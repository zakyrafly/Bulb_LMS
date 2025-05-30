<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="editAssignment.aspx.cs" Inherits="assignmentDraft1.editAssignment" %>

<!DOCTYPE html>
<html lang="en">
<head>
   <meta charset="UTF-8">
   <meta http-equiv="X-UA-Compatible" content="IE=edge">
   <meta name="viewport" content="width=device-width, initial-scale=1.0">
   <title>Edit Assignment - Bulb Admin</title>
   <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.1.2/css/all.min.css">
   <link rel="stylesheet" href="css/style.css">
   
   <style>
       :root {
           --admin-primary: #2c3e50;
           --admin-secondary: #3498db;
           --admin-success: #27ae60;
           --admin-warning: #f39c12;
           --admin-danger: #e74c3c;
           --admin-light: #ecf0f1;
       }
       
       .admin-header {
           background: linear-gradient(135deg, var(--admin-primary), var(--admin-secondary));
           color: white;
       }
       
       .admin-header .logo {
           color: white;
           font-weight: bold;
       }
       
       .edit-assignment {
           padding: 2rem;
           max-width: 1000px;
           margin: 0 auto;
       }
       
       .page-header {
           background: white;
           border-radius: 1rem;
           box-shadow: 0 4px 15px rgba(0,0,0,0.1);
           padding: 2rem;
           margin-bottom: 2rem;
           text-align: center;
       }
       
       .page-title {
           font-size: 2.5rem;
           color: var(--admin-primary);
           margin-bottom: 0.5rem;
       }
       
       .page-subtitle {
           color: #7f8c8d;
           font-size: 1.4rem;
       }
       
       .form-container {
           background: white;
           border-radius: 1rem;
           box-shadow: 0 4px 15px rgba(0,0,0,0.1);
           padding: 2rem;
       }
       
       .form-section {
           margin-bottom: 2.5rem;
       }
       
       .section-title {
           font-size: 1.8rem;
           color: var(--admin-primary);
           margin-bottom: 1.5rem;
           padding-bottom: 0.5rem;
           border-bottom: 2px solid var(--admin-light);
       }
       
       .form-grid {
           display: grid;
           grid-template-columns: 1fr 1fr;
           gap: 1.5rem;
           margin-bottom: 1.5rem;
       }
       
       .form-group {
           margin-bottom: 1.5rem;
       }
       
       .form-group.full-width {
           grid-column: 1 / -1;
       }
       
       .form-group label {
           display: block;
           margin-bottom: 0.5rem;
           font-weight: bold;
           color: var(--admin-primary);
           font-size: 1.2rem;
       }
       
       .required {
           color: var(--admin-danger);
       }
       
       .form-input {
           width: 100%;
           padding: 1rem;
           border: 2px solid #ddd;
           border-radius: 0.5rem;
           font-size: 1.2rem;
           transition: border-color 0.3s ease;
           box-sizing: border-box;
       }
       
       .form-input:focus {
           outline: none;
           border-color: var(--admin-secondary);
           box-shadow: 0 0 0 3px rgba(52, 152, 219, 0.1);
       }
       
       .form-textarea {
           min-height: 120px;
           resize: vertical;
           font-family: inherit;
       }
       
       .datetime-group {
           display: grid;
           grid-template-columns: 1fr 1fr;
           gap: 1rem;
       }
       
       .info-card {
           background: #e3f2fd;
           border: 1px solid #90caf9;
           border-radius: 0.5rem;
           padding: 1rem;
           margin-bottom: 1.5rem;
       }
       
       .info-card h4 {
           margin: 0 0 0.5rem 0;
           color: var(--admin-secondary);
       }
       
       .info-card p {
           margin: 0;
           color: #1976d2;
       }
       
       .warning-card {
           background: #fff3cd;
           border: 1px solid #ffc107;
           border-radius: 0.5rem;
           padding: 1rem;
           margin-bottom: 1.5rem;
       }
       
       .warning-card h4 {
           margin: 0 0 0.5rem 0;
           color: var(--admin-warning);
       }
       
       .warning-card p {
           margin: 0;
           color: #856404;
       }
       
       .action-section {
           background: #f8f9fa;
           border-radius: 0.5rem;
           padding: 1.5rem;
           margin-top: 2rem;
           text-align: center;
       }
       
       .btn-group {
           display: flex;
           gap: 1rem;
           justify-content: center;
           flex-wrap: wrap;
       }
       
       .btn-primary {
           background: var(--admin-secondary);
           color: white;
           padding: 1rem 2rem;
           border: none;
           border-radius: 0.5rem;
           font-size: 1.3rem;
           font-weight: bold;
           cursor: pointer;
           transition: all 0.3s ease;
           text-decoration: none;
           display: inline-flex;
           align-items: center;
           gap: 0.5rem;
       }
       
       .btn-primary:hover {
           background: #2980b9;
           transform: translateY(-2px);
           text-decoration: none;
           color: white;
       }
       
       .btn-success {
           background: var(--admin-success);
           color: white;
           padding: 1rem 2rem;
           border: none;
           border-radius: 0.5rem;
           font-size: 1.3rem;
           font-weight: bold;
           cursor: pointer;
           transition: all 0.3s ease;
       }
       
       .btn-success:hover {
           background: #229954;
           transform: translateY(-2px);
       }
       
       .btn-warning {
           background: var(--admin-warning);
           color: white;
           padding: 1rem 2rem;
           border: none;
           border-radius: 0.5rem;
           font-size: 1.3rem;
           font-weight: bold;
           cursor: pointer;
           transition: all 0.3s ease;
           text-decoration: none;
           display: inline-flex;
           align-items: center;
           gap: 0.5rem;
       }
       
       .btn-warning:hover {
           background: #d68910;
           transform: translateY(-2px);
           text-decoration: none;
           color: white;
       }
       
       .btn-danger {
           background: var(--admin-danger);
           color: white;
           padding: 1rem 2rem;
           border: none;
           border-radius: 0.5rem;
           font-size: 1.3rem;
           font-weight: bold;
           cursor: pointer;
           transition: all 0.3s ease;
       }
       
       .btn-danger:hover {
           background: #c0392b;
           transform: translateY(-2px);
       }
       
       .stats-grid {
           display: grid;
           grid-template-columns: repeat(auto-fit, minmax(150px, 1fr));
           gap: 1rem;
           margin: 1.5rem 0;
       }
       
       .stat-item {
           text-align: center;
           padding: 1rem;
           background: white;
           border-radius: 0.5rem;
           border: 1px solid #ddd;
       }
       
       .stat-number {
           font-size: 1.8rem;
           font-weight: bold;
           color: var(--admin-secondary);
       }
       
       .stat-label {
           font-size: 1rem;
           color: #7f8c8d;
           margin-top: 0.3rem;
       }
       
       @media (max-width: 768px) {
           .edit-assignment {
               padding: 1rem;
           }
           
           .form-grid {
               grid-template-columns: 1fr;
           }
           
           .datetime-group {
               grid-template-columns: 1fr;
           }
           
           .btn-group {
               flex-direction: column;
           }
           
           .stats-grid {
               grid-template-columns: 1fr 1fr;
           }
       }
   </style>
