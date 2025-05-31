<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="homeWebform.aspx.cs" Inherits="assignmentDraft1.homeWebform" %>

<!DOCTYPE html>
<html lang="en">
<head>
   <meta charset="UTF-8">
   <meta http-equiv="X-UA-Compatible" content="IE=edge">
   <meta name="viewport" content="width=device-width, initial-scale=1.0">
   <title>Student Dashboard - Bulb LMS</title>
   <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.1.2/css/all.min.css">
   <link rel="stylesheet" href="css/style.css">

   <style>
      /* Enhanced Dashboard Styles */
      .dashboard-stats {
         display: grid;
         grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
         gap: 2rem;
         margin-bottom: 3rem;
      }

      .stat-card {
         background: linear-gradient(135deg, var(--main-color), var(--orange));
         color: white !important;
         padding: 2.5rem 2rem;
         border-radius: 1.2rem;
         box-shadow: 0 6px 20px rgba(0,0,0,0.15);
         transition: transform 0.3s ease, box-shadow 0.3s ease;
         position: relative;
         overflow: hidden;
         border: none;
         min-height: 140px;
         display: flex;
         flex-direction: column;
         justify-content: space-between;
      }

      .stat-card::before {
         content: '';
         position: absolute;
         top: 0;
         left: 0;
         right: 0;
         bottom: 0;
         background: rgba(0, 0, 0, 0.05);
         z-index: 1;
      }

      .stat-card * {
         position: relative;
         z-index: 2;
         color: white !important;
      }

      .stat-card:hover {
         transform: translateY(-8px);
         box-shadow: 0 12px 30px rgba(0,0,0,0.25);
      }

      .stat-card:nth-child(2) {
         background: linear-gradient(135deg, #3498db, #2980b9);
      }

      .stat-card:nth-child(3) {
         background: linear-gradient(135deg, #27ae60, #229954);
      }

      .stat-card:nth-child(4) {
         background: linear-gradient(135deg, #e74c3c, #c0392b);
      }

      .stat-header {
         display: flex;
         justify-content: space-between;
         align-items: flex-start;
         margin-bottom: 0.5rem;
      }

      .stat-number {
         font-size: 3.5rem;
         font-weight: 900;
         line-height: 1;
         color: white !important;
         text-shadow: 0 3px 6px rgba(0,0,0,0.4);
         margin: 0;
      }

      .stat-label {
         font-size: 1.3rem;
         font-weight: 600;
         color: white !important;
         text-shadow: 0 2px 4px rgba(0,0,0,0.4);
         margin-top: 0.8rem;
         opacity: 0.95;
      }

      .stat-icon {
         font-size: 2.8rem;
         color: white !important;
         text-shadow: 0 2px 4px rgba(0,0,0,0.4);
         opacity: 0.9;
      }

      /* Enhanced Timeline */
      .timeline-box {
         background: white;
         border-radius: 1rem;
         box-shadow: 0 4px 15px rgba(0,0,0,0.1);
         overflow: hidden;
      }

      .timeline-header {
         background: linear-gradient(135deg, var(--main-color), var(--orange));
         color: white;
         padding: 1.5rem 2rem;
         display: flex;
         justify-content: space-between;
         align-items: center;
      }

      .timeline-filters {
         background: #f8f9fa;
         padding: 1.5rem 2rem;
         border-bottom: 1px solid #eee;
         display: grid;
         grid-template-columns: 2fr 1fr 1.5fr;
         gap: 2rem;
         align-items: start;
      }

      .filter-group {
         display: flex;
         flex-direction: column;
         gap: 0.8rem;
      }

      .filter-label {
         font-size: 1.2rem;
         font-weight: bold;
         color: var(--black);
         margin-bottom: 0.5rem;
      }

      .quick-filters {
         display: flex;
         gap: 0.5rem;
         flex-wrap: wrap;
      }

      .quick-filter {
         padding: 0.6rem 1.2rem;
         background: white;
         border: 2px solid #e1e5e9;
         border-radius: 2rem;
         cursor: pointer;
         transition: all 0.3s;
         font-size: 1.1rem;
         font-weight: 500;
         white-space: nowrap;
      }

      .quick-filter:hover, .quick-filter.active {
         background: var(--main-color);
         color: white;
         border-color: var(--main-color);
         transform: translateY(-1px);
      }

      /* Improved form controls */
      .timeline-filters select {
         width: 100%;
         padding: 0.8rem 1rem;
         border: 2px solid #e1e5e9;
         border-radius: 0.5rem;
         font-size: 1.2rem;
         background: white;
         cursor: pointer;
         transition: all 0.3s;
      }

      .timeline-filters select:focus {
         outline: none;
         border-color: var(--main-color);
         box-shadow: 0 0 0 3px rgba(139, 69, 19, 0.1);
      }

      .timeline-filters input[type="text"] {
         width: 100%;
         padding: 0.8rem 1rem;
         border: 2px solid #e1e5e9;
         border-radius: 0.5rem;
         font-size: 1.2rem;
         background: white;
         transition: all 0.3s;
      }

      .timeline-filters input[type="text"]:focus {
         outline: none;
         border-color: var(--main-color);
         box-shadow: 0 0 0 3px rgba(139, 69, 19, 0.1);
      }

      .timeline-filters input[type="text"]::placeholder {
         color: #999;
         font-style: italic;
      }

      /* Enhanced Assignment Cards */
      .assignment-grid {
         display: grid;
         grid-template-columns: repeat(auto-fill, minmax(350px, 1fr));
         gap: 1.5rem;
         padding: 2rem;
      }

      .assignment-card {
         background: white;
         border-radius: 1rem;
         box-shadow: 0 4px 15px rgba(0,0,0,0.1);
         overflow: hidden;
         transition: transform 0.3s ease, box-shadow 0.3s ease;
         border-left: 5px solid var(--main-color);
      }

      .assignment-card:hover {
         transform: translateY(-3px);
         box-shadow: 0 8px 25px rgba(0,0,0,0.15);
      }

      .assignment-card.overdue {
         border-left-color: #e74c3c;
      }

      .assignment-card.due-soon {
         border-left-color: #f39c12;
      }

      .assignment-card.submitted {
         border-left-color: #27ae60;
      }

      .assignment-header {
         padding: 1.5rem;
         border-bottom: 1px solid #f0f0f0;
      }

      .assignment-title {
         font-size: 1.6rem;
         font-weight: bold;
         color: var(--black);
         margin: 0 0 0.5rem 0;
      }

      .assignment-course {
         color: var(--main-color);
         font-weight: 600;
         font-size: 1.2rem;
      }

      .assignment-body {
         padding: 1.5rem;
      }

      .assignment-meta {
         display: grid;
         grid-template-columns: 1fr 1fr;
         gap: 1rem;
         margin-bottom: 1.5rem;
      }

      .meta-item {
         display: flex;
         align-items: center;
         gap: 0.5rem;
         font-size: 1.1rem;
      }

      .meta-icon {
         color: var(--main-color);
         width: 16px;
      }

      .status-badge {
         display: inline-flex;
         align-items: center;
         gap: 0.5rem;
         padding: 0.5rem 1rem;
         border-radius: 2rem;
         font-weight: bold;
         font-size: 1.1rem;
         margin-bottom: 1rem;
      }

      .status-pending {
         background: #fff3cd;
         color: #856404;
      }

      .status-submitted {
         background: #d4edda;
         color: #155724;
      }

      .status-overdue {
         background: #f8d7da;
         color: #721c24;
      }

      .status-graded {
         background: #d1ecf1;
         color: #0c5460;
      }

      .grade-display {
         background: #f8f9fa;
         padding: 1rem;
         border-radius: 0.5rem;
         margin-bottom: 1rem;
         text-align: center;
      }

      .grade-score {
         font-size: 1.8rem;
         font-weight: bold;
         color: var(--main-color);
      }

      .assignment-actions {
         display: flex;
         gap: 0.5rem;
         justify-content: flex-end;
      }

      /* Enhanced Course Section */
      .course-grid {
         display: grid;
         grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
         gap: 2rem;
         margin-top: 2rem;
      }

      .course-card {
         background: white;
         border-radius: 1rem;
         box-shadow: 0 4px 15px rgba(0,0,0,0.1);
         overflow: hidden;
         transition: transform 0.3s ease;
      }

      .course-card:hover {
         transform: translateY(-5px);
      }

      .course-header {
         background: linear-gradient(135deg, #3498db, #2980b9);
         color: white;
         padding: 1.5rem;
      }

      .course-title {
         font-size: 1.6rem;
         font-weight: bold;
         margin: 0 0 0.5rem 0;
      }

      .course-lecturer {
         display: flex;
         align-items: center;
         gap: 0.5rem;
         opacity: 0.9;
      }

      .course-body {
         padding: 1.5rem;
      }

      .course-progress {
         margin: 1rem 0;
      }

      .progress-bar {
         background: #e9ecef;
         border-radius: 1rem;
         height: 8px;
         overflow: hidden;
      }

      .progress-fill {
         background: linear-gradient(90deg, var(--main-color), var(--orange));
         height: 100%;
         border-radius: 1rem;
         transition: width 0.5s ease;
      }

      .progress-text {
         font-size: 1.1rem;
         color: var(--light-color);
         margin-top: 0.5rem;
      }

      /* Quick Actions */
      .quick-actions {
         position: fixed;
         bottom: 2rem;
         right: 2rem;
         z-index: 1000;
      }

      .quick-action-btn {
         display: flex;
         align-items: center;
         justify-content: center;
         width: 60px;
         height: 60px;
         background: var(--main-color);
         color: white;
         border-radius: 50%;
         box-shadow: 0 4px 15px rgba(0,0,0,0.2);
         transition: all 0.3s ease;
         margin-bottom: 1rem;
         text-decoration: none;
         font-size: 1.5rem;
      }

      .quick-action-btn:hover {
         transform: scale(1.1);
         box-shadow: 0 6px 20px rgba(0,0,0,0.3);
      }

      /* Welcome Section */
      .welcome-section {
         background: linear-gradient(135deg, var(--main-color), var(--orange));
         color: white;
         padding: 3rem 2rem;
         border-radius: 1rem;
         margin-bottom: 3rem;
         text-align: center;
         position: relative;
         overflow: hidden;
      }

      .welcome-section::before {
         content: '';
         position: absolute;
         top: 0;
         left: 0;
         right: 0;
         bottom: 0;
         background: rgba(0, 0, 0, 0.1);
         z-index: 1;
      }

      .welcome-section > * {
         position: relative;
         z-index: 2;
      }

      .welcome-title {
         font-size: 2.8rem;
         margin: 0 0 1rem 0;
         text-shadow: 0 2px 4px rgba(0,0,0,0.3);
         font-weight: 700;
      }

      .welcome-subtitle {
         font-size: 1.4rem;
         text-shadow: 0 1px 2px rgba(0,0,0,0.3);
         margin: 0;
         font-weight: 400;
      }

      .current-time {
         font-size: 1.2rem;
         opacity: 0.9;
         margin-top: 1.5rem;
         text-shadow: 0 1px 2px rgba(0,0,0,0.3);
         font-weight: 500;
      }

      /* Empty States */
      .empty-state {
         text-align: center;
         padding: 4rem 2rem;
         color: var(--light-color);
      }

      .empty-icon {
         font-size: 4rem;
         margin-bottom: 1rem;
         opacity: 0.5;
      }

      .empty-title {
         font-size: 1.8rem;
         margin-bottom: 0.5rem;
         color: var(--black);
      }

      .empty-text {
         font-size: 1.2rem;
         line-height: 1.6;
      }

      /* Responsive Design */
      @media (max-width: 768px) {
         .dashboard-stats {
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 1.5rem;
         }

         .stat-card {
            padding: 2rem 1.5rem;
            min-height: 120px;
         }

         .stat-number {
            font-size: 2.8rem;
         }

         .stat-label {
            font-size: 1.2rem;
         }

         .stat-icon {
            font-size: 2.3rem;
         }

         .timeline-filters {
            grid-template-columns: 1fr;
            gap: 1.5rem;
         }

         .quick-filters {
            justify-content: center;
         }

         .assignment-grid {
            grid-template-columns: 1fr;
            padding: 1rem;
         }

         .assignment-meta {
            grid-template-columns: 1fr;
         }

         .course-grid {
            grid-template-columns: 1fr;
         }

         .quick-actions {
            bottom: 1rem;
            right: 1rem;
         }

         .welcome-title {
            font-size: 2.2rem;
         }
      }

      @media (max-width: 480px) {
         .dashboard-stats {
            grid-template-columns: 1fr;
         }

         .stat-card {
            padding: 1.8rem 1.2rem;
            min-height: 110px;
         }

         .stat-number {
            font-size: 2.5rem;
         }

         .stat-label {
            font-size: 1.1rem;
         }

         .stat-icon {
            font-size: 2rem;
         }

         .timeline-filters {
            padding: 1rem;
         }

         .quick-filter {
            padding: 0.5rem 0.8rem;
            font-size: 1rem;
         }

         .filter-label {
            font-size: 1.1rem;
         }

         .timeline-filters select,
         .timeline-filters input[type="text"] {
            font-size: 1.1rem;
            padding: 0.7rem;
         }

         .welcome-title {
            font-size: 1.8rem;
         }

         .welcome-subtitle {
            font-size: 1.2rem;
         }
      }

      /* Animation Classes */
      .fade-in {
         animation: fadeIn 0.6s ease-in-out;
      }

      @keyframes fadeIn {
         from { 
            opacity: 0; 
            transform: translateY(30px); 
         }
         to { 
            opacity: 1; 
            transform: translateY(0); 
         }
      }

      .slide-in {
         animation: slideIn 0.4s ease-out;
      }

      @keyframes slideIn {
         from { 
            transform: translateX(-30px); 
            opacity: 0; 
         }
         to { 
            transform: translateX(0); 
            opacity: 1; 
         }
      }

      /* Stagger animation delays */
      .stat-card:nth-child(1) { animation-delay: 0.1s; }
      .stat-card:nth-child(2) { animation-delay: 0.2s; }
      .stat-card:nth-child(3) { animation-delay: 0.3s; }
      .stat-card:nth-child(4) { animation-delay: 0.4s; }

      .assignment-card:nth-child(1) { animation-delay: 0.1s; }
      .assignment-card:nth-child(2) { animation-delay: 0.2s; }
      .assignment-card:nth-child(3) { animation-delay: 0.3s; }
      .assignment-card:nth-child(4) { animation-delay: 0.4s; }
      .assignment-card:nth-child(5) { animation-delay: 0.5s; }
   </style>
</head>
<body>
    <form id="form1" runat="server">

<header class="header">
   <section class="flex">
      <a href="homeWebform.aspx" class="logo">Bulb</a>

      <asp:Panel runat="server" CssClass="search-form">
          <asp:TextBox ID="txtSearch" runat="server" CssClass="search-input" placeholder="Search courses, assignments..." MaxLength="100" />
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
         <h3 class="name"><asp:Label ID="lblName" runat="server" Text="Student Name"></asp:Label></h3>
         <p class="role"><asp:Label ID="lblRole" runat="server" Text="student"></asp:Label></p>
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
      <a href="courses.html"><i class="fas fa-graduation-cap"></i><span>My Courses</span></a>
      <a href="assignments.html"><i class="fas fa-tasks"></i><span>Assignments</span></a>
      <a href="grades.html"><i class="fas fa-star"></i><span>Grades</span></a>
      <a href="calendar.html"><i class="fas fa-calendar"></i><span>Calendar</span></a>
      <a href="profile.aspx"><i class="fas fa-user"></i><span>Profile</span></a>
      <a href="loginWebform.aspx"><i class="fas fa-sign-out-alt"></i><span>Logout</span></a>
   </nav>
</div>

<section class="home-grid">
    <!-- Welcome Section -->
    <div class="welcome-section fade-in">
        <h1 class="welcome-title">
            <i class="fas fa-sun"></i> Good <span id="timeOfDay">Morning</span>, <asp:Label ID="lblWelcomeName" runat="server" Text="Student"></asp:Label>!
        </h1>
        <p class="welcome-subtitle">Ready to continue your learning journey?</p>
        <div class="current-time" id="currentDateTime"></div>
    </div>

    <!-- Dashboard Statistics -->
    <div class="dashboard-stats fade-in">
        <div class="stat-card">
            <div class="stat-header">
                <div>
                    <div class="stat-number" id="totalAssignments">0</div>
                    <div class="stat-label">Total Assignments</div>
                </div>
                <div class="stat-icon">
                    <i class="fas fa-tasks"></i>
                </div>
            </div>
        </div>

        <div class="stat-card">
            <div class="stat-header">
                <div>
                    <div class="stat-number" id="pendingAssignments">0</div>
                    <div class="stat-label">Pending</div>
                </div>
                <div class="stat-icon">
                    <i class="fas fa-clock"></i>
                </div>
            </div>
        </div>

        <div class="stat-card">
            <div class="stat-header">
                <div>
                    <div class="stat-number" id="completedAssignments">0</div>
                    <div class="stat-label">Completed</div>
                </div>
                <div class="stat-icon">
                    <i class="fas fa-check-circle"></i>
                </div>
            </div>
        </div>

        <div class="stat-card">
            <div class="stat-header">
                <div>
                    <div class="stat-number" id="averageGrade">0%</div>
                    <div class="stat-label">Average Grade</div>
                </div>
                <div class="stat-icon">
                    <i class="fas fa-star"></i>
                </div>
            </div>
        </div>
    </div>

    <!-- Timeline Section -->
    <div class="timeline-box box fade-in">
        <div class="timeline-header">
            <h1><i class="fas fa-timeline"></i> Assignment Timeline</h1>
            <div id="lastUpdated">Updated: <span id="updateTime"></span></div>
        </div>

        <div class="timeline-filters">
            <div class="filter-group">
                <label class="filter-label">Filter by Status:</label>
                <div class="quick-filters">
                    <div class="quick-filter active" data-filter="all">All</div>
                    <div class="quick-filter" data-filter="pending">Pending</div>
                    <div class="quick-filter" data-filter="submitted">Submitted</div>
                    <div class="quick-filter" data-filter="overdue">Overdue</div>
                    <div class="quick-filter" data-filter="graded">Graded</div>
                </div>
            </div>

            <div class="filter-group">
                <label class="filter-label">Sort by:</label>
                <select class="box select" id="sortSelect">
                    <option value="dueDate">Due Date</option>
                    <option value="course">Course</option>
                    <option value="status">Status</option>
                    <option value="created">Recently Added</option>
                </select>
            </div>

            <div class="filter-group">
                <label class="filter-label">Search:</label>
                <input type="text" class="box search-input" id="assignmentSearch" placeholder="Search assignments..." />
            </div>
        </div>

        <!-- Assignment Grid -->
        <div class="assignment-grid" id="assignmentGrid">
            <asp:Repeater ID="assignmentRepeater" runat="server">
                <ItemTemplate>
                    <div class="assignment-card slide-in" 
                         data-status='<%# Eval("Status").ToString().ToLower() %>'
                         data-course='<%# Eval("CourseName") %>'
                         data-due='<%# Eval("DueDate", "{0:yyyy-MM-dd}") %>'>
                        
                        <div class="assignment-header">
                            <h3 class="assignment-title"><%# Eval("Title") %></h3>
                            <div class="assignment-course"><%# Eval("CourseName") %></div>
                        </div>

                        <div class="assignment-body">
                            <div class="status-badge status-<%# Eval("Status").ToString().ToLower().Replace(" ", "-") %>">
                                <i class="fas <%# GetStatusIcon(Eval("Status")) %>"></i>
                                <%# Eval("Status") %>
                            </div>

                            <%# Eval("PointsEarned") != DBNull.Value ? GetGradeDisplay(Eval("PointsEarned"), Eval("MaxPoints")) : "" %>

                            <div class="assignment-meta">
                                <div class="meta-item">
                                    <i class="fas fa-calendar meta-icon"></i>
                                    <span>Due: <%# Eval("DueDate", "{0:MMM dd, yyyy}") %></span>
                                </div>
                                <div class="meta-item">
                                    <i class="fas fa-clock meta-icon"></i>
                                    <span><%# GetTimeRemaining(Eval("DueDate"), Eval("Status")) %></span>
                                </div>
                                <div class="meta-item">
                                    <i class="fas fa-star meta-icon"></i>
                                    <span><%# Eval("MaxPoints") %> points</span>
                                </div>
                                <div class="meta-item">
                                    <i class="fas fa-info-circle meta-icon"></i>
                                    <span><%# GetStatusDescription(Eval("Status")) %></span>
                                </div>
                            </div>

                            <div class="assignment-actions">
                                <a href='assignment-details.aspx?assignmentID=<%# Eval("AssignmentID") %>' 
                                   class="inline-btn">
                                    <i class="fas fa-eye"></i> View Details
                                </a>
                            </div>
                        </div>
                    </div>
                </ItemTemplate>
            </asp:Repeater>
        </div>

        <!-- Empty State -->
        <asp:Panel ID="noAssignmentsPanel" runat="server" Visible="false">
            <div class="empty-state">
                <div class="empty-icon">
                    <i class="fas fa-tasks"></i>
                </div>
                <h3 class="empty-title">No assignments yet</h3>
                <p class="empty-text">When your instructors create assignments, they'll appear here.</p>
            </div>
        </asp:Panel>
    </div>
</section>

<!-- My Courses Section -->
<section class="courses">
    <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 2rem;">
        <h1 class="heading"><i class="fas fa-graduation-cap"></i> My Courses</h1>
        <a href="courses.html" class="inline-btn">
            <i class="fas fa-plus"></i> Browse All Courses
        </a>
    </div>

    <div class="course-grid">
        <asp:Repeater ID="courseContentRepeater" runat="server">
            <ItemTemplate>
                <div class="course-card fade-in">
                    <div class="course-header">
                        <h3 class="course-title"><%# Eval("ModuleTitle") %></h3>
                        <div class="course-lecturer">
                            <i class="fas fa-user"></i>
                            <span><%# Eval("LecturerName") ?? "Instructor" %></span>
                        </div>
                    </div>
                    <div class="course-body">
                        <div class="course-progress">
                            <div class="progress-bar">
                                <div class="progress-fill" style="width: <%# GetRandomProgress() %>%"></div>
                            </div>
                            <div class="progress-text">Progress: <%# GetRandomProgress() %>% complete</div>
                        </div>
                        <div style="margin-top: 1.5rem;">
                            <a href='lessons.aspx?moduleID=<%# Eval("ModuleID") %>' class="inline-btn">
                                <i class="fas fa-play"></i> Continue Learning
                            </a>
                        </div>
                    </div>
                </div>
            </ItemTemplate>
        </asp:Repeater>

        <!-- Empty State for Courses -->
        <asp:Panel ID="noCoursesPanel" runat="server" Visible="false">
            <div class="empty-state">
                <div class="empty-icon">
                    <i class="fas fa-graduation-cap"></i>
                </div>
                <h3 class="empty-title">No courses enrolled</h3>
                <p class="empty-text">Enroll in courses to start your learning journey.</p>
                <a href="courses.html" class="inline-btn">
                    <i class="fas fa-search"></i> Browse Courses
                </a>
            </div>
        </asp:Panel>
    </div>
</section>

<!-- Quick Actions -->
<div class="quick-actions">
    <a href="assignments.html" class="quick-action-btn" title="View All Assignments">
        <i class="fas fa-tasks"></i>
    </a>
    <a href="calendar.html" class="quick-action-btn" title="View Calendar">
        <i class="fas fa-calendar"></i>
    </a>
    <a href="profile.aspx" class="quick-action-btn" title="View Profile">
        <i class="fas fa-user"></i>
    </a>
</div>

<footer class="footer">
   &copy; copyright @ 2025 by <span>Stanley Nilam</span> | all rights reserved!
</footer>

<script src="js/script.js"></script>
<script>
    // Enhanced JavaScript functionality
    document.addEventListener('DOMContentLoaded', function () {
        // Set welcome message based on time
        setWelcomeMessage();

        // Update current date/time
        updateDateTime();
        setInterval(updateDateTime, 1000);

        // Initialize assignment filtering
        initializeFiltering();

        // Calculate and display statistics
        calculateStatistics();

        // Add smooth scrolling
        addSmoothScrolling();

        // Initialize animations
        initializeAnimations();
    });

    function setWelcomeMessage() {
        const hour = new Date().getHours();
        const timeOfDayElement = document.getElementById('timeOfDay');

        if (hour < 12) {
            timeOfDayElement.textContent = 'Morning';
        } else if (hour < 17) {
            timeOfDayElement.textContent = 'Afternoon';
        } else {
            timeOfDayElement.textContent = 'Evening';
        }
    }

    function updateDateTime() {
        const now = new Date();
        const options = {
            weekday: 'long',
            year: 'numeric',
            month: 'long',
            day: 'numeric',
            hour: '2-digit',
            minute: '2-digit'
        };

        const currentDateTime = document.getElementById('currentDateTime');
        const updateTime = document.getElementById('updateTime');

        if (currentDateTime) {
            currentDateTime.textContent = now.toLocaleDateString('en-US', options);
        }

        if (updateTime) {
            updateTime.textContent = now.toLocaleTimeString('en-US', {
                hour: '2-digit',
                minute: '2-digit'
            });
        }
    }

    function initializeFiltering() {
        const quickFilters = document.querySelectorAll('.quick-filter');
        const sortSelect = document.getElementById('sortSelect');
        const searchInput = document.getElementById('assignmentSearch');
        const assignmentCards = document.querySelectorAll('.assignment-card');

        // Quick filter functionality
        quickFilters.forEach(filter => {
            filter.addEventListener('click', function () {
                quickFilters.forEach(f => f.classList.remove('active'));
                this.classList.add('active');

                const filterValue = this.getAttribute('data-filter');
                filterAssignments(filterValue);
            });
        });

        // Sort functionality
        if (sortSelect) {
            sortSelect.addEventListener('change', function () {
                sortAssignments(this.value);
            });
        }

        // Search functionality
        if (searchInput) {
            searchInput.addEventListener('input', function () {
                searchAssignments(this.value);
            });
        }
    }

    function filterAssignments(status) {
        const cards = document.querySelectorAll('.assignment-card');

        cards.forEach(card => {
            const cardStatus = card.getAttribute('data-status');

            if (status === 'all' || cardStatus === status) {
                card.style.display = 'block';
                card.classList.add('slide-in');
            } else {
                card.style.display = 'none';
                card.classList.remove('slide-in');
            }
        });

        updateEmptyState();
    }

    function sortAssignments(sortBy) {
        const container = document.getElementById('assignmentGrid');
        const cards = Array.from(container.querySelectorAll('.assignment-card'));

        cards.sort((a, b) => {
            switch (sortBy) {
                case 'dueDate':
                    return new Date(a.getAttribute('data-due')) - new Date(b.getAttribute('data-due'));
                case 'course':
                    return a.getAttribute('data-course').localeCompare(b.getAttribute('data-course'));
                case 'status':
                    return a.getAttribute('data-status').localeCompare(b.getAttribute('data-status'));
                default:
                    return 0;
            }
        });

        // Reorder DOM elements
        cards.forEach(card => container.appendChild(card));
    }

    function searchAssignments(query) {
        const cards = document.querySelectorAll('.assignment-card');
        const searchTerm = query.toLowerCase();

        cards.forEach(card => {
            const title = card.querySelector('.assignment-title').textContent.toLowerCase();
            const course = card.querySelector('.assignment-course').textContent.toLowerCase();

            if (title.includes(searchTerm) || course.includes(searchTerm)) {
                card.style.display = 'block';
            } else {
                card.style.display = 'none';
            }
        });

        updateEmptyState();
    }

    function updateEmptyState() {
        const visibleCards = document.querySelectorAll('.assignment-card[style*="block"], .assignment-card:not([style*="none"])');
        const emptyState = document.querySelector('.empty-state');

        if (visibleCards.length === 0 && emptyState) {
            emptyState.style.display = 'block';
        } else if (emptyState) {
            emptyState.style.display = 'none';
        }
    }

    function calculateStatistics() {
        const cards = document.querySelectorAll('.assignment-card');
        let total = cards.length;
        let pending = 0;
        let completed = 0;
        let gradeSum = 0;
        let gradeCount = 0;

        cards.forEach(card => {
            const status = card.getAttribute('data-status');

            if (status === 'pending' || status === 'overdue') {
                pending++;
            } else if (status === 'submitted' || status === 'graded') {
                completed++;
            }

            // Calculate average grade if available
            const gradeDisplay = card.querySelector('.grade-score');
            if (gradeDisplay) {
                const gradeText = gradeDisplay.textContent;
                const gradeMatch = gradeText.match(/(\d+)/);
                if (gradeMatch) {
                    gradeSum += parseInt(gradeMatch[1]);
                    gradeCount++;
                }
            }
        });

        // Update statistics with animation
        animateCounter('totalAssignments', total);
        animateCounter('pendingAssignments', pending);
        animateCounter('completedAssignments', completed);

        const averageGrade = gradeCount > 0 ? Math.round(gradeSum / gradeCount) : 0;
        animateCounter('averageGrade', averageGrade, '%');
    }

    function animateCounter(elementId, target, suffix = '') {
        const element = document.getElementById(elementId);
        if (!element) return;

        let current = 0;
        const increment = target / 20;
        const timer = setInterval(() => {
            current += increment;
            if (current >= target) {
                current = target;
                clearInterval(timer);
            }
            element.textContent = Math.floor(current) + suffix;
        }, 50);
    }

    function addSmoothScrolling() {
        document.querySelectorAll('a[href^="#"]').forEach(anchor => {
            anchor.addEventListener('click', function (e) {
                e.preventDefault();
                const target = document.querySelector(this.getAttribute('href'));
                if (target) {
                    target.scrollIntoView({
                        behavior: 'smooth',
                        block: 'start'
                    });
                }
            });
        });
    }

    function initializeAnimations() {
        // Add staggered animation to cards
        const cards = document.querySelectorAll('.assignment-card, .course-card');
        cards.forEach((card, index) => {
            card.style.animationDelay = `${index * 0.1}s`;
        });

        // Intersection Observer for animations
        const observerOptions = {
            threshold: 0.1,
            rootMargin: '0px 0px -50px 0px'
        };

        const observer = new IntersectionObserver(function (entries) {
            entries.forEach(entry => {
                if (entry.isIntersecting) {
                    entry.target.classList.add('fade-in');
                }
            });
        }, observerOptions);

        document.querySelectorAll('.stat-card, .course-card').forEach(el => {
            observer.observe(el);
        });
    }

    // Enhanced sidebar and header functionality (keeping existing)
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
    });

    window.addEventListener('scroll', () => {
        profile?.classList.remove('active');
        search?.classList.remove('active');

        if (window.innerWidth < 1200) {
            sideBar?.classList.remove('active');
            body?.classList.remove('active');
        }
    });

    // Auto-refresh functionality
    setInterval(() => {
        updateDateTime();
        calculateStatistics();
    }, 60000); // Update every minute
</script>

    </form>
</body>
</html>