<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="searchResults.aspx.cs" Inherits="assignmentDraft1.searchResults" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Search Results</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.1.2/css/all.min.css">
    <link rel="stylesheet" href="css/style.css">
</head>
    <form id="form1" runat="server">
        <header class="header">
            <section class="flex">
                <a href="homeWebform.aspx" class="logo">Bulb</a>
                <asp:Panel runat="server" CssClass="search-form">
                    <asp:TextBox ID="txtSearch" runat="server" CssClass="search-input" placeholder="Search courses..." MaxLength="100" />
                    <asp:Button ID="btnSearch" runat="server" CssClass="fas fa-search" Text="🔍" UseSubmitBehavior="false" />
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
        <section class="courses">
            <h1 class="heading">Search Results</h1>
            <div class="box-container">
                <asp:Repeater ID="searchRepeater" runat="server">
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
                <asp:Panel ID="noResultsPanel" runat="server" CssClass="no-results" Visible="false">
                    No results found. Please try a different search.
                </asp:Panel>
            </div>
        </section>
        <footer class="footer">
            &copy; copyright @ 2025 by <span>Stanley Nilam</span> | all rights reserved!
        </footer>
        <script src="js/script.js"></script>
    </form>
</html>