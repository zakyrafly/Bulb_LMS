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

            // Handle confirmation-based deletions
            HandlePostBackEvents();
        }

        private void HandlePostBackEvents()
        {
            string eventTarget = Request.Form["__EVENTTARGET"];
            string eventArgument = Request.Form["__EVENTARGUMENT"];

            if (!string.IsNullOrEmpty(eventArgument) && eventArgument.StartsWith("deleteCourse_"))
            {
                string courseIdStr = eventArgument.Substring("deleteCourse_".Length);
                if (int.TryParse(courseIdStr, out int courseId))
                {
                    DeleteCourse(courseId);
                }
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
                    ShowMessage("Lecturer profile not found. Please contact administrator.", "error");
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

                // Cast the text column to nvarchar to avoid GROUP BY issues
                SqlCommand cmd = new SqlCommand(@"
                    SELECT 
                        c.CourseID,
                        c.CourseName,
                        CAST(c.Description AS NVARCHAR(MAX)) as Description,
                        c.Category,
                        (SELECT COUNT(*) FROM Modules m WHERE m.CourseID = c.CourseID AND m.LecturerID = @LecturerID) as ModuleCount
                    FROM Courses c
                    WHERE EXISTS (SELECT 1 FROM Modules m WHERE m.CourseID = c.CourseID AND m.LecturerID = @LecturerID)", con);

                cmd.Parameters.AddWithValue("@LecturerID", lecturerId);

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();

                try
                {
                    da.Fill(dt);

                    // Sort the DataTable in memory
                    if (dt.Rows.Count > 0)
                    {
                        DataView dv = dt.DefaultView;
                        dv.Sort = "CourseName ASC";
                        DataTable sortedDt = dv.ToTable();

                        courseRepeater.DataSource = sortedDt;
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
                catch (SqlException ex)
                {
                    ShowMessage("Database error: " + ex.Message, "error");
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
                    SELECT 
                        a.AssignmentID,
                        a.Title,
                        a.DueDate,
                        a.CreatedDate,
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
                    WHERE m.LecturerID = @LecturerID AND a.IsActive = 1", con);

                cmd.Parameters.AddWithValue("@LecturerID", lecturerId);

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);

                // Sort and limit in memory
                if (dt.Rows.Count > 0)
                {
                    DataView dv = dt.DefaultView;
                    dv.Sort = "CreatedDate DESC";

                    // Take only top 5
                    DataTable sortedDt = dv.ToTable();
                    DataTable top5 = sortedDt.Clone();

                    int count = Math.Min(sortedDt.Rows.Count, 5);
                    for (int i = 0; i < count; i++)
                    {
                        top5.ImportRow(sortedDt.Rows[i]);
                    }

                    assignmentRepeater.DataSource = top5;
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

        // ====== COURSE MANAGEMENT METHODS ======

        protected void BtnManageModules_Click(object sender, EventArgs e)
        {
            try
            {
                LinkButton btn = (LinkButton)sender;
                int courseId = Convert.ToInt32(btn.CommandArgument);

                // Redirect to the dedicated module management page
                Response.Redirect($"ManageModules.aspx?courseId={courseId}");
            }
            catch (Exception ex)
            {
                ShowMessage("Error: " + ex.Message, "error");
            }
        }

        protected void BtnEditCourse_Click(object sender, EventArgs e)
        {
            try
            {
                LinkButton btn = (LinkButton)sender;
                int courseId = Convert.ToInt32(btn.CommandArgument);
                LoadCourseForEdit(courseId);
            }
            catch (Exception ex)
            {
                ShowMessage("Error loading course for editing: " + ex.Message, "error");
            }
        }

        protected void BtnDeleteCourse_Click(object sender, EventArgs e)
        {
            try
            {
                LinkButton btn = (LinkButton)sender;
                int courseId = Convert.ToInt32(btn.CommandArgument);

                // The actual deletion will be handled by the confirmation dialog JavaScript
                // This method is called but doesn't do the deletion - it's handled by HandlePostBackEvents
                // Just log the attempt for debugging
                System.Diagnostics.Debug.WriteLine($"Delete course button clicked for CourseID: {courseId}");
            }
            catch (Exception ex)
            {
                ShowMessage("Error: " + ex.Message, "error");
            }
        }

        private void LoadCourseForEdit(int courseId)
        {
            string cs = ConfigurationManager.ConnectionStrings["dbConnection"].ConnectionString;
            using (SqlConnection con = new SqlConnection(cs))
            {
                try
                {
                    con.Open();

                    // Verify lecturer has access to this course
                    SqlCommand accessCmd = new SqlCommand(@"
                        SELECT COUNT(*) FROM Modules 
                        WHERE CourseID = @CourseID AND LecturerID = @LecturerID", con);
                    accessCmd.Parameters.AddWithValue("@CourseID", courseId);
                    accessCmd.Parameters.AddWithValue("@LecturerID", lecturerId);

                    int moduleCount = (int)accessCmd.ExecuteScalar();
                    if (moduleCount == 0)
                    {
                        ShowMessage("You don't have permission to edit this course.", "error");
                        return;
                    }

                    SqlCommand cmd = new SqlCommand(@"
                        SELECT CourseID, CourseName, CAST(Description AS NVARCHAR(MAX)) as Description, Category
                        FROM Courses 
                        WHERE CourseID = @CourseID", con);
                    cmd.Parameters.AddWithValue("@CourseID", courseId);

                    SqlDataReader reader = cmd.ExecuteReader();
                    if (reader.Read())
                    {
                        hfCourseID.Value = reader["CourseID"].ToString();

                        string courseName = reader["CourseName"]?.ToString() ?? "";
                        string description = reader["Description"]?.ToString() ?? "";
                        string category = reader["Category"]?.ToString() ?? "";

                        // Escape quotes for JavaScript
                        courseName = courseName.Replace("'", "\\'").Replace("\"", "\\\"");
                        description = description.Replace("'", "\\'").Replace("\"", "\\\"");
                        category = category.Replace("'", "\\'").Replace("\"", "\\\"");

                        // Open modal via JavaScript
                        string script = $"openEditCourseModal({courseId}, '{courseName}', '{description}', '{category}');";
                        ClientScript.RegisterStartupScript(this.GetType(), "openEditModal", script, true);
                    }
                    else
                    {
                        ShowMessage("Course not found.", "error");
                    }
                    reader.Close();
                }
                catch (Exception ex)
                {
                    ShowMessage("Error loading course: " + ex.Message, "error");
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

                    // Verify lecturer has access to this course
                    SqlCommand accessCmd = new SqlCommand(@"
                        SELECT COUNT(*) FROM Modules 
                        WHERE CourseID = @CourseID AND LecturerID = @LecturerID", con);
                    accessCmd.Parameters.AddWithValue("@CourseID", courseId);
                    accessCmd.Parameters.AddWithValue("@LecturerID", lecturerId);

                    int lecturerModuleCount = (int)accessCmd.ExecuteScalar();
                    if (lecturerModuleCount == 0)
                    {
                        ShowMessage("You don't have permission to delete this course.", "error");
                        return;
                    }

                    // Enhanced validation: Check if course has any assignments or students enrolled
                    SqlCommand checkCmd = new SqlCommand(@"
                        SELECT 
                            (SELECT COUNT(*) FROM Assignments a 
                             JOIN Modules m ON a.ModuleID = m.ModuleID 
                             WHERE m.CourseID = @CourseID) as AssignmentCount,
                            (SELECT COUNT(*) FROM UserCourses WHERE CourseID = @CourseID) as StudentCount,
                            (SELECT CourseName FROM Courses WHERE CourseID = @CourseID) as CourseName", con);
                    checkCmd.Parameters.AddWithValue("@CourseID", courseId);

                    SqlDataReader checkReader = checkCmd.ExecuteReader();
                    if (checkReader.Read())
                    {
                        int assignmentCount = Convert.ToInt32(checkReader["AssignmentCount"]);
                        int studentCount = Convert.ToInt32(checkReader["StudentCount"]);
                        string courseName = checkReader["CourseName"]?.ToString() ?? "Unknown Course";

                        if (assignmentCount > 0 || studentCount > 0)
                        {
                            checkReader.Close();
                            string message = $"Cannot delete course '{courseName}'. ";
                            if (assignmentCount > 0 && studentCount > 0)
                            {
                                message += $"It has {assignmentCount} assignment(s) and {studentCount} enrolled student(s).";
                            }
                            else if (assignmentCount > 0)
                            {
                                message += $"It has {assignmentCount} assignment(s).";
                            }
                            else
                            {
                                message += $"It has {studentCount} enrolled student(s).";
                            }
                            ShowMessage(message, "error");
                            return;
                        }
                    }
                    checkReader.Close();

                    // Delete associated modules first (only those belonging to this lecturer)
                    SqlCommand deleteModulesCmd = new SqlCommand(
                        "DELETE FROM Modules WHERE CourseID = @CourseID AND LecturerID = @LecturerID", con);
                    deleteModulesCmd.Parameters.AddWithValue("@CourseID", courseId);
                    deleteModulesCmd.Parameters.AddWithValue("@LecturerID", lecturerId);
                    int modulesDeleted = deleteModulesCmd.ExecuteNonQuery();

                    // Check if there are any remaining modules for this course by other lecturers
                    SqlCommand remainingModulesCmd = new SqlCommand("SELECT COUNT(*) FROM Modules WHERE CourseID = @CourseID", con);
                    remainingModulesCmd.Parameters.AddWithValue("@CourseID", courseId);
                    int remainingModules = (int)remainingModulesCmd.ExecuteScalar();

                    int rowsAffected = 0;
                    if (remainingModules == 0)
                    {
                        // No other lecturers have modules in this course, safe to delete the course
                        SqlCommand deleteCourseCmd = new SqlCommand("DELETE FROM Courses WHERE CourseID = @CourseID", con);
                        deleteCourseCmd.Parameters.AddWithValue("@CourseID", courseId);
                        rowsAffected = deleteCourseCmd.ExecuteNonQuery();
                    }

                    if (modulesDeleted > 0)
                    {
                        string message = $"Your modules removed successfully! ({modulesDeleted} module(s) deleted)";
                        if (rowsAffected > 0)
                        {
                            message = $"Course deleted successfully! ({modulesDeleted} module(s) also removed)";
                        }
                        ShowMessage(message, "success");
                        LoadCourses();
                        LoadDashboardData();
                    }
                    else
                    {
                        ShowMessage("Error deleting course. Course may not exist or you don't have permission.", "error");
                    }
                }
                catch (Exception ex)
                {
                    ShowMessage("Database error while deleting course: " + ex.Message, "error");
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

                        // Create a default module for this course - Let SQL Server auto-generate ModuleID
                        SqlCommand insertModuleCmd = new SqlCommand(@"
                            INSERT INTO Modules (CourseID, Title, Description, ModuleOrder, LecturerID)
                            VALUES (@CourseID, @Title, @Description, @ModuleOrder, @LecturerID)", con);

                        insertModuleCmd.Parameters.AddWithValue("@CourseID", newCourseId);
                        insertModuleCmd.Parameters.AddWithValue("@Title", txtCourseName.Text.Trim() + " - Main Module");
                        insertModuleCmd.Parameters.AddWithValue("@Description", "Main module for " + txtCourseName.Text.Trim());
                        insertModuleCmd.Parameters.AddWithValue("@ModuleOrder", 1);
                        insertModuleCmd.Parameters.AddWithValue("@LecturerID", lecturerId);

                        insertModuleCmd.ExecuteNonQuery();

                        ShowMessage($"Course '{txtCourseName.Text.Trim()}' created successfully with default module!", "success");
                    }
                    else
                    {
                        // Update existing course
                        int courseId = Convert.ToInt32(hfCourseID.Value);

                        // Verify lecturer has access to this course
                        SqlCommand accessCmd = new SqlCommand(@"
                            SELECT COUNT(*) FROM Modules 
                            WHERE CourseID = @CourseID AND LecturerID = @LecturerID", con);
                        accessCmd.Parameters.AddWithValue("@CourseID", courseId);
                        accessCmd.Parameters.AddWithValue("@LecturerID", lecturerId);

                        int moduleCount = (int)accessCmd.ExecuteScalar();
                        if (moduleCount == 0)
                        {
                            ShowMessage("You don't have permission to edit this course.", "error");
                            return;
                        }

                        SqlCommand updateCmd = new SqlCommand(@"
                            UPDATE Courses 
                            SET CourseName = @CourseName, Description = @Description, Category = @Category
                            WHERE CourseID = @CourseID", con);

                        updateCmd.Parameters.AddWithValue("@CourseID", hfCourseID.Value);
                        updateCmd.Parameters.AddWithValue("@CourseName", txtCourseName.Text.Trim());
                        updateCmd.Parameters.AddWithValue("@Description", txtCourseDescription.Text.Trim());
                        updateCmd.Parameters.AddWithValue("@Category", txtCategory.Text.Trim());

                        int rowsAffected = updateCmd.ExecuteNonQuery();
                        if (rowsAffected > 0)
                        {
                            ShowMessage($"Course '{txtCourseName.Text.Trim()}' updated successfully!", "success");
                        }
                        else
                        {
                            ShowMessage("No changes were made to the course.", "error");
                        }
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
                    ShowMessage("Error saving course: " + ex.Message, "error");
                }
            }
        }

        private bool ValidateCourseForm()
        {
            if (string.IsNullOrWhiteSpace(txtCourseName.Text))
            {
                ShowMessage("Please enter course name.", "error");
                return false;
            }

            if (txtCourseName.Text.Trim().Length < 3)
            {
                ShowMessage("Course name must be at least 3 characters long.", "error");
                return false;
            }

            if (string.IsNullOrWhiteSpace(txtCourseDescription.Text))
            {
                ShowMessage("Please enter course description.", "error");
                return false;
            }

            if (txtCourseDescription.Text.Trim().Length < 10)
            {
                ShowMessage("Course description must be at least 10 characters long.", "error");
                return false;
            }

            if (string.IsNullOrWhiteSpace(txtCategory.Text))
            {
                ShowMessage("Please enter course category.", "error");
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
                    ShowMessage("A course with this name already exists. Please choose a different name.", "error");
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

        private void ShowMessage(string message, string type)
        {
            lblMessage.Text = message;
            lblMessage.CssClass = $"message {type}";
            lblMessage.Visible = true;

            // Add client-side styling and auto-hide
            string messageClass = type == "error" ? "error" : "success";
            string script = $@"
                var msgElement = document.getElementById('{lblMessage.ClientID}');
                if (msgElement) {{
                    msgElement.className = 'message {messageClass}';
                    msgElement.style.display = 'block';
                    setTimeout(function() {{
                        msgElement.style.display = 'none';
                    }}, 5000);
                }}";

            ClientScript.RegisterStartupScript(this.GetType(), "showMessage", script, true);
        }

        // Override for better error handling
        protected override void OnError(EventArgs e)
        {
            Exception ex = Server.GetLastError();
            if (ex != null)
            {
                System.Diagnostics.Debug.WriteLine("TeacherWebform Page Error: " + ex.Message);

                // Clear the error
                Server.ClearError();

                // Show user-friendly message
                ShowMessage("An unexpected error occurred. Please try again or contact support if the problem persists.", "error");
            }

            base.OnError(e);
        }
    }
}