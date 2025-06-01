using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace assignmentDraft1
{
    public partial class AdminManageModules : System.Web.UI.Page
    {
        private int courseId;

        protected void Page_Load(object sender, EventArgs e)
        {
            // Check if user is logged in and is admin
            if (Session["email"] == null)
            {
                Response.Redirect("loginWebform.aspx");
                return;
            }

            // Get course ID from query string
            if (Request.QueryString["courseId"] == null || !int.TryParse(Request.QueryString["courseId"], out courseId))
            {
                ShowMessage("Invalid course ID. Redirecting to course management...", "error");
                Response.Redirect("manageCourses.aspx");
                return;
            }

            // Load admin info and validate permissions
            if (!LoadAdminInfo())
            {
                return;
            }

            if (!IsPostBack)
            {
                LoadCourseInfo();
                LoadLecturers();
                LoadModules();
                hfCourseID.Value = courseId.ToString();
            }
        }

        private bool LoadAdminInfo()
        {
            string email = Session["email"].ToString();
            string cs = ConfigurationManager.ConnectionStrings["dbConnection"].ConnectionString;

            using (SqlConnection con = new SqlConnection(cs))
            {
                try
                {
                    con.Open();

                    // Check if user is admin
                    SqlCommand userCmd = new SqlCommand("SELECT UserID, Name, Role FROM Users WHERE Username = @Email", con);
                    userCmd.Parameters.AddWithValue("@Email", email);

                    SqlDataReader userReader = userCmd.ExecuteReader();
                    if (userReader.Read())
                    {
                        string role = userReader["Role"].ToString();
                        if (role != "Admin")
                        {
                            userReader.Close();
                            Response.Redirect("loginWebform.aspx");
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

                    return true;
                }
                catch (Exception ex)
                {
                    ShowMessage("Error loading admin information: " + ex.Message, "error");
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
                        Page.Title = $"Admin Manage Modules - {lblCourseName.Text} - Bulb";
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

        private void LoadLecturers()
        {
            string cs = ConfigurationManager.ConnectionStrings["dbConnection"].ConnectionString;
            using (SqlConnection con = new SqlConnection(cs))
            {
                try
                {
                    con.Open();

                    SqlCommand cmd = new SqlCommand(@"
                        SELECT L.LecturerID, L.Name 
                        FROM Lecturers L
                        JOIN Users U ON L.Email = U.Username
                        WHERE U.Role = 'Lecturer'
                        ORDER BY L.Name", con);

                    SqlDataReader reader = cmd.ExecuteReader();

                    ddlLecturer.Items.Clear();
                    ddlLecturer.Items.Add(new ListItem("Select Lecturer", ""));

                    while (reader.Read())
                    {
                        ddlLecturer.Items.Add(new ListItem(
                            reader["Name"].ToString(),
                            reader["LecturerID"].ToString()
                        ));
                    }
                    reader.Close();
                }
                catch (Exception ex)
                {
                    ShowMessage("Error loading lecturers: " + ex.Message, "error");
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
                        SELECT 
                            M.ModuleID, 
                            M.Title, 
                            M.Description, 
                            M.ModuleOrder,
                            M.LecturerID,
                            L.Name AS LecturerName
                        FROM Modules M
                        LEFT JOIN Lecturers L ON M.LecturerID = L.LecturerID
                        WHERE M.CourseID = @CourseID
                        ORDER BY M.ModuleOrder", con);

                    cmd.Parameters.AddWithValue("@CourseID", courseId);

                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    DataTable dt = new DataTable();
                    da.Fill(dt);

                    if (dt.Rows.Count > 0)
                    {
                        rptModules.DataSource = dt;
                        rptModules.DataBind();

                        pnlModulesTable.Visible = true;
                        pnlNoModules.Visible = false;

                        lblModuleCount.Text = dt.Rows.Count.ToString();
                    }
                    else
                    {
                        rptModules.DataSource = null;
                        rptModules.DataBind();

                        pnlModulesTable.Visible = false;
                        pnlNoModules.Visible = true;

                        lblModuleCount.Text = "0";
                    }
                }
                catch (Exception ex)
                {
                    ShowMessage("Error loading modules: " + ex.Message, "error");
                }
            }
        }

        protected void BtnSaveModule_Click(object sender, EventArgs e)
        {
            if (!ValidateModuleForm())
                return;

            string cs = ConfigurationManager.ConnectionStrings["dbConnection"].ConnectionString;
            using (SqlConnection con = new SqlConnection(cs))
            {
                try
                {
                    con.Open();

                    if (string.IsNullOrEmpty(hfModuleID.Value))
                    {
                        // Add new module
                        SqlCommand insertCmd = new SqlCommand(@"
                            INSERT INTO Modules (CourseID, Title, Description, ModuleOrder, LecturerID)
                            VALUES (@CourseID, @Title, @Description, @ModuleOrder, @LecturerID)", con);

                        insertCmd.Parameters.AddWithValue("@CourseID", courseId);
                        insertCmd.Parameters.AddWithValue("@Title", txtModuleTitle.Text.Trim());
                        insertCmd.Parameters.AddWithValue("@Description", txtModuleDescription.Text.Trim());
                        insertCmd.Parameters.AddWithValue("@ModuleOrder", Convert.ToInt32(txtModuleOrder.Text.Trim()));

                        if (string.IsNullOrEmpty(ddlLecturer.SelectedValue))
                        {
                            insertCmd.Parameters.AddWithValue("@LecturerID", DBNull.Value);
                        }
                        else
                        {
                            insertCmd.Parameters.AddWithValue("@LecturerID", Convert.ToInt32(ddlLecturer.SelectedValue));
                        }

                        insertCmd.ExecuteNonQuery();
                        ShowMessage($"Module '{txtModuleTitle.Text.Trim()}' created successfully!", "success");
                    }
                    else
                    {
                        // Update existing module
                        int moduleId = Convert.ToInt32(hfModuleID.Value);

                        SqlCommand updateCmd = new SqlCommand(@"
                            UPDATE Modules
                            SET Title = @Title, Description = @Description, ModuleOrder = @ModuleOrder, LecturerID = @LecturerID
                            WHERE ModuleID = @ModuleID AND CourseID = @CourseID", con);

                        updateCmd.Parameters.AddWithValue("@ModuleID", moduleId);
                        updateCmd.Parameters.AddWithValue("@Title", txtModuleTitle.Text.Trim());
                        updateCmd.Parameters.AddWithValue("@Description", txtModuleDescription.Text.Trim());
                        updateCmd.Parameters.AddWithValue("@ModuleOrder", Convert.ToInt32(txtModuleOrder.Text.Trim()));
                        updateCmd.Parameters.AddWithValue("@CourseID", courseId);

                        if (string.IsNullOrEmpty(ddlLecturer.SelectedValue))
                        {
                            updateCmd.Parameters.AddWithValue("@LecturerID", DBNull.Value);
                        }
                        else
                        {
                            updateCmd.Parameters.AddWithValue("@LecturerID", Convert.ToInt32(ddlLecturer.SelectedValue));
                        }

                        int rowsAffected = updateCmd.ExecuteNonQuery();
                        if (rowsAffected > 0)
                        {
                            ShowMessage($"Module '{txtModuleTitle.Text.Trim()}' updated successfully!", "success");
                        }
                        else
                        {
                            ShowMessage("Error updating module. Module not found.", "error");
                            return;
                        }
                    }

                    // Clear form and reload
                    ClearModuleForm();
                    LoadModules();
                }
                catch (Exception ex)
                {
                    ShowMessage("Error saving module: " + ex.Message, "error");
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
                        SELECT ModuleID, Title, Description, ModuleOrder, LecturerID
                        FROM Modules 
                        WHERE ModuleID = @ModuleID AND CourseID = @CourseID", con);
                    cmd.Parameters.AddWithValue("@ModuleID", moduleId);
                    cmd.Parameters.AddWithValue("@CourseID", courseId);

                    SqlDataReader reader = cmd.ExecuteReader();
                    if (reader.Read())
                    {
                        hfModuleID.Value = reader["ModuleID"].ToString();
                        txtModuleTitle.Text = reader["Title"]?.ToString() ?? "";
                        txtModuleDescription.Text = reader["Description"]?.ToString() ?? "";
                        txtModuleOrder.Text = reader["ModuleOrder"]?.ToString() ?? "";

                        // Set lecturer dropdown
                        string lecturerId = reader["LecturerID"]?.ToString() ?? "";
                        if (!string.IsNullOrEmpty(lecturerId))
                        {
                            ddlLecturer.SelectedValue = lecturerId;
                        }
                        else
                        {
                            ddlLecturer.SelectedIndex = 0; // Select "Select Lecturer"
                        }

                        lblFormTitle.Text = "Edit Module";
                        btnSaveModule.Text = "Update Module";

                        // Scroll to form
                        ClientScript.RegisterStartupScript(this.GetType(), "scrollToForm",
                            "document.querySelector('.form-container').scrollIntoView({ behavior: 'smooth' });", true);
                    }
                    else
                    {
                        ShowMessage("Module not found.", "error");
                    }
                    reader.Close();
                }
                catch (Exception ex)
                {
                    ShowMessage("Error loading module: " + ex.Message, "error");
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
                        WHERE ModuleID = @ModuleID AND CourseID = @CourseID", con);
                    moduleInfoCmd.Parameters.AddWithValue("@ModuleID", moduleId);
                    moduleInfoCmd.Parameters.AddWithValue("@CourseID", courseId);

                    string moduleTitle = moduleInfoCmd.ExecuteScalar()?.ToString() ?? "Unknown Module";

                    // Check if module has any assignments
                    SqlCommand checkAssignmentsCmd = new SqlCommand("SELECT COUNT(*) FROM Assignments WHERE ModuleID = @ModuleID", con);
                    checkAssignmentsCmd.Parameters.AddWithValue("@ModuleID", moduleId);

                    int assignmentCount = (int)checkAssignmentsCmd.ExecuteScalar();

                    // Check if module has any lessons
                    SqlCommand checkLessonsCmd = new SqlCommand("SELECT COUNT(*) FROM Lessons WHERE ModuleID = @ModuleID", con);
                    checkLessonsCmd.Parameters.AddWithValue("@ModuleID", moduleId);

                    int lessonCount = (int)checkLessonsCmd.ExecuteScalar();

                    if (assignmentCount > 0 || lessonCount > 0)
                    {
                        string dependencyMessage = $"Cannot delete module '{moduleTitle}'. It has ";
                        if (assignmentCount > 0 && lessonCount > 0)
                        {
                            dependencyMessage += $"{assignmentCount} assignment(s) and {lessonCount} lesson(s)";
                        }
                        else if (assignmentCount > 0)
                        {
                            dependencyMessage += $"{assignmentCount} assignment(s)";
                        }
                        else
                        {
                            dependencyMessage += $"{lessonCount} lesson(s)";
                        }
                        dependencyMessage += " associated with it.";

                        ShowMessage(dependencyMessage, "error");
                        return;
                    }

                    // Delete the module
                    SqlCommand deleteCmd = new SqlCommand(@"
                        DELETE FROM Modules 
                        WHERE ModuleID = @ModuleID AND CourseID = @CourseID", con);
                    deleteCmd.Parameters.AddWithValue("@ModuleID", moduleId);
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
                    }
                    else
                    {
                        ShowMessage("Error deleting module. Module not found.", "error");
                    }
                }
                catch (Exception ex)
                {
                    ShowMessage("Database error while deleting module: " + ex.Message, "error");
                }
            }
        }

        protected void BtnManageLessons_Click(object sender, EventArgs e)
        {
            try
            {
                LinkButton btn = (LinkButton)sender;
                int moduleId = Convert.ToInt32(btn.CommandArgument);

                // Redirect to the AdminManageLessons.aspx page with moduleId and courseId parameters
                Response.Redirect($"AdminManageLessons.aspx?moduleId={moduleId}&courseId={courseId}");
            }
            catch (Exception ex)
            {
                ShowMessage("Error navigating to lessons management: " + ex.Message, "error");
            }
        }

        protected void BtnCancel_Click(object sender, EventArgs e)
        {
            ClearModuleForm();
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

            // Check if module order is already taken in this course
            int moduleOrder = Convert.ToInt32(txtModuleOrder.Text);

            string cs = ConfigurationManager.ConnectionStrings["dbConnection"].ConnectionString;
            using (SqlConnection con = new SqlConnection(cs))
            {
                try
                {
                    con.Open();
                    string query = @"
                        SELECT COUNT(*) FROM Modules 
                        WHERE CourseID = @CourseID AND ModuleOrder = @ModuleOrder";

                    if (!string.IsNullOrEmpty(hfModuleID.Value))
                    {
                        query += " AND ModuleID != @ModuleID";
                    }

                    SqlCommand cmd = new SqlCommand(query, con);
                    cmd.Parameters.AddWithValue("@CourseID", courseId);
                    cmd.Parameters.AddWithValue("@ModuleOrder", moduleOrder);

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
            ddlLecturer.SelectedIndex = 0;

            lblFormTitle.Text = "Add New Module";
            btnSaveModule.Text = "Save Module";
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

        // Helper method to get suggested module order
        private int GetNextModuleOrder()
        {
            string cs = ConfigurationManager.ConnectionStrings["dbConnection"].ConnectionString;
            using (SqlConnection con = new SqlConnection(cs))
            {
                try
                {
                    con.Open();
                    SqlCommand cmd = new SqlCommand(@"
                        SELECT ISNULL(MAX(ModuleOrder), 0) + 1 
                        FROM Modules 
                        WHERE CourseID = @CourseID", con);
                    cmd.Parameters.AddWithValue("@CourseID", courseId);

                    return (int)cmd.ExecuteScalar();
                }
                catch
                {
                    return 1; // Default to 1 if there's an error
                }
            }
        }

        // Override PreRender to set suggested module order for new modules
        protected override void OnPreRender(EventArgs e)
        {
            base.OnPreRender(e);

            // If adding new module and order field is empty, suggest next order
            if (string.IsNullOrEmpty(hfModuleID.Value) && string.IsNullOrEmpty(txtModuleOrder.Text))
            {
                txtModuleOrder.Text = GetNextModuleOrder().ToString();
            }
        }

        // Override for better error handling
        protected override void OnError(EventArgs e)
        {
            Exception ex = Server.GetLastError();
            if (ex != null)
            {
                System.Diagnostics.Debug.WriteLine("AdminManageModules Page Error: " + ex.Message);

                // Clear the error
                Server.ClearError();

                // Show user-friendly message
                ShowMessage("An unexpected error occurred. Please try again or contact support if the problem persists.", "error");
            }

            base.OnError(e);
        }
    }
}