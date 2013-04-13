<%-- 
    Document   : navigation
    Created on : 28-mrt-2013, 9:20:35
    Author     : robbie
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Navigation</title>
    </head>
    <body>
        <nav id="nav_wrapper">
            <%
                String pageName = extractPageNameFromURLString(request.getRequestURI()).toString();
                if (pageName.equals("index") || pageName.equals("")) { %>
                    <a href="/"><img src="img/header/home_selected.png" alt="Home" height="33" /></a> 
                    <a href="festivals.jsp"><img src="img/header/festivals.png" alt="Festivals" height="33" /></a>
                    <a href="groepen.jsp"><img src="img/header/groepen.png" alt="Groepen" height="33" /></a>
                <% } else if (pageName.equals("festivals")) { %>
                    <a href="index.jsp"><img src="img/header/home.png" alt="Home" height="33" /></a> 
                    <a href="festivals.jsp"><img src="img/header/festivals_selected.png" alt="Festivals" height="33" /></a>
                    <a href="groepen.jsp"><img src="img/header/groepen.png" alt="Groepen" height="33" /></a>
                <%} else if (pageName.equals("groepen")) { %>
                    <a href="index.jsp"><img src="img/header/home.png" alt="Home" height="33" /></a> 
                    <a href="festivals.jsp"><img src="img/header/festivals.png" alt="Festivals" height="33" /></a>
                    <a href="groepen.jsp"><img src="img/header/groepen_selected.png" alt="Groepen" height="33" /></a>
                <%} else if (pageName.equals("groepen_details")) { %>
                    <a href="index.jsp"><img src="img/header/home.png" alt="Home" height="33" /></a> 
                    <a href="festivals.jsp"><img src="img/header/festivals.png" alt="Festivals" height="33" /></a>
                    <a href="groepen.jsp"><img src="img/header/groepen_selected.png" alt="Groepen" height="33" /></a>
                <%} else if (pageName.equals("festivals_filter")) { %>
                    <a href="index.jsp"><img src="img/header/home.png" alt="Home" height="33" /></a> 
                    <a href="festivals.jsp"><img src="img/header/festivals_selected.png" alt="Festivals" height="33" /></a>
                    <a href="groepen.jsp"><img src="img/header/groepen.png" alt="Groepen" height="33" /></a>
                <%} else if (pageName.equals("groepen_filter")) { %>
                    <a href="index.jsp"><img src="img/header/home.png" alt="Home" height="33" /></a> 
                    <a href="festivals.jsp"><img src="img/header/festivals.png" alt="Festivals" height="33" /></a>
                    <a href="groepen.jsp"><img src="img/header/groepen_selected.png" alt="Groepen" height="33" /></a>
                <%}
                else if (pageName.equals("inlog")) { %>
                    <a href="index.jsp"><img src="img/header/home_selected.png" alt="Home" height="33" /></a> 
                    <a href="festivals.jsp"><img src="img/header/festivals.png" alt="Festivals" height="33" /></a>
                    <a href="groepen.jsp"><img src="img/header/groepen.png" alt="Groepen" height="33" /></a>
                <%}
            %>
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
