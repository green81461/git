<%@ Page Language="C#" AutoEventWireup="true" CodeFile="OrderCardAllCancelResult.aspx.cs" Inherits="Admin_Order_OrderCardAllCancelResult" %>

<!DOCTYPE html>

<html>
<head runat="server">
    <title>카드 주문 전체 취소 결과</title>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=yes, target-densitydpi=medium-dpi" />
    <link rel="stylesheet" type="text/css" href="./css/import.css" />
    <link rel="stylesheet" href="../Content/Order/order.css" />
    <link rel="stylesheet" type="text/css" href="../Content/popup.css" />
    <link rel="stylesheet" type="text/css" href="../../Content/SiteInfo/SiteInfo.css" />
    <script type="text/javascript" src="../../Scripts/jquery-1.10.2.min.js"></script>
    <script src="../../Scripts/common.js"></script>

    <script type="text/javascript">
        function resize_window() {
            window.resizeTo(650, 520);
        }

        function fnOpenerReload() {
            opener.parent.location.replace("OrderHistoryList.aspx");
        }

        function fnPopClose() {
            self.close();
        }
    </script>
</head>
<body onload="javascript_:resize_window();" onbeforeunload="fnOpenerReload()">
<form id="cancelResultForm">
    <div class="payfin_area">
        <%--<div  style="margin-top:20px; margin-left:10px "><img src="../Images/Order/cancle1-title.jpg" alt="주문취소 내역"/></div>--%>
        <div class="top" style="margin-top:10px;"><h3 class="pop-title">카드 전체 주문취소 결과</h3></div>
        <div class="conwrap">
            <div class="con">
                <div class="tabletypea" >
                    <table class="cancleList-table" style="margin-top:20px; margin-bottom:10px;">
                        <colgroup>
                            <col style="width:30%" />
                        </colgroup>
                        <tr>
                            <th class="tbl-td">주문취소 결과
                                <input type="hidden" id="hdResultFlag" value="<%=statusFLAG %>" />
                            </th>
                            <td style="padding-left: 5px;"><%=resultContent%></td>
                        </tr>
                        <tr>
                            <th class="tbl-td">거래 아이디</th>
                            <td style="padding-left: 5px;"><%=Tid%></td>
                        </tr>
                        <tr>
                            <th class="tbl-td">결제 수단</th>
                            <td style="padding-left: 5px;"><%=PayMethod%></td>
                        </tr>
                        <tr>
                            <th class="tbl-td">결과 내용</th>
                            <td style="padding-left: 5px;"><%="["+ResultCode+"]"+ResultMsg%></td>
                        </tr>
                        <tr>
                            <th class="tbl-td">취소 금액</th>
                            <td style="padding-left: 5px;"><%=CancelAmt%></td>
                        </tr>
                        <tr>
                            <th class="tbl-td">취소일</th>
                            <td style="padding-left: 5px;"><%=CancelDate%></td>
                        </tr>
                        <%--<tr>
                            <th class="tbl-td">취소시간</th>
                            <td style="padding-left: 5px;"><%=CancelTime%></td>
                        </tr>--%>

                    </table>


                </div>
                <div  class="orderRqs-bt-align">
                    <%--<a onclick="fnPopClose()">
                        <img src="../Images/Order/confirm-off.jpg" alt="확인" onmouseover="this.src='../Images/Order/confirm-on.jpg'" onmouseout="this.src='../Images/Order/confirm-off.jpg'" /></a>--%>
                    <input type="button" class="commonBtn" style="width:95px; height:30px; font-size:12px" value="확인" onclick="fnPopClose();"/>
                </div>
                <br />
                <br />
                <br />
                <span style="padding-left:20px; font-size:12px;">
                * 취소가 성공한 경우에는 다시 승인상태로 복구 할 수 없습니다.</span>
            </div>
        </div>
    </div>
</form>
</body>
</html>
