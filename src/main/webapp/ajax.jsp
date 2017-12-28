
<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%
	String path = request.getContextPath();
	String basePath = request.getScheme() + "://"
			+ request.getServerName() + ":" + request.getServerPort()
			+ path + "/";
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<base href="<%=basePath%>">

<title>My JSP 'ajax.jsp' starting page</title>

<meta http-equiv="pragma" content="no-cache">
<meta http-equiv="cache-control" content="no-cache">
<meta http-equiv="expires" content="0">
<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
<meta http-equiv="description" content="This is my page">
<!--
	<link rel="stylesheet" type="text/css" href="styles.css">
	-->
<script type="text/javascript">
	function sendAjax(url, methodType, param, resultFun) {
		var xmlhttp = null;
		if (window.XMLHttpRequest) {// code for IE7+, Firefox, Chrome, Opera, Safari
			xmlhttp = new XMLHttpRequest();
		} else {// code for IE6, IE5
			xmlhttp = new ActiveXObject("Microsoft.XMLHTTP");
		}
		xmlhttp.onreadystatechange = function() {
			if (xmlhttp.readyState == 4 && xmlhttp.status == 200) {
				resultFun(xmlhttp.responseText);
			}
		};
		if (methodType == "get" || methodType == "GET") {
			xmlhttp.open("GET", url + "?" + param, true);
			xmlhttp.send();
		} else {
			xmlhttp.open("POST", url, true);
			xmlhttp.setRequestHeader("Content-type",
					"application/x-www-form-urlencoded;charset=UTF-8");
			xmlhttp.send(param);
		}
	}

	function query() {
		var foodname = document.getElementsByName("foodName")[0].value;

		sendAjax(
				"${pageContext.request.contextPath}/queryAFoodList",
				"GET",
				"foodName=" + foodname,
				function(responseText) {
					//返回的是字符串json
					var resultJson = responseText;
					//转换成json对象
					var resultObj = JSON.parse(resultJson);
					//获取表格对象				
					var table = document.getElementById("myTable");
					//将所有名字为 dataTr的tr全部删除  [a,b,c]
					var allDataTr = document.getElementsByName("dataTr");
					var length = allDataTr.length;
					for ( var i = 0; i < length; i++) {
						table.removeChild(allDataTr[0]);
					}

					//根据json的行数追加多个tr
					for ( var i = 0; i < resultObj.length; i++) {
						var obj = resultObj[i];
						var td = document.createElement("td");
						td.innerText = obj.foodname;

						var td1 = document.createElement("td");
						td1.innerText = obj.price;

						var td2 = document.createElement("td");
						//创建删除按钮
						var button = document.createElement("button");
						button.innerText = "删除";
						td2.appendChild(button);
						
						//创建修改按钮
						var button1 = document.createElement("button");
						button1.innerText = "修改";
						td2.appendChild(button1);

						var tr = document.createElement("tr");
						tr.setAttribute("name", "dataTr");
						
						//将json对象绑定到当前按钮
						button.foodObj = obj;
						//将数据行绑定到当前按钮
						button.curTr = tr;
						button.addEventListener("click", function() {
							//获取当前按钮
							var curButton = event.srcElement;
							//删除数据化
							table.removeChild(curButton.curTr);
							//发送请求到服务器重新查询数据
							sendAjax("${pageContext.request.contextPath}/food/"
									+ button.foodObj.foodid, "POST",
									"_method=delete", function(responseText) {
										if (responseText == 1)
											alert("删除成功");
										else {
											alert("删除失败");
										}
									});
						});

						button1.foodObj = obj;
						button1.curTr = tr;
						button1.addEventListener("click",function() {
											var curButton = event.srcElement;
											document
													.getElementById('updateDiv').style.display = 'block';
											document
													.getElementsByName("umyFoodName")[0].value = curButton.foodObj.foodname;
											document
													.getElementsByName("umyFoodPrice")[0].value = curButton.foodObj.price;
											document
													.getElementsByName("umyFoodId")[0].value = curButton.foodObj.foodid;
										});

						tr.appendChild(td);
						tr.appendChild(td1);
						tr.appendChild(td2);
						table.appendChild(tr);
					}
				});

	}
	//新增菜品
	function saveFood() {
		var myFoodName = document.getElementsByName("myFoodName")[0].value;
		var myFoodPrice = document.getElementsByName("myFoodPrice")[0].value;
		sendAjax("${pageContext.request.contextPath}/food", "POST", "foodName="
				+ myFoodName + "&price=" + myFoodPrice, function(responseText) {
			if (responseText == 1) {
				document.getElementById('addDiv').style.display = 'none';
				query();
				alert("新增成功");

			} else {
				alert("新增失败");
			}
		});

	}
	
	//修改菜品
	function updateFood() {
		//获取div中文本框的值
		var myFoodName = document.getElementsByName("umyFoodName")[0].value;
		var myFoodPrice = document.getElementsByName("umyFoodPrice")[0].value;
		var myFoodId = document.getElementsByName("umyFoodId")[0].value;
		sendAjax(
				"${pageContext.request.contextPath}/food/" + myFoodId,
				"POST",
				"_method=put&foodName=" + myFoodName + "&price="
						+ myFoodPrice,
				function(responseText) {
					if (responseText == 1) {
						//隐藏div
						document.getElementById('updateDiv').style.display = 'none';
						query();
						alert("修改成功");

					} else {
						alert("修改失败");
					}
				});
	}
</script>
</head>

<body>
	<input type="text" name="foodName" />
	<input type="button" value="查询" onclick="query()" />
	<input type='button' value="新增"
		onclick="document.getElementById('addDiv').style.display='block';">
	<br />
	<br />
	<table id="myTable" >
		<tr>
			<th>菜品名</th>
			<th>菜品价格</th>
			<th>操作</th>
		</tr>
	</table>

	<!-- 新增菜品 -->
	<div id="addDiv"
		style="display:none;position: absolute;left:40%;top:40%;z-index: 100;border:1px solid black;width:250px;height: 80px;">

		<table style="text-align: left">

			<tr>
				<td>菜品名：</td>
				<td><input type="text" name="myFoodName">
				</td>
			</tr>
			<tr>
				<td>价格：</td>
				<td><input type="text" name="myFoodPrice">
				</td>
			</tr>
			<tr>
				<td><input type="button" value="保存" onclick="saveFood()">
				</td>
				<td><input type="button" value="关闭"
					onclick="document.getElementById('addDiv').style.display='none';">
				</td>
			</tr>
		</table>
	</div>

	<!-- 修改菜品 -->
	<div id="updateDiv"
		style="display:none;position: absolute;left:40%;top:40%;z-index: 100;border:1px solid black;width:250px;height: 80px;">
		<!-- 隐藏表单域：传递菜品的id -->
		<input type="hidden" name="umyFoodId">
		<table style="text-align: left">

			<tr>
				<td>菜品名：</td>
				<td><input type="text" name="umyFoodName">
				</td>
			</tr>
			<tr>
				<td>价格：</td>
				<td><input type="text" name="umyFoodPrice">
				</td>
			</tr>
			<tr>
				<td><input type="button" value="修改" onclick="updateFood()">
				</td>
				<td><input type="button" value="关闭"
					onclick="document.getElementById('updateDiv').style.display='none';">
				</td>
			</tr>
		</table>
	</div>
</body>
</html>
