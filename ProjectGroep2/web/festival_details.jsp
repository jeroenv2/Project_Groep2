<%-- 
    Document   : layout
    Created on : 28-mrt-2013, 9:04:18
    Author     : robbie
--%>

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
        <jsp:useBean id="al" scope="application" class="beans.actionlisteners" />
        <script src="js/vendor/modernizr-2.6.2.min.js"></script>
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
                             draggable="true" ondragstart="<% al.dragstart(); %>"
                             />
                        Foto:&nbsp;&nbsp;
                    </article>
                    <article id="details">
                        <header>
                            <h2>Header van details</h2>
                        </header>
                            <p>Gegevens van festival</p>
                        <footer>
                            <h3>footer van details</h3>
                        </footer>
                    </article>
                    <article id="overzicht">
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