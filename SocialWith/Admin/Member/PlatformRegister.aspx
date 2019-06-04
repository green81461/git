<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Master/AdminMasterPage.master" AutoEventWireup="true" CodeFile="PlatformRegister.aspx.cs" Inherits="Admin_Member_PlatformRegister" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <link href="../Content/Goods/goods.css" rel="stylesheet" />
    <script type="text/javascript">
        function fnValidate() {
            var txtPlatformCode = $('#<%= txtPlatformCode.ClientID%>');
            var txtPlatformName = $('#<%= txtPlatformName.ClientID%>');

            if (txtPlatformCode.val() == '') {
                alert('판매사 플랫폼 유형코드코드를 입력해 주세요');
                txtPlatformCode.focus();
                return false;
            }

            if (txtPlatformName.val() == '') {
                alert('판매사 플랫폼명을 입력해 주세요');
                txtPlatformName.focus();
                return false;
            }

            if (txtPlatformCode.val().length > 10) {
                alert('코드는 10자리 이내로 입력해 주세요');
                txtPlatformCode.focus();
                return false;
            }

            return true;
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

            <div class="sub-title-div">
                <p class="p-title-mainsentence">
                    판매사 플랫폼
                    <span class="span-title-subsentence"></span>
                </p>
            </div>

            <!--탭메뉴-->
            <div class="div-main-tab" style="width: 100%;">
                <ul>
                    <li class='tabOff' style="width: 185px;" onclick="fnTabClickRedirect('PlatformManagement');">
                        <a onclick="fnTabClickRedirect('PlatformManagement');">판매사플랫폼조회</a>
                    </li>
                    <li class='tabOn' style="width: 185px;" onclick="fnTabClickRedirect('PlatformRegister');">
                        <a onclick="fnTabClickRedirect('PlatformRegister');">판매사플랫폼등록</a>
                    </li>
                </ul>
            </div>


            <table id="tblBrandReg">
                <tr>
                    <th>판매사 플랫폼 유형코드</th>
                    <td colspan="2">
                        <asp:TextBox runat="server" ID="txtPlatformCode" CssClass="input-text"></asp:TextBox>
                        <%--<asp:HiddenField runat="server" id="hfPlatformCode"/>--%>
                    </td>

                    <th>판매사 플랫폼명</th>
                    <td>
                        <asp:TextBox runat="server" ID="txtPlatformName" CssClass="input-text" placeholder="직접입력"></asp:TextBox>

                    </td>
                </tr>
                <tr>
                    <th>설명</th>
                    <td colspan="4">
                        <asp:TextBox runat="server" ID="txtRemark" CssClass="input-text" Width="100%"></asp:TextBox>
                    </td>
                </tr>
            </table>


            <!--저장버튼-->
            <div class="bt-align-div">
                <asp:ImageButton runat="server" ID="ibSave" ImageUrl="../Images/Member/save.jpg" AlternateText="저장" onmouseover="this.src='../Images/Member/save-on.jpg'" onmouseout="this.src='../Images/Member/save.jpg'" OnClick="ibSave_Click" OnClientClick="return fnValidate();" />
            </div>
            <!--저장버튼끝-->


        </div>
    </div>
</asp:Content>

