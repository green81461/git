<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Master/AdminMasterPage.master" AutoEventWireup="true" CodeFile="BalanceSummary.aspx.cs" Inherits="Admin_BalanceAccounts_BalanceSummary" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <link href="../Content/Order/order.css" rel="stylesheet" />
    <script src="../../Scripts/jquery.inputmask.bundle.js"></script>

    <style>
        #tbodyPayProfit tr:hover {
            background-color: gainsboro;
            cursor: pointer
        }
    </style>
    <script type="text/javascript">
        var qs = fnGetQueryStrings();
        var ucode = qs["ucode"];
        $(document).ready(function () {
            $("#<%=this.txtSearchSdate.ClientID%>").inputmask("9999-99-99");
            $("#<%=this.txtSearchEdate.ClientID%>").inputmask("9999-99-99");


            //체크박스 하나만 선택
            var tableid = 'tblSearchList';
            ListCheckboxOnlyOne(tableid);

            //달력
            $("#<%=this.txtSearchSdate.ClientID%>").datepicker({
                showAnimation: 'slideDown',
                changeMonth: true,
                changeYear: true,
                showOn: 'button',
                buttonImage:/* "/Images/icon_calandar.png"*/"../../Images/Goods/calendar.jpg",
                buttonImageOnly: true,
                dateFormat: "yy-mm-dd",
                monthNamesShort: ["1월", "2월", "3월", "4월", "5월", "6월", "7월", "8월", "9월", "10월", "11월", "12월"],
                dayNamesMin: ["일", "월", "화", "수", "목", "금", "토"],
                showMonthAfterYear: true,
                onSelect: function (dateText, inst) {         //달력에 변경이 생길 시 수행하는 함수
                    SetDate();
                }
            });

            $("#<%=this.txtSearchEdate.ClientID%>").datepicker({
                showAnimation: 'slideDown',
                changeMonth: true,
                changeYear: true,
                showOn: 'button',
                buttonImage:/* "/Images/icon_calandar.png"*/"../../Images/Goods/calendar.jpg",
                buttonImageOnly: true,
                dateFormat: "yy-mm-dd",
                monthNamesShort: ["1월", "2월", "3월", "4월", "5월", "6월", "7월", "8월", "9월", "10월", "11월", "12월"],
                dayNamesMin: ["일", "월", "화", "수", "목", "금", "토"],
                showMonthAfterYear: true
            });

            $('#tblSearchList input[type="checkbox"]').change(function () {
                if ($(this).prop('checked') == true) {
                    var num = $(this).val();
                    if (num == '0') {
                        $("#<%=this.txtSearchSdate.ClientID%>").val('')
                        $("#<%=this.txtSearchEdate.ClientID%>").val('')
                        $("#<%=this.txtSearchSdate.ClientID%>").attr("readonly", false)      //ReadOnly 풀기
                        $("#<%=this.txtSearchEdate.ClientID%>").attr("readonly", false)      //ReadOnly 풀기 
                        // $("input[name=id]").attr("readonly", true);
                        return;
                    }
                    else {
                        $("#<%=this.txtSearchSdate.ClientID%>").attr("readonly", true)      //ReadOnly 적용
                        $("#<%=this.txtSearchEdate.ClientID%>").attr("readonly", true)      //ReadOnly 적용 
                    }

                    var resultSDate = new Date();
                    var resultEDate = new Date();
                    $("#<%=this.txtSearchEdate.ClientID%>").val($.datepicker.formatDate("yy-mm-dd", resultEDate));
                    var newDate = new Date($("#<%=this.txtSearchEdate.ClientID%>").val());

                    resultSDate.setDate(newDate.getDate() - num);
                    $("#<%=this.txtSearchSdate.ClientID%>").val($.datepicker.formatDate("yy-mm-dd", resultSDate));
                }
            });

            $("#tbodyPayProfit").on('click', 'tr', function () {
                if ($(this).find("td").length > 1) {
                    fnPopupSummery_D(this); return false;
                }
            });

            $('#<%= txtSaleComp.ClientID%>').val('');
        });

        function SetDate() {

            $("input[name=chkBox]:checked").each(function () {
                var num = $(this).val();                 //선택한 체크박스
                var newEDate = new Date($("#<%=this.txtSearchSdate.ClientID%>").val());         //시작일자를 NewEDate에 넣음

                var resultDate = new Date();
                num = parseInt(num);
                resultDate.setDate(newEDate.getDate() + num);             //ResultDate에 일자를 NewEdate의 일자로 넣고 선택한 체크박스만큼 더한다.

                if (newEDate.getFullYear() != resultDate.getFullYear()) {         //연도가 다를 때
                    resultDate.setFullYear(newEDate.getFullYear());               //연도를 세팅해준다.
                }

                //if (newEDate.getMonth() == '11' && newEDate.getDate() + num >= 31) {     //12월이며 날짜 값이 31이 넘을 때
                //    alert('1')
                //    resultDate.setFullYear(newEDate.getFullYear() + 1);             //연도 세팅
                //}

                //if (newEDate.getMonth() == '9' && newEDate.getDate()>= 3 && num == 90) {     //12월이며 날짜 값이 31이 넘을 때
                //    alert('10월..')
                //    resultDate.setFullYear(newEDate.getFullYear() + 1);             //연도 세팅

                //}



                var lastDay = (new Date(newEDate.getFullYear(), newEDate.getMonth() + 1, 0)).getDate();        //그 달의 마지막 날 구하는 방법


                if (newEDate.getMonth() == resultDate.getMonth()) {       //newEDate의 달과 ResultDate의 달이 같을 때 처리

                    if (newEDate.getMonth() == '9' && newEDate.getDate() >= 3) { //10월 3일~10월31일 처리과정.
                        resultDate.setMonth(resultDate.getMonth() + 3);
                    }
                }
                else {   //같지 않을때, 달을 바꿔 맞춰준다.
                    resultDate.setMonth(newEDate.getMonth());            //ResultDate에 달 값을 NewEdate의 달로 세팅함.

                    if (num == '1' && newEDate.getDate() >= lastDay) {           //마지막날 비교 후 달 변경
                        resultDate.setMonth(newEDate.getMonth() + 1);  //1일 선택 시
                    }
                    else if (num == '7' && newEDate.getDate() >= '24') { //7일 선택 시
                        resultDate.setMonth(newEDate.getMonth() + 1);
                    }
                    else if (num == '15' && newEDate.getDate() >= '17') { //15일 선택 시
                        resultDate.setMonth(newEDate.getMonth() + 1);
                    }
                    else if (num == '30' && newEDate.getDate() >= '2') { //30일 선택 시
                        resultDate.setMonth(newEDate.getMonth() + 1);
                    }
                    else if (num == '90') {  //90일 선택 시 
                        resultDate.setDate(newEDate.getDate() + num);
                    }

                }
                $("#<%=this.txtSearchEdate.ClientID%>").val($.datepicker.formatDate("yy-mm-dd", resultDate));

            });

        }



        //목록 조회
        function fnPayProfitList(pageNo) {
            var svidUser = '<%= Svid_User %>';
            var startDate = $('#<%= txtSearchSdate.ClientID%>').val();
            var endDate = $('#<%= txtSearchEdate.ClientID%>').val();
            var saleComp = $('#<%= txtSaleComp.ClientID%>').val();
            var pageSize = 20;
            var asynTable = "";

            if (isEmpty(saleComp)) {
                alert("판매사명을 입력해 주세요.");
                return false;
            }

            var callback = function (response) {
                $("#tbodyPayProfit").empty();
                if (!isEmpty(response)) {
                    $.each(response, function (key, value) {
                        if (key == 0) {
                            $('#hdTotalCount').val(value.TotalCount);
                        }

                        var saleAmt = Number(value.SaleAmt); //판매사 매출(A)
                        var supplyJung = Number(value.SupplyJung); //플랫폼수수료(B)
                        var custAmt = Number(value.CustAmt); //판매사매입(C)
                        var deliveryJung = Number(value.DeliveryJung); //배송비수수료(D)
                        var PGJung = Number(value.PGJung); //PG수수료(E)
                        var billJung = Number(value.BillJung); //전자세금계산서 발행비용(F)
                        var totalJung = saleAmt - (supplyJung + custAmt + deliveryJung + PGJung + billJung); //정산금액(G)
                        var errorCode = value.ErrorCode;
                        var rowCol = '#FFFFFF';
                        if (errorCode == '1') {
                            rowCol = '#FF9A9A';
                        }
                        asynTable += "<tr style='background-color:" + rowCol + "'><td style='text-align:center'>" + value.RowNum + "<input type='hidden' name='hdSaleCompCode' value='" + value.OrderSaleCompany_Code + "' /></td >";
                        asynTable += "<td style='text-align:center'> " + startDate + " <br />~" + endDate + "</td>";
                        asynTable += "<td style='text-align:center'>" + value.BuyCompName + "</td>";
                        asynTable += "<td style='text-align:center'>" + value.OrderSaleCompany_Code + "</td>";
                        asynTable += "<td style='text-align:center'>" + value.OrderSaleCompany_Name + "</td>";
                        asynTable += "<td style='text-align:center'>" + numberWithCommas(saleAmt) + "원" + "</td>";
                        asynTable += "<td style='text-align:center'>" + numberWithCommas(supplyJung) + "원" + "</td>";
                        asynTable += "<td style='text-align:center'>" + numberWithCommas(custAmt) + "원" + "</td>";
                        asynTable += "<td style='text-align:center'>" + numberWithCommas(deliveryJung) + "원" + "</td>";
                        asynTable += "<td style='text-align:center'>" + numberWithCommas(PGJung) + "원" + "</td>";
                        asynTable += "<td style='text-align:center'>" + numberWithCommas(billJung) + "원" + "</td>";
                        asynTable += "<td style='text-align:center'>" + numberWithCommas(totalJung) + "원" + "</td></td>";

                    });
                } else {
                    asynTable += "<tr><td colspan='12' class='txt-center'>" + "조회된 리스트가 없습니다." + "</td></tr>"
                    $("#hdTotalCount").val(0);
                }

                $("#tbodyPayProfit").append(asynTable);
                fnCreatePagination('pagination', $("#hdTotalCount").val(), pageNo, 20, getPageData);
            };

            var param = {
                SvidUser: svidUser
                , StartDate: startDate
                , EndDate: endDate
                , SaleCompNm: saleComp
                , PageNo: pageNo
                , PageSize: 20
                , Method: "GetProfitSummaryList_Admin"
            };

            var beforeSend = function () {
                $('#divLoading').css('display', '');
            }
            var complete = function () {
                $('#divLoading').css('display', 'none');
            }

            //JajaxSessionCheck('Post', '../../Handler/PayHandler.ashx', param, 'json', callback, svidUser);
            JqueryAjax('Post', '../../Handler/PayHandler.ashx', true, false, param, 'json', callback, beforeSend, complete, true, svidUser);
        }

        function getPageData() {
            var container = $('#pagination');
            var getPageNum = container.pagination('getSelectedPageNum');
            fnPayProfitList(getPageNum);

            return false;
        }

        //정산내용상세 팝업창
        function fnPopupSummery_D(el) {
            var callback = function (response) {

                var startDate = $("#<%=this.txtSearchSdate.ClientID%>").val().split('-');
                var endDate = $("#<%=this.txtSearchEdate.ClientID%>").val().split('-');

                var startMonth = startDate[1];
                var startDay = startDate[2];
                var endMonth = endDate[1];
                var endDay = endDate[2];

                $("#lblSearchDue").text(startMonth + "월" + startDay + " ~ " + endMonth + "월" + endDay + "일");

                var newRowContent = '';
                var i = 1;
                if (!isEmpty(response)) {
                    var saleAmt1 = Number(response.SaleAmt1); //A_1
                    var saleAmt2 = Number(response.SaleAmt2); //A_2
                    var deliveryJung = Number(response.DeliveryJung); //A_3
                    var saleAmt3 = Number(response.SaleAmt3); //A_4
                    var A_tot = (saleAmt1 + saleAmt2 + deliveryJung) - saleAmt3; //A_tot

                    var supplyAmt1 = Number(response.SupplyAmt1); //B_goods
                    var supplyAmt2 = Number(response.SupplyAmt2); //B_AS
                    var supplyAmt3 = Number(response.SupplyAmt3); //B_return
                    var supplyJung1 = Number(response.SupplyJung1); //B_1
                    var supplyJung2 = Number(response.SupplyJung2); //B_2
                    var supplyJung3 = Number(response.SupplyJung3); //B_3
                    var B_tot = (supplyJung1 + supplyJung2) - supplyJung3; //B_tot

                    var custAmt1 = Number(response.CustAmt1); //C_1
                    var custAmt2 = Number(response.CustAmt2); //C_2
                    var custAmt3 = Number(response.CustAmt3); //C_3
                    var C_tot = (custAmt1 + custAmt2) - custAmt3; //C_tot

                    var cardJung = Number(response.CardJung); //E_1
                    var realJung = Number(response.RealJung); //E_2
                    var cyberJung = Number(response.CyberJung); //E_3
                    var cyberLoanJung = Number(response.CyberLoanJung); //E_4
                    var cardArsJung = Number(response.CardArsJung); //E_5
                    //var YCyberLoanJung = Number(response.YCyberLoanJung); //E_6
                    var cyberBulkJung = Number(response.CyberBulkJung); //E_6
                    var cancelJung = Number(response.CancelJung); //E_7

                    var E_tot = cardJung + realJung + cyberJung + cyberLoanJung + cardArsJung + cyberBulkJung + cancelJung; //E_tot

                    var billJung = Number(response.BillJung); //F

                    var G_tot = A_tot - (B_tot + C_tot + deliveryJung + E_tot + billJung); //G_tot

                    $("#lblDtl_A_tot").text(numberWithCommas(A_tot) + "원");
                    $("#spDtl_A_1").text(numberWithCommas(saleAmt1) + "원");
                    //$("#spDtl_A_2").text(numberWithCommas(saleAmt2) + "원");
                    $("#spDtl_A_3").text(numberWithCommas(deliveryJung) + "원");
                    $("#spDtl_A_4").text(numberWithCommas(saleAmt3) + "원");

                    $("#lblDtl_B_tot").text(numberWithCommas(B_tot) + "원");
                    $("#spDtl_B_goods").text(numberWithCommas(supplyAmt1) + "원");
                    //$("#spDtl_B_AS").text(numberWithCommas(supplyAmt2) + "원");
                    $("#spDtl_B_return").text(numberWithCommas(supplyAmt3) + "원");
                    $("#spDtl_B_1").text(numberWithCommas(supplyJung1) + "원");
                    //$("#spDtl_B_2").text(numberWithCommas(supplyJung2) + "원");
                    $("#spDtl_B_3").text(numberWithCommas(supplyJung3) + "원");

                    $("#lblDtl_C_tot").text(numberWithCommas(C_tot) + "원");
                    $("#spDtl_C_1").text(numberWithCommas(custAmt1) + "원");
                    //$("#spDtl_C_2").text(numberWithCommas(custAmt2) + "원");
                    $("#spDtl_C_3").text(numberWithCommas(custAmt3) + "원");

                    $("#lblDtl_D_tot").text(numberWithCommas(deliveryJung) + "원");
                    $("#spDtl_D_1").text(numberWithCommas(deliveryJung) + "원");

                    $("#lblDtl_E_tot").text(numberWithCommas(E_tot) + "원");
                    $("#spDtl_E_1").text(numberWithCommas(cardJung) + "원");
                    $("#spDtl_E_2").text(numberWithCommas(realJung) + "원");
                    $("#spDtl_E_3").text(numberWithCommas(cyberJung) + "원");
                    $("#spDtl_E_4").text(numberWithCommas(cyberLoanJung) + "원");
                    $("#spDtl_E_5").text(numberWithCommas(cardArsJung) + "원");
                    $("#spDtl_E_6").text(numberWithCommas(cyberBulkJung) + "원");
                    $("#spDtl_E_7").text(numberWithCommas(cancelJung) + "원");
                    $("#spDtl_F").text(numberWithCommas(billJung) + "원");
                    $("#lblDtl_G_tot").text(numberWithCommas(G_tot) + "원");

                } else {
                    $("#lblDtl_A_tot").text("0원");
                    $("#spDtl_A_1").text("0원");
                    //$("#spDtl_A_2").text("0원");
                    $("#spDtl_A_3").text("0원");
                    $("#spDtl_A_4").text("0원");

                    $("#lblDtl_B_tot").text("0원");
                    $("#spDtl_B_goods").text("0원");
                    //$("#spDtl_B_AS").text("0원");
                    $("#spDtl_B_return").text("0원");
                    $("#spDtl_B_1").text("0원");
                    //$("#spDtl_B_2").text("0원");
                    $("#spDtl_B_3").text("0원");

                    $("#lblDtl_C_tot").text("0원");
                    $("#spDtl_C_1").text("0원");
                    //$("#spDtl_C_2").text("0원");
                    $("#spDtl_C_3").text("0원");

                    $("#lblDtl_D_tot").text("0원");
                    $("#spDtl_D_1").text("0원");

                    $("#lblDtl_E_tot").text("0원");
                    $("#spDtl_E_1").text("0원");
                    $("#spDtl_E_2").text("0원");
                    $("#spDtl_E_3").text("0원");
                    $("#spDtl_E_4").text("0원");
                    $("#spDtl_E_5").text("0원");
                    $("#spDtl_E_6").text("0원");
                    $("#spDtl_E_7").text("0원");
                    $("#spDtl_F").text("0원");
                    $("#lblDtl_G_tot").text("0원");
                }

                //var e = document.getElementById('balDiv');
                //if (e.style.display == 'block') {
                //    e.style.display = 'none';

                //} else {
                //    e.style.display = 'block';
                //    $(".balWrapper").draggable();
                //}

                fnOpenDivLayerPopup('balDiv');
            }

            var saleCompCode = $(el).find("input:hidden[name^='hdSaleCompCode']").val();

            if (isEmpty(saleCompCode)) {
                alert("판매사코드의 부재로 인해 검색을 할 수 없습니다. 브라우저창을 닫고 다시 시도해 주세요.");
                return false;
            }

            var param = {
                Method: 'GetProfitSummary_D_Admin',
                SvidUser: '<%=Svid_User%>',
                StartDate: $("#<%=this.txtSearchSdate.ClientID%>").val(),
                EndDate: $("#<%=this.txtSearchEdate.ClientID%>").val(),
                SaleCompCode: saleCompCode
            };

            var beforeSend = function () {
                $('#divLoading').css('display', '');
            }
            var complete = function () {
                $('#divLoading').css('display', 'none');
            }

            JqueryAjax('Post', '../../Handler/PayHandler.ashx', true, false, param, 'json', callback, beforeSend, complete, true, '<%=Svid_User%>');


        }

       

        function fnEnter() {
            if (event.keyCode == 13) {
                fnPayProfitList(1);
                return false;
            }
            else
                return true;
        }


        function fnEnterDate() {

            if (event.keyCode == 13) {

                argStr1 = $("#<%=this.txtSearchSdate.ClientID%>").val();
                argStr2 = $("#<%=this.txtSearchEdate.ClientID%>").val();
                AutoDateSet(argStr1, argStr2)
                return false;
            }
            else
                return true;
        }

        //날짜 데이터 하이픈 넣기
        function AutoDateSet(argStr1, argStr2) {
            var retVal1;
            var retVal2;

            if (argStr1 !== undefined && String(argStr1) !== '') {

                var regExp = /[\{\}\[\]\/?.,;:|\)*~`!^\-_+<>@\#$%&\\\=\(\'\"]/gi;

                var tmp = String(argStr1).replace(/(^\s*)|(\s*$)/gi, '').replace(regExp, ''); // 공백 및 특수문자 제거

                if (tmp.length <= 4) {

                    retVal1 = tmp;

                } else if (tmp.length > 4 && tmp.length <= 6) {

                    retVal1 = tmp.substr(0, 4) + '-' + tmp.substr(4, 2);

                } else if (tmp.length > 6 && tmp.length <= 8) {

                    retVal1 = tmp.substr(0, 4) + '-' + tmp.substr(4, 2) + '-' + tmp.substr(6, 2);

                } else {

                    alert('날짜 형식이 잘못되었습니다.\n입력된 데이터:' + tmp);

                    retVal1 = '';

                }

            }

            if (argStr2 !== undefined && String(argStr2) !== '') {
                var regExp = /[\{\}\[\]\/?.,;:|\)*~`!^\-_+<>@\#$%&\\\=\(\'\"]/gi;

                var tmp2 = String(argStr2).replace(/(^\s*)|(\s*$)/gi, '').replace(regExp, ''); // 공백 및 특수문자 제거

                if (tmp2.length <= 4) {

                    retVal2 = tmp2;

                } else if (tmp2.length > 4 && tmp2.length <= 6) {

                    retVal2 = tmp2.substr(0, 4) + '-' + tmp2.substr(4, 2);

                } else if (tmp2.length > 6 && tmp2.length <= 8) {

                    retVal2 = tmp2.substr(0, 4) + '-' + tmp2.substr(4, 2) + '-' + tmp2.substr(6, 2);

                } else {

                    alert('날짜 형식이 잘못되었습니다.\n입력된 데이터:' + tmp2);

                    retVal2 = '';

                }

            }

            $("#<%=this.txtSearchSdate.ClientID%>").val(retVal1);
            $("#<%=this.txtSearchEdate.ClientID%>").val(retVal2);
            return retVal1, retVal2;
        }

        function fnTabClickRedirect(pageName) {
            location.href = pageName + '.aspx?ucode=' + ucode;
            return false;
        }
    </script>

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div class="all">
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
                     <%--<li class='tabOn' style="width: 185px;" onclick="fnTabClickRedirect('BalanceSummary');">
                        <a onclick="fnTabClickRedirect('BalanceSummary');">정산요약</a>
                     </li>--%>
                    <li class='tabOn' style="width: 185px;" onclick="fnTabClickRedirect('ProfitList');">
                         <a onclick="fnTabClickRedirect('ProfitList');">매출정산내역</a>
                    </li>
                    <%--<li class='tabOff' style="width: 185px;" onclick="fnTabClickRedirect('ReturnList');">
                         <a onclick="fnTabClickRedirect('ReturnList');">반품내역</a>
                    </li>--%>
                    <li class='tabOff' style="width: 185px;" onclick="fnTabClickRedirect('../Order/OrderBillIssueCheck');">
                        <a onclick="fnTabClickRedirect('../Order/OrderBillIssueCheck');">전자세금계산서 발행내역</a>
                    </li>
                    <li class='tabOff' style="width: 185px;" onclick="fnTabClickRedirect('BillPayment');">
                         <a onclick="fnTabClickRedirect('BillPayment');">대금정산</a>
                    </li>
                </ul>
            </div>

            <!--상단영역 시작-->
            <div class="search-div">
                <table id="tblSearchList" class="tbl_main">
                    <colgroup>
                        <col style="width:200px;"/>
                        <col />
                        <col style="width:200px;"/>
                        <col />
                    </colgroup>
                    <thead>
                        <tr>
                            <th colspan="4">정산현황</th>
                        </tr>
                    </thead>
                    <tr>
                        <th>주문일</th>
                        <td>
                            <asp:TextBox ID="txtSearchSdate" runat="server" MaxLength="10" CssClass="calendar" OnkeyPress="return fnEnterDate();" placeholder="2018-01-01" ReadOnly="true"></asp:TextBox>
                            -
                            <asp:TextBox ID="txtSearchEdate" runat="server" MaxLength="10" CssClass="calendar" OnkeyPress="return fnEnterDate();" placeholder="2018-12-30" ReadOnly="true"></asp:TextBox>&nbsp;&nbsp;&nbsp;
                            <input type="checkbox" name="chkBox" id="ckbSearch1" value="1" checked="checked" /><label for="ckbSearch1">1일</label>
                            <input type="checkbox" name="chkBox" id="ckbSearch2" value="7" /><label for="ckbSearch2">7일</label>
                            <input type="checkbox" name="chkBox" id="ckbSearch3" value="15" /><label for="ckbSearch3">15일</label>
                            <input type="checkbox" name="chkBox" id="ckbSearch4" value="30" /><label for="ckbSearch4">30일</label>
                            <input type="checkbox" name="chkBox" id="ckbSearch5" value="90" /><label for="ckbSearch5">90일</label>
                            <input type="checkbox" name="chkBox" id="ckbSearch6" value="0" /><label for="ckbSearch6">직접입력</label>
                        </td>

                        <th>판매사</th>
                        <td>
                            <asp:TextBox runat="server" class="medium-size" ID="txtSaleComp" Onkeypress="return fnEnter();"></asp:TextBox></td>
                    </tr>
                </table>
            </div>
            <!--조회하기 버튼-->
            <div class="bt-align-div">
                <input type="button" class="mainbtn type1" style="width: 95px; height: 30px; border-radius:5px;font-size: 12px; margin-bottom:2px" value="조회하기" onclick="fnPayProfitList(1); return false;" />
            </div>
            <span style="color: #69686d; float: right; margin-top: 10px; margin-bottom: 10px;">*<b style="color: #ec2029; font-weight: bold;"> VAT(부가세)포함 가격</b>입니다.</span>


            <div class="balDiv">
                <table class="tbl_main" id="tblPayProfit">
                    <thead>
                        <tr>
                            <th style="width: 50px;">번호</th>
                            <th>매출기간</th>
                            <th>구매사명</th>
                            <th>판매사코드</th>
                            <th>판매사명</th>
                            <th>판매사매출<br />
                                (A)</th>
                            <th>플랫폼수수료<br />
                                (B)</th>
                            <th>판매사매입<br />
                                (C)</th>
                            <th>배송비수수료<br />
                                (D)</th>
                            <th style="width: 80px;">PG사수수료<br />
                                (E)</th>
                            <th>전자세금계산서<br />
                                발행비용(F)</th>
                            <th>정산금액<br />
                                (G)=A-(B+C+D+E)</th>
                        </tr>
                    </thead>
                    <tbody id="tbodyPayProfit">
                        <tr>
                            <td colspan="12" class="txt-center">조회된 리스트가 없습니다.</td>
                        </tr>
                    </tbody>
                </table>
            </div>
            <br />
            <%--페이징 영역--%>
            <div style="margin: 0 auto; text-align: center">
                <input type="hidden" id="hdTotalCount" />
                <div id="pagination" class="page_curl" style="display: inline-block"></div>
            </div>

            <!--엑셀 저장-->
            <div class="bt-align-div">
                <asp:Button ID="btnExcelExport" runat="server" Width="95" Height="30" Text="엑셀 저장" OnClick="btnExcelExport_Click" CssClass="mainbtn type1"/>
                
            </div>

            <!--정산내용 상세 팝업div 영역-->
            <div id="balDiv" class="popupdiv divpopup-layer-package">
                <div class="popupdivWrapper" style="width:600px;">
                    <div class="balContent" style="border: none;">
                        <div class="popupdivContents">
                            <div class="close-div">
                                <a onclick="fnClosePopup('balDiv'); return false;" style="cursor: pointer">
                                    <img src="../../Images/Wish/icon-delete.jpg" alt="닫기" style="float: right;" /></a>
                            </div>
                            <div class="popup-title">
                                <%--<img src="../Images/Goods/balPop-title.jpg" alt=" 정산내용상세팝업" style="margin-bottom: 30px" />--%>
                                <h3 class="pop-title">정산내용상세팝업</h3>

                                <div style="overflow-y: scroll">
                                    <div style="height: 680px">
                                        <table class=" tbl_main tbl_popup" style="margin-top: 0px">

                                            <tr>
                                                <th colspan="3">판매사 정산 요약</th>
                                                <th>기간:
                                                    <label id="lblSearchDue"></label>
                                                </th>
                                            </tr>

                                            <tr>
                                                <th style="width: 30%">구분</th>
                                                <th colspan="2" style="width: 40%;">상세구분</th>
                                                <th>금액(원)</th>
                                            </tr>

                                            <!--********************************************************-->
                                            <tr>
                                                <th rowspan="4">매출금액(A)<br />
                                                    (판매사≠공급사)</th>
                                                <%--<th colspan="2" style="text-align: center;">판매사 매출 합계(A)=(①+②+③)-④</th>--%>
                                                <th colspan="2" style="text-align: center;">판매사 매출 합계(A)=(①+②)-③</th>
                                                <th>
                                                    <label id="lblDtl_A_tot"></label>
                                                </th>
                                            </tr>
                                            <tr>
                                                <td colspan="2">①상품매출(일반)</td>
                                                <td style="text-align: right; padding-right: 35px;"><span id="spDtl_A_1"></span></td>
                                            </tr>

                                            <%--<tr>
                                                <td colspan="2">②A/S매출(일반)</td>
                                                <td style="text-align: right; padding-right: 35px;"><span id="spDtl_A_2"></span></td>
                                            </tr>--%>

                                            <tr>
                                                <td colspan="2">②배송비용</td>
                                                <td style="text-align: right; padding-right: 35px;"><span id="spDtl_A_3"></span></td>
                                            </tr>

                                            <tr>
                                                <td colspan="2">③반품금액</td>
                                                <td style="text-align: right; padding-right: 35px;"><span id="spDtl_A_4"></span></td>
                                            </tr>

                                            <!--********************************************************-->
                                            <tr>
                                                <th rowspan="5">플랫폼수수료(B)<br />
                                                    (판매사=공급사)</th>
                                                <%--<th colspan="2" style="text-align: center;">플랫폼 수수료(B)=(①+②)-③</th>--%>
                                                <th colspan="2" style="text-align: center;">플랫폼 수수료(B)=①-②</th>
                                                <th>
                                                    <label id="lblDtl_B_tot"></label>
                                                </th>
                                            </tr>
                                            <tr>
                                                <td colspan="2">상품매출(수수료정산대상)</td>
                                                <td style="text-align: right; padding-right: 35px;"><span id="spDtl_B_goods"></span></td>
                                            </tr>

                                            <%--<tr>
                                                <td colspan="2">A/S매출(수수료정산대상)</td>
                                                <td style="text-align: right; padding-right: 35px;"><span id="spDtl_B_AS"></span></td>
                                            </tr>--%>

                                            <tr>
                                                <td colspan="2">반품금액(수수료정산대상)</td>
                                                <td style="text-align: right; padding-right: 35px;"><span id="spDtl_B_return"></span></td>
                                            </tr>

                                            <tr>
                                                <td colspan="2">①매출(수수료정산대상)</td>
                                                <td style="text-align: right; padding-right: 35px;"><span id="spDtl_B_1"></span></td>
                                            </tr>
                                            <%--<tr>
                                                <td colspan="2">②A/S건 매출(수수료정산대상)</td>
                                                <td style="text-align: right; padding-right: 35px;"><span id="spDtl_B_2"></span></td>
                                            </tr>--%>
                                            <tr>
                                                <td colspan="2">②반품금액(수수료정산대상)</td>
                                                <td style="text-align: right; padding-right: 35px;"><span id="spDtl_B_3"></span></td>
                                            </tr>
                                            <!--********************************************************-->
                                            <tr>
                                                <th rowspan="3">판매사매입(C)</th>
                                                <th colspan="2" style="text-align: center;">판매사매입금액합계(C)=①-②</th>
                                                <th>
                                                    <label id="lblDtl_C_tot"></label>
                                                </th>
                                            </tr>
                                            <tr>
                                                <td colspan="2">①매출건 상품매입금액 </td>
                                                <td style="text-align: right; padding-right: 35px;"><span id="spDtl_C_1"></span></td>
                                            </tr>

                                            <%--<tr>
                                                <td colspan="2">②A/S건 부품매입금액</td>
                                                <td style="text-align: right; padding-right: 35px;"><span id="spDtl_C_2"></span></td>
                                            </tr>--%>

                                            <tr>
                                                <td colspan="2">②반품금액</td>
                                                <td style="text-align: right; padding-right: 35px;"><span id="spDtl_C_3"></span></td>
                                            </tr>

                                            <!--********************************************************-->
                                            <tr>
                                                <th rowspan="2">배송비용(D)</th>
                                                <th colspan="2" style="text-align: center;">배송비용금액 합계(D)=(①)</th>
                                                <th>
                                                    <label id="lblDtl_D_tot"></label>
                                                </th>
                                            </tr>
                                            <tr>
                                                <td colspan="2">①배송비용</td>
                                                <td style="text-align: right; padding-right: 35px;"><span id="spDtl_D_1"></span></td>
                                            </tr>
                                            <!--********************************************************-->
                                            <tr>
                                                <th rowspan="8">PG사 수수료(E)<br />
                                                    (일반매출+수수료대상매출+반품)</th>
                                                <th colspan="2" style="text-align: center;">PG사 수수료 합계(E)=①~⑦</th>
                                                <th>
                                                    <label id="lblDtl_E_tot"></label>
                                                </th>
                                            </tr>
                                            <tr>
                                                <td colspan="2">①신용카드<%--(3.0%)--%></td>
                                                <td style="text-align: right; padding-right: 35px;"><span id="spDtl_E_1"></span></td>
                                            </tr>

                                            <tr>
                                                <td colspan="2">②실시간계좌이체<%--(3.3%)--%></td>
                                                <td style="text-align: right; padding-right: 35px;"><span id="spDtl_E_2"></span></td>
                                            </tr>

                                            <tr>
                                                <td colspan="2">③가상계좌(건당 330원)</td>
                                                <td style="text-align: right; padding-right: 35px;"><span id="spDtl_E_3"></span></td>
                                            </tr>

                                            <tr>
                                                <td colspan="2">④계좌이체(후불)(건당 330원)</td>
                                                <td style="text-align: right; padding-right: 35px;"><span id="spDtl_E_4"></span></td>
                                            </tr>

                                            <tr>
                                                <td colspan="2">⑤ARS(카드결제)<%--(3.3%)--%></td>
                                                <td style="text-align: right; padding-right: 35px;"><span id="spDtl_E_5"></span></td>
                                            </tr>
                                            <%--<tr>
                                                <td colspan="2">⑥여신결제(일반)(3.3%)</td>
                                                <td style="text-align: right; padding-right: 35px;"><span id="spDtl_E_6"></span></td>
                                            </tr>--%>
                                            <tr>
                                                <td colspan="2">⑥가상계좌(고정)(건당 330원)</td>
                                                <td style="text-align: right; padding-right: 35px;"><span id="spDtl_E_6"></span></td>
                                            </tr>
                                            <tr>
                                                <td colspan="2">⑦취소수수료(건당 605원)</td>
                                                <td style="text-align: right; padding-right: 35px;"><span id="spDtl_E_7"></span></td>
                                            </tr>

                                            <!--********************************************************-->
                                            <tr>
                                                <th colspan="3">전자세금계산서 발행(F)(건당220원)</th>
                                                <td style="text-align: right; padding-right: 35px;"><span id="spDtl_F"></span></td>
                                            </tr>
                                            <tr>
                                                <th colspan="3">정산금액합계(G) [A-(B+C+D+E+F)=G]</th>
                                                <td style="text-align: right; padding-right: 35px; color: #eb222c; font-weight: bold">
                                                    <label id="lblDtl_G_tot"></label>
                                                </td>
                                            </tr>
                                        </table>
                                    </div>
                                </div>
                                <!--확인버튼 영역-->
                                <div class="btPop-div" style="text-align: center; margin-top: 10px;">
                                    <%--<asp:ImageButton runat="server" AlternateText="확인" OnClientClick="fnCancel(); return false;" ImageUrl="../Images/Member/submit-off.jpg" onmouseover="this.src='../Images/Member/submit-on.jpg'" onmouseout="this.src='../Images/Member/submit-off.jpg'" />--%>
                                    <input type="button" class="mainbtn type1" style="width:75px;" onclick="fnClosePopup('balDiv'); return false;" value="확인"/>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

</asp:Content>

