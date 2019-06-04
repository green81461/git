<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Master/AdminMasterPage.master" AutoEventWireup="true" CodeFile="ImageUpload.aspx.cs" Inherits="Admin_Goods_ImageUpload" %>




<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
 <link href="../Content/Order/common.css" rel="stylesheet" />
 <link href="../Content/Goods/goods.css" rel="stylesheet" />

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div class="all">
        <div class="sub-contents-div">
            <div class="sub-title-div">
                <p class="p-title-mainsentence">
                    상품이미지 업로드
                    <span class="span-title-subsentence"></span>
                </p>
            </div>
            <div class="container">
                <div>
                    <asp:Button ID="btnUpload" runat="server" CssClass="mainbtn type1" OnClick="btnUpload_Click" Text="업로드" />
                    <br />
                    <asp:Label ID="lblUpload" runat="server" Visible="false"></asp:Label>
                </div>
            </div>
        </div>
    </div>

</asp:Content>
