<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="manageCourses.aspx.cs" Inherits="assignmentDraft1.manageCourses" %>

<!DOCTYPE html>
<html lang="en">
<head>
   <meta charset="UTF-8">
   <meta http-equiv="X-UA-Compatible" content="IE=edge">
   <meta name="viewport" content="width=device-width, initial-scale=1.0">
   <title>Course Management - Bulb Admin</title>
   <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.1.2/css/all.min.css">
   <link rel="stylesheet" href="css/style.css">
   
</head>
<body>
    <form id="form1" runat="server">

<header class="header admin-header">
   <section class="flex">
      <a href="adminDashboard.aspx" class="logo">
          <i class="fas fa-shield-alt"></i> Bulb Admin
      </a>
      
      <asp:Panel runat="server" CssClass="search-form">
          <asp:TextBox ID="txtHeaderSearch" runat="server" CssClass="search-input" placeholder="Search courses..." MaxLength="100" />
          <asp:LinkButton ID="btnHeaderSearch" runat="server" CssClass="inline-btn search-btn" OnClick="btnHeaderSearch_Click">
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
         <p class="role"><asp:Label ID="lblRole" runat="server" Text="admin"></asp:Label></p>
         <a href="profile.aspx" class="btn">view profile</a>
         <div class="flex-btn">
            <a href="loginWebform.aspx" class="option-btn">logout</a>
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
      <p class="role"><asp:Label ID="lblSidebarRole" runat="server" Text="admin"></asp:Label></p>
      <a href="profile.aspx" class="btn">view profile</a>
   </div>
   <nav class="navbar">
      <a href="adminDashboard.aspx"><i class="fas fa-tachometer-alt"></i><span>Dashboard</span></a>
      <a href="manageUsers.aspx"><i class="fas fa-users"></i><span>User Management</span></a>
      <a href="manageCourses.aspx" class="active"><i class="fas fa-graduation-cap"></i><span>Course Management</span></a>
      <a href="manageAssignments.aspx"><i class="fas fa-tasks"></i><span>Assignment Oversight</span></a>
      <a href="systemReports.aspx"><i class="fas fa-chart-line"></i><span>Reports & Analytics</span></a>
      <a href="systemSettings.aspx"><i class="fas fa-cog"></i><span>System Settings</span></a>
      <a href="loginWebform.aspx"><i class="fas fa-sign-out-alt"></i><span>Logout</span></a>
   </nav>
</div>

