<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>회원가입</title>
</head>
<style>
table { margin:auto; border-collapse:collapsed;}
td { border:1px solid black;}
</style>
<body>
<form method="post" action="/dosignup">
<table>
<tr><td>아이디 : </td><td><input type="text" name="uid"></td></tr>
<tr><td>비밀번호 : </td><td><input type="password" name="upw1"></td></tr>
<tr><td>비밀번호 확인 : </td><td><input type="password" name="upw2"></td></tr>
<tr><td>실명 : </td><td><input type="text" name="un"></td></tr>
<tr><td>생년월일 : </td><td><input type="date" name="ud"></td></tr>
<tr><td>성별 : </td><td><input type="radio" name="ug" value="남성">남성
						<input type="radio" name="ug" value="여성">여성</td></tr>
<tr><td>모바일번호 : </td><td><input type="text" name="mobile"></td></tr>
<!-- <tr><td>지역</td><td>
	<select name="ur">
		<option value="덕양구">덕양구</option>
		<option value="일산동구">일산동구</option>
		<option value="일산서구">일산서구</option>
	</select>
</td></tr> -->
<tr>
	<td>관심분야</td><td>
		<input type=checkbox name=nf value=Java>Java
		<input type=checkbox name=nf value=Javascript>Javascript
		<input type=checkbox name=nf value=Python>Python<br>
		<input type=checkbox name=nf value=MySQL>MySQL
		<input type=checkbox name=nf value=Oracle>Oracle
		<input type=checkbox name=nf value=React>React<br>
		<input type=checkbox name=nf value=Spring>Spring
		<input type=checkbox name=nf value="Node.js">Node.js
		<input type=checkbox name=nf value="Next.js">Next.js
	</td>
</tr>
<tr>
	<td colspan=2 style='text-align:center'>
		<input type=submit value='회원가입'>&nbsp;
		<input type="button" id=cancel value="취소">
	</td>
</tr>
</table>
</form>
</body>
<script src='https://code.jquery.com/jquery-latest.js'></script>
<script>
$(document)
.on('click', '#cancel',function(){
	document.location='/cancellogin';
})
</script>
</html>