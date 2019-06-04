<%@ Page Title="" Language="C#" MasterPageFile="~/Master/Default.master" AutoEventWireup="true" CodeFile="OrderBillListSch.aspx.cs" Inherits="Order_OrderBillListSch" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <link href="../Content/Order/order.css" rel="stylesheet" />
    <link href="../Content/popup.css" rel="stylesheet" />

    <style type="text/css">
        table.ui-datepicker-calendar { display:none; }
    </style>
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

        });

        // enter key 방지
        $(document).on("keypress", "#tblHistoryList input", function (e) {
            if (e.keyCode == 13) {
                fnSearch(1);
                return false;
            }
            else
                return true;
        });

        var is_sending = false;
        //조회 버튼
        function fnSearch(pageNum) {

            var txtSdate = $("#<%=this.txtSearchSdate.ClientID%>").val();
            var txtEdate = $("#<%=this.txtSearchEdate.ClientID%>").val();

            if (txtSdate != '' && txtEdate != '') {


                var schSdate = txtSdate.split('-');

                var schSdateYY = schSdate[0];
                var schSdateMM = schSdate[1];


                var schEdate = txtEdate.split('-');

                var schEdateYY = schEdate[0];
                var schEdateMM = schEdate[1];

                var searchKeyword = $("#txtLoanNo").val();   //여신결제번호


                var pageSize = 20; //페이징 처리 사이즈
                var asynTable = "";

                var callback = function (response) {

                    $("#tblOrderBillListSch tbody").empty();

                    if (!isEmpty(response)) {

                        $.each(response, function (key, value) {

                            $("#hdTotalCount").val(value.TotalCount);

                            asynTable += "<tr name='trColor'>"
                            asynTable += "<td class='txt-center'><input type='hidden' id='hdUnumPayNo' name='hdUnumPayNo' value='" + value.Unum_PayNo + "'><input type='checkbox'/>" + "</td>";
                            asynTable += "<td class='txt-center'>" + value.YY + "." + value.MM + "</td>";
                            asynTable += "<td class='txt-center'>" + value.OrderCodeNo + "</td>";
                            asynTable += "<td class='txt-center'>" + value.OrderCnt + " 건 </td>";
                            asynTable += "<td class='txt-center'>" + value.GoodsQty + " 건 </td>";
                            asynTable += "<td style='text-align:right; padding-right:10px;'>" + numberWithCommas(value.Amt) + "원</td>";
                            asynTable += "<td style='text-align:center'><img src='../Images/add-off.jpg' style='cursor:pointer' onmouseover=\"this.src='../Images/add-on.jpg'\"  onmouseout=\"this.src='../Images/add-off.jpg'\"  alt='상세확인' onclick='return showDetailPopup(this)' id='imgBPayType'/></td></tr >";
                            asynTable += "  ";
                        });
                    } else {
                        asynTable += "<tr><td colspan='7' class='txt-center'>" + "조회된 내역이 없습니다." + "</td></tr>"
                        $("#hdTotalCount").val(0);
                    }
                    $("#tblOrderBillListSch tbody").append(asynTable);
                    fnCreatePagination('pagination', $("#hdTotalCount").val(), pageNum, pageSize, getPageData);

                }


                var sUser = '<%=Svid_User %>';
                var ComCode = '<%=UserInfoObject.UserInfo.Company_Code%>';

                var param = {
                    sUser: sUser,
                    comCode: ComCode,
                    odrCodeNo: searchKeyword,
                    sYear: schSdateYY,
                    eYear: schEdateYY,
                    sMon: schSdateMM,
                    eMon: schEdateMM,
                    PageNo: pageNum,
                    PageSize: pageSize,
                    Method: 'OrderBillListSch'
                };

                var beforeSend = function () {
                    is_sending = true;
                }
                var complete = function () {
                    is_sending = false;
                }

                if (is_sending) return false;

                JqueryAjax('Post', '../Handler/PayHandler.ashx', true, false, param, 'json', callback, beforeSend, complete, true, '<%=Svid_User%>');

            }
            else {
                alert('조회할 달을 지정해주세요.')
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
        function getPageData2() {
            var container = $('#pagination_2');
            var getPageNum = container.pagination('getSelectedPageNum');
            SearachPop(getPageNum, $("#hd_pop_uNumPay").val());
            return false;
        }


        function showDetailPopup(el) {

            var e = document.getElementById('DetailDiv');

            if (e.style.display == 'block') {
                e.style.display = 'none';

            } else {
                e.style.display = 'block';
            }

            var uNumPay = $(el).parent().parent().find("input:hidden[name='hdUnumPayNo']").val();

            SearachPop(1, uNumPay);
            return false;
        }



        //팝업에서 조회
        function SearachPop(pageNum, UnumPayNo) {


            //var searchKeyword = $("#txtLoanNo").val();   //여신결제번호


            var pageSize = 7;                                  //페이징 처리 사이즈
            var i = 1;                                          //페이징
            var asynTable = "";


            var callback = function (response) {

                $("#tblOrderBillListSchPop tbody").empty();

                if (!isEmpty(response)) {

                    $.each(response, function (key, value) {
                        $("#hdTotalCount_2").val(value.TotalCount);
                        if (key == 0) $("#hd_pop_uNumPay").val(value.PayLoanSeqNoB);

                        var src = '/GoodsImage' + '/' + value.GoodsFinalCategoryCode + '/' + value.GoodsGroupCode + '/' + value.GoodsCode + '/' + value.GoodsFinalCategoryCode + '-' + value.GoodsGroupCode + '-' + value.GoodsCode + '-sss.jpg';
                        asynTable += "<tr name='trColor'>"
                        asynTable += "<td rowspan='2' class='txt-center'>" + value.RowNumber + "</td>";  //번호
                        asynTable += "<td rowspan='2' class='txt-center'>" + value.OrderEnterDate.split("T")[0] + "</td>"; //입고일
                        asynTable += "<td rowspan='2' class='txt-center'>" + value.OrderCodeNo + "</td>"; //주문코드
                        asynTable += "<td rowspan='2' class='txt-center'><img src=" + src + " onerror='no_image(this, \"s\")' style='width:50px; height=50px'/></td>"; //이미지
                        asynTable += "<td rowspan='2' class='txt-center'>" + value.GoodsCode + "</td>"; //상품코드 
                        asynTable += "<td rowspan='2' style='text-align:left;  class='txt-center'>" + "[" + value.BrandName + "] " + value.GoodsFinalName + "<br /><span style='color:#368AFF; width:280px; word-wrap:break-word; display:block;'>" + value.GoodsOptionSummaryValues + "</span></td>"; //주문상품정보
                        asynTable += "<td rowspan='2' class='txt-center'>" + value.GoodsModel + "</td>"; //모델명 
                        asynTable += "<td class='txt-center'>" + numberWithCommas(value.GoodsSalePriceVat) + "원</td>"; //상품단가(vat 포함)
                        asynTable += "<td rowspan='2' class='txt-center'>" + value.Qty + "</td>"; //수량
                        asynTable += "<td rowspan='2' style='text-align:right; padding-right:5px;'>" + numberWithCommas(value.GoodsTotalSalePriceVat) + "원</td>"; //주문금액(vat 포함)
                        asynTable += "<td rowspan='2' class='txt-center'>" + value.OrderEndType_Name + "</td>"; //마감현황
                        asynTable += "<tr name='trColor'>"
                        asynTable += "<td class='txt-center'>" + value.GoodsUnit_Name + "</td></tr>";


                        //<td style='text-align:left; width:280px'>" + "[" + value.BrandName + "] " + value.GoodsFinalName + "<br /><span style='color:#368AFF; width:280px; word-wrap:break-word; display:block;'>" + value.GoodsOptionSummaryValues + "</span></td></tr></table ></td >


                        i++;

                    });
                } else {
                    asynTable += "<tr><td colspan='11' class='txt-center'>" + "조회된 정보가 없습니다." + "</td></tr>"
                    $("#hdTotalCount_2").val(0);
                }
                $("#tblOrderBillListSchPop tbody").append(asynTable);
                fnCreatePagination('pagination_2', $("#hdTotalCount_2").val(), pageNum, pageSize, getPageData2);


            }

            var sUser = '<%=Svid_User %>';
            var param = {
                sUser: sUser,
                unumPayNo: UnumPayNo,
                PageNo: pageNum,
                PageSize: pageSize,
                Flag: 'BUY',
                Method: 'OrderBillListSchPop'
            };

            // JajaxSessionCheck('Post', '../Handler/PayHandler.ashx', param, 'json', callback, sUser);

            var beforeSend = function () { };
            var complete = function () { };
            JqueryAjax('Post', '../Handler/PayHandler.ashx', true, false, param, 'json', callback, beforeSend, complete, true, '<%=Svid_User%>');
            //반환 값 없이 OK와 같은 신호를 보낼거면 json을 text로 바꿈, 마지막에 svid전에 true는 세션체크 유무

        }
        
        function fnCancel() {
            $('.popupdiv').fadeOut();
            return false;
        }

        function fnExcelDownload() {
            alert("추후 개발예정입니다.");
            return false;
        }
    </script>

    <style type="text/css">
        .auto-style1 {
            height: 30px;
        }

        .table1 {
            float: left;
            width: 550px;
            height: 300px;
        }

        .table2 {
            display: inline-block;
            width: 550px;
            height: 300px;
        }

        .auto-style7 {
            width: 1218px;
        }

        .auto-style8 {
            text-align: center;
            height: 30px;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div class="sub-contents-div">
        <!--제목 타이틀-->
        <div class="sub-title-div">
            <p class="p-title-mainsentence">
                정산내역조회
                <%--<span class="span-title-subsentence">고객님의 배송지를 확인할 수 있습니다.</span>--%>
            </p>
        </div>

        <!--탭메뉴-->
        <%--<div class="div-main-tab" style="width:100%; height:36px; border-bottom:1px solid #ec2028">
            <ul>
                <li>
                    <a href="OrderBillList.aspx" class='tabOff' style="width: 185px; height: 35px; font-size: 12px">마감신청</a>
                    <a href="OrderBillListSch.aspx" class='tabOn' style="width: 185px; height: 35px; font-size: 12px">내역조회</a>
                    <a href="OrderBillPayment.aspx" class='tabOff' style="width: 185px; height: 35px; font-size: 12px">대금결제</a>
                </li>
            </ul>
        </div>--%>
        <div class="div-main-tab" style="width: 100%; ">
            <ul>
                <li  class='tabOff' style="width: 185px;" onclick="location.href='OrderBillList.aspx'">
                    <a href="OrderBillList.aspx" >마감신청</a>
                </li>
                <li  class='tabOn' style="width: 185px;" onclick="location.href='OrderBillListSch.aspx'">
                    <a href="OrderBillListSch.aspx" >내역조회</a>
                 </li>
                <li  class='tabOff' style="width: 185px;" onclick="location.href='OrderBillPayment.aspx'">
                    <a href="OrderBillPayment.aspx" >대금결제</a>
                 </li>
            </ul>
        </div>


        <div class="search-div">
            <table id="tblHistoryList">
                <thead>
                </thead>
                <tr>
                    <th colspan="2" class="auto-style8">마감월별조회</th>
                    <td colspan="6" class="auto-style1">
                        <asp:TextBox ID="txtSearchSdate" runat="server" CssClass="calendar" ReadOnly="true" Onkeypress="return fnEnter();"></asp:TextBox>&nbsp;&nbsp;
                      <%--<input type="checkbox" id="ckbSearch1" value="1" checked="checked" /><label for="ckbSearch1">분할1</label>
                        <input type="checkbox" id="ckbSearch2" value="7" /><label for="ckbSearch2">분할2</label>--%>
                        -
                            &nbsp;&nbsp;<asp:TextBox ID="txtSearchEdate" runat="server" CssClass="calendar" ReadOnly="true" Onkeypress="return fnEnter();"></asp:TextBox>&nbsp;&nbsp;
                        <%--<input type="checkbox" id="ckbSearch3" value="15" /><label for="ckbSearch3">분할1</label>
                        <input type="checkbox" id="ckbSearch4" value="30" /><label for="ckbSearch4">분할2</label>--%>
                    </td>
                </tr>
                <tr>
                    <th colspan="2" class="auto-style8">여신결제번호</th>
                    <td>
                        <input type="text" name="txtLoanNo" id="txtLoanNo" style="height: 25px; width: 220px; border:1px solid #a2a2a2;" />
                    </td>
                </tr>
            </table>

            <div class="bt-align-div">
                <a>
                    <img alt="조회하기" src="../Images/Goods/aslist.jpg" id="btnSearch" onclick="fnSearch(1); return false;" onmouseover="this.src='../Images/Wish/aslist-over.jpg'" onmouseout="this.src='../Images/Goods/aslist.jpg'" /></a>
            </div>
        </div>

        <!--상단 조회영역 끝-->
        <br />

        <!--하단 리시트영역 시작-->
        <div class="auto-style7">

            <table class="CommonList-tbl" id="tblOrderBillListSch">
                <thead>
                    <tr>
                        <th style="width: 35px;">선택<br />
                            <input type="checkbox" /></th>
                        <th style="width: 105px;">마감월</th>
                        <th style="width: 180px;">여신결제번호</th>
                        <th style="width: 105px;">주문건수</th>
                        <th style="width: 105px;">상품건수</th>
                        <th style="width: 155px;">총 결제금액</th>

                        <th style="width: 100px;">상세보기</th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td colspan="7" class="txt-center">리스트을 조회해 주시기 바랍니다.</td>
                    </tr>
                </tbody>
            </table>

            <div style="margin: 0 auto; text-align: center; padding-top: 10px">
                <input type="hidden" id="hdTotalCount2" />
                <div id="pagination" class="page_curl" style="display: inline-block"></div>
            </div>

            <div class="bt-align-div">
                <input type="button" class="commonBtn" style="width: 95px; height: 30px; font-size: 12px" value="엑셀다운" onclick="return fnExcelDownload();" />

            </div>
        </div>
        <!--하단 리스트 영역 끝 -->
    </div>

    <%--상세보기 팝업 시작--%>

    <div id="DetailDiv" class="popupdiv">
        <div class="popupdivWrapper" style="width: 1200px; height: 200px; margin: 150px auto; background-color: #ffffff;">
            <div class="popupdivContents" style="background-color: #ffffff; height: 710px; padding: 15px;">

                <div class="close-div">
                    <a onclick="fnCancel()" style="cursor: pointer">
                        <img src="../../Images/Wish/icon-delete.jpg" alt="닫기" style="float: right;" /></a>
                </div>

                <div class="popup-title" style="margin-top: 20px;">
                    <h3 class="pop-title">주문상품</h3>
                    <br />

                    <!-- 주문 상품 테이블 -->
                    <div>
                        <table class="board-table" id="tblOrderBillListSchPop">
                            <thead>
                                <tr>
                                    <th rowspan="2">번호<input type="hidden" id="hd_pop_uNumPay" /></th>
                                    <th rowspan="2">입고일</th>
                                    <th rowspan="2">주문코드</th>
                                    <th rowspan="2">이미지</th>
                                    <th rowspan="2">상품코드</th>
                                    <th rowspan="2">주문상품정보</th>
                                    <th>모델명</th>
                                    <th rowspan="2">상품단가
                                        <br />
                                        (VAT포함)</th>
                                    <th rowspan="2">수량</th>
                                    <th rowspan="2">주문금액<br />
                                        (VAT포함)</th>
                                    <th rowspan="2">마감현황</th>
                                </tr>
                                <tr>
                                    <th>내용량</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr>
                                    <td colspan="12" class="txt-center">주문내역이 없습니다.</td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                    <br />
                </div>

                <div style="margin: 0 auto; text-align: center">
                    <input type="hidden" id="hdTotalCount_2" />
                    <div id="pagination_2" class="page_curl" style="display: inline-block"></div>
                </div>

                <!-- 팝업버튼 -->
                <div style="margin-top: 20px; text-align: right">
                    <input type="button" class="commonBtn" style="width:95px; height:30px; font-size:12px" value="닫기" onclick="fnCancel(); return false;"/>
                </div>
            </div>
        </div>
    </div>
    <input type="hidden" id="hdTotalCount" />

    <!-- 상세보기 -->
</asp:Content>

