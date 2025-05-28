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
        }
        
        .modal {
            position: fixed;
            z-index: 1000;
            left: 0;
            top: 0;
            width: 100%;
            height: 100vh;
            background-color: rgba(0,0,0,0.5);
            display: none;
        }
        
        .modal-content {
            background-color: var(--white);
            margin: 5% auto;
            padding: 2rem;
            width: 50%;
            border-radius: 0.5rem;
            max-width: 600px;
        }
        
        .close {
            color: #aaa;
            float: right;
            font-size: 28px;
            font-weight: bold;
            cursor: pointer;
        }
        
        .close:hover {
            color: #000;
        }
        
        @media (max-width: 768px) {
            .modal-content {
                width: 90%;
                margin: 10% auto;
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
                            <a href="assignments.aspx"><i class="fas fa-book"></i><span>Active Courses: <asp:Label runat="server" ID="lblActiveCourses" Text="0" /></span></a>
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
                    <button type="button" onclick="openAddCourseModal()" class="inline-btn"><i class="fas fa-plus"></i> Add New Course</button>
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
                                <div class="flex" style="margin-top: 1rem;">
                                    <asp:LinkButton runat="server" CssClass="inline-option-btn" 
                                        CommandName="Edit" CommandArgument='<%# Eval("CourseID") %>' 
                                        OnClick="BtnEditCourse_Click">
                                        <i class="fas fa-edit"></i> Edit
                                    </asp:LinkButton>
                                    <asp:LinkButton runat="server" CssClass="inline-delete-btn" 
                                        CommandName="Delete" CommandArgument='<%# Eval("CourseID") %>' 
                                        OnClick="BtnDeleteCourse_Click"
                                        OnClientClick="return confirm('Are you sure you want to delete this course?');">
                                        <i class="fas fa-trash"></i> Delete
                                    </asp:LinkButton>
                                </div>
                            </div>
                        </ItemTemplate>
                    </asp:Repeater>
                    
                    <asp:Panel ID="pnlNoCourses" runat="server" Visible="false">
                        <div class="box">
                            <h3 class="title">No Courses Found</h3>
                            <p>You haven't created any courses yet. Click "Add New Course" to get started.</p>
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
            
            <!-- Message Display -->
            <asp:Label ID="lblMessage" runat="server" Visible="false" CssClass="message"></asp:Label>
        </div>

        <!-- Add/Edit Course Modal -->
        <div id="courseModal" class="modal">
            <div class="modal-content">
                <span class="close" onclick="closeCourseModal()">&times;</span>
                <h2 id="modalTitle">Add New Course</h2>
                
                <asp:HiddenField ID="hfCourseID" runat="server" />
                
                <div style="margin: 1rem 0;">
                    <label>Course Name:</label>
                    <asp:TextBox ID="txtCourseName" runat="server" CssClass="box" placeholder="Enter course name" MaxLength="100" />
                </div>
                
                <div style="margin: 1rem 0;">
                    <label>Description:</label>
                    <asp:TextBox ID="txtCourseDescription" runat="server" TextMode="MultiLine" Rows="4" CssClass="box" placeholder="Enter course description" />
                </div>
                
                <div style="margin: 1rem 0;">
                    <label>Category:</label>
                    <asp:TextBox ID="txtCategory" runat="server" CssClass="box" placeholder="Enter category" MaxLength="50" />
                </div>
                
                <div style="margin: 2rem 0;">
                    <asp:Button ID="BtnSaveCourse" runat="server" Text="Save Course" CssClass="btn" OnClick="BtnSaveCourse_Click" />
                </div>
            </div>
        </div>

        <footer class="footer">
            &copy; 2025 <span>Bulb</span> Teacher Dashboard
        </footer>
    </form>

    <script>
        // Modal functionality
        function openAddCourseModal() {
            document.getElementById('courseModal').style.display = 'block';
            document.getElementById('modalTitle').innerText = 'Add New Course';
            // Clear form
            document.getElementById('<%= txtCourseName.ClientID %>').value = '';
            document.getElementById('<%= txtCourseDescription.ClientID %>').value = '';
            document.getElementById('<%= txtCategory.ClientID %>').value = '';
            document.getElementById('<%= hfCourseID.ClientID %>').value = '';
        }

        function openEditCourseModal(courseId, courseName, description, category) {
            document.getElementById('courseModal').style.display = 'block';
            document.getElementById('modalTitle').innerText = 'Edit Course';
            document.getElementById('<%= txtCourseName.ClientID %>').value = courseName;
            document.getElementById('<%= txtCourseDescription.ClientID %>').value = description;
            document.getElementById('<%= txtCategory.ClientID %>').value = category;
            document.getElementById('<%= hfCourseID.ClientID %>').value = courseId;
        }

        function closeCourseModal() {
            document.getElementById('courseModal').style.display = 'none';
        }

        // Close modal when clicking outside
        window.onclick = function (event) {
            var modal = document.getElementById('courseModal');
            if (event.target == modal) {
                modal.style.display = 'none';
            }
        }

        // Include your existing script.js functionality here
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
    </script>
</body>
</html>