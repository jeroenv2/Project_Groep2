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
                                ArrayList<String> alGenres = new ArrayList<String>();

                                Connectie_Databank connectie = new Connectie_Databank();

                                connectie.maakConnectie();
                                List<String> alParams = new ArrayList<String>();

                                connectie.voerQueryUit("SELECT b.*, bf.*, f.fest_naam"
                                + " FROM bands b, bandsperfestival bf, festivals f"
                                + " WHERE b.band_id = bf.band_id AND bf.fest_id = f.fest_id"
                                + " GROUP BY b.band_naam", alParams);
                                ResultSet rsInhoudGroepen = connectie.haalResultSetOp();
                                    
                                if (rsInhoudGroepen.next()) {
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

                                                        if (!alGenres.contains(genre)) {
                                                            alGenres.add(genre);
                                                        }
                                                    }
                                                    rsInhoudGroepen.first();
                                                    rsInhoudGroepen.previous();

                                                    //De ArrayList alfabetisch ordenen
                                                    java.util.Collections.sort(alGenres);
                                                    for (String strGenre : alGenres) {
                                                %>
                                        &nbsp;&nbsp;&nbsp;&nbsp;<input type='checkbox' name='chkGenre' value='<%= strGenre %>' /> <%= strGenre %><br />
                                        <%
                                            }
                                        %>
                                        </td>
                                        <td>
                                        <div class="tekst_onderlijning">Festival:</div>
                                        <%
                                              List<String> alFestivals = new ArrayList<String>();
                                              while (rsInhoudGroepen.next()) {
                                                        String festival = rsInhoudGroepen.getString("fest_naam");

                                                        if (!alFestivals.contains(festival)) {
                                                            alFestivals.add(festival);
                                                        }
                                                    }
                                              //De ArrayList alfabetisch ordenen
                                                    java.util.Collections.sort(alFestivals);
                                                    for (String festival : alFestivals) {
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
                                
                        <div id="witruimte_tabel_filter">
                            <!-- Informatie groepen -->
                            <%
                                connectie.voerQueryUit("SELECT * FROM bands", alParams);
                                
                                rsInhoudGroepen = connectie.haalResultSetOp();
                                rsInhoudGroepen.beforeFirst();
                                
                                while (rsInhoudGroepen.next()) {
                                    String strNaam = rsInhoudGroepen.getString("band_naam");
                                    String strGenre = rsInhoudGroepen.getString("band_soortMuziek");
                                    String strFoto = strNaam.toLowerCase().replace(" ", "_").replace("'", "");
                            %>
                            <form action="groep_details.jsp" method="POST">
                            <table id="tabel_breedte_600px_omrand">
                                <tbody class="inhoud_tabel_links_uitlijning" style='padding: 10px;'>
                                    <tr>
                                        <td rowspan="4" style="width: 120px;">
                                            <img id="opmaak_afbeelding" src="img/bands/<%= strFoto %>.jpg" alt="Afbeelding Band" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="inhoud_tabel_spatie_links_boven" style="border-top: 1px solid white;"><b>
                                                <div class="tekst_vet"> <%= strNaam %> </div>
                                                <input type="hidden" name="naam" value="<%= strNaam %>">
                                        </td>
                                        <td style="border-top: 1px solid white;"></td>
                                    </tr>
                                    <tr>
                                        <td class="inhoud_tabel_spatie_links_boven">Genre: <%= strGenre %></td>
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
                                        <h3>Helaas! Er zijn geen groepen gevonden</h3>
                                        Klik <a href="index.jsp">hier</a> om naar de hoofdpagina te gaan...
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