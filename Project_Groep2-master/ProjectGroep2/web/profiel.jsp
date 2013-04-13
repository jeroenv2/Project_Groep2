<%-- 
    Document   : profiel
    Created on : Apr 13, 2013, 1:11:05 PM
    Author     : Steven Verheyen
--%>

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
        <title>Profiel</title>
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
                    <div id="ElementenCenter">
                        <%
                            //Adres opsplitsen d.m.v. regex
                            String adres = "46 Grotlaan, Maaseik - Belgie";
                            String[] adresOpgesplitst = adres.split("\\s+|,+"); //'+' voor meerdere spaties of komma's achter elkaar te verwijderen
                            
                            String huisnmr = adresOpgesplitst[0];
                            String straatnaam = adresOpgesplitst[1];
                            //adresOpgesplitst[2] -> ','
                            String gemeente = adresOpgesplitst[3];
                            //adresOpgesplitst[4] -> '-'
                            String land = adresOpgesplitst[5];
                        %>
                        <form method="POST" action="#">
                            <table id="TableWidth600Border">
                                <tbody>
                                    <tr>
                                        <td class="TableDataPaddingLeftTop">
                                            Gebruikersnaam:
                                        </td>
                                        <td class="TableDataPaddingLeftTop">
                                            <input type="text" name="gebruikersnaam" value="${gegevens.gebruikersnaam}" readonly />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="TableDataPaddingLeftTop">
                                            Huidig paswoord:
                                        </td>
                                        <td class="TableDataPaddingLeftTop">
                                            <input type="password" name="paswoord" value="" required />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="TableDataPaddingLeftTop">
                                            Nieuw paswoord:
                                        </td>
                                        <td class="TableDataPaddingLeftTop">
                                            <input type="password" name="paswoord" value="" required />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="TableDataPaddingLeftTop">
                                            Bevestigd paswoord:
                                        </td>
                                        <td class="TableDataPaddingLeftTop">
                                            <input type="password" name="paswoord" value="" required />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="TableDataPaddingLeftTop" style="vertical-align: top;">
                                            Adres:
                                        </td>
                                        <td class="TableDataPaddingLeftTop">
                                            <input type="text" name="adres" value="<%=straatnaam%>" required /> <input type="text" name="adres" value="<%=huisnmr%>" size="1" required /><br />
                                            <input type="text" name="adres" value="<%=gemeente%>" required /><br />
                                            <input type="text" name="adres" value="<%=land%>" required /><br />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="TableDataPaddingLeftTop">
                                            Geboortedatum:
                                        </td>
                                        <td class="TableDataPaddingLeftTop">
                                            <input type="text" name="geboorteDatum" value="${gegevens.geboorteDatum}" size="50" required />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="TableDataPaddingLeftTopBottom" colspan="2">
                                            <input type="submit" name="verzend" value=" Wijzig " /> <input type="reset" name="reset" value=" Wis " />
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                        </form>
                    </div>
                </section>
            </div>
            <hr style="width: auto; margin-left: 20px; margin-right: 20px;" />
            <jsp:include page="footer.jsp" />
        </div>
    </body>
</html>
