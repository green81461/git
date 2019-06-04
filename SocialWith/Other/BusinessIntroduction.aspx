<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/Master/Default.master" CodeFile="BusinessIntroduction.aspx.cs" Inherits="Other_CompanyAbout" %>

<%@ Import Namespace="Urian.Core" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">

    <link href="../Content/other/faq.css" rel="stylesheet" />
    <link href="../Content/sub.css" rel="stylesheet" />

    <div class="sub-contents-div">

        <div class="sub-title-div">
            <img src="/images/BusinessIntroduction.png" />
        </div>

        <div class="div-compabout-content" id="divMainContent">

            <div class="tab-content" id="divMainContent_1">
                사업소개 내용
            </div>
        </div>
        <div class="left-menu-wrap" id="divLeftMenu">
            <dl>
                <dt style="border-bottom: 1px solid #eaeaea;">
                    <strong>회사소개</strong>
                </dt>
                <dd>
                    <a href="/Other/CompanyAbout">인사말</a>
                </dd>
                <dd class="active">
                    <a href="/Other/BusinessIntroduction">사업소개</a>
                </dd>
                <dd>
                    <a href="/Other/CompanyMap.aspx">오시는 길</a>
                </dd>
            </dl>
        </div>
    </div>
    <script charset="UTF-8">

</script>

</asp:Content>
