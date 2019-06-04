<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Master/AdminMasterPage.master" AutoEventWireup="true" CodeFile="OBGoodsDisplayManagement.aspx.cs" Inherits="Admin_Goods_OBGoodsDisplayManagement" %>

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

                //var e = document.getElementById('orderSaleCodediv');
                //if (e.style.display == 'block') {
                //    e.style.display = 'none';

                //} else {
                //    e.style.display = 'block';
                //}

                fnOpenDivLayerPopup('orderSaleCodediv');

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
                        //newRowContent += "<td class='txt-center'><input type='hidden' id='hdSaleCompCode' value='" + value.OrderSaleCompCode + "'/>" + value.OrderSaleCompCode + "</td>";  //판매사코드
                        //newRowContent += "<td class='txt-center'>" + value.OrderSaleCompName + "</td>";  //판매사명
                        newRowContent += "<td class='txt-center'>" + value.AdminUserName + "</td>";  //우리안담당자
                        newRowContent += "<td class='txt-center'>" + value.AtypeRole + "</td>";  //유형
                        newRowContent += "<td class='txt-center'>" + fnOracleDateFormatConverter(value.CpConStartDate) + "</td>";  //계약시작일
                        newRowContent += "<td class='txt-center'>" + fnOracleDateFormatConverter(value.CpConEndDate) + "</td>";  //계약만료일
                        newRowContent += "<td class='txt-center'>" + fnOracleDateFormatConverter(value.CompanyPriceDate) + "</td>";  //최종단가수정일
                        newRowContent += "<td class='txt-center'>" + value.CompanyPriceName + "</td>";  //최종단가수정자
                        newRowContent += "</tr>";
                    });
                } else {
                    newRowContent += "<tr style='height:40px'><td colspan='13' class='txt-center'>" + "조회된 데이터가 없습니다." + "</td></tr>"

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
        function fnGetCompDisplayList(pageNum) {
            var saleCompCode = $("#hdSaleCompCode").val();

            // $('#divLoading').css('display', '');
            var callback = function (response) {


                var newRowContent = "";

                if (!isEmpty(response)) {

                    $('#tblList2 tbody').empty(); //테이블 클리어
                    $.each(response, function (key, value) { //테이블 추가

                        $("#hdCompPriceTotalCount").val(value.TotalCount);
                        var disableStyle = '';
                        if (value.GoodsDCYN == '2') {
                            disableStyle = 'disabled';
                        }

                        var SaleCompGoodsYN = value.SaleCompGoodsYN;
                        
                        if (SaleCompGoodsYN == null || SaleCompGoodsYN == 'Y') {
                            SaleCompGoodsYN = "사용";
                        } else {
                            SaleCompGoodsYN = "사용중지";
                        }

                        newRowContent += "<tr style='height:40px'>";
                        newRowContent += "<td class='txt-center'><input type='checkbox' id='cbSelect' " + disableStyle + "/>";
                        newRowContent += "<input type='hidden' id='hdCategoryCode' value='" + value.GoodsFinalCategoryCode + "'/>";
                        newRowContent += "<input type='hidden' id='hdGroupCode' value='" + value.GoodsGroupCode + "'/>";
                        newRowContent += "<input type='hidden' id='hdGoodsCode' value='" + value.GoodsCode + "'/>";
                        newRowContent += "<input type='hidden' id='hdCustPrice' value='" + value.GoodsCustPriceVat + "'/>";
                        newRowContent += "</td>"; //선택
                        newRowContent += "<td style='text-align:left'>" + value.GoodsCode + "<br/>" + value.GoodsFinalName + "(" + value.GoodsModel + ")<br/>*" + value.BrandName + "<br/>" + value.GoodsOptionSummaryValues + "</td>";  //상품정보
                        newRowContent += "<td class='txt-center'>" + value.GoodsUnitName + "</td>";  //내용량
                        newRowContent += "<td class='txt-center'>" + value.GoodsGroupCode + "</td>";  //그룹코드
                        newRowContent += "<td class='txt-center'>" + SaleCompGoodsYN+ "</td>";//판매사 사용유무

                        //구매사 사용유무
                        var SaleCompGoodsYN_1 = value.CompGoodsYN_1;
                        var SaleCompGoodsYN_2 = value.CompGoodsYN_2;
                        var SaleCompGoodsYN_3 = value.CompGoodsYN_3;
                        var SaleCompGoodsYN_4 = value.CompGoodsYN_4;
                        var SaleCompGoodsYN_5 = value.CompGoodsYN_5;

                       if (!isEmpty($('#hdSelectBuyCompCode1').val())) {
                           if (SaleCompGoodsYN_1 == null || SaleCompGoodsYN_1 == 'Y' || SaleCompGoodsYN_1 == '') {
                               newRowContent += "<td class='txt-center'><select name='selectUseYN1'><option value='Y' selected='true'>사용</option><option value='N'>사용중지</option></select><input type='hidden' id='hdRowCompCode' value='" + $('#hdSelectBuyCompCode1').val() + "'></td>";
                           } else {
                               newRowContent += "<td class='txt-center'><select name='selectUseYN1'><option value='Y' >사용</option><option value='N' selected='true'>사용중지</option></select><input type='hidden' id='hdRowCompCode' value='" + $('#hdSelectBuyCompCode1').val() + "'></td>";
                           }
                        }
                        if (!isEmpty($('#hdSelectBuyCompCode2').val())) {
                            if (SaleCompGoodsYN_2 == null || SaleCompGoodsYN_2 == 'Y' || SaleCompGoodsYN_2 == '') {
                                newRowContent += "<td class='txt-center'><select name='selectUseYN2'><option value='Y' selected='true'>사용</option><option value='N'>사용중지</option></select><input type='hidden' id='hdRowCompCode' value='" + $('#hdSelectBuyCompCode2').val() + "'></td>";
                            } else {
                                newRowContent += "<td class='txt-center'><select name='selectUseYN2'><option value='Y' >사용</option><option value='N' selected='true'>사용중지</option></select><input type='hidden' id='hdRowCompCode' value='" + $('#hdSelectBuyCompCode2').val() + "'></td>";
                            }                            
                        }
                        if (!isEmpty($('#hdSelectBuyCompCode3').val())) {
                            if (SaleCompGoodsYN_3 == null || SaleCompGoodsYN_3 == 'Y' || SaleCompGoodsYN_3 == '') {
                                newRowContent += "<td class='txt-center'><select name='selectUseYN3'><option value='Y' selected='true'>사용</option><option value='N'>사용중지</option></select><input type='hidden' id='hdRowCompCode' value='" + $('#hdSelectBuyCompCode3').val() + "'></td>";
                            } else {
                                newRowContent += "<td class='txt-center'><select name='selectUseYN3'><option value='Y' >사용</option><option value='N' selected='true'>사용중지</option></select><input type='hidden' id='hdRowCompCode' value='" + $('#hdSelectBuyCompCode3').val() + "'></td>";
                            }   
                        }
                        if (!isEmpty($('#hdSelectBuyCompCode4').val())) {
                            if (SaleCompGoodsYN_4 == null || SaleCompGoodsYN_4 == 'Y' || SaleCompGoodsYN_4 == '') {
                                newRowContent += "<td class='txt-center'><select name='selectUseYN4'><option value='Y' selected='true'>사용</option><option value='N'>사용중지</option></select><input type='hidden' id='hdRowCompCode' value='" + $('#hdSelectBuyCompCode4').val() + "'></td>";
                            } else {
                                newRowContent += "<td class='txt-center'><select name='selectUseYN4'><option value='Y' >사용</option><option value='N' selected='true'>사용중지</option></select><input type='hidden' id='hdRowCompCode' value='" + $('#hdSelectBuyCompCode4').val() + "'></td>";
                            }   
                        }
                        if (!isEmpty($('#hdSelectBuyCompCode5').val())) {
                            if (SaleCompGoodsYN_5 == null || SaleCompGoodsYN_5 == 'Y' || SaleCompGoodsYN_5 == '') {
                                newRowContent += "<td class='txt-center'><select name='selectUseYN5'><option value='Y' selected='true'>사용</option><option value='N'>사용중지</option></select><input type='hidden' id='hdRowCompCode' value='" + $('#hdSelectBuyCompCode5').val() + "'></td>";
                            } else {
                                newRowContent += "<td class='txt-center'><select name='selectUseYN5'><option value='Y' >사용</option><option value='N' selected='true'>사용중지</option></select><input type='hidden' id='hdRowCompCode' value='" + $('#hdSelectBuyCompCode5').val() + "'></td>";
                            }    
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
                Method: 'GetAdminCompDisplayList',
                Gubun: 'BU',
                SaleCompCode: saleCompCode,
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
            fnGetCompDisplayList(getPageNum);
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

        function fnCompPriceBind() {

            var selectLength = $('#tblBuyComp tbody input[type="checkbox"]:checked').length;
            if (selectLength < 1) {
                alert('판매사를 선택해 주세요.');
                return false;
            }

            if (selectLength > 5) {
                alert('판매사를 5개 이하로 선택해 주세요.');
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

            fnGetCompDisplayList(1);
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
        function fnMultiDisplaySet() {

            var selectLength = $('#tblList2 tbody input[type="checkbox"]:checked').length;
            if (selectLength < 1) {
                alert('상품을 선택해 주세요');
                return false;

            }
     
            if (!confirm('적용하시겠습니까?')) {
                return false;
            }

            var callback = function (response) {
                if (response == 'OK') {
                    alert('적용되었습니다.');
                    fnGetCompDisplayList($('#compPricepagination').pagination('getSelectedPageNum'));
                }
                else {
                    alert('시스템 오류입니다. 관리자에게 문의하세요.');
                }
                return false;
            };

            var categoryCodeArray = '';
            var goodsGroupCodeArray = '';
            var codeArray = '';
            var unitArray = '';
            $('#tblList2 tbody input[type="checkbox"]').each(function () {
                if ($(this).prop('checked') == true) {
                    var goodsCode = $(this).parent().parent().children().find('#hdGoodsCode').val();
                    var goodsGroupCode = $(this).parent().parent().children().find('#hdGroupCode').val();
                    var categoryCode = $(this).parent().parent().children().find('#hdCategoryCode').val();
                    categoryCodeArray += categoryCode + '/';
                    goodsGroupCodeArray += goodsGroupCode + '/';
                    codeArray += goodsCode + '/';
                    unitArray += $('#selectUnit').val() + '/';
                }
            });
            
            var param = {
                Method: 'MultiSaveBuyCompDisplay',
                CompCodes: $('#hdSelectBuyCodes').val().slice(0, -1),
                Gubun: 'BU',
                PriceId:'<%= UserInfoObject.Id%>',
                CtgrCodes: categoryCodeArray.slice(0, -1),
                GroupCodes: goodsGroupCodeArray.slice(0, -1),
                GoodsCodes: codeArray.slice(0, -1),
                GoodsYN: unitArray.slice(0, -1),
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


        function fnDisplaySet() {
            var selectLength = $('#tblList2 tbody input[type="checkbox"]:checked').length;
            if (selectLength < 1) {
                alert('상품을 선택해 주세요');
                return false;

            }

            var nullFlag = true;

            $('#tblList2 tbody input[type="checkbox"]').each(function () {
                if ($(this).prop('checked') == true) {

                    var selectUseYNs = $(this).parent().parent().children().find('select[name^=selectUseYN]');

                    selectUseYNs.each(function () {
                        if (!isEmpty($(this).val())) {
                            nullFlag = false;
                            return false;
                        }
                    })
                }
            });

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
                    var selectUseYNs = $(this).parent().parent().children().find('select[name^=selectUseYN]');
                    var useYNArray = '';
                    var compCodesArray = ''
                    selectUseYNs.each(function () {
                        if (!isEmpty($(this).val())) {
                            useYNArray += $(this).val() + '/';
                            compCodesArray += $(this).next('#hdRowCompCode').val() + '/';
                        }

                    })
                    var param = {
                        Method: 'SaveBuyCompDisplay',
                        CompCodes: compCodesArray.slice(0, -1),
                        Gubun: 'BU',
                        PriceId:'<%= UserInfoObject.Id%>',
                        CtgrCode: categoryCode,
                        GroupCode: goodsGroupCode,
                        GoodsCode: goodsCode,
                        UseYN: useYNArray.slice(0, -1),
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
                fnGetCompDisplayList($('#compPricepagination').pagination('getSelectedPageNum'));
            }
            else {
                alert('시스템 오류입니다. 관리자에게 문의하세요.');
                return false;
            }
            return false;
        }

        //RealTime Comma찍기
        function fnAutoComma(el) {
            var price = $(el).val();

            price = price.replace(/[^\d]+/g, ''); // (,)지우기          
            $(el).val(numberWithCommas(price));   //콤마설정

            $(el).parent().parent().children().find("input[id^=cbSelect]").not(":disabled").prop("checked", true); //자동 체크박스 선택
        }

        function fnSearchGoodsEnter() {
            if (event.keyCode == 13) {
                fnCompPriceBind();
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
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div class="sub-contents-div" style="min-height: 1500px">

        <!--제목 타이틀-->
             <div class="sub-title-div">
                <p class="p-title-mainsentence">
                    구매사 Display 관리
                    <span class="span-title-subsentence"></span>
                </p>
            </div>

            <!--탭메뉴-->
             <div class="div-main-tab" style="width: 100%;">
                <ul>
                    <li class='tabOff' style="width: 185px;" onclick="fnTabClickRedirect('OSGoodsDisplayManagement');">
                        <a onclick="fnTabClickRedirect('OSGoodsDisplayManagement');">판매사 Display관리</a>
                     </li>
                    <li class='tabOn' style="width: 185px;" onclick="fnTabClickRedirect('OBGoodsDisplayManagement');">
                         <a onclick="fnTabClickRedirect('OBGoodsDisplayManagement');">구매사 Display관리</a>
                    </li>
                </ul>
            </div>
        
        <div class="bottom-search-div" style="margin-bottom: 20px">
            <table class="tbl_search" style="margin-top: 30px; margin-bottom: 30px;">
                <tr>
                    <td style="width:80px"></td>
                    <td style="width:150px"> 
                        <select id="searchTarget" style="width:150px">
                            <option value="SALE">판매사</option>
                            <option value="BUY">구매사</option>
                        </select>
                    </td>
                    <td>
                        <asp:TextBox runat="server" placeholder="검색어를 입력하세요." Style="width: 600px" ID="txtSaleCompSearch" OnKeyPress="return fnSaleCompSearchEnter();"></asp:TextBox>
                        <asp:Button runat="server" CssClass="mainbtn type1" ID="btnGoodsSearch" Style="vertical-align: middle;" OnClientClick="return fnSearchSaleCompPopup();" Text="검색" Width="75" Height="25"/>
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
                <colgroup>
                    <col width="3%" />
                    <col width="5%" />
                    <col width="6%" />
                    <col width="17%" />
                    <col width="5%" />
                    <col width="6%" />
                    <col width="10%" />
                    <col width="6%" />
                    <col width="8%" />
                    <col width="7%" />
                    <col width="7%" />
                    <col width="10%" />
                    <col width="10%" />
                </colgroup>
                <thead>
                    <tr>
                        <th class="txt-center">선택</th>
                        <th class="txt-center">업체정보</th>
                        <th class="txt-center">구매사코드</th>
                        <th class="txt-center">구매사명</th>
                        <th class="txt-center">대표자명</th>
                        <%--<th class="txt-center">판매사코드</th>
                        <th class="txt-center">판매사명</th>--%>
                        <th class="txt-center">소셜위드<br />담당자</th>
                        <th class="txt-center">유형</th>
                        <th class="txt-center">계약 시작일</th>
                        <th class="txt-center">계약 만료일</th>
                        <th class="txt-center">최종 Display 수정일</th>
                        <th class="txt-center">최종 Display 수정자</th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td class="txt-center" colspan="11">리스트가 없습니다.</td>
                    </tr>
                </tbody>

            </table>
            <!-- 페이징 처리 -->
            <div style="margin: 0 auto; text-align: center; padding-top: 10px; padding-bottom: 10px">
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
                            <input type="button" class="mainbtn type1" style="width:75px;" value="검색" onclick="fnCompPriceBind();" />
                            <%--<a onclick="fnCompPriceBind()">
                            <img alt="검색" src="../../AdminSub/Images/Goods/search-bt-off.jpg" /></a>--%>

                        </td>
                    </tr>
                    <tr>
                       <th>상세검색</th>
                            <th>상품명</th>
                            <td><input type="text" class="txtBox" id="txtGoodsName" onkeypress="fnSearchGoodsEnter();"/></td>
                            <th>상품코드</th>
                            <td><input type="text" class="txtBox" id="txtGoodsCode" onkeypress="fnSearchGoodsEnter();"/></td>
                            <th>브랜드명</th>
                            <td><input type="text" class="txtBox" id="txtBrandName" onkeypress="fnSearchGoodsEnter();"/></td>
                            <th>브랜드<br />코드</th>
                            <td><input type="text" class="txtBox" id="txtBrandCode" onkeypress="fnSearchGoodsEnter();"/></td>
                            <th>그룹코드</th>
                            <td><input type="text" class="txtBox" id="txtGroupCode" onkeypress="fnSearchGoodsEnter();"/></td>
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
                            <asp:Button ID="btnExcelUpload" runat="server" Text="엑셀업로드" CssClass="mainbtn type1"/>
                            <asp:Button ID="btnExcelFormDownload" runat="server" Text="엑셀업로드폼 다운로드" CssClass="mainbtn type1"/>
                        </td>

                           <%-- <asp:ImageButton ID="ibtnExcelUpload" AlternateText="엑셀업로드" runat="server" ImageUrl="../Images/Goods/upload-off.jpg" onmouseover="this.src='../Images/Goods/upload-on.jpg'" onmouseout="this.src='../Images/Goods/upload-off.jpg'" CssClass="upLoad" /></td>
                        <td style="border-left: none;">
                            <asp:ImageButton ID="ibtnExcelFormDownload" AlternateText="엑셀업로드폼 다운로드" runat="server" ImageUrl="../Images/Goods/formSave-off.jpg" onmouseover="this.src='../Images/Goods/formSave-on.jpg'" onmouseout="this.src='../Images/Goods/formSave-off.jpg'" CssClass="upLoad" /></td>--%>
                    </tr>
                </table>
            </div>
            <div style="display: inline-block; width: 605px; padding-left: 20px">
                <table class="tbl_main">
                    <tr>
                        <th rowspan="2">일괄적용</th>
                        <th>설정
                        </th>
                        <td rowspan="2" style="width: 100px; text-align: center">
                             <input type="button" class="mainbtn type1" style="width: 75px; height: 25px;" value="적용" onclick="fnMultiDisplaySet();" />
                            <%--<a onclick="fnMultiDisplaySet();">
                                <img id="imgBtnApply" alt="적용" src="../Images/Goods/adjust-on.jpg" onmouseover="this.src='../Images/Goods/adjust-off.jpg'" onmouseout="this.src='../Images/Goods/adjust-on.jpg'" /></a>--%>
                        </td>
                    </tr>
                    <tr>
                        <td style="text-align: center">
                            <select id="selectUnit" style="width: 90%">
                                <option value="Y">사용</option>
                                <option value="N">사용중지</option>
                            </select>
                        </td>
                        <td style="border: 1px solid #ffffff; padding-left: 30px;">
                            <input type="button" class="mainbtn type1" style="width: 95px; height: 30px;" value="저장" onclick="fnDisplaySet();" />
                            <%--<a onclick="fnDisplaySet();">
                            <img alt="저장" src="../Images/Goods/save-off.jpg" onmouseover="this.src='../Images/Goods/save-on.jpg'" onmouseout="this.src='../Images/Goods/save-off.jpg'" /></a>--%>
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
                        <th style="width: 80px" rowspan="2">선택<br />
                            <input type="checkbox" id="selectAll" onclick="fnSelectAll(this);">
                        </th>
                        <th style="width: 250px" rowspan="2">상품정보
                        </th>
                        <th style="width: 120px" rowspan="2">내용량
                        </th>
                        <th style="width: 100px" rowspan="2">그룹코드
                        </th>
                        <th style="width: 100px" rowspan="2">판매사 사용유무
                        </th>
                        <th style="width: 150px" colspan="5">구매사 설정
                        </th>
                    </tr>
                    <tr id="trHeader1" style="display: none">
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td colspan="18" class="txt-center">리스트가 없습니다.</td>
                    </tr>
                </tbody>
            </table>
           <%-- <div id="divLoading" style="display: none; position: absolute; top:0; left:0; width:100%; height:100%; background-color:rgba(0,0,0,.65);  margin: 0 auto; ">
                <img src="../Images/loading.gif" style="width: 130px; height: 130px; position:absolute;  top:20%; left:45%">
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

                        <%--<a class="imgA" onclick="fnGetCompanyList_A(1); return false;">
                            <img src="../../AdminSub/Images/Goods/search-bt-off.jpg" onmouseover="this.src='../../AdminSub/Images/Goods/search-bt-on.jpg'" onmouseout="this.src='../../AdminSub/Images/Goods/search-bt-off.jpg'" alt="검색" class="search-img" /></a>--%>
                    </div>


                    <div class="divpopup-layer-conts">
                        <input type="hidden" id="hdSelectCode" />
                        <input type="hidden" id="hdSelectName" />
                        <table id="tblPopupSaleComp" class="tbl_main">
                            <thead>
                                <tr class="">
                                    <th class="text-center">판매사명</th>
                                    <th class="text-center">판매사 코드</th>
                                </tr>
                            </thead>
                            <tbody id="goodspopup_Tbody">
                                <tr class="">
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

