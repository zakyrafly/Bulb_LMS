<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="calendar.aspx.cs" Inherits="assignmentDraft1.calendar" %>

<!DOCTYPE html>
<html lang="en">
<head>
   <meta charset="UTF-8">
   <meta http-equiv="X-UA-Compatible" content="IE=edge">
   <meta name="viewport" content="width=device-width, initial-scale=1.0">
   <title>Academic Calendar - Bulb LMS</title>
   <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.1.2/css/all.min.css">
   <link rel="stylesheet" href="css/style.css">

   <style>
       /* Calendar Styles */
       .calendar-container {
           display: flex;
           flex-direction: column;
           gap: 2rem;
       }

       .calendar-header {
           display: flex;
           justify-content: space-between;
           align-items: center;
       }

       .month-selector {
           display: flex;
           align-items: center;
           gap: 1rem;
       }

       .month-name {
           font-size: 2.2rem;
           font-weight: bold;
           min-width: 200px;
           text-align: center;
       }

       .month-nav {
           width: 40px;
           height: 40px;
           border-radius: 50%;
           background: var(--main-color);
           color: white;
           display: flex;
           align-items: center;
           justify-content: center;
           cursor: pointer;
           transition: all 0.3s ease;
       }

       .month-nav:hover {
           background: var(--black);
       }

       .view-switcher {
           display: flex;
           gap: 0.5rem;
       }

       .view-btn {
           padding: 0.5rem 1rem;
           border-radius: 0.5rem;
           background: var(--light-bg);
           color: var(--light-color);
           cursor: pointer;
           transition: all 0.3s ease;
       }

       .view-btn:hover, .view-btn.active {
           background: var(--main-color);
           color: white;
       }

       .calendar-grid {
           display: grid;
           grid-template-columns: repeat(7, 1fr);
           gap: 0.5rem;
           background: var(--white);
           border-radius: 0.5rem;
           box-shadow: var(--box-shadow);
           padding: 1.5rem;
       }

       .calendar-day-header {
           text-align: center;
           font-weight: bold;
           padding: 0.5rem;
           color: var(--black);
       }

       .calendar-day {
           min-height: 100px;
           padding: 0.5rem;
           border-radius: 0.5rem;
           background: var(--light-bg);
           position: relative;
           transition: all 0.3s ease;
       }

       .calendar-day:hover {
           background: var(--white);
           box-shadow: var(--box-shadow);
       }

       .day-number {
           font-size: 1.2rem;
           font-weight: bold;
           margin-bottom: 0.5rem;
           color: var(--black);
       }

       .other-month .day-number {
           color: var(--light-color);
           opacity: 0.5;
       }

       .today {
           background: rgba(var(--main-rgb), 0.1);
           border: 2px solid var(--main-color);
       }

       .today .day-number {
           color: var(--main-color);
       }

       .event-dot {
           width: 10px;
           height: 10px;
           border-radius: 50%;
           display: inline-block;
           margin-right: 5px;
       }

       .event-list {
           margin-top: 0.5rem;
           overflow: hidden;
       }

       .event-item {
           font-size: 0.85rem;
           white-space: nowrap;
           overflow: hidden;
           text-overflow: ellipsis;
           padding: 2px 5px;
           margin-bottom: 3px;
           border-radius: 3px;
           cursor: pointer;
           transition: all 0.3s ease;
       }

       .event-item:hover {
           filter: brightness(1.1);
       }

       .event-assignment {
           background: rgba(255, 193, 7, 0.2);
           border-left: 3px solid #ffc107;
       }

       .event-overdue {
           background: rgba(220, 53, 69, 0.2);
           border-left: 3px solid #dc3545;
       }

       .more-events {
           font-size: 0.8rem;
           text-align: center;
           color: var(--main-color);
           cursor: pointer;
       }

       .more-events:hover {
           text-decoration: underline;
       }

       /* Agenda section */
       .agenda-section {
           background: var(--white);
           border-radius: 0.5rem;
           box-shadow: var(--box-shadow);
           padding: 1.5rem;
       }

       .agenda-header {
           display: flex;
           justify-content: space-between;
           align-items: center;
           margin-bottom: 1rem;
           padding-bottom: 1rem;
           border-bottom: 1px solid var(--light-bg);
       }

       .agenda-date {
           font-size: 1.8rem;
           font-weight: bold;
           color: var(--black);
       }

       .agenda-filters {
           display: flex;
           gap: 0.5rem;
       }

       .filter-tag {
           padding: 0.3rem 0.8rem;
           border-radius: 2rem;
           font-size: 0.9rem;
           cursor: pointer;
           transition: all 0.3s ease;
           display: flex;
           align-items: center;
           gap: 0.3rem;
       }

       .filter-tag i {
           font-size: 0.8rem;
       }

       .filter-tag.active {
           font-weight: bold;
       }

       .filter-assignment {
           background: rgba(255, 193, 7, 0.2);
           color: #856404;
       }
       .filter-assignment.active {
           background: #ffc107;
           color: #000;
       }

       .filter-overdue {
           background: rgba(220, 53, 69, 0.2);
           color: #dc3545;
       }
       .filter-overdue.active {
           background: #dc3545;
           color: #fff;
       }

       .timeline {
           position: relative;
           padding-left: 30px;
       }

       .timeline::before {
           content: '';
           position: absolute;
           left: 8px;
           top: 0;
           bottom: 0;
           width: 2px;
           background: var(--light-bg);
       }

       .timeline-item {
           position: relative;
           margin-bottom: 1.5rem;
           padding: 1rem;
           border-radius: 0.5rem;
           transition: all 0.3s ease;
       }

       .timeline-item:hover {
           transform: translateX(5px);
       }

       .timeline-item::before {
           content: '';
           position: absolute;
           left: -30px;
           top: 1.5rem;
           width: 18px;
           height: 18px;
           border-radius: 50%;
           background: var(--white);
           border: 2px solid;
           z-index: 1;
       }

       .timeline-assignment::before {
           border-color: #ffc107;
       }

       .timeline-overdue::before {
           border-color: #dc3545;
       }

       .timeline-item .time {
           font-size: 0.9rem;
           color: var(--light-color);
           margin-bottom: 0.5rem;
       }

       .timeline-item .title {
           font-size: 1.2rem;
           font-weight: bold;
           color: var(--black);
           margin-bottom: 0.5rem;
       }

       .timeline-item .description {
           color: var(--light-color);
       }

       .timeline-item .event-actions {
           display: flex;
           gap: 0.5rem;
           margin-top: 1rem;
       }

       .timeline-assignment {
           background: rgba(255, 193, 7, 0.1);
           border-left: 3px solid #ffc107;
       }

       .timeline-overdue {
           background: rgba(220, 53, 69, 0.1);
           border-left: 3px solid #dc3545;
       }

       .no-events {
           text-align: center;
           padding: 2rem;
           color: var(--light-color);
       }

       .no-events i {
           font-size: 3rem;
           margin-bottom: 1rem;
           opacity: 0.3;
       }

       /* Modal styles */
       .event-modal {
           display: none;
           position: fixed;
           top: 0;
           left: 0;
           width: 100%;
           height: 100%;
           background: rgba(0, 0, 0, 0.5);
           z-index: 1000;
           align-items: center;
           justify-content: center;
       }

       .modal-content {
           background: var(--white);
           border-radius: 0.5rem;
           box-shadow: var(--box-shadow);
           width: 90%;
           max-width: 600px;
           max-height: 90vh;
           overflow-y: auto;
           position: relative;
       }

       .modal-header {
           padding: 1.5rem;
           border-bottom: 1px solid var(--light-bg);
           display: flex;
           justify-content: space-between;
           align-items: center;
       }

       .modal-body {
           padding: 1.5rem;
       }

       .modal-footer {
           padding: 1.5rem;
           border-top: 1px solid var(--light-bg);
           display: flex;
           justify-content: flex-end;
           gap: 1rem;
       }

       .close-modal {
           position: absolute;
           top: 1rem;
           right: 1rem;
           cursor: pointer;
           font-size: 1.5rem;
           color: var(--light-color);
           transition: all 0.3s ease;
       }

       .close-modal:hover {
           color: var(--main-color);
       }

       .event-details {
           margin-bottom: 1rem;
       }

       .event-detail {
           display: flex;
           margin-bottom: 0.8rem;
       }

       .detail-label {
           font-weight: bold;
           width: 120px;
           color: var(--black);
       }

       .detail-value {
           flex: 1;
       }

       .event-tag {
           display: inline-block;
           padding: 0.3rem 0.8rem;
           border-radius: 2rem;
           font-size: 0.9rem;
           margin-right: 0.5rem;
           margin-bottom: 0.5rem;
       }

       /* Quick Actions */
       .quick-actions {
           position: fixed;
           bottom: 2rem;
           right: 2rem;
           display: flex;
           flex-direction: column;
           gap: 1rem;
           z-index: 99;
       }

       .quick-action-btn {
           width: 50px;
           height: 50px;
           border-radius: 50%;
           background: var(--main-color);
           color: white;
           display: flex;
           align-items: center;
           justify-content: center;
           box-shadow: var(--box-shadow);
           transition: all 0.3s ease;
       }

       .quick-action-btn:hover {
           transform: scale(1.1);
           background: var(--black);
       }

       .today-btn {
           background: #0d6efd;
       }

       /* Responsive styles */
       @media (max-width: 991px) {
           .calendar-grid {
               font-size: 0.9rem;
           }
           
           .calendar-day {
               min-height: 80px;
               padding: 0.3rem;
           }
           
           .day-number {
               font-size: 1rem;
           }
           
           .event-item {
               font-size: 0.75rem;
               padding: 1px 3px;
           }
       }
       
       @media (max-width: 768px) {
           .calendar-day-header {
               font-size: 0.8rem;
           }
           
           .calendar-day {
               min-height: 60px;
           }
           
           .event-dot {
               width: 8px;
               height: 8px;
           }
           
           .event-item {
               font-size: 0.7rem;
               margin-bottom: 2px;
           }
           
           .agenda-date {
               font-size: 1.5rem;
           }
           
           .agenda-filters {
               flex-wrap: wrap;
           }
           
           .timeline-item .title {
               font-size: 1.1rem;
           }
       }
       
       @media (max-width: 576px) {
           .calendar-grid {
               grid-template-columns: repeat(7, 1fr);
               gap: 0.2rem;
               padding: 0.5rem;
           }
           
           .calendar-day-header {
               font-size: 0.7rem;
               padding: 0.3rem;
           }
           
           .calendar-day {
               min-height: 50px;
               padding: 0.2rem;
           }
           
           .day-number {
               font-size: 0.9rem;
               margin-bottom: 0.2rem;
           }
           
           .event-list {
               margin-top: 0.2rem;
           }
           
           .calendar-header {
               flex-direction: column;
               gap: 1rem;
           }
           
           .month-selector {
               width: 100%;
               justify-content: space-between;
           }
           
           .view-switcher {
               width: 100%;
               justify-content: center;
           }
       }
   </style>
