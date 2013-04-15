<%-- 
    Document   : header
    Created on : 28-mrt-2013, 9:10:17
    Author     : robbie, Steven
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
    <header id="hoofding_omslag">
        <a href="index.jsp"><img src="<%= request.getContextPath() %>/img/header/logo.png" alt="Logo" width="250" style="padding-top: 10px; padding-left: 20px;"/></a>
        <div align="right">
            <input type="search" placeholder="Zoeken" name="Zoeken" size="30" />
            &nbsp;<img src="<%= request.getContextPath() %>/img/header/zoeken.png" alt="Zoeken" width="24" style="float: right;" />
        </div><br />
        <%
            beans.gegevensGebruiker gebruiker = (beans.gegevensGebruiker) session.getAttribute("gegevensGebruiker");

            if(gebruiker != null)
            {
                String gebruikersnaam = gebruiker.getGebruikersnaam();
        %>
        <div id="OpmaakIngelogd">
                <div class="TekstVet">Hallo <%=gebruikersnaam%></div>
                <a href="profiel.jsp">Profiel Aanpassen</a> | <a href="uitgelogd.jsp">Uitloggen</a>
        </div>
        <%  }
            else
            {
        %>
                <form id="login" method="post" action="inlog.jsp">
                    <input type="text" id="username" name="gebruikersnaam" placeholder="Gebruikersnaam" required />
                    <br/>
                    <input type="password" id="password" name="paswoord" placeholder="Paswoord" required />
                    <br/>
                    <input type="submit" value="Log In" id="loginButton"/>
                </form>
        <%  }%>
    </header>
</html>