<%-- 
    Document   : profiel_verwerking
    Created on : Apr 14, 2013, 10:35:33 AM
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
        <title>Festivals</title>
        <link rel="stylesheet" href="css/normalize.css">
        <link rel="stylesheet" href="css/main.css">
        <script src="js/vendor/modernizr-2.6.2.min.js"></script>
        <script src="http://ajax.googleapis.com/ajax/libs/jquery/1.8.1/jquery.min.js"></script>
        <script src="js/vendor/jquery.collapse.js"></script>
        <script>
            //Bron: http://stackoverflow.com/questions/9280037/javascript-toggle-function-to-hide-and-display-text-how-to-add-images
            function onChangeCheckboxDatums()
            {
                var checked = document.getElementById("datumTonen").checked;
                var ele = document.getElementById("datums");
                if (checked)
                {
                    ele.style.display = "inline";
                }
                else
                {
                    ele.style.display = "none";
                }
            }
            //Bron: http://www.javascript-coder.com/javascript-form/javascript-reset-form.phtml
            function resetFilter() {
                var form_elementen = form_filter.elements;    
                for(i=0; i<form_elementen.length; i++)
                {
                    form_elementen[i].checked = false;
                }
            }
            window.onload = resetFilter;
        </script>
    </head>
    <body>
        <div id="page_wrapper">
            <jsp:include page="header.jsp" />
            <jsp:include page="navigation.jsp" />
            <div id="content_wrapper">
                <section id="content">
                    <div id="ElementenCenter">
                        <div id="TekstCenter">
                            <h3>Uw profielgegevens zijn met succes gewijzigd</h3>
                            klik <a href="index.jsp">hier</a> om naar de hoofdpagina te gaan...                            
                        </div>
                    </div>
        </section>
        </div>
            <hr style="width: auto; margin-left: 20px; margin-right: 20px;" />
            <jsp:include page="footer.jsp" />
        </div>
    </body>
</html>