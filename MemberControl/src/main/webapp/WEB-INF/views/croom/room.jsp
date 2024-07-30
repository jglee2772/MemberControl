<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<style>
	table {
		
		
		
		margin:auto;
		border-collapse:collpase;
	}
	td {
		border-collapse:collapse;
		border:1px solid black;
	}
	th {
		border:none;
	}
</style>
<body>
<input type=hidden id=cid>
<table style="border: none;">
	<tr>
	<td>
	<table id=tblRoom>
	<thead>
	<tr><td>id</td><td>타입이름</td><td>객실명</td><td>숙박인원</td><td>가격</td></tr>
	</thead>
	<tbody>
	</tbody>
	</table>
	</td>
	<td>
	<table>
		<tr><td>객실타입</td><td><select size="1" id=roomselect></select></td></tr>
		<tr><td>객실명</td><td><input type=text id=roomname></td></tr>
		<tr><td>숙박가능인원</td><td><input type=number min=1 id=personal>명</td></tr>
		<tr><td>1박 요금</td><td><input type=number id=price>원</td></tr>
		<tr><td colspan=2 style="text-align: center;"><input type=button id=btnon value="등록">&nbsp;&nbsp;<input type=button id=btnclear value="비우기">&nbsp;&nbsp;<input type=button id=btncancel value="삭제">
	</table>
	</td>
	</tr>
</table>
</body>
<script src='https://code.jquery.com/jquery-latest.js'></script>
<script>
$(document)
.ready(function(){
	loadRoomtype();
	loadRoom();
})
.on('click','#btnclear', function(){
	$('#roomname').val('');
	$('#personal').val(null);
	$('#price').val(null);
	$('#cid').val('');
})
.on('click','#btncancel',function(){
	if(!confirm("정말로 삭제하시겠습니까?")) return false;
	let id = $('#cid').val();
	$.ajax({
		url:'/deleteroom',type:'post',data:{id:id},dataType:'text',
		success:function(data) {
			if(data=='ok') {
				$('#btnclear').trigger('click');
				loadRoom();
			}
		}
	})
})
.on('click','#btnon',function(){
	let id = $('#cid').val();
	let typenum = $('#roomselect').find('option:selected').val();
	let name = $('#roomname').val();
	let personal = $('#personal').val();
	let price = $('#price').val();
	if(id=='') {
		$.ajax({
			url:'/insertroom',type:'post',data:{type:typenum,name:name,personal:personal,price:price},dataType:'text',
			success:function(data){
				if(data=='ok') {
					$('#btnclear').trigger('click');
					loadRoom();
				}
			}
		})
	} else {
		$.ajax({
			url:'/updateroom',type:'post',data:{id:id,type:typenum,name:name,personal:personal,price:price},dataType:'text',
			success:function(data) {
				if(data=='ok') {
					$('#btnclear').trigger('click');
					loadRoom();
				}
			}
		})
	}
	return false;
})
.on('click','#tblRoom tbody tr',function(){
	let id=$(this).find('td:eq(0)').text();
	let typename=$(this).find('td:eq(1)').text();
	let name=$(this).find('td:eq(2)').text();
	let personal=$(this).find('td:eq(3)').text();
	let price=$(this).find('td:eq(4)').text();
	$('#cid').val(id);
	$('#roomselect option').each(function() {
        if ($(this).text() == typename) {
            $(this).prop('selected', true);
        }
    });
	$('#roomname').val(name);
	$('#personal').val(personal);
	$('#price').val(price);
})
;
function loadRoomtype() {
	$.ajax({
		url:'/roomtype',type:'post',data:{},dataType:'json',
		success:function(data){
			$('#roomselect').empty();
			for(let x of data) {
				strn = '<option value='+x["id"]+'>'+x["typename"]+'</option>';
				$('#roomselect').append(strn);
			}
		}
	})
	return false;
}
function loadRoom() {
	$.ajax({
		url:'/loadroom',type:'post',data:{},dataType:'json',
		success:function(data){
			$('#tblRoom tbody').empty();
			for(let x of data){
				let strm = '<tr>';
				strm+='<td>'+x['id']+'</td><td>'+x['typename']+'</td><td>'+x['name']+'</td><td>'+x['personal']+'</td><td>'+x['price']+'</td></tr>';
				$('#tblRoom tbody').append(strm);
			}
		}
	})
	return false;
}
</script>
</html>