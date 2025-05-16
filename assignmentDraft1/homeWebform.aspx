<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="homeWebform.aspx.cs" Inherits="assignmentDraft1.homeWebform" %>

<!DOCTYPE html>
<html lang="en">
<head>
   <meta charset="UTF-8">
   <meta http-equiv="X-UA-Compatible" content="IE=edge">
   <meta name="viewport" content="width=device-width, initial-scale=1.0">
   <title>home</title>
   <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.1.2/css/all.min.css">
   <link rel="stylesheet" href="css/style.css">

</head>
<body>
    <form id="form1" runat="server">

<header class="header">
   
   <section class="flex">

      <a href="home.html" class="logo">Bulb</a>

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
   <h3 class="name"><asp:Label ID="lblName" runat="server" Text="Zaky Rafly"></asp:Label></h3>
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
      <h3 class="name"><asp:Label ID="lblSidebarName" runat="server" Text="Zaky Rafly"></asp:Label></h3>
      <p class="role"><asp:Label ID="lblSidebarRole" runat="server" Text="student"></asp:Label></p>
      <a href="profile.html" class="btn">view profile</a>
   </div>

   <nav class="navbar">
      <a href="home.html"><i class="fas fa-home"></i><span>home</span></a>
      <a href="about.html"><i class="fas fa-question"></i><span>about</span></a>
      <a href="courses.html"><i class="fas fa-graduation-cap"></i><span>courses</span></a>
      <a href="teachers.html"><i class="fas fa-chalkboard-user"></i><span>teachers</span></a>
      <a href="contact.html"><i class="fas fa-headset"></i><span>contact us</span></a>
      <a href="loginWebform.aspx"><span>Log out</span></a>
   </nav>

</div>

<section class="home-grid">

   <h1 class="heading">Timeline</h1>

<div class="box timeline-box">
   <div class="timeline-filters">
      <select class="box select">
         <option>All</option>
         <option>Overdue</option>
         <option>Due date</option>
         <option>Next 7 days</option>
         <option>Next 30 days</option>
         <option>Next 3 months</option>
         <option>Next 6 months</option>
      </select>

      <select class="box select">
         <option>Sort by dates</option>
         <option>Sort by courses</option>
      </select>

      <input type="text" class="box search-input" placeholder="Search by activity type or name" oninput="handleSearchPlaceholder(this)">

   </div>

   <p class="updated-date" id="current-date">Updated: </p>

   <div class="assignment-card box">
      <h3 class="title">Assignment: Final Project Report</h3>
      <p class="likes">Course: <span>Web Development</span></p>
      <p class="likes">Due: <span>April 30, 2025</span></p>
      <a href="#" class="inline-btn">View Assignment</a>
   </div>
</div>

</section>






<h1 class="heading">My courses</h1>

<section class="courses">
    <div class="box-container">
        <asp:Repeater ID="courseContentRepeater" runat="server">
            <ItemTemplate>
                <div class="box">
                    <div class="tutor">
                        <img src="images/default-avatar.png" alt="Lecturer Image" />
                        <div>
                            <h3><%# Eval("LecturerName") %></h3>
                            <span>Lecturer</span>
                        </div>
                    </div>
                    <div class="title">
                        <a href='lessons.aspx?moduleID=<%# Eval("ModuleID") %>'>
                            <%# Eval("ModuleTitle") %>
                        </a>
                    </div>
                </div>
            </ItemTemplate>
        </asp:Repeater>
    </div>
</section>



   <div class="box-container">

      <div class="box">
         <div class="tutor">
            <img src="images/pic-2.jpg" alt="">
            <div class="info">
               <h3>john deo</h3>
               <span>21-10-2022</span>
            </div>
         </div>
         <div class="thumb">
            <img src="images/thumb-1.png" alt="">
            <span>10 videos</span>
         </div>
         <h3 class="title">complete HTML tutorial</h3>
         <a href="playlist.html" class="inline-btn">view playlist</a>
      </div>

      <div class="box">
         <div class="tutor">
            <img src="images/pic-3.jpg" alt="">
            <div class="info">
               <h3>john deo</h3>
               <span>21-10-2022</span>
            </div>
         </div>
         <div class="thumb">
            <img src="images/thumb-2.png" alt="">
            <span>10 videos</span>
         </div>
         <h3 class="title">complete CSS tutorial</h3>
         <a href="playlist.html" class="inline-btn">view playlist</a>
      </div>

      <div class="box">
         <div class="tutor">
            <img src="images/pic-4.jpg" alt="">
            <div class="info">
               <h3>john deo</h3>
               <span>21-10-2022</span>
            </div>
         </div>
         <div class="thumb">
            <img src="images/thumb-3.png" alt="">
            <span>10 videos</span>
         </div>
         <h3 class="title">complete JS tutorial</h3>
         <a href="playlist.html" class="inline-btn">view playlist</a>
      </div>

      <div class="box">
         <div class="tutor">
            <img src="images/pic-5.jpg" alt="">
            <div class="info">
               <h3>john deo</h3>
               <span>21-10-2022</span>
            </div>
         </div>
         <div class="thumb">
            <img src="images/thumb-4.png" alt="">
            <span>10 videos</span>
         </div>
         <h3 class="title">complete Boostrap tutorial</h3>
         <a href="playlist.html" class="inline-btn">view playlist</a>
      </div>

      <div class="box">
         <div class="tutor">
            <img src="images/pic-6.jpg" alt="">
            <div class="info">
               <h3>john deo</h3>
               <span>21-10-2022</span>
            </div>
         </div>
         <div class="thumb">
            <img src="images/thumb-5.png" alt="">
            <span>10 videos</span>
         </div>
         <h3 class="title">complete JQuery tutorial</h3>
         <a href="playlist.html" class="inline-btn">view playlist</a>
      </div>

      <div class="box">
         <div class="tutor">
            <img src="images/pic-7.jpg" alt="">
            <div class="info">
               <h3>john deo</h3>
               <span>21-10-2022</span>
            </div>
         </div>
         <div class="thumb">
            <img src="images/thumb-6.png" alt="">
            <span>10 videos</span>
         </div>
         <h3 class="title">complete SASS tutorial</h3>
         <a href="playlist.html" class="inline-btn">view playlist</a>
      </div>

   </div>

   <div class="more-btn">
      <a href="courses.html" class="inline-option-btn">view all courses</a>
   </div>






<footer class="footer">
   &copy; copyright @ 2025 by <span>Stanley Nilam</span> | all rights reserved!
</footer>
<script src="js/script.js"></script>

    </form>
</body>
</html>