<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ include file="/WEB-INF/common/common.jsp"%>



<!DOCTYPE html>
<html>
<head>

<title>결제 페이지</title>

<script type="text/javascript"src="https://cdn.iamport.kr/js/iamport.payment-1.1.5.js"></script>
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
	<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
	<link rel="stylesheet" href="https://www.w3schools.com/w3css/4/w3.css">
<%
    
      
        int offset = 2; //오프 셋
        int content = twelve - 2 * offset; //12 - 2 * 오프셋
    %>
    <script type="text/javascript">
         var coupon_no; 

        function sendaddshipping() {
            new daum.Postcode({
                oncomplete: function (data) {
                    // 팝업에서 검색결과 항목을 클릭했을때 실행할 코드를 작성하는 부분.

                    // 도로명 주소의 노출 규칙에 따라 주소를 표시한다.
                    // 내려오는 변수가 값이 없는 경우엔 공백('')값을 가지므로, 이를 참고하여 분기 한다.
                    var roadAddr = data.roadAddress; // 도로명 주소 변수
                    var extraRoadAddr = ''; // 참고 항목 변수

                    // 법정동명이 있을 경우 추가한다. (법정리는 제외)
                    // 법정동의 경우 마지막 문자가 "동/로/가"로 끝난다.
                    if (data.bname !== '' && /[동|로|가]$/g.test(data.bname)) {
                        extraRoadAddr += data.bname;
                    }
                    // 건물명이 있고, 공동주택일 경우 추가한다.
                    if (data.buildingName !== '' && data.apartment === 'Y') {
                        extraRoadAddr += (extraRoadAddr !== '' ? ', ' + data.buildingName : data.buildingName);
                    }
                    // 표시할 참고항목이 있을 경우, 괄호까지 추가한 최종 문자열을 만든다.
                    if (extraRoadAddr !== '') {
                        extraRoadAddr = ' (' + extraRoadAddr + ')';
                    }

                    // 우편번호와 주소 정보를 해당 필드에 넣는다.
                    document.getElementById('sample4_postcode').value = data.zonecode;
                    document.getElementById("sample4_roadAddress").value = roadAddr;
                    document.getElementById("sample4_jibunAddress").value = data.jibunAddress;

                    // 참고항목 문자열이 있을 경우 해당 필드에 넣는다.
                    if (roadAddr !== '') {
                        document.getElementById("sample4_extraAddress").value = extraRoadAddr;
                    } else {
                        document.getElementById("sample4_extraAddress").value = '';
                    }

                    var guideTextBox = document.getElementById("guide");
                    // 사용자가 '선택 안함'을 클릭한 경우, 예상 주소라는 표시를 해준다.
                    if (data.autoRoadAddress) {
                        var expRoadAddr = data.autoRoadAddress + extraRoadAddr;
                        guideTextBox.innerHTML = '(예상 도로명 주소 : ' + expRoadAddr + ')';
                        guideTextBox.style.display = 'block';

                    } else if (data.autoJibunAddress) {
                        var expJibunAddr = data.autoJibunAddress;
                        guideTextBox.innerHTML = '(예상 지번 주소 : ' + expJibunAddr + ')';
                        guideTextBox.style.display = 'block';
                    } else {
                        guideTextBox.innerHTML = '';
                        guideTextBox.style.display = 'none';
                    }
                }
            }).open();
        }

         $(document).ready(function () {

            var productname = "${param.productname}";
            console.log(productname);
            $("[name=addrlist]").click(function (e) {
                $("#addrshippname").text($(this).children('.shippingname').text());
                $("#addrname").text($(this).children('.payee').text());
                $("#addrtext").text($(this).children('.address1n2').text());
                $("#seq_addr").text($(this).children('.seq_add').text());
                $("#exampleModal").modal('hide');
            });
            $("[name=couponselect]").click(function (e) {
                var couponchoice = $(this).text();
                coupon_no = $(this).children('.coupon_no').text();
                var kind = $(this).data("kind");
                $(this).children('.coupon_no').text("");
                $("#coupontext").text($(this).text());

                if ("${param.buyCount}" != "") {
                    if (kind == 2) { //무료배송
                        var total = parseInt("${totalprice}").format();
                        console.log(total);
                        $("#shippingfee").text(0 + "원");
                        $("#totalprice").text(total + "원");

                    } else {
                        var total = parseInt("${totalprice}").format();
                        var discount = parseFloat($(this).data("discount")).toFixed(1);
                        if (${requestScope.totalprice<=50000}) {
                            $("#shippingfee").text("2,500원");
                        }
                        $("#totalprice").text((total - (total * discount) + 2500) + "원");
                        console.log(total);
                        console.log(total * discount)
                    }
                } else {
                    if (kind == 2) { //무료배송
                        var total = parseInt("${totalprice}").format();
                        $("#shippingfee").text(0 + "원");
                        $("#totalprice").text(total + "원");
                    } else {
                        var total = parseInt("${totalprice}") // 정기구독 곱한 총가격
                        var discount = parseFloat($(this).data("discount")).toFixed(1); //할인율
                        if (${requestScope.totalprice<=50000}) {
                            $("#shippingfee").text("2,500원");
                        }// 배송비
                        $("#totalprice").text(parseInt(total - (total * discount) + 2500).format() + "원"); // 총 결제 금액
                    }
                }
                $("#couponselectbtn").modal('hide');

            });
        }); 
    </script>
    <style type="text/css">
        #payinfotable th {
            font-weight: bold;
            padding: 7px 10px 7px 15px;
        }

        #paymemberinfo th {
            padding: 7px 10px 7px 15px;
        }

        #deliverytable th {
            padding: 7px 10px 7px 15px;
        }

        a {
            text-decoration: none;
        }
        .btn-primary {
    /* color: #fff; */
  			 background-color: #522772;
   			 border-color: #522772;
		}
		.btn-warning {
   			color: #fff;
    		background-color: #522772;
    		border-color: #522772;
		}

		element.style {
    		font-weight: bolder;
    		background-color: #522772;
    		color: white;
		}
    </style>
