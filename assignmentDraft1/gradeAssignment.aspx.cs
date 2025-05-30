using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace assignmentDraft1
{
    public partial class gradeAssignment : System.Web.UI.Page
    {
        private int assignmentId;
        private int maxPoints;

        protected void Page_Load(object sender, EventArgs e)
        {
            // Check if user is logged in and is admin
            if (Session["email"] == null)
            {
                Response.Redirect("loginWebform.aspx");
                return;
            }

            // Get assignment ID from query string
            if (Request.QueryString["assignmentID"] != null && int.TryParse(Request.QueryString["assignmentID"], out assignmentId))
            {
                // Load admin info on every page load
                LoadAdminInfo();

                if (!IsPostBack)
                {
                    LoadAssignmentDetails();
                    LoadSubmissions();
                }
            }
            else
            {
                Response.Redirect("manageAssignments.aspx");
            }
        }

        private void LoadAdminInfo()
        {
            string email = Session["email"].ToString();
            string cs = ConfigurationManager.ConnectionStrings["dbConnection"].ConnectionString;

            using (SqlConnection con = new SqlConnection(cs))
            {
                con.Open();

                // Check if user is admin
                SqlCommand userCmd = new SqlCommand("SELECT UserID, Name, Role FROM Users WHERE username = @Email", con);
                userCmd.Parameters.AddWithValue("@Email", email);

                SqlDataReader userReader = userCmd.ExecuteReader();
                if (userReader.Read())
                {
                    string role = userReader["Role"].ToString();
                    if (role != "Admin")
                    {
                        userReader.Close();
                        Response.Redirect("loginWebform.aspx"); // Redirect non-admins
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

        private void LoadAssignmentDetails()
        {
            string cs = ConfigurationManager.ConnectionStrings["dbConnection"].ConnectionString;
            using (SqlConnection con = new SqlConnection(cs))
            {
                con.Open();

                SqlCommand cmd = new SqlCommand(@"
                    SELECT 
                        A.Title, A.Description, A.DueDate, A.MaxPoints,
                        C.CourseName, M.Title AS ModuleTitle
                    FROM Assignments A
                    JOIN Modules M ON A.ModuleID = M.ModuleID
                    JOIN Courses C ON M.CourseID = C.CourseID
                    WHERE A.AssignmentID = @AssignmentID", con);
                cmd.Parameters.AddWithValue("@AssignmentID", assignmentId);

                SqlDataReader reader = cmd.ExecuteReader();
                if (reader.Read())
                {
                    lblAssignmentTitle.Text = reader["Title"].ToString();
                    lblCourseName.Text = reader["CourseName"].ToString();
                    lblModuleName.Text = reader["ModuleTitle"].ToString();
                    lblDueDate.Text = Convert.ToDateTime(reader["DueDate"]).ToString("MMM dd, yyyy hh:mm tt");
                    lblMaxPoints.Text = reader["MaxPoints"].ToString() + " points";
                    lblDescription.Text = reader["Description"].ToString();

                    maxPoints = Convert.ToInt32(reader["MaxPoints"]);
                }
            }
        }

        private void LoadSubmissions()
        {
            string cs = ConfigurationManager.ConnectionStrings["dbConnection"].ConnectionString;
            using (SqlConnection con = new SqlConnection(cs))
            {
                con.Open();

                // Get all students enrolled in this course and their submission/grade status
                SqlCommand cmd = new SqlCommand(@"
                    SELECT 
                        U.UserID,
                        U.Name AS StudentName,
                        U.username AS StudentEmail,
                        S.SubmissionID,
                        S.SubmissionText,
                        S.AttachmentPath,
                        S.SubmissionDate,
                        S.IsLate,
                        G.PointsEarned,
                        G.Feedback,
                        G.GradedDate,
                        A.MaxPoints
                    FROM Users U
                    JOIN UserCourses UC ON U.UserID = UC.UserID
                    JOIN Modules M ON UC.CourseID = M.CourseID
                    JOIN Assignments A ON M.ModuleID = A.ModuleID
                    LEFT JOIN AssignmentSubmissions S ON A.AssignmentID = S.AssignmentID AND U.UserID = S.UserID
                    LEFT JOIN AssignmentGrades G ON S.SubmissionID = G.SubmissionID
                    WHERE A.AssignmentID = @AssignmentID AND U.Role = 'Student'
                    ORDER BY U.Name", con);
                cmd.Parameters.AddWithValue("@AssignmentID", assignmentId);

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);

                if (dt.Rows.Count > 0)
                {
                    submissionRepeater.DataSource = dt;
                    submissionRepeater.DataBind();
                    pnlNoSubmissions.Visible = false;

                    // Update statistics
                    int totalSubmissions = 0;
                    int gradedCount = 0;

                    foreach (DataRow row in dt.Rows)
                    {
                        if (row["SubmissionDate"] != DBNull.Value)
                            totalSubmissions++;
                        if (row["PointsEarned"] != DBNull.Value)
                            gradedCount++;
                    }

                    lblTotalSubmissions.Text = totalSubmissions.ToString();
                    lblGradedCount.Text = gradedCount.ToString();
                }
                else
                {
                    submissionRepeater.DataSource = null;
                    submissionRepeater.DataBind();
                    pnlNoSubmissions.Visible = true;
                    lblTotalSubmissions.Text = "0";
                    lblGradedCount.Text = "0";
                }
            }
        }

        protected void submissionRepeater_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            int userId = Convert.ToInt32(e.CommandArgument);

            switch (e.CommandName)
            {
                case "SaveGrade":
                    SaveGrade(userId, e.Item);
                    break;
                case "ClearGrade":
                    ClearGrade(userId);
                    break;
            }
        }

        private void SaveGrade(int userId, RepeaterItem item)
        {
            try
            {
                // Find the input controls in the repeater item
                TextBox txtPoints = (TextBox)item.FindControl("txtPoints_" + userId);
                TextBox txtFeedback = (TextBox)item.FindControl("txtFeedback_" + userId);

                if (txtPoints == null || txtFeedback == null)
                {
                    ShowMessage("Error finding form controls.", "red");
                    return;
                }

                string pointsText = txtPoints.Text.Trim();
                string feedback = txtFeedback.Text.Trim();

                if (string.IsNullOrEmpty(pointsText))
                {
                    ShowMessage("Please enter points earned.", "red");
                    return;
                }

                if (!double.TryParse(pointsText, out double pointsEarned))
                {
                    ShowMessage("Please enter a valid number for points.", "red");
                    return;
                }

                if (pointsEarned < 0 || pointsEarned > maxPoints)
                {
                    ShowMessage($"Points must be between 0 and {maxPoints}.", "red");
                    return;
                }

                string cs = ConfigurationManager.ConnectionStrings["dbConnection"].ConnectionString;
                using (SqlConnection con = new SqlConnection(cs))
                {
                    con.Open();

                    // First, get or create the submission
                    SqlCommand getSubmissionCmd = new SqlCommand(@"
                        SELECT SubmissionID FROM AssignmentSubmissions 
                        WHERE AssignmentID = @AssignmentID AND UserID = @UserID", con);
                    getSubmissionCmd.Parameters.AddWithValue("@AssignmentID", assignmentId);
                    getSubmissionCmd.Parameters.AddWithValue("@UserID", userId);

                    object submissionIdObj = getSubmissionCmd.ExecuteScalar();
                    int submissionId;

                    if (submissionIdObj == null)
                    {
                        // Create a submission record if none exists
                        SqlCommand getNewSubmissionIdCmd = new SqlCommand("SELECT ISNULL(MAX(SubmissionID), 0) + 1 FROM AssignmentSubmissions", con);
                        submissionId = (int)getNewSubmissionIdCmd.ExecuteScalar();

                        SqlCommand createSubmissionCmd = new SqlCommand(@"
                            INSERT INTO AssignmentSubmissions (SubmissionID, AssignmentID, UserID, SubmissionText, SubmissionDate, Status, IsLate)
                            VALUES (@SubmissionID, @AssignmentID, @UserID, @SubmissionText, @SubmissionDate, @Status, @IsLate)", con);
                        createSubmissionCmd.Parameters.AddWithValue("@SubmissionID", submissionId);
                        createSubmissionCmd.Parameters.AddWithValue("@AssignmentID", assignmentId);
                        createSubmissionCmd.Parameters.AddWithValue("@UserID", userId);
                        createSubmissionCmd.Parameters.AddWithValue("@SubmissionText", "Admin graded submission");
                        createSubmissionCmd.Parameters.AddWithValue("@SubmissionDate", DateTime.Now);
                        createSubmissionCmd.Parameters.AddWithValue("@Status", "Submitted");
                        createSubmissionCmd.Parameters.AddWithValue("@IsLate", false);
                        createSubmissionCmd.ExecuteNonQuery();
                    }
                    else
                    {
                        submissionId = Convert.ToInt32(submissionIdObj);
                    }

                    // Check if grade already exists
                    SqlCommand checkGradeCmd = new SqlCommand("SELECT GradeID FROM AssignmentGrades WHERE SubmissionID = @SubmissionID", con);
                    checkGradeCmd.Parameters.AddWithValue("@SubmissionID", submissionId);
                    object gradeIdObj = checkGradeCmd.ExecuteScalar();

                    if (gradeIdObj == null)
                    {
                        // Insert new grade
                        SqlCommand getNewGradeIdCmd = new SqlCommand("SELECT ISNULL(MAX(GradeID), 0) + 1 FROM AssignmentGrades", con);
                        int newGradeId = (int)getNewGradeIdCmd.ExecuteScalar();

                        SqlCommand insertGradeCmd = new SqlCommand(@"
                            INSERT INTO AssignmentGrades (GradeID, SubmissionID, GradedBy, PointsEarned, Feedback, GradedDate)
                            VALUES (@GradeID, @SubmissionID, @GradedBy, @PointsEarned, @Feedback, @GradedDate)", con);
                        insertGradeCmd.Parameters.AddWithValue("@GradeID", newGradeId);
                        insertGradeCmd.Parameters.AddWithValue("@SubmissionID", submissionId);
                        insertGradeCmd.Parameters.AddWithValue("@GradedBy", Session["email"].ToString());
                        insertGradeCmd.Parameters.AddWithValue("@PointsEarned", pointsEarned);
                        insertGradeCmd.Parameters.AddWithValue("@Feedback", string.IsNullOrWhiteSpace(feedback) ? (object)DBNull.Value : feedback);
                        insertGradeCmd.Parameters.AddWithValue("@GradedDate", DateTime.Now);
                        insertGradeCmd.ExecuteNonQuery();
                    }
                    else
                    {
                        // Update existing grade
                        SqlCommand updateGradeCmd = new SqlCommand(@"
                            UPDATE AssignmentGrades 
                            SET PointsEarned = @PointsEarned, Feedback = @Feedback, GradedDate = @GradedDate, GradedBy = @GradedBy
                            WHERE SubmissionID = @SubmissionID", con);
                        updateGradeCmd.Parameters.AddWithValue("@SubmissionID", submissionId);
                        updateGradeCmd.Parameters.AddWithValue("@PointsEarned", pointsEarned);
                        updateGradeCmd.Parameters.AddWithValue("@Feedback", string.IsNullOrWhiteSpace(feedback) ? (object)DBNull.Value : feedback);
                        updateGradeCmd.Parameters.AddWithValue("@GradedDate", DateTime.Now);
                        updateGradeCmd.Parameters.AddWithValue("@GradedBy", Session["email"].ToString());
                        updateGradeCmd.ExecuteNonQuery();
                    }

                    ShowMessage("Grade saved successfully!", "green");
                    LoadSubmissions(); // Refresh the data
                }
            }
            catch (Exception ex)
            {
                ShowMessage("Error saving grade: " + ex.Message, "red");
            }
        }

        private void ClearGrade(int userId)
        {
            try
            {
                string cs = ConfigurationManager.ConnectionStrings["dbConnection"].ConnectionString;
                using (SqlConnection con = new SqlConnection(cs))
                {
                    con.Open();

                    // Get submission ID
                    SqlCommand getSubmissionCmd = new SqlCommand(@"
                        SELECT SubmissionID FROM AssignmentSubmissions 
                        WHERE AssignmentID = @AssignmentID AND UserID = @UserID", con);
                    getSubmissionCmd.Parameters.AddWithValue("@AssignmentID", assignmentId);
                    getSubmissionCmd.Parameters.AddWithValue("@UserID", userId);

                    object submissionIdObj = getSubmissionCmd.ExecuteScalar();
                    if (submissionIdObj != null)
                    {
                        int submissionId = Convert.ToInt32(submissionIdObj);

                        // Delete the grade
                        SqlCommand deleteGradeCmd = new SqlCommand("DELETE FROM AssignmentGrades WHERE SubmissionID = @SubmissionID", con);
                        deleteGradeCmd.Parameters.AddWithValue("@SubmissionID", submissionId);
                        deleteGradeCmd.ExecuteNonQuery();

                        ShowMessage("Grade cleared successfully!", "green");
                        LoadSubmissions(); // Refresh the data
                    }
                    else
                    {
                        ShowMessage("No submission found to clear grade from.", "red");
                    }
                }
            }
            catch (Exception ex)
            {
                ShowMessage("Error clearing grade: " + ex.Message, "red");
            }
        }

        protected void btnApplyBulk_Click(object sender, EventArgs e)
        {
            if (string.IsNullOrEmpty(ddlBulkAction.SelectedValue))
            {
                ShowMessage("Please select a bulk action.", "red");
                return;
            }

            switch (ddlBulkAction.SelectedValue)
            {
                case "GradeComplete":
                    ApplyBulkCompleteGrade();
                    break;
                case "SendReminder":
                    SendBulkReminder();
                    break;
            }
        }

        private void ApplyBulkCompleteGrade()
        {
            try
            {
                string cs = ConfigurationManager.ConnectionStrings["dbConnection"].ConnectionString;
                using (SqlConnection con = new SqlConnection(cs))
                {
                    con.Open();

                    // Get all students who have submitted but not been graded
                    SqlCommand getUngraded = new SqlCommand(@"
                        SELECT S.SubmissionID, S.UserID
                        FROM AssignmentSubmissions S
                        LEFT JOIN AssignmentGrades G ON S.SubmissionID = G.SubmissionID
                        WHERE S.AssignmentID = @AssignmentID AND S.Status = 'Submitted' AND G.GradeID IS NULL", con);
                    getUngraded.Parameters.AddWithValue("@AssignmentID", assignmentId);

                    SqlDataAdapter da = new SqlDataAdapter(getUngraded);
                    DataTable dt = new DataTable();
                    da.Fill(dt);

                    int gradedCount = 0;
                    foreach (DataRow row in dt.Rows)
                    {
                        int submissionId = Convert.ToInt32(row["SubmissionID"]);

                        SqlCommand getNewGradeIdCmd = new SqlCommand("SELECT ISNULL(MAX(GradeID), 0) + 1 FROM AssignmentGrades", con);
                        int newGradeId = (int)getNewGradeIdCmd.ExecuteScalar();

                        SqlCommand insertGradeCmd = new SqlCommand(@"
                            INSERT INTO AssignmentGrades (GradeID, SubmissionID, GradedBy, PointsEarned, Feedback, GradedDate)
                            VALUES (@GradeID, @SubmissionID, @GradedBy, @PointsEarned, @Feedback, @GradedDate)", con);
                        insertGradeCmd.Parameters.AddWithValue("@GradeID", newGradeId);
                        insertGradeCmd.Parameters.AddWithValue("@SubmissionID", submissionId);
                        insertGradeCmd.Parameters.AddWithValue("@GradedBy", Session["email"].ToString());
                        insertGradeCmd.Parameters.AddWithValue("@PointsEarned", maxPoints); // Full points
                        insertGradeCmd.Parameters.AddWithValue("@Feedback", "Bulk graded as complete");
                        insertGradeCmd.Parameters.AddWithValue("@GradedDate", DateTime.Now);
                        insertGradeCmd.ExecuteNonQuery();

                        gradedCount++;
                    }

                    ShowMessage($"Bulk graded {gradedCount} submissions with full points.", "green");
                    LoadSubmissions();
                }
            }
            catch (Exception ex)
            {
                ShowMessage("Error applying bulk grade: " + ex.Message, "red");
            }
        }

        private void SendBulkReminder()
        {
            // This is a placeholder for email reminder functionality
            ShowMessage("Reminder feature coming soon!", "blue");
        }

        // Helper methods for displaying submission content
        protected string GetSubmissionContent(object dataItem)
        {
            DataRowView row = (DataRowView)dataItem;

            string submissionText = row["SubmissionText"]?.ToString() ?? "";
            string attachmentPath = row["AttachmentPath"]?.ToString() ?? "";
            DateTime submissionDate = Convert.ToDateTime(row["SubmissionDate"]);
            bool isLate = Convert.ToBoolean(row["IsLate"]);

            string content = "<div class='submission-details'>";
            content += "<div class='detail-item'>";
            content += "<div class='detail-label'>Submitted</div>";
            content += $"<div class='detail-value'>{submissionDate:MMM dd, yyyy hh:mm tt}</div>";
            content += "</div>";
            content += "<div class='detail-item'>";
            content += "<div class='detail-label'>Status</div>";
            content += $"<div class='detail-value' style='color: {(isLate ? "#e74c3c" : "#27ae60")}'>{(isLate ? "Late" : "On Time")}</div>";
            content += "</div>";
            content += "</div>";

            if (!string.IsNullOrEmpty(submissionText))
            {
                content += "<div class='submission-text'>";
                content += "<strong>Submission Text:</strong><br>";
                content += submissionText;
                content += "</div>";
            }

            if (!string.IsNullOrEmpty(attachmentPath))
            {
                content += "<div class='attachment-section'>";
                content += "<strong>Attachments:</strong>";
                content += "<div class='attachment-item'>";
                content += "<i class='fas fa-file attachment-icon'></i>";
                content += $"<span>{System.IO.Path.GetFileName(attachmentPath)}</span>";
                content += $"<a href='{attachmentPath}' target='_blank' class='inline-btn' style='margin-left: auto;'>Download</a>";
                content += "</div>";
                content += "</div>";
            }

            return content;
        }

        protected string GetNoSubmissionContent()
        {
            return "<div class='no-submission'>" +
                   "<i class='fas fa-exclamation-triangle' style='font-size: 2rem; margin-bottom: 1rem; color: #f39c12;'></i>" +
                   "<p>Student has not submitted this assignment yet.</p>" +
                   "</div>";
        }

        protected string GetCurrentGradeDisplay(object pointsEarnedObj, object maxPointsObj, object feedbackObj)
        {
            if (pointsEarnedObj == null || pointsEarnedObj == DBNull.Value)
                return "";

            double pointsEarned = Convert.ToDouble(pointsEarnedObj);
            double maxPoints = Convert.ToDouble(maxPointsObj);
            string feedback = feedbackObj?.ToString() ?? "";

            double percentage = (pointsEarned / maxPoints) * 100;
            string letterGrade = GetLetterGrade(percentage);

            string content = "<div class='current-grade'>";
            content += $"<div class='grade-percentage'>{percentage:F1}% ({letterGrade})</div>";
            content += $"<div class='grade-letter'>{pointsEarned}/{maxPoints} points</div>";
            if (!string.IsNullOrEmpty(feedback))
            {
                content += $"<div style='margin-top: 0.5rem; font-size: 1.1rem;'>Previous Feedback: {feedback}</div>";
            }
            content += "</div>";

            return content;
        }

        private string GetLetterGrade(double percentage)
        {
            if (percentage >= 90) return "A";
            if (percentage >= 80) return "B";
            if (percentage >= 70) return "C";
            if (percentage >= 60) return "D";
            return "F";
        }

        private void ShowMessage(string message, string color)
        {
            lblMessage.Text = message;

            switch (color.ToLower())
            {
                case "green":
                    lblMessage.ForeColor = System.Drawing.Color.Green;
                    break;
                case "red":
                    lblMessage.ForeColor = System.Drawing.Color.Red;
                    break;
                case "blue":
                    lblMessage.ForeColor = System.Drawing.Color.Blue;
                    break;
                default:
                    lblMessage.ForeColor = System.Drawing.Color.Black;
                    break;
            }

            lblMessage.Visible = true;

            // Hide message after 5 seconds
            ClientScript.RegisterStartupScript(this.GetType(), "hideMessage",
                "setTimeout(function(){ document.getElementById('" + lblMessage.ClientID + "').style.display = 'none'; }, 5000);", true);
        }
    }
}