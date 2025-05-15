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
                    // Not logged in, redirect to login page
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

                            // Get userID from DB to use in course content loading
                            reader.Close();

                            SqlCommand getUserIdCmd = new SqlCommand("SELECT UserID FROM Users WHERE Username = @Email", con);
                            getUserIdCmd.Parameters.AddWithValue("@Email", email);
                            int userId = (int)getUserIdCmd.ExecuteScalar();

                            LoadCourseContent(userId); // Call this after setting labels
                        }


                    }
                }
            }
        }

        protected void btnSearch_Click(object sender, EventArgs e)
        {
            string searchTerm = txtSearch.Text.Trim();
            string connStr = ConfigurationManager.ConnectionStrings["dbConnection"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string query = "SELECT * FROM Modules WHERE Title LIKE @SearchTerm";
                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@SearchTerm", "%" + searchTerm + "%");

                SqlDataAdapter adapter = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                adapter.Fill(dt);



                searchRepeater.DataSource = dt;
                searchRepeater.DataBind();
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