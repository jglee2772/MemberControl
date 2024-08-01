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
<table id=tblone>
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
<tr><td colspan="2">
<input type="button" id="btnon" value="댓글 달기">
<div id="commentSection" style="display:none;">
    <h3 style="text-align:center;">댓글 입력</h3>
    <textarea id="commentContent" rows="5" cols="60" placeholder="댓글을 입력하세요..." style="resize:none;"></textarea><br>
    <button id="submitComment">댓글 추가</button>
    <div id="commentList"></div>
</div>
</td></tr>
<c:forEach items="${arReply}" var="reply">
<tr><td style='text-align:center;'>작성자 : ${reply.writer}</td><td style='text-align:right;'>작성일자 : ${reply.created}</td></tr>
<tr><td colspan=2 style='text-align:right;'>${reply.content}</td></tr>
<tr><td colspan=2 style='text-align:right;'><button>답글</button><button id="updateView">수정</button><button id="deleteComment">삭제</button>
<div id="newComment" style="display:none;">
	<textarea id="newContent" rows="2" cols="60" placeholder="댓글을 입력하세요..." style="resize:none;"></textarea>
	<button id="updateComment">등록</button>
</div>
</td></tr>

</c:forEach>
</table>
</body>
<script src='https://code.jquery.com/jquery-latest.js'></script>
<script>
$(document)
.ready(function(){
	
})
.on("click","#btnon",function(){
	$('#commentSection').toggle();
})
.on("click","#submitComment",function(){
	let content = $('#commentContent').val();
	let boardid = ${board.id};
	$.ajax({
		url:'/addComment',type:'post',data:{content:content,boardid:boardid},
		success:function(data) {
			$('#commentContent').val('');
			$('#commentSection').toggle();
		}
	})
})
.on("click","#updateView",function(){
	$('#newComment').toggle();
})
.on("click","#updateComment",function(){
	let content = $('#newContent').val();
	$.ajax({
		url:'/updateComment',type:'post',data:{content:content},
		success:function(data) {
			$('#newContent').val('');
			$('#newComment').toggle();
		}
	})
})

</script>
</html>