<%@page import="com.summer.comm.StringUtil"%>
<%@page import="com.summer.comm.SearchVO"%>
<%@page import="org.slf4j.Logger"%>
<%@page import="org.slf4j.LoggerFactory"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%
	Logger log = LoggerFactory.getLogger(this.getClass());
	log.debug("===================================");
	log.debug("this.getClass()="+this.getClass());
	log.debug("===================================");
	
%>

<%-- CONTEXT --%>
<c:set var ="CONTEXT" value="${pageContext.request.contextPath}" ></c:set>
	<div class="container">
		<br>
		<br>
		<br>
		<!-- Title-------------------------------------------- -->
		 <h3>글수정</h3>
		<!--// Title------------------------------------------ -->
		<form id="frmselect" name="frmselect" method="get">
		</form>

		
		<!-- Input Form--------------------------------------- -->
		<div class="container">
			<div class="col-lg-12"></div>
			<div class="col-lg-12"></div>
			<div class="panel panel-default"></div>
			<form class="form-horizontal" name="frm" id="frm"
				method="post">
				<div class="form-group">
					<label class="col-lg-4 control-label" style="display:none;">구분</label>
					<div class="col-lg-8">
						<input type="hidden"  name="category" id="category"
							class="form-control input-sm" value="${Board.category}" maxlength="20" />
					</div>
				</div>
				
				<div class="form-group">
					<label class="col-lg-4 control-label">제목</label>
					<div class="col-lg-8">
						<input type="text" name="title" id="title"
							class="form-control input-sm" value="${Board.title}" maxlength="20" />
					</div>
				</div>
				
				<div class="form-group">
					<label class="col-lg-4 control-label">작성자</label>
					<div class="col-lg-8">
						<input type="text" name="id" id="id" disabled="disabled"
							class="form-control input-sm" value="<%= session.getAttribute("id") %>" maxlength="200" />
					</div>
				</div>
				
				<div class="form-group">
					<label class="col-lg-4 control-label">글내용</label>
					<div class="col-lg-8">
						<textarea class="form-control" id="content" name="content" rows="15">${Board.content}</textarea>
					</div>
				</div>
			</form>
		</div>
		<!--// Input Form------------------------------------- -->
		
				
		<!-- Button-------------------------------------------- -->
		 <div class="form-inline pull-right">
		 	<button class="btn btn-default btn-sm" id="do_update" >완료</button>
		 	<button class="btn btn-default btn-sm" id="do_selectOne" >취소</button>
		 </div>
		<!--// Button------------------------------------------ -->
		</div>
		<!-- jQuery (부트스트랩의 자바스크립트 플러그인을 위해 필요합니다) -->
    <script src="${CONTEXT}/resources/js/jquery-1.12.4.js"></script>
    <!-- 모든 컴파일된 플러그인을 포함합니다 (아래), 원하지 않는다면 필요한 각각의 파일을 포함하세요 -->
    <script src="${CONTEXT}/resources/js/bootstrap.min.js"></script>
	<script type="text/javascript">


		
		$(document).ready(function() {

			//등록
			$("#do_update").on("click", function() {
				console.log("do_update")
				
				var boardNum = ${Board.num};
				
				if (false == confirm("수정 하시겠습니까?"))
					return;

				$.ajax({
					type : "POST",
					url : "do_update.do",
					dataType : "html",// JSON/Html
					async : false,
					data : {
						"category" : $("#category").val(),
						"title" : $("#title").val(),
						"content" : $("#content").val(),
						"num"	: boardNum
					},
					success : function(data) {//통신이 성공적으로 이루어 졌을때 받을 함수
						console.log("data=" + data);
						//json parsing
						var parseData = $.parseJSON(data);
						console.log("parseData=" + parseData);

						if (parseData.msgId == "1") {
							alert(parseData.message);
							
							var frm = document.frmselect;
							frm.action = '${CONTEXT}'+"/board/do_selectList.do";
							frm.submit();	
						} else {
							alert(parseData.message);
						}

					},
					complete : function(data) {//무조건 수행

					},
					error : function(xhr, status, error) {
						console.log("do_update error: " + error);
					}
				});//--그리드 click -> ajax
			});//--수정
			
			//취소(뒤로가기)
			$("#do_selectOne").on("click", function() {
				console.log("do_selectOne_cancel")
				
				if (false == confirm("취소하시겠습니까?"))
					return;
				
				var num = ${Board.num};
				location.href="/summer/board/do_selectOne.do?num="+num;
			});
			
		});//--document.ready
	</script>