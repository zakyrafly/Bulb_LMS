<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="lessons.aspx.cs" Inherits="assignmentDraft1.lessons" %>
<!DOCTYPE html>
<html lang="en">
<head>
   <meta charset="UTF-8">
   <meta http-equiv="X-UA-Compatible" content="IE=edge">
   <meta name="viewport" content="width=device-width, initial-scale=1.0">
   <title>Video Playlist</title>
   <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.1.2/css/all.min.css">
   <link rel="stylesheet" href="css/style.css">
</head>
<body>

<!-- HEADER & SIDEBAR CODE (keep your existing header/sidebar HTML here) -->

<section class="playlist-videos">
   <h1 class="heading">Playlist Videos</h1>
   <div class="box-container">
      <asp:Repeater ID="lessonRepeater" runat="server">
         <ItemTemplate>
            <a class="box" href='<%# "watch-video.aspx?lessonID=" + Eval("LessonID") %>'>
               <i class="fas fa-play"></i>
               <img src="images/post-1-1.png" alt="">
               <h3><%# Eval("Title") %></h3>
            </a>
         </ItemTemplate>
      </asp:Repeater>
   </div>
</section>

<footer class="footer">
   &copy; copyright @ 2025 by <span>Stanley Nilam</span> | all rights reserved!
</footer>
<script src="js/script.js"></script>

</body>
</html>
