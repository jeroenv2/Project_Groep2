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
        <title>Groepen</title>
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
                            try {
                                ArrayList<String> lijstGenres = new ArrayList<String>();

                                Connectie_Databank connectie = new Connectie_Databank();

                                connectie.maakConnectie();
                                List<String> lijstParams = new ArrayList<String>();

                                connectie.voerQueryUit("SELECT * FROM bands", lijstParams);
                                ResultSet res = connectie.haalResultSetOp();

                                res.last();
                                int lengteResultSet = res.getRow();

                                res.first();
                                res.previous();

                                if (lengteResultSet > 0) {
                        %>   
                        <form action='groepen_filter.jsp' method='POST'>
                            <table width='500px' style='border: 1px solid white;'>
                                <tbody>
                                    <tr>
                                        <td colspan="2" style='padding-left: 5px; padding-top: 5px; font-size: 24px;'><b>Geavanceerd Zoeken</b></td>
                                    </tr>
                                    <tr>
                                        <td style='padding-left: 10px;'><u>Genre:</u><br />
                                        <%while (res.next()) {
                                                String genre = res.getString("band_soortMuziek");

                                                if (!lijstGenres.contains(genre)) {
                                                    lijstGenres.add(genre);
                                                }
                                            }

                                            //De ArrayList alfabetisch ordenen
                                            java.util.Collections.sort(lijstGenres);
                                            for (String genre : lijstGenres) {
                                        %>
                                &nbsp;&nbsp;<input type='checkbox' name='genre' value='<%= genre%>' /> <%= genre%><br />
                                <%
                                    }
                                %>
                                </td>
                                <td></td>
                                </tr>
                                <tr>
                                    <td style='padding-left: 10px; padding-bottom: 5px; padding-top: 10px;'>
                                        <input type='submit' name='ZoekFilter' value=' Zoeken ' /> <input type='reset' name='ResetFilter' value=' Wissen ' /></td>
                                    <td></td>
                                </tr>
                                </tbody>
                            </table>
                        </form>
                        <div style='padding-top: 25px; padding-bottom: 10px;'>

                            <!-- Informatie groepen -->
                            <%
                                res.first();    //Zorgen dat de cursor op de 1ste rij van de ResultSet staat
                                res.previous(); //Zorgen dat de cursor op rij 0 komt te staan (anders wordt de 1ste rij niet meegenomen!!!)
                                while (res.next()) {
                                    String naam = res.getString("band_naam");
                                    String genre = res.getString("band_soortMuziek");
                                    String afbeelding = res.getString("band_afbeelding");
                            %>
                            <table width='500px' style='border: 1px solid white;'>
                                <tbody style='padding: 10px;'>
                                <form action="groepen_details.jsp" method="POST">
                                    <tr>
                                        <!-- width:5 zodat de kolom van de afbeelding altijd maar tot de grootte van de afbeelding uitgerokken wordt -->
                                        <td rowspan="4" style="width: 5px; padding: 5px;"><img src="img/bands/test_afbeelding_groepen.jpg" height="80px" alt="Afbeelding Band" /></td>
                                    </tr>
                                    <tr>
                                        <td style='padding-left: 10px; padding-top: 10px; border-top: 1px solid white;'><b><%= naam%></b></td>
                                        <input type="hidden" name="naam" value="<%=naam%>">
                                        <td  style="border-top: 1px solid white;"></td>
                                    </tr>
                                    <tr>
                                        <td style='padding-left: 10px; padding-top: 10px;'>Genre: <%=genre%></td>
                                        <td></td>
                                    </tr>
                                    <tr>
                                        <%
                                            if (res.getString("band_url") != null) {
                                                String url = res.getString("band_url");
                                        %>
                                        <td style='padding-left: 10px; padding-bottom: 6px;'><a href='http://<%=url%>' target='_blank'>Site</a></td>
                                    <%
                                    } else {
                                    %>
                                    <td></td>
                                    <%}%>
                                    <td align='right' style='padding-right: 10px; padding-bottom: 6px;'>
                                        <input type="submit" name="Details" value=" Details " />
                                    </td>
                                    </tr>
                                </form>
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