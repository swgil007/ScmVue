<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>	
							
							<c:if test="${totalProduct eq 0 }">
								<tr>
									<td colspan="9">데이터가 존재하지 않습니다.</td>
								</tr>
							</c:if>

							<c:if test="${totalProduct > 0 }">
							<c:set var="nRow" value="${pageSize*(currentPageProduct-1)}" />	
							<c:forEach items="${listProductModel}" var="list">
									<tr>
										<td>${list.pro_model_no}</td>
										<td>${list.pro_name}</td>
							
										<td>${list.pro_deli_price}</td>
									</tr>
								<c:set var="nRow" value="${nRow + 1}" />
								</c:forEach>
							</c:if>
				
				
				
		
							
							<input type="hidden" id="totalProduct" name="totalProduct" value ="${totalProduct}"/>
										
										