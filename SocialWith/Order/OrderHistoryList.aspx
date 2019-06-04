<%@ Page Title="" Language="C#" MasterPageFile="~/Master/Default.master" AutoEventWireup="true" CodeFile="OrderHistoryList.aspx.cs" Inherits="Order_OrderHistoryList" %>

<asp:Content ID="Content3" runat="server" ContentPlaceHolderID="head">
    <script src="../Scripts/order.js"></script>
     <asp:Literal runat="server" ID="orderCss" EnableViewState="false"></asp:Literal>
    

    <style>
        /*소스용*/
        .budget-view {
            display: none;
        }

        table#tblGoodsInfo,
        table#tblGoodsInfo td {
            border: none !important;
        }
    </style>

    <script type="text/javascript">
        var is_sending = false;

        $(document).ready(function () {

            fnSetPaywaySearch('<%=ddlPayWay.ClientID%>','<%=UserInfoObject.UserInfo.BPayType %>');

            var budget_role = '<%=UserInfoObject.Svid_Role %>';

            //기능보류[2018-10-23]
            if (budget_role != "A1") {
                //$(".budget-view").removeClass("budget-view");
                $('#thHeaderName').html('주문자<br/>(요청자)');
            }


            //체크박스 하나만 선택
            var tableid = 'tblHistoryList';
            ListCheckboxOnlyOne(tableid);

            //달력
            $("#<%=this.txtSearchSdate.ClientID%>").datepicker({
                showAnimation: 'slideDown',
                changeMonth: true,
                changeYear: true,
                showOn: 'button',
                buttonImage:/* "/Images/icon_calandar.png"*/"../Images/Goods/calendar.jpg",
                buttonImageOnly: true,
                dateFormat: "yy-mm-dd",
                monthNamesShort: ["1월", "2월", "3월", "4월", "5월", "6월", "7월", "8월", "9월", "10월", "11월", "12월"],
                dayNamesMin: ["일", "월", "화", "수", "목", "금", "토"],
                showMonthAfterYear: true
            });

            $("#<%=this.txtSearchEdate.ClientID%>").datepicker({
                showAnimation: 'slideDown',
                changeMonth: true,
                changeYear: true,
                showOn: 'button',
                buttonImage:/* "/Images/icon_calandar.png"*/"../Images/Goods/calendar.jpg",
                buttonImageOnly: true,
                dateFormat: "yy-mm-dd",
                monthNamesShort: ["1월", "2월", "3월", "4월", "5월", "6월", "7월", "8월", "9월", "10월", "11월", "12월"],
                dayNamesMin: ["일", "월", "화", "수", "목", "금", "토"],
                showMonthAfterYear: true
            });

            $("#txtDataPicker").datepicker({
                showAnimation: 'slideDown',
                changeMonth: true,
                changeYear: true,
                showOn: 'button',
                buttonImage:/* "/Images/icon_calandar.png"*/"../Images/Goods/calendar.jpg",
                buttonImageOnly: true,
                dateFormat: "yy-mm-dd",
                monthNamesShort: ["1월", "2월", "3월", "4월", "5월", "6월", "7월", "8월", "9월", "10월", "11월", "12월"],
                dayNamesMin: ["일", "월", "화", "수", "목", "금", "토"],
                showMonthAfterYear: true,
                beforeShow: function () {
                    $(this).css({
                        "position": "relative",
                        "z-index": '999999'
                    });
                },
            });

            $('#tblHistoryList input[type="checkbox"]').change(function () {
                if ($(this).prop('checked') == true) {
                    var num = $(this).val();
                    var newDate = new Date($("#<%=this.txtSearchEdate.ClientID%>").val());
                    var resultDate = new Date();
                    resultDate.setDate(newDate.getDate() - num);
                    $("#<%=this.txtSearchSdate.ClientID%>").val($.datepicker.formatDate("yy-mm-dd", resultDate));
                }
            });

        });

        // 주문상세 팝업 화면 로딩 시 데이터 설정
        function fnSetDetailPopupDataBind(response) {
            var ordGdsList = null;
            var payInfo = null;

            $.each(response, function (key, value) {
                switch (key) {
                    case "orderGoodsList":
                        ordGdsList = value;
                        break;
                    case "payInfo":
                        payInfo = value;
                        break;
                }
            });

            //주문상품
            $("#tbody_pop_odrDtl").html("");
            //결제내용
            $("#tbl_dtlPop_pay").html("");

            var defaultTag = "<tr><th colspan= '2'> 결제금액</th></tr>"
                + "<tr><th>결제방식</th>"
                + "<td id='tdDtl_payway'></td></tr>"
                + "<tr><th id='th_dtl_totSalePrice'>총 구매금액</th>"
                + "<td id='tdDtl_totSalePrice'></td></tr>"
                + "<tr><th>배송비</th>"
                + "<td id='tdDtl_dlvrCost'></td></tr>"
                + "<tr><th>특수 배송비</th>"
                + "<td id='tdDtl_powerDlvrCost'></td></tr>"
                + "<tr><th id='th_dtl_payPrice'>결제금액</th>"
                + "<td id='tdDtl_payPrice'></td></tr>"
                //+ "<tr><th id='th_dtl_payPrice'>결제TID</th>"
                + "<td style='display:none' id='tdPG_Tid'></td></tr>";

            $("#tbl_dtlPop_pay").append(defaultTag);

            var ordStat = fnSetOrderGoodsList(ordGdsList);
            var result = fnSetPayInfo(payInfo, ordStat);
            var hdValue = $("#hdPopupGoodsCode").val();

            //tr색칠
            $('#tblOrder tbody tr').each(function (index, element) {
                if ($(element).find("#tdDtlGdsCode").text() == hdValue) {
                    $(this).css('background-color', '#FAF4C0');
                }
            });

            //합배송/분할배송 관련 부분
            var deliTypeFlag = false;

            $("#tbody_pop_odrDtl tr").each(function (index, element) {
                var deliType = $(this).find("input:hidden[name^='hdGdsDeliType']").val();
                //alert("deliType_" + index + " : " + deliType);

                if (!isEmpty(deliType) && (deliType != "11")) {
                    deliTypeFlag = true;
                }
            });

            //if (deliTypeFlag) {
            //    $("#aDocStat_1").css("display", "none");
            //    $("#aDocStat_2").css("display", "");
            //    $("#aDocStat_3").css("display", "");
            //} else {
            //    $("#aDocStat_2").css("display", "none");
            //    $("#aDocStat_3").css("display", "none");
            //    $("#aDocStat_1").css("display", "");
            //}

            if (result) {
                //var width = 1050;
                //var height = 700;
                //var left = (window.screen.width / 2) - (width / 2);
                //var top = (window.screen.height / 2) - (height / 2);
                //layer_popup_open("divPopup", "divPopup_check", top / 2, left, width, height);

                var e = document.getElementById('productDiv');

                if (e.style.display == 'block') {
                    e.style.display = 'none';

                } else {
                    e.style.display = 'block';
                    $(".popupdivWrapper").draggable();
                }
            }
        }

        // 주문상세 팝업 - 주문상품 목록 설정
        function fnSetOrderGoodsList(list) {

            var ordStat = 0;
            var taxYNFlags = '';
            for (i in list) {
                // 상태값을 처음에 한 번만 저장
                if (i == 0) {
                    ordStat = list[i].OrderStatus;
                    $('#hdBillNo').val(list[i].SbillSeq);
                    $('#hdMD5').val(list[i].MD5);
                    $('#hdzBillNo').val(list[i].zSbillSeq);
                    $('#hdzMD5').val(list[i].zMD5);
                }

                var gdsFinalCtgrCode = list[i].GoodsFinalCategoryCode;
                var gdsGrpCode = list[i].GoodsGroupCode;
                var gdsCode = list[i].GoodsCode;
                var gdsName = list[i].GoodsFinalName;

                var src = "/GoodsImage" + "/" + gdsFinalCtgrCode + "/" + gdsGrpCode + "/" + gdsCode + "/" + gdsFinalCtgrCode + "-" + gdsGrpCode + "-" + gdsCode + '-sss.jpg';
                taxYNFlags += list[i].GoodsSaleTaxYN + ',';
                var addRow = "<tr>"
                    + "<td>"
                    //+ "<img onerror='no_image(this, \"s\")' src='" + src + "' alt='" + gdsName + "' title='" + gdsName + "' />"
                    + "<img onerror='no_image(this, \"s\")' src='" + src + "' alt='" + gdsName + "' title='" + gdsName + "' width='50' height='50'/>"
                    + "<input type='hidden' name='hd_dtl_OdrCodeNo' value='" + list[i].OrderCodeNo + "' />"
                    + "<input type='hidden' name='hdGdsDeliType' value='" + list[i].GoodsDeliveryType + "' />" //상품의 배송유형(합/분할)
                    + "</td>"
                    + "<td id='tdDtlGdsCode'>" + list[i].GoodsCode + "</td>"
                    + "<td id='tdDtlGdsInfo' style='text-align:left'>[" + list[i].BrandName + "] " + list[i].GoodsFinalName + "<br><span style='color:#368AFF; width:280px; word-wrap:break-word; display:block;'>" + list[i].GoodsOptionSummaryValues + "</span></td>"
                    + "<td id='tdDtlModel'>" + list[i].GoodsModel + "</td>"
                    + "<td id='tdDtlDueName'>" + list[i].GoodsDeliveryOrderDue_Name + "</td>"
                    //+ "<td id='tdDtlUnit'>" + list[i].GoodsUnitQty + "(" + list[i].GoodsUnit_Name + ")</td>"
                    + "<td id='tdDtlMoq' >" + list[i].GoodsUnitMoq + "</td>"
                    + "<td id='tdDtlUnit' style='text-align:center'>" + list[i].GoodsUnit_Name + "</td>"
                    + "<td id='tdDtlSalePrice' style='text-align:right; padding-right:5px'>" + numberWithCommas(list[i].GoodsSalePriceVat) + "원</td>"
                    + "<td id='tdDtlQty'>" + list[i].Qty + "</td>"
                    + "<td id='tdDtlSaleComp' style='text-align:center'>" + list[i].OrderSaleCompanyName + "</td>"
                    + "<td id='tdDtlPayway'>" + list[i].PayWayName + "</td>"
                    + "<td id='tdDtlTotSalePrice' style='text-align:right; padding-right:5px'>" + numberWithCommas(list[i].GoodsTotalSalePriceVAT) + "원</td>"
                    + "</tr>";

                $("#tbody_pop_odrDtl").append(addRow);
            }

            if (taxYNFlags.indexOf('0') > -1 && taxYNFlags.indexOf('1') > -1) {   //과세/비과세 품목이 다 포함

                $('#trTaxinvoice_1').css('display', 'none');
                $('#trTaxinvoice_2').css('display', 'none');
                $('#trTaxinvoice_3').css('display', '');
            }
            else if (taxYNFlags.indexOf('0') == -1 && taxYNFlags.indexOf('1') > -1) { //과세품목만  포함
                //MD5나 zMD5하나라도 있으면 세금계산서 버튼이 뜸
                if (!isEmpty(list[i].MD5) || !isEmpty(list[i].zMD5)) {
                    $('#trTaxinvoice_1').css('display', '');
                } else if (isEmpty(list[i].MD5) && isEmpty(list[i].zMD5)) {
                    $('#trTaxinvoice_1').css('display', '');
                    $('#imgTaxInvoice_1').prop('src', '../Images/Order/taxBill.jpg'); //이미지추가
                    $('#imgTaxInvoice_1').prop('alt', '세금계산서요청');
                    $('#imgTaxInvoice_1').prop('id', 'imgReqTax');
                    $("#imgReqTax").attr('onclick', '').unbind('click');
                    $("#imgReqTax").attr('onclick', 'fnReqTax()').bind('click');
                    //문구 추가
                    $("#lblText").html("※ 배송완료시 세금계산서가 발행됩니다.<br />세금계산서 일자를 변경하고싶으시면 세금계산서 수정 버튼을 클릭하여 주시기바랍니다.");
                }

                $('#trTaxinvoice_2').css('display', 'none');
                $('#trTaxinvoice_3').css('display', 'none');
            }
            else if (taxYNFlags.indexOf('0') > -1 && taxYNFlags.indexOf('1') == -1) { //비과세품목만  포함

                $('#trTaxinvoice_1').css('display', 'none');
                $('#trTaxinvoice_2').css('display', '');
                $('#trTaxinvoice_3').css('display', 'none');
            }

            return ordStat;
        }

        function fnPopupModify() {
            if (fnPopupValidation()) {
                var txtDataPicker = $("#txtDataPicker").val();
                var billEmail = $("#txtEmail1").val() + "@" + $("#txtEmail2").val();
                var orderCodeNo = $("input[name = hd_dtl_OdrCodeNo]").val();

                var callback = function (response) {

                    if (!isEmpty(response) && (response == "OK")) {
                        alert("성공적으로 세금계산서 발행 정보가 수정되었습니다.");

                    } else {
                        alert("오류가 발생했습니다. 잠시 후 다시 시도해 주세요.");
                    }

                    return false;

                }
                var param = { Method: 'PayBillCheck', OrderCodeNo: orderCodeNo, BillSelectDate: txtDataPicker, BillEmail: billEmail };

                var beforeSend = function () { };
                var complete = function () { };

                JqueryAjax("Post", "../Handler/OrderHandler.ashx", true, false, param, "text", callback, beforeSend, complete, true, '<%=Svid_User%>');

                <%--JajaxSessionCheck('Post', '../Handler/OrderHandler.ashx', param, 'text', callback, '<%=Svid_User%>');--%>
            }

        }

        //팝업창 필수값 체크
        function fnPopupValidation() {
            var txtDataPicker = $("#txtDataPicker");
            var txtEmail1 = $("#txtEmail1");
            var txtEmail2 = $("#txtEmail2");

            if (txtDataPicker.val() == '') {
                alert('세금계산서 일자는 필수 입력 항목입니다.');
                txtDataPicker.focus();
                return false;
            }

            if (txtEmail1.val() == '') {
                alert('세금계산서 이메일 필수 입력 항목입니다.');
                txtEmail1.focus();
                return false;
            }

            if (txtEmail2.val() == '') {
                alert('세금계산서 이메일 필수 입력 항목입니다.');
                txtEmail2.focus();
                return false;
            }

            var regeMail = /^([\w-]+(?:\.[\w-]+)*)@((?:[\w-]+\.)*\w[\w-]{0,66})\.([a-z]{2,6}(?:\.[a-z]{2})?)$/;
            if (!regeMail.test((txtEmail1.val() + '@' + txtEmail2.val()))) {
                alert("잘못된 이메일 형식입니다.");
                txtEmail1.focus();
                return false;
            }

            return true;
        }

        function fnReqTax() {
            //초기화

            if ($('#hdPrintPayway').val() == '1' || $('#hdPrintPayway').val() == '5') {

                alert('카드결제는 세금계산서 발행이 안됩니다.');
                return false;
            }

            var ordStat = $('#hdPrintOrderStaus').val();
            var numOrdStat = Number(ordStat);
            if ((numOrdStat >= 400) && (numOrdStat < 500)) {
                alert("주문취소관련 상품이므로 세금계산서 발행이 안됩니다.\n관리자에게 문의하시기 바랍니다.");
                return false;
            }

            var orderCodeNo = $("input[name = hd_dtl_OdrCodeNo]").val();
            var callback = function (response) {

                if (!isEmpty(response)) {
                    if (response.BillCheck == 'Y') {
                        var email1 = response.BillEmail.split('@')[0];
                        var email2 = response.BillEmail.split('@')[1];
                        var date = response.BillSelectDate.split('T')[0];
                        $("#txtDataPicker").val(date);
                        $("#txtEmail1").val(email1);
                        $("#txtEmail2").val(email2);
                    }

                } else {
                    alert("오류가 발생했습니다. 잠시 후 다시 시도해 주세요.");
                }

                return false;

            }

            if ($("#tbl_dtlPop_pay tbody").children(":last").prop('id') == 'trEmail') {
                $("#spanBtn").empty();
                $("#tbl_dtlPop_pay tbody").children(":last").remove();
                $("#tbl_dtlPop_pay tbody").children(":last").remove();
            }


            $("#spanBtn").prepend('<input type="button" id="btnTab1" class="mainbtn type1" style="width: 95px; height: 30px; font-size: 12px" value="수정" onclick="return fnPopupModify()">'); //이미지추가
            var addTbl = "";
            addTbl += "<tr><th>세금계산서 일자</th>"
            addTbl += "<td><input type='text' readonly='readonly' class='calendar' Onkeypress='return fnEnter();' id='txtDataPicker' /></td></tr>"
            addTbl += "<tr id='trEmail'><th>세금계산서 이메일</th>"
            addTbl += "<td><input type='text' Onkeypress='return fnEnter();' id='txtEmail1' style='border:1px solid #a2a2a2; height:24.3px; width:45%'/> @ <input type='text' Onkeypress='return fnEnter();' id='txtEmail2' style='border:1px solid #a2a2a2; height:24.3px; width:46%'/></td></tr>";
            $("#tbl_dtlPop_pay tbody").append(addTbl);

            //$("#txtDataPicker").val((new Date()).yyyymmdd());
            $("#txtDataPicker").datepicker({
                showAnimation: 'slideDown',
                changeMonth: true,
                changeYear: true,
                showOn: 'button',
                buttonImage:/* "/Images/icon_calandar.png"*/"../Images/Goods/calendar.jpg",
                buttonImageOnly: true,
                dateFormat: "yy-mm-dd",
                monthNamesShort: ["1월", "2월", "3월", "4월", "5월", "6월", "7월", "8월", "9월", "10월", "11월", "12월"],
                dayNamesMin: ["일", "월", "화", "수", "목", "금", "토"],
                showMonthAfterYear: true,
                beforeShow: function () {
                    $(this).css({
                        "position": "relative",
                        "z-index": '999999'
                    });
                },
            });

            var param = { Method: 'GetPayBillCheck', OrderCodeNo: orderCodeNo };

            var beforeSend = function () { is_sending = true; }
            var complete = function () { is_sending = false; }
            if (is_sending) return false;

            JqueryAjax("Post", "../Handler/OrderHandler.ashx", true, false, param, "json", callback, beforeSend, complete, true, '<%=Svid_User%>');

            <%--JajaxSessionCheck('Post', '../Handler/OrderHandler.ashx', param, 'json', callback, '<%=Svid_User%>');--%>

        }

        // 주문상세 팝업 - 결제정보 설정
        function fnSetPayInfo(info, ordStat) {

            if (isEmpty(info)) {
                alert("오류가 발생했습니다. 관리자에게 문의하세요.");
                return false;
            }

            var payway = info.Payway;

            // 공통항목
            $("#tdDtl_payway").text(info.Payway_Name);
            $("#tdDtl_totSalePrice").text(numberWithCommas(info.Total_GoodsSalePriceVat) + "원");
            $("#tdDtl_dlvrCost").text(numberWithCommas(info.DeliveryCost) + "원");
            $("#tdDtl_powerDlvrCost").text(numberWithCommas(info.PowerDeliveryCost) + "원");
            $("#tdDtl_payPrice").text(numberWithCommas(info.Amt) + "원");
            $("#tdPG_Tid").text(info.Pg_Tid);

            var numOrdStat = Number(ordStat);

            // 주문취소인 경우
            if ((numOrdStat >= 400) && (numOrdStat < 500)) {

                $("#th_dtl_totSalePrice").text("총 구매취소금액");
                $("#th_dtl_payPrice").text("결제취소금액");

            } else { // 주문완료인 경우

                $("#th_dtl_totSalePrice").text("총 구매금액");
                $("#th_dtl_payPrice").text("결제금액");

                var addTag = "";

                switch (payway) {
                    case '1':
                        addTag = "<tr><th>카드번호</th>"
                            + "<td>" + info.PayCardNo + "</td></tr>"
                            + "<tr><th>카드명</th>"
                            + "<td>" + info.PayCardName + "</td></tr>";
                        break;
                    case '2':
                        addTag = "<tr><th>결제계좌</th>"
                            + "<td>XXXXXXXXXXXX(개인정보보호)</td></tr>"
                            + "<tr><th>결제은행</th>"
                            + "<td>" + info.BankName + "</td></tr>";
                        break;
                    case '3':
                        addTag = "<tr><th>입금은행</th>"
                            + "<td>" + info.VbankNo + "</td></tr>"
                            + "<tr><th>입금은행</th>"
                            + "<td>" + info.VbankName + "</td></tr>"
                            + "<tr><th>예금주</th>"
                            + "<td>" + info.BankTypeName + "</td></tr>";
                        break;
                    case '4':
                        addTag = "<tr><th>입금은행</th>"
                            + "<td>" + info.VbankNo + "</td></tr>"
                            + "<tr><th>입금은행</th>"
                            + "<td>" + info.VbankName + "</td></tr>"
                            + "<tr><th>예금주</th>"
                            + "<td>" + info.BankTypeName + "</td></tr>";
                        break;
                    case '5':
                        addTag = "<tr><th>카드번호</th>"
                            + "<td>" + info.PayCardNo + "</td></tr>"
                            + "<tr><th>카드명</th>"
                            + "<td>" + info.PayCardName + "</td></tr>";
                        break;
                    case '6':
                        addTag = "<tr><th>입금은행</th>"
                            + "<td>" + info.VbankNo + "</td></tr>"
                            + "<tr><th>입금은행</th>"
                            + "<td>" + info.VbankName + "</td></tr>"
                            + "<tr><th>예금주</th>"
                            + "<td>" + info.BankTypeName + "</td></tr>";
                        break;
                    case '8':
                        addTag = "<tr><th>입금계좌</th>"
                            + "<td>" + info.VbankNo + "</td></tr>"
                            + "<tr><th>입금은행</th>"
                            + "<td>" + info.VbankName + "</td></tr>"
                            + "<tr><th>예금주</th>"
                            + "<td>" + info.BankTypeName + "</td></tr>";
                        break;
                    case '9':
                        addTag = "<tr><th>입금계좌</th>"
                            + "<td>" + info.VbankNo + "</td></tr>"
                            + "<tr><th>입금은행</th>"
                            + "<td>" + info.VbankName + "</td></tr>"
                            + "<tr><th>예금주</th>"
                            + "<td>" + info.BankTypeName + "</td></tr>";
                        break;
                }

                $("#tbl_dtlPop_pay").append(addTag);
            }

            return true;
        }

        // 주문상세 팝업
        function fnOdrDtlPopup(el) {
            //$("#hdPopupGoodsCode").val($(el).parent().parent().find('#tdGoodsCode').text());
            $("#hdPopupGoodsCode").val($(el).parent().parent().find("input:hidden[name='hdGdsCode']").val());
            $("#spanBtn").empty();
            $('#hdPrintOrderCodeNo').val('');
            $('#hdPrintOrderStaus').val('');
            $('#hdPrintSvidUser').val('');
            $('#hdPrintPayway').val('');
            $('#hdDocumentOrderSaleCompCode').val('');

            $('#hdBillNo').val('');
            $('#hdMD5').val('');
            $('#hdzBillNo').val('');
            $('#hdzMD5').val('');

            var callback = function (response) {
                if (!isEmpty(response)) {

                    fnSetDetailPopupDataBind(response);
                    fnDocumentBind();

                } else {
                    alert("오류가 발생했습니다. 잠시 후 다시 시도해 주세요.");
                }

                return false;
            };

            var sUser = '<%= Svid_User %>';
            var odrCodeNo = $(el).parent().parent().find("input:hidden[name^=hdOrderCodeNo]").val();
            var odrStat = $(el).parent().parent().find("input:hidden[name^=hdOrdStat]").val();
            var payway = $(el).parent().parent().find("input:hidden[name^=hdPayWay]").val();
            var hdSvidUser = $(el).parent().parent().find("input:hidden[name^=hdSvidUser]").val();
            var hdOrderSaleCompCode = $(el).parent().parent().find("input:hidden[name^=hdOrderSaleCompCode]").val();
            var unumOrdNo = $(el).parent().parent().find("input:hidden[name^=hdUorderNo]").val();

            $('#hdPrintOrderCodeNo').val(odrCodeNo);
            $('#hdPrintSvidUser').val(hdSvidUser);
            $('#hdPrintOrderStaus').val(odrStat);
            $('#hdPrintPayway').val(payway);
            $('#hdDocumentOrderSaleCompCode').val(hdOrderSaleCompCode);


            var param = { SvidUser: sUser, OdrCodeNo: odrCodeNo, OdrStat: odrStat, UnumOrdNo: unumOrdNo, Method: "OrderDtlInfo" };

            var beforeSend = function () { is_sending = true; }
            var complete = function () { is_sending = false; }
            if (is_sending) return false;

            JqueryAjax("Post", "../Handler/OrderHandler.ashx", true, false, param, "json", callback, beforeSend, complete, true, '<%=Svid_User%>');

            <%--JajaxDuplicationCheck("Post", "../Handler/OrderHandler.ashx", param, "json", callback, beforeSend, complete, true, '<%= Svid_User %>');--%>
        }

        //function fnSubmit() {
        //    $('#divPopup').fadeOut();
        //}

        // 취소 버튼 클릭 시 팝업 닫기
        function fnCancel() {
            $('.divpopup-layer-package').fadeOut();
        }

        // 가상계좌나 후불계좌일 경우 주문상태 관련 정보 조회(주문취소여부 관련)
        <%--function fnGetOrderCancelYN(uOrderNo, ordCodeNo) {
            //var returnVal = false;
            var callback = function (response) {
                var returnVal = false;
                if (!isEmpty(response)) {
                    var resultVal = response.Result;

                    if (Number(resultVal) >= 1) {
                        alert("주문하신 상품이 주문취소가 불가능합니다.\n관리자에게 문의하시기 바랍니다.");

                    } else {
                        // 결제 팝업
                        var url = "OrderCancel.aspx?uOdrNo=" + uOrderNo + "&ordCodeNo=" + ordCodeNo + "&sUser=" + '<%=Svid_User %>' + "&flag=VBANK";
                        var targetName = "ordCancelPopup";

                        var childWin = window.open(url, targetName, "height=500, width=800,status=yes,toolbar=no,menubar=no,location=no,resizable=no");
                    }

                } else {
                    alert("오류가 발생했습니다. 잠시 후 다시 시도해 주세요.");
                }
                return false;
            };

            var sUser = '<%=Svid_User %>';
            var param = { SvidUser: sUser, OrdCodeNo: ordCodeNo, Method: 'OrderStatCnt' };

            var beforeSend = function () { };
            var complete = function () { };

            JqueryAjax("Post", "../Handler/OrderHandler.ashx", true, false, param, "json", callback, beforeSend, complete, true, '<%=Svid_User%>');
        }--%>

        // 화면없이 주문취소
        function fnOrdCancelDirect(ordCodeNo, ordStat) {
            var callback = function (response) {
                var returnVal = false;
                if (!isEmpty(response)) {
                    var resultVal = response.Result;

                    alert("정상적으로 주문이 취소되었습니다.");

                } else {
                    alert("오류가 발생했습니다. 잠시 후 다시 시도해 주세요.");
                }

                fnSearch(1);

                return false;
            };

            var sUser = '<%=Svid_User %>';
            var param = { SvidUser: sUser, OrdCodeNo: ordCodeNo, OrdStat: ordStat, Method: 'OrdCancelDirect' };

            var beforeSend = function () { is_sending = true; }
            var complete = function () { is_sending = false; }
            if (is_sending) return false;

            JqueryAjax("Post", "../Handler/OrderHandler.ashx", true, false, param, "json", callback, beforeSend, complete, true, '<%=Svid_User%>');
        }


        //목록에서 취소 버튼 클릭 시
        function fnCancelClick(el) {
            var ordStat = $(el).parent().parent().find("input:hidden[name^='hdOrdStat']").val();
            var ordCodeNo = $(el).parent().parent().find("input:hidden[name^='hdOrderCodeNo']").val();
            var payway = $(el).parent().parent().find("input:hidden[name^='hdPayWay']").val();
            var payCashConfirm = $(el).parent().parent().find("input:hidden[name^='hdPayCashConfirm']").val();
            var uNumOrdNo = $(el).parent().parent().find("input:hidden[name^='hdUorderNo']").val();

            if ((payway == "3") || (payway == "4") || (payway == "6") || (payway == "7") || (payway == "8") || (payway == "9") || (payway == "10")) {

                //배송단계에 있는 상품이 있는지 조회
                var callback = function (response) {
                    var returnVal = false;
                    if (!isEmpty(response)) {
                        var checkCnt = Number(response);
                        if (checkCnt > 0) {
                            alert("배송중인 상품이 있으므로 취소하실 수 없습니다.");
                            return false;
                        } else {
                            var confirmRst = confirm("가상계좌나 후불계좌로 결제하신 상품은 \"주문전체취소\"만 가능합니다.\n\n정말로 전체 주문을 취소 하시겠습니까?");

                            if (payway == "10") {
                                confirmRst = confirm("무통장입금으로 결제하신 상품은 현재는 \"주문전체취소\"만 가능합니다.\n부분취소는 추후 서비스 예정이며 부분취소를 원하시면 관리자에게 문의하시기 바랍니다.\n\n정말로 전체 주문을 전체 취소 하시겠습니까?");
                            }

                            if (confirmRst) {

                                //여신결제(일반/판매분/무)
                                if ((payway == "6") || (payway == "7") || (payway == "8") || (payway == "10")) {
                                    fnOrdCancelDirect(ordCodeNo, ordStat); // 화면 없이 주문 취소


                                    //가상계좌(후불), 가상계좌(고정)
                                } else if (((payway == "4") || (payway == "9"))) {

                                    if (payCashConfirm == 'Y') {
                                        var url = "VbankCancelRequest.aspx?ordCodeNo=" + ordCodeNo + "&sUser=" + '<%=Svid_User %>' + "&ordStat=" + ordStat;
                                        var targetName = "ordCancelVbankPopup";

                                        var childWin = window.open(url, targetName, "height=500, width=800,status=yes,toolbar=no,menubar=no,location=no,resizable=no");

                                    } else {
                                        fnOrdCancelDirect(ordCodeNo, ordStat); // 화면 없이 주문 취소
                                    }


                                    //가상계좌
                                } else {
                                    // 입금 전
                                    if ((ordStat == "101") || (ordStat == "411")) {

                                        fnOrdCancelDirect(ordCodeNo, ordStat); // 화면 없이 주문 취소

                                        // 입금 후
                                    } else if ((ordStat == "100") || (ordStat == "412")) {

                                        var url = "VbankCancelRequest.aspx?ordCodeNo=" + ordCodeNo + "&sUser=" + '<%=Svid_User %>' + "&ordStat=" + ordStat;
                                        var targetName = "ordCancelVbankPopup";

                                        var childWin = window.open(url, targetName, "height=500, width=800,status=yes,toolbar=no,menubar=no,location=no,resizable=no");
                                    }
                                }
                            }
                        }
                    }

                    return false;
                };

                var sUser = '<%=Svid_User %>';
                var param = { SvidUser: sUser, OrdCodeNo: ordCodeNo, Method: 'OrdDeliveryCheck' };

                var beforeSend = function () { };
                var complete = function () { };

                JqueryAjax("Post", "../Handler/OrderHandler.ashx", true, false, param, "text", callback, beforeSend, complete, true, '<%=Svid_User%>');

            } else {

                //ARS결제전 취소
                if ((ordStat == "102") && (payway == "5")) {
                    var confirmRst = confirm("ARS(신용카드) 결제전 상품은 \"주문전체취소\"만 가능합니다.\n\n정말로 전체 주문을 취소 하시겠습니까?");
                    if (confirmRst) {
                        fnOrdCancelDirect(ordCodeNo, ordStat); // 화면 없이 주문 취소
                    }

                    //신용카드/ARS결제후
                } else {
                    var cancel_uNumOrdNo = $(el).parent().parent().find("input:hidden[name^='hdUorderNo']").val();
                    var confirmVal = true;

                    var callback = function (response) {
                        if (!isEmpty(response)) {
                            var resultVal = false;
                            var uNumOrdNoArr = '';

                            if (response.length > 1) {

                                $.each(response, function (key, value) {

                                    //var ordCodeNo = parseInt(value.OrderCodeNo, 10);
                                    var totGdsSalePriceVAT = parseInt(value.GoodsTotalSalePriceVAT, 10); //총 주문상품합계금액
                                    var remainPriceVAT = parseInt(value.Remain_GoodsSalePriceVAT, 10); //남은 금액
                                    var uNumOrdNo = parseInt(value.Unum_OrderNo, 10); //주문번호 시퀀스

                                    if ((totGdsSalePriceVAT >= 50000) && (remainPriceVAT < 50000)) {

                                        resultVal = true;

                                        if (cancel_uNumOrdNo != uNumOrdNo) {
                                            uNumOrdNoArr += uNumOrdNo + ",";
                                        }
                                    }
                                });

                                //남은금액이 5만원미만
                                if (resultVal) {
                                    confirmVal = confirm("상품 취소시, 총 주문상품 합계금액이 5만원 이하이므로 배송비가 부가됩니다. 배송비 부가는 주문전체취소와 재결제 단계로 진행됩니다.\n\n주문 전체취소를 진행 하시겠습니까?");

                                    if (confirmVal) {
                                        //alert("취소 요청(" + cancel_uNumOrdNo + ") : " + uNumOrdNoArr);

                                        fnCancelAllPopup(el);
                                    }

                                    //남은금액이 5만원이상
                                } else {
                                    fnCancelPopup(el);
                                }

                                //마지막 상품 주문 취소시
                            } else {
                                fnCancelPopup(el);
                            }
                        }
                        return false;
                    };

                    var beforeSend = function () { is_sending = true; }
                    var complete = function () { is_sending = false; }
                    if (is_sending) return false;

                    var param = { OrdCodeNo: ordCodeNo, UNumOrdNo: cancel_uNumOrdNo, Method: 'OrderPriceData' };

                    JqueryAjax("Post", "../Handler/OrderHandler.ashx", true, false, param, "json", callback, beforeSend, complete, true, '<%=Svid_User%>');
                }

            }
        }

        //주문취소 팝업(신용카드, 실시간이체) - 1건
        function fnCancelPopup(el) {

            var uOrderNo = $(el).parent().parent().find("input:hidden[name^='hdUorderNo']").val();
            var ordCodeNo = $(el).parent().parent().find("input:hidden[name^='hdOrderCodeNo']").val();
            var payway = $(el).parent().parent().find("input:hidden[name^='hdPayWay']").val();

            //var url = "OrderCancel";
            var url = "OrderCancelRequest";
            var targetName = "OrdCancelPopup";

            var addForm = "<form name='ordCancelPayForm' method='POST' action='" + url + "' target='" + targetName + "'>"
                //+ "<input type='hidden' name='goodsCnt' value='" + goodsCnt + "' />"
                + "<input type='hidden' name='uOdrNo' value='" + uOrderNo + "' />"
                + "<input type='hidden' name='ordCodeNo' value='" + ordCodeNo + "' />"
                + "<input type='hidden' name='sUser' value='" + '<%=Svid_User %>' + "' />"
                + "<input type='hidden' name='flag' value='ETC' />"
                + "</form>";

            $("body").append(addForm);


            var popupForm = $("form[name='ordCancelPayForm']");

            fnWindowOpen('', targetName, 800, 500, 'yes', 'no', 'no', 'no', 'no', 'no');

            popupForm.submit();






<%--            var url = "OrderCancel.aspx?uOdrNo=" + uOrderNo + "&ordCodeNo=&sUser=" + '<%=Svid_User %>' + "&flag=ETC";
            var targetName = "ordCancelPopup";

            var width = 500;
            var height = 800;
            var popupX = (window.screen.width / 2) - (width / 2);
            var popupY = (window.screen.height / 2) - (height / 2);

            var childWin = window.open(url, targetName, "height=" + height + ", width=" + width + ",status=yes,toolbar=no,menubar=no,location=no,scrollbars=no,resizable=no, left=" + popupX + ", top=" + popupY + ", screenX=" + popupX + ", screenY= " + popupY + ";");
            --%>
        }

        //주문취소 팝업(신용카드, 실시간이체) - 전부
        function fnCancelAllPopup(el) {

            var uOrderNo = $(el).parent().parent().find("input:hidden[name^='hdUorderNo']").val();
            var ordCodeNo = $(el).parent().parent().find("input:hidden[name^='hdOrderCodeNo']").val();
            var payway = $(el).parent().parent().find("input:hidden[name^='hdPayWay']").val();

            //var url = "OrderCancel";
            var url = "OrderCancelRequest";
            var targetName = "OrdCancelAllPopup";

            var addForm = "<form name='ordCancelAllForm' method='POST' action='" + url + "' target='" + targetName + "'>"
                + "<input type='hidden' name='uOdrNo' value='" + uOrderNo + "' />"
                + "<input type='hidden' name='ordCodeNo' value='" + ordCodeNo + "' />"
                + "<input type='hidden' name='sUser' value='" + '<%=Svid_User %>' + "' />"
                + "<input type='hidden' name='flag' value='ETC' />"
                + "<input type='hidden' name='cancelFlag' value='ALL_12' />"
                + "</form>";

            $("body").append(addForm);


            var popupForm = $("form[name='ordCancelAllForm']");

            fnWindowOpen('', targetName, 800, 500, 'yes', 'no', 'no', 'no', 'no', 'no');

            popupForm.submit();

        }

        //초기화
        function fnInitState() {
            alert('검색조건을 초기화 합니다.');
            window.location.reload(true);
        }

        //조회하기
        function fnSearch(pageNum) {
            var startDate = $('#<%= txtSearchSdate.ClientID%>').val();
            var endDate = $('#<%= txtSearchEdate.ClientID%>').val();
            var orderCodeNo = $('#<%= txtOrderNo.ClientID %>').val();
            var brand = $('#<%= txtBrand.ClientID %>').val();
            var goodsName = $('#<%= txtGoodsName.ClientID %>').val();
            var goodsCode = $('#<%= txtGoodsCode.ClientID %>').val();
            var odrStat = $('#<%=ddlOrderStatus.ClientID %>').val();
            var payway = $('#<%=ddlPayWay.ClientID %>').val();
            var pageSize = 20;
            var i = 1;
            var asynTable = "";
            var budget_role = '<%=UserInfoObject.Svid_Role %>';

            var callback = function (response) {
                $("#tblSearch tbody").empty();

                if (!isEmpty(response)) {
                    $.each(response, function (key, value) {

                        var dlvrDate = value.DeliveryDate;
                        var name = '';
                        if (!isEmpty(dlvrDate)) {
                            dlvrDate = value.DeliveryDate.split("T")[0];
                        } else {
                            dlvrDate = '';
                        }

                        var budget_role = '<%=UserInfoObject.Svid_Role %>';

                        if (budget_role != 'A1') {
                            if (value.RequestName != '') {
                                name = value.Name + "<br/>(" + value.RequestName + ")";
                            }
                            else {
                                name = value.Name;
                            }
                        }
                        else {
                            name = value.Name;
                        }

                        $("#hdTotalCount").val(value.TotalCount);

                        var ordCancelYn = value.OrdCancelYn; // 주문취소 가능 여부
                        var cancelTag = "";
                        var src = '/GoodsImage' + '/' + value.GoodsFinalCategoryCode + '/' + value.GoodsGroupCode + '/' + value.GoodsCode + '/' + value.GoodsFinalCategoryCode + '-' + value.GoodsGroupCode + '-' + value.GoodsCode + '-sss.jpg';
                        if (ordCancelYn == "Y") {

                            var userRole = '<%=UserInfoObject.Svid_Role %>'; //권한 유형

                            if ((userRole == "A1") || (userRole == "B1") || (userRole == "C2") || (userRole == "BC2")) {
                                //cancelTag = "<a><img src='../Images/Order/cancleh-on.jpg' alt='취소' onclick='fnCancelPopup(this); return false;' onmouseover=\"this.src='../Images/Order/cancleh-off.jpg'\" onmouseout=\"this.src='../Images/Order/cancleh-on.jpg'\"></a>";
                                //cancelTag = "<a><img src='../Images/Order/apply-off.jpg' alt='취소' onclick='fnCancelClick(this); return false;' onmouseover=\"this.src='../Images/Order/apply-on.jpg'\" onmouseout=\"this.src='../Images/Order/apply-off.jpg'\"></a>";
                                cancelTag = "<input type='button' class='listBtn' value='신 청' style='width:71px; height:22px; font-size:12px' onclick='return fnCancelClick(this);' />";
                            }
                        }

                        asynTable += "<tr><input type='hidden' name='hdUorderNo' value='" + value.Unum_OrderNo + "' />";
                        asynTable += "<input type= 'hidden' name='hdOrderCodeNo' value='" + value.OrderCodeNo + "' />";
                        asynTable += "<input type= 'hidden' name='hdSvidUser' value='" + value.Svid_User + "' />";
                        asynTable += "<input type= 'hidden' name='hdPayWay' value='" + value.PayWay + "' />";
                        asynTable += "<input type= 'hidden' name='hdOrdStat' value='" + value.OrderStatus + "' />";
                        asynTable += "<input type= 'hidden' name='hdOrderSaleCompCode' value='" + value.OrderSaleCompanyCode + "' />";
                        asynTable += "<input type= 'hidden' name='hdPayCashConfirm' value='" + value.PayCashConfirm + "' />";
                        asynTable += "<input type= 'hidden' name='hdGdsCode' value='" + value.GoodsCode + "' />";

                        asynTable += "<td rowspan='2' class='border-right'>" + value.RowNumber + "</td>";
                        asynTable += "<td class='border-right'>" + value.EntryDate.split("T")[0] + "</td>";
                        asynTable += "<td class='border-right'>" + value.OrderSaleCompanyName + "</td>";
                        asynTable += "<td rowspan='2' class='rowColor_td border-right'><table style='width:100%;' id='tblGoodsInfo'><tr><td rowspan='2' style='width:70px'><img src=" + src + " onerror='no_image(this, \"s\")' style='width:50px; height=50px'/></td><td style='text-align:left; width:280px'>" + value.GoodsCode + "</td></tr><tr><td style='text-align:left; width:280px'>" + "[" + value.BrandName + "] " + value.GoodsFinalName + "<br/><span style='color:#368AFF; width:280px; word-wrap:break-word; display:block;'>" + value.GoodsOptionSummaryValues + "</span></td></tr></table></td>";
                        asynTable += "<td rowspan='2' class='border-right'> " + value.GoodsModel + "</td >";

                        asynTable += "<td rowspan='2' class='border-right'>" + value.GoodsUnit + "</td>";
                        asynTable += "<td rowspan='2' class='border-right'>" + value.Qty + "</td>";
                        asynTable += "<td rowspan='2' class='border-right' style='padding-right: 5px; text-align: right;' >" + numberWithCommas(value.GoodsTotalSalePriceVAT) + "원</td>";
                        asynTable += "<td class='budget-view' class='border-right'>" + value.CompanyDeptName + "</td>";
                        asynTable += "<td class='border-right'>" + value.GoodsDeliveryOrderDue_Name + "</td>";
                        asynTable += "<td rowspan='2' class='border-right'>" + value.OrderStatus_NAME + "</td>";
                        asynTable += "<td rowspan='2' class='border-right'>" + value.PayWayName + "</td>";
                        //asynTable += "<td rowspan='2' class='border-right'><a><img src='../Images/Order/submit-on.jpg' alt='확인' onclick='fnOdrDtlPopup(this); return false;' onmouseover=\"this.src='../Images/Order/submit-off.jpg'\" onmouseout=\"this.src='../Images/Order/submit-on.jpg'\"></a></td>"

                        asynTable += "<td rowspan='2' class='border-right'><input type='button' class='listBtn' value='확 인' style='width:71px; height:22px; font-size:12px' onclick='return fnOdrDtlPopup(this);' /></td>";


                        asynTable += "<td rowspan='2'>" + cancelTag + "</td></tr>";

                        //-----------------------------------------------------------------다음행-----------------------------------------------------------------------------------------------------------//
                        asynTable += "<tr><td class='border-right'>" + value.OrderCodeNo + "</td>";
                        asynTable += "<td class='border-right'>" + name + "</td>";
                        asynTable += "<td class='budget-view border-righ'>" + value.BudgetAccountName + "</td>";
                        asynTable += "<td class='border-right'>" + dlvrDate + "</td></tr>";



                        i++;
                    });
                } else {
                    asynTable += "<tr><td colspan='20' class='txt-center'>" + "조회된 주문내역이 없습니다." + "</td></tr>"
                    $("#hdTotalCount").val(0);
                }

                $("#tblSearch tbody").append(asynTable);

                //기능보류[2018-10-23]
                //if (budget_role != "A1") {
                //    $(".budget-view").removeClass("budget-view");
                //}
                fnCreatePagination('pagination', $("#hdTotalCount").val(), pageNum, 20, getPageData);
            }
            var sUser = '<%= Svid_User%>';
            param = { SvidUser: sUser, OrderStatus: odrStat, PayWay: payway, TodateB: startDate, TodateE: endDate, OrderCodeNo: orderCodeNo, Brand: brand, GoodsFinalName: goodsName, GoodsCode: goodsCode, Method: 'OrderHistory', PageNo: pageNum, PageSize: pageSize };

            var beforeSend = function () { };
            var complete = function () { };

            JqueryAjax("Post", "../Handler/OrderHandler.ashx", true, false, param, "json", callback, beforeSend, complete, true, sUser);

            //JajaxSessionCheck('Post', '../Handler/OrderHandler.ashx', param, 'json', callback, sUser);
        }

        function getPageData() {
            var container = $('#pagination');
            var getPageNum = container.pagination('getSelectedPageNum');
            fnSearch(getPageNum);
            return false;
        }

        function fnEnter() {
            if (event.keyCode == 13) {
                fnSearch(1);
                return false;
            }
            else
                return true;
        }

        function fnPortFolio() {

            if (($("#hdPrintPayway").val() != "1") && ($("#hdPrintPayway").val() != "5")) {
                alert("카드로 결제한 경우만 카드 명세표를 보실 수 있습니다.");
                return false;
            }

            var ordStat = $('#hdPrintOrderStaus').val();
            if (ordStat == '101') {
                alert('아직 입금전입니다.');
                return false;
            }
            var numOrdStat = Number(ordStat);
            if ((numOrdStat >= 400) && (numOrdStat < 500)) {
                alert("주문취소관련 상품이므로 카드명세표 출력을 하실 수 없습니다.\n관리자에게 문의하시기 바랍니다.");
                return false;
            }

            var status = "toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,width=420,height=540"
            var url = "https://pg.nicepay.co.kr/issue/IssueLoader.jsp?TID=" + $("#tdPG_Tid").text() + "&type=0";

            var width = 420;
            var height = 540;
            var dualScreenLeft = window.screenLeft != undefined ? window.screenLeft : screen.left;
            var dualScreenTop = window.screenTop != undefined ? window.screenTop : screen.top;

            var getwidth = window.innerWidth ? window.innerWidth : document.documentElement.clientWidth ? document.documentElement.clientWidth : screen.width;
            var getheight = window.innerHeight ? window.innerHeight : document.documentElement.clientHeight ? document.documentElement.clientHeight : screen.height;

            var left = ((getwidth / 2) - (width / 2)) + dualScreenLeft;
            var top = ((getheight / 2) - (height / 2)) + dualScreenTop;

            window.open(url, '', "width=" + width + ",height=" + height + ",status=no ,toolbar=no,menubar=no,location=no,resizable=yes,scrollbars=yes,left=" + left + ", top=" + top + "");
        }

        function fnDeliveryConfirmPrintPopup() {
            var ordStat = $('#hdPrintOrderStaus').val();
            //if (ordStat == "101") {
            //    alert('아직 입금전입니다.');
            //    return false;
            //}

            var numOrdStat = Number(ordStat);
            if ((numOrdStat >= 400) && (numOrdStat < 500)) {
                alert("주문취소관련 상품이므로 납품확인서 출력을 하실 수 없습니다.\n관리자에게 문의하시기 바랍니다.");
                return false;
            }

            var orderCodeNo = $('#hdPrintOrderCodeNo').val();
            var svidUser = $('#hdPrintSvidUser').val();
            var url = '../../Print/DeliveryConfirmationReport.aspx?OrderCodeNo=' + orderCodeNo + '&SvidUser=' + svidUser + '';

            //url, target, width, height, status, toolbar,  menubar, location, resizable, scrollbar
            fnWindowOpen(url, '', 1000, 600, 'yes', 'no', 'no', 'no', 'yes', 'yes');

            // window.open(url, '', "height=600, width=1000,status=yes,toolbar=no,menubar=no,location=no,resizable=no");
        }
        function fnStatementPopup() {
            var ordStat = $('#hdPrintOrderStaus').val();

            //if (ordStat == '101') {
            //    alert('아직 입금전입니다.');
            //    return false;
            //}
            if (Number(ordStat) >= 400) {
                alert("주문취소관련 상품에 대해선 거래명세서가 제공되지 않습니다.");
                return false;
            }
            var orderCodeNo = $('#hdPrintOrderCodeNo').val();
            var svidUser = $('#hdPrintSvidUser').val();

            var url = '../../Print/TransactionReport?OrderCodeNo=' + orderCodeNo + '&SvidUser=' + svidUser + '&OrdStat=' + ordStat;

            fnWindowOpen(url, '', 1000, 600, 'yes', 'no', 'no', 'no', 'yes', 'yes');

        }
        function fnPickingStatementPopup() {

            //if ($('#hdPrintOrderStaus').val() == '101') {
            //    alert('아직 입금전입니다.');
            //    return false;
            //}
            var orderCodeNo = $('#hdPrintOrderCodeNo').val();
            var svidUser = $('#hdPrintSvidUser').val();
            var url = '../../Print/PickingStatementReport?OrderCodeNo=' + orderCodeNo + '&SvidUser=' + svidUser;

            fnWindowOpen(url, '', 1000, 600, 'yes', 'no', 'no', 'no', 'yes', 'yes');

        }
        function fnDeliveryStatementPopup() {
            //if ($('#hdPrintOrderStaus').val() == '101') {
            //    alert('아직 입금전입니다.');
            //    return false;
            //}
            var orderCodeNo = $('#hdPrintOrderCodeNo').val();
            var svidUser = $('#hdPrintSvidUser').val();
            var url = '../../Print/DeliveryStatementReport?OrderCodeNo=' + orderCodeNo + '&SvidUser=' + svidUser;

            fnWindowOpen(url, '', 1000, 600, 'yes', 'no', 'no', 'no', 'yes', 'yes');

        }
        function fnReceiptPopup() {
            var ordStat = $('#hdPrintOrderStaus').val();

            //if ($('#hdPrintPayway').val() == '1') {
            //    alert('신용카드는 영수증 제공이 안됩니다.');
            //    return false;
            //}
            //if (Number(ordStat) >= 400) {
            //    alert("주문취소관련 상품에 대해선 영수증이 제공되지 않습니다.");
            //    return false;
            //}
            //if (ordStat == '101') {
            //    alert('아직 입금전입니다.');
            //    return false;
            //}
            var orderCodeNo = $('#hdPrintOrderCodeNo').val();
            var svidUser = $('#hdPrintSvidUser').val();

            var url = '../../Print/ReceiptReport?OrderCodeNo=' + orderCodeNo + '&SvidUser=' + svidUser + '&OrdStat=' + ordStat;

            //url, target, width, height, status, toolbar,  menubar, location, resizable, scrollbar
            fnWindowOpen(url, '', 1000, 600, 'yes', 'no', 'no', 'no', 'yes', 'yes');
            //window.open(url, '', "height=600, width=1000,status=yes,toolbar=no,menubar=no,location=no,resizable=no");
        }


        function fnBillPopup() {

            //var width = 700;
            //var height = 800;
            //var popupX = (window.screen.width / 2) - (width / 2);
            //var popupY = (window.screen.height / 2) - (height / 2);

            //if ($('#hdPrintPayway').val() == '1') {
            //    alert('신용카드는 영수증 제공이 안됩니다.');
            //    return false;
            //}
            //if ($('#hdPrintOrderStaus').val() == '101') {
            //    alert('아직 입금전입니다.');
            //    return false;
            //}

            if ($('#hdBillNo').val() == '') {
                alert('세금명세서 확인이 불가한 거래 입니다.');
                return false;
            }
            var billNo = $('#hdBillNo').val();
            var MD5 = $('#hdMD5').val();

            var url = 'http://www.sendbill.co.kr/PreView?seq=' + billNo + "&cert=" + MD5 + "&VenderCheck=N&PR_DIV=R";

            var width = 700;
            var height = 800;
            var dualScreenLeft = window.screenLeft != undefined ? window.screenLeft : screen.left;
            var dualScreenTop = window.screenTop != undefined ? window.screenTop : screen.top;

            var getwidth = window.innerWidth ? window.innerWidth : document.documentElement.clientWidth ? document.documentElement.clientWidth : screen.width;
            var getheight = window.innerHeight ? window.innerHeight : document.documentElement.clientHeight ? document.documentElement.clientHeight : screen.height;

            var left = ((getwidth / 2) - (width / 2)) + dualScreenLeft;
            var top = ((getheight / 2) - (height / 2)) + dualScreenTop;

            window.open(url, '', "width=" + width + ",height=" + height + ",status=no ,toolbar=no,menubar=no,location=no,resizable=no,scrollbars=yes,left=" + left + ", top=" + top + "");
            //url, target, width, height, status, toolbar,  menubar, location, resizable, scrollbar
            // fnWindowOpen(url, '', 700, 800, 'yes', 'no', 'no', 'no', 'no', 'yes');

            //window.open(url, '', "height=" + height + ", width=" + width + ",status=yes,toolbar=no,menubar=no,location=no,resizable=no, scrollbars=yes,left=" + popupX + ", top=" + popupY + ", screenX=" + popupX + ", screenY= " + popupY + "");
            return false;
        }


        function fnzBillPopup() {

            //var width = 700;
            //var height = 800;
            //var popupX = (window.screen.width / 2) - (width / 2);
            //var popupY = (window.screen.height / 2) - (height / 2);

            //if ($('#hdPrintPayway').val() == '1') {
            //    alert('신용카드는 영수증 제공이 안됩니다.');
            //    return false;
            //}
            //if ($('#hdPrintOrderStaus').val() == '101') {
            //    alert('아직 입금전입니다.');
            //    return false;
            //}

            if ($('#hdzBillNo').val() == '') {
                alert('계산서명세서 확인이 불가한 거래 입니다.');
                return false;
            }


            var zbillNo = $('#hdzBillNo').val();
            var zMD5 = $('#hdzMD5').val();

            var url = 'http://www.sendbill.co.kr/PreView?seq=' + zbillNo + "&cert=" + zMD5 + "&VenderCheck=N&PR_DIV=R";

            var width = 700;
            var height = 800;
            var dualScreenLeft = window.screenLeft != undefined ? window.screenLeft : screen.left;
            var dualScreenTop = window.screenTop != undefined ? window.screenTop : screen.top;

            var getwidth = window.innerWidth ? window.innerWidth : document.documentElement.clientWidth ? document.documentElement.clientWidth : screen.width;
            var getheight = window.innerHeight ? window.innerHeight : document.documentElement.clientHeight ? document.documentElement.clientHeight : screen.height;

            var left = ((getwidth / 2) - (width / 2)) + dualScreenLeft;
            var top = ((getheight / 2) - (height / 2)) + dualScreenTop;

            window.open(url, '', "width=" + width + ",height=" + height + ",status=no ,toolbar=no,menubar=no,location=no,resizable=no,scrollbars=yes,left=" + left + ", top=" + top + "");

            //var url = 'http://www.sendbill.co.kr/PreView?seq=' + zbillNo + "&cert=" + zMD5 + "&VenderCheck=N&PR_DIV=R";
            //window.open(url, '', "height=" + height + ", width=" + width + ",status=yes,toolbar=no,menubar=no,location=no,resizable=no, scrollbars=yes,left=" + popupX + ", top=" + popupY + ", screenX=" + popupX + ", screenY= " + popupY + "");
            return false;
        }





        function fnDocumentBind() {
            var callback = function (response) {
                var newRowContent = '';

                $('#tblPopupDocument tbody').empty(); //테이블 클리어
                if (!isEmpty(response)) {
                    for (var i = 0; i < response.length; i++) {

                        newRowContent += "<tr>";
                        newRowContent += "<th>" + response[i].Map_Name + "";
                        newRowContent += "<input type= 'hidden' id='hdFileName' value= '" + response[i].Attach_P_Name + "' />";
                        newRowContent += "<input type= 'hidden' id='hdFilePath' value= '" + response[i].Attach_Path + "' />";
                        newRowContent += "</th>";
                        newRowContent += "<td style='width: 200px; text-align:center; ' ><a onclick='fnFileDownload(this); return false;' style='cursor: pointer; text-decoration:none; color:black; font-weight:bold;'>" + response[i].Attach_P_Name + "</a></td>"; //" 파일명
                        newRowContent += "</tr>";
                    }
                    $('#tblPopupDocument tbody').append(newRowContent);
                }
                else {
                    $('#tblPopupDocument tbody').append('<tr><td colspan="2" class="txt-center">조회된 데이터가 없습니다.</td></tr>');
                }

                return false;
            }

            var param = { SaleCompCode: $('#hdDocumentOrderSaleCompCode').val(), Flag: 'GetSaleCompanyDocumentInfo' };

            var beforeSend = function () { };
            var complete = function () { };

            JqueryAjax("Post", "../Handler/Admin/CompanyHandler.ashx", true, false, param, "json", callback, beforeSend, complete, true, '<%= Svid_User%>');

            <%--JajaxSessionCheck('Post', '../Handler/Admin/CompanyHandler.ashx', param, 'json', callback, '<%= Svid_User%>');--%>
        }

        function fnFileDownload(el) {

            var hdFilePath = $(el).parent().parent().find("input:hidden[id=hdFilePath]").val();
            var hdFileName = $(el).parent().parent().find("input:hidden[id=hdFileName]").val();
            window.location = 'FileDownload.aspx?FilePath=' + hdFilePath + '&FileName=' + hdFileName;
            return false;
        }

        //function fnPortFolio() {
        //    var status = "toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,width=420,height=540"
        //    var https = "https://"
        //    //var url = "pg.nicepay.co.kr/issue/IssueLoader.jsp?TID=" + tdPG_Tid + "&type=1";
        //    var url = https + "pg.nicepay.co.kr/issue/IssueLoader.jsp?TID=" + tdPG_Tid + "&type=0";
        //    alert(tdPG_Tid)
        //    window.open(url, "popupIssue", status);
        //}

        //팝업창 닫기
        function fnCancel() {
            $('.divpopup-layer-package').fadeOut();
        }
    </script>
