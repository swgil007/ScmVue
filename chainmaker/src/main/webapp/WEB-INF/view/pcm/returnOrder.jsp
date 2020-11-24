<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>returnOrder</title>

<!-- <style>
	.trBottom{
		spac
	}
</style> -->

<!-- common Include -->
<jsp:include page="/WEB-INF/view/common/common_include.jsp"></jsp:include>

<script>
//페이징 설정
var pageSizeReturnOrder=10;
var pageBlockSizeReturnOrder=10;

var pageSizeModalReturnDtl=5;
var pageBlockSizeModalReturnDtl=5;

var currentRefundNum;

//페이지 로드시 실행 (Onload Event)
$(document).ready(function(){
	
	//구매담당자_발주 지시서 목록 조회
	returnOrderList();
	
	//데이트피커 활성화       
	setDatePicker();
});

function setDatePicker(){
	$.datepicker.setDefaults($.datepicker.regional['ko']); 
    $( "#startDate" ).datepicker({
         changeMonth: true, 
         changeYear: true,
         nextText: '다음 달',
         prevText: '이전 달', 
         dayNames: ['일요일', '월요일', '화요일', '수요일', '목요일', '금요일', '토요일'],
         dayNamesMin: ['일', '월', '화', '수', '목', '금', '토'], 
         monthNamesShort: ['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월'],
         monthNames: ['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월'],
         showAnim: "slide", //애니메이션을 적용한다.
         dateFormat: "yy-mm-dd",
         maxDate: 0,                       // 선택할수있는 최소날짜, ( 0 : 오늘 이후 날짜 선택 불가)
         onClose: function( selectedDate ) {    
              //시작일(startDate) datepicker가 닫힐때
              //종료일(endDate)의 선택할수있는 최소 날짜(minDate)를 선택한 시작일로 지정
             $("#endDate").datepicker( "option", "minDate", selectedDate );
             
             var endDate = $("#endDate").val();
         }    
    });
    $( "#endDate" ).datepicker({
         changeMonth: true, 
         changeYear: true,
         nextText: '다음 달',
         prevText: '이전 달', 
         dayNames: ['일요일', '월요일', '화요일', '수요일', '목요일', '금요일', '토요일'],
         dayNamesMin: ['일', '월', '화', '수', '목', '금', '토'], 
         monthNamesShort: ['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월'],
         monthNames: ['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월'],
         showAnim: "slide", //애니메이션을 적용한다.
         dateFormat: "yy-mm-dd",                    // 선택할수있는 최대날짜, ( 0 : 오늘 이후 날짜 선택 불가)
         onClose: function( selectedDate ) {    
             // 종료일(endDate) datepicker가 닫힐때
             // 시작일(startDate)의 선택할수있는 최대 날짜(maxDate)를 선택한 시작일로 지정
             $("#startDate").datepicker( "option", "maxDate", selectedDate );
             
             var startDate = $("#startDate").val();
         } 	    
    }); 
    
    $("#startDate").datepicker('setDate', 'today');
    $("#endDate").datepicker('setDate', 'today');
}

