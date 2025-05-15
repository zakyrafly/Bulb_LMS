using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;

namespace assignmentDraft1
{
    public partial class lessons : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack && Request.QueryString["moduleID"] != null)
            {
                int moduleId;
                if (int.TryParse(Request.QueryString["moduleID"], out moduleId))
                {
                    LoadLessons(moduleId);
                }
                else
                {
                    Response.Redirect("homeWebform.aspx"); // fallback if invalid
                }
            }
        }

        private void LoadLessons(int moduleId)
        {
            string cs = ConfigurationManager.ConnectionStrings["dbConnection"].ConnectionString;
            using (SqlConnection con = new SqlConnection(cs))
            {
                SqlCommand cmd = new SqlCommand("SELECT LessonID, Title FROM Lessons WHERE ModuleID = @ModuleID", con);
                cmd.Parameters.AddWithValue("@ModuleID", moduleId);

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);

                lessonRepeater.DataSource = dt;
                lessonRepeater.DataBind();
            }
        }
    }
}
