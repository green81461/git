<%@ Page Title="" Language="C#" MasterPageFile="~/AdminSub/Master/AdminSubMaster.master" AutoEventWireup="true" CodeFile="OrderBillIssue.aspx.cs" Inherits="AdminSub_Order_OrderBillIssue" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <link href="../../AdminSub/Contents/Order/order.css" rel="stylesheet" />
    <script src="../../Scripts/jquery.inputmask.bundle.js"></script>

    <script>
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

            fnSearch(1); //조회하기
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
        //조회하기
        function fnSearch(pageNum) {
            var startDate = $('#<%= txtSearchSdate.ClientID%>').val();
            var endDate = $('#<%= txtSearchEdate.ClientID%>').val();
            var buyCompNm = $('#<%= txtBuyCompName.ClientID%>').val();
            var pageSize = 20;
            var asynTable = "";

            var callback = function (response) {

                $("#tbodyBill").empty();

                if (!isEmpty(response)) {

                    $.each(response, function (key, value) {

                        if (key == 0) $('#hdTotalCount').val(value.TotalCount);

                        asynTable += "<tr>";
                        asynTable += "<td rowspan='2'>" + value.RowNumber + "</td>";
                        asynTable += "<td>" + fnOracleDateFormatConverter(value.EntryDate) + "</td>";
                        asynTable += "<td>" + value.BuyCompany_Name + "</td>";
                        asynTable += "<td rowspan='2'>" + value.GoodsFinalName + "</td>";
                        asynTable += "<td rowspan='2'>" + numberWithCommas(value.GoodsSalePriceVat) + "원" + "</td>";
                        asynTable += "<td>" + value.OrderStatus_NAME + "</td>";
                        asynTable += "<td>" + value.BillNo + "</td>";
                        asynTable += "<td>" + value.zBillNo + "</td>";
                        asynTable += "</tr>";
                        //------------------------------------------------------------------------------
                        asynTable += "<tr>";
                        asynTable += "<td>" + value.OrderCodeNo + "</td>";
                        asynTable += "<td>" + value.Name + "</td>";
                        asynTable += "<td>" + value.PayWay + "</td>";

                        var billNo = value.BillNo;
                        var zBillNo = value.zBillNo;
                        var MD5 = value.MD5;
                        var zMD5 = value.zMD5;
                        var tdMD5Bill = '';
                        var tdZMD5Bill = '';

                        //과세
                        if (isEmpty(billNo) || isEmpty(MD5)) {
                            tdMD5Bill = "<span style='color:red;'>진행중</span>";

                        } else {
                            tdMD5Bill = "<a onClick='fnBillDirect(this, \"MD5\")'><input type='hidden' id='hdMD5' value='" + MD5 + "'/><input type='hidden' id='hdbillNo' value='" + billNo + "'/>"
                                + "<img src='../Images/Order/goDirect-on.jpg' alt='바로가기' onmouseover=\"this.src='../Images/Order/goDirect-off.jpg'\" onmouseout=\"this.src='../Images/Order/goDirect-on.jpg'\"></a>";
                        }
                        //면세
                        if (!isEmpty(zBillNo) && !isEmpty(zMD5)) {
                            tdZMD5Bill = "<a onClick='fnBillDirect(this, \"ZMD5\")'><input type='hidden' id='hdZMD5' value='" + zMD5 + "'/><input type='hidden' id='hdZBillNo' value='" + zBillNo + "'/>"
                                + "<img src='../Images/Order/goDirect-on.jpg' alt='바로가기' onmouseover=\"this.src='../Images/Order/goDirect-off.jpg'\" onmouseout=\"this.src='../Images/Order/goDirect-on.jpg'\"></a>";
                        }

                        asynTable += "<td>" + tdMD5Bill + "</td>";
                        asynTable += "<td>" + tdZMD5Bill + "</td>";
                        asynTable += "</tr>";

                    });

                } else {
                    asynTable += "<tr><td colspan='8'>" + "리스트가 없습니다." + "</td></tr>";
                }

                $("#tbodyBill").append(asynTable);

                fnCreatePagination('pagination', $("#hdTotalCount").val(), pageNum, pageSize, getPageData);
            }

            var param = { SvidUser: '<%= Svid_User%>', TodateB: startDate, TodateE: endDate, BuyCompNm: buyCompNm, PageNo: pageNum, PageSize: pageSize, Method: 'OrderBillIssue_A' };
            JajaxSessionCheck('Post', '../../Handler/OrderHandler.ashx', param, 'json', callback, '<%= Svid_User%>');
        }
        function getPageData() {
            var container = $('#pagination');
            var getPageNum = container.pagination('getSelectedPageNum');
            fnSearch(getPageNum);
            return false; hdTotalCount
        }

        //바로가기
        function fnBillDirect(el, billFlag) {
            var billNo = $(el).find("#hdbillNo").val();
            var zBillNo = $(el).find("#hdZBillNo").val();
            var MD5 = $(el).find("#hdMD5").val();
            var zMD5 = $(el).find("#hdZMD5").val();
            var url = '';

            if (billFlag == "MD5") url = "http://www.sendbill.co.kr/PreView?seq=" + billNo + "&cert=" + MD5 + "&VenderCheck=N&PR_DIV=R";
            if (billFlag == "ZMD5") url = 'http://www.sendbill.co.kr/PreView?seq=' + zBillNo + "&cert=" + zMD5 + "&VenderCheck=N&PR_DIV=R";

            var width = 800;
            var height = 500;
            var dualScreenLeft = window.screenLeft != undefined ? window.screenLeft : screen.left;
            var dualScreenTop = window.screenTop != undefined ? window.screenTop : screen.top;

            var getwidth = window.innerWidth ? window.innerWidth : document.documentElement.clientWidth ? document.documentElement.clientWidth : screen.width;
            var getheight = window.innerHeight ? window.innerHeight : document.documentElement.clientHeight ? document.documentElement.clientHeight : screen.height;

            var left = ((getwidth / 2) - (width / 2)) + dualScreenLeft;
            var top = ((getheight / 2) - (height / 2)) + dualScreenTop;

            window.open(url, '', "width=" + width + ",height=" + height + ",status=no ,toolbar=no,menubar=no,location=no,resizable=yes,scrollbars=yes,left=" + left + ", top=" + top + "");

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

    <div class="sub-contents-div">

        <!--제목 타이틀-->
            <div class="sub-title-div">
                <p class="p-title-mainsentence">
                    전자세금계산서 발행현황(구매사)
                    <span class="span-title-subsentence"></span>
                </p>
            </div>

        <div class="search-div">
            <table class="report-table" id="tblHistoryList">
                <tr class="board-tr-height" style="height: 30px; width: 200px;">
                    <th colspan="2" class="txt-center">조회기간</th>
                    <td>
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
                <tr>
                    <th colspan="2" style="width: 150px;">구매사</th>
                    <td>
                        <asp:TextBox runat="server" ID="txtBuyCompName" Width="50%" Height="90%" Onkeypress="return fnEnter();" Style="border: 1px solid #a2a2a2"></asp:TextBox>
                    </td>
                </tr>
            </table>

            <!--조회하기버튼영역-->
            <div class="align-div" style="text-align: right; margin-top: 10px; margin-bottom: 10px;">
                <input type="button" class="mainbtn type1" value="조회하기" style="width:95px; height:30px" onclick="fnSearch(1); return false;"/>
            </div>
            <span style="color: #69686d; float: right; margin-top: 10px; margin-bottom: 10px;">*<b style="color: #ec2029; font-weight: bold;"> VAT(부가세)포함 가격</b>입니다.</span>
        </div>

        <div style="margin-top: 30px;">
            <table border="1" style="width: 100%" class="report-table" id="tblSearch">
                <thead>
                    <tr>
                        <th style="width: 30px;" rowspan="2">번호</th>
                        <th style="width: 120px;">주문일자</th>
                        <th style="width: 180px;">구매사</th>
                        <th style="width: 270px;" rowspan="2">주문상품정보</th>
                        <th style="width:100px" rowspan="2">구매가격</th>
                        <th class="auto-style2">주문처리현황</th>
                        <th class="auto-style2">세금계산서번호</th>
                        <th class="auto-style2">[면세]<br>계산서번호</th>
                    </tr>
                    <tr>
                        <th>주문번호</th>
                        <%--<th>주문자<br />(요청자)</th>--%>
                        <th>주문자</th>
                        <%--<th>예산계정</th>--%>
                        <th class="text-center">결제수단</th>
                        <th class="text-center">세금계산서상세</th>
                        <th class="text-center">계산서상세</th>
                    </tr>
                </thead>
                <tbody id="tbodyBill">
                </tbody>
            </table>
        </div>
        <input type="hidden" id="hdTotalCount" />
        <br />
        <!-- 페이징 처리 -->

        <div style="margin: 0 auto; text-align: center">
            <div id="pagination" class="page_curl" style="display: inline-block"></div>
        </div>

    </div>

</asp:Content>

