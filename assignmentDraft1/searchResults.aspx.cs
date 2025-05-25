using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;

namespace assignmentDraft1
{
    public partial class searchResults : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // Set lblname from session
            if (Session["email"] != null)
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

                        // Also update the sidebar labels
                        lblSidebarName.Text = reader["Name"].ToString();
                        lblSidebarRole.Text = reader["Role"].ToString();
                    }
                    else
                    {
                        lblName.Text = "Guest";
                        lblRole.Text = "Guest";
                        lblSidebarName.Text = "Guest";
                        lblSidebarRole.Text = "Guest";
                    }
                }
            }
            else
            {
                // Redirect to login page if not logged in
                Response.Redirect("loginWebform.aspx");
            }

            // Keep your existing search code here
            if (!IsPostBack && Request.QueryString["query"] != null)
            {
                string searchTerm = Request.QueryString["query"];
                // Rest of your existing search code...
            }

            if (!IsPostBack && Request.QueryString["query"] != null)
            {
                string searchTerm = Request.QueryString["query"];

                string cs = ConfigurationManager.ConnectionStrings["dbConnection"].ConnectionString;
                using (SqlConnection con = new SqlConnection(cs))
                {
                    con.Open();

                    SqlCommand cmd = new SqlCommand(
                        @"SELECT 
                  M.ModuleID,
                  M.Title AS ModuleTitle, 
                  Lec.FullName AS LecturerName
              FROM Modules M
              LEFT JOIN Lecturers Lec ON M.LecturerID = Lec.LecturerID
              WHERE M.Title LIKE @SearchTerm", con);

                    cmd.Parameters.AddWithValue("@SearchTerm", "%" + searchTerm + "%");

                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    DataTable dt = new DataTable();
                    da.Fill(dt);

                    searchRepeater.DataSource = dt;
                    searchRepeater.DataBind();
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
    }
}
