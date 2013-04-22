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
<html>
    <!--<![endif]-->
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <%
            // Als de methode van het geposte formulier niet POST is, heeft de gebruiker het
            // formulier in festival_details_aanpassen.jsp niet gepost.
            if (!"POST".equalsIgnoreCase(request.getMethod())) {
                response.sendRedirect("./");
                return;
            }
           
            String browser = request.getHeader("User-Agent");
            String strFouten = "", strNaam = "";
            int intCapaciteit = 0;
            List<String> alParams = null, alLeeg = null;
            ResultSet rsFest = null, rsBandPFest = null, rsCampPFest = null, rsTickets = null;
            beans.gegevensGebruiker gebruiker = (beans.gegevensGebruiker) session.getAttribute("gegevensGebruiker");
            try {
                
                Connectie_Databank connectie = new Connectie_Databank();
                strNaam = request.getParameter("naam");
                connectie.maakConnectie();
                alParams = new ArrayList<String>();
                alLeeg = new ArrayList<String>();
                alParams.add(strNaam);

                strFouten = "Het festival '" + strNaam + "' werd niet gevonden";
                //ResultSet aanmaken voor het gekozen festival
                connectie.voerQueryUit("SELECT fest_id, fest_naam, fest_locatie, fest_datum, fest_duur, fest_einddatum, fest_url"
                        + " FROM festivals f"
                        + " WHERE f.fest_naam = ?", alParams);
                rsFest = connectie.haalResultSetOp();
                rsFest.first();
                    
                alParams.remove(0);
                alParams.add(rsFest.getString("fest_id"));
                    
                strFouten = "Fout bij het ophalen van geregistreerde groepen voor " + strNaam;
                //ResultSet aanmaken voor alle groepen van op het festival
                connectie.voerQueryUit("SELECT b.band_naam, p.pod_omschr"
                + " FROM bands b"
                + " JOIN bandsperfestival bf ON b.band_id = bf.band_id"
                + " JOIN podia p ON p.pod_id = bf.pod_id"
                + " WHERE fest_id = ?", alParams);
                rsBandPFest = connectie.haalResultSetOp();

                strFouten = "Fout bij het ophalen van geregistreerde campings voor " + strNaam;
                //ResultSet aanmaken voor alle campings van een festival
                connectie.voerQueryUit("SELECT c.camp_adres, c.camp_cap"
                + " FROM campings c"
                + " JOIN campingsperfestival cf ON c.camp_id = cf.camp_id"
                + " WHERE fest_id = ?", alParams);
                rsCampPFest = connectie.haalResultSetOp();

                //Capaciteit van campings ophalen
                intCapaciteit = 0;
                while (rsCampPFest.next()) {
                    intCapaciteit += Integer.parseInt(rsCampPFest.getString("camp_cap"));
                }
                rsCampPFest.beforeFirst();

                strFouten = "Fout bij het ophalen van geregistreerde tickettypes voor " + strNaam;
                //ResultSet aanmaken voor alle tickettypes beschikbaar op een festival
                connectie.voerQueryUit("SELECT tt.typ_omschr, tt.typ_prijs"
                + " FROM tickettypes tt"
                + " JOIN tickettypesperfestival ttf ON tt.typ_id = ttf.typ_id"
                + " WHERE fest_id = ?", alParams);
                rsTickets = connectie.haalResultSetOp();
                    
                strFouten = "";
            } catch (NullPointerException np) {
                strFouten += "<p id=\"error\">[NULLPOINTER]: " + strFouten + ":<br />" + np.getMessage() + "</p>\n";
            } catch (IllegalArgumentException ia) {
                strFouten += "<p id=\"error\">[ARGUMENTEN]: " + strFouten + ":<br />" + ia.getMessage() + "</p>\n";
            } catch (SQLException se) {
                strFouten += "<p id=\"error\">[SQL]: " + strFouten + ":<br />" + se.getMessage() + "</p>\n";
            } catch (Exception e) {
                strFouten += "<p id=\"error\">[ONBEKEND]: " + strFouten + ":<br />" + e.getMessage() + "</p>\n";
            }
        %>
        <title><%= rsFest.getString(2) %> - Details</title>
        <link rel="stylesheet" href="css/normalize.css">
        <link rel="stylesheet" href="css/main.css">
        <% if (browser.contains("mie")) { %>
        <link rel="stylesheet" href="css/ie_uitzonderingen.css">
        <% } else { %>
        <link rel="stylesheet" href="css/detail_pagina.css">
        <% } %>
        <script src="js/vendor/modernizr-2.6.2.min.js"></script>
        <script src="http://ajax.googleapis.com/ajax/libs/jquery/1.7.2/jquery.min.js"></script>
        <script src="js/vendor/jquery.collapse.js"></script>
        <script src="js/vendor/jquery.collapse_storage.js"></script>
        <script src="js/vendor/jquery.collapse_cookie_storage.js"></script>
    </head>
    <body>
        <div id="pagina_omslag">
            <jsp:include page="hoofding.jsp" />
            <jsp:include page="navigatie.jsp" />
            <div id="inhoud_omslag">
                <% if (strFouten.equals("")) { %>
                <section id="inhoud">
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
                            <h2><%= rsFest.getString("fest_naam") %></h2>
                        </header>
                        
                        <table>
                            <tbody>
                                <tr>
                                    <td>Land:</td>
                                    <td><%= land %></td>
                                </tr>
                                <tr>
                                    <td>Locatie:</td>
                                    <td><%= gemeente %></td>
                                </tr>
                                <tr>
                                    <td>Startdatum:</td>
                                    <td><%= rsFest.getString("fest_datum") %></td>
                                </tr>
                                <tr>
                                    <td>Einddatum:</td>
                                    <td><%= rsFest.getString("fest_einddatum") %></td>
                                </tr>
                                <tr>
                                    <td>Duur:</td>
                                    <td><%= rsFest.getInt("fest_duur") %> dagen</td>
                                </tr>
                                <tr>
                                    <td>Website:</td>
                                    <%  String strUrl = rsFest.getString("fest_url");
                                    if (strUrl != null) {%>
                                    <td><a href="http://<%=strUrl%>" target="_blank"><%= strUrl %></a></td>
                                    <%} else {%>
                                    <td>Niet beschikbaar</td>
                                    <%}%>
                                </tr>
                                <tr>
                                    <td style="padding-right: 25px;">Capaciteit camping:</td>
                                    <td><%= intCapaciteit %></td>
                                </tr>
                                <% if (gebruiker != null) { %>
                                <tr>
                                    <td colspan="2">
                                        <form action="festival_details_aanpassen.jsp" method="POST">
                                            <input type="hidden" name="naam" value="<%=request.getParameter("naam")%>">
                                            <input type="submit" name="festedit" value="Festival aanpassen"
                                                   style="width: 435px; margin-top: 10px;"/>
                                        </form>
                                    </td>
                                </tr>
                                <% } %>
                            </tbody>
                        </table>
                    </article>
                    <article id="overzicht">
                        <header>
                            <h2>Overzicht</h2>
                        </header>
                        <div id="lijsten" data-collapse="persist">
                            <p class="open menu">Groepen</p>
                            <ul>
                                <% if (rsBandPFest.next()) {
                                do { %>
                                <li><form action="groep_details.jsp" method="post">
                                    <input type="hidden" name="naam" value="<%= rsBandPFest.getString("band_naam") %>" />
                                    <a href="javascript:;" onclick="parentNode.submit();"><%= rsBandPFest.getString("band_naam") %></a>
                                    </form></li>
                                <li><%= rsBandPFest.getString("pod_omschr") %></li>
                                <%  } while (rsBandPFest.next());
                                } else { %>
                                <li>Nog geen groepen</li>
                                <% }%>
                            </ul>
                            <p class="menu">Campings</p>
                            <ul>
                                <% if (rsCampPFest.next()) {
                                do { %>
                                <li><%= rsCampPFest.getString("camp_adres") %></li>
                                <li><%= rsCampPFest.getString("camp_cap") %></li>
                                <%  } while (rsCampPFest.next());
                                } else { %>
                                <li>Nog geen campings</li>
                                <% } %>
                            </ul>
                            <p class="menu">Tickets</p>
                            <ul>
                                <% if (rsTickets.next()) {
                                do { %>
                                <li><%= rsTickets.getString("typ_omschr") %></li>
                                <li><%= rsTickets.getString("typ_prijs") %> €</li>
                                <%  } while (rsTickets.next());
                                } else { %>
                                <li>Nog geen tickets</li>
                                <% }%>
                            </ul>
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
            <hr style="width: auto; margin-left: 20px; margin-right: 20px;" />
            <jsp:include page="voettekst.jsp" />
        </div>
    </body>
</html>