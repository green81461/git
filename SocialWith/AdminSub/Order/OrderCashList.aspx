<%@ Page Title="" Language="C#" MasterPageFile="~/AdminSub/Master/AdminSubMaster.master" AutoEventWireup="true" CodeFile="OrderCashList.aspx.cs" Inherits="AdminSub_Order_OrderCashList" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <link href="../Contents/Order/order.css" rel="stylesheet" />
    <script src="../../Scripts/jquery.inputmask.bundle.js"></script>

    <style>
        .profitList-div {
            width: 100%;
        }

        #tblProfitList {
            width: 100%;
        }

            #tblProfitList th {
                height: 40px;
            }
    </style>
    <script type="text/javascript">

        $(document).ready(function () {
            $("#<%=this.txtSearchSdate.ClientID%>").inputmask("9999-99-99");
            $("#<%=this.txtSearchEdate.ClientID%>").inputmask("9999-99-99");
            //검색창에서 달력 관련 기능
            $("#<%=this.txtSearchSdate.ClientID%>").datepicker({
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
                onSelect: function (dateText, inst) {         //달력에 변경이 생길 시 수행하는 함수. 
                    SetDate();
                }
            });


            //$("#searchEndDate").val((new Date()).yyyymmdd());
            $("#<%=this.txtSearchEdate.ClientID%>").datepicker({
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

            //검색창 날짜범위 선택 부분..

            $('#tblSearch input[type="checkbox"]').change(function () {
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

        });

        $(function () {
            fnSeachboxSet();
            fnProfitListBind(1);
        })

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


        function fnSeachboxSet() {
            var tableid = 'tblSearch';
            ListCheckboxOnlyOne(tableid);

            var date = new Date();
            var firstDate = new Date(date.getFullYear(), date.getMonth(), 1);

            fnPaywayBind();
        }

        function fnPaywayBind() {

            var callback = function (response) {
                for (var i = 0; i < response.length; i++) {

                    var createHtml = '';

                    if (response[i].Map_Type != 0) {
                        createHtml = '<option value="' + response[i].Map_Type + '">' + response[i].Map_Name + '</option>';
                        $('#selectPayway').append(createHtml);
                    }
                }
                return false;
            }
            var param = {
                Method: 'GetCommList',
                Code: 'PAY',
                Channel: 3
            };
            JajaxSessionCheck('Post', '../../Handler/Common/CommHandler.ashx', param, 'json', callback, '<%=Svid_User%>');
        }

        function fnProfitListBind(pageNo) {
            $('#tblProfitList tbody').empty(); //테이블 클리어
            var callback = function (response) {
                var newRowContent = '';
                if (!isEmpty(response)) {
                    for (var i = 0; i < response.length; i++) {
                        $('#hdTotalCount').val(response[i].TotalCount);


                        newRowContent += "<tr style='height:30px;'>";
                        newRowContent += "<td class='txt-center' rowspan='2'>" + response[i].RowNum + "";
                        newRowContent += "</td>";
                        newRowContent += "<td class='txt-center'>" + response[i].EntryDate.split('T')[0] + "";
                        newRowContent += "</td>";
                        newRowContent += "<td class='txt-center'>" + response[i].BuyerCompany_Name + "";
                        newRowContent += "</td>";
                        newRowContent += "<td class='txt-center' rowspan='2'>" + response[i].GoodsName + "";
                        newRowContent += "</td>";
                        newRowContent += "<td style='padding-right: 5px; text-align: right;' rowspan='2'>" + numberWithCommas(response[i].Amt) + "원<br/>(" + response[i].GoodsQty + "개)";
                        newRowContent += "</td>";
                        newRowContent += "<td class='txt-center'>" + response[i].Payway_Name + "";
                        newRowContent += "</td>";
                        newRowContent += "<td class='txt-center' rowspan='2'>" + fnSetText('process', response[i].PayCashConfirm) + "";
                        newRowContent += "</td>";
                        newRowContent += "<td class='txt-center' rowspan='2'>" + fnOracleDateFormatConverter(response[i].PayConfirmDate) + "";
                        newRowContent += "</td>";
                        newRowContent += "<td class='txt-center' rowspan='2'>" + fnSetText('confirm', response[i].IsConfirm) + "";
                        newRowContent += "</td>";
                        newRowContent += "<td class='txt-center' rowspan='2'>" + response[i].ConfirmName + "";
                        newRowContent += "</td>";
                        newRowContent += "<td class='txt-center' rowspan='2'>" + fnOracleDateFormatConverter(response[i].ConfirmDate) + "";
                        newRowContent += "</td>";
                        newRowContent += "</tr>";
                        newRowContent += "<tr style='height:30px;'>";
                        newRowContent += "<td class='txt-center'>" + response[i].OrderCodeNo + "";
                        newRowContent += "</td>";
                        newRowContent += "<td class='txt-center'>" + response[i].BuyerName + "";
                        newRowContent += "</td>";
                        newRowContent += "<td class='txt-center'>" + response[i].PayResult + "";
                        newRowContent += "</td>";
                        newRowContent += "</tr>";


                    }
                    $('#tblProfitList tbody').append(newRowContent);

                }
                else {
                    $('#tblProfitList tbody').append("<tr><td colspan='11' class='txt-center'>" + "조회된 주문내역이 없습니다." + "</td></tr>");
                    $("#hdTotalCount").val(0);
                }


                fnCreatePagination('pagination', $("#hdTotalCount").val(), pageNo, 20, getPageData);
                return false;

            };
            var param = {
                Method: 'GetProfitList',
                SvidUser: '<%=Svid_User%>',
                StartDate: $("#<%=this.txtSearchSdate.ClientID%>").val(),
                EndDate: $("#<%=this.txtSearchEdate.ClientID%>").val(),
                SvidCompNo: '<%=UserInfoObject.UserInfo.Company_No%>',
                BuyerCompName: $("#<%=this.txtBuyerCompName.ClientID%>").val(),
                Payway: $("#<%=this.ddlSelectPayway.ClientID%>").val(),
                PayCash: $("#<%=this.ddlPayCash.ClientID%>").val(),
                PageNo: pageNo,
                PageSize: 20
            };
            JajaxSessionCheck('Post', '../../Handler/PayHandler.ashx', param, 'json', callback, '<%=Svid_User%>');
        }

        function fnSetDate(date) {

            var returnVal = '';
            if (date == '' || date == null) {
                return returnVal;
            }
            else {
                returnVal = date.split("T")[0]
            }
            return returnVal;
        }

        function getPageData() {
            var container = $('#pagination');
            var getPageNum = container.pagination('getSelectedPageNum');
            fnProfitListBind(getPageNum);
            return false;
        }
        function fnSearch() {
            fnProfitListBind(1);
        }

        function fnEnter() {

            if (event.keyCode == 13) {
                fnSearch();
                return false;
            }
            else
                return true;
        }

        function fnSetText(type, val) {
            var returnVal = '';
            if (type == 'process') {
                if (val == 'Y') {
                    returnVal = '입금완료'
                }
                else {
                    returnVal = '입금전'
                }
            }
            else {
                if (val == 'Y') {
                    returnVal = '확인'
                }
                else {
                    returnVal = '미확인'
                }
            }
            return returnVal;
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
            <!--제목 타이틀-->
            <div class="sub-title-div">
                <p class="p-title-mainsentence">
                    입금내역조회(현금)
                    <span class="span-title-subsentence">입금내역을 확인 할 수 있습니다.</span>
                </p>
            </div>


            <!--상단영역 시작-->
            <div class="search-div">
                <table id="tblSearch">
                    <thead>
                        <tr>
                            <th colspan="6" style="height: 40px;">입금내역조회</th>
                        </tr>
                    </thead>
                    <tr style="">
                        <th style="width: 180px;">주문일</th>
                        <td colspan="6" style="text-align: left; padding-left: 5px;">
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
                        <th style="width: 180px;">결제수단</th>
                        <td style="width: 250px;">
                            <asp:DropDownList ID="ddlSelectPayway" CssClass="input-drop" runat="server" Height="24px">
                                <asp:ListItem Value="all" Text="---전체---"></asp:ListItem>
                            </asp:DropDownList>

                        </td>
                        <th style="width: 180px;">입금진행현황</th>

                        <td style="width: 250px;">
                            <asp:DropDownList ID="ddlPayCash" CssClass="input-drop" runat="server" Height="24px">
                                <%-- <asp:ListItem Value="all" Text="---전체---"></asp:ListItem>--%>
                                <asp:ListItem Value="N" Text="입금전"></asp:ListItem>
                                <asp:ListItem Value="Y" Text="입금완료"></asp:ListItem>
                            </asp:DropDownList>
                        </td>

                        <th style="width: 180px;">구매사</th>
                        <td style="width: 250px;">
                            <asp:TextBox ID="txtBuyerCompName" runat="server" CssClass="input-txt" OnKeypress="return fnEnter();" Height="24px" Width="100%"></asp:TextBox>

                        </td>

                    </tr>

                    <tr style="display: none">
                        <th>진행구분</th>
                        <td>
                            <select>
                                <option value="all">---전체---</option>
                            </select>
                        </td>
                    </tr>

                </table>
            </div>
            <!--상단영역 끝-->

            <!--조회하기 버튼-->
            <div class="bt-align-div">
                <input type="button" class="mainbtn type1" value="조회하기" style="width:95px; height:30px" onclick="fnSearch(); return false;"/>
            </div>

            <!--vat포함 라벨영역-->
            <span style="color: #69686d; float: right; margin-top: 10px; margin-bottom: 10px;">*<b style="color: #ec2029; font-weight: bold;"> VAT(부가세)포함 가격</b>입니다.</span>
            <!--하단영역시작-->
            <div id="profitList-wrap">
                <div class="profitList-div">
                    <table id="tblProfitList">

                        <thead>
                            <tr>
                                <th class="text-center" rowspan="2">번호</th>
                                <th class="text-center">주문날짜</th>
                                <th class="text-center">구매사</th>
                                <th class="text-center" rowspan="2">상품명</th>
                                <th class="text-center" rowspan="2">결제금액<br />
                                    (수량)</th>
                                <th class="text-center">결제수단</th>
                                <th class="text-center" rowspan="2">입금진행현황</th>
                                <th class="text-center" rowspan="2">입금날짜</th>
                                <th class="text-center" rowspan="2">입금확인여부</th>
                                <th class="text-center" rowspan="2">입금확인자</th>
                                <th class="text-center" rowspan="2">입금확인일자</th>
                            </tr>
                            <tr>
                                <th class="text-center">주문번호</th>
                                <th class="text-center">구매자</th>
                                <th class="text-center">결과내용</th>

                            </tr>
                        </thead>
                        <tbody>
                        </tbody>
                    </table>

                </div>
            </div>

            <br />
            <input type="hidden" id="hdTotalCount" />
            <div style="margin: 0 auto; text-align: center">
                <div id="pagination" class="page_curl" style="display: inline-block"></div>
            </div>
            <!-- 페이징 처리 -->
            <br />
            <!--하단영역끝-->

            <!--엑셀 저장-->
            <div class="bt-align-div">
                <asp:ImageButton ID="ibExecel" AlternateText="엑셀저장" runat="server" Visible="false" ImageUrl="../../Images/Order/detail-excel.jpg" onmouseover="this.src='../../Images/Order/detail-excel-on.jpg'" onmouseout="this.src='../../Images/Order/detail-excel.jpg'" OnClick="ibExecel_Click" />
                <%--<img src="../../Images/Cart/excel-off.jpg" alt="엑셀저장" onmouseover="this.src='../../Images/Cart/excel-on.jpg'" onmouseout="this.src='../../Images/Cart/excel-off.jpg'"/>--%>
            </div>
        </div>
    </div>
</asp:Content>

