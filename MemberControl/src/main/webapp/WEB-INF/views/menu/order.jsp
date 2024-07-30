<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>주문관리</title>
</head>
<style>
        th {
            border:none;
            text-align: center;
            padding: 20px;
            height: 25px;
        }
        table {
            font-size: 18px;
            width: 100%;
            height: 800px;
            max-width: 450px;
            margin: auto;
            border-collapse: separate;
            border-radius: 10px;
            border: 1px solid black;
            background-color: rgba(0, 0, 0, 0.1);
        }
        select {
            text-align: right;
            font-size: 18px;
            width: 400px;
            height: 500px;
        }
        td {
            text-align: right;
            padding: 10px;
        }
        input[type="text"],
        input[type="number"] {
            width: 200px;
            height: 20px;
        }
        input[type="button"] {
            width: 120px;
            font-size: 18px;
            text-align: center;
            border-radius: 4px;
            border: 1px solid black;
        }
        input[type="button"]:hover {
            background-color: rgba(122, 122, 122, 0.5);
        }
        .label1 {
            vertical-align: middle;
        }
    </style>
<body>
<input type=hidden id=mid>
<form action="" method="post">
        <table style="border: none; background-color: white;">
            <caption style="text-align: left; margin-left: 20px;"><a href="/menuctrl">메뉴관리</a> 주문관리</caption>
            <tr>
                <td>
                    <table>
                        <tr><th>메뉴목록</th></tr>
                        <tr>
                            <td style="vertical-align: top;">
                            <select size="50" id="menuselect">
                            </select>
                            </td>
                        </tr>
                        <tr>
                            <td><label for="메뉴명" class="label1">메뉴명 : </label><input type="text" id="mname" readonly style="margin-right: 24px;"></td>
                        </tr>
                        <tr>
                            <td><label for="수량" class="label1">수량 : </label><input type="number" min="1" id="mcnt" style="width: 50px;"> 잔</td>
                        </tr>
                        <tr>
                            <td><label for="금액" class="label1">금액 : </label><input type="number" id="mprice" step="100" readonly> 원</td>
                        </tr>
                        <tr>
                            <td colspan="2" style="text-align: center;"><input type="button" id='btno' value="주문" style="margin-right: 20px;"><input id='menucancel' type="button" value="취소"></td>
                        </tr>
                    </table>
                </td>
                <td>
                    <table>
                        <tr><th>주문목록</th></tr>
                        <tr>
                            <td style="vertical-align: top;">
                                <select size="50" id='orderselect'>                                    
                                </select>
                            </td>
                        </tr>
                        <tr>
                            <td><label for="총액" class="label1">총액 : </label><input type="number" id="msum1" readonly step="100"> 원 </td>
                        </tr>
                        <tr>
                            <td><label for="모바일 번호" class="label1">모바일 번호 : </label><input type="text" id="mobile" style="margin-right: 24px;" placeholder="000-0000-0000"></td>
                        </tr>
                        <tr>
                            <td>&nbsp;</td>
                        </tr>
                        <tr>
                            <td colspan="2" style="text-align: center;"><input id=orderend type="button" value="주문완료" style="margin-right: 20px;"><input id='ordercancel' type="button" value="전체취소"></td>
                        </tr>
                    </table>
                </td>
                <td>
                    <table>
                        <tr><th>매출내역</th></tr>
                        <tr>
                            <td style="vertical-align: top;">
                                <select id="lastselect" size="50" style="font-size:13px;">
                                    
                                </select>
                            </td>
                        </tr>
                        <tr>
                            <td rowspan="3"><label for="총액2" class="label1">총액 : </label><input type="text" id="msum2" readonly> 원</td>
                        </tr>
                    </table>
                </td>
            </tr>
        </table>
    </form>
</body>
<script src='https://code.jquery.com/jquery-latest.js'></script>
<script>
let price;
$(document)
.ready(function(){
	loadMenu();
	loadRevenue();
})
.on('click','#menuselect',function(){
	let menus = $(this).find('option:selected').text();
	let mn = menus.split(':');
	let mid = $(this).find('option:selected').val();
	$('#mid').val(mid);
	$('#mname').val(mn[0]);
	$('#mcnt').val(1);
	price = parseInt(mn[1].replace(' ',''));
	$('#mprice').val(price);
})
.on('click','#menucancel',function(){
	$('#mname').val('');
	$('#mcnt').val(null);
	$('#mprice').val(null);
})
.on('click','#ordercancel',function(){
	$('#msum1').val(null);
	$('#mobile').val('');
	$('#orderselect').empty();
	$('#mid').val('');
})
.on('change', '#mcnt', function() {
    $('#mprice').val(price*$('#mcnt').val());
})
.on('click','#btno',function(){
	if($('#mname').val()==''||$('#mcnt').val()==null||$('#mprice').val()==null){
		$('#menucancel').trigger('click');
		return false;
	}
	let mid = $('#mid').val();
	let on = $('#mname').val();
	let oc = $('#mcnt').val();
	let os = $('#mprice').val();
	let full = '<option value='+mid+'>'+on+'x'+oc+' '+os+'</option>';
	$('#orderselect').append(full);
	
	let total = $('#msum1').val();
	if(total==''||total==null) total=0;
	else total = parseInt($('#msum1').val());
	total = total+parseInt($('#mprice').val());
	$('#msum1').val(total);
	$('#menucancel').trigger('click');
})
.on('click','#orderend',function(){
	
	if($('#msum1').val()==''||$('#msum1').val()==null) return false;
	$('#orderselect').find('option').each(function(y, x) {
		let all = $(x).text().split(' ');
		let name = all[0];
		let mid = $(x).val();
		let qtyx = all[1].split('x');
		let qty = qtyx[1];
		let sum = all[2];
		let mobile = $('#mobile').val();
		$.ajax({
			url:'/addRevenue',type:'post',data:{mobile:mobile,menuid:mid,qty:qty,menusum:sum},dataType:'text',
			success:function(data){
				if(data=='ok') {
					$('#ordercancel').trigger('click');
					loadRevenue();
				}
			}
		})
	});
})
;
function loadRevenue() {
	$.ajax({
		url:'/revenuelist',type:'post',data:{},dataType:'json',
		success:function(data){
			let total = 0;
			$('#lastselect').empty();
			for(let x of data) {
				total += x['menusum'];
				strm = '<option>'+x['id']+'. '+x['mobile']+' '+x['menuname']+' '+x['qty']+'잔'+x['menusum']+'원'+x['created']+'</option>';
				$('#lastselect').append(strm);
			}
			$('#msum2').val(total);
		}
	})
	return false;
}

function loadMenu() {
	$.ajax({
		url:'/menulist',type:'post',data:{},dataType:'json',
		success:function(data){
			$('#menuselect').empty();
			for(let x of data) {
				strm ='<option value='+x['id']+'>'+x['name']+' : '+x['price']+'</option>';
				$('#menuselect').append(strm);
			}
		},
		error:function(){},
		complete:function(){}
	})
	return false;
}
</script>
</html>