<%@ Page Language="C#" AutoEventWireup="true" CodeFile="OrderCardAllCancelRequest.aspx.cs" Inherits="Admin_Order_OrderCardAllCancelRequest" %>

<!DOCTYPE html>

<html>
<head runat="server">
    <title>카드 주문 전체 취소 요청</title>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=yes, target-densitydpi=medium-dpi" />
    <link rel="stylesheet" type="text/css" href="./css/import.css" />
    <link rel="stylesheet" href="../Content/Order/order.css" />
    <link rel="stylesheet" type="text/css" href="../Content/popup.css" />
    <link rel="stylesheet" type="text/css" href="../../Content/SiteInfo/SiteInfo.css" />
    <script type="text/javascript" src="../../Scripts/jquery-1.10.2.min.js"></script>
    <script src="../../Scripts/common.js"></script>
    <script type="text/javascript">
        var is_sending = false;

        $(document).ready(function () {
            $(window).on("beforeunload", function () {
                $(opener.location).attr("href", "javascript:fnSearch(1);");
            });
        });

        //유효성검사
        function fnDataCheck() {
            var CancelMsg = $("input[name='CancelMsg']").val();

            if (CancelMsg == "") {
                alert('취소 사유를 입력해주세요.');
                return false;
            }

            var confirmVal = confirm("정말로 전체 주문취소를 하시겠습니까?");
            if (!confirmVal) {
                return false;
            }

            return true;
        }

        //신용카드 전체 취소
        function goAllCancelPay() {

            if (!fnDataCheck()) return false;

            document.allCancelForm.submit();

            //var callback = function (response) {

            //    if (!isEmpty(response) && (response == "SUCCESS")) {
            //        document.allCancelForm.submit();

            //    } else {
            //        alert("오류가 발생했습니다. 관리자에게 문의바랍니다.");
            //        return false;
            //    }
            //};

            //var OrderCodeNo = $("input[name='Moid']").val();
            //var Svid_User = $("input[name='Svid_User']").val();
            //var CancelMsg = $("input[name='CancelMsg']").val();

            //var param = {
            //    OrderCodeNo: OrderCodeNo,
            //    SvidUser: Svid_User,
            //    CancelMsg: CancelMsg,
            //    Method: "SaveOrderAllCancel"
            //};

            //var beforeSend = function () { is_sending = true; }
            //var complete = function () { is_sending = false; }
            //if (is_sending) return false;

            <%--JqueryAjax("Post", "../../Handler/OrderHandler.ashx", true, false, param, "text", callback, beforeSend, complete, true, '<%=Svid_User%>');--%>
            
        }

        function fnPopupClose() {
            self.close();
        }
    </script>
