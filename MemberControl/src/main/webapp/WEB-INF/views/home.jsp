<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
    
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>어서오세요</title>
</head>
<style>
table { margin:auto; border-collapse:collapsed;}
td { border:1px solid black;}
th { border:1px solid white; background-color:black; color:white}
</style>
<body>
<p>2024-07-23</p>
<table>
<tr>
	<td style='text-align:right;border:none;'>
	${linkstr}
	</td>
</tr>
<tr>
	<td style="text-align:center; font-size:36px">안녕하세요. 이정건의 홈페이지 입니다.</td>
</tr>
</table>
<br>
<table>
<tr><td colspan=5 style='text-align:right; border:none'>${newpost}</td></tr>
<tr><th>번호</th><th>제목</th><th>글쓴이</th><th>작성일</th><th>조회수</th></tr>
<c:forEach items="${arBoard}" var="board">
<tr><td style='text-align:center;'>${board.id}</td><td><a href="/view?id=${board.id}">${board.title}</a></td><td>${board.writer}</td>
	<td>${board.created}</td><td style='text-align:center;'>${board.hit}</td></tr>
</c:forEach>
<tr><td style="text-align:center;" colspan=5>${movestr}</td></tr>
</table>
</body>
</html>