using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace assignmentDraft1
{
    public partial class homeWebform : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (Session["email"] == null)
                {
                    Response.Redirect("loginWebform.aspx");
                }
                else
                {
                    string email = Session["email"].ToString();
                    string cs = ConfigurationManager.ConnectionStrings["dbConnection"].ConnectionString;

                    using (SqlConnection con = new SqlConnection(cs))
                    {
                        string query = "SELECT Name, Role FROM Users WHERE Username = @Email";
                        SqlCommand cmd = new SqlCommand(query, con);
                        cmd.Parameters.AddWithValue("@Email", email);

                        con.Open();
                        SqlDataReader reader = cmd.ExecuteReader();
                        if (reader.Read())
                        {
                            lblName.Text = reader["Name"].ToString();
                            lblRole.Text = reader["Role"].ToString();
                            lblSidebarName.Text = reader["Name"].ToString();
                            lblSidebarRole.Text = reader["Role"].ToString();

                            // Set welcome name (first name only)
                            string fullName = reader["Name"].ToString();
                            string firstName = fullName.Split(' ')[0];
                            if (FindControl("lblWelcomeName") != null)
                            {
                                ((Label)FindControl("lblWelcomeName")).Text = firstName;
                            }

                            reader.Close();

                            SqlCommand getUserIdCmd = new SqlCommand("SELECT UserID FROM Users WHERE Username = @Email", con);
                            getUserIdCmd.Parameters.AddWithValue("@Email", email);
                            int userId = (int)getUserIdCmd.ExecuteScalar();

                            LoadCourseContent(userId);
                            LoadAssignments(userId);
                        }
                    }
                }
            }
        }

        protected void btnSearch_Click(object sender, EventArgs e)
        {
            string query = txtSearch.Text.Trim();

            if (!string.IsNullOrEmpty(query))
            {
                // Redirect to search page with query string
                Response.Redirect("searchResults.aspx?query=" + Server.UrlEncode(query));
            }
        }

        private void LoadAssignments(int userId)
        {
            string cs = ConfigurationManager.ConnectionStrings["dbConnection"].ConnectionString;
            using (SqlConnection con = new SqlConnection(cs))
            {
                con.Open();

                // Fixed query to handle TEXT/NTEXT columns properly
                SqlCommand cmd = new SqlCommand(@"
                    SELECT TOP 5
                        a.AssignmentID,
                        a.Title,
                        a.DueDate,
                        a.MaxPoints,
                        c.CourseName,
                        CASE 
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
                    LEFT JOIN AssignmentSubmissions s ON a.AssignmentID = s.AssignmentID AND s.UserID = @UserID
                    LEFT JOIN AssignmentGrades g ON s.SubmissionID = g.SubmissionID
                    WHERE uc.UserID = @UserID AND a.IsActive = 1
                    ORDER BY a.DueDate ASC", con);

                cmd.Parameters.AddWithValue("@UserID", userId);

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);

                if (dt.Rows.Count > 0)
                {
                    assignmentRepeater.DataSource = dt;
                    assignmentRepeater.DataBind();
                    noAssignmentsPanel.Visible = false;
                }
                else
                {
                    assignmentRepeater.DataSource = null;
                    assignmentRepeater.DataBind();
                    noAssignmentsPanel.Visible = true;
                }
            }
        }

        private void LoadCourseContent(int userId)
        {
            string cs = ConfigurationManager.ConnectionStrings["dbConnection"].ConnectionString;
            using (SqlConnection con = new SqlConnection(cs))
            {
                con.Open();

                // Get CourseID based on user
                SqlCommand courseCmd = new SqlCommand(
                    @"SELECT C.CourseID, C.CourseName 
                      FROM UserCourses UC 
                      JOIN Courses C ON UC.CourseID = C.CourseID 
                      WHERE UC.UserID = @UserID", con);
                courseCmd.Parameters.AddWithValue("@UserID", userId);

                int courseId = 0;
                SqlDataReader reader = courseCmd.ExecuteReader();
                if (reader.Read())
                {
                    courseId = Convert.ToInt32(reader["CourseID"]);
                }
                reader.Close();

                if (courseId > 0)
                {
                    // Fixed query to avoid TEXT/NTEXT comparison issues
                    SqlCommand contentCmd = new SqlCommand(
                        @"SELECT 
                              M.ModuleID,
                              M.Title AS ModuleTitle, 
                              Lec.FullName AS LecturerName
                          FROM Modules M
                          LEFT JOIN Lecturers Lec ON M.LecturerID = Lec.LecturerID
                          WHERE M.CourseID = @CourseID
                          ORDER BY M.ModuleOrder, M.Title", con);

                    contentCmd.Parameters.AddWithValue("@CourseID", courseId);

                    SqlDataAdapter da = new SqlDataAdapter(contentCmd);
                    DataTable dt = new DataTable();
                    da.Fill(dt);

                    courseContentRepeater.DataSource = dt;
                    courseContentRepeater.DataBind();
                }
            }
        }

        // Helper methods for the enhanced ASPX page
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

        protected string GetStatusIcon(object status)
        {
            if (status == null) return "fa-info";

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
                case "due soon":
                    return "fa-hourglass-half";
                default:
                    return "fa-info";
            }
        }

        protected string GetStatusDescription(object status)
        {
            if (status == null) return "Unknown status";

            string statusStr = status.ToString().ToLower();
            switch (statusStr)
            {
                case "pending":
                    return "Ready to start";
                case "submitted":
                    return "Waiting for grade";
                case "overdue":
                    return "Past due date";
                case "graded":
                    return "Grade received";
                case "due soon":
                    return "Due very soon";
                default:
                    return statusStr;
            }
        }

        protected string GetRandomProgress()
        {
            // Generate a realistic progress percentage for demo purposes
            Random rand = new Random();
            int progress = rand.Next(25, 95); // Between 25% and 95%
            return progress.ToString();
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

        private string GetLetterGrade(double percentage)
        {
            if (percentage >= 90) return "A";
            if (percentage >= 80) return "B";
            if (percentage >= 70) return "C";
            if (percentage >= 60) return "D";
            return "F";
        }
    }
}