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

        }

        protected void btnLogin_Click(object sender, EventArgs e)
        {
            string email = txtEmail.Text;
            string password = txtPassword.Text;

            string cs = ConfigurationManager.ConnectionStrings["dbConnection"].ConnectionString;

            using (SqlConnection con = new SqlConnection(cs))
            {
                // Modified query to retrieve user details including role
                string query = "SELECT Name, Role FROM Users WHERE username=@email AND Password=@pass";
                SqlCommand cmd = new SqlCommand(query, con);
                cmd.Parameters.AddWithValue("@email", email);
                cmd.Parameters.AddWithValue("@pass", password);

                con.Open();
                SqlDataReader reader = cmd.ExecuteReader();

                if (reader.Read())
                {
                    // Successful login - get user details
                    string userName = reader["Name"].ToString();
                    string userRole = reader["Role"].ToString();

                    // Store user information in session
                    Session["email"] = email;
                    Session["userName"] = userName;
                    Session["userRole"] = userRole;

                    // Redirect based on role
                    if (userRole.Equals("Student", StringComparison.OrdinalIgnoreCase))
                    {
                        Response.Redirect("homeWebform.aspx");
                    }
                    else if (userRole.Equals("Lecturer", StringComparison.OrdinalIgnoreCase))
                    {
                        Response.Redirect("teacherWebform.aspx");
                    }
                    else
                    {
                        // Handle unexpected role or redirect to a default page
                        Response.Redirect("homeWebform.aspx");
                    }
                }
                else
                {
                    lblMessage.Text = "Invalid email or password.";
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