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
            if (!IsPostBack && Request.Form["search_box"] != null)
            {
                string searchTerm = Request.Form["search_box"];

                string connectionString = ConfigurationManager.ConnectionStrings["YourConnectionStringName"].ConnectionString;
                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    string query = "SELECT * FROM Modules WHERE ModuleTitle LIKE @SearchTerm";
                    SqlCommand cmd = new SqlCommand(query, conn);
                    cmd.Parameters.AddWithValue("@SearchTerm", "%" + searchTerm + "%");

                    SqlDataAdapter adapter = new SqlDataAdapter(cmd);
                    DataTable dt = new DataTable();
                    adapter.Fill(dt);

                    searchRepeater.DataSource = dt;
                    searchRepeater.DataBind();
                }
            }
        }
    }
}
