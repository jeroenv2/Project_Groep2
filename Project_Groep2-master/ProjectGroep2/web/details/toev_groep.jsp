<%-- 
    Document   : add_ticket
    Created on : 13-apr-2013, 16:19:04
    Author     : robbie
--%>

<%@page import="java.sql.SQLException"%>
<%@page import="java.text.ParseException"%>
<%@page import="java.text.DateFormat"%>
<%@page import="java.util.Date"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.List"%>
<%@page import="Databank.Connectie_Databank"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <jsp:useBean id="datum" scope="page" class="beans.datumBean" />
        <title>Groep toevoegen</title>
        <% 
            String strFouten = "";
            List<String> alParams = new ArrayList<String>();
                String strFestId = request.getParameter("fest_id");
                String strBandId = request.getParameter("band_id");
                String strPodId = request.getParameter("pod_id");
                String strDatum = request.getParameter("groep_datum");
                String strBeginDatum = request.getParameter("fest_datum");
                String strEindDatum = request.getParameter("fest_einddatum");
                String strUur = request.getParameter("uur");
                try { %>
                    <jsp:setProperty name="datum" property="strBegin" value="<%= strBeginDatum %>" />
                    <jsp:setProperty name="datum" property="strEind" value="<%= strEindDatum %>" />    
                    <%
                    boolean boolDatumOk = datum.isDatumTussen(strDatum);
                    System.out.println("Datum ok? - " + boolDatumOk);
                    if (!boolDatumOk) {
                        throw new IllegalArgumentException();
                    }
                } catch (IllegalArgumentException ia) {
                    strFouten += "<p>ARGUMENT: Enkele gegevens werden niet goed verwerkt:<br /> " + ia.getMessage() + "</p>";
                } catch (ParseException pe) {
                    strFouten += "<p>DATA: Een van de datums zijn niet in het correcte formaat:<br /> " + pe.getMessage() + "</p>";
                } catch (Exception e) {
                    strFouten += "<p>ONBEKEND: Een onbekende fout werd opgevangen<br /> " + e.getMessage() + "</p>";
                }
                alParams.add(strFestId);
                alParams.add(strBandId);
                alParams.add(strPodId);
                alParams.add(strDatum);
                alParams.add(strUur);
                
                if (strFouten.equals("")) {
                    try {
                        Connectie_Databank connectie = new Connectie_Databank();
                        connectie.maakConnectie();

                        connectie.voerUpdateUit("INSERT INTO bandsperfestival"
                        + " (fest_id, band_id, pod_id, datum, uur)"
                        + " VALUES (?, ?, ?, ?, ?)", alParams);

                        //Connectie sluiten voor deze pagina
                        connectie.sluitConnectie();
                    } catch (SQLException se) {
                        strFouten += "<p>SQL: Kon ticket niet toevoegen:<br /> " + se.getMessage() + "</p>";
                    }
                }
        %>
        <script type="text/javascript">
            //Indien fout -> vorige pagina met ingegeven details (zie onclick van button)
            function goBack() {
                window.history.back();
            }
        </script>
        <link rel="stylesheet" href="../css/normalize.css">
        <link rel="stylesheet" href="../css/main.css">
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
                        <p>Er heeft zich een fout voorgedaan bij het toevoegen van het ticket:<br /><%= strFouten %></p>
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
