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
    public partial class ViewStudent : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // Check if user is logged in and is lecturer
            if (Session["email"] == null)
            {
                Response.Redirect("loginWebform.aspx");
                return;
            }

            // Load lecturer info on every page load
            LoadLecturerInfo();

            if (!IsPostBack)
            {
                LoadStudentStatistics();
                LoadLecturerCourses(); // Load courses for the dropdown filter
                LoadStudents();
            }
        }

        private void LoadLecturerInfo()
        {
            string email = Session["email"].ToString();
            string cs = ConfigurationManager.ConnectionStrings["dbConnection"].ConnectionString;

            using (SqlConnection con = new SqlConnection(cs))
            {
                con.Open();

                // Check if user is lecturer
                SqlCommand userCmd = new SqlCommand("SELECT UserID, Name, Role FROM Users WHERE username = @Email", con);
                userCmd.Parameters.AddWithValue("@Email", email);

                SqlDataReader userReader = userCmd.ExecuteReader();
                if (userReader.Read())
                {
                    string role = userReader["Role"].ToString();
                    if (role != "Lecturer")
                    {
                        userReader.Close();
                        Response.Redirect("loginWebform.aspx"); // Redirect non-lecturers
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

        private void LoadStudentStatistics()
        {
            string lecturerEmail = Session["email"].ToString();
            string cs = ConfigurationManager.ConnectionStrings["dbConnection"].ConnectionString;

            using (SqlConnection con = new SqlConnection(cs))
            {
                con.Open();

                // Get total students count for this lecturer's courses
                SqlCommand totalCmd = new SqlCommand(@"
                    SELECT COUNT(DISTINCT UC.UserID) 
                    FROM UserCourses UC
                    INNER JOIN Courses C ON UC.CourseID = C.CourseID
                    INNER JOIN Modules M ON C.CourseID = M.CourseID
                    INNER JOIN Lecturers L ON M.LecturerID = L.LecturerID
                    INNER JOIN Users U ON UC.UserID = U.UserID
                    WHERE L.Email = @LecturerEmail AND U.Role = 'Student'", con);
                totalCmd.Parameters.AddWithValue("@LecturerEmail", lecturerEmail);
                int totalStudents = (int)totalCmd.ExecuteScalar();
                lblTotalStudents.Text = totalStudents.ToString();

                // Get total courses count for this lecturer
                SqlCommand coursesCmd = new SqlCommand(@"
                    SELECT COUNT(DISTINCT C.CourseID) 
                    FROM Courses C
                    INNER JOIN Modules M ON C.CourseID = M.CourseID
                    INNER JOIN Lecturers L ON M.LecturerID = L.LecturerID
                    WHERE L.Email = @LecturerEmail", con);
                coursesCmd.Parameters.AddWithValue("@LecturerEmail", lecturerEmail);
                int totalCourses = (int)coursesCmd.ExecuteScalar();
                lblTotalCourses.Text = totalCourses.ToString();

                // Get active enrollments count (same as total students since we don't have IsActive in UserCourses)
                lblActiveEnrollments.Text = totalStudents.ToString();
            }
        }

        private void LoadLecturerCourses()
        {
            string lecturerEmail = Session["email"].ToString();
            string cs = ConfigurationManager.ConnectionStrings["dbConnection"].ConnectionString;

            using (SqlConnection con = new SqlConnection(cs))
            {
                con.Open();
                SqlCommand cmd = new SqlCommand(@"
                    SELECT DISTINCT C.CourseID, C.CourseName 
                    FROM Courses C
                    INNER JOIN Modules M ON C.CourseID = M.CourseID
                    INNER JOIN Lecturers L ON M.LecturerID = L.LecturerID
                    WHERE L.Email = @LecturerEmail
                    ORDER BY C.CourseName", con);
                cmd.Parameters.AddWithValue("@LecturerEmail", lecturerEmail);
                SqlDataReader reader = cmd.ExecuteReader();

                ddlCourseFilter.Items.Clear();
                ddlCourseFilter.Items.Add(new ListItem("All Courses", ""));

                while (reader.Read())
                {
                    ddlCourseFilter.Items.Add(new ListItem(reader["CourseName"].ToString(), reader["CourseID"].ToString()));
                }
            }
        }

        private void LoadStudents()
        {
            string lecturerEmail = Session["email"].ToString();
            string cs = ConfigurationManager.ConnectionStrings["dbConnection"].ConnectionString;

            using (SqlConnection con = new SqlConnection(cs))
            {
                con.Open();

                // Build dynamic query based on filters
                string query = @"
                    SELECT DISTINCT
                        U.UserID,
                        U.Name,
                        U.username,
                        U.ContactInfo,
                        C.CourseName,
                        UC.EnrollmentDate
                    FROM Users U
                    INNER JOIN UserCourses UC ON U.UserID = UC.UserID
                    INNER JOIN Courses C ON UC.CourseID = C.CourseID
                    INNER JOIN Modules M ON C.CourseID = M.CourseID
                    INNER JOIN Lecturers L ON M.LecturerID = L.LecturerID
                    WHERE L.Email = @LecturerEmail AND U.Role = 'Student'";

                // Add search filter
                if (!string.IsNullOrEmpty(txtSearch.Text.Trim()))
                {
                    query += " AND (U.Name LIKE @SearchTerm OR U.username LIKE @SearchTerm)";
                }

                // Add course filter
                if (!string.IsNullOrEmpty(ddlCourseFilter.SelectedValue))
                {
                    query += " AND C.CourseID = @CourseFilter";
                }

                query += " ORDER BY U.Name";

                SqlCommand cmd = new SqlCommand(query, con);
                cmd.Parameters.AddWithValue("@LecturerEmail", lecturerEmail);

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
                    studentRepeater.DataSource = dt;
                    studentRepeater.DataBind();
                    lblDisplayCount.Text = dt.Rows.Count.ToString();
                    pnlNoStudents.Visible = false;
                }
                else
                {
                    studentRepeater.DataSource = null;
                    studentRepeater.DataBind();
                    lblDisplayCount.Text = "0";
                    pnlNoStudents.Visible = true;
                }
            }
        }

        protected void DdlCourseFilter_SelectedIndexChanged(object sender, EventArgs e)
        {
            LoadStudents();
        }

        protected void BtnSearch_Click(object sender, EventArgs e)
        {
            LoadStudents();
        }

        protected void BtnHeaderSearch_Click(object sender, EventArgs e)
        {
            txtSearch.Text = txtHeaderSearch.Text.Trim();
            LoadStudents();
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