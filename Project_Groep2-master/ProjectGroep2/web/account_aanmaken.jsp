<%-- 
    Document   : layout
    Created on : 28-mrt-2013, 9:04:18
    Author     : Steven
--%>

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
        <title>Gebruiker Aanmaken</title>
        <link rel="stylesheet" href="css/normalize.css">
        <link rel="stylesheet" href="css/main.css">
        <script src="js/vendor/modernizr-2.6.2.min.js"></script>
        <script src="http://ajax.googleapis.com/ajax/libs/jquery/1.8.1/jquery.min.js"></script>
        <script src="js/vendor/jquery.collapse.js"></script>
    </head>
    <body>
        <div id="pagina_omslag">
            <jsp:include page="hoofding.jsp" />
            <jsp:include page="navigatie.jsp" />
            <div id="inhoud_omslag">
                <section id="inhoud">
                    <div class="tekst_centreren">
                         <%
                            Connectie_Databank connectieAanmakenGebruiker = new Connectie_Databank();

                            connectieAanmakenGebruiker.maakConnectie();
                            List<String> lijstParams = new ArrayList<String>();
                                
                            String aanmakenAdres = "";
                            if(!request.getParameter("txtAanmakenBus").equals(""))
                            {
                                aanmakenAdres = request.getParameter("txtAanmakenHuisnummer") + "-" + request.getParameter("txtAanmakenBus") + "-" + request.getParameter("txtAanmakenStraatnaam") + "-" + request.getParameter("txtAanmakenPostcode") + "-" + request.getParameter("txtAanmakenGemeente") + "-" + request.getParameter("txtAanmakenLand");
                            }
                            else
                            {
                                aanmakenAdres = request.getParameter("txtAanmakenHuisnummer") + "-" + request.getParameter("txtAanmakenStraatnaam") + "-" + request.getParameter("txtAanmakenPostcode") + "-" + request.getParameter("txtAanmakenGemeente") + "-" + request.getParameter("txtAanmakenLand");
                            } 
                                    
                            lijstParams.add(request.getParameter("txtAanmakenGebruikersnaam"));
                            lijstParams.add(aanmakenAdres);
                            lijstParams.add(request.getParameter("txtAanmakenPaswoord"));
                            lijstParams.add(request.getParameter("dtAanmakenGebDat"));
                            
                            int aantalToegevoegd = connectieAanmakenGebruiker.veranderQuery("INSERT INTO geregistreerdegebruikers (gebr_naam, gebr_adres, gebr_wachtwoord, gebr_gebDat) VALUES (?, ?, PASSWORD(?), ?)", lijstParams);

                            if (aantalToegevoegd > 0) //Gebruiker is aangemaakt
                            {%>
                                <h3>Administrator is aangemaakt!</h3>
                                Deze Administrator kan nu inloggen met ingevoerde gegevens
                            <%}
                            else
                            {%>
                                <h3>Oeps!</h3>
                                Er is iets mis gegaan. Controleer de databank en probeer later nog eens...
                            <%}%>
                    </div>
                </section>
            </div>
            <hr style="width: auto; margin-left: 20px; margin-right: 20px;" />
            <jsp:include page="voettekst.jsp" />
        </div>  
    </body>
</html>