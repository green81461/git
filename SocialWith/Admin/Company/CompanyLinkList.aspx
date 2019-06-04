<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Master/AdminMasterPage.master" AutoEventWireup="true" CodeFile="CompanyLinkList.aspx.cs" Inherits="Admin_Company_CompanyLinkList" %>
<%@ Register Src="~/UserControl/ucListControl.ascx" TagName="ListPager" TagPrefix="ucPager" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <link href="../Content/Member/member.css" rel="stylesheet" />
    <script type="text/javascript">
        var is_sending = false;

        $(document).ready(function () {

            //페이지 로드될때 전체 리스트 출력
            fnCompanyLinkListSet(1);

            // 구매사 회사구분 코드 클릭시 
            $('.tblCompanyLinkList').on("click", "a.btnBuyCompCode", function (e) {
                e.preventDefault();

                var target = e.target;
                var selBuyCompCode = $(target).siblings('input[type=hidden]').val();

                // selectbox에서 구매사 회사구분코드 선택 -> input창에 코드 세팅
                $('#selectSearchTarget option:eq(1)').prop("selected", true);
                $('#txtSearchLinkName').val(selBuyCompCode);
                fnCompanyLinkListSet(1);
            });

            // 검색창에서 검색 후 엔터키 클릭시 이벤트
            $('#txtSearchLinkName').on({
                keydown: function (e) {
                    if (e.keyCode == 13) {
                        fnCompanyLinkListSet(1);
                        return false;
                    }
                    else
                        return true;
                }
            });

            // 데이터 삭제
            $('.tblCompanyLinkList').on("click", "a.btnDelete", function (e) {
                e.preventDefault();

                var target = e.target;
                var selDelTarget = $(target).siblings('input[type=hidden]').val();
                var confirmMsg = confirm("정말로 삭제하시겠습니까?");

                if (!confirmMsg) {
                    return false;
                }

                var callback = function (response) {
                    if (!isEmpty(response)) {
                        fnCompanyLinkListSet(1);
                    }
                }

                var param = {
                    Code: selDelTarget,
                    Method: "DeleteSocialCompanyLink"
                };

                var beforeSend = function () {
                    is_sending = true;
                }
                var complete = function () {
                    is_sending = false;
                }

                if (is_sending) {
                    return false;
                }

                JqueryAjax("Post", "../../Handler/Admin/SocialCompanyHandler.ashx", false, false, param, "text", callback, beforeSend, complete, true, '<%=Svid_User %>');
            });

        });

        // 리스트 조회
        function fnCompanyLinkListSet(pageNum) {
            var asynTable = "";
            var pageSize = 20;
            var selSearchTarget = $('#selectSearchTarget').val();
            var keyword = $('#txtSearchLinkName').val();

            var callback = function (response) {

                $(".tblCompanyLinkList tbody").empty();

                if (!isEmpty(response)) {

                    $.each(response, function (index, value) {

                        asynTable += "<tr>";
                        asynTable += "<td class='txt-center' rowspan='2'>" + (index + 1) + "</td>";
                        asynTable += "<td class='txt-center' rowspan='2'>" + value.SocialCompanyLink_Code + "</td>";
                        asynTable += "<td class='txt-center' rowspan='2'>" + value.SocialCompanyLink_Name + "</td>";
                        asynTable += "<td class='txt-center'>" + value.Remark + "</td>";
                        asynTable += "<td class='txt-center'>" + value.SaleSocialCompanyName + "</td>";
                        asynTable += "<td class='txt-center'>" + value.BuySocialCompanyName + "</td>";
                        asynTable += "<td class='txt-center' rowspan='2'>" + value.SocialCompanyLinkSeq + "</td>";
                        asynTable += "<td class='txt-center' rowspan='2'>" + fnGetCurrentSeqFlag(value.CurrentSeqFlag) + "</td>"; // 설정여부 추가
                        asynTable += "<td rowspan='2'>" + value.Remark + "</td>";
                        asynTable += "<td class='txt-center' rowspan='2'>" + fnOracleDateFormatConverter(value.EntryDate) + "</td>"
                        asynTable += "<td rowspan='2' class='txt-center'><a href='#none' id='deleteLink' class='btnDelete' OnClientClick='return fnDeleteConfirm();'>삭제</a>";
                        asynTable += "<input type='hidden' value='" + value.SocialCompanyLink_Code + "' /></td >"; 
                        asynTable += "</tr><tr>"

                        //------------------------------------------------------------------------------
                        asynTable += "<td class='txt-center'><select><option value='yes'>예</option><option value='no'>아니오</option></select> <a href='#' class='btnDelete'>저장</a></td>";
                        asynTable += "<td class='txt-center'>" + value.SaleSocialCompany_Code  + "</td>";
                        asynTable += "<td class='txt-center'>";
                        asynTable += "<a href='#none' class='btnBuyCompCode'>" + value.BuySocialCompany_Code + "</a>";
                        asynTable += "<input type='hidden' id='hfBuySocialCompCode' value='" + value.BuySocialCompany_Code + "' />";
                        asynTable += "</td > ";
                        asynTable += "</tr>"

                        $("#hdTotalCount").val(value.TotalCount);
                    });

                } else {
                    asynTable += "<tr><td colspan='10' class='text-center'>" + "리스트가 없습니다." + "</td></tr>";
                    $("#hdTotalCount").val(0);
                }

                $(".tblCompanyLinkList").append(asynTable);

                // 페이징 만들어주는 함수
                fnCreatePagination('pagination', $("#hdTotalCount").val(), pageNum, 20, getPageData);
            }
            
            var param = {
                SearchTarget:selSearchTarget,
                SearchKeyword: keyword.trim(),
                PageNo: pageNum,
                PageSize: pageSize,
                Method: "GetSocialCompanyLinkList"
            };

            var beforeSend = function () {
                is_sending = true;
            }
            var complete = function () {
                is_sending = false;
            }

            JqueryAjax("Post", "../../Handler/Admin/SocialCompanyHandler.ashx", false, false, param, "json", callback, beforeSend, complete, true, '<%=Svid_User %>');
        }
        
        // 클릭한 페이지 번호를 가지고 해당 내용 조회 
        function getPageData() {
            var container = $('#pagination');
            var getPageNum = container.pagination('getSelectedPageNum');
            fnCompanyLinkListSet(getPageNum);
            return false;
        }

        // 탭메뉴 클릭시 해당 페이지로 이동
        function fnTabClickRedirect(pageName) {
            location.href = pageName + '.aspx?ucode=03';
            return false;
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

        // 설정되어있을시에 이미지 표시
        function fnGetCurrentSeqFlag(currentSeqFlag) {
            if (currentSeqFlag == 'Y') {
                return '<img src="../../Images/Company_Selected.png" />';
            } else {
                return '';
            }
        }

    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <p class="p-title-mainsentence">관계사 연동관리</p>
    <ul class="listStyle0">
        <li><a href="#none" class="mainbtn type1" onclick="fnGoPage('PG'); return false;" >PG 관리</a></li>
        <li><a href="#none" class="mainbtn type1" onclick="fnGoPage('OBM'); return false;">주문 연동 관리</a></li>
        <li><a href="#none" class="mainbtn type1" onclick="fnGoPage('LOAN'); return false;">여신 관리</a></li>
    </ul>

<!-- S. 탭메뉴-->
    <div class="div-main-tab">
        <ul>
            <li class='tabOn' onclick="fnTabClickRedirect('CompanyLinkList');">
                <a onclick="fnTabClickRedirect('CompanyLinkList');">관계사 연동 조회</a>
            </li>
            <li class='tabOff' onclick="fnTabClickRedirect('CompanyLinkRegist');">
                <a onclick="fnTabClickRedirect('CompanyLinkRegist');">관계사 연동 등록</a>
            </li>
            <li class='tabOff' onclick="fnTabClickRedirect('CompanyLinkSeqUpdate');">
                <a onclick="fnTabClickRedirect('CompanyLinkSeqUpdate');">관계사 고정 판매사 변경</a>
            </li>
        </ul>
    </div>
<!-- E. 탭메뉴 -->

<!-- S. 관계사 연동 조회 -->
    <div class="bottom-search-div">
        <table class="tbl_search">
            <tr>
                <td style="90px"></td>
                <td style="width: 200px; text-align: right;">
                    <select id="selectSearchTarget">
                        <option value="NAME">구매사 회사구분명</option>
                        <option value="CODE">구매사 회사구분코드</option>
                    </select>
                </td>
                <td>
                    <input type="text" style="width: 65%" id="txtSearchLinkName" placeholder="구매사 회사구분으로 검색" />
                    <a href="#" class="mainbtn type1" style="width:65px; text-align:center;" onclick="fnCompanyLinkListSet(1); return false;">검색</a>
                </td>
            </tr>
        </table>

        <table class="tbl_main tblCompanyLinkList interlockList" style="margin-top: 40px;">
            <colgroup>
                <col width="3%" />      <!-- 번호 -->
                <col width="9%" />     <!-- 회사연동코드 -->
                <col width="15%" />     <!-- 회사연동명 -->
                <col width="13%" />     <!-- RMP회사명 -->
                <col width="13%" />     <!-- 판매사회사구분 -->
                <col width="13%" />     <!-- 구매사회사구분 -->
                <col width="4%" />     <!-- 관계사연동순번 -->
                <col width="5%" />     <!--설정여부 -->
                <col width="11%" />     <!-- 비고 -->
                <col width="10%" />     <!-- 등록날짜 -->
                <col width="10%" />      <!-- 삭제버튼 -->
            </colgroup>
            <thead>
                <tr>
                    <th rowspan="2">번호</th>
                    <th rowspan="2">회사연동코드</th>
                    <th rowspan="2">회사연동명</th>
                    <th>RMP 회사명<br>(사용유무)</th>
                    <th>판매사 회사구분명</th>
                    <th>구매사 회사구분명</th>
                    <th rowspan="2">관계사<br />연동 순번</th>
                    <th rowspan="2">현재 판매사 <br />여부</th>
                    <th rowspan="2">비고</th>
                    <th rowspan="2">등록날짜</th>
                    <th rowspan="2">삭제</th>
                </tr>
                <tr>
                    <th>RMP 회사코드</th>
                    <th>판매사 회사구분코드</th>
                    <th>구매사 회사구분코드</th>
                </tr>
            </thead>
            <tbody>
                <tr>
                    <td colspan="10">리스트가 없습니다.</td>
                </tr>
            </tbody>
        </table>
    </div>
<!-- E. 관계사 연동 조회 -->

<!-- S. 페이징 처리 -->
    <div style="margin: 0 auto; text-align: center">
        <input type="hidden" id="hdTotalCount" />
        <div id="pagination" class="page_curl" style="display: inline-block"></div>
    </div>
<!-- E. 페이징 처리 -->
</asp:Content>

