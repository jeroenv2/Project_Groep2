<%-- 
    Document   : layout
    Created on : 28-mrt-2013, 9:04:18
    Author     : robbie
--%>

<%@page import="java.net.URI"%>
<%@page import="java.net.URL"%>
<%@page import="java.io.File"%>
<%@page import="java.sql.SQLException"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.text.DateFormat"%>
<%@page import="java.util.Calendar"%>
<%@page import="java.text.ParseException"%>
<%@page import="java.util.Date"%>
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
                
            String strFouten = "";
            String strNaam = request.getParameter("band_naam");
            String strGenre = request.getParameter("band_soortMuziek");
            String strUrl = request.getParameter("band_url");
            String strId = request.getParameter("band_id");
                
            List<String> alLeeg = new ArrayList<String>();
            List<String> alParams = new ArrayList<String>();
            alParams.add(strNaam);
            alParams.add(strGenre);
            alParams.add(strUrl);
            alParams.add(strId);
            
            try {
                // Simpele update om de wijzigingen door te voeren
                connectie.voerVeranderingUit("UPDATE bands"
                + " SET band_naam = ?, band_soortMuziek = ?, band_url = ?"
                + " WHERE band_id = ?", alParams);
                
                // Dit laatste deel dient om de afbeeldingsnaam voor de band ter veranderen
                // zodat de afbeelding dynamisch kan worden ingeladen.
                
                // Eerst het pad ophalen waarin de server draait
                // (in localhost is dit in /build/web/... zodra gepubliceerd hoeft de replace("build/", "") niet meer!
                ServletContext info = session.getServletContext();
                String strAbsoluutPad = info.getRealPath("/").replace("build/", "") + "img/bands/";
                    
                // Vervolgens maken we een string met het absoluut pad naar de huidige afbeelding.
                String strAfbeelding = strAbsoluutPad 
                        + request.getParameter("orig_band_naam").toLowerCase().replace(" ", "_").replace("'", "") + ".jpg";
                // Dan een string met het absoluut pad naar waar de afbeelding komt te staan (in ons geval, zelfde map - andere naam)
                String strNieuwAfbeelding = strAbsoluutPad
                        + strNaam.toLowerCase().replace(" ", "_").replace("'", "") + ".jpg";
                            
                //Nu maken we twee File instantie aan (zelfde principe als de twee string strAfbeelding en strNieuwAfbeelding)
                File bestandAfbeelding = new File(strAfbeelding);
                File nieuwBestandAfbeelding = new File(strNieuwAfbeelding);
                // File.renameTo(File) is een functie die een bestand vervangd door een ander (gewoon hernoemen dus)
                boolean gelukt = bestandAfbeelding.renameTo(nieuwBestandAfbeelding);
            } catch(IllegalArgumentException ia) {
                strFouten = "[ARGUMENTEN]: Eén van de ingevoerde gegevens kloppen niet:<br />"
                + ia.getMessage();
            } catch(SQLException se) {
                strFouten = "[SQL]: Fout bij het uitvoeren van de query:<br />"
                + se.getMessage();
            } catch(Exception e) {
                strFouten = "[ONBEKEND]: Gegevens konden niet worden opgehaald:<br />"
                + e.getMessage();
                e.printStackTrace();
            }
            
        %>
        <% if (strFouten.equals("")) { %>
        <title><%= strNaam %> aangepast</title>
        <% } else { %>
        <title>Fout bij het aanpassen van <%= strNaam %></title>
        <% } %>
        <link rel="stylesheet" href="css/normalize.css">
        <link rel="stylesheet" href="css/main.css">
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
                <% boolean blFouten = !strFouten.equals(""); %>
                <section <% if (blFouten) { %>class="fout" <% } %> style="text-align: center;" id="inhoud">
                    <article>
                        <header>
                            <h1>
                            <% if (!blFouten) { %>
                                Gegevens opgeslagen
                            <% } else { %>
                                Er heeft zich een fout voorgedaan.
                            <% } %>
                            </h1>
                        </header>
                        <% if (!blFouten) { %>
                        <p>De gegevens zijn succesvol weggeschreven.</p>
                        <% } else { %>
                        <p>De gegevens konden niet worden weggeschreven</p>
                        <p><%= strFouten %></p>
                        <% } %>
                        <p>Klik <a style="color: palegreen;" href="./groepen.jsp">hier</a> om terug te keren naar het overzicht.</p>
                    </article>
                </section>
            </div>
            <hr style="width: auto; margin-left: 20px; margin-right: 20px;" />
            <jsp:include page="voettekst.jsp" />
        </div>
    </body>
</html>