</head>
<body>
    <form id="form1" runat="server">

<header class="header">
   <section class="flex">
      <a href="homeWebform.aspx" class="logo">Bulb</a>
      
      <asp:Panel runat="server" CssClass="search-form">
          <asp:TextBox ID="txtSearch" runat="server" CssClass="search-input" placeholder="Search events..." MaxLength="100" />
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
         <h3 class="name"><asp:Label ID="lblName" runat="server" Text=""></asp:Label></h3>
         <p class="role"><asp:Label ID="lblRole" runat="server" Text=""></asp:Label></p>
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
      <h3 class="name"><asp:Label ID="lblSidebarName" runat="server" Text=""></asp:Label></h3>
      <p class="role"><asp:Label ID="lblSidebarRole" runat="server" Text=""></asp:Label></p>
      <a href="profile.aspx" class="btn">view profile</a>
   </div>

   <nav class="navbar">
      <a href="homeWebform.aspx"><i class="fas fa-home"></i><span>Home</span></a>
      <a href="courses.html"><i class="fas fa-graduation-cap"></i><span>My Courses</span></a>
      <a href="student-assignments.aspx"><i class="fas fa-tasks"></i><span>Assignments</span></a>
      <a href="calendar.aspx" class="active"><i class="fas fa-calendar"></i><span>Calendar</span></a>
      <a href="profile.aspx"><i class="fas fa-user"></i><span>Profile</span></a>
      <a href="loginWebform.aspx"><i class="fas fa-sign-out-alt"></i><span>Logout</span></a>
   </nav>
