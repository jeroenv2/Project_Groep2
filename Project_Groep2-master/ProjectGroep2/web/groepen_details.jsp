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
<%!ArrayList<String> lijstFestivalNamen,lijstFestivalUrls;%>
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


        <title>Details van de Netsky</title>
        <link rel="stylesheet" href="css/normalize.css">
        <link rel="stylesheet" href="css/main.css">
        <script src="js/vendor/modernizr-2.6.2.min.js"></script>
        <style>
            #table
            {
                border-collapse:separate;
                border-spacing:  50px 20px ;
            }

            #opmaak{
                font-family: sans-serif;
                color: #fff; 
                font-size:25px;
                font-weight:bold; 
            }
            #lijstFestival{
                list-style-type: none;
                border:1px solid black;
                float:right; padding:90px 30px 90px 10px ;
                margin-top: 10px;  
            }
          

        </style>

    </head>
    <body>
        <div id="page_wrapper">
            <jsp:include page="header.jsp" />
            <jsp:include page="navigation.jsp" />
            <div id="content_wrapper">
                <section id="content">

                    <div id="opmaak" align="center"  >
                        Nirvana
                    </div>
                    <%

                        Connectie_Databank connectie = new Connectie_Databank();
                        connectie.maakConnectie();
                        List<String> lijstParams = new ArrayList<String>();

                        lijstParams.add("Kiss");
                        connectie.voerQueryUit("SELECT * FROM bands b, bandsperfestival bf, festivals f WHERE b.band_naam = ? and (b.band_id=bf.band_id and f.fest_id=bf.fest_id);", lijstParams);

                        ResultSet res = connectie.haalResultSetOp();
                        
                        lijstFestivalNamen= new ArrayList<String>();
                        lijstFestivalUrls=new ArrayList<String>();
                        i=0;
                        
                        while (res.next()) {
                            MuziekSoort = res.getString("band_soortMuziek");
                            SiteGroep = res.getString("band_url");
                            lijstFestivalNamen.add(res.getString("fest_naam"));  
                            lijstFestivalUrls.add(res.getString("fest_url"));
                            AfbeeldingGroep=res.getString("band_afbeelding");
                            i++;
                            
                        }
                       
                        
                    %>
                    <table  id="table">
                        <tbody>
                            <tr>
                                <td>
                                    <img src="<%=AfbeeldingGroep%>" width="300px"  />
                                </td>
                                <td> </br>   </td>
                                <td>

                                    <div align="center"> 
                                        <table>
                                            <tbody>
                                                <tr>
                                                    <td >Naam: </td>
                                                    <td>&nbsp;&nbsp;Netsky</td>
                                                </tr>
                                                <tr>
                                                    <td>Genre:</td>
                                                    <td>&nbsp;&nbsp;<%= MuziekSoort%></td>
                                                </tr>
                                                <tr>
                                                    <td></br></td>
                                                </tr>
                                                <tr>
                                                    <td><a href="http://<%= SiteGroep%>/">Site Groep </a></td>
                                                </tr>

                                            </tbody>
                                        </table>
                                    </div>
                                </td>
                                <td></br></td>
                                <td>
                                    <ul id="lijstFestival" align="top">
                                        <li align="top" class="">festivals:</li>

                                        <% for (int j = 0; j < i; j++) {%>
                                        <li >&nbsp;&nbsp;<a href="http://<% out.println(lijstFestivalUrls.get(j));%>/nl"> <%out.println(lijstFestivalNamen.get(j));%> </a></li>
                                            <% }%>

                                    </ul>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </section>
            </div>
            <hr style="width: auto; margin-left: 20px; margin-right: 20px;" />
            <jsp:include page="footer.jsp" />
        </div>
    </body>
</html>