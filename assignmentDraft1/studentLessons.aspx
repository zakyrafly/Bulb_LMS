<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="studentLessons.aspx.cs" Inherits="assignmentDraft1.studentLessons" %>

<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Lessons - Bulb LMS</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.1.2/css/all.min.css">
    <link rel="stylesheet" href="css/style.css">
    <style>
        /* Additional Styling */
        .module-section {
            margin-bottom: 3rem;
        }
        
        .module-header {
            background: linear-gradient(135deg, var(--main-color), var(--orange));
            color: white;
            padding: 1.5rem 2rem;
            border-radius: 1rem 1rem 0 0;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        
        .module-title {
            font-size: 2rem;
            margin: 0;
        }
        
        .module-lecturer {
            font-size: 1.4rem;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }
        
        .module-content {
            background: white;
            border-radius: 0 0 1rem 1rem;
            padding: 2rem;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        
        .lesson-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
            gap: 2rem;
        }
        
        .lesson-card {
            background: var(--light-bg);
            border-radius: 1rem;
            overflow: hidden;
            transition: all 0.3s;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            display: flex;
            flex-direction: column;
            cursor: pointer;
            border-left: 4px solid var(--main-color);
        }
        
        .lesson-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 16px rgba(0,0,0,0.15);
        }
        
        .lesson-header {
            padding: 1.5rem;
            border-bottom: 1px solid rgba(0,0,0,0.05);
        }
        
        .lesson-title {
            font-size: 1.6rem;
            margin: 0;
            color: var(--black);
        }
        
        .lesson-body {
            padding: 1.5rem;
            flex-grow: 1;
            display: flex;
            flex-direction: column;
        }
        
        .lesson-content-type {
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            padding: 0.5rem 1rem;
            background: var(--main-color);
            color: white;
            border-radius: 2rem;
            font-size: 1.2rem;
            margin-bottom: 1rem;
        }
        
        .lesson-meta {
            margin-bottom: 1.5rem;
            color: var(--light-color);
            font-size: 1.3rem;
        }
        
        .lesson-meta-item {
            display: flex;
            align-items: center;
            gap: 0.5rem;
            margin-bottom: 0.5rem;
        }
        
        .lesson-meta-item i {
            color: var(--main-color);
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

        /* Header section styling */
        .page-header {
            background: linear-gradient(135deg, var(--main-color), var(--orange));
            color: white;
            padding: 3rem 2rem;
            margin-bottom: 3rem;
            border-radius: 1rem;
            box-shadow: 0 4px 8px rgba(0,0,0,0.1);
        }

        .page-title {
            font-size: 2.8rem;
            margin-bottom: 1rem;
        }

        .page-subtitle {
            font-size: 1.6rem;
            opacity: 0.9;
            margin-bottom: 0;
        }
        
        /* Mobile responsiveness */
        @media (max-width: 768px) {
            .lesson-grid {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <!-- Header -->
        <header class="header">
            <section class="flex">
                <a href="homeWebform.aspx" class="logo">Bulb</a>

                <asp:Panel runat="server" CssClass="search-form">
                    <asp:TextBox ID="txtSearch" runat="server" CssClass="search-input" placeholder="Search courses, lessons..." MaxLength="100" />
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
                    <h3 class="name"><asp:Label ID="lblName" runat="server" Text="Student Name"></asp:Label></h3>
                    <p class="role"><asp:Label ID="lblRole" runat="server" Text="student"></asp:Label></p>
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
                <img src="images/pic-1.jpg" class="image" alt="">
                <h3 class="name"><asp:Label ID="lblSidebarName" runat="server" Text="Student Name"></asp:Label></h3>
                <p class="role"><asp:Label ID="lblSidebarRole" runat="server" Text="student"></asp:Label></p>
                <a href="profile.aspx" class="btn">view profile</a>
            </div>

            <nav class="navbar">
                <a href="homeWebform.aspx"><i class="fas fa-home"></i><span>Home</span></a>
                <a href="studentLessons.aspx" class="active"><i class="fas fa-graduation-cap"></i><span>My Courses</span></a>
                <a href="student-assignments.aspx"><i class="fas fa-tasks"></i><span>Assignments</span></a>
                <a href="calendar.aspx"><i class="fas fa-calendar"></i><span>Calendar</span></a>
                <a href="profile.aspx"><i class="fas fa-user"></i><span>Profile</span></a>
                <a href="loginWebform.aspx"><i class="fas fa-sign-out-alt"></i><span>Logout</span></a>
            </nav>
        </div>

        <!-- Main Content -->
        <section class="main-content">
            <!-- Page Header -->
            <div class="page-header">
                <h1 class="page-title"><i class="fas fa-book-open"></i> My Lessons</h1>
                <p class="page-subtitle">Access all your course materials</p>
            </div>

            <!-- Modules List -->
            <asp:Repeater ID="moduleRepeater" runat="server" OnItemDataBound="ModuleRepeater_ItemDataBound">
                <ItemTemplate>
                    <div class="module-section">
                        <div class="module-header">
                            <h2 class="module-title"><%# Eval("Title") %></h2>
                            <div class="module-lecturer">
                                <i class="fas fa-user"></i>
                                <span><%# Eval("LecturerName") ?? "Instructor" %></span>
                            </div>
                        </div>
                        <div class="module-content">
                            <asp:HiddenField ID="hfModuleId" runat="server" Value='<%# Eval("ModuleID") %>' />
                            
                            <asp:Repeater ID="lessonRepeater" runat="server">
                                <HeaderTemplate>
                                    <div class="lesson-grid">
                                </HeaderTemplate>
                                <ItemTemplate>
                                    <div class="lesson-card" onclick="navigateToLesson(<%# ((HiddenField)Container.Parent.Parent.FindControl("hfModuleId")).Value %>, <%# Eval("LessonID") %>)">
                                        <div class="lesson-header">
                                            <h3 class="lesson-title"><%# Eval("Title") %></h3>
                                        </div>
                                        <div class="lesson-body">
                                            <div class="lesson-content-type">
                                                <i class="fas <%# GetContentTypeIcon(Eval("ContentType").ToString()) %>"></i>
                                                <%# GetContentTypeLabel(Eval("ContentType").ToString()) %>
                                            </div>
                                            <div class="lesson-meta">
                                                <div class="lesson-meta-item">
                                                    <i class="fas fa-clock"></i>
                                                    <span><%# Eval("Duration") %> minutes</span>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </ItemTemplate>
                                <FooterTemplate>
                                    </div>
                                </FooterTemplate>
                            </asp:Repeater>
                            
                            <asp:Panel ID="noLessonsPanel" runat="server" Visible="false" CssClass="empty-state">
                                <i class="fas fa-book"></i>
                                <h3>No Lessons Available</h3>
                                <p>This module doesn't have any lessons yet.</p>
                            </asp:Panel>
                        </div>
                    </div>
                </ItemTemplate>
            </asp:Repeater>
            
            <!-- No Modules Message -->
            <asp:Panel ID="noModulesPanel" runat="server" Visible="false" CssClass="empty-state">
                <i class="fas fa-graduation-cap"></i>
                <h3>No Modules Available</h3>
                <p>You are not enrolled in any courses with modules yet.</p>
                <a href="courses.html" class="btn">
                    <i class="fas fa-search"></i> Browse Courses
                </a>
            </asp:Panel>
        </section>

        <footer class="footer">
            &copy; 2025 <span>Bulb</span> Learning Management System
        </footer>
    </form>

    <script>
        // Navigate to the lessons page with moduleID and lessonID
        function navigateToLesson(moduleId, lessonId) {
            window.location.href = `lessons.aspx?moduleID=${moduleId}&lessonID=${lessonId}`;
        }

        // Sidebar functionality
        document.addEventListener('DOMContentLoaded', function () {
            // Set up sidebar toggle
            const bodyElement = document.body;
            const profile = document.querySelector('.header .flex .profile');
            const search = document.querySelector('.header .flex .search-form');
            const sideBar = document.querySelector('.side-bar');

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
                bodyElement?.classList.toggle('active');
            });

            document.querySelector('#close-btn')?.addEventListener('click', () => {
                sideBar?.classList.remove('active');
                bodyElement?.classList.remove('active');
            });

            document.querySelector('#toggle-btn')?.addEventListener('click', () => {
                bodyElement?.classList.toggle('dark');
            });

            window.addEventListener('scroll', () => {
                profile?.classList.remove('active');
                search?.classList.remove('active');

                if (window.innerWidth < 1200) {
                    sideBar?.classList.remove('active');
                    bodyElement?.classList.remove('active');
                }
            });
        });
    </script>
</body>
</html>