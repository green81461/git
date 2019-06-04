<%@ Page Language="C#" AutoEventWireup="true" CodeFile="PayResult.aspx.cs" Inherits="Order_PayResult" %>

<!DOCTYPE html>

<html>
<head runat="server">
<title>NICEPAY 결제 결과</title>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=yes, target-densitydpi=medium-dpi" />
<link href="../Content/NicePay/import.css" rel="stylesheet" />
<script src="https://web.nicepay.co.kr/flex/js/nicepay_tr_utf.js"></script>
<script src="../Scripts/jquery-1.10.2.min.js"></script>
<script src="../Scripts/common.js"></script>

<script type="text/javascript">
    $(document).ready(function () {
        resizeWindow();
    });

    function resizeWindow() {
        var payway = '<%=payMethodFlag %>';
        var popupY = 850;
        if ((payway == "3") || (payway == "6") || (payway == "9")) {
            popupY = 650;
            if (payway != "3") {
                popupY = 750;
            }
        } else {
            popupY = 850;
        }

        window.resizeTo(830, popupY);
    }

    function printReceipt(tid) {    
        var status = "toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,width=420,height=540";
        var url = "https://pg.nicepay.co.kr/issue/IssueLoader.jsp?TID="+tid+"&type=0";
        window.open(url,"popupIssue",status);
    }

    //결제 결과
    function fnPayResult() {
        var paySuccessFlag = "<%=paySuccessFlag %>";
        var payway = "<%=payMethodFlag %>";

        if (!isEmpty(paySuccessFlag)) {

            //결제 실패 시
            if (paySuccessFlag == "FAIL") {
                alert("결제 요청이 실패하였습니다.");
            }
            //결제 성공 시
            else {
                if (payway == "3") {
                    alert("가상계좌 결제 건의 경우, 입금이 완료되어야 상품이 배송됩니다.");

                } else {
                    alert("성공적으로 결제가 완료되었습니다.");
                }
                opener.location.replace("Ordersuccess.aspx");
            }
            self.close();

        } else {
            alert("결제 요청이 실패하였습니다.");
            self.close();
        }
    }
