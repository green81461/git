<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Master/AdminMasterPage.master" AutoEventWireup="true" CodeFile="OrderBillIssueCheckIssue.aspx.cs" Inherits="Admin_Order_OrderBillIssueCheckIssue" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <link href="../Content/Order/order.css" rel="stylesheet" />

    <script type="text/javascript">
        $(document).ready(function () {
            //달력
            $(function () {
                $("#txtSearchSdate").inputmask("9999-99-99");

                $("#txtSearchSdate").datepicker({
                    showAnimation: 'slideDown',
                    changeMonth: true,
                    changeYear: true,
                    showOn: 'button',
                    buttonImage:"../../Images/Goods/calendar.jpg",
                    buttonImageOnly: true,
                    dateFormat: "yy-mm-dd",
                    monthNamesShort: ["1월", "2월", "3월", "4월", "5월", "6월", "7월", "8월", "9월", "10월", "11월", "12월"],
                    dayNamesMin: ["일", "월", "화", "수", "목", "금", "토"],
                    showMonthAfterYear: true,
                });
                //현재날짜
                $("#txtSearchSdate").val($.datepicker.formatDate('yymmdd', new Date()));
                $("#txtSearchSdate").attr('placeholder', $.datepicker.formatDate('yy-mm-dd', new Date()));
            });

            $(function () {
                $("#txtSearchEdate").inputmask("9999-99-99");

                $("#txtSearchEdate").datepicker({
                    showAnimation: 'slideDown',
                    changeMonth: true,
                    changeYear: true,
                    showOn: 'button',
                    buttonImage:"../../Images/Goods/calendar.jpg",
                    buttonImageOnly: true,
                    dateFormat: "yy-mm-dd",
                    monthNamesShort: ["1월", "2월", "3월", "4월", "5월", "6월", "7월", "8월", "9월", "10월", "11월", "12월"],
                    dayNamesMin: ["일", "월", "화", "수", "목", "금", "토"],
                    showMonthAfterYear: true,
                });
                //현재날짜
                $("#txtSearchEdate").val($.datepicker.formatDate('yymmdd', new Date()));
                $("#txtSearchEdate").attr('placeholder', $.datepicker.formatDate('yy-mm-dd', new Date()));
            });
             
        });

        //페이지 이동
            function fnGoPage(pageVal) {
                switch (pageVal) {
                    case "GOODS":
                        window.location.href = "../Order/OrderBillIssueCheck?ucode=" + ucode;
                        break;
                    case "FINAL":
                        window.location.href = "../Order/OrderBillIssueCheckFinal?ucode=" + ucode;
                        break;
                     case "ISSUE":
                        window.location.href = "../Order/OrderBillIssueCheckIssue?ucode=" + ucode;
                        break;
                    default:
                        break;
                }
            }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">

        <div class="sub-contents-div">
            <!--제목 타이틀-->
           <div class="sub-title-div">
                <p class="p-title-mainsentence">
                   정산내역조회
                </p>
            </div>

            <!--탭메뉴-->
            <div class="div-main-tab" style="width: 100%; ">
                <ul>
                    <li class='tabOff' style="width: 185px;" onclick="fnTabClickRedirect('../BalanceAccounts/ProfitList');">
                         <a onclick="fnTabClickRedirect('../BalanceAccounts/ProfitList');">매출정산내역</a>
                    </li>
                   <%-- <li class='tabOff' style="width: 185px;" onclick="fnTabClickRedirect('ReturnList');">
                         <a onclick="fnTabClickRedirect('ReturnList');">반품내역</a>
                    </li>--%>
                    <li class='tabOn' style="width: 185px;" onclick="fnTabClickRedirect('OrderBillIssueCheck');">
                        <a onclick="fnTabClickRedirect('OrderBillIssueCheck');">전자세금계산서 발행내역</a>
                    </li>
                    <li class='tabOff' style="width: 185px;" onclick="fnTabClickRedirect('../BalanceAccounts/BillPayment');">
                         <a onclick="fnTabClickRedirect('../BalanceAccounts/BillPayment');">대금정산</a>
                    </li>
                </ul>
            </div>
            <!--하위 탭메뉴-->
            <div class="tab-display1">
                <div class="tab" style="margin-top: 10px">
                    <span class="subTabOff" style="width: 186px; height: 35px; cursor: pointer;" id="btnTab2" onclick="fnGoPage('GOODS')">발행</span>
                    <span class="subTabOff" style="width: 186px; height: 35px; cursor: pointer;" id="btnTab2" onclick="fnGoPage('FINAL')">최종 현황</span>
                    <span class="subTabOn" style="width: 186px; height: 35px; cursor: pointer;" id="btnTab1" onclick="fnGoPage('ISSUE')">이슈 현황</span>
                </div>
            </div>
            <!--상단영역 시작-->
            <div class="search-div">
                <table id="tblSearch" class="tbl_main">
                    <colgroup>
                        <col style="width:200px"/>
                        <col />
                        <col style="width:200px"/>
                        <col />
                    </colgroup>
                    <thead>
                        <tr>
                            <th colspan="4">정산 세금계산서 내역확인</th>
                        </tr>
                    </thead>
                    <tr>
                        <th>세금계산서 발행일자</th>
                        <td>
                            <input type="text" id="txtSearchSdate" class="calendar" maxlength="10" placeholder="2018-01-01">&nbsp;&nbsp;
                            -
                            &nbsp;&nbsp; <input type="text" id="txtSearchEdate" class="calendar" maxlength="10" placeholder="2018-01-01">
                        </td>
                        <th><label for="RMP">RMP</label> <input type="radio" name="division" value="RMP" checked> &nbsp&nbsp<label for="판매사">판매사</label> <input type="radio" name="division" value="판매사"></th>
                        <td>
                            <asp:TextBox ID="txtSaleCompName" runat="server" OnKeypress="return fnEnter();" CssClass="medium-size"></asp:TextBox>
                            <input Class="mainbtn type1" style="width:75px" type="button" value="검색">
                        </td>
                    </tr>

                </table>
            </div>
            <!--엑셀 저장-->
            <div class="bt-align-div">
                <asp:HiddenField runat="server" ID="hdUnumPayNoArr" />
                <asp:Button ID="btnExcelExport" runat="server" Width="95" Text="조회하기" CssClass="mainbtn type1"/>
            </div>

            <!--하단영역시작-->
            <div class="orderList-div" style="width: 100%;">
                <table id="tblProfitList" class="tbl_main">
                    <colgroup>
                        <col style="width:80px;"/>
                        <col style="width:150px;"/>
                        <col style="width:150px;"/>
                        <col style="width:150px;"/>
                        <col style="width:200px;"/>
                        <col style="width:200px;"/>
                        <col style="width:200px;"/>
                        <col style="width:150px;"/>
                        <col style="width:150px;"/>
                        <col style="width:150px;"/>
                    </colgroup>
                    <thead>
                        <tr>
                            <th class="text-center" rowspan="2">번호</th>
                            <th class="text-center">세금계산서 발행일자</th>
                            <th class="text-center" rowspan="2">판매사</th>
                            <th class="text-center" rowspan="2">RMP</th>
                            <th class="text-center" rowspan="2">세금계산서 발행정보</th>
                            <th class="text-center" rowspan="2">판매사<br>세금계산서<br>합계 발행금액</th>
                            <th class="text-center" rowspan="2">RMP<br>세금계산서<br>합계 발행금액</th>
                            <th class="text-center">세금계산서번호</th>
                            <th class="text-center">[면세]<br>계산서번호</th>
                            <th class="text-center" rowspan="2">세금계산서 구분</th>
                        </tr>
                        <tr>
                            <th>세금계산서 발행일자</th>
                            <th>세금계산서상세</th>
                            <th>[면세]<br>세금계산서상세</th>
                        </tr>
                    </thead>
                          <tbody id="tbodyList">
                        <tr>
                            <td class="text-center" colspan="13">리스트가 없습니다.</td>                     
                        </tr>     
                    </tbody>
                </table>
                <br />
                  <input type="hidden" id="hdTotalCount"/>
                <!-- 페이징 처리 -->   
                <div style="margin:0 auto; text-align:center">
                    <div id="pagination" class="page_curl" style="display:inline-block"></div> 
                </div>
          
        </div>

    </div>

</asp:Content>

