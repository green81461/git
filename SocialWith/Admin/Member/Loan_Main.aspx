<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/Admin/Master/AdminMasterPage.master" CodeFile="Loan_Main.aspx.cs" Inherits="Admin_Member_Loan_Main" %>

<%@ Register Src="~/UserControl/ucListControl.ascx" TagName="ListPager" TagPrefix="ucPager" %>
<%@ Import Namespace="Urian.Core" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <link href="../Content/Goods/goods.css" rel="stylesheet" />
    <script type="text/javascript">

        $(document).on('click', '#tblHeader td', function () {
            fnShowDetail(this); return false;
        });




        var is_sending = false;

        $(document).ready(function () {

            $('#tbodyLoan tr').each(function () {
                var hdDelFlag = $(this).find("input:hidden[name='hdDelFlag']").val();

                if (hdDelFlag == "Y") {
                    $(this).find("input:checkbox[name='ckbBrand']").attr("disabled", "disabled");
                }
            });




            $("#tbodyLoan").on("mouseenter", "tr", function () {

                $(this).find("td").css("background-color", "gainsboro");
                $(this).find("td").css("cursor", "pointer");
                //var rowIdx = this.rowIndex;
                //if ((rowIdx % 2) == 0) {
                //    $(this).next().css("background-color", "gainsboro");
                //    $(this).next().css("cursor", "pointer");
                //} else {
                //    $(this).prev().css("background-color", "gainsboro");
                //    $(this).prev().css("cursor", "pointer");
                //    //alert(rowIdx - 1);
                //}

            });

            $("#tbodyLoan").on("mouseleave", "tr", function () {

                $(this).find("td").css("background-color", "");

                var rowIdx = this.rowIndex;
                if ((rowIdx % 2) == 0) {
                    $(this).next().css("background-color", "");
                } else {
                    $(this).prev().css("background-color", "");
                }
            });

        });

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
            3000
            if (is_sending) return false;
            JajaxDuplicationCheck('Post', '../../Handler/Common/BrandHandler.ashx', param, 'text', callback, beforeSend, complete, true, sUser);


            return false;
        }

        function fnEnter() {

            if (event.keyCode == 13) {
                    <%=Page.GetPostBackEventReference(btnSearch)%>
                return false;
            }
            else
                return true;
        }

        function PopfnEnter() {

            if (event.keyCode == 13) {
                fn_Buyerclick(1);
                return false;
            }
            else
                return true;
        }

        function fnShowDetail(el) {


            $('#<%= txtComName.ClientID%>').val('');
            $('#<%= txtComCode.ClientID%>').val('');
            $('#<%= txtComNo.ClientID%>').val('');
            $('#<%= txtMappCode.ClientID%>').val('');
            $('#<%= txtMappName.ClientID%>').val('');
            $('#<%= txtRemark.ClientID%>').val('');
            $('#<%= txtBulk.ClientID%>').val('');



            var ComName = $(el).parent().find('#tdComName').text().trim();
            var ComCode = $(el).parent().find('#tdComCode').text().trim();
            var ComNo = $(el).parent().find('#tdComNo').text().trim();
            var MappCode = $(el).parent().find('#tdMappCode').text().trim();
            var Bulk = $(el).parent().find('#tdBulk').text().trim();
            var Remark = $(el).parent().find('#tdRemark').text().trim();
            var MappName = $(el).parent().find('#buyComName').text().trim();




            $('#<%= txtComName.ClientID%>').val(ComName);
            $('#<%= txtComCode.ClientID%>').val(ComCode);
            $('#<%= txtComNo.ClientID%>').val(ComNo);
            $('#<%= txtMappCode.ClientID%>').val(MappCode);
            $('#<%= txtRemark.ClientID%>').val(Remark);
            $('#<%= txtBulk.ClientID%>').val(Bulk);
            $('#<%= txtMappName.ClientID%>').val(MappName);


            //var e = document.getElementById('PGdiv');

            //if (e.style.display == 'block') {
            //    e.style.display = 'none';

            //} else {
            //    e.style.display = 'block';
            //}

            fnOpenDivLayerPopup('PGdiv');

            return false;
        }


        //function fnCancel() {
        //    $('.divpopup-layer-package').fadeOut();
        //    return false;
        //}

        function PopfnCancel() {
            //var e = document.getElementById('BuyerSel');

            //if (e.style.display == 'none') {
            //    e.style.display = 'block';

            //} else {
            //    e.style.display = 'none';
            //}

            fnOpenDivLayerPopup('BuyerSel');

            return false;
        }




        //구매사 매핑 코드 조회  
        function fnComBuyerSearchPopup() {

            $('#tblBuyer tbody').empty();
            var pageSize = 10;
            var pageNum = 1;
            var BSearchKeyWord = $("input[name='BSearchKeyWord']").val();
            $('#BSearchKeyWord').val('');
            BSearchKeyWord = '';
            var callback = function (response) {
                $('#tblBuyer tbody').empty(); //테이블 클리어
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

                $('#tblBuyer tbody').append(newRowContent);

                fnCreatePagination('pagination_3', $("#hdTotalCount_3").val(), pageNum, pageSize, getPageData);

                //var e = document.getElementById('BuyerSel');

                //if (e.style.display == 'block') {
                //    e.style.display = 'none';

                //} else {
                //    e.style.display = 'block';
                //}

                fnOpenDivLayerPopup('BuyerSel'); 

                return false;
            }

            var param = { Method: 'GetCompanyBuyer_List', SvidUser: '<%= Svid_User%>' };

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


        //구매사 검색 결과 선택.  
        function fnSelectBCompany() {

            var selectLength = $('#tblBuyer input[type="checkbox"]:checked').length;
            if (selectLength < 1) {
                alert('구매사를 선택해 주세요');
                return false;

            }
            //텍스트박스 클리어
            $('#<%= txtMappName.ClientID%>').val("");
            $('#<%= txtMappCode.ClientID%>').val("");




            var ComCode = $('#tblBuyer tr').filter(':has(:checkbox:checked)').find('td#Company_Code').text(); //구매사 코드번호
            var ComName = $('#tblBuyer tr').filter(':has(:checkbox:checked)').find('td#Company_Name').text(); //구매사명



            $('#<%= txtMappName.ClientID%>').val(ComName);
            $('#<%= txtMappCode.ClientID%>').val(ComCode);



            fnClosePopup("BuyerSel");
            // $('.divpopup-layer-package').fadeOut();
            return false;
        }

        //페이징
        function getPageData() {
            var container = $('#pagination_3');
            var getPageNum = container.pagination('getSelectedPageNum');
            fn_Buyerclick(getPageNum);
            return false;
        }


        //구매 키워드 조건으로 검색
        function fn_Buyerclick(getPageNum) {

            $('#tblBuyer tbody').empty();
            var pageSize = 10;
            var pageNum = getPageNum;
            var BSearchKeyWord = $("input[name='BSearchKeyWord']").val();
            BSearchKeyWord = '';
            var callback = function (response) {
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

                $('#tblBuyer tbody').append(newRowContent);
                fnCreatePagination('pagination_3', $("#hdTotalCount_3").val(), pageNum, pageSize, getPageData);
                return false;
            }

            var SearchKeyWord = $("input[name='BSearchKeyWord']").val();

            var param = { Method: 'GetCompanyBuyer_List', SvidUser: '<%= Svid_User%>', bSearchKeyWord: SearchKeyWord, PageNo: pageNum, PageSize: pageSize };

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
    </style>


</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div class="all">

        <div class="sub-contents-div">
            <div class="sub-title-div">
                <p class="p-title-mainsentence">
                    여신 관리
                    <span class="span-title-subsentence"></span>
                </p>
            </div>
            <br />

            <!--탭메뉴-->
            <div>
                <input type="button" class="mainbtn type1" style="width: 105px; height: 30px; font-size: 12px" value="관계사 연동 관리" onclick="fnGoPage('CLM')" />
                <input type="button" class="mainbtn type1" style="width: 105px; height: 30px; font-size: 12px" value="PG 관리" onclick="fnGoPage('PG')" />
                <input type="button" class="mainbtn type1" style="width: 105px; height: 30px; font-size: 12px" value="주문 연동 관리" onclick="fnGoPage('OBM')" />

            </div>


            <!--탭메뉴-->
            <div class="div-main-tab" style="width: 100%;">
                <ul>
                    <li class='tabOn' style="width: 185px;" onclick="fnTabClickRedirect('Loan_Main');">
                        <a onclick="fnTabClickRedirect('Loan_Main');">여신등록 업체조회</a>
                    </li>
                    <li class='tabOff' style="width: 185px;" onclick="fnTabClickRedirect('Loan_Register');">
                        <a onclick="fnTabClickRedirect('Loan_Register');">여신 신규등록</a>
                    </li>
                </ul>
            </div>
            <br />
            <%--<asp:ImageButton runat="server" ImageUrl="../Images/Member/reset-off.jpg" onmouseover="this.src='../Images/Member/reset-on.jpg'" onmouseout="this.src='../Images/Member/reset-off.jpg'"/>--%>



            <!--상단 조회 영역 시작-->
            <div class="search-div">


                <div class="bottom-search-div" style="margin-bottom: 1px">
                    <table class="tbl_search" style="margin-top: 30px; margin-bottom: 30px;">
                        <tr>
                            <td style="width: 90px"></td>

                            <td>
                                <asp:TextBox runat="server" placeholder="업체명을 입력하세요." Style="padding-left: 10px; width: 100%" ID="txtSearch" Onkeypress="return fnEnter();"></asp:TextBox>
                            </td>
                            <td style="text-align: left;">
                                <asp:Button runat="server" CssClass="mainbtn type1" ID="btnSearch" OnClick="btnSearch_Click" Text="검색" style="width:75px;"/>
                            </td>
                        </tr>
                    </table>
                    <br />
                </div>

            </div>







            <div class="brand-search">

                <asp:ListView ID="lvBrandList" runat="server" ItemPlaceholderID="phItemList" OnItemDataBound="lvBrandList_ItemDataBound">
                    <LayoutTemplate>
                        <table id="tblHeader" class="tbl_main" style="margin-top: 0; text-align: center;">
                            <colgroup>
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
                                <tr class="board-tr-height">
                                    <th class="txt-center">번호</th>
                                    <th class="txt-center">판매사명</th>
                                    <th class="txt-center">판매사코드</th>
                                    <th class="txt-center">판매사사업자번호</th>
                                    <th class="txt-center">구매사명</th>
                                    <th class="txt-center">구매사코드</th>
                                    <th class="txt-center">벌크계좌번호</th>
                                    <th class="txt-center">최근수정일자</th>
                                    <th class="txt-center">최초등록일자</th>
                                    <th class="txt-center">비고</th>
                                </tr>
                            </thead>
                            <tbody id="tbodyLoan">
                                <asp:PlaceHolder ID="phItemList" runat="server" />
                            </tbody>
                        </table>
                    </LayoutTemplate>
                    <ItemTemplate>
                        <tr class="board-tr-height">
                            <td class="txt-center">
                                <span><%# Eval("RowNumber").ToString()%></span>
                            </td>
                            <td class="txt-center" id="tdComName">
                                <%# Eval("Company_Name").ToString()%>
                            </td>
                            <td class="txt-center" id="tdComCode">
                                <%# Eval("Company_Code").ToString()%>
                            </td>
                            <td class="txt-center" id="tdComNo">
                                <%# Eval("Company_No").ToString() %>
                            </td>
                            <td class="txt-center" id="buyComName">
                                <%# Eval("BuyComName").ToString() %>
                            </td>
                            <td class="txt-center" id="tdMappCode">
                                <%# Eval("MappCompany_Code").ToString() %>
                            </td>
                            <td class="txt-center" id="tdBulk">
                                <%# Eval("BulkBankNo").ToString() %>
                            </td>
                            <td class="txt-center">
                                <%# ((DateTime)(Eval("UpdateDate"))).ToString("yyyy-MM-dd")%>
                            </td>
                            <td class="txt-center">
                                <%# ((DateTime)(Eval("EntryDate"))).ToString("yyyy-MM-dd")%>
                            </td>
                            <td class="txt-center" id="tdRemark">
                                <%# Eval("Remark").ToString() %>
                                <asp:HiddenField runat="server" ID="hfDelFlag" Value='<%# Eval("DelFlag").ToString()%>' />

                            </td>

                        </tr>
                    </ItemTemplate>
                    <EmptyDataTemplate>
                        <table class="tbl_main" style="margin-top: 0;">
                            <colgroup>
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
                                    <th class="txt-center">번호</th>
                                    <th class="txt-center">판매사명</th>
                                    <th class="txt-center">판매사코드</th>
                                    <th class="txt-center">판매사사업자번호</th>
                                    <th class="txt-center">구매사명</th>
                                    <th class="txt-center">구매사코드</th>
                                    <th class="txt-center">벌크계좌번호</th>
                                    <th class="txt-center">최근수정일자</th>
                                    <th class="txt-center">최초등록일자</th>
                                    <th class="txt-center">비고</th>
                                </tr>
                            </thead>
                            <tr>
                                <td colspan="11" class="txt-center">조회된 데이터가 없습니다.</td>
                            </tr>
                        </table>
                    </EmptyDataTemplate>
                </asp:ListView>
                <!--데이터 리스트 종료 -->

                <!--페이징-->
                <div style="margin: 0 auto; text-align: center">
                    <ucPager:ListPager ID="ucListPager" runat="server" OnPageIndexChange="ucListPager_PageIndexChange" PageSize="20" />
                </div>
            </div>
            <!--엑셀다운로드,저장 버튼-->
            <%--<div class="bt-align-div">
                <asp:ImageButton AlternateText="엑셀저장" runat="server" ID="btnExcel" OnClick="btnExcel_Click" ImageUrl="../../Images/Cart/excel-off.jpg" onmouseover="this.src='../../Images/Cart/excel-on.jpg'" onmouseout="this.src='../../Images/Cart/excel-off.jpg'" />
            </div>--%>
            <!--상단영역 끝 -->
        </div>
    </div>



    <%--LOAN정보 수정 팝업 시작--%>

    <div id="PGdiv" class="divpopup-layer-package">
        <div class="popupdivWrapper" style="height: 600px; width: 680px;">
            <div class="popupdivContents">

                <div class="close-div">
                    <a onclick="fnClosePopup('PGdiv');" style="cursor: pointer">
                        <img src="../../Images/Wish/icon-delete.jpg" alt="닫기" style="float: right;" /></a>
                </div>

                <div class="popup-title">
                    <h3 class="pop-title">여신수정</h3>
                    <table class="tbl_main">
                        <colgroup>
                            <col style="width:200px">
                            <col>
                        </colgroup>
                        <tr>
                            <th>＊&nbsp;&nbsp;판매사명
                            </th>
                            <td>
                                <asp:TextBox ID="txtComName" runat="server" CssClass="medium-size" onkeypress="return preventEnter(event);"></asp:TextBox>
                                &nbsp;<input type="hidden" id="hdIdCheckFlag" value="0" />

                            </td>

                        </tr>
                        <tr>

                            <th>＊&nbsp;&nbsp;판매사코드
                            </th>
                            <td>
                                <asp:TextBox ID="txtComCode" runat="server" onkeypress="return preventEnter(event);" CssClass="medium-size"></asp:TextBox>

                            </td>
                        </tr>
                        <tr>

                            <th>＊&nbsp;&nbsp;사업자번호
                            </th>
                            <td>
                                <asp:TextBox ID="txtComNo" runat="server" oninput="return maxLengthCheck(this)" onkeypress="return onlyNumbers(event);" CssClass="medium-size"></asp:TextBox>

                            </td>
                        </tr>
                        <tr>

                            <th>＊&nbsp;&nbsp;구매사명</th>
                            <td>
                                <asp:TextBox ID="txtMappName" runat="server" onkeypress="return preventEnter(event);" CssClass="medium-size"></asp:TextBox>
                                <input type="button" value="검색" id="btnSave" style="width:75px" class="mainbtn type1" onclick="fnComBuyerSearchPopup()">
                            </td>
                        </tr>
                        <tr>

                            <th>＊&nbsp;&nbsp;구매사코드</th>
                            <td>
                                <asp:TextBox ID="txtMappCode" runat="server" onkeypress="return preventEnter(event);" CssClass="medium-size"></asp:TextBox>
                            </td>
                        </tr>
                        <tr>

                            <th>＊&nbsp;&nbsp;벌크계좌번호
                            </th>
                            <td>
                                <asp:TextBox ID="txtBulk" runat="server" onkeypress="return preventEnter(event);" CssClass="medium-size"></asp:TextBox>
                                <label id="lbCheckText" style="color: red"></label>
                            </td>
                        </tr>
                        <tr>
                            <th>＊&nbsp;&nbsp;메모</th>
                            <td>
                                <asp:TextBox ID="txtRemark" runat="server" TextMode="MultiLine" CssClass="position" Width="450px" onkeypress="return preventEnter(event);" Height="134px" Style="border: 1px solid #a2a2a2;"></asp:TextBox>
                            </td>
                        </tr>
                    </table>
                    <div class="btn_center">                        
                        <asp:Button runat="server" ID="btnSave" Text="저장" OnClick="click_save" style="width:75px;"  class="mainbtn type1" AlternateText="저장" />
                    </div>

                </div>
            </div>
        </div>
    </div>


    <%-- 구매사조회 AJAX 시작--%>
    <div id="BuyerSel" class="divpopup-layer-package">
        <div class="popupdivWrapper" style="height: 600px; width: 680px;">
            <div class="popupdivContents">

                <div class="close-div">
                    <a onclick="fnClosePopup('BuyerSel');" style="cursor: pointer">
                        <img src="../../Images/Wish/icon-delete.jpg" alt="닫기" style="float: right;" /></a>
                </div>
                <div class="popup-title">
                    <h3 class="pop-title">업체명 조회</h3>
                    <div class="search-div">
                        <input type="text" class="text-code" style="width:300px;" id="BSearchKeyWord" name="BSearchKeyWord" placeholder="검색어를 입력하세요" onkeypress="return PopfnEnter();" />
                        <input type="button" value="검색" style="width:75px" class="mainbtn type1" onclick="fn_Buyerclick(1)">
                    </div>

                    <div class="divpopup-layer-conts">
                        <table id="tblBuyer" class="tbl_main">

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
                        <input type="hidden" id="hdBuyerSel" />
                    </div>

                    <div style="margin: 0 auto; padding-top:10px; text-align: center">
                        <input type="hidden" id="hdTotalCount_3" />
                        <div id="pagination_3" class="page_curl" style="display: inline-block"></div>
                    </div>

                    <div class="btn_center">
                        <input type="button" value="확인" style="width:75px" class="mainbtn type1" onclick="fnSelectBCompany()">                        
                    </div>

                </div>
            </div>
        </div>
    </div>


</asp:Content>

