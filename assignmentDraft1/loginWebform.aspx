<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="loginWebform.aspx.cs" Inherits="assignmentDraft1.WebForm1" %>

<!DOCTYPE html>
<html lang="en">
<head>
   <meta charset="UTF-8">
   <meta http-equiv="X-UA-Compatible" content="IE=edge">
   <meta name="viewport" content="width=device-width, initial-scale=1.0">
   <title>Login</title>
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
         min-height: 100vhz
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
   </style>
</head>
<body class="no-sidebar login-page">

<div class="page-wrapper">

   <header class="header">
      <section class="flex">
         <a href="home.aspx" class="logo">Bulb</a>&nbsp;
      </section>
   </header>

   <section class="form-container">
      <form id="form1" runat="server">
         <h3>Login Now</h3>
         <p>Your Email <span>*</span></p>
         <asp:TextBox ID="txtEmail" runat="server" CssClass="box" TextMode="Email" MaxLength="50" Placeholder="Enter your email"></asp:TextBox>

         <p>Your Password <span>*</span></p>
         <asp:TextBox ID="txtPassword" runat="server" CssClass="box" TextMode="Password" MaxLength="20" Placeholder="Enter your password"></asp:TextBox>

         <asp:Button ID="btnLogin" runat="server" Text="Login Now" CssClass="btn" OnClick="btnLogin_Click" />
         <asp:Label ID="lblMessage" runat="server" ForeColor="Red"></asp:Label>
          <br />
          <asp:LinkButton ID="LinkButton1" runat="server" Font-Size="Small" OnClick="LinkButton1_Click1">Don&#39;t have an account? Register</asp:LinkButton>
      </form>
   </section>

   <footer class="footer">
      &copy; copyright @ 2025 by <span>Stanley Nilam</span> | all rights reserved!
   </footer>

</div>

<script src="js/script.js"></script>

    <p>
        &nbsp;</p>

</body>
</html>
