<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Master/AdminMasterPage.master" AutoEventWireup="true" CodeFile="OrderBillIssue.aspx.cs" Inherits="Admin_Order_OrderBillIssue" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
  <link href="../Content/Order/common.css" rel="stylesheet" />
  <link href="../Content/Order/order.css" rel="stylesheet" />
    
    <style>
        a{
            cursor:pointer;
        }

       .sub-tab-div a:nth-child(2) {
            margin-left: -2.5px;
        }
        .sub-tab-div a:nth-child(3) {
            margin-left: -2.5px;
        }
          .sub-tab-div a:nth-child(4) {
            margin-left: -2.5px;
        }
       
    </style>
    
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

            var paySelectType = $('#ddlPaySelectType').val();

            if (paySelectType == 'NULL') {

                $('#btnApply').css('display', '');
                $('#btnCancel').css('display', 'none');
                $('#btnTaxPublish').css('display', 'none');
            }
            else if (paySelectType == 'Y') {
                $('#btnApply').css('display', 'none');
                $('#btnCancel').css('display', '');
                $('#btnTaxPublish').css('display', '');
            }
            else if (paySelectType == 'N') {
                $('#btnApply').css('display', 'none');
                $('#btnCancel').css('display', '');
                $('#btnTaxPublish').css('display', 'none');
            }

        });


        //조회하기
        function fnSearch() {
            var startDate = $('#<%= txtSearchSdate.ClientID%>').val();
            var endDate = $('#<%= txtSearchEdate.ClientID%>').val();
            var paySelectType = $('#ddlPaySelectType').val();
            var saleComp = $('#<%=txtSaleCompName.ClientID %>').val();

            if (isEmpty(saleComp)) {
                alert("검색 조건에서 판매사명을 입력해 주세요.");
                return false;
            }

            var delFlag = '';
            if (paySelectType == 'N') {
                delFlag = 'I';
                $('#btnApply').css('display', 'none');
                $('#btnCancel').css('display', '');
                $('#btnTaxPublish').css('display', 'none');
            }
            else if (paySelectType == 'Y') {
                delFlag = 'I';
                $('#btnApply').css('display', 'none');
                $('#btnCancel').css('display', '');
                $('#btnTaxPublish').css('display', '');
            }
            else if (paySelectType == 'NULL') {
                delFlag = 'N';
                $('#btnApply').css('display', '');
                $('#btnCancel').css('display', 'none');
                $('#btnTaxPublish').css('display', 'none');

            }
            var i = 1;
            var asynTable = "";

            var callback = function (response) {
                $("#tblProfitList tbody").empty();

                fnBillList(response.billList, response.billStatList);
                
            }

            var sUser = '<%= Svid_User%>';
            var param = { StartDate: startDate, EndDate: endDate, SaleCompName: saleComp, PaySelectType: paySelectType, DelFlag: delFlag, Method: 'GetAdminBillList' };

            var beforeSend = function () { };
            var complete = function () { };

            JqueryAjax("Post", "../../Handler/PayHandler.ashx", true, false, param, "json", callback, beforeSend, complete, true, sUser);
        }


        function fnBillList(list, statList) {

            var asynTable = "";
            var index = 1;
            var ingOrdCnt = 0;

            //배송완료 주문목록
            if (!isEmpty(list)) {
                $.each(list, function (idx, value) {
                    var ordCodeNo = value.MainCodeNo;
                    var ordStat = value.OrderStatus;
                    var trColor = '';
                    var trCkb = "<input type='checkbox' id='cbSelect" + index + "' />";
                    
                    //배송상태
                    if (!isEmpty(statList)) {
                        $.each(statList, function (idx, statVal) {
                            //alert("배송상태 : " + " - " + idx + " : " + statVal.OrderCodeNo + ", " + statVal.OrderStatus); 

                            if (ordCodeNo === statVal.OrderCodeNo) {
                                trColor = " style='background-color: #ff7979;'";
                                trCkb = '';

                                ++ingOrdCnt;
                            }
                        });
                    }

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

                    asynTable += "<tr" + trColor + ">"
                    asynTable += "<td rowspan='2' style='border:1px solid #a2a2a2;' class='txt-center'>" + trCkb;
                    asynTable += "<input type='hidden' id='hdSeqNo" + index + "' value='" + value.Unum_SeqNo + "'/>";
                    asynTable += "<input type='hidden' id='hdMainCodeNo" + index + "' value='" + value.MainCodeNo + "'/>";
                    asynTable += "<input type='hidden' id='hdGoodsName" + index + "' value='" + value.GoodsFinalName + "'/>";
                    asynTable += "<input type='hidden' id='hdOrdSaleCompCode" + index + "' value='" + value.OrderSaleComp_Code + "'/>";
                    asynTable += "<input type='hidden' id='hdTotJung" + index + "' value='" + value.TotalJung + "'/>";
                    asynTable += "</td>";
                    asynTable += "<td rowspan='2' style='border-right:1px solid #a2a2a2' class='txt-center'>" + index + "</td>";
                    asynTable += "<td rowspan='2' style='border-right:1px solid #a2a2a2' class='txt-center'>" + gubunFlag + fnOracleDateFormatConverter(value.PayConfirmDate) + "</td>";
                    asynTable += "<td style='border:1px solid #a2a2a2;' class='txt-center'>" + gubunFlag + fnOracleDateFormatConverter(value.EntryDate) + "</td>";
                    asynTable += "<td rowspan='2' style='border:1px solid #a2a2a2;' class='txt-center'>" + value.OrderSaleComp_Name + "</td>";
                    asynTable += "<td rowspan='2' style='border:1px solid #a2a2a2;' class='txt-center'>" + gubunFlag + value.GoodsFinalName + "<br/><span style='float:left'>수량: " + value.GoodsQty + "</span></td>";
                    asynTable += "<td style='text-align:center'> " + value.GoodsModel + "</td >";
                    asynTable += "<td  rowspan='2' style='border:1px solid #a2a2a2; text-align:right; padding-left:3px'>" + gubunFlag + numberWithCommas(value.CustAmt) + "원</td>";
                    asynTable += "<td rowspan='2' style='border:1px solid #a2a2a2; text-align:right'>" + numberWithCommas(value.SupplyJung) + "원</td>";
                    asynTable += "<td rowspan='2' style='border:1px solid #a2a2a2; text-align:right'>" + numberWithCommas(value.DeliveryJung) + "원</td>";
                    asynTable += "<td rowspan='2' style='border:1px solid #a2a2a2; text-align:right; padding-left:3px'>" + numberWithCommas(value.Billjung) + "원</td>";
                    asynTable += "<td rowspan='2' style='border:1px solid #a2a2a2; text-align:right; padding-left:3px' >" + numberWithCommas(value.TotalJung) + "원</td>";
                    asynTable += "<td rowspan='2' style='border:1px solid #a2a2a2;' class='txt-center'>" + fnSetPaySelectText(value.PaySelectType) + "</td>";
                    asynTable += "</tr>";

                    //-----------------------------------------------------------------다음행-----------------------------------------------------------------------------------------------------------//
                    asynTable += "<tr" + trColor + ">"
                    asynTable += "<td style= 'border-bottom:1px solid #a2a2a2;' class='txt-center'> " + gubunFlag + value.MainCodeNo + "</td > ";
                    asynTable += "<td style= 'border-bottom:1px solid #a2a2a2;' class='txt-center'> " + value.GoodsUnitName + "</td ></tr>";
                    index++;
                    

                });
            } else {
                asynTable = "<tr><td colspan='14' class='txt-center'>" + "조회된 데이터가 없습니다." + "</td></tr>"
                //$("#tblProfitList tbody").append(asynTable);
            }

            if (ingOrdCnt > 0) {
                var confirmVal = confirm("배송완료되지 않은 상품이 목록에 존재합니다. 계속 진행하시겠습니까?");

                //if (confirmVal) {
                //    $("#tblProfitList tbody").append(asynTable);
                //} else {
                //    asynTable = "<tr><td colspan='14' class='txt-center'>" + "조회된 데이터가 없습니다." + "</td></tr>"

                //    $("#tblProfitList tbody").append(asynTable);
                //}

                if (!confirmVal) {
                    asynTable = "<tr><td colspan='14' class='txt-center'>" + "조회된 데이터가 없습니다." + "</td></tr>"
                }
            }

            $("#tblProfitList tbody").append(asynTable);
            
            return false;
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

        var is_sending = false;
        //적용버튼 클릭
        function fnTaxUpdate(type) {
            var callback = function (response) {
                if (!isEmpty(response)) {
                    if (response == "OK") {
                        if (type == 'Y') {
                            alert('적용되었습니다.');
                        }
                        else {
                            alert('취소되었습니다.');
                        }

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

            $('#tbodyOrderList input[id ^="cbSelect"]').each(function () {
                if ($(this).prop('checked') == true) {
                    var seqNo = $(this).parent().find('input[id^="hdSeqNo"]').val();
                    numsArray += seqNo + ',';
                }
            });
            if (numsArray == '') {

                if (type == 'Y') {
                    alert('적용할 건을 선택해 주세요.');
                }
                else {
                    alert('취소할 건을 선택해 주세요.');
                }
                return false;
            }
            
            var param = {
                Type: type,
                Nums: numsArray.slice(0, -1),
                Method: 'AdminPayTaxUpdate'
            };

            var beforeSend = function () {
                is_sending = true;
            }
            var complete = function () {
                is_sending = false;
            }
            if (is_sending) return false;

            JqueryAjax("Post", "../../Handler/PayHandler.ashx", true, false, param, "text", callback, beforeSend, complete, true, '<%=Svid_User%>');

            <%--JajaxDuplicationCheck('Post', '../../Handler/PayHandler.ashx', param, 'text', callback, beforeSend, complete, true, '<%=Svid_User%>');--%>
            return false;
        }

        //세금계산서 발행 버튼 클릭 시
        function fnTaxInvoice() {
            var numsArray = '';
            var orderCnt = 0; //외 주문건수
            var returnCnt = 0; //외 반품건수
            var orderNm = "주문 세금계산서"; //주문명
            var returnNm = "반품 세금계산서"; //반품명
            var ordSaleCompCode = ''; //판매사코드
            var totJung = 0; //발행금액합계
            
            $('#tbodyOrderList input[id ^="cbSelect"]').each(function () {
                if ($(this).prop('checked') == true) {
                    var seqNo = $(this).parent().find('input[id^="hdSeqNo"]').val();
                    var mainCodeNo = $(this).parent().find('input[id^="hdMainCodeNo"]').val();
                    var gdsName = $(this).parent().find('input[id^="hdGoodsName"]').val();
                    var strAmt = $(this).parent().find('input[id^="hdTotJung"]').val();

                    numsArray += seqNo + ',';

                    if (!isEmpty(mainCodeNo)) {

                        var mainCode = mainCodeNo.substring(0, 2); //코드 앞 2자리

                        if (orderCnt == 0) {
                            ordSaleCompCode = $(this).parent().find('input[id^="hdOrdSaleCompCode"]').val();
                        }

                        totJung += Number(strAmt); //세금계산서 발행금액

                        switch (mainCode) {
                            case "ON":
                                ++orderCnt; //주문
                                break;
                            case "R-":
                                ++returnCnt; //반품
                                break;
                            default:
                        }
                    }
                }
            });

            if (isEmpty(numsArray)) {
                alert("세금계산서를 발행할 건을 선택해 주세요.");

                return false;
            }

            var confirmVal = confirm("정말로 세금계산서를 발행하시겠습니까?");
            if (confirmVal) {
                var finalName = ''; //최종 명칭
                if (orderCnt > 0) {
                    finalName += orderNm + "(" + orderCnt + "건)";
                }
                if (returnCnt > 0) {
                    if (!isEmpty(finalName)) finalName += "&ltbr /&gt";

                    finalName += returnNm + "(" + returnCnt + "건)";
                }

                var gdsQty = orderCnt + asCnt + returnCnt; //총 수량

                var callback = function (response) {
                    if (!isEmpty(response)) {
                        if (response == "OK") {
                            alert("성공적으로 세금계산서가 발행되었습니다.");

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

                var param = {
                    OrdSaleCompCode: ordSaleCompCode,
                    Nums: numsArray.slice(0, -1),
                    GoodsName: finalName,
                    GoodsQty: gdsQty,
                    TotAmt: totJung,
                    Method: 'AdminPayBill'
                };

                var beforeSend = function () {
                    is_sending = true;
                }
                var complete = function () {
                    is_sending = false;
                }

                if (is_sending) return false;

                JajaxDuplicationCheck('Post', '../../Handler/PayHandler.ashx', param, 'text', callback, beforeSend, complete, true, '<%=Svid_User%>');
            }
            
            return false;
        }

        function fnEnter() {

            if (event.keyCode == 13) {
                fnSearch();
                return false;
            }
            else
                return true;
        }

        function fnTabClickRedirect(pageName) {
            location.href = pageName + '.aspx?ucode=' + ucode;
            return false;
        }
    </script>

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">

    <div class="all">
        <div class="sub-contents-div">
           <!--제목 타이틀-->       
        <div class="sub-title-div">
                <p class="p-title-mainsentence">
                    전자세금계산서 발행현황(판매사)
                    <span class="span-title-subsentence"></span>
                </p>
            </div>
           
       <!--탭메뉴-->          
      <div class="div-main-tab" style="width: 100%; ">
                <ul>
                    <li class='tabOff' style="width: 185px;" onclick="fnTabClickRedirect('../BalanceAccounts/BalanceSummary');">
                        <a onclick="fnTabClickRedirect('../BalanceAccounts/BalanceSummary');">정산요약</a>
                     </li>
                    <li class='tabOff' style="width: 185px;" onclick="fnTabClickRedirect('../BalanceAccounts/ProfitList');">
                         <a onclick="fnTabClickRedirect('../BalanceAccounts/ProfitList');">매출내역</a>
                    </li>
                   <%-- <li class='tabOff' style="width: 185px;" onclick="fnTabClickRedirect('../BalanceAccounts/AsList');">
                        <a onclick="fnTabClickRedirect('../BalanceAccounts/AsList');">A/S내역</a>
                    </li>--%>
                   <%-- <li class='tabOff' style="width: 185px;" onclick="fnTabClickRedirect('../BalanceAccounts/ReturnList');">
                         <a onclick="fnTabClickRedirect('../BalanceAccounts/ReturnList');">반품내역</a>
                    </li>--%>
                    <li class='tabOn' style="width: 185px;" onclick="fnTabClickRedirect('OrderBillIssue');">
                        <a onclick="fnTabClickRedirect('OrderBillIssue');">전자세금계산서 발행</a>
                    </li>
                </ul>
            </div>

            <div class="tab-display1">
                <div class="tab" style="margin-top:10px">
                    <input type="button" class="mainbtn type2" style="width: 95px; height: 30px; border-radius:5px;font-size: 12px; margin-bottom:2px" value="선택" onclick="javascript:location.href='OrderBillIssue.aspx?ucode='+ucode;" />
                    <input type="button" class="mainbtn type1" style="width: 95px; height: 30px; border-radius:5px;font-size: 12px; margin-bottom:2px" value="현황" onclick="javascript:location.href='OrderBillIssueCheck.aspx?ucode='+ucode;" />

                  
               </div>
            </div>
          
            <!--상단영역 시작-->
            <div class="search-div">
                <table id="tblSearch" class="tbl_main">
                    <thead>
                        <tr>
                            <th colspan="12" style="height: 40px;">전자세금계산서 선택</th>
                        </tr>
                    </thead>


                    <tr>
                        <th style="width: 180px;">주문일자<br />(반품일자)</th>
                        <td colspan="3" rowspan="2" style="text-align: left; padding-left: 5px;">
                            <asp:TextBox ID="txtSearchSdate" runat="server" CssClass="calendar" ReadOnly="true" Height="24px" Width="130px"></asp:TextBox>&nbsp;&nbsp;
                            -
                            &nbsp;&nbsp;<asp:TextBox ID="txtSearchEdate" runat="server" CssClass="calendar" ReadOnly="true" Height="24px" Width="130px"></asp:TextBox>&nbsp;&nbsp;
                            <%--<input type="checkbox" id="ckbSearch1" value="1" checked="checked" /><label for="ckbSearch1">1일</label>
                            <input type="checkbox" id="ckbSearch2" value="7" /><label for="ckbSearch2">7일</label>
                            <input type="checkbox" id="ckbSearch3" value="15" /><label for="ckbSearch3">15일</label>
                            <input type="checkbox" id="ckbSearch4" value="30" /><label for="ckbSearch4">30일</label>
                            <input type="checkbox" id="ckbSearch5" value="90" /><label for="ckbSearch5">90일</label>--%>

                          <%--  <a onclick="fnSetSearchDate()"><img alt="날짜설정" src="" id="btnDateSet" onmouseover="this.src=''" onmouseout="this.src=''" /></a>--%>
                        </td>
                        <th style="width: 150px;">판매사 확인유무</th>
                        <td style="width: 100px;">
                            <select id="ddlPaySelectType" style="width:97%; height:24px">
                                <option value="NULL">미적용</option>
                                <option value="Y">예</option>
                                <option value="N">아니오</option>
                            </select>
                        </td>
                        <th style="width: 150px;">판매사</th>
                        <td style="width: 250px;">
                            <asp:TextBox ID="txtSaleCompName" runat="server" Height="24px" OnKeypress="return fnEnter();" Width="98%" Style="border: 1px solid #a2a2a2;"></asp:TextBox>
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
                    <input type="button" class="mainbtn type1" style="width: 95px; height: 30px;" value="조회하기" onclick="fnSearch();" />
                    <input type="button" onclick="fnTaxUpdate('Y'); return false;" class="mainbtn type1" style="width: 95px; height: 30px; display:none" id="btnApply" value="적용"/>
                    <input type="button" onclick="fnTaxUpdate('N'); return false;" class="mainbtn type1" style="width: 95px; height: 30px; display:none" id="btnCancel" value="취소"/>
                    <input type="button" onclick="return fnTaxInvoice();" class="mainbtn type1" style="width: 115px; height: 30px; display:none" id="btnTaxPublish" value="세금계산서 발행"/>
            </div>
                        <span style="color: #69686d; float: right; margin-top: 10px; margin-bottom: 10px;">*<b style="color: #ec2029; font-weight: bold;"> VAT(부가세)포함 가격</b>입니다.</span>

            <!--하단영역시작-->
            <div class="orderList-div" style="width: 100%; height:600px; overflow-y:auto; overflow-x:hidden">
                <%--  <table  id="tblorderList" style="border:1px solid #a2a2a2;width:2850px;height:40px;">--%>
                <table id="tblProfitList" class="tbl_main">
                    <thead>
                        <tr>
                            <th class="text-center" style="width: 40px" rowspan="2">전체<br />선택
                                &nbsp;&nbsp;<input type="checkbox" id="ckbListAll" style="text-align:center" onclick="fnSelectAll(this);"/>&nbsp;&nbsp;
                            </th>
                            <th class="text-center" style="width: 80px" rowspan="2">번호</th>
                            <th class="text-center" style="width: 150px" rowspan="2">*주문입금날짜<br />@반품출금날짜</th>
                            <th class="text-center" style="width: 150px">*주문일자<br />@반품일자</th>
                            <th class="text-center" style="width: 150px" rowspan="2">판매사</th>
                            <th class="text-center" style="width: 300px" rowspan="2">*주문상품명(수량)<br />@반품상품정보(수량)</th>
                            <th class="text-center" style="width: 180px">모델명</th>
                            <th class="text-center" style="width: 180px" rowspan="2">*판매사 매출정산<br />@판매사 반품정산</th>
                            <th class="text-center" style="width: 150px" rowspan="2">플랫폼 이용<br />수수료</th>
                            <th class="text-center" style="width: 150px" rowspan="2">배송비<br />수수료</th>
                            <th class="text-center" style="width: 150px" rowspan="2">세금계산서<br />수수료</th>
                            <th class="text-center" style="width: 150px" rowspan="2">세금계산서<br />발행금액</th>
                            <th class="text-center" style="width: 120px" rowspan="2">판매사<br /> 확인유무</th>
                        </tr>
                        <tr>
                              <th class="text-center" style="width: 120px">*주문번호<br />@반품번호</th>
                              <th class="text-center" style="width: 120px">내용량</th>
                        </tr>
                    </thead>
                    <tbody id="tbodyOrderList">
                        <tr>
                            <td colspan="13" style="text-align:center">
                                조회하기 버튼을 클릭해주세요.
                            </td>
                        </tr>
                    </tbody>
                </table>

            </div>

            <!--하단영역끝-->

        </div>
    </div>
</asp:Content>