//구매담당자_발주 지시서 목록 조회 & 검색
function searchReturnOrderList(currentPage){		
	currentPage=currentPage || 1;
	
	var searchKey=document.getElementById("searchKey").value;
	var searchWord=document.getElementById("searchWord").value;
	
	var startDate=$("#startDate").val();
	var endDate=$("#endDate").val();
       //alert(typeof startDate+" => "+startDate+"\n"+typeof endDate+" => "+endDate);
	
	var param={
			currentPage:currentPage,
			pageSize:pageSizeReturnOrder,
			searchKey:searchKey,
			searchWord:searchWord,	
			startDate:startDate,
			endDate:endDate
	}
	
	console.log("startDate : "+startDate+", endDate : "+endDate);
	
	if(searchKey === 'all'){
		alert("검색조건을 선택하세요.");	
		if(startDate === ''){
			alert("시작일을 선택하세요.");			
		}
		if(endDate === ''){
			alert("종료일을 선택하세요.");	
		}
	}else{
		if(startDate ==='' && endDate === ''){
			
		}			
		else{		
			if(startDate > endDate){
				alert("종료일을 다시 선택해주세요.");
				endDate.val("");					
			}
		}
	}
	
	var resultCallbackSearch=function(data){
		returnOrderListResult(data, currentPage);
	}
	callAjax("/pcm/returnOrderList.do", "post", "text", true, param, resultCallbackSearch);
}
//구매담당자_발주 지시서 목록 조회
function returnOrderList(currentPage){
	currentPage=currentPage || 1;
	
	var searchKey=document.getElementById("searchKey").value;
	var searchWord=document.getElementById("searchWord").value;
	
	//console.log("searchKey : "+searchKey+", searchWord : "+searchWord)
	
	var param={
			currentPage:currentPage,
			pageSize:pageSizeReturnOrder,
			searchKey:searchKey,
			searchWord:searchWord		
	}
	
	var resultCallback=function(data){
		returnOrderListResult(data, currentPage);
	}
	callAjax("/pcm/returnOrderList.do", "post", "text", true, param, resultCallback);
}
//구매담당자_발주 지시서 목록 조회 콜백
function returnOrderListResult(data, currentPage){
	console.log(data);
	
	//기존 목록 삭제 및 가져온 정보 넣기
	$("#listReturnOrder").empty();
	$("#listReturnOrder").append(data);
	
	//구매담당자_발주 지시서 목록 조회 카운트
	var returnOrderTotal=$("#returnOrderTotal").val();
	
	// 페이지 네비게이션 생성
	var paginationHtml = getPaginationHtml(currentPage, returnOrderTotal, pageSizeReturnOrder, pageBlockSizeReturnOrder, "returnOrderList");
	$("#returnOrderPagination").empty().append(paginationHtml);
	
	$("#currentPageReturnOrder").val(currentPage);
}


//구매담당자_발주 지시서 단건 조회
function returnOrderSelect(refund_no){
	console.log("스크립트(returnOrderSelect)_refund_no : "+refund_no);
	var param={
			refund_no:refund_no
	}
	console.log("스크립트(returnOrderSelect)_param : "+param.refund_no);
	
	var resultCallback=function(data){
		returnOrderSelectResult(data);
	}
	callAjax("/pcm/returnOrderSelect.do", "post", "json", true, param, resultCallback);
}
//구매담당자_발주 지시서 단건 조회 콜백
function returnOrderSelectResult(data){
	console.log("data.returnOrderModel : "+data.returnOrderModel);
	
	//모달 팝업
	gfModalPop("#layer1");
	//모달 초기화 및 정보 넣기 함수 호출
	setReturnModal(data.returnOrderModel);		
}

//확인버튼 클릭 이벤트
function confirmBtnClickEvent(refund_no){	
	//구매담당자_발주 지시서 단건 조회 함수 호출
	console.log("스크립트(confirmBtnClickEvent)_refund_no : "+refund_no);
	returnOrderSelect(refund_no);	
	//returnDtlList(refund_no);
}

//모달 초기화 및 정보 넣기
function setReturnModal(object) {
	if( object == "" || object == null || object == undefined) {			
		$("#refund_no").val("");
		$("#pro_no").val("");
		$("#deli_company").val("");
		$("#pro_name").val("");		
		$("#refund_qty").val("");		
		
	} else {					
		$("#refund_no").val(object.refund_no);
		$("#pro_no").val(object.pro_no);
		$("#deli_company").val(object.deli_company);
		$("#pro_name").val(object.pro_name);
		$("#refund_qty").val(object.refund_qty);	
		currentRefundNum=object.refund_no;
	}	
}