</head>
<body>
<!-- <div class="modal fade" id="couponselectbtn" data-bs-backdrop="static"
     data-bs-keyboard="false" tabindex="-1"
     aria-labelledby="staticBackdropLabel" aria-hidden="true"> -->
   <%--  <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="staticBackdropLabel">적용하실 쿠폰을 선택해주세요.</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <div class="list-group">
                    <c:forEach items="${coupons}" var="coupon">
                        <button type="button" class="list-group-item list-group-item-action" aria-current="true"
                                data-kind="${coupon.kind}" data-discount="${coupon.discount}" name="couponselect">
                            <c:if test="${coupon.kind==1}">
                                (할인쿠폰)
                            </c:if>
                            <c:if test="${coupon.kind==2}">
                                (배송비할인)
                            </c:if>
                            <span>${coupon.name}</span>
                            <c:if test="${coupon.kind==1}">
                                <span><fmt:formatNumber type="percent" maxIntegerDigits="3"
                                                        value="${coupon.discount}"></fmt:formatNumber></span>
                            </c:if>
                            <c:if test="${coupon.kind==2}">
                                배송비 전액
                            </c:if>
                            <span class="coupon_no" style="display:none">${coupon.no}</span>
                        </button>
                    </c:forEach>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">닫기</button>
            </div>
        </div>
    </div> --%>
<!-- </div> -->
<div class="modal fade" id="exampleModal" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-scrollable">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="exampleModalLabel">배송지를 선택해주세요.</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <div class="list-group">
                    <c:forEach items="${addressList}" var="addr">
                        <button type="button" class="list-group-item list-group-item-action" aria-current="true"
                                name="addrlist">
                            <span class="shippingname">${addr.shippingname}</span> / <span
                                class="payee">${addr.name}</span>
                            <span class="address1n2">${addr.address1}</span><span class="seq_add"
                                                                                  type="hidden">${addr.seq_add}</span>
                        </button>
                    </c:forEach>
                </div>
            </div>
        </div>
    </div>
