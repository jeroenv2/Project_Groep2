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
        <title>Groep verwijderen</title>
        <% 
            String strFouten = "";
            List<String> alParams = new ArrayList<String>();
            try {
                String strFestId = request.getParameter("fest_id");
                String strBandId = request.getParameter("band_id");
                String strPodId = request.getParameter("pod_id");
                alParams.add(strFestId);
                alParams.add(strBandId);
                alParams.add(strPodId);
                
                Connectie_Databank connectie = new Connectie_Databank();
                connectie.maakConnectie();

                connectie.voerVeranderingUit("DELETE FROM bandsperfestival"
                + " WHERE fest_id = ? AND band_id = ? AND pod_id = ?", alParams);

                connectie.sluitConnectie();
            } catch (Exception e) {
                strFouten += "Kon ticket niet verwijderen:<br /> " + e.getMessage();
            }
        %>
        <script type="text/javascript">
            function goBack() {
                window.history.back();
            }
        </script>
        <link rel="stylesheet" href="css/normalize.css">
        <link rel="stylesheet" href="css/main.css">
        <script src="js/vendor/modernizr-2.6.2.min.js"></script>
    </head>
    <body>
        <div id="pagina_omslag">
            <jsp:include page="../hoofding.jsp" />
            <jsp:include page="../navigatie.jsp" />
            <div id="inhoud_omslag">
                <section id="inhoud">
                    <article>
                        <% if (strFouten.equals("")) { %>
                        <form id="back" action="../festival_details_aanpassen.jsp" method="post">
                            <input type="hidden" name="naam" value="<%= request.getParameter("fest_naam") %>" />
                        </form>
                        <script>
                            document.forms["back"].submit();
                        </script>
                        <% } else { %>
                        <h1>Helaas</h1>
                        <p>Er heeft zich een fout voorgedaan bij het verwijderen van de groep:<br /><%= strFouten %></p>
                        <p>Probeer het opnieuw: <input type="button" onclick="goBack()" value="Ga terug" /></p>
                        <% } %>
                    </article>
                </section>
            </div>
            <hr style="width: auto; margin-left: 20px; margin-right: 20px;" />
            <jsp:include page="/voettekst.jsp" />
        </div>
    </body>
</html>
