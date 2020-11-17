// 그룹코드 페이징 설정
var pageSizeDailyOrder = 10;
var pageBlockSizeDailyOrder = 10;
	
// 상세코드 페이징 설정
var pageSizeComnDtlCod = 5;
var pageBlockSizeComnDtlCod = 10;

$(function() {
	// 일일 수주 조회
	fListDailyOrderHistroy();
	// 버튼 이벤트 등록
	fRegisterButtonClickEvent();
	
	
	
	// 반품 체크 검색 이벤트 등록
	fCheckRefundClickEvent();
});

/** 버튼 이벤트 등록 */
function fRegisterButtonClickEvent() {
	$('a[name=btn]').click(function(e) {
		e.preventDefault();

		var btnId = $(this).attr('id');

		switch (btnId) {
			case 'shippingDoneBtn' :
				fShippingDone();
				break;
			case 'btnCloseGrpCod' :
			case 'btnClose' :
				gfCloseModal();
				break;
		}
	});
}

/** 일별 수주 내역 조회 */
function fListDailyOrderHistroy(currentPage) {

  currentPage = currentPage || 1;

  console.log("currentPage : " + currentPage);

  var param = {
    currentPage: currentPage
    , pageSize: pageSizeDailyOrder
  }

  var resultCallback = function(data) {
    flistDailyOrderHistroyResult(data, currentPage);
  };
  // Ajax실행 방식
  // callAjax("Url",type,return,async or sync방식,넘겨준거,값,Callback함수 이름)
  // html로 받을거라 text
  callAjax("/scm/dailyOrderHistory.do/orders/dailyOrder", "post", "text", true, param, resultCallback);
}

/** 일별 수주 내역 조회 콜백 함수 */
function flistDailyOrderHistroyResult(data, currentPage) {

  // alert(data);
  console.log(data);

  // 기존 목록 삭제
  $('#listDailyOrderHistroy').empty();

  var $data = $($(data).html());

  $("#listDailyOrderHistroy").append(data);

  // 총 개수 추출
  var $totalCntDailyOrder = $data.find("#totalCntDailyOrder");
  var totalCntDailyOrder = $totalCntDailyOrder.text();

  // 페이지 네비게이션 생성
  var paginationHtml = getPaginationHtml(currentPage, totalCntDailyOrder, pageSizeDailyOrder, pageBlockSizeDailyOrder, 'fListDailyOrderHistroy');
  console.log("paginationHtml : " + paginationHtml);

  $("#dailyOrderPagination").empty().append(paginationHtml);

  // 현재 페이지 설정
  $("#currentPageComnGrpCod").val(currentPage);
}


/** 주문 정보 배송 지시서 모달 실행 */
function fPopModalDeliDirection(order_no, pro_no) {

    // Tranjection type 설정
    $("#action").val("U");
    
    $("#shipping_tbody").children().remove();
    
    $("#order_qty_upper").val('');
    
    // 주문 번호, 제품 번호 단건 조회
    fSelectOrderNoAndProNo(order_no, pro_no);
  
}

// 미입금 주문 팝업
function fNotDepositPopUp(){
	alert("입금되지 않은 주문입니다.");
}

// 재고가 부족한 상황
function fNoneWareQtyPopUp(){
	alert("재고가 부족합니다. 발주 지시서를 작성해주세요.");
}

/** 그룹코드 단건 조회 */
function fSelectOrderNoAndProNo(order_no, pro_no) {

  var param = { 
		  order_no : order_no,
		  pro_no : pro_no
		  };

  var resultCallback = function(data) {
	  fSelectOrderNoAndProNoResult(data);
  };
  
  var prefix = "/scm/dailyOrderHistory.do/order/";
  var suffix = "/product/";
  var url = prefix + order_no + suffix + pro_no;

  callAjax(url, "get", "json", true, null, resultCallback);
}



/** 그룹코드 단건 조회 콜백 함수 */
function fSelectOrderNoAndProNoResult(data) {

    // 일별 수주내역 폼 데이터 설정
    fInitFormDeliyDirection(data.orderDetail);


    // 모달 팝업
    gfModalPop("#deliDirection");

}



