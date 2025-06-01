<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="EditModules.aspx.cs" Inherits="assignmentDraft1.EditModules" %>

<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <meta charset="UTF-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Edit Modules - Bulb</title>
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
            background: linear-gradient(135deg, var(--main-color), var(--orange));
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

        .module-card {
            background: white;
            border-radius: 1rem;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            padding: 2rem;
            margin-bottom: 2rem;
            transition: all 0.3s;
            border-left: 4px solid var(--main-color);
        }

        .module-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 20px rgba(0,0,0,0.15);
        }

        .module-header {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            margin-bottom: 1rem;
        }

        .module-title {
            font-size: 2rem;
            font-weight: bold;
            color: var(--black);
            margin: 0;
        }

        .module-order {
            background: var(--main-color);
            color: white;
            padding: 0.5rem 1rem;
            border-radius: 50%;
            font-weight: bold;
            min-width: 40px;
            text-align: center;
        }

        .module-description {
            color: #666;
            margin: 1rem 0;
            line-height: 1.6;
        }

        .module-actions {
            display: flex;
            gap: 1rem;
            margin-top: 1.5rem;
        }

        .btn-edit, .btn-delete {
            padding: 0.8rem 1.5rem;
            border: none;
            border-radius: 0.5rem;
            cursor: pointer;
            font-size: 1.4rem;
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

        .empty-state {
            text-align: center;
            padding: 4rem 2rem;
            color: #666;
            background: white;
            border-radius: 1rem;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }

        .empty-state i {
            font-size: 4rem;
            margin-bottom: 1rem;
            color: #ddd;
        }

        .stats-bar {
            background: white;
            padding: 1.5rem 2rem;
            border-radius: 1rem;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            margin-bottom: 3rem;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .stat-item {
            text-align: center;
        }

        .stat-number {
            font-size: 2.4rem;
            font-weight: bold;
            color: var(--main-color);
        }

        .stat-label {
            font-size: 1.2rem;
            color: #666;
            margin-top: 0.5rem;
        }

        /* Edit Form Modal */
        .modal {
            position: fixed;
            z-index: 1000;
            left: 0;
            top: 0;
            width: 100%;
            height: 100vh;
            background-color: rgba(0,0,0,0.5);
            display: none;
            overflow-y: auto;
        }
        
        .modal-content {
            background-color: white;
            margin: 3% auto;
            padding: 2rem;
            width: 60%;
            border-radius: 0.8rem;
            max-width: 700px;
            box-shadow: 0 8px 32px rgba(0,0,0,0.3);
            max-height: 90vh;
            overflow-y: auto;
            position: relative;
            animation: modalSlideIn 0.3s ease-out;
        }
        
        @keyframes modalSlideIn {
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
            color: #aaa;
            float: right;
            font-size: 28px;
            font-weight: bold;
            cursor: pointer;
            position: relative;
            z-index: 10;
            transition: color 0.3s;
        }
        
        .close:hover {
            color: #000;
        }

        .form-group {
            margin: 1.5rem 0;
        }

        .form-group label {
            display: block;
            margin-bottom: 0.5rem;
            font-weight: bold;
            color: var(--black);
        }

        .form-group input, .form-group textarea {
            width: 100%;
            padding: 1rem;
            border: 1px solid #ddd;
            border-radius: 0.5rem;
            font-size: 1.4rem;
            transition: border-color 0.3s;
        }

        .form-group input:focus, .form-group textarea:focus {
            outline: none;
            border-color: var(--main-color);
            box-shadow: 0 0 0 2px rgba(139, 69, 19, 0.1);
        }

        @media (max-width: 768px) {
            .course-info {
                grid-template-columns: 1fr;
                text-align: center;
            }

            .module-header {
                flex-direction: column;
                align-items: center;
                text-align: center;
            }

            .module-actions {
                justify-content: center;
            }

            .stats-bar {
                flex-direction: column;
                gap: 1rem;
            }

            .modal-content {
                width: 95%;
                margin: 5% auto;
            }
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <!-- Header -->
        <header class="header">
            <section class="flex">
                <a href="TeacherWebform.aspx" class="logo">Bulb</a>
                <div class="icons">
                    <div id="menu-btn" class="fas fa-bars"></div>
                    <div id="user-btn" class="fas fa-user"></div>
                    <div id="toggle-btn" class="fas fa-sun"></div>
                </div>
                
                <div class="profile">
                    <img src="images/pic-1.jpg" class="image" alt="">
                    <h3 class="name"><asp:Label ID="lblName" runat="server" Text="Teacher Name"></asp:Label></h3>
                    <p class="role"><asp:Label ID="lblRole" runat="server" Text="lecturer"></asp:Label></p>
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
                <img src="images/pic-1.jpg" class="image" alt="Teacher profile" />
                <h3 class="name"><asp:Label runat="server" ID="lblSidebarName" Text="Teacher Name" /></h3>
                <p class="role"><asp:Label runat="server" ID="lblSidebarRole" Text="lecturer" /></p>
                <a href="profile.aspx" class="btn">View Profile</a>
            </div>
            
            <nav class="navbar">
                <a href="TeacherWebform.aspx"><i class="fas fa-home"></i><span>Dashboard</span></a>
                <a href="assignments.aspx"><i class="fas fa-tasks"></i><span>Assignments</span></a>
                <a href="manageStudents.aspx"><i class="fas fa-users"></i><span>Students</span></a>
                <a href="analytics.aspx"><i class="fas fa-chart-line"></i><span>Analytics</span></a>
                <a href="settings.aspx"><i class="fas fa-cog"></i><span>Settings</span></a>
                <a href="loginWebform.aspx"><i class="fas fa-sign-out-alt"></i><span>Logout</span></a>
            </nav>
        </div>

        <!-- Main Content -->
        <div class="main-content">
            <!-- Page Header -->
            <div class="page-header">
                <div class="breadcrumb">
                    <a href="TeacherWebform.aspx"><i class="fas fa-home"></i> Dashboard</a>
                    <span> / </span>
                    <a href='<%# "ManageModules.aspx?courseId=" + Request.QueryString["courseId"] %>'><i class="fas fa-th-list"></i> Manage Modules</a>
                    <span> / </span>
                    <span>Edit Modules</span>
                </div>
                <div class="course-info">
                    <div>
                        <h1><i class="fas fa-edit"></i> Edit Modules</h1>
                        <h2><asp:Label ID="lblCourseName" runat="server" Text="Course Name"></asp:Label></h2>
                        <p><asp:Label ID="lblCourseDescription" runat="server" Text="Course Description"></asp:Label></p>
                    </div>
                    <div>
                        <a href='<%# "ManageModules.aspx?courseId=" + Request.QueryString["courseId"] %>' class="btn">
                            <i class="fas fa-arrow-left"></i> Back to Manage Modules
                        </a>
                    </div>
                </div>
            </div>

            <!-- Statistics Bar -->
            <div class="stats-bar">
                <div class="stat-item">
                    <div class="stat-number"><asp:Label ID="lblModuleCount" runat="server" Text="0"></asp:Label></div>
                    <div class="stat-label">Total Modules</div>
                </div>
                <div class="stat-item">
                    <div class="stat-number"><asp:Label ID="lblLastOrder" runat="server" Text="0"></asp:Label></div>
                    <div class="stat-label">Last Order</div>
                </div>
                <div class="stat-item">
                    <div class="stat-number"><asp:Label ID="lblAssignmentCount" runat="server" Text="0"></asp:Label></div>
                    <div class="stat-label">Total Assignments</div>
                </div>
            </div>

            <!-- Modules List -->
            <asp:Repeater ID="rptModules" runat="server">
                <ItemTemplate>
                    <div class="module-card">
                        <div class="module-header">
                            <h3 class="module-title"><%# Eval("Title") %></h3>
                            <div class="module-order"><%# Eval("ModuleOrder") %></div>
                        </div>
                        <div class="module-description">
                            <%# Eval("Description") %>
                        </div>
                      <!-- Updating the "Edit Module" button in the repeater -->
                        <div class="module-actions">
                            <asp:LinkButton runat="server" CssClass="btn-edit" 
                                CommandName="ManageLessons" CommandArgument='<%# Eval("ModuleID") %>' 
                                OnClick="BtnManageLessons_Click">
                                <i class="fas fa-book-open"></i> Manage Lessons
                            </asp:LinkButton>
                            <asp:LinkButton runat="server" CssClass="btn-delete" 
                                CommandName="Delete" CommandArgument='<%# Eval("ModuleID") %>' 
                                OnClick="BtnDeleteModule_Click"
                                OnClientClick='<%# "return confirm(\"Are you sure you want to delete the module: " + Eval("Title") + "?\\n\\nThis action cannot be undone.\");" %>'>
                                <i class="fas fa-trash"></i> Delete Module
                            </asp:LinkButton>
                        </div>
                    </div>
                </ItemTemplate>
            </asp:Repeater>
            
            <asp:Panel ID="pnlNoModules" runat="server" Visible="false">
                <div class="empty-state">
                    <i class="fas fa-th-list"></i>
                    <h3>No Modules Found</h3>
                    <p>This course doesn't have any modules yet.</p>
                    <a href='<%# "ManageModules.aspx?courseId=" + Request.QueryString["courseId"] %>' class="btn">
                        <i class="fas fa-plus"></i> Add First Module
                    </a>
                </div>
            </asp:Panel>
        </div>

        <!-- Edit Module Modal -->
        <div id="editModuleModal" class="modal">
            <div class="modal-content">
                <span class="close" onclick="closeEditModal()">&times;</span>
                <h2>Edit Module</h2>
                
                <asp:HiddenField ID="hfModuleID" runat="server" />
                <asp:HiddenField ID="hfCourseID" runat="server" />
                
                <div class="form-group">
                    <label for="<%= txtModuleTitle.ClientID %>">Module Title *</label>
                    <asp:TextBox ID="txtModuleTitle" runat="server" placeholder="Enter module title" MaxLength="100" />
                </div>
                
                <div class="form-group">
                    <label for="<%= txtModuleOrder.ClientID %>">Module Order *</label>
                    <asp:TextBox ID="txtModuleOrder" runat="server" placeholder="Enter order (1, 2, 3...)" TextMode="Number" min="1" step="1" />
                </div>
                
                <div class="form-group">
                    <label for="<%= txtModuleDescription.ClientID %>">Description *</label>
                    <asp:TextBox ID="txtModuleDescription" runat="server" TextMode="MultiLine" Rows="4" placeholder="Enter detailed module description" />
                </div>
                
                <div style="margin-top: 2rem; text-align: right;">
                    <button type="button" onclick="closeEditModal()" class="btn" style="background-color: #6c757d;">Cancel</button>
                    <asp:Button ID="btnUpdateModule" runat="server" Text="Update Module" CssClass="btn" OnClick="BtnUpdateModule_Click" style="background-color: var(--main-color);" />
                </div>
            </div>
        </div>

        <!-- Message Display -->
        <asp:Label ID="lblMessage" runat="server" Visible="false" CssClass="message"></asp:Label>

        <footer class="footer">
            &copy; 2025 <span>Bulb</span> Teacher Dashboard
        </footer>
    </form>

    <script>
        // Modal functionality
        function openEditModal() {
            document.getElementById('editModuleModal').style.display = 'block';
        }

        function closeEditModal() {
            document.getElementById('editModuleModal').style.display = 'none';
        }

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

        // Close modal when clicking outside
        window.onclick = function(event) {
            const modal = document.getElementById('editModuleModal');
            if (event.target === modal) {
                closeEditModal();
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
            console.log('EditModules page loaded successfully');
            
            // Check for any messages from server
            const messageEl = document.getElementById('<%= lblMessage.ClientID %>');
            if (messageEl && messageEl.innerText.trim()) {
                messageEl.style.display = 'block';
                setTimeout(() => {
                    messageEl.style.display = 'none';
                }, 5000);
            }
        });
    </script>
</body>
</html>