</div>
<div class="modal fade" id="addshipping" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-scrollable">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="exampleModalLabel">신규 배송지를 추가해주세요.</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <form method="post" action="<%=YesForm%>?command=paymentaddaddr">
                    <input type="hidden" name="mid" value="${loginfo.mid}">
                    <input type="hidden" name="phone" value="${loginfo.phone}">
                    <c:if test="${requestScope.regular==1}">
                        <input type="hidden" name="productcode" value="${productRLists.get(0).getProductcode()}">
                        <input type="hidden" name="directbuy" value="${directbuy}">
                        <input type="hidden" name="months" value="${productRLists.get(0).getMonths()}">
                        <input type="hidden" name="regular" value="1">
                    </c:if>
                    <c:if test="${requestScope.regular==-1}">
                        <input type="hidden" name="productcode" value="${productLists.get(0).getProductcode()}">
                        <input type="hidden" name="directbuy" value="${directbuy}">
                        <input type="hidden" name="qty" value="${productLists.get(0).getQty()}">
                        <input type="hidden" name="regular" value="-1">
                    </c:if>
                    <div class="input-group mb-3">
                        <input type="text" name="shippingname" class="form-control" placeholder="배송지 이름"
                               aria-label="배송지 이름" aria-describedby="basic-addon2">
                    </div>
                    <div class="input-group mb-3">
                        <input type="text" name="name" class="form-control" placeholder="수취인" aria-label="수취인"
                               aria-describedby="basic-addon2">
                    </div>
                    <div class="input-group mb-3">
                        <input type="text" id="sample4_postcode" class="form-control" placeholder="우편번호"
                               aria-label="우편번호" aria-describedby="basic-addon2">
                        <button type="button" class="input-group-text" id="basic-addon2" onclick="sendaddshipping()">
                            우편번호 찾기
                        </button>
                    </div>
                    <div class="input-group mb-3">
                        <input type="text" class="form-control" name="sample4_roadAddress" id="sample4_roadAddress"
                               placeholder="도로명주소" aria-label="도로명주소" aria-describedby="basic-addon1">
                    </div>
                    <div class="input-group mb-3">
                        <input type="text" class="form-control" name="sample4_jibunAddress" id="sample4_jibunAddress"
                               placeholder="지번주소" aria-label="지번주소" aria-describedby="basic-addon1">
                    </div>
                    <div class="input-group mb-3">
                        <input type="text" class="form-control" id="sample4_extraAddress" placeholder="참고항목"
                               aria-label="참고항목" aria-describedby="basic-addon1">
                    </div>
                    <div class="input-group mb-3">
                        <input type="text" class="form-control" id="sample4_detailAddress" placeholder="상세주소"
                               aria-label="상세주소" aria-describedby="basic-addon1">
                    </div>
                    <div class="row">
                        <div class="col">
                        </div>
                        <div class="col">
                            <button type="submit" class="btn btn-primary">추가하기</button>
                        </div>
                        <div class="col">
                        </div>
                    </div>
                </form>
                <span id="guide" style="color:#999;display:none"></span>
            </div>
        </div>
    </div>
