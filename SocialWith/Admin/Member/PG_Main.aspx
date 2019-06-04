<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Master/AdminMasterPage.master" AutoEventWireup="true" CodeFile="PG_Main.aspx.cs" Inherits="Admin_Member_PG_Main" %>

<%@ Register Src="~/UserControl/ucListControl.ascx" TagName="ListPager" TagPrefix="ucPager" %>
<%@ Import Namespace="Urian.Core" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <link href="../Content/Goods/goods.css" rel="stylesheet" />
    <script type="text/javascript">

        $(document).on('click', '#tblHeader td:not(:nth-child(5))', function () {
            //fnShowDetail(this); return false;
        });

        var is_sending = false;

        $(document).ready(function () {

            //$('#tbodyPgMain tr').each(function () {
            //    var hdDelFlag = $(this).find("input:hidden[name='hdDelFlag']").val();

            //    if (hdDelFlag == "Y") {
            //        $(this).find("input:checkbox[name='ckbBrand']").attr("disabled", "disabled");
            //    }
            //});


            //$("#tbodyPgMain").on("mouseenter", "tr", function () {

            //    $(this).find("td").css("background-color", "#dcdcdc");
            //    $(this).find("td").css("cursor", "pointer");


            //});

            //$("#tbodyPgMain").on("mouseleave", "tr", function () {

            //    $(this).find("td").css("background-color", "");

            //    var rowIdx = this.rowIndex;
            //    if ((rowIdx % 2) == 0) {
            //        $(this).next().css("background-color", "");
            //    } else {
            //        $(this).prev().css("background-color", "");
            //    }
            //});

            fnGetPGList(1);

            $('#tbodyPgMain').on("click", "tr", function (e) {
                var target = e.target;
                var currentTarget = e.currentTarget;
                var targetCompCode = $(currentTarget).find('input[name=hdCompCode]').val();

                fnPGDetailPopShow(targetCompCode);
            });

        });

        function fnGetPGList(pageNum) {
            var asynTable = "";
            var pageSize = 20;
            var searchTarget = "All";
            var keyword = $('#txtSearch').val();

            var callback = function (response) {
                $("#tblHeader tbody").empty();
                if (!isEmpty(response)) {
                    $.each(response, function (index, value) {
                        asynTable += "<tr>";
                        asynTable += "<td class='txt-center'>" + value.RowNum + "</td>";
                        asynTable += "<td class='txt-center'>" + value.Company_Name + "</td>";
                        asynTable += "<td class='txt-center'>" + value.Company_Code;
                        asynTable += "<input type='hidden' name='hdCompCode' value='" + value.Company_Code + "' /></td>";
                        asynTable += "<td class='txt-center'>" + value.Company_No + "</td>";
                        asynTable += "<td class='txt-center'>" + value.Pg_Aid + "</td>";
                        asynTable += "<td class='txt-center'>" + value.Pg_Gid + "</td>";
                        asynTable += "<td class='txt-center'>" + value.Pg_Mid + "</td>";
                        asynTable += "<td class='txt-center'>" + value.Pg_Ars_Mid + "</td>";
                        asynTable += "<td class='txt-center'>" + value.Pg_Loan_Mid + "</td>";
                        asynTable += "<td class='txt-center'>" + value.Pg_Mobile_Mid + "</td>";
                        asynTable += "<td class='txt-center'>" + fnOracleDateFormatConverter(value.EntryDate) + "</td>";
                        asynTable += "<td class='txt-center'>" + value.Remark + "</td>";
                        asynTable += "<td class='txt-center' style='display:none'>" + value.Pg_MidKey + "</td>";
                        asynTable += "<td class='txt-center' style='display:none'>" + value.Pg_Ars_MidKey + "</td>";
                        asynTable += "<td class='txt-center' style='display:none'>" + value.Pg_Loan_MidKey + "</td>";
                        asynTable += "<td class='txt-center' style='display:none'>" + value.Pg_Mobile_MidKey + "</td>";
                        asynTable += "</tr>"

                        $("#hdTotalCount").val(value.TotalCount);
                    });

                } else {
                    asynTable += "<tr><td colspan='12'>" + "리스트가 없습니다." + "</td></tr>";
                    $("#hdTotalCount").val(0);
                }

                $("#tblHeader tbody").append(asynTable);

                // 페이징 만들어주는 함수
                fnCreatePagination('pagination', $("#hdTotalCount").val(), pageNum, 20, getPageData);
            }

            var param = {
                SearchTarget: searchTarget,
                SearchKeyword: keyword.trim(),
                PageNo: pageNum,
                PageSize: pageSize,
                Flag: "GetPGList"
            };

            var beforeSend = function () {
                is_sending = true;
            }
            var complete = function () {
                is_sending = false;
            }

            JqueryAjax("Post", "../../Handler/Admin/CompanyHandler.ashx", true, false, param, "json", callback, beforeSend, complete, true, '<%=Svid_User %>');
        }

        function getPageData() {
            var container = $('#pagination');
            var getPageNum = container.pagination('getSelectedPageNum');
            fnGetPGList(getPageNum);
            return false;
        }

        //설정에서 버튼 클릭 시
        function fnBrandManagement(el, flag) {
            var callback = function (response) {
                if (response == 'OK') {
                    alert('변경되었습니다.');
                }
                else {
                    alert('시스템 오류입니다. 개발팀에 문의하세요.');
                }
                return false;
            };
            var sUser = '<%=Svid_User %>';
            var hdBrandCode = $(el).parent().find("input:hidden[name='hdBrandCode']").val();

            var param = { SvidUser: sUser, BrandCodes: hdBrandCode, DelFlag: flag, Method: 'DelBrand' };

            var beforeSend = function () {
                is_sending = true;
            }
            var complete = function () {
                is_sending = false;
                window.location.reload(true);
            }

            if (is_sending) return false;
            JajaxDuplicationCheck('Post', '../../Handler/Common/BrandHandler.ashx', param, 'text', callback, beforeSend, complete, true, sUser);

            return false;
        }

        function fnEnter() {

            if (event.keyCode == 13) {

                fnGetPGList(1);
                return false;
            }
            
        }

        <%--function fnShowDetail(el) {
            $('#<%= txtComName.ClientID%>').val('');
            $('#<%= txtComCode.ClientID%>').val('');
            $('#<%= txtComNo.ClientID%>').val('');
            $('#<%= txtAid.ClientID%>').val('');
            $('#<%= txtGid.ClientID%>').val('');
            $('#<%= txtMid.ClientID%>').val('');
            $('#<%= txtMidKey.ClientID%>').val('');
            $('#<%= txtArsMid.ClientID%>').val('');
            $('#<%= txtArsKey.ClientID%>').val('');
            $('#<%= txtLoanMid.ClientID%>').val('');
            $('#<%= txtLoanKey.ClientID%>').val('');
            $('#<%= txtRemark.ClientID%>').val('');
            $('#<%= txtMobileMId.ClientID%>').val('');
            $('#<%= txtMobileKey.ClientID%>').val('');


            var ComName = $(el).parent().find('#tdComName').text().trim();
            var ComCode = $(el).parent().find('#tdComCode').text().trim();
            var ComNo = $(el).parent().find('#tdComNo').text().trim();
            var Aid = $(el).parent().find('#tdAid').text().trim();
            var Gid = $(el).parent().find('#tdGid').text().trim();
            var Mid = $(el).parent().find('#tdMid').text().trim();
            var MidKey = $(el).parent().find('#tdMidKey').text().trim();
            var ArsMid = $(el).parent().find('#tdArsMid').text().trim();
            var ArsKey = $(el).parent().find('#tdArsKey').text().trim();
            var LoanMid = $(el).parent().find('#tdLoanMid').text().trim();
            var LoanKey = $(el).parent().find('#tdLoanKey').text().trim();
            var Remark = $(el).parent().find('#tdRemark').text().trim();
            var MobileId = $(el).parent().find('#tdMobileMId').text().trim();
            var MobileKey = $(el).parent().find('#tdMobileKey').text().trim();


            $('#<%= txtComName.ClientID%>').val(ComName);
            $('#<%= txtComCode.ClientID%>').val(ComCode);
            $('#<%= txtComNo.ClientID%>').val(ComNo);
            $('#<%= txtAid.ClientID%>').val(Aid);
            $('#<%= txtGid.ClientID%>').val(Gid);
            $('#<%= txtMid.ClientID%>').val(Mid);
            $('#<%= txtMidKey.ClientID%>').val(MidKey);
            $('#<%= txtArsMid.ClientID%>').val(ArsMid);
            $('#<%= txtArsKey.ClientID%>').val(ArsKey);
            $('#<%= txtLoanMid.ClientID%>').val(LoanMid);
            $('#<%= txtLoanKey.ClientID%>').val(LoanKey);
            $('#<%= txtRemark.ClientID%>').val(Remark);
            $('#<%= txtMobileMId.ClientID%>').val(MobileId);
            $('#<%= txtMobileKey.ClientID%>').val(MobileKey);

            //var e = document.getElementById('PGdiv');

            //if (e.style.display == 'block') {
            //    e.style.display = 'none';

            //} else {
            //    e.style.display = 'block';
            //}
            fnOpenDivLayerPopup('PGdiv');
            return false;
        }--%>

        //function fnCancel() {
        //    $('.divpopup-layer-package').fadeOut();
        //    return false;
        //}

        function fnPGDetailPopShow(targetCompCode) {

            var companyCode = targetCompCode;

            var callback = function (response) {

                if (!isEmpty(response)) {
                    fnOpenDivLayerPopup('PGdiv');
                    $('#txtCompName').val(response.CompanyName);
                    $('#txtCompCode').val(response.CompanyCode);
                    $('#txtCompNo').val(response.CompanyNo);
                    $('#txtAid').val(response.PgAid);
                    $('#txtGid').val(response.PgGid);
                    $('#txtMid').val(response.PgMid);
                    $('#txtMidKey').val(response.PgMidKey);
                    $('#txtArsMid').val(response.PgArsMid);
                    $('#txtArsKey').val(response.PgArsMidKey);
                    $('#txtLoanMid').val(response.PgLoanMid);
                    $('#txtLoanKey').val(response.PgLoanMidKey);
                    $('#txtMobileMId').val(response.PgMobileMid);
                    $('#txtMobileKey').val(response.PgMobileMidKey);
                    $('#txtRemark').val(response.Remark);
                }
            }
            
            var param = {
                CompanyCode: companyCode,
                Flag: "GetPGDetail"
            };

            var beforeSend = function () {
                is_sending = true;
            }
            var complete = function () {
                is_sending = false;
            }

            JqueryAjax("Post", "../../Handler/Admin/CompanyHandler.ashx", false, false, param, "json", callback, beforeSend, complete, true, '<%=Svid_User %>');
        }

        function fnPGUpt() {

            var callback = function (response) {

                if (!isEmpty(response)) {
                    alert("수정되었습니다.");
                    $('#PGdiv').fadeOut();
                    fnGetPGList(1);
                    
                }
            }
            
            var param = {
                SvidUser : '<%= Svid_User%>',
                CompCode : $('#txtCompCode').val(),
                CompNo : $('#txtCompNo').val(),
                AId : $('#txtAid').val(),
                GId : $('#txtGid').val(),
                MId : $('#txtMid').val(),
                MIdKey : $('#txtMidKey').val(),
                ArsMId : $('#txtArsMid').val(),
                ArsKey : $('#txtArsKey').val(),
                LoanId : $('#txtLoanMid').val(),
                LoanKey : $('#txtLoanKey').val(),
                Remark : $('#txtRemark').val(),
                MobileId : $('#txtMobileMid').val(),
                MobileKey : $('#txtMobileKey').val(),
                Flag: "GetPGUpt"
            };

            var beforeSend = function () {
                is_sending = true;
            }
            var complete = function () {
                is_sending = false;
            }

            if (is_sending) return false;

            JqueryAjax("Post", "../../Handler/Admin/CompanyHandler.ashx", false, false, param, "text", callback, beforeSend, complete, true, '<%=Svid_User %>');
        
        }

        //페이지 이동
        function fnGoPage(pageVal) {
            switch (pageVal) {
                case "OHL":
                    window.location.href = "../Order/OrderHistoryList?ucode=" + ucode;
                    break;
                case "DL":
                    window.location.href = "../Order/DeliveryOrderList?ucode=" + ucode;
                    break;
                case "PG":
                    window.location.href = "../Member/Pg_Main?ucode=" + ucode;
                    break;
                case "LOAN":
                    window.location.href = "../Member/Loan_Main?ucode=" + ucode;
                    break;
                case "OBM":
                    window.location.href = "../Order/OrderBelongMain?ucode=" + ucode;
                    break;
                case "CLM":
                    window.location.href = "../Company/CompanyLinkManagement?ucode=" + ucode;
                    break;
                default:
                    break;
            }
        }

        function fnTabClickRedirect(pageName) {
            location.href = pageName + '.aspx?ucode=' + ucode;
            return false;
        }
    </script>
    <style>
        .board-table {
            border: 1px solid #a2a2a2;
        }

            .board-table th {
                border: 1px solid #a2a2a2;
            }

            .board-table td {
                border: 1px solid #a2a2a2;
            }

        .auto-style1 {
            position: relative;
            top: -2px;
            left: 0px;
        }

        #tblHeader tbody tr:hover{background-color:#dcdcdc; cursor:pointer}
    </style>


