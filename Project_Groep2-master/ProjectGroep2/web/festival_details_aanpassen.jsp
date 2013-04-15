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
            List<String> alParams = new ArrayList<String>();
            List<String> alLeeg = new ArrayList<String>();
            alParams.add(request.getParameter("naam"));

            //ResultSet aanmaken voor het gekozen festival
            connectie.voerQueryUit("SELECT f.fest_id, f.fest_naam, f.fest_locatie, f.fest_datum, f.fest_duur, f.fest_einddatum, f.fest_url"
                    + " FROM festivals f"
                    + " WHERE f.fest_naam = ?", alParams);
            ResultSet rsFest = connectie.haalResultSetOp();
            rsFest.first();
            
            //fest_naam niet meer nodig -> verwijderen en fest_id in de plaats
            alParams.remove(0);
            alParams.add(rsFest.getString("fest_id"));
                
            //ResultSet aanmaken voor alle groepen van op het festival
            connectie.voerQueryUit("SELECT b.band_id, b.band_naam, p.pod_id, p.pod_omschr"
            + " FROM bands b"
            + " JOIN bandsperfestival bf ON b.band_id = bf.band_id"
            + " JOIN podia p ON p.pod_id = bf.pod_id"
            + " WHERE fest_id = ?", alParams);
            ResultSet rsBands = connectie.haalResultSetOp();
            
            //Lijst aanmaken met alle band_id's voor later... zie groepen toevoegen/verwijderen
            List<String> alBands = new ArrayList<String>();
            while(rsBands.next()) {
                alBands.add(rsBands.getString("band_id"));
            }
            rsBands.beforeFirst();
                
            //ResultSet aanmaken voor alle campings van een festival
            connectie.voerQueryUit("SELECT c.camp_id, c.camp_adres, c.camp_cap"
            + " FROM campings c"
            + " JOIN campingsperfestival cf ON c.camp_id = cf.camp_id"
            + " WHERE fest_id = ?", alParams);
            ResultSet rsCamp = connectie.haalResultSetOp();
            
            //ResultSet aanmaken voor alle tickettypes beschikbaar op een festival
            connectie.voerQueryUit("SELECT tt.typ_id, tt.typ_omschr, tt.typ_prijs"
            + " FROM tickettypes tt"
            + " JOIN tickettypesperfestival ttf ON tt.typ_id = ttf.typ_id"
            + " WHERE fest_id = ?", alParams);
            ResultSet rsTick = connectie.haalResultSetOp();
            
            //Lijst aanmaken met alle typ_id's voor later... zie tickets toevoegen/verwijderen
            List<String> alTickets = new ArrayList<String>();
            while(rsTick.next()) {
                alTickets.add(rsTick.getString("typ_id"));
            }
            rsTick.beforeFirst();
            
            //Alle tickettypes ophalen om te linken aan dit festival -> zie tickets toevoegen
            connectie.voerQueryUit("SELECT * FROM tickettypes", alLeeg);
            ResultSet rsTicketTypes = connectie.haalResultSetOp();

            //Alle groepen ophalen om te linken aan dit festival -> zie groepen toevoegen
            connectie.voerQueryUit("SELECT bf.band_id, b.band_naam"
            + " FROM bandsperfestival bf"
            + " JOIN bands b ON bf.band_id = b.band_id", alLeeg);
            ResultSet rsBandsFestival = connectie.haalResultSetOp();
                
            //Alle beschikbare podia ophalen
            connectie.voerQueryUit("SELECT pod_omschr, pod_id"
            + " FROM podia", alLeeg);
            ResultSet rsPodia = connectie.haalResultSetOp();
                
            //Naam van pagina opslaan
            String name = rsFest.getString("fest_naam");
                
            //Hergebruikte Strings
            String val;
            int count;
            String browser = request.getHeader("User-Agent"); 
        %>
        <title><%= name %> - Details</title>
        <link rel="stylesheet" href="css/normalize.css">
        <link rel="stylesheet" href="css/main.css">
        <link rel="stylesheet" href="css/detailpages.css">
        <script src="js/vendor/modernizr-2.6.2.min.js"></script>
        <script src="http://ajax.googleapis.com/ajax/libs/jquery/1.7.2/jquery.min.js"></script>
        <script src="js/vendor/jquery.collapse.js"></script>
        <script src="js/vendor/jquery.collapse_storage.js"></script>
        <script src="js/vendor/jquery.collapse_cookie_storage.js"></script>
        <script type="text/javascript">
            function setDropDownValue(select, input) {
                var val = select.options[select.selectedIndex].value;
                var inp = document.getElementById(input);
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
                            String foto = rsFest.getString(2).toLowerCase().replace(" ", "_").replace("'", "");
                        %>
                        <img src="img/festivals/<%= foto %>.jpg"
                             alt="<%= foto %>" width="95%"
                             draggable="true" />
                    </article>
                    <article id="details">
                        <!-- gemeente scheiden van land -->
                        <%
                            String land = "";
                            String gemeente = "";
                            String locatie = rsFest.getString("fest_locatie");
                                
                            int sep = locatie.indexOf("-");
                            gemeente = locatie.substring(0, sep).trim();
                            land = locatie.substring(sep+1, locatie.length()).trim();
                        %>
                        <header>
                            <h2><%=rsFest.getString("fest_naam")%></h2>
                        </header>
                        
                        <!--
                            In principe het zelfde formulier als bij festivaldetails, maar met invoervelden met de actuele gegevens in.
                        -->
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
                                    <td><input type="date" id="bdatum" name="fest_datum" value="<%= rsFest.getString("fest_datum") %>"
                                               required pattern="\d{4}-\d{2}-\d{2}" title="jjjj-mm-dd" /></td>
                                </tr>
                                <tr>
                                    <td>Einddatum:</td>
                                    <td><input type="date" id="edatum" name="fest_einddatum" value="<%= rsFest.getString("fest_einddatum") %>"
                                               required pattern="\d{4}-\d{2}-\d{2}" title="jjjj-mm-dd" /></td>
                                </tr>
                                <tr>
                                    <td>Website:</td>
                                    <%  String website = rsFest.getString("fest_url");
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
                                        <input type="hidden" name="fest_id" value="<%= rsFest.getString("fest_id") %>" />
                                        <input type="hidden" name="fest_naam" value="<%= rsFest.getString("fest_naam") %>" />
                                        <input type="submit" id="festsave" name="festsave" value="Gegevens opslaan"
                                               style="width: 400px; margin-top: 10px;"/>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                        </form>
                    </article>
                    <article id="overzicht">
                        <header>
                            <h2>Verwijderen / toevoegen</h2>
                        </header>
                        <div id="lijsten" data-collapse="persist">
                            <!--
                               GROEPEN VERWIJDEREN 
                            -->
                            <p class="open">Verwijder groep</p>
                            <ul>
                                <% try {
                                    while (rsBands.next()) { %>
                                <li>
                                    <%= rsBands.getString("band_naam") %>
                                </li>
                                <li>
                                    <input type="image" id="" src="img/minus.png" width="15px"/>&nbsp;
                                    <%= rsBands.getString("pod_omschr") %>
                                </li>
                                <%  }
                                   } catch (Exception e) { %>
                                <li>Nog geen groepen</li>
                                <% } 
                                   rsBands.beforeFirst();%>
                            </ul>
                            <!--
                               GROEPEN TOEVOEGEN 
                            -->
                            <p>Groep toevoegen</p>
                            <div class="nolist">
                                <form id="form_add_group" name="add_groep" action="details/add_group.jsp">
                                    
                                Groep:&nbsp;
                                <select id="group_add" onchange="setDropDownValue(this, 'band_id')" required oninvalid="setCustomValidity('Geen groepen meer')"
                                        style="width: 150px;">
                                <!-- 
                                Controleren welke groepen nog niet gelinkt zijn aan dit festival en toevoegen aan het dropdown menu
                                -->
                                <% 
                                    count = 0;
                                    String strBId = "";
                                    while (rsBandsFestival.next()) {
                                        String strBandId = rsBandsFestival.getString("band_id");
                                        System.out.println(strBandId);
                                        if (!alBands.contains(strBandId)) { 
                                            if (count == 0) {
                                                strBId = strBandId;
                                                count++;
                                            }
                                 %>
                                    <option value="<%= strBandId %>">
                                        <%= rsBandsFestival.getString("band_naam") %>
                                    </option>
                                    <% }
                                    } %>
                                </select>
                                Podium:&nbsp;
                                <select id="pod_add" onchange="setDropDownValue(this, 'pod_id')">
                                <% 
                                    count = 0;
                                    String strPId = "";
                                    while (rsPodia.next()) {
                                        String strPodId = rsPodia.getString("pod_id");
                                        System.out.println(strPodId);
                                 %>
                                     <option value="<%= strPodId %>">
                                        <%= rsPodia.getString("pod_omschr") %>
                                    </option>
                                    <% 
                                    } %>
                                </select>
                                Datum:&nbsp;
                                <input type="date" name="groep_datum" value="<%= rsFest.getString("fest_datum") %>"
                                       required pattern="\d{4}-\d{2}-\d{2}" title="jjjj-mm-dd"
                                       min="<%= rsFest.getString("fest_datum") %>"
                                       max="<%= rsFest.getString("fest_einddatum") %>"
                                       maxlength="10"
                                       style="width: 100px;"/><br />
                                Tijd:&nbsp;
                                <input type="time" name="tijd" min="23:59" max="00:00" required pattern="\d{2}:\d{2}" title="HH:MM" />
                                
                                <!-- Hidden velde band_id en pod_id worden opgevuld door javascript (select onchange) -->
                                <input type="number" name="typ_aantal" min="1" required title="Niet negatief" style="width: 75px;" max="6"
                                       oninvalid="setCustomValidity('Geef numerieke waarde')" />
                                <input type="hidden" name="fest_id" value="<%= rsFest.getString("fest_id") %>" />
                                <input type="hidden" id="band_id" name="band_id" value="<%= strBId %>" />
                                <input type="hidden" id="pod_id" name="pod_id" value="<%= strPId %>" />
                                <input type="hidden" name="fest_naam" value="<%= rsFest.getString("fest_naam") %>" />
                                <input type="submit" id="add_ticket" name="submit" value="Toevoegen"
                                       style="margin-top: 5px; width: 100px;"/>
                                </form>
                            </div>
                                
                                
                            <p>Verwijder camping</p>
                            <ul>
                                <% try {
                                    while (rsCamp.next()) { %>
                                <li>
                                    <%= rsCamp.getString("camp_adres") %>
                                    <input type="image" id="" src="img/minus.png" width="15px"/>&nbsp;
                                </li>
                                <li><%= rsCamp.getString("camp_cap") %></li>
                                <%  }
                                   } catch (Exception e) { %>
                                <li>Nog geen campings</li>
                                <% }%>
                            </ul>
                            <!--
                               TICKETS VERWIJDEREN EN TOEVOEGEN 
                            -->
                            <p>Verwijder ticket</p>
                            <ul>
                                <!-- 
                                    Voor elk record in de tickets voor dit festival dynamisch een formulier aanmaken.
                                    Dit formulier dient om een ticket te verwijderen voor dit festival
                                -->
                                <% try {
                                    while (rsTick.next()) { %>
                                <li>
                                    <form action="./details/delete_ticket.jsp">
                                        <input type="hidden" name="fest_id" value="<%= rsFest.getString("fest_id") %>" />
                                        <input type="hidden" name="fest_naam" value="<%= rsFest.getString("fest_naam") %>" />
                                        <input type="hidden" name="typ_id" value="<%= rsTick.getString("typ_id") %>" />
                                        <button type="submit">
                                            <img src="img/minus.png" alt="X" width="15px"/>
                                        </button>
                                        <%= rsTick.getString("typ_omschr") %>
                                    </form>
                                </li>
                                <li><%= rsTick.getString("typ_prijs") %></li>
                                <%  }
                                   } catch (Exception e) { %>
                                <li>Nog geen tickets</li>
                                <% }%>
                            </ul>
                            <p>Ticket toevoegen</p>
                            <div class="nolist">
                                <form id="form_add_ticket" name="add_ticket" action="details/add_ticket.jsp">
                                Type:&nbsp;
                                <!-- 
                                Controleren welke tickets nog niet gelinkt zijn aan dit festival en toevoegen aan het dropdown menu
                                -->
                                <select id="ticket_add" onchange="setDropDownValue(this, 'typ_id')" required oninvalid="setCustomValidity('Geen tickets meer')"
                                        style="width: 150px;">
                                <% 
                                count = 0;
                                val = "";
                                while (rsTicketTypes.next()) {
                                    String strTypId = rsTicketTypes.getString("typ_id");
                                    if (!alTickets.contains(strTypId)) { 
                                        if (count == 0) {
                                            val = strTypId;
                                            count++;
                                        }
                                 %>
                                    <option value="<%= strTypId %>">
                                        <%= rsTicketTypes.getString("typ_omschr") %>
                                    </option>
                                    <% }
                                } %>
                                </select><br />
                                Aantal:&nbsp;
                                <!-- Hidden veld typ_id wordt opgevuld door javascript (select onchange) -->
                                <input type="number" name="typ_aantal" min="1" required title="Niet negatief" style="width: 75px;" max="6"
                                       oninvalid="setCustomValidity('Geef numerieke waarde')" />
                                <input type="hidden" name="fest_id" value="<%= rsFest.getString("fest_id") %>" />
                                <input type="hidden" id="typ_id" name="typ_id" value="<%= val %>" />
                                <input type="hidden" name="fest_naam" value="<%= rsFest.getString("fest_naam") %>" />
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