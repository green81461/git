<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Master/AdminMasterPage.master" AutoEventWireup="true" CodeFile="BorderTypeRegister.aspx.cs" Inherits="Admin_Company_BorderTypeRegister" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <link href="../Content/Goods/goods.css" rel="stylesheet" />
    <script type="text/javascript">
        function fnValidate() {
            var txtCode = $('#<%= txtCode.ClientID%>');
            var txtName = $('#<%= txtName.ClientID%>');

            if (txtCode.val() == '') {
                alert('코드를 입력해 주세요');
                txtCode.focus();
                return false;
            }

            if (txtName.val() == '') {
                alert('유형명을 입력해 주세요');
                txtName.focus();
                return false;
            }

            if (txtCode.val().length > 5) {
                alert('코드는 5자리 이내로 입력해 주세요');
                txtCode.focus();
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
                    구매사 주문유형관리
                    <span class="span-title-subsentence"></span>
                </p>
            </div>

            <!--탭메뉴-->
            <div class="div-main-tab" style="width: 100%;">
                <ul>
                    <li class='tabOff' style="width: 185px;" onclick="fnTabClickRedirect('BorderTypeMain');">
                        <a onclick="fnTabClickRedirect('BorderTypeMain');">구매사 주문 유형 조회</a>
                    </li>
                    <li class='tabOn' style="width: 185px;" onclick="fnTabClickRedirect('BorderTypeRegister');">
                        <a onclick="fnTabClickRedirect('BorderTypeRegister');">구매사 주문 유형 등록</a>
                    </li>
                </ul>
            </div>


            <table id="tblBrandReg">
                <tr>
                    <th>구매사 주문 유형코드</th>
                    <td>
                        <asp:TextBox runat="server" ID="txtCode" CssClass="input-text"></asp:TextBox>
                    </td>
                    <th>구매사 주문 유형명</th>
                    <td>
                        <asp:TextBox runat="server" ID="txtName" CssClass="input-text" placeholder="직접입력"></asp:TextBox>

                    </td>
                </tr>
                <tr>
                    <th>비고</th>
                    <td colspan="3">
                        <asp:TextBox runat="server" ID="txtRemark" CssClass="input-text" Width="100%"></asp:TextBox>

                    </td>
                </tr>
            </table>


            <!--저장버튼-->
            <div class="bt-align-div">
                <asp:Button runat="server" Style="width: 75px; height: 25px;" CssClass="mainbtn type1" ID="ibSave" OnClick="ibSave_Click" OnClientClick="return fnValidate();" Text="검색" />
            </div>
            <!--저장버튼끝-->


        </div>
    </div>
</asp:Content>

