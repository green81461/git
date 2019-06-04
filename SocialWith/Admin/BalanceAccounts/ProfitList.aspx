<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Master/AdminMasterPage.master" AutoEventWireup="true" CodeFile="ProfitList.aspx.cs" Inherits="Admin_BalanceAccounts_ProfitList" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <link href="../Content/Order/order.css" rel="stylesheet" />
    <%--<script type="text/javascript" src="../../Scripts/jquery.mtz.monthpicker.js"></script>--%>
    <script type="text/javascript" src="../../Scripts/jquery.ui.monthpicker.js"></script>
    <script src="../../Scripts/jquery.fileDownload.js"></script>
    <script type="text/javascript">

        $(function () {

            fnPaywayBind();

            //달력
            /* MonthPicker 옵션 */
            //options = {
            //    pattern: 'yyyy-mm', // Default is 'mm/yyyy' and separator char is not mandatory
            //    selectedYear: 2019,
            //    startYear: 2015,
            //    finalYear: 2025,
            //    monthNames: ['1월', '2월', '3월', '4월', '5월', '6월', '7월', '8월', '9월', '10월', '11월', '12월']
            //};

            ///* MonthPicker Set */
            //$('#txtdate').monthpicker(options);

            ///* 버튼 클릭시 MonthPicker Show */
            //$('#txtdate-button').bind('click', function () {
            //    $('#txtdate').monthpicker('show');
            //});

            $("#txtdate").monthpicker({
                monthNames: ['1월(JAN)', '2월(FEB)', '3월(MAR)', '4월(APR)', '5월(MAY)', '6월(JUN)',
                    '7월(JUL)', '8월(AUG)', '9월(SEP)', '10월(OCT)', '11월(NOV)', '12월(DEC)'],
                monthNamesShort: ['1월', '2월', '3월', '4월', '5월', '6월', '7월', '8월', '9월', '10월', '11월', '12월'],
                showOn: "button",
                buttonImage: "../../Images/Goods/calendar.jpg",
                buttonImageOnly: true,
                changeYear: false,
                yearRange: 'c-2:c+2',
                dateFormat: 'yy-mm'
            });

            $("#txtdate").attr('placeholder', $.datepicker.formatDate('yy-mm', new Date()));


            // 팝업창에서 클릭시 변경 이벤트
            $("#profitLinkPopup_Tbody").on("mouseover", "tr", function () {
                $("#profitLinkPopup_Tbody tr").css("cursor", "pointer");
            });

            $("#profitLinkPopup_Tbody").on("click", "tr", function () {

                //초기화
                $("#hdSelectCode").val('');
                $("#hdSelectName").val('');
                $("#profitLinkPopup_Tbody tr").css("background-color", "");

                $(this).css("background-color", "#ffe6cc");

                var selectCode = $(this).find("#Comp_Code").text();
                var selectName = $(this).find("#Comp_Name").text();
                $("#hdSelectCode").val(selectCode);
                $("#hdSelectName").val(selectName);
            });

            // 검색창에서 검색 후 엔터키 클릭시 이벤트
            $('#txtSaleCompNamePopup').on({
                keydown: function (e) {
                    if (e.keyCode == 13) {
                        // fnCompanyLinkGubunListPopUp(1);
                        fnProfitListPopUpSearch(1);
                        return false;
                    }
                    else
                        return true;
                }
            });
        });

        // 구분값 넘기기
        function fnRadioChecked() {
            var value = $('input[name="division"]:checked').val();
            if (value == 'RMP') {
                return 'IU';
            } else {
                return 'SU';
            }
        }

        // 팝업 열기
        function fnProfitListPopUp(pageNo) {

            $("#hdSelectCode").val('');
            $("#hdSelectName").val('');

            var asynTable = '';
            var pageSize = 20;
            // var keyword = '';
            var gubun = fnRadioChecked();

            var callback = function (response) {

                if (!isEmpty(response)) {

                    $.each(response, function (index, value) {
                        asynTable += "<tr>";
                        asynTable += "<td id='Comp_Code' class='txt-center'>" + value.Company_Code + "</td>";
                        asynTable += "<td id='Comp_Name' class='txt-center'>" + value.Company_Name + "</td></tr>";
                        $('#hdTotalCountPopup').val(value.TotalCount);
                    });

                } else {
                    asynTable += "<tr><td colspan='2' class='text-center'>" + "검색결과가 없습니다." + "</td></tr>";
                    $('#hdTotalCountPopup').val(0);
                }

                $('#profitLinkPopup_Tbody').empty().append(asynTable);

                // 페이징 만들어주는 함수
                fnCreatePagination('paginationPopup', $("#hdTotalCountPopup").val(), pageNo, pageSize, getPageData);

                fnOpenDivLayerPopup('profitListdiv');
            };

            var param = {
                SearchKeyword: '',
                Gubun: gubun,
                PageNo: pageNo,
                PageSize: pageSize,
                Flag: "GetSearchCompanyList"
            };

            var beforeSend = function () {
                $('#divLoading').css('display', '');
            }
            var complete = function () {
                $('#divLoading').css('display', 'none');
            }

            JqueryAjax('Post', "../../Handler/Admin/CompanyHandler.ashx", false, false, param, 'json', callback, beforeSend, complete, true, '<%=Svid_User %>');
        }

        // 팝업창 검색버튼 클릭시
        function fnProfitListPopUpSearch(pageNum) {

            var asynTable = '';
            var pageSize = 20;
            var keyword = $('#txtSaleCompNamePopup').val();
            var gubun = fnRadioChecked();

            var callback = function (response) {

                if (!isEmpty(response)) {

                    $.each(response, function (index, value) {
                        asynTable += "<tr>";
                        asynTable += "<td id='Comp_Code' class='txt-center'>" + value.Company_Code + "</td>";
                        asynTable += "<td id='Comp_Name' class='txt-center'>" + value.Company_Name + "</td></tr>";
                        $('#hdTotalCountPopup').val(value.TotalCount);
                    });

                } else {
                    asynTable += "<tr><td colspan='2' class='text-center'>" + "검색결과가 없습니다." + "</td></tr>";
                    $('#hdTotalCountPopup').val(0);
                }

                $('#profitLinkPopup_Tbody').empty().append(asynTable);

                // 페이징 만들어주는 함수
                fnCreatePagination('paginationPopup', $("#hdTotalCountPopup").val(), pageNum, pageSize, getPageData);

                // fnOpenDivLayerPopup('profitListdiv');
            };

            var param = {
                SearchKeyword: keyword.trim(),
                Gubun: gubun,
                PageNo: pageNum,
                PageSize: pageSize,
                Flag: "GetSearchCompanyList"
            };

            JqueryAjax('Post', "../../Handler/Admin/CompanyHandler.ashx", false, false, param, 'json', callback, null, null, true, '<%=Svid_User %>');
        }

        //팝업창 확인버튼
        function fnPopupOk() {
            var selectCode = $("#hdSelectCode").val();
            var selectName = $("#hdSelectName").val();

            if (selectCode == '' || selectName == '') {
                alert('회사를 선택해주세요.');
                return false;
            } else {
                $('#txtSaleCompName').val(selectCode);
                fnClosePopup('profitListdiv');
                return false;
            }
        }

        // 결제수단 바인딩
        function fnPaywayBind() {

            var callback = function (response) {
                for (var i = 0; i < response.length; i++) {

                    var createHtml = '';

                    if (response[i].Map_Type != 0) {
                        createHtml = '<option value="' + response[i].Map_Type + '">' + response[i].Map_Name + '</option>';
                        $('#ddlSelectPayway').append(createHtml);
                    }
                }
                return false;
            }
            var param = {
                Method: 'GetCommList',
                Code: 'PAY',
                Channel: 3
            };
                // JajaxSessionCheck('Post', '../../Handler/Common/CommHandler.ashx', param, 'json', callback, '<%=Svid_User%>');
            JqueryAjax('Post', "../../Handler/Common/CommHandler.ashx", false, false, param, 'json', callback, null, null, true, '<%=Svid_User %>');
        }

        // 리스트 조회
        function fnProfitListSet(pageNo) {

            fnSearchEmpty();

            var asynTable = "";
            var month = $('#txtdate').val().replace('-', '');
            var gubun = fnRadioChecked();
            var compCode = $('#txtSaleCompName').val();
            var buyerCompany_Name = $('#txtBuyerCompName').val();
            var payWay = $('#ddlSelectPayway').val();
            var pageSize = 20;

            var callback = function (response) {

                if (!isEmpty(response)) {

                    $.each(response, function (index, value) {

                        asynTable += "<tr>";
                        asynTable += "<td class='txt-center' rowspan='2' id='tableIndex'>" + value.RowNumber + "</td>";
                        asynTable += "<td class='txt-center'>" + fnOracleDateFormatConverter(value.EntryDate) + "</td>"; // 주문일자
                        asynTable += "<td class='txt-center'>" + value.Company_Name + "<br />(" + fnOracleDateFormatConverter(value.PayCashDate) + ")</td>"; // 구매사(입금날짜)
                        asynTable += "<td class='txt-center' rowspan='2'>" + value.OrderSaleCompany_Name + "</td>"; // 판매사
                        asynTable += "<td class='txt-center' rowspan='2'>" + value.RMPCompanyName + "</td>"; // RMP
                        asynTable += "<td class='txt-left' rowspan='2'>" + value.GoodsCode + "<br />[" + value.BrandName + "]" + value.GoodsFinalName + "<br /><span style='color:#368AFF; width:280px; word-wrap:break-word; display:block;'>" + value.GoodsOptionSummaryValues + "</span></td>"; // 주문상품정보(상품코드/[브랜드명]상품명/상품옵션요약명)
                        asynTable += "<td class='txt-center' rowspan='2'>" + value.GoodsModel + "</td>" // 모델명
                        asynTable += "<td class='txt-center' rowspan='2'>" + numberWithCommas(value.GoodsSalePriceVat) + "원<br />(" + value.PayWayName + ")</td>"; // 구매사 매출금액 (결제수단)
                        asynTable += "<td class='txt-center' rowspan='2'>" + numberWithCommas(fnCustFormula(value.IsRMP, value.GoodsSalePriceVat, value.GoodsBuyPriceVat, value.RMPPriceP, 100 - value.SwpPriceP, value.GoodsCustPriceVat)) + "</td>"; // 판매사 매출금액
                        asynTable += "<td class='txt-center' rowspan='2'>" + numberWithCommas(fnRMPFormula(value.IsRMP, value.GoodsSalePriceVat, value.GoodsBuyPriceVat, 100 - value.SwpPriceP)) + "</td>"; // RMP 매출금액
                        asynTable += "<td class='txt-center' rowspan='2'>" + numberWithCommas(value.GoodsBuyPriceVat) + "원</td>"; // 매입 매출금액
                        asynTable += "<td class='txt-center' rowspan='2'>" + value.SupplyJung + "원</td>"; // 플랫폼 이용수수료
                        asynTable += "</tr>";

                        asynTable += "<tr>";
                        asynTable += "<td class='txt-center'>" + value.OrderCodeNo + "</td>"; // 주문번호
                        asynTable += "<td class='txt-center'><strong>" + value.Name + "</strong><br />-" + value.Id + "-</td>"; // 주문자 -아이디-   
                        asynTable += "</tr>";
                        $('#hdTotalCount').val(value.TotalCount);
                    });

                } else {
                    asynTable += "<tr><td colspan='12' class='text-center'>" + "조회된 리스트가 없습니다." + "</td></tr>";
                    $('#hdTotalCount').val(0);
                }

                $("#tbProfitList tbody").empty().append(asynTable);

                fnCreatePagination('pagination', $("#hdTotalCount").val(), pageNo, pageSize, getPageData);
            }

            var param = {
                Month: month,
                Gubun: gubun,
                CompCode: compCode,
                BuyerCompany_Name: buyerCompany_Name,
                PayWay: payWay,
                PageNo: pageNo,
                PageSize: pageSize,
                Flag: "GetSalesExactcal"
            };

            var beforeSend = function () {
                $('#divLoading').css('display', '');
            }
            var complete = function () {
                $('#divLoading').css('display', 'none');
            }

            JqueryAjax("Post", "../../Handler/Admin/CompanyHandler.ashx", true, false, param, "json", callback, beforeSend, complete, true, '<%=Svid_User %>');
        }

        // RMP 有 판매사 매출금액 계산식
        function fnCustFormula(isRMP, GoodsSalePriceVat, GoodsBuyPriceVat, RMPPriceP, SwpPriceP, GoodsCustPriceVat) {
            var result = '';
            var RMP = fnRMPFormula(isRMP, GoodsSalePriceVat, GoodsBuyPriceVat, SwpPriceP);

            if (isRMP == 'Y') {
                // RMP + (구매가 - 매입가) * RMP비율
                result = eval(RMP.replace('원', '')) + (GoodsSalePriceVat - GoodsBuyPriceVat) * RMPPriceP / 100;
                return Math.round(result) + "원";
            } else {
                // (매입가 + 구매가) / 2
                //result = (GoodsBuyPriceVat + GoodsSalePriceVat) / 2;
                //return Math.round(result) + "원";
                return GoodsCustPriceVat + "원";
            }
        }

        // RMP 有 RMP 매출금액 계산식
        function fnRMPFormula(isRMP, GoodsSalePriceVat, GoodsBuyPriceVat, SwpPriceP) {
            var result = '';

            if (isRMP == 'Y') {
                // 매입가 + (구매가-매입가) * RMP비율
                result = GoodsBuyPriceVat + (GoodsSalePriceVat - GoodsBuyPriceVat) * SwpPriceP / 100;
                return Math.round(result) + "원";
            } else {
                // RMP가 없으면 RMP 매출금액 계산식이 필요없음
                return result;
            }
        }

        // 조회하기클릭시 빈칸 처리
        function fnSearchEmpty() {
            var cust = $('#txtSaleCompName').val();

            if (cust == '') {
                alert('회사 코드를 검색해주세요.');
            }
        }

        // 조회 엑셀저장
        function fnExcelExport() {

            var month = $('#txtdate').val().replace('-', '');
            var gubun = fnRadioChecked();
            var compCode = $('#txtSaleCompName').val();
            var buyerCompany_Name = $('#txtBuyerCompName').val();
            var payWay = $('#ddlSelectPayway').val();
            var id = '<%= AdminId%>';

            $.fileDownload('../../Handler/ExcelHandler.ashx', {
                httpMethod: 'POST',
                dataType: "json",
                contentType: "application/json",
                data: {
                    Month: month,
                    Gubun: gubun,
                    CompCode: compCode,
                    BuyerCompany_Name: buyerCompany_Name,
                    PayWay: payWay,
                    Id: id,
                    Method: 'ProfitListExcelDownLoad'
                },
                //prepareCallback: function (url) {
                //    $('#divLoading').css('display', '');
                //},
                //successCallback: function (url) {
                //    $('#divLoading').css('display', 'none');
                //},
                failCallback: function (html, url) {
                    alert("저장에 실패 했습니다. 관리자에게 문의해주십시오.");
                }
            });
        }

        // 페이징처리함수
        function getPageData() {
            var containerPopup = $('#paginationPopup');
            var getPageNumPopup = containerPopup.pagination('getSelectedPageNum');

            var container = $('#pagination');
            var getPageNum = container.pagination('getSelectedPageNum');

            fnProfitListPopUp(getPageNumPopup);
            fnProfitListSet(getPageNum);

            return false;
        }
    </script>

