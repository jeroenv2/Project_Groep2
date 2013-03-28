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
        <script src="js/vendor/modernizr-2.6.2.min.js"></script>
    </head>
    <body>
        <div id="page_wrapper">
            <jsp:include page="header.jsp" />
            <jsp:include page="navigation.jsp" />
            <div id="content_wrapper">
                <section id="content">
                    <article>
                        <header>
                            <h2>Header van artikel 2</h2>
                        </header>
                        <p>Test van Anke's pc,ctetur adipisicing elit, sed do eiusmod tempor incididunt ut labore 
                        et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex 
                        ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla 
                        pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. </p>
                        <footer>
                            <h3>Footer van artike1 1</h3>
                        </footer>
                    </article>
                    <article>
                        <header>
                            <h2>Header van artikel 2</h2>
                        </header>
                            <p>Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore 
                            et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex 
                            ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla 
                            pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. </p>
                        <footer>
                            <h3>Footer van artike1 2</h3>
                        </footer>
                    </article>
                </section>
            </div>
            <hr style="width: auto; margin-left: 20px; margin-right: 20px;" />
            <jsp:include page="footer.jsp" />
        </div>
    </body>
</html>