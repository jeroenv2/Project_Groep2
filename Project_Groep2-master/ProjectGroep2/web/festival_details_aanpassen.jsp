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
            String strOrigNaam = request.getParameter("naam"); // Dit is de naam van het festival voor de wijziging
            String strFoto = "", strBrowser = "", strFouten = "";
            String browser = request.getHeader("User-Agent");
            // Lijsten die gebruikt worden om te bepalen welke gegevens gemanipuleerd kunnen worden.
            List<String> alParams = null, alLeeg = null, alBands = null, 
                         alCampings = null, alTickets = null;
            // De klasse waarin alle databasequeries afgehandeld worden
            Connectie_Databank connectie = new Connectie_Databank();
            // Volgende resultsets halen basisinformatie over een festival op
            ResultSet rsFest = null, rsBandsFest = null, rsCampFest = null, rsTickFest = null;
            // Volgende resultsets halen beschikbare informatie op om toe te voegen
            ResultSet rsTickPFest = null, rsPodPFest = null, rsCampPFest = null, rsBandsPFest = null;

            try {
                connectie.maakConnectie();
                alParams = new ArrayList<String>(); // Lijst die alle parameters voor een query zal bevatten
                alLeeg = new ArrayList<String>(); // Lege lijst om queries zonder parameter te voltooien
                alParams.add(strOrigNaam); // De originele naam is nodig om gegevens over het festival op te halen
                
                strFouten = "Het festival '" + strOrigNaam + "' werd niet gevonden";
                // ResultSet aanmaken voor het gekozen festival
                connectie.voerQueryUit("SELECT fest_id, fest_naam, fest_locatie, fest_datum, fest_duur, fest_einddatum, fest_url"
                        + " FROM festivals"
                        + " WHERE fest_naam = ?", alParams);
                rsFest = connectie.haalResultSetOp();
                rsFest.first();
                    
                try {
                    // Om te testen of de gebruiken per ongeluk op deze pagina terecht gekomen is
                    String strTestHeaderManipulatie = rsFest.getString("fest_id");
                } catch (SQLException se) { 
                    response.sendRedirect("./"); // Herleiden naar de home pagina
                }

                // fest_naam niet meer nodig -> verwijderen en fest_id in de plaats
                alParams.remove(0);
                alParams.add(rsFest.getString("fest_id"));

                strFouten = "Fout bij het ophalen van geregistreerde groepen voor " + strOrigNaam;
                // ResultSet aanmaken voor alle groepen van op het festival
                connectie.voerQueryUit("SELECT b.band_id, b.band_naam, p.pod_id, p.pod_omschr"
                + " FROM bands b"
                + " JOIN bandsperfestival bf ON b.band_id = bf.band_id"
                + " JOIN podia p ON p.pod_id = bf.pod_id"
                + " WHERE fest_id = ?", alParams);
                rsBandsFest = connectie.haalResultSetOp();

                //Lijst aanmaken met alle band_id's voor later... zie groepen toevoegen/verwijderen
                alBands = new ArrayList<String>();
                while(rsBandsFest.next()) {
                    alBands.add(rsBandsFest.getString("band_id"));
                }
                rsBandsFest.beforeFirst();

                strFouten = "Fout bij het ophalen van geregistreerde campings voor " + strOrigNaam;
                //ResultSet aanmaken voor alle campings van een festival
                connectie.voerQueryUit("SELECT c.camp_id, c.camp_adres, c.camp_cap"
                + " FROM campings c"
                + " JOIN campingsperfestival cf ON c.camp_id = cf.camp_id"
                + " WHERE fest_id = ?", alParams);
                rsCampFest = connectie.haalResultSetOp();

                alCampings = new ArrayList<String>();
                while (rsCampFest.next()) {
                    alCampings.add(rsCampFest.getString("camp_id"));
                }
                rsCampFest.beforeFirst();

                strFouten = "Fout bij het ophalen van geregistreerde tickets voor " + strOrigNaam;
                //ResultSet aanmaken voor alle tickettypes beschikbaar op een festival
                connectie.voerQueryUit("SELECT tt.typ_id, tt.typ_omschr, tt.typ_prijs"
                + " FROM tickettypes tt"
                + " JOIN tickettypesperfestival ttf ON tt.typ_id = ttf.typ_id"
                + " WHERE fest_id = ?", alParams);
                rsTickFest = connectie.haalResultSetOp();

                //Lijst aanmaken met alle typ_id's voor later... zie tickets toevoegen/verwijderen
                alTickets = new ArrayList<String>();
                while(rsTickFest.next()) {
                    alTickets.add(rsTickFest.getString("typ_id"));
                }
                rsTickFest.beforeFirst();

                strFouten = "Fout bij het ophalen van beschikbare tickets voor " + strOrigNaam;
                //Alle tickettypes ophalen om te linken aan dit festival -> zie tickets toevoegen
                connectie.voerQueryUit("SELECT * FROM tickettypes", alLeeg);
                rsTickPFest = connectie.haalResultSetOp();

                strFouten = "Fout bij het ophalen van beschikbare  groepen voor " + strOrigNaam;
                //Alle groepen ophalen om te linken aan dit festival -> zie groepen toevoegen
                connectie.voerQueryUit("SELECT bf.band_id, b.band_naam"
                + " FROM bandsperfestival bf"
                + " JOIN bands b ON bf.band_id = b.band_id"
                + " GROUP BY b.band_naam", alLeeg);
                rsBandsPFest = connectie.haalResultSetOp();

                strFouten = "Fout bij het ophalen van beschikbare podia voor " + strOrigNaam;
                //Alle beschikbare podia ophalen om te linken aan dit festival -> zie groepen toevoegen
                connectie.voerQueryUit("SELECT pod_omschr, pod_id"
                + " FROM podia", alLeeg);
                rsPodPFest = connectie.haalResultSetOp();

                strFouten = "Fout bij het ophalen van beschikbare campings voor " + strOrigNaam;
                //Alle beschikbare campings ophalen om te linken aan dit festival -> zie camping toevoegen
                connectie.voerQueryUit("SELECT *"
                + " FROM campings", alLeeg);
                rsCampPFest = connectie.haalResultSetOp();

                // Veelgebruikte Strings
                strBrowser = request.getHeader("User-Agent");
                strFoto = strOrigNaam.toLowerCase().replace(" ", "_").replace("'", "");
                strFouten = "";
            } catch (IllegalArgumentException ia) {
                strFouten += "<p id=\"error\">[ARGUMENTEN]: " + strFouten + ":<br />" + ia.getMessage() + "</p>\n";
            } catch (SQLException se) {
                strFouten += "<p id=\"error\">[SQL]: " + strFouten + ":<br />" + se.getMessage() + "</p>\n";
            } catch (Exception e) {
                strFouten += "<p id=\"error\">[ONBEKEND]: " + strFouten + ":<br />" + e.getMessage() + "</p>\n";
            }
        %>
        <title><%= strOrigNaam %> - Details</title>
        <link rel="stylesheet" href="css/normalize.css">
        <link rel="stylesheet" href="css/main.css">
        <% if (browser.contains("MSIE")) { %>
        <link rel="stylesheet" href="css/ie_uitzonderingen.css">
        <% } else { %>
        <link rel="stylesheet" href="css/detail_pagina.css">
        <% } %>
        <script src="js/vendor/modernizr-2.6.2.min.js"></script>
        <script src="http://ajax.googleapis.com/ajax/libs/jquery/1.7.2/jquery.min.js"></script>
        <script src="js/vendor/jquery.collapse.js"></script>
        <script src="js/vendor/jquery.collapse_storage.js"></script>
        <script src="js/vendor/jquery.collapse_cookie_storage.js"></script>
        <script type="text/javascript" src="js/uploadify/jquery.uploadify-3.1.min.js"></script>
    </head>
    <body>
        <div id="pagina_omslag">
            <jsp:include page="hoofding.jsp" />
            <jsp:include page="navigatie.jsp" />
            <div id="inhoud_omslag">
                <% if (strFouten.equals("")) { %>
                <section id="inhoud">
                    <article id="foto">
                        <img src="img/festivals/<%= strFoto %>.jpg"
                             alt="<%= strFoto %>" width="95%"
                             draggable="true"
                        />
                    </article>
                    <article id="details">
                        <%
                            // Gemeente en land scheiden in locatie
                            String strLand = "";
                            String strGemeente = "";
                            String strLocatie = rsFest.getString("fest_locatie");
                                
                            int intSplits = strLocatie.indexOf(" - ");
                            strGemeente = strLocatie.substring(0, intSplits).trim();
                            strLand = strLocatie.substring(intSplits + 2, strLocatie.length()).trim();
                        %>
                        <header>
                            <h2><%= strOrigNaam %></h2>
                        </header>
                        
                        <!--
                            In principe het zelfde formulier als bij festivaldetails, maar met invoervelden met de actuele gegevens in.
                        -->
                        <form action="festival_details_aanpassen_resultaat.jsp" method="post">
                        <table>
                            <tbody>
                                <tr>
                                    <td>Naam:</td>
                                    <td><input type="text" id="txtNaam" name="fest_naam" value="<%= strOrigNaam %>" 
                                               required title="Geef een festivalnaam." /></td>
                                </tr>
                                <tr>
                                    <td>Land:</td>
                                    <td><input type="text" id="txtland" name="land" value="<%= strLand %>" 
                                               required title="Vul een land in." /></td>
                                </tr>
                                <tr>
                                    <td>Locatie:</td>
                                    <td><input type="text" id="txtgemeente" name="gemeente" value="<%= strGemeente %>"
                                               required title="Vul en gemeente in." /></td>
                                </tr>
                                <tr>
                                    <td>Startdatum:</td>
                                    <td><input type="date" id="dtBDatum" name="fest_datum" value="<%= rsFest.getString("fest_datum") %>"
                                               required pattern="\d{4}-\d{2}-\d{2}" title="jjjj-mm-dd" /></td>
                                </tr>
                                <tr>
                                    <td>Einddatum:</td>
                                    <td><input type="date" id="dtEDatum" name="fest_einddatum" value="<%= rsFest.getString("fest_einddatum") %>"
                                               required pattern="\d{4}-\d{2}-\d{2}" title="jjjj-mm-dd" /></td>
                                </tr>
                                <tr>
                                    <td>Website:</td>
                                    <%  String website = rsFest.getString("fest_url");
                                    if (website != null) {%>
                                    <td><input type="url" id="txtMUrl" name="fest_url" value="<%= website %>"/></td>
                                    <%} else {%>
                                    <td><input type="url" id="txtZUrl" name="fest_url" value="" /></td>
                                    <%}%>
                                </tr>
                                <tr>
                                    <td colspan="2">
                                        <input type="hidden" name="fest_id" value="<%= rsFest.getString("fest_id") %>" />
                                        <input type="hidden" name="orig_fest_naam" value="<%= strOrigNaam %>" />
                                        <input type="submit" id="btnPasAan" name="festsave" value="Gegevens opslaan"
                                               style="width: 435px; margin-top: 10px;"/>
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
                                        <input type="hidden" name="fest_naam" value="<%= strOrigNaam %>" />
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
                                <select id="sel_groep_toev" name="band_id" class="inputveld"
                                        required oninvalid="setCustomValidity('Geen groepen meer')"
                                        style="width: 150px;">
                                <!-- Controleren welke groepen nog niet gelinkt zijn aan dit festival en toevoegen aan het dropdown menu -->
                                <% 
                                    while (rsBandsPFest.next()) {
                                        String strBandId = rsBandsPFest.getString("band_id");
                                        if (!alBands.contains(strBandId)) { 
                                 %>
                                    <option value="<%= strBandId %>">
                                        <%= rsBandsPFest.getString("band_naam") %>
                                    </option>
                                    <% }
                                    } %>
                                </select></p>
                                <p>Podium:</p>
                                <p><select id="pod_toev" name="pod_id" class="inputveld">
                                <% 
                                    while (rsPodPFest.next()) {
                                        String strPodId = rsPodPFest.getString("pod_id");
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
                                <input type="hidden" name="fest_naam" value="<%= strOrigNaam %>" />
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
                                        <input type="hidden" name="fest_naam" value="<%= strOrigNaam %>" />
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
                                <select id="camp_toev" class="inputveld" name="camp_id"
                                        required oninvalid="setCustomValidity('Geen campings meer')"
                                        style="width: 190px;">
                                <%
                                while (rsCampPFest.next()) {
                                    String strCampId = rsCampPFest.getString("camp_id");
                                    if (!alCampings.contains(strCampId)) { 
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
                                <input type="hidden" name="fest_naam" value="<%= strOrigNaam %>" />
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
                                        <input type="hidden" name="fest_naam" value="<%= strOrigNaam %>" />
                                        <input type="hidden" name="typ_id" value="<%= rsTickFest.getString("typ_id") %>" />
                                        <button type="submit">
                                            <img src="img/minus.png" alt="X" width="15px"/>
                                        </button>
                                        <%= rsTickFest.getString("typ_omschr") %>
                                    </form>
                                </li>
                                <li><%= rsTickFest.getString("typ_prijs") %> €</li>
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
                                <select id="ticket_add" name="typ_id"
                                        required oninvalid="setCustomValidity('Geen tickets meer')"
                                        style="width: 150px;">
                                <% 
                                while (rsTickPFest.next()) {
                                    String strTypId = rsTickPFest.getString("typ_id");
                                    if (!alTickets.contains(strTypId)) { 
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
                                <input type="hidden" name="fest_naam" value="<%= strOrigNaam %>" />
                                <input type="submit" id="toev_ticket" name="submit" value="Toevoegen"
                                       style="margin-top: 5px; width: 100px;"/>
                                </form>
                            </div>
                        </div>
                    </article>
                </section>
                <% } else { %>
                <section class="fout">
                    <h2>Helaas</h2>
                    <p>Een fout belet u om deze pagina te bezoeken.</p>
                    <%= strFouten %>
                </section>
                <% } %>
            </div>
            <% connectie.sluitConnectie(); %>
            <hr style="width: auto; margin-left: 20px; margin-right: 20px;" />
            <jsp:include page="voettekst.jsp" />
        </div>
    </body>
</html>