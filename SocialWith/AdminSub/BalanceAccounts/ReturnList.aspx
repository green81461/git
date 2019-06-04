<%@ Page Title="" Language="C#" MasterPageFile="~/AdminSub/Master/AdminSubMaster.master" AutoEventWireup="true" CodeFile="ReturnList.aspx.cs" Inherits="AdminSub_BalanceAccounts_ReturnList" %>

<%@ Import Namespace="Urian.Core" %>
<%@ Register Src="~/UserControl/ucListControl.ascx" TagName="ListPager" TagPrefix="ucPager" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <link href="../Contents/Goods/as.css" rel="stylesheet" />
    <script src="../../Scripts/jquery.inputmask.bundle.js"></script>

    <style>
        .sub-tab-div a:nth-child(2) {
            margin-left: -2.5px;
        }

        .sub-tab-div a:nth-child(3) {
            margin-left: -2.5px;
        }
    </style>
    <script>

          var qs = fnGetQueryStrings();
        var ucode = qs["ucode"];
        $(document).ready(function () {
            //체크박스 하나만 선택
            $("#<%=this.txtSearchSdate.ClientID%>").inputmask("9999-99-99");
            $("#<%=this.txtSearchEdate.ClientID%>").inputmask("9999-99-99");

            var tableid = 'Search-table';
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

            $('#Search-table input[type="checkbox"]').change(function () {
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

            $('.div-main-tab > ul > li').click(function () {
                if ($(this).attr('id') == 'libs') {
                    $(this).attr('onClick', "location.href='BalanceSummary.aspx?ucode="+ucode+"'");
                    $(this).find('a').attr('href', 'BalanceSummary.aspx?ucode='+ucode+'');
                }
                else if ($(this).attr('id') == 'lipl') {
                    $(this).attr('onClick', "location.href='ProfitList.aspx?ucode="+ucode+"'");
                    $(this).find('a').attr('href', 'ProfitList.aspx?ucode='+ucode+'');
                }
                else if ($(this).attr('id') == 'lirl') {
                    $(this).attr('onClick', "location.href='ReturnList.aspx?ucode="+ucode+"'");
                    $(this).find('a').attr('href', 'ReturnList.aspx?ucode='+ucode+'');
                }
                else if ($(this).attr('id') == 'liob') {
                    $(this).attr('onClick', "location.href='OrderBillIssueCheck.aspx?ucode="+ucode+"'");
                    $(this).find('a').attr('href', 'OrderBillIssueCheck.aspx?ucode='+ucode+'');
                }
                else if ($(this).attr('id') == 'lipay') {
                    $(this).attr('onClick', "location.href='BillPayment.aspx?ucode="+ucode+"'");
                    $(this).find('a').attr('href', 'BillPayment.aspx?ucode='+ucode+'');
                }
            })
        });

        // enter key 방지
        $(document).on("keypress", "#Search-table input", function (e) {
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
            var status = $('#<%=ddlReturnStatus.ClientID %>').val();
            var buyComp = $('#<%=txtBuySaleName.ClientID %>').val();
            var pageSize = 20;
            var i = 1;
            var asynTable = "";

            var callback = function (response) {
                $("#list-table tbody").empty();



                if (!isEmpty(response)) {
                    $.each(response, function (key, value) {



                        var TotalAmt = parseInt(value.SaleAmt) - (parseInt(value.CustAmt) + parseInt(value.SupplyJung) + parseInt(value.BillJung) + parseInt(value.PgJung));




                        var src = '/GoodsImage' + '/' + value.GoodsFinalCategoryCode + '/' + value.GoodsGroupCode + '/' + value.GoodsCode + '/' + value.GoodsFinalCategoryCode + '-' + value.GoodsGroupCode + '-' + value.GoodsCode + '-sss.jpg';
                        $("#hdTotalCount").val(value.TotalCount);

                        asynTable += "<tr>"
                        asynTable += "<td rowspan='2' style='border:1px solid #a2a2a2;'>" + value.RowNum + "</td>";
                        asynTable += "<td rowspan='2' style='border-right:1px solid #a2a2a2'>" + fnOracleDateFormatConverter(value.PayDate) + "</td>";
                        asynTable += "<td style='border-right:1px solid #a2a2a2'>" + fnOracleDateFormatConverter(value.RtnChg_EntryDate) + "</td>";
                        asynTable += "<td style='border:1px solid #a2a2a2;'>" + value.BuyCompanyName + "</td>";
                        asynTable += "<td style= 'text-align:left; padding-left:5px; border:1px solid #a2a2a2;' rowspan='2'><table style='width:100%;' id='tblGoodsInfo'><tr><td rowspan='2' style='width:20%; border:0;'><img src=" + src + " onerror='no_image(this, \"s\")' style='width:50px; height=50px; border:0;'/></td><td style='text-align:left; border:0;'>" + value.GoodsCode + "</td></tr><tr><td style='text-align:left; border:0;'>" + "[" + value.BrandName + "] " + value.GoodsFinalName + "<br/><span style='color:#368AFF'>" + value.GoodsOptionSummaryValues + "</span></td></tr></table></td>";
                        asynTable += "<td rowspan='2' class='txt-center'> " + value.GoodsModel + "</td >";
                        asynTable += "<td class='txt-center'> " + value.GoodsUnitMoq + " / " + value.GoodsUnitName + "</td >";
                        asynTable += "<td rowspan='2' style='border:1px solid #a2a2a2; text-align:right; padding-left:3px'>" + numberWithCommas(value.SaleAmt) + "원</td>";
                        asynTable += "<td rowspan='2' style='border:1px solid #a2a2a2; text-align:right; padding-left:3px'>" + numberWithCommas(value.CustAmt) + "원 " + "<br/><span>(" + value.PaywayName + ")  </td>";
                        asynTable += "<td rowspan='2' style='border:1px solid #a2a2a2; text-align:right; padding-left:3px'>" + numberWithCommas(value.SupplyJung) + "원</td>";
                        asynTable += "<td rowspan='2' style='border:1px solid #a2a2a2; text-align:right; padding-left:3px'>" + numberWithCommas(value.BillJung) + "원</td>";
                        asynTable += "<td rowspan='2' style='border:1px solid #a2a2a2; text-align:right; padding-left:3px'>" + numberWithCommas(value.PgJung) + "원</td>";
                        asynTable += "<td rowspan='2' style='border:1px solid #a2a2a2; text-align:right; padding-left:3px'>" + numberWithCommas(TotalAmt) + "원</td></tr>";

                        //-----------------------------------------------------------------다음행-----------------------------------------------------------------------------------------------------------//
                        asynTable += "<tr>"
                        asynTable += "<td style= 'border-bottom:1px solid #a2a2a2;'> " + value.ReturnChangeCodeNo + "</td > ";
                        asynTable += "<td style= 'border-bottom:1px solid #a2a2a2;' > " + value.UserName + "</td > ";
                        asynTable += "<td style='border-bottom:1px solid #a2a2a2'>" + value.Qty + "</td></tr>";
                        i++;

                    });
                } else {
                    asynTable += "<tr><td colspan='13' class='txt-center'>" + "조회된 반품내역이 없습니다." + "</td></tr>"
                    $("#hdTotalCount").val(0);
                }
                $("#list-table tbody").append(asynTable);
                fnCreatePagination('pagination', $("#hdTotalCount").val(), pageNum, 20, getPageData);
            }

            var sUser = '<%= Svid_User%>';
            var param = { SvidUser: sUser, Status: status, TodateB: startDate, TodateE: endDate, BuyComp: buyComp, Flag: 'ReturnList_A', PageNo: pageNum, PageSize: pageSize };
            JajaxSessionCheck('Post', '../../Handler/ReturnExchangeHandler.ashx', param, 'json', callback, sUser);
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
                    정산내역조회
                    <span class="span-title-subsentence"></span>
                </p>
            </div>

            <!--탭메뉴-->
            <div class="div-main-tab" style="width: 100%; ">
                <ul>
                    <li id="libs"  class='tabOff' style="width: 185px;">
                        <a>정산요약</a>
                    </li>
                    <li id="lipl" class='tabOff' style="width: 185px;">
                        <a>매출정산내역</a>
                    </li>
                    <li id="lirl" class='tabOn' style="width: 185px;">
                        <a>반품내역</a>
                    </li>
                    <li id="liob"  class='tabOff' style="width: 185px;">
                        <a>전자세금계산서 발행내역</a>
                    </li>
                    <li id="lipay"  class='tabOff' style="width: 185px;">
                        <a>대금정산</a>
                    </li>
                </ul>
            </div>



            <!--상단 조회 영역 시작-->
            <div class="search-div">
                <table id="Search-table">
                    <thead>
                        <tr>
                            <th colspan="7">반품 조회</th>
                        </tr>
                    </thead>

                    <tr>
                        <th style="width: 100px;">조회기간</th>
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
                        <th style="width: 100px;">결제수단</th>
                        <td style="width: 300px;">
                            <asp:DropDownList runat="server" ID="ddlReturnStatus" CssClass="input-drop">
                                <asp:ListItem Value="all">---전체---</asp:ListItem>
                            </asp:DropDownList>
                        </td>
                    </tr>
                    <tr>
                        <%--<th>구매사</th>
						<td >
							<asp:TextBox runat="server" ID="txtBuySaleName" Width="100%" style="border:1px solid #a2a2a2; height:90%;"  onkeypress="return fnEnter();"></asp:TextBox>
						</td>--%>
                        <th>구매사</th>
                        <td colspan="6">
                            <input type="text" runat="server" id="txtBuySaleName" class="search" placeholder="구매사를 입력하세요" style="width: 100%; height: 24px;" />
                            <%--<a><img src="../../AdminSub/Images/Goods/search-bt-off.jpg"  onmouseover="this.src='../../AdminSub/Images/Goods/search-bt-on.jpg'" onmouseout="this.src='../../AdminSub/Images/Goods/search-bt-off.jpg'" alt="검색" class="search-img"/></a>--%>
                        </td>

                    </tr>


                    <%-- <tr><th>조회기간</th>
                    <td colspan="6">  
                        <asp:TextBox ID="txtSearchSdate" runat="server" CssClass="calendar"></asp:TextBox>&nbsp;&nbsp;-&nbsp;
                        <asp:TextBox ID="txtSearchEdate" runat="server" cssclass="calendar"></asp:TextBox>&nbsp;&nbsp; 
                       <asp:CheckBoxList runat="server" ID="CheckBoxList1"  RepeatLayout="Flow" RepeatDirection="Horizontal">
                            <asp:ListItem Selected="True" Value="7" Text="7일"></asp:ListItem>
                            <asp:ListItem Value="15" Text="15일"></asp:ListItem>
                            <asp:ListItem  Value="30" Text="30일"></asp:ListItem>
                        </asp:CheckBoxList>
                    </td>
                    
                </tr>
             <tr><th>검색</th><td colspan="3"><input type="text" class="search" placeholder="검색어를 입력하세요"/>
            <a><img src="../../AdminSub/Images/Goods/search-bt-off.jpg"  onmouseover="this.src='../../AdminSub/Images/Goods/search-bt-on.jpg'" onmouseout="this.src='../../AdminSub/Images/Goods/search-bt-off.jpg'" alt="검색" class="search-img"/></a></td>
            <th>진행상태</th>
                    <td>
                      <asp:DropDownList runat="server" ID="ddlReturnStatus" CssClass="input-drop">
                          <asp:ListItem Text="전체"></asp:ListItem>
                      </asp:DropDownList>
                    </td>
             </tr>--%>
                </table>

                <div class="bt-align-div">
                    <input type="button" class="mainbtn type1" value="조회하기" style="width:95px; height:30px" onclick="fnSearch(1); return false;"/>
                </div>
            </div>
            <!--조회하기 버튼-->


            <span style="color: #69686d; float: right; margin-top: 10px; margin-bottom: 10px;">*<b style="color: #ec2029; font-weight: bold;"> VAT(부가세)포함 가격</b>입니다.</span>
            <!--상단 조회 영역 끝-->

            <!--하단영역시작-->
            <div class="list-div" style="clear: both">
                <div style="width: 100%; height: auto;">
                    <table id="list-table">
                        <%--<table id="tblSearch" class="TblSearch">--%>
                        <thead>

                            <tr>
                                <th class="text-center" rowspan="2" style="width: 50px">번호</th>
                                <th class="text-center" rowspan="2" style="width: 100px">출금날짜</th>
                                <th class="text-center" style="width: 90px">반품일자</th>
                                <th class="text-center" style="width: 90px">구매사</th>
                                <th class="text-center" style="width: 252px" rowspan="2">주문상품정보</th>
                                <th class="text-center" rowspan="2" style="width: 90px">모델명</th>
                                <th class="text-center" style="width: 105px">최소수량 / 내용량</th>
                                <th class="text-center" rowspan="2" style="width: 90px">구매사<br />
                                    반품 정산<br />
                                    (결제수단)</th>
                                <th class="text-center" rowspan="2" style="width: 90px">판매사<br />
                                    반품 정산</th>
                                <th class="text-center" rowspan="2" style="width: 90px">플랫폼<br />
                                    이용 수수료</th>
                                <%--        <th class="text-center" rowspan="2" style="width:100px">배송비<br />수수료</th>--%>
                                <th class="text-center" rowspan="2" style="width: 90px">세금계산서<br />
                                    수수료정산</th>
                                <th class="text-center" rowspan="2" style="width: 90px">PG<br />
                                    수수료정산</th>
                                <th rowspan="2" style="width: 90px">반품 대금정산</th>
                            </tr>
                            <tr>
                                <th class="auto-style1" style="width: 90px">반품번호</th>
                                <th class="auto-style1" style="width: 90px">신청자</th>
                                <th class="text-center" style="width: 90px">주문수량</th>
                            </tr>
                        </thead>
                        <tbody>
                        </tbody>
                    </table>
                </div>
            </div>
            <br />
            <input type="hidden" id="hdTotalCount" />

            <!-- 페이징 처리 -->
            <div style="margin: 0 auto; text-align: center">
                <div id="pagination" class="page_curl" style="display: inline-block"></div>
            </div>
            <!--하단영역끝-->


            <!--엑셀저장버튼-->
            <div class="bt-align-div" style="display: none">
                <asp:ImageButton ID="btnRtnExcel" runat="server" OnClick="btnRtnExcel_Click" AlternateText="엑셀저장" ImageUrl="../../Images/Cart/excel-off.jpg" onmouseover="this.src='../../Images/Cart/excel-on.jpg'" onmouseout="this.src='../../Images/Cart/excel-off.jpg'" />

            </div>
        </div>
    </div>
</asp:Content>

