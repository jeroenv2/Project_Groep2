<%-- 
    Document   : layout
    Created on : 28-mrt-2013, 9:04:18
    Author     : robbie
--%>

<%@page import="java.io.File"%>
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
        <jsp:useBean id="date" scope="page" class="beans.datumBean" />
        <%
            Connectie_Databank connectie = new Connectie_Databank();

            connectie.maakConnectie();
                
            String strFouten = "";
            String strNaam = request.getParameter("fest_naam");
            String strLand = request.getParameter("land");
            String strGemeente = request.getParameter("gemeente");
            String strBeginDatum = request.getParameter("fest_datum");
            String strEindDatum = request.getParameter("fest_einddatum");
            String strDateFout = "";
            String strDuur = "";
            //Verschil tussen begin en einddatum bereken (voor de duur vh festival) met bean datumBean
            try { %>
                <jsp:setProperty name="date" property="strBegin" value="<%= strBeginDatum %>" />
                <jsp:setProperty name="date" property="strEind" value="<%= strEindDatum %>" />
                <%
                strDuur = "" + %><jsp:scriptlet> date.getDuur(); </jsp:scriptlet><%;
            } catch (IllegalArgumentException ia) {
                strFouten += "<p id=\"error\">De ingegeven datum(s) "+ strDateFout + " zijn/is niet correct</p>\n";
            } catch (ParseException pa) {
                strFouten += "<p id=\"error\">De ingegeven datum(s) "+ strDateFout + " zijn/is niet correct</p>\n";
            }
                
            String strUrl = request.getParameter("fest_url");
            String strLocatie = strGemeente + " - " + strLand;
            String strId = request.getParameter("fest_id");
                
            List<String> alLeeg = new ArrayList<String>();
            List<String> alParams = new ArrayList<String>();
            alParams.add(strNaam);
            alParams.add(strLocatie);
            alParams.add(strBeginDatum);
            alParams.add(strDuur);
            alParams.add(strEindDatum);
            alParams.add(strUrl);
            alParams.add(strId);
            
            if (!strDuur.equals("")) {
                try {
                    connectie.voerVeranderingUit("UPDATE festivals"
                    + " SET fest_naam = ?, fest_locatie = ?, fest_datum = ?, fest_duur = ?, fest_einddatum = ?, fest_url = ?"
                    + " WHERE fest_id = ?", alParams);
                } catch (Exception e) {
                    strFouten += "<p id=\"error\">Niet alle gegevens zijn correct, melding:<br />" + e.getMessage() + "</p>\n";
                }
            } else {
                strFouten += "<p id=\"error\">De duur van het festival kon niet worden berekend.</p>\n";
            }
            
                // Dit laatste deel dient om de afbeeldingsnaam voor het festival ter veranderen
                // zodat de afbeelding dynamisch kan worden ingeladen.
                
                // Eerst het pad ophalen waarin de server draait
                // (in localhost is dit in /build/web/... zodra gepubliceerd hoeft de replace("build/", "") niet meer!
                ServletContext info = session.getServletContext();
                String strAbsoluutPad = info.getRealPath("/").replace("build/", "") + "img/festivals/";
                    
                // Vervolgens maken we een string met het absoluut pad naar de huidige afbeelding.
                String strAfbeelding = strAbsoluutPad 
                        + request.getParameter("orig_fest_naam").toLowerCase().replace(" ", "_").replace("'", "") + ".jpg";
                // Dan een string met het absoluut pad naar waar de afbeelding komt te staan (in ons geval, zelfde map - andere naam)
                String strNieuwAfbeelding = strAbsoluutPad
                        + strNaam.toLowerCase().replace(" ", "_").replace("'", "") + ".jpg";
                            
                //Nu maken we twee File instantie aan (zelfde principe als de twee string strAfbeelding en strNieuwAfbeelding)
                File bestandAfbeelding = new File(strAfbeelding);
                File nieuwBestandAfbeelding = new File(strNieuwAfbeelding);
                // File.renameTo(File) is een functie die een bestand vervangd door een ander (gewoon hernoemen dus)
                boolean gelukt = bestandAfbeelding.renameTo(nieuwBestandAfbeelding);
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
                <section id="inhoud">
                    <article>
                        <header>
                            <h1>
                            <% if (strFouten.equals("")) { %>
                                Gegevens opgeslagen
                            <% } else { %>
                                Er heeft zich een fout voorgedaan.
                            <% } %>
                            </h1>
                        </header>
                        <% if (strFouten.equals("")) { %>
                        <p>De gegevens zijn succesvol weggeschreven.</p>
                        <% } else { %>
                        <p>De gegevens konden niet worden weggeschreven</p>
                        <p><%= strFouten %></p>
                        <% } %>
                        <p>Klik <a href="./festivals.jsp">hier</a> om terug te keren naar het overzicht.</p>
                    </article>
                </section>
            </div>
            <hr style="width: auto; margin-left: 20px; margin-right: 20px;" />
            <jsp:include page="voettekst.jsp" />
        </div>
    </body>
</html>