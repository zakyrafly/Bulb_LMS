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
    public partial class WebForm1 : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // Clear any existing sessions on login page load
            if (!IsPostBack)
            {
                Session.Clear();
            }
        }

        protected void btnLogin_Click(object sender, EventArgs e)
        {
            string email = txtEmail.Text.Trim();
            string password = txtPassword.Text.Trim();

            // Validate input
            if (string.IsNullOrEmpty(email) || string.IsNullOrEmpty(password))
            {
                lblMessage.Text = "Please enter both email and password.";
                return;
            }

            string cs = ConfigurationManager.ConnectionStrings["dbConnection"].ConnectionString;

            using (SqlConnection con = new SqlConnection(cs))
            {
                try
                {
                    // Modified query to retrieve user details including role
                    string query = "SELECT UserID, Name, Role FROM Users WHERE Username = @email AND Password = @pass";
                    SqlCommand cmd = new SqlCommand(query, con);
                    cmd.Parameters.AddWithValue("@email", email);
                    cmd.Parameters.AddWithValue("@pass", password);

                    con.Open();
                    SqlDataReader reader = cmd.ExecuteReader();

                    if (reader.Read())
                    {
                        // Successful login - get user details
                        string userId = reader["UserID"].ToString();
                        string userName = reader["Name"].ToString();
                        string userRole = reader["Role"].ToString();

                        // Store user information in session
                        Session["email"] = email;
                        Session["userId"] = userId;
                        Session["userName"] = userName;
                        Session["userRole"] = userRole;

                        reader.Close();

                        // Debug: Show what role was detected
                        System.Diagnostics.Debug.WriteLine($"Login successful - Role: {userRole}");

                        // Redirect based on role (case-insensitive comparison)
                        if (string.Equals(userRole, "Student", StringComparison.OrdinalIgnoreCase))
                        {
                            Response.Redirect("homeWebform.aspx");
                        }
                        else if (string.Equals(userRole, "Lecturer", StringComparison.OrdinalIgnoreCase))
                        {
                            // Verify lecturer exists in Lecturers table
                            SqlCommand lecCmd = new SqlCommand("SELECT COUNT(*) FROM Lecturers WHERE Email = @email", con);
                            lecCmd.Parameters.AddWithValue("@email", email);
                            int lecturerExists = (int)lecCmd.ExecuteScalar();

                            if (lecturerExists > 0)
                            {
                                Response.Redirect("teacherWebform.aspx");
                            }
                            else
                            {
                                lblMessage.Text = "Lecturer profile not found. Please contact administrator.";
                                lblMessage.ForeColor = System.Drawing.Color.Red;
                            }
                        }
                        else if (string.Equals(userRole, "Admin", StringComparison.OrdinalIgnoreCase))
                        {
                            Response.Redirect("adminDashboard.aspx");
                        }
                        else
                        {
                            // Handle unexpected role
                            lblMessage.Text = $"Unknown user role: {userRole}. Please contact administrator.";
                            lblMessage.ForeColor = System.Drawing.Color.Red;
                        }
                    }
                    else
                    {
                        lblMessage.Text = "Invalid email or password.";
                        lblMessage.ForeColor = System.Drawing.Color.Red;
                    }
                }
                catch (Exception ex)
                {
                    lblMessage.Text = "Login error: " + ex.Message;
                    lblMessage.ForeColor = System.Drawing.Color.Red;
                }
            }
        }

        protected void LinkButton1_Click(object sender, EventArgs e)
        {
            Response.Redirect("Register.aspx");
        }

        protected void LinkButton1_Click1(object sender, EventArgs e)
        {
            Response.Redirect("Register.aspx");
        }
    }
}