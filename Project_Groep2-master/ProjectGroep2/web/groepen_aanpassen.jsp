

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
        <script src="http://ajax.googleapis.com/ajax/libs/jquery/1.8.1/jquery.min.js"></script>
        <script>
            <%!List<String> groepen = new ArrayList();%>          
        </script>
        
    </head>
    <body>
        <a id="top"></a>
        <div id="page_wrapper">
            <jsp:include page="header.jsp" />
            <jsp:include page="navigation.jsp" />
            <div id="content_wrapper">
                <section id="content">
                    <div align="center">
                        
                         <%
                       groepen.clear();
                       
                       boolean Verwijder_knop=false;
                            if ((request.getParameter("elements") != null)&& request.getParameter("annuleren") == null) {
                                
                                for (String e : request.getParameterValues("elements")) {
                                    if(!groepen.contains(e)){
                                    groepen.add(e);}
                                }
                                
                            }
                            try {
                                ArrayList<String> lijstGenres = new ArrayList<String>();

                                Connectie_Databank connectie = new Connectie_Databank();

                                connectie.maakConnectie();
                                List<String> lijstParams = new ArrayList<String>();

                                connectie.voerQueryUit("SELECT * FROM bands ", lijstParams);
                                ResultSet res = connectie.haalResultSetOp();

                                res.last();
                                int lengteResultSet = res.getRow();

                                res.first();
                                res.previous();

                                if (lengteResultSet > 0) {
                        %>
                        
                            <%! String id = "";%>
                            <!-- Informatie groepen -->
                            <%
                                res.first();    //Zorgen dat de cursor op de 1ste rij van de ResultSet staat
                                res.previous(); //Zorgen dat de cursor op rij 0 komt te staan (anders wordt de 1ste rij niet meegenomen!!!)
                                while (res.next()) {
                                    id = res.getString("band_id");
                                    String naam = res.getString("band_naam");
                                    String genre = res.getString("band_soortMuziek");
                                    String afbeelding = res.getString("band_afbeelding");
                                    String styleTable;
                                    if (groepen.contains(id)) {
                                        styleTable = " background-color: red;";
                                    } else {
                                        styleTable = "";
                                    }
        %>
                            <table width='500px' style='border: 1px solid white;<%= styleTable%>'>
                                <tbody align="left" style='padding: 10px;'>
                                <form action="groepen_aanpassen.jsp" method="POST">
                                    <tr>
                                        <td rowspan="4" style="width: 120px; padding: 5px;"><img src="<%=afbeelding%>" width="120px" height="80px" alt="Afbeelding Band" /></td>
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
                                    <tr><td>
                                     <%
                                            String knop;
                                            if(!groepen.contains(id)){
                                            knop ="Verwijderen";
                                           %>
                                            
                                            <input name="elements" type="hidden" value="<%=id%>"/>
                                        <%}else{
                                                knop="Annuleren";
                                                Verwijder_knop=true;
                                                
                                            }
                                        %>
                                        
                                        </td>
                                        <td> <%
                                           
                                            
                                            for (String element : groepen) {
                                                if(!element.equals(id)){
                                                
                                                
                                                
                                                %>
                                    <input name="elements" type="hidden" value="<%=element%>"/>
                                    
                                    <%}
                                        
                                        }
                                    %></td>
                                        <td align='right' style='padding-right: 10px;padding-bottom: 10px;' >
                                        <input type="submit" value="<%=knop%>" style="background: #14742a;padding: 2px 1px;color: #fff;border-color: #14742a;"/>
                     </td>
                                        </tr>
                                </form>
                                </tbody>
                            </table><br />
                            <%
                                }%>
                                <form action="groepen_aanpassen_resultaat.jsp">
                                <table>
                                    <tr>
                                        <td>
                                            <%
                                                                                        
                                      for (String element : groepen) {%>
                                            <input name="elementsVerwijderen" type="hidden" value="<%=element%>"/>

                                            <%}
                                               String status = "visibility: visible;";
                                                if (!Verwijder_knop) {
                                                    status = "visibility: hidden;";
                                                }
                                            %>
                                        </td>
                                        <td><input type="submit" value="Verwijderen" style="background: #14742a;padding: 2px 1px;color: #fff;border-color: #14742a;<%= status %>"/> </td>
                                         </form>
                                        
                                         <form action="groepen_aanpassen.jsp" method="GET">
                                            <input id="annuleren_hidden" name="annuleren" type="hidden" value="false"/>
                                             
                                             <td>
                                                 <input name="annuleren" type="submit" value="Annuleren" style=" background: #14742a;padding: 2px 1px;color: #fff;border-color: #14742a;<%= status %>"/></td>
                                         </form>
                                        <td></td>

                                    </tr>
                                </table>

                            <%
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
        <a href="#top"><div id="TopPage"> Begin Pagina </div></a>
    </body>
</html>