<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Master/AdminMasterPage.master" AutoEventWireup="true" CodeFile="CompanyManagement.aspx.cs" Inherits="Admin_Company_CompanyManagement" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <link href="../Content/Company/company.css" rel="stylesheet" />
    <link href="../Content/Member/member.css" rel="stylesheet" />
   <script type="text/javascript">

        $(document).ready(function () {
            fnSetCount();
            fnSearch(1);

            $("#tblCompList tbody").on('click', 'td:not(:nth-child(10))', function () {
                fnRedirect($(this).parent());
            });
        });

        //상세확인팝업
        function popUp(event) {
            var payCode = $(event).parent().parent().find("#tdPayManagementCode").text();
            payCode = payCode.substr(1, payCode.length);
            var list = "";
            $("#ulPay").empty();

            for (var i = 0; i < payCode.length; i++) {
                if (payCode[i] == 1) {
                    switch (i) {
                        case 0:
                            list = '<li value="1" class="list_payContent">신용카드</li>';
                            $('#ulPay').append(list);
                            break;
                        case 1:
                            list = '<li value="2" class="list_payContent">실시간계좌</li>';
                            $('#ulPay').append(list);
                            break;
                        case 2:
                            list = '<li value="3" class="list_payContent">가상계좌</li>';
                            $('#ulPay').append(list);
                            break;
                        case 3:
                            list = '<li value="4" class="list_payContent">후불계좌</li>';
                            $('#ulPay').append(list);
                            break;
                        case 4:
                            list = '<li value="5" class="list_payContent">ARS(신용카드)결제</li>';
                            $('#ulPay').append(list);
                            break;
                        case 5:
                            list = '<li value="6" class="list_payContent">여신결제(일반)</li>';
                            $('#ulPay').append(list);
                            break;
                        case 6:
                            list = '<li value="7" class="list_payContent">여신결제(판매분)</li>';
                            $('#ulPay').append(list);
                            break;
                        case 7:
                            list = '<li value="8" class="list_payContent">여신결제(무)</li>';
                            $('#ulPay').append(list);
                            break;
                    }

                }
            }
            if (payCode.length == 0) {
                list = '<li class="list_payContent">조회된 구매사 결제관리내용이 없습니다.</li>';
                $('#ulPay').append(list);
            }


            //var e = document.getElementById('CompSearchDiv');

            //if (e.style.display == 'block') {
            //    e.style.display = 'none';

            //} else {
            //    e.style.display = 'block';
            //}

            fnOpenDivLayerPopup('CompSearchDiv');

            return false;
        }


        //function fnCheck() {
        //    $('#CompSearchDiv').fadeOut();
        //    return false;
        //}

        //테이블 호버
        function setTableHover() {
            $("#tblCompList tbody tr:even").each(function (index, element) {
                $(element).find(".rowColor_td").mouseover(function () {
                    $(element).find(".rowColor_td").css("background-color", "gainsboro");
                    $("#tblCompList tbody tr:eq(" + (element.rowIndex - 1) + ")").find(".rowColor_td").css("background-color", "gainsboro");

                    $(element).find(".rowColor_td").css("cursor", "pointer");
                    $("#tblCompList tbody tr:eq(" + (element.rowIndex - 1) + ")").find(".rowColor_td").css("cursor", "pointer");
                    //alert(element.rowIndex); //2 4 6
                    //alert(index); // 0 1 2              

                });
                $(element).find(".rowColor_td").mouseout(function () {
                    $(".rowColor_td").css("background-color", "");
                });
            });

            $("#tblCompList tbody tr:odd").each(function (index, element) {
                $(element).find(".rowColor_td").mouseover(function () {
                    $(element).find(".rowColor_td").css("background-color", "gainsboro");
                    $("#tblCompList tbody tr:eq(" + (index * 2) + ")").find(".rowColor_td").css("background-color", "gainsboro");

                    $(element).find(".rowColor_td").css("cursor", "pointer");
                    $("#tblCompList tbody tr:eq(" + (index * 2) + ")").find(".rowColor_td").css("cursor", "pointer");
                    // alert(element.rowIndex); //3 5 7
                    // alert(index); // 0 1 2
                });
                $(element).find(".rowColor_td").mouseout(function () {
                    $(".rowColor_td").css("background-color", "");
                });
            });



        }

        function fnRedirect(event) {
            var name = $(event).attr('name');
            var compCode = "";
            var compNo = "";
            var gubun = "";

            if (name == 'tr1') {
                //first tr
                compCode = $(event).find('#tdCompCode').text();
                compNo = $(event).next().find('#tdCompNo').text();
                gubun = $(event).find('#hdGubun').val();

            } else if (name == 'tr2') {
                //second tr
                compCode = $(event).prev().find('#tdCompCode').text();
                compNo = $(event).find('#tdCompNo').text();
                gubun = $(event).prev().find('#hdGubun').val();

            }

            if (gubun == "SU") {
                location.href = 'CompManagementInfo.aspx?compCode=' + compCode + '&compNo=' + compNo + '&gubun=' + gubun + '&ucode=' + ucode;
            } else if (gubun == "BU") {
                location.href = 'CompManagementInfo_B.aspx?compCode=' + compCode + '&compNo=' + compNo + '&gubun=' + gubun+ '&ucode=' + ucode;
                            
            } else if (gubun == "IU") {
                location.href = 'CompManagementInfo.aspx?compCode=' + compCode + '&compNo=' + compNo + '&gubun=' + gubun+ '&ucode=' + ucode;
                            
            }

            return false;
        }

        function fnSetCount() {
            var callback = function (response) {
                if (!isEmpty(response)) {
                    $("#lblTotal").text(response.TotalListCnt);

                    $("#spanB").text(response.AList_CNT);
                    $("#spanB1").text(response.AListUse_CNT);
                    $("#spanB2").text(response.AListDel_CNT);

                    $("#spanA").text(response.BList_CNT);
                    $("#spanA1").text(response.BListUse_CNT);
                    $("#spanA2").text(response.BListDel_CNT);

                } else {
                    alert("오류가 발생했습니다. 잠시 후 다시 시도해 주세요.");
                }

            }

            var sUser = '<%= Svid_User%>';
            param = { Flag: 'CompanyManagementListCount' };
            JajaxSessionCheck('Post', '../../Handler/Admin/CompanyHandler.ashx', param, 'json', callback, sUser);
        }
        //조회하기
        function fnSearch(pageNum) {
            var target = $("#sbSearchTarget").val();
            var selectComp = $("#selectComp").val();
            var keyword = $("#txtSearchKeyword").val();
            var pageSize = 20;
            var i = 1;
            var asynTable = "";

            var callback = function (response) {
                $("#tblCompList tbody").empty();

                if (!isEmpty(response)) {

                    $.each(response, function (key, value) {

                        $("#hdTotalCount").val(value.TotalCount);
                        BPayType = value.BPayType;
                        var GBimg = "";
                        if (value.Gubun_Name == "판매사") {
                            GBimg = "<img src='../../Images/Gubun-seller.png' alt='판매사'  />";
                        } else if (value.Gubun_Name == "구매사") {
                            GBimg = "<img src='../../Images/Gubun-Buyer.png' alt='구매사'  />";
                        } else {
                            GBimg = "<img src='../../Images/Gubun-RMP.png' alt='RMP'  />";
                        }
                        var deal = (value.DelFlag_Name == "거래중") ? 'Company_trading.png' : 'Company_Stoptrading.png';
                        

                        

                        //asynTable += "<tr onclick='fnRedirect(this); return false;' name='tr1'><td rowspan='2' style='border:1px solid #a2a2a2; text-align:center' class='rowColor_td'>" + (pageSize * (pageNum - 1) + i) + "</td>";
                        asynTable += "<tr name='tr1'><td rowspan='2' style='text-align:center' class='rowColor_td'>" + value.RowNumber + "</td>";
                        asynTable += "<td rowspan='2' style='text-align:center' class='rowColor_td' id='tdCompCode'>" + value.Company_Code + "</td>";
                        asynTable += "<td style='text-align:center' class='rowColor_td'>" + value.Company_Name + "</td>";
                        asynTable += "<td rowspan='2' style='text-align:center' class='rowColor_td'><input type='hidden' id='hdGubun' value='" + value.Gubun + "'/>"+ GBimg +"</td>";
                        asynTable += "<td rowspan='2' style='text-align:center' class='rowColor_td'>" + value.BillCheck_Name + "</td>";
                        asynTable += "<td rowspan='2' style='text-align:center' class='rowColor_td'><img src='../../Images/" + deal + "'  /></td>";
                        asynTable += "<td rowspan='2' style='text-align:center' class='rowColor_td'>" + value.ATypeRole + "</td>";
                        asynTable += "<td rowspan='2' style='text-align:center' class='rowColor_td'>" + value.BTypeRole + "</td>";

                        
                        var compLoanYN_Nm = value.CompLoanYN_Name;
                        var loanPriceVal = "<br/>(" + numberWithCommas(value.LoanPrice) + ")";

                        if (isEmpty(compLoanYN_Nm) || (compLoanYN_Nm == "아니오")) loanPriceVal = "";

                        //asynTable += "<td rowspan='2' style='border:1px solid #a2a2a2; text-align:center' class='rowColor_td'>" + value.CompLoanYN_Name + "<br/>(" + numberWithCommas(value.LoanPrice) + ")</td>";
                        asynTable += "<td rowspan='2' style='text-align:center' class='rowColor_td'>" + compLoanYN_Nm + loanPriceVal + "</td>";
                        asynTable += "<td rowspan='2' style='text-align:center' class='rowColor_td' id='tdPayManagementCode'>" + value.BPayType + "<br />";

                        var BPayTypeTag = "";
                        if (isEmpty(value.BPayType)) BPayTypeTag = "style = 'display:none;'"; //값이 없으면 숨김
                         //asynTable += "<img src='../Images/Member/dd-off.jpg' style='cursor:pointer' onmouseover=\"this.src='../Images/Member/dd-on.jpg'\"  onmouseout=\"this.src='../Images/Member/dd-off.jpg'\"  alt='상세확인' onclick='return popUp(this)' id='imgBPayType' " + BPayTypeTag + " /></td></tr >";//
                        asynTable += "<a class='btnDelete' onclick='return popUp(this)' id='imgBPayType' " + BPayTypeTag + ">상세확인</a></td></tr >";
                        //---------------------------------------다음행------------------------------------------------------------------
                        //asynTable += "<tr onclick='fnRedirect(this); return false;' name='tr2'><td style='border:1px solid #a2a2a2; text-align:center' class='rowColor_td' id='tdCompNo'>" + value.Company_No + "</td>"
                        asynTable += "<tr name='tr2'><td style='text-align:center' class='rowColor_td' id='tdCompNo'>" + value.Company_No + "</td>";
                        i++;
                    });

                } else {
                    asynTable += "<tr style='text-align:center;'><td colspan='10' class='txt-center'>" + "조회된 정보가 없습니다." + "</td></tr>"
                    $("#hdTotalCount").val(0);

                }
                $("#tblCompList tbody").append(asynTable);

                setTableHover();

                fnCreatePagination('pagination', $("#hdTotalCount").val(), pageNum, 20, getPageData);
            }

            var sUser = '<%= Svid_User%>';
            param = { SvidUser: sUser, Target: target, SelectComp: selectComp, Keyword: keyword, Flag: 'CompanyManagementList', PageNo: pageNum, PageSize: pageSize };
            JajaxSessionCheck('Post', '../../Handler/Admin/CompanyHandler.ashx', param, 'json', callback, sUser);
        }

        function getPageData() {
            var container = $('#pagination');
            var getPageNum = container.pagination('getSelectedPageNum');
            fnSearch(getPageNum);
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

        //팝업창 닫기

        function fnCancel() {
            $('.divpopup-layer-package').fadeOut();
        }

        //페이지 이동
        function fnGoPage(pageVal) {
         
            switch (pageVal) {
                case "MEMBER_A":
                    window.location.href = "../Member/MemberMain_A?ucode="+ucode;
                
                    break;
                case "MEMBER_B":
                    window.location.href = "../Member/MemberMain_B?ucode="+ucode;
                    break;
                default:
                    break;
            }
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div class="all">
        <div class="sub-contents-div">

            <div class="sub-title-div">
                <p class="p-title-mainsentence">
                    회사관리
                    <span class="span-title-subsentence"></span>
                </p>
            </div>
            <br />

            <div>
 
                <input type="button" class="mainbtn type1" style="width: 125px; height: 30px; font-size: 12px" value="회원관리(판매사)" onclick="fnGoPage('MEMBER_A')" />
                <input type="button" class="mainbtn type1" style="width: 125px; height: 30px; font-size: 12px" value="회원관리(구매사)" onclick="fnGoPage('MEMBER_B')" />

            </div>
            <br />
            <!--상단영역 시작-->
            <div class="memberB-div">
                <table id="tblSearch" class="tbl_search" style="height: 50px;">
                    <tr>
                        <th style="width:90px;"></th>
                        <th style="width: 10%">
                            <select id="selectComp" class="dropC2">
                                <option value="">전체</option>
                                <option value="SU">판매사</option>
                                <option value="BU">구매사</option>
                            </select>
                        </th>
                        <th style="width: 10%; padding-left: 5px;">
                            <select id="sbSearchTarget" class="dropC1">
                                <option value="COMPANYNAME">회사명</option>
                                <option value="COMPANYCODE">회사코드</option>
                            </select>
                        </th>
                        <th>
                            <input type="text" style="width:100%" id="txtSearchKeyword" placeholder="검색어를 입력하세요" onkeypress="return fnEnter();" />
                        </th>

                        <th>
                       <input type="button" class="mainbtn type1" style="width: 95px; height: 30px; font-size: 12px" value="검색" onclick="fnSearch(1); return false;" />

<%--                            <img src="../Images/Order/search-off.jpg" onmouseover="this.src='../Images/Order/search-on.jpg'" onmouseout="this.src='../Images/Order/search-off.jpg'" style="float: left; padding-left: 55px" alt="검색" onclick="fnSearch(1); return false;" />--%>
                        </th>
                    </tr>
                </table>
            </div>
            <!--상단영역 끝-->

            <br />

            <div>
                <span>총&nbsp;<label id="lblTotal"></label>&nbsp;회사&nbsp;</span>
                [
                <label id="" style="color: red;">구매사</label>&nbsp;(<span id="spanA"></span>)&nbsp;-&nbsp;<strong>거래중(<span id="spanA1"></span>)</strong>,&nbsp;&nbsp;거래중지(<span id="spanA2"></span>)&nbsp;/&nbsp;<label id="" style="color: red;">판매사</label>&nbsp;(<span id="spanB"></span>)&nbsp;-&nbsp;<strong>거래중(<span id="spanB1"></span>)</strong>,&nbsp;&nbsp;거래중지(<span id="spanB2"></span>) ]
            </div>


            <div>
                <table class="tbl_main" id="tblCompList">
                    <colgroup>
                        <col style="width: 3%" />
                        <col />
                        <col />
                        <col />
                        <col />
                        <col />
                        <col />
                        <col />
                        <col />
                        <col />
                    </colgroup>
                    <thead>
                        <tr>
                            <th rowspan="2">번호</th>
                            <th rowspan="2">회사코드</th>
                            <th>회사명</th>
                            <th rowspan="2">구분</th>
                            <th rowspan="2">세금계산서<br />
                                필수정보</th>
                            <th rowspan="2">거래현황</th>
                            <th rowspan="2">판매사<br />
                                플랫폼유형</th>
                            <th rowspan="2">구매사<br />
                                결제유형</th>
                            <th rowspan="2">구매사후불여부<br />
                                (여신한도)</th>
                            <th rowspan="2">구매사결제관리코드<br />
                                구매사결제관리내용</th>
                        </tr>
                        <tr>
                            <th>사업자번호</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td colspan="10" class="txt-center">조회된 정보가 없습니다.</td>
                        </tr>
                    </tbody>
                </table>

            </div>
            <br />

            <input type="hidden" id="hdTotalCount" />
            <!-- 페이징 처리 -->
            <div style="margin: 0 auto; text-align: center">
                <div id="pagination" class="page_curl" style="display: inline-block"></div>
            </div>
        </div>
    </div>




    <!--상세확인 팝업-->

    <div id="CompSearchDiv" class="popupdiv divpopup-layer-package">
        <div class="popupdivWrapper" style="width: 500px; height:320px;">
            <div class="popupdivContents">
                    <div class="close-div">
                        <a onclick="fnClosePopup('CompSearchDiv'); return false;" style="cursor: pointer">
                            <img src="../../Images/Wish/icon-delete.jpg" alt="닫기" style="float: right;" /></a>
                    </div>
                <div class="popup-title" style="margin-top: 20px;">
                            <h3 class="pop-title">구매사결제관리내용</h3>
                        </div>

                    <ul id="ulPay" class="pop_box">
                        <li class="list_payContent">조회된 구매사 결제관리내용이 없습니다.</li>
                    </ul>
                    <div class="btn_center">
                        <input type="button" value="확인" style="width: 75px" class="mainbtn type1" onclick="fnClosePopup('CompSearchDiv'); return false;" id="btnOK">
                    </div>
            </div>
        </div>
    </div>

</asp:Content>

