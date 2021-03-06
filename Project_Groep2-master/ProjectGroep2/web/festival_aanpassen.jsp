<%-- 
    Document   : festival_aanpassen
    Created on : Apr 9, 2013, 9:20:39 AM
    Author     : tar-aldaron
--%>
<%@page import="sun.font.Script"%>
<%@page import="java.util.List"%>
<%@page import="java.text.DateFormat"%>
<%@page import="java.util.Locale"%>
<%@page import="java.util.Calendar"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>
<%@page import="java.sql.ResultSet"%>

<%@page import="Databank.Connectie_Databank"%>
<%@page import="java.util.ArrayList"%>
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
        <title>Festivals</title>
        <link rel="stylesheet" href="css/normalize.css">
        <link rel="stylesheet" href="css/main.css">
        <script src="js/vendor/modernizr-2.6.2.min.js"></script>
        <script>
            <%!List<String> fest = new ArrayList();

            %>
        </script>
    </head>
    <body>
        <a id="top"></a>

        <div id="pagina_omslag">
            <jsp:include page="hoofding.jsp" />
            <jsp:include page="navigatie.jsp" />
            <div id="inhoud_omslag">
                <section id="inhoud">
                    <div id="elementen_centreren">

                        <%
                            beans.gegevensGebruiker gebruiker = (beans.gegevensGebruiker) session.getAttribute("gegevensGebruiker");
                            fest.clear();

                            boolean Verwijder_knop = false;
                            if ((request.getParameter("elementen") != null) && request.getParameter("annuleren") == null) {

                                for (String e : request.getParameterValues("elementen")) {
                                    if (!fest.contains(e)) {
                                        fest.add(e);
                                    }
                                }
                            }
                            if (gebruiker != null) {
                                try {
                                    Connectie_Databank connectie = new Connectie_Databank();

                                    connectie.maakConnectie();
                                    List<String> lijstParams = new ArrayList<String>();

                                    connectie.voerQueryUit("SELECT * FROM festivals", lijstParams);
                                    ResultSet rs = connectie.haalResultSetOp();

                                    rs.last();
                                    int lengteResultSet = rs.getRow();

                                    rs.first();
                                    rs.previous();

                                    if (lengteResultSet > 0) {

                        %>   

                        <div style='padding-top: 25px; padding-bottom: 10px;'>
                            <%! String id = "";%>
                            <!-- Informatie Festivals -->
                            <%
                                rs.first();    //Zorgen dat de cursor op de 1ste rij van de ResultSet staat
                                rs.previous(); //Zorgen dat de cursor op rij 0 komt te staan (anders wordt de 1ste rij niet meegenomen!!!)
                                while (rs.next()) {
                                    id = rs.getString("fest_id");
                                    String naam = rs.getString("fest_naam");
                                    String beginDatum = rs.getString("fest_datum");
                                    String locatie = rs.getString("fest_locatie");
                                    String styleTable;
                                    if (fest.contains(id)) {
                                        styleTable = " background-color: red;";
                                    } else {
                                        styleTable = "";
                                    }
                            %>
                            <a id="<%= id%>"></a>
                            <table id="tabel_breedte_600px_omrand" style='<%= styleTable%> '>
                                <tbody style='padding: 10px;'>

                                    <tr>
                                        <td class="inhoud_tabel_breedte_300px inhoud_tabel_spatie_links_boven"><b> <%= naam%> </b></td>

                                        <td style='padding-left: 10px; padding-top: 10px;'>Begindatum: <%=beginDatum%> </td>
                                        <td><input type="hidden" name="naam" value="<%=naam%>"></td>
                                        <td></td>
                                    </tr>
                                    <tr>
                                        <td style='padding-left: 10px; padding-top: 10px; padding-bottom: 10px'>Locatie: <%=locatie%></td>
                                        <!-- Datums berekenen -->
                                        <%
                                            DateFormat formaatDatum = new SimpleDateFormat("yyyy-MM-dd");   //Formaat van datum bepalen

                                            Date begindatum = formaatDatum.parse(beginDatum);

                                            //Calendar gebruiken om dagen (duur) op te tellen bij de begindatum
                                            Calendar cal = Calendar.getInstance();  //Huidige datum in cal steken
                                            cal.setTime(begindatum);                //De begindatum in cal steken
                                            cal.add(cal.DATE, Integer.parseInt(rs.getString("fest_duur")));    //Dagen (duur) optellen bij de begindatum

                                            Date einddatum = cal.getTime(); //Nieuwe Date-obj maken als einddatum met de inhoud van cal
                                            String strEinddatum = formaatDatum.format(einddatum); //Einddatum omzetten naar juiste formaat
                                        %>
                                        <td style='padding-left: 10px; padding-top: 10px;'>Einddatum: <%=strEinddatum%></td>
                                        <td></td>
                                        <td  class="inhoud_tabel_spatie_rechts_onder">
                                            <form action="festival_details_aanpassen.jsp" method="POST" >
                                                <input  name="naam" type="hidden" value="<%=naam%>"/>
                                                <input type="submit" name="Details" value=" Details " />
                                            </form></td>
                                        
                                    </tr>

                                    <tr>
                                        <%
                                            if (rs.getString("fest_url") != null) {
                                                String url = rs.getString("fest_url");
                                        %>
                                        <td style='padding-left: 10px; padding-bottom: 10px;'><a href='http://<%=url%>' target='_blank'>Site</a></td>
                                        <%
                                        } else {%>
                                        <td></td>
                                        <% }%>
                                    <td></td><td></td>
                                        <td class="inhoud_tabel_spatie_rechts_onder" >
                                            <form action="festival_aanpassen.jsp#<%=Integer.parseInt(id) - 1%>" method="POST" >
                                                <%                                            String knop;
                                                    if (!fest.contains(id)) {
                                                        knop = "Verwijderen";
                                                %>
                                                <input name="elementen" type="hidden" value="<%=id%>"/>
                                                <%} else {
                                                        knop = "Annuleren";
                                                        Verwijder_knop = true;

                                                    }
                                                    for (String element : fest) {
                                                        if (!element.equals(id)) {


                                                %>
                                                <input name="elementen" type="hidden" value="<%=element%>"/>
                                                <%}
                                                    }
                                                %>
                                                <input type="submit" value="<%=knop%>"/>
                                            </form>
                                        </td>
                                    </tr>

                                </tbody>
                            </table><br />
                            <%
                                }%>

                            <table>
                                <tr>
                                    <td></td>
                                    <td style='padding-right: 10px; padding-bottom: 6px;'>
                                        <form action="verwijderen_resultaat.jsp" method="POST">
                                            <%

                                                for (String element : fest) {%>
                                            <input name="festivalsVerwijderen" type="hidden" value="<%=element%>"/>

                                            <%}
                                                String status = "visibility: visible;";
                                                if (!Verwijder_knop) {
                                                    status = "visibility: hidden;";
                                                }
                                            %>

                                            <input type="submit" value="Verwijderen" style="<%= status%>"/> 
                                        </form>
                                    </td> 
                                    <td style='padding-right: 10px; padding-bottom: 6px;'>
                                        <form action="festival_aanpassen.jsp" method="GET">
                                            <input id="annuleren_hidden" name="annuleren" type="hidden" value="false"/>
                                            <input name="annuleren" type="submit" value="Annuleren" style="<%= status%>"/>
                                        </form>
                                    </td>

                                    <td></td>

                                </tr>
                            </table>

                            <%} else {
                            %>
                            <h3>Helaas! Er zijn geen records gevonden...</h3>
                            <%}
                                    connectie.sluitConnectie(); //Connectie met de databank sluiten
                                } catch (Exception e) {
                                    out.println(e.getMessage());
                                }
                            } else {
                            %>


                            <h3>Helaas! U bent niet ingelogd...</h3>

                            <%}%>

                        </div>
                    </div>
                </section>
            </div>
            <hr style="width: auto; margin-left: 20px; margin-right: 20px;" />
            <jsp:include page="voettekst.jsp" />
        </div>
        <a href="#top"><div id="pagina_boven"> Begin Pagina </div></a>
    </body>
</html>