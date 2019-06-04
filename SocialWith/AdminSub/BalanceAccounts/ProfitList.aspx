<%@ Page Title="" Language="C#" MasterPageFile="~/AdminSub/Master/AdminSubMaster.master" AutoEventWireup="true" CodeFile="ProfitList.aspx.cs" Inherits="AdminSub_BalanceAccounts_ProfitList" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <link href="../Contents/Order/order.css" rel="stylesheet" />
    
  <script src="../../Scripts/jquery.inputmask.bundle.js"></script>

    <style>
        .auto-style1 {
            text-align: center;
            height: 30px;
        }

        .sub-tab-div a:nth-child(5) {
            margin-left: -3px;
        }
    </style>


    <script type="text/javascript">
      var qs = fnGetQueryStrings();
        var ucode = qs["ucode"];
    $(document).ready(function () {

      $("#<%=this.txtSearchSdate.ClientID%>").inputmask("9999-99-99");
            $("#<%=this.txtSearchEdate.ClientID%>").inputmask("9999-99-99");

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
                onSelect: function (dateText, inst) {         //달력에 변경이 생길 시 수행하는 함수. 
                    SetDate();
                }

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

            $('#tblSearch input[type="checkbox"]').change(function () {
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
                    $(this).attr('onClick', "location.href='OrderBillIssueCheck.aspx?ucode="+ucode+"'");
                    $(this).find('a').attr('href', 'OrderBillIssueCheck.aspx?ucode='+ucode+'');
                }
                else if ($(this).attr('id') == 'lipay') {
                    $(this).attr('onClick', "location.href='BillPayment.aspx?ucode="+ucode+"'");
                    $(this).find('a').attr('href', 'BillPayment.aspx?ucode='+ucode+'');
                }
            })

    });

        $(function () {
            fnSeachboxSet();
            fnProfitListBind(1);

            $("#tbodyProfitList").on("mouseenter", "tr", function () {

                $(this).find("td").css("background-color", "gainsboro");
                $(this).find("td").css("cursor", "pointer");
                var rowIdx = this.rowIndex;
                if ((rowIdx % 2) == 0) {
                    $(this).next().css("background-color", "gainsboro");
                    $(this).next().css("cursor", "pointer");
                } else {
                    $(this).prev().css("background-color", "gainsboro");
                    $(this).prev().css("cursor", "pointer");
                    //alert(rowIdx - 1);
                }

            });
            $("#tbodyProfitList").on("mouseleave", "tr", function () {

                $(this).find("td").css("background-color", "");

                var rowIdx = this.rowIndex;
                if ((rowIdx % 2) == 0) {
                    $(this).next().css("background-color", "");
                } else {
                    $(this).prev().css("background-color", "");
                }
            });
        })

        //달력 자동 세팅 함수  
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


        function fnSeachboxSet() {
            var tableid = 'tblSearch';
            ListCheckboxOnlyOne(tableid);

            var date = new Date();
            var firstDate = new Date(date.getFullYear(), date.getMonth(), 1);


           

            fnPaywayBind();
        }

        function fnPaywayBind() {

            var callback = function (response) {
                for (var i = 0; i < response.length; i++) {

                    var createHtml = '';

                    if (response[i].Map_Type != 0) {
                        createHtml = '<option value="' + response[i].Map_Type + '">' + response[i].Map_Name + '</option>';
                        $('#selectPayway').append(createHtml);
                    }
                }
                return false;
            }
            var param = {
                Method: 'GetCommList',
                Code: 'PAY',
                Channel: 3
            };
            JajaxSessionCheck('Post', '../../Handler/Common/CommHandler.ashx', param, 'json', callback, '<%=Svid_User%>');
        }

        // 주문상세 팝업 화면 로딩 시 데이터 설정
        function fnSetDetailPopupDataBind(response) {
            var ordGdsList = null;
            var payInfo = null;

            $.each(response, function (key, value) {
                switch (key) {
                    case "orderGoodsList":
                        ordGdsList = value;
                        break;
                    case "payInfo":
                        payInfo = value;
                        break;
                }
            });

            $("#tbody_pop_odrDtl").html("");
            $("#tbl_dtlPop_pay").html("");

            var defaultTag = "<tr style='height:30px'><th colspan= '2'> 결제금액</th></tr>"
                + "<tr><th style='width:150px'>결제방식</th>"
                + "<td id='tdDtl_payway'></td></tr>"
                + "<tr><th id='th_dtl_totSalePrice'>총 구매금액</th>"
                + "<td id='tdDtl_totSalePrice'></td></tr>"
                + "<tr><th>배송비</th>"
                + "<td id='tdDtl_dlvrCost'></td></tr>"
                + "<tr><th>특수 배송비</th>"
                + "<td id='tdDtl_powerDlvrCost'></td></tr>"
                + "<tr><th id='th_dtl_payPrice'>결제금액</th>"
                + "<td id='tdDtl_payPrice'></td></tr>"
            //+ "<tr><th id='th_dtl_payPrice'>결제TID</th>"
            //+ "<td id='tdPG_Tid'></td></tr>";

            //var defaultTag = "<tr><th colspan= '2'> 결제금액</th></tr>"
            //    + "<th>결제방식</th>"
            //    + "<td id='tdDtl_payway'></td></tr>"
            //    + "<tr><th id='th_dtl_totSalePrice'>총 결제금액</th>"
            //    + "<td id='tdDtl_totSalePrice'></td></tr>";

            //+ "<tr><th>결제계좌</th>"
            //+ "<td id='tdDtl_account'></td></tr>"
            //+ "<tr><th>은행</th>"
            //+ "<td id='tdDtl_bank'></td></tr>"
            //+ "<tr><th>예금주</th>"
            //+ "<td id='tdDtl_name'></td></tr>"
            //+ "<tr><th id='th_dtl_date'>입금일(까지)</th>"
            //+ "<td id='tdDtl_date'></td></tr>";

            $("#tbl_dtlPop_pay").append(defaultTag);

            var ordStat = fnSetOrderGoodsList(ordGdsList);
            var result = fnSetPayInfo(payInfo, ordStat);

            if (result) {
                //    var width = 1050;
                //    var height = 700;
                //    var left = (window.screen.width / 2) - (width / 2);
                //    var top = (window.screen.height / 2) - (height / 2);
                //    layer_popup_open("divPopup", "divPopup_check", top / 2, left, width, height);

                var e = document.getElementById('productDiv');

                if (e.style.display == 'block') {
                    e.style.display = 'none';

                } else {
                    e.style.display = 'block';
                }

            }
        }


        // 주문상세 팝업 - 주문상품 목록 설정
        function fnSetOrderGoodsList(list) {

            var ordStat = 0;
            var ordTotalSalePrice = 0;

            for (i in list) {
                // 상태값을 처음에 한 번만 저장
                if (i == 0) {
                    ordStat = list[i].OrderStatus;
                }


                var gdsFinalCtgrCode = list[i].GoodsFinalCategoryCode;
                var gdsGrpCode = list[i].GoodsGroupCode;
                var gdsCode = list[i].GoodsCode;
                var gdsName = list[i].GoodsFinalName;

                ordTotalSalePrice += Number(list[i].GoodsTotalSalePriceVAT);

                var src = "/GoodsImage" + "/" + gdsFinalCtgrCode + "/" + gdsGrpCode + "/" + gdsCode + "/" + gdsFinalCtgrCode + "-" + gdsGrpCode + "-" + gdsCode + '-sss.jpg';
                //$("#lbPrice").text(numberWithCommas(list[i].GoodsTotalSalePriceVAT));
                $("#lbPrice").text(numberWithCommas(list[i].Amt));
                var addRow = "<tr>";
                addRow += "<td rowspan='2'>" + list[i].OrderSaleCompanyName + "</td>";
                addRow += "<td style= 'text-align:left; padding-left:5px; border:1px solid #a2a2a2;' rowspan='2'>"
                    + "<table style='width:100%;' id='tblGoodsInfo_pop'><tr><td rowspan='2' style='width:20%; border:0;'><img  style='width:50px; height=50px' onerror= 'no_image(this, \"s\")' src= '" + src + "' alt= '" + gdsName + "' title= '" + gdsName + "'/></td><td style='text-align:left; border:0;'>" + list[i].GoodsCode + "</td></tr><tr><td style='text-align:left; border:0;'>" + "[" + list[i].BrandName + "] " + list[i].GoodsFinalName + "<br /><span style='color:#368AFF'>" + list[i].GoodsOptionSummaryValues + "</span></td></tr></table>"
                    + "<input type='hidden' name='hd_dtl_OdrCodeNo' value='" + list[i].OrderCodeNo + "' />"
                    + "</td>";
                addRow += "<td style='text-align: center'>" + list[i].GoodsModel + "</td>";
                addRow += "<td rowspan='2' id='tdDtlSalePrice' style='text-align:right; padding-right:5px;'>" + numberWithCommas(list[i].GoodsSalePriceVat) + " 원</td>";
                addRow += "<td rowspan='2' id='tdDtlQty'>" + list[i].Qty + "개</td>";
                addRow += "<td rowspan='2' id='tdDtlTotSalePrice' style='text-align:right; padding-right:5px;'>" + numberWithCommas(list[i].GoodsTotalSalePriceVAT) + " 원</td>";
                addRow += "<td>" + list[i].GoodsDeliveryOrderDue_Name + "</td>";
                addRow += "<td rowspan='2'>" + list[i].OrderStatus_NAME + "</td>";
                addRow += "<td rowspan='2'>" + list[i].PayWayName + "</td></tr>";
                //-----------------------------------------------------------------다음행-----------------------------------------------------------------------------------------------------------//
                addRow += "<tr><td id= 'tdDtlUnit' > " + list[i].GoodsUnitQty + list[i].GoodsUnit_Name + "</td >";
                addRow += "<td></td></tr>";

                $("#tbody_pop_odrDtl").append(addRow);
            }

            return ordStat;
        }

        // 주문상세 팝업 - 결제정보 설정
        function fnSetPayInfo(info, ordStat) {

            if (isEmpty(info)) {
                alert("오류가 발생했습니다. 관리자에게 문의하세요.");
                return false;
            }

            var payway = info.Payway;

            // 공통항목
            $("#tdDtl_payway").text(info.Payway_Name);
            $("#tdDtl_totSalePrice").text(numberWithCommas(info.Total_GoodsSalePriceVat) + "원");
            $("#tdDtl_dlvrCost").text(numberWithCommas(info.DeliveryCost) + "원");
            $("#tdDtl_powerDlvrCost").text(numberWithCommas(info.PowerDeliveryCost) + "원");
            $("#tdDtl_payPrice").text(numberWithCommas(info.Amt) + "원");

            //$("#th_dtl_date").text(info.VbankNo);

            var numOrdStat = Number(ordStat);

            // 주문취소인 경우
            if ((numOrdStat >= 400) && (numOrdStat < 500)) {

                $("#th_dtl_totSalePrice").text("총 구매취소금액");
                $("#th_dtl_payPrice").text("결제취소금액");

            } else { // 주문완료인 경우

                $("#th_dtl_totSalePrice").text("총 구매금액");
                $("#th_dtl_payPrice").text("결제금액");
                var addTag = "";

                switch (payway) {
                    case '1':
                        addTag = "<tr><th>카드번호</th>"
                            + "<td>" + info.PayCardNo + "</td></tr>"
                            + "<tr><th>카드명</th>"
                            + "<td>" + info.PayCardName + "</td></tr>";
                        break;
                    case '2':
                        addTag = "<tr><th>결제계좌</th>"
                            + "<td>XXXXXXXXXXXX(개인정보보호)</td></tr>"
                            + "<tr><th>은행</th>"
                            + "<td>" + info.BankName + "</td></tr>";
                        break;
                    case '3':
                        addTag = "<tr><th>결제계좌</th>"
                            + "<td>" + info.VbankNo + "</td></tr>"
                            + "<tr><th>은행</th>"
                            + "<td>" + info.VbankName + "</td></tr>"
                            + "<tr><th>예금주</th>"
                            + "<td>" + info.BankTypeName + "</td></tr>";
                        break;
                    case '4':
                        addTag = "<tr><th>결제계좌</th>"
                            + "<td>" + info.VbankNo + "</td></tr>"
                            + "<tr><th>은행</th>"
                            + "<td>" + info.VbankName + "</td></tr>"
                            + "<tr><th>예금주</th>"
                            + "<td>" + info.BankTypeName + "</td></tr>";
                        break;
                }

                // $("#tbl_dtlPop_pay").append(addTag);
            }

            return true;
        }

        // 취소 버튼 클릭 시 팝업 닫기
        function fnCancel() {
            $('.divpopup-layer-package').fadeOut();
        }

        //목록에서 행 클릭 시 팝업 띄움
        function fnSelectOrdDtlPopup(el) {
            var payway = $(el).find("input:hidden[name^=hdPayWay]").val();
            var hdSaleAmt = $(el).find("input:hidden[name^=hdSaleAmt]").val();
            
            if ((hdSaleAmt == "0") && ((payway == "1") || (payway == "2") || (payway == "5"))) {
                alert("신용카드나 실시간계좌이체의 취소건에 대한 주문상세내역은 개발예정입니다.");
                return false;
            }

            var callback = function (response) {
                if (!isEmpty(response)) {

                    fnSetDetailPopupDataBind(response);

                } else {
                    alert("오류가 발생했습니다. 잠시 후 다시 시도해 주세요.");
                }

                return false;
            };

            var sUser = '<%= Svid_User %>';
            var ordCodeNo = $(el).find("input:hidden[name^=hdOrderCodeNo]").val();
            var odrStat = $(el).find("input:hidden[name^=hdOrdStat]").val();
            var param = { OdrCodeNo: ordCodeNo, OdrStat: odrStat, Method: "OrderDtlInfoAllUser" };
            JajaxSessionCheck("Post", "../../Handler/OrderHandler.ashx", param, "json", callback, sUser); // ajax 호출

        }

        function fnProfitListBind(pageNo) {
            $('#tblProfitList tbody').find('tr').remove(); //테이블 클리어
            var callback = function (response) {
                var newRowContent = '';
                if (!isEmpty(response)) {
                    for (var i = 0; i < response.length; i++) {

                        var payConfirmDate = '';
                        var entryDate = '';

                        if (response[i].PayConfirmDate != null) {
                            payConfirmDate = response[i].PayConfirmDate.split('T')[0];
                        }

                        if (response[i].EntryDate != null) {
                            entryDate = response[i].EntryDate.split('T')[0];
                        }

                        $('#hdTotalCount').val(response[i].TotalCount);

                        newRowContent += "<tr onclick='fnSelectOrdDtlPopup(this)'>";
                        newRowContent += "<td class='txt-center' rowspan='2'>" + response[i].RowNum + "";

                        newRowContent += "<input type= 'hidden' name= 'hdOrderCodeNo' value= '" + response[i].OrderCodeNo + "' />"
                        newRowContent += "<input type= 'hidden' name= 'hdPayWay' value= '" + response[i].Payway + "' />"
                        newRowContent += "<input type= 'hidden' name= 'hdOrdStat' value= '" + response[i].OrderStatus + "' />"
                        newRowContent += "<input type= 'hidden' name= 'hdSaleAmt' value= '" + response[i].SaleAMT + "' />"

                        newRowContent += "</td>";
                        newRowContent += "<td class='txt-center' rowspan='2'>" + payConfirmDate + "";
                        newRowContent += "</td>";
                        newRowContent += "<td class='txt-center'> " + entryDate + "";
                        newRowContent += "</td>";
                        newRowContent += "<td class='txt-center'>" + response[i].BuyerCompany_Name + "";
                        newRowContent += "</td>";
                        newRowContent += "<td class='txt-center' rowspan='2'>" + response[i].GoodsName + "<br/>(" + response[i].GoodsQty + "개)";
                        newRowContent += "</td>";

                        newRowContent += "<td style='padding-right:5px; text-align:right;' rowspan='2'>" + numberWithCommas(response[i].SaleAMT) + "원<br/>(" + response[i].Payway_Name + ")";
                        newRowContent += "</td>";
                        newRowContent += "<td style='padding-right:5px; text-align:right;' rowspan='2'>" + numberWithCommas(response[i].CustAMT) + "원";
                        newRowContent += "</td>";

                        newRowContent += "<td style='padding-right:5px; text-align:right;' rowspan='2'>" + numberWithCommas(response[i].SupplyJung) + "원";
                        newRowContent += "</td>";


                        newRowContent += "<td style='padding-right:5px; text-align:right;' rowspan='2'>" + numberWithCommas(response[i].DeliveryJung) + "원";
                        newRowContent += "</td>";


                        newRowContent += "<td style='padding-right:5px; text-align:right;' rowspan='2'>" + numberWithCommas(response[i].BillJung) + "원";
                        newRowContent += "</td>";

                        var PGJung = numberWithCommas(response[i].PGJung) + "원";
                        var totalJung = numberWithCommas(response[i].TotalJung) + "원";
                        if (response[i].SaleAMT == "0") {
                            PGJung = "<label style='color:red; font-weight:normal;'>(" + PGJung + ")</label>";
                            totalJung = "<label style='color:red; font-weight:normal;'>" + totalJung + "</label>";
                        }

                        newRowContent += "<td style='padding-right:5px; text-align:right;' rowspan='2'>" + PGJung;
                        newRowContent += "</td>";
                        newRowContent += "<td style='padding-right:5px; text-align:right;' rowspan='2'>" + totalJung;

                        newRowContent += "</td>";
                        newRowContent += "</tr>";

                        //------------------------------------------------------------------------------------------//
                        newRowContent += "<tr>";
                        newRowContent += "<td class='txt-center'>" + response[i].OrderCodeNo + "";
                        newRowContent += "</td>";
                        newRowContent += "<td class='txt-center'> " + response[i].BuyerName + "";
                        newRowContent += "</td>";
                        newRowContent += "</tr>";

                    }
                    $('#tblProfitList tbody').append(newRowContent);
                }
                else {
                    $("#hdTotalCount").val(0);
                    $('#tblProfitList tbody').append("<tr><td colspan='12' class='text-center'>데이터가 없습니다</td></tr>");
                }

                fnCreatePagination('pagination', $("#hdTotalCount").val(), pageNo, 20, getPageData);
                return false;

            };
            var param = {
                Method: 'GetAdminSubBAProfitList',
                SvidUser: '<%=Svid_User%>',
                StartDate: $("#<%=this.txtSearchSdate.ClientID%>").val(),
                EndDate: $("#<%=this.txtSearchEdate.ClientID%>").val(),
                SvidCompNo: '<%=UserInfoObject.UserInfo.Company_No%>',
                BuyerCompName: $("#<%=this.txtBuyerCompName.ClientID%>").val(),
                Payway: $("#<%=this.ddlSelectPayway.ClientID%>").val(),
                PageNo: pageNo,
                PageSize: 20
            };
            JajaxSessionCheck('Post', '../../Handler/PayHandler.ashx', param, 'json', callback, '<%=Svid_User%>');
        }

        function fnSetDate(date) {

            var returnVal = '';
            if (date == '' || date == null) {
                return returnVal;
            }
            else {
                returnVal = date.split("T")[0]
            }
            return returnVal;
        }



        function getPageData() {
            var container = $('#pagination');
            var getPageNum = container.pagination('getSelectedPageNum');
            fnProfitListBind(getPageNum);
            return false;
        }
        function fnSearch() {
            fnProfitListBind(1);
        }

        function fnEnter() {

            if (event.keyCode == 13) {
                fnSearch();
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
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div class="all">
        <div class="sub-contents-div">
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
                    <li id="lipl" class='tabOn' style="width: 185px;">
                        <a>매출정산내역</a>
                    </li>
                    <li id="lirl" class='tabOff' style="width: 185px;">
                        <a>반품내역</a>
                    </li>
                    <li id="liob"  class='tabOff' style="width: 185px;">
                        <a>전자세금계산서 발행내역</a>
                    </li>
                    <li id="lipay"  class='tabOff' style="width: 185px;">
                        <a>대금정산</a>
                    </li>
                </ul>
            </div>


            <!--상단영역 시작-->
            <div class="search-div">
                <table id="tblSearch">
                    <thead>
                        <tr>
                            <th colspan="4" style="height: 40px;">매출정산내역</th>
                        </tr>
                    </thead>
                    <tr>
                        <th style="width: 100px;">주문일</th>
                        <td style="text-align: left">
                                  <asp:textbox id="txtSearchSdate" runat="server" maxlength="10" cssclass="calendar" onkeypress="return fnEnterDate();" placeholder="2018-01-01" readonly="true"></asp:textbox>
                            -
                            <asp:textbox id="txtSearchEdate" runat="server" maxlength="10" cssclass="calendar" onkeypress="return fnEnterDate();" placeholder="2018-12-30" readonly="true"></asp:textbox>
                            &nbsp;&nbsp;&nbsp;
                            <input type="checkbox" name="chkBox" id="ckbSearch1" value="1" checked="checked" /><label for="ckbSearch1">1일</label>
                            <input type="checkbox" name="chkBox" id="ckbSearch2" value="7" /><label for="ckbSearch2">7일</label>
                            <input type="checkbox" name="chkBox" id="ckbSearch3" value="15" /><label for="ckbSearch3">15일</label>
                            <input type="checkbox" name="chkBox" id="ckbSearch4" value="30" /><label for="ckbSearch4">30일</label>
                            <input type="checkbox" name="chkBox" id="ckbSearch5" value="90" /><label for="ckbSearch5">90일</label>
                            <input type="checkbox" name="chkBox" id="ckbSearch6" value="0" /><label for="ckbSearch6">직접입력</label>

                        </td>
                        <th style="width: 100px;">구매사</th>
                        <td style="width: 300px;">
                            <asp:TextBox ID="txtBuyerCompName" runat="server" Height="100%" OnKeypress="return fnEnter();" Width="100%" Style="border: 1px solid #a2a2a2;"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <th style="width: 200px;">결제수단</th>
                        <td style="text-align: left;" colspan="3">
                            <asp:DropDownList ID="ddlSelectPayway" CssClass="input-drop" runat="server" Width="200px" Style="margin-left: 3px">
                                <asp:ListItem Value="all" Text="---전체---"></asp:ListItem>
                            </asp:DropDownList>
                        </td>
                        <%--<th style="width: 100px;">진행구분</th>

                        <td style="width: 200px;">
                            <asp:DropDownList CssClass="input-drop" runat="server" Height="24px">
                                <asp:ListItem Value="all" Text="---전체---"></asp:ListItem>
                                <asp:ListItem Value="all" Text="매출정산"></asp:ListItem>
                                <asp:ListItem Value="all" Text="매출취소"></asp:ListItem>
                            </asp:DropDownList>
                        </td>--%>
                    </tr>
                </table>
            </div>
            <!--상단영역 끝-->

            <!--조회하기 버튼-->
            <div class="bt-align-div">
                 <input type="button" class="mainbtn type1" value="조회하기" style="width:95px; height:30px" onclick="fnSearch(); return false;"/>
            </div>

            <span style="color: #69686d; float: right; margin-top: 10px; margin-bottom: 10px;">*<b style="color: #ec2029; font-weight: bold;"> VAT(부가세)포함 가격</b>입니다.</span>

            <!--하단영역시작-->
            <div class="profitList-div" style="width: 100%;">
                <table id="tblProfitList" style="width: 100%">
                    <thead>
                        <tr>
                            <th class="text-center" rowspan="2" style="width: 100px">번호</th>
                            <th class="text-center" rowspan="2" style="width: 100px">입금날짜</th>
                            <th class="text-center" style="width: 100px">주문일자</th>
                            <th class="text-center" style="width: 120px">구매사</th>
                            <th class="text-center" rowspan="2" style="width: 250px">상품명<br />
                                (수량)</th>
                            <th class="text-center" rowspan="2" style="width: 120px">구매사<br />
                                매출정산<br />
                                (결제수단)</th>
                            <th class="text-center" rowspan="2" style="width: 100px">판매사<br />
                                매출정산</th>
                            <th class="text-center" rowspan="2" style="width: 100px">플랫폼<br />
                                이용 수수료</th>
                            <th class="text-center" rowspan="2" style="width: 100px">배송비<br />
                                수수료</th>
                            <th class="text-center" rowspan="2" style="width: 100px">세금계산서<br />
                                수수료정산</th>
                            <th class="text-center" rowspan="2" style="width: 100px">PG<br />
                                수수료정산<br />(취소 수수료)</th>
                            <th class="text-center" rowspan="2" style="width: 100px">대금정산</th>
                        </tr>
                        <tr>
                            <th class="auto-style1">주문번호</th>
                            <th class="auto-style1">구매자</th>
                        </tr>
                    </thead>
                    <tbody id="tbodyProfitList">
                    </tbody>
                </table>

            </div>

            <br />

            <input type="hidden" id="hdTotalCount" />
            <div style="margin: 0 auto; text-align: center">
                <div id="pagination" class="page_curl" style="display: inline-block"></div>
            </div>
            <!-- 페이징 처리 -->

            <!--하단영역끝-->

            <!--엑셀 저장-->
            <!--엑셀 저장-->
            <div class="bt-align-div">
                <asp:Button id="btnExcel" runat="server" Text="엑셀저장" CssClass="mainbtn type1" Width="95" Height="30" OnClick="btnExcel_Click"/>
            </div>

        </div>

        <%--주문상세 팝업 시작--%>
        <div id="productDiv" class="divpopup-layer-package">

            <div class="productWrapper">
                <div class="productContent" style="border: none;">

                     <div class="popup-title" style="margin-top: 20px;">
                            <h3 class="pop-title">주문상품</h3>
                        </div>

                    <%--<div class="mini-title">
                        <img src="../Images/Order/subOrder.jpg" alt="주문내역" /></div>--%>
                    <div style="text-align: right;">구매사 결제금액:<label id="lbPrice"></label>원</div>

                    <div class="tblOrder-div" style="height: 270px; width: 100%; overflow-y: auto; overflow-x: hidden;">
                        <table id="tblOrder">
                            <thead>

                                <tr>
                                    <th style="width: 80px;" rowspan="2">구매사</th>
                                    <th style="width: 270px;" rowspan="2">주문상품정보</th>
                                    <th style="width: 60px;">모델명</th>
                                    <th style="width: 70px;" rowspan="2">상품단가<br />
                                        (VAT포함)</th>
                                    <th style="width: 40px;" rowspan="2">수량</th>
                                    <th style="width: 70px;" rowspan="2">주문금액<br />
                                        (VAT포함)</th>
                                    <th style="width: 70px;">출하예정일</th>

                                    <th style="width: 60px;" rowspan="2">주문처리현황</th>
                                    <th style="width: 60px;" rowspan="2">결제수단</th>
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
                        <table id="tbl_dtlPop_pay" style="width: 100%"></table>
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

