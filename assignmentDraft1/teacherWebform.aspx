<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="teacherWebform.aspx.cs" Inherits="assignmentDraft1.teacherWebform" %>

<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <meta charset="UTF-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Bulb Teacher Dashboard</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.1.2/css/all.min.css" />
    <style>
        /* Put your CSS here as you had in your original HTML */
        /* ... (omitted for brevity, but use the same CSS you had before) ... */
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <!-- Header -->
        <header class="header">
            <section class="flex">
                <a href="teacherWebform.aspx" class="logo">Bulb</a>
                <asp:Panel runat="server" CssClass="search-form">
                    <asp:TextBox runat="server" ID="txtSearch" CssClass="" placeholder="Search courses, students..." />
                    <asp:Button runat="server" ID="btnSearch" CssClass="fas fa-search" OnClick="btnSearch_Click" Text=" " />
                </asp:Panel>
                <div class="icons">
                    <div id="menu-btn" class="fas fa-bars"></div>
                    <div id="search-btn" class="fas fa-search"></div>
                    <div id="user-btn" class="fas fa-user"></div>
                    <div id="toggle-btn" class="fas fa-sun"></div>
                </div>
            </section>
        </header>
        <!-- Sidebar -->
        <div class="side-bar">
            <div class="profile">
                <img src="/api/placeholder/100/100" class="image" alt="Teacher profile" />
                <h3 class="name"><asp:Label runat="server" ID="lblTeacherName" Text="Teacher Name" /></h3>
                <p class="role">teacher</p>
                <a href="profile.aspx" class="btn">View Profile</a>
            </div>
            <nav class="navbar">
                <a href="teacherWebform.aspx" class="active"><i class="fas fa-home"></i><span>Dashboard</span></a>
                <a href="addCourse.aspx"><i class="fas fa-plus"></i><span>Add Course</span></a>
                <a href="manageStudents.aspx"><i class="fas fa-users"></i><span>Students</span></a>
                <a href="assignments.aspx"><i class="fas fa-tasks"></i><span>Assignments</span></a>
                <a href="analytics.aspx"><i class="fas fa-chart-line"></i><span>Analytics</span></a>
                <a href="settings.aspx"><i class="fas fa-cog"></i><span>Settings</span></a>
                <a href="logout.aspx"><i class="fas fa-sign-out-alt"></i><span>Logout</span></a>
            </nav>
        </div>
        <!-- Main Content -->
        <div class="main-content">
            <!-- Course Summary Stats -->
            <div class="section">
                <div class="card-grid">
                    <div class="stats-card">
                        <div class="stats-icon">
                            <i class="fas fa-book"></i>
                        </div>
                        <div class="stats-info">
                            <h3><asp:Label runat="server" ID="lblActiveCourses" Text="5" /></h3>
                            <p>Active Courses</p>
                        </div>
                    </div>
                    <div class="stats-card">
                        <div class="stats-icon">
                            <i class="fas fa-users"></i>
                        </div>
                        <div class="stats-info">
                            <h3><asp:Label runat="server" ID="lblTotalStudents" Text="128" /></h3>
                            <p>Total Students</p>
                        </div>
                    </div>
                    <div class="stats-card">
                        <div class="stats-icon">
                            <i class="fas fa-tasks"></i>
                        </div>
                        <div class="stats-info">
                            <h3><asp:Label runat="server" ID="lblActiveAssignments" Text="12" /></h3>
                            <p>Active Assignments</p>
                        </div>
                    </div>
                    <div class="stats-card">
                        <div class="stats-icon">
                            <i class="fas fa-check-circle"></i>
                        </div>
                        <div class="stats-info">
                            <h3><asp:Label runat="server" ID="lblCompletionRate" Text="78%" /></h3>
                            <p>Completion Rate</p>
                        </div>
                    </div>
                </div>
            </div>
            <!-- Course Management -->
            <div class="section">
                <div class="section-header">
                    <h2 class="section-title">Course Management</h2>
                    <a href="addCourse.aspx" class="btn inline-btn"><i class="fas fa-plus"></i> Add New Course</a>
                </div>
                <asp:Repeater runat="server" ID="rptCourses">
                    <HeaderTemplate>
                        <div class="card-grid">
                    </HeaderTemplate>
                    <ItemTemplate>
                        <div class="card">
                            <div class="card-header">
                                <h3 class="card-title"><%# Eval("Title") %></h3>
                            </div>
                            <div class="card-body">
                                <p class="card-text"><%# Eval("Description") %></p>
                                <div class="progress-bar">
                                    <div class="fill" style='<%# "width:" + Eval("CompletionPercent") + ";" %>'></div>
                                </div>
                                <div style="display: flex; justify-content: space-between; font-size: 0.85rem;">
                                    <span><%# Eval("StudentCount") %> Students</span>
                                    <span><%# Eval("CompletionPercent") %> Completion</span>
                                </div>
                            </div>
                            <div class="card-footer">
                                <a href='editCourse.aspx?id=<%# Eval("Id") %>' class="btn btn-outline">Edit</a>
                                <a href='deleteCourse.aspx?id=<%# Eval("Id") %>' class="btn btn-danger" onclick="return confirm('Delete this course?')">Delete</a>
                            </div>
                        </div>
                    </ItemTemplate>
                    <FooterTemplate>
                        </div>
                    </FooterTemplate>
                </asp:Repeater>
            </div>
            <!-- Lessons & Materials, Student Enrollments, Assignments & Grading, Course Analytics -->
            <!-- You can add more ASP.NET controls and repeaters here as needed -->
        </div>
        <div class="footer">
            &copy; 2025 <span>Bulb</span> Teacher Dashboard
        </div>
    </form>
</body>
</html>