</div>
<div class="container col-md-offset-<%=offset%> col-md-<%=content%>" style="padding-bottom: 10%; width: 40%;">
    <div class="ordTitle">
        <!-- <h1>주문/결제</h1> -->
        <hr style="border:none; border: 1px double #522772; width: 100%;">
        <div align="right" style="color: blue">주문결제 >
            <span style="color: black;">"주문완료"</span>
        </div>
    </div>
    <div data-component="customerinfo">
        <div class="customer_h2">
            <h3 style="margin-left: 200px;" class="col-md-3">구매자 정보</h3>
            <hr>
            <table id="paymemberinfo"
                   style="padding: 10px 0px 10px 16px; font: 12px 돋움, Dotum, sans-werif; white-space: nowrap; width: 100%;">
                <tr align="center">
                    <th style="background: #f0f0f5; font-weight: bold;">이름
                    </th>
                    <td align="center"><span id="userName">${sessionScope.loginfo.name}</span>(${sessionScope.loginfo.mid})님
                    </td>
                </tr>
                <tr align="center">
                    <th style="background: #f0f0f5; font-weight: bold;">휴대폰 번호</th>
                    <td class="col-md-4">
                        <input type="text" id="phone" name="phone" value="${sessionScope.loginfo.phone}">
                    </td>
                    <td class="col-md-4">
						<a href="http://localhost:8989<%=contextPath%>/modify.me?mid=${sessionScope.loginfo.mid}">
	                        <button type="button" class="btn btn-warning btn-sm">
	                            수정
	                        </button>    
                        </a>
                    </td>
                </tr>
            </table>
        </div>
    </div>
    <hr>
    <div data-component="deleveryaddress">
        <div>
            <h3 style="padding: 0px 0px 0px 2px; margin: 30px 0px 8px; margin-left: 200px;">받는사람 정보
                <span>
                    <button type="button" data-bs-toggle="modal" data-bs-target="#exampleModal" id="shippingchange"
                            class="btn btn-outline-primary btn-sm"
                            style="margin: 0px 0px 0px 5px; padding: 4px 8px; font: 11px 돋움, Dotum, sans-serif;">
                            배송지 변경
                    </button>
                    <button type="button" data-bs-toggle="modal" data-bs-target="#addshipping"
                            class="btn btn-outline-primary "
                            style="margin: 0px 0px 0px 5px; padding: 4px 8px; font: 11px 돋움, Dotum, sans-serif;">
                            신규 배송지 추가
                    </button>
                </span>
            </h3>
            <hr>
            <table id="deliverytable"
                   style="padding: 10px 0px 10px 16px; font: 12px 돋움, Dotum, sans-werif; white-space: nowrap; width: 100%;">
                <tbody>
                <!--<tr align="center">
                    <th style="background: #f0f0f5; font-weight: bold;">배송지 이름</th>
                    <td align="center" id="addrshippname">${requestScope.address.shippingname}</td>
                </tr> -->
                <tr align="center">
                    <th style="background: #f0f0f5; font-weight: bold;">수령인</th>
                    <td align="center" id="addrname">${sessionScope.loginfo.name}</td>
                </tr>
                <tr align="center">
                    <th style="background: #f0f0f5; font-weight: bold;">배송주소</th>
                    <td align="center" id="addrtext">${sessionScope.loginfo.address1} ${sessionScope.loginfo.address2}</td>
                </tr>
                <tr align="center">
                    <th style="background: #f0f0f5; font-weight: bold;">연락처</th>
                    <td align="center">${sessionScope.loginfo.phone}</td>
                </tr>
                <tr style="display: none">
                    <td id="seq_addr">${address.seq_add}</td>
                </tr>
                </tbody>
            </table>
        </div>
        <div style="margin: 8px 0px 0px; font:12px 돋움, Dotum, sans-serif;">
            <hr style="border: none;">
            <div style="padding: 10px 15px 10px 20px; background: #EEEEEE;">
                <strong>3/9</strong>
                <span>도착 예정</span>
            </div>
            <hr style="border: none;">
            <div>
                    <table>
                       <c:forEach items="${sessionScope.shoplists}" var="shopinfo">
                            <tr>
                                <td>
                                   <img src="<%=contextPath%>/resources/assets/img/products/${shopinfo.pimg}"
                                                                     alt="" width="70" class="img-fluid rounded shadow-sm">
                                </td>
                                <td>
                                    <span style="padding-left:0px; font-size: 25px; color: blue;">${shopinfo.productname}</span>
                                </td>
                            </tr>
                        </c:forEach>
                    </table>
                
                    <table>
                            <tr style="border-right 100px;">
                                <td>
                                    <img src="<%=contextPath%>/resources/assets/img/products/비스테까 티라미슈.jpg"
                                                                     alt="" width="150" height="70" align="middle" class="img-fluid rounded shadow-sm">
                                </td>
                                <td id="product_lists">
                                    <span style="padding-left: 0px; font-size: 25px; color: blue;">${shopinfo.productname}</span>
                                </td>
                                <td id="product_lists2">
                                    <span class="col-md-10"
                                          style="margin-bottom:10px; margin-left: 150px; font-size: 25px; color: #522772"><%=1 %> 개</span>
                                </td>
                            </tr>
                       <%--  </c:forEach> --%>
                    </table>
               
                <p align="right"><span id="monthVal"
                                       style="font-weight: bolder; background-color: #522772; color: white;">상품 <%=1 %> 종류 </span>
                </p>
            </div>
            <hr>
            <div>

            </div>
        </div>
        <div>
            <h3 align="center">결제 정보</h3>
            <hr>
        </div>
        
            <input type="hidden" name="command" value="paymentval">
            <table id="payinfotable" style="margin: 8px 0px 0px; font:12px 돋움, Dotum, sans-serif;">
                <tbody align="center">
                <tr align="center">
                    <th>총 상품가격</th>
                      <c:choose>
                        <c:when test="${sessionScope.totalprice>20000}">
                            <td id="totalprice"><fmt:formatNumber value="${sessionScope.totalprice}"
                                                                  pattern="#,###"/>원
                            </td>
                        </c:when>
                        <c:otherwise>
                            <td id="totalprice"><fmt:formatNumber value="${sessionScope.disTotalPrice}"
                                                                  pattern="#,###"/>원
                            </td>
                        </c:otherwise>
                    </c:choose>
                </tr>
              <%--   <tr align="center">
                    <th>할인 쿠폰</th>
                    <td align="center" id="coupontext">
                        <c:if test="${couponitem.name==null}">s
                            쿠폰 미적용
                        </c:if>
                        <c:if test="${couponitem.name!=null}">
                            ${couponitem.name}
                        </c:if>
                    </td>
                    <!-- <td>
                        <button style="float: right; font: 10px;" type="button"
                                class="btn btn-warning btn-sm" data-bs-toggle="modal" data-bs-target="#couponselectbtn">
                            <span>쿠폰 선택</span>
                        </button>
                    </td> -->
                </tr> --%>
              <%--   <tr align="center">
                    <th>배송비</th>
                    <td id="shippingfee">
                        <c:choose>
                            <c:when test="${sessionScope.totalprice>50000}">
                                <fmt:formatNumber value="0" pattern="#,###"/>원
                            </c:when>
                            <c:otherwise>
                                <fmt:formatNumber value="2500" pattern="#,###"/>원
                            </c:otherwise>
                        </c:choose>
                    </td>
                </tr> --%>
               <!--  <tr align="center">
                    <th>도담도담 캐시</th>
                    <td>0원</td>
                </tr> -->
                <tr align="center">
                    <th>총 결제금액</th>
                    <c:choose>
                        <c:when test="${sessionScope.totalprice>20000}">
                            <td id="totalprice"><fmt:formatNumber value="${sessionScope.totalprice}"
                                                                  pattern="#,###"/>원
                            </td>
                        </c:when>
                        <c:otherwise>
                            <td id="totalprice"><fmt:formatNumber value="${sessionScope.disTotalPrice}"
                                                                  pattern="#,###"/>원
                            </td>
                        </c:otherwise>
                    </c:choose>
                </tr>

                <tr align="center">
                    <th>결제방법</th>
                    <td style="padding: 4px 0px 0px; float: right;">
                        <input type="radio" name="pymnt" value="card" checked>&nbsp;신용/체크카드
                        <input id="virtualaccount" type="radio" name="pymnt" value="banktrnsf">&nbsp;무통장입금(가상계좌)
                        <div align="center">
                            <input id="agreecheck" type="checkbox" checked="checked">&nbsp;선택한 결제수단으로 향후 결제 이용에
                            동의합니다(선택)
                        </div>
                    </td>
                </tr>
                </tbody>
            </table>
        </form>
    </div>
    <br><br><br>
    <div style="margin: 0px 0px 10px; font:12px 돋움, Dotum, sans-serif;">
        <div>
            <span>개인정보 제공안내</span>
            <a onfocus="blur()" onclick="this.innerHTML=(this.nextSibling.style.display=='none')?'[닫기]':'[열기]';
				 this.nextSibling.style.display=(this.nextSibling.style.display=='none')?'block':'none';"
               href="javascript:void(0)";>[열기]</a>
            <div style="DISPLAY: none">
                <div class="agreements__content " data-agreements-content=""
                     style="display: block;">
                    <table class="agreements__content__table">
                        <thead>
                        <tr>
                            <th class="agreements__content__th" width="24%">제공받는자</th>
                            <th class="agreements__content__th" width="24%">제공목적</th>
                            <th class="agreements__content__th" width="24%">제공정보</th>
                            <th class="agreements__content__th">보유 및 이용기간</th>
                        </tr>
                        </thead>
                        <tbody>
                        <tr>
                            <td class="agreements__content__td"><span
                                    class="agreements__content__td__em"
                                    style="word-break: break-all">소니바리</span></td>
                            <td class="agreements__content__td"><span
                                    class="agreements__content__td__em">서비스 제공, 사은행사,
											구매자확인, 해피콜</span></td>
                            <td class="agreements__content__td">성명, 휴대전화번호(또는 안심번호),
                                배송지주소, 이메일<br>※ 구매자와 수취인이 다를 경우에는 수취인의 정보(해외 배송 상품은
                                개인통관고유부호 포함)가 제공될 수 있습니다.
                            </td>
                            <td class="agreements__content__td"><span
                                    class="agreements__content__td__em">재화 또는 서비스의 제공 목적이
											달성 된 후 파기</span> (단, 관계법령에 정해진 규정에 따라 법정기간 동안 보관)
                            </td>
                        </tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
        <br>
    </div>
    <div style="margin: 0px 0px 10px; font:12px 돋움, Dotum, sans-serif;">
        <div>
            <span>구매조건 확인 및 결제대행 서비스 약관 동의</span>
            <a onfocus="blur()" onclick="this.innerHTML=(this.nextSibling.style.display=='none')?'[닫기]':'[열기]';
				 this.nextSibling.style.display=(this.nextSibling.style.display=='none')?'block':'none';"
               href="javascript:void(0)" ;>[열기]</a>
            <div style="DISPLAY: none">

                <li>
                    ② 관련법령에 의한 정보보유
                    <br>
                    상법, 전자상거래 등에서의 소비자보호에 관한 법률, 전자금융거래법 등 관련법령의 규정에 의하여 보존할 필요가 있는 경우 회사는 관련법령에서 정한 일정한 기간 동안 정보를
                    보관합니다. 이 경우 회사는 보관하는 정보를 그 보관의 목적으로만 이용하며 보존기간은 아래와 같습니다.
                    <ol>
                        <li>1) 계약 또는 청약철회 등에 관한 기록 : 보존기간: 5년 / 보존근거: 전자상거래 등에서의 소비자보호에 관한 법률</li>
                        <li>2) 대금결제 및 재화 등의 공급에 관한 기록 : 보존기간: 5년 / 보존근거: 전자상거래 등에서의 소비자보호에 관한 법률 (단, 건당 거래 금액이 1만원 이하의
                            경우에는 1년간 보존 합니다).
                        </li>
                        <li>3) 소비자의 불만 또는 분쟁처리에 관한 기록 : 보존기간: 3년 / 보존근거: 전자상거래 등에서의 소비자보호에 관한 법률</li>
                        <li>4) 전자금융거래에 관한 기록 : 보존기간: 5년 / 보존근거: 전자금융거래법</li>
                        <li>5) 방문에 관한 기록 : 보존기간: 3개월 / 보존근거: 통신비밀보호법</li>
                    </ol>
                </li>
            </div>
        </div>
        <br>
    </div>
    <div style="margin: 10px 0px 0px; font:12px 돋움, Dotum, sans-serif;">
        <p>
            * 개별 판매자가 등록한 마켓플레이스(오픈마켓) 상품에 대한 광고, 상품주문, 배송 및 환불의 의무와 책임은 각 판매자가 부담하고, 이에 대하여 쿠팡은 통신판매중개자로서 통신판매의 당사자가
            아니므로 일체 책임을 지지 않습니다.
        </p><br>
    </div>
    <div align="center" style="margin: 15px 0px; font:12px 돋움, Dotum, sans-serif; ">
        위 주문 내용을 확인 하였으며, 회원 본인은 결제에 동의합니다.<br>
    </div>
    <div align="center">
        <button class="btn btn-primary" type="button" onclick="requestPay()">결제 하기</button>
    </div>
