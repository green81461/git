<%@ Page Language="C#" AutoEventWireup="true" CodeFile="OrderNoPassbookResult.aspx.cs" Inherits="Order_OrderNoPassbookResult" %>

<!DOCTYPE html>

<html style="overflow-y: hidden">
<head>
    <title>무통장입금 주문 결과 확인</title>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=yes, target-densitydpi=medium-dpi" />

    <link href="../Content/Order/order.css" rel="stylesheet" />
    <link rel="stylesheet" type="text/css" href="../Content/jquery-ui.css" />

    <script type="text/javascript" src="https://web.nicepay.co.kr/flex/js/nicepay_tr_utf.js"></script>
    <script type="text/javascript" src="../Scripts/jquery-1.10.2.min.js"></script>
    <script type="text/javascript" src="../Scripts/jquery-ui.min.js"></script>
    <script type="text/javascript" src="../Scripts/jquery.inputmask.bundle.js"></script>
    <script type="text/javascript" src="../Scripts/common.js"></script>

    <style>
        .commonBtn {
            text-decoration: none;
            font-family: Dotum;
            line-height: 30px;
            text-align: center;
            vertical-align: middle;
            display: inline-block;
            color: #ffffff;
            padding: 0px;
            background-color: #69696b;
            font-weight: 600;
            border: none;
        }
        .commonBtn:active {
            /*position: relative;
            top: 3px*/
        }
        .commonBtn:hover {
            background-color: #ec2029;
            color: #ffffff;
            text-decoration: none;
        }

    </style>
    <script>
        var closeFlag = false;
        var is_sending = false;

        $(document).ready(function () {

            $("#txtBillDate").inputmask("9999-99-99");

            $("#txtBillDate").datepicker({
                minDate: 0,                  //최소 선택 가능 일자 오늘 부터.
                maxDate: "60D",              //최대 선택 가능 일자 오늘부터 +30일
                showAnimation: 'slideDown',
                changeMonth: true,
                changeYear: true,
                dateFormat: "yy-mm-dd",
                monthNamesShort: ["1월", "2월", "3월", "4월", "5월", "6월", "7월", "8월", "9월", "10월", "11월", "12월"],
                dayNamesMin: ["일", "월", "화", "수", "목", "금", "토"],
                showMonthAfterYear: true
            });
        });

        $(document).on("keydown", function (e) {
            if (e.keyCode == 116) {
                closeFlag = true;
            }
        });

        window.onbeforeunload = function (event) {
            if (!closeFlag) {
                fnWinClose();
            }
        };
        
        function fnReSizeWindow() {
            window.resizeTo(640, 715);
        }

        function fnWinClose() {
            closeFlag = true;

            alert("성공적으로 결제가 완료되었습니다.");

            opener.location.replace("Ordersuccess.aspx");
            self.close();
        }
        
        function fnOrderFinish() {
            
            if ($("tr[id^='trBill']").css("display") != "none") {

                var billEmail = $.trim($("#txtBillEmail").val());

                if (billEmail.match('@') == '@') {

                    var callback = function (response) {

                        if (!isEmpty(response)) {

                            fnWinClose();
                        }
                        else {
                            alert("세금계산서 발행일 수정에 실패하였습니다. 관리자에게 문의하시기 바랍니다.");

                            return false;
                        }
                    };

                    var sUser = '<%=Svid_User %>';
                    var ordCodeNo = $("#hdOrdCodeNo").val();
                    var billSelectDate = $("#txtBillDate").val();

                    var param = { Svid_User: sUser, OdrCodeNo: ordCodeNo, BillSelectDate: billSelectDate, BillEmail: billEmail, Method: "OrderBillCheck" };

                    var beforeSend = function () {
                        is_sending = true;
                    }
                    var complete = function () {
                        is_sending = false;
                    }
                    if (is_sending) return false;

                    JqueryAjax('Post', '../Handler/PayHandler.ashx', true, false, param, 'text', callback, beforeSend, complete, true, sUser);

                } else {
                    alert("세금계산서 Email 정보가 올바르지 않습니다. 다시 입력해 주세요.");
                    return false;
                }
                
            } else {
                fnWinClose();
            }
        }
        
        //인쇄
        function fnOrderResultPop() {
            var SaveAuthDate = $('#hdSubjectDate').val();
            var PayMethod = "무통장입금";
            var Moid = $('#hdOrdCodeNo').val();
            var GoodsName = $('#hdGoodsName').val();
            var Amt = $('#hdAmt').val();
            var bankName = $('#hdBankName').val();
            var bankNum = $('#hdBankNo').val();
            //var VBANKDATE = $('#hdVBANKDATE').val();
            var BuyerName = $('#hdBuyerName').val();
            var SaleComName = $('#hdSaleComName').val();

            var url = '../../Print/OrderResultPrint?SaveAuthDate=' + SaveAuthDate + '&PayMethod=' + PayMethod + '&SaleComName=' + SaleComName + ' &BuyerName=' + BuyerName + ' &Moid=' + Moid + ' &GoodsName=' + GoodsName + ' &Amt=' + Amt + ' &VbankName=' + bankName + ' &VbankNum=' + bankNum + ' &VBANKDATE=';
            fnWindowOpen(url, '', 800, 500, 'yes', 'no', 'no', 'no', 'yes', 'yes');


            //  window.open(url, '', "height=500, width=800,status=yes,toolbar=no,menubar=no,location=no,resizable=no");
        }

        //세금계산서 수정 view
        function fnBillDisplay() {
            if ($("tr[id^='trBill']").css("display") == "none") {
                $("tr[id^='trBill']").css("display", "");
                $("#btnBill").val("세금계산서 발행일 취소");

            } else {
                $("tr[id^='trBill']").find("input:text[id^='txtBill']").val("");
                $("tr[id^='trBill']").css("display", "none");
                $("#btnBill").val("세금계산서 발행일 수정");
            }
            
            return false;
        }
    </script>
</head>
<body onload="javascript:fnReSizeWindow();">
<form id="payNoBookResultForm" runat="server">
    <div class="payfin_area">
        <div class="orderR-title-div">
            <img src="../Images/Order/orderR-title1.jpg" alt="결제 결과" />
            <div style="width: 600px; float: right; height: 30px;">
                <a id="btnPrint" onclick="fnOrderResultPop()"><img src="../Images/Order/print.jpg" alt="인쇄" style="float: right;" /></a>
            </div>
            <br /><br />
            <table class="orderRqs-table">
                <tr>
                    <th style="width:170px;" class="auto-style2"><span>결과내용</span></th>
                    <td class="auto-style3" style="font-size:14px;">주문 성공</td>
                </tr>
                <tr>
                    <th style="width:170px;" class="auto-style2"><span>결제수단</span></th>
                    <td class="auto-style3">
                        <span style="font-weight:normal">무통장입금</span>
                        <input type="hidden" name="hdOrdCodeNo" id="hdOrdCodeNo" value="<%=OrderCodeNo %>" />
                        <input type="hidden" id="hdBuyerName" value="<%=BuyerName %>" />
                        <input type="hidden" id="hdGoodsName" value="<%=GoodsName %>" />
                        <input type="hidden" name="hdPayway" id="hdPayway" value="<%=Payway %>" />
                        <input type="hidden" name="hdSubjectDate" id="hdSubjectDate" value="<%=SubjectDate %>" />
                        <input type="hidden" id="hdSaleComName" value="<%=SaleComName %>" />
                    </td>
                </tr>
                <tr>
                    <th>주문번호</th>
                    <td>
                        <span style="font-weight:normal"><%=OrderCodeNo%></span>
                    </td>
                </tr>
                <tr>
                    <th><span>상품명</span></th>
                    <td>
                        <span style="font-weight:normal"><%=GoodsName%></span>
                    </td>
                </tr>
                <tr>
                    <th><span>금액</span></th>
                    <td>
                        <span style="font-weight:normal"><%=String.Format("{0:##,##0;}", Amt) %></span><span style="font-weight:normal">원</span>
                        <input type="hidden" name="hdAmt" id="hdAmt" value="<%=Amt %>" />
                    </td>
                </tr>
                <tr>
                    <th class="auto-style1"><span>구매자명</span></th>
                    <td class="auto-style1">
                        <span style="font-weight:normal"><%=BuyerName %></span>
                    </td>
                </tr>
                <tr>
                    <th class="auto-style1"><span>연락처</span></th>
                    <td class="auto-style1">
                        <span style="font-weight:normal"><%=BuyerTel %></span>
                    </td>
                </tr>
                <tr>
                    <th class="auto-style1"><span>이메일</span></th>
                    <td class="auto-style1">
                        <span style="font-weight:normal"><%=BuyerEmail %></span>
                    </td>
                </tr>
                <tr id="trBillDate" style="display:none">
                    <th class="auto-style1"><span>세금계산서 일자(요청)</span></th>
                    <td>
                        <input type="text" id="txtBillDate" name="txtBillDate" style="width: 110px; height:22px; border:1px solid #a2a2a2; padding-left:5px;" maxlength="10" placeholder="클릭하세요" size="30" />
                    </td>
                </tr>
                <tr id="trBillEmail" style="display:none">
                    <th class="auto-style1"><span>세금계산서 Email(요청)</span></th>
                    <td><input type="text" id="txtBillEmail" name="txtBillEmail" style="width: 250px; height:22px; border:1px solid #a2a2a2; padding-left:5px;" placeholder="입력하세요" value="" /></td>
                </tr>

                <tr style="background-color: aliceblue; height:150px;">
                    <td style="color: white; background-color: slategrey; font-size: 20px;" colspan="2"><span style="font-size: 12px; display: block; text-align: center"></span>
                        <input type="hidden" name="hdBankNo" id="hdBankNo" value="21903349001051" />
                        <input type="hidden" name="hdBankTypeName" id="hdBankTypeName" value="(주)동신툴피아" />
                        <input type="hidden" name="hdBankName" id="hdBankName" value="기업은행" />
                        <input type="hidden" name="hdBankCode" id="hdBankCode" value="3" />

                        <span>입금은행 : <span style="color: white; font-size: 25px; text-align: left;">기업은행 (주)동신툴피아</span></span><br />
                        <span>입금계좌 : <span style="color: white; font-size: 25px; text-align: left;">219-033490-01-051</span></span>
                    </td>
                </tr>
            </table>
            <br />

            <!--완료하기 버튼-->
            <div class="orderRqs-bt-align1">
                <input type="button" class="commonBtn" style="width:170px; height:30px; font-size:12px" id="btnBill" value="세금계산서 발행일 수정" onclick="return fnBillDisplay();"/>
                <input type="button" class="commonBtn" style="width:95px; height:30px; font-size:12px" value="완료하기" onclick="fnOrderFinish()"/>
            </div>
        </div>
    </div>
</form>
</body>
</html>
