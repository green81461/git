<%@ Page Language="C#" AutoEventWireup="true" CodeFile="OrderCancelResultTest.aspx.cs" Inherits="Test_OrderCancelResultTest" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
    <title></title>
    <link href="../Content/Order/order.css" rel="stylesheet" />
    <script>
        function resize_window() {
            window.resizeTo(650, 620);
        }

        function fnOpenerReload() {
            //opener.parent.location.replace("OrderHistoryList.aspx");
        }

        function fnPopClose() {
            //opener.parent.location.replace("OrderHistoryList.aspx");
            //self.close();
        }
    </script>
</head>
<body>
    <div class="payfin_area">
        <div  style="margin-top:20px; margin-left:10px "><img src="../Images/Order/cancle1-title.jpg" alt="주문취소 내역"/></div>
        <div class="conwrap">
            <div class="con">
                <div class="tabletypea" >
                    <table class="cancleList-table" style="margin-top:20px; margin-bottom:10px;">
                    
                         <colgroup>
                                <col style="width:30%" />
         
                            </colgroup>
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
                        <tr>
                            <th class="tbl-td">취소시간</th>
                            <td style="padding-left: 5px;"><%=CancelTime%></td>
                        </tr>
               <%--<tr>
                        <th><span>굿즈파이널</span></th>
                        <td><%=GoodsFinalCategoryCode%></td>
                        </tr>--%>


                    </table>
                    <%--<input type="hidden" name="OrderCodeNo" value="<%=OrderCodeNo%>" />
                    <input type="hidden" name="OrderCodeNo" value="<%=Svid_User%>" />--%>


                </div>
                <div  class="orderRqs-bt-align">
                <a onclick="fnPopClose()" >
              <img src="../Images/Order/confirm-off.jpg" alt="확인" onmouseover="this.src='../Images/Order/confirm-on.jpg'" onmouseout="this.src='../Images/Order/confirm-off.jpg'" /></a>
            </div>
            <br />
            <br />
            <br />
            <span style="padding-left:20px; font-size:12px;">
            * 취소가 성공한 경우에는 다시 승인상태로 복구 할 수 없습니다.</span>
        </div>
    </div>
        </div>
</body>
</html>
