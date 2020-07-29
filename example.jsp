<%@ page language="java" contentType="text/html; charset=EUC-KR"
pageEncoding="EUC-KR" import="java.sql.*"%>

<html>
<head>
<meta charset="EUC-KR">
<title>Insert title here</title>
</head>
<body>
   <%
   String driver = "oracle.jdbc.driver.OracleDriver";
   String url = "jdbc:oracle:thin:@localhost:1521:orcl";
   String user = "db1611164";
   String password = "0113";
   try {
      Class.forName(driver);
      out.println("1613704 jdbc driver 로딩 성공");
      DriverManager.getConnection(url, user, password);
      out.println("오라클 연결 성공");
   } catch (ClassNotFoundException e) {
      System.out.println("jdbc driver 로딩 실패");
   } catch (SQLException e) {
      System.out.println("오라클 연결 실패");
   }
   %>
</body>
</html>