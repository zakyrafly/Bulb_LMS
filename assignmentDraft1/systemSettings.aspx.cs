using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Text;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace assignmentDraft1
{
    public partial class systemSettings : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // Check if user is logged in and is admin
            if (Session["email"] == null)
            {
                Response.Redirect("loginWebform.aspx");
                return;
            }

            // Load admin info on every page load
            LoadAdminInfo();

            if (!IsPostBack)
            {
                LoadSystemSettings();
                LoadSystemStatistics();
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

        private void LoadSystemSettings()
        {
            string cs = ConfigurationManager.ConnectionStrings["dbConnection"].ConnectionString;
            using (SqlConnection con = new SqlConnection(cs))
            {
                con.Open();

                // Load settings from database
                SqlCommand settingsCmd = new SqlCommand("SELECT SettingName, SettingValue FROM SystemSettings", con);
                SqlDataReader settingsReader = settingsCmd.ExecuteReader();

                while (settingsReader.Read())
                {
                    string settingName = settingsReader["SettingName"].ToString();
                    string settingValue = settingsReader["SettingValue"].ToString();

                    switch (settingName)
                    {
                        case "SystemName":
                            txtSystemName.Text = settingValue;
                            break;
                        case "MaxAssignmentPoints":
                            txtMaxPoints.Text = settingValue;
                            break;
                        case "AutoSaveFrequency":
                            if (ddlAutoSave.Items.FindByValue(settingValue) != null)
                                ddlAutoSave.SelectedValue = settingValue;
                            break;
                        case "AllowSelfRegistration":
                            chkSelfRegistration.Checked = settingValue.ToLower() == "true";
                            break;
                        case "DefaultUserRole":
                            if (ddlDefaultRole.Items.FindByValue(settingValue) != null)
                                ddlDefaultRole.SelectedValue = settingValue;
                            break;
                        case "PasswordMinLength":
                            if (ddlPasswordLength.Items.FindByValue(settingValue) != null)
                                ddlPasswordLength.SelectedValue = settingValue;
                            break;
                        case "AllowLateSubmissions":
                            chkLateSubmissions.Checked = settingValue.ToLower() == "true";
                            break;
                        case "LatePenaltyPercent":
                            txtLatePenalty.Text = settingValue;
                            break;
                        case "AutoGradeSubmissions":
                            chkAutoGrade.Checked = settingValue.ToLower() == "true";
                            break;
                        case "EmailNotifications":
                            chkEmailNotifications.Checked = settingValue.ToLower() == "true";
                            break;
                        case "DueReminderDays":
                            if (ddlDueReminders.Items.FindByValue(settingValue) != null)
                                ddlDueReminders.SelectedValue = settingValue;
                            break;
                        case "GradeNotifications":
                            chkGradeNotifications.Checked = settingValue.ToLower() == "true";
                            break;
                    }
                }
                settingsReader.Close();
            }
        }

        private void LoadSystemStatistics()
        {
            string cs = ConfigurationManager.ConnectionStrings["dbConnection"].ConnectionString;
            using (SqlConnection con = new SqlConnection(cs))
            {
                con.Open();

                // Get total users
                SqlCommand usersCmd = new SqlCommand("SELECT COUNT(*) FROM Users", con);
                int totalUsers = (int)usersCmd.ExecuteScalar();
                lblSystemUsers.Text = totalUsers.ToString();

                // Get total courses
                SqlCommand coursesCmd = new SqlCommand("SELECT COUNT(*) FROM Courses", con);
                int totalCourses = (int)coursesCmd.ExecuteScalar();
                lblSystemCourses.Text = totalCourses.ToString();

                // Get total assignments
                SqlCommand assignmentsCmd = new SqlCommand("SELECT COUNT(*) FROM Assignments", con);
                int totalAssignments = (int)assignmentsCmd.ExecuteScalar();
                lblSystemAssignments.Text = totalAssignments.ToString();
            }
        }

        // Helper method to update a setting in the database
        private void UpdateSetting(string settingName, string settingValue)
        {
            string cs = ConfigurationManager.ConnectionStrings["dbConnection"].ConnectionString;
            using (SqlConnection con = new SqlConnection(cs))
            {
                con.Open();

                SqlCommand updateCmd = new SqlCommand(@"
                    UPDATE SystemSettings 
                    SET SettingValue = @SettingValue, ModifiedDate = GETDATE() 
                    WHERE SettingName = @SettingName", con);
                updateCmd.Parameters.AddWithValue("@SettingName", settingName);
                updateCmd.Parameters.AddWithValue("@SettingValue", settingValue);

                updateCmd.ExecuteNonQuery();
            }
        }

        // Helper method to get a setting value from database
        public static string GetSetting(string settingName, string defaultValue = "")
        {
            try
            {
                string cs = ConfigurationManager.ConnectionStrings["dbConnection"].ConnectionString;
                using (SqlConnection con = new SqlConnection(cs))
                {
                    con.Open();

                    SqlCommand cmd = new SqlCommand("SELECT SettingValue FROM SystemSettings WHERE SettingName = @SettingName", con);
                    cmd.Parameters.AddWithValue("@SettingName", settingName);

                    object result = cmd.ExecuteScalar();
                    return result?.ToString() ?? defaultValue;
                }
            }
            catch
            {
                return defaultValue;
            }
        }

        protected void btnSaveGeneral_Click(object sender, EventArgs e)
        {
            try
            {
                // Validate max points
                if (!string.IsNullOrEmpty(txtMaxPoints.Text))
                {
                    int maxPoints = Convert.ToInt32(txtMaxPoints.Text);
                    if (maxPoints < 1 || maxPoints > 1000)
                    {
                        ShowMessage("Maximum points must be between 1 and 1000.", "red");
                        return;
                    }
                }

                // Save general settings to database
                UpdateSetting("SystemName", txtSystemName.Text.Trim());
                UpdateSetting("MaxAssignmentPoints", txtMaxPoints.Text.Trim());
                UpdateSetting("AutoSaveFrequency", ddlAutoSave.SelectedValue);

                ShowMessage("General settings saved successfully!", "green");
            }
            catch (Exception ex)
            {
                ShowMessage("Error saving general settings: " + ex.Message, "red");
            }
        }

        protected void btnSaveUser_Click(object sender, EventArgs e)
        {
            try
            {
                // Save user management settings to database
                UpdateSetting("AllowSelfRegistration", chkSelfRegistration.Checked.ToString().ToLower());
                UpdateSetting("DefaultUserRole", ddlDefaultRole.SelectedValue);
                UpdateSetting("PasswordMinLength", ddlPasswordLength.SelectedValue);

                ShowMessage("User management settings saved successfully!", "green");
            }
            catch (Exception ex)
            {
                ShowMessage("Error saving user settings: " + ex.Message, "red");
            }
        }

        protected void btnSaveAssignment_Click(object sender, EventArgs e)
        {
            try
            {
                // Validate late penalty
                if (!string.IsNullOrEmpty(txtLatePenalty.Text))
                {
                    int penalty = Convert.ToInt32(txtLatePenalty.Text);
                    if (penalty < 0 || penalty > 100)
                    {
                        ShowMessage("Late penalty must be between 0 and 100 percent.", "red");
                        return;
                    }
                }

                // Save assignment settings to database
                UpdateSetting("AllowLateSubmissions", chkLateSubmissions.Checked.ToString().ToLower());
                UpdateSetting("LatePenaltyPercent", txtLatePenalty.Text.Trim());
                UpdateSetting("AutoGradeSubmissions", chkAutoGrade.Checked.ToString().ToLower());

                ShowMessage("Assignment settings saved successfully!", "green");
            }
            catch (Exception ex)
            {
                ShowMessage("Error saving assignment settings: " + ex.Message, "red");
            }
        }

        protected void btnSaveNotifications_Click(object sender, EventArgs e)
        {
            try
            {
                // Save notification settings to database
                UpdateSetting("EmailNotifications", chkEmailNotifications.Checked.ToString().ToLower());
                UpdateSetting("DueReminderDays", ddlDueReminders.SelectedValue);
                UpdateSetting("GradeNotifications", chkGradeNotifications.Checked.ToString().ToLower());

                ShowMessage("Notification settings saved successfully!", "green");
            }
            catch (Exception ex)
            {
                ShowMessage("Error saving notification settings: " + ex.Message, "red");
            }
        }

        protected void btnRefreshStats_Click(object sender, EventArgs e)
        {
            try
            {
                LoadSystemStatistics();
                ShowMessage("Statistics refreshed successfully!", "green");
            }
            catch (Exception ex)
            {
                ShowMessage("Error refreshing statistics: " + ex.Message, "red");
            }
        }

        protected void btnClearInactive_Click(object sender, EventArgs e)
        {
            try
            {
                string cs = ConfigurationManager.ConnectionStrings["dbConnection"].ConnectionString;
                using (SqlConnection con = new SqlConnection(cs))
                {
                    con.Open();

                    // For demo purposes, we'll just count how many users would be affected
                    // In a real system, you'd have LastLogin tracking
                    SqlCommand countCmd = new SqlCommand("SELECT COUNT(*) FROM Users WHERE Role = 'Student'", con);
                    int inactiveCount = (int)countCmd.ExecuteScalar();

                    if (inactiveCount > 0)
                    {
                        ShowMessage($"Found {inactiveCount} potentially inactive users. Feature not implemented for safety.", "blue");
                    }
                    else
                    {
                        ShowMessage("No inactive users found.", "green");
                    }
                }
            }
            catch (Exception ex)
            {
                ShowMessage("Error checking inactive users: " + ex.Message, "red");
            }
        }

        protected void btnResetAssignments_Click(object sender, EventArgs e)
        {
            try
            {
                string cs = ConfigurationManager.ConnectionStrings["dbConnection"].ConnectionString;
                using (SqlConnection con = new SqlConnection(cs))
                {
                    con.Open();

                    // Delete assignment grades first (foreign key constraints)
                    SqlCommand deleteGradesCmd = new SqlCommand("DELETE FROM AssignmentGrades", con);
                    int gradesDeleted = deleteGradesCmd.ExecuteNonQuery();

                    // Delete assignment submissions
                    SqlCommand deleteSubmissionsCmd = new SqlCommand("DELETE FROM AssignmentSubmissions", con);
                    int submissionsDeleted = deleteSubmissionsCmd.ExecuteNonQuery();

                    // Delete assignments
                    SqlCommand deleteAssignmentsCmd = new SqlCommand("DELETE FROM Assignments", con);
                    int assignmentsDeleted = deleteAssignmentsCmd.ExecuteNonQuery();

                    ShowMessage($"Reset complete! Deleted {assignmentsDeleted} assignments, {submissionsDeleted} submissions, and {gradesDeleted} grades.", "green");

                    // Refresh statistics
                    LoadSystemStatistics();
                }
            }
            catch (Exception ex)
            {
                ShowMessage("Error resetting assignment data: " + ex.Message, "red");
            }
        }

        protected void btnExportData_Click(object sender, EventArgs e)
        {
            try
            {
                string cs = ConfigurationManager.ConnectionStrings["dbConnection"].ConnectionString;
                using (SqlConnection con = new SqlConnection(cs))
                {
                    con.Open();

                    StringBuilder exportData = new StringBuilder();
                    exportData.AppendLine("BULB LMS SYSTEM DATA EXPORT");
                    exportData.AppendLine("Generated: " + DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss"));
                    exportData.AppendLine("=" + new string('=', 50));
                    exportData.AppendLine();

                    // Export System Settings
                    exportData.AppendLine("SYSTEM SETTINGS:");
                    exportData.AppendLine("SettingName,SettingValue,SettingDescription");
                    SqlCommand settingsCmd = new SqlCommand("SELECT SettingName, SettingValue, SettingDescription FROM SystemSettings ORDER BY SettingName", con);
                    SqlDataReader settingsReader = settingsCmd.ExecuteReader();
                    while (settingsReader.Read())
                    {
                        exportData.AppendLine($"{EscapeCsvValue(settingsReader["SettingName"].ToString())},{EscapeCsvValue(settingsReader["SettingValue"].ToString())},{EscapeCsvValue(settingsReader["SettingDescription"]?.ToString() ?? "")}");
                    }
                    settingsReader.Close();
                    exportData.AppendLine();

                    // Export Users
                    exportData.AppendLine("USERS:");
                    exportData.AppendLine("ID,Name,Email,Role,ContactInfo");
                    SqlCommand usersCmd = new SqlCommand("SELECT UserID, Name, username, Role, ContactInfo FROM Users ORDER BY UserID", con);
                    SqlDataReader usersReader = usersCmd.ExecuteReader();
                    while (usersReader.Read())
                    {
                        exportData.AppendLine($"{usersReader["UserID"]},{EscapeCsvValue(usersReader["Name"].ToString())},{usersReader["username"]},{usersReader["Role"]},{EscapeCsvValue(usersReader["ContactInfo"]?.ToString() ?? "")}");
                    }
                    usersReader.Close();
                    exportData.AppendLine();

                    // Export Courses
                    exportData.AppendLine("COURSES:");
                    exportData.AppendLine("ID,Name,Description,Category");
                    SqlCommand coursesCmd = new SqlCommand("SELECT CourseID, CourseName, Description, Category FROM Courses ORDER BY CourseID", con);
                    SqlDataReader coursesReader = coursesCmd.ExecuteReader();
                    while (coursesReader.Read())
                    {
                        exportData.AppendLine($"{coursesReader["CourseID"]},{EscapeCsvValue(coursesReader["CourseName"].ToString())},{EscapeCsvValue(coursesReader["Description"]?.ToString() ?? "")},{EscapeCsvValue(coursesReader["Category"]?.ToString() ?? "")}");
                    }
                    coursesReader.Close();
                    exportData.AppendLine();

                    // Export Modules
                    exportData.AppendLine("MODULES:");
                    exportData.AppendLine("ID,CourseID,Title,Description,ModuleOrder,LecturerID");
                    SqlCommand modulesCmd = new SqlCommand("SELECT ModuleID, CourseID, Title, Description, ModuleOrder, LecturerID FROM Modules ORDER BY ModuleID", con);
                    SqlDataReader modulesReader = modulesCmd.ExecuteReader();
                    while (modulesReader.Read())
                    {
                        exportData.AppendLine($"{modulesReader["ModuleID"]},{modulesReader["CourseID"]},{EscapeCsvValue(modulesReader["Title"]?.ToString() ?? "")},{EscapeCsvValue(modulesReader["Description"]?.ToString() ?? "")},{modulesReader["ModuleOrder"]},{modulesReader["LecturerID"]}");
                    }
                    modulesReader.Close();
                    exportData.AppendLine();

                    // Export Assignments
                    exportData.AppendLine("ASSIGNMENTS:");
                    exportData.AppendLine("ID,Title,Description,DueDate,MaxPoints,ModuleID,IsActive");
                    SqlCommand assignmentsCmd = new SqlCommand("SELECT AssignmentID, Title, Description, DueDate, MaxPoints, ModuleID, IsActive FROM Assignments ORDER BY AssignmentID", con);
                    SqlDataReader assignmentsReader = assignmentsCmd.ExecuteReader();
                    while (assignmentsReader.Read())
                    {
                        exportData.AppendLine($"{assignmentsReader["AssignmentID"]},{EscapeCsvValue(assignmentsReader["Title"].ToString())},{EscapeCsvValue(assignmentsReader["Description"]?.ToString() ?? "")},{assignmentsReader["DueDate"]},{assignmentsReader["MaxPoints"]},{assignmentsReader["ModuleID"]},{assignmentsReader["IsActive"]}");
                    }
                    assignmentsReader.Close();
                    exportData.AppendLine();

                    // Export User Course Enrollments
                    exportData.AppendLine("USER ENROLLMENTS:");
                    exportData.AppendLine("UserCourseID,UserID,CourseID,EnrollmentDate");
                    SqlCommand enrollmentsCmd = new SqlCommand("SELECT UserCourseID, UserID, CourseID, EnrollmentDate FROM UserCourses ORDER BY UserCourseID", con);
                    SqlDataReader enrollmentsReader = enrollmentsCmd.ExecuteReader();
                    while (enrollmentsReader.Read())
                    {
                        exportData.AppendLine($"{enrollmentsReader["UserCourseID"]},{enrollmentsReader["UserID"]},{enrollmentsReader["CourseID"]},{enrollmentsReader["EnrollmentDate"]}");
                    }
                    enrollmentsReader.Close();
                    exportData.AppendLine();

                    // Export Assignment Submissions
                    exportData.AppendLine("ASSIGNMENT SUBMISSIONS:");
                    exportData.AppendLine("SubmissionID,AssignmentID,UserID,SubmissionText,SubmissionDate,Status,IsLate");
                    SqlCommand submissionsCmd = new SqlCommand("SELECT SubmissionID, AssignmentID, UserID, SubmissionText, SubmissionDate, Status, IsLate FROM AssignmentSubmissions ORDER BY SubmissionID", con);
                    SqlDataReader submissionsReader = submissionsCmd.ExecuteReader();
                    while (submissionsReader.Read())
                    {
                        exportData.AppendLine($"{submissionsReader["SubmissionID"]},{submissionsReader["AssignmentID"]},{submissionsReader["UserID"]},{EscapeCsvValue(submissionsReader["SubmissionText"]?.ToString() ?? "")},{submissionsReader["SubmissionDate"]},{submissionsReader["Status"]},{submissionsReader["IsLate"]}");
                    }
                    submissionsReader.Close();
                    exportData.AppendLine();

                    // Export Assignment Grades
                    exportData.AppendLine("ASSIGNMENT GRADES:");
                    exportData.AppendLine("GradeID,SubmissionID,GradedBy,PointsEarned,Feedback,GradedDate");
                    SqlCommand gradesCmd = new SqlCommand("SELECT GradeID, SubmissionID, GradedBy, PointsEarned, Feedback, GradedDate FROM AssignmentGrades ORDER BY GradeID", con);
                    SqlDataReader gradesReader = gradesCmd.ExecuteReader();
                    while (gradesReader.Read())
                    {
                        exportData.AppendLine($"{gradesReader["GradeID"]},{gradesReader["SubmissionID"]},{EscapeCsvValue(gradesReader["GradedBy"]?.ToString() ?? "")},{gradesReader["PointsEarned"]},{EscapeCsvValue(gradesReader["Feedback"]?.ToString() ?? "")},{gradesReader["GradedDate"]}");
                    }
                    gradesReader.Close();
                    exportData.AppendLine();

                    // Export Lecturers
                    exportData.AppendLine("LECTURERS:");
                    exportData.AppendLine("LecturerID,FullName,Email,Department");
                    SqlCommand lecturersCmd = new SqlCommand("SELECT LecturerID, FullName, Email, Department FROM Lecturers ORDER BY LecturerID", con);
                    SqlDataReader lecturersReader = lecturersCmd.ExecuteReader();
                    while (lecturersReader.Read())
                    {
                        exportData.AppendLine($"{lecturersReader["LecturerID"]},{EscapeCsvValue(lecturersReader["FullName"]?.ToString() ?? "")},{lecturersReader["Email"]},{EscapeCsvValue(lecturersReader["Department"]?.ToString() ?? "")}");
                    }
                    lecturersReader.Close();
                    exportData.AppendLine();

                    // Export Summary Statistics
                    exportData.AppendLine("SYSTEM STATISTICS:");
                    exportData.AppendLine($"Total Users: {lblSystemUsers.Text}");
                    exportData.AppendLine($"Total Courses: {lblSystemCourses.Text}");
                    exportData.AppendLine($"Total Assignments: {lblSystemAssignments.Text}");
                    exportData.AppendLine($"Export Date: {DateTime.Now:yyyy-MM-dd HH:mm:ss}");
                    exportData.AppendLine($"System Version: Bulb LMS v1.0.0");

                    // Set response headers for file download
                    Response.Clear();
                    Response.ContentType = "text/plain";
                    Response.AddHeader("Content-Disposition",
                        $"attachment; filename=Bulb_LMS_Complete_Export_{DateTime.Now:yyyyMMdd_HHmmss}.txt");

                    // Write export data to response
                    Response.Write(exportData.ToString());
                    Response.End();
                }
            }
            catch (Exception ex)
            {
                ShowMessage("Error exporting data: " + ex.Message, "red");
            }
        }

        // Helper method to escape CSV values
        private string EscapeCsvValue(string value)
        {
            if (string.IsNullOrEmpty(value))
                return "";

            if (value.Contains(",") || value.Contains("\"") || value.Contains("\n") || value.Contains("\r"))
            {
                return "\"" + value.Replace("\"", "\"\"") + "\"";
            }

            return value;
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