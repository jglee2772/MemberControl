<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>로그인</title>
</head>
<style>
table { margin:auto; border-collapse:collapsed;}
td { border:1px solid black;}
</style>
<body>
<form method="post" action="doLogin">
<table>
<tr><td>아이디 :</td><td><input type=text name=userid id=userid></td>
<tr><td>비밀번호 :</td><td><input type=password name=password id=password></td>
<tr><td colspan=2><input type="submit" value="로그인"> <input type="button" id=cancel value="취소"></td></tr>
</table>
</form>
</body>
<script src='https://code.jquery.com/jquery-latest.js'></script>
<script>
$(document)
.ready(function(){
	<% String message = (String) request.getAttribute("message"); %>
    <% if (message != null && !message.equals("")) { %>
        alert('<%= message %>');
    <% } %>
})
.on('click', '#cancel',function(){
	document.location='/cancellogin';
});
</script>
</html>