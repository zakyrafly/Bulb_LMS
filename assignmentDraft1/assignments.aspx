<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="assignments.aspx.cs" Inherits="assignmentDraft1.assignments" %>

<!DOCTYPE html>
<html lang="en">
<head>
   <meta charset="UTF-8">
   <meta http-equiv="X-UA-Compatible" content="IE=edge">
   <meta name="viewport" content="width=device-width, initial-scale=1.0">
   <title>Assignment Management - Bulb LMS</title>
   <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.1.2/css/all.min.css">
   <link rel="stylesheet" href="css/style.css">
   
   <style>
       /* Dashboard Statistics */
       .stats-container {
           display: grid;
           grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
           gap: 2rem;
           margin-bottom: 3rem;
       }
       
       .stat-card {
           background: var(--white);
           border-radius: 1rem;
           box-shadow: 0 0.5rem 1rem rgba(0, 0, 0, 0.1);
           padding: 2rem;
           transition: all 0.3s ease;
           position: relative;
           overflow: hidden;
       }
       
       .stat-card:hover {
           transform: translateY(-5px);
           box-shadow: 0 1rem 2rem rgba(0, 0, 0, 0.15);
       }
       
       .stat-header {
           display: flex;
           justify-content: space-between;
           align-items: flex-start;
           margin-bottom: 1.5rem;
       }
       
       .stat-number {
           font-size: 3rem;
           font-weight: bold;
           margin-bottom: 0.5rem;
           color: var(--black);
       }
       
       .stat-label {
           font-size: 1.6rem;
           color: var(--light-color);
       }
       
       .stat-icon {
           background: var(--light-bg);
           width: 5rem;
           height: 5rem;
           border-radius: 50%;
           display: flex;
           align-items: center;
           justify-content: center;
           font-size: 2.2rem;
           color: var(--main-color);
       }
       
       .stat-card:nth-child(1) .stat-icon {
           background: rgba(139, 69, 19, 0.1);
           color: var(--main-color);
       }
       
       .stat-card:nth-child(2) .stat-icon {
           background: rgba(0, 128, 0, 0.1);
           color: green;
       }
       
       .stat-card:nth-child(3) .stat-icon {
           background: rgba(255, 165, 0, 0.1);
           color: orange;
       }
       
       .stat-card:nth-child(4) .stat-icon {
           background: rgba(220, 20, 60, 0.1);
           color: crimson;
       }
       
       /* Filter Section */
       .filter-container {
           background: var(--white);
           border-radius: 1rem;
           box-shadow: 0 0.5rem 1rem rgba(0, 0, 0, 0.1);
           padding: 2rem;
           margin-bottom: 3rem;
           display: flex;
           flex-wrap: wrap;
           gap: 2rem;
           align-items: center;
       }
       
       .filter-group {
           flex: 1;
           min-width: 200px;
       }
       
       .filter-label {
           display: block;
           margin-bottom: 0.8rem;
           font-weight: 500;
           font-size: 1.4rem;
           color: var(--black);
       }
       
       .filter-group .box {
           width: 100%;
           padding: 1.2rem;
           border-radius: 0.8rem;
           font-size: 1.5rem;
           border: 1px solid #ddd;
       }
       
       .filter-group .box:focus {
           border-color: var(--main-color);
           box-shadow: 0 0 0 3px rgba(139, 69, 19, 0.1);
       }
       
       .status-filters {
           display: flex;
           flex-wrap: wrap;
           gap: 1rem;
       }
       
       .status-filter {
           padding: 0.8rem 1.5rem;
           border-radius: 2rem;
           background-color: var(--light-bg);
           color: var(--black);
           font-size: 1.4rem;
           cursor: pointer;
           transition: all 0.3s;
           border: none;
       }
       
       .status-filter:hover {
           background-color: var(--light-color);
           color: var(--white);
       }
       
       .status-filter.active {
           background-color: var(--main-color);
           color: var(--white);
       }
       
       /* Assignment Grid */
       .assignment-grid {
           display: grid;
           grid-template-columns: repeat(auto-fill, minmax(350px, 1fr));
           gap: 2.5rem;
           margin: 2rem 0;
       }
       
       .assignment-card {
           background: var(--white);
           border-radius: 1rem;
           box-shadow: 0 0.5rem 1rem rgba(0, 0, 0, 0.1);
           overflow: hidden;
           transition: all 0.3s ease;
           border-top: 4px solid var(--main-color);
           animation: fadeIn 0.5s ease-out forwards;
           opacity: 0;
       }
       
       @keyframes fadeIn {
           from {
               opacity: 0;
               transform: translateY(20px);
           }
           to {
               opacity: 1;
               transform: translateY(0);
           }
       }
       
       .assignment-card:hover {
           transform: translateY(-5px);
           box-shadow: 0 1rem 2rem rgba(0, 0, 0, 0.15);
       }
       
       .assignment-header {
           padding: 2rem;
           border-bottom: 1px solid var(--light-bg);
           position: relative;
       }
       
       .assignment-title {
           font-size: 1.8rem;
           color: var(--black);
           margin-bottom: 1rem;
       }
       
       .module-badge {
           display: inline-block;
           padding: 0.5rem 1rem;
           background: var(--light-bg);
           color: var(--black);
           border-radius: 2rem;
           font-size: 1.2rem;
           margin-bottom: 1rem;
       }
       
       .status-badge {
           position: absolute;
           top: 2rem;
           right: 2rem;
           padding: 0.5rem 1.2rem;
           border-radius: 2rem;
           font-size: 1.2rem;
           font-weight: 500;
           display: flex;
           align-items: center;
           gap: 0.5rem;
       }
       
       .status-active {
           background-color: rgba(0, 128, 0, 0.1);
           color: green;
       }
       
       .status-due-soon {
           background-color: rgba(255, 165, 0, 0.1);
           color: orange;
       }
       
       .status-overdue {
           background-color: rgba(220, 20, 60, 0.1);
           color: crimson;
       }
       
       .assignment-body {
           padding: 2rem;
       }
       
       .assignment-description {
           color: var(--light-color);
           font-size: 1.4rem;
           margin-bottom: 2rem;
           line-height: 1.6;
           display: -webkit-box;
           -webkit-line-clamp: 3;
           -webkit-box-orient: vertical;
           overflow: hidden;
       }
       
       .assignment-meta {
           display: grid;
           grid-template-columns: 1fr 1fr;
           gap: 1.5rem;
           margin-bottom: 2rem;
       }
       
       .meta-item {
           display: flex;
           align-items: center;
           gap: 0.8rem;
           font-size: 1.4rem;
           color: var(--black);
       }
       
       .meta-icon {
           color: var(--main-color);
           font-size: 1.6rem;
           width: 1.8rem;
           text-align: center;
       }
       
       .submission-stats {
           display: flex;
           justify-content: space-between;
           background: var(--light-bg);
           border-radius: 0.8rem;
           padding: 1.5rem;
           margin-bottom: 2rem;
       }
       
       .stat-item {
           text-align: center;
           flex: 1;
       }
       
       .stat-item:not(:last-child) {
           border-right: 1px solid rgba(0,0,0,0.1);
       }
       
       .stat-value {
           font-size: 2.2rem;
           font-weight: bold;
           color: var(--main-color);
           line-height: 1;
           margin-bottom: 0.5rem;
       }
       
       .stat-name {
           font-size: 1.2rem;
           color: var(--light-color);
       }
       
       .assignment-actions {
           display: flex;
           gap: 1rem;
           flex-wrap: wrap;
       }
       
       .assignment-actions .inline-btn,
       .assignment-actions .option-btn,
       .assignment-actions .delete-btn {
           flex: 1;
           display: flex;
           align-items: center;
           justify-content: center;
           gap: 0.5rem;
           min-width: 90px;
       }
       
       /* Due indicators */
       .due-soon {
           border-top-color: orange;
       }
       
       .overdue {
           border-top-color: crimson;
       }
       
       /* Empty state */
       .empty-state {
           text-align: center;
           padding: 6rem 2rem;
           background-color: var(--white);
           border-radius: 1rem;
           box-shadow: 0 0.5rem 1rem rgba(0, 0, 0, 0.1);
       }
       
       .empty-icon {
           font-size: 6rem;
           color: var(--light-color);
           margin-bottom: 2rem;
           opacity: 0.3;
       }
       
       .empty-title {
           font-size: 2.4rem;
           margin-bottom: 1rem;
           color: var(--black);
       }
       
       .empty-text {
           font-size: 1.6rem;
           color: var(--light-color);
           margin-bottom: 3rem;
       }
       
       /* Modal styling */
       .modal {
           display: none;
           position: fixed;
           z-index: 1000;
           left: 0;
           top: 0;
           width: 100%;
           height: 100%;
           background-color: rgba(0,0,0,0.5);
           animation: fadeIn 0.3s ease-out;
           overflow-y: auto;
       }
       
       .modal-content {
           background-color: var(--white);
           margin: 5% auto;
           padding: 3rem;
           border-radius: 1rem;
           width: 90%;
           max-width: 700px;
           max-height: 85vh;
           overflow-y: auto;
           animation: slideIn 0.3s ease-out;
           position: relative;
       }
       
       @keyframes slideIn {
           from {
               opacity: 0;
               transform: translateY(-50px);
           }
           to {
               opacity: 1;
               transform: translateY(0);
           }
       }
       
       .close {
           position: absolute;
           top: 2rem;
           right: 2rem;
           color: var(--light-color);
           font-size: 2.8rem;
           font-weight: bold;
           cursor: pointer;
           transition: all 0.3s;
           width: 4rem;
           height: 4rem;
           display: flex;
           align-items: center;
           justify-content: center;
           border-radius: 50%;
       }
       
       .close:hover {
           color: var(--black);
           background-color: var(--light-bg);
       }
       
       .modal-title {
           font-size: 2.4rem;
           margin-bottom: 2.5rem;
           color: var(--black);
           padding-right: 4rem;
       }
       
       .form-group {
           margin-bottom: 2rem;
       }
       
       .form-group label {
           display: block;
           margin-bottom: 0.8rem;
           font-weight: 500;
           font-size: 1.5rem;
           color: var(--black);
       }
       
       .form-group .box {
           width: 100%;
           padding: 1.2rem;
           border-radius: 0.8rem;
           font-size: 1.5rem;
           border: 1px solid #ddd;
           transition: all 0.3s;
       }
       
       .form-group .box:focus {
           border-color: var(--main-color);
           box-shadow: 0 0 0 3px rgba(139, 69, 19, 0.1);
           outline: none;
       }
       
       .form-row {
           display: grid;
           grid-template-columns: 1fr 1fr;
           gap: 2rem;
       }
       
       .form-actions {
           display: flex;
           gap: 1.5rem;
           margin-top: 3rem;
           justify-content: flex-end;
       }
       
       .form-actions .btn,
       .form-actions .option-btn {
           padding: 1.2rem 2.5rem;
           font-size: 1.5rem;
           border-radius: 0.8rem;
       }
       
       /* Message styling */
       .message {
           padding: 1.5rem 2rem;
           border-radius: 0.8rem;
           font-size: 1.5rem;
           margin: 2rem 0;
           position: fixed;
           bottom: 2rem;
           right: 2rem;
           z-index: 1000;
           min-width: 300px;
           max-width: 500px;
           box-shadow: 0 0.5rem 1.5rem rgba(0, 0, 0, 0.2);
           animation: slideInRight 0.5s ease-out forwards;
           transform: translateX(100%);
           display: flex;
           align-items: center;
           gap: 1rem;
       }
       
       @keyframes slideInRight {
           to {
               transform: translateX(0);
           }
       }
       
       .message.success {
           background-color: #d4edda;
           color: #155724;
           border-left: 5px solid #28a745;
       }
       
       .message.error {
           background-color: #f8d7da;
           color: #721c24;
           border-left: 5px solid #dc3545;
       }
       
       .message-icon {
           font-size: 2rem;
       }
       
       /* Quick Actions */
       .quick-actions {
           position: fixed;
           right: 3rem;
           bottom: 3rem;
           display: flex;
           flex-direction: column;
           gap: 1.5rem;
           z-index: 100;
       }
       
       .quick-action-btn {
           width: 6rem;
           height: 6rem;
           border-radius: 50%;
           background-color: var(--main-color);
           color: white;
           display: flex;
           align-items: center;
           justify-content: center;
           font-size: 2.2rem;
           box-shadow: 0 0.5rem 1.5rem rgba(0, 0, 0, 0.2);
           transition: all 0.3s;
           cursor: pointer;
           border: none;
       }
       
       .quick-action-btn:hover {
           transform: translateY(-5px) scale(1.05);
           box-shadow: 0 1rem 2.5rem rgba(0, 0, 0, 0.25);
       }
       
       /* Responsive adjustments */
       @media (max-width: 768px) {
           .assignment-grid {
               grid-template-columns: 1fr;
           }
           
           .form-row {
               grid-template-columns: 1fr;
               gap: 1rem;
           }
           
           .filter-container {
               flex-direction: column;
               align-items: stretch;
               gap: 1.5rem;
           }
           
           .filter-group {
               width: 100%;
           }
           
           .modal-content {
               width: 95%;
               margin: 5% auto;
               padding: 2rem;
           }
       }
       
       /* Dark mode adjustments */
       .dark .stat-card,
       .dark .assignment-card,
       .dark .filter-container,
       .dark .empty-state,
       .dark .modal-content {
           background-color: var(--black);
           box-shadow: 0 0.5rem 1rem rgba(0, 0, 0, 0.2);
       }
       
       .dark .submission-stats {
           background-color: rgba(255, 255, 255, 0.1);
       }
       
       .dark .stat-item:not(:last-child) {
           border-right: 1px solid rgba(255,255,255,0.1);
       }
       
       .dark .assignment-header {
           border-bottom: 1px solid var(--border);
       }
       
       .dark .form-group .box {
           background-color: var(--black);
           border-color: var(--border);
           color: var(--white);
       }
   </style>
</head>
<body>
    <form id="form1" runat="server">

<header class="header">
   <section class="flex">
      <a href="teacherWebform.aspx" class="logo">Bulb</a>
      
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
      <a href="teacherWebform.aspx"><i class="fas fa-home"></i><span>Dashboard</span></a>
      <a href="manageStudents.aspx"><i class="fas fa-users"></i><span>Students</span></a>
      <a href="assignments.aspx" class="active"><i class="fas fa-tasks"></i><span>Assignments</span></a>
      <a href="analytics.aspx"><i class="fas fa-chart-line"></i><span>Analytics</span></a>
      <a href="settings.aspx"><i class="fas fa-cog"></i><span>Settings</span></a>
      <a href="loginWebform.aspx"><i class="fas fa-sign-out-alt"></i><span>Logout</span></a>
   </nav>
</div>

<section class="course-content">
    <!-- Page Header -->
    <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 3rem;">
        <h1 class="heading"><i class="fas fa-tasks"></i> Assignment Management</h1>
        <button type="button" class="inline-btn" onclick="openAddModal()">
            <i class="fas fa-plus"></i> Create New Assignment
        </button>
    </div>

    <!-- Dashboard Statistics -->
    <div class="stats-container">
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
                    <div class="stat-number" id="activeAssignments">0</div>
                    <div class="stat-label">Active</div>
                </div>
                <div class="stat-icon">
                    <i class="fas fa-check-circle"></i>
                </div>
            </div>
        </div>
        
        <div class="stat-card">
            <div class="stat-header">
                <div>
                    <div class="stat-number" id="dueSoonAssignments">0</div>
                    <div class="stat-label">Due Soon</div>
                </div>
                <div class="stat-icon">
                    <i class="fas fa-clock"></i>
                </div>
            </div>
        </div>
        
        <div class="stat-card">
            <div class="stat-header">
                <div>
                    <div class="stat-number" id="overdueAssignments">0</div>
                    <div class="stat-label">Overdue</div>
                </div>
                <div class="stat-icon">
                    <i class="fas fa-exclamation-circle"></i>
                </div>
            </div>
        </div>
    </div>

    <!-- Filter Options -->
    <div class="filter-container">
        <div class="filter-group">
            <label class="filter-label">Filter by Module:</label>
            <asp:DropDownList ID="ddlModuleFilter" runat="server" CssClass="box" AutoPostBack="true" OnSelectedIndexChanged="ddlModuleFilter_SelectedIndexChanged">
                <asp:ListItem Text="All Modules" Value="" />
            </asp:DropDownList>
        </div>
        
        <div class="filter-group">
            <label class="filter-label">Filter by Status:</label>
            <asp:DropDownList ID="ddlStatusFilter" runat="server" CssClass="box" AutoPostBack="true" OnSelectedIndexChanged="ddlStatusFilter_SelectedIndexChanged">
                <asp:ListItem Text="All Statuses" Value="" />
                <asp:ListItem Text="Active" Value="Active" />
                <asp:ListItem Text="Due Soon" Value="DueSoon" />
                <asp:ListItem Text="Overdue" Value="Overdue" />
            </asp:DropDownList>
        </div>
        
        <div class="filter-group">
            <label class="filter-label">Sort by:</label>
            <select id="sortSelect" class="box" onchange="sortAssignments()">
                <option value="dueDate">Due Date (Earliest First)</option>
                <option value="dueDateDesc">Due Date (Latest First)</option>
                <option value="title">Title (A-Z)</option>
                <option value="module">Module (A-Z)</option>
                <option value="submissions">Most Submissions</option>
            </select>
        </div>
    </div>

    <!-- Assignments Grid -->
    <div class="assignment-grid" id="assignmentGrid">
        <asp:Repeater ID="assignmentRepeater" runat="server" OnItemCommand="assignmentRepeater_ItemCommand">
            <ItemTemplate>
                <div class="assignment-card <%# GetCardClass(Eval("DueDate")) %>" 
                     data-title='<%# Eval("Title") %>'
                     data-module='<%# Eval("ModuleTitle") %>'
                     data-due-date='<%# Convert.ToDateTime(Eval("DueDate")).ToString("yyyy-MM-dd HH:mm:ss") %>'
                     data-submissions='<%# Eval("TotalSubmissions") %>'>
                    <div class="assignment-header">
                        <div class="module-badge"><%# Eval("ModuleTitle") %></div>
                        <h3 class="assignment-title"><%# Eval("Title") %></h3>
                        <div class="status-badge <%# GetStatusClass(Eval("DueDate")) %>">
                            <i class="fas fa-circle"></i>
                            <%# GetStatusText(Eval("DueDate")) %>
                        </div>
                    </div>
                    
                    <div class="assignment-body">
                        <div class="assignment-description">
                            <%# Eval("Description") %>
                        </div>
                        
                        <div class="assignment-meta">
                            <div class="meta-item">
                                <i class="fas fa-calendar meta-icon"></i>
                                <span><%# Convert.ToDateTime(Eval("DueDate")).ToString("MMM dd, yyyy") %></span>
                            </div>
                            <div class="meta-item">
                                <i class="fas fa-clock meta-icon"></i>
                                <span><%# Convert.ToDateTime(Eval("DueDate")).ToString("hh:mm tt") %></span>
                            </div>
                            <div class="meta-item">
                                <i class="fas fa-star meta-icon"></i>
                                <span><%# Eval("MaxPoints") %> points</span>
                            </div>
                            <div class="meta-item time-remaining" data-due='<%# Convert.ToDateTime(Eval("DueDate")).ToString("yyyy-MM-dd HH:mm:ss") %>'>
                                <i class="fas fa-hourglass-half meta-icon"></i>
                                <span>Loading...</span>
                            </div>
                        </div>
                        
                        <div class="submission-stats">
                            <div class="stat-item">
                                <div class="stat-value"><%# Eval("TotalSubmissions") %></div>
                                <div class="stat-name">Submissions</div>
                            </div>
                            <div class="stat-item">
                                <div class="stat-value"><%# Eval("GradedSubmissions") %></div>
                                <div class="stat-name">Graded</div>
                            </div>
                            <div class="stat-item">
                                <div class="stat-value"><%# Eval("PendingGrades") %></div>
                                <div class="stat-name">Pending</div>
                            </div>
                        </div>
                        
                        <div class="assignment-actions">
                            <asp:LinkButton runat="server" CssClass="inline-btn" 
                                          CommandName="Grade" CommandArgument='<%# Eval("AssignmentID") %>'>
                                <i class="fas fa-graduation-cap"></i> Grade (<%# Eval("PendingGrades") %>)
                            </asp:LinkButton>
                            <asp:LinkButton runat="server" CssClass="option-btn" 
                                          CommandName="Edit" CommandArgument='<%# Eval("AssignmentID") %>'>
                                <i class="fas fa-edit"></i> Edit
                            </asp:LinkButton>
                            <asp:LinkButton runat="server" CssClass="delete-btn" 
                                          CommandName="Delete" CommandArgument='<%# Eval("AssignmentID") %>'
                                          OnClientClick="return confirmDelete();">
                                <i class="fas fa-trash"></i> Delete
                            </asp:LinkButton>
                        </div>
                    </div>
                </div>
            </ItemTemplate>
        </asp:Repeater>
    </div>

    <!-- No Assignments Message -->
    <asp:Panel ID="pnlNoAssignments" runat="server" Visible="false">
        <div class="empty-state">
            <div class="empty-icon">
                <i class="fas fa-tasks"></i>
            </div>
            <h2 class="empty-title">No Assignments Found</h2>
            <p class="empty-text">Create your first assignment to get started!</p>
            <button type="button" class="inline-btn" onclick="openAddModal()">
                <i class="fas fa-plus"></i> Create Assignment
            </button>
        </div>
    </asp:Panel>

    <!-- Messages -->
    <div id="messageContainer" style="display: none;" class="message">
        <i class="fas fa-info-circle message-icon"></i>
        <span id="messageText"></span>
    </div>
    <asp:Label ID="lblMessage" runat="server" Text="" style="display: none;"></asp:Label>
</section>

<!-- Add/Edit Assignment Modal -->
<div id="assignmentModal" class="modal">
    <div class="modal-content">
        <span class="close" onclick="closeModal()">&times;</span>
        <h2 id="modalTitle" class="modal-title">Add New Assignment</h2>
        
        <div class="form-group">
            <label for="<%= txtTitle.ClientID %>">Assignment Title <span style="color: red;">*</span></label>
            <asp:TextBox ID="txtTitle" runat="server" CssClass="box" MaxLength="200" placeholder="Enter assignment title"></asp:TextBox>
        </div>
        
        <div class="form-group">
            <label for="<%= ddlModule.ClientID %>">Module <span style="color: red;">*</span></label>
            <asp:DropDownList ID="ddlModule" runat="server" CssClass="box">
            </asp:DropDownList>
        </div>
        
        <div class="form-group">
            <label for="<%= txtDescription.ClientID %>">Description <span style="color: red;">*</span></label>
            <asp:TextBox ID="txtDescription" runat="server" CssClass="box" TextMode="MultiLine" 
                       Rows="4" placeholder="Enter assignment description"></asp:TextBox>
        </div>
        
        <div class="form-group">
            <label for="<%= txtInstructions.ClientID %>">Instructions</label>
            <asp:TextBox ID="txtInstructions" runat="server" CssClass="box" TextMode="MultiLine" 
                       Rows="6" placeholder="Enter detailed instructions for students"></asp:TextBox>
        </div>
        
        <div class="form-row">
            <div class="form-group">
                <label for="<%= txtDueDate.ClientID %>">Due Date <span style="color: red;">*</span></label>
                <asp:TextBox ID="txtDueDate" runat="server" CssClass="box" TextMode="Date"></asp:TextBox>
            </div>
            <div class="form-group">
                <label for="<%= txtDueTime.ClientID %>">Due Time <span style="color: red;">*</span></label>
                <asp:TextBox ID="txtDueTime" runat="server" CssClass="box" TextMode="Time"></asp:TextBox>
            </div>
        </div>
        
        <div class="form-group">
            <label for="<%= txtMaxPoints.ClientID %>">Maximum Points <span style="color: red;">*</span></label>
            <asp:TextBox ID="txtMaxPoints" runat="server" CssClass="box" TextMode="Number" 
                       placeholder="100" min="1" max="1000"></asp:TextBox>
        </div>
        
        <div class="form-actions">
            <button type="button" class="option-btn" onclick="closeModal()">Cancel</button>
            <asp:Button ID="btnSaveAssignment" runat="server" Text="Save Assignment" 
                      CssClass="btn" OnClick="btnSaveAssignment_Click" />
        </div>
        
        <asp:HiddenField ID="hfAssignmentID" runat="server" />
    </div>
</div>

<!-- Quick Actions -->
<div class="quick-actions">
    <button type="button" class="quick-action-btn" title="Create New Assignment" onclick="openAddModal()">
        <i class="fas fa-plus"></i>
    </button>
</div>

<footer class="footer">
   &copy; copyright @ 2025 by <span>Stanley Nilam</span> | all rights reserved!
</footer>

<script src="js/script.js"></script>
<script>
    // Global variables
    let allAssignmentCards = [];
    let currentSortBy = 'dueDate';
    
    // Initialize when DOM is ready
    document.addEventListener('DOMContentLoaded', function() {
        console.log('DOM loaded, initializing assignments page...');
        
        // Get all assignment cards
        allAssignmentCards = Array.from(document.querySelectorAll('.assignment-card'));
        
        // Initialize time remaining
        updateTimeRemaining();
        
        // Calculate statistics
        calculateStatistics();
        
        // Initialize animations
        initializeAnimations();
        
        // Check server-side messages
        checkMessages();
        
        // Set up interval for updating time remaining
        setInterval(updateTimeRemaining, 60000); // Update every minute
    });
    
    function initializeAnimations() {
        // Set staggered delays for animation
        document.querySelectorAll('.assignment-card').forEach((card, index) => {
            card.style.animationDelay = `${index * 0.1}s`;
        });
    }
    
    function updateTimeRemaining() {
        document.querySelectorAll('.time-remaining').forEach(element => {
            const dueDate = new Date(element.getAttribute('data-due'));
            const now = new Date();
            const diffTime = dueDate - now;
            const diffDays = Math.ceil(diffTime / (1000 * 60 * 60 * 24));
            
            let timeText = '';
            const iconElement = element.querySelector('i');
            
            if (diffTime < 0) {
                timeText = `${Math.abs(diffDays)} day(s) overdue`;
                if (iconElement) iconElement.className = 'fas fa-exclamation-circle meta-icon';
                element.style.color = 'crimson';
            } else if (diffDays === 0) {
                const diffHours = Math.ceil(diffTime / (1000 * 60 * 60));
                if (diffHours <= 1) {
                    timeText = 'Due in less than an hour';
                } else {
                    timeText = `Due in ${diffHours} hours`;
                }
                if (iconElement) iconElement.className = 'fas fa-exclamation-circle meta-icon';
                element.style.color = 'orange';
            } else if (diffDays === 1) {
                timeText = 'Due tomorrow';
                if (iconElement) iconElement.className = 'fas fa-clock meta-icon';
                element.style.color = 'orange';
            } else if (diffDays <= 7) {
                timeText = `Due in ${diffDays} days`;
                if (iconElement) iconElement.className = 'fas fa-clock meta-icon';
                element.style.color = '';
            } else {
                timeText = `Due in ${diffDays} days`;
                if (iconElement) iconElement.className = 'fas fa-calendar meta-icon';
                element.style.color = '';
            }
            
            const spanElement = element.querySelector('span');
            if (spanElement) {
                spanElement.textContent = timeText;
            }
        });
    }
    
    function calculateStatistics() {
        const assignments = document.querySelectorAll('.assignment-card');
        const now = new Date();
        const oneWeekFromNow = new Date();
        oneWeekFromNow.setDate(oneWeekFromNow.getDate() + 7);
        
        let totalCount = assignments.length;
        let activeCount = 0;
        let dueSoonCount = 0;
        let overdueCount = 0;
        
        assignments.forEach(assignment => {
            const dueDate = new Date(assignment.getAttribute('data-due-date'));
            
            if (dueDate < now) {
                overdueCount++;
            } else if (dueDate <= oneWeekFromNow) {
                dueSoonCount++;
            } else {
                activeCount++;
            }
        });
        
        // Update statistics in UI
        document.getElementById('totalAssignments').textContent = totalCount;
        document.getElementById('activeAssignments').textContent = activeCount;
        document.getElementById('dueSoonAssignments').textContent = dueSoonCount;
        document.getElementById('overdueAssignments').textContent = overdueCount;
    }
    
    function sortAssignments() {
        currentSortBy = document.getElementById('sortSelect').value;
        
        const container = document.getElementById('assignmentGrid');
        if (!container) return;
        
        // Convert nodeList to array for sorting
        const cards = Array.from(container.querySelectorAll('.assignment-card'));
        
        // Sort the array
        cards.sort((a, b) => {
            switch (currentSortBy) {
                case 'dueDate':
                    return compareDates(a, b);
                case 'dueDateDesc':
                    return compareDates(b, a);
                case 'title':
                    return compareStrings(a, b, 'data-title');
                case 'module':
                    return compareStrings(a, b, 'data-module');
                case 'submissions':
                    return compareNumbers(b, a, 'data-submissions');
                default:
                    return 0;
            }
        });
        
        // Reorder in DOM
        cards.forEach(card => {
            container.appendChild(card);
        });
    }
    
    function compareDates(a, b) {
        const dateA = new Date(a.getAttribute('data-due-date'));
        const dateB = new Date(b.getAttribute('data-due-date'));
        return dateA - dateB;
    }
    
    function compareStrings(a, b, attr) {
        const stringA = a.getAttribute(attr).toLowerCase();
        const stringB = b.getAttribute(attr).toLowerCase();
        return stringA.localeCompare(stringB);
    }
    
    function compareNumbers(a, b, attr) {
        const numA = parseInt(a.getAttribute(attr)) || 0;
        const numB = parseInt(b.getAttribute(attr)) || 0;
        return numA - numB;
    }
    
    function checkMessages() {
        const serverMessage = document.getElementById('<%= lblMessage.ClientID %>');
        if (serverMessage && serverMessage.innerHTML.trim()) {
            showMessage(serverMessage.innerHTML, serverMessage.style.color.includes('Red') ? 'error' : 'success');
            serverMessage.innerHTML = '';
        }
    }
    
    function showMessage(message, type = 'success') {
        const messageContainer = document.getElementById('messageContainer');
        const messageText = document.getElementById('messageText');
        const messageIcon = messageContainer.querySelector('.message-icon');
        
        messageText.innerHTML = message;
        messageContainer.className = 'message ' + type;
        
        if (type === 'error') {
            messageIcon.className = 'fas fa-exclamation-circle message-icon';
        } else {
            messageIcon.className = 'fas fa-check-circle message-icon';
        }
        
        messageContainer.style.display = 'flex';
        
        // Auto-hide after 5 seconds
        setTimeout(() => {
            messageContainer.style.display = 'none';
        }, 5000);
    }
    
    function openAddModal() {
        document.getElementById('modalTitle').innerText = 'Add New Assignment';
        document.getElementById('<%= hfAssignmentID.ClientID %>').value = '';
        document.getElementById('<%= btnSaveAssignment.ClientID %>').innerText = 'Save Assignment';
        
        // Set default due date/time
        const now = new Date();
        const twoWeeksFromNow = new Date();
        twoWeeksFromNow.setDate(now.getDate() + 14);
        
        document.getElementById('<%= txtDueDate.ClientID %>').value = twoWeeksFromNow.toISOString().split('T')[0];
        document.getElementById('<%= txtDueTime.ClientID %>').value = '23:59';
        document.getElementById('<%= txtMaxPoints.ClientID %>').value = '100';
        
        document.getElementById('assignmentModal').style.display = 'block';
        
        // Focus on title field
        setTimeout(() => {
            document.getElementById('<%= txtTitle.ClientID %>').focus();
        }, 300);
    }
    
    function openEditModal(assignmentId) {
        document.getElementById('modalTitle').innerText = 'Edit Assignment';
        document.getElementById('<%= hfAssignmentID.ClientID %>').value = assignmentId;
        document.getElementById('<%= btnSaveAssignment.ClientID %>').innerText = 'Update Assignment';
        document.getElementById('assignmentModal').style.display = 'block';
        
        // Focus on title field
        setTimeout(() => {
            document.getElementById('<%= txtTitle.ClientID %>').focus();
        }, 300);
    }
    
    function closeModal() {
        document.getElementById('assignmentModal').style.display = 'none';
        // Clear form
        document.getElementById('<%= txtTitle.ClientID %>').value = '';
        document.getElementById('<%= txtDescription.ClientID %>').value = '';
        document.getElementById('<%= txtInstructions.ClientID %>').value = '';
        document.getElementById('<%= txtDueDate.ClientID %>').value = '';
        document.getElementById('<%= txtDueTime.ClientID %>').value = '';
        document.getElementById('<%= txtMaxPoints.ClientID %>').value = '';
    }

    function confirmDelete() {
        return confirm('Are you sure you want to delete this assignment? This action cannot be undone.');
    }

    // Close modal when clicking outside
    window.onclick = function (event) {
        const modal = document.getElementById('assignmentModal');
        if (event.target == modal) {
            closeModal();
        }
    }

    // Initialize the sidebar and header functions
    document.addEventListener('DOMContentLoaded', function () {
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
    });
</script>

    </form>
</body>
</html>