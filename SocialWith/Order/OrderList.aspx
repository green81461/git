<%@ Page Title="" Language="C#" MasterPageFile="~/Master/Default.master" AutoEventWireup="true" CodeFile="OrderList.aspx.cs" Inherits="Order_OrderList" %>

<%@ Import Namespace="Urian.Core" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">

    <asp:Literal runat="server" ID="orderCss" EnableViewState="false"></asp:Literal>
    <script src="../Scripts/order.js"></script>

    <style>
        table.scroll {
            width: 1020px; /* Optional */
            /* border-collapse: collapse; */
        }

            table.scroll tbody,
            table.scroll thead {
                display: block;
            }

                table.scroll thead tr th {
                    width: 100%;
                    height: 30px;
                    /*text-align: left;*/
                }

                table.scroll tbody tr td {
                    width: 100%;
                    height: 30px;
                    /*text-align: left;*/
                }

            table.scroll tbody {
                height: 345px;
            }

        .destination-span {
            padding: 200px;
        }

        ::-ms-clear {
            display: none;
        }

        .auto-style1 {
            position: relative;
            top: 4px;
            left: 0px;
        }
    </style>
    <script type="text/javascript">
        var is_sending = false;
        var isSocialCompExist = false
        var qs = fnGetQueryStrings();
        var GroupNo = qs["groupNo"];
        var ScompNo = qs["scompNo"];
        $(document).ready(function () {
            var compareYN = '<%= UserInfoObject.UserInfo.BPestimateCompareYN.AsText("N")%>';

            //if (compareYN == 'N') {    //로그인 계정의 구매사가 상품비교를 미사용으로 설정
            //     $('#btnPrintReport').css('display', 'none'); //가격비교 보임
            //}
            //else {
            //     $('#btnPrintReport').css('display', '');//가격비교 안보임
            //}

            $(".input-arrow-up").on("click", function () {
                var moq = parseInt($(this).parent().parent().parent().children().find("input:hidden[name^='hdGoodsUnitMoq']").val());
                $(this).parent().find('input[id*="txtGoodsNum"]').val(parseInt($(this).parent().find('input[id*="txtGoodsNum"]').val()) + moq);
            });
            $(".input-arrow-down").on("click", function () {
                var moq = parseInt($(this).parent().parent().parent().children().find("input:hidden[name^='hdGoodsUnitMoq']").val());
                if (parseInt($(this).parent().find('input[id*="txtGoodsNum"]').val()) - moq <= 0) {
                    alert('수량이 0보다 작거나 같을 수 없습니다.');
                }
                else {
                    $(this).parent().find('input[id*="txtGoodsNum"]').val(parseInt($(this).parent().find('input[id*="txtGoodsNum"]').val()) - moq);
                }
            });

            $('input[id*="txtGoodsNum"]').blur(function () {
                var moq = parseInt($(this).parent().parent().parent().children().find("input:hidden[name^='hdGoodsUnitMoq']").val());
                var qty = parseInt($(this).parent().parent().parent().children().find("input:hidden[name^='hdQty']").val());
                var val = parseInt($(this).val()) % moq;


                if (parseInt($(this).val()) <= 0) {
                    alert('수량이 0보다 작거나 같을 수 없습니다.');
                    $(this).val(qty);

                }
                if (val != 0) {
                    alert('본 상품은 최소구매수량 단위로 구매가 가능합니다. ');
                    $(this).val(qty);
                }
            });

            fnSetPageVIew(); // 화면 내용 설정

            var callback = function (response) {
                if (!isEmpty(response)) {
                    $("#tdCompanyName").text(response.UserInfo.Company_Name); //기관명
                    $("#tdCompanyDeptName").text(response.UserInfo.CompanyDept_Name); //부서명
                    $("#tdName").text(response.Name); //담당자명
                    $("#tdTelNo").text(response.TelNo); //연락처
                    $("#tdEmail").text(response.Email); //이메일
                    $("#tdAddress").text(response.UserInfo.Address_1 + " " + response.UserInfo.Address_2); //주소

                    $("#tdCompanyName2").text(response.UserInfo.Company_Name); //기관명
                    $("#tdCompanyDeptName2").text(response.UserInfo.CompanyDept_Name); //부서명
                    $("#hdBLoanYN").val(response.UserInfo.BLoanYN); //PO별 묶음 결제 여부

                    //$("#tdName2").text(response.Name); //담당자명
                    //$("#tdTelNo2").text(response.TelNo); //연락처

                    $("#txtDlvrUserNm").val(response.Name);
                    //$("#txtDlvrTelNo").val(response.TelNo.replace(/-/g, ''));
                    $("#txtDlvrTelNo").val('');


                    var telNo = response.TelNo;

                    // 결제 팝업용
                    $("#hd_pay_BuyerName").val(response.Name);
                    $("#hd_pay_BuyerTel").val(telNo.replace(/-/g, ''));
                    $("#hd_pay_Company").val(response.UserInfo.Company_Name);
                    $("#hd_pay_CompDept").val(response.UserInfo.CompanyDept_Name);
                    $("#hd_pay_Email").val(response.Email);
                    $("#hdBPayType").val(response.UserInfo.BPayType);

                    fnSetPaywayView("tdPayway", $("#hdBPayType").val()); //결제방식 내용 설정
                }
            }
            var param = { Id: '<%=UserId %>', Method: 'UserInfo' };

            var beforeSend = function () { };
            var complete = function () { };

            var goodsPriceCompareYN = '<%= UserInfoObject.UserInfo.BPestimateCompareYN%>';
            if (goodsPriceCompareYN == 'Y') {
                fnSetGoodsPriceCompareSaleCompInfo();//가격비교 사용설정시 GoodsPriceSale에서 판매사 정보를 갖고온다
            } 
            else if (goodsPriceCompareYN == 'U') { //가격비교에서 유저관리로 설정시 swp_socialcompanyuserlink에서 판매사 정보를 갖고온다 (없으면 goodsPriceCompareYN == 'Y'(가격비교 설정과 동일))
                fnSetSocialCompUserInfo();
            }
            else {
                fnSetSocialCompInfo(); //주문업체 설정
            }
            
            JqueryAjax("Post", "../Handler/OrderHandler.ashx", true, false, param, "json", callback, beforeSend, complete, true, '<%=Svid_User%>');
            fnGetDeliveryNo();
            ListCheckboxOnlyOne("tblDeliveryList"); // 체크박스 1개만 체크되는 기능



        });

        // enter key 방지
        $(document).on("keypress", "#tdPayway input", function (e) {
            if (e.keyCode == 13) {
                return false;
            }
            else
                return true;
        });

        function fnSetGoodsPriceCompareSaleCompInfo() {
            var callback = function (response) {
                if (!isEmpty(response)) {
                    isSocialCompExist = true;
                    $('#trSelectSaleComp').css('display', 'none');
                    $('#trSetSaleComp').css('display', '');
                    $('#trSelectResult').css('display', 'none');

                    for (var i = 0; i < response.length; i++) {
                        if (i == 0) {
                            $('#spanBelong').text(response[i].OrderBelongName);
                            $('#hdBelongCode').val(response[i].OrderBelongCode);
                            $('#spanArea').text(response[i].OrderAreaName);
                            $('#hdAreaCode').val(response[i].OrderAreaCode);
                            $('#spanSaleCompany').text(response[i].OrderSaleCompanyName);
                            $('#hdSaleCompCode').val(response[i].OrderSaleCompanyCode);
                            $('#hdSaleCompNo').val(response[i].CompanyNo);
                            var SaleText = $('#spanSaleCompany').text();
                            $('#selectCompanyName').text(SaleText);
                        }
                    }
                }
                else {

                    $('#trSelectSaleComp').css('display', '');
                    $('#trSetSaleComp').css('display', 'none');
                    $('#trSelectResult').css('display', '');
                    fnOrderBelongListBind();
                }
                return false;
            }
            var param = {
                SvidUser: '<%= Svid_User%>',
                CompCode: '<%= UserInfoObject.UserInfo.Company_Code%>',
                GroupNo: GroupNo,
                ScompInfoNo : ScompNo,
                Flag: 'GetGoodsPriceCompareSaleCompInfo'
            };

            var beforeSend = function () { };
            var complete = function () { };

            JqueryAjax("Post", "../Handler/Admin/CompanyHandler.ashx", true, false, param, "json", callback, beforeSend, complete, true, '<%=Svid_User%>');
        }

        function fnSetSocialCompInfo() {

            var callback = function (response) {
                if (!isEmpty(response)) {
                    isSocialCompExist = true;
                    $('#trSelectSaleComp').css('display', 'none');
                    $('#trSetSaleComp').css('display', '');
                    $('#trSelectResult').css('display', 'none');

                    for (var i = 0; i < response.length; i++) {
                        if (i == 0) {
                            $('#spanBelong').text(response[i].OrderBelongName);
                            $('#hdBelongCode').val(response[i].OrderBelongCode);
                            $('#spanArea').text(response[i].OrderAreaName);
                            $('#hdAreaCode').val(response[i].OrderAreaCode);
                            $('#spanSaleCompany').text(response[i].OrderSaleCompanyName);
                            $('#hdSaleCompCode').val(response[i].OrderSaleCompanyCode);
                            $('#hdSaleCompNo').val(response[i].CompanyNo);
                            var SaleText = $('#spanSaleCompany').text();
                            $('#selectCompanyName').text(SaleText);
                        }
                    }
                }
                else {

                    $('#trSelectSaleComp').css('display', '');
                    $('#trSetSaleComp').css('display', 'none');
                    $('#trSelectResult').css('display', '');
                    fnOrderBelongListBind();
                }
                return false;
            }
            var param = { SvidUser: '<%= Svid_User%>', Flag: 'GetSocialCompLinkInfo' };

            var beforeSend = function () { };
            var complete = function () { };

            JqueryAjax("Post", "../Handler/Admin/CompanyHandler.ashx", true, false, param, "json", callback, beforeSend, complete, true, '<%=Svid_User%>');
        }

        function fnSetSocialCompInfo() {

            var callback = function (response) {
                if (!isEmpty(response)) {
                    isSocialCompExist = true;
                    $('#trSelectSaleComp').css('display', 'none');
                    $('#trSetSaleComp').css('display', '');
                    $('#trSelectResult').css('display', 'none');

                    for (var i = 0; i < response.length; i++) {
                        if (i == 0) {
                            $('#spanBelong').text(response[i].OrderBelongName);
                            $('#hdBelongCode').val(response[i].OrderBelongCode);
                            $('#spanArea').text(response[i].OrderAreaName);
                            $('#hdAreaCode').val(response[i].OrderAreaCode);
                            $('#spanSaleCompany').text(response[i].OrderSaleCompanyName);
                            $('#hdSaleCompCode').val(response[i].OrderSaleCompanyCode);
                            $('#hdSaleCompNo').val(response[i].CompanyNo);
                            var SaleText = $('#spanSaleCompany').text();
                            $('#selectCompanyName').text(SaleText);
                        }
                    }
                }
                else {

                    $('#trSelectSaleComp').css('display', '');
                    $('#trSetSaleComp').css('display', 'none');
                    $('#trSelectResult').css('display', '');
                    fnOrderBelongListBind();
                }
                return false;
            }
            var param = { SvidUser: '<%= Svid_User%>', Flag: 'GetSocialCompLinkInfo' };

            var beforeSend = function () { };
            var complete = function () { };

            JqueryAjax("Post", "../Handler/Admin/CompanyHandler.ashx", true, false, param, "json", callback, beforeSend, complete, true, '<%=Svid_User%>');
        }

        //관계사 유저 설정(유저관리) 
        function fnSetSocialCompUserInfo() {

            var callback = function (response) {
                if (!isEmpty(response)) {
                    isSocialCompExist = true;
                    $('#trSelectSaleComp').css('display', 'none');
                    $('#trSetSaleComp').css('display', '');
                    $('#trSelectResult').css('display', 'none');

                    for (var i = 0; i < response.length; i++) {
                        if (i == 0) {
                            $('#spanBelong').text(response[i].OrderBelongName);
                            $('#hdBelongCode').val(response[i].OrderBelongCode);
                            $('#spanArea').text(response[i].OrderAreaName);
                            $('#hdAreaCode').val(response[i].OrderAreaCode);
                            $('#spanSaleCompany').text(response[i].OrderSaleCompanyName);
                            $('#hdSaleCompCode').val(response[i].OrderSaleCompanyCode);
                            $('#hdSaleCompNo').val(response[i].CompanyNo);
                            var SaleText = $('#spanSaleCompany').text();
                            $('#selectCompanyName').text(SaleText);
                        }
                    }
                }
                else {

                    fnSetSocialCompInfo();
                }
                return false;
            }
            var param = { SvidUser: '<%= Svid_User%>', Flag: 'GetSocialCompUserLinkInfo' };

            var beforeSend = function () { };
            var complete = function () { };

            JqueryAjax("Post", "../Handler/Admin/CompanyHandler.ashx", true, false, param, "json", callback, beforeSend, complete, true, '<%=Svid_User%>');
        }

        // 배송구분에 따른 메시지 출력 설정
        function fnSetDlvrGubunMsg() {
            $("#tbodyOrderList tr").each(function () {
                var dlvrGubun = $(this).find("input:hidden[name='hdDlvrGubun']").val();

                if ((dlvrGubun == "3") || (dlvrGubun == "4")) {
                    $(this).find("span[id^='spanDlvrGbnNm']").html("※업체 직배송상품으로 개별 배송됩니다.<br/>");
                    $(this).find("span[id^='spanDlvrGbnNm']").css("color", "#ff0000");
                }
            });
        }

        function fnSetTdTotPriceView(totalPrice, dlvrCost_1, dlvrCost_2) {
            var totPrice = Number(totalPrice);
            var dlvrTotCost = Number(dlvrCost_1) + Number(dlvrCost_2);

            $("#lbTotalPrice").text(numberWithCommas(totPrice));
            $("#lbTotalDlvrPrice").text(numberWithCommas(dlvrTotCost));
            $("#lbTotalPayPrice").text(numberWithCommas(totPrice + dlvrTotCost));
            $("#sumPrice").text(numberWithCommas(totPrice));
        }

        // 화면 내용 설정
        function fnSetPageVIew() {
            fnSetDlvrGubunMsg(); // 배송구분에 따른 메시지 출력 설정
            fnTotalPayDlvrCost(); // 배송비 및 총 금액 관련 설정
        }

        // 배송비 및 총 금액 관련 설정
        function fnTotalPayDlvrCost() {
            var totalPayPrice = fnGetTotalPrice(); // 주문 합계

            // 배송비 관련
            var dlvrCost_1 = 0; // 기본 배송비 합계
            var dlvrCost_2 = 0; // 특수 배송비 합계

            $("#tbodyOrderList tr").each(function () {

                var hdDlvrCostGubun = $(this).find("input:hidden[name^=hdDlvrCostGubun]").val();
                var hdDefDlvrCost = $(this).find("input:hidden[name^=hdDefDlvrCost]").val();
                var hdPowerDlvrCost = $(this).find("input:hidden[name^=hdPowerDlvrCost]").val();
                var hdMemo = $(this).find("input:hidden[name='hdMemo']").val();
                
                // 기본배송비
                if (hdDlvrCostGubun == '2') {
                    dlvrCost_1 = Number(hdDefDlvrCost);

                    // 특수배송비
                } else if (hdDlvrCostGubun == '3') {
                    dlvrCost_2 += Number(hdPowerDlvrCost);
                }
            });

            var result_dlvrCost_1 = totalPayPrice >= 50000 ? 0 : dlvrCost_1;
            var resultCost_1 = result_dlvrCost_1 == 0 ? "(무료)" : "(" + numberWithCommas(result_dlvrCost_1) + "원)";
            var resultCost_2 = dlvrCost_2 > 0 ? ", 특수 배송비 : (" + numberWithCommas(dlvrCost_2) + "원)" : '';
            var dlvrView = "기본 배송비 : " + resultCost_1 + resultCost_2;

            $("#spanDlvrPrice").text(dlvrView);

            $("#hdBasicDlvrCost").val(result_dlvrCost_1); // 기본 배송비
            $("#hdAddDlvrCost").val(dlvrCost_2); // 특수 배송비

            // 총 결제 금액 관련
            var totalDlvrCost = result_dlvrCost_1 + dlvrCost_2;

            $("#spanTotalPayPrice").text(numberWithCommas(totalDlvrCost + totalPayPrice));
            $("#hdGdsSalePriceVat").val(totalPayPrice); // 상품 합계 금액
            $("#hd_pay_Amt").val(totalDlvrCost + totalPayPrice); // 총 결제 금액

            fnSetTdTotPriceView(totalPayPrice, result_dlvrCost_1, dlvrCost_2); // 결제진행 영역에 금액 출력
        }

        // 주문 합계 구함
        function fnGetTotalPrice() {
            var totSalePrice = 0;

            $('#tblOrderGoods tbody tr').each(function (index, element) {
                var strPrice = $(element).find("input:hidden[name^='hdGdsTotSalePriceVAT']").val();

                if (!isEmpty(strPrice)) {
                    totSalePrice += Number(strPrice);
                }
            });

            return totSalePrice;
        }

        //주문상품 삭제
        function fnOrderDelete(index) {
            var selTr = $(index).parent().parent();

            if ($("#tbodyOrderList tr").length <= 1) {
                alert("상품이 1개 남은 경우에는 더이상 삭제하실 수 없습니다.");
                return false;
            }

            var uOrderTryNo = $(selTr).find("input:hidden[name^=hdUodrTryNo]").val();
            var ucartNo = $(selTr).find("input:hidden[name^=hdUnumCartNo]").val();

            var callback = function (response) {
                if (!isEmpty(response)) {
                    $.each(response, function (key, value) {
                        if (value == "OK") {
                            $(index).parent().parent().remove();

                            fnSetTdTotPriceView(); // 결제진행 영역에 금액 출력

                            fnTotalPayDlvrCost(); // 배송비 및 총 금액 관련 설정
                        }
                    });
                }
                return false;
            };

            var param = {
                SvidUser: '<%= Svid_User%>',
                UorderTryNo: uOrderTryNo,
                UcartNo: ucartNo,
                Method: "DelOrderTry"
            };

            var beforeSend = function () {
                is_sending = true;
            }
            var complete = function () {
                is_sending = false;
            }

            if (is_sending) return false;

            JqueryAjax("Post", "../Handler/OrderHandler.ashx", true, false, param, "json", callback, beforeSend, complete, true, '<%=Svid_User%>');
        }

        //주문상품목록에서 수량(합계금액)/최소수량 맞는지 검사
        function fnCheckGoodsPriceAndQty() {
            var result = ''; //Q(수량)/M(최소수량)

            //수량변경 저장여부 검사
            $.each($("#tbodyOrderList tr"), function (idx, objTr) {
                var totGdsSalePriceVAT = $(objTr).find("input:hidden[name='hdGdsTotSalePriceVAT']").val();
                var gdsSalePriceVAT = $(objTr).find("input:hidden[name='hdGdsSalePriceVAT']").val();
                var moq = $(objTr).find("input:hidden[name='hdGoodsUnitMoq']").val();
                var qty = $(objTr).find("input:text[name*='txtGoodsNum']").val();
                var calTotPrice = Number(qty) * Number(gdsSalePriceVAT);

                if ((parseInt(qty) < parseInt(moq)) || ((parseInt(qty) % parseInt(moq)) > 0)) {
                    result = "M";
                    //return result;
                    $(objTr).css("background-color", "#ffb3b3");
                    return result;
                }

                //수량변경 확인
                if (totGdsSalePriceVAT != calTotPrice) {
                    result = "Q";
                    return result;
                }
            });

            return result;
        }

        // 유효성 검사
        function fnCheckForm() {
            var postNo = $('#<%=txtPostNo.ClientID%>').val();
            var addr1 = $('#<%=txtAddr1.ClientID%>').val();
            var addr2 = $('#<%=txtAddr2.ClientID%>').val();
            var dlvrUserNm = $("#txtDlvrUserNm").val();
            var dlvrUserTelNo = $("#txtDlvrTelNo").val();

            var chkResult = fnCheckGoodsPriceAndQty();

            if (chkResult == "Q") {
                alert("주문상품 목록에서 수량을 변경하신 상품의 '수량변경' 버튼을 각각 클릭해 주시기 바랍니다.");
                return false;
            } else if (chkResult == "M") {
                alert("최소수량이 맞지 않는 상품이 있습니다. 최소수량에 맞게 수량을 변경해 주시기 바랍니다.");
                return false;
            }

            if (isEmpty(postNo) || isEmpty(addr1)) {
                alert("배송지 주소를 선택해 주세요.");
                return false;
            }

            if (isEmpty(dlvrUserNm)) {
                alert("받는사람명을 입력해 주세요.");
                return false;
            }
            if (isEmpty(dlvrUserTelNo)) {
                alert("받는사람 연락처를 입력해 주세요.");
                return false;
            }

            //배송지 요구사항 50자이상 체크
            var text = $('#txtPs').val();
            if (text.length > 50) {
                alert('50자 미만으로 입력해주세요.');
                return false;
            }

            //소속선택 셀렉트박스
            var selectGroup = $('#selectBelong option:selected').val();
            if (isEmpty(selectGroup) && isSocialCompExist == false) {
                alert("구매업체의 소속을 선택해 주세요.");
                return false;
            }

            //소속선택 셀렉트박스
            var selectRegion = $('#selectArea option:selected').val();
            if (isEmpty(selectRegion) && isSocialCompExist == false) {
                alert("구매업체의 지역을 선택해 주세요.");
                return false;
            }

            //소속선택 셀렉트박스
            var selectCompany = $('#selectSaleCompany option:selected').val();
            if (isEmpty(selectCompany) && isSocialCompExist == false) {
                alert("구매업체의 업체를 선택해 주세요.");
                return false;
            }

            var orderFlag = true;
            $('#tbodyOrderList tr').each(function (index, element) {
                if ($(this).children().find('input[id^="hfCompanyGoodsYN"]').val() == 'N' || !isEmpty($(this).children().find('input[id^="hfGoodsDisplayReason"]').val())) {
                    alert('주문할 수 없는 상품이 포함되어 있습니다. 삭제하고 주문해 주세요.');
                    orderFlag = false;
                    return false;
                }
            });

            if (!orderFlag) {
                return false;
            }
            return true;
        }

        //구매업체 소속 선택 selector바인딩
        function fnOrderBelongListBind() {
            $('#selectBelong').empty().append('<option selected="selected" value="">---선택---</option>');
            var callback = function (response) {
                $.each(response, function (key, value) {

                    var options = '<option value="' + value.OrderBelongCode + '">' + value.OrderBelongName + ' </option>'
                    $('#selectBelong').append(options);
                });
                return false;
            }
            var param = { Method: 'BelongList' };

            var beforeSend = function () { };
            var complete = function () { };

            JqueryAjax("Post", "../Handler/OrderHandler.ashx", true, false, param, "json", callback, beforeSend, complete, true, '<%=Svid_User%>');
        }

        //구매업체 지역 선택 selector바인딩
        function fnOrderAreaListBind(value) {
            $('#selectArea').empty().append('<option selected="selected" value="">---선택---</option>');  //지역선택 클리어
            $('#selectSaleCompany').empty().append('<option selected="selected" value="">---선택---</option>'); //업체선택 클리어
            $('#selectResult').text(''); //결과 클리어
            var callback = function (response) {
                $.each(response, function (key, value) {

                    var options = '<option value="' + value.OrderAreaCode + '">' + value.OrderAreaName + ' </option>'
                    $('#selectArea').append(options);
                });
                return false;
            }
            var param = { Method: 'AreaList', OrderBelongCode: value };

            var beforeSend = function () { };
            var complete = function () { };

            JqueryAjax("Post", "../Handler/OrderHandler.ashx", true, false, param, "json", callback, beforeSend, complete, true, '<%=Svid_User%>');
        }

        //구매업체 업체 선택 selector바인딩
        function fnOrderSaleCompListBind(value) {
            $('#selectSaleCompany').empty().append('<option selected="selected" value="">---선택---</option>'); //업체선택 클리어
            var callback = function (response) {

                if (!isEmpty(response)) {
                    $.each(response, function (key, value) {

                        var options = '<option value="' + value.OrderSaleCompanyCode + '" compNo="' + value.CompanyNo + '">' + value.OrderSaleCompanyName + ' </option>';
                        $('#selectSaleCompany').append(options);
                    });
                }

                return false;
            }
            var param = {
                Method: 'SaleCompList'
                , OrderBelongCode: $('#selectBelong option:selected').val()
                , OrderAreaCode: value
            };

            var beforeSend = function () { };
            var complete = function () { };

            JqueryAjax("Post", "../Handler/OrderHandler.ashx", true, false, param, "json", callback, beforeSend, complete, true, '<%=Svid_User%>');
        }

        function fnSetSelectResult() {

            var resultText = $('#selectSaleCompany option:selected').text();
            $('#selectResult').text(resultText + '을(를) 선택하였습니다.');
            $('#selectCompanyName').text(resultText);
            return false;

        }

        //배송지선택 팝업
        function fnDeliverySearchPopup() {
            $('#txtPostalCode').val('');
            $('#txtAddress1').val('');
            $('#txtAddress2').val('');
            fnDeliveryListBind();
            fnOpenDivLayerPopup('destinationDiv');
           
        }

        function fnDeliveryListBind() {

            var callback = function (response) {
                $('#tblDeliveryList tbody').empty(); //테이블 클리어
                //권한에 따라 사업장/사업부 visible 처리
                $('#thArea').css('display', fnSetDeliveryAreaTdVisible());
                $('#thBusiness').css('display', fnSetDeliveryBusinessTdVisible());
                var index = 0;
                $.each(response, function (key, value) { //테이블 추가
                    var newRowContent = "<tr>";
                    newRowContent += "<td style='width: 30px' class='txt-center'><input type='checkbox' id='cbDeliverySelect'/> </td>";  //선택
                    newRowContent += "<td style='width: 30px' class='txt-center'>" + parseInt(index + 1) + "</td>";  //구분
                    newRowContent += "<td style='width: 80px' class='txt-center'>" + fnSetDefault(value.Delivery_Default) + "</td>"; //" 기본배송지

                    //권한에 따라 사업장 visible처리
                    if (fnSetDeliveryAreaTdVisible() != 'none') {
                        newRowContent += "<td style='width: 80px; class='txt-center'>" + value.CompanyArea_Name + "</td>"; //사업장
                    }
                    //권한에 따라 사업부 visible처리
                    if (fnSetDeliveryBusinessTdVisible() != 'none') {
                        newRowContent += "<td style='width: 80px; class='txt-center'>" + value.CompBusinessDept_Name + "</td>"; //사업부
                    }

                    newRowContent += "<td style='width: 80px' class='txt-center'>" + value.CompanyDept_Name + "</td>"; //부서명
                    newRowContent += "<td style='width: 80px' class='txt-center'>" + value.Delivery_Person + "</td>"; //담당자
                    newRowContent += "<td id='tdPostal' style='width: 90px' class='txt-center'>" + value.Zipcode + "</td>"; //우편번호
                    newRowContent += "<td id='tdAddress1' style='width: 300px' class='txt-center'>" + value.Address_1 + "</td>"; //주소
                    newRowContent += "<td id='tdAddress2' style='width: 300px' class='txt-center'>" + value.Address_2 + "</td>"; //상세주소
                    $('#tblDeliveryList tbody').append(newRowContent);
                    index++;
                });


                return false;
            }
            var param = { Method: 'GetDeliveryList', SvidUser: '<%= Svid_User%>' };

            var beforeSend = function () {
                is_sending = true;
            }
            var complete = function () {
                is_sending = false;
            }
            // if (is_sending) return false;

            JqueryAjax('Post', '../Handler/Common/DeliveryHandler.ashx', true, false, param, 'json', callback, beforeSend, complete, true, '<%=Svid_User%>');

        }
        function fnGetDeliveryNo() {

            var callback = function (response) {
                $('#hdDeliveryNo').val(response);
                return false;
            }
            var param = { Method: 'GetDeliveryNo', SvidUser: '<%= Svid_User%>' };

            var beforeSend = function () {
                is_sending = true;
            }
            var complete = function () {
                is_sending = false;
            }
            //   if (is_sending) return false;

            JqueryAjax('Post', '../Handler/Common/DeliveryHandler.ashx', true, false, param, 'text', callback, beforeSend, complete, true, '<%=Svid_User%>');
        }

        //기본배송지 세팅
        function fnSetDefault(value) {
            if (value == 'Y') {
                return '✔';
            }
            return '';

        }

        //권한별 배송지 사업장 visible 세팅
        function fnSetDeliveryAreaTdVisible() {
            if ($('#hdDeliveryNo').val() == '3' || $('#hdDeliveryNo').val() == '4') {
                return 'none';
            }
            return 'block';
        }

        //권한별 배송지 사업부 visible 세팅
        function fnSetDeliveryBusinessTdVisible() {
            if ($('#hdDeliveryNo').val() == '4') {
                return 'none';
            }
            return 'block';
        }

        //배송지 선택
        function fnSelectDelivery() {

            var selectLength = $('#tblDeliveryList input[type="checkbox"]:checked').length;
            if (selectLength < 1) {
                alert('배송지를 선택해 주세요');
                return false;

            }
            //텍스트박스 클리어
            $('#<%= txtPostNo.ClientID%>').val("");
            $('#<%= txtAddr1.ClientID%>').val("");
            $('#<%= txtAddr2.ClientID%>').val("");

            var postNo = $('#tblDeliveryList tr').filter(':has(:checkbox:checked)').find('td#tdPostal').text();
            var address1 = $('#tblDeliveryList tr').filter(':has(:checkbox:checked)').find('td#tdAddress1').text();
            var address2 = $('#tblDeliveryList tr').filter(':has(:checkbox:checked)').find('td#tdAddress2').text();

            $('#<%= txtPostNo.ClientID%>').val(postNo);
            $('#<%= txtAddr1.ClientID%>').val(address1);
            $('#<%= txtAddr2.ClientID%>').val(address2);

            $('.divpopup-layer-package').fadeOut();
            return false;
        }

        // 취소 버튼 클릭 시 팝업 닫기
        function fnCancel() {
            $('.divpopup-layer-package').fadeOut();

        }

        //PO별 묶음 결제로 주문 시
        function fnBLoanOrderPay(ordCodeNo) {
            var callback = function (response) {

                if (!isEmpty(response)) {
                    if (response === "LIST") {
                        alert("성공적으로 주문이 완료되었습니다.");
                        var useSMS = '<%= ConfigurationManager.AppSettings["SendSMSUse"].AsText("false")%>';

                        if (useSMS == 'true') {
                            fnSendSMS(ordCodeNo);
                        }

                        window.location.replace("Ordersuccess.aspx");

                    } else {
                        alert("주문요청에 실패하였습니다. 브라우저 창을 닫고 다시 시도해 주시기 바랍니다.");
                    }


                } else {
                    alert("오류가 발생했습니다. 잠시후 다시 시도해 주세요.");
                }

                return false;
            }

            var param = { SvidUser: '<%= Svid_User%>', OrdCodeNo: ordCodeNo, RoleFlag: 'TYPE_1', Type: '', TypeUnumNo: '', Method: 'SaveBLoanOrder' };


            var beforeSend = function () {
                is_sending = true;
            }
            var complete = function () {
                is_sending = false;
            }
            if (is_sending) return false;

            JqueryAjax('Post', '../Handler/PayHandler.ashx', false, false, param, 'text', callback, beforeSend, complete, true, '<%=Svid_User%>');
        }

        function fnSendSMS(ordCodeNo) {
            var callback = function (response) {

                if (response != 'Success') {

                    alert("오류가 발생했습니다. 잠시후 다시 시도해 주세요.");
                }

                return false;
            }

            var param = { OrderCodeNo: ordCodeNo, Amt: $('#spanTotalPayPrice').text().replace(/[^0-9 | ^.]/g, ''), BuyCompName: $('#tdCompanyName').text(), Method: 'SendMMS' };


            var beforeSend = function () {
                //  is_sending = true;
            }
            var complete = function () {
                // is_sending = false;
            }
            // if (is_sending) return false;

            JqueryAjax('Post', '../Handler/OrderHandler.ashx', false, false, param, 'text', callback, null, null, true, '<%=Svid_User%>');
        }

        // 분할배송인지 물어보는 팝업 띄움
        function fnDialogConfirm() {

            var e = document.getElementById("ordDlvrConfirmDiv");

            if (e.style.display == "block") {
                e.style.display = "none";

            } else {
                e.style.display = "block";
            }
        }

        // 분할배송 선택 팝업에서 예/아니오 클릭 시
        function fnOrderDlvrPopupConfirm(selectVal) {

            var payway = $(":radio[name='pay']:checked").val();

            var gdsTotPriceVat = fnGetTotalPrice(); // 주문 합계 금액

            // 여신 관련
            var hfRemainPrice = $('#<%= hfRemainPrice.ClientID %>').val();
            var remainPrice = 0;

            if ((hfRemainPrice != null) && (hfRemainPrice != "null") && (hfRemainPrice != "")) {
                remainPrice = Number(hfRemainPrice);

                if (gdsTotPriceVat > remainPrice) {
                    alert("주문합계금액이 여신한도금액을 초과하였습니다.");
                    return false;
                }
            }

            var selectBelongVal = '';
            var selectAreaVal = '';
            var selectSaleCompVal = '';
            var selectSaleCompNo = '';

            if (isSocialCompExist == true) {
                selectBelongVal = $('#hdBelongCode').val();
                selectAreaVal = $('#hdAreaCode').val();
                selectSaleCompVal = $('#hdSaleCompCode').val();
                selectSaleCompNo = $('#hdSaleCompNo').val();
            }
            else {
                selectBelongVal = $("#selectBelong option:selected").val();
                selectAreaVal = $("#selectArea option:selected").val();
                selectSaleCompVal = $("#selectSaleCompany option:selected").val();
                selectSaleCompNo = $("#selectSaleCompany option:selected").attr("compNo");
            }

            // 주문내역 저장 및 결제 팝업 관련
            var gdsFinCtgrCodeArr = "";
            var gdsGrpCodeArr = "";
            var gdsCodeArr = "";
            var qtyArr = "";
            var uCartNoArr = "";
            var gdsSalePriceArr = "";
            var orderBelong_Code = selectBelongVal;
            var orderArea_Code = selectAreaVal;
            var orderSaleComp_Code = selectSaleCompVal;
            var payway = $(":radio[name='pay']:checked").val();
            //var orderStat = 100
            var orderStat = 0;
            var ordTryUnumArr = "";
            var gdsDeliTypeArr = ""; //배송기간유형

            var dlvrCost = $("#hdBasicDlvrCost").val();
            var powerDlvrCost = $("#hdAddDlvrCost").val();

            var postNo = $('#<%= txtPostNo.ClientID%>').val();
            postNo = postNo.replace(/-/g, '');
            var addr1 = $('#<%= txtAddr1.ClientID%>').val();
            var addr2 = $('#<%= txtAddr2.ClientID%>').val();
            var dlvrReqInfo = $("#txtPs").val();

            var dlvrUserNm = $("#txtDlvrUserNm").val();
            var dlvrUserTelNo = $("#txtDlvrTelNo").val();

            var arrOrdList = new Array(); //상품목록 배열에 저장

            $("#tbodyOrderList tr").each(function (idx) {
                var tmpGdsFinCtgrCode = $(this).find("input:hidden[name^='hdGdsFinCtgrCode']").val();
                var tmpGdsGrpCode = $(this).find("input:hidden[name^='hdGdsGrpCode']").val();
                var tmpGdsCode = $(this).find("input:hidden[name^='hdGdsCode']").val();
                var tmpQty = $(this).find("input:hidden[name^='hdQty']").val();
                var tmpUnumCartNo = $(this).find("input:hidden[name^='hdUnumCartNo']").val();
                var tmpGdsSalePrice = $(this).find("input:hidden[name^='hdGdsTotSalePriceVAT']").val();
                var tmpDlvrDue = $(this).find("input:hidden[name^='hdDlvrDue']").val();
                var tmpOrdTryUnum = $(this).find("input:hidden[name^='hdUodrTryNo']").val();
                var tmpDlvrDueType = '';

                arrOrdList[idx] = {
                    GdsFinCtgrCode: tmpGdsFinCtgrCode, GdsGrpCode: tmpGdsGrpCode, GdsCode: tmpGdsCode, Qty: tmpQty, UnumCartNo: tmpUnumCartNo
                    , BgtAcco: '', GdsSalePrice: tmpGdsSalePrice, DlvrDue: tmpDlvrDue, OrdTryUnum: tmpOrdTryUnum, DlvrDueType: ''
                };
            });

            var sortArrOrdList = arrOrdList;

            if (sortArrOrdList.length >= 2) {
                sortArrOrdList = arrOrdList.sort(function (a, b) {
                    return a.DlvrDue < b.DlvrDue ? -1 : a.DlvrDue > b.DlvrDue ? 1 : 0;
                });
            }

            var firstDueVal = '';

            for (var i = 0; i < sortArrOrdList.length; i++) {

                if (selectVal) { //분할배송

                    if (i == 0) {
                        firstDueVal = sortArrOrdList[i].DlvrDue;
                        sortArrOrdList[i].DlvrDueType = "21";
                    } else {

                        if (firstDueVal == sortArrOrdList[i].DlvrDue) {
                            sortArrOrdList[i].DlvrDueType = "21";

                        } else {
                            sortArrOrdList[i].DlvrDueType = "22";
                        }
                    }

                } else { //합배송

                    sortArrOrdList[i].DlvrDueType = "11";
                }
            }

            for (var i = 0; i < sortArrOrdList.length; i++) {
                gdsFinCtgrCodeArr += sortArrOrdList[i].GdsFinCtgrCode + '/';
                gdsGrpCodeArr += sortArrOrdList[i].GdsGrpCode + '/';
                gdsCodeArr += sortArrOrdList[i].GdsCode + '/';
                qtyArr += sortArrOrdList[i].Qty + '/';
                uCartNoArr += sortArrOrdList[i].UnumCartNo + '/';
                gdsSalePriceArr += sortArrOrdList[i].GdsSalePrice + '/';
                ordTryUnumArr += sortArrOrdList[i].OrdTryUnum + '/';
                gdsDeliTypeArr += sortArrOrdList[i].DlvrDueType + '/';
            }

            // 결제 팝업 화면용
            $("#hdUnumCartNoArr").val(uCartNoArr);
            $("#hdPayway").val(payway); // 결제 방법
            var goodsCnt = $("#tbodyOrderList tr").find("input:hidden[name^='hdGdsCode']").length;
            $("#hd_pay_GoodsCnt").val(goodsCnt); // 상품 개수
            $("#hd_pay_GoodsName").val($("#tbodyOrderList tr:eq(0)").find("input:hidden[name^='hdGdsName']").val() + " 외 " + (goodsCnt - 1) + "개"); // 상품명

            //(여신)고정 가상계좌 관련 값
            //var saleCompObj = document.getElementById("selectSaleCompany");
            //var selectSaleCompNo = $("#selectSaleCompany option:selected").attr("compNo");
            //var selectSaleCompCode = $("#selectSaleCompany").val();
            var myCompCode = '<%=UserInfoObject.UserInfo.Company_Code %>';

            // 합배송/분할배송 체크
            var dlvrDueTypeResult = '1';

            if (selectVal) {
                dlvrDueTypeResult = '2'; // 분할배송
            } else {
                dlvrDueTypeResult = '1'; // 합배송
            }

            var bloanYN = $("#hdBLoanYN").val(); //PO별 묶음 결제 사용 여부
            var bloanYNFlag = '';

            if (bloanYN == "Y") bloanYNFlag = "ORDER";

            var param = {
                GdsFinCtgrCode: gdsFinCtgrCodeArr, GdsGrpCode: gdsGrpCodeArr, GdsCode: gdsCodeArr, Svid_User: '<%=Svid_User %>'
                , OrderBelong_Code: orderBelong_Code, OrderArea_Code: orderArea_Code, OrderSaleComp_Code: orderSaleComp_Code
                , Qty: qtyArr, Payway: payway, GdsSalePriceVat: gdsSalePriceArr, OrderStat: orderStat
                , DlvrCost: dlvrCost, PowerdlvrCost: powerDlvrCost, Zipcode: postNo, Address_1: addr1, Address_2: addr2, DlvrReqInfo: dlvrReqInfo
                , DlvrDueType: dlvrDueTypeResult, OrdTryUnum: ordTryUnumArr, GdsDeliType: gdsDeliTypeArr
                , SaleCompNo: selectSaleCompNo, SaleCompCode: selectSaleCompVal, MyCompCode: myCompCode
                , BLoanYN: bloanYN, BLoanYNFlag: bloanYNFlag, DlvrUserNm: dlvrUserNm, DlvrUserTelNo: dlvrUserTelNo, Method: "SaveOrder"
            };

            var goodsCnt = $("#tbodyOrderList tr").find("input:hidden[name^='hdGdsCode']").length; // 상품개수

            var SaleComName = "";

            if ($("#trSelectSaleComp").css("display") == "none") {
                SaleComName = $('#spanSaleCompany').text();

            } else {
                SaleComName = $("#selectSaleCompany option:selected").text();
            }

            var returnloanFlag = '';
            var returnOrdCodeNo = '';

            var callback = function (response) {
                if (!isEmpty(response)) {

                    var orderCodeNo = response.Result; //생성된 주문번호

                    //여신결제(일반) 결제방식에서 고정계좌번호 값이 없는 경우
                    if (orderCodeNo == "NotBankNo") {
                        alert("확정 가상계좌 발급 문제가 있습니다.\n관리자에게 문의해 주시기 바랍니다.\n(담당자 임수찬 : 070-5226-1105)");
                        return false;

                    } else if (orderCodeNo != "") {

                        //여신 사용 시
                        if ((!isEmpty(response.LoanFlag)) && (response.LoanFlag == "LOAN")) {

                            returnloanFlag = response.LoanFlag;
                            returnOrdCodeNo = orderCodeNo;

                        } else {
                            // 팝업 안 보이게 처리
                            var e = document.getElementById("ordDlvrConfirmDiv");
                            e.style.display = "none";


                            var payway = $("#hdPayway").val();
                            

                            //무통장입금
                            if (payway == "10") {

                                fnPopupNoPassbook(orderCodeNo, SaleComName);

                            } else { //그 외 결제방식
                                // 결제 팝업
                                var url = "PayRequest";
                                //var url = "OrderRequest";
                                var targetName = "OrdReqPopup";

                                //var roleFlag = "TYPE_1";

                                var addForm = "<form name='ordPayForm' method='POST' action='" + url + "' target='" + targetName + "'>"
                                    //+ "<input type='hidden' name='goodsCnt' value='" + goodsCnt + "' />"
                                    + "<input type='hidden' name='ordCdNo' value='" + orderCodeNo + "' />"
                                    + "<input type='hidden' name='saleComName' value='" + SaleComName + "' />"
                                    //+ "<input type='hidden' name='RoleFlag' value='" + roleFlag + "' />"
                                    + "</form>";

                                $("body").append(addForm);


                                var popupForm = $("form[name='ordPayForm']");

                                //var width = 820;
                                //var height = 630;
                                //var popupX = (window.screen.width / 2) - (width / 2);
                                //var popupY = (window.screen.height / 2) - (height / 2);

                                //url, target, width, height, status, toolbar,  menubar, location, resizable, scrollbar
                                //fnWindowOpen('', targetName, 820, 630, 'yes', 'no', 'no', 'no', 'no', 'no');

                                fnWindowOpen('', targetName, 820, 630, 'yes', 'no', 'no', 'no', 'no', 'no');

                                popupForm.submit();
                            }
                            
                        }

                    } else {
                        // 팝업 안 보이게 처리
                        var e = document.getElementById("ordDlvrConfirmDiv");
                        e.style.display = "none";

                        alert("오류가 발생했습니다. 잠시후 다시 시도해 주세요.");
                        return false;
                    }
                }
                return false;
            }

            var beforeSend = function () {
                is_sending = true;
            }
            var complete = function () {
                is_sending = false;

                if ((!isEmpty(returnloanFlag)) && (returnloanFlag == "LOAN")) {

                    fnBLoanOrderPay(returnOrdCodeNo); //PO별 묶음 결제 주문 저장
                }
            }
            if (is_sending) return false;

            JqueryAjax('Post', '../Handler/OrderHandler.ashx', true, false, param, 'json', callback, beforeSend, complete, true, '<%=Svid_User%>');
        }

        // 주문내용확인 버튼 클릭 시
        function fnOrderConfirm() {
            var hdPayAmt = $("#hd_pay_Amt").val();
            var payway = $(":radio[name='pay']:checked").val();
         
            if ((parseInt(hdPayAmt) >= 2000000) && (payway == '2') )
            {
                alert('고객님이 주문하신 상품금액이 이체한도 200만원을 넘었습니다. \n실시간 이체한도는 200만원입니다.')
                return false;
            }


            if (fnCheckForm()) { // 유효성 검사

                var gdsTotPriceVat = fnGetTotalPrice(); // 주문 합계 금액

                // 여신 관련
                var hfRemainPrice = $('#<%= hfRemainPrice.ClientID %>').val();
                var remainPrice = 0;

                if (!isEmpty(hfRemainPrice) && (hfRemainPrice != "null")) {
                    remainPrice = Number(hfRemainPrice);

                    if (gdsTotPriceVat > remainPrice) {
                        alert("주문합계금액이 여신한도금액을 초과하였습니다.");
                        return false;
                    }
                }

                var dlvrDuePackage = false; // 합배송 정보 저장
                var dlvrDueName = "";
                var firstVal = "";
                var compareDlvrDue = 0; //비교할 배송기간

                var oneDayVal = false;

                $("#tbodyOrderList tr").each(function (idx) {

                    var tmpDlvrDue = $(this).find("input:hidden[name^='hdDlvrDue']").val();

                    if (idx == 0) {
                        firstVal = tmpDlvrDue;
                        compareDlvrDue = tmpDlvrDue;
                        dlvrDueName = $(this).find("input:hidden[name^='hdDlvrDueName']").val();
                    }

                    if (tmpDlvrDue == '1') oneDayVal = true;

                    if (Number(compareDlvrDue) != Number(tmpDlvrDue)) {
                        if (oneDayVal) dlvrDuePackage = true;
                    }

                    if (Number(compareDlvrDue) < Number(tmpDlvrDue)) {
                        compareDlvrDue = tmpDlvrDue;
                        dlvrDueName = $(this).find("input:hidden[name^='hdDlvrDueName']").val();
                    }
                });

                var goodsCnt = $("#tbodyOrderList tr").find("input:hidden[name^='hdGdsCode']").length;

                if (goodsCnt == 1) dlvrDuePackage = false;
                
                //임시로 주석처리......
                //if (dlvrDuePackage) {
                //    $("#td_popup_dlvr").text("주문하신 상품이 최대 " + dlvrDueName + " 소요됩니다.\n분할배송 하시겠습니까?");

                //    fnDialogConfirm(); // 분할배송 여부 선택 팝업 띄움.

                //} else {
                    fnOrderDlvrPopupConfirm(false); // 결제팝업이 바로 실행.
                //}
            }
        }

        // 주문하기 화면에서 취소 버튼 클릭 시
        function fnOrderTryCancel() {
            window.location.href = "../Cart/CartList.aspx";
        }

        //수량 업데이트
        function fnChangeGoodsNum(el) {

            var qty = $(el).parent().find("input[name*='txtGoodsNum']").val();
            var ordtryNo = $(el).parent().parent().find("input[name='hdUodrTryNo']").val();
            var goodsUnitMoq = $(el).parent().parent().find("input[name='hdGoodsUnitMoq']").val();

            if (parseInt(qty) < parseInt(goodsUnitMoq)) {
                alert('주문수량이 최소수량보다 작습니다.');
                return false;
            }
            var callback = function (response) {

                if (response == 'Success') {
                    alert('수량이 수정되었습니다.');
                } else {
                    alert('시스템 오류가 발생했습니다. 관리자에게 문의하시기 바랍니다.');
                }

                return false;
            }

            var compcode = '';
            var saleCompcode = '';

            if (!isEmpty('<%= UserInfoObject.UserInfo.PriceCompCode%>')) {
                compcode = '<%= UserInfoObject.UserInfo.PriceCompCode%>'
            }
            else {
                compcode = 'EMPTY'
            }

            if (!isEmpty('<%= UserInfoObject.UserInfo.SaleCompCode%>')) {
                saleCompcode = '<%= UserInfoObject.UserInfo.SaleCompCode%>'
            }
            else {
                saleCompcode = 'EMPTY'
            }
            var param = {
                Method: 'UpdateOrderTryQty',
                OrderTryNo: ordtryNo,
                Qty: qty,
                CompCode: compcode,
                SaleCompCode: saleCompcode,
                DongshinCheck: '<%= UserInfoObject.UserInfo.BmroCheck%>',
                FreeCompanyYN: '<%= UserInfoObject.UserInfo.FreeCompanyYN.AsText("N")%>',
                SvidUser: '<%= Svid_User%>'
            };

            var beforeSend = function () {
                is_sending = true;
            }
            var complete = function () {
                is_sending = false;
                window.location.reload(true);
            }
            if (is_sending) return false;

            JqueryAjax('Post', '../Handler/OrderHandler.ashx', true, false, param, 'text', callback, beforeSend, complete, true, '<%=Svid_User%>');
        }

        function fnAddDelivery() {

            if ($('#txtPostalCode').val() == '' || $('#txtAddress1').val() == '') {
                alert('우편번호와 주소를 검색해 주세요.');
                $('#txtPostalCode').focus();
                return false;
            }
            
            var callback = function (response) {

                if (response == 'Success') {
                    alert('추가되었습니다.');
                    $('#txtPostalCode').val('');
                    $('#txtAddress1').val('');
                    $('#txtAddress2').val('');
                    fnDeliveryListBind();

                }
                else {
                    alert('시스템 오류가 발생했습니다. 관리자에게 문의하시기 바랍니다.');
                }

                return false;
            }

            var param = {
                Method: 'SaveDelivery',
                SvidUser: '<%= Svid_User%>',
                UserName: '<%= UserInfoObject.Name%>',
                CompNo: '<%= UserInfoObject.UserInfo.Company_No%>',
                CompCode: '<%= UserInfoObject.UserInfo.Company_Code%>',
                AreaCode: '<%= UserInfoObject.UserInfo.CompanyArea_Code%>',
                BDeptCode: '<%= UserInfoObject.UserInfo.CompBusinessDept_Code%>',
                DeptCode: '<%= UserInfoObject.UserInfo.CompanyDept_Code%>',
                Portal: $('#txtPostalCode').val(),
                Addr1: $('#txtAddress1').val(),
                Addr2: $('#txtAddress2').val()
            };

            var beforeSend = function () {
                is_sending = true;
            };
            var complete = function () {
                is_sending = false;
            };
            if (is_sending) return false;

            JqueryAjax('Post', '../../Handler/Common/DeliveryHandler.ashx', true, false, param, 'text', callback, beforeSend, complete, true, '<%=Svid_User%>');
        }

        //무통장입금
        function fnPopupNoPassbook(orderCodeNo, saleComName) {
            // 결제 팝업
            var url = "OrderNoPassbookRequest";
            var targetName = "OrdReqPopupNoBook";

            var roleFlag = "TYPE_1";

            var addForm = "<form name='ordPayNoBookForm' method='POST' action='" + url + "' target='" + targetName + "'>"
                + "<input type='hidden' name='orderNo' value='" + orderCodeNo + "' />"
                + "<input type='hidden' name='SaleComName' value='" + saleComName + "' />"
                + "<input type='hidden' name='RoleFlag' value='" + roleFlag + "' />"
                + "</form>";

            $("body").append(addForm);


            var popupForm = $("form[name='ordPayNoBookForm']");

            //var width = 820;
            //var height = 630;
            //var popupX = (window.screen.width / 2) - (width / 2);
            //var popupY = (window.screen.height / 2) - (height / 2);

            //url, target, width, height, status, toolbar,  menubar, location, resizable, scrollbar
            fnWindowOpen('', targetName, 640, 600, 'yes', 'no', 'no', 'no', 'no', 'no');

            // window.open("", targetName, "height=" + height + ", width=" + width + ",status=yes,toolbar=no,menubar=no,location=no,scrollbars=no,resizable=no, left=" + popupX + ", top=" + popupY + ", screenX=" + popupX + ", screenY= " + popupY + ";");

            popupForm.submit();
        }
    </script>
    <script>
        //우편번호 팝업
        function openPostcode() {
            var width = 500; //팝업의 너비
            var height = 500; //팝업의 높이
            new daum.Postcode({
                width: width,
                height: height,
                oncomplete: function (data) {
                    // 팝업에서 검색결과 항목을 클릭했을때 실행할 코드를 작성하는 부분.

                    // 각 주소의 노출 규칙에 따라 주소를 조합한다.
                    // 내려오는 변수가 값이 없는 경우엔 공백('')값을 가지므로, 이를 참고하여 분기 한다.
                    var fullAddr = ''; // 최종 주소 변수
                    var extraAddr = ''; // 조합형 주소 변수

                    // 사용자가 선택한 주소 타입에 따라 해당 주소 값을 가져온다.
                    if (data.userSelectedType === 'R') { // 사용자가 도로명 주소를 선택했을 경우
                        fullAddr = data.roadAddress;

                    } else { // 사용자가 지번 주소를 선택했을 경우(J)
                        fullAddr = data.jibunAddress;
                    }

                    // 사용자가 선택한 주소가 도로명 타입일때 조합한다.
                    if (data.userSelectedType === 'R') {
                        //법정동명이 있을 경우 추가한다.
                        if (data.bname !== '') {
                            extraAddr += data.bname;
                        }
                        // 건물명이 있을 경우 추가한다.
                        if (data.buildingName !== '') {
                            extraAddr += (extraAddr !== '' ? ', ' + data.buildingName : data.buildingName);
                        }
                        // 조합형주소의 유무에 따라 양쪽에 괄호를 추가하여 최종 주소를 만든다.
                        fullAddr += (extraAddr !== '' ? ' (' + extraAddr + ')' : '');
                    }

                    // 우편번호와 주소 정보를 해당 필드에 넣는다.
                    $("#txtPostalCode").val(data.zonecode);
                    $("#hfPostalCode").val(data.zonecode);
                    $("#txtAddress1").val(fullAddr);
                    $("#hfAddress1").val(fullAddr);


                    //// 커서를 상세주소 필드로 이동한다.
                    $("#txtAddress2").focus();
                }
            }).open({
                left: (window.screen.width / 2) - (width / 2),
                top: (window.screen.height / 2) - (height / 2)
            }
            );
        }

        function fnGoodsCompareReportPopup() {
            var svidUser = '<%= Svid_User%>';
            var saleCompCode = $('#hdSaleCompCode').val();
            var url = '../../Print/GoodsPriceCompareReport.aspx?SvidUser=' + svidUser + '&Dcheck=' + '<%= UserInfoObject.UserInfo.BmroCheck%>' + '&FreeCompFlag=' + '<%= UserInfoObject.UserInfo.FreeCompanyYN%>'+ '&SaleCompCode=' + saleCompCode;

            //url, target, width, height, status, toolbar,  menubar, location, resizable, scrollbar
            fnWindowOpen(url, '', 1000, 600, 'yes', 'no', 'no', 'no', 'yes', 'yes');
            return false;
            //window.open(url, '', "height=600, width=1000,status=yes,toolbar=no,menubar=no,location=no,resizable=no");
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div class="sub-contents-div">

        <div class="sub-title-div">
            <img src="/images/OrderList_nam.png" />
        </div>

        <!--주문상품 div 시작-->

        <div class="mini-title" style="margin-bottom: 0;">
            <p><img src="/images/text_star_red.png" /><span  class="member_sub">주문상품</span></p>
        </div>
        <span style="float: right; margin-bottom: 10px;">
            <span style="color: #ec2029; font-weight: bold;">* 50,000원(VAT포함) 이상</span>  구매 시 무료배송
        </span>
        <div class="order1-div">

            <asp:HiddenField runat="server" ID="hfRemainPrice" />

            <table class="tbl_main" id="tblOrderGoods">
                <thead>
                    <tr style="height: 40px;">
                        <th class="txt-center">번호</th>
                        <th class="txt-center">이미지</th>
                        <th class="txt-center">상품코드</th>
                        <th class="txt-center">상품정보</th>
                        <th class="txt-center">모델명</th>
                        <th class="txt-center">출하예정일</th>
                        <th class="txt-center">최소수량</th>
                        <th class="txt-center">내용량</th>
                        <th class="txt-center">상품가격</th>
                        <th class="txt-center">수량</th>
                        <th class="txt-center">합계금액</th>

                        <th class="txt-center">삭제</th>
                    </tr>
                </thead>
                <tbody id="tbodyOrderList">
                    <asp:Repeater ID="rptOrder" runat="server" OnItemDataBound="rptOrder_ItemDataBound">
                        <ItemTemplate>
                            <tr>
                                <td style="height: 40px;">
                                    <%# Container.ItemIndex + 1 %>

                                    <input type="hidden" name="hdUodrTryNo" value='<%# Eval("Unum_OrderTryNo").AsText() %>' />
                                    <input type="hidden" name="hdUnumCartNo" value='<%# Eval("Unum_CartNo").AsText() %>' />
                                    <input type="hidden" name="hdDlvrCostGubun" value='<%# Eval("DeliveryCostGubun").AsText() %>' />
                                    <input type="hidden" name="hdDlvrCostCode" value='<%# Eval("DeliveryCost_Code").AsText() %>' />
                                    <input type="hidden" name="hdDefDlvrCost" value='<%# Eval("Default_DeliveryCost").AsText() %>' />
                                    <input type="hidden" name="hdPowerDlvrCost" value='<%# Eval("Power_DeliveryCost").AsText() %>' />
                                    <input type="hidden" name="hdGdsFinCtgrCode" value='<%# Eval("GoodsFinalCategoryCode").AsText() %>' />
                                    <input type="hidden" name="hdGdsGrpCode" value='<%# Eval("GoodsGroupCode").AsText() %>' />
                                    <input type="hidden" name="hdGdsCode" value='<%# Eval("GoodsCode").AsText() %>' />
                                    <input type="hidden" name="hdGdsName" value='<%# Eval("GoodsFinalName").AsText() %>' />
                                    <input type="hidden" name="hdQty" value='<%# Eval("QTY").AsText() %>' />
                                    <input type="hidden" name="hdGdsTotSalePriceVAT" value='<%# Eval("GoodsTotalSalePriceVAT").AsText() %>' />
                                    <input type="hidden" name="hdDlvrGubun" value='<%# Eval("DeliveryGubun").AsText() %>' />
                                    <input type="hidden" name="hdDlvrDue" value='<%# Eval("GoodsDeliveryOrderDue").AsText() %>' />
                                    <input type="hidden" name="hdDlvrDueName" value='<%# Eval("GoodsDeliveryOrderDue_Name").AsText() %>' />
                                    <input type="hidden" name="hdGoodsUnitMoq" value='<%# Eval("GoodsUnitMoq").AsText() %>' />
                                    <%--<asp:HiddenField ID="hfGdsTax" runat="server" Value='<%# Eval("GoodsSaleTaxYN").ToString() %>' />--%>
                                    <asp:HiddenField ID="hfGdsTax" runat="server" Value='<%# Eval("GoodsSaleTaxYN").AsText() %>' />
                                    <input type="hidden" id="hfCompanyGoodsYN" value='<%# Eval("CompanyGoodsYN").AsText() %>' />
                                    <input type="hidden" id="hfGoodsDisplayReason" value='<%# Eval("GoodsDisplayReason").AsText() %>' />
                                    <input type="hidden" name="hdGdsSalePriceVAT" value='<%# Eval("GoodsSalePriceVAT").AsText() %>' />
                                    <input type="hidden" name="hdMemo" value='<%# Eval("Memo").AsText() %>' />

                                </td>
                                <td>
                                    <asp:HyperLink ID="hlImg" runat="server" NavigateUrl='<%# String.Format("../Goods/GoodsDetail?GoodsModel=&GoodsCode={0}&CategoryCode={1}&BrandName=&GoodsName=&Type=ds", Eval("GoodsCode").ToString(),Eval("GoodsFinalCategoryCode").ToString()) %>'>
                                        <asp:Image runat="server" ID="imgGoods" Width="50" Height="50" ImageUrl='<%# String.Format("/GoodsImage/{0}/{1}/{2}/{3}", Eval("GoodsFinalCategoryCode") , Eval("GoodsGroupCode"), Eval("GoodsCode"), Eval("GoodsFinalCategoryCode").ToString() + "-" + Eval("GoodsGroupCode") + "-" + Eval("GoodsCode") + "-" + "sss.jpg")%>' onerror="this.onload = null; this.src='/Images/noImage_s.jpg';" />
                                    </asp:HyperLink></td>
                                <td>
                                    <%# Eval("GoodsCode").ToString() %><br />
                                    <asp:Label runat="server" ID="lblGoodsDiplayText" Text='<%# SetGoodsDisplayText(Eval("CompanyGoodsYN").AsText(),Eval("GoodsDisplayReason").AsText()) %>' Font-Bold="true" ForeColor="Red"></asp:Label>
                                </td>
                                <td style="text-align: left">
                                    <span id="spanDlvrGbnNm"></span>
                                    [<%# Eval("BrandName").ToString() %>]<%# Eval("GoodsFinalName").ToString() %><br />[<%# Eval("GoodsOptionSummaryValues").ToString() %>]
                                    <asp:Label runat="server" ID="lblTax" Visible="false"><br />(면세)</asp:Label>
                                </td>
                                <td><%# Eval("GoodsModel").ToString() %></td>

                                <td id="tdDlvrDue"><%# Eval("GoodsDeliveryOrderDue_Name").ToString() %></td>
                                <td id="tdMoq"><%# Eval("GoodsUnitMoq").ToString() %></td>
                                <td id="tdUnit"><%# Eval("GoodsUnit_Name").ToString() %></td>
                                <td id="tdPrice" style="padding-right: 5px; text-align: right;"><%# String.Format("{0:##,##0;}", Eval("GoodsSalePriceVAT").AsDecimal()) %>원</td>
                                <td id="tdQty" style="width: 84px;">
                                    <span class='input-qty' style="width: 72px; padding-left: 6px; margin-bottom: 4px; background-color: #ffffff">
                                        <asp:TextBox ID="txtGoodsNum" runat="server" flag="qty" Width="56px" MaxLength='4' Onkeypress="return onlyNumbers(event);" value='<%# Eval("Qty").ToString() %>'></asp:TextBox>
                                        <a class='input-arrow-up'>
                                            <img src='../Images/inputarrow_up.png' width='9' height='9' class='imgarrowup' /></a>
                                        <a class='input-arrow-down'>
                                            <img src='../Images/inputarrow_down.png' width='9' height='9' class='imgarrowdown' /></a>
                                    </span>
                                    <input type="button" class="listBtn2" value="수량변경" style="width: 72px; height: 22px; font-size: 12px; margin: 0; padding: 0;" onclick="return fnChangeGoodsNum(this);" />

                                </td>
                                <td id="tdTotSalePrice" style="padding-right: 5px; text-align: right;"><%# String.Format("{0:##,##0;}", Eval("GoodsTotalSalePriceVAT").AsDecimal()) %>원</td>
                                <td style="width: 85px;">
                                    <input type="button" class="listBtn" value="삭 제" style="width: 65px; height: 26px; font-size: 12px" onclick="return fnOrderDelete(this);" />
                                </td>
                            </tr>
                        </ItemTemplate>
                        <FooterTemplate>
                            <tr id="trEmpty" runat="server" visible="false">
                                <td colspan="14">리스트가 없습니다.</td>
                            </tr>
                        </FooterTemplate>
                    </asp:Repeater>
                </tbody>
            </table>

            <div class="price">
                주문 합계금액:&nbsp;<label id="lbTotalPrice"></label>원<br />
                (기본+특수 배송비:&nbsp;<label id="lbTotalDlvrPrice"></label>원)<br />
                총 주문 합계금액:&nbsp;<label id="lbTotalPayPrice"></label>원
            </div>

        </div>





        <!--주문자정보 div 시작 -->
        <div class="mini-title">
            <p><img src="/images/text_star_red.png" /><span  class="member_sub">주문자정보</span></p>
        </div>
        <div class="order2-div">
            <table class="tbl_main" id="tblOrderInfo" style="width:100%">
                <tr>
                    <th style="height: 30px; width: 170px">기관명</th>
                    <td id="tdCompanyName" style="height: 30px; width: 150px"></td>
                    <th style="height: 30px; width: 170px">부서명</th>
                    <td id="tdCompanyDeptName" style="height: 30px; width: 150px"></td>
                    <th style="height: 30px; width: 170px">
                        <input type="hidden" id="hdBLoanYN" />담당자</th>
                    <td id="tdName" style="height: 30px; width: 250px"></td>
                </tr>

                <tr>
                    <th style="height: 30px; width: 170px">연락처</th>
                    <td id="tdTelNo" style="height: 30px;"></td>
                    <th style="height: 30px; width: 170px">E-mail</th>
                    <td id="tdEmail"></td>
                    <th style="height: 30px; width: 170px">주&nbsp;소</th>
                    <td id="tdAddress"></td>
                </tr>
            </table>
        </div>



        <!--배송지 div 시작 -->
        <div class="mini-title">
            <p><img src="/images/text_star_red.png" /><span  class="member_sub">배송지</span></p>
        </div>
        <div class="order3-div">
            <table class="tbl_main" id="tblDestination" style="width:100%">
                <colgroup>
                    <col style="width: 200px;" />
                    <col style="width: 400px" />
                    <col style="width: 210px" />
                    <col style="width: 400px" />
                </colgroup>
                <tr>
                    <th style="width: 200px; height: 30px;">기관명</th>
                    <td id="tdCompanyName2"></td>
                    <th>부서명</th>
                    <td id="tdCompanyDeptName2"></td>
                </tr>
                <tr>
                    <th style="width: 200px; height: 30px;">받는사람명</th>
                    <td id="tdName2" class="align-left">
                        <input type="text" id="txtDlvrUserNm" maxlength="20" onkeypress="return preventEnter(event);" style="width: 90%; height: 25px; border: 1px solid #a2a2a2; padding-left: 5px;" /></td>
                    <th>받는사람 연락처</th>
                    <td id="tdTelNo2" class="align-left">
                        <input type="text" id="txtDlvrTelNo" maxlength="16" onkeypress="return onlyNumbers(event);" style="width: 200px; height: 25px; border: 1px solid #a2a2a2; padding-left: 5px;" placeholder="-없이 입력해 주세요" />
                        <span style="padding-left: 5px;">'-' 없이 입력해 주세요.</span>
                    </td>
                </tr>
                <tr>
                    <th style="width: 200px; height: 30px;">주소</th>
                    <td colspan="3" class="align-left">
                        <asp:TextBox ID="txtPostNo" runat="server" CssClass="addr-textbox1" OnkeyPress="return preventEnter(event);" ReadOnly="true"></asp:TextBox>
                        <asp:TextBox ID="txtAddr1" runat="server" CssClass="addr-textbox" OnkeyPress="return preventEnter(event);" ReadOnly="true"></asp:TextBox>
                        <asp:TextBox ID="txtAddr2" runat="server" CssClass="addr-textbox" OnkeyPress="return preventEnter(event);" ReadOnly="true"></asp:TextBox>
                        <input type="button" class="mainbtn type1" style="width: 88px; height: 28px; font-size: 12px" onclick="fnDeliverySearchPopup(); return false;" value="배송지 선택"/>
                    </td>
                </tr>
                <tr>
                    <th>배송시요구사항<br />
                        (50자 이하)</th>
                    <td colspan="3" style="height: 100px;">
                        <textarea id="txtPs" rows="4" maxlength="50" style="width: 100%; height: 100%; border: 1px solid #a2a2a2"></textarea>
                    </td>
                </tr>
            </table>
        </div>



        <!--판매업체 선택 div 시작 -->
        <div class="mini-title">
            <p><img src="/images/text_star_red.png" /><span  class="member_sub">판매업체 선택</span></p>
        </div>
        <div class="order4-div">
            <table class="tbl_main" style="width:100%">
                <colgroup>
                    <col style="width: 203px" />
                    <col style="width: 203px" />
                    <col style="width: 203px" />
                    <col style="width: 203px" />
                    <col style="width: 203px" />
                    <col style="width: 203px" />
                </colgroup>
                <tr>
                    <th colspan="6" style="height: 30px;">결제승인</th>
                </tr>
                <tr id="trSelectSaleComp" style="display: none">
                    <th style="height: 30px;">소속선택</th>
                    <td>
                        <select id="selectBelong" onchange="fnOrderAreaListBind(this.value);" style="width: 98%; height: 28px">
                            <option value="">---선택---</option>
                        </select>
                    </td>
                    <th>지역선택</th>
                    <td>
                        <select id="selectArea" onchange="fnOrderSaleCompListBind(this.value);" style="width: 98%; height:28px">
                            <option value="">---선택---</option>
                        </select>
                    </td>
                    <th>업체선택</th>
                    <td>
                        <select id="selectSaleCompany" style="width: 98%; height: 28px" onchange="fnSetSelectResult();">
                            <option value="">---선택---</option>
                        </select>
                    </td>
                </tr>
                <tr id="trSelectResult" style="display: none">
                    <td colspan="6" style="text-align: center; height: 30px;"><span id="selectResult"></span></td>
                </tr>
                <tr id="trSetSaleComp" style="display: none">
                    <th style="height: 30px;">소속</th>
                    <td style="text-align: center">
                        <span id="spanBelong"></span>
                        <input type="hidden" id="hdBelongCode" />
                    </td>
                    <th>지역</th>
                    <td style="text-align: center">
                        <span id="spanArea"></span>
                        <input type="hidden" id="hdAreaCode" />
                    </td>
                    <th>업체</th>
                    <td style="text-align: center">
                        <span id="spanSaleCompany"></span>
                        <input type="hidden" id="hdSaleCompCode" />
                        <input type="hidden" id="hdSaleCompNo" />
                    </td>
                </tr>
            </table>
        </div>

        <br />
        <br />


        <!--결제진행 div 시작 -->
        <div class="mini-title">
            <p><img src="/images/text_star_red.png" /><span  class="member_sub">결제진행</span></p>
        </div>
        <div class="order5-div">

            <input type="hidden" name="hdUnumCartNoArr" id="hdUnumCartNoArr" value="" />
            <input type="hidden" name="hdBasicDlvrCost" id="hdBasicDlvrCost" value="" />
            <input type="hidden" name="hdAddDlvrCost" id="hdAddDlvrCost" value="" />
            <input type="hidden" name="hdPayway" id="hdPayway" value="" />
            <input type="hidden" name="hdGdsSalePriceVat" id="hdGdsSalePriceVat" value="" />

            <input type="hidden" name="hd_pay_GoodsCnt" id="hd_pay_GoodsCnt" value="" />
            <input type="hidden" name="hd_pay_GoodsName" id="hd_pay_GoodsName" value="" />
            <input type="hidden" name="hd_pay_Amt" id="hd_pay_Amt" value="" />
            <input type="hidden" name="hd_pay_BuyerName" id="hd_pay_BuyerName" value="" />
            <input type="hidden" name="hd_pay_BuyerTel" id="hd_pay_BuyerTel" value="" />
            <input type="hidden" name="hd_pay_Company" id="hd_pay_Company" value="" />
            <input type="hidden" name="hd_pay_CompDept" id="hd_pay_CompDept" value="" />
            <input type="hidden" name="hd_pay_Email" id="hd_pay_Email" value="" />
            <input type="hidden" name="hd_pay_DlvrPostNo" id="hd_pay_DlvrPostNo" value="" />
            <input type="hidden" name="hd_pay_DlvrAddr" id="hd_pay_DlvrAddr" value="" />
            <input type="hidden" id="hdBPayType" />

            <table class="tbl_main"  style="width:100%">
                <colgroup>
                    <col style="width: 183px" />
                    <col style="width: 426px" />
                    <col style="width: 203px" />
                    <col style="width: 306px" />
                </colgroup>

                <tr>
                    <th style="height: 30px;">결제방식 선택</th>
                    <td id="tdPayway" style="vertical-align: middle">&nbsp;&nbsp;</td>
                    <th colspan="2">결제금액</th>
                </tr>
                <tr>
                    <td colspan="2" rowspan="5">
                        <span style="font-size: 14px; display: block; text-align: center">' <b style="font-size: 20px; color: #804000">#</b> ' 는 <b style="font-size: 14px; color: #ec2028">세금계산서가 발행</b>되는 결제방식입니다.</span><br />
                        <span style="font-size: 14px; display: block; text-align: center">*<b style="font-size: 14px;">선불결제</b>의 경우 <b style="font-size: 14px; color: #ec2028">결제가 완료</b>되어야 <b style="font-size: 14px;">주문접수 및 배송진행</b>이 가능합니다.<br />
                        </span>&nbsp;
                        <span style="font-size: 14px; display: block; text-align: center"><b style="font-size: 14px; color: #ec2028">*[팝업 차단을 해제] </b>하셔야 결제창 확인이 가능합니다. (FAQ 기타문의 참고)</span>
                        <span style="font-size: 14px; display: block; text-align: center"><b style="font-size: 14px; color: black">(주문별 실시간 이체한도는 200만원입니다.)</span>
                    </td>
                    <th style="height: 30px;">상품금액</th>
                    <td><span id="sumPrice"></span>원</td>
                </tr>
                <tr>
                    <th style="height: 30px;">할인금액</th>
                    <td></td>
                </tr>
                <tr>
                    <th style="height: 30px;">배송금액</th>
                    <td>
                        <span id="spanDlvrPrice"></span>
                        <input type="hidden" id="hdDlvrPrice" value="" />
                        <input type="hidden" id="hdAddDlvrPrice" value="" />
                    </td>
                </tr>
                <tr>
                    <th style="height: 30px;">총 결제 금액</th>
                    <td style="color: red"><span id="spanTotalPayPrice"></span>원</td>
                </tr>
                <tr>
                    <th style="height: 30px;">사회적기업</th>
                    <td><span id="selectCompanyName"></span></td>
                </tr>
            </table>
        </div>

        <div class="bottom-btn">
            <input type="button" id="btnPrintReport" class="mainbtn type1" style="width:95px; height:30px; font-size:12px; display:none" value="견적서출력" onclick="return fnGoodsCompareReportPopup();"/>
            <input type="button" class="mainbtn type1" style="width: 75px; height: 30px; font-size: 12px" value="취소" onclick="return fnOrderTryCancel();" />
            <input type="button" class="mainbtn type1" style="width: 105px; height: 30px; font-size: 12px" value="주문내용확인" onclick="return fnOrderConfirm();" />
        </div>
    </div>
    <%-- DIV 팝업창 배송지검색 시작 --%>
    <div class="popupdiv divpopup-layer-package" id="destinationDiv">
        <div class="popupdivWrapper" style="width:70%; height: 650px">
            <div class="popupdivContents">
               <h3>배송지 검색</h3>
                <div style="width: 100%; height: 250px; overflow-y: auto; overflow-x: hidden">
                    <table id="tblDeliveryList" class="tbl_popup">
                        <thead>
                            <tr>
                                <th style="width: 30px" class="txt-center">선택</th>
                                <th style="width: 30px" class="txt-center">구분</th>
                                <th style="width: 80px" class="txt-center">기본배송지</th>
                                <th style="width: 80px" id="thArea" class="txt-center">사업장</th>
                                <th style="width: 80px" id="thBusiness" class="txt-center">사업부</th>
                                <th style="width: 80px" class="txt-center">부서명</th>
                                <th style="width: 80px" class="txt-center">담당자</th>
                                <th style="width: 90px" class="txt-center">우편번호</th>
                                <th style="width: 300px" class="txt-center">주소</th>
                                <th style="width: 300px" class="txt-center">상세주소</th>
                            </tr>
                        </thead>
                        <tbody></tbody>
                    </table>
                    <input type="hidden" id="hdDeliveryNo" />
                </div>
                <div class="bottom-btn" style="padding-right: 5px;">

                    <input type="button" class="mainbtn type1" style="width: 75px; height: 30px; font-size: 12px" value="취소" onclick="fnCancel();" />
                    <input type="button" class="mainbtn type1" style="width: 75px; height: 30px; font-size: 12px" value="확인" onclick="fnSelectDelivery();" />
                    
                </div>
                <br />
                <h3>배송지 추가</h3>
                <table class="tbl_popup">
                    <colgroup>
                        <col style="width: 300px;" />
                        <col style="width: 350px;" />
                        <col style="width: auto" />
                        <col style="width: 100px" />
                    </colgroup>
                    <tr>
                        <th class="txt-center">우편번호</th>
                        <th class="txt-center">주소</th>
                        <th class="txt-center">상세주소</th>
                        <th class="txt-center">추가</th>
                    </tr>
                    <tr>
                        <td class="txt-center">
                            <input type="text" id="txtPostalCode" readonly="readonly" style="width: 50%; border: 1px solid #a2a2a2; position: relative;" />
                            <input type="button" class="subBtn" style="width: 95px; height: 25px; font-size: 12px" value="우편번호검색" onclick="openPostcode()" />
                        </td>
                        <td class="txt-center">
                            <input type="text" id="txtAddress1" readonly="readonly" style="width: 90%; border: 1px solid #a2a2a2; position: relative;" />
                        </td>
                        <td class="txt-center">
                            <input type="text" id="txtAddress2" style="width: 90%; border: 1px solid #a2a2a2; position: relative;" />
                        </td>
                        <td class="txt-center">
                            <input type="button" class="subBtn" style="width: 55px; height: 25px; font-size: 12px" value="추가" onclick="return fnAddDelivery();" />
                        </td>
                    </tr>
                </table>
            </div>
        </div>
        <%-- DIV 팝업창 끝 --%>
    </div>




    <%-- DIV 팝업창 분할배송 선택 시작 --%>
    <div class="popupdiv divpopup-layer-package" id="ordDlvrConfirmDiv">
        <div class="popupdivWrapper" style="width: 400px; ">
            <div class="popupdivContents">
                    <h3>분할배송선택</h3>
                    <div class="divpopup-layer-conts">
                        <table id="tblDlvrConfirm" style="width: 100%">
                            <tbody>
                                <tr>
                                    <td id="td_popup_dlvr"></td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                    <div class="yesPop-align">
                        <a onclick="fnOrderDlvrPopupConfirm(true)">
                            <img src="../Images/Order/yes-on.jpg" alt="예" /></a>
                        <a onclick="fnOrderDlvrPopupConfirm(false)">
                            <img src="../Images/Order/no-off.jpg" alt="아니오" /></a>
                    </div>
            </div>
        </div>
    </div>
    <%-- DIV 팝업창 분할배송 선택 끝 --%>



    <script type="text/javascript">
        $(function () {
            $(".onOff-btn").on("mouseover focus", function () {
                $("img", this).attr("src", $("img", this).attr("src").replace("off.jpg", "on.jpg"));
            });
            $(".onOff-btn").on("mouseleave", function () {
                $("img", this).attr("src", $("img", this).attr("src").replace("on.jpg", "off.jpg"));
            });
        });
    </script>
</asp:Content>