<section class="course-management">
    <!-- Page Header -->
    <div style="margin-bottom: 2rem;">
        <h1 class="heading"><i class="fas fa-graduation-cap"></i> Course Management</h1>
        <p style="color: #7f8c8d; font-size: 1.4rem;">Manage courses, enrollments, and course content</p>
    </div>

    <!-- Statistics Summary -->
    <div class="stats-summary">
        <div class="stat-card">
            <div class="stat-number"><asp:Label ID="lblTotalCourses" runat="server" Text="0"></asp:Label></div>
            <div class="stat-label">Total Courses</div>
        </div>
        <div class="stat-card">
            <div class="stat-number"><asp:Label ID="lblTotalStudents" runat="server" Text="0"></asp:Label></div>
            <div class="stat-label">Enrolled Students</div>
        </div>
        <div class="stat-card">
            <div class="stat-number"><asp:Label ID="lblTotalModules" runat="server" Text="0"></asp:Label></div>
            <div class="stat-label">Total Modules</div>
        </div>
        <div class="stat-card">
            <div class="stat-number"><asp:Label ID="lblActiveLecturers" runat="server" Text="0"></asp:Label></div>
            <div class="stat-label">Active Lecturers</div>
        </div>
    </div>

    <!-- Controls Section -->
    <div class="controls-section">
        <div class="search-filters">
            <asp:TextBox ID="txtSearch" runat="server" CssClass="box" placeholder="Search courses..." />
            <asp:DropDownList ID="ddlCategoryFilter" runat="server" CssClass="box" AutoPostBack="true" OnSelectedIndexChanged="ddlCategoryFilter_SelectedIndexChanged">
                <asp:ListItem Text="All Categories" Value="" />
            </asp:DropDownList>
            <asp:Button ID="btnSearch" runat="server" Text="Search" CssClass="inline-btn" OnClick="btnSearch_Click" />
        </div>
        
        <button type="button" class="btn" onclick="openAddCourseModal()">
            <i class="fas fa-plus"></i> Add New Course
        </button>
    </div>

    <!-- Courses Grid -->
    <div class="courses-grid">
        <asp:Repeater ID="courseRepeater" runat="server" OnItemCommand="courseRepeater_ItemCommand">
            <ItemTemplate>
                <div class="course-card">
                    <div class="course-header">
                        <div class="course-title"><%# Eval("CourseName") %></div>
                        <div class="course-category"><%# Eval("Category") %></div>
                    </div>
                    <div class="course-body">
                        <div class="course-description">
                            <%# Eval("Description") %>
                        </div>
                        
                        <div class="course-stats">
                            <div class="stat-item">
                                <div class="stat-item-number"><%# Eval("StudentCount") %></div>
                                <div class="stat-item-label">Students</div>
                            </div>
                            <div class="stat-item">
                                <div class="stat-item-number"><%# Eval("ModuleCount") %></div>
                                <div class="stat-item-label">Modules</div>
                            </div>
                            <div class="stat-item">
                                <div class="stat-item-number"><%# Eval("AssignmentCount") %></div>
                                <div class="stat-item-label">Assignments</div>
                            </div>
                        </div>
                        
                        <div class="course-actions">
                            <asp:LinkButton runat="server" CssClass="action-btn btn-view" 
                                          CommandName="ViewDetails" CommandArgument='<%# Eval("CourseID") %>'>
                                <i class="fas fa-eye"></i> View Details
                            </asp:LinkButton>
                            <asp:LinkButton runat="server" CssClass="action-btn btn-edit" 
                                          CommandName="Edit" CommandArgument='<%# Eval("CourseID") %>'>
                                <i class="fas fa-edit"></i>
                            </asp:LinkButton>
                            <asp:LinkButton runat="server" CssClass="action-btn btn-delete" 
                                          CommandName="Delete" CommandArgument='<%# Eval("CourseID") %>'
                                          OnClientClick="return confirm('Are you sure you want to delete this course? This will also delete all associated modules and assignments.');">
                                <i class="fas fa-trash"></i>
                            </asp:LinkButton>
                        </div>
                    </div>
                </div>
            </ItemTemplate>
        </asp:Repeater>
    </div>

    <!-- No Courses Message -->
    <asp:Panel ID="pnlNoCourses" runat="server" Visible="false">
        <div style="text-align: center; padding: 4rem; color: #7f8c8d;">
            <i class="fas fa-graduation-cap" style="font-size: 6rem; margin-bottom: 2rem; opacity: 0.3;"></i>
            <h3>No Courses Found</h3>
            <p>No courses match your current search criteria.</p>
            <button type="button" class="btn" onclick="openAddCourseModal()">
                <i class="fas fa-plus"></i> Create First Course
            </button>
        </div>
    </asp:Panel>

    <!-- Messages -->
    <asp:Label ID="lblMessage" runat="server" Text="" style="display: block; margin: 1rem 0;"></asp:Label>
</section>

<!-- Add/Edit Course Modal -->
<div id="courseModal" class="modal">
    <div class="modal-content">
        <div class="modal-header">
            <h2 id="modalTitle">Add New Course</h2>
            <span class="close" onclick="closeCourseModal()">&times;</span>
        </div>
        <div class="modal-body">
            <asp:HiddenField ID="hfCourseID" runat="server" />
            
            <div class="form-group">
                <label>Course Name <span class="required">*</span></label>
                <asp:TextBox ID="txtCourseName" runat="server" CssClass="box" MaxLength="100" placeholder="Enter course name" />
            </div>
            
            <div class="form-group">
                <label>Category <span class="required">*</span></label>
                <asp:TextBox ID="txtCategory" runat="server" CssClass="box" MaxLength="50" placeholder="e.g., Programming, Design" />
            </div>
            
            <div class="form-group full-width">
                <label>Description <span class="required">*</span></label>
                <asp:TextBox ID="txtDescription" runat="server" CssClass="box" TextMode="MultiLine" Rows="4" 
                           placeholder="Enter detailed course description" />
            </div>
            
            <div style="display: flex; gap: 1rem; margin-top: 2rem; justify-content: flex-end;">
                <button type="button" class="option-btn" onclick="closeCourseModal()">Cancel</button>
                <asp:Button ID="btnSaveCourse" runat="server" Text="Save Course" CssClass="btn" OnClick="btnSaveCourse_Click" />
            </div>
        </div>
    </div>
