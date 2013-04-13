<%-- 
    Document   : header
    Created on : 28-mrt-2013, 9:10:17
    Author     : robbie
--%>

<%@page import="beans.gegevensGebruiker"%>
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
        <a href="index.jsp"><img src="img/header/logo.png" alt="Logo" width="250" style="padding-top: 10px; padding-left: 20px;"/></a>
        <div align="right">
            <input type="text" placeholder="Zoeken" name="Zoeken" size="30" />
            &nbsp;<img src="img/header/zoeken.png" alt="Zoeken" width="24" style="float: right;" />
        </div><br />
        
        <%
            String gebruikersnaam = %>${gegGebruiker.getGebruikersnaam}<%;%>
            if(gebruikersnaam != null)
            {%>
                Hallo <%=gebruikersnaam%><br />
                <a href="profiel.jsp">Profiel</a>
            <%}
            else
            {%>
                <form id="login" method="post" action="inlog">
                    <input type="text" id="username" name="gebruikersnaam" placeholder="Gebruikersnaam" required />
                    <br/>
                    <input type="password" id="password" name="paswoord" placeholder="Paswoord" required />
                    <br/>
                    <input type="submit" value="Log In" id="loginButton"/>
                </form>
            <%}%>
    </header>
</html>