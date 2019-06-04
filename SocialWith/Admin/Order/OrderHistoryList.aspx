<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Master/AdminMasterPage.master" AutoEventWireup="true" CodeFile="OrderHistoryList.aspx.cs" Inherits="Admin_Order_OrderHistoryList" %>

<%@ Import Namespace="Urian.Core" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <link href="../Content/Order/order.css" rel="stylesheet" />
    <script src="../../Scripts/jquery.inputmask.bundle.js"></script>
    <script>
        var qs = fnGetQueryStrings();
        var ordstatus = qs["ordstatus"];
        is_sending = false;

        $(document).ready(function () {

            $('.ui-datepicker').css('z-index', 99999999999999);
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
                buttonImage:/* "/Images/icon_calandar.png
                ."*/"../../Images/Goods/calendar.jpg",
                buttonImageOnly: true,
                dateFormat: "yy-mm-dd",
                monthNamesShort: ["1월", "2월", "3월", "4월", "5월", "6월", "7월", "8월", "9월", "10월", "11월", "12월"],
                dayNamesMin: ["일", "월", "화", "수", "목", "금", "토"],
                showMonthAfterYear: true
            });



            $('#tblHistoryList input[type="checkbox"]').change(function () {
                var num = $(this).val();
                var isDateChk = false;
                if ($(this).prop('checked') == true) {
                    if (num == '0') {
                        alert('조회기간을 입력해주세요')
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
                    isDateChk = true;
                }

                if (!isDateChk) {
                    $("input:checkbox[id='ckbSearch" + num + "']").prop("checked", true);

                    return false;
                }

            });

            if (!isEmpty(ordstatus)) {
                $('#<%=ddlOrderStatus.ClientID %>').val(ordstatus);
                 var d = new Date()
                 var dayOfMonth = d.getDate()
                 d.setDate(dayOfMonth - 30)
                 $('#<%= txtSearchSdate.ClientID%>').val(d.format("yyyy-MM-dd"));
                 $('#<%= txtSearchEdate.ClientID%>').val(new Date().format("yyyy-MM-dd"));
                $('#ckbSearch30').prop('checked', 'checked');
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



        //초기화
        function fnInitState() {
            alert('검색조건을 초기화 합니다.');
            window.location.reload(true);
        }

        //tr 마우스오버시
        function setTableHover() {
            $("#tblSearch tbody tr:even").each(function (index, element) {
                $(element).find(".rowColor_td").mouseover(function () {
                    //$(element).find(".rowColor_td").not(':eq(1), :eq(2),:eq(7), :eq(9)').css("background-color", "#dcdcdc");
                    //$("#tblSearch tbody tr:eq(" + (element.rowIndex + index + 1) + ")").find(".rowColor_td").not(':eq(0),:eq(1)').css("background-color", "#dcdcdc");
                    $(element).find(".rowColor_td").not(':eq(7), :eq(9)').css("background-color", "#dcdcdc");
                    $("#tblSearch tbody tr:eq(" + (element.rowIndex + index + 1) + ")").find(".rowColor_td").css("background-color", "#dcdcdc");

                    $(element).find(".rowColor_td").css("cursor", "pointer");
                    $("#tblSearch tbody tr:eq(" + (element.rowIndex + index + 1) + ")").find(".rowColor_td").css("cursor", "pointer");
                });
                $(element).find(".rowColor_td").mouseout(function () {
                    //$(element).find(".rowColor_td").not(':eq(1), :eq(2),:eq(7), :eq(9)').css("background-color", "");
                    //$("#tblSearch tbody tr:eq(" + (element.rowIndex + index + 1) + ")").find(".rowColor_td").not(':eq(0),:eq(1)').css("background-color", "");
                    $(element).find(".rowColor_td").not(':eq(7), :eq(9)').css("background-color", "");
                    $("#tblSearch tbody tr:eq(" + (element.rowIndex + index + 1) + ")").find(".rowColor_td").css("background-color", "");
                });
            });

            $("#tblSearch tbody tr:odd").each(function (index, element) {
                $(element).find(".rowColor_td").mouseover(function () {
                    //$(element).find(".rowColor_td").not(':eq(0),:eq(1)').css("background-color", "#dcdcdc");
                    //$("#tblSearch tbody tr:eq(" + (element.rowIndex + index - 4) + ")").find(".rowColor_td").not(':eq(1), :eq(2),:eq(7), :eq(9)').css("background-color", "#dcdcdc");
                    $(element).find(".rowColor_td").css("background-color", "#dcdcdc");
                    $("#tblSearch tbody tr:eq(" + (element.rowIndex + index - 4) + ")").find(".rowColor_td").not(':eq(7), :eq(9)').css("background-color", "#dcdcdc");

                    $(element).find(".rowColor_td").css("cursor", "pointer");
                    $("#tblSearch tbody tr:eq(" + (element.rowIndex + index - 4) + ")").find(".rowColor_td").css("cursor", "pointer");
                });
                $(element).find(".rowColor_td").mouseout(function () {
                    //$(element).find(".rowColor_td").not(':eq(0),:eq(1)').css("background-color", "");
                    //$("#tblSearch tbody tr:eq(" + (element.rowIndex + index - 4) + ")").find(".rowColor_td").not(':eq(1), :eq(2),:eq(7), :eq(9)').css("background-color", "");
                    $(element).find(".rowColor_td").css("background-color", "");
                    $("#tblSearch tbody tr:eq(" + (element.rowIndex + index - 4) + ")").find(".rowColor_td").not(':eq(7), :eq(9)').css("background-color", "");
                });
            });
        }

        // 주문상세 팝업 화면 로딩 시 데이터 설정
        function fnSetDetailPopupDataBind(response) {

            $('#btnCardSpecification').css('display', 'none');
            $('#btnCancelCardSpec').css('display', 'none');

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

            //주문상태 변경 selectbox option 생성
            var ordStat = $("#hdPopupOrderStatus").val();
            var ordStatCodes = '<%=OrdStatCodes %>';
            ordStatCodes = JSON.parse(ordStatCodes);
            var tag_ordStat = '';
            var selectFlag = '';

            if (!isEmpty(ordStatCodes)) {
                $.each(ordStatCodes, function (key, value) {
                    var mapType = value.Map_Type;
                    if (!isEmpty(mapType)) mapType = parseInt(mapType);
                    if (!isEmpty(ordStat)) ordStat = parseInt(ordStat);

                    if (mapType == ordStat) {

                        selectFlag = "selected='selected'";
                    } else {
                        selectFlag = '';
                    }

                    tag_ordStat += "<option value='" + value.Map_Type + "' " + selectFlag + ">" + value.Map_Name + "</option>";
                });
            }

            $("#tbody_pop_odrDtl").html("");
            $("#tbl_dtlPop_pay").html("");

            var selectGdsCode = $("#hdPopupGoodsCode").val(); //선택한 행의 상품코드
            for (i in ordGdsList) {
                if (selectGdsCode == ordGdsList[i].GoodsCode) {
                    $("#hdPopupDlvrNo").val(ordGdsList[i].DeliveryNo);
                }
            }

            var defaultTag = "<tr style='height:35px'><th colspan='2' style='width:30%'> 결제금액</th> <th colspan='2'>상품 처리</th></tr>"
                + "<tr><th style='width:13%'>결제방식</th>"
                + "<td style='width:19%' id='tdDtl_payway'></td>"
                + "<th style='width:14%'>주문처리</th>"
                + "<td>"
                + "<span id='spDlvrGubunChg' style='display: none; margin-right:5px'><input type='button' id='btnDlvrGubunChg' class='btnDelete' style='width:71px; height:22px; font-size:12px;' value='직송변경' onclick='fnDlvrGubunChg(); return false;' /></span>"
                + "<span id='spDlvrGubunChgCD' style='display: none; margin-right:5px'><input type='button' id='btnDlvrGubunChgCD' class='btnDelete' style='width:71px; height:22px; font-size:12px;' value='CD변경' onclick='fnDlvrGubunChgCD(); return false;' /></span>"
                + "<span id='spOrdStatReset' style='display: none; margin-right:5px'><input type='button' id='btnOrdStatReset' class='btnDelete' style='width:100px; height:22px;font - size: 12px;' value='주문처리초기화' onclick='fnOrdStatReset(); return false;' /></span>"
                + "<span id='spOrdCardAllCancel' style='display: none; margin-right:5px'><input type='button' id='btnOrdCardAllCancel' class='btnDelete' style='width:100px; height:22px;font - size: 12px;' value='카드전체취소' onclick='fnOrdCardAllCancel(\"" + ordGdsList[0].OrderCodeNo + "\",\"" + ordGdsList[0].Svid_User + "\"); return false;' /></span>"
                + "</td></tr>"

                + "<tr><th id='th_dtl_totSalePrice'>총 구매금액</th>"
                + "<td id='tdDtl_totSalePrice'></td><th>주문상태 변경</th>"
                + "<td>"
                + "<span id='spOrderStat'>"
                + "<select id='sltOrdStat' style='width:100px; height: 26px; border-radius: 3px; margin-right:20px'>"
                + tag_ordStat
                + "</select>"
                + "<input type='button' class='btnDelete' id='btnSelectOrdStatChg' style='width: 125px;' value='(선택)주문상태변경' onclick='fnChangeOrderStatus(\"One\",\"" + ordGdsList[0].Svid_User + "\"); return false;' />&nbsp;&nbsp;&nbsp;&nbsp;<input type='button' class='btnDelete' id='btnPoOrdStatChg' style='width: 125px; ' value='(PO)주문상태변경' onclick='fnChangeOrderStatus(\"All\",\"" + ordGdsList[0].Svid_User + "\"); return false;' />"
                + "</span>"
                + "</td></tr>"
                + "<tr><th>배송비</th>"
                + "<td id='tdDtl_dlvrCost'></td><th>운송장번호 입력</th>"
                + "<td>"
                + "<span id='spDlvrNo'>"
                + "<input type='text'id='txtDlvrNo' name='txtDlvrNo' style='width:150px; margin-right:10px' placeholder=' 운송장번호 입력' value='" + $("#hdPopupDlvrNo").val() + "' /><input type='button' class='btnDelete' id='btnSelectInputDlvrNo' style='width: 145px;' value='(선택)운송장번호 저장' onclick='fnSaveDeleveryNo(\"One\",\"" + ordGdsList[0].Svid_User + "\"); return false;' />&nbsp;&nbsp;&nbsp;&nbsp;<input type='button' id='btnPoDlvrNo' class='btnDelete' style='width: 145px;' value='(PO)운송장번호 저장' onclick='fnSaveDeleveryNo(\"All\",\"" + ordGdsList[0].Svid_User + "\"); return false;' />"
                + "</span>"
                + "</td></tr>"

                + "<tr><th>특수 배송비</th>"
                + "<td id='tdDtl_powerDlvrCost'></td><th>배송 관련</th><td><input type='text' id='deliDate' name='deliDate' style='width:90px; margin-right:20px' placeholder=' 날짜 입력란' /><input type='button' class='btnDelete' id='btnSelDeliSuccess' style='width: 125px;' value='(선택)배송완료' onclick='fnDeliPut(1); return false;' />&nbsp;&nbsp;&nbsp;&nbsp;<input type='button' class='btnDelete' id='btnPoDeliSuccess' style='width: 125px;' value='(PO)배송 완료' onclick='fnDeliPut(2); return false;' /></td></tr>"
                + "<tr><th id='th_dtl_payPrice'>결제금액</th>"
                + "<td id='tdDtl_payPrice'></td><th>입고 관련</th><td><input type='text'id='PutDate' name='PutDate' style='width:90px; margin-right:20px' placeholder=' 날짜 입력란' /><input type='button' class='btnDelete' id='btnSelPutChk' style='width: 125px;' value='(선택)입고 확인' onclick='fnDeliPut(3); return false;' />&nbsp;&nbsp;&nbsp;&nbsp;<input type='button' id='btnPoPutChk' class='btnDelete' style='width: 125px;' value='(PO)입고 확인' onclick='fnDeliPut(4); return false;' /></td></tr>"

                + "<tr><th></th>"
                + "<td></td><th>플랫폼이용 수수료</th><td><input type='text' id='txtPlatformFee' placeholder='수수료 입력' style='width:100px;' onkeypress='return onlyNumbers(event);' />&nbsp;<span style='width:20px; margin-right:20px'>원</span>"
                + "<input type='button' class='btnDelete' id='btnSelectPlatformFee' style='width: 120px;' value='(선택)수수료 적용' onclick='fnSavePlatformFee(1); return false;' />&nbsp;&nbsp;&nbsp;&nbsp;<input type='button' class='btnDelete' id='btnPoPlatformFee' style='width: 120px;' value='(PO)수수료 적용' onclick='fnSavePlatformFee(2)); return false;' /></td></tr>"
                + "<tr><th></th>"

                + "<td></td><th>출력</th><td><span id='spCardSpecification' style='display: none; margin-right:5px'><input type='button' id='btnCardSpecification' style='width: 95px; height: 25px; font-size: 12px;' class='btnDelete' value='카드명세표' onclick='fnPortFolio(); return false;' /></span><span id='spCancelCardSpec' style='display: none; margin-right:5px'><input type='button' id='btnCancelCardSpec' class='btnDelete' style='width: 115px; height: 25px; font-size: 12px;' value='(취소)카드명세표' onclick='fnCancelPortFolio(); return false;' /></span>"
                + "<span id='spPrintOrderList' style='margin-right:5px'><input type='button' id='btnPrintOrderList' style='width: 95px;' class='btnDelete' value='거래명세서' onclick='fnPrintOrderList(\"" + ordGdsList[0].Svid_User + "\"); return false;' /></span>"
                + "</td></tr>"
                + "<tr><th></th><td></td>"
                + "<th id='th_dtl_bill'>세금계산서</th>"
                + "<td id='tdDtl_bill'>"
                + "<span id='spBillReq' style='margin-right:13px'><input type='text' id='txtBillDate' name='txtBillDate' style='width:90px; margin-right:20px' placeholder=' 날짜 입력란' /><input type='button' id='btnBillReq' class='btnDelete' style='width:135px;' value='(PO)세금계산서 요청' onclick='return fnUpdateBillDate(\"REQ\");' /></span>"
                + "<span id='spBillStop' style='margin-right:5px'><input type='button' id='btnBillStop' class='btnDelete' style='width:135px;' value='(PO)세금계산서 중지' onclick='return fnUpdateBillDate(\"STOP\");' /></span>"
                + "</td>"

                + "</tr>";


            $("#tbl_dtlPop_pay").append(defaultTag);

            RealTimeComma("txtPlatformFee");

            $("#deliDate").datepicker({
                //minDate: 0,                  //최소 선택 가능 일자 오늘 부터.
                maxDate: "60D",              //최대 선택 가능 일자 오늘부터 +30일
                showAnimation: 'slideDown',
                changeMonth: true,
                changeYear: true,
                dateFormat: "yy-mm-dd",
                monthNamesShort: ["1월", "2월", "3월", "4월", "5월", "6월", "7월", "8월", "9월", "10월", "11월", "12월"],
                dayNamesMin: ["일", "월", "화", "수", "목", "금", "토"],
                showMonthAfterYear: true
            });

            $("#PutDate").datepicker({
                //minDate: 0,                //최소 선택 가능 일자 오늘 부터. 
                maxDate: "60D",              //최대 선택 가능 일자 오늘부터 +30일 
                showAnimation: 'slideDown',
                changeMonth: true,
                changeYear: true,
                dateFormat: "yy-mm-dd",
                monthNamesShort: ["1월", "2월", "3월", "4월", "5월", "6월", "7월", "8월", "9월", "10월", "11월", "12월"],
                dayNamesMin: ["일", "월", "화", "수", "목", "금", "토"],
                showMonthAfterYear: true
            });

            $("#txtBillDate").datepicker({
                //minDate: 0,                //최소 선택 가능 일자 오늘 부터. 
                maxDate: "60D",              //최대 선택 가능 일자 오늘부터 +30일 
                showAnimation: 'slideDown',
                changeMonth: true,
                changeYear: true,
                dateFormat: "yy-mm-dd",
                monthNamesShort: ["1월", "2월", "3월", "4월", "5월", "6월", "7월", "8월", "9월", "10월", "11월", "12월"],
                dayNamesMin: ["일", "월", "화", "수", "목", "금", "토"],
                showMonthAfterYear: true
            });

            //주문상태 변경 시
            $("#sltOrdStat").change(function () {
                var prevOrdStat = $("#hdPopupOrderStatus").val();
                var selectOrdStat = this.value;
                if (!isEmpty(prevOrdStat)) prevOrdStat = parseInt(prevOrdStat);
                if (!isEmpty(selectOrdStat)) selectOrdStat = parseInt(selectOrdStat);

                if (selectOrdStat < prevOrdStat) {
                    $("#btnPoOrdStatChg").css("display", "none");

                } else {
                    $("#btnPoOrdStatChg").css("display", "inline-block");
                }
            });

            var ordStat = fnSetOrderGoodsList(ordGdsList);
            var result = fnSetPayInfo(payInfo, ordStat);

            if (result) {
                var numOrdStat = parseInt($('#hdPopupOrderStatus').val());

                if (numOrdStat > 300) {
                    $("#spOrderStat").css("display", "none");

                    if (numOrdStat == 302) {
                        $("#spDlvrNo").css("display", "none");
                    }
                }

                if ((numOrdStat >= 100) && (numOrdStat <= 302) && $('#hdPopupPayway').val() == '1') {
                    $('#spCardSpecification').css('display', '');
                }

                if ((numOrdStat == 422) && $('#hdPopupPayway').val() == '1') {
                    $('#spCancelCardSpec').css('display', '');
                }

                if (numOrdStat >= 400) {
                    $("#spPrintOrderList").css("display", "none");
                }

                var popDiv = document.getElementById('productDiv');
                if (popDiv.style.display != "block") {
                    fnOpenDivLayerPopup('productDiv');
                }
            }
        }


        // 주문상세 팝업 - 주문상품 목록 설정
        function fnSetOrderGoodsList(list) {

            var ordStat = 0;

            var ordCodeNo = '';
            var userName = '';
            var zipCode = '';
            var addr1 = ''
            var addr2 = '';
            var telNo = '';
            var payway = '';

            var selectGdsCode = $("#hdPopupGoodsCode").val(); //선택한 행의 상품코드

            for (i in list) {
                // 상태값을 처음에 한 번만 저장
                if (i == 0) {
                    ordStat = list[i].OrderStatus;
                    ordCodeNo = list[i].OrderCodeNo;
                    userName = list[i].Name;
                    zipCode = list[i].ZipCode;
                    addr1 = list[i].Address_1;
                    addr2 = list[i].Address_2;
                    telNo = list[i].TelNo;
                    payway = list[i].PayWay;
                }


                var gdsFinalCtgrCode = list[i].GoodsFinalCategoryCode;
                var gdsGrpCode = list[i].GoodsGroupCode;
                var gdsCode = list[i].GoodsCode;
                var gdsName = list[i].GoodsFinalName;
                var dlvrGubun = list[i].DeliveryGubun; //배송구분
                $("#hdGoodsCode").val(gdsCode);
                var trColor = ''; //tr색

                if (selectGdsCode == gdsCode) {
                    trColor = "style='background-color: #FAF4C0;'";

                    //$("#btnDlvrGubunChg").css("display", 'none'); //직송변경 버튼
                    //$("#btnDlvrGubunChgCD").css("display", 'none'); //CD변경 버튼
                    //$("#btnOrdStatReset").css("display", 'none'); //주문처리초기화 버튼
                    $("#spDlvrGubunChg").css("display", 'none'); //직송변경 버튼
                    $("#spDlvrGubunChgCD").css("display", 'none'); //CD변경 버튼
                    $("#spOrdStatReset").css("display", 'none'); //주문처리초기화 버튼

                    if ((dlvrGubun != "2") && (dlvrGubun != "4") && (ordStat == "200")) {
                        //$("#btnOrdStatReset").css("display", 'none');
                        //$("#btnDlvrGubunChg").css("display", ''); //직송변경 버튼
                        $("#spOrdStatReset").css("display", 'none');
                        $("#spDlvrGubunChg").css("display", ''); //직송변경 버튼
                    }

                    if (((dlvrGubun == "2") || (dlvrGubun == "4")) && (ordStat == "200")) {
                        //$("#btnOrdStatReset").css("display", 'none');
                        //$("#btnDlvrGubunChgCD").css("display", ''); //CD변경 버튼
                        $("#spOrdStatReset").css("display", 'none');
                        $("#spDlvrGubunChgCD").css("display", ''); //CD변경 버튼
                    }

                    if (((dlvrGubun == "2") || (dlvrGubun == "4")) && (ordStat == "302")) {
                        //$("#btnDlvrGubunChg").css("display", 'none');
                        //$("#btnOrdStatReset").css("display", ''); //주문처리초기화 버튼
                        $("#spDlvrGubunChg").css("display", 'none');
                        $("#spOrdStatReset").css("display", ''); //주문처리초기화 버튼
                    }

                    if (((payway == "1") || (payway == "5")) && (parseInt(ordStat) < 400) && (parseInt(ordStat) != 102)) {
                        $("#spOrdCardAllCancel").css("display", '');
                    } else {
                        $("#spOrdCardAllCancel").css("display", "none");
                    }

                }


                var src = "/GoodsImage" + "/" + gdsFinalCtgrCode + "/" + gdsGrpCode + "/" + gdsCode + "/" + gdsFinalCtgrCode + "-" + gdsGrpCode + "-" + gdsCode + '-sss.jpg';
                //$("#lbPrice").text(numberWithCommas(list[i].GoodsTotalSalePriceVAT));
                var addRow = "<tr " + trColor + ">";
                addRow += "<td rowspan='2'>" + list[i].OrderSaleCompanyName + "</td>"
                addRow += "<td style= 'text-align:left; padding-left:5px;' rowspan='2'>"
                    + "<table style='width:100%;' id='tblGoodsInfo_pop'><tr><td rowspan='2' style='width:70px;'><img  style='width:50px; height:50px' onerror= 'no_image(this, \"s\")' src= '" + src + "' alt= '" + gdsName + "' title= '" + gdsName + "'/></td><td style='text-align:left; width:280px'>" + list[i].GoodsCode + "</td></tr><tr><td style='text-align:left; width:280px'>" + "[" + list[i].BrandName + "] " + list[i].GoodsFinalName + "<br /><span style='color:#368AFF'>" + list[i].GoodsOptionSummaryValues + "</span></td></tr></table>"
                    + "<input type='hidden' name='hd_dtl_OdrCodeNo' value='" + list[i].OrderCodeNo + "' />"
                    + "</td>"
                addRow += "<td style='text-align: center' rowspan='2'>" + list[i].GoodsModel + "</td>"
                addRow += "<td style='text-align: center'>" + list[i].GoodsUnitMoq + " / " + list[i].GoodsUnit_Name + "</td>"
                addRow += "<td rowspan='2' id='tdDtlSalePrice' style='text-align:right; padding-right:5px;'>" + numberWithCommas(list[i].GoodsTotalSalePriceVAT) + "원</td>"
                addRow += "<td>" + list[i].GoodsDeliveryOrderDue_Name + "</td>"
                addRow += "<td rowspan='2'>"
                    + "<input type='hidden' name='hdPopupDlvrGubun' value='" + dlvrGubun + "' />"
                    + "<input type='hidden' name='hdPopupOrdSaleComCode' value='" + list[i].OrderSaleCompanyCode + "' />"
                    + list[i].OrderStatus_NAME + "</td>"
                addRow += "<td rowspan='2'>" + list[i].PayWayName + "</td></tr>"
                //-----------------------------------------------------------------다음행-----------------------------------------------------------------------------------------------------------//
                addRow += "<tr " + trColor + "><td id= 'tdDtlUnit' > " + list[i].Qty + "</td >";
                addRow += "<td>" + fnOracleDateFormatConverter(list[i].DeliveryDate) + "</td></tr>";

                $("#tbody_pop_odrDtl").append(addRow);
            }

            $("#lbl_pop_ordCodeNo").text(ordCodeNo);
            $("#td_pop_userInfo").text(userName + ", " + telNo);
            $("#td_pop_addr").text("(" + zipCode + ") " + addr1 + " " + addr2);

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
            $("#lbPrice").text(numberWithCommas(info.Total_GoodsSalePriceVat));
            $('#hdPopupTid').val(info.Pg_Tid);
            //$("#th_dtl_date").text(info.VbankNo);

            //세금계산서 관련 정보
            var billSelectDate = fnOracleDateFormatConverter(info.BillSelectDate);
            var billTransCnt = info.BillTransCnt;
            $('#hdPopupBillSelectDate').val(billSelectDate);
            $('#hdPopupBillEmail').val(info.BillEmail);
            $('#hdPopupBillCheck').val(info.BillCheck);
            $('#hdPopupBillTransCnt').val(billTransCnt);

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

                //$("#tbl_dtlPop_pay").append(addTag);

                //세금계산서 발행
                if (!isEmpty(billTransCnt) && (parseInt(billTransCnt) > 0)) {
                    $("#spBillReq").css("display", "none");
                    $("#spBillStop").css("display", "none");

                } else { //세금계산서 미발행
                    if (!isEmpty(billSelectDate)) {
                        if (billSelectDate == "9999-01-01") {
                            $("#spBillStop").css("display", "none");
                        } else {
                            $("#spBillStop").css("display", "");
                            $("#txtBillDate").val(billSelectDate);
                        }

                        $("#spBillReq").css("display", "");
                    }
                }
            }

            return true;
        }

        // 주문상세 팝업
        function fnOdrDtlPopup(el) {
            $("#hdPopupUorderNo").val($(el).find("input:hidden[name='hdUorderNo']").val());
            $("#hdPopupOrdCodeNo").val($(el).find("input:hidden[name='hdOrderCodeNo']").val());
            $("#hdPopupGoodsFinCtgrCode").val($(el).find("input:hidden[name='hdGdsFinCtgrCode']").val());
            $("#hdPopupGoodsGrpCode").val($(el).find("input:hidden[name='hdGdsGrpCode']").val());
            $("#hdPopupGoodsCode").val($(el).find("input:hidden[name='hdGdsCode']").val());

            var sUser = '<%= Svid_User %>';
            var odrCodeNo = $(el).find("input:hidden[name='hdOrderCodeNo']").val();
            var odrStat = $(el).find("input:hidden[name='hdOrdStat']").val();
            var payway = $(el).find("input:hidden[name='hdPayWay']").val();
            var saleCompCode = $(el).find("input:hidden[name='hdSaleCompCode']").val();

            $('#hdPopupCompCode').val(saleCompCode);
            $('#hdPopupOrderStatus').val(odrStat);
            $('#hdPopupPayway').val(payway);

            var callback = function (response) {
                if (!isEmpty(response)) {

                    fnSetDetailPopupDataBind(response);

                } else {
                    alert("오류가 발생했습니다. 잠시 후 다시 시도해 주세요.");
                }

                return false;
            };

            var uNumOrdNo = $(el).find("input:hidden[name='hdUorderNo']").val();
            var param = { OdrCodeNo: odrCodeNo, OdrStat: odrStat, UNumOrdNo: uNumOrdNo, Method: "OrderDtlInfoAllUser" };

            var beforeSend = function () {
                is_sending = true;
            }
            var complete = function () {
                is_sending = false;
            }
            if (is_sending) return false;

            JqueryAjax("Post", "../../Handler/OrderHandler.ashx", false, false, param, "json", callback, beforeSend, complete, true, '<%=Svid_User %>');
        }

        // 취소 버튼 클릭 시 팝업 닫기
        function fnCancel() {
            $('.divpopup-layer-package').fadeOut();
        }

        function fnSelectOrderSearch() {
            fnCancel();

            var ordCodeNo = $("#lbl_pop_ordCodeNo").text();
            $('#<%= txtOrderNo.ClientID%>').val(ordCodeNo);

            fnSearch(1);
        }

        //조회하기
        function fnSearch(pageNum) {
            var startDate = $('#<%= txtSearchSdate.ClientID%>').val();
            var endDate = $('#<%= txtSearchEdate.ClientID%>').val();
            var odrStat = $('#<%=ddlOrderStatus.ClientID %>').val();
            var payway = $('#<%=ddlPayWay.ClientID %>').val();
            var orderCodeNo = $('#<%= txtOrderNo.ClientID%>').val();
            var brand = $('#<%= txtBrand.ClientID%>').val();
            var goodsName = $('#<%= txtGoodsName.ClientID%>').val();
            var goodsCode = $('#<%= txtGoodsCode.ClientID%>').val();
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

                        } else {
                            if (value.OrderStatus == "301") {
                                dlvrDate = value.DeliveryCompany;
                                dlvrDate += "<br/>(" + value.DeliveryNo + ")";
                            }
                        }
                        var src = '/GoodsImage' + '/' + value.GoodsFinalCategoryCode + '/' + value.GoodsGroupCode + '/' + value.GoodsCode + '/' + value.GoodsFinalCategoryCode + '-' + value.GoodsGroupCode + '-' + value.GoodsCode + '-sss.jpg';

                        var cellColor = '';
                        if (value.OrderStatus == '302') { //배송완료 blue
                            cellColor = '#E8FFFF';
                        }
                        else if (value.OrderStatus > '302' || value.OrderStatus == '101') { //주문완료입금전 혹은 302보다 크면 white
                            cellColor = '#FFFFFF';
                        }
                        else {//그밖은 다 pink
                            cellColor = '#FFE6E6';
                        }
                        $("#hdTotalCount").val(value.TotalCount);
                        asynTable += "<tr onClick='fnOdrDtlPopup(this); return false;'><input type='hidden' name='hdUorderNo' value='" + value.Unum_OrderNo + "' />"
                            + "<input type='hidden' name='hdOrderCodeNo' value='" + value.OrderCodeNo + "' />"
                            + "<input type='hidden' name='hdPayWay' value='" + value.PayWay + "' />"
                            + "<input type='hidden' name='hdOrdStat' value='" + value.OrderStatus + "' />"
                            + "<input type='hidden' name='hdGdsFinCtgrCode' value='" + value.GoodsFinalCategoryCode + "' />"
                            + "<input type='hidden' name='hdGdsGrpCode' value='" + value.GoodsGroupCode + "' />"
                            + "<input type='hidden' name='hdGdsCode' value='" + value.GoodsCode + "' />"
                            + "<input type='hidden' name='hdSaleCompCode' value='" + value.SaleCompany_Code + "' />";
                        asynTable += "<td rowspan='2' style='text-align:center' class='rowColor_td'>" + value.RowNumber + "</td>";
                        asynTable += "<td " + cellColor + "' class='rowColor_td text-center'>" + value.EntryDate.split("T")[0] + "</td>";
                        asynTable += "<td " + cellColor + "' class='rowColor_td text-center'>" + value.OrderSaleCompanyName + "</td>";
                        asynTable += "<td rowspan='2' style='text-align:center;' class='rowColor_td'>" + value.SaleCompany_Name + "</td>";
                        var certImgDisplay = 'display:none';
                        if (!isEmpty(value.GoodsConfirmMark) && value.GoodsConfirmMark != '00000000') {
                            certImgDisplay = ''
                        }

                        asynTable += "<td style= 'text-align:center; padding-left:5px;' rowspan='2' class='rowColor_td'><table style='width:100%;' id='tblGoodsInfo'><tr><td rowspan='2' style='width:70px;'><span class='spanCert' id='spanCert" + value.GoodsConfirmMark + "'  other-title='' style='" + certImgDisplay + "'>*인증상품</span><img src=" + src + " onerror='no_image(this, \"s\")' style='width:50px; height=50px'/></td><td style='text-align:left;'>" + value.GoodsCode + "&nbsp;&nbsp;&nbsp;&nbsp;" + value.SupInfo + "</td></tr><tr><td style='text-align:left;'>" + "[" + value.BrandName + "] " + value.GoodsFinalName + "<br/><span style='color:#368AFF; word-wrap:break-word; display:block; width:280px'>" + value.GoodsOptionSummaryValues + "</span></td></tr></table></td>";
                        asynTable += "<td class='rowColor_td' rowspan='2' style='text-align:center;'> " + value.GoodsModel + "</td >";
                        asynTable += "<td class='rowColor_td' style='padding-right:5px; text-align:center;'> " + value.GoodsUnitMoq + " / " + value.GoodsUnit + "</td >";

                        var deliveryYn = value.DeliveryYN;
                        var deliveryHtml = '';
                        var deliveryColor = '';
                        if (deliveryYn == 'Y') {
                            deliveryHtml = '<br/>(배송비 발생)';
                            deliveryColor = 'background-color:#BFFF80';
                        }

                        var orderStatusIcon = '<img src="../../Images/Order/orderstatusicon_' + value.OrderStatus + '.png"/>'; //주문상태아이콘
                        var paywayIcon = '<img src="../../Images/Order/paywayicon_' + value.PayWay + '.png"/>'; //결제방법아이콘
                        var orderdueIcon = '<img src="../../Images/Order/orderdueicon_' + value.GoodsDeliveryOrderDue_Type + '.png"/>'; //발송일 아이콘

                        asynTable += "<td rowspan='2' class='rowColor_td' style='text-align:right; padding-right:5px" + deliveryColor + "'> " + numberWithCommas(value.GoodsTotalSalePriceVAT) + "원" + deliveryHtml + "</td >";
                        asynTable += "<td class='rowColor_td' style='text-align:center;'>" + orderdueIcon + "</td>";

                        
                        asynTable += "<td rowspan='2' style='text-align:center;" + cellColor + "' class='rowColor_td'>" + orderStatusIcon + "</td>";
                        //asynTable += "<td rowspan='2' style='border:1px solid #a2a2a2; text-align:center;" + cellColor + "' class='rowColor_td'>" + value.OrderStatus_NAME + "</td>";
                        //asynTable += "<td rowspan='2' style='text-align:center;' class='rowColor_td'>" + value.PayWayName + "</td></tr>";
                        asynTable += "<td rowspan='2' style='text-align:center;' class='rowColor_td'>" + paywayIcon + "</td></tr>";

                        //-----------------------------------------------------------------다음행-----------------------------------------------------------------------------------------------------------//
                        asynTable += "<tr class='trOrder' onClick='fnOdrDtlPopup(this); return false;'><input type='hidden' name='hdUorderNo' value='" + value.Unum_OrderNo + "' />"
                            + "<input type='hidden' name='hdOrderCodeNo' value='" + value.OrderCodeNo + "' />"
                            + "<input type='hidden' name='hdPayWay' value='" + value.PayWay + "' />"
                            + "<input type='hidden' name='hdOrdStat' value='" + value.OrderStatus + "' />"
                            + "<input type='hidden' name='hdGdsFinCtgrCode' value='" + value.GoodsFinalCategoryCode + "' />"
                            + "<input type='hidden' name='hdGdsGrpCode' value='" + value.GoodsGroupCode + "' />"
                            + "<input type='hidden' name='hdGdsCode' value='" + value.GoodsCode + "' />"
                            + "<input type='hidden' name='hdSaleCompCode' value='" + value.SaleCompany_Code + "' />";
                        asynTable += "<td class='rowColor_td' style='text-align:center'>" + value.OrderCodeNo + "</td>";
                        asynTable += "<td class='rowColor_td text-center'><strong>" + value.Name + "</strong><br/>-" + value.Id + "-</td>";
                        asynTable += "<td class='rowColor_td' style='padding-right:5px; text-align:right'>" + value.Qty + "</td>";
                        asynTable += "<td class='rowColor_td'>" + dlvrDate + "</td></tr>";
                        i++;

                    });

                } else {
                    asynTable += "<tr><td colspan='11' class='txt-center'>" + "조회된 주문내역이 없습니다." + "</td></tr>"
                    $("#hdTotalCount").val(0);
                }
                $("#tblSearch tbody").append(asynTable);
                setTableHover();
                SetCertifyImageSet();
                fnCreatePagination('pagination', $("#hdTotalCount").val(), pageNum, 20, getPageData);
            }
            var sUser = '<%= Svid_User%>';

            var param = { Method: 'OrderHistory_Admin', SvidUser: sUser, OrderStatus: odrStat, PayWay: payway, TodateB: startDate, TodateE: endDate, OrderCodeNo: orderCodeNo, Brand: brand, GoodsFinalName: goodsName, GoodsCode: goodsCode, SaleCompName: $('#<%= txtSaleCompName.ClientID%>').val(), BuyCompName: $('#<%= txtBuyCompName.ClientID%>').val(), PageNo: pageNum, PageSize: pageSize };
            var beforeSend = function () {
                $('#divLoading').css('display', 'block');
            }
            var complete = function () {
                $('#divLoading').css('display', 'none');
            }
            JqueryAjax("Post", "../../Handler/OrderHandler.ashx", true, false, param, "json", callback, beforeSend, complete, true, '<%=Svid_User %>');
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

        function fnEnter() {

            if (event.keyCode == 13) {
                fnSearch(1);
                return false;
            }
            else
                return true;
        }

        function fnPortFolio() {

            var status = "toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,width=420,height=540"
            var url = "https://pg.nicepay.co.kr/issue/IssueLoader.jsp?TID=" + $("#hdPopupTid").val() + "&type=0";

            var width = 420;
            var height = 540;
            var dualScreenLeft = window.screenLeft != undefined ? window.screenLeft : screen.left;
            var dualScreenTop = window.screenTop != undefined ? window.screenTop : screen.top;

            var getwidth = window.innerWidth ? window.innerWidth : document.documentElement.clientWidth ? document.documentElement.clientWidth : screen.width;
            var getheight = window.innerHeight ? window.innerHeight : document.documentElement.clientHeight ? document.documentElement.clientHeight : screen.height;

            var left = ((getwidth / 2) - (width / 2)) + dualScreenLeft;
            var top = ((getheight / 2) - (height / 2)) + dualScreenTop;

            window.open(url, '', "width=" + width + ",height=" + height + ",status=no ,toolbar=no,menubar=no,location=no,resizable=yes,scrollbars=yes,left=" + left + ", top=" + top + "");
        }

        //(취소)카드명세표 팝업
        function fnCancelPortFolio() {

            var status = "toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,width=420,height=540"
            var url = "https://pg.nicepay.co.kr/issue/IssueLoader.jsp?TID=" + $("#hdPopupTid").val() + "&type=0";

            var width = 420;
            var height = 540;
            var dualScreenLeft = window.screenLeft != undefined ? window.screenLeft : screen.left;
            var dualScreenTop = window.screenTop != undefined ? window.screenTop : screen.top;

            var getwidth = window.innerWidth ? window.innerWidth : document.documentElement.clientWidth ? document.documentElement.clientWidth : screen.width;
            var getheight = window.innerHeight ? window.innerHeight : document.documentElement.clientHeight ? document.documentElement.clientHeight : screen.height;

            var left = ((getwidth / 2) - (width / 2)) + dualScreenLeft;
            var top = ((getheight / 2) - (height / 2)) + dualScreenTop;

            window.open(url, '', "width=" + width + ",height=" + height + ",status=no ,toolbar=no,menubar=no,location=no,resizable=yes,scrollbars=yes,left=" + left + ", top=" + top + "");
        }

        //페이지 이동
        function fnGoPage(pageVal) {
            switch (pageVal) {
                case "OHL":
                    window.location.href = "../Order/OrderHistoryList?ucode=" + ucode;
                    break;
                case "DL":
                    window.location.href = "../Order/DeliveryOrderList?ucode=" + ucode;
                    break;
                case "MSM":
                    window.location.href = "../Member/MemberMain_A?ucode=03";
                    break;
                case "MBM":
                    window.location.href = "../Member/MemberMain_B?ucode=03";
                    break;
                default:
                    break;
            }
        }

        //CD변경
        function fnDlvrGubunChgCD() {
            var confirmVal = confirm("정말로 CD변경을 하시겠습니까?");
            if (!confirmVal) {
                return false;
            }

            var callback = function (response) {
                if (!isEmpty(response)) {
                    if (response == "Success") {
                        alert("성공적으로 CD변경이 되었습니다. ");

                        fnCancel();

                        fnSearch(1);
                    } else {
                        alert("CD변경에 실패하였습니다. 개발담당자에게 문의바랍니다.");
                    }
                }
                return false;
            };

            var param = {
                UnumOrdNo: $("#hdPopupUorderNo").val(),
                OrdCodeNo: $("#hdPopupOrdCodeNo").val(),
                GdsCode: $("#hdPopupGoodsCode").val(),
                Method: "UpdateDlvrGubunChgCD"
            };

            var beforeSend = function () {
                is_sending = true;
            }
            var complete = function () {
                is_sending = false;
            }
            if (is_sending) return false;

            JqueryAjax("Post", "../../Handler/OrderHandler.ashx", false, false, param, "text", callback, beforeSend, complete, true, '<%=Svid_User %>');
        }

        //직송변경
        function fnDlvrGubunChg() {
            var confirmVal = confirm("정말로 직송변경을 하시겠습니까?");
            if (!confirmVal) {
                return false;
            }

            var callback = function (response) {
                if (!isEmpty(response)) {
                    if (response == "Success") {
                        alert("성공적으로 직송변경이 되었습니다. ");

                        fnCancel();

                        fnSearch(1);
                    } else {
                        alert("직송변경에 실패하였습니다. 개발담당자에게 문의바랍니다.");
                    }
                }
                return false;
            };

            var param = {
                UnumOrdNo: $("#hdPopupUorderNo").val(),
                OrdCodeNo: $("#hdPopupOrdCodeNo").val(),
                GdsFinCtgrCode: $("#hdPopupGoodsFinCtgrCode").val(),
                GdsGrpCode: $("#hdPopupGoodsGrpCode").val(),
                GdsCode: $("#hdPopupGoodsCode").val(),
                OrdSaleComCode: $("#hdPopupCompCode").val(),
                Method: "UpdateDlvrGubunChg"
            };

            var beforeSend = function () {
                is_sending = true;
            }
            var complete = function () {
                is_sending = false;
            }
            if (is_sending) return false;

            JqueryAjax("Post", "../../Handler/OrderHandler.ashx", false, false, param, "text", callback, beforeSend, complete, true, '<%=Svid_User %>');
        }

        //주문처리초기화
        function fnOrdStatReset() {
            var confirmVal = confirm("정말로 주문처리초기화를 하시겠습니까?");
            if (!confirmVal) {
                return false;
            }

            var callback = function (response) {
                if (!isEmpty(response)) {
                    if (response == "Success") {
                        alert("성공적으로 주문처리초기화가 되었습니다. ");

                        fnCancel();

                        fnSearch(1);
                    } else {
                        alert("주문처리초기화에 실패하였습니다. 개발담당자에게 문의바랍니다.");
                    }
                }
                return false;
            };

            var param = {
                UnumOrdNo: $("#hdPopupUorderNo").val(),
                OrdCodeNo: $("#hdPopupOrdCodeNo").val(),
                GdsCode: $("#hdPopupGoodsCode").val(),
                Method: "UpdateOrderStatReset"
            };

            var beforeSend = function () {
                is_sending = true;
            }
            var complete = function () {
                is_sending = false;
            }
            if (is_sending) return false;

            JqueryAjax("Post", "../../Handler/OrderHandler.ashx", false, false, param, "text", callback, beforeSend, complete, true, '<%=Svid_User %>');
        }

        //배송관련 & 입고관련 처리 함수
        function fnDeliPut(chk) {
            var ProcessType = chk;
            var OrderCodeNo = $("#lbl_pop_ordCodeNo").text();
            var GoodsCode = $("#hdPopupGoodsCode").val();
            var DeliDate = $("#deliDate").val();       //배송 완료
            var PutDate = $("#PutDate").val();       //입고일자
            var ParamDate;
            var confirmMsg = '';
            var tipMsg = '';

            //프로세스 타입 1 : 선택 배송완료 , 타입 2: PO 배송완료 , 타입 3 : 선택 입고확인, 타입4 : PO 입고확인

            //선택 타입의 경우에만 상품명 필요
            if (ProcessType == '1' || ProcessType == '2') {
                if (DeliDate == '') {
                    alert('배송 날짜를 입력해주세요.')
                    return false;
                }
                else {
                    ParamDate = DeliDate;
                }

                confirmMsg = "배송완료";
                tipMsg = "\n주문완료 상태인 경우 직송건(판매사=공급사)만 배송완료로 처리됩니다.";
            }

            if (ProcessType == '3' || ProcessType == '4') {
                if (PutDate == '') {
                    alert('입고 날짜를 입력해주세요.')
                    return false;
                }
                else {
                    ParamDate = PutDate;
                }

                confirmMsg = "입고 확인";
            }


            var confirmVal = confirm("정말로 " + confirmMsg + " 처리하시겠습니까?" + tipMsg + "\n\n(프로세스 타입 : " + ProcessType + ", 주문번호 : " + OrderCodeNo + "\n, 상품코드 : " + GoodsCode + ", 완료일자 : " + ParamDate + ")");
            if (!confirmVal) {
                return false;
            }

            //alert('프로세스 타입 : ' + ProcessType + '    주문번호 : ' + OrderCodeNo + '  상품코드 : ' + GoodsCode + '   완료일자 : ' + ParamDate)

            var callback = function (response) {
                if (!isEmpty(response)) {
                    if (response == "Success") {
                        alert("성공적으로 처리 되었습니다. ");

                        //fnCancel();
                        var container = $('#pagination');
                        var getPageNum = container.pagination('getSelectedPageNum');
                        fnSearch(getPageNum);
                    } else {
                        alert("실패하였습니다. 개발 담당자에게 문의바랍니다.");
                    }
                }
                return false;
            };

            var param = {
                Type: ProcessType,               //프로세스 타입
                OrdCodeNo: OrderCodeNo,          //주문번호
                GdsCode: GoodsCode,              //상품번호
                ChkDate: ParamDate,             //선택일자
                Method: "UpdateDeliPutDate"
            };

            var beforeSend = function () {
                is_sending = true;
            }
            var complete = function () {
                is_sending = false;
            }
            if (is_sending) return false;

            JqueryAjax("Post", "../../Handler/OrderHandler.ashx", false, false, param, "text", callback, beforeSend, complete, true, '<%=Svid_User %>');

        }

        //카드전체취소
        function fnOrdCardAllCancel(ordCodeNo, sUser) {
            //var uOrderNo = $(el).parent().parent().find("input:hidden[name^='hdUorderNo']").val();
            //var payway = $(el).parent().parent().find("input:hidden[name^='hdPayWay']").val();

            var selectOrdSeq = $("#hdPopupUorderNo").val(); //선택한 행의 주문시퀀스

            var url = "OrderCardAllCancelRequest";
            var targetName = "OrdCancelAllPopup";

            var addForm = "<form name='ordCancelAllForm' method='POST' action='" + url + "' target='" + targetName + "'>"
                + "<input type='hidden' name='uOdrNo' value='" + selectOrdSeq + "' />"
                + "<input type='hidden' name='ordCodeNo' value='" + ordCodeNo + "' />"
                + "<input type='hidden' name='sUser' value='" + sUser + "' />"
                + "<input type='hidden' name='flag' value='ETC' />"
                + "<input type='hidden' name='cancelFlag' value='ALL_12' />"
                + "</form>";

            $("body").append(addForm);

            var popupForm = $("form[name='ordCancelAllForm']");
            fnWindowOpen('', targetName, 650, 500, 'yes', 'no', 'no', 'no', 'no', 'no');
            popupForm.submit();
        }

        //(PO)세금계산서 발행 요청/중지
        function fnUpdateBillDate(flag) {
            var ordCodeNo = $("#hdPopupOrdCodeNo").val();
            var billEmail = '<%=UserInfoObject.Email %>';
            var billReqDate = '';
            var resultMsg = '';

            if (flag == "REQ") {
                resultMsg = "요청";
                billReqDate = $("#txtBillDate").val();

                if (isEmpty(billReqDate)) {
                    alert("날짜를 선택해 주세요.");
                    return false;
                }

            } else {
                resultMsg = "중지";
            }

            var confirmMsg = "정말로 세금계산서 발행을 " + resultMsg + "하시겠습니까?";
            var confirmVal = confirm(confirmMsg);

            if (!confirmVal) {
                return false;
            }

            var callback = function (response) {
                if (!isEmpty(response) && (response.length > 2)) {
                    //중지
                    if (response == "STOP") {
                        $("#txtBillDate").val('');
                        $("#spBillStop").css("display", "none");

                    } else {
                        $("#spBillStop").css("display", '');
                    }

                    alert("성공적으로 세금계산서 발행이 " + resultMsg + " 처리되었습니다.");

                } else {
                    alert("실패하였습니다. 개발 담당자에게 문의바랍니다.");
                }
                return false;
            };

            var sUser = '<%=Svid_User %>';
            var param = { OdrCodeNo: ordCodeNo, BillSelectDate: billReqDate, BillEmail: billEmail, BillFlag: flag, Method: "UpdateBillDate_Admin" };

            var beforeSend = function () {
                is_sending = true;
            }
            var complete = function () {
                is_sending = false;
            }
            if (is_sending) return false;

            JqueryAjax("Post", "../../Handler/PayHandler.ashx", false, false, param, "text", callback, beforeSend, complete, true, sUser);

            return false;
        }

        //(선택/PO)주문상태 변경
        function fnChangeOrderStatus(flag, sUser) {
            var ordStat = $("#sltOrdStat").val();
            var ordCodeNo = $("#hdPopupOrdCodeNo").val();
            var goodsCode = $("#hdPopupGoodsCode").val();
            var ordStatName = $("#sltOrdStat option:checked").text();
            var uNumOrdNo = $("#hdPopupUorderNo").val();

            //alert("ordStat : " + ordStat + ", ordCodeNo :  " + ordCodeNo + ", goodsCode : " + goodsCode+", SVID_USER : "+sUser);

            var confirmVal = confirm("정말로 주문상태를 \"" + ordStatName + "\" 로 변경하시겠습니까?");

            if (!confirmVal) {
                return false;
            }

            //전체
            if (flag == "All") {
                goodsCode = "ALL";
            }

            var callback = function (response) {
                if (!isEmpty(response)) {

                    $("#hdPopupOrderStatus").val(ordStat);

                    alert("성공적으로 주문상태가 변경되었습니다.");

                    getPageData();
                    fnSetDetailPopupDataBind(response);

                } else {
                    alert("실패하였습니다. 개발 담당자에게 문의바랍니다.");
                }
                return false;
            };

            var param = {
                SvidUser: sUser,
                OdrCodeNo: ordCodeNo,
                GoodsCode: goodsCode,
                OdrStat: ordStat,
                UNumOrdNo: uNumOrdNo,
                Method: "UpdateOrderStatus"
            };

            var beforeSend = function () {
                is_sending = true;
            }
            var complete = function () {
                is_sending = false;
            }
            if (is_sending) return false;

            JqueryAjax("Post", "../../Handler/OrderHandler.ashx", false, false, param, "json", callback, beforeSend, complete, true, '<%=Svid_User %>');
        }

        //선택/PO 운송장번호 저장
        function fnSaveDeleveryNo(flag, sUser) {
            var dlvrNo = $("#txtDlvrNo").val();
            var ordCodeNo = $("#hdPopupOrdCodeNo").val();
            var goodsCode = $("#hdPopupGoodsCode").val();
            var uNumOrdNo = $("#hdPopupUorderNo").val();
            var ordStat = "301";

            var confirmVal = confirm("정말로 운송장번호를 저장하시겠습니까?\n\n(PO별 운송장번호 입력일 경우 \"직송상품은 제외\" 됩니다.)");

            if (!confirmVal) {
                return false;
            }

            if (isEmpty(dlvrNo)) {
                alert("운송장번호를 입력해 주세요.");
                return false;
            }

            //전체
            if (flag == "All") {
                goodsCode = "ALL";
            }

            var callback = function (response) {
                if (!isEmpty(response)) {

                    $("#hdPopupOrderStatus").val(ordStat);

                    alert("성공적으로 운송장번호를 저장하였습니다.");

                    getPageData();
                    fnSetDetailPopupDataBind(response);

                } else {
                    alert("실패하였습니다. 개발 담당자에게 문의바랍니다.");
                }
                return false;
            };

            var param = {
                SvidUser: sUser,
                OdrCodeNo: ordCodeNo,
                GoodsCode: goodsCode,
                OdrStat: ordStat,
                UNumOrdNo: uNumOrdNo,
                DlvrNo: dlvrNo,
                Method: "UpdateOrderDlvrNo"
            };

            var beforeSend = function () {
                is_sending = true;
            }
            var complete = function () {
                is_sending = false;
            }
            if (is_sending) return false;

            JqueryAjax("Post", "../../Handler/OrderHandler.ashx", false, false, param, "json", callback, beforeSend, complete, true, '<%=Svid_User %>');
        }

        //거래명세서
        function fnPrintOrderList(sUser) {
            var ordCodeNo = $("#hdPopupOrdCodeNo").val();
            var ordStat = $("#hdPopupOrderStatus").val();
            var saleComCode = $("#hdPopupCompCode").val();
            var url = '../../Print/AdminTransactionReport?OrderCodeNo=' + ordCodeNo + '&SvidUser=' + sUser + '&OrdStat=' + ordStat + '&SaleCompCode=' + saleComCode;

            fnWindowOpen(url, '', 1000, 600, 'yes', 'no', 'no', 'no', 'yes', 'yes');
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
                <table id="tblHistoryList" class="tbl_main">
                    <thead>
                        <tr>
                            <th colspan="8" style="height: 40px;">주문내역조회</th>
                        </tr>
                    </thead>
                    <tr>
                        <th class="txt-center" style="width: 150px;">조회기간
                        </th>
                        <td colspan="4">

                            <asp:TextBox ID="txtSearchSdate" runat="server" MaxLength="10" CssClass="calendar" OnkeyPress="return fnEnterDate();" placeholder="2018-01-01" ReadOnly="true"></asp:TextBox>
                            -
                            <asp:TextBox ID="txtSearchEdate" runat="server" MaxLength="10" CssClass="calendar" OnkeyPress="return fnEnterDate();" placeholder="2018-12-30" ReadOnly="true"></asp:TextBox>&nbsp;&nbsp;&nbsp;
                            <input type="checkbox" style="margin-top: 6px;" name="chkBox" id="ckbSearch1" value="1" checked="checked" /><label for="ckbSearch1">1일</label>
                            <input type="checkbox" style="margin-top: 6px; margin-left: 5px;" name="chkBox" id="ckbSearch7" value="7" /><label for="ckbSearch2">7일</label>
                            <input type="checkbox" style="margin-top: 6px; margin-left: 5px;" name="chkBox" id="ckbSearch15" value="15" /><label for="ckbSearch3">15일</label>
                            <input type="checkbox" style="margin-top: 6px; margin-left: 5px;" name="chkBox" id="ckbSearch30" value="30" /><label for="ckbSearch4">30일</label>
                            <input type="checkbox" style="margin-top: 6px; margin-left: 5px;" name="chkBox" id="ckbSearch90" value="90" /><label for="ckbSearch5">90일</label>
                            <input type="checkbox" style="margin-top: 6px; margin-left: 5px;" name="chkBox" id="ckbSearch0" value="0" /><label for="ckbSearch6">직접입력</label>
                        </td>
                    </tr>
                    <tr>
                        <th style="width: 150px;">판매사</th>
                        <td>
                            <asp:TextBox runat="server" ID="txtSaleCompName" class="large-size" Onkeypress="return fnEnter();"></asp:TextBox>
                        </td>
                        <th style="width: 150px;">구매사</th>
                        <td>
                            <asp:TextBox runat="server" ID="txtBuyCompName" class="large-size" Onkeypress="return fnEnter();"></asp:TextBox>
                        </td>
                        <td rowspan="4" style="width: 123px">
                            <input type="button" class="mainbtn type1" value="조회하기" style="width: 90px; margin-bottom: 5px;" onclick="fnSearch(1); return false;" />
                            <br />
                            <input type="button" class="mainbtn type1" value="초기화" style="width: 90px;" onclick="fnInitState()" />

                        </td>

                    </tr>
                    <tr>
                        <th style="width: 150px;">구분(처리상태)</th>
                        <td>
                            <asp:DropDownList runat="server" ID="ddlOrderStatus" CssClass="large-size">
                            </asp:DropDownList>
                        </td>
                        <th style="width: 150px;">결제수단</th>
                        <td>
                            <asp:DropDownList runat="server" ID="ddlPayWay" CssClass="input-drop" Style="width: 300px">
                            </asp:DropDownList>
                        </td>

                    </tr>
                    <tr>
                        <th style="width: 200px;">주문번호</th>
                        <td>
                            <asp:TextBox runat="server" ID="txtOrderNo" class="large-size" Onkeypress="return fnEnter();"></asp:TextBox>
                        </td>
                        <th>상품코드</th>
                        <td>
                            <asp:TextBox runat="server" ID="txtGoodsCode" class="large-size" Onkeypress="return fnEnter();"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <th>상품명</th>
                        <td>
                            <asp:TextBox runat="server" ID="txtGoodsName" class="large-size" Onkeypress="return fnEnter();"></asp:TextBox>
                        </td>
                        <th>브랜드명</th>
                        <td>
                            <asp:TextBox runat="server" ID="txtBrand" class="large-size" Onkeypress="return fnEnter();"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="5" style="height: 200px; text-align: center">
                            <img src="../../images/order/perpectgift.jpg" />
                        </td>
                    </tr>
                </table>
            </div>
            <%--검색영역 버튼--%>
            <div style="width: 100%; height: 60px; margin-top: 20px;">
                <div style="float: left; display: inline-block; width: 50%">
                    <input type="button" class="mainbtn type1" style="width: 125px; height: 30px; font-size: 12px" value="회원관리(판매사)" onclick="fnGoPage('MSM')" />
                    <input type="button" class="mainbtn type1" style="width: 125px; height: 30px; font-size: 12px" value="회원관리(구매사)" onclick="fnGoPage('MBM')" />
                    <input type="button" class="mainbtn type1" style="width: 95px; height: 30px; font-size: 12px" value="배송조회" onclick="fnGoPage('DL')" />
                </div>
                <div class="vattext" style="float: right; display: inline-block; border-bottom: 2px solid #f9264f; line-height: 23px; padding: 3px 23px; margin-bottom: 10px;">
                    <asp:Label runat="server" ID="lblPayStatus1" CssClass="currentPay"></asp:Label><br />
                    <asp:Label runat="server" ID="lblPayStatus2" CssClass="currentPay"></asp:Label>
                </div>

            </div>

            <!--하단영역-->
            <div class="list-table">


                <table id="tblSearch" class="tbl_main">
                    <colgroup>
                        <col width="4%" /> <!-- 번호 -->
                        <col width="10%" /> <!-- 주문일자/주문번호 -->
                        <col width="10%" /> <!-- 구매사/주문자아이디 -->
                        <col width="13%" /> <!-- 판매사 -->
                        <col width="11%" /> <!-- 주문상품정보 -->
                        <col width="9%" /> <!-- 모델명 -->
                        <col width="9%" /> <!-- 최소수량/내용량/주문수량 -->
                        <col width="8%" /> <!-- 주문금액(VAT포함) -->
                        <col width="8%" /> <!-- 출고예정일/배송완료일 -->
                        <col width="9%" /> <!-- 주문처리현황 -->
                        <col width="9%" /> <!-- 결제수단 -->
                    </colgroup>
                    <thead>
                        <tr>
                            <th rowspan="2">번호</th>
                            <th>주문일자</th>
                            <th>구매사</th>
                            <th rowspan="2">판매사</th>
                            <th rowspan="2">주문상품정보</th>
                            <th rowspan="2">모델명</th>
                            <th>최소수량 / 내용량</th>
                            <th rowspan="2">주문금액<br />(VAT포함)</th>
                            <th>출고예정일</th>
                            <th rowspan="2">주문처리<br />현황</th>
                            <th rowspan="2">결제수단</th>
                        </tr>
                        <tr>
                            <th>주문번호</th>
                            <th>주문자<br />-아이디-</th>
                            <th>주문수량</th>
                            <th>배송완료일</th>
                        </tr>
                    </thead>
                    <tbody>
                    </tbody>
                </table>


                <!--엑셀저장버튼-->
                <div class="bt-align-div">
                    <asp:Button ID="btnExcelExport" runat="server" Height="30" Text="주문내역 엑셀 저장" OnClick="btnExcelExport_Click" CssClass="mainbtn type1" />
                    <asp:Button ID="btnDeliveryExport" runat="server" Width="130" Height="30" Text="택배용 엑셀 저장" OnClick="btnDeliveryExport_Click" CssClass="mainbtn type1" />
                </div>
            </div>


            <input type="hidden" id="hdTotalCount" />

            <!-- 페이징 처리 -->
            <div style="margin: 0 auto; text-align: center">
                <div id="pagination" class="page_curl" style="display: inline-block"></div>
            </div>


            <!-- DIV팝업창(주문상세) 시작 -->

            <div id="productDiv" class="popupdiv divpopup-layer-package">

                <div class="popupdivWrapper" style="width: 85%">
                    <div class="popupdivContents" style="">
                        <div class="close-div">
                            <a onclick="fnCancel()" style="cursor: pointer">
                                <img src="../../Images/Wish/icon-delete.jpg" alt="닫기" style="float: right;" />
                            </a>
                        </div>
                        <div class="sub-title-div">
                            <h3 class="pop-title">주문상품</h3>
                        </div>

                        <%--<div class="mini-title">
                            <img src="../../Images/Order/subOrder.jpg" alt="주문내역" />
                        </div>--%>
                        <div style="text-align: right;">주문금액:<label id="lbPrice"></label>원</div>

                        <div class="tblOrder-div">
                            <input type="hidden" id="hdPopupUorderNo" />
                            <input type="hidden" id="hdPopupOrdCodeNo" />
                            <input type="hidden" id="hdPopupGoodsFinCtgrCode" />
                            <input type="hidden" id="hdPopupGoodsGrpCode" />
                            <input type="hidden" id="hdPopupGoodsCode" />
                            <input type="hidden" id="hdPopupCompCode" />
                            <input type="hidden" id="hdPopupOrderStatus" />
                            <input type="hidden" id="hdPopupPayway" />
                            <input type="hidden" id="hdPopupTid" />
                            <input type="hidden" id="hdPopupBillSelectDate" />
                            <input type="hidden" id="hdPopupBillEmail" />
                            <input type="hidden" id="hdPopupBillCheck" />
                            <input type="hidden" id="hdPopupBillTransCnt" />
                            <input type="hidden" id="hdPopupDlvrNo" />
                         <div style="height:300px; overflow-y:auto;">
                            <table id="tblOrder" class="tbl_main tbl_pop">
                                <thead>
                                    <tr>
                                        <th style="width: 80px;" rowspan="2">판매사</th>
                                        <th style="width: 280px;" rowspan="2">주문상품정보</th>
                                        <th style="width: 60px;" rowspan="2">모델명</th>
                                        <th style="width: 120px;">최소수량 / 내용량</th>
                                        <th style="width: 70px;" rowspan="2">주문금액<br />
                                            (VAT포함)</th>
                                        <th style="width: 70px;">출고예정일</th>
                                        <th style="width: 80px;" rowspan="2">주문처리현황</th>
                                        <th style="width: 80px;" rowspan="2">결제수단</th>
                                    </tr>
                                    <tr>
                                        <th>주문수량</th>
                                        <th>배송완료일</th>
                                    </tr>
                                </thead>
                                <tbody id="tbody_pop_odrDtl"></tbody>
                            </table>
                        </div>
                        </div>
                        <%--<div class="mini-title">
                            <img src="../../Images/Order/subPay.jpg" alt="결제내역" />
                        </div>--%>
                        <div id="divDtlPop_1">
                            <table id="tbl_dtlPop_pay" class="tbl_main tbl_pop"></table>
                        </div>

                        <br />

                        <%-- <a onclick="fnCancel('divPopup')">확인</a>--%>



                        <div>
                            <table style="width: 100%">
                                <tr>
                                    <th colspan="2">※ 주문자정보(<a id="lbl_pop_ordCodeNo" href="javascript:fnSelectOrderSearch()"></a>)
                                        <input type="hidden" id="hdGoodsCode" name="hdGoodsCode" value="" />
                                    </th>
                                </tr>
                                <tr>
                                    <td id="td_pop_userInfo" style="padding-left: 15px;" colspan="2"></td>
                                </tr>
                                <tr>
                                    <td id="td_pop_addr" style="width: 50%; padding-left: 15px;"></td>
                                    <td style="width: 49%; text-align: right;">
                                        <%--<input type="button" id="btnDlvrGubunChg" class="commonBtn" style="width: 95px; height: 30px; font-size: 12px; display: none" value="직송변경" onclick="fnDlvrGubunChg(); return false;" />
                                        <input type="button" id="btnDlvrGubunChgCD" class="commonBtn" style="width: 95px; height: 30px; font-size: 12px; display: none" value="CD변경" onclick="fnDlvrGubunChgCD(); return false;" />--%>
                                        <%--<input type="button" id="btnOrdStatReset" class="commonBtn" style="width: 115px; height: 30px; font-size: 12px; display: none" value="주문처리초기화" onclick="fnOrdStatReset(); return false;" />--%>

                                        <input type="button" id="btnCardSpecification" class="mainbtn type1" style="width: 95px; display: none" value="카드명세표" onclick="fnPortFolio(); return false;" />
                                        <input type="button" id="btnCancelCardSpec" class="mainbtn type1" style="width: 125px; display: none" value="(취소)카드명세표" onclick="fnCancelPortFolio(); return false;" />
                                        <input type="button" class="mainbtn type1" style="width:75px;" value="확인" onclick="fnCancel('divPopup')" />
                                    </td>
                                </tr>
                            </table>
                        </div>

                        <%--<a style="float: right;">
                            <img src="../../Images/Goods/sub-off.jpg" alt="확인" onclick="fnCancel('divPopup')" onmouseover="this.src='../../Images/Goods/sub-on.jpg'" onmouseout="this.src='../../Images/Goods/sub-off.jpg'" /></a>--%>

                        <%--<a onclick="fnSubmit(); return false;">확인</a>--%>
                    </div>
                </div>
            </div>
        </div>

    </div>
</asp:Content>

