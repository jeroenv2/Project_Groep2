<%-- 
    Document   : layout
    Created on : 28-mrt-2013, 9:04:18
    Author     : robbie
--%>

<%@page import="Databank.Connectie_Databank"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.List"%>
<%@page import="java.sql.ResultSet"%>
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
        <%
            Connectie_Databank connectie = new Connectie_Databank();

            connectie.maakConnectie();
            List<String> lijstParams = new ArrayList<String>();
            List<String> legeLijst = new ArrayList<String>();
            lijstParams.add(request.getParameter("naam"));

            //ResultSet aanmaken voor het gekozen festival
            connectie.voerQueryUit("SELECT f.fest_id, f.fest_naam, f.fest_locatie, f.fest_datum, f.fest_duur, f.fest_einddatum, f.fest_url"
                    + " FROM festivals f"
                    + " WHERE f.fest_naam = ?", lijstParams);
            ResultSet fest = connectie.haalResultSetOp();
            fest.first();
            
            lijstParams.remove(0);
            lijstParams.add(fest.getString("fest_id"));
            //ResultSet aanmaken voor alle groepen van op het festival
            connectie.voerQueryUit("SELECT b.band_naam, p.pod_omschr"
            + " FROM bands b"
            + " JOIN bandsperfestival bf ON b.band_id = bf.band_id"
            + " JOIN podia p ON p.pod_id = bf.pod_id"
            + " WHERE fest_id = ?", lijstParams);
            ResultSet bands = connectie.haalResultSetOp();
            
            //ResultSet aanmaken voor alle campings van een festival
            connectie.voerQueryUit("SELECT c.camp_adres, c.camp_cap"
            + " FROM campings c"
            + " JOIN campingsperfestival cf ON c.camp_id = cf.camp_id"
            + " WHERE fest_id = ?", lijstParams);
            ResultSet campings = connectie.haalResultSetOp();
            
            //Capaciteit van campings ophalen
            int cap = 0;
            while (campings.next()) {
                cap += Integer.parseInt(campings.getString("camp_cap"));
            }
            campings.beforeFirst();
                
                
            //ResultSet aanmaken voor alle tickettypes beschikbaar op een festival
            connectie.voerQueryUit("SELECT tt.typ_omschr, tt.typ_prijs"
            + " FROM tickettypes tt"
            + " JOIN tickettypesperfestival ttf ON tt.typ_id = ttf.typ_id"
            + " WHERE fest_id = ?", lijstParams);
            ResultSet tickets = connectie.haalResultSetOp();

            //ResultSet aanmaken voor alle campings van het festival

        %>
        <title><%= fest.getString("fest_naam") %> - Details</title>
        <link rel="stylesheet" href="css/normalize.css">
        <link rel="stylesheet" href="css/main.css">
        <link rel="stylesheet" href="css/detailpages.css">
        <script src="js/vendor/modernizr-2.6.2.min.js"></script>
        <script src="http://ajax.googleapis.com/ajax/libs/jquery/1.7.2/jquery.min.js"></script>
        <script src="js/vendor/jquery.collapse.js"></script>
        <script src="js/vendor/jquery.collapse_storage.js"></script>
        <script src="js/vendor/jquery.collapse_cookie_storage.js"></script>
    </head>
    <body>
        <div id="page_wrapper">
            <jsp:include page="header.jsp" />
            <jsp:include page="navigation.jsp" />
            <div id="content_wrapper">
                <section id="content">
                    <article id="foto">
                        <% 
                            String foto = fest.getString(2).toLowerCase().replace(" ", "_").replace("'", "");
                        %>
                        <img src="img/festivals/<%= foto %>.jpg"
                             alt="<%= foto %>" width="95%"
                             draggable="true" />
                    </article>
                    <article id="details">
                        <!-- Naam van browser ophalen -->
                        <% String browser = request.getHeader("User-Agent"); %>
                        <!-- gemeente scheiden van land -->
                        <%
                            String land = "";
                            String gemeente = "";
                            String locatie = fest.getString("fest_locatie");
                                
                            int sep = locatie.indexOf("-");
                            gemeente = locatie.substring(0, sep).trim();
                            land = locatie.substring(sep+1, locatie.length()).trim();
                        %>
                        <header>
                            <h2><%=fest.getString("fest_naam")%></h2>
                        </header>
                        
                        <form action="festival_details_aanpassen_resultaat.jsp" method="POST">
                        <table>
                            <tbody>
                                <tr>
                                    <td>Land:</td>
                                    <td><input type="text" name="land" value="<%= land %>" /></td>
                                </tr>
                                <tr>
                                    <td>Locatie:</td>
                                    <td><input type="text" name="gemeente" value="<%= gemeente %>" /></td>
                                </tr>
                                <tr>
                                    <td>Startdatum:</td>
                                    <td><input type="text" name="fest_datum" value="<%= fest.getString("fest_datum") %>" /></td>
                                </tr>
                                <tr>
                                    <td>Einddatum:</td>
                                    <td><input type="text" name="fest_einddatum" value="<%= fest.getString("fest_einddatum") %>" /></td>
                                </tr>
                                <tr>s
                                    <td>Duur:</td>
                                    <td><input type="text" name="fest_duur" value="<%= fest.getString("fest_duur") %>" /></td>
                                </tr>
                                <tr>
                                    <td>Website:</td>
                                    <%  String website = fest.getString("fest_url");
                                    if (website != null) {%>
                                    <td><input type="text" name="website" value="<%= website %>" /></td>
                                    <%} else {%>
                                    <td><input type="text" name="website" value="" /></td>
                                    <%}%>
                                </tr>
                                <tr>
                                    <td colspan="2">
                                        <input type="hidden" name="fest_id" value="<%= fest.getString("fest_id") %>" />
                                        <input type="hidden" name="fest_naam" value="<%= fest.getString("fest_naam") %>" />
                                        <input type="submit" name="festsave" value="Gegevens opslaan"
                                               style="width: 435px; margin-top: 10px;"/>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                        </form>
                    </article>
                        <article id="overzicht"
                                 style="<% if (browser.contains("Chrome") || browser.contains("MSIE")) {%>margin-right: 45px;<%}%>">
                            <header>
                                <h2>Overzicht</h2>
                            </header>
                            <div id="lijsten" data-collapse="persist">
                                <p class="open">Groepen</p>
                                <ul>
                                    <% try {
                                        while (bands.next()) { %>
                                    <li><%= bands.getString("band_naam") %></li>
                                    <li><%= bands.getString("pod_omschr") %></li>
                                    <%  }
                                       } catch (Exception e) { %>
                                    <li>Nog geen groepen</li>
                                    <% }%>
                                </ul>
                                <p>Campings</p>
                                <ul>
                                    <% try {
                                        while (campings.next()) { %>
                                    <li><%= campings.getString("camp_adres") %></li>
                                    <li><%= campings.getString("camp_cap") %></li>
                                    <%  }
                                       } catch (Exception e) { %>
                                    <li>Nog geen campings</li>
                                    <% }%>
                                </ul>
                                <p>Tickets</p>
                                <ul>
                                    <% try {
                                        while (tickets.next()) { %>
                                    <li><%= tickets.getString("typ_omschr") %></li>
                                    <li><%= tickets.getString("typ_prijs") %></li>
                                    <%  }
                                       } catch (Exception e) { %>
                                    <li>Nog geen tickets</li>
                                    <% }%>
                                </ul>
                            </div>
                        </article>
                </section>
            </div>
            <hr style="width: auto; margin-left: 20px; margin-right: 20px;" />
            <jsp:include page="footer.jsp" />
        </div>
    </body>
</html>