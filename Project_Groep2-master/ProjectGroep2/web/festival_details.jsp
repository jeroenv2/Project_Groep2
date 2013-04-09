<%-- 
    Document   : layout
    Created on : 28-mrt-2013, 9:04:18
    Author     : robbie
--%>

<%@page import="Databank.Connectie_Databank"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.List"%>
<%@page import="java.sql.ResultSet"%>
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
        <title>JSP Page</title>
        <link rel="stylesheet" href="css/normalize.css">
        <link rel="stylesheet" href="css/main.css">
        <link rel="stylesheet" href="css/detailpages.css">
        <script src="js/vendor/modernizr-2.6.2.min.js"></script>
        <%
            Connectie_Databank connectie = new Connectie_Databank();

            connectie.maakConnectie();
            List<String> lijstParams = new ArrayList<String>();
            lijstParams.add(request.getParameter("naam"));

            connectie.voerQueryUit("SELECT f.fest_id, f.fest_naam, f.fest_locatie, f.fest_datum, f.fest_duur, f.fest_einddatum, f.fest_url, c.camp_cap"
                    + " FROM festivals f"
                    + " JOIN campingsperfestival cp ON f.fest_id = cp.fest_id"
                    + " JOIN campings c ON cp.camp_id = c.camp_id"
                    + " WHERE f.fest_naam = ?", lijstParams);
            ResultSet res = connectie.haalResultSetOp();
            res.first();
        %>
    </head>
    <body>
        <div id="page_wrapper">
            <jsp:include page="header.jsp" />
            <jsp:include page="navigation.jsp" />
            <div id="content_wrapper">
                <section id="content">
                    <article id="foto">
                        <img src="img/festivals/rock_werchter_2013.png"
                             alt="Rock Werchter 2013 - afbeelding" width="140px"
                             draggable="true"
                             />
                        Foto:&nbsp;&nbsp;
                    </article>
                    <article id="details">
                        <header>
                            <h2><%=res.getString(2)%></h2>
                        </header>
                        <!-- Naam van browser ophalen -->
                        <% String browser = request.getHeader("User-Agent"); %>
                        <!-- gemeente scheiden van land -->
                        <%
                            String land = "";
                            String gemeente = "";
                            String locatie = res.getString(3);
                                
                            int sep = locatie.indexOf("-");
                            land = locatie.substring(0, sep-1);
                            gemeente = locatie.substring(sep+1, locatie.length());
                        %>
                        <table>
                            <tbody>
                                <tr>
                                    <td>Land:</td>
                                    <td><%= land %></td>
                                </tr>
                                <tr>
                                    <td>Locatie:</td>
                                    <td><%= gemeente %></td>
                                </tr>
                                <tr>
                                    <td>Startdatum:</td>
                                    <td><%= res.getString(4) %></td>
                                </tr>
                                <tr>
                                    <td>Einddatum:</td>
                                    <td><%= res.getString(6) %></td>
                                </tr>
                                <tr>s
                                    <td>Duur:</td>
                                    <td><%= res.getInt(5) %></td>
                                </tr>
                                <tr>
                                    <td>Website:</td>
                                    <%  String website = res.getString(7);
                                    if (website != null) {%>
                                    <td><%= website %></td>
                                    <%} else {%>
                                    <td>Niet beschikbaar</td>
                                    <%}%>
                                </tr>
                                <tr>
                                    <td style="padding-right: 25px;">Capaciteit kamping:</td>
                                    <td><%= res.getString(8) %></td>
                                </tr>
                            </tbody>
                        </table>
                        <footer>
                            <h3>footer van details</h3>
                        </footer>
                    </article>
                    <article id="overzicht"
                             style="<% if (browser.contains("Chrome") || browser.contains("MSIE")) {%>margin-right: 45px;<%}%>">
                        <header>
                            <h2>Lijsten</h2>
                        </header>
                        <p>Festivallijst & toevoegen</p>
                        <footer>
                            <h3>borderfactory dinges</h3>
                        </footer>
                    </article>
                </section>
            </div>
            <hr style="width: auto; margin-left: 20px; margin-right: 20px;" />
            <jsp:include page="footer.jsp" />
        </div>
    </body>
</html>