</div>

<section class="course-content">
    <!-- Calendar Container -->
    <div class="calendar-container">
        <!-- Calendar Header -->
        <div class="calendar-header">
            <div class="month-selector">
                <div class="month-nav" id="prevMonth"><i class="fas fa-chevron-left"></i></div>
                <div class="month-name" id="currentMonth">June 2025</div>
                <div class="month-nav" id="nextMonth"><i class="fas fa-chevron-right"></i></div>
            </div>
            <div class="view-switcher">
                <div class="view-btn active" id="monthView">Month</div>
                <div class="view-btn" id="weekView">Week</div>
                <div class="view-btn" id="listView">List</div>
                <asp:Button ID="btnToday" runat="server" Text="Today" CssClass="inline-btn" OnClick="btnToday_Click" />
            </div>
        </div>

        <!-- Calendar Grid -->
        <div class="calendar-grid" id="calendarGrid">
            <!-- Day Headers -->
            <div class="calendar-day-header">Sun</div>
            <div class="calendar-day-header">Mon</div>
            <div class="calendar-day-header">Tue</div>
            <div class="calendar-day-header">Wed</div>
            <div class="calendar-day-header">Thu</div>
            <div class="calendar-day-header">Fri</div>
            <div class="calendar-day-header">Sat</div>
            
            <!-- Calendar Days will be generated by JavaScript -->
            <asp:Literal ID="litCalendarDays" runat="server"></asp:Literal>
        </div>

        <!-- Daily Agenda Section -->
        <div class="agenda-section">
            <div class="agenda-header">
                <h2 class="agenda-date" id="agendaDate">June 1, 2025</h2>
                <div class="agenda-filters">
                    <div class="filter-tag filter-assignment active" data-type="pending">
                        <i class="fas fa-clock"></i> Pending
                    </div>
                    <div class="filter-tag filter-overdue active" data-type="overdue">
                        <i class="fas fa-exclamation-triangle"></i> Overdue
                    </div>
                </div>
            </div>

            <div class="timeline" id="agendaTimeline">
                <!-- Events for the selected day will be loaded here -->
                <asp:Literal ID="litDayEvents" runat="server"></asp:Literal>
            </div>
        </div>
    </div>
