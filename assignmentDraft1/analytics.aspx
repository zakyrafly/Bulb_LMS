<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="analytics.aspx.cs" Inherits="assignmentDraft1.analytics" %>

<!DOCTYPE html>
<html lang="en">
<head>
   <meta charset="UTF-8">
   <meta http-equiv="X-UA-Compatible" content="IE=edge">
   <meta name="viewport" content="width=device-width, initial-scale=1.0">
   <title>Lecturer Analytics</title>
   <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.1.2/css/all.min.css">
   <link rel="stylesheet" href="css/style.css">
   
   <style>
       /* Analytics specific styles */
       .analytics-grid {
           display: grid;
           grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
           gap: 2rem;
           margin-bottom: 2rem;
       }
       
       .analytics-card {
           background: var(--white);
           border-radius: .5rem;
           box-shadow: var(--box-shadow);
           padding: 2rem;
           transition: all 0.3s ease;
       }
       
       .analytics-card:hover {
           transform: translateY(-5px);
           box-shadow: 0 1rem 2rem rgba(0, 0, 0, 0.15);
       }
       
       .analytics-header {
           display: flex;
           justify-content: space-between;
           align-items: center;
           margin-bottom: 1.5rem;
       }
       
       .analytics-title {
           font-size: 1.8rem;
           color: var(--black);
       }
       
       .analytics-icon {
           width: 4rem;
           height: 4rem;
           background: var(--light-bg);
           border-radius: 50%;
           display: flex;
           align-items: center;
           justify-content: center;
           font-size: 1.8rem;
           color: var(--main-color);
       }
       
       .stat-large {
           font-size: 3rem;
           font-weight: bold;
           margin-bottom: 0.5rem;
           color: var(--black);
       }
       
       .stat-description {
           font-size: 1.4rem;
           color: var(--light-color);
       }
       
       .trend-up {
           color: green;
       }
       
       .trend-down {
           color: red;
       }
       
       .chart-container {
           background: var(--white);
           border-radius: .5rem;
           box-shadow: var(--box-shadow);
           padding: 2rem;
           margin-bottom: 2rem;
           min-height: 400px;
       }
       
       .chart-header {
           display: flex;
           justify-content: space-between;
           align-items: center;
           margin-bottom: 2rem;
       }
       
       .chart-title {
           font-size: 2rem;
           color: var(--black);
       }
       
       .chart-canvas {
           width: 100%;
           height: 350px;
           background: var(--white);
       }
       
       .filter-bar {
           display: flex;
           flex-wrap: wrap;
           gap: 1rem;
           margin-bottom: 2rem;
           background: var(--white);
           border-radius: .5rem;
           box-shadow: var(--box-shadow);
           padding: 1.5rem;
       }
       
       .date-filter {
           display: flex;
           align-items: center;
           gap: 1rem;
       }
       
       .date-label {
           font-size: 1.4rem;
           color: var(--black);
       }
       
       .key-insights {
           background: var(--white);
           border-radius: .5rem;
           box-shadow: var(--box-shadow);
           padding: 2rem;
           margin-bottom: 2rem;
       }
       
       .insight-list {
           list-style: none;
           padding: 0;
           margin: 1rem 0;
       }
       
       .insight-item {
           display: flex;
           align-items: flex-start;
           gap: 1rem;
           margin-bottom: 1.5rem;
           padding-bottom: 1.5rem;
           border-bottom: 1px solid var(--light-bg);
       }
       
       .insight-item:last-child {
           border-bottom: none;
           padding-bottom: 0;
           margin-bottom: 0;
       }
       
       .insight-icon {
           background: var(--light-bg);
           width: 3rem;
           height: 3rem;
           border-radius: 50%;
           display: flex;
           align-items: center;
           justify-content: center;
           font-size: 1.4rem;
           color: var(--main-color);
           flex-shrink: 0;
       }
       
       .insight-content {
           flex-grow: 1;
       }
       
       .insight-title {
           font-size: 1.6rem;
           color: var(--black);
           margin-bottom: 0.5rem;
       }
       
       .insight-description {
           font-size: 1.4rem;
           color: var(--light-color);
       }
       
       .progress-bar {
           width: 100%;
           height: 0.8rem;
           background: var(--light-bg);
           border-radius: 1rem;
           overflow: hidden;
           margin-top: 1rem;
       }
       
       .progress-fill {
           height: 100%;
           border-radius: 1rem;
           transition: width 1s ease-in-out;
       }
       
       .color-primary {
           background: var(--main-color);
       }
       
       .color-success {
           background: green;
       }
       
       .color-warning {
           background: orange;
       }
       
       .color-danger {
           background: red;
       }
       
       .tabs-container {
           margin-bottom: 2rem;
       }
       
       .tabs {
           display: flex;
           border-bottom: 1px solid var(--light-bg);
           margin-bottom: 2rem;
       }
       
       .tab {
           padding: 1rem 2rem;
           font-size: 1.6rem;
           cursor: pointer;
           background: transparent;
           border: none;
           position: relative;
           color: var(--light-color);
       }
       
       .tab.active {
           color: var(--main-color);
           font-weight: bold;
       }
       
       .tab.active::after {
           content: '';
           position: absolute;
           bottom: -1px;
           left: 0;
           width: 100%;
           height: 3px;
           background: var(--main-color);
       }
       
       .tab-content {
           display: none;
       }
       
       .tab-content.active {
           display: block;
       }
       
       .info-card {
           background: var(--white);
           border-radius: .5rem;
           box-shadow: var(--box-shadow);
           padding: 2rem;
           margin-bottom: 1rem;
       }
       
       .info-title {
           font-size: 1.6rem;
           color: var(--black);
           margin-bottom: 1rem;
       }
       
       .info-value {
           font-size: 1.4rem;
           color: var(--light-color);
       }
       
       .student-table {
           width: 100%;
           border-collapse: collapse;
       }
       
       .student-table th, .student-table td {
           padding: 1.2rem;
           text-align: left;
           border-bottom: 1px solid var(--light-bg);
       }
       
       .student-table th {
           font-weight: bold;
           color: var(--black);
       }
       
       .student-table td {
           color: var(--light-color);
       }
       
       .student-table tbody tr:hover {
           background: var(--light-bg);
       }
       
       .chart-tooltip {
           background: rgba(0, 0, 0, 0.8);
           color: white;
           padding: 1rem;
           border-radius: 0.5rem;
           font-size: 1.4rem;
           pointer-events: none;
           position: absolute;
           z-index: 100;
           display: none;
       }
       
       .loader {
           display: flex;
           justify-content: center;
           align-items: center;
           height: 200px;
       }
       
       .loader i {
           font-size: 3rem;
           color: var(--main-color);
           animation: spin 1s linear infinite;
       }
       
       @keyframes spin {
           0% { transform: rotate(0deg); }
           100% { transform: rotate(360deg); }
       }
       
       /* Responsive adjustments */
       @media (max-width: 768px) {
           .analytics-grid {
               grid-template-columns: 1fr;
           }
           
           .filter-bar {
               flex-direction: column;
           }
           
           .date-filter {
               flex-wrap: wrap;
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
          <asp:TextBox ID="txtHeaderSearch" runat="server" CssClass="search-input" placeholder="Search..." MaxLength="100" />
          <asp:LinkButton ID="btnHeaderSearch" runat="server" CssClass="inline-btn search-btn" OnClick="BtnHeaderSearch_Click">
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
         <p class="role"><asp:Label ID="lblRole" runat="server" Text=""></asp:Label></p>
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
      <h3 class="name"><asp:Label ID="lblSidebarName" runat="server" Text=""></asp:Label></h3>
      <p class="role"><asp:Label ID="lblSidebarRole" runat="server" Text=""></asp:Label></p>
      <a href="profile.aspx" class="btn">view profile</a>
   </div>
   <nav class="navbar">
      <a href="teacherWebform.aspx"><i class="fas fa-home"></i><span>Dashboard</span></a>
      <a href="ViewStudent.aspx"><i class="fas fa-users"></i><span>Students</span></a>
      <a href="assignments.aspx"><i class="fas fa-tasks"></i><span>Assignments</span></a>
      <a href="analytics.aspx" class="active"><i class="fas fa-chart-line"></i><span>Analytics</span></a>
      <a href="settings.aspx"><i class="fas fa-cog"></i><span>Settings</span></a>
      <a href="loginWebform.aspx"><i class="fas fa-sign-out-alt"></i><span>Logout</span></a>
   </nav>
</div>

<section class="course-content">
    <!-- Page Header -->
    <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 2rem;">
        <h1 class="heading"><i class="fas fa-chart-line"></i> Analytics Dashboard</h1>
        <div>
            <asp:Button ID="btnExportData" runat="server" CssClass="btn" Text="Export Data" OnClick="BtnExportData_Click" />
            <asp:Button ID="btnRefreshData" runat="server" CssClass="inline-option-btn" Text="Refresh Data" OnClick="BtnRefreshData_Click" />
        </div>
    </div>

    <!-- Filter Options -->
    <div class="filter-bar">
        <div style="flex-grow: 1;">
            <asp:DropDownList ID="ddlCourseFilter" runat="server" CssClass="box" AutoPostBack="true" OnSelectedIndexChanged="DdlCourseFilter_SelectedIndexChanged">
                <asp:ListItem Text="All Courses" Value="" />
            </asp:DropDownList>
        </div>
        
        <div class="date-filter">
            <span class="date-label">Date Range:</span>
            <asp:DropDownList ID="ddlDateRange" runat="server" CssClass="box" AutoPostBack="true" OnSelectedIndexChanged="DdlDateRange_SelectedIndexChanged">
                <asp:ListItem Text="Last 7 Days" Value="7" />
                <asp:ListItem Text="Last 30 Days" Value="30" />
                <asp:ListItem Text="Last 90 Days" Value="90" />
                <asp:ListItem Text="All Time" Value="0" Selected="True" />
            </asp:DropDownList>
        </div>
        
        <div class="date-filter">
            <span class="date-label">Custom:</span>
            <asp:TextBox ID="txtStartDate" runat="server" CssClass="box" TextMode="Date" />
            <span class="date-label">to</span>
            <asp:TextBox ID="txtEndDate" runat="server" CssClass="box" TextMode="Date" />
            <asp:Button ID="btnApplyCustomDate" runat="server" CssClass="inline-btn" Text="Apply" OnClick="BtnApplyCustomDate_Click" />
        </div>
    </div>
    
    <!-- Overview Stats -->
    <div class="analytics-grid">
        <div class="analytics-card">
            <div class="analytics-header">
                <div>
                    <h3 class="analytics-title">Total Students</h3>
                </div>
                <div class="analytics-icon">
                    <i class="fas fa-users"></i>
                </div>
            </div>
            <div class="stat-large"><asp:Label ID="lblTotalStudents" runat="server" Text="0"></asp:Label></div>
            <div class="stat-description">
                <i class="fas fa-arrow-up trend-up"></i> 
                <asp:Label ID="lblStudentGrowth" runat="server" Text="0%"></asp:Label> from previous period
            </div>
        </div>
        
        <div class="analytics-card">
            <div class="analytics-header">
                <div>
                    <h3 class="analytics-title">Assignment Completion</h3>
                </div>
                <div class="analytics-icon">
                    <i class="fas fa-tasks"></i>
                </div>
            </div>
            <div class="stat-large"><asp:Label ID="lblCompletionRate" runat="server" Text="0%"></asp:Label></div>
            <div class="stat-description">
                <i class="fas fa-arrow-up trend-up"></i> 
                <asp:Label ID="lblCompletionGrowth" runat="server" Text="0%"></asp:Label> from previous period
            </div>
            <div class="progress-bar">
                <div class="progress-fill color-primary" id="completionRateBar" style="width: 0%;"></div>
            </div>
        </div>
        
        <div class="analytics-card">
            <div class="analytics-header">
                <div>
                    <h3 class="analytics-title">Average Grade</h3>
                </div>
                <div class="analytics-icon">
                    <i class="fas fa-graduation-cap"></i>
                </div>
            </div>
            <div class="stat-large"><asp:Label ID="lblAverageGrade" runat="server" Text="0%"></asp:Label></div>
            <div class="stat-description">
                <i class="fas fa-arrow-down trend-down"></i> 
                <asp:Label ID="lblGradeGrowth" runat="server" Text="0%"></asp:Label> from previous period
            </div>
            <div class="progress-bar">
                <div class="progress-fill color-success" id="averageGradeBar" style="width: 0%;"></div>
            </div>
        </div>
        
        <div class="analytics-card">
            <div class="analytics-header">
                <div>
                    <h3 class="analytics-title">Active Assignments</h3>
                </div>
                <div class="analytics-icon">
                    <i class="fas fa-clipboard-list"></i>
                </div>
            </div>
            <div class="stat-large"><asp:Label ID="lblActiveAssignments" runat="server" Text="0"></asp:Label></div>
            <div class="stat-description">
                <i class="fas fa-arrow-up trend-up"></i> 
                <asp:Label ID="lblAssignmentGrowth" runat="server" Text="0%"></asp:Label> from previous period
            </div>
        </div>
    </div>
    
    <!-- Tabs Navigation -->
    <div class="tabs-container">
        <div class="tabs">
            <button type="button" class="tab active" data-tab="student-performance">Student Performance</button>
            <button type="button" class="tab" data-tab="assignment-analytics">Assignment Analytics</button>
            <button type="button" class="tab" data-tab="course-engagement">Course Engagement</button>
            <button type="button" class="tab" data-tab="grade-distribution">Grade Distribution</button>
        </div>
        
        <!-- Student Performance Tab -->
        <div id="student-performance" class="tab-content active">
            <div class="chart-container">
                <div class="chart-header">
                    <h3 class="chart-title">Student Performance Trends</h3>
                    <div>
                        <asp:DropDownList ID="ddlPerformanceMetric" runat="server" CssClass="box" AutoPostBack="true" OnSelectedIndexChanged="DdlPerformanceMetric_SelectedIndexChanged">
                            <asp:ListItem Text="Average Grade" Value="grade" />
                            <asp:ListItem Text="Completion Rate" Value="completion" />
                            <asp:ListItem Text="Submission Time" Value="time" />
                        </asp:DropDownList>
                    </div>
                </div>
                <div class="chart-canvas" id="performanceChart">
                    <div class="loader">
                        <i class="fas fa-spinner"></i>
                    </div>
                </div>
            </div>
            
            <div class="key-insights">
                <h3 class="chart-title">Key Insights</h3>
                <ul class="insight-list">
                    <asp:Repeater ID="performanceInsightsRepeater" runat="server">
                        <ItemTemplate>
                            <li class="insight-item">
                                <div class="insight-icon">
                                    <i class="fas <%# Eval("Icon") %>"></i>
                                </div>
                                <div class="insight-content">
                                    <h4 class="insight-title"><%# Eval("Title") %></h4>
                                    <p class="insight-description"><%# Eval("Description") %></p>
                                </div>
                            </li>
                        </ItemTemplate>
                    </asp:Repeater>
                </ul>
            </div>
            
            <h3 class="chart-title">Top Performing Students</h3>
            <div style="overflow-x: auto;">
                <table class="student-table">
                    <thead>
                        <tr>
                            <th>Student Name</th>
                            <th>Email</th>
                            <th>Course</th>
                            <th>Avg. Grade</th>
                            <th>Submissions</th>
                            <th>Completion Rate</th>
                        </tr>
                    </thead>
                    <tbody>
                        <asp:Repeater ID="topStudentsRepeater" runat="server">
                            <ItemTemplate>
                                <tr>
                                    <td><%# Eval("Name") %></td>
                                    <td><%# Eval("Email") %></td>
                                    <td><%# Eval("CourseName") %></td>
                                    <td><%# Eval("AvgGrade") %>%</td>
                                    <td><%# Eval("Submissions") %></td>
                                    <td><%# Eval("CompletionRate") %>%</td>
                                </tr>
                            </ItemTemplate>
                        </asp:Repeater>
                    </tbody>
                </table>
            </div>
        </div>
        
        <!-- Assignment Analytics Tab -->
        <div id="assignment-analytics" class="tab-content">
            <div class="chart-container">
                <div class="chart-header">
                    <h3 class="chart-title">Assignment Completion Rates</h3>
                    <div>
                        <asp:DropDownList ID="ddlAssignmentFilter" runat="server" CssClass="box" AutoPostBack="true" OnSelectedIndexChanged="DdlAssignmentFilter_SelectedIndexChanged">
                            <asp:ListItem Text="All Assignments" Value="" />
                            <asp:ListItem Text="Active Assignments" Value="active" />
                            <asp:ListItem Text="Past Due Assignments" Value="past" />
                        </asp:DropDownList>
                    </div>
                </div>
                <div class="chart-canvas" id="assignmentChart">
                    <div class="loader">
                        <i class="fas fa-spinner"></i>
                    </div>
                </div>
            </div>
            
            <div class="analytics-grid">
                <div class="analytics-card">
                    <div class="analytics-header">
                        <div>
                            <h3 class="analytics-title">Average Submission Time</h3>
                        </div>
                        <div class="analytics-icon">
                            <i class="fas fa-clock"></i>
                        </div>
                    </div>
                    <div class="stat-large"><asp:Label ID="lblAvgSubmissionTime" runat="server" Text="0"></asp:Label> days</div>
                    <div class="stat-description">before deadline</div>
                </div>
                
                <div class="analytics-card">
                    <div class="analytics-header">
                        <div>
                            <h3 class="analytics-title">Late Submissions</h3>
                        </div>
                        <div class="analytics-icon">
                            <i class="fas fa-exclamation-circle"></i>
                        </div>
                    </div>
                    <div class="stat-large"><asp:Label ID="lblLateSubmissions" runat="server" Text="0%"></asp:Label></div>
                    <div class="stat-description">of total submissions</div>
                    <div class="progress-bar">
                        <div class="progress-fill color-warning" id="lateSubmissionsBar" style="width: 0%;"></div>
                    </div>
                </div>
                
                <div class="analytics-card">
                    <div class="analytics-header">
                        <div>
                            <h3 class="analytics-title">Average Time to Grade</h3>
                        </div>
                        <div class="analytics-icon">
                            <i class="fas fa-hourglass-half"></i>
                        </div>
                    </div>
                    <div class="stat-large"><asp:Label ID="lblAvgGradeTime" runat="server" Text="0"></asp:Label> days</div>
                    <div class="stat-description">after submission</div>
                </div>
            </div>
            
            <h3 class="chart-title">Assignments Requiring Attention</h3>
            <div style="overflow-x: auto;">
                <table class="student-table">
                    <thead>
                        <tr>
                            <th>Assignment</th>
                            <th>Course</th>
                            <th>Due Date</th>
                            <th>Submission Rate</th>
                            <th>Avg. Grade</th>
                            <th>Status</th>
                        </tr>
                    </thead>
                    <tbody>
                        <asp:Repeater ID="assignmentAttentionRepeater" runat="server">
                            <ItemTemplate>
                                <tr>
                                    <td><%# Eval("Title") %></td>
                                    <td><%# Eval("CourseName") %></td>
                                    <td><%# Eval("DueDate", "{0:MMM dd, yyyy}") %></td>
                                    <td><%# Eval("SubmissionRate") %>%</td>
                                    <td><%# Eval("AvgGrade") %>%</td>
                                    <td>
                                        <span class="status-badge <%# Eval("StatusClass") %>">
                                            <%# Eval("Status") %>
                                        </span>
                                    </td>
                                </tr>
                            </ItemTemplate>
                        </asp:Repeater>
                    </tbody>
                </table>
            </div>
        </div>
        
        <!-- Course Engagement Tab -->
        <div id="course-engagement" class="tab-content">
            <div class="chart-container">
                <div class="chart-header">
                    <h3 class="chart-title">Course Engagement Overview</h3>
                    <div>
                        <asp:DropDownList ID="ddlEngagementMetric" runat="server" CssClass="box" AutoPostBack="true" OnSelectedIndexChanged="DdlEngagementMetric_SelectedIndexChanged">
                            <asp:ListItem Text="Student Activity" Value="activity" />
                            <asp:ListItem Text="Completion Rates" Value="completion" />
                            <asp:ListItem Text="Student Progress" Value="progress" />
                        </asp:DropDownList>
                    </div>
                </div>
                <div class="chart-canvas" id="engagementChart">
                    <div class="loader">
                        <i class="fas fa-spinner"></i>
                    </div>
                </div>
            </div>
            
            <div class="analytics-grid">
                <div class="analytics-card">
                    <div class="analytics-header">
                        <div>
                            <h3 class="analytics-title">Active Students</h3>
                        </div>
                        <div class="analytics-icon">
                            <i class="fas fa-user-check"></i>
                        </div>
                    </div>
                    <div class="stat-large"><asp:Label ID="lblActiveStudents" runat="server" Text="0%"></asp:Label></div>
                    <div class="stat-description">of enrolled students</div>
                    <div class="progress-bar">
                        <div class="progress-fill color-primary" id="activeStudentsBar" style="width: 0%;"></div>
                    </div>
                </div>
                
                <div class="analytics-card">
                    <div class="analytics-header">
                        <div>
                            <h3 class="analytics-title">Inactive Students</h3>
                        </div>
                        <div class="analytics-icon">
                            <i class="fas fa-user-times"></i>
                        </div>
                    </div>
                    <div class="stat-large"><asp:Label ID="lblInactiveStudents" runat="server" Text="0"></asp:Label></div>
                    <div class="stat-description">students with no activity</div>
                </div>
                
                <div class="analytics-card">
                    <div class="analytics-header">
                        <div>
                            <h3 class="analytics-title">Most Active Course</h3>
                        </div>
                        <div class="analytics-icon">
                            <i class="fas fa-award"></i>
                        </div>
                    </div>
                    <div class="stat-large"><asp:Label ID="lblMostActiveCourse" runat="server" Text="-"></asp:Label></div>
                    <div class="stat-description">
                        <asp:Label ID="lblMostActiveCourseRate" runat="server" Text="0%"></asp:Label> engagement rate
                    </div>
                </div>
            </div>
            
            <div class="key-insights">
                <h3 class="chart-title">Engagement Insights</h3>
                <ul class="insight-list">
                    <asp:Repeater ID="engagementInsightsRepeater" runat="server">
                        <ItemTemplate>
                            <li class="insight-item">
                                <div class="insight-icon">
                                    <i class="fas <%# Eval("Icon") %>"></i>
                                </div>
                                <div class="insight-content">
                                    <h4 class="insight-title"><%# Eval("Title") %></h4>
                                    <p class="insight-description"><%# Eval("Description") %></p>
                                </div>
                            </li>
                        </ItemTemplate>
                    </asp:Repeater>
                </ul>
            </div>
            
            <h3 class="chart-title">Course Activity Ranking</h3>
            <div style="overflow-x: auto;">
                <table class="student-table">
                    <thead>
                        <tr>
                            <th>Course</th>
                            <th>Students</th>
                            <th>Assignments</th>
                            <th>Avg. Completion</th>
                            <th>Avg. Grade</th>
                            <th>Engagement Score</th>
                        </tr>
                    </thead>
                    <tbody>
                        <asp:Repeater ID="courseActivityRepeater" runat="server">
                            <ItemTemplate>
                                <tr>
                                    <td><%# Eval("CourseName") %></td>
                                    <td><%# Eval("Students") %></td>
                                    <td><%# Eval("Assignments") %></td>
                                    <td><%# Eval("AvgCompletion") %>%</td>
                                    <td><%# Eval("AvgGrade") %>%</td>
                                    <td>
                                        <div class="progress-bar" style="margin: 0;">
                                            <div class="progress-fill color-primary" style="width: <%# Eval("EngagementScore") %>%;"></div>
                                        </div>
                                        <div style="text-align: right; font-size: 1.2rem; margin-top: 0.2rem;">
                                            <%# Eval("EngagementScore") %>%
                                        </div>
                                    </td>
                                </tr>
                            </ItemTemplate>
                        </asp:Repeater>
                    </tbody>
                </table>
            </div>
        </div>
        
        <!-- Grade Distribution Tab -->
        <div id="grade-distribution" class="tab-content">
            <div class="chart-container">
                <div class="chart-header">
                    <h3 class="chart-title">Grade Distribution</h3>
                    <div>
                        <asp:DropDownList ID="ddlGradeFilter" runat="server" CssClass="box" AutoPostBack="true" OnSelectedIndexChanged="DdlGradeFilter_SelectedIndexChanged">
                            <asp:ListItem Text="All Assignments" Value="" />
                        </asp:DropDownList>
                    </div>
                </div>
                <div class="chart-canvas" id="gradeDistributionChart">
                    <div class="loader">
                        <i class="fas fa-spinner"></i>
                    </div>
                </div>
            </div>
            
            <div class="analytics-grid">
                <div class="analytics-card">
                    <div class="analytics-header">
                        <div>
                            <h3 class="analytics-title">Highest Grade</h3>
                        </div>
                        <div class="analytics-icon">
                            <i class="fas fa-trophy"></i>
                        </div>
                    </div>
                    <div class="stat-large"><asp:Label ID="lblHighestGrade" runat="server" Text="0%"></asp:Label></div>
                    <div class="stat-description">
                        by <asp:Label ID="lblHighestGradeStudent" runat="server" Text="-"></asp:Label>
                    </div>
                </div>
                
                <div class="analytics-card">
                    <div class="analytics-header">
                        <div>
                            <h3 class="analytics-title">Lowest Grade</h3>
                        </div>
                        <div class="analytics-icon">
                            <i class="fas fa-exclamation-triangle"></i>
                        </div>
                    </div>
                    <div class="stat-large"><asp:Label ID="lblLowestGrade" runat="server" Text="0%"></asp:Label></div>
                    <div class="stat-description">
                        by <asp:Label ID="lblLowestGradeStudent" runat="server" Text="-"></asp:Label>
                    </div>
                </div>
                
                <div class="analytics-card">
                    <div class="analytics-header">
                        <div>
                            <h3 class="analytics-title">Median Grade</h3>
                        </div>
                        <div class="analytics-icon">
                            <i class="fas fa-sort-numeric-up"></i>
                        </div>
                    </div>
                    <div class="stat-large"><asp:Label ID="lblMedianGrade" runat="server" Text="0%"></asp:Label></div>
                    <div class="stat-description">across all assignments</div>
                </div>
                
                <div class="analytics-card">
                    <div class="analytics-header">
                        <div>
                            <h3 class="analytics-title">Grade Deviation</h3>
                        </div>
                        <div class="analytics-icon">
                            <i class="fas fa-chart-bar"></i>
                        </div>
                    </div>
                    <div class="stat-large"><asp:Label ID="lblGradeDeviation" runat="server" Text="0"></asp:Label></div>
                    <div class="stat-description">standard deviation</div>
                </div>
            </div>
            
            <div class="chart-container">
                <div class="chart-header">
                    <h3 class="chart-title">Grade Trends Over Time</h3>
                </div>
                <div class="chart-canvas" id="gradeTrendsChart">
                    <div class="loader">
                        <i class="fas fa-spinner"></i>
                    </div>
                </div>
            </div>
            
            <h3 class="chart-title">Grade Summary by Assignment</h3>
            <div style="overflow-x: auto;">
                <table class="student-table">
                    <thead>
                        <tr>
                            <th>Assignment</th>
                            <th>Course</th>
                            <th>Avg. Grade</th>
                            <th>Median</th>
                            <th>Highest</th>
                            <th>Lowest</th>
                            <th>Grade Curve</th>
                        </tr>
                    </thead>
                    <tbody>
                        <asp:Repeater ID="gradeSummaryRepeater" runat="server">
                            <ItemTemplate>
                                <tr>
                                    <td><%# Eval("Title") %></td>
                                    <td><%# Eval("CourseName") %></td>
                                    <td><%# Eval("AvgGrade") %>%</td>
                                    <td><%# Eval("Median") %>%</td>
                                    <td><%# Eval("Highest") %>%</td>
                                    <td><%# Eval("Lowest") %>%</td>
                                    <td>
                                        <div style="display: flex; height: 20px; width: 100%; min-width: 100px; border-radius: 10px; overflow: hidden;">
                                            <div style="background-color: #4CAF50; height: 100%; width: <%# Eval("APercent") %>%;" title="A: <%# Eval("APercent") %>%"></div>
                                            <div style="background-color: #8BC34A; height: 100%; width: <%# Eval("BPercent") %>%;" title="B: <%# Eval("BPercent") %>%"></div>
                                            <div style="background-color: #FFC107; height: 100%; width: <%# Eval("CPercent") %>%;" title="C: <%# Eval("CPercent") %>%"></div>
                                            <div style="background-color: #FF9800; height: 100%; width: <%# Eval("DPercent") %>%;" title="D: <%# Eval("DPercent") %>%"></div>
                                            <div style="background-color: #F44336; height: 100%; width: <%# Eval("FPercent") %>%;" title="F: <%# Eval("FPercent") %>%"></div>
                                        </div>
                                    </td>
                                </tr>
                            </ItemTemplate>
                        </asp:Repeater>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
    
    <!-- Chart tooltip container -->
    <div id="chartTooltip" class="chart-tooltip"></div>
    
    <!-- Messages -->
    <asp:Label ID="lblMessage" runat="server" Text="" style="display: block; margin: 1rem 0;"></asp:Label>
</section>

<footer class="footer">
   &copy; copyright @ 2025 by <span>Stanley Nilam</span> | all rights reserved!
</footer>

<script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/3.7.1/chart.min.js"></script>
<script>
    // Global variables
    let performanceChart = null;
    let assignmentChart = null;
    let engagementChart = null;
    let gradeDistributionChart = null;
    let gradeTrendsChart = null;
    
    // Initialize when DOM is ready
    document.addEventListener('DOMContentLoaded', function() {
        // Initialize UI components
        initializeSidebar();
        initializeTabs();
        initializeProgressBars();
        
        // Initialize charts
        initializeCharts();
        
        // Show any messages
        showMessages();
    });
    
    // Initialize sidebar functionality
    function initializeSidebar() {
        let body = document.body;
        let profile = document.querySelector('.header .flex .profile');
        let search = document.querySelector('.header .flex .search-form');
        let sideBar = document.querySelector('.side-bar');
        
        document.querySelector('#user-btn')?.addEventListener('click', () => {
            profile?.classList.toggle('active');
            search?.classList.remove('active');
        });
        
        document.querySelector('#search-btn')?.addEventListener('click', () => {
            search?.classList.toggle('active');
            profile?.classList.remove('active');
        });
        
        document.querySelector('#menu-btn')?.addEventListener('click', () => {
            sideBar?.classList.toggle('active');
            body?.classList.toggle('active');
        });
        
        document.querySelector('#close-btn')?.addEventListener('click', () => {
            sideBar?.classList.remove('active');
            body?.classList.remove('active');
        });
        
        document.querySelector('#toggle-btn')?.addEventListener('click', () => {
            body?.classList.toggle('dark');
            updateChartsTheme();
        });
        
        window.addEventListener('scroll', () => {
            profile?.classList.remove('active');
            search?.classList.remove('active');
            
            if (window.innerWidth < 1200) {
                sideBar?.classList.remove('active');
                body?.classList.remove('active');
            }
        });
    }
    
    // Initialize tabs functionality
    function initializeTabs() {
        const tabs = document.querySelectorAll('.tab');
        const tabContents = document.querySelectorAll('.tab-content');
        
        tabs.forEach(tab => {
            tab.addEventListener('click', () => {
                const tabId = tab.getAttribute('data-tab');
                
                // Remove active class from all tabs and contents
                tabs.forEach(t => t.classList.remove('active'));
                tabContents.forEach(c => c.classList.remove('active'));
                
                // Add active class to selected tab and content
                tab.classList.add('active');
                document.getElementById(tabId).classList.add('active');
                
                // Redraw charts when tab is shown to fix rendering issues
                setTimeout(() => {
                    if (tabId === 'student-performance' && performanceChart) {
                        performanceChart.resize();
                    } else if (tabId === 'assignment-analytics' && assignmentChart) {
                        assignmentChart.resize();
                    } else if (tabId === 'course-engagement' && engagementChart) {
                        engagementChart.resize();
                    } else if (tabId === 'grade-distribution') {
                        if (gradeDistributionChart) gradeDistributionChart.resize();
                        if (gradeTrendsChart) gradeTrendsChart.resize();
                    }
                }, 50);
            });
        });
    }
    
    // Initialize progress bars
    function initializeProgressBars() {
        // Set width of completion rate progress bar
        const completionRateBar = document.getElementById('completionRateBar');
        const completionRateText = document.querySelector('#lblCompletionRate').textContent;
        const completionRateValue = parseInt(completionRateText) || 0;
        
        if (completionRateBar) {
            completionRateBar.style.width = completionRateValue + '%';
        }
        
        // Set width of average grade progress bar
        const averageGradeBar = document.getElementById('averageGradeBar');
        const averageGradeText = document.querySelector('#lblAverageGrade').textContent;
        const averageGradeValue = parseInt(averageGradeText) || 0;
        
        if (averageGradeBar) {
            averageGradeBar.style.width = averageGradeValue + '%';
        }
        
        // Set width of late submissions progress bar
        const lateSubmissionsBar = document.getElementById('lateSubmissionsBar');
        const lateSubmissionsText = document.querySelector('#lblLateSubmissions').textContent;
        const lateSubmissionsValue = parseInt(lateSubmissionsText) || 0;
        
        if (lateSubmissionsBar) {
            lateSubmissionsBar.style.width = lateSubmissionsValue + '%';
        }
        
        // Set width of active students progress bar
        const activeStudentsBar = document.getElementById('activeStudentsBar');
        const activeStudentsText = document.querySelector('#lblActiveStudents').textContent;
        const activeStudentsValue = parseInt(activeStudentsText) || 0;
        
        if (activeStudentsBar) {
            activeStudentsBar.style.width = activeStudentsValue + '%';
        }
    }
    
    // Initialize charts
    function initializeCharts() {
        // Get theme colors based on current theme
        const isDarkMode = document.body.classList.contains('dark');
        const textColor = isDarkMode ? '#e6e6e6' : '#333';
        const gridColor = isDarkMode ? 'rgba(255, 255, 255, 0.1)' : 'rgba(0, 0, 0, 0.1)';
        
        // Common chart options
        const commonOptions = {
            responsive: true,
            maintainAspectRatio: false,
            animation: {
                duration: 1000,
                easing: 'easeOutQuart'
            },
            plugins: {
                legend: {
                    labels: {
                        color: textColor,
                        font: {
                            size: 14
                        }
                    }
                },
                tooltip: {
                    backgroundColor: isDarkMode ? 'rgba(0, 0, 0, 0.8)' : 'rgba(255, 255, 255, 0.8)',
                    titleColor: isDarkMode ? '#fff' : '#333',
                    bodyColor: isDarkMode ? '#e6e6e6' : '#555',
                    borderColor: isDarkMode ? '#555' : '#ddd',
                    borderWidth: 1,
                    padding: 12,
                    cornerRadius: 6,
                    displayColors: true,
                    usePointStyle: true,
                    boxPadding: 6
                }
            },
            scales: {
                x: {
                    grid: {
                        color: gridColor
                    },
                    ticks: {
                        color: textColor
                    }
                },
                y: {
                    beginAtZero: true,
                    grid: {
                        color: gridColor
                    },
                    ticks: {
                        color: textColor
                    }
                }
            }
        };
        
        // Student Performance Chart
        const performanceCtx = document.getElementById('performanceChart');
        if (performanceCtx) {
            // Remove loading indicator
            performanceCtx.innerHTML = '';
            
            performanceChart = new Chart(performanceCtx, {
                type: 'line',
                data: {
                    labels: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun'],
                    datasets: [{
                        label: 'Average Grade',
                        data: [75, 78, 72, 80, 82, 85],
                        backgroundColor: 'rgba(75, 192, 192, 0.2)',
                        borderColor: 'rgba(75, 192, 192, 1)',
                        borderWidth: 3,
                        tension: 0.4,
                        pointBackgroundColor: 'rgba(75, 192, 192, 1)',
                        pointBorderColor: '#fff',
                        pointRadius: 5,
                        pointHoverRadius: 7
                    }]
                },
                options: {
                    ...commonOptions,
                    plugins: {
                        ...commonOptions.plugins,
                        title: {
                            display: true,
                            text: 'Student Performance Trends',
                            color: textColor,
                            font: {
                                size: 18,
                                weight: 'bold'
                            },
                            padding: {
                                bottom: 20
                            }
                        }
                    }
                }
            });
        }
        
        // Assignment Completion Chart
        const assignmentCtx = document.getElementById('assignmentChart');
        if (assignmentCtx) {
            // Remove loading indicator
            assignmentCtx.innerHTML = '';
            
            assignmentChart = new Chart(assignmentCtx, {
                type: 'bar',
                data: {
                    labels: ['Assignment 1', 'Assignment 2', 'Assignment 3', 'Assignment 4', 'Assignment 5'],
                    datasets: [{
                        label: 'Completion Rate (%)',
                        data: [95, 82, 78, 90, 65],
                        backgroundColor: 'rgba(54, 162, 235, 0.6)',
                        borderColor: 'rgba(54, 162, 235, 1)',
                        borderWidth: 1,
                        borderRadius: 5,
                        maxBarThickness: 50
                    }]
                },
                options: {
                    ...commonOptions,
                    plugins: {
                        ...commonOptions.plugins,
                        title: {
                            display: true,
                            text: 'Assignment Completion Rates',
                            color: textColor,
                            font: {
                                size: 18,
                                weight: 'bold'
                            },
                            padding: {
                                bottom: 20
                            }
                        }
                    }
                }
            });
        }
        
        // Course Engagement Chart
        const engagementCtx = document.getElementById('engagementChart');
        if (engagementCtx) {
            // Remove loading indicator
            engagementCtx.innerHTML = '';
            
            engagementChart = new Chart(engagementCtx, {
                type: 'radar',
                data: {
                    labels: ['Assignments Completed', 'Participation', 'On-Time Submissions', 'Above Avg. Grades', 'Resource Access'],
                    datasets: [{
                        label: 'Course A',
                        data: [85, 70, 90, 60, 75],
                        backgroundColor: 'rgba(255, 99, 132, 0.2)',
                        borderColor: 'rgba(255, 99, 132, 1)',
                        borderWidth: 2,
                        pointBackgroundColor: 'rgba(255, 99, 132, 1)',
                        pointBorderColor: '#fff'
                    },
                    {
                        label: 'Course B',
                        data: [65, 85, 70, 75, 80],
                        backgroundColor: 'rgba(54, 162, 235, 0.2)',
                        borderColor: 'rgba(54, 162, 235, 1)',
                        borderWidth: 2,
                        pointBackgroundColor: 'rgba(54, 162, 235, 1)',
                        pointBorderColor: '#fff'
                    }]
                },
                options: {
                    ...commonOptions,
                    scales: {
                        r: {
                            angleLines: {
                                color: gridColor
                            },
                            grid: {
                                color: gridColor
                            },
                            pointLabels: {
                                color: textColor,
                                font: {
                                    size: 12
                                }
                            },
                            suggestedMin: 0,
                            suggestedMax: 100,
                            ticks: {
                                color: textColor,
                                backdropColor: isDarkMode ? 'rgba(0, 0, 0, 0.3)' : 'rgba(255, 255, 255, 0.3)'
                            }
                        }
                    }
                }
            });
        }
        
        // Grade Distribution Chart
        const gradeDistributionCtx = document.getElementById('gradeDistributionChart');
        if (gradeDistributionCtx) {
            // Remove loading indicator
            gradeDistributionCtx.innerHTML = '';
            
            gradeDistributionChart = new Chart(gradeDistributionCtx, {
                type: 'bar',
                data: {
                    labels: ['F (0-49%)', 'D (50-59%)', 'C (60-69%)', 'B (70-84%)', 'A (85-100%)'],
                    datasets: [{
                        label: 'Number of Students',
                        data: [5, 10, 25, 35, 25],
                        backgroundColor: [
                            'rgba(255, 99, 132, 0.6)',
                            'rgba(255, 159, 64, 0.6)',
                            'rgba(255, 205, 86, 0.6)',
                            'rgba(75, 192, 192, 0.6)',
                            'rgba(54, 162, 235, 0.6)'
                        ],
                        borderColor: [
                            'rgb(255, 99, 132)',
                            'rgb(255, 159, 64)',
                            'rgb(255, 205, 86)',
                            'rgb(75, 192, 192)',
                            'rgb(54, 162, 235)'
                        ],
                        borderWidth: 1,
                        borderRadius: 5,
                        maxBarThickness: 60
                    }]
                },
                options: {
                    ...commonOptions,
                    plugins: {
                        ...commonOptions.plugins,
                        title: {
                            display: true,
                            text: 'Grade Distribution',
                            color: textColor,
                            font: {
                                size: 18,
                                weight: 'bold'
                            },
                            padding: {
                                bottom: 20
                            }
                        }
                    }
                }
            });
        }
        
        // Grade Trends Chart
        const gradeTrendsCtx = document.getElementById('gradeTrendsChart');
        if (gradeTrendsCtx) {
            // Remove loading indicator
            gradeTrendsCtx.innerHTML = '';
            
            gradeTrendsChart = new Chart(gradeTrendsCtx, {
                type: 'line',
                data: {
                    labels: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun'],
                    datasets: [{
                        label: 'A Grades',
                        data: [15, 18, 20, 25, 23, 28],
                        backgroundColor: 'rgba(54, 162, 235, 0.2)',
                        borderColor: 'rgba(54, 162, 235, 1)',
                        borderWidth: 2,
                        tension: 0.4
                    },
                    {
                        label: 'B Grades',
                        data: [30, 32, 28, 30, 35, 32],
                        backgroundColor: 'rgba(75, 192, 192, 0.2)',
                        borderColor: 'rgba(75, 192, 192, 1)',
                        borderWidth: 2,
                        tension: 0.4
                    },
                    {
                        label: 'C Grades',
                        data: [25, 22, 25, 20, 18, 15],
                        backgroundColor: 'rgba(255, 205, 86, 0.2)',
                        borderColor: 'rgba(255, 205, 86, 1)',
                        borderWidth: 2,
                        tension: 0.4
                    },
                    {
                        label: 'D/F Grades',
                        data: [30, 28, 27, 25, 24, 20],
                        backgroundColor: 'rgba(255, 99, 132, 0.2)',
                        borderColor: 'rgba(255, 99, 132, 1)',
                        borderWidth: 2,
                        tension: 0.4
                    }]
                },
                options: {
                    ...commonOptions,
                    plugins: {
                        ...commonOptions.plugins,
                        title: {
                            display: true,
                            text: 'Grade Trends Over Time',
                            color: textColor,
                            font: {
                                size: 18,
                                weight: 'bold'
                            },
                            padding: {
                                bottom: 20
                            }
                        }
                    }
                }
            });
        }
    }
    
    // Update charts theme when switching between light/dark mode
    function updateChartsTheme() {
        const isDarkMode = document.body.classList.contains('dark');
        const textColor = isDarkMode ? '#e6e6e6' : '#333';
        const gridColor = isDarkMode ? 'rgba(255, 255, 255, 0.1)' : 'rgba(0, 0, 0, 0.1)';
        
        const updateChartTheme = (chart) => {
            if (!chart) return;
            
            // Update tooltip style
            chart.options.plugins.tooltip.backgroundColor = isDarkMode ? 'rgba(0, 0, 0, 0.8)' : 'rgba(255, 255, 255, 0.8)';
            chart.options.plugins.tooltip.titleColor = isDarkMode ? '#fff' : '#333';
            chart.options.plugins.tooltip.bodyColor = isDarkMode ? '#e6e6e6' : '#555';
            chart.options.plugins.tooltip.borderColor = isDarkMode ? '#555' : '#ddd';
            
            // Update legend style
            if (chart.options.plugins.legend) {
                chart.options.plugins.legend.labels.color = textColor;
            }
            
            // Update title style
            if (chart.options.plugins.title) {
                chart.options.plugins.title.color = textColor;
            }
            
            // Update scale colors
            if (chart.options.scales.x) {
                chart.options.scales.x.grid.color = gridColor;
                chart.options.scales.x.ticks.color = textColor;
            }
            
            if (chart.options.scales.y) {
                chart.options.scales.y.grid.color = gridColor;
                chart.options.scales.y.ticks.color = textColor;
            }
            
            if (chart.options.scales.r) {
                chart.options.scales.r.grid.color = gridColor;
                chart.options.scales.r.angleLines.color = gridColor;
                chart.options.scales.r.pointLabels.color = textColor;
                chart.options.scales.r.ticks.color = textColor;
                chart.options.scales.r.ticks.backdropColor = isDarkMode ? 'rgba(0, 0, 0, 0.3)' : 'rgba(255, 255, 255, 0.3)';
            }
            
            chart.update();
        };
        
        // Update each chart
        updateChartTheme(performanceChart);
        updateChartTheme(assignmentChart);
        updateChartTheme(engagementChart);
        updateChartTheme(gradeDistributionChart);
        updateChartTheme(gradeTrendsChart);
    }
    
    // Show any messages
    function showMessages() {
        const messageEl = document.getElementById('<%= lblMessage.ClientID %>');
        if (messageEl && messageEl.innerText.trim()) {
            messageEl.style.display = 'block';
            setTimeout(() => {
                messageEl.style.display = 'none';
            }, 5000);
        }
    }
</script>

    </form>
</body>
</html>