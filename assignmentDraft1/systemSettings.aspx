<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="systemSettings.aspx.cs" Inherits="assignmentDraft1.systemSettings" %>

<!DOCTYPE html>
<html lang="en">
<head>
   <meta charset="UTF-8">
   <meta http-equiv="X-UA-Compatible" content="IE=edge">
   <meta name="viewport" content="width=device-width, initial-scale=1.0">
   <title>System Settings - Bulb Admin</title>
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
           --admin-purple: #9b59b6;
       }
       
       .admin-header {
           background: linear-gradient(135deg, var(--admin-primary), var(--admin-secondary));
           color: white;
       }
       
       .admin-header .logo {
           color: white;
           font-weight: bold;
       }
       
       .system-settings {
           padding: 2rem;
           max-width: 1200px;
           margin: 0 auto;
       }
       
       .settings-grid {
           display: grid;
           grid-template-columns: repeat(auto-fit, minmax(400px, 1fr));
           gap: 2rem;
           margin: 2rem 0;
       }
       
       .settings-card {
           background: white;
           border-radius: 1rem;
           box-shadow: 0 4px 15px rgba(0,0,0,0.1);
           overflow: hidden;
           transition: transform 0.3s ease;
       }
       
       .settings-card:hover {
           transform: translateY(-2px);
       }
       
       .card-header {
           background: linear-gradient(135deg, var(--admin-primary), var(--admin-secondary));
           color: white;
           padding: 1.5rem;
           display: flex;
           align-items: center;
           gap: 1rem;
       }
       
       .card-header h3 {
           margin: 0;
           font-size: 1.6rem;
       }
       
       .card-header i {
           font-size: 1.8rem;
       }
       
       .card-body {
           padding: 1.5rem;
       }
       
       .setting-item {
           margin-bottom: 1.5rem;
           padding-bottom: 1.5rem;
           border-bottom: 1px solid #eee;
       }
       
       .setting-item:last-child {
           border-bottom: none;
           margin-bottom: 0;
           padding-bottom: 0;
       }
       
       .setting-label {
           font-weight: bold;
           color: var(--admin-primary);
           margin-bottom: 0.5rem;
           display: block;
       }
       
       .setting-description {
           color: #7f8c8d;
           font-size: 1.1rem;
           margin-bottom: 1rem;
       }
       
       .setting-control {
           display: flex;
           align-items: center;
           gap: 1rem;
       }
       
       .form-input {
           flex: 1;
           padding: 0.8rem;
           border: 2px solid #ddd;
           border-radius: 0.5rem;
           font-size: 1.1rem;
           transition: border-color 0.3s ease;
       }
       
       .form-input:focus {
           outline: none;
           border-color: var(--admin-secondary);
       }
       
       .toggle-switch {
           position: relative;
           display: inline-block;
           width: 60px;
           height: 34px;
       }
       
       .toggle-switch input {
           opacity: 0;
           width: 0;
           height: 0;
       }
       
       .slider {
           position: absolute;
           cursor: pointer;
           top: 0;
           left: 0;
           right: 0;
           bottom: 0;
           background-color: #ccc;
           transition: .4s;
           border-radius: 34px;
       }
       
       .slider:before {
           position: absolute;
           content: "";
           height: 26px;
           width: 26px;
           left: 4px;
           bottom: 4px;
           background-color: white;
           transition: .4s;
           border-radius: 50%;
       }
       
       input:checked + .slider {
           background-color: var(--admin-success);
       }
       
       input:checked + .slider:before {
           transform: translateX(26px);
       }
       
       .btn-save {
           background: var(--admin-success);
           color: white;
           padding: 0.8rem 1.5rem;
           border: none;
           border-radius: 0.5rem;
           font-size: 1.1rem;
           cursor: pointer;
           transition: background 0.3s ease;
       }
       
       .btn-save:hover {
           background: #229954;
       }
       
       .btn-danger {
           background: var(--admin-danger);
           color: white;
           padding: 0.8rem 1.5rem;
           border: none;
           border-radius: 0.5rem;
           font-size: 1.1rem;
           cursor: pointer;
           transition: background 0.3s ease;
       }
       
       .btn-danger:hover {
           background: #c0392b;
       }
       
       .btn-secondary {
           background: #6c757d;
           color: white;
           padding: 0.8rem 1.5rem;
           border: none;
           border-radius: 0.5rem;
           font-size: 1.1rem;
           cursor: pointer;
           transition: background 0.3s ease;
       }
       
       .btn-secondary:hover {
           background: #545b62;
       }
       
       .info-section {
           background: #e3f2fd;
           border: 1px solid #90caf9;
           border-radius: 0.5rem;
           padding: 1rem;
           margin-bottom: 1.5rem;
       }
       
       .info-section h4 {
           margin: 0 0 0.5rem 0;
           color: var(--admin-secondary);
       }
       
       .info-section p {
           margin: 0;
           color: #1976d2;
       }
       
       .warning-section {
           background: #fff3cd;
           border: 1px solid #ffc107;
           border-radius: 0.5rem;
           padding: 1rem;
           margin-bottom: 1.5rem;
       }
       
       .warning-section h4 {
           margin: 0 0 0.5rem 0;
           color: var(--admin-warning);
       }
       
       .warning-section p {
           margin: 0;
           color: #856404;
       }
       
       .stats-item {
           display: flex;
           justify-content: space-between;
           align-items: center;
           padding: 0.8rem 0;
           border-bottom: 1px solid #eee;
       }
       
       .stats-item:last-child {
           border-bottom: none;
       }
       
       .stats-label {
           color: #7f8c8d;
       }
       
       .stats-value {
           font-weight: bold;
           color: var(--admin-primary);
       }
       
       .action-buttons {
           display: flex;
           gap: 1rem;
           margin-top: 1rem;
           flex-wrap: wrap;
       }
       
       @media (max-width: 768px) {
           .system-settings {
               padding: 1rem;
           }
           
           .settings-grid {
               grid-template-columns: 1fr;
           }
           
           .setting-control {
               flex-direction: column;
               align-items: stretch;
           }
           
           .action-buttons {
               flex-direction: column;
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
      <a href="systemSettings.aspx" class="active"><i class="fas fa-cog"></i><span>System Settings</span></a>
      <a href="loginWebform.aspx"><i class="fas fa-sign-out-alt"></i><span>Logout</span></a>
   </nav>
</div>

<section class="system-settings">
    <!-- Page Header -->
    <div style="margin-bottom: 2rem; text-align: center;">
        <h1 class="heading"><i class="fas fa-cog"></i> System Settings</h1>
        <p style="color: #7f8c8d; font-size: 1.4rem;">Configure system preferences and administrative options</p>
    </div>

    <!-- Settings Grid -->
    <div class="settings-grid">
        
        <!-- General Settings -->
        <div class="settings-card">
            <div class="card-header">
                <i class="fas fa-sliders-h"></i>
                <h3>General Settings</h3>
            </div>
            <div class="card-body">
                <div class="setting-item">
                    <label class="setting-label">System Name</label>
                    <p class="setting-description">The name displayed throughout the application</p>
                    <div class="setting-control">
                        <asp:TextBox ID="txtSystemName" runat="server" CssClass="form-input" placeholder="Bulb Learning Management System" />
                    </div>
                </div>
                
                <div class="setting-item">
                    <label class="setting-label">Maximum Assignment Points</label>
                    <p class="setting-description">Default maximum points for new assignments</p>
                    <div class="setting-control">
                        <asp:TextBox ID="txtMaxPoints" runat="server" CssClass="form-input" TextMode="Number" placeholder="100" min="1" max="1000" />
                    </div>
                </div>
                
                <div class="setting-item">
                    <label class="setting-label">Auto-Save Frequency</label>
                    <p class="setting-description">How often user progress is automatically saved (minutes)</p>
                    <div class="setting-control">
                        <asp:DropDownList ID="ddlAutoSave" runat="server" CssClass="form-input">
                            <asp:ListItem Text="5 minutes" Value="5" />
                            <asp:ListItem Text="10 minutes" Value="10" Selected="True" />
                            <asp:ListItem Text="15 minutes" Value="15" />
                            <asp:ListItem Text="30 minutes" Value="30" />
                            <asp:ListItem Text="Disabled" Value="0" />
                        </asp:DropDownList>
                    </div>
                </div>
                
                <div class="action-buttons">
                    <asp:Button ID="btnSaveGeneral" runat="server" Text="Save General Settings" CssClass="btn-save" OnClick="btnSaveGeneral_Click" />
                </div>
            </div>
        </div>

        <!-- User Management Settings -->
        <div class="settings-card">
            <div class="card-header">
                <i class="fas fa-users-cog"></i>
                <h3>User Management</h3>
            </div>
            <div class="card-body">
                <div class="setting-item">
                    <label class="setting-label">Allow Self Registration</label>
                    <p class="setting-description">Enable users to register accounts themselves</p>
                    <div class="setting-control">
                        <label class="toggle-switch">
                            <asp:CheckBox ID="chkSelfRegistration" runat="server" />
                            <span class="slider"></span>
                        </label>
                    </div>
                </div>
                
                <div class="setting-item">
                    <label class="setting-label">Default User Role</label>
                    <p class="setting-description">Default role assigned to new users</p>
                    <div class="setting-control">
                        <asp:DropDownList ID="ddlDefaultRole" runat="server" CssClass="form-input">
                            <asp:ListItem Text="Student" Value="Student" Selected="True" />
                            <asp:ListItem Text="Lecturer" Value="Lecturer" />
                        </asp:DropDownList>
                    </div>
                </div>
                
                <div class="setting-item">
                    <label class="setting-label">Password Minimum Length</label>
                    <p class="setting-description">Minimum characters required for passwords</p>
                    <div class="setting-control">
                        <asp:DropDownList ID="ddlPasswordLength" runat="server" CssClass="form-input">
                            <asp:ListItem Text="6 characters" Value="6" />
                            <asp:ListItem Text="8 characters" Value="8" Selected="True" />
                            <asp:ListItem Text="10 characters" Value="10" />
                            <asp:ListItem Text="12 characters" Value="12" />
                        </asp:DropDownList>
                    </div>
                </div>
                
                <div class="action-buttons">
                    <asp:Button ID="btnSaveUser" runat="server" Text="Save User Settings" CssClass="btn-save" OnClick="btnSaveUser_Click" />
                </div>
            </div>
        </div>

        <!-- Assignment Settings -->
        <div class="settings-card">
            <div class="card-header">
                <i class="fas fa-tasks"></i>
                <h3>Assignment Settings</h3>
            </div>
            <div class="card-body">
                <div class="setting-item">
                    <label class="setting-label">Late Submission Policy</label>
                    <p class="setting-description">Allow submissions after due date</p>
                    <div class="setting-control">
                        <label class="toggle-switch">
                            <asp:CheckBox ID="chkLateSubmissions" runat="server" />
                            <span class="slider"></span>
                        </label>
                    </div>
                </div>
                
                <div class="setting-item">
                    <label class="setting-label">Late Penalty (%)</label>
                    <p class="setting-description">Points deducted for late submissions per day</p>
                    <div class="setting-control">
                        <asp:TextBox ID="txtLatePenalty" runat="server" CssClass="form-input" TextMode="Number" placeholder="10" min="0" max="100" />
                    </div>
                </div>
                
                <div class="setting-item">
                    <label class="setting-label">Auto-Grade Submissions</label>
                    <p class="setting-description">Automatically assign full points to submitted assignments</p>
                    <div class="setting-control">
                        <label class="toggle-switch">
                            <asp:CheckBox ID="chkAutoGrade" runat="server" />
                            <span class="slider"></span>
                        </label>
                    </div>
                </div>
                
                <div class="action-buttons">
                    <asp:Button ID="btnSaveAssignment" runat="server" Text="Save Assignment Settings" CssClass="btn-save" OnClick="btnSaveAssignment_Click" />
                </div>
            </div>
        </div>

        <!-- System Information -->
        <div class="settings-card">
            <div class="card-header">
                <i class="fas fa-info-circle"></i>
                <h3>System Information</h3>
            </div>
            <div class="card-body">
                <div class="info-section">
                    <h4><i class="fas fa-server"></i> System Status</h4>
                    <p>All systems operational and running smoothly</p>
                </div>
                
                <div class="stats-item">
                    <span class="stats-label">System Version</span>
                    <span class="stats-value">Bulb LMS v1.0.0</span>
                </div>
                <div class="stats-item">
                    <span class="stats-label">Database Status</span>
                    <span class="stats-value" style="color: var(--admin-success);">Connected</span>
                </div>
                <div class="stats-item">
                    <span class="stats-label">Total Users</span>
                    <span class="stats-value"><asp:Label ID="lblSystemUsers" runat="server" Text="0"></asp:Label></span>
                </div>
                <div class="stats-item">
                    <span class="stats-label">Total Courses</span>
                    <span class="stats-value"><asp:Label ID="lblSystemCourses" runat="server" Text="0"></asp:Label></span>
                </div>
                <div class="stats-item">
                    <span class="stats-label">Total Assignments</span>
                    <span class="stats-value"><asp:Label ID="lblSystemAssignments" runat="server" Text="0"></asp:Label></span>
                </div>
                <div class="stats-item">
                    <span class="stats-label">Last Backup</span>
                    <span class="stats-value">Never</span>
                </div>
                
                <div class="action-buttons">
                    <asp:Button ID="btnRefreshStats" runat="server" Text="Refresh Statistics" CssClass="btn-secondary" OnClick="btnRefreshStats_Click" />
                </div>
            </div>
        </div>

        <!-- Data Management -->
        <div class="settings-card">
            <div class="card-header">
                <i class="fas fa-database"></i>
                <h3>Data Management</h3>
            </div>
            <div class="card-body">
                <div class="warning-section">
                    <h4><i class="fas fa-exclamation-triangle"></i> Danger Zone</h4>
                    <p>These actions are irreversible and should be used with extreme caution.</p>
                </div>
                
                <div class="setting-item">
                    <label class="setting-label">Clear Inactive Users</label>
                    <p class="setting-description">Remove users who haven't logged in for over 365 days</p>
                    <div class="action-buttons">
                        <asp:Button ID="btnClearInactive" runat="server" Text="Clear Inactive Users" CssClass="btn-secondary" 
                                  OnClick="btnClearInactive_Click" 
                                  OnClientClick="return confirm('This will permanently remove inactive users. Are you sure?');" />
                    </div>
                </div>
                
                <div class="setting-item">
                    <label class="setting-label">Reset System Data</label>
                    <p class="setting-description">Remove all assignments, submissions, and grades (keeps users and courses)</p>
                    <div class="action-buttons">
                        <asp:Button ID="btnResetAssignments" runat="server" Text="Reset Assignment Data" CssClass="btn-danger" 
                                  OnClick="btnResetAssignments_Click" 
                                  OnClientClick="return confirm('This will permanently delete all assignment data. Are you absolutely sure?');" />
                    </div>
                </div>
                
                <div class="setting-item">
                    <label class="setting-label">Export System Data</label>
                    <p class="setting-description">Download a backup of all system data</p>
                    <div class="action-buttons">
                        <asp:Button ID="btnExportData" runat="server" Text="Export All Data" CssClass="btn-secondary" OnClick="btnExportData_Click" />
                    </div>
                </div>
            </div>
        </div>

        <!-- Notification Settings -->
        <div class="settings-card">
            <div class="card-header">
                <i class="fas fa-bell"></i>
                <h3>Notification Settings</h3>
            </div>
            <div class="card-body">
                <div class="setting-item">
                    <label class="setting-label">Email Notifications</label>
                    <p class="setting-description">Send email notifications for important events</p>
                    <div class="setting-control">
                        <label class="toggle-switch">
                            <asp:CheckBox ID="chkEmailNotifications" runat="server" />
                            <span class="slider"></span>
                        </label>
                    </div>
                </div>
                
                <div class="setting-item">
                    <label class="setting-label">Assignment Due Reminders</label>
                    <p class="setting-description">Days before due date to send reminders</p>
                    <div class="setting-control">
                        <asp:DropDownList ID="ddlDueReminders" runat="server" CssClass="form-input">
                            <asp:ListItem Text="1 day before" Value="1" />
                            <asp:ListItem Text="2 days before" Value="2" />
                            <asp:ListItem Text="3 days before" Value="3" Selected="True" />
                            <asp:ListItem Text="7 days before" Value="7" />
                            <asp:ListItem Text="Disabled" Value="0" />
                        </asp:DropDownList>
                    </div>
                </div>
                
                <div class="setting-item">
                    <label class="setting-label">Grade Notifications</label>
                    <p class="setting-description">Notify students when assignments are graded</p>
                    <div class="setting-control">
                        <label class="toggle-switch">
                            <asp:CheckBox ID="chkGradeNotifications" runat="server" />
                            <span class="slider"></span>
                        </label>
                    </div>
                </div>
                
                <div class="action-buttons">
                    <asp:Button ID="btnSaveNotifications" runat="server" Text="Save Notification Settings" CssClass="btn-save" OnClick="btnSaveNotifications_Click" />
                </div>
            </div>
        </div>
    </div>

    <!-- Messages -->
    <asp:Label ID="lblMessage" runat="server" Text="" style="display: block; margin: 2rem 0; text-align: center; font-size: 1.2rem;"></asp:Label>
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
    }
</script>

    </form>
</body>
</html>