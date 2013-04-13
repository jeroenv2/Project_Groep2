<%-- 
    Document   : profiel
    Created on : Apr 13, 2013, 1:11:05 PM
    Author     : Steven Verheyen
--%>

<%@page import="java.text.DateFormat"%>
<%@page import="java.util.Locale"%>
<%@page import="java.util.Calendar"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>
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
        <title>Profiel Wijzigen</title>
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
                    <div id="ElementenCenter">
                        <%
                            try
                            {
                                beans.gegevensGebruiker gebruiker = (beans.gegevensGebruiker) session.getAttribute("gegevensGebruiker");
                                
                                //Conversies adres
                                //Adres opsplitsen d.m.v. regex
                                String adres = gebruiker.getAdres();
                                String[] adresOpgesplitst = adres.split("\\s+|,+|/"); //'+' voor meerdere spaties of komma's achter elkaar te verwijderen

                                String huisnmr = "";
                                String straatnaam = "";
                                String bus = "";
                                String postcode = "";
                                String gemeente = "";
                                String land = "";

                                if(adresOpgesplitst.length == 7)
                                {
                                    huisnmr = adresOpgesplitst[0];
                                    straatnaam = adresOpgesplitst[1];
                                    //adresOpgesplitst[2] -> ','
                                    postcode = adresOpgesplitst[3];
                                    gemeente = adresOpgesplitst[4];
                                    //adresOpgesplitst[5] -> '-'
                                    land = adresOpgesplitst[6];
                                } else if(adresOpgesplitst.length == 8) //Wanneer er een bus bij een huisnummer is
                                {
                                    huisnmr = adresOpgesplitst[0];
                                    bus = adresOpgesplitst[1];
                                    straatnaam = adresOpgesplitst[2];
                                    //adresOpgesplitst[3] -> ','
                                    postcode = adresOpgesplitst[4];
                                    gemeente = adresOpgesplitst[5];
                                    //adresOpgesplitst[6] -> '-'
                                    land = adresOpgesplitst[7];
                                }
                                //!!!Extra controle nodig voor landen en straten met spaties!!!

                                //Conversies geboortedatum
                                Date gebDatum = gebruiker.getGeboorteDatum();                            
                                int jaar = gebDatum.getYear();
                                int maand = gebDatum.getMonth();
                                int dag = gebDatum.getDay();
                            %>
                            <form method="POST" action="#">
                                <table id="TableWidth600Border">
                                    <tbody>
                                        <tr>
                                            <td class="TableDataPaddingLeftTop">
                                                Gebruikersnaam:
                                            </td>
                                            <td class="TableDataPaddingLeftTop">
                                                <input type="text" name="gebruikersnaam" value="${gegevens.gebruikersnaam}" readonly />
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="TableDataPaddingLeftTop">
                                                Huidig paswoord:
                                            </td>
                                            <td class="TableDataPaddingLeftTop">
                                                <input type="password" name="paswoord" value="" required />
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="TableDataPaddingLeftTop">
                                                Nieuw paswoord:
                                            </td>
                                            <td class="TableDataPaddingLeftTop">
                                                <input type="password" name="paswoord" value="" required />
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="TableDataPaddingLeftTop">
                                                Bevestigd paswoord:
                                            </td>
                                            <td class="TableDataPaddingLeftTop">
                                                <input type="password" name="paswoord" value="" required />
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="TableDataPaddingLeftTop" style="vertical-align: top;">
                                                Adres:
                                            </td>
                                            <td class="TableDataPaddingLeftTop">
                                                <input type="text" name="straatnaam" value="<%=straatnaam%>" required /> 
                                                <input type="text" name="huisnummer" value="<%=huisnmr%>" size="1" required /> 
                                                bus <input type="text" name="bus" value="<%=bus%>" size="1"  /> <br />
                                                <input type="text" name="postcode" value="<%=postcode%>" size="6" required /> 
                                                <input type="text" name="gemeente" value="<%=gemeente%>" required /><br />
                                                <input type="text" name="land" value="<%=land%>" required /><br />
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="TableDataPaddingLeftTop">
                                                Geboortedatum:
                                            </td>
                                            <td class="TableDataPaddingLeftTop">
                                                <input type="text" name="jaar" value="<%=jaar%>" size="1" required /> /
                                                <input type="text" name="maand" value="<%=maand%>" size="1" required /> /
                                                <input type="text" name="dag" value="<%=dag%>" size="1" required />
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="TableDataPaddingLeftTopBottom" colspan="2">
                                                <input type="submit" name="verzend" value=" Wijzig " /> <input type="reset" name="reset" value=" Wis " />
                                            </td>
                                        </tr>
                                    </tbody>
                                </table>
                            </form>
                        <%}catch(Exception e)
                        {%>
                            <div id="TekstCenter">
                                <h3>U dient eerst ingelogd te zien alvorens u uw profiel kan wijzigen</h3>
                                Klik <a href="index.jsp">hier</a> om naar de hoofdpagina te gaan...
                            </div>
                        <%}%>
                    </div>
                </section>
            </div>
            <hr style="width: auto; margin-left: 20px; margin-right: 20px;" />
            <jsp:include page="footer.jsp" />
        </div>
    </body>
</html>
