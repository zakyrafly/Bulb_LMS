<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="profile.aspx.cs" Inherits="assignmentDraft1.profile" %>

<!DOCTYPE html>
<html lang="en">
<head>
   <meta charset="UTF-8">
   <meta http-equiv="X-UA-Compatible" content="IE=edge">
   <meta name="viewport" content="width=device-width, initial-scale=1.0">
   <title>My Profile - Bulb LMS</title>
   <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.1.2/css/all.min.css">
   <link rel="stylesheet" href="css/style.css">
   
   <style>
       .profile-container {
           padding: 2rem;
           max-width: 1200px;
           margin: 0 auto;
       }
       
       .profile-header {
           background: linear-gradient(135deg, var(--main-color), var(--secondary-color, #3498db));
           color: white;
           border-radius: 1rem;
           padding: 2rem;
           margin-bottom: 2rem;
           box-shadow: 0 4px 15px rgba(0,0,0,0.1);
       }
       
       .profile-info {
           display: flex;
           align-items: center;
           gap: 2rem;
           flex-wrap: wrap;
       }
       
       .profile-avatar {
           width: 120px;
           height: 120px;
           border-radius: 50%;
           border: 4px solid white;
           object-fit: cover;
           box-shadow: 0 4px 15px rgba(0,0,0,0.2);
       }
       
       .profile-details h1 {
           margin: 0 0 0.5rem 0;
           font-size: 2.5rem;
       }
       
       .profile-details p {
           margin: 0.3rem 0;
           opacity: 0.9;
           font-size: 1.3rem;
       }
       
       .profile-badge {
           display: inline-block;
           padding: 0.5rem 1rem;
           background: rgba(255,255,255,0.2);
           border-radius: 2rem;
           font-weight: bold;
           margin-top: 0.5rem;
       }
       
       .profile-content {
           display: grid;
           grid-template-columns: 1fr 1fr;
           gap: 2rem;
           margin-bottom: 2rem;
       }
       
       .profile-card {
           background: white;
           border-radius: 1rem;
           box-shadow: 0 4px 15px rgba(0,0,0,0.1);
           overflow: hidden;
       }
       
       .card-header {
           background: var(--light-bg);
           padding: 1.5rem;
           border-bottom: 1px solid #eee;
       }
       
       .card-header h3 {
           margin: 0;
           color: var(--black);
           display: flex;
           align-items: center;
           gap: 0.5rem;
           font-size: 1.6rem;
       }
       
       .card-body {
           padding: 1.5rem;
       }
       
       .info-item {
           display: flex;
           justify-content: space-between;
           align-items: center;
           padding: 1rem 0;
           border-bottom: 1px solid #f0f0f0;
       }
       
       .info-item:last-child {
           border-bottom: none;
       }
       
       .info-label {
           font-weight: bold;
           color: var(--light-color);
       }
       
       .info-value {
           color: var(--black);
           font-size: 1.2rem;
       }
       
       .course-list {
           display: grid;
           gap: 1rem;
       }
       
       .course-item {
           display: flex;
           align-items: center;
           justify-content: space-between;
           padding: 1rem;
           background: var(--light-bg);
           border-radius: 0.5rem;
           border-left: 4px solid var(--main-color);
       }
       
       .course-info h4 {
           margin: 0;
           color: var(--black);
       }
       
       .course-info p {
           margin: 0.3rem 0 0 0;
           color: var(--light-color);
           font-size: 1.1rem;
       }
       
       .course-stats {
           text-align: center;
           color: var(--main-color);
           font-weight: bold;
       }
       
       .stats-grid {
           display: grid;
           grid-template-columns: repeat(auto-fit, minmax(150px, 1fr));
           gap: 1rem;
           margin: 1rem 0;
       }
       
       .stat-item {
           text-align: center;
           padding: 1rem;
           background: var(--light-bg);
           border-radius: 0.5rem;
       }
       
       .stat-number {
           font-size: 2rem;
           font-weight: bold;
           color: var(--main-color);
           display: block;
       }
       
       .stat-label {
           color: var(--light-color);
           font-size: 1.1rem;
           margin-top: 0.3rem;
       }
       
       .edit-form {
           display: none;
           margin-top: 1rem;
       }
       
       .edit-form.active {
           display: block;
       }
       
       .form-group {
           margin-bottom: 1.5rem;
       }
       
       .form-group label {
           display: block;
           margin-bottom: 0.5rem;
           font-weight: bold;
           color: var(--black);
       }
       
       .form-actions {
           display: flex;
           gap: 1rem;
           margin-top: 1.5rem;
       }
       
       .password-form {
           margin-top: 1rem;
       }
       
       .password-requirements {
           background: #f8f9fa;
           padding: 1rem;
           border-radius: 0.5rem;
           margin: 1rem 0;
           font-size: 1.1rem;
           color: #6c757d;
       }
       
       .recent-activity {
           grid-column: 1 / -1;
       }
       
       .activity-list {
           max-height: 300px;
           overflow-y: auto;
       }
       
       .activity-item {
           display: flex;
           align-items: center;
           gap: 1rem;
           padding: 1rem 0;
           border-bottom: 1px solid #f0f0f0;
       }
       
       .activity-item:last-child {
           border-bottom: none;
       }
       
       .activity-icon {
           width: 40px;
           height: 40px;
           border-radius: 50%;
           display: flex;
           align-items: center;
           justify-content: center;
           font-size: 1.2rem;
           color: white;
       }
       
       .activity-icon.assignment { background: var(--main-color); }
       .activity-icon.grade { background: #28a745; }
       .activity-icon.course { background: #17a2b8; }
       .activity-icon.login { background: #6c757d; }
       
       .activity-content h4 {
           margin: 0;
           color: var(--black);
           font-size: 1.3rem;
       }
       
       .activity-content p {
           margin: 0.3rem 0 0 0;
           color: var(--light-color);
           font-size: 1.1rem;
       }
       
       .activity-time {
           color: var(--light-color);
           font-size: 1rem;
           margin-left: auto;
       }
       
       @media (max-width: 768px) {
           .profile-container {
               padding: 1rem;
           }
           
           .profile-content {
               grid-template-columns: 1fr;
           }
           
           .profile-info {
               text-align: center;
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

<header class="header">
   <section class="flex">
      <a href="teacherWebform.aspx" class="logo">Bulb</a>
      
      <asp:Panel runat="server" CssClass="search-form">
          <asp:TextBox ID="txtSearch" runat="server" CssClass="search-input" placeholder="Search..." MaxLength="100" />
          <asp:LinkButton ID="btnSearch" runat="server" CssClass="inline-btn search-btn" OnClick="btnSearch_Click">
              <i class="fas fa-search"></i>
          </asp:LinkButton>
      </asp:Panel>

      <div class="icons">
         <div id="menu-btn" class="fas fa-bars"></div>
         <div id="search-btn" class="fas fa-search"></div>
         <div id="user-btn" class="fas fa-user"></div>
         <div id="toggle-btn" class="fas fa-sun"></div>
      </div>

      <div class="profile">
         <img src="images/pic-1.jpg" class="image" alt="">
         <h3 class="name"><asp:Label ID="lblHeaderName" runat="server" Text=""></asp:Label></h3>
         <p class="role"><asp:Label ID="lblHeaderRole" runat="server" Text=""></asp:Label></p>
         <a href="profile.aspx" class="btn">view profile</a>
         <div class="flex-btn">
            <a href="logout.aspx" class="option-btn">logout</a>
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
      <h3 class="name"><asp:Label ID="lblSidebarName" runat="server" Text="Student Name"></asp:Label></h3>
      <p class="role"><asp:Label ID="lblSidebarRole" runat="server" Text="student"></asp:Label></p>
      <a href="profile.aspx" class="btn">view profile</a>
   </div>

    <nav class="navbar">
          <a href="homeWebform.aspx" class="active"><i class="fas fa-home"></i><span>Home</span></a>
          <a href="studentLessons.aspx"><i class="fas fa-graduation-cap"></i><span>My Courses</span></a>
          <a href="student-assignments.aspx"><i class="fas fa-tasks"></i><span>Assignments</span></a>
          <a href="calendar.aspx"><i class="fas fa-calendar"></i><span>Calendar</span></a>
          <a href="profile.aspx"><i class="fas fa-user"></i><span>Profile</span></a>
          <a href="loginWebform.aspx"><i class="fas fa-sign-out-alt"></i><span>Logout</span></a>
       </nav>
</div>

<section class="profile-container">
    <!-- Profile Header -->
    <div class="profile-header">
        <div class="profile-info">
            <img src="images/pic-1.jpg" alt="Profile Picture" class="profile-avatar">
            <div class="profile-details">
                <h1><asp:Label ID="lblProfileName" runat="server" Text=""></asp:Label></h1>
                <p><i class="fas fa-envelope"></i> <asp:Label ID="lblProfileEmail" runat="server" Text=""></asp:Label></p>
                <p><i class="fas fa-calendar"></i> Member since <asp:Label ID="lblMemberSince" runat="server" Text=""></asp:Label></p>
                <span class="profile-badge">
                    <i class="fas fa-user"></i> <asp:Label ID="lblProfileRole" runat="server" Text=""></asp:Label>
                </span>
            </div>
        </div>
    </div>

    <!-- Profile Content -->
    <div class="profile-content">
        
        <!-- Personal Information -->
        <div class="profile-card">
            <div class="card-header">
                <h3><i class="fas fa-user"></i> Personal Information</h3>
                <asp:LinkButton ID="btnEditProfile" runat="server" CssClass="option-btn" OnClick="btnEditProfile_Click">
                    <i class="fas fa-edit"></i> Edit
                </asp:LinkButton>
            </div>
            <div class="card-body">
                <div id="profileView" runat="server">
                    <div class="info-item">
                        <span class="info-label">Full Name:</span>
                        <span class="info-value"><asp:Label ID="lblFullName" runat="server" Text=""></asp:Label></span>
                    </div>
                    <div class="info-item">
                        <span class="info-label">Email:</span>
                        <span class="info-value"><asp:Label ID="lblEmail" runat="server" Text=""></asp:Label></span>
                    </div>
                    <div class="info-item">
                        <span class="info-label">Role:</span>
                        <span class="info-value"><asp:Label ID="lblRole" runat="server" Text=""></asp:Label></span>
                    </div>
                    <div class="info-item">
                        <span class="info-label">Contact Info:</span>
                        <span class="info-value"><asp:Label ID="lblContactInfo" runat="server" Text="Not provided"></asp:Label></span>
                    </div>
                </div>
                
                <div id="profileEdit" runat="server" class="edit-form">
                    <div class="form-group">
                        <label>Full Name</label>
                        <asp:TextBox ID="txtEditName" runat="server" CssClass="box" MaxLength="100"></asp:TextBox>
                    </div>
                    <div class="form-group">
                        <label>Contact Info</label>
                        <asp:TextBox ID="txtEditContact" runat="server" CssClass="box" TextMode="MultiLine" Rows="3"></asp:TextBox>
                    </div>
                    <div class="form-actions">
                        <asp:Button ID="btnSaveProfile" runat="server" Text="Save Changes" CssClass="btn" OnClick="btnSaveProfile_Click" />
                        <asp:Button ID="btnCancelEdit" runat="server" Text="Cancel" CssClass="option-btn" OnClick="btnCancelEdit_Click" />
                    </div>
                </div>
            </div>
        </div>

        <!-- Change Password -->
        <div class="profile-card">
            <div class="card-header">
                <h3><i class="fas fa-lock"></i> Security</h3>
                <asp:LinkButton ID="btnChangePassword" runat="server" CssClass="option-btn" OnClick="btnChangePassword_Click">
                    <i class="fas fa-key"></i> Change Password
                </asp:LinkButton>
            </div>
            <div class="card-body">
                <div id="passwordView" runat="server">
                    <div class="info-item">
                        <span class="info-label">Password:</span>
                        <span class="info-value">••••••••</span>
                    </div>
                    <div class="info-item">
                        <span class="info-label">Last Changed:</span>
                        <span class="info-value">Recently</span>
                    </div>
                </div>
                
                <div id="passwordEdit" runat="server" class="edit-form">
                    <div class="form-group">
                        <label>Current Password</label>
                        <asp:TextBox ID="txtCurrentPassword" runat="server" CssClass="box" TextMode="Password"></asp:TextBox>
                    </div>
                    <div class="form-group">
                        <label>New Password</label>
                        <asp:TextBox ID="txtNewPassword" runat="server" CssClass="box" TextMode="Password"></asp:TextBox>
                    </div>
                    <div class="form-group">
                        <label>Confirm New Password</label>
                        <asp:TextBox ID="txtConfirmPassword" runat="server" CssClass="box" TextMode="Password"></asp:TextBox>
                    </div>
                    <div class="password-requirements">
                        <strong>Password Requirements:</strong><br>
                        • At least 6 characters long<br>
                        • Use a strong, unique password
                    </div>
                    <div class="form-actions">
                        <asp:Button ID="btnSavePassword" runat="server" Text="Update Password" CssClass="btn" OnClick="btnSavePassword_Click" />
                        <asp:Button ID="btnCancelPassword" runat="server" Text="Cancel" CssClass="option-btn" OnClick="btnCancelPassword_Click" />
                    </div>
                </div>
            </div>
        </div>

        <!-- Role-specific Information -->
        <asp:Panel ID="pnlRoleSpecific" runat="server" CssClass="profile-card">
            <div class="card-header">
                <h3><i class="fas fa-graduation-cap"></i> <asp:Label ID="lblRoleSpecificTitle" runat="server" Text="Academic Information"></asp:Label></h3>
            </div>
            <div class="card-body">
                <!-- Student Information -->
                <asp:Panel ID="pnlStudentInfo" runat="server" Visible="false">
                    <div class="stats-grid">
                        <div class="stat-item">
                            <span class="stat-number"><asp:Label ID="lblAssignmentCount" runat="server" Text="0"></asp:Label></span>
                            <div class="stat-label">Assignments</div>
                        </div>
                        <div class="stat-item">
                            <span class="stat-number"><asp:Label ID="lblCompletedCount" runat="server" Text="0"></asp:Label></span>
                            <div class="stat-label">Completed</div>
                        </div>
                        <div class="stat-item">
                            <span class="stat-number"><asp:Label ID="lblAverageGrade" runat="server" Text="0%"></asp:Label></span>
                            <div class="stat-label">Avg Grade</div>
                        </div>
                    </div>
                    
                    <h4 style="margin: 1.5rem 0 1rem 0;">Enrolled Courses</h4>
                    <div class="course-list">
                        <asp:Repeater ID="studentCoursesRepeater" runat="server">
                            <ItemTemplate>
                                <div class="course-item">
                                    <div class="course-info">
                                        <h4><%# Eval("CourseName") %></h4>
                                        <p><%# Eval("Description") %></p>
                                    </div>
                                    <div class="course-stats">
                                        <div><%# Eval("ModuleCount") %> Modules</div>
                                    </div>
                                </div>
                            </ItemTemplate>
                        </asp:Repeater>
                    </div>
                </asp:Panel>

                <!-- Lecturer Information -->
                <asp:Panel ID="pnlLecturerInfo" runat="server" Visible="false">
                    <div class="stats-grid">
                        <div class="stat-item">
                            <span class="stat-number"><asp:Label ID="lblModuleCount" runat="server" Text="0"></asp:Label></span>
                            <div class="stat-label">Modules</div>
                        </div>
                        <div class="stat-item">
                            <span class="stat-number">-</span>
                            <div class="stat-label">Students</div>
                        </div>
                        <div class="stat-item">
                            <span class="stat-number">-</span>
                            <div class="stat-label">Assignments</div>
                        </div>
                    </div>
    
                    <div style="text-align: center; margin-top: 2rem; padding: 2rem; background: var(--light-bg); border-radius: 0.5rem;">
                        <i class="fas fa-chalkboard-teacher" style="font-size: 3rem; color: var(--main-color); margin-bottom: 1rem;"></i>
                        <h4 style="margin-bottom: 0.5rem; color: var(--black);">Teaching Dashboard</h4>
                        <p style="color: var(--light-color); margin-bottom: 1.5rem;">Manage your courses and assignments</p>
                        <a href="teacherWebform.aspx" class="btn" style="display: inline-block; text-decoration: none;">
                            <i class="fas fa-arrow-right"></i> Go to Teaching Dashboard
                        </a>
                    </div>
                </asp:Panel>

                <!-- Admin Information -->
                <asp:Panel ID="pnlAdminInfo" runat="server" Visible="false">
                    <div class="stats-grid">
                        <div class="stat-item">
                            <span class="stat-number"><asp:Label ID="lblTotalUsers" runat="server" Text="0"></asp:Label></span>
                            <div class="stat-label">Total Users</div>
                        </div>
                        <div class="stat-item">
                            <span class="stat-number"><asp:Label ID="lblTotalCourses" runat="server" Text="0"></asp:Label></span>
                            <div class="stat-label">Courses</div>
                        </div>
                        <div class="stat-item">
                            <span class="stat-number"><asp:Label ID="lblSystemHealth" runat="server" Text="98%"></asp:Label></span>
                            <div class="stat-label">System Health</div>
                        </div>
                    </div>
                    
                    <div style="text-align: center; margin-top: 2rem;">
                        <a href="adminDashboard.aspx" class="btn">
                            <i class="fas fa-tachometer-alt"></i> Go to Admin Dashboard
                        </a>
                    </div>
                </asp:Panel>
            </div>
        </asp:Panel>

        <!-- Recent Activity -->
        <div class="profile-card recent-activity">
            <div class="card-header">
                <h3><i class="fas fa-clock"></i> Recent Activity</h3>
            </div>
            <div class="card-body">
                <div class="activity-list">
                    <asp:Repeater ID="activityRepeater" runat="server">
                        <ItemTemplate>
                            <div class="activity-item">
                                <div class="activity-icon <%# Eval("ActivityType").ToString().ToLower() %>">
                                    <i class="fas <%# ((assignmentDraft1.profile)Page).GetActivityIcon(Eval("ActivityType")) %>"></i>
                                </div>
                                <div class="activity-content">
                                    <h4><%# Eval("ActivityTitle") %></h4>
                                    <p><%# Eval("ActivityDescription") %></p>
                                </div>
                                <div class="activity-time">
                                    <%# Eval("ActivityTime", "{0:MMM dd, HH:mm}") %>
                                </div>
                            </div>
                        </ItemTemplate>
                    </asp:Repeater>
                    
                    <asp:Panel ID="pnlNoActivity" runat="server" Visible="false" style="text-align: center; padding: 2rem; color: var(--light-color);">
                        <i class="fas fa-clock" style="font-size: 3rem; margin-bottom: 1rem; opacity: 0.3;"></i>
                        <p>No recent activity to display</p>
                    </asp:Panel>
                </div>
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
            setTimeout(function () {
                messageLabel.style.display = 'none';
            }, 5000);
        }
    }
</script>

    </form>
</body>
</html>