<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>게시글 보기</title>
</head>
<style>
table { margin:auto; border-collapse:collapse; }
td:nth-child(1){ text-align:right; }
td {border:1px solid black; }
textarea {
            width: 100%;
            box-sizing: border-box;
        }
</style>
<body>
<table id="tblone">
<thead>
<input type="hidden" id="hideid" value="${userid}">
<tr><td>제목</td><td><input type="text" name="title" value="${board.title}" readonly></td></tr>
<tr><td>작성자</td><td><input type="text" name="writer" value="${board.writer}" readonly></td></tr>
<tr><td>게시글</td><td><textarea name="content" rows="20"  readonly>${board.content}</textarea></td></tr>
<tr><td>작성시간</td><td>${board.created}</td></tr>
<tr><td>수정시간</td><td>${board.updated}</td></tr>
<tr><td colspan="2" style='text-align:center'>
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
    <textarea id="commentContent" rows="5" placeholder="댓글을 입력하세요..." style="resize:none;"></textarea><br>
    <button id="submitComment">댓글 추가</button>
    <div id="commentList"></div>
</div>
</td></tr>
</thead>
<tbody>
</tbody>
</table>
</body>
<script src='https://code.jquery.com/jquery-latest.js'></script>
<script>
$(document)
.ready(function() {
	loadComments();
})
.on("click", "#btnon", function() {
	if($('#hideid').val()=='') {
		window.location.href = "/login";
	} else {
		$('#commentSection').toggle();
	}
})
.on("click", "#submitComment", function() {
    let content = $('#commentContent').val();
    let boardid = ${board.id};
    $.ajax({
        url: '/addComment',
        type: 'post',
        data: { content: content, boardid: boardid },
        success: function(data) {
            $('#commentContent').val('');
            $('#commentSection').toggle();
            loadComments();
        }
    });
})
.on("click", ".replyButton", function() {
    let id = $(this).data('id');
    if($('#hideid').val()=='') {
    	window.location.href = "/login";
    } else {
    	$('#replySection_' + id).toggle();
    }
})
.on("click",".updateButton",function(){
	let id = $(this).data('id');
	$('#updateSection_'+id).toggle();
})
.on("click", ".submitReplyButton", function() {
    let parentId = $(this).data('id');
    let content = $('#replySection_' + parentId + ' .replyContent').val();
    let boardid = ${board.id};
    $.ajax({
        url: '/addReply',
        type: 'post',
        data: { content: content, boardid: boardid, parentId: parentId },
        success: function(data) {
            $('#replySection_' + parentId + ' .replyContent').val('');
            $('#replySection_' + parentId).toggle();
            loadComments();
        }
    });
})
.on("click", ".updateCommentButton", function() {
	let id = $(this).data('id');
	let newContent = $('#updateSection_' + id + ' .updateContent').val();
    if (confirm("정말로 수정하시겠습니까?")) {
        $.ajax({
            url: '/updateComment',
            type: 'post',
            data: { id: id, content: newContent },
            success: function(data) {
                loadComments();
            }
        });
    }
})
.on("click", ".deleteCommentButton", function() {
	let id = $(this).data('id');
    if (confirm("정말로 삭제하시겠습니까?")) {
        $.ajax({
            url: '/deleteComment',
            type: 'post',
            data: { id: id },
            success: function(data) {
                loadComments();
            }
        });
    }
});

function loadComments() {
    let boardid = ${board.id};
    let userid = $('#hideid').val();
    
    $.ajax({
        url: '/getComments',
        type: 'post',
        data: { boardid: boardid },
        dataType: 'json',
        success: function(data) {
            $('#tblone tbody').empty();
            function renderComments(indata, par_id) {
                let str = '';
                for (let reply of indata) {
                    if (reply['parid'] === par_id) {
                        str += "<tr><td style='text-align:center;'>작성자 : " + reply['writer'] + "</td><td style='text-align:right;'>작성일자 : " + reply['created'] + "</td></tr>" +
                               "<tr><td colspan='2' style='text-align:right;'>" + reply['content'] + "</td></tr>" +
                               "<tr><td colspan='2'>" +
                               "<button class='replyButton' data-id='" + reply['id'] + "'>답글</button>";

                        if (reply['writer'] === userid) {
                            str += "<button class='updateButton' data-id='" + reply['id'] + "'>수정</button>" +
                                    "<button class='deleteCommentButton' data-id='" + reply['id'] + "'>삭제</button>";
                        }

                        str += "</td></tr>" +
                                "<tr><td colspan='2' id='replySection_" + reply['id'] + "' style='display:none;'>" +
                                "<h4>답글 작성</h4>" +
                                "<textarea class='replyContent' rows='3' placeholder='답글을 입력하세요...' style='resize:none;'></textarea><br>" +
                                "<button class='submitReplyButton' data-id='" + reply['id'] + "'>답글 추가</button>" +
                                "</td></tr>" +
                                "<tr><td colspan='2' id='updateSection_" + reply['id'] + "' style='display:none;'>" +
                                "<h4>수정글 작성</h4>" +
                                "<textarea class='updateContent' rows='3' placeholder='수정글을 입력하세요...' style='resize:none;'></textarea><br>" +
                                "<button class='updateCommentButton' data-id='" + reply['id'] + "'>수정하기</button>" +
                                "</td></tr>";

                        str += renderComments(indata, reply['id']);
                    }
                }
                return str;
            }

            $('#tblone tbody').append(renderComments(data, 0));
        }
    });
}
</script>
</html>
