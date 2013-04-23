<%-- 
    Document   : layout
    Created on : 28-mrt-2013, 9:04:18
    Author     : robbie, jeroen, steven
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
        <title>Home</title>
        <link rel="stylesheet" href="css/normalize.css">
        <link rel="stylesheet" href="css/main.css">
        <link rel="stylesheet" href="css/ie_uitzonderingen.css">
        <script src="js/vendor/modernizr-2.6.2.min.js"></script>
    </head>
    <body>
        <div id="pagina_omslag">
            <jsp:include page="hoofding.jsp" />
            <jsp:include page="navigatie.jsp" />
            <div id="inhoud_omslag">
                <section id="inhoud">
 
                    <%
                        try
                        {
                            //Huidige tijd en datum opvragen
                            DateFormat dateFormat = new SimpleDateFormat("yyyy/MM/dd HH:mm:ss", Locale.ENGLISH);
                            Calendar calNu = Calendar.getInstance();

                            //Controle voor als de gebruiker achter een proxy zit of niet
                            String strIpAdres = request.getHeader("HTTP_X_FORWARDED_FOR"); //Proxy
                            if(strIpAdres == null)
                            {
                                strIpAdres = request.getRemoteAddr(); //Geen proxy
                            }
                            //Controle om te kijken of het IP adres al eens gelogd is binnen 30 minuten
                            Connectie_Databank connectie_InhoudIpLogging = new Connectie_Databank();

                            connectie_InhoudIpLogging.maakConnectie();
                            List<String> lijstParams_ControleIpLogging = new ArrayList<String>();

                            lijstParams_ControleIpLogging.add(strIpAdres);

                            connectie_InhoudIpLogging.voerQueryUit("SELECT * FROM iplogging WHERE MINUTE(TIMEDIFF(NOW(), ip_datum)) < 10 AND ip_adres = ?", lijstParams_ControleIpLogging);
                            ResultSet rsInhoudIpLogging = connectie_InhoudIpLogging.haalResultSetOp();

                            rsInhoudIpLogging.last();
                            int lengteRsInhoudIpLogging = rsInhoudIpLogging.getRow();

                            if(lengteRsInhoudIpLogging == 0) //IP is nog niet gelogd in 30 minuten
                            {
                                out.println("IP Gelogd");
                                //Wegschrijven van IP Logging                        
                                Connectie_Databank connectie_ipLogging = new Connectie_Databank();

                                connectie_ipLogging.maakConnectie();
                                List<String> lijstParams_ipLogging = new ArrayList<String>();

                                lijstParams_ipLogging.add(dateFormat.format(calNu.getTime()) + "");
                                lijstParams_ipLogging.add(strIpAdres);

                                connectie_ipLogging.veranderQuery("INSERT INTO iplogging (ip_datum, ip_adres) VALUES(?, ?)", lijstParams_ipLogging);
                            }
                        }catch(Exception e){
                            out.println("Ergens een fout: " + e.getMessage());
                        }
                    %>
        
                    <div id="links">
                        <h2>Over de website</h2>
                        <p>Op onze website krijgt u meer informatie over festivals wereldwijd.</p>
                        <p>Indien u meer informatie opvraagt over een festival, heeft u de keuze om details over groepen op te vragen en vica versa.</p>
                        <h2>Over Groep 2</h2>
                        <p>Groep 2 is een groep studenten van de richting Toegepaste Informatica op de PHL</p>
                        <p>De groepsleden zijn Anke Appeltans, Wouter Peeters, Jeroen Vanlessen, Robbie Vercammen en Steven Verheyen.</p>
                        <p>Groep 2 wenst u een informatieve surfervaring!</p>
                    </div>

                    <div id="rechts">
                        <article>
                            <header>
                                <h2>Komende festivals</h2>
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
                                    connectie.voerQueryUit(query, lijstParams);
                                    res = connectie.haalResultSetOp();
                                } catch (Exception e) {
                                    out.println(e.getMessage());
                                }

                                //Controleren of er festivals zijn
                                if (res.isBeforeFirst()) {

                                    res.first();    //Zorgen dat de cursor op de 1ste rij van de ResultSet staat
                                    res.previous(); //Zorgen dat de cursor op rij 0 komt te staan (anders wordt de 1ste rij niet meegenomen!!!)
                                    while (res.next()) {
                                        String naam = res.getString("fest_naam");
                                        String locatie = res.getString("fest_locatie");
                            %>
                            <table style='min-width: 475px; border: 1px solid white;'>
                                <tbody align="left" style='padding: 10px;'>
                                <form action="festival_details.jsp" method="POST">
                                    <tr>
                                        <td width='150px' style='padding-left: 10px; padding-top: 10px;'><b> <%= naam%> </b></td>
                                    <input type="hidden" name="naam" value="<%=naam%>">
                                    <td style='padding-left: 10px; padding-top: 10px;'>Locatie: <%=locatie%> </td>
                                    </tr>

                                    <%
                                        String url = res.getString("fest_url");
                                    %>

                                    <tr>
                                        <%
                                            //Als de URL-waarde leeg (null) is, geen URL maar boodschap weergeven
                                            if (url == null) {
                                        %>
                                        <td style='padding-left: 10px; padding-bottom: 10px;'></td>
                                        <%                                    } else {
                                        %>
                                        <td style='padding-left: 10px; padding-bottom: 10px;'><a href='http://<%=url%>' target='_blank'>Site</a></td>
                                        <%
                                            }
                                        %>

                                        <td align='right' style='padding-right: 10px; padding-bottom: 10px;'>
                                            <input type="submit" name="Details" value=" Details " />
                                        </td>
                                    </tr>
                                </form>
                                </tbody>
                            </table><br /> 
                            <%
                                }
                            } else {
                            %>
                            <h3>Er zijn geen komende festivals</h3>
                            <p>Kom later nog eens terug.</p>
                            <%                            }
                            %>
                        </article>
                    </div>
                </section>
            </div>
            <%
                     connectie.sluitConnectie(); //Connectie met de databank sluiten
%>
            <hr style="width: auto; margin-left: 20px; margin-right: 20px;" />
            <jsp:include page="voettekst.jsp" />
        </div>
    </body>
</html>