</asp:Content>
<asp:Content ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div class="all">
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
                    <li class='tabOn' style="width: 185px;" onclick="fnTabClickRedirect('ProfitList');">
                        <a onclick="fnTabClickRedirect('ProfitList');">매출정산내역</a>
                    </li>
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
                <table class="tbl_main">
                    <colgroup>
                        <col style="width: 200px" />
                        <col />
                        <col style="width: 200px" />
                        <col />
                    </colgroup>
                    <thead>
                        <tr>
                            <th colspan="4">매출내역</th>
                        </tr>
                    </thead>
                    <tr>
                        <th>정산월</th>
                        <td>
                            <input type="text" id="txtdate" class="calendar" maxlength="10" placeholder="2018-01" readonly>
                            <%--<img id="txtdate-button" src="../../Images/Goods/calendar.jpg" />--%>
                        </td>

                        <th>
                            <label for="RMP">RMP</label>
                            <input type="radio" id="RMP" name="division" value="RMP" checked>
                            &nbsp&nbsp
                            <label for="판매사">판매사</label>
                            <input type="radio" id="판매사" name="division" value="판매사">
                        </th>
                        <td>
                            <%--<asp:TextBox ID="txtSaleCompName" runat="server" OnKeypress="return fnEnter();" CssClass="medium-size"></asp:TextBox>--%>
                            <input type="text" id="txtSaleCompName" class="medium-size" value="" readonly />
                            <input class="mainbtn type1" style="width: 75px" type="button" value="검색" onclick="fnProfitListPopUp(1);">
                        </td>
                    </tr>
                    <tr>
                        <th>결제수단</th>
                        <td>
                            <%--<asp:DropDownList ID="ddlSelectPayway" CssClass="medium-size" runat="server">
                                <asp:ListItem Value="all" Text="---전체---"></asp:ListItem>
                            </asp:DropDownList>--%>
                            <select id="ddlSelectPayway" class="medium-size">
                                <option value="ALL">---전체---</option>
                            </select>
                        </td>
                        <th>구매사</th>
                        <td>
                            <%--<asp:TextBox ID="txtBuyerCompName" runat="server" OnKeypress="return fnEnter();" CssClass="medium-size"></asp:TextBox>--%>
                            <input type="text" id="txtBuyerCompName" class="medium-size" />
                        </td>
                    </tr>
                </table>
            </div>
            <!--상단영역 끝-->
            <!--조회하기 버튼-->
            <div class="bt-align-div">
                <input type="button" class="mainbtn type1" style="width: 95px; height: 30px; border-radius: 5px; font-size: 12px; margin-bottom: 2px" value="조회하기" onclick="fnProfitListSet(1);" />
            </div>
            <!--하단영역시작-->
            <div class="profitList-div" style="width: 100%;">
                <table class="tbl_main" id="tbProfitList">
                    <colgroup>
                        <col style="width: 4%;" />
                        <!--번호-->
                        <col style="width: 7%;" />
                        <!--주문일자 / 주문번호-->
                        <col style="width: 13%;" />
                        <!--구매사(입금날짜) / 주문자-아이디--->
                        <col style="width: 10%;" />
                        <!--판매사-->
                        <col style="width: 10%;" />
                        <!--RMP-->
                        <col style="width: 19%;" />
                        <!--주문상품정보-->
                        <col style="width: 7%;" />
                        <!--모델명-->
                        <col style="width: 7%;" />
                        <!--구매사매출금액(결제수단)-->
                        <col style="width: 4%;" />
                        <!--판매사 매출금액-->
                        <col style="width: 4%;" />
                        <!--RMP 매출금액-->
                        <col style="width: 4%;" />
                        <!--매입 매출금액-->
                        <col style="width: 4%;" />
                        <!--플랫폼 이용수수료-->
                    </colgroup>
                    <thead>
                        <tr>
                            <th rowspan="2">번호</th>
                            <th>주문일자</th>
                            <th>구매사<br>
                                (입금날짜)</th>
                            <th rowspan="2">판매사</th>
                            <th rowspan="2">RMP</th>
                            <th rowspan="2">주문상품정보</th>
                            <th rowspan="2">모델명</th>
                            <th rowspan="2">구매사<br>
                                매출금액<br>
                                (결제수단)</th>
                            <th rowspan="2">(예정)<br>
                                판매사<br>
                                매출금액</th>
                            <th rowspan="2">(예정)<br>
                                RMP<br>
                                매출금액</th>
                            <th rowspan="2">매입<br>
                                매출금액</th>
                            <th rowspan="2">플랫폼<br>
                                이용수수료</th>
                        </tr>
                        <tr>
                            <th>주문번호</th>
                            <th>주문자<br>
                                -아이디-</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td colspan="12" class="text-center">조회된 리스트가 없습니다.</td>
                        </tr>
                    </tbody>
                </table>
                <div class="bt-align-div">
                    <input class="mainbtn type1" type="button" value="전체 엑셀저장" />
                    <input class="mainbtn type1" type="button" value="조회 엑셀저장" onclick="fnExcelExport();" />
                    <input class="mainbtn type1" type="button" value="판매사 일괄 엑셀전송" />
                </div>
                <%--페이징처리--%>
                <div style="margin: 20px auto; text-align: center">
                    <input type="hidden" id="hdTotalCount" />
                    <div id="pagination" class="page_curl" style="display: inline-block"></div>
                </div>
            </div>

            <%--검색버튼 클릭시 팝업--%>
            <div id="profitListdiv" class="popupdiv divpopup-layer-package">
                <div class="popupdivWrapper" style="width: 700px;">
                    <div class="popupdivContents">
                        <div class="close-div">
                            <a onclick="fnClosePopup('profitListdiv');" style="cursor: pointer">
                                <img src="../../Images/Wish/icon-delete.jpg" alt="닫기" style="float: right;" /></a>
                        </div>
                        <div class="popup-title">
                            <h3 class="pop-title">회사 리스트</h3>
                        </div>
                        <div class="code-div divpopup-layer-conts" style="overflow-y: hidden">
                            <input type="hidden" id="hdSelectCode" />
                            <input type="hidden" id="hdSelectName" />
                            <div class="search-div" style="overflow: hidden;">
                                <input type="text" class="text-code" id="txtSaleCompNamePopup" style="width: 300px;" placeholder=" 검색어를 입력해 주세요." />
                                <input class="mainbtn type1" style="width: 75px;" type="button" value="검색" onclick="fnProfitListPopUpSearch(1);">
                            </div>
                            <table id="tbProfitListPopup" class="tbl_main tbl_popup">
                                <thead>
                                    <tr>
                                        <th>회사코드</th>
                                        <th>회사명</th>
                                    </tr>
                                </thead>
                                <tbody id="profitLinkPopup_Tbody">
                                    <tr>
                                        <td colspan="2" class="text-center">리스트가 없습니다.</td>
                                    </tr>
                                </tbody>
                            </table>
                            <%--페이징처리--%>
                            <div style="margin: 20px auto; text-align: center">
                                <input type="hidden" id="hdTotalCountPopup" />
                                <div id="paginationPopup" class="page_curl" style="display: inline-block"></div>
                            </div>
                        </div>
                        <div class="btn_center">
                            <input type="button" id="btnOk" class="mainbtn type1" style="width: 95px; height: 30px;" value="확인" onclick="return fnPopupOk();" />
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

</asp:Content>

