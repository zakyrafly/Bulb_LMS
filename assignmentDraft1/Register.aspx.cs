using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Web.Caching;
using System.Web.UI;
using System.Xml.Linq;

namespace assignmentDraft1
{
    public partial class Register : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                string cs = ConfigurationManager.ConnectionStrings["dbConnection"].ConnectionString;
                using (SqlConnection con = new SqlConnection(cs))
                {
                    string query = "SELECT CourseID, CourseName FROM Courses";
                    SqlCommand cmd = new SqlCommand(query, con);
                    con.Open();
                    SqlDataReader rdr = cmd.ExecuteReader();
                    ddlCourse.DataSource = rdr;
                    ddlCourse.DataTextField = "CourseName";
                    ddlCourse.DataValueField = "CourseID";
                    ddlCourse.DataBind();
                }
            }
        }

        protected void btnRegister_Click(object sender, EventArgs e)
        {
            string name = txtName.Text.Trim();
            string username = txtUsername.Text.Trim();
            string password = txtPassword.Text.Trim();
            string role = ddlRole.SelectedValue;
            string contact = txtContact.Text.Trim();
            string selectedCourseID = ddlCourse.SelectedValue;

            // Course selection required for both students and lecturers
            if (string.IsNullOrEmpty(selectedCourseID))
            {
                lblMessage.Text = role == "Student" ? "Please select a course." : "Please select a course you want to teach.";
                return;
            }

            string cs = ConfigurationManager.ConnectionStrings["dbConnection"].ConnectionString;

            using (SqlConnection con = new SqlConnection(cs))
            {
                con.Open();

                // Check if username already exists
                string checkQuery = "SELECT COUNT(*) FROM Users WHERE username = @username";
                SqlCommand checkCmd = new SqlCommand(checkQuery, con);
                checkCmd.Parameters.AddWithValue("@username", username);

                int existingUsers = (int)checkCmd.ExecuteScalar();
                if (existingUsers > 0)
                {
                    lblMessage.Text = "Username already exists. Please choose another.";
                    return;
                }

                // Get max UserID and add 1
                string idQuery = "SELECT ISNULL(MAX(UserID), 0) + 1 FROM Users";
                SqlCommand idCmd = new SqlCommand(idQuery, con);
                int newUserId = (int)idCmd.ExecuteScalar();

                // Insert the new user
                string insertQuery = "INSERT INTO Users (UserID, Name, username, password, Role, ContactInfo) VALUES (@id, @name, @username, @password, @role, @contact)";
                SqlCommand insertCmd = new SqlCommand(insertQuery, con);
                insertCmd.Parameters.AddWithValue("@id", newUserId);
                insertCmd.Parameters.AddWithValue("@name", name);
                insertCmd.Parameters.AddWithValue("@username", username);
                insertCmd.Parameters.AddWithValue("@password", password); // Optional: hash it
                insertCmd.Parameters.AddWithValue("@role", role);
                insertCmd.Parameters.AddWithValue("@contact", string.IsNullOrWhiteSpace(contact) ? (object)DBNull.Value : contact);

                insertCmd.ExecuteNonQuery();

                // If registering as lecturer, also add to Lecturers table
                if (role == "Lecturer")
                {
                    // Insert into Lecturers table (LecturerID is auto-generated)
                    string insertLecturerQuery = "INSERT INTO Lecturers (FullName, Email, Department) VALUES (@fullName, @email, @department)";
                    SqlCommand insertLecCmd = new SqlCommand(insertLecturerQuery, con);
                    insertLecCmd.Parameters.AddWithValue("@fullName", name);
                    insertLecCmd.Parameters.AddWithValue("@email", username); // Username is the email
                    insertLecCmd.Parameters.AddWithValue("@department", string.IsNullOrWhiteSpace(contact) ? "General" : contact); // Use contact as department or default

                    insertLecCmd.ExecuteNonQuery();

                    // Get the newly created LecturerID using the email we just inserted
                    SqlCommand getLecturerIdCmd = new SqlCommand("SELECT LecturerID FROM Lecturers WHERE Email = @email", con);
                    getLecturerIdCmd.Parameters.AddWithValue("@email", username);

                    object lecturerIdObj = getLecturerIdCmd.ExecuteScalar();

                    if (lecturerIdObj != null && lecturerIdObj != DBNull.Value)
                    {
                        int newLecturerId = Convert.ToInt32(lecturerIdObj);

                        // Create basic modules for the selected course
                        string[] moduleNames = { "Introduction Module", "Core Concepts", "Advanced Topics" };
                        string[] moduleDescriptions = {
                            "Basic introduction and overview",
                            "Core concepts and fundamentals",
                            "Advanced topics and applications"
                        };

                        for (int i = 0; i < moduleNames.Length; i++)
                        {
                            SqlCommand insertModuleCmd = new SqlCommand(@"
                                INSERT INTO Modules (CourseID, Title, Description, ModuleOrder, LecturerID) 
                                VALUES (@courseId, @title, @description, @moduleOrder, @lecturerId)", con);

                            insertModuleCmd.Parameters.AddWithValue("@courseId", selectedCourseID);
                            insertModuleCmd.Parameters.AddWithValue("@title", moduleNames[i]);
                            insertModuleCmd.Parameters.AddWithValue("@description", moduleDescriptions[i]);
                            insertModuleCmd.Parameters.AddWithValue("@moduleOrder", i + 1);
                            insertModuleCmd.Parameters.AddWithValue("@lecturerId", newLecturerId);

                            insertModuleCmd.ExecuteNonQuery();
                        }
                    }
                    else
                    {
                        // If we can't get the LecturerID, that's okay - lecturer can create modules manually later
                        lblMessage.Text += " Note: Please create modules manually from the assignments page.";
                    }
                }

                // Insert into UserCourses (only for students)
                if (role == "Student")
                {
                    string getUCIDQuery = "SELECT ISNULL(MAX(UserCourseID), 0) + 1 FROM UserCourses";
                    SqlCommand getUCIDCmd = new SqlCommand(getUCIDQuery, con);
                    int newUserCourseID = (int)getUCIDCmd.ExecuteScalar();

                    string insertUserCourseQuery = "INSERT INTO UserCourses (UserCourseID, UserID, CourseID) VALUES (@userCourseId, @userId, @courseId)";
                    SqlCommand insertUCmd = new SqlCommand(insertUserCourseQuery, con);
                    insertUCmd.Parameters.AddWithValue("@userCourseId", newUserCourseID);
                    insertUCmd.Parameters.AddWithValue("@userId", newUserId);
                    insertUCmd.Parameters.AddWithValue("@courseId", selectedCourseID);

                    insertUCmd.ExecuteNonQuery();
                }

                lblMessage.ForeColor = System.Drawing.Color.Green;
                lblMessage.Text = "Registration successful! You can now log in.";
            }
            Response.Redirect("loginWebform.aspx");
        }

        protected void LinkButton1_Click(object sender, EventArgs e)
        {
            Response.Redirect("loginWebform.aspx");
        }
    }
}