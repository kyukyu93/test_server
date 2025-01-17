<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<html>
<head>
<title>worrior</title>
<meta http-equiv="content-type" content="text/html; charset=utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=Edge" />
<link rel="stylesheet" type="text/css" href="/resources/worrior/css/common.css" />
<script type="text/javascript" src="/resources/worrior/js/nav.js"></script>
<script type="text/javascript" src="/resources/js/common.js"></script>
<!-- <script type="text/javascript" src="/resources/worrior/js/utils.js"></script> -->
<script type="text/javascript" src="/resources/worrior/js/jquery-3.5.1.js"></script>
</head>
<script type="text/javascript">
var pageStart = 0;
var initPaging = 0;
var pageTarget = 1;

$(document).ready(function () {
	$('#ajaxReload').on('click', function() {
		var param = new Object();
		param.useType = "1";
 		var callBack = "ajax_callback";
		get_ajax("/worrior/manage/getMon.ajax", param, callBack);
	});
	$('#ajaxInfo').on('click', function() {
		var param = new Object();
		param.useType = "1";
 		var callBack = "apiList_callback";
		get_ajax("/worrior/manage/getMonList.ajax", param, callBack);
	});
	
	$('#apiReload').on('click', function() {
		var param = new Object();
		param.useType = "2";
 		var callBack = "api_callback";
		get_ajax("/worrior/manage/getMon.ajax", param, callBack);
		
	});
	$('#apiInfo').on('click', function() {
		var param = new Object();
		param.useType = "2";
 		var callBack = "apiList_callback";
		get_ajax("/worrior/manage/getMonList.ajax", param, callBack);
	});
	$('#secureReload').on('click', function() {
		var param = new Object();
		param.useType = "3";
 		var callBack = "api_callback";
		get_ajax("/worrior/manage/getMon.ajax", param, callBack);
	});
	$('#messageReload').on('click', function() {
		var param = new Object();
		param.useType = "4";
 		var callBack = "api_callback";
		get_ajax("/worrior/manage/getMon.ajax", param, callBack);
	});
	

	$('#ajaxReload').click();
	$('#apiReload').click();
	
	fncSearch(1);
});


function ajax_callback(result) {
	console.log(result.data);
	if(result.data.callAvg=="NaN") $('#ajaxCallAvg').html("-");
	else $('#ajaxCallAvg').html(result.data.callAvg + "%");
	
	$('#ajaxAllCnt').html(result.data.allCnt + " 건");
	$('#ajaxRequestTime').html(result.data.requestTime);
	$('#ajaxSuccessCnt').html(result.data.successCnt + " 건");
	$('#ajaxFailCnt').html(result.data.failCnt + " 건");
}

function api_callback(result) {
	console.log(result.data);
	if(result.data.callAvg=="NaN") $('#apiCallAvg').html("-");
	else $('#apiCallAvg').html(result.data.callAvg + "%");
	
	$('#apiAllCnt').html(result.data.allCnt + " 건");
	$('#apiRequestTime').html(result.data.requestTime);
	$('#apiSuccessCnt').html(result.data.successCnt + " 건");
	$('#apiFailCnt').html(result.data.failCnt + " 건");
}
function apiList_callback(result) {
	$("#boardList").empty();
	var str = "";
	if (result.data.boardList.length > 0) {
		$.each( result.data.boardList, function(index, data) {
			str+="<tr>";
			str+="<td>"+data.userId+"</td>";
			str+="<td>"+data.useUrl+"</td>";
			if(data.useParameter == "undefined" || data.useParameter == undefined) str+="<td> - </td>";
			else str+="<td>"+data.useParameter+"</td>";
			if(data.useMethod == "undefined" || data.useMethod == undefined) str+="<td> - </td>";
			else str+="<td>"+data.useMethod+"</td>";
			str+="<td>"+data.useIp+"</td>";
			if(data.useType=="1") str+="<td>ajax</td>";
			else if(data.useType=="2") str+="<td>API</td>";
			else if(data.useType=="3") str+="<td>보안</td>";
			else str+="<td>메시지</td>";
			if(data.useSuccess=="Y") str+="<td>성공</td>";
			else str+="<td>실패</td>";
// 			str+="<td>"+moment(data.createDt).format('YYYY-MM-DD HH:mm:ss')+"</td>";
			str+="<td>"+data.createDt+"</td>";
			//
			str+="</tr>";
			$("#boardList").append(str);
			str = "";
		});
		
	} else {
		str+="<tr>";
		str+="<td colspan='8'>";
		str+="호출 기록이 없습니다"
		str+="</td>";
		str+="</tr>";
		$("#boardList").append(str);
	}
	$(".util_paging").empty();
	
	
	initPaging = parseInt(result.data.boardCount / 10) + 1;
	
	console.log("#######" + initPaging);
	str = "";
	str+="<a href='#' onclick=\"fncSearch('"+0+"');\" class='pg_first'></a>";
	str+="<a href='#' onclick=\"fncSearch('"+(pageStart-100)+"');\" class='pg_prev'></a>";
	
	for(var i = pageStart; i < initPaging; i ++) {
		str+="<a href='#' id=page"+i+" onclick=\"fncSearch('"+i+"');\" class='num'>"+(i+1)+"</a>";
	}
	str+="<a href='#' onclick=\"fncSearch('"+(pageStart+100)+"');\" class='pg_next'></a>";
	str+="<a href='#' onclick=\"fncSearch('"+(initPaging-1)+"');\" class='pg_last'></a>";
	
	$(".util_paging").append(str);
	$('#total').html(result.data.boardCount);
	
	document.getElementById("page"+pagestart).classList.add('active');
	console.log(pageStart);
}

