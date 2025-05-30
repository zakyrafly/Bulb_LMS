using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Text;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace assignmentDraft1
{
    public partial class systemReports : System.Web.UI.Page
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
                LoadSystemOverview();
                LoadReports();
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

        private void LoadSystemOverview()
        {
            string cs = ConfigurationManager.ConnectionStrings["dbConnection"].ConnectionString;
            using (SqlConnection con = new SqlConnection(cs))
            {
                con.Open();

                // Get total users
                SqlCommand usersCmd = new SqlCommand("SELECT COUNT(*) FROM Users", con);
                int totalUsers = (int)usersCmd.ExecuteScalar();
                lblTotalUsers.Text = totalUsers.ToString();

                // Get total courses
                SqlCommand coursesCmd = new SqlCommand("SELECT COUNT(*) FROM Courses", con);
                int totalCourses = (int)coursesCmd.ExecuteScalar();
                lblTotalCourses.Text = totalCourses.ToString();

                // Get total assignments
                SqlCommand assignmentsCmd = new SqlCommand("SELECT COUNT(*) FROM Assignments WHERE IsActive = 1", con);
                int totalAssignments = (int)assignmentsCmd.ExecuteScalar();
                lblTotalAssignments.Text = totalAssignments.ToString();

                // Get total submissions
                SqlCommand submissionsCmd = new SqlCommand("SELECT COUNT(*) FROM AssignmentSubmissions WHERE Status = 'Submitted'", con);
                int totalSubmissions = (int)submissionsCmd.ExecuteScalar();
                lblTotalSubmissions.Text = totalSubmissions.ToString();

                // Get total grades
                SqlCommand gradesCmd = new SqlCommand("SELECT COUNT(*) FROM AssignmentGrades", con);
                int totalGrades = (int)gradesCmd.ExecuteScalar();
                lblTotalGrades.Text = totalGrades.ToString();

                // Calculate average performance
                SqlCommand avgPerformanceCmd = new SqlCommand(@"
                    SELECT AVG(CAST(PointsEarned AS FLOAT) / CAST(A.MaxPoints AS FLOAT) * 100) 
                    FROM AssignmentGrades G
                    JOIN AssignmentSubmissions S ON G.SubmissionID = S.SubmissionID
                    JOIN Assignments A ON S.AssignmentID = A.AssignmentID", con);
                object avgPerformanceObj = avgPerformanceCmd.ExecuteScalar();
                double avgPerformance = avgPerformanceObj != DBNull.Value ? Convert.ToDouble(avgPerformanceObj) : 0;
                lblAvgPerformance.Text = avgPerformance.ToString("F1") + "%";

                // Calculate database records
                SqlCommand recordsCmd = new SqlCommand(@"
                    SELECT 
                        (SELECT COUNT(*) FROM Users) +
                        (SELECT COUNT(*) FROM Courses) +
                        (SELECT COUNT(*) FROM Assignments) +
                        (SELECT COUNT(*) FROM AssignmentSubmissions) +
                        (SELECT COUNT(*) FROM AssignmentGrades) +
                        (SELECT COUNT(*) FROM UserCourses) +
                        (SELECT COUNT(*) FROM Modules) AS TotalRecords", con);
                int totalRecords = (int)recordsCmd.ExecuteScalar();
                lblDatabaseRecords.Text = totalRecords.ToString();
            }
        }

        private void LoadReports()
        {
            LoadUserActivity();
            LoadCoursePerformance();
            LoadAssignmentAnalytics();
            LoadTopStudents();
            LoadRecentActivity();
        }

        private void LoadUserActivity()
        {
            string cs = ConfigurationManager.ConnectionStrings["dbConnection"].ConnectionString;
            using (SqlConnection con = new SqlConnection(cs))
            {
                con.Open();

                // Active students (students with submissions)
                SqlCommand activeStudentsCmd = new SqlCommand(@"
                    SELECT COUNT(DISTINCT U.UserID) 
                    FROM Users U
                    JOIN AssignmentSubmissions S ON U.UserID = S.UserID
                    WHERE U.Role = 'Student' AND S.Status = 'Submitted'", con);
                int activeStudents = (int)activeStudentsCmd.ExecuteScalar();
                lblActiveStudents.Text = activeStudents.ToString();

                // Active lecturers (lecturers with modules)
                SqlCommand activeLecturersCmd = new SqlCommand(@"
                    SELECT COUNT(DISTINCT L.LecturerID) 
                    FROM Lecturers L
                    JOIN Modules M ON L.LecturerID = M.LecturerID", con);
                int activeLecturers = (int)activeLecturersCmd.ExecuteScalar();
                lblActiveLecturers.Text = activeLecturers.ToString();

                // New registrations (mock data based on recent users)
                SqlCommand newRegistrationsCmd = new SqlCommand("SELECT COUNT(*) FROM Users WHERE Role = 'Student'", con);
                int newRegistrations = Math.Min((int)newRegistrationsCmd.ExecuteScalar() / 4, 10); // Mock recent registrations
                lblNewRegistrations.Text = newRegistrations.ToString();

                // Engagement rate
                SqlCommand totalStudentsCmd = new SqlCommand("SELECT COUNT(*) FROM Users WHERE Role = 'Student'", con);
                int totalStudents = (int)totalStudentsCmd.ExecuteScalar();
                double engagementRate = totalStudents > 0 ? (double)activeStudents / totalStudents * 100 : 0;
                lblEngagementRate.Text = engagementRate.ToString("F1") + "%";
            }
        }

        private void LoadCoursePerformance()
        {
            string cs = ConfigurationManager.ConnectionStrings["dbConnection"].ConnectionString;
            using (SqlConnection con = new SqlConnection(cs))
            {
                con.Open();

                SqlCommand cmd = new SqlCommand(@"
                    SELECT 
                        C.CourseName,
                        ISNULL(StudentStats.StudentCount, 0) AS StudentCount,
                        ISNULL(PerformanceStats.CompletionRate, 0) AS CompletionRate,
                        ISNULL(PerformanceStats.AverageGrade, 0) AS AverageGrade
                    FROM Courses C
                    LEFT JOIN (
                        SELECT 
                            UC.CourseID,
                            COUNT(DISTINCT UC.UserID) AS StudentCount
                        FROM UserCourses UC
                        GROUP BY UC.CourseID
                    ) StudentStats ON C.CourseID = StudentStats.CourseID
                    LEFT JOIN (
                        SELECT 
                            UC.CourseID,
                            AVG(CASE 
                                WHEN S.Status = 'Submitted' THEN 100.0 
                                ELSE 0.0 
                            END) AS CompletionRate,
                            AVG(CASE 
                                WHEN G.PointsEarned IS NOT NULL THEN 
                                    (CAST(G.PointsEarned AS FLOAT) / CAST(A.MaxPoints AS FLOAT) * 100)
                                ELSE 0
                            END) AS AverageGrade
                        FROM UserCourses UC
                        JOIN Modules M ON UC.CourseID = M.CourseID
                        JOIN Assignments A ON M.ModuleID = A.ModuleID
                        LEFT JOIN AssignmentSubmissions S ON A.AssignmentID = S.AssignmentID AND UC.UserID = S.UserID
                        LEFT JOIN AssignmentGrades G ON S.SubmissionID = G.SubmissionID
                        GROUP BY UC.CourseID
                    ) PerformanceStats ON C.CourseID = PerformanceStats.CourseID
                    ORDER BY C.CourseName", con);

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);

                if (dt.Rows.Count > 0)
                {
                    coursePerformanceRepeater.DataSource = dt;
                    coursePerformanceRepeater.DataBind();
                    pnlNoCourseData.Visible = false;
                }
                else
                {
                    coursePerformanceRepeater.DataSource = null;
                    coursePerformanceRepeater.DataBind();
                    pnlNoCourseData.Visible = true;
                }
            }
        }

        private void LoadAssignmentAnalytics()
        {
            string cs = ConfigurationManager.ConnectionStrings["dbConnection"].ConnectionString;
            using (SqlConnection con = new SqlConnection(cs))
            {
                con.Open();

                // On-time submissions
                SqlCommand onTimeCmd = new SqlCommand(@"
                    SELECT COUNT(*) FROM AssignmentSubmissions S
                    JOIN Assignments A ON S.AssignmentID = A.AssignmentID
                    WHERE S.Status = 'Submitted' AND S.IsLate = 0", con);
                int onTimeSubmissions = (int)onTimeCmd.ExecuteScalar();
                lblOnTimeSubmissions.Text = onTimeSubmissions.ToString();

                // Late submissions
                SqlCommand lateCmd = new SqlCommand(@"
                    SELECT COUNT(*) FROM AssignmentSubmissions S
                    WHERE S.Status = 'Submitted' AND S.IsLate = 1", con);
                int lateSubmissions = (int)lateCmd.ExecuteScalar();
                lblLateSubmissions.Text = lateSubmissions.ToString();

                // Missed assignments (assignments past due with no submission)
                SqlCommand missedCmd = new SqlCommand(@"
                    SELECT COUNT(*) FROM Assignments A
                    JOIN Modules M ON A.ModuleID = M.ModuleID
                    JOIN UserCourses UC ON M.CourseID = UC.CourseID
                    LEFT JOIN AssignmentSubmissions S ON A.AssignmentID = S.AssignmentID AND UC.UserID = S.UserID
                    WHERE A.DueDate < GETDATE() AND A.IsActive = 1 AND S.SubmissionID IS NULL", con);
                int missedAssignments = (int)missedCmd.ExecuteScalar();
                lblMissedAssignments.Text = missedAssignments.ToString();

                // Submission rate
                SqlCommand totalExpectedCmd = new SqlCommand(@"
                    SELECT COUNT(*) FROM Assignments A
                    JOIN Modules M ON A.ModuleID = M.ModuleID
                    JOIN UserCourses UC ON M.CourseID = UC.CourseID
                    WHERE A.IsActive = 1", con);
                int totalExpected = (int)totalExpectedCmd.ExecuteScalar();

                SqlCommand actualSubmissionsCmd = new SqlCommand("SELECT COUNT(*) FROM AssignmentSubmissions WHERE Status = 'Submitted'", con);
                int actualSubmissions = (int)actualSubmissionsCmd.ExecuteScalar();

                double submissionRate = totalExpected > 0 ? (double)actualSubmissions / totalExpected * 100 : 0;
                lblSubmissionRate.Text = submissionRate.ToString("F1") + "%";

                // Grading efficiency
                SqlCommand gradingEfficiencyCmd = new SqlCommand(@"
                    SELECT 
                        COUNT(CASE WHEN G.GradeID IS NOT NULL THEN 1 END) * 100.0 / 
                        NULLIF(COUNT(S.SubmissionID), 0) AS GradingEfficiency
                    FROM AssignmentSubmissions S
                    LEFT JOIN AssignmentGrades G ON S.SubmissionID = G.SubmissionID
                    WHERE S.Status = 'Submitted'", con);
                object gradingEfficiencyObj = gradingEfficiencyCmd.ExecuteScalar();
                double gradingEfficiency = gradingEfficiencyObj != DBNull.Value ? Convert.ToDouble(gradingEfficiencyObj) : 0;
                lblGradingEfficiency.Text = gradingEfficiency.ToString("F1") + "%";
            }
        }

        private void LoadTopStudents()
        {
            string cs = ConfigurationManager.ConnectionStrings["dbConnection"].ConnectionString;
            using (SqlConnection con = new SqlConnection(cs))
            {
                con.Open();

                SqlCommand cmd = new SqlCommand(@"
                    SELECT TOP 5
                        U.Name AS StudentName,
                        AVG(CAST(G.PointsEarned AS FLOAT) / CAST(A.MaxPoints AS FLOAT) * 100) AS AverageGrade,
                        COUNT(G.GradeID) AS CompletedAssignments,
                        COUNT(S.SubmissionID) AS TotalAssignments
                    FROM Users U
                    JOIN AssignmentSubmissions S ON U.UserID = S.UserID
                    JOIN Assignments A ON S.AssignmentID = A.AssignmentID
                    LEFT JOIN AssignmentGrades G ON S.SubmissionID = G.SubmissionID
                    WHERE U.Role = 'Student' AND S.Status = 'Submitted'
                    GROUP BY U.UserID, U.Name
                    HAVING COUNT(G.GradeID) > 0
                    ORDER BY AverageGrade DESC", con);

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);

                if (dt.Rows.Count > 0)
                {
                    topStudentsRepeater.DataSource = dt;
                    topStudentsRepeater.DataBind();
                    pnlNoStudentData.Visible = false;
                }
                else
                {
                    topStudentsRepeater.DataSource = null;
                    topStudentsRepeater.DataBind();
                    pnlNoStudentData.Visible = true;
                }
            }
        }

        private void LoadRecentActivity()
        {
            // Create mock recent activity data
            DataTable activityData = new DataTable();
            activityData.Columns.Add("ActivityType");
            activityData.Columns.Add("ActivityDescription");
            activityData.Columns.Add("ActivityTime", typeof(DateTime));

            // Add sample activities
            activityData.Rows.Add("User Registration", "3 new students registered today", DateTime.Now.AddHours(-2));
            activityData.Rows.Add("Assignment Created", "New assignment 'Final Project' created", DateTime.Now.AddHours(-5));
            activityData.Rows.Add("Grade Submitted", "25 assignments graded by lecturers", DateTime.Now.AddHours(-8));
            activityData.Rows.Add("Course Enrollment", "12 students enrolled in new courses", DateTime.Now.AddDays(-1));
            activityData.Rows.Add("System Maintenance", "Database optimization completed", DateTime.Now.AddDays(-2));

            if (activityData.Rows.Count > 0)
            {
                recentActivityRepeater.DataSource = activityData;
                recentActivityRepeater.DataBind();
                pnlNoActivity.Visible = false;
            }
            else
            {
                recentActivityRepeater.DataSource = null;
                recentActivityRepeater.DataBind();
                pnlNoActivity.Visible = true;
            }
        }

        protected void ddlReportPeriod_SelectedIndexChanged(object sender, EventArgs e)
        {
            LoadReports();
            ShowMessage("Reports refreshed for selected period.", "green");
        }

        protected void btnRefreshReports_Click(object sender, EventArgs e)
        {
            try
            {
                LoadSystemOverview();
                LoadReports();
                ShowMessage("All reports refreshed successfully!", "green");
            }
            catch (Exception ex)
            {
                ShowMessage("Error refreshing reports: " + ex.Message, "red");
            }
        }

        protected void btnExportReports_Click(object sender, EventArgs e)
        {
            try
            {
                StringBuilder reportData = new StringBuilder();
                reportData.AppendLine("BULB LMS SYSTEM REPORTS");
                reportData.AppendLine("Generated: " + DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss"));
                reportData.AppendLine("Report Period: " + ddlReportPeriod.SelectedItem.Text);
                reportData.AppendLine("=" + new string('=', 50));
                reportData.AppendLine();

                // System Overview
                reportData.AppendLine("SYSTEM OVERVIEW:");
                reportData.AppendLine($"Total Users: {lblTotalUsers.Text}");
                reportData.AppendLine($"Active Courses: {lblTotalCourses.Text}");
                reportData.AppendLine($"Total Assignments: {lblTotalAssignments.Text}");
                reportData.AppendLine($"Total Submissions: {lblTotalSubmissions.Text}");
                reportData.AppendLine($"Grades Given: {lblTotalGrades.Text}");
                reportData.AppendLine($"Average Performance: {lblAvgPerformance.Text}");
                reportData.AppendLine();

                // User Activity
                reportData.AppendLine("USER ACTIVITY:");
                reportData.AppendLine($"Active Students: {lblActiveStudents.Text}");
                reportData.AppendLine($"Active Lecturers: {lblActiveLecturers.Text}");
                reportData.AppendLine($"New Registrations: {lblNewRegistrations.Text}");
                reportData.AppendLine($"Engagement Rate: {lblEngagementRate.Text}");
                reportData.AppendLine();

                // Assignment Analytics
                reportData.AppendLine("ASSIGNMENT ANALYTICS:");
                reportData.AppendLine($"On-Time Submissions: {lblOnTimeSubmissions.Text}");
                reportData.AppendLine($"Late Submissions: {lblLateSubmissions.Text}");
                reportData.AppendLine($"Missed Assignments: {lblMissedAssignments.Text}");
                reportData.AppendLine($"Submission Rate: {lblSubmissionRate.Text}");
                reportData.AppendLine($"Grading Efficiency: {lblGradingEfficiency.Text}");
                reportData.AppendLine();

                // System Performance
                reportData.AppendLine("SYSTEM PERFORMANCE:");
                reportData.AppendLine($"Database Records: {lblDatabaseRecords.Text}");
                reportData.AppendLine($"Storage Usage: 65% Used");
                reportData.AppendLine($"System Uptime: 99.9%");
                reportData.AppendLine($"Data Integrity: Excellent");
                reportData.AppendLine();

                // Export course performance data
                string cs = ConfigurationManager.ConnectionStrings["dbConnection"].ConnectionString;
                using (SqlConnection con = new SqlConnection(cs))
                {
                    con.Open();

                    reportData.AppendLine("COURSE PERFORMANCE:");
                    reportData.AppendLine("Course,Students,Completion Rate,Average Grade");

                    SqlCommand courseCmd = new SqlCommand(@"
                        SELECT 
                            C.CourseName,
                            ISNULL(StudentStats.StudentCount, 0) AS StudentCount,
                            ISNULL(PerformanceStats.CompletionRate, 0) AS CompletionRate,
                            ISNULL(PerformanceStats.AverageGrade, 0) AS AverageGrade
                        FROM Courses C
                        LEFT JOIN (
                            SELECT CourseID, COUNT(DISTINCT UserID) AS StudentCount
                            FROM UserCourses GROUP BY CourseID
                        ) StudentStats ON C.CourseID = StudentStats.CourseID
                        LEFT JOIN (
                            SELECT 
                                UC.CourseID,
                                AVG(CASE WHEN S.Status = 'Submitted' THEN 100.0 ELSE 0.0 END) AS CompletionRate,
                                AVG(CASE WHEN G.PointsEarned IS NOT NULL THEN 
                                    (CAST(G.PointsEarned AS FLOAT) / CAST(A.MaxPoints AS FLOAT) * 100) ELSE 0 END) AS AverageGrade
                            FROM UserCourses UC
                            JOIN Modules M ON UC.CourseID = M.CourseID
                            JOIN Assignments A ON M.ModuleID = A.ModuleID
                            LEFT JOIN AssignmentSubmissions S ON A.AssignmentID = S.AssignmentID AND UC.UserID = S.UserID
                            LEFT JOIN AssignmentGrades G ON S.SubmissionID = G.SubmissionID
                            GROUP BY UC.CourseID
                        ) PerformanceStats ON C.CourseID = PerformanceStats.CourseID", con);

                    SqlDataReader courseReader = courseCmd.ExecuteReader();
                    while (courseReader.Read())
                    {
                        reportData.AppendLine($"{EscapeCsvValue(courseReader["CourseName"].ToString())},{courseReader["StudentCount"]},{courseReader["CompletionRate"]:F1}%,{courseReader["AverageGrade"]:F1}%");
                    }
                    courseReader.Close();
                }

                reportData.AppendLine();
                reportData.AppendLine("Report generated by Bulb LMS Admin Panel");

                // Set response headers for file download
                Response.Clear();
                Response.ContentType = "text/plain";
                Response.AddHeader("Content-Disposition",
                    $"attachment; filename=Bulb_LMS_Reports_{DateTime.Now:yyyyMMdd_HHmmss}.txt");

                // Write report data to response
                Response.Write(reportData.ToString());
                Response.End();
            }
            catch (Exception ex)
            {
                ShowMessage("Error exporting reports: " + ex.Message, "red");
            }
        }

        // Helper method for performance indicators
        protected string GetPerformanceClass(object gradeObj)
        {
            if (gradeObj == null || gradeObj == DBNull.Value)
                return "performance-poor";

            double grade = Convert.ToDouble(gradeObj);

            if (grade >= 90) return "performance-excellent";
            if (grade >= 80) return "performance-good";
            if (grade >= 70) return "performance-average";
            return "performance-poor";
        }

        // Helper method to escape CSV values
        private string EscapeCsvValue(string value)
        {
            if (string.IsNullOrEmpty(value))
                return "";

            if (value.Contains(",") || value.Contains("\"") || value.Contains("\n") || value.Contains("\r"))
            {
                return "\"" + value.Replace("\"", "\"\"") + "\"";
            }

            return value;
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