<%@ Page Language="C#" AutoEventWireup="true" CodeFile="OrderCancelRequest.aspx.cs" Inherits="Order_OrderCancelRequest" %>

<!DOCTYPE html>

<html>
<head runat="server">
<title>주문취소 요청</title>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=yes, target-densitydpi=medium-dpi" />
<link href="../Content/NicePay/import.css" rel="stylesheet" />
<link href="../Content/jquery-ui.css" rel="stylesheet" />
<script src="https://web.nicepay.co.kr/flex/js/nicepay_tr_utf.js"></script>
<script src="../Scripts/jquery-1.10.2.min.js"></script>
<script src="../Scripts/common.js"></script>

<style>
    #loading {
     width: 100%;  
     height: 100%;  
     top: 0px;
     left: 0px;
     position: fixed;  
     display: block;  
     opacity: 0.7;  
     background-color: #fff;  
     z-index: 99;  
     text-align: center; } 
  
    #loading-image {  
     position: absolute;  
     top: 50%;  
     left: 50%; 
     z-index: 100; }
</style>

<script type="text/javascript">
    $(window).load(function() {    
        $('#loading').hide();  
    });

    $(document).ready(function () {
        resize_window();

        vBanckCode();

        $(window).on("beforeunload", function () {
            $(opener.location).attr("href", "javascript:fnSearch(1);");
        });
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

        var beforeSend = function () { };
        var complete = function () { };

        JqueryAjax("Post", "../Handler/Common/CommHandler.ashx", true, false, param, "json", callback, beforeSend, complete, true, '<%=Svid_User%>');
    }

    function GetCommList(commList) {
        for (var item in commList) {

            var option = $("<option value=" + commList[item].Map_Type + "></option>").text(commList[item].Map_Name);


            $("#paybankName").append(option);

        }
    }


    function goCancel() {
        document.cancelReqForm.submit();
    }

    function fnCheck() {
        var CancelMsg = $("input[name='CancelMsg']").val();
        var VbankInputName = $("input[name='VbankInputName']").val();
        var vBankNum = $("input[name='vBankNum']").val();
        var cancelFlag = $("input[name='cancelFlag']").val();

        if (typeof VbankInputName != "undefined") {

            vBankNum = vBankNum.replace(/[^0-9]/g, '');

            //정규식으로 변환한거 넣기
            $("input[name='vBankNum']").val(vBankNum);

            if (VbankInputName == "") {

                alert('예금주 명을 입력해주세요.');
                return false;
            }

            if (vBankNum == "") {

                alert('환불계좌를 입력해주세요');
                return false;
            }
        }

        if (CancelMsg == "") {

            alert('취소 사유를 입력해주세요.');
            return false;
        }

        if (isEmpty(cancelFlag)) {
            goCancelPay();
        } else {
            goAllCancelPay();
        }
    }

    var is_sending = false;

    //신용카드/실시간 주문 전체 취소(5만원미만)
    function goAllCancelPay() {

        var callback = function (response) {

            if (!isEmpty(response) && (response == "SUCCESS")) {
                goCancel();

            } else {
                alert("오류가 발생했습니다. 관리자에게 문의바랍니다.");
                return false;
            }
        };

        var OrderCodeNo = $("input[name='Moid']").val();
        var Svid_User = $("input[name='Svid_User']").val();
        //var goodsinfo = $("input[name='goodsinfo']").val();
        var CancelMsg = $("input[name='CancelMsg']").val();
        //var uOrderNo = $("input[name='uOrderNo']").val();
        //var uNumOrdNoArr = $("input[name='uNumOrdNoArr']").val();
        //var Flag = $("input[name='Flag']").val();
        //var cancelFlag = $("input[name='cancelFlag']").val();

        var param = {
            OrderCodeNo: OrderCodeNo,
            SvidUser: Svid_User,
            CancelMsg: CancelMsg,
            Method: "SaveOrderAllCancel"
        };

        var beforeSend = function () { is_sending = true; }
        var complete = function () { is_sending = false; }
        if (is_sending) return false;

        JqueryAjax("Post", "../Handler/OrderHandler.ashx", true, false, param, "text", callback, beforeSend, complete, true, '<%=Svid_User%>');
    }

    function goCancelPay() {
        var callback = function (response) {

            if (!isEmpty(response)) {
                var codeNo = response.Result;
                document.cancelReqForm.CancelCodeNo.value = codeNo;

                if (!isEmpty(codeNo)) {
                    goCancel();
                }
            }
        };

        var OrderCodeNo = $("input[name='Moid']").val();
        var GoodsFinalCategoryCode = $("input[name='GoodsFinalCategoryCode']").val();
        var GoodsGroupCode = $("input[name='GoodsGroupCode']").val();
        var GoodsCode = $("input[name='GoodsCode']").val();
        var Svid_User = $("input[name='Svid_User']").val();
        var goodsinfo = $("input[name='goodsinfo']").val();
        var CancelMsg = $("input[name='CancelMsg']").val();
        var OrderCancelStatus = $("input[name='OrderCancelStatus']").val();
        var uOrderNo = $("input[name='uOrderNo']").val();
        var OrderStatus = $("input[name='OrderStatus']").val();
        var PaywayFlag = $("input[name='PaywayFlag']").val();

        var param = {
            OrderCodeNo: OrderCodeNo,
            GoodsFinalCategoryCode: GoodsFinalCategoryCode,
            GoodsGroupCode: GoodsGroupCode,
            GoodsCode: GoodsCode,
            SvidUser: Svid_User,
            goodsinfo: goodsinfo,
            CancelMsg: CancelMsg,
            OrderCancelStatus: OrderCancelStatus,
            uOrderNo: uOrderNo,
            OrderStatus: OrderStatus,
            Flag: PaywayFlag,
            Method: "SaveOrderCancel"
        };

        var beforeSend = function () { is_sending = true; }
        var complete = function () { is_sending = false; }
        if (is_sending) return false;

        JqueryAjax("Post", "../Handler/OrderHandler.ashx", true, false, param, "json", callback, beforeSend, complete, true, '<%=Svid_User%>');
    }

    function fnOrderClose() {
        self.close();
    }


    function resize_window() {
        var width = 670;
        var height = 640;
        var left = (window.screen.width / 2) - (width / 2);
        var top = (window.screen.height / 2) - (height / 2);
        window.resizeTo(width, height, 100, 20);
    }
    //팝업창 닫기
    function fnCancle() {
        $('.divpopup-layer-pakage').fadeOut();
    }
</script>

</head>
<body>
<form name="cancelReqForm" method="post" action="OrderCancelResult">
    <div id="loading"><img id="loading-image" src="../Images/Order/payLoading.gif" alt="Loading..." /></div>
    <div class="payfin_area">
        <div class="top">주문취소 요청</div>
        <div class="conwrap">
            <div class="con">
                <div class="tabletypea">
                    <table>
                        <colgroup><col style="width:30%" /><col style="width:auto" /></colgroup>
                        <tr>
                            <th><span>주문번호</span></th>
                            <td>
                                <asp:Literal runat="server" ID="ltrMoid"></asp:Literal>
                                <input type="hidden" name="Moid" value="<%=OrderCodeNo%>">

                                <input type="hidden" name="MID" value='<%=Pg_MID%>' />
                                <input type="hidden" name="TID" value='<%=Pg_TID%>' />
                                <input type="hidden" name="CancelPwd" value='<%=CancelPwd%>' />
                                <input type="hidden" name="PartialCancelCode" id="PartialCancelCode" value='<%=PartialCancelCode%>' />
                                <input type="hidden" name="GoodsQty" id="GoodsQty" value='<%=GoodsQty%>' />
                                <input type="hidden" name="GoodsFinalCategoryCode" id="GoodsFinalCategoryCode" value='<%=GoodsFinalCategoryCode%>' />
                                <input type="hidden" name="GoodsGroupCode" id="GoodsGroupCode" value='<%=GoodsGroupCode%>' />
                                <input type="hidden" name="GoodsCode" id="GoodsCode" value='<%=GoodsCode%>' />
                                <input type="hidden" name="Svid_User" id="Svid_User" value='<%=Svid_User%>' />
                                <input type="hidden" name="OrderCancelStatus" id="OrderCancelStatus" value='<%=OrderCancelStatus%>' />
                                <input type="hidden" name="GoodsFinalName" id="GoodsFinalName" value='<%=GoodsFinalName%>' />
                                <input type="hidden" name="CancelCodeNo" id="CancelCodeNo" value="" />
                                <input type="hidden" name="uOrderNo" id="uOrderNo" value='<%=uOrderNo%>' />
                                <input type="hidden" name="OrderStatus" id="OrderStatus" value='<%=ordStat_type%>' />
                                <input type="hidden" name="PaywayFlag" id="PaywayFlag" value='<%=Flag%>' />
                                <input type="hidden" name="DftDlvrCost" id="dftDlvrCost" value='<%=DftDlvrCost%>' />
                                <input type="hidden" name="PowerDlvrCost" id="powerDlvrCost" value='<%=PowerDlvrCost%>' />
                                <input type="hidden" name="CancelAmt" id="CancelAmt" value='<%=GoodsSalePriceVat%>' />
                                <input type="hidden" name="PayMethod" id="PayMethod" value="<%=PayMethod%>" />
                                <input type="hidden" name="payWayResult" id="payWayResult" value="<%=payWayResult%>" />
                                <%--복합과세--%>
                                <input type="hidden" name="SupplyAmt" value="<%=SupplyAmt %>">
                                <input type="hidden" name="GoodsVat" value="<%=GoodsVat %>">
                                <input type="hidden" name="ServiceAmt" value="<%=ServiceAmt %>">
                                <input type="hidden" name="TaxFreeAmt" value="<%=TaxFreeAmt %>">
                            </td>
                        </tr>
                        <tr>
                            <th><span>주문일자</span></th>
                            <td>
                                <asp:Literal runat="server" ID="ltrEntryDate"></asp:Literal>
                                <input type="hidden" name="EntryDate" value="<%=EntryDate%>">
                            </td>
                        </tr>
                        <tr>
                            <th><span>상품정보</span></th>
                            <td>
                                <asp:Literal runat="server" ID="ltrGoodsInfo"></asp:Literal>
                                <input type="hidden" name="cancelFlag" value="<%=cancelFlag %>" />
                                <input type="hidden" name="uNumOrdNoArr" value="<%=uNumOrdNoArr %>" />
                            </td>
                        </tr>
                        <tr>
                            <th><span>모델명</span></th>
                            <td>
                                <asp:Literal runat="server" ID="ltrGoodsModel"></asp:Literal>
                            </td>
                        </tr>
                        <tr>
                            <th><span>수량</span></th>
                            <td>
                                <asp:Literal runat="server" ID="ltrGoodsCnt"></asp:Literal>
                                <input type="hidden" name="qty" value="<%=Qty%>" />
                            </td>
                        </tr>
                        <tr>
                            <th><span>결제 금액</span></th>
                            <td>
                                <asp:Literal runat="server" ID="ltrCancelAmt"></asp:Literal>

                            </td>
                        </tr>
                        <tr>
                            <th><span>취소 사유</span></th>
                            <td>
                                <input type="text" name="CancelMsg" value="<%=CancelMsg%>" style="border: 1px solid #a2a2a2; height: 24px; width: 98%" placeholder="&nbsp;취소사유를 30자이내로 입력 하세요.">
                            </td>
                        </tr>

                        <asp:Panel ID="vbankPanel" runat="server" Visible="false">
                            <tr>
                                <th class="tbl-td">예금주명</th>
                                <td style="padding-left: 5px;">
                                <input type="text" name="VbankInputName" value="" style="border: 1px solid #a2a2a2; height: 70%; width: 160px;" placeholder="&nbsp;예금주명을 입력 하세요."></td>
                            </tr>
                            <tr>
                                <th class="tbl-td">환급계좌번호</th>
                                <td style="padding-left: 5px;">
                                <input type="text" name="vBankNum" value="" style="border: 1px solid #a2a2a2; height: 70%; width: 160px;" placeholder="&nbsp;계좌번호을 입력 하세요."></td>
                            </tr>
                            <tr>
                                <th class="tbl-td">환급계좌은행명</th>
                                <td style="padding-left: 5px;">
                                    <select id="paybankName" name="paybankName" style="border: 1px solid #a2a2a2; height: 70%;"></select>
                                </td>
                            </tr>
                        </asp:Panel>
                    </table>
                </div>
            </div>
            
            <p>* 신용카드결제, 계좌이체, 가상계좌만 부분취소/부분환불이 가능합니다.</p>
            <div class="btngroup">
                <a href="#" class="btn_blue" onClick="fnOrderClose();">닫기</a>
                <a href="#" class="btn_blue" onClick="fnCheck();">주문취소요청</a>
            </div>
        </div>
    </div>
</form>
</body>
</html>