/*
//구매담당자_발주 지시서 단건 조회_상세 리스트 
function returnDtlList(refund_no, currentPage){
	currentPage=currentPage || 1;
	
	var param={
			purchase_no:purchase_no,
			currentPage:currentPage,
			pageSize:pageSizeModalReturnDtl
	}
	
	var resultCallback=function(data){
		returnDtlListResult(data, currentPage);
	}
	callAjax("/pcm/modalReturndtl.do", "post", "text", true, param, resultCallback);
}
//구매담당자_발주 지시서 단건 조회_상세 리스트 콜백
function returnDtlListResult(data, currentPage){
	//console.log(data);
	
	//기존 목록 삭제 및 가져온 정보 넣기
	$("#listModalReturnDtl").empty();
	$("#listModalReturnDtl").append(data);
	
	//구매담당자_발주 지시서 목록 조회 카운트
	var modalReturnDtlTotal=$("#modalReturnDtlTotal").val();
	
	// 페이지 네비게이션 생성
	// var paginationHtml = getPaginationHtml(currentPage, modalPurchaseDtlTotal, pageSizeModalPurchaseDtl, pageBlockSizeModalPurchaseDtl, "purchaseDtlList");
	// $("#ModalPurchaseDtlPagination").empty().append(paginationHtml);
	
	// $("#currentPageModalPurchaseDtl").val(currentPage);	
}
*/


function sendRefundDirection(refund_no){	
	// currentPage=currentPage || 1;
	
	var param={
			refund_no:currentRefundNum,
			// currentPage:currentPage,
			pageSize:pageSizeModalReturnDtl
	}
	
	var resultCallback=function(data){
		sendRefundDirectionResult(data/* , currentPage */);
	}
	
	callAjax("/pcm/sendRefund.do", "post", "text", true, param, resultCallback);
}

function sendRefundDirectionResult(data){
	alert(data);
	//모달 팝업
	gfCloseModal();		
}
</script>
</head>
<body>
	<form id="myForm" action=""  method="">
		<input type="hidden" name="currentPageReturnOrder" id="currentPageReturnOrder" value="">
		<input type="hidden" name="currentPageModalReturnDtl" id="currentPageModalReturnDtl" value="">
		<input type="hidden" id="deliCompanyEmail" name="deliCompanyEmail" value=""/>
		<input type="hidden" id="currentRefundNum" name="currentRefundNum" value=""/>
		
		<div id="wrap_area">
			
			<!-- header Include -->
			<jsp:include page="/WEB-INF/view/common/header.jsp"></jsp:include>
			
			<div id="container">
				<ul>
					<li class="lnb">
					
						<!-- lnb Include -->
						<jsp:include page="/WEB-INF/view/common/lnbMenu.jsp"></jsp:include>
						
					</li>
					<li class="contents">
						<div class="content">
							<!-- 메뉴 경로 영역 -->
							<p class="Location">
								<a href="../dashboard/dashboard.do" class="btn_set home">메인으로</a> <a href="#"
									class="btn_nav">제품 발주/반품</a> <span class="btn_nav bold">반품 지시서 목록</span> <a href="/pcm/returnOrder.do" class="btn_set refresh">새로고침</a>
							</p>
							
							<!-- 검색 영역 -->
							<p class="search">
							
							</p>							
							<p class="conTitle" id="searchArea">
							<span>반품 지시서 목록_구매담당자</span>
								 <span class="fr"> 
									<select id="searchKey" name="searchKey" style="width: 80px;">
									    <option value="all" id="option1" selected="selected">검색 조건</option>
										<option value="deli_company" id="option2">업체 명</option>
										<option value="pro_name" id="option3">제품 명</option>										
									</select> 
									<input type="text" id="searchWord" name="searchWord" placeholder="검색어를 입력하세요." style="height: 28px;"> 
										<input type="text" id="startDate" name="startDate" placeholder="시작일 선택" style="height: 28px;width: 80px"></input>
										<input type="text" id="endDate" name="endDate" placeholder="종료일 선택" style="height: 28px;width: 80px"></input>
										<a class="btnType blue" href="javascript:searchReturnOrderList()" onkeydown="enterKey()" name="search">
										<span id="searchEnter">검색</span></a>			
								</span>
							</p>
							
							<!-- 테이블 영역 -->
							<div class="divReturnOrder" id="divReturnOrder">
								<table class="col">
									<colgroup>
										<col width="5%">
										<col width="5%">
										<col width="8%">
										<col width="5%">
										<col width="10%">
										<col width="5%">
									</colgroup>
									<thead>
										<tr>
											<th scope="col">반품번호</th>
											<th scope="col">반품회사</th>
											<th scope="col">반품제품</th>
											<th scope="col">반품수량</th>
											<th scope="col">반품날짜</th>
											<th scope="col">입금확인</th>
										</tr>
									</thead>
									
									<!--  -->
									<tbody id="listReturnOrder">
									</tbody>									
								</table>
							</div>	<!-- .divReturnOrderList 종료 -->
							
							<!-- 테이블 페이지 네비게이션 영역 -->
							<div class="pagingArea" id="returnOrderPagination">
							
							</div>																					
						</div><!-- div.content 종료 -->
					</li>	<!-- li.content 종료 -->
				</ul>
			</div>	<!-- div#container 종료 -->
		</div>	<!-- div#wrap_area 종료 -->
		
		<!-- Modal 시작 -->
		<div id="layer1" class="layerPop layerType2" style="width: 900px;">
		<dl>
			<dt>
				<strong>발주 지시서</strong>
			</dt>
			<dd class="content">
				<!-- s : 여기에 내용입력 -->
				<table class="row">
					<caption>caption</caption>
					<colgroup>
						<col width="120px">
						<col width="*px">
					</colgroup>

					<tbody>										
						<tr>						
							<th scope="row">반품번호</th>
							<td><input type="text" class="inputTxt p100" name="refund_no" id="refund_no" readonly="readonly"/></td>
							<th scope="row">반품회사</th>
							<td><input type="text" class="inputTxt p100" name="deli_company" id="deli_company" readonly="readonly"/></td>						
						</tr>						
						<tr>
							<th scope="row">제품명</th>
							<td><input type="text" class="inputTxt p100" name="pro_no" id="pro_no" readonly="readonly"/></td>
							<th scope="row">제품번호</th>
							<td><input type="text" class="inputTxt p100" name="pro_name" id="pro_name" readonly="readonly"/></td>
						</tr>
						<tr>
							<th scope="row">반품수량</th>
							<td><input type="text" class="inputTxt p100" name="refund_qty" id="refund_qty" readonly="readonly"/></td>
						</tr>
					</tbody>
				</table>
				
