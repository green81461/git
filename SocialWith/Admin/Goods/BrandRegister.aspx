<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Master/AdminMasterPage.master" AutoEventWireup="true" CodeFile="BrandRegister.aspx.cs" Inherits="Admin_Goods_BrandRegister" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
   <link href="../Content/Goods/goods.css" rel="stylesheet" />
    <script type="text/javascript">
        function fnValidate() {
            var txtBrandCode = $('#<%= txtBrandCode.ClientID%>');
            var txtBrandName = $('#<%= txtBrandName.ClientID%>');

            if (txtBrandCode.val() == '') {
                alert('코드를 생성해 주세요');
                txtBrandCode.focus();
                return false;
            }

            if (txtBrandName.val() == '') {
                alert('브랜드명을 작성해 주세요');
                txtBrandName.focus();
                return false;
            }

            return true;
        }

        //페이지 이동
        function fnGoPage(pageVal) {
            switch (pageVal) {
                case "GOODS":
                    window.location.href = "../Goods/GoodsRegister?ucode="+ucode;
                    break;
                case "BRAND":
                    window.location.href = "../Goods/BrandMain?ucode="+ucode;
                    break;
                case "CATEGORY":
                    window.location.href = "../Goods/CategoryManage?ucode="+ucode;
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
                    브랜드 관리
                    <span class="span-title-subsentence">브랜드 조회 및 브랜드 등록 관리 할 수 있습니다.</span>
                </p>
            </div>

            <!--탭메뉴-->
            <div class="div-main-tab" style="width: 100%; ">
                <ul>
                    <li class='tabOff' style="width: 185px;" onclick="fnTabClickRedirect('BrandMain');">
                        <a onclick="fnTabClickRedirect('BrandMain');">브랜드 조회</a>
                     </li>
                    <li class='tabOn' style="width: 185px;" onclick="fnTabClickRedirect('BrandRegister');">
                         <a onclick="fnTabClickRedirect('BrandRegister');">브랜드 등록</a>
                    </li>
                </ul>
            </div>

            <div>
                <input type="button" class="mainbtn type1" style="width: 105px; height: 30px;" value="카테고리 관리" onclick="fnGoPage('CATEGORY')" />
                <input type="button" class="mainbtn type1" style="width: 105px; height: 30px;" value="상품 관리" onclick="fnGoPage('GOODS')" />
            </div>

            <div class="search-div">
                <table id="tblBrandReg" class="tbl_main">
                    <colgroup>
                        <col style="width:200px;"/>
                        <col />
                        <col style="width:200px;"/>
                        <col />
                    </colgroup>
                    <tr>
                        <th>브랜드코드</th>
                        <td>
                            <asp:TextBox runat="server" ID="txtBrandCode" CssClass="medium-size" ReadOnly="true"></asp:TextBox>
                            <asp:HiddenField runat="server" ID="hfBrandCode" />
                            <asp:Button runat="server" ID="ibCodeCreate" Text="생성" style="width:75px" CssClass="mainbtn type1" OnClick="ibCodeCreate_Click" />
                            <!--<input type="button" class="mainbtn type1" ID="ibCodeCreate" style="width:75px; height: 30px;" value="생성" onclick="ibCodeCreate_Click" />-->
                        </td>
                        <th>브랜드명</th>
                        <td>
                            <asp:TextBox runat="server" ID="txtBrandName" CssClass="medium-size" placeholder="직접입력"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <th>비고</th>
                        <td colspan="4">
                            <asp:TextBox runat="server" ID="txtRemark" CssClass="medium-size"></asp:TextBox>
                        </td>
                    </tr>
                </table>
            </div>

            <!--저장버튼-->
            <div class="bt-align-div">

                <asp:Button ID="btnSave" runat="server" Width="95" Height="30" Text="저장" OnClick="btnSave_Click" CssClass="mainbtn type1"/>

                <%--<asp:ImageButton runat="server" ID="ibSave" ImageUrl="../Images/Member/save.jpg" AlternateText="저장" onmouseover="this.src='../Images/Member/save-on.jpg'" onmouseout="this.src='../Images/Member/save.jpg'" OnClick="ibSave_Click" OnClientClick="return fnValidate();" />--%>
            </div>
            <!--저장버튼끝-->


        </div>
    </div>
</asp:Content>

