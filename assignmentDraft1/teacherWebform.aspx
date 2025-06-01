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
        /* Enhanced UI Styles */
        .welcome-section {
            background: var(--white);
            border-radius: 0.8rem;
            padding: 2rem;
            margin-bottom: 2rem;
            box-shadow: 0 0.5rem 1rem rgba(0, 0, 0, 0.1);
            position: relative;
            overflow: hidden;
        }

        .welcome-title {
            font-size: 2.5rem;
            margin-bottom: 1rem;
            display: flex;
            align-items: center;
            gap: 1rem;
        }

        .welcome-title i {
            color: var(--main-color);
            font-size: 3rem;
        }

        .welcome-subtitle {
            font-size: 1.8rem;
            color: var(--light-color);
            margin-bottom: 1rem;
        }

        .current-time {
            font-size: 1.5rem;
            color: var(--light-color);
        }

        .dashboard-stats {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(240px, 1fr));
            gap: 2rem;
            margin-bottom: 3rem;
        }

        .stat-card {
            background: var(--white);
            border-radius: 0.8rem;
            padding: 2rem;
            box-shadow: 0 0.5rem 1rem rgba(0, 0, 0, 0.1);
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
        }

        .stat-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 1rem 2rem rgba(0, 0, 0, 0.15);
        }

        .stat-header {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            margin-bottom: 1.5rem;
        }

        .stat-number {
            font-size: 3rem;
            font-weight: bold;
            margin-bottom: 0.5rem;
            color: var(--black);
        }

        .stat-label {
            font-size: 1.6rem;
            color: var(--light-color);
        }

        .stat-icon {
            background: var(--light-bg);
            width: 5rem;
            height: 5rem;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 2.2rem;
            color: var(--main-color);
        }

        .stat-card:nth-child(1) .stat-icon {
            background: rgba(139, 69, 19, 0.1);
            color: var(--main-color);
        }

        .stat-card:nth-child(2) .stat-icon {
            background: rgba(0, 128, 0, 0.1);
            color: green;
        }

        .stat-card:nth-child(3) .stat-icon {
            background: rgba(0, 0, 255, 0.1);
            color: blue;
        }

        .stat-card:nth-child(4) .stat-icon {
            background: rgba(255, 165, 0, 0.1);
            color: orange;
        }

        .progress-bar {
            width: 100%;
            height: 0.8rem;
            background: var(--light-bg);
            border-radius: 1rem;
            overflow: hidden;
            margin-top: 1rem;
        }

        .progress-fill {
            height: 100%;
            background: var(--main-color);
            border-radius: 1rem;
            transition: width 1s ease-in-out;
        }

        /* Course management styles */
        .course-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
            gap: 2rem;
            margin-top: 2rem;
        }

        .course-card {
            background: var(--white);
            border-radius: 0.8rem;
            overflow: hidden;
            box-shadow: 0 0.5rem 1rem rgba(0, 0, 0, 0.1);
            transition: all 0.3s ease;
            animation: fadeIn 0.5s ease-out forwards;
            opacity: 0;
        }

        .course-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 1rem 2rem rgba(0, 0, 0, 0.15);
        }

        .course-header {
            padding: 2rem;
            border-bottom: 1px solid var(--light-bg);
            position: relative;
        }

        .course-title {
            font-size: 1.8rem;
            margin-bottom: 1rem;
            color: var(--black);
        }

        .course-category {
            display: inline-block;
            padding: 0.5rem 1rem;
            background: var(--light-bg);
            color: var(--black);
            border-radius: 2rem;
            font-size: 1.2rem;
            margin-bottom: 1rem;
        }

        .course-lecturer {
            display: flex;
            align-items: center;
            gap: 0.5rem;
            font-size: 1.4rem;
            color: var(--light-color);
        }

        .course-body {
            padding: 2rem;
        }

        .course-description {
            font-size: 1.4rem;
            color: var(--light-color);
            margin-bottom: 1.5rem;
            display: -webkit-box;
            -webkit-line-clamp: 3;
            -webkit-box-orient: vertical;
            overflow: hidden;
            text-overflow: ellipsis;
        }

        .course-meta {
            display: flex;
            justify-content: space-between;
            margin-bottom: 1.5rem;
            font-size: 1.4rem;
        }

        .meta-item {
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .meta-icon {
            color: var(--main-color);
        }

        .course-actions {
            display: flex;
            gap: 1rem;
            flex-wrap: wrap;
        }

        /* Assignment section styles */
        .assignment-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
            gap: 2rem;
            margin-top: 2rem;
        }

        .assignment-card {
            background: var(--white);
            border-radius: 0.8rem;
            overflow: hidden;
            box-shadow: 0 0.5rem 1rem rgba(0, 0, 0, 0.1);
            transition: all 0.3s ease;
            animation: slideIn 0.5s ease-out forwards;
            opacity: 0;
        }

        .assignment-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 1rem 2rem rgba(0, 0, 0, 0.15);
        }

        .assignment-header {
            padding: 2rem;
            border-bottom: 1px solid var(--light-bg);
        }

        .assignment-title {
            font-size: 1.8rem;
            margin-bottom: 0.5rem;
            color: var(--black);
        }

        .assignment-course {
            font-size: 1.4rem;
            color: var(--light-color);
        }

        .assignment-body {
            padding: 2rem;
        }

        .assignment-meta {
            display: flex;
            flex-direction: column;
            gap: 1rem;
            margin-bottom: 1.5rem;
        }

        .meta-item {
            display: flex;
            align-items: center;
            gap: 0.8rem;
            font-size: 1.4rem;
        }

        .progress-text {
            font-size: 1.4rem;
            color: var(--light-color);
            margin-top: 0.5rem;
            text-align: right;
        }

        .status-badge {
            display: inline-flex;
            align-items: center;
            padding: 0.5rem 1rem;
            border-radius: 2rem;
            font-size: 1.3rem;
            margin-bottom: 1.5rem;
            gap: 0.5rem;
        }

        .status-open {
            background-color: rgba(0, 128, 0, 0.1);
            color: green;
        }

        .status-overdue {
            background-color: rgba(255, 0, 0, 0.1);
            color: red;
        }

        .status-pending {
            background-color: rgba(255, 165, 0, 0.1);
            color: orange;
        }

        .status-closed {
            background-color: rgba(128, 128, 128, 0.1);
            color: gray;
        }

        /* Modal enhanced styles */
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
            animation: fadeIn 0.3s ease-out;
        }
        
        .modal-content {
            background-color: var(--white);
            margin: 3% auto;
            padding: 3rem;
            width: 60%;
            border-radius: 1rem;
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
            position: absolute;
            right: 2rem;
            top: 2rem;
            color: var(--light-color);
            font-size: 2.8rem;
            font-weight: bold;
            cursor: pointer;
            transition: color 0.3s;
            z-index: 10;
            width: 4rem;
            height: 4rem;
            display: flex;
            align-items: center;
            justify-content: center;
            border-radius: 50%;
        }
        
        .close:hover {
            color: var(--black);
            background-color: var(--light-bg);
        }

        /* Form styling */
        .form-group {
            margin: 2rem 0;
        }

        .form-group label {
            display: block;
            margin-bottom: 0.8rem;
            font-weight: bold;
            color: var(--black);
            font-size: 1.6rem;
        }

        .form-group input, .form-group textarea, .form-group select {
            width: 100%;
            padding: 1.2rem;
            border: 1px solid #ddd;
            border-radius: 0.8rem;
            font-size: 1.5rem;
            transition: all 0.3s;
            background-color: var(--white);
        }

        .form-group input:focus, .form-group textarea:focus, .form-group select:focus {
            outline: none;
            border-color: var(--main-color);
            box-shadow: 0 0 0 3px rgba(139, 69, 19, 0.1);
        }

        /* Messages */
        .message {
            display: block;
            padding: 1.5rem 2.5rem;
            margin: 1rem 0;
            border-radius: 0.8rem;
            font-size: 1.6rem;
            text-align: center;
            position: fixed;
            top: 20px;
            right: 20px;
            z-index: 2000;
            min-width: 300px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.2);
            animation: slideInRight 0.5s ease-out forwards;
            transform: translateX(100%);
        }
        
        @keyframes slideInRight {
            to {
                transform: translateX(0);
            }
        }
        
        .message.success {
            background-color: #d4edda;
            color: #155724;
            border-left: 5px solid #28a745;
        }
        
        .message.error {
            background-color: #f8d7da;
            color: #721c24;
            border-left: 5px solid #dc3545;
        }

        /* Confirmation dialog */
        .confirmation-dialog {
            position: fixed;
            z-index: 2000;
            left: 50%;
            top: 50%;
            transform: translate(-50%, -50%) scale(0.9);
            background-color: white;
            padding: 3rem;
            border-radius: 1rem;
            box-shadow: 0 8px 32px rgba(0,0,0,0.3);
            min-width: 400px;
            text-align: center;
            display: none;
            animation: scaleIn 0.3s ease-out forwards;
        }
        
        @keyframes scaleIn {
            to {
                transform: translate(-50%, -50%) scale(1);
            }
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
            animation: fadeIn 0.3s ease-out;
        }
        
        @keyframes fadeIn {
            from {
                opacity: 0;
            }
            to {
                opacity: 1;
            }
        }
        
        .confirmation-buttons {
            margin-top: 2.5rem;
            display: flex;
            justify-content: center;
            gap: 1.5rem;
        }

        /* Button styling */
        .btn-confirm, .btn-cancel, .btn-primary {
            padding: 1rem 2.5rem;
            border: none;
            border-radius: 0.8rem;
            cursor: pointer;
            font-size: 1.5rem;
            transition: all 0.3s;
            font-weight: 500;
        }
        
        .btn-confirm {
            background-color: var(--red);
            color: white;
        }
        
        .btn-cancel {
            background-color: var(--light-bg);
            color: var(--black);
        }
        
        .btn-primary {
            background-color: var(--main-color);
            color: white;
        }
        
        .btn-confirm:hover, .btn-primary:hover {
            transform: translateY(-3px);
            box-shadow: 0 5px 15px rgba(0,0,0,0.2);
        }
        
        .btn-cancel:hover {
            background-color: #e5e7eb;
            transform: translateY(-3px);
        }

        /* Animation classes */
        .fade-in {
            animation: fadeIn 0.5s ease-out forwards;
            opacity: 0;
        }
        
        .slide-in {
            animation: slideIn 0.5s ease-out forwards;
            opacity: 0;
        }
        
        @keyframes slideIn {
            from {
                opacity: 0;
                transform: translateY(20px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        /* Empty state styling */
        .empty-state {
            text-align: center;
            padding: 4rem 2rem;
            background-color: var(--white);
            border-radius: 0.8rem;
            box-shadow: 0 0.5rem 1rem rgba(0, 0, 0, 0.1);
        }
        
        .empty-icon {
            font-size: 5rem;
            color: var(--light-color);
            margin-bottom: 2rem;
        }
        
        .empty-title {
            font-size: 2rem;
            margin-bottom: 1rem;
            color: var(--black);
        }
        
        .empty-text {
            font-size: 1.6rem;
            color: var(--light-color);
            margin-bottom: 2rem;
        }

        /* Quick action buttons */
        .quick-actions {
            position: fixed;
            right: 3rem;
            bottom: 3rem;
            display: flex;
            flex-direction: column;
            gap: 1.5rem;
            z-index: 100;
        }
        
        .quick-action-btn {
            width: 6rem;
            height: 6rem;
            border-radius: 50%;
            background-color: var(--main-color);
            color: white;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 2.2rem;
            box-shadow: 0 0.5rem 1.5rem rgba(0, 0, 0, 0.2);
            transition: all 0.3s;
            cursor: pointer;
        }
        
        .quick-action-btn:hover {
            transform: translateY(-5px) scale(1.05);
            box-shadow: 0 1rem 2.5rem rgba(0, 0, 0, 0.25);
        }
        
        .quick-action-btn.primary {
            background-color: var(--main-color);
        }
        
        .quick-action-btn.secondary {
            background-color: #6c757d;
        }

        /* Timeline filters */
        .timeline-filters {
            background-color: var(--white);
            border-radius: 0.8rem;
            padding: 2rem;
            margin-bottom: 2rem;
            box-shadow: 0 0.5rem 1rem rgba(0, 0, 0, 0.1);
        }
        
        .filter-row {
            display: flex;
            flex-wrap: wrap;
            gap: 2rem;
            align-items: center;
        }
        
        .filter-group {
            flex: 1;
            min-width: 200px;
        }
        
        .filter-label {
            display: block;
            margin-bottom: 0.8rem;
            font-weight: 500;
            font-size: 1.4rem;
            color: var(--black);
        }
        
        .quick-filters {
            display: flex;
            flex-wrap: wrap;
            gap: 0.8rem;
        }
        
        .quick-filter {
            padding: 0.6rem 1.2rem;
            border-radius: 2rem;
            background-color: var(--light-bg);
            color: var(--black);
            font-size: 1.3rem;
            cursor: pointer;
            transition: all 0.3s;
        }
        
        .quick-filter:hover {
            background-color: var(--light-color);
            color: var(--white);
        }
        
        .quick-filter.active {
            background-color: var(--main-color);
            color: var(--white);
        }
        
        .select {
            appearance: none;
            background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='24' height='24' viewBox='0 0 24 24' fill='none' stroke='currentColor' stroke-width='2' stroke-linecap='round' stroke-linejoin='round'%3E%3Cpolyline points='6 9 12 15 18 9'%3E%3C/polyline%3E%3C/svg%3E");
            background-repeat: no-repeat;
            background-position: right 1rem center;
            background-size: 1.5rem;
            padding-right: 3.5rem;
        }
        
        .search-input {
            width: 100%;
            padding: 1rem 1.5rem;
            border: 1px solid #ddd;
            border-radius: 2rem;
            font-size: 1.4rem;
            transition: all 0.3s;
        }
        
        .search-input:focus {
            outline: none;
            border-color: var(--main-color);
            box-shadow: 0 0 0 3px rgba(139, 69, 19, 0.1);
        }

        /* Responsive adjustments */
        @media (max-width: 1024px) {
            .dashboard-stats {
                grid-template-columns: repeat(2, 1fr);
            }
            
            .course-grid, .assignment-grid {
                grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
            }
        }
        
        @media (max-width: 768px) {
            .dashboard-stats {
                grid-template-columns: 1fr;
            }
            
            .filter-row {
                flex-direction: column;
                align-items: stretch;
                gap: 1.5rem;
            }
            
            .filter-group {
                width: 100%;
            }
            
            .modal-content {
                width: 90%;
                padding: 2rem;
            }
            
            .confirmation-dialog {
                width: 90%;
                min-width: unset;
            }
        }
        
        /* Dark mode specific adjustments */
        .dark .stat-card, 
        .dark .course-card, 
        .dark .assignment-card,
        .dark .welcome-section,
        .dark .timeline-filters,
        .dark .empty-state {
            background-color: var(--black);
            box-shadow: 0 0.5rem 1rem rgba(0, 0, 0, 0.2);
        }
        
        .dark .stat-icon {
            background-color: var(--light-bg);
        }
        
        .dark .stat-card:nth-child(1) .stat-icon {
            background: rgba(139, 69, 19, 0.2);
        }
        
        .dark .stat-card:nth-child(2) .stat-icon {
            background: rgba(0, 128, 0, 0.2);
        }
        
        .dark .stat-card:nth-child(3) .stat-icon {
            background: rgba(0, 0, 255, 0.2);
        }
        
        .dark .stat-card:nth-child(4) .stat-icon {
            background: rgba(255, 165, 0, 0.2);
        }
        
        .dark .course-header, .dark .assignment-header {
            border-bottom: 1px solid var(--border);
        }
        
        .dark .modal-content {
            background-color: var(--black);
        }
        
        .dark .confirmation-dialog {
            background-color: var(--black);
            color: var(--white);
        }
        
        .dark .btn-cancel {
            background-color: var(--border);
            color: var(--white);
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
                <a href="ViewStudent.aspx"><i class="fas fa-users"></i><span>Students</span></a>
                <a href="analytics.aspx"><i class="fas fa-chart-line"></i><span>Analytics</span></a>
                <a href="TeacherSettings.aspx"><i class="fas fa-cog"></i><span>Settings</span></a>
                <a href="loginWebform.aspx"><i class="fas fa-sign-out-alt"></i><span>Logout</span></a>
            </nav>
        </div>

        <!-- Main Content -->
        <section class="home-grid">
            <!-- Welcome Section -->
            <div class="welcome-section fade-in">
                <h1 class="welcome-title">
                    <i class="fas fa-sun"></i> Good <span id="timeOfDay">Morning</span>, <asp:Label ID="lblWelcomeName" runat="server" Text="Professor"></asp:Label>!
                </h1>
                <p class="welcome-subtitle">Ready to empower your students today?</p>
                <div class="current-time" id="currentDateTime"></div>
            </div>

            <!-- Dashboard Statistics -->
            <div class="dashboard-stats">
                <div class="stat-card fade-in">
                    <div class="stat-header">
                        <div>
                            <div class="stat-number"><asp:Label runat="server" ID="lblActiveCourses" Text="0" /></div>
                            <div class="stat-label">Active Courses</div>
                        </div>
                        <div class="stat-icon">
                            <i class="fas fa-book"></i>
                        </div>
                    </div>
                </div>

                <div class="stat-card fade-in">
                    <div class="stat-header">
                        <div>
                            <div class="stat-number"><asp:Label runat="server" ID="lblTotalStudents" Text="0" /></div>
                            <div class="stat-label">Total Students</div>
                        </div>
                        <div class="stat-icon">
                            <i class="fas fa-users"></i>
                        </div>
                    </div>
                </div>

                <div class="stat-card fade-in">
                    <div class="stat-header">
                        <div>
                            <div class="stat-number"><asp:Label runat="server" ID="lblActiveAssignments" Text="0" /></div>
                            <div class="stat-label">Active Assignments</div>
                        </div>
                        <div class="stat-icon">
                            <i class="fas fa-tasks"></i>
                        </div>
                    </div>
                </div>

                <div class="stat-card fade-in">
                    <div class="stat-header">
                        <div>
                            <div class="stat-number"><asp:Label runat="server" ID="lblCompletionRate" Text="0%" /></div>
                            <div class="stat-label">Completion Rate</div>
                        </div>
                        <div class="stat-icon">
                            <i class="fas fa-check-circle"></i>
                        </div>
                    </div>
                    <div class="progress-bar">
                        <div class="progress-fill" id="completionRateBar" style="width: 0%"></div>
                    </div>
                </div>
            </div>
        </section>

        <!-- Course Management -->
        <section class="courses">
            <div class="section-header" style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 2rem;">
                <h1 class="heading"><i class="fas fa-graduation-cap"></i> My Courses</h1>
            </div>
            
            <!-- Course filtering -->
            <div class="timeline-filters fade-in">
                <div class="filter-row">
                    <div class="filter-group">
                        <label class="filter-label">Filter by Category:</label>
                        <div class="quick-filters" id="categoryFilters">
                            <div class="quick-filter active" data-category="all">All</div>
                            <!-- Categories will be populated dynamically -->
                        </div>
                    </div>
                    
                    <div class="filter-group">
                        <label class="filter-label">Sort by:</label>
                        <select class="select" id="courseSortSelect">
                            <option value="name">Course Name</option>
                            <option value="category">Category</option>
                            <option value="modules">Number of Modules</option>
                        </select>
                    </div>
                    
                    <div class="filter-group">
                        <label class="filter-label">Search:</label>
                        <input type="text" class="search-input" id="courseSearch" placeholder="Search courses..." />
                    </div>
                </div>
            </div>
            
            <!-- Course Grid -->
            <div class="course-grid" id="courseGrid">
                <asp:Repeater runat="server" ID="courseRepeater">
                    <ItemTemplate>
                        <div class="course-card fade-in" 
                             data-course-id='<%# Eval("CourseID") %>'
                             data-course-name='<%# Eval("CourseName") %>'
                             data-category='<%# Eval("Category") %>'
                             data-modules='<%# Eval("ModuleCount") %>'>
                            <div class="course-header">
                                <h3 class="course-title"><%# Eval("CourseName") %></h3>
                                <div class="course-category"><%# Eval("Category") %></div>
                                <div class="course-lecturer">
                                    <i class="fas fa-user"></i>
                                    <span>You're the instructor</span>
                                </div>
                            </div>
                            <div class="course-body">
                                <div class="course-description"><%# Eval("Description") %></div>
                                <div class="course-meta">
                                    <div class="meta-item">
                                        <i class="fas fa-th-list meta-icon"></i>
                                        <span><%# Eval("ModuleCount") %> modules</span>
                                    </div>
                                </div>
                                <div class="progress-bar">
                                    <div class="progress-fill course-progress" style="width: 0%"></div>
                                </div>
                                <div class="progress-text course-progress-text">0% complete</div>
                                <div class="course-actions">
                                    <asp:LinkButton runat="server" ID="btnManageModules" CssClass="inline-btn" 
                                        CommandName="ManageModules" CommandArgument='<%# Eval("CourseID") %>' 
                                        OnClick="BtnManageModules_Click">
                                        <i class="fas fa-th-list"></i> Manage Modules
                                    </asp:LinkButton>
                                    <asp:LinkButton runat="server" CssClass="inline-delete-btn" 
                                        CommandName="Delete" CommandArgument='<%# Eval("CourseID") %>' 
                                        OnClick="BtnDeleteCourse_Click"
                                        OnClientClick='<%# "return confirmDeleteCourse(" + Eval("CourseID") + ", \"" + Eval("CourseName") + "\", " + Eval("ModuleCount") + ");" %>'>
                                        <i class="fas fa-trash"></i> Delete
                                    </asp:LinkButton>
                                    <a href='<%# "EditModules.aspx?courseId=" + Eval("CourseID") %>' class="inline-option-btn">
                                        <i class="fas fa-edit"></i> Edit
                                    </a>
                                </div>
                            </div>
                        </div>
                    </ItemTemplate>
                </asp:Repeater>
                
                <asp:Panel ID="pnlNoCourses" runat="server" Visible="false">
                    <div class="empty-state">
                        <div class="empty-icon">
                            <i class="fas fa-graduation-cap"></i>
                        </div>
                        <h3 class="empty-title">No Courses Found</h3>
                        <p class="empty-text">Get started by creating your first course!</p>
                        <button type="button" class="inline-btn" onclick="openAddCourseModal()">
                            <i class="fas fa-plus"></i> Create Course
                        </button>
                    </div>
                </asp:Panel>
            </div>
        </section>

        <!-- Recent Assignments Section -->
        <section class="courses">
            <div class="section-header" style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 2rem;">
                <h1 class="heading"><i class="fas fa-tasks"></i> Recent Assignments</h1>
                <a href="assignments.aspx" class="inline-btn">
                    <i class="fas fa-plus"></i> Manage All Assignments
                </a>
            </div>
            
            <div class="assignment-grid">
                <asp:Repeater ID="assignmentRepeater" runat="server">
                    <ItemTemplate>
                        <div class="assignment-card slide-in" 
                             data-assignment-id='<%# Eval("AssignmentID") %>'
                             data-due-date='<%# Eval("DueDate", "{0:yyyy-MM-dd}") %>'
                             data-submissions='<%# Eval("TotalSubmissions") %>'
                             data-total='<%# Eval("MaxStudents") %>'>
                            <div class="assignment-header">
                                <h3 class="assignment-title"><%# Eval("Title") %></h3>
                                <div class="assignment-course"><%# Eval("CourseName") %></div>
                            </div>
                            <div class="assignment-body">
                                <div class="status-badge">
                                    <i class="fas fa-clock"></i>
                                    Pending
                                </div>
                                
                                <div class="assignment-meta">
                                    <div class="meta-item">
                                        <i class="fas fa-calendar meta-icon"></i>
                                        <span>Due: <%# Eval("DueDate", "{0:MMM dd, yyyy}") %></span>
                                    </div>
                                    <div class="meta-item">
                                        <i class="fas fa-users meta-icon"></i>
                                        <span><%# Eval("TotalSubmissions") %>/<%# Eval("MaxStudents") %> submissions</span>
                                    </div>
                                    <div class="meta-item">
                                        <i class="fas fa-clock meta-icon"></i>
                                        <span class="time-remaining" data-date='<%# Eval("DueDate", "{0:yyyy-MM-dd}") %>'>Loading...</span>
                                    </div>
                                </div>
                                
                                <div class="progress-bar">
                                    <div class="progress-fill assignment-progress" style="width: 0%"></div>
                                </div>
                                <div class="progress-text assignment-progress-text">0% submitted</div>
                                
                                <a href='TeacherGradeAssignment.aspx?assignmentID=<%# Eval("AssignmentID") %>' class="inline-btn">
                                    <i class="fas fa-check-circle"></i> Grade Submissions
                                  </a>
                            </div>
                        </div>
                    </ItemTemplate>
                </asp:Repeater>
                
                <asp:Panel ID="pnlNoAssignments" runat="server" Visible="false">
                    <div class="empty-state">
                        <div class="empty-icon">
                            <i class="fas fa-tasks"></i>
                        </div>
                        <h3 class="empty-title">No Recent Assignments</h3>
                        <p class="empty-text">Create assignments for your students to complete.</p>
                        <a href="assignments.aspx" class="inline-btn">
                            <i class="fas fa-plus"></i> Create Assignment
                        </a>
                    </div>
                </asp:Panel>
            </div>
        </section>

        <!-- Add/Edit Course Modal -->
        <div id="courseModal" class="modal">
            <div class="modal-content">
                <span class="close" onclick="closeCourseModal()">&times;</span>
                <h2 id="modalTitle" style="font-size: 2.4rem; margin-bottom: 2.5rem;">Add New Course</h2>
                
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
                
                <div style="margin-top: 3rem; text-align: right; display: flex; justify-content: flex-end; gap: 1.5rem;">
                    <button type="button" onclick="closeCourseModal()" class="btn-cancel">Cancel</button>
                    <asp:Button ID="BtnSaveCourse" runat="server" Text="Save Course" CssClass="btn-primary" OnClick="BtnSaveCourse_Click" />
                </div>
            </div>
        </div>

        <!-- Confirmation Dialog -->
        <div id="confirmationOverlay" class="confirmation-overlay"></div>
        <div id="confirmationDialog" class="confirmation-dialog">
            <h3 id="confirmationTitle" style="font-size: 2.2rem; margin-bottom: 1.5rem;">Confirm Action</h3>
            <p id="confirmationMessage" style="font-size: 1.6rem; line-height: 1.6;">Are you sure you want to proceed?</p>
            <div class="confirmation-buttons">
                <button type="button" class="btn-cancel" onclick="hideConfirmation()">Cancel</button>
                <button type="button" class="btn-confirm" id="confirmButton">Confirm</button>
            </div>
        </div>

        <!-- Message Display -->
        <asp:Label ID="lblMessage" runat="server" Visible="false" CssClass="message"></asp:Label>

        <!-- Quick Actions -->
        <div class="quick-actions">
            <button type="button" class="quick-action-btn primary" title="Add New Course" onclick="openAddCourseModal()">
                <i class="fas fa-plus"></i>
            </button>
            <a href="assignments.aspx" class="quick-action-btn secondary" title="Manage Assignments">
                <i class="fas fa-tasks"></i>
            </a>
            <a href="manageStudents.aspx" class="quick-action-btn secondary" title="Manage Students">
                <i class="fas fa-users"></i>
            </a>
        </div>

        <footer class="footer">
            &copy; 2025 <span>Bulb</span> Learning Management System
        </footer>
    </form>

    <script>
        // Global variables
        let confirmationCallback = null;
        let allCourseCards = [];
        let currentCategoryFilter = 'all';
        let currentCourseSort = 'name';
        let currentCourseSearch = '';
        let categories = new Set();

        // Initialize when DOM is ready
        document.addEventListener('DOMContentLoaded', function() {
            console.log('TeacherWebform page loaded successfully');
            
            // Set welcome message based on time of day
            setWelcomeMessage();
            
            // Update date and time
            updateDateTime();
            
            // Initialize dashboard
            initializeDashboard();
            
            // Set up timers for refreshing data
            setUpRefreshTimers();
        });

        // Initialize dashboard elements
        function initializeDashboard() {
            // Initialize course filtering
            setTimeout(initializeCourseFiltering, 300);
            
            // Initialize animations with slight delays for smooth loading
            setTimeout(initializeAnimations, 100);
            
            // Initialize sidebar and menu functionality
            initializeSidebar();
            
            // Initialize various UI components
            initializeMessageSystem();
            initializeProgressBars();
            initializeTimeRemaining();
            updateAssignmentStatus();
            
            // Set up keyboard shortcuts
            setupKeyboardShortcuts();
        }

        // Set up timers for refreshing data
        function setUpRefreshTimers() {
            // Update date and time every minute
            setInterval(updateDateTime, 60000);
            
            // Update time remaining indicators every minute
            setInterval(initializeTimeRemaining, 60000);
        }

        // Set appropriate welcome message based on time of day
        function setWelcomeMessage() {
            const hour = new Date().getHours();
            const timeOfDayElement = document.getElementById('timeOfDay');
            
            if (timeOfDayElement) {
                if (hour < 12) {
                    timeOfDayElement.textContent = 'Morning';
                } else if (hour < 17) {
                    timeOfDayElement.textContent = 'Afternoon';
                } else {
                    timeOfDayElement.textContent = 'Evening';
                }
            }
        }

        // Update date and time display
        function updateDateTime() {
            const now = new Date();
            const options = {
                weekday: 'long',
                year: 'numeric',
                month: 'long',
                day: 'numeric',
                hour: '2-digit',
                minute: '2-digit'
            };

            const currentDateTime = document.getElementById('currentDateTime');
            if (currentDateTime) {
                currentDateTime.textContent = now.toLocaleDateString('en-US', options);
            }
        }

        // Initialize progress bars
        function initializeProgressBars() {
            // Update completion rate bar
            const completionRateBar = document.getElementById('completionRateBar');
            const completionRateText = document.querySelector('#lblCompletionRate').textContent;
            const completionRateValue = parseInt(completionRateText) || 0;
            
            if (completionRateBar) {
                completionRateBar.style.width = completionRateValue + '%';
            }
            
            // Update course progress bars
            document.querySelectorAll('.course-progress').forEach(progressBar => {
                const randomProgress = Math.floor(Math.random() * (95 - 25 + 1)) + 25;
                progressBar.style.width = randomProgress + '%';
                
                // Update the corresponding text element
                const textElement = progressBar.closest('.course-body').querySelector('.course-progress-text');
                if (textElement) {
                    textElement.textContent = randomProgress + '% complete';
                }
            });
            
            // Update assignment progress bars
            document.querySelectorAll('.assignment-card').forEach(card => {
                const submissions = parseInt(card.getAttribute('data-submissions') || '0');
                const total = parseInt(card.getAttribute('data-total') || '1');
                const percentage = total > 0 ? Math.round((submissions / total) * 100) : 0;
                
                const progressBar = card.querySelector('.assignment-progress');
                const progressText = card.querySelector('.assignment-progress-text');
                
                if (progressBar) {
                    progressBar.style.width = percentage + '%';
                }
                
                if (progressText) {
                    progressText.textContent = percentage + '% submitted';
                }
            });
        }

        // Initialize time remaining indicators
        function initializeTimeRemaining() {
            document.querySelectorAll('.time-remaining').forEach(element => {
                if (element.hasAttribute('data-date')) {
                    const dueDate = new Date(element.getAttribute('data-date'));
                    const now = new Date();
                    const diffTime = dueDate - now;
                    const diffDays = Math.ceil(diffTime / (1000 * 60 * 60 * 24));
                    
                    let timeText = '';
                    if (diffDays < 0) {
                        timeText = `${Math.abs(diffDays)} day(s) overdue`;
                    } else if (diffDays === 0) {
                        timeText = 'Due today';
                    } else if (diffDays === 1) {
                        timeText = 'Due tomorrow';
                    } else {
                        timeText = `Due in ${diffDays} days`;
                    }
                    
                    element.textContent = timeText;
                }
            });
        }

        // Update assignment status badges
        function updateAssignmentStatus() {
            document.querySelectorAll('.assignment-card').forEach(card => {
                const submissions = parseInt(card.getAttribute('data-submissions') || '0');
                const total = parseInt(card.getAttribute('data-total') || '1');
                const percentage = total > 0 ? Math.round((submissions / total) * 100) : 0;
                const dueDate = new Date(card.getAttribute('data-due-date'));
                const now = new Date();
                
                const statusBadge = card.querySelector('.status-badge');
                if (!statusBadge) return;
                
                // Remove existing status classes
                statusBadge.classList.remove('status-open', 'status-pending', 'status-overdue', 'status-closed');
                
                let statusClass = 'status-pending';
                let statusIcon = 'fa-clock';
                let statusText = 'Pending';
                
                // Determine status based on submissions and due date
                if (dueDate < now && submissions < total) {
                    statusClass = 'status-overdue';
                    statusIcon = 'fa-exclamation-circle';
                    statusText = 'Overdue';
                } else if (submissions === 0) {
                    statusClass = 'status-pending';
                    statusIcon = 'fa-clock';
                    statusText = 'Pending';
                } else if (submissions === total) {
                    statusClass = 'status-open';
                    statusIcon = 'fa-check-circle';
                    statusText = 'All Submitted';
                } else {
                    statusClass = 'status-open';
                    statusIcon = 'fa-hourglass-half';
                    statusText = 'In Progress';
                }
                
                // Apply the appropriate class
                statusBadge.classList.add(statusClass);
                
                // Update icon and text
                const iconElement = statusBadge.querySelector('i');
                if (iconElement) {
                    iconElement.className = 'fas ' + statusIcon;
                }
                
                // Update text content (preserve the icon)
                const iconHtml = statusBadge.innerHTML.split('</i>')[0] + '</i>';
                statusBadge.innerHTML = iconHtml + ' ' + statusText;
            });
        }

        // Initialize course filtering system
        function initializeCourseFiltering() {
            // Get all course cards
            allCourseCards = Array.from(document.querySelectorAll('.course-card'));
            console.log('Found', allCourseCards.length, 'course cards');
            
            if (allCourseCards.length === 0) return;
            
            // Extract categories for filtering
            extractCategories();
            
            // Setup category filters
            setupCategoryFilters();
            
            // Setup sort dropdown
            setupCourseSortDropdown();
            
            // Setup search input
            setupCourseSearchInput();
        }

        // Extract unique categories from course cards
        function extractCategories() {
            categories.clear();
            categories.add('all');
            
            allCourseCards.forEach(card => {
                if (card.hasAttribute('data-category')) {
                    const category = card.getAttribute('data-category').toLowerCase();
                    if (category) {
                        categories.add(category);
                    }
                }
            });
            
            // Populate category filters
            const categoryFiltersContainer = document.getElementById('categoryFilters');
            if (categoryFiltersContainer) {
                // Clear existing filters except "All"
                const allFilter = categoryFiltersContainer.querySelector('[data-category="all"]');
                if (allFilter) {
                    categoryFiltersContainer.innerHTML = '';
                    categoryFiltersContainer.appendChild(allFilter);
                    
                    // Add category filters
                    categories.forEach(category => {
                        if (category !== 'all') {
                            const filterElement = document.createElement('div');
                            filterElement.className = 'quick-filter';
                            filterElement.setAttribute('data-category', category);
                            filterElement.textContent = category.charAt(0).toUpperCase() + category.slice(1);
                            filterElement.addEventListener('click', function() {
                                setActiveCategoryFilter(this);
                            });
                            categoryFiltersContainer.appendChild(filterElement);
                        }
                    });
                }
            }
        }

        // Set active category filter
        function setActiveCategoryFilter(filterElement) {
            const filters = document.querySelectorAll('#categoryFilters .quick-filter');
            filters.forEach(filter => filter.classList.remove('active'));
            filterElement.classList.add('active');
            
            currentCategoryFilter = filterElement.getAttribute('data-category');
            applyAllCourseFilters();
        }

        // Setup category filter buttons
        function setupCategoryFilters() {
            const filterButtons = document.querySelectorAll('#categoryFilters .quick-filter');
            
            filterButtons.forEach(button => {
                button.addEventListener('click', function() {
                    setActiveCategoryFilter(this);
                });
            });
        }

        // Setup sort dropdown
        function setupCourseSortDropdown() {
            const sortSelect = document.getElementById('courseSortSelect');
            if (sortSelect) {
                sortSelect.addEventListener('change', function() {
                    currentCourseSort = this.value;
                    applyAllCourseFilters();
                });
            }
        }

        // Setup search input
        function setupCourseSearchInput() {
            const searchInput = document.getElementById('courseSearch');
            if (searchInput) {
                searchInput.addEventListener('input', function() {
                    currentCourseSearch = this.value.toLowerCase();
                    applyAllCourseFilters();
                });
            }
        }

        // Apply all course filters
        function applyAllCourseFilters() {
            console.log('Applying filters - Category:', currentCategoryFilter, 'Sort:', currentCourseSort, 'Search:', currentCourseSearch);
            
            let visibleCards = [];
            
            allCourseCards.forEach(card => {
                let show = true;
                
                // Apply category filter
                if (currentCategoryFilter !== 'all') {
                    const cardCategory = card.getAttribute('data-category')?.toLowerCase();
                    if (cardCategory !== currentCategoryFilter) {
                        show = false;
                    }
                }
                
                // Apply search filter
                if (currentCourseSearch && show) {
                    const courseName = card.getAttribute('data-course-name')?.toLowerCase() || '';
                    const category = card.getAttribute('data-category')?.toLowerCase() || '';
                    const description = card.querySelector('.course-description')?.textContent.toLowerCase() || '';
                    
                    if (!courseName.includes(currentCourseSearch) && 
                        !category.includes(currentCourseSearch) && 
                        !description.includes(currentCourseSearch)) {
                        show = false;
                    }
                }
                
                // Show or hide card
                if (show) {
                    card.style.display = 'block';
                    visibleCards.push(card);
                } else {
                    card.style.display = 'none';
                }
            });
            
            // Sort visible cards
            sortCourseCards(visibleCards);
            
            // Show empty state if no cards visible
            const noCoursesPanel = document.getElementById('<%= pnlNoCourses.ClientID %>');
            if (noCoursesPanel) {
                noCoursesPanel.style.display = visibleCards.length === 0 ? 'block' : 'none';
            }
        }

        // Sort course cards
        function sortCourseCards(cards) {
            if (cards.length === 0) return;
            
            const container = document.getElementById('courseGrid');
            if (!container) return;
            
            // Sort the array
            cards.sort((a, b) => {
                switch (currentCourseSort) {
                    case 'name':
                        const nameA = a.getAttribute('data-course-name')?.toLowerCase() || '';
                        const nameB = b.getAttribute('data-course-name')?.toLowerCase() || '';
                        return nameA.localeCompare(nameB);
                    case 'category':
                        const categoryA = a.getAttribute('data-category')?.toLowerCase() || '';
                        const categoryB = b.getAttribute('data-category')?.toLowerCase() || '';
                        return categoryA.localeCompare(categoryB);
                    case 'modules':
                        const modulesA = parseInt(a.getAttribute('data-modules') || '0');
                        const modulesB = parseInt(b.getAttribute('data-modules') || '0');
                        return modulesB - modulesA; // Descending order
                    default:
                        return 0;
                }
            });
            
            // Reorder in DOM
            cards.forEach(card => {
                container.appendChild(card);
            });
        }

        // Initialize animations
        function initializeAnimations() {
            // Set staggered animation delays
            const fadeElements = document.querySelectorAll('.fade-in');
            const slideElements = document.querySelectorAll('.slide-in');
            
            fadeElements.forEach((el, index) => {
                el.style.animationDelay = `${index * 0.1}s`;
            });
            
            slideElements.forEach((el, index) => {
                el.style.animationDelay = `${index * 0.1}s`;
            });
            
            // Set up intersection observer for on-scroll animations
            const observerOptions = {
                threshold: 0.1,
                rootMargin: '0px 0px -50px 0px'
            };
            
            const observer = new IntersectionObserver(function(entries) {
                entries.forEach(entry => {
                    if (entry.isIntersecting) {
                        entry.target.style.opacity = '1';
                    }
                });
            }, observerOptions);
            
            // Observe all animation elements
            fadeElements.forEach(el => observer.observe(el));
            slideElements.forEach(el => observer.observe(el));
        }

        // Initialize message system
        function initializeMessageSystem() {
            const messageEl = document.getElementById('<%= lblMessage.ClientID %>');
            if (messageEl && messageEl.innerText.trim()) {
                messageEl.style.display = 'block';
                setTimeout(() => {
                    messageEl.style.display = 'none';
                }, 5000);
            }
        }

        // Show message
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

        // Initialize sidebar and menu functionality
        function initializeSidebar() {
            let body = document.body;
            let profile = document.querySelector('.header .flex .profile');
            let search = document.querySelector('.header .flex .search-form');
            let sideBar = document.querySelector('.side-bar');
            
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
                body?.classList.toggle('active');
            });
            
            document.querySelector('#close-btn')?.addEventListener('click', () => {
                sideBar?.classList.remove('active');
                body?.classList.remove('active');
            });
            
            document.querySelector('#toggle-btn')?.addEventListener('click', () => {
                body?.classList.toggle('dark');
            });
            
            window.addEventListener('scroll', () => {
                profile?.classList.remove('active');
                search?.classList.remove('active');
                
                if (window.innerWidth < 1200) {
                    sideBar?.classList.remove('active');
                    body?.classList.remove('active');
                }
            });
        }

        // Setup keyboard shortcuts
        function setupKeyboardShortcuts() {
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
        }

        // Course modal functionality
        function openAddCourseModal() {
            document.getElementById('courseModal').style.display = 'block';
            document.getElementById('modalTitle').innerText = 'Add New Course';
            clearCourseForm();
            
            // Focus on first input
            setTimeout(() => {
                document.getElementById('<%= txtCourseName.ClientID %>').focus();
            }, 300);
        }

        function openEditCourseModal(courseId, courseName, description, category) {
            document.getElementById('courseModal').style.display = 'block';
            document.getElementById('modalTitle').innerText = 'Edit Course';
            
            document.getElementById('<%= txtCourseName.ClientID %>').value = courseName || '';
            document.getElementById('<%= txtCourseDescription.ClientID %>').value = description || '';
            document.getElementById('<%= txtCategory.ClientID %>').value = category || '';
            document.getElementById('<%= hfCourseID.ClientID %>').value = courseId || '';
            
            // Focus on first input
            setTimeout(() => {
                document.getElementById('<%= txtCourseName.ClientID %>').focus();
            }, 300);
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

        // Enhanced confirmation dialog
        function showConfirmation(title, message, callback) {
            document.getElementById('confirmationTitle').innerText = title;
            document.getElementById('confirmationMessage').innerHTML = message;
            document.getElementById('confirmationOverlay').style.display = 'block';
            document.getElementById('confirmationDialog').style.display = 'block';
            confirmationCallback = callback;

            document.getElementById('confirmButton').onclick = function () {
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

            showConfirmation('Confirm Course Deletion', message, function () {
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

        // Close modal when clicking outside
        window.onclick = function (event) {
            const courseModal = document.getElementById('courseModal');
            const confirmationOverlay = document.getElementById('confirmationOverlay');

            if (event.target === courseModal) {
                closeCourseModal();
            }

            if (event.target === confirmationOverlay) {
                hideConfirmation();
            }
        }
    </script>
</body>
</html>