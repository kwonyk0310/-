<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
 <%@ include file="/WEB-INF/common/common.jsp" %>  
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Shopping Cart</title>
	<script type="text/javascript">


    </script>
    <style>
	    body{
	    	padding-bottom: 50px;
	    }
        .nodiscount{
            position: relative;
            right: 71px;
            bottom: 20px;
        }
        .red{
        	font: red;
        }
        .btn {
		    height: 50px;
		    margin: 5px;
		}
		.text-center {
  			text-align: center!important;
		}
		.pb-5, .py-5 {
		    padding-bottom: 1rem!important;
		}
		.pt-5, .py-5 {
		    padding-top: 2rem!important;
		}
		.p-5 {
   			padding: 2rem!important;
		}
		h5, h6 {
		    color: #303030;
		    font-weight: 400;
		    letter-spacing: 0;
		    line-height: 1.35;
		    margin: 0 0 5px;
		}
		input {
			height: 30px;
		    width: 70px;
		}
		.form-inline bnt{
			width: 120px !important;
			height: 50px !important;
		}
		.btn-outline-info:hover {
		    color: #fff;
		    background-color: #D8BFD8;
		    border-color: #8A2BE2;
		}
		.btn-outline-info {
		    color:  #8A2BE2;
		    background-color: transparent;
		    background-image: none;
		    border-color: #8A2BE2;
		    width: 90px !important;
			height: 40px !important;
		}
		
    </style>
</head>
<body id="cartlist_body">
    <div class="px-4 px-lg-0">
        <!-- For demo purpose -->
        <div class="container text-#8B4513 py-5 text-center">
            <h4><i class="fas fa-shopping-cart"></i> Shopping Cart</h4>
        </div>
        <!-- End -->
        <!-- <div class="container"> -->
            <!-- Tab panes -->
                <div id="home" class="container tab-pane active"><br>
                    <div class="pb-5">
                        <div class="container">
                            <div class="row">
                                <div class="col-lg-12 p-5 bg-white rounded shadow-sm mb-5">
                                    <!-- Shopping cart table -->
                                    <div class="table-responsive">
                                        <table class="table">
                                            <thead>
                                            <tr>
                                                <th scope="col" class="border-0 bg-light">
                                                    <div class="p-2 px-3 text-uppercase">Product</div>
                                                </th>
                                                <th scope="col" class="border-0 bg-light">
                                                    <div class="py-2 text-uppercase">Price</div>
                                                </th>
                                                <th scope="col" class="border-0 bg-light">
                                                    <div class="py-2 text-uppercase">Quantity</div>
                                                </th>
                                                <th scope="col" class="border-0 bg-light">
                                                    <div class="py-2 text-uppercase">Remove</div>
                                                </th>
                                            </tr>
                                            </thead>
                                            <tbody>
                                                <c:forEach items="${sessionScope.shoplists}" var="shopinfo">
                                                    <tr>
                                                        <th scope="row" class="border-0">
                                                            <div class="p-2">
                                                                <img src="<%=contextPath%>/resources/assets/img/products/${shopinfo.pimg}"
                                                                     alt="" width="70" class="img-fluid rounded shadow-sm">
                                                                <div class="ml-3 d-inline-block align-middle">
                                                                    <h5 class="mb-0"><a href="<%=contextPath%>/pdetail.pr?pno=${shopinfo.productcode}"
                                                                                        class="text-dark d-inline-block align-middle">
                                                                            ${shopinfo.productname}</a></h5>
                                                                    <span class="text-muted font-weight-normal font-italic d-block">Category: Watches</span>
                                                                </div>
                                                            </div>
                                                        </th>
                                                        <td class="border-0 align-middle">
                                                            <span class="text-danger mr-1 ">
                                                                <strong><fmt:formatNumber value="${shopinfo.price *(1-shopinfo.discount)}" pattern="###,###"/> ￦</strong>
                                                            </span>
                                                            <span class="text-grey nodiscount"><s>
																<fmt:formatNumber value="${shopinfo.price}" pattern="###,###"/> ￦
                                                            </s></span>
                                                        </td>
                                                        <td class="border-0 align-middle">
                                                        <form class="form-inline" role="form" method="post" action="<%=contextPath%>/modify.mall">
                                                                    <input type="hidden" name="pno" value="${shopinfo.productcode}">
                                                                   <input type="text" name="qty" value="${shopinfo.qty}">
                                                                    <button type="submit"
                                                                            class="btn btn-outline-info btn-sm">수량 변경
                                                                    </button>
                                                                </form>
                                                        
                                                        
                                                        <td class="border-0 align-middle">
                                                            <a href="<%=contextPath%>/delete.mall?pno=${shopinfo.productcode}" type="button"
                                                               class="card-link-secondary small text-uppercase mr-3">
                                                                Delete
                                                            </a>
                                                        </td>
                                                    </tr>
                                                </c:forEach>
                                            </tbody>
                                        </table>
                                    </div>
                                    <!-- End -->
                                </div>
                            </div>
                            <div class="row py-5 p-4 bg-white rounded shadow-sm">
                                
                                
                                <div class="col-lg-6">
                                    <div class="bg-light rounded-pill px-4 py-3 text-uppercase font-weight-bold">
                                           품절 시 대체 물품으로 출고됩니다.
                                    </div>
                                    <div class="p-4">
                                       <!--  <p class="font-italic mb-4">If you have a coupon code, please enter it in the box below</p> -->
                                        <div class="input-group mb-4 border rounded-pill p-2">
                                        	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                        	<a href="<%=contextPath%>/plist.pr">
                                            <button id="button-addon3" type="button" class="btn btn-dark px-4 rounded-pill">
                                            	<i class="fa fa-gift mr-2"></i>쇼핑 더 하기
                                            	</button>
                                            </a>
                                            	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                            <div class="input-group-append border-0">
                                            <a href="<%=contextPath%>/deleteAll.mall">
	                                                <button id="button-addon3" type="submit" class="btn btn-dark px-4 rounded-pill">
	                                                    전체 목록 삭제하기
	                                                </button>
	                                          </a> 
                                            </div> 
                                        </div>
                                    </div>
                                </div>
                                
                                
                                <div class="col-lg-6">
                                    <div class="bg-light rounded-pill px-4 py-3 text-uppercase font-weight-bold">
                                        Order summary
                                    </div>
                                    <div class="p-4">
                                        <p class="font-italic mb-4">총 구매금액이 20,000원 이상 일 경우 배송비가 부과되지 않습니다.</p>
                                        <ul class="list-unstyled mb-4">
                                            <li class="d-flex justify-content-between py-3 border-bottom">
                                                <strong class="text-muted">Pre-discount totalamount </strong>
                                                <strong><fmt:formatNumber value="${sessionScope.totalAmount}" pattern="###,###"/> ￦</strong>
                                            </li>
                                            <li class="d-flex justify-content-between py-3 border-bottom">
                                                <strong class="text-muted">
                                                    <i class='fas fa-shipping-fast'></i>
                                                    Shipping and handling
                                                </strong>
                                                <strong>
                                                    <c:if test="${sessionScope.disTotalPrice >= 20000}">
                                                        <span class="text-grey">
                                                            <s>+ <fmt:formatNumber value="3000" pattern="###,###"/> ￦</s>
                                                        </span>
                                                        ￦<fmt:formatNumber value="0" pattern="###,###"/>
                                                    </c:if>
                                                    <c:if test="${sessionScope.disTotalPrice < 20000}">
                                                        <fmt:formatNumber value="3000" pattern="###,###"/> ￦</c:if>
                                                </strong>
                                            </li>
                                            <li class="d-flex justify-content-between py-3 border-bottom">
                                                <strong class="text-muted">Discount</strong>
                                                <strong class="red"><fmt:formatNumber value="${sessionScope.totalAmount - sessionScope.disTotalPrice}" pattern="###,###"/> ￦</strong>
                                            </li>
                                            <li class="d-flex justify-content-between py-3 border-bottom">
                                                <strong class="text-muted">Total</strong>
                                                <strong>
                                                    <c:if test="${sessionScope.disTotalPrice >= 20000}">
                                                        <h5 class="font-weight-bold"><fmt:formatNumber value="${sessionScope.disTotalPrice}" pattern="###,###"/> ￦</h5>
                                                    </c:if>
                                                    <c:if test="${sessionScope.disTotalPrice < 20000}">
                                                         <h5 class="font-weight-bold"><fmt:formatNumber value="${sessionScope.disTotalPrice + 3000}" pattern="###,###"/> ￦</h5>
                                                    </c:if>
                                                </strong>
                                                <%-- <h5 class="font-weight-bold"><fmt:formatNumber value="${sessionScope.disTotalPrice}" pattern="###,###"/> ￦</h5> --%>
                                            </li>
                                        </ul>
                                       				<c:if test="${whologin == 0}">
														<a href="<%=contextPath%>/login.me" onclick="logincheck()">
															<button type="button" class="btn btn-dark rounded-pill py-2 btn-block"> 주문 하기 </button>
														</a>
													</c:if>
													
													<c:if test="${whologin != 0}">
														<button type="button" class="btn btn-dark rounded-pill py-2 btn-block" onclick="goOrder();"> 주문 하기 </button>
													</c:if>
                                            <!-- <button type="button" class="btn btn-dark rounded-pill py-2 btn-block" onclick="goOrder();"> 주문 하기 </button> -->
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>



	<script type="text/javascript">
	

       function goOrder(){
   	   
 
   	   location.href ="payment.pm";

       }


	</script>






</body>
</html>