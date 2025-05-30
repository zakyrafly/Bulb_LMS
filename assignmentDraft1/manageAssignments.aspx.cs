using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace assignmentDraft1
{
    public partial class manageAssignments : System.Web.UI.Page
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
                LoadAssignmentStatistics();
                LoadCourseFilter();
                LoadAssignments();
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

        private void LoadAssignmentStatistics()
        {
            string cs = ConfigurationManager.ConnectionStrings["dbConnection"].ConnectionString;
            using (SqlConnection con = new SqlConnection(cs))
            {
                con.Open();

                // Get total assignments count
                SqlCommand totalCmd = new SqlCommand("SELECT COUNT(*) FROM Assignments", con);
                int totalAssignments = (int)totalCmd.ExecuteScalar();
                lblTotalAssignments.Text = totalAssignments.ToString();

                // Get active assignments count
                SqlCommand activeCmd = new SqlCommand("SELECT COUNT(*) FROM Assignments WHERE IsActive = 1", con);
                int activeAssignments = (int)activeCmd.ExecuteScalar();
                lblActiveAssignments.Text = activeAssignments.ToString();

                // Get assignments due soon (within 7 days)
                SqlCommand dueSoonCmd = new SqlCommand(@"
                    SELECT COUNT(*) FROM Assignments 
                    WHERE IsActive = 1 AND DueDate BETWEEN GETDATE() AND DATEADD(day, 7, GETDATE())", con);
                int dueSoon = (int)dueSoonCmd.ExecuteScalar();
                lblDueSoon.Text = dueSoon.ToString();

                // Get overdue assignments
                SqlCommand overdueCmd = new SqlCommand(@"
                    SELECT COUNT(*) FROM Assignments 
                    WHERE IsActive = 1 AND DueDate < GETDATE()", con);
                int overdue = (int)overdueCmd.ExecuteScalar();
                lblOverdue.Text = overdue.ToString();

                // Get total submissions count
                SqlCommand submissionsCmd = new SqlCommand("SELECT COUNT(*) FROM AssignmentSubmissions", con);
                int totalSubmissions = (int)submissionsCmd.ExecuteScalar();
                lblTotalSubmissions.Text = totalSubmissions.ToString();

                // Get pending grades count
                SqlCommand pendingGradesCmd = new SqlCommand(@"
                    SELECT COUNT(*) FROM AssignmentSubmissions s
                    LEFT JOIN AssignmentGrades g ON s.SubmissionID = g.SubmissionID
                    WHERE s.Status = 'Submitted' AND g.GradeID IS NULL", con);
                int pendingGrades = (int)pendingGradesCmd.ExecuteScalar();
                lblPendingGrades.Text = pendingGrades.ToString();
            }
        }

        private void LoadCourseFilter()
        {
            string cs = ConfigurationManager.ConnectionStrings["dbConnection"].ConnectionString;
            using (SqlConnection con = new SqlConnection(cs))
            {
                con.Open();
                SqlCommand cmd = new SqlCommand(@"
                    SELECT DISTINCT C.CourseID, C.CourseName 
                    FROM Courses C
                    JOIN Modules M ON C.CourseID = M.CourseID
                    JOIN Assignments A ON M.ModuleID = A.ModuleID
                    ORDER BY C.CourseName", con);

                SqlDataReader reader = cmd.ExecuteReader();

                ddlCourseFilter.Items.Clear();
                ddlCourseFilter.Items.Add(new ListItem("All Courses", ""));

                while (reader.Read())
                {
                    ddlCourseFilter.Items.Add(new ListItem(reader["CourseName"].ToString(), reader["CourseID"].ToString()));
                }
            }
        }

        private void LoadAssignments()
        {
            string cs = ConfigurationManager.ConnectionStrings["dbConnection"].ConnectionString;
            using (SqlConnection con = new SqlConnection(cs))
            {
                con.Open();

                // Build comprehensive query with statistics
                string query = @"
                    SELECT 
                        A.AssignmentID,
                        A.Title,
                        A.Description,
                        A.DueDate,
                        A.MaxPoints,
                        A.IsActive,
                        C.CourseName,
                        M.Title AS ModuleTitle,
                        ISNULL(SubmissionStats.TotalSubmissions, 0) AS TotalSubmissions,
                        ISNULL(EnrollmentStats.EnrolledStudents, 0) AS EnrolledStudents
                    FROM Assignments A
                    JOIN Modules M ON A.ModuleID = M.ModuleID
                    JOIN Courses C ON M.CourseID = C.CourseID
                    LEFT JOIN (
                        SELECT 
                            AssignmentID,
                            COUNT(*) AS TotalSubmissions
                        FROM AssignmentSubmissions
                        WHERE Status = 'Submitted'
                        GROUP BY AssignmentID
                    ) SubmissionStats ON A.AssignmentID = SubmissionStats.AssignmentID
                    LEFT JOIN (
                        SELECT 
                            M.CourseID,
                            COUNT(DISTINCT UC.UserID) AS EnrolledStudents
                        FROM Modules M
                        JOIN UserCourses UC ON M.CourseID = UC.CourseID
                        GROUP BY M.CourseID
                    ) EnrollmentStats ON C.CourseID = EnrollmentStats.CourseID
                    WHERE A.IsActive = 1";

                // Add search filter
                if (!string.IsNullOrEmpty(txtSearch.Text.Trim()))
                {
                    query += " AND (A.Title LIKE @SearchTerm OR A.Description LIKE @SearchTerm)";
                }

                // Add status filter
                if (!string.IsNullOrEmpty(ddlStatusFilter.SelectedValue))
                {
                    switch (ddlStatusFilter.SelectedValue)
                    {
                        case "Active":
                            query += " AND A.DueDate > GETDATE()";
                            break;
                        case "DueSoon":
                            query += " AND A.DueDate BETWEEN GETDATE() AND DATEADD(day, 7, GETDATE())";
                            break;
                        case "Overdue":
                            query += " AND A.DueDate < GETDATE()";
                            break;
                    }
                }

                // Add course filter
                if (!string.IsNullOrEmpty(ddlCourseFilter.SelectedValue))
                {
                    query += " AND C.CourseID = @CourseFilter";
                }

                query += " ORDER BY A.DueDate ASC";

                SqlCommand cmd = new SqlCommand(query, con);

                // Add parameters
                if (!string.IsNullOrEmpty(txtSearch.Text.Trim()))
                {
                    cmd.Parameters.AddWithValue("@SearchTerm", "%" + txtSearch.Text.Trim() + "%");
                }

                if (!string.IsNullOrEmpty(ddlCourseFilter.SelectedValue))
                {
                    cmd.Parameters.AddWithValue("@CourseFilter", ddlCourseFilter.SelectedValue);
                }

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);

                if (dt.Rows.Count > 0)
                {
                    assignmentRepeater.DataSource = dt;
                    assignmentRepeater.DataBind();
                    lblDisplayCount.Text = dt.Rows.Count.ToString();
                    pnlNoAssignments.Visible = false;
                }
                else
                {
                    assignmentRepeater.DataSource = null;
                    assignmentRepeater.DataBind();
                    lblDisplayCount.Text = "0";
                    pnlNoAssignments.Visible = true;
                }
            }
        }

        protected void ddlStatusFilter_SelectedIndexChanged(object sender, EventArgs e)
        {
            LoadAssignments();
        }

        protected void ddlCourseFilter_SelectedIndexChanged(object sender, EventArgs e)
        {
            LoadAssignments();
        }

        protected void btnSearch_Click(object sender, EventArgs e)
        {
            LoadAssignments();
        }

        protected void btnHeaderSearch_Click(object sender, EventArgs e)
        {
            txtSearch.Text = txtHeaderSearch.Text.Trim();
            LoadAssignments();
        }

        protected void btnExportReport_Click(object sender, EventArgs e)
        {
            // Export functionality can be implemented here
            ShowMessage("Export feature coming soon!", "blue");
        }

        protected void assignmentRepeater_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            int assignmentId = Convert.ToInt32(e.CommandArgument);

            switch (e.CommandName)
            {
                case "ViewDetails":
                    LoadAssignmentDetails(assignmentId);
                    break;
                case "ManageGrades":
                    Response.Redirect($"gradeAssignment.aspx?assignmentID={assignmentId}");
                    break;
                case "Edit":
                    Response.Redirect($"editAssignment.aspx?assignmentID={assignmentId}");
                    break;
                case "Delete":
                    DeleteAssignment(assignmentId);
                    break;
            }
        }

        private void LoadAssignmentDetails(int assignmentId)
        {
            string cs = ConfigurationManager.ConnectionStrings["dbConnection"].ConnectionString;
            using (SqlConnection con = new SqlConnection(cs))
            {
                con.Open();

                // Load assignment details
                SqlCommand assignmentCmd = new SqlCommand(@"
                    SELECT 
                        A.Title, A.Description, A.DueDate, A.MaxPoints,
                        C.CourseName, M.Title AS ModuleTitle
                    FROM Assignments A
                    JOIN Modules M ON A.ModuleID = M.ModuleID
                    JOIN Courses C ON M.CourseID = C.CourseID
                    WHERE A.AssignmentID = @AssignmentID", con);
                assignmentCmd.Parameters.AddWithValue("@AssignmentID", assignmentId);

                SqlDataReader assignmentReader = assignmentCmd.ExecuteReader();
                if (assignmentReader.Read())
                {
                    lblModalTitle.Text = assignmentReader["Title"].ToString();
                    lblModalCourse.Text = $"{assignmentReader["CourseName"]} - {assignmentReader["ModuleTitle"]}";
                    lblModalDescription.Text = assignmentReader["Description"].ToString();
                    lblModalDueDate.Text = Convert.ToDateTime(assignmentReader["DueDate"]).ToString("MMM dd, yyyy hh:mm tt");
                    lblModalMaxPoints.Text = assignmentReader["MaxPoints"] + " points";

                    DateTime dueDate = Convert.ToDateTime(assignmentReader["DueDate"]);
                    lblModalStatus.Text = GetStatusText(dueDate);
                }
                assignmentReader.Close();

                // Load submissions and grades
                SqlCommand submissionsCmd = new SqlCommand(@"
                    SELECT 
                        U.Name AS StudentName,
                        U.username AS StudentEmail,
                        S.SubmissionDate,
                        G.PointsEarned,
                        A.MaxPoints
                    FROM Users U
                    JOIN UserCourses UC ON U.UserID = UC.UserID
                    JOIN Modules M ON UC.CourseID = M.CourseID
                    JOIN Assignments A ON M.ModuleID = A.ModuleID
                    LEFT JOIN AssignmentSubmissions S ON A.AssignmentID = S.AssignmentID AND U.UserID = S.UserID
                    LEFT JOIN AssignmentGrades G ON S.SubmissionID = G.SubmissionID
                    WHERE A.AssignmentID = @AssignmentID AND U.Role = 'Student'
                    ORDER BY U.Name", con);
                submissionsCmd.Parameters.AddWithValue("@AssignmentID", assignmentId);

                SqlDataAdapter da = new SqlDataAdapter(submissionsCmd);
                DataTable dt = new DataTable();
                da.Fill(dt);

                if (dt.Rows.Count > 0)
                {
                    submissionRepeater.DataSource = dt;
                    submissionRepeater.DataBind();
                    pnlNoSubmissions.Visible = false;
                }
                else
                {
                    submissionRepeater.DataSource = null;
                    submissionRepeater.DataBind();
                    pnlNoSubmissions.Visible = true;
                }

                // Open details modal via JavaScript
                ClientScript.RegisterStartupScript(this.GetType(), "openDetailsModal",
                    "document.getElementById('detailsModal').style.display = 'block';", true);
            }
        }

        private void DeleteAssignment(int assignmentId)
        {
            string cs = ConfigurationManager.ConnectionStrings["dbConnection"].ConnectionString;
            using (SqlConnection con = new SqlConnection(cs))
            {
                try
                {
                    con.Open();

                    // Check if assignment has submissions
                    SqlCommand checkCmd = new SqlCommand("SELECT COUNT(*) FROM AssignmentSubmissions WHERE AssignmentID = @AssignmentID", con);
                    checkCmd.Parameters.AddWithValue("@AssignmentID", assignmentId);
                    int submissionCount = (int)checkCmd.ExecuteScalar();

                    if (submissionCount > 0)
                    {
                        ShowMessage("Cannot delete assignment. Students have already submitted work.", "red");
                        return;
                    }

                    // Soft delete - set IsActive to false
                    SqlCommand deleteCmd = new SqlCommand("UPDATE Assignments SET IsActive = 0 WHERE AssignmentID = @AssignmentID", con);
                    deleteCmd.Parameters.AddWithValue("@AssignmentID", assignmentId);
                    deleteCmd.ExecuteNonQuery();

                    ShowMessage("Assignment deleted successfully!", "green");
                    LoadAssignments();
                    LoadAssignmentStatistics();
                }
                catch (Exception ex)
                {
                    ShowMessage("Error: " + ex.Message, "red");
                }
            }
        }

        // Helper methods for the repeater
        protected string GetStatusClass(object dueDateObj)
        {
            if (dueDateObj == null) return "status-active";

            DateTime dueDate = Convert.ToDateTime(dueDateObj);
            DateTime now = DateTime.Now;

            if (dueDate < now)
                return "status-overdue";
            else if (dueDate < now.AddDays(7))
                return "status-due-soon";

            return "status-active";
        }

        protected string GetStatusText(object dueDateObj)
        {
            if (dueDateObj == null) return "Active";

            DateTime dueDate = Convert.ToDateTime(dueDateObj);
            DateTime now = DateTime.Now;

            if (dueDate < now)
                return "Overdue";
            else if (dueDate < now.AddDays(7))
                return "Due Soon";

            return "Active";
        }

        private string GetStatusText(DateTime dueDate)
        {
            DateTime now = DateTime.Now;

            if (dueDate < now)
                return "Overdue";
            else if (dueDate < now.AddDays(7))
                return "Due Soon";

            return "Active";
        }

        protected string GetProgressPercentage(object submissionsObj, object enrolledObj)
        {
            int submissions = submissionsObj != null ? Convert.ToInt32(submissionsObj) : 0;
            int enrolled = enrolledObj != null ? Convert.ToInt32(enrolledObj) : 0;

            if (enrolled == 0) return "0";

            double percentage = (double)submissions / enrolled * 100;
            return Math.Round(percentage, 0).ToString();
        }

        protected string GetGradeClass(object pointsEarnedObj, object maxPointsObj)
        {
            if (pointsEarnedObj == null || pointsEarnedObj == DBNull.Value)
                return "grade-pending";

            double pointsEarned = Convert.ToDouble(pointsEarnedObj);
            double maxPoints = Convert.ToDouble(maxPointsObj);
            double percentage = (pointsEarned / maxPoints) * 100;

            if (percentage >= 90) return "grade-excellent";
            if (percentage >= 80) return "grade-good";
            if (percentage >= 70) return "grade-average";
            if (percentage >= 60) return "grade-poor";
            return "grade-poor";
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