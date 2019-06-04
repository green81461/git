<%@ Page Title="" Language="C#" MasterPageFile="~/Master/Default.master" AutoEventWireup="true" CodeFile="OrderBillIssue.aspx.cs" Inherits="Order_OrderBillIssue" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <link href="pagination.css" rel="stylesheet" type="text/css">
    <link href="../Content/Order/order.css" rel="stylesheet" />
    <script src="pagination.js"></script>
    <script src="../Scripts/jquery.inputmask.bundle.js"></script>


    <script type="text/javascript">
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
                buttonImage:/* "/Images/icon_calandar.png"*/"../Images/Goods/calendar.jpg",
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
                buttonImage:/* "/Images/icon_calandar.png"*/"../Images/Goods/calendar.jpg",
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
            fnInitBillNo();
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


        //조회하기
        function fnSearch(pageNum) {
            var startDate = $('#<%= txtSearchSdate.ClientID%>').val();
            var endDate = $('#<%= txtSearchEdate.ClientID%>').val();
            var pageSize = 20;
            var i = 1;
            var asynTable = "";

            var callback = function (response) {
                var newRowContent = '';
                $("#tblSearch tbody").empty();
                if (!isEmpty(response)) {
                    $.each(response, function (key, value) {

                        var goodsSalePriceVat = value.GoodsSalePriceVat + "";
                        var billNo = value.BillNo;

                        var MD5 = value.MD5;
                        var zMD5 = value.zMD5;
                        $('#hdTotalCount').val(value.TotalCount);


                        if (billNo == "" || billNo == null) {
                            billNo = "";
                        }

                        var zbillNo = value.zBillNo;
                        if (zbillNo == "" || zbillNo == null) {
                            zbillNo = "";
                        }

                        var setMD5Style = '';
                        var setStyleP = 'style="display:none"'
                        if (MD5 == '') {
                            setMD5Style = 'style="display:none"'
                            setStyleP = 'style="display:inline-block"'
                        }

                        var setStyle = '';

                        if (zMD5 == '') {
                            setStyle = 'style="display:none"'

                        }

                        //if (response[i].MD5 != null) {
                        //    MD5 = response[i].MD5;
                        //}

                        //if (response[i].zMD5 != null) {
                        //    zMD5 = response[i].zMD5;
                        //}


                        asynTable += "<tr><td class='border-right' rowspan='2'>" + (pageSize * (pageNum - 1) + i) + "</td>" + "<td class='border-right'>" + value.EntryDate.split("T")[0] + "</td><td class='border-right' rowspan='2'>" + value.Name + "</td> <td class='border-right' rowspan='2'>" + value.OrderSaleCompanyName + "</td> <td class='border-right' rowspan='2'>" + value.GoodsFinalName + "</td><td class='border-right' rowspan='2' style='padding-right:5px; text-align:right;'>"
                            + goodsSalePriceVat.replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,') + "원</td><td class='border-right'>" + value.OrderStatus_NAME + "</td><td class='border-right' id='tdBillNo'>" + billNo + "</td><td>" + zbillNo + "</td></tr><tr>"
                            + "<td class='border-right'>" + value.OrderCodeNo + "</td>" + "<td class='border-right'>" + value.PayWay + "</td><td class='border-right'><p " + setStyleP + " id=hding> 진행중</p><a id='btnOrderBill' onClick='fnDirect(this); return;'><img src='../Images/Order/goDirect-on.jpg' alt='바로가기' " + setMD5Style + "  onmouseover=\"this.src='../Images/Order/goDirect-off.jpg'\" onmouseout=\"this.src='../Images/Order/goDirect-on.jpg'\"></a><input type='hidden' id='hdMD5' value='" + value.MD5 + "'/><input type='hidden' id='hdbillNo' value='" + billNo + "'/></td> <td><a id='btnOrderBill' onClick='fnZDirect(this); return;'><img src='../Images/Order/goDirect-on.jpg' alt='바로가기' " + setStyle + " onmouseover=\"this.src='../Images/Order/goDirect-off.jpg'\" onmouseout=\"this.src='../Images/Order/goDirect-on.jpg'\"></a><input type='hidden' id='hdzMD5' value='" + value.zMD5 + "'/><input type='hidden' id='hdzMD5' value='" + value.zMD5 + "'/><input type='hidden' id='hdzbillNo' value='" + zbillNo + "'/> </td></tr>";
                        i++;
                    });






                    //asynTable += "<tr><td rowspan='2'>" + (pageSize * (pageNum - 1) + i) + "</td>" + "<td>" + value.EntryDate.split("T")[0] + "</td><td>" + value.OrderCodeNo + "</td><td>" + value.GoodsFinalName + "</td><td>"
                    //    + goodsSalePriceVat.replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,') + "원</td><td>" + value.OrderStatus_NAME + "</td><td>" + value.Name + "</td>"
                    //    + "<td>" + value.OrderSaleCompanyName + "</td><td>" + value.PayWay + "</td><td id='tdBillNo'>" + billNo + "</td><td><a id='btnOrderBill' onClick='fnDirect(this); return;'><img src='../Images/Order/goDirect-on.jpg' alt='바로가기' onmouseover=\"this.src='../Images/Order/goDirect-off.jpg'\" onmouseout=\"this.src='../Images/Order/goDirect-on.jpg'\"></a><input type='hidden' id='hdMD5' value='" + value.MD5 + "'/></td></tr>";
                    //i++;








                } else {
                    asynTable += "<tr><td colspan='20'>" + "리스트가 없습니다." + "</td></tr>";
                }
                $("#tblSearch tbody").append(asynTable);

                fnInitBillNo();

                if ($("#hdTotalCount").val() == '') {
                    return false;
                }

                fnCreatePagination('pagination', $("#hdTotalCount").val(), pageNum, 20, getPageData);

            }

            param = { SvidUser: '<%= Svid_User%>', TodateB: startDate, TodateE: endDate, Method: 'OrderBillIssue', PageNo: pageNum, PageSize: pageSize };
            Jajax('Post', '../../Handler/OrderHandler.ashx', param, 'json', callback);
        }

        function getPageData() {
            var container = $('#pagination');
            var getPageNum = container.pagination('getSelectedPageNum');
            fnSearch(getPageNum);
            return false; hdTotalCount
        }

        function fnInitBillNo() {
            $('#tblSearch tbody tr').each(function (index, element) {
                var BillNo = $("#tdBillNo").text();
                if (BillNo == '진행중') {
                    $(element).find("#btnOrderBill").css("visibility", 'hidden');
                } else {
                    $(element).find("#btnOrderBill").css("visibility", 'visible');
                }
            });
        }


        function fnDirect(event) {
            if (billNo != '진행중') {
                var billNo = $(event).parent().parent().find("#hdbillNo").val();
                var MD5 = $(event).parent().parent().find("#hdMD5").val();

                var url = 'http://www.sendbill.co.kr/PreView?seq=' + billNo + "&cert=" + MD5 + "&VenderCheck=N&PR_DIV=R";

                var width = 800;
                var height = 500;
                var dualScreenLeft = window.screenLeft != undefined ? window.screenLeft : screen.left;
                var dualScreenTop = window.screenTop != undefined ? window.screenTop : screen.top;

                var getwidth = window.innerWidth ? window.innerWidth : document.documentElement.clientWidth ? document.documentElement.clientWidth : screen.width;
                var getheight = window.innerHeight ? window.innerHeight : document.documentElement.clientHeight ? document.documentElement.clientHeight : screen.height;

                var left = ((getwidth / 2) - (width / 2)) + dualScreenLeft;
                var top = ((getheight / 2) - (height / 2)) + dualScreenTop;

                window.open(url, '', "width=" + width + ",height=" + height + ",status=no ,toolbar=no,menubar=no,location=no,resizable=yes,scrollbars=yes,left=" + left + ", top=" + top + "");

                //var url = 'http://www.sendbill.co.kr/PreView?seq=' + billNo + "&cert=" + MD5 + "&VenderCheck=N&PR_DIV=R";
                //fnWindowOpen(url, '', 800, 500, 'yes', 'no', 'no', 'no', 'yes', 'yes');
                // window.open(url, '', "height=" + height + ", width=" + width + ",status=yes,toolbar=no,menubar=no,location=no,resizable=no, scrollbars=yes,left=" + popupX + ", top=" + popupY + ", screenX=" + popupX + ", screenY= " + popupY + "");
                return false;

            }
            //if (billNo != '진행중')
            //{
            //    location.href = "http://www.sendbill.co.kr/PreView?seq=" + billNo + "&cert=" + MD5 + "&VenderCheck=N&PR_DIV=R";
            //} 
        }


        function fnZDirect(event) {
            if (zbillNo != '진행중') {

                var zbillNo = $(event).parent().parent().find("#hdzbillNo").val();
                var zMD5 = $(event).parent().parent().find("#hdzMD5").val();

                var url = 'http://www.sendbill.co.kr/PreView?seq=' + zbillNo + "&cert=" + zMD5 + "&VenderCheck=N&PR_DIV=R";

                var width = 800;
                var height = 500;
                var dualScreenLeft = window.screenLeft != undefined ? window.screenLeft : screen.left;
                var dualScreenTop = window.screenTop != undefined ? window.screenTop : screen.top;

                var getwidth = window.innerWidth ? window.innerWidth : document.documentElement.clientWidth ? document.documentElement.clientWidth : screen.width;
                var getheight = window.innerHeight ? window.innerHeight : document.documentElement.clientHeight ? document.documentElement.clientHeight : screen.height;

                var left = ((getwidth / 2) - (width / 2)) + dualScreenLeft;
                var top = ((getheight / 2) - (height / 2)) + dualScreenTop;

                window.open(url, '', "width=" + width + ",height=" + height + ",status=no ,toolbar=no,menubar=no,location=no,resizable=no,scrollbars=yes,left=" + left + ", top=" + top + "");




                //var url = 'http://www.sendbill.co.kr/PreView?seq=' + zbillNo + "&cert=" + zMD5 + "&VenderCheck=N&PR_DIV=R";
                //fnWindowOpen(url, '', 800, 500, 'yes', 'no', 'no', 'no', 'yes', 'yes');
                //  window.open(url, '', "height=" + height + ", width=" + width + ",status=yes,toolbar=no,menubar=no,location=no,resizable=no, scrollbars=yes,left=" + popupX + ", top=" + popupY + ", screenX=" + popupX + ", screenY= " + popupY + "");
                return false;

            }
            //if (billNo != '진행중')
            //{
            //    location.href = "http://www.sendbill.co.kr/PreView?seq=" + billNo + "&cert=" + MD5 + "&VenderCheck=N&PR_DIV=R";
            //} 
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
            <div class="sub-title-div">
                <img src="/images/OrderBillIssue_nam.png" />
           <%-- <p class="p-title-mainsentence">
                계산서발행
                       <span class="span-title-subsentence">계산서를 조회 및 발행 할 수 있습니다.</span>
            </p>--%>
        </div>

        <div>
            <table class="tbl_search" id="tblHistoryList">
                <tr>
                    <th colspan="2">조회기간</th>
                    <td colspan="6" class="align-left">
                        <asp:TextBox ID="txtSearchSdate" type="date" runat="server" MaxLength="10" CssClass="calendar" onkeypress="return fnEnterDate();" placeholder="2018-01-01" ReadOnly="true"></asp:TextBox>
                        -
                            <asp:TextBox ID="txtSearchEdate" type="date" runat="server" MaxLength="10" CssClass="calendar" onkeypress="return fnEnterDate();" placeholder="2018-12-30" ReadOnly="true"></asp:TextBox>
                        &nbsp;&nbsp;&nbsp;
                            <input type="checkbox" style="vertical-align:middle;" name="chkBox" id="ckbSearch1" value="1" checked="checked" /><label for="ckbSearch1">1일</label>
                        <input type="checkbox" style="margin-left:5px; vertical-align:middle;" name="chkBox" id="ckbSearch2" value="7" /><label for="ckbSearch2">7일</label>
                        <input type="checkbox" style="margin-left:5px; vertical-align:middle;" name="chkBox" id="ckbSearch3" value="15" /><label for="ckbSearch3">15일</label>
                        <input type="checkbox" style="margin-left:5px; vertical-align:middle;" name="chkBox" id="ckbSearch4" value="30" /><label for="ckbSearch4">30일</label>
                        <input type="checkbox" style="margin-left:5px; vertical-align:middle;" name="chkBox" id="ckbSearch5" value="90" /><label for="ckbSearch5">90일</label>
                        <input type="checkbox" style="margin-left:5px; vertical-align:middle;" name="chkBox" id="ckbSearch6" value="0" /><label for="ckbSearch6">직접입력</label>
                    </td>
                </tr>


            </table>

            <!--조회하기버튼영역-->
            <div class="align-div" style="text-align: right;">
                <input type="button" id="btnTab1" class="mainbtn type1" style="width:117px; height:30px; font-size:12px" value="조회하기" onclick="fnSearch(1); return false;"/>
                <%--<a>
                    <img src="../Images/Document/search-bt-off.jpg" alt="조회하기" onclick="fnSearch(1);return false;" onmouseover="this.src='../Images/Document/search-bt-on.jpg'" onmouseout="this.src='../Images/Document/search-bt-off.jpg'"></a>--%>
            </div>

            <span style="color: #69686d; float: right; margin-top: 10px; margin-bottom: 10px;">*<b style="color: #ec2029; font-weight: bold;"> VAT(부가세)포함 가격</b>입니다.</span>

        </div>


        <div style="margin-top: 30px;">
            <table style="width: 100%" class="tbl_main tbl_main2" id="tblSearch">
                <thead>
                    <tr>
                        <th rowspan="2" class="border-right">번호</th>
                        <th class="border-right">주문일자</th>
                        <th rowspan="2" class="border-right">주문자</th>
                        <th rowspan="2" class="border-right">판매사</th>
                        <th rowspan="2" class="border-right">상품정보</th>
                        <th rowspan="2" class="border-right">구매가격</th>
                        <th class="border-right">주문처리현황</th>
                        <th class="border-right">세금계산서번호</th>
                        <th>[면세] 계산서번호</th>
                    </tr>
                    <tr>
                        <th class="border-right">주문번호</th>
                        <th class="border-right">결제수단</th>
                        <th class="border-right">세금계산서상세</th>
                        <th>계산서상세</th>
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
         <div class="left-menu-wrap" id="divLeftMenu">
	            <dl>
		            <dt style="border-bottom:1px solid #eaeaea;">
			            <strong>마이페이지</strong>
		            </dt>
		            <dd>
                        <a href="/Order/OrderHistoryList.aspx">주문조회</a> 
                    </dd>
                    <dd>
                        <a href="/Delivery/DeliveryOrderList.aspx">배송조회</a> 
                    </dd>
                    <dd   class="active">
                        <a href="/Order/OrderBillIssue.aspx">세금계산서 조회</a> 
                    </dd>
                    <dd>
                        <a href="/Member/MemberEditCheck.aspx">마이정보변경</a> 
                    </dd>
                    <dd>
                        <a href="/Delivery/DeliveryList.aspx">배송지관리</a> 
                    </dd>
	            </dl>
            </div>
		</div>
        
   
</asp:Content>

