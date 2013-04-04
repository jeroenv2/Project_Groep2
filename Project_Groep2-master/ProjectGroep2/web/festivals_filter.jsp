<%-- 
    Document   : layout
    Created on : 28-mrt-2013, 9:04:18
    Author     : Steven
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
                            try
                            {
                                Connectie_Databank connectie = new Connectie_Databank();

                                connectie.maakConnectie();
                                List<String> lijstParams = new ArrayList<String>();
                                String query = "SELECT * FROM festivals"; //Zonder enig iets aangeduid te hebben in festivals.jsp
                                
                                //Alle aangeduidde letters behandelen
                                if(request.getParameter("beginletter") != null)
                                {
                                    query += " WHERE fest_naam LIKE ?"; //Beginletters geselecteerd
                                    String[] letters = request.getParameterValues("beginletter");
                                    //Vormen van query
                                    for(int i=0; i<letters.length-1; i++) //ervoor zorgen dat de query juist eindigt
                                    {                                     //Begin 0: Array letters begin ook vanaf 0
                                        query += " OR fest_naam LIKE ?";
                                    }
                                    
                                    //Vormen van lijstParams
                                    for(int i=0; i<letters.length; i++)
                                    {
                                        lijstParams.add(letters[i] + "%");
                                    }
                                }
                                
                                //Alle aangeduidde locaties behandelen
                                if(request.getParameter("locatieFestival") != null)
                                {
                                    //**ER EVEN VANUIT GAANDE DAT ER BEGINLETTERS AANGEDUID WORDEN (EXTRA CONTROLE NODIG!)
                                    query += " AND fest_locatie = ?"; //Beginletters geselecteerd
                                    String[] locaties = request.getParameterValues("locatieFestival");
                                    //Vormen van query
                                    for(int i=0; i<locaties.length-1; i++) //ervoor zorgen dat de query juist eindigt
                                    {                                      //Begin 0: Array letters begin ook vanaf 0
                                        query += " OR fest_locatie = ?";
                                    }
                                    
                                    //Vormen van lijstParams
                                    for(int i=0; i<locaties.length; i++)
                                    {
                                        lijstParams.add(locaties[i]);
                                    }
                                }
                                
                                //SELECT * FROM festivals WHERE fest_naam LIKE 'R' OR fest_naam LIKE 'W' AND fest_locatie = 'Geel - Belgie' OR fest_locatie = 'Werchter - Belgie'
                                
                                connectie.voerQueryUit(query, lijstParams);
                                ResultSet res = connectie.haalResultSetOp();                           

                                res.last();
                                int lengteResultSet = res.getRow();
                                
                                res.first();
                                res.previous();

                                if(lengteResultSet > 0)
                                {
                                    out.println("<div align='center' style='padding-top: 25px; padding-bottom: 10px;'>");

                                    
                                    //Informatie festivals
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

                                        Date einddatum = cal.getTime(); //Nieuwe Date-obj maken als einddatum met de inhoud van cal
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
                                }
                                else
                                {
                                    out.println("<h3>Helaas! Er zijn geen records gevonden...</h3>");
                                    out.println("<p>Klik <a href='festivals.jsp'>hier</a> om terug te keren...</p>");
                                }
                                connectie.sluitConnectie(); //Connectie met de databank sluiten
                            }
                            catch(Exception e)
                            {
                                out.println(e.getMessage());
                            }
                        %>
                    </div>
                </section>
            </div>
            <hr style="width: auto; margin-left: 20px; margin-right: 20px;" />
            <jsp:include page="footer.jsp" />
        </div>
    </body>
</html>