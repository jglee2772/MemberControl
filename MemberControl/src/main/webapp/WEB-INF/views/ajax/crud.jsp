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
<table id=tblBoard>
<tr><td colspan=5><input type=button id=btnLoad value="가저오기"></td></tr>
<tr><th>번호</th><th>제목</th><th>글쓴이</th><th>작성일</th><th>조회수</th></tr>
</table>
</body>
<script src='https://code.jquery.com/jquery-latest.js'></script>
<script>
$(document)
.ready(function(){
})
.on('click','#btnLoad',function(){
	$.ajax({
		url:'/list',type:'post',data:{},dataType:'json',
		success:function(data){
			for(let x of data) {
				let str = '<tr>';
				str +='<td>'+x['id']+'</td><td>'+x['title']+'</td><td>'+x['writer']+'</td><td>'+x['created']+'</td><td>'+x['hit']+'</td></tr>';
				$('#tblBoard').append(str);
			}
		},
		error:function(){},
		complete:function(){}
	})
	return false;
})
</script>
</html>