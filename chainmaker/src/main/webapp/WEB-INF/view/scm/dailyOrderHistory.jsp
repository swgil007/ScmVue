<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<title>Chain Maker</title>

<jsp:include page="/WEB-INF/view/common/common_include.jsp"></jsp:include>

<script type="text/javascript">
</script>
<script src="${CTX_PATH}/js/view/scm/dailyOrderHistory/dailyOrder.js"></script>
<script src="${CTX_PATH}/js/view/scm/dailyOrderHistory/dtlOrder.js"></script>

</head>
<body>
	<input type="hidden" id="currentPageDailyOrder" value="1">
	<input type="hidden" id="currentPageComnDtlCod" value="1">
	<input type="hidden" id="tmpGrpCod" value="">
	<input type="hidden" id="tmpGrpCodNm" value="">
	<input type="hidden" name="action" id="action" value="">

	<div id="whInfoData"></div>


	<!-- 모달 배경 -->
	<div id="mask"></div>

	<div id="wrap_area">

		<h2 class="hidden">header 영역</h2>
		<jsp:include page="/WEB-INF/view/common/header.jsp"></jsp:include>

		<h2 class="hidden">컨텐츠 영역</h2>
		<div id="container">
			<ul>
				<li class="lnb">
					<!-- lnb 영역 --> <jsp:include
						page="/WEB-INF/view/common/lnbMenu.jsp"></jsp:include> <!--// lnb 영역 -->
				</li>
				<li class="contents">
					<!-- contents -->
					<h3 class="hidden">contents 영역</h3> <!-- content -->
					<div class="content">

						<p class="Location">
							<a href="#" class="btn_set home">메인으로</a> <a href="#"
								class="btn_nav">거래내역</a> <span class="btn_nav bold">일별 수주
								내역</span> <a href="../scm/dailyOrderHistory.do" class="btn_set refresh">새로고침</a>
						</p>

						<p class="conTitle">
							<span>일별 수주 내역</span> <span class="fr"> 
								<label><input type="checkbox" id="refundCheck" name="refundCheck" value="refund"> 반품 요청 목록 조회</label>  
							</span>
						</p>

						<div class="divComGrpCodList">
							<table class="col">
								<caption>caption</caption>
								<colgroup>
									<col width="5%">
									<col width="12%">
									<col width="10%">
									<col width="15%">
									<col width="6%">
									<col width="8%">
									<col width="7%">
									<col width="8%">
									<col width="6%">
									<col width="12%">
									<col width="9%">
									<col width="7%">
									<col width="7%">
								</colgroup>

								<thead>
									<tr>
										<th scope="col">주문 번호</th>
										<th scope="col">주문 일자</th>
										<th scope="col">고객기업명</th>
										<th scope="col">주문제품명</th>
										<th scope="col">재고 개수</th>
										<th scope="col">공급가</th>
										<th scope="col">주문 개수</th>
										<th scope="col">금액 합계</th>
										<th scope="col">주문구분</th>
										<th scope="col">납품희망날짜</th>
										<th scope="col">입금여부</th>
										<th scope="col">배송지시서 작성</th>
										<th scope="col">발주지시서 작성</th>
									</tr>
								</thead>
								<tbody id="listDailyOrderHistroy"></tbody>
							</table>
						</div>
						<div class="paging_area" id="dailyOrderPagination"></div>


						<div class="paging_area" id="comnDtlCodPagination"></div>

					</div> <!--// content -->

					<h3 class="hidden">풋터 영역</h3> <jsp:include
						page="/WEB-INF/view/common/footer.jsp"></jsp:include>
				</li>
			</ul>
		</div>
	</div>

	<!-- 모달팝업 -->
	<div id="deliDirection" class="layerPop layerType2"
		style="width: 900px;">
		<dl>
			<dt>
				<strong>배송 지시서 작성</strong>
			</dt>
			<dd class="content">
				<!-- s : 여기에 내용입력 -->

				<table class="col">
					<caption>caption</caption>
					<colgroup>
						<col width="8%">
						<col width="14%">
						<col width="10%">
						<col width="18%">
						<col width="6%">
						<col width="8%">
						<col width="6%">
					</colgroup>

					<thead>
						<tr>
							<th scope="col">주문 번호</th>
							<th scope="col">주문 일자</th>
							<th scope="col">고객기업명</th>
							<th scope="col">주문제품명</th>
							<th scope="col">주문 개수</th>
<!-- 							<th scope="col">배송 담당자</th>
							<th scope="col">입금여부</th> -->
						</tr>
					</thead>
					<tbody>

						<tr>
							<td><a type="text" class="inputTxt p100" name="order_no"
								id="order_no" readonly="readonly" /></a></td>
							<td id="order_date"></td>
							<td id="user_company"></td>
							<td id="pro_name"></td>
							<td id="order_qty"></td>