/** 일별 수주 내역 폼 초기화 */
function fInitFormDeliyDirection(object) {
  $("#order_no").focus();
  if (object == "" || object == null || object == undefined) {

    $("#order_no").val("");
    $("#order_date").val("");
    $("#user_company").val("");
    $("#pro_name").val("");
    $("#pro_ware_qty").val("");
    $("#name").val("");
    $("#order_cd").val("");
    $("#order_no").focus();

  } else {

	    $("#order_no").text(object.order_no);
	    $("#order_date").text(object.order_date);
	    $("#user_company").text(object.user_company);
	    $("#pro_name").text(object.pro_name);
	    $("#order_qty").text(object.order_qty);
/*
 * $("#name").text(object.name); $("#order_cd").text(object.order_cd);
 */
	    $("#order_no").focus();
	    
	    
	    $("#ware_name").text('');
	    $("#pro_ware_qty_upper").val('');

	    $("#pro_name_bottom").text('');
	    
	    
	    
	    
	    
  }
  
  
  // pro_no로 wh정보 가져오기
  fMakeWHInfoDropdownByProNo(object.pro_no);
  
}

function fMakeWHInfoDropdownByProNo(pro_no){

	var prefix = "/scm/dailyOrderHistory.do/warehouse/";
	var url = prefix + pro_no;
	

	var resultCallback = function(data) {
		fMakeWHInfoDropdownByProNoResult(data, 'ware_name_option');
	};
	
	callAjax(url, "get", "json", true, null, resultCallback);
	
}

function fMakeWHInfoDropdownByProNoResult(data, optionId){
	
	
		$("#"+optionId).find("option").remove();
		$("#whInfoData").children().remove();
		
		$("#"+optionId).append("<option value=''> 창고 선택 </option>");
		

		// 해당 제품들 정보 hidden 저장
		$("#whInfoData").find("input").remove();
		
		for (var i=0 ; i<data.whInfoList.length ; i++) {
			var model = data.whInfoList[i];
			$("#"+optionId).append("<option value='"+model.ware_no+"' >"+model.ware_name+"</option>");
			$("#whInfoData").append("<div class='"+model.ware_no+"'"+"id="+model.ware_no+">"+"</div>");
			$("#"+model.ware_no).append("<input type='hidden' class='wb_ware_no' value='"+model.ware_no+"'>");

			$("#"+model.ware_no).append("<input type='hidden' class='wb_ware_name' value='"+model.ware_name+"'>");
			$("#"+model.ware_no).append("<input type='hidden' class='wb_pro_no' value='"+model.pro_no+"'>");
			$("#"+model.ware_no).append("<input type='hidden' class='wb_pro_name' value='"+model.pro_name+"'>");
			$("#"+model.ware_no).append("<input type='hidden' class='wb_name' value='"+model.name+"'>");
			
			$("#"+model.ware_no).append("<input type='hidden' class='wb_pro_ware_qty' value='"+model.pro_ware_qty+"'>");

			/*
			 * $("#"+model.ware_no).append("<input type='hidden'
			 * class='"+model.ware_no+"'id='ware_no'
			 * value='"+model.ware_no+"'>");
			 * 
			 * $("#"+model.ware_no).append("<input type='hidden'
			 * id='"+model.ware_no+"ware_no"+model.pro_no+"pro_no"+"'
			 * value='"+model.pro_no+"'>"); $("#"+model.ware_no).append("<input
			 * type='hidden' id='"+model.ware_no+"ware_no"+model.name+"name"+"'
			 * value='"+model.name+"'>");
			 * 
			 * $("#"+model.ware_no).append("<input type='hidden'
			 * id='"+model.ware_no+"ware_no"+model.pro_ware_qty+"pro_ware_qty"+"'
			 * value='"+model.pro_ware_qty+"'>");
			 */
		}
}

function fSelectedOptions(ware_no, optionId){
	
	$("#order_qty_upper").val('');
	
/*
 * var option_ware_no =
 * $("#whInfoData").find('.'+ware_no).children('.wb_ware_no').val(); var
 * option_ware_name =
 * $("#whInfoData").find('.'+ware_no).children('.wb_ware_name').val(); var
 * option_pro_no =
 * $("#whInfoData").find('.'+ware_no).children('.wb_pro_no').val(); var
 * option_pro_name =
 * $("#whInfoData").find('.'+ware_no).children('.wb_pro_name').val(); var
 * option_name = $("#whInfoData").find('.'+ware_no).children('.wb_name').val();
 */
	let option_pro_ware_qty = $("#whInfoData").find('.'+ware_no).children('.wb_pro_ware_qty').val();
	
	$("#pro_ware_qty_upper").val(option_pro_ware_qty);
	

	
    /* $("#name").text(option_name); */

/*
 * $("#ware_name").text(option_ware_name);
 * $("#pro_name_bottom").text(option_pro_name);
 */
 /* $("#pro_ware_qty").text(option_pro_ware_qty); */
	
}

