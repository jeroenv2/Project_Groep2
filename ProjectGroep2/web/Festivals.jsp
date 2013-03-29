<%-- 
    Document   : layout
    Created on : 28-mrt-2013, 9:04:18
    Author     : robbie
--%>

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
        <title>Festivals</title>
        <link rel="stylesheet" href="css/normalize.css">
        <link rel="stylesheet" href="css/main.css">
        <script src="js/vendor/modernizr-2.6.2.min.js"></script>
    </head>
    <body>
        <div id="page_wrapper">
            <jsp:include page="header.jsp" />
            <div align="center" style="margin-top: 10px;"> <!-- ::VERWIJDEREN NA STATISCH MAKEN:: -->
                <a href="index.jsp"><img src="img/HomeWhite.png" alt="Home" height="30px" /></a> 
                <a href="Festivals.jsp"><img src="img/Festivals_Sel.png" alt="Festivals" height="30px" /></a> 
                <a href="Groepen.jsp"><img src="img/GroepenWhite.png" alt="Groepen" height="30px" /></a> 
            </div>
            <div id="content_wrapper">
                <section id="content">
                    <div align="center">
                        <%
                            ArrayList<String> lijstLetters = new ArrayList<String>();
                            
                            //Genereren uit bestaande groepen (DB) (substring)
                            lijstLetters.add("A");
                            lijstLetters.add("B");
                            lijstLetters.add("C");
                            lijstLetters.add("D");
                            lijstLetters.add("E");
                            lijstLetters.add("F");

                            for(int i=0; i<lijstLetters.size()-1; i++) //Ervoor zorgen dat het niet eindigt met '|'
                            {
                                out.println(lijstLetters.get(i) + " | ");
                            }
                            out.println(lijstLetters.get(lijstLetters.size()-1));
                        %>
                        
                    </div>
                    <div align="center" style="padding-top: 25px; padding-bottom: 10px;">
                        <!-- HTML5 table (doorlopen met foreach van gegevens uit DB (aantal records) -->
                        <table width="600px" style="border: 1px solid white;">
                            <tbody style="padding: 10px;">
                                <tr>
                                    <td style="padding-left: 10px; padding-top: 10px;"><b>Pukkelpop</b></td>
                                    <td style="padding-left: 10px; padding-top: 10px;">Begindatum: 20-12-2012</td>
                                    <td></td>
                                </tr>
                                <tr>
                                    <td style="padding-left: 10px; padding-top: 10px; padding-bottom: 10px">Locatie: hier en daar</td>
                                    <td style="padding-left: 10px; padding-top: 10px;">Einddatum: 21-12-2012</td>
                                    <td></td>
                                </tr>
                                <tr>
                                    <td style="padding-left: 10px; padding-bottom: 10px;"><a href="#">Site</a></td>
                                    <td></td>
                                    <td align="right" style="padding-right: 10px; padding-bottom: 10px;"><input type="button" name="Detail" value=" Detail " /></td>
                                </tr>
                            </tbody>
                        </table><br />

                        <!-- ::VERWIJDEREN NA UITLEZEN DB:: -->
                        <table width="600px" style="border: 1px solid white;">
                            <tbody style="padding: 10px;">
                                <tr>
                                    <td style="padding-left: 10px; padding-top: 10px;"><b>Rock Werchter</b></td>
                                    <td style="padding-left: 10px; padding-top: 10px;">Begindatum: 20-12-2012</td>
                                    <td></td>
                                </tr>
                                <tr>
                                    <td style="padding-left: 10px; padding-top: 10px; padding-bottom: 10px">Locatie: hier en daar</td>
                                    <td style="padding-left: 10px; padding-top: 10px;">Einddatum: 21-12-2012</td>
                                    <td></td>
                                </tr>
                                <tr>
                                    <td style="padding-left: 10px; padding-bottom: 10px;"><a href="#">Site</a></td>
                                    <td></td>
                                    <td align="right" style="padding-right: 10px; padding-bottom: 10px;"><input type="button" name="Detail" value=" Detail " /></td>
                                </tr>
                            </tbody>
                        </table>
                        <!-- ::EINDE VERWIJDERING:: -->

                    </div>
                </section>
            </div>
            <hr style="width: auto; margin-left: 20px; margin-right: 20px;" />
            <jsp:include page="footer.jsp" />
        </div>
    </body>
</html>