</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div class="all">
        <div class="sub-contents-div">
            <div class="sub-title-div">
                <p class="p-title-mainsentence">
                    PG 등록 및 조회 관리
                    <span class="span-title-subsentence"></span>
                </p>
            </div>
        </div>
        <!-- S. 탭메뉴 -->
        <div>
            <input type="button" class="mainbtn type1" style="width: 105px; height: 30px; font-size: 12px" value="관계사 연동 관리" onclick="fnGoPage('CLM')" />
            <input type="button" class="mainbtn type1" style="width: 105px; height: 30px; font-size: 12px" value="주문 연동 관리" onclick="fnGoPage('OBM')" />
            <input type="button" class="mainbtn type1" style="width: 105px; height: 30px; font-size: 12px" value="여신 관리" onclick="fnGoPage('LOAN')" />
        </div>
        <!-- E. 탭메뉴 -->
        <div class="div-main-tab" style="width: 100%;">
            <ul>
                <li class='tabOn' style="width: 185px;" onclick="fnTabClickRedirect('PG_Main');">
                    <a onclick="fnTabClickRedirect('PG_Main');">PG등록업체조회</a>
                </li>
                <li class='tabOff' style="width: 185px;" onclick="fnTabClickRedirect('PG_Register');">
                    <a onclick="fnTabClickRedirect('PG_Register');">PG 신규등록</a>
                </li>
            </ul>
        </div>

        <!--상단 조회 영역 시작-->
        <div class="search-div">
            <div class="bottom-search-div">
                <table class="tbl_search">
                    <colgroup>
                        <col width="10%" />
                        <col width="40%" />
                        <col width="40%" />
                    </colgroup>
                    <tr>
                        <td></td>
                        <td>
                            <input type="text" placeholder="업체명을 입력하세요." style="padding:0 10px; width:100%" id="txtSearch" onkeypress="return fnEnter();" />
                        </td>
                        <td>
                            <input type="button" class="mainbtn type1" id="btnSearch" value="검색" style="width:75px" onclick="fnGetPGList(1); return false;" />
                        </td>
                    </tr>
                </table>
            </div>
        </div>
        
        <div class="brand-search">
            <!--삭제, 엑셀업로드, 엑셀업로드폼다운로드 버튼 시작-->
            <%--            <div class="bt-align-div">
                <asp:ImageButton AlternateText="엑셀업로드" runat="server" ImageUrl="../Images/Goods/upload-off.jpg" onmouseover="this.src='../Images/Goods/upload-on.jpg'" onmouseout="this.src='../Images/Goods/upload-off.jpg'" />
                <asp:ImageButton AlternateText="엑셀업로드폼 다운로드" runat="server" ImageUrl="../Images/Goods/formSave-off.jpg" onmouseover="this.src='../Images/Goods/formSave-on.jpg'" onmouseout="this.src='../Images/Goods/formSave-off.jpg'" />
            </div>--%>
            <!-- S. PG 리스트 -->
            <table id="tblHeader" class="tbl_main" style="margin-top: 0; text-align:center">
                <colgroup>
                    <col width="5%" />
                    <col width="11%" />
                    <col width="7%" />
                    <col width="9%" />
                    <col width="8%" />
                    <col width="8%" />
                    <col width="8%" />
                    <col width="8%" />
                    <col width="8%" />
                    <col width="8%" />
                    <col width="8%" />
                    <col width="12%" />
                </colgroup>
                <thead>
                    <tr>
                        <th class="txt-center">등록번호</th>
                        <th class="txt-center">업체명</th>
                        <th class="txt-center">회사코드</th>
                        <th class="txt-center">사업자번호</th>
                        <th class="txt-center">AID</th>
                        <th class="txt-center">GID</th>
                        <th class="txt-center">상점아이디</th>
                        <th class="txt-center">ARS아이디</th>
                        <th class="txt-center">여신아이디</th>
                        <th class="txt-center">모바일아이디</th>
                        <th class="txt-center">PG 등록일자</th>
                        <th class="txt-center">비고</th>
                    </tr>
                </thead>
                <tbody id="tbodyPgMain">
                </tbody>
            </table>
            <!-- E. PG 리스트 -->

            <!-- S. 페이징 처리 -->
            <div style="margin:10px auto 0; text-align: center">
                <input type="hidden" id="hdTotalCount" />
                <div id="pagination" class="page_curl" style="display: inline-block"></div>
            </div>
        <!-- E. 페이징 처리 -->
        </div>
        <!--엑셀다운로드,저장 버튼-->
        <%--<div class="bt-align-div">
                <asp:ImageButton AlternateText="엑셀저장" runat="server" ID="btnExcel" OnClick="btnExcel_Click" ImageUrl="../../Images/Cart/excel-off.jpg" onmouseover="this.src='../../Images/Cart/excel-on.jpg'" onmouseout="this.src='../../Images/Cart/excel-off.jpg'" />
            </div>--%>
        <!--상단영역 끝 -->
    </div>


    <%--PG정보 수정 팝업 시작--%>
    <div id="PGdiv" class="divpopup-layer-package">
        <div class="popupdivWrapper" style="width:700px; height:750px">
            <div class="popupdivContents">
                <div class="close-div">
                    <a onclick="fnClosePopup('PGdiv');" style="cursor: pointer">
                        <img src="../../Images/Wish/icon-delete.jpg" alt="닫기" style="float: right;" />
                    </a>
                </div>

               <div class="sub-title-div">
                    <h3 class="pop-title">PG수정</h3>
                    <table class="tbl_main">
                        <colgroup>
                            <col width="30%"/>
                            <col width="70%"/>
                        </colgroup>
                        <tr>
                            <th>＊&nbsp;&nbsp;업체명</th>
                            <td>
                                <input type="hidden" id="hdIdCheckFlag" value="0" />
                                <input type="text" id="txtCompName" class="txtPg" style="width:90%" readonly />
                            </td>
                        </tr>
                        <tr>
                            <th>＊&nbsp;&nbsp;업체코드</th>
                            <td>
                                <input type="text" id="txtCompCode" class="txtPg" style="width:90%" readonly />
                            </td>
                        </tr>
                        <tr>
                            <th>＊&nbsp;&nbsp;사업자번호</th>
                            <td>
                                <input type="text" id="txtCompNo" class="txtPg" style="width:90%" readonly />
                            </td>
                        </tr>
                        <tr>
                            <th>＊&nbsp;&nbsp;AID</th>
                            <td>
                                <input type="text" id="txtAid" class="txtPg" style="width:90%" />
                            </td>
                        </tr>
                        <tr>
                            <th>＊&nbsp;&nbsp;GID</th>
                            <td>
                                <input type="text" id="txtGid" class="txtPg" style="width:90%" />
                                <label id="lbCheckText" style="color: red"></label>
                            </td>
                        </tr>
                        <tr>
                            <th>＊&nbsp;&nbsp;MID</th>
                            <td>
                                <input type="text" id="txtMid" class="txtPg" style="width:90%" />
                            </td>
                        </tr>
                        <tr>
                            <th>＊&nbsp;&nbsp;KEY</th>
                            <td>
                                <input type="text" id="txtMidKey" class="txtPg" style="width:90%" />
                            </td>
                        </tr>
                        <tr>
                            <th>＊&nbsp;&nbsp;ARS MID</th>
                            <td>
                                <input type="text" id="txtArsMid" class="txtPg" style="width:90%" />
                            </td>
                        </tr>
                        <tr>
                            <th>＊&nbsp;&nbsp;ARS KEY</th>
                            <td>
                                <input type="text" id="txtArsKey" class="txtPg" style="width:90%" />
                            </td>
                        </tr>
                        <tr>
                            <th>＊&nbsp;&nbsp;여신 MID
                            </th>
                            <td>
                                <input type="text" id="txtLoanMid" class="txtPg" style="width:90%" />
                            </td>
                        </tr>
                        <tr>
                            <th>＊&nbsp;&nbsp;여신 KEY
                            </th>
                            <td>
                                <input type="text" id="txtLoanKey" class="txtPg" style="width:90%" />
                            </td>
                        </tr>
                        <tr>
                            <th>＊&nbsp;&nbsp;모바일 MID
                            </th>
                            <td>
                                <input type="text" id="txtMobileMid" class="txtPg" style="width:90%" />
                            </td>
                        </tr>
                        <tr>
                            <th>＊&nbsp;&nbsp;모바일 KEY
                            </th>
                            <td>
                                <input type="text" id="txtMobileKey" class="txtPg" style="width:90%" />
                            </td>
                        </tr>
                        <tr>
                            <th>＊&nbsp;&nbsp;메모</th>
                            <td>
                                <textarea id="txtRemark" class="position" style="width:90%; height:100px; border-radius:3px; resize:none"></textarea>
                            </td>
                        </tr>
                    </table>
                    <div class="btn_center">
                        <input type="button" value="저장" style="width:75px;" class="mainbtn type1" ID="btnSave" onclick="fnPGUpt()">
                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>