function faddShppingBtn(){
	
	
	let order_qty_upper = $("#order_qty_upper").val() * 1;
	
	let order_qty = $("#order_qty").text() * 1;
	
	
	// 많은 수량 주문 or 0개 주문의 경우
	if(order_qty_upper > order_qty){
		alert("주문 수량보다 많은 양의 수주량입니다.");
		return
	} else if(order_qty_upper==0){
		alert("0개 이상의 수량만 수주 가능합니다.")
		return
	}
	
	// 해당 창고의 재고수 보다 많은 주문량 경고
	
	let pro_ware_qty = $("#pro_ware_qty_upper").val();
	if(order_qty_upper > pro_ware_qty){
		alert("재고 수량보다 많은 양의 수주량입니다.");
		return
	}

	let seleted_ware_no = $("#ware_name_option option:selected").val();
	
	let shpping_tbody_tr_length = $('#shipping_tbody tr').length;
	
	// 이미 해당 창고에서 주문한 경우
	for(var i = 0 ; i<shpping_tbody_tr_length; i++){

		let existing_ware_no = $("td[id=ware_no]:eq(" + i + ")").text() * 1;
		
		if(seleted_ware_no == existing_ware_no){
			alert("해당 창고에서 이미 수주량을 결정 하셨습니다.")
			return
		}
	}
	
	
	let seleted_ware_name = $("#ware_name_option option:selected").text();
	

	let seleted_pro_no = $("#whInfoData").find('.'+seleted_ware_no).children('.wb_pro_no').val();
	let seleted_pro_name = $("#whInfoData").find('.'+seleted_ware_no).children('.wb_pro_name').val();
	
	var seleted_shpping_master_name = $("#whInfoData").find('.'+seleted_ware_no).children('.wb_name').val();
	// alert(seleted_ware_name);
	
	
	let html = "<tr>" +"<td id='ware_no'>"+seleted_ware_no+"</td>"+
	"<td id='ware_name'>"+seleted_ware_name+"</td>"+
	"<td id='pro_no'>"+seleted_pro_no+"</td>"+
	"<td id='pro_name'>"+seleted_pro_name+"</td>"+
	"<td id='shpping_qty'>"+order_qty_upper+"</td>"+
	"<td id='shpping_master_name'>"+seleted_shpping_master_name+"</td>"+
	"<td><a class='btnType gray' id='deleteShppingBtn' name='deleteShppingBtn'><span>삭제</span></a></td></tr>"
	;
	
	$("#shipping_tbody").append(html);
	
	
	$('a[name=deleteShppingBtn]').click(function(e) {
		e.preventDefault();
		
		let this_order_qty = $(this).parent().parent().children().eq(4).text() * 1;
		
		let order_qty = $("#order_qty").text() * 1;
		
		$("#order_qty").text(this_order_qty + order_qty);
		
		alert(this_order_qty);
		
		$(this).parent().parent().remove();
	});
	
	// 주문 개수 입력 란 비워 주기
	$("#order_qty_upper").val('');
	
	// 재고 개수 겉값 변경
	$("#pro_ware_qty_upper").val(pro_ware_qty - order_qty_upper);
	
	// 주문개수 - 수주개수 해주기
	let changed_order_qty = order_qty - order_qty_upper;
	
	$("#order_qty").text(changed_order_qty);
	
	
}

