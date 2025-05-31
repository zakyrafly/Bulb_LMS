using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace assignmentDraft1
{
    public partial class student_assignments : System.Web.UI.Page
    {
        private int userId;
        private string currentStatusFilter = "all";
        private string currentCourseFilter = "";
        private string currentSearchFilter = "";
        private string currentSortOption = "dueDate";

        protected void Page_Load(object sender, EventArgs e)
        {
            // Check if user is logged in
            if (Session["email"] == null)
            {
                Response.Redirect("loginWebform.aspx");
                return;
            }

            // Load user info on every page load
            LoadUserInfo();

            if (!IsPostBack)
            {
                // Initialize based on query parameters if present
                if (Request.QueryString["status"] != null)
                {
                    currentStatusFilter = Request.QueryString["status"].ToLower();
                    SetActiveStatusFilter(currentStatusFilter);
                }

                if (Request.QueryString["course"] != null)
                {
                    currentCourseFilter = Request.QueryString["course"];
                }

                if (Request.QueryString["sort"] != null)
                {
                    currentSortOption = Request.QueryString["sort"].ToLower();
                    ddlSortOptions.SelectedValue = currentSortOption;
                }

                if (Request.QueryString["search"] != null)
                {
                    currentSearchFilter = Request.QueryString["search"];
                    txtFilterSearch.Text = currentSearchFilter;
                }

                LoadCourseFilters();
                LoadAssignments();
            }
        }

        private void LoadUserInfo()
        {
            string email = Session["email"].ToString();
            string cs = ConfigurationManager.ConnectionStrings["dbConnection"].ConnectionString;

            using (SqlConnection con = new SqlConnection(cs))
            {
                string query = "SELECT UserID, Name, Role FROM Users WHERE Username = @Email";
                SqlCommand cmd = new SqlCommand(query, con);
                cmd.Parameters.AddWithValue("@Email", email);

                con.Open();
                SqlDataReader reader = cmd.ExecuteReader();
                if (reader.Read())
                {
                    userId = Convert.ToInt32(reader["UserID"]);
                    lblName.Text = reader["Name"].ToString();
                    lblRole.Text = reader["Role"].ToString();
                    lblSidebarName.Text = reader["Name"].ToString();
                    lblSidebarRole.Text = reader["Role"].ToString();
                }
                else
                {
                    Response.Redirect("loginWebform.aspx");
                }
            }
        }

        private void LoadCourseFilters()
        {
            string cs = ConfigurationManager.ConnectionStrings["dbConnection"].ConnectionString;

            using (SqlConnection con = new SqlConnection(cs))
            {
                con.Open();

                // Get courses the student is enrolled in
                string query = @"
                    SELECT DISTINCT c.CourseID, c.CourseName
                    FROM Courses c
                    JOIN UserCourses uc ON c.CourseID = uc.CourseID
                    WHERE uc.UserID = @UserID
                    ORDER BY c.CourseName";

                SqlCommand cmd = new SqlCommand(query, con);
                cmd.Parameters.AddWithValue("@UserID", userId);

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);

                if (dt.Rows.Count > 0)
                {
                    courseFilterRepeater.DataSource = dt;
                    courseFilterRepeater.DataBind();
                    pnlCourseFilters.Visible = true;
                }
                else
                {
                    pnlCourseFilters.Visible = false;
                }
            }
        }

        private void LoadAssignments()
        {
            string cs = ConfigurationManager.ConnectionStrings["dbConnection"].ConnectionString;

            using (SqlConnection con = new SqlConnection(cs))
            {
                con.Open();

                // Build a comprehensive query for assignments with filtering
                string query = @"
                    SELECT 
                        a.AssignmentID, 
                        a.Title,
                        a.Description, 
                        a.DueDate, 
                        a.MaxPoints,
                        c.CourseName,
                        c.CourseID,
                        l.FullName AS InstructorName,
                        CASE 
                            WHEN g.PointsEarned IS NOT NULL THEN 'Graded'
                            WHEN s.SubmissionID IS NOT NULL THEN 'Submitted'
                            WHEN a.DueDate < GETDATE() THEN 'Overdue'
                            ELSE 'Pending'
                        END AS Status,
                        s.SubmissionDate,
                        g.PointsEarned
                    FROM Assignments a
                    JOIN Modules m ON a.ModuleID = m.ModuleID
                    JOIN Courses c ON m.CourseID = c.CourseID
                    JOIN UserCourses uc ON c.CourseID = uc.CourseID
                    LEFT JOIN Lecturers l ON m.LecturerID = l.LecturerID
                    LEFT JOIN AssignmentSubmissions s ON a.AssignmentID = s.AssignmentID AND s.UserID = @UserID
                    LEFT JOIN AssignmentGrades g ON s.SubmissionID = g.SubmissionID
                    WHERE uc.UserID = @UserID AND a.IsActive = 1";

                // Add status filter if not "all"
                if (currentStatusFilter != "all")
                {
                    if (currentStatusFilter == "pending")
                    {
                        query += @" AND s.SubmissionID IS NULL AND a.DueDate >= GETDATE()";
                    }
                    else if (currentStatusFilter == "submitted")
                    {
                        query += @" AND s.SubmissionID IS NOT NULL AND g.PointsEarned IS NULL";
                    }
                    else if (currentStatusFilter == "graded")
                    {
                        query += @" AND g.PointsEarned IS NOT NULL";
                    }
                    else if (currentStatusFilter == "overdue")
                    {
                        query += @" AND s.SubmissionID IS NULL AND a.DueDate < GETDATE()";
                    }
                }

                // Add course filter if specified
                if (!string.IsNullOrEmpty(currentCourseFilter))
                {
                    query += " AND c.CourseID = @CourseID";
                }

                // Add search filter if specified
                if (!string.IsNullOrEmpty(currentSearchFilter))
                {
                    query += @" AND (a.Title LIKE @Search OR a.Description LIKE @Search OR c.CourseName LIKE @Search)";
                }

                // Add sorting
                if (currentSortOption == "dueDate")
                {
                    query += " ORDER BY a.DueDate ASC";
                }
                else if (currentSortOption == "course")
                {
                    query += " ORDER BY c.CourseName ASC, a.DueDate ASC";
                }
                else if (currentSortOption == "status")
                {
                    query += @" ORDER BY 
                        CASE 
                            WHEN a.DueDate < GETDATE() AND s.SubmissionID IS NULL THEN 1 -- Overdue first
                            WHEN a.DueDate < DATEADD(day, 7, GETDATE()) AND s.SubmissionID IS NULL THEN 2 -- Due soon second
                            WHEN s.SubmissionID IS NULL THEN 3 -- Pending third
                            WHEN g.PointsEarned IS NULL THEN 4 -- Submitted fourth
                            ELSE 5 -- Graded last
                        END, 
                        a.DueDate ASC";
                }

                SqlCommand cmd = new SqlCommand(query, con);
                cmd.Parameters.AddWithValue("@UserID", userId);

                if (!string.IsNullOrEmpty(currentCourseFilter))
                {
                    cmd.Parameters.AddWithValue("@CourseID", currentCourseFilter);
                }

                if (!string.IsNullOrEmpty(currentSearchFilter))
                {
                    cmd.Parameters.AddWithValue("@Search", "%" + currentSearchFilter + "%");
                }

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);

                if (dt.Rows.Count > 0)
                {
                    assignmentsRepeater.DataSource = dt;
                    assignmentsRepeater.DataBind();
                    pnlNoAssignments.Visible = false;

                    // Update statistics
                    UpdateAssignmentStatistics(dt);
                }
                else
                {
                    assignmentsRepeater.DataSource = null;
                    assignmentsRepeater.DataBind();
                    pnlNoAssignments.Visible = true;

                    // Reset statistics
                    lblTotalAssignments.Text = "0";
                    lblPendingAssignments.Text = "0";
                    lblCompletedAssignments.Text = "0";
                    lblAverageGrade.Text = "0%";
                }
            }
        }

        private void UpdateAssignmentStatistics(DataTable assignments)
        {
            int total = assignments.Rows.Count;
            int pending = 0;
            int completed = 0;
            double totalPoints = 0;
            double maxPoints = 0;
            int gradedCount = 0;

            foreach (DataRow row in assignments.Rows)
            {
                string status = row["Status"].ToString();

                if (status == "Pending" || status == "Overdue")
                {
                    pending++;
                }
                else if (status == "Submitted" || status == "Graded")
                {
                    completed++;
                }

                if (status == "Graded" && !Convert.IsDBNull(row["PointsEarned"]) && !Convert.IsDBNull(row["MaxPoints"]))
                {
                    totalPoints += Convert.ToDouble(row["PointsEarned"]);
                    maxPoints += Convert.ToDouble(row["MaxPoints"]);
                    gradedCount++;
                }
            }

            lblTotalAssignments.Text = total.ToString();
            lblPendingAssignments.Text = pending.ToString();
            lblCompletedAssignments.Text = completed.ToString();

            // Calculate average grade
            if (gradedCount > 0 && maxPoints > 0)
            {
                double averagePercentage = (totalPoints / maxPoints) * 100;
                lblAverageGrade.Text = averagePercentage.ToString("F1") + "%";
            }
            else
            {
                lblAverageGrade.Text = "N/A";
            }
        }

        private void SetActiveStatusFilter(string status)
        {
            // Reset all filter buttons
            btnFilterAll.CssClass = "quick-filter";
            btnFilterPending.CssClass = "quick-filter";
            btnFilterSubmitted.CssClass = "quick-filter";
            btnFilterGraded.CssClass = "quick-filter";
            btnFilterOverdue.CssClass = "quick-filter";

            // Set active class to selected filter
            switch (status.ToLower())
            {
                case "pending":
                    btnFilterPending.CssClass = "quick-filter active";
                    break;
                case "submitted":
                    btnFilterSubmitted.CssClass = "quick-filter active";
                    break;
                case "graded":
                    btnFilterGraded.CssClass = "quick-filter active";
                    break;
                case "overdue":
                    btnFilterOverdue.CssClass = "quick-filter active";
                    break;
                default:
                    btnFilterAll.CssClass = "quick-filter active";
                    break;
            }
        }

        #region Event Handlers

        protected void btnFilterAll_Click(object sender, EventArgs e)
        {
            currentStatusFilter = "all";
            SetActiveStatusFilter("all");
            LoadAssignments();
        }

        protected void btnFilterPending_Click(object sender, EventArgs e)
        {
            currentStatusFilter = "pending";
            SetActiveStatusFilter("pending");
            LoadAssignments();
        }

        protected void btnFilterSubmitted_Click(object sender, EventArgs e)
        {
            currentStatusFilter = "submitted";
            SetActiveStatusFilter("submitted");
            LoadAssignments();
        }

        protected void btnFilterGraded_Click(object sender, EventArgs e)
        {
            currentStatusFilter = "graded";
            SetActiveStatusFilter("graded");
            LoadAssignments();
        }

        protected void btnFilterOverdue_Click(object sender, EventArgs e)
        {
            currentStatusFilter = "overdue";
            SetActiveStatusFilter("overdue");
            LoadAssignments();
        }

        protected void courseFilterRepeater_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (e.CommandName == "FilterCourse")
            {
                string courseId = e.CommandArgument.ToString();

                if (currentCourseFilter == courseId)
                {
                    // If clicking the same course again, clear the filter
                    currentCourseFilter = "";
                }
                else
                {
                    currentCourseFilter = courseId;
                }

                LoadAssignments();
                courseFilterRepeater.DataBind(); // Refresh the course filter UI
            }
        }

        protected void txtFilterSearch_TextChanged(object sender, EventArgs e)
        {
            currentSearchFilter = txtFilterSearch.Text.Trim();
            LoadAssignments();
        }

        protected void ddlSortOptions_SelectedIndexChanged(object sender, EventArgs e)
        {
            currentSortOption = ddlSortOptions.SelectedValue;
            LoadAssignments();
        }

        protected void btnClearFilters_Click(object sender, EventArgs e)
        {
            // Reset all filters
            currentStatusFilter = "all";
            currentCourseFilter = "";
            currentSearchFilter = "";
            currentSortOption = "dueDate";

            // Reset UI
            SetActiveStatusFilter("all");
            txtFilterSearch.Text = "";
            ddlSortOptions.SelectedValue = "dueDate";

            // Reload data
            LoadAssignments();
            courseFilterRepeater.DataBind();
        }

        protected void btnSearch_Click(object sender, EventArgs e)
        {
            string query = txtSearch.Text.Trim();
            if (!string.IsNullOrEmpty(query))
            {
                Response.Redirect("searchResults.aspx?query=" + Server.UrlEncode(query));
            }
        }

        #endregion

        #region Helper Methods

        protected string GetStatusIcon(object status)
        {
            if (status == null) return "fa-question";

            string statusStr = status.ToString().ToLower();
            switch (statusStr)
            {
                case "pending":
                    return "fa-clock";
                case "submitted":
                    return "fa-check";
                case "overdue":
                    return "fa-exclamation-triangle";
                case "graded":
                    return "fa-star";
                default:
                    return "fa-question";
            }
        }

        protected string GetTimeRemaining(object dueDate, object status)
        {
            if (dueDate == null || dueDate == DBNull.Value)
                return "No due date";

            try
            {
                DateTime due = Convert.ToDateTime(dueDate);
                TimeSpan remaining = due - DateTime.Now;
                string statusStr = status?.ToString().ToLower() ?? "";

                if (statusStr == "submitted" || statusStr == "graded")
                {
                    return "Completed";
                }

                if (remaining.TotalDays < 0)
                {
                    int daysLate = Math.Abs((int)remaining.TotalDays);
                    return daysLate == 0 ? "Due today" : $"{daysLate} day{(daysLate > 1 ? "s" : "")} overdue";
                }
                else if (remaining.TotalDays < 1)
                {
                    int hoursLeft = (int)remaining.TotalHours;
                    return hoursLeft <= 0 ? "Due soon" : $"{hoursLeft} hour{(hoursLeft > 1 ? "s" : "")} left";
                }
                else
                {
                    int daysLeft = (int)remaining.TotalDays;
                    return $"{daysLeft} day{(daysLeft > 1 ? "s" : "")} left";
                }
            }
            catch
            {
                return "Invalid date";
            }
        }

        protected string GetTimeRemainingClass(object dueDate, object status)
        {
            if (dueDate == null || dueDate == DBNull.Value) return "";

            string statusStr = status?.ToString().ToLower() ?? "";
            if (statusStr == "submitted" || statusStr == "graded")
            {
                return "";
            }

            try
            {
                DateTime due = Convert.ToDateTime(dueDate);
                TimeSpan remaining = due - DateTime.Now;

                if (remaining.TotalDays < 0)
                {
                    return "urgent";
                }
                else if (remaining.TotalDays < 3)
                {
                    return "soon";
                }
                else
                {
                    return "plenty";
                }
            }
            catch
            {
                return "";
            }
        }

        protected string GetCompletionPercentage(object status)
        {
            if (status == null) return "0";

            string statusStr = status.ToString().ToLower();
            switch (statusStr)
            {
                case "pending":
                    return "25";
                case "submitted":
                    return "75";
                case "graded":
                    return "100";
                case "overdue":
                    return "10";
                default:
                    return "0";
            }
        }

        protected string GetActionButtonText(object status)
        {
            if (status == null) return "<i class=\"fas fa-eye\"></i> View Details";

            string statusStr = status.ToString().ToLower();
            switch (statusStr)
            {
                case "pending":
                    return "<i class=\"fas fa-pencil-alt\"></i> Start Assignment";
                case "submitted":
                    return "<i class=\"fas fa-eye\"></i> View Submission";
                case "overdue":
                    return "<i class=\"fas fa-exclamation-circle\"></i> Submit Late";
                case "graded":
                    return "<i class=\"fas fa-star\"></i> View Feedback";
                default:
                    return "<i class=\"fas fa-eye\"></i> View Details";
            }
        }

        protected string GetGradeDisplay(object pointsEarned, object maxPoints)
        {
            if (pointsEarned == null || pointsEarned == DBNull.Value ||
                maxPoints == null || maxPoints == DBNull.Value)
                return "";

            try
            {
                double earned = Convert.ToDouble(pointsEarned);
                double max = Convert.ToDouble(maxPoints);
                double percentage = (earned / max) * 100;
                string letterGrade = GetLetterGrade(percentage);

                return $@"
                    <div class='grade-display'>
                        <div class='grade-score'>{earned:F1}/{max:F1}</div>
                        <div style='color: var(--light-color); font-size: 1.1rem;'>{percentage:F1}% ({letterGrade})</div>
                    </div>";
            }
            catch
            {
                return "";
            }
        }

        protected string GetCourseFilterClass(object courseId)
        {
            if (courseId == null) return "course-filter";

            string id = courseId.ToString();
            return id == currentCourseFilter ? "course-filter active" : "course-filter";
        }

        protected string TruncateDescription(object description)
        {
            if (description == null || description == DBNull.Value)
                return "No description available";

            string desc = description.ToString();
            if (desc.Length <= 100)
                return desc;

            return desc.Substring(0, 100) + "...";
        }

        private string GetLetterGrade(double percentage)
        {
            if (percentage >= 90) return "A";
            if (percentage >= 80) return "B";
            if (percentage >= 70) return "C";
            if (percentage >= 60) return "D";
            return "F";
        }

        #endregion
    }
}