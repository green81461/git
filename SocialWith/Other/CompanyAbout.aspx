<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/Master/Default.master" CodeFile="CompanyAbout.aspx.cs" Inherits="Other_CompanyAbout" %>

<%@ Import Namespace="Urian.Core" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">

    <script>
        var qs = fnGetQueryStrings();
        var qsMenuUpCode;
        var qsMenuType;
        var daumcodeTS;
        var daumcodeKey;
        var qsTab;
        $(function () {
            
            //회사소개이미지 분기(하드코딩...ㅠㅠ)
            var siteName = '<%= SiteName%>';
            var imgTag = ' <img src="/Images/Comp/'+siteName+'-compinfo.jpg">';
                $('#divMainContent_1').append(imgTag);
        })


        function openNewWindow() {
            window.open("https://get.adobe.com/reader/?loc=kr");
        }


    </script>


    <link href="../Content/other/faq.css" rel="stylesheet" />
    <link href="../Content/sub.css" rel="stylesheet" />

    <div class="sub-contents-div">

        <div class="sub-title-div">
             <img src="/images/CompanyAbout.png" />
        </div>
        <div class="div-compabout-content" id="divMainContent">
            <div class="tab-content" id="divMainContent_1"></div>
        </div>


        <div class="left-menu-wrap" id="divLeftMenu">
            <dl>
                <dt style="border-bottom:1px solid #eaeaea;">
                    <strong>회사소개</strong>
                </dt>
                <dd class="active">
                    <a href="/Other/CompanyAbout">인사말</a> 
                </dd>
                <dd>
                    <a>사업소개</a><%--href="/Other/BusinessIntroduction"--%>
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
