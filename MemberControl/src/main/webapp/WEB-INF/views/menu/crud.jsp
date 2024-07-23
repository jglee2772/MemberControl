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
<table style='width:100%'>
<tr>
	<td style='width:30%;text-align:left;border:none;'>
		<a href='/orderctrl'>주문관리</a>
	</td>
	<td style='width:40%;text-align:center;border:none;'>
		<h1>메뉴관리</h1>
	</td>
	<td style='width:30%;border:none;'>
	</td>
</table>
<input type=hidden id=id>
<table>
	<tr><td>메뉴명</td><td><input type=text id=title></td></tr>
	<tr><td>가격</td><td><input type=number id=price></td></tr>
	<tr><td colspan=2 style='text-align:center;'>
	<input type=button value='등록' id=btnAdd>
	<input type=button value='비우기' id=btnClear>
	<input type=button value='삭제' id=btnDelete>
	</td></tr>
</table>
<table id=tblMenu>
<thead>
<tr><td colspan=3><input type=button id=btnLoadm value="가저오기"></td></tr>
<tr><th>번호</th><th>메뉴명</th><th>가격</th></tr>
</thead>
<tbody></tbody>
</table>
</body>
<script src='https://code.jquery.com/jquery-latest.js'></script>
<script>
$(document)
.ready(function(){
	loadMenu();
})
.on('click','#btnClear',function(){
	$('#id,#title,#price').val("");
})

.on('click','#btnAdd',function(){
	let id = $('#id').val();
	let title = $('#title').val();
	let price = $('#price').val();
	if(title == ''||price == '') return false;
	if(id=='') {
		$.ajax({
			url:'/addMenu',type:'post',data:{name:title,price:price},dataType:'text',
			success:function(data){
				if(data=='ok') {
					$('#btnClear').trigger('click');
					loadMenu();
				}
			}
		})
	} else {
		$.ajax({
			url:'/updateMenu',type:'post',data:{id:id,name:title,price:price},dataType:'text',
			success:function(data){
				if(data=='ok') {
					$('#btnClear').trigger('click');
					loadMenu();
				}
			}
		})
	}
	return false;
})
.on('click','#tblMenu tbody tr',function(){
	let id=$(this).find('td:eq(0)').text();
	let title=$(this).find('td:eq(1)').text();
	let price=$(this).find('td:eq(2)').text();
	$('#id').val(id);
	$('#title').val(title);
	$('#price').val(price);
})
.on('click','#btnDelete',function(){
	if(!confirm("정말로 삭제하십니까?")) return false;
	let id = $('#id').val();
	$.ajax({
		url:'/deleteMenu',type:'post',data:{id:id},dataType:'text',
		success:function(data) {
			if(data=='ok') {
				$('#btnClear').trigger('click');
				loadMenu();
			}
		}
	})
})
;
function loadMenu() {
	$.ajax({
		url:'/menulist',type:'post',data:{},dataType:'json',
		success:function(data){
			$('#tblMenu tbody').empty();
			for(let x of data) {
				let strm = '<tr>';
				strm +='<td>'+x['id']+'</td><td>'+x['name']+'</td><td>'+x['price']+'</td></tr>';
				$('#tblMenu tbody').append(strm);
			}
		},
		error:function(){},
		complete:function(){}
	})
	return false;
}
</script>
</html>