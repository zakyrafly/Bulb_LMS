<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="homeWebform.aspx.cs" Inherits="assignmentDraft1.homeWebform" %>

<!DOCTYPE html>
<html lang="en">
<head>
   <meta charset="UTF-8">
   <meta http-equiv="X-UA-Compatible" content="IE=edge">
   <meta name="viewport" content="width=device-width, initial-scale=1.0">
   <title>Student Dashboard - Bulb LMS</title>
   <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.1.2/css/all.min.css">
   <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <form id="form1" runat="server">

<header class="header">
   <section class="flex">
      <a href="homeWebform.aspx" class="logo">Bulb</a>

      <asp:Panel runat="server" CssClass="search-form">
          <asp:TextBox ID="txtSearch" runat="server" CssClass="search-input" placeholder="Search courses, assignments..." MaxLength="100" />
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
      <a href="homeWebform.aspx" class="active"><i class="fas fa-home"></i><span>Home</span></a>
      <a href="courses.html"><i class="fas fa-graduation-cap"></i><span>My Courses</span></a>
      <a href="assignments.html"><i class="fas fa-tasks"></i><span>Assignments</span></a>
      <a href="grades.html"><i class="fas fa-star"></i><span>Grades</span></a>
      <a href="calendar.html"><i class="fas fa-calendar"></i><span>Calendar</span></a>
      <a href="profile.aspx"><i class="fas fa-user"></i><span>Profile</span></a>
      <a href="loginWebform.aspx"><i class="fas fa-sign-out-alt"></i><span>Logout</span></a>
   </nav>
</div>

