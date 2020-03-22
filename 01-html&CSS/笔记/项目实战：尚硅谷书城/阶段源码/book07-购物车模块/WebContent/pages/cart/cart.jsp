<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>购物车</title>

<!-- 头部共享信息的引入。包含jquery，base标签，以及css样式 --> 
<%@ include file="/pages/common/header.jsp" %>
<script type="text/javascript">
	$(function(){
		
				// 清空购物车提示
		$("#clearCart").click(function(){
			return confirm("你确定要清空购物车吗?");
		});
		
		
		// 修改商品数量的事件。
		$("a.deleteItem").click(function(){
			// 提示用户是否修改
			var name = $(this).parent().parent().children("td:first").html();
			// 询问用户是否要删除
			return confirm("你确定要删除【" + name + "】吗?");
		});
		
		
		// 修改商品数量的事件。
		$(".updateItem").change(function(){
			// 提示用户是否修改
			var name = $(this).parent().parent().children("td:first").html();
			if ( confirm("你确定修改【" + name + "】个数为：" + this.value) ){
				// 发起请求
				location.href="cartServlet?action=updateItem&id=" + $(this).attr("data") + "&count="+this.value;
			} else {
				// 还原商品数量
				this.value = $(this).attr("ov");
			}
		});
	});
</script>
</head>
<body>
	
	<div id="header">
			<img class="logo_img" alt="" src="static/img/logo.gif" >
			<span class="wel_word">购物车</span>
				
		<!-- 登录成功之后所有相同的菜单  -->
		<%@ include file="/pages/common/login_success_menu.jsp" %>

	</div>
	
	<div id="main">
		<table>
			<tr>
				<td>商品名称</td>
				<td>数量</td>
				<td>单价</td>
				<td>金额</td>
				<td>操作</td>
			</tr>	
			<c:choose>
				<%-- 先判断，如果购物车有商品，则显示，没有则提示用户，购物车是空 --%>
				<c:when test="${  not empty sessionScope.cart.items }">
					<!-- 遍历购物车中的内容 -->
					<c:forEach items="${ sessionScope.cart.items }" var="item">
						<%-- 
							把购物车中的CartItem取到,存到pageScope域中
						 --%>
						<c:set value="${ item.value }" var="cartItem" />
						<%-- 输出 --%>
						<tr>
							<td>${ cartItem.name }</td>
							<!-- ov为原来的数量备份，data属性保存商品编号，class属性，方便我们通过class选择器查找到输入框 -->
							<td><input ov="${ cartItem.count }" style="width: 35px;" class="updateItem" data="${ cartItem.id }" value="${ cartItem.count }" type="text" /> </td>
							<td>${ cartItem.price }</td>
							<td>${ cartItem.totalMoney }</td>
							<!-- class属性方便 jquery查找所有删除的a标签 -->
							<td><a class="deleteItem" href="cartServlet?action=deleteItem&id=${ cartItem.id }">删除</a></td>
						</tr>
					</c:forEach>
				</c:when>
				<%-- 没有商品，提示用户 --%>
				<c:otherwise>
					<tr>
						<td colspan="5"><a href="${ pageContext.request.contextPath }">亲，购物车是空的。快去买，买，买！！！</a></td>
					</tr>
				</c:otherwise>
			</c:choose>

		</table>
		<div class="cart_info">
			<span class="cart_span">购物车中共有<span class="b_count">${ cart.totalCount }</span>件商品</span>
			<span class="cart_span">总金额<span class="b_price"> ${ cart.totalMoney } </span>元</span>
			<span class="cart_span"><a id="clearCart" href="cartServlet?action=clear">清空购物车</a></span>
			<span class="cart_span"><a href="pages/cart/checkout.jsp">去结账</a></span>
		</div>
	</div>
	<!-- 这是页脚的引入 -->
	<%@ include file="/pages/common/footer.jsp" %>
</body>
</html>