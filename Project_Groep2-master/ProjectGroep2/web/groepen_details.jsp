<%-- 
    Document   : layout
    Created on : 28-mrt-2013, 9:04:18
    Author     : anke
--%>

<%@page import="java.sql.SQLException"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="Databank.Connectie_Databank" %>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.sql.ResultSetMetaData"%>
<%@page import="java.util.List"%>
<%@page import="com.mysql.jdbc.StringUtils"%>
<%!String MuziekSoort, SiteGroep;%>
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
            // Bean voor gebruikergegevens
            beans.gegevensGebruiker gebruiker = (beans.gegevensGebruiker) session.getAttribute("gegevensGebruiker");
                
            String strFouten = "", strBandNaam = "";
            ResultSet rsBand = null, rsFestPBand = null;
            try {
                strBandNaam = request.getParameter("naam");
                Connectie_Databank connectie = new Connectie_Databank();
                connectie.maakConnectie();
                List<String> alParams = new ArrayList<String>();
                alParams.add(strBandNaam);
                    
                connectie.voerQueryUit("SELECT band_id, band_soortMuziek, band_url"
                + " FROM bands"
                + " WHERE band_naam = ?", alParams);
                rsBand = connectie.haalResultSetOp();
                rsBand.beforeFirst();
                
                if (rsBand.next()) {
                    MuziekSoort = rsBand.getString("band_soortMuziek");
                    SiteGroep = rsBand.getString("band_url");
                    alParams.remove(0);
                    alParams.add(rsBand.getString("band_id"));
                }
                
                // Bandnaam niet meer nodig, vervangen door band_id                    
                connectie.voerQueryUit("SELECT f.fest_naam"
                + " FROM festivals f"
                + " JOIN bandsperfestival bf ON f.fest_id = bf.fest_id"
                + " WHERE bf.band_id = ?", alParams);
                rsFestPBand = connectie.haalResultSetOp();
                    
            } catch (IllegalArgumentException ia) {
                strFouten = "[ARGUMENTEN]: Een van de opgegeven argumenten waren niet correct:<br />"
                + ia.getMessage();
            } catch(SQLException se){
                strFouten = "[SQL]: Fout bij het uitvoeren van een query:<br />"
                + se.getMessage();
            } catch(Exception e) {
                strFouten = "[ONBEKEND]: Gegevens konden niet worden opgehaald:<br />"
                + e.getMessage();
            } %>
       
        <title><%= strBandNaam %> - Details</title>
        <link rel="stylesheet" href="css/normalize.css">
        <link rel="stylesheet" href="css/main.css">
        <link rel="stylesheet" href="css/detail_pagina.css">
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
                <section id="inhoud">
                    <% if (strFouten.equals("")) { %>
                    <article id="foto">
                        <% 
                            String foto = strBandNaam.toLowerCase().replace(" ", "_").replace("'", "");
                        %>
                        <img src="img/bands/<%= foto %>.jpg"
                             alt="<%= foto %>" width="95%"
                             draggable="true" />
                    </article>
                    <article id="details">
                        <header>
                            <h2> <%= strBandNaam %></h2>
                        </header>
                        <table >
                            <tbody>
                                <tr>
                                    <td >Naam:</td>
                                    <td><%= strBandNaam %> </td>
                                </tr>
                                <tr style="padding-bottom: 20px;">
                                    <td>Genre:</td>
                                    <td><%= MuziekSoort %></td>
                                </tr>
                                <tr>
                                    <td colspan="2" style="padding-top: 15px !important;">
                                        <a href="http://<%= SiteGroep %>" target="_blank">Site Groep</a>
                                    </td>
                                </tr>
                                <% if (gebruiker != null) { %>
                                <tr>
                                    <td colspan="2">
                                        <form action="band_details_aanpassen.jsp" method="POST">
                                            <input type="hidden" name="naam" value="<%= strBandNaam %>">
                                            <input type="submit" name="bandedit" value="Band aanpassen"
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
                            <p class="open menu">Festivals</p>
                            <ul  >
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
            <hr style="width: auto; margin-left: 20px; margin-right: 20px;" />
            <jsp:include page="voettekst.jsp" />
        </div>
    </body>
</html>