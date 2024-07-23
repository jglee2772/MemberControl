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
<input type=hidden id=id>
<table>
<tr><td>제목</td><td><input type=text id=title></td></tr>

<tr><td>게시글</td><td><textarea id=content rows=10 cols=50></textarea></td></tr>
<tr><td colspan=2 style='text-align:center'>
<input type=button id=btnSave value='저장'>&nbsp;&nbsp;<input type=reset id=btnClear value='비우기'>&nbsp;&nbsp;
<input type=button id=btnDelete value='삭제'>
</td></tr>
</table>
<table id=tblBoard>
<thead>
<tr><td colspan=5><input type=button id=btnLoad value="가저오기"></td></tr>
<tr><th>번호</th><th>제목</th><th>글쓴이</th><th>작성일</th><th>조회수</th></tr>
</thead>
<tbody>
</tbody>
</table>
</body>
<script src='https://code.jquery.com/jquery-latest.js'></script>
<script>
$(document)
.ready(function(){
	loadBoard();
})
.on('click','#btnClear',function(){
	$('#title,#writer,#content,#id').val("");
})

.on('click','#btnSave',function(){
	let id = $('#id').val();
	let title = $('#title').val();
	let writer = $('#writer').val();
	let content = $('#content').val();
	if(title == ''||content == '') return false;
	if(id=='') {
		$.ajax({
			url:'/saveBoard',type:'post',data:{title:title,content:content},dataType:'text',
			success:function(data){
				if(data=='ok') {
					$('#btnClear').trigger('click');
					loadBoard();
				}
			}
		})
	} else {
		$.ajax({
			url:'/updateBoard',type:'post',data:{id:id,title:title,content:content},dataType:'text',
			success:function(data){
				if(data=='ok') {
					$('#btnClear').trigger('click');
					loadBoard();
				}
			}
		})
	}
	return false;
})
.on('click','#tblBoard tbody tr',function(){
	let id=$(this).find('td:eq(0)').text();
	let title=$(this).find('td:eq(1)').text();
	$('#id').val(id);
	$('#title').val(title);
	$.ajax({
		url:'/boardContent',type:'post',data:{id:id},dataType:'text',
		success:function(data) {
			$('#content').val(data);
		}
	})
})
.on('click','#btnDelete',function(){
	if($('#id').val()=="") {
		alert("삭제할 게시물을 선택해주세요");
		return false;
	}
	if(!confirm("정말로 삭제하십니까?")) return false;
	let id = $('#id').val();
	$.ajax({
		url:'/deleteBoard',type:'post',data:{id:id},dataType:'text',
		success:function(data) {
			if(data=='ok') {
				$('#btnClear').trigger('click');
				loadBoard();
			}
		}
	})
})
;
function loadBoard() {
	$.ajax({
		url:'/list',type:'post',data:{},dataType:'json',
		success:function(data){
			$('#tblBoard tbody').empty();
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
}
</script>
</html>