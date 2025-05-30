using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace assignmentDraft1
{
    public partial class EditModules : System.Web.UI.Page
    {
        private int lecturerId;
        private int courseId;

        protected void Page_Load(object sender, EventArgs e)
        {
            // Check if user is logged in
            if (Session["email"] == null)
            {
                Response.Redirect("loginWebform.aspx");
                return;
            }

            // Get course ID from query string
            if (Request.QueryString["courseId"] == null || !int.TryParse(Request.QueryString["courseId"], out courseId))
            {
                ShowMessage("Invalid course ID. Redirecting to dashboard...", "error");
                Response.Redirect("TeacherWebform.aspx");
                return;
            }

            // Load lecturer info and validate permissions
            if (!LoadLecturerInfo())
            {
                return;
            }

            // Validate that this lecturer has access to this course
            if (!ValidateCourseAccess())
            {
                ShowMessage("You don't have permission to edit modules for this course.", "error");
                Response.Redirect("TeacherWebform.aspx");
                return;
            }

            if (!IsPostBack)
            {
                LoadCourseInfo();
                LoadModules();
                LoadStatistics();
                hfCourseID.Value = courseId.ToString();
            }
        }

        private bool LoadLecturerInfo()
        {
            string email = Session["email"].ToString();
            string cs = ConfigurationManager.ConnectionStrings["dbConnection"].ConnectionString;

            using (SqlConnection con = new SqlConnection(cs))
            {
                try
                {
                    con.Open();

                    // First check if user is a lecturer
                    SqlCommand userCmd = new SqlCommand("SELECT UserID, Name, Role FROM Users WHERE Username = @Email", con);
                    userCmd.Parameters.AddWithValue("@Email", email);

                    SqlDataReader userReader = userCmd.ExecuteReader();
                    if (userReader.Read())
                    {
                        string role = userReader["Role"].ToString();
                        if (role != "Lecturer")
                        {
                            userReader.Close();
                            Response.Redirect("homeWebform.aspx");
                            return false;
                        }

                        lblName.Text = userReader["Name"].ToString();
                        lblRole.Text = role;
                        lblSidebarName.Text = userReader["Name"].ToString();
                        lblSidebarRole.Text = role;
                    }
                    else
                    {
                        userReader.Close();
                        ShowMessage("User not found.", "error");
                        return false;
                    }
                    userReader.Close();

                    // Get lecturer ID from Lecturers table
                    SqlCommand lecCmd = new SqlCommand("SELECT LecturerID FROM Lecturers WHERE Email = @Email", con);
                    lecCmd.Parameters.AddWithValue("@Email", email);

                    object lecIdObj = lecCmd.ExecuteScalar();
                    if (lecIdObj != null)
                    {
                        lecturerId = Convert.ToInt32(lecIdObj);
                        return true;
                    }
                    else
                    {
                        ShowMessage("Lecturer profile not found. Please contact administrator.", "error");
                        return false;
                    }
                }
                catch (Exception ex)
                {
                    ShowMessage("Error loading lecturer information: " + ex.Message, "error");
                    return false;
                }
            }
        }

        private bool ValidateCourseAccess()
        {
            string cs = ConfigurationManager.ConnectionStrings["dbConnection"].ConnectionString;
            using (SqlConnection con = new SqlConnection(cs))
            {
                try
                {
                    con.Open();

                    // Check if this lecturer has modules in this course
                    SqlCommand cmd = new SqlCommand(
                        "SELECT COUNT(*) FROM Modules WHERE CourseID = @CourseID AND LecturerID = @LecturerID", con);
                    cmd.Parameters.AddWithValue("@CourseID", courseId);
                    cmd.Parameters.AddWithValue("@LecturerID", lecturerId);

                    int moduleCount = (int)cmd.ExecuteScalar();
                    return moduleCount > 0; // Must have at least one module to access edit page
                }
                catch (Exception ex)
                {
                    ShowMessage("Error validating course access: " + ex.Message, "error");
                    return false;
                }
            }
        }

        private void LoadCourseInfo()
        {
            string cs = ConfigurationManager.ConnectionStrings["dbConnection"].ConnectionString;
            using (SqlConnection con = new SqlConnection(cs))
            {
                try
                {
                    con.Open();

                    SqlCommand cmd = new SqlCommand(@"
                        SELECT CourseName, CAST(Description AS NVARCHAR(MAX)) as Description, Category 
                        FROM Courses 
                        WHERE CourseID = @CourseID", con);
                    cmd.Parameters.AddWithValue("@CourseID", courseId);

                    SqlDataReader reader = cmd.ExecuteReader();
                    if (reader.Read())
                    {
                        lblCourseName.Text = reader["CourseName"]?.ToString() ?? "Unknown Course";
                        lblCourseDescription.Text = reader["Description"]?.ToString() ?? "No description available";

                        // Update page title
                        Page.Title = $"Edit Modules - {lblCourseName.Text} - Bulb";
                    }
                    else
                    {
                        ShowMessage("Course information not found.", "error");
                    }
                    reader.Close();
                }
                catch (Exception ex)
                {
                    ShowMessage("Error loading course information: " + ex.Message, "error");
                }
            }
        }

        private void LoadModules()
        {
            string cs = ConfigurationManager.ConnectionStrings["dbConnection"].ConnectionString;
            using (SqlConnection con = new SqlConnection(cs))
            {
                try
                {
                    con.Open();

                    SqlCommand cmd = new SqlCommand(@"
                        SELECT ModuleID, Title, Description, ModuleOrder
                        FROM Modules
                        WHERE CourseID = @CourseID AND LecturerID = @LecturerID", con);

                    cmd.Parameters.AddWithValue("@CourseID", courseId);
                    cmd.Parameters.AddWithValue("@LecturerID", lecturerId);

                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    DataTable dt = new DataTable();
                    da.Fill(dt);

                    if (dt.Rows.Count > 0)
                    {
                        // Sort by module order
                        DataView dv = dt.DefaultView;
                        dv.Sort = "ModuleOrder ASC";
                        DataTable sortedDt = dv.ToTable();

                        rptModules.DataSource = sortedDt;
                        rptModules.DataBind();

                        pnlNoModules.Visible = false;
                    }
                    else
                    {
                        rptModules.DataSource = null;
                        rptModules.DataBind();

                        pnlNoModules.Visible = true;
                    }
                }
                catch (Exception ex)
                {
                    ShowMessage("Error loading modules: " + ex.Message, "error");
                }
            }
        }

        private void LoadStatistics()
        {
            string cs = ConfigurationManager.ConnectionStrings["dbConnection"].ConnectionString;
            using (SqlConnection con = new SqlConnection(cs))
            {
                try
                {
                    con.Open();

                    // Get module count
                    SqlCommand moduleCmd = new SqlCommand(@"
                        SELECT COUNT(*) FROM Modules 
                        WHERE CourseID = @CourseID AND LecturerID = @LecturerID", con);
                    moduleCmd.Parameters.AddWithValue("@CourseID", courseId);
                    moduleCmd.Parameters.AddWithValue("@LecturerID", lecturerId);

                    int moduleCount = (int)moduleCmd.ExecuteScalar();
                    lblModuleCount.Text = moduleCount.ToString();

                    // Get last module order
                    SqlCommand orderCmd = new SqlCommand(@"
                        SELECT ISNULL(MAX(ModuleOrder), 0) FROM Modules 
                        WHERE CourseID = @CourseID AND LecturerID = @LecturerID", con);
                    orderCmd.Parameters.AddWithValue("@CourseID", courseId);
                    orderCmd.Parameters.AddWithValue("@LecturerID", lecturerId);

                    int lastOrder = (int)orderCmd.ExecuteScalar();
                    lblLastOrder.Text = lastOrder.ToString();

                    // Get assignment count
                    SqlCommand assignmentCmd = new SqlCommand(@"
                        SELECT COUNT(*) FROM Assignments a
                        JOIN Modules m ON a.ModuleID = m.ModuleID
                        WHERE m.CourseID = @CourseID AND m.LecturerID = @LecturerID", con);
                    assignmentCmd.Parameters.AddWithValue("@CourseID", courseId);
                    assignmentCmd.Parameters.AddWithValue("@LecturerID", lecturerId);

                    int assignmentCount = (int)assignmentCmd.ExecuteScalar();
                    lblAssignmentCount.Text = assignmentCount.ToString();
                }
                catch (Exception ex)
                {
                    ShowMessage("Error loading statistics: " + ex.Message, "error");
                }
            }
        }

        protected void BtnEditModule_Click(object sender, EventArgs e)
        {
            try
            {
                LinkButton btn = (LinkButton)sender;
                int moduleId = Convert.ToInt32(btn.CommandArgument);
                LoadModuleForEdit(moduleId);
            }
            catch (Exception ex)
            {
                ShowMessage("Error loading module for editing: " + ex.Message, "error");
            }
        }

        private void LoadModuleForEdit(int moduleId)
        {
            string cs = ConfigurationManager.ConnectionStrings["dbConnection"].ConnectionString;
            using (SqlConnection con = new SqlConnection(cs))
            {
                try
                {
                    con.Open();

                    SqlCommand cmd = new SqlCommand(@"
                        SELECT ModuleID, Title, Description, ModuleOrder 
                        FROM Modules 
                        WHERE ModuleID = @ModuleID AND LecturerID = @LecturerID AND CourseID = @CourseID", con);
                    cmd.Parameters.AddWithValue("@ModuleID", moduleId);
                    cmd.Parameters.AddWithValue("@LecturerID", lecturerId);
                    cmd.Parameters.AddWithValue("@CourseID", courseId);

                    SqlDataReader reader = cmd.ExecuteReader();
                    if (reader.Read())
                    {
                        hfModuleID.Value = reader["ModuleID"].ToString();
                        txtModuleTitle.Text = reader["Title"]?.ToString() ?? "";
                        txtModuleDescription.Text = reader["Description"]?.ToString() ?? "";
                        txtModuleOrder.Text = reader["ModuleOrder"]?.ToString() ?? "";

                        reader.Close();

                        // Open edit modal via JavaScript
                        ClientScript.RegisterStartupScript(this.GetType(), "openEditModal", "openEditModal();", true);
                    }
                    else
                    {
                        ShowMessage("Module not found or you don't have permission to edit it.", "error");
                        reader.Close();
                    }
                }
                catch (Exception ex)
                {
                    ShowMessage("Error loading module: " + ex.Message, "error");
                }
            }
        }

        protected void BtnUpdateModule_Click(object sender, EventArgs e)
        {
            if (!ValidateModuleForm())
                return;

            if (string.IsNullOrEmpty(hfModuleID.Value))
            {
                ShowMessage("Error: Module ID not found.", "error");
                return;
            }

            string cs = ConfigurationManager.ConnectionStrings["dbConnection"].ConnectionString;
            using (SqlConnection con = new SqlConnection(cs))
            {
                try
                {
                    con.Open();

                    int moduleId = Convert.ToInt32(hfModuleID.Value);

                    SqlCommand updateCmd = new SqlCommand(@"
                        UPDATE Modules
                        SET Title = @Title, Description = @Description, ModuleOrder = @ModuleOrder
                        WHERE ModuleID = @ModuleID AND LecturerID = @LecturerID AND CourseID = @CourseID", con);

                    updateCmd.Parameters.AddWithValue("@ModuleID", moduleId);
                    updateCmd.Parameters.AddWithValue("@Title", txtModuleTitle.Text.Trim());
                    updateCmd.Parameters.AddWithValue("@Description", txtModuleDescription.Text.Trim());
                    updateCmd.Parameters.AddWithValue("@ModuleOrder", Convert.ToInt32(txtModuleOrder.Text.Trim()));
                    updateCmd.Parameters.AddWithValue("@LecturerID", lecturerId);
                    updateCmd.Parameters.AddWithValue("@CourseID", courseId);

                    int rowsAffected = updateCmd.ExecuteNonQuery();
                    if (rowsAffected > 0)
                    {
                        ShowMessage($"Module '{txtModuleTitle.Text.Trim()}' updated successfully!", "success");

                        // Clear form and reload
                        ClearModuleForm();
                        LoadModules();
                        LoadStatistics();

                        // Close modal via JavaScript
                        ClientScript.RegisterStartupScript(this.GetType(), "closeModal", "closeEditModal();", true);
                    }
                    else
                    {
                        ShowMessage("Error updating module. Module not found or you don't have permission.", "error");
                    }
                }
                catch (Exception ex)
                {
                    ShowMessage("Error saving module: " + ex.Message, "error");
                }
            }
        }

        protected void BtnDeleteModule_Click(object sender, EventArgs e)
        {
            try
            {
                LinkButton btn = (LinkButton)sender;
                int moduleId = Convert.ToInt32(btn.CommandArgument);
                DeleteModule(moduleId);
            }
            catch (Exception ex)
            {
                ShowMessage("Error deleting module: " + ex.Message, "error");
            }
        }

        private void DeleteModule(int moduleId)
        {
            string cs = ConfigurationManager.ConnectionStrings["dbConnection"].ConnectionString;
            using (SqlConnection con = new SqlConnection(cs))
            {
                try
                {
                    con.Open();

                    // Get module information for confirmation
                    SqlCommand moduleInfoCmd = new SqlCommand(@"
                        SELECT Title FROM Modules 
                        WHERE ModuleID = @ModuleID AND LecturerID = @LecturerID AND CourseID = @CourseID", con);
                    moduleInfoCmd.Parameters.AddWithValue("@ModuleID", moduleId);
                    moduleInfoCmd.Parameters.AddWithValue("@LecturerID", lecturerId);
                    moduleInfoCmd.Parameters.AddWithValue("@CourseID", courseId);

                    string moduleTitle = moduleInfoCmd.ExecuteScalar()?.ToString() ?? "Unknown Module";

                    // Check if module has any assignments
                    SqlCommand checkCmd = new SqlCommand("SELECT COUNT(*) FROM Assignments WHERE ModuleID = @ModuleID", con);
                    checkCmd.Parameters.AddWithValue("@ModuleID", moduleId);

                    int assignmentCount = (int)checkCmd.ExecuteScalar();
                    if (assignmentCount > 0)
                    {
                        ShowMessage($"Cannot delete module '{moduleTitle}'. It has {assignmentCount} assignment(s) associated with it.", "error");
                        return;
                    }

                    // Delete the module
                    SqlCommand deleteCmd = new SqlCommand(@"
                        DELETE FROM Modules 
                        WHERE ModuleID = @ModuleID AND LecturerID = @LecturerID AND CourseID = @CourseID", con);
                    deleteCmd.Parameters.AddWithValue("@ModuleID", moduleId);
                    deleteCmd.Parameters.AddWithValue("@LecturerID", lecturerId);
                    deleteCmd.Parameters.AddWithValue("@CourseID", courseId);

                    int rowsAffected = deleteCmd.ExecuteNonQuery();
                    if (rowsAffected > 0)
                    {
                        ShowMessage($"Module '{moduleTitle}' deleted successfully!", "success");

                        // Clear form if the deleted module was being edited
                        if (hfModuleID.Value == moduleId.ToString())
                        {
                            ClearModuleForm();
                        }

                        LoadModules(); // Reload modules list
                        LoadStatistics(); // Update statistics
                    }
                    else
                    {
                        ShowMessage("Error deleting module. Module not found or you don't have permission.", "error");
                    }
                }
                catch (Exception ex)
                {
                    ShowMessage("Database error while deleting module: " + ex.Message, "error");
                }
            }
        }

        private bool ValidateModuleForm()
        {
            if (string.IsNullOrWhiteSpace(txtModuleTitle.Text))
            {
                ShowMessage("Please enter module title.", "error");
                return false;
            }

            if (txtModuleTitle.Text.Trim().Length < 3)
            {
                ShowMessage("Module title must be at least 3 characters long.", "error");
                return false;
            }

            if (string.IsNullOrWhiteSpace(txtModuleDescription.Text))
            {
                ShowMessage("Please enter module description.", "error");
                return false;
            }

            if (txtModuleDescription.Text.Trim().Length < 10)
            {
                ShowMessage("Module description must be at least 10 characters long.", "error");
                return false;
            }

            if (string.IsNullOrWhiteSpace(txtModuleOrder.Text) || !int.TryParse(txtModuleOrder.Text, out int order) || order < 1)
            {
                ShowMessage("Please enter a valid module order (positive number).", "error");
                return false;
            }

            // Check if module order is already taken in this course (excluding current module)
            int moduleOrder = Convert.ToInt32(txtModuleOrder.Text);

            string cs = ConfigurationManager.ConnectionStrings["dbConnection"].ConnectionString;
            using (SqlConnection con = new SqlConnection(cs))
            {
                try
                {
                    con.Open();
                    string query = @"
                        SELECT COUNT(*) FROM Modules 
                        WHERE CourseID = @CourseID AND ModuleOrder = @ModuleOrder AND LecturerID = @LecturerID";

                    if (!string.IsNullOrEmpty(hfModuleID.Value))
                    {
                        query += " AND ModuleID != @ModuleID";
                    }

                    SqlCommand cmd = new SqlCommand(query, con);
                    cmd.Parameters.AddWithValue("@CourseID", courseId);
                    cmd.Parameters.AddWithValue("@ModuleOrder", moduleOrder);
                    cmd.Parameters.AddWithValue("@LecturerID", lecturerId);

                    if (!string.IsNullOrEmpty(hfModuleID.Value))
                    {
                        cmd.Parameters.AddWithValue("@ModuleID", hfModuleID.Value);
                    }

                    int count = (int)cmd.ExecuteScalar();
                    if (count > 0)
                    {
                        ShowMessage($"A module with order {moduleOrder} already exists in this course. Please choose a different order.", "error");
                        return false;
                    }
                }
                catch (Exception ex)
                {
                    ShowMessage("Error validating module order: " + ex.Message, "error");
                    return false;
                }
            }

            return true;
        }

        private void ClearModuleForm()
        {
            hfModuleID.Value = "";
            txtModuleTitle.Text = "";
            txtModuleDescription.Text = "";
            txtModuleOrder.Text = "";
        }

        private void ShowMessage(string message, string type)
        {
            lblMessage.Text = message;
            lblMessage.CssClass = $"message {type}";
            lblMessage.Visible = true;

            // Add client-side styling and auto-hide
            string messageClass = type == "error" ? "error" : "success";
            string script = $@"
                var msgElement = document.getElementById('{lblMessage.ClientID}');
                if (msgElement) {{
                    msgElement.className = 'message {messageClass}';
                    msgElement.style.display = 'block';
                    setTimeout(function() {{
                        msgElement.style.display = 'none';
                    }}, 5000);
                }}";

            ClientScript.RegisterStartupScript(this.GetType(), "showMessage", script, true);
        }

        // Override for better error handling
        protected override void OnError(EventArgs e)
        {
            Exception ex = Server.GetLastError();
            if (ex != null)
            {
                System.Diagnostics.Debug.WriteLine("EditModules Page Error: " + ex.Message);

                // Clear the error
                Server.ClearError();

                // Show user-friendly message
                ShowMessage("An unexpected error occurred. Please try again or contact support if the problem persists.", "error");
            }

            base.OnError(e);
        }
    }
}