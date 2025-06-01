<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="teacherSettings.aspx.cs" Inherits="assignmentDraft1.teacherSettings" %>

<!DOCTYPE html>
<html lang="en">
<head>
   <meta charset="UTF-8">
   <meta http-equiv="X-UA-Compatible" content="IE=edge">
   <meta name="viewport" content="width=device-width, initial-scale=1.0">
   <title>Teacher Settings - Bulb LMS</title>
   <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.1.2/css/all.min.css">
   <link rel="stylesheet" href="css/style.css">
   
   <style>
       :root {
           --teacher-primary: #1a5276;
           --teacher-secondary: #3498db;
           --teacher-success: #27ae60;
           --teacher-warning: #f39c12;
           --teacher-danger: #e74c3c;
           --teacher-light: #ecf0f1;
           --teacher-purple: #9b59b6;
       }
       
       .teacher-header {
           background: linear-gradient(135deg, var(--teacher-primary), var(--teacher-secondary));
           color: white;
       }
       
       .teacher-header .logo {
           color: white;
           font-weight: bold;
       }
       
       .teacher-settings {
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
           background: linear-gradient(135deg, var(--teacher-primary), var(--teacher-secondary));
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
           color: var(--teacher-primary);
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
           border-color: var(--teacher-secondary);
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
           background-color: var(--teacher-success);
       }
       
       input:checked + .slider:before {
           transform: translateX(26px);
       }
       
       .btn-save {
           background: var(--teacher-success);
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
       
       .action-buttons {
           display: flex;
           gap: 1rem;
           margin-top: 1rem;
           flex-wrap: wrap;
       }
       
       @media (max-width: 768px) {
           .teacher-settings {
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

<header class="header teacher-header">
   <section class="flex">
      <a href="teacherDashboard.aspx" class="logo">
          <i class="fas fa-chalkboard-teacher"></i> Bulb Teacher
      </a>
      
      <div class="icons">
         <div id="menu-btn" class="fas fa-bars"></div>
         <div id="user-btn" class="fas fa-user"></div>
         <div id="toggle-btn" class="fas fa-sun"></div>
      </div>

      <div class="profile">
         <img src="images/pic-1.jpg" class="image" alt="">
         <h3 class="name"><asp:Label ID="lblName" runat="server" Text=""></asp:Label></h3>
         <p class="role"><asp:Label ID="lblRole" runat="server" Text="lecturer"></asp:Label></p>
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
      <p class="role"><asp:Label ID="lblSidebarRole" runat="server" Text="lecturer"></asp:Label></p>
      <a href="profile.aspx" class="btn">view profile</a>
   </div>
   <nav class="navbar">
      <a href="TeacherWebform.aspx"><i class="fas fa-home"></i><span>Dashboard</span></a>
      <a href="assignments.aspx"><i class="fas fa-tasks"></i><span>Assignments</span></a>
      <a href="teacherSettings.aspx" class="active"><i class="fas fa-cog"></i><span>Settings</span></a>
      <a href="loginWebform.aspx"><i class="fas fa-sign-out-alt"></i><span>Logout</span></a>
   </nav>
</div>

<section class="teacher-settings">
    <!-- Page Header -->
    <div style="margin-bottom: 2rem; text-align: center;">
        <h1 class="heading"><i class="fas fa-cog"></i> Teacher Settings</h1>
        <p style="color: #7f8c8d; font-size: 1.4rem;">Customize your teaching preferences and account settings</p>
    </div>

    <!-- Settings Grid -->
    <div class="settings-grid">
        
        <!-- Account Settings -->
        <div class="settings-card">
            <div class="card-header">
                <i class="fas fa-user-shield"></i>
                <h3>Account Settings</h3>
            </div>
            <div class="card-body">
                <div class="setting-item">
                    <label class="setting-label">Change Password</label>
                    <p class="setting-description">Update your account password</p>
                    <div class="setting-control">
                        <asp:TextBox ID="txtCurrentPassword" runat="server" CssClass="form-input" TextMode="Password" placeholder="Current Password" />
                    </div>
                    <div class="setting-control" style="margin-top: 10px;">
                        <asp:TextBox ID="txtNewPassword" runat="server" CssClass="form-input" TextMode="Password" placeholder="New Password" />
                    </div>
                    <div class="setting-control" style="margin-top: 10px;">
                        <asp:TextBox ID="txtConfirmPassword" runat="server" CssClass="form-input" TextMode="Password" placeholder="Confirm New Password" />
                    </div>
                </div>
                
                <div class="setting-item">
                    <label class="setting-label">Contact Information</label>
                    <p class="setting-description">Update your contact details</p>
                    <div class="setting-control">
                        <asp:TextBox ID="txtPhone" runat="server" CssClass="form-input" placeholder="Phone Number" />
                    </div>
                </div>
                
                <div class="action-buttons">
                    <asp:Button ID="btnSaveAccount" runat="server" Text="Save Account Settings" CssClass="btn-save" OnClick="btnSaveAccount_Click" />
                </div>
            </div>
        </div>

        <!-- Notification Preferences -->
        <div class="settings-card">
            <div class="card-header">
                <i class="fas fa-bell"></i>
                <h3>Notification Preferences</h3>
            </div>
            <div class="card-body">
                <div class="setting-item">
                    <label class="setting-label">Email Notifications</label>
                    <p class="setting-description">Receive important updates via email</p>
                    <div class="setting-control">
                        <label class="toggle-switch">
                            <asp:CheckBox ID="chkEmailNotifications" runat="server" />
                            <span class="slider"></span>
                        </label>
                    </div>
                </div>
                
                <div class="setting-item">
                    <label class="setting-label">SMS Notifications</label>
                    <p class="setting-description">Receive important updates via SMS</p>
                    <div class="setting-control">
                        <label class="toggle-switch">
                            <asp:CheckBox ID="chkSmsNotifications" runat="server" />
                            <span class="slider"></span>
                        </label>
                    </div>
                </div>
                
                <div class="setting-item">
                    <label class="setting-label">Assignment Submissions</label>
                    <p class="setting-description">Get notified when students submit assignments</p>
                    <div class="setting-control">
                        <label class="toggle-switch">
                            <asp:CheckBox ID="chkSubmissionNotifications" runat="server" Checked="true" />
                            <span class="slider"></span>
                        </label>
                    </div>
                </div>
                
                <div class="action-buttons">
                    <asp:Button ID="btnSaveNotifications" runat="server" Text="Save Notification Settings" CssClass="btn-save" OnClick="btnSaveNotifications_Click" />
                </div>
            </div>
        </div>

        <!-- Teaching Preferences -->
        <div class="settings-card">
            <div class="card-header">
                <i class="fas fa-chalkboard"></i>
                <h3>Teaching Preferences</h3>
            </div>
            <div class="card-body">
                <div class="setting-item">
                    <label class="setting-label">Default Assignment Due Time</label>
                    <p class="setting-description">Default time of day for assignment deadlines</p>
                    <div class="setting-control">
                        <asp:DropDownList ID="ddlDefaultDueTime" runat="server" CssClass="form-input">
                            <asp:ListItem Text="8:00 AM" Value="08:00" />
                            <asp:ListItem Text="12:00 PM" Value="12:00" />
                            <asp:ListItem Text="5:00 PM" Value="17:00" Selected="True" />
                            <asp:ListItem Text="11:59 PM" Value="23:59" />
                        </asp:DropDownList>
                    </div>
                </div>
                
                <div class="setting-item">
                    <label class="setting-label">Late Submission Policy</label>
                    <p class="setting-description">How to handle late submissions</p>
                    <div class="setting-control">
                        <asp:DropDownList ID="ddlLatePolicy" runat="server" CssClass="form-input">
                            <asp:ListItem Text="Accept with penalty" Value="penalty" Selected="True" />
                            <asp:ListItem Text="Accept without penalty" Value="no_penalty" />
                            <asp:ListItem Text="Don't accept late submissions" Value="no_late" />
                        </asp:DropDownList>
                    </div>
                </div>
                
                <div class="setting-item">
                    <label class="setting-label">Late Penalty (%)</label>
                    <p class="setting-description">Percentage deduction per day for late submissions</p>
                    <div class="setting-control">
                        <asp:TextBox ID="txtLatePenalty" runat="server" CssClass="form-input" TextMode="Number" placeholder="10" min="0" max="100" />
                    </div>
                </div>
                
                <div class="action-buttons">
                    <asp:Button ID="btnSaveTeaching" runat="server" Text="Save Teaching Preferences" CssClass="btn-save" OnClick="btnSaveTeaching_Click" />
                </div>
            </div>
        </div>

        <!-- Profile Display -->
        <div class="settings-card">
            <div class="card-header">
                <i class="fas fa-id-card"></i>
                <h3>Profile Display</h3>
            </div>
            <div class="card-body">
                <div class="setting-item">
                    <label class="setting-label">Display Full Name to Students</label>
                    <p class="setting-description">Show your full name to enrolled students</p>
                    <div class="setting-control">
                        <label class="toggle-switch">
                            <asp:CheckBox ID="chkDisplayFullName" runat="server" Checked="true" />
                            <span class="slider"></span>
                        </label>
                    </div>
                </div>
                
                <div class="setting-item">
                    <label class="setting-label">Display Contact Information</label>
                    <p class="setting-description">Make your contact information visible to students</p>
                    <div class="setting-control">
                        <label class="toggle-switch">
                            <asp:CheckBox ID="chkDisplayContact" runat="server" Checked="true" />
                            <span class="slider"></span>
                        </label>
                    </div>
                </div>
                
                <div class="setting-item">
                    <label class="setting-label">Profile Bio</label>
                    <p class="setting-description">Short description visible on your profile</p>
                    <div class="setting-control">
                        <asp:TextBox ID="txtProfileBio" runat="server" CssClass="form-input" TextMode="MultiLine" Rows="3" placeholder="Enter a brief professional bio..." />
                    </div>
                </div>
                
                <div class="action-buttons">
                    <asp:Button ID="btnSaveProfile" runat="server" Text="Save Profile Settings" CssClass="btn-save" OnClick="btnSaveProfile_Click" />
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