</div>
<script>
  
    IMP.init("imp38748327"); // "imp00000000" 대신 발급받은 "가맹점 식별코드"를 사용합니다.
    function requestPay() {
        if ($("#agreecheck").is(":checked") == false) {
            alert('결제 이용 동의를 선택해주세요.');
            return false;
        }
        if ($("#virtualaccount").is(":checked") == true) {
        	var totalprice = parseInt($("#totalprice").text().replace(",", "").replace("원", ""));
        	location.href = "/controller/payprogress.pm?totalprice="+totalprice;
            return false;
        }
        var obj = document.getElementsByName("momentum"); 
        if (obj.value == "banktrnsf") {
            // 여기에 나중에 계좌이체로 처리할 페이지로 이동하게끔 유도
        }
        //var shoplists = JSON.stringify(lists); // 이 list가 어디있죠 ? 저도 몰라요 ...아마도 왼ㅉ목에 새로 만들어야 할 것 같은... ㅠ
        // IMP.request_pay(param, callback) 호출
        var today = new Date();
        var merchant_uid = today.getMonth() + "" + today.getDate() + "" + today.getHours() + "" + today.getMinutes() + "" + today.getSeconds();
        var email ="";
        var p_name = $("#userName").text();
        var totalprice = parseInt($("#totalprice").text().replace(",", "").replace("원", ""));
        var b_name = $("#userName").text();
        var b_tel = $("#phone").val();
        var b_addr = $("#addrtext").text();
        
        IMP.request_pay({ // param
            pg: "html5_inicis",
            pay_method: "card",
            merchant_uid: merchant_uid,
            buyer_email: email,
            name: p_name,
            amount: totalprice,
            buyer_name: b_name,
            buyer_tel: b_tel,
            buyer_addr: b_addr,
        }, function (rsp) { // callback
        	
        	console.log("실행1");
        	
            if (rsp.success) { // 결제 성공 시: 결제 승인 또는 가상계좌 발급에 성공한 경우
            	
            	console.log("결제 성공!!!!!!!");
            	
            
            	//location.href = "/test.pm?
            	location.href = "http://localhost:8989/controller/test.pm";
            
            	/* 
            	    - 상품결제 성공 비지니스로직 구현
            		- 컨트롤러에 필요정보를 담아서 보낸다.(ex: 상품명, 고객정보(주소,연락처), 재고수량 등등)
            		- 컨트롤러 왔으면 service 호출하고 dao 호출하고 db 저장한다.
            		- db 까지 저장 성공했으면 상품 결제 완료 페이지로 이동
            	*/
            
            	
            
            } else {
                alert("결제에 실패하였습니다. 에러내용!: " + rsp.error_msg);
                console.log("결제 실패입니다.");
            }
        });
    }

    Number.prototype.format = function () {
        if (this == 0) return 0;

        var reg = /(^[+-]?\d+)(\d{3})/;
        var n = (this + '');

        while (reg.test(n)) n = n.replace(reg, '$1' + ',' + '$2');

        return n;
    };
    String.prototype.format = function () {
        var num = parseFloat(this);
        if (isNaN(num)) return "0";

        return num.format();
    };
</script>

</body>
</html>