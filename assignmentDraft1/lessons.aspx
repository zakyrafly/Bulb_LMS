<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="lessons.aspx.cs" Inherits="assignmentDraft1.lessons" %>

<!DOCTYPE html>
<html lang="en">
<head>
   <meta charset="UTF-8">
   <meta http-equiv="X-UA-Compatible" content="IE=edge">
   <meta name="viewport" content="width=device-width, initial-scale=1.0">
   <title>Module Lessons - Bulb</title>
   <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.1.2/css/all.min.css">
   <link rel="stylesheet" href="css/style.css">
   <style>
      .module-header {
          background: linear-gradient(135deg, var(--main-color), var(--orange));
          color: white;
          padding: 2rem;
          margin-bottom: 2rem;
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

      .module-title {
          font-size: 2.4rem;
          margin-bottom: 0.5rem;
      }

      .module-info {
          font-size: 1.6rem;
          opacity: 0.9;
      }

      /* Layout with sidebar and content */
      .lesson-container {
          display: grid;
          grid-template-columns: 300px 1fr;
          gap: 2rem;
          margin-bottom: 3rem;
      }

      /* Lesson sidebar */
      .lesson-sidebar {
          background: white;
          border-radius: 1rem;
          overflow: hidden;
          box-shadow: 0 2px 10px rgba(0,0,0,0.1);
      }

      .sidebar-header {
          background: var(--main-color);
          color: white;
          padding: 1.5rem;
          font-size: 1.8rem;
          font-weight: bold;
      }

      .lesson-list {
          list-style: none;
          padding: 0;
          margin: 0;
          max-height: 600px;
          overflow-y: auto;
      }

      .lesson-list li {
          border-bottom: 1px solid #eee;
      }

      .lesson-list li:last-child {
          border-bottom: none;
      }

      .lesson-list a {
          display: flex;
          align-items: center;
          padding: 1.5rem;
          text-decoration: none;
          color: var(--black);
          transition: all 0.3s ease;
          gap: 1rem;
      }

      .lesson-list a:hover {
          background-color: var(--light-bg);
      }

      .lesson-list a.active {
          background-color: var(--light-bg);
          border-left: 4px solid var(--main-color);
      }

      .lesson-icon {
          background: var(--light-bg);
          width: 40px;
          height: 40px;
          border-radius: 50%;
          display: flex;
          align-items: center;
          justify-content: center;
          color: var(--main-color);
          font-size: 1.4rem;
      }

      .lesson-info {
          flex: 1;
      }

      .lesson-title {
          font-weight: bold;
          margin-bottom: 0.5rem;
      }

      .lesson-meta {
          display: flex;
          font-size: 1.2rem;
          color: var(--light-color);
          gap: 1rem;
      }

      .completed-badge {
          background-color: var(--green);
          color: white;
          padding: 0.2rem 0.8rem;
          border-radius: 1rem;
          font-size: 1rem;
          display: inline-flex;
          align-items: center;
          gap: 0.3rem;
      }

      /* Lesson content area */
      .lesson-content-area {
          background: white;
          border-radius: 1rem;
          overflow: hidden;
          box-shadow: 0 2px 10px rgba(0,0,0,0.1);
          min-height: 600px;
          display: flex;
          flex-direction: column;
      }

      .content-header {
          padding: 2rem;
          border-bottom: 1px solid #eee;
      }

      .content-title {
          font-size: 2.2rem;
          margin-bottom: 1rem;
          font-weight: bold;
          color: var(--black);
      }

      .content-meta {
          display: flex;
          align-items: center;
          gap: 2rem;
          font-size: 1.4rem;
          color: var(--light-color);
      }

      .content-meta i {
          color: var(--main-color);
      }

      .content-type-badge {
          display: inline-flex;
          align-items: center;
          gap: 0.5rem;
          background-color: var(--light-bg);
          padding: 0.5rem 1rem;
          border-radius: 2rem;
          font-size: 1.2rem;
          color: var(--black);
      }

      .main-content-area {
          padding: 2rem;
          flex: 1;
          overflow-y: auto;
      }

      /* Content type specific styles */
      .video-container {
          position: relative;
          padding-bottom: 56.25%; /* 16:9 aspect ratio */
          height: 0;
          overflow: hidden;
          margin-bottom: 2rem;
          border-radius: 0.5rem;
          box-shadow: 0 4px 8px rgba(0,0,0,0.1);
      }

      .video-container iframe {
          position: absolute;
          top: 0;
          left: 0;
          width: 100%;
          height: 100%;
          border: none;
      }

      .pdf-container, .link-container {
          text-align: center;
          padding: 3rem;
          background-color: var(--light-bg);
          border-radius: 0.5rem;
          margin-bottom: 2rem;
      }

      .text-container {
          line-height: 1.8;
          font-size: 1.6rem;
      }

      .text-container p {
          margin-bottom: 1.5rem;
      }

      .text-container h1, .text-container h2, .text-container h3 {
          margin-top: 2rem;
          margin-bottom: 1rem;
          color: var(--black);
      }

      .text-container ul, .text-container ol {
          margin-bottom: 1.5rem;
          padding-left: 2.5rem;
      }

      .text-container li {
          margin-bottom: 0.5rem;
      }

      .text-container img {
          max-width: 100%;
          border-radius: 0.5rem;
          margin: 1rem 0;
      }

      .navigation-buttons {
          display: flex;
          justify-content: space-between;
          margin-top: 3rem;
          padding-top: 2rem;
          border-top: 1px solid #eee;
      }

      .btn-prev, .btn-next {
          display: inline-flex;
          align-items: center;
          gap: 0.8rem;
          padding: 1rem 2rem;
          background-color: var(--main-color);
          color: white;
          border-radius: 0.5rem;
          text-decoration: none;
          transition: all 0.3s ease;
      }

      .btn-prev:hover, .btn-next:hover {
          background-color: var(--hover-color);
          transform: translateY(-2px);
      }

      .btn-prev.disabled, .btn-next.disabled {
          opacity: 0.5;
          cursor: not-allowed;
          pointer-events: none;
      }

      .mark-complete {
          text-align: center;
          margin: 2rem 0;
      }

      .mark-complete-btn {
          display: inline-flex;
          align-items: center;
          gap: 0.8rem;
          padding: 1rem 2rem;
          background-color: var(--green);
          color: white;
          border: none;
          border-radius: 0.5rem;
          cursor: pointer;
          font-size: 1.6rem;
          transition: all 0.3s ease;
      }

      .mark-complete-btn:hover {
          background-color: #27ae60;
          transform: translateY(-2px);
      }

      .mark-complete-btn.completed {
          background-color: #ddd;
          color: #666;
      }

      .mark-complete-btn.completed:hover {
          background-color: #ccc;
      }

      .progress-container {
          background-color: var(--light-bg);
          border-radius: 1rem;
          padding: 1.5rem;
          margin-bottom: 2rem;
      }

      .progress-header {
          display: flex;
          justify-content: space-between;
          margin-bottom: 1rem;
      }

      .progress-title {
          font-size: 1.6rem;
          font-weight: bold;
          color: var(--black);
      }

      .progress-percentage {
          font-size: 1.4rem;
          color: var(--main-color);
          font-weight: bold;
      }

      .progress-bar {
          height: 0.8rem;
          background-color: #e9ecef;
          border-radius: 1rem;
          overflow: hidden;
      }

      .progress-fill {
          height: 100%;
          background-color: var(--main-color);
          border-radius: 1rem;
          transition: width 0.5s ease;
      }

      /* Empty state */
      .empty-state {
          text-align: center;
          padding: 5rem 2rem;
          color: var(--light-color);
      }

      .empty-state i {
          font-size: 5rem;
          margin-bottom: 2rem;
          opacity: 0.3;
      }

      .empty-state h3 {
          font-size: 2rem;
          margin-bottom: 1rem;
          color: var(--black);
      }

      /* Responsive adjustments */
      @media (max-width: 991px) {
          .lesson-container {
              grid-template-columns: 1fr;
          }

          .lesson-sidebar {
              margin-bottom: 2rem;
          }

          .lesson-list {
              max-height: none;
          }
      }

      @media (max-width: 768px) {
          .module-header {
              padding: 1.5rem;
          }

          .content-meta {
              flex-direction: column;
              align-items: flex-start;
              gap: 0.5rem;
          }

          .navigation-buttons {
              flex-direction: column;
              gap: 1rem;
          }

          .btn-prev, .btn-next {
              width: 100%;
              justify-content: center;
          }
      }

      /* Dark mode adjustments */
      .dark .lesson-sidebar,
      .dark .lesson-content-area {
          background-color: var(--black);
          box-shadow: 0 2px 10px rgba(0, 0, 0, 0.3);
      }

      .dark .lesson-list a {
          color: white;
      }

      .dark .lesson-list a:hover,
      .dark .lesson-list a.active {
          background-color: var(--border);
      }

      .dark .lesson-icon {
          background-color: var(--border);
      }

      .dark .content-header {
          border-bottom-color: var(--border);
      }

      .dark .content-type-badge {
          background-color: var(--border);
          color: white;
      }

      .dark .pdf-container, 
      .dark .link-container {
          background-color: var(--border);
      }

      .dark .progress-container {
          background-color: var(--border);
      }

      .dark .progress-bar {
          background-color: var(--black);
      }

      .dark .navigation-buttons {
          border-top-color: var(--border);
      }
   </style>
</head>
<body>
   <form id="form1" runat="server">
      <!-- Header -->
      <header class="header">
         <section class="flex">
            <a href="homeWebform.aspx" class="logo">Bulb</a>
            
            <div class="icons">
               <div id="menu-btn" class="fas fa-bars"></div>
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
            <a href="courses.html" class="active"><i class="fas fa-graduation-cap"></i><span>My Courses</span></a>
            <a href="student-assignments.aspx"><i class="fas fa-tasks"></i><span>Assignments</span></a>
            <a href="calendar.aspx"><i class="fas fa-calendar"></i><span>Calendar</span></a>
            <a href="profile.aspx"><i class="fas fa-user"></i><span>Profile</span></a>
            <a href="loginWebform.aspx"><i class="fas fa-sign-out-alt"></i><span>Logout</span></a>
         </nav>
      </div>

      <!-- Main Content -->
      <section class="playlist-content">
         <!-- Module Header -->
         <div class="module-header">
            <div class="breadcrumb">
               <a href="homeWebform.aspx"><i class="fas fa-home"></i> Home</a>
               <span> / </span>
               <a href="courses.html"><i class="fas fa-graduation-cap"></i> My Courses</a>
               <span> / </span>
               <span><asp:Label ID="lblCourseTitle" runat="server" Text="Course Title"></asp:Label></span>
            </div>
            <h1 class="module-title"><asp:Label ID="lblModuleTitle" runat="server" Text="Module Title"></asp:Label></h1>
            <p class="module-info"><asp:Label ID="lblModuleDescription" runat="server" Text="Module description will appear here..."></asp:Label></p>
         </div>

         <!-- Progress Bar -->
         <div class="progress-container">
            <div class="progress-header">
               <div class="progress-title">Your Progress</div>
               <div class="progress-percentage"><span id="progressPercentage">0%</span></div>
            </div>
            <div class="progress-bar">
               <div class="progress-fill" id="progressFill" style="width: 0%;"></div>
            </div>
         </div>

         <div class="lesson-container">
            <!-- Lesson Sidebar -->
            <div class="lesson-sidebar">
               <div class="sidebar-header">
                  <i class="fas fa-list-alt"></i> Lessons
               </div>
               <ul class="lesson-list">
                  <asp:Repeater ID="lessonRepeater" runat="server">
                     <ItemTemplate>
                        <li>
                           <a href='<%# "lessons.aspx?moduleID=" + Request.QueryString["moduleID"] + "&lessonID=" + Eval("LessonID") %>'
                              class='<%# GetActiveClass(Convert.ToInt32(Eval("LessonID"))) %>'
                              data-lesson-id='<%# Eval("LessonID") %>'>
                              <div class="lesson-icon">
                                 <i class="fas <%# GetContentTypeIcon(Eval("ContentType")) %>"></i>
                              </div>
                              <div class="lesson-info">
                                 <div class="lesson-title"><%# Eval("Title") %></div>
                                 <div class="lesson-meta">
                                    <span><i class="fas fa-clock"></i> <%# Eval("Duration") %> min</span>
                                    <span class="completion-status"></span>
                                 </div>
                              </div>
                           </a>
                        </li>
                     </ItemTemplate>
                  </asp:Repeater>
               </ul>
            </div>

            <!-- Lesson Content Area -->
            <div class="lesson-content-area">
               <asp:Panel ID="pnlLessonContent" runat="server" Visible="true">
                  <div class="content-header">
                     <h2 class="content-title"><asp:Label ID="lblLessonTitle" runat="server" Text="Lesson Title"></asp:Label></h2>
                     <div class="content-meta">
                        <span><i class="fas fa-clock"></i> Duration: <asp:Label ID="lblLessonDuration" runat="server" Text="0"></asp:Label> minutes</span>
                        <div class="content-type-badge">
                           <i class="fas fa-tag"></i>
                           <asp:Label ID="lblContentType" runat="server" Text="Content Type"></asp:Label>
                        </div>
                     </div>
                  </div>

                  <div class="main-content-area">
                     <!-- Video Content -->
                     <asp:Panel ID="pnlVideoContent" runat="server" Visible="false">
                        <div class="video-container">
                           <iframe id="videoFrame" runat="server" width="100%" height="450" frameborder="0" allowfullscreen></iframe>
                        </div>
                     </asp:Panel>

                     <!-- PDF Content -->
                     <asp:Panel ID="pnlPdfContent" runat="server" Visible="false">
                        <div class="pdf-container">
                           <i class="fas fa-file-pdf" style="font-size: 5rem; color: var(--red); margin-bottom: 2rem;"></i>
                           <h3>PDF Document</h3>
                           <p>Click the button below to view the PDF document.</p>
                           <a href="#" id="pdfLink" runat="server" target="_blank" class="btn" style="margin-top: 1.5rem;">
                              <i class="fas fa-external-link-alt"></i> Open PDF Document
                           </a>
                        </div>
                     </asp:Panel>

                     <!-- External Link Content -->
                     <asp:Panel ID="pnlLinkContent" runat="server" Visible="false">
                        <div class="link-container">
                           <i class="fas fa-external-link-alt" style="font-size: 5rem; color: var(--main-color); margin-bottom: 2rem;"></i>
                           <h3>External Resource</h3>
                           <p>Click the button below to access the external learning resource.</p>
                           <a href="#" id="externalLink" runat="server" target="_blank" class="btn" style="margin-top: 1.5rem;">
                              <i class="fas fa-external-link-alt"></i> Visit Resource
                           </a>
                        </div>
                     </asp:Panel>

                     <!-- Text Content -->
                     <asp:Panel ID="pnlTextContent" runat="server" Visible="false">
                        <div class="text-container">
                           <asp:Literal ID="litTextContent" runat="server"></asp:Literal>
                        </div>
                     </asp:Panel>

                     <!-- Mark as Complete Button -->
                     <div class="mark-complete">
                        <button type="button" id="btnMarkComplete" class="mark-complete-btn" onclick="markLessonComplete(); return false;">
                           Mark as Complete
                        </button>
                     </div>

                     <!-- Navigation Buttons -->
                     <div class="navigation-buttons">
                        <asp:HyperLink ID="btnPrevious" runat="server" CssClass="btn-prev" Visible="false">
                           <i class="fas fa-arrow-left"></i> Previous Lesson
                        </asp:HyperLink>
                        
                        <asp:HyperLink ID="btnNext" runat="server" CssClass="btn-next" Visible="false">
                           Next Lesson <i class="fas fa-arrow-right"></i>
                        </asp:HyperLink>
                     </div>
                  </div>
               </asp:Panel>

               <!-- Empty State (No Lesson Selected) -->
               <asp:Panel ID="pnlNoLesson" runat="server" Visible="false">
                  <div class="empty-state">
                     <i class="fas fa-book-open"></i>
                     <h3>No Lesson Selected</h3>
                     <p>Please select a lesson from the sidebar to start learning.</p>
                  </div>
               </asp:Panel>
            </div>
         </div>
      </section>

      <footer class="footer">
         &copy; 2025 <span>Bulb</span> Learning Management System
      </footer>

      <script src="js/script.js"></script>
      <script>
         // Store the module ID and current lesson ID
         const moduleId = <%= Request.QueryString["moduleID"] ?? "0" %>;
         const currentLessonId = <%= Request.QueryString["lessonID"] ?? "0" %>;
         const userEmail = '<%= Session["email"] ?? "" %>';
         
         // Initialize when the document is ready
         document.addEventListener('DOMContentLoaded', function() {
            // Set up sidebar and other UI functionality
            initializeUI();
            
            // Initialize lesson completion tracking
            initializeCompletionTracking();
         });
         
         function initializeUI() {
            let profile = document.querySelector('.header .flex .profile');
            let sideBar = document.querySelector('.side-bar');
            let body = document.body;

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
         }
         
         // Initialize lesson completion tracking using localStorage
         function initializeCompletionTracking() {
            if (!moduleId) return;
            
            // Create storage key based on user and module
            const storageKey = `bulb_module_${moduleId}_${userEmail.replace('@', '_at_')}`;
            
            // Get completed lessons from localStorage
            let completedLessons = getCompletedLessons(storageKey);
            
            // Update the completed status for each lesson in the sidebar
            updateLessonCompletionUI(completedLessons);
            
            // Update the progress bar
            updateProgressBar(completedLessons);
            
            // Check if current lesson is completed
            if (currentLessonId > 0) {
               updateCompletionButton(completedLessons.includes(currentLessonId));
            }
         }
         
         // Get completed lessons from localStorage
         function getCompletedLessons(storageKey) {
            try {
               const stored = localStorage.getItem(storageKey);
               return stored ? JSON.parse(stored) : [];
            } catch (e) {
               console.error('Error reading from localStorage:', e);
               return [];
            }
         }
         
         // Update the UI to show completion status for each lesson
         function updateLessonCompletionUI(completedLessons) {
            const lessonItems = document.querySelectorAll('.lesson-list a');
            
            lessonItems.forEach(item => {
               const lessonId = parseInt(item.getAttribute('data-lesson-id'));
               const statusElement = item.querySelector('.completion-status');
               
               if (statusElement && completedLessons.includes(lessonId)) {
                  statusElement.innerHTML = '<span class="completed-badge"><i class="fas fa-check"></i> Completed</span>';
               }
            });
         }
         
         // Update the progress bar based on completed lessons
         function updateProgressBar(completedLessons) {
            const totalLessons = document.querySelectorAll('.lesson-list a').length;
            const completedCount = completedLessons.length;
            
            if (totalLessons > 0) {
               const percentage = Math.round((completedCount / totalLessons) * 100);
               document.getElementById('progressPercentage').textContent = `${percentage}%`;
               document.getElementById('progressFill').style.width = `${percentage}%`;
            }
         }
         
         // Update the mark complete button based on completion status
         function updateCompletionButton(isCompleted) {
            const button = document.getElementById('btnMarkComplete');
            
            if (button) {
               if (isCompleted) {
                  button.textContent = 'Completed ✓';
                  button.classList.add('completed');
                  button.disabled = true;
               } else {
                  button.textContent = 'Mark as Complete';
                  button.classList.remove('completed');
                  button.disabled = false;
               }
            }
         }
         
         // Mark the current lesson as complete
         function markLessonComplete() {
            if (!moduleId || !currentLessonId) return;
            
            // Create storage key based on user and module
            const storageKey = `bulb_module_${moduleId}_${userEmail.replace('@', '_at_')}`;
            
            // Get completed lessons
            let completedLessons = getCompletedLessons(storageKey);
            
            // Add current lesson if not already completed
            if (!completedLessons.includes(currentLessonId)) {
               completedLessons.push(currentLessonId);
               
               // Save back to localStorage
               try {
                  localStorage.setItem(storageKey, JSON.stringify(completedLessons));
               } catch (e) {
                  console.error('Error saving to localStorage:', e);
               }
               
               // Update UI
               updateLessonCompletionUI(completedLessons);
               updateProgressBar(completedLessons);
               updateCompletionButton(true);
               
               // Check if there's a next lesson
               const nextButton = document.getElementById('<%= btnNext.ClientID %>');
               if (nextButton && nextButton.style.display !== 'none') {
                  setTimeout(function() {
                     if (confirm('Great job! Ready to move to the next lesson?')) {
                        window.location.href = nextButton.getAttribute('href');
                     }
                  }, 500);
               }
            }
         }
      </script>
   </form>
</body>
</html>