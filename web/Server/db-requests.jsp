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
    
    void outputJson(java.sql.ResultSet data, javax.servlet.jsp.JspWriter out) throws Exception {
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
                + data.getString("FlagAmount")
                + "\",\"date\":\""
                + data.getString("Date")
                + "\",\"index\":\""
                + data.getRow()
                + "\"}"
            );
        } catch (Exception ex1) {
            throw new Exception();
        }
    }
	
    java.sql.ResultSet getData(String orderBy, java.sql.Statement state) {
	try {
            if (orderBy == "score") {
                return state.executeQuery("select * from funnycontent order by Score;");
            } else {
		return state.executeQuery("select * from funnycontent order by Date;");
            }
	}
	catch (Exception ex) {
            return null;
	}
    }
    
    /* Fonctions that allow the check of a single session votings and flaggings. */
    byte getCurrVote(int index, int[] votings) {
        return (byte)((votings[index / 16] & (3 << index % 16)) >> index % 16);
    }
    
    byte getCurrFlag(int index, int[] flagings) {
        return (byte)((flagings[index / 32] & (1 << index % 32)) >> index % 32);
    }
%>

<%
    try {
        
        response.setContentType("application/json");
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
	
        /* Reading or creatign session attributes */
        /* Current Ind */
        Object ind = session.getAttribute("index");
        int index;
        if (ind == null) {
            index = 1;
            session.setAttribute("index", index);
        } else {
            index = (Integer)ind;
        }
        
        /* Flags and votings */
        Object flagings = session.getAttribute("flags");
        int[] flags;
        if (flagings == null) {
            flags = new int[1 + dataLength / 32];
            session.setAttribute("flags", flags);
        } else {
            flags = (int[])flagings;
        }
        
        /* Flags and votings */
        Object votings = session.getAttribute("votes");
        int[] votes;
        if (flagings == null) {
            votes = new int[1 + dataLength / 16];
            session.setAttribute("votes", votes);
        } else {
            votes = (int[])votings;
        }
        
        byte currVote = 0;
        byte currFlag = 0;
        
        /* Done with the session. */
        data.absolute(index);
        
        String[] possibleActions = {
            "prev", "next", "last", "first", "add", "upvote", "downvote", "flag"
        };
        
        int act = 0;
        while (act < possibleActions.length && !possibleActions[act].equalsIgnoreCase(action)) {
            act++;
        }
        if (act == 8) {
            response.sendError(418, "I'm a teapot");
            return;
        }
                
        /* Dealing with different actions */
	switch(act) {
            /* Reading Data, simply. */
            case 0:
                if (!data.isFirst()) {
                    data.previous();
                    index -= 1;
                }
		outputJson(data, out);
		break;
            case 1:
                if (!data.isLast()) {
                    data.next();
                    index += 1;
                }
		outputJson(data, out);
		break;
            case 2:
                data.last();
                index = dataLength;
		outputJson(data, out);
		break;
            case 3:
                data.first();
                index = 1;
		outputJson(data, out);
		break;

            /* Upvoting */
            case 5:
                currVote = getCurrVote(index, votes);
                if (currVote != 2) {
		    state.executeUpdate(
                        "update funnycontent set score=" 
                        + (Integer.parseInt(data.getString("score")) + 1)
                        + " where ID = "
                        + data.getString("ID")
                        + ";"
                    );
                    if (currVote == 1) {
                        currVote = 0;
                    } else {
                        currVote = 2;
                    }
                }
                
		data = getData(orderBy, state);
		data.absolute(index);
		outputJson(data, out);
		break;
		/* Downvoting */
            case 6:
                currVote = getCurrVote(index, votes);
                if (currVote != 1) {
		    state.executeUpdate(
                        "update funnycontent set score=" 
                        + (Integer.parseInt(data.getString("score")) - 1)
                        + " where ID = "
                        + data.getString("ID")
                        + ";"
                    );
                    if (currVote == 2) {
                        currVote = 0;
                    } else {
                        currVote = 1;
                    }
                }
				
		data = getData(orderBy, state);
		data.absolute(index);
		outputJson(data, out);
                break;
		/* Flagging */
            case 7:
                currFlag = getCurrFlag(index, flags);
                if (currFlag != 1) {
		    if (data.getString("FlagAmount") == "4") {
                        state.executeUpdate(
		      	    "delete from funnycontent where ID = " + data.getString("ID") + ";"
                        );
                        index = 1;
		    }
		    else {
                        state.executeUpdate(
                            "update funnycontent set score=" 
                            + (Integer.parseInt(data.getString("FlagAmount")) + 1)
                            + " where ID = "
                            + data.getString("ID")
                            + ";"
                        );
		    }
                    currFlag = 1;
                }
				
		data = getData(orderBy, state);
		data.absolute(index);
		outputJson(data, out);
		break;
            case 4: 
                String title = request.getParameter("title");
                String content = request.getParameter("content");
                String url = request.getParameter("url");
                
                if (title.length() > 64 || content.length() > 1024 || url.length() > 4096) {
                    response.sendError(418, "I'm a teapot");
                    return;
                }
                
                PreparedStatement statement = null;
                statement = con.prepareStatement(
                    "insert into funnycontent (Title, Content, ImageURL, Score, FlagAmount, Date) values (?, ?, ?, 0, 0, "
                    + DateTimeFormatter.ofPattern("yyyy-MM-dd").format(LocalDate.now()) + ");"
                );
                statement.setString(1, title);
                statement.setString(2, content);
                statement.setString(3, url);
                statement.executeUpdate();
                
                data = getData(orderBy, statement); /* This might fail */
                data.absolute(index);
                outputJson(data, out);
                break;
            default:
                response.sendError(418, "I'm a teapot");
                break;
	}
        session.setAttribute("index", index);
        flags[index / 32] |= currFlag << (index % 32);
        session.setAttribute("flags", flags);
        votes[index / 16] &= (-1 ^ 3 << (index % 16));
        votes[index / 16] = currVote << (index % 16);
        session.setAttribute("flags", votes);
    }
    catch (Exception ex) {
        /* Return some error Json here */
        response.sendError(418, "I'm a teapot");
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
                /* Return some error Json here */
                response.sendError(418, "I'm a teapot");
            }
        }
    }
%>