<!-- 				<table class="row mt20" id="modalReturnDtlList">
					<colgroup>
						<col width="8%">
						<col width="5%">
						<col width="6%">
						<col width="8%">
						<col width="5%">
						<col width="10%">
						<col width="20%">
					</colgroup>
					<thead>
						<tr style="background-color: silver;">
							<th scope="row" style="font-weight: bold;">제품</th>
							<th scope="row" style="font-weight: bold;">수량</th>
							<th scope="row" style="font-weight: bold;">납품금액</th>
							<th scope="row" style="font-weight: bold;">금액</th>
							<th scope="row" style="font-weight: bold;">창고번호</th>
							<th scope="row" style="font-weight: bold;">창고이름</th>
							<th scope="row" style="font-weight: bold;">창고주소</th>
						</tr>
					</thead>
					<tbody id="listModalReturnDtl">					
					</tbody>	
				</table>
				테이블 페이지 네비게이션 영역
				<div class="pagingArea" id="ModalReturnDtlPagination"></div>	 -->

				<!-- e : 여기에 내용입력 -->

				<div class="btn_areaC mt30">
					<a href="javascript:sendRefundDirection()" class="btnType blue" id="btnSendConfirm" name="btn"><span>반품 지시서 전송</span></a>
					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					<a href=""	class="btnType gray" name="btn"><span>취소</span></a>
				</div>
			</dd>
		</dl>
		<a href="" class="closePop"><span class="hidden">닫기</span></a>
	</div>	
	<!-- Modal 종료 -->		
			
	</form>	
</body>
</html>