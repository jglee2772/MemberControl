<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<style>
table { margin:auto; border-collapse:collapsed;}
td { border:1px solid black;}
th { border:1px solid white; background-color:black; color:white}
</style>
<body>
<table id=tblMenu>
<tr><td colspan=3><input type=button id=btnLoadm value="가저오기"></td></tr>
<tr><th>번호</th><th>메뉴명</th><th>가격</th></tr>
</table>
</body>
<script src='https://code.jquery.com/jquery-latest.js'></script>
<script>
$(document)
.ready(function(){
})
.on('click','#btnLoadm',function(){
	$.ajax({
		url:'/menulist',type:'post',data:{},dataType:'json',
		success:function(data){
			console.log(data);
			for(let x of data) {
				let strm = '<tr>';
				strm +='<td>'+x['id']+'</td><td>'+x['name']+'</td><td>'+x['price']+'</td></tr>';
				$('#tblMenu').append(strm);
			}
		},
		error:function(){},
		complete:function(){}
	})
	return false;
})
</script>
</html>