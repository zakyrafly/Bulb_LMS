using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI.WebControls;

namespace assignmentDraft1
{
    public partial class lessons : System.Web.UI.Page
    {
        private int moduleId = 0;
        private int lessonId = 0;
        private int userId = 0;
        private int courseId = 0;
        private string courseName = string.Empty;

        protected void Page_Load(object sender, EventArgs e)
        {
            // Check if user is logged in
            if (Session["email"] == null)
            {
                Response.Redirect("loginWebform.aspx");
                return;
            }

            // Get the userId from the session email
            userId = GetUserIdFromEmail(Session["email"].ToString());
            if (userId == 0)
            {
                Response.Redirect("loginWebform.aspx");
                return;
            }

            // Get moduleId from query string
            if (Request.QueryString["moduleID"] != null && int.TryParse(Request.QueryString["moduleID"], out moduleId))
            {
                // Get lessonId from query string if available
                if (Request.QueryString["lessonID"] != null)
                {
                    int.TryParse(Request.QueryString["lessonID"], out lessonId);
                }

                if (!IsPostBack)
                {
                    LoadUserInfo();
                    LoadModuleInfo();
                    LoadLessons();

                    // If no specific lesson is selected, show the first lesson
                    if (lessonId == 0 && lessonRepeater.Items.Count > 0)
                    {
                        DataTable lessonsData = (DataTable)lessonRepeater.DataSource;
                        if (lessonsData != null && lessonsData.Rows.Count > 0)
                        {
                            lessonId = Convert.ToInt32(lessonsData.Rows[0]["LessonID"]);
                            Response.Redirect($"lessons.aspx?moduleID={moduleId}&lessonID={lessonId}");
                        }
                        else
                        {
                            // No lessons available
                            pnlLessonContent.Visible = false;
                            pnlNoLesson.Visible = true;
                        }
                    }
                    else if (lessonId > 0)
                    {
                        LoadLessonContent(lessonId);
                        SetupNavigationButtons();
                    }
                    else
                    {
                        // No valid lesson selected
                        pnlLessonContent.Visible = false;
                        pnlNoLesson.Visible = true;
                    }
                }
            }
            else
            {
                Response.Redirect("homeWebform.aspx"); // Redirect if no valid moduleId
            }
        }

        private int GetUserIdFromEmail(string email)
        {
            int userId = 0;
            string cs = ConfigurationManager.ConnectionStrings["dbConnection"].ConnectionString;

            using (SqlConnection con = new SqlConnection(cs))
            {
                SqlCommand cmd = new SqlCommand("SELECT UserID FROM Users WHERE Username = @Email", con);
                cmd.Parameters.AddWithValue("@Email", email);

                try
                {
                    con.Open();
                    object result = cmd.ExecuteScalar();
                    if (result != null && result != DBNull.Value)
                    {
                        userId = Convert.ToInt32(result);
                    }
                }
                catch (Exception ex)
                {
                    System.Diagnostics.Debug.WriteLine("Error getting user ID: " + ex.Message);
                }
            }

            return userId;
        }

        private void LoadUserInfo()
        {
            string email = Session["email"].ToString();
            string cs = ConfigurationManager.ConnectionStrings["dbConnection"].ConnectionString;

            using (SqlConnection con = new SqlConnection(cs))
            {
                try
                {
                    con.Open();
                    SqlCommand cmd = new SqlCommand("SELECT Name, Role FROM Users WHERE Username = @Email", con);
                    cmd.Parameters.AddWithValue("@Email", email);

                    SqlDataReader reader = cmd.ExecuteReader();
                    if (reader.Read())
                    {
                        lblName.Text = reader["Name"].ToString();
                        lblRole.Text = reader["Role"].ToString();
                        lblSidebarName.Text = reader["Name"].ToString();
                        lblSidebarRole.Text = reader["Role"].ToString();
                    }
                    reader.Close();
                }
                catch (Exception ex)
                {
                    System.Diagnostics.Debug.WriteLine("Error loading user info: " + ex.Message);
                }
            }
        }

