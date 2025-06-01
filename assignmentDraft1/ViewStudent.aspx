<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ViewStudent.aspx.cs" Inherits="assignmentDraft1.ViewStudent" %>

<!DOCTYPE html>
<html lang="en">
<head>
   <meta charset="UTF-8">
   <meta http-equiv="X-UA-Compatible" content="IE=edge">
   <meta name="viewport" content="width=device-width, initial-scale=1.0">
   <title>View Students - Bulb Lecturer</title>
   <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.1.2/css/all.min.css">
   <link rel="stylesheet" href="css/style.css">
   
   <style>
       :root {
           --lecturer-primary: #2c3e50;
           --lecturer-secondary: #3498db;
           --lecturer-success: #27ae60;
           --lecturer-warning: #f39c12;
           --lecturer-danger: #e74c3c;
           --lecturer-light: #ecf0f1;
       }
       
       .lecturer-header {
           background: linear-gradient(135deg, var(--lecturer-primary), var(--lecturer-secondary));
           color: white;
       }
       
       .lecturer-header .logo {
           color: white;
           font-weight: bold;
       }
       
       .student-management {
           padding: 2rem;
       }
       
       .controls-section {
           display: flex;
           justify-content: space-between;
           align-items: center;
           margin-bottom: 2rem;
           flex-wrap: wrap;
           gap: 1rem;
       }
       
       .search-filters {
           display: flex;
           gap: 1rem;
           align-items: center;
           flex-wrap: wrap;
       }
       
       .student-table {
           background: white;
           border-radius: 1rem;
           box-shadow: 0 4px 15px rgba(0,0,0,0.1);
           overflow: hidden;
       }
       
       .table-header {
           background: var(--lecturer-primary);
           color: white;
           padding: 1.5rem 2rem;
           display: flex;
           justify-content: space-between;
           align-items: center;
       }
       
       .data-table {
           width: 100%;
           border-collapse: collapse;
       }
       
       .data-table th {
           background: var(--lecturer-light);
           padding: 1.2rem;
           text-align: left;
           font-weight: bold;
           color: var(--lecturer-primary);
           border-bottom: 2px solid #ddd;
       }
       
       .data-table td {
           padding: 1.2rem;
           border-bottom: 1px solid #eee;
           vertical-align: middle;
       }
       
       .data-table tr:hover {
           background-color: #f8f9fa;
       }
       
       .student-avatar {
           width: 40px;
           height: 40px;
           border-radius: 50%;
           object-fit: cover;
       }
       
       .student-info {
           display: flex;
           align-items: center;
           gap: 1rem;
       }
       
       .student-details h4 {
           margin: 0;
           color: var(--lecturer-primary);
           font-size: 1.4rem;
       }
       
       .student-details p {
           margin: 0.2rem 0 0 0;
           color: #7f8c8d;
           font-size: 1.1rem;
       }
       
       .course-badge {
           padding: 0.5rem 1rem;
           border-radius: 2rem;
           font-size: 1.1rem;
           font-weight: bold;
           background: #d5f4e6;
           color: var(--lecturer-success);
       }
       
       .enrollment-date {
           color: #7f8c8d;
           font-size: 1.1rem;
       }
       
       .stats-summary {
           display: grid;
           grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
           gap: 1.5rem;
           margin-bottom: 2rem;
       }
       
       .stat-card {
           background: white;
           padding: 1.5rem;
           border-radius: 1rem;
           box-shadow: 0 4px 15px rgba(0,0,0,0.1);
           text-align: center;
       }
       
       .stat-number {
           font-size: 2.5rem;
           font-weight: bold;
           color: var(--lecturer-secondary);
           margin-bottom: 0.5rem;
       }
       
       .stat-label {
           color: #7f8c8d;
           font-size: 1.2rem;
       }
       
       .pagination {
           display: flex;
           justify-content: center;
           gap: 0.5rem;
           margin: 2rem 0;
       }
       
       .page-btn {
           padding: 0.8rem 1.2rem;
           border: 1px solid #ddd;
           background: white;
           color: var(--lecturer-primary);
           border-radius: 0.5rem;
           cursor: pointer;
           transition: all 0.3s ease;
       }
       
       .page-btn:hover,
       .page-btn.active {
           background: var(--lecturer-secondary);
           color: white;
           border-color: var(--lecturer-secondary);
       }
       
       @media (max-width: 768px) {
           .controls-section {
               flex-direction: column;
               align-items: stretch;
           }
           
           .search-filters {
               flex-direction: column;
           }
           
           .data-table {
               font-size: 1.2rem;
           }
           
           .data-table th,
           .data-table td {
               padding: 0.8rem;
           }
           
           .student-info {
               flex-direction: column;
               text-align: center;
               gap: 0.5rem;
           }
       }
   </style>
</head>
<body>
    <form id="form1" runat="server">

