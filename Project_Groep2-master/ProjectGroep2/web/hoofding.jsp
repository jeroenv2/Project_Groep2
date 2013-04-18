<%-- 
    Document   : header
    Created on : 28-mrt-2013, 9:10:17
    Author     : robbie, Steven
--%>

<%@page import="beans.gegevensGebruiker"%>
<%@page import="java.util.List"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="Databank.Connectie_Databank"%>
<%@page import="java.util.ArrayList"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Hoofding</title>
        <link rel="stylesheet" href="css/normalize.css">
        <link rel="stylesheet" href="css/main.css">
        <script>
            var lijstFestivals = [];
            var lijstBands = [];
            
            //Bron: http://www.codemiles.com/javascript-examples/check-array-contains-a-value-using-javascript-t7796.html
            function bevatWaarde(array, zoekWaarde) {
                var lengteArray = array.length;
                
                while (lengteArray--)
                {
                    if (array[lengteArray] === zoekWaarde)
                    {
                        return true;
                    }
                }
                return false;
            }
            
            function vervangTekst()
            {
                if(document.getElementById("naam").value === "Onbestaande naam")
                {
                    document.getElementById("naam").value = "";
                }
            }
            
            function controleLijstenZoeken()
            {         
                var invoerZoekveld = document.getElementById('naam').value;

                if(bevatWaarde(lijstFestivals, invoerZoekveld))
                {
                    
                    var frmZoekenJS = document.getElementById('frmZoeken');
                    frmZoekenJS.naam.value = invoerZoekveld; //Waarde van 'naam' veranderen

                    frmZoekenJS.action = "festival_details.jsp"; //url veranderen van frmZoeken
                    frmZoekenJS.submit();
                }
                else if(bevatWaarde(lijstBands, invoerZoekveld))
                {
                    var frmZoekenJS = document.getElementById('frmZoeken');
                    frmZoekenJS.naam.value = invoerZoekveld; //Waarde van 'naam' veranderen

                    frmZoekenJS.action = "groep_details.jsp"; //url veranderen van frmZoeken
                    frmZoekenJS.submit();
                }
                else
                {
                    document.getElementById("naam").value = "Onbestaande naam";
                    return false;
                }
            }
        </script>
    </head>
    <header id="hoofding_omslag">
        <a href="index.jsp"><img src="img/header/logo.png" alt="Logo" width="250" style="padding-top: 10px; padding-left: 20px;"/></a>
        <div align="right">
            
            <!-- Zoekgedeelte -->
            <form method="POST" id="frmZoeken" onsubmit="return controleLijstenZoeken();">
                <input type="text" list="lijstGegevens" id="naam" name="naam" placeholder="Zoeken" onfocus="vervangTekst();" size="30" required title="Gelieve een naam in te geven"/>
                <datalist id="lijstGegevens">
                  <%
                      Connectie_Databank connectie = new Connectie_Databank();
                      List<String> lijstBands = new ArrayList<String>();
                      List<String> lijstFestivals = new ArrayList<String>();
                      
                      connectie.maakConnectie();
                      List<String> lijstParams = new ArrayList<String>();

                      connectie.voerQueryUit("SELECT DISTINCT fest_naam FROM festivals", lijstParams);
                      ResultSet rsInhoudFestivals = connectie.haalResultSetOp();

                      connectie.voerQueryUit("SELECT DISTINCT band_naam FROM bands", lijstParams);
                      ResultSet rsInhoudBands = connectie.haalResultSetOp();

                      while(rsInhoudFestivals.next())
                      {
                            String naamFestival = rsInhoudFestivals.getString("fest_naam");%>
                            <option value="<%=naamFestival%>"><%=naamFestival%> (Festival)</option>
                            <%=lijstFestivals.add(naamFestival)%>
                      <%}

                      while(rsInhoudBands.next())
                      {
                            String naamBand = rsInhoudBands.getString("band_naam");%>
                            <option value="<%=naamBand%>"><%=naamBand%> (Band)</option>
                            <%=lijstBands.add(naamBand)%>
                      <%}
                  %>
                </datalist>
                &nbsp;<input type="image" src="img/header/zoeken.png" alt="Logo" width="24" style="float: right;" />

                <%
                      for(String festivals : lijstFestivals)
                      {%>
                            <script>lijstFestivals.push("<%=festivals%>");</script>
               <%     }
                      for(String bands : lijstBands)
                      {%>
                            <script>lijstBands.push("<%=bands%>");</script>
               <%     }%>
            </form>
        </div><br />
        <%
            beans.gegevensGebruiker gebruiker = (beans.gegevensGebruiker) session.getAttribute("gegevensGebruiker");

            if(gebruiker != null)
            {
                String gebruikersnaam = gebruiker.getGebruikersnaam();
        %>
        <div id="opmaak_ingelogd">
                <div class="tekst_vet">Hallo <%=gebruikersnaam%></div>
                <a href="profiel.jsp">Profiel Aanpassen</a> | <a href="uitgelogd.jsp">Uitloggen</a>
        </div>
        <%  }
            else
            {
        %>
                <form id="login" method="post" action="inlog.jsp">
                    <input type="text" id="username" name="gebruikersnaam" placeholder="Gebruikersnaam" required />
                    <br/>
                    <input type="password" id="password" name="paswoord" placeholder="Paswoord" required />
                    <br/>
                    <input type="submit" value="Log In" id="loginButton"/>
                </form>
        <%  }%>
    </header>
</html>