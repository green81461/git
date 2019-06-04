<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Master/AdminMasterPage.master" AutoEventWireup="true" CodeFile="OrderBillDeadLine.aspx.cs" Inherits="Admin_Order_OrderBillDeadLine" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <link href="../Content/Order/order.css" rel="stylesheet" />
    <link href="../Content/popup.css" rel="stylesheet" />  
    <script type="text/javascript">
        $(document).ready(function () {
            $.datepicker.regional['ko'] = {
                closeText: '닫기',
                prevText: '이전달',
                nextText: '다음달',
                currentText: '오늘',
                monthNames: ['1월(JAN)', '2월(FEB)', '3월(MAR)', '4월(APR)', '5월(MAY)', '6월(JUN)', '7월(JUL)', '8월(AUG)', '9월(SEP)', '10월(OCT)', '11월(NOV)', '12월(DEC)'],
                monthNamesShort: ['1월', '2월', '3월', '4월', '5월', '6월', '7월', '8월', '9월', '10월', '11월', '12월'],
                dayNames: ['일', '월', '화', '수', '목', '금', '토'],
                dayNamesShort: ['일', '월', '화', '수', '목', '금', '토'],
                dayNamesMin: ['일', '월', '화', '수', '목', '금', '토'],
                weekHeader: 'Wk',
                dateFormat: 'yy-mm-dd',
                firstDay: 0,
                isRTL: false,
                showMonthAfterYear: true,
                yearSuffix: '',
                showOn: 'both',
                buttonImage: '../../Images/Goods/calendar.jpg',
                buttonImageOnly: true,
                // buttonText: "달력",
                changeMonth: true,
                changeYear: true,
                showButtonPanel: true,
                yearRange: 'c-99:c+99'
            };
            $.datepicker.setDefaults($.datepicker.regional['ko']);

            var sDate_default = {
                showOn: 'both',
                buttonImage: '../../Images/Goods/calendar.jpg',
                buttonImageOnly: true,
                // buttonText: "달력",
                currentText: "이번달",
                changeMonth: true,
                changeYear: true,
                showButtonPanel: true,
                yearRange: 'c-99:c+99',
                showOtherMonths: true,
                selectOtherMonths: true
            }

            sDate_default.closeText = "선택";
            sDate_default.dateFormat = "yy-mm";
            sDate_default.onClose = function (dateText, inst) {
                var month = $("#ui-datepicker-div .ui-datepicker-month :selected").val();
                var year = $("#ui-datepicker-div .ui-datepicker-year :selected").val();
                $(this).datepicker("option", "defaultDate", new Date(year, month, 1));
                $(this).datepicker('setDate', new Date(year, month, 1));
            }

            sDate_default.beforeShow = function () {
                var selectDate = $("#<%=this.txtSearchSdate.ClientID%>").val().split("-");
                var year = Number(selectDate[0]);
                var month = Number(selectDate[1]) - 1;
                $(this).datepicker("option", "defaultDate", new Date(year, month, 1));
            }

            var eDate_default = {
                showOn: 'both',
                buttonImage: '../../Images/Goods/calendar.jpg',
                buttonImageOnly: true,
                // buttonText: "달력",
                currentText: "이번달",
                changeMonth: true,
                changeYear: true,
                showButtonPanel: true,
                yearRange: 'c-99:c+99',
                showOtherMonths: true,
                selectOtherMonths: true
            }

            eDate_default.closeText = "선택";
            eDate_default.dateFormat = "yy-mm";
            eDate_default.onClose = function (dateText, inst) {
                var month = $("#ui-datepicker-div .ui-datepicker-month :selected").val();
                var year = $("#ui-datepicker-div .ui-datepicker-year :selected").val();
                $(this).datepicker("option", "defaultDate", new Date(year, month, 1));
                $(this).datepicker('setDate', new Date(year, month, 1));
            }

            eDate_default.beforeShow = function () {
                var selectDate = $("#<%=this.txtSearchEdate.ClientID%>").val().split("-");
                var year = Number(selectDate[0]);
                var month = Number(selectDate[1]) - 1;
                $(this).datepicker("option", "defaultDate", new Date(year, month, 1));
            }

            $("#<%=this.txtSearchSdate.ClientID%>").datepicker(sDate_default);
            $("#<%=this.txtSearchEdate.ClientID%>").datepicker(eDate_default);

            ListCheckboxOnlyOne('tblPopupAdmUserId');
            ListCheckboxOnlyOne('tblPopupComp');

        });

        // enter key 방지
        $(document).on("keypress", "#tblSearchPart input, #txtPopDropReason", function (e) {
            if (e.keyCode == 13) {
                e.preventDefault();
                return false;
            }
            else
                return true;
        });

        function showCarryForwardPopup(el) {
            fnOpenDivLayerPopup('CarryForwardDiv');
            //var e = document.getElementById('CarryForwardDiv');

            //if (e.style.display == 'block') {
            //    e.style.display = 'none';

            //} else {
            //    e.style.display = 'block';
            //    $(".popupdivWrapper").draggable();
            //}
            return false;
        }
        //상세보기
        function showDetailPopup(el) {
            fnOpenDivLayerPopup('DetailDiv');
            //var e = document.getElementById('DetailDiv');

            //if (e.style.display == 'block') {
            //    e.style.display = 'none';

            //} else {
            //    e.style.display = 'block';
            //    $(".popupdivWrapper").draggable();
            //}
            $("#hd_UnumPayNo").val(el);

            //   var uNumPay = $(el).parent().parent().find("input:hidden[name='hdUnumPayNo']").val();
            SearachPop(1, el);
            return false;
        }

        //마감이월사유
        function showNextReason(el) {

            fnClosePopup('nextReasonDiv')

            //var e = document.getElementById('nextReasonDiv');

            //if (e.style.display == 'block') {
            //    e.style.display = 'none';

            //} else {
            //    e.style.display = 'block';
            //    $(".popupdivWrapper").draggable();
            //}

            $("#txtPopDropReason").val(el);

            return false;
        }


        //function fnCancel() {
        //    $('.popupdiv').fadeOut();
        //    return false;
        //}

        function fnPopDelay() {

            $('.popupdiv divpopup-layer-package').fadeOut();
            return false;
        }


        //담당자 검색 팝업 ON
        function fnSearchAdmUserIdPopup() {

            fnAdmUserIdSearch(1);

            fnOpenDivLayerPopup('admUserIdSearchDiv');
            //var e = document.getElementById('admUserIdSearchDiv');

            //if (e.style.display == 'block') {
            //    e.style.display = 'none';

            //} else {
            //    $(".popupdivWrapper").css("height", "500px");

            //    e.style.display = 'block';
            //    $(".popupdivWrapper").draggable();
            //}
            return false;
        }

        function fnAdmUserIdSearch(pageNo) {
            var searchKeyword = $("#txtPopSearch2").val();
            var searchTarget = $("#ddlPopSearch2").val();
            var pageSize = 15;
            var asynTable = "";
            var i = 1;

            var callback = function (response) {
                $("#pop_admUserIdTbody").empty();

                if (!isEmpty(response)) {

                    $.each(response, function (key, value) {

                        $('#hdTotalCount2').val(value.TotalCount);

                        asynTable += "<tr name='trColor'>"
                        asynTable += "<td class='txt-center'><input type='checkbox' id='cbPopup'/><input type='hidden' name='hdPopUserId' value='" + value.Id + "' /><input type='hidden' name='hdPopUserNm' value='" + value.Name + "' /></td>";
                        asynTable += "<td class='txt-center'>" + (pageSize * (pageNo - 1) + i) + "</td>";
                        asynTable += "<td class='txt-center' id='tdPopUserId'>" + value.Id + "</td>";
                        asynTable += "<td class='txt-center' id='tdPopName'>" + value.Name + "</td>";
                        asynTable += "</tr>";
                        i++;
                    });

                } else {
                    asynTable += "<tr><td colspan='4' class='txt-center'>" + "리스트가 없습니다." + "</td></tr>"
                    $("#pop_admUserIdTbody").val(0);

                }
                $("#pop_admUserIdTbody").append(asynTable);

                //페이징
                fnCreatePagination('pagination2', $("#hdTotalCount2").val(), pageNo, pageSize, getPageData2);
                return false;
            }

            var param = { Method: 'GetUserSearchList', Type: 'D', SearchTarget: searchTarget, SearchKeyword: searchKeyword, PageNo: pageNo, PageSize: pageSize };

            var beforeSend = function () { };
            var complete = function () { };

            JqueryAjax("Post", "../../Handler/Common/UserHandler.ashx", true, false, param, "json", callback, beforeSend, complete, true, '<%=Svid_User%>');

            <%--JajaxSessionCheck('Post', '../../Handler/Common/UserHandler.ashx', param, 'json', callback, '<%=Svid_User%>');--%>

        }


        //페이징 인덱스 클릭시 데이터 바인딩
        function getPageData2() {
            var container = $('#pagination2');
            var getPageNum = container.pagination('getSelectedPageNum');
            fnAdmUserIdSearch(getPageNum);
            return false;
        }

        //우리안 관리 담당자 아이디 팝업 확인 버튼 클릭 시
        function fnPopupOkAdmUserId() {
            var cnt = 0;

            $('#tblPopupAdmUserId tr').each(function (index, element) {
                var check = $(this).find("#cbPopup").is(":checked");
                if (check) {
                    var userId = $(this).find("input:hidden[name='hdPopUserId']").val();
                    var userNm = $(this).find("input:hidden[name='hdPopUserNm']").val();

                    $("#txtSearchCompCode").val('');
                    $("#txtSearchCompName").val('');

                    $("#loanEndDate").text('');
                    $("#loanBillDate").text('');
                    $("#loanPayDate").text('');

                    $("#txtSearchAdminId").val(userId);
                    $("#txtSearchAdminName").val(userNm);

                    ++cnt;
                }
            });

            if (cnt == 0) {
                alert('우리안 관리 담당자 아이디를 선택해 주세요.');
                return false;
            }
            fnClosePopup("admUserIdSearchDiv");
            return true;
        }

        //[팝업]우리안 관리 담당자 조회
        function fnAdmUserIdSearch(pageNo) {
            var searchKeyword = $("#txtPopSearch2").val();
            var searchTarget = $("#ddlPopSearch2").val();
            var pageSize = 15;
            var asynTable = "";
            var i = 1;

            var callback = function (response) {
                $("#pop_admUserIdTbody").empty();

                if (!isEmpty(response)) {

                    $.each(response, function (key, value) {

                        $('#hdTotalCount2').val(value.TotalCount);

                        asynTable += "<tr name='trColor'>"
                        asynTable += "<td class='txt-center'><input type='checkbox' id='cbPopup'/><input type='hidden' name='hdPopUserId' value='" + value.Id + "' /><input type='hidden' name='hdPopUserNm' value='" + value.Name + "' /></td>";
                        asynTable += "<td class='txt-center'>" + (pageSize * (pageNo - 1) + i) + "</td>";
                        asynTable += "<td class='txt-center' id='tdPopUserId'>" + value.Id + "</td>";
                        asynTable += "<td class='txt-center' id='tdPopName'>" + value.Name + "</td>";
                        asynTable += "</tr>";
                        i++;
                    });

                } else {
                    asynTable += "<tr><td colspan='4' class='txt-center'>" + "리스트가 없습니다." + "</td></tr>"
                    $("#hdTotalCount2").val(0);

                }
                $("#pop_admUserIdTbody").append(asynTable);

                //페이징
                fnCreatePagination('pagination2', $("#hdTotalCount2").val(), pageNo, pageSize, getPageData2);
                return false;
            }

            var param = { Method: 'GetUserSearchList', Type: 'D', SearchTarget: searchTarget, SearchKeyword: searchKeyword, PageNo: pageNo, PageSize: pageSize };

            var beforeSend = function () { };
            var complete = function () { };

            JqueryAjax('Post', '../../Handler/Common/UserHandler.ashx', true, false, param, 'json', callback, beforeSend, complete, true, '<%=Svid_User%>');
        }

        //회사 조회 팝업
        function fnSearchCompPopup() {

            fnCompSearch(1);

            fnOpenDivLayerPopup('compSearchDiv');

            //var e = document.getElementById('compSearchDiv');

            //if (e.style.display == 'block') {
            //    e.style.display = 'none';

            //} else {
            //    e.style.display = 'block';
            //    $(".popupdivWrapper").draggable();
            //}
            return false;
        }


        //[팝업]회사 조회
        function fnCompSearch(pageNo) {
            var searchKeyword = $("#txtCompPopSearch").val();
            var searchTarget = $("#ddlCompPopSearch").val();
            var pageSize = 15;
            var asynTable = "";
            var i = 1;

            var callback = function (response) {
                $("#pop_CompTbody").empty();

                if (!isEmpty(response)) {

                    $.each(response, function (key, value) {

                        $('#hdCompTotalCount').val(value.TotalCount);

                        asynTable += "<tr name='trColor'>"
                        asynTable += "<td class='txt-center'><input type='checkbox' id='cbCompPopup'/>";
                        asynTable += "<input type='hidden' name='hdPopCompCode' value='" + value.Company_Code + "' /><input type='hidden' name='hdPopCompName' value='" + value.Company_Name + "' />";
                        asynTable += "<input type='hidden' name='hdLoanEndDate' value='" + value.LoanEndDate + "' />";
                        asynTable += "<input type='hidden' name='hdLoanBillDate' value='" + value.LoanBillDate + "' />";
                        asynTable += "<input type='hidden' name='hdLoanPayDate' value='" + value.LoanPayDate + "' />";
                        asynTable += "<input type='hidden' name='hdLoanCalDue' value='" + value.LoanCalDue + "' />";
                        asynTable += "</td>";
                        asynTable += "<td class='txt-center' id='tdPopCompCode'>" + value.Company_Code + "</td>";
                        asynTable += "<td class='txt-center' id='tdPopCompName'>" + value.Company_Name + "</td>";
                        asynTable += "<td class='txt-center'>" + value.LoanEndDate + "일</td>";
                        asynTable += "</tr>";
                        i++;
                    });

                } else {
                    asynTable += "<tr><td colspan='4' class='txt-center'>" + "리스트가 없습니다." + "</td></tr>"
                    $("#hdCompTotalCount").val(0);

                }

                $("#pop_CompTbody").append(asynTable);

                //페이징
                fnCreatePagination('compPagination', $("#hdCompTotalCount").val(), pageNo, pageSize, getCompPageData);
                return false;
            }

            var param = {
                Flag: 'GetCompListByAdminId',
                Target: searchTarget,
                Keyword: searchKeyword,
                AdminId: $('#txtSearchAdminId').val(),
                LoanYN: 'Y',
                PageNo: pageNo,
                PageSize: pageSize
            };

            var beforeSend = function () { };
            var complete = function () { };

            JqueryAjax('Post', '../../Handler/Admin/CompanyHandler.ashx', true, false, param, 'json', callback, beforeSend, complete, true, '<%=Svid_User%>');

        }

        //페이징 인덱스 클릭시 데이터 바인딩
        function getCompPageData() {
            var container = $('#compPagination');
            var getPageNum = container.pagination('getSelectedPageNum');
            fnCompSearch(getPageNum);
            return false;
        }


        //회사 팝업 확인 버튼 클릭 시
        function fnPopupOkComp() {
            var cnt = 0;

            $('#pop_CompTbody tr').each(function (index, element) {
                var check = $(this).find("#cbCompPopup").is(":checked");
                if (check) {
                    var compCode = $(this).find("input:hidden[name='hdPopCompCode']").val();
                    var compName = $(this).find("input:hidden[name='hdPopCompName']").val();

                    var loanEndDate = $(this).find("input:hidden[name='hdLoanEndDate']").val();
                    var loanBillDate = $(this).find("input:hidden[name='hdLoanBillDate']").val();
                    var loanPayDate = $(this).find("input:hidden[name='hdLoanPayDate']").val();
                    var loanCalDue = $(this).find("input:hidden[name='hdLoanCalDue']").val();

                    var loanCalDueTxt = '';
                    switch (loanCalDue) {
                        case '0':
                            loanCalDueTxt = '당월';
                            break;
                        case '30':
                            loanCalDueTxt = '익월';
                            break;
                        case '60':
                            loanCalDueTxt = '익익월';
                            break;
                        case '90':
                            loanCalDueTxt = '익익월';
                            break;
                        case '120':
                            loanCalDueTxt = '익익월';
                            break;

                        default:
                            loanCalDueTxt = '당월';
                            break;
                    }

                    var loanBillDueTxt = '';

                    if (parseInt(loanEndDate) <= parseInt(loanBillDate)) {
                        loanBillDueTxt = '당월';
                    }
                    else {
                        loanBillDueTxt = '익월';
                    }
                    $("#txtSearchCompCode").val(compCode);
                    $("#txtSearchCompName").val(compName);
                    $('#hdLoanEndDate').val(loanEndDate);
                    $("#loanEndDate").text('당월 ' + loanEndDate + '일');
                    $("#loanBillDate").text(loanBillDueTxt + ' ' + loanBillDate + '일');
                    $("#loanPayDate").text(loanCalDueTxt + ' ' + loanPayDate + '일');

                    ++cnt;
                }
            });

            if (cnt == 0) {
                alert('회사를 선택해 주세요.');
                return false;
            }
            fnClosePopup("compSearchDiv");
            return true;
        }

        //조회 버튼
        function fnSearch(pageNum) {

            var txtSdate = $("#<%=this.txtSearchSdate.ClientID%>").val();
            var txtEdate = $("#<%=this.txtSearchEdate.ClientID%>").val();
            var adminID = $("#txtSearchAdminId").val();    //우리안담당자명
            var compCode = $("#txtSearchCompCode").val();  //회사코드
            var searchKeyword = $("#txtLoanNo").val();   //여신결제번호

            if ((txtSdate != '') && (txtEdate != '')) {

                var schSdate = txtSdate.split('-');
                var schSdateYY = schSdate[0];
                var schSdateMM = schSdate[1];
                var schEdate = txtEdate.split('-');
                var schEdateYY = schEdate[0];
                var schEdateMM = schEdate[1];

                var pageSize = 20;
                var searchTbl = "";

                var callback = function (response) {

                    $("#tblSearch tbody").empty();

                    if (!isEmpty(response)) {

                        $.each(response, function (key, value) {

                            $("#hdTotalCount").val(value.TotalCount);

                            searchTbl += "<tr>"
                            searchTbl += "<td style='border:1px solid #a2a2a2; text-align:center' class='txt-center'><input type='checkbox'/>" + "</td>";
                            searchTbl += "<td style='border:1px solid #a2a2a2; text-align:center' class='txt-center'>" + fnOracleDateFormatConverter(value.EntryDate) + "</td>";
                            searchTbl += "<td style='border:1px solid #a2a2a2; text-align:center' class='txt-center'>" + value.Company_Name + "</td>";
                            searchTbl += "<td style='border:1px solid #a2a2a2; text-align:center' class='txt-center'>" + value.AdminUserName + "</td>";
                            searchTbl += "<td style='border:1px solid #a2a2a2; text-align:center' class='txt-center'>" + value.OrderCodeNo + "</td>";
                            searchTbl += "<td style='border:1px solid #a2a2a2; text-align:center' class='txt-center'>" + value.OrderCnt + "</td>";
                            searchTbl += "<td style='border:1px solid #a2a2a2; text-align:center' class='txt-center'>" + value.TotalQty + "</td>";
                            searchTbl += "<td style='border:1px solid #a2a2a2; text-align:center' class='txt-center'>" + numberWithCommas(value.TotalGoodsSalePriceVat) + "  원</td>";
                            searchTbl += "<td style='border:1px solid #a2a2a2; text-align:center'><input type='button' class='listBtn' value='상세보기' style='width:71px; height:22px; font-size:12px' onclick='showDetailPopup(\"" + value.Unum_PayNo + "\")' /></td></tr>";
                        });
                    } else {
                        searchTbl += "<tr><td colspan='9' class='txt-center'>" + "조회된 정보가 없습니다." + "</td></tr>"
                        $("#hdTotalCount").val(0);
                    }

                    $("#tblSearch tbody").append(searchTbl);
                    fnCreatePagination('pagination', $("#hdTotalCount").val(), pageNum, pageSize, getPageData);

                }
                var param = {
                    compCode: compCode,                   //회사코드                                      
                    adminID: adminID,                   //담당자명
                    odrCodeNo: searchKeyword,           //여신번호
                    sYear: schSdateYY,
                    eYear: schEdateYY,
                    sMon: schSdateMM,
                    eMon: schEdateMM,
                    PageNo: pageNum,
                    PageSize: pageSize,
                    Method: 'OrderBillDeadLine'
                };

                var beforeSend = function () { };
                var complete = function () { };

                JqueryAjax("Post", "../../Handler/PayHandler.ashx", true, false, param, "json", callback, beforeSend, complete, true, '<%=Svid_User%>');

                <%--JajaxSessionCheck('Post', '../../Handler/PayHandler.ashx', param, 'json', callback, '<%=Svid_User%>');--%>
            }
            else {
                alert('조회 일자를 지정해주세요.')
                return false;
            }
        }

        //페이징 처리하는 것.
        function getPageData() {
            var container = $('#pagination');
            var getPageNum = container.pagination('getSelectedPageNum');
            fnSearch(getPageNum);
            return false;
        }


        //페이징 처리하는 것.(팝업창)
        function getPageData3() {
            var container = $('#pagination_3');
            var getPageNum = container.pagination('getSelectedPageNum');
            SearachPop(getPageNum, $("#hd_UnumPayNo").val());
            return false;
        }

        //엔터 키 (회사 검색)
        function fnAdminPopupEnter() {
            if (event.keyCode == 13) {
                fnAdmUserIdSearch(1);
                return false;
            }
            else
                return true;
        }

        //엔터키(담당자 검색)
        function fnCompPopupEnter() {
            if (event.keyCode == 13) {
                fnCompSearch(1);
                return false;
            }
            else
                return true;
        }

        //팝업에서 조회
        function SearachPop(pageNum, UnumPayNo) {
            //var searchKeyword = $("#txtLoanNo").val();   //여신결제번호

            var pageSize = 7;                                  //페이징 처리 사이즈
            var i = 1;                                          //페이징
            var asynTable = "";

            var callback = function (response) {

                $("#tblOrderBillDeadLinePop tbody").empty();

                if (!isEmpty(response)) {

                    $.each(response, function (key, value) {
                        $("#hdTotalCount_2").val(value.TotalCount);
                        var src = '/GoodsImage' + '/' + value.GoodsFinalCategoryCode + '/' + value.GoodsGroupCode + '/' + value.GoodsCode + '/' + value.GoodsFinalCategoryCode + '-' + value.GoodsGroupCode + '-' + value.GoodsCode + '-sss.jpg';
                        asynTable += "<tr name='trColor'>"
                        asynTable += "<td rowspan='2' class='txt-center'>" + value.RowNumber + "</td>";  //번호
                        asynTable += "<td rowspan='2' class='txt-center'>" + value.OrderEnterDate.split("T")[0] + "</td>"; //입고일
                        asynTable += "<td rowspan='2' class='txt-center'>" + value.OrderCodeNo + "</td>"; //주문코드
                        asynTable += "<td rowspan='2' class='txt-center'><img src=" + src + " onerror='no_image(this, \"s\")' style='width:50px; height=50px'/></td>"; //이미지
                        asynTable += "<td rowspan='2' class='txt-center'>" + value.GoodsCode + "</td>"; //상품코드 
                        asynTable += "<td rowspan='2' style='text-align:left;  class='txt-center'>" + "[" + value.BrandName + "] " + value.GoodsFinalName + "<br /><span style='color:#368AFF; width:280px; word-wrap:break-word; display:block;'>" + value.GoodsOptionSummaryValues + "</span></td>"; //주문상품정보
                        asynTable += "<td class='txt-center'>" + value.GoodsModel + "</td>"; //모델명 
                        asynTable += "<td rowspan='2' class='txt-center'>" + numberWithCommas(value.GoodsSalePriceVat) + "원</td>"; //상품단가(vat 포함)
                        asynTable += "<td rowspan='2' class='txt-center'>" + value.Qty + "</td>"; //수량
                        asynTable += "<td rowspan='2' class='txt-center'>" + numberWithCommas(value.GoodsTotalSalePriceVat) + "원</td>"; //주문금액(vat 포함)
                        asynTable += "<td rowspan='2' class='txt-center'>" + value.OrderEndType_Name + "</td>"; //마감현황

                        var nextEndTag = '';
                        if (value.OrderNextEndYN === 'Y')
                            nextEndTag = "<input type='button' class='listBtn' value='이월사유' style='width:71px; height:22px; font-size:12px' onclick='return showNextReason(\"" + value.OrderNextEndReason + "\");' />";
                        else
                            nextEndTag = "해당 없음";

                        asynTable += "<td rowspan='2' style='text-align:center;'>" + nextEndTag + "</td></tr>";

                        asynTable += "<tr name='trColor'>"
                        asynTable += "<td class='txt-center'>" + value.GoodsUnit_Name + "</td></tr>";

                        i++;

                    });
                } else {
                    asynTable += "<tr><td colspan='12' class='txt-center'>" + "조회된 정보가 없습니다." + "</td></tr>"
                    $("#hdTotalCount_2").val(0);
                }
                $("#tblOrderBillDeadLinePop tbody").append(asynTable);
                fnCreatePagination('pagination_3', $("#hdTotalCount_2").val(), pageNum, pageSize, getPageData3);
            }

            var sUser = '<%=Svid_User %>';
            var param = {
                sUser: sUser,
                unumPayNo: UnumPayNo,
                PageNo: pageNum,
                PageSize: pageSize,
                Flag: 'ADMIN',
                Method: 'OrderBillListSchPop'
            };

            var beforeSend = function () { };
            var complete = function () { };

            JqueryAjax("Post", "../../Handler/PayHandler.ashx", true, false, param, "json", callback, beforeSend, complete, true, '<%=Svid_User%>');

            <%--JajaxSessionCheck('Post', '../../Handler/PayHandler.ashx', param, 'json', callback, '<%=Svid_User%>');--%>
        }

        function fnExcelDownload() {
            alert("추후 개발예정입니다.");
            return false;
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
                    정산내역조회(구매사)
                    <span class="span-title-subsentence"></span>
                </p>
            </div>
            <!--탭메뉴-->
            <div class="div-main-tab" style="width: 100%; ">
                <ul>
                    <li class='tabOff' style="width: 185px;" onclick="fnTabClickRedirect('OrderBillList');">
                        <a onclick="fnTabClickRedirect('OrderBillList');">마감 승인</a>
                     </li>
                    <li class='tabOn' style="width: 185px;" onclick="fnTabClickRedirect('OrderBillDeadLine');">
                         <a onclick="fnTabClickRedirect('OrderBillDeadLine');">마감 내역조회</a>
                    </li>
                    <li class='tabOff' style="width: 185px;" onclick="fnTabClickRedirect('OrderBillListsch');">
                        <a onclick="fnTabClickRedirect('OrderBillListsch');">대금결제 내역조회</a>
                    </li>
                </ul>
            </div>


            <!--상단 조회영역 시작-->
            <div class="search-div">
                <table id="tblSearchPart" class="tbl_main">
                     <colgroup>
                        <col style="width:130px;"/>
                        <col />
                        <col style="width:130px;"/>
                        <col />
                    </colgroup>
                    <tr>
                        <th class="txt-center">담당자별 검색</th>
                        <td>
                            <input type="text" id="txtSearchAdminId" class="medium-size" readonly="readonly" />&nbsp;
                            <input type="text" id="txtSearchAdminName" class="medium-size" readonly="readonly" />
                            <%--<img src="../Images/Order/search-bt-off.jpg" onmouseover="this.src='../Images/Order/search-bt-on.jpg'" onmouseout="this.src='../Images/Order/search-bt-off.jpg'" alt="검색" class="search-img" onclick="return fnSearchAdmUserIdPopup()" />--%>
                            <input type="button" class="mainbtn type1" value="검색" style="width:75px; height:25px;" onclick="return fnSearchAdmUserIdPopup();"/>
                        </td>
                        <th class="txt-center">회사 검색</th>
                        <td>
                            <input type="text" id="txtSearchCompCode" class="medium-size" readonly="readonly" />&nbsp;
                            <input type="text" id="txtSearchCompName" class="medium-size" readonly="readonly" />
                            <%--<img src="../Images/Order/search-bt-off.jpg" onmouseover="this.src='../Images/Order/search-bt-on.jpg'" onmouseout="this.src='../Images/Order/search-bt-off.jpg'" alt="검색" class="search-img" onclick="return fnSearchCompPopup()" />--%>
                            <input type="button" class="mainbtn type1" value="검색" style="width:75px; height:25px;" onclick="return fnSearchCompPopup();"/>
                        </td>
                    </tr>

                    <tr>
                        <th class="txt-center">월 별 조회</th>
                        <td>

                            <asp:TextBox ID="txtSearchSdate" runat="server" CssClass="calendar" Width="190px" ReadOnly="true" Onkeypress="return fnEnter();"></asp:TextBox>&nbsp;&nbsp;
                            -
                            &nbsp;&nbsp;<asp:TextBox ID="txtSearchEdate" runat="server" CssClass="calendar" Width="190px" ReadOnly="true" Onkeypress="return fnEnter();"></asp:TextBox>&nbsp;&nbsp;
                        </td>

                        <th>여신번호 조회</th>
                        <td>
                            <input type="text" name="txtLoanNo" id="txtLoanNo" class="medium-size"/>
                        </td>
                    </tr>
                </table>

            </div>
            <div class="bt-align-div">
                <input type="button" class="mainbtn type1" style="width:95px; height:30px;" value="조회하기" onclick="return fnSearch(1);"/>
                <%--<a>
                    <img alt="조회하기" src="../Images/search-off.jpg" id="btnSearch" onclick="fnSearch(1); return false;" onmouseover="this.src='../Images/search-on.jpg'" onmouseout="this.src='../Images/search-off.jpg'" />
                </a>--%>
                <%--                    <img alt="조회하기" src="../../Images/Goods/aslist.jpg" id="btnSearch" onclick="fnSearch(1); return false;" onmouseover="this.src='../Images/Wish/aslist-over.jpg'" onmouseout="this.src='../../Images/Goods/aslist.jpg'" /></a>--%>
            </div>


            <!--상단 조회영역 끝-->
            <br />
            <br />
            <br />


            <!--하단 리시트영역 시작-->
            <div class="list-div" style="width: 100%;">
                <%--<div>
                    <span style="font-weight: bold; margin-bottom: 5px; float: right">* 이월요청 : 건</span>
                </div>--%>
                <table id="tblSearch" class="tbl_main">
                    <thead>
                        <tr>
                            <th style="width: 35px;">선택<br /><input type="checkbox" /></th>
                            <th style="width: 85px;">마감일</th>
                            <th style="width: 105px;">회사코드/명</th>
                            <th style="width: 95px;">담당자</th>
                            <th style="width: 105px;">여신결제번호</th>
                            <th style="width: 105px;">주문건수</th>
                            <th style="width: 85px;">상품수</th>
                            <th style="width: 85px;">총 주문금액</th>
                            <th style="width: 90px;">상세보기</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td colspan="20" class="txt-center">리스트을 조회해 주시기 바랍니다.</td>
                        </tr>
                    </tbody>
                </table>
                <br />
                <input type="hidden" id="hdTotalCount" />
                <!-- 페이징 처리 -->
                <div style="margin: 0 auto; text-align: center">
                    <div id="pagination" class="page_curl" style="display: inline-block"></div>
                </div>

                <!--엑셀다운 버튼-->
                <div class="bt-align-div">
                    <input type="button" class="mainbtn type1" style="width: 95px; height: 30px;" value="엑셀다운" onclick="return fnExcelDownload();" />
                </div>
            </div>
            <!--하단 리스트 영역 끝 -->



            <%--마감이월사유 팝업 시작--%>

            <div id="CarryForwardDiv" class="popupdiv divpopup-layer-package">
                <div class="popupdivWrapper" style="width: 620px; margin: 100px auto; background-color: #ffffff;">
                    <div class="popupdivContents" style="background-color: #ffffff; padding: 15px;">

                        <div class="close-div">
                            <a onclick="fnClosePopup('CarryForwardDiv'); return false;" style="cursor: pointer">
                                <img src="../../Images/Wish/icon-delete.jpg" alt="닫기" style="float: right;" /></a>
                        </div>

                        <div class="popup-title" style="margin-top: 20px;">
                            <%--<img src="" alt="마감 이월 사유" />--%>
                            <h3 class="pop-title">마감 이월 사유</h3>
                            <br />
                            <br />
                            <br />

                            <div style="height: 150px">
                                <table class="board-table">
                                    <thead>
                                        <tr>
                                            <th>마감 이월 사유</th>
                                            <td style="padding-left: 1px">
                                                <textarea readonly="readonly" style="width: 100%; height: 100px; resize: none;"></textarea></td>
                                        </tr>
                                    </thead>
                                </table>
                            </div>
                        </div>

                        <!-- 팝업버튼 -->
                        <div style="margin-top: 20px; text-align: right">
                            <%--<img src="" alt="승인" />--%>
                            <%--<img src="" alt="거절" onclick="fnCancel()" />--%>
                            <input type="button" class="mainbtn type1" style="width:75px" value="승인" />
                            <input type="button" class="mainbtn type2" style="width:75px" value="거절" onclick="fnClosePopup('CarryForwardDiv'); return false;" />
                        </div>
                    </div>
                </div>
            </div>

            <%--상세보기 팝업 시작--%>
            <div id="DetailDiv" class="popupdiv divpopup-layer-package">
                <div class="popupdivWrapper" style="width: 1200px; height: 200px; margin: 150px auto; background-color: #ffffff;">
                    <div class="popupdivContents" style="background-color: #ffffff; height: 720px; padding: 15px;">

                        <div class="close-div">
                            <a onclick="fnClosePopup('DetailDiv'); return false;" style="cursor: pointer">
                                <img src="../../Images/Wish/icon-delete.jpg" alt="닫기" style="float: right;" /></a>
                        </div>

                        <div class="popup-title" style="margin-top: 20px;">
                            <h3 class="pop-title">주문 상품</h3>
                            <br />

                            <!-- 주문 상품 테이블 -->
                            <div>
                                <table class="board-table" id="tblOrderBillDeadLinePop">
                                    <thead>
                                        <tr>
                                            <th rowspan="2">번호</th>
                                            <th rowspan="2">입고일</th>
                                            <th rowspan="2">주문코드</th>
                                            <th rowspan="2">이미지</th>
                                            <th rowspan="2">상품코드</th>
                                            <th rowspan="2">주문상품정보</th>
                                            <th>모델명</th>
                                            <th rowspan="2">상품단가<br />
                                                (VAT포함)</th>
                                            <th rowspan="2">수량</th>
                                            <th rowspan="2">주문금액<br />
                                                (VAT포함)</th>
                                            <th rowspan="2">마감현황</th>
                                            <th rowspan="2">이월 사유 보기</th>
                                        </tr>
                                        <tr>
                                            <th>내용량</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <tr>
                                            <td colspan="12" class="txt-center">리스트가 없습니다!.</td>
                                        </tr>
                                    </tbody>
                                </table>
                            </div>
                            <br />
                        </div>

                        <div style="margin: 0 auto; text-align: center">
                            <input type="hidden" id="hdTotalCount_2" />
                            <div id="pagination_3" class="page_curl" style="display: inline-block"></div>
                        </div>

                        <!-- 팝업버튼 -->
                        <div style="margin-top: 20px; text-align: right">
                            <%--<img src="../Images/Goods/submit1-off.jpg" alt="확인" onmouseover="this.src='../Images/Goods/submit1-on.jpg'" onmouseout="this.src='../Images/Goods/submit1-off.jpg'" onclick="fnCancel()" />--%>
                            <input type="button" class="commonBtn" style="width:95px; height:30px; font-size:12px" value="닫기" onclick="return fnClosePopup('DetailDiv'); return false;"/>

                            <%--    <img src="../" alt="닫기" onclick="fnCancel()" />--%>
                        </div>
                    </div>
                </div>
            </div>
            <input type="hidden" id="hdTotalCount_3" />
            <input type="hidden" id="hd_UnumPayNo" name="hd_UnumPayNo" />


            <%-- 팝업 --%>
            <div id="admUserIdSearchDiv" class="popupdiv divpopup-layer-package">
                <div class="popupdivWrapper" style="width: 650px; height: 650px">
                    <div class="popupdivContents">

                        <div class="close-div">
                            <a onclick="fnClosePopup('admUserIdSearchDiv'); return false;" style="cursor: pointer">
                                <img src="../Images/icon-delete.jpg" alt="닫기" style="float: right;" /></a>
                        </div>
                        <div class="popup-title">
                            <h3 class="pop-title">검색조건 선택</h3>

                            <div class="search-div">
                                <select id="ddlPopSearch2">
                                    <option value="Name">이름</option>
                                    <option value="Id">아이디</option>
                                </select>
                                <input type="text" class="text-code" id="txtPopSearch2" placeholder="검색어를 입력해 주세요." onkeypress="return fnAdminPopupEnter();" style="width: 300px" />
                                <input type="button" value="검색" style="width:75px" class="mainbtn type1" onclick="fnAdmUserIdSearch(1); return false;">
                            </div>
                            <div class="divpopup-layer-conts">
                                <table id="tblPopupAdmUserId" class="tbl_main">
                                    <thead>
                                        <tr>
                                            <th>선택</th>
                                            <th>번호</th>
                                            <th>담당자 ID</th>
                                            <th>담당자명</th>
                                        </tr>
                                    </thead>
                                    <tbody id="pop_admUserIdTbody">
                                        <tr>
                                            <td colspan="4" class="text-center">리스트가 없습니다.</td>
                                        </tr>
                                    </tbody>
                                </table>
                                <!-- 페이징 처리 -->
                                <div style="margin: 0 auto; text-align: center; padding-top: 10px">
                                    <input type="hidden" id="hdTotalCount2" />
                                    <div id="pagination2" class="page_curl" style="display: inline-block"></div>
                                </div>
                            </div>

                            <div class="btn_center">
                                <input type="button" value="취소" style="width:75px" class="mainbtn type2" onclick="fnClosePopup('admUserIdSearchDiv'); return false;">
                                <input type="button" value="확인" style="width:75px" class="mainbtn type1" onclick="fnPopupOkAdmUserId(); return false;">     
                        </div>
                    </div>
                </div>
            </div>
            <%--우리안 관리 담당자 ID 팝업 끝--%>




            <%--회사 팝업 시작--%>
            <div id="compSearchDiv" class="popupdiv divpopup-layer-package">
                <div class="popupdivWrapper" style="width: 650px; height: 650px">
                    <div class="popupdivContents">

                        <div class="close-div">
                            <a onclick="fnClosePopup('compSearchDiv'); return false;" style="cursor: pointer">
                                <img src="../Images/icon-delete.jpg" alt="닫기" style="float: right;" /></a>
                        </div>
                        <div class="popup-title" style="margin-top: 20px;">
                            <h3 class="pop-title">검색조건 선택</h3>

                            <div class="search-div" style="margin-bottom: 20px;">
                                <select id="ddlCompPopSearch" class="selectCompManagement" style="height: 23px">
                                    <option value="NAME">회사명</option>
                                    <option value="CODE">회사코드</option>
                                </select>
                                <input type="text" class="text-code" id="txtCompPopSearch" placeholder="검색어를 입력해 주세요." onkeypress="return fnCompPopupEnter();" style="width: 300px" />
                                <a class="imgA" onclick="fnCompSearch(1); return false;">
                                    <img src="../Images/Popup/search-bt-off.jpg" onmouseover="this.src='../Images/Popup/search-bt-on.jpg'" onmouseout="this.src='../Images/Popup/search-bt-off.jpg'" alt="검색" class="search-img" /></a>
                            </div>


                            <div class="divpopup-layer-conts">
                                <table id="tblPopupComp" class="board-table" style="margin-top: 0; width: 100%">
                                    <thead>
                                        <tr>
                                            <th class="text-center" style="width: 10%">선택</th>
                                            <th class="text-center">회사코드</th>
                                            <th class="text-center">회사명</th>
                                            <th class="text-center">마감일</th>
                                        </tr>
                                    </thead>
                                    <tbody id="pop_CompTbody">
                                        <tr>
                                            <td colspan="4" class="text-center">리스트가 없습니다.</td>
                                        </tr>
                                    </tbody>
                                </table>
                                <!-- 페이징 처리 -->
                                <div style="margin: 0 auto; text-align: center; padding-top: 10px">
                                    <input type="hidden" id="hdCompTotalCount" />
                                    <div id="compPagination" class="page_curl" style="display: inline-block"></div>
                                </div>
                            </div>

                            <div style="text-align: right; margin-top: 30px;">
                                <a onclick="fnClosePopup('compSearchDiv'); return false;">
                                    <img src="../../Images/cancle_btn.jpg" alt="취소" onmouseover="this.src='../../Images/cancle_on_btn.jpg'" onmouseout="this.src='../../Images/cancle_btn.jpg'" /></a>
                                <a onclick="fnPopupOkComp(); return false;">
                                    <img src="../Images/Goods/submit1-off.jpg" alt="확인" onmouseover="this.src='../Images/Goods/submit1-on.jpg'" onmouseout="this.src='../Images/Goods/submit1-off.jpg'" /></a>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <%--회사  팝업 끝--%>



    <%-- 이월사유 --%>
    <div id="nextReasonDiv" class="popupdiv divpopup-layer-package">
        <div class="popupdivWrapper" style="width: 500px; height: 300px; margin: 150px auto; background-color: #ffffff;">
            <div class="popupdivContents" style="background-color: #ffffff; height: 200px; padding: 15px;">
                <div class="divpopup-layer-container">
                    <div class="sub-title-div">
                        <%--<img src="../Images/title-img.jpg" class="img-title" />이월사유           --%>
                        <h3 class="pop-title">이월사유</h3> 
                    </div>

                    <div class="divpopup-layer-conts">
                        <table id="tblModify" class="tbl_popup">
                            <tr>
                                <th style="width: 30%;">이월사유</th>
                                <td style="width: 70%;">
                                    <%--<asp:TextBox runat="server" id="txtPopDropReason" Rows="5" onkeypress="preventEnter(event)" TextMode="MultiLine" Width="100%"></asp:TextBox>--%>
                                    <textarea id="txtPopDropReason" rows="5" style="width: 100%; border: 1px solid #a2a2a2;" maxlength="1000" readonly="readonly"></textarea>
                                </td>

                            </tr>
                        </table>
                        <br />
                        <div style="text-align: right; margin-top: 30px;">
                            <a onclick="fnClosePopup('nextReasonDiv'); return false;">
                                <%--<img src="../Images/Goods/submit1-off.jpg" alt="확인" onmouseover="this.src='../Images/Goods/submit1-on.jpg'" onmouseout="this.src='../Images/Goods/submit1-off.jpg'" /></a>--%>
                                <input type="button" class="commonBtn" style="width:95px; height:30px; font-size:12px" value="닫기" onclick="return fnClosePopup('nextReasonDiv'); return false;"/>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <%-- 설정 팝업끝 --%>
</asp:Content>

