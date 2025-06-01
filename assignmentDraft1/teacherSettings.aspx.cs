using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace assignmentDraft1
{
    public partial class teacherSettings : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // Check if user is logged in and is a teacher
            if (Session["email"] == null)
            {
                Response.Redirect("loginWebform.aspx");
                return;
            }

            // Load teacher info on every page load
            LoadTeacherInfo();

            if (!IsPostBack)
            {
                LoadTeacherSettings();
            }
        }

        private void LoadTeacherInfo()
        {
            string email = Session["email"].ToString();
            string cs = ConfigurationManager.ConnectionStrings["dbConnection"].ConnectionString;

            using (SqlConnection con = new SqlConnection(cs))
            {
                con.Open();

                // Check if user is a teacher
                SqlCommand userCmd = new SqlCommand("SELECT UserID, Name, Role FROM Users WHERE username = @Email", con);
                userCmd.Parameters.AddWithValue("@Email", email);

                SqlDataReader userReader = userCmd.ExecuteReader();
                if (userReader.Read())
                {
                    string role = userReader["Role"].ToString();
                    if (role != "Lecturer" && role != "Teacher")
                    {
                        userReader.Close();
                        Response.Redirect("loginWebform.aspx"); // Redirect non-teachers
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
                userReader.Close();
            }
        }

        private void LoadTeacherSettings()
        {
            string email = Session["email"].ToString();
            string cs = ConfigurationManager.ConnectionStrings["dbConnection"].ConnectionString;

            try
            {
                using (SqlConnection con = new SqlConnection(cs))
                {
                    con.Open();

                    // Get teacher profile information
                    SqlCommand profileCmd = new SqlCommand("SELECT ContactInfo, ProfileBio FROM Users WHERE username = @Email", con);
                    profileCmd.Parameters.AddWithValue("@Email", email);

                    SqlDataReader profileReader = profileCmd.ExecuteReader();
                    if (profileReader.Read())
                    {
                        txtPhone.Text = profileReader["ContactInfo"]?.ToString() ?? "";
                        txtProfileBio.Text = profileReader["ProfileBio"]?.ToString() ?? "";
                    }
                    profileReader.Close();

                    // Load teacher-specific settings from TeacherSettings table
                    SqlCommand settingsCmd = new SqlCommand("SELECT SettingName, SettingValue FROM TeacherSettings WHERE Email = @Email", con);
                    settingsCmd.Parameters.AddWithValue("@Email", email);

                    SqlDataReader settingsReader = settingsCmd.ExecuteReader();
                    while (settingsReader.Read())
                    {
                        string settingName = settingsReader["SettingName"].ToString();
                        string settingValue = settingsReader["SettingValue"].ToString();

                        switch (settingName)
                        {
                            case "EmailNotifications":
                                chkEmailNotifications.Checked = settingValue.ToLower() == "true";
                                break;
                            case "SmsNotifications":
                                chkSmsNotifications.Checked = settingValue.ToLower() == "true";
                                break;
                            case "SubmissionNotifications":
                                chkSubmissionNotifications.Checked = settingValue.ToLower() == "true";
                                break;
                            case "DefaultDueTime":
                                if (ddlDefaultDueTime.Items.FindByValue(settingValue) != null)
                                    ddlDefaultDueTime.SelectedValue = settingValue;
                                break;
                            case "LatePolicy":
                                if (ddlLatePolicy.Items.FindByValue(settingValue) != null)
                                    ddlLatePolicy.SelectedValue = settingValue;
                                break;
                            case "LatePenalty":
                                txtLatePenalty.Text = settingValue;
                                break;
                            case "DisplayFullName":
                                chkDisplayFullName.Checked = settingValue.ToLower() == "true";
                                break;
                            case "DisplayContact":
                                chkDisplayContact.Checked = settingValue.ToLower() == "true";
                                break;
                        }
                    }
                    settingsReader.Close();
                }
            }
            catch (Exception ex)
            {
                ShowMessage("Error loading settings: " + ex.Message, "red");
            }
        }

        // Helper method to update a setting in the database
        private void UpdateTeacherSetting(string settingName, string settingValue)
        {
            string email = Session["email"].ToString();
            string cs = ConfigurationManager.ConnectionStrings["dbConnection"].ConnectionString;

            using (SqlConnection con = new SqlConnection(cs))
            {
                con.Open();

                // Check if setting already exists
                SqlCommand checkCmd = new SqlCommand("SELECT COUNT(*) FROM TeacherSettings WHERE Email = @Email AND SettingName = @SettingName", con);
                checkCmd.Parameters.AddWithValue("@Email", email);
                checkCmd.Parameters.AddWithValue("@SettingName", settingName);

                int settingExists = (int)checkCmd.ExecuteScalar();

                if (settingExists > 0)
                {
                    // Update existing setting
                    SqlCommand updateCmd = new SqlCommand(
                        "UPDATE TeacherSettings SET SettingValue = @SettingValue, ModifiedDate = GETDATE() WHERE Email = @Email AND SettingName = @SettingName",
                        con);
                    updateCmd.Parameters.AddWithValue("@Email", email);
                    updateCmd.Parameters.AddWithValue("@SettingName", settingName);
                    updateCmd.Parameters.AddWithValue("@SettingValue", settingValue);

                    updateCmd.ExecuteNonQuery();
                }
                else
                {
                    // Insert new setting
                    SqlCommand insertCmd = new SqlCommand(
                        "INSERT INTO TeacherSettings (Email, SettingName, SettingValue, CreatedDate, ModifiedDate) VALUES (@Email, @SettingName, @SettingValue, GETDATE(), GETDATE())",
                        con);
                    insertCmd.Parameters.AddWithValue("@Email", email);
                    insertCmd.Parameters.AddWithValue("@SettingName", settingName);
                    insertCmd.Parameters.AddWithValue("@SettingValue", settingValue);

                    insertCmd.ExecuteNonQuery();
                }
            }
        }

        protected void btnSaveAccount_Click(object sender, EventArgs e)
        {
            try
            {
                string email = Session["email"].ToString();
                string cs = ConfigurationManager.ConnectionStrings["dbConnection"].ConnectionString;

                // Change password if provided
                if (!string.IsNullOrEmpty(txtCurrentPassword.Text) && !string.IsNullOrEmpty(txtNewPassword.Text) && !string.IsNullOrEmpty(txtConfirmPassword.Text))
                {
                    if (txtNewPassword.Text != txtConfirmPassword.Text)
                    {
                        ShowMessage("New password and confirmation do not match.", "red");
                        return;
                    }

                    using (SqlConnection con = new SqlConnection(cs))
                    {
                        con.Open();

                        // Verify current password
                        SqlCommand verifyCmd = new SqlCommand("SELECT Password FROM Users WHERE username = @Email", con);
                        verifyCmd.Parameters.AddWithValue("@Email", email);

                        string storedPassword = (string)verifyCmd.ExecuteScalar();
                        if (storedPassword != txtCurrentPassword.Text) // In a real app, use proper password hashing
                        {
                            ShowMessage("Current password is incorrect.", "red");
                            return;
                        }

                        // Update password
                        SqlCommand updatePwdCmd = new SqlCommand("UPDATE Users SET Password = @NewPassword WHERE username = @Email", con);
                        updatePwdCmd.Parameters.AddWithValue("@Email", email);
                        updatePwdCmd.Parameters.AddWithValue("@NewPassword", txtNewPassword.Text); // In a real app, use proper password hashing

                        updatePwdCmd.ExecuteNonQuery();
                    }

                    // Clear password fields
                    txtCurrentPassword.Text = "";
                    txtNewPassword.Text = "";
                    txtConfirmPassword.Text = "";
                }

                // Update profile information if changed
                using (SqlConnection con = new SqlConnection(cs))
                {
                    con.Open();

                    SqlCommand updateProfileCmd = new SqlCommand("UPDATE Users SET ContactInfo = @Phone WHERE username = @Email", con);
                    updateProfileCmd.Parameters.AddWithValue("@Email", email);
                    updateProfileCmd.Parameters.AddWithValue("@Phone", txtPhone.Text.Trim());

                    updateProfileCmd.ExecuteNonQuery();
                }

                ShowMessage("Account settings updated successfully!", "green");
            }
            catch (Exception ex)
            {
                ShowMessage("Error updating account settings: " + ex.Message, "red");
            }
        }

        protected void btnSaveNotifications_Click(object sender, EventArgs e)
        {
            try
            {
                // Save notification settings
                UpdateTeacherSetting("EmailNotifications", chkEmailNotifications.Checked.ToString().ToLower());
                UpdateTeacherSetting("SmsNotifications", chkSmsNotifications.Checked.ToString().ToLower());
                UpdateTeacherSetting("SubmissionNotifications", chkSubmissionNotifications.Checked.ToString().ToLower());

                ShowMessage("Notification preferences saved successfully!", "green");
            }
            catch (Exception ex)
            {
                ShowMessage("Error saving notification preferences: " + ex.Message, "red");
            }
        }

        protected void btnSaveTeaching_Click(object sender, EventArgs e)
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

                // Save teaching preferences
                UpdateTeacherSetting("DefaultDueTime", ddlDefaultDueTime.SelectedValue);
                UpdateTeacherSetting("LatePolicy", ddlLatePolicy.SelectedValue);
                UpdateTeacherSetting("LatePenalty", txtLatePenalty.Text.Trim());

                ShowMessage("Teaching preferences saved successfully!", "green");
            }
            catch (Exception ex)
            {
                ShowMessage("Error saving teaching preferences: " + ex.Message, "red");
            }
        }

        protected void btnSaveProfile_Click(object sender, EventArgs e)
        {
            try
            {
                string email = Session["email"].ToString();
                string cs = ConfigurationManager.ConnectionStrings["dbConnection"].ConnectionString;

                // Update profile display settings
                UpdateTeacherSetting("DisplayFullName", chkDisplayFullName.Checked.ToString().ToLower());
                UpdateTeacherSetting("DisplayContact", chkDisplayContact.Checked.ToString().ToLower());

                // Update profile bio in Users table
                using (SqlConnection con = new SqlConnection(cs))
                {
                    con.Open();

                    SqlCommand updateBioCmd = new SqlCommand("UPDATE Users SET ProfileBio = @ProfileBio WHERE username = @Email", con);
                    updateBioCmd.Parameters.AddWithValue("@Email", email);
                    updateBioCmd.Parameters.AddWithValue("@ProfileBio", txtProfileBio.Text.Trim());

                    updateBioCmd.ExecuteNonQuery();
                }

                ShowMessage("Profile display settings saved successfully!", "green");
            }
            catch (Exception ex)
            {
                ShowMessage("Error saving profile display settings: " + ex.Message, "red");
            }
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