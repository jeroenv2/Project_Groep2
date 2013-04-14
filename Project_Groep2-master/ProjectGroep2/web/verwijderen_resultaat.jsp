<%-- 
    Document   : verwijderen_resultaat
    Created on : Apr 14, 2013, 9:47:37 AM
    Author     : tar-aldaron
--%>

<%@page import="javax.print.DocFlavor.STRING"%>
<%@page import="sun.font.Script"%>
<%@page import="java.util.List"%>
<%@page import="java.util.Locale"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="Databank.Connectie_Databank"%>
<%@page import="java.util.ArrayList"%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
    </head>
    <body>
        <div id="page_wrapper">
            <jsp:include page="header.jsp" />
            <jsp:include page="navigation.jsp" />
            <div id="content_wrapper">
                <section id="content">
                    <div align="center">

                        <%
                            Connectie_Databank connectie = new Connectie_Databank();
                            String doel = "";
                            int aantal = 0;
                            if (request.getParameter("festivalsVerwijderen") != null) {

                                List<String> festivals = new ArrayList();
                                for (String e : request.getParameterValues("festivalsVerwijderen")) {
                                    festivals.add(e);
                                }

                                List<String> tabellen = new ArrayList();
                                tabellen.add("tickets");
                                tabellen.add("tickettypesperfestival");
                                tabellen.add("campingsperfestival");
                                tabellen.add("bandsperfestival");
                                tabellen.add("festivals");


                                try {
                                    connectie.maakConnectie();
                                    for (String tabel : tabellen) {
                                        String verwijder_query = "DELETE FROM " + tabel;
                                        verwijder_query += " WHERE (fest_id = ?";
                                        for (int i = 1; i < festivals.size(); i++) {
                                            verwijder_query += " OR fest_id = ?";
                                        }
                                        verwijder_query += ")";

                                        aantal = connectie.updateQuery(verwijder_query, festivals);
                                    }
                                } catch (Exception e) {
                                    out.println(e.getMessage());
                                } finally {
                                    connectie.sluitConnectie();//Connectie met de databank sluiten}
                                    if (aantal > 1) {
                                        doel = "festivals";
                                    } else {
                                        doel = "festival";
                                    }
                                }
                            }
                            if (request.getParameter("groepenVerwijderen") != null) {

                                List<String> groepen = new ArrayList();
                                for (String e : request.getParameterValues("groepenVerwijderen")) {
                                    groepen.add(e);
                                }

                                List<String> tabellen2 = new ArrayList();
                                tabellen2.add("bandsperfestival");
                                tabellen2.add("bands");

                                try {
                                    connectie.maakConnectie();
                                    for (String tabel : tabellen2) {
                                        String verwijder_query = "DELETE FROM " + tabel;
                                        verwijder_query += " WHERE (band_id = ?";
                                        for (int i = 1; i < groepen.size(); i++) {
                                            verwijder_query += " OR band_id = ?";
                                        }
                                        verwijder_query += ")";

                                        aantal = connectie.updateQuery(verwijder_query, groepen);
                                    }
                                } catch (Exception e) {
                                    out.println(e.getMessage());
                                } finally {
                                    connectie.sluitConnectie();//Connectie met de databank sluiten}
                                    if (aantal > 1) {
                                        doel = "groepen";
                                    } else {
                                        doel = "groep";
                                    }
                                }
                            }


                        %>
                        Er zijn <%= aantal%> <%= doel%> verwijderd.<br />
                        <%if (doel.equals("groep") || doel.equals("groepen")) {%>
                        <strong><a href="groepen_aanpassen.jsp">Terug</a></strong>
                        <% } else {%> 

                        <strong><a href="festival_aanpassen.jsp">Terug</a></strong>
                        <%}%>
                    </div>
                </section>
            </div>
            <hr style="width: auto; margin-left: 20px; margin-right: 20px;" />
            <jsp:include page="footer.jsp" />
        </div>
    </body>
</html>