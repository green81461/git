<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Loan_OrderResult.aspx.cs" Inherits="Order_Loan_OrderResult" %>

<!DOCTYPE html>

<html>
<head runat="server">
    <meta charset="utf-8">
    <link rel="stylesheet" type="text/css" href="../Content/jquery-ui.css" />
    <link href="../Content/Order/order.css" rel="stylesheet" />

    <script type="text/javascript" src="../Scripts/jquery-1.10.2.min.js"></script>
    <script type="text/javascript" src="../Scripts/jquery-ui.min.js"></script>
    <script type="text/javascript" src="../Scripts/common.js"></script>

    <title>주문완료</title>

    <script type="text/javascript">

        //출력하기 버튼 Visible 처리
        $(document).ready(function () {

            var ResultCode = $("input[name='loan_ResultCode']").val();
            if (ResultCode == '3001' || ResultCode == '4000' || ResultCode == 'A000' || ResultCode == '4100' || ResultCode == '0000' || ResultCode == '4120') {


                $("#spSuccessPay").css("display", "");
                $("#spFailPay").css("display", "none");
            }
            else {
                $("#tblSuccess").css("display", "none");

                $("#spSuccessPay").css("display", "none");
                $("#spFailPay").css("display", "");

            }

            var accNum = $("input[name='BulkBankNo']").val();

            $('#AccountNumber').text(accNum); //입금 계좌명 span 값에 저장.


            var ResultCode = $("input[name='loan_ResultCode']").val();
            if (ResultCode == '4120') {
                $('#Show_resultMsg').val('주문 등록이 완료되었습니다.');
            }
            else {
                $('#Show_resultMsg').val('주문 등록에 실패했습니다. 관리자에게 문의해주세요.');
            }


            $("#billDate").datepicker({
                minDate: 0,                  //최소 선택 가능 일자 오늘 부터.  
                maxDate: "30D",              //최대 선택 가능 일자 오늘부터 +30일  
                showAnimation: 'slideDown',
                changeMonth: true,
                changeYear: true,
                dateFormat: "yy-mm-dd",
                monthNamesShort: ["1월", "2월", "3월", "4월", "5월", "6월", "7월", "8월", "9월", "10월", "11월", "12월"],
                dayNamesMin: ["일", "월", "화", "수", "목", "금", "토"],
                showMonthAfterYear: true
            });


            var buyPrice = $("input[name='loan_Amt']").val();
            $("#hdAmt").val(numberWithCommas(buyPrice));
            $("#loan_Amt").val(numberWithCommas(buyPrice));

            var chkPayWay = $("input[name='hdPayway']").val();

            if (chkPayWay == '3' || chkPayWay == '4' || chkPayWay == '9') {
                $("#btnPrint").css("display", "");
                $("#btnBill").css("display", "");


            }
            else {
                $("#btnPrint").css("display", "none");
                $("#btnBill").css("display", "none");
            }
        });

        function closepopup() {


            var ResultCode = $("input[name='loan_ResultCode']").val();
            if (ResultCode == '3001' || ResultCode == '4000' || ResultCode == 'A000' || ResultCode == '4100' || ResultCode == '0000' || ResultCode == '4120') {
                // alert('결제가 완료 되었습니다.');
                //opener.parent.location.replace("Ordersuccess.aspx");
                opener.location.replace("Ordersuccess.aspx");
                self.close();
            }
            else {

                //alert("결제 요청 실패");
                self.close();
            }

        }

        function fnclick() {
            fnbillCheck();

        }

        function fnbillCheck() {

            var billEmail = $("input[name='billEmail']").val();
            if (billEmail.match('@') == '@') {

                var callback = function (response) {

                    if (!isEmpty(response)) {

                        closepopup();
                    }
                    else {

                    }
                    return false;
                };

                var sUser = $("input[name='svid_user']").val();
                var ordCodeNo = $("input[name='loan_Moid']").val();
                var billSelectDate = $("input[name='billDate']").val();
                var billEmail = $("input[name='billEmail']").val();
                var param = { Svid_User: sUser, OdrCodeNo: ordCodeNo, BillSelectDate: billSelectDate, BillEmail: billEmail, Method: "OrderBillCheck" };
                JajaxSessionCheck("Post", "../Handler/PayHandler.ashx", param, "text", callback, true, '<%= Svid_User %>');

            }
            else {
                alert('올바른 이메일 주소가 아닙니다.')
                return false;
            }
        }


        function fnBill() {

            $("#trBillDate").css("display", "");
            $("#trBillEmail").css("display", "");

            $("#onBill").css("display", "");
            $("#noBill").css("display", "none");

        }

        //주문내역 출력 페이지 이동.
        function fnOrderResultPop() {

            var SaveAuthDate = $('#hdSaveAuthDate').val();
            var PayMethod = $('#hdPayMethod').val();
            var Moid = $('#hdMoid').val();
            var GoodsName = $('#hdGoodsName').val();
            var Amt = $('#hdAmt').val();
            var VbankName = $('#hdVbankName').val();
            var VbankNum = $('#hdVbankNum').val();
            var VBANKDATE = $('#hdVBANKDATE').val();
            var BuyerName = $('#hdBuyerName').val();
            var SaleComName = $('#hdSaleComName').val();
            alert(VBANKDATE)

            var url = '../../Print/OrderResultPrint?SaveAuthDate=' + SaveAuthDate + '&PayMethod=' + PayMethod + '&SaleComName=' + SaleComName + ' &BuyerName=' + BuyerName + ' &Moid=' + Moid + ' &GoodsName=' + GoodsName + ' &Amt=' + Amt + ' &VbankName=' + VbankName + ' &VbankNum=' + VbankNum + ' &VBANKDATE=' + VBANKDATE + '';
            fnWindowOpen(url, '', 800, 500, 'yes', 'no', 'no', 'no', 'yes', 'yes');


            //  window.open(url, '', "height=500, width=800,status=yes,toolbar=no,menubar=no,location=no,resizable=no");
        }

    </script>





    <style type="text/css">
        .auto-style1 {
            height: 30px;
        }
    </style>
</head>
<body>
    <div class="payfin_area">
        <div class="orderR-title-div">
            <div style="text-align: left; height: 30px;">

                <img src="../Images/Order/orderPop1-title.jpg" alt="우리안 로고" />
                <%--                    <br />
                        <span id="spSuccessPay" style="font-size: 20px; font-weight: bolder; color:#AB4A12;">결제가 정상적으로 처리되었습니다.</span>
                <span id="spFailPay" style="font-size: 20px; font-weight: bolder;color:#AB4A12;">결제가 정상적으로 처리되지 않았습니다.</span>--%>
            </div>
            <%--    <br />--%>
            <div style="width: 600px; float: right; height: 30px;">
                <a id="btnPrint" onclick="fnOrderResultPop()">
                    <img src="../Images/Order/print.jpg" alt="인쇄" style="float: right;" /></a>

            </div>

            <%--  <div style="width: 600px; float: right; height: 30px;">
            </div>--%>


            <table class="orderRqs-table">
                <tr>
                    <th style="width: 30%;">결과내용</th>
                    <td>
                        <input type="text" name="Show_resultMsg" id="Show_resultMsg" style="width: 100%" value="" />
                        <input type="hidden" name="loan_ResultCode" style="width: 50px" value="<%=loan_ResultCode%>" />
                        <input type="hidden" name="loan_ResultMsg" style="text-align: left; width: 300px" value="<%=loan_ResultMsg%>" />

                    </td>
                </tr>
                <tr>
                    <th class="auto-style2"><span>결제수단</span></th>
                    <td class="auto-style3">
                        <input type="hidden" name="loan_payMethod" style="width: 100%" value="<%=loan_payMethod%>" />
                        <input type="text" name="loan_PayWayResult" style="width: 100%" readonly value="<%=loan_PayWayResult%>" />


                    </td>
                </tr>
                <tr>
                    <th><span>상품명</span></th>
                    <td>
                        <input type="text" name="loan_goodsName" style="width: 100%" readonly value="<%=loan_goodsName%>" />
                    </td>
                </tr>
                <tr>
                    <th><span>금액</span></th>
                    <td>
                        <input type="text" name="loan_Amt" id="loan_Amt" style="width: 100%" readonly value="<%=loan_Amt%> 원" />
                    </td>

                </tr>

                <tr>
                    <th>주문번호</th>
                    <td>
                        <input type="text" name="loan_Moid" style="width: 100%" readonly value="<%=loan_Moid%>" />
                        <input type="hidden" name="BulkBankNo" value="<%=BulkBankNo%>" />
                    </td>



                </tr>
                <%--<tr>
                    <th>입금계좌번호</th>
                    <td>
                        <input type="text" name="BulkBankNo" readonly style="width: 60px" value="신한은행" />
                        <input type="text" name="BulkBankNo" readonly value="<%=BulkBankNo%>" />
                    </td>
                </tr>--%>
                <tr>
                    <th class="auto-style1"><span>구매자명</span></th>
                    <td class="auto-style1">
                        <input type="text" name="loan_buyerName" style="width: 100%" readonly value="<%=loan_buyerName%>" />
                        <input type="hidden" id="hdPayway" name="hdPayway" value="<%=chkPayway%>" />



                        <%--출력하기 전용--%>
                        <input type="hidden" id="hdSaveAuthDate" name="hdSaveAuthDate" value="<%=loan_SaveAuthDate%>" />
                        <%--승인날짜--%>
                        <input type="hidden" id="hdPayMethod" name="hdPayMethod" value="<%=loan_PayWayResult%>" />
                        <%--결제유형--%>
                        <input type="hidden" id="hdMoid" name="hdMoid" value="<%=loan_Moid%>" />
                        <%--주문번호--%>
                        <input type="hidden" id="hdGoodsName" name="hdGoodsName" value="<%=loan_goodsName%>" />
                        <%--상품명--%>
                        <input type="hidden" id="hdAmt" name="hdAmt" value="<%=loan_Amt%>" />
                        <%--금액--%>
                        <input type="hidden" id="hdVbankName" name="hdVbankName" value="신한은행" />
                        <%--가상계좌 은행명--%>
                        <input type="hidden" id="hdVbankNum" name="hdVbankNum" value="<%=BulkBankNo%>" />
                        <%--가상계좌 번호--%>
                        <input type="hidden" id="hdVBANKDATE" name="hdVBANKDATE" value="<%=loan_VbankDate%>" />
                        <%--가상계좌 입금 만료일--%>
                        <input type="hidden" id="hdBuyerName" name="hdBuyerName" value="<%=loan_buyerName%>" />
                        <%--구매자명--%>
                        <input type="hidden" id="hdSaleComName" name="hdSaleComName" value="<%=loan_SaleComName%>" />
                        <%--판매사명--%>

                        <input type="hidden" id="svid_user" name="svid_user" value="<%=Svid_User%>" />
                        <%--svidUser--%>


                    </td>
                </tr>
                <tr id="trBillDate" style="display: none">
                    <th class="auto-style1"><span>세금계산서 일자(요청)</span></th>
                    <td>
                        <input type="text" id="billDate" name="billDate" placeholder="클릭하세요" size="30" />
                    </td>
                </tr>

                <tr id="trBillEmail" style="display: none">
                    <th class="auto-style1"><span>세금계산서 Email(요청)</span></th>
                    <td>
                        <input type="text" id="billEmail" name="billEmail" style="width: 200px" value="" /></td>
                </tr>

                <%-- <tr style="background-color: aliceblue;">
                    <td style="color: white; background-color: slategrey; font-size: 20px;" colspan="2" rowspan="1"><span style="font-size: 12px; display: block; text-align: center"></span>

                        <br />
                        입금계좌 : 신한은행 <span id="AccountNumber" style="color: white; font-size: 25px; text-align: left;"></span>
                        <br />
                        <br />

                    </td>

                </tr>--%>
            </table>
            <p></p>
            <table class="orderRqs-table2" id="tblSuccess">
                <tr style="height: 50px;">
                    <th style="font-size: 20px; color: black;" class="auto-style6">입금 계좌명 : 신한은행(<%=loan_SaleComName%>)
                        <br />
                        <span id="AccountNumber" style="color: black; font-size: 25px; text-align: left;"></span>

                    </th>
                </tr>
            </table>

            <p></p>
            <p style="text-align: center; font-size: 12px;">
                ※배송완료시 세금계산서가 발행됩니다.
                <br />

                세금계산서 일자를 변경하고싶으시면 세금계산서 수정 버튼을 클릭하여 주시기바랍니다.
            </p>


            <!--완료하기 버튼-->
            <div class="orderRqs-bt-align1">
                <%--                <a id="btnPrint" onclick="fnOrderResultPop()">
                    <img src="../Images/Order/order-print-off.jpg" alt="출력하기" onmouseover="this.src='../Images/Order/order-print-on.jpg'" onmouseout="this.src='../Images/Order/order-print-off.jpg'" /></a>--%>

                <a id="btnBill" onclick="fnBill()">
                    <img src="../Images/Order/taxM-off.jpg" alt="세금계산서 수정" onmouseover="this.src='../Images/Order/taxM-on.jpg'" onmouseout="this.src='../Images/Order/taxM-off.jpg'" /></a>

                <%--세금계산서 요청 --%>
                <a class="onOff-btn" id="onBill" style="display: none" onclick="fnclick()">
                    <img src="../Images/Order/order-suc-off.jpg" alt="완료하기" onmouseover="this.src='../Images/Order/order-suc-on.jpg'" onmouseout="this.src='../Images/Order/order-suc-off.jpg'" />
                </a>
                <%--세금계산서 요청 X --%>
                <a class="onOff-btn" id="noBill" onclick="closepopup()">
                    <img src="../Images/Order/order-suc-off.jpg" alt="완료하기" onmouseover="this.src='../Images/Order/order-suc-on.jpg'" onmouseout="this.src='../Images/Order/order-suc-off.jpg'" />
                </a>
            </div>
        </div>
    </div>
</body>

</html>
