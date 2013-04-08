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
              font-size:20px;
              font-weight:bold; 
            }
            #lijst{
                list-style-type: none;
                border:1px solid black;
                float:right; padding:10px;
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
                        lijstParams.add("Nirvana");
                       connectie.voerQueryUit("SELECT * FROM bands WHERE band_naam = ?", lijstParams);
                        ResultSet res = connectie.haalResultSetOp();

                      while(res.next()){
                      String g= res.getString("band_soortMuziek");
                      out.println(g);
                       }
                      
                       
                    
                    %>
                    <table  id="table">
                        <tbody>
                            <tr>
                                <td>
                                    <img src="img/bands/test_afbeelding_groepen.jpg" width="300px"  />
                                </td>
                                <td>
                                    
                                    <div align="center"> 
                                        <table>
                                            <tbody>
                                                <tr>
                                                    <td >Naam: </td>
                                                    <td>&nbsp;&nbsp;&nbsp; Netsky</td>
                                                </tr>
                                                <tr>
                                                    <td>Land herkomst:</td>
                                                    <td>&nbsp;&nbsp;&nbsp; Amerika</td>
                                                </tr>
                                                <tr>
                                                    <td>Genre:</td>
                                                    <td>&nbsp;&nbsp;&nbsp; Drum and base</td>
                                                </tr>
                                                <tr>
                                                    <td><a href="http://netskymusic.com/">Site groep </a></td>
                                                </tr>

                                            </tbody>
                                        </table>
                                    </div>
                                </td>
                                <td>
                                    <ul id="lijst">
                                        <li>festivals:</li>
                                        <li >&nbsp;&nbsp;&nbsp;<a href="http://www.rockwerchter.be/nl">Rock Werchter </a></li>
                                        <li>&nbsp;&nbsp;&nbsp;<a href="http://www.pukkelpop.be/nl/">Pukkelpop</a></li>
                                        <li>&nbsp;&nbsp;&nbsp;<a href="http://www.werchterboutique.be/fr">Werchter Boutique</a></li>
                                        <li>&nbsp;&nbsp;&nbsp;<a href="http://www.pinkpop.nl/2013/">Pinkpop</a></li>
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