</script>
</head>
<body>
    <div class="payfin_area">
        <div class="top">주문 <asp:Literal runat="server" ID="ltrResultTxt"></asp:Literal>
            <span>&nbsp;:&nbsp;
            [<asp:Literal ID="ResultCode" runat="server" />] <asp:Literal ID="ResultMsg" runat="server" /></span>
        </div>
        <div class="conwrap">
            <div class="con">
                <div class="tabletypea">
                    <table>
                        <colgroup>
                            <col style="width:40%" />
                            <col style="width:auto" />
                            <col style="width:15%" />
                            <col style="width:15%" />
                        </colgroup>
                        <%--<tr>
                            <th><span>결제 결과</span></th>
                            <td colspan="3">
                                [<asp:Literal ID="ResultCode" runat="server" />]
                                <asp:Literal ID="ResultMsg" runat="server" />
                            </td>
                        </tr>--%>
                        <tr>
                            <th>상품명</th>
                            <th>결제금액(VAT포함)</th>
                            <th>총 수량</th>
                            <th>결제수단</th>
                        </tr>
                        <tr>
                            <td>
                                <asp:Literal ID="GoodsName" runat="server" />
                            </td>
                            <td>
                                <asp:Literal ID="Amt" runat="server" />
                                원
                            </td>
                            <td>
                                <asp:Literal ID="TotGoodsQty" runat="server" />
                            </td>
                            <td>
                                <asp:Literal ID="PayMethodName" runat="server" />
                            </td>
                        </tr>

                    </table>
                </div>

                <br />
                <div class="top">주문 정보</div>

                <div class="tabletypea">
                    <table>
                        <colgroup>
                            <col style="width:40%" />
                            <col style="width:auto" />
                            <col style="width:15%" />
                            <col style="width:15%" />
                        </colgroup>

                        <tr>
                            <th><span>주문번호</span></th>
                            <td>
                                <asp:Literal ID="Moid" runat="server" />
                            </td>
                        </tr>
                        <tr>
                            <th><span>구매자명</span></th>
                            <td>
                                <asp:Literal ID="BuyerName" runat="server" />
                            </td>
                        </tr>
                        <tr>
                            <th><span>승인일시</span></th>
                            <td>
                                <asp:Literal ID="AuthDate" runat="server" />
                            </td>
                        </tr>

                        <asp:Panel ID="cardPanel" runat="server" Visible="false">
                            <tr>
                                <th><span>승인번호</span></th>
                                <td>
                                    <asp:Literal ID="AuthCode" runat="server" />
                                </td>
                            </tr>
                            <tr>
                                <th><span>발급사명</span></th>
                                <td>
                                    <asp:Literal ID="CardName" runat="server" />
                                </td>
                            </tr>
                            <tr>
                                <th><span>발급사코드</span></th>
                                <td>
                                    <asp:Literal ID="CardCode" runat="server" />
                                </td>
                            </tr>
                            <tr>
                                <th><span>매입사명</span></th>
                                <td>
                                    <asp:Literal ID="AcquCardName" runat="server" />
                                </td>
                            </tr>
                            <tr>
                                <th><span>매입사코드</span></th>
                                <td>
                                    <asp:Literal ID="AcquCardCode" runat="server" />
                                </td>
                            </tr>
                            <tr>
                                <th><span>할부기간</span></th>
                                <td>
                                    <asp:Literal ID="CardQuota" runat="server" />
                                </td>
                            </tr>
                            <tr>
                                <th><span>카드번호</span></th>
                                <td>
                                    <asp:Literal ID="CardNumber" runat="server" />
                                </td>
                            </tr>
                        </asp:Panel>
                        <asp:Panel ID="bankPanel" runat="server" Visible="false">
                            <tr>
                                <th><span>은행코드</span></th>
                                <td>
                                    <asp:Literal ID="BankCode" runat="server" />
                                </td>
                            </tr>
                            <tr>
                                <th><span>은행명</span></th>
                                <td>
                                    <asp:Literal ID="BankName" runat="server" />
                                </td>
                            </tr>
                            <tr>
                                <th><span>현금영수증 타입(0:발행안함,1:소득공제,2:지출증빙)</span></th>
                                <td>
                                    <asp:Literal ID="RcptType" runat="server" />
                                </td>
                            </tr>
                            <tr>
                                <th><span>현금영수증 승인번호</span></th>
                                <td>
                                    <asp:Literal ID="RcptAuthCode" runat="server" />
                                </td>
                            </tr>
                        </asp:Panel>
                        <asp:Panel ID="vbankPanel" runat="server" Visible="false">
                            <tr>
                                <th><span>가상계좌코드</span></th>
                                <td>
                                    <asp:Literal ID="VbankBankCode" runat="server" />
                                </td>
                            </tr>
                            <tr>
                                <th><span>가상계좌은행명</span></th>
                                <td>
                                    <asp:Literal ID="VbankName" runat="server" />
                                </td>
                            </tr>
                            <tr>
                                <th><span>가상계좌번호</span></th>
                                <td>
                                    <asp:Literal ID="VbankNum" runat="server" />
                                </td>
                            </tr>
                            <tr>
                                <th><span>가상계좌 입금만료일</span></th>
                                <td>
                                    <asp:Literal ID="VbankExpDate" runat="server" />
                                </td>
                            </tr>
                        </asp:Panel>
                    </table>
                </div>

            </div>
            <div class="btngroup">
                <%--<a href="#" class="btn_blue" onClick="nicepayClose();">세금계산서 수정</a>--%>
                <a href="#" class="btn_blue" onClick="fnPayResult()">완료하기</a>
            </div>
        </div>
    </div>
</body>
</html>
