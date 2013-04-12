<%-- 
    Document   : layout
    Created on : 28-mrt-2013, 9:04:18
    Author     : Steven
--%>
<!-- Door rowspan te gebruiken, krijgt men hier een warning. Dit is een bug in Netbeans -->
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
        <title>Groepen</title>
        <link rel="stylesheet" href="css/normalize.css">
        <link rel="stylesheet" href="css/main.css">
        <script src="js/vendor/modernizr-2.6.2.min.js"></script>
        
        <!-- Collapsible scripts -->
        <script src="http://ajax.googleapis.com/ajax/libs/jquery/1.8.1/jquery.min.js"></script>
        <script src="js/vendor/jquery.collapse.js"></script>
        <script>
            //Bron: http://www.javascript-coder.com/javascript-form/javascript-reset-form.phtml
            function resetFilter() {
                var form_elementen = form_filter.elements;    
                for(i=0; i<form_elementen.length; i++)
                {
                    form_elementen[i].checked = false;
                }
            }
            window.onload = resetFilter;
        </script>
    </head>
    <body>
        <a id="top"></a>
        <div id="page_wrapper">
            <jsp:include page="header.jsp" />
            <jsp:include page="navigation.jsp" />
            <div id="content_wrapper">
                <section id="content">
                    <div id="ElementenCenter">
                        <%
                            try {
                                ArrayList<String> lijstGenres = new ArrayList<String>();

                                Connectie_Databank connectie = new Connectie_Databank();

                                connectie.maakConnectie();
                                List<String> lijstParams = new ArrayList<String>();

                                connectie.voerQueryUit("SELECT b.*, bf.*, f.fest_naam FROM bands b, bandsperfestival bf, festivals f WHERE b.band_id = bf.band_id AND bf.fest_id = f.fest_id", lijstParams);
                                ResultSet res = connectie.haalResultSetOp();

                                res.last();
                                int lengteResultSet = res.getRow();

                                res.first();
                                res.previous();

                                if (lengteResultSet > 0) {
                        %>
                        <div data-collapse id="CollapseOpmaak">
                            <h2 id="geavZoeken">+ Geavanceerd Zoeken </h2>
                        <div>
                        <form id="form_filter" action='groepen_filter.jsp' method='POST'>
                            <table id="TableFilter">
                                <tbody class="tbodyAlignLeft">
                                    <tr>
                                        <td><div class="TekstOnderlijning">Genre:</div>
                                        <%while (res.next()) {
                                                String genre = res.getString("band_soortMuziek");

                                                if (!lijstGenres.contains(genre)) {
                                                    lijstGenres.add(genre);
                                                }
                                            }
                                            res.first();
                                            res.previous();
                                            
                                            //De ArrayList alfabetisch ordenen
                                            java.util.Collections.sort(lijstGenres);
                                            for (String genre : lijstGenres) {
                                        %>
                                &nbsp;&nbsp;&nbsp;&nbsp;<input type='checkbox' name='genre' value='<%= genre%>' /> <%= genre%><br />
                                <%
                                    }
                                %>
                                </td>
                                <td>
                                <div class="TekstOnderlijning">Festival:</div>
                                <%
                                      List<String> lijstFestivals = new ArrayList<String>();
                                      while (res.next()) {
                                                String festival = res.getString("fest_naam");

                                                if (!lijstFestivals.contains(festival)) {
                                                    lijstFestivals.add(festival);
                                                }
                                            }
                                      //De ArrayList alfabetisch ordenen
                                            java.util.Collections.sort(lijstFestivals);
                                            for (String festival : lijstFestivals) {
                                        %>
                                &nbsp;&nbsp;&nbsp;&nbsp;<input type='radio' name='festival' value='<%=festival%>' /> <%=festival%><br />
                                <%
                                    }
                                %>
                                </td>
                                </tr>
                                <tr>
                                    <td class="TableDataPaddingLeftTopBottom">
                                        <input type='submit' name='ZoekFilter' value=' Zoeken ' /> 
                                        <input type='reset' name='ResetFilter' value=' Wissen ' /></td>
                                    <td></td>
                                </tr>
                                </tbody >
                            </table>
                        </form>
                        </div>
                        </div>
                                
                        <div id="WitruimteTabelFilter">
                            <!-- Informatie groepen -->
                            <%
                                res.first();    //Zorgen dat de cursor op de 1ste rij van de ResultSet staat
                                res.previous(); //Zorgen dat de cursor op rij 0 komt te staan (anders wordt de 1ste rij niet meegenomen!!!)
                                while (res.next()) {
                                    String naam = res.getString("band_naam");
                                    String genre = res.getString("band_soortMuziek");
                                    String afbeelding = res.getString("band_afbeelding");
                            %>
                            <form action="groepen_details.jsp" method="POST">
                            <table id="TableWidth600Border">
                                <tbody class="tbodyAlignLeft" style='padding: 10px;'>
                                    <tr>
                                        <td rowspan="4" style="width: 120px;">
                                            <img id="afbeeldingOpmaak" src="<%=afbeelding%>" alt="Afbeelding Band" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="TableDataPaddingLeftTop" style="border-top: 1px solid white;"><b>
                                                <div class="TekstVet"> <%= naam%> </div>
                                                <input type="hidden" name="naam" value="<%=naam%>">
                                        </td>
                                        <td style="border-top: 1px solid white;"></td>
                                    </tr>
                                    <tr>
                                        <td class="TableDataPaddingLeftTop">Genre: <%=genre%></td>
                                        <td></td>
                                    </tr>
                                    <tr>
                                        <%
                                            if (res.getString("band_url") != null) {
                                                String url = res.getString("band_url");
                                                url = url.replace(" ", "%20"); //Spatie vervangen door %20 in url
                                        %>
                                                <td class="TableDataPaddingLeftBottom">
                                                    <a href="http://<%=url%>" target="_blank">Site</a>
                                                </td>
                                        <% } else { %>
                                                <td></td>
                                        <%}%>
                                        <td class="TableDataPaddingRightBottom">
                                            <input type="submit" name="Details" value=" Details " />
                                        </td>
                                    </tr> <!-- Warning negeren. De controle wordt genegeerd. Daarom ziet HTML 3 kolommen ipv 2 -->
                                </tbody>
                            </table>
                            </form>
                            <%
                                }
                            } else {
                            %>
                            <h3>Helaas! Er zijn geen groepen gevonden...</h3>
                            <%}
                                    connectie.sluitConnectie(); //Connectie met de databank sluiten
                                } catch (Exception e) {
                                    out.println(e.getMessage());
                                }
                            %>
                        </div>
                    </div>
                </section>
            </div>
            <hr style="width: auto; margin-left: 20px; margin-right: 20px;" />
            <jsp:include page="footer.jsp" />
        </div>
        <a href="#top"><div id="TopPage">Begin Pagina</div></a>
    </body>
</html>