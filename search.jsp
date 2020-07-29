<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.sql.*" %>
<% request.setCharacterEncoding("EUC-KR"); %>
<%@ include file="top.jsp" %>
<%
	if (session_id == null) 
		response.sendRedirect("login.jsp");
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="EUC-KR">
<title>친구 찾기</title>
<script>
		function onSearch() {
			var fr = document.getElementById("search_form");
			var search_id = fr.search_id.value;
			location.href = "search.jsp?search_id=" + search_id;
		}
	</script>
</head>
<body>
<%
String stu_id = request.getParameter("search_id");

if (stu_id == null)
	stu_id = "1234567";

	%>

	<form method="post" width="75%" align="center" id="search_form" action="search.jsp"> 
		<br/>
		<br/>
		학번 <input type="text" name="search_id" value="<%=stu_id %>" size="10"/>
		<input type="button" value="SEARCH" onclick="onSearch()"/>
	</form>
	
	<table width="75%" align="center" id="search_table">
<% 
%>
		<tr>
			<th>과목번호</th>
			<th>분반</th>
			<th>학기</th>
			<th>과목명</th>
			<th>강의시간</th>
			<th>담당교수</th>
		</tr>
<%
Connection myConn = null;      Statement stmt = null;
ResultSet myResultSet = null;   String mySQL = "";
String sql="";
CallableStatement cstmt = null;
PreparedStatement pstmt = null;
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
sql = "create or replace view stu_enroll as select e.c_id, e.c_id_no, c.c_name, c.c_p_name, e.e_year, e.e_semester, e.s_id, c.c_start_hh,c.c_start_mm, c.c_end_hh ,c.c_end_mm, c.c_day from enroll e, course c where e.c_id = c.c_id and e.s_id="+stu_id;
pstmt = myConn.prepareStatement(sql);
pstmt.executeQuery();


mySQL = "SELECT s_id, c_id, c_id_no, c_name, c_p_name, e_year, e_semester, c_start_hh, c_start_mm, c_end_hh , c_end_mm , c_day from stu_enroll where s_id=?";
try{
	pstmt = myConn.prepareStatement(mySQL);
	pstmt.setInt(1, Integer.parseInt(stu_id));
	myResultSet = pstmt.executeQuery();
	if (myResultSet != null) {
		while (myResultSet.next()) {	
			String c_id = myResultSet.getString("c_id"); //과목번호
			int c_id_no = myResultSet.getInt("c_id_no");	//분반		
			String c_name = myResultSet.getString("c_name"); //과목명		//학점	
			int c_year = myResultSet.getInt("e_year");  //년도
			int c_semester = myResultSet.getInt("e_semester"); //학기
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
		  <td align="center"><%=str_c_day%> <%= c_st_h %>:<%= c_st_mm %>-<%= c_et_h %>:<%= c_et_mm %></td>
		  <td align="center"><%= c_p_name %></td>
		  
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