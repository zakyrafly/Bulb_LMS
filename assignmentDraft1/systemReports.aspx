<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="systemReports.aspx.cs" Inherits="assignmentDraft1.systemReports" %>

<!DOCTYPE html>
<html lang="en">
<head>
   <meta charset="UTF-8">
   <meta http-equiv="X-UA-Compatible" content="IE=edge">
   <meta name="viewport" content="width=device-width, initial-scale=1.0">
   <title>System Reports & Analytics - Bulb Admin</title>
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
           --admin-teal: #1abc9c;
       }
       
       .admin-header {
           background: linear-gradient(135deg, var(--admin-primary), var(--admin-secondary));
           color: white;
       }
       
       .admin-header .logo {
           color: white;
           font-weight: bold;
       }
       
       .system-reports {
           padding: 2rem;
       }
       
       .stats-overview {
           display: grid;
           grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
           gap: 1.5rem;
           margin-bottom: 3rem;
       }
       
       .overview-card {
           background: white;
           border-radius: 1rem;
           padding: 1.5rem;
           box-shadow: 0 4px 15px rgba(0,0,0,0.1);
           text-align: center;
           position: relative;
           overflow: hidden;
       }
       
       .overview-card::before {
           content: '';
           position: absolute;
           top: 0;
           left: 0;
           right: 0;
           height: 4px;
       }
       
       .overview-card.users::before { background: var(--admin-secondary); }
       .overview-card.courses::before { background: var(--admin-success); }
       .overview-card.assignments::before { background: var(--admin-warning); }
       .overview-card.submissions::before { background: var(--admin-purple); }
       .overview-card.grades::before { background: var(--admin-teal); }
       .overview-card.performance::before { background: var(--admin-danger); }
       
       .overview-icon {
           font-size: 2.5rem;
           margin-bottom: 1rem;
           color: var(--admin-secondary);
       }
       
       .overview-number {
           font-size: 2.5rem;
           font-weight: bold;
           color: var(--admin-primary);
           margin-bottom: 0.5rem;
       }
       
       .overview-label {
           color: #7f8c8d;
           font-size: 1.2rem;
       }
       
       .reports-grid {
           display: grid;
           grid-template-columns: repeat(auto-fit, minmax(500px, 1fr));
           gap: 2rem;
           margin: 2rem 0;
       }
       
       .report-card {
           background: white;
           border-radius: 1rem;
           box-shadow: 0 4px 15px rgba(0,0,0,0.1);
           overflow: hidden;
       }
       
       .report-header {
           background: linear-gradient(135deg, var(--admin-primary), var(--admin-secondary));
           color: white;
           padding: 1.5rem;
           display: flex;
           justify-content: space-between;
           align-items: center;
       }
       
       .report-title {
           display: flex;
           align-items: center;
           gap: 1rem;
           font-size: 1.6rem;
           margin: 0;
       }
       
       .report-body {
           padding: 1.5rem;
       }
       
       .chart-container {
           width: 100%;
           height: 300px;
           display: flex;
           align-items: center;
           justify-content: center;
           background: #f8f9fa;
           border-radius: 0.5rem;
           margin: 1rem 0;
           position: relative;
       }
       
       .data-table {
           width: 100%;
           border-collapse: collapse;
           margin: 1rem 0;
       }
       
       .data-table th {
           background: var(--admin-light);
           padding: 1rem;
           text-align: left;
           font-weight: bold;
           color: var(--admin-primary);
           border-bottom: 2px solid #ddd;
       }
       
       .data-table td {
           padding: 1rem;
           border-bottom: 1px solid #eee;
       }
       
       .data-table tr:hover {
           background-color: #f8f9fa;
       }
       
       .progress-bar {
           width: 100%;
           height: 8px;
           background: #e9ecef;
           border-radius: 4px;
           overflow: hidden;
           margin: 0.5rem 0;
       }
       
       .progress-fill {
           height: 100%;
           background: var(--admin-success);
           transition: width 0.3s ease;
       }
       
       .metric-item {
           display: flex;
           justify-content: space-between;
           align-items: center;
           padding: 1rem 0;
           border-bottom: 1px solid #eee;
       }
       
       .metric-item:last-child {
           border-bottom: none;
       }
       
       .metric-label {
           color: #7f8c8d;
           font-weight: bold;
       }
       
       .metric-value {
           color: var(--admin-primary);
           font-weight: bold;
           font-size: 1.2rem;
       }
       
       .controls-section {
           display: flex;
           justify-content: space-between;
           align-items: center;
           margin-bottom: 2rem;
           flex-wrap: wrap;
           gap: 1rem;
       }
       
       .filter-controls {
           display: flex;
           gap: 1rem;
           align-items: center;
           flex-wrap: wrap;
       }
       
       .btn-export {
           background: var(--admin-success);
           color: white;
           padding: 0.8rem 1.5rem;
           border: none;
           border-radius: 0.5rem;
           font-size: 1.1rem;
           cursor: pointer;
           transition: background 0.3s ease;
           text-decoration: none;
           display: inline-flex;
           align-items: center;
           gap: 0.5rem;
       }
       
       .btn-export:hover {
           background: #229954;
           text-decoration: none;
           color: white;
       }
       
       .btn-refresh {
           background: var(--admin-secondary);
           color: white;
           padding: 0.8rem 1.5rem;
           border: none;
           border-radius: 0.5rem;
           font-size: 1.1rem;
           cursor: pointer;
           transition: background 0.3s ease;
       }
       
       .btn-refresh:hover {
           background: #2980b9;
       }
       
       .performance-indicator {
           display: inline-block;
           padding: 0.3rem 0.8rem;
           border-radius: 1rem;
           font-size: 0.9rem;
           font-weight: bold;
       }
       
       .performance-excellent { background: #d5f4e6; color: var(--admin-success); }
       .performance-good { background: #cce5ff; color: var(--admin-secondary); }
       .performance-average { background: #fff3cd; color: var(--admin-warning); }
       .performance-poor { background: #ffeaea; color: var(--admin-danger); }
       
       .no-data {
           text-align: center;
           padding: 3rem;
           color: #7f8c8d;
           font-style: italic;
       }
       
       .chart-placeholder {
           color: #7f8c8d;
           font-size: 1.2rem;
           text-align: center;
       }
       
       @media (max-width: 768px) {
           .system-reports {
               padding: 1rem;
           }
           
           .reports-grid {
               grid-template-columns: 1fr;
           }
           
           .stats-overview {
               grid-template-columns: repeat(auto-fit, minmax(150px, 1fr));
           }
           
           .controls-section {
               flex-direction: column;
               align-items: stretch;
           }
           
           .filter-controls {
               justify-content: center;
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
      <a href="systemReports.aspx" class="active"><i class="fas fa-chart-line"></i><span>Reports & Analytics</span></a>
      <a href="systemSettings.aspx"><i class="fas fa-cog"></i><span>System Settings</span></a>
      <a href="loginWebform.aspx"><i class="fas fa-sign-out-alt"></i><span>Logout</span></a>
   </nav>
</div>

<section class="system-reports">
    <!-- Page Header -->
    <div style="margin-bottom: 2rem; text-align: center;">
        <h1 class="heading"><i class="fas fa-chart-line"></i> System Reports & Analytics</h1>
        <p style="color: #7f8c8d; font-size: 1.4rem;">Comprehensive analytics and performance insights</p>
    </div>

    <!-- System Overview Stats -->
    <div class="stats-overview">
        <div class="overview-card users">
            <i class="fas fa-users overview-icon"></i>
            <div class="overview-number"><asp:Label ID="lblTotalUsers" runat="server" Text="0"></asp:Label></div>
            <div class="overview-label">Total Users</div>
        </div>
        <div class="overview-card courses">
            <i class="fas fa-graduation-cap overview-icon" style="color: var(--admin-success);"></i>
            <div class="overview-number"><asp:Label ID="lblTotalCourses" runat="server" Text="0"></asp:Label></div>
            <div class="overview-label">Active Courses</div>
        </div>
        <div class="overview-card assignments">
            <i class="fas fa-tasks overview-icon" style="color: var(--admin-warning);"></i>
            <div class="overview-number"><asp:Label ID="lblTotalAssignments" runat="server" Text="0"></asp:Label></div>
            <div class="overview-label">Total Assignments</div>
        </div>
        <div class="overview-card submissions">
            <i class="fas fa-file-alt overview-icon" style="color: var(--admin-purple);"></i>
            <div class="overview-number"><asp:Label ID="lblTotalSubmissions" runat="server" Text="0"></asp:Label></div>
            <div class="overview-label">Submissions</div>
        </div>
        <div class="overview-card grades">
            <i class="fas fa-star overview-icon" style="color: var(--admin-teal);"></i>
            <div class="overview-number"><asp:Label ID="lblTotalGrades" runat="server" Text="0"></asp:Label></div>
            <div class="overview-label">Grades Given</div>
        </div>
        <div class="overview-card performance">
            <i class="fas fa-chart-bar overview-icon" style="color: var(--admin-danger);"></i>
            <div class="overview-number"><asp:Label ID="lblAvgPerformance" runat="server" Text="0%"></asp:Label></div>
            <div class="overview-label">Avg Performance</div>
        </div>
    </div>

    <!-- Controls -->
    <div class="controls-section">
        <div class="filter-controls">
            <asp:DropDownList ID="ddlReportPeriod" runat="server" CssClass="box" AutoPostBack="true" OnSelectedIndexChanged="ddlReportPeriod_SelectedIndexChanged">
                <asp:ListItem Text="Last 7 Days" Value="7" />
                <asp:ListItem Text="Last 30 Days" Value="30" Selected="True" />
                <asp:ListItem Text="Last 90 Days" Value="90" />
                <asp:ListItem Text="All Time" Value="0" />
            </asp:DropDownList>
            <asp:Button ID="btnRefreshReports" runat="server" Text="Refresh Data" CssClass="btn-refresh" OnClick="btnRefreshReports_Click" />
        </div>
        <div>
            <asp:Button ID="btnExportReports" runat="server" Text="Export Reports" CssClass="btn-export" OnClick="btnExportReports_Click" />
        </div>
    </div>

    <!-- Reports Grid -->
    <div class="reports-grid">
        
        <!-- User Activity Report -->
        <div class="report-card">
            <div class="report-header">
                <h3 class="report-title">
                    <i class="fas fa-users"></i>
                    User Activity Report
                </h3>
            </div>
            <div class="report-body">
                <div class="metric-item">
                    <span class="metric-label">Active Students</span>
                    <span class="metric-value"><asp:Label ID="lblActiveStudents" runat="server" Text="0"></asp:Label></span>
                </div>
                <div class="metric-item">
                    <span class="metric-label">Active Lecturers</span>
                    <span class="metric-value"><asp:Label ID="lblActiveLecturers" runat="server" Text="0"></asp:Label></span>
                </div>
                <div class="metric-item">
                    <span class="metric-label">New Registrations</span>
                    <span class="metric-value"><asp:Label ID="lblNewRegistrations" runat="server" Text="0"></asp:Label></span>
                </div>
                <div class="metric-item">
                    <span class="metric-label">User Engagement Rate</span>
                    <span class="metric-value"><asp:Label ID="lblEngagementRate" runat="server" Text="0%"></asp:Label></span>
                </div>
            </div>
        </div>

        <!-- Course Performance Report -->
        <div class="report-card">
            <div class="report-header">
                <h3 class="report-title">
                    <i class="fas fa-graduation-cap"></i>
                    Course Performance
                </h3>
            </div>
            <div class="report-body">
                <asp:Repeater ID="coursePerformanceRepeater" runat="server">
                    <HeaderTemplate>
                        <table class="data-table">
                            <thead>
                                <tr>
                                    <th>Course</th>
                                    <th>Students</th>
                                    <th>Completion</th>
                                    <th>Avg Grade</th>
                                </tr>
                            </thead>
                            <tbody>
                    </HeaderTemplate>
                    <ItemTemplate>
                        <tr>
                            <td><%# Eval("CourseName") %></td>
                            <td><%# Eval("StudentCount") %></td>
                            <td>
                                <div class="progress-bar">
                                    <div class="progress-fill" style="width: <%# Eval("CompletionRate") %>%"></div>
                                </div>
                                <%# Eval("CompletionRate") %>%
                            </td>
                            <td>
                                <span class="performance-indicator <%# GetPerformanceClass(Eval("AverageGrade")) %>">
                                    <%# Eval("AverageGrade", "{0:F1}") %>%
                                </span>
                            </td>
                        </tr>
                    </ItemTemplate>
                    <FooterTemplate>
                            </tbody>
                        </table>
                    </FooterTemplate>
                </asp:Repeater>
                
                <asp:Panel ID="pnlNoCourseData" runat="server" Visible="false">
                    <div class="no-data">
                        <i class="fas fa-chart-bar" style="font-size: 3rem; margin-bottom: 1rem; opacity: 0.3;"></i>
                        <p>No course performance data available</p>
                    </div>
                </asp:Panel>
            </div>
        </div>

        <!-- Assignment Analytics -->
        <div class="report-card">
            <div class="report-header">
                <h3 class="report-title">
                    <i class="fas fa-tasks"></i>
                    Assignment Analytics
                </h3>
            </div>
            <div class="report-body">
                <div class="chart-container">
                    <div class="chart-placeholder">
                        <i class="fas fa-chart-pie" style="font-size: 3rem; margin-bottom: 1rem;"></i>
                        <p>Assignment Status Distribution</p>
                        <div style="display: flex; justify-content: space-around; margin-top: 2rem;">
                            <div style="text-align: center;">
                                <div style="color: var(--admin-success); font-size: 1.5rem; font-weight: bold;"><asp:Label ID="lblOnTimeSubmissions" runat="server" Text="0"></asp:Label></div>
                                <div style="color: #7f8c8d;">On Time</div>
                            </div>
                            <div style="text-align: center;">
                                <div style="color: var(--admin-warning); font-size: 1.5rem; font-weight: bold;"><asp:Label ID="lblLateSubmissions" runat="server" Text="0"></asp:Label></div>
                                <div style="color: #7f8c8d;">Late</div>
                            </div>
                            <div style="text-align: center;">
                                <div style="color: var(--admin-danger); font-size: 1.5rem; font-weight: bold;"><asp:Label ID="lblMissedAssignments" runat="server" Text="0"></asp:Label></div>
                                <div style="color: #7f8c8d;">Missed</div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="metric-item">
                    <span class="metric-label">Average Submission Rate</span>
                    <span class="metric-value"><asp:Label ID="lblSubmissionRate" runat="server" Text="0%"></asp:Label></span>
                </div>
                <div class="metric-item">
                    <span class="metric-label">Grading Efficiency</span>
                    <span class="metric-value"><asp:Label ID="lblGradingEfficiency" runat="server" Text="0%"></asp:Label></span>
                </div>
            </div>
        </div>

        <!-- Top Performing Students -->
        <div class="report-card">
            <div class="report-header">
                <h3 class="report-title">
                    <i class="fas fa-trophy"></i>
                    Top Performing Students
                </h3>
            </div>
            <div class="report-body">
                <asp:Repeater ID="topStudentsRepeater" runat="server">
                    <HeaderTemplate>
                        <table class="data-table">
                            <thead>
                                <tr>
                                    <th>Rank</th>
                                    <th>Student</th>
                                    <th>Average Grade</th>
                                    <th>Assignments</th>
                                </tr>
                            </thead>
                            <tbody>
                    </HeaderTemplate>
                    <ItemTemplate>
                        <tr>
                            <td>
                                <span style="background: var(--admin-warning); color: white; padding: 0.3rem 0.8rem; border-radius: 1rem; font-weight: bold;">
                                    #<%# Container.ItemIndex + 1 %>
                                </span>
                            </td>
                            <td><%# Eval("StudentName") %></td>
                            <td>
                                <span class="performance-indicator <%# GetPerformanceClass(Eval("AverageGrade")) %>">
                                    <%# Eval("AverageGrade", "{0:F1}") %>%
                                </span>
                            </td>
                            <td><%# Eval("CompletedAssignments") %>/<%# Eval("TotalAssignments") %></td>
                        </tr>
                    </ItemTemplate>
                    <FooterTemplate>
                            </tbody>
                        </table>
                    </FooterTemplate>
                </asp:Repeater>
                
                <asp:Panel ID="pnlNoStudentData" runat="server" Visible="false">
                    <div class="no-data">
                        <i class="fas fa-user-graduate" style="font-size: 3rem; margin-bottom: 1rem; opacity: 0.3;"></i>
                        <p>No student performance data available</p>
                    </div>
                </asp:Panel>
            </div>
        </div>

        <!-- System Performance Metrics -->
        <div class="report-card">
            <div class="report-header">
                <h3 class="report-title">
                    <i class="fas fa-server"></i>
                    System Performance
                </h3>
            </div>
            <div class="report-body">
                <div class="metric-item">
                    <span class="metric-label">Database Records</span>
                    <span class="metric-value"><asp:Label ID="lblDatabaseRecords" runat="server" Text="0"></asp:Label></span>
                </div>
                <div class="metric-item">
                    <span class="metric-label">Storage Usage</span>
                    <span class="metric-value">
                        <div class="progress-bar">
                            <div class="progress-fill" style="width: 65%"></div>
                        </div>
                        65% Used
                    </span>
                </div>
                <div class="metric-item">
                    <span class="metric-label">System Uptime</span>
                    <span class="metric-value" style="color: var(--admin-success);">99.9%</span>
                </div>
                <div class="metric-item">
                    <span class="metric-label">Data Integrity</span>
                    <span class="metric-value" style="color: var(--admin-success);">Excellent</span>
                </div>
            </div>
        </div>

        <!-- Recent Activity Timeline -->
        <div class="report-card">
            <div class="report-header">
                <h3 class="report-title">
                    <i class="fas fa-clock"></i>
                    Recent System Activity
                </h3>
            </div>
            <div class="report-body">
                <asp:Repeater ID="recentActivityRepeater" runat="server">
                    <ItemTemplate>
                        <div class="metric-item">
                            <div>
                                <strong><%# Eval("ActivityType") %></strong>
                                <p style="margin: 0.3rem 0 0 0; color: #7f8c8d; font-size: 1.1rem;">
                                    <%# Eval("ActivityDescription") %>
                                </p>
                            </div>
                            <span class="metric-value" style="font-size: 1rem;">
                                <%# Eval("ActivityTime", "{0:MMM dd, HH:mm}") %>
                            </span>
                        </div>
                    </ItemTemplate>
                </asp:Repeater>
                
                <asp:Panel ID="pnlNoActivity" runat="server" Visible="false">
                    <div class="no-data">
                        <i class="fas fa-clock" style="font-size: 3rem; margin-bottom: 1rem; opacity: 0.3;"></i>
                        <p>No recent activity to display</p>
                    </div>
                </asp:Panel>
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