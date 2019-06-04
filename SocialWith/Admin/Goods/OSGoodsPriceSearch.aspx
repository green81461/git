<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Master/AdminMasterPage.master" AutoEventWireup="true" CodeFile="OSGoodsPriceSearch.aspx.cs" Inherits="Admin_Goods_OSGoodsPriceSearch" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
     <link href="../Content/Goods/goods.css" rel="stylesheet" />
     <link href="../Content/popup.css" rel="stylesheet" />
    <style>
         #tblList2 td:nth-child(2){
             height: 30px;
             border: 1px solid #a2a2a2;
             text-align: left;
         }

    </style>
     <script type="text/javascript">
         $(document).ready(function () {
            
            //카테고리 리스트 바인드(레벨1)
            fnCategoryBind();
     
        });

        //카테고리 리스트 바인드(레벨1)
        function fnCategoryBind() {
            fnSelectBoxClear(1);
            var callback = function (response) {

                if (!isEmpty(response)) {

                    var ddlHtml = "";

                    $.each(response, function (key, value) {

                        ddlHtml += '<option value="' + value.CategoryFinalCode + '">' + value.CategoryFinalName + '</option>';
                    });

                    $("#Category01").append(ddlHtml);

                }
                return false;
            };

            var sUser = '<%=Svid_User %>';
            var param = {
                LevelCode: '1',
                UpCode: '',
                Method: 'GetCategoryLevelList'
            };

            JajaxSessionCheck('Post', '../../Handler/Common/CategoryHandler.ashx', param, 'json', callback, '<%=Svid_User %>');
        }


        //상위레벨 카테고리 선택시 하위 카테고리 리스트 바인드
        function fnChangeSubCategoryBind(el, level) {

            var selectedVal = $(el).val();

            for (var i = level; i < 10; i++) {
                fnSelectBoxClear(i);
            }

            var callback = function (response) {

                if (!isEmpty(response)) {

                    var ddlHtml = "";

                    $.each(response, function (key, value) {
                        ddlHtml += '<option value="' + value.CategoryFinalCode + '">' + value.CategoryFinalName + '</option>';
                    });

                    var id = '';

                    if (level == '10') {
                        id = level;
                    }
                    else {
                        id = '0' + level;
                    }
                    $("#Category" + id).append(ddlHtml);

                }
                return false;
            };

            var sUser = '<%=Svid_User %>';
            var param = {
                LevelCode: level,
                UpCode: selectedVal,
                Method: 'GetCategoryLevelList'
            };

            JajaxSessionCheck('Post', '../../Handler/Common/CategoryHandler.ashx', param, 'json', callback, '<%=Svid_User %>');

        }

        //카테고리 리스트 클리어
        function fnSelectBoxClear(index) {

            var id = '';

            if (index == '10') {
                id = index;
            }
            else {
                id = '0' + index;
            }
            $("#Category" + id).empty();
           
            $("#Category" + id).append('<option value="All">---전체---</option>');
        
            
            return false;

        }

         //선택된 업체 정보 조회
         function fnGetCompanyInfo() {      
             //if (!fnValidation()) {
             //    return false;
             //}

             var searchKeyword = $("#<%=txtCompSearch.ClientID%>").val();
             var asynTable = "";
             var callback = function (response) {

                 $("#tblList tbody").empty();

                 if (!isEmpty(response)) {
                     $.each(response, function (key, value) {

                         var gubun = value.Gubun;
                         if (gubun == 'A') {
                             gubun = '판매사';
                         } else {
                             gubun = '구매사';
                         }


                         asynTable += "<tr>";
                         asynTable += "<td style='width:3%'><input type='checkbox' onchange='fnCheckboxChange();'></td>";
                         asynTable += "<td>" + gubun + "</td>";
                         asynTable += "<td id='comp_code'>" + value.Company_Code + "</td>";
                         asynTable += "<td id='comp_name'>" + value.Company_Name + "</td>";
                         asynTable += "<td style='width:7%'>" + value.DelegateName + "</td>";
                         asynTable += "<td style='width:7%'>" + value.AdminUserName + "</td>";
                         asynTable += "<td style='width:10%'>" + fnOracleDateFormatConverter(value.CpConStartDate) + "</td>";
                         asynTable += "<td style='width:10%'>" + fnOracleDateFormatConverter(value.CpConEndDate) + "</td>";
                         asynTable += "<td style='width:10%'>" + fnOracleDateFormatConverter(value.CompanyPriceDate) + "</td>";
                         asynTable += "<td style='width:7%'>" + value.CompanyPriceName + "</td>";
                         asynTable += "</tr>";
                     });

                 } else {
                     asynTable += "<tr id='trEmpty'><td colspan='10' class='txt-center'>" + "조회된 데이터가 없습니다." + "</td></tr>"
                 }
                 $("#tblList tbody").append(asynTable);
          
        
                 return false;
             };

             var sUser = '<%=Svid_User %>';
             var param = {
                 Gubun: 'A',
                 SearchKeyword: searchKeyword,
                 SaleSearchType: 'SEARCH',
                 BuySearchType: '',
                 PageNo: 1,
                 PageSize: 1,
                 Flag: 'GetCompPriceCompanyList'
             };

             JajaxSessionCheck('Post', '../../Handler/Admin/CompanyHandler.ashx', param, 'json', callback, '<%=Svid_User %>');
        }

         //전체선택
         function fnSelectAll(el) {
             if ($(el).prop("checked")) {
                 $("input[id^=cbSelect]").not(":disabled").prop("checked", true);
             }
             else {
                 $("input[id^=cbSelect]").not(":disabled").prop("checked", false);
             }
         }
         
         function fnValidation() {
             var trID = $("#tblList tbody tr").prop('id');
             
             if (trID == 'trEmpty') {
                 alert('판매사를 검색해주세요.');
                 return false; 

             } else {
                 var cnt = 0;
                 $('#tblList input[type="checkbox"]').each(function () {
                     if ($(this).prop("checked") == true) {
                         cnt++;
                     } 

                 });

                 if (cnt == 0) {
                     alert('체크박스를 선택해주세요.');
                     return false; 

                 }
                 
             }

            <%-- var searchKeyword = $("#<%=txtCompSearch.ClientID%>").val();
             if (searchKeyword == ''){
                 alert("판매사를 입력해주세요.");
                 return false; 
             }--%>
             return true;
         }

         function fnCheckboxChange() {
             $("#Category01").prop("disabled", "");
             $("#Category02").prop("disabled", "");
             $("#Category03").prop("disabled", "");
             $("#Category04").prop("disabled", "");
             $("#Category05").prop("disabled", "");
             $("#txtGoodsName").prop("disabled", "");
             $("#txtGoodsCode").prop("disabled", "");
             $("#txtBrandName").prop("disabled", "");
             $("#txtBrandCode").prop("disabled", "");
             $("#txtGroupCode").prop("disabled", "");
         }

         function fnSaleCompSearchEnter() {
             if (event.keyCode == 13) {
                 fnGetCompanyInfo();
                 return false;
             }
             else
                 return true;

         }
     


         //2
         function fnCompSaleInfoList(pageNo) {
             if (!fnValidation()) {
                 return false;
             }

             var category1 = $("select[id ^='Category01']").val();
             var category2 = $("select[id ^='Category02']").val();
             var category3 = $("select[id ^='Category03']").val();
             var category4 = $("select[id ^='Category04']").val();
             var category5 = $("select[id ^='Category05']").val();
             var finalCategory = "";
             var compCode1 = "";
             var compCode2 = "";
             var compCode3 = "";
             var compCode4 = "";
             var compCode5 = "";
             var categoryCode = finalCategory;
             var txtGoodsName = $("#txtGoodsName").val();
             var txtGoodsCode = $("#txtGoodsCode").val();
             var txtBrandName = $("#txtBrandName").val();
             var txtBrandCode = $("#txtBrandCode").val();
             var txtGroupCode = $("#txtGroupCode").val();
             var pageSize = 50;

             var compName1 = "";
             var compName2 = "";
             var compName3 = "";
             var compName4 = "";
             var compName5 = "";

             if (txtGoodsCode != '' ) { 
                 category1 = 'All';
             } else if (txtGroupCode != ''){ 
                 category1 = 'All';
             }else if (category1 == 'All') {
                 alert('1단 카테고리는 필수 선택 조건입니다.');
                 return false;
             }
            
             if (category5 == 'All'){
                 if (category4 == 'All') {
                     if (category3 == 'All') {
                         if (category2 == 'All') {
                             finalCategory = category1;
                         } else {
                             finalCategory = category2;
                         }
                     } else {
                         finalCategory = category3;
                     }
                 } else {
                     finalCategory = category4;
                 }

             } else {
                 finalCategory = category5;
             }   
                  
             var queue = new Array(); //코드
             var queue2 = new Array(); //판매사명


             $('#tblList input[type="checkbox"]').each(function () {

                 if ($(this).prop("checked") == true) {
                     queue.push($(this).parent().parent().find("#comp_code").text());
                     queue2.push($(this).parent().parent().find("#comp_name").text());         
                 } else {
                     queue.push("");
                     queue2.push("");
                 }
           
                 if (isEmpty(compCode1)) {
                     compCode1 = queue.shift();
                     compName1 = queue2.shift();
                 } else if (isEmpty(compCode2)) {
                     compCode2 = queue.shift();
                     compName2 = queue2.shift();
                 } else if (isEmpty(compCode3)) {
                     compCode3 = queue.shift();
                     compName3 = queue2.shift();
                 } else if (isEmpty(compCode4)) {
                     compCode4 = queue.shift();
                     compName4 = queue2.shift();
                 } else {
                     compCode5 = queue.shift();
                     compName5 = queue2.shift();
                 }            

             });
             
             //alert(compName1);
             //alert(compName2);
             //alert(compName3);
             //alert(compName4);
             //alert(compName5);

             
             //alert(compCode3);
             //alert(compCode4);
             //alert(compCode5);

             //배열에 담는다
             var array = [compName1, compName2, compName3, compName4, compName5];
    
            
             var callback = function (response) {
                 var asynTable = "";
                 $("#tblList2 tbody").empty();

                 //체크 수 만큼 테이블 헤더에 th추가
                 var asynTable2 = "";
                 var cnt = 0;

                 //체크된 수 카운트
                 $('#tblList input[type="checkbox"]').each(function () {
                     if ($(this).prop("checked") == true) {
                         ++cnt;
                     }
                 });
                 $("#tdCompSalePrice").prop("colspan", cnt);
                 asynTable2 += "<tr>";
                 $('#tblList input[type="checkbox"]').each(function () {
                     if ($(this).prop("checked") == true) {
                         asynTable2 += "<th>";
                         asynTable2 += array.shift();
                         asynTable2 += "</th>";
                     }                    
                 });
                 asynTable2 += "</tr>";
                 if ($("#tblList2 thead tr").length > 1) {
                     $("#tblList2 thead tr").last().remove();
                 } 
                 $("#tblList2 thead").append(asynTable2);


               

                 if (!isEmpty(response)) {
                     $.each(response, function (key, value) {                   
                         $('#hdTotalCount').val(value.TotalCount);

                         //가격변동 세팅
                         var GoodsDCYN = value.GoodsDCYN;
                         if (GoodsDCYN == "1"){
                             GoodsDCYN = "가능";
                         } else if (GoodsDCYN == "2"){
                             GoodsDCYN = "불가능";
                         }

                        

                         //가격 세팅
                         var TempCompPrice_1 = value.TempCompPrice_1;
                         var TempCompPrice_2 = value.TempCompPrice_2;
                         var TempCompPrice_3 = value.TempCompPrice_3;
                         var TempCompPrice_4 = value.TempCompPrice_4;
                         var TempCompPrice_5 = value.TempCompPrice_5;
                  

                         if (TempCompPrice_1 == null) {
                             TempCompPrice_1 = "";
                         } else {
                             TempCompPrice_1 = numberWithCommas(TempCompPrice_1) + "원";
                         }

                         if (TempCompPrice_2 == null) {
                             TempCompPrice_2 = "";
                         } else {
                             TempCompPrice_2 = numberWithCommas(TempCompPrice_2) + "원";
                         }

                         if (TempCompPrice_3 == null) {
                             TempCompPrice_3 = "";
                         } else {
                             TempCompPrice_3 = numberWithCommas(TempCompPrice_3) + "원";
                         }

                         if (TempCompPrice_4 == null) {
                             TempCompPrice_4 = "";
                         } else {
                             TempCompPrice_4 = numberWithCommas(TempCompPrice_4) + "원";
                         }

                         if (TempCompPrice_5 == null) {
                             TempCompPrice_5 = "";
                         } else {
                             TempCompPrice_5 = numberWithCommas(TempCompPrice_5) + "원";
                         }


                         //배열에 담는다
                         var array2 = [TempCompPrice_1, TempCompPrice_2, TempCompPrice_3, TempCompPrice_4, TempCompPrice_5];
                         var asynTag = "";

                         for (var i = 1; i <= cnt; i++) {
                             var price = array2.shift();
                             asynTag += "<td style='text-align:right !important'>" + price + "</td>";                           
                         }

                         asynTable += "<tr>";
                         asynTable += "<td><input type='checkbox' id='cbSelect'></td>";
                         asynTable += "<td>" + value.GoodsCode + "<br/>" + value.GoodsFinalName + "(" + value.GoodsModel + ")" + "<br/>";
                         asynTable += "*" + value.BrandName + "<br/>";
                         asynTable += value.GoodsOptionSummaryValues + "</td>";
                         asynTable += "<td>" + value.GoodsUnitName + "</td>";
                         asynTable += "<td>" + value.GoodsGroupCode + "</td>";
                         asynTable += "<td style='text-align:right !important'>" + numberWithCommas(value.GoodsBuyPrice) + "원</td>";
                         asynTable += "<td style='text-align:right !important'>" + numberWithCommas(value.GoodsBuyPriceVat) + "원</td>";
                         asynTable += "<td style='text-align:right !important'>" + numberWithCommas(value.GoodsSalePriceVat) + "원</td>";
                         asynTable += "<td style='text-align:right !important'>" + numberWithCommas(value.GoodsCustPriceVat) + "원</td>";
                         asynTable += "<td>" + GoodsDCYN + "<br/>(" + fnSetDisplayFlag(value.GoodsDisplayFlag) + ")</td>";
                         asynTable += "<td>" + value.UrianYield + "%</td>";
                         asynTable += "<td>" + value.SaleCompYield + "%</td>";
                         asynTable += "<td>" + value.BuyCompYield + "%</td>";

                         asynTable += asynTag;

                         asynTable += "</tr>";
                     });

                 } else {
                     $("#hdTotalCount").val(0);
                     asynTable += "<tr><td colspan='17' class='txt-center'>" + "조회된 데이터가 없습니다." + "</td></tr>"
                 }

                 $("#tblList2 tbody").append(asynTable);
                 fnCreatePagination('pagination', $("#hdTotalCount").val(), pageNo, pageSize, getPageData);

                 return false;
             };

             var sUser = '<%=Svid_User %>';
             var param = {
                 CompCode1: compCode1,
                 CompCode2: compCode2,
                 CompCode3: compCode3,
                 CompCode4: compCode4,
                 CompCode5: compCode5,
                 CategoryCode: finalCategory,
                 GoodsName: txtGoodsName,
                 GoodsCode: txtGoodsCode,
                 BrandName: txtBrandName,
                 BrandCode: txtBrandCode,
                 GroupCode: txtGroupCode,
                 PageNo: pageNo,
                 PageSize: pageSize,
                 Method: 'GetAdminCompPriceList'
             };

             JajaxSessionCheck('Post', '../../Handler/GoodsHandler.ashx', param, 'json', callback, '<%=Svid_User %>')
         }

         function getPageData() {
             var container = $('#pagination');
             var getPageNum = container.pagination('getSelectedPageNum');
             fnCompSaleInfoList(getPageNum);
             return false;
         } 

         function fnSetDisplayFlag(val) {
             var returnVal = '';
             if (val == '1') {
                 returnVal = '노출';
             }
             else {
                 returnVal = '비노출';
             }
             return returnVal;
         }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
     <div class="all">
        <div class="sub-contents-div">

             <!--제목영역-->
            <div class="sub-title-div">
                <img src="../Images/Goods/netPrice-title.jpg" alt="판매사 단가 조회" />
            </div>
           
            
            <!--탭영역-->
            <div class="sub-tab-div" style="border-bottom:1px solid #ec2028">
                <ul>
                    <li>
                        <a href="OSGoodsPriceSearch.aspx">
                            <img src="../Images/Goods/tab11-on.jpg" alt="판매사 단가 조회" /></a>
                        <a href="OBGoodsPriceSearch.aspx">
                            <img src="../Images/Goods/tab22-off.jpg" alt="구매사 단가 조회" /></a>
                    </li>
                </ul>
            </div>


            <!--검색영역-->
            <div class="bottom-search-div" style="margin-bottom: 20px">
                <table class="notice-search-table" style="width: 100%; margin-top: 30px; margin-bottom: 30px; border: 1px solid #a2a2a2; text-align:center">
                    <tr>
                        <td style="width:70%">
                            <input type="text" runat="server" id="txtCompSearch" placeholder="검색어를 입력하세요" class="" style="padding-left:5px; width: 600px" onkeypress="return fnSaleCompSearchEnter();"/> 
                        </td>
                        <td style="text-align: left">
                            <a onclick="return fnGetCompanyInfo();" class="">
                               <img src="../Images/sub_notice_search_btn.jpg" alt="판매사 검색" style="vertical-align:middle; "/></a>
                        </td>
                    </tr>
                </table>
            </div>


            <!--판매사 리스트 영역 시작-->
            <div class="list-div" style="overflow-y: auto; height:120px">
                <table id="tblList">                
                    <thead>
                        <tr>
                            <th>
                                선택
                            </th>
                            <th>
                                구분
                            </th>
                            <th>
                                판매사코드
                            </th>
                            <th>
                                판매사명
                            </th>
                            <th>
                                대표자명
                            </th>
                            <th>
                                우리안 담당자
                            </th>
                            <th>
                                계약 시작일
                            </th>
                            <th>
                                계약 만료일
                            </th>
                            <th>
                                최종 단가 수정일
                            </th>
                            <th>
                                최종 단가 수정자
                            </th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr id='trEmpty' style="height:40px">
                            <td colspan="10"> 조회된 데이터가 없습니다.</td>
                        </tr>
                    </tbody>
                </table>
            </div>
           
            <!-- 상품검색 -->
            <div>
                <table class="search_table">
                    <thead>
                        <tr>
                            <th colspan="12">상품검색</th>
                        </tr>
                        <tr>
                            <th>카테고리</th>
                            <th style="width:55px">1단</th>
                            <td>
                                <select class="category_select" id="Category01" onchange="fnChangeSubCategoryBind(this,2); return false;" disabled="disabled">
                                    <option value="All">---전체---</option>
                                </select>
                            </td>
                            <th style="width:55px">2단</th>
                            <td>
                                <select class="category_select" id="Category02" onchange="fnChangeSubCategoryBind(this,3); return false;" disabled="disabled">
                                    <option value="All">---전체---</option>
                                </select>
                            </td>
                            <th style="width:55px">3단</th>
                            <td>
                                <select class="category_select" id="Category03" onchange="fnChangeSubCategoryBind(this,4); return false;" disabled="disabled">
                                    <option value="All">---전체---</option>
                                </select>
                            </td>
                            <th style="width:55px">4단</th>
                            <td>
                                <select class="category_select" id="Category04" onchange="fnChangeSubCategoryBind(this,5); return false;" disabled="disabled">
                                    <option value="All">---전체---</option>
                                </select>
                            </td>
                            <th style="width:55px">5단</th>
                            <td>
                                <select class="category_select" id="Category05" onchange="fnChangeSubCategoryBind(this,6); return false;" disabled="disabled">
                                    <option value="All">---전체---</option>
                                </select>
                            </td>
                            <td rowspan="2"><a onclick="return fnCompSaleInfoList(1);"><img alt="검색" src="../../AdminSub/Images/Goods/search-bt-off.jpg"/></a></td>
                        </tr>
                        <tr>
                            <th>상세검색</th>
                            <th>상품명</th>
                            <td><input type="text" class="txtBox" id="txtGoodsName" disabled="disabled"/></td>
                            <th>상품코드</th>
                            <td><input type="text" class="txtBox" id="txtGoodsCode" disabled="disabled"/></td>
                            <th>브랜드명</th>
                            <td><input type="text" class="txtBox" id="txtBrandName" disabled="disabled"/></td>
                            <th>브랜드<br />코드</th>
                            <td><input type="text" class="txtBox" id="txtBrandCode" disabled="disabled"/></td>
                            <th>그룹코드</th>
                            <td><input type="text" class="txtBox" id="txtGroupCode" disabled="disabled"/></td>
                        </tr>
                    </thead>
                </table>
            </div>
            <br />
            
            <div style="text-align:right; margin-bottom:10px;">
                <a><img alt="엑셀다운로드" src="../../Images/Cart/excel-off.jpg" onmouseover="this.src='../../Images/Cart/excel-on.jpg'" onmouseout="this.src='../../Images/Cart/excel-off.jpg'"/></a>
            </div>

            <!-- 상품정보 -->
            <div>
                <table id="tblList2">
                    <thead>
                        <tr>
                            <th rowspan="2">선택<br />
                                <input type="checkbox" id="selectAll" onclick="fnSelectAll(this);" />
                            </th>
                            <th rowspan="2">
                                상품정보
                            </th>
                            <th rowspan="2">
                                내용량
                            </th>
                            <th rowspan="2">
                                그룹코드
                            </th>
                            <th rowspan="2">
                                매입가격<br />(VAT별도)
                            </th>
                            <th rowspan="2">
                                매입가격<br />(VAT포함)
                            </th>
                            <th rowspan="2">
                                구매사 판매가격<br />(VAT포함)
                            </th>
                            <th rowspan="2">
                                판매사 판매가격<br />(VAT포함)
                            </th>
                            <th rowspan="2">
                                가격변동
                            </th>
                            <th rowspan="2">
                                우리안<br />수익률
                            </th>
                            <th rowspan="2">
                                판매사<br />수익률
                            </th>
                            <th rowspan="2">
                                구매사<br />수익률
                            </th>
                            <th id="tdCompSalePrice">
                                판매사판매가격<br />(VAT포함)
                            </th>
                        </tr>
                      
                    </thead>
                    <tbody>
                        <tr>
                            <td colspan="17">조회된 데이터가 없습니다.</td>
                        </tr>
                    </tbody>
                </table>
            </div>
            <br />
            <br />
                <!-- 페이징 -->
                <input type="hidden" id="hdTotalCount" />
                <div style="margin: 0 auto; text-align: center">
                    <div id="pagination" class="page_curl" style="display: inline-block"></div>
                </div>
        </div>
     </div>


</asp:Content>

