<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/Admin/Master/AdminMasterPage.master" CodeFile="Loan_Register.aspx.cs" Inherits="Admin_Member_Loan_Register" %>


<%@ Register Src="~/UserControl/ucListControl.ascx" TagName="ListPager" TagPrefix="ucPager" %>
<%@ Import Namespace="Urian.Core" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <link href="../Content/Goods/goods.css" rel="stylesheet" />
    <link href="../Content/Member/member.css" rel="stylesheet" />
   
    <script type="text/javascript">
        var is_sending = false;
        //업체코드 팝업창
        function fnAddPopupOpen() {
            //var e = document.getElementById('corpCodeAdiv');

            //if (e.style.display == 'block') {
            //    e.style.display = 'none';

            //} else {
            //    e.style.display = 'block';
            //}
            fnOpenDivLayerPopup('corpCodeAdiv');

        }

        $(document).ready(function () {

            var tableid = "tblHeader";
            ListCheckboxOnlyOne(tableid);


            var tableidcheck = "tblBuyer";
            ListCheckboxOnlyOne(tableidcheck);
        });




        //팝업창 닫기

        //function fnCancel() {
        //    $('.divpopup-layer-package').fadeOut();
        //}


        //판매사 키워드 조건으로 검색
        function fn_click(getPageNum) {
            $('#tblHeader tbody').empty();
            var pageSize = 10;
            var pageNum = getPageNum;
            var SearchKeyWord = $("input[name='SearchKeyWord']").val();
            SearchKeyWord = '';
            var callback = function (response) {
                var newRowContent = "";

                if (!isEmpty(response)) {
                    $.each(response, function (key, value) { //테이블 추가
                        if (key == 0) $("#hdTotalCount_2").val(value.TotalCount);

                        newRowContent += "<tr>";
                        newRowContent += "<td style='width: 50px' class='txt-center'><input type='checkbox' id='cbDeliverySelect'/> </td>";  //선택          
                        newRowContent += "<td id='Company_Name' style='width: 100px' class='txt-center'>" + value.Company_Name + "</td>"; //업체명
                        newRowContent += "<td id='Company_Code' style='width: 100px' class='txt-center'>" + value.Company_Code + "</td>"; //업체코드
                        newRowContent += "<td id='Company_No' style='width: 100px' class='txt-center'>" + value.Company_No + "</td>"; //사업자번호
                        newRowContent += "<td id='Remark' style='width: 100px' class='txt-center'>" + value.Remark + "</td> </tr>"; //메모

                    });

                } else {
                    newRowContent += "<tr><td colspan='5' class='txt-center'>" + "조회된 데이터가 없습니다." + "</td></tr>"
                    $("#hdTotalCount_2").val(0);
                }

                $('#tblHeader tbody').append(newRowContent);

                fnCreatePagination('pagination_2', $("#hdTotalCount_2").val(), pageNum, pageSize, getPageData2);
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


        //업체명 검색
        function fnComSearchPopup() {

            fn_click(1);
            fnOpenDivLayerPopup('corpCodeAdiv');
            //var e = document.getElementById('corpCodeAdiv');

            //if (e.style.display == 'block') {
            //    e.style.display = 'none';

            //} else {
            //    e.style.display = 'block';
            //}
            //return false;
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


        //구매사 검색 결과 선택.
        function fnSelectBCompany() {

            var selectLength = $('#tblBuyer input[type="checkbox"]:checked').length;
            if (selectLength < 1) {
                alert('구매사를 선택해 주세요');
                return false;

            }
            //텍스트박스 클리어
            $('#<%= mapPoint.ClientID%>').val("");
            $('#<%= txtBuyCom.ClientID%>').val("");




            var ComCode = $('#tblBuyer tr').filter(':has(:checkbox:checked)').find('td#Company_Code').text();
            var ComName = $('#tblBuyer tr').filter(':has(:checkbox:checked)').find('td#Company_Name').text();


            $('#<%= mapPoint.ClientID%>').val(ComCode);
            $('#<%= txtBuyCom.ClientID%>').val(ComName);



            $('.divpopup-layer-package').fadeOut();
            return false;
        }




        //구매사 매핑 코드 조회
        function fnComBuyerSearchPopup() {
            fn_Buyerclick(1);
            fnOpenDivLayerPopup('BuyerSel');
            //var e = document.getElementById('BuyerSel');

            //if (e.style.display == 'block') {
            //    e.style.display = 'none';

            //} else {
            //    e.style.display = 'block';
            //}
            return false;
        }


        function getPageData() {
            var container = $('#pagination_3');
            var getPageNum = container.pagination('getSelectedPageNum');
            fn_Buyerclick(getPageNum);
            return false;
        }


        function getPageData2() {
            var container = $('#pagination_2');
            var getPageNum = container.pagination('getSelectedPageNum');
            fn_click(getPageNum);
            return false;
        }


        function fnPopSocialCompEnter() {
            if (event.keyCode == 13) {
                fn_click(1);
                return false;
            }
            else
                return true;
        }
        function fnPopSocialCompEnter1() {

            if (event.keyCode == 13) {
                fn_Buyerclick(1);
                return false;
            }
            else
                return true;
        }   //페이지 이동
        function fnGoPage(pageVal) {
            switch (pageVal) {
                case "OHL":
                    window.location.href = "../Order/OrderHistoryList";
                    break;
                case "DL":
                    window.location.href = "../Order/DeliveryOrderList";
                    break;
                case "PG":
                    window.location.href = "../Member/Pg_Main";
                    break;
                case "LOAN":
                    window.location.href = "../Member/Loan_Main";
                    break;
                case "OBM":
                    window.location.href = "../Order/OrderBelongMain";
                    break;
                case "CLM":
                    window.location.href = "../Company/CompanyLinkManagement";
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
                    <li class='tabOff' style="width: 185px;" onclick="fnTabClickRedirect('Loan_Main');">
                        <a onclick="fnTabClickRedirect('Loan_Main');">여신 등록 업체조회</a>
                    </li>
                    <li class='tabOn' style="width: 185px;" onclick="fnTabClickRedirect('Loan_Register');">
                        <a onclick="fnTabClickRedirect('Loan_Register');">여신 신규 등록</a>
                    </li>
                </ul>
            </div>
            <br />

            <table class="tbl_main">
                <colgroup>
                    <col style="width:300px;"/>
                    <col />
                </colgroup>
                <tr>
                    <th>＊&nbsp;&nbsp;판매 회사명</th>
                    <td>
                        <asp:TextBox ID="txtComName" runat="server" CssClass="txtPg" Width="300" onkeypress="return preventEnter(event);"></asp:TextBox>
                        <input type="hidden" id="hdIdCheckFlag" value="0" />
                        <input type="button" value="검색" class='mainbtn type1' onclick="fnComSearchPopup()" style="width:75px;"/>
                    </td>

                </tr>
                <tr>
                    <th>＊&nbsp;&nbsp;판매회사코드</th>
                    <td>
                        <asp:TextBox ID="txtComCode" runat="server" ReadOnly="true" Width="300px" onkeypress="return preventEnter(event);" CssClass="txtPg"></asp:TextBox>
                    </td>
                </tr>
                <tr>
                    <th>＊&nbsp;&nbsp;사업자번호</th>
                    <td>
                        <asp:TextBox ID="txtComNo" runat="server" ReadOnly="true" oninput="return maxLengthCheck(this)" Width="300px" onkeypress="return onlyNumbers(event);" CssClass="tax"></asp:TextBox>
                        <%--                        <asp:TextBox ID="txtBusinessNum2" runat="server" TextMode="Number" max="9999" oninput="return maxLengthCheck(this)" MaxLength="2" Width="88px" onkeypress="return onlyNumbers(event);" CssClass="tax"></asp:TextBox>&nbsp;&nbsp;-&nbsp;
                        <asp:TextBox ID="txtBusinessNum3" runat="server" TextMode="Number" max="99999" oninput="return maxLengthCheck(this)" MaxLength="5" Width="88px" onkeypress="return onlyNumbers(event);" CssClass="tax"></asp:TextBox>--%>
                        <%--      <span>＊사업자번호나 고유번호를 입력해주세요.</span>--%>
                    </td>
                </tr>
                <tr>
                    <th>＊&nbsp;&nbsp;구매 회사명</th>
                    <td class="auto-style3">
                        <asp:TextBox ID="txtBuyCom" runat="server" Width="300px" onkeypress="return preventEnter(event);" CssClass="txtPg"></asp:TextBox>
                         <input type="button" value="검색" class='mainbtn type1' onclick="fnComBuyerSearchPopup()"  style="width:75px;"/>
                    </td>
                </tr>
                <tr>
                    <th>＊&nbsp;&nbsp;구매 회사코드</th>
                    <td>
                        <asp:TextBox ID="mapPoint" runat="server" Width="300px" onkeypress="return preventEnter(event);" CssClass="txtPg"></asp:TextBox>
                    </td>
                </tr>
                <tr>
                    <th>＊&nbsp;&nbsp;벌크계좌번호</th>
                    <td>
                        <asp:TextBox ID="Verk" runat="server" Width="300px" onkeypress="return preventEnter(event);" CssClass="txtPg"></asp:TextBox>
                        <label id="lbCheckText" style="color: red"></label>
                    </td>
                </tr>

                <%--<tr>
                    <th></th>
                    <td style="font-weight: bold">＊&nbsp;&nbsp;
                    </td>
                    <td>
                        <asp:TextBox ID="txtMid" runat="server" CssClass="txtPg" Width="300px" onkeypress="return preventEnter(event);"></asp:TextBox>
                    </td>
                </tr>

                <tr>
                    <th></th>
                    <td style="font-weight: bold" class="auto-style1">＊&nbsp;&nbsp;KEY
                    </td>
                    <td class="auto-style1">
                        <asp:TextBox ID="txtMidKey" runat="server" CssClass="txtPg" Width="300px" onkeypress="return preventEnter(event);"></asp:TextBox>
                    </td>
                </tr>
                <tr>
                    <th></th>
                    <td style="font-weight: bold">＊&nbsp;&nbsp;ARS MID
                    </td>
                    <td>
                        <asp:TextBox ID="txtArsMid" runat="server" CssClass="txtPg" Width="300px" onkeypress="return preventEnter(event);"></asp:TextBox>
                    </td>
                </tr>
                <tr>
                    <th style="width: 300px"></th>
                    <td style="font-weight: bold">＊&nbsp;&nbsp;ARS KEY
                    </td>
                    <td>
                        <asp:TextBox ID="txtArsKey" runat="server" CssClass="txtPg" Width="300px" onkeypress="return preventEnter(event);"></asp:TextBox>
                    </td>
                </tr>--%>
                <tr>
                    <th>＊&nbsp;&nbsp;메모</th>
                    <td>
                        <asp:TextBox ID="txtRemark" runat="server" CssClass="position" Width="300px" onkeypress="return preventEnter(event);" Height="134px" Style="border: 1px solid #a2a2a2;"></asp:TextBox>
                    </td>
                </tr>
            </table>

            <!--저장버튼-->
            <div class="bt-align-div">
                <asp:Button runat="server" ID="ibSave" ImageUrl="../Images/Member/save.jpg" Text="저장" OnClick="ibSave_Click" Style="width: 75px; height: 25px;" CssClass='mainbtn type1' />
            </div>
            <!--저장버튼끝-->

            <%-- S. 판매사 업체명 조회 팝업 --%>
            <div id="corpCodeAdiv" class="popupdiv divpopup-layer-package">
                <div class="popupdivWrapper">
                    <div class="popupdivContents">

                        <div class="close-div">
                            <a onclick="fnClosePopup('corpCodeAdiv');" style="cursor: pointer">
                                <img src="../../Images/Wish/icon-delete.jpg" alt="닫기" style="float: right;" /></a>
                        </div>
                        <div class="popup-title">
                            <h3 class="pop-title">업체명 조회</h3>
                            <div class="search-div">
                                <input type="text" class="text-code" id="SearchKeyWord" name="SearchKeyWord" placeholder="검색어를 입력하세요" onkeypress="return fnPopSocialCompEnter();" />
                                <input type="button" value="검색" style="width:75px" class="mainbtn type1" onclick="fn_click(1)">
                             </div>
                            <%--                 <div class="search-div">
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
                                <input type="hidden" id="hdTotalCount_2" />
                                <div id="pagination_2" class="page_curl" style="display: inline-block"></div>
                            </div>

                            <div class="btn_center">
                                <input type="button" value="확인" style="width:75px" class="mainbtn type1" onclick="fnSelectCompany()">
                         </div>
                    </div>
                </div>
            </div>
        </div>
            <%-- E. 판매사 조회 팝업 --%>

            <%-- S. 구매사조회 팝업--%>
            <div id="BuyerSel" class="popupdiv divpopup-layer-package">
                <div class="popupdivWrapper">
                    <div class="popupdivContents">

                        <div class="close-div">
                            <a onclick="fnClosePopup('BuyerSel');" style="cursor: pointer">
                                <img src="../../Images/Wish/icon-delete.jpg" alt="닫기" style="float: right;" /></a>
                        </div>
                        <div class="popup-title">
                            <h3 class="pop-title">구매사 업체명 조회</h3>
                            <div class="search-div" style="margin-bottom: 20px;">
                                <input type="text" class="text-code" id="BSearchKeyWord" name="BSearchKeyWord" placeholder="검색어를 입력하세요" onkeypress="return fnPopSocialCompEnter1();" />
                                <a href="#none" class="mainbtn type1" onclick="fn_Buyerclick(1); return false;" style="width:75px">검색</a>
                            </div>
                            <%--                 <div class="search-div">
                                <asp:TextBox runat="server" placeholder="검색어를 입력하세요." Style="padding-left: 10px; width: 100%" ID="txtSearch"></asp:TextBox>
                                <asp:Button runat="server" CssClass="notice-search-btn" ID="btnSearch" OnClick="btnSearch_Click" />
                            </div>--%>

                            <div class="divpopup-layer-conts">
                                <table id="tblBuyer" class="tbl_main" style="margin-top: 0; width: 100%">
                                    <colgroup>
                                        <col width="7%" />
                                        <col width="35%" />
                                        <col width="15%" />
                                        <col width="20%" />
                                        <col width="23%" />
                                    </colgroup>
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
                            <br />
                            <div style="margin: 0 auto; text-align: center">
                                <input type="hidden" id="hdTotalCount_3" />
                                <div id="pagination_3" class="page_curl" style="display: inline-block"></div>
                            </div>

                            <div class="btn_center">
                                <a href="#none" class="mainbtn type1" onclick="fnSelectBCompany(); return false;" style="width:75px">확인</a>
                            </div>

                        </div>
                    </div>
                </div>
            </div>
            <%-- E. 구매사 조회 팝업 --%>
    </div>
    </div>
</asp:Content>

