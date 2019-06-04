<%@ Page Title="" Language="C#" MasterPageFile="~/AdminSub/Master/AdminSubMaster.master" AutoEventWireup="true" CodeFile="OrderCancelList.aspx.cs" Inherits="AdminSub_Order_OrderCancelList" %>

<%@ Import Namespace="Urian.Core" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <%--<link href="../Contents/Goods/as.css" rel="stylesheet" />--%>
    <link href="../Contents/Order/order.css" rel="stylesheet" />
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

        function fnEnter() {

            if (event.keyCode == 13) {
                <%--<%=Page.GetPostBackEventReference(imgSearch)%>--%>
                fnSearch(1);
                return false;
            }
            else
                return true;
        }

        //조회하기
        function fnSearch(pageNum) {
            var startDate = $('#<%= txtSearchSdate.ClientID%>').val();
             var endDate = $('#<%= txtSearchEdate.ClientID%>').val();
             var odrStat = $('#<%=ddlOrdStat.ClientID %>').val();
             var payway = $('#<%=ddlPay.ClientID %>').val();
             //var buyComp = $("#txtBuyComp").val();
             var buyComp = $('#<%=txtBuySaleName.ClientID %>').val();

            var pageSize = 20;
            var i = 1;
            var asynTable = "";

            var callback = function (response) {
                $("#tblSearch tbody").empty();

                if (!isEmpty(response)) {
                    $.each(response, function (key, value) {

                        var dlvrDate = "";
                        if (!isEmpty(dlvrDate)) {
                            dlvrDate = value.DeliveryDate.split("T")[0];
                        }
                        var src = '/GoodsImage' + '/' + value.GoodsFinalCategoryCode + '/' + value.GoodsGroupCode + '/' + value.GoodsCode + '/' + value.GoodsFinalCategoryCode + '-' + value.GoodsGroupCode + '-' + value.GoodsCode + '-sss.jpg';
                        $("#hdTotalCount").val(value.TotalCount);

                        asynTable += "<tr class='trOrder'>"
                            + "<input type= 'hidden' name= 'hdOrderCodeNo' value= '" + value.OrderCodeNo + "' />"
                            + "<input type= 'hidden' name= 'hdPayWay' value= '" + value.PayWay + "' />"
                            + "<input type= 'hidden' name= 'hdOrdStat' value= '" + value.OrderStatus + "' />"
                        asynTable += "<td rowspan='2' style='border:1px solid #a2a2a2; width:85px' class='rowColor_td'>" + value.OrderCancelStatus_Name + "</td>";
                        asynTable += "<td style='border-right:1px solid #a2a2a2; width:97px' class='rowColor_td'>" + value.CancelEntryDate.split("T")[0] + "</td>";
                        asynTable += "<td style='border:1px solid #a2a2a2; width:85px' class='rowColor_td'>" + value.OrderSaleCompanyName + "</td>";
                        asynTable += "<td style='border-right:1px solid #a2a2a2; width:105px' class='rowColor_td'>" + value.EntryDate.split("T")[0] + "</td>";
                        asynTable += "<td style= 'text-align:left; padding-left:5px; border:1px solid #a2a2a2; width:440px' rowspan='2' class='rowColor_td'><table style='width:100%;' id='tblGoodsInfo'><tr><td rowspan='2' style='width:20%; border:0;'><img src=" + src + " onerror='no_image(this, \"s\")' style='width:50px; height=50px; border:0;'/></td><td style='text-align:left; border:0;'>" + value.GoodsCode + "</td></tr><tr><td style='text-align:left; border:0;'>" + "[" + value.BrandName + "] " + value.GoodsFinalName + "<br/><span style='color:#368AFF; width:319px; word-wrap:break-word; display:block;'>" + value.GoodsOptionSummaryValues + "</span></td></tr></table></td>";
                        asynTable += "<td rowspan='2' class='rowColor_td' style='width:85px'> " + value.GoodsModel + "</td >";
                        asynTable += "<td  class='rowColor_td' style='width:85px'> " + value.GoodsUnitMoq + " / " + value.GoodsUnit + "</td >";

                        asynTable += "<td style='border:1px solid #a2a2a2; padding-right: 5px; text-align: right;  width:75px'  class='rowColor_td'>" + numberWithCommas(value.GoodsSalePriceVat) + " 원</td>";
                        asynTable += "<td rowspan='2' style='border:1px solid #a2a2a2;  width:75px' class='rowColor_td'>" + value.CancelContent + "</td>";
                        asynTable += "<td rowspan='2' style='border:1px solid #a2a2a2;  width:100px' class='rowColor_td'>" + value.PayWayName + "</td></tr>";

                        //-----------------------------------------------------------------다음행-----------------------------------------------------------------------------------------------------------//
                        asynTable += "<tr class='trOrder'>"
                            + "<input type= 'hidden' name= 'hdOrderCodeNo' value= '" + value.OrderCodeNo + "' />"
                            + "<input type= 'hidden' name= 'hdPayWay' value= '" + value.PayWay + "' />"
                            + "<input type= 'hidden' name= 'hdOrdStat' value= '" + value.OrderStatus + "' />"
                        asynTable += "<td style= 'border-bottom:1px solid #a2a2a2;' class='rowColor_td' > " + value.OrderCancelCodeNo + "</td > ";
                        asynTable += "<td style= 'border-bottom:1px solid #a2a2a2;' class='rowColor_td' > " + value.Name + "</td > ";
                        asynTable += "<td style= 'border-bottom:1px solid #a2a2a2;' class='rowColor_td' > " + value.OrderCodeNo + "</td >";
                        asynTable += "<td style='border:1px solid #a2a2a2;  width:75px' class='rowColor_td'>" + value.Qty + "</td>";
                        asynTable += "<td style='border:1px solid #a2a2a2; padding-right: 5px; text-align: right;  width:75px' class='rowColor_td'>" + numberWithCommas(value.GoodsTotalSalePriceVAT) + " 원</td></tr>";

                        i++;

                    });
                } else {
                    asynTable += "<tr><td colspan='11' class='txt-center'>" + "조회된 주문취소내역이 없습니다." + "</td></tr>"
                    $("#hdTotalCount").val(0);
                }
                $("#tblSearch tbody").append(asynTable);

                fnCreatePagination('pagination', $("#hdTotalCount").val(), pageNum, 20, getPageData);
            }

            var sUser = '<%= Svid_User%>';
            var param = { SvidUser: sUser, OrderStatus: odrStat, PayWay: payway, TodateB: startDate, TodateE: endDate, BuyComp: buyComp, Method: 'OrdCancelList_A', PageNo: pageNum, PageSize: pageSize };
            JajaxSessionCheck('Post', '../../Handler/OrderHandler.ashx', param, 'json', callback, sUser);
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
                    주문취소조회
                    <span class="span-title-subsentence">구매사가 취소한 내역을 조회 할 수 있습니다.</span>
                </p>
            </div>

            <%--    <!--입금현황은 탭인지 무엇인지 몰겠음. -->
        <div>
            <a><img src="" alt="입금현황"/></a> 
        </div--%>

            <!--상단영역 시작-->
            <div class="search-div">
                <%--<table id="Search-table">--%>
                <table id="tblHistoryList">
                    <tr>
                        <th colspan="6" style="height: 40px;">주문취소조회</th>
                    </tr>
                    <tr>
                        <th>주문일</th>
                        <td colspan="5">
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
                        <th>결제수단</th>
                        <td>
                            <asp:DropDownList runat="server" ID="ddlPay" CssClass="input-drop" Width="150px">
                                <asp:ListItem Value="all">---전체---</asp:ListItem>
                            </asp:DropDownList></td>


                        <th>진행구분</th>
                        <td>
                            <asp:DropDownList runat="server" ID="ddlOrdStat" CssClass="input-drop" Width="200px">
                                <asp:ListItem Value="all">---전체---</asp:ListItem>
                            </asp:DropDownList></td>



                        <th>구매사</th>
                        <td>
                            <%--<input type="text" id="txtBuyComp" placeholder="구매사 입력" />--%>
                            <%-- <asp:DropDownList runat="server" ID="buySaleList" CssClass="input-drop">
                                <asp:ListItem Value="saleCom">판매사</asp:ListItem>
                                <asp:ListItem Value="buyCom">구매사</asp:ListItem>
                            </asp:DropDownList>--%>
                            <asp:TextBox runat="server" ID="txtBuySaleName" Width="100%" onkeypress="return fnEnter();" CssClass="buyer-text"></asp:TextBox></td>
                    </tr>
                </table>
            </div>
            <!--상단영역 끝-->

            <!--조회하기 버튼-->
            <div class="bt-align-div">
                <input type="button" class="mainbtn type1" value="조회하기" style="width:95px; height:30px" onclick="fnSearch(1); return false;"/>
            </div>

            <!-- vat 포함 영역-->
            <span style="color: #69686d; float: right; margin-top: 10px; margin-bottom: 10px;">*<b style="color: #ec2029; font-weight: bold;"> VAT(부가세)포함 가격</b>입니다.</span>

            <!--하단영역시작-->
            <div class="list-table">
                <table id="tblSearch" class="TblSearch">
                    <thead>
                        <tr>
                            <th class="text-center" rowspan="2" style="width: 85px">구분</th>
                            <th class="text-center" style="width: 97px">주문취소일자</th>
                            <th class="text-center" style="width: 85px">구매사</th>
                            <th class="text-center" style="width: 105px">주문일자</th>
                            <th class="text-center" rowspan="2" style="width: 440px">주문상품정보</th>
                            <th class="text-center" rowspan="2" style="width: 85px">모델명</th>
                            <th class="text-center" style="width: 105px">최소수량 / 내용량</th>
                            <th class="text-center" style="width: 75px">상품가격</th>


                            <th class="text-center" rowspan="2" style="width: 75px">취소사유</th>
                            <th class="text-center" rowspan="2" style="width: 100px">결제수단</th>
                        </tr>
                        <tr>
                            <th class="text-center">주문취소번호</th>
                            <th class="text-center">주문자</th>
                            <th class="text-center">주문번호</th>
                            <th class="text-center">취소수량</th>
                            <th class="text-center">취소금액</th>

                        </tr>
                    </thead>
                    <tbody>
                    </tbody>
                </table>
            </div>

            <input type="hidden" id="hdTotalCount" />

            <!-- 페이징 처리 -->
            <div style="margin: 0 auto; text-align: center">
                <div id="pagination" class="page_curl" style="display: inline-block"></div>
            </div>
            <!--하단영역끝-->

            <!--엑셀 저장-->
            <div class="bt-align-div">
                <asp:ImageButton ID="btnExcel" runat="server" AlternateText="엑셀저장" Visible="false" ImageUrl="../../Images/Cart/excel-off.jpg" onmouseover="this.src='../../Images/Cart/excel-on.jpg'" onmouseout="this.src='../../Images/Cart/excel-off.jpg'" OnClick="btnExcel_Click" />
            </div>

        </div>

    </div>
</asp:Content>

