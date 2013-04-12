<%-- 
    Document   : layout
    Created on : 28-mrt-2013, 9:04:18
    Author     : anke
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="Databank.Connectie_Databank" %>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.sql.ResultSetMetaData"%>
<%@page import="java.util.List"%>
<%@page import="com.mysql.jdbc.StringUtils"%>
<%!String MuziekSoort, SiteGroep, FestivalNamen, FestivalUrls, AfbeeldingGroep;%>
<%!ArrayList<String> lijstFestivalNamen, lijstFestivalUrls;%>
<%! int i;%>
<!DOCTYPE html>
<!--[if lt IE 7]>      <html class="no-js lt-ie9 lt-ie8 lt-ie7"> <![endif]-->
<!--[if IE 7]>         <html class="no-js lt-ie9 lt-ie8"> <![endif]-->
<!--[if IE 8]>         <html class="no-js lt-ie9"> <![endif]-->
<!--[if gt IE 8]><!-->
<html class="no-js">
    <!--<![endif]-->
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <%

            Connectie_Databank connectie = new Connectie_Databank();
            connectie.maakConnectie();
            List<String> lijstParams = new ArrayList<String>();

            lijstParams.add(request.getParameter("naam"));
            connectie.voerQueryUit("SELECT * FROM bands b, bandsperfestival bf, festivals f WHERE b.band_naam = ? and (b.band_id=bf.band_id and f.fest_id=bf.fest_id);", lijstParams);

            ResultSet res = connectie.haalResultSetOp();


            lijstFestivalNamen = new ArrayList<String>();
            lijstFestivalUrls = new ArrayList<String>();
            i = 0;


            while (res.next()) {
                MuziekSoort = res.getString("band_soortMuziek");
                SiteGroep = res.getString("band_url");
                lijstFestivalNamen.add(res.getString("fest_naam"));
                lijstFestivalUrls.add(res.getString("fest_url"));
                AfbeeldingGroep = res.getString("band_afbeelding");
                i++;

            }

        %>
       
         <!-- Naam van browser ophalen -->
         <% String browser = request.getHeader("User-Agent"); %>
        <title><% out.println(request.getParameter("naam"));%> - Details</title>
        <link rel="stylesheet" href="css/normalize.css">
        <link rel="stylesheet" href="css/main.css">
        <link rel="stylesheet" href="css/detailpages.css">
        <script src="js/vendor/modernizr-2.6.2.min.js"></script>
    </head>
    <body>
        <div id="page_wrapper">
            <jsp:include page="header.jsp" />
            <jsp:include page="navigation.jsp" />
            <div id="content_wrapper">
                <section id="content">
                    <article id="foto">
                        <img src="<%=AfbeeldingGroep%>" alt="foto <%out.println(request.getParameter("naam"));%> " width="95%" draggable="true"  />
                    </article>
                    <article id="details">
                        <header>
                            <h2> <% out.println(request.getParameter("naam"));%></h2>
                        </header>
                        <table >
                            <tbody>
                                <tr>
                                    <td >Naam: </td>
                                    <td> <% out.println(request.getParameter("naam"));%> </td>
                                </tr>
                                <tr>
                                    <td>Genre:</td>
                                    <td>   <%= MuziekSoort%></td>
                                </tr>
                                <tr>
                                    <td><br/></td>
                                </tr>
                                <tr>
                                    <td><a href="http://<%= SiteGroep%>/">Site Groep </a></td>
                                </tr>

                            </tbody>
                        </table>
                    </article>
                    <article id="overzicht" style="<% if (browser.contains("Chrome") || browser.contains("MSIE")) {%>margin-right: 45px;<%}%>">
                         <!-- Naam van browser ophalen -->
                        
                        <header>
                            <h2>Overzicht</h2>
                        </header>
                        <div id="lijsten" data-collapse="persist">
                            <p class="open">Festivals</p>
                            <ul  >
                            <% for (int j = 0; j < i; j++) {%>
                            <li >&nbsp;&nbsp;<a href="http://<% out.println(lijstFestivalUrls.get(j));%>"> <%out.println(lijstFestivalNamen.get(j));%> </a></li>
                                <% }%>

                        </ul>
                        </div>
                    </article>
                </section>
            </div>
            <hr style="width: auto; margin-left: 20px; margin-right: 20px;" />
            <jsp:include page="footer.jsp" />
        </div>
    </body>
</html>
