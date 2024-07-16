<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>새글작성</title>
</head>
<style>
table { margin:auto; border-collapse:collapsed;}
td:nth-child(1){ text-align:right;}
td {border:1px solid black;}
</style>
<body>
<form method="post" action="/save">
<table>
<tr><td>제목</td><td><input type=text name=title></td></tr>
<tr><td>작성자</td><td><input type=text name=writer value="${userid}" readonly></td></tr>
<tr><td>게시글</td><td><textarea name=content rows=20 cols=50></textarea></td></tr>
<tr><td colspan=2 style='text-align:center'>
<input type=submit value='저장'><input type=reset value='비우기'>
</td></tr>
</table>
</form>
</body>
</html>