<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AdminManageModules.aspx.cs" Inherits="assignmentDraft1.AdminManageModules" %>

<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <meta charset="UTF-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Admin Manage Modules - Bulb</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.1.2/css/all.min.css" />
    <link rel="stylesheet" href="css/style.css" />
    <style>
        .message {
            display: block;
            padding: 1rem 2rem;
            margin: 1rem 0;
            border-radius: 0.5rem;
            font-size: 1.6rem;
            text-align: center;
            position: fixed;
            top: 20px;
            right: 20px;
            z-index: 2000;
            min-width: 300px;
            box-shadow: 0 4px 8px rgba(0,0,0,0.2);
        }
        
        .message.success {
            background-color: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }
        
        .message.error {
            background-color: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }

        .page-header {
            background: linear-gradient(135deg, var(--admin-primary), var(--admin-secondary));
            color: white;
            padding: 2rem;
            margin-bottom: 3rem;
            border-radius: 1rem;
            box-shadow: 0 4px 8px rgba(0,0,0,0.1);
        }

        .breadcrumb {
            font-size: 1.4rem;
            margin-bottom: 1rem;
        }

        .breadcrumb a {
            color: rgba(255,255,255,0.8);
            text-decoration: none;
        }

        .breadcrumb a:hover {
            color: white;
        }

        .course-info {
            display: grid;
            grid-template-columns: 1fr auto;
            gap: 2rem;
            align-items: center;
        }

        .form-container {
            background: white;
            padding: 2rem;
            border-radius: 1rem;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            margin-bottom: 3rem;
        }

        .form-row {
            display: grid;
            grid-template-columns: 1fr 1fr 1fr;
            gap: 2rem;
            margin-bottom: 2rem;
        }

        .form-group {
            margin-bottom: 2rem;
        }

        .form-group label {
            display: block;
            margin-bottom: 0.5rem;
            font-weight: bold;
            color: var(--black);
            font-size: 1.4rem;
        }

        .form-group input, 
        .form-group textarea,
        .form-group select {
            width: 100%;
            padding: 1rem;
            border: 2px solid #e1e5e9;
            border-radius: 0.5rem;
            font-size: 1.4rem;
            transition: all 0.3s;
        }

        .form-group input:focus, 
        .form-group textarea:focus,
        .form-group select:focus {
            outline: none;
            border-color: var(--admin-primary);
            box-shadow: 0 0 0 3px rgba(52, 152, 219, 0.1);
        }

        .modules-table {
            width: 100%;
            border-collapse: collapse;
            background: white;
            border-radius: 1rem;
            overflow: hidden;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }

        .modules-table th {
            background: linear-gradient(135deg, var(--admin-primary), var(--admin-secondary));
            color: white;
            padding: 1.5rem;
            text-align: left;
            font-weight: bold;
            font-size: 1.4rem;
        }

        .modules-table td {
            padding: 1.5rem;
            border-bottom: 1px solid #f0f0f0;
            font-size: 1.4rem;
        }

        .modules-table tr:hover {
            background-color: #f8f9fa;
        }

        .modules-table tr:last-child td {
            border-bottom: none;
        }

        .action-buttons {
            display: flex;
            gap: 0.5rem;
        }

        .btn-edit, .btn-delete, .btn-lessons {
            padding: 0.6rem 1.2rem;
            border: none;
            border-radius: 0.4rem;
            cursor: pointer;
            font-size: 1.2rem;
            transition: all 0.3s;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
        }

        .btn-edit {
            background-color: var(--orange);
            color: white;
        }

        .btn-edit:hover {
            background-color: #e67e22;
            transform: translateY(-2px);
        }

        .btn-delete {
            background-color: var(--red);
            color: white;
        }

        .btn-delete:hover {
            background-color: #c0392b;
            transform: translateY(-2px);
        }

        .btn-lessons {
            background-color: var(--main-color);
            color: white;
        }

        .btn-lessons:hover {
            background-color: #7b3c1d;
            transform: translateY(-2px);
        }

        .empty-state {
            text-align: center;
            padding: 4rem 2rem;
            color: #666;
        }

        .empty-state i {
            font-size: 4rem;
            margin-bottom: 1rem;
            color: #ddd;
        }

        .form-actions {
            display: flex;
            gap: 1rem;
            justify-content: flex-end;
            margin-top: 2rem;
            padding-top: 2rem;
            border-top: 1px solid #eee;
        }

        .btn-cancel {
            background-color: #6c757d;
            color: white;
            padding: 1rem 2rem;
            border: none;
            border-radius: 0.5rem;
            cursor: pointer;
            font-size: 1.4rem;
            text-decoration: none;
            transition: all 0.3s;
        }

        .btn-cancel:hover {
            background-color: #5a6268;
            transform: translateY(-2px);
        }

        .lecturer-info {
            background: #f8f9fa;
            padding: 0.5rem 1rem;
            border-radius: 0.3rem;
            font-size: 1.2rem;
            color: #666;
        }

        @media (max-width: 768px) {
            .course-info {
                grid-template-columns: 1fr;
                text-align: center;
            }

            .form-row {
                grid-template-columns: 1fr;
            }

            .modules-table {
                font-size: 1.2rem;
            }

            .modules-table th,
            .modules-table td {
                padding: 1rem;
            }

            .action-buttons {
                flex-direction: column;
            }
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <!-- Header -->
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
                    <h3 class="name"><asp:Label ID="lblName" runat="server" Text="Admin Name"></asp:Label></h3>
                    <p class="role"><asp:Label ID="lblRole" runat="server" Text="admin"></asp:Label></p>
                    <a href="profile.aspx" class="btn">view profile</a>
                    <div class="flex-btn">
                        <a href="logout.aspx" class="option-btn">logout</a>
                    </div>
                </div>
            </section>
        </header>

        <!-- Sidebar -->
        <div class="side-bar">
            <div id="close-btn">
                <i class="fas fa-times"></i>
            </div>
            
            <div class="profile">
                <img src="images/pic-1.jpg" class="image" alt="Admin profile" />
                <h3 class="name"><asp:Label runat="server" ID="lblSidebarName" Text="Admin Name" /></h3>
                <p class="role"><asp:Label runat="server" ID="lblSidebarRole" Text="admin" /></p>
                <a href="profile.aspx" class="btn">View Profile</a>
            </div>
            
            <nav class="navbar">
                <a href="adminDashboard.aspx"><i class="fas fa-tachometer-alt"></i><span>Dashboard</span></a>
                <a href="manageUsers.aspx"><i class="fas fa-users"></i><span>User Management</span></a>
                <a href="manageCourses.aspx"><i class="fas fa-graduation-cap"></i><span>Course Management</span></a>
                <a href="manageAssignments.aspx"><i class="fas fa-tasks"></i><span>Assignment Oversight</span></a>
                <a href="systemReports.aspx"><i class="fas fa-chart-line"></i><span>Reports & Analytics</span></a>
                <a href="systemSettings.aspx"><i class="fas fa-cog"></i><span>System Settings</span></a>
                <a href="loginWebform.aspx"><i class="fas fa-sign-out-alt"></i><span>Logout</span></a>
            </nav>
        </div>

        <!-- Main Content -->
        <div class="main-content">
            <!-- Page Header -->
            <div class="page-header">
                <div class="breadcrumb">
                    <a href="adminDashboard.aspx"><i class="fas fa-tachometer-alt"></i> Admin Dashboard</a>
                    <span> / </span>
                    <a href="manageCourses.aspx"><i class="fas fa-graduation-cap"></i> Course Management</a>
                    <span> / </span>
                    <span>Manage Modules</span>
                </div>
                <div class="course-info">
                    <div>
                        <h1><i class="fas fa-th-list"></i> Manage Modules</h1>
                        <h2><asp:Label ID="lblCourseName" runat="server" Text="Course Name"></asp:Label></h2>
                        <p><asp:Label ID="lblCourseDescription" runat="server" Text="Course Description"></asp:Label></p>
                    </div>
                    <div>
                        <a href="manageCourses.aspx" class="btn">
                            <i class="fas fa-arrow-left"></i> Back to Courses
                        </a>
                    </div>
                </div>
            </div>

            <!-- Add/Edit Module Form -->
            <div class="form-container">
                <h3><asp:Label ID="lblFormTitle" runat="server" Text="Add New Module"></asp:Label></h3>
                
                <asp:HiddenField ID="hfModuleID" runat="server" />
                <asp:HiddenField ID="hfCourseID" runat="server" />
                
                <div class="form-row">
                    <div class="form-group">
                        <label for="<%= txtModuleTitle.ClientID %>">Module Title *</label>
                        <asp:TextBox ID="txtModuleTitle" runat="server" placeholder="Enter module title" MaxLength="100" />
                    </div>
                    
                    <div class="form-group">
                        <label for="<%= txtModuleOrder.ClientID %>">Module Order *</label>
                        <asp:TextBox ID="txtModuleOrder" runat="server" placeholder="Enter order (1, 2, 3...)" TextMode="Number" min="1" step="1" />
                    </div>

                    <div class="form-group">
                        <label for="<%= ddlLecturer.ClientID %>">Assign Lecturer *</label>
                        <asp:DropDownList ID="ddlLecturer" runat="server" CssClass="box">
                            <asp:ListItem Text="Select Lecturer" Value="" />
                        </asp:DropDownList>
                    </div>
                </div>
                
                <div class="form-group">
                    <label for="<%= txtModuleDescription.ClientID %>">Description *</label>
                    <asp:TextBox ID="txtModuleDescription" runat="server" TextMode="MultiLine" Rows="4" placeholder="Enter detailed module description" />
                </div>
                
                <div class="form-actions">
                    <asp:Button ID="btnCancel" runat="server" Text="Cancel" CssClass="btn-cancel" OnClick="BtnCancel_Click" />
                    <asp:Button ID="btnSaveModule" runat="server" Text="Save Module" CssClass="btn" OnClick="BtnSaveModule_Click" />
                </div>
            </div>

            <!-- Modules List -->
            <div class="box">
                <div class="title" style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 2rem;">
                    <h3>Course Modules</h3>
                    <span class="likes">Total: <asp:Label ID="lblModuleCount" runat="server" Text="0"></asp:Label></span>
                </div>
                
                <asp:Panel ID="pnlModulesTable" runat="server">
                    <table class="modules-table">
                        <thead>
                            <tr>
                                <th>Order</th>
                                <th>Title</th>
                                <th>Lecturer</th>
                                <th>Description</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <asp:Repeater ID="rptModules" runat="server">
                                <ItemTemplate>
                                    <tr>
                                        <td><strong><%# Eval("ModuleOrder") %></strong></td>
                                        <td><%# Eval("Title") %></td>
                                        <td>
                                            <div class="lecturer-info">
                                                <i class="fas fa-user"></i>
                                                <%# Eval("LecturerName") ?? "Unassigned" %>
                                            </div>
                                        </td>
                                        <td><%# Eval("Description") %></td>
                                        <td>
                                            <div class="action-buttons">
                                                <asp:LinkButton runat="server" CssClass="btn-lessons" 
                                                    CommandName="ManageLessons" CommandArgument='<%# Eval("ModuleID") %>' 
                                                    OnClick="BtnManageLessons_Click">
                                                    <i class="fas fa-book-open"></i> Lessons
                                                </asp:LinkButton>
                                                <asp:LinkButton runat="server" CssClass="btn-edit" 
                                                    CommandName="Edit" CommandArgument='<%# Eval("ModuleID") %>' 
                                                    OnClick="BtnEditModule_Click">
                                                    <i class="fas fa-edit"></i> Edit
                                                </asp:LinkButton>
                                                <asp:LinkButton runat="server" CssClass="btn-delete" 
                                                    CommandName="Delete" CommandArgument='<%# Eval("ModuleID") %>' 
                                                    OnClick="BtnDeleteModule_Click"
                                                    OnClientClick='<%# "return confirm(\"Are you sure you want to delete the module: " + Eval("Title") + "?\");" %>'>
                                                    <i class="fas fa-trash"></i> Delete
                                                </asp:LinkButton>
                                            </div>
                                        </td>
                                    </tr>
                                </ItemTemplate>
                            </asp:Repeater>
                        </tbody>
                    </table>
                </asp:Panel>
                
                <asp:Panel ID="pnlNoModules" runat="server" Visible="false">
                    <div class="empty-state">
                        <i class="fas fa-th-list"></i>
                        <h3>No Modules Found</h3>
                        <p>This course doesn't have any modules yet. Add your first module using the form above.</p>
                    </div>
                </asp:Panel>
            </div>
        </div>

        <!-- Message Display -->
        <asp:Label ID="lblMessage" runat="server" Visible="false" CssClass="message"></asp:Label>

        <footer class="footer">
            &copy; 2025 <span>Bulb</span> Admin Dashboard
        </footer>
    </form>

    <script>
        // Message system
        function showMessage(message, type) {
            const messageEl = document.getElementById('<%= lblMessage.ClientID %>');
            if (messageEl) {
                messageEl.innerHTML = message;
                messageEl.className = 'message ' + (type === 'error' ? 'error' : 'success');
                messageEl.style.display = 'block';
                
                // Auto-hide after 5 seconds
                setTimeout(() => {
                    messageEl.style.display = 'none';
                }, 5000);
            }
        }

        // Enhanced sidebar and header functionality
        let body = document.body;
        let profile = document.querySelector('.header .flex .profile');
        let sideBar = document.querySelector('.side-bar');

        document.querySelector('#user-btn').onclick = () => {
            profile.classList.toggle('active');
        }

        document.querySelector('#menu-btn').onclick = () => {
            sideBar.classList.toggle('active');
            body.classList.toggle('active');
        }

        document.querySelector('#close-btn').onclick = () => {
            sideBar.classList.remove('active');
            body.classList.remove('active');
        }

        document.querySelector('#toggle-btn').onclick = () => {
            body.classList.toggle('dark');
        }

        window.onscroll = () => {
            profile.classList.remove('active');

            if (window.innerWidth < 1200) {
                sideBar.classList.remove('active');
                body.classList.remove('active');
            }
        }

        // Initialize page
        document.addEventListener('DOMContentLoaded', function() {
            console.log('AdminManageModules page loaded successfully');
            
            // Check for any messages from server
            const messageEl = document.getElementById('<%= lblMessage.ClientID %>');
            if (messageEl && messageEl.innerText.trim()) {
                messageEl.style.display = 'block';
                setTimeout(() => {
                    messageEl.style.display = 'none';
                }, 5000);
            }

            // Focus on title field if form is empty
            const titleField = document.getElementById('<%= txtModuleTitle.ClientID %>');
            if (titleField && !titleField.value.trim()) {
                titleField.focus();
            }
        });
    </script>
</body>
</html>