<%@ page contentType="text/html; charset=UTF-8" pageEncoding="EUC-KR"%>
<%@ page import="java.net.URLEncoder" %>
<%@ page import="java.sql.*"  %>
<html>
	<head>
		<title>수강신청 입력</title>
		<link rel='stylesheet' href='./dbDesign.css' />
		<style type="text/css">
		#in_b, #in_b:visited {
			width: 80pt;
			font-size: 17pt;
			color: blue;	
		}
	</style>
	</head>
<body>
<%@ include file="top.jsp" %>
<% 	
	request.setCharacterEncoding("UTF-8");
	if (session_id==null) response.sendRedirect("login.jsp");  

%>
	<div align="center" id="insert_div" style="width:75%; overflow-y: auto; margin-top:2%; overflow-x: auto; margin-left: 12.5%; height: 80%;">
		<table align="center" width="100%" id="insert_table">
		<br>
		<tr>
			<th>과목번호</th>
			<th>분반</th>
			<th>학기</th>
			<th>과목명</th>
			<th>학점</th>
			<th>수업시간</th>
			<th>담당교수</th>
		    <th>수강신청</th>
		</tr>
<%
			Connection myConn = null;      Statement stmt = null;
			ResultSet myResultSet = null;   String mySQL = "";
			CallableStatement cstmt = null;
			String dburl  = "jdbc:oracle:thin:@localhost:1521:orcl";
			String user="db1613704";     String passwd="0525";
		    String dbdriver = "oracle.jdbc.driver.OracleDriver";
			try {
				Class.forName(dbdriver);
			    myConn =  DriverManager.getConnection (dburl, user, passwd);
			    stmt = myConn.createStatement();
			    
			    cstmt = myConn.prepareCall("{? = call getStrDay(?)}");
				cstmt.registerOutParameter(1, java.sql.Types.VARCHAR);
		    } catch(SQLException ex) {
			     System.err.println("SQLException: " + ex.getMessage());
		    }
			mySQL = "SELECT c.c_id, c.c_id_no, c.c_name, c.c_unit, c.c_year, c.c_semester, c.c_day, c.c_start_hh, c.c_start_mm, c.c_end_hh, c.c_end_mm, c.c_p_name FROM course c WHERE (c.c_id, c.c_id_no) not in (select c_id, c_id_no from enroll where s_id='" + session_id + "') order by c.c_id, c.c_id_no";
			try{
				myResultSet = stmt.executeQuery(mySQL);
				if (myResultSet != null) {
					while (myResultSet.next()) {	
						String c_id = myResultSet.getString("c_id"); //과목번호
						int c_id_no = myResultSet.getInt("c_id_no");	//분반		
						String c_name = myResultSet.getString("c_name"); //과목명
						int c_unit = myResultSet.getInt("c_unit");		//학점	
						int c_year = myResultSet.getInt("c_year");  //년도
						int c_semester = myResultSet.getInt("c_semester"); //학기
						String c_p_name = myResultSet.getString("c_p_name"); //교수이름
						int c_st_h = myResultSet.getInt("c_start_hh");  //시작
						int c_st_m = myResultSet.getInt("c_start_mm"); //시작
						int c_et_h = myResultSet.getInt("c_end_hh");  //끝
						int c_et_m = myResultSet.getInt("c_end_mm"); //끝
						String c_st_mm = null, c_et_mm = null;
						c_st_mm = c_st_m + ""; c_et_mm = c_et_m + ""; 
						if(c_st_m == 0) c_st_mm = "00";
						if(c_et_m == 0) c_et_mm = "00";
						
						int int_c_day = myResultSet.getInt("c_day"); 
						cstmt.setInt(2, int_c_day);
						cstmt.execute();
						String str_c_day = cstmt.getString(1);
%>
<tr>
					  <td align="center"><%= c_id %></td> 
					  <td align="center"><%= c_id_no %></td>
					  <td align="center"><%= c_year %>-<%=c_semester%></td> 
					  <td align="center"><%= c_name %></td>
					  <td align="center"><%= c_unit %></td>
					  <td align="center"><%=str_c_day%> <%= c_st_h %>:<%= c_st_mm %>-<%= c_et_h %>:<%= c_et_mm %></td>
					  <td align="center"><%= c_p_name %></td>
					  <td align="center"><a href="insert_verify.jsp?c_name='<%=URLEncoder.encode(c_name, "UTF-8")%>'&c_id=<%= c_id %>&c_id_no=<%= c_id_no %>" id="in_b">신청</a></td>
					  
					</tr>
<%
					}
				%></table>
				</div><%	
				}
			}catch(SQLException e){
			    out.println(e);
			    e.printStackTrace();
			}
			stmt.close();  
			myConn.close();
			
%>
</body></html>