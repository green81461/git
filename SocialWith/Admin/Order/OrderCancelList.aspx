<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Master/AdminMasterPage.master" AutoEventWireup="true" CodeFile="OrderCancelList.aspx.cs" Inherits="Admin_Order_OrderCancelList" %>

<%@ Register Src="~/UserControl/ucListControl.ascx" TagName="ListPager" TagPrefix="ucPager" %>
<%@ Import Namespace="Urian.Core" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <link href="../Content/Order/order.css" rel="stylesheet" />
    <script src="../../Scripts/jquery.inputmask.bundle.js"></script>
   
    <script type="text/javascript">
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

            fnSearch(1);
        });

        // enter key 방지
        $(document).on("keypress", "#tblSearchList input", function (e) {
            if (e.keyCode == 13) {
                return false;
            }
            else
                return true;
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


        //조회하기
        function fnSearch(pageNum) {
            var startDate = $('#<%= txtSearchSdate.ClientID%>').val();
            var endDate = $('#<%= txtSearchEdate.ClientID%>').val();
            var payway = $('#<%=ddlPay.ClientID %>').val();
            var status = $('#<%=ddlAsStatus.ClientID %>').val();
            var saleComp = $('#<%=txtSaleCompanyName.ClientID %>').val();
            var buyComp = $('#<%=txtBuySaleName.ClientID %>').val();
            var pageSize = 20;
            var i = 1;
            var asynTable = "";

            var callback = function (response) {
                $("#list-table tbody").empty();

                if (!isEmpty(response)) {
                    $.each(response, function (key, value) {

                        var dlvrDate = "";
                        if (!isEmpty(dlvrDate)) {
                            dlvrDate = value.DeliveryDate.split("T")[0];
                        }
                        var paywayIcon = '<img src="../../Images/Order/paywayicon_' + value.PayWay + '.png"/>'; //결제방법아이콘
                        //var src = '/GoodsImage' + '/' + value.GoodsFinalCategoryCode + '/' + value.GoodsGroupCode + '/' + value.GoodsCode + '/' + value.GoodsFinalCategoryCode + '-' + value.GoodsGroupCode + '-' + value.GoodsCode + '-sss.jpg';
                        $("#hdTotalCount").val(value.TotalCount);

                        asynTable += "<tr class='trOrder' onClick='fnOdrDtlPopup(this); return false;'>"
                            + "<input type= 'hidden' name= 'hdOrderCodeNo' value= '" + value.OrderCodeNo + "' />"
                            + "<input type= 'hidden' name= 'hdPayWay' value= '" + value.PayWay + "' />"
                            + "<input type= 'hidden' name= 'hdOrdStat' value= '" + value.OrderCancelStatus + "' />"

                        //asynTable += "<td rowspan='2' style='text-align:center; width:77px' class='rowColor_td'>" + value.OrderCancelStatus_Name + "</td>";
                        asynTable += "<td rowspan='2' style='text-align:center; width:77px' class='rowColor_td'><img src='../Images/Order/ico_OrdCancel_" + value.OrderCancelStatus + ".png' /></td>";




                        asynTable += "<td style='text-align:center; width:87px' class='rowColor_td'>" + value.CancelEntryDate.split("T")[0] + "</td>";
                        asynTable += "<td style='text-align:center; text-align:center; width:80px' class='rowColor_td'>" + value.OrderSaleCompanyName + "</td>";
                        asynTable += "<td rowspan='2' style='text-align:center; width:80px' class='rowColor_td'>" + value.SaleCompany_Name + "</td>";
                        asynTable += "<td class='rowColor_td' style='text-align:center; width:102px'> " + value.EntryDate.split("T")[0] + "</td >";
                        asynTable += "<td rowspan='2' style='width:285px' class='rowColor_td'>" + "[" + value.BrandName + "] " + value.GoodsFinalName + "<br/><span style='color:#368AFF; width:280px; word-wrap:break-word; display:block;'>" + value.GoodsOptionSummaryValues + "</td>";
                        asynTable += "<td rowspan='2' class='rowColor_td'>" + value.GoodsModel + "</td>";
                        asynTable += "<td style='text-align:center; width:87px' class='rowColor_td'>" + value.GoodsUnitMoq + " / " + value.GoodsUnit + "</td>";
                        asynTable += "<td style='padding-right: 5px; text-align: right; width:77px' class='rowColor_td'>" + numberWithCommas(value.GoodsSalePriceVat) + "원</td>";
                        asynTable += "<td rowspan='2' style='text-align:center; width:64px' class='rowColor_td'>" + value.CancelContent + "</td>";
                        asynTable += "<td rowspan='2' style='text-align:center; width:64px' class='rowColor_td'>" + paywayIcon + "</td></tr>";

                        //-----------------------------------------------------------------다음행-----------------------------------------------------------------------------------------------------------//
                        asynTable += "<tr class='trOrder' onClick='fnOdrDtlPopup(this); return false;'>"
                            + "<input type= 'hidden' name= 'hdOrderCodeNo' value= '" + value.OrderCodeNo + "' />"
                            + "<input type= 'hidden' name= 'hdPayWay' value= '" + value.PayWay + "' />"
                            + "<input type= 'hidden' name= 'hdOrdStat' value= '" + value.OrderCancelStatus + "' />"
                        asynTable += "<td style= 'text-align:center' class='rowColor_td' > " + value.OrderCancelCodeNo + "</td > ";
                        asynTable += "<td style= 'text-align:center' class='rowColor_td' > " + value.Name + "<br />" + "-" + value.Id + "-" + "</td > ";
                        asynTable += "<td style= 'text-align:center' class='rowColor_td' > " + value.OrderCodeNo + "</td > ";
                        asynTable += "<td style='text-align:center' class='rowColor_td'>" + value.Qty + "</td>";
                        asynTable += "<td style='padding-right: 5px; text-align: right;' class='rowColor_td'>" + numberWithCommas(value.GoodsTotalSalePriceVAT) + "원</td></tr>";
                        i++;

                    });
                } else {
                    asynTable += "<tr><td colspan='11' class='txt-center'>" + "조회된 주문취소내역이 없습니다." + "</td></tr>"
                    $("#hdTotalCount").val(0);
                }
                $("#list-table tbody").append(asynTable);
                //setTableHover();
                fnCreatePagination('pagination', $("#hdTotalCount").val(), pageNum, 20, getPageData);
            }

            var sUser = '<%= Svid_User%>';
            var param = { SvidUser: sUser, OrderStatus: status, PayWay: payway, TodateB: startDate, TodateE: endDate, SaleComp: saleComp, BuyComp: buyComp, Status: status, Method: 'OrdCancelList_Admin', PageNo: pageNum, PageSize: pageSize };
            //JajaxSessionCheck('Post', '../../Handler/OrderHandler.ashx', param, 'json', callback, sUser);

            var beforeSend = function () {
                $('#divLoading').css('display', '');
            }
            var complete = function () {
                $('#divLoading').css('display', 'none');
            }

             JqueryAjax('Post', '../../Handler/OrderHandler.ashx', true, false, param, 'json', callback, beforeSend, complete, true, sUser);
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
                    주문취소내역
                    <span class="span-title-subsentence">주문 취소 내역을 조회 할 수 있습니다.</span>
                </p>
            </div>

            <%--    <!--입금현황은 탭인지 무엇인지 몰겠음. -->
        <div>
            <a><img src="" alt="입금현황"/></a> 
        </div--%>

            <!--상단영역 시작-->
            <div class="search-div">
                <table id="tblSearchList" class="tbl_main">
                    <colgroup>
                        <col style="width:200px;"/>
                        <col />
                        <col style="width:200px;"/>
                        <col />
                        <col style="width:200px;"/>
                        <col />
                    </colgroup>
                    <thead>
                        <tr>
                            <th colspan="6">취소현황</th>
                        </tr>
                    </thead>
                    <tr>
                        <th>주문일</th>
                        <td colspan="3">
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
                        <th>판매사</th>
                        <td>
                            <asp:TextBox runat="server" ID="txtSaleCompanyName" CssClass="medium-size"></asp:TextBox></td>
                    </tr>
                    <tr>
                        <th>결제수단</th>
                        <td>
                            <asp:DropDownList runat="server" ID="ddlPay" CssClass="medium-size">
                                <asp:ListItem Value="all">---전체---</asp:ListItem>
                            </asp:DropDownList></td>


                        <th>진행구분</th>
                        <td>
                            <asp:DropDownList runat="server" ID="ddlAsStatus" CssClass="medium-size">
                                <asp:ListItem Value="all">---전체---</asp:ListItem>
                            </asp:DropDownList></td>
                        <th>구매사</th>
                        <td>
                            <asp:TextBox runat="server" ID="txtBuySaleName" CssClass="medium-size"></asp:TextBox></td>
                    </tr>

                </table>
            </div>
            <!--상단영역 끝-->

            <!--조회하기 버튼-->
            <div class="bt-align-div">
                <input type="button" class="mainbtn type1" style="width: 95px; height: 30px;" value="조회하기" onclick="fnSearch(1); return false;" />
            </div>
            <span style="color: #69686d; float: right; margin-top: 10px; margin-bottom: 10px;">*<b style="color: #ec2029; font-weight: bold;"> VAT(부가세)포함 가격</b>입니다.</span>

            <!--하단영역시작-->
            <div class="list-div">
                <div class="list-table">
                    <table id="list-table" class="tbl_main">
                        <colgroup class="">
                            <col style="width: 77px;" />
                            <!--구분-->
                            <col style="width: 87px;" />
                            <!--주문취소일자-->
                            <col style="width: 80px;" />
                            <!--구매사-->
                            <col style="width: 80px;" />
                            <!--판매사-->
                            <col style="width: 80px;" />
                            <!--예산부서-->
                            <col style="width: 300px;" /> 
                            <!--주문일자-->
                            <col style="width: 87px;" /> <%--여기가 모델명 --%>
                            <!--주문상품정보-->
                            <col style="width: 87px;" />
                            <!--모델명-->
                            <col style="width: 105px;" />
                            <!--모델명-->
                            <col style="width: 77px;" />
                            <!--상품금액-->
                            <col style="width: 64px;" />
                            <!--취소수량-->
                            <col style="width: 64px;" />
                            <!--주문취소금액-->
                            <col style="width: 64px;" />
                            <!--취소사유-->
                            <col style="width:150px;" />
                            <!--결제수단-->
                        </colgroup>
                        <thead>
                            <tr>
                                <th rowspan="2">구분</th>
                                <th>주문취소일자</th>
                                <th>구매사</th>
                                <th rowspan="2">판매사</th>
                                <th>주문일자</th>
                                <th rowspan="2">주문상품정보</th>
                                <th rowspan="2">모델명</th>
                                <th>최소수량 / 내용량</th>
                                <th>상품금액</th>
                                <th rowspan="2">취소사유</th>
                                <th rowspan="2">결제수단</th>
                            </tr>
                            <tr>
                                <th>주문취소번호</th>
                                <th>주문자<br />-아이디-</th>
                                <th>주문번호</th>
                                <th>취소수량</th>
                                <th>취소금액</th>
                            </tr>
                        </thead>
                        <tbody>
                        </tbody>
                    </table>
                </div>
                <input type="hidden" id="hdTotalCount" />
                <br />
                <!-- 페이징 처리 -->
                <div style="margin: 0 auto; text-align: center">
                    <div id="pagination" class="page_curl" style="display: inline-block"></div>
                </div>
                <!--하단영역끝-->

                <!--엑셀 저장-->
                <div class="bt-align-div">
                    <asp:Button ID="btnExcelExport" runat="server" Width="95" Height="30" Text="엑셀 저장" OnClick="btnExcelExport_Click" CssClass="mainbtn type1"/>
                </div>
            </div>
        </div>
    </div>
</asp:Content>

