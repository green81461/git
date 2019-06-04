<%@ Page Language="C#" AutoEventWireup="true" CodeFile="OrderResultPrint.aspx.cs" Inherits="Print_OrderResultPrint" %>

<link href="../Content/Print/print.css" rel="stylesheet" />
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title></title>
    <style>
        th, td, label {
            font-size: 11px;
        }

        * {
            margin: 0;
            padding: 0
        }

        .auto-style1 {
            height: 30px;
        }
    </style>
    <script type="text/javascript" src="../Scripts/jquery-1.10.2.min.js"></script>
    <script type="text/javascript" src="../Scripts/common.js"></script>
    <script type="text/javascript" src="../Scripts/printThis.js"></script>

    <script type="text/javascript">
        function resize_window() {
            window.resizeTo(800, 500);
        }
        
        var qs = fnGetQueryStrings();
        var qsSaveAuthDate;  //승인일자
        var qsPayMethod;     //결제유형
        var qsMoid;          //주문번호
        var qsGoodsName;     //상품명
        var qsAmt;           //금액
        var qsVbankName;     //가상계좌 은행명
        var qsVbankNum;      //가상계좌 번호
        var qsVBANKDATE;     //가상계좌 입금 만료일
        var qsBuyerName;
        var qsSaleComName;


        $(function () {
            qsSaveAuthDate = qs['SaveAuthDate'];
            qsPayMethod = qs['PayMethod'];
            qsMoid = qs['Moid'];
            qsGoodsName = qs['GoodsName'];
            qsAmt = qs['Amt'];
            qsVbankName = qs['VbankName'];
            qsVbankNum = qs['VbankNum'];
            qsVBANKDATE = qs['VBANKDATE'];
            qsBuyerName = qs['BuyerName'];
            qsSaleComName = qs['SaleComName'];


            if (qsSaleComName != '') {

                $("#trSaleComName").css("display", "none");
            }

            else {
                $("#trSaleComName").css("display", "");
            }

            if (isEmpty(qsVBANKDATE)) {
                $("#trBankDate").css("display","none");
            } else {
                $("#trBankDate").css("display", "");
            }

            //결제유형 판단
            if (qsPayMethod == '여신 결제') {
                qsPayMethod = qsPayMethod + ' 정보 출력';
            }
            else if (qsPayMethod == '여신 결제(일반)') {
                var payName = qsPayMethod.split("(");
                qsPayMethod = payName[0] + ' 정보 출력';
            }

            else {
                qsPayMethod = qsPayMethod + '결제 정보 출력';
            }

            $('#SaveAuthDate').val(qsSaveAuthDate);
            $('#PayMethod').val(qsPayMethod);
            $('#BuyerName').val(qsBuyerName);
            $('#Moid').val(qsMoid);
            $('#GoodsName').val(qsGoodsName);
            $('#Amt').val(numberWithCommas(qsAmt));
            $('#BuyerName').val(qsBuyerName);

            $('#VbankName').val(qsVbankName);
            $('#VbankNum').val(qsVbankNum);
            $('#VBANKDATE').val(qsVBANKDATE);
            $('#SaleComName').val(qsSaleComName);



        })
        
        function fnPrint() {
            $('#printMain').printThis({
                importStyle: true,
                //  pageTitle: " ",  
            });

        }

        function closePopup() {
            self.close();
        }
        
    </script>
</head>


<body onload="javascript_:resize_window();">
    <form id="form1" runat="server">



        <div style="text-align: center;" id="printMain">

            <!--제목-->
            <div class="orderP-title-div" style="text-align: center">
                <%--  <img src="../Order/images/print-title.jpg" alt="출력"/>--%>
                <input type="text" name="PayMethod" id="PayMethod" readonly style="background-color: transparent; border: 0 solid black; text-align: center; width: 100%" />
            </div>

            <!--날짜-->
            <div class="time">
                <input type="text" name="SaveAuthDate" id="SaveAuthDate" readonly style="background-color: transparent; border: 0 solid black; text-align: right;" />
            </div>

            <!--테이블-->
            <table class="tblPrintOut">
                <tr id="trSaleComName">
                    <th>판매사 </th>
                    <td>
                        <input type="text" name="SaleComName" id="SaleComName" readonly style="background-color: transparent; width: 300px; border: 0 solid black; text-align: left;" />
                    </td>
                </tr>

                <tr>
                    <th class="auto-style1">주문번호 </th>
                    <td class="auto-style1">
                        <input type="text" name="Moid" id="Moid" readonly style="background-color: transparent; border: 0 solid black; width: 300px; text-align: left;" />
                    </td>
                </tr>

                <tr>
                    <th>상품명 </th>
                    <td>
                        <input type="text" name="GoodsName" id="GoodsName" readonly style="background-color: transparent; width: 300px; border: 0 solid black; text-align: left;" />
                    </td>
                </tr>

                <tr>
                    <th>금액 </th>
                    <td>
                        <input type="text" name="Amt" id="Amt" readonly style="background-color: transparent; border: 0 solid black; width: 300px; text-align: left;" /></td>
                </tr>

                <tr>
                    <th>입금계좌 은행명 </th>
                    <td>
                        <input type="text" name="VbankName" id="VbankName" readonly style="background-color: transparent; border: 0 solid black; text-align: left;" />
                    </td>
                </tr>

                <tr>
                    <th>입금계좌 번호</th>
                    <td>
                        <input type="text" name="VbankNum" id="VbankNum" readonly style="background-color: transparent; border: 0 solid black; text-align: left;" />
                    </td>
                </tr>

                <tr id="trBankDate">
                    <th>입금계좌 입금만료일</th>
                    <td>
                        <input type="text" name="VBANKDATE" id="VBANKDATE" readonly style="background-color: transparent; border: 0 solid black; text-align: left;" />
                    </td>
                </tr>
            </table>

            <!--입금자명-->
            <div class="sender" style="text-align: right">
                * 입금자 명 :   
              <input type="text" name="BuyerName" id="BuyerName" readonly style="background-color: transparent; border: 0 solid black; text-align: left; width: 80px;" /><br />
                <br />
                &nbsp;
            </div>

            <!--취소하기/인쇄하기버튼 -->

            <div class="orderRqs-bt-align1" style="margin: 0">

                <a onclick="closePopup();">
                    <img src="../Images/Order/cancleR-off.jpg" alt="취소하기" onmouseover="this.src='../Images/Order/cancleR-on.jpg'" onmouseout="this.src='../Images/Order/cancleR-off.jpg'" /></a>

                <a onclick="fnPrint(); return false;">
                    <img src="../Order/images/printBt-off.jpg" alt="인쇄하기" onmouseover="this.src='../Order/images/printBt-on.jpg'" onmouseout="this.src='../Order/images/printBt-off.jpg'" />
                </a>
            </div>

            <%--            <div class="orderP-bt-align" style="text-align: center; margin: 0">
                <a>
                    <img src="../Images/Order/cancleR-off.jpg" alt="취소하기" onclick="fnPayClose();" onmouseover="this.src='../Images/Order/cancleR-on.jpg'" onmouseout="this.src='../Images/Order/cancleR-off.jpg'" /></a>

                <a onclick="fnPrint(); return false;">
                    <img src="../Order/images/printBt-off.jpg" alt="인쇄하기" onmouseover="this.src='../Order/images/printBt-on.jpg'" onmouseout="this.src='../Order/images/printBt-off.jpg'" />
                </a>
            </div>--%>
        </div>
    </form>
</body>
</html>
1