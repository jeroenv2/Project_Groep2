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
<html>
<!--<![endif]-->
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Festivals</title>
        <link rel="stylesheet" href="css/normalize.css">
        <link rel="stylesheet" href="css/main.css">
        <script src="js/vendor/modernizr-2.6.2.min.js"></script>
        <script src="http://ajax.googleapis.com/ajax/libs/jquery/1.8.1/jquery.min.js"></script>
        <script src="js/vendor/jquery.collapse.js"></script>
        <script>
            //Bron: http://stackoverflow.com/questions/9280037/javascript-toggle-function-to-hide-and-display-text-how-to-add-images
            function AanvinkenCheckboxDatums()
            {
                var chkAangevinkt = document.getElementById("datumTonen").checked;
                var ele = document.getElementById("datums");
                if (chkAangevinkt)
                {
                    ele.style.display = "inline";
                }
                else
                {
                    ele.style.display = "none";
                }
            }
            //Bron: http://www.javascript-coder.com/javascript-form/javascript-reset-form.phtml
            function FilterLegen() {
                var frmElementen = form_filter.elements;    
                for(i=0; i<frmElementen.length; i++)
                {
                    frmElementen[i].checked = false;
                }
            }
            window.onload = FilterLegen;
        </script>
    </head>
    <body>
        <a id="boven"></a>
        <div id="pagina_omslag">
            <jsp:include page="hoofdding.jsp" />
            <jsp:include page="navigatie.jsp" />
            <div id="inhoud_omslag">
                <section id="inhoud">
                    <div id="elementen_centreren">
                        <%
                            try
                            {
                                ArrayList<String> lijstLetters = new ArrayList<String>();
                                ArrayList<String> lijstLocaties = new ArrayList<String>();

                                Connectie_Databank connectie = new Connectie_Databank();

                                connectie.maakConnectie();
                                List<String> lijstParams = new ArrayList<String>();

                                connectie.voerQueryUit("SELECT * FROM festivals", lijstParams);
                                ResultSet rsInhoudfestivals = connectie.haalResultSetOp();

                                rsInhoudfestivals.last();
                                int lengteRsInhoudfestivals = rsInhoudfestivals.getRow();

                                rsInhoudfestivals.first();
                                rsInhoudfestivals.previous();

                                if (lengteRsInhoudfestivals > 0)
                                {
                        %>   
                                    <div data-collapse id="opmaak_openklapper">
                                        <h2 id="geavanceerd_zoeken_filter">+ Geavanceerd Zoeken </h2>
                                    <div>
                                      <form id="form_filter" action='festivals_filter.jsp' method='POST'>
                                        <table id="tabel_filter">
                                            <tbody id="inhoud_tabel_links_uitlijning" >
                                                <tr>
                                                    <td class="inhoud_tabel_breedte_300px">
                                                        <div class="tekst_onderlijning">Naam begint met:</div>
                                                        <%while (rsInhoudfestivals.next()) {
                                                                String letter = rsInhoudfestivals.getString("fest_naam").substring(0, 1);

                                                                if (!lijstLetters.contains(letter)) {
                                                                    lijstLetters.add(letter);
                                                                }
                                                            }

                                                            //De ArrayList alfabetisch ordenen
                                                            java.util.Collections.sort(lijstLetters);
                                                            for (String letter : lijstLetters) {
                                                        %>
                                                            &nbsp;&nbsp;&nbsp;&nbsp;<input type='checkbox' name='beginletter' value='<%= letter%>' /> <%= letter%><br />
                                                        <%
                                                            }
                                                        %>
                                                    </td>
                                                    <td class="TableDataPaddingLeftTop">
                                                        <div class="TekstOnderlijning">Locatie:</div>
                                                        <%
                                                            //Ervoor zorgen dat een locatie maar 1x getoond wordt (geen dubbels!)
                                                            rsInhoudfestivals.first();
                                                            rsInhoudfestivals.previous();
                                                            while (rsInhoudfestivals.next()) {
                                                                String locatie = rsInhoudfestivals.getString("fest_locatie");

                                                                if (!lijstLocaties.contains(locatie)) {
                                                                    lijstLocaties.add(locatie);
                                                                }
                                                            }

                                                            //De ArrayList alfabetisch ordenen
                                                            java.util.Collections.sort(lijstLocaties);
                                                            for (String locatie : lijstLocaties) {
                                                        %>
                                                        &nbsp;&nbsp;&nbsp;&nbsp;<input type='checkbox' name='locatieFestival' value='<%=locatie%>' /> <%= locatie%><br />
                                                        <%}%>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td class="inhoud_tabel_spatie_links_boven_onder">
                                                        <input type='checkbox' id='datumTonen' name='opDatum' onChange='AanvinkenCheckboxDatums();' /> Filteren op datums
                                                    </td>
                                                    <td></td>
                                                <tr>
                                                    <td colspan="2" style='padding-left: 10px;'>
                                                        <div id='datums' style='display: none;'>
                                                        Tussen <input type='date' name='begindatum' value='2013-04-01' style='font-size: 14px;' /> en&nbsp; <input type='date' name='einddatum' value='2013-04-01' style='font-size: 14px;' />
                                                        </div>
                                                    </td>
                                               </tr>
                                               <tr>
                                                   <td class="inhoud_tabel_spatie_links_boven_onder">
                                                       <input type='submit' name='ZoekFilter' value=' Zoeken ' /> <input type='reset' name='FilterLegen' value=' Wissen ' /></td>
                                                   <td></td>
                                               </tr>
                                        </tbody>
                                    </table>
                                 </form>
                              </div>
                            </div>   
                            <div id="WitruimteTabelFilter">
                                <!-- Informatie Festivals -->
                                <%
                                   rsInhoudfestivals.first();    //Zorgen dat de cursor op de 1ste rij van de ResultSet staat
                                   rsInhoudfestivals.previous(); //Zorgen dat de cursor op rij 0 komt te staan (anders wordt de 1ste rij niet meegenomen!!!)
                                   while (rsInhoudfestivals.next())
                                   {
                                       String naam = rsInhoudfestivals.getString("fest_naam");
                                       String beginDatum = rsInhoudfestivals.getString("fest_datum");
                                       String locatie = rsInhoudfestivals.getString("fest_locatie");
                                %>
                                       <form action="festival_details.jsp" method="POST">
                                          <table id="TableWidth600Border">
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
                                                         DateFormat formaatDatum = new SimpleDateFormat("yyyy-MM-dd");   //Formaat van datum bepalen
                                                         Date begindatum = formaatDatum.parse(beginDatum);

                                                         //Calendar gebruiken om dagen (duur) op te tellen bij de begindatum
                                                         Calendar cal = Calendar.getInstance();  //Huidige datum in cal steken
                                                         cal.setTime(begindatum);                //De begindatum in cal steken
                                                         cal.add(cal.DATE, Integer.parseInt(rsInhoudfestivals.getString("fest_duur")));    //Dagen (duur) optellen bij de begindatum

                                                         Date einddatum = cal.getTime(); //Nieuwe Date-obj maken als einddatum met de inhoud van cal
                                                         String strEinddatum = formaatDatum.format(einddatum); //Einddatum omzetten naar juiste formaat
                                                       %>
                                                       <td class="inhoud_tabel_spatie_links_boven"  style="border-right: 1px solid white;">Einddatum: <%=strEinddatum%></td>
                                                    </tr>
                                                    <tr>
                                                       <%
                                                            if (rsInhoudfestivals.getString("fest_url") != null) {
                                                            String url = rsInhoudfestivals.getString("fest_url");
                                                            url = url.replace(" ", "%20");  //Bij een spatie in de url moet deze vervangen worden door %20 (spatie in hexadeci)
                                                       %>
                                                       <td style='padding-left: 10px; padding-bottom: 7px;'>
                                                            <a href="http://<%=url%>" target="_blank">Site</a>
                                                       </td>
                                                       <%} else {%>
                                                            <td></td>
                                                       <%}

                                                       cal.set(Calendar.YEAR, 0);
                                                       cal.set(Calendar.MONTH, 0);
                                                       cal.set(Calendar.DAY_OF_WEEK, 0);
                                                       if (begindatum.after(new Date()))
                                                       {%>
                                                           <td class="TableDataPaddingRightBottom">
                                                               <input type="submit" name="Details" value=" Details " />
                                                           </td>
                                                       <%} else {%>
                                                             <td class="TableDataPaddingRightBottom">
                                                                 <div id="FontVerlopenFestival">Dit festival is verlopen</div>
                                                             </td>
                                                       <%}%> <!-- Warning negeren. De controles worden hier genegeert en zo telt HTML 4 kolommen ipv 2 -->
                                                    </tr> <!-- Warning negeren. De controles worden hier genegeert en zo telt HTML 4 kolommen ipv 2 -->
                                                </tbody>
                                            </table>
                                        </form>
                                   <%}
                                  } else {%>
                                        <h3>Helaas! Er zijn geen festivals gevonden...</h3>
                                  <%}
                            connectie.sluitConnectie(); //Connectie met de databank sluiten
                        } catch (Exception e) {
                            out.println(e.getMessage());
                        }%>
                    </div>
            </div>
        </section>
        </div>
            <hr style="width: auto; margin-left: 20px; margin-right: 20px;" />
            <jsp:include page="voettekst.jsp" />
        </div>
        <a href="#boven"><div id="pagina_boven">Begin Pagina</div></a>
    </body>
</html>