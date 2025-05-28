using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace assignmentDraft1
{
    public partial class TeacherWebform : System.Web.UI.Page
    {
        private int lecturerId;

        protected void Page_Load(object sender, EventArgs e)
        {
            // Check if user is logged in
            if (Session["email"] == null)
            {
                Response.Redirect("loginWebform.aspx");
                return;
            }

            // Load lecturer info on every page load
            LoadLecturerInfo();

            if (!IsPostBack)
            {
                LoadDashboardData();
                LoadCourses();
                LoadRecentAssignments();
            }
        }

        private void LoadLecturerInfo()
        {
            string email = Session["email"].ToString();
            string cs = ConfigurationManager.ConnectionStrings["dbConnection"].ConnectionString;

            using (SqlConnection con = new SqlConnection(cs))
            {
                con.Open();

                // First check if user is a lecturer
                SqlCommand userCmd = new SqlCommand("SELECT UserID, Name, Role FROM Users WHERE Username = @Email", con);
                userCmd.Parameters.AddWithValue("@Email", email);

                SqlDataReader userReader = userCmd.ExecuteReader();
                if (userReader.Read())
                {
                    string role = userReader["Role"].ToString();
                    if (role != "Lecturer")
                    {
                        userReader.Close();
                        Response.Redirect("homeWebform.aspx"); // Redirect non-lecturers
                        return;
                    }

                    lblName.Text = userReader["Name"].ToString();
                    lblRole.Text = role;
                    lblSidebarName.Text = userReader["Name"].ToString();
                    lblSidebarRole.Text = role;
                }
                userReader.Close();

                // Get lecturer ID from Lecturers table
                SqlCommand lecCmd = new SqlCommand("SELECT LecturerID FROM Lecturers WHERE Email = @Email", con);
                lecCmd.Parameters.AddWithValue("@Email", email);

                object lecIdObj = lecCmd.ExecuteScalar();
                if (lecIdObj != null)
                {
                    lecturerId = Convert.ToInt32(lecIdObj);
                }
                else
                {
                    ShowMessage("Lecturer profile not found. Please contact administrator.", "red");
                }
            }
        }

        private void LoadDashboardData()
        {
            string cs = ConfigurationManager.ConnectionStrings["dbConnection"].ConnectionString;
            using (SqlConnection con = new SqlConnection(cs))
            {
                con.Open();

                // Get active courses count
                SqlCommand coursesCmd = new SqlCommand("SELECT COUNT(*) FROM Modules WHERE LecturerID = @LecturerID", con);
                coursesCmd.Parameters.AddWithValue("@LecturerID", lecturerId);
                int activeCourses = (int)coursesCmd.ExecuteScalar();
                lblActiveCourses.Text = activeCourses.ToString();

                // Get total students count (enrolled in lecturer's courses)
                SqlCommand studentsCmd = new SqlCommand(@"
                    SELECT COUNT(DISTINCT uc.UserID) 
                    FROM UserCourses uc
                    JOIN Modules m ON uc.CourseID = m.CourseID
                    WHERE m.LecturerID = @LecturerID", con);
                studentsCmd.Parameters.AddWithValue("@LecturerID", lecturerId);
                int totalStudents = (int)studentsCmd.ExecuteScalar();
                lblTotalStudents.Text = totalStudents.ToString();

                // Get active assignments count
                SqlCommand assignmentsCmd = new SqlCommand(@"
                    SELECT COUNT(*) 
                    FROM Assignments a
                    JOIN Modules m ON a.ModuleID = m.ModuleID
                    WHERE m.LecturerID = @LecturerID AND a.IsActive = 1", con);
                assignmentsCmd.Parameters.AddWithValue("@LecturerID", lecturerId);
                int activeAssignments = (int)assignmentsCmd.ExecuteScalar();
                lblActiveAssignments.Text = activeAssignments.ToString();

                // Calculate completion rate (submitted assignments / total assignments)
                SqlCommand completionCmd = new SqlCommand(@"
                    SELECT 
                        COUNT(DISTINCT s.AssignmentID) as CompletedAssignments,
                        COUNT(DISTINCT a.AssignmentID) as TotalAssignments
                    FROM Assignments a
                    JOIN Modules m ON a.ModuleID = m.ModuleID
                    LEFT JOIN AssignmentSubmissions s ON a.AssignmentID = s.AssignmentID AND s.Status = 'Submitted'
                    WHERE m.LecturerID = @LecturerID AND a.IsActive = 1", con);
                completionCmd.Parameters.AddWithValue("@LecturerID", lecturerId);

                SqlDataReader completionReader = completionCmd.ExecuteReader();
                if (completionReader.Read())
                {
                    int completed = Convert.ToInt32(completionReader["CompletedAssignments"]);
                    int total = Convert.ToInt32(completionReader["TotalAssignments"]);
                    double completionRate = total > 0 ? (double)completed / total * 100 : 0;
                    lblCompletionRate.Text = $"{completionRate:F0}%";
                }
                completionReader.Close();
            }
        }

        private void LoadCourses()
        {
            string cs = ConfigurationManager.ConnectionStrings["dbConnection"].ConnectionString;
            using (SqlConnection con = new SqlConnection(cs))
            {
                con.Open();

                SqlCommand cmd = new SqlCommand(@"
                    SELECT 
                        c.CourseID,
                        c.CourseName,
                        c.Description,
                        c.Category
                    FROM Courses c
                    JOIN Modules m ON c.CourseID = m.CourseID
                    WHERE m.LecturerID = @LecturerID
                    ORDER BY c.CourseName", con);
                cmd.Parameters.AddWithValue("@LecturerID", lecturerId);

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

        private void LoadRecentAssignments()
        {
            string cs = ConfigurationManager.ConnectionStrings["dbConnection"].ConnectionString;
            using (SqlConnection con = new SqlConnection(cs))
            {
                con.Open();

                SqlCommand cmd = new SqlCommand(@"
                    SELECT TOP 5
                        a.AssignmentID,
                        a.Title,
                        a.DueDate,
                        c.CourseName,
                        ISNULL(SubmissionStats.TotalSubmissions, 0) AS TotalSubmissions,
                        ISNULL(StudentCount.MaxStudents, 0) AS MaxStudents
                    FROM Assignments a
                    JOIN Modules m ON a.ModuleID = m.ModuleID
                    JOIN Courses c ON m.CourseID = c.CourseID
                    LEFT JOIN (
                        SELECT 
                            AssignmentID,
                            COUNT(*) AS TotalSubmissions
                        FROM AssignmentSubmissions
                        WHERE Status = 'Submitted'
                        GROUP BY AssignmentID
                    ) SubmissionStats ON a.AssignmentID = SubmissionStats.AssignmentID
                    LEFT JOIN (
                        SELECT 
                            m.ModuleID,
                            COUNT(DISTINCT uc.UserID) AS MaxStudents
                        FROM Modules m
                        JOIN UserCourses uc ON m.CourseID = uc.CourseID
                        GROUP BY m.ModuleID
                    ) StudentCount ON m.ModuleID = StudentCount.ModuleID
                    WHERE m.LecturerID = @LecturerID AND a.IsActive = 1
                    ORDER BY a.CreatedDate DESC", con);
                cmd.Parameters.AddWithValue("@LecturerID", lecturerId);

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);

                if (dt.Rows.Count > 0)
                {
                    assignmentRepeater.DataSource = dt;
                    assignmentRepeater.DataBind();
                    pnlNoAssignments.Visible = false;
                }
                else
                {
                    assignmentRepeater.DataSource = null;
                    assignmentRepeater.DataBind();
                    pnlNoAssignments.Visible = true;
                }
            }
        }

        protected void BtnSearch_Click(object sender, EventArgs e)
        {
            string query = txtSearch.Text.Trim();
            if (!string.IsNullOrEmpty(query))
            {
                Response.Redirect("searchResults.aspx?query=" + Server.UrlEncode(query));
            }
        }

        protected void BtnEditCourse_Click(object sender, EventArgs e)
        {
            LinkButton btn = (LinkButton)sender;
            int courseId = Convert.ToInt32(btn.CommandArgument);
            LoadCourseForEdit(courseId);
        }

        protected void BtnDeleteCourse_Click(object sender, EventArgs e)
        {
            LinkButton btn = (LinkButton)sender;
            int courseId = Convert.ToInt32(btn.CommandArgument);
            DeleteCourse(courseId);
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
                    hfCourseID.Value = reader["CourseID"].ToString();
                    txtCourseName.Text = reader["CourseName"].ToString();
                    txtCourseDescription.Text = reader["Description"]?.ToString() ?? "";
                    txtCategory.Text = reader["Category"]?.ToString() ?? "";

                    // Open modal via JavaScript
                    ClientScript.RegisterStartupScript(this.GetType(), "openEditModal",
                        $"openEditCourseModal({courseId}, '{reader["CourseName"]}', '{reader["Description"]}', '{reader["Category"]}');", true);
                }
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

                    // Check if course has any assignments or students enrolled
                    SqlCommand checkCmd = new SqlCommand(@"
                        SELECT 
                            (SELECT COUNT(*) FROM Assignments a 
                             JOIN Modules m ON a.ModuleID = m.ModuleID 
                             WHERE m.CourseID = @CourseID) as AssignmentCount,
                            (SELECT COUNT(*) FROM UserCourses WHERE CourseID = @CourseID) as StudentCount", con);
                    checkCmd.Parameters.AddWithValue("@CourseID", courseId);

                    SqlDataReader checkReader = checkCmd.ExecuteReader();
                    if (checkReader.Read())
                    {
                        int assignmentCount = Convert.ToInt32(checkReader["AssignmentCount"]);
                        int studentCount = Convert.ToInt32(checkReader["StudentCount"]);

                        if (assignmentCount > 0 || studentCount > 0)
                        {
                            checkReader.Close();
                            ShowMessage("Cannot delete course. It has assignments or enrolled students.", "red");
                            return;
                        }
                    }
                    checkReader.Close();

                    // Delete associated modules first
                    SqlCommand deleteModulesCmd = new SqlCommand("DELETE FROM Modules WHERE CourseID = @CourseID AND LecturerID = @LecturerID", con);
                    deleteModulesCmd.Parameters.AddWithValue("@CourseID", courseId);
                    deleteModulesCmd.Parameters.AddWithValue("@LecturerID", lecturerId);
                    deleteModulesCmd.ExecuteNonQuery();

                    // Delete the course
                    SqlCommand deleteCourseCmd = new SqlCommand("DELETE FROM Courses WHERE CourseID = @CourseID", con);
                    deleteCourseCmd.Parameters.AddWithValue("@CourseID", courseId);
                    int rowsAffected = deleteCourseCmd.ExecuteNonQuery();

                    if (rowsAffected > 0)
                    {
                        ShowMessage("Course deleted successfully!", "green");
                        LoadCourses();
                        LoadDashboardData();
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

        protected void BtnSaveCourse_Click(object sender, EventArgs e)
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
                        SqlCommand getIdCmd = new SqlCommand("SELECT ISNULL(MAX(CourseID), 0) + 1 FROM Courses", con);
                        int newCourseId = (int)getIdCmd.ExecuteScalar();

                        SqlCommand insertCourseCmd = new SqlCommand(@"
                            INSERT INTO Courses (CourseID, CourseName, Description, Category)
                            VALUES (@CourseID, @CourseName, @Description, @Category)", con);

                        insertCourseCmd.Parameters.AddWithValue("@CourseID", newCourseId);
                        insertCourseCmd.Parameters.AddWithValue("@CourseName", txtCourseName.Text.Trim());
                        insertCourseCmd.Parameters.AddWithValue("@Description", txtCourseDescription.Text.Trim());
                        insertCourseCmd.Parameters.AddWithValue("@Category", txtCategory.Text.Trim());

                        insertCourseCmd.ExecuteNonQuery();

                        // Create a default module for this course
                        SqlCommand getModuleIdCmd = new SqlCommand("SELECT ISNULL(MAX(ModuleID), 0) + 1 FROM Modules", con);
                        int newModuleId = (int)getModuleIdCmd.ExecuteScalar();

                        SqlCommand insertModuleCmd = new SqlCommand(@"
                            INSERT INTO Modules (ModuleID, CourseID, Title, Description, ModuleOrder, LecturerID)
                            VALUES (@ModuleID, @CourseID, @Title, @Description, @ModuleOrder, @LecturerID)", con);

                        insertModuleCmd.Parameters.AddWithValue("@ModuleID", newModuleId);
                        insertModuleCmd.Parameters.AddWithValue("@CourseID", newCourseId);
                        insertModuleCmd.Parameters.AddWithValue("@Title", txtCourseName.Text.Trim() + " - Main Module");
                        insertModuleCmd.Parameters.AddWithValue("@Description", "Main module for " + txtCourseName.Text.Trim());
                        insertModuleCmd.Parameters.AddWithValue("@ModuleOrder", 1);
                        insertModuleCmd.Parameters.AddWithValue("@LecturerID", lecturerId);

                        insertModuleCmd.ExecuteNonQuery();

                        ShowMessage("Course created successfully!", "green");
                    }
                    else
                    {
                        // Update existing course
                        SqlCommand updateCmd = new SqlCommand(@"
                            UPDATE Courses 
                            SET CourseName = @CourseName, Description = @Description, Category = @Category
                            WHERE CourseID = @CourseID", con);

                        updateCmd.Parameters.AddWithValue("@CourseID", hfCourseID.Value);
                        updateCmd.Parameters.AddWithValue("@CourseName", txtCourseName.Text.Trim());
                        updateCmd.Parameters.AddWithValue("@Description", txtCourseDescription.Text.Trim());
                        updateCmd.Parameters.AddWithValue("@Category", txtCategory.Text.Trim());

                        updateCmd.ExecuteNonQuery();

                        ShowMessage("Course updated successfully!", "green");
                    }

                    // Clear form and reload
                    ClearCourseForm();
                    LoadCourses();
                    LoadDashboardData();

                    // Close modal via JavaScript
                    ClientScript.RegisterStartupScript(this.GetType(), "closeModal", "closeCourseModal();", true);
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

            if (string.IsNullOrWhiteSpace(txtCourseDescription.Text))
            {
                ShowMessage("Please enter course description.", "red");
                return false;
            }

            if (string.IsNullOrWhiteSpace(txtCategory.Text))
            {
                ShowMessage("Please enter course category.", "red");
                return false;
            }

            // Check if course name already exists (for new courses or different course during edit)
            string cs = ConfigurationManager.ConnectionStrings["dbConnection"].ConnectionString;
            using (SqlConnection con = new SqlConnection(cs))
            {
                con.Open();
                string query = "SELECT COUNT(*) FROM Courses WHERE CourseName = @CourseName";

                if (!string.IsNullOrEmpty(hfCourseID.Value))
                {
                    query += " AND CourseID != @CourseID";
                }

                SqlCommand cmd = new SqlCommand(query, con);
                cmd.Parameters.AddWithValue("@CourseName", txtCourseName.Text.Trim());

                if (!string.IsNullOrEmpty(hfCourseID.Value))
                {
                    cmd.Parameters.AddWithValue("@CourseID", hfCourseID.Value);
                }

                int count = (int)cmd.ExecuteScalar();
                if (count > 0)
                {
                    ShowMessage("A course with this name already exists.", "red");
                    return false;
                }
            }

            return true;
        }

        private void ClearCourseForm()
        {
            hfCourseID.Value = "";
            txtCourseName.Text = "";
            txtCourseDescription.Text = "";
            txtCategory.Text = "";
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