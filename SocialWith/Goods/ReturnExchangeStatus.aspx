<%@ Page Language="C#" MasterPageFile="~/Master/Default.master" AutoEventWireup="true" CodeFile="ReturnExchangeStatus.aspx.cs" Inherits="Goods_ReturnExchangeStatus" %>

<%@ Register Src="~/UserControl/ucListControl.ascx" TagName="ListPager" TagPrefix="ucPager" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <style type="text/css">
        /* Style the tab */
        a {
            cursor: pointer;
        }

        div.tab {
            overflow: hidden;
        }

        .board-table th {
            border: 1px solid #a2a2a2
        }

        /* Create an active/current tablink class */
        .tabButton.active {
            background-color: #ccc;
        }

        /*소스용 css - 수정,삭제 불가!!*/
        .tab-display {
        }

        /* 임시용 */
        #tblHeader th, #tblHeader td {
            border: 1px solid #929292;
        }

        .imgStyle {
            margin-left: 10px;
        }

    </style>

    <script type="text/javascript">
        var is_sending = false;

        function fnCancelGo(el) {
            var trTag = $(el).parent().parent();
            var hdOrdStat = $(trTag).find("input:hidden[name='hdOrdStat']").val();


            if ((hdOrdStat != "501") && (hdOrdStat != "505")) {
                alert("반품/교환 신청이 진행 중이라 취소하실 수 없습니다.\n관리자에게 문의하시기 바랍니다.");
                return false;
            }

            var confirmReault = confirm("반품/교환 신청을 취소하시겠습니까?");

            if (confirmReault) {

                var hdUnumRtnChgNo = $(trTag).find("input:hidden[name='hdUnumRtnChgNo']").val();
                var hdRtnChgGubun = $(trTag).find("input:hidden[name='hdRtnChgGubun']").val();
                var hdUNumOrdNo = $(trTag).find("input:hidden[name='hdUNumOrdNo']").val();


                var callback = function (response) {

                    if ((response != '') && (response.Result != '')) {
                        alert("반품/교환 신청이 취소되었습니다.");

                        <%=Page.GetPostBackEventReference(btnStatSearch)%>;
                        //$("#statusDiv").load("ReturnExchangeStatus.aspx");

                        return false;
                    } else {
                        alert("오류가 발생했습니다. 관리자에게 문의하시기 바랍니다.");
                        return false;
                    }
                    return false;
                };

                var param = { UNumRtnChgNo: hdUnumRtnChgNo, UNumOrdNo: hdUNumOrdNo, RtnChgGubun: hdRtnChgGubun, S_User: '<%= Svid_User %>', Flag: 'RtnChgCancel' };

                var beforeSend = function () {
                    is_sending = true;
                }
                var complete = function () {
                    is_sending = false;
                }
                if (is_sending) return false;

                JajaxDuplicationCheck("Post", "../Handler/ReturnExchangeHandler.ashx", param, "json", callback, beforeSend, complete, true, '<%= Svid_User %>');
            }
        }

        function fnEnter() {
            if (event.keyCode == 13) {
                <%=Page.GetPostBackEventReference(btnStatSearch)%>;
                return false;
            }
            else
                return true;
        }

        //주문 상세 팝업 오픈
        function fnOdrDtlPopup(el) {
            var PopUp = $(el).parent().parent();

            var hdSvidU = $(PopUp).find("input:hidden[name='hdSvidUser']").val();
            var OdrCoNo = $(PopUp).find("input:hidden[name='hdOrderCodeNo']").val();
            var ChangeNo = $(PopUp).find("input:hidden[name='hdRtChangeNo']").val();

            var checkPop = $(PopUp).find("input:hidden[name='hdGubun']").val();
            $('#hdPopupGubun').val(checkPop);
            if (checkPop == '반품') {
                $('#trReturn').css('display', '');
                $('#trExchange').css('display', 'none');
                
                $('#popupTitle_1').css('display', '');
                $('#popupTitle_2').css('display', 'none');

                $('#tdPrint').text('반품증명 서류 출력');

            }

            if (checkPop == '교환') {
                $('#trReturn').css('display', 'none');
                $('#trExchange').css('display', '');

                $('#popupTitle_1').css('display', 'none');
                $('#popupTitle_2').css('display', '');

                $('#tdPrint').text('교환증명 서류 출력');
            }


            $('#hdPrintSvidUser').val(hdSvidU);
            $('#hdPrintOrderCodeNo').val(OdrCoNo);
            $('#hdReturnChangeNo').val(ChangeNo);


         <%-- var Svid_User = "<%=Svid_User%>";--%>

            var e = document.getElementById('ReturnDocDiv');

            if (e.style.display == 'block') {
                e.style.display = 'none';

            } else {
                e.style.display = 'block';
            }
        }

        //팝업창 닫기

        function fnCancel() {
            $('.divpopup-layer-package').fadeOut();
        }



        //거래명세서
        function fnStatementPopup() {
            if ($('#hdPrintOrderStaus').val() == '101') {
                alert('아직 입금전입니다.');
                return false;
            }
            
            var ReturnChangeNo = $('#hdReturnChangeNo').val();
            var svidUser = $('#hdPrintSvidUser').val();
            var pageName = '';
            if ($('#hdPopupGubun').val() == '반품') {
                pageName = 'ReturnStatementReport';
            }
            else {

                pageName = 'ExchangeStatementReport';
            }


            var url = '../../Print/' + pageName+'?ReturnChangeNo=' + ReturnChangeNo + '&SvidUser=' + svidUser + '';
            fnWindowOpen(url, '', 1200, 600, 'yes', 'no', 'no', 'no', 'yes', 'yes');
            //window.open(url, '', "height=600, width=1000,status=yes,toolbar=no,menubar=no,location=no,resizable=no");
        }

        //반품신청서
        function fnPopupReturnPrint() {

            var returnChangeNo = $('#hdReturnChangeNo').val();
            var svidUser = $('#hdPrintSvidUser').val();

            var url = '../../Print/ReturnApplicationReport?ReturnChangeNo=' + returnChangeNo + '&SvidUser=' + svidUser + '';

            //url, target, width, height, status, toolbar,  menubar, location, resizable, scrollbar
            fnWindowOpen(url, '', 1200, 600, 'yes', 'no', 'no', 'no', 'yes', 'yes');

            return false;

        }
         //교환신청서
        function fnPopupExchangePrint() {

            var returnChangeNo = $('#hdReturnChangeNo').val();
            var svidUser = $('#hdPrintSvidUser').val();

            var url = '../../Print/ExchangeApplicationReport?ReturnChangeNo=' + returnChangeNo + '&SvidUser=' + svidUser + '';

            //url, target, width, height, status, toolbar,  menubar, location, resizable, scrollbar
            fnWindowOpen(url, '', 1200, 600, 'yes', 'no', 'no', 'no', 'yes', 'yes');

            return false;
        }

        //세금계산서
        function fnTaxPopup() {
            alert('아직 발행 전입니다.');
            return false;
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">

    <div class="sub-contents-div">
        

          <div class="sub-title-div">
                <p class="p-title-mainsentence">
                    반품/교환<span class="span-title-subsentence">반품 및 교환을 할 수 있습니다.</span>
                </p>
        </div>

            <div class="tabHeaderWrap1" >
                 <a href='ReturnExchangeRequest.aspx' class='subTabOff' style="width:186px; height:35px;font-size:12px;">반품/교환 신청</a>
                 <a href='ReturnExchangeStatus.aspx' class='subTabOn' style="width:186px; height:35px;font-size:12px;">반품/교환 현황</a>
	         
            </div>
            <div class="clear"></div>
            <div class="statusDiv-text" style="display: block; padding-top:10px">* 주의사항 : 반품 물품 수령 후 반품완료(결제취소)가 진행됩니다.</div>

            <!--vat 포함-->
            <span style="color: #69686d; float: right; margin-top: 10px; padding-right: 20px; margin-bottom: 10px;">*<b style="color: #ec2029; font-weight: bold;"> VAT(부가세)포함 가격</b>입니다.</span>

            <div style="margin-top: -30px">
                <!--데이터 리스트 시작 -->
                <asp:ListView ID="lvStatusList" runat="server" ItemPlaceholderID="phItemList2">

                    <LayoutTemplate>
                        <table id="tblHeader" class="tbl_main">
                            <colgroup>
                                <col />
                                <col />
                                <col />
                                <col />
                                <col />
                                <col />
                                <col />
                                <col />
                                <col />
                                <col />
                                <col />
                                <col />
                                <col />
                                <col />
                                <col />
                                <col />
                                <col />
                            </colgroup>
                            <thead>
                                <tr>
                                    <th class="text-center" rowspan="2">번호</th>
                                    <th class="text-center" rowspan="2">구분</th>
                                    <th class="text-center">반품/교환날짜</th>
                                    <th class="text-center">주문날짜</th>
                                    <th class="text-center" rowspan="2">판매사</th>
                                    <th class="text-center" rowspan="2">상품정보</th>
                                    <th class="text-center" rowspan="2">상품금액<br />
                                        (수량)</th>
                                    <th class="text-center" rowspan="2">상품배송완료일</th>
                                    <th class="text-center" rowspan="2">결제현황</th>
                                    <th class="text-center" rowspan="2">반품/교환금액<br />
                                        (반품/교환수량)</th>
                                    <th class="text-center" rowspan="2">유형<br />
                                        (배송비)</th>
                                    <th class="text-center" rowspan="2">반품증빙서류</th>
                                    <th class="text-center" rowspan="2">취소</th>
                                </tr>
                                <tr class="board-tr-height">
                                    <th class="text-center">반품/교환번호</th>
                                    <th class="text-center">주문번호</th>
                                </tr>
                            </thead>
                            <tbody>
                                <asp:PlaceHolder ID="phItemList2" runat="server" />
                            </tbody>
                        </table>
                    </LayoutTemplate>
                    <ItemTemplate>
                        <tr class="board-tr-height">
                            <td class="txt-center" rowspan="2">
                                <%# Eval("Unum_ReturnChangeNo").ToString()%>

                                <input type="hidden" name="hdUnumRtnChgNo" value='<%# Eval("Unum_ReturnChangeNo").ToString()%>' />
                                <input type="hidden" name="hdRtnChgGubun" value='<%# Eval("ReturnChangeGubun").ToString()%>' />
                                <input type="hidden" name="hdUNumOrdNo" value='<%# Eval("Unum_OrderNo").ToString()%>' />
                                <input type="hidden" name="hdOrdStat" value='<%# Eval("OrderStatus").ToString()%>' />
                                <input type="hidden" name="hdSvidUser" value='<%# Eval("Svid_User").ToString()%>' />
                                <input type="hidden" name="hdOrderCodeNo" value='<%# Eval("OrderCodeNo").ToString()%>' />
                                <input type="hidden" name="hdRtChangeNo" value='<%# Eval("ReturnChangeCodeNo").ToString()%>' />
                                 <input type="hidden" name="hdGubun" value='<%# Eval("ReturnChangeGubun_Name").ToString()%>' />

                                <%--히든필드 정리--%>

                            </td>
                            <td class="txt-center" rowspan="2">
                                <%# Eval("ReturnChangeGubun_Name").ToString()%>
                            </td>
                            <td class="txt-center">
                                <%# ((DateTime)(Eval("RtnChg_EntryDate"))).ToString("yyyy-MM-dd")%>
                                <%-- <%# Eval("ReturnChangeCodeNo").ToString() %> 요기랑--%>
                            </td>
                            <td class="txt-center">
                                <%# ((DateTime)(Eval("EntryDate"))).ToString("yyyy-MM-dd")%>
                            </td>
                            <td class="txt-center" rowspan="2">
                                <%# Eval("OrderSaleCompanyName").ToString()%>
                            </td>
                            <td rowspan="2">
                                <asp:Image runat="server" ID="imgGoods" Width="50" Height="50" ImageUrl='<%# String.Format("/GoodsImage/{0}/{1}/{2}/{3}", Eval("GoodsFinalCategoryCode") , Eval("GoodsGroupCode"), Eval("GoodsCode"), Eval("GoodsFinalCategoryCode").ToString() + "-" + Eval("GoodsGroupCode") + "-" + Eval("GoodsCode") + "-" + "sss.jpg")%>' onerror="this.onload = null; this.src='/Images/noImage_s.jpg';" CssClass="imgStyle" />
                                <div style="float: right; width: 70%">
                                    <span style="display: inline-block"><%# Eval("GoodsCode").ToString() %></span><br />
                                    [<%# Eval("BrandName").ToString() %>]&nbsp;<%# Eval("GoodsFinalName").ToString() %><br /><span style="color: #368AFF"><%# Eval("GoodsOptionSummaryValues").ToString() %></span></div>
                            </td>
                            <td class="txt-center" rowspan="2">
                                <%# String.Format("{0:##,##0;}", Eval("GoodsTotalSalePriceVat")) %> 원
                                <br />
                                (<%# Eval("Qty").ToString()%>)
                            </td>
                            <td class="txt-center" rowspan="2">
                                <%# ((DateTime)(Eval("DeliveryDate"))).ToString("yyyy-MM-dd")%>
                            </td>
                            <td class="txt-center" rowspan="2">
                                <%# Eval("OrderStatus_Name").ToString()%>
                            </td>
                            <td class="txt-center" rowspan="2">
                                <%# String.Format("{0:##,##0;}", Eval("ReturnChangePrice")) %> 원<br />
                                (<%# Eval("ReturnChangeQty").ToString()%>)
                            </td>
                            <td class="txt-center" rowspan="2">
                                <%# Eval("ReturnChangeType_Name").ToString().Substring(0,Eval("ReturnChangeType_Name").ToString().Length-1)%>
                                <br />
                                (<%# Eval("ReturnChangeDeliveryGubun_Name").ToString()%>)
                            </td>
                            <td class="txt-center" rowspan="2">
                                <a onclick="fnOdrDtlPopup(this); return false;">
                                    <img src="../Images/Order/submit-on.jpg" alt="확인" onmouseover="this.src='../Images/Order/submit-off.jpg'" onmouseout="this.src='../Images/Order/submit-on.jpg'"></a>
                            </td>
                            <td class="txt-center" rowspan="2">
                                <a onclick="fnCancelGo(this); return false;">
                                    <img src="../Images/Order/cancleh-on.jpg" alt="취소" onmouseover="this.src='../Images/Order/cancleh-off.jpg'" onmouseout="this.src='../Images/Order/cancleh-on.jpg'"></a>
                            </td>
                        </tr>
                        <tr>
                            <td class="txt-center" style="height: 40px">
                                <%-- <%# ((DateTime)(Eval("RtnChg_EntryDate"))).ToString("yyyy-MM-dd")%>--%>
                                <%# Eval("ReturnChangeCodeNo").ToString() %> 
                            </td>
                            <td class="txt-center">
                                <%# Eval("OrderCodeNo").ToString()%>
                            </td>
                        </tr>
                    </ItemTemplate>
                    <EmptyDataTemplate>
                        <table class="tbl_main">
                            <colgroup>
                                <col />
                                <col />
                                <col />
                                <col />
                                <col />
                                <col />
                                <col />
                                <col />
                                <col />
                                <col />
                                <col />
                                <col />
                                <col />
                                <col />
                                <col />
                                <col />
                                <col />
                                <col />
                            </colgroup>
                            <thead>
                                <tr>
                                    <th class="text-center">번호</th>
                                    <th class="text-center">구분</th>
                                    <th class="text-center">반품/교환날짜</th>
                                    <th class="text-center">반품/교환번호</th>
                                    <th class="text-center">주문번호</th>
                                    <th class="text-center">주문날짜</th>
                                    <th class="text-center">판매사</th>
                                    <th class="text-center">상품코드</th>
                                    <th class="text-center">상품정보</th>
                                    <th class="text-center">주문수량</th>
                                    <th class="text-center">주문금액</th>
                                    <th class="text-center">배송완료일</th>
                                    <th class="text-center">결제현황</th>
                                    <th class="text-center">반품/교환<br />
                                        수량</th>
                                    <th class="text-center">반품/교환<br />
                                        금액</th>
                                    <th class="text-center">유형</th>
                                    <th class="text-center">배송비</th>
                                    <th class="text-center">취소</th>
                                </tr>
                            </thead>
                            <tr class="board-tr-height">
                                <td colspan="18" class="txt-center">조회된 데이터가 없습니다.</td>
                            </tr>
                        </table>
                    </EmptyDataTemplate>
                </asp:ListView>
                <!--데이터 리스트 종료 -->

                <!--페이징-->
                <div style="margin: 0 auto; text-align: center">
                    <ucPager:ListPager ID="ucListPager" runat="server" OnPageIndexChange="ucListPager_PageIndexChange" PageSize="20" />
                </div>
                <!--페이징 끝-->
            </div>

            <div class="bottom-search-div">
                <table class="board-search-table">
                    <tr>
                        <td>
                            <asp:DropDownList ID="ddlSearchTarget" runat="server">
                                <asp:ListItem Text="브랜드" Value="BRANDNAME"></asp:ListItem>
                                <asp:ListItem Text="상품명" Value="GOODSFINALNAME"></asp:ListItem>
                                <asp:ListItem Text="모델명" Value="GOODSMODEL"></asp:ListItem>
                                <asp:ListItem Text="상품코드" Value="GOODSCODE"></asp:ListItem>
                                <asp:ListItem Text="판매사명" Value="SALECOMPANY_NAME"></asp:ListItem>
                            </asp:DropDownList>
                        </td>
                        <td>
                            <asp:TextBox ID="txtSearch" runat="server" Onkeypress="return fnEnter();" Width="690px"></asp:TextBox>
                        </td>
                        <td style="width: 95px; height: 30px; float: left; margin-top: 15px; margin-left: 10px;">
                            <%--검색 버튼--%>
                            <%--<asp:Button ID="btnStatSearch" runat="server" CssClass="board-search-btn" OnClick="btnStatSearch_Click" />--%>
                            <asp:Button ID="btnStatSearch" runat="server" OnClick="btnStatSearch_Click" Text="검색" CssClass="mainbtn type1" Width="95" Height="30"/>
                        </td>
                    </tr>
                </table>
            </div>
       
    </div>

    <div id="ReturnDocDiv" class="popupdiv divpopup-layer-package" >
        <div class="popupdivWrapper" style="width:650px; height:350px">
            <div class="popupdivContents">
                <div class="divpopup-layer-container" >
                    <div class="close-div">
                        <a onclick="fnCancel()" style="cursor: pointer">
                            <img src="../../Images/Wish/icon-delete.jpg" alt="닫기" style="float: right;" /></a>
                    </div>

                    <img src="../Images/Goods/returnDoc-title.jpg" style="margin-top: 20px; margin-bottom: 30px" id="popupTitle_1" alt="반품증빙서류"/>
                    <img src="../Images/Goods/exchangeDoc-title.jpg" style="margin-top: 20px; margin-bottom: 30px" id="popupTitle_2" alt="교환증빙서류"/>
                    <input type="hidden" id="hdPopupGubun" />
                   


                    <div class="divpopup-layer-conts">
                        <table style="width: 100%" class="tbl_popup">
                            <tr>
                                <th style="width: 100px" colspan="2" id="tdPrint">
                                </th>
                            </tr>

                            <tr id="trReturn" class="board-tr-height" style="display:none">
                                <th class="txt-center" style="width: 200px">반품신청서
                                </th>
                                <td class="txt-center" style="width: 100px">
                                    <asp:ImageButton runat="server" ID="btn1" ImageUrl="../Images/Goods/rd1.jpg" OnClientClick="fnPopupReturnPrint(); return false"></asp:ImageButton>
                                </td>
                            </tr>

                               <tr id="trExchange" class="board-tr-height" style="display:none">
                                <th class="txt-center" style="width: 200px">교환신청서
                                </th>
                                <td class="txt-center" style="width: 100px">
                                    <asp:ImageButton runat="server" ID="ImageButton1" ImageUrl="../Images/Goods/r7.jpg" AlternateText="교환신청서" OnClientClick="fnPopupExchangePrint(); return false"></asp:ImageButton>
                                </td>
                            </tr>

                            <tr class="board-tr-height">
                                <th class="txt-center">거래명세서
                                </th>
                                <td class="txt-center" style="width: 100px">
                                    <a>
                                        <%-- <img src="" alt="거래명세서" onclick="fnStatementPopup(); return false;" />--%>
                                        <img src="../Images/Goods/rd2.jpg" onclick="fnStatementPopup(); return false;" />
                                    </a>
                                    <input type="hidden" id="hdPrintOrderCodeNo" />
                                    <input type="hidden" id="hdPrintOrderStaus" />
                                    <input type="hidden" id="hdPrintSvidUser" />
                                    <input type="hidden" id="hdPrintTaxYn" />
                                    <input type="hidden" id="hdBillNo" />
                                    <input type="hidden" id="hdMD5" />
                                    <input type="hidden" id="hdReturnChangeNo" />
                                    <input type="hidden" id="hdzBillNo" />
                                    <input type="hidden" id="hdzMD5" />

                                    <%--    <asp:imageButton runat="server" ID="btn2" imageUrl="../Images/Goods/rd2.jpg"></asp:imageButton>--%>
                                </td>
                            </tr>

                            <tr class="board-tr-height" style="display:none">
                                <th class="txt-center">납품확인서
                                </th>
                                <td class="txt-center" style="width: 100px">
                                    <asp:ImageButton runat="server" ID="btn3" ImageUrl="../Images/Goods/rd3.jpg"></asp:ImageButton>
                                </td>
                            </tr>

                            <tr class="board-tr-height" style="display:none">
                                <th class="txt-center">카드명세표
                                </th>
                                <td class="txt-center" style="width: 100px">
                                    <asp:ImageButton runat="server" ID="Button1" ImageUrl="../Images/Goods/rd4.jpg"></asp:ImageButton>
                                </td>
                            </tr>

                            <tr class="board-tr-height" style="display:none">
                                <th class="txt-center">영수증
                                </th>
                                <td class="txt-center" style="width: 100px">
                                    <asp:ImageButton runat="server" ID="Button2" ImageUrl="../Images/Goods/rd5.jpg"></asp:ImageButton>
                                </td>
                            </tr>

                            <tr class="board-tr-height">
                                <th class="txt-center">세금계산서
                                </th>
                                <td class="txt-center" style="width: 100px">
                                    <asp:ImageButton runat="server" ID="Button3" ImageUrl="../Images/Goods/rd6.jpg" OnClientClick="return fnTaxPopup();"></asp:ImageButton>
                                </td>
                            </tr>

                        </table>

                        <br />
                        <br />
                        <div style="text-align:right">
                            <input type="button" id="btnTab1" class="mainbtn type1" style="width:95px; height:30px; font-size:12px" value="취소" onclick="fnCancel();"/>
                        </div>
                       <%-- <a onclick="fnCancel()" style="cursor: pointer;">
                            <img src="../Admin/Images/Company/cancleB-off.jpg" alt="취소" style="float: right;" onmouseover="this.src='../Admin/Images/Company/cancleB-on.jpg'" onmouseout="this.src='../Admin/Images/Company/cancleB-off.jpg'" /></a>--%>



                    </div>
                </div>
            </div>
        </div>
    </div>










</asp:Content>
