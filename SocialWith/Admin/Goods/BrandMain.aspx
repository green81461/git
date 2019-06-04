<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Master/AdminMasterPage.master" AutoEventWireup="true" CodeFile="BrandMain.aspx.cs" Inherits="Admin_Goods_BrandMain" %>

<%@ Register Src="~/UserControl/ucListControl.ascx" TagName="ListPager" TagPrefix="ucPager" %>
<%@ Import Namespace="Urian.Core" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <link href="../../Content/Goods/goods.css" rel="stylesheet" />
    <link rel="stylesheet" href="../content/fontawesome/all.css" crossorigin="anonymous">
    <!--폰트어썸 css-->
    <script defer src="../content/fontawesome/all.js" crossorigin="anonymous"></script>
    <!--폰트어썸 js-->
    <style>
        #tblBrand tr.selected {
            background-color: gainsboro
        }
    </style>
    <script type="text/javascript">


        $(document).on('click', '#tblBrand td:not(:nth-child(5))', function () {
            fnShowDetail(this); return false;
        });

        var is_sending = false;

        $(document).ready(function () {

            fnBrandListBind(1);

            $('#tbodyBrand tr').each(function () {
                var hdDelFlag = $(this).find("input:hidden[name='hdDelFlag']").val();

                if (hdDelFlag == "Y") {
                    $(this).find("input:checkbox[name='ckbBrand']").attr("disabled", "disabled");
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
            var hdBrandCode = $(el).parent().find("#hdBrandCode").val();

            var param = { SvidUser: sUser, BrandCodes: hdBrandCode, DelFlag: flag, Method: 'DelBrand' };

            var beforeSend = function () {
                is_sending = true;
            }
            var complete = function () {
                is_sending = false;
                var container = $('#pagination');
                var getPageNum = container.pagination('getSelectedPageNum');
                fnBrandListBind(getPageNum);
            }

            if (is_sending) return false;
            JajaxDuplicationCheck('Post', '../../Handler/Common/BrandHandler.ashx', param, 'text', callback, beforeSend, complete, true, sUser);

            return false;
        }
        function fnCancel() {
            $('#brandDiv').fadeOut();
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

        function fnShowDetail(el) {

            $('#hfPopupCode').val('');
            $('#lblPopupCode').text('');
            $('#txtPopupName').val('');
            $('#txtPopupRemark').val('');

            var code = $(el).parent().find('#tdCode').text().trim();
            var name = $(el).parent().find('#tdName').text().trim();
            var remark = $(el).parent().find('#tdRemark').text().trim();

            $('#lblPopupCode').text(code);
            $('#txtPopupName').val(name);
            $('#txtPopupRemark').val(remark);
            $('#hfPopupCode>').val(code);
            fnOpenDivLayerPopup('brandDiv');
            
            return false;

        }

        function fnSetRowColor(el, type) {

            if (type == 'over') {
                $(el).css('cursor', 'pointer')
                $(el).addClass("selected");
            }
            else {
                $(el).removeClass("selected");

            }

        }

        //페이지 이동
        function fnGoPage(pageVal) {
            switch (pageVal) {
                case "GOODS":
                    window.location.href = "../Goods/GoodsRegister?ucode=" + ucode;
                    break;
                case "BRAND":
                    window.location.href = "../Goods/BrandMain?ucode=" + ucode;
                    break;
                case "CATEGORY":
                    window.location.href = "../Goods/CategoryManage?ucode=" + ucode;
                    break;
                default:
                    break;
            }
        }
        //리스트 사용 사용중지 이미지 세팅
        function fnDelFlagName(delFlagName) {
            if (delFlagName == '사용') {
                return '<img src="../../Images/btn_use_m.png">';
            } else {
                return '<img src="../../Images/btn_nouse_m.png">';
            }
        }


        //리스트 사용/사용중지버튼 세팅
        function fnSetDelButton(flag) {
            if (flag == 'Y') {
                return '<input type="button" class="listBtn" value="사용" style="width: 71px; height: 22px; font-size: 12px" OnClick="return fnBrandManagement(this,\'N\');">';
            } else {
                return '<input type="button" class="listBtn type2" value="사용중지" style="width: 71px; height: 22px; font-size: 12px" OnClick="return fnBrandManagement(this,\'Y\');">';
            }
        }

        function fnBrandListBind(pageNo) {

            var pageSize = 20;
            var callback = function (response) {
                if (!isEmpty(response)) {

                    var rowCount = '';

                    $.each(response, function (key, value) {
                        $("#hdTotalCount").val(value.TotalCount);
                        var Brand_RegDate = fnOracleDateFormatConverter(value.EntryDate);
                        var Brand_UpDate = fnOracleDateFormatConverter(value.UpdateDate);

                        rowCount += '<tr onmouseover="fnSetRowColor(this,\'over\');" onmouseout="fnSetRowColor(this,\'out\');"><td>' + value.RowNumber + '</td><td id="tdCode">' + value.BrandCode + '</td><td id="tdName">' + value.BrandName + '</td><td>'
                            + fnDelFlagName(value.DelFlag_Name) + '</td><td><input type="hidden" id="hdBrandCode" value="'+value.BrandCode+'">' + fnSetDelButton(value.DelFlag) + '</td><td>' + value.DelSvid_User_Name + '</td><td>'
                            + Brand_UpDate + '</td><td id="remark">' + value.Remark + '</td><td>' + Brand_RegDate;

                    });

                    $("#lvBrandCont").empty().append(rowCount);
                    $('td').addClass('txt-center');

                } else {
                    $("#hdCompTotalCount").val(0);
                    var emptyCont = "<tr><td colspan='9'>조회된 데이터가 없습니다.</td></tr>"
                    $("#lvBrandCont").empty().append(emptyCont);
                }
                fnCreatePagination('pagination', $("#hdTotalCount").val(), pageNo, pageSize, getPageData);
                return false;
            }

            var param = {
                SearchKeyword: '<%=txtSearch.Text.Trim()%>',
                SearchTarget: '<%=ddlSearchTarget.SelectedValue%>',
                OrderValue: $('#hdOrderValue').val(),
                DelFlag: '<%=ddlSearchDelFlag.SelectedValue%>',
                PageNo: pageNo,
                PageSize: pageSize,
                Method: 'GetBrandListAdmin'
            };

            var beforeSend = function () {
                $('#divLoading').css('display', '');
            }
            var complete = function () {
                $('#divLoading').css('display', 'none');
            }

            JqueryAjax('Post', '../../Handler/Common/BrandHandler.ashx', true, false, param, 'json', callback, beforeSend, complete, true, '<%=Svid_User%>');
        }

        function getPageData() {
            var container = $('#pagination');
            var getPageNum = container.pagination('getSelectedPageNum');
            fnBrandListBind(getPageNum);
            return false;
        }

        function fnOrderListBind(el, type) {

            var qsListType;

            $(el).parent().parent().find('a').removeClass('active');
            $(el).addClass('active');
            $('#hdOrderValue').val(type); //정렬값 저장

            var listType = qsListType;
            if (!isEmpty(qsListType)) {
                if (!isEmpty($('#hdListType').val())) {
                    listType = $('#hdListType').val();
                }
                else {
                    listType = 'a';
                }
            }

            fnBrandListBind(1);

        }

        function fnUpdateBrand() {
            var callback = function (response) {
                if (response == 'OK') {
                    alert('저장되었습니다.');
                    $('#brandDiv').fadeOut();
                }
                else {
                    alert('시스템 오류입니다. 관리자에게 문의하세요');
                }
                return false;
            }

            var param = {
                SvidUser: '<%= Svid_User %>',
                BrandCode: $('#lblPopupCode').text(),
                BrandName: $('#txtPopupName').val(),
                Remark:$('#txtPopupRemark').val(),
                Method: 'UpdateBrand'
            };

            var beforeSend = function () {
                is_sending = true;
                 $('#divLoading').css('display', '');
            }
            var complete = function () {
                is_sending = false;
                $('#divLoading').css('display', 'none');
                var container = $('#pagination');
                var getPageNum = container.pagination('getSelectedPageNum');
                fnBrandListBind(getPageNum);
            }

            if (is_sending) return false;

            JqueryAjax('Post', '../../Handler/Common/BrandHandler.ashx', true, false, param, 'text', callback, beforeSend, complete, true, '<%=Svid_User%>');
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
    </style>


</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div class="all">

        <div class="sub-contents-div">
            <div class="sub-title-div">
                <p class="p-title-mainsentence">
                    브랜드 관리
                    <span class="span-title-subsentence">브랜드 조회 및 브랜드 등록 관리 할 수 있습니다.</span>
                </p>
            </div>

            <!--탭메뉴-->
            <div class="div-main-tab" style="width: 100%;">
                <ul>
                    <li class='tabOn' style="width: 185px;" onclick="fnTabClickRedirect('BrandMain');">
                        <a onclick="fnTabClickRedirect('BrandMain');">브랜드 조회</a>
                    </li>
                    <li class='tabOff' style="width: 185px;" onclick="fnTabClickRedirect('BrandRegister');">
                        <a onclick="fnTabClickRedirect('BrandRegister');">브랜드 등록</a>
                    </li>
                </ul>
            </div>

            <div>
                <input type="button" class="mainbtn type1" style="width: 105px; height: 30px;" value="카테고리 관리" onclick="fnGoPage('CATEGORY')" />
                <input type="button" class="mainbtn type1" style="width: 105px; height: 30px;" value="상품 관리" onclick="fnGoPage('GOODS')" />


            </div>



            <!--상단 조회 영역 시작-->
            <div class="search-div">
                <div class="bottom-search-div" style="margin-bottom: 1px">
                    <table class="tbl_search">
                        <tr>
                            <th style="width: 90px"></th>
                            <td style="width: 110px">
                                <asp:DropDownList ID="ddlSearchDelFlag" runat="server" Width="180px">
                                    <asp:ListItem Text="사용중/사용중지 선택" Value="" Selected="True"></asp:ListItem>
                                    <asp:ListItem Text="사용" Value="N"></asp:ListItem>
                                    <asp:ListItem Text="중지" Value="Y"></asp:ListItem>
                                </asp:DropDownList>
                            </td>

                            <td style="width: 150px;">
                                <asp:DropDownList ID="ddlSearchTarget" runat="server" Width="150px">
                                    <asp:ListItem Text="브랜드코드" Value="CODE"></asp:ListItem>
                                    <asp:ListItem Text="브랜드명" Value="NAME"></asp:ListItem>
                                </asp:DropDownList>
                            </td>
                            <td>
                                <asp:TextBox runat="server" placeholder="검색어를 입력하세요." Style="padding-left: 10px; width: 100%" ID="txtSearch" Onkeypress="return fnEnter();"></asp:TextBox>
                            </td>
                            <td style="text-align: left">
                                <asp:Button runat="server" CssClass="mainbtn type1" ID="btnSearch" OnClick="btnSearch_Click" Text="검색" Width="75" Height="25" />
                            </td>
                        </tr>
                    </table>
                </div>

            </div>

            <div class="brand-search">

                <!--삭제, 엑셀업로드, 엑셀업로드폼다운로드 버튼 시작-->
                <div class="bt-align-div">
                    <%--<asp:ImageButton AlternateText="삭제" runat="server" OnClientClick="fnDeleteBrand(); return false;" ImageUrl="../Images/Goods/deleteUp-off.jpg" onmouseover="this.src='../Images/Goods/deleteUp-on.jpg'" onmouseout="this.src='../Images/Goods/deleteUp-off.jpg'" />--%>

                    <asp:Button ID="btnExcelUpload" runat="server" Width="95" Height="30" Text="엑셀 업로드" CssClass="mainbtn type1" />
                    <asp:Button ID="btnExcelUploadForm" runat="server" Width="155" Height="30" Text="엑셀 업로드폼 저장" CssClass="mainbtn type1" />


                    <%--                    <asp:ImageButton AlternateText="엑셀업로드" runat="server" ImageUrl="../Images/Goods/upload-off.jpg" onmouseover="this.src='../Images/Goods/upload-on.jpg'" onmouseout="this.src='../Images/Goods/upload-off.jpg'" />
                    <asp:ImageButton AlternateText="엑셀업로드폼 다운로드" runat="server" ImageUrl="../Images/Goods/formSave-off.jpg" onmouseover="this.src='../Images/Goods/formSave-on.jpg'" onmouseout="this.src='../Images/Goods/formSave-off.jpg'" />--%>
                </div>


                <div>
                <div id="menu" class="goodslist-topbar">
                <div id="divOrder" class="goodslist-topbar-order"<%-- style="display: inline-block;"--%>>
                    <input type="hidden" id="hdOrderValue" value="1" />
                    <ul>
                        <li>
                            <a onclick="fnOrderListBind(this,'1')" class="active">브랜드이름순</a> 
                        </li>
                        <li>
                            <a onclick="fnOrderListBind(this,'2')">브랜드코드순</a> 
                        </li>
                        <li>
                            <a onclick="fnOrderListBind(this,'3')">등록순</a>
                        </li>
                    </ul>
                </div>
            </div>

                    <input type="hidden" id="hdListType" />
                    <table id="tblBrand" class="tbl_main">
                        <thead>
                            <tr class="board-tr-height">
                                <th class="txt-center">번호</th>
                                <th class="txt-center">브랜드코드</th>
                                <th class="txt-center">브랜드명</th>
                                <th class="txt-center">사용유무</th>
                                <th class="txt-center">설정</th>
                                <th class="txt-center">변경자</th>
                                <th class="txt-center">변경날짜</th>
                                <th class="txt-center">비고</th>
                                <th class="txt-center">등록날짜</th>
                            </tr>
                        </thead>
                        <tbody id="lvBrandCont"></tbody>
                    </table>

                    <%-- <asp:ListView ID="lvBrandList" runat="server" ItemPlaceholderID="phItemList" OnItemDataBound="lvBrandList_ItemDataBound">
                    <LayoutTemplate>
                        <table id="tblBrand" class="tbl_main">
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
                                    <th class="txt-center">브랜드코드</th>
                                    <th class="txt-center">브랜드명</th>
                                    <th class="txt-center">사용유무</th>
                                    <th class="txt-center">설정</th>
                                    <th class="txt-center">변경자</th>
                                    <th class="txt-center">변경날짜</th>
                                    <th class="txt-center">비고</th>
                                    <th class="txt-center">등록날짜</th>
                                </tr>
                            </thead>
                            <tbody id="tbodyBrand">
                                <asp:PlaceHolder ID="phItemList" runat="server" />
                            </tbody>
                        </table>
                    </LayoutTemplate>
                    <ItemTemplate>
                        <tr class="board-tr-height" onmouseover="fnSetRowColor(this,'over');" onmouseout="fnSetRowColor(this,'out');">
                            <td class="txt-center">
                                <span><%# Eval("RowNumber").ToString()%></span>
                            </td>
                            <td class="txt-center" id="tdCode">
                                <%# Eval("BrandCode").ToString()%>
                            </td>
                            <td class="txt-center" id="tdName">
                                <%# Eval("BrandName").ToString() %>
                            </td>
                            <td  class="txt-center tdDelFlag">
                                <i class="<%# Eval("DelFlag").ToString().Equals("Y") ? "fa fa-times-circle" : "fa fa-play-circle" %>"></i> <%# Eval("DelFlag_Name").ToString() %>
                            </td>

                            <td class="txt-center">
                                <input type="hidden" name="hdBrandCode" value="<%# Eval("BrandCode").ToString()%>" />
                                <asp:HiddenField runat="server" ID="hfDelFlag" Value='<%# Eval("DelFlag").ToString()%>' />
                                <asp:ImageButton AlternateText="사용중지" ID="ibtnBrandDelete" runat="server" ImageUrl="../Images/Goods/useStop-off.jpg" onmouseover="this.src='../Images/Goods/useStop-off.jpg'" onmouseout="this.src='../Images/Goods/useStop-off.jpg'" OnClientClick="return fnBrandManagement(this,'Y');" />
                                <asp:ImageButton AlternateText="사용" ID="ibtnBrandUse" runat="server" ImageUrl="../Images/Goods/use-on.jpg" onmouseover="this.src='../Images/Goods/use-on.jpg'" onmouseout="this.src='../Images/Goods/use-on.jpg'" OnClientClick="return fnBrandManagement(this,'N');" />
                            </td>
                            <td class="txt-center">
                                <%# Eval("DelSvid_User_Name").ToString() %>
                            </td>
                            <td class="txt-center">
                                <%# Eval("UpdateDate").AsDateTimeNullable() != null ? Eval("UpdateDate").AsDateTime().ToString("yyyy-MM-dd") : "" %>
                            </td>
                            <td class="txt-center" id="tdRemark">
                                <%# Eval("Remark").ToString() %>
                            </td>
                            <td class="txt-center">
                                <%# ((DateTime)(Eval("EntryDate"))).ToString("yyyy-MM-dd")%>
                            </td>
                        </tr>
                    </ItemTemplate>
                    <EmptyDataTemplate>
                        <table class="board-table" style="margin-top: 0;">
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
                                    <th class="txt-center">브랜드코드</th>
                                    <th class="txt-center">브랜드명</th>
                                    <th class="txt-center">사용유무</th>

                                    <th class="txt-center">설정</th>
                                    <th class="txt-center">변경자</th>
                                    <th class="txt-center">변경날짜</th>
                                    <th class="txt-center">비고</th>
                                    <th class="txt-center">등록날짜</th>
                                </tr>
                            </thead>
                            <tr class="board-tr-height">
                                <td colspan="9" class="txt-center">조회된 데이터가 없습니다.</td>
                            </tr>
                        </table>
                    </EmptyDataTemplate>
                </asp:ListView>--%>

                    <!--데이터 리스트 종료 -->

                    <!--페이징-->
                    <%--<div style="margin: 0 auto; text-align: center">
                    <ucPager:ListPager ID="ucListPager" runat="server" OnPageIndexChange="ucListPager_PageIndexChange" PageSize="20" />
                </div>--%>
                    <div style="margin: 0 auto; text-align: center; padding-top: 10px">
                        <input type="hidden" id="hdTotalCount" />
                        <div id="pagination" class="page_curl" style="display: inline-block"></div>
                    </div>
                </div>
                <!--엑셀다운로드,저장 버튼-->
                <div class="bt-align-div">
                    <asp:Button ID="btnExcelExport" runat="server" Width="95" Height="30" Text="엑셀 저장" OnClick="btnExcelExport_Click" CssClass="mainbtn type1" />

                    <%--<asp:ImageButton AlternateText="엑셀저장" runat="server" ID="btnExcel" OnClick="btnExcel_Click" ImageUrl="../../Images/Cart/excel-off.jpg" onmouseover="this.src='../../Images/Cart/excel-on.jpg'" onmouseout="this.src='../../Images/Cart/excel-off.jpg'" />--%>
                </div>
                <!--상단영역 끝 -->
            </div>
        </div>


        <!-- 수정 팝업-->

        <div id="brandDiv" class="popupdiv divpopup-layer-package">
            <div class="popupdivWrapper" style="width:950px; height: 230px">
                <div class="popupdivContents" >
                        <div class="close-div">
                            <a onclick="fnClosePopup('brandDiv'); return false;" style="cursor: pointer">
                                <img src="../../Images/Wish/icon-delete.jpg" alt="닫기" style="float: right;">
                            </a>
                        </div>
                         <div class="popup-title" style="margin-top: 20px;">
                            <h3 class="pop-title">브랜드 수정</h3>
                        </div>
                        <div class="divpopup-layer-conts">
                            <table class="tbl_main">
                                <tr>
                                    <th>브랜드코드
                                    </th>
                                    <td>
                                        <p ID="lblPopupCode"></p>
                                    </td>
                                    <th>브랜드명  
                                    </th>
                                    <td style="padding-left: 5px;">
                                        <input type ="text" ID="txtPopupName" onkeypress="preventEnter(event)" Style="width:90%;  border: 1px solid #a2a2a2; padding-left: 5px"/>
                                    </td>
                                </tr>
                                <tr>
                                    <th class="txt-center">비고
                                    </th>
                                    <td colspan="3" style="padding-left: 5px;">
                                        <input type ="text" ID="txtPopupRemark" onkeypress="preventEnter(event)" Style="width:90%; border: 1px solid #a2a2a2; padding-left: 5px"/>
                                    </td>
                                </tr>
                            </table>
                            <br />
                            <div class="btn_center">
                                <input type="hidden" ID="hfPopupCode"> 
                                 <input type="button" value="취소" class="mainbtn type2" ID="btnCancel" style="width:75px" onclick="fnClosePopup('brandDiv'); return false;" />
                                 <input type="button" value="저장" class="mainbtn type1" ID="btnSave" style="width:75px" onclick="return fnUpdateBrand();" />
                                <%--<asp:Button ID="btnCancel" runat="server" CssClass="mainbtn type2" Text=" 취소" OnClientClick="return fnCancel();" ImageUrl="../Images/Order/cancle.jpg" onmouseover="this.src='../Images/Order/cancle-on.jpg'" onmouseout="this.src='../Images/Order/cancle.jpg'" />
                                <asp:Button ID="btnSave" runat="server" CssClass="mainbtn type1" Text="저장" ImageUrl="../Images/Order/save.jpg" onmouseover="this.src='../Images/Order/save-on.jpg'" onmouseout="this.src='../Images/Order/save.jpg'" OnClick="btnSave_Click" OnClientClick="return fnValidate();" />--%>
                            </div>
                        </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>

