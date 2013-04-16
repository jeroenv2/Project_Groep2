<%-- 
    Document   : layout
    Created on : 28-mrt-2013, 9:04:18
    Author     : robbie
--%>

<%@page import="java.sql.SQLException"%>
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
            ResultSet rsBandsFest = connectie.haalResultSetOp();
            
            //Lijst aanmaken met alle band_id's voor later... zie groepen toevoegen/verwijderen
            List<String> alBands = new ArrayList<String>();
            while(rsBandsFest.next()) {
                alBands.add(rsBandsFest.getString("band_id"));
            }
            rsBandsFest.beforeFirst();
                
            //ResultSet aanmaken voor alle campings van een festival
            connectie.voerQueryUit("SELECT c.camp_id, c.camp_adres, c.camp_cap"
            + " FROM campings c"
            + " JOIN campingsperfestival cf ON c.camp_id = cf.camp_id"
            + " WHERE fest_id = ?", alParams);
            ResultSet rsCampFest = connectie.haalResultSetOp();
                
            List<String> alCampings = new ArrayList<String>();
            while (rsCampFest.next()) {
                alCampings.add(rsCampFest.getString("camp_id"));
            }
            rsCampFest.beforeFirst();
            
            //ResultSet aanmaken voor alle tickettypes beschikbaar op een festival
            connectie.voerQueryUit("SELECT tt.typ_id, tt.typ_omschr, tt.typ_prijs"
            + " FROM tickettypes tt"
            + " JOIN tickettypesperfestival ttf ON tt.typ_id = ttf.typ_id"
            + " WHERE fest_id = ?", alParams);
            ResultSet rsTickFest = connectie.haalResultSetOp();
            
            //Lijst aanmaken met alle typ_id's voor later... zie tickets toevoegen/verwijderen
            List<String> alTickets = new ArrayList<String>();
            while(rsTickFest.next()) {
                alTickets.add(rsTickFest.getString("typ_id"));
            }
            rsTickFest.beforeFirst();
            
            //Alle tickettypes ophalen om te linken aan dit festival -> zie tickets toevoegen
            connectie.voerQueryUit("SELECT * FROM tickettypes", alLeeg);
            ResultSet rsTickPFest = connectie.haalResultSetOp();

            //Alle groepen ophalen om te linken aan dit festival -> zie groepen toevoegen
            connectie.voerQueryUit("SELECT bf.band_id, b.band_naam"
            + " FROM bandsperfestival bf"
            + " JOIN bands b ON bf.band_id = b.band_id"
            + " GROUP BY b.band_naam", alLeeg);
            ResultSet rsBandsPFest = connectie.haalResultSetOp();
                
            //Alle beschikbare podia ophalen
            connectie.voerQueryUit("SELECT pod_omschr, pod_id"
            + " FROM podia", alLeeg);
            ResultSet rsPodPFest = connectie.haalResultSetOp();
            
            //Alle beschikbare campings ophalen
            connectie.voerQueryUit("SELECT *"
            + " FROM campings", alLeeg);
            ResultSet rsCampPFest = connectie.haalResultSetOp();
                
            //Naam van pagina opslaan
            
                
                
            //Hergebruikte Strings
            String strNaam = rsFest.getString("fest_naam");
            String val;
            int count;
            String browser = request.getHeader("User-Agent"); 
        %>
        <title><%= strNaam %> - Details</title>
        <link rel="stylesheet" href="css/normalize.css">
        <link rel="stylesheet" href="css/main.css">
        <link rel="stylesheet" href="css/detail_pagina.css">
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
        <div id="pagina_omslag">
            <jsp:include page="hoofding.jsp" />
            <jsp:include page="navigatie.jsp" />
            <div id="inhoud_omslag">
                <section id="inhoud">
                    <article id="foto">
                        <% 
                            String foto = rsFest.getString(2).toLowerCase().replace(" ", "_").replace("'", "");
                        %>
                        <header>
                            <h2>Afbeelding</h2>
                        </header>
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
                            <h2><%=strNaam%></h2>
                        </header>
                        
                        <!--
                            In principe het zelfde formulier als bij festivaldetails, maar met invoervelden met de actuele gegevens in.
                        -->
                        <form action="festival_details_aanpassen_resultaat.jsp" method="post">
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
                                        <input type="hidden" name="fest_naam" value="<%= strNaam %>" />
                                        <input type="submit" id="festsave" name="festsave" value="Gegevens opslaan" />
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
                           <p class="open menu">Verwijder groep</p>
                            <ul>
                             <% if (rsBandsFest.next()) {
                                do { %>
                                <li>
                                    <form action="./details/wis_groep.jsp" method="post">
                                        <input type="hidden" name="fest_id" value="<%= rsFest.getString("fest_id") %>" />
                                        <input type="hidden" name="band_id" value="<%= rsBandsFest.getString("band_id") %>" />
                                        <input type="hidden" name="pod_id" value="<%= rsBandsFest.getString("pod_id") %>" />
                                        <input type="hidden" name="fest_naam" value="<%= strNaam %>" />
                                        <button type="submit">
                                            <img src="img/minus.png" alt="X" width="15px"/>
                                        </button>&nbsp;<%= rsBandsFest.getString("band_naam") %>
                                    </form>
                                </li>
                                <li>
                                    <%= rsBandsFest.getString("pod_omschr") %>
                                </li>
                                <% } while (rsBandsFest.next());
                                } else { %>
                                    <li>Nog geen groepen</li>
                             <% } %>
                            </ul>
                            <!--
                               GROEPEN TOEVOEGEN 
                            -->
                            <p class="menu">Groep toevoegen</p>
                            <div class="geen_lijst">
                                <form id="form_toev_groep" name="toev_groep" action="details/toev_groep.jsp" method="post">
                                    
                                <p style="margin-top: 0px !important">Groep:
                                <select id="sel_groep_toev" class="inputveld" onchange="setDropDownValue(this, 'band_id');"
                                        required oninvalid="setCustomValidity('Geen groepen meer')"
                                        style="width: 150px;">
                                <!-- Controleren welke groepen nog niet gelinkt zijn aan dit festival en toevoegen aan het dropdown menu -->
                                <% 
                                    count = 0;
                                    String strBId = "";
                                    while (rsBandsPFest.next()) {
                                        String strBandId = rsBandsPFest.getString("band_id");
                                        if (!alBands.contains(strBandId)) { 
                                            if (count == 0) {
                                                strBId = strBandId;
                                                count++;
                                            }
                                 %>
                                    <option value="<%= strBandId %>">
                                        <%= rsBandsPFest.getString("band_naam") %>
                                    </option>
                                    <% }
                                    } %>
                                </select></p>
                                <p>Podium:</p>
                                <p><select id="pod_toev" class="inputveld" onchange="setDropDownValue(this, 'pod_id');">
                                <% 
                                    count = 0;
                                    String strPId = "";
                                    while (rsPodPFest.next()) {
                                        String strPodId = rsPodPFest.getString("pod_id");
                                        if (count == 0) {
                                            strPId = strPodId;
                                            count++;
                                        }
                                 %>
                                     <option value="<%= strPodId %>">
                                        <%= rsPodPFest.getString("pod_omschr") %>
                                    </option>
                                    <% 
                                    } %>
                                </select></p>
                                <p>Datum:
                                <input type="date" class="inputveld" name="groep_datum" value="<%= rsFest.getString("fest_datum") %>"
                                       required pattern="\d{4}-\d{2}-\d{2}" title="jjjj-mm-dd" oninvalid="setCustomValidity('Datum incorrect')"
                                       min="<%= rsFest.getString("fest_datum") %>"
                                       max="<%= rsFest.getString("fest_einddatum") %>"
                                       maxlength="10"
                                       style="width: 100px;"/></p>
                                <p>Tijd:
                                    <!-- in pattern (%3A) moet goedgekeurd worden voor browsers die type="time" kennen -->
                                <input type="time" name="uur" class="inputveld" min="00:00" max="23:59"
                                       required pattern="\d{2}(%3A|:)?\d{2}" title="HH:MM" oninvalid="setCustomValidity('Tijd niet correct')"
                                       style="width: 50px;" /></p>
                                
                                <!-- Hidden velde band_id en pod_id worden opgevuld door javascript (select onchange) -->
                                <input type="hidden" name="fest_id" value="<%= rsFest.getString("fest_id") %>" />
                                <input type="hidden" id="band_id" name="band_id" value="<%= strBId %>" />
                                <input type="hidden" id="pod_id" name="pod_id" value="<%= strPId %>" />
                                <input type="hidden" name="fest_naam" value="<%= strNaam %>" />
                                <input type="hidden" name="fest_datum" value="<%= rsFest.getString("fest_datum") %>" />
                                <input type="hidden" name="fest_einddatum" value="<%= rsFest.getString("fest_einddatum") %>" />
                                <input type="submit" id="toev_ticket" name="submit" value="Toevoegen"
                                       style="margin-top: 5px; width: 100px;"/>
                                </form>
                            </div>
                            <!--
                               CAMPING VERWIJDEREN
                            -->
                            <p class="menu">Verwijder campings</p>
                            <ul>
                             <% if (rsCampFest.next()) {
                                do { %>
                                <li>
                                    <form action="details/wis_camping.jsp" method="post">
                                        <input type="hidden" name="fest_id" value="<%= rsFest.getString("fest_id") %>" />
                                        <input type="hidden" name="camp_id" value="<%= rsCampFest.getString("camp_id") %>" />
                                        <input type="hidden" name="fest_naam" value="<%= strNaam %>" />
                                        <button type="submit">
                                                <img src="img/minus.png" alt="X" width="15px"/>
                                        </button>&nbsp;<%= rsCampFest.getString("camp_adres") %>
                                    </form>
                                </li>
                                <li><%= rsCampFest.getString("camp_cap") %></li>
                                <% } while (rsCampFest.next());
                                } else { %>
                                <li>Nog geen campings</li>
                                <% } %>
                            </ul>
                            <!--
                               CAMPING TOEVOEGEN
                            -->
                            <p class="menu">Camping toevoegen</p>
                            <div class="geen_lijst">
                                <form action="details/toev_camping.jsp" method="post">
                                <p style="margin-top: 0px !important; margin-bottom: 25px;">Camping:
                                <select id="camp_toev" class="inputveld" onchange="setDropDownValue(this, 'camp_id');"
                                        required oninvalid="setCustomValidity('Geen campings meer')"
                                        style="width: 190px;">
                                <% count = 0;
                                String strCId = "";
                                while (rsCampPFest.next()) {
                                    String strCampId = rsCampPFest.getString("camp_id");
                                    if (!alCampings.contains(strCampId)) { 
                                        if (count == 0) {
                                            strCId = strCampId;
                                            count++;
                                        }
                                        String strAdres = rsCampPFest.getString("camp_adres");
                                        String strAdresKort = strAdres.substring(0, strAdres.indexOf('-')-1).trim();
                                %>
                                <option value="<%= strCampId %>">
                                    <%= strAdresKort %>
                                </option>
                                <%  }
                                } %>
                                </select></p>
                                <!-- Hidden veld camp_id wordt opgevuld door javascript (select onchange) -->
                                <input type="hidden" name="fest_id" value="<%= rsFest.getString("fest_id") %>" />
                                <input type="hidden" id="camp_id" name="camp_id" value="<%= strCId %>" />
                                <input type="hidden" name="fest_naam" value="<%= strNaam %>" />
                                <input type="submit" id="toev_camping" name="submit" value="Toevoegen"
                                       style="margin-top: 5px; width: 100px;"/>
                                </form>
                            </div>
                            <!--
                               TICKETS VERWIJDEREN EN TOEVOEGEN 
                            -->
                            <p class="menu">Verwijder ticket</p>
                            <ul>
                                <!-- 
                                    Voor elk record in de tickets voor dit festival dynamisch een formulier aanmaken.
                                    Dit formulier dient om een ticket te verwijderen voor dit festival
                                -->
                                <% if (rsTickFest.next()) {
                                do { %>
                                <li>
                                    <form action="./details/wis_ticket.jsp" method="post">
                                        <input type="hidden" name="fest_id" value="<%= rsFest.getString("fest_id") %>" />
                                        <input type="hidden" name="fest_naam" value="<%= strNaam %>" />
                                        <input type="hidden" name="typ_id" value="<%= rsTickFest.getString("typ_id") %>" />
                                        <button type="submit">
                                            <img src="img/minus.png" alt="X" width="15px"/>
                                        </button>
                                        <%= rsTickFest.getString("typ_omschr") %>
                                    </form>
                                </li>
                                <li><%= rsTickFest.getString("typ_prijs") %></li>
                                <%  } while (rsTickFest.next());
                                } else { %> 
                                <li>Nog geen tickets</li>
                                <% } %>
                            </ul>
                            <p class="menu">Ticket toevoegen</p>
                            <div class="geen_lijst">
                                <form id="form_toev_ticket" name="toev_ticket" action="details/toev_ticket.jsp" method="post">
                                Type:&nbsp;
                                <!-- 
                                Controleren welke tickets nog niet gelinkt zijn aan dit festival en toevoegen aan het dropdown menu
                                -->
                                <select id="ticket_add" onchange="setDropDownValue(this, 'typ_id')" required oninvalid="setCustomValidity('Geen tickets meer')"
                                        style="width: 150px;">
                                <% 
                                count = 0;
                                val = "";
                                while (rsTickPFest.next()) {
                                    String strTypId = rsTickPFest.getString("typ_id");
                                    if (!alTickets.contains(strTypId)) { 
                                        if (count == 0) {
                                            val = strTypId;
                                            count++;
                                        }
                                 %>
                                    <option value="<%= strTypId %>">
                                        <%= rsTickPFest.getString("typ_omschr") %>
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
                                <input type="hidden" name="fest_naam" value="<%= strNaam %>" />
                                <input type="submit" id="toev_ticket" name="submit" value="Toevoegen"
                                       style="margin-top: 5px; width: 100px;"/>
                                </form>
                            </div>
                        </div>
                    </article>
                </section>
            </div>
            <% connectie.sluitConnectie(); %>
            <hr style="width: auto; margin-left: 20px; margin-right: 20px;" />
            <jsp:include page="voettekst.jsp" />
        </div>
    </body>
</html>