</head>
<body>
    <form id="form1" runat="server">

<header class="header admin-header">
   <section class="flex">
      <a href="adminDashboard.aspx" class="logo">
          <i class="fas fa-shield-alt"></i> Bulb Admin
      </a>
      
      <div class="icons">
         <div id="menu-btn" class="fas fa-bars"></div>
         <div id="user-btn" class="fas fa-user"></div>
         <div id="toggle-btn" class="fas fa-sun"></div>
      </div>

      <div class="profile">
         <img src="images/pic-1.jpg" class="image" alt="">
         <h3 class="name"><asp:Label ID="lblName" runat="server" Text=""></asp:Label></h3>
         <p class="role"><asp:Label ID="lblRole" runat="server" Text="admin"></asp:Label></p>
         <a href="profile.aspx" class="btn">view profile</a>
         <div class="flex-btn">
            <a href="loginWebform.aspx" class="option-btn">logout</a>
         </div>
      </div>
   </section>
</header>   

<div class="side-bar">
   <div id="close-btn">
      <i class="fas fa-times"></i>
   </div>
   <div class="profile">
      <img src="images/pic-1.jpg" class="image" alt="">
      <h3 class="name"><asp:Label ID="lblSidebarName" runat="server" Text=""></asp:Label></h3>
      <p class="role"><asp:Label ID="lblSidebarRole" runat="server" Text="admin"></asp:Label></p>
      <a href="profile.aspx" class="btn">view profile</a>
   </div>
   <nav class="navbar">
      <a href="adminDashboard.aspx"><i class="fas fa-tachometer-alt"></i><span>Dashboard</span></a>
      <a href="manageUsers.aspx"><i class="fas fa-users"></i><span>User Management</span></a>
      <a href="manageCourses.aspx"><i class="fas fa-graduation-cap"></i><span>Course Management</span></a>
      <a href="manageAssignments.aspx"><i class="fas fa-tasks"></i><span>Assignment Oversight</span></a>
      <a href="systemReports.aspx"><i class="fas fa-chart-line"></i><span>Reports & Analytics</span></a>
      <a href="systemSettings.aspx"><i class="fas fa-cog"></i><span>System Settings</span></a>
      <a href="loginWebform.aspx"><i class="fas fa-sign-out-alt"></i><span>Logout</span></a>
   </nav>
