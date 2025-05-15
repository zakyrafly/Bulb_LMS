<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="searchResults.aspx.cs" Inherits="assignmentDraft1.searchResults" %>

<!DOCTYPE html>
<html>
<head>
    <title>Search Results</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>

<h1>Search Results</h1>

<asp:Repeater ID="searchRepeater" runat="server">
    <ItemTemplate>
        <div class="box">
            <h3><%# Eval("ModuleTitle") %></h3>
          <p>Lecturer: <%# Eval("LecturerName") %></p>
            <a href='lessons.aspx?moduleID=<%# Eval("ModuleID") %>' class="inline-btn">View Lessons</a>
        </div>
    </ItemTemplate>
</asp:Repeater>

</body>
</html>
