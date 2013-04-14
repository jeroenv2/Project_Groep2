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
        <script type="text/javascript">
            function checkPaswoorden() {
                if(document.form_profiel.NieuwPaswoord.value !== document.form_profiel.HertypePaswoord.value){
                    
                    alert('Bevestigd paswoord komt niet overeen met het nieuwe paswoord!');
                    //Border textfield rood maken
                    
                    document.form_profiel.HertypePaswoord.style.border='2px solid red';
                    //document.getElementById("HertypeWachtwoord").className = document.getElementById("HertypeWachtwoord").className + " WachtwoordError";
                    return false;
                } else {
                    return true;
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
                    <div id="ElementenCenter">
                        <%
                            try {
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

                                if (adresOpgesplitst.length == 7) {
                                    huisnmr = adresOpgesplitst[0];
                                    straatnaam = adresOpgesplitst[1];
                                    //adresOpgesplitst[2] -> ','
                                    postcode = adresOpgesplitst[3];
                                    gemeente = adresOpgesplitst[4];
                                    //adresOpgesplitst[5] -> '-'
                                    land = adresOpgesplitst[6];
                                } else if (adresOpgesplitst.length == 8) //Wanneer er een bus bij een huisnummer is
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
                                String strGebDatum = new SimpleDateFormat("yyyy-MM-dd").format(gebruiker.getGeboorteDatum());
                                Date gebDatum = new SimpleDateFormat("yyyy-MM-dd").parse(strGebDatum);
                        %>
                        <h1>Profiel Aanpassen</h1>
                        <form method="POST" action="#" name="form_profiel" onsubmit="return checkPaswoorden();">
                            <table>
                                <tbody>
                                    <tr>
                                        <td class="TableDataPaddingLeftTop">
                                            Gebruikersnaam*:
                                        </td>
                                        <td class="TableDataPaddingLeftTop">
                                            <input type="text" name="gebruikersnaam" value="${gegevens.gebruikersnaam}" readonly />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="TableDataPaddingLeftTop">
                                            Huidig paswoord*:
                                        </td>
                                        <td class="TableDataPaddingLeftTop">
                                            <input type="password" name="paswoord" required />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="TableDataPaddingLeftTop">
                                            Nieuw paswoord:
                                        </td>
                                        <td class="TableDataPaddingLeftTop">
                                            <!-- Wachtwoord tussen 5 en 12 letters/nummers -->
                                            <input type="password" name="NieuwPaswoord" pattern="[a-zA-Z0-9]{5,12}" title="Minimum 5 en maximum 12 letters/nummers" required />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="TableDataPaddingLeftTop">
                                            Bevestigd paswoord:
                                        </td>
                                        <td class="TableDataPaddingLeftTop">
                                            <input type="password" name="HertypePaswoord" required />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="TableDataPaddingLeftTop" style="vertical-align: top;">
                                            Adres*:
                                        </td>
                                        <td class="TableDataPaddingLeftTop">
                                            <input type="text" name="straatnaam" value="<%=straatnaam%>" required pattern="[a-zA-Z0-9]{1,}" title="1 of meer letters/getallen zonder spaties" /> 
                                            <input type="text" name="huisnummer" value="<%=huisnmr%>" size="1" required pattern="[a-zA-Z0-9]{1,}" title="1 of meer letters/getallen zonder spaties" /> 
                                            bus <input type="text" name="bus" value="<%=bus%>" size="1" pattern="[a-zA-Z0-9]{1,}" title="1 of meer letters/getallen zonder spaties" /> <br />
                                            <input type="text" name="postcode" value="<%=postcode%>" size="6" required pattern="[a-zA-Z0-9]{1,}" title="1 of meer letters/getallen zonder spaties" /> 
                                            <input type="text" name="gemeente" value="<%=gemeente%>" required pattern="[a-zA-Z0-9]{1,}" title="1 of meer letters/getallen zonder spaties" /><br />
                                            <input type="text" name="land" value="<%=land%>" required pattern="[a-zA-Z0-9]{1,}" title="1 of meer letters/getallen zonder spaties" /><br />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="TableDataPaddingLeftTop">
                                            Geboortedatum*:
                                        </td>
                                        <td class="TableDataPaddingLeftTop">
                                            <input type="date" name="geboorteDatum" value="<%=strGebDatum%>" /> 
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
                        <%} catch (Exception e) {%>
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
