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
	$('#btnLoadm').trigger('click');
})
.on('click','#btnClear',function(){
	$('#id,#title,#price').val("");
})
.on('click','#btnLoadm',function(){
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
					$('#btnLoadm,#btnClear').trigger('click');
				}
			}
		})
	} else {
		$.ajax({
			url:'/updateMenu',type:'post',data:{id:id,name:title,price:price},dataType:'text',
			success:function(data){
				if(data=='ok') {
					$('#btnLoadm,#btnClear').trigger('click');
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
				$('#btnLoadm,#btnClear').trigger('click');
			}
		}
	})
})


<!--
.on('click','#btnLoadm',function(){
	$.post('/menulist',{},function(data){
		$('#tblMenu tbody').empty();
		for(let x of data) {
			let strm = '<tr>';
			strm +='<td>'+x['id']+'</td><td>'+x['name']+'</td><td>'+x['price']+'</td></tr>';
			$('#tblMenu tbody').append(strm);
		}
	},'json');
})
-->
</script>
</html>