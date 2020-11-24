<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
					

						    
						
							<c:if test="${totalCntlistInf eq 0 }">
								<tr>
									<td colspan="4">데이터가 존재하지 않습니다.</td>
								</tr>
							</c:if>
							
							<c:if test="${totalCntlistInf > 0 }">
								<c:set var="nRow" value="${pageSize*(currentPageInf-1)}" />
								<c:forEach items="${listInf}" var="list">
									<tr>
										<td>${list.inq_no}</td>
										<td><a href="javascript:fPopModalInf('${list.inq_no}')">${list.inq_title}</a></td>
										<td>${list.inq_regdate}</td>
										<td>${list.loginID}</td>
										 <td>${list.answer_cd}</td>
									</tr>									
									<c:set var="nRow" value="${nRow + 1}" />
								</c:forEach>
							</c:if>
							
							<input type="hidden" id="totalCntlistInf" name="totalCntlistInf" value="${totalCntlistInf}"/>