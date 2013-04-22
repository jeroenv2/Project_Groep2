<%-- 
    Document   : festival_aanpassen
    Created on : Apr 9, 2013, 9:20:39 AM
    Author     : tar-aldaron
--%>

<%@page import="javax.swing.JOptionPane"%>
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
<html class="no-js">
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
                            if(gebruiker!=null){
                            try {
                                Connectie_Databank connectie = new Connectie_Databank();

                                connectie.maakConnectie();
                                List<String> lijstParams = new ArrayList<String>();

                                connectie.voerQueryUit("SELECT * FROM festivals", lijstParams);
                                ResultSet res = connectie.haalResultSetOp();

                                res.last();
                                int lengteResultSet = res.getRow();

                                res.first();
                                res.previous();

                                if (lengteResultSet > 0) {

                        %>   

                        <div style='padding-top: 25px; padding-bottom: 10px;'>
                            <%! String id = "";%>
                            <!-- Informatie Festivals -->
                            <%
                                res.first();    //Zorgen dat de cursor op de 1ste rij van de ResultSet staat
                                res.previous(); //Zorgen dat de cursor op rij 0 komt te staan (anders wordt de 1ste rij niet meegenomen!!!)
                                while (res.next()) {
                                    id = res.getString("fest_id");
                                    String naam = res.getString("fest_naam");
                                    String beginDatum = res.getString("fest_datum");
                                    String locatie = res.getString("fest_locatie");
                                    String styleTable;
                                    if (fest.contains(id)) {
                                        styleTable = " background-color: red;";
                                    } else {
                                        styleTable = "";
                                    }
                            %>
                            <a id="<%= id%>"></a>
                            <table width='600px' style='border: 1px solid white;<%= styleTable%> '>
                                <tbody style='padding: 10px;'>
                                
                                    <tr>
                                        <td width='300px' style='padding-left: 10px; padding-top: 10px;'><b> <%= naam%> </b></td>
                                    <input type="hidden" name="naam" value="<%=naam%>">
                                    <td style='padding-left: 10px; padding-top: 10px;'>Begindatum: <%=beginDatum%> </td>
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
                                            cal.add(cal.DATE, Integer.parseInt(res.getString("fest_duur")));    //Dagen (duur) optellen bij de begindatum

                                            Date einddatum = cal.getTime(); //Nieuwe Date-obj maken als einddatum met de inhoud van cal
                                            String strEinddatum = formaatDatum.format(einddatum); //Einddatum omzetten naar juiste formaat
%>
                                        <td style='padding-left: 10px; padding-top: 10px;'>Einddatum: <%=strEinddatum%></td>
                                        <td align='right' style='padding-right: 10px; padding-bottom: 10px;'>
                                            <form action="festival_details_aanpassen.jsp" method="POST" >
                                             <input name="naam" type="hidden" value="<%=naam%>"/>
                                            <input type="submit" name="Details" value=" Details " />
                                            </form><form action="festival_aanpassen.jsp#<%=Integer.parseInt(id) - 1%>" method="POST" >
                                    </tr>
                                    <tr>
                                        <%
                                            if (res.getString("fest_url") != null) {
                                                String url = res.getString("fest_url");
                                        %>
                                        <td style='padding-left: 10px; padding-bottom: 10px;'><a href='http://<%=url%>' target='_blank'>Site</a></td>
                                        <%
                                        } else {
                                        %>
                                        <td></td>
                                        <%}
                                            String knop;
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
                                    <td></td>
                                    <td align="right" style='padding-right: 10px;padding-bottom: 10px;' >
                                        <input type="submit" value="<%=knop%>"/>

                                    </td>
                                    </tr>
                                </form>
                                </tbody>
                            </table><br />
                            <%
                                }%>
                            <form action="verwijderen_resultaat.jsp" method="POST">
                                <table>
                                    <tr>
                                        <td>
                                            <%

                                                for (String element : fest) {%>
                                            <input name="festivalsVerwijderen" type="hidden" value="<%=element%>"/>

                                            <%}
                                                String status = "visibility: visible;";
                                                if (!Verwijder_knop) {
                                                    status = "visibility: hidden;";
                                                }

                                            %>
                                        </td>
                                        <td style='padding-right: 10px; padding-bottom: 6px;'>
                                            <input type="submit" value="Verwijderen" style="<%= status%>"/> 
                                        </td>
                                        </form>

                                    <form action="festival_aanpassen.jsp" method="GET">
                                        <input id="annuleren_hidden" name="annuleren" type="hidden" value="false"/>

                                        <td style='padding-right: 10px; padding-bottom: 6px;'>
                                            <input name="annuleren" type="submit" value="Annuleren"style="<%= status%>"/></td>
                                    </form>
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
                                  }else{
                                %>
                                
                                
                                U bent niet ingelogd
                                
                                <%}%>
                        </div>
                </section>
            </div>
            <hr style="width: auto; margin-left: 20px; margin-right: 20px;" />
            <jsp:include page="voettekst.jsp" />
        </div>
        <a href="#top"><div id="pagina_boven"> Begin Pagina </div></a>
    </body>
</html>