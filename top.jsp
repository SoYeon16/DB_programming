<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="EUC-KR"%>
<% String session_id = (String) session.getAttribute("user");
String log;
if (session_id == null)
log = "<a href=login.jsp>�α���</a>";
else log = "<a href=logout.jsp>�α׾ƿ�</a>"; %>
<table width="75%" align="center" bgcolor="#FFFF99" border>
<tr>
<td align="center"><b><%=log%></b></td>
<td align="center"><b><a href="update.jsp">����� ���� ����</b></td>
<td align="center"><b><a href="insert.jsp">������û �Է�</b></td>
<td align="center"><b><a href="delete.jsp">������û ����</b></td>
<td align="center"><b><a href="select.jsp">������û ��ȸ</b></td>
<td align="center"><b><a href="search.jsp">ģ�� ã��</b></td>
</tr>
</table>