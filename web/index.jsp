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
        <script src="Javascript/index.js"></script>
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
                
                <div id="content">
                    <div id="content_grid">
                        <div id="content_title">
                            <h2 id="txtTitle" data-editType="input" class="canBeEditedEventually">Une blague de merde!</h2>
                        </div>
                        <div id="content_url">
                            <span id="txtUrl" data-editType="input" class="canBeEditedEventually">https://www.commitstrip.com/wp-content/uploads/2017/09/Strip-Faire-croire-au-bug-english650-final.jpg</span>
                        </div>
                        <div id="content_text">
                            <h4 id="txtText" data-editType="textArea" class="canBeEditedEventually">Content!</h4>
                        </div>
                        <div id="content_img">
                            <img id="content_img__img" alt="Image goes here" src="https://www.commitstrip.com/wp-content/uploads/2017/09/Strip-Faire-croire-au-bug-english650-final.jpg"></img>
                        </div>
                        <!-- Here we give information about the result of search / nav. -->
                        <div id="content_buttons">
                            <!-- Keep that a bit safe.  -->
                            <input type="button" id="btnUp" value=" + 1 ">
                            <span id="txtScore">0</span>
                            <input type="button" id="btnDown" value=" - 1 ">
                            <input type="button" id="btnFlag" value="Signaler">
                            <div id="content_buttons__spacer"></div>
                            <input type="button" id="btnNew" value="Nouveau">
                        </div>
                    </div>
                </div>
                
                <!-- resources, links Jquery-animated names -->
                <footer id="footer">
                    <div id="footer_header">
                        <input type ="button" id="btnPrevFooter" value="Précédent">
                        <input type ="button" id="btnNextFooter" value="Suivant">
                    </div>
                    <div id="animatedNames">
                        <div id="animatedText">
                            <span>Une production de Goulah! et Carl</span>
                            <!-- Liens et animation :D -->
                        </div>
                    </div>
                </footer>
            </div>
        </div>
    </body>
</html>