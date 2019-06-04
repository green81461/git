<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Master/AdminMasterPage.master" AutoEventWireup="true" CodeFile="OBGoodsPriceManagement.aspx.cs" Inherits="Admin_Goods_OBGoodsPriceManagement" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <link href="../Content/Goods/goods.css" rel="stylesheet" />
    <link href="../Content/popup.css" rel="stylesheet" />
   
    <script type="text/javascript">
        $(document).ready(function () {
            $("#goodspopup_Tbody").on("mouseover", "tr", function () {
                $("#goodspopup_Tbody tr").css("cursor", "pointer");
            });

            $("#goodspopup_Tbody").on("click", "tr", function () {

                //초기화
                $("#hdSelectCode").val('');
                $("#hdSelectName").val('');
                $("#goodspopup_Tbody tr").css("background-color", "");

                $(this).css("background-color", "#ffe6cc");

                var selectCode = $(this).find("#SaleComp_Code").text();
                var selectName = $(this).find("#SaleComp_Name").text();
                $("#hdSelectCode").val(selectCode);
                $("#hdSelectName").val(selectName);

            });
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

        //주문 업체 팝업
        function fnSearchSaleCompPopup() {
            var target = $('#searchTarget').val();
            if (target == 'SALE') {  //판매사일때
                $("#txtPopSearchSaleComp").val($("#<%=txtSaleCompSearch.ClientID%>").val());
                fnGetCompanyList_A(1);

                fnOpenDivLayerPopup('orderSaleCodediv');

                //var e = document.getElementById('orderSaleCodediv');

                //if (e.style.display == 'block') {
                //    e.style.display = 'none';

                //} else {
                //    e.style.display = 'block';
                //}
            }
            else {

                fnGetCompanyInfo($("#<%=txtSaleCompSearch.ClientID%>").val(), 'BUY', 1);
            }

            return false;
        }

        //주문 업체 목록 조회
        function fnGetCompanyList_A(pageNum) {


            var keyword = $("#txtPopSearchSaleComp").val();
            var pageSize = 10;

            var callback = function (response) {
                $('#tblPopupSaleComp tbody').empty(); //테이블 클리어
                var newRowContent = "";

                if (!isEmpty(response)) {

                    $.each(response, function (key, value) { //테이블 추가
                        if (key == 0) $("#hdTotalCount").val(value.TotalCount);

                        newRowContent += "<tr style='height: 30px'>";
                        newRowContent += "<td id='SaleComp_Name' style='width: 100px' class='txt-center'>" + value.Company_Name + "</td>"; //회사명
                        newRowContent += "<td id='SaleComp_Code' style='width: 100px' class='txt-center'>" + value.Company_Code + "</td> </tr>"; //회사코드
                    });
                } else {
                    newRowContent += "<tr><td colspan='3' class='txt-center'>" + "조회된 데이터가 없습니다." + "</td></tr>"
                    $("#hdTotalCount").val(0);
                }
                $('#tblPopupSaleComp tbody').append(newRowContent);

                fnCreatePagination('pagination', $("#hdTotalCount").val(), pageNum, pageSize, getPageData);
                return false;
            }

            var param = {
                Flag: 'CompList_A',
                CompNm: keyword,
                PageNo: pageNum,
                PageSize: pageSize,
            };

            JajaxSessionCheck('Post', '../../Handler/Admin/CompanyHandler.ashx', param, 'json', callback, '<%=Svid_User%>');
        }
        function getPageData() {
            var container = $('#pagination');
            var getPageNum = container.pagination('getSelectedPageNum');
            fnGetCompanyList_A(getPageNum);
            return false;
        }

        function fnSaleCompSearchEnter() {
            if (event.keyCode == 13) {
                fnSearchSaleCompPopup();
                return false;
            }
            else
                return true;

        }

        function fnPopupOkSaleComp() {

            fnGetCompanyInfo($("#hdSelectCode").val(), 'SALE', 1);
            fnClosePopup('orderSaleCodediv');
            return false;
        }

        //선택된 업체 정보 조회
        function fnGetCompanyInfo(searchKeyword, searchType, pageNum) {
            $('#hdSelectBuyCodes').val('');
            $('#hdSelectBuyCompCode1').val('');
            $('#hdSelectBuyCompCode2').val('');
            $('#hdSelectBuyCompCode3').val('');
            $('#hdSelectBuyCompCode4').val('');
            $('#hdSelectBuyCompCode5').val('');
            $('#thHeader1').attr('colspan', '');
            $('#trHeader1').empty();
            $('#tblList2 tbody').empty(); //단가리스트 테이블 클리어
            $('#tblList2 tbody').append("<tr><td colspan='18' class='txt-center'>리스트가 없습니다.</td></tr>");
            $('#compPricepagination').css('display', 'none');
            var callback = function (response) {
                $('#tblBuyComp tbody').empty(); //테이블 클리어
                var newRowContent = "";

                if (!isEmpty(response)) {

                    $.each(response, function (key, value) { //테이블 추가
                        $("#hdBuyCompTotalCount").val(value.TotalCount);
                        newRowContent += "<tr style='height:40px'>";
                        newRowContent += "<td class='txt-center'><input type='checkbox' id='cbBuyComp'><input type='hidden' id='hdBuyCompCode' value='" + value.Company_Code + "'/></td>"; //선택
                        newRowContent += "<td class='txt-center'>구매사</td>"; //업체정보
                        newRowContent += "<td class='txt-center'>" + value.Company_Code + "</td>";  //구매사코드
                        newRowContent += "<td class='txt-center' id='tdCompName'>" + value.Company_Name + "</td>";  //구매사명
                        newRowContent += "<td class='txt-center'>" + value.DelegateName + "</td>";  //대표자명
                        //newRowContent += "<td class='txt-center'>" + value.OrderSaleCompCode + "</td>";  //판매사코드
                        //newRowContent += "<td class='txt-center'>" + value.OrderSaleCompName + "</td>";  //판매사명
                        newRowContent += "<td class='txt-center'>" + value.AdminUserName + "</td>";  //소셜위드담당자
                        newRowContent += "<td class='txt-center'>" + value.AtypeRole + "</td>";  //유형
                        newRowContent += "<td class='txt-center'>" + fnOracleDateFormatConverter(value.CpConStartDate) + "</td>";  //계약시작일
                        newRowContent += "<td class='txt-center'>" + fnOracleDateFormatConverter(value.CpConEndDate) + "</td>";  //계약만료일
                        newRowContent += "<td class='txt-center'>" + fnOracleDateFormatConverter(value.CompanyPriceDate) + "</td>";  //최종단가수정일
                        newRowContent += "<td class='txt-center'>" + value.CompanyPriceName + "</td>";  //최종단가수정자
                        newRowContent += "</tr>";
                    });
                } else {
                    newRowContent += "<tr style='height:40px'><td colspan='11' class='txt-center'>" + "조회된 데이터가 없습니다." + "</td></tr>"
                    $('#buyComppagination').css('display', 'none');
                }
                $('#tblBuyComp tbody').append(newRowContent);
                fnCreatePagination('buyComppagination', $("#hdBuyCompTotalCount").val(), pageNum, 5, getBuyCompPageData);
                return false;
            }
           
            var param = {
                Flag: 'GetCompPriceCompanyList',
                Gubun: 'BU',
                SearchKeyword: searchKeyword,
                SaleSearchType: '',
                BuySearchType: searchType,
                PageNo: pageNum,
                PageSize: 5,
            };

             var beforeSend = function () {
                $('#divLoading').css('display', '');
            }
            var complete = function () {
                $('#divLoading').css('display', 'none');
            }
            JqueryAjax("Post", "../../Handler/Admin/CompanyHandler.ashx", true, false, param, "json", callback, beforeSend, complete, true, '<%=Svid_User %>');

            // JajaxSessionCheck('Post', '../../Handler/Admin/CompanyHandler.ashx', param, 'json', callback, '<%=Svid_User%>');
        }

        function getBuyCompPageData() {
            var container = $('#buyComppagination');
            var getPageNum = container.pagination('getSelectedPageNum');
            var target = $('#searchTarget').val();
            var keyword = '';
            if (target == 'SALE') {
                keyword = $("#hdSelectCode").val();
            }
            else {
                keyword = $('#<%= txtSaleCompSearch.ClientID%>').val();
            }
            fnGetCompanyInfo(keyword, target, getPageNum);
            return false;
        }

        //단가리스트 조회
        function fnGetCompPriceList(pageNum) {

            // $('#divLoading').css('display', '');
            var callback = function (response) {


                var newRowContent = "";
                var priceCheck = true;
                if (!isEmpty(response)) {

                    $('#tblList2 tbody').empty(); //테이블 클리어
                    $.each(response, function (key, value) { //테이블 추가

                        $("#hdCompPriceTotalCount").val(value.TotalCount);
                        var disableStyle = '';
                        if (value.GoodsDCYN == '2' || value.GoodsDisplayFlag == '2') {
                            disableStyle = 'disabled';
                        }
                        newRowContent += "<tr style='height:40px'>";
                        newRowContent += "<td class='txt-center'><input type='checkbox' id='cbSelect' " + disableStyle + "/>";
                        newRowContent += "<input type='hidden' id='hdCategoryCode' value='" + value.GoodsFinalCategoryCode + "'/>";
                        newRowContent += "<input type='hidden' id='hdGroupCode' value='" + value.GoodsGroupCode + "'/>";
                        newRowContent += "<input type='hidden' id='hdGoodsCode' value='" + value.GoodsCode + "'/>";
                        newRowContent += "<input type='hidden' id='hdCustPrice' value='" + value.GoodsCustPriceVat + "'/>";
                        newRowContent += "<input type='hidden' id='hdGoodsSalePriceVat' value='" + value.GoodsSalePriceVat + "'/>";
                        newRowContent += "</td>"; //선택
                        newRowContent += "<td style='text-align:left'>" + value.GoodsCode + "<br/>" + value.GoodsFinalName + "(" + value.GoodsModel + ")<br/>*" + value.BrandName + "<br/>" + value.GoodsOptionSummaryValues + "</td>";  //상품정보
                        newRowContent += "<td class='txt-center'>" + value.GoodsUnitName + "</td>";  //내용량
                        newRowContent += "<td class='txt-center'>" + value.GoodsGroupCode + "</td>";  //그룹코드
                        newRowContent += "<td class='txt-center' style='background-color:#FFEBFF'>" + numberWithCommas(value.GoodsBuyPrice) + "원<br/>";  //매입가격
                        newRowContent += "<div id='divVatPrice' style='float:left; height:20px; padding-left:7px'><img src='/Images/tax_icon.png' width='20' height='20'/><label style='color:red' id='lblPriceVAT'>" + numberWithCommas(value.GoodsBuyPriceVat) + "</label><label style='color:red'>원</label></div></td>";  //매입가격
                        newRowContent += "<td class='txt-center' style='background-color:#E8FFFF'>" + numberWithCommas(value.GoodsSalePrice) + "원<br/>";  //구매사 판매가격
                        newRowContent += "<div id='divVatPrice' style='float:left; height:20px; padding-left:7px'><img src='/Images/tax_icon.png' width='20' height='20'/><label style='color:red' id='lblPriceVAT'>" + numberWithCommas(value.GoodsSalePriceVat) + "</label><label style='color:red'>원</label></div></td>";  //구매사 판매가격
                        newRowContent += "<td class='txt-center' style='background-color:#FFEBFF'>" + numberWithCommas(value.GoodsCustPrice) + "원<br/>";  //판매사 판매가격
                        newRowContent += "<div id='divVatPrice' style='float:left; height:20px; padding-left:7px'><img src='/Images/tax_icon.png' width='20' height='20'/><label style='color:red' id='lblPriceVAT'>" + numberWithCommas(value.GoodsCustPriceVat) + "</label><label style='color:red'>원</label></div></td>";  //판매사 판매가격 
                        var displayColor = '#FFFFFF';
                        if (value.GoodsDCYN == '2' || value.GoodsDisplayFlag =='2') {
                            displayColor = '#FAED7D';
                        }
                        newRowContent += "<td class='txt-center' style='background-color:" + displayColor+"'>" + fnSetDCYN(value.GoodsDCYN) + "<br/>(" + fnSetDisplayFlag(value.GoodsDisplayFlag) + ")</td>";  //가격변동
                        newRowContent += "<td class='txt-center' style='background-color:#FFEBFF'>" + value.UrianYield + "%</td>";  //소셜위드수익률
                        newRowContent += "<td class='txt-center' style='background-color:#FFEBFF'>" + value.SaleCompYield + "%</td>";  //판매사수익률
                        newRowContent += "<td class='txt-center' style='background-color:#FFEBFF'>" + value.BuyCompYield + "%</td>";  //구매사수익률

                        var colColor1 = 'background-color:#E8FFFF';
                        var colColor2 = 'background-color:#E8FFFF';
                        var colColor3 = 'background-color:#E8FFFF';
                        var colColor4 = 'background-color:#E8FFFF';
                        var colColor5 = 'background-color:#E8FFFF';

                        if (!isEmpty(value.TempCompPrice_1) && value.GoodsSalePrice > value.TempCompPrice_1) {
                            colColor1 = 'background-color:#FFC6C6';
                            priceCheck = false;
                        }

                        if (!isEmpty(value.TempCompPrice_2) && value.GoodsSalePrice > value.TempCompPrice_2) {
                            colColor2 = 'background-color:#FFC6C6';
                            priceCheck = false;
                        }

                        if (!isEmpty(value.TempCompPrice_3) && value.GoodsSalePrice > value.TempCompPrice_3) {
                            colColor3 = 'background-color:#FFC6C6';
                            priceCheck = false;
                        }

                        if (!isEmpty(value.TempCompPrice_4) && value.GoodsSalePrice > value.TempCompPrice_4) {
                            colColor4 = 'background-color:#FFC6C6';
                            priceCheck = false;
                        }

                        if (!isEmpty(value.TempCompPrice_5) && value.GoodsSalePrice > value.TempCompPrice_5) {
                            colColor5 = 'background-color:#FFC6C6';
                            priceCheck = false;
                        }

                        var price1 = '';
                        if (!isEmpty(value.TempCompPrice_1)) {
                            price1 = numberWithCommas(value.TempCompPrice_1);
                        }
                        var price2 = '';
                        if (!isEmpty(value.TempCompPrice_2)) {
                            price2 = numberWithCommas(value.TempCompPrice_2);
                        }
                        var price3 = '';
                        if (!isEmpty(value.TempCompPrice_3)) {
                            price3 = numberWithCommas(value.TempCompPrice_3);
                        }
                        var price4 = '';
                        if (!isEmpty(value.TempCompPrice_4)) {
                            price4 = numberWithCommas(value.TempCompPrice_4);
                        }
                        var price5 = '';
                        if (!isEmpty(value.TempCompPrice_5)) {
                            price5 = numberWithCommas(value.TempCompPrice_5);
                        }


                       

                        if (!isEmpty($('#hdSelectBuyCompCode1').val())) {

                            newRowContent += "<td class='txt-center' style='" + colColor1 + "; width:150px'><input type='text' id='txtPrice1' style='width:80%; ' value='" + price1 + "' " + disableStyle + " onkeyup='return fnAutoComma(this);' onkeypress='return onlyNumbers(event);'>원<input type='hidden' id='hdRowCompCode' value='" + $('#hdSelectBuyCompCode1').val() + "'><div id='divVatPrice' style='float:left; height:20px; padding-left:7px'>";  //판매사 판매가격입력
                            if (!isEmpty(value.TempCompPriceVat_1)) {
                                newRowContent += "<img src='/Images/tax_icon.png' width='20' height='20'/><label style='color:red' id='lblPriceVAT'>" + numberWithCommas(value.TempCompPriceVat_1) + "</label><label style='color:red'>원</label>";
                            }
                            newRowContent += "</div></td>";
                        }
                        if (!isEmpty($('#hdSelectBuyCompCode2').val())) {
                            newRowContent += "<td class='txt-center' style='" + colColor2 + "; width:150px'><input type='text' id='txtPrice2' style='width:80%; ' value='" + price2 + "' " + disableStyle + " onkeyup='return fnAutoComma(this);' onkeypress='return onlyNumbers(event);'>원<input type='hidden' id='hdRowCompCode' value='" + $('#hdSelectBuyCompCode2').val() + "'><div id='divVatPrice' style='float:left; height:20px; padding-left:7px'>";  //판매사 판매가격입력
                            if (!isEmpty(value.TempCompPriceVat_2)) {
                                newRowContent += "<img src='/Images/tax_icon.png' width='20' height='20'/><label style='color:red' id='lblPriceVAT'>" + numberWithCommas(value.TempCompPriceVat_2) + "</label><label style='color:red'>원</label>";
                            }
                            newRowContent += "</div></td>";
                        }
                        if (!isEmpty($('#hdSelectBuyCompCode3').val())) {
                            newRowContent += "<td class='txt-center' style='" + colColor3 + "; width:150px'><input type='text' id='txtPrice3' style='width:80%; ' value='" + price3 + "' " + disableStyle + " onkeyup='return fnAutoComma(this);' onkeypress='return onlyNumbers(event);'>원<input type='hidden' id='hdRowCompCode' value='" + $('#hdSelectBuyCompCode3').val() + "'><div id='divVatPrice' style='float:left; height:20px; padding-left:7px'>";  //판매사 판매가격입력
                            if (!isEmpty(value.TempCompPriceVat_3)) {
                                newRowContent += "<img src='/Images/tax_icon.png' width='20' height='20'/><label style='color:red' id='lblPriceVAT'>" + numberWithCommas(value.TempCompPriceVat_3) + "</label><label style='color:red'>원</label>";
                            }
                            newRowContent += "</div></td>";
                        }
                        if (!isEmpty($('#hdSelectBuyCompCode4').val())) {
                            newRowContent += "<td class='txt-center' style='" + colColor4 + "; width:150px'><input type='text' id='txtPrice4' style='width:80%; ' value='" + price4 + "' " + disableStyle + " onkeyup='return fnAutoComma(this);' onkeypress='return onlyNumbers(event);'>원<input type='hidden' id='hdRowCompCode' value='" + $('#hdSelectBuyCompCode4').val() + "'><div id='divVatPrice' style='float:left; height:20px; padding-left:7px'>";  //판매사 판매가격입력
                            if (!isEmpty(value.TempCompPriceVat_4)) {
                                newRowContent += "<img src='/Images/tax_icon.png' width='20' height='20'/><label style='color:red' id='lblPriceVAT'>" + numberWithCommas(value.TempCompPriceVat_4) + "</label><label style='color:red'>원</label>";
                            }
                            newRowContent += "</div></td>";
                        }
                        if (!isEmpty($('#hdSelectBuyCompCode5').val())) {
                            newRowContent += "<td class='txt-center' style='" + colColor5 + "; width:150px'><input type='text' id='txtPrice5' style='width:80%; ' value='" + price5 + "' " + disableStyle + " onkeyup='return fnAutoComma(this);' onkeypress='return onlyNumbers(event);'>원<input type='hidden' id='hdRowCompCode' value='" + $('#hdSelectBuyCompCode5').val() + "'><div id='divVatPrice' style='float:left; height:20px; padding-left:7px'>";  //판매사 판매가격입력
                            if (!isEmpty(value.TempCompPriceVat_5)) {
                                newRowContent += "<img src='/Images/tax_icon.png' width='20' height='20'/><label style='color:red' id='lblPriceVAT'>" + numberWithCommas(value.TempCompPriceVat_5) + "</label><label style='color:red'>원</label>";
                            }
                            newRowContent += "</div></td>";
                        }


                        newRowContent += "</tr>";


                    });
                } else {
                    $("#hdCompPriceTotalCount").val(0);
                    newRowContent += "<tr style='height:40px'><td colspan='17' class='txt-center'>" + "조회된 데이터가 없습니다." + "</td></tr>"

                }
                // $('#divLoading').css('display', 'none');
                $('#tblList2 tbody').append(newRowContent);
                $('#compPricepagination').css('display', 'inline-block');
                fnCreatePagination('compPricepagination', $("#hdCompPriceTotalCount").val(), pageNum, 50, getCompPricePageData);
                if (!priceCheck) {
                    alert('구매사 판매가격이 역마진 가격으로 입력되었습니다. 확인바랍니다.');
                }
                return false;
            }

            var categoryCode = $('#Category01').val();
           
            if ($('#Category02').val() == 'All' && $('#Category03').val() == 'All' && $('#Category04').val() == 'All' && $('#Category05').val() == 'All') {
                categoryCode = $('#Category01').val()
            }
            else if ($('#Category03').val() == 'All' && $('#Category04').val() == 'All' && $('#Category05').val() == 'All') {
                categoryCode = $('#Category02').val()
            }
            else if ($('#Category04').val() == 'All' && $('#Category05').val() == 'All') {
                categoryCode = $('#Category03').val()
            }
            else if ($('#Category05').val() == 'All') {
                categoryCode = $('#Category04').val()
            }
            var param = {
                Method: 'GetAdminCompPriceList',
                SaleCompCode: $("#hdSelectCode").val(),
                CompCode1: $('#hdSelectBuyCompCode1').val(),
                CompCode2: $('#hdSelectBuyCompCode2').val(),
                CompCode3: $('#hdSelectBuyCompCode3').val(),
                CompCode4: $('#hdSelectBuyCompCode4').val(),
                CompCode5: $('#hdSelectBuyCompCode5').val(),
                CategoryCode: categoryCode,
                GoodsName: $("#txtGoodsName").val(),
                GoodsCode: $("#txtGoodsCode").val().trim().toUpperCase(),
                BrandCode: $("#txtBrandCode").val(),
                BrandName: $("#txtBrandName").val(),
                GroupCode: $("#txtGroupCode").val(),
                PageNo: pageNum,
                PageSize: 50,
            };

            var beforeSend = function () {
                $('#divLoading').css('display', '');
            }
            var complete = function () {
                $('#divLoading').css('display', 'none');
            }
            JqueryAjax("Post", "../../Handler/GoodsHandler.ashx", true, false, param, "json", callback, beforeSend, complete, true, '<%=Svid_User %>');

            // JajaxSessionCheck('Post', '../../Handler/GoodsHandler.ashx', param, 'json', callback, '<%=Svid_User%>');
        }

        function getCompPricePageData() {
            var container = $('#compPricepagination');
            var getPageNum = container.pagination('getSelectedPageNum');
            fnGetCompPriceList(getPageNum);
            return false;
        }

        function fnSetDCYN(val) {
            var returnVal = '';
            if (val == '1') {
                returnVal = '가능';
            }
            else {
                returnVal = '불가능';
            }
            return returnVal;
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

        function fnCompPriceBind() {

            var selectLength = $('#tblBuyComp tbody input[type="checkbox"]:checked').length;
            if (selectLength < 1) {
                alert('구매사를 선택해 주세요.');
                return false;
            }

            if (selectLength > 5) {
                alert('구매사를 5개 이하로 선택해 주세요.');
                return false;
            }
            if ($('#Category01').val() == 'All') {
                if (($("#txtGoodsCode").val() == '' && $("#txtGroupCode").val() == '')) {
                    alert('1단 카테고리는 필수 선택 조건입니다.');
                    return false;
                }
                
               
            }

            $('#hdSelectBuyCodes').val('');
            $('#hdSelectBuyCompCode1').val('');
            $('#hdSelectBuyCompCode2').val('');
            $('#hdSelectBuyCompCode3').val('');
            $('#hdSelectBuyCompCode4').val('');
            $('#hdSelectBuyCompCode5').val('');
            $('#thHeader1').attr('colspan', '');
            $('#trHeader1').empty();
            $('#tblList2 tbody').empty(); //테이블 클리어
            var i = 1;
            var codes = '';
            var headerContent = "";

            $('#tblBuyComp input[type="checkbox"]').each(function () {
                if ($(this).prop('checked') == true) {
                    $('#hdSelectBuyCompCode' + i).val($(this).next('#hdBuyCompCode').val());
                    codes += $(this).next('#hdBuyCompCode').val() + '/';
                    headerContent += '<th style="width:150px; background-color:#E8FFFF">' + $(this).parent().parent().find('#tdCompName').text() + '</th>';
                    i++;
                }
            });
            $('#hdSelectBuyCodes').val(codes);
            $('#thHeader1').attr('colspan', i - 1);
            $('#thHeader1').css('display', '');
            $('#trHeader1').css('display', '');
            $('#compPricepagination').css('display', 'none');
            $('#trHeader1').append(headerContent);

            fnGetCompPriceList(1);
            return false;
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

        //단가 일괄적용

        var is_sending = false;
        function fnMultiPriceSet() {

            var selectLength = $('#tblList2 tbody input[type="checkbox"]:checked').length;
            if (selectLength < 1) {
                alert('상품을 선택해 주세요');
                return false;

            }

            if (isEmpty($('#txtMultiSavePrice').val())) {
                alert('적용값을 입력해 주세요.');
                return false;
            }
            if (!confirm('적용하시겠습니까?')) {
                return false;
            }
            var callback = function (response) {
                if (response == 'OK') {
                    alert('적용되었습니다.');
                    fnGetCompPriceList($('#compPricepagination').pagination('getSelectedPageNum'));
                }
                else {
                    alert('시스템 오류입니다. 관리자에게 문의하세요.');
                }
                return false;
            };

            var categoryCodeArray = '';
            var goodsGroupCodeArray = '';
            var codeArray = '';
            $('#tblList2 tbody input[type="checkbox"]').each(function () {
                if ($(this).prop('checked') == true) {
                    var goodsCode = $(this).parent().parent().children().find('#hdGoodsCode').val();
                    var goodsGroupCode = $(this).parent().parent().children().find('#hdGroupCode').val();
                    var categoryCode = $(this).parent().parent().children().find('#hdCategoryCode').val();
                    categoryCodeArray += categoryCode + '/';
                    goodsGroupCodeArray += goodsGroupCode + '/';
                    codeArray += goodsCode + '/';
                }
            });

            var param = {
                Method: 'MultiSaveBuyCompPrice',
                CompCodes: $('#hdSelectBuyCodes').val().slice(0, -1),
                Gubun: 'BU',
                PriceId:'<%= UserInfoObject.Id%>',
                CtgrCodes: categoryCodeArray.slice(0, -1),
                GroupCodes: goodsGroupCodeArray.slice(0, -1),
                GoodsCodes: codeArray.slice(0, -1),
                Unit: $('#selectUnit').val(),
                Sign: $('#selectGubun').val(),
                Price: $('#txtMultiSavePrice').val(),
            };


            var beforeSend = function () {
                is_sending = true;
            }
            var complete = function () {
                is_sending = false;
            }

            if (is_sending) return false;
            JajaxDuplicationCheck('Post', '../../Handler/GoodsHandler.ashx', param, 'text', callback, beforeSend, complete, true, '<%=Svid_User%>');

            return false;
        }


        function fnPriceSet() {
            var selectLength = $('#tblList2 tbody input[type="checkbox"]:checked').length;
            if (selectLength < 1) {
                alert('상품을 선택해 주세요');
                return false;

            }

            var nullFlag = true;
            var checkBuyPriceFlag = true;

            $('#tblList2 tbody input[type="checkbox"]').each(function () {
                if ($(this).prop('checked') == true) {

                    var txtPrices = $(this).parent().parent().children().find('input[id^=txtPrice]');
                    var salePrice = $(this).parent().parent().children().find('input[id*="hdGoodsSalePriceVat"]').val();
                    txtPrices.each(function () {
                        if (!isEmpty($(this).val())) {
                            nullFlag = false;
                            if (parseInt(salePrice) > parseInt($(this).val().replace(/[^0-9 | ^.]/g, ''))) {
                                checkBuyPriceFlag = false;
                            }
                        }
                    })
                }
            });

            if (nullFlag) {
                alert('체크된 항목은 판매사 가격이 하나라도 입력돼야 합니다.');
                return false;
            }

            //if (!checkBuyPriceFlag) {
            //    alert('구매사 판매가격이 역마진 가격으로 입력되었습니다. 확인바랍니다.');
            //}

            if (!confirm('적용하시겠습니까?')) {
                return false;
            }


            var errorFlag = false;
            $('#tblList2 tbody input[type="checkbox"]').each(function () {
                if ($(this).prop('checked') == true) {

                    var callback = function (response) {
                        if (response != 'OK') {
                            errorFlag = true;
                            return false;
                        }
                    };

                    var goodsCode = $(this).parent().parent().children().find('#hdGoodsCode').val();
                    var goodsGroupCode = $(this).parent().parent().children().find('#hdGroupCode').val();
                    var categoryCode = $(this).parent().parent().children().find('#hdCategoryCode').val();
                    var txtPrices = $(this).parent().parent().children().find('input[id^=txtPrice]');
                    var priceArray = '';
                    var compCodesArray = ''
                    txtPrices.each(function () {
                        if (!isEmpty($(this).val())) {
                            priceArray += $(this).val().replace(/[^0-9 | ^.]/g, '') + '/';
                            compCodesArray += $(this).next('#hdRowCompCode').val() + '/';
                        }

                    })

                    var param = {
                        Method: 'SaveBuyCompPrice',
                        CompCodes: compCodesArray.slice(0, -1),
                        Gubun: 'BU',
                        PriceId:'<%= UserInfoObject.Id%>',
                        CtgrCode: categoryCode,
                        GroupCode: goodsGroupCode,
                        GoodsCode: goodsCode,
                        Prices: priceArray.slice(0, -1),
                    };

                    var beforeSend = function () {
                        is_sending = true;
                    }
                    var complete = function () {
                        is_sending = false;
                    }

                    if (is_sending) return false;

                    $.ajax({
                        type: 'Post',
                        url: '../../Handler/GoodsHandler.ashx',
                        cache: false,
                        data: param,
                        dataType: 'text',
                        beforeSend: beforeSend,
                        complete: complete,
                        success: callback,
                        async: false,
                        error: function (xhr, status, error) {
                            if (xhr.readyState == 0 || xhr.status == 0) {
                                return; //Skip this error
                            }
                            alert('xhr: ' + xhr + 'status: ' + status + 'Error: ' + error + "\n오류가 발생했습니다. 잠시 후 다시 시도해 주세요.");
                        }
                    });
                }
            });
            if (errorFlag == false) {
                alert('적용되었습니다.');
                fnGetCompPriceList($('#compPricepagination').pagination('getSelectedPageNum'));
            }
            else {
                alert('시스템 오류입니다. 관리자에게 문의하세요.');
                return false;
            }
            return false;
        }


        function fnPriceDelete() {
            var selectLength = $('#tblList2 tbody input[type="checkbox"]:checked').length;
            if (selectLength < 1) {
                alert('상품을 선택해 주세요');
                return false;

            }
            
            if (!confirm('삭제하시겠습니까?')) {
                return false;
            }


            var errorFlag = false;
            $('#tblList2 tbody input[type="checkbox"]').each(function () {
                if ($(this).prop('checked') == true) {

                    var callback = function (response) {
                        if (response != 'OK') {
                            errorFlag = true;
                            return false;
                        }
                    };

                    var goodsCode = $(this).parent().parent().children().find('#hdGoodsCode').val();
                    var goodsGroupCode = $(this).parent().parent().children().find('#hdGroupCode').val();
                    var categoryCode = $(this).parent().parent().children().find('#hdCategoryCode').val();
                    var txtPrices = $(this).parent().parent().children().find('input[id^=txtPrice]');
                    var priceArray = '';
                    var compCodesArray = ''
                    txtPrices.each(function () {
                        if (!isEmpty($(this).val())) {
                            compCodesArray += $(this).next('#hdRowCompCode').val() + '/';
                        }

                    })

                    var param = {
                        Method: 'DeleteBuyCompPrice',
                        CompCodes: compCodesArray.slice(0, -1),
                        Gubun: 'BU',
                        PriceId: '<%= UserInfoObject.Id%>',
                        CtgrCode: categoryCode,
                        GroupCode: goodsGroupCode,
                        GoodsCode: goodsCode,
                    };

                    var beforeSend = function () {
                        is_sending = true;
                    }
                    var complete = function () {
                        is_sending = false;
                    }

                    if (is_sending) return false;

                    $.ajax({
                        type: 'Post',
                        url: '../../Handler/GoodsHandler.ashx',
                        cache: false,
                        data: param,
                        dataType: 'text',
                        beforeSend: beforeSend,
                        complete: complete,
                        success: callback,
                        async: false,
                        error: function (xhr, status, error) {
                            if (xhr.readyState == 0 || xhr.status == 0) {
                                return; //Skip this error
                            }
                            alert('xhr: ' + xhr + 'status: ' + status + 'Error: ' + error + "\n오류가 발생했습니다. 잠시 후 다시 시도해 주세요.");
                        }
                    });
                }
            });
            if (errorFlag == false) {
                alert('삭제되었습니다.');
                fnGetCompPriceList($('#compPricepagination').pagination('getSelectedPageNum'));
            }
            else {
                alert('시스템 오류입니다. 관리자에게 문의하세요.');
                return false;
            }
            return false;
        }

        //RealTime Comma찍기
        function fnAutoComma(el) {
            //var price = $(el).val();

            //price = price.replace(/[^\d]+/g, ''); // (,)지우기          
            //$(el).val(numberWithCommas(price));   //콤마설정

            //$(el).parent().parent().children().find("input[id^=cbSelect]").not(":disabled").prop("checked", true); //자동 체크박스 선택

            if ($(el).parent().find('#divVatPrice').is(':empty') == true) {
                $(el).parent().find('#divVatPrice').append("<img src='/Images/tax_icon.png' width='20' height='20'/><label style='color:red' id='lblPriceVAT'/><label style='color:red'>원</label>");
            }
            var price = $(el).val();

            price = price.replace(/[^\d]+/g, ''); // (,)지우기          

            var txtpriceVat = price * 1.1; //매입가격(VAT포함)         
            txtpriceVat = roundXL(txtpriceVat, -1);
            $(el).val(numberWithCommas(price));   //콤마설정
            $(el).parent().children().find('#lblPriceVAT').text(numberWithCommas(txtpriceVat));   //콤마설정
            $(el).parent().parent().children().find("input[id^=cbSelect]").not(":disabled").prop("checked", true); //자동 체크박스 선택
        }

        function roundXL(num, digits) {
            digits = Math.pow(10, digits);
            return Math.round(num * digits) / digits;
        };

        function fnSearchGoodsEnter() {
            if (event.keyCode == 13) {
                fnCompPriceBind();
                return false;
            }
        }

        function fnPopSaleCompEnter() {
            if (event.keyCode == 13) {
                fnGetCompanyList_A(1);
                return false;
            }
            else
                return true;
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div class="sub-contents-div" style="min-height: 1500px">
        <div class="sub-title-div">
                <p class="p-title-mainsentence">
                    구매사 단가관리
                    <span class="span-title-subsentence"></span>
                </p>
        </div>
        <!--탭영역-->
            <div class="div-main-tab" style="width: 100%; ">
                <ul>
                    <li class='tabOff' style="width: 185px;" onclick="fnTabClickRedirect('RMPGoodsPriceManagement');">
                        <a onclick="fnTabClickRedirect('RMPGoodsPriceManagement');">RMP 단가관리</a>
                     </li>
                    <li class='tabOff' style="width: 185px;" onclick="fnTabClickRedirect('OSGoodsPriceManagement');">
                        <a onclick="fnTabClickRedirect('OSGoodsPriceManagement');">판매사 단가관리</a>
                     </li>
                    <li class='tabOn' style="width: 185px;" onclick="fnTabClickRedirect('OBGoodsPriceManagement');">
                         <a onclick="fnTabClickRedirect('OBGoodsPriceManagement');">구매사 단가관리</a>
                    </li>
                </ul>
            </div>
        <div class="bottom-search-div" style="margin-bottom: 20px">
            <table class="tbl_search" style="margin-top: 30px; margin-bottom: 30px;">
                <tr>
                    <td style="width:80px"></td>
                    <td style="width:80px">
                         <select id="searchTarget" style="height:28px">
                            <option value="SALE">판매사</option>
                            <option value="BUY">구매사</option>
                        </select>
                    </td>
                    <td>
                        <asp:TextBox runat="server" placeholder="검색어를 입력하세요." Style="width: 600px" ID="txtSaleCompSearch" OnKeyPress="return fnSaleCompSearchEnter();"></asp:TextBox>
                        <asp:Button runat="server" CssClass="mainbtn type1" ID="btnGoodsSearch" Text="검색" Width="75" Height="25" Style="vertical-align: middle;" OnClientClick="return fnSearchSaleCompPopup();" />
                    </td>
                </tr>
            </table>
        </div>

        <!-- 구매사 정보 -->
        <div>
            <input type="hidden" id="hdSelectBuyCompCode1" />
            <input type="hidden" id="hdSelectBuyCompCode2" />
            <input type="hidden" id="hdSelectBuyCompCode3" />
            <input type="hidden" id="hdSelectBuyCompCode4" />
            <input type="hidden" id="hdSelectBuyCompCode5" />
            <input type="hidden" id="hdSelectBuyCodes" />

            <table id="tblBuyComp" class="tbl_main">
                <thead>
                    <tr>
                        <th class="txt-center" style="width: 60px">선택</th>
                        <th class="txt-center" style="width: 70px">업체정보</th>
                        <th class="txt-center" style="width: 70px">구매사코드</th>
                        <th class="txt-center" style="width: 180px">구매사명</th>
                        <th class="txt-center" style="width: 100px">대표자명</th>
                       <%-- <th class="txt-center" style="width: 70px">판매사코드</th>
                        <th class="txt-center" style="width: 180px">판매사명</th>--%>
                        <th class="txt-center" style="width: 70px">소셜위드<br />
                            담당자</th>
                        <th class="txt-center" style="width: 60px">유형</th>
                        <th class="txt-center" style="width: 80px">계약 시작일</th>
                        <th class="txt-center" style="width: 80px">계약 만료일</th>
                        <th class="txt-center" style="width: 80px">단가수정일</th>
                        <th class="txt-center" style="width: 70px">단가수정자</th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td class="txt-center" colspan="11">리스트가 없습니다.
                        </td>
                    </tr>
                </tbody>

            </table>
            <!-- 페이징 처리 -->
            <div style="margin: 0 auto; text-align: center; padding-top: 10px">
                <input type="hidden" id="hdBuyCompTotalCount" />
                <div id="buyComppagination" class="page_curl" style="display: inline-block"></div>
            </div>
        </div>
        <!-- 상품검색 -->
        <div>
            <table class="tbl_main">
                <thead>
                    <tr>
                        <th colspan="12">상품검색</th>
                    </tr>
                    <tr>
                        <th>카테고리</th>
                        <th style="width: 55px">1단</th>
                        <td>
                            <select style="width:93%" id="Category01" onchange="fnChangeSubCategoryBind(this,2); return false;">
                                <option value="All">---전체---</option>
                            </select>
                        </td>
                        <th style="width: 55px">2단</th>
                        <td>
                            <select style="width:93%" id="Category02" onchange="fnChangeSubCategoryBind(this,3); return false;">
                                <option value="All">---전체---</option>
                            </select>
                        </td>
                        <th style="width: 55px">3단</th>
                        <td>
                            <select style="width:93%" id="Category03" onchange="fnChangeSubCategoryBind(this,4); return false;">
                                <option value="All">---전체---</option>
                            </select>
                        </td>
                        <th style="width: 55px">4단</th>
                        <td>
                            <select style="width:93%" id="Category04" onchange="fnChangeSubCategoryBind(this,5); return false;">
                                <option value="All">---전체---</option>
                            </select>
                        </td>
                        <th style="width: 55px">5단</th>
                        <td>
                            <select style="width:93%" id="Category05" onchange="fnChangeSubCategoryBind(this,6); return false;">
                                <option value="All">---전체---</option>
                            </select>
                        </td>
                        <td rowspan="2">
                            <input type="button" class="mainbtn type1" value="검색" onclick="fnCompPriceBind();" />
                            <%--<a onclick="fnCompPriceBind()">
                            <img alt="검색" src="../../AdminSub/Images/Goods/search-bt-off.jpg" /></a>--%>

                        </td>
                    </tr>
                    <tr>
                       <th>상세검색</th>
                            <th>상품명</th>
                            <td><input type="text" class="txtBox" id="txtGoodsName" onkeypress="return fnSearchGoodsEnter();"/></td>
                            <th>상품코드</th>
                            <td><input type="text" class="txtBox" id="txtGoodsCode" onkeypress="return fnSearchGoodsEnter();"/></td>
                            <th>브랜드명</th>
                            <td><input type="text" class="txtBox" id="txtBrandName" onkeypress="return fnSearchGoodsEnter();"/></td>
                            <th>브랜드<br />코드</th>
                            <td><input type="text" class="txtBox" id="txtBrandCode" onkeypress="return fnSearchGoodsEnter();"/></td>
                            <th>그룹코드</th>
                            <td><input type="text" class="txtBox" id="txtGroupCode" onkeypress="return fnSearchGoodsEnter();"/></td>
                    </tr>
                </thead>
            </table>

        </div>
        <br />

        <div style="width: 100%">
            <div style="display: inline-block; width: 50%">
                <table class="tbl_file">
                    <tr>
                        <th style="width: 100px">엑셀파일 등록</th>
                        <td>
                            <asp:FileUpload runat="server" ID="fuExcel" Width="200px" /></td>
                        <td style="padding-left: 13px; text-align:center">
                            <asp:Button ID="btnExcelUpload" runat="server" Text="엑셀업로드" OnClick="btnExcelUpload_Click" CssClass="mainbtn type1"/>
                            <asp:Button ID="btnExcelFormDownload" runat="server" Text="엑셀업로드폼 다운로드" OnClick="btnExcelFormDownload_Click" CssClass="mainbtn type1"/>
                        </td>
                           <%-- <asp:ImageButton ID="ibtnExcelUpload" AlternateText="엑셀업로드" runat="server" ImageUrl="../Images/Goods/upload-off.jpg" onmouseover="this.src='../Images/Goods/upload-on.jpg'" onmouseout="this.src='../Images/Goods/upload-off.jpg'" CssClass="upLoad" onclick="ibtnExcelUpload_Click"/></td>
                        <td style="border-left: none;">
                            <asp:ImageButton ID="ibtnExcelFormDownload" AlternateText="엑셀업로드폼 다운로드" runat="server" ImageUrl="../Images/Goods/formSave-off.jpg" onmouseover="this.src='../Images/Goods/formSave-on.jpg'" onmouseout="this.src='../Images/Goods/formSave-off.jpg'" CssClass="upLoad" OnClick="ibtnExcelFormDownload_Click"/></td>--%>
                    </tr>
                </table>
            </div>
            <div style="display: inline-block; width: 603px; padding-left: 20px">
                <table class="tbl_main">
                    <tr>
                        <th rowspan="2">일괄적용</th>
                        <th>단위
                        </th>
                        <th>구분
                        </th>
                        <th>적용값
                        </th>
                        <td rowspan="2" style="width: 100px; text-align: center">
                            <input type="button" class="mainbtn type1" style="width: 75px; height: 25px;" value="적용" onclick="fnMultiPriceSet();" />

                           <%-- <a onclick="fnMultiPriceSet();">
                                <img id="imgBtnApply" alt="적용" src="../Images/Goods/adjust-on.jpg" onmouseover="this.src='../Images/Goods/adjust-off.jpg'" onmouseout="this.src='../Images/Goods/adjust-on.jpg'" /></a>--%>
                        </td>
                    </tr>
                    <tr>
                        <td style="text-align: center">
                            <select id="selectUnit" style="width: 90%">
                                <option value="WON">원</option>
                                <option value="PERCENT">%</option>
                            </select>
                        </td>
                        <td style="text-align: center">
                            <select id="selectGubun" style="width: 90%">
                                <option value="P">+</option>
                                <option value="M">-</option>
                            </select>
                        </td>
                        <td style="text-align: center">
                            <input type="text" style="width: 90%; border: 1px solid #a2a2a2" id="txtMultiSavePrice" onkeypress="return onlyNumbers(event);" />
                        </td>
                        <td style="border:1px solid #ffffff; padding-left:30px; "> 
                            <input type="button" class="mainbtn type1" style="width:50px; height:25px; font-size:12px" value="삭 제" onclick="fnPriceDelete();"/>
                        </td>
                        <td style="border:1px solid #ffffff;">
                            <input type="button" class="mainbtn type1" style="width:50px; height:25px; font-size:12px" value="저 장" onclick="fnPriceSet()"/>
                        </td>
                    </tr>
                </table>

            </div>
        </div>
        <!-- 리스트 -->
        <div id="divTableList2" style="position: relative;">
            <table id="tblList2" class="tbl_main">
                <thead>
                    <tr>
                        <th style="width: 50px" rowspan="2">선택<br />
                            <input type="checkbox" id="selectAll" onclick="fnSelectAll(this);">
                        </th>
                        <th style="width: 250px" rowspan="2">상품정보
                        </th>
                        <th style="width: 120px" rowspan="2">내용량
                        </th>
                        <th style="width: 80px" rowspan="2">그룹코드
                        </th>
                        <th style="width: 110px; background-color: #FFEBFF" rowspan="2">매입가격</th>
                        <th style="width: 120px; background-color: #E8FFFF" rowspan="2">구매사<br/>판매가격</th>
                        <th style="width: 120px; background-color: #FFEBFF" rowspan="2">판매사<br/>판매가격</th>
                        <th style="width: 100px" rowspan="2">가격변동<br/>(노출여부)
                        </th>
                        <th style="width: 100px; background-color: #FFEBFF" rowspan="2">소셜위드<br />
                            수익률
                        </th>
                        <th style="width: 100px; background-color: #FFEBFF" rowspan="2">판매사<br />
                            수익률
                        </th>
                        <th style="width: 100px; background-color: #FFEBFF" rowspan="2">구매사<br />
                            수익률
                        </th>
                        <th style="background-color: #E8FFFF" id="thHeader1" >구매사</th>
                    </tr>
                    <tr id="trHeader1" style="display: none">
                    </tr>
                </thead>
                <tbody>
                    <tr>

                        <td colspan="18">리스트가 없습니다.</td>
                    </tr>
                </tbody>
            </table>
            <%--<div id="divLoading" style="display: none; position: absolute; top: 0; left: 0; width: 100%; height: 100%; background-color: rgba(0,0,0,.65); margin: 0 auto;">
                <img src="../Images/loading.gif" style="width: 130px; height: 130px; position: absolute; top: 20%; left: 45%">
            </div>--%>
              </div>
            <%-- </div>--%>
            <br />
            <div style="margin: 0 auto; text-align: center; padding-top: 10px">
                <input type="hidden" id="hdCompPriceTotalCount" />
                <div id="compPricepagination" class="page_curl" style="display: inline-block"></div>
            </div>
      
    </div>

    <%--주문 업체 코드 팝업--%>
    <div id="orderSaleCodediv" class="popupdiv divpopup-layer-package">
        <div class="popupdivWrapper" style="width: 650px;  height:600px">
            <div class="popupdivContents">

                <div class="close-div">
                    <a onclick="fnClosePopup('orderSaleCodediv'); return false;" style="cursor: pointer">
                        <img src="../../Images/Wish/icon-delete.jpg" alt="닫기" style="float: right;" /></a>
                </div>
                <div class="popup-title">
                    <h3 class="pop-title">그룹 판매사 검색</h3>      
                    <div class="search-div">
                        <input type="text" class="text-code" id="txtPopSearchSaleComp" placeholder="판매사명을 입력하세요" onkeypress="return fnPopSaleCompEnter();" style="width: 300px" />
                        <input type="button" class="mainbtn type1" style="width: 75px; height: 25px;" value="검색" onclick="fnGetCompanyList_A(1); return false;" />
<%--                        <a class="imgA" onclick="fnGetCompanyList_A(1); return false;">
                            <img src="../../AdminSub/Images/Goods/search-bt-off.jpg" onmouseover="this.src='../../AdminSub/Images/Goods/search-bt-on.jpg'" onmouseout="this.src='../../AdminSub/Images/Goods/search-bt-off.jpg'" alt="검색" class="search-img" /></a>--%>
                    </div>

                    <div class="divpopup-layer-conts">
                        <input type="hidden" id="hdSelectCode" />
                        <input type="hidden" id="hdSelectName" />
                        <table id="tblPopupSaleComp" class="tbl_main">
                            <thead>
                                <tr>
                                    <th class="text-center">판매사명</th>
                                    <th class="text-center">판매사 코드</th>
                                </tr>
                            </thead>
                            <tbody id="goodspopup_Tbody">
                                <tr class="board-tr-height">
                                    <td colspan="2" class="text-center">리스트가 없습니다.</td>
                                </tr>
                            </tbody>
                        </table>
                        <!-- 페이징 처리 -->
                        <div style="margin: 0 auto; text-align: center; padding-top: 10px">
                            <input type="hidden" id="hdTotalCount" />
                            <div id="pagination" class="page_curl" style="display: inline-block"></div>
                        </div>
                    </div>

                    <div class="btn_center">
                        <input type="button" class="mainbtn type1" style="width: 95px; height: 30px;" value="확인" onclick="fnPopupOkSaleComp(); return false;" />

                        <%--<a onclick="fnPopupOkSaleComp(); return false;">
                            <img src="../Images/Goods/submit1-off.jpg" alt="확인" onmouseover="this.src='../Images/Goods/submit1-on.jpg'" onmouseout="this.src='../Images/Goods/submit1-off.jpg'" /></a>--%>
                    </div>

                </div>
            </div>
        </div>
    </div>
</asp:Content>