<!-- 							<td id="name"></td>
							<td id="order_cd"></td> -->
						</tr>
					</tbody>
				</table>

				<table class="row">
					<caption>caption</caption>
					<colgroup>
						<col width="15%">
						<col width="10%">
						<col width="10%">
					</colgroup>

					<tbody>
						<tr>
							<th scope="row">창고 선택</th>
							<td><select style="width: 160px" id="ware_name_option"
								name="ware_name_option"
								onchange="fSelectedOptions(this.options[this.selectedIndex].value, ware_name_option)">
							</select></td>

							<th scope="row">재고 개수 <span class="font_red"></span></th>
							<td><input type="text" class="inputTxt p100"
							id="pro_ware_qty_upper" readonly="readonly" /></td>
							<th scope="row">주문 개수 <span class="font_red"></span></th>
							<td><input type="text" class="inputTxt p100"
							id="order_qty_upper" /></td>
							<td>
							<a href="javascript:faddShppingBtn();"
							 class="btnType blue"><span>추가</span></a>
							</td>
						</tr>

					</tbody>
				</table>
				
				<table class="col" id ="shippingDiretionTable">
					<caption>caption</caption>
					<colgroup>
					
						<col width="3%">
						<col width="12%">
						<col width="12%">
						<col width="16%">
						<col width="3%">
						<col width="8%">
						<col width="3%">
					</colgroup>

					<thead>
						<tr>
							<th scope="col">창고번호</th>
							<th scope="col">창고명</th>
							<th scope="col">제품번호</th>
							<th scope="col">제품명</th>
							<th scope="col">수주 개수</th>
							<th scope="col">배송 담당자</th>
							<th scope="col">비고</th>
						</tr>
					</thead>
					<tbody id="shipping_tbody">

						<tr>
							<td id="ware_name"></td>
							<td id="pro_name_bottom"></td>
							<!-- <td id="pro_ware_qty"></td> -->
							<td id="ship_manager_name">
							<td id="ship_qty"></td>
							<td></td>
						</tr>



					</tbody>
				</table>

				<!-- e : 여기에 내용입력 -->

				<div class="btn_areaC mt30">
					<a href="" class="btnType gray" id="shippingDoneBtn" name="btn"><span>완료</span></a>
					<a href="" class="btnType gray" id="btnClose" name="btn"><span>취소</span></a>
				</div>
			</dd>
		</dl>
		<a href="" class="closePop"><span class="hidden">닫기</span></a>
	</div>

	<div id="layer2" class="layerPop layerType2" style="width: 600px;">
		<dl>
			<dt>
				<strong>상세코드 관리</strong>
			</dt>
			<dd class="content">

				<!-- s : 여기에 내용입력 -->

				<table class="row">
					<caption>caption</caption>
					<colgroup>
						<col width="120px">
						<col width="*">
						<col width="120px">
						<col width="*">
					</colgroup>

					<tbody>
						<tr>
							<th scope="row">그룹 코드 ID <span class="font_red">*</span></th>
							<td><input type="text" class="inputTxt p100"
								id="dtl_grp_cod" name="dtl_grp_cod" /></td>
							<th scope="row">그룹 코드 명 <span class="font_red">*</span></th>
							<td><input type="text" class="inputTxt p100"
								id="dtl_grp_cod_nm" name="dtl_grp_cod_nm" /></td>
						</tr>
						<tr>
							<th scope="row">상세 코드 ID <span class="font_red">*</span></th>
							<td><input type="text" class="inputTxt p100" id="dtl_cod"
								name="dtl_cod" /></td>
							<th scope="row">상세 코드 명 <span class="font_red">*</span></th>
							<td><input type="text" class="inputTxt p100" id="dtl_cod_nm"
								name="dtl_cod_nm" /></td>
						</tr>
						<tr>
							<th scope="row">순서</th>
							<td colspan="3"><input type="text" class="inputTxt"
								id="dtl_odr" name="dtl_odr" /></td>
						</tr>
						<tr>
							<th scope="row">코드 설명</th>
							<td colspan="3"><input type="text" class="inputTxt p100"
								id="dtl_cod_eplti" name="dtl_cod_eplti" /></td>
						</tr>
						<tr>
							<th scope="row">임시 필드 01</th>
							<td colspan="3"><input type="text" class="inputTxt p100"
								id="dtl_tmp_fld_01" name="dtl_tmp_fld_01" /></td>
						</tr>
						<tr>
							<th scope="row">임시 필드 02</th>
							<td colspan="3"><input type="text" class="inputTxt p100"
								id="dtl_tmp_fld_02" name="dtl_tmp_fld_02" /></td>
						</tr>
						<tr>
							<th scope="row">임시 필드 03</th>
							<td colspan="3"><input type="text" class="inputTxt p100"
								id="dtl_tmp_fld_03" name="dtl_tmp_fld_03" /></td>
						</tr>
						<tr>
							<th scope="row">임시 필드 04</th>
							<td colspan="3"><input type="text" class="inputTxt p100"
								id="dtl_tmp_fld_04" name="dtl_tmp_fld_04" /></td>
						</tr>
						<tr>
							<th scope="row">사용 유무 <span class="font_red">*</span></th>
							<td colspan="3"><input type="radio" id="dtl_use_poa_1"
								name="dtl_use_poa" value="Y" /> <label for="radio1-1">사용</label>
								&nbsp;&nbsp;&nbsp;&nbsp; <input type="radio" id="dtl_use_poa_2"
								name="dtl_use_poa" value="N" /> <label for="radio1-2">미사용</label></td>
						</tr>
					</tbody>
				</table>

				<!-- e : 여기에 내용입력 -->

				<div class="btn_areaC mt30">
					<a href="" class="btnType blue" id="btnSaveDtlCod" name="btn"><span>저장</span></a>
					<a href="" class="btnType blue" id="btnDeleteDtlCod" name="btn"><span>삭제</span></a>
					<a href="" class="btnType gray" id="btnCloseDtlCod" name="btn"><span>취소</span></a>
				</div>
			</dd>
		</dl>
		<a href="" class="closePop"><span class="hidden">닫기</span></a>
	</div>
	<!--// 모달팝업 -->
</body>
</html>