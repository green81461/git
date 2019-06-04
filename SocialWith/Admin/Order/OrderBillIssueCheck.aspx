<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Master/AdminMasterPage.master" AutoEventWireup="true" CodeFile="OrderBillIssueCheck.aspx.cs" Inherits="Admin_Order_OrderBillIssueCheck" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <link href="../Content/Order/order.css" rel="stylesheet" />
    <link href="../Content/Member/member.css" rel="stylesheet" />
    <script type="text/javascript" src="../../Scripts/jquery.ui.monthpicker.js"></script>
    <script type="text/javascript">
        $(function () {
            //달력
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

            $('#btnOrderBillSearch').on("click", function () {
                fnOpenDivLayerPopup('corpCodeAdiv');
                fnOrderBillCheckList(1);
            });

            // 팝업창에서 클릭시 변경 이벤트
            $("#tbSaleCompanyList").on("mouseover", "tr", function () {
                $("#tbSaleCompanyList tr").css("cursor", "pointer");
            });

            $("#tbSaleCompanyList").on("click", "tr", function () {
                //초기화
                $("#hdSelectCode").val('');
                $("#hdSelectName").val('');
                $("#tbSaleCompanyList tr").css("background-color", "");

                $(this).css("background-color", "#ffe6cc");

                var selectCode = $(this).find("#Comp_Code").text();
                var selectName = $(this).find("#Comp_Name").text();
                $("#hdSelectCode").val(selectCode);
                $("#hdSelectName").val(selectName);
            });

            // 검색창에서 검색 후 엔터키 클릭시 이벤트
            $('#txtPopSearchComp').on({
                keydown: function (e) {
                    if (e.keyCode == 13) {
                        fnOrderBillCheckList(1);
                        return false;
                    }
                    else
                        return true;
                }
            });

            $('#btnSearch').on("click", fnOrderBillIssueList);

            fnPaywayBind();
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

        function fnOrderBillCheckList(pageNum) {
            var asynTable = '';
            var pageSize = 8;
            var searchTarget = $('input[type=radio]:checked').val();
            var keyword = $('#txtPopSearchComp').val();

            var callback = function (response) {
                if (!isEmpty(response)) {
                    $.each(response, function (index, value) {
                        asynTable += "<tr>";
                        asynTable += "<td id='Comp_Code' class='txt-center' style='height:30px'>" + value.Company_Code + "</td>";
                        asynTable += "<td id='Comp_Name' class='txt-center' style='height:30px'>" + value.Company_Name + "</td></tr>";
                        $('#hdTotalCount').val(value.TotalCount);
                    });
                } else {
                    asynTable += "<tr><td colspan='2' class='text-center'>" + "검색결과가 없습니다." + "</td></tr>";
                    $('#hdTotalCount').val(0);
                }
                $('#tbSaleCompanyList tbody').empty().append(asynTable);

                // 페이징 만들어주는 함수
                fnCreatePagination('pagination', $("#hdTotalCount").val(), pageNum, pageSize, getPageData);
            };

            var param = {
                Keyword: keyword.trim(),
                Gubun: searchTarget,
                PageNo: pageNum,
                PageSize: pageSize,
                Method: "GetOrderBillCompList_Admin"
            };

            var beforeSend = function () {
                is_sending = true;
                $('#divLoading').css('display', 'block');
            }
            var complete = function () {
                is_sending = false;
                $('#divLoading').css('display', 'none');
            }

            JqueryAjax("Post", "../../Handler/PayHandler.ashx", false, false, param, "json", callback, beforeSend, complete, true, '<%=Svid_User %>');
        }

        function fnOrderBillIssueList() {
            var asynTable = '';
            var month = $('#txtdate').val().replace('-','');
            var gubun = fnRadioChecked();
            var compCode = $('#txtSaleCompName').val();
            var payway = $('#ddlSelectPayway').val();
            var callback = function (response) {
                if (!isEmpty(response)) {
                    $.each(response, function (i, value) {
                        asynTable += "<tr>";
                        asynTable += "<td rowspan='2' class='text-center'><input type='checkbox' id='chkNum'" + (i + 1) + ">";
                        asynTable += "<input type='hidden' value='" + value.OrderCodeNo + "' /></td>";
                        asynTable += "<td rowspan='2' class='text-center'>" + value.RowNumber + "</td>"; // 번호
                        asynTable += "<td class='text-center'>" + fnOracleDateFormatConverter(value.EntryDate) + "</td>"; // 주문일자
                        asynTable += "<td class='text-center'>" + value.CompanyCode + "<br/>(" + fnOracleDateFormatConverter(value.PayCashDate) + ")</td>" // 구매사(입금날짜)
                        asynTable += "<td rowspan='2' class='text-center'>" + value.OrderSaleCompanyName + "</td>"; // 판매사
                        asynTable += "<td rowspan='2' class='text-center'>" + value.RMPCompanyName + "</td>"; // RMP
                        asynTable += "<td rowspan='2'>" + value.GoodsName + "</td>" // 상품요약명(수량)
                        asynTable += "<td rowspan='2' class='text-right' style='padding-right:10px'>" + numberWithCommas(fnCustFormula(value.IsRMP, value.GoodsSalePriceVat, value.GoodsBuyPriceVat, value.RMPPriceP, 100 - value.SwpPriceP, value.GoodsCustPriceVat)) + "</td>"; // 판매사매출정산
                        asynTable += "<td rowspan='2' class='text-right' style='padding-right:10px'>" + numberWithCommas(fnRMPFormula(value.IsRMP, value.GoodsSalePriceVat, value.GoodsBuyPriceVat, 100 - value.SwpPriceP)) + "</td>"; // RMP매출정산
                        asynTable += "<td rowspan='2' class='text-right' style='padding-right:10px'>" + value.SupplyJung + "원</td>"; // 플랫폼이용수수료
                        asynTable += "<td rowspan='2' class='text-right' style='padding-right:10px'>" + value.BillJung + "원</td>"; // 세금계산서수수료
                        asynTable += "<td rowspan='2' class='text-right' style='padding-right:10px'>" + numberWithCommas(fnCustBillFormula(value.SupplyJung, value.BillJung, value.GoodsCustPriceVat)) + "</td>"; // 판매사세금계산서발행금액
                        asynTable += "<td rowspan='2' class='text-right' style='padding-right:10px'>" + numberWithCommas(fnRMPCustBillFormula(value.IsRMP, value.GoodsSalePriceVat, value.GoodsBuyPriceVat, value.SupplyJung, value.SwpPriceP, value.BillJung)) + "</td>"; // RMP세금계산서발행금액
                        asynTable += "</tr>"

                        //========================================================//

                        asynTable += "<tr>"
                        asynTable += "<td class='text-center'>" + value.OrderCodeNo + "</td>"; // 주문번호
                        asynTable += "<td class='text-center'>" + value.Name + "<br/>-" + value.Id + "-</td>"; // 주문자-아이디-
                        asynTable += "</tr>"
                    });
                } else {
                    asynTable += "<tr><td colspan='13' class='text-center'>" + "리스트가 없습니다." + "</td></tr>";
                }
                $('#tbOrdBillIssueList tbody').empty().append(asynTable);
            };

            var param = {
                Month: month,
                Gubun: gubun,
                CompCode: compCode,
                PayWay: payway,
                Method: "GetOrderBillIssueList_Admin"
            };

            var beforeSend = function () {
                is_sending = true;
                $('#divLoading').css('display', 'block');
            }
            var complete = function () {
                is_sending = false;
                $('#divLoading').css('display', 'none');
            }

            JqueryAjax("Post", "../../Handler/PayHandler.ashx", false, false, param, "json", callback, beforeSend, complete, true, '<%=Svid_User %>');
        
        }

        function getPageData() {
            var container = $('#pagination');
            var getPageNum = container.pagination('getSelectedPageNum');
           
            fnOrderBillCheckList(getPageNum);
            return false;
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
        function fnRMPFormula(isRMP, GoodsSalePriceVat, GoodsBuyPriceVat, RMPPriceP) {
            var result = '';

            if (isRMP == 'Y') {
                // 매입가 + (구매가-매입가) * RMP비율
                result = GoodsBuyPriceVat + (GoodsSalePriceVat - GoodsBuyPriceVat) * RMPPriceP / 100;
                return Math.round(result) + "원";
            } else {
                // RMP가 없으면 RMP 매출금액 계산식이 필요없음
                return result;
            }
        }

        // 세금계산서 발행금액
        function fnCustBillFormula(SupplyJung, BillJung, GoodsCustPriceVat) {
            var result = '';

            // 판매사매출정산 + 플랫폼 수수료 + 세금계산서 수수료
            result = GoodsCustPriceVat + SupplyJung + BillJung;
            return Math.round(result) + "원";
        }

        function fnRMPCustBillFormula(isRMP, GoodsSalePriceVat, GoodsBuyPriceVat, SupplyJung, SwpPriceP, BillJung) {
            var result = '';
            var RMP = fnRMPFormula(isRMP, GoodsSalePriceVat, GoodsBuyPriceVat, SwpPriceP);

            if (isRMP == 'Y') {
                // RMP + 플랫폼 수수료 + 세금계산서 수수료
                result = eval(RMP.replace('원', '')) + SupplyJung + BillJung;
                return Math.round(result) + "원";
            } else {
                return result;
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
            JqueryAjax('Post', "../../Handler/Common/CommHandler.ashx", false, false, param, 'json', callback, null, null, true, '<%=Svid_User %>');
        }

        function fnPopupEnter() {
            if (event.keyCode == 13) {
                fnSearchCompanyList(1);
                return false;
            }
            else
                return true;
        }

        function fnDataClear() {
            $("input[type='text'][id^='txt']").val('');
            $("input[type='file'][id^='fu']").val('');
            $("p[id^='lbl']").text('');
            $("span[id^='span']").text('');
            $("input[type='radio'][id^='rb']").prop('checked', false);
        }

        function fnPopupOk() {
            var selectCode = $("#hdSelectCode").val();
            var selectName = $("#hdSelectName").val();
            if (selectCode == '' || selectName == '') {
                alert('회사를 선택해주세요.');
                return false;
            } else {
                fnOrderBillCheckList(1);
                fnClosePopup('corpCodeAdiv');
                $('#txtSaleCompName').val(selectCode);
                return false;
            }
        }

        //전체선택
        function fnSelectAll(el) {
            if ($(el).prop("checked")) {
                $("input[id*=cbSelect]").not(":disabled").prop("checked", true);
            }
            else {
                $("input[id*=cbSelect]").not(":disabled").prop("checked", false);
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
            <div class="div-main-tab" style="width: 100%; ">
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
                    <span class="subTabOn" style="width: 186px; height: 35px; cursor: pointer;" id="btnTab1" onclick="fnGoPage('GOODS')">발행</span>
                    <span class="subTabOff" style="width: 186px; height: 35px; cursor: pointer;" id="btnTab2"onclick="fnGoPage('FINAL')">최종 현황</span>
                    <span class="subTabOff" style="width: 186px; height: 35px; cursor: pointer;" id="btnTab2" onclick="fnGoPage('ISSUE')">이슈 현황</span>
                </div>
            </div>

            <!--상단영역 시작-->
            <div class="search-div">
                <table id="tblSearch" class="tbl_main">
                    <colgroup>
                        <col style="width:200px"/>
                        <col />
                        <col style="width:200px"/>
                        <col />
                    </colgroup>
                    <thead>
                        <tr>
                            <th colspan="4">매출내역 요약</th>
                        </tr>
                    </thead>
                    <tr>
                        <th>정산월</th>
                        <td>
                            <input type="text" id="txtdate" class="calendar" maxlength="10" placeholder="2018-01" readonly>
                        </td>
                        <th rowspan="2"><label for="RMP">RMP</label> <input type="radio" name="division" value="IU" checked> &nbsp&nbsp<label for="판매사">판매사</label> <input type="radio" name="division" value="SU"></th>
                        <td rowspan="2">
                            <input type="text" id="txtSaleCompName" onkeypress="return fnEnter();" class="medium-size" />
                            <input Class="mainbtn type1" id="btnOrderBillSearch" style="width:75px" type="button" value="검색">
                        </td>
                    </tr>
                    <tr>
                        <th>결제수단</th>
                        <td>
                            <select id="ddlSelectPayway" class="medium-size">
                                <option value="ALL">---전체---</option>
                            </select>
                        </td>
                    </tr>
                </table>
            </div>
        <!-- S. 조회하기 -->
            <div class="bt-align-div">
                <input type="button" id="btnSearch" class="mainbtn type1" value="조회하기" style="width:95px"/>
            </div>

            <!--하단영역시작-->
            <div class="orderList-div" style="width: 100%;">
                <table id="tbOrdBillIssueList" class="tbl_main">
                    <colgroup>
                        <!-- 전체선택 -->
                        <col width="3%" />
                        <!-- 번호 -->
                        <col width="3%" />
                        <!-- 주문일자/주문번호 -->
                        <col width="7%" />
                        <!-- 구매사/주문자 -->
                        <col width="8%" />
                        <!-- 판매사 -->
                        <col width="8%" />
                        <!-- RMP -->
                        <col width="8%" />
                        <!-- 상품요약명 -->
                        <col width="15%" />
                        <!-- 판매사 매출정산 -->
                        <col width="8%" />
                        <!-- RMP 매출정산 -->
                        <col width="8%" />
                        <!-- 플랫폼 이용수수료 -->
                        <col width="6%" />
                        <!-- 세금계산서수수료(결제수단) -->
                        <col width="9%" />
                        <!-- 판매사 세금계산서 발행금액 -->
                        <col width="9%" />
                        <!-- RMP 세금계산서 발행금액 -->
                        <col width="8%" />
                    </colgroup>
                    <thead>
                        <tr>
                            <th class="text-center" rowspan="2">전체<br>선택<br><input type="checkbox" id="cbSelectAll" onclick="fnSelectAll(this)"/></th>
                            <th class="text-center" rowspan="2">번호</th>
                            <th class="text-center">주문일자</th>
                            <th class="text-center">구매사<br>(입금날짜)</th>
                            <th class="text-center" rowspan="2">판매사</th>
                            <th class="text-center" rowspan="2">RMP</th>
                            <th class="text-center" rowspan="2">상품요약명<br>(수량)</th>
                            <th class="text-center" rowspan="2">(예정)<br>판매사 매출정산</th>
                            <th class="text-center" rowspan="2">(예정)<br>RMP 매출정산</th>
                            <th class="text-center" rowspan="2">플랫폼<br />이용수수료</th>
                            <th class="text-center" rowspan="2">세금계산서<br />수수료</th>
                            <th class="text-center" rowspan="2">판매사 세금계산서<br>발행금액</th>
                            <th class="text-center" rowspan="2">RMP세금계산서<br>발행금액</th>
                        </tr>
                        <tr>
                            <th>주문번호</th>
                            <th>주문자<br>-아이디-</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td class="text-center" colspan="13">리스트가 없습니다.</td>                     
                        </tr>     
                    </tbody>
                </table>
            <!--하단영역끝-->
                <div class="bt-align-div">
                    <input class="mainbtn type1" type="button" value="판매사 세금계산서 발행" />
                    <input class="mainbtn type1" type="button" value="RMP 세금계산서 발행" />
                </div>
        </div>
    </div>
<%-- S. RMP/판매사 회사구분코드 팝업--%>
    <div id="corpCodeAdiv" class="divpopup-layer-package">
        <div class="popupdivWrapper" style="width: 700px;">
            <div class="popupdivContents">
                <div class="close-div">
                    <a href="#none" onclick="fnClosePopup('corpCodeAdiv'); return false;" style="cursor: pointer">
                        <img src="../../Images/Wish/icon-delete.jpg" alt="닫기" style="float: right;" /></a>
                </div>
                <div class="popup-title">
                    <h3 class="pop-title">회사코드검색</h3>
                </div>
                <div class="search-div">
                    <input type="text" id="txtPopSearchComp" class="large-size" placeholder="검색어를 입력해주세요." style="padding:0 3px"/>
                    <input type="button" class="mainbtn type1" style="width: 75px; height: 25px;" value="검색" onclick="fnOrderBillCheckList(1)" />
                </div>
                <div class="code-div divpopup-layer-conts">
                    <input type="hidden" id="hdSelectCode" />
                    <input type="hidden" id="hdSelectName" />
                    <table id="tbSaleCompanyList" class="tbl_main tbl_popup">
                        <colgroup>
                            <col width="50%" />
                            <col width="50%" />
                        </colgroup>
                        <thead>
                            <tr>
                                <th>회사코드</th>
                                <th>회사명</th>
                            </tr>
                        </thead>
                        <tbody></tbody>
                    </table>
                </div>
            <%-- S. 페이징처리--%>
                <div style="margin: 20px auto; text-align: center">
                    <input type="hidden" id="hdTotalCount" />
                    <div id="pagination" class="page_curl" style="display: inline-block"></div>
                </div>
            <%-- E. 페이징처리--%>
                <div class="btn_center">
                    <input type="button" id="btnOk" class="mainbtn type1" style="width: 95px; height: 30px;" value="확인" onclick="return fnPopupOk();" />
                </div>
            </div>
        </div>
    </div>
<%-- E. RMP/판매사 회사구분코드 팝업--%>
</asp:Content>

