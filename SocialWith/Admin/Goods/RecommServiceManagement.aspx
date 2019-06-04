<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Master/AdminMasterPage.master" AutoEventWireup="true" CodeFile="RecommServiceManagement.aspx.cs" Inherits="Admin_Goods_RecommManagement" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <script type="text/javascript">
        $(function () {
            ListCheckboxOnlyOne('tblUser_Tbody');
            ListCheckboxOnlyOne('tblGoods_Tbody');
            ListCheckboxOnlyOne('tblPopupGoods_Tbody');
            $("#tblPopupComp").on("click", "tr", function () {

                //초기화
                $("#hdSelectCode").val('');
                $("#hdSelectName").val('');
                $("#tblPopupComp tr").css("background-color", "");

                $(this).css("background-color", "#ffe6cc");

                var selectCode = $(this).find("input:hidden[id^='hdCode']").val();
                var selectName = $(this).find("input:hidden[id^='hdName']").val();

                $("#hdSelectCode").val(selectCode);
                $("#hdSelectName").val(selectName);

            });

            $("#tblPopupSaleComp").on("click", "tr", function () {

                //초기화
                $("#hdSelectSaleCompCode").val('');
                $("#hdSelectSaleCompName").val('');
                $("#tblPopupSaleComp tr").css("background-color", "");

                $(this).css("background-color", "#ffe6cc");

                var selectCode = $(this).find("input:hidden[id^='hdCode']").val();
                var selectName = $(this).find("input:hidden[id^='hdName']").val();

                $("#hdSelectSaleCompCode").val(selectCode);
                $("#hdSelectSaleCompName").val(selectName);

            });

            $("#txtGoodsSearch").bind('paste', function (e) {

                var selectVal = $('#selectGoodsSearchKeyword').val();
                if (selectVal == 'GoodsCode') {

                    var $this = $(this);
                    setTimeout(function () {
                        var agent = navigator.userAgent.toLowerCase();

                        if ((navigator.appName == 'Netscape' && agent.indexOf('trident') != -1) || (agent.indexOf("msie") != -1)) {
                            var source = window.clipboardData;

                            if (source.getData("Text").length > 0) {

                                $this.val(source.getData("Text").replace(/(\n|\r\n)/g, ','))
                            }

                        }
                        else {
                            $this.val($this.val().replace(/ /g, ','))
                        }

                    }, 0);
                }
            });
        })


        //-------------------------------사용자 검색 시작------------------------------------------------//



        function fnSearchTarget() {
            $('#txtPopSearchComp').val($('#txtUserSearch').val());
            $('#hdUsers').val('');
            $('#hdCompCodes').val('');
            if ($('#selectTarget').val() == 'COMP') {
                fnSearchCompanyList(1);
                fnOpenDivLayerPopup('searchCompdiv');
            }
            else {
                fnGetUserListSearch(1);
            }
            return false;
        }

        function fnSearchCompanyList(pageNo) {
            $("#tblPopupComp").empty();
            var pageSize = 15;
            var callback = function (response) {
                var newRowContent = '';
                if (!isEmpty(response)) {
                    $.each(response, function (key, value) { //테이블 추가


                        if (key == 0) $("#hdCompTotalCount").val(value.TotalCount);
                        newRowContent += "<tr style='cursor: pointer'>";
                        newRowContent += "<td style='text-align:center'><input type='hidden' id='hdCode' value='" + value.Company_Code + "'/><input type='hidden' id='hdName' value='" + value.Company_Name + "'/><input type='hidden' id='hdUrl' value='" + value.AtypeUrl + "'/>" + value.Company_Code + "</td>";
                        newRowContent += "<td style='text-align:center'>" + value.Company_Name + "</td>";
                        newRowContent += "<tr>";


                    });
                    $("#tblPopupComp").append(newRowContent);
                }
                else {
                    $("#hdCompTotalCount").val(0);
                    var emptyTag = "<tr><td colspan='2' class='txt-center'>조회된 데이터가 없습니다.</td></tr>";
                    $("#tblPopupComp").append(emptyTag);
                }
                fnCreatePagination('compPagination', $("#hdCompTotalCount").val(), pageNo, pageSize, getCompPageData);
                return false;
            }


            var param = {

                Gubun: 'BU',
                Keyword: $('#txtPopSearchComp').val(),
                PageNo: pageNo,
                PageSize: pageSize,
                Flag: 'GetCompanySearchList'

            };
            var beforeSend = function () {
                $('#divLoading').css('display', '');
            }
            var complete = function () {
                $('#divLoading').css('display', 'none');
            }

            //type, url, async, cache, data, datatype, _callback, _beforeSend, _complete, issessionCheck, sessionValue
            JqueryAjax('Post', '../../Handler/Admin/CompanyHandler.ashx', true, false, param, 'json', callback, beforeSend, complete, true, '<%=Svid_User%>');

        }

        function getCompPageData() {
            var container = $('#compPagination');
            var getPageNum = container.pagination('getSelectedPageNum');
            fnSearchCompanyList(getPageNum);
            return false;
        }

        function fnGetUserListSearch(pageNo) {

            $("#tblUser_Tbody").empty();
            var pageSize = 10;
            var callback = function (response) {
                var newRowContent = '';
                if (!isEmpty(response)) {
                    $.each(response, function (key, value) { //테이블 추가


                        if (key == 0) $("#hdUserTotalCount").val(value.TotalCount);
                        newRowContent += "<tr>";
                        newRowContent += "<td style='text-align:center'>";
                        newRowContent += "<input type= 'hidden' id= 'hdListSvidUser' value= '" + value.Svid_User + "' />";
                        newRowContent += "<input type= 'hidden' id= 'hdListCompCode' value= '" + value.UserInfo.Company_Code + "' />";
                        newRowContent += "<input type= 'hidden' id= 'hdListSaleCompCode' value= '" + value.UserInfo.SaleCompCode + "' />";
                        newRowContent += "<input type= 'hidden' id= 'hdListBChcek' value= '" + value.UserInfo.BdongshinCheck + "' />";
                        newRowContent += "<input type= 'hidden' id= 'hdListFreeCompYn' value= '" + value.UserInfo.FreeCompanyYN + "' />";
                        newRowContent += "<input type= 'hidden' id= 'hdListFreeCompVatYn' value= '" + value.UserInfo.FreeCompanyVATYN + "' />";
                        newRowContent += "<input type='checkbox' id='cbUser'/>";
                        newRowContent += "</td>";
                        newRowContent += "<td style='text-align:center'>" + value.RowNum + "</td>";
                        newRowContent += "<td style='text-align:center'>" + value.UserInfo.CompanyType_Name + "</td>";
                        newRowContent += "<td style='text-align:center'>" + value.UserInfo.Company_Code + "</td>";
                        newRowContent += "<td style='text-align:center'>" + value.UserInfo.Company_Name + "</td>";
                        newRowContent += "<td style='text-align:center'>" + value.UserInfo.CompanyArea_Name + "</td>";
                        newRowContent += "<td style='text-align:center'>" + value.UserInfo.CompBusinessDept_Name + "</td>";
                        newRowContent += "<td style='text-align:center'>" + value.UserInfo.CompanyDept_Name + "</td>";
                        newRowContent += "<td style='text-align:center'>" + value.Name + "</td>";
                        newRowContent += "</tr>";


                    });
                    $("#tblUser_Tbody").append(newRowContent);
                }
                else {
                    $("#hdUserTotalCount").val(0);
                    var emptyTag = "<tr><td colspan='9' class='txt-center'>조회된 데이터가 없습니다.</td></tr>";
                    $("#tblUser_Tbody").append(emptyTag);
                }



                fnCreatePagination('userPagination', $("#hdUserTotalCount").val(), pageNo, pageSize, getUserPageData);
                return false;
            }

            var keyword = '';

            if ($('#selectTarget').val() == 'USER') {

                keyword = $('#txtUserSearch').val();
            }
            else {

                keyword = $("#hdSelectCode").val();
            }
            var param = {

                SearchType: $('#selectTarget').val(),
                SearchKeyword: keyword,
                PageNo: pageNo,
                PageSize: pageSize,
                Method: 'GetGoodsRecommUserList'

            };
            var beforeSend = function () {
                $('#divLoading').css('display', '');
            }
            var complete = function () {
                $('#divLoading').css('display', 'none');
            }

            //type, url, async, cache, data, datatype, _callback, _beforeSend, _complete, issessionCheck, sessionValue
            JqueryAjax('Post', '../../Handler/GoodsRecommHandler.ashx', true, false, param, 'json', callback, beforeSend, complete, true, '<%=Svid_User%>');

        }


        function getUserPageData() {
            var container = $('#userPagination');
            var getPageNum = container.pagination('getSelectedPageNum');
            fnGetUserListSearch(getPageNum);
            return false;
        }
        function fnPopupCompSearchEnter() {

            if (event.keyCode == 13) {
                fnSearchCompanyList(1);
                return false;
            }
            else
                return true;
        }
        function fnCompSearchEnter() {

            if (event.keyCode == 13) {
                fnSearchTarget();
                return false;
            }
            else
                return true;
        }

        function fnConfirm() {
            var hdCode = $("#hdSelectCode").val();
            var hdName = $("#hdSelectName").val();

            if (isEmpty(hdCode)) {
                alert('회사를 선택해 주세요.');
                return false;
            }
            fnGetUserListSearch(1);
            fnClosePopup('searchCompdiv');
        }
        //-------------------------------사용자 검색 끝------------------------------------------------//



        //-------------------------------상품조회 팝업 시작 ---------------------------------------------//

        function fnGoodsSearchEnter() {


            if (event.keyCode == 13) {
                fnOpenGoodsPopup();
                return false;
            }
            else
                return true;
        }

        function fnPopupGoodsSearchEnter() {
            if (event.keyCode == 13) {
                fnGoodsDataBind(1);
                return false;
            }
            else
                return true;

        }

        //상품조회  팝업
        function fnOpenGoodsPopup() {

            var selectUserLength = $('#tblUser_Tbody input[type="checkbox"]:checked').length;
            if (selectUserLength < 1) {
                alert('구매자를 선택해 주세요.');
                return false;

            }
            
            var selectGoodsLength = $('#tblGoods_Tbody #tdRowIndex').length;
            if (selectGoodsLength > 0) {
                alert('이미 선택한 서비스가 있습니다. 서비스를 삭제하시고 다시 검색해주세요.');
                return false;
            }

            var keyword = $('#txtGoodsSearch').val();
            if (keyword == '') {
                alert('서비스 관련 검색어를 입력하세요.');
                return false;
            }
            $('#selectPopupGoodsTarget').val($('#selectGoodsSearchKeyword').val());
            $('#txtPopSearchGoods').val($('#txtGoodsSearch').val());
            $("#tblPopupGoods_Tbody").empty(); //데이터 클리어
            $('#popupGoodsPagination').css('display', 'none');
            $('#selectAllGoods').prop('checked', false)
            fnGoodsDataBind(1);

            //var e = document.getElementById('goodsListPopupdiv');

            //if (e.style.display == 'block') {
            //    e.style.display = 'none';

            //} else {
            //    e.style.display = 'block';
            //}

            fnOpenDivLayerPopup('goodsListPopupdiv');

            return false;
        }

        //상품 데이터 바인딩
        function fnGoodsDataBind(pageNo) {


            var callback = function (response) {
                $("#tblPopupGoods_Tbody").empty(); //데이터 클리어
                if (!isEmpty(response)) {

                    var listTag = "";

                    $.each(response, function (key, value) {
                        $('#popupGoodsPagination').css('display', 'inline-block');
                        $('#hdPopupGoodsTotalCount').val(value.TotalCount);
                        listTag += "<tr>"
                            + "<td class='txt-center'><input type='checkbox' id='cbGoodsSelect'></td>"
                            + "<td class='txt-center'><input type='hidden' id='hdPopupGoodsCode' value='" + value.GoodsCode + "' /><input type='hidden' id='hdPopupGoodsName' value='" + value.GoodsFinalName + "' />" + value.GoodsCode + "</td>"
                            + "<td class='txt-center'>" + value.GoodsFinalName + "</td>"
                            + "</tr>";
                    });

                    $("#tblPopupGoods_Tbody").append(listTag);
                    fnCreatePagination('popupGoodsPagination', $("#hdPopupGoodsTotalCount").val(), pageNo, 15, getGoodsPopupPageData);

                } else {
                    var emptyTag = "<tr><td colspan='3' class='txt-center'>조회된 데이터가 없습니다.</td></tr>";

                    $("#tblPopupGoods_Tbody").append(emptyTag);
                }

                return false;
            };
            var sUser = '<%=Svid_User %>';
            var param = {
                Target: $('#selectPopupGoodsTarget').val(),
                Keyword: $('#txtPopSearchGoods').val(),
                PageNo: pageNo,
                PageSize: 15,
                Method: 'GetGoodsSearchList'
            };
            JqueryAjax('Post', '../../Handler/GoodsHandler.ashx', true, false, param, 'json', callback, null, null, true, '<%=Svid_User%>');
        }

        //페이징 인덱스 클릭시 상품데이터 바인딩
        function getGoodsPopupPageData() {
            var container = $('#popupGoodsPagination');
            var getPageNum = container.pagination('getSelectedPageNum');
            fnGoodsDataBind(getPageNum);
            return false;
        }

        //상품 확인클릭
        function fnPopupOkGoods() {

            var callback = function (response) {
                $('#GoodsEmptyRow').remove(); //테이블 클리어
                Array.prototype.contains = function (element) {
                    for (var i = 0; i < this.length; i++) {
                        if (this[i] == element) {
                            return true;
                        }
                    }
                    return false;
                }

                var newRowContent = "";
                if (!isEmpty(response)) {
                    var curCodesArray = new Array();
                    $('#tblGoods_Tbody > tr').each(function () {
                        curCodesArray.push($(this).children().find('#hdGoodsCode').val());
                    });

                    $.each(response, function (key, value) { //테이블 추가

                        if (curCodesArray.contains(value.GoodsCode) == false) {
                            newRowContent += "<tr style='height:40px'>";
                            newRowContent += "<td class='txt-center'><input type='checkbox' id='cbSelect' checked='checked' /><br/><input type='button' class='listBtn' id='imgRowDelete' style='width:50px; height:22px; font-size:12px' value='삭제' onclick='fnRowDelete(this)' style='cursor:pointer'>";
                            newRowContent += "<input type='hidden' id='hdCategoryCode' value='" + value.GoodsFinalCategoryCode + "'/>";
                            newRowContent += "<input type='hidden' id='hdGroupCode' value='" + value.GoodsGroupCode + "'/>";
                            newRowContent += "<input type='hidden' id='hdGoodsCode' value='" + value.GoodsCode + "'/>";
                            newRowContent += "<input type='hidden' id='hdBrandCode' value='" + value.BrandCode + "'/>";
                            newRowContent += "<input type='hidden' id='hdSalePrice' value='" + value.GoodsSalePrice + "'/>";
                            newRowContent += "<input type='hidden' id='hdSalePriceVat' value='" + value.GoodsSalePriceVat + "'/>";
                            newRowContent += "<input type='hidden' id='hdMoq' value='" + value.GoodsUnitMoq + "'/>";
                            newRowContent += "</td>"; //선택
                            newRowContent += "<td class='txt-center' id='tdRowIndex'>" + parseInt(key + 1) + "</td>";  //번호
                            newRowContent += "<td style='text-align:left'>" + value.GoodsCode + "<br/>" + value.GoodsFinalName + "(" + value.GoodsModel + ")<br/>*" + value.BrandName + "<br/>" + value.GoodsOptionSummaryValues + "</td>";  //상품정보
                            newRowContent += "<td class='txt-center'>" + value.GoodsUnitMoq + "</td>";  //최소수량
                            newRowContent += "<td class='txt-center'>" + value.GoodsUnitName + "</td>";  //단위
                            newRowContent += "<td class='txt-center'>" + numberWithCommas(value.GoodsCustPrice) + "원<br>";  //판매가
                            newRowContent += "<div id='divVatPrice' style='float:left; height:20px; padding-left:7px'><img src='/Images/tax_icon.png' width='20' height='20'/><label style='color:red' id='lblCustPriceVAT_A'>" + numberWithCommas(value.GoodsCustPriceVat) + "</label><label style='color:red'>원</label></div></td>";  //판매가격(vat)
                            newRowContent += "<td class='txt-center'><input type='text' id='txtChangeCustPrice' onkeypress='onlyNumbers(event)' style='width:70px'  onkeyup='return fnAutoComma(this, \"cust\");' value='" + numberWithCommas(value.GoodsCustPrice) + "'/>원";  //판매가 변경
                            newRowContent += "<div id='divVatPrice' style='float:left; height:20px; padding-left:7px'><img src='/Images/tax_icon.png' width='20' height='20'/><label style='color:red' id='lblCustPriceVAT'>" + numberWithCommas(value.GoodsCustPriceVat) + "</label><label style='color:red'>원</label></div></td>";  //판매가격변경(vat)
                            var saleCompYield = roundXL((1 - (value.GoodsCustPrice / value.GoodsSalePrice)) * 100, 1);
                            newRowContent += "<td class='txt-center'>" + saleCompYield + "%</td>";  //판매가 수익률
                            newRowContent += "<td class='txt-center'>" + numberWithCommas(value.GoodsSalePrice) + "원";  //구매가
                            newRowContent += "<div id='divVatPrice' style='float:left; height:20px; padding-left:7px'><img src='/Images/tax_icon.png' width='20' height='20'/><label style='color:red' id='lblSalePriceVAT_A'>" + numberWithCommas(value.GoodsSalePriceVat) + "</label><label style='color:red'>원</label></div></td>";  //구매가격(vat)
                            newRowContent += "<td class='txt-center'><input type='text' id='txtChangeSalePrice' onkeypress='onlyNumbers(event)'style='width:70px' onkeyup='return fnAutoComma(this, \"sale\");' value='" + numberWithCommas(value.GoodsSalePrice) + "'/>원";  //구매가 변경
                            newRowContent += "<div id='divVatPrice' style='float:left; height:20px; padding-left:7px'><img src='/Images/tax_icon.png' width='20' height='20'/><label style='color:red' id='lblSalePriceVAT'>" + numberWithCommas(value.GoodsSalePriceVat) + "</label><label style='color:red'>원</label></div></td>";  //구매가격변경(vat)
                            var buyCompYield = roundXL((1 - (value.GoodsBuyPrice / value.GoodsCustPrice)) * 100, 1);
                            newRowContent += "<td class='txt-center'>" + buyCompYield + "%</td>";  //소셜위드 수익률
                            newRowContent += "<td id='divVatPrice' class='txt-center'>"
                            newRowContent += "<span class='input-qty'>"
                            newRowContent += "<input type='number' id='txtQty'   value='" + value.GoodsUnitMoq + "'  onblur='fnQtyTextBlur(this); return false;' style='width: calc(100% - 12px); height: 100%;'/>"
                            newRowContent += "<a class='input-arrow-up' id='arrowUp' onclick='return fnArrowClick(this , \"up\");' ><img src='/Images/inputarrow_up.png' width='9' height='9' class='imgarrowup' /></a>"
                            newRowContent += "<a class='input-arrow-down' id='arrowDown' onclick='return fnArrowClick(this ,\"down\");'><img src='/Images/inputarrow_down.png' width='9' height='9' class='imgarrowdown' /></a>"
                            newRowContent += "</span>";
                            newRowContent += "</td>";
                            newRowContent += "<td class='txt-center' id='tdTotalPriceVat'>" + numberWithCommas(value.GoodsSalePrice * value.GoodsUnitMoq) + "원";
                            newRowContent += "<div id='divVatPrice' style='width:100%; float:left; height:20px; padding-left:7px'><img src='/Images/tax_icon.png' width='20' height='20'/><label style='color:red' id='lblTotalPriceVAT'>" + numberWithCommas(value.GoodsSalePriceVat * value.GoodsUnitMoq) + "</label><label style='color:red'>원</label></div></td>";  //합계가격(vat)
                            newRowContent += "</tr>";
                        } //중복제거



                    });
                } else {
                    newRowContent += "<tr style='height:40px'><td colspan='13' class='txt-center'>" + "조회된 데이터가 없습니다." + "</td></tr>"

                }



                $('#tblGoods_Tbody').append(newRowContent);

                var row = 1;
                $('#tblGoods_Tbody > tr').each(function () {
                    $(this).find('#tdRowIndex').text(row);
                    row++;
                });


                fnClosePopup('goodsListPopupdiv');
                return false;
            }

            var compCode = '';
            var saleCompCode = '';
            var bCheck = '';
            var freeCompYn = '';
            var freeCompVatYn = '';

            $('#tblUser_Tbody input[type="checkbox"]').each(function () {
                if ($(this).prop('checked') == true) {
                    compCode = $(this).parent().parent().children().find('#hdListCompCode').val();
                    saleCompCode = $(this).parent().parent().children().find('#hdListSaleCompCode').val();
                    bCheck = $(this).parent().parent().children().find('#hdListBChcek').val();
                    freeCompYn = $(this).parent().parent().children().find('#hdListFreeCompYn').val();
                    freeCompVatYn = $(this).parent().parent().children().find('#hdListFreeCompVatYn').val();
                }
            });

            var codeArray = '';
            $('#tblPopupGoods tbody input[type="checkbox"]').each(function () {
                if ($(this).prop('checked') == true) {
                    var goodsCode = $(this).parent().parent().children().find('#hdPopupGoodsCode').val();
                    codeArray += goodsCode + ',';

                }
            });

            var param = {
                Method: 'GetRecommAddGoodsList',
                GoodsCodes: codeArray.slice(0, -1),
                CompCode: compCode,
                SaleCompCode: saleCompCode,
                Bcheck: bCheck,
                FreeCompYn: freeCompYn,
                FreeCompVatYn: freeCompVatYn,
            };

            var beforeSend = function () {
            };

            var complete = function () {

            };

            JqueryAjax('Post', '../../Handler/GoodsRecommHandler.ashx', false, false, param, 'json', callback, beforeSend, complete, true, '<%=Svid_User%>');
            return false;
        }

        //수량 화살표 클릭 이벤트
        function fnArrowClick(el, type) {

            if (type == 'up') {
                var moq = parseInt($(el).parent().parent().parent().children().find('#hdMoq').val());
                $(el).parent().parent().find('input[id*="txtQty"]').val(parseInt($(el).parent().parent().find('input[id*="txtQty"]').val()) + moq);
                var pricevat = $(el).parent().parent().parent().children().find('#txtChangeSalePrice').val().replace(/[^\d]+/g, '');
                var qty = $(el).parent().parent().find('input[id*="txtQty"]').val();

                var priceVatText = numberWithCommas(pricevat * qty) + "원<br/><div id='divVatPrice' style='float:left; height:20px; padding-left:7px'><img src='/Images/tax_icon.png' width='20' height='20'/><label style='color:red' id='lblTotlePriceVAT'>" + numberWithCommas(roundXL((pricevat * qty) * 1.1, -1)) + "</label><label style='color:red'>원</label></div>"
                $(el).parent().parent().parent().find('#tdTotalPriceVat').html(priceVatText);
            }
            else {
                var moq = parseInt($(el).parent().parent().parent().children().find('#hdMoq').val());
                if (parseInt($(el).parent().parent().find('input[id*="txtQty"]').val()) - moq <= 0) {
                    alert('수량이 0보다 작거나 같을 수 없습니다.');
                }
                else {
                    $(el).parent().find('input[id*="txtQty"]').val(parseInt($(el).parent().parent().find('input[id*="txtQty"]').val()) - moq);
                    var pricevat = $(el).parent().parent().parent().children().find('#txtChangeSalePrice').val().replace(/[^\d]+/g, '');
                    var qty = $(el).parent().parent().find('input[id*="txtQty"]').val();
                    var priceVatText = numberWithCommas(pricevat * qty) + "원<br/><div id='divVatPrice' style='float:left; height:20px; padding-left:7px'><img src='/Images/tax_icon.png' width='20' height='20'/><label style='color:red' id='lblPriceVAT'>" + numberWithCommas(roundXL((pricevat * qty) * 1.1, -1)) + "</label><label style='color:red'>원</label></div>"
                    $(el).parent().parent().parent().find('#tdTotalPriceVat').html(priceVatText);
                }
            }
            return false;
        }

        //수량 blur처리 (최소수량 단위로 작성 확인)
        function fnQtyTextBlur(el) {

            var moq = parseInt($(el).parent().parent().parent().children().find('#hdMoq').val());
            var val = parseInt($(el).val()) % moq;


            if (parseInt($(el).val()) <= 0) {
                alert('수량이 0보다 작거나 같을 수 없습니다.');
                $(el).val(moq);
                return false;

            }
            if (val != 0) {
                alert('본 서비스는 최소구매수량 단위로 구매가 가능합니다. ');
                $(el).val(moq);
                return false;
            }

            var pricevat = $(el).parent().parent().parent().children().find('#txtChangeSalePrice').val().replace(/[^\d]+/g, '');
            var qty = $(el).val();

            var priceVatText = numberWithCommas(pricevat * qty) + "원<br/><div id='divVatPrice' style='float:left; height:20px; padding-left:7px'><img src='/Images/tax_icon.png' width='20' height='20'/><label style='color:red' id='lblPriceVAT'>" + numberWithCommas(roundXL((pricevat * qty) * 1.1, -1)) + "</label><label style='color:red'>원</label></div>"
            $(el).parent().parent().parent().find('#tdTotalPriceVat').html(priceVatText);

        }
        function fnAutoComma(el, type) {

            var lblId = '';
            if (type == 'cust') {
                lblId = 'lblCustPriceVAT';
            }
            else {
                lblId = 'lblSalePriceVAT';
            }
            if ($(el).parent().find('#divVatPrice').is(':empty') == true) {
                $(el).parent().find('#divVatPrice').append("<img src='/Images/tax_icon.png' width='20' height='20'/><label style='color:red' id='lblPriceVAT'/><label style='color:red'>원</label>");
            }

            var price = $(el).val();
            price = price.replace(/[^\d]+/g, ''); // (,)지우기    
            var txtpriceVat = price * 1.1; //매입가격(VAT포함)         
            txtpriceVat = roundXL(txtpriceVat, -1);

            $(el).val(numberWithCommas(price));   //콤마설정
            $(el).parent().children().find('#' + lblId).text(numberWithCommas(txtpriceVat));   //콤마설정


            if (type == 'sale') {

                var qty = $(el).parent().parent().children().find('input[id*="txtQty"]').val();
                var totalPriceText = numberWithCommas(price * qty) + "원<br/><div id='divVatPrice' style='float:left; height:20px; padding-left:7px'><img src='/Images/tax_icon.png' width='20' height='20'/><label style='color:red' id='lblTotlePriceVAT'>" + numberWithCommas(roundXL((price * qty) * 1.1, -1)) + "</label><label style='color:red'>원</label></div>"
                $(el).parent().parent().find('#tdTotalPriceVat').html(totalPriceText);
            }
            return false;
        }

        function roundXL(num, digits) {
            digits = Math.pow(10, digits);
            return Math.round(num * digits) / digits;
        };



        function fnRowDelete(el) {

            $(el).parent().parent().remove();
            var rowCnt = $("#tblGoods_Tbody tr").length;
            if (rowCnt == 0) {
                $('#tblGoods_Tbody').append("<tr style='height:30px' id='GoodsEmptyRow'><td colspan='13' class='txt-center'>" + "조회된 데이터가 없습니다." + "</td></tr>");
            }

            var row = 1;
            $('#tblGoods_Tbody > tr').each(function () {
                $(this).find('#tdRowIndex').text(row);
                row++;
            });
            return false;
        }
        //-------------------------------상품조회 팝업 끝 ---------------------------------------------//

        var is_sending = false;
        function fnSaveGoodsRecomm() {


            var selectUserLength = $('#tblUser_Tbody input[type="checkbox"]:checked').length;
            if (selectUserLength < 1) {
                alert('구매자를 선택해 주세요.');
                return false;

            }

            if ($("#hdSelectSaleCompCode").val() == '') {
                alert('판매사를 선택해 주세요.');
                return false;
            }

            var selectCompLength = $('#tblGoods_Tbody input[type="checkbox"]:checked').length;
            if (selectCompLength < 1) {
                alert('서비스를 선택해 주세요.');
                return false;

            }

            if ($('#txtSubject').val() == '') {
                alert('제목은 필수입력 사항입니다.');
                $('#txtSubject').focus();
                return false;
            }

            if ($('#txtContent').val() == '') {
                alert('내용은 필수입력 사항입니다.');
                $('#txtContent').focus();
                return false;
            }

            var svidArray = '';
            var compCodeArray = '';
            var categoryCodeArray = '';
            var goodsGroupCodeArray = '';
            var goodsCodeArray = '';
            var priceArray = '';
            var priceVatArray = '';
            var priceCustArray = '';
            var priceCustVatArray = '';
            var qtyArray = '';
            var seqArray = '';
            var seq = 1;

            $('#tblUser_Tbody input[type="checkbox"]').each(function () {
                if ($(this).prop('checked') == true) {
                    var svidUser = $(this).parent().parent().children().find('#hdListSvidUser').val();
                    var compCode = $(this).parent().parent().children().find('#hdListCompCode').val();

                    svidArray += svidUser + '/';
                    compCodeArray += compCode + '/';
                }
            });

            $('#tblGoods_Tbody input[type="checkbox"]').each(function () {
                if ($(this).prop('checked') == true) {

                    var categoryCode = $(this).parent().parent().children().find('#hdCategoryCode').val();
                    var goodsGroupCode = $(this).parent().parent().children().find('#hdGroupCode').val();
                    var goodsCode = $(this).parent().parent().children().find('#hdGoodsCode').val();
                    var price = $(this).parent().parent().children().find('#txtChangeSalePrice').val().replace(/[^\d]+/g, '');
                    var priceVat = $(this).parent().parent().children().find('#lblSalePriceVAT').text().replace(/[^\d]+/g, '');
                    var custPrice = $(this).parent().parent().children().find('#txtChangeCustPrice').val().replace(/[^\d]+/g, '');
                    var custPriceVat = $(this).parent().parent().children().find('#lblCustPriceVAT').text().replace(/[^\d]+/g, '');
                    var qty = $(this).parent().parent().children().find('#txtQty').val();
                    categoryCodeArray += categoryCode + '/';
                    goodsGroupCodeArray += goodsGroupCode + '/';
                    goodsCodeArray += goodsCode + '/';
                    priceArray += price + '/';
                    priceVatArray += priceVat + '/';
                    priceCustArray += custPrice + '/';
                    priceCustVatArray += custPriceVat + '/';
                    qtyArray += qty + '/';
                    seqArray += seq + '/';

                    seq++;
                }
            });

            if (!confirm('저장하시겠습니까?')) {
                return false;
            }
            var callback = function (response) {
                if (response == 'Success') {
                    alert('저장되었습니다.');
                    location.href = 'RecommServiceListSearch.aspx?ucode=' + ucode;
                }
                else {
                    alert('시스템 오류입니다. 관리자에게 문의하세요.');
                }
                return false;
            }

            <%--var param = {
                Method: 'SaveGoodsRecommService',
                SvidUser: svidArray.slice(0, -1),
                SaleCompCode : $("#hdSelectSaleCompCode").val(),
                BuyCompCode: compCodeArray.slice(0, -1),
                Subject: $('#txtSubject').val(),
                Remark: $('#txtContent').val(),
                AdminId: '<%= AdminId%>',
                CategoryCodes: categoryCodeArray.slice(0, -1),
                GroupCodes: goodsGroupCodeArray.slice(0, -1),
                GoodsCodes: goodsCodeArray.slice(0, -1),
                Prices: priceArray.slice(0, -1),
                PriceVats: priceVatArray.slice(0, -1),
                CustPrices: priceCustArray.slice(0, -1),
                CustPriceVats: priceCustVatArray.slice(0, -1),
                Qtys: qtyArray.slice(0, -1),
                Seqs: seqArray.slice(0, -1),
                Gubun: 'RS',
            };--%>
            if (is_sending) return false;
            $.ajax({
                type: "POST",
                url: '../../Handler/GoodsRecommHandler.ashx',
                async: false,
                contentType: false,
                processData: false,
                success: callback,
                beforeSend: function () {
                    is_sending = true;
                },
                complete: function () {
                    is_sending = false;
                },
                data: function () {
                    var data = new FormData();
                    data.append("Method", 'SaveGoodsRecommService');
                    data.append("SvidUser", svidArray.slice(0, -1));
                    data.append("SaleCompCode", $("#hdSelectSaleCompCode").val());
                    data.append("BuyCompCode", compCodeArray.slice(0, -1));
                    data.append("Subject", $('#txtSubject').val());
                    data.append("Remark", $('#txtContent').val());
                    data.append("AdminId", '<%= AdminId%>');
                    data.append("CategoryCodes", categoryCodeArray.slice(0, -1));
                    data.append("GroupCodes", goodsGroupCodeArray.slice(0, -1));
                    data.append("GoodsCodes", goodsCodeArray.slice(0, -1));
                    data.append("Prices", priceArray.slice(0, -1));
                    data.append("PriceVats", priceVatArray.slice(0, -1));
                    data.append("CustPrices", priceCustArray.slice(0, -1));
                    data.append("CustPriceVats", priceCustVatArray.slice(0, -1));
                    data.append("Qtys", qtyArray.slice(0, -1));
                    data.append("Seqs", seqArray.slice(0, -1));
                    data.append("Gubun", 'RS');
                    data.append('GFile', $('#fuFile').get(0).files[0]);

                    return data;
                }(),
                dataType: 'text',
            });

            //var beforeSend = function () {
            //    is_sending = true;
            //}
            //var complete = function () {
            //    is_sending = false;
            //}

            //if (is_sending) return false;
            //JqueryAjax('Post', '../../Handler/GoodsRecommHandler.ashx', true, false, param, 'text', callback, beforeSend, complete, true, '<%=Svid_User%>');
            return false;
        }

        function fnTabClickRedirect(pageName) {
            location.href = pageName + '.aspx?ucode=' + ucode;
            return false;
        }


        function fnSearchCompanyPopup() {
            $('#txtPopSearchSaleComp').val('');
            fnSearchSaleCompanyList(1);
            fnOpenDivLayerPopup('searchSaleCompdiv');
        }


        function fnSearchSaleCompanyList(pageNo) {

            $("#tblPopupSaleComp").empty();
            var pageSize = 15;
            var callback = function (response) {
                var newRowContent = '';
                if (!isEmpty(response)) {
                    $.each(response, function (key, value) { //테이블 추가


                        if (key == 0) $("#hdSaleCompTotalCount").val(value.TotalCount);
                        newRowContent += "<tr style='cursor: pointer'>";
                        newRowContent += "<td style='text-align:center'><input type='hidden' id='hdCode' value='" + value.Company_Code + "'/><input type='hidden' id='hdName' value='" + value.Company_Name + "'/><input type='hidden' id='hdUrl' value='" + value.AtypeUrl + "'/>" + value.Company_Code + "</td>";
                        newRowContent += "<td style='text-align:center'>" + value.Company_Name + "</td>";
                        newRowContent += "<tr>";


                    });
                    $("#tblPopupSaleComp").append(newRowContent);
                }
                else {
                    $("#hdSaleCompTotalCount").val(0);
                    var emptyTag = "<tr><td colspan='2' class='txt-center'>조회된 데이터가 없습니다.</td></tr>";
                    $("#tblPopupSaleComp").append(emptyTag);
                }
                fnCreatePagination('saleCompPagination', $("#hdSaleCompTotalCount").val(), pageNo, pageSize, getSaleCompPageData);
                return false;
            }

            var param = {

                Gubun: 'SU',
                Keyword: $('#txtPopSearchSaleComp').val(),
                PageNo: pageNo,
                PageSize: pageSize,
                Flag: 'GetCompanySearchList'

            };


            //type, url, async, cache, data, datatype, _callback, _beforeSend, _complete, issessionCheck, sessionValue
            JqueryAjax('Post', '../../Handler/Admin/CompanyHandler.ashx', true, false, param, 'json', callback, null, null, true, '<%=Svid_User%>');

        }

        function getSaleCompPageData() {
            var container = $('#saleCompPagination');
            var getPageNum = container.pagination('getSelectedPageNum');
            fnSearchSaleCompanyList(getPageNum);
            return false;
        }
        function fnSaleCompPopupEnter() {
            if (event.keyCode == 13) {
                fnSearchSaleCompanyList(1);
                return false;
            }
            else
                return true;
        }
        function fnSaleCompSearchEnter() {

            if (event.keyCode == 13) {
                fnSearchCompanyPopup();
                return false;
            }
            else
                return true;
        }

        function fnSaleCompConfirm() {
            var hdCode = $("#hdSelectSaleCompCode").val();
            var hdName = $("#hdSelectSaleCompName").val();

            if (isEmpty(hdCode)) {
                alert('회사를 선택해 주세요.');
                return false;
            }
            $('#txtSaleCompSearch').val(hdName);

            fnClosePopup('searchSaleCompdiv');
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div class="all">

        <div class="sub-contents-div">
            <div class="sub-title-div">
                <p class="p-title-mainsentence">
                    추천서비스용역 관리
                    <span class="span-title-subsentence"></span>
                </p>
            </div>

            <div class="div-main-tab" style="width: 100%;">
                <ul>
                    <li class='tabOn' style="width: 185px;" onclick="fnTabClickRedirect('RecommServiceManagement');">
                        <a onclick="fnTabClickRedirect('RecommServiceManagement');">추천서비스 생성</a>
                    </li>
                    <li class='tabOff' style="width: 185px;" onclick="fnTabClickRedirect('RecommServiceListSearch');">
                        <a onclick="fnTabClickRedirect('RecommServiceListSearch');">생성 리스트 조회</a>
                    </li>
                </ul>
            </div>
            <div class="search-div">
                <table class="tbl_search">
                    <tr>
                        <th>추천대상선정</th>
                        <td style="width: 80%">
                            <select style="width: 150px" id="selectTarget">
                                <option value="USER">사용자명</option>
                                <option value="COMP">구매사명</option>
                            </select>
                            <input type="text" id="txtUserSearch" placeholder="사용자명/구매사명을 입력하세요" style="width: 82%;" onkeypress="return fnCompSearchEnter();" />
                        </td>
                        <td class="txt-center">
                            <input type="button" class="mainbtn type1" style="width: 95px; height: 30px; font-size: 12px" value="검색" onclick="return fnSearchTarget(); " />
                        </td>
                    </tr>
                    <tr>
                        <th>추천대상 판매사선정</th>
                        <td style="width: 80%">
                            <input type="text" id="txtSaleCompSearch" placeholder="우측 검색버튼을 클릭하세요" style="width: 93%;" onkeypress="return fnSaleCompSearchEnter();" disabled="disabled" />
                        </td>
                        <td class="txt-center">
                            <input type="button" class="mainbtn type1" style="width: 95px; height: 30px; font-size: 12px" value="검색" onclick="return fnSearchCompanyPopup(); " />
                        </td>
                    </tr>
                </table>
            </div>
            <div style="padding-top: 10px">
                <input type="hidden" id="hdUsers" />
                <input type="hidden" id="hdCompCodes" />
                <table class="tbl_main">
                    <tr>
                        <th style="width: 60px">선택
                        </th>
                        <th style="width: 60px">번호
                        </th>
                        <th style="width: 100px">구분
                        </th>
                        <th style="width: 100px">회사코드
                        </th>
                        <th style="width: 150px">회사명
                        </th>
                        <th style="width: 120px">사업장명
                        </th>
                        <th style="width: 100px">사업부명
                        </th>
                        <th style="width: 100px">부서명
                        </th>
                        <th style="width: 100px">담당자명
                        </th>
                    </tr>
                    <tbody id="tblUser_Tbody">
                        <tr id="CompEmptyRow">
                            <td class="txt-center" colspan="9">구매자를 검색해 주세요.
                            </td>
                        </tr>
                    </tbody>
                </table>
                <!-- 페이징 처리 -->
                <div style="margin: 0 auto; text-align: center; padding-top: 10px">
                    <input type="hidden" id="hdUserTotalCount" />
                    <div id="userPagination" class="page_curl" style="display: inline-block"></div>
                </div>
            </div>
            <div style="padding-top: 10px">
                <table class="tbl_main">
                    <tr>
                        <th>제목
                        </th>
                        <td>
                            <input type="text" style="width: 100%" id="txtSubject" onkeypress="return preventEnter(event)" />
                        </td>
                    </tr>
                    <tr>
                        <th>상세사항
                        </th>
                        <td>
                            <textarea style="width: 100%" id="txtContent" rows="5"></textarea>
                        </td>
                    </tr>
                    <tr>
                        <th>견적서 업로드
                        </th>
                        <td>
                            <input type="file" id="fuFile" />
                        </td>
                    </tr>
                </table>
            </div>
            <div>
                <table class="tbl_main">
                </table>
            </div>

            <div class="search-div" style="padding-top: 10px">
                <table class="tbl_search">
                    <tr>
                        <th>서비스조회</th>
                        <td style="width: 80%">
                            <select id="selectGoodsSearchKeyword" style="width: 150px; height: 26px">
                                <option value="GoodsName">서비스명</option>
                                <option value="GoodsCode">서비스코드</option>

                            </select>
                            <input type="text" placeholder="서비스명/서비스코드를 입력하세요" style="width: 82%; height: 26px" id="txtGoodsSearch" onkeypress="return fnGoodsSearchEnter();" />
                        </td>
                        <td class="txt-center">
                            <input type="button" class="mainbtn type1" style="width: 95px; height: 30px; font-size: 12px" value="검색" onclick="fnOpenGoodsPopup(); return false;" />
                        </td>
                    </tr>
                </table>
            </div>

            <div style="padding-top: 10px">
                <table class="tbl_main">
                    <tr>
                        <th style="width: 60px">선택
                        </th>
                        <th style="width: 40px">번호
                        </th>
                        <th style="width: 280px">서비스정보
                        </th>
                        <th style="width: 80px">최소수량
                        </th>
                        <th style="width: 100px">단위
                        </th>
                        <th style="width: 90px">판매가
                        </th>
                        <th style="width: 110px">변경가
                        </th>
                        <th style="width: 70px">판매사<br />
                            수익률
                        </th>
                        <th style="width: 90px">구매가
                        </th>
                        <th style="width: 110px">변경가
                        </th>
                        <th style="width: 70px">소셜위드<br />
                            수익률
                        </th>
                        <th style="width: 40px">수량
                        </th>
                        <th style="width: 120px">합계금액
                        </th>
                    </tr>
                    <tbody id="tblGoods_Tbody">
                        <tr id="GoodsEmptyRow">
                            <td class="txt-center" colspan="13">서비스를 검색해 주세요.
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>
            <div style="padding-top: 10px; float: right">
                <input type="button" class="mainbtn type1" style="width: 95px; height: 30px; font-size: 12px" value="저장" onclick="return fnSaveGoodsRecomm();" />
            </div>
        </div>
    </div>
    <%--회사 검색 팝업--%>
    <div id="searchCompdiv" class="popupdiv divpopup-layer-package">
        <div class="popupdivWrapper" style="width: 650px; height: 730px">
            <div class="popupdivContents">

                <div class="close-div">
                    <a onclick="fnClosePopup('searchCompdiv'); return false;" style="cursor: pointer">
                        <img src="../../Images/Wish/icon-delete.jpg" alt="닫기" style="float: right;" /></a>
                </div>
                <div class="popup-title">
                    <h3 class="pop-title">회사검색</h3>
                </div>
                <div class="search-div">
                    <input type="text" class="" id="txtPopSearchComp" style="width: 300px; height: 26px" onkeypress="return fnPopupCompSearchEnter();" />
                    <input type="button" class="mainbtn type1" style="width: 75px; height: 25px; font-size: 12px" value="검색" onclick="fnSearchCompanyList(1); return false;" />
                </div>


                <div class="divpopup-layer-conts">
                    <input type="hidden" id="hdSelectCode" />
                    <input type="hidden" id="hdSelectName" />
                    <input type="hidden" id="hdSelectGubun" />
                    <table class="tbl_main tbl_popup" style="margin-top: 0; width: 100%">
                        <thead>
                            <tr>
                                <th class="text-center" style="width: 40%">회사코드</th>
                                <th class="text-center">회사명</th>
                            </tr>
                        </thead>
                        <tbody id="tblPopupComp">
                            <tr>
                                <td colspan="2" class="text-center">리스트가 없습니다.</td>
                            </tr>
                        </tbody>
                    </table>
                    <br />
                    <!-- 페이징 처리 -->
                    <div style="margin: 0 auto; text-align: center; padding-top: 10px">
                        <input type="hidden" id="hdCompTotalCount" />
                        <div id="compPagination" class="page_curl" style="display: inline-block"></div>
                    </div>
                </div>

                <div style="text-align: right; margin-top: 10px;">
                    <input type="button" class="mainbtn type1" style="width: 95px; height: 30px; font-size: 12px" value="확인" onclick="fnConfirm(); return false;" />
                </div>

            </div>
        </div>
    </div>

    <%--상품 팝업--%>
    <div id="goodsListPopupdiv" class="popupdiv divpopup-layer-package">
        <div class="popupdivWrapper" style="width: 650px; height: 750px; margin: 30px auto;">
            <div class="popupdivContents">

                <div class="close-div">
                    <a onclick="fnClosePopup('goodsListPopupdiv'); return false;" style="cursor: pointer">
                        <img src="../Images/icon-delete.jpg" alt="닫기" style="float: right;" /></a>
                </div>
                <div class="popup-title">
                    <h3 class="pop-title">서비스 조회</h3>
                </div>


                <div class="search-div" style="margin-bottom: 20px;">
                    <select id="selectPopupGoodsTarget" style="height: 30px; width: 150px; vertical-align: baseline">
                        <option value="GoodsName">서비스명
                        </option>
                        <option value="GoodsCode">서비스코드
                        </option>
                    </select>
                    <input type="text" class="text-code" id="txtPopSearchGoods" placeholder="검색어를 입력하세요" onkeypress="return fnPopupGoodsSearchEnter();" style="width: 300px" />
                    <input type="button" class="mainbtn type1" style="width: 95px; height: 30px;" value="검색" onclick="fnGoodsDataBind(1); return false;" />
                </div>


                <div class="divpopup-layer-conts">
                    <table id="tblPopupGoods" class="tbl_main tbl_pop" style="margin-top: 0; width: 100%">
                        <thead>
                            <tr>
                                <th style="width: 50px; text-align: center">선택</th>
                                <th class="text-center" style="width: 150px">서비스코드</th>
                                <th class="text-center" style="width: auto">서비스명</th>
                            </tr>
                        </thead>
                        <tbody id="tblPopupGoods_Tbody">
                            <tr class="board-tr-height">
                                <td colspan="3" class="text-center">리스트가 없습니다.</td>
                            </tr>
                        </tbody>
                    </table>
                    <!-- 페이징 처리 -->
                    <div style="margin: 0 auto; text-align: center; padding-top: 10px">
                        <input type="hidden" id="hdPopupGoodsTotalCount" />
                        <div id="popupGoodsPagination" class="page_curl" style="display: inline-block"></div>
                    </div>
                </div>

                <div style="text-align: right; margin-top: 30px;">
                    <input type="button" class="mainbtn type1" style="width: 95px; height: 30px;" value="확인" onclick="fnPopupOkGoods(); return false;" />
                </div>

            </div>
        </div>
    </div>

    <%--판매사 회사 검색 팝업--%>
    <div id="searchSaleCompdiv" class="popupdiv divpopup-layer-package">
        <div class="popupdivWrapper" style="width: 650px; height: 730px">
            <div class="popupdivContents">

                <div class="close-div">
                    <a onclick="fnClosePopup('searchSaleCompdiv'); return false;" style="cursor: pointer">
                        <img src="../../Images/Wish/icon-delete.jpg" alt="닫기" style="float: right;" /></a>
                </div>
                <div class="popup-title">
                    <h3 class="pop-title">회사검색</h3>
                </div>
                <div class="search-div">
                    <input type="text" id="txtPopSearchSaleComp" onkeypress="return fnSaleCompPopupEnter();" style="width: 300px;" />
                    <input type="button" class="mainbtn type1" style="width: 75px; height: 25px;" value="검색" onclick="fnSearchSaleCompanyList(1); return false;" />
                </div>


                <div class="divpopup-layer-conts">
                    <input type="hidden" id="hdSelectSaleCompCode" />
                    <input type="hidden" id="hdSelectSaleCompName" />
                    <input type="hidden" id="hdSelectSaleCompGubun" />
                    <table class="tbl_main tbl_pop">
                        <thead>
                            <tr>
                                <th class="text-center" style="width: 40%">회사코드</th>
                                <th class="text-center">회사명</th>
                            </tr>
                        </thead>
                        <tbody id="tblPopupSaleComp">
                            <tr>
                                <td colspan="2" class="text-center">리스트가 없습니다.</td>
                            </tr>
                        </tbody>
                    </table>
                    <br />
                    <!-- 페이징 처리 -->
                    <div style="margin: 0 auto; text-align: center; padding-top: 10px">
                        <input type="hidden" id="hdSaleCompTotalCount" />
                        <div id="saleCompPagination" class="page_curl" style="display: inline-block"></div>
                    </div>
                </div>

                <div class="btn_center">
                    <input type="button" class="mainbtn type1" style="width: 75px;" value="확인" onclick="fnSaleCompConfirm(); return false;" />
                </div>

            </div>
        </div>
    </div>

</asp:Content>

