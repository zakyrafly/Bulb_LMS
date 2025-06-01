using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Text.RegularExpressions;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace assignmentDraft1
{
    public partial class ManageLessons : System.Web.UI.Page
    {
        private int lecturerId;
        private int moduleId;
        private int courseId;

        protected void Page_Load(object sender, EventArgs e)
        {
            // Check if user is logged in
            if (Session["email"] == null)
            {
                Response.Redirect("loginWebform.aspx");
                return;
            }

            // Get module ID from query string
            if (Request.QueryString["moduleId"] == null || !int.TryParse(Request.QueryString["moduleId"], out moduleId))
            {
                ShowMessage("Invalid module ID. Redirecting to dashboard...", "error");
                Response.Redirect("TeacherWebform.aspx");
                return;
            }

            // Get course ID from query string (for navigation)
            if (Request.QueryString["courseId"] != null)
            {
                int.TryParse(Request.QueryString["courseId"], out courseId);
            }

            // Load lecturer info and validate permissions
            if (!LoadLecturerInfo())
            {
                return;
            }

            // Validate that this lecturer has access to this module
            if (!ValidateModuleAccess())
            {
                ShowMessage("You don't have permission to manage lessons for this module.", "error");
                Response.Redirect("TeacherWebform.aspx");
                return;
            }

            if (!IsPostBack)
            {
                LoadModuleInfo();
                LoadLessons();
                LoadStatistics();
                hfModuleID.Value = moduleId.ToString();
            }

            // Enable data binding for dynamically generated URLs
            DataBind();
        }

        private bool LoadLecturerInfo()
        {
            string email = Session["email"].ToString();
            string cs = ConfigurationManager.ConnectionStrings["dbConnection"].ConnectionString;

            using (SqlConnection con = new SqlConnection(cs))
            {
                try
                {
                    con.Open();

                    // First check if user is a lecturer
                    SqlCommand userCmd = new SqlCommand("SELECT UserID, Name, Role FROM Users WHERE Username = @Email", con);
                    userCmd.Parameters.AddWithValue("@Email", email);

                    SqlDataReader userReader = userCmd.ExecuteReader();
                    if (userReader.Read())
                    {
                        string role = userReader["Role"].ToString();
                        if (role != "Lecturer")
                        {
                            userReader.Close();
                            Response.Redirect("homeWebform.aspx");
                            return false;
                        }

                        lblName.Text = userReader["Name"].ToString();
                        lblRole.Text = role;
                        lblSidebarName.Text = userReader["Name"].ToString();
                        lblSidebarRole.Text = role;
                    }
                    else
                    {
                        userReader.Close();
                        ShowMessage("User not found.", "error");
                        return false;
                    }
                    userReader.Close();

                    // Get lecturer ID from Lecturers table
                    SqlCommand lecCmd = new SqlCommand("SELECT LecturerID FROM Lecturers WHERE Email = @Email", con);
                    lecCmd.Parameters.AddWithValue("@Email", email);

                    object lecIdObj = lecCmd.ExecuteScalar();
                    if (lecIdObj != null)
                    {
                        lecturerId = Convert.ToInt32(lecIdObj);
                        return true;
                    }
                    else
                    {
                        ShowMessage("Lecturer profile not found. Please contact administrator.", "error");
                        return false;
                    }
                }
                catch (Exception ex)
                {
                    ShowMessage("Error loading lecturer information: " + ex.Message, "error");
                    return false;
                }
            }
        }

        private bool ValidateModuleAccess()
        {
            string cs = ConfigurationManager.ConnectionStrings["dbConnection"].ConnectionString;
            using (SqlConnection con = new SqlConnection(cs))
            {
                try
                {
                    con.Open();

                    // Check if this lecturer has access to this module
                    SqlCommand cmd = new SqlCommand(
                        "SELECT COUNT(*) FROM Modules WHERE ModuleID = @ModuleID AND LecturerID = @LecturerID", con);
                    cmd.Parameters.AddWithValue("@ModuleID", moduleId);
                    cmd.Parameters.AddWithValue("@LecturerID", lecturerId);

                    int count = (int)cmd.ExecuteScalar();
                    return count > 0;
                }
                catch (Exception ex)
                {
                    ShowMessage("Error validating module access: " + ex.Message, "error");
                    return false;
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

                        // Store course ID for navigation breadcrumbs
                        if (courseId == 0) // Only if not already set from query string
                        {
                            courseId = Convert.ToInt32(reader["CourseID"]);
                        }

                        // Update page title
                        Page.Title = $"Manage Lessons - {lblModuleTitle.Text} - Bulb";
                    }
                    else
                    {
                        ShowMessage("Module information not found.", "error");
                    }
                    reader.Close();
                }
                catch (Exception ex)
                {
                    ShowMessage("Error loading module information: " + ex.Message, "error");
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
                        SELECT LessonID, Title, ContentType, ContentURL, TextContent, Duration
                        FROM Lessons
                        WHERE ModuleID = @ModuleID
                        ORDER BY LessonID", con);

                    cmd.Parameters.AddWithValue("@ModuleID", moduleId);

                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    DataTable dt = new DataTable();
                    da.Fill(dt);

                    if (dt.Rows.Count > 0)
                    {
                        rptLessons.DataSource = dt;
                        rptLessons.DataBind();
                        pnlNoLessons.Visible = false;
                    }
                    else
                    {
                        rptLessons.DataSource = null;
                        rptLessons.DataBind();
                        pnlNoLessons.Visible = true;
                    }
                }
                catch (Exception ex)
                {
                    ShowMessage("Error loading lessons: " + ex.Message, "error");
                }
            }
        }

        private void LoadStatistics()
        {
            string cs = ConfigurationManager.ConnectionStrings["dbConnection"].ConnectionString;
            using (SqlConnection con = new SqlConnection(cs))
            {
                try
                {
                    con.Open();

                    // Get lesson count
                    SqlCommand countCmd = new SqlCommand("SELECT COUNT(*) FROM Lessons WHERE ModuleID = @ModuleID", con);
                    countCmd.Parameters.AddWithValue("@ModuleID", moduleId);
                    int lessonCount = (int)countCmd.ExecuteScalar();
                    lblLessonCount.Text = lessonCount.ToString();

                    // Get video and text counts
                    SqlCommand typesCmd = new SqlCommand(@"
                        SELECT 
                            ContentType, 
                            COUNT(*) as TypeCount
                        FROM Lessons 
                        WHERE ModuleID = @ModuleID
                        GROUP BY ContentType", con);
                    typesCmd.Parameters.AddWithValue("@ModuleID", moduleId);

                    SqlDataReader typesReader = typesCmd.ExecuteReader();
                    int videoCount = 0;
                    int textCount = 0;

                    while (typesReader.Read())
                    {
                        string contentType = typesReader["ContentType"].ToString();
                        int count = Convert.ToInt32(typesReader["TypeCount"]);

                        if (contentType == "Video")
                            videoCount += count;
                        else if (contentType == "Text")
                            textCount += count;
                    }
                    typesReader.Close();

                    lblVideosCount.Text = videoCount.ToString();
                    lblTextsCount.Text = textCount.ToString();

                    // Get total duration
                    SqlCommand durationCmd = new SqlCommand(@"
                        SELECT SUM(Duration) FROM Lessons WHERE ModuleID = @ModuleID", con);
                    durationCmd.Parameters.AddWithValue("@ModuleID", moduleId);

                    object totalDurationObj = durationCmd.ExecuteScalar();
                    int totalDuration = 0;

                    if (totalDurationObj != null && totalDurationObj != DBNull.Value)
                    {
                        totalDuration = Convert.ToInt32(totalDurationObj);
                    }

                    lblTotalDuration.Text = $"{totalDuration} min";
                }
                catch (Exception ex)
                {
                    ShowMessage("Error loading statistics: " + ex.Message, "error");
                }
            }
        }

        protected void BtnEditLesson_Click(object sender, EventArgs e)
        {
            try
            {
                LinkButton btn = (LinkButton)sender;
                int lessonId = Convert.ToInt32(btn.CommandArgument);
                LoadLessonForEdit(lessonId);
            }
            catch (Exception ex)
            {
                ShowMessage("Error loading lesson for editing: " + ex.Message, "error");
            }
        }

        private void LoadLessonForEdit(int lessonId)
        {
            string cs = ConfigurationManager.ConnectionStrings["dbConnection"].ConnectionString;
            using (SqlConnection con = new SqlConnection(cs))
            {
                try
                {
                    con.Open();

                    SqlCommand cmd = new SqlCommand(@"
                        SELECT LessonID, Title, ContentType, ContentURL, TextContent, Duration 
                        FROM Lessons 
                        WHERE LessonID = @LessonID AND ModuleID = @ModuleID", con);
                    cmd.Parameters.AddWithValue("@LessonID", lessonId);
                    cmd.Parameters.AddWithValue("@ModuleID", moduleId);

                    SqlDataReader reader = cmd.ExecuteReader();
                    if (reader.Read())
                    {
                        hfLessonID.Value = reader["LessonID"].ToString();
                        txtLessonTitle.Text = reader["Title"]?.ToString() ?? "";
                        ddlContentType.SelectedValue = reader["ContentType"]?.ToString() ?? "Text";
                        txtContentURL.Text = reader["ContentURL"]?.ToString() ?? "";
                        txtTextContent.Text = reader["TextContent"]?.ToString() ?? "";
                        txtDuration.Text = reader["Duration"]?.ToString() ?? "";

                        reader.Close();

                        // Open edit modal via JavaScript
                        ClientScript.RegisterStartupScript(this.GetType(), "openEditModal", "openEditLessonModal();", true);
                    }
                    else
                    {
                        ShowMessage("Lesson not found or you don't have permission to edit it.", "error");
                        reader.Close();
                    }
                }
                catch (Exception ex)
                {
                    ShowMessage("Error loading lesson: " + ex.Message, "error");
                }
            }
        }

        protected void BtnViewLesson_Click(object sender, EventArgs e)
        {
            try
            {
                LinkButton btn = (LinkButton)sender;
                int lessonId = Convert.ToInt32(btn.CommandArgument);
                LoadLessonForView(lessonId);
            }
            catch (Exception ex)
            {
                ShowMessage("Error loading lesson for viewing: " + ex.Message, "error");
            }
        }

        private void LoadLessonForView(int lessonId)
        {
            string cs = ConfigurationManager.ConnectionStrings["dbConnection"].ConnectionString;
            using (SqlConnection con = new SqlConnection(cs))
            {
                try
                {
                    con.Open();

                    SqlCommand cmd = new SqlCommand(@"
                        SELECT LessonID, Title, ContentType, ContentURL, TextContent, Duration 
                        FROM Lessons 
                        WHERE LessonID = @LessonID AND ModuleID = @ModuleID", con);
                    cmd.Parameters.AddWithValue("@LessonID", lessonId);
                    cmd.Parameters.AddWithValue("@ModuleID", moduleId);

                    SqlDataReader reader = cmd.ExecuteReader();
                    if (reader.Read())
                    {
                        lblViewTitle.Text = reader["Title"]?.ToString() ?? "";
                        lblViewContentType.Text = GetContentTypeLabel(reader["ContentType"]?.ToString() ?? "");
                        lblViewDuration.Text = reader["Duration"]?.ToString() ?? "0";

                        string contentType = reader["ContentType"]?.ToString() ?? "";
                        string contentUrl = reader["ContentURL"]?.ToString() ?? "";
                        string textContent = reader["TextContent"]?.ToString() ?? "";

                        // Reset all content panels
                        pnlVideoContent.Visible = false;
                        pnlPdfContent.Visible = false;
                        pnlLinkContent.Visible = false;
                        pnlTextContent.Visible = false;

                        // Show appropriate content panel
                        if (contentType == "Video" && !string.IsNullOrEmpty(contentUrl))
                        {
                            pnlVideoContent.Visible = true;
                            videoFrame.Src = contentUrl;
                        }
                        else if (contentType == "PDF" && !string.IsNullOrEmpty(contentUrl))
                        {
                            pnlPdfContent.Visible = true;
                            pdfLink.HRef = contentUrl;
                        }
                        else if (contentType == "Link" && !string.IsNullOrEmpty(contentUrl))
                        {
                            pnlLinkContent.Visible = true;
                            externalLink.HRef = contentUrl;
                        }
                        else if (contentType == "Text" && !string.IsNullOrEmpty(textContent))
                        {
                            pnlTextContent.Visible = true;
                            litTextContent.Text = textContent;
                        }

                        reader.Close();

                        // Open view modal via JavaScript
                        ClientScript.RegisterStartupScript(this.GetType(), "openViewModal", "openViewLessonModal();", true);
                    }
                    else
                    {
                        ShowMessage("Lesson not found.", "error");
                        reader.Close();
                    }
                }
                catch (Exception ex)
                {
                    ShowMessage("Error loading lesson: " + ex.Message, "error");
                }
            }
        }

        protected void BtnDeleteLesson_Click(object sender, EventArgs e)
        {
            try
            {
                LinkButton btn = (LinkButton)sender;
                int lessonId = Convert.ToInt32(btn.CommandArgument);
                DeleteLesson(lessonId);
            }
            catch (Exception ex)
            {
                ShowMessage("Error deleting lesson: " + ex.Message, "error");
            }
        }

        private void DeleteLesson(int lessonId)
        {
            string cs = ConfigurationManager.ConnectionStrings["dbConnection"].ConnectionString;
            using (SqlConnection con = new SqlConnection(cs))
            {
                try
                {
                    con.Open();

                    // Get lesson information for confirmation
                    SqlCommand lessonInfoCmd = new SqlCommand(@"
                        SELECT Title FROM Lessons 
                        WHERE LessonID = @LessonID AND ModuleID = @ModuleID", con);
                    lessonInfoCmd.Parameters.AddWithValue("@LessonID", lessonId);
                    lessonInfoCmd.Parameters.AddWithValue("@ModuleID", moduleId);

                    string lessonTitle = lessonInfoCmd.ExecuteScalar()?.ToString() ?? "Unknown Lesson";

                    // Delete the lesson
                    SqlCommand deleteCmd = new SqlCommand(@"
                        DELETE FROM Lessons 
                        WHERE LessonID = @LessonID AND ModuleID = @ModuleID", con);
                    deleteCmd.Parameters.AddWithValue("@LessonID", lessonId);
                    deleteCmd.Parameters.AddWithValue("@ModuleID", moduleId);

                    int rowsAffected = deleteCmd.ExecuteNonQuery();
                    if (rowsAffected > 0)
                    {
                        ShowMessage($"Lesson '{lessonTitle}' deleted successfully!", "success");

                        // Clear form if the deleted lesson was being edited
                        if (hfLessonID.Value == lessonId.ToString())
                        {
                            ClearLessonForm();
                        }

                        LoadLessons(); // Reload lessons list
                        LoadStatistics(); // Update statistics
                    }
                    else
                    {
                        ShowMessage("Error deleting lesson. Lesson not found or you don't have permission.", "error");
                    }
                }
                catch (Exception ex)
                {
                    ShowMessage("Database error while deleting lesson: " + ex.Message, "error");
                }
            }
        }

        protected void BtnSaveLesson_Click(object sender, EventArgs e)
        {
            if (!ValidateLessonForm())
                return;

            string cs = ConfigurationManager.ConnectionStrings["dbConnection"].ConnectionString;
            using (SqlConnection con = new SqlConnection(cs))
            {
                try
                {
                    con.Open();

                    if (string.IsNullOrEmpty(hfLessonID.Value))
                    {
                        // Add new lesson
                        SqlCommand insertCmd = new SqlCommand(@"
                            INSERT INTO Lessons (ModuleID, Title, ContentType, ContentURL, TextContent, Duration)
                            VALUES (@ModuleID, @Title, @ContentType, @ContentURL, @TextContent, @Duration)", con);

                        insertCmd.Parameters.AddWithValue("@ModuleID", moduleId);
                        insertCmd.Parameters.AddWithValue("@Title", txtLessonTitle.Text.Trim());
                        insertCmd.Parameters.AddWithValue("@ContentType", ddlContentType.SelectedValue);
                        insertCmd.Parameters.AddWithValue("@ContentURL", ddlContentType.SelectedValue == "Text" ? DBNull.Value : (object)txtContentURL.Text.Trim());
                        insertCmd.Parameters.AddWithValue("@TextContent", ddlContentType.SelectedValue == "Text" ? (object)txtTextContent.Text.Trim() : DBNull.Value);
                        insertCmd.Parameters.AddWithValue("@Duration", Convert.ToInt32(txtDuration.Text.Trim()));

                        insertCmd.ExecuteNonQuery();

                        ShowMessage($"Lesson '{txtLessonTitle.Text.Trim()}' added successfully!", "success");
                    }
                    else
                    {
                        // Update existing lesson
                        int lessonId = Convert.ToInt32(hfLessonID.Value);

                        SqlCommand updateCmd = new SqlCommand(@"
                            UPDATE Lessons
                            SET Title = @Title, ContentType = @ContentType, ContentURL = @ContentURL, 
                                TextContent = @TextContent, Duration = @Duration
                            WHERE LessonID = @LessonID AND ModuleID = @ModuleID", con);

                        updateCmd.Parameters.AddWithValue("@LessonID", lessonId);
                        updateCmd.Parameters.AddWithValue("@ModuleID", moduleId);
                        updateCmd.Parameters.AddWithValue("@Title", txtLessonTitle.Text.Trim());
                        updateCmd.Parameters.AddWithValue("@ContentType", ddlContentType.SelectedValue);
                        updateCmd.Parameters.AddWithValue("@ContentURL", ddlContentType.SelectedValue == "Text" ? DBNull.Value : (object)txtContentURL.Text.Trim());
                        updateCmd.Parameters.AddWithValue("@TextContent", ddlContentType.SelectedValue == "Text" ? (object)txtTextContent.Text.Trim() : DBNull.Value);
                        updateCmd.Parameters.AddWithValue("@Duration", Convert.ToInt32(txtDuration.Text.Trim()));

                        int rowsAffected = updateCmd.ExecuteNonQuery();
                        if (rowsAffected > 0)
                        {
                            ShowMessage($"Lesson '{txtLessonTitle.Text.Trim()}' updated successfully!", "success");
                        }
                        else
                        {
                            ShowMessage("Error updating lesson. Lesson not found or you don't have permission.", "error");
                        }
                    }

                    // Clear form and reload
                    ClearLessonForm();
                    LoadLessons();
                    LoadStatistics();

                    // Close modal via JavaScript
                    ClientScript.RegisterStartupScript(this.GetType(), "closeModal", "closeLessonModal();", true);
                }
                catch (Exception ex)
                {
                    ShowMessage("Error saving lesson: " + ex.Message, "error");
                }
            }
        }

        private bool ValidateLessonForm()
        {
            if (string.IsNullOrWhiteSpace(txtLessonTitle.Text))
            {
                ShowMessage("Please enter lesson title.", "error");
                return false;
            }

            if (txtLessonTitle.Text.Trim().Length < 3)
            {
                ShowMessage("Lesson title must be at least 3 characters long.", "error");
                return false;
            }

            if (string.IsNullOrWhiteSpace(txtDuration.Text) || !int.TryParse(txtDuration.Text, out int duration) || duration < 1)
            {
                ShowMessage("Please enter a valid duration (positive number).", "error");
                return false;
            }

            string contentType = ddlContentType.SelectedValue;

            if (contentType != "Text")
            {
                if (string.IsNullOrWhiteSpace(txtContentURL.Text))
                {
                    ShowMessage($"Please enter a URL for the {contentType} content.", "error");
                    return false;
                }

                // Validate URL format
                if (!Uri.TryCreate(txtContentURL.Text.Trim(), UriKind.Absolute, out Uri uriResult)
                    || (uriResult.Scheme != Uri.UriSchemeHttp && uriResult.Scheme != Uri.UriSchemeHttps))
                {
                    ShowMessage("Please enter a valid URL (starting with http:// or https://).", "error");
                    return false;
                }

                // YouTube validation for video type
                if (contentType == "Video" && txtContentURL.Text.Contains("youtube.com"))
                {
                    if (!txtContentURL.Text.Contains("youtube.com/embed/"))
                    {
                        ShowMessage("For YouTube videos, please use the embed URL format: https://www.youtube.com/embed/VIDEO_ID", "error");
                        return false;
                    }
                }
            }
            else // Text content
            {
                if (string.IsNullOrWhiteSpace(txtTextContent.Text))
                {
                    ShowMessage("Please enter the text content for the lesson.", "error");
                    return false;
                }

                if (txtTextContent.Text.Trim().Length < 10)
                {
                    ShowMessage("Text content must be at least 10 characters long.", "error");
                    return false;
                }
            }

            return true;
        }

        private void ClearLessonForm()
        {
            hfLessonID.Value = "";
            txtLessonTitle.Text = "";
            ddlContentType.SelectedValue = "Text";
            txtContentURL.Text = "";
            txtTextContent.Text = "";
            txtDuration.Text = "";
        }

        // Helper methods for the repeater
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

        protected string GetContentPreview(string contentType, object textContent, object contentUrl)
        {
            if (contentType == "Text" && textContent != null && textContent != DBNull.Value)
            {
                string text = textContent.ToString();
                // Truncate long text for preview
                if (text.Length > 150)
                {
                    text = text.Substring(0, 150) + "...";
                }
                return text;
            }
            else if (contentUrl != null && contentUrl != DBNull.Value)
            {
                string url = contentUrl.ToString();
                if (contentType == "Video")
                {
                    return $"<i class=\"fas fa-video\"></i> Video at: {url}";
                }
                else if (contentType == "PDF")
                {
                    return $"<i class=\"fas fa-file-pdf\"></i> PDF Document";
                }
                else if (contentType == "Link")
                {
                    return $"<i class=\"fas fa-external-link-alt\"></i> External Resource: {url}";
                }
            }
            return "No preview available";
        }

        private void ShowMessage(string message, string type)
        {
            lblMessage.Text = message;
            lblMessage.CssClass = $"message {type}";
            lblMessage.Visible = true;

            // Add client-side styling and auto-hide
            string messageClass = type == "error" ? "error" : "success";
            string script = $@"
                var msgElement = document.getElementById('{lblMessage.ClientID}');
                if (msgElement) {{
                    msgElement.className = 'message {messageClass}';
                    msgElement.style.display = 'block';
                    setTimeout(function() {{
                        msgElement.style.display = 'none';
                    }}, 5000);
                }}";

            ClientScript.RegisterStartupScript(this.GetType(), "showMessage", script, true);
        }

        // Override for better error handling
        protected override void OnError(EventArgs e)
        {
            Exception ex = Server.GetLastError();
            if (ex != null)
            {
                System.Diagnostics.Debug.WriteLine("ManageLessons Page Error: " + ex.Message);

                // Clear the error
                Server.ClearError();

                // Show user-friendly message
                ShowMessage("An unexpected error occurred. Please try again or contact support if the problem persists.", "error");
            }

            base.OnError(e);
        }
    }
}