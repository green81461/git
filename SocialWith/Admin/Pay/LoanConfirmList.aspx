<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Master/AdminMasterPage.master" AutoEventWireup="true" CodeFile="LoanConfirmList.aspx.cs" Inherits="Admin_Pay_LoanConfirmList" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <link href="../Content/Order/order.css" rel="stylesheet" />
    <link href="../Content/popup.css" rel="stylesheet" />
    <script src="../../Scripts/jquery.inputmask.bundle.js"></script>

    <script type="text/javascript">

        $(document).ready(function () {

            $("#<%=this.txtSearchSdate.ClientID%>").inputmask("9999-99-99");
            $("#<%=this.txtSearchEdate.ClientID%>").inputmask("9999-99-99");
            
            //달력
            var chk = 'ckbSearch';
            ListCheckboxOnlyOne(chk);
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

            $('#ckbSearch input[type="checkbox"]').change(function () {
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
            //fnSearch(1);

            ListCheckboxOnlyOne("tblPopupAdmUserId");
            ListCheckboxOnlyOne("tblPopupComp");

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
       
        //엑셀 ㄱㄱㄱ
        function showCarryForwardPopup(el) {
            fnOpenDivLayerPopup('CarryForwardDiv');
            //var e = document.getElementById('CarryForwardDiv');

            //if (e.style.display == 'block') {
            //    e.style.display = 'none';

            //} else {
            //    e.style.display = 'block';
            //    $(".popupdivWrapper").draggable();
            //}
            
            return false;
        }
        //담당자 검색 팝업
        function fnSearchAdmUserIdPopup() {

            fnAdmUserIdSearch(1);
            fnOpenDivLayerPopup('admUserIdSearchDiv');

            //var e = document.getElementById('admUserIdSearchDiv');

            //if (e.style.display == 'block') {
            //    e.style.display = 'none';

            //} else {
            //    $(".popupdivWrapper").css("height", "500px");

            //    e.style.display = 'block';

            //    $(".popupdivWrapper").draggable();
            //}
            
            return false;
        }


        //[팝업]우리안 관리 담당자 조회
        function fnAdmUserIdSearch(pageNo) {
            var searchKeyword = $("#txtPopSearch2").val();
            var searchTarget = $("#ddlPopSearch2").val();
            var pageSize = 15;
            var asynTable = "";
            var i = 1;

            var callback = function (response) {
                $("#pop_admUserIdTbody").empty();

                if (!isEmpty(response)) {

                    $.each(response, function (key, value) {

                        $('#hdTotalCount2').val(value.TotalCount);

                        asynTable += "<tr>";
                        asynTable += "<td class='txt-center'><input type='checkbox' id='cbPopup'/><input type='hidden' name='hdPopUserId' value='" + value.Id + "' /><input type='hidden' name='hdPopUserNm' value='" + value.Name + "' /></td>";
                        asynTable += "<td class='txt-center'>" + (pageSize * (pageNo - 1) + i) + "</td>";
                        asynTable += "<td class='txt-center' id='tdPopUserId'>" + value.Id + "</td>";
                        asynTable += "<td class='txt-center' id='tdPopName'>" + value.Name + "</td>";
                        asynTable += "</tr>";
                        i++;
                    });

                } else {
                    asynTable += "<tr><td colspan='4' class='txt-center'>" + "리스트가 없습니다." + "</td></tr>"
                    $("#hdTotalCount2").val(0);

                }
                $("#pop_admUserIdTbody").append(asynTable);

                //페이징
                fnCreatePagination('pagination2', $("#hdTotalCount2").val(), pageNo, pageSize, getPageData2);
                return false;
            }

            var param = { Method: 'GetUserSearchList', Type: 'D', SearchTarget: searchTarget, SearchKeyword: searchKeyword, PageNo: pageNo, PageSize: pageSize };

            var beforeSend = function () {
            };

            var complete = function () {
            };

            //type, url, async, cache, data, datatype, _callback, _beforeSend, _complete, issessionCheck, sessionValue
            JqueryAjax('Post', '../../Handler/Common/UserHandler.ashx', true, false, param, 'json', callback, beforeSend, complete, true, '<%=Svid_User%>');

        }


        //페이징 인덱스 클릭시 데이터 바인딩
        function getPageData2() {
            var container = $('#pagination2');
            var getPageNum = container.pagination('getSelectedPageNum');
            fnAdmUserIdSearch(getPageNum);
            return false;
        }


        //페이징 처리하는 것.
        function getPageData() {
            var container = $('#pagination');
            var getPageNum = container.pagination('getSelectedPageNum');
            fnSearch(getPageNum);
            return false;
        }

        //우리안 관리 담당자 아이디 팝업 확인 버튼 클릭 시
        function fnPopupOkAdmUserId() {
            var cnt = 0;

            $('#tblPopupAdmUserId tr').each(function (index, element) {
                var check = $(this).find("#cbPopup").is(":checked");
                if (check) {
                    var userId = $(this).find("input:hidden[name='hdPopUserId']").val();
                    var userNm = $(this).find("input:hidden[name='hdPopUserNm']").val();

                    $("#txtSearchCompCode").val('');
                    $("#txtSearchCompName").val('');

                    $("#loanEndDate").text('');
                    $("#loanBillDate").text('');
                    $("#loanPayDate").text('');

                    $("#txtSearchAdminId").val(userId);
                    $("#txtSearchAdminName").val(userNm);

                    ++cnt;
                }
            });

            if (cnt == 0) {
                alert('우리안 관리 담당자 아이디를 선택해 주세요.');
                return false;
            }
            fnClosePopup("admUserIdSearchDiv");
            return true;
        }

        //회사검색 팝업
        function fnSearchCompPopup() {

            fnCompSearch(1);
            fnOpenDivLayerPopup('compSearchDiv');

            //var e = document.getElementById('compSearchDiv');

            //if (e.style.display == 'block') {
            //    e.style.display = 'none';

            //} else {
            //    e.style.display = 'block';

            //    $(".popupdivWrapper").draggable();
            //}
            
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

        //엔터키이벤트
        function fnCompPopupEnter() {
            if (event.keyCode == 13) {
                fnCompSearch(1);
                return false;
            }
            else
                return true;
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
                    var adminuserName = $(this).find("input:hidden[name='hdAdminUserName']").val();


                    $("#txtSearchCompCode").val(compCode);
                    $("#txtSearchCompName").val(compName);
                    $('#spanAdmUserId').text(adminuserName);
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

        //상세보기 팝업 visible
        function showDetailPopup(el) {

            fnOpenDivLayerPopup('DetailDiv');

            //var e = document.getElementById('DetailDiv');

            //if (e.style.display == 'block') {
            //    e.style.display = 'none';

            //} else {
            //    e.style.display = 'block';
            //    $(".popupdivWrapper").draggable();
            //}
            
            // var uNumPay = $("#hdUnum_PayNo").val();

            var uNumPay = $(el).parent().parent().find("input:hidden[name='hdUnumPayNo']").val();
            var OrderCodeNo = $(el).parent().parent().find("input:hidden[name='hdOrdNo']").val();


            SearachPop(1, uNumPay, OrderCodeNo);
            return false;
        }

      

        function fnCancelNoData() {
        fnClosePopup("compSearchDiv");
            
            alert('조회된 결과 값이 없습니다.')
            return false;
        }




        //회사 팝업 확인 버튼 클릭 시
        function fnPopupOkComp() {
            var cnt = 0;

            $('#pop_CompTbody tr').each(function (index, element) {
                var check = $(this).find("#cbCompPopup").is(":checked");
                if (check) {
                    var compCode = $(this).find("input:hidden[name='hdPopCompCode']").val();
                    var compName = $(this).find("input:hidden[name='hdPopCompName']").val();

                    var loanEndDate = $(this).find("input:hidden[name='hdLoanEndDate']").val();
                    var loanBillDate = $(this).find("input:hidden[name='hdLoanBillDate']").val();
                    var loanPayDate = $(this).find("input:hidden[name='hdLoanPayDate']").val();
                    var loanCalDue = $(this).find("input:hidden[name='hdLoanCalDue']").val();

                    var loanCalDueTxt = '';
                    switch (loanCalDue) {
                        case '0':
                            loanCalDueTxt = '당월';
                            break;
                        case '30':
                            loanCalDueTxt = '익월';
                            break;
                        case '60':
                            loanCalDueTxt = '익익월';
                            break;
                        case '90':
                            loanCalDueTxt = '익익월';
                            break;
                        case '120':
                            loanCalDueTxt = '익익월';
                            break;

                        default:
                            loanCalDueTxt = '당월';
                            break;
                    }


                    var loanBillDueTxt = '';

                    if (parseInt(loanEndDate) <= parseInt(loanBillDate)) {
                        loanBillDueTxt = '당월';
                    }
                    else {
                        loanBillDueTxt = '익월';
                    }
                    $("#txtSearchCompCode").val(compCode);
                    $("#txtSearchCompName").val(compName);
                    $('#hdLoanEndDate').val(loanEndDate);
                    $("#loanEndDate").text('당월 ' + loanEndDate + '일');
                    $("#loanBillDate").text(loanBillDueTxt + ' ' + loanBillDate + '일');
                    $("#loanPayDate").text(loanCalDueTxt + ' ' + loanPayDate + '일');

                    ++cnt;
                }
            });

            if (cnt == 0) {
                alert('회사를 선택해 주세요.');
                return false;
            }
            fnClosePopup("compSearchDiv");
            return true;
        }




        var is_sending = false;
        //조회하기
        function fnSearch(pageNum) {
            var sdate = $("#<%=this.txtSearchSdate.ClientID%>").val();  //시작일자
            var edate = $("#<%=this.txtSearchEdate.ClientID%>").val();  //종료일자
            var loanPayList_Arr = '';
            var AdminId = $('#txtSearchAdminId').val();   //영업 담당자 아이디
            var ComCode = $('#txtSearchCompCode').val();  //구매사 회사 코드
            var orderCodeNo = $('#txtOrderCodeNo').val()

            if (isEmpty(ComCode)) {
                alert("검색 조건에서 회사를 선택해 주세요.");
                return false;
            }

            $("input[name=PayType]:checked").each(function () {
                payWay = $(this).val();
            });

            $("input[name=dedline]:checked").each(function () {

                //    var tdArr = new Array();
                var dedline = $(this).val();

                loanPayList_Arr += ',' + dedline;


            });
            loanPayList_Arr = loanPayList_Arr.substring(1)


            if (!sdate) {
                alert('검색일자를 설정해주세요.')
                return false;
            }

            if (!edate) {
                alert('검색일자를 설정해주세요.')
                return false;
            }



            var pageSize = 20;                                  //페이징 처리 사이즈
            var i = 1;                                          //페이징
            var asynTable = "";

            var callback = function (response) {

                $("#tblSearch tbody").empty();

                if (!isEmpty(response)) {

                    $.each(response, function (key, value) {

                        $("#hdTotalCount").val(value.TotalCount);

                        asynTable += "<tr class='txt-center' name='trColor'>"
                        asynTable += "<td style='border:1px solid #a2a2a2; text-align:center' class='txt-center'><input type='hidden' id='hdUnumPayNo' name='hdUnumPayNo' value='" + value.Unum_PayNo + "'><input type='hidden' id='hdOrdNo' name='hdOrdNo' value='" + value.OrderCodeNo + "'><input type='checkbox'/>" + "</td>";
                        asynTable += "<td style='border:1px solid #a2a2a2; text-align:center' class='txt-center'>" + value.Year + "." + value.Month + "." + value.Day + "</td>";
                        asynTable += "<td style='border:1px solid #a2a2a2; text-align:center' class='txt-center'>" + value.Company_Code + " / " + value.Company_Name + "</td>";
                        asynTable += "<td style='border:1px solid #a2a2a2; text-align:center' class='txt-center'>" + value.AdminUserName + "</td>";
                        asynTable += "<td style='border:1px solid #a2a2a2; text-align:center' class='txt-center'>" + value.OrderCodeNo + "</td>";
                        //asynTable += "<td style='border:1px solid #a2a2a2; text-align:center' class='txt-center'>" + value.Payway_Name + "</td>";
                        //asynTable += "<td style='border:1px solid #a2a2a2; text-align:center' class='txt-center'>" + value.LoanPayDate + "</td>";
                        asynTable += "<td style='border:1px solid #a2a2a2; text-align:center' class='txt-center'>" + value.PayDate.split("T")[0] + "</td>";
                        asynTable += "<td style='border:1px solid #a2a2a2; text-align:center' class='txt-center'>" + numberWithCommas(value.LoanMonsPayPrice) + " 원</td>";
                        asynTable += "<td style='border:1px solid #a2a2a2; text-align:center' class='txt-center'>" + numberWithCommas(value.LoanPayUsePrice) + " 원</td>";
                        asynTable += "<td style='border:1px solid #a2a2a2; text-align:center' class='txt-center'>" + numberWithCommas(value.LoanMonthUsePrice) + " 원</td>";
                        asynTable += "<td style='border:1px solid #a2a2a2; text-align:center' class='txt-center'>" + value.LoanPayListName + "</td>";
                        //asynTable += "<td style='border:1px solid #a2a2a2; text-align:center'><img src='../../Images/delivery/add1-off.jpg' style='cursor:pointer' onmouseover=\"this.src='../../Images/delivery/add1-off.jpg'\"  onmouseout=\"this.src='../../Images/delivery/add1-on.jpg'\"  alt='상세확인' onclick='return showDetailPopup(this)' id='imgBPayType'/></td>";

                        asynTable += "<td style='border:1px solid #a2a2a2; text-align:center'><input type='button' class='listBtn' value='상세보기' style='width:71px; height:22px; font-size:12px' onclick='return showDetailPopup(this)' /></td>";

                        //asynTable += "<td style='text-align:right'>" + numberWithCommas(value.Amt) + "원</td>";
                        //asynTable += "  ";
                        asynTable += '</tr>';

                        i++;

                    });
                } else {
                    asynTable += "<tr><td colspan='20' class='txt-center'>" + "조회된 정보가 없습니다." + "</td></tr>"
                    $("#hdTotalCount").val(0);
                }
                $("#tblSearch tbody").append(asynTable);
                fnCreatePagination('pagination', $("#hdTotalCount").val(), pageNum, pageSize, getPageData);

            }

            var sUser = '<%=Svid_User %>';


            var param = {
                CompCode: ComCode,                                   //구매사 회사코드
                AdminUserID: AdminId,                                //영업 담당자
                OrderCodeNo: orderCodeNo,             //여신결제번호
                LoanPayList_Arr: loanPayList_Arr,                    // 결제일, 입금일 ex) 미결제,입금대기,부분결제,결제완료           
                Sdate: sdate,
                Edate: edate,
                PageNo: pageNum,
                PageSize: pageSize,
                Method: 'Payok_OrderEnd'
            };

            var beforeSend = function () {
                is_sending = true;
            }
            var complete = function () {
                is_sending = false;
            }

            if (is_sending) return false;

            JqueryAjax('Post', '../../Handler/PayHandler.ashx', true, false, param, 'json', callback, beforeSend, complete, true, '<%=Svid_User%>');

        }



        //팝업에서 상세보기 조회
        function SearachPop(pageNum, UnumPayNo, OrderCodeNo) {
            $("#popOrderCodeNo").val(OrderCodeNo);
            var pageSize = 7;                                  //페이징 처리 사이즈
            var i = 1;                                          //페이징
            var asynTable = "";
            var ComCode = $('#txtSearchCompCode').val();  //구매사 회사 코드

            var callback = function (response) {

                $("#CommListtbl tbody").empty();

                if (!isEmpty(response)) {

                    $.each(response, function (key, value) {
                        $("#hdTotalCount_2").val(value.TotalCount);
                        if (key == 0) $("#hd_pop_uNumPay").val(value.PayLoanSeqNoB);

                        $("#ComCode_Name").text(value.Company_Code + " / " + value.Company_Name); //회사 코드 / 명
                        $("#UrianAdminName").text(value.AdminUserName);                           //담당자명
                        $("#LoanEndDate").text(value.LoanEndDate + ' 일');                                //월 마감일자


                        var chkBillDate = '';
                        if (Number(value.LoanEndDate) > Number(value.LoanBillDate)) {
                            $("#LoanBillDate").text('익월' + value.LoanBillDate + ' 일');                              //세금계산서 발행일자

                        }
                        else {
                            $("#LoanBillDate").text('당월' + value.LoanBillDate + ' 일');
                        }

                        //if (Number(value.LoanEndDate) - Number(value.LoanBillDate) =='' ) {

                        //}

                        $("#EntryDate").text(value.EntryDate.split("T")[0] + ' 일');                                    //결제 신청일   
                        $("#LoanMonsPayPrice").text(numberWithCommas(value.LoanMonsPayPrice)+" 원");                                  //마감금액
                        $("#LoanPayUsePrice").text(numberWithCommas(value.LoanPayUsePrice) + " 원");                                    //결제금액
                        var OutStandAmount = Number(value.LoanMonsPayPrice) - Number(value.LoanPayUsePrice);    //미수금액 
                        $("#OutStandAmount").text(numberWithCommas(OutStandAmount) + " 원");                                                 //미수금액
                        $("#LoanPayList").text(value.LoanPayListName);                             //결제현황
                        var loanCalDueTxt = '';
                        if (value.LoanCalDue == '0') {
                            loanCalDueTxt = '당월'
                        }
                        else if (value.LoanCalDue == '30') {
                            loanCalDueTxt = '익월'
                        }
                        else {
                            loanCalDueTxt = '익익월'
                        }

                        $("#LoanCalDate").text(loanCalDueTxt);



                        //var src = '/GoodsImage' + '/' + value.GoodsFinalCategoryCode + '/' + value.GoodsGroupCode + '/' + value.GoodsCode + '/' + value.GoodsFinalCategoryCode + '-' + value.GoodsGroupCode + '-' + value.GoodsCode + '-sss.jpg';
                        asynTable += "<tr name='trColor'>"
                        asynTable += "<td rowspan='2' class='txt-center'>" + value.RowNumber + "</td>";  //번호
                        asynTable += "<td rowspan='2' style='border:1px solid #a2a2a2; text-align:center' class='txt-center'>" + value.Year + "." + value.Month + "." + value.Day + "</td>";
                        asynTable += "<td rowspan='2' class='txt-center'>" + numberWithCommas(value.LoanMonsPayPrice) + " 원</td>"; //주문코드
                        //asynTable += "<td rowspan='2' class='txt-center'><img src=" + src + " onerror='no_image(this, \"s\")' style='width:50px; height=50px'/></td>"; //이미지
                        asynTable += "<tr name='trColor'>"

                        i++;

                    });
                } else {
                    $("#hdTotalCount_2").val(0);
                    asynTable += "<tr><td colspan='4' class='txt-center'>" + "조회된 정보가 없습니다." + "</td></tr>"
                    fnCancelNoData();
                }
                $("#CommListtbl tbody").append(asynTable);
                fnCreatePagination('pagination_2', $("#hdTotalCount_2").val(), pageNum, pageSize, getPageData2);


            }

            var sUser = '<%=Svid_User %>';
            var param = {
                comCode: ComCode,
                unumPayNo: UnumPayNo,
                PageNo: pageNum,
                PageSize: pageSize,
                Method: 'OrderEnd_DTL'
            };

            // JajaxSessionCheck('Post', '../Handler/PayHandler.ashx', param, 'json', callback, sUser);

            var beforeSend = function () { };
            var complete = function () { };
            JqueryAjax('Post', '../../Handler/PayHandler.ashx', true, false, param, 'json', callback, beforeSend, complete, true, '<%=Svid_User%>');

            //반환 값 없이 OK와 같은 신호를 보낼거면 json을 text로 바꿈, 마지막에 svid전에 true는 세션체크 유무

        }


        //엔터 키 (회사 검색)
        function fnAdminPopupEnter() {
            if (event.keyCode == 13) {
                fnAdmUserIdSearch(1);
                return false;
            }
            else
                return true;
        }

        //엔터키(담당자 검색)
        function fnCompPopupEnter() {
            if (event.keyCode == 13) {
                fnCompSearch(1);
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
                    <li class='tabOff' style="width: 185px;" onclick="fnTabClickRedirect('SalesDeptChk');">
                         <a onclick="fnTabClickRedirect('SalesDeptChk');">영업팀 확인</a>
                    </li>
                    <li class='tabOn' style="width: 185px;" onclick="fnTabClickRedirect('LoanConfirmList');">
                        <a onclick="fnTabClickRedirect('LoanConfirmList');">확인 내역조회</a>
                    </li>
                </ul>
            </div>


            <!--상단 조회영역 시작-->
            <div class="search-div">


                <table class="tbl_main">
                    <colgroup>
                        <col style="width:150px;"/>
                        <col />
                        <col />
                        <col />
                        <col style="width:150px;"/>
                        <col />
                        <col />
                        <col />
                    </colgroup>
                    <tr>
                        <th>담당자별 검색</th>
                        <td colspan="3">
                            <input type="text" id="txtSearchAdminId" class="medium-size" readonly="readonly" />&nbsp;
                            <input type="text" id="txtSearchAdminName" class="medium-size" readonly="readonly" />
                            <input type="button" class="mainbtn type1" style="width:75px;" value="검색" onclick="return fnSearchAdmUserIdPopup();" />
                        </td>
                        <th>회사 검색</th>
                        <td colspan="3">
                            <input type="text" id="txtSearchCompCode" class="medium-size" readonly="readonly" />&nbsp;
                            <input type="text" id="txtSearchCompName" class="medium-size" readonly="readonly" />
                            <input type="button" class="mainbtn type1" style="width:75px;" value="검색" onclick="return fnSearchCompPopup();" />
                        </td>
                    </tr>
                    <%--               <tr>
                        <th colspan="2" class="txt-center">회사 검색</th>
                        <td>
                            <input type="text" id="txtSearchCompCode" style="height: 25px; width: 37%" readonly="readonly" />&nbsp;
                            <input type="text" id="txtSearchCompName" style="height: 25px; width: 37%" readonly="readonly" />
                            <img src="../Images/Order/search-bt-off.jpg" onmouseover="this.src='../Images/Order/search-bt-on.jpg'" onmouseout="this.src='../Images/Order/search-bt-off.jpg'" alt="검색" class="search-img" onclick="return fnSearchCompPopup()" />
                        </td>
                        <th colspan="2" class="txt-center">영업 담당자</th>
                        <td colspan="2" class="txt-center" style="width: 130px;">
                            <span id="spanAdmUserId"></span>
                        </td>
                    </tr>--%>

                    <tr id="ckbSearch">
                        <th>결제일/입금일 조회</th>
                        <td colspan="6" id="tdSearchDate">
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
                        <th colspan="1">여신결제번호 조회</th>
                        <td colspan="3">
                            <input type="text" class="medium-size">
                        </td>
                        <%--       <th colspan="1">구분</th>
                        <td colspan="1">
                            <input type="checkbox" id="ckbSearch8" value="" checked="checked" />여신(일반)&nbsp;
                        <input type="checkbox" id="ckbSearch9" value="" checked="checked" />여신(무)&nbsp;

                        </td>--%>
                        <th colspan="2">결제 현황</th>
                        <td colspan="2">
                            <input type="checkbox" id="dedline1" name="dedline" value="1" /><label for="ckbSearch5">미결제</label>&nbsp;
                            <input type="checkbox" id="dedline2" name="dedline" value="2" /><label for="ckbSearch6">입금대기</label>&nbsp;
                            <input type="checkbox" id="dedline3" name="dedline" value="3" /><label for="ckbSearch7">입금완료</label>&nbsp;
                            <input type="checkbox" id="dedline4" name="dedline" value="4" /><label for="ckbSearch8">부분입금</label>&nbsp;
                            <%--파라미터 보낼 때 여러개면 쉼표 값이없으면 빈값 보내면 됨--%>
                        </td>
                    </tr>


                </table>

            </div>
            <!--조회 버튼-->
            <div class="bt-align-div">
                <input type="button" class="mainbtn type1" style="width: 95px; height: 30px;" value="조회하기" id="btnSearch" onclick="fnSearch(1); return false;" />
            </div>


            <!--상단 조회영역 끝-->
            <br />
            <br />
            <br />


            <!--하단 리스트영역 시작-->
            <div class="list-div" style="width: 100%;">
                <table id="tblSearch" class="tbl_main">
                    <thead>
                        <tr>
                            <th style="width: 35px;">선택<br />
                                <input type="checkbox" /></th>
                            <th style="width: 85px;">결제일</th>
                            <th style="width: 120px;">회사코드/명</th>
                            <th style="width: 95px;">담당자</th>
                            <th style="width: 105px;">여신 결제번호</th>
                            <th style="width: 105px;">최근 입금 등록일</th>
                            <th style="width: 85px;">마감금액</th>
                            <th style="width: 85px;">결제금액</th>
                            <th style="width: 90px;">미수금액</th>
                            <th style="width: 90px;">결제현황</th>
                            <th style="width: 85px;">내역확인</th>
                        </tr>

                    </thead>
                    <tbody>
                        <tr>
                            <td colspan="20" class="txt-center">리스트을 조회해 주시기 바랍니다.</td>
                        </tr>
                    </tbody>
                </table>
            </div>
            <br />
            <!-- 페이징 처리 -->
            <div style="margin: 0 auto; text-align: center">
                <div id="pagination" class="page_curl" style="display: inline-block"></div>
                <input type="hidden" id="hdTotalCount" />
            </div>

            <!--하단 리스트 영역 끝 -->



            <!--팝업 시작-->
            <div class="bt-align-div">
                <asp:Button runat="server" CssClass="mainbtn type1"  Font-Size="12px" Width="95px" Height="30px" Text="엑셀 저장"/>
                <%--       <input type="button" class="commonBtn" style="width: 95px; height: 30px; font-size: 12px" value="상세보기" id="btnDetail" onclick="showDetailPopup(this); return false;" />
                --%>

                <!--팝업 끝-->
            </div>
        </div>
    </div>


    <%--마감이월사유 팝업 시작--%>

    <div id="CarryForwardDiv" class="popupdiv divpopup-layer-package">
        <div class="popupdivWrapper" style="width: 620px; margin: 100px auto; background-color: #ffffff;">
            <div class="popupdivContents" style="background-color: #ffffff; padding: 15px;">

                <div class="close-div">
                    <a onclick="fnClosePopup('CarryForwardDiv')" style="cursor: pointer">
                        <img src="../../Images/Wish/icon-delete.jpg" alt="닫기" style="float: right;" /></a>
                </div>

                <div class="popup-title" style="margin-top: 20px;">
                   <%-- <img src="../" alt="마감 이월 사유" />--%>
                    <h3 class="pop-title">마감 이월 사유</h3>
                    <br />
                    <br />
                    <br />

                    <div style="height: 150px">
                        <table class="board-table">
                            <thead>
                                <tr>
                                    <th>마감 이월 사유</th>
                                    <td style="padding-left: 1px">
                                        <textarea style="width: 100%; height: 100px; resize: none;"></textarea></td>
                                </tr>
                            </thead>
                        </table>
                    </div>
                </div>

                <!-- 팝업버튼 -->
                <div style="margin-top: 20px; text-align: right">
                    <%--<img src="../" alt="승인" />
                    <img src="../" alt="거절" onclick="fnClosePopup()" />--%>
                    <input type="button" class="mainbtn type1" style="width:75px" value="승인" />
                    <input type="button" class="mainbtn type1" style="width:75px" value="거절" onclick="fnClosePopup('CarryForwardDiv')" />
                </div>
            </div>
        </div>
    </div>

    <%--상세보기 팝업 시작--%>

    <div id="DetailDiv" class="popupdiv divpopup-layer-package">
        <div class="popupdivWrapper" style="width: 1200px; margin: 150px auto; background-color: #ffffff;">
            <div class="popupdivContents" style="background-color: #ffffff; height: 650px; padding: 15px;">

                <div class="close-div">
                    <a onclick="fnClosePopup('DetailDiv')" style="cursor: pointer">
                        <img src="../../Images/Wish/icon-delete.jpg" alt="닫기" style="float: right;" /></a>
                </div>

                <div class="popup-title">
                    <h3 class="pop-title">내역확인</h3>
                    <%--  <img src="../" alt="[영업팀용] 수정 확인" />--%>
                    <div>

                        <h3 style="font-size: 25px" class="pop-title">주문상품</h3>
                        여신결제번호 :
                        <input type="text" style="border: none;" name="popOrderCodeNo" id="popOrderCodeNo" value="" />

                    </div>
                    <div class="CommonList-tbl" style="border: 1px solid #a2a2a2; float: left;">
                        <table id="ComTbl" class="CommonList-tbl">
                            <tr>
                                <th colspan="2">회사코드/명</th>
                                <td colspan="2">
                                    <span id="ComCode_Name"></span>
                                    <%-- <input type="text" style="height: 25px; width: 99%" id="ComCode_Name" name="ComCode_Name" value=""></td>--%>
                                <th colspan="2">담당자</th>
                                <td colspan="2">
                                    <span id="UrianAdminName"></span>
                                    <%--  <input type="text" style="height: 25px; width: 99%" id="UrianAdminName" name="UrianAdminName" value=""></td>--%>
                            </tr>

                            <tr>
                                <th>월 마감일</th>
                                <td>
                                    <span id="LoanEndDate"></span>
                                    <%--      <input type="text" id="LoanEndDate" name="LoanEndDate" value=""></td>--%>
                                <th>세금계산서 발행일</th>
                                <td>
                                    <span id="LoanBillDate"></span>
                                    <%--  <input type="text" id="LoanBillDate" name="LoanBillDate" value=""></td>--%>
                                <th>결제일</th>
                                <td>
                                    <span id="LoanCalDate"></span>
                                    <%-- <input type="text" id="LoanCalDate" name="LoanCalDate" value=""></td>--%>
                                <th>결제 신청일</th>
                                <td>
                                    <span id="EntryDate"></span>
                                    <%--     <input type="text" id="EntryDate" name="EntryDate" value=""></td>--%>
                            </tr>

                            <tr>
                                <th>마감금액</th>
                                <td>
                                    <span id="LoanMonsPayPrice"></span>
                                    <%--   <input type="text" id="LoanMonsPayPrice" name="LoanMonsPayPrice" value=""></td>--%>
                                <th>결제금액</th>
                                <td>
                                    <span id="LoanPayUsePrice"></span>
                                    <%--<input type="text" id="LoanPayUsePrice" name="LoanPayUsePrice" value=""></td>--%>
                                <th>미수금액</th>
                                <td>
                                    <span id="OutStandAmount"></span>
                                    <%--        <input type="text" id="OutStandAmount" name="OutStandAmount" value=""></td>--%>
                                <th>결제현황</th>
                                <td>
                                    <span id="LoanPayList"></span>
                                    <%--  <input type="text" id="LoanPayList" name="LoanPayList" value=""></td>--%>
                            </tr>
                        </table>
                    </div>
                    <br />
                    <br />
                    <br />
                    <br />
                    <br />
                    <%--    <!-- 주문 상품 테이블 -->
                    <div style="height: 300px">
                        <table class="CommonList-tbl">
                            <tr>
                                <th>여신한도</th>
                                <td></td>
                                <th>미수금</th>
                                <td></td>
                                <th>마감예상액</th>
                                <td></td>
                                <th>예상잔여한도</th>
                                <td></td>
                            </tr>

                            <tr>
                                <th>마감일</th>
                                <td></td>
                                <th>세금계산서발행일</th>
                                <td></td>
                                <th>결제일</th>
                                <td></td>
                                <th colspan="2">
                                    <input type="button" value="수정하기" />
                                </th>

                            </tr>

                        </table>--%>

                    <br />
                    <br />
                    <br />
                    <div class="list-div" style="width: 1170px;">
                        <div class="CommonList-tbl">
                            <table id="CommListtbl">
                                <thead>
                                    <tr>

                                        <th style="width: 390px">번호</th>
                                        <th style="width: 390px">입금정보등록일</th>
                                        <th style="width: 390px">입력금액</th>
                                    </tr>

                                </thead>
                                <tbody>
                                    <tr>
                                        <td colspan="3" class="txt-center">리스트을 조회해 주시기 바랍니다.</td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                        &nbsp;&nbsp;
                 
                    </div>
                </div>


                <div style="margin: 0 auto; text-align: center">
                    <input type="hidden" id="hdTotalCount_2" />
                    <div id="pagination_2" class="page_curl" style="display: inline-block"></div>
                </div>

                <!--조회 버튼-->
                <div class="bt-align-div">
                    <input type="button" class="commonBtn" style="width: 95px; height: 30px; font-size: 12px" value="확인" onclick="fnClosePopup('DetailDiv'); return false;" />
                </div>
                <%-- <img src="../" alt="취소" onclick="fnCancel()" />--%>
            </div>
        </div>
    </div>
    <!-- 팝업버튼 -->



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

    <%--담당자 팝업--%>
    <div id="admUserIdSearchDiv" class="popupdiv divpopup-layer-package">
        <div class="popupdivWrapper" style="width: 650px; height: 650px">
            <div class="popupdivContents">

                <div class="close-div">
                    <a onclick="fnClosePopup('admUserIdSearchDiv'); return false;" style="cursor: pointer">
                        <img src="../Images/icon-delete.jpg" alt="닫기" style="float: right;" /></a>
                </div>
                <div class="popup-title">
                    <h3 class="pop-title">검색조건 선택</h3>
                    <div class="search-div">
                        <select id="ddlPopSearch2">
                            <option value="Name">이름</option>
                            <option value="Id">아이디</option>
                        </select>
                        <input type="text" class="text-code" id="txtPopSearch2" placeholder="검색어를 입력해 주세요." onkeypress="return fnAdminPopupEnter();" style="width: 300px" />
                        <input type="button" value="검색" style="width:75px" class="mainbtn type1" onclick="fnAdmUserIdSearch(1); return false;">
                    </div>
                    <div class="divpopup-layer-conts">
                        <table id="tblPopupAdmUserId" class="tbl_main">
                            <thead>
                                <tr>
                                    <th>선택</th>
                                    <th>번호</th>
                                    <th>담당자 ID</th>
                                    <th>담당자명</th>
                                </tr>
                            </thead>
                            <tbody id="pop_admUserIdTbody">
                                <tr>
                                    <td colspan="4" class="text-center">리스트가 없습니다.</td>
                                </tr>
                            </tbody>
                        </table>
                        <!-- 페이징 처리 -->
                        <div style="margin: 0 auto; text-align: center; padding-top: 10px">
                            <input type="hidden" id="hdTotalCount2" />
                            <div id="pagination2" class="page_curl" style="display: inline-block"></div>
                        </div>
                    </div>

                    <div class="btn_center">
                        <input type="button" value="취소" style="width:75px" class="mainbtn type2" onclick="fnClosePopup('admUserIdSearchDiv'); return false;">
                        <input type="button" value="확인" style="width:75px" class="mainbtn type1" onclick="fnPopupOkAdmUserId(); return false;">      
                   </div>
                </div>
            </div>
        </div>
    </div>

</asp:Content>