        private void LoadModuleInfo()
        {
            string cs = ConfigurationManager.ConnectionStrings["dbConnection"].ConnectionString;
            using (SqlConnection con = new SqlConnection(cs))
            {
                try
                {
                    con.Open();
                    SqlCommand cmd = new SqlCommand(@"
                        SELECT M.Title, M.Description, C.CourseID, C.CourseName
                        FROM Modules M
                        JOIN Courses C ON M.CourseID = C.CourseID
                        WHERE M.ModuleID = @ModuleID", con);
                    cmd.Parameters.AddWithValue("@ModuleID", moduleId);

                    SqlDataReader reader = cmd.ExecuteReader();
                    if (reader.Read())
                    {
                        lblModuleTitle.Text = reader["Title"].ToString();
                        lblModuleDescription.Text = reader["Description"].ToString();
                        courseId = Convert.ToInt32(reader["CourseID"]);
                        courseName = reader["CourseName"].ToString();
                        lblCourseTitle.Text = courseName;

                        // Update page title
                        Page.Title = $"{reader["Title"]} - {courseName} - Bulb";
                    }
                    reader.Close();
                }
                catch (Exception ex)
                {
                    System.Diagnostics.Debug.WriteLine("Error loading module info: " + ex.Message);
                }
            }
        }

        private void LoadLessons()
        {
            string cs = ConfigurationManager.ConnectionStrings["dbConnection"].ConnectionString;
            using (SqlConnection con = new SqlConnection(cs))
            {
                try
                {
                    con.Open();
                    SqlCommand cmd = new SqlCommand(@"
                        SELECT LessonID, Title, ContentType, Duration
                        FROM Lessons
                        WHERE ModuleID = @ModuleID
                        ORDER BY LessonID", con);
                    cmd.Parameters.AddWithValue("@ModuleID", moduleId);

                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    DataTable dt = new DataTable();
                    da.Fill(dt);

                    lessonRepeater.DataSource = dt;
                    lessonRepeater.DataBind();
                }
                catch (Exception ex)
                {
                    System.Diagnostics.Debug.WriteLine("Error loading lessons: " + ex.Message);
                }
            }
        }

        private void LoadLessonContent(int lessonId)
        {
            string cs = ConfigurationManager.ConnectionStrings["dbConnection"].ConnectionString;
            using (SqlConnection con = new SqlConnection(cs))
            {
                try
                {
                    con.Open();
                    SqlCommand cmd = new SqlCommand(@"
                        SELECT Title, ContentType, ContentURL, TextContent, Duration
                        FROM Lessons 
                        WHERE LessonID = @LessonID", con);
                    cmd.Parameters.AddWithValue("@LessonID", lessonId);

                    SqlDataReader reader = cmd.ExecuteReader();
                    if (reader.Read())
                    {
                        string title = reader["Title"].ToString();
                        string contentType = reader["ContentType"].ToString();
                        string contentUrl = reader["ContentURL"]?.ToString() ?? "";
                        string textContent = reader["TextContent"]?.ToString() ?? "";
                        string duration = reader["Duration"].ToString();

                        // Set lesson information
                        lblLessonTitle.Text = title;
                        lblLessonDuration.Text = duration;
                        lblContentType.Text = GetContentTypeLabel(contentType);

                        // Hide all content panels first
                        pnlVideoContent.Visible = false;
                        pnlPdfContent.Visible = false;
                        pnlLinkContent.Visible = false;
                        pnlTextContent.Visible = false;

                        // Show appropriate content panel based on content type
                        switch (contentType)
                        {
                            case "Video":
                                pnlVideoContent.Visible = true;
                                videoFrame.Src = contentUrl;
                                break;
                            case "PDF":
                                pnlPdfContent.Visible = true;
                                pdfLink.HRef = contentUrl;
                                break;
                            case "Link":
                                pnlLinkContent.Visible = true;
                                externalLink.HRef = contentUrl;
                                break;
                            case "Text":
                            default:
                                pnlTextContent.Visible = true;
                                litTextContent.Text = textContent;
                                break;
                        }

                        // Show content panel
                        pnlLessonContent.Visible = true;
                        pnlNoLesson.Visible = false;
                    }
                    else
                    {
                        // Lesson not found
                        pnlLessonContent.Visible = false;
                        pnlNoLesson.Visible = true;
                    }
                    reader.Close();
                }
                catch (Exception ex)
                {
                    System.Diagnostics.Debug.WriteLine("Error loading lesson content: " + ex.Message);
                }
            }
        }

        private void SetupNavigationButtons()
        {
            string cs = ConfigurationManager.ConnectionStrings["dbConnection"].ConnectionString;
            using (SqlConnection con = new SqlConnection(cs))
            {
                try
                {
                    con.Open();

                    // Find previous lesson
                    SqlCommand prevCmd = new SqlCommand(@"
                        SELECT TOP 1 LessonID 
                        FROM Lessons 
                        WHERE ModuleID = @ModuleID AND LessonID < @LessonID 
                        ORDER BY LessonID DESC", con);
                    prevCmd.Parameters.AddWithValue("@ModuleID", moduleId);
                    prevCmd.Parameters.AddWithValue("@LessonID", lessonId);

                    object prevLessonId = prevCmd.ExecuteScalar();
                    if (prevLessonId != null && prevLessonId != DBNull.Value)
                    {
                        btnPrevious.NavigateUrl = $"lessons.aspx?moduleID={moduleId}&lessonID={prevLessonId}";
                        btnPrevious.Visible = true;
                    }
                    else
                    {
                        btnPrevious.Visible = false;
                    }

                    // Find next lesson
                    SqlCommand nextCmd = new SqlCommand(@"
                        SELECT TOP 1 LessonID 
                        FROM Lessons 
                        WHERE ModuleID = @ModuleID AND LessonID > @LessonID 
                        ORDER BY LessonID ASC", con);
                    nextCmd.Parameters.AddWithValue("@ModuleID", moduleId);
                    nextCmd.Parameters.AddWithValue("@LessonID", lessonId);

                    object nextLessonId = nextCmd.ExecuteScalar();
                    if (nextLessonId != null && nextLessonId != DBNull.Value)
                    {
                        btnNext.NavigateUrl = $"lessons.aspx?moduleID={moduleId}&lessonID={nextLessonId}";
                        btnNext.Visible = true;
                    }
                    else
                    {
                        btnNext.Visible = false;
                    }
                }
                catch (Exception ex)
                {
                    System.Diagnostics.Debug.WriteLine("Error setting up navigation buttons: " + ex.Message);
                }
            }
        }

        // Helper methods
        protected string GetActiveClass(int currentLessonId)
        {
            return currentLessonId == lessonId ? "active" : "";
        }

        protected string GetContentTypeIcon(object contentTypeObj)
        {
            string contentType = contentTypeObj?.ToString() ?? "Text";

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

        private string GetContentTypeLabel(string contentType)
        {
            switch (contentType)
            {
                case "Video":
                    return "Video Lesson";
                case "PDF":
                    return "PDF Document";
                case "Link":
                    return "External Resource";
                case "Text":
                default:
                    return "Text Lesson";
            }
        }
    }
}