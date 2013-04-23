<%-- 
    Document   : profiel
    Created on : Apr 13, 2013, 1:11:05 PM
    Author     : Steven Verheyen
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
            function controlePaswoordenAanmakenAccount() {
                if (document.getElementById("txtPaswoord").value !== document.getElementById("txtBevestigPaswoord").value) {
                    alert('Bevestigd paswoord komt niet overeen met het nieuwe paswoord!');
                    document.getElementById("txtPaswoord").style.border = '2px solid red';
                    document.getElementById("txtBevestigPaswoord").style.border = '2px solid red';

                    return false;
                } else {
                    return true;
                }
            }
            
            function klikAlgemeen()
            {
                var algemeen = document.getElementById("frmAlgemeen");
                var paswoorden = document.getElementById("frmPaswoorden");
                var ipLogging = document.getElementById("ipLogging");
                var accountMaken = document.getElementById("frmAccountMaken");
                paswoorden.style.display = 'none';
                ipLogging.style.display = 'none';
                accountMaken.style.display = 'none';
                algemeen.style.display = 'inline';
            }
            function klikPaswoord()
            {
                var algemeen = document.getElementById("frmAlgemeen");
                var paswoorden = document.getElementById("frmPaswoorden");
                var ipLogging = document.getElementById("ipLogging");
                var accountMaken = document.getElementById("frmAccountMaken");
                algemeen.style.display = 'none';
                ipLogging.style.display = 'none';
                accountMaken.style.display = 'none';
                paswoorden.style.display = 'inline';
            }
            function klikIpLogging()
            {
                var algemeen = document.getElementById("frmAlgemeen");
                var paswoorden = document.getElementById("frmPaswoorden");
                var ipLogging = document.getElementById("ipLogging");
                var accountMaken = document.getElementById("frmAccountMaken");
                algemeen.style.display = 'none';
                paswoorden.style.display = 'none';
                accountMaken.style.display = 'none';
                ipLogging.style.display = 'inline';
            }
            function klikAccountMaken()
            {
                var algemeen = document.getElementById("frmAlgemeen");
                var paswoorden = document.getElementById("frmPaswoorden");
                var ipLogging = document.getElementById("ipLogging");
                var accountMaken = document.getElementById("frmAccountMaken");
                algemeen.style.display = 'none';
                paswoorden.style.display = 'none';
                ipLogging.style.display = 'none';
                accountMaken.style.display = 'inline';
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
                            String[] adresOpgesplitst = adres.split("-");

                            String huisnmr = "";
                            String straatnaam = "";
                            String bus = "";
                            String postcode = "";
                            String gemeente = "";
                            String land = "";

                            if (adresOpgesplitst.length == 5) {
                                huisnmr = adresOpgesplitst[0];
                                straatnaam = adresOpgesplitst[1];
                                postcode = adresOpgesplitst[2];
                                gemeente = adresOpgesplitst[3];
                                land = adresOpgesplitst[4];
                            } else if (adresOpgesplitst.length == 6) //Wanneer er een bus bij een huisnummer is
                            {
                                huisnmr = adresOpgesplitst[0];
                                bus = adresOpgesplitst[1];
                                straatnaam = adresOpgesplitst[2];
                                postcode = adresOpgesplitst[3];
                                gemeente = adresOpgesplitst[4];
                                land = adresOpgesplitst[5];
                            }

                            //Conversies geboortedatum
                            String strGebDatum = new SimpleDateFormat("yyyy-MM-dd").format(gebruiker.getGeboorteDatum());
                    %>
                    <div id="profiel_navigatie">
                        <input type="button" id="btnAlgemeen" value=" Algemeen " style="margin-bottom: 2px; width:125px;" onClick="klikAlgemeen();" /><br />
                        <input type="button" id="btnPaswoord" value=" Paswoord " style="margin-bottom: 2px; width:125px;" onClick="klikPaswoord();" /><br/>
                        <input type="button" id="btnAccountMaken" value=" Account Maken " style="margin-bottom: 2px; width:125px;" onClick="klikAccountMaken();" /><br/>
                        <input type="button" id="btnIpLogging" value=" IP Logging " style="margin-bottom: 2px; width:125px;" onClick="klikIpLogging();" /><br/>
                        <form action="faces/gebruiker.xhtml" target="_blank">
                            <input type="submit" value="Admins" style="margin-bottom: 2px; width: 125px;"/>       
                        </form>
                        <form action="faces/tickettypes.xhtml" target="_blank">
                            <input type="submit" value="Tickets" style="margin-bottom: 2px; width: 125px;"/>       
                        </form>
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
                                             
                        
                        <!-- IP adressen te tonen -->
                        <div id="ipLogging" hidden>
                            <h2>IP Logging</h2>
                            
                            <%
                                Connectie_Databank connectie = new Connectie_Databank();

                                connectie.maakConnectie();
                                List<String> lijstParams = new ArrayList<String>();

                                //Laatste 10 IP adressen opzoeken
                                connectie.voerQueryUit("SELECT * FROM iplogging ORDER BY ip_datum desc LIMIT 10", lijstParams);
                                ResultSet rsInhoudIpLogging = connectie.haalResultSetOp();

                                rsInhoudIpLogging.last();
                                int lengteRsInhoudfestivals = rsInhoudIpLogging.getRow();

                                rsInhoudIpLogging.beforeFirst();

                                if (lengteRsInhoudfestivals > 0)
                                {
                                    while(rsInhoudIpLogging.next())
                                    {
                                        String strIpAdres = rsInhoudIpLogging.getString("ip_adres");
                                        if(strIpAdres.equals("0:0:0:0:0:0:0:1")) //Controle voor het geval de IP adres localhost is
                                        {
                                            strIpAdres = "127.0.0.1 (localhost)";
                                        }
                            %>
                                        <p>
                                            IP adres: <%= strIpAdres %><br/>
                                            Datum: <%= rsInhoudIpLogging.getString("ip_datum") %><br/>
                                        </p>
                                 <% }
                               }else
                                {%>
                                    Helaas! Er zijn nog geen IP adressen gelogd...
                                <% } %>
                        </div>
                         
                        
                        <form method="POST" action="account_aanmaken.jsp" id="frmAccountMaken" hidden onsubmit="return controlePaswoordenAanmakenAccount();">
                            <table>
                                <thead>
                                    <tr>
                                        <td colspan="2">
                                            <h2>Account Aanmaken</h2>
                                        </td>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr>
                                        <td class="inhoud_tabel_spatie_links_boven">Gebruikersnaam*: </td>
                                        <td class="inhoud_tabel_spatie_links_boven"><input type="text" id="txtAanmakenGebruikersnaam" name="txtAanmakenGebruikersnaam" placeholder="Gebruikersnaam" required pattern="[a-zA-Z0-9]{4,100}" title="minimum 4 en maximum 100 cijfers/letters"/></td>
                                    </tr>
                                    <tr>
                                        <td class="inhoud_tabel_spatie_links_boven">
                                            Huisnummer/bus*:
                                        </td>
                                        <td class="inhoud_tabel_spatie_links_boven">
                                            <input type="text" name="txtAanmakenHuisnummer" placeholder="Nmr" size="1" required pattern="[a-zA-Z0-9]{1,}" title="1 of meer letters/getallen zonder spaties" /> / 
                                            <input type="text" name="txtAanmakenBus" placeholder="Bus" size="1" pattern="[a-zA-Z0-9]{1,}" title="1 of meer letters/getallen zonder spaties" /> 
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="inhoud_tabel_spatie_links_boven">
                                            Straat*:
                                        </td>
                                        <td class="inhoud_tabel_spatie_links_boven">
                                            <input type="text" name="txtAanmakenStraatnaam" placeholder="Straatnaam" required pattern="[a-zA-Z0-9]{1,}" title="1 of meer letters/getallen zonder spaties" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="inhoud_tabel_spatie_links_boven">
                                            Postcode/Gemeente*:
                                        </td>
                                        <td class="inhoud_tabel_spatie_links_boven">
                                            <input type="text" name="txtAanmakenPostcode" placeholder="Postcode" size="6" required pattern="[a-zA-Z0-9]{1,}" title="1 of meer letters/getallen zonder spaties" />
                                            <input type="text" name="txtAanmakenGemeente"  placeholder="Gemeente" required pattern="[a-zA-Z0-9]{1,}" title="1 of meer letters/getallen zonder spaties" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="inhoud_tabel_spatie_links_boven">
                                            Land*:
                                        </td>
                                        <td class="inhoud_tabel_spatie_links_boven">
                                            <input type="text" name="txtAanmakenLand" placeholder="Land" required pattern="[a-zA-Z0-9]{1,}" title="1 of meer letters/getallen zonder spaties" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="inhoud_tabel_spatie_links_boven">Geboortedatum*: </td>
                                        <td class="inhoud_tabel_spatie_links_boven"><input type="date" name="dtAanmakenGebDat" placeholder="yyyy-MM-dd" required pattern="[0-9]{4}-[0-9]{2}-[0-9]{2}"/></td>
                                    </tr>
                                    <tr>
                                        <td class="inhoud_tabel_spatie_links_boven">Paswoord*: </td>
                                        <td class="inhoud_tabel_spatie_links_boven"><input type="password" id="txtPaswoord" name="txtAanmakenPaswoord" placeholder="Paswoord" required pattern="[a-zA-Z0-9]{4,12}" title="Minimum 4 en maximum 12 cijfers/letters ingeven"/></td>
                                    </tr>
                                    <tr>
                                        <td class="inhoud_tabel_spatie_links_boven">Bevestig paswoord*:</td>
                                        <td class="inhoud_tabel_spatie_links_boven"><input type="password" id="txtBevestigPaswoord" placeholder="Bevestig Paswoord" required/></td>
                                    </tr>
                                    <tr>
                                        <td class="inhoud_tabel_spatie_links_boven" colspan="2">
                                            <input type="submit" name="btnVerzend" value=" Maak aan "/> <input type="reset" name="btnReset" value=" Wis "/>
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                        </form>
                    </div>
                    <div style="clear: both;"></div>
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
