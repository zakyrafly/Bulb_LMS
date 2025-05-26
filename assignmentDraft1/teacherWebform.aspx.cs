using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace assignmentDraft1
{
    public partial class teacherWebform : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // Load teacher information
            if (Session["email"] != null)
            {
                // Set the teacher's name from session or database
                lblTeacherName.Text = "Teacher Name"; // Replace with actual name retrieval
            }
            else
            {
                // Redirect to login if not authenticated
                //Response.Redirect("loginWebform.aspx");
            }
        }

        protected void btnSearch_Click(object sender, EventArgs e)
        {
            // Implement search functionality
            string searchQuery = txtSearch.Text.Trim();
            if (!string.IsNullOrEmpty(searchQuery))
            {
                // Redirect to search results page
                Response.Redirect("searchResults.aspx?query=" + Server.UrlEncode(searchQuery));
            }
        }
    }
}