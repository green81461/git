<%@ Page Language="C#" AutoEventWireup="true" CodeFile="VbankRequest.aspx.cs" Inherits="Order_VbankRequest" %>


<!DOCTYPE html>
<html>
<head>
    <title>NICEPAY PAY REQUEST</title>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=yes, target-densitydpi=medium-dpi" />
    <%--<link rel="stylesheet" type="text/css" href="./css/import.css" />--%>
    <link href="../Content/Order/order.css" rel="stylesheet" />
    <script src="https://web.nicepay.co.kr/flex/js/nicepay_tr_utf.js" language="javascript"></script>
    <script type="text/javascript" src="../Scripts/jquery-1.10.2.min.js"></script>
    <script src="../Scripts/common.js"></script>
    <script type="text/javascript">
        var is_sending = false;

        function resize_window() {
            window.resizeTo(820, 630);
        }


        $(document).ready(function () {

            vBanckCode();

            var buyPrice = $("input[name='Amt1']").val();

            $("#Amt1").val(numberWithCommas(buyPrice));
        });

        function vBanckCode() {
            var callback = function (response) {

                if (!isEmpty(response)) {

                    GetCommList(response);
                }
            };
            var svidUser = '<%= Svid_User%>';
            var param = {
                Code: "PAY", Channel: 2, Method: "GetCommList", Svid_User: svidUser
            };
            JajaxSessionCheck("Post", "../Handler/Common/CommHandler.ashx", param, "json", callback, '<%=Svid_User %>'); // ajax 호출
            
        }

        function GetCommList(commList) {
            for (var item in commList) {

                var option = $("<option value=" + commList[item].Map_Type + "></option>").text(commList[item].Map_Name);


                $("#paybankName").append(option);
            }
        }

        function fnOpenerReload() {
            opener.parent.location.replace("OrderHistoryList.aspx");
        }

        //결제창 최초 요청시 실행됩니다.
        function nicepayStart() {
            goPay(document.payForm);
        }

        function fnPayClose() {
            //alert('주문취소를 취소합니다.')
            self.close();
        }

        function fnOrdCancelReq() {

            var ordCodeNo = $("#hdOrdCodeNo").val();
            var ordStat = $("#hdOrdStat").val();

            if ((isEmpty(ordCodeNo)) || (isEmpty(ordStat))) {
                alert("잘못된 호출입니다. 창을 종료합니다.\n잠시 후 다시 시도해 주세요.");
                self.close();
            }

            var cancelMsg = $("#cancelMsg").val();
            var cancelVBankNo = $("#inputCancVbankNo").val();
            var cancelVBankCode = $("#paybankName").val();
            var VbankInputName = $("#inputCancVbankName").val();
            

            if (isEmpty(VbankInputName)) {

                alert("예금주 명을 입력해주세요.")
                return false;
            }

            if (isEmpty(cancelVBankNo)) {

                alert("환불계좌를 입력해주세요")
                return false;

            } else {
                cancelVBankNo = cancelVBankNo.replace(/[^0-9]/g, '');
            }

            if (isEmpty(cancelMsg)) {

                alert('취소 사유를 입력해주세요.')
                return false;
            }
            
            var callback = function (response) {
                var returnVal = false;
                if (!isEmpty(response)) {
                    var resultVal = response.Result;

                    alert("정상적으로 주문이 취소되었습니다.");
                    
                } else {
                    alert("오류가 발생했습니다. 잠시 후 다시 시도해 주세요.");
                }
                
                return false;
            };
            
            var sUser = '<%=Svid_User %>';
            var param = { SvidUser: sUser, OrdCodeNo: ordCodeNo, OrdStat: ordStat, CancVbankNo: cancelVBankNo, CancVbankCode: cancelVBankCode, CancVbankName: VbankInputName, CancelMsg: cancelMsg, Method: 'OrdCancelDirect' };


            var beforeSend = function () { is_sending = true; }
            var complete = function () {
                is_sending = false;

                self.close();
            }
            if (is_sending) return false;

            JqueryAjax("Post", "../Handler/OrderHandler.ashx", true, false, param, "json", callback, beforeSend, complete, true, '<%=Svid_User%>');

            <%--JajaxSessionCheck('Post', '../Handler/OrderHandler.ashx', param, 'json', callback, '<%=Svid_User %>');--%>


            //var callback = function (response) {

            //    if (!isEmpty(response)) {
            //        nicepayStart();
            //    }
            //};

            //var PayWay = $("input[name='PayWay']").val();
            //var PayMethod = $("input[name='PayMethod']").val();
            //var GoodsName = $("input[name='GoodsName']").val();
            //var GoodsCnt = $("input[name='GoodsCnt']").val();
            //var Amt = $("input[name='Amt']").val();
            //var BuyerName = $("input[name='BuyerName']").val();
            //var BuyerTel = $("input[name='BuyerTel']").val();
            //var Moid = $("input[name='Moid']").val();
            //var MID = $("input[name='MID']").val();
            //var VbankExpDate = $("input[name='VbankExpDate']").val();
            //var BuyerEmail = $("input[name='BuyerEmail']").val();
            //var TransType = $("input[name='TransType']").val();
            //var EncodeParameters = $("input[name='EncodeParameters']").val();
            //var subjectDate = $("input[name='subjectDate']").val();
            //var EncryptData = $("input[name='EncryptData']").val();
            //var MerchantKey = $("input[name='MerchantKey']").val();

            //var param = {
            //    OrderCodeNo: Moid,
            //    Pg_Mid: MID,
            //    Pg_Midkey: MerchantKey,
            //    Pg_Hash: EncryptData,
            //    BuyerName: BuyerName,
            //    BuyerTel: BuyerTel,
            //    BuyerMail: BuyerEmail,
            //    GoodsName: GoodsName,
            //    Goodsqty: GoodsCnt,
            //    Amt: Amt,
            //    PayWay: PayWay,
            //    SubjectDate: subjectDate,
            //    Method: "PayInsert"
            //};

            //Jajax('Post', '../Handler/PayHandler.ashx', param, 'json', callback);

        }

        //결제 최종 요청시 실행됩니다. <<'nicepaySubmit()' 이름 수정 불가능>>
        function nicepaySubmit() {
            document.payForm.submit();
        }

        //결제창 종료 함수 <<'nicepayClose()' 이름 수정 불가능>>
        function nicepayClose() {
            alert("결제가 취소 되었습니다");
            self.close();
        }
    </script>

    <style type="text/css">
        * {
            margin: 0;
            padding: 0
        }

        .auto-style1 {
            height: 30px;
        }

        .auto-style2 {
            background-color: #ececec;
            text-align: center;
            height: 30px;
        }

        .auto-style3 {
            background-color: #ececec;
            text-align: center;
            height: 26px;
        }

        .auto-style4 {
            height: 24px;
        }

        .auto-style5 {
            background-color: #ececec;
            text-align: center;
            height: 24px;
        }
    </style>


