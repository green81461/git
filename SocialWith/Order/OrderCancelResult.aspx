<%@ Page Language="C#" AutoEventWireup="true" CodeFile="OrderCancelResult.aspx.cs" Inherits="Order_OrderCancelResult" %>

<!DOCTYPE html>

<html>
<head runat="server">
<title>주문 취소 결과</title>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=yes, target-densitydpi=medium-dpi" />
<link href="../Content/NicePay/import.css" rel="stylesheet" />
<link href="../Content/jquery-ui.css" rel="stylesheet" />
<script src="https://web.nicepay.co.kr/flex/js/nicepay_tr_utf.js"></script>
<script src="../Scripts/jquery-1.10.2.min.js"></script>
<script src="../Scripts/jquery-ui.min.js"></script>
<script src="../Scripts/common.js"></script>

<script type="text/javascript">
    function resize_window() {
        window.resizeTo(650, 620);
    }

    function fnOpenerReload() {
        opener.parent.location.replace("OrderHistoryList.aspx");
    }

    function fnPopClose() {
        opener.parent.location.replace("OrderHistoryList.aspx");
        self.close();
    }
</script>

</head>
<body>
    <div class="payfin_area">
        <div class="top">주문 취소 결과</div>
        <div class="conwrap">
            <div class="con">
                <div class="tabletypea">
                    <table>
                        <tr>
                            <th><span>거래 아이디</span></th>
                            <td><%=Tid%></td>
                        </tr>
                        <tr>
                            <th><span>결제 수단</span></th>
                            <td><%=PayMethod%></td>
                        </tr>         
                        <tr>
                            <th><span>결과 내용</span></th>
                            <td><%="["+ResultCode+"]"+ResultMsg%></td>
                        </tr>
                        <tr>
                            <th><span>취소 금액</span></th>
                            <td><%=CancelAmt%></td>
                        </tr>
                        <tr>
                            <th><span>취소일</span></th>
                            <td><%=CancelDate%></td>
                        </tr>
                        <tr>
                            <th><span>취소시간</span></th>
                            <td><%=CancelTime%></td>
                        </tr>
                    </table>
                </div>
            </div>
            <p>* 취소가 성공한 경우에는 다시 승인상태로 복구 할 수 없습니다.</p>
            <div class="btngroup">
                <a href="#" class="btn_blue" onClick="fnPopClose();">닫기</a>
            </div>
        </div>
    </div>
</body>
</html>
