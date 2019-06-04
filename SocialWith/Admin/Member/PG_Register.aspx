<%@ Page Language="C#" MasterPageFile="~/Admin/Master/AdminMasterPage.master" AutoEventWireup="true" CodeFile="PG_Register.aspx.cs" Inherits="Admin_Member_PG_Register" %>

<%@ Register Src="~/UserControl/ucListControl.ascx" TagName="ListPager" TagPrefix="ucPager" %>
<%@ Import Namespace="Urian.Core" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <link href="../Content/Goods/goods.css" rel="stylesheet" />
    <link href="../Content/Member/member.css" rel="stylesheet" />
    <script type="text/javascript">
        var is_sending = false;
        //업체코드 팝업창
        function fnAddPopupOpen() {

            fnOpenDivLayerPopup('corpCodeAdiv');
            
        }


        //팝업창 닫기

        //function fnCancel() {
        //    $('.divpopup-layer-package').fadeOut();
        //}
        $(document).ready(function () {

            var tableid = "tblHeader";
            ListCheckboxOnlyOne(tableid);
        });



        //업체명 키워드 조건으로 검색
        function fn_click(getPageNum) {
            $('#tblHeader tbody').empty();
            var pageSize = 10;
            var pageNum = getPageNum;
            var SearchKeyWord = $("input[name='SearchKeyWord']").val();
            SearchKeyWord = '';
            var callback = function (response) {
                $('#tblHeader tbody').empty(); //테이블 클리어
                var newRowContent = "";

                if (!isEmpty(response)) {
                    $.each(response, function (key, value) { //테이블 추가
                        if (key == 0) $("#hdTotalCount_3").val(value.TotalCount);

                        newRowContent += "<tr>";
                        newRowContent += "<td style='width: 50px' class='txt-center'><input type='checkbox' id='cbDeliverySelect'/> </td>";  //선택          
                        newRowContent += "<td id='Company_Name' style='width: 100px' class='txt-center'>" + value.Company_Name + "</td>"; //업체명
                        newRowContent += "<td id='Company_Code' style='width: 100px' class='txt-center'>" + value.Company_Code + "</td>"; //업체코드
                        newRowContent += "<td id='Company_No' style='width: 100px' class='txt-center'>" + value.Company_No + "</td>"; //사업자번호
                        newRowContent += "<td id='Remark' style='width: 100px' class='txt-center'>" + value.Remark + "</td> </tr>"; //메모

                    });
                } else {
                    newRowContent += "<tr><td colspan='5' class='txt-center'>" + "조회된 데이터가 없습니다." + "</td></tr>"
                    $("#hdTotalCount_3").val(0);
                }

                $('#tblHeader tbody').append(newRowContent);

                fnCreatePagination('pagination_3', $("#hdTotalCount_3").val(), pageNum, pageSize, getPageData);



                return false;
            }

            var SearchKeyWord = $("input[name='SearchKeyWord']").val();

            var param = { Method: 'GetCompanySearch', SvidUser: '<%= Svid_User%>', SearchKeyWord: SearchKeyWord, PageNo: pageNum, PageSize: pageSize };

            //jquery Ajax function 호출 (type, url, data, responseDataType, callback)

            var beforeSend = function () {
                is_sending = true;
            }
            var complete = function () {
                is_sending = false;

            }


            if (is_sending) return false;

            JajaxDuplicationCheck("Post", "../../Handler/Common/UserHandler.ashx", param, "json", callback, beforeSend, complete, true, '<%= Svid_User %>');
        }

        //업체명 검색
        function fnComSearchPopup() {

            fn_click(1);

            fnOpenDivLayerPopup('corpCodeAdiv');
            return false;
        }


    <%--    //업체명 검색
        function fnComSearchPopup() {
            $('#tblHeader tbody').empty();
            var pageSize = 10;
            var pageNum = 1;
            var SearchKeyWord = $("input[name='SearchKeyWord']").val();
            SearchKeyWord = '';
            var callback = function (response) {
                $('#tblHeader tbody').empty(); //테이블 클리어
                var newRowContent = "";
                if (!isEmpty(response)) {
                    $.each(response, function (key, value) { //테이블 추가
                        if (key == 0) $("#hdTotalCount_3").val(value.TotalCount);

                        newRowContent += "<tr>";
                        newRowContent += "<td style='width: 50px' class='txt-center'><input type='checkbox' id='cbDeliverySelect'/> </td>";  //선택          
                        newRowContent += "<td id='Company_Name' style='width: 100px' class='txt-center'>" + value.Company_Name + "</td>"; //업체명
                        newRowContent += "<td id='Company_Code' style='width: 100px' class='txt-center'>" + value.Company_Code + "</td>"; //업체코드
                        newRowContent += "<td id='Company_No' style='width: 100px' class='txt-center'>" + value.Company_No + "</td>"; //사업자번호
                        newRowContent += "<td id='Remark' style='width: 100px' class='txt-center'>" + value.Remark + "</td> </tr>"; //메모

                    });
                } else {
                    newRowContent += "<tr><td colspan='5' class='txt-center'>" + "조회된 데이터가 없습니다." + "</td></tr>"
                    $("#hdTotalCount_3").val(0);
                }

                $('#tblHeader tbody').append(newRowContent);

                fnCreatePagination('pagination_3', $("#hdTotalCount_3").val(), pageNum, pageSize, getPageData);

                var e = document.getElementById('corpCodeAdiv');

                if (e.style.display == 'block') {
                    e.style.display = 'none';

                } else {
                    e.style.display = 'block';
                }
                return false;
            }

            var param = { Method: 'GetCompanyList', SvidUser: '<%= Svid_User%>' };

            //jquery Ajax function 호출 (type, url, data, responseDataType, callback)

            var beforeSend = function () {
                is_sending = true;
            }
            var complete = function () {
                is_sending = false;

            }


            if (is_sending) return false;

            JajaxDuplicationCheck("Post", "../../Handler/Common/UserHandler.ashx", param, "json", callback, beforeSend, complete, true, '<%= Svid_User %>');
        }--%>

        function getPageData() {
            var container = $('#pagination_3');
            var getPageNum = container.pagination('getSelectedPageNum');
            fn_click(getPageNum);
            return false;
        }

        //판매사 검색 결과 선택.
        function fnSelectCompany() {

            var selectLength = $('#tblHeader input[type="checkbox"]:checked').length;
            if (selectLength < 1) {
                alert('판매사를 선택해 주세요');
                return false;

            }

            //텍스트박스 클리어
            $('#<%= txtComName.ClientID%>').val("");
            $('#<%= txtComCode.ClientID%>').val("");
            $('#<%= txtComNo.ClientID%>').val("");
            $('#<%= txtRemark.ClientID%>').val("");

            var ComName = $('#tblHeader tr').filter(':has(:checkbox:checked)').find('td#Company_Name').text();
            var ComCode = $('#tblHeader tr').filter(':has(:checkbox:checked)').find('td#Company_Code').text();
            var ComNo = $('#tblHeader tr').filter(':has(:checkbox:checked)').find('td#Company_No').text();
            var Remark = $('#tblHeader tr').filter(':has(:checkbox:checked)').find('td#Remark').text();



            $('#<%= txtComName.ClientID%>').val(ComName);
            $('#<%= txtComCode.ClientID%>').val(ComCode);
            $('#<%= txtComNo.ClientID%>').val(ComNo);
            $('#<%= txtRemark.ClientID%>').val(Remark);

            $('.divpopup-layer-package').fadeOut();
            return false;
        }
        //엔터 키 설정  
        function fnPopSocialCompEnter() {
            if (event.keyCode == 13) {
                fn_click(1);
                return false;
            }
            else
                return true;
        }   //페이지 이동
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


        function chkPGInsert() {

            if ($('#<%= txtComName.ClientID%>').val() == '') {
                alert('업체명을 입력해주세요.')
                return false;
            }

            if ($('#<%= txtComCode.ClientID%>').val() == '') {
                alert('업체코드를 입력해주세요.')
                return false;
            }

            if ($('#<%= txtComNo.ClientID%>').val() == '') {
                alert('사업자번호를 입력해주세요.')
                return false;
            }

            if ($('#<%= txtMid.ClientID%>').val() == '') {
                alert('일반 MID 값을 입력해주세요.')
                return false;
            }

            if ($('#<%= txtMidKey.ClientID%>').val() == '') {
                alert('일반 MID 키 값을 입력해주세요.')
                return false;
            }
        }

        function fnTabClickRedirect(pageName) {
            location.href = pageName + '.aspx?ucode=' + ucode;
            return false;
        }
    </script>

    <style>
        

        .txtPg {
            border: 1px solid #a2a2a2;
            height: 26px;
        }

        .tax {
            border: 1px solid #a2a2a2;
            height: 26px;
        }

        .search-img {
            vertical-align: middle;
            margin-left: 0;
        }
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
        <br />

        <!--탭메뉴-->
        <div>
            <input type="button" class="mainbtn type1" style="width: 105px; height: 30px; font-size: 12px" value="관계사 연동 관리" onclick="fnGoPage('CLM')" />
            <input type="button" class="mainbtn type1" style="width: 105px; height: 30px; font-size: 12px" value="주문 연동 관리" onclick="fnGoPage('OBM')" />
            <input type="button" class="mainbtn type1" style="width: 105px; height: 30px; font-size: 12px" value="여신 관리" onclick="fnGoPage('LOAN')" />

        </div>
        <br />
        <!--탭메뉴-->
        <div class="div-main-tab" style="width: 100%;">
            <ul>
                <li class='tabOff' style="width: 185px;" onclick="fnTabClickRedirect('PG_Main');">
                    <a onclick="fnTabClickRedirect('PG_Main');">PG등록업체조회</a>
                </li>
                <li class='tabOn' style="width: 185px;" onclick="fnTabClickRedirect('PG_Register');">
                    <a onclick="fnTabClickRedirect('PG_Register');">PG 신규등록</a>
                </li>
            </ul>
        </div>



        <table class="tbl_main">
            <tr>
                <th>＊&nbsp;&nbsp;업체명</th>
                <td>
                    <asp:TextBox ID="txtComName" runat="server" CssClass="txtPg" Width="300" onkeypress="return preventEnter(event);"></asp:TextBox>

                    <%--<asp:ImageButton runat="server" CssClass="destination-btn" OnClientClick="btnComserch(); return false;" />--%>
                    <%--   <asp:ImageButton ID="btnComser" runat="server"  OnClick="btnComserch(); />--%>
                        &nbsp;<input type="hidden" id="hdIdCheckFlag" value="0" />
                   <input type="button" onclick="fnComSearchPopup()" value="검색" class="mainbtn type1" style="width:75px;"/>
                </td>

            </tr>
            <tr>
                <th>＊&nbsp;&nbsp;업체명</th>
                <td>
                    <asp:TextBox ID="txtComCode" runat="server" Width="300px" onkeypress="return preventEnter(event);" CssClass="txtPg"></asp:TextBox>

                </td>
            </tr>
            <tr>
                <th>＊&nbsp;&nbsp;사업자번호</th>
                <td>
                    <asp:TextBox ID="txtComNo" runat="server" oninput="return maxLengthCheck(this)" Width="300px" onkeypress="return onlyNumbers(event);" CssClass="tax"></asp:TextBox>
                    <%--                        <asp:TextBox ID="txtBusinessNum2" runat="server" TextMode="Number" max="9999" oninput="return maxLengthCheck(this)" MaxLength="2" Width="88px" onkeypress="return onlyNumbers(event);" CssClass="tax"></asp:TextBox>&nbsp;&nbsp;-&nbsp;
                        <asp:TextBox ID="txtBusinessNum3" runat="server" TextMode="Number" max="99999" oninput="return maxLengthCheck(this)" MaxLength="5" Width="88px" onkeypress="return onlyNumbers(event);" CssClass="tax"></asp:TextBox>--%>
                    <%--      <span>＊사업자번호나 고유번호를 입력해주세요.</span>--%>
                </td>
            </tr>
            <tr>
                <th>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;AID</th>
                <td>
                    <asp:TextBox ID="txtAid" runat="server" Width="300px" onkeypress="return preventEnter(event);" CssClass="txtPg"></asp:TextBox>
                    &nbsp;</td>
            </tr>
            <tr>
                <th>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;GID</th>
                <td>
                    <asp:TextBox ID="txtGid" runat="server" Width="300px" onkeypress="return preventEnter(event);" CssClass="txtPg"></asp:TextBox>
                    <label id="lbCheckText" style="color: red"></label>
                </td>
            </tr>

            <tr>
                <th>＊&nbsp;&nbsp;일반 MID</th>
                <td>
                    <asp:TextBox ID="txtMid" runat="server" CssClass="txtPg" Width="300px" onkeypress="return preventEnter(event);"></asp:TextBox>
                </td>
            </tr>

            <tr>
                <th>＊&nbsp;&nbsp;일반 KEY</th>
                <td class="auto-style1">
                    <asp:TextBox ID="txtMidKey" runat="server" CssClass="txtPg" Width="300px" onkeypress="return preventEnter(event);"></asp:TextBox>
                </td>
            </tr>
            <tr>
                <th>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;ARS MID</th>
                <td>
                    <asp:TextBox ID="txtArsMid" runat="server" CssClass="txtPg" Width="300px" onkeypress="return preventEnter(event);"></asp:TextBox>
                </td>
            </tr>
            <tr>
                <th>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;ARS KEY</th>
                <td>
                    <asp:TextBox ID="txtArsKey" runat="server" CssClass="txtPg" Width="300px" onkeypress="return preventEnter(event);"></asp:TextBox>
                </td>
            </tr>

            <tr>
                <th>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;여신 MID</th>
                <td>
                    <asp:TextBox ID="txtLoanMid" runat="server" CssClass="txtPg" Width="300px" onkeypress="return preventEnter(event);"></asp:TextBox>
                </td>
            </tr>
            <tr>
                <th>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;여신 KEY</th>
                <td>
                    <asp:TextBox ID="txtLoanKey" runat="server" CssClass="txtPg" Width="300px" onkeypress="return preventEnter(event);"></asp:TextBox>
                </td>
            </tr>
            <tr>
                <th>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;모바일 MID</th>
                <td>
                    <asp:TextBox ID="txtMobileMId" runat="server" CssClass="txtPg" Width="300px" onkeypress="return preventEnter(event);"></asp:TextBox>
                </td>
            </tr>
            <tr>
                <th>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;모바일 KEY</th>
                <td>
                    <asp:TextBox ID="txtMobileKey" runat="server" CssClass="txtPg" Width="300px" onkeypress="return preventEnter(event);"></asp:TextBox>
                </td>
            </tr>
            <tr>

                <th>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;메모</th>
                <td>
                    <asp:TextBox ID="txtRemark" runat="server" CssClass="position" Width="300px" onkeypress="return preventEnter(event);" Height="134px" TextMode="MultiLine" Style="border: 1px solid #a2a2a2; overflow: hidden; resize:none"></asp:TextBox>
                </td>
            </tr>
        </table>

        <!--저장버튼-->
        <div class="btn_center">
            <asp:Button runat="server" ID="ibSave" class="mainbtn type1" Text="저장"  style="width:75px" OnClientClick="return chkPGInsert();" OnClick="ibSave_Click" />
        </div>
        <!--저장버튼끝-->

        <%-- 업체조회 AJAX 시작--%>
        <div id="corpCodeAdiv" class="popupdiv divpopup-layer-package">
            <div class="popupdivWrapper">
                <div class="popupdivContents">

                    <div class="close-div">
                        <a onclick="fnClosePopup('corpCodeAdiv');" style="cursor: pointer">
                            <img src="../../Images/Wish/icon-delete.jpg" alt="닫기" style="float: right;" /></a>
                    </div>
                   <div class="sub-title-div">
                        <h3 class="pop-title">업체명 조회</h3>
                        <div class="search-div">
                            <input type="text" class="text-code" id="SearchKeyWord" name="SearchKeyWord" placeholder="검색어를 입력해 주세요." onkeypress="return fnPopSocialCompEnter();"/>
                            <input type="button" value="검색" style="width:75px" class="mainbtn type1" onclick="fn_click(); return false;"> 
                        </div>
                        <%--<div class="search-div">
                                <asp:TextBox runat="server" placeholder="검색어를 입력하세요." Style="padding-left: 10px; width: 100%" ID="txtSearch"></asp:TextBox>
                                <asp:Button runat="server" CssClass="notice-search-btn" ID="btnSearch" OnClick="btnSearch_Click" />
                            </div>--%>

                        <div class="divpopup-layer-conts">
                            <table id="tblHeader" class="tbl_main tbl_pop">

                                <thead>
                                    <tr>
                                        <th class="text-center">선택</th>
                                        <th class="text-center">업체명</th>
                                        <th class="text-center">업체코드</th>
                                        <th class="text-center">사업자번호</th>
                                        <th class="text-center">비고</th>
                                    </tr>
                                </thead>
                                <tbody></tbody>
                            </table>
                            <input type="hidden" id="hdDeliveryNo" />


                        </div>
                        <br />
                        <div style="margin: 0 auto; text-align: center">
                            <input type="hidden" id="hdTotalCount_3" />
                            <div id="pagination_3" class="page_curl" style="display: inline-block"></div>
                        </div>

                        <div class="btn_center">
                            <input type="button" class="mainbtn type1" style="width:75px" value="확인" onclick="fnSelectCompany()"/>
                       </div>
                </div>
            </div>
        </div>
    </div>
   
</asp:Content>

