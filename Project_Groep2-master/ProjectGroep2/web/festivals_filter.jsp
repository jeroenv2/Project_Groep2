<%-- 
    Document   : layout
    Created on : 28-mrt-2013, 9:04:18
    Author     : Steven
--%>

<%@page import="java.util.GregorianCalendar"%>
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
        <title>Festivals Gefilterd</title>
        <link rel="stylesheet" href="css/normalize.css">
        <link rel="stylesheet" href="css/main.css">
        <script src="js/vendor/modernizr-2.6.2.min.js"></script>
    </head>
    <body>
        <a id="boven"></a>
        <div id="pagina_omslag">
            <jsp:include page="hoofding.jsp" />
            <jsp:include page="navigatie.jsp" />
            <div id="inhoud_omslag">
                <section id="inhoud">
                    <div id="elementen_centreren">
                        <%
                            Connectie_Databank connectie = null;
                            try {
                                connectie = new Connectie_Databank();
                                connectie.maakConnectie();
                                List<String> lijstParams = new ArrayList<String>();
                                String query = "SELECT * FROM festivals"; //Zonder enig iets aangeduid te hebben in festivals.jsp

                                //Alle aangeduidde letters behandelen
                                if (request.getParameter("chkBeginletter") != null) {
                                    query += " WHERE (fest_naam LIKE ?"; //Beginletters geselecteerd
                                    String[] letters = request.getParameterValues("chkBeginletter");
                                    //Vormen van query
                                    for (int i = 0; i < letters.length - 1; i++) //ervoor zorgen dat de query juist eindigt
                                    {                                     //Begin 0: Array letters begin ook vanaf 0
                                        query += " OR fest_naam LIKE ?";
                                    }
                                    query += ")";

                                    //Vormen van lijstParams
                                    for (int i = 0; i < letters.length; i++) {
                                        lijstParams.add(letters[i] + "%");
                                    }
                                }

                                //Alle aangeduidde locaties behandelen
                                if (request.getParameter("chkLocatieFestival") != null) {
                                    if(request.getParameter("chkBeginletter") == null)
                                    {
                                        query += " WHERE (fest_locatie = ?";
                                    }
                                    else
                                    {
                                        query += " AND (fest_locatie = ?"; //Beginletters geselecteerd
                                    }
                                    String[] locaties = request.getParameterValues("chkLocatieFestival");
                                    //Vormen van query
                                    for (int i = 0; i < locaties.length - 1; i++) //ervoor zorgen dat de query juist eindigt
                                    {                                      //Begin 0: Array letters begin ook vanaf 0
                                        query += " OR fest_locatie = ?";
                                    }
                                    query += ")";

                                    //Vormen van lijstParams
                                    for (int i = 0; i < locaties.length; i++) {
                                        lijstParams.add(locaties[i]);
                                    }
                                }

                                //Checkbox geeft volgende terug:
                                //on <- als checked is
                                //null <- als niet checked is
                                if (request.getParameter("chkOpDatum") != null) {
                                    if(request.getParameter("chkLocatieFestival") == null &&
                                            request.getParameter("chkBeginletter") == null)
                                    {
                                        query += " WHERE (fest_datum >= ? AND fest_einddatum <= ?)";
                                    }
                                    else
                                    {
                                        query += " AND (fest_datum >= ? AND fest_einddatum <= ?)";
                                    }
                                    
                                    lijstParams.add(request.getParameter("dtBegindatum"));
                                    lijstParams.add(request.getParameter("dtEinddatum"));
                                }
                                
                                connectie.voerQueryUit(query, lijstParams);
                                ResultSet rsInhoudFestivals = connectie.haalResultSetOp();

                                rsInhoudFestivals.last();
                                int lengteResultSet = rsInhoudFestivals.getRow();

                                rsInhoudFestivals.first();
                                rsInhoudFestivals.previous();
                                
                                if (lengteResultSet > 0) {
                        %>
                                    <div class="tekst_centreren">
                                        <h1>Gefilterd Resultaat</h1>
                                        Klik <a href='festivals.jsp'>hier</a> om terug te keren
                                    </div>
                        
                                    <!-- Informatie Festivals -->
                                    <%
                                       rsInhoudFestivals.first();    //Zorgen dat de cursor op de 1ste rij van de ResultSet staat
                                       rsInhoudFestivals.previous(); //Zorgen dat de cursor op rij 0 komt te staan (anders wordt de 1ste rij niet meegenomen!!!)
                                       while (rsInhoudFestivals.next())
                                       {
                                           String naam = rsInhoudFestivals.getString("fest_naam");
                                           String beginDatum = rsInhoudFestivals.getString("fest_datum");
                                           String locatie = rsInhoudFestivals.getString("fest_locatie");
                                    %>
                                           <form action="festival_details.jsp" method="POST">
                                              <table id="tabel_breedte_600px_omrand">
                                                  <tbody class="inhoud_tabel_links_uitlijning" style='padding: 10px;'>
                                                      <tr>
                                                         <td class="inhoud_tabel_breedte_300px" style='padding-left: 10px; padding-top: 10px;'>
                                                             <div class="tekst_vet"> <%= naam%> </div>
                                                            <input type="hidden" name="naam" value="<%=naam%>">
                                                         </td>
                                                         <td class="inhoud_tabel_breedte_300px inhoud_tabel_spatie_links_boven_onder">Begindatum: <%=beginDatum%> </td>
                                                       </tr>
                                                       <tr>
                                                          <td class="inhoud_tabel_spatie_links_boven_onder">
                                                              Locatie: <%=locatie%>
                                                          </td>
                                                            <!-- Datums berekenen -->
                                                            <%
                                                             DateFormat dfFormaatDatum = new SimpleDateFormat("yyyy-MM-dd");   //Formaat van datum bepalen
                                                             Date begindatum = dfFormaatDatum.parse(beginDatum);

                                                             //Calendar gebruiken om dagen (duur) op te tellen bij de begindatum
                                                             Calendar calBegindatum = Calendar.getInstance();  //Huidige datum in cal steken
                                                             calBegindatum.setTime(begindatum);                //De begindatum in cal steken
                                                             calBegindatum.add(calBegindatum.DATE, Integer.parseInt(rsInhoudFestivals.getString("fest_duur")));    //Dagen (duur) optellen bij de begindatum

                                                             Date einddatum = calBegindatum.getTime(); //Nieuwe Date-obj maken als einddatum met de inhoud van cal
                                                             String strEinddatum = dfFormaatDatum.format(einddatum); //Einddatum omzetten naar juiste formaat
                                                           %>
                                                           <td class="inhoud_tabel_spatie_links_boven"  style="border-right: 1px solid white;">Einddatum: <%=strEinddatum%></td>
                                                        </tr>
                                                        <tr>
                                                           <%
                                                                if (rsInhoudFestivals.getString("fest_url") != null) {
                                                                String url = rsInhoudFestivals.getString("fest_url");
                                                                url = url.replace(" ", "%20");  //Bij een spatie in de url moet deze vervangen worden door %20 (spatie in hexadeci)
                                                           %>
                                                           <td style='padding-left: 10px; padding-bottom: 7px;'>
                                                                <a href="http://<%=url%>" target="_blank">Site</a>
                                                           </td>
                                                           <%} else {%>
                                                                <td></td>
                                                           <%}

                                                           calBegindatum.set(Calendar.YEAR, 0);
                                                           calBegindatum.set(Calendar.MONTH, 0);
                                                           calBegindatum.set(Calendar.DAY_OF_WEEK, 0);
                                                           if (begindatum.after(new Date()))
                                                           {%>
                                                               <td class="inhoud_tabel_spatie_rechts_onder">
                                                                   <input type="submit" name="btnDetails" value=" Details " />
                                                               </td>
                                                           <%} else {%>
                                                                 <td class="inhoud_tabel_spatie_rechts_onder">
                                                                     <div id="tekstkleur_verlopen_festival">Dit festival is verlopen</div>
                                                                 </td>
                                                           <%}%> <!-- Waarschuwing negeren. De controles worden hier genegeert en zo telt HTML 4 kolommen ipv 2 -->
                                                        </tr> <!-- Waarschuwing negeren. De controles worden hier genegeert en zo telt HTML 4 kolommen ipv 2 -->
                                                    </tbody>
                                                </table>
                                            </form>
                                       <%}
                                      } else {%>
                                      <div class="tekst_centreren">
                                            <h3>Helaas! Er zijn geen festivals gevonden...</h3>
                                            Klik <a href="festivals.jsp">hier</a> om terug te keren...
                                      </div>
                                      <%}
                            } catch (Exception e) {
                                out.println(e.getMessage());
                            }
                            finally
                            {
                                connectie.sluitConnectie(); //Connectie met de databank sluiten
                            }%>
                        </div> 
                </section>
            </div>
            <hr style="width: auto; margin-left: 20px; margin-right: 20px;" />
            <jsp:include page="voettekst.jsp" />
        </div>
     <a href="#boven"><div id="pagina_boven">Begin Pagina</div></a>   
    </body>
</html>