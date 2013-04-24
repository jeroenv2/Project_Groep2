

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
        <title>Groepen</title>
        <link rel="stylesheet" href="css/normalize.css">
        <link rel="stylesheet" href="css/main.css">
        <script src="js/vendor/modernizr-2.6.2.min.js"></script>
        <script src="http://ajax.googleapis.com/ajax/libs/jquery/1.8.1/jquery.min.js"></script>
        <script>
            <%!List<String> groepen = new ArrayList();%>
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
                            groepen.clear();

                            boolean Verwijder_knop = false;
                            if ((request.getParameter("elementen") != null) && request.getParameter("annuleren") == null) {

                                for (String e : request.getParameterValues("elementen")) {
                                    if (!groepen.contains(e)) {
                                        groepen.add(e);
                                    }
                                }

                            }
                            if (gebruiker != null) {
                                try {
                                    ArrayList<String> lijstGenres = new ArrayList<String>();

                                    Connectie_Databank connectie = new Connectie_Databank();

                                    connectie.maakConnectie();
                                    List<String> lijstParams = new ArrayList<String>();

                                    connectie.voerQueryUit("SELECT * FROM bands ", lijstParams);
                                    ResultSet rs = connectie.haalResultSetOp();

                                    rs.last();
                                    int lengteResultSet = rs.getRow();

                                    rs.first();
                                    rs.previous();

                                    if (lengteResultSet > 0) {
                        %>

                        <%! String strID = "";%>
                        <!-- Informatie groepen -->
                        <%
                            rs.first();    //Zorgen dat de cursor op de 1ste rij van de ResultSet staat
                            rs.previous(); //Zorgen dat de cursor op rij 0 komt te staan (anders wordt de 1ste rij niet meegenomen!!!)
                            while (rs.next()) {
                                strID = rs.getString("band_id");
                                String strNaam = rs.getString("band_naam");
                                String strGenre = rs.getString("band_soortMuziek");
                                String strFoto = strNaam.toLowerCase().replace(" ", "_").replace("'", "");
                                String styleTable;
                                if (groepen.contains(strID)) {
                                    styleTable = " background-color: red;";
                                } else {
                                    styleTable = "";
                                }
                        %>                  <a id="<%= strID%>"></a>
                        <table id="tabel_breedte_600px_omrand" style='<%= styleTable%>;'>
                            <tbody  style='padding: 10px;'>

                                <tr>
                                    <td rowspan="4" style="width: 120px; padding: 5px;">
                                        <img id="opmaak_afbeelding" src="img/bands/<%= strFoto %>.jpg" alt="Afbeelding Band" />
                                    </td>
       
                                </tr>
                                <tr>
                                    <td style='padding-left: 10px; padding-top: 10px; border-top: 1px solid white;'><b><%= strNaam%></b></td>
                            
                                    <td style="border-top: 1px solid white;"></td>
                            </tr>
                            <tr>
                                <td style='padding-left: 10px; padding-top: 10px;'>Genre: <%=strGenre%></td>
                                <td class="inhoud_tabel_spatie_rechts_onder">

                                    <form action="groep_details_aanpassen.jsp" method="POST" >
                                        <input name="naam" type="hidden" value="<%=strNaam%>"/>
                                        <input type="submit" name="Details" value=" Details " />
                                    </form>


                                </td>
             
                            </tr>
                            <tr>
                                <%
                                    if (rs.getString("band_url") != null) {
                                        String url = rs.getString("band_url");
                                %>
                                <td style='padding-left: 10px; padding-bottom: 6px;'><a href='http://<%=url%>' target='_blank'>Site</a></td>
                                <%
                                } else {
                                %>
                                <td></td>
                                <%}%>

                                <td class="inhoud_tabel_spatie_rechts_onder">
                                    <form action="groepen_aanpassen.jsp#<%=Integer.parseInt(strID) - 1%>" method="POST">
                                        <%
                                            String knop;
                                            if (!groepen.contains(strID)) {
                                                knop = "Verwijderen";
                                        %>

                                        <input name="elementen" type="hidden" value="<%=strID%>"/>
                                        <%} else {
                                                knop = "Annuleren";
                                                Verwijder_knop = true;

                                            }
                                            for (String element : groepen) {
                                                if (!element.equals(strID)) {
                                        %>
                                        <input name="elementen" type="hidden" value="<%=element%>"/>

                                        <%
                                                }
                                            }
                                        %>

                                        <input type="submit" value="<%=knop%>" />
                                    </form>
                                </td>
                        
                            </tr>
 
                            
                            </tbody>
                        </table><br />
                        <%
                        }%>
                        
                            <table>
                                <tr>
                                    <td>

                                    </td>
                                    <td style='padding-right: 10px; padding-bottom: 6px;'>
                                             <form action="verwijderen_resultaat.jsp" method="POST">
                                        <%

                                        for (String element : groepen) {%>
                                        <input name="groepenVerwijderen" type="hidden" value="<%=element%>"/>

                                        <%}
                                            String status = "visibility: visible;";
                                            if (!Verwijder_knop) {
                                                status = "visibility: hidden;";
                                            }
                                        %>
                                        
                                        <input type="submit" value="Verwijderen" style="<%= status%>"/> </td>
                                    </form>
                                <td style='padding-right: 10px; padding-bottom: 6px;'>
                                <form action="groepen_aanpassen.jsp" method="POST">
                                    <input id="annuleren_hidden" name="annuleren" type="hidden" value="false"/>
                                        <input name="annuleren" type="submit" value="Annuleren" style="<%= status%>"/>
                                </form>
                                </td>
                                </tr>
                            </table>

                            <%
                            } else {
                            %>
                            <h3>Helaas! Er zijn geen records gevonden...</h3>
                            <%}
                                    connectie.sluitConnectie(); //Connectie met de databank sluiten
                                } catch (Exception e) {
                                    out.println(e.getMessage());
                                }
                            } else {
                            %>
                            <h3>Helaas! U bent niet ingelogd</h3>

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