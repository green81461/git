<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Master/AdminMasterPage.master" AutoEventWireup="true" CodeFile="PlatformManagement.aspx.cs" Inherits="Admin_Member_PlatformManagement" %>

<%@ Register Src="~/UserControl/ucListControl.ascx" TagName="ListPager" TagPrefix="ucPager" %>
<%@ Import Namespace="Urian.Core" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <link href="../Content/Goods/goods.css" rel="stylesheet" />
    <link href="../Content/Company/company.css" rel="stylesheet" />
    <style>
        #tblPlatformList tr.selected {
            background-color: gainsboro
        }
    </style>
    <script type="text/javascript">

        $(document).on('click', '#tblPlatformList td:not(:nth-child(6))', function () {
            fnShowDetail(this); return false;
        });

        var is_sending = false;


        //설정에서 버튼 클릭 시
        function fnManagement(el, flag) {
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
            var hdCode = $(el).parent().find("input:hidden[name='hdCode']").val().trim();

            var param = { Code: hdCode, DelFlag: flag, Method: 'PlatformTypeMgt' };

            var beforeSend = function () {
                is_sending = true;
            }
            var complete = function () {
                is_sending = false;
                window.location.reload(true);
            }

            if (is_sending) return false;
            JajaxDuplicationCheck('Post', '../../Handler/Common/UserHandler.ashx', param, 'text', callback, beforeSend, complete, true, sUser);

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

        function fnSetRowColor(el, type) {

            if (type == 'over') {
                $(el).css('cursor', 'pointer')
                $(el).addClass("selected");
            }
            else {
                $(el).removeClass("selected");

            }

        }

        function fnShowDetail(el) {

            $('#<%= hfPopupCode.ClientID%>').val('');
            $('#<%= lblPopupCode.ClientID%>').text('');
            $('#<%= txtPopupName.ClientID%>').val('');
            $('#<%= txtPopupRemark.ClientID%>').val('');

            var code = $(el).parent().find('#tdCode').text().trim();
            var name = $(el).parent().find('#tdName').text().trim();
            var remark = $(el).parent().find('#tdRemark').text().trim();

            $('#<%= lblPopupCode.ClientID%>').text(code);
            $('#<%= txtPopupName.ClientID%>').val(name);
            $('#<%= txtPopupRemark.ClientID%>').val(remark);
            $('#<%= hfPopupCode.ClientID%>').val(code);

            var e = document.getElementById('bordertypeDiv');

            if (e.style.display == 'block') {
                e.style.display = 'none';

            } else {
                e.style.display = 'block';
            }
            return false;

        }

        function fnValidate() {
            var txtName = $('#<%= txtPopupName.ClientID%>');
            if (txtName.val() == '') {
                alert('판매사 플랫폼 유형명을 입력해 주세요');
                txtName.focus();
                return false;
            }
            return true;
        }

        function fnCancel() {
            $('#bordertypeDiv').fadeOut();
            return false;
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
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div class="all">
        <div class="sub-contents-div">
            <div class="sub-title-div">
                <p class="p-title-mainsentence">
                    판매사 플랫폼
                    <span class="span-title-subsentence"></span>
                </p>
            </div>


            <!--탭메뉴-->
            <div class="div-main-tab" style="width: 100%;">
                <ul>
                    <li class='tabOn' style="width: 185px;" onclick="fnTabClickRedirect('PlatformManagement');">
                        <a onclick="fnTabClickRedirect('PlatformManagement');">판매사플랫폼조회</a>
                    </li>
                    <li class='tabOff' style="width: 185px;" onclick="fnTabClickRedirect('PlatformRegister');">
                        <a onclick="fnTabClickRedirect('PlatformRegister');">판매사플랫폼등록</a>
                    </li>
                </ul>
            </div>

            <%--            <!--탭메뉴-->
            <div class="sub-tab-div">
                <ul>
                    <li>
                        <a href="PlatformManagement.aspx">
                            <img src="../../AdminSub/Images/Member/sellerTab1-on.jpg" alt="판매사플랫폼조회" /></a>
                        <a href="PlatformRegister.aspx">
                            <img src="../../AdminSub/Images/Member/sellerTab2-off.jpg" alt="판매사플랫폼등록" /></a>
                    </li>
                </ul>
            </div>--%>



            <!--상단 조회 영역 시작-->
             <div class="memberB-div">
                <div class="bottom-search-div" style="margin-bottom: 1px">
                    <table class="tblMainC" style="width: 100%; margin-top: 30px; margin-bottom: 30px; border: 1px solid #a2a2a2;">
                        <tr>
                            <th style="width: 90px"></th>
                            <td style="width: 90px">
                                <asp:DropDownList ID="ddlSearchDelFlag" runat="server" Width="200px">
                                    <asp:ListItem Text="사용중/사용중지 선택" Value="" Selected="True"></asp:ListItem>
                                    <asp:ListItem Text="사용" Value="N"></asp:ListItem>
                                    <asp:ListItem Text="중지" Value="Y"></asp:ListItem>
                                </asp:DropDownList>
                            </td>

                            <td style="width: 150px;">
                                <asp:DropDownList ID="ddlSearchTarget" runat="server" Width="150px" Style="margin-left: 5px; position: relative; top: -3px">
                                    <asp:ListItem Text="유형코드" Value="Code"></asp:ListItem>
                                    <asp:ListItem Text="유형명" Value="Name"></asp:ListItem>
                                </asp:DropDownList>
                            </td>
                            <td>
                                <asp:TextBox runat="server" placeholder="검색어를 입력하세요." Style="padding-left: 10px; width: 100%" ID="txtSearch" Onkeypress="return fnEnter();"></asp:TextBox>
                            </td>
                            <td style="text-align: left">
                                <asp:Button runat="server" Style="width: 75px; height: 25px;" CssClass="mainbtn type1" ID="btnSearch" OnClick="btnSearch_Click" Text="검색" />
                            </td>
                        </tr>
                    </table>
                </div>
            </div>




            <div class="brand-search">

                <asp:ListView ID="lvPlatformList" runat="server" ItemPlaceholderID="phItemList" OnItemDataBound="lvList_ItemDataBound">
                    <LayoutTemplate>
                        <table id="tblPlatformList" class="tbl_main" style="margin-top: 0; text-align:center;">
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
                                    <th class="txt-center">판매사 플랫폼
                                        <br />
                                        유형코드</th>
                                    <th class="txt-center">판매사 플랫폼 유형명</th>
                                    <th class="txt-center">설명</th>
                                    <th class="txt-center">사용유무</th>
                                    <th class="txt-center">설정</th>
                                    <th class="txt-center">등록자</th>
                                    <th class="txt-center">변경날짜</th>
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
                            <td style="width: 4%" class="txt-center">
                                <span><%# Eval("Rownum").ToString()%></span>
                            </td>
                            <td style="width: 8%" class="txt-center" id="tdCode">
                                <%# Eval("PlatformCode").ToString()%>
                            </td>
                            <td style="width: 15%" class="txt-center" id="tdName">
                                <%# Eval("PlatformName").ToString() %>
                            </td>
                            <td style="width: 40%; word-break: break-all" class="txt-center" id="tdRemark">
                                <%# Eval("Remark").ToString() %>
                            </td>
                            <td class="txt-center">
                                <%# Eval("DelFlag_Name").ToString() %>
                            </td>
                            <td class="txt-center">
                                <input type="hidden" name="hdCode" value="<%# Eval("PlatformCode").ToString()%>" />
                                <asp:HiddenField runat="server" ID="hfDelFlag" Value='<%# Eval("DelFlag").ToString()%>' />
                                <asp:ImageButton AlternateText="사용중지" ID="ibtnDelete" runat="server" ImageUrl="../Images/Goods/useStop-off.jpg" onmouseover="this.src='../Images/Goods/useStop-off.jpg'" onmouseout="this.src='../Images/Goods/useStop-off.jpg'" OnClientClick="return fnManagement(this,'Y');" />
                                <asp:ImageButton AlternateText="사용" ID="ibtnUse" runat="server" ImageUrl="../Images/Goods/use-on.jpg" onmouseover="this.src='../Images/Goods/use-on.jpg'" onmouseout="this.src='../Images/Goods/use-on.jpg'" OnClientClick="return fnManagement(this,'N');" />
                            </td>
                            <td class="txt-center">
                                <%# Eval("Svid_User_Name").ToString() %>
                            </td>
                            <td class="txt-center">
                                <%# Eval("UpdateDate").AsDateTimeNullable() != null ?  Eval("UpdateDate").AsDateTime().ToString("yyyy-MM-dd") : ""  %>
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
                                    <th class="txt-center">판매사 플랫폼 유형코드</th>
                                    <th class="txt-center">판매사 플랫폼 유형명</th>
                                    <th class="txt-center">설명</th>
                                    <th class="txt-center">사용유무</th>
                                    <th class="txt-center">설정</th>
                                    <th class="txt-center">등록자</th>
                                    <th class="txt-center">변경날짜</th>
                                    <th class="txt-center">등록날짜</th>
                                </tr>
                            </thead>
                            <tr class="board-tr-height">
                                <td colspan="9" class="txt-center">조회된 데이터가 없습니다.</td>
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
        </div>
    </div>


    <!-- 수정 팝업-->

    <div id="bordertypeDiv" class="divpopup-layer-package">
        <div class="bordertypeWrapper">
            <div class="bordertypeContent" style="border: none;">
                <div class="divpopup-layer-container">
                    <div class="sub-title-div">
                        <p class="p-title-mainsentence">
                            유형 수정
                    <span class="span-title-subsentence"></span>
                        </p>
                    </div>
                </div>
                <br />

                <div class="divpopup-layer-conts">
                    <table style="width: 100%" class="tbl_main">
                        <tr class="board-tr-height">
                            <th class="txt-center" style="width: 100px">판매사 플랫폼 유형코드
                            </th>
                            <td class="txt-center" style="width: 100px">
                                <asp:Label runat="server" ID="lblPopupCode"></asp:Label>
                            </td>
                            <th class="txt-center" style="width: 100px">판매사 플랫폼 유형명  
                            </th>
                            <td style="padding-left: 5px">
                                <asp:TextBox runat="server" ID="txtPopupName" Width="99%" Height="26px" onkeypress="preventEnter(event)" Style="border: 1px solid #a2a2a2"></asp:TextBox>
                            </td>
                        </tr>
                        <tr class="board-tr-height">
                            <th class="txt-center">설명
                            </th>
                            <td colspan="3" style="padding-left: 5px">
                                <asp:TextBox runat="server" ID="txtPopupRemark" onkeypress="preventEnter(event)" Width="99%" Height="26px" Style="border: 1px solid #a2a2a2"></asp:TextBox>
                            </td>
                        </tr>
                    </table>
                    <br />
                    <div style="text-align: right">
                        <asp:HiddenField runat="server" ID="hfPopupCode" />
                        <asp:ImageButton ID="btnCancel" runat="server" AlternateText=" 취소" OnClientClick="return fnCancel();" ImageUrl="../Images/Order/cancle.jpg" onmouseover="this.src='../Images/Order/cancle-on.jpg'" onmouseout="this.src='../Images/Order/cancle.jpg'" />
                        <asp:ImageButton ID="btnSave" runat="server" AlternateText="저장" OnClick="btnSave_Click" OnClientClick="return fnValidate();" ImageUrl="../Images/Order/save.jpg" onmouseover="this.src='../Images/Order/save-on.jpg'" onmouseout="this.src='../Images/Order/save.jpg'" />
                    </div>
                </div>
            </div>
        </div>
    </div>
    </div>
</asp:Content>

