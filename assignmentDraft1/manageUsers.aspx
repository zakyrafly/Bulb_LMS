<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="manageUsers.aspx.cs" Inherits="assignmentDraft1.manageUsers" %>

<!DOCTYPE html>
<html lang="en">
<head>
   <meta charset="UTF-8">
   <meta http-equiv="X-UA-Compatible" content="IE=edge">
   <meta name="viewport" content="width=device-width, initial-scale=1.0">
   <title>User Management - Bulb Admin</title>
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
       }
       
       .admin-header {
           background: linear-gradient(135deg, var(--admin-primary), var(--admin-secondary));
           color: white;
       }
       
       .admin-header .logo {
           color: white;
           font-weight: bold;
       }
       
       .user-management {
           padding: 2rem;
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
       
       .user-table {
           background: white;
           border-radius: 1rem;
           box-shadow: 0 4px 15px rgba(0,0,0,0.1);
           overflow: hidden;
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
       
       .user-avatar {
           width: 40px;
           height: 40px;
           border-radius: 50%;
           object-fit: cover;
       }
       
       .user-info {
           display: flex;
           align-items: center;
           gap: 1rem;
       }
       
       .user-details h4 {
           margin: 0;
           color: var(--admin-primary);
           font-size: 1.4rem;
       }
       
       .user-details p {
           margin: 0.2rem 0 0 0;
           color: #7f8c8d;
           font-size: 1.1rem;
       }
       
       .role-badge {
           padding: 0.5rem 1rem;
           border-radius: 2rem;
           font-size: 1.1rem;
           font-weight: bold;
           text-transform: capitalize;
       }
       
       .role-admin {
           background: #ffeaea;
           color: var(--admin-danger);
       }
       
       .role-lecturer {
           background: #fff3cd;
           color: var(--admin-warning);
       }
       
       .role-student {
           background: #d5f4e6;
           color: var(--admin-success);
       }
       
       .status-badge {
           padding: 0.4rem 0.8rem;
           border-radius: 1rem;
           font-size: 1rem;
           font-weight: bold;
       }
       
       .status-active {
           background: #d5f4e6;
           color: var(--admin-success);
       }
       
       .status-inactive {
           background: #ffeaea;
           color: var(--admin-danger);
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
       }
       
       .btn-edit {
           background: var(--admin-secondary);
           color: white;
       }
       
       .btn-edit:hover {
           background: #2980b9;
       }
       
       .btn-delete {
           background: var(--admin-danger);
           color: white;
       }
       
       .btn-delete:hover {
           background: #c0392b;
       }
       
       .btn-toggle {
           background: var(--admin-warning);
           color: white;
       }
       
       .btn-toggle:hover {
           background: #d68910;
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
           max-width: 600px;
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
       
       .form-grid {
           display: grid;
           grid-template-columns: 1fr 1fr;
           gap: 1.5rem;
           margin-bottom: 1.5rem;
       }
       
       .form-group {
           margin-bottom: 1.5rem;
       }
       
       .form-group.full-width {
           grid-column: 1 / -1;
       }
       
       .form-group label {
           display: block;
           margin-bottom: 0.5rem;
           font-weight: bold;
           color: var(--admin-primary);
       }
       
       .required {
           color: var(--admin-danger);
       }
       
       .pagination {
           display: flex;
           justify-content: center;
           gap: 0.5rem;
           margin: 2rem 0;
       }
       
       .page-btn {
           padding: 0.8rem 1.2rem;
           border: 1px solid #ddd;
           background: white;
           color: var(--admin-primary);
           border-radius: 0.5rem;
           cursor: pointer;
           transition: all 0.3s ease;
       }
       
       .page-btn:hover,
       .page-btn.active {
           background: var(--admin-secondary);
           color: white;
           border-color: var(--admin-secondary);
       }
       
       .stats-summary {
           display: grid;
           grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
           gap: 1.5rem;
           margin-bottom: 2rem;
       }
       
       .stat-card {
           background: white;
           padding: 1.5rem;
           border-radius: 1rem;
           box-shadow: 0 4px 15px rgba(0,0,0,0.1);
           text-align: center;
       }
       
       .stat-number {
           font-size: 2.5rem;
           font-weight: bold;
           color: var(--admin-secondary);
           margin-bottom: 0.5rem;
       }
       
       .stat-label {
           color: #7f8c8d;
           font-size: 1.2rem;
       }
       
       @media (max-width: 768px) {
           .controls-section {
               flex-direction: column;
               align-items: stretch;
           }
           
           .search-filters {
               flex-direction: column;
           }
           
           .form-grid {
               grid-template-columns: 1fr;
           }
           
           .data-table {
               font-size: 1.2rem;
           }
           
           .data-table th,
           .data-table td {
               padding: 0.8rem;
           }
           
           .user-info {
               flex-direction: column;
               text-align: center;
               gap: 0.5rem;
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
          <asp:TextBox ID="txtHeaderSearch" runat="server" CssClass="search-input" placeholder="Search users..." MaxLength="100" />
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
      <a href="manageUsers.aspx" class="active"><i class="fas fa-users"></i><span>User Management</span></a>
      <a href="manageCourses.aspx"><i class="fas fa-graduation-cap"></i><span>Course Management</span></a>
      <a href="manageAssignments.aspx"><i class="fas fa-tasks"></i><span>Assignment Oversight</span></a>
      <a href="systemReports.aspx"><i class="fas fa-chart-line"></i><span>Reports & Analytics</span></a>
      <a href="systemSettings.aspx"><i class="fas fa-cog"></i><span>System Settings</span></a>
      <a href="loginWebform.aspx"><i class="fas fa-sign-out-alt"></i><span>Logout</span></a>
   </nav>
</div>

<section class="user-management">
    <!-- Page Header -->
    <div style="margin-bottom: 2rem;">
        <h1 class="heading"><i class="fas fa-users"></i> User Management</h1>
        <p style="color: #7f8c8d; font-size: 1.4rem;">Manage system users, roles, and permissions</p>
    </div>

    <!-- Statistics Summary -->
    <div class="stats-summary">
        <div class="stat-card">
            <div class="stat-number"><asp:Label ID="lblTotalUsers" runat="server" Text="0"></asp:Label></div>
            <div class="stat-label">Total Users</div>
        </div>
        <div class="stat-card">
            <div class="stat-number"><asp:Label ID="lblActiveUsers" runat="server" Text="0"></asp:Label></div>
            <div class="stat-label">Active Users</div>
        </div>
        <div class="stat-card">
            <div class="stat-number"><asp:Label ID="lblStudentCount" runat="server" Text="0"></asp:Label></div>
            <div class="stat-label">Students</div>
        </div>
        <div class="stat-card">
            <div class="stat-number"><asp:Label ID="lblLecturerCount" runat="server" Text="0"></asp:Label></div>
            <div class="stat-label">Lecturers</div>
        </div>
    </div>

    <!-- Controls Section -->
    <div class="controls-section">
        <div class="search-filters">
            <asp:TextBox ID="txtSearch" runat="server" CssClass="box" placeholder="Search by name or email..." />
            <asp:DropDownList ID="ddlRoleFilter" runat="server" CssClass="box" AutoPostBack="true" OnSelectedIndexChanged="ddlRoleFilter_SelectedIndexChanged">
                <asp:ListItem Text="All Roles" Value="" />
                <asp:ListItem Text="Students" Value="Student" />
                <asp:ListItem Text="Lecturers" Value="Lecturer" />
                <asp:ListItem Text="Admins" Value="Admin" />
            </asp:DropDownList>
            <asp:Button ID="btnSearch" runat="server" Text="Search" CssClass="inline-btn" OnClick="btnSearch_Click" />
        </div>
        
        <button type="button" class="btn" onclick="openAddUserModal()">
            <i class="fas fa-user-plus"></i> Add New User
        </button>
    </div>

    <!-- Users Table -->
    <div class="user-table">
        <div class="table-header">
            <h3><i class="fas fa-list"></i> System Users</h3>
            <span>Total: <asp:Label ID="lblDisplayCount" runat="server" Text="0"></asp:Label> users</span>
        </div>
        
        <table class="data-table">
            <thead>
                <tr>
                    <th>User</th>
                    <th>Role</th>
                    <th>Contact Info</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
                <asp:Repeater ID="userRepeater" runat="server" OnItemCommand="userRepeater_ItemCommand">
                    <ItemTemplate>
                        <tr>
                            <td>
                                <div class="user-info">
                                    <img src="images/default-avatar.png" alt="User Avatar" class="user-avatar" />
                                    <div class="user-details">
                                        <h4><%# Eval("Name") %></h4>
                                        <p><%# Eval("username") %></p>
                                    </div>
                                </div>
                            </td>
                            <td>
                                <span class="role-badge role-<%# Eval("Role").ToString().ToLower() %>">
                                    <%# Eval("Role") %>
                                </span>
                            </td>
                            <td><%# Eval("ContactInfo") %></td>
                            <td>
                                <div class="action-buttons">
                                    <asp:LinkButton runat="server" CssClass="action-btn btn-edit" 
                                                  CommandName="Edit" CommandArgument='<%# Eval("UserID") %>' 
                                                  ToolTip="Edit User">
                                        <i class="fas fa-edit"></i>

                                    </asp:LinkButton>
                                    <asp:LinkButton runat="server" CssClass="action-btn btn-delete" 
                                                  CommandName="Delete" CommandArgument='<%# Eval("UserID") %>' 
                                                  ToolTip="Delete User"
                                                  OnClientClick="return confirm('Are you sure you want to delete this user? This action cannot be undone.');">
                                        <i class="fas fa-trash"></i>
                                    </asp:LinkButton>
                                </div>
                            </td>
                        </tr>
                    </ItemTemplate>
                </asp:Repeater>
            </tbody>
        </table>
        
        <asp:Panel ID="pnlNoUsers" runat="server" Visible="false">
            <div style="text-align: center; padding: 4rem; color: #7f8c8d;">
                <i class="fas fa-users" style="font-size: 6rem; margin-bottom: 2rem; opacity: 0.3;"></i>
                <h3>No Users Found</h3>
                <p>No users match your current filter criteria.</p>
            </div>
        </asp:Panel>
    </div>

    <!-- Pagination -->
    <asp:Panel ID="pnlPagination" runat="server" CssClass="pagination">
        <!-- Pagination controls will be added here -->
    </asp:Panel>

    <!-- Messages -->
    <asp:Label ID="lblMessage" runat="server" Text="" style="display: block; margin: 1rem 0;"></asp:Label>
</section>

<!-- Add/Edit User Modal -->
<div id="userModal" class="modal">
    <div class="modal-content">
        <div class="modal-header">
            <h2 id="modalTitle">Add New User</h2>
            <span class="close" onclick="closeUserModal()">&times;</span>
        </div>
        <div class="modal-body">
            <asp:HiddenField ID="hfUserID" runat="server" />
            
            <div class="form-grid">
                <div class="form-group">
                    <label>Full Name <span class="required">*</span></label>
                    <asp:TextBox ID="txtFullName" runat="server" CssClass="box" MaxLength="100" placeholder="Enter full name" />
                </div>
                
                <div class="form-group">
                    <label>Email/Username <span class="required">*</span></label>
                    <asp:TextBox ID="txtEmail" runat="server" CssClass="box" TextMode="Email" MaxLength="100" placeholder="Enter email address" />
                </div>
            </div>
            
            <div class="form-grid">
                <div class="form-group">
                    <label>Password <span class="required" id="passwordRequired">*</span></label>
                    <asp:TextBox ID="txtPassword" runat="server" CssClass="box" TextMode="Password" MaxLength="50" placeholder="Enter password" />
                    <small style="color: #7f8c8d; display: block; margin-top: 0.5rem;" id="passwordHelp">
                        Leave blank to keep current password (for existing users)
                    </small>
                </div>
                
                <div class="form-group">
                    <label>Confirm Password <span class="required" id="confirmRequired">*</span></label>
                    <asp:TextBox ID="txtConfirmPassword" runat="server" CssClass="box" TextMode="Password" MaxLength="50" placeholder="Confirm password" />
                </div>
            </div>
            
            <div class="form-grid">
                <div class="form-group">
                    <label>Role <span class="required">*</span></label>
                    <asp:DropDownList ID="ddlRole" runat="server" CssClass="box" onchange="toggleCourseSection()">
                        <asp:ListItem Text="-- Select Role --" Value="" />
                        <asp:ListItem Text="Student" Value="Student" />
                        <asp:ListItem Text="Lecturer" Value="Lecturer" />
                        <asp:ListItem Text="Admin" Value="Admin" />
                    </asp:DropDownList>
                </div>
                
                <div class="form-group" id="courseSection" style="display: none;">
                    <label id="courseLabel">Course <span class="required">*</span></label>
                    <asp:DropDownList ID="ddlCourse" runat="server" CssClass="box">
                        <asp:ListItem Text="-- Select Course --" Value="" />
                    </asp:DropDownList>
                </div>
            </div>
            
            <div class="form-group full-width">
                <label id="contactLabel">Contact Info</label>
                <asp:TextBox ID="txtContactInfo" runat="server" CssClass="box" TextMode="MultiLine" Rows="3" placeholder="Enter contact information" />
            </div>
            
            <div style="display: flex; gap: 1rem; margin-top: 2rem; justify-content: flex-end;">
                <button type="button" class="option-btn" onclick="closeUserModal()">Cancel</button>
                <asp:Button ID="btnSaveUser" runat="server" Text="Save User" CssClass="btn" OnClick="btnSaveUser_Click" />
            </div>
        </div>
    </div>
</div>

<footer class="footer">
   &copy; copyright @ 2025 by <span>Stanley Nilam</span> | all rights reserved!
</footer>

<script src="js/script.js"></script>
<script>
    function openAddUserModal() {
        document.getElementById('modalTitle').innerText = 'Add New User';
        document.getElementById('<%= hfUserID.ClientID %>').value = '';
        document.getElementById('<%= btnSaveUser.ClientID %>').innerText = 'Save User';

        // Show password requirements for new users
        document.getElementById('passwordRequired').style.display = 'inline';
        document.getElementById('confirmRequired').style.display = 'inline';
        document.getElementById('passwordHelp').style.display = 'none';

        clearForm();
        toggleCourseSection(); // Initialize course section
        document.getElementById('userModal').style.display = 'block';
    }

    function openEditUserModal(userId, name, email, role, isActive) {
        document.getElementById('modalTitle').innerText = 'Edit User';
        document.getElementById('<%= hfUserID.ClientID %>').value = userId;
        document.getElementById('<%= btnSaveUser.ClientID %>').innerText = 'Update User';

        // Hide password requirements for existing users
        document.getElementById('passwordRequired').style.display = 'none';
        document.getElementById('confirmRequired').style.display = 'none';
        document.getElementById('passwordHelp').style.display = 'block';

        // Populate form
        document.getElementById('<%= txtFullName.ClientID %>').value = name;
        document.getElementById('<%= txtEmail.ClientID %>').value = email;
        document.getElementById('<%= ddlRole.ClientID %>').value = role;
        
        // Clear password fields
        document.getElementById('<%= txtPassword.ClientID %>').value = '';
        document.getElementById('<%= txtConfirmPassword.ClientID %>').value = '';
        
        // Load user's course if they're a student
        if (role === 'Student') {
            loadUserCourse(userId);
        }
        
        toggleCourseSection(); // Update course section visibility
        document.getElementById('userModal').style.display = 'block';
    }
    
    function closeUserModal() {
        document.getElementById('userModal').style.display = 'none';
        clearForm();
    }
    
    function clearForm() {
        document.getElementById('<%= txtFullName.ClientID %>').value = '';
        document.getElementById('<%= txtEmail.ClientID %>').value = '';
        document.getElementById('<%= txtPassword.ClientID %>').value = '';
        document.getElementById('<%= txtConfirmPassword.ClientID %>').value = '';
        document.getElementById('<%= ddlRole.ClientID %>').selectedIndex = 0;
        document.getElementById('<%= ddlCourse.ClientID %>').selectedIndex = 0;
        document.getElementById('<%= txtContactInfo.ClientID %>').value = '';
    }
    
    function toggleCourseSection() {
        var roleSelect = document.getElementById('<%= ddlRole.ClientID %>');
        var courseSection = document.getElementById('courseSection');
        var courseLabel = document.getElementById('courseLabel');
        var contactLabel = document.getElementById('contactLabel');
        var contactField = document.getElementById('<%= txtContactInfo.ClientID %>');

        if (roleSelect.value === 'Student') {
            courseSection.style.display = 'block';
            courseLabel.innerHTML = 'Course <span class="required">*</span>';
            contactLabel.innerText = 'Contact Info';
            contactField.placeholder = 'Enter contact information';
        } else if (roleSelect.value === 'Lecturer') {
            courseSection.style.display = 'block';
            courseLabel.innerHTML = 'Course to Teach <span class="required">*</span>';
            contactLabel.innerText = 'Department';
            contactField.placeholder = 'Enter your department';
        } else {
            courseSection.style.display = 'none';
            contactLabel.innerText = 'Contact Info';
            contactField.placeholder = 'Enter contact information';
        }
    }
    
    function loadUserCourse(userId) {
        // This would be implemented via AJAX or server-side code
        // For now, we'll handle it in the code-behind
    }
    
    // Close modal when clicking outside
    window.onclick = function(event) {
        var modal = document.getElementById('userModal');
        if (event.target == modal) {
            closeUserModal();
        }
    }
    
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