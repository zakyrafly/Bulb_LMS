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
				string query = "SELECT COUNT(*) FROM Users WHERE username=@email AND Password=@pass";
				SqlCommand cmd = new SqlCommand(query, con);
				cmd.Parameters.AddWithValue("@email", email);
				cmd.Parameters.AddWithValue("@pass", password);

				con.Open();
				int count = (int)cmd.ExecuteScalar();

				if (count == 1)
				{
					// successful login
					Session["email"] = email;
					Response.Redirect("homeWebform.aspx");
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