</div>

<section class="edit-assignment">
    <!-- Page Header -->
    <div class="page-header">
        <h1 class="page-title">
            <i class="fas fa-edit"></i> Edit Assignment
        </h1>
        <p class="page-subtitle">Modify assignment details and settings</p>
    </div>

    <!-- Form Container -->
    <div class="form-container">
        <!-- Assignment Information -->
        <div class="form-section">
            <h2 class="section-title">
                <i class="fas fa-info-circle"></i> Assignment Information
            </h2>
            
            <div class="info-card">
                <h4><i class="fas fa-graduation-cap"></i> Course & Module</h4>
                <p><asp:Label ID="lblCourseModule" runat="server" Text=""></asp:Label></p>
            </div>
            
            <div class="form-group">
                <label>Assignment Title <span class="required">*</span></label>
                <asp:TextBox ID="txtTitle" runat="server" CssClass="form-input" MaxLength="200" placeholder="Enter assignment title" />
            </div>
            
            <div class="form-group">
                <label>Description <span class="required">*</span></label>
                <asp:TextBox ID="txtDescription" runat="server" CssClass="form-input form-textarea" TextMode="MultiLine" 
                           placeholder="Enter assignment description" />
            </div>
            
            <div class="form-group">
                <label>Instructions</label>
                <asp:TextBox ID="txtInstructions" runat="server" CssClass="form-input form-textarea" TextMode="MultiLine" 
                           placeholder="Enter detailed instructions for students (optional)" />
            </div>
        </div>

        <!-- Assignment Settings -->
        <div class="form-section">
            <h2 class="section-title">
                <i class="fas fa-cog"></i> Assignment Settings
            </h2>
            
            <div class="form-grid">
                <div class="form-group">
                    <label>Maximum Points <span class="required">*</span></label>
                    <asp:TextBox ID="txtMaxPoints" runat="server" CssClass="form-input" TextMode="Number" 
                               placeholder="100" min="1" max="1000" />
                </div>
                
                <div class="form-group">
                    <label>Assignment Status</label>
                    <asp:DropDownList ID="ddlStatus" runat="server" CssClass="form-input">
                        <asp:ListItem Text="Active" Value="True" />
                        <asp:ListItem Text="Inactive" Value="False" />
                    </asp:DropDownList>
                </div>
            </div>
            
            <div class="form-group">
                <label>Due Date & Time <span class="required">*</span></label>
                <div class="datetime-group">
                    <asp:TextBox ID="txtDueDate" runat="server" CssClass="form-input" TextMode="Date" />
                    <asp:TextBox ID="txtDueTime" runat="server" CssClass="form-input" TextMode="Time" />
                </div>
            </div>
        </div>

        <!-- Assignment Statistics -->
        <div class="form-section">
            <h2 class="section-title">
                <i class="fas fa-chart-bar"></i> Assignment Statistics
            </h2>
            
            <div class="stats-grid">
                <div class="stat-item">
                    <div class="stat-number"><asp:Label ID="lblTotalSubmissions" runat="server" Text="0"></asp:Label></div>
                    <div class="stat-label">Total Submissions</div>
                </div>
                <div class="stat-item">
                    <div class="stat-number"><asp:Label ID="lblGradedSubmissions" runat="server" Text="0"></asp:Label></div>
                    <div class="stat-label">Graded</div>
                </div>
                <div class="stat-item">
                    <div class="stat-number"><asp:Label ID="lblPendingGrades" runat="server" Text="0"></asp:Label></div>
                    <div class="stat-label">Pending Grades</div>
                </div>
                <div class="stat-item">
                    <div class="stat-number"><asp:Label ID="lblEnrolledStudents" runat="server" Text="0"></asp:Label></div>
                    <div class="stat-label">Enrolled Students</div>
                </div>
            </div>
            
            <asp:Panel ID="pnlSubmissionWarning" runat="server" Visible="false">
                <div class="warning-card">
                    <h4><i class="fas fa-exclamation-triangle"></i> Warning</h4>
                    <p>This assignment has submissions. Some changes may affect existing student work and grades.</p>
                </div>
            </asp:Panel>
        </div>

        <!-- Action Buttons -->
        <div class="action-section">
            <h3 style="margin-bottom: 1.5rem; color: var(--admin-primary);">Actions</h3>
            
            <div class="btn-group">
                <asp:Button ID="btnSaveChanges" runat="server" Text="Save Changes" CssClass="btn-success" OnClick="btnSaveChanges_Click" />
                <a href='<%# "gradeAssignment.aspx?assignmentID=" + Request.QueryString["assignmentID"] %>' class="btn-primary">
                    <i class="fas fa-star"></i> Grade Assignment
                </a>
                <a href="manageAssignments.aspx" class="btn-warning">
                    <i class="fas fa-arrow-left"></i> Back to Assignments
                </a>
                <asp:Button ID="btnDeleteAssignment" runat="server" Text="Delete Assignment" CssClass="btn-danger" 
                          OnClick="btnDeleteAssignment_Click" 
                          OnClientClick="return confirm('Are you sure you want to delete this assignment? This action cannot be undone.');" />
            </div>
        </div>
    </div>

    <!-- Messages -->
    <asp:Label ID="lblMessage" runat="server" Text="" style="display: block; margin: 1rem 0; text-align: center; font-size: 1.2rem;"></asp:Label>
