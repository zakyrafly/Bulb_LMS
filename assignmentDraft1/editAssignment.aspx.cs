using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace assignmentDraft1
{
    public partial class editAssignment : System.Web.UI.Page
    {
        private int assignmentId;

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
                    LoadAssignmentStatistics();
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
                        A.Title, A.Description, A.Instructions, A.DueDate, A.MaxPoints, A.IsActive,
                        C.CourseName, M.Title AS ModuleTitle
                    FROM Assignments A
                    JOIN Modules M ON A.ModuleID = M.ModuleID
                    JOIN Courses C ON M.CourseID = C.CourseID
                    WHERE A.AssignmentID = @AssignmentID", con);
                cmd.Parameters.AddWithValue("@AssignmentID", assignmentId);

                SqlDataReader reader = cmd.ExecuteReader();
                if (reader.Read())
                {
                    // Populate form fields
                    txtTitle.Text = reader["Title"].ToString();
                    txtDescription.Text = reader["Description"].ToString();
                    txtInstructions.Text = reader["Instructions"]?.ToString() ?? "";
                    txtMaxPoints.Text = reader["MaxPoints"].ToString();
                    ddlStatus.SelectedValue = reader["IsActive"].ToString();

                    // Set course and module info
                    lblCourseModule.Text = $"{reader["CourseName"]} - {reader["ModuleTitle"]}";

                    // Parse and set due date/time
                    DateTime dueDate = Convert.ToDateTime(reader["DueDate"]);
                    txtDueDate.Text = dueDate.ToString("yyyy-MM-dd");
                    txtDueTime.Text = dueDate.ToString("HH:mm");
                }
                else
                {
                    ShowMessage("Assignment not found.", "red");
                    Response.Redirect("manageAssignments.aspx");
                }
            }
        }

        private void LoadAssignmentStatistics()
        {
            string cs = ConfigurationManager.ConnectionStrings["dbConnection"].ConnectionString;
            using (SqlConnection con = new SqlConnection(cs))
            {
                con.Open();

                // Get total submissions
                SqlCommand submissionsCmd = new SqlCommand(@"
                    SELECT COUNT(*) FROM AssignmentSubmissions 
                    WHERE AssignmentID = @AssignmentID AND Status = 'Submitted'", con);
                submissionsCmd.Parameters.AddWithValue("@AssignmentID", assignmentId);
                int totalSubmissions = (int)submissionsCmd.ExecuteScalar();
                lblTotalSubmissions.Text = totalSubmissions.ToString();

                // Get graded submissions
                SqlCommand gradedCmd = new SqlCommand(@"
                    SELECT COUNT(*) FROM AssignmentSubmissions S
                    JOIN AssignmentGrades G ON S.SubmissionID = G.SubmissionID
                    WHERE S.AssignmentID = @AssignmentID AND S.Status = 'Submitted'", con);
                gradedCmd.Parameters.AddWithValue("@AssignmentID", assignmentId);
                int gradedSubmissions = (int)gradedCmd.ExecuteScalar();
                lblGradedSubmissions.Text = gradedSubmissions.ToString();

                // Calculate pending grades
                int pendingGrades = totalSubmissions - gradedSubmissions;
                lblPendingGrades.Text = pendingGrades.ToString();

                // Get enrolled students count
                SqlCommand enrolledCmd = new SqlCommand(@"
                    SELECT COUNT(DISTINCT UC.UserID) 
                    FROM UserCourses UC
                    JOIN Modules M ON UC.CourseID = M.CourseID
                    JOIN Assignments A ON M.ModuleID = A.ModuleID
                    JOIN Users U ON UC.UserID = U.UserID
                    WHERE A.AssignmentID = @AssignmentID AND U.Role = 'Student'", con);
                enrolledCmd.Parameters.AddWithValue("@AssignmentID", assignmentId);
                int enrolledStudents = (int)enrolledCmd.ExecuteScalar();
                lblEnrolledStudents.Text = enrolledStudents.ToString();

                // Show warning if there are submissions
                if (totalSubmissions > 0)
                {
                    pnlSubmissionWarning.Visible = true;
                }
            }
        }

        protected void btnSaveChanges_Click(object sender, EventArgs e)
        {
            if (!ValidateForm())
                return;

            try
            {
                string cs = ConfigurationManager.ConnectionStrings["dbConnection"].ConnectionString;
                using (SqlConnection con = new SqlConnection(cs))
                {
                    con.Open();

                    // Combine date and time
                    DateTime dueDateTime = DateTime.Parse($"{txtDueDate.Text} {txtDueTime.Text}");

                    SqlCommand updateCmd = new SqlCommand(@"
                        UPDATE Assignments 
                        SET Title = @Title, Description = @Description, Instructions = @Instructions, 
                            DueDate = @DueDate, MaxPoints = @MaxPoints, IsActive = @IsActive
                        WHERE AssignmentID = @AssignmentID", con);

                    updateCmd.Parameters.AddWithValue("@AssignmentID", assignmentId);
                    updateCmd.Parameters.AddWithValue("@Title", txtTitle.Text.Trim());
                    updateCmd.Parameters.AddWithValue("@Description", txtDescription.Text.Trim());
                    updateCmd.Parameters.AddWithValue("@Instructions", string.IsNullOrWhiteSpace(txtInstructions.Text) ? (object)DBNull.Value : txtInstructions.Text.Trim());
                    updateCmd.Parameters.AddWithValue("@DueDate", dueDateTime);
                    updateCmd.Parameters.AddWithValue("@MaxPoints", int.Parse(txtMaxPoints.Text));
                    updateCmd.Parameters.AddWithValue("@IsActive", Convert.ToBoolean(ddlStatus.SelectedValue));

                    int rowsAffected = updateCmd.ExecuteNonQuery();

                    if (rowsAffected > 0)
                    {
                        ShowMessage("Assignment updated successfully!", "green");

                        // Reload statistics in case status changed
                        LoadAssignmentStatistics();
                    }
                    else
                    {
                        ShowMessage("No changes were made to the assignment.", "blue");
                    }
                }
            }
            catch (Exception ex)
            {
                ShowMessage("Error updating assignment: " + ex.Message, "red");
            }
        }

        protected void btnDeleteAssignment_Click(object sender, EventArgs e)
        {
            try
            {
                string cs = ConfigurationManager.ConnectionStrings["dbConnection"].ConnectionString;
                using (SqlConnection con = new SqlConnection(cs))
                {
                    con.Open();

                    // Check if assignment has submissions
                    SqlCommand checkCmd = new SqlCommand("SELECT COUNT(*) FROM AssignmentSubmissions WHERE AssignmentID = @AssignmentID", con);
                    checkCmd.Parameters.AddWithValue("@AssignmentID", assignmentId);
                    int submissionCount = (int)checkCmd.ExecuteScalar();

                    if (submissionCount > 0)
                    {
                        // Soft delete - set IsActive to false
                        SqlCommand softDeleteCmd = new SqlCommand("UPDATE Assignments SET IsActive = 0 WHERE AssignmentID = @AssignmentID", con);
                        softDeleteCmd.Parameters.AddWithValue("@AssignmentID", assignmentId);
                        softDeleteCmd.ExecuteNonQuery();

                        ShowMessage("Assignment has been deactivated due to existing submissions.", "blue");

                        // Update the form to reflect the change
                        ddlStatus.SelectedValue = "False";
                        LoadAssignmentStatistics();
                    }
                    else
                    {
                        // Hard delete - remove completely
                        SqlCommand deleteCmd = new SqlCommand("DELETE FROM Assignments WHERE AssignmentID = @AssignmentID", con);
                        deleteCmd.Parameters.AddWithValue("@AssignmentID", assignmentId);
                        deleteCmd.ExecuteNonQuery();

                        ShowMessage("Assignment deleted successfully! Redirecting...", "green");

                        // Redirect after a short delay
                        ClientScript.RegisterStartupScript(this.GetType(), "redirect",
                            "setTimeout(function(){ window.location = 'manageAssignments.aspx'; }, 2000);", true);
                    }
                }
            }
            catch (Exception ex)
            {
                ShowMessage("Error deleting assignment: " + ex.Message, "red");
            }
        }

        private bool ValidateForm()
        {
            if (string.IsNullOrWhiteSpace(txtTitle.Text))
            {
                ShowMessage("Please enter assignment title.", "red");
                return false;
            }

            if (string.IsNullOrWhiteSpace(txtDescription.Text))
            {
                ShowMessage("Please enter assignment description.", "red");
                return false;
            }

            if (string.IsNullOrWhiteSpace(txtDueDate.Text) || string.IsNullOrWhiteSpace(txtDueTime.Text))
            {
                ShowMessage("Please select due date and time.", "red");
                return false;
            }

            DateTime dueDateTime;
            if (!DateTime.TryParse($"{txtDueDate.Text} {txtDueTime.Text}", out dueDateTime))
            {
                ShowMessage("Invalid due date/time format.", "red");
                return false;
            }

            int maxPoints;
            if (!int.TryParse(txtMaxPoints.Text, out maxPoints) || maxPoints <= 0)
            {
                ShowMessage("Please enter valid maximum points (greater than 0).", "red");
                return false;
            }

            if (maxPoints > 1000)
            {
                ShowMessage("Maximum points cannot exceed 1000.", "red");
                return false;
            }

            return true;
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