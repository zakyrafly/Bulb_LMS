using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace assignmentDraft1
{
    public partial class profile : System.Web.UI.Page
    {
        private int userId;
        private string userRole;

        protected void Page_Load(object sender, EventArgs e)
        {
            // Check if user is logged in
            if (Session["email"] == null)
            {
                Response.Redirect("loginWebform.aspx");
                return;
            }

            // FIXED: Always load user ID and role to ensure they're available on postbacks
            LoadUserIdentity();

            if (!IsPostBack)
            {
                LoadUserProfile();
                LoadRoleSpecificData();
                LoadRecentActivity();
                // ADDED: Update password requirements display on initial load
                UpdatePasswordRequirementsDisplay();
            }
        }

        // FIXED: Separate method to load user identity on every page load
        private void LoadUserIdentity()
        {
            string email = Session["email"].ToString();
            string cs = ConfigurationManager.ConnectionStrings["dbConnection"].ConnectionString;

            using (SqlConnection con = new SqlConnection(cs))
            {
                con.Open();

                SqlCommand cmd = new SqlCommand(@"
                    SELECT UserID, Role
                    FROM Users 
                    WHERE username = @Email", con);
                cmd.Parameters.AddWithValue("@Email", email);

                SqlDataReader reader = cmd.ExecuteReader();
                if (reader.Read())
                {
                    userId = Convert.ToInt32(reader["UserID"]);
                    userRole = reader["Role"].ToString();
                }
                else
                {
                    ShowMessage("User not found.", "red");
                    Response.Redirect("loginWebform.aspx");
                }
            }
        }

        private void LoadUserProfile()
        {
            string email = Session["email"].ToString();
            string cs = ConfigurationManager.ConnectionStrings["dbConnection"].ConnectionString;

            using (SqlConnection con = new SqlConnection(cs))
            {
                con.Open();

                SqlCommand cmd = new SqlCommand(@"
                    SELECT UserID, Name, username, Role, ContactInfo
                    FROM Users 
                    WHERE username = @Email", con);
                cmd.Parameters.AddWithValue("@Email", email);

                SqlDataReader reader = cmd.ExecuteReader();
                if (reader.Read())
                {
                    userId = Convert.ToInt32(reader["UserID"]);
                    userRole = reader["Role"].ToString();

                    // Header and sidebar
                    lblHeaderName.Text = reader["Name"].ToString();
                    lblHeaderRole.Text = userRole;
                    lblSidebarName.Text = reader["Name"].ToString();
                    lblSidebarRole.Text = userRole;

                    // Profile header
                    lblProfileName.Text = reader["Name"].ToString();
                    lblProfileEmail.Text = reader["username"].ToString();
                    lblProfileRole.Text = userRole;
                    lblMemberSince.Text = DateTime.Now.AddMonths(-6).ToString("MMMM yyyy"); // Mock data

                    // Profile information
                    lblFullName.Text = reader["Name"].ToString();
                    lblEmail.Text = reader["username"].ToString();
                    lblRole.Text = userRole;
                    lblContactInfo.Text = reader["ContactInfo"] != DBNull.Value ?
                                         reader["ContactInfo"].ToString() : "Not provided";

                    // Set edit form initial values
                    txtEditName.Text = reader["Name"].ToString();
                    txtEditContact.Text = reader["ContactInfo"] != DBNull.Value ?
                                         reader["ContactInfo"].ToString() : "";
                }
                else
                {
                    ShowMessage("User profile not found.", "red");
                    Response.Redirect("loginWebform.aspx");
                }
            }
        }

        private void LoadRoleSpecificData()
        {
            switch (userRole)
            {
                case "Student":
                    LoadStudentData();
                    lblRoleSpecificTitle.Text = "Academic Progress";
                    pnlStudentInfo.Visible = true;
                    break;
                case "Lecturer":
                    LoadLecturerData();
                    lblRoleSpecificTitle.Text = "Teaching Overview";
                    pnlLecturerInfo.Visible = true;
                    break;
                case "Admin":
                    LoadAdminData();
                    lblRoleSpecificTitle.Text = "System Overview";
                    pnlAdminInfo.Visible = true;
                    break;
            }
        }

        private void LoadStudentData()
        {
            string cs = ConfigurationManager.ConnectionStrings["dbConnection"].ConnectionString;
            using (SqlConnection con = new SqlConnection(cs))
            {
                con.Open();

                // Get assignment statistics
                SqlCommand assignmentStatsCmd = new SqlCommand(@"
                    SELECT 
                        COUNT(DISTINCT A.AssignmentID) AS TotalAssignments,
                        COUNT(DISTINCT S.SubmissionID) AS CompletedAssignments,
                        AVG(CASE WHEN G.PointsEarned IS NOT NULL THEN 
                            (CAST(G.PointsEarned AS FLOAT) / CAST(A.MaxPoints AS FLOAT) * 100) 
                            ELSE NULL END) AS AverageGrade
                    FROM UserCourses UC
                    JOIN Modules M ON UC.CourseID = M.CourseID
                    JOIN Assignments A ON M.ModuleID = A.ModuleID
                    LEFT JOIN AssignmentSubmissions S ON A.AssignmentID = S.AssignmentID AND UC.UserID = S.UserID AND S.Status = 'Submitted'
                    LEFT JOIN AssignmentGrades G ON S.SubmissionID = G.SubmissionID
                    WHERE UC.UserID = @UserID AND A.IsActive = 1", con);
                assignmentStatsCmd.Parameters.AddWithValue("@UserID", userId);

                SqlDataReader statsReader = assignmentStatsCmd.ExecuteReader();
                if (statsReader.Read())
                {
                    lblAssignmentCount.Text = statsReader["TotalAssignments"] != DBNull.Value ?
                                            statsReader["TotalAssignments"].ToString() : "0";
                    lblCompletedCount.Text = statsReader["CompletedAssignments"] != DBNull.Value ?
                                           statsReader["CompletedAssignments"].ToString() : "0";

                    double avgGrade = statsReader["AverageGrade"] != DBNull.Value ?
                                    Convert.ToDouble(statsReader["AverageGrade"]) : 0;
                    lblAverageGrade.Text = avgGrade.ToString("F1") + "%";
                }
                statsReader.Close();

                // Get enrolled courses
                SqlCommand coursesCmd = new SqlCommand(@"
                    SELECT 
                        C.CourseName, 
                        C.Description,
                        COUNT(M.ModuleID) AS ModuleCount
                    FROM UserCourses UC
                    JOIN Courses C ON UC.CourseID = C.CourseID
                    LEFT JOIN Modules M ON C.CourseID = M.CourseID
                    WHERE UC.UserID = @UserID
                    GROUP BY C.CourseID, C.CourseName, C.Description", con);
                coursesCmd.Parameters.AddWithValue("@UserID", userId);

                SqlDataAdapter coursesDa = new SqlDataAdapter(coursesCmd);
                DataTable coursesDt = new DataTable();
                coursesDa.Fill(coursesDt);

                studentCoursesRepeater.DataSource = coursesDt;
                studentCoursesRepeater.DataBind();
            }
        }

        private void LoadLecturerData()
        {
            string cs = ConfigurationManager.ConnectionStrings["dbConnection"].ConnectionString;
            using (SqlConnection con = new SqlConnection(cs))
            {
                con.Open();

                // Get lecturer statistics
                SqlCommand lecturerStatsCmd = new SqlCommand(@"
                    SELECT 
                        COUNT(DISTINCT M.ModuleID) AS ModuleCount,
                        COUNT(DISTINCT UC.UserID) AS StudentCount,
                        COUNT(DISTINCT A.AssignmentID) AS AssignmentCount
                    FROM Lecturers L
                    JOIN Modules M ON L.LecturerID = M.LecturerID
                    JOIN Courses C ON M.CourseID = C.CourseID
                    LEFT JOIN UserCourses UC ON C.CourseID = UC.CourseID
                    LEFT JOIN Assignments A ON M.ModuleID = A.ModuleID AND A.IsActive = 1
                    WHERE L.Email = @Email", con);
                lecturerStatsCmd.Parameters.AddWithValue("@Email", Session["email"].ToString());

                SqlDataReader lecturerStatsReader = lecturerStatsCmd.ExecuteReader();
                if (lecturerStatsReader.Read())
                {
                    lblModuleCount.Text = lecturerStatsReader["ModuleCount"] != DBNull.Value ?
                                        lecturerStatsReader["ModuleCount"].ToString() : "0";
                    lblStudentCount.Text = lecturerStatsReader["StudentCount"] != DBNull.Value ?
                                         lecturerStatsReader["StudentCount"].ToString() : "0";
                    lblCreatedAssignments.Text = lecturerStatsReader["AssignmentCount"] != DBNull.Value ?
                                                lecturerStatsReader["AssignmentCount"].ToString() : "0";
                }
                lecturerStatsReader.Close();

                // Get teaching modules
                SqlCommand modulesCmd = new SqlCommand(@"
                    SELECT 
                        M.Title AS ModuleTitle,
                        M.Description,
                        C.CourseName,
                        COUNT(A.AssignmentID) AS AssignmentCount
                    FROM Lecturers L
                    JOIN Modules M ON L.LecturerID = M.LecturerID
                    JOIN Courses C ON M.CourseID = C.CourseID
                    LEFT JOIN Assignments A ON M.ModuleID = A.ModuleID AND A.IsActive = 1
                    WHERE L.Email = @Email
                    GROUP BY M.ModuleID, M.Title, M.Description, C.CourseName", con);
                modulesCmd.Parameters.AddWithValue("@Email", Session["email"].ToString());

                SqlDataAdapter modulesDa = new SqlDataAdapter(modulesCmd);
                DataTable modulesDt = new DataTable();
                modulesDa.Fill(modulesDt);

                lecturerModulesRepeater.DataSource = modulesDt;
                lecturerModulesRepeater.DataBind();
            }
        }

        private void LoadAdminData()
        {
            string cs = ConfigurationManager.ConnectionStrings["dbConnection"].ConnectionString;
            using (SqlConnection con = new SqlConnection(cs))
            {
                con.Open();

                // Get system statistics
                SqlCommand totalUsersCmd = new SqlCommand("SELECT COUNT(*) FROM Users", con);
                lblTotalUsers.Text = totalUsersCmd.ExecuteScalar().ToString();

                SqlCommand totalCoursesCmd = new SqlCommand("SELECT COUNT(*) FROM Courses", con);
                lblTotalCourses.Text = totalCoursesCmd.ExecuteScalar().ToString();

                lblSystemHealth.Text = "99%"; // Mock data
            }
        }

        private void LoadRecentActivity()
        {
            // Create mock activity data based on user role
            DataTable activityData = new DataTable();
            activityData.Columns.Add("ActivityType");
            activityData.Columns.Add("ActivityTitle");
            activityData.Columns.Add("ActivityDescription");
            activityData.Columns.Add("ActivityTime", typeof(DateTime));

            switch (userRole)
            {
                case "Student":
                    LoadStudentActivity(activityData);
                    break;
                case "Lecturer":
                    LoadLecturerActivity(activityData);
                    break;
                case "Admin":
                    LoadAdminActivity(activityData);
                    break;
            }

            if (activityData.Rows.Count > 0)
            {
                activityRepeater.DataSource = activityData;
                activityRepeater.DataBind();
                pnlNoActivity.Visible = false;
            }
            else
            {
                activityRepeater.DataSource = null;
                activityRepeater.DataBind();
                pnlNoActivity.Visible = true;
            }
        }

        private void LoadStudentActivity(DataTable activityData)
        {
            string cs = ConfigurationManager.ConnectionStrings["dbConnection"].ConnectionString;
            using (SqlConnection con = new SqlConnection(cs))
            {
                con.Open();

                // Get recent submissions
                SqlCommand recentSubmissionsCmd = new SqlCommand(@"
                    SELECT TOP 3
                        A.Title,
                        S.SubmissionDate,
                        CASE WHEN G.PointsEarned IS NOT NULL THEN 'Graded' ELSE 'Submitted' END AS Status,
                        G.PointsEarned,
                        A.MaxPoints
                    FROM AssignmentSubmissions S
                    JOIN Assignments A ON S.AssignmentID = A.AssignmentID
                    LEFT JOIN AssignmentGrades G ON S.SubmissionID = G.SubmissionID
                    WHERE S.UserID = @UserID AND S.Status = 'Submitted'
                    ORDER BY S.SubmissionDate DESC", con);
                recentSubmissionsCmd.Parameters.AddWithValue("@UserID", userId);

                SqlDataReader submissionReader = recentSubmissionsCmd.ExecuteReader();
                while (submissionReader.Read())
                {
                    DataRow row = activityData.NewRow();

                    if (submissionReader["PointsEarned"] != DBNull.Value)
                    {
                        row["ActivityType"] = "grade";
                        row["ActivityTitle"] = "Assignment Graded";
                        row["ActivityDescription"] = $"Received grade for '{submissionReader["Title"]}' - {submissionReader["PointsEarned"]}/{submissionReader["MaxPoints"]} points";
                    }
                    else
                    {
                        row["ActivityType"] = "assignment";
                        row["ActivityTitle"] = "Assignment Submitted";
                        row["ActivityDescription"] = $"Submitted assignment: {submissionReader["Title"]}";
                    }

                    row["ActivityTime"] = Convert.ToDateTime(submissionReader["SubmissionDate"]);
                    activityData.Rows.Add(row);
                }
                submissionReader.Close();
            }

            // Add login activity
            activityData.Rows.Add("login", "Profile Updated", "Updated profile information", DateTime.Now.AddHours(-1));
        }

        private void LoadLecturerActivity(DataTable activityData)
        {
            // Mock lecturer activities
            activityData.Rows.Add("assignment", "Assignment Created", "Created new assignment 'Final Project'", DateTime.Now.AddHours(-2));
            activityData.Rows.Add("grade", "Grades Submitted", "Graded 15 assignments", DateTime.Now.AddHours(-5));
            activityData.Rows.Add("course", "Module Updated", "Updated course materials", DateTime.Now.AddDays(-1));
            activityData.Rows.Add("login", "Login", "Logged into the system", DateTime.Now.AddHours(-1));
        }

        private void LoadAdminActivity(DataTable activityData)
        {
            // Mock admin activities
            activityData.Rows.Add("course", "System Maintenance", "Performed database optimization", DateTime.Now.AddHours(-2));
            activityData.Rows.Add("assignment", "User Management", "Added 5 new users to the system", DateTime.Now.AddHours(-4));
            activityData.Rows.Add("grade", "Reports Generated", "Generated monthly performance reports", DateTime.Now.AddDays(-1));
            activityData.Rows.Add("login", "Admin Login", "Accessed admin dashboard", DateTime.Now.AddMinutes(-30));
        }

        protected void btnEditProfile_Click(object sender, EventArgs e)
        {
            profileView.Visible = false;
            profileEdit.Visible = true;
            // FIXED: Use Attributes["class"] instead of CssClass for HtmlGenericControl
            profileEdit.Attributes["class"] = "edit-form active";
        }

        protected void btnSaveProfile_Click(object sender, EventArgs e)
        {
            if (string.IsNullOrWhiteSpace(txtEditName.Text))
            {
                ShowMessage("Please enter your name.", "red");
                return;
            }

            string cs = ConfigurationManager.ConnectionStrings["dbConnection"].ConnectionString;
            using (SqlConnection con = new SqlConnection(cs))
            {
                try
                {
                    con.Open();

                    SqlCommand updateCmd = new SqlCommand(@"
                        UPDATE Users 
                        SET Name = @Name, ContactInfo = @ContactInfo
                        WHERE UserID = @UserID", con);
                    updateCmd.Parameters.AddWithValue("@UserID", userId);
                    updateCmd.Parameters.AddWithValue("@Name", txtEditName.Text.Trim());
                    updateCmd.Parameters.AddWithValue("@ContactInfo",
                        string.IsNullOrWhiteSpace(txtEditContact.Text) ? (object)DBNull.Value : txtEditContact.Text.Trim());

                    updateCmd.ExecuteNonQuery();

                    ShowMessage("Profile updated successfully!", "green");

                    // Refresh the display
                    LoadUserProfile();
                    profileView.Visible = true;
                    profileEdit.Visible = false;
                    // FIXED: Use Attributes["class"] instead of CssClass
                    profileEdit.Attributes["class"] = "edit-form";
                }
                catch (Exception ex)
                {
                    ShowMessage("Error updating profile: " + ex.Message, "red");
                }
            }
        }

        protected void btnCancelEdit_Click(object sender, EventArgs e)
        {
            profileView.Visible = true;
            profileEdit.Visible = false;
            // FIXED: Use Attributes["class"] instead of CssClass
            profileEdit.Attributes["class"] = "edit-form";

            // Reset form values
            LoadUserProfile();
        }

        protected void btnChangePassword_Click(object sender, EventArgs e)
        {
            passwordView.Visible = false;
            passwordEdit.Visible = true;
            // FIXED: Use Attributes["class"] instead of CssClass
            passwordEdit.Attributes["class"] = "edit-form active";

            // ADDED: Update password requirements display with current admin setting
            UpdatePasswordRequirementsDisplay();
        }

        protected void btnSavePassword_Click(object sender, EventArgs e)
        {
            if (string.IsNullOrWhiteSpace(txtCurrentPassword.Text) ||
                string.IsNullOrWhiteSpace(txtNewPassword.Text) ||
                string.IsNullOrWhiteSpace(txtConfirmPassword.Text))
            {
                ShowMessage("Please fill in all password fields.", "red");
                return;
            }

            if (txtNewPassword.Text != txtConfirmPassword.Text)
            {
                ShowMessage("New passwords do not match.", "red");
                return;
            }

            if (txtNewPassword.Text.Length < 6)
            {
                ShowMessage("Password must be at least 6 characters long.", "red");
                return;
            }

            string cs = ConfigurationManager.ConnectionStrings["dbConnection"].ConnectionString;
            using (SqlConnection con = new SqlConnection(cs))
            {
                try
                {
                    con.Open();

                    // Verify current password
                    SqlCommand verifyCmd = new SqlCommand("SELECT password FROM Users WHERE UserID = @UserID", con);
                    verifyCmd.Parameters.AddWithValue("@UserID", userId);
                    string currentPassword = verifyCmd.ExecuteScalar()?.ToString();

                    if (currentPassword != txtCurrentPassword.Text.Trim())
                    {
                        ShowMessage("Current password is incorrect.", "red");
                        return;
                    }

                    // Update password
                    SqlCommand updateCmd = new SqlCommand("UPDATE Users SET password = @NewPassword WHERE UserID = @UserID", con);
                    updateCmd.Parameters.AddWithValue("@UserID", userId);
                    updateCmd.Parameters.AddWithValue("@NewPassword", txtNewPassword.Text.Trim());

                    updateCmd.ExecuteNonQuery();

                    ShowMessage("Password updated successfully!", "green");

                    // Clear form and hide
                    txtCurrentPassword.Text = "";
                    txtNewPassword.Text = "";
                    txtConfirmPassword.Text = "";

                    passwordView.Visible = true;
                    passwordEdit.Visible = false;
                    // FIXED: Use Attributes["class"] instead of CssClass
                    passwordEdit.Attributes["class"] = "edit-form";
                }
                catch (Exception ex)
                {
                    ShowMessage("Error updating password: " + ex.Message, "red");
                }
            }
        }

        protected void btnCancelPassword_Click(object sender, EventArgs e)
        {
            txtCurrentPassword.Text = "";
            txtNewPassword.Text = "";
            txtConfirmPassword.Text = "";

            passwordView.Visible = true;
            passwordEdit.Visible = false;
            // FIXED: Use Attributes["class"] instead of CssClass
            passwordEdit.Attributes["class"] = "edit-form";
        }

        protected void btnSearch_Click(object sender, EventArgs e)
        {
            string query = txtSearch.Text.Trim();
            if (!string.IsNullOrEmpty(query))
            {
                Response.Redirect("searchResults.aspx?query=" + Server.UrlEncode(query));
            }
        }

        // ADDED: Method to update password requirements display with current admin setting
        private void UpdatePasswordRequirementsDisplay()
        {
            int minLength = GetPasswordMinLength();

            // Find the password requirements div and update it
            // This would be easier with a server control, but we can use JavaScript injection
            string script = $@"
                var reqDiv = document.querySelector('.password-requirements');
                if (reqDiv) {{
                    reqDiv.innerHTML = '<strong>Password Requirements:</strong><br>• At least {minLength} characters long<br>• Use a strong, unique password';
                }}";

            ClientScript.RegisterStartupScript(this.GetType(), "updatePasswordReq", script, true);
        }

        // ADDED: Method to get password minimum length from admin settings
        private int GetPasswordMinLength()
        {
            try
            {
                string cs = ConfigurationManager.ConnectionStrings["dbConnection"].ConnectionString;
                using (SqlConnection con = new SqlConnection(cs))
                {
                    con.Open();

                    SqlCommand cmd = new SqlCommand("SELECT SettingValue FROM SystemSettings WHERE SettingName = 'PasswordMinLength'", con);
                    object result = cmd.ExecuteScalar();

                    if (result != null && int.TryParse(result.ToString(), out int minLength))
                    {
                        return minLength;
                    }
                }
            }
            catch
            {
                // If there's any error, fall back to default
            }

            // Default fallback
            return 6;
        }

        // FIXED: Make it public for data binding access
        public string GetActivityIcon(object activityType)
        {
            if (activityType == null) return "fa-info";

            string type = activityType.ToString().ToLower();
            switch (type)
            {
                case "assignment": return "fa-tasks";
                case "grade": return "fa-star";
                case "course": return "fa-graduation-cap";
                case "login": return "fa-sign-in-alt";
                default: return "fa-info";
            }
        }

        private void ShowMessage(string message, string color)
        {
            lblMessage.Text = message;

            switch (color.ToLower())
            {
                case "green":
                    lblMessage.ForeColor = System.Drawing.Color.Green;
                    break;
                case "red":
                    lblMessage.ForeColor = System.Drawing.Color.Red;
                    break;
                case "blue":
                    lblMessage.ForeColor = System.Drawing.Color.Blue;
                    break;
                default:
                    lblMessage.ForeColor = System.Drawing.Color.Black;
                    break;
            }

            lblMessage.Visible = true;

            // Hide message after 5 seconds
            ClientScript.RegisterStartupScript(this.GetType(), "hideMessage",
                "setTimeout(function(){ document.getElementById('" + lblMessage.ClientID + "').style.display = 'none'; }, 5000);", true);
        }
    }
}