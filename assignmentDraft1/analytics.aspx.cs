using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace assignmentDraft1
{
    public partial class analytics : System.Web.UI.Page
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
                LoadCourseDropdown();
                LoadAnalyticsData();
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

        private void LoadCourseDropdown()
        {
            string cs = ConfigurationManager.ConnectionStrings["dbConnection"].ConnectionString;
            using (SqlConnection con = new SqlConnection(cs))
            {
                con.Open();

                // Get courses that this lecturer teaches
                SqlCommand cmd = new SqlCommand(@"
                    SELECT DISTINCT C.CourseID, C.CourseName 
                    FROM Courses C
                    INNER JOIN Modules M ON C.CourseID = M.CourseID
                    INNER JOIN Lecturers L ON M.LecturerID = L.LecturerID
                    WHERE L.LecturerID = @LecturerID
                    ORDER BY C.CourseName", con);
                cmd.Parameters.AddWithValue("@LecturerID", lecturerId);

                SqlDataReader reader = cmd.ExecuteReader();

                // Clear and populate course dropdown
                ddlCourseFilter.Items.Clear();
                ddlCourseFilter.Items.Add(new ListItem("All Courses", ""));

                // Add courses to the grade filter dropdown as well
                ddlGradeFilter.Items.Clear();
                ddlGradeFilter.Items.Add(new ListItem("All Assignments", ""));

                while (reader.Read())
                {
                    ddlCourseFilter.Items.Add(new ListItem(reader["CourseName"].ToString(), reader["CourseID"].ToString()));
                }
                reader.Close();

                // Get assignments for grade filter
                SqlCommand assignmentCmd = new SqlCommand(@"
                    SELECT A.AssignmentID, A.Title, C.CourseName
                    FROM Assignments A
                    INNER JOIN Modules M ON A.ModuleID = M.ModuleID
                    INNER JOIN Courses C ON M.CourseID = C.CourseID
                    WHERE M.LecturerID = @LecturerID
                    ORDER BY A.DueDate DESC", con);
                assignmentCmd.Parameters.AddWithValue("@LecturerID", lecturerId);

                SqlDataReader assignmentReader = assignmentCmd.ExecuteReader();
                while (assignmentReader.Read())
                {
                    string displayText = $"{assignmentReader["Title"]} ({assignmentReader["CourseName"]})";
                    ddlGradeFilter.Items.Add(new ListItem(displayText, assignmentReader["AssignmentID"].ToString()));
                }
                assignmentReader.Close();
            }
        }

        private void LoadAnalyticsData()
        {
            try
            {
                string cs = ConfigurationManager.ConnectionStrings["dbConnection"].ConnectionString;
                using (SqlConnection con = new SqlConnection(cs))
                {
                    con.Open();

                    string selectedCourseId = ddlCourseFilter.SelectedValue;
                    string courseFilter = string.IsNullOrEmpty(selectedCourseId) ? "" : " AND C.CourseID = @CourseID";

                    // Get total students count for this lecturer
                    SqlCommand studentsCmd = new SqlCommand(@"
                        SELECT COUNT(DISTINCT UC.UserID) 
                        FROM UserCourses UC
                        INNER JOIN Courses C ON UC.CourseID = C.CourseID
                        INNER JOIN Modules M ON C.CourseID = M.CourseID
                        INNER JOIN Lecturers L ON M.LecturerID = L.LecturerID
                        INNER JOIN Users U ON UC.UserID = U.UserID
                        WHERE L.LecturerID = @LecturerID AND U.Role = 'Student'" + courseFilter, con);
                    studentsCmd.Parameters.AddWithValue("@LecturerID", lecturerId);
                    if (!string.IsNullOrEmpty(selectedCourseId))
                    {
                        studentsCmd.Parameters.AddWithValue("@CourseID", selectedCourseId);
                    }

                    object studentCountObj = studentsCmd.ExecuteScalar();
                    int studentCount = studentCountObj != null ? Convert.ToInt32(studentCountObj) : 0;
                    lblTotalStudents.Text = studentCount.ToString();

                    // Calculate growth from previous period (30 days ago)
                    SqlCommand prevStudentsCmd = new SqlCommand(@"
                        SELECT COUNT(DISTINCT UC.UserID) 
                        FROM UserCourses UC
                        INNER JOIN Courses C ON UC.CourseID = C.CourseID
                        INNER JOIN Modules M ON C.CourseID = M.CourseID
                        INNER JOIN Lecturers L ON M.LecturerID = L.LecturerID
                        INNER JOIN Users U ON UC.UserID = U.UserID
                        WHERE L.LecturerID = @LecturerID AND U.Role = 'Student' 
                        AND UC.EnrollmentDate < DATEADD(day, -30, GETDATE())" + courseFilter, con);
                    prevStudentsCmd.Parameters.AddWithValue("@LecturerID", lecturerId);
                    if (!string.IsNullOrEmpty(selectedCourseId))
                    {
                        prevStudentsCmd.Parameters.AddWithValue("@CourseID", selectedCourseId);
                    }

                    object prevStudentCountObj = prevStudentsCmd.ExecuteScalar();
                    int prevStudentCount = prevStudentCountObj != null ? Convert.ToInt32(prevStudentCountObj) : 0;

                    // Calculate growth percentage
                    int studentGrowth = prevStudentCount > 0
                        ? (int)Math.Round(((double)(studentCount - prevStudentCount) / prevStudentCount) * 100)
                        : 0;

                    lblStudentGrowth.Text = $"{studentGrowth}%";

                    // If growth is negative, change the icon class
                    if (studentGrowth < 0)
                    {
                        ClientScript.RegisterStartupScript(this.GetType(), "updateStudentGrowthIcon",
                            "$('.trend-up').eq(0).removeClass('trend-up').addClass('trend-down').removeClass('fa-arrow-up').addClass('fa-arrow-down');", true);
                    }

                    // Get assignment completion rate
                    SqlCommand completionCmd = new SqlCommand(@"
                        SELECT 
                            COUNT(DISTINCT S.SubmissionID) as Submissions,
                            (SELECT COUNT(DISTINCT UC.UserID) * COUNT(DISTINCT A.AssignmentID)
                             FROM UserCourses UC
                             INNER JOIN Courses C ON UC.CourseID = C.CourseID
                             INNER JOIN Modules M ON C.CourseID = M.CourseID
                             INNER JOIN Assignments A ON M.ModuleID = A.ModuleID
                             INNER JOIN Users U ON UC.UserID = U.UserID
                             WHERE M.LecturerID = @LecturerID AND U.Role = 'Student' AND A.IsActive = 1" + courseFilter + @") as PossibleSubmissions
                        FROM AssignmentSubmissions S
                        INNER JOIN Assignments A ON S.AssignmentID = A.AssignmentID
                        INNER JOIN Modules M ON A.ModuleID = M.ModuleID
                        INNER JOIN Courses C ON M.CourseID = C.CourseID
                        WHERE M.LecturerID = @LecturerID AND S.Status = 'Submitted'" + courseFilter, con);
                    completionCmd.Parameters.AddWithValue("@LecturerID", lecturerId);
                    if (!string.IsNullOrEmpty(selectedCourseId))
                    {
                        completionCmd.Parameters.AddWithValue("@CourseID", selectedCourseId);
                    }

                    SqlDataReader completionReader = completionCmd.ExecuteReader();
                    int submissions = 0;
                    int possibleSubmissions = 0;

                    if (completionReader.Read())
                    {
                        submissions = Convert.ToInt32(completionReader["Submissions"]);
                        possibleSubmissions = Convert.ToInt32(completionReader["PossibleSubmissions"]);
                    }
                    completionReader.Close();

                    double completionRate = possibleSubmissions > 0 ? (double)submissions / possibleSubmissions * 100 : 0;
                    lblCompletionRate.Text = $"{completionRate:F0}%";

                    // Get completion rate from previous 30 days
                    SqlCommand prevCompletionCmd = new SqlCommand(@"
                        SELECT 
                            (SELECT COUNT(*) 
                             FROM AssignmentSubmissions S
                             INNER JOIN Assignments A ON S.AssignmentID = A.AssignmentID
                             INNER JOIN Modules M ON A.ModuleID = M.ModuleID
                             INNER JOIN Courses C ON M.CourseID = C.CourseID
                             WHERE M.LecturerID = @LecturerID 
                             AND S.Status = 'Submitted'
                             AND S.SubmissionDate BETWEEN DATEADD(day, -60, GETDATE()) AND DATEADD(day, -30, GETDATE())" + courseFilter + @") as PrevSubmissions,
                            
                            (SELECT COUNT(DISTINCT UC.UserID) * COUNT(DISTINCT A.AssignmentID)
                             FROM UserCourses UC
                             INNER JOIN Courses C ON UC.CourseID = C.CourseID
                             INNER JOIN Modules M ON C.CourseID = M.CourseID
                             INNER JOIN Assignments A ON M.ModuleID = A.ModuleID
                             INNER JOIN Users U ON UC.UserID = U.UserID
                             WHERE M.LecturerID = @LecturerID AND U.Role = 'Student' 
                             AND A.DueDate BETWEEN DATEADD(day, -60, GETDATE()) AND DATEADD(day, -30, GETDATE())" + courseFilter + @") as PrevPossible", con);
                    prevCompletionCmd.Parameters.AddWithValue("@LecturerID", lecturerId);
                    if (!string.IsNullOrEmpty(selectedCourseId))
                    {
                        prevCompletionCmd.Parameters.AddWithValue("@CourseID", selectedCourseId);
                    }

                    SqlDataReader prevCompletionReader = prevCompletionCmd.ExecuteReader();
                    int prevSubmissions = 0;
                    int prevPossible = 0;

                    if (prevCompletionReader.Read())
                    {
                        prevSubmissions = Convert.ToInt32(prevCompletionReader["PrevSubmissions"]);
                        prevPossible = Convert.ToInt32(prevCompletionReader["PrevPossible"]);
                    }
                    prevCompletionReader.Close();

                    double prevCompletionRate = prevPossible > 0 ? (double)prevSubmissions / prevPossible * 100 : 0;
                    int completionGrowth = prevCompletionRate > 0
                        ? (int)Math.Round(completionRate - prevCompletionRate)
                        : 0;

                    lblCompletionGrowth.Text = $"{completionGrowth}%";

                    // If growth is negative, change the icon class
                    if (completionGrowth < 0)
                    {
                        ClientScript.RegisterStartupScript(this.GetType(), "updateCompletionGrowthIcon",
                            "$('.trend-up').eq(1).removeClass('trend-up').addClass('trend-down').removeClass('fa-arrow-up').addClass('fa-arrow-down');", true);
                    }

                    // Get average grade
                    SqlCommand gradeCmd = new SqlCommand(@"
                        SELECT AVG(CAST(G.PointsEarned as FLOAT) / CAST(A.MaxPoints as FLOAT) * 100) as AvgGrade
                        FROM AssignmentGrades G
                        INNER JOIN AssignmentSubmissions S ON G.SubmissionID = S.SubmissionID
                        INNER JOIN Assignments A ON S.AssignmentID = A.AssignmentID
                        INNER JOIN Modules M ON A.ModuleID = M.ModuleID
                        INNER JOIN Courses C ON M.CourseID = C.CourseID
                        WHERE M.LecturerID = @LecturerID" + courseFilter, con);
                    gradeCmd.Parameters.AddWithValue("@LecturerID", lecturerId);
                    if (!string.IsNullOrEmpty(selectedCourseId))
                    {
                        gradeCmd.Parameters.AddWithValue("@CourseID", selectedCourseId);
                    }

                    object avgGradeObj = gradeCmd.ExecuteScalar();
                    double avgGrade = 0;

                    if (avgGradeObj != DBNull.Value && avgGradeObj != null)
                    {
                        avgGrade = Convert.ToDouble(avgGradeObj);
                        lblAverageGrade.Text = $"{avgGrade:F0}%";
                    }
                    else
                    {
                        lblAverageGrade.Text = "N/A";
                    }

                    // Get average grade from previous 30 days
                    SqlCommand prevGradeCmd = new SqlCommand(@"
                        SELECT AVG(CAST(G.PointsEarned as FLOAT) / CAST(A.MaxPoints as FLOAT) * 100) as AvgGrade
                        FROM AssignmentGrades G
                        INNER JOIN AssignmentSubmissions S ON G.SubmissionID = S.SubmissionID
                        INNER JOIN Assignments A ON S.AssignmentID = A.AssignmentID
                        INNER JOIN Modules M ON A.ModuleID = M.ModuleID
                        INNER JOIN Courses C ON M.CourseID = C.CourseID
                        WHERE M.LecturerID = @LecturerID 
                        AND G.GradedDate BETWEEN DATEADD(day, -60, GETDATE()) AND DATEADD(day, -30, GETDATE())" + courseFilter, con);
                    prevGradeCmd.Parameters.AddWithValue("@LecturerID", lecturerId);
                    if (!string.IsNullOrEmpty(selectedCourseId))
                    {
                        prevGradeCmd.Parameters.AddWithValue("@CourseID", selectedCourseId);
                    }

                    object prevAvgGradeObj = prevGradeCmd.ExecuteScalar();
                    double prevAvgGrade = 0;

                    if (prevAvgGradeObj != DBNull.Value && prevAvgGradeObj != null)
                    {
                        prevAvgGrade = Convert.ToDouble(prevAvgGradeObj);
                    }

                    int gradeGrowth = prevAvgGrade > 0
                        ? (int)Math.Round(avgGrade - prevAvgGrade)
                        : 0;

                    lblGradeGrowth.Text = $"{gradeGrowth}%";

                    // If growth is positive, change the icon class
                    if (gradeGrowth > 0)
                    {
                        ClientScript.RegisterStartupScript(this.GetType(), "updateGradeGrowthIcon",
                            "$('.trend-down').eq(0).removeClass('trend-down').addClass('trend-up').removeClass('fa-arrow-down').addClass('fa-arrow-up');", true);
                    }

                    // Get active assignments count
                    SqlCommand activeAssignmentsCmd = new SqlCommand(@"
                        SELECT COUNT(*) 
                        FROM Assignments A
                        INNER JOIN Modules M ON A.ModuleID = M.ModuleID
                        INNER JOIN Courses C ON M.CourseID = C.CourseID
                        WHERE M.LecturerID = @LecturerID AND A.IsActive = 1 AND A.DueDate > GETDATE()" + courseFilter, con);
                    activeAssignmentsCmd.Parameters.AddWithValue("@LecturerID", lecturerId);
                    if (!string.IsNullOrEmpty(selectedCourseId))
                    {
                        activeAssignmentsCmd.Parameters.AddWithValue("@CourseID", selectedCourseId);
                    }

                    object activeAssignmentsObj = activeAssignmentsCmd.ExecuteScalar();
                    int activeAssignments = activeAssignmentsObj != null ? Convert.ToInt32(activeAssignmentsObj) : 0;
                    lblActiveAssignments.Text = activeAssignments.ToString();

                    // Get active assignments from previous 30 days
                    SqlCommand prevAssignmentsCmd = new SqlCommand(@"
                        SELECT COUNT(*) 
                        FROM Assignments A
                        INNER JOIN Modules M ON A.ModuleID = M.ModuleID
                        INNER JOIN Courses C ON M.CourseID = C.CourseID
                        WHERE M.LecturerID = @LecturerID AND A.IsActive = 1 
                        AND A.CreatedDate BETWEEN DATEADD(day, -60, GETDATE()) AND DATEADD(day, -30, GETDATE())" + courseFilter, con);
                    prevAssignmentsCmd.Parameters.AddWithValue("@LecturerID", lecturerId);
                    if (!string.IsNullOrEmpty(selectedCourseId))
                    {
                        prevAssignmentsCmd.Parameters.AddWithValue("@CourseID", selectedCourseId);
                    }

                    object prevAssignmentsObj = prevAssignmentsCmd.ExecuteScalar();
                    int prevActiveAssignments = prevAssignmentsObj != null ? Convert.ToInt32(prevAssignmentsObj) : 0;

                    int assignmentGrowth = prevActiveAssignments > 0
                        ? (int)Math.Round(((double)(activeAssignments - prevActiveAssignments) / prevActiveAssignments) * 100)
                        : 0;

                    lblAssignmentGrowth.Text = $"{assignmentGrowth}%";

                    // If growth is negative, change the icon class
                    if (assignmentGrowth < 0)
                    {
                        ClientScript.RegisterStartupScript(this.GetType(), "updateAssignmentGrowthIcon",
                            "$('.trend-up').eq(2).removeClass('trend-up').addClass('trend-down').removeClass('fa-arrow-up').addClass('fa-arrow-down');", true);
                    }

                    // Load charts data
                    LoadPerformanceChartData(con, selectedCourseId);
                    LoadAssignmentCompletionData(con, selectedCourseId);
                    LoadGradeDistributionData(con, selectedCourseId);

                    // Load detailed analysis data
                    LoadSubmissionAnalytics(con, selectedCourseId);
                    LoadTopStudents(con, selectedCourseId);
                    LoadAssignmentsRequiringAttention(con, selectedCourseId);
                    LoadCourseEngagementData(con);
                    LoadGradeSummary(con, selectedCourseId);

                    // Initialize the progress bars
                    ClientScript.RegisterStartupScript(this.GetType(), "initProgressBars",
                        "setTimeout(function() { initializeProgressBars(); }, 500);", true);
                }
            }
            catch (Exception ex)
            {
                ShowMessage("Error loading analytics data: " + ex.Message, "error");
            }
        }

        #region Page Event Handlers

        protected void DdlCourseFilter_SelectedIndexChanged(object sender, EventArgs e)
        {
            LoadAnalyticsData();
        }

        protected void DdlDateRange_SelectedIndexChanged(object sender, EventArgs e)
        {
            // Apply date filter based on selection
            int days = 0;
            if (int.TryParse(ddlDateRange.SelectedValue, out days))
            {
                DateTime startDate = DateTime.Now.AddDays(-days);
                txtStartDate.Text = startDate.ToString("yyyy-MM-dd");
                txtEndDate.Text = DateTime.Now.ToString("yyyy-MM-dd");
            }

            LoadAnalyticsData();
            ShowMessage("Date range updated.", "success");
        }

        protected void BtnApplyCustomDate_Click(object sender, EventArgs e)
        {
            if (string.IsNullOrEmpty(txtStartDate.Text) || string.IsNullOrEmpty(txtEndDate.Text))
            {
                ShowMessage("Please select both start and end dates.", "error");
                return;
            }

            DateTime startDate, endDate;
            if (!DateTime.TryParse(txtStartDate.Text, out startDate) || !DateTime.TryParse(txtEndDate.Text, out endDate))
            {
                ShowMessage("Invalid date format.", "error");
                return;
            }

            if (startDate > endDate)
            {
                ShowMessage("Start date must be before end date.", "error");
                return;
            }

            // Reset date range dropdown to avoid confusion
            ddlDateRange.SelectedValue = "0";

            LoadAnalyticsData();
            ShowMessage("Custom date range applied.", "success");
        }

        protected void DdlPerformanceMetric_SelectedIndexChanged(object sender, EventArgs e)
        {
            string selectedMetric = ddlPerformanceMetric.SelectedValue;
            string metricTitle = ddlPerformanceMetric.SelectedItem.Text;

            // Update chart data based on selected metric
            ClientScript.RegisterStartupScript(this.GetType(), "updatePerformanceMetric",
                $@"
                setTimeout(function() {{
                    if (performanceChart) {{
                        performanceChart.data.datasets[0].label = '{metricTitle}';
                        
                        // In a production system, this would load different data based on the metric
                        if ('{selectedMetric}' === 'grade') {{
                            performanceChart.data.datasets[0].data = [75, 78, 72, 80, 82, 85];
                        }} else if ('{selectedMetric}' === 'completion') {{
                            performanceChart.data.datasets[0].data = [65, 70, 75, 80, 85, 90];
                        }} else if ('{selectedMetric}' === 'time') {{
                            performanceChart.data.datasets[0].data = [2.1, 1.8, 2.5, 1.9, 1.5, 1.2];
                        }}
                        
                        performanceChart.update();
                    }}
                }}, 500);
                ", true);

            ShowMessage("Performance metric updated.", "success");
        }

        protected void DdlAssignmentFilter_SelectedIndexChanged(object sender, EventArgs e)
        {
            string selectedFilter = ddlAssignmentFilter.SelectedValue;

            // Update chart data based on selected filter
            ClientScript.RegisterStartupScript(this.GetType(), "updateAssignmentFilter",
                $@"
                setTimeout(function() {{
                    if (assignmentChart) {{
                        // In a production system, this would load different data based on the filter
                        if ('{selectedFilter}' === 'active') {{
                            assignmentChart.data.labels = ['Active Assignment 1', 'Active Assignment 2', 'Active Assignment 3', 'Active Assignment 4'];
                            assignmentChart.data.datasets[0].data = [85, 65, 75, 60];
                        }} else if ('{selectedFilter}' === 'past') {{
                            assignmentChart.data.labels = ['Past Assignment 1', 'Past Assignment 2', 'Past Assignment 3'];
                            assignmentChart.data.datasets[0].data = [95, 90, 92];
                        }} else {{
                            assignmentChart.data.labels = ['Assignment 1', 'Assignment 2', 'Assignment 3', 'Assignment 4', 'Assignment 5'];
                            assignmentChart.data.datasets[0].data = [95, 82, 78, 90, 65];
                        }}
                        
                        assignmentChart.update();
                    }}
                }}, 500);
                ", true);

            ShowMessage("Assignment filter applied.", "success");
        }

        protected void DdlEngagementMetric_SelectedIndexChanged(object sender, EventArgs e)
        {
            string selectedMetric = ddlEngagementMetric.SelectedValue;

            // Update chart data based on selected metric
            ClientScript.RegisterStartupScript(this.GetType(), "updateEngagementMetric",
                $@"
                setTimeout(function() {{
                    if (engagementChart) {{
                        // In a production system, this would load different data based on the metric
                        if ('{selectedMetric}' === 'activity') {{
                            engagementChart.data.datasets[0].data = [85, 70, 90, 60, 75];
                            engagementChart.data.datasets[1].data = [65, 85, 70, 75, 80];
                        }} else if ('{selectedMetric}' === 'completion') {{
                            engagementChart.data.datasets[0].data = [90, 75, 85, 65, 70];
                            engagementChart.data.datasets[1].data = [70, 80, 75, 85, 90];
                        }} else if ('{selectedMetric}' === 'progress') {{
                            engagementChart.data.datasets[0].data = [75, 80, 85, 70, 60];
                            engagementChart.data.datasets[1].data = [60, 70, 65, 75, 85];
                        }}
                        
                        engagementChart.update();
                    }}
                }}, 500);
                ", true);

            ShowMessage("Engagement metric updated.", "success");
        }

        protected void DdlGradeFilter_SelectedIndexChanged(object sender, EventArgs e)
        {
            string selectedAssignment = ddlGradeFilter.SelectedValue;

            // Update chart data based on selected assignment
            ClientScript.RegisterStartupScript(this.GetType(), "updateGradeFilter",
                $@"
                setTimeout(function() {{
                    if (gradeDistributionChart) {{
                        // In a production system, this would load grade distribution for the selected assignment
                        if ('{selectedAssignment}' !== '') {{
                            // Example: Different distribution for selected assignment
                            gradeDistributionChart.data.datasets[0].data = [10, 15, 30, 25, 20];
                        }} else {{
                            // Default overall distribution
                            gradeDistributionChart.data.datasets[0].data = [5, 10, 25, 35, 25];
                        }}
                        
                        gradeDistributionChart.update();
                    }}
                }}, 500);
                ", true);

            ShowMessage("Grade filter applied.", "success");
        }

        protected void BtnExportData_Click(object sender, EventArgs e)
        {
            try
            {
                // Create export file with real data
                string cs = ConfigurationManager.ConnectionStrings["dbConnection"].ConnectionString;
                using (SqlConnection con = new SqlConnection(cs))
                {
                    con.Open();

                    // Get the data to export
                    SqlCommand cmd = new SqlCommand(@"
                SELECT 
                    C.CourseName,
                    (SELECT COUNT(DISTINCT UC.UserID) FROM UserCourses UC WHERE UC.CourseID = C.CourseID) as Students,
                    CONVERT(DECIMAL(5,1), 
                        (SELECT AVG(CAST(G.PointsEarned as FLOAT) / CAST(A.MaxPoints as FLOAT) * 100)
                         FROM AssignmentGrades G
                         INNER JOIN AssignmentSubmissions S ON G.SubmissionID = S.SubmissionID
                         INNER JOIN Assignments A ON S.AssignmentID = A.AssignmentID
                         INNER JOIN Modules M ON A.ModuleID = M.ModuleID
                         WHERE M.CourseID = C.CourseID)
                    ) as AvgGrade,
                    CONVERT(DECIMAL(5,1), 
                        (SELECT COUNT(*) FROM AssignmentSubmissions S
                         INNER JOIN Assignments A ON S.AssignmentID = A.AssignmentID
                         INNER JOIN Modules M ON A.ModuleID = M.ModuleID
                         WHERE M.CourseID = C.CourseID) * 100.0 /
                        NULLIF((SELECT COUNT(DISTINCT UC.UserID) FROM UserCourses UC WHERE UC.CourseID = C.CourseID) *
                               (SELECT COUNT(*) FROM Assignments A
                                INNER JOIN Modules M ON A.ModuleID = M.ModuleID
                                WHERE M.CourseID = C.CourseID), 0)
                    ) as CompletionRate
                FROM Courses C
                INNER JOIN Modules M ON C.CourseID = M.CourseID
                WHERE M.LecturerID = @LecturerID
                GROUP BY C.CourseID, C.CourseName", con);

                    cmd.Parameters.AddWithValue("@LecturerID", lecturerId);

                    SqlDataReader reader = cmd.ExecuteReader();

                    // Build the CSV content
                    string fileName = $"AnalyticsReport_{DateTime.Now.ToString("yyyyMMdd")}.csv";
                    string header = "Course,Students,Avg Grade,Completion Rate";
                    string content = "";

                    while (reader.Read())
                    {
                        string courseName = reader["CourseName"].ToString().Replace(",", " ");
                        string students = reader["Students"].ToString();
                        string avgGrade = reader["AvgGrade"] != DBNull.Value ? reader["AvgGrade"].ToString() + "%" : "N/A";
                        string completionRate = reader["CompletionRate"] != DBNull.Value ? reader["CompletionRate"].ToString() + "%" : "N/A";

                        content += $"{courseName},{students},{avgGrade},{completionRate}\r\n";
                    }

                    reader.Close();

                    // If no data, add a dummy row
                    if (string.IsNullOrEmpty(content))
                    {
                        content = "No data available,0,0%,0%\r\n";
                    }

                    // Export the CSV
                    Response.Clear();
                    Response.Buffer = true;
                    Response.AddHeader("content-disposition", $"attachment;filename={fileName}");
                    Response.Charset = "";
                    Response.ContentType = "application/text";
                    Response.Output.Write(header + "\r\n" + content);
                    Response.Flush();
                    Response.End();
                }
            }
            catch (Exception ex)
            {
                ShowMessage("Error exporting data: " + ex.Message, "error");
            }
        }

        protected void BtnRefreshData_Click(object sender, EventArgs e)
        {
            LoadAnalyticsData();
            ShowMessage("Data refreshed successfully.", "success");
        }

        protected void BtnHeaderSearch_Click(object sender, EventArgs e)
        {
            string searchTerm = txtHeaderSearch.Text.Trim();

            if (string.IsNullOrEmpty(searchTerm))
            {
                ShowMessage("Please enter a search term.", "error");
                return;
            }

            // In a production system, this would search through analytics data
            // For now, just show a message
            ShowMessage($"Searching for '{searchTerm}'...", "success");

            // Example of how search could be implemented:
            ClientScript.RegisterStartupScript(this.GetType(), "searchHighlight",
                $@"
                setTimeout(function() {{
                    // Highlight any table row containing the search term
                    const searchTerm = '{searchTerm.ToLower()}';
                    const tables = document.querySelectorAll('.student-table');
                    
                    tables.forEach(table => {{
                        const rows = table.querySelectorAll('tbody tr');
                        rows.forEach(row => {{
                            const text = row.textContent.toLowerCase();
                            if (text.includes(searchTerm)) {{
                                row.style.backgroundColor = 'rgba(255, 255, 0, 0.2)';
                            }} else {{
                                row.style.backgroundColor = '';
                            }}
                        }});
                    }});
                }}, 500);
                ", true);
        }

        #endregion

        #region Helper Methods

        private void ShowMessage(string message, string type)
        {
            lblMessage.Text = message;
            lblMessage.ForeColor = type == "success" ? System.Drawing.Color.Green : System.Drawing.Color.Red;
            lblMessage.Visible = true;

            // Hide message after 5 seconds
            ClientScript.RegisterStartupScript(this.GetType(), "hideMessage",
                "setTimeout(function(){ document.getElementById('" + lblMessage.ClientID + "').style.display = 'none'; }, 5000);", true);
        }

        private void LoadTopStudents(SqlConnection con, string selectedCourseId)
        {
            string courseFilter = string.IsNullOrEmpty(selectedCourseId) ? "" : " AND C.CourseID = @CourseID";

            // Query to get top performing students
            SqlCommand cmd = new SqlCommand(@"
                SELECT TOP 5
                    U.Name,
                    U.username as Email,
                    C.CourseName,
                    CONVERT(DECIMAL(5,1), AVG(CAST(G.PointsEarned as FLOAT) / CAST(A.MaxPoints as FLOAT) * 100)) as AvgGrade,
                    COUNT(DISTINCT S.SubmissionID) as Submissions,
                    (SELECT COUNT(*) 
                     FROM Assignments A2 
                     INNER JOIN Modules M2 ON A2.ModuleID = M2.ModuleID 
                     WHERE M2.CourseID = C.CourseID) as TotalAssignments,
                    CONVERT(DECIMAL(5,1), (COUNT(DISTINCT S.SubmissionID) * 100.0 / 
                        (SELECT COUNT(*) 
                         FROM Assignments A2 
                         INNER JOIN Modules M2 ON A2.ModuleID = M2.ModuleID 
                         WHERE M2.CourseID = C.CourseID))) as CompletionRate
                FROM Users U
                INNER JOIN AssignmentSubmissions S ON U.UserID = S.UserID
                INNER JOIN AssignmentGrades G ON S.SubmissionID = G.SubmissionID
                INNER JOIN Assignments A ON S.AssignmentID = A.AssignmentID
                INNER JOIN Modules M ON A.ModuleID = M.ModuleID
                INNER JOIN Courses C ON M.CourseID = C.CourseID
                WHERE M.LecturerID = @LecturerID AND U.Role = 'Student'" + courseFilter + @"
                GROUP BY U.UserID, U.Name, U.username, C.CourseID, C.CourseName
                ORDER BY AVG(CAST(G.PointsEarned as FLOAT) / CAST(A.MaxPoints as FLOAT) * 100) DESC", con);

            cmd.Parameters.AddWithValue("@LecturerID", lecturerId);
            if (!string.IsNullOrEmpty(selectedCourseId))
            {
                cmd.Parameters.AddWithValue("@CourseID", selectedCourseId);
            }

            DataTable dt = new DataTable();
            SqlDataAdapter da = new SqlDataAdapter(cmd);
            da.Fill(dt);

            if (dt.Rows.Count > 0)
            {
                topStudentsRepeater.DataSource = dt;
                topStudentsRepeater.DataBind();
            }
            else
            {
                // If no data, show a message
                DataTable emptyTable = new DataTable();
                emptyTable.Columns.Add("Name");
                emptyTable.Columns.Add("Email");
                emptyTable.Columns.Add("CourseName");
                emptyTable.Columns.Add("AvgGrade");
                emptyTable.Columns.Add("Submissions");
                emptyTable.Columns.Add("CompletionRate");

                emptyTable.Rows.Add("No data available", "", "", "0", "0/0", "0");

                topStudentsRepeater.DataSource = emptyTable;
                topStudentsRepeater.DataBind();
            }
        }

        private void LoadAssignmentsRequiringAttention(SqlConnection con, string selectedCourseId)
        {
            string courseFilter = string.IsNullOrEmpty(selectedCourseId) ? "" : " AND C.CourseID = @CourseID";

            // Query to get assignments requiring attention
            SqlCommand cmd = new SqlCommand(@"
                SELECT TOP 5
                    A.Title,
                    C.CourseName,
                    A.DueDate,
                    CONVERT(DECIMAL(5,1), 
                        (SELECT COUNT(*) FROM AssignmentSubmissions WHERE AssignmentID = A.AssignmentID AND Status = 'Submitted') * 100.0 / 
                        NULLIF((SELECT COUNT(*) FROM UserCourses WHERE CourseID = C.CourseID), 0)
                    ) as SubmissionRate,
                    CASE 
                        WHEN (SELECT COUNT(*) FROM AssignmentSubmissions WHERE AssignmentID = A.AssignmentID AND Status = 'Submitted') = 0 THEN 0
                        ELSE CONVERT(DECIMAL(5,1), 
                            (SELECT AVG(CAST(G2.PointsEarned as FLOAT) / CAST(A2.MaxPoints as FLOAT) * 100)
                             FROM AssignmentGrades G2 
                             INNER JOIN AssignmentSubmissions S2 ON G2.SubmissionID = S2.SubmissionID
                             INNER JOIN Assignments A2 ON S2.AssignmentID = A2.AssignmentID
                             WHERE S2.AssignmentID = A.AssignmentID)
                        )
                    END as AvgGrade,
                    CASE 
                        WHEN A.DueDate < GETDATE() AND 
                             (SELECT COUNT(*) FROM AssignmentSubmissions WHERE AssignmentID = A.AssignmentID AND Status = 'Submitted') * 100.0 / 
                             NULLIF((SELECT COUNT(*) FROM UserCourses WHERE CourseID = C.CourseID), 0) < 70 
                             THEN 'Overdue' 
                        WHEN A.DueDate > GETDATE() AND A.DueDate < DATEADD(day, 7, GETDATE()) THEN 'Due Soon'
                        WHEN (SELECT AVG(CAST(G2.PointsEarned as FLOAT) / CAST(A2.MaxPoints as FLOAT) * 100)
                              FROM AssignmentGrades G2 
                              INNER JOIN AssignmentSubmissions S2 ON G2.SubmissionID = S2.SubmissionID
                              INNER JOIN Assignments A2 ON S2.AssignmentID = A2.AssignmentID
                              WHERE S2.AssignmentID = A.AssignmentID) < 70 THEN 'Low Grades'
                        WHEN (SELECT COUNT(*) FROM AssignmentSubmissions WHERE AssignmentID = A.AssignmentID AND Status = 'Submitted') * 100.0 / 
                             NULLIF((SELECT COUNT(*) FROM UserCourses WHERE CourseID = C.CourseID), 0) < 50 THEN 'Low Submission'
                        ELSE 'Needs Review'
                    END as Status,
                    CASE 
                        WHEN A.DueDate < GETDATE() AND 
                             (SELECT COUNT(*) FROM AssignmentSubmissions WHERE AssignmentID = A.AssignmentID AND Status = 'Submitted') * 100.0 / 
                             NULLIF((SELECT COUNT(*) FROM UserCourses WHERE CourseID = C.CourseID), 0) < 70 
                             THEN 'status-overdue' 
                        WHEN A.DueDate > GETDATE() AND A.DueDate < DATEADD(day, 7, GETDATE()) THEN 'status-pending'
                        WHEN (SELECT AVG(CAST(G2.PointsEarned as FLOAT) / CAST(A2.MaxPoints as FLOAT) * 100)
                              FROM AssignmentGrades G2 
                              INNER JOIN AssignmentSubmissions S2 ON G2.SubmissionID = S2.SubmissionID
                              INNER JOIN Assignments A2 ON S2.AssignmentID = A2.AssignmentID
                              WHERE S2.AssignmentID = A.AssignmentID) < 70 THEN 'status-warning'
                        WHEN (SELECT COUNT(*) FROM AssignmentSubmissions WHERE AssignmentID = A.AssignmentID AND Status = 'Submitted') * 100.0 / 
                             NULLIF((SELECT COUNT(*) FROM UserCourses WHERE CourseID = C.CourseID), 0) < 50 THEN 'status-warning'
                        ELSE 'status-pending'
                    END as StatusClass
                FROM Assignments A
                INNER JOIN Modules M ON A.ModuleID = M.ModuleID
                INNER JOIN Courses C ON M.CourseID = C.CourseID
                WHERE M.LecturerID = @LecturerID AND A.IsActive = 1" + courseFilter + @"
                ORDER BY 
                    CASE 
                        WHEN A.DueDate < GETDATE() THEN 0 
                        WHEN A.DueDate < DATEADD(day, 7, GETDATE()) THEN 1 
                        ELSE 2 
                    END,
                    A.DueDate", con);

            cmd.Parameters.AddWithValue("@LecturerID", lecturerId);
            if (!string.IsNullOrEmpty(selectedCourseId))
            {
                cmd.Parameters.AddWithValue("@CourseID", selectedCourseId);
            }

            DataTable dt = new DataTable();
            SqlDataAdapter da = new SqlDataAdapter(cmd);
            da.Fill(dt);

            if (dt.Rows.Count > 0)
            {
                assignmentAttentionRepeater.DataSource = dt;
                assignmentAttentionRepeater.DataBind();
            }
            else
            {
                // If no data, show a message
                DataTable emptyTable = new DataTable();
                emptyTable.Columns.Add("Title");
                emptyTable.Columns.Add("CourseName");
                emptyTable.Columns.Add("DueDate", typeof(DateTime));
                emptyTable.Columns.Add("SubmissionRate");
                emptyTable.Columns.Add("AvgGrade");
                emptyTable.Columns.Add("Status");
                emptyTable.Columns.Add("StatusClass");

                emptyTable.Rows.Add("No assignments requiring attention", "", DateTime.Now, "0", "0", "No Issues", "status-submitted");

                assignmentAttentionRepeater.DataSource = emptyTable;
                assignmentAttentionRepeater.DataBind();
            }
        }

        private void LoadSubmissionAnalytics(SqlConnection con, string selectedCourseId)
        {
            string courseFilter = string.IsNullOrEmpty(selectedCourseId) ? "" : " AND C.CourseID = @CourseID";

            // Get average submission time before deadline
            SqlCommand avgTimeCmd = new SqlCommand(@"
                SELECT AVG(DATEDIFF(day, S.SubmissionDate, A.DueDate)) as AvgDaysBeforeDeadline
                FROM AssignmentSubmissions S
                INNER JOIN Assignments A ON S.AssignmentID = A.AssignmentID
                INNER JOIN Modules M ON A.ModuleID = M.ModuleID
                INNER JOIN Courses C ON M.CourseID = C.CourseID
                WHERE M.LecturerID = @LecturerID AND S.Status = 'Submitted' AND S.SubmissionDate <= A.DueDate" + courseFilter, con);

            avgTimeCmd.Parameters.AddWithValue("@LecturerID", lecturerId);
            if (!string.IsNullOrEmpty(selectedCourseId))
            {
                avgTimeCmd.Parameters.AddWithValue("@CourseID", selectedCourseId);
            }

            object avgTimeObj = avgTimeCmd.ExecuteScalar();
            double avgDaysBeforeDeadline = 0;

            if (avgTimeObj != DBNull.Value && avgTimeObj != null)
            {
                avgDaysBeforeDeadline = Convert.ToDouble(avgTimeObj);
                lblAvgSubmissionTime.Text = $"{avgDaysBeforeDeadline:F1}";
            }
            else
            {
                lblAvgSubmissionTime.Text = "N/A";
            }

            // Get percentage of late submissions
            SqlCommand lateCmd = new SqlCommand(@"
                SELECT
                    (SELECT COUNT(*) 
                     FROM AssignmentSubmissions S
                     INNER JOIN Assignments A ON S.AssignmentID = A.AssignmentID
                     INNER JOIN Modules M ON A.ModuleID = M.ModuleID
                     INNER JOIN Courses C ON M.CourseID = C.CourseID
                     WHERE M.LecturerID = @LecturerID AND S.IsLate = 1" + courseFilter + @") * 100.0 /
                    NULLIF((SELECT COUNT(*) 
                     FROM AssignmentSubmissions S
                     INNER JOIN Assignments A ON S.AssignmentID = A.AssignmentID
                     INNER JOIN Modules M ON A.ModuleID = M.ModuleID
                     INNER JOIN Courses C ON M.CourseID = C.CourseID
                     WHERE M.LecturerID = @LecturerID" + courseFilter + @"), 0) as LatePercentage", con);

            lateCmd.Parameters.AddWithValue("@LecturerID", lecturerId);
            if (!string.IsNullOrEmpty(selectedCourseId))
            {
                lateCmd.Parameters.AddWithValue("@CourseID", selectedCourseId);
            }

            object lateObj = lateCmd.ExecuteScalar();
            double latePercentage = 0;

            if (lateObj != DBNull.Value && lateObj != null)
            {
                latePercentage = Convert.ToDouble(lateObj);
                lblLateSubmissions.Text = $"{latePercentage:F0}%";
            }
            else
            {
                lblLateSubmissions.Text = "0%";
            }

            // Get average time to grade assignments
            SqlCommand gradeTimeCmd = new SqlCommand(@"
                SELECT AVG(DATEDIFF(day, S.SubmissionDate, G.GradedDate)) as AvgDaysToGrade
                FROM AssignmentSubmissions S
                INNER JOIN AssignmentGrades G ON S.SubmissionID = G.SubmissionID
                INNER JOIN Assignments A ON S.AssignmentID = A.AssignmentID
                INNER JOIN Modules M ON A.ModuleID = M.ModuleID
                INNER JOIN Courses C ON M.CourseID = C.CourseID
                WHERE M.LecturerID = @LecturerID" + courseFilter, con);

            gradeTimeCmd.Parameters.AddWithValue("@LecturerID", lecturerId);
            if (!string.IsNullOrEmpty(selectedCourseId))
            {
                gradeTimeCmd.Parameters.AddWithValue("@CourseID", selectedCourseId);
            }

            object gradeTimeObj = gradeTimeCmd.ExecuteScalar();
            double avgDaysToGrade = 0;

            if (gradeTimeObj != DBNull.Value && gradeTimeObj != null)
            {
                avgDaysToGrade = Convert.ToDouble(gradeTimeObj);
                lblAvgGradeTime.Text = $"{avgDaysToGrade:F1}";
            }
            else
            {
                lblAvgGradeTime.Text = "N/A";
            }
        }

        private void LoadCourseEngagementData(SqlConnection con)
        {
            // Get active/inactive students
            SqlCommand activeCmd = new SqlCommand(@"
        SELECT
            (SELECT COUNT(DISTINCT S.UserID) 
             FROM AssignmentSubmissions S
             INNER JOIN Assignments A ON S.AssignmentID = A.AssignmentID
             INNER JOIN Modules M ON A.ModuleID = M.ModuleID
             WHERE M.LecturerID = @LecturerID AND S.SubmissionDate > DATEADD(day, -30, GETDATE())) * 100.0 /
            NULLIF((SELECT COUNT(DISTINCT UC.UserID)
             FROM UserCourses UC
             INNER JOIN Courses C ON UC.CourseID = C.CourseID
             INNER JOIN Modules M ON C.CourseID = M.CourseID
             WHERE M.LecturerID = @LecturerID), 0) as ActivePercentage,
             
            (SELECT COUNT(DISTINCT UC.UserID)
             FROM UserCourses UC
             INNER JOIN Courses C ON UC.CourseID = C.CourseID
             INNER JOIN Modules M ON C.CourseID = M.CourseID
             WHERE M.LecturerID = @LecturerID
             AND UC.UserID NOT IN (
                SELECT DISTINCT S.UserID 
                FROM AssignmentSubmissions S
                INNER JOIN Assignments A ON S.AssignmentID = A.AssignmentID
                INNER JOIN Modules M ON A.ModuleID = M.ModuleID
                WHERE M.LecturerID = @LecturerID AND S.SubmissionDate > DATEADD(day, -30, GETDATE())
             )) as InactiveCount", con);

            activeCmd.Parameters.AddWithValue("@LecturerID", lecturerId);

            SqlDataReader activeReader = activeCmd.ExecuteReader();
            if (activeReader.Read())
            {
                double activePercentage = 0;
                if (activeReader["ActivePercentage"] != DBNull.Value)
                {
                    activePercentage = Convert.ToDouble(activeReader["ActivePercentage"]);
                }

                int inactiveCount = 0;
                if (activeReader["InactiveCount"] != DBNull.Value)
                {
                    inactiveCount = Convert.ToInt32(activeReader["InactiveCount"]);
                }

                lblActiveStudents.Text = $"{activePercentage:F0}%";
                lblInactiveStudents.Text = inactiveCount.ToString();
            }
            else
            {
                lblActiveStudents.Text = "0%";
                lblInactiveStudents.Text = "0";
            }
            activeReader.Close();

            // Get most active course
            SqlCommand mostActiveCmd = new SqlCommand(@"
        SELECT TOP 1
            C.CourseName,
            (SELECT 
                COUNT(*) * 100.0 / 
                NULLIF(
                    (SELECT COUNT(*) FROM UserCourses UC2 WHERE UC2.CourseID = C.CourseID) *
                    (SELECT COUNT(*) FROM Assignments A2
                     INNER JOIN Modules M2 ON A2.ModuleID = M2.ModuleID
                     WHERE M2.CourseID = C.CourseID), 0)
             FROM AssignmentSubmissions S2
             INNER JOIN Assignments A2 ON S2.AssignmentID = A2.AssignmentID
             INNER JOIN Modules M2 ON A2.ModuleID = M2.ModuleID
             WHERE M2.CourseID = C.CourseID) as EngagementRate
        FROM Courses C
        INNER JOIN Modules M ON C.CourseID = M.CourseID
        WHERE M.LecturerID = @LecturerID
        GROUP BY C.CourseID, C.CourseName
        ORDER BY EngagementRate DESC", con);

            mostActiveCmd.Parameters.AddWithValue("@LecturerID", lecturerId);

            SqlDataReader mostActiveReader = mostActiveCmd.ExecuteReader();
            if (mostActiveReader.Read())
            {
                string courseName = mostActiveReader["CourseName"].ToString();
                double engagementRate = 0;

                if (mostActiveReader["EngagementRate"] != DBNull.Value)
                {
                    engagementRate = Convert.ToDouble(mostActiveReader["EngagementRate"]);
                }

                lblMostActiveCourse.Text = courseName;
                lblMostActiveCourseRate.Text = $"{engagementRate:F0}%";
            }
            else
            {
                lblMostActiveCourse.Text = "N/A";
                lblMostActiveCourseRate.Text = "0%";
            }
            mostActiveReader.Close();

            // Get course activity ranking
            SqlCommand courseActivityCmd = new SqlCommand(@"
        SELECT
            C.CourseName,
            (SELECT COUNT(DISTINCT UC.UserID) FROM UserCourses UC WHERE UC.CourseID = C.CourseID) as Students,
            (SELECT COUNT(*) FROM Assignments A
             INNER JOIN Modules M ON A.ModuleID = M.ModuleID
             WHERE M.CourseID = C.CourseID) as Assignments,
            CONVERT(DECIMAL(5,1), 
                (SELECT COUNT(*) FROM AssignmentSubmissions S
                 INNER JOIN Assignments A ON S.AssignmentID = A.AssignmentID
                 INNER JOIN Modules M ON A.ModuleID = M.ModuleID
                 WHERE M.CourseID = C.CourseID) * 100.0 /
                NULLIF((SELECT COUNT(DISTINCT UC.UserID) FROM UserCourses UC WHERE UC.CourseID = C.CourseID) *
                       (SELECT COUNT(*) FROM Assignments A
                        INNER JOIN Modules M ON A.ModuleID = M.ModuleID
                        WHERE M.CourseID = C.CourseID), 0)
            ) as AvgCompletion,
            CONVERT(DECIMAL(5,1),
                (SELECT AVG(CAST(G.PointsEarned as FLOAT) / CAST(A.MaxPoints as FLOAT) * 100)
                 FROM AssignmentGrades G
                 INNER JOIN AssignmentSubmissions S ON G.SubmissionID = S.SubmissionID
                 INNER JOIN Assignments A ON S.AssignmentID = A.AssignmentID
                 INNER JOIN Modules M ON A.ModuleID = M.ModuleID
                 WHERE M.CourseID = C.CourseID)
            ) as AvgGrade,
            CONVERT(DECIMAL(5,1),
                (SELECT COUNT(*) FROM AssignmentSubmissions S2
                 INNER JOIN Assignments A2 ON S2.AssignmentID = A2.AssignmentID
                 INNER JOIN Modules M2 ON A2.ModuleID = M2.ModuleID
                 WHERE M2.CourseID = C.CourseID) * 100.0 /
                NULLIF((SELECT COUNT(DISTINCT UC2.UserID) FROM UserCourses UC2 WHERE UC2.CourseID = C.CourseID) *
                       (SELECT COUNT(*) FROM Assignments A2
                        INNER JOIN Modules M2 ON A2.ModuleID = M2.ModuleID
                        WHERE M2.CourseID = C.CourseID), 0) +
                ISNULL((SELECT AVG(CAST(G2.PointsEarned as FLOAT) / CAST(A2.MaxPoints as FLOAT) * 100)
                 FROM AssignmentGrades G2
                 INNER JOIN AssignmentSubmissions S2 ON G2.SubmissionID = S2.SubmissionID
                 INNER JOIN Assignments A2 ON S2.AssignmentID = A2.AssignmentID
                 INNER JOIN Modules M2 ON A2.ModuleID = M2.ModuleID
                 WHERE M2.CourseID = C.CourseID), 0)
            ) / 2 as EngagementScore
        FROM Courses C
        INNER JOIN Modules M ON C.CourseID = M.CourseID
        WHERE M.LecturerID = @LecturerID
        GROUP BY C.CourseID, C.CourseName
        ORDER BY EngagementScore DESC", con);

            courseActivityCmd.Parameters.AddWithValue("@LecturerID", lecturerId);

            DataTable courseActivityDt = new DataTable();
            SqlDataAdapter da = new SqlDataAdapter(courseActivityCmd);
            da.Fill(courseActivityDt);

            if (courseActivityDt.Rows.Count > 0)
            {
                courseActivityRepeater.DataSource = courseActivityDt;
                courseActivityRepeater.DataBind();
            }
            else
            {
                // If no data, show a message
                DataTable emptyTable = new DataTable();
                emptyTable.Columns.Add("CourseName");
                emptyTable.Columns.Add("Students");
                emptyTable.Columns.Add("Assignments");
                emptyTable.Columns.Add("AvgCompletion");
                emptyTable.Columns.Add("AvgGrade");
                emptyTable.Columns.Add("EngagementScore");

                emptyTable.Rows.Add("No course data available", "0", "0", "0", "0", "0");

                courseActivityRepeater.DataSource = emptyTable;
                courseActivityRepeater.DataBind();
            }

            // Get engagement insights data
            LoadEngagementInsights();
        }

        private void LoadGradeSummary(SqlConnection con, string selectedCourseId)
        {
            string courseFilter = string.IsNullOrEmpty(selectedCourseId) ? "" : " AND C.CourseID = @CourseID";

            // Get grade summary statistics
            SqlCommand gradeStatsCmd = new SqlCommand(@"
        SELECT
            MAX(CAST(G.PointsEarned as FLOAT) / CAST(A.MaxPoints as FLOAT) * 100) as HighestGrade,
            MIN(CAST(G.PointsEarned as FLOAT) / CAST(A.MaxPoints as FLOAT) * 100) as LowestGrade,
            AVG(CAST(G.PointsEarned as FLOAT) / CAST(A.MaxPoints as FLOAT) * 100) as MedianGrade,
            STDEV(CAST(G.PointsEarned as FLOAT) / CAST(A.MaxPoints as FLOAT) * 100) as StdDeviation,
            (SELECT TOP 1 U.Name
             FROM AssignmentGrades G2
             INNER JOIN AssignmentSubmissions S2 ON G2.SubmissionID = S2.SubmissionID
             INNER JOIN Users U ON S2.UserID = U.UserID
             INNER JOIN Assignments A2 ON S2.AssignmentID = A2.AssignmentID
             INNER JOIN Modules M2 ON A2.ModuleID = M2.ModuleID
             INNER JOIN Courses C2 ON M2.CourseID = C2.CourseID
             WHERE M2.LecturerID = @LecturerID" + courseFilter + @"
             ORDER BY CAST(G2.PointsEarned as FLOAT) / CAST(A2.MaxPoints as FLOAT) DESC) as HighestStudent,
            (SELECT TOP 1 U.Name
             FROM AssignmentGrades G2
             INNER JOIN AssignmentSubmissions S2 ON G2.SubmissionID = S2.SubmissionID
             INNER JOIN Users U ON S2.UserID = U.UserID
             INNER JOIN Assignments A2 ON S2.AssignmentID = A2.AssignmentID
             INNER JOIN Modules M2 ON A2.ModuleID = M2.ModuleID
             INNER JOIN Courses C2 ON M2.CourseID = C2.CourseID
             WHERE M2.LecturerID = @LecturerID" + courseFilter + @"
             ORDER BY CAST(G2.PointsEarned as FLOAT) / CAST(A2.MaxPoints as FLOAT)) as LowestStudent
        FROM AssignmentGrades G
        INNER JOIN AssignmentSubmissions S ON G.SubmissionID = S.SubmissionID
        INNER JOIN Assignments A ON S.AssignmentID = A.AssignmentID
        INNER JOIN Modules M ON A.ModuleID = M.ModuleID
        INNER JOIN Courses C ON M.CourseID = C.CourseID
        WHERE M.LecturerID = @LecturerID" + courseFilter, con);

            gradeStatsCmd.Parameters.AddWithValue("@LecturerID", lecturerId);
            if (!string.IsNullOrEmpty(selectedCourseId))
            {
                gradeStatsCmd.Parameters.AddWithValue("@CourseID", selectedCourseId);
            }

            SqlDataReader gradeStatsReader = gradeStatsCmd.ExecuteReader();
            if (gradeStatsReader.Read())
            {
                if (gradeStatsReader["HighestGrade"] != DBNull.Value)
                {
                    double highestGrade = Convert.ToDouble(gradeStatsReader["HighestGrade"]);
                    lblHighestGrade.Text = $"{highestGrade:F0}%";
                }
                else
                {
                    lblHighestGrade.Text = "N/A";
                }

                if (gradeStatsReader["LowestGrade"] != DBNull.Value)
                {
                    double lowestGrade = Convert.ToDouble(gradeStatsReader["LowestGrade"]);
                    lblLowestGrade.Text = $"{lowestGrade:F0}%";
                }
                else
                {
                    lblLowestGrade.Text = "N/A";
                }

                if (gradeStatsReader["MedianGrade"] != DBNull.Value)
                {
                    double medianGrade = Convert.ToDouble(gradeStatsReader["MedianGrade"]);
                    lblMedianGrade.Text = $"{medianGrade:F0}%";
                }
                else
                {
                    lblMedianGrade.Text = "N/A";
                }

                if (gradeStatsReader["StdDeviation"] != DBNull.Value)
                {
                    double stdDev = Convert.ToDouble(gradeStatsReader["StdDeviation"]);
                    lblGradeDeviation.Text = $"{stdDev:F1}";
                }
                else
                {
                    lblGradeDeviation.Text = "N/A";
                }

                lblHighestGradeStudent.Text = gradeStatsReader["HighestStudent"]?.ToString() ?? "N/A";
                lblLowestGradeStudent.Text = gradeStatsReader["LowestStudent"]?.ToString() ?? "N/A";
            }
            else
            {
                lblHighestGrade.Text = "N/A";
                lblLowestGrade.Text = "N/A";
                lblMedianGrade.Text = "N/A";
                lblGradeDeviation.Text = "N/A";
                lblHighestGradeStudent.Text = "N/A";
                lblLowestGradeStudent.Text = "N/A";
            }
            gradeStatsReader.Close();

            // Get grade distribution by assignment
            SqlCommand gradeSummaryCmd = new SqlCommand(@"
        SELECT 
            A.Title,
            C.CourseName,
            CONVERT(DECIMAL(5,1), AVG(CAST(G.PointsEarned as FLOAT) / CAST(A.MaxPoints as FLOAT) * 100)) as AvgGrade,
            CONVERT(DECIMAL(5,1), 
                (SELECT MAX(CAST(G2.PointsEarned as FLOAT) / CAST(A2.MaxPoints as FLOAT) * 100) 
                 FROM AssignmentGrades G2 
                 INNER JOIN AssignmentSubmissions S2 ON G2.SubmissionID = S2.SubmissionID 
                 INNER JOIN Assignments A2 ON S2.AssignmentID = A2.AssignmentID
                 WHERE S2.AssignmentID = A.AssignmentID)
            ) as Highest,
            CONVERT(DECIMAL(5,1), 
                (SELECT MIN(CAST(G2.PointsEarned as FLOAT) / CAST(A2.MaxPoints as FLOAT) * 100) 
                 FROM AssignmentGrades G2 
                 INNER JOIN AssignmentSubmissions S2 ON G2.SubmissionID = S2.SubmissionID 
                 INNER JOIN Assignments A2 ON S2.AssignmentID = A2.AssignmentID
                 WHERE S2.AssignmentID = A.AssignmentID)
            ) as Lowest,
            CONVERT(DECIMAL(5,1), 
                (SELECT AVG(CAST(G2.PointsEarned as FLOAT) / CAST(A2.MaxPoints as FLOAT) * 100)
                 FROM AssignmentGrades G2 
                 INNER JOIN AssignmentSubmissions S2 ON G2.SubmissionID = S2.SubmissionID 
                 INNER JOIN Assignments A2 ON S2.AssignmentID = A2.AssignmentID
                 WHERE S2.AssignmentID = A.AssignmentID)
            ) as Median,
            CONVERT(DECIMAL(5,1), 
                (SELECT 
                    COUNT(CASE WHEN CAST(G2.PointsEarned as FLOAT) / CAST(A2.MaxPoints as FLOAT) * 100 >= 85 THEN 1 END) * 100.0 / 
                    NULLIF(COUNT(*), 0)
                 FROM AssignmentGrades G2 
                 INNER JOIN AssignmentSubmissions S2 ON G2.SubmissionID = S2.SubmissionID 
                 INNER JOIN Assignments A2 ON S2.AssignmentID = A2.AssignmentID
                 WHERE S2.AssignmentID = A.AssignmentID 
                )
            ) as APercent,
            CONVERT(DECIMAL(5,1), 
                (SELECT 
                    COUNT(CASE WHEN CAST(G2.PointsEarned as FLOAT) / CAST(A2.MaxPoints as FLOAT) * 100 >= 70 
                          AND CAST(G2.PointsEarned as FLOAT) / CAST(A2.MaxPoints as FLOAT) * 100 < 85 THEN 1 END) * 100.0 / COUNT(*)
                 FROM AssignmentGrades G2 
                 INNER JOIN AssignmentSubmissions S2 ON G2.SubmissionID = S2.SubmissionID 
                 INNER JOIN Assignments A2 ON S2.AssignmentID = A2.AssignmentID
                 WHERE S2.AssignmentID = A.AssignmentID 
                )
            ) as BPercent,
            CONVERT(DECIMAL(5,1), 
                (SELECT 
                    COUNT(CASE WHEN CAST(G2.PointsEarned as FLOAT) / CAST(A2.MaxPoints as FLOAT) * 100 >= 60 
                          AND CAST(G2.PointsEarned as FLOAT) / CAST(A2.MaxPoints as FLOAT) * 100 < 70 THEN 1 END) * 100.0 / COUNT(*)
                 FROM AssignmentGrades G2 
                 INNER JOIN AssignmentSubmissions S2 ON G2.SubmissionID = S2.SubmissionID 
                 INNER JOIN Assignments A2 ON S2.AssignmentID = A2.AssignmentID
                 WHERE S2.AssignmentID = A.AssignmentID 
                )
            ) as CPercent,
            CONVERT(DECIMAL(5,1), 
                (SELECT 
                    COUNT(CASE WHEN CAST(G2.PointsEarned as FLOAT) / CAST(A2.MaxPoints as FLOAT) * 100 >= 50 
                          AND CAST(G2.PointsEarned as FLOAT) / CAST(A2.MaxPoints as FLOAT) * 100 < 60 THEN 1 END) * 100.0 / COUNT(*)
                 FROM AssignmentGrades G2 
                 INNER JOIN AssignmentSubmissions S2 ON G2.SubmissionID = S2.SubmissionID 
                 INNER JOIN Assignments A2 ON S2.AssignmentID = A2.AssignmentID
                 WHERE S2.AssignmentID = A.AssignmentID 
                )
            ) as DPercent,
            CONVERT(DECIMAL(5,1), 
                (SELECT 
                    COUNT(CASE WHEN CAST(G2.PointsEarned as FLOAT) / CAST(A2.MaxPoints as FLOAT) * 100 < 50 THEN 1 END) * 100.0 / COUNT(*)
                 FROM AssignmentGrades G2 
                 INNER JOIN AssignmentSubmissions S2 ON G2.SubmissionID = S2.SubmissionID 
                 INNER JOIN Assignments A2 ON S2.AssignmentID = A2.AssignmentID
                 WHERE S2.AssignmentID = A.AssignmentID 
                )
            ) as FPercent
        FROM Assignments A
        INNER JOIN Modules M ON A.ModuleID = M.ModuleID
        INNER JOIN Courses C ON M.CourseID = C.CourseID
        INNER JOIN AssignmentSubmissions S ON A.AssignmentID = S.AssignmentID
        INNER JOIN AssignmentGrades G ON S.SubmissionID = G.SubmissionID
        WHERE M.LecturerID = @LecturerID" + courseFilter + @"
        GROUP BY A.AssignmentID, A.Title, C.CourseName
        ORDER BY AvgGrade DESC", con);

            gradeSummaryCmd.Parameters.AddWithValue("@LecturerID", lecturerId);
            if (!string.IsNullOrEmpty(selectedCourseId))
            {
                gradeSummaryCmd.Parameters.AddWithValue("@CourseID", selectedCourseId);
            }

            DataTable gradeSummaryDt = new DataTable();
            SqlDataAdapter da = new SqlDataAdapter(gradeSummaryCmd);
            da.Fill(gradeSummaryDt);

            if (gradeSummaryDt.Rows.Count > 0)
            {
                gradeSummaryRepeater.DataSource = gradeSummaryDt;
                gradeSummaryRepeater.DataBind();
            }
            else
            {
                // If no data, show a message
                DataTable emptyTable = new DataTable();
                emptyTable.Columns.Add("Title");
                emptyTable.Columns.Add("CourseName");
                emptyTable.Columns.Add("AvgGrade");
                emptyTable.Columns.Add("Median");
                emptyTable.Columns.Add("Highest");
                emptyTable.Columns.Add("Lowest");
                emptyTable.Columns.Add("APercent");
                emptyTable.Columns.Add("BPercent");
                emptyTable.Columns.Add("CPercent");
                emptyTable.Columns.Add("DPercent");
                emptyTable.Columns.Add("FPercent");

                emptyTable.Rows.Add("No grade data available", "", "0", "0", "0", "0", "0", "0", "0", "0", "0");

                gradeSummaryRepeater.DataSource = emptyTable;
                gradeSummaryRepeater.DataBind();
            }

            // Load performance insights data
            LoadPerformanceInsights();
        }

        private void LoadPerformanceChartData(SqlConnection con, string selectedCourseId)
        {
            // In a production environment, this would dynamically populate the performance chart data
            // For now, we'll just add the script to initialize it with sample data
            string courseFilter = !string.IsNullOrEmpty(selectedCourseId) ? $"var courseFilter = {selectedCourseId};" : "var courseFilter = null;";

            ClientScript.RegisterStartupScript(this.GetType(), "loadPerformanceChartData",
                $@"
                {courseFilter}
                
                // This would be replaced with actual data from the database
                setTimeout(function() {{
                    if (performanceChart) {{
                        performanceChart.data.labels = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun'];
                        performanceChart.data.datasets[0].data = [75, 78, 72, 80, 82, 85];
                        performanceChart.update();
                    }}
                }}, 1000);
                ", true);
        }

        private void LoadAssignmentCompletionData(SqlConnection con, string selectedCourseId)
        {
            // In a production environment, this would dynamically populate the assignment chart data
            // For now, we'll just add the script to initialize it with sample data
            string courseFilter = !string.IsNullOrEmpty(selectedCourseId) ? $"var courseFilter = {selectedCourseId};" : "var courseFilter = null;";

            ClientScript.RegisterStartupScript(this.GetType(), "loadAssignmentChartData",
                $@"
                {courseFilter}
                
                // This would be replaced with actual data from the database
                setTimeout(function() {{
                    if (assignmentChart) {{
                        assignmentChart.data.labels = ['Assignment 1', 'Assignment 2', 'Assignment 3', 'Assignment 4', 'Assignment 5'];
                        assignmentChart.data.datasets[0].data = [95, 82, 78, 90, 65];
                        assignmentChart.update();
                    }}
                }}, 1000);
                ", true);
        }

        private void LoadGradeDistributionData(SqlConnection con, string selectedCourseId)
        {
            // In a production environment, this would dynamically populate the grade distribution chart data
            // For now, we'll just add the script to initialize it with sample data
            string courseFilter = !string.IsNullOrEmpty(selectedCourseId) ? $"var courseFilter = {selectedCourseId};" : "var courseFilter = null;";

            ClientScript.RegisterStartupScript(this.GetType(), "loadGradeDistributionData",
                $@"
                {courseFilter}
                
                // This would be replaced with actual data from the database
                setTimeout(function() {{
                    if (gradeDistributionChart) {{
                        gradeDistributionChart.data.datasets[0].data = [5, 10, 25, 35, 25];
                        gradeDistributionChart.update();
                    }}
                    
                    if (gradeTrendsChart) {{
                        gradeTrendsChart.update();
                    }}
                }}, 1000);
                ", true);
        }

        private void LoadPerformanceInsights()
        {
            // In a production environment, these insights would be dynamically generated based on data analysis
            // For now, we'll use sample insights
            DataTable performanceInsights = new DataTable();
            performanceInsights.Columns.Add("Icon");
            performanceInsights.Columns.Add("Title");
            performanceInsights.Columns.Add("Description");

            performanceInsights.Rows.Add("fa-arrow-up", "Improved Performance in Web Development", "Average grades increased by 8% compared to previous term, with notable improvements in JavaScript assignments.");
            performanceInsights.Rows.Add("fa-exclamation-triangle", "Low Submission Rate for Database Projects", "Only 65% of students submitted the Database Design Project. Consider extending deadline or following up with students.");
            performanceInsights.Rows.Add("fa-users", "Top Performing Student Group", "Students enrolled in both Web Development and Database Design show 15% higher average grades than those in single courses.");

            performanceInsightsRepeater.DataSource = performanceInsights;
            performanceInsightsRepeater.DataBind();
        }

        private void LoadEngagementInsights()
        {
            // In a production environment, these insights would be dynamically generated based on data analysis
            // For now, we'll use sample insights
            DataTable engagementInsights = new DataTable();
            engagementInsights.Columns.Add("Icon");
            engagementInsights.Columns.Add("Title");
            engagementInsights.Columns.Add("Description");

            engagementInsights.Rows.Add("fa-calendar-check", "Higher Engagement on Mondays", "Student activity is 30% higher on Mondays compared to other days. Consider scheduling important assignments for Monday release.");
            engagementInsights.Rows.Add("fa-clock", "Late-Night Submission Pattern", "40% of submissions occur between 10pm and 2am. This suggests students may be working late on assignments.");
            engagementInsights.Rows.Add("fa-lightbulb", "Interactive Assignments Get More Engagement", "Assignments with interactive components have 25% higher completion rates than traditional written assignments.");

            engagementInsightsRepeater.DataSource = engagementInsights;
            engagementInsightsRepeater.DataBind();

            #endregion
        }
    }
}