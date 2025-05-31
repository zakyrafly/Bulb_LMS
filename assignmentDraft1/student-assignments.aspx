<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="student-assignments.aspx.cs" Inherits="assignmentDraft1.student_assignments" %>

<!DOCTYPE html>
<html lang="en">
<head>
   <meta charset="UTF-8">
   <meta http-equiv="X-UA-Compatible" content="IE=edge">
   <meta name="viewport" content="width=device-width, initial-scale=1.0">
   <title>My Assignments - Bulb LMS</title>
   <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.1.2/css/all.min.css">
   <link rel="stylesheet" href="css/style.css">

   <style>
       .assignment-header {
           display: flex;
           justify-content: space-between;
           align-items: center;
           margin-bottom: -2rem;
       }

       .filter-section {
           background: var(--white);
           padding: 1.5rem;
           border-radius: 0.5rem;
           box-shadow: var(--box-shadow);
           margin-bottom: 2rem;
       }

       .filter-row {
           display: flex;
           flex-wrap: wrap;
           gap: 1.5rem;
           align-items: center;
       }

       .filter-group {
           flex: 1;
           min-width: 200px;
       }

       .filter-label {
           display: block;
           margin-bottom: 0.5rem;
           font-weight: bold;
           color: var(--black);
       }

       .quick-filters {
           display: flex;
           flex-wrap: wrap;
           gap: 0.5rem;
       }

       .quick-filter {
           padding: 0.5rem 1rem;
           border-radius: 2rem;
           background: var(--light-bg);
           color: var(--light-color);
           cursor: pointer;
           transition: all 0.3s ease;
       }

       .quick-filter:hover {
           background: var(--main-color);
           color: #fff;
       }

       .quick-filter.active {
           background: var(--main-color);
           color: #fff;
       }

       .assignment-grid {
           display: grid;
           grid-template-columns: repeat(auto-fill, minmax(400px, 1fr));
           gap: 2rem;
           margin: 2rem 0;
       }

       .assignment-card {
           background: var(--white);
           border-radius: 0.5rem;
           box-shadow: var(--box-shadow);
           overflow: hidden;
           transition: transform 0.3s ease, box-shadow 0.3s ease;
       }

       .assignment-card:hover {
           transform: translateY(-5px);
           box-shadow: var(--box-shadow-dark);
       }

       .card-header {
           padding: 1.5rem;
           border-bottom: 1px solid var(--light-bg);
       }

       .assignment-title {
           font-size: 1.8rem;
           color: var(--black);
           margin-bottom: 0.5rem;
       }

       .card-body {
           padding: 1.5rem;
       }

       .course-name {
           display: inline-block;
           background: var(--light-bg);
           color: var(--main-color);
           padding: 0.3rem 0.8rem;
           border-radius: 2rem;
           font-size: 1.2rem;
           margin-bottom: 1rem;
       }

       .status-badge {
           display: inline-block;
           padding: 0.5rem 1rem;
           border-radius: 2rem;
           font-weight: bold;
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

       .meta-row {
           display: grid;
           grid-template-columns: 1fr 1fr;
           gap: 1rem;
           margin: 1.5rem 0;
       }

       .meta-item {
           display: flex;
           align-items: center;
           gap: 0.5rem;
       }

       .meta-icon {
           width: 20px;
           color: var(--main-color);
       }

       .progress-bar {
           height: 8px;
           background-color: var(--light-bg);
           border-radius: 4px;
           margin: 1rem 0;
           overflow: hidden;
       }

       .progress-fill {
           height: 100%;
           background-color: var(--main-color);
           border-radius: 4px;
           transition: width 0.5s ease;
       }

       .card-footer {
           background: var(--light-bg);
           padding: 1.5rem;
           display: flex;
           justify-content: space-between;
           align-items: center;
       }

       .grade-display {
           background: var(--light-bg);
           padding: 1rem;
           border-radius: 0.5rem;
           margin: 1rem 0;
           text-align: center;
       }

       .grade-score {
           font-size: 2rem;
           font-weight: bold;
           color: var(--main-color);
       }

       .time-remaining {
           font-weight: bold;
       }

       .urgent {
           color: #dc3545;
       }

       .soon {
           color: #fd7e14;
       }

       .plenty {
           color: #28a745;
       }

       .empty-state {
           text-align: center;
           padding: 4rem 2rem;
           background: var(--white);
           border-radius: 0.5rem;
           box-shadow: var(--box-shadow);
       }

       .empty-icon {
           font-size: 5rem;
           color: var(--light-color);
           margin-bottom: 2rem;
           opacity: 0.5;
       }

       .empty-title {
           font-size: 2rem;
           margin-bottom: 1rem;
           color: var(--black);
       }

       .empty-text {
           color: var(--light-color);
           margin-bottom: 2rem;
       }

       .course-filter-section {
           margin-top: 1.5rem;
           display: flex;
           flex-wrap: wrap;
           gap: 0.5rem;
       }

       .course-filter {
           padding: 0.3rem 0.8rem;
           border-radius: 2rem;
           background: var(--light-bg);
           color: var(--black);
           cursor: pointer;
           transition: all 0.3s ease;
       }

       .course-filter:hover,
       .course-filter.active {
           background: var(--main-color);
           color: #fff;
       }

       /* Animation classes */
       .fade-in {
           animation: fadeIn 0.5s ease forwards;
       }

       .slide-in {
           animation: slideIn 0.5s ease forwards;
       }

       @keyframes fadeIn {
           from { opacity: 0; }
           to { opacity: 1; }
       }

       @keyframes slideIn {
           from { transform: translateY(20px); opacity: 0; }
           to { transform: translateY(0); opacity: 1; }
       }

       /* Responsive adjustments */
       @media (max-width: 768px) {
           .assignment-grid {
               grid-template-columns: 1fr;
           }

           .meta-row {
               grid-template-columns: 1fr;
           }

           .filter-row {
               flex-direction: column;
               align-items: stretch;
           }

           .filter-group {
               width: 100%;
           }
       }
   </style>
</head>
<body>
    <form id="form1" runat="server">

<header class="header">
   <section class="flex">
      <a href="homeWebform.aspx" class="logo">Bulb</a>

      <asp:Panel runat="server" CssClass="search-form">
          <asp:TextBox ID="txtSearch" runat="server" CssClass="search-input" placeholder="Search assignments..." MaxLength="100" />
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
      <a href="homeWebform.aspx"><i class="fas fa-home"></i><span>Home</span></a>
      <a href="courses.html"><i class="fas fa-graduation-cap"></i><span>My Courses</span></a>
      <a href="student-assignments.aspx" class="active"><i class="fas fa-tasks"></i><span>Assignments</span></a>
      <a href="calendar.html"><i class="fas fa-calendar"></i><span>Calendar</span></a>
      <a href="profile.aspx"><i class="fas fa-user"></i><span>Profile</span></a>
      <a href="loginWebform.aspx"><i class="fas fa-sign-out-alt"></i><span>Logout</span></a>
   </nav>
</div>

<section class="course-content">
    <!-- Page Header -->
    <div class="assignment-header">
        <h1 class="heading"><i class="fas fa-tasks"></i> My Assignments</h1>
        <div>
            <asp:DropDownList ID="ddlSortOptions" runat="server" CssClass="box" AutoPostBack="true" OnSelectedIndexChanged="ddlSortOptions_SelectedIndexChanged">
                <asp:ListItem Text="Sort by Due Date" Value="dueDate" />
                <asp:ListItem Text="Sort by Course" Value="course" />
                <asp:ListItem Text="Sort by Status" Value="status" />
            </asp:DropDownList>
        </div>
    </div>

    <!-- Filters Section -->
    <div class="filter-section">
        <div class="filter-row">
            <div class="filter-group">
                <label class="filter-label">Filter by Status:</label>
                <div class="quick-filters">
                    <asp:LinkButton ID="btnFilterAll" runat="server" CssClass="quick-filter active" OnClick="btnFilterAll_Click">
                        All
                    </asp:LinkButton>
                    <asp:LinkButton ID="btnFilterPending" runat="server" CssClass="quick-filter" OnClick="btnFilterPending_Click">
                        <i class="fas fa-clock"></i> Pending
                    </asp:LinkButton>
                    <asp:LinkButton ID="btnFilterSubmitted" runat="server" CssClass="quick-filter" OnClick="btnFilterSubmitted_Click">
                        <i class="fas fa-check"></i> Submitted
                    </asp:LinkButton>
                    <asp:LinkButton ID="btnFilterGraded" runat="server" CssClass="quick-filter" OnClick="btnFilterGraded_Click">
                        <i class="fas fa-star"></i> Graded
                    </asp:LinkButton>
                    <asp:LinkButton ID="btnFilterOverdue" runat="server" CssClass="quick-filter" OnClick="btnFilterOverdue_Click">
                        <i class="fas fa-exclamation-triangle"></i> Overdue
                    </asp:LinkButton>
                </div>
            </div>

            <div class="filter-group">
                <label class="filter-label">Search:</label>
                <asp:TextBox ID="txtFilterSearch" runat="server" CssClass="box" placeholder="Search in assignments..." AutoPostBack="true" OnTextChanged="txtFilterSearch_TextChanged" />
            </div>
        </div>

        <!-- Course Filter Pills -->
        <asp:Panel ID="pnlCourseFilters" runat="server" CssClass="course-filter-section">
            <asp:Repeater ID="courseFilterRepeater" runat="server" OnItemCommand="courseFilterRepeater_ItemCommand">
                <ItemTemplate>
                    <asp:LinkButton runat="server" CssClass='<%# GetCourseFilterClass(Eval("CourseID")) %>' 
                                   CommandName="FilterCourse" CommandArgument='<%# Eval("CourseID") %>'>
                        <%# Eval("CourseName") %>
                    </asp:LinkButton>
                </ItemTemplate>
            </asp:Repeater>
        </asp:Panel>
    </div>

    <!-- Assignments Grid -->
    <div class="assignment-grid">
        <asp:Repeater ID="assignmentsRepeater" runat="server">
            <ItemTemplate>
                <div class="assignment-card slide-in" 
                     data-status='<%# Eval("Status").ToString().ToLower() %>'
                     data-course='<%# Eval("CourseName") %>'
                     data-due='<%# Eval("DueDate", "{0:yyyy-MM-dd}") %>'>
                    
                    <div class="card-header">
                        <h3 class="assignment-title"><%# Eval("Title") %></h3>
                        <div class="course-name"><%# Eval("CourseName") %></div>
                    </div>
                    
                    <div class="card-body">
                        <div class="status-badge status-<%# Eval("Status").ToString().ToLower() %>">
                            <i class="fas <%# GetStatusIcon(Eval("Status")) %>"></i>
                            <%# Eval("Status") %>
                        </div>
                        
                        <p><%# TruncateDescription(Eval("Description")) %></p>
                        
                        <div class="meta-row">
                            <div class="meta-item">
                                <i class="fas fa-calendar meta-icon"></i>
                                <span>Due: <%# Eval("DueDate", "{0:MMM dd, yyyy}") %></span>
                            </div>
                            <div class="meta-item">
                                <i class="fas fa-clock meta-icon"></i>
                                <span><%# Eval("DueDate", "{0:h:mm tt}") %></span>
                            </div>
                            <div class="meta-item">
                                <i class="fas fa-star meta-icon"></i>
                                <span><%# Eval("MaxPoints") %> points</span>
                            </div>
                            <div class="meta-item">
                                <i class="fas fa-hourglass-half meta-icon"></i>
                                <span class="time-remaining <%# GetTimeRemainingClass(Eval("DueDate"), Eval("Status")) %>">
                                    <%# GetTimeRemaining(Eval("DueDate"), Eval("Status")) %>
                                </span>
                            </div>
                        </div>
                        
                        <%# Eval("PointsEarned") != DBNull.Value ? GetGradeDisplay(Eval("PointsEarned"), Eval("MaxPoints")) : "" %>
                        
                        <div class="progress-bar">
                            <div class="progress-fill" style="width: <%# GetCompletionPercentage(Eval("Status")) %>%"></div>
                        </div>
                    </div>
                    
                    <div class="card-footer">
                        <a href='assignment-details.aspx?assignmentID=<%# Eval("AssignmentID") %>' class="inline-btn">
                            <%# GetActionButtonText(Eval("Status")) %>
                        </a>
                        
                        <span>
                            <i class="fas fa-user"></i> <%# Eval("InstructorName") ?? "Instructor" %>
                        </span>
                    </div>
                </div>
            </ItemTemplate>
        </asp:Repeater>
    </div>

    <!-- Empty State -->
    <asp:Panel ID="pnlNoAssignments" runat="server" Visible="false">
        <div class="empty-state">
            <div class="empty-icon">
                <i class="fas fa-tasks"></i>
            </div>
            <h3 class="empty-title">No assignments found</h3>
            <p class="empty-text">There are no assignments matching your current filters.</p>
            <asp:Button ID="btnClearFilters" runat="server" Text="Clear All Filters" CssClass="btn" OnClick="btnClearFilters_Click" />
        </div>
    </asp:Panel>

    <!-- Assignment Stats Summary -->
    <div class="box" style="margin-top: 3rem;">
        <h3><i class="fas fa-chart-pie"></i> Assignment Summary</h3>
        <div style="display: flex; flex-wrap: wrap; gap: 2rem; margin-top: 1.5rem;">
            <div style="flex: 1; min-width: 150px; text-align: center;">
                <div style="font-size: 3rem; font-weight: bold; color: var(--main-color);">
                    <asp:Label ID="lblTotalAssignments" runat="server" Text="0"></asp:Label>
                </div>
                <div>Total Assignments</div>
            </div>
            <div style="flex: 1; min-width: 150px; text-align: center;">
                <div style="font-size: 3rem; font-weight: bold; color: #856404;">
                    <asp:Label ID="lblPendingAssignments" runat="server" Text="0"></asp:Label>
                </div>
                <div>Pending</div>
            </div>
            <div style="flex: 1; min-width: 150px; text-align: center;">
                <div style="font-size: 3rem; font-weight: bold; color: #155724;">
                    <asp:Label ID="lblCompletedAssignments" runat="server" Text="0"></asp:Label>
                </div>
                <div>Completed</div>
            </div>
            <div style="flex: 1; min-width: 150px; text-align: center;">
                <div style="font-size: 3rem; font-weight: bold; color: #0c5460;">
                    <asp:Label ID="lblAverageGrade" runat="server" Text="0%"></asp:Label>
                </div>
                <div>Average Grade</div>
            </div>
        </div>
    </div>
</section>

<footer class="footer">
   &copy; copyright @ 2025 by <span>Stanley Nilam</span> | all rights reserved!
</footer>

<script src="js/script.js"></script>

    </form>
</body>
</html>