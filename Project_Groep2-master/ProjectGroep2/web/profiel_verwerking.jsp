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
        <div id="pagina_omslag">
            <jsp:include page="hoofding.jsp" />
            <jsp:include page="navigatie.jsp" />
            <div id="inhoud_omslag">
                <section id="inhoud">
                    <div id="elementen_centreren">
                        <div class="tekst_centreren">
                            <%
                                beans.gegevensGebruiker gebruiker = (beans.gegevensGebruiker) session.getAttribute("gegevensGebruiker");
                                
                                Connectie_Databank connectie = new Connectie_Databank();

                                connectie.maakConnectie();
                                List<String> lijstParams = new ArrayList<String>();
                                int aantalUpdate = 0;
                                
                                if(request.getParameter("txtLand") != null) //Controle doen om te kijken welke formulier gebruikt werd
                                {
                                    String adres = "";
                                    if(!request.getParameter("txtBus").equals(""))
                                    {
                                        adres = request.getParameter("txtHuisnummer") + "/" + request.getParameter("txtBus") + " " + request.getParameter("txtStraatnaam") + ", " + request.getParameter("txtPostcode") + " " + request.getParameter("txtGemeente") + " - " + request.getParameter("txtLand");
                                    }
                                    else
                                    {
                                        adres = request.getParameter("TxtHuisnummer") + " " + request.getParameter("txtStraatnaam") + ", " + request.getParameter("txtPostcode") + " " + request.getParameter("txtGemeente") + " - " + request.getParameter("txtLand");
                                    }                                

                                    lijstParams.add(adres);
                                    lijstParams.add(request.getParameter("dtGeboorteDatum"));
                                    lijstParams.add(request.getParameter("dtGebruikersnaam"));

                                    aantalUpdate = connectie.updateQuery("UPDATE geregistreerdegebruikers SET gebr_adres=?, gebr_gebDat=? WHERE gebr_naam=?", lijstParams);
                                
                                    if (aantalUpdate > 0) //Bean gegevensGebruiker updaten
                                    {
                                        Date geboortedatum = new SimpleDateFormat("yyyy-MM-dd", Locale.ENGLISH).parse(request.getParameter("geboorteDatum"));
                                    
                                        gebruiker.setAdres(adres);
                                        gebruiker.setGeboorteDatum(geboortedatum);
                                    }
                                }
                                else if(request.getParameter("passNieuwPaswoord") != null) //Controle om te kijken welke form gebruikt is
                                {
                                    String paswoord = request.getParameter("passNieuwPaswoord");
                                    
                                    lijstParams.add(request.getParameter("passNieuwPaswoord"));
                                    lijstParams.add(request.getParameter("txtGebruikersnaam"));
                                    
                                    if(gebruiker.getPaswoord().equals(request.getParameter("passHuidigPaswoord")))
                                    {
                                        aantalUpdate = connectie.updateQuery("UPDATE geregistreerdegebruikers SET gebr_wachtwoord=? WHERE gebr_naam=?", lijstParams);
                                
                                        if (aantalUpdate > 0) //Bean gegevensGebruiker updaten
                                        {
                                            gebruiker.setPaswoord(paswoord);
                                        }
                                    }
                                    else
                                    {%>
                                        <h3>Verkeerd paswoord</h3>
                                        U heeft uw huidig paswoord verkeerd ingegeven. Gelieve deze na te kijken...<br />
                                    <%}
                                }
                                if(aantalUpdate > 0)
                                {
                        %>   
                                    <h3>Uw profielgegevens zijn met succes gewijzigd</h3>
                        <%      }%>
                                klik <a href="profiel.jsp">hier</a> om terug naar de profielpagina te gaan... 
                        </div>
                    </div>
                </section>
            </div>
            <hr style="width: auto; margin-left: 20px; margin-right: 20px;" />
            <jsp:include page="voettekst.jsp" />
        </div>
    </body>
</html>