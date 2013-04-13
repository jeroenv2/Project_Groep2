<%-- 
    Document   : layout
    Created on : 28-mrt-2013, 9:04:18
    Author     : robbie
--%>

<%@page import="java.sql.Date"%>
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
            String strNaam = request.getParameter("fest_naam");
            String strLand = request.getParameter("land");
            String strGemeente = request.getParameter("gemeente");
            String strBeginDatum = request.getParameter("fest_datum");
            String strEindDatum = request.getParameter("fest_einddatum");
            String strDuur = request.getParameter("fest_duur");
            String strUrl = request.getParameter("website");
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
            
            try {
                connectie.voerUpdateUit("UPDATE festivals"
                + " SET fest_naam = ?, fest_locatie = ?, fest_datum = ?, fest_duur = ?, fest_einddatum = ?, fest_url = ?"
                + " WHERE fest_id = ?", alParams);
            } catch (Exception e) {
                strFouten += "<p id=\"error\">Niet alle gegevens zijn correct, melding:<br />" + e.getMessage() + "<br />";
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
        <div id="page_wrapper">
            <jsp:include page="header.jsp" />
            <jsp:include page="navigation.jsp" />
            <div id="content_wrapper">
                <section id="content">
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
            <jsp:include page="footer.jsp" />
        </div>
    </body>
</html>