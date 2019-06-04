<%@ Page Language="C#" MasterPageFile="~/Admin/Master/AdminMasterPage.master" AutoEventWireup="true" CodeFile="SalesDeptChk.aspx.cs" Inherits="Admin_Pay_SalesDeptChk" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <link href="../Content/Order/order.css" rel="stylesheet" />
    <link href="../Content/popup.css" rel="stylesheet" />
    <script src="../../Scripts/jquery.inputmask.bundle.js"></script>

    <script>
        $(document).ready(function () {
            $("#<%=this.txtSearchSdate.ClientID%>").inputmask("9999-99-99");
            $("#<%=this.txtSearchEdate.ClientID%>").inputmask("9999-99-99");
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
                buttonImage:/* "/Images/icon_calandar.png
                ."*/"../../Images/Goods/calendar.jpg",
                buttonImageOnly: true,
                dateFormat: "yy-mm-dd",
                monthNamesShort: ["1월", "2월", "3월", "4월", "5월", "6월", "7월", "8월", "9월", "10월", "11월", "12월"],
                dayNamesMin: ["일", "월", "화", "수", "목", "금", "토"],
                showMonthAfterYear: true
            });

            $('#tdSearchDate input[type="checkbox"]').change(function () {
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
        var is_sending = false;

        $(function () {
            ListCheckboxOnlyOne("tblPopupComp");
            ListCheckboxOnlyOne('tdSearchDate');


            //실시간 콤마찍기
            RealTimeComma("txtMoney");
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

        //수정팝업
        function modifyPopup(el) {

            fnOpenDivLayerPopup('modifyDiv');

           
            
            return false;
        }

        


        //회사 팝업
        function fnSearchCompPopup() {

            fnCompSearch(1);
            fnOpenDivLayerPopup('compSearchDiv');
          

            return false;
        }

        //[팝업]회사 조회
        function fnCompSearch(pageNo) {
            var searchKeyword = $("#txtCompPopSearch").val();
            var searchTarget = $("#ddlCompPopSearch").val();
            var pageSize = 15;
            var asynTable = "";
            var i = 1;

            var callback = function (response) {
                $("#pop_CompTbody").empty();

                if (!isEmpty(response)) {

                    $.each(response, function (key, value) {

                        $('#hdCompTotalCount').val(value.TotalCount);

                        asynTable += "<tr>";
                        asynTable += "<td class='txt-center'><input type='checkbox' id='cbCompPopup'/>";
                        asynTable += "<input type='hidden' name='hdPopCompCode' value='" + value.Company_Code + "' /><input type='hidden' name='hdPopCompName' value='" + value.Company_Name + "' />";
                        asynTable += "<input type='hidden' name='hdLoanEndDate' value='" + value.LoanEndDate + "' />";
                        asynTable += "<input type='hidden' name='hdLoanBillDate' value='" + value.LoanBillDate + "' />";
                        asynTable += "<input type='hidden' name='hdLoanPayDate' value='" + value.LoanPayDate + "' />";
                        asynTable += "<input type='hidden' name='hdLoanCalDue' value='" + value.LoanCalDue + "' />";
                        asynTable += "<input type='hidden' name='hdAdminUserName' value='" + value.AdminUserName + "' />";
                        asynTable += "</td>";
                        asynTable += "<td class='txt-center' id='tdPopCompCode'>" + value.Company_Code + "</td>";
                        asynTable += "<td class='txt-center' id='tdPopCompName'>" + value.Company_Name + "</td>";
                        asynTable += "<td class='txt-center'>" + value.LoanEndDate + "일</td>";
                        asynTable += "</tr>";
                        i++;
                    });

                } else {
                    asynTable += "<tr><td colspan='4' class='txt-center'>" + "리스트가 없습니다." + "</td></tr>"
                    $("#hdCompTotalCount").val(0);

                }

                $("#pop_CompTbody").append(asynTable);

                //페이징
                fnCreatePagination('compPagination', $("#hdCompTotalCount").val(), pageNo, pageSize, getCompPageData);
                return false;
            }

            var param = {
                Flag: 'GetCompListByAdminId',
                Target: searchTarget,
                Keyword: searchKeyword,
                AdminId: $('#txtSearchAdminId').val(),
                LoanYN: 'Y',
                PageNo: pageNo,
                PageSize: pageSize
            };

            var beforeSend = function () {
            };

            var complete = function () {
            };

            //type, url, async, cache, data, datatype, _callback, _beforeSend, _complete, issessionCheck, sessionValue
            JqueryAjax('Post', '../../Handler/Admin/CompanyHandler.ashx', true, false, param, 'json', callback, beforeSend, complete, true, '<%=Svid_User%>');

        }

        //페이징 인덱스 클릭시 데이터 바인딩
        function getCompPageData() {
            var container = $('#compPagination');
            var getPageNum = container.pagination('getSelectedPageNum');
            fnCompSearch(getPageNum);
            return false;
        }


        //회사 팝업 확인 버튼 클릭 시
        function fnPopupOkComp() {
            $("#deadlineList tbody").empty();
            $("#deadlineList tbody").append("<tr id='emptyRow'><td colspan='10' class='txt-center'>" + "조회된 주문내역이 없습니다." + "</td></tr>");

            $('#tdSearchCb input[type=checkbox]').each(function () {
                $(this).prop('checked', '');
            });
            var cnt = 0;

            $('#pop_CompTbody tr').each(function (index, element) {
                var check = $(this).find("#cbCompPopup").is(":checked");
                if (check) {
                    var compCode = $(this).find("input:hidden[name='hdPopCompCode']").val();
                    var compName = $(this).find("input:hidden[name='hdPopCompName']").val();


                    $("#txtSearchCompCode").val(compCode);
                    $("#txtSearchCompName").val(compName);
                }
            });

            var selectLength = $('#tblPopupComp input[type="checkbox"]:checked').length;
            if (selectLength < 1) {
                alert('회사를 선택해 주세요');
                return false;

            }

            fnClosePopup("compSearchDiv");
            return true;
        }

        function fnCompPopupEnter() {
            if (event.keyCode == 13) {
                fnCompSearch(1);
                return false;
            }
            else
                return true;
        }

        //입금확인 버튼 클릭 시
        function fnDepositConfirm(el) {
            var rowEl = $(el).parent();
            var year = $(rowEl).find("input:hidden[name='hdYear']").val();
            var month = $(rowEl).find("input:hidden[name='hdMon']").val();
            var day = $(rowEl).find("input:hidden[name='hdDay']").val();
            var seq = $(rowEl).find("input:hidden[name='hdSeq']").val();
            var depositDate = year + '-' + month + '-' + day;

            var confirmVal = confirm("정말로 입금 확인 하시겠습니까?");

            if (!confirmVal) {
                return false;
            }

            var callback = function (response) {

                if (!isEmpty(response) && (response === "OK")) {
                    alert("성공적으로 입금 확인되었습니다.");

                } else {
                    alert("입금 확인에 실패하였습니다. 개발자에게 문의바랍니다.");
                }
                return false;
            }

            var param = {
                Method: 'LoanDepositSalesConfirm',
                CompCode: $.trim($('#txtSearchCompCode').val()),
                ConfIdB: '<%=UserInfoObject.Id %>',
                DepositDate: depositDate,
                Seq: seq
            };

            var beforeSend = function () {
                is_sending = true;
            }
            var complete = function () {
                is_sending = false;
                fnSearch(1);
            }
            if (is_sending) return false;

            JqueryAjax('Post', '../../Handler/PayHandler.ashx', true, false, param, 'text', callback, beforeSend, complete, true, '<%=Svid_User%>');
        }

        function fnSearch(pageNo) {

            if ($.trim($('#txtSearchCompCode').val()) == '') {
                alert('회사를 선택해 주세요.');
                return false;
            }
            var pageSize = 20;
            var asynTable = "";
            var i = 1;

            var callback = function (response) {
                $("#depositList tbody").empty();

                if (!isEmpty(response)) {

                    $.each(response, function (key, value) {

                        $('#hdTotalCount').val(value.TotalCount);

                        var typeText = '';

                        if (value.ConfirmType == 'A' && value.LoanPayList == '5') {
                            typeText = "<input type='button' id='btnDepositOk' onclick='fnDepositConfirm(this)' class='listBtn' value='입금 확인' style='width:71px; height:22px; font-size:12px' />";
                        }
                        else if (value.ConfirmType == 'B' && value.LoanPayList == '6') {
                            typeText = '입금 확인 완료';
                        }
                        else {
                            typeText = "<input type='button' id='btnDepositOk' onclick='fnDepositConfirm(this)' class='listBtn' value='입금 확인' style='width:71px; height:22px; font-size:12px' />";
                        }

                        asynTable += "<tr>";
                        asynTable += "<td class='txt-center'>" + fnOracleDateFormatConverter(value.ConfirmDateA) + "</td>";
                        asynTable += "<td class='txt-center'>" + value.Seq + "</td>";
                        asynTable += "<td class='txt-center'>" + value.Company_Name + "</td>";
                        asynTable += "<td class='txt-center'>" + numberWithCommas(value.LoanPayUsePrice) + "원</td>";
                        asynTable += "<td class='txt-center'>";
                        asynTable += "<input type='hidden' name='hdYear' value='" + value.Year + "' />"
                        asynTable += "<input type='hidden' name='hdMon' value='" + value.Month + "' />"
                        asynTable += "<input type='hidden' name='hdDay' value='" + value.Day + "' />"
                        asynTable += "<input type='hidden' name='hdSeq' value='" + value.Seq + "' />"
                        asynTable += typeText + "</td>";
                        asynTable += "</tr>";
                        i++;
                    });

                } else {
                    asynTable += "<tr><td colspan='5' class='txt-center'>" + "조회된 리스트가 없습니다." + "</td></tr>"
                    $("#TotalCount").val(0);

                }

                $("#depositList tbody").append(asynTable);

                //페이징
                fnCreatePagination('pagination', $("#hdTotalCount").val(), pageNo, pageSize, getPageData);
                return false;
            }

            var param = {
                Method: 'LoanDepositList',
                CompCode: $.trim($('#txtSearchCompCode').val()),
                Sdate: $("#<%=this.txtSearchSdate.ClientID%>").val(),
                Edate: $("#<%=this.txtSearchEdate.ClientID%>").val(),
                PageNo: pageNo,
                PageSize: pageSize
            };

            var beforeSend = function () {
                is_sending = true;
            }
            var complete = function () {
                is_sending = false;
            }
            if (is_sending) return false;

            //type, url, async, cache, data, datatype, _callback, _beforeSend, _complete, issessionCheck, sessionValue
            JqueryAjax('Post', '../../Handler/PayHandler.ashx', true, false, param, 'json', callback, beforeSend, complete, true, '<%=Svid_User%>');
        }

        //페이징 인덱스 클릭시 데이터 바인딩
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

        function fnTabClickRedirect(pageName) {
            location.href = pageName + '.aspx?ucode=' + ucode;
            return false;
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div class="all">


        <div class="sub-contents-div">
            <div class="sub-title-div">
                <p class="p-title-mainsentence">
                    여신(무) 관리
                    <span class="span-title-subsentence"></span>
                </p>
            </div>

            <!--탭메뉴-->
            <div class="div-main-tab" style="width: 100%; ">
                <ul>
                    <li class='tabOff' style="width: 185px;" onclick="fnTabClickRedirect('FinanceDeptManage');">
                        <a onclick="fnTabClickRedirect('FinanceDeptManage');">재무팀 등록/수정</a>
                     </li>
                    <li class='tabOn' style="width: 185px;" onclick="fnTabClickRedirect('SalesDeptChk');">
                         <a onclick="fnTabClickRedirect('SalesDeptChk');">영업팀 확인</a>
                    </li>
                    <li class='tabOff' style="width: 185px;" onclick="fnTabClickRedirect('LoanConfirmList');">
                        <a onclick="fnTabClickRedirect('LoanConfirmList');">확인 내역조회</a>
                    </li>
                </ul>
            </div>

            <!--상단 조회영역 시작-->
            <div class="search-div">
                <colgroup>
                        <col style="width:200px;"/>
                        <col style="width:600px;"/>
                        <col style="width:200px;"/>
                        <col />
                    </colgroup>
                <table class="tbl_main">
                    <tr>
                        <th>회사 검색</th>
                        <td>
                            <input type="text" id="txtSearchCompCode" class="medium-size" readonly="readonly" />&nbsp;
                            <input type="text" id="txtSearchCompName" class="medium-size" readonly="readonly" />
                            <input type="button" class="mainbtn type1" style="width: 75px;" value="검색" onclick="return fnSearchCompPopup();" />
                        </td>
                        <th>영업 담당자</th>
                        <td>
                            <span id="spanAdmUserId"><%= UserInfoObject.Name %></span>
                        </td>
                    </tr>

                    <tr>
                        <th>입금 등록일별 검색</th>
                        <td colspan="3" id="tdSearchDate">
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

                </table>

                <!--버튼-->
                <div class="bt-align-div">
                    <input type="button" class="mainbtn type1" style="width: 95px;" value="조회하기" id="btnSearch" onclick="fnSearch(1); return false;" />
                </div>
            </div>
            <br />

            <!--하단 리시트영역 시작-->
            <div class="list-div" style="width: 100%;">

                <table id="depositList" class="tbl_main">
                    <thead>
                        <tr>
                            <th style="width: 200px;">입금 정보 등록일</th>
                            <th style="width: 80px;">순번</th>
                            <th style="width: 370px;">회사명</th>
                            <th style="width: 200px;">입력금액</th>
                            <th style="width: 150px;">영업확인</th>
                        </tr>

                    </thead>
                    <tbody>
                        <tr>
                            <td colspan="5" class="txt-center">리스트을 조회해 주시기 바랍니다.</td>
                        </tr>
                    </tbody>
                </table>
                <br />
                <input type="hidden" id="hdTotalCount" />
                <!-- 페이징 처리 -->
                <div style="margin: 0 auto; text-align: center">
                    <div id="pagination" class="page_curl" style="display: inline-block"></div>
                </div>

                <!--조회하기 버튼-->
                <div class="bt-align-div">
                    <asp:Button runat="server" CssClass="mainbtn type1" Text="엑셀다운"  Width="95px" Height="30px" />
                </div>
            </div>
            <!--하단 리스트 영역 끝 -->



            <%--상세보기 팝업 시작--%>

            <div id="modifyDiv" class="popupdiv divpopup-layer-package">
                <div class="popupdivWrapper" style="width: 1200px; margin: 150px auto; background-color: #ffffff;">
                    <div class="popupdivContents" style="background-color: #ffffff; height: 450px; padding: 15px;">

                        <div class="close-div">
                            <a onclick="fnClosePopup('modifyDiv')" style="cursor: pointer">
                                <img src="../../Images/Wish/icon-delete.jpg" alt="닫기" style="float: right;" /></a>
                        </div>

                        <div class="popup-title" style="margin-top: 20px;">
                            <%--<img src="" alt="[재무팀] 수정하기" />--%>
                            <h3 class="pop-title">[재무팀] 수정하기</h3>
                            <br />
                            <br />

                            <!-- 주문 상품 테이블 -->
                            <div>
                                <table class="board-table">
                                    <thead>
                                        <tr>
                                            <th class="txt-center" style="width: 10%">입금정보등록일</th>
                                            <td style="width: 20%">
                                                <asp:TextBox ID="txtPaymentInfoDate" runat="server" CssClass="calendar" ReadOnly="true" Onkeypress="return fnEnter();"></asp:TextBox>
                                            </td>
                                            <th class="txt-center" style="width: 10%">기관명(회사명)</th>
                                            <td style="width: 10%"></td>
                                            <th class="txt-center" style="width: 10%">영업담당자</th>
                                            <td style="width: 10%"></td>
                                            <th class="txt-center" style="width: 10%">확인여부</th>
                                            <td style="width: 10%"></td>
                                        </tr>
                                    </thead>
                                </table>
                            </div>
                            <br />
                            <br />




                            <!-- 주문 정보 테이블 -->
                            <table class="board-table">
                                <colgroup>
                                    <col style="width: 30%" />
                                    <col style="width: 70%" />
                                </colgroup>
                                <thead>
                                    <tr>
                                        <th>입금액</th>
                                        <td style="text-align: left">원</td>
                                    </tr>
                                    <tr>
                                        <th>수정액</th>
                                        <td style="text-align: left">
                                            <input type="text" style="height: 25px; width: 60%; margin-left: 4px; padding-left: 1px" id="txtModifyPop" />&nbsp;원</td>
                                    </tr>
                                    <tr>
                                        <th>사유입력</th>
                                        <td>
                                            <textarea style="width: 99%; height: 150px; resize: none"></textarea></td>
                                    </tr>
                                </thead>
                                <tbody>
                                </tbody>
                            </table>
                        </div>

                        <!-- 팝업버튼 -->
                        <div style="margin-top: 20px; text-align: right">
                            <img src="" alt="수정요청" />
                            <img src="" alt="삭제" />
                        </div>
                        <div style="margin-top: 20px; text-align: right">
                            <img src="" alt="수정요청" />
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <%--회사 팝업 시작--%>
    <div id="compSearchDiv" class="popupdiv divpopup-layer-package">
        <div class="popupdivWrapper" style="width: 650px; height: 650px">
            <div class="popupdivContents">

                <div class="close-div">
                    <a onclick="fnClosePopup('compSearchDiv'); return false;" style="cursor: pointer">
                        <img src="../Images/icon-delete.jpg" alt="닫기" style="float: right;" /></a>
                </div>
                <div class="popup-title">
                    <h3 class="pop-title">검색조건 선택</h3>

                    <div class="search-div">
                        <select id="ddlCompPopSearch" class="selectCompManagement">
                            <option value="NAME">회사명</option>
                            <option value="CODE">회사코드</option>
                        </select>
                        <input type="text" class="text-code" id="txtCompPopSearch" placeholder="검색어를 입력해 주세요." onkeypress="return fnCompPopupEnter();" style="width: 300px" />
                        <input type="button" value="검색" style="width:75px" class="mainbtn type1" onclick="fnCompSearch(1); return false;">
                    </div>
                    <div class="divpopup-layer-conts">
                        <table id="tblPopupComp" class="tbl_main">
                            <thead>
                                <tr>
                                    <th>선택</th>
                                    <th>회사코드</th>
                                    <th>회사명</th>
                                    <th>마감일</th>
                                </tr>
                            </thead>
                            <tbody id="pop_CompTbody">
                                <tr>
                                    <td colspan="4" class="text-center">리스트가 없습니다.</td>
                                </tr>
                            </tbody>
                        </table>
                        <!-- 페이징 처리 -->
                        <div style="margin: 0 auto; text-align: center; padding-top: 10px">
                            <input type="hidden" id="hdCompTotalCount" />
                            <div id="compPagination" class="page_curl" style="display: inline-block"></div>
                        </div>
                    </div>

                    <div class="btn_center">
                        <input type="button" value="취소" style="width:75px" class="mainbtn type2" onclick="fnClosePopup('compSearchDiv'); return false;"/>
                        <input type="button" value="확인" style="width:75px" class="mainbtn type1" onclick="fnPopupOkComp(); return false;"/>                     
                    </div>
                </div>
            </div>
        </div>
    </div>
    <%--회사  팝업 끝--%>
</asp:Content>
