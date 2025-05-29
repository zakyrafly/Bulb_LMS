<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="adminDashboard.aspx.cs" Inherits="assignmentDraft1.adminDashboard" %>

<!DOCTYPE html>
<html lang="en">
<head>
   <meta charset="UTF-8">
   <meta http-equiv="X-UA-Compatible" content="IE=edge">
   <meta name="viewport" content="width=device-width, initial-scale=1.0">
   <title>Admin Dashboard - Bulb LMS</title>
   <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.1.2/css/all.min.css">
   <link rel="stylesheet" href="css/style.css">
   
</head>
<body>
    <form id="form1" runat="server">

<header class="header admin-header">
   <section class="flex">
      <a href="adminDashboard.aspx" class="logo">
          <i class="fas fa-shield-alt"></i> Bulb Admin
      </a>
      
      <asp:Panel runat="server" CssClass="search-form">
          <asp:TextBox ID="txtSearch" runat="server" CssClass="search-input" placeholder="Search users, courses..." MaxLength="100" />
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
      <a href="adminDashboard.aspx" class="active"><i class="fas fa-tachometer-alt"></i><span>Dashboard</span></a>
      <a href="manageUsers.aspx"><i class="fas fa-users"></i><span>User Management</span></a>
      <a href="manageCourses.aspx"><i class="fas fa-graduation-cap"></i><span>Course Management</span></a>
      <a href="manageAssignments.aspx"><i class="fas fa-tasks"></i><span>Assignment Oversight</span></a>
      <a href="systemReports.aspx"><i class="fas fa-chart-line"></i><span>Reports & Analytics</span></a>
      <a href="systemSettings.aspx"><i class="fas fa-cog"></i><span>System Settings</span></a>
      <a href="loginWebform.aspx"><i class="fas fa-sign-out-alt"></i><span>Logout</span></a>
   </nav>
</div>