</asp:Content>


<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div class="sub-contents-div">
        <!--제목 타이틀-->
            <div class="sub-title-div">
                <img src="/images/OrderHistoryList.png" />
               <%-- <p class="p-title-mainsentence">
                    주문내역조회
                       <span class="span-title-subsentence">주문하신 내역을 조회 할 수 있습니다.</span>
                </p>--%>
            </div>

            <!--상단 조회영역 시작-->
            <div class="search-div">

                <table class="tbl_search" id="tblHistoryList">

                    <thead>
                        <tr>
                            <th colspan="8">주문내역조회</th>
                        </tr>
                    </thead>

                    <tr >
                        <th colspan="2" class="border-right">구분(처리상태)</th>
                        <td colspan="2" class="border-right">
                            <asp:DropDownList runat="server" ID="ddlOrderStatus" CssClass="input-drop">
                            </asp:DropDownList>
                        </td>
                        <th colspan="2" class="border-right">결제수단</th>
                        <td colspan="2">
                            <asp:DropDownList runat="server" ID="ddlPayWay" CssClass="input-drop">
                            </asp:DropDownList>
                        </td>

                    </tr>
                    <tr>
                        <th colspan="2" class="border-right">조회기간</th>
                        <td colspan="6" class="align-left">

                            <asp:TextBox ID="txtSearchSdate" tpye="date" runat="server" CssClass="calendar" ReadOnly="true" Onkeypress="return fnEnter();"></asp:TextBox>&nbsp;&nbsp;
                            -
                            &nbsp;&nbsp;<asp:TextBox ID="txtSearchEdate" tpye="date" runat="server" CssClass="calendar" ReadOnly="true" Onkeypress="return fnEnter();"></asp:TextBox>&nbsp;&nbsp;
                            <input type="checkbox" style="margin-left:5px; vertical-align:middle;" id="ckbSearch1" value="1" checked="checked" /><label for="ckbSearch1">1일</label>
                            <input type="checkbox" style="margin-left:5px; vertical-align:middle;" id="ckbSearch2" value="7" /><label for="ckbSearch2">7일</label>
                            <input type="checkbox" style="margin-left:5px; vertical-align:middle;" id="ckbSearch3" value="15" /><label for="ckbSearch3">15일</label>
                            <input type="checkbox" style="margin-left:5px; vertical-align:middle;" id="ckbSearch4" value="30" /><label for="ckbSearch4">30일</label>
                            <input type="checkbox" style="margin-left:5px; vertical-align:middle;" id="ckbSearch5" value="90" /><label for="ckbSearch5">90일</label>
                        </td>
                    </tr>

                    <tr class="txt-center">
                        <th class="border-right">주문번호</th>
                        <td class="border-right">
                            <asp:TextBox ID="txtOrderNo" runat="server" CssClass="input-drop" Onkeypress="return fnEnter();"></asp:TextBox></td>
                        <th class="border-right">브랜드</th>
                        <td class="border-right">
                            <asp:TextBox ID="txtBrand" runat="server" CssClass="input-drop" Onkeypress="return fnEnter();"></asp:TextBox></td>
                        <th class="border-right">상품명</th>
                        <td class="border-right">
                            <asp:TextBox ID="txtGoodsName" runat="server" CssClass="input-drop" Onkeypress="return fnEnter();"></asp:TextBox></td>
                        <th class="border-right">상품코드</th>
                        <td>
                            <asp:TextBox ID="txtGoodsCode" runat="server" CssClass="input-drop" Onkeypress="return fnEnter();"></asp:TextBox></td>
                    </tr>
                </table>
                <div style="border-left: 1px solid #a2a2a2; border-right: 1px solid #a2a2a2; border-bottom: 1px solid #a2a2a2; text-align:center">
                    <img src="/Images/deliverynam.jpg"/>
                </div>

                <!--조회하기 버튼-->
                <div class="bt-align-div">
                    <input type="button" class="mainbtn type1" style="width: 117px; height: 30px; margin-right:-2px; font-size: 12px" value="초기화" onclick="fnInitState(); return false;" />
                    <%-- <img alt="초기화" src="../Images/Member/reset-off.jpg" onclick="fnInitState(); return false;" onmouseover="this.src='../Images/Member/reset-on.jpg'" onmouseout="this.src='../Images/Member/reset-off.jpg'"/>--%>
                    <%--<a><img alt="조회하기" src="../Images/Goods/aslist.jpg" id="btnSearch" onclick="fnSearch(1); return false;" onmouseover="this.src='../Images/Wish/aslist-over.jpg'" onmouseout="this.src='../Images/Goods/aslist.jpg'" /></a>--%>
                    <input type="button" id="btnSearch" class="mainbtn type1" style="width: 117px; height: 30px; font-size: 12px" value="조회하기" onclick="fnSearch(1); return false;" />
                </div>

            </div>

            <span style="color: #69686d; float: right; margin-top: 10px; margin-bottom: 10px;">*<b style="color: #ee2248; font-weight: bold;"> VAT(부가세)포함 가격</b>입니다.</span>
            <!--상단 조회영역 끝-->


            <!--하단 리시트영역 시작-->
            <div class="list-div" style="width: 100%;">
                <table id="tblSearch"  class="tbl_main tbl_main2">
                    <thead>
                        <tr>
                            <th style="width: 70px;" rowspan="2" class="border-right">번호</th>
                            <th style="width: 110px;" class="border-right">주문일자</th>
                            <th style="width: 105px;" class="border-right">판매사</th>
                            <th style="width: 275px;" rowspan="2" class="border-right">주문상품정보</th>
                            <th style="width: 80px;" rowspan="2" class="border-right">모델명</th>
                            <th style="width: 80px;" rowspan="2" class="border-right">내용량</th>
                            <th style="width: 80px;" rowspan="2" class="border-right">주문수량</th>
                            <th style="width: 83px;" rowspan="2" class="border-right">주문금액</th>
                            <th style="width: 72px;" class="budget-view border-right">예산부서</th>
                            <th style="width: 96px;" class="border-right">출고예정일</th>
                            <th style="width: 85px;" rowspan="2" class="border-right">주문처리<br />
                                현황</th>
                            <th style="width: 85px;" rowspan="2" class="border-right">결제수단
                            </th>
                            <th rowspan="2" style="width: 88px;" class="border-right">판매사<br />
                                증빙서류</th>
                            <th rowspan="2" style="width: 90px;">주문취소</th>
                        </tr>
                        <tr>
                            <th class="border-right">주문번호</th>
                            <th id="thHeaderName" class="border-right">주문자</th>
                            <th class="budget-view border-right">예산계정</th>
                            <th class="border-right">배송완료일</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td colspan="20" class="txt-center">주문내역을 조회해 주시기 바랍니다.</td>
                        </tr>
                    </tbody>
                </table>
                <br />
                <input type="hidden" id="hdTotalCount" />
                <!-- 페이징 처리 -->
                <div style="margin: 0 auto; text-align: center">
                    <div id="pagination" class="page_curl"></div>
                </div>
            </div>
            <!--하단 리스트 영역 끝 -->

            <!--상세내역엑셀저장버튼-->
            <div class="bt-align-div">
                <asp:ImageButton ID="btnOrdHistoryExcel" runat="server" Visible="false" OnClick="btnOrdHistoryExcel_Click" AlternateText="엑셀저장" ImageUrl="../Images/Order/detail-excel.jpg" onmouseover="this.src='../Images/Order/detail-excel-on.jpg'" onmouseout="this.src='../Images/Order/detail-excel.jpg'" />

            </div>
         <div class="left-menu-wrap" id="divLeftMenu">
        <dl>
            <dt style="border-bottom:1px solid #eaeaea;">
                <strong>마이페이지</strong>
            </dt>
            <dd   class="active">
                <a href="/Order/OrderHistoryList.aspx">주문조회</a> 
            </dd>
            <dd>
                <a href="/Delivery/DeliveryOrderList.aspx">배송조회</a> 
            </dd>
            <dd>
                <a href="/Order/OrderBillIssue.aspx">세금계산서 조회</a> 
            </dd>
            <dd>
                <a href="/Member/MemberEditCheck.aspx">마이정보변경</a> 
            </dd>
            <dd>
                <a href="/Delivery/DeliveryList.aspx">배송지관리</a> 
            </dd>
        </dl>
    </div>
    </div>


   


    <!-- DIV팝업창(주문상품) 시작 -->
    <div id="productDiv" class="popupdiv divpopup-layer-package">

        <div class="popupdivWrapper" style="width:85%; height: 800px; margin: 50px auto;">
            <div class="popupdivContents" style="border: none;">
                <div class="sub-title-div">
                    <div class="close-div"><a onclick="fnCancel()" style="cursor: pointer">
                        <img src="../../Images/Wish/icon-delete.jpg" alt="닫기" style="float: right;" /></a></div>
                        <h3>주문상품</h3>
                </div>
                <span style="color: #69686d; float: right; margin-bottom: 10px;">*<b style="color: #ee2248; font-weight: bold;"> VAT(부가세)포함 가격</b>입니다.</span>

                <div style="height: 217px; width: 100%; overflow-y: auto; overflow-x: hidden;">

                    <table id="tblOrder">
                        <thead>
                            <tr>
                                <th>이미지</th>
                                <th>상품코드</th>
                                <th>상품정보</th>
                                <th>모델명</th>
                                <th>출고예정일</th>
                                <th>최소수량</th>
                                <th>내용량</th>
                                <th>상품가격</th>
                                <th>주문수량</th>
                                <th>판매사</th>
                                <th>결제방식</th>
                                <th>구매가격</th>
                            </tr>
                        </thead>
                        <tbody id="tbody_pop_odrDtl"></tbody>
                    </table>
                </div>
                <br />
                <%--<div>결제내용</div>--%>

                <!-- Left Table -->
                <div id="divDtlPop_1">
                    <label style="margin-top: 350px; display: inline; float: left; width: 500px; z-index: 1; position: fixed" id="lblText"></label>
                    <table id="tbl_dtlPop_pay" style="z-index: 2;"></table>


                    <%--  </div>--%>
                    <!-- Left Table -->
                    <input type="hidden" id="hdDocumentOrderSaleCompCode" />
                    <asp:HiddenField runat="server" ID="hfDocumentPath" />
                    <asp:HiddenField runat="server" ID="hfDocumentFileName" />
                    <div style="height: 132px; overflow-y: auto; overflow-x: hidden;">
                        <table id="tblPopupDocument" style="width: 483px;">
                            <thead>
                                <tr>
                                    <th colspan="2" class="txt-center">문서출력</th>
                                </tr>
                            </thead>
                            <tbody>
                            </tbody>
                        </table>

                    </div>
                    <table id="printDocument">
                        <tr>
                            <th colspan="5">결제관리 서류출력</th>
                        </tr>

                        <tr>
                            <th>거래명세서</th>
                            <td>
                                <a id="aDocStat_1" onclick="fnStatementPopup('11'); return false;" class='orderPrinticonBtn' style="width: 284px; height: 22px">
                                    <img src="../Images/Button/icon-down.png" />거래 명세서</a>
                                <%--<a id="aDocStat_2" onclick="fnStatementPopup('21'); return false;"  class='orderPrinticonBtn' style="display: none; width:139px; height:22px"><img src="../Images/Button/icon-down.png"/>거래 명세서 1</a>
                                 <a id="aDocStat_3" onclick="fnStatementPopup('22'); return false;"  class='orderPrinticonBtn' style="display: none; width:139px; height:22px"><img src="../Images/Button/icon-down.png"/>거래 명세서 2</a>--%>

                                <%--<a id="aDocStat_1"><img src="../Images/Order/document1-off.jpg" alt="거래명세서" onclick="fnStatementPopup('11'); return false;" /></a>
                                <a id="aDocStat_2" style="display: none;"><img src="../Images/Order/docu1-off.jpg" alt="거래명세서 1" onclick="fnStatementPopup('21'); return false;" /></a>
                                <a id="aDocStat_3" style="display: none;"><img src="../Images/Order/docu2-off.jpg" alt="거래명세서 2" onclick="fnStatementPopup('22'); return false;" /></a>--%>

                                <input type="hidden" id="hdPrintOrderCodeNo" />
                                <input type="hidden" id="hdPrintOrderStaus" />
                                <input type="hidden" id="hdPrintSvidUser" />
                                <input type="hidden" id="hdPrintTaxYn" />
                                <input type="hidden" id="hdBillNo" />
                                <input type="hidden" id="hdMD5" />
                                <input type="hidden" id="hdzBillNo" />
                                <input type="hidden" id="hdzMD5" />
                            </td>
                        </tr>
                        <tr>
                            <th>납품확인서</th>
                            <td>
                                <%--<a>
                                <img src="../Images/Order/document2-off.jpg" alt="납품확인서" onclick="fnDeliveryConfirmPrintPopup(); return false;" />
                                </a>--%>
                                <a onclick="fnDeliveryConfirmPrintPopup(); return false;" class='orderPrinticonBtn' style="width: 284px; height: 22px">
                                    <img src="../Images/Button/icon-down.png" />납품 확인서</a>
                            </td>

                        </tr>
                        <tr style="display: none">
                            <th>출고명세서</th>
                            <td>
                                <%--<a>
                                <img src="../Images/Order/document2-off.jpg" alt="납품확인서" onclick="fnDeliveryConfirmPrintPopup(); return false;" />
                                <img src="" alt="납품증명서" onclick="fnDeliveryConfirmPrintPopup(); return false;" />

                                </a>--%>
                                <a onclick="fnDeliveryStatementPopup(); return false;" class='orderPrinticonBtn' style="width: 284px; height: 22px">
                                    <img src="../Images/Button/icon-down.png" />출고 명세서</a>

                            </td>

                        </tr>
                        <tr>
                            <th>카드명세표</th>
                            <td>
                                <%--<a>
                                    <img src="../Images/Order/document3-off.jpg" alt="카드명세표" onclick="fnPortFolio()" />
                                    <img src="" alt="카드명세표" onclick="fnPortFolio()" />

                                </a>--%>
                                <a onclick="fnPortFolio(); return false;" class='orderPrinticonBtn' style="width: 284px; height: 22px">
                                    <img src="../Images/Button/icon-down.png" />카드 명세표</a>
                            </td>
                        </tr>
                        <tr>
                            <th>영수증</th>
                            <td>
                                <input type="hidden" id="hdPrintPayway" />
                                <%--<a>
                                
                                <img src="../Images/Order/document4-off.jpg" alt="영수증" onclick="fnReceiptPopup(); return false;" />

                                 <img src="" alt="영수증" onclick="fnReceiptPopup(); return false;" />

                                </a>--%>
                                <a onclick="fnReceiptPopup(); return false;" class='orderPrinticonBtn' style="width: 284px; height: 22px">
                                    <img src="../Images/Button/icon-down.png" />영수증 출력</a>
                            </td>
                        </tr>
                        <tr style="display: none" id="trTaxinvoice_1">
                            <th>세금계산서</th>
                            <td>

                                <%--<a>
                                    <img src="../Images/Order/document5_1-off.jpg" alt="세금명세서" id="imgTaxInvoice_1" onclick="fnBillPopup(); return false;" />
                                </a>--%>
                                <a onclick="fnBillPopup(); return false;" id="imgTaxInvoice_1" class='orderPrinticonBtn' style="width: 284px; height: 22px">
                                    <img src="../Images/Button/icon-down.png" />세금명세서 요청</a>
                            </td>
                        </tr>
                        <tr style="display: none" id="trTaxinvoice_2">
                            <th>세금계산서</th>
                            <td>

                                <%--<a>
                                    <img src="../Images/Order/document6_1-off.jpg" alt="계산서명세서" id="imgTaxInvoice_2" onclick="fnzBillPopup(); return false;" />
                                </a>--%>
                                <a onclick="fnzBillPopup(); return false;" id="imgTaxInvoice_2" class='orderPrinticonBtn' style="width: 284px; height: 22px">
                                    <img src="../Images/Button/icon-down.png" />계산서</a>
                            </td>
                        </tr>
                        <tr style="display: none" id="trTaxinvoice_3">
                            <th>세금계산서</th>
                            <td>
                                <%--<a>
                                    <img src="../Images/Order/document5_2-off.jpg" alt="세금명세서" id="imgTaxInvoice_3"  onclick="fnBillPopup(); return false;"/>
                                </a>
                                <a>
                                    <img src="../Images/Order/document6_2-off.jpg" alt="계산서명세서" id="taxInvoice_1" onclick="fnzBillPopup(); return false;"/>
                                </a>--%>
                                <a onclick="fnBillPopup(); return false;" id="imgTaxInvoice_3" class='orderPrinticonBtn' style="width: 139px; height: 22px">
                                    <img src="../Images/Button/icon-down.png" />세금 계산서</a>
                                <a onclick="fnzBillPopup(); return false;" id="taxInvoice_1" class='orderPrinticonBtn' style="width: 139px; height: 22px">
                                    <img src="../Images/Button/icon-down.png" />계산서</a>
                            </td>
                        </tr>

                    </table>
                </div>
                <br />
                <div style="float: right;" id="divBtn">
                    <span id="spanBtn"></span>
                    <input type="hidden" id="hdPopupGoodsCode" />
                    <%-- <a onclick="fnCancel('divPopup')">확인</a>--%>
                    <input type="button" id="btnTab1" class="mainbtn type1" style="width: 95px; height: 30px; font-size: 12px" value="확인" onclick="fnCancel('divPopup')" />
                    <%-- <a>
                        <img src="../Images/Goods/sub-off.jpg" alt="확인" onclick="fnCancel('divPopup')" onmouseover="this.src='../Images/Goods/sub-on.jpg'" onmouseout="this.src='../Images/Goods/sub-off.jpg'" /></a>--%>

                    <%--<a onclick="fnSubmit(); return false;">확인</a>--%>
                </div>
            </div>
        </div>
    </div>
    <!-- DIV팝업창(주문상세) 끝 -->

</asp:Content>
