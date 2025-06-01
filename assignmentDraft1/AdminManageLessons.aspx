<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AdminManageLessons.aspx.cs" Inherits="assignmentDraft1.AdminManageLessons" %>

<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <meta charset="UTF-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Admin Manage Lessons - Bulb</title>
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

        .module-info {
            display: grid;
            grid-template-columns: 1fr auto;
            gap: 2rem;
            align-items: center;
        }

        .lesson-card {
            background: white;
            border-radius: 1rem;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            padding: 2rem;
            margin-bottom: 2rem;
            transition: all 0.3s;
            border-left: 4px solid var(--admin-primary);
            display: flex;
            flex-direction: column;
        }

        .lesson-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 20px rgba(0,0,0,0.15);
        }

        .lesson-header {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            margin-bottom: 1rem;
        }

        .lesson-title {
            font-size: 2rem;
            font-weight: bold;
            color: var(--black);
            margin: 0;
        }

        .lesson-id {
            background: var(--admin-primary);
            color: white;
            padding: 0.5rem 1rem;
            border-radius: 0.5rem;
            font-weight: bold;
            min-width: 60px;
            text-align: center;
        }

        .lesson-content-type {
            display: inline-block;
            padding: 0.5rem 1rem;
            border-radius: 2rem;
            font-size: 1.2rem;
            background: var(--light-bg);
            color: var(--black);
            margin-bottom: 1rem;
        }

        .lesson-duration {
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            font-size: 1.4rem;
            color: var(--light-color);
            margin-bottom: 1rem;
        }

        .lesson-duration i {
            color: var(--admin-primary);
        }

        .lesson-content {
            margin: 1.5rem 0;
            line-height: 1.6;
            color: var(--light-color);
            overflow: hidden;
            text-overflow: ellipsis;
            display: -webkit-box;
            -webkit-line-clamp: 3;
            -webkit-box-orient: vertical;
        }

        .lesson-actions {
            display: flex;
            gap: 1rem;
            margin-top: auto;
        }

        .btn-edit, .btn-delete, .btn-view {
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

        .btn-view {
            background-color: var(--admin-primary);
            color: white;
        }

        .btn-view:hover {
            background-color: #2980b9;
            transform: translateY(-2px);
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
            color: var(--admin-primary);
        }

        .stat-label {
            font-size: 1.2rem;
            color: #666;
            margin-top: 0.5rem;
        }

        /* Add/Edit Lesson Modal */
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
            width: 70%;
            border-radius: 0.8rem;
            max-width: 800px;
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

        .form-group input, .form-group textarea, .form-group select {
            width: 100%;
            padding: 1rem;
            border: 1px solid #ddd;
            border-radius: 0.5rem;
            font-size: 1.4rem;
            transition: border-color 0.3s;
        }

        .form-group input:focus, .form-group textarea:focus, .form-group select:focus {
            outline: none;
            border-color: var(--admin-primary);
            box-shadow: 0 0 0 2px rgba(52, 152, 219, 0.1);
        }

        .content-type-container {
            margin-top: 1rem;
        }

        /* Preview section */
        .preview-section {
            margin-top: 2rem;
            padding: 1rem;
            border: 1px dashed #ddd;
            border-radius: 0.5rem;
            background-color: #f9f9f9;
        }

        .preview-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 1rem;
        }

        .preview-title {
            font-size: 1.6rem;
            font-weight: bold;
            color: var(--admin-primary);
        }

        .preview-content {
            min-height: 100px;
            padding: 1rem;
            background-color: white;
            border-radius: 0.5rem;
            box-shadow: 0 1px 3px rgba(0,0,0,0.1);
        }

        /* View Lesson Modal */
        .lesson-view-container {
            padding: 2rem;
        }

        .lesson-view-header {
            margin-bottom: 2rem;
            padding-bottom: 1rem;
            border-bottom: 1px solid #eee;
        }

        .lesson-view-title {
            font-size: 2.4rem;
            margin-bottom: 0.5rem;
            color: var(--black);
        }

        .lesson-view-meta {
            display: flex;
            flex-wrap: wrap;
            gap: 2rem;
            margin-bottom: 1rem;
        }

        .lesson-view-meta-item {
            display: flex;
            align-items: center;
            gap: 0.5rem;
            font-size: 1.4rem;
            color: var(--light-color);
        }

        .lesson-view-meta-item i {
            color: var(--admin-primary);
        }

        .lesson-view-content {
            margin-top: 2rem;
        }

        .lesson-view-content iframe,
        .lesson-view-content video {
            width: 100%;
            border-radius: 0.5rem;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            margin-bottom: 1.5rem;
        }

        .lesson-view-text {
            line-height: 1.8;
            font-size: 1.6rem;
            color: var(--black);
        }

        .content-url-container {
            margin-top: 1rem;
            display: none;
        }

        .text-content-container {
            margin-top: 1rem;
            display: none;
        }

        @media (max-width: 768px) {
            .module-info {
                grid-template-columns: 1fr;
                text-align: center;
            }

            .lesson-header {
                flex-direction: column;
                align-items: center;
                text-align: center;
            }

            .lesson-actions {
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
                    <a href='<%# "AdminManageModules.aspx?courseId=" + Request.QueryString["courseId"] %>'><i class="fas fa-th-list"></i> Manage Modules</a>
                    <span> / </span>
                    <span>Manage Lessons</span>
                </div>
                <div class="module-info">
                    <div>
                        <h1><i class="fas fa-book-open"></i> Manage Lessons</h1>
                        <h2><asp:Label ID="lblModuleTitle" runat="server" Text="Module Title"></asp:Label></h2>
                        <p><asp:Label ID="lblModuleDescription" runat="server" Text="Module Description"></asp:Label></p>
                        <div style="margin-top: 1rem;">
                            <strong>Lecturer:</strong> <asp:Label ID="lblLecturerName" runat="server" Text="Unassigned"></asp:Label>
                        </div>
                    </div>
                    <div>
                        <a href='<%# "AdminManageModules.aspx?courseId=" + Request.QueryString["courseId"] %>' class="btn">
                            <i class="fas fa-arrow-left"></i> Back to Modules
                        </a>
                    </div>
                </div>
            </div>

            <!-- Statistics Bar -->
            <div class="stats-bar">
                <div class="stat-item">
                    <div class="stat-number"><asp:Label ID="lblLessonCount" runat="server" Text="0"></asp:Label></div>
                    <div class="stat-label">Total Lessons</div>
                </div>
                <div class="stat-item">
                    <div class="stat-number"><asp:Label ID="lblTotalDuration" runat="server" Text="0 min"></asp:Label></div>
                    <div class="stat-label">Total Duration</div>
                </div>
                <div class="stat-item">
                    <div class="stat-number"><asp:Label ID="lblVideosCount" runat="server" Text="0"></asp:Label></div>
                    <div class="stat-label">Video Lessons</div>
                </div>
                <div class="stat-item">
                    <div class="stat-number"><asp:Label ID="lblTextsCount" runat="server" Text="0"></asp:Label></div>
                    <div class="stat-label">Text Lessons</div>
                </div>
            </div>

            <!-- Add Lesson Button -->
            <div style="margin-bottom: 2rem; text-align: right;">
                <button type="button" class="btn" onclick="openAddLessonModal()">
                    <i class="fas fa-plus"></i> Add New Lesson
                </button>
            </div>

            <!-- Lessons List -->
            <asp:Repeater ID="rptLessons" runat="server">
                <ItemTemplate>
                    <div class="lesson-card">
                        <div class="lesson-header">
                            <h3 class="lesson-title"><%# Eval("Title") %></h3>
                            <div class="lesson-id">ID: <%# Eval("LessonID") %></div>
                        </div>
                        <div class="lesson-content-type">
                            <i class="fas <%# GetContentTypeIcon(Eval("ContentType").ToString()) %>"></i>
                            <%# GetContentTypeLabel(Eval("ContentType").ToString()) %>
                        </div>
                        <div class="lesson-duration">
                            <i class="fas fa-clock"></i>
                            <span><%# Eval("Duration") %> minutes</span>
                        </div>
                        <div class="lesson-content">
                            <%# GetContentPreview(Eval("ContentType").ToString(), Eval("TextContent"), Eval("ContentURL")) %>
                        </div>
                        <div class="lesson-actions">
                            <asp:LinkButton runat="server" CssClass="btn-view" 
                                          CommandName="View" CommandArgument='<%# Eval("LessonID") %>' 
                                          OnClick="BtnViewLesson_Click">
                                <i class="fas fa-eye"></i> View
                            </asp:LinkButton>
                            <asp:LinkButton runat="server" CssClass="btn-edit" 
                                          CommandName="Edit" CommandArgument='<%# Eval("LessonID") %>' 
                                          OnClick="BtnEditLesson_Click">
                                <i class="fas fa-edit"></i> Edit
                            </asp:LinkButton>
                            <asp:LinkButton runat="server" CssClass="btn-delete" 
                                          CommandName="Delete" CommandArgument='<%# Eval("LessonID") %>' 
                                          OnClick="BtnDeleteLesson_Click"
                                          OnClientClick="return confirm('Are you sure you want to delete this lesson? This action cannot be undone.');">
                                <i class="fas fa-trash"></i> Delete
                            </asp:LinkButton>
                        </div>
                    </div>
                </ItemTemplate>
            </asp:Repeater>
            
            <asp:Panel ID="pnlNoLessons" runat="server" Visible="false">
                <div class="empty-state">
                    <i class="fas fa-book-open"></i>
                    <h3>No Lessons Found</h3>
                    <p>This module doesn't have any lessons yet.</p>
                    <button type="button" class="btn" onclick="openAddLessonModal()">
                        <i class="fas fa-plus"></i> Add First Lesson
                    </button>
                </div>
            </asp:Panel>
        </div>

        <!-- Add/Edit Lesson Modal -->
        <div id="lessonModal" class="modal">
            <div class="modal-content">
                <span class="close" onclick="closeLessonModal()">&times;</span>
                <h2 id="modalTitle">Add New Lesson</h2>
                
                <asp:HiddenField ID="hfLessonID" runat="server" />
                <asp:HiddenField ID="hfModuleID" runat="server" />
                
                <div class="form-group">
                    <label for="<%= txtLessonTitle.ClientID %>">Lesson Title *</label>
                    <asp:TextBox ID="txtLessonTitle" runat="server" placeholder="Enter lesson title" MaxLength="100" />
                </div>
                
                <div class="form-group">
                    <label for="<%= ddlContentType.ClientID %>">Content Type *</label>
                    <asp:DropDownList ID="ddlContentType" runat="server" CssClass="select" onchange="handleContentTypeChange()">
                        <asp:ListItem Text="Text" Value="Text" />
                        <asp:ListItem Text="Video" Value="Video" />
                        <asp:ListItem Text="PDF" Value="PDF" />
                        <asp:ListItem Text="External Link" Value="Link" />
                    </asp:DropDownList>
                </div>
                
                <div class="form-group">
                    <label for="<%= txtDuration.ClientID %>">Duration (minutes) *</label>
                    <asp:TextBox ID="txtDuration" runat="server" placeholder="Enter estimated duration in minutes" TextMode="Number" min="1" step="1" />
                </div>
                
                <div id="contentUrlContainer" class="form-group content-url-container">
                    <label for="<%= txtContentURL.ClientID %>">Content URL *</label>
                    <asp:TextBox ID="txtContentURL" runat="server" placeholder="Enter URL (YouTube, PDF link, etc.)" />
                    <small style="display: block; margin-top: 0.5rem; color: #666;">For YouTube videos, use the embed URL (https://www.youtube.com/embed/VIDEO_ID)</small>
                </div>
                
                <div id="textContentContainer" class="form-group text-content-container">
                    <label for="<%= txtTextContent.ClientID %>">Text Content *</label>
                    <asp:TextBox ID="txtTextContent" runat="server" TextMode="MultiLine" Rows="6" 
                               placeholder="Enter lesson content here. You can use basic HTML tags for formatting." />
                </div>
                
                <div class="preview-section">
                    <div class="preview-header">
                        <div class="preview-title">Content Preview</div>
                    </div>
                    <div id="contentPreview" class="preview-content">
                        <p class="text-center" style="color: #999;">Content preview will appear here</p>
                    </div>
                </div>
                
                <div style="margin-top: 2rem; text-align: right;">
                    <button type="button" onclick="closeLessonModal()" class="btn" style="background-color: #6c757d;">Cancel</button>
                    <asp:Button ID="btnSaveLesson" runat="server" Text="Save Lesson" CssClass="btn" OnClick="BtnSaveLesson_Click" style="background-color: var(--admin-primary);" />
                </div>
            </div>
        </div>

        <!-- View Lesson Modal -->
        <div id="viewLessonModal" class="modal">
            <div class="modal-content">
                <span class="close" onclick="closeViewLessonModal()">&times;</span>
                <div class="lesson-view-container">
                    <div class="lesson-view-header">
                        <h2 class="lesson-view-title"><asp:Label ID="lblViewTitle" runat="server" Text="Lesson Title"></asp:Label></h2>
                        <div class="lesson-view-meta">
                            <div class="lesson-view-meta-item">
                                <i class="fas fa-tag"></i>
                                <span><asp:Label ID="lblViewContentType" runat="server" Text="Content Type"></asp:Label></span>
                            </div>
                            <div class="lesson-view-meta-item">
                                <i class="fas fa-clock"></i>
                                <span><asp:Label ID="lblViewDuration" runat="server" Text="Duration"></asp:Label> minutes</span>
                            </div>
                        </div>
                    </div>
                    
                    <div class="lesson-view-content">
                        <asp:Panel ID="pnlVideoContent" runat="server" Visible="false">
                            <iframe id="videoFrame" runat="server" width="100%" height="400" frameborder="0" allowfullscreen></iframe>
                        </asp:Panel>
                        
                        <asp:Panel ID="pnlPdfContent" runat="server" Visible="false">
                            <div style="padding: 1rem; background: #f5f5f5; border-radius: 0.5rem; text-align: center;">
                                <a href="#" id="pdfLink" runat="server" target="_blank" class="btn">
                                    <i class="fas fa-file-pdf"></i> View PDF Document
                                </a>
                            </div>
                        </asp:Panel>
                        
                        <asp:Panel ID="pnlLinkContent" runat="server" Visible="false">
                            <div style="padding: 1rem; background: #f5f5f5; border-radius: 0.5rem; text-align: center;">
                                <a href="#" id="externalLink" runat="server" target="_blank" class="btn">
                                    <i class="fas fa-external-link-alt"></i> Open External Resource
                                </a>
                            </div>
                        </asp:Panel>
                        
                        <asp:Panel ID="pnlTextContent" runat="server" Visible="false">
                            <div class="lesson-view-text">
                                <asp:Literal ID="litTextContent" runat="server"></asp:Literal>
                            </div>
                        </asp:Panel>
                    </div>
                    
                    <div style="margin-top: 2rem; text-align: right;">
                        <button type="button" onclick="closeViewLessonModal()" class="btn">Close</button>
                    </div>
                </div>
            </div>
        </div>

        <!-- Message Display -->
        <asp:Label ID="lblMessage" runat="server" Visible="false" CssClass="message"></asp:Label>

        <footer class="footer">
            &copy; 2025 <span>Bulb</span> Admin Dashboard
        </footer>
    </form>

    <script>
        // Modal functionality
        function openAddLessonModal() {
            clearLessonForm();
            document.getElementById('modalTitle').textContent = 'Add New Lesson';
            document.getElementById('lessonModal').style.display = 'block';
            handleContentTypeChange(); // Initialize content type containers
        }

        function openEditLessonModal() {
            document.getElementById('modalTitle').textContent = 'Edit Lesson';
            document.getElementById('lessonModal').style.display = 'block';
            handleContentTypeChange(); // Show/hide based on selected content type
            updateContentPreview(); // Show current content in preview
        }

        function closeLessonModal() {
            document.getElementById('lessonModal').style.display = 'none';
        }
        
        function openViewLessonModal() {
            document.getElementById('viewLessonModal').style.display = 'block';
        }
        
        function closeViewLessonModal() {
            document.getElementById('viewLessonModal').style.display = 'none';
        }

        function handleContentTypeChange() {
            const contentType = document.getElementById('<%= ddlContentType.ClientID %>').value;
            const contentUrlContainer = document.getElementById('contentUrlContainer');
            const textContentContainer = document.getElementById('textContentContainer');
            
            // Reset visibility
            contentUrlContainer.style.display = 'none';
            textContentContainer.style.display = 'none';
            
            // Show relevant container based on content type
            if (contentType === 'Text') {
                textContentContainer.style.display = 'block';
            } else {
                contentUrlContainer.style.display = 'block';
            }
            
            // Update preview
            updateContentPreview();
        }
        
        function updateContentPreview() {
            const contentType = document.getElementById('<%= ddlContentType.ClientID %>').value;
            const contentUrl = document.getElementById('<%= txtContentURL.ClientID %>').value;
            const textContent = document.getElementById('<%= txtTextContent.ClientID %>').value;
            const previewContainer = document.getElementById('contentPreview');
            
            // Clear previous preview
            previewContainer.innerHTML = '';
            
            if (contentType === 'Video' && contentUrl) {
                if (contentUrl.includes('youtube.com/embed/')) {
                    previewContainer.innerHTML = `<iframe width="100%" height="200" src="${contentUrl}" frameborder="0" allowfullscreen></iframe>`;
                } else {
                    previewContainer.innerHTML = `<p>Preview not available. Please enter a valid YouTube embed URL.</p>`;
                }
            } else if (contentType === 'PDF' && contentUrl) {
                previewContainer.innerHTML = `
                    <div style="text-align: center; padding: 20px;">
                        <i class="fas fa-file-pdf" style="font-size: 40px; color: #e74c3c;"></i>
                        <p style="margin-top: 10px;">PDF Document</p>
                        <a href="${contentUrl}" target="_blank" class="btn" style="display: inline-block; margin-top: 10px;">Preview PDF</a>
                    </div>
                `;
            } else if (contentType === 'Link' && contentUrl) {
                previewContainer.innerHTML = `
                    <div style="text-align: center; padding: 20px;">
                        <i class="fas fa-external-link-alt" style="font-size: 40px; color: #3498db;"></i>
                        <p style="margin-top: 10px;">External Resource</p>
                        <a href="${contentUrl}" target="_blank" class="btn" style="display: inline-block; margin-top: 10px;">Visit Link</a>
                    </div>
                `;
            } else if (contentType === 'Text' && textContent) {
                previewContainer.innerHTML = textContent;
            } else {
                previewContainer.innerHTML = `<p class="text-center" style="color: #999;">Content preview will appear here</p>`;
            }
        }

        function clearLessonForm() {
            document.getElementById('<%= hfLessonID.ClientID %>').value = '';
            document.getElementById('<%= txtLessonTitle.ClientID %>').value = '';
            document.getElementById('<%= ddlContentType.ClientID %>').value = 'Text';
            document.getElementById('<%= txtDuration.ClientID %>').value = '';
            document.getElementById('<%= txtContentURL.ClientID %>').value = '';
            document.getElementById('<%= txtTextContent.ClientID %>').value = '';
            document.getElementById('contentPreview').innerHTML = '<p class="text-center" style="color: #999;">Content preview will appear here</p>';
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

        // Close modals when clicking outside
        window.onclick = function(event) {
            const lessonModal = document.getElementById('lessonModal');
            const viewLessonModal = document.getElementById('viewLessonModal');
            
            if (event.target === lessonModal) {
                closeLessonModal();
            }
            
            if (event.target === viewLessonModal) {
                closeViewLessonModal();
            }
        }

        // Set up event listeners for real-time preview
        document.addEventListener('DOMContentLoaded', function() {
            const contentTypeSelect = document.getElementById('<%= ddlContentType.ClientID %>');
            const contentUrlInput = document.getElementById('<%= txtContentURL.ClientID %>');
            const textContentInput = document.getElementById('<%= txtTextContent.ClientID %>');
            
            contentTypeSelect.addEventListener('change', handleContentTypeChange);
            contentUrlInput.addEventListener('input', updateContentPreview);
            textContentInput.addEventListener('input', updateContentPreview);
            
            // Initialize UI based on current content type
            handleContentTypeChange();
            
            // Check for any messages from server
            const messageEl = document.getElementById('<%= lblMessage.ClientID %>');
            if (messageEl && messageEl.innerText.trim()) {
                messageEl.style.display = 'block';
                setTimeout(() => {
                    messageEl.style.display = 'none';
                }, 5000);
            }
        });

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
    </script>
</body>
</html>