</div>

<!-- Course Details Modal -->
<div id="detailsModal" class="modal">
    <div class="modal-content">
        <div class="modal-header">
            <h2>Course Details</h2>
            <span class="close" onclick="closeDetailsModal()">&times;</span>
        </div>
        <div class="modal-body">
            <div class="enrollment-section">
                <div class="enrollment-header">
                    <h3><i class="fas fa-users"></i> Enrolled Students</h3>
                    <span>Total: <asp:Label ID="lblEnrolledCount" runat="server" Text="0"></asp:Label></span>
                </div>
                <div class="enrollment-list">
                    <asp:Repeater ID="enrollmentRepeater" runat="server">
                        <ItemTemplate>
                            <div class="student-item">
                                <div class="student-info">
                                    <h4><%# Eval("Name") %></h4>
                                    <p><%# Eval("username") %></p>
                                </div>
                                <div>
                                    <span style="color: #7f8c8d;">Enrolled: <%# Eval("EnrollmentDate", "{0:MMM dd, yyyy}") %></span>
                                </div>
                            </div>
                        </ItemTemplate>
                    </asp:Repeater>
                    
                    <asp:Panel ID="pnlNoEnrollments" runat="server" Visible="false">
                        <div style="text-align: center; padding: 2rem; color: #7f8c8d;">
                            <i class="fas fa-user-graduate" style="font-size: 4rem; margin-bottom: 1rem; opacity: 0.3;"></i>
                            <p>No students enrolled in this course yet.</p>
                        </div>
                    </asp:Panel>
                </div>
            </div>
        </div>
    </div>
</div>

<footer class="footer">
   &copy; copyright @ 2025 by <span>Stanley Nilam</span> | all rights reserved!
</footer>

<script src="js/script.js"></script>
<script>
    function openAddCourseModal() {
        document.getElementById('modalTitle').innerText = 'Add New Course';
        document.getElementById('<%= hfCourseID.ClientID %>').value = '';
        document.getElementById('<%= btnSaveCourse.ClientID %>').innerText = 'Save Course';
        clearCourseForm();
        document.getElementById('courseModal').style.display = 'block';
    }
    
    function openEditCourseModal(courseId, courseName, category, description) {
        document.getElementById('modalTitle').innerText = 'Edit Course';
        document.getElementById('<%= hfCourseID.ClientID %>').value = courseId;
        document.getElementById('<%= btnSaveCourse.ClientID %>').innerText = 'Update Course';
        
        document.getElementById('<%= txtCourseName.ClientID %>').value = courseName;
        document.getElementById('<%= txtCategory.ClientID %>').value = category;
        document.getElementById('<%= txtDescription.ClientID %>').value = description;
        
        document.getElementById('courseModal').style.display = 'block';
    }
    
    function closeCourseModal() {
        document.getElementById('courseModal').style.display = 'none';
        clearCourseForm();
    }
    
    function closeDetailsModal() {
        document.getElementById('detailsModal').style.display = 'none';
    }
    
    function clearCourseForm() {
        document.getElementById('<%= txtCourseName.ClientID %>').value = '';
        document.getElementById('<%= txtCategory.ClientID %>').value = '';
        document.getElementById('<%= txtDescription.ClientID %>').value = '';
    }
    
    // Close modals when clicking outside
    window.onclick = function(event) {
        var courseModal = document.getElementById('courseModal');
        var detailsModal = document.getElementById('detailsModal');
        
        if (event.target == courseModal) {
            closeCourseModal();
        }
        if (event.target == detailsModal) {
            closeDetailsModal();
        }
    }
    
    // Auto-hide messages after 5 seconds
    window.onload = function() {
        var messageLabel = document.getElementById('<%= lblMessage.ClientID %>');
        if (messageLabel && messageLabel.innerText.trim() !== '') {
            setTimeout(function () {
                messageLabel.style.display = 'none';
            }, 5000);
        }
    }
</script>

    </form>
</body>
</html>