</head>
<body onload="javascript_:resize_window();" onbeforeunload="fnOpenerReload()">
    <form name="payForm">
        <div class="payffin_area">

            <div class="conwrap" style="border: 1px solid #a2a2a2; box-sizing: border-box; width: 796px; height: 558px">
                <div class="orderR-title-div">
                    <img src="../Images/Order/cancle-title.jpg" alt="주문취소 요청"/>
                   
                </div>
                <div class="con">
                    <div class="tabletypea">
                        <table class="orderRqs-table">
                            <tr>
                                <td class="auto-style2">결제수단</td>
                                <td style="padding-left: 5px;" class="auto-style1">
                                    <input name="PayMethod" type="hidden" id="PayMethod" value="<%=PayMethod%>"  />
                                        <input name="payWayResult" type="text" id="payWayResult" value="<%=payWayResult%>"  readonly />

                                    <input type="hidden" name="Moid" value="<%=moid%>">

                                    <input type="hidden" name="GoodsCnt" value="<%=goodsCnt%>">

                                    <input type="hidden" name="Svid_User" value="<%=Svid_User%>">

                                    <%-- <input type="hidden" name="FLAG" value="<%=FLAG%>" />--%>



                                    <!-- 옵션 -->
                                    <input type="hidden" name="VbankExpDate" value="<%=VbankExpDate%>" />
                                    <!-- 가상계좌입금만료일 -->
                                    <input type="hidden" name="BuyerEmail" value="<%=buyerEmail%>" />
                                    <!-- 구매자 이메일 -->
                                    <input type="hidden" name="GoodsCl" value="1" />
                                    <!-- 상품구분(실물(1),컨텐츠(0)) -->
                                    <input type="hidden" name="TransType" value="<%=transType%>" />
                                    <!-- 일반(0)/에스크로(1) -->

                                    <!-- 변경 불가능 -->
                                    <input type="hidden" name="EncodeParameters" value="<%=encodeParameters%>" />

                                    <input type="hidden" name="PayWay" id="PayWay" value="<%=PayWay%>" />
                                    <!-- 암호화대상항목 -->
                                    <input type="hidden" name="EdiDate" value="<%=ediDate%>" />
                                    <!-- 전문 생성일시 -->
                                    <input type="hidden" name="EncryptData" value="<%=hash_String%>" />

                                    <input type="hidden" name="subjectDate" value="<%=subjectDate%>" />


                                    <!-- 해쉬값 -->
                                    <input type="hidden" name="TrKey" value="" />
                                    <!-- 필드만 필요 -->
                                    <input type="hidden" name="MerchantKey" value="<%=merchantKey%>" />

                                    <input type="hidden" name="MID" value="<%=merchantID%>">
                                    <!-- 상점 키 -->
                                    <input type="hidden" name="SocketYN" value="Y">
                                    <!-- 소켓통신 -->
                                    <input type="hidden" name="ROLE_FLAG" value="TYPE_1">
                                    <input type="hidden" name="payWayResult" value="<%=payWayResult%>">
                                    <input type="hidden" name="Amt" value="<%=price%>">

                                    <input type="hidden" id="hdOrdCodeNo" value='<%= ordCodeNo %>'>
                                    <input type="hidden" id="hdOrdStat" value='<%= ordStat %>'>
                                    
                                </td>
                            </tr>

                            <tr>
                                <td class="tbl-td">구매기관명</td>
                                <td style="padding-left: 5px;">
                                    <input name="tdCompanyName" type="text" id="tdCompanyName" value="<%=CompanyName%>" readonly style="height: 24px; width: 95%; line-height: 25px;" /></td>
                            </tr>

                            <tr>
                                <td class="tbl-td">부서명</td>
                                <td style="padding-left: 5px;">
                                    <input name="부서명" type="text" value="<%=CompanyDeptName%>" readonly style="height: 24px; width: 95%; line-height: 25px;" /></td>

                            </tr>


                            <tr>
                                <td  style="background-color: #ececec; text-align: center">주문자</td>
                                <td style="padding-left: 5px;">
                                    <input name="BuyerName" type="text" value="<%=buyerName%>" readonly id="BuyerName" style="height: 24px; width: 95%; line-height: 25px;" /></td>
                            </tr>

                            <tr>
                                <td  style="background-color: #ececec; text-align: center;">연락처</td>
                                <td style="padding-left: 5px;">
                                    <input name="BuyerTel" type="text" readonly id="BuyerTel" value="<%=buyerTel%>" style="height: 24px; width: 95%; line-height: 25px;" /></td>
                            </tr>

                            <tr>
                                <td class="auto-style1" style="background-color: #ececec; text-align: center;">이메일</td>
                                <td class="auto-style1" style="padding-left: 5px;">
                                    <input name="이메일" type="text" value="<%=buyerEmail%>" readonly style="height: 24px; width: 95%; line-height: 25px;" /></td>

                            </tr>

                            <tr>
                                <td class="tbl-td">배송지 정보</td>
                                <td colspan="5" style="padding-left: 5px;">
                                    <input name="DeliveryInfo" type="text" class="addr" value="<%=Address_1%>" readonly style="height: 24px; width: 95%; line-height: 25px;" /></td>
                            </tr>
                            <tr>
                                <td class="auto-style2">결제상품명</td>
                                <td style="padding-left: 5px;" class="auto-style1">
                                    <input name="GoodsName" class="goodN" type="text" id="GoodsName" value="<%=goodsName%>" style="height: 24px; width: 95%; line-height: 25px;" /></td>
                            </tr>
                            <tr>
                                <td class="auto-style5">총결제금액</td>
                                <td style="padding-left: 5px;" class="auto-style4">
                                    <input name="Amt1" type="text" id="Amt1" readonly value="<%=price%> 원" style="height: 24px; width: 95%; line-height: 25px;" /></td>
                                    

                                <%--  <td>
                                    <input type="text" name="MerchantKey" value="<%=merchantKey%>" />

                                    <input type="text" name="MID" value="<%=merchantID%>">
                                </td>--%>

                                <%--     numberWithCommas--%>
                            </tr>


                            <tr>
                                <td class="tbl-td">취소 사유</td>
                                <td style="padding-left: 5px;">
                                    <input type="text" id="cancelMsg" value="" style="border:1px solid #a2a2a2; height:70%; width:98%" placeholder="&nbsp;취소사유를 30자이내로 입력 하세요."></td>
                           
                            </tr>

                            
                            <tr>
                                <td class="tbl-td">예금주명</td>
                                <td style="padding-left: 5px;">
                                    <input type="text" id="inputCancVbankName" value="" style="border:1px solid #a2a2a2; height:70%; width:160px;"  placeholder="&nbsp;예금주명을 입력 하세요."></td>
                            </tr>
                            <tr>
                                <td class="tbl-td">환급계좌번호</td>
                                <td style="padding-left: 5px;">
                                    <input type="text" id="inputCancVbankNo" value="" style="border:1px solid #a2a2a2; height:70%;  width:160px; " placeholder="&nbsp;'-'없이 계좌번호을 입력 하세요."></td>
                            </tr>
                            <tr>
                                <td class="tbl-td">환급계좌은행명</td>
                                <td style="padding-left: 5px;">
                                    <select id="paybankName" style="border:1px solid #a2a2a2;height:70%; "></select>

                                </td>

                            </tr>

                        </table>
                        <%--  <asp:Button ID="btnPayment" runat="server" Text="결제!" OnClick="btnPayment_Click" UseSubmitBehavior="false" Style="height: 21px" />--%>
                    </div>
                </div>
                <div class="orderRqs-bt-align1" style="margin-top:8px;">
                    <a>
                        <img src="../Images/Order/close-off.jpg" alt="취소하기" onclick="fnPayClose();" onmouseover="this.src='../Images/Order/close-on.jpg'" onmouseout="this.src='../Images/Order/close-off.jpg'" /></a>
                    <a class="btn_blue" onclick="fnOrdCancelReq();">
                        <img src="../Images/Order/reqCan-off.jpg" alt="요청하기" onmouseover="this.src='../Images/Order/reqCan-on.jpg'" onmouseout="this.src='../Images/Order/reqCan-off.jpg'" /></a>
                    <%--   <a href="#" class="btn_blue" onclick="nicepayStart();">요 청</a>--%>
                </div>
            </div>
        </div>
    </form>

</body>
</html>
