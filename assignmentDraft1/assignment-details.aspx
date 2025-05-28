<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="assignment-details.aspx.cs" Inherits="assignmentDraft1.assignment_details" %>

<!DOCTYPE html>
<html lang="en">
<head>
   <meta charset="UTF-8">
   <meta http-equiv="X-UA-Compatible" content="IE=edge">
   <meta name="viewport" content="width=device-width, initial-scale=1.0">
   <title>Assignment Details</title>
   <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.1.2/css/all.min.css">
   <link rel="stylesheet" href="css/style.css">
   
   <style>
       .assignment-header {
           background: var(--white);
           padding: 2rem;
           border-radius: .5rem;
           box-shadow: var(--box-shadow);
           margin-bottom: 2rem;
       }
       
       .assignment-meta {
           display: flex;
           gap: 2rem;
           margin: 1rem 0;
           flex-wrap: wrap;
       }
       
       .meta-item {
           display: flex;
           align-items: center;
           gap: 0.5rem;
       }
       
       .status-badge {
           padding: 0.5rem 1rem;
           border-radius: 2rem;
           font-weight: bold;
           font-size: 1.2rem;
       }
       
       .status-pending { background: #fff3cd; color: #856404; }
       .status-submitted { background: #d4edda; color: #155724; }
       .status-overdue { background: #f8d7da; color: #721c24; }
       .status-graded { background: #d1ecf1; color: #0c5460; }
       
       .submission-section {
           background: var(--white);
           padding: 2rem;
           border-radius: .5rem;
           box-shadow: var(--box-shadow);
           margin-bottom: 2rem;
       }
       
       .file-upload-area {
           border: 2px dashed var(--light-color);
           padding: 2rem;
           text-align: center;
           border-radius: .5rem;
           margin: 1rem 0;
       }
       
       .grade-display {
           background: var(--light-bg);
           padding: 1.5rem;
           border-radius: .5rem;
           border-left: 4px solid var(--main-color);
       }
   </style>
</head>
<body>
    <form id="form1" runat="server">

<header class="header">
   <section class="flex">
      <a href="homeWebform.aspx" class="logo">Bulb</a>
      
      <asp:Panel runat="server" CssClass="search-form">
          <asp:TextBox ID="txtSearch" runat="server" CssClass="search-input" placeholder="Search courses..." MaxLength="100" />
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
      <a href="homeWebform.aspx"><i class="fas fa-home"></i><span>home</span></a>
      <a href="about.html"><i class="fas fa-question"></i><span>about</span></a>
      <a href="courses.html"><i class="fas fa-graduation-cap"></i><span>courses</span></a>
      <a href="teachers.html"><i class="fas fa-chalkboard-user"></i><span>teachers</span></a>
      <a href="contact.html"><i class="fas fa-headset"></i><span>contact us</span></a>
      <a href="loginWebform.aspx"><span>Log out</span></a>
   </nav>
</div>

<section class="course-content">
    <!-- Assignment Header -->
    <div class="assignment-header">
        <div style="display: flex; justify-content: space-between; align-items: flex-start; margin-bottom: 1rem;">
            <h1><asp:Label ID="lblAssignmentTitle" runat="server" Text=""></asp:Label></h1>
            <asp:Label ID="lblStatusBadge" runat="server" CssClass="status-badge" Text=""></asp:Label>
        </div>
        
        <div class="assignment-meta">
            <div class="meta-item">
                <i class="fas fa-book"></i>
                <span><strong>Course:</strong> <asp:Label ID="lblCourseName" runat="server" Text=""></asp:Label></span>
            </div>
            <div class="meta-item">
                <i class="fas fa-calendar"></i>
                <span><strong>Due Date:</strong> <asp:Label ID="lblDueDate" runat="server" Text=""></asp:Label></span>
            </div>
            <div class="meta-item">
                <i class="fas fa-star"></i>
                <span><strong>Points:</strong> <asp:Label ID="lblMaxPoints" runat="server" Text=""></asp:Label></span>
            </div>
            <div class="meta-item">
                <i class="fas fa-user"></i>
                <span><strong>Instructor:</strong> <asp:Label ID="lblInstructor" runat="server" Text=""></asp:Label></span>
            </div>
        </div>
        
        <div style="margin-top: 1.5rem;">
            <h3>Assignment Description</h3>
            <asp:Label ID="lblDescription" runat="server" Text=""></asp:Label>
        </div>
        
        <asp:Panel ID="pnlInstructions" runat="server" Visible="false" style="margin-top: 1.5rem;">
            <h3>Instructions</h3>
            <asp:Label ID="lblInstructions" runat="server" Text=""></asp:Label>
        </asp:Panel>
    </div>

    <!-- Grade Display (if graded) -->
    <asp:Panel ID="pnlGradeDisplay" runat="server" Visible="false">
        <div class="grade-display">
            <h3 style="color: var(--main-color); margin-bottom: 1rem;">
                <i class="fas fa-trophy"></i> Your Grade
            </h3>
            <div style="font-size: 2rem; font-weight: bold; margin-bottom: 1rem;">
                <asp:Label ID="lblEarnedPoints" runat="server" Text=""></asp:Label> / 
                <asp:Label ID="lblTotalPoints" runat="server" Text=""></asp:Label> points
            </div>
            <asp:Panel ID="pnlFeedback" runat="server" Visible="false">
                <h4>Instructor Feedback:</h4>
                <p><asp:Label ID="lblFeedback" runat="server" Text=""></asp:Label></p>
            </asp:Panel>
            <p style="margin-top: 1rem; color: var(--light-color);">
                <i class="fas fa-clock"></i> Graded on: <asp:Label ID="lblGradedDate" runat="server" Text=""></asp:Label>
            </p>
        </div>
    </asp:Panel>

    <!-- Submission Section -->
    <div class="submission-section">
        <h2><i class="fas fa-upload"></i> Your Submission</h2>
        
        <!-- If already submitted -->
        <asp:Panel ID="pnlExistingSubmission" runat="server" Visible="false">
            <div style="background: var(--light-bg); padding: 1.5rem; border-radius: .5rem; margin: 1rem 0;">
                <h4 style="color: var(--main-color);">
                    <i class="fas fa-check-circle"></i> Submitted Successfully
                </h4>
                <p><strong>Submission Date:</strong> <asp:Label ID="lblSubmissionDate" runat="server" Text=""></asp:Label></p>
                <asp:Panel ID="pnlSubmissionText" runat="server" Visible="false" style="margin-top: 1rem;">
                    <h5>Your Text Submission:</h5>
                    <div style="background: white; padding: 1rem; border-radius: .3rem; border: 1px solid #ddd;">
                        <asp:Label ID="lblSubmittedText" runat="server" Text=""></asp:Label>
                    </div>
                </asp:Panel>
                <asp:Panel ID="pnlSubmissionFile" runat="server" Visible="false" style="margin-top: 1rem;">
                    <h5>Uploaded File:</h5>
                    <asp:LinkButton ID="lnkDownloadFile" runat="server" CssClass="inline-btn" OnClick="lnkDownloadFile_Click">
                        <i class="fas fa-download"></i> Download Submission
                    </asp:LinkButton>
                </asp:Panel>
            </div>
        </asp:Panel>

        <!-- Submission Form (if not submitted or can resubmit) -->
        <asp:Panel ID="pnlSubmissionForm" runat="server">
            <div style="margin: 1.5rem 0;">
                <label><strong>Text Submission:</strong></label>
                <asp:TextBox ID="txtSubmission" runat="server" CssClass="box" TextMode="MultiLine" 
                           Rows="8" placeholder="Enter your assignment text here..."></asp:TextBox>
            </div>

            <div style="margin: 1.5rem 0;">
                <label><strong>File Upload (Optional):</strong></label>
                <div class="file-upload-area">
                    <i class="fas fa-cloud-upload-alt" style="font-size: 3rem; color: var(--light-color);"></i>
                    <p>Choose a file to upload</p>
                    <asp:FileUpload ID="fileUpload" runat="server" CssClass="box" />
                    <p style="font-size: 1.2rem; color: var(--light-color); margin-top: 0.5rem;">
                        Supported formats: PDF, DOC, DOCX, TXT (Max 10MB)
                    </p>
                </div>
            </div>

            <asp:Panel ID="pnlSubmitButtons" runat="server">
                <div style="display: flex; gap: 1rem; margin-top: 2rem;">
                    <asp:Button ID="btnSubmit" runat="server" Text="Submit Assignment" 
                              CssClass="btn" OnClick="btnSubmit_Click" />
                    <a href="homeWebform.aspx" class="delete-btn">Cancel</a>
                </div>
            </asp:Panel>
        </asp:Panel>

        <!-- Messages -->
        <asp:Label ID="lblMessage" runat="server" Text="" style="display: block; margin-top: 1rem;"></asp:Label>
    </div>
</section>

<footer class="footer">
   &copy; copyright @ 2025 by <span>Stanley Nilam</span> | all rights reserved!
</footer>

<script src="js/script.js"></script>
    </form>
</body>
</html>