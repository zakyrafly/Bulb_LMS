using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace assignmentDraft1
{
    public partial class assignments : System.Web.UI.Page
    {
        private int lecturerId;

        protected void Page_Load(object sender, EventArgs e)
        {
            // Check if user is logged in
            if (Session["email"] == null)
            {
                Response.Redirect("loginWebform.aspx");
                return;
            }

            // Load lecturer info on every page load
            LoadLecturerInfo();

            if (!IsPostBack)
            {
                LoadModuleDropdowns();
                LoadAssignments();
            }
        }

        private void LoadLecturerInfo()
        {
            string email = Session["email"].ToString();
            string cs = ConfigurationManager.ConnectionStrings["dbConnection"].ConnectionString;

            using (SqlConnection con = new SqlConnection(cs))
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
                        Response.Redirect("homeWebform.aspx"); // Redirect non-lecturers
                        return;
                    }

                    lblName.Text = userReader["Name"].ToString();
                    lblRole.Text = role;
                    lblSidebarName.Text = userReader["Name"].ToString();
                    lblSidebarRole.Text = role;
                }
                userReader.Close();

                // Get lecturer ID from Lecturers table
                SqlCommand lecCmd = new SqlCommand("SELECT LecturerID FROM Lecturers WHERE Email = @Email", con);
                lecCmd.Parameters.AddWithValue("@Email", email);

                object lecIdObj = lecCmd.ExecuteScalar();
                if (lecIdObj != null)
                {
                    lecturerId = Convert.ToInt32(lecIdObj);
                }
                else
                {
                    lblMessage.Text = "Lecturer profile not found. Please contact administrator.";
                    lblMessage.ForeColor = System.Drawing.Color.Red;
                }
            }
        }

        private void LoadModuleDropdowns()
        {
            string cs = ConfigurationManager.ConnectionStrings["dbConnection"].ConnectionString;
            using (SqlConnection con = new SqlConnection(cs))
            {
                con.Open();

                // Load modules for this lecturer
                SqlCommand cmd = new SqlCommand(@"
                    SELECT ModuleID, Title, C.CourseName
                    FROM Modules M
                    JOIN Courses C ON M.CourseID = C.CourseID
                    WHERE M.LecturerID = @LecturerID
                    ORDER BY C.CourseName, M.Title", con);
                cmd.Parameters.AddWithValue("@LecturerID", lecturerId);

                SqlDataReader reader = cmd.ExecuteReader();

                // Clear and populate module dropdowns
                ddlModule.Items.Clear();
                ddlModuleFilter.Items.Clear();

                ddlModule.Items.Add(new ListItem("-- Select Module --", ""));
                ddlModuleFilter.Items.Add(new ListItem("All Modules", ""));

                while (reader.Read())
                {
                    string moduleText = $"{reader["CourseName"]} - {reader["Title"]}";
                    string moduleValue = reader["ModuleID"].ToString();

                    ddlModule.Items.Add(new ListItem(moduleText, moduleValue));
                    ddlModuleFilter.Items.Add(new ListItem(moduleText, moduleValue));
                }
            }
        }

        private void LoadAssignments()
        {
            string cs = ConfigurationManager.ConnectionStrings["dbConnection"].ConnectionString;
            using (SqlConnection con = new SqlConnection(cs))
            {
                con.Open();

                // Build dynamic query based on filters
                string query = @"
                    SELECT 
                        A.AssignmentID, A.Title, A.Description, A.DueDate, A.MaxPoints,
                        M.Title AS ModuleTitle, C.CourseName,
                        ISNULL(SubmissionStats.TotalSubmissions, 0) AS TotalSubmissions,
                        ISNULL(SubmissionStats.GradedSubmissions, 0) AS GradedSubmissions,
                        (ISNULL(SubmissionStats.TotalSubmissions, 0) - ISNULL(SubmissionStats.GradedSubmissions, 0)) AS PendingGrades
                    FROM Assignments A
                    JOIN Modules M ON A.ModuleID = M.ModuleID
                    JOIN Courses C ON M.CourseID = C.CourseID
                    LEFT JOIN (
                        SELECT 
                            AssignmentID,
                            COUNT(*) AS TotalSubmissions,
                            SUM(CASE WHEN G.GradeID IS NOT NULL THEN 1 ELSE 0 END) AS GradedSubmissions
                        FROM AssignmentSubmissions S
                        LEFT JOIN AssignmentGrades G ON S.SubmissionID = G.SubmissionID
                        WHERE S.Status = 'Submitted'
                        GROUP BY AssignmentID
                    ) SubmissionStats ON A.AssignmentID = SubmissionStats.AssignmentID
                    WHERE M.LecturerID = @LecturerID AND A.IsActive = 1";

                // Add filters
                if (!string.IsNullOrEmpty(ddlModuleFilter.SelectedValue))
                {
                    query += " AND M.ModuleID = @ModuleFilter";
                }

                if (!string.IsNullOrEmpty(ddlStatusFilter.SelectedValue))
                {
                    switch (ddlStatusFilter.SelectedValue)
                    {
                        case "DueSoon":
                            query += " AND A.DueDate BETWEEN GETDATE() AND DATEADD(day, 7, GETDATE())";
                            break;
                        case "Overdue":
                            query += " AND A.DueDate < GETDATE()";
                            break;
                        case "Active":
                            query += " AND A.DueDate > GETDATE()";
                            break;
                    }
                }

                query += " ORDER BY A.DueDate ASC";

                SqlCommand cmd = new SqlCommand(query, con);
                cmd.Parameters.AddWithValue("@LecturerID", lecturerId);

                if (!string.IsNullOrEmpty(ddlModuleFilter.SelectedValue))
                {
                    cmd.Parameters.AddWithValue("@ModuleFilter", ddlModuleFilter.SelectedValue);
                }

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);

                if (dt.Rows.Count > 0)
                {
                    assignmentRepeater.DataSource = dt;
                    assignmentRepeater.DataBind();
                    pnlNoAssignments.Visible = false;
                }
                else
                {
                    assignmentRepeater.DataSource = null;
                    assignmentRepeater.DataBind();
                    pnlNoAssignments.Visible = true;
                }
            }
        }

        protected void ddlModuleFilter_SelectedIndexChanged(object sender, EventArgs e)
        {
            LoadAssignments();
        }

        protected void ddlStatusFilter_SelectedIndexChanged(object sender, EventArgs e)
        {
            LoadAssignments();
        }

        protected void btnSearch_Click(object sender, EventArgs e)
        {
            // Implement search functionality if needed
            string query = txtSearch.Text.Trim();
            if (!string.IsNullOrEmpty(query))
            {
                // You can add search logic here
                LoadAssignments();
            }
        }

        protected void btnSaveAssignment_Click(object sender, EventArgs e)
        {
            if (!ValidateAssignmentForm())
                return;

            string cs = ConfigurationManager.ConnectionStrings["dbConnection"].ConnectionString;
            using (SqlConnection con = new SqlConnection(cs))
            {
                con.Open();

                DateTime dueDateTime = DateTime.Parse($"{txtDueDate.Text} {txtDueTime.Text}");

                if (string.IsNullOrEmpty(hfAssignmentID.Value))
                {
                    // Add new assignment
                    SqlCommand getIdCmd = new SqlCommand("SELECT ISNULL(MAX(AssignmentID), 0) + 1 FROM Assignments", con);
                    int newAssignmentId = (int)getIdCmd.ExecuteScalar();

                    SqlCommand insertCmd = new SqlCommand(@"
                        INSERT INTO Assignments 
                        (AssignmentID, ModuleID, Title, Description, Instructions, DueDate, MaxPoints, CreatedDate, IsActive)
                        VALUES (@AssignmentID, @ModuleID, @Title, @Description, @Instructions, @DueDate, @MaxPoints, @CreatedDate, @IsActive)", con);

                    insertCmd.Parameters.AddWithValue("@AssignmentID", newAssignmentId);
                    insertCmd.Parameters.AddWithValue("@ModuleID", ddlModule.SelectedValue);
                    insertCmd.Parameters.AddWithValue("@Title", txtTitle.Text.Trim());
                    insertCmd.Parameters.AddWithValue("@Description", txtDescription.Text.Trim());
                    insertCmd.Parameters.AddWithValue("@Instructions", string.IsNullOrWhiteSpace(txtInstructions.Text) ? (object)DBNull.Value : txtInstructions.Text.Trim());
                    insertCmd.Parameters.AddWithValue("@DueDate", dueDateTime);
                    insertCmd.Parameters.AddWithValue("@MaxPoints", int.Parse(txtMaxPoints.Text));
                    insertCmd.Parameters.AddWithValue("@CreatedDate", DateTime.Now);
                    insertCmd.Parameters.AddWithValue("@IsActive", true);

                    insertCmd.ExecuteNonQuery();

                    lblMessage.Text = "Assignment created successfully!";
                    lblMessage.ForeColor = System.Drawing.Color.Green;
                }
                else
                {
                    // Update existing assignment
                    SqlCommand updateCmd = new SqlCommand(@"
                        UPDATE Assignments 
                        SET ModuleID = @ModuleID, Title = @Title, Description = @Description, 
                            Instructions = @Instructions, DueDate = @DueDate, MaxPoints = @MaxPoints
                        WHERE AssignmentID = @AssignmentID", con);

                    updateCmd.Parameters.AddWithValue("@AssignmentID", hfAssignmentID.Value);
                    updateCmd.Parameters.AddWithValue("@ModuleID", ddlModule.SelectedValue);
                    updateCmd.Parameters.AddWithValue("@Title", txtTitle.Text.Trim());
                    updateCmd.Parameters.AddWithValue("@Description", txtDescription.Text.Trim());
                    updateCmd.Parameters.AddWithValue("@Instructions", string.IsNullOrWhiteSpace(txtInstructions.Text) ? (object)DBNull.Value : txtInstructions.Text.Trim());
                    updateCmd.Parameters.AddWithValue("@DueDate", dueDateTime);
                    updateCmd.Parameters.AddWithValue("@MaxPoints", int.Parse(txtMaxPoints.Text));

                    updateCmd.ExecuteNonQuery();

                    lblMessage.Text = "Assignment updated successfully!";
                    lblMessage.ForeColor = System.Drawing.Color.Green;
                }
            }

            // Clear form and reload
            ClearForm();
            LoadAssignments();

            // Close modal via JavaScript
            ClientScript.RegisterStartupScript(this.GetType(), "closeModal", "closeModal();", true);
        }

        protected void assignmentRepeater_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            int assignmentId = Convert.ToInt32(e.CommandArgument);

            switch (e.CommandName)
            {
                case "Edit":
                    LoadAssignmentForEdit(assignmentId);
                    break;
                case "Delete":
                    DeleteAssignment(assignmentId);
                    break;
                case "Grade":
                    Response.Redirect($"TeacherGradeAssignment.aspx?assignmentID={assignmentId}");
                    break;
            }
        }

        private void LoadAssignmentForEdit(int assignmentId)
        {
            string cs = ConfigurationManager.ConnectionStrings["dbConnection"].ConnectionString;
            using (SqlConnection con = new SqlConnection(cs))
            {
                con.Open();

                SqlCommand cmd = new SqlCommand(@"
                    SELECT AssignmentID, ModuleID, Title, Description, Instructions, DueDate, MaxPoints
                    FROM Assignments 
                    WHERE AssignmentID = @AssignmentID", con);
                cmd.Parameters.AddWithValue("@AssignmentID", assignmentId);

                SqlDataReader reader = cmd.ExecuteReader();
                if (reader.Read())
                {
                    hfAssignmentID.Value = reader["AssignmentID"].ToString();
                    ddlModule.SelectedValue = reader["ModuleID"].ToString();
                    txtTitle.Text = reader["Title"].ToString();
                    txtDescription.Text = reader["Description"].ToString();
                    txtInstructions.Text = reader["Instructions"]?.ToString() ?? "";

                    DateTime dueDate = Convert.ToDateTime(reader["DueDate"]);
                    txtDueDate.Text = dueDate.ToString("yyyy-MM-dd");
                    txtDueTime.Text = dueDate.ToString("HH:mm");
                    txtMaxPoints.Text = reader["MaxPoints"].ToString();

                    // Open modal via JavaScript
                    ClientScript.RegisterStartupScript(this.GetType(), "openEditModal",
                        $"openEditModal({assignmentId});", true);
                }
            }
        }

        private void DeleteAssignment(int assignmentId)
        {
            string cs = ConfigurationManager.ConnectionStrings["dbConnection"].ConnectionString;
            using (SqlConnection con = new SqlConnection(cs))
            {
                con.Open();

                // Soft delete - set IsActive to false
                SqlCommand cmd = new SqlCommand("UPDATE Assignments SET IsActive = 0 WHERE AssignmentID = @AssignmentID", con);
                cmd.Parameters.AddWithValue("@AssignmentID", assignmentId);

                cmd.ExecuteNonQuery();

                lblMessage.Text = "Assignment deleted successfully!";
                lblMessage.ForeColor = System.Drawing.Color.Green;

                LoadAssignments();
            }
        }

        private bool ValidateAssignmentForm()
        {
            if (string.IsNullOrWhiteSpace(txtTitle.Text))
            {
                lblMessage.Text = "Please enter assignment title.";
                lblMessage.ForeColor = System.Drawing.Color.Red;
                return false;
            }

            if (string.IsNullOrEmpty(ddlModule.SelectedValue))
            {
                lblMessage.Text = "Please select a module.";
                lblMessage.ForeColor = System.Drawing.Color.Red;
                return false;
            }

            if (string.IsNullOrWhiteSpace(txtDescription.Text))
            {
                lblMessage.Text = "Please enter assignment description.";
                lblMessage.ForeColor = System.Drawing.Color.Red;
                return false;
            }

            if (string.IsNullOrWhiteSpace(txtDueDate.Text) || string.IsNullOrWhiteSpace(txtDueTime.Text))
            {
                lblMessage.Text = "Please select due date and time.";
                lblMessage.ForeColor = System.Drawing.Color.Red;
                return false;
            }

            DateTime dueDateTime;
            if (!DateTime.TryParse($"{txtDueDate.Text} {txtDueTime.Text}", out dueDateTime))
            {
                lblMessage.Text = "Invalid due date/time format.";
                lblMessage.ForeColor = System.Drawing.Color.Red;
                return false;
            }

            if (dueDateTime <= DateTime.Now)
            {
                lblMessage.Text = "Due date must be in the future.";
                lblMessage.ForeColor = System.Drawing.Color.Red;
                return false;
            }

            int maxPoints;
            if (!int.TryParse(txtMaxPoints.Text, out maxPoints) || maxPoints <= 0)
            {
                lblMessage.Text = "Please enter valid maximum points (greater than 0).";
                lblMessage.ForeColor = System.Drawing.Color.Red;
                return false;
            }

            return true;
        }

        private void ClearForm()
        {
            hfAssignmentID.Value = "";
            ddlModule.SelectedIndex = 0;
            txtTitle.Text = "";
            txtDescription.Text = "";
            txtInstructions.Text = "";
            txtDueDate.Text = "";
            txtDueTime.Text = "";
            txtMaxPoints.Text = "";
        }

        // Helper methods for the repeater
        protected string GetCardClass(object dueDateObj)
        {
            if (dueDateObj == null) return "";

            DateTime dueDate = Convert.ToDateTime(dueDateObj);
            DateTime now = DateTime.Now;

            if (dueDate < now)
                return "overdue";
            else if (dueDate < now.AddDays(7))
                return "due-soon";

            return "";
        }

        protected string GetStatusClass(object dueDateObj)
        {
            if (dueDateObj == null) return "status-pending";

            DateTime dueDate = Convert.ToDateTime(dueDateObj);
            DateTime now = DateTime.Now;

            if (dueDate < now)
                return "status-overdue";
            else if (dueDate < now.AddDays(7))
                return "status-pending";

            return "status-submitted";
        }

        protected string GetStatusText(object dueDateObj)
        {
            if (dueDateObj == null) return "Active";

            DateTime dueDate = Convert.ToDateTime(dueDateObj);
            DateTime now = DateTime.Now;

            if (dueDate < now)
                return "Overdue";
            else if (dueDate < now.AddDays(7))
                return "Due Soon";

            return "Active";
        }
    }
}