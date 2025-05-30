<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="gradeAssignment.aspx.cs" Inherits="assignmentDraft1.gradeAssignment" %>

<!DOCTYPE html>
<html lang="en">
<head>
   <meta charset="UTF-8">
   <meta http-equiv="X-UA-Compatible" content="IE=edge">
   <meta name="viewport" content="width=device-width, initial-scale=1.0">
   <title>Grade Assignment - Bulb Admin</title>
   <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.1.2/css/all.min.css">
   <link rel="stylesheet" href="css/style.css">
   
   <style>
       :root {
           --admin-primary: #2c3e50;
           --admin-secondary: #3498db;
           --admin-success: #27ae60;
           --admin-warning: #f39c12;
           --admin-danger: #e74c3c;
           --admin-light: #ecf0f1;
           --admin-purple: #9b59b6;
       }
       
       .admin-header {
           background: linear-gradient(135deg, var(--admin-primary), var(--admin-secondary));
           color: white;
       }
       
       .admin-header .logo {
           color: white;
           font-weight: bold;
       }
       
       .grade-management {
           padding: 2rem;
       }
       
       .assignment-header {
           background: white;
           border-radius: 1rem;
           box-shadow: 0 4px 15px rgba(0,0,0,0.1);
           padding: 2rem;
           margin-bottom: 2rem;
       }
       
       .assignment-title {
           font-size: 2.5rem;
           color: var(--admin-primary);
           margin-bottom: 1rem;
       }
       
       .assignment-meta {
           display: grid;
           grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
           gap: 1.5rem;
           margin-bottom: 1.5rem;
       }
       
       .meta-item {
           text-align: center;
           padding: 1rem;
           background: #f8f9fa;
           border-radius: 0.5rem;
       }
       
       .meta-label {
           font-size: 1.1rem;
           color: #7f8c8d;
           margin-bottom: 0.5rem;
       }
       
       .meta-value {
           font-size: 1.6rem;
           font-weight: bold;
           color: var(--admin-primary);
       }
       
       .controls-section {
           display: flex;
           justify-content: space-between;
           align-items: center;
           margin-bottom: 2rem;
           flex-wrap: wrap;
           gap: 1rem;
       }
       
       .bulk-actions {
           display: flex;
           gap: 1rem;
           align-items: center;
       }
       
       .submissions-grid {
           display: grid;
           gap: 1.5rem;
       }
       
       .submission-card {
           background: white;
           border-radius: 1rem;
           box-shadow: 0 4px 15px rgba(0,0,0,0.1);
           overflow: hidden;
           transition: transform 0.3s ease;
       }
       
       .submission-card:hover {
           transform: translateY(-2px);
       }
       
       .submission-header {
           background: linear-gradient(135deg, var(--admin-secondary), #5dade2);
           color: white;
           padding: 1.5rem;
           display: flex;
           justify-content: space-between;
           align-items: center;
       }
       
       .student-info h3 {
           margin: 0;
           font-size: 1.8rem;
       }
       
       .student-info p {
           margin: 0.3rem 0 0 0;
           opacity: 0.9;
       }
       
       .submission-status {
           padding: 0.5rem 1rem;
           border-radius: 1rem;
           font-weight: bold;
           background: rgba(255,255,255,0.2);
       }
       
       .submission-body {
           padding: 1.5rem;
       }
       
       .submission-details {
           display: grid;
           grid-template-columns: 1fr 1fr;
           gap: 1rem;
           margin-bottom: 1.5rem;
       }
       
       .detail-item {
           display: flex;
           flex-direction: column;
           gap: 0.3rem;
       }
       
       .detail-label {
           font-size: 1.1rem;
           color: #7f8c8d;
           font-weight: bold;
       }
       
       .detail-value {
           font-size: 1.3rem;
           color: var(--admin-primary);
       }
       
       .submission-text {
           background: #f8f9fa;
           padding: 1rem;
           border-radius: 0.5rem;
           margin-bottom: 1.5rem;
           border-left: 4px solid var(--admin-secondary);
       }
       
       .attachment-section {
           margin-bottom: 1.5rem;
       }
       
       .attachment-item {
           display: flex;
           align-items: center;
           gap: 1rem;
           padding: 0.8rem;
           background: #e3f2fd;
           border-radius: 0.5rem;
           margin-bottom: 0.5rem;
       }
       
       .attachment-icon {
           font-size: 1.5rem;
           color: var(--admin-secondary);
       }
       
       .grading-section {
           border-top: 2px solid #eee;
           padding-top: 1.5rem;
       }
       
       .grading-form {
           display: grid;
           grid-template-columns: 1fr 1fr;
           gap: 1.5rem;
           margin-bottom: 1rem;
       }
       
       .form-group {
           display: flex;
           flex-direction: column;
           gap: 0.5rem;
       }
       
       .form-group label {
           font-weight: bold;
           color: var(--admin-primary);
       }
       
       .grade-input {
           padding: 0.8rem;
           border: 2px solid #ddd;
           border-radius: 0.5rem;
           font-size: 1.2rem;
           transition: border-color 0.3s ease;
       }
       
       .grade-input:focus {
           outline: none;
           border-color: var(--admin-secondary);
       }
       
       .feedback-section {
           margin-top: 1rem;
       }
       
       .feedback-textarea {
           width: 100%;
           min-height: 100px;
           padding: 1rem;
           border: 2px solid #ddd;
           border-radius: 0.5rem;
           font-size: 1.2rem;
           resize: vertical;
           font-family: inherit;
       }
       
       .feedback-textarea:focus {
           outline: none;
           border-color: var(--admin-secondary);
       }
       
       .action-buttons {
           display: flex;
           gap: 1rem;
           margin-top: 1rem;
       }
       
       .btn-save {
           background: var(--admin-success);
           color: white;
           padding: 0.8rem 1.5rem;
           border: none;
           border-radius: 0.5rem;
           font-size: 1.2rem;
           cursor: pointer;
           transition: background 0.3s ease;
       }
       
       .btn-save:hover {
           background: #229954;
       }
       
       .btn-clear {
           background: var(--admin-warning);
           color: white;
           padding: 0.8rem 1.5rem;
           border: none;
           border-radius: 0.5rem;
           font-size: 1.2rem;
           cursor: pointer;
           transition: background 0.3s ease;
       }
       
       .btn-clear:hover {
           background: #d68910;
       }
       
       .current-grade {
           background: var(--admin-success);
           color: white;
           padding: 1rem;
           border-radius: 0.5rem;
           text-align: center;
           margin-bottom: 1rem;
       }
       
       .grade-percentage {
           font-size: 2rem;
           font-weight: bold;
           margin-bottom: 0.5rem;
       }
       
       .grade-letter {
           font-size: 1.5rem;
           opacity: 0.9;
       }
       
       .no-submission {
           text-align: center;
           padding: 2rem;
           color: #7f8c8d;
           background: #f8f9fa;
           border-radius: 0.5rem;
           border: 2px dashed #ddd;
       }
       
       @media (max-width: 768px) {
           .grade-management {
               padding: 1rem;
           }
           
           .assignment-meta {
               grid-template-columns: 1fr;
           }
           
           .submission-details {
               grid-template-columns: 1fr;
           }
           
           .grading-form {
               grid-template-columns: 1fr;
           }
           
           .controls-section {
               flex-direction: column;
               align-items: stretch;
           }
           
           .bulk-actions {
               justify-content: center;
           }
       }
   </style>
</head>
<body>
    <form id="form1" runat="server">

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
      <a href="manageCourses.aspx"><i class="fas fa-graduation-cap"></i><span>Course Management</span></a>
      <a href="manageAssignments.aspx"><i class="fas fa-tasks"></i><span>Assignment Oversight</span></a>
      <a href="systemReports.aspx"><i class="fas fa-chart-line"></i><span>Reports & Analytics</span></a>
      <a href="systemSettings.aspx"><i class="fas fa-cog"></i><span>System Settings</span></a>
      <a href="loginWebform.aspx"><i class="fas fa-sign-out-alt"></i><span>Logout</span></a>
   </nav>
</div>

<section class="grade-management">
    <!-- Assignment Header -->
    <div class="assignment-header">
        <h1 class="assignment-title">
            <i class="fas fa-star"></i> 
            <asp:Label ID="lblAssignmentTitle" runat="server" Text="Grade Assignment"></asp:Label>
        </h1>
        
        <div class="assignment-meta">
            <div class="meta-item">
                <div class="meta-label">Course</div>
                <div class="meta-value"><asp:Label ID="lblCourseName" runat="server" Text=""></asp:Label></div>
            </div>
            <div class="meta-item">
                <div class="meta-label">Module</div>
                <div class="meta-value"><asp:Label ID="lblModuleName" runat="server" Text=""></asp:Label></div>
            </div>
            <div class="meta-item">
                <div class="meta-label">Due Date</div>
                <div class="meta-value"><asp:Label ID="lblDueDate" runat="server" Text=""></asp:Label></div>
            </div>
            <div class="meta-item">
                <div class="meta-label">Max Points</div>
                <div class="meta-value"><asp:Label ID="lblMaxPoints" runat="server" Text=""></asp:Label></div>
            </div>
            <div class="meta-item">
                <div class="meta-label">Total Submissions</div>
                <div class="meta-value"><asp:Label ID="lblTotalSubmissions" runat="server" Text="0"></asp:Label></div>
            </div>
            <div class="meta-item">
                <div class="meta-label">Graded</div>
                <div class="meta-value"><asp:Label ID="lblGradedCount" runat="server" Text="0"></asp:Label></div>
            </div>
        </div>
        
        <div style="background: #f8f9fa; padding: 1rem; border-radius: 0.5rem; border-left: 4px solid var(--admin-secondary);">
            <strong>Description:</strong>
            <asp:Label ID="lblDescription" runat="server" Text=""></asp:Label>
        </div>
    </div>

    <!-- Controls -->
    <div class="controls-section">
        <div>
            <a href="manageAssignments.aspx" class="option-btn">
                <i class="fas fa-arrow-left"></i> Back to Assignments
            </a>
        </div>
        
        <div class="bulk-actions">
            <asp:DropDownList ID="ddlBulkAction" runat="server" CssClass="box">
                <asp:ListItem Text="Bulk Actions" Value="" />
                <asp:ListItem Text="Grade All as Complete" Value="GradeComplete" />
                <asp:ListItem Text="Send Reminder" Value="SendReminder" />
            </asp:DropDownList>
            <asp:Button ID="btnApplyBulk" runat="server" Text="Apply" CssClass="inline-btn" OnClick="btnApplyBulk_Click" />
        </div>
    </div>

    <!-- Submissions List -->
    <div class="submissions-grid">
        <asp:Repeater ID="submissionRepeater" runat="server" OnItemCommand="submissionRepeater_ItemCommand">
            <ItemTemplate>
                <div class="submission-card">
                    <div class="submission-header">
                        <div class="student-info">
                            <h3><%# Eval("StudentName") %></h3>
                            <p><%# Eval("StudentEmail") %></p>
                        </div>
                        <div class="submission-status">
                            <%# Eval("SubmissionDate") != DBNull.Value ? "Submitted" : "No Submission" %>
                        </div>
                    </div>
                    
                    <div class="submission-body">
                        <%# Eval("SubmissionDate") != DBNull.Value ? GetSubmissionContent(Container.DataItem) : GetNoSubmissionContent() %>
                        
                        <!-- Grading Section -->
                        <div class="grading-section">
                            <%# Eval("PointsEarned") != DBNull.Value ? GetCurrentGradeDisplay(Eval("PointsEarned"), Eval("MaxPoints"), Eval("Feedback")) : "" %>
                            
                            <div class="grading-form">
                                <div class="form-group">
                                    <label>Points Earned</label>
                                    <asp:TextBox runat="server" CssClass="grade-input" TextMode="Number" 
                                               placeholder="Enter points" min="0" max='<%# Eval("MaxPoints") %>'
                                               ID='TextBox1' 
                                               Text='<%# Eval("PointsEarned") != DBNull.Value ? Eval("PointsEarned").ToString() : "" %>' />
                                </div>
                                <div class="form-group">
                                    <label>Grade Date</label>
                                    <asp:TextBox runat="server" CssClass="grade-input" ReadOnly="true"
                                               Text='<%# Eval("GradedDate") != DBNull.Value ? Convert.ToDateTime(Eval("GradedDate")).ToString("MMM dd, yyyy") : DateTime.Now.ToString("MMM dd, yyyy") %>' />
                                </div>
                            </div>
                            
                            <div class="feedback-section">
                                <label>Feedback</label>
                                <asp:TextBox runat="server" TextMode="MultiLine" CssClass="feedback-textarea" 
                                           placeholder="Enter feedback for the student..."
                                           ID='TextBox2'
                                           Text='<%# Eval("Feedback") != DBNull.Value ? Eval("Feedback").ToString() : "" %>' />
                            </div>
                            
                            <div class="action-buttons">
                                <asp:Button runat="server" Text="Save Grade" CssClass="btn-save" 
                                          CommandName="SaveGrade" CommandArgument='<%# Eval("UserID") %>' />
                                <asp:Button runat="server" Text="Clear Grade" CssClass="btn-clear" 
                                          CommandName="ClearGrade" CommandArgument='<%# Eval("UserID") %>'
                                          OnClientClick="return confirm('Are you sure you want to clear this grade?');" />
                            </div>
                        </div>
                    </div>
                </div>
            </ItemTemplate>
        </asp:Repeater>
    </div>

    <!-- No Submissions Message -->
    <asp:Panel ID="pnlNoSubmissions" runat="server" Visible="false">
        <div style="text-align: center; padding: 4rem; color: #7f8c8d;">
            <i class="fas fa-inbox" style="font-size: 6rem; margin-bottom: 2rem; opacity: 0.3;"></i>
            <h3>No Students Enrolled</h3>
            <p>No students are enrolled in this course yet.</p>
        </div>
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

    // Calculate percentage as user types points
    function calculatePercentage(pointsInput, maxPoints) {
        var points = parseFloat(pointsInput.value) || 0;
        var percentage = (points / maxPoints * 100).toFixed(1);

        // Update visual feedback (you can enhance this)
        pointsInput.style.borderColor = points > maxPoints ? '#e74c3c' : '#27ae60';
    }
</script>

    </form>
</body>
</html>