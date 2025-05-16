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
