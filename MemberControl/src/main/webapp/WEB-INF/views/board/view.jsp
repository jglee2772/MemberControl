<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>게시글 보기</title>
<input type="hidden" id="hideid" value="${userid}">
<style>
body {
    font-family: Arial, sans-serif;
    background-color: #f4f4f4;
    margin: 0;
    padding: 20px;
}

table {
    margin: auto;
    border-collapse: collapse;
    width: 80%;
    background-color: #fff;
    border-radius: 8px;
    overflow: hidden;
    box-shadow: 0 4px 8px rgba(0,0,0,0.1);
}

thead {
    background-color: #f9f9f9;
}

th, td {
    padding: 12px;
    text-align: left;
}

th {
    background-color: #f1f1f1;
}

td {
    border-bottom: 1px solid #ddd;
}

td:nth-child(1) {
    text-align: right;
    font-weight: bold;
}

input[type="text"], textarea {
    width: calc(100% - 24px);
    padding: 8px;
    border: 1px solid #ccc;
    border-radius: 4px;
    box-sizing: border-box;
}

textarea {
    resize: none;
}

button {
    background-color: #007bff;
    color: #fff;
    border: none;
    padding: 10px 15px;
    border-radius: 4px;
    cursor: pointer;
    font-size: 14px;
    margin-right: 5px;
}

button:hover {
    background-color: #0056b3;
}

a {
    color: #007bff;
    text-decoration: none;
}

a:hover {
    text-decoration: underline;
}

.comment-header {
	text-align: left;
    padding: 10px;
    border-top: 1px solid #ddd;
    font-weight: bold;
}

.comment-content {
	text-align: left;
    padding: 10px;
}

.replySection, .updateSection {
    background-color: #fff;
    padding: 15px;
    border-radius: 4px;
    border: 1px solid #ddd;
    margin-top: 10px;
}

#commentSection {
    background-color: #f9f9f9;
    padding: 15px;
    border-radius: 4px;
    margin-top: 20px;
}

#commentSection h3 {
    margin-top: 0;
}

#commentList {
    margin-top: 20px;
}
</style>
</head>
<body>
<table id="tblone">
<thead>
<tr><td>제목</td><td><input type="text" name="title" value="${board.title}" readonly></td></tr>
<tr><td>작성자</td><td><input type="text" name="writer" value="${board.writer}" readonly></td></tr>
<tr><td>게시글</td><td><textarea name="content" rows="20" readonly>${board.content}</textarea></td></tr>
<tr><td>작성시간</td><td>${board.created}</td></tr>
<tr><td>수정시간</td><td>${board.updated}</td></tr>
<tr><td colspan="2" style='text-align:center;'>
<a href="/">목록으로 돌아가기</a>&nbsp;&nbsp;
<c:if test="${sessionScope.userid == board.writer}">
<a href="/update?id=${board.id}">수정</a>&nbsp;&nbsp;
<a href="/delete?id=${board.id}">삭제하기</a>
</c:if>
</td></tr>
<tr><td colspan="2">
<button id="btnon">댓글 달기</button>
<div id="commentSection" style="display:none;">
    <h3>댓글 입력</h3>
    <textarea id="commentContent" rows="5" placeholder="댓글을 입력하세요..."></textarea><br>
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
.on("click", ".updateButton", function() {
    let id = $(this).data('id');
    $('#updateSection_' + id).toggle();
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
            $('#commentList').empty();

            function renderComments(indata, par_id, indent) {
                let str = '';
                for (let reply of indata) {
                    if (reply['parid'] === par_id) {
                        str += "<div class='comment-header' style='margin-left: " + (indent * 30) + "px;'>" + 
                               "<strong>작성자:</strong> " + reply['writer'] + 
                               "</div>" +
                               "<div class='comment-content' style='margin-left: " + (indent * 30) + "px;'>" +
                               reply['content'] + 
                               "</div>" +
                               "<div>" +
                               "<button class='replyButton' data-id='" + reply['id'] + "'>답글</button>";

                        if (reply['writer'] === userid) {
                            str += "<button class='updateButton' data-id='" + reply['id'] + "'>수정</button>" +
                                    "<button class='deleteCommentButton' data-id='" + reply['id'] + "'>삭제</button>";
                        }

                        str += "</div>" +
                               "<div id='replySection_" + reply['id'] + "' class='replySection' style='display:none;'>" +
                               "<h4>답글 작성</h4>" +
                               "<textarea class='replyContent' rows='3' placeholder='답글을 입력하세요...'></textarea><br>" +
                               "<button class='submitReplyButton' data-id='" + reply['id'] + "'>답글 추가</button>" +
                               "</div>" +
                               "<div id='updateSection_" + reply['id'] + "' class='updateSection' style='display:none;'>" +
                               "<h4>수정글 작성</h4>" +
                               "<textarea class='updateContent' rows='3' placeholder='수정글을 입력하세요...'></textarea><br>" +
                               "<button class='updateCommentButton' data-id='" + reply['id'] + "'>수정하기</button>" +
                               "</div>";

                        str += renderComments(indata, reply['id'], indent + 1);
                    }
                }
                return str;
            }

            $('#commentList').append(renderComments(data, 0, 1));
        }
    });
}
</script>
</html>
