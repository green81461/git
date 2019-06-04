﻿<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Master/AdminMasterPage.master" AutoEventWireup="true" CodeFile="RMPGoodsPriceManagement.aspx.cs" Inherits="Admin_Goods_OSGoodsPriceManagement" %>

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
                var selectSWPPriceP = $(this).find("#hdPopSWPPriceP").val();
                var selectRMPPriceP = $(this).find("#hdPopRMPPriceP").val();
                var selectPopSALEPriceP = $(this).find("#hdPopSALEPriceP").val();
                $("#hdSelectCode").val(selectCode);
                $("#hdSelectName").val(selectName);
                $("#hdSWPPriceP").val(selectSWPPriceP);
                $("#hdRMPPriceP").val(selectRMPPriceP);
                $("#hdSALEPriceP").val(selectPopSALEPriceP);

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
            //alert("클릭");
            $("#txtPopSearchSaleComp").val($("#txtSaleCompSearch").val());
            fnGetCompanyList_A(1);
            fnOpenDivLayerPopup('orderSaleCodediv');
            //var e = document.getElementById('orderSaleCodediv');
            //if (e.style.display == 'block') {
            //    e.style.display = 'none';

            //} else {
            //    e.style.display = 'block';
            //}

            return false;
        }

        //RMP목록 조회
        function fnGetCompanyList_A(pageNum) {


            var keyword = $("#txtPopSearchSaleComp").val();
            var pageSize = 10;

            var callback = function (response) {
                $('#tblPopupSaleComp tbody').empty(); //테이블 클리어
                var newRowContent = "";

                if (!isEmpty(response)) {

                    $.each(response, function (key, value) { //테이블 추가
                        if (key == 0) $("#hdTotalCount").val(value.TotalCount);

                        newRowContent += "<tr style='height: 30px' ondblclick='dbClick()'>";
                        newRowContent += "<td id='SaleComp_Name' style='width: 100px' class='txt-center'>" + value.Company_Name + "</td>"; //회사명
                        newRowContent += "<td id='SaleComp_Code' style='width: 100px' class='txt-center'>" + value.Company_Code + "</td> "; //회사코드
                        newRowContent += "<input type='hidden' id='hdPopSWPPriceP' value='" + (100 - value.SWPPriceP) + "'/><input type='hidden' id='hdPopRMPPriceP' value='" + value.RMPPriceP + "'/><input type='hidden' id='hdPopSALEPriceP' value='" + value.SALEPriceP + "'/></tr>"; //회사코드
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
                Flag: 'GetCompListByGubun',
                Keyword: $("#txtSaleCompSearch").val(),
                Target: "COMPNAME",
                Gubun: "IU",
                PageNo: pageNum,
                PageSize: pageSize,
            };

            var beforeSend = function () {
                $('#divLoading').css('display', '');
            }
            var complete = function () {
                $('#divLoading').css('display', 'none');
            }

            JqueryAjax('Post', '../../Handler/Admin/CompanyHandler.ashx', true, false, param, 'json', callback, beforeSend, complete, true, '<%=Svid_User%>');

        }
        function getPageData() {
            var container = $('#pagination');
            var getPageNum = container.pagination('getSelectedPageNum');
            fnGetCompanyList_A(getPageNum);
            return false;
        }

        //더블클릭
        function dbClick() {
            fnPopupOkSaleComp();
        }


        function fnPopupOkSaleComp() {
            if ($("#hdSelectCode").val() == "") {
                alert("RMP를 선택해주세요");

            } else {

                fnGetCompanyInfo();
                $('#tblList2 tbody').empty(); //단가리스트 테이블 클리어
                $('#tblList2 tbody').append("<tr><td colspan='15' class='txt-center'>리스트가 없습니다.</td></tr>");
                $('#compPricepagination').css('display', 'none');

                fnClosePopup('orderSaleCodediv');
            }

            return false;
        }

        //선택된 업체 정보 조회
        function fnGetCompanyInfo() {
            $('#compPricepagination').css('display', 'none');
            var callback = function (response) {
                $('#tblSaleComp tbody').empty(); //테이블 클리어
                var newRowContent = "";

                if (!isEmpty(response)) {

                    $.each(response, function (key, value) { //테이블 추가

                        newRowContent += "<tr style='height:40px'>";
                        newRowContent += "<td class='txt-center'>RMP</td>"; //업체정보
                        newRowContent += "<td class='txt-center'>" + value.Company_Code + "</td>";  //업체코드
                        newRowContent += "<td class='txt-center'>" + value.Company_Name + "</td>";  //업체명
                        newRowContent += "<td class='txt-center'>" + value.DelegateName + "</td>";  //대표자명
                        newRowContent += "<td class='txt-center'>" + value.AdminUserName + "</td>";  //소셜위드담당자
                        newRowContent += "<td class='txt-center'>" + fnOracleDateFormatConverter(value.CpConStartDate) + "</td>";  //계약시작일
                        newRowContent += "<td class='txt-center'>" + fnOracleDateFormatConverter(value.CpConEndDate) + "</td>";  //계약만료일
                        newRowContent += "<td class='txt-center'>" + fnOracleDateFormatConverter(value.CompanyPriceDate) + "</td>";  //최종단가수정일
                        newRowContent += "<td class='txt-center'>" + value.CompanyPriceName + "</td>";  //최종단가수정자
                        newRowContent += "</tr>";
                    });
                } else {
                    newRowContent += "<tr style='height:40px'><td colspan='9' class='txt-center'>" + "조회된 데이터가 없습니다." + "</td></tr>"

                }
                $('#tblSaleComp tbody').append(newRowContent);
                return false;
            }

            var param = {
                Flag: 'GetCompPriceCompanyList',
                Gubun: 'IU',
                SearchKeyword: $("#hdSelectCode").val(),
                SaleSearchType: 'MANAGE',
                BuySearchType: '',
                PageNo: 1,
                PageSize: 1,
            };

            var beforeSend = function () {
                $('#divLoading').css('display', '');
            }
            var complete = function () {
                $('#divLoading').css('display', 'none');
            }

            JqueryAjax('Post', '../../Handler/Admin/CompanyHandler.ashx', true, false, param, 'json', callback, beforeSend, complete, true, '<%=Svid_User%>');
        }

        function fnCompPriceBind() {
            if (isEmpty($("#hdSelectCode").val())) {
                alert('RMP를 선택해 주세요.');
                return false;
            }

            if ($('#Category01').val() == 'All') {
                if (($("#txtGoodsCode").val() == '' && $("#txtGroupCode").val() == '')) {
                    alert('1단 카테고리는 필수 선택 조건입니다.');
                    return false;
                }
            }

            $('#tblList2 tbody').empty(); //테이블 클리어
            $('#compPricepagination').css('display', 'none');
            fnGetCompPriceList(1);
            return false;
        }
        //단가리스트 조회
        function fnGetCompPriceList(pageNum) {
            // $('#divLoading').css('display', '');
            var callback = function (response) {
                $('#tblList2 tbody').empty(); //테이블 클리어
                var newRowContent = "";
                var priceCheck = true;
                var SWPPriceP = $("#hdSWPPriceP").val();
                var RMPPriceP = $("#hdRMPPriceP").val();
                if (!isEmpty(response)) {

                    $.each(response, function (key, value) { //테이블 추가
                        $("#hdCompPriceTotalCount").val(value.TotalCount);
                        var disableStyle = '';

                        if (value.GoodsDCYN == '2' || value.GoodsDisplayFlag == '2') {
                            disableStyle = 'disabled';
                        }

                        var colColor = 'background-color:#E8FFFF';
                        if (!isEmpty(value.TempCompPrice_1) && value.GoodsBuyPrice > value.TempCompPrice_1) {
                            colColor = 'background-color:#FFC6C6';
                            priceCheck = false;
                        }

                        var RMPprice = Math.round((value.GoodsBuyPrice + (value.GoodsSalePrice - value.GoodsBuyPrice) * (SWPPriceP / 100)));
                        var RMPpriceVat = Math.round((value.GoodsBuyPriceVat + (value.GoodsSalePriceVat - value.GoodsBuyPriceVat) * (SWPPriceP / 100)));
                        var custPrice = Math.round((RMPprice + (value.GoodsSalePrice - value.GoodsBuyPrice) * (RMPPriceP / 100))); //RMP가 들어간 판매가 
                        var custPriceVat = Math.round((RMPpriceVat + (value.GoodsSalePriceVat - value.GoodsBuyPriceVat) * (RMPPriceP / 100))); //부가세 포함 


                        newRowContent += "<tr style='height:40px;'>";
                        newRowContent += "<td class='txt-center'><input type='checkbox' id='cbSelect' " + disableStyle + "/>";
                        newRowContent += "<input type='hidden' id='hdCategoryCode' value='" + value.GoodsFinalCategoryCode + "'/>";
                        newRowContent += "<input type='hidden' id='hdGroupCode' value='" + value.GoodsGroupCode + "'/>";
                        newRowContent += "<input type='hidden' id='hdGoodsCode' value='" + value.GoodsCode + "'/>";
                        newRowContent += "<input type='hidden' id='hdCustPrice' value='" + value.GoodsCustPriceVat + "'/>";
                        newRowContent += "<input type='hidden' id='hdBuyPriceVat' value='" + value.GoodsBuyPriceVat + "'/>";
                        newRowContent += "</td>"; //선택
                        newRowContent += "<td style='text-align:left'>" + value.GoodsCode + "<br/>" + value.GoodsFinalName + "(" + value.GoodsModel + ")<br/>*" + value.BrandName + "<br/>" + value.GoodsOptionSummaryValues + "</td>";  //상품정보
                        newRowContent += "<td class='txt-center'>" + value.GoodsUnitName + "</td>";  //내용량
                        newRowContent += "<td class='txt-center'>" + value.GoodsGroupCode + "</td>";  //그룹코드
                        newRowContent += "<td class='txt-center'>" + fnOracleDateFormatConverter(value.CompanyPriceDate) + "</td>";  //최종단가수정일
                        newRowContent += "<td class='txt-center'>" + value.CompanyPriceName + "</td>";  //최종단가 수정자
                        newRowContent += "<td class='txt-center' style='background-color:#FFEBFF'>" + numberWithCommas(value.GoodsBuyPrice) + "원<br/>";
                        newRowContent += "<div id='divVatPrice' style='float:left; height:20px; padding-left:7px'><img src='/Images/tax_icon.png' width='20' height='20'/><label style='color:red' id='lblPriceVAT'>" + numberWithCommas(value.GoodsBuyPriceVat) + "</label><label style='color:red'>원</label></div></td>";  //매입가격
                        newRowContent += "<td class='txt-center' style='background-color:#FFEBFF'>" + numberWithCommas(value.GoodsSalePrice) + "원<br/>";
                        newRowContent += "<div id='divVatPrice' style='float:left; height:20px; padding-left:7px'><img src='/Images/tax_icon.png' width='20' height='20'/><label style='color:red' id='lblPriceVAT'>" + numberWithCommas(value.GoodsSalePriceVat) + "</label><label style='color:red'>원</label></div></td>";  //구매사 판매가격
                        newRowContent += "<td class='txt-center' style='background-color:#FFEBFF'>" + numberWithCommas(custPrice) + "원<br/>";
                        newRowContent += "<div id='divVatPrice' style='float:left; height:20px; padding-left:7px'><img src='/Images/tax_icon.png' width='20' height='20'/><label style='color:red' id='lblPriceVAT'>" + numberWithCommas(custPriceVat) + "</label><label style='color:red'>원</label></div></td>";  //판매사 판매가격 
                        newRowContent += "<td class='txt-center' style='background-color:#E8FFFF'>" + numberWithCommas(RMPprice) + "원<br/>";
                        newRowContent += "<div id='divVatPrice' style='float:left; height:20px; padding-left:7px'><img src='/Images/tax_icon.png' width='20' height='20'/><label style='color:red' id='lblPriceVAT'>" + numberWithCommas(RMPpriceVat) + "</label><label style='color:red'>원</label></div></td>";  //RMP 판매가격 
                        var displayColor = '#FFFFFF';
                        if (value.GoodsDCYN == '2' || value.GoodsDisplayFlag == '2') {
                            displayColor = '#FFFFA4';
                        }
                        newRowContent += "<td class='txt-center' style='background-color:" + displayColor + "'>" + fnSetDCYN(value.GoodsDCYN) + "<br/>(" + fnSetDisplayFlag(value.GoodsDisplayFlag) + ")</td>";  //가격변동
                        newRowContent += "<td class='txt-center' style='background-color:#FFEBFF'>" + value.UrianYield + "%</td>";  //소셜위드수익률
                        newRowContent += "<td class='txt-center' style='background-color:#FFEBFF'>" + value.SaleCompYield + "%</td>";  //판매사수익률
                        newRowContent += "<td class='txt-center' style='background-color:#FFEBFF'>" + value.BuyCompYield + "%</td>";  //구매사수익률

                        var price = '';
                        if (!isEmpty(value.TempCompPrice_1)) {
                            price = numberWithCommas(value.TempCompPrice_1);
                        }
                        newRowContent += "<td class='txt-center' style='" + colColor + "'><input type='text' id='txtPrice' style='width:80%; ' value='" + price + "' " + disableStyle + " onkeyup='return fnAutoComma(this);' onkeypress='return onlyNumbers(event);'>원<div id='divVatPrice' style='float:left; height:20px; padding-left:7px'>";  //RMP 판매가격입력

                        if (!isEmpty(value.TempCompPriceVat_1)) {
                            newRowContent += "<img src='/Images/tax_icon.png' width='20' height='20'/><label style='color:red' id='lblPriceVAT'>" + numberWithCommas(value.TempCompPriceVat_1) + "</label><label style='color:red'>원</label>";
                        }

                        newRowContent += "</div></td></tr>";
                    });
                } else {
                    $("#hdCompPriceTotalCount").val(0);
                    newRowContent += "<tr style='height:40px'><td colspan='15' class='txt-center'>" + "조회된 데이터가 없습니다." + "</td></tr>"

                }
                $('#tblList2 tbody').append(newRowContent);
                // $('#divLoading').css('display', 'none');
                $('#compPricepagination').css('display', 'inline-block');

                fnCreatePagination('compPricepagination', $("#hdCompPriceTotalCount").val(), pageNum, 50, getCompPricePageData);
                if (!priceCheck) {
                    alert('RMP 판매가격이 역마진 가격으로 입력되었습니다. 확인바랍니다.');
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
                Method: 'GetAdminCompPriceList_TypeA',
                CompCode1: $("#hdSelectCode").val(),
                CompCode2: '',
                CompCode3: '',
                CompCode4: '',
                CompCode5: '',
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
            //JajaxSessionCheck('Post', '../../Handler/GoodsHandler.ashx', param, 'json', callback, '<%=Svid_User%>');
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
        function fnSaleCompSearchEnter() {
            if (event.keyCode == 13) {
                fnSearchSaleCompPopup();
                return false;
            }
            else
                return true;

        }

        function fnPopSaleCompEnter() {
            if (event.keyCode == 13) {
                fnGetCompanyList_A(1);
                return false;
            }
            else
                return true;
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
                Method: 'MultiSaveCompPrice',
                CompCode: $("#hdSelectCode").val(),
                Gubun: 'IU',
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

        function fnPriceDelete() {
            var selectLength = $('#tblList2 tbody input[type="checkbox"]:checked').length;
            if (selectLength < 1) {
                alert('상품을 선택해 주세요');
                return false;

            }


            if (!confirm('삭제하시겠습니까?')) {
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
            var priceArray = '';
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
                Method: 'DeleteCompPrice',
                CompCode: $("#hdSelectCode").val(),
                Gubun: 'IU',
                PriceId:'<%= UserInfoObject.Id%>',
                CtgrCodes: categoryCodeArray.slice(0, -1),
                GroupCodes: goodsGroupCodeArray.slice(0, -1),
                GoodsCodes: codeArray.slice(0, -1),
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

                    var price = $(this).parent().parent().children().find('input[id*="txtPrice"]').val();
                    var buyprice = $(this).parent().parent().children().find('input[id*="hdBuyPriceVat"]').val();
                    if (isEmpty(price)) {
                        nullFlag = false;
                    }
                    if (parseInt(buyprice) > parseInt(price.replace(/[^0-9 | ^.]/g, ''))) {
                        checkBuyPriceFlag = false;
                    }
                }
            });

            if (nullFlag == false) {
                alert('체크된 판매가격은 필수 입력입니다.');
                return false;
            }

            //if (checkBuyPriceFlag == false) {
            //    alert('판매사 판매가격이 역마진 가격으로 입력되었습니다. 확인바랍니다.');
            //}

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
            var priceArray = '';
            $('#tblList2 tbody input[type="checkbox"]').each(function () {
                if ($(this).prop('checked') == true) {
                    var goodsCode = $(this).parent().parent().children().find('#hdGoodsCode').val();
                    var goodsGroupCode = $(this).parent().parent().children().find('#hdGroupCode').val();
                    var categoryCode = $(this).parent().parent().children().find('#hdCategoryCode').val();
                    var price = $(this).parent().parent().children().find('#txtPrice').val().replace(/[^0-9 | ^.]/g, '');
                    categoryCodeArray += categoryCode + '/';
                    goodsGroupCodeArray += goodsGroupCode + '/';
                    codeArray += goodsCode + '/';
                    priceArray += price + '/';
                }
            });
            var param = {
                Method: 'SaveCompPrice',
                CompCode: $("#hdSelectCode").val(),
                Gubun: 'IU',
                PriceId:'<%= UserInfoObject.Id%>',
                CtgrCodes: categoryCodeArray.slice(0, -1),
                GroupCodes: goodsGroupCodeArray.slice(0, -1),
                GoodsCodes: codeArray.slice(0, -1),
                Prices: priceArray.slice(0, -1),
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

        //RealTime Comma찍기
        function fnAutoComma(el) {

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
                fnGetCompPriceList(1);
                return false;
            }
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div class="sub-contents-div">
        <div class="sub-title-div">
            <p class="p-title-mainsentence">
                RMP 단가관리
                    <span class="span-title-subsentence"></span>
            </p>
        </div>

        <!--탭영역-->
        <div class="div-main-tab" style="width: 100%;">
            <ul>
                <li class='tabOn' style="width: 185px;" onclick="fnTabClickRedirect('RMPGoodsPriceManagement');">
                    <a onclick="fnTabClickRedirect('RMPGoodsPriceManagement');">RMP 단가관리</a>
                </li>
                <li class='tabOff' style="width: 185px;" onclick="fnTabClickRedirect('OSGoodsPriceManagement');">
                    <a onclick="fnTabClickRedirect('OSGoodsPriceManagement');">판매사 단가관리</a>
                </li>
                <li class='tabOff' style="width: 185px;" onclick="fnTabClickRedirect('OBGoodsPriceManagement');">
                    <a onclick="fnTabClickRedirect('OBGoodsPriceManagement');">구매사 단가관리</a>
                </li>
            </ul>
        </div>

        <%--<!--탭메뉴-->
            <div class="sub-tab-div">
                <ul>
                    <li>
                        <a href="OSGoodsPriceManagement.aspx">
                            <img src="../Images/Goods/tab111-on.jpg" alt="판매사 단가관리" /></a>
                        <a href="OBGoodsPriceManagement.aspx">
                            <img src="../Images/Goods/tab222-off.jpg" alt="구매사 단가관리" /></a>
                    </li>
                </ul>
            </div>--%>
        <div class="bottom-search-div" style="margin-bottom: 20px">
            <table class="tbl_search" style="margin-top: 30px; margin-bottom: 30px;">
                <colgroup>
                    <col style="width: 80px;" />
                    <col />
                </colgroup>
                <tr>
                    <td></td>
                    <td>
                        <%--<asp:TextBox runat="server" placeholder="검색어를 입력하세요." Style="width: 600px" ID="txtSaleCompSearch" OnKeyPress="return fnSaleCompSearchEnter();"></asp:TextBox>--%>
                        <input placeholder="검색어를 입력하세요." style="width: 600px;" id="txtSaleCompSearch" onkeypress="return fnSaleCompSearchEnter();" />
                        <%--<asp:Button runat="server" CssClass="mainbtn type1" ID="btnGoodsSearch"  style="vertical-align:middle; " OnClientClick="return fnSearchSaleCompPopup();" Text="검색" Width="75" Height="25"/>--%>
                        <input type="button" class="mainbtn type1" id="btnGoodsSearch" style="vertical-align: middle; width: 75px; height: 25px;" onclick="return fnSearchSaleCompPopup();" value="검색" />
                        <input type="hidden" id="hdSWPPriceP" />
                        <input type="hidden" id="hdRMPPriceP" />
                        <input type="hidden" id="hdSALEPriceP" />
                    </td>
                </tr>
            </table>
        </div>
        <div class="saleComp-search">
            <table id="tblSaleComp" class="tbl_main">
                <thead>

                    <tr class="board-tr-height">
                        <th class="txt-center" style="width: 80px">구분</th>
                        <th class="txt-center" style="width: 120px">RMP코드</th>
                        <th class="txt-center" style="width: auto">RMP명</th>
                        <th class="txt-center" style="width: 120px">대표자명</th>
                        <th class="txt-center" style="width: 120px">소셜위드담당자</th>
                        <th class="txt-center" style="width: 120px">계약 시작일</th>
                        <th class="txt-center" style="width: 120px">계약 만료일</th>
                        <th class="txt-center" style="width: 120px">최종단가수정일</th>
                        <th class="txt-center" style="width: 120px">최종단가수정자</th>
                    </tr>
                </thead>
                <tbody>
                    <tr class="board-tr-height">
                        <td class="txt-center" colspan="9">조회된 데이터가 없습니다.
                        </td>
                    </tr>
                </tbody>
            </table>
        </div>
        <!-- 상품검색 -->
        <div style="padding-top: 30px">
            <table class="tbl_main">
                <thead>
                    <tr>
                        <th colspan="12">상품검색</th>
                    </tr>
                    <tr>
                        <th style="width: 70px">카테고리</th>
                        <th style="width: 55px">1단</th>
                        <td>
                            <select style="width: 93%" id="Category01" onchange="fnChangeSubCategoryBind(this,2); return false;">
                            </select>
                        </td>
                        <th style="width: 55px">2단</th>
                        <td>
                            <select style="width: 93%" id="Category02" onchange="fnChangeSubCategoryBind(this,3); return false;">
                                <option value="All">---전체---</option>
                            </select>
                        </td>
                        <th style="width: 55px">3단</th>
                        <td>
                            <select style="width: 93%" id="Category03" onchange="fnChangeSubCategoryBind(this,4); return false;">
                                <option value="All">---전체---</option>
                            </select>
                        </td>
                        <th style="width: 55px">4단</th>
                        <td>
                            <select style="width: 93%" id="Category04" onchange="fnChangeSubCategoryBind(this,5); return false;">
                                <option value="All">---전체---</option>
                            </select>
                        </td>
                        <th style="width: 55px">5단</th>
                        <td>
                            <select style="width: 93%" id="Category05" onchange="fnChangeSubCategoryBind(this,6); return false;">
                                <option value="All">---전체---</option>
                            </select>
                        </td>
                        <td rowspan="2">
                            <input type="button" class="mainbtn type1" style="width: 75px;" value="검색" onclick="fnCompPriceBind();" />

                            <%--<a onclick="fnCompPriceBind()"><img alt="검색" src="../../AdminSub/Images/Goods/search-bt-off.jpg"/></a>--%>

                        </td>
                    </tr>
                    <tr>
                        <th>상세검색</th>
                        <th>상품명</th>
                        <td>
                            <input type="text" class="txtBox" id="txtGoodsName" onkeypress="return fnSearchGoodsEnter();" /></td>
                        <th>상품코드</th>
                        <td>
                            <input type="text" class="txtBox" id="txtGoodsCode" onkeypress="return fnSearchGoodsEnter();" /></td>
                        <th>브랜드명</th>
                        <td>
                            <input type="text" class="txtBox" id="txtBrandName" onkeypress="return fnSearchGoodsEnter();" /></td>
                        <th>브랜드<br />
                            코드</th>
                        <td>
                            <input type="text" class="txtBox" id="txtBrandCode" onkeypress="return fnSearchGoodsEnter();" /></td>
                        <th>그룹코드</th>
                        <td>
                            <input type="text" class="txtBox" id="txtGroupCode" onkeypress="return fnSearchGoodsEnter();" /></td>
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
                        <td style="border-right: none; text-align: center">
                            <%--<asp:ImageButton ID="ibtnExcelUpload" AlternateText="엑셀업로드" runat="server" ImageUrl="../Images/Goods/upload-off.jpg" onmouseover="this.src='../Images/Goods/upload-on.jpg'" onmouseout="this.src='../Images/Goods/upload-off.jpg'"  CssClass="upLoad" />--%>
                            <asp:Button ID="btnExcelUpload" runat="server" Width="95" Height="30" Text="엑셀업로드" OnClick="btnExcelUpload_Click" CssClass="mainbtn type1" />
                            <asp:Button ID="btnExcelFormDownload" runat="server" Width="155" Height="30" Text="엑셀업로드폼 다운로드" OnClick="btnExcelFormDownload_Click" CssClass="mainbtn type1" />
                            <%--<asp:ImageButton ID="ibtnExcelFormDownload" AlternateText="엑셀업로드폼 다운로드" runat="server" ImageUrl="../Images/Goods/formSave-off.jpg" onmouseover="this.src='../Images/Goods/formSave-on.jpg'" onmouseout="this.src='../Images/Goods/formSave-off.jpg'"  CssClass="upLoad"/>--%>
                        </td>
                        <td style="border-left: none;"></td>
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
                        <td rowspan="2" style="width: 100px; text-align: center;">
                            <input type="button" class="mainbtn type1" style="width: 75px; height: 25px;" value="적용" onclick="fnMultiPriceSet();" />
                            <%-- <a onclick="fnMultiPriceSet();"><img id="imgBtnApply" alt="적용"  src="../Images/Goods/adjust-on.jpg" onmouseover="this.src='../Images/Goods/adjust-off.jpg'" onmouseout="this.src='../Images/Goods/adjust-on.jpg'"/></a>--%>
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
                        <td style="border: 1px solid #ffffff; padding-left: 30px;">
                            <input type="button" class="mainbtn type1" style="width: 50px; height: 25px; font-size: 12px" value="삭 제" onclick="fnPriceDelete();" />
                        </td>
                        <td style="border: 1px solid #ffffff;">
                            <input type="button" class="mainbtn type1" style="width: 50px; height: 25px; font-size: 12px" value="저 장" onclick="fnPriceSet()" />
                        </td>
                    </tr>
                </table>
            </div>

        </div>
        <!-- 리스트 -->
        <%-- <div class="list-div">--%>
        <div id="divTableList2" style="position: relative;">
            <table id="tblList2" class="tbl_main">
                <thead>
                    <tr>
                        <th style="width: 60px">선택<br />
                            <input type="checkbox" id="selectAll" onclick="fnSelectAll(this);">
                        </th>
                        <th style="width: 280px">상품정보
                        </th>
                        <th style="width: 110px">내용량
                        </th>
                        <th style="width: 80px">그룹코드
                        </th>
                        <th style="width: 120px">최종단가<br />
                            수정일
                        </th>
                        <th style="width: 120px">최종단가<br />
                            수정자
                        </th>
                        <th style="width: 120px; background-color: #FFEBFF">매입가격
                        </th>
                        <th style="width: 120px; background-color: #FFEBFF">구매사<br />
                            판매가격
                        </th>
                        <th style="width: 120px; background-color: #FFEBFF">판매사<br />
                            판매가격
                        </th>
                        <th style="width: 120px; background-color: #E8FFFF">RMP<br />
                            판매가격
                        </th>
                        <th style="width: 100px">가격변동<br />
                            (노출여부)
                        </th>
                        <th style="width: 100px; background-color: #FFEBFF">소셜위드<br />
                            수익률
                        </th>
                        <th style="width: 100px; background-color: #FFEBFF">판매사<br />
                            수익률
                        </th>
                        <th style="width: 100px; background-color: #FFEBFF">구매사<br />
                            수익률
                        </th>
                        <th style="width: 160px; background-color: #E8FFFF">RMP<br />
                            판매가격입력
                        </th>
                    </tr>

                </thead>
                <tbody>
                    <tr>
                        <td colspan="15" class="txt-center">리스트가 없습니다.</td>
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
        <div class="popupdivWrapper" style="width: 650px; height: 600px">
            <div class="popupdivContents">

                <div class="close-div">
                    <a onclick="fnClosePopup('orderSaleCodediv'); return false;" style="cursor: pointer">
                        <img src="../../Images/Wish/icon-delete.jpg" alt="닫기" style="float: right;" /></a>
                </div>
                <div class="popup-title">
                    <h3 class="pop-title">RMP사 검색</h3>
                    <div class="search-div">
                        <input type="text" class="text-code" id="txtPopSearchSaleComp" placeholder="RMP명을 입력하세요" onkeypress="return fnPopSaleCompEnter();" style="width: 300px" />
                        <input type="button" class="mainbtn type1" style="width: 75px; height: 25px;" value="검색" onclick="fnGetCompanyList_A(1); return false;" />
                        <%--<a class="imgA" onclick="fnGetCompanyList_A(1); return false;">
                            <img src="../../AdminSub/Images/Goods/search-bt-off.jpg" onmouseover="this.src='../../AdminSub/Images/Goods/search-bt-on.jpg'" onmouseout="this.src='../../AdminSub/Images/Goods/search-bt-off.jpg'" alt="검색" class="search-img" /></a>--%>
                    </div>


                    <div class="divpopup-layer-conts">
                        <input type="hidden" id="hdSelectCode" />
                        <input type="hidden" id="hdSelectName" />
                        <table id="tblPopupSaleComp" class="tbl_main tbl_popup">
                            <thead>
                                <tr>
                                    <th class="text-center">RMP명</th>
                                    <th class="text-center">RMP 코드</th>
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

