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
            connectie.voerQueryUit("SELECT b.band_id, b.band_naam, p.pod_id, p.pod_omschr"
            + " FROM bands b"
            + " JOIN bandsperfestival bf ON b.band_id = bf.band_id"
            + " JOIN podia p ON p.pod_id = bf.pod_id"
            + " WHERE fest_id = ?", lijstParams);
            ResultSet bands = connectie.haalResultSetOp();
            
            //ResultSet aanmaken voor alle campings van een festival
            connectie.voerQueryUit("SELECT c.camp_id, c.camp_adres, c.camp_cap"
            + " FROM campings c"
            + " JOIN campingsperfestival cf ON c.camp_id = cf.camp_id"
            + " WHERE fest_id = ?", lijstParams);
            ResultSet campings = connectie.haalResultSetOp();
            
            //ResultSet aanmaken voor alle tickettypes beschikbaar op een festival
            connectie.voerQueryUit("SELECT tt.typ_id, tt.typ_omschr, tt.typ_prijs"
            + " FROM tickettypes tt"
            + " JOIN tickettypesperfestival ttf ON tt.typ_id = ttf.typ_id"
            + " WHERE fest_id = ?", lijstParams);
            ResultSet tickets = connectie.haalResultSetOp();
            
            List<String> alTickets = new ArrayList<String>();
            while(tickets.next()) {
                alTickets.add(tickets.getString("typ_id"));
            }
            tickets.beforeFirst();
            
            lijstParams.remove(0);
            connectie.voerQueryUit("SELECT * FROM tickettypes", lijstParams);
            ResultSet rsTicketTypes = connectie.haalResultSetOp();

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
        <script type="text/javascript">
            function setDropDownValue(select) {
                var val = select.options[select.selectedIndex].value;
                var inp = document.getElementById("typ_id");
                inp.value = val;
            }
        </script>
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
                                    <td><input type="text" id="land" name="land" value="<%= land %>" 
                                               required title="Vul een land in." /></td>
                                </tr>
                                <tr>
                                    <td>Locatie:</td>
                                    <td><input type="text" id="gemeente" name="gemeente" value="<%= gemeente %>"
                                               required title="Vul en gemeente in." /></td>
                                </tr>
                                <tr>
                                    <td>Startdatum:</td>
                                    <td><input type="date" id="bdatum" name="fest_datum" value="<%= fest.getString("fest_datum") %>"
                                               required pattern="\d{4}-\d{2}-\d{2}" title="jjjj-mm-dd" /></td>
                                </tr>
                                <tr>
                                    <td>Einddatum:</td>
                                    <td><input type="date" id="edatum" name="fest_einddatum" value="<%= fest.getString("fest_einddatum") %>"
                                               required pattern="\d{4}-\d{2}-\d{2}" title="jjjj-mm-dd" /></td>
                                </tr>
                                <tr>s
                                    <td>Duur:</td>
                                    <td><input type="text" id="duur" name="fest_duur" value="<%= fest.getString("fest_duur") %>" required/></td>
                                </tr>
                                <tr>
                                    <td>Website:</td>
                                    <%  String website = fest.getString("fest_url");
                                    if (website != null) {%>
                                    <td><input type="text" id="murl" name="website" value="<%= website %>"
                                               pattern="(http:\/\/|https:\/\/)?www\.?([a-zA-Z0-9_%]*)\.[a-zA-Z]{1}[a-zA-Z]+"
                                               title="http:// of https:// + A-Z + .A-Z"/></td>
                                    <%} else {%>
                                    <td><input type="url" id="zurl" name="website" value="" /></td>
                                    <%}%>
                                </tr>
                                <tr>
                                    <td colspan="2">
                                        <input type="hidden" name="fest_id" value="<%= fest.getString("fest_id") %>" />
                                        <input type="hidden" name="fest_naam" value="<%= fest.getString("fest_naam") %>" />
                                        <input type="submit" id="festsave" name="festsave" value="Gegevens opslaan"
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
                                <p class="open">Verwijder groep</p>
                                <ul>
                                    <% try {
                                        while (bands.next()) { %>
                                    <li>
                                        <%= bands.getString("band_naam") %>
                                    </li>
                                    <li>
                                        <input type="image" id="" src="img/minus.png" width="15px"/>&nbsp;
                                        <%= bands.getString("pod_omschr") %>
                                    </li>
                                    <%  }
                                       } catch (Exception e) { %>
                                    <li>Nog geen groepen</li>
                                    <% }%>
                                </ul>
                                <p>Verwijder camping</p>
                                <ul>
                                    <% try {
                                        while (campings.next()) { %>
                                    <li>
                                        <%= campings.getString("camp_adres") %>
                                        <input type="image" id="" src="img/minus.png" width="15px"/>&nbsp;
                                    </li>
                                    <li><%= campings.getString("camp_cap") %></li>
                                    <%  }
                                       } catch (Exception e) { %>
                                    <li>Nog geen campings</li>
                                    <% }%>
                                </ul>
                                <p>Verwijder ticket</p>
                                <ul>
                                    <% try {
                                        while (tickets.next()) { %>
                                    <li>
                                        <form action="./details/delete_ticket.jsp">
                                            <%= tickets.getString("typ_omschr") %>
                                            <input type="hidden" name="fest_id" value="<%= fest.getString("fest_id") %>" />
                                            <input type="hidden" name="typ_id" value="<%= tickets.getString("typ_id") %>" />
                                            <button type="submit">
                                                <img src="img/minus.png" alt="X" width="15px"/>
                                            </button>
                                        </form>
                                    </li>
                                    <li><%= tickets.getString("typ_prijs") %></li>
                                    <%  }
                                       } catch (Exception e) { %>
                                    <li>Nog geen tickets</li>
                                    <% }%>
                                </ul>
                                <p>Ticket toevoegen</p>
                                <div class="nolist">
                                    <form id="form_add_ticket" name="add_ticket" action="details/add_ticket.jsp">
                                    Type:&nbsp;
                                    <select id="ticket_add" onchange="setDropDownValue(this)">
                                    <% while (rsTicketTypes.next()) {
                                        if (!alTickets.contains(rsTicketTypes.getString("typ_id"))) { %>
                                        <option value="<%= rsTicketTypes.getString("typ_id") %>">
                                            <%= rsTicketTypes.getString("typ_omschr") %>
                                        </option>
                                        <% }
                                    } %>
                                    </select><br />
                                    Aantal:&nbsp;
                                    <input type="number" name="typ_aantal" min="1" required title="Niet negatief" />
                                    <input type="hidden" name="fest_id" value="<%= fest.getString("fest_id") %>" />
                                    <input type="hidden" id="typ_id" name="typ_id" value="" />
                                    <input type="submit" id="add_ticket" name="submit" value="Toevoegen"
                                           style="margin-top: 5px; width: 100px;"/>
                                    </form>
                                </div>
                            </div>
                        </article>
                </section>
            </div>
            <hr style="width: auto; margin-left: 20px; margin-right: 20px;" />
            <jsp:include page="footer.jsp" />
        </div>
    </body>
</html>