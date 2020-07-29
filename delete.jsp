<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.sql.*"  %>
<html>
	<head>
		<title>수강신청 취소</title>
		<link rel='stylesheet' href='./dbDesign.css' />
	</head>
	<style type="text/css">
		#in_b, #in_b:visited {
			width: 80pt;
			font-size: 17pt;
			color: blue;	
		}
	</style>
<body>
<%@ include file="top.jsp" %>
<%   
	if (session_id == null) 
		response.sendRedirect("login.jsp");
	
	Connection myConn = null;      
	Statement stmt = null;
	CallableStatement cstmt = null;
	String mySQL = "";
	String semesterSQL = "";
	ResultSet myResultSet = null;
	String dburl  = "jdbc:oracle:thin:@localhost:1521:orcl";
	String user="db1613704";     String passwd="0525";
	String dbdriver = "oracle.jdbc.driver.OracleDriver";
	String str_course_day = "";
	int presentSemester = 0;
	try {
		Class.forName(dbdriver);
        myConn =  DriverManager.getConnection (dburl, user, passwd);
		stmt = myConn.createStatement();	
	} catch(SQLException ex) {
    	System.err.println("SQLException: " + ex.getMessage());
	}
	
	
%>
		<table width="75%" align="center" id="delete_table">
		<br>
		<tr>
			<th>과목번호</th>
			<th>분반</th>
			<th>과목명</th>
			<th>강의시간</th>
		    <th>강의장소</th>
			<th>학점</th>
		    <th>수강취소</th>
		</tr>
<%
			
			mySQL = "select e.c_id, e.c_id_no, e.e_semester, c.c_name, c.c_unit, c.c_day, c.c_start_hh, c.c_start_mm, c.c_end_hh, c.c_end_mm, c.c_where from course c, enroll e where e.s_id='"+ session_id +"' and e.c_id = c.c_id and e.c_id_no = c.c_id_no";
			try{
				myResultSet = stmt.executeQuery(mySQL);
				if (myResultSet != null) {
					while (myResultSet.next()) {	
						String c_id = myResultSet.getString("c_id");
						int c_id_no = myResultSet.getInt("c_id_no");
						int e_semester = myResultSet.getInt("e_semester");
						String c_name = myResultSet.getString("c_name");
						int c_unit = myResultSet.getInt("c_unit");
						int c_day = myResultSet.getInt("c_day");
						int c_startTime_HH = myResultSet.getInt("c_start_hh");
						int c_startTime_MM = myResultSet.getInt("c_start_mm");
						int c_endTime_HH = myResultSet.getInt("c_end_hh");
						int c_endTime_MM = myResultSet.getInt("c_end_mm");
						String c_where = myResultSet.getString("c_where");
						
						mySQL = "{? = call getStrDay(?)}";
						cstmt = myConn.prepareCall(mySQL);
						cstmt.registerOutParameter(1, java.sql.Types.VARCHAR);
						cstmt.setString(2, ""+c_day);
						cstmt.execute();
						str_course_day = cstmt.getString(1);
						
						String str_st_m = null, str_et_m = null;
						str_st_m = c_startTime_MM + "";
						if(c_startTime_MM == 0) str_st_m = "00";
						str_et_m = c_endTime_MM + "";
						if(c_endTime_MM == 0) str_et_m = "00";
						
						semesterSQL = "{call getNextSemester(?)}";
						cstmt = myConn.prepareCall(semesterSQL);
						cstmt.registerOutParameter(1, java.sql.Types.INTEGER);
						cstmt.execute();
						presentSemester = cstmt.getInt(1);
						
						if(e_semester == presentSemester){
%>				
					<tr>
					  <td align="center"><%= c_id %></td> <td align="center"><%= c_id_no %></td> 
					  <td align="center"><%= c_name %></td>
					  <td align="center"><%=str_course_day %> <%= c_startTime_HH %> : <%= str_st_m %> ~ <%= c_endTime_HH %> : <%= str_et_m %></td>
					  <td align="center"><%= c_where %></td>
					  <td align="center"><%= c_unit %></td>
					  <td align="center"><a id="in_b" href="delete_verify.jsp?c_id=<%= c_id %>&c_id_no=<%= c_id_no %>">취소</a></td>
					</tr>
<%
						}
					}
				}
			}catch(SQLException e){
			    out.println(e);
			    e.printStackTrace();
			}
			stmt.close();  
			myConn.close();

%>
</table></body></html>