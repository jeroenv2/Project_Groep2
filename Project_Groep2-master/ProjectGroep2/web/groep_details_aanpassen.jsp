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
            ResultSet rsBand = null, rsFestPBand = null;
            String strFouten = "", strNaam = request.getParameter("naam"), strFoto = "",
                    strSiteGroep="", strGenre = "", strUrl = "", strId = "";
            Connectie_Databank connectie = null;
            
            // Bean voor gebruikergegevens
            beans.gegevensGebruiker gebruiker = (beans.gegevensGebruiker) session.getAttribute("gegevensGebruiker");
                
            try {
                connectie = new Connectie_Databank();

                connectie.maakConnectie();
                List<String> alParams = new ArrayList<String>();
                List<String> alLeeg = new ArrayList<String>();
                alParams.add(strNaam);

                //ResultSet aanmaken voor de gekozen band
                connectie.voerQueryUit("SELECT band_id, band_soortMuziek, band_url"
                + " FROM bands"
                + " WHERE band_naam = ?", alParams);
                rsBand = connectie.haalResultSetOp();
                rsBand.first();
                
                // Bandnaam niet meer nodig, verwijderen en vervangen door band_id
                alParams.remove(0);
                strId = rsBand.getString("band_id");
                alParams.add(strId);
                    
                connectie.voerQueryUit("SELECT f.fest_naam"
                + " FROM festivals f"
                + " JOIN bandsperfestival bf ON f.fest_id = bf.fest_id"
                + " WHERE bf.band_id = ?", alParams);
                rsFestPBand = connectie.haalResultSetOp();
                    
                //Hergebruikte Strings
                strSiteGroep = rsBand.getString("band_url");
                strGenre = rsBand.getString("band_soortMuziek");
                strUrl = rsBand.getString("band_url");
                strFoto = strNaam.toLowerCase().replace(" ", "_").replace("'", "");
            } catch(SQLException se){
                strFouten = "[SQL]: Fout bij het uitvoeren van de query:<br />"
                + se.getMessage();
            } catch(Exception e) {
                strFouten = "[ONBEKEND]: Gegevens konden niet worden opgehaald:<br />"
                + e.getMessage();
            }
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
        <script type="text/javascript" src="js/uploadify/jquery.uploadify-3.1.min.js"></script>
    </head>
    <body>
        <div id="pagina_omslag">
            <jsp:include page="hoofding.jsp" />
            <jsp:include page="navigatie.jsp" />
            <div id="inhoud_omslag">
                <section id="inhoud">
                    <% if (strFouten.equals("")) { %>
                    <article id="foto">
                        <img src="img/bands/<%= strFoto %>.jpg"
                             alt="<%= strFoto %>" width="95%"
                             draggable="true"
                        />
                    </article>
                    <article id="details">

                        <header>
                            <h2><%=strNaam%></h2>
                        </header>
                        
                        <!--
                            In principe het zelfde formulier als bij banddetails, maar met invoervelden met de actuele gegevens in.
                        -->
                        <form action="groep_details_aanpassen_resultaat.jsp" method="post">
                        <table >
                            <tbody>
                                <tr>
                                    <td >Naam:</td>
                                    <td><input type="text" id="txtBandNaam" name="band_naam" value="<%= strNaam %>" 
                                               required title="Geef de bandnaam" /></td>
                                </tr>
                                <tr style="padding-bottom: 20px;">
                                    <td>Genre:</td>
                                    <td><input type="text" id="txtBandGenre" name="band_soortMuziek" value="<%= strGenre %>" 
                                               required title="Geef het genre" /></td>
                                </tr>
                                <tr>
                                    <td>Website:</td>
                                    <% if (strUrl != null) {%>
                                    <td><input type="text" id="murl" name="band_url" value="<%= strUrl %>"
                                               pattern="(http:\/\/|https:\/\/)?www\.?([a-zA-Z0-9_%]*)\.[a-zA-Z]{1}[a-zA-Z]+"
                                               title="http:// of https:// + A-Z + .A-Z"/></td>
                                    <%} else {%>
                                    <td><input type="url" id="zurl" name="band_url" value="" /></td>
                                    <%}%>
                                </tr>
                                <% if (gebruiker != null) { %>
                                <tr>
                                    <td colspan="2">
                                        <input type="hidden" name="orig_band_naam" value="<%= strNaam %>" />
                                        <input type="hidden" name="band_id" value="<%= strId %>">
                                        <input type="submit" name="bandedit" value="Gegevens opslaan"
                                               style="width: 435px; margin-top: 10px;"/>
                                    </td>
                                </tr>
                                <% } %>
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
                               Overzicht festivals 
                            -->        <jsp:useBean id="date" scope="page" class="beans.datumBean" />
                           <div id="lijsten" data-collapse="persist">
                           <p class="open menu">Festivals</p>
                            <ul class="enkel_kolom">
                            <% if (rsFestPBand.next()) {
                                  do {%>
                                <li><form action="festival_details.jsp" method="post">
                                    <input type="hidden" name="naam" value="<%= rsFestPBand.getString("fest_naam") %>" />
                                    <a href="javascript:;" onclick="parentNode.submit();"><%= rsFestPBand.getString("fest_naam") %></a>
                                    </form></li>
                               <% } while(rsFestPBand.next());
                                } else {%>
                                <li>Nog geen festivals</li>
                            <% } %>
                            </ul>
                        </div>
                    </article>
                    <% } else { %>
                    <article style="max-width: 900px;">
                        <p style="max-width: 900px;">
                        <%= strFouten %>
                        </p>
                    </article>
                    <% } %>
                </section>
            </div>
            <% connectie.sluitConnectie(); %>
            <hr style="width: auto; margin-left: 20px; margin-right: 20px;" />
            <jsp:include page="voettekst.jsp" />
        </div>
    </body>
</html>