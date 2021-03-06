<%-- 
    Document   : Uitgelogd
    Created on : Apr 13, 2013, 7:18:02 PM
    Author     : Steven Verheyen
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<!--[if lt IE 7]>      <html class="no-js lt-ie9 lt-ie8 lt-ie7"> <![endif]-->
<!--[if IE 7]>         <html class="no-js lt-ie9 lt-ie8"> <![endif]-->
<!--[if IE 8]>         <html class="no-js lt-ie9"> <![endif]-->
<!--[if gt IE 8]><!-->
<html>
    <!--<![endif]-->
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Uitgelogd</title>
        <link rel="stylesheet" href="css/normalize.css">
        <link rel="stylesheet" href="css/main.css">
        <script src="js/vendor/modernizr-2.6.2.min.js"></script>
    </head>
    <body>
        <%
             beans.gegevensGebruiker gebruiker = (beans.gegevensGebruiker) session.getAttribute("gegevensGebruiker");
             if(gebruiker != null)
             {
                request.getSession().removeAttribute("gegevensGebruiker");
            }
        %>
        <div id="pagina_omslag">
            <jsp:include page="hoofding.jsp" />
            <jsp:include page="navigatie.jsp" />
            <div id="inhoud_omslag">
                <section id="inhoud">
                    <div id="elementen_centreren">
                        <div class="tekst_centreren">
                                <%
                                    if(gebruiker != null)
                                    {
                                %>
                                        <h2>U ben met succes uitgelogd</h2>
                                        klik <a href="index.jsp">hier</a> om naar de hoofdpagina te gaan...
                                <%  }else {%>
                                    <h2>U ben niet ingelogd</h2>
                                    klik <a href="index.jsp">hier</a> om naar de hoofdpagina te gaan.
                                <%}%>
                            </div>
                    </div>
                </section>
            </div>
            <hr style="width: auto; margin-left: 20px; margin-right: 20px;" />
            <jsp:include page="voettekst.jsp" />
        </div>
    </body>
</html>
