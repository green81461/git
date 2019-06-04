<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Master/AdminMasterPage.master" AutoEventWireup="true" CodeFile="OrderBillList.aspx.cs" Inherits="Admin_Order_OrderBillList" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <link href="../Content/Order/order.css" rel="stylesheet" />

    <script type="text/javascript">
        $(function () {
            ListCheckboxOnlyOne('tdSearchCb');
            ListCheckboxOnlyOne('tblPopupAdmUserId');
            ListCheckboxOnlyOne('tblPopupComp');
            fnCommDetailBind();
        });
        var is_sending = false;
        //마감현황조회 공통코드
        function fnCommDetailBind() {

            var callback = function (response) {
                var createHtml = '';

                if (!isEmpty(response)) {
                    for (var i = 0; i < response.length; i++) {

                        if (response[i].Map_Type != 0) {

                            createHtml += '<input type="checkbox" id="cbSearch' + i + '" value="' + response[i].Map_Type + '" />&nbsp;<label for="lblCbLabel' + i + '">' + response[i].Map_Name + '</label>&nbsp;&nbsp;&nbsp;&nbsp;'
                        }
                    }
                    $('#tdSearchCb').append(createHtml)

                } else {
                    alert("오류가 발생했습니다. 개발자에게 문의바랍니다.");
                }

                return false;
            }
            var param = {
                Method: 'GetCommList',
                Code: 'ORDER',
                Channel: 5
            };
            var beforeSend = function () {
            };

            var complete = function () {
            };

            //type, url, async, cache, data, datatype, _callback, _beforeSend, _complete, issessionCheck, sessionValue
            JqueryAjax('Post', '../../Handler/Common/CommHandler.ashx', true, false, param, 'json', callback, beforeSend, complete, true, '<%=Svid_User%>');
        }

        //우리안 관리 담당자 아이디 팝업
        function fnSearchAdmUserIdPopup() {

            fnAdmUserIdSearch(1);

            fnOpenDivLayerPopup('admUserIdSearchDiv');
            //var e = document.getElementById('admUserIdSearchDiv');

            //if (e.style.display == 'block') {
            //    e.style.display = 'none';

            //} else {
            //    $(".popupdivWrapper").css("height", "650px");

            //    e.style.display = 'block';
            //    $(".popupdivWrapper").draggable();
            //}
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

                        asynTable += "<tr>";
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

            var beforeSend = function () {
            };

            var complete = function () {
            };

            //type, url, async, cache, data, datatype, _callback, _beforeSend, _complete, issessionCheck, sessionValue
            JqueryAjax('Post', '../../Handler/Common/UserHandler.ashx', true, false, param, 'json', callback, beforeSend, complete, true, '<%=Svid_User%>');

        }

        //페이징 인덱스 클릭시 데이터 바인딩
        function getPageData2() {
            var container = $('#pagination2');
            var getPageNum = container.pagination('getSelectedPageNum');
            fnAdmUserIdSearch(getPageNum);
            return false;
        }

        //회사 팝업
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

                        asynTable += "<tr>";
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

            var beforeSend = function () {
            };

            var complete = function () {
            };

            //type, url, async, cache, data, datatype, _callback, _beforeSend, _complete, issessionCheck, sessionValue
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
            $("#deadlineList tbody").empty();
            $("#deadlineList tbody").append("<tr id='emptyRow'><td colspan='10' class='txt-center'>" + "조회된 주문내역이 없습니다." + "</td></tr>");

            $('#tdSearchCb input[type=checkbox]').each(function () {
                $(this).prop('checked', '');
            });
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

                    if (isEmpty(loanCalDue)) loanCalDue = 0;

                    var loanCalDueTxt = '';
                    switch (Number(loanCalDue)) {
                        case 0:
                            loanCalDueTxt = '당월';
                            break;
                        case 30:
                            loanCalDueTxt = '익월';
                            break;
                        case 60:
                            loanCalDueTxt = '익익월';
                            break;
                        case 90:
                            loanCalDueTxt = '익익월';
                            break;
                        case 120:
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


        function fnViewOrderNextReason(orderNo, reason) {
            $('#txtReason').val('');
            $('#hdPopupOrderNo').val('');
            $('#hdPopupReason').val('');

            fnOpenDivLayerPopup('CarryForwardDiv');
            //var e = document.getElementById('CarryForwardDiv');

            //if (e.style.display == 'block') {
            //    e.style.display = 'none';

            //} else {
            //    e.style.display = 'block';
            //    $(".popupdivWrapper").draggable();
            //}
            $('#hdPopupOrderNo').val(orderNo);
            $('#hdPopupReason').val(reason);
            $('#txtReason').val(reason);
            return false;
        }

        function showDetailPopup(el) {
            fnOpenDivLayerPopup('DetailDiv');
            //var e = document.getElementById('DetailDiv');

            //if (e.style.display == 'block') {
            //    e.style.display = 'none';

            //} else {
            //    e.style.display = 'block';
            //    $(".popupdivWrapper").draggable();
            //}
            return false;
        }

        //function fnCancel() {
        //    $('.popupdiv').fadeOut();
        //    return false;
        //}

        function fnSearch() {

            if ($('#txtSearchCompCode').val() == '') {
                alert('회사를 선택해 주세요.');
                return false;
            }

            var callback = function (response) {
                var asynTable = "";
                var index = 0;
                $("#deadlineList tbody").empty();
                if (!isEmpty(response)) {

                    $.each(response, function (key, value) {

                        if (index == 0) {
                            $('#spanRequestCnt').text(value.OrderNextEnd_CNT);
                        }
                        var endTypeHtml = '';
                        if (value.OrderEndType == '4') {
                            endTypeHtml = "<td rowspan='2' class='txt-center' id='tdOrderEndType'><input type='hidden' id='hdOrderEndType' name='hdOrderEndType' value='" + value.OrderEndType + "'/><input type='hidden' id='hdOrderNo' name='hdOrderNo' value='" + value.Unum_OrderNo + "'/><input type='button' class='listBtn' value='이월요청' style='width:71px; height:22px; font-size:12px' onclick='return fnViewOrderNextReason(\"" + value.Unum_OrderNo + "\",\"" + value.OrderNextEndReason + "\")'/></td>";
                        }
                        else {
                            var OrdEndTypeName = value.OrderEndType_Name;
                            if (value.OrderEndType == "0") {
                                OrdEndTypeName = "입고확인";
                            }
                            endTypeHtml = "<td rowspan='2' class='txt-center' id='tdOrderEndType'><input type='hidden' id='hdOrderEndType' name='hdOrderEndType' value='" + value.OrderEndType + "'/><input type='hidden' id='hdOrderNo' name='hdOrderNo' value='" + value.Unum_OrderNo + "'/>" + OrdEndTypeName + "</td>";
                        }
                        var goodsInfo = value.GoodsCode + "<br/>[" + value.BrandName + "]" + value.GoodsFinalName + "<br/><span style='color:#368AFF'>" + value.GoodsOptionSummaryValues + "</span>";
                        asynTable += "<tr name='trColor'>"
                        asynTable += "<td rowspan='2' class='txt-center'>" + value.RowNumber + "</td>";

                        var dlvrDate = value.DeliveryDate;
                        if (!isEmpty(dlvrDate)) {
                            dlvrDate = "<br>(" + fnOracleDateFormatConverter(dlvrDate) + ")";
                        }

                        asynTable += "<td rowspan='2' class='txt-center'>" + value.OrderEntryDate.split(' ')[0] + dlvrDate + "</td>";
                        asynTable += "<td rowspan='2' class='txt-center'>" + value.Company_Code + "</td>";
                        asynTable += "<td rowspan='2' class='txt-center'>" + value.AdminUserName + "</td>";
                        asynTable += "<td rowspan='2' class='txt-center'>" + value.OrderCodeNo + "</td>";
                        asynTable += "<td rowspan='2' >" + goodsInfo + "</td>";
                        asynTable += "<td rowspan='2'  class='txt-center'>" + value.GoodsModel + "</td>";
                        asynTable += "<td  class='txt-center'>" + value.GoodsUnitMoq + " / " + value.GoodsUnitName + "</td>";
                        asynTable += "<td style='text-align:right'>" + numberWithCommas(value.GoodsSalePriceVAT) + "원</td>";
                        asynTable += endTypeHtml;
                        asynTable += '</tr>';
                        asynTable += "<tr name='trColor'>"
                        asynTable += "<td  class='txt-center'>" + value.Qty + "</td>";
                        asynTable += "<td style='text-align:right'>" + numberWithCommas(value.GoodsTotalSalePriceVAT) + "원</td>";
                        asynTable += '</tr>';
                        index++;
                    });
                } else {
                    asynTable += "<tr id='emptyRow'><td colspan='10' class='txt-center'>" + "조회된 주문내역이 없습니다." + "</td></tr>"
                }
                $("#deadlineList tbody").append(asynTable);

            }


            var today = new Date();
            var yyyy = today.getFullYear();
            var mm = today.getMonth() + 1; //January is 0!


            if (mm < 10) {
                mm = '0' + mm
            }


            var startDateText = yyyy + '-' + mm + '-' + $('#hdLoanEndDate').val();
            var endDate = new Date(startDateText);
            endDate.setMonth(endDate.getMonth() - 1);
            endDate.setDate(endDate.getDate() + 1);

            $('#<%= hdEndDate.ClientID%>').val(startDateText);
            $('#<%= hdBuyComCode.ClientID%>').val($('#txtSearchCompCode').val());

            var endTypeVal = '0';
            $('#tdSearchCb input[type=checkbox]').each(function () {
                if ($(this).is(":checked")) {
                    endTypeVal = $(this).val();
                }
            });



            var param = {
                CompCode: $('#txtSearchCompCode').val(),
                OrderEndType: endTypeVal,
                TodateB: formatDate(endDate),
                TodateE: startDateText,
                Method: 'GetMonthDeadLineList_Admin'
            };

            var beforeSend = function () {
            };

            var complete = function () {
            };



            //type, url, async, cache, data, datatype, _callback, _beforeSend, _complete, issessionCheck, sessionValue
            JqueryAjax('Post', '../../Handler/OrderHandler.ashx', true, false, param, 'json', callback, beforeSend, complete, true, '<%=Svid_User%>');
        }

        function formatDate(date) {
            var d = new Date(date), month = '' + (d.getMonth() + 1), day = '' + d.getDate(), year = d.getFullYear();
            if (month.length < 2)
                month = '0' + month;
            if (day.length < 2) day = '0' + day;
            return [year, month, day].join('-');
        }
        function fnAdminPopupEnter() {
            if (event.keyCode == 13) {
                fnAdmUserIdSearch(1);
                return false;
            }
            else
                return true;
        }

        function fnCompPopupEnter() {
            if (event.keyCode == 13) {
                fnCompSearch(1);
                return false;
            }
            else
                return true;
        }

        function fnUpdateOrderEndReq(confirmType) {
            var confirmsg = '';
            if (confirmType == 'Y') {
                confirmsg = '승인하시겠습니까?';
            }
            else {
                confirmsg = '거절하시겠습니까?';
            }

            if (!confirm(confirmsg)) {
                return false;
            }

            var callback = function (response) {
                if (response == 'Success') {
                    fnSearch();
                }
                else {
                    alert('시스템 오류입니다. 시스템 관리자에게 문의하세요.');
                }
                fnClosePopup('CarryForwardDiv');
                return false;
            }

            var param = {
                SvidUser: '<%= Svid_User%>',
                Unum_OrderNo_Arr: $('#hdPopupOrderNo').val(),
                OrderNextEndReason: $('#hdPopupReason').val(),
                OrderNextEndConfirm: confirmType,
                P_Flag: 'NEXTREQ_3',
                Method: 'UpdateOrderNextEnd'
            };

            var beforeSend = function () {
                is_sending = true;
            }
            var complete = function () {
                is_sending = false;
            }

            if (is_sending) return false;

            //type, url, async, cache, data, datatype, _callback, _beforeSend, _complete, issessionCheck, sessionValue
            JqueryAjax('Post', '../../Handler/OrderHandler.ashx', true, false, param, 'text', callback, beforeSend, complete, true, '<%=Svid_User%>');
        }

        function fnMultiUpdateOrderEndReq() {
            var chkCnt = 0;
            $('#tdSearchCb input[type=checkbox]').each(function () {
                if ($(this).is(":checked")) {
                    chkCnt++;
                }
            });
            if (chkCnt > 0) {
                alert("마감 현황을 선택하고 조회하면 승인을 할 수 없습니다. \n선택을 해제하고 전체 조회를 합니다.\n 다시 마감승인 버튼을 클릭해주세요.");

                $('#tdSearchCb input[type=checkbox]').each(function () {
                    $(this).prop('checked', '');
                    fnSearch();
                });
                return false;
            }
            if ($('#deadlineList tbody tr').not('#emptyRow').length == 0) {
                alert("리스트를 조회해 주세요.");
                return false;
            }
            if (!confirm("정말로 승인하시겠습니까?")) {
                return false;
            }

            var callback = function (response) {
                if (response == "Success") {
                    alert("성공적으로 마감 승인이 완료되었습니다.");
                    fnSearch();
                }
                else {
                    alert("시스템 오류입니다. 시스템 관리자에게 문의하세요.");
                }
                return false;
            }
            var typeFlag = true;
            var seqArray = '';
            $('#deadlineList tbody tr').each(function () {
                if ($(this).children().find('#hdOrderEndType').val() == '4') {
                    alert("이월요청건이 존재합니다. 확인 후 다시 시도해 주세요.");
                    typeFlag = false;
                    return false;
                }
                else {
                    var ordEndType = $(this).children().find("#hdOrderEndType").val();
                    if ((ordEndType == '1') || (ordEndType == '2') || (ordEndType == '5') || (ordEndType == '6')) {
                        var orderSeq = $(this).children().find('#hdOrderNo').val();
                        seqArray += orderSeq + '/';
                    }
                }
            });

            if (seqArray == '') {
                alert('승인 대상건이 없습니다.');
                return false;
            }
            if (!typeFlag) {
                return false;
            }
            var param = {
                SvidUser: '<%= Svid_User%>',
                Unum_OrderNo_Arr: seqArray.slice(0, -1),
                CompCode: $("#txtSearchCompCode").val(),
                P_Flag: 'ENDREQ_2',
                Method: 'UpdateOrderEndReq'
            };

            var beforeSend = function () {
                is_sending = true;
            }
            var complete = function () {
                is_sending = false;
            }

            if (is_sending) return false;

            //type, url, async, cache, data, datatype, _callback, _beforeSend, _complete, issessionCheck, sessionValue
            JqueryAjax('Post', '../../Handler/OrderHandler.ashx', true, false, param, 'text', callback, beforeSend, complete, true, '<%=Svid_User%>');
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
                    <li class='tabOn' style="width: 185px;" onclick="fnTabClickRedirect('OrderBillList');">
                        <a onclick="fnTabClickRedirect('OrderBillList');">마감 승인</a>
                     </li>
                    <li class='tabOff' style="width: 185px;" onclick="fnTabClickRedirect('OrderBillDeadLine');">
                         <a onclick="fnTabClickRedirect('OrderBillDeadLine');">마감 내역조회</a>
                    </li>
                    <li class='tabOff' style="width: 185px;" onclick="fnTabClickRedirect('OrderBillListsch');">
                        <a onclick="fnTabClickRedirect('OrderBillListsch');">대금결제 내역조회</a>
                    </li>
                </ul>
            </div>


            <!--상단 조회영역 시작-->
            <div class="search-div">

                <table class="tbl_main">
                    <colgroup>
                        <col style="width:130px;"/>
                        <col />
                        <col style="width:130px;"/>
                        <col />
                    </colgroup>
                    <thead>
                        <tr>
                            <th colspan="4">정산내역조회</th>
                        </tr>
                    </thead>

                    <tr>
                        <th class="txt-center">담당자별 검색</th>
                        <td>
                            <input type="text" id="txtSearchAdminId" class="medium-size" readonly="readonly" />&nbsp;
                            <input type="text" id="txtSearchAdminName" class="medium-size" readonly="readonly" />
                            <input type="button" class="mainbtn type1" style="width: 75px;" value="검색" onclick="return fnSearchAdmUserIdPopup();" />
                            <%--<img src="../Images/Order/search-bt-off.jpg" onmouseover="this.src='../Images/Order/search-bt-on.jpg'" onmouseout="this.src='../Images/Order/search-bt-off.jpg'" alt="검색" class="search-img" onclick="return fnSearchAdmUserIdPopup()" />--%>
                        </td>
                        <th class="txt-center">회사 검색</th>
                        <td>
                            <input type="text" id="txtSearchCompCode" class="medium-size" readonly="readonly" />&nbsp;
                            <input type="text" id="txtSearchCompName" class="medium-size" width: 37%" readonly="readonly" />
                            <input type="button" class="mainbtn type1" style="width: 75px;" value="검색" onclick="return fnSearchCompPopup();" />
                            <%--<img src="../Images/Order/search-bt-off.jpg" onmouseover="this.src='../Images/Order/search-bt-on.jpg'" onmouseout="this.src='../Images/Order/search-bt-off.jpg'" alt="검색" class="search-img" onclick="return fnSearchCompPopup()" />--%>
                        </td>
                    </tr>

                    <tr>
                        <th>마감 현황 조회</th>
                        <td colspan="3" id="tdSearchCb"></td>
                    </tr>

                </table>

                <!--버튼-->
                <div class="bt-align-div">
                    <input type="button" class="mainbtn type1" style="width: 95px; height: 30px;" value="조회하기" onclick="return fnSearch();" />
                    <%--<a>
                        <img alt="조회하기" src="../Images/search-off.jpg" id="btnSearch" onclick="fnSearch(); return false;" onmouseover="this.src='../Images/search-on.jpg'" onmouseout="this.src='../Images/search-off.jpg'" /></a>--%>
                </div>
            </div>
            <!--상단 조회영역 끝-->
            <br />

            <table class="tbl_main">
                <colgroup>
                    <col style="width:15%"/>
                    <col style="width:20%"/>
                    <col style="width:15%"/>
                    <col style="width:20%"/>
                    <col style="width:15%"/>
                    <col style="width:20%"/>
                </colgroup>
                <tr>
                    <th class="txt-center">월 마감일</th>
                    <td><span id="loanEndDate"></span></td>
                    <th class="txt-center">세금계산서 발행일자 출력일</th>
                    <td><span id="loanBillDate"></span></td>
                    <th class="txt-center">결제일</th>
                    <td><span id="loanPayDate"></span></td>
                </tr>
            </table>
            <br />
            <div style="width: 100%; padding-bottom: 20px">
                <div style="display: inline-block;">
                    <span style="font-weight: bold; margin-bottom: 5px;">* 이월요청 : <span style="color: red" id="spanRequestCnt"></span>건</span>
                </div>

                <!--조회하기 버튼-->
                <div style="display: inline-block; float: right">
                    <asp:HiddenField runat="server" ID="hdEndDate"></asp:HiddenField>
                    <asp:HiddenField runat="server" ID="hdBuyComCode"></asp:HiddenField>

                    <%--<input type="button" class="commonBtn" style="width: 95px; height: 30px; font-size: 12px" value="엑셀다운" onclick="" />--%>
                    <asp:Button runat="server" ID="btnExcel" CssClass="mainbtn type1" Text="엑셀다운" Width="95px" Height="30px" OnClick="btnExcel_Click"/>
                    <input type="button" class="mainbtn type1" style="width: 95px; height: 30px;" value="마감승인" onclick="return fnMultiUpdateOrderEndReq();" />
                </div>
            </div>
                        <span style="color: #69686d; float: right;margin-top: 10px; margin-bottom: 10px;">*<b style="color: #ec2029; font-weight: bold;"> VAT(부가세)포함 가격</b>입니다.</span>

            <!--하단 리시트영역 시작-->
            <div class="list-div" style="width:100%; height: 700px; overflow-x: hidden; overflow-y: auto">
                <input type="hidden" id="hdLoanEndDate" />
                <table class="tbl_main" id="deadlineList">
                    <thead>
                        <tr>
                            <th rowspan="2" style="width: 35px;">번호</th>
                            <th rowspan="2" style="width: 105px;">입고일자<br />(배송일자)</th>
                            <th rowspan="2" style="width: 105px;">회사코드</th>
                            <th rowspan="2" style="width: 95px;">담당자</th>
                            <th rowspan="2" style="width: 105px;">주문번호</th>
                            <th rowspan="2" style="width: 300px;">주문상품정보</th>
                            <th rowspan="2" style="width: 100px;">모델명</th>
                            <th style="width: 100px;">최소수량 / 내용량</th>
                            <th style="width: 100px;">상품가격</th>

                            <th rowspan="2" style="width: 120px;">마감현황</th>
                        </tr>
                        <tr>
                            <th>주문수량</th>
                            <th>주문금액</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr id="emptyRow">
                            <td colspan="10" class="txt-center">리스트을 조회해 주시기 바랍니다.</td>
                        </tr>
                    </tbody>
                </table>
            </div>


            <!--하단 리스트 영역 끝 -->



            <%--마감이월사유 팝업 시작--%>

            <div id="CarryForwardDiv" class="popupdiv divpopup-layer-package">
                <div class="popupdivWrapper" style="width: 620px; height: 315px; margin: 100px auto; background-color: #ffffff;">
                    <div class="popupdivContents" style="background-color: #ffffff; padding: 15px;">

                        <div class="close-div">
                            <a onclick="fnClosePopup('CarryForwardDiv'); return false;" style="cursor: pointer">
                                <img src="../Images/icon-delete.jpg" alt="닫기" style="float: right;" /></a>
                        </div>

                        <div class="popup-title">
                            <h3 class="pop-title">마감 이월 사유</h3>
                            <br />
                            <div style="height: 150px">
                                <table class="board-table">
                                    <thead>
                                        <tr>
                                            <th style="width: 150px">마감 이월 사유</th>
                                            <td style="padding-left: 1px">
                                                <textarea style="width: 100%; height: 100px; resize: none;" id="txtReason"></textarea></td>
                                        </tr>
                                    </thead>
                                </table>
                            </div>
                        </div>

                        <!-- 팝업버튼 -->
                        <div style="margin-top: 10px; text-align: right">
                            <input type="hidden" id="hdPopupOrderNo" />
                            <input type="hidden" id="hdPopupReason" />
                            <input type="button" class="commonBtn" style="width: 95px; height: 30px; font-size: 12px" value="승인" onclick="return fnUpdateOrderEndReq('Y');" />
                            <input type="button" class="commonBtn" style="width: 95px; height: 30px; font-size: 12px" value="거절" onclick="return fnUpdateOrderEndReq('N');" />
                            <input type="button" class="commonBtn" style="width: 95px; height: 30px; font-size: 12px" value="닫기" onclick="fnClosePopup('CarryForwardDiv'); return false;" />
                        </div>
                    </div>
                </div>
            </div>

            <%--상세보기 팝업 시작--%>

            <div id="DetailDiv" class="popupdiv divpopup-layer-package">
                <div class="popupdivWrapper" style="width: 1200px; margin: 150px auto; background-color: #ffffff;">
                    <div class="popupdivContents" style="background-color: #ffffff; height: 700px; padding: 15px;">

                        <div class="close-div">
                            <a onclick="fnClosePopup('DetailDiv'); return false;" style="cursor: pointer">
                                <img src="../../Images/Wish/icon-delete.jpg" alt="닫기" style="float: right;" /></a>
                        </div>

                        <div class="popup-title">
                            <%--<img src="" alt="주문 상품 정보 상세보기" />--%>
                            <h3 class="pop-title">주문 상품 정보 상세보기</h3>
                            <br />
                            <br />

                            <!-- 주문 상품 테이블 -->
                            <div style="height: 300px">
                                <table class="board-table">
                                    <thead>
                                        <tr>
                                            <th rowspan="2">판매사</th>
                                            <th rowspan="2">이미지</th>
                                            <th rowspan="2">상품코드</th>
                                            <th rowspan="2">주문상품정보</th>
                                            <th>모델명</th>
                                            <th rowspan="2">상품가격<br />
                                                (VAT포함)</th>
                                            <th rowspan="2">수량</th>
                                            <th rowspan="2">주문금액<br />
                                                (VAT포함)</th>
                                            <th>입고확정일</th>
                                            <th rowspan="2">마감현황</th>
                                        </tr>
                                        <tr>
                                            <th>내용량</th>
                                            <th>입고현황</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <tr>
                                            <td colspan="11" class="txt-center">리스트가 없습니다.</td>
                                        </tr>
                                    </tbody>
                                </table>
                            </div>
                            <br />
                            <br />




                            <!-- 주문 정보 테이블 -->
                            <table class="board-table">
                                <colgroup>
                                    <col style="width: 20%" />
                                    <col style="width: 30%" />
                                    <col style="width: 20%" />
                                    <col style="width: 30%" />
                                </colgroup>
                                <thead>
                                    <tr>
                                        <th colspan="4">주문정보</th>
                                    </tr>
                                    <tr>
                                        <th>결제방식</th>
                                        <td></td>
                                        <th>총 구매금액</th>
                                        <td>원</td>
                                    </tr>
                                    <tr>
                                        <th>주문 상품수</th>
                                        <td>개</td>
                                        <th>배송비</th>
                                        <td>원</td>
                                    </tr>
                                    <tr>
                                        <th>마감</th>
                                        <td>개</td>
                                        <th>특수 배송비</th>
                                        <td>원</td>
                                    </tr>
                                    <tr>
                                        <th>마감이월</th>
                                        <td>개</td>
                                        <th>결제금액</th>
                                        <td>원</td>
                                    </tr>
                                </thead>
                                <tbody>
                                </tbody>
                            </table>
                        </div>

                        <!-- 팝업버튼 -->
                        <div style="margin-top: 20px; text-align: right">
                            <%--<img src="" alt="닫기" onclick="fnCancel()" />--%>
                            <input type="button" class="mainbtn type1" style="width:75px" value="닫기" onclick="fnClosePopup('DetailDiv'); return false;" />
                        </div>
                    </div>
                </div>
            </div>



        </div>
    </div>

    <%--우리안 관리 담당자 ID 팝업 시작--%>
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
                        <table id="tblPopupAdmUserId" class="tbl_main" style="margin-top: 0; width: 100%">
                            <thead>
                                <tr>
                                    <th class="text-center" style="width: 10%">선택</th>
                                    <th class="text-center">번호</th>
                                    <th class="text-center">담당자 ID</th>
                                    <th class="text-center">담당자명</th>
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
                <div class="popup-title">
                    <h3 class="pop-title">검색조건 선택 </h3>

                    <div class="search-div">
                        <select id="ddlCompPopSearch">
                            <option value="NAME">회사명</option>
                            <option value="CODE">회사코드</option>
                        </select>
                        <input type="text" class="text-code" id="txtCompPopSearch" placeholder="검색어를 입력해 주세요." onkeypress="return fnCompPopupEnter();" style="width: 300px" />
                        <input type="button" value="검색" style="width:75px" class="mainbtn type1" onclick="fnCompSearch(1); return false;">
                    </div>


                    <div class="divpopup-layer-conts">
                        <table id="tblPopupComp" class="tbl_main">
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
                    <div class="btn_center">
                        <input type="button" value="취소" style="width:75px" class="mainbtn type2" onclick="fnClosePopup('compSearchDiv'); return false;"> 
                        <input type="button" value="확인" style="width:75px" class="mainbtn type1" onclick="fnPopupOkComp(); return false;"> 
                    </div>
                </div>
            </div>
        </div>
    </div>
    <%--회사  팝업 끝--%>
</asp:Content>

