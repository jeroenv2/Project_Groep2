<%-- 
    Document   : festival_aanpassen
    Created on : Apr 9, 2013, 9:20:39 AM
    Author     : tar-aldaron
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
    <%ArrayList verwijder = new ArrayList();%>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Festivals</title>
        <link rel="stylesheet" href="css/normalize.css">
        <link rel="stylesheet" href="css/main.css">
        <script src="js/vendor/modernizr-2.6.2.min.js"></script>
        <!-- controleren of de checkbox van de datums aangevinkt is of niet -->
        <script>
            //Ervoor zorgen dat de datums niet getoond worden (of juist wel)
            //Bron: http://stackoverflow.com/questions/9280037/javascript-toggle-function-to-hide-and-display-text-how-to-add-images
            ;
            
            function onChangeCheckboxDatums()
            {
                var checked = document.getElementById("datumTonen").checked;
                var ele = document.getElementById("datums");
                
                if (checked)
                {
                    ele.style.display = "inline";
                }
                else
                {
                    ele.style.display = "none";
                }
            }

                
        </script>
    </head>
    <body>
        <div id="page_wrapper">
            <jsp:include page="header.jsp" />
            <jsp:include page="navigation.jsp" />
            <div id="content_wrapper">
                <section id="content">
                    <div align="center">
                        <%
                            try {
                                ArrayList<String> lijstLetters = new ArrayList<String>();
                                ArrayList<String> lijstLocaties = new ArrayList<String>();
                                Connectie_Databank connectie = new Connectie_Databank();

                                connectie.maakConnectie();
                                List<String> lijstParams = new ArrayList<String>();

                                connectie.voerQueryUit("SELECT * FROM festivals", lijstParams);
                                ResultSet res = connectie.haalResultSetOp();

                                res.last();
                                int lengteResultSet = res.getRow();

                                res.first();
                                res.previous();

                                if (lengteResultSet > 0) {
                        %>   
                        
                                <div style='padding-top: 25px; padding-bottom: 10px;'>

                                    <!-- Informatie Festivals -->
                                    <%
                                        res.first();    //Zorgen dat de cursor op de 1ste rij van de ResultSet staat
                                        res.previous(); //Zorgen dat de cursor op rij 0 komt te staan (anders wordt de 1ste rij niet meegenomen!!!)
                                        while (res.next()) {
                                            String id = res.getString("fest_id");
                                            String naam = res.getString("fest_naam");
                                            String beginDatum = res.getString("fest_datum");
                                            String locatie = res.getString("fest_locatie");
                                    %>
                                    <table id="<%=id%>" width='600px' style='border: 1px solid white;'>
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
%>
                                                <td style='padding-left: 10px; padding-top: 10px;'>Einddatum: <%=strEinddatum%></td>
                                                <td align='right' style='padding-right: 10px; padding-bottom: 10px;'>
                                                        <input type="submit" name="Details" value=" Details " />
                                                                                                                              
                  
                                            </tr>
                                            <tr>
                                                <%
                                                    if (res.getString("fest_url") != null) {
                                                        String url = res.getString("fest_url");
                                                %>
                                                <td style='padding-left: 10px; padding-bottom: 10px;'><a href='http://<%=url%>' target='_blank'>Site</a></td>
                                                <%
                                                } else {
                                                %>
                                                <td></td>
                                                <%}%>
                                                    <td></td>
                                                           <td style='padding-right: 10px;padding-bottom: 10px;' >
                                                                <input onclick='if (value =="Verwijderen"){
                                                                        value = "Niet verwijderen";
                                                                        document.getElementById(<%=id%>).style.backgroundColor="red";
                                                                       verwijder.add(<%=id%>);
                                                                   }
                                                                       else if(value !="Verwijderen")
                                                                   { 

                                                                       
                                                                       value = "Verwijderen";
                                                                       document.getElementById(<%=id%>).style.backgroundColor="";
                                                                       verwijder.remove(<%=id%>);

                                                                 }' type="button" value="Verwijderen" style="background: #14742a;padding: 2px 1px;color: #fff;border-color: #14742a;"/> 
                                                              
                                            </form>                              
            
                                                    
                                                </td>
                                            </tr>
                                        </tbody>
                                    </table><br />
                                    <%
                                        }
                                    } else {
                                    %>
                                    <h3>Helaas! Er zijn geen records gevonden...</h3>
                                    <%}
                                            connectie.sluitConnectie(); //Connectie met de databank sluiten
                                        } catch (Exception e) {
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