</section>

<footer class="footer">
   &copy; copyright @ 2025 by <span>Stanley Nilam</span> | all rights reserved!
</footer>

<script src="js/script.js"></script>
<script>
    // Auto-hide messages after 5 seconds
    window.onload = function() {
        var messageLabel = document.getElementById('<%= lblMessage.ClientID %>');
        if (messageLabel && messageLabel.innerText.trim() !== '') {
            setTimeout(function() {
                messageLabel.style.display = 'none';
            }, 5000);
        }
        
        // Set minimum date to today for due date
        var dueDateInput = document.getElementById('<%= txtDueDate.ClientID %>');
        if (dueDateInput) {
            var today = new Date().toISOString().split('T')[0];
            dueDateInput.setAttribute('min', today);
        }
    }
    
    // Validate form before submission
    function validateForm() {
        var title = document.getElementById('<%= txtTitle.ClientID %>').value.trim();
        var description = document.getElementById('<%= txtDescription.ClientID %>').value.trim();
        var maxPoints = document.getElementById('<%= txtMaxPoints.ClientID %>').value;
        var dueDate = document.getElementById('<%= txtDueDate.ClientID %>').value;
        var dueTime = document.getElementById('<%= txtDueTime.ClientID %>').value;
        
        if (!title) {
            alert('Please enter assignment title.');
            return false;
        }
        
        if (!description) {
            alert('Please enter assignment description.');
            return false;
        }
        
        if (!maxPoints || maxPoints <= 0) {
            alert('Please enter valid maximum points.');
            return false;
        }
        
        if (!dueDate || !dueTime) {
            alert('Please select due date and time.');
            return false;
        }
        
        // Check if due date is in the future
        var dueDateTimeString = dueDate + 'T' + dueTime;
        var dueDateTime = new Date(dueDateTimeString);
        var now = new Date();
        
        if (dueDateTime <= now) {
            if (!confirm('The due date is in the past or very soon. Are you sure you want to save this?')) {
                return false;
            }
        }
        
        return true;
    }
    
    // Attach validation to save button
    document.getElementById('<%= btnSaveChanges.ClientID %>').onclick = function() {
        return validateForm();
    };
</script>

    </form>
</body>
</html>