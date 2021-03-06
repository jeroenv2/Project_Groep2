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
            function controlePaswoorden() {
                if (document.getElementById("Nieuw").value !== document.getElementById("Hertype").value) {
                    alert('Bevestigd paswoord komt niet overeen met het nieuwe paswoord!');
                    document.getElementById("Nieuw").style.border = '2px solid red';
                    document.getElementById("Hertype").style.border = '2px solid red';

                    return false;
                } else {
                    return true;
                }
            }
            function klikAlgemeen()
            {
                var algemeen = document.getElementById("frmAlgemeen");
                var paswoorden = document.getElementById("frmPaswoorden");
                algemeen.style.display = 'inline';
                paswoorden.style.display = 'none';
                document.getElementById("Algemeen").style.backgroundColor = 'white;';
            }
            function klikPaswoord()
            {
                var algemeen = document.getElementById("frmAlgemeen");
                var paswoorden = document.getElementById("frmPaswoorden");
                algemeen.style.display = 'none';
                paswoorden.style.display = 'inline';
            }
            function klikFestival() 
            {

            }
            function klikAdmins()
            {

            }
        </script>
    </head>
    <body>
        <div id="pagina_omslag">
            <jsp:include page="hoofding.jsp" />
            <jsp:include page="navigatie.jsp" />
            <div id="inhoud_omslag">
                <section id="inhoud">
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
                    %>
                    <div id="profiel_navigatie">
                        <input type="button" id="btnAlgemeen" value=" Algemeen " style="margin-bottom: 2px; width:90px;" onClick="klikAlgemeen();" /><br />
                        <input type="button" id="btnPaswoord" value=" Paswoord " style="margin-bottom: 2px; width:90px;" onClick="klikPaswoord();" /><br/>
                        <input type="button" id="btnTicketsPerFestival" value="Tickets" style="margin-bottom: 2px; width:90px;" onClick="klikFestival;" /><br/>
                        <input type="button" id="btnAdminGegevens" value="Admins" style="margin-bottom: 2px; width:90px;" onClick="klikAdmins;" />
                    </div>
                    <div id="elementen_centreren">
                        <!-- Formulier om algemene gegevens aan te passen -->
                        <form method="POST" action="profiel_verwerking.jsp" id="frmAlgemeen">
                            <table>
                                <thead>
                                    <tr>
                                        <td colspan="2">
                                            <h2>Algemene Gegevens</h2>
                                        </td>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr>
                                        <td class="inhoud_tabel_spatie_links_boven inhoud_tabel_breedte_200px">
                                            Gebruikersnaam*:
                                        </td>
                                        <td class="inhoud_tabel_spatie_links_boven">
                                            <input type="text" name="txtGebruikersnaam" value="<%=gebruiker.getGebruikersnaam()%>" readonly />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="inhoud_tabel_spatie_links_boven">
                                            Geboortedatum*:
                                        </td>
                                        <td class="inhoud_tabel_spatie_links_boven">
                                            <input type="date" name="dtGeboorteDatum" value="<%=strGebDatum%>" placeholder="yyyy-MM-dd" required pattern="[0-9]{4}-[0-9]{2}-[0-9]{2}" /> 
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="inhoud_tabel_spatie_links_boven">
                                            Huisnummer/bus*:
                                        </td>
                                        <td class="inhoud_tabel_spatie_links_boven">
                                            <input type="text" name="txtHuisnummer" placeholder="Nmr" value="<%=huisnmr%>" size="1" required pattern="[a-zA-Z0-9]{1,}" title="1 of meer letters/getallen zonder spaties" /> / 
                                            <input type="text" name="txtBus" placeholder="Bus" value="<%=bus%>" size="1" pattern="[a-zA-Z0-9]{1,}" title="1 of meer letters/getallen zonder spaties" /> 
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="inhoud_tabel_spatie_links_boven">
                                            Straat*:
                                        </td>
                                        <td class="inhoud_tabel_spatie_links_boven">
                                            <input type="text" name="txtStraatnaam" placeholder="Straatnaam" value="<%=straatnaam%>" required pattern="[a-zA-Z0-9]{1,}" title="1 of meer letters/getallen zonder spaties" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="inhoud_tabel_spatie_links_boven">
                                            Postcode/Gemeente*:
                                        </td>
                                        <td class="inhoud_tabel_spatie_links_boven">
                                            <input type="text" name="txtPostcode" placeholder="Postcode" value="<%=postcode%>" size="6" required pattern="[a-zA-Z0-9]{1,}" title="1 of meer letters/getallen zonder spaties" />
                                            <input type="text" name="txtGemeente"  placeholder="Gemeente" value="<%=gemeente%>" required pattern="[a-zA-Z0-9]{1,}" title="1 of meer letters/getallen zonder spaties" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="inhoud_tabel_spatie_links_boven">
                                            Land*:
                                        </td>
                                        <td class="inhoud_tabel_spatie_links_boven">
                                            <input type="text" name="txtLand" placeholder="Land" value="<%=land%>" required pattern="[a-zA-Z0-9]{1,}" title="1 of meer letters/getallen zonder spaties" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="inhoud_tabel_spatie_links_boven_onder" colspan="2">
                                            <input type="submit" name="btnVerzend" value=" Wijzig " /> <input type="reset" name="btnWis" value=" Wis " />
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                        </form>

                        <!-- Formulier om paswoorden te veranderen -->
                        <form method="POST" action="profiel_verwerking.jsp" id="frmPaswoorden" hidden onsubmit="return controlePaswoorden();">
                            <table>
                                <thead>
                                    <tr>
                                        <td colspan="2">
                                            <h2>Paswoorden</h2>
                                        </td>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr>
                                        <td class="inhoud_tabel_spatie_links_boven inhoud_tabel_breedte_200px">
                                            Gebruikersnaam*:
                                        </td>
                                        <td class="inhoud_tabel_spatie_links_boven">
                                            <input type="text" name="txtGebruikersnaam" value="<%=gebruiker.getGebruikersnaam()%>" readonly />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="inhoud_tabel_spatie_links_boven">
                                            Huidig paswoord*:
                                        </td>
                                        <td class="inhoud_tabel_spatie_links_boven">
                                            <input type="password" name="passHuidigPaswoord" placeholder="Huidig paswoord" required />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="inhoud_tabel_spatie_links_boven">
                                            Nieuw paswoord*:
                                        </td>
                                        <td class="inhoud_tabel_spatie_links_boven">
                                            <!-- Wachtwoord tussen 5 en 12 letters/nummers -->
                                            <input type="password" name="passNieuwPaswoord" id="Nieuw" placeholder="Nieuw paswoord" pattern="[a-zA-Z0-9]{5,12}" title="Minimum 5 en maximum 12 letters/nummers" required />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="inhoud_tabel_spatie_links_boven">
                                            Bevestigd paswoord*:
                                        </td>
                                        <td class="inhoud_tabel_spatie_links_boven">
                                            <input type="password" name="passHertypePaswoord" id="Hertype" placeholder="Bevestigd paswoord" required />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="inhoud_tabel_spatie_links_boven_onder" colspan="2">
                                            <input type="submit" name="btnVerzend" value=" Wijzig " /> <input type="reset" name="btnWis" value=" Wis " />
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                        </form>
                    </div>
                    <%} catch (Exception e) {%>
                    <div class="tekst_centreren">
                        <h3>U dient eerst ingelogd te zien alvorens u uw profiel kan wijzigen</h3>
                        Klik <a href="index.jsp">hier</a> om naar de hoofdpagina te gaan...
                    </div>
                    <%}%>
                </section>
            </div>
            <hr style="width: auto; margin-left: 20px; margin-right: 20px;" />
            <jsp:include page="voettekst.jsp" />
        </div>
    </body>
</html>
