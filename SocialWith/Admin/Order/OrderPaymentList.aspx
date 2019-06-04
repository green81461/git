<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Master/AdminMasterPage.master" AutoEventWireup="true" CodeFile="OrderPaymentList.aspx.cs" Inherits="Admin_Order_OrderPaymentList" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <link href="../../AdminSub/Contents/Order/order.css" rel="stylesheet" />

    <script>
        $(document).ready(function () {
            var date = new Date();
            var firstDate = new Date(date.getFullYear(), date.getMonth(), 1);
            
            //검색창에서 달력 관련 기능
            $("#<%=this.txtSearchSdate.ClientID%>").datepicker({
                showAnimation: 'slideDown',
                changeMonth: true,
                changeYear: true,
                showOn: 'button',
                buttonImage: "../../Images/Goods/calendar.jpg",
                buttonImageOnly: true,
                dateFormat: "yy-mm-dd",
                monthNamesShort: ["1월", "2월", "3월", "4월", "5월", "6월", "7월", "8월", "9월", "10월", "11월", "12월"],
                dayNamesMin: ["일", "월", "화", "수", "목", "금", "토"],
                showMonthAfterYear: true,
            });


            //$("#searchEndDate").val((new Date()).yyyymmdd());
            $("#<%=this.txtSearchEdate.ClientID%>").datepicker({
                showAnimation: 'slideDown',
                changeMonth: true,
                changeYear: true,
                showOn: 'button',
                buttonImage: "../../Images/Goods/calendar.jpg",
                buttonImageOnly: true,
                dateFormat: "yy-mm-dd",
                monthNamesShort: ["1월", "2월", "3월", "4월", "5월", "6월", "7월", "8월", "9월", "10월", "11월", "12월"],
                dayNamesMin: ["일", "월", "화", "수", "목", "금", "토"],
                showMonthAfterYear: true,
            });

            // enter key 방지
            $(document).on("keypress", "#tblSearch input", function (e) {
                if (e.keyCode == 13) {
                    return false;
                }
                else
                    return true;
            });
        });

        //날짜설정 버튼 클릭 시
        function fnSetSearchDate() {
            alert("추후 개발예정입니다.");
            return false;
        }

        //적용 버튼 클릭 시
        function fnUpdateStat() {
            alert("추후 개발예정입니다.");
            return false;
        }

        //조회하기 버튼 클릭 시
        function fnSearchList() {
            alert("조회하기");
            return false;
        }
    </script>

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">

    <div class="all">
        <div class="sub-contents-div">
            <!--제목 타이틀-->
            <div class="sub-title-div">
                <img src="../Images/Order/payList-title.jpg" alt="대금결제 내역관리" />
            </div>
          
            <!--상단영역 시작-->
            <div class="search-div">
                <table id="tblSearch">
                    <thead>
                        <tr>
                            <th colspan="12" style="height: 40px;">대금결제 현황</th>
                        </tr>
                    </thead>


                    <tr>
                        <th rowspan="2" style="width: 180px;">주문일</th>
                        <td colspan="3" rowspan="2" style="text-align: left; padding-left: 5px;">
                            <asp:TextBox ID="txtSearchSdate" runat="server" CssClass="calendar" ReadOnly="true" Height="24px"></asp:TextBox>&nbsp;&nbsp;
                            -
                            &nbsp;&nbsp;<asp:TextBox ID="txtSearchEdate" runat="server" CssClass="calendar" ReadOnly="true" Height="24px"></asp:TextBox>&nbsp;&nbsp;
                            <%--<input type="checkbox" id="ckbSearch1" value="1" checked="checked" /><label for="ckbSearch1">1일</label>
                            <input type="checkbox" id="ckbSearch2" value="7" /><label for="ckbSearch2">7일</label>
                            <input type="checkbox" id="ckbSearch3" value="15" /><label for="ckbSearch3">15일</label>
                            <input type="checkbox" id="ckbSearch4" value="30" /><label for="ckbSearch4">30일</label>
                            <input type="checkbox" id="ckbSearch5" value="90" /><label for="ckbSearch5">90일</label>--%>

                            <a onclick="fnSetSearchDate()"><img alt="날짜설정" src="../Images/Order/date-off.jpg" id="btnDateSet" /></a>
                        </td>
                        <th style="width: 180px;">판매사</th>
                        <td style="width: 250px;">
                            <asp:TextBox ID="txtSaleCompName" runat="server" Height="100%" OnKeypress="return fnEnter();" Width="98%" Style="border: 1px solid #a2a2a2;"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <th style="width: 180px;">구매사</th>
                        <td style="width: 250px;">
                            <asp:TextBox ID="txtBuyerCompName" runat="server" Height="100%" OnKeypress="return fnEnter();" Width="98%" Style="border: 1px solid #a2a2a2;"></asp:TextBox>
                        </td>
                    </tr>
                </table>
            </div>
            <!--상단영역 끝-->

            <!--조회하기 버튼-->
            <div class="bt-align-div">
                <a onclick="fnSearchList(); return false;">
                    <img alt="조회하기" src="../../Images/Goods/aslist.jpg" id="btnSearch" onmouseover="this.src='../../Images/Wish/aslist-over.jpg'" onmouseout="this.src='../../Images/Goods/aslist.jpg'" /></a>
                <a onclick="fnUpdateStat(); return false;"><img alt="적용" src="../Images/Member/appl-off.jpg" id="btnDateSet" onmouseover="this.src='../Images/Member/appl-on.jpg'" onmouseout="this.src='../Images/Member/appl-off.jpg'" /></a>
            </div>

            <!--하단영역시작-->
            <div class="orderList-div" style="width: 100%;">
                <%--  <table  id="tblorderList" style="border:1px solid #a2a2a2;width:2850px;height:40px;">--%>
                <table id="tblProfitList" style="width: 100%">
                    <thead>
                        <tr>
                            <th class="text-center" style="width: 100px">
                                &nbsp;&nbsp;<input type="checkbox" id="ckbListAll" />&nbsp;&nbsp;
                            </th>
                            <th class="text-center" style="width: 100px">주문일자</th>
                            <th class="text-center" style="width: 100px">주문번호</th>
                            <th class="text-center" style="width: 120px">구매사</th>
                            <th class="text-center" style="width: 120px">판매사</th>
                            <th class="text-center" style="width: 250px">상품명<br />(수량)</th>
                            <th class="text-center" style="width: 120px">결제금액</th>
                            <th class="text-center" style="width: 120px">상태</th>
                            <th class="text-center" style="width: 120px">취소</th>
                        </tr>
                    </thead>
                    <tbody id="tbodyOrderList">
                    </tbody>
                </table>

            </div>

            <!--하단영역끝-->

        </div>

        <%--주문상세 팝업 시작--%>
        <div id="productDiv" class="divpopup-layer-package">

            <div class="productWrapper">
                <div class="productContent" style="border: none;">

                    <div class="sub-title-div">
                        <img src="../../Images/Order/orderProduct-title.jpg" />
                    </div>

                    <%--<div class="mini-title">
                    <img src="../Images/Order/subOrder.jpg" alt="주문내역" /></div>--%>
                    <div style="text-align: right;">구매사 결제금액:<label id="lbPrice"></label>원</div>

                    <div class="tblOrder-div" style="height: 270px; width: 100%; overflow-y: auto; overflow-x: hidden;">
                        <table id="tblOrder">
                            <thead>
                                <tr>
                                    <th style="width: 80px;">구매사</th>
                                    <th style="width: 270px;">주문상품정보</th>
                                    <th style="width: 60px;">모델명</th>
                                    <th style="width: 70px;">상품단가<br />
                                        (VAT포함)</th>
                                    <th style="width: 40px;">수량</th>
                                    <th style="width: 70px;">주문금액<br />
                                        (VAT포함)</th>
                                    <th style="width: 70px;">출하예정일</th>

                                    <th style="width: 60px;">주문처리현황</th>
                                    <th style="width: 60px;">결제현황</th>
                                </tr>
                                <tr>
                                    <th>내용량</th>
                                    <th>배송완료일</th>
                                </tr>
                            </thead>
                            <tbody id="tbody_pop_odrDtl"></tbody>
                        </table>
                    </div>

                    <%--<div class="mini-title">
                    <img src="../Images/Order/subPay.jpg" alt="결제내역" />
                </div>--%>
                    <div id="divDtlPop_1">
                        <table id="tbl_dtlPop_pay"></table>
                    </div>

                    <br />

                    <%-- <a onclick="fnCancel('divPopup')">확인</a>--%>

                    <a style="float: right;">
                        <img src="../../Images/Goods/sub-off.jpg" alt="확인" onclick="fnCancel('divPopup')" onmouseover="this.src='../../Images/Goods/sub-on.jpg'" onmouseout="this.src='../../Images/Goods/sub-off.jpg'" /></a>

                    <%--<a onclick="fnSubmit(); return false;">확인</a>--%>
                </div>
            </div>
        </div>
        <%--주문상세 팝업 끝--%>
    </div>

</asp:Content>