<header class="header lecturer-header">
   <section class="flex">
      <a href="lecturerDashboard.aspx" class="logo">
          <i class="fas fa-graduation-cap"></i> Bulb Lecturer
      </a>
      
      <asp:Panel runat="server" CssClass="search-form">
          <asp:TextBox ID="txtHeaderSearch" runat="server" CssClass="search-input" placeholder="Search students..." MaxLength="100" />
          <asp:LinkButton ID="btnHeaderSearch" runat="server" CssClass="inline-btn search-btn" OnClick="BtnHeaderSearch_Click">
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
         <p class="role"><asp:Label ID="lblRole" runat="server" Text="lecturer"></asp:Label></p>
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
      <p class="role"><asp:Label ID="lblSidebarRole" runat="server" Text="lecturer"></asp:Label></p>
      <a href="profile.aspx" class="btn">view profile</a>
   </div>
   <nav class="navbar">
      <a href="TeacherWebform.aspx"><i class="fas fa-home"></i><span>Dashboard</span></a>
      <a href="ViewStudent.aspx" class="active"><i class="fas fa-users"></i><span>View Students</span></a>
      <a href="assignments.aspx"><i class="fas fa-tasks"></i><span>Assignments</span></a>
      <a href="loginWebform.aspx"><i class="fas fa-sign-out-alt"></i><span>Logout</span></a>
   </nav>
</div>

<section class="student-management">
    <!-- Page Header -->
    <div style="margin-bottom: 2rem;">
        <h1 class="heading"><i class="fas fa-users"></i> My Students</h1>
        <p style="color: #7f8c8d; font-size: 1.4rem;">View students enrolled in your courses</p>
    </div>

    <!-- Statistics Summary -->
    <div class="stats-summary">
        <div class="stat-card">
            <div class="stat-number"><asp:Label ID="lblTotalStudents" runat="server" Text="0"></asp:Label></div>
            <div class="stat-label">Total Students</div>
        </div>
        <div class="stat-card">
            <div class="stat-number"><asp:Label ID="lblTotalCourses" runat="server" Text="0"></asp:Label></div>
            <div class="stat-label">My Courses</div>
        </div>
        <div class="stat-card">
            <div class="stat-number"><asp:Label ID="lblActiveEnrollments" runat="server" Text="0"></asp:Label></div>
            <div class="stat-label">Active Enrollments</div>
        </div>
    </div>

    <!-- Controls Section -->
    <div class="controls-section">
        <div class="search-filters">
            <asp:TextBox ID="txtSearch" runat="server" CssClass="box" placeholder="Search by name or email..." />
            <asp:DropDownList ID="ddlCourseFilter" runat="server" CssClass="box" AutoPostBack="true" OnSelectedIndexChanged="DdlCourseFilter_SelectedIndexChanged">
                <asp:ListItem Text="All Courses" Value="" />
            </asp:DropDownList>
            <asp:Button ID="btnSearch" runat="server" Text="Search" CssClass="inline-btn" OnClick="BtnSearch_Click" />
        </div>
    </div>

    <!-- Students Table -->
    <div class="student-table">
        <div class="table-header">
            <h3><i class="fas fa-list"></i> Student List</h3>
            <span>Total: <asp:Label ID="lblDisplayCount" runat="server" Text="0"></asp:Label> students</span>
        </div>
        
        <table class="data-table">
            <thead>
                <tr>
                    <th>Student</th>
                    <th>Course</th>
                    <th>Contact Info</th>
                    <th>Enrollment Date</th>
                </tr>
            </thead>
            <tbody>
                <asp:Repeater ID="studentRepeater" runat="server">
                    <ItemTemplate>
                        <tr>
                            <td>
                                <div class="student-info">
                                    <img src="images/default-avatar.png" alt="Student Avatar" class="student-avatar" />
                                    <div class="student-details">
                                        <h4><%# Eval("Name") %></h4>
                                        <p><%# Eval("username") %></p>
                                    </div>
                                </div>
                            </td>
                            <td>
                                <span class="course-badge">
                                    <%# Eval("CourseName") %>
                                </span>
                            </td>
                            <td>
                                <%# Eval("ContactInfo") != DBNull.Value ? Eval("ContactInfo").ToString() : "No contact info" %>
                            </td>
                            <td>
                                <span class="enrollment-date">
                                    <%# Eval("EnrollmentDate") != DBNull.Value ? Convert.ToDateTime(Eval("EnrollmentDate")).ToString("MMM dd, yyyy") : "N/A" %>
                                </span>
                            </td>
                        </tr>
                    </ItemTemplate>
                </asp:Repeater>
            </tbody>
        </table>
        
        <asp:Panel ID="pnlNoStudents" runat="server" Visible="false">
            <div style="text-align: center; padding: 4rem; color: #7f8c8d;">
                <i class="fas fa-user-graduate" style="font-size: 6rem; margin-bottom: 2rem; opacity: 0.3;"></i>
                <h3>No Students Found</h3>
                <p>No students are enrolled in your courses or match your search criteria.</p>
            </div>
        </asp:Panel>
    </div>

    <!-- Pagination -->
    <asp:Panel ID="pnlPagination" runat="server" CssClass="pagination">
        <!-- Pagination controls will be added here if needed -->
    </asp:Panel>

    <!-- Messages -->
    <asp:Label ID="lblMessage" runat="server" Text="" style="display: block; margin: 1rem 0;"></asp:Label>
</section>

<footer class="footer">
   &copy; copyright @ 2025 by <span>Stanley Nilam</span> | all rights reserved!
</footer>

<script src="js/script.js"></script>
<script>
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
