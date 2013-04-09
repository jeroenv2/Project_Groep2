<%-- 
    Document   : layout
    Created on : 28-mrt-2013, 9:04:18
    Author     : robbie, jeroen
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
<html class="no-js">
	<!--<![endif]-->
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Home</title>
        <link rel="stylesheet" href="css/normalize.css">
        <link rel="stylesheet" href="css/main.css">
        <link rel="stylesheet" href="css/ieuitzonderingen.css">
        <script src="js/vendor/modernizr-2.6.2.min.js"></script>
    </head>
    <body>
        <div id="page_wrapper">
            <jsp:include page="header.jsp" />
            <jsp:include page="navigation.jsp" />
            <div id="content_wrapper">
                <section id="content">
                    <div style='padding-top: 25px; padding-bottom: 10px;' align="center">
                    <article>
                        <header>
                            <h2>Eerstvolgende festivals</h2>
                        </header>
                        
                       <!-- Informatie eerstvolgende festivals (max 5) -->
                        <%
                        Connectie_Databank connectie = null;
                        ResultSet res = null;

                        try {
                        connectie = new Connectie_Databank();
                        connectie.maakConnectie();

                        List<String> lijstParams = new ArrayList<String>();
                        String query = "SELECT * FROM festivals where fest_datum >= (select curdate()) order by fest_datum limit 5";
                        //order by fest_datum limit 10
                        connectie.voerQueryUit(query, lijstParams);
                        res = connectie.haalResultSetOp();           
                        }
                        catch (Exception e){
                            out.println(e.getMessage());
                        }
                     
                        res.first();    //Zorgen dat de cursor op de 1ste rij van de ResultSet staat
                        res.previous(); //Zorgen dat de cursor op rij 0 komt te staan (anders wordt de 1ste rij niet meegenomen!!!)
                        while (res.next()) {
                            String naam = res.getString("fest_naam");
                            String beginDatum = res.getString("fest_datum");
                            String locatie = res.getString("fest_locatie");
                        %>
                        <table width='600px' style='border: 1px solid white;'>
                            <tbody style='padding: 10px;'>
                            <form action="festival_details.jsp" method="POST">
                                <tr>
                                    <td width='300px' style='padding-left: 10px; padding-top: 10px;'><b> <%= naam%> </b></td>
                                <input type="hidden" name="naam" value="<%=naam%>">
                                <td style='padding-left: 10px; padding-top: 10px;'>Begindatum: <%=beginDatum%> </td>
                                <td></td>
                                </tr>
                                <tr>
                                    <td style='padding-left: 10px; padding-top: 10px; padding-bottom: 10px'>Locatie: <%=locatie%></td>
                                    <!-- Datums berekenen -->
                                    <%
                                        DateFormat formaatDatum = new SimpleDateFormat("yyyy-MM-dd");   //Formaat van datum bepalen

                                        Date begindatum = formaatDatum.parse(beginDatum);

                                        //Calendar gebruiken om dagen (duur) op te tellen bij de begindatum
                                        Calendar cal = Calendar.getInstance();  //Huidige datum in cal steken
                                        cal.setTime(begindatum);                //De begindatum in cal steken
                                        cal.add(cal.DATE, Integer.parseInt(res.getString("fest_duur")));    //Dagen (duur) optellen bij de begindatum

                                        Date einddatum = cal.getTime(); //Nieuwe Date-obj maken als einddatum met de inhoud van cal
                                        String strEinddatum = formaatDatum.format(einddatum); //Einddatum omzetten naar juiste formaat
                                        String url = res.getString("fest_url");
                                    %>
                                    <td style='padding-left: 10px; padding-top: 10px;'>Einddatum: <%=strEinddatum%></td>
                                    <td></td>
                                </tr>
                                <tr>
                                    <td style='padding-left: 10px; padding-bottom: 10px;'><a href='http://<%=url%>' target='_blank'>Site</a></td>
                                   
                                    <td align='right' style='padding-right: 10px; padding-bottom: 10px;'>
                                        <input type="submit" name="Details" value=" Details " />
                                    </td>
                                </tr>
                            </form>
                            </tbody>
                        </table><br />                   
                        <%}
                            connectie.sluitConnectie(); //Connectie met de databank sluiten
                        %>
                    </article>
                    </div>      
                </section>
            </div>
            <hr style="width: auto; margin-left: 20px; margin-right: 20px;" />
            <jsp:include page="footer.jsp" />
        </div>
    </body>
</html>