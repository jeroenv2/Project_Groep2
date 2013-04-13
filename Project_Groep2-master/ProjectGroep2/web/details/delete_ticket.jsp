<%-- 
    Document   : tickets
    Created on : 13-apr-2013, 14:47:38
    Author     : robbie
--%>

<%@page import="java.util.List"%>
<%@page import="java.util.ArrayList"%>
<%@page import="Databank.Connectie_Databank"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Ticket verwijderen</title>
        <% 
            String strFouten = "";
            List<String> alParams = new ArrayList<String>();
            try {
                String strFestId = request.getParameter("fest_id");
                String strTypId = request.getParameter("typ_id");
                alParams.add(strFestId);
                alParams.add(strTypId);
            } catch (Exception e) {
                strFouten += "Kon ticket niet verwijderen:<br /> " + e.getMessage();
            }
            
            if (strFouten.equals("")) {
                Connectie_Databank connectie = new Connectie_Databank();
                connectie.maakConnectie();

                connectie.voerUpdateUit("DELETE * FROM tickettypesperfestival"
                + " WHERE typ_id = ? AND fest_id = ?", alParams);

                connectie.sluitConnectie();
            }
        %>
        <script type="text/javascript">
            function goBack()
            {
            window.history.back()
            } 
        </script>
        <link rel="stylesheet" href="css/normalize.css">
        <link rel="stylesheet" href="css/main.css">
        <script src="js/vendor/modernizr-2.6.2.min.js"></script>
    </head>
    <body>
        <jsp:include page="header.jsp" />
        <jsp:include page="navigation.jsp" />
        <div id="content_wrapper">
            <section id="content">
                <article>
                    <% if (strFouten.equals("")) { %>
                    <script type="text/javascript">
                        goBack();
                    </script>
                    <% } else { %>
                    <h1>Helaas</h1>
                    <p>Er heeft zich een fout voorgedaan bij het verwijderen van het ticket: <br /><%= strFouten %></p>
                    <p>Probeer het opnieuw: <input type="button" onclick="goBack()" value="Ga terug" /></p>
                    <% } %>
                </article>
            </section>
        </div>
        <hr style="width: auto; margin-left: 20px; margin-right: 20px;" />
        <jsp:include page="footer.jsp" />
    </body>
</html>
