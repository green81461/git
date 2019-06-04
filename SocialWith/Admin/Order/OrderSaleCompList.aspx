<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Master/AdminMasterPage.master" AutoEventWireup="true" CodeFile="OrderSaleCompList.aspx.cs" Inherits="Admin_Order_OrderSaleCompList" %>

<%@ Register Src="~/UserControl/ucListControl.ascx" TagName="ListPager" TagPrefix="ucPager" %>
<%@ Import Namespace="Urian.Core" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <%--<link href="../Content/order/order.css" rel="stylesheet" />--%>
    <link href="../Content/Goods/goods.css" rel="stylesheet" />

   
    <script type="text/javascript">

        $(document).ready(function () {

            //   $("td:empty").text("").parent().css('background', 'rgb(255,230,230)');
            $('#tblBasicList tbody tr').each(function (index, element) {
                var dongCode = $(this).find("td[id='tdDongCode']").text();
                //if (isEmpty(dongCode)) {
                //    $(this).css('background', 'rgb(255,230,150)');
               // }
            });
        });

        $(function () {
            var tableid = "tblHeader";
            ListCheckboxOnlyOne(tableid);

            var tableid = "tblSaleComp";
            ListCheckboxOnlyOne(tableid);




            $(".basicTbl > tbody").on("mouseenter", "tr", function () {
                $('#tblBasicList tbody tr').each(function (index, element) {
                    var dongCode = $(this).find("td[id='tdDongCode']").text();
                    if (isEmpty(dongCode)) {
                        $(this).css('background', 'rgb(255,230,150)');
                    }
                });

                $(this).css("background-color", "gainsboro");
                $(this).css("cursor", "pointer");

            });
            $(".basicTbl > tbody").on("mouseleave", "tr", function () {
                $(this).css("background-color", "");

            });

        })
        //Enter Event
        function fnEnter() {
            if (event.keyCode == 13) {
                <%=Page.GetPostBackEventReference(imgSearch)%>
                return false;
            }
            else
                return true;
        }

        

        ///////////////// 주문 업체 팝업 영역 //////////////////

        //주문 업체 목록 조회
        function fnGetCompanyList_A(pageNum) {

            var keyword = $("#txtPopSearchSaleComp").val();
            var pageSize = 15;

            var callback = function (response) {
                $('#tblSaleComp tbody').empty(); //테이블 클리어
                var newRowContent = "";

                if (!isEmpty(response)) {

                    $.each(response, function (key, value) { //테이블 추가
                        if (key == 0) $("#hdTotalCount").val(value.TotalCount);

                        newRowContent += "<tr>";
                        newRowContent += "<td style='width: 50px' class='txt-center'><input type='checkbox' id='cbSelect'/>";
                        newRowContent += "<input type='hidden' name='hdCompNo' value='" + value.Company_No + "'";
                        newRowContent += "</td > ";  //선택
                        newRowContent += "<td id='SaleComp_Name" + key + "' style='width: 100px' class='txt-center'>" + value.Company_Name + "</td>"; //회사명
                        newRowContent += "<td id='SaleComp_Code" + key + "' style='width: 100px' class='txt-center'>" + value.Company_Code + "</td> </tr>"; //회사코드
                    });
                } else {
                    newRowContent += "<tr><td colspan='3' class='txt-center'>" + "조회된 데이터가 없습니다." + "</td></tr>"
                    $("#hdTotalCount").val(0);
                }
                $('#tblSaleComp tbody').append(newRowContent);

                fnCreatePagination('pagination', $("#hdTotalCount").val(), pageNum, pageSize, getPageData);

                return false;
            }

            var param = {
                Flag: 'CompList_A',
                CompNm: keyword,
                PageNo: pageNum,
                PageSize: pageSize,
            };

            
            JqueryAjax('Post', '../../Handler/Admin/CompanyHandler.ashx', true, false, param, 'json', callback, null, null, true, '<%=Svid_User%>');
        }
        function getPageData() {
            var container = $('#pagination');
            var getPageNum = container.pagination('getSelectedPageNum');
            fnGetCompanyList_A(getPageNum);
            return false;
        }

        //주문 업체 팝업
        function fnSearchSaleCompPopup() {
            $("#txtPopSearchSaleComp").val('');
            fnGetCompanyList_A(1);
            fnOpenDivLayerPopup('orderSaleCodediv');
           

            return false;
        }

        function fnPopupOkSaleComp() {
            var isCheck = false;
            $('#tblSaleComp tbody tr').each(function (index, element) {
                if ($(this).find("input[type = checkbox]").prop('checked') == true) {
                    var name = $(this).find("td[id^='SaleComp_Name']").text();
                    var code = $(this).find("td[id^='SaleComp_Code']").text();
                    var compNo = $(this).find("input:hidden[name^='hdCompNo']").val();

                    $('#<%= txtOrderCompCode.ClientID%>').val(code);
                    $('#<%= txtOrderCompName.ClientID%>').val(name);
                    $('#<%= txtComNo.ClientID%>').val(compNo);


                    isCheck = true;
                }
            });

            if (!isCheck) {
                alert("주문 업체를 선택해 주세요.");
                return false;
            }
            fnClosePopup('orderSaleCodediv');
        }

        function fnPopSaleCompEnter() {
            if (event.keyCode == 13) {
                fnGetCompanyList_A(1);
                return false;
            }
            else
                return true;
        }

        ///////////////// 사업자 구분 팝업 영역 //////////////////

        //사업자 구분 목록 조회
        function fnGetSocialCompList(pageNum) {

            var keyword = $("#txtPopSearchSocialComp").val();
            var pageSize = 15;

            var callback = function (response) {
                $('#tblSocialComp tbody').empty(); //테이블 클리어
                var newRowContent = "";

                if (!isEmpty(response)) {

                    $.each(response, function (key, value) { //테이블 추가
                        if (key == 0) $("#hdTotalCount_3").val(value.TotalCount);

                        newRowContent += "<tr>";
                        newRowContent += "<td style='width: 50px' class='txt-center'><input type='checkbox' id='cbSelect'/></td>";  //선택
                        newRowContent += "<td id='SocialComp_Name" + key + "' style='width: 100px' class='txt-center'>" + value.SocialCompany_Name + "</td>"; //회사명
                        newRowContent += "<td id='SocialComp_Code" + key + "' style='width: 100px' class='txt-center'>" + value.SocialCompany_Code + "</td> </tr>"; //회사코드
                    });
                } else {
                    newRowContent += "<tr><td colspan='3' class='txt-center'>" + "조회된 데이터가 없습니다." + "</td></tr>"
                    $("#hdTotalCount_3").val(0);
                }
                $('#tblSocialComp tbody').append(newRowContent);

                fnCreatePagination('pagination_3', $("#hdTotalCount_3").val(), pageNum, pageSize, getPageData2);

                return false;
            }

            var param = {
                Method: 'SearchSocialComp',
                SocialCompNm: keyword,
                Gubun: 'SU',
                PageNo: pageNum,
                PageSize: pageSize,
            };
            
             JqueryAjax('Post', '../../Handler/Admin/SocialCompanyHandler.ashx', true, false, param, 'json', callback, null, null, true, '<%=Svid_User%>');
        }
        function getPageData2() {
            var container = $('#pagination_3');
            var getPageNum = container.pagination('getSelectedPageNum');
            fnGetSocialCompList(getPageNum);
            return false;
        }

        //사업자 구분 팝업
        function fnSearchSocialCompPopup() {
            $("#txtPopSearchSocialComp").val('');
            fnGetSocialCompList(1);
            fnOpenDivLayerPopup('socialCompCodediv');
          

            return false;
        }

        function fnPopupOkSocialComp() {
            var isCheck = false;
            $('#tblSocialComp tbody tr').each(function (index, element) {
                if ($(this).find("input[type = checkbox]").prop('checked') == true) {
                    var name = $(this).find("td[id^='SocialComp_Name']").text();
                    var code = $(this).find("td[id^='SocialComp_Code']").text();

                    $('#<%= txtGubun.ClientID%>').val(name);
                    $('#<%= hfSocialCompCode.ClientID%>').val(code);
                    isCheck = true;
                }
            });

            if (!isCheck) {
                alert("사업자 구분을 선택해 주세요.");
                return false;
            }

            fnClosePopup('socialCompCodediv');
        }

        function fnPopSocialCompEnter() {
            if (event.keyCode == 13) {
                fnGetSocialCompList(1);
                return false;
            }
            else
                return true;
        }

        function fnSetData() {

            $('#<%= hfNewCompCode.ClientID%>').val($('#<%= txtOrderCompCode.ClientID%>').val());
            $('#<%= hfNewCompName.ClientID%>').val($('#<%= txtOrderCompName.ClientID%>').val());
            $('#<%= hfNewCompNo.ClientID%>').val($('#<%= txtComNo.ClientID%>').val());
            $('#<%= hfNewGubun.ClientID%>').val($('#<%= hfSocialCompCode.ClientID%>').val());
            return true;
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

         function trMouseOver(el) {
            $(el).css("background-color", "#ececec");
        }
         function trMouseOut(el) {
            $(el).css("background-color", "white");
        }


        //주문업체조회 팝업 ajax

        function fnViewUpdatePopup(orderSaleCompanyCode, orderSaleCompanyName, companyNo, gubunName, remark, belongCode, areaCode, gubun) {
            var callback = function (response) {
                if (!isEmpty(response)) {

                    $("#<%=txtOrderCompCode.ClientID%>").val(response.OrderSaleCompanyCode);
                    $("#<%=txtOrderCompName.ClientID%>").val(response.OrderSaleCompanyName);
                    $("#<%=txtComNo.ClientID%>").val(response.CompanyNo);
                    $("#<%=txtGubun.ClientID%>").val(response.GubunName);
                    $("#<%=txtRemark.ClientID%>").val(response.Remark);

                }
            }
            var param = {
                Flag: 'GetOrderSaleCompPopup_Admin',
                OrderBelong_Code: belongCode,
                OrderArea_Code: areaCode,
                OrderSaleCompany_Code: orderSaleCompanyCode,
            };
            var beforeSend = function () {
                $('#divLoading').css('display', '');
            }
            var complete = function () {
                $('#divLoading').css('display', 'none');
                fnOpenDivLayerPopup('updateInfodiv');
            }
            JqueryAjax('Post', '../../Handler/Admin/CompanyHandler.ashx', true, false, param, 'json', callback, beforeSend, complete, true, '<%=Svid_User%>');
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">

    <div class="all">

        <div class="sub-contents-div">

            <div class="sub-title-div">
                <p class="p-title-mainsentence">
                    주문연동관리
                    <span class="span-title-subsentence"></span>
                </p>
            </div>
            <br />
            <!--상위 탭메뉴-->
            <div>
                <input type="button" class="mainbtn type1" style="width: 105px; height: 30px; font-size: 12px" value="관계사 연동 관리" onclick="fnGoPage('CLM')" />
                <input type="button" class="mainbtn type1" style="width: 105px; height: 30px; font-size: 12px" value="PG 관리" onclick="fnGoPage('PG')" />
                <input type="button" class="mainbtn type1" style="width: 105px; height: 30px; font-size: 12px" value="여신 관리" onclick="fnGoPage('LOAN')" />
            </div>


            <!--탭메뉴-->
            <div class="div-main-tab" style="width: 100%;">
                <ul>
                    <li class='tabOff' style="width: 185px;" onclick="fnTabClickRedirect('OrderBelongMain');">
                        <a onclick="fnTabClickRedirect('OrderBelongMain');">주문 소속</a>
                    </li>
                    <li class='tabOff' style="width: 185px;" onclick="fnTabClickRedirect('OrderAreaList');">
                        <a onclick="fnTabClickRedirect('OrderAreaList');">주문 지역</a>
                    </li>
                    <li class='tabOn' style="width: 185px;" onclick="fnTabClickRedirect('OrderSaleCompList');">
                        <a onclick="fnTabClickRedirect('OrderSaleCompList');">주문 업체</a>
                    </li>
                    <li></li>
                </ul>
            </div>



            <!--하위 탭메뉴-->
            <div class="tab-display1">
                <div class="tab" style="margin-top: 10px">
                    <span class="subTabOn" style="width: 186px; height: 35px; cursor: pointer;" id="btnTab1" onclick="fnTabClickRedirect('OrderSaleCompList');">주문 업체 조회</span>
                    <span class="subTabOff" style="width: 186px; height: 35px; cursor: pointer;" id="btnTab2" onclick="fnTabClickRedirect('OrderSaleCompRegister');">주문 업체 등록</span>
                    <%--<a class="tabButton1" id="btnTab1" onclick="javascript:location.href='OrderSaleCompList.aspx';">
                        <img src="../../Images/Order/belongTsub-on.jpg" alt="주문 지역 조회" /></a>
                    <a class="tabButton2" id="btnTab2" onclick="javascript:location.href='OrderSaleCompRegister.aspx';">
                        <img src="../../Images/Order/belongT2sub-off.jpg" alt="주문 지역 등록" /></a>--%>
                </div>
            </div>

            <!--상단영역 시작-->
            <div class="search-div">
                <table id="tblSearch" class="tbl_main">
                    <thead>
                        <tr>
                            <th colspan="7" style="height: 50px;">
                                <h4>주문 업체 조회</h4>
                            </th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <th style="width: 130px;">주문 소속</th>
                            <td style="width: 170px;">
                                <asp:DropDownList runat="server" ID="ddlSearchBelong" AutoPostBack="true" OnSelectedIndexChanged="ddlSearchBelong_Changed" Height="24px" Width="98%">
                                </asp:DropDownList>
                            </td>
                            <th style="width: 130px;">주문 지역</th>
                            <td style="width: 150px;">
                                <asp:DropDownList runat="server" ID="ddlSearchArea" Height="24px" Width="98%">
                                </asp:DropDownList>
                            </td>
                            <th style="width: 150px;">주문 업체</th>
                            <td style="width: 300px;">
                                <asp:TextBox ID="txtSearchSaleCompNm" runat="server" Height="24px" OnKeypress="return fnEnter();" Width="98%" placeholder="검색어를 입력하세요." Style="border: 1px solid #a2a2a2;"></asp:TextBox>
                            </td>
                            <th style="text-align: left; padding-top: 5px">
                                <asp:Button ID="imgSearch" runat="server" OnClick="imgSearch_Click" Text="검색" Style="width: 75px; height: 25px;" CssClass="mainbtn type1" />
                            </th>
                        </tr>
                    </tbody>
                </table>
            </div>
            <!--상단영역 끝-->
            <!--하단영역시작-->
            <div class="orderList-div">

                <asp:ListView runat="server" ID="lvSaleCompList" ItemPlaceholderID="phItemList" OnItemDataBound="lvSaleCompList_ItemDataBound">
                    <LayoutTemplate>
                        <table id="tblBasicList" class="tbl_main">
                            <colgroup class="">
                                <col style="width:60px;" />
                                <col style="width:110px;"/>
                                <col />
                                <col style="width:110px;"/>
                                <col/>
                                <col style="width:180px;"/>
                            </colgroup>
                            <thead>
                                <tr>
                                    <th>번호</th>
                                    <th>주문소속</th>
                                    <th>주문지역</th>
                                    <th>판매사 회사코드</th>
                                    <th>판매사 회사명</th>
                                    <th>사업자번호</th>
                                    <th>사업자구분(구매사)</th>
                                    <th>비고</th>
                                    <th>등록날짜</th>
                                </tr>
                            </thead>
                            <tbody>
                                <asp:PlaceHolder runat="server" ID="phItemList"></asp:PlaceHolder>
                            </tbody>
                        </table>
                    </LayoutTemplate>
                    <ItemTemplate>
                        <tr onclick='<%# String.Format("javascript:fnViewUpdatePopup(\"{0}\", \"{1}\",\"{2}\", \"{3}\",\"{4}\", \"{5}\", \"{6}\", \"{7}\");", Eval("OrderSaleCompanyCode") , Eval("OrderSaleCompanyName"), Eval("CompanyNo"), Eval("GubunName"), Eval("Remark"), Eval("OrderBelongCode"), Eval("OrderAreaCode"), Eval("Gubun")) %>' style="cursor:pointer;" onmouseover="trMouseOver(this)" onmouseout="trMouseOut(this)" >
                            <td><%# Eval("RowNum").AsInt()%></td>
                            <td><%# Eval("OrderBelongName").AsText()%></td>
                            <td><%# Eval("OrderAreaName").AsText()%></td>
                            <td><%# Eval("OrderSaleCompanyCode").AsText()%></td>
                            <td><%# Eval("OrderSaleCompanyName").AsText()%></td>
                            <td><%# Eval("CompanyNo").AsText()%></td>
                            <td><%# Eval("GubunName").AsText()%></td>
                            <td><%# Eval("Remark").AsText()%></td>
                            <td><%# ((DateTime)(Eval("EntryDate"))).ToString("yyyy-MM-dd")%></td>
                        </tr>
                    </ItemTemplate>
                    <EmptyDataTemplate>
                        <table class="basicTbl" style="width: 100%">
                            <colgroup>
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
                                    <th>번호</th>
                                    <th>판매사 회사코드</th>
                                    <th>판매사 회사명</th>
                                    <th>사업자번호</th>
                                    <th>사업자구분(구매사)</th>
                                    <th>비고</th>
                                    <th>등록날짜</th>
                                </tr>
                            </thead>
                            <tr>
                                <td colspan="7" style="text-align: center;">조회된 데이터가 없습니다.</td>
                            </tr>
                        </table>
                    </EmptyDataTemplate>
                </asp:ListView>

                <%--페이징 영역--%>
                <div style="margin: 0 auto; text-align: center">
                    <ucPager:ListPager ID="ucListPager" runat="server" OnPageIndexChange="ucListPager_PageIndexChange" PageSize="20" />
                </div>
            </div>

            <!--하단영역끝-->
        </div>
    </div>

    <%--LOAN정보 수정 팝업 시작--%>

    <div id="updateInfodiv" class="popupdiv divpopup-layer-package">
        <div class="popupdivWrapper" style="width: 650px; height: 450px;">
            <div class="popupdivContents">
                <div class="close-div">
                    <a onclick="fnClosePopup('updateInfodiv'); return false;" style="cursor: pointer">
                        <img src="../../Images/Wish/icon-delete.jpg" alt="닫기" style="float: right;" /></a>
                </div>             
                 <div class="popup-title" style="margin-top: 20px;">
                       <h3 class="pop-title">정보수정</h3>
                  </div>
                    <table id="tblUpdateInfo" class="tbl_main tbl_pop">
                        <colgroup>
                            <col style="width:200px"/>
                            <col />
                        </colgroup>
                        <tr>
                            <th>＊&nbsp;&nbsp;판매사코드</th>
                            <td>
                                <asp:TextBox ID="txtOrderCompCode" class="medium-size" runat="server" Enabled="false"></asp:TextBox>
                                <asp:HiddenField runat="server" ID="hfNewCompCode" />
                                <input type="button" class="mainbtn type1" style="width: 60px; height: 25px; font-size: 12px" value="검색" onclick="return fnSearchSaleCompPopup();" />

                            </td>

                        </tr>
                        <tr>

                            <th>＊&nbsp;&nbsp;판매사명
                            </th>
                            <td>
                                <asp:TextBox ID="txtOrderCompName" class="medium-size" runat="server" Enabled="false" CssClass="txtPg"></asp:TextBox>
                                <asp:HiddenField runat="server" ID="hfNewCompName" />
                            </td>
                        </tr>
                        <tr>

                            <th>＊&nbsp;&nbsp;사업자번호
                            </th>
                            <td>
                                <asp:TextBox ID="txtComNo" class="medium-size" runat="server" Enabled="false" onkeypress="return onlyNumbers(event);" CssClass="tax"></asp:TextBox>
                                <asp:HiddenField runat="server" ID="hfNewCompNo" />
                            </td>
                        </tr>
                        <tr>

                            <th>＊&nbsp;&nbsp;사업자구분</th>
                            <td>
                                <asp:TextBox ID="txtGubun" class="medium-size" runat="server" Enabled="false" CssClass="txtPg"></asp:TextBox>
                                <input type="button" class="mainbtn type1" style="width: 60px; height: 25px; font-size: 12px" value="검색" onclick="return fnSearchSocialCompPopup();" />
                                <asp:HiddenField runat="server" ID="hfGubun" />
                                <asp:HiddenField runat="server" ID="hfNewGubun" />
                            </td>
                        </tr>
                        <tr>
                            <th>＊&nbsp;&nbsp;메모</th>
                            <td>
                                <asp:TextBox ID="txtRemark" runat="server" TextMode="MultiLine" CssClass="position" Width="390px" onkeypress="return preventEnter(event);" Height="134px" Style="border: 1px solid #a2a2a2;"></asp:TextBox>
                            </td>
                        </tr>
                    </table>
                    <div class="btn_center">
                        <asp:HiddenField runat="server" ID="hfBelongCode" />
                        <asp:HiddenField runat="server" ID="hfAreaCode" />
                        <asp:Button runat="server" CssClass="mainbtn type1" Text="저장" Font-Size="12px" Width="95px" Height="30px" ID="btnPopupSave" OnClick="btnPopupSave_Click" OnClientClick="return fnSetData();" />
                    </div>

                </div>
            </div>
        </div>
    
    <!-- 팝업창 영역 시작 -->
    <%--주문 업체 코드 팝업--%>
    <div id="orderSaleCodediv" class="popupdiv divpopup-layer-package">
        <div class="popupdivWrapper" style="width: 650px; height: 750px">
            <div class="popupdivContents">

                <div class="close-div">
                    <a onclick="fnClosePopup('orderSaleCodediv'); return false;" style="cursor: pointer">
                        <img src="../../Images/Wish/icon-delete.jpg" alt="닫기" style="float: right;" /></a>
                </div>
                <div class="popup-title">
                    <h3 class="pop-title">주문 업체 코드 조회</h3>
                    <div class="search-div">
                        <input type="text" style="width:300px;" class="text-code" id="txtPopSearchSaleComp" placeholder="주문 업체명을 입력하세요" onkeypress="return fnPopSaleCompEnter();" />
                        <input type="button" value="검색" style="width:75px" class="mainbtn type1" onclick="fnGetCompanyList_A(1); return false;">
                    </div>
                    <div class="divpopup-layer-conts">
                        <table id="tblSaleComp" class="tbl_main tbl_pop">
                            <thead>
                                <tr>
                                    <th class="text-center" style="width: 10%">선택</th>
                                    <th class="text-center">판매사명</th>
                                    <th class="text-center">판매사 코드</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr>
                                    <td colspan="3" class="text-center">리스트가 없습니다.</td>
                                </tr>
                            </tbody>
                        </table>
                        <br />
                        <!-- 페이징 처리 -->
                        <div style="margin: 0 auto; text-align: center">
                            <input type="hidden" id="hdTotalCount" />
                            <div id="pagination" class="page_curl" style="display: inline-block"></div>
                        </div>
                    </div>

                    <div class="btn_center">
                        <input type="button" value="확인" style="width:75px" class="mainbtn type1"onclick="fnPopupOkSaleComp(); return false;">
                        <asp:HiddenField runat="server" ID="hfBaseOrderSaleCompCode" />
                    </div>

                </div>
            </div>
        </div>
    </div>
    <%--사업자 구분 팝업--%>
    <div id="socialCompCodediv" class="popupdiv divpopup-layer-package">
        <div class="popupdivWrapper" style="width:650px; height: 750px">
            <div class="popupdivContents">

                <div class="close-div">
                    <a onclick="fnClosePopup('socialCompCodediv'); return false;" style="cursor: pointer">
                        <img src="../../Images/Wish/icon-delete.jpg" alt="닫기" style="float: right;" /></a>
                </div>
                <div class="popup-title">
                    <h3 class="pop-title">사업자 구분 코드 조회</h3>
                    <div class="search-div">
                        <input type="text" class="text-code" style="width:300px;" id="txtPopSearchSocialComp" placeholder="사업자 구분명을 입력하세요" onkeypress="return fnPopSocialCompEnter();" />
                        <input type="button" value="검색" style="width:75px" class="mainbtn type1" onclick="fnGetSocialCompList(1); return false;">
                    </div>
                    <div class="divpopup-layer-conts">
                        <table id="tblSocialComp" class="tbl_main tbl_pop">
                            <thead>
                                <tr>
                                    <th class="text-center" style="width: 10%">선택</th>
                                    <th class="text-center">사업자 구분명</th>
                                    <th class="text-center">사업자 구분 코드</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr>
                                    <td colspan="3" class="text-center">리스트가 없습니다.</td>
                                </tr>
                            </tbody>
                        </table>
                        <br />
                        <!-- 페이징 처리 -->
                        <div style="margin: 0 auto; text-align: center">
                            <input type="hidden" id="hdTotalCount_3" />
                            <div id="pagination_3" class="page_curl" style="display: inline-block"></div>
                        </div>
                    </div>

                    <div class="btn_center">
                        <input type="button" value="확인" style="width:75px" class="mainbtn type1" onclick="fnPopupOkSocialComp(); return false;">
                        <asp:HiddenField runat="server" ID="hfSocialCompCode" />
                    </div>

                </div>
            </div>
        </div>
    </div>
    <!-- 팝업창 영역 끝 -->
</asp:Content>

