<%-- 
    Main page for the [insert purpose] site.

    Geremy Desmanche | Samuel Goulet - 2017-09-14
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
    </head>
    <body>
        <!-- Header portion, contains title and search functionality. -->
        <header>
            <div id="titleDiv">
            <h1>Humour de programmeurs !</h1>
            </div>
            <div id="searchDiv">
                <form action="maybeAFile.jsp"> <!-- TOBEDONE -->
                    <p> Recherche </p>
                    <input type="text" id="txtSearch" name="txtSearch"> 
                    <input type="button" id="btnSearch" name="btnSearch" value="..">
                </form>
            </div>
        </header>
        
        <!-- Navigation portion, contains stuff to interact with the DB -->
        <div id="navDiv">
            <nav>
                <form action="maybeAFile.jsp"> <!-- Same -->
                    <input type="button" id="btnFirst" name="btnFirst" value="Premier">
                    <input type="button" id="btnPrev" name="btnPrev" value="Précédent">
                    <input type="button" id="btnOrder" name="btnOrder" value="Ordonner par score">
                    <input type="button" id="btnNext" name="btnNext" value="Prochain">
                    <input type="button" id="btnLast" name="btnLast" value="Dernier">
                </form>
            </nav>
        </div>
        
        <!-- Here we give information about the result of search / nav. -->
        <form action="maybeAFile.jsp">
            <div id="buttonDiv">
                <input type ="button" id="btnNew" name="btnNew" value="Nouveau">
                <input type ="button" id="btnFlag" name="btnFlag" value="Signaler">
                <!-- Keep that a bit safe.  -->
                <input type ="button" id="btnUp" name="btnUp" value=" + 1 ">
                <input type ="button" id="btnDown" name="btnDown" value=" - 1 ">
            </div>
            <div id="contentDiv">
                
            </div>

        </form>
        <!-- resources, links Jquery-animated names -->
        <footer>
            
        </footer>
    </body>
</html>