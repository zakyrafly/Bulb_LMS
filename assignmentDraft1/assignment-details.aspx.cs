using System;
using System.Configuration;
using System.Data.SqlClient;
using System.IO;
using System.Web.UI;

namespace assignmentDraft1
{
    public partial class assignment_details : System.Web.UI.Page
    {
        private int assignmentId;
        private int userId;

        protected void Page_Load(object sender, EventArgs e)
        {
            // Check if user is logged in
            if (Session["email"] == null)
            {
                Response.Redirect("loginWebform.aspx");
                return;
            }

            // Get assignment ID from query string
            if (Request.QueryString["assignmentID"] == null ||
                !int.TryParse(Request.QueryString["assignmentID"], out assignmentId))
            {
                Response.Redirect("homeWebform.aspx");
                return;
            }

            if (!IsPostBack)
            {
                LoadUserInfo();
                LoadAssignmentDetails();
                CheckSubmissionStatus();
            }
        }

        private void LoadUserInfo()
        {
            string email = Session["email"].ToString();
            string cs = ConfigurationManager.ConnectionStrings["dbConnection"].ConnectionString;

            using (SqlConnection con = new SqlConnection(cs))
            {
                string query = "SELECT UserID, Name, Role FROM Users WHERE Username = @Email";
                SqlCommand cmd = new SqlCommand(query, con);
                cmd.Parameters.AddWithValue("@Email", email);

                con.Open();
                SqlDataReader reader = cmd.ExecuteReader();
                if (reader.Read())
                {
                    userId = Convert.ToInt32(reader["UserID"]);
                    lblName.Text = reader["Name"].ToString();
                    lblRole.Text = reader["Role"].ToString();
                    lblSidebarName.Text = reader["Name"].ToString();
                    lblSidebarRole.Text = reader["Role"].ToString();
                }
                else
                {
                    Response.Redirect("loginWebform.aspx");
                }
            }
        }

        private void LoadAssignmentDetails()
        {
            string cs = ConfigurationManager.ConnectionStrings["dbConnection"].ConnectionString;
            using (SqlConnection con = new SqlConnection(cs))
            {
                con.Open();
                SqlCommand cmd = new SqlCommand(@"
                    SELECT 
                        a.Title, a.Description, a.Instructions, a.DueDate, a.MaxPoints,
                        c.CourseName, l.FullName as LecturerName
                    FROM Assignments a
                    JOIN Modules m ON a.ModuleID = m.ModuleID
                    JOIN Courses c ON m.CourseID = c.CourseID
                    LEFT JOIN Lecturers l ON m.LecturerID = l.LecturerID
                    WHERE a.AssignmentID = @AssignmentID", con);

                cmd.Parameters.AddWithValue("@AssignmentID", assignmentId);
                SqlDataReader reader = cmd.ExecuteReader();

                if (reader.Read())
                {
                    lblAssignmentTitle.Text = reader["Title"].ToString();
                    lblDescription.Text = reader["Description"].ToString();
                    lblCourseName.Text = reader["CourseName"].ToString();
                    lblDueDate.Text = Convert.ToDateTime(reader["DueDate"]).ToString("MMM dd, yyyy hh:mm tt");
                    lblMaxPoints.Text = reader["MaxPoints"].ToString();
                    lblTotalPoints.Text = reader["MaxPoints"].ToString();
                    lblInstructor.Text = reader["LecturerName"]?.ToString() ?? "Not Assigned";

                    if (!reader.IsDBNull(reader.GetOrdinal("Instructions")) &&
                        !string.IsNullOrWhiteSpace(reader["Instructions"].ToString()))
                    {
                        lblInstructions.Text = reader["Instructions"].ToString();
                        pnlInstructions.Visible = true;
                    }

                    // Check if assignment is overdue
                    DateTime dueDate = Convert.ToDateTime(reader["DueDate"]);
                    if (dueDate < DateTime.Now)
                    {
                        lblStatusBadge.Text = "Overdue";
                        lblStatusBadge.CssClass = "status-badge status-overdue";
                    }
                    else
                    {
                        lblStatusBadge.Text = "Active";
                        lblStatusBadge.CssClass = "status-badge status-pending";
                    }
                }
                else
                {
                    lblMessage.Text = "Assignment not found.";
                    lblMessage.ForeColor = System.Drawing.Color.Red;
                    pnlSubmissionForm.Visible = false;
                }
            }
        }

        private void CheckSubmissionStatus()
        {
            string cs = ConfigurationManager.ConnectionStrings["dbConnection"].ConnectionString;
            using (SqlConnection con = new SqlConnection(cs))
            {
                con.Open();
                SqlCommand cmd = new SqlCommand(@"
                    SELECT 
                        s.SubmissionID, s.SubmissionText, s.AttachmentPath, s.SubmissionDate, s.Status,
                        g.PointsEarned, g.Feedback, g.GradedDate
                    FROM AssignmentSubmissions s
                    LEFT JOIN AssignmentGrades g ON s.SubmissionID = g.SubmissionID
                    WHERE s.AssignmentID = @AssignmentID AND s.UserID = @UserID", con);

                cmd.Parameters.AddWithValue("@AssignmentID", assignmentId);
                cmd.Parameters.AddWithValue("@UserID", userId);

                SqlDataReader reader = cmd.ExecuteReader();
                if (reader.Read())
                {
                    // Student has submitted
                    pnlExistingSubmission.Visible = true;
                    lblSubmissionDate.Text = Convert.ToDateTime(reader["SubmissionDate"]).ToString("MMM dd, yyyy hh:mm tt");

                    // Show submission text if available
                    if (!reader.IsDBNull(reader.GetOrdinal("SubmissionText")) &&
                        !string.IsNullOrWhiteSpace(reader["SubmissionText"].ToString()))
                    {
                        lblSubmittedText.Text = reader["SubmissionText"].ToString();
                        pnlSubmissionText.Visible = true;
                    }

                    // Show file download link if available
                    if (!reader.IsDBNull(reader.GetOrdinal("AttachmentPath")) &&
                        !string.IsNullOrWhiteSpace(reader["AttachmentPath"].ToString()))
                    {
                        pnlSubmissionFile.Visible = true;
                        lnkDownloadFile.CommandArgument = reader["AttachmentPath"].ToString();
                    }

                    // Check if graded
                    if (!reader.IsDBNull(reader.GetOrdinal("PointsEarned")))
                    {
                        pnlGradeDisplay.Visible = true;
                        lblEarnedPoints.Text = reader["PointsEarned"].ToString();
                        lblGradedDate.Text = Convert.ToDateTime(reader["GradedDate"]).ToString("MMM dd, yyyy");

                        if (!reader.IsDBNull(reader.GetOrdinal("Feedback")) &&
                            !string.IsNullOrWhiteSpace(reader["Feedback"].ToString()))
                        {
                            lblFeedback.Text = reader["Feedback"].ToString();
                            pnlFeedback.Visible = true;
                        }

                        lblStatusBadge.Text = "Graded";
                        lblStatusBadge.CssClass = "status-badge status-graded";
                    }
                    else
                    {
                        lblStatusBadge.Text = "Submitted";
                        lblStatusBadge.CssClass = "status-badge status-submitted";
                    }

                    // Hide submission form if already submitted (unless it's a draft)
                    string status = reader["Status"].ToString();
                    if (status == "Submitted")
                    {
                        pnlSubmissionForm.Visible = false;
                    }
                    else
                    {
                        // If it's a draft, load the existing content
                        txtSubmission.Text = reader["SubmissionText"]?.ToString() ?? "";
                    }
                }
                else
                {
                    // No submission yet - show form
                    pnlSubmissionForm.Visible = true;
                    pnlExistingSubmission.Visible = false;
                }
            }
        }

        protected void btnSubmit_Click(object sender, EventArgs e)
        {
            if (string.IsNullOrWhiteSpace(txtSubmission.Text) && !fileUpload.HasFile)
            {
                lblMessage.Text = "Please provide either text submission or upload a file.";
                lblMessage.ForeColor = System.Drawing.Color.Red;
                return;
            }

            SubmitAssignment("Submitted");
        }

        protected void btnSaveDraft_Click(object sender, EventArgs e)
        {
            SubmitAssignment("Draft");
        }

        private void SubmitAssignment(string status)
        {
            string cs = ConfigurationManager.ConnectionStrings["dbConnection"].ConnectionString;
            string attachmentPath = null;

            // Handle file upload
            if (fileUpload.HasFile)
            {
                string allowedExtensions = ".pdf,.doc,.docx,.txt";
                string fileExtension = Path.GetExtension(fileUpload.FileName).ToLower();

                if (!allowedExtensions.Contains(fileExtension))
                {
                    lblMessage.Text = "Invalid file type. Please upload PDF, DOC, DOCX, or TXT files only.";
                    lblMessage.ForeColor = System.Drawing.Color.Red;
                    return;
                }

                if (fileUpload.PostedFile.ContentLength > 10 * 1024 * 1024) // 10MB limit
                {
                    lblMessage.Text = "File size must be less than 10MB.";
                    lblMessage.ForeColor = System.Drawing.Color.Red;
                    return;
                }

                try
                {
                    string uploadFolder = Server.MapPath("~/Uploads/Assignments/");
                    if (!Directory.Exists(uploadFolder))
                        Directory.CreateDirectory(uploadFolder);

                    string fileName = $"{userId}_{assignmentId}_{DateTime.Now:yyyyMMddHHmmss}_{fileUpload.FileName}";
                    attachmentPath = Path.Combine(uploadFolder, fileName);
                    fileUpload.SaveAs(attachmentPath);
                    attachmentPath = $"~/Uploads/Assignments/{fileName}"; // Store relative path
                }
                catch (Exception ex)
                {
                    lblMessage.Text = "Error uploading file: " + ex.Message;
                    lblMessage.ForeColor = System.Drawing.Color.Red;
                    return;
                }
            }

            using (SqlConnection con = new SqlConnection(cs))
            {
                con.Open();

                // Check if submission already exists
                SqlCommand checkCmd = new SqlCommand("SELECT SubmissionID FROM AssignmentSubmissions WHERE AssignmentID = @AssignmentID AND UserID = @UserID", con);
                checkCmd.Parameters.AddWithValue("@AssignmentID", assignmentId);
                checkCmd.Parameters.AddWithValue("@UserID", userId);

                object existingSubmissionId = checkCmd.ExecuteScalar();

                if (existingSubmissionId != null)
                {
                    // Update existing submission
                    SqlCommand updateCmd = new SqlCommand(@"
                        UPDATE AssignmentSubmissions 
                        SET SubmissionText = @SubmissionText, 
                            AttachmentPath = COALESCE(@AttachmentPath, AttachmentPath),
                            SubmissionDate = @SubmissionDate,
                            Status = @Status,
                            IsLate = @IsLate
                        WHERE SubmissionID = @SubmissionID", con);

                    updateCmd.Parameters.AddWithValue("@SubmissionText", txtSubmission.Text.Trim());
                    updateCmd.Parameters.AddWithValue("@AttachmentPath", (object)attachmentPath ?? DBNull.Value);
                    updateCmd.Parameters.AddWithValue("@SubmissionDate", DateTime.Now);
                    updateCmd.Parameters.AddWithValue("@Status", status);
                    updateCmd.Parameters.AddWithValue("@SubmissionID", existingSubmissionId);

                    // Check if late
                    SqlCommand dueDateCmd = new SqlCommand("SELECT DueDate FROM Assignments WHERE AssignmentID = @AssignmentID", con);
                    dueDateCmd.Parameters.AddWithValue("@AssignmentID", assignmentId);
                    DateTime dueDate = (DateTime)dueDateCmd.ExecuteScalar();
                    updateCmd.Parameters.AddWithValue("@IsLate", DateTime.Now > dueDate);

                    updateCmd.ExecuteNonQuery();
                }
                else
                {
                    // Create new submission
                    SqlCommand getIdCmd = new SqlCommand("SELECT ISNULL(MAX(SubmissionID), 0) + 1 FROM AssignmentSubmissions", con);
                    int newSubmissionId = (int)getIdCmd.ExecuteScalar();

                    SqlCommand insertCmd = new SqlCommand(@"
                        INSERT INTO AssignmentSubmissions 
                        (SubmissionID, AssignmentID, UserID, SubmissionText, AttachmentPath, SubmissionDate, Status, IsLate)
                        VALUES (@SubmissionID, @AssignmentID, @UserID, @SubmissionText, @AttachmentPath, @SubmissionDate, @Status, @IsLate)", con);

                    insertCmd.Parameters.AddWithValue("@SubmissionID", newSubmissionId);
                    insertCmd.Parameters.AddWithValue("@AssignmentID", assignmentId);
                    insertCmd.Parameters.AddWithValue("@UserID", userId);
                    insertCmd.Parameters.AddWithValue("@SubmissionText", txtSubmission.Text.Trim());
                    insertCmd.Parameters.AddWithValue("@AttachmentPath", (object)attachmentPath ?? DBNull.Value);
                    insertCmd.Parameters.AddWithValue("@SubmissionDate", DateTime.Now);
                    insertCmd.Parameters.AddWithValue("@Status", status);

                    // Check if late
                    SqlCommand dueDateCmd = new SqlCommand("SELECT DueDate FROM Assignments WHERE AssignmentID = @AssignmentID", con);
                    dueDateCmd.Parameters.AddWithValue("@AssignmentID", assignmentId);
                    DateTime dueDate = (DateTime)dueDateCmd.ExecuteScalar();
                    insertCmd.Parameters.AddWithValue("@IsLate", DateTime.Now > dueDate);

                    insertCmd.ExecuteNonQuery();
                }

                string message = status == "Draft" ? "Draft saved successfully!" : "Assignment submitted successfully!";
                lblMessage.Text = message;
                lblMessage.ForeColor = System.Drawing.Color.Green;

                // Refresh the page to show updated status
                if (status == "Submitted")
                {
                    Response.Redirect(Request.RawUrl);
                }
            }
        }

        protected void lnkDownloadFile_Click(object sender, EventArgs e)
        {
            string filePath = lnkDownloadFile.CommandArgument;
            string fullPath = Server.MapPath(filePath);

            if (File.Exists(fullPath))
            {
                Response.ContentType = "application/octet-stream";
                Response.AppendHeader("Content-Disposition", "attachment; filename=" + Path.GetFileName(fullPath));
                Response.WriteFile(fullPath);
                Response.End();
            }
            else
            {
                lblMessage.Text = "File not found.";
                lblMessage.ForeColor = System.Drawing.Color.Red;
            }
        }

        protected void btnSearch_Click(object sender, EventArgs e)
        {
            string query = txtSearch.Text.Trim();
            if (!string.IsNullOrEmpty(query))
            {
                Response.Redirect("searchResults.aspx?query=" + Server.UrlEncode(query));
            }
        }
    }
}