<%-- 
    Document   : layout
    Created on : 28-mrt-2013, 9:04:18
    Author     : Steven
--%>
<!-- Door rowspan te gebruiken, krijgt men hier een warning. Dit is een bug in Netbeans -->
<%@page import="java.util.GregorianCalendar"%>
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
        <title>Groepen Gefilterd</title>
        <link rel="stylesheet" href="css/normalize.css">
        <link rel="stylesheet" href="css/main.css">
        <script src="js/vendor/modernizr-2.6.2.min.js"></script>
    </head>
    <body>
        <a id="boven"></a>
        <div id="pagina_omslag">
            <jsp:include page="hoofding.jsp" />
            <jsp:include page="navigatie.jsp" />
            <div id="inhoud_omslag">
                <section id="inhoud">
                    <div id="elementen_centreren">
                        <%
                            try {
                                Connectie_Databank connectie = new Connectie_Databank();

                                connectie.maakConnectie();
                                List<String> lijstParams = new ArrayList<String>();
                                String query = "SELECT b.* FROM bands b, festivals f, bandsperfestival bf WHERE  b.band_id = bf.band_id AND bf.fest_id = f.fest_id";
                                //WHERE b.band_id = bf.band_id AND bf.fest_id = f.fest_id

                                if (request.getParameter("chkGenre") != null) {
                                    query += " AND (b.band_soortMuziek = ?"; //Beginletters geselecteerd
                                    String[] genres = request.getParameterValues("chkGenre");
                                    //Vormen van query
                                    for (int i = 0; i < genres.length - 1; i++) //ervoor zorgen dat de query juist eindigt
                                    {                                     //Begin 0: Array letters begin ook vanaf 0
                                        query += " OR b.band_soortMuziek = ?";
                                    }
                                    query += ")";

                                    //Vormen van lijstParams
                                    for (int i = 0; i < genres.length; i++) {
                                        lijstParams.add(genres[i]);
                                    }
                                }

                                if (request.getParameter("radFestival") != null) {
                                    query += " AND f.fest_naam = ?";
                                    lijstParams.add(request.getParameter("radFestival"));
                                }

                                connectie.voerQueryUit(query, lijstParams);
                                ResultSet rsInhoudGroepen = connectie.haalResultSetOp();

                                rsInhoudGroepen.last();
                                int lengteResultSet = rsInhoudGroepen.getRow();

                                rsInhoudGroepen.first();
                                rsInhoudGroepen.previous();

                                if (lengteResultSet > 0) {
                        %>
                        <div class="tekst_centreren">
                            <h1>Gefilterd Resultaat</h1>
                            Klik <a href='groepen.jsp'>hier</a> om terug te keren
                        </div>
                        
                            <!-- Informatie groepen -->
                            <%
                                rsInhoudGroepen.first();    //Zorgen dat de cursor op de 1ste rij van de ResultSet staat
                                rsInhoudGroepen.previous(); //Zorgen dat de cursor op rij 0 komt te staan (anders wordt de 1ste rij niet meegenomen!!!)
                                while (rsInhoudGroepen.next()) {
                                    String naam = rsInhoudGroepen.getString("band_naam");
                                    String genre = rsInhoudGroepen.getString("band_soortMuziek");
                                    String afbeelding = rsInhoudGroepen.getString("band_afbeelding");
                            %>
                            <form action="groepen_details.jsp" method="POST">
                            <table id="tabel_breedte_600px_omrand">
                                <tbody class="inhoud_tabel_links_uitlijning" style='padding: 10px;'>
                                    <tr>
                                        <td rowspan="4" style="width: 120px;">
                                            <img id="opmaak_afbeelding" src="<%=afbeelding%>" alt="Afbeelding Band" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="inhoud_tabel_spatie_links_boven" style="border-top: 1px solid white;"><b>
                                                <div class="tekst_vet"> <%= naam%> </div>
                                                <input type="hidden" name="naam" value="<%=naam%>">
                                        </td>
                                        <td style="border-top: 1px solid white;"></td>
                                    </tr>
                                    <tr>
                                        <td class="inhoud_tabel_spatie_links_boven">Genre: <%=genre%></td>
                                        <td></td>
                                    </tr>
                                    <tr>
                                        <%
                                            if (rsInhoudGroepen.getString("band_url") != null) {
                                                String url = rsInhoudGroepen.getString("band_url");
                                                url = url.replace(" ", "%20"); //Spatie vervangen door %20 in url
                                        %>
                                                <td class="inhoud_tabel_spatie_links_onder">
                                                    <a href="http://<%=url%>" target="_blank">Site</a>
                                                </td>
                                        <% } else { %>
                                                <td></td>
                                        <%}%>
                                        <td class="inhoud_tabel_spatie_rechts_onder">
                                            <input type="submit" name="btnDetails" value=" Details " />
                                        </td>
                                    </tr> <!-- Warning negeren. De controle wordt genegeerd. Daarom ziet HTML 3 kolommen ipv 2 -->
                                </tbody>
                            </table>
                            </form>
                            <%
                                }
                            } else {
                            %>
                            <div class="tekst_centreren">
                                <h3>Helaas! Er zijn geen groepen gevonden...</h3>
                                Klik <a href="groepen.jsp">hier</a> om terug te keren
                            </div>
                            <%}
                                    connectie.sluitConnectie(); //Connectie met de databank sluiten
                                } catch (Exception e) {
                                    out.println(e.getMessage());
                                }
                            %>
                        </div>
                </section>
            </div>
            <hr style="width: auto; margin-left: 20px; margin-right: 20px;" />
            <jsp:include page="voettekst.jsp" />
        </div>
        <a href="#boven"><div id="pagina_boven">Begin Pagina</div></a>
    </body>
</html>