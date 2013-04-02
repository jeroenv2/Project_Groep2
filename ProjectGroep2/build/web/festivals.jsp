<%-- 
    Document   : layout
    Created on : 28-mrt-2013, 9:04:18
    Author     : robbie
--%>

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
                    <div align="center">
                        <%
                            ArrayList<String> lijstLetters = new ArrayList<String>();

                            Connectie_Databank connectie = new Connectie_Databank();

                            connectie.maakConnectie();
                            connectie.voerQueryUit("SELECT * FROM festivals", null); //null = geen parameter
                            ResultSet res = connectie.haalResultSetOp();

                            while (res.next()) {
                                String letter = res.getString("fest_naam").substring(0, 1);

                                if (!lijstLetters.contains(letter)) {
                                    lijstLetters.add(letter);
                                }
                            }

                            //De ArrayList alfabetisch ordenen
                            java.util.Collections.sort(lijstLetters);

                            for (int i = 0; i < lijstLetters.size() - 1; i++) //Ervoor zorgen dat het niet eindigt met '|'
                            {
                                out.println("<a href='#'>" + lijstLetters.get(i) + "</a> | ");
                            }
                            out.println("<a href='#'>" + lijstLetters.get(lijstLetters.size() - 1) + "</a>");

                            //Elke regel apart voor betere leesbaarheid
                            out.println("</div>");
                            out.println("<div align='center' style='padding-top: 25px; padding-bottom: 10px;'>");

                            res.first();    //Zorgen dat de cursor op de 1ste rij van de ResultSet staat
                            res.previous(); //Zorgen dat de cursor op rij 0 komt te staan (anders wordt de 1ste rij niet meegenomen!!!)
                            while (res.next()) {
                                out.println("<table width='600px' style='border: 1px solid white;'>");
                                out.println("<tbody style='padding: 10px;'>");
                                out.println("<tr>");
                                out.println("<td width='300px' style='padding-left: 10px; padding-top: 10px;'><b>" + res.getString("fest_naam") + "</b></td>");
                                out.println("<td style='padding-left: 10px; padding-top: 10px;'>Begindatum: " + res.getString("fest_datum") + "</td>");
                                out.println("<td></td>");
                                out.println("</tr>");
                                out.println("<tr>");
                                out.println("<td style='padding-left: 10px; padding-top: 10px; padding-bottom: 10px'>Locatie: " + res.getString("fest_locatie") + "</td>");

                                //** Duur (dagen) optellen met de begindatum **
                                DateFormat formaatDatum = new SimpleDateFormat("yyyy-MM-dd");   //Formaat van datum bepalen
                                
                                Date begindatum = formaatDatum.parse(res.getString("fest_datum")); //Datum uit DB (String) omzetten naar Date
                                
                                //Calendar gebruiken om dagen (duur) op te tellen bij de begindatum
                                Calendar cal = Calendar.getInstance();  //Huidige datum in cal steken
                                cal.setTime(begindatum);                //De begindatum in cal steken
                                cal.add(cal.DATE, Integer.parseInt(res.getString("fest_duur")));    //Dagen (duur) optellen bij de begindatum
                                
                                Date einddatum = cal.getTime(); //Nieuwe Date-obj maken als einddatum
                                String strEinddatum = formaatDatum.format(einddatum); //Einddatum omzetten naar juiste formaat
                                
                                out.println("<td style='padding-left: 10px; padding-top: 10px;'>Einddatum: " + strEinddatum + "</td>");
                                out.println("<td></td>");
                                out.println("</tr>");
                                out.println("<tr>");
                                if (res.getString("fest_url") != null) {
                                    out.println("<td style='padding-left: 10px; padding-bottom: 10px;'><a href='http://" + res.getString("fest_url") + "' target='_blank'>Site</a></td>");
                                } else {
                                    out.println("<td></td>");
                                }
                                out.println("<td></td>");
                                out.println("<td align='right' style='padding-right: 10px; padding-bottom: 10px;'>");
                                out.println("<input type='button' name='Detail' value=' Detail ' onclick='location.href = './festival_details.jsp';' />");
                                out.println("</td>");
                                out.println("</tr>");
                                out.println("</tbody>");
                                out.println("</table><br />");
                            }

                            connectie.sluitConnectie(); //Connectie met de databank sluiten
%>
                    </div>
                </section>
            </div>
            <hr style="width: auto; margin-left: 20px; margin-right: 20px;" />
            <jsp:include page="footer.jsp" />
        </div>
    </body>
</html>