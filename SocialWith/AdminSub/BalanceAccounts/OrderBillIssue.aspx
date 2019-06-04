<%@ Page Title="" Language="C#" MasterPageFile="~/AdminSub/Master/AdminSubMaster.master" AutoEventWireup="true" CodeFile="OrderBillIssue.aspx.cs" Inherits="AdminSub_BalanceAccounts_OrderBillIssue" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
     <link href="../Contents/Order/order.css" rel="stylesheet" />
    <style>
  .sub-tab-div a:nth-child(1) {
        margin-left:0;
    }

    .sub-tab-div a:nth-child(2) {
        margin-left: -2.5px;
    }

    .sub-tab-div a:nth-child(3) {
        margin-left: -2.5px;
    }


    .sub-tab-div a:nth-child(4) {
        margin-left: -2px;
    }
    .sub-tab-div a:nth-child(5) {
        margin-left: -3px;
    }
  
    </style>
     <script>
           var qs = fnGetQueryStrings();
        var ucode = qs["ucode"];
         $(document).ready(function () {
             var date = new Date();
             var firstDate = new Date(date.getFullYear(), date.getMonth()-1, 1);
             var lastDate = new Date(date.getFullYear(), date.getMonth(), 0);

             $("#<%=this.txtSearchSdate.ClientID%>").val(firstDate.yyyymmdd());
             $("#<%=this.txtSearchEdate.ClientID%>").val(lastDate.yyyymmdd());

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
                disabled: true
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
                disabled: true
            });

            // enter key 방지
            $(document).on("keypress", "#tblSearch input", function (e) {
                if (e.keyCode == 13) {
                    return false;
                }
                else
                    return true;
             });

             $('.div-main-tab > ul > li').click(function () {
                if ($(this).attr('id') == 'libs') {
                    $(this).attr('onClick', "location.href='BalanceSummary.aspx?ucode="+ucode+"'");
                    $(this).find('a').attr('href', 'BalanceSummary.aspx?ucode='+ucode+'');
                }
                else if ($(this).attr('id') == 'lipl') {
                    $(this).attr('onClick', "location.href='ProfitList.aspx?ucode="+ucode+"'");
                    $(this).find('a').attr('href', 'ProfitList.aspx?ucode='+ucode+'');
                }
                else if ($(this).attr('id') == 'lirl') {
                    $(this).attr('onClick', "location.href='ReturnList.aspx?ucode="+ucode+"'");
                    $(this).find('a').attr('href', 'ReturnList.aspx?ucode='+ucode+'');
                }
                else if ($(this).attr('id') == 'liob') {
                    $(this).attr('onClick', "location.href='OrderBillIssue.aspx?ucode="+ucode+"'");
                    $(this).find('a').attr('href', 'OrderBillIssue.aspx?ucode='+ucode+'');
                }
            })
         });


         //조회하기
         function fnSearch() {
            var startDate = $('#<%= txtSearchSdate.ClientID%>').val();
            var endDate = $('#<%= txtSearchEdate.ClientID%>').val();
            var i = 1;
            var asynTable = "";

            var callback = function (response) {
                $("#tblProfitList tbody").empty();
                if (!isEmpty(response)) {
                    var index = 1;
                    $.each(response, function (key, value) {

                        var mainCode = value.MainCodeNo.substring(0, 2);
                        var gubunFlag = ''; //주문:*, A/S:#, 반품:@

                        switch (mainCode) {
                            case "ON":
                                gubunFlag = '*';
                                break;
                            case "R-":
                                gubunFlag = '@';
                                break;
                            default:
                        }
                      
                        asynTable += "<tr>"
                        asynTable += "<td rowspan='2' style='border-right:1px solid #a2a2a2' class='txt-center'>" + index + "<input type='hidden' id='hdSeqNo" + index + "' value='" + value.Unum_SeqNo +"'/></td>";
                        asynTable += "<td rowspan='2' style='border-right:1px solid #a2a2a2' class='txt-center'>" + gubunFlag + fnOracleDateFormatConverter(value.PayConfirmDate) + "</td>";
                        asynTable += "<td style='border:1px solid #a2a2a2;' class='txt-center'>" + gubunFlag + fnOracleDateFormatConverter(value.EntryDate) + "</td>";
                        asynTable += "<td rowspan='2' style='border:1px solid #a2a2a2;' class='txt-center'>" + value.BuyComp_Name + "</td>";
                        asynTable += "<td rowspan='2' style='border:1px solid #a2a2a2;' class='txt-center'>" + gubunFlag + value.GoodsFinalName + "<br/>수량: " + value.GoodsQty  + "</td>";
                        asynTable += "<td style='text-align:center'> " + value.GoodsModel + "</td >";
                        asynTable += "<td  rowspan='2' style='border:1px solid #a2a2a2; text-align:right; padding-left:3px'>" + gubunFlag + numberWithCommas(value.CustAmt) + "원</td>";
                        asynTable += "<td rowspan='2' style='border:1px solid #a2a2a2; text-align:right'>" + numberWithCommas(value.SupplyJung) + "원</td>";
                        asynTable += "<td rowspan='2' style='border:1px solid #a2a2a2; text-align:right'>" + numberWithCommas(value.DeliveryJung) + "원</td>";
                        asynTable += "<td rowspan='2' style='border:1px solid #a2a2a2; text-align:right; padding-left:3px'>" + numberWithCommas(value.Billjung) + "원</td>";
                        asynTable += "<td rowspan='2' style='border:1px solid #a2a2a2; text-align:right; padding-left:3px' >" + numberWithCommas(value.TotalJung) + "원</td>";
                        asynTable += "</tr>";

                        //-----------------------------------------------------------------다음행-----------------------------------------------------------------------------------------------------------//
                        asynTable += "<tr>"
                        asynTable += "<td style= 'border-bottom:1px solid #a2a2a2;' class='txt-center'> " + gubunFlag + value.MainCodeNo + "</td > ";
                        asynTable += "<td style= 'border-bottom:1px solid #a2a2a2;'  class='txt-center'> " + value.GoodsUnitName + "</td > ";
                        index++;

                    });
                } else {
                    asynTable += "<tr id='emptyRow'><td colspan='11' class='txt-center'>" + "조회된 데이터가 없습니다." + "</td></tr>"
                }
                $("#tblProfitList tbody").append(asynTable);
            }

            var sUser = '<%= Svid_User%>';
            var param = { StartDate: startDate, EndDate: endDate, SaleCompCode: '<%= UserInfoObject.UserInfo.Company_Code%>',  Method: 'GetAdminSubBillList' };
            JajaxSessionCheck('Post', '../../Handler/PayHandler.ashx', param, 'json', callback, sUser);
         }

         function fnSetPaySelectText(val) {
             var returnVal = '';
             if (val == 'Y') {

                 returnVal = '예';

             }
             else if (val == 'N') {

                 returnVal = '아니오';
             }

             return returnVal;
         }

         //테이블 전체 선택
         function fnSelectAll(el) {
             if ($(el).prop("checked")) {
                 $("input[id^=cbSelect]").prop("checked", true);
             }
             else {
                 $("input[id^=cbSelect]").prop("checked", false);
             }
         }
         function fnEnter() {

             if (event.keyCode == 13) {
                 fnSearch();
                 return false;
             }
             else
                 return true;
         }

         var is_sending = false;
         //확인용버튼 클릭
         function fnTaxUpdate() {
             var callback = function (response) {
                 if (!isEmpty(response)) {
                     if (response == "OK") {
                         alert('확인되었습니다.');

                         fnSearch();
                         return false;
                     }
                     else {
                         alert('시스템 오류입니다. 관리자에게 문의하세요.');
                         return false;
                     }
                 }
                 return false;
             };


             var numsArray = '';

             $('#tbodyOrderList tr:even').each(function () {

                 if ($(this).attr('id') != 'emptyRow') {
                     var seqNo = $(this).children().find('input[id^="hdSeqNo"]').val();
                     numsArray += seqNo + ',';
                 }
               
             });

             if (numsArray == '') {
                 alert('조회된 건이 없습니다.');
                 return false;
             }
             

             var param = {
               Nums: numsArray.slice(0, -1),
                 Method: 'AdminSubPayTaxUpdate'
             };

             var beforeSend = function () {
                 is_sending = true;
             }
             var complete = function () {
                 is_sending = false;
             }

             if (is_sending) return false;

             JajaxDuplicationCheck('Post', '../../Handler/PayHandler.ashx', param, 'text', callback, beforeSend, complete, true, '<%=Svid_User%>');
            return false;
        }
    </script>
        <style type="text/css">
            .auto-style1 {
                margin-left: 40px;
            }
        </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <div class="all">
    <div class="sub-contents-div" style="max-height:1300px;">
    <!--제목 타이틀-->
            <div class="sub-title-div">
                <p class="p-title-mainsentence">
                    정산내역조회
                    <span class="span-title-subsentence"></span>
                </p>
            </div>

        <!--탭메뉴-->          
        <div class="div-main-tab" style="width: 100%; ">
                <ul>
                    <li id="libs"  class='tabOff' style="width: 185px;">
                        <a>정산요약</a>
                    </li>
                    <li id="lipl" class='tabOff' style="width: 185px;">
                        <a>매출내역</a>
                     </li>
                    <li id="lirl" class='tabOff' style="width: 185px;">
                        <a>반품내역</a>
                     </li>
                    <li id="liob"  class='tabOn' style="width: 185px;">
                        <a>전자세금계산서 발행</a>
                     </li>
                </ul>
            </div>
       
            <div class="tab-display1">
                <div class="tab" style="margin-top:10px">
                    <input type="button" value="발행 조회" style="width:75px; height:30px" class="mainbtn type2"  id="btnTab1" onclick="javascript: location.href = 'OrderBillIssue.aspx?ucode=' + ucode;"/>
                    <input type="button" value="확인 조회" style="width:75px; height:30px" class="mainbtn type1"  id="btnTab2" onclick="javascript:location.href='OrderBillIssueCheck.aspx?ucode=' + ucode;"/>
          
                </div>
            </div>
<!--상단영역 시작-->
            <div class="search-div">
                <table id="tblSearch">
                    <thead>
                        <tr>
                            <th colspan="12" style="height: 40px;">전자세금계산서 발행</th>
                        </tr>
                    </thead>


                    <tr>
                        <th style="width: 180px;">주문일자<br />(A/S일자 = 반품일자)</th>
                        <td colspan="3" rowspan="2" style="text-align: left; padding-left: 5px;">
                            <asp:TextBox ID="txtSearchSdate" runat="server" CssClass="calendar" ReadOnly="true" Height="24px" Width="130px" ></asp:TextBox>&nbsp;&nbsp;
                            -
                            &nbsp;&nbsp;<asp:TextBox ID="txtSearchEdate" runat="server" CssClass="calendar" ReadOnly="true" Height="24px" Width="130px" ></asp:TextBox>&nbsp;&nbsp;
                            <%--<input type="checkbox" id="ckbSearch1" value="1" checked="checked" /><label for="ckbSearch1">1일</label>
                            <input type="checkbox" id="ckbSearch2" value="7" /><label for="ckbSearch2">7일</label>
                            <input type="checkbox" id="ckbSearch3" value="15" /><label for="ckbSearch3">15일</label>
                            <input type="checkbox" id="ckbSearch4" value="30" /><label for="ckbSearch4">30일</label>
                            <input type="checkbox" id="ckbSearch5" value="90" /><label for="ckbSearch5">90일</label>--%>

                          <%--  <a onclick="fnSetSearchDate()"><img alt="날짜설정" src="" id="btnDateSet" onmouseover="this.src=''" onmouseout="this.src=''" /></a>--%>
                        </td>
                    </tr>
                   <%-- <tr>
                        <th style="width: 180px;">구매사</th>
                        <td style="width: 250px;">
                            <asp:TextBox ID="txtBuyerCompName" runat="server" Height="100%" OnKeypress="return fnEnter();" Width="98%" Style="border: 1px solid #a2a2a2;"></asp:TextBox>
                        </td>
                    </tr>--%>
                </table>
            </div>
            <!--상단영역 끝-->

            <!--조회하기 버튼-->
            <div class="bt-align-div">
                 <input type="button" class="mainbtn type1" style="width:95px; height:30px; " value="조회하기" onclick="return fnSearch(); return false"/>
                 <input type="button" class="mainbtn type1" style="width:95px; height:30px; " value="확인" onclick="return fnTaxUpdate(); return false"/>
            </div>
    
            <!--하단영역시작-->
            <div class="orderList-div" style="width: 100%; height:600px; overflow-y:auto; overflow-x:hidden">
                <%--  <table  id="tblorderList" style="border:1px solid #a2a2a2;width:2850px;height:40px;">--%>
                <table id="tblProfitList" style="width: 100%">
                    <thead>
                        <tr>
                            <th class="text-center" style="width: 80px" rowspan="2">번호</th>
                            <th class="text-center" style="width: 150px" rowspan="2">*주문입금날짜<br />#A/S입금날짜<br />@반품출금날짜</th>
                            <th class="text-center" style="width: 150px">*주문일자<br />#A/S일짜<br />@반품일자</th>
                            <th class="text-center" style="width: 120px" rowspan="2">구매사</th>
                            <th class="text-center" style="width: 300px" rowspan="2">*주문상품명(수량)<br />#A/S상품정보(수량)<br />@반품상품정보(수량)</th>
                            <th class="text-center" style="width: 180px">모델명</th>
                            <th class="text-center" style="width: 180px" rowspan="2">*판매사 매출정산<br />#A/S 매출정산<br />@판매사 반품정산</th>
                            <th class="text-center" style="width: 130px" rowspan="2">플랫폼/<br />이용수수료</th>
                            <th class="text-center" style="width: 130px" rowspan="2">배송비/<br />수수료</th>
                            <th class="text-center" style="width: 130px" rowspan="2">세금계산서/<br />수수료</th>
                            <th class="text-center" style="width: 130px" rowspan="2">세금계산서/<br />발행금액</th>
                        </tr>
                        <tr>
                              <th class="text-center" style="width: 120px">*주문번호<br />#A/S번호<br />@반품번호</th>
                              <th class="text-center" style="width: 120px">내용량</th>
                        </tr>
                    </thead>
                    <tbody id="tbodyOrderList">
                        <tr id="emptyRow">
                            <td colspan="11" style="text-align:center">
                                조회하기 버튼을 클릭해주세요.
                            </td>
                        </tr>
                    </tbody>
                </table>

            </div>

            <!--하단영역끝-->

        </div>

</asp:Content>
