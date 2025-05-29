using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace assignmentDraft1
{
    public partial class manageUsers : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // Check if user is logged in and is admin
            if (Session["email"] == null)
            {
                Response.Redirect("loginWebform.aspx");
                return;
            }

            // Load admin info on every page load
            LoadAdminInfo();

            if (!IsPostBack)
            {
                LoadUserStatistics();
                LoadCourses(); // Load courses for the dropdown
                LoadUsers();
            }
        }

        private void LoadAdminInfo()
        {
            string email = Session["email"].ToString();
            string cs = ConfigurationManager.ConnectionStrings["dbConnection"].ConnectionString;

            using (SqlConnection con = new SqlConnection(cs))
            {
                con.Open();

                // Check if user is admin
                SqlCommand userCmd = new SqlCommand("SELECT UserID, Name, Role FROM Users WHERE username = @Email", con);
                userCmd.Parameters.AddWithValue("@Email", email);

                SqlDataReader userReader = userCmd.ExecuteReader();
                if (userReader.Read())
                {
                    string role = userReader["Role"].ToString();
                    if (role != "Admin")
                    {
                        userReader.Close();
                        Response.Redirect("loginWebform.aspx"); // Redirect non-admins
                        return;
                    }

                    lblName.Text = userReader["Name"].ToString();
                    lblRole.Text = role;
                    lblSidebarName.Text = userReader["Name"].ToString();
                    lblSidebarRole.Text = role;
                }
                else
                {
                    Response.Redirect("loginWebform.aspx");
                }
            }
        }

        private void LoadUserStatistics()
        {
            string cs = ConfigurationManager.ConnectionStrings["dbConnection"].ConnectionString;
            using (SqlConnection con = new SqlConnection(cs))
            {
                con.Open();

                // Get total users count
                SqlCommand totalCmd = new SqlCommand("SELECT COUNT(*) FROM Users WHERE UserID IS NOT NULL", con);
                int totalUsers = (int)totalCmd.ExecuteScalar();
                lblTotalUsers.Text = totalUsers.ToString();

                // Get active users count (assuming all non-null users are active)
                SqlCommand activeCmd = new SqlCommand("SELECT COUNT(*) FROM Users WHERE UserID IS NOT NULL", con);
                int activeUsers = (int)activeCmd.ExecuteScalar();
                lblActiveUsers.Text = activeUsers.ToString();

                // Get students count
                SqlCommand studentCmd = new SqlCommand("SELECT COUNT(*) FROM Users WHERE Role = 'Student'", con);
                int studentCount = (int)studentCmd.ExecuteScalar();
                lblStudentCount.Text = studentCount.ToString();

                // Get lecturers count
                SqlCommand lecturerCmd = new SqlCommand("SELECT COUNT(*) FROM Users WHERE Role = 'Lecturer'", con);
                int lecturerCount = (int)lecturerCmd.ExecuteScalar();
                lblLecturerCount.Text = lecturerCount.ToString();
            }
        }

        private void LoadCourses()
        {
            string cs = ConfigurationManager.ConnectionStrings["dbConnection"].ConnectionString;
            using (SqlConnection con = new SqlConnection(cs))
            {
                con.Open();
                SqlCommand cmd = new SqlCommand("SELECT CourseID, CourseName FROM Courses ORDER BY CourseName", con);
                SqlDataReader reader = cmd.ExecuteReader();

                ddlCourse.Items.Clear();
                ddlCourse.Items.Add(new ListItem("-- Select Course --", ""));

                while (reader.Read())
                {
                    ddlCourse.Items.Add(new ListItem(reader["CourseName"].ToString(), reader["CourseID"].ToString()));
                }
            }
        }

        private void LoadUsers()
        {
            string cs = ConfigurationManager.ConnectionStrings["dbConnection"].ConnectionString;
            using (SqlConnection con = new SqlConnection(cs))
            {
                con.Open();

                // Build dynamic query based on filters
                string query = @"
                    SELECT 
                        UserID, Name, username, Role, ContactInfo
                    FROM Users 
                    WHERE UserID IS NOT NULL";

                // Add search filter
                if (!string.IsNullOrEmpty(txtSearch.Text.Trim()))
                {
                    query += " AND (Name LIKE @SearchTerm OR username LIKE @SearchTerm)";
                }

                // Add role filter
                if (!string.IsNullOrEmpty(ddlRoleFilter.SelectedValue))
                {
                    query += " AND Role = @RoleFilter";
                }

                query += " ORDER BY UserID DESC";

                SqlCommand cmd = new SqlCommand(query, con);

                // Add parameters
                if (!string.IsNullOrEmpty(txtSearch.Text.Trim()))
                {
                    cmd.Parameters.AddWithValue("@SearchTerm", "%" + txtSearch.Text.Trim() + "%");
                }

                if (!string.IsNullOrEmpty(ddlRoleFilter.SelectedValue))
                {
                    cmd.Parameters.AddWithValue("@RoleFilter", ddlRoleFilter.SelectedValue);
                }

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);

                // Add computed columns for display
                dt.Columns.Add("IsActive", typeof(bool));
                dt.Columns.Add("CreatedDate", typeof(DateTime));
                dt.Columns.Add("LastLogin", typeof(DateTime));

                // Set default values for new columns
                foreach (DataRow row in dt.Rows)
                {
                    row["IsActive"] = true; // Assume all users are active
                    row["CreatedDate"] = DateTime.Now.AddDays(-30); // Default to 30 days ago
                    row["LastLogin"] = DBNull.Value; // No last login data
                }

                if (dt.Rows.Count > 0)
                {
                    userRepeater.DataSource = dt;
                    userRepeater.DataBind();
                    lblDisplayCount.Text = dt.Rows.Count.ToString();
                    pnlNoUsers.Visible = false;
                }
                else
                {
                    userRepeater.DataSource = null;
                    userRepeater.DataBind();
                    lblDisplayCount.Text = "0";
                    pnlNoUsers.Visible = true;
                }
            }
        }

        protected void ddlRoleFilter_SelectedIndexChanged(object sender, EventArgs e)
        {
            LoadUsers();
        }

        protected void ddlStatusFilter_SelectedIndexChanged(object sender, EventArgs e)
        {
            // Since we don't have IsActive column, this filter won't work
            // We'll just reload users for now
            LoadUsers();
        }

        protected void btnSearch_Click(object sender, EventArgs e)
        {
            LoadUsers();
        }

        protected void btnHeaderSearch_Click(object sender, EventArgs e)
        {
            txtSearch.Text = txtHeaderSearch.Text.Trim();
            LoadUsers();
        }

        protected void btnSaveUser_Click(object sender, EventArgs e)
        {
            if (!ValidateUserForm())
                return;

            string cs = ConfigurationManager.ConnectionStrings["dbConnection"].ConnectionString;
            using (SqlConnection con = new SqlConnection(cs))
            {
                try
                {
                    con.Open();

                    if (string.IsNullOrEmpty(hfUserID.Value))
                    {
                        // Add new user
                        if (UserExists(txtEmail.Text.Trim(), con))
                        {
                            ShowMessage("A user with this email already exists.", "red");
                            return;
                        }

                        SqlCommand getIdCmd = new SqlCommand("SELECT ISNULL(MAX(UserID), 0) + 1 FROM Users", con);
                        int newUserId = (int)getIdCmd.ExecuteScalar();

                        SqlCommand insertCmd = new SqlCommand(@"
                            INSERT INTO Users (UserID, Name, username, password, Role, ContactInfo)
                            VALUES (@UserID, @Name, @Username, @Password, @Role, @ContactInfo)", con);

                        insertCmd.Parameters.AddWithValue("@UserID", newUserId);
                        insertCmd.Parameters.AddWithValue("@Name", txtFullName.Text.Trim());
                        insertCmd.Parameters.AddWithValue("@Username", txtEmail.Text.Trim());
                        insertCmd.Parameters.AddWithValue("@Password", txtPassword.Text.Trim()); // In production, hash the password
                        insertCmd.Parameters.AddWithValue("@Role", ddlRole.SelectedValue);
                        insertCmd.Parameters.AddWithValue("@ContactInfo", string.IsNullOrWhiteSpace(txtContactInfo.Text) ? (object)DBNull.Value : txtContactInfo.Text.Trim());

                        insertCmd.ExecuteNonQuery();

                        // Create lecturer record if role is Lecturer
                        if (ddlRole.SelectedValue == "Lecturer")
                        {
                            CreateLecturerRecord(newUserId, txtFullName.Text.Trim(), txtEmail.Text.Trim(), con);

                            // Create modules for the selected course if course is selected
                            if (!string.IsNullOrEmpty(ddlCourse.SelectedValue))
                            {
                                CreateLecturerModules(Convert.ToInt32(ddlCourse.SelectedValue), txtEmail.Text.Trim(), con);
                            }
                        }

                        // Create course enrollment if role is Student
                        if (ddlRole.SelectedValue == "Student" && !string.IsNullOrEmpty(ddlCourse.SelectedValue))
                        {
                            CreateStudentEnrollment(newUserId, Convert.ToInt32(ddlCourse.SelectedValue), con);
                        }

                        ShowMessage("User created successfully!", "green");
                    }
                    else
                    {
                        // Update existing user
                        int userId = Convert.ToInt32(hfUserID.Value);

                        if (UserExists(txtEmail.Text.Trim(), con, userId))
                        {
                            ShowMessage("Another user with this email already exists.", "red");
                            return;
                        }

                        string updateQuery = @"
                            UPDATE Users 
                            SET Name = @Name, username = @Username, Role = @Role, ContactInfo = @ContactInfo";

                        // Only update password if provided
                        if (!string.IsNullOrEmpty(txtPassword.Text.Trim()))
                        {
                            updateQuery += ", password = @Password";
                        }

                        updateQuery += " WHERE UserID = @UserID";

                        SqlCommand updateCmd = new SqlCommand(updateQuery, con);
                        updateCmd.Parameters.AddWithValue("@UserID", userId);
                        updateCmd.Parameters.AddWithValue("@Name", txtFullName.Text.Trim());
                        updateCmd.Parameters.AddWithValue("@Username", txtEmail.Text.Trim());
                        updateCmd.Parameters.AddWithValue("@Role", ddlRole.SelectedValue);
                        updateCmd.Parameters.AddWithValue("@ContactInfo", string.IsNullOrWhiteSpace(txtContactInfo.Text) ? (object)DBNull.Value : txtContactInfo.Text.Trim());

                        if (!string.IsNullOrEmpty(txtPassword.Text.Trim()))
                        {
                            updateCmd.Parameters.AddWithValue("@Password", txtPassword.Text.Trim());
                        }

                        updateCmd.ExecuteNonQuery();

                        // Handle role-specific updates
                        string oldRole = GetUserRole(userId, con);

                        // Handle lecturer record
                        if (ddlRole.SelectedValue == "Lecturer")
                        {
                            EnsureLecturerRecord(userId, txtFullName.Text.Trim(), txtEmail.Text.Trim(), con);

                            // Create modules for the selected course if course is selected and it's a new lecturer
                            if (!string.IsNullOrEmpty(ddlCourse.SelectedValue) && oldRole != "Lecturer")
                            {
                                CreateLecturerModules(Convert.ToInt32(ddlCourse.SelectedValue), txtEmail.Text.Trim(), con);
                            }
                        }
                        else
                        {
                            RemoveLecturerRecord(userId, con);
                        }

                        // Handle student enrollment
                        if (ddlRole.SelectedValue == "Student" && !string.IsNullOrEmpty(ddlCourse.SelectedValue))
                        {
                            // Remove old enrollment
                            RemoveStudentEnrollment(userId, con);
                            // Add new enrollment
                            CreateStudentEnrollment(userId, Convert.ToInt32(ddlCourse.SelectedValue), con);
                        }
                        else if (ddlRole.SelectedValue != "Student")
                        {
                            // Remove enrollment if no longer a student
                            RemoveStudentEnrollment(userId, con);
                        }

                        ShowMessage("User updated successfully!", "green");
                    }

                    // Clear form and reload
                    ClearUserForm();
                    LoadUsers();
                    LoadUserStatistics();

                    // Close modal via JavaScript
                    ClientScript.RegisterStartupScript(this.GetType(), "closeModal", "closeUserModal();", true);
                }
                catch (Exception ex)
                {
                    ShowMessage("Error: " + ex.Message, "red");
                }
            }
        }

        protected void userRepeater_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            int userId = Convert.ToInt32(e.CommandArgument);

            switch (e.CommandName)
            {
                case "Edit":
                    LoadUserForEdit(userId);
                    break;
                case "Delete":
                    DeleteUser(userId);
                    break;
                case "ToggleStatus":
                    ToggleUserStatus(userId);
                    break;
            }
        }

        private void LoadUserForEdit(int userId)
        {
            string cs = ConfigurationManager.ConnectionStrings["dbConnection"].ConnectionString;
            using (SqlConnection con = new SqlConnection(cs))
            {
                con.Open();

                SqlCommand cmd = new SqlCommand(@"
                    SELECT U.UserID, U.Name, U.username, U.Role, U.ContactInfo,
                           UC.CourseID, C.CourseName
                    FROM Users U
                    LEFT JOIN UserCourses UC ON U.UserID = UC.UserID
                    LEFT JOIN Courses C ON UC.CourseID = C.CourseID
                    WHERE U.UserID = @UserID", con);
                cmd.Parameters.AddWithValue("@UserID", userId);

                SqlDataReader reader = cmd.ExecuteReader();
                if (reader.Read())
                {
                    string courseId = reader["CourseID"]?.ToString() ?? "";
                    string contactInfo = reader["ContactInfo"]?.ToString() ?? "";

                    // Open modal via JavaScript with user data
                    string script = $@"
                        openEditUserModal(
                            {reader["UserID"]}, 
                            '{reader["Name"].ToString().Replace("'", "\\'")}', 
                            '{reader["username"].ToString().Replace("'", "\\'")}', 
                            '{reader["Role"]}', 
                            'True'
                        );
                        
                        // Set contact info and course
                        document.getElementById('{txtContactInfo.ClientID}').value = '{contactInfo.Replace("'", "\\'")}';
                        if ('{courseId}' !== '') {{
                            document.getElementById('{ddlCourse.ClientID}').value = '{courseId}';
                        }}
                        ";

                    ClientScript.RegisterStartupScript(this.GetType(), "openEditModal", script, true);
                }
            }
        }

        private void DeleteUser(int userId)
        {
            string cs = ConfigurationManager.ConnectionStrings["dbConnection"].ConnectionString;
            using (SqlConnection con = new SqlConnection(cs))
            {
                try
                {
                    con.Open();

                    // Check if user has dependencies (enrollments, assignments, etc.)
                    if (HasUserDependencies(userId, con))
                    {
                        ShowMessage("Cannot delete user. User has associated data (courses, assignments, etc.).", "red");
                        return;
                    }

                    // Delete lecturer record if exists
                    SqlCommand deleteLecCmd = new SqlCommand("DELETE FROM Lecturers WHERE Email = (SELECT username FROM Users WHERE UserID = @UserID)", con);
                    deleteLecCmd.Parameters.AddWithValue("@UserID", userId);
                    deleteLecCmd.ExecuteNonQuery();

                    // Delete user enrollments
                    SqlCommand deleteEnrollCmd = new SqlCommand("DELETE FROM UserCourses WHERE UserID = @UserID", con);
                    deleteEnrollCmd.Parameters.AddWithValue("@UserID", userId);
                    deleteEnrollCmd.ExecuteNonQuery();

                    // Delete user
                    SqlCommand deleteCmd = new SqlCommand("DELETE FROM Users WHERE UserID = @UserID", con);
                    deleteCmd.Parameters.AddWithValue("@UserID", userId);
                    int rowsAffected = deleteCmd.ExecuteNonQuery();

                    if (rowsAffected > 0)
                    {
                        ShowMessage("User deleted successfully!", "green");
                        LoadUsers();
                        LoadUserStatistics();
                    }
                    else
                    {
                        ShowMessage("Error deleting user.", "red");
                    }
                }
                catch (Exception ex)
                {
                    ShowMessage("Error: " + ex.Message, "red");
                }
            }
        }

        private void ToggleUserStatus(int userId)
        {
            // Since we don't have IsActive column, we'll show a message instead
            ShowMessage("User status toggle is not available - no IsActive column in database.", "red");
        }

        private bool ValidateUserForm()
        {
            if (string.IsNullOrWhiteSpace(txtFullName.Text))
            {
                ShowMessage("Please enter full name.", "red");
                return false;
            }

            if (string.IsNullOrWhiteSpace(txtEmail.Text))
            {
                ShowMessage("Please enter email address.", "red");
                return false;
            }

            if (string.IsNullOrEmpty(ddlRole.SelectedValue))
            {
                ShowMessage("Please select a role.", "red");
                return false;
            }

            // Course validation for students and lecturers
            if ((ddlRole.SelectedValue == "Student" || ddlRole.SelectedValue == "Lecturer") && string.IsNullOrEmpty(ddlCourse.SelectedValue))
            {
                string message = ddlRole.SelectedValue == "Student" ? "Please select a course for the student." : "Please select a course for the lecturer to teach.";
                ShowMessage(message, "red");
                return false;
            }

            // Password validation for new users
            if (string.IsNullOrEmpty(hfUserID.Value))
            {
                if (string.IsNullOrWhiteSpace(txtPassword.Text))
                {
                    ShowMessage("Please enter password.", "red");
                    return false;
                }

                if (txtPassword.Text.Trim() != txtConfirmPassword.Text.Trim())
                {
                    ShowMessage("Passwords do not match.", "red");
                    return false;
                }
            }
            else
            {
                // For existing users, only validate if password is provided
                if (!string.IsNullOrEmpty(txtPassword.Text.Trim()) && txtPassword.Text.Trim() != txtConfirmPassword.Text.Trim())
                {
                    ShowMessage("Passwords do not match.", "red");
                    return false;
                }
            }

            return true;
        }

        private bool UserExists(string email, SqlConnection con, int excludeUserId = 0)
        {
            string query = "SELECT COUNT(*) FROM Users WHERE username = @Email";
            if (excludeUserId > 0)
            {
                query += " AND UserID != @ExcludeUserID";
            }

            SqlCommand cmd = new SqlCommand(query, con);
            cmd.Parameters.AddWithValue("@Email", email);
            if (excludeUserId > 0)
            {
                cmd.Parameters.AddWithValue("@ExcludeUserID", excludeUserId);
            }

            return (int)cmd.ExecuteScalar() > 0;
        }

        private bool HasUserDependencies(int userId, SqlConnection con)
        {
            // Check for assignment submissions
            SqlCommand submissionCmd = new SqlCommand("SELECT COUNT(*) FROM AssignmentSubmissions WHERE UserID = @UserID", con);
            submissionCmd.Parameters.AddWithValue("@UserID", userId);
            if ((int)submissionCmd.ExecuteScalar() > 0) return true;

            // Check for lecturer assignments
            SqlCommand lecturerCmd = new SqlCommand(@"
                SELECT COUNT(*) FROM Modules M 
                JOIN Lecturers L ON M.LecturerID = L.LecturerID 
                JOIN Users U ON L.Email = U.username 
                WHERE U.UserID = @UserID", con);
            lecturerCmd.Parameters.AddWithValue("@UserID", userId);
            if ((int)lecturerCmd.ExecuteScalar() > 0) return true;

            return false;
        }

        private void CreateLecturerRecord(int userId, string name, string email, SqlConnection con)
        {
            // Check if lecturer record already exists
            SqlCommand checkCmd = new SqlCommand("SELECT COUNT(*) FROM Lecturers WHERE Email = @Email", con);
            checkCmd.Parameters.AddWithValue("@Email", email);

            if ((int)checkCmd.ExecuteScalar() == 0)
            {
                SqlCommand insertCmd = new SqlCommand(@"
                    INSERT INTO Lecturers (FullName, Email)
                    VALUES (@FullName, @Email)", con);

                insertCmd.Parameters.AddWithValue("@FullName", name);
                insertCmd.Parameters.AddWithValue("@Email", email);

                insertCmd.ExecuteNonQuery();
            }
        }

        private void EnsureLecturerRecord(int userId, string name, string email, SqlConnection con)
        {
            // Update or create lecturer record
            SqlCommand checkCmd = new SqlCommand("SELECT COUNT(*) FROM Lecturers WHERE Email = @Email", con);
            checkCmd.Parameters.AddWithValue("@Email", email);

            if ((int)checkCmd.ExecuteScalar() > 0)
            {
                // Update existing record
                SqlCommand updateCmd = new SqlCommand("UPDATE Lecturers SET FullName = @FullName WHERE Email = @Email", con);
                updateCmd.Parameters.AddWithValue("@FullName", name);
                updateCmd.Parameters.AddWithValue("@Email", email);
                updateCmd.ExecuteNonQuery();
            }
            else
            {
                // Create new record
                CreateLecturerRecord(userId, name, email, con);
            }
        }

        private void RemoveLecturerRecord(int userId, SqlConnection con)
        {
            // Get user email first
            SqlCommand getUserCmd = new SqlCommand("SELECT username FROM Users WHERE UserID = @UserID", con);
            getUserCmd.Parameters.AddWithValue("@UserID", userId);
            string email = getUserCmd.ExecuteScalar()?.ToString();

            if (!string.IsNullOrEmpty(email))
            {
                // Check if lecturer has any modules assigned
                SqlCommand checkModulesCmd = new SqlCommand(@"
                    SELECT COUNT(*) FROM Modules M 
                    JOIN Lecturers L ON M.LecturerID = L.LecturerID 
                    WHERE L.Email = @Email", con);
                checkModulesCmd.Parameters.AddWithValue("@Email", email);

                if ((int)checkModulesCmd.ExecuteScalar() == 0)
                {
                    // Safe to delete lecturer record
                    SqlCommand deleteCmd = new SqlCommand("DELETE FROM Lecturers WHERE Email = @Email", con);
                    deleteCmd.Parameters.AddWithValue("@Email", email);
                    deleteCmd.ExecuteNonQuery();
                }
            }
        }

        private string GetUserRole(int userId, SqlConnection con)
        {
            SqlCommand cmd = new SqlCommand("SELECT Role FROM Users WHERE UserID = @UserID", con);
            cmd.Parameters.AddWithValue("@UserID", userId);
            return cmd.ExecuteScalar()?.ToString() ?? "";
        }

        private void CreateStudentEnrollment(int userId, int courseId, SqlConnection con)
        {
            // Check if enrollment already exists
            SqlCommand checkCmd = new SqlCommand("SELECT COUNT(*) FROM UserCourses WHERE UserID = @UserID AND CourseID = @CourseID", con);
            checkCmd.Parameters.AddWithValue("@UserID", userId);
            checkCmd.Parameters.AddWithValue("@CourseID", courseId);

            if ((int)checkCmd.ExecuteScalar() == 0)
            {
                SqlCommand getIdCmd = new SqlCommand("SELECT ISNULL(MAX(UserCourseID), 0) + 1 FROM UserCourses", con);
                int newUserCourseId = (int)getIdCmd.ExecuteScalar();

                SqlCommand insertCmd = new SqlCommand(@"
                    INSERT INTO UserCourses (UserCourseID, UserID, CourseID)
                    VALUES (@UserCourseID, @UserID, @CourseID)", con);

                insertCmd.Parameters.AddWithValue("@UserCourseID", newUserCourseId);
                insertCmd.Parameters.AddWithValue("@UserID", userId);
                insertCmd.Parameters.AddWithValue("@CourseID", courseId);

                insertCmd.ExecuteNonQuery();
            }
        }

        private void RemoveStudentEnrollment(int userId, SqlConnection con)
        {
            SqlCommand deleteCmd = new SqlCommand("DELETE FROM UserCourses WHERE UserID = @UserID", con);
            deleteCmd.Parameters.AddWithValue("@UserID", userId);
            deleteCmd.ExecuteNonQuery();
        }

        private void CreateLecturerModules(int courseId, string lecturerEmail, SqlConnection con)
        {
            // Get lecturer ID
            SqlCommand getLecIdCmd = new SqlCommand("SELECT LecturerID FROM Lecturers WHERE Email = @Email", con);
            getLecIdCmd.Parameters.AddWithValue("@Email", lecturerEmail);
            object lecIdObj = getLecIdCmd.ExecuteScalar();

            if (lecIdObj != null)
            {
                int lecturerId = Convert.ToInt32(lecIdObj);

                string[] moduleNames = { "Introduction Module", "Core Concepts", "Advanced Topics" };
                string[] moduleDescriptions = {
                    "Basic introduction and overview",
                    "Core concepts and fundamentals",
                    "Advanced topics and applications"
                };

                for (int i = 0; i < moduleNames.Length; i++)
                {
                    SqlCommand insertModuleCmd = new SqlCommand(@"
                        INSERT INTO Modules (CourseID, Title, Description, ModuleOrder, LecturerID) 
                        VALUES (@courseId, @title, @description, @moduleOrder, @lecturerId)", con);

                    insertModuleCmd.Parameters.AddWithValue("@courseId", courseId);
                    insertModuleCmd.Parameters.AddWithValue("@title", moduleNames[i]);
                    insertModuleCmd.Parameters.AddWithValue("@description", moduleDescriptions[i]);
                    insertModuleCmd.Parameters.AddWithValue("@moduleOrder", i + 1);
                    insertModuleCmd.Parameters.AddWithValue("@lecturerId", lecturerId);

                    insertModuleCmd.ExecuteNonQuery();
                }
            }
        }

        private void ClearUserForm()
        {
            hfUserID.Value = "";
            txtFullName.Text = "";
            txtEmail.Text = "";
            txtPassword.Text = "";
            txtConfirmPassword.Text = "";
            txtContactInfo.Text = "";
            ddlRole.SelectedIndex = 0;
            ddlCourse.SelectedIndex = 0;
        }

        private void ShowMessage(string message, string color)
        {
            lblMessage.Text = message;
            lblMessage.ForeColor = color == "green" ? System.Drawing.Color.Green : System.Drawing.Color.Red;
            lblMessage.Visible = true;

            // Hide message after 5 seconds
            ClientScript.RegisterStartupScript(this.GetType(), "hideMessage",
                "setTimeout(function(){ document.getElementById('" + lblMessage.ClientID + "').style.display = 'none'; }, 5000);", true);
        }
    }
}