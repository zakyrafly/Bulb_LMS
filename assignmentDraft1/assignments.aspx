<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="assignments.aspx.cs" Inherits="assignmentDraft1.assignments" %>

<!DOCTYPE html>
<html lang="en">
<head>
   <meta charset="UTF-8">
   <meta http-equiv="X-UA-Compatible" content="IE=edge">
   <meta name="viewport" content="width=device-width, initial-scale=1.0">
   <title>Assignment Management</title>
   <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.1.2/css/all.min.css">
   <link rel="stylesheet" href="css/style.css">
   
   <style>
       .assignment-grid {
           display: grid;
           grid-template-columns: repeat(auto-fit, minmax(400px, 1fr));
           gap: 2rem;
           margin: 2rem 0;
       }
       
       .assignment-card {
           background: var(--white);
           border-radius: .5rem;
           box-shadow: var(--box-shadow);
           padding: 2rem;
           border-left: 4px solid var(--main-color);
       }
       
       .assignment-header {
           display: flex;
           justify-content: space-between;
           align-items: flex-start;
           margin-bottom: 1rem;
       }
       
       .assignment-title {
           font-size: 1.8rem;
           color: var(--black);
           margin-bottom: 0.5rem;
       }
       
       .assignment-meta {
           display: grid;
           grid-template-columns: 1fr 1fr;
           gap: 1rem;
           margin: 1rem 0;
           font-size: 1.2rem;
       }
       
       .meta-item {
           display: flex;
           align-items: center;
           gap: 0.5rem;
       }
       
       .assignment-stats {
           display: flex;
           justify-content: space-between;
           margin: 1.5rem 0;
           padding: 1rem;
           background: var(--light-bg);
           border-radius: .3rem;
       }
       
       .stat-item {
           text-align: center;
       }
       
       .stat-number {
           font-size: 2rem;
           font-weight: bold;
           color: var(--main-color);
       }
       
       .stat-label {
           font-size: 1.1rem;
           color: var(--light-color);
       }
       
       .assignment-actions {
           display: flex;
           gap: 1rem;
           margin-top: 1.5rem;
       }
       
       .modal {
           display: none;
           position: fixed;
           z-index: 1000;
           left: 0;
           top: 0;
           width: 100%;
           height: 100%;
           background-color: rgba(0,0,0,0.5);
       }
       
       .modal-content {
           background-color: var(--white);
           margin: 5% auto;
           padding: 2rem;
           border-radius: .5rem;
           width: 80%;
           max-width: 600px;
           max-height: 80vh;
           overflow-y: auto;
       }
       
       .close {
           color: #aaa;
           float: right;
           font-size: 28px;
           font-weight: bold;
           cursor: pointer;
       }
       
       .close:hover {
           color: var(--main-color);
       }
       
       .form-group {
           margin: 1.5rem 0;
       }
       
       .form-group label {
           display: block;
           margin-bottom: 0.5rem;
           font-weight: bold;
       }
       
       .due-soon {
           border-left-color: #f39c12;
       }
       
       .overdue {
           border-left-color: #e74c3c;
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
      <a href="addCourse.aspx"><i class="fas fa-plus"></i><span>Add Course</span></a>
      <a href="manageStudents.aspx"><i class="fas fa-users"></i><span>Students</span></a>
      <a href="assignments.aspx" class="active"><i class="fas fa-tasks"></i><span>Assignments</span></a>
      <a href="analytics.aspx"><i class="fas fa-chart-line"></i><span>Analytics</span></a>
      <a href="settings.aspx"><i class="fas fa-cog"></i><span>Settings</span></a>
      <a href="loginWebform.aspx"><i class="fas fa-sign-out-alt"></i><span>Logout</span></a>
   </nav>
</div>

<section class="course-content">
    <!-- Page Header -->
    <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 2rem;">
        <h1 class="heading"><i class="fas fa-tasks"></i> Assignment Management</h1>
        <button type="button" class="btn" onclick="openAddModal()">
            <i class="fas fa-plus"></i> Create New Assignment
        </button>
    </div>

    <!-- Filter Options -->
    <div style="display: flex; gap: 1rem; margin-bottom: 2rem; flex-wrap: wrap;">
        <asp:DropDownList ID="ddlModuleFilter" runat="server" CssClass="box" AutoPostBack="true" OnSelectedIndexChanged="ddlModuleFilter_SelectedIndexChanged">
            <asp:ListItem Text="All Modules" Value="" />
        </asp:DropDownList>
        
        <asp:DropDownList ID="ddlStatusFilter" runat="server" CssClass="box" AutoPostBack="true" OnSelectedIndexChanged="ddlStatusFilter_SelectedIndexChanged">
            <asp:ListItem Text="All Statuses" Value="" />
            <asp:ListItem Text="Active" Value="Active" />
            <asp:ListItem Text="Due Soon" Value="DueSoon" />
            <asp:ListItem Text="Overdue" Value="Overdue" />
        </asp:DropDownList>
    </div>

    <!-- Assignments Grid -->
    <div class="assignment-grid">
        <asp:Repeater ID="assignmentRepeater" runat="server" OnItemCommand="assignmentRepeater_ItemCommand">
            <ItemTemplate>
                <div class="assignment-card <%# GetCardClass(Eval("DueDate")) %>">
                    <div class="assignment-header">
                        <h3 class="assignment-title"><%# Eval("Title") %></h3>
                        <span class="status-badge <%# GetStatusClass(Eval("DueDate")) %>">
                            <%# GetStatusText(Eval("DueDate")) %>
                        </span>
                    </div>
                    
                    <p style="color: var(--light-color); margin-bottom: 1rem;">
                        <%# Eval("Description") %>
                    </p>
                    
                    <div class="assignment-meta">
                        <div class="meta-item">
                            <i class="fas fa-book"></i>
                            <span><%# Eval("ModuleTitle") %></span>
                        </div>
                        <div class="meta-item">
                            <i class="fas fa-calendar"></i>
                            <span><%# Convert.ToDateTime(Eval("DueDate")).ToString("MMM dd, yyyy") %></span>
                        </div>
                        <div class="meta-item">
                            <i class="fas fa-star"></i>
                            <span><%# Eval("MaxPoints") %> points</span>
                        </div>
                        <div class="meta-item">
                            <i class="fas fa-clock"></i>
                            <span><%# Convert.ToDateTime(Eval("DueDate")).ToString("hh:mm tt") %></span>
                        </div>
                    </div>
                    
                    <div class="assignment-stats">
                        <div class="stat-item">
                            <div class="stat-number"><%# Eval("TotalSubmissions") %></div>
                            <div class="stat-label">Submissions</div>
                        </div>
                        <div class="stat-item">
                            <div class="stat-number"><%# Eval("GradedSubmissions") %></div>
                            <div class="stat-label">Graded</div>
                        </div>
                        <div class="stat-item">
                            <div class="stat-number"><%# Eval("PendingGrades") %></div>
                            <div class="stat-label">Pending</div>
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
                                      OnClientClick="return confirm('Are you sure you want to delete this assignment?');">
                            <i class="fas fa-trash"></i> Delete
                        </asp:LinkButton>
                    </div>
                </div>
            </ItemTemplate>
        </asp:Repeater>
    </div>

    <!-- No Assignments Message -->
    <asp:Panel ID="pnlNoAssignments" runat="server" Visible="false">
        <div style="text-align: center; padding: 4rem; color: var(--light-color);">
            <i class="fas fa-tasks" style="font-size: 6rem; margin-bottom: 2rem; opacity: 0.3;"></i>
            <h2>No Assignments Found</h2>
            <p>Create your first assignment to get started!</p>
            <button type="button" class="btn" onclick="openAddModal()">
                <i class="fas fa-plus"></i> Create Assignment
            </button>
        </div>
    </asp:Panel>

    <!-- Messages -->
    <asp:Label ID="lblMessage" runat="server" Text="" style="display: block; margin: 1rem 0;"></asp:Label>
</section>

<!-- Add/Edit Assignment Modal -->
<div id="assignmentModal" class="modal">
    <div class="modal-content">
        <span class="close" onclick="closeModal()">&times;</span>
        <h2 id="modalTitle">Add New Assignment</h2>
        
        <div class="form-group">
            <label>Assignment Title *</label>
            <asp:TextBox ID="txtTitle" runat="server" CssClass="box" MaxLength="200" placeholder="Enter assignment title"></asp:TextBox>
        </div>
        
        <div class="form-group">
            <label>Module *</label>
            <asp:DropDownList ID="ddlModule" runat="server" CssClass="box">
            </asp:DropDownList>
        </div>
        
        <div class="form-group">
            <label>Description *</label>
            <asp:TextBox ID="txtDescription" runat="server" CssClass="box" TextMode="MultiLine" 
                       Rows="4" placeholder="Enter assignment description"></asp:TextBox>
        </div>
        
        <div class="form-group">
            <label>Instructions</label>
            <asp:TextBox ID="txtInstructions" runat="server" CssClass="box" TextMode="MultiLine" 
                       Rows="6" placeholder="Enter detailed instructions for students"></asp:TextBox>
        </div>
        
        <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 1rem;">
            <div class="form-group">
                <label>Due Date *</label>
                <asp:TextBox ID="txtDueDate" runat="server" CssClass="box" TextMode="Date"></asp:TextBox>
            </div>
            <div class="form-group">
                <label>Due Time *</label>
                <asp:TextBox ID="txtDueTime" runat="server" CssClass="box" TextMode="Time"></asp:TextBox>
            </div>
        </div>
        
        <div class="form-group">
            <label>Maximum Points *</label>
            <asp:TextBox ID="txtMaxPoints" runat="server" CssClass="box" TextMode="Number" 
                       placeholder="100" min="1" max="1000"></asp:TextBox>
        </div>
        
        <div style="display: flex; gap: 1rem; margin-top: 2rem;">
            <asp:Button ID="btnSaveAssignment" runat="server" Text="Save Assignment" 
                      CssClass="btn" OnClick="btnSaveAssignment_Click" />
            <button type="button" class="option-btn" onclick="closeModal()">Cancel</button>
        </div>
        
        <asp:HiddenField ID="hfAssignmentID" runat="server" />
    </div>
</div>

<footer class="footer">
   &copy; copyright @ 2025 by <span>Stanley Nilam</span> | all rights reserved!
</footer>

<script src="js/script.js"></script>
<script>
    function openAddModal() {
        document.getElementById('modalTitle').innerText = 'Add New Assignment';
        document.getElementById('<%= hfAssignmentID.ClientID %>').value = '';
        document.getElementById('<%= btnSaveAssignment.ClientID %>').innerText = 'Save Assignment';
        document.getElementById('assignmentModal').style.display = 'block';
    }
    
    function openEditModal(assignmentId) {
        document.getElementById('modalTitle').innerText = 'Edit Assignment';
        document.getElementById('<%= hfAssignmentID.ClientID %>').value = assignmentId;
        document.getElementById('<%= btnSaveAssignment.ClientID %>').innerText = 'Update Assignment';
        document.getElementById('assignmentModal').style.display = 'block';
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
    
    // Close modal when clicking outside
    window.onclick = function(event) {
        var modal = document.getElementById('assignmentModal');
        if (event.target == modal) {
            closeModal();
        }
    }
</script>

    </form>
</body>
</html>