function fncSearch(pag) {
	
	if(pag == undefined || pag == "") pag = 0;
	if(pag > initPaging) pag = initPaging-1;
	if(pag < 0) pag = 0;
	pagestart = pag;
	console.log('##' + pageStart);
	var param = new Object();
	param.searchType = $("#searchType").val();
	param.searchText = $("#searchText").val();
	param.useType = pageTarget;
	param.pageStart = pagestart;
	
	var callBack = "apiList_callback";
// 	request_ajax("/worrior/manage/getMonList.ajax", param, callBack);
	get_ajax("/worrior/manage/getMonList.ajax", param, callBack);
}
</script>

<body>

	<div class="wrap">
		<!-- 스킵 네비게이션 -->
		<!-- header -->
		<div class="header">
			<jsp:include page="../../common/worrior_nav.jsp" flush="false" />
		</div>
		<!-- 			<hr class="div_contents" /> -->
		<div class="item-block"></div>
		<div class="container">
			
			<div class="mon_banner" style="background-color: aliceblue; height: 150px; width: 100%; display: inline-block;">
				<div class="mon1" id="ajaxInfo" style="float: left;width: 23%;display: inline-block;height: 100%;padding: 1%;background-color: lightgray; cursor: pointer;">
					<div style="display: inline-block; width: 100%;">
						<div style="display: block; margin-bottom: 30px; font-weight: bold; font-size: 1.3em; float: left;">프로세스 모니터링</div>
						<div style="display: block; margin-bottom: 30px; font-weight: bold; font-size: 1.3em; float: right;">
							<button id="ajaxReload">새로고침</button>
						</div>
					</div>
					<div>
						<table>
							<thead>
								<tr>
									<th>호출</th>
									<th>정상</th>
									<th>오류</th>
									<th>응답률</th>
								</tr>
							</thead>
							<tbody style="text-align: center;">
								<tr>
									<td id="ajaxAllCnt">1,000</td>
									<td id="ajaxSuccessCnt">970</td>
									<td id="ajaxFailCnt">30</td>
									<td id="ajaxCallAvg">97.00%</td>
								</tr>
							</tbody>
						</table>
					</div>
					<div style="display: block; margin-top: 30px; text-align: right; " id="ajaxRequestTime">2021-07-18 16:01:00</div>
				</div>

				<div class="mon2" id="apiInfo" style="float: left;width: 23%;display: inline-block;height: 100%;padding: 1%;background-color: navajowhite; cursor: pointer;">
					<div style="display: inline-block; width: 100%;">
						<div style="display: block; margin-bottom: 30px; font-weight: bold; font-size: 1.3em; float: left;">API 모니터링</div>
						<div style="display: block; margin-bottom: 30px; font-weight: bold; font-size: 1.3em; float: right;">
							<button id="apiReload">새로고침</button>
						</div>
					</div>
					<div>
						<table>
							<thead>
								<tr>
									<th>호출</th>
									<th>정상</th>
									<th>오류</th>
									<th>응답률</th>
								</tr>
							</thead>
							<tbody style="text-align: center;">
								<tr>
									<td id="apiAllCnt">1,000</td>
									<td id="apiSuccessCnt">970</td>
									<td id="apiFailCnt">30</td>
									<td id="apiCallAvg">97.00%</td>
								</tr>
							</tbody>
						</table>
					</div>
					<div style="display: block; margin-top: 30px; text-align: right;" id="apiRequestTime">2021-07-18 16:01:00</div>
				</div>
				
				<div class="mon3" style="float: left;width: 23%;display: inline-block;height: 100%;padding: 1%;background-color: steelblue; cursor: pointer;">
					<div style="display: inline-block; width: 100%;">
						<div style="display: block; margin-bottom: 30px; font-weight: bold; font-size: 1.3em; float: left;">보안 모니터링</div>
						<div style="display: block; margin-bottom: 30px; font-weight: bold; font-size: 1.3em; float: right;">
							<button>새로고침</button>
						</div>
					</div>
					<div>
						<table>
							<thead>
								<tr>
									<th>오늘</th>
									<th>누적</th>
								</tr>
							</thead>
							<tbody style="text-align: center;">
								<tr>
									<td>0</td>
									<td>3</td>
								</tr>
							</tbody>
						</table>
					</div>
					<div style="display: block; margin-top: 30px; text-align: right;">2021-07-18 16:01:00</div>
				</div>
				
				<div class="mon4" style="float: left;width: 23%;display: inline-block;height: 100%;padding: 1%;background-color: cornsilk; cursor: pointer;">
					<div style="display: inline-block; width: 100%;">
						<div style="display: block; margin-bottom: 30px; font-weight: bold; font-size: 1.3em; float: left;">메시징 모니터링</div>
						<div style="display: block; margin-bottom: 30px; font-weight: bold; font-size: 1.3em; float: right;">
							<button>새로고침</button>
						</div>
					</div>
					<div>
						<table>
							<thead>
								<tr>
									<th>총 건수</th>
									<th>정상</th>
									<th>오류</th>
									<th>전송률</th>
								</tr>
							</thead>
							<tbody style="text-align: center;">
								<tr>
									<td>3,700</td>
									<td>3,500</td>
									<td>200</td>
									<td>94.59%</td>
								</tr>
							</tbody>
						</table>
					</div>
					<div style="display: block; margin-top: 30px; text-align: right;">2021-07-18 16:01:00</div>
				</div>
			</div>
			<div class="item-block"></div>
			
			<div class="table_search_area">
					<div class="table_top_side">
						<select name="searchType" id="searchType" class="cb_box w100">
							<option value="userId">사용자ID</option>
							<option value="useType">호출구분</option>
							<option value="useSuccess">성공여부</option>
						</select> 
						<input type="text" name="searchText" id="searchText" value="" class="in_text w150 mr5" maxlength="100"> 
						<a href="#" id="btnSearch" class="search_btn input_btn">검색</a>
					</div>
					<div class="item-block"></div>
				</div>
				<table class="list_table">
					<colgroup>
						<col width="100">
						<col width="200">
						<col width="*">
						<col width="80">
						<col width="200">
						<col width="80">
						<col width="80">
						<col width="180">
					</colgroup>
					<thead>
						<tr class="first">
							<th scope="col">ID</th>
							<th scope="col">URL</th>
							<th scope="col">Parameter</th>
							<th scope="col">Method</th>
							<th scope="col">IP</th>
							<th scope="col">호출구분</th>
							<th scope="col">성공여부</th>
							<th scope="col">호출일자</th>
						</tr>
					</thead>
					<tbody id="boardList">
<!-- 					TODO 삭제 -->
						<tr>
							<td>test1</td>
							<td>TEST/TEST</td>
							<td>0.0.0.1</td>
							<td>param1</td>
							<td>API</td>
							<td>성공</td>
							<td>2021.08.21</td>
						</tr>
						
					</tbody>
				</table>
				<!-- 하단 영역 -->
				<div class="btm_area">
					<div class="util_paging">
						<a href="#" class="pg_first"></a>
						<a href="#" class="pg_prev"></a> 
						<a href="#" class="num active">1</a>
						<a href="#" class="pg_next"></a> 
						<a href="#" class="pg_last"></a>
					</div>
				</div>
		</div>
		<div class="footer">
			<jsp:include page="../../common/worrior_footer.jsp"
				flush="false" />
		</div>
	</div>
</body>
</html>
