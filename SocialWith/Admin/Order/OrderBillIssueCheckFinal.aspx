<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Master/AdminMasterPage.master" AutoEventWireup="true" CodeFile="OrderBillIssueCheckFinal.aspx.cs" Inherits="Admin_Order_OrderBillIssueCheckFinal" %>

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
                    buttonImage: "../../Images/Goods/calendar.jpg",
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
                    buttonImage: "../../Images/Goods/calendar.jpg",
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

            $("#btnSearch").on("click", function () {
                fnOpenDivLayerPopup('companyListDiv');
                fnCompPopList(1);

            });

            $("#btnPopSearch").on("click", function () {
                fnCompPopList(1);
            });


            $("#tblcompList").on("click", "tr", function (e) {
                $('tr').removeClass('gray');
                var tr = $(this);

                if (tr.hasClass('compList')) {
                    tr.addClass('gray');
                }
            });
        });

        function fnEnter() {
            if (event.keyCode == 13) {
                fnCompPopList(1);
                return false;
            }

        }
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

        function fnCompPopList(pageNo) {
            var pageSize = 15;

            var gubun = $('input[name="division"]:checked').attr("data-gubun");
            var callback = function (response) {
                $("#tblcompList").empty();
                if (!isEmpty(response)) {

                    var list = "";

                    $.each(response, function (key, value) {

                        $('#hdCompTotalCount').val(value.TotalCount);
                        list += '<tr class="compList"  ondblclick="dbClick()">'
                        list += '<td class="txt-center compCode">' + value.Company_Code + '</td>'
                        list += '<td class="txt-center compName">' + value.Company_Name + '</td>'
                        list += '</tr>'


                    });//each() end

                    $("#tblcompList").append(list);
                    fnCreatePagination('compPopPagination', $("#hdCompTotalCount").val(), pageNo, pageSize, getPopListPageData);
                    $('#tblcompList').children().css('cursor', 'pointer');

                } else {
                    list += "<tr>"
                    list += "<td class='txt-center' colspan='2' >조회된 데이터가 없습니다.</td>"
                    list += "</tr>"
                    $("#tblcompList").append(list);

                } //if~else end

                return false;

            }

            var param = {
                SearchKeyword: $("#txtPopSearchComp").val(),
                Gubun: gubun,
                PageNo: pageNo,
                PageSize: pageSize,
                Flag: 'GetSearchCompanyList'
            };

            var beforeSend = function () {
                $('#divLoading').css('display', '');
            }
            var complete = function () {
                $('#divLoading').css('display', 'none');
            }

            JqueryAjax('Post', '../../Handler/Admin/CompanyHandler.ashx', true, false, param, 'json', callback, beforeSend, complete, true, '<%=Svid_User%>');

        }

        //팝업페이지
        function getPopListPageData() {
            var container = $('#compPopPagination');
            var getPageNum = container.pagination('getSelectedPageNum');
            fnCompPopList(getPageNum);
            return false;
        }

        function dbClick() {
            fnConfirm();
        }

        function fnConfirm() {
            var tr = $('.gray');
            var compName = tr.children('.compName').text();
            var gubun = $('input[name="division"]:checked').attr("data-gubun");
            if (compName != "") {
                $("#txtSaleCompName").val(compName);
                $("#hdGubunCode").val(gubun);

                fnClosePopup('companyListDiv');
            } else {
                alert("회사를 선택해주세요.");
            }
        }

        //조회하기
        function fnBillList(pageNo) {
            var pageSize = 20;
            var compName = $("#txtSaleCompName").val();
            var gubun = $("#hdGubunCode").val();
            var startDate = $("#txtSearchSdate").val();
            var endDate = $("#txtSearchEdate").val();


            var callback = function (response) {
                if (!isEmpty(response)) {

                    var list = "";

                    $.each(response, function (key, value) {

                        $('#hdTotalCount').val(value.TotalCount);

                        list += '<tr>';
                        list += '<td class="text-center" rowspan="2">' + value.RowNumber + '</td>';
                        list += '<td class="text-center" >' + value.EntryDate + '</td>';
                        list += '<td class="text-center" rowspan="2">테스트' + (gubun == "SU") ? value.Company_Name : ""; + '</td>';
                        list += '<td class="text-center" rowspan="2">RMP 테스트' + value.RMPCompName + '</td>';
                        list += '<td class="text-center" rowspan="2">' + value.OBJ + '</td>'; //세금계산서 발행정보
                        list += '<td class="text-center" rowspan="3">20000' + (gubun == "SU") ? numberWithCommas(value.Amt) + "원" : "" + '</td>'; //분기처리 
                        list += '<td class="text-center" rowspan="3">20000' + (gubun == "IU") ? numberWithCommas(value.Amt) + "원" : "" + '</td>';
                        list += '<td class="text-center">세금계산서 번호 테스트' + (value.TAXYN == "Y") ? value.SbillSeq : "" + '</td>';
                        list += '<td class="text-center">면세 번호 테스트' + (value.TAXYN == "N") ? value.SbillSeq : "" + '</td>';
                        list += '</tr>';
                        list += '<tr>';
                        list += '<td class="text-center">11111' + value.OrderCodeNo + '</td>';
                        list += '<td class="text-center"><button class="mainbtn type1">바로가기</button><input type="hidden" value="' + (value.TAXYN == "Y") ? value.MD5 : "" + '" /></td>';
                        list += '<td class="text-center"><button class="mainbtn type1">바로가기</button><input type="hidden" value="' + (value.TAXYN == "N") ? value.MD5 : "" + '" /></td>'; //분기처리 
                        list += '</tr>';


                    });//each() end


                    $("#tbodyList").empty().append(list);
                    fnCreatePagination('pagination', $("#hdTotalCount").val(), pageNo, pageSize, getBillPageData);
                    $('#tbodyList').children().css('cursor', 'pointer');

                } else {

                    if (compName == "") {
                        alert("RMP명이나 회사명을 검색해주세요.");
                    } else {

                        list += "<tr>"
                        list += "<td class='txt-center' colspan='13' >조회된 데이터가 없습니다.</td>"
                        list += "</tr>"
                        $("#tbodyList").empty().append(list);
                    }


                } //if~else end

                return false;

            }

            var param = {
                StartDate: startDate,
                EndDate: endDate,
                Gubun: gubun,
                CompName: compName,
                PageNo: pageNo,
                PageSize: pageSize,
                Method: 'GetAdminBillStatus_A'
            };

            var beforeSend = function () {
                $('#divLoading').css('display', '');
            }
            var complete = function () {
                $('#divLoading').css('display', 'none');
            }


            JqueryAjax('Post', '../../Handler/PayHandler.ashx', true, false, param, 'json', callback, beforeSend, complete, true, '<%=Svid_User%>');
        }

        function getBillPageData() {
            var container = $('#pagination');
            var getPageNum = container.pagination('getSelectedPageNum');
            fnBillList(getPageNum);
            return false;
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
        <div class="div-main-tab" style="width: 100%;">
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
                <span class="subTabOn" style="width: 186px; height: 35px; cursor: pointer;" id="btnTab1" onclick="fnGoPage('FINAL')">최종 현황</span>
                <span class="subTabOff" style="width: 186px; height: 35px; cursor: pointer;" id="btnTab2" onclick="fnGoPage('ISSUE')">이슈 현황</span>
            </div>
        </div>
        <!--상단영역 시작-->
        <div class="search-div">
            <table id="tblSearch" class="tbl_main">
                <colgroup>
                    <col style="width: 200px" />
                    <col />
                    <col style="width: 200px" />
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
                            &nbsp;&nbsp;
                        <input type="text" id="txtSearchEdate" class="calendar" maxlength="10" placeholder="2018-01-01">
                    </td>
                    <th>
                        <label for="RMP">RMP</label>
                        <input type="radio" id="selRMP" data-gubun="IU" name="division" value="RMP" checked>
                        &nbsp&nbsp<label for="판매사">판매사</label>
                        <input type="radio" data-gubun="SU" id="selSale" name="division" value="판매사"></th>
                    <td>
                        <%--<asp:TextBox ID="txtSaleCompName" runat="server" OnKeypress="return fnEnter();" CssClass="medium-size"></asp:TextBox>--%>
                        <input type="text" id="txtSaleCompName" class="medium-size" placeholder="검색 버튼을 눌러주세요" readonly />
                        <input type="hidden" id="hdGubunCode" />
                        <input class="mainbtn type1" id="btnSearch" style="width: 75px" type="button" value="검색">
                    </td>
                </tr>

            </table>
        </div>
        <!--엑셀 저장-->
        <div class="bt-align-div">
            <input type="hidden" id="hdUnumPayNoArr" />
            <%--<asp:Button ID="btnExcelExport" runat="server" Width="95" Text="조회하기" CssClass="mainbtn type1" />--%>
            <input type="button" id="btnBillList" style="width: 95px;" class="mainbtn type1" value="조회하기" onclick="fnBillList(1); return false;" />
        </div>

        <!--하단영역시작-->
        <div class="orderList-div" style="width: 100%;">
            <table id="tblProfitList" class="tbl_main">
                <colgroup>
                    <col style="width: 80px;" />
                    <col style="width: 150px;" />
                    <col style="width: 150px;" />
                    <col style="width: 150px;" />
                    <col style="width: 200px;" />
                    <col style="width: 200px;" />
                    <col style="width: 200px;" />
                    <col />
                    <col />
                </colgroup>
                <thead>
                    <tr>
                        <th class="text-center" rowspan="2">번호</th>
                        <th class="text-center">세금계산서 발행일자</th>
                        <th class="text-center" rowspan="2">판매사</th>
                        <th class="text-center" rowspan="2">RMP</th>
                        <th class="text-center" rowspan="2">세금계산서 발행정보</th>
                        <th class="text-center" rowspan="2">판매사<br>
                            세금계산서<br>
                            합계 발행금액</th>
                        <th class="text-center" rowspan="2">RMP<br>
                            세금계산서<br>
                            합계 발행금액</th>
                        <th class="text-center">세금계산서번호</th>
                        <th class="text-center">[면세]<br>
                            계산서번호</th>
                    </tr>
                    <tr>
                        <th>세금계산서 발행번호</th>
                        <th>세금계산서상세</th>
                        <th>[면세]<br>
                            세금계산서상세</th>
                    </tr>
                </thead>
                <tbody id="tbodyList">
                    <tr>
                        <td class="text-center" colspan="13">RMP명이나 회사명을 검색해주세요.</td>
                    </tr>
                </tbody>
            </table>
            <br />
            <!-- 페이징 처리 -->
            <input type="hidden" id="hdTotalCount" />
            <div style="margin: 0 auto; text-align: center">
                <div id="pagination" class="page_curl" style="display: inline-block"></div>
            </div>
            <!--하단영역끝-->
            <div class="bt-align-div">
                <input class="mainbtn type1" type="button" value="엑셀 저장" />
                <input class="mainbtn type1" type="button" value="내역상세 엑셀" />
            </div>
        </div>

    </div>

    <div id="companyListDiv" class="popupdiv divpopup-layer-package">
        <div class="popupdivWrapper" style="border: none; width: 550px; height: 310px">
            <div class="popupdivContents">

                <div class="close-div">
                    <a onclick="fnClosePopup('companyListDiv'); return false;" style="cursor: pointer">
                        <img src="../../Images/Wish/icon-delete.jpg" alt="닫기" style="float: right;" /></a>
                </div>

                <div class="popup-title">
                    <h3 class="pop-title">회사조회</h3>

                </div>

                <div class="search-div" style="margin-bottom: 20px;">

                    <input type="text" class="" id="txtPopSearchComp" onkeypress="return fnEnter();" style="width: 400px; height: 26px" />
                    <input type="button" id="btnPopSearch" class="mainbtn type1" style="width: 75px; height: 25px; font-size: 12px" value="검색" />
                </div>

                <div class="divpopup-layer-conts">
                    <table class="tbl_main tbl_pop">
                        <thead>
                            <tr>
                                <th>회사코드</th>
                                <th>회사명</th>
                            </tr>
                        </thead>
                        <tbody id="tblcompList">
                            <tr>
                                <td>CC000032</td>
                                <td>무한상사 사회적협동조합</td>
                            </tr>
                        </tbody>

                    </table>

                    <!-- 페이징 처리 -->
                    <div style="margin: 0 auto; text-align: center; padding-top: 10px">
                        <input type="hidden" id="hdCompTotalCount" />
                        <div id="compPopPagination" class="page_curl" style="display: inline-block"></div>
                    </div>

                    <div class="btn_center">
                        <input type="button" class="mainbtn type1" style="width: 95px; height: 30px; font-size: 12px" value="확인" onclick="fnConfirm(); return false;" />
                    </div>
                </div>
            </div>
        </div>
    </div>


</asp:Content>