</head>
<body>
    <form name="allCancelForm" method="post" action="OrderCardAllCancelResult">
        <div class="canclefin_area">
            <div class="top" style="margin-top:10px;"><h3 class="pop-title">카드 전체 주문취소 요청</h3></div>
            <div class="conwrap">
                <div class="con">
                    <div class="tabletypea">
                        <table class="cancleRqs-table" style="margin-top: 30px;">
                            <colgroup>
                                <col style="width: 30%" />

                            </colgroup>
                            <tr>
                                <th class="tbl-td">주문번호</th>
                                <td style="padding-left: 5px;">
                                    <input type="text" name="Moid" id="Moid" value="<%=OrderCodeNo%>" style="width: 98%" readonly>
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
                                    <input type="hidden" name="codeNo" id="codeNo" value="" />
                                    <input type="hidden" name="uOrderNo" id="uOrderNo" value='<%=uOrderNo%>' />
                                    <input type="hidden" name="OrderStatus" id="OrderStatus" value='<%=ordStat_type%>' />
                                    <input type="hidden" name="Flag" id="Flag" value='<%=Flag%>' />
                                    <input type="hidden" name="DftDlvrCost" id="dftDlvrCost" value='<%=DftDlvrCost%>' />
                                    <input type="hidden" name="PowerDlvrCost" id="powerDlvrCost" value='<%=PowerDlvrCost%>' />
                                    <input type="hidden" name="CancelAmt" id="CancelAmt" value='<%=GoodsSalePriceVat%>' />
                                    <input name="PayMethod" type="hidden" id="PayMethod" value="<%=PayMethod%>" />
                                    <input name="payWayResult" type="hidden" id="payWayResult" value="<%=payWayResult%>" />

                                    <%--공급가액--%>
                                    <%--<input type="text" name="SupplyAmt" value="<%=SupplyAmt %>">--%>
                                    <%--부가가치세--%>
                                    <%--<input type="text" name="GoodsVat" value="<%=GoodsVat %>">--%>
                                    <%--봉사료--%>
                                    <%--<input type="text" name="ServiceAmt" value="<%=ServiceAmt %>">--%>
                                    <%--면세 금액--%>
                                    <%--<input type="text" name="TaxFreeAmt" value="<%=TaxFreeAmt %>">--%>
                                </td>
                            </tr>
                            <tr>
                                <th class="tbl-td">주문일자</th>
                                <td style="padding-left: 5px;">
                                    <input type="text" name="EntryDate" value="<%=EntryDate%>" style="width: 98%" readonly></td>
                            </tr>
                            <tr>
                                <th class="tbl-td">상품정보</th>
                                <td style="padding-left: 5px;">
                                    <input type="hidden" name="cancelFlag" value="<%=cancelFlag %>" />
                                    <input type="hidden" name="uNumOrdNoArr" value="<%=uNumOrdNoArr %>" />
                                    <input type="text" name="goodsinfo" value="<%=goodsinfo%>" style="width: 98%" readonly></td>
                            </tr>
                            <tr>
                                <th class="tbl-td">모델명</th>
                                <td style="padding-left: 5px;">
                                    <input type="text" name="GoodsModel" value="<%=GoodsModel%>" style="width: 98%" readonly></td>
                            </tr>
                            <tr>
                                <th class="tbl-td">수량</th>
                                <td style="padding-left: 5px;">
                                    <input type="hidden" name="qty" value="<%=Qty%>" />
                                    <input type="text" name="qtyNm" value="<%=qty%>" readonly /></td>
                            </tr>
                            <tr>
                                <th class="tbl-td">구매금액</th>
                                <td style="padding-left: 5px;">
                                    <input type="text" name="CancelAmt1" id="CancelAmt1" value="<%=GoodsSalePriceVat%> 원" readonly class="auto-style1"></td>
                            </tr>
                            <tr>
                                <th class="tbl-td">취소 사유</th>
                                <td style="padding-left: 5px;">
                                    <input type="text" name="CancelMsg" value="<%=CancelMsg%>" style="border: 1px solid #a2a2a2; height: 24px; width: 98%" placeholder=" 취소사유를 30자이내로 입력 하세요."></td>
                            </tr>
                        </table>
                    </div>
                
                    <span style="padding-left: 25px; font-size: 12px;">* 취소 요청시 상단의 모든 값을 입력 하세요.</span>
                    <%--<br />--%>
                    <%--<span style="padding-left: 25px; font-size: 12px;">* 신용카드결제, 실시간계좌이체만 부분취소/부분환불이 가능합니다.</span>--%>
                    <div class="btngroup">
                        <%--  <a href="#" class="btn_blue" onclick="fnCheck();">요 청</a>--%>
                        <!--취소하기, 요청하기 버튼 -->
                        <div class="orderRqs-bt-align" style="padding-top:20px;">
                            <%--<a>
                                <img src="../Images/Order/close-off.jpg" alt="닫기" onclick="fnOrderClose();" onmouseover="this.src='../Images/Order/close-on.jpg'" onmouseout="this.src='../Images/Order/close-off.jpg'" /></a>--%>
                            <%--<a onclick="fnCheck();">
                                <img src="../Images/Order/reqCan-off.jpg" alt="요청하기" onmouseover="this.src='../Images/Order/reqCan-on.jpg'" onmouseout="this.src='../Images/Order/reqCan-off.jpg'" /></a>--%>
                            <input type="button" class="commonBtn" style="width:95px; height:30px; font-size:12px" value="닫기" onclick="fnPopupClose();"/>
                            <input type="button" class="commonBtn" style="width:95px; height:30px; font-size:12px" value="요청하기" onclick="return goAllCancelPay();"/>
                        </div>
                    </div>
                
                
                </div>

            </div>
        </div>
    </form>
</body>
</html>
