<%-- 
    Document   : header
    Created on : 28-mrt-2013, 9:10:17
    Author     : robbie
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Header</title>
        <link rel="stylesheet" href="css/normalize.css">
        <link rel="stylesheet" href="css/main.css">
    </head>
    <header id="header_wrapper">
        <a href="index.jsp"><img src="img/logo.png" alt="Logo" width="250px" style="padding-top: 10px; padding-left: 20px;"/></a>
        <div align="right">
            <input type="text" placeholder="Zoeken" name="Zoeken" size="30px" />
            &nbsp;<img src="img/zoeken.png" alt="Zoeken" width="24px" style="float: right;" />
        </div><br />
        <form id="login" method="post" action="verifylogin.jsp" id="loginForm">
            <input type="text" id="username" name="username" placeholder="Gebruikersnaam"/>
            <br/>
            <input type="password" id="password" name="password" placeholder="Paswoord" />
            <br/>
            <input type="submit" value="Log In" id="loginButton" />
        </form>
    </header>
</html>
