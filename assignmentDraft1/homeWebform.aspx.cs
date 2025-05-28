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

                            reader.Close();

                            SqlCommand getUserIdCmd = new SqlCommand("SELECT UserID FROM Users WHERE Username = @Email", con);
                            getUserIdCmd.Parameters.AddWithValue("@Email", email);
                            int userId = (int)getUserIdCmd.ExecuteScalar();

                            LoadCourseContent(userId);
                            LoadAssignments(userId); // Add this line
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


<<<<<<< HEAD
=======
        private void LoadAssignments(int userId)
        {
            string cs = ConfigurationManager.ConnectionStrings["dbConnection"].ConnectionString;
            using (SqlConnection con = new SqlConnection(cs))
            {
                con.Open();

                // Get assignments for the user's enrolled courses
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

                // Bind to a repeater (you'll need to add this to your ASPX)
                assignmentRepeater.DataSource = dt;
                assignmentRepeater.DataBind();
            }
        }
>>>>>>> lecturer-page



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
                    SqlCommand contentCmd = new SqlCommand(
    @"SELECT 
          M.ModuleID,
          M.Title AS ModuleTitle, 
          Lec.FullName AS LecturerName
      FROM Modules M
      LEFT JOIN Lecturers Lec ON M.LecturerID = Lec.LecturerID
      WHERE M.CourseID = @CourseID", con);

                    contentCmd.Parameters.AddWithValue("@CourseID", courseId);

                    SqlDataAdapter da = new SqlDataAdapter(contentCmd);
                    DataTable dt = new DataTable();
                    da.Fill(dt);

                    courseContentRepeater.DataSource = dt;
                    courseContentRepeater.DataBind();
                }
            }
        }

    }
}