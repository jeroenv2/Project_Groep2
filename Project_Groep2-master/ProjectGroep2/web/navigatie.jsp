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
                String strPaginaNaam = leidPaginaNaamAfVanUrl(request.getRequestURI()).toString();
                beans.gegevensGebruiker gebruiker = (beans.gegevensGebruiker) session.getAttribute("gegevensGebruiker");
                
                if (strPaginaNaam.equals("index") || strPaginaNaam.equals("") || strPaginaNaam.equals("inlog") || strPaginaNaam.equals("uitgelogd")) { %>
                    <a href="index.jsp"><img src="img/header/home_selected.png" alt="Home" height="33" /></a> 
                    <% if(gebruiker == null){%>
                    <a href="festivals.jsp"><img src="img/header/festivals.png" alt="Festivals" height="33" /></a>
                    <a href="groepen.jsp"><img src="img/header/groepen.png" alt="Groepen" height="33" /></a>
                    <%} else {%>
                    <a href="festival_aanpassen.jsp"><img src="img/header/festivals.png" alt="Festivals" height="33" /></a>
                    <a href="groepen_aanpassen.jsp"><img src="img/header/groepen.png" alt="Groepen" height="33" /></a>
                    <% } %>
               <% } else if (strPaginaNaam.contains("festival") || strPaginaNaam.contains("verwijderen_resultaat")) { %>
                    <a href="index.jsp"><img src="img/header/home.png" alt="Home" height="33" /></a> 
                    <% if(gebruiker == null){%>
                    <a href="festivals.jsp"><img src="img/header/festivals_selected.png" alt="Festivals" height="33" /></a>
                    <a href="groepen.jsp"><img src="img/header/groepen.png" alt="Groepen" height="33" /></a>
                    <%} else {%>
                    <a href="festival_aanpassen.jsp"><img src="img/header/festivals_selected.png" alt="Festivals" height="33" /></a>
                    <a href="groepen_aanpassen.jsp"><img src="img/header/groepen.png" alt="Groepen" height="33" /></a>
                    <% } %>
              <%} else if (strPaginaNaam.contains("groep")) { %>
                    <a href="index.jsp"><img src="img/header/home.png" alt="Home" height="33" /></a> 
                    <% if(gebruiker == null){%>
                    <a href="festivals.jsp"><img src="img/header/festivals.png" alt="Festivals" height="33" /></a>
                    <a href="groepen.jsp"><img src="img/header/groepen_selected.png" alt="Groepen" height="33" /></a>
                    <%} else {%>
                    <a href="festival_aanpassen.jsp"><img src="img/header/festivals.png" alt="Festivals" height="33" /></a>
                    <a href="groepen_aanpassen.jsp"><img src="img/header/groepen_selected.png" alt="Groepen" height="33" /></a>
                    <% } %>                   
              <%} else if (strPaginaNaam.contains("administrator") || strPaginaNaam.contains("account_aanmaken")) { %>
                    <a href="index.jsp"><img src="img/header/home.png" alt="Home" height="33" /></a> 
                    <% if(gebruiker == null){%>
                    <a href="festivals.jsp"><img src="img/header/festivals.png" alt="Festivals" height="33" /></a>
                    <a href="groepen.jsp"><img src="img/header/groepen.png" alt="Groepen" height="33" /></a>
                    <%} else {%>
                    <a href="festival_aanpassen.jsp"><img src="img/header/festivals.png" alt="Festivals" height="33" /></a>
                    <a href="groepen_aanpassen.jsp"><img src="img/header/groepen.png" alt="Groepen" height="33" /></a>
                    <% } %>       
                    <%if(gebruiker != null){ //Voor het geval een gebruiker naar een pagina wil gaan zonder ingelogd te zijn (inlog vereist)
                    %>
                            <a href="administrator.jsp"><img src="img/header/admin_Selected.png" alt="Admin" height="33" /></a>
                <%} }
                if(gebruiker != null && !strPaginaNaam.contains("administrator") && !strPaginaNaam.contains("account_aanmaken")) 
                {%>
                    <a href="administrator.jsp"><img src="img/header/admin.png" alt="Admin" height="33" /></a>
                <%}%>
        </nav>
        <%!
            public static String leidPaginaNaamAfVanUrl(String strUrl) {
                if (strUrl == null) {
                    return null;
                }
                int lastSlash = strUrl.lastIndexOf("/");
                //if (lastSlash==-1) lastSlash = 0;
                String pageAndExtensions = strUrl.substring(lastSlash + 1);
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