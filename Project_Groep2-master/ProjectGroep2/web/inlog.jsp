<%-- 
    Document   : inlog
    Created on : Apr 13, 2013, 1:23:49 PM
    Author     : Steven Verheyen
--%>

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
        <jsp:useBean id="gegevens" class="beans.gegevensGebruiker" scope="request">
            <jsp:setProperty name="gegevens" property="*" />
        </jsp:useBean>
    </head>
    <body>
        <div id='page_wrapper'>
            <jsp:include page="header.jsp" />
            <jsp:include page="navigation.jsp" />
            <div id='content_wrapper'>
                <section id='content'>
                    <div id='ElementenCenter'>
                        <div id='TekstCenter'>
                            <%
                                try
                                {
                                    Databank.Connectie_Databank connectie = new Databank.Connectie_Databank();
                                    connectie.maakConnectie();

                                    String query = "SELECT * FROM geregistreerdegebruikers WHERE gebr_naam = ? AND gebr_wachtwoord = ?";
                                    List<String> lijstParams = new ArrayList<String>();
                                    lijstParams.add(request.getParameter("gebruikersnaam"));
                                    lijstParams.add(request.getParameter("paswoord"));

                                    connectie.voerQueryUit(query, lijstParams);
                                    ResultSet res = connectie.haalResultSetOp();
                                    res.last();
                                    int lengteResultSet = res.getRow(); //Lengte van de ResultSet opvragen
                                    if(lengteResultSet > 0)
                                    {
                                   %>
                                        <h1>U bent met succes ingelogd!</h1>
                                        Klik <a href='index.jsp'>hier</a> om naar de hoofdpagina te gaan
                                    <%}
                                    else
                                    {%>
                                            <h2>U hebt verkeerde inloggegevens ingegeven</h2>
                                            Klik <a href='index.jsp'>hier</a> om naar de hoofdpagina te gaan
                                    <%}
                                } catch(Exception e) {}
                            %>
                        </div>
                    </div>
                </section>
            </div>
            <hr style='width: auto; margin-left: 20px; margin-right: 20px;' />
            <jsp:include page="footer.jsp" />
        </div>
    </body>
</html>