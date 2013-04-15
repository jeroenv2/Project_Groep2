<%-- 
    Document   : layout
    Created on : 28-mrt-2013, 9:04:18
    Author     : Steven
--%>
<!-- Door rowspan te gebruiken, krijgt men hier een warning. Dit is een bug in Netbeans -->
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
        
        <!-- Collapsible scripts -->
        <script src="http://ajax.googleapis.com/ajax/libs/jquery/1.8.1/jquery.min.js"></script>
        <script src="js/vendor/jquery.collapse.js"></script>
        <script>
            //Bron: http://www.javascript-coder.com/javascript-form/javascript-reset-form.phtml
            function leegFilter() {
                var frmElementen = form_filter.elements;    
                for(i=0; i<frmElementen.length; i++)
                {
                    frmElementen[i].checked = false;
                }
            }
            window.onload = leegFilter;
        </script>
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
                                ArrayList<String> lijstGenres = new ArrayList<String>();

                                Connectie_Databank connectie = new Connectie_Databank();

                                connectie.maakConnectie();
                                List<String> lijstParams = new ArrayList<String>();

                                connectie.voerQueryUit("SELECT b.*, bf.*, f.fest_naam FROM bands b, bandsperfestival bf, festivals f WHERE b.band_id = bf.band_id AND bf.fest_id = f.fest_id", lijstParams);
                                ResultSet rsInhoudGroepen = connectie.haalResultSetOp();

                                rsInhoudGroepen.last();
                                int lengteResultSet = rsInhoudGroepen.getRow();

                                rsInhoudGroepen.first();
                                rsInhoudGroepen.previous();

                                if (lengteResultSet > 0) {
                        %>
                        <div data-collapse id="opmaak_openklapper">
                            <h2 id="geavanceerd_zoeken_filter">+ Geavanceerd Zoeken </h2>
                        <div>
                        <form id="form_filter" action='groepen_filter.jsp' method='POST'>
                            <table id="tabel_filter">
                                <tbody class="inhoud_tabel_links_uitlijning">
                                    <tr>
                                        <td><div class="tekst_onderlijning">Genre:</div>
                                        <%while (rsInhoudGroepen.next()) {
                                                String genre = rsInhoudGroepen.getString("band_soortMuziek");

                                                if (!lijstGenres.contains(genre)) {
                                                    lijstGenres.add(genre);
                                                }
                                            }
                                            rsInhoudGroepen.first();
                                            rsInhoudGroepen.previous();
                                            
                                            //De ArrayList alfabetisch ordenen
                                            java.util.Collections.sort(lijstGenres);
                                            for (String genre : lijstGenres) {
                                        %>
                                &nbsp;&nbsp;&nbsp;&nbsp;<input type='checkbox' name='chkGenre' value='<%= genre%>' /> <%= genre%><br />
                                <%
                                    }
                                %>
                                </td>
                                <td>
                                <div class="tekst_onderlijning">Festival:</div>
                                <%
                                      List<String> lijstFestivals = new ArrayList<String>();
                                      while (rsInhoudGroepen.next()) {
                                                String festival = rsInhoudGroepen.getString("fest_naam");

                                                if (!lijstFestivals.contains(festival)) {
                                                    lijstFestivals.add(festival);
                                                }
                                            }
                                      //De ArrayList alfabetisch ordenen
                                            java.util.Collections.sort(lijstFestivals);
                                            for (String festival : lijstFestivals) {
                                        %>
                                &nbsp;&nbsp;&nbsp;&nbsp;<input type='radio' name='radFestival' value='<%=festival%>' /> <%=festival%><br />
                                <%
                                    }
                                %>
                                </td>
                                </tr>
                                <tr>
                                    <td class="inhoud_tabel_spatie_links_boven_onder">
                                        <input type='submit' name='btnZoekFilter' value=' Zoeken ' /> 
                                        <input type='reset' name='btnLeegFilter' value=' Wissen ' /></td>
                                    <td></td>
                                </tr>
                                </tbody >
                            </table>
                        </form>
                        </div>
                        </div>
                                
                        <div id="WitruimteTabelFilter">
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
                            <h3>Helaas! Er zijn geen groepen gevonden...</h3>
                            <%}
                                    connectie.sluitConnectie(); //Connectie met de databank sluiten
                                } catch (Exception e) {
                                    out.println(e.getMessage());
                                }
                            %>
                        </div>
                    </div>
                </section>
            </div>
            <hr style="width: auto; margin-left: 20px; margin-right: 20px;" />
            <jsp:include page="voettekst.jsp" />
        </div>
        <a href="#boven"><div id="pagina_boven">Begin Pagina</div></a>
    </body>
</html>