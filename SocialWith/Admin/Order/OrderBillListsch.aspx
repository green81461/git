<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Master/AdminMasterPage.master" AutoEventWireup="true" CodeFile="OrderBillListsch.aspx.cs" Inherits="Admin_Order_OrderBillListsch" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <link href="../Content/Order/order.css" rel="stylesheet" />
    <link href="../Content/popup.css" rel="stylesheet" />

    <script type="text/javascript">

        $(document).ready(function () {
            fnSearch(1)


            //var d = new Date()
            //var monthOfYear = d.getMonth()
            //d.setMonth(monthOfYear - 1)

            //$("#txtSearchSdate").val(d)



        });

        $(function () {

            ListCheckboxOnlyOne('tblPopupAdmUserId');
            ListCheckboxOnlyOne('tblPopupComp');
            //ListCheckboxOnlyOne('chkDeadLine');
            ListCheckboxOnlyOne('PayType');
            ListCheckboxOnlyOne('tdchkPay');



        });

        $(function () {
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
                showMonthAfterYear: true
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


             $('#txtSearchSdate').change(function () {
                var num = $(this).val();
                var isDateChk = false;
                if ($(this).prop('checked') == true) {
                    if (num == '0') {
                        alert('조회기간을 입력해주세요')
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
                    isDateChk = true;
                }

                if (!isDateChk) {
                    $("input:checkbox[id='ckbSearch" + num + "']").prop("checked", true);

                    return false;
                }

            });
        });

        // enter key 방지
        $(document).on("keypress", "#tblSearchPart input, #txtPopDropReason", function (e) {
            if (e.keyCode == 13) {
                e.preventDefault();
                return false;
            }
            else
                return true;
        });

        function fnQnaReqInfo() {
            alert("담당자에게 문의전화 바랍니다.\n 000-0000-0000");//수정 필요한 부분
        }

        //function showCarryForwardPopup(el) {
        //    var e = document.getElementById('CarryForwardDiv');

        //    if (e.style.display == 'block') {
        //        e.style.display = 'none';

        //    } else {
        //        e.style.display = 'block';
        //    }
        //    return false;
        //}

        //function showDetailPopup(el) {
        //    var e = document.getElementById('DetailDiv');

        //    if (e.style.display == 'block') {
        //        e.style.display = 'none';

        //    } else {
        //        e.style.display = 'block';
        //    }
        //    return false;
        //}

        //function fnCancel() {
        //    $('.popupdiv').fadeOut();
        //    return false;
        //}


        //미결제 건 수 체크 하는 함수
        function OutStanding(AdminId, ComCode) {


            var callback = function (response) {

                $.each(response, function (key, value) {

                    alert('결제일 기준, 미결제 ' + value.OutStanding_Cnt + ' 건이 있습니다.')
                    $('#NonePayment').text(value.OutStanding_Cnt); //결제일 보여주기

                });
            }
            var param = {
                CompCode: ComCode,             //구매사 회사코드
                AdminUserID: AdminId,           //영업 담당자           
                Method: 'OutStanding'
            };


            var beforeSend = function () {
            };

            var complete = function () {
            };

            JqueryAjax('Post', '../../Handler/PayHandler.ashx', true, false, param, 'json', callback, beforeSend, complete, true, '<%=Svid_User%>');


        }


        //담당자 검색 팝업 ON
        function fnSearchAdmUserIdPopup() {

            fnAdmUserIdSearch(1);
            fnOpenDivLayerPopup('admUserIdSearchDiv');
            
            return false;
        }


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
                    $("#pop_admUserIdTbody").val(0);

                }
                $("#pop_admUserIdTbody").append(asynTable);

                //페이징
                fnCreatePagination('pagination2', $("#hdTotalCount2").val(), pageNo, pageSize, getPageData2);
                return false;
            }

            var param = { Method: 'GetUserSearchList', Type: 'D', SearchTarget: searchTarget, SearchKeyword: searchKeyword, PageNo: pageNo, PageSize: pageSize };

            JajaxSessionCheck('Post', '../../Handler/Common/UserHandler.ashx', param, 'json', callback, '<%=Svid_User%>');

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

            JqueryAjax('Post', '../../Handler/Common/UserHandler.ashx', true, false, param, 'json', callback, beforeSend, complete, true, '<%=Svid_User%>');

        }
        
        //회사 조회 팝업
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
            var payWay = '';
            var dateFlag = '';
            var loanPayList_Arr = '';
            var AdminId = $('#txtSearchAdminId').val();   //영업 담당자 아이디
            var ComCode = $('#txtSearchCompCode').val();  //구매사 회사 코드
            var orderCodeNo = $('#txtOrderCodeNo').val()



            $("input[name=PayType]:checked").each(function () {
                payWay = $(this).val();
            });

            $("input[name=dedline]:checked").each(function () {

                //    var tdArr = new Array();
                var dedline = $(this).val();

                loanPayList_Arr += ',' + dedline;


            });
            loanPayList_Arr = loanPayList_Arr.substring(1)



            $("input[name=chkPay]:checked").each(function () {
                var chkPay = $(this).val();

                dateFlag += ',' + chkPay;

                //  alert(dateFlag)
            });
            dateFlag = dateFlag.substring(1)


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
                        asynTable += "<td style='border:1px solid #a2a2a2; text-align:center' class='txt-center'><input type='checkbox'/>" + "</td>";
                        asynTable += "<td style='border:1px solid #a2a2a2; text-align:center' class='txt-center'>" + fnOracleDateFormatConverter(value.Month_LoanPayDate) + "</td>";
                        asynTable += "<td style='border:1px solid #a2a2a2; text-align:center' class='txt-center'>" + value.Company_Code + "</td>";
                        asynTable += "<td style='border:1px solid #a2a2a2; text-align:center' class='txt-center'>" + value.Company_Name + "</td>";
                        asynTable += "<td style='border:1px solid #a2a2a2; text-align:center' class='txt-center'>" + value.AdminUserName + "</td>";
                        asynTable += "<td style='border:1px solid #a2a2a2; text-align:center' class='txt-center'>" + value.OrderCodeNo + "</td>";
                        asynTable += "<td style='border:1px solid #a2a2a2; text-align:center' class='txt-center'>" + value.Payway_Name + "</td>";
                        asynTable += "<td style='border:1px solid #a2a2a2; text-align:center' class='txt-center'>" + fnOracleDateFormatConverter(value.EntryDate) + "</td>";
                        asynTable += "<td style='border:1px solid #a2a2a2; text-align:center' class='txt-center'>" + numberWithCommas(value.LoanMonsPayPrice) + " 원</td>";
                        asynTable += "<td style='border:1px solid #a2a2a2; text-align:center' class='txt-center'>" + numberWithCommas(value.LoanPayUsePrice) + " 원</td>";
                        asynTable += "<td style='border:1px solid #a2a2a2; text-align:center' class='txt-center'>" + numberWithCommas(value.LoanMonthUsePrice) + " 원</td>";
                        asynTable += "<td style='border:1px solid #a2a2a2; text-align:center' class='txt-center'>" + value.LoanPayListName + "</td>";
                        //asynTable += "<td style='border:1px solid #a2a2a2; text-align:center' class='txt-center'>" + value.LoanMonsPayClearYN + "</td>";
                        //asynTable += "<td style='text-align:right'>" + numberWithCommas(value.Amt) + "원</td>";
                        //asynTable += "<td style='text-align:center'><img src='../Images/add-off.jpg' style='cursor:pointer' onmouseover=\"this.src='../Images/add-on.jpg'\"  onmouseout=\"this.src='../Images/add-off.jpg'\"  alt='상세확인' onclick='return showDetailPopup(this)' id='imgBPayType'/></td></tr >";
                        //asynTable += "  ";
                        asynTable += '</tr>';

                        i++;

                    });
                } else {
                    asynTable += "<tr><td colspan='12' class='txt-center'>" + "조회된 정보가 없습니다." + "</td></tr>"
                    $("#hdTotalCount").val(0);
                }


                $("#tblSearch tbody").append(asynTable);
                fnCreatePagination('pagination', $("#hdTotalCount").val(), pageNum, pageSize, getPageData);
                OutStanding(AdminId, ComCode);


            }

            var sUser = '<%=Svid_User %>';


            var param = {
                CompCode: ComCode,                                   //구매사 회사코드
                AdminUserID: AdminId,                                //영업 담당자
                DateFlag: dateFlag,                                  //검색 일자 구분 
                OrderCodeNo: orderCodeNo,             //여신결제번호
                PayWay: payWay,                                      //결제수단 ex) 여신일반, 여신 무 
                LoanPayList_Arr: loanPayList_Arr,                    // 결제일, 입금일 ex) 미결제,입금대기,부분결제,결제완료           
                Sdate: sdate,
                Edate: edate,
                PageNo: pageNum,
                PageSize: pageSize,
                Method: 'MonthOrderEnd_Admin'
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

        function fnExcelDownload() {
            alert("추후 개발예정입니다.");
            return false;
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
            <!--제목 타이틀-->
            <div class="sub-title-div">
                <p class="p-title-mainsentence">
                    정산내역조회(구매사)
                    <span class="span-title-subsentence"></span>
                </p>
            </div>


            <!--탭메뉴-->
            <div class="div-main-tab" style="width: 100%; ">
                <ul>
                    <li class='tabOff' style="width: 185px;" onclick="fnTabClickRedirect('OrderBillList');">
                        <a onclick="fnTabClickRedirect('OrderBillList');">마감 승인</a>
                     </li>
                    <li class='tabOff' style="width: 185px;" onclick="fnTabClickRedirect('OrderBillDeadLine');">
                         <a onclick="fnTabClickRedirect('OrderBillDeadLine');">마감 내역조회</a>
                    </li>
                    <li class='tabOn' style="width: 185px;" onclick="fnTabClickRedirect('OrderBillListsch');">
                        <a onclick="fnTabClickRedirect('OrderBillListsch');">대금결제 내역조회</a>
                    </li>
                </ul>
            </div>

            <!--상단 조회영역 시작-->
            <div class="search-div">


                <table id="tblSearchPart" class="tbl_main">
                    <colgroup>
                        <col style="width:120px"/>
                        <col style="width:420px"/>
                        <col style="width:120px" />
                        <col style="width:180px"/>
                        <col style="width:120px" />
                        <col style="width:430px"/>
                    </colgroup>                
                    <tr>
                        <th>담당자별 검색</th>
                        <td colspan="2">
                            <input type="text" id="txtSearchAdminId" class="medium-size" readonly="readonly" />&nbsp;
                            <input type="text" id="txtSearchAdminName" class="medium-size" readonly="readonly" />
                            <%--<img src="../Images/Order/search-bt-off.jpg" onmouseover="this.src='../Images/Order/search-bt-on.jpg'" onmouseout="this.src='../Images/Order/search-bt-off.jpg'" alt="검색" class="search-img" onclick="return fnSearchAdmUserIdPopup()" />--%>
                            <input type="button" class="mainbtn type1" value="검색" style="width:60px;" onclick="return fnSearchAdmUserIdPopup();"/>
                        </td>
                        <th>회사 검색</th>
                        <td colspan="2">
                            <input type="text" id="txtSearchCompCode" class="medium-size" readonly="readonly" />&nbsp;
                            <input type="text" id="txtSearchCompName" class="medium-size" readonly="readonly" />
                            <%--<img src="../Images/Order/search-bt-off.jpg" onmouseover="this.src='../Images/Order/search-bt-on.jpg'" onmouseout="this.src='../Images/Order/search-bt-off.jpg'" alt="검색" class="search-img" onclick="return fnSearchCompPopup()" />--%>
                            <input type="button" class="mainbtn type1" value="검색" style="width:60px;" onclick="return fnSearchCompPopup();"/>
                        </td>
                    </tr>

                    <tr>
                        <th class="txt-center">일자별 조회</th>
                        <td colspan="5" id="tdchkPay">
                            <asp:TextBox ID="txtSearchSdate" runat="server" CssClass="calendar" ReadOnly="true" Onkeypress="return fnEnter();"></asp:TextBox>&nbsp;&nbsp;
                            -
                            &nbsp;&nbsp;<asp:TextBox ID="txtSearchEdate" runat="server" CssClass="calendar" ReadOnly="true" Onkeypress="return fnEnter();"></asp:TextBox>&nbsp;&nbsp;
                            <input type="checkbox" id="ckbSearch1" name="chkPay" value="PAY" checked /><label for="ckbSearch1">결제일</label>&nbsp; <%--결제일이면 PAY--%>
                            <input type="checkbox" id="ckbSearch2" name="chkPay" value="DEPOSIT" />입금일 <%--입금일 DEPOSIT--%>
                            &nbsp;&nbsp;    
                        </td>
                    </tr>

                    <tr>
                        <th>여신번호 조회</th>
                        <td>
                            <input type="text" id="txtOrderCodeNo" class="medium-size"/>
                        </td>
                        <th>구분</th>
                        <td id="PayType">
                            <input type="checkbox" id="PayType1" name="PayType" value="6" />여신(일반)&nbsp;
                            <input type="checkbox" id="PayType2" name="PayType" value="8" />여신(무)&nbsp;     <%--   둘중 하나만--%>
                        </td>

                        <th>마감 현황 조회</th>
                        <td id="chkDeadLine">
                            <input type="checkbox" id="dedline1" name="dedline" value="1" /><label for="ckbSearch5">미결제</label>&nbsp;
                            <input type="checkbox" id="dedline2" name="dedline" value="2" /><label for="ckbSearch6">입금대기</label>&nbsp;
                            <input type="checkbox" id="dedline3" name="dedline" value="3" /><label for="ckbSearch7">입금완료</label>&nbsp;
                            <input type="checkbox" id="dedline4" name="dedline" value="4" /><label for="ckbSearch8">부분입금</label>&nbsp;
                            <%--파라미터 보낼 때 여러개면 쉼표 값이없으면 빈값 보내면 됨--%>
                        </td>
                    </tr>


                </table>

            </div>

            <div class="bt-align-div">
                <input type="button" class="mainbtn type1" style="width:95px; height:30px;" value="조회하기" onclick="return fnSearch(1);"/>
            </div>

            <!--상단 조회영역 끝-->
            <br />
            <br />


            <!--하단 리시트영역 시작-->
            <div class="list-div" style="width: 100%;">
                <div style="float: right; height:25px">
                    <b><span>* 현재 실시간 정보입니다. 미결제 : </span><span id="NonePayment" style="color:red;"></span><span>건</span></b>
                </div>
                <table id="tblSearch" class="tbl_main">
                    <thead>
                        <tr>
                            <th class="txt-center" style="width: 35px;">선택<br /><input type="checkbox" /></th>
                            <th class="txt-center" style="width: 85px;">결제일</th>
                            <th class="txt-center" style="width: 85px;">회사코드</th>
                            <th class="txt-center" style="width: 125px;">회사명</th>
                            <th class="txt-center" style="width: 95px;">담당자</th>
                            <th class="txt-center" style="width: 105px;">여신번호</th>
                            <th class="txt-center" style="width: 85px;">구분</th>
                            <th class="txt-center" style="width: 85px;">입금일</th>
                            <th class="txt-center" style="width: 85px;">마감금액</th>
                            <th class="txt-center" style="width: 90px;">결제금액</th>
                            <th class="txt-center" style="width: 90px;">미수금액</th>
                            <th class="txt-center" style="width: 90px;">결제현황</th>
                            <%-- <th class="txt-center" style="width: 85px;">결제보기</th>--%>
                        </tr>

                    </thead>
                    <tbody>
                        <tr>
                            <td colspan="12" class="txt-center">리스트을 조회해 주시기 바랍니다.</td>
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
                    <a>
                        <input type="button" class="mainbtn type1" style="width: 95px; height: 30px;" value="엑셀다운" onclick="return fnExcelDownload();" /></a>
                    <!-- 상세보기 이거 조회하는 화면에 넣어야함 -->
                    <%--        <a>
                        <input type="button" class="commonBtn" style="width: 95px; height: 30px; font-size: 12px" value="상세보기" onclick="showDetailPopup(this); return false;" />
                        <%--                        <img alt="상세보기" src="../" onclick="showDetailPopup(this); return false;" /></a>--%>



                    <!-- 상세보기 지원야됨-->
                    <%--  <a>
                        <img alt="요청승인" src="../" onclick="fnQnaReqInfo()" /></a>--%>
                </div>
            </div>
            <!--하단 리스트 영역 끝 -->

        </div>

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
                            <input type="text" class="text-code" id="txtPopSearch2" placeholder="검색어를 입력해 주세요." onkeypress="return fnAdminPopupEnter();" style="width: 300px;" />
                            <input type="button" value="검색" style="width:75px" class="mainbtn type1" onclick="return fnAdmUserIdSearch(1);"/>
                        </div>


                        <div class="divpopup-layer-conts">
                            <table id="tblPopupAdmUserId" class="tbl_main tbl_pop">
                                <thead>
                                    <tr>
                                        <th class="text-center" style="width: 10%">선택</th>
                                        <th class="text-center">번호</th>
                                        <th class="text-center">담당자 ID</th>
                                        <th class="text-center">담당자명</th>
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
                            <input type="button" value="취소" style="width:75px" class="mainbtn type2" onclick="return fnClosePopup('admUserIdSearchDiv');"/>
                            <input type="button" value="확인" style="width:75px" class="mainbtn type1" onclick="return fnPopupOkAdmUserId();"/>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <%--우리안 관리 담당자 ID 팝업 끝--%>
        <%--회사 팝업 시작--%>
        <div id="compSearchDiv" class="popupdiv divpopup-layer-package">
            <div class="popupdivWrapper" style="width: 650px; height: 500px">
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
                            <input type="text" class="text-code" id="txtCompPopSearch" placeholder="검색어를 입력해 주세요." onkeypress="return fnCompPopupEnter();" style="width: 300px;" />
                            <input type="button" value="검색" style="width:75px" class="mainbtn type1" onclick="return fnCompSearch(1);"//>
                        </div>


                        <div class="divpopup-layer-conts">
                            <table id="tblPopupComp" class="tbl_main">
                                <thead>
                                    <tr>
                                        <th class="text-center" style="width: 10%">선택</th>
                                        <th class="text-center">회사코드</th>
                                        <th class="text-center">회사명</th>
                                        <th class="text-center">마감일</th>
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
                            <input type="button" value="취소" style="width:75px" class="mainbtn type2" onclick="return fnClosePopup('compSearchDiv');"/>
                            <input type="button" value="확인" style="width:75px" class="mainbtn type1" onclick="return fnPopupOkComp();"/>
                        </div>
                    </div>
                </div>
            </div>
        </div>

    </div>
</asp:Content>

