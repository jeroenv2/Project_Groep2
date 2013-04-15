<%-- 
    Document   : navigation
    Created on : 28-mrt-2013, 9:20:35
    Author     : robbie, Steven
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Navigatie</title>
    </head>
    <body>
        <nav id="navigatie_omslag">
            <%
                String pageName = extractPageNameFromURLString(request.getRequestURI()).toString();
                beans.gegevensGebruiker gebruiker = (beans.gegevensGebruiker) session.getAttribute("gegevensGebruiker");
                
                if (pageName.equals("index") || pageName.equals("") || pageName.equals("inlog") || pageName.equals("uitgelogd")) { %>
                    <a href="/"><img src="img/header/home_selected.png" alt="Home" height="33" /></a> 
                    <a href="festivals.jsp"><img src="img/header/festivals.png" alt="Festivals" height="33" /></a>
                    <a href="groepen.jsp"><img src="img/header/groepen.png" alt="Groepen" height="33" /></a>
                <% } else if (pageName.equals("festivals") || pageName.equals("festivals_filter")) { %>
                    <a href="index.jsp"><img src="img/header/home.png" alt="Home" height="33" /></a> 
                    <a href="festivals.jsp"><img src="img/header/festivals_selected.png" alt="Festivals" height="33" /></a>
                    <a href="groepen.jsp"><img src="img/header/groepen.png" alt="Groepen" height="33" /></a>
                <%} else if (pageName.equals("groepen") || pageName.equals("groepen_filter") || pageName.equals("groepen_details")) { %>
                    <a href="index.jsp"><img src="img/header/home.png" alt="Home" height="33" /></a> 
                    <a href="festivals.jsp"><img src="img/header/festivals.png" alt="Festivals" height="33" /></a>
                    <a href="groepen.jsp"><img src="img/header/groepen_selected.png" alt="Groepen" height="33" /></a>
                <%} else if (pageName.equals("profiel") || pageName.equals("profiel_verwerking")) { %>
                    <a href="index.jsp"><img src="img/header/home.png" alt="Home" height="33" /></a> 
                    <a href="festivals.jsp"><img src="img/header/festivals.png" alt="Festivals" height="33" /></a>
                    <a href="groepen.jsp"><img src="img/header/groepen.png" alt="Groepen" height="33" /></a>
                    <%if(gebruiker != null){ //Voor het geval een gebruiker naar een pagina wil gaan zonder ingelogd te zijn (inlog vereist)
                    %>
                            <a href="#"><img src="img/header/admin_Selected.png" alt="Admin" height="33" /></a>
                <%} }
                if(gebruiker != null && !pageName.equals("profiel") && !pageName.equals("profiel_verwerking")) 
                {%>
                    <a href="#"><img src="img/header/admin.png" alt="Admin" height="33" /></a>
                <%}%>
        </nav>
        <%!
            public static String extractPageNameFromURLString(String urlString) {
                if (urlString == null) {
                    return null;
                }
                int lastSlash = urlString.lastIndexOf("/");
                //if (lastSlash==-1) lastSlash = 0;
                String pageAndExtensions = urlString.substring(lastSlash + 1);
                int lastQuestion = pageAndExtensions.indexOf(".");
                if (lastQuestion == -1) {
                    lastQuestion = pageAndExtensions.length();
                }
                String result = pageAndExtensions.substring(0, lastQuestion);
                return result;
            }
        %>
    </body>
</html>