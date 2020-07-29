<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>
<%
String userID=request.getParameter("userID");
String userPassword=request.getParameter("userPassword");

String driver = "oracle.jdbc.driver.OracleDriver";
String url = "jdbc:oracle:thin:@localhost:1521:orcl";

String user = "db1613704";
String password = "0525";

Class.forName(driver);

Statement stmt = null;
String mySQL = null;

Connection myConn = DriverManager.getConnection(url, user, password);   
stmt = myConn.createStatement();
mySQL="select s_id from student where s_id='" + userID + " 'and s_pwd='" + userPassword + "'";

ResultSet rs = stmt.executeQuery(mySQL);

if (rs.next()){
   session.setAttribute("user", userID);
   response.sendRedirect("main.jsp");
}
else {
   response.sendRedirect("login.jsp");
}

stmt.close();
myConn.close();
%>