<%-- 
    Document   : add_ticket
    Created on : 13-apr-2013, 16:19:04
    Author     : robbie
--%>

<%@page import="java.util.ArrayList"%>
<%@page import="java.util.List"%>
<%@page import="Databank.Connectie_Databank"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
        <% 
            String strFouten = "";
            List<String> alParams = new ArrayList<String>();
            try {
                String strFestId = request.getParameter("fest_id");
                String strTypId = request.getParameter("typ_id");
                String strTypAantal = request.getParameter("typ_aantal");
                alParams.add(strFestId);
                alParams.add(strTypId);
                alParams.add(strTypAantal);
                    
                Connectie_Databank connectie = new Connectie_Databank();
                connectie.maakConnectie();

                connectie.voerUpdateUit("INSERT INTO tickettypesperfestival"
                + " (fest_id, typ_id, aantal)"
                + " VALUES (?, ?, ?)", alParams);
                                
                //Connectie sluiten voor deze pagina
                connectie.sluitConnectie();
            } catch (Exception e) {
                strFouten += "Kon ticket niet toevoegen:<br /> " + e.getMessage();
            }
            
            if (strFouten.equals("")) {

            }
        %>
        <link rel="stylesheet" href="../css/normalize.css">
        <link rel="stylesheet" href="../css/main.css">
        <script src="js/vendor/modernizr-2.6.2.min.js"></script>
    </head>
    <body>
        <div id="page_wrapper">
            <jsp:include page="../header.jsp" />
            <jsp:include page="../navigation.jsp" />
            <div id="content_wrapper">
                <section id="content">
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
                        <p>Er heeft zich een fout voorgedaan bij het toevoegen van het ticket:<br /><%= strFouten %></p>
                        <p>Probeer het opnieuw: <input type="button" onclick="goBack()" value="Ga terug" /></p>
                        <% } %>
                    </article>
                </section>
            </div>
            <hr style="width: auto; margin-left: 20px; margin-right: 20px;" />
            <jsp:include page="/footer.jsp" />
        </div>
    </body>
</html>
