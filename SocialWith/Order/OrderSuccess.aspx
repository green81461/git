<%@ Page Title="" Language="C#" MasterPageFile="~/Master/Default.master" AutoEventWireup="true" CodeFile="OrderSuccess.aspx.cs" Inherits="Order_OrderSuccess" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
  <link rel="stylesheet" href="../Content/Order/order.css" />

  <script>
      function fnGoPage(flag) {
          if (flag == "Order") {
              document.location.href = "../Order/OrderHistoryList.aspx";
          } else {
              document.location.href = "../Default.aspx";
          }
      }
  </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <div class="sub-contents-div"> 

        <table class="orderSuccess-table">
            <tr>
                <td>
                    <img src="../Images/Order/orderSuccessBg1.jpg" style="width:300px; height:200px;" />
                </td>
            </tr>
            <tr><td class="line1"><span>주문접수</span><span style="color:black;">가 정상적으로 완료되었습니다.</span></td></tr>
            <tr><td class="line2">(가상계좌 결제건의 경우 입금이 완료되어야 상품이 배송됩니다.)</td></tr>
            <tr><td class="line3">"이용해 주셔서 감사합니다."</td></tr>
            <tr>
                <td>
                    <input type="button" class="mainbtn type1" style="width: 117px; height: 30px; margin-right:-2px; font-size: 12px; background-color:#3e3e46;" value="주문조회" onclick="fnGoPage('Order'); return false;" />&nbsp;&nbsp;
                    <input type="button" id="btnSearch" class="mainbtn type1" style="width: 117px; height: 30px; font-size: 12px; background-color:#ee2248;" value="쇼핑계속하기" onclick="fnGoPage('Shop'); return false;" />
                </td>
            </tr>
        </table>
    </div>

</asp:Content>

