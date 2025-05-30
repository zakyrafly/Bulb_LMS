<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="TeacherWebform.aspx.cs" Inherits="assignmentDraft1.TeacherWebform" %>

<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <meta charset="UTF-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Bulb Teacher Dashboard</title>
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
        
        /* Enhanced modal styling */
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
            background-color: var(--white);
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
        
        /* Confirmation dialog styles */
        .confirmation-dialog {
            position: fixed;
            z-index: 2000;
            left: 50%;
            top: 50%;
            transform: translate(-50%, -50%);
            background-color: white;
            padding: 2rem;
            border-radius: 0.8rem;
            box-shadow: 0 8px 32px rgba(0,0,0,0.3);
            min-width: 400px;
            text-align: center;
            display: none;
        }
        
        .confirmation-overlay {
            position: fixed;
            z-index: 1999;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0,0,0,0.5);
            display: none;
        }
        
        .confirmation-buttons {
            margin-top: 2rem;
            display: flex;
            justify-content: center;
            gap: 1rem;
        }
        
        .btn-confirm {
            background-color: var(--red);
            color: white;
            padding: 0.8rem 2rem;
            border: none;
            border-radius: 0.5rem;
            cursor: pointer;
            font-size: 1.4rem;
            transition: all 0.3s;
        }
        
        .btn-cancel {
            background-color: var(--light-bg);
            color: var(--black);
            padding: 0.8rem 2rem;
            border: none;
            border-radius: 0.5rem;
            cursor: pointer;
            font-size: 1.4rem;
            transition: all 0.3s;
        }
        
        .btn-confirm:hover {
            background-color: #dc2626;
            transform: translateY(-2px);
        }
        
        .btn-cancel:hover {
            background-color: #e5e7eb;
            transform: translateY(-2px);
        }
        
        @media (max-width: 768px) {
            .modal-content {
                width: 95%;
                margin: 5% auto;
                padding: 1.5rem;
            }
            
            .confirmation-dialog {
                width: 90%;
                min-width: unset;
            }
        }

        .inline-btn:focus, 
        .option-btn:focus, 
        .inline-option-btn:focus, 
        .inline-delete-btn:focus {
            outline: 2px solid var(--main-color);
        }

        .inline-btn, .option-btn, .inline-option-btn, .inline-delete-btn {
            display: inline-block;
            padding: 0.8rem 1.5rem;
            border-radius: 0.5rem;
            color: var(--white);
            cursor: pointer;
            text-align: center;
            margin-right: 0.5rem;
            font-size: 1.4rem;
            min-height: 2.5rem;
            min-width: 8rem;
            border: none;
            transition: all 0.3s;
            text-decoration: none;
        }

        .inline-btn {
            background-color: var(--main-color);
        }

        .option-btn {
            background-color: var(--light-bg);
            color: var(--black);
        }

        .inline-option-btn {
            background-color: var(--orange);
        }

        .inline-delete-btn {
            background-color: var(--red);
        }

        .inline-btn:hover, .option-btn:hover, .inline-option-btn:hover, .inline-delete-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(0,0,0,0.2);
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
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <!-- Header -->
        <header class="header">
            <section class="flex">
                <a href="TeacherWebform.aspx" class="logo">Bulb</a>
                <asp:Panel runat="server" CssClass="search-form">
                    <asp:TextBox runat="server" ID="txtSearch" CssClass="search-input" placeholder="Search courses, students..." />
                    <asp:LinkButton runat="server" ID="BtnSearch" CssClass="inline-btn search-btn" OnClick="BtnSearch_Click">
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
                <a href="TeacherWebform.aspx" class="active"><i class="fas fa-home"></i><span>Dashboard</span></a>
                <a href="assignments.aspx"><i class="fas fa-tasks"></i><span>Assignments</span></a>
                <a href="manageStudents.aspx"><i class="fas fa-users"></i><span>Students</span></a>
                <a href="analytics.aspx"><i class="fas fa-chart-line"></i><span>Analytics</span></a>
                <a href="settings.aspx"><i class="fas fa-cog"></i><span>Settings</span></a>
                <a href="loginWebform.aspx"><i class="fas fa-sign-out-alt"></i><span>Logout</span></a>
            </nav>
        </div>

        <!-- Main Content -->
        <div class="main-content">
            <!-- Course Summary Stats -->
            <section class="home-grid">
                <h1 class="heading">Dashboard Overview</h1>
                
                <div class="box-container">
                    <div class="box">
                        <div class="title">Statistics</div>
                        <div class="flex">
                            <a href="TeacherWebform.aspx"><i class="fas fa-book"></i><span>Active Courses: <asp:Label runat="server" ID="lblActiveCourses" Text="0" /></span></a>
                            <a href="manageStudents.aspx"><i class="fas fa-users"></i><span>Total Students: <asp:Label runat="server" ID="lblTotalStudents" Text="0" /></span></a>
                            <a href="assignments.aspx"><i class="fas fa-tasks"></i><span>Active Assignments: <asp:Label runat="server" ID="lblActiveAssignments" Text="0" /></span></a>
                            <a href="#"><i class="fas fa-check-circle"></i><span>Completion Rate: <asp:Label runat="server" ID="lblCompletionRate" Text="0%" /></span></a>
                        </div>
                    </div>
                </div>
            </section>

            <!-- Course Management -->
            <section class="courses">
                <div class="section-header" style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 2rem;">
                    <h1 class="heading" style="margin-bottom: 0;">My Courses</h1>
                </div>
                
                <div class="box-container">
                    <asp:Repeater runat="server" ID="courseRepeater">
                        <ItemTemplate>
                            <div class="box">
                                <div class="tutor">
                                    <img src="images/pic-1.jpg" alt="">
                                    <div class="info">
                                        <h3><%# Eval("CourseName") %></h3>
                                        <span>Course: <%# Eval("Category") %></span>
                                    </div>
                                </div>
                                <h3 class="title"><%# Eval("CourseName") %></h3>
                                <p class="likes">Description: <span><%# Eval("Description") %></span></p>
                                <p class="likes">Category: <span><%# Eval("Category") %></span></p>
                                <p class="likes">Modules: <span><%# Eval("ModuleCount") %></span></p>
                                
                                <div class="flex" style="margin-top: 1.5rem;">
                                    <asp:LinkButton runat="server" ID="btnManageModules" CssClass="inline-btn" 
                                        CommandName="ManageModules" CommandArgument='<%# Eval("CourseID") %>' 
                                        OnClick="BtnManageModules_Click">
                                        <i class="fas fa-th-list"></i> Manage Modules
                                    </asp:LinkButton>
                                </div>
                                    <asp:LinkButton runat="server" CssClass="inline-delete-btn" 
                                        CommandName="Delete" CommandArgument='<%# Eval("CourseID") %>' 
                                        OnClick="BtnDeleteCourse_Click"
                                        OnClientClick='<%# "return confirmDeleteCourse(" + Eval("CourseID") + ", \"" + Eval("CourseName") + "\", " + Eval("ModuleCount") + ");" %>'>
                                        <i class="fas fa-trash"></i> Delete
                                    </asp:LinkButton>
                                    <a href='<%# "EditModules.aspx?courseId=" + Eval("CourseID") %>' class="inline-btn" style="margin-left: 0.5rem;">
                                        <i class="fas fa-edit"></i> Edit Modules
                                    </a>
                                </div>
                            </div>
                        </ItemTemplate>
                    </asp:Repeater>
                    
                    <asp:Panel ID="pnlNoCourses" runat="server" Visible="false">
                        <div class="box">
                            <h3 class="title">No Courses Found</h3>
                        </div>
                    </asp:Panel>
                </div>
            </section>

            <!-- Recent Assignments -->
            <section class="home-grid">
                <h1 class="heading">Recent Assignments</h1>
                
                <div class="box-container">
                    <asp:Repeater ID="assignmentRepeater" runat="server">
                        <ItemTemplate>
                            <div class="box">
                                <h3 class="title"><%# Eval("Title") %></h3>
                                <p class="likes">Course: <span><%# Eval("CourseName") %></span></p>
                                <p class="likes">Due: <span><%# Eval("DueDate", "{0:MMM dd, yyyy}") %></span></p>
                                <p class="likes">Submissions: <span><%# Eval("TotalSubmissions") %>/<%# Eval("MaxStudents") %></span></p>
                                <a href='gradeAssignment.aspx?assignmentID=<%# Eval("AssignmentID") %>' class="inline-btn">Grade Submissions</a>
                            </div>
                        </ItemTemplate>
                    </asp:Repeater>
                    
                    <asp:Panel ID="pnlNoAssignments" runat="server" Visible="false">
                        <div class="box">
                            <h3 class="title">No Recent Assignments</h3>
                            <p>No assignments to display.</p>
                            <a href="assignments.aspx" class="inline-btn">Create Assignment</a>
                        </div>
                    </asp:Panel>
                </div>
            </section>
        </div>

        <!-- Add/Edit Course Modal -->
        <div id="courseModal" class="modal">
            <div class="modal-content">
                <span class="close" onclick="closeCourseModal()">&times;</span>
                <h2 id="modalTitle">Add New Course</h2>
                
                <asp:HiddenField ID="hfCourseID" runat="server" />
                
                <div class="form-group">
                    <label for="<%= txtCourseName.ClientID %>">Course Name:</label>
                    <asp:TextBox ID="txtCourseName" runat="server" placeholder="Enter course name" MaxLength="100" />
                </div>
                
                <div class="form-group">
                    <label for="<%= txtCourseDescription.ClientID %>">Description:</label>
                    <asp:TextBox ID="txtCourseDescription" runat="server" TextMode="MultiLine" Rows="4" placeholder="Enter course description" />
                </div>
                
                <div class="form-group">
                    <label for="<%= txtCategory.ClientID %>">Category:</label>
                    <asp:TextBox ID="txtCategory" runat="server" placeholder="Enter category" MaxLength="50" />
                </div>
                
                <div style="margin-top: 2rem; text-align: right;">
                    <button type="button" onclick="closeCourseModal()" class="btn-cancel">Cancel</button>
                    <asp:Button ID="BtnSaveCourse" runat="server" Text="Save Course" CssClass="btn-confirm" OnClick="BtnSaveCourse_Click" style="background-color: var(--main-color);" />
                </div>
            </div>
        </div>

        <!-- Confirmation Dialog -->
        <div id="confirmationOverlay" class="confirmation-overlay"></div>
        <div id="confirmationDialog" class="confirmation-dialog">
            <h3 id="confirmationTitle">Confirm Action</h3>
            <p id="confirmationMessage">Are you sure you want to proceed?</p>
            <div class="confirmation-buttons">
                <button type="button" class="btn-cancel" onclick="hideConfirmation()">Cancel</button>
                <button type="button" class="btn-confirm" id="confirmButton">Confirm</button>
            </div>
        </div>

        <!-- Message Display -->
        <asp:Label ID="lblMessage" runat="server" Visible="false" CssClass="message"></asp:Label>

        <footer class="footer">
            &copy; 2025 <span>Bulb</span> Teacher Dashboard
        </footer>
    </form>

    <script>
        // Global variables for confirmation dialog
        let confirmationCallback = null;

        // Enhanced confirmation dialog
        function showConfirmation(title, message, callback) {
            document.getElementById('confirmationTitle').innerText = title;
            document.getElementById('confirmationMessage').innerHTML = message;
            document.getElementById('confirmationOverlay').style.display = 'block';
            document.getElementById('confirmationDialog').style.display = 'block';
            confirmationCallback = callback;
            
            document.getElementById('confirmButton').onclick = function() {
                hideConfirmation();
                if (confirmationCallback) {
                    confirmationCallback();
                }
            };
        }

        function hideConfirmation() {
            document.getElementById('confirmationOverlay').style.display = 'none';
            document.getElementById('confirmationDialog').style.display = 'none';
            confirmationCallback = null;
        }

        // Course deletion confirmation
        function confirmDeleteCourse(courseId, courseName, moduleCount) {
            const message = `
                <strong>Delete Course: ${courseName}</strong><br><br>
                This action cannot be undone.<br>
                Modules in this course: ${moduleCount}<br><br>
                Are you sure you want to delete this course?
            `;
            
            showConfirmation('Confirm Course Deletion', message, function() {
                // Create a form and submit it to trigger the server-side delete
                var form = document.getElementById('form1');
                var input = document.createElement('input');
                input.type = 'hidden';
                input.name = 'deleteAction';
                input.value = courseId;
                form.appendChild(input);
                __doPostBack('', 'deleteCourse_' + courseId);
            });
            
            return false; // Prevent immediate postback
        }

        // Modal functionality for courses
        function openAddCourseModal() {
            document.getElementById('courseModal').style.display = 'block';
            document.getElementById('modalTitle').innerText = 'Add New Course';
            clearCourseForm();
        }

        function openEditCourseModal(courseId, courseName, description, category) {
            document.getElementById('courseModal').style.display = 'block';
            document.getElementById('modalTitle').innerText = 'Edit Course';
            
            document.getElementById('<%= txtCourseName.ClientID %>').value = courseName || '';
            document.getElementById('<%= txtCourseDescription.ClientID %>').value = description || '';
            document.getElementById('<%= txtCategory.ClientID %>').value = category || '';
            document.getElementById('<%= hfCourseID.ClientID %>').value = courseId || '';
        }

        function closeCourseModal() {
            document.getElementById('courseModal').style.display = 'none';
            clearCourseForm();
        }

        function clearCourseForm() {
            document.getElementById('<%= txtCourseName.ClientID %>').value = '';
            document.getElementById('<%= txtCourseDescription.ClientID %>').value = '';
            document.getElementById('<%= txtCategory.ClientID %>').value = '';
            document.getElementById('<%= hfCourseID.ClientID %>').value = '';
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
            const courseModal = document.getElementById('courseModal');
            const confirmationOverlay = document.getElementById('confirmationOverlay');

            if (event.target === courseModal) {
                closeCourseModal();
            }

            if (event.target === confirmationOverlay) {
                hideConfirmation();
            }
        }

        // Enhanced sidebar and header functionality
        let body = document.body;
        let profile = document.querySelector('.header .flex .profile');
        let search = document.querySelector('.header .flex .search-form');
        let sideBar = document.querySelector('.side-bar');

        document.querySelector('#user-btn').onclick = () => {
            profile.classList.toggle('active');
            search.classList.remove('active');
        }

        document.querySelector('#search-btn').onclick = () => {
            search.classList.toggle('active');
            profile.classList.remove('active');
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
            search.classList.remove('active');

            if (window.innerWidth < 1200) {
                sideBar.classList.remove('active');
                body.classList.remove('active');
            }
        }

        // Keyboard shortcuts
        document.addEventListener('keydown', function(event) {
            // Escape key closes modals
            if (event.key === 'Escape') {
                if (document.getElementById('courseModal').style.display === 'block') {
                    closeCourseModal();
                }
                if (document.getElementById('confirmationDialog').style.display === 'block') {
                    hideConfirmation();
                }
            }

            // Ctrl+N for new course
            if (event.ctrlKey && event.key === 'n') {
                event.preventDefault();
                openAddCourseModal();
            }
        });

        // Initialize page
        document.addEventListener('DOMContentLoaded', function() {
            console.log('TeacherWebform page loaded successfully');
            
            // Check for any error messages from server
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