using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace assignmentDraft1
{
    public partial class studentLessons : System.Web.UI.Page
    {
        private int userId;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // Check if user is logged in
                if (Session["email"] == null)
                {
                    Response.Redirect("loginWebform.aspx");
                    return;
                }

                // Get user information
                if (!LoadUserInfo())
                {
                    return;
                }

                // Load modules
                LoadModules();
            }
            // Remove the postback handling for modal since we're navigating to lessons.aspx instead
        }

        private bool LoadUserInfo()
        {
            string email = Session["email"].ToString();
            string cs = ConfigurationManager.ConnectionStrings["dbConnection"].ConnectionString;

            using (SqlConnection con = new SqlConnection(cs))
            {
                try
                {
                    con.Open();

                    // Get user details
                    SqlCommand userCmd = new SqlCommand("SELECT UserID, Name, Role FROM Users WHERE Username = @Email", con);
                    userCmd.Parameters.AddWithValue("@Email", email);

                    SqlDataReader userReader = userCmd.ExecuteReader();
                    if (userReader.Read())
                    {
                        string role = userReader["Role"].ToString();

                        // Set user ID for further queries
                        userId = Convert.ToInt32(userReader["UserID"]);

                        // Set user information in the UI
                        lblName.Text = userReader["Name"].ToString();
                        lblRole.Text = role;
                        lblSidebarName.Text = userReader["Name"].ToString();
                        lblSidebarRole.Text = role;
                    }
                    else
                    {
                        userReader.Close();
                        return false;
                    }
                    userReader.Close();

                    return true;
                }
                catch (Exception ex)
                {
                    System.Diagnostics.Debug.WriteLine($"Error loading user information: {ex.Message}");
                    return false;
                }
            }
        }

        private void LoadModules()
        {
            string cs = ConfigurationManager.ConnectionStrings["dbConnection"].ConnectionString;
            using (SqlConnection con = new SqlConnection(cs))
            {
                try
                {
                    con.Open();

                    // This query is similar to what's used in homeWebform.aspx
                    SqlCommand cmd = new SqlCommand(@"
                        SELECT 
                            M.ModuleID, 
                            M.Title, 
                            M.Description,
                            L.FullName AS LecturerName,
                            C.CourseName
                        FROM Modules M
                        JOIN Courses C ON M.CourseID = C.CourseID
                        JOIN UserCourses UC ON C.CourseID = UC.CourseID
                        LEFT JOIN Lecturers L ON M.LecturerID = L.LecturerID
                        WHERE UC.UserID = @UserID
                        ORDER BY C.CourseName, M.ModuleOrder", con);

                    cmd.Parameters.AddWithValue("@UserID", userId);

                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    DataTable dt = new DataTable();
                    da.Fill(dt);

                    if (dt.Rows.Count > 0)
                    {
                        moduleRepeater.DataSource = dt;
                        moduleRepeater.DataBind();
                        noModulesPanel.Visible = false;
                    }
                    else
                    {
                        moduleRepeater.DataSource = null;
                        moduleRepeater.DataBind();
                        noModulesPanel.Visible = true;
                    }
                }
                catch (Exception ex)
                {
                    System.Diagnostics.Debug.WriteLine($"Error loading modules: {ex.Message}");
                }
            }
        }

        protected void ModuleRepeater_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                DataRowView drv = (DataRowView)e.Item.DataItem;
                int moduleId = Convert.ToInt32(drv["ModuleID"]);

                Repeater lessonRepeater = (Repeater)e.Item.FindControl("lessonRepeater");
                Panel noLessonsPanel = (Panel)e.Item.FindControl("noLessonsPanel");

                if (lessonRepeater != null && noLessonsPanel != null)
                {
                    LoadLessonsForModule(moduleId, lessonRepeater, noLessonsPanel);
                }
            }
        }

        private void LoadLessonsForModule(int moduleId, Repeater lessonRepeater, Panel noLessonsPanel)
        {
            string cs = ConfigurationManager.ConnectionStrings["dbConnection"].ConnectionString;
            using (SqlConnection con = new SqlConnection(cs))
            {
                try
                {
                    con.Open();

                    SqlCommand cmd = new SqlCommand(@"
                        SELECT 
                            LessonID, 
                            Title, 
                            ContentType, 
                            Duration
                        FROM Lessons
                        WHERE ModuleID = @ModuleID
                        ORDER BY LessonID", con);

                    cmd.Parameters.AddWithValue("@ModuleID", moduleId);

                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    DataTable dt = new DataTable();
                    da.Fill(dt);

                    if (dt.Rows.Count > 0)
                    {
                        System.Diagnostics.Debug.WriteLine($"Found {dt.Rows.Count} lessons for module {moduleId}");
                        lessonRepeater.DataSource = dt;
                        lessonRepeater.DataBind();
                        noLessonsPanel.Visible = false;
                    }
                    else
                    {
                        System.Diagnostics.Debug.WriteLine($"No lessons found for module {moduleId}");
                        lessonRepeater.DataSource = null;
                        lessonRepeater.DataBind();
                        noLessonsPanel.Visible = true;
                    }
                }
                catch (Exception ex)
                {
                    System.Diagnostics.Debug.WriteLine($"Error loading lessons for module {moduleId}: {ex.Message}");
                }
            }
        }

        // Remove LoadLessonForView method since we're not using modal anymore

        protected void btnSearch_Click(object sender, EventArgs e)
        {
            string query = txtSearch.Text.Trim();

            if (!string.IsNullOrEmpty(query))
            {
                // Redirect to search page with query string
                Response.Redirect("searchResults.aspx?query=" + Server.UrlEncode(query));
            }
        }

        // Helper methods for content display
        protected string GetContentTypeIcon(string contentType)
        {
            switch (contentType)
            {
                case "Video":
                    return "fa-video";
                case "PDF":
                    return "fa-file-pdf";
                case "Link":
                    return "fa-external-link-alt";
                case "Text":
                default:
                    return "fa-font";
            }
        }

        protected string GetContentTypeLabel(string contentType)
        {
            switch (contentType)
            {
                case "Video":
                    return "Video Content";
                case "PDF":
                    return "PDF Document";
                case "Link":
                    return "External Link";
                case "Text":
                default:
                    return "Text Content";
            }
        }
    }
}