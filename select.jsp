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
	<meta charset="UTF-8">
	<title>수강신청 조회</title>
	<link rel='stylesheet' href='dbDesign.css' />
	<script>
		function onSearch() {
			var fr = document.getElementById("select_form");
			var search_year = fr.search_year.value;
			var search_semester = fr.search_semester.value;
			location.href = "select.jsp?search_year=" + search_year + "&search_semester=" + search_semester;
		}
	</script>
</head>
<body>
<% 
	String search_year = request.getParameter("search_year");
	String search_semester = request.getParameter("search_semester");
 	if (search_year == null)
		search_year = "2020";
	if (search_semester == null)
		search_semester = "2";
	String course_id;
	int course_id_no;
	String course_name = "";
	int course_unit = 0;
	String int_course_day = "";
	String str_course_day = "";
	String course_start_time = "";
	String course_end_time = "";
	String course_place = "";
	int max_student_num = 0;
	int current_student_num = 0;
	int total_course = 0;
	int total_unit = 0;
	
	Connection conn = null;		
	PreparedStatement pstmt = null;
	CallableStatement cstmt = null; 
	ResultSet rs = null;
	ResultSet sub_rs = null;
	String sql;
	String sub_sql;
	String dburl = "jdbc:oracle:thin:@localhost:1521:orcl";
	String user = "db1613704";                                       
	String passwd = "0525";
%>
	<form method="post" width="75%" align="center" id="select_form" action="select.jsp"> 
		<br/>
		<br/>
		년도 <input type="text" name="search_year" value="<%=search_year %>" size="10"/>
		학기 <input type="text" name="search_semester" value="<%=search_semester %>" size="10"/>
		<input type="button" value="SEARCH" onclick="onSearch()"/>
	</form>
	
	<table width="75%" align="center" id="select_table">
<% 

%>
		<tr>
			<th>과목번호</th><th>분반</th><th>과목명</th>
			<th>강의시간</th><th>강의장소</th><th>학점</th>
		</tr>
<%

	try {
		Class.forName("oracle.jdbc.driver.OracleDriver");            
		conn = DriverManager.getConnection(dburl, user, passwd);
		 
		sql = "SELECT c_id, c_id_no FROM enroll WHERE s_id = ? and e_year = ? and e_semester = ?";
		
		pstmt = conn.prepareStatement(sql);
		pstmt.setString(1, session_id);
		pstmt.setInt(2, Integer.parseInt(search_year));
		pstmt.setInt(3, Integer.parseInt(search_semester));
		rs = pstmt.executeQuery();
		while (rs.next()) {
			course_id = rs.getString("c_id");
			course_id_no = rs.getInt("c_id_no");
			
			sub_sql = "SELECT c_name, c_unit FROM course WHERE c_id = ? and c_id_no = ?";
			pstmt = conn.prepareStatement(sub_sql);
			pstmt.setString(1, course_id);
			pstmt.setInt(2, course_id_no);
			sub_rs = pstmt.executeQuery();
			if (sub_rs.next()) {
				course_name = sub_rs.getString("c_name");
				course_unit = sub_rs.getInt("c_unit");
				total_unit = total_unit + course_unit;
				total_course++;
			}
			
			sub_sql = "SELECT  c_day, c_start_hh, c_start_mm, c_end_hh, c_end_mm, c_where, c_max FROM course WHERE c_id = ? and c_id_no = ?";
			pstmt = conn.prepareStatement(sub_sql);
			pstmt.setString(1, course_id);
			pstmt.setInt(2, course_id_no);
			sub_rs = pstmt.executeQuery();
			if (sub_rs.next()) {
				int_course_day = "" + sub_rs.getInt("c_day");
				String str_st_m = null, str_et_m = null;
				int st_m = sub_rs.getInt("c_start_mm");
				str_st_m = st_m + "";
				if (st_m == 0)  
					str_st_m = "00";
				int et_m = sub_rs.getInt("c_end_mm");
				str_et_m = et_m + "";
				if (et_m == 0)  
					str_et_m = "00";
				
				course_start_time = "" + sub_rs.getInt("c_start_hh");
				course_start_time = course_start_time + " : " + str_st_m;
				course_end_time = "" + sub_rs.getInt("c_end_hh");
				course_end_time = course_end_time + " : " + str_et_m;
				course_place = sub_rs.getString("c_where");
				max_student_num = sub_rs.getInt("c_max");
			}
			
			/*
			sub_sql = "SELECT c_p_name FROM course WHERE p_id = ?";
			pstmt = conn.prepareStatement(sub_sql);
			pstmt.setString(1, professor_id);
			sub_rs = pstmt.executeQuery();
			if (sub_rs.next())
				professor_name = sub_rs.getString("c_p_name");
			*/
			
			sub_sql = "SELECT s_id FROM enroll WHERE c_id = ? and c_id_no = ?";
			pstmt = conn.prepareStatement(sub_sql);
			pstmt.setString(1, course_id);
			pstmt.setInt(2, course_id_no);
			sub_rs = pstmt.executeQuery();
			if (sub_rs.next())
				current_student_num++;
			
			sql = "{? = call getStrDay(?)}";
			cstmt = conn.prepareCall(sql);
			cstmt.registerOutParameter(1, java.sql.Types.VARCHAR);
			cstmt.setString(2, int_course_day);
			cstmt.execute();
			str_course_day = cstmt.getString(1);
			//System.out.println(str_course_day);
			
%>
		<tr>
			<td align="center"><%=course_id %></td>
			<td align="center"><%=course_id_no %></td>
			<td align="center"><%=course_name %></td>
			<td align="center"><%=str_course_day %><%=course_start_time %> - <%=course_end_time %></td>
			<td align="center"><%=course_place %></td>
			<td align="center"><%=course_unit %></td>
<%
			}
			
		rs.close();
		pstmt.close();
		conn.close();
	} 
	catch(SQLException ex) { 
		System.err.println("SQLException: " + ex.getMessage());
	}
%>
		</tr>
	</table>
	<br/>
	<br/>
	<div width="75%" align="center">
		<p><%=search_year %>년 <%=search_semester %>학기 수강신청 검색 결과 : </p>
		<p>현재까지 <%=total_course %>과목, 총 <%=total_unit %>학점 수강신청 했습니다 </p>
	</div>
	</table>
</body>
</html>