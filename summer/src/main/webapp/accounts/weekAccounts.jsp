

<%@page import="com.summer.accounts.domain.Accounts"%>
<%@page import="com.summer.comm.DTO"%>
<%@page import="java.util.List"%>
<%@page import="com.summer.codes.dao.CodeDao"%>
<%@page import="com.summer.codes.domain.CodeVO"%>
<%@page import="com.summer.comm.StringUtil"%>
<%@page import="com.summer.comm.SearchVO"%>
<%@page import="org.slf4j.LoggerFactory"%>
<%@page import="org.slf4j.Logger"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%
	Logger log = LoggerFactory.getLogger(this.getClass());

	log.debug("===============================");
	log.debug("=this.getClass()="+this.getClass());
	log.debug("===============================");

	String searchWord = ""; //검색어
	String searchDiv = ""; //검색구분

	SearchVO searchVO = new SearchVO();
	if(null != request.getAttribute("searchVO")){
		searchVO = (SearchVO)request.getAttribute("searchVO");
	}
	log.debug("=searchVO="+searchVO.toString());
	
	searchWord = StringUtil.nvl(searchVO.getSearchWord(),"");
	searchDiv = StringUtil.nvl(searchVO.getSearchDiv(),"2018/06");
	
	String searchYear = searchDiv.substring(0, searchDiv.indexOf("/"));
	String searchMonth = searchDiv.substring(searchDiv.indexOf("/")+1);
	
	log.debug("searchDiv"+searchDiv);

	
%>

<%-- CONTEXT --%>
<c:set var="CONTEXT" value="${pageContext.request.contextPath}"/>

  
  <div class="container">
 	<br/><br/>
 	

   <!-- Search ----------------------------------------------------------->
   	<form class="form-inline" name="frm" id="frm" method="get">
		<input type="hidden" name="searchWord" id="searchWord" value="<%=session.getAttribute("id")%>"/>
	   	<table class="table">
	   			<tr>
	   				<td style="padding-left:0; padding-right:0;">
	   					<div class="form-group col-xs-12" style="padding:0">
							<select id="searchYear" name="searchYear" class="form-control input-sm">
					          <c:forEach begin="0" end="10" var="result" step="1">
					           <option value="${2018 - result}"
					           	<c:if test="${(2018 - result) == searchYear}"> selected="selected"</c:if>><c:out value="${2018 - result}" />
					           </option>
					          </c:forEach>                          
					        </select>
					        <select id="searchMonth" name="searchMonth" class="form-control input-sm" onchange="makeWeekSelectOptions();">
					          <c:forEach begin="1" end="12" var="result" step="1">
					           <option value=<fmt:formatNumber value="${result}" pattern="00"/>
					           	<c:if test="${result == 6}"> selected="selected"</c:if>>
					           		<fmt:formatNumber value="${result}" pattern="00"/>
					           </option>
					          </c:forEach>  
					                            
					        </select>
					        
					       
							<input type="button" class="btn btn-sm btn-default" id="doSelectWeek" value="검색"/>
   							<input  style="float:right;" type="button" class="btn btn-sm btn-default" value="차트보기" onclick="showWeekPopup();"/>		
	   					</div>
	   				</td>
	   			</tr>
   		</table> 
   		
   	</form>
   	   		
		
   	



   	<!--// Search --------------------------------------------------------->
   
  
   <!-- List ------------------------------------------------------------->
  
	     <div class="table-responsive">
	     	
	       <table id="listTable" class="table  table-striped table-bordered table-hover">
	        	<thead class="bg-primary">
	        		<tr>
	        			<th class="text-center" width="200">주</th>
		         		<th class="text-center" width="200">지출</th>
		         		<th class="text-center" width="200">수입</th>
		         		<th class="text-center" width="200">총합</th>
	         		</tr>
	        	</thead>
	        	<tbody>
	        	
	        	</tbody>
	        </table>
	        
	      </div>
	    

   <!--// List ----------------------------------------------------------->
   
   </div>
   
	<script type="text/javascript">
	
	function doWeek(){
		var frm = document.frm;
		frm.action="doWeek.do";
		frm.submit();
	}
	
	//천단위 콤마
	function numberWithCommas(x) {
	    return x.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
	}
	
	
	$(document).ready(function(){
		
		
		$("#doSelectWeek").on("click",function(){

			$.ajax({
	    			      	 type:"GET",
		                 url:"doSelectListWeek.do",   
		                 dataType:"html",// JSON/html
		                 async: false,
		                 data:{
		                    	"searchDiv":$("#searchYear").val() +"/"+ $("#searchMonth").val(),
		                    	"searchWord":$("#searchWord").val()
			                 },
		                 success: function(data){//통신이 성공적으로 이루어 졌을때 받을 함수
		                	
		                	 console.log("data="+data); 
		                 
		                 	//json parsing
		                 	var parseData = $.parseJSON(data); //데이터 들어있음.
		                 
		                 	$('#listTable > tbody > tr').remove();
		                 	
		                 	$.each(parseData , function(idx, val) {
		                 		 $('#listTable > tbody').append("<tr><td>" + val[0] + "</td><td class='text-right' style='color: red;'>" + numberWithCommas(val[1]) + "</td><td class='text-right' style='color: blue;'>" + numberWithCommas(val[2])+ "</td><td class='text-right'>"+ numberWithCommas(val[3]) + "</td></tr>");
		                 		
		                 		});
		                 		
			                 },
			                complete: function(data){//무조건 수행
			                 },
			                error: function(xhr,status,error){
			                console.log("do_checkedDelete error: "+error);
			                 }
  			   }); //--그리드 클릭> ajax
		});
		
		$("#doSelectWeek").trigger("click"); 
		
	});
			
		function showWeekPopup() { window.open("${CONTEXT}/chart/chart2.jsp", "월 간 차트", "width=380, height=800, left=100, top=50"); }		
	
		
	</script>
	
  </body>
</html>