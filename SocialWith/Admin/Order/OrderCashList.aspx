﻿<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Master/AdminMasterPage.master" AutoEventWireup="true" CodeFile="OrderCashList.aspx.cs" Inherits="Admin_Order_OrderCashList" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <link href="../Content/Order/order.css" rel="stylesheet" />
    <script src="../../Scripts/jquery.inputmask.bundle.js"></script>

    <script>
        var is_sending = false;

        $(document).ready(function () {
            $("#<%=this.txtSearchSdate.ClientID%>").inputmask("9999-99-99");
            $("#<%=this.txtSearchEdate.ClientID%>").inputmask("9999-99-99");
            //체크박스 하나만 선택
            var tableid = 'tblSearch';
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

            fnProfitListBind(1);
        });

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

        function fnSearch() {
            fnProfitListBind(1);
        }

        function fnProfitListBind(pageNo) {

            $('#tblProfitList tbody').empty(); //테이블 클리어
            var callback = function (response) {
                var newRowContent = '';
                if (!isEmpty(response)) {
                    for (var i = 0; i < response.length; i++) {
                        $('#hdTotalCount').val(response[i].TotalCount);


                        var checkBoxFlag = '';
                        if (response[i].IsConfirm == 'Y' || response[i].PayCashConfirm == 'N') {
                            checkBoxFlag = 'disabled';
                        }
                        var index = 1;
                        newRowContent += "<tr style='height:30px;'>";
                        newRowContent += "<td class='txt-center' rowspan='2'><input type='checkbox' " + checkBoxFlag + " id='cbSelect" + index + "'><input type='hidden' id='hdOrderCodeNo' value='" + response[i].OrderCodeNo + "'></td>";
                        newRowContent += "<td class='txt-center' rowspan='2'>" + response[i].RowNum + "";
                        newRowContent += "</td>";
                        newRowContent += "<td class='txt-center'>" + response[i].EntryDate.split('T')[0] + "";
                        newRowContent += "</td>";
                        newRowContent += "<td class='txt-center' >" + response[i].BuyerCompany_Name + "";
                        newRowContent += "</td>";
                        newRowContent += "<td class='txt-center' rowspan='2'>" + response[i].OrderSaleCompany_Name + "";
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
                        index++;

                    }
                    $('#tblProfitList tbody').append(newRowContent);

                }
                else {
                    $('#tblProfitList tbody').append("<tr><td colspan='13' class='txt-center'>" + "리스트가 없습니다." + "</td></tr>");
                    $("#hdTotalCount").val(0);
                }


                fnCreatePagination('pagination', $("#hdTotalCount").val(), pageNo, 20, getPageData);
                return false;

            };
            var param = {
                Method: 'ProfitCash_Admin',
                SvidUser: '<%=Svid_User%>',
                StartDate: $("#<%=this.txtSearchSdate.ClientID%>").val(),
                EndDate: $("#<%=this.txtSearchEdate.ClientID%>").val(),
                SvidCompNo: '<%=UserInfoObject.UserInfo.Company_No%>',
                BuyerCompName: $("#<%=this.txtBuyerCompName.ClientID%>").val(),
                saleCompName: $("#<%=this.txtSaleCompName.ClientID%>").val(),
                Payway: $("#<%=this.ddlSelectPayway.ClientID%>").val(),
                PayCash: $("#<%=this.ddlPayCash.ClientID%>").val(),
                PageNo: pageNo,
                PageSize: 20
            };
            

            var beforeSend = function () {
                is_sending = true;
                $('#divLoading').css('display', 'block');
            }
            var complete = function () {
                is_sending = false;
                $('#divLoading').css('display', 'none');
            }
            
            JqueryAjax("Post", "../../Handler/PayHandler.ashx", true, false, param, "json", callback, beforeSend, complete, true, '<%=Svid_User %>');
        

        }

        //테이블 전체 선택
        function fnSelectAll(el) {
            if ($(el).prop("checked")) {
                $("input[id^=cbSelect]").not(":disabled").prop("checked", true);
            }
            else {
                $("input[id^=cbSelect]").not(":disabled").prop("checked", false);
            }
        }

        function getPageData() {
            var container = $('#pagination');
            var getPageNum = container.pagination('getSelectedPageNum');
            fnProfitListBind(getPageNum);
            return false;
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
        var is_sending = false;
        //입금확인 버튼 클릭
        function fnDepositConfirm() {

            var codeArray = '';

            $('#tblProfitList tbody input[id ^="cbSelect"]').each(function () {
                if ($(this).prop('checked') == true) {
                    var code = $(this).parent().find('input[id^="hdOrderCodeNo"]').val();
                    codeArray += code + ',';
                }
            });

            if (codeArray == '') {
                alert('주문건을 선택해 주세요.');
                return false;
            }
            var callback = function (response) {
                if (!isEmpty(response)) {
                    if (response == "OK") {
                        alert('확인되었습니다.');
                        fnSearch();

                        return false;
                    }
                    else {
                        alert('시스템 오류입니다. 관리자에게 문의하세요.');
                        return false;
                    }
                }
                return false;
            };

            var param = {
                Codes: codeArray.slice(0, -1),
                UserId: '<%= UserInfoObject.Id%>',
                Method: 'AdminDepositConfirmUpdate'
            };

            var beforeSend = function () {
                is_sending = true;
            }
            var complete = function () {
                is_sending = false;
            }

            if (is_sending) return false;

            JajaxDuplicationCheck('Post', '../../Handler/PayHandler.ashx', param, 'text', callback, beforeSend, complete, true, '<%=Svid_User%>');
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
                    입금내역조회(현금)
                    <span class="span-title-subsentence">입금내역을 확인 할 수 있습니다.</span>
                </p>
            </div>

            <!--상단영역 시작-->
            <div class="search-div">
                <table id="tblSearch" class="tbl_main">
                    <thead>
                        <tr>
                            <th colspan="4" style="height:50px;">입금내역조회</th>
                        </tr>
                    </thead>


                    <tr>
                        <th style="width: 180px;">주문일</th>
                        <td colspan="3" style="text-align: left; padding-left: 5px;">
                            <asp:TextBox ID="txtSearchSdate" runat="server" MaxLength="10" CssClass="calendar" OnkeyPress="return fnEnterDate();" placeholder="2018-01-01" ReadOnly="true"></asp:TextBox>
                            -
                            <asp:TextBox ID="txtSearchEdate" runat="server" MaxLength="10" CssClass="calendar" OnkeyPress="return fnEnterDate();" placeholder="2018-12-30" ReadOnly="true"></asp:TextBox>&nbsp;&nbsp;&nbsp;
                            <input type="checkbox" style="margin-top:6px;" name="chkBox" id="ckbSearch1" value="1" checked="checked" /><label for="ckbSearch1">1일</label>
                            <input type="checkbox" style="margin-top:6px; margin-left:5px;" name="chkBox" id="ckbSearch2" value="7" /><label for="ckbSearch2">7일</label>
                            <input type="checkbox" style="margin-top:6px; margin-left:5px;" name="chkBox" id="ckbSearch3" value="15" /><label for="ckbSearch3">15일</label>
                            <input type="checkbox" style="margin-top:6px; margin-left:5px;" name="chkBox" id="ckbSearch4" value="30" /><label for="ckbSearch4">30일</label>
                            <input type="checkbox" style="margin-top:6px; margin-left:5px;" name="chkBox" id="ckbSearch5" value="90" /><label for="ckbSearch5">90일</label>
                            <input type="checkbox" style="margin-top:6px; margin-left:5px;" name="chkBox" id="ckbSearch6" value="0" /><label for="ckbSearch6">직접입력</label>
                        </td>
                    </tr>
                    <tr>
                        <th style="width: 180px;">결제수단</th>
                        <td style="width: 250px;">
                            <asp:DropDownList ID="ddlSelectPayway" CssClass="medium-size" runat="server">
                                <asp:ListItem Value="all" Text="---전체---"></asp:ListItem>
                            </asp:DropDownList>
                        </td>
                        <th style="width: 180px;">입금진행현황</th>

                        <td style="width: 250px;">
                            <asp:DropDownList ID="ddlPayCash" CssClass="medium-size" runat="server">
                                <%-- <asp:ListItem Value="all" Text="---전체---"></asp:ListItem>--%>
                                <asp:ListItem Value="N" Text="입금전"></asp:ListItem>
                                <asp:ListItem Value="Y" Text="입금완료"></asp:ListItem>
                            </asp:DropDownList>
                            <%--<asp:DropDownList CssClass="input-drop" runat="server" Height="24px">
                                <asp:ListItem Value="all" Text="---전체---"></asp:ListItem>
                                <asp:ListItem Value="all" Text="매출정산"></asp:ListItem>
                                <asp:ListItem Value="all" Text="매출취소"></asp:ListItem>
                            </asp:DropDownList>--%>
                        </td>
                    </tr>
                    <tr>
                         <th style="width: 180px;">판매사</th>
                        <td>
                            <asp:TextBox ID="txtSaleCompName" runat="server" class="medium-size" OnKeypress="return fnEnter();"></asp:TextBox>
                        </td>
                        <th style="width: 180px;">구매사</th>
                        <td style="width: 250px;">
                            <asp:TextBox ID="txtBuyerCompName" runat="server" class="medium-size" OnKeypress="return fnEnter();"></asp:TextBox>
                        </td>
                    </tr>
                </table>
            </div>
            <!--상단영역 끝-->

            <!--조회하기 버튼-->
            <div class="bt-align-div">
                <%--<a>
                    <img alt="조회하기" src="../../Images/Goods/aslist.jpg" id="btnSearch" onmouseover="this.src='../../Images/Wish/aslist-over.jpg'" onmouseout="this.src='../../Images/Goods/aslist.jpg'" onclick="fnSearch();" /></a>

                </a>--%>
                 <input type="button" class="mainbtn type1" id="btnSearch" style="width: 113px; height: 30px; border-radius:5px;font-size: 12px; margin-bottom:2px" value="조회하기" onclick="fnSearch();" />
                <%--<a>
                    <img alt="입금확인" src="../Images/Order/moneyCheck-off.jpg" onmouseover="this.src='../Images/Order/moneyCheck-on.jpg'" onmouseout="this.src='../Images/Order/moneyCheck-off.jpg'" onclick="fnDepositConfirm(); return false;" />
                </a>--%>
                <input type="button" class="mainbtn type1" id="btnConfirm" style="width: 113px; height: 30px; border-radius:5px;font-size: 12px; margin-bottom:2px" value="입금확인" onclick="fnDepositConfirm(); return false;" />
            </div>
            <span style="color: #69686d; float: right; margin-top: 10px; margin-bottom: 10px;">*<b style="color: #ec2029; font-weight: bold;"> VAT(부가세)포함 가격</b>입니다.</span>

            <!--하단영역시작-->   
            <%--<div id="profitList-wrap">--%>
                <%--<div class="profitList-div">--%>
                <div class="list-div" style="width: 100%;">
                    <table id="tblProfitList" class="tbl_main">

                        <thead>
                            <tr>
                                <th class="text-center" style="width: 30px" rowspan="2">
                                    <input type="checkbox" onclick="fnSelectAll(this);" /></th>
                                <th class="text-center" style="width: 35px" rowspan="2">번호</th>
                                <th class="text-center" style="width: 105px">주문날짜</th>
                                <th class="text-center" style="width: 141px">구매사</th>
                                <th class="text-center" rowspan="2" style="width: 95px">판매사</th>
                                <th class="text-center" rowspan="2" style="width: 240px">상품명</th>
                                <th class="text-center" rowspan="2" style="width: 84px">결제금액<br />
                                    (수량)</th>
                                <th class="text-center" style="width: 70px">결제수단</th>
                                <th class="text-center" rowspan="2" style="width: 86px">입금진행현황</th>
                                <th class="text-center" rowspan="2" style="width: 75px">입금날짜</th>
                                <th class="text-center" rowspan="2" style="width: 86px">입금확인여부</th>
                                <th class="text-center" rowspan="2" style="width: 73px">입금확인자</th>
                                <th class="text-center" rowspan="2" style="width: 88px">입금확인일자</th>
                            </tr>
                            <tr>
                                <th class="text-center">주문번호</th>
                                <th class="text-center">구매자</th>
                                <th class="text-center">결과내용</th>

                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td colspan="13">리스트가 없습니다.</td>
                            </tr>
                        </tbody>
                    </table>

                </div>
            <%--</div>--%>

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
                <asp:Button ID="btnExcelExport" runat="server" Width="95" Height="30" Text="엑셀 저장" OnClick="btnExcelExport_Click" CssClass="mainbtn type1"/>
            </div>
        </div>
    </div>
</asp:Content>


