<%-- 
    Document   : inlog
    Created on : Apr 13, 2013, 1:23:49 PM
    Author     : Steven Verheyen
--%>

<%@page import="beans.gegevensGebruiker"%>
<%@page import="java.util.List"%>
<%@page import="java.text.DateFormat"%>
<%@page import="java.util.Locale"%>
<%@page import="java.util.Calendar"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>
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
        <title>Inlog</title>
        <link rel="stylesheet" href="css/normalize.css">
        <link rel="stylesheet" href="css/main.css">
        <script src="js/vendor/modernizr-2.6.2.min.js"></script>
    </head>
    <body>
        <%
            gegevensGebruiker gebruiker = new gegevensGebruiker();
            try
            {
                Databank.Connectie_Databank connectie = new Databank.Connectie_Databank();
                connectie.maakConnectie();

                String query = "SELECT * FROM geregistreerdegebruikers WHERE lower(gebr_naam) = ? AND gebr_wachtwoord = ?";
                List<String> lijstParams = new ArrayList<String>();
                lijstParams.add(request.getParameter("gebruikersnaam").toLowerCase());
                lijstParams.add(request.getParameter("paswoord"));

                connectie.voerQueryUit(query, lijstParams);
                ResultSet res = connectie.haalResultSetOp();
                res.last();
                int lengteResultSet = res.getRow(); //Lengte van de ResultSet opvragen
                if(lengteResultSet > 0)
                {
                    String gebruikersnaam = res.getString("gebr_naam");
                    String paswoord = res.getString("gebr_wachtwoord");
                    String adres = res.getString("gebr_adres");        
                    Date geboortedatum = new SimpleDateFormat("yyyy-MM-dd", Locale.ENGLISH).parse(res.getString("gebr_gebDat")); //Geboortedatum omzetten naar Date (controles nodig later in de webapp)
                                        
                    //In beans steken
                    gebruiker.setGebruikersnaam(gebruikersnaam);
                    gebruiker.setPaswoord(paswoord);
                    gebruiker.setAdres(adres);
                    gebruiker.setGeboorteDatum(geboortedatum);
                                        
                    session.setAttribute("gegevensGebruiker", gebruiker);
                }
        %>        
        <div id="pagina_omslag">
            <jsp:include page="hoofding.jsp" />
            <jsp:include page="navigatie.jsp" />
            <div id="inhoud_omslag">
                <section id="inhoud">
                    <div class="tekst_centreren">
                            <%
                                if(gebruiker.getGebruikersnaam() != null)
                                {
                            %>                      
                                        <h1>U bent met succes ingelogd!</h1>
                            <%  } else{%>
                                        <h2>U hebt verkeerde inloggegevens ingegeven</h2>
                                        
                            <%  }
                          } catch(Exception e) {}
                            %>
                            Klik <a href='index.jsp'>hier</a> om naar de hoofdpagina te gaan
                    </div>
                </section>
            </div>
            <hr style='width: auto; margin-left: 20px; margin-right: 20px;' />
            <jsp:include page="voettekst.jsp" />
        </div>
    </body>
</html>