<section class="home-grid">
    <!-- Welcome Section -->
    <div class="welcome-section fade-in">
        <h1 class="welcome-title">
            <i class="fas fa-sun"></i> Good <span id="timeOfDay">Morning</span>, <asp:Label ID="lblWelcomeName" runat="server" Text="Student"></asp:Label>!
        </h1>
        <p class="welcome-subtitle">Ready to continue your learning journey?</p>
        <div class="current-time" id="currentDateTime"></div>
    </div>

    <!-- Dashboard Statistics -->
    <div class="dashboard-stats fade-in">
        <div class="stat-card">
            <div class="stat-header">
                <div>
                    <div class="stat-number" id="totalAssignments">0</div>
                    <div class="stat-label">Total Assignments</div>
                </div>
                <div class="stat-icon">
                    <i class="fas fa-tasks"></i>
                </div>
            </div>
        </div>

        <div class="stat-card">
            <div class="stat-header">
                <div>
                    <div class="stat-number" id="pendingAssignments">0</div>
                    <div class="stat-label">Pending</div>
                </div>
                <div class="stat-icon">
                    <i class="fas fa-clock"></i>
                </div>
            </div>
        </div>

        <div class="stat-card">
            <div class="stat-header">
                <div>
                    <div class="stat-number" id="completedAssignments">0</div>
                    <div class="stat-label">Completed</div>
                </div>
                <div class="stat-icon">
                    <i class="fas fa-check-circle"></i>
                </div>
            </div>
        </div>

        <div class="stat-card">
            <div class="stat-header">
                <div>
                    <div class="stat-number" id="averageGrade">0%</div>
                    <div class="stat-label">Average Grade</div>
                </div>
                <div class="stat-icon">
                    <i class="fas fa-star"></i>
                </div>
            </div>
        </div>
    </div>

    <!-- Timeline Section -->
    <div class="timeline-box box fade-in">
        <div class="timeline-header">
            <h1><i class="fas fa-timeline"></i> Assignment Timeline</h1>
            <div id="lastUpdated">Updated: <span id="updateTime"></span></div>
        </div>

        <div class="timeline-filters">
            <div class="filter-row">
                <div class="filter-group">
                    <label class="filter-label">Filter by Status:</label>
                    <div class="quick-filters">
                        <div class="quick-filter active" data-filter="all">All</div>
                        <div class="quick-filter" data-filter="pending">Pending</div>
                        <div class="quick-filter" data-filter="submitted">Submitted</div>
                        <div class="quick-filter" data-filter="overdue">Overdue</div>
                        <div class="quick-filter" data-filter="graded">Graded</div>
                    </div>
                </div>

                <div class="filter-group">
                    <label class="filter-label">Sort by:</label>
                    <select class="box select" id="sortSelect">
                        <option value="dueDate">Due Date</option>
                        <option value="course">Course</option>
                        <option value="status">Status</option>
                        <option value="title">Title</option>
                    </select>
                </div>

                <div class="filter-group">
                    <label class="filter-label">Search:</label>
                    <input type="text" class="box search-input" id="assignmentSearch" placeholder="Search assignments..." />
                </div>
            </div>
        </div>

        <!-- Assignment Grid -->
        <div class="assignment-grid" id="assignmentGrid">
            <asp:Repeater ID="assignmentRepeater" runat="server">
                <ItemTemplate>
                    <div class="assignment-card slide-in" 
                         data-status='<%# GetNormalizedStatus(Eval("Status")) %>'
                         data-course='<%# Eval("CourseName") %>'
                         data-due='<%# Eval("DueDate", "{0:yyyy-MM-dd}") %>'
                         data-title='<%# Eval("Title") %>'>
                        
                        <div class="assignment-header">
                            <h3 class="assignment-title"><%# Eval("Title") %></h3>
                            <div class="assignment-course"><%# Eval("CourseName") %></div>
                        </div>

                        <div class="assignment-body">
                            <div class="status-badge status-<%# Eval("Status").ToString().ToLower().Replace(" ", "-") %>">
                                <i class="fas <%# GetStatusIcon(Eval("Status")) %>"></i>
                                <%# Eval("Status") %>
                            </div>

                            <%# Eval("PointsEarned") != DBNull.Value ? GetGradeDisplay(Eval("PointsEarned"), Eval("MaxPoints")) : "" %>

                            <div class="assignment-meta">
                                <div class="meta-item">
                                    <i class="fas fa-calendar meta-icon"></i>
                                    <span>Due: <%# Eval("DueDate", "{0:MMM dd, yyyy}") %></span>
                                </div>
                                <div class="meta-item">
                                    <i class="fas fa-clock meta-icon"></i>
                                    <span><%# GetTimeRemaining(Eval("DueDate"), Eval("Status")) %></span>
                                </div>
                                <div class="meta-item">
                                    <i class="fas fa-star meta-icon"></i>
                                    <span><%# Eval("MaxPoints") %> points</span>
                                </div>
                                <div class="meta-item">
                                    <i class="fas fa-info-circle meta-icon"></i>
                                    <span><%# GetStatusDescription(Eval("Status")) %></span>
                                </div>
                            </div>

                            <div class="assignment-actions">
                                <a href='assignment-details.aspx?assignmentID=<%# Eval("AssignmentID") %>' 
                                   class="inline-btn">
                                    <i class="fas fa-eye"></i> View Details
                                </a>
                            </div>
                        </div>
                    </div>
                </ItemTemplate>
            </asp:Repeater>
        </div>

        <!-- Empty State -->
        <asp:Panel ID="noAssignmentsPanel" runat="server" Visible="false">
            <div class="empty-state">
                <div class="empty-icon">
                    <i class="fas fa-tasks"></i>
                </div>
                <h3 class="empty-title">No assignments yet</h3>
                <p class="empty-text">When your instructors create assignments, they'll appear here.</p>
            </div>
        </asp:Panel>
    </div>
</section>

<!-- My Courses Section -->
<section class="courses">
    <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 2rem;">
        <h1 class="heading"><i class="fas fa-graduation-cap"></i> My Courses</h1>
        <a href="courses.html" class="inline-btn">
            <i class="fas fa-plus"></i> Browse All Courses
        </a>
    </div>

    <div class="course-grid">
        <asp:Repeater ID="courseContentRepeater" runat="server">
            <ItemTemplate>
                <div class="course-card fade-in">
                    <div class="course-header">
                        <h3 class="course-title"><%# Eval("ModuleTitle") %></h3>
                        <div class="course-lecturer">
                            <i class="fas fa-user"></i>
                            <span><%# Eval("LecturerName") ?? "Instructor" %></span>
                        </div>
                    </div>
                    <div class="course-body">
                        <div class="course-progress">
                            <div class="progress-bar">
                                <div class="progress-fill" style="width: <%# GetRandomProgress() %>%"></div>
                            </div>
                            <div class="progress-text">Progress: <%# GetRandomProgress() %>% complete</div>
                        </div>
                        <div style="margin-top: 1.5rem;">
                            <a href='lessons.aspx?moduleID=<%# Eval("ModuleID") %>' class="inline-btn">
                                <i class="fas fa-play"></i> Continue Learning
                            </a>
                        </div>
                    </div>
                </div>
            </ItemTemplate>
        </asp:Repeater>

        <!-- Empty State for Courses -->
        <asp:Panel ID="noCoursesPanel" runat="server" Visible="false">
            <div class="empty-state">
                <div class="empty-icon">
                    <i class="fas fa-graduation-cap"></i>
                </div>
                <h3 class="empty-title">No courses enrolled</h3>
                <p class="empty-text">Enroll in courses to start your learning journey.</p>
                <a href="courses.html" class="inline-btn">
                    <i class="fas fa-search"></i> Browse Courses
                </a>
            </div>
        </asp:Panel>
    </div>
</section>

<!-- Quick Actions -->
<div class="quick-actions">
    <a href="assignments.html" class="quick-action-btn" title="View All Assignments">
        <i class="fas fa-tasks"></i>
    </a>
    <a href="calendar.html" class="quick-action-btn" title="View Calendar">
        <i class="fas fa-calendar"></i>
    </a>
    <a href="profile.aspx" class="quick-action-btn" title="View Profile">
        <i class="fas fa-user"></i>
    </a>
</div>

<footer class="footer">
   &copy; copyright @ 2025 by <span>Stanley Nilam</span> | all rights reserved!
</footer>

<script src="js/script.js"></script>
<script>
    // Global variables
    let allCards = [];
    let currentFilter = 'all';
    let currentSort = 'dueDate';
    let currentSearch = '';

    // Initialize when DOM is ready
    document.addEventListener('DOMContentLoaded', function () {
        console.log('DOM loaded, initializing...');
        
        // Set welcome message
        setWelcomeMessage();
        
        // Update time
        updateDateTime();
        setInterval(updateDateTime, 1000);
        
        // Initialize filtering with delay to ensure ASP.NET is done
        setTimeout(initializeSystem, 1000);
        
        // Add other initializations
        addSmoothScrolling();
        initializeAnimations();
    });

    function initializeSystem() {
        console.log('Initializing filtering system...');
        
        // Get all assignment cards
        allCards = document.querySelectorAll('.assignment-card');
        console.log('Found', allCards.length, 'assignment cards');
        
        // Setup filter buttons
        setupFilterButtons();
        
        // Setup sort dropdown
        setupSortDropdown();
        
        // Setup search input
        setupSearchInput();
        
        // Calculate initial statistics
        calculateStatistics();
        
        console.log('System initialized successfully');
    }

    function setupFilterButtons() {
        const filterButtons = document.querySelectorAll('.quick-filter');
        console.log('Setting up', filterButtons.length, 'filter buttons');
        
        filterButtons.forEach(button => {
            button.addEventListener('click', function() {
                console.log('Filter clicked:', this.getAttribute('data-filter'));
                
                // Remove active from all buttons
                filterButtons.forEach(btn => btn.classList.remove('active'));
                
                // Add active to clicked button
                this.classList.add('active');
                
                // Apply filter
                currentFilter = this.getAttribute('data-filter');
                applyAllFilters();
            });
        });
    }

    function setupSortDropdown() {
        const sortSelect = document.getElementById('sortSelect');
        if (sortSelect) {
            console.log('Setting up sort dropdown');
            sortSelect.addEventListener('change', function() {
                console.log('Sort changed to:', this.value);
                currentSort = this.value;
                applyAllFilters();
            });
        }
    }

    function setupSearchInput() {
        const searchInput = document.getElementById('assignmentSearch');
        if (searchInput) {
            console.log('Setting up search input');
            searchInput.addEventListener('input', function() {
                console.log('Search input:', this.value);
                currentSearch = this.value.toLowerCase();
                applyAllFilters();
            });
        }
    }

    function applyAllFilters() {
        console.log('Applying filters - Filter:', currentFilter, 'Sort:', currentSort, 'Search:', currentSearch);
        
        let visibleCards = [];
        
        allCards.forEach(card => {
            let show = true;
            
            // Apply status filter
            if (currentFilter !== 'all') {
                const cardStatus = card.getAttribute('data-status');
                if (cardStatus !== currentFilter) {
                    show = false;
                }
            }
            
            // Apply search filter
            if (currentSearch && show) {
                const title = (card.getAttribute('data-title') || '').toLowerCase();
                const course = (card.getAttribute('data-course') || '').toLowerCase();
                if (!title.includes(currentSearch) && !course.includes(currentSearch)) {
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
        
        console.log('Visible cards after filtering:', visibleCards.length);
        
        // Sort visible cards
        sortCards(visibleCards);
        
        // Update empty state
        updateEmptyState(visibleCards.length);
        
        // Update statistics
        calculateStatistics();
    }

    function sortCards(cards) {
        if (cards.length === 0) return;
        
        const container = document.getElementById('assignmentGrid');
        if (!container) return;
        
        // Sort the array
        cards.sort((a, b) => {
            switch (currentSort) {
                case 'dueDate':
                    const dateA = new Date(a.getAttribute('data-due') || '9999-12-31');
                    const dateB = new Date(b.getAttribute('data-due') || '9999-12-31');
                    return dateA - dateB;
                case 'course':
                    const courseA = (a.getAttribute('data-course') || '').toLowerCase();
                    const courseB = (b.getAttribute('data-course') || '').toLowerCase();
                    return courseA.localeCompare(courseB);
                case 'status':
                    const statusA = a.getAttribute('data-status') || '';
                    const statusB = b.getAttribute('data-status') || '';
                    return statusA.localeCompare(statusB);
                case 'title':
                    const titleA = (a.getAttribute('data-title') || '').toLowerCase();
                    const titleB = (b.getAttribute('data-title') || '').toLowerCase();
                    return titleA.localeCompare(titleB);
                default:
                    return 0;
            }
        });
        
        // Reorder in DOM
        cards.forEach(card => {
            container.appendChild(card);
        });
    }

    function updateEmptyState(visibleCount) {
        const emptyPanel = document.querySelector('[id*="noAssignmentsPanel"]');
        if (emptyPanel) {
            if (visibleCount === 0) {
                emptyPanel.style.display = 'block';
            } else {
                emptyPanel.style.display = 'none';
            }
        }
    }

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
        const updateTime = document.getElementById('updateTime');

        if (currentDateTime) {
            currentDateTime.textContent = now.toLocaleDateString('en-US', options);
        }
        if (updateTime) {
            updateTime.textContent = now.toLocaleTimeString('en-US', {
                hour: '2-digit',
                minute: '2-digit'
            });
        }
    }

    function calculateStatistics() {
        const cards = document.querySelectorAll('.assignment-card[style*="block"], .assignment-card:not([style*="none"])');
        let total = allCards.length;
        let pending = 0;
        let completed = 0;
        let gradeSum = 0;
        let gradeCount = 0;

        allCards.forEach(card => {
            const status = card.getAttribute('data-status');
            if (status === 'pending' || status === 'overdue') {
                pending++;
            } else if (status === 'submitted' || status === 'graded') {
                completed++;
            }

            const gradeDisplay = card.querySelector('.grade-score');
            if (gradeDisplay) {
                const gradeText = gradeDisplay.textContent;
                const gradeMatch = gradeText.match(/(\d+)/);
                if (gradeMatch) {
                    gradeSum += parseInt(gradeMatch[1]);
                    gradeCount++;
                }
            }
        });

        animateCounter('totalAssignments', total);
        animateCounter('pendingAssignments', pending);
        animateCounter('completedAssignments', completed);

        const averageGrade = gradeCount > 0 ? Math.round(gradeSum / gradeCount) : 0;
        animateCounter('averageGrade', averageGrade, '%');
    }

    function animateCounter(elementId, target, suffix = '') {
        const element = document.getElementById(elementId);
        if (!element) return;

        let current = 0;
        const increment = target / 20;
        const timer = setInterval(() => {
            current += increment;
            if (current >= target) {
                current = target;
                clearInterval(timer);
            }
            element.textContent = Math.floor(current) + suffix;
        }, 50);
    }

    function addSmoothScrolling() {
        document.querySelectorAll('a[href^="#"]').forEach(anchor => {
            anchor.addEventListener('click', function (e) {
                e.preventDefault();
                const target = document.querySelector(this.getAttribute('href'));
                if (target) {
                    target.scrollIntoView({
                        behavior: 'smooth',
                        block: 'start'
                    });
                }
            });
        });
    }

    function initializeAnimations() {
        const cards = document.querySelectorAll('.assignment-card, .course-card');
        cards.forEach((card, index) => {
            card.style.animationDelay = `${index * 0.1}s`;
        });

        const observerOptions = {
            threshold: 0.1,
            rootMargin: '0px 0px -50px 0px'
        };

        const observer = new IntersectionObserver(function (entries) {
            entries.forEach(entry => {
                if (entry.isIntersecting) {
                    entry.target.classList.add('fade-in');
                }
            });
        }, observerOptions);

        document.querySelectorAll('.stat-card, .course-card').forEach(el => {
            observer.observe(el);
        });
    }

    // Sidebar functionality
    document.addEventListener('DOMContentLoaded', function() {
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

    // Auto-refresh
    setInterval(() => {
        updateDateTime();
        calculateStatistics();
    }, 60000);
</script>

    </form>
</body>
</html>