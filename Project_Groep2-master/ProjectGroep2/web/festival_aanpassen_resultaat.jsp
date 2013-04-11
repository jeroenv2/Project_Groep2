<%-- 
    Document   : festival_aanpassen
    Created on : Apr 9, 2013, 9:20:39 AM
    Author     : tar-aldaron
--%>

<%@page import="javax.swing.JOptionPane"%>
<%@page import="sun.font.Script"%>
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
        <title>Festivals</title>
        <link rel="stylesheet" href="css/normalize.css">
        <link rel="stylesheet" href="css/main.css">
        <script src="js/vendor/modernizr-2.6.2.min.js"></script>
        <script>
             
        </script>
    </head>
    <body>
        <%!List<String> verwijder = new ArrayList();%>
        <div id="page_wrapper">
            <jsp:include page="header.jsp" />
            <jsp:include page="navigation.jsp" />
            <div id="content_wrapper">
                <section id="content">
                    <div align="center">
                        <%
                        int aantal=0;
                        if (request.getParameter("elementsVerwijderen") != null) {
                                List<String> festivals = new ArrayList();
                                for (String e : request.getParameterValues("elementsVerwijderen")) {
                                    festivals.add(e);
                                    
                                }                                            
                                Connectie_Databank connectie = new Connectie_Databank();
                                                    try {
                                    
                                
                                                connectie.maakConnectie();
                                                String verwijder_query = "DELETE FROM tickets";

                                                if (!festivals.isEmpty()) {
                                                    verwijder_query += " WHERE (fest_id = ?";
                                                    for (int i = 1; i < festivals.size(); i++) {
                                                        verwijder_query += " OR fest_id = ?";
                                                    }
                                                    verwijder_query += ")";
                                                    
                                                    aantal=connectie.updateQuery(verwijder_query, festivals);
                                                }

                                            } catch (Exception e) {
                                                out.println(e.getMessage());
                                            } finally {
                                                connectie.sluitConnectie();//Connectie met de databank sluiten}
                        
                                                                       }
                                try {
                                    
                                
                                                connectie.maakConnectie();
                                                String verwijder_query = "DELETE FROM tickettypesperfestival";

                                                if (!festivals.isEmpty()) {
                                                    verwijder_query += " WHERE (fest_id = ?";
                                                    for (int i = 1; i < festivals.size(); i++) {
                                                        verwijder_query += " OR fest_id = ?";
                                                    }
                                                    verwijder_query += ")";
                                                    
                                                    aantal=connectie.updateQuery(verwijder_query, festivals);
                                                }

                                            } catch (Exception e) {
                                                out.println(e.getMessage());
                                            } finally {
                                                connectie.sluitConnectie();//Connectie met de databank sluiten}
                        
                                                                       }
                                        try {
                                    
                                
                                                connectie.maakConnectie();
                                                String verwijder_query = "DELETE FROM campingsperfestival";

                                                if (!festivals.isEmpty()) {
                                                    verwijder_query += " WHERE (fest_id = ?";
                                                    for (int i = 1; i < festivals.size(); i++) {
                                                        verwijder_query += " OR fest_id = ?";
                                                    }
                                                    verwijder_query += ")";
                                                    
                                                    aantal=connectie.updateQuery(verwijder_query, festivals);
                                                }

                                            } catch (Exception e) {
                                                out.println(e.getMessage());
                                            } finally {
                                                connectie.sluitConnectie();//Connectie met de databank sluiten}
                        
                                                                       }
                                try {
                                    
                                
                                                connectie.maakConnectie();
                                                String verwijder_query = "DELETE FROM bandsperfestival";

                                                if (!festivals.isEmpty()) {
                                                    verwijder_query += " WHERE (fest_id = ?";
                                                    for (int i = 1; i < festivals.size(); i++) {
                                                        verwijder_query += " OR fest_id = ?";
                                                    }
                                                    verwijder_query += ")";
                                                    
                                                    aantal=connectie.updateQuery(verwijder_query, festivals);
                                                }

                                            } catch (Exception e) {
                                                out.println(e.getMessage());
                                            } finally {
                                                connectie.sluitConnectie();//Connectie met de databank sluiten}
                        
                                                                       }
                                try {
                                    
                                
                                                connectie.maakConnectie();
                                                String verwijder_query = "DELETE FROM festivals";

                                                if (!festivals.isEmpty()) {
                                                    verwijder_query += " WHERE (fest_id = ?";
                                                    for (int i = 1; i < festivals.size(); i++) {
                                                        verwijder_query += " OR fest_id = ?";
                                                    }
                                                    verwijder_query += ")";
                                                    
                                                    aantal=connectie.updateQuery(verwijder_query, festivals);
                                                }

                                            } catch (Exception e) {
                                                out.println(e.getMessage());
                                            } finally {
                                                connectie.sluitConnectie();//Connectie met de databank sluiten}
                        
                                                                       }}
                        
                        %>
                        
                        Er zijn <%= aantal %> festivals verwijderd.<br />
                        <strong><a href="festival_aanpassen.jsp">Terug</a></strong>
                        
                    </div>
                </section>
            </div>
            <hr style="width: auto; margin-left: 20px; margin-right: 20px;" />
            <jsp:include page="footer.jsp" />
        </div>
    </body>
</html>