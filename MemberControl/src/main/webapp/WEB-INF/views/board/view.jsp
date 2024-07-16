<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

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
<table>
<tr><td>제목</td><td><input type=text name=title value="${board.title}" readonly></td></tr>
<tr><td>작성자</td><td><input type=text name=writer value="${board.writer}" readonly></td></tr>
<tr><td>게시글</td><td><textarea name=content rows=20 cols=50 readonly>${board.content}</textarea></td></tr>
<tr><td>작성시간</td><td>${board.created}</td></tr>
<tr><td>수정시간</td><td>${board.updated}</td></tr>
<tr><td colspan=2 style='text-align:center'>
<a href="/">목록으로 돌아가기</a>&nbsp;&nbsp;
<c:if test="${sessionScope.userid == board.writer}">
<a href="/update?id=${board.id}">수정</a>&nbsp;&nbsp;
<a href="/delete?id=${board.id}">삭제하기</a>
</c:if>
</td></tr>
</table>
</body>
</html>