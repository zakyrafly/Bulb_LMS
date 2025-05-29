using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace assignmentDraft1
{
    public partial class manageCourses : System.Web.UI.Page
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
                LoadCourseStatistics();
                LoadCategories();
                LoadCourses();
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

        private void LoadCourseStatistics()
        {
            string cs = ConfigurationManager.ConnectionStrings["dbConnection"].ConnectionString;
            using (SqlConnection con = new SqlConnection(cs))
            {
                con.Open();

                // Get total courses count
                SqlCommand totalCoursesCmd = new SqlCommand("SELECT COUNT(*) FROM Courses", con);
                int totalCourses = (int)totalCoursesCmd.ExecuteScalar();
                lblTotalCourses.Text = totalCourses.ToString();

                // Get total enrolled students count
                SqlCommand totalStudentsCmd = new SqlCommand("SELECT COUNT(DISTINCT UserID) FROM UserCourses", con);
                int totalStudents = (int)totalStudentsCmd.ExecuteScalar();
                lblTotalStudents.Text = totalStudents.ToString();

                // Get total modules count
                SqlCommand totalModulesCmd = new SqlCommand("SELECT COUNT(*) FROM Modules", con);
                int totalModules = (int)totalModulesCmd.ExecuteScalar();
                lblTotalModules.Text = totalModules.ToString();

                // Get active lecturers count (lecturers who have modules)
                SqlCommand activeLecturersCmd = new SqlCommand(@"
                    SELECT COUNT(DISTINCT LecturerID) FROM Modules WHERE LecturerID IS NOT NULL", con);
                int activeLecturers = (int)activeLecturersCmd.ExecuteScalar();
                lblActiveLecturers.Text = activeLecturers.ToString();
            }
        }

        private void LoadCategories()
        {
            string cs = ConfigurationManager.ConnectionStrings["dbConnection"].ConnectionString;
            using (SqlConnection con = new SqlConnection(cs))
            {
                con.Open();
                SqlCommand cmd = new SqlCommand("SELECT DISTINCT Category FROM Courses WHERE Category IS NOT NULL ORDER BY Category", con);
                SqlDataReader reader = cmd.ExecuteReader();

                ddlCategoryFilter.Items.Clear();
                ddlCategoryFilter.Items.Add(new ListItem("All Categories", ""));

                while (reader.Read())
                {
                    if (!string.IsNullOrWhiteSpace(reader["Category"].ToString()))
                    {
                        ddlCategoryFilter.Items.Add(new ListItem(reader["Category"].ToString(), reader["Category"].ToString()));
                    }
                }
            }
        }

        private void LoadCourses()
        {
            string cs = ConfigurationManager.ConnectionStrings["dbConnection"].ConnectionString;
            using (SqlConnection con = new SqlConnection(cs))
            {
                con.Open();

                // Build dynamic query with statistics
                string query = @"
                    SELECT 
                        C.CourseID,
                        C.CourseName,
                        C.Description,
                        C.Category,
                        ISNULL(StudentStats.StudentCount, 0) AS StudentCount,
                        ISNULL(ModuleStats.ModuleCount, 0) AS ModuleCount,
                        ISNULL(AssignmentStats.AssignmentCount, 0) AS AssignmentCount
                    FROM Courses C
                    LEFT JOIN (
                        SELECT CourseID, COUNT(*) AS StudentCount
                        FROM UserCourses
                        GROUP BY CourseID
                    ) StudentStats ON C.CourseID = StudentStats.CourseID
                    LEFT JOIN (
                        SELECT CourseID, COUNT(*) AS ModuleCount
                        FROM Modules
                        GROUP BY CourseID
                    ) ModuleStats ON C.CourseID = ModuleStats.CourseID
                    LEFT JOIN (
                        SELECT M.CourseID, COUNT(A.AssignmentID) AS AssignmentCount
                        FROM Modules M
                        LEFT JOIN Assignments A ON M.ModuleID = A.ModuleID AND A.IsActive = 1
                        GROUP BY M.CourseID
                    ) AssignmentStats ON C.CourseID = AssignmentStats.CourseID
                    WHERE 1=1";

                // Add search filter
                if (!string.IsNullOrEmpty(txtSearch.Text.Trim()))
                {
                    query += " AND (C.CourseName LIKE @SearchTerm OR C.Description LIKE @SearchTerm)";
                }

                // Add category filter
                if (!string.IsNullOrEmpty(ddlCategoryFilter.SelectedValue))
                {
                    query += " AND C.Category = @CategoryFilter";
                }

                query += " ORDER BY C.CourseName";

                SqlCommand cmd = new SqlCommand(query, con);

                // Add parameters
                if (!string.IsNullOrEmpty(txtSearch.Text.Trim()))
                {
                    cmd.Parameters.AddWithValue("@SearchTerm", "%" + txtSearch.Text.Trim() + "%");
                }

                if (!string.IsNullOrEmpty(ddlCategoryFilter.SelectedValue))
                {
                    cmd.Parameters.AddWithValue("@CategoryFilter", ddlCategoryFilter.SelectedValue);
                }

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);

                if (dt.Rows.Count > 0)
                {
                    courseRepeater.DataSource = dt;
                    courseRepeater.DataBind();
                    pnlNoCourses.Visible = false;
                }
                else
                {
                    courseRepeater.DataSource = null;
                    courseRepeater.DataBind();
                    pnlNoCourses.Visible = true;
                }
            }
        }

        protected void ddlCategoryFilter_SelectedIndexChanged(object sender, EventArgs e)
        {
            LoadCourses();
        }

        protected void btnSearch_Click(object sender, EventArgs e)
        {
            LoadCourses();
        }

        protected void btnHeaderSearch_Click(object sender, EventArgs e)
        {
            txtSearch.Text = txtHeaderSearch.Text.Trim();
            LoadCourses();
        }

        protected void btnSaveCourse_Click(object sender, EventArgs e)
        {
            if (!ValidateCourseForm())
                return;

            string cs = ConfigurationManager.ConnectionStrings["dbConnection"].ConnectionString;
            using (SqlConnection con = new SqlConnection(cs))
            {
                try
                {
                    con.Open();

                    if (string.IsNullOrEmpty(hfCourseID.Value))
                    {
                        // Add new course
                        if (CourseExists(txtCourseName.Text.Trim(), con))
                        {
                            ShowMessage("A course with this name already exists.", "red");
                            return;
                        }

                        SqlCommand getIdCmd = new SqlCommand("SELECT ISNULL(MAX(CourseID), 0) + 1 FROM Courses", con);
                        int newCourseId = (int)getIdCmd.ExecuteScalar();

                        SqlCommand insertCmd = new SqlCommand(@"
                            INSERT INTO Courses (CourseID, CourseName, Description, Category)
                            VALUES (@CourseID, @CourseName, @Description, @Category)", con);

                        insertCmd.Parameters.AddWithValue("@CourseID", newCourseId);
                        insertCmd.Parameters.AddWithValue("@CourseName", txtCourseName.Text.Trim());
                        insertCmd.Parameters.AddWithValue("@Description", txtDescription.Text.Trim());
                        insertCmd.Parameters.AddWithValue("@Category", string.IsNullOrWhiteSpace(txtCategory.Text) ? (object)DBNull.Value : txtCategory.Text.Trim());

                        insertCmd.ExecuteNonQuery();

                        ShowMessage("Course created successfully!", "green");
                    }
                    else
                    {
                        // Update existing course
                        int courseId = Convert.ToInt32(hfCourseID.Value);

                        if (CourseExists(txtCourseName.Text.Trim(), con, courseId))
                        {
                            ShowMessage("Another course with this name already exists.", "red");
                            return;
                        }

                        SqlCommand updateCmd = new SqlCommand(@"
                            UPDATE Courses 
                            SET CourseName = @CourseName, Description = @Description, Category = @Category
                            WHERE CourseID = @CourseID", con);

                        updateCmd.Parameters.AddWithValue("@CourseID", courseId);
                        updateCmd.Parameters.AddWithValue("@CourseName", txtCourseName.Text.Trim());
                        updateCmd.Parameters.AddWithValue("@Description", txtDescription.Text.Trim());
                        updateCmd.Parameters.AddWithValue("@Category", string.IsNullOrWhiteSpace(txtCategory.Text) ? (object)DBNull.Value : txtCategory.Text.Trim());

                        updateCmd.ExecuteNonQuery();

                        ShowMessage("Course updated successfully!", "green");
                    }

                    // Clear form and reload
                    ClearCourseForm();
                    LoadCourses();
                    LoadCourseStatistics();
                    LoadCategories(); // Refresh categories in case new one was added

                    // Close modal via JavaScript
                    ClientScript.RegisterStartupScript(this.GetType(), "closeModal", "closeCourseModal();", true);
                }
                catch (Exception ex)
                {
                    ShowMessage("Error: " + ex.Message, "red");
                }
            }
        }

        protected void courseRepeater_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            int courseId = Convert.ToInt32(e.CommandArgument);

            switch (e.CommandName)
            {
                case "Edit":
                    LoadCourseForEdit(courseId);
                    break;
                case "Delete":
                    DeleteCourse(courseId);
                    break;
                case "ViewDetails":
                    LoadCourseDetails(courseId);
                    break;
            }
        }

        private void LoadCourseForEdit(int courseId)
        {
            string cs = ConfigurationManager.ConnectionStrings["dbConnection"].ConnectionString;
            using (SqlConnection con = new SqlConnection(cs))
            {
                con.Open();

                SqlCommand cmd = new SqlCommand(@"
                    SELECT CourseID, CourseName, Description, Category
                    FROM Courses 
                    WHERE CourseID = @CourseID", con);
                cmd.Parameters.AddWithValue("@CourseID", courseId);

                SqlDataReader reader = cmd.ExecuteReader();
                if (reader.Read())
                {
                    string courseName = reader["CourseName"].ToString();
                    string category = reader["Category"]?.ToString() ?? "";
                    string description = reader["Description"]?.ToString() ?? "";

                    // Open modal via JavaScript with course data
                    string script = $@"
                        openEditCourseModal(
                            {courseId}, 
                            '{courseName.Replace("'", "\\'")}', 
                            '{category.Replace("'", "\\'")}', 
                            '{description.Replace("'", "\\'")}', 
                            '',
                            ''
                        );";

                    ClientScript.RegisterStartupScript(this.GetType(), "openEditModal", script, true);
                }
            }
        }

        private void LoadCourseDetails(int courseId)
        {
            string cs = ConfigurationManager.ConnectionStrings["dbConnection"].ConnectionString;
            using (SqlConnection con = new SqlConnection(cs))
            {
                con.Open();

                // Load enrolled students
                SqlCommand cmd = new SqlCommand(@"
                    SELECT U.UserID, U.Name, U.username, UC.EnrollmentDate
                    FROM UserCourses UC
                    JOIN Users U ON UC.UserID = U.UserID
                    WHERE UC.CourseID = @CourseID
                    ORDER BY U.Name", con);
                cmd.Parameters.AddWithValue("@CourseID", courseId);

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);

                if (dt.Rows.Count > 0)
                {
                    enrollmentRepeater.DataSource = dt;
                    enrollmentRepeater.DataBind();
                    lblEnrolledCount.Text = dt.Rows.Count.ToString();
                    pnlNoEnrollments.Visible = false;
                }
                else
                {
                    enrollmentRepeater.DataSource = null;
                    enrollmentRepeater.DataBind();
                    lblEnrolledCount.Text = "0";
                    pnlNoEnrollments.Visible = true;
                }

                // Open details modal via JavaScript
                ClientScript.RegisterStartupScript(this.GetType(), "openDetailsModal",
                    "document.getElementById('detailsModal').style.display = 'block';", true);
            }
        }

        private void DeleteCourse(int courseId)
        {
            string cs = ConfigurationManager.ConnectionStrings["dbConnection"].ConnectionString;
            using (SqlConnection con = new SqlConnection(cs))
            {
                try
                {
                    con.Open();

                    // Check if course has dependencies
                    if (HasCourseDependencies(courseId, con))
                    {
                        ShowMessage("Cannot delete course. Students are enrolled or assignments exist.", "red");
                        return;
                    }

                    // Delete modules first (cascade delete)
                    SqlCommand deleteModulesCmd = new SqlCommand("DELETE FROM Modules WHERE CourseID = @CourseID", con);
                    deleteModulesCmd.Parameters.AddWithValue("@CourseID", courseId);
                    deleteModulesCmd.ExecuteNonQuery();

                    // Delete course
                    SqlCommand deleteCourseCmd = new SqlCommand("DELETE FROM Courses WHERE CourseID = @CourseID", con);
                    deleteCourseCmd.Parameters.AddWithValue("@CourseID", courseId);
                    int rowsAffected = deleteCourseCmd.ExecuteNonQuery();

                    if (rowsAffected > 0)
                    {
                        ShowMessage("Course deleted successfully!", "green");
                        LoadCourses();
                        LoadCourseStatistics();
                        LoadCategories();
                    }
                    else
                    {
                        ShowMessage("Error deleting course.", "red");
                    }
                }
                catch (Exception ex)
                {
                    ShowMessage("Error: " + ex.Message, "red");
                }
            }
        }

        private bool ValidateCourseForm()
        {
            if (string.IsNullOrWhiteSpace(txtCourseName.Text))
            {
                ShowMessage("Please enter course name.", "red");
                return false;
            }

            if (string.IsNullOrWhiteSpace(txtDescription.Text))
            {
                ShowMessage("Please enter course description.", "red");
                return false;
            }

            if (string.IsNullOrWhiteSpace(txtCategory.Text))
            {
                ShowMessage("Please enter course category.", "red");
                return false;
            }

            return true;
        }

        private bool CourseExists(string courseName, SqlConnection con, int excludeCourseId = 0)
        {
            string query = "SELECT COUNT(*) FROM Courses WHERE CourseName = @CourseName";
            if (excludeCourseId > 0)
            {
                query += " AND CourseID != @ExcludeCourseID";
            }

            SqlCommand cmd = new SqlCommand(query, con);
            cmd.Parameters.AddWithValue("@CourseName", courseName);
            if (excludeCourseId > 0)
            {
                cmd.Parameters.AddWithValue("@ExcludeCourseID", excludeCourseId);
            }

            return (int)cmd.ExecuteScalar() > 0;
        }

        private bool HasCourseDependencies(int courseId, SqlConnection con)
        {
            // Check for student enrollments
            SqlCommand enrollmentCmd = new SqlCommand("SELECT COUNT(*) FROM UserCourses WHERE CourseID = @CourseID", con);
            enrollmentCmd.Parameters.AddWithValue("@CourseID", courseId);
            if ((int)enrollmentCmd.ExecuteScalar() > 0) return true;

            // Check for assignments in modules
            SqlCommand assignmentCmd = new SqlCommand(@"
                SELECT COUNT(*) FROM Assignments A 
                JOIN Modules M ON A.ModuleID = M.ModuleID 
                WHERE M.CourseID = @CourseID", con);
            assignmentCmd.Parameters.AddWithValue("@CourseID", courseId);
            if ((int)assignmentCmd.ExecuteScalar() > 0) return true;

            return false;
        }

        private void ClearCourseForm()
        {
            hfCourseID.Value = "";
            txtCourseName.Text = "";
            txtCategory.Text = "";
            txtDescription.Text = "";
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