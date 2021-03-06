<%@page import="com.summer.comm.StringUtil"%>
<%@page import="com.summer.comm.SearchVO"%>
<%@page import="org.slf4j.LoggerFactory"%>
<%@page import="org.slf4j.Logger"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%
	Logger log = LoggerFactory.getLogger(this.getClass());

	String userId = (String)session.getAttribute("id");
	
	if(null == session.getAttribute("id")){
		userId = null;
	} else {
		userId = session.getAttribute("id").toString();
	}
	
	log.debug("userId="+userId);

	log.debug("==================================");
	log.debug("this.getClass()"+this.getClass());
	log.debug("==================================");
	
	String pageSize = "10";// 페이지 사이즈
	String pageNum = "1";// 현재페이지
	String searchWord = "";// 검색어
	String searchDiv = "";// 검색구분
	
	int totalCnt = 0;
	int bottomCnt = 10; //바닥에 보여줄 숫자
	
	SearchVO searchVO = new SearchVO();
	
	if(null != request.getAttribute("searchVO")) {
		searchVO = (SearchVO)request.getAttribute("searchVO");
	}
	log.debug("==searchVO=="+searchVO.toString());
	
	
	pageSize = StringUtil.nvl(searchVO.getPageSize(),"10");
	pageNum = StringUtil.nvl(searchVO.getPageNum(),"1");
	searchWord = StringUtil.nvl(searchVO.getSearchWord(),"");
	searchDiv = StringUtil.nvl(searchVO.getSearchDiv(),"");
	
	int o_pageSize = Integer.parseInt(pageSize);
	int o_pageNum = Integer.parseInt(pageNum);
	
	String o_totalCnt =  (null == request.getAttribute("totalCnt"))?"0":request.getAttribute("totalCnt").toString();
	
	totalCnt = Integer.parseInt(o_totalCnt);
%>
<%-- CONTEXT --%>
<c:set var="CONTEXT" value="${pageContext.request.contextPath}"/>
<c:set var="userId" value="<%=userId%>"></c:set>
  <style>
       #map {
        height: 400px;
        width: 100%;
       }
    </style>

<div class="container">
	
	<!-- search -->
	<form class="form-inline" name="frm" id="frm" method="get">
		<input type="hidden" name="pageNum" value="${searchVO.pageNum}"/>
		<input type="hidden" name="goodId" value="${detailGood.goodId}"/>
		<input type="hidden" id="x"/>
		<input type="hidden" id="y"/>
		<input type="hidden" id="userId" value="<%=userId %>"/>
		 
		<table class="table">
			<tr>
				<td class="text-center">
				<div class="form-group col-lg5 col-sm6">
					<input type="text" class="form-control input-sm" name="searchWord" id="searchWord" value="${searchVO.searchWord}">
					<button class="btn btn-sm" id="goodlist" onclick="javascript:doSearch();">검색</button>
				</div>
				</td>
			</tr>
		</table>
		
	</form>
	<!-- search end -->
	
	<h3>${detailGood.goodName}</h3>
	<hr/>
	
	<!-- list -->
	<div class="table-responsive">
		<table class="table table-striped table-bordered table-hover" id="listTable">
       	<thead class="bg-primary">
       		<th class="text-center">최저가격</th>
       		<th class="text-center">평균가격</th>
       		<th class="text-center">최고가격</th>
       	</thead>
       	<tbody>
       		<tr>
		         	<td class="text-center"><fmt:formatNumber value="${detailGood.minPrice}" pattern="#,###"/> 원</td>
		         	<td class="text-center"><fmt:formatNumber value="${detailGood.avgPrice}" pattern="#,###"/> 원</td>
		         	<td class="text-center"><fmt:formatNumber value="${detailGood.maxPrice}" pattern="#,###"/> 원</td>
		       </tr>
         	</tbody>
       </table>
	</div>
	
	<!-- list end -->
	<br/>
	<hr/>
	
	<div id="map"></div>
	
	<!-- List ------------------------------------------------------------->
  
  <br/>
  <br/>
  <h4>가까운 매장</h4>
  <hr/>
	
     	<table id="entpTable" class="table table-striped table-bordered table-hover">
        	<thead class="bg-primary">
        		<tr>
        			<th class="text-center">매장명</th>
	         		<th class="text-center">가격</th>
	         		<c:choose>
	         			<c:when test="${userId ne null}">
	         				<th class="text-center">장바구니</th>
	         			</c:when>
	         		</c:choose>
         		</tr>
         	</thead>
        	<tbody>
        		<tr>
	         		<td colspan="99" class="text-center">no data</td>
	         	</tr>		
        	</tbody>
        </table>
      </div>
	  
   <!--// List ----------------------------------------------------------->
	<script async defer
    src="https://maps.googleapis.com/maps/api/js?key=AIzaSyB3C_iXo7Xb-jkSbAqAQBHNcHRMP7HyWp0&callback=initMap">
    </script>
	<script type="text/javascript">
	
	var length = ${entpList.size()};
	var list = new Array();
	
	var x;
	var y;


	<c:forEach var="location" items="${entpList}" varStatus="status">
	 	var arr = {};
		arr["entpName"]="${location.entpName}";
		arr["x"]=${location.XMapCoord};
		arr["y"]=${location.YMapCoord};
		list.push(arr);
	</c:forEach>
	
	
	$(document).ready(function(){
	});

	
	function initMap() {
        var map = new google.maps.Map(document.getElementById('map'), {
          center: {lat: -34.397, lng: 150.644},
          zoom: 15
        });
       
        var infoWindow = new google.maps.InfoWindow({
        	map: map
        });
        
        var locs = new Array();
        for(var i=0;i<length;i++){
        	locs[i] = {position: new google.maps.LatLng(list[i].x,list[i].y), title:list[i].entpName};  
        }
        
        //console.log(locs[0].title);

          // Create markers.
        locs.forEach(function(loc) {
            var marker = new google.maps.Marker({
              position: loc.position,
              title: loc.title,
              map: map
            });
           marker.addListener('click', function() {
        	   	infoWindow.open(map, marker);
        	   	infoWindow.setContent(loc.title);
             });
          });
        
        
        
        // Try HTML5 geolocation.
        if (navigator.geolocation) {
          navigator.geolocation.getCurrentPosition(function(position) {
            var pos = {
              lat: position.coords.latitude,
              lng: position.coords.longitude
            };
            x = pos.lat;
            y = pos.lng
            
            //console.log(x);
            //console.log(y);
            
            $("#x").val(x);
            $("#y").val(y);

            doEntpSearch();
            
            //var image = ${CONTEXT}+"/img/flag.png";
            var image = new google.maps.MarkerImage("${CONTEXT}/img/flag.png",
            												null,
								            		   		null,
            		   										null);
            
            var marker = new google.maps.Marker({
                position: pos,
                map: map,
                icon: image
              });
            
            
            
            marker.addListener('click', function() {
        	   	infoWindow.open(map, marker);
        	   	infoWindow.setContent('현재위치');
             });
              
            map.setCenter(pos);
          }, function() {
            handleLocationError(true, infoWindow, map.getCenter());
          });
        } else {
          // Browser doesn't support Geolocation
          handleLocationError(false, infoWindow, map.getCenter());
        }
        
      }

      function handleLocationError(browserHasGeolocation, infoWindow, pos) {
        infoWindow.setPosition(pos);
        infoWindow.setContent(browserHasGeolocation ?
                              'Error: The Geolocation service failed.' :
                              'Error: Your browser doesn\'t support geolocation.');
      }
      
//       var entpid, entpname;
      
   function doEntpSearch(){
	   //alert($("#x").val());
	   //alert($("#y").val());
	   
	   $.ajax({
	      	 type:"GET",
       url:"dosearchEntp.do",   
       dataType:"html",// JSON/html
       async: false,
       data:{
    	   "goodId":'${detailGood.goodId}',
    	   "XMapCoord":$("#x").val(),
    	   "YMapCoord":$("#y").val()
        },
       success: function(data){//통신이 성공적으로 이루어 졌을때 받을 함수
      	 //console.log("data="+data); 
        
       	//json parsing
       	var parseData = $.parseJSON(data); //데이터 들어있음.
       
       	$('#entpTable > tbody > tr > td').remove();
       	
       	$.each(parseData , function(idx, val) {

     			//var entpid = val[4];
     			//var entpname = val[0];
     			
       		 $('#entpTable > tbody').append(
       				 "<tr>"
       				 +"<td id='entpn'>" + val[0] +"&nbsp;&nbsp;"+ ((val[2] == 'Y') ? "<span class='badge badge-success' style='font-color: white;'>1+1</span>":"") +"&nbsp;&nbsp;"+ ((val[3] == 'Y') ? "<span class='badge badge-info'>할인</span>":"") +"</td>"
       				 +"<td class='text-right'>" + numberWithCommas(val[1]) + " 원</td>"
       				 +"<c:choose><c:when test='${userId ne null}'>"
       				 +"<td class='text-center'><input type='button' class='btn btn-default' value='추가' onclick=javascript:doUpsert('"+val[4]+"','"+val[0]+"');></td>"
       				 +"</c:when></c:choose>"
       				 +"<td id='entpi' class='text-left' style='display:none;'>"+val[4]+"</td>"
       				 +"</tr>"
       				 );
       		 	//alert("val[4]"+val[4]);
       		
       		}); 
           },
          complete: function(data){//무조건 수행
           },
          error: function(xhr,status,error){
          console.log("dosearchEntp error: "+error);
           }
		}); 
	   //그리드 클릭> ajax
   }
   
 //천단위 콤마
	function numberWithCommas(x) {
	    return x.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
	}
	
	function doSearch(){
		var frm = document.frm;
		frm.action = "doSelectList.do";
		frm.submit();
	}
	
	function doUpsert(entpid, entpname){
		console.log('${detailGood.goodId}');
		console.log('${detailGood.goodName}');
		console.log(entpid);
		console.log(entpname);
	$.ajax({
	      	 type:"POST",
      url:"${CONTEXT}/favo/doUpsert.do",   
      dataType:"html",// JSON/html
      async: false,
      data:{
   	   		"goodId":'${detailGood.goodId}',
   	   		"goodName":'${detailGood.goodName}',
   	   		"entpId":entpid,
   	   		"entpName":entpname,
   	   		"goodNum":1,
   	   		"id":$("#userId").val()
       },
      success: function(data){//통신이 성공적으로 이루어 졌을때 받을 함수
     	 	console.log("data="+data); 
     	 	var parseData = $.parseJSON(data); //데이터 들어있음.
        	console.log("parseData"+parseData);
        		
        	if(parseData == "1"){
        		alert(parseData.message);	
        	}else{
        		alert(parseData.message);	
        	}
      
          },
         complete: function(data){//무조건 수행
          },
         error: function(xhr,status,error){
         console.log("doUpsert error: "+error);
          }
		}); 
	   //그리드 클릭> ajax
	
	}
	
	</script>
