<%@ Page Language="C#" AutoEventWireup="true" CodeFile="OrderCancelTest.aspx.cs" Inherits="Test_OrderCancelTest" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta charset="utf-8">
    <title>주문취소 수동 작업</title>
    <script type="text/javascript" src="../Scripts/jquery-1.10.2.min.js"></script>
    <script src="../Scripts/common.js"></script>

    <script type="text/javascript">
        var is_sending = false;

        $(document).ready(function () {

            vBanckCode();

            var buyPrice = $("input[name='CancelAmt1']").val();

            $("#CancelAmt1").val(numberWithCommas(buyPrice));


            //$(window).on("beforeunload", function () {
            //    $(opener.location).attr("href", "javascript:fnSearch(1);");
            //});
        });

        function vBanckCode() {
            var callback = function (response) {

                if (!isEmpty(response)) {

                    GetCommList(response);
                }
            };
            var svidUser = "";
            var param = {
                Code: "PAY", Channel: 2, Method: "GetCommList", Svid_User: svidUser
            };

            var beforeSend = function () { }
            var complete = function () { }
            
            JqueryAjax('Post', '../Handler/Common/CommHandler.ashx', true, false, param, 'json', callback, beforeSend, complete, false, '');


            //JajaxSessionCheck("Post", "../Handler/Common/CommHandler.ashx", param, "json", callback, svidUser);
            
        }

        function GetCommList(commList) {
            for (var item in commList) {

                var option = $("<option value=" + commList[item].Map_Type + "></option>").text(commList[item].Map_Name);


                $("#paybankName").append(option);

            }
        }


        function goCancel() {
            document.tranMgr.submit();
        }

        function fnCheck() {
            var CancelMsg = $("input[name='CancelMsg']").val();
            var VbankInputName = $("input[name='VbankInputName']").val();
            var vBankNum = $("input[name='vBankNum']").val();

            if (typeof VbankInputName != "undefined") {

                vBankNum = vBankNum.replace(/[^0-9]/g, '');

                //정규식으로 변환한거 넣기
                $("input[name='vBankNum']").val(vBankNum);

                if (VbankInputName == "") {

                    alert('예금주 명을 입력해주세요.')
                    return false;
                }

                if (vBankNum == "") {

                    alert('환불계좌를 입력해주세요')
                    return false;
                }
            }

            if (CancelMsg == "") {

                alert('취소 사유를 입력해주세요.')
                return false;
            }

            goCancelPay();
        }

        function goCancelPay() {
            var callback = function (response) {

                if (!isEmpty(response)) {
                    var codeNo = response.Result;
                    document.tranMgr.codeNo.value = codeNo;

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
            var Flag = $("input[name='Flag']").val();

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
                Flag: Flag,
                Method: "SaveOrderCancel"
            };
            
            var beforeSend = function () {
                is_sending = true;
            }
            var complete = function () {
                is_sending = false;
            }

            if (is_sending) return false;

            JqueryAjax('Post', '../Handler/OrderHandler.ashx', true, false, param, 'json', callback, beforeSend, complete, false, '');

            //JajaxSessionCheck('Post', '../Handler/OrderHandler.ashx', param, 'json', callback, '3e8937b8-100c-4c50-9473-c39a23eacaff');
            //실행하기 전에 위의 SVID_USER 값을 수정해야 함...
        }

        function fnOrderClose() {
            alert('취소 되었습니다.')
            self.close();
        }


        function resize_window() {
            var width = 670;
            var height = 640;
            var left = (window.screen.width / 2) - (width / 2);
            var top = (window.screen.height / 2) - (height / 2);
            window.resizeTo(width, height,100,20);
        }
        //팝업창 닫기
        function fnCancle() {
            $('.divpopup-layer-pakage').fadeOut();
        }

    
    </script>

</head>
<body>
    <form name="tranMgr" method="post" action="OrderCancelResultTest">
        <div class="canclefin_area">

                   

         
            <div class="top" style="margin-top:20px;">
                   
                <img src="../Images/Order/cancle-title.jpg" alt="주문취소 요청"/></div>
            <div class="conwrap">
                <div class="con">
                    <div class="tabletypea">
                        <table class="cancleRqs-table" style="margin-top:30px; margin-bottom:10px;">
                            <colgroup>
                                <col style="width:30%" />
                                
                                </colgroup>
                            <tr>
                                <th class="tbl-td">주문번호</th>
                                <td style="padding-left: 5px;">
                                    <input type="text" name="Moid" id="Moid" value="<%=OrderCodeNo%>" style="width:98%" readonly>
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
                             

                                    
                                </td>
                            </tr>

                            <tr>
                                <th class="tbl-td">주문일자</th>
                                <td style="padding-left: 5px;">
                                    <input type="text" name="EntryDate" value="<%=EntryDate%>" style="width:98%" readonly></td>
                            </tr>

                            <tr>
                                <th class="tbl-td">상품정보</th>
                                <td style="padding-left: 5px;">
                                    <input type="text" name="goodsinfo" value="<%=goodsinfo%>" style="width:98%" readonly></td>
                            </tr>

                            <tr>
                                <th class="tbl-td">모델명</th>
                                <td style="padding-left: 5px;">
                                    <input type="text" name="GoodsModel" value="<%=GoodsModel%>" style="width:98%" readonly></td>
                            </tr>

                            <tr>
                                <th class="tbl-td">수량</th>
                                <td style="padding-left: 5px;">
                                    <input type="text" name="qty" value="<%=Qty%>" readonly></td>
                            </tr>


                            <tr>
                                <th class="tbl-td">구매금액</th>
                                <td style="padding-left: 5px;">
                                    <input type="text" name="CancelAmt1" id="CancelAmt1" value="<%=GoodsSalePriceVat%> 원" readonly class="auto-style1"></td>
                            </tr>

                            <tr>
                                <th class="tbl-td">취소 사유</th>
                                <td style="padding-left: 5px;">
                                    <%--<input type="text" name="CancelMsg" value="반품(배송비 2,500원 제외)" style="border:1px solid #a2a2a2; height:24px; width:98%" placeholder="&nbsp;취소사유를 30자이내로 입력 하세요.">--%>
                                    <input type="text" name="CancelMsg" value="요청에 의한 취소" style="border:1px solid #a2a2a2; height:24px; width:98%" placeholder="&nbsp;취소사유를 30자이내로 입력 하세요.">
                                </td>
                            </tr>



                            <tr>
                            </tr>
                            <asp:Panel ID="vbankPanel" runat="server" Visible="false">
                                <tr>
                                    <th class="tbl-td">예금주명</th>
                                    <td style="padding-left: 5px;">
                                        <input type="text" name="VbankInputName" value="" style="border:1px solid #a2a2a2; height:70%; width:160px;"  placeholder="&nbsp;예금주명을 입력 하세요."></td>
                                </tr>
                                <tr>
                                    <th class="tbl-td">환급계좌번호</th>
                                    <td style="padding-left: 5px;">
                                        <input type="text" name="vBankNum" value="" style="border:1px solid #a2a2a2; height:70%;  width:160px; " placeholder="&nbsp;계좌번호을 입력 하세요."></td>
                                </tr>
                                <tr>
                                    <th class="tbl-td">환급계좌은행명</th>
                                    <td style="padding-left: 5px;">
                                        <select id="paybankName" name="paybankName" style="border:1px solid #a2a2a2;height:70%; "></select>

                                    </td>

                                </tr>
                            </asp:Panel>

                            <%--<asp:DropDownList runat="server" ID="paybankName" CssClass="input-drop"/>--%>
                        </table>
                    </div>
                </div>

                <span style="padding-left:25px; font-size:12px;">* 취소 요청시 상단의 모든 값을 입력 하세요.</span>
            <br/> 
                <span style="padding-left:25px; font-size:12px;">* 신용카드결제, 계좌이체, 가상계좌만 부분취소/부분환불이 가능합니다.</span>
                <div class="btngroup">
                  <%--  <a href="#" class="btn_blue" onclick="fnCheck();">요 청</a>--%>
<!--취소하기, 요청하기 버튼 -->
 <div class="orderRqs-bt-align">
                    <a>
                        <img src="../Images/Order/close-off.jpg" alt="닫기" onclick="fnOrderClose();" onmouseover="this.src='../Images/Order/close-on.jpg'" onmouseout="this.src='../Images/Order/close-off.jpg'" /></a>
                  <%--  <a class="btn_blue" onclick="fnCheck();">--%>
                         <a  onclick="fnCheck();">
                        <img src="../Images/Order/reqCan-off.jpg" alt="요청하기" onmouseover="this.src='../Images/Order/reqCan-on.jpg'" onmouseout="this.src='../Images/Order/reqCan-off.jpg'" /></a>
                   
                </div>


                </div>
            </div>
        </div>
    </form>
</body>
</html>