<section class="course-content">
    <!-- Page Header -->
    <div style="margin-bottom: 2rem;">
        <h1 class="heading"><i class="fas fa-tachometer-alt"></i> Admin Dashboard</h1>
        <p style="color: #7f8c8d; font-size: 1.4rem;">Welcome to the Bulb LMS Administration Panel</p>
    </div>

    <!-- System Statistics -->
    <div class="admin-stats">
        <div class="stat-card success">
            <div class="stat-header">
                <div>
                    <div class="stat-label">Total Users</div>
                    <div class="stat-number"><asp:Label ID="lblTotalUsers" runat="server" Text="0"></asp:Label></div>
                </div>
                <i class="fas fa-users stat-icon" style="color: var(--admin-success);"></i>
            </div>
            <div class="stat-change positive">
                <i class="fas fa-arrow-up"></i> <asp:Label ID="lblUserChange" runat="server" Text="+12%"></asp:Label> this month
            </div>
        </div>

        <div class="stat-card">
            <div class="stat-header">
                <div>
                    <div class="stat-label">Total Courses</div>
                    <div class="stat-number"><asp:Label ID="lblTotalCourses" runat="server" Text="0"></asp:Label></div>
                </div>
                <i class="fas fa-graduation-cap stat-icon" style="color: var(--admin-secondary);"></i>
            </div>
            <div class="stat-change positive">
                <i class="fas fa-arrow-up"></i> <asp:Label ID="lblCourseChange" runat="server" Text="+5%"></asp:Label> this month
            </div>
        </div>

        <div class="stat-card warning">
            <div class="stat-header">
                <div>
                    <div class="stat-label">Active Assignments</div>
                    <div class="stat-number"><asp:Label ID="lblActiveAssignments" runat="server" Text="0"></asp:Label></div>
                </div>
                <i class="fas fa-tasks stat-icon" style="color: var(--admin-warning);"></i>
            </div>
            <div class="stat-change positive">
                <i class="fas fa-arrow-up"></i> <asp:Label ID="lblAssignmentChange" runat="server" Text="+8%"></asp:Label> this week
            </div>
        </div>

        <div class="stat-card danger">
            <div class="stat-header">
                <div>
                    <div class="stat-label">Pending Grades</div>
                    <div class="stat-number"><asp:Label ID="lblPendingGrades" runat="server" Text="0"></asp:Label></div>
                </div>
                <i class="fas fa-clock stat-icon" style="color: var(--admin-danger);"></i>
            </div>
            <div class="stat-change negative">
                <i class="fas fa-exclamation-triangle"></i> Needs attention
            </div>
        </div>
    </div>

    <!-- Quick Navigation -->
    <h2 class="heading">Quick Actions</h2>
    <div class="admin-nav">
        <a href="manageUsers.aspx" class="nav-card">
            <i class="fas fa-user-plus"></i>
            <h3>User Management</h3>
            <p>Add, edit, and manage user accounts</p>
        </a>

        <a href="manageCourses.aspx" class="nav-card">
            <i class="fas fa-book-open"></i>
            <h3>Course Management</h3>
            <p>Manage courses and enrollments</p>
        </a>

        <a href="manageAssignments.aspx" class="nav-card">
            <i class="fas fa-clipboard-list"></i>
            <h3>Assignment Oversight</h3>
            <p>Monitor assignments and submissions</p>
        </a>

        <a href="systemReports.aspx" class="nav-card">
            <i class="fas fa-chart-bar"></i>
            <h3>Reports & Analytics</h3>
            <p>View system reports and statistics</p>
        </a>

        <a href="systemSettings.aspx" class="nav-card">
            <i class="fas fa-tools"></i>
            <h3>System Settings</h3>
            <p>Configure system preferences</asp:
        </a>

        <a href="#" onclick="showBulkImportModal()" class="nav-card">
            <i class="fas fa-file-import"></i>
            <h3>Bulk Import</h3>
            <p>Import users and data from files</p>
        </a>
    </div>

    <!-- System Health Status -->
    <div class="system-health">
        <h2 class="heading" style="margin-bottom: 2rem;">System Health</h2>
        <div class="health-item">
            <span><i class="fas fa-database"></i> Database Connection</span>
            <span class="health-status good">Good</span>
        </div>
        <div class="health-item">
            <span><i class="fas fa-server"></i> Server Performance</span>
            <span class="health-status good">Optimal</span>
        </div>
        <div class="health-item">
            <span><i class="fas fa-users"></i> Active Users</span>
            <span class="health-status good"><asp:Label ID="lblActiveUsers" runat="server" Text="0"></asp:Label> online</span>
        </div>
        <div class="health-item">
            <span><i class="fas fa-hdd"></i> Storage Usage</span>
            <span class="health-status warning"><asp:Label ID="lblStorageUsage" runat="server" Text="65%"></asp:Label> used</span>
        </div>
    </div>

    <!-- Recent Activity -->
    <div class="recent-activity">
        <div class="activity-header">
            <h2 class="heading" style="margin: 0;">Recent Activity</h2>
        </div>
        <div class="activity-list">
            <asp:Repeater ID="activityRepeater" runat="server">
                <ItemTemplate>
                    <div class="activity-item">
                        <div class="activity-icon <%# GetActivityClass(Eval("ActivityType")) %>">
                            <i class="fas <%# GetActivityIcon(Eval("ActivityType")) %>"></i>
                        </div>
                        <div class="activity-content">
                            <div class="activity-title"><%# Eval("ActivityTitle") %></div>
                            <div class="activity-time"><%# Eval("ActivityTime", "{0:MMM dd, yyyy HH:mm}") %></div>
                        </div>
                    </div>
                </ItemTemplate>
            </asp:Repeater>

            <asp:Panel ID="pnlNoActivity" runat="server" Visible="false">
                <div class="activity-item">
                    <div class="activity-icon" style="background: #bdc3c7;">
                        <i class="fas fa-info"></i>
                    </div>
                    <div class="activity-content">
                        <div class="activity-title">No recent activity</div>
                        <div class="activity-time">System activity will appear here</div>
                    </div>
                </div>
            </asp:Panel>
        </div>
    </div>

    <!-- Messages -->
    <asp:Label ID="lblMessage" runat="server" Text="" style="display: block; margin: 1rem 0;"></asp:Label>
</section>

<!-- Quick Action Buttons -->
<div class="quick-actions">
    <a href="manageUsers.aspx?action=add" class="quick-action-btn" title="Add New User">
        <i class="fas fa-user-plus"></i>
    </a>
</div>

<footer class="footer">
   &copy; copyright @ 2025 by <span>Stanley Nilam</span> | all rights reserved!
</footer>

<script src="js/script.js"></script>
<script>
    function showBulkImportModal() {
        alert('Bulk import feature coming soon!');
    }
    
    // Auto-refresh dashboard every 5 minutes
    setTimeout(function() {
        location.reload();
    }, 300000);
</script>

    </form>
</body>
</html>