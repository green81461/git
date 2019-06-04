<%@ Page Language="C#" AutoEventWireup="true" CodeFile="OrderNoPassbookRequest.aspx.cs" Inherits="OrderNoPassbookRequest" %>

<!DOCTYPE html>

<html style="overflow-y: hidden">
<head>
    <title>무통장입금 주문</title>
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
        var is_sending = false;

        $(document).ready(function () {
            $("#txtBankExpDate").inputmask("9999-99-99");
            $("#Amt").val(numberWithCommas($("#hdAmt").val()) + " 원");

            $("#txtBankExpDate").datepicker({
                minDate: 0,                  //최소 선택 가능 일자 오늘 부터.
                maxDate: "60D",              //최대 선택 가능 일자 오늘부터 +60일
                showAnimation: 'slideDown',
                changeMonth: true,
                changeYear: true,
                dateFormat: "yy-mm-dd",
                monthNamesShort: ["1월", "2월", "3월", "4월", "5월", "6월", "7월", "8월", "9월", "10월", "11월", "12월"],
                dayNamesMin: ["일", "월", "화", "수", "목", "금", "토"],
                showMonthAfterYear: true
            });
        });

        function fnInfoChk() {
            var buyerTel = $("#txtBuyerTel").val();
            var txtBankExpDate = $("#txtBankExpDate").val();

            if (isEmpty(buyerTel) || (buyerTel.length < 9)) {
                alert("연락처가 없거나 올바르지 않습니다. 연락처를 '-'없이 입력해 주세요.");
                return false;
            }
            if (isEmpty(txtBankExpDate) || (txtBankExpDate.length < 10)) {
                alert("입금예정일을 선택해 주세요.");
                return false;
            }
            
            return true;
        }

        //결제하기
        function fnOrderPay() {

            if (fnInfoChk()) {
                var buyerTel = $("#txtBuyerTel").val();
                buyerTel = buyerTel.replace(/\-/g, '');
                $('#txtBuyerTel').val(buyerTel);

                var callback = function (response) {

                    if (!isEmpty(response)) {
                        document.payNoBookForm.action = "OrderNoPassbookResult";
                        document.payNoBookForm.submit();
                    }
                }

                var payway = $("input[name='hdPayway']").val();
                var goodsName = $("input[name='txtGoodsName']").val();
                var goodsCnt = $("input[name='hdGoodsCnt']").val();
                var Amt = $("input[name='hdAmt']").val();
                var buyerName = $("input[name='txtBuyerName']").val();
                var ordCodeNo = $("input[name='txtOrdCodeNo']").val();
                var buyerEmail = $("input[name='txtBuyerEmail']").val();
                var subjectDate = $("input[name='hdSubjectDate']").val();
                var roleFlag = '<%=RoleFlag %>';
                var urianType = '<%=UrianType %>';
                var urianTypeUnumNo = '<%=UrianTypeUnumNo %>';
                
                var param = {
                    SvidUser: '<%=Svid_User%>',
                    OrderCodeNo: ordCodeNo,
                    PgMid: 'PAYWAY_10',
                    BuyerName: buyerName,
                    BuyerTel: buyerTel,
                    BuyerMail: buyerEmail,
                    GoodsName: goodsName,
                    GoodsQty: goodsCnt,
                    Amt: Amt,
                    PayWay: payway,
                    RoleFlag: roleFlag,
                    UrianType: urianType,
                    UrianTypeUnumNo: urianTypeUnumNo,
                    Method: "SavePayNoPassbook"
                };
                
                var beforeSend = function () {
                    is_sending = true;
                }
                var complete = function () {
                    is_sending = false;
                }
                if (is_sending) return false;


                JqueryAjax('Post', '../Handler/PayHandler.ashx', true, false, param, 'text', callback, beforeSend, complete, true, '<%=Svid_User%>');

            }
        }

        function fnPayClose() {
            alert("결제가 취소 되었습니다.");
            self.close();
        }
    </script>
</head>
<body>
<form name="payNoBookForm" method="post" action="OrderNoPassbookResult" style="height: 100%">
    <div class="payfin_area">
        <div class="orderR-title-div">
            <img src="../Images/Order/orderR-title.jpg" alt="최종결제내역 확인" />
            <br /><br />
            <table class="orderRqs-table">
                <tr>
                    <th style="width:150px;" class="auto-style2"><span>결제수단</span></th>
                    <td class="auto-style3">
                        <input type="text" name="txtPayway" style="width: 300px" readonly value="무통장입금" />
                        <input type="hidden" name="hdPayway" id="hdPayway" value="<%=Payway %>" />
                        <input type="hidden" name="hdGoodsCnt" id="hdGoodsCnt" value="<%=GoodsCnt %>" />
                        <input type="hidden" name="hdSubjectDate" id="hdSubjectDate" value="<%=SubjectDate %>" />
                        <input type="hidden" name="hdSaleComName" id="hdSaleComName" value="<%=SaleComName %>" />
                        <input type="hidden" name="hdBuyerComName" id="hdBuyerComName" value="<%=BuyerComName %>" />
                        
                    </td>
                </tr>
                <tr>
                    <th>주문번호</th>
                    <td>
                        <input type="text" name="txtOrdCodeNo" style="width: 300px;" readonly value="<%=OrderCodeNo%>" onfocus="this.blur();" />
                    </td>
                </tr>
                <tr>
                    <th><span>상품명</span></th>
                    <td>
                        <input type="text" name="txtGoodsName" style="width: 300px" readonly value="<%=GoodsName%>" onfocus="this.blur();" />
                    </td>
                </tr>
                <tr>
                    <th><span>금액</span></th>
                    <td>
                        <input type="text" name="txtAmt" id="Amt" style="width: 300px" readonly value="<%=Amt%> 원" onfocus="this.blur();" />
                        <input type="hidden" name="hdAmt" id="hdAmt" value="<%=Amt %>" />
                    </td>
                </tr>
                <tr>
                    <th class="auto-style1"><span>구매자명</span></th>
                    <td class="auto-style1">
                        <input type="text" name="txtBuyerName" id="txtBuyerName" style="width: 200px" readonly value="<%=BuyerName%>" onfocus="this.blur();" />
                    </td>
                </tr>
                <tr>
                    <th class="auto-style1"><span>연락처</span></th>
                    <td class="auto-style1">
                        <input type="text" name="txtBuyerTel" id="txtBuyerTel" style="width: 110px; height:22px; border:1px solid #a2a2a2; padding-left:5px;" maxlength="16" onkeypress="return onlyNumbers(event);" value="<%=BuyerTel %>" />
                        <label style="font-weight:normal;">&nbsp;'-' 없이 입력해주세요</label>
                    </td>
                </tr>
                <tr>
                    <th class="auto-style1"><span>이메일</span></th>
                    <td class="auto-style1">
                        <input type="text" name="txtBuyerEmail" id="txtBuyerEmail" style="width: 300px" readonly value="<%=BuyerEmail %>" onfocus="this.blur();" />
                    </td>
                </tr>
                <tr>
                    <th class="auto-style1"><span>입금예정일</span></th>
                    <td>
                        <input type="text" id="txtBankExpDate" name="txtBankExpDate" style="width: 110px; height:22px; border:1px solid #a2a2a2; padding-left:5px;" maxlength="10" placeholder="클릭하세요" size="30" />
                    </td>
                </tr>

                <tr style="background-color: aliceblue; height:150px;">
                    <td style="color: white; background-color: slategrey; font-size: 20px;" colspan="2"><span style="font-size: 12px; display: block; text-align: center"></span>
                        <input type="hidden" name="hdBankNo" id="hdBankNo" value="21903349001051" />
                        <input type="hidden" name="hdBankTypeName" id="hdBankTypeName" value="(주)동신툴피아" />
                        <input type="hidden" name="hdBankName" id="hdBankName" value="기업은행" />
                        <input type="hidden" name="hdBankCode" id="hdBankCode" value="003" />

                        <span>입금은행 : <span style="color: white; font-size: 25px; text-align: left;">기업은행 (주)동신툴피아</span></span><br />
                        <span>입금계좌 : <span style="color: white; font-size: 25px; text-align: left;">219-033490-01-051</span></span>
                    </td>
                </tr>
            </table>
            <br />

            <!--완료하기 버튼-->
            <div class="orderRqs-bt-align1">
                <input type="button" class="commonBtn" style="width:95px; height:30px; font-size:12px" value="취소" onclick="fnPayClose()"/>
                <input type="button" class="commonBtn" style="width:95px; height:30px; font-size:12px" value="결제하기" onclick="fnOrderPay()"/>
            </div>
        </div>
    </div>
</form>
</body>
</html>
