<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="searchResults.aspx.cs" Inherits="assignmentDraft1.searchResults" %>

<!DOCTYPE html>
<html>
<head>
    <title>Search Results</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body class="no-sidebar">
    <section>
        <div class="heading">Search Results</div>
        <div class="home-grid">
            <div class="box-container">
                <asp:Repeater ID="searchRepeater" runat="server">
                    <ItemTemplate>
                        <div class="box">
                            <div class="title"><%# Eval("ModuleTitle") %></div>
                            <div class="tutor">Lecturer: <%# Eval("LecturerName") %></div>
                            <a href='lessons.aspx?moduleID=<%# Eval("ModuleID") %>' class="inline-btn">View Lessons</a>
                        </div>
                    </ItemTemplate>
                </asp:Repeater>
                <div id="noResults" runat="server" class="no-results" visible="false">
                    No results found. Please try a different search.
                </div>
            </div>
        </div>
    </section>
</body>
</html>