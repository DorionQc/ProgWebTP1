<%-- 
    Server part dealing with requests from JQuery. 
	
    Geremy Desmanche & Samuel Goulet 
    2017-09-14
--%>

<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.time.LocalDate"%>
<%@page import="java.time.format.DateTimeFormatter"%>
<%!
    java.sql.Connection con;
    java.sql.Statement state;
    
    void outputJson(java.sql.ResultSet data, javax.servlet.jsp.JspWriter out) {
        try {
            out.print(
                "{\"ID\":\"" 
                + data.getString("ID") 
                + "\",\"title\":\""
                + data.getString("Title") 
                + "\",\"content\":\""
                + data.getString("Content") 
                + "\",\"imageUrl\":\""
                + data.getString("ImageURL") 
                + "\",\"score\":\""
                + data.getString("Score")
                + "\",\"flagAmount\":\""
                + data.getString("flagAmount")
                + "\",\"date\":\""
                + data.getString("Date")
                + "\",\"index\":"
                + data.getRow()
                + "\"}"
            );
        } catch (Exception ex1) {
            try {
                out.print("{\"ID\":\"error\"");
            } catch (Exception ex2) {
                ; // really
            }
        }
    }
	
    java.sql.ResultSet getData(String orderBy, java.sql.Statement state) {
	try {
            if (orderBy == "score") {
                return state.executeQuery("select * from contenudrole order by Score;");
            } else {
		return state.executeQuery("select * from contenudrole order by Date;");
            }
	}
	catch (Exception ex) {
            return null;
	}
    }
    
%>
    
<%
    try {
	/* Getting parameters from request. */
        String orderBy = request.getParameter("orderBy");
        /*
            Possible values :
            "score"
            "[literally anything else]"
        */
        
	String action = request.getParameter("action");
        /*
            Possible values :
        
        */
        
        Object ind = session.getAttribute("index");
        int index;
        if (ind == null) {
            session.setAttribute("index", 1);
            index = 1;
        } else {
            index = (int)ind;
        }
	//Integer.parseInt(request.getParameter("index"));
	int dataLength;
		
	/* Opening the dataBase and reading its data. */
        Class.forName("com.mysql.jdbc.Driver").newInstance();
        con = java.sql.DriverManager.getConnection(
            "jdbc:mysql://localhost/tp1",
            "root", ""
        );   
        state = con.createStatement();
        java.sql.ResultSet data = getData(orderBy, state);

	data.last();
	dataLength = data.getRow();
	
        data.absolute(index);
        
        /* Dealing with different actions */
	switch(action) {
            /* Reading Data, simply. */
            case "prev":
                if (!data.isFirst()) {
                    data.previous();
                }
		outputJson(data, out);
		break;
            case "next":
                if (!data.isLast()) {
                    data.next();
                }
		outputJson(data, out);
		break;
            case "last":
                data.last();
		outputJson(data, out);
		break;
            case "first":
                data.first();
		outputJson(data, out);
		break;
            /* Upvoting */
            case "upvote":
		state.executeUpdate(
                    "update contenudrole set score=" 
                    + (Integer.parseInt(data.getString("score")) + 1)
                    + " where ID = "
                    + data.getString("ID")
                    + ";"
                );
                
		data = getData(orderBy, state);
		data.absolute(index);
		outputJson(data, out);
		break;
		/* Downvoting */
            case "downvote":
		state.executeUpdate(
                    "update contenudrole set score=" 
                    + (Integer.parseInt(data.getString("score")) - 1)
                    + " where ID = "
                    + data.getString("ID")
                    + ";"
                );
				
		data = getData(orderBy, state);
		data.absolute(index);
		outputJson(data, out);
                break;
		/* Flagging */
            case "flag":
		if (data.getString("flagAmount") == "4") {
                    state.executeUpdate(
			"delete from contenudrole where ID = " + data.getString("ID") + ";"
                    );
		}
		else {
                    state.executeUpdate(
                        "update contenudrole set score=" 
                        + (Integer.parseInt(data.getString("flagAmount")) + 1)
                        + " where ID = "
                        + data.getString("ID")
                        + ";"
                    );
		}
				
		data = getData(orderBy, state);
		data.absolute(index);
		outputJson(data, out);
		break;
            case "add": 
                PreparedStatement statement = null;
                statement = con.prepareStatement(
                    "insert into contenudrole (Title, Content, ImageURL, Score, flagAmount, Date) values (?, ?, ?, 0, 0, "
                    + DateTimeFormatter.ofPattern("yyyy-MM-dd").format(LocalDate.now()) + ");"
                );
                statement.setString(1, request.getParameter("title"));
                statement.setString(2, request.getParameter("content"));
                statement.setString(3, request.getParameter("url"));
                statement.executeUpdate();
                break;
            default:
		out.print("{\"ID\":\"error\"");
                break;
	}
    }
    catch (Exception ex) {
        ;
    }
    finally {
        try {
            state.close();
            con.close();   
        }
        catch (Exception ex){
            try {
                con.close();
            }
            catch (Exception ex2) {
                ;
            }
        }
        /* Return some error Json here */
        out.print("{\"ID\":\"error\"");
    }
%>
