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
   </style>
</head>
<body class="no-sidebar login-page">

<div class="page-wrapper">

   <header class="header">
      <section class="flex">
         <a href="home.html" class="logo">Bulb</a>
      </section>
   </header>

   <section class="form-container">
      <form action="" method="post" enctype="multipart/form-data">
         <h3>Login Now</h3>
         <p>Your Email <span>*</span></p>
         <input type="email" name="email" placeholder="Enter your email" required maxlength="50" class="box">
         <p>Your Password <span>*</span></p>
         <input type="password" name="pass" placeholder="Enter your password" required maxlength="20" class="box">
         <input type="submit" value="Login New" name="submit" class="btn">
      </form>
   </section>

   <footer class="footer">
      &copy; copyright @ 2025 by <span>Stanley Nilam</span> | all rights reserved!
   </footer>

</div>


<script src="js/script.js"></script>

</body>
</html>