function fShippingDone(){
	
	let left_order_qty = $("#order_qty").text() * 1;
	
	if(left_order_qty!=0){
		alert("처리 되지 않은 주문이 남았습니다.");
		return
	}

	let shipping_body_length = $("#shipping_tbody tr").length * 1;
	
	var shippingDirectionList = new Array(shipping_body_length);
	
	var ware_no = 1;
	var pro_no = 1;
	var ship_qty = 1;
	var deli_master_name = 1;
	var order_no = $("#order_no").text();
	
	
	
	var test = {
			
			order_no : order_no,
			ware_no : ware_no,
			pro_no : pro_no,
			ship_qty : ship_qty,
			deli_master_name : deli_master_name
	};

	
	
	for(let i = 0; i < shipping_body_length; i++){
		ware_no = $("#shipping_tbody").children().eq(i).children().eq(0).text();
		pro_no = $("#shipping_tbody").children().eq(i).children().eq(2).text();
		ship_qty = $("#shipping_tbody").children().eq(i).children().eq(4).text();
		deli_master_name = $("#shipping_tbody").children().eq(i).children().eq(5).text();
		
		var shippingDirectionDTO = {
				order_no : order_no,
				ware_no : ware_no,
				pro_no : pro_no,
				ship_qty : ship_qty,
				deli_master_name : deli_master_name
		};
		
		shippingDirectionList[i] = shippingDirectionDTO;
		
		console.log(i+"번째 : "+" ware_no : " + ware_no + " pro_no : " + pro_no + 
				" ship_qty : " + ship_qty + " deli_master_name : " + deli_master_name + " order_no : " + order_no);
	}
	
	alert(shippingDirectionList[0].deli_master_name);
	
	
	var resultCallback = function(data) {
		const result = data.result;
		if(result == 'SUCCESS'){
			alert(data.msg);
			
			
			fListDailyOrderHistroy();
			
			gfCloseModal();
		} else if(result =='FAIL'){
			alert(data.msg);
		}
	};
	
	let url = "/scm/dailyOrderHistory.do/shipdirection";
	
	
	$.ajax({
        url: url,
        contentType: 'application/json',
        dataType: "json", //json 형태의 타입
        data: JSON.stringify(shippingDirectionList),
        type: "POST",
        success: function(data){
        	resultCallback(data);
        },
        error: function(xhr, status, error){
            console.log("xhr:"+xhr+", status:"+ status + ", error:"+error);
        }
});
	
	//callAjax(url, "post", "json", true, shippingDirectionList, resultCallback);
	
	
}

function fCheckRefundClickEvent(currentPage){

	currentPage = currentPage || 1;
	
	$("#refundCheck").change(
			function() {
				if ($("#refundCheck").is(":checked")) {
					let url ="/scm/orders/refund";
					var param = {
						currentPage : currentPage,
						pageSize : pageSizeDailyOrder
					}
					var resultCallback = function(data) {
						flistDailyOrderHistroyResult(data, currentPage);
					};
					callAjax(url, "get", "text", true, param, resultCallback);

				} else {
					let url = "/scm/orders/dailyOrder";
					var param = {
						currentPage : currentPage,
						pageSize : userPageSize,
						del_cd : del_cd.toString()
					}

					var resultCallback = function(data) {
						flistDailyOrderHistroyResult(data, currentPage);
					};

					callAjax(url, "post", "text", true, param, resultCallback);
				}
			});
}




















/** 그룹코드 저장 validation */
function fValidateGrpCod() {

  var chk = checkNotEmpty(
    [
      ["grp_cod", "그룹 코드를 입력해 주세요."],
      ["grp_cod_nm", "그룹 코드 명을 입력해 주세요"],
      ["grp_cod_eplti", "그룹 코드 설명을 입력해 주세요."]
    ]);
  if (!chk) {
    return;
  }
  return true;
}


/** 그룹코드 저장 */
function fSaveGrpCod() {

  // vaildation 체크
  if (!fValidateGrpCod())  {
    return;
  }

  var resultCallback = function(data) {
    fSaveDailyOrderHistoryResult(data);
  };

  callAjax("/system/saveComnGrpCod.do", "get", "json", true, $("#myForm").serialize(), resultCallback);
}


/** 그룹코드 저장 콜백 함수 */
function fSaveDailyOrderHistoryResult(data) {

  // 목록 조회 페이지 번호
  var currentPage = "1";
  if ($("#action").val() != "I") {
    currentPage = $("#currentPageDailyOrder").val();
  }

  if (data.result == "SUCCESS") {

    // 응답 메시지 출력
    alert(data.resultMsg);

    // 모달 닫기
    gfCloseModal();

    // 목록 조회
    fListDailyOrderHistroy(currentPage);

  } else {
    // 오류 응답 메시지 출력
    alert(data.resultMsg);
  }

  // 입력폼 초기화
  fInitFormDiailyOrderHistory();
}


/** 그룹코드 삭제 */
function fDeleteDailyOrderHistroy() {

  var resultCallback = function(data) {
    fDeleteDailyOrderHistroyResult(data);
  };

  callAjax("/system/deleteComnGrpCod.do", "post", "json", true, $("#myForm").serialize(), resultCallback);
}


/** 그룹코드 삭제 콜백 함수 */
function fDeleteDailyOrderHistroyResult(data) {

  var currentPage = $("#currentPageDailyOrder").val();

  if (data.result == "SUCCESS") {

    // 응답 메시지 출력
    alert(data.resultMsg);

    // 모달 닫기
    gfCloseModal();

    // 일별수주 목록 조회
    fListDailyOrderHistroy(currentPage);

  } else {
    alert(data.resultMsg);
  }
}