</section>

<!-- Event Details Modal - Hidden since we're redirecting directly to assignment details -->
<div class="event-modal" id="eventModal" style="display: none;">
    <!-- Modal content omitted as it's not needed with direct redirection -->
</div>

<!-- Quick Actions -->
<div class="quick-actions">
    <a href="#" class="quick-action-btn today-btn" id="quickTodayBtn" title="Go to Today">
        <i class="fas fa-calendar-day"></i>
    </a>
</div>

<footer class="footer">
   &copy; copyright @ 2025 by <span>Stanley Nilam</span> | all rights reserved!
</footer>

<script src="js/script.js"></script>
<script>
    // Calendar initialization
    document.addEventListener('DOMContentLoaded', function () {
        // Current date tracking
        let currentDate = new Date();
        let selectedDate = new Date();
        let currentView = 'month';
        let activeFilters = ['pending', 'overdue'];

        // Initialize the calendar
        updateCalendarHeader();

        // Set up event listeners
        document.getElementById('prevMonth').addEventListener('click', function () {
            currentDate.setMonth(currentDate.getMonth() - 1);
            updateCalendarHeader();
            loadCalendarData();
        });

        document.getElementById('nextMonth').addEventListener('click', function () {
            currentDate.setMonth(currentDate.getMonth() + 1);
            updateCalendarHeader();
            loadCalendarData();
        });

        document.getElementById('monthView').addEventListener('click', function () {
            setActiveView('month');
        });

        document.getElementById('weekView').addEventListener('click', function () {
            setActiveView('week');
        });

        document.getElementById('listView').addEventListener('click', function () {
            setActiveView('list');
        });

        document.getElementById('quickTodayBtn').addEventListener('click', function (e) {
            e.preventDefault();
            goToToday();
        });

        // Set up filter toggles
        document.querySelectorAll('.filter-tag').forEach(function (filter) {
            filter.addEventListener('click', function () {
                const type = this.getAttribute('data-type');
                this.classList.toggle('active');

                if (this.classList.contains('active')) {
                    if (!activeFilters.includes(type)) {
                        activeFilters.push(type);
                    }
                } else {
                    const index = activeFilters.indexOf(type);
                    if (index > -1) {
                        activeFilters.splice(index, 1);
                    }
                }

                filterAgendaEvents();
            });
        });

        // Initial load
        loadCalendarData();

        // Functions
        function updateCalendarHeader() {
            const options = { year: 'numeric', month: 'long' };
            document.getElementById('currentMonth').textContent = currentDate.toLocaleDateString('en-US', options);
        }

        function setActiveView(view) {
            currentView = view;

            // Update view buttons
            document.querySelectorAll('.view-btn').forEach(function (btn) {
                btn.classList.remove('active');
            });

            document.getElementById(view + 'View').classList.add('active');

            // Load appropriate view
            loadCalendarData();
        }

        function goToToday() {
            currentDate = new Date();
            selectedDate = new Date();
            updateCalendarHeader();
            loadCalendarData();
            updateAgendaDate();
            loadDayEvents(selectedDate);
        }

        function loadCalendarData() {
            // This would typically make an AJAX call to load calendar data
            // For now, we'll use the server-rendered content from ASP.NET

            // After loading calendar data, bind day click events
            setTimeout(bindDayClickEvents, 100);
        }

        function bindDayClickEvents() {
            document.querySelectorAll('.calendar-day').forEach(function (day) {
                day.addEventListener('click', function () {
                    // Remove 'selected' class from all days
                    document.querySelectorAll('.calendar-day').forEach(function (d) {
                        d.classList.remove('selected');
                    });

                    // Add 'selected' class to clicked day
                    this.classList.add('selected');

                    // Get the date from the day element
                    const dateString = this.getAttribute('data-date');
                    if (dateString) {
                        selectedDate = new Date(dateString);
                        updateAgendaDate();
                        loadDayEvents(selectedDate);
                    }
                });
            });

            // Also bind event item clicks to show modal
            document.querySelectorAll('.event-item').forEach(function (item) {
                item.addEventListener('click', function (e) {
                    e.stopPropagation(); // Prevent triggering day click
                    const eventId = this.getAttribute('data-event-id');
                    if (eventId) {
                        showEventDetails(eventId);
                    }
                });
            });

            // Bind timeline item clicks
            document.querySelectorAll('.timeline-item').forEach(function (item) {
                item.addEventListener('click', function () {
                    const eventId = this.getAttribute('data-event-id');
                    if (eventId) {
                        showEventDetails(eventId);
                    }
                });
            });
        }

        function updateAgendaDate() {
            const options = { weekday: 'long', year: 'numeric', month: 'long', day: 'numeric' };
            document.getElementById('agendaDate').textContent = selectedDate.toLocaleDateString('en-US', options);
        }

        function loadDayEvents(date) {
            // This would typically make an AJAX call to load events for the selected day
            // For now, we'll use the server-rendered content

            // After loading events, apply any active filters
            setTimeout(filterAgendaEvents, 100);
        }

        function filterAgendaEvents() {
            const activeFilters = [];
            document.querySelectorAll('.filter-tag.active').forEach(function (filter) {
                activeFilters.push(filter.getAttribute('data-type'));
            });

            document.querySelectorAll('.timeline-item').forEach(function (item) {
                const type = item.getAttribute('data-event-type');
                if (activeFilters.includes(type)) {
                    item.style.display = '';
                } else {
                    item.style.display = 'none';
                }
            });

            // Check if there are any visible events
            const visibleEvents = Array.from(document.querySelectorAll('.timeline-item')).filter(
                item => item.style.display !== 'none'
            );

            const noEventsEl = document.querySelector('.no-events');

            if (visibleEvents.length === 0) {
                if (!noEventsEl) {
                    const timeline = document.getElementById('agendaTimeline');
                    const noEvents = document.createElement('div');
                    noEvents.className = 'no-events';
                    noEvents.innerHTML = '<i class="fas fa-calendar-times"></i><p>No assignments due on this day</p>';
                    timeline.appendChild(noEvents);
                } else {
                    noEventsEl.style.display = '';
                }
            } else if (noEventsEl) {
                noEventsEl.style.display = 'none';
            }
        }

        function showEventDetails(assignmentId) {
            // Redirect to assignment details page
            window.location.href = 'assignment-details.aspx?assignmentID=' + assignmentId;
        }
    });
</script>

    </form>
</body>
</html>