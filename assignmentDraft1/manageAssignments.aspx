<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="manageAssignments.aspx.cs" Inherits="assignmentDraft1.manageAssignments" %>

<!DOCTYPE html>
<html lang="en">
<head>
   <meta charset="UTF-8">
   <meta http-equiv="X-UA-Compatible" content="IE=edge">
   <meta name="viewport" content="width=device-width, initial-scale=1.0">
   <title>Assignment Oversight - Bulb Admin</title>
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
       
       .assignment-management {
           padding: 2rem;
       }
       
       .stats-grid {
           display: grid;
           grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
           gap: 1.5rem;
           margin-bottom: 2rem;
       }
       
       .stat-card {
           background: white;
           padding: 1.5rem;
           border-radius: 1rem;
           box-shadow: 0 4px 15px rgba(0,0,0,0.1);
           text-align: center;
           position: relative;
           overflow: hidden;
       }
       
       .stat-card::before {
           content: '';
           position: absolute;
           top: 0;
           left: 0;
           right: 0;
           height: 4px;
           background: var(--admin-secondary);
       }
       
       .stat-card.warning::before { background: var(--admin-warning); }
       .stat-card.danger::before { background: var(--admin-danger); }
       .stat-card.success::before { background: var(--admin-success); }
       .stat-card.purple::before { background: var(--admin-purple); }
       
       .stat-number {
           font-size: 2.5rem;
           font-weight: bold;
           color: var(--admin-primary);
           margin-bottom: 0.5rem;
       }
       
       .stat-label {
           color: #7f8c8d;
           font-size: 1.2rem;
       }
       
       .stat-icon {
           position: absolute;
           top: 1rem;
           right: 1rem;
           font-size: 2rem;
           opacity: 0.3;
           color: var(--admin-secondary);
       }
       
       .controls-section {
           display: flex;
           justify-content: space-between;
           align-items: center;
           margin-bottom: 2rem;
           flex-wrap: wrap;
           gap: 1rem;
       }
       
       .search-filters {
           display: flex;
           gap: 1rem;
           align-items: center;
           flex-wrap: wrap;
       }
       
       .assignments-table {
           background: white;
           border-radius: 1rem;
           box-shadow: 0 4px 15px rgba(0,0,0,0.1);
           overflow: hidden;
           margin: 2rem 0;
       }
       
       .table-header {
           background: var(--admin-primary);
           color: white;
           padding: 1.5rem 2rem;
           display: flex;
           justify-content: space-between;
           align-items: center;
       }
       
       .data-table {
           width: 100%;
           border-collapse: collapse;
       }
       
       .data-table th {
           background: var(--admin-light);
           padding: 1.2rem;
           text-align: left;
           font-weight: bold;
           color: var(--admin-primary);
           border-bottom: 2px solid #ddd;
       }
       
       .data-table td {
           padding: 1.2rem;
           border-bottom: 1px solid #eee;
           vertical-align: middle;
       }
       
       .data-table tr:hover {
           background-color: #f8f9fa;
       }
       
       .assignment-info {
           display: flex;
           flex-direction: column;
           gap: 0.3rem;
       }
       
       .assignment-title {
           font-weight: bold;
           color: var(--admin-primary);
           font-size: 1.3rem;
       }
       
       .assignment-course {
           color: #7f8c8d;
           font-size: 1.1rem;
       }
       
       .status-badge {
           padding: 0.4rem 0.8rem;
           border-radius: 1rem;
           font-size: 1rem;
           font-weight: bold;
           text-align: center;
           min-width: 80px;
       }
       
       .status-active {
           background: #d5f4e6;
           color: var(--admin-success);
       }
       
       .status-overdue {
           background: #ffeaea;
           color: var(--admin-danger);
       }
       
       .status-due-soon {
           background: #fff3cd;
           color: var(--admin-warning);
       }
       
       .progress-bar {
           width: 100%;
           height: 8px;
           background: #e9ecef;
           border-radius: 4px;
           overflow: hidden;
           margin-bottom: 0.5rem;
       }
       
       .progress-fill {
           height: 100%;
           background: var(--admin-success);
           transition: width 0.3s ease;
       }
       
       .progress-text {
           font-size: 1.1rem;
           color: #6c757d;
       }
       
       .action-buttons {
           display: flex;
           gap: 0.5rem;
       }
       
       .action-btn {
           padding: 0.5rem;
           border: none;
           border-radius: 0.5rem;
           cursor: pointer;
           font-size: 1.2rem;
           width: 35px;
           height: 35px;
           display: flex;
           align-items: center;
           justify-content: center;
           transition: all 0.3s ease;
           text-decoration: none;
       }
       
       .btn-view {
           background: var(--admin-secondary);
           color: white;
       }
       
       .btn-view:hover {
           background: #2980b9;
           color: white;
           text-decoration: none;
       }
       
       .btn-grade {
           background: var(--admin-purple);
           color: white;
       }
       
       .btn-grade:hover {
           background: #8e44ad;
           color: white;
           text-decoration: none;
       }
       
       .btn-edit {
           background: var(--admin-warning);
           color: white;
       }
       
       .btn-edit:hover {
           background: #d68910;
       }
       
       .btn-delete {
           background: var(--admin-danger);
           color: white;
       }
       
       .btn-delete:hover {
           background: #c0392b;
       }
       
       .modal {
           display: none;
           position: fixed;
           z-index: 1000;
           left: 0;
           top: 0;
           width: 100%;
           height: 100vh;
           background-color: rgba(0,0,0,0.5);
       }
       
       .modal-content {
           background-color: white;
           margin: 2% auto;
           padding: 0;
           border-radius: 1rem;
           width: 90%;
           max-width: 800px;
           max-height: 90vh;
           overflow-y: auto;
           box-shadow: 0 10px 30px rgba(0,0,0,0.3);
       }
       
       .modal-header {
           background: var(--admin-primary);
           color: white;
           padding: 1.5rem 2rem;
           border-radius: 1rem 1rem 0 0;
           display: flex;
           justify-content: space-between;
           align-items: center;
       }
       
       .modal-body {
           padding: 2rem;
       }
       
       .close {
           color: white;
           font-size: 28px;
           font-weight: bold;
           cursor: pointer;
           padding: 0.5rem;
           border-radius: 50%;
           transition: background 0.3s ease;
       }
       
       .close:hover {
           background: rgba(255,255,255,0.2);
       }
       
       .submission-list {
           max-height: 400px;
           overflow-y: auto;
       }
       
       .submission-item {
           display: flex;
           justify-content: space-between;
           align-items: center;
           padding: 1rem;
           border-bottom: 1px solid #f0f0f0;
           background: #f8f9fa;
           margin-bottom: 0.5rem;
           border-radius: 0.5rem;
       }
       
       .submission-item:last-child {
           border-bottom: none;
       }
       
       .student-info h4 {
           margin: 0;
           color: var(--admin-primary);
       }
       
       .student-info p {
           margin: 0.2rem 0 0 0;
           color: #7f8c8d;
           font-size: 1.1rem;
       }
       
       .grade-display {
           text-align: center;
           padding: 0.5rem 1rem;
           border-radius: 1rem;
           font-weight: bold;
       }
       
       .grade-excellent { background: #d5f4e6; color: var(--admin-success); }
       .grade-good { background: #cce5ff; color: var(--admin-secondary); }
       .grade-average { background: #fff3cd; color: var(--admin-warning); }
       .grade-poor { background: #ffeaea; color: var(--admin-danger); }
       .grade-pending { background: #e9ecef; color: #6c757d; }
       
       @media (max-width: 768px) {
           .assignment-management {
               padding: 1rem;
           }
           
           .controls-section {
               flex-direction: column;
               align-items: stretch;
           }
           
           .search-filters {
               flex-direction: column;
           }
           
           .data-table {
               font-size: 1.2rem;
           }
           
           .data-table th,
           .data-table td {
               padding: 0.8rem;
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
      
      <asp:Panel runat="server" CssClass="search-form">
          <asp:TextBox ID="txtHeaderSearch" runat="server" CssClass="search-input" placeholder="Search assignments..." MaxLength="100" />
          <asp:LinkButton ID="btnHeaderSearch" runat="server" CssClass="inline-btn search-btn" OnClick="btnHeaderSearch_Click">
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
      <a href="adminDashboard.aspx"><i class="fas fa-tachometer-alt"></i><span>Dashboard</span></a>
      <a href="manageUsers.aspx"><i class="fas fa-users"></i><span>User Management</span></a>
      <a href="manageCourses.aspx"><i class="fas fa-graduation-cap"></i><span>Course Management</span></a>
      <a href="manageAssignments.aspx" class="active"><i class="fas fa-tasks"></i><span>Assignment Oversight</span></a>
      <a href="systemReports.aspx"><i class="fas fa-chart-line"></i><span>Reports & Analytics</span></a>
      <a href="systemSettings.aspx"><i class="fas fa-cog"></i><span>System Settings</span></a>
      <a href="loginWebform.aspx"><i class="fas fa-sign-out-alt"></i><span>Logout</span></a>
   </nav>
</div>

<section class="assignment-management">
    <!-- Page Header -->
    <div style="margin-bottom: 2rem;">
        <h1 class="heading"><i class="fas fa-tasks"></i> Assignment Oversight</h1>
        <p style="color: #7f8c8d; font-size: 1.4rem;">Monitor assignments, submissions, and grading across all courses</p>
    </div>

    <!-- Statistics Grid -->
    <div class="stats-grid">
        <div class="stat-card">
            <i class="fas fa-tasks stat-icon"></i>
            <div class="stat-number"><asp:Label ID="lblTotalAssignments" runat="server" Text="0"></asp:Label></div>
            <div class="stat-label">Total Assignments</div>
        </div>
        <div class="stat-card success">
            <i class="fas fa-check-circle stat-icon" style="color: var(--admin-success);"></i>
            <div class="stat-number"><asp:Label ID="lblActiveAssignments" runat="server" Text="0"></asp:Label></div>
            <div class="stat-label">Active Assignments</div>
        </div>
        <div class="stat-card warning">
            <i class="fas fa-clock stat-icon" style="color: var(--admin-warning);"></i>
            <div class="stat-number"><asp:Label ID="lblDueSoon" runat="server" Text="0"></asp:Label></div>
            <div class="stat-label">Due Soon</div>
        </div>
        <div class="stat-card danger">
            <i class="fas fa-exclamation-triangle stat-icon" style="color: var(--admin-danger);"></i>
            <div class="stat-number"><asp:Label ID="lblOverdue" runat="server" Text="0"></asp:Label></div>
            <div class="stat-label">Overdue</div>
        </div>
        <div class="stat-card purple">
            <i class="fas fa-file-alt stat-icon" style="color: var(--admin-purple);"></i>
            <div class="stat-number"><asp:Label ID="lblTotalSubmissions" runat="server" Text="0"></asp:Label></div>
            <div class="stat-label">Total Submissions</div>
        </div>
        <div class="stat-card">
            <i class="fas fa-star stat-icon"></i>
            <div class="stat-number"><asp:Label ID="lblPendingGrades" runat="server" Text="0"></asp:Label></div>
            <div class="stat-label">Pending Grades</div>
        </div>
    </div>

    <!-- Controls Section -->
    <div class="controls-section">
        <div class="search-filters">
            <asp:TextBox ID="txtSearch" runat="server" CssClass="box" placeholder="Search assignments..." />
            <asp:DropDownList ID="ddlStatusFilter" runat="server" CssClass="box" AutoPostBack="true" OnSelectedIndexChanged="ddlStatusFilter_SelectedIndexChanged">
                <asp:ListItem Text="All Status" Value="" />
                <asp:ListItem Text="Active" Value="Active" />
                <asp:ListItem Text="Due Soon" Value="DueSoon" />
                <asp:ListItem Text="Overdue" Value="Overdue" />
            </asp:DropDownList>
            <asp:DropDownList ID="ddlCourseFilter" runat="server" CssClass="box" AutoPostBack="true" OnSelectedIndexChanged="ddlCourseFilter_SelectedIndexChanged">
                <asp:ListItem Text="All Courses" Value="" />
            </asp:DropDownList>
            <asp:Button ID="btnSearch" runat="server" Text="Search" CssClass="inline-btn" OnClick="btnSearch_Click" />
        </div>
        
        <div style="display: flex; gap: 1rem;">
            <asp:Button ID="btnExportReport" runat="server" Text="Export Report" CssClass="option-btn" OnClick="btnExportReport_Click" />
        </div>
    </div>

    <!-- Assignments Table -->
    <div class="assignments-table">
        <div class="table-header">
            <h3><i class="fas fa-list"></i> System Assignments</h3>
            <span>Total: <asp:Label ID="lblDisplayCount" runat="server" Text="0"></asp:Label> assignments</span>
        </div>
        
        <table class="data-table">
            <thead>
                <tr>
                    <th>Assignment</th>
                    <th>Due Date</th>
                    <th>Status</th>
                    <th>Progress</th>
                    <th>Points</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
                <asp:Repeater ID="assignmentRepeater" runat="server" OnItemCommand="assignmentRepeater_ItemCommand">
                    <ItemTemplate>
                        <tr>
                            <td>
                                <div class="assignment-info">
                                    <div class="assignment-title"><%# Eval("Title") %></div>
                                    <div class="assignment-course"><%# Eval("CourseName") %> - <%# Eval("ModuleTitle") %></div>
                                </div>
                            </td>
                            <td>
                                <div><%# Convert.ToDateTime(Eval("DueDate")).ToString("MMM dd, yyyy") %></div>
                                <div style="font-size: 1rem; color: #7f8c8d;"><%# Convert.ToDateTime(Eval("DueDate")).ToString("hh:mm tt") %></div>
                            </td>
                            <td>
                                <span class="status-badge <%# GetStatusClass(Eval("DueDate")) %>">
                                    <%# GetStatusText(Eval("DueDate")) %>
                                </span>
                            </td>
                            <td>
                                <div class="progress-bar">
                                    <div class="progress-fill" style="width: <%# GetProgressPercentage(Eval("TotalSubmissions"), Eval("EnrolledStudents")) %>%"></div>
                                </div>
                                <div class="progress-text"><%# Eval("TotalSubmissions") %>/<%# Eval("EnrolledStudents") %> submitted</div>
                            </td>
                            <td><%# Eval("MaxPoints") %> pts</td>
                            <td>
                                <div class="action-buttons">
                                    <asp:LinkButton runat="server" CssClass="action-btn btn-view" 
                                                  CommandName="ViewDetails" CommandArgument='<%# Eval("AssignmentID") %>' 
                                                  ToolTip="View Details">
                                        <i class="fas fa-eye"></i>
                                    </asp:LinkButton>
                                    <asp:LinkButton runat="server" CssClass="action-btn btn-grade" 
                                                  CommandName="ManageGrades" CommandArgument='<%# Eval("AssignmentID") %>' 
                                                  ToolTip="Manage Grades">
                                        <i class="fas fa-star"></i>
                                    </asp:LinkButton>
                                    <asp:LinkButton runat="server" CssClass="action-btn btn-edit" 
                                                  CommandName="Edit" CommandArgument='<%# Eval("AssignmentID") %>' 
                                                  ToolTip="Edit Assignment">
                                        <i class="fas fa-edit"></i>
                                    </asp:LinkButton>
                                    <asp:LinkButton runat="server" CssClass="action-btn btn-delete" 
                                                  CommandName="Delete" CommandArgument='<%# Eval("AssignmentID") %>' 
                                                  ToolTip="Delete Assignment"
                                                  OnClientClick="return confirm('Are you sure you want to delete this assignment? This action cannot be undone.');">
                                        <i class="fas fa-trash"></i>
                                    </asp:LinkButton>
                                </div>
                            </td>
                        </tr>
                    </ItemTemplate>
                </asp:Repeater>
            </tbody>
        </table>
        
        <asp:Panel ID="pnlNoAssignments" runat="server" Visible="false">
            <div style="text-align: center; padding: 4rem; color: #7f8c8d;">
                <i class="fas fa-tasks" style="font-size: 6rem; margin-bottom: 2rem; opacity: 0.3;"></i>
                <h3>No Assignments Found</h3>
                <p>No assignments match your current filter criteria.</p>
            </div>
        </asp:Panel>
    </div>

    <!-- Messages -->
    <asp:Label ID="lblMessage" runat="server" Text="" style="display: block; margin: 1rem 0;"></asp:Label>
</section>

<!-- Assignment Details Modal -->
<div id="detailsModal" class="modal">
    <div class="modal-content">
        <div class="modal-header">
            <h2><i class="fas fa-eye"></i> Assignment Details</h2>
            <span class="close" onclick="closeDetailsModal()">&times;</span>
        </div>
        <div class="modal-body">
            <div style="margin-bottom: 2rem;">
                <h3><asp:Label ID="lblModalTitle" runat="server" Text=""></asp:Label></h3>
                <p style="color: #7f8c8d; margin-bottom: 1rem;">
                    <asp:Label ID="lblModalCourse" runat="server" Text=""></asp:Label>
                </p>
                <div style="background: #f8f9fa; padding: 1rem; border-radius: 0.5rem; margin-bottom: 1rem;">
                    <asp:Label ID="lblModalDescription" runat="server" Text=""></asp:Label>
                </div>
                <div style="display: grid; grid-template-columns: 1fr 1fr 1fr; gap: 1rem; margin-bottom: 2rem;">
                    <div style="text-align: center;">
                        <strong>Due Date</strong><br>
                        <asp:Label ID="lblModalDueDate" runat="server" Text=""></asp:Label>
                    </div>
                    <div style="text-align: center;">
                        <strong>Max Points</strong><br>
                        <asp:Label ID="lblModalMaxPoints" runat="server" Text=""></asp:Label>
                    </div>
                    <div style="text-align: center;">
                        <strong>Status</strong><br>
                        <asp:Label ID="lblModalStatus" runat="server" Text=""></asp:Label>
                    </div>
                </div>
            </div>
            
            <div style="background: white; border-radius: 1rem; box-shadow: 0 2px 10px rgba(0,0,0,0.1);">
                <div style="background: var(--admin-primary); color: white; padding: 1rem 1.5rem; border-radius: 1rem 1rem 0 0;">
                    <h3 style="margin: 0;"><i class="fas fa-users"></i> Submissions & Grades</h3>
                </div>
                <div class="submission-list">
                    <asp:Repeater ID="submissionRepeater" runat="server">
                        <ItemTemplate>
                            <div class="submission-item">
                                <div class="student-info">
                                    <h4><%# Eval("StudentName") %></h4>
                                    <p><%# Eval("StudentEmail") %></p>
                                    <p style="font-size: 1rem;">
                                        Submitted: <%# Eval("SubmissionDate") != DBNull.Value ? 
                                                      Convert.ToDateTime(Eval("SubmissionDate")).ToString("MMM dd, yyyy hh:mm tt") : 
                                                      "Not submitted" %>
                                    </p>
                                </div>
                                <div class="grade-display <%# GetGradeClass(Eval("PointsEarned"), Eval("MaxPoints")) %>">
                                    <%# Eval("PointsEarned") != DBNull.Value ? 
                                        Eval("PointsEarned") + "/" + Eval("MaxPoints") : 
                                        "Not Graded" %>
                                </div>
                            </div>
                        </ItemTemplate>
                    </asp:Repeater>
                    
                    <asp:Panel ID="pnlNoSubmissions" runat="server" Visible="false">
                        <div style="text-align: center; padding: 2rem; color: #7f8c8d;">
                            <i class="fas fa-inbox" style="font-size: 4rem; margin-bottom: 1rem; opacity: 0.3;"></i>
                            <p>No submissions for this assignment yet.</p>
                        </div>
                    </asp:Panel>
                </div>
            </div>
        </div>
    </div>
</div>

<footer class="footer">
   &copy; copyright @ 2025 by <span>Stanley Nilam</span> | all rights reserved!
</footer>

<script src="js/script.js"></script>
<script>
    function closeDetailsModal() {
        document.getElementById('detailsModal').style.display = 'none';
    }
    
    // Close modal when clicking outside
    window.onclick = function(event) {
        var detailsModal = document.getElementById('detailsModal');
        
        if (event.target == detailsModal) {
            closeDetailsModal();
        }
    }
    
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