using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace assignmentDraft1
{
    public partial class adminDashboard : System.Web.UI.Page
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
                LoadDashboardData();
                LoadRecentActivity();
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
                SqlCommand userCmd = new SqlCommand("SELECT UserID, Name, Role FROM Users WHERE Username = @Email", con);
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

        private void LoadDashboardData()
        {
            string cs = ConfigurationManager.ConnectionStrings["dbConnection"].ConnectionString;
            using (SqlConnection con = new SqlConnection(cs))
            {
                con.Open();

                // Get total users count
                SqlCommand usersCmd = new SqlCommand("SELECT COUNT(*) FROM Users", con);
                int totalUsers = (int)usersCmd.ExecuteScalar();
                lblTotalUsers.Text = totalUsers.ToString();

                // Get total courses count
                SqlCommand coursesCmd = new SqlCommand("SELECT COUNT(*) FROM Courses", con);
                int totalCourses = (int)coursesCmd.ExecuteScalar();
                lblTotalCourses.Text = totalCourses.ToString();

                // Get active assignments count
                SqlCommand assignmentsCmd = new SqlCommand("SELECT COUNT(*) FROM Assignments WHERE IsActive = 1", con);
                int activeAssignments = (int)assignmentsCmd.ExecuteScalar();
                lblActiveAssignments.Text = activeAssignments.ToString();

                // Get pending grades count
                SqlCommand pendingGradesCmd = new SqlCommand(@"
                    SELECT COUNT(*) 
                    FROM AssignmentSubmissions s
                    LEFT JOIN AssignmentGrades g ON s.SubmissionID = g.SubmissionID
                    WHERE s.Status = 'Submitted' AND g.GradeID IS NULL", con);
                int pendingGrades = (int)pendingGradesCmd.ExecuteScalar();
                lblPendingGrades.Text = pendingGrades.ToString();

                // Calculate user growth (mock data for now)
                SqlCommand newUsersCmd = new SqlCommand(@"
                    SELECT COUNT(*) FROM Users 
                    WHERE UserID IN (SELECT MAX(UserID) FROM Users) - 10", con);
                // This is simplified - in a real system you'd track registration dates
                lblUserChange.Text = "+12%";
                lblCourseChange.Text = "+5%";
                lblAssignmentChange.Text = "+8%";

                // Get active users (users who logged in recently - mock for now)
                // In a real system, you'd track login sessions/timestamps
                lblActiveUsers.Text = Math.Min(totalUsers / 4, 25).ToString();

                // Mock storage usage
                lblStorageUsage.Text = "65%";
            }
        }

        private void LoadRecentActivity()
        {
            string cs = ConfigurationManager.ConnectionStrings["dbConnection"].ConnectionString;
            using (SqlConnection con = new SqlConnection(cs))
            {
                con.Open();

                // Create a mock recent activity feed
                // In a real system, you'd have an activity log table
                DataTable activityData = new DataTable();
                activityData.Columns.Add("ActivityType");
                activityData.Columns.Add("ActivityTitle");
                activityData.Columns.Add("ActivityTime", typeof(DateTime));

                // Get recent users
                SqlCommand recentUsersCmd = new SqlCommand("SELECT TOP 3 Name FROM Users ORDER BY UserID DESC", con);
                SqlDataReader userReader = recentUsersCmd.ExecuteReader();
                while (userReader.Read())
                {
                    DataRow row = activityData.NewRow();
                    row["ActivityType"] = "user";
                    row["ActivityTitle"] = $"New user registered: {userReader["Name"]}";
                    row["ActivityTime"] = DateTime.Now.AddHours(-new Random().Next(1, 24));
                    activityData.Rows.Add(row);
                }
                userReader.Close();

                // Get recent assignments
                SqlCommand recentAssignmentsCmd = new SqlCommand(@"
                    SELECT TOP 2 a.Title, c.CourseName 
                    FROM Assignments a 
                    JOIN Modules m ON a.ModuleID = m.ModuleID
                    JOIN Courses c ON m.CourseID = c.CourseID
                    WHERE a.IsActive = 1 
                    ORDER BY a.AssignmentID DESC", con);
                SqlDataReader assignmentReader = recentAssignmentsCmd.ExecuteReader();
                while (assignmentReader.Read())
                {
                    DataRow row = activityData.NewRow();
                    row["ActivityType"] = "assignment";
                    row["ActivityTitle"] = $"New assignment created: {assignmentReader["Title"]} ({assignmentReader["CourseName"]})";
                    row["ActivityTime"] = DateTime.Now.AddHours(-new Random().Next(1, 48));
                    activityData.Rows.Add(row);
                }
                assignmentReader.Close();

                // Get recent submissions
                SqlCommand recentSubmissionsCmd = new SqlCommand(@"
                    SELECT TOP 2 a.Title, u.Name
                    FROM AssignmentSubmissions s
                    JOIN Assignments a ON s.AssignmentID = a.AssignmentID
                    JOIN Users u ON s.UserID = u.UserID
                    WHERE s.Status = 'Submitted'
                    ORDER BY s.SubmissionID DESC", con);
                SqlDataReader submissionReader = recentSubmissionsCmd.ExecuteReader();
                while (submissionReader.Read())
                {
                    DataRow row = activityData.NewRow();
                    row["ActivityType"] = "grade";
                    row["ActivityTitle"] = $"Assignment submitted: {submissionReader["Title"]} by {submissionReader["Name"]}";
                    row["ActivityTime"] = DateTime.Now.AddMinutes(-new Random().Next(30, 1440));
                    activityData.Rows.Add(row);
                }
                submissionReader.Close();

                // Sort by time and bind
                DataView dv = activityData.DefaultView;
                dv.Sort = "ActivityTime DESC";

                if (dv.Count > 0)
                {
                    activityRepeater.DataSource = dv;
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
        }

        protected void btnSearch_Click(object sender, EventArgs e)
        {
            string query = txtSearch.Text.Trim();
            if (!string.IsNullOrEmpty(query))
            {
                // Redirect to admin search results page
                Response.Redirect($"adminSearch.aspx?query=" + Server.UrlEncode(query));
            }
        }

        // Helper methods for the activity repeater
        protected string GetActivityClass(object activityType)
        {
            if (activityType == null) return "user";

            string type = activityType.ToString().ToLower();
            switch (type)
            {
                case "user": return "user";
                case "course": return "course";
                case "assignment": return "assignment";
                case "grade": return "grade";
                default: return "user";
            }
        }

        protected string GetActivityIcon(object activityType)
        {
            if (activityType == null) return "fa-user";

            string type = activityType.ToString().ToLower();
            switch (type)
            {
                case "user": return "fa-user-plus";
                case "course": return "fa-graduation-cap";
                case "assignment": return "fa-tasks";
                case "grade": return "fa-star";
                default: return "fa-info";
            }
        }

        // Method to get user role breakdown for charts (can be used later)
        private DataTable GetUserRoleBreakdown()
        {
            string cs = ConfigurationManager.ConnectionStrings["dbConnection"].ConnectionString;
            using (SqlConnection con = new SqlConnection(cs))
            {
                con.Open();
                SqlCommand cmd = new SqlCommand(@"
                    SELECT Role, COUNT(*) AS Count 
                    FROM Users 
                    GROUP BY Role", con);

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);
                return dt;
            }
        }

        // Method to get course enrollment statistics
        private DataTable GetEnrollmentStats()
        {
            string cs = ConfigurationManager.ConnectionStrings["dbConnection"].ConnectionString;
            using (SqlConnection con = new SqlConnection(cs))
            {
                con.Open();
                SqlCommand cmd = new SqlCommand(@"
                    SELECT 
                        c.CourseName,
                        COUNT(uc.UserID) AS EnrollmentCount
                    FROM Courses c
                    LEFT JOIN UserCourses uc ON c.CourseID = uc.CourseID
                    GROUP BY c.CourseID, c.CourseName
                    ORDER BY EnrollmentCount DESC", con);

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);
                return dt;
            }
        }

        // Method to get assignment completion rates
        private DataTable GetAssignmentStats()
        {
            string cs = ConfigurationManager.ConnectionStrings["dbConnection"].ConnectionString;
            using (SqlConnection con = new SqlConnection(cs))
            {
                con.Open();
                SqlCommand cmd = new SqlCommand(@"
                    SELECT 
                        a.Title,
                        COUNT(s.SubmissionID) AS SubmissionCount,
                        COUNT(g.GradeID) AS GradedCount
                    FROM Assignments a
                    LEFT JOIN AssignmentSubmissions s ON a.AssignmentID = s.AssignmentID AND s.Status = 'Submitted'
                    LEFT JOIN AssignmentGrades g ON s.SubmissionID = g.SubmissionID
                    WHERE a.IsActive = 1
                    GROUP BY a.AssignmentID, a.Title
                    ORDER BY SubmissionCount DESC", con);

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);
                return dt;
            }
        }
    }
}