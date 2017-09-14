<%-- 
    Main page for the [insert purpose] site.

    Geremy Desmanche | Samuel Goulet - 2017-09-14
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <script src="Javascript/jquery-3.2.1.min.js"></script>
        <script src="Javascript/jquery-ui.min.js"></script>
        <link rel="stylesheet" type="text/css" href="Css/index.css"></link>
        <link rel="stylesheet" type="text/css" href="Css/jquery-ui.min.css"></link>
        <link rel="stylesheet" type="text/css" href="Css/jquery-ui.structure.min.css"></link>
        <link rel="stylesheet" type="text/css" href="Css/jquery-ui.theme.min.css"></link>
        <title>JSP Page</title>
    </head>
    <body>
        <div id="global">
            <div id="container">
                <!-- Header portion, contains title and search functionality. -->
                <header id="header">
                    <div id="titleDiv">
                        <h1>Humour de programmeurs !</h1>
                    </div>
                    <div id="bannerDiv">
                        <div id="searchDiv">
                            <span class="searchLabel whiteText"> Recherche </span>
                            <input type="text" id="txtSearch"> 
                            <input type="button" id="btnSearch" value="?">
                        </div>
                    </div>
                </header>
                
                <!-- Navigation portion, contains stuff to interact with the DB -->
                <div id="navDiv">
                    <nav id="nav">
                        <input type="button" id="btnFirst" value="Premier">
                        <input type="button" id="btnPrev" value="Précédent">
                        <input type="button" id="btnOrder" value="Ordonner par score">
                        <input type="button" id="btnNext" value="Prochain">
                        <input type="button" id="btnLast" value="Dernier">
                    </nav>
                </div>
                
                <div id="contentDiv">
                    <div class="content_header">
                        <h1 id="content_title">Titre!</h1>
                        <span id="content_img_url">URL</span>
                    </div>
                    
                    <div class="content_body">
                        <h4 id="content_main">Content!</h4>
                        <img id="content_img" alt="Image goes here"></img>
                    </div>
                    
                    <!-- Here we give information about the result of search / nav. -->
                    <div id="buttonDiv" class="content_footer">
                        <input type ="button" id="btnNew" value="Nouveau">
                        <input type ="button" id="btnFlag" value="Signaler">
                        <!-- Keep that a bit safe.  -->
                        <input type ="button" id="btnUp" value=" + 1 ">
                        <input type ="button" id="btnDown" value=" - 1 ">
                    </div>
                </div>
                
                <!-- resources, links Jquery-animated names -->
                <footer>
                    <div class="footer_header">
                        <input type ="button" id="btnPrevFooter" value="Précédent">
                        <input type ="button" id="btnNextFooter" value="Suivant">
                    </div>
                    <span>Une production de Goulah! et Carl</span>
                    <!-- Liens et animation :D -->
                </footer>
            </div>
        </div>
    </body>
</html>