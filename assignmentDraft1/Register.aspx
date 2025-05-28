<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Register.aspx.cs" Inherits="assignmentDraft1.Register" %>

<!DOCTYPE html>
<html lang="en">
<head>
   <meta charset="UTF-8">
   <meta http-equiv="X-UA-Compatible" content="IE=edge">
   <meta name="viewport" content="width=device-width, initial-scale=1.0">
   <title>Register</title>
   <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.1.2/css/all.min.css">
   <link rel="stylesheet" href="css/style.css">

   <style>
      html, body {
         height: 100%;
         margin: 0;
         padding: 0;
      }

      .page-wrapper {
         display: flex;
         flex-direction: column;
         min-height: 100vh;
      }

      .form-container {
         flex: 1;
         display: flex;
         align-items: center;
         justify-content: center;
      }

      body.no-sidebar {
         padding-left: 0;
      }

      body.no-sidebar .footer {
         padding-left: 0;
         text-align: center;
      }
      
      .course-section {
         display: none;
      }
      
      .course-section.show {
         display: block;
      }
   </style>
</head>
<body class="no-sidebar login-page">

<div class="page-wrapper">

   <header class="header">
      <section class="flex">
         <a href="home.aspx" class="logo">Bulb</a>
      </section>
   </header>

   <section class="form-container">
      <form id="form1" runat="server">
         <h3>Register Now</h3>

         <p>Full Name <span>*</span></p>
         <asp:TextBox ID="txtName" runat="server" CssClass="box" MaxLength="100" Placeholder="Enter your full name"></asp:TextBox>

         <p>E-mail/Username <span>*</span></p>
         <asp:TextBox ID="txtUsername" runat="server" CssClass="box" MaxLength="100" Placeholder="Enter your E-mail"></asp:TextBox>

         <p>Password <span>*</span></p>
         <asp:TextBox ID="txtPassword" runat="server" CssClass="box" TextMode="Password" MaxLength="255" Placeholder="Create a password"></asp:TextBox>

         <p>Role <span>*</span></p>
         <asp:DropDownList ID="ddlRole" runat="server" CssClass="box" onchange="toggleCourseSection()">
            <asp:ListItem>Student</asp:ListItem>
            <asp:ListItem>Lecturer</asp:ListItem>
         </asp:DropDownList>

         <div id="courseSection" class="course-section show">
             <p id="courseLabel">Course <span>*</span></p>
             <asp:DropDownList ID="ddlCourse" runat="server" CssClass="box" AppendDataBoundItems="true">
                 <asp:ListItem Text="-- Select a course --" Value="" />
             </asp:DropDownList>
         </div>

         <p id="contactLabel">Contact Info</p>
         <asp:TextBox ID="txtContact" runat="server" CssClass="box" TextMode="MultiLine" Rows="3" Placeholder="Optional contact details"></asp:TextBox>

         <asp:Button ID="btnRegister" runat="server" Text="Register Now" CssClass="btn" OnClick="btnRegister_Click" />
         <asp:Label ID="lblMessage" runat="server" ForeColor="Red"></asp:Label>
         <br />
         <asp:LinkButton ID="LinkButton1" runat="server" Font-Size="Small" OnClick="LinkButton1_Click">Go back to Login Page</asp:LinkButton>
      </form>
   </section>

   <footer class="footer">
      &copy; copyright @ 2025 by <span>Stanley Nilam</span> | all rights reserved!
   </footer>

</div>

<script src="js/script.js"></script>
<script>
    function toggleCourseSection() {
        var roleSelect = document.getElementById('<%= ddlRole.ClientID %>');
    var courseSection = document.getElementById('courseSection');
    var courseLabel = document.getElementById('courseLabel');
    var contactLabel = document.getElementById('contactLabel');

    if (roleSelect.value === 'Student') {
        courseSection.classList.add('show');
        courseLabel.innerHTML = 'Course <span>*</span>';
        contactLabel.innerText = 'Contact Info';
        document.getElementById('<%= txtContact.ClientID %>').placeholder = 'Optional contact details';
    } else if (roleSelect.value === 'Lecturer') {
        courseSection.classList.add('show');
        courseLabel.innerHTML = 'Course to Teach <span>*</span>';
        contactLabel.innerText = 'Department';
        document.getElementById('<%= txtContact.ClientID %>').placeholder = 'Enter your department (optional)';
        }
    }

    // Initialize on page load
    window.onload = function () {
        toggleCourseSection();
    };
</script>

</body>
</html>