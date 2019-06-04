<%@ Page Title="" Language="C#" MasterPageFile="~/AdminSub/Master/AdminSubMaster.master" AutoEventWireup="true" CodeFile="OrderHistoryList.aspx.cs" Inherits="AdminSub_Order_OrderHistoryList" %>
<%@ Import namespace="Urian.Core" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <link href="../Contents/Order/order.css" rel="stylesheet" />
    <script src="../../Scripts/jquery.inputmask.bundle.js"></script>

    <style>
         .ui-tooltip {
        padding: 0;
        max-width: 600px;
      }
        /*#tblSearch tr:hover td{
            background-color: gainsboro;
            cursor: pointer;
        }*/


        /*#tblSearch tr.selected td:not(:last-child) {
            background-color:gainsboro
        }*/
        /*소스용*/
        .budget-view {
            display: none;
        }

        table#tblGoodsInfo,
        table#tblGoodsInfo td,
        table#tblGoodsInfo_pop td {
            border: none !important;
        }
    </style>

    <script type="text/javascript">
        var qs = fnGetQueryStrings();
        var ordstatus = qs["ordstatus"];
        $(document).ready(function () {
            $("#<%=this.txtSearchSdate.ClientID%>").inputmask("9999-99-99");
            $("#<%=this.txtSearchEdate.ClientID%>").inputmask("9999-99-99");

            //체크박스 하나만 선택
            var tableid = 'tblHistoryList';
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
                onSelect: function (dateText, inst) {         //달력에 변경이 생길 시 수행하는 함수. 
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

            $('#tblHistoryList input[type="checkbox"]').change(function () {
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

            if (!isEmpty(ordstatus)) {
                $('#<%=ddlOrderStatus.ClientID %>').val(ordstatus);
                 var d = new Date()
                  var dayOfMonth = d.getDate()
                  d.setDate(dayOfMonth - 7)
                $('#<%= txtSearchSdate.ClientID%>').val(d.format("yyyy-MM-dd"));
                $('#<%= txtSearchEdate.ClientID%>').val(new Date().format("yyyy-MM-dd"));
                $('#ckbSearch2').prop('checked', 'checked');
                $('#ckbSearch1').prop('checked', '');
            }
            fnSearch(1);


        });

        

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

        //테이블 호버
        function setTableHover() {
            $("#tblSearch tbody tr:even").each(function (index, element) {
                $(element).find(".rowColor_td").mouseover(function () {
                    $(element).find(".rowColor_td").css("background-color", "gainsboro");
                    $("#tblSearch tbody tr:eq(" + (element.rowIndex + index + 1) + ")").find(".rowColor_td").css("background-color", "gainsboro");

                    $(element).find(".rowColor_td").css("cursor", "pointer");
                    $("#tblSearch tbody tr:eq(" + (element.rowIndex + index + 1) + ")").find(".rowColor_td").css("cursor", "pointer");
                });
                $(element).find(".rowColor_td").mouseout(function () {
                    $(".rowColor_td").css("background-color", "");
                });
            });

            $("#tblSearch tbody tr:odd").each(function (index, element) {
                $(element).find(".rowColor_td").mouseover(function () {
                    $(element).find(".rowColor_td").css("background-color", "gainsboro");
                    $("#tblSearch tbody tr:eq(" + (element.rowIndex + index - 4) + ")").find(".rowColor_td").css("background-color", "gainsboro");

                    $(element).find(".rowColor_td").css("cursor", "pointer");
                    $("#tblSearch tbody tr:eq(" + (element.rowIndex + index - 4) + ")").find(".rowColor_td").css("cursor", "pointer");
                });
                $(element).find(".rowColor_td").mouseout(function () {
                    $(".rowColor_td").css("background-color", "");
                });
            });

        }

        //초기화 
        function fnInitState() {
            alert('검색조건을 초기화 합니다.');
            window.location.reload(true);
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

            var defaultTag = "<tr style='height:30px'><th colspan= '2' > 결제금액</th></tr>"
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

            var selectGdsCode = $("#hdPopupGoodsCode").val(); //선택한 행의 상품코드

            for (i in list) {
                // 상태값을 처음에 한 번만 저장
                if (i == 0) {
                    ordStat = list[i].OrderStatus;
                }

                var gdsFinalCtgrCode = list[i].GoodsFinalCategoryCode;
                var gdsGrpCode = list[i].GoodsGroupCode;
                var gdsCode = list[i].GoodsCode;
                var gdsName = list[i].GoodsFinalName;

                var trColor = ''; //tr색

                if (selectGdsCode == gdsCode) {
                    trColor = "style='background-color: #FAF4C0;'";
                }

                var src = "/GoodsImage" + "/" + gdsFinalCtgrCode + "/" + gdsGrpCode + "/" + gdsCode + "/" + gdsFinalCtgrCode + "-" + gdsGrpCode + "-" + gdsCode + '-sss.jpg';
                //$("#lbPrice").text(numberWithCommas(list[i].GoodsTotalSalePriceVAT));
                var addRow = "<tr " + trColor + ">";
                addRow += "<td rowspan='2'>" + list[i].BuyCompany_Name + "</td>";
                addRow += "<td style= 'text-align:left; padding-left:5px; border:1px solid #a2a2a2;' rowspan='2'>"
                    + "<table style='width:100%;' id='tblGoodsInfo_pop'><tr><td rowspan='2' style='width:70px'><img  style='width:50px; height=50px' onerror= 'no_image(this, \"s\")' src= '" + src + "' alt= '" + gdsName + "' title= '" + gdsName + "'/></td><td style='text-align:left; width:280px'>" + list[i].GoodsCode + "</td></tr><tr><td style='text-align:left; width:280px'>" + "[" + list[i].BrandName + "] " + list[i].GoodsFinalName + "<br /><span style='color:#368AFF; width:280px; word-wrap:break-word; display:block;'>" + list[i].GoodsOptionSummaryValues + "</span></td></tr></table>"
                    + "<input type='hidden' name='hd_dtl_OdrCodeNo' value='" + list[i].OrderCodeNo + "' />"
                    + "</td>";
                addRow += "<td style='text-align: center' rowspan='2'>" + list[i].GoodsModel + "</td>";
                addRow += "<td style='text-align: center' >" + list[i].GoodsUnitMoq + " / " + list[i].GoodsUnit_Name + "</td>";
                addRow += "<td id='tdDtlSalePrice' style='text-align:right; padding-right:5px;'>" + numberWithCommas(list[i].GoodsSalePriceVat) + "원</td>";

                addRow += "<td>" + list[i].GoodsDeliveryOrderDue_Name + "</td>";
                addRow += "<td rowspan='2'>" + list[i].OrderStatus_NAME + "</td>";

                var paywayNm = list[i].PayWayName;
                var payway = list[i].PayWay;

                if ((payway == '3') || (payway == '9')) paywayNm = paywayNm.substring(0, 4);

                addRow += "<td rowspan='2'>" + paywayNm + "</td></tr>";
                //-----------------------------------------------------------------다음행-----------------------------------------------------------------------------------------------------------//
                addRow += "<tr " + trColor + "><td id= 'tdDtlUnit' > " + list[i].Qty + "</td >";
                addRow += "<td id='tdDtlTotSalePrice' style='text-align:right; padding-right:5px;'>" + numberWithCommas(list[i].GoodsTotalSalePriceVAT) + "원</td>";
                addRow += "<td>" + fnOracleDateFormatConverter(list[i].DeliveryDate) + "</td></tr>";

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
            var paywayNm = info.Payway_Name;
            if ((payway == '3') || (payway == '9')) paywayNm = paywayNm.substring(0, 4);

            $("#tdDtl_payway").text(paywayNm);
            $("#tdDtl_totSalePrice").text(numberWithCommas(info.Total_GoodsSalePriceVat) + "원");
            $("#tdDtl_dlvrCost").text(numberWithCommas(info.DeliveryCost) + "원");
            $("#tdDtl_powerDlvrCost").text(numberWithCommas(info.PowerDeliveryCost) + "원");
            $("#tdDtl_payPrice").text(numberWithCommas(info.Amt) + "원");

            $("#lbPrice").text(numberWithCommas(info.Total_GoodsSalePriceVat));

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

        // 주문상세 팝업
        function fnOdrDtlPopup(el) {
            $("#hdPopupGoodsCode").val($(el).find("input:hidden[name^='hdGdsCode']").val());

            var callback = function (response) {
                if (!isEmpty(response)) {

                    fnSetDetailPopupDataBind(response);

                } else {
                    alert("오류가 발생했습니다. 잠시 후 다시 시도해 주세요.");
                }

                return false;
            };

            var sUser = '<%= Svid_User %>';
            var odrCodeNo = $(el).find("input:hidden[name^=hdOrderCodeNo]").val();
            var odrStat = $(el).find("input:hidden[name^=hdOrdStat]").val();
            var uNumOrdNo = $(el).find("input:hidden[name='hdUorderNo']").val();
            var param = { OdrCodeNo: odrCodeNo, OdrStat: odrStat, UNumOrdNo: uNumOrdNo, Method: "OrderDtlInfoAllUser" };
            JajaxSessionCheck("Post", "../../Handler/OrderHandler.ashx", param, "json", callback, sUser); // ajax 호출
        }

        // 취소 버튼 클릭 시 팝업 닫기
        function fnCancel() {
            $('.divpopup-layer-package').fadeOut();
        }


        //조회하기
        function fnSearch(pageNum) {
            var odrStat = $('#<%=ddlOrderStatus.ClientID %>').val();
            var startDate = $('#<%= txtSearchSdate.ClientID%>').val();
            var endDate = $('#<%= txtSearchEdate.ClientID%>').val();
            var odrStat = $('#<%=ddlOrderStatus.ClientID %>').val();
            var payway = $('#<%=ddlPayWay.ClientID %>').val();
            var pageSize = 20;
            var i = 1;
            var asynTable = "";

            var callback = function (response) {
                $("#tblSearch tbody").empty();

                if (!isEmpty(response)) {
                    $.each(response, function (key, value) {

                        var dlvrDate = "";
                        if (!isEmpty(dlvrDate)) {
                            dlvrDate = value.DeliveryDate.split("T")[0];
                        }
                        var src = '/GoodsImage' + '/' + value.GoodsFinalCategoryCode + '/' + value.GoodsGroupCode + '/' + value.GoodsCode + '/' + value.GoodsFinalCategoryCode + '-' + value.GoodsGroupCode + '-' + value.GoodsCode + '-sss.jpg';
                        $("#hdTotalCount").val(value.TotalCount);
                        asynTable += "<tr class='trOrder' onClick='fnOdrDtlPopup(this); return false;'><input type='hidden' name='hdUorderNo' value='" + value.Unum_OrderNo + "' />"
                            + "<input type='hidden' name='hdOrderCodeNo' value='" + value.OrderCodeNo + "' />"
                            + "<input type='hidden' name='hdPayWay' value='" + value.PayWay + "' />"
                            + "<input type='hidden' name='hdOrdStat' value='" + value.OrderStatus + "' />"
                            + "<input type='hidden' name='hdGdsCode' value='" + value.GoodsCode + "' />";
                        asynTable += "<td rowspan='2' style='border:1px solid #a2a2a2;' class='rowColor_td'>" + value.RowNumber + "</td>";
                        asynTable += "<td style='border-right:1px solid #a2a2a2' class='rowColor_td'>" + value.EntryDate.split("T")[0] + "</td>";
                        asynTable += "<td rowspan='2' style='border:1px solid #a2a2a2;' class='rowColor_td'>" + value.OrderSaleCompanyName + "</td>";
                        var certImgDisplay = 'display:none';
                        if (!isEmpty(value.GoodsConfirmMark) && value.GoodsConfirmMark != '00000000') {
                            certImgDisplay = ''
                        }
                        asynTable += "<td style= 'text-align:left; padding-left:5px; border:1px solid #a2a2a2;' rowspan='2' class='rowColor_td'><table style='width:100%;' id='tblGoodsInfo'><tr><td rowspan='2' style='width:70px'><span class='spanCert' id='spanCert" + value.GoodsConfirmMark + "'  other-title='' style='" + certImgDisplay +"'>*인증상품</span><img src=" + src + " onerror='no_image(this, \"s\")' style='width:50px; height=50px'/></td><td style='text-align:left; '>" + value.GoodsCode + "</td></tr><tr><td style='text-align:left;'>" + "[" + value.BrandName + "] " + value.GoodsFinalName + "<br/><span style='color:#368AFF; word-wrap:break-word; display:block;'>" + value.GoodsOptionSummaryValues + "</span></td></tr></table></td>";
                        asynTable += "<td class='rowColor_td' rowspan='2'> " + value.GoodsModel + "</td >";
                        asynTable += "<td class='rowColor_td'> " + value.GoodsUnitMoq + " / " + value.GoodsUnit + "</td >";
                        asynTable += "<td style='border:1px solid #a2a2a2; padding-right: 5px; text-align: right;' class='rowColor_td'>" + numberWithCommas(value.GoodsSalePriceVat) + "원</td>";
                        asynTable += "<td class='rowColor_td'>" + value.GoodsDeliveryOrderDue_Name + "</td>";
                        asynTable += "<td rowspan='2' style='border:1px solid #a2a2a2' class='rowColor_td'>" + value.OrderStatus_NAME + "</td>";
                        asynTable += "<td rowspan='2' style='border:1px solid #a2a2a2' class='rowColor_td'>" + value.PayWayName + "</td></tr>";

                        //-----------------------------------------------------------------다음행-----------------------------------------------------------------------------------------------------------//
                        asynTable += "<tr class='trOrder' onClick='fnOdrDtlPopup(this); return false;'><input type='hidden' name='hdUorderNo' value='" + value.Unum_OrderNo + "' />"
                            + "<input type= 'hidden' name= 'hdOrderCodeNo' value= '" + value.OrderCodeNo + "' />"
                            + "<input type= 'hidden' name= 'hdPayWay' value= '" + value.PayWay + "' />"
                            + "<input type= 'hidden' name= 'hdOrdStat' value= '" + value.OrderStatus + "' />"
                            + "<input type='hidden' name='hdGdsCode' value='" + value.GoodsCode + "' />";
                        asynTable += "<td style= 'border-bottom:1px solid #a2a2a2;' class='rowColor_td' > " + value.OrderCodeNo + "</td > ";
                        asynTable += "<td style='border-bottom:1px solid #a2a2a2' class='rowColor_td'>" + value.Qty + "</td>";
                        asynTable += "<td style='padding-right: 5px; text-align: right;  border:1px solid #a2a2a2;' class='rowColor_td'>" + numberWithCommas(value.GoodsTotalSalePriceVAT) + "원</td>";
                        asynTable += "<td style='text-align:center; border-bottom:1px solid #a2a2a2' class='rowColor_td'>" + dlvrDate + "</td></tr>";
                        i++;

                    });
                } else {
                    asynTable += "<tr><td colspan='20' class='txt-center'>" + "조회된 주문내역이 없습니다." + "</td></tr>"
                    $("#hdTotalCount").val(0);
                }
                $("#tblSearch tbody").append(asynTable);
                setTableHover();
                SetCertifyImageSet();
                fnCreatePagination('pagination', $("#hdTotalCount").val(), pageNum, 20, getPageData);
            }

            var sUser = '<%= Svid_User%>';

            param = { SvidUser: sUser, OrderStatus: odrStat, PayWay: payway, TodateB: startDate, TodateE: endDate, Method: 'OrderHistory_A', PageNo: pageNum, PageSize: pageSize };


             JqueryAjax('Post', '../../Handler/OrderHandler.ashx', false, false, param, 'json', callback, null, null, false, '');
            //JajaxSessionCheck('Post', '../../Handler/OrderHandler.ashx', param, 'json', callback, sUser);
        }

        function SetCertifyImageSet() {
            $('.spanCert').tooltip({
                items: '[other-title]',
                content: function () {
                    var upload = '<%= ConfigurationManager.AppSettings["UpLoadFolder"].AsText()%>';
                    var code = $(this).prop('id').substring(8);
                    var html = '';
                    html = "<div>";
                    if (code.substring(0, 1) == '1') {
                        html += "<img class='map' alt= '사회적기업' src='" + upload + "CertificationImage/01.jpg' style='padding:5px'/>";

                    }
                    if (code.substring(1, 2) == '1') {
                        html += "<img class='map' alt= '한국여성경제인협회' src='" + upload + "/CertificationImage/02.jpg' style='padding:5px'/>";

                    }
                    if (code.substring(2, 3) == '1') {
                        html += "<img class='map' alt= '장애인표준사업장' src='" + upload + "/CertificationImage/03.jpg' style='padding:5px'/>";

                    }
                    if (code.substring(3, 4) == '1') {
                        html += "<img class='map' alt= 'COOP협동조합' src='" + upload + "/CertificationImage/04.jpg' style='padding:5px'/>";

                    }
                    if (code.substring(4, 5) == '1') {
                        html += "<img class='map' alt= '중증장애인생산품' src='" + upload + "/CertificationImage/05.jpg' style='padding:5px'/>";

                    }
                    if (code.substring(5, 6) == '1') {
                        html += "<img class='map' alt= '' src='" + upload + "/CertificationImage/06.jpg' style='padding:5px'/>";

                    }
                    if (code.substring(6, 7) == '1') {
                        html += "<img class='map' alt= '' src='" + upload + "/CertificationImage/07.jpg' style='padding:5px'/>";

                    }
                    if (code.substring(7, 8) == '1') {
                        html += "<img class='map' alt= '' src='" + upload + "UploadFile/CertificationImage/08.jpg' style='padding:5px'/>";

                    }
                    html += "</div>";
                    return html;
                },
                position: {
                    my: "center bottom",
                    at: "center top-6",
                }
            });
        }

        function getPageData() {
            var container = $('#pagination');
            var getPageNum = container.pagination('getSelectedPageNum');
            fnSearch(getPageNum);
            return false;
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
                    주문내역조회
                    <span class="span-title-subsentence">고객이 주문한 내역을 조회 할 수 있습니다.</span>
                </p>
            </div>


            <!--상단영역 시작-->
            <div class="search-div">
                <table id="tblHistoryList">

                    <thead>
                        <tr>
                            <th colspan="8">주문내역조회</th>
                        </tr>
                    </thead>
                    <tr>
                        <th style="width: 250px;">구분(처리상태)</th>
                        <td colspan="2">
                            <asp:DropDownList runat="server" ID="ddlOrderStatus" CssClass="input-drop" Style="width: 400px">
                            </asp:DropDownList>
                        </td>
                        <th class="txt-center" style="width: 250px;">결제수단</th>
                        <td colspan="2">
                            <asp:DropDownList runat="server" ID="ddlPayWay" CssClass="input-drop" Style="width: 400px">
                            </asp:DropDownList>
                        </td>

                    </tr>
                    <tr>
                        <th class="txt-center">조회기간
                        </th>
                        <td colspan="4">

                            <asp:TextBox ID="txtSearchSdate" runat="server" MaxLength="10" CssClass="calendar" onkeypress="return fnEnterDate();" placeholder="2018-01-01" ReadOnly="true"></asp:TextBox>
                            -
                            <asp:TextBox ID="txtSearchEdate" runat="server" MaxLength="10" CssClass="calendar" onkeypress="return fnEnterDate();" placeholder="2018-12-30" ReadOnly="true"></asp:TextBox>
                            &nbsp;&nbsp;&nbsp;
                            <input type="checkbox" name="chkBox" id="ckbSearch1" value="1" checked="checked" /><label for="ckbSearch1">1일</label>
                            <input type="checkbox" name="chkBox" id="ckbSearch2" value="7" /><label for="ckbSearch2">7일</label>
                            <input type="checkbox" name="chkBox" id="ckbSearch3" value="15" /><label for="ckbSearch3">15일</label>
                            <input type="checkbox" name="chkBox" id="ckbSearch4" value="30" /><label for="ckbSearch4">30일</label>
                            <input type="checkbox" name="chkBox" id="ckbSearch5" value="90" /><label for="ckbSearch5">90일</label>
                            <input type="checkbox" name="chkBox" id="ckbSearch6" value="0" /><label for="ckbSearch6">직접입력</label>

                        </td>
                    </tr>
                </table>

                <%--        <a><img src="../Images/Order/viewList.jpg"" alt="조회하기" onclick="fnSearch(1);return false;" style="margin-bottom:30px;"></a>--%>

                <!--조회하기 버튼-->
                <div class="bt-align-div">
                    <input type="button" class="mainbtn type1" value="초기화" style="width:95px; height:30px" onclick="fnInitState(); return false;"/>
                    <input type="button" class="mainbtn type1" value="조회하기" style="width:95px; height:30px" onclick="fnSearch(1); return false;"/>
                    <%--<img alt="초기화" src="../../AdminSub/Images/Member/reset-off.jpg" onclick="fnInitState(); return false;" onmouseover="this.src='../../AdminSub/Images/Member/reset-on.jpg'" onmouseout="this.src='../../AdminSub/Images/Member/reset-off.jpg'" />
                    <a>
                        <img alt="조회하기" src="../../Images/Goods/aslist.jpg" id="btnSearch" onclick="fnSearch(1); return false;" onmouseover="this.src='../../Images/Wish/aslist-over.jpg'" onmouseout="this.src='../../Images/Goods/aslist.jpg'" /></a>--%>
                </div>

            </div>

            <!--vat 포함 라벨 영역-->
            <span style="color: #69686d; float: right; margin-top: 10px; margin-bottom: 10px;">*<b style="color: #ec2029; font-weight: bold;"> VAT(부가세)포함 가격</b>입니다.</span>
            <!--하단영역-->
            <div class="list-table">
                <table id="tblSearch" class="TblSearch">
                    <thead>
                        <tr>
                            <th style="width: 40px;" rowspan="2">번호</th>
                            <th style="width: 120px;">주문일자</th>
                            <th style="width: 120px;" rowspan="2">구매사</th>
                            <th style="width: 351px;" rowspan="2">주문상품정보</th>
                            <th style="width: 90px;" rowspan="2">모델명</th>
                            <th style="width: 105px;">최소수량 / 내용량</th>
                            <th style="width: 90px;">상품가격<br />
                                (VAT포함)</th>
                            <th style="width: 92px;">출고예정일</th>
                            <th style="width: 80px;" rowspan="2">주문처리현황</th>
                            <th style="width: 80px;" rowspan="2">결제수단</th>
                        </tr>
                        <tr>
                            <th>주문번호</th>
                            <th>주문수량</th>
                            <th>주문금액<br />
                                (VAT포함)</th>
                            <th>배송완료일</th>
                        </tr>
                    </thead>
                    <tbody>
                    </tbody>
                </table>



                <!--엑셀저장버튼-->
                <div class="bt-align-div">
                    <asp:ImageButton ID="btnOrdHistoryExcel" runat="server" Visible="false" AlternateText="엑셀저장" ImageUrl="../../Images/Order/detail-excel.jpg" onmouseover="this.src='../../Images/Order/detail-excel-on.jpg'" onmouseout="this.src='../../Images/Order/detail-excel.jpg'" OnClick="btnOrdHistoryExcel_Click" />
                </div>
            </div>


            <input type="hidden" id="hdTotalCount" />

            <!-- 페이징 처리 -->
            <div style="margin: 0 auto; text-align: center">
                <div id="pagination" class="page_curl" style="display: inline-block"></div>
            </div>

            <div id="productDiv" class="popupdiv divpopup-layer-package">

                <div class="popupdivWrapper" style="width: 1050px; height: 710px">
                    <div class="popupdivContents" style="border: none;">

                        <div class="popup-title" style="margin-top: 20px;">
                            <h3 class="pop-title">주문상품</h3>
                        </div>

                        <%--<div class="mini-title">
                            <img src="../Images/Order/subOrder.jpg" alt="주문내역" /></div>--%>
                        <div style="text-align: right;">주문금액:<label id="lbPrice"></label>원</div>

                        <div class="tblOrder-div" style="height: 270px; width: 100%; overflow-y: auto; overflow-x: hidden;">
                            <input type="hidden" id="hdPopupGoodsCode" />

                            <table id="tblOrder">
                                <thead>
                                    <tr>
                                        <th style="width: 80px;" rowspan="2">구매사</th>
                                        <th style="width: 270px;" rowspan="2">주문상품정보</th>
                                        <th style="width: 60px;" rowspan="2">모델명</th>
                                        <th style="width: 105px;">최소수량 / 내용량</th>
                                        <th style="width: 70px;">상품가격<br />
                                            (VAT포함)</th>
                                        <th style="width: 70px;">출고예정일</th>

                                        <th style="width: 60px;" rowspan="2">주문처리현황</th>
                                        <th style="width: 60px;" rowspan="2">결제수단</th>
                                    </tr>
                                    <tr>
                                        <th>주문수량</th>
                                        <th>주문금액<br />
                                            (VAT포함)</th>
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

                        <div style="float: right;">
                            <input type="button" class="mainbtn type1" value="확인" style="width:95px; height:30px" onclick="fnCancel('divPopup');"/>
                        </div>

                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>

