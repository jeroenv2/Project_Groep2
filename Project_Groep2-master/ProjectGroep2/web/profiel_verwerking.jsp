<%-- 
    Document   : profiel_verwerking
    Created on : Apr 14, 2013, 10:35:33 AM
    Author     : Steven Verheyen
--%>

<%@page import="java.text.DateFormat"%>
<%@page import="java.util.Locale"%>
<%@page import="java.util.Calendar"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>
<%@page import="java.util.List"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="Databank.Connectie_Databank"%>
<%@page import="java.util.ArrayList"%>
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
        <title>Festivals</title>
        <link rel="stylesheet" href="css/normalize.css">
        <link rel="stylesheet" href="css/main.css">
        <script src="js/vendor/modernizr-2.6.2.min.js"></script>
    </head>
    <body>
        <div id="page_wrapper">
            <jsp:include page="header.jsp" />
            <jsp:include page="navigation.jsp" />
            <div id="content_wrapper">
                <section id="content">
                    <div id="ElementenCenter">
                        <div id="TekstCenter">
                            <%
                                beans.gegevensGebruiker gebruiker = (beans.gegevensGebruiker) session.getAttribute("gegevensGebruiker");
                                
                                Connectie_Databank connectie = new Connectie_Databank();

                                connectie.maakConnectie();
                                List<String> lijstParams = new ArrayList<String>();

                                String adres = "";
                                if(!request.getParameter("bus").equals(""))
                                {
                                    adres = request.getParameter("huisnummer") + "/" + request.getParameter("bus") + " " + request.getParameter("straatnaam") + ", " + request.getParameter("postcode") + " " + request.getParameter("gemeente") + " - " + request.getParameter("land");
                                }
                                else
                                {
                                    adres = request.getParameter("huisnummer") + " " + request.getParameter("straatnaam") + ", " + request.getParameter("postcode") + " " + request.getParameter("gemeente") + " - " + request.getParameter("land");
                                }                                
                                
                                lijstParams.add(adres);
                                lijstParams.add(request.getParameter("geboorteDatum"));
                                lijstParams.add(request.getParameter("gebruikersnaam"));
                                
                                int aantalUpdate = connectie.updateQuery("UPDATE geregistreerdegebruikers SET gebr_adres=?, gebr_gebDat=? WHERE gebr_naam=?", lijstParams);

                                if (aantalUpdate > 0)
                                {
                                    gebruiker.setAdres(adres);
                                    
                                    Date geboortedatum = new SimpleDateFormat("yyyy-MM-dd", Locale.ENGLISH).parse(request.getParameter("geboorteDatum"));
                                    gebruiker.setGeboorteDatum(geboortedatum);
                        %>   
                                    <h3>Uw profielgegevens zijn met succes gewijzigd</h3>
                                    
                        <%      }else {%>
                                    <h3>Er is iets fout gegaan. Probeer later uw profiel aan te passen</h3>
                        <%      }%>
                                klik <a href="index.jsp">hier</a> om naar de hoofdpagina te gaan... 
                        </div>
                    </div>
                </section>
            </div>
            <hr style="width: auto; margin-left: 20px; margin-right: 20px;" />
            <jsp:include page="footer.jsp" />
        </div>
    </body>
</html>