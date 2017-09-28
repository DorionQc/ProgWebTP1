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
            if (orderBy.equals("score")) {
                return state.executeQuery("select * from funnycontent order by Score DESC;");
            } else {
		return state.executeQuery("select * from funnycontent order by Date;");
            }
	}
	catch (Exception ex) {
            return null;
	}
    }
    
    /* Fonctions that allow the check of a single session votings and flaggings. */
    int getCurrVote(int ID, int[] votings) {
        return ((votings[ID / 16] & (3 << ID % 16)) >> ID % 16);
    }
    
    int getCurrFlag(int ID, int[] flagings) {
        return ((flagings[ID / 32] & (1 << ID % 32)) >> ID % 32);
    }
    
    void sendError(javax.servlet.http.HttpServletResponse response, String msg) {
        try {
            response.sendError(418, msg);
        } catch (Exception ex2) {
            return;
        }
    }
    
    int findPostByID(int ID, java.sql.ResultSet data) {
        int i = 1;
        try {
            while (data.next() && data.getInt("ID") != ID) {
                i++;
            }
            if (data.isAfterLast()) {
                return 1;
            }
            return i;
        } catch (Exception ex) {
            return 1;
        }
    }
%>

<%
    try {
        session.setMaxInactiveInterval(1800000000);
        response.setContentType("application/json");
	/* Getting parameters from request. */
        String orderBy = request.getParameter("orderBy");
        /*
            Possible values :
            "score"
            "[literally anything else]"
        */
        
	String action = request.getParameter("action");
        
        boolean error = false;
        if (session.getAttribute("error") == null) {
            session.setAttribute("error", 0);
        } else {
            try {
                error = (Integer)session.getAttribute("error") > 0;
            } catch (Exception ex) {
                error = false;
            }
        }
        
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
        if (votings == null) {
            votes = new int[1 + dataLength / 16];
            session.setAttribute("votes", votes);
        } else {
            votes = (int[])votings;
        }
        
        int currVote = 0;
        int currFlag = 0;
        
        /* Done with the session. */
        data.absolute(index);
        int currID = data.getInt("ID");
        
        String[] possibleActions = {
            "prev", "next", "last", "first", "add",
            "upvote", "downvote", "flag", "show", "search"
        };
        
        int act = 0;
        while (act < possibleActions.length && !possibleActions[act].equalsIgnoreCase(action)) {
            act++;
        }
        if (act == 10) {
            sendError(response, "Invalid Action");
            return;
        }
        if (error) {
            if (act < 2) {
                // Next and Prev should redirect to the first image
                act = 3;
                session.setAttribute("error", 0);
            } else if (act >= 4 && act <= 7) {
                // Can't vote when on error page
                sendError(response, "Cannot vote when on 404 page");
                return;
            } else {
                session.setAttribute("error", 0);
            }
        }
        
        PreparedStatement statement;
                
        /* Dealing with different actions */
	switch(act) {
            case 0: // prev
                if (!data.isFirst()) {
                    data.previous();
                    index -= 1;
                }
                
                currID = data.getInt("ID");
                currVote = getCurrVote(currID, votes);
                currFlag = getCurrFlag(currID, flags);
		outputJson(data, out);
		break;
            case 1: // next
                if (!data.isLast()) {
                    data.next();
                    index += 1;
                }
                
                currID = data.getInt("ID");
                currVote = getCurrVote(currID, votes);
                currFlag = getCurrFlag(currID, flags);
		outputJson(data, out);
		break;
            case 2: // last
                data.last();
                currID = data.getInt("ID");
                currVote = getCurrVote(currID, votes);
                currFlag = getCurrFlag(currID, flags);
                index = dataLength;
		outputJson(data, out);
		break;
            case 3: // first
                data.first();
                currID = data.getInt("ID");
                currVote = getCurrVote(currID, votes);
                currFlag = getCurrFlag(currID, flags);
                index = 1;
		outputJson(data, out);
		break;
            case 4: // add
                String title = request.getParameter("title");
                String content = request.getParameter("content");
                String url = request.getParameter("url");
                
                if (title.length() > 64 || content.length() > 1024 || url.length() > 4096) {
                    sendError(response, "Content too long");
                    return;
                }
                
                statement = con.prepareStatement(
                    "insert into funnycontent (Title, Content, ImageURL, Date) values (?, ?, ?, \""
                    + DateTimeFormatter.ofPattern("yyyy-MM-dd").format(LocalDate.now()) + "\");"
                );
                statement.setString(1, title);
                statement.setString(2, content);
                statement.setString(3, url);
                statement.executeUpdate();
                
                if (orderBy == "score") {
                     data = state.executeQuery("select * from funnycontent order by Score;");
                } else {
                     data = state.executeQuery("select * from funnycontent order by Date;");
                }
                index = 1;
                data.absolute(index);
                
                currID = data.getInt("ID");
                currVote = getCurrVote(currID, votes);
                currFlag = getCurrFlag(currID, flags);
                outputJson(data, out);
                break;
                
            case 5: // upvote
                currVote = getCurrVote(currID, votes);
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
                index = findPostByID(currID, data);
		data.absolute(index);
                
                currID = data.getInt("ID");
                currFlag = getCurrFlag(currID, flags);
		outputJson(data, out);
		break;
            case 6: // downvote
                currVote = getCurrVote(currID, votes);
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
                index = findPostByID(currID, data);
		data.absolute(index);
                
                currID = data.getInt("ID");
                currFlag = getCurrFlag(currID, flags);
		outputJson(data, out);
                break;
            case 7: // flag
                currFlag = getCurrFlag(currID, flags);
                if (currFlag != 1) {
		    if (data.getInt("FlagAmount") >= 4) {
                        state.executeUpdate(
		      	    "delete from funnycontent where ID = " + data.getString("ID") + ";"
                        );
                        index = 1;
		    }
		    else {
                        state.executeUpdate(
                            "update funnycontent set FlagAmount=" 
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
                
                currID = data.getInt("ID");
                currVote = getCurrVote(currID, votes);
		outputJson(data, out);
		break;
                
            case 8: // show
                outputJson(data, out);
                
                currID = data.getInt("ID");
                currVote = getCurrVote(currID, votes);
                currFlag = getCurrFlag(currID, flags);
                break;
            
            case 9: // search
                statement = con.prepareStatement(
                    "select * from funnycontent where lower(title) like lower(?) order by ?;"
                );
                statement.setString(1, request.getParameter("title"));
                statement.setString(2, orderBy == "score" ? "score" : "date");
                index = 1;
                data = statement.executeQuery();
                if (!data.isBeforeFirst()) {
                    session.setAttribute("error", 1);
                    throw new Exception("No data found");
                } else {
                    data.first();
                    outputJson(data, out);
                }
                
                currID = data.getInt("ID");
                currVote = getCurrVote(currID, votes);
                currFlag = getCurrFlag(currID, flags);
                break;
            default:
                sendError(response, "Invalid Action");
                return;
	}
        session.setAttribute("index", index);
        flags[currID / 32] |= ((int)currFlag << (currID % 32));
        session.setAttribute("flags", flags);
        votes[currID / 16] &= (-1 ^ (3 << (currID % 16)));
        votes[currID / 16] |= currVote << (currID % 16);
        session.setAttribute("votes", votes);
    }
    catch (Exception ex) {
        /* Return some error Json here */
        sendError(response, ex.getMessage());
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
                sendError(response, ex2.getMessage());
            }
        }
    }
%>