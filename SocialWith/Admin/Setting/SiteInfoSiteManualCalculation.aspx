<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Master/AdminMasterPage.master" AutoEventWireup="true" CodeFile="SiteInfoSiteManualCalculation.aspx.cs" Inherits="Admin_Setting_SiteInfoSiteManualCalculation" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <script type="text/javascript">
        $(document).ready(function () {
            function fnTabClickRedirect(pageName) {
            location.href = pageName + '.aspx?ucode=' + ucode;
            return false;
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
        <div class="sub-contents-div">
            <!--제목타이틀 영역-->
            <div class="sub-title-div">
                <p class="p-title-mainsentence">
                    사이트 메뉴얼
                    <span class="span-title-subsentence"></span>
                </p>
            </div>
            <!--탭메뉴-->
            <div class="div-main-tab" style="width: 100%;">
                <ul>
                   <li class='tabOff' style="width: 185px;" onclick="fnTabClickRedirect('SiteInfoSiteManual');">
                        <a onclick="fnTabClickRedirect('SiteInfoSiteManual');">사이트유형</a>
                     </li>
                    <li class='tabOff' style="width: 185px;" onclick="fnTabClickRedirect(SiteInfoSiteManualSummary');">
                         <a onclick="fnTabClickRedirect('SiteInfoSiteManualSummary');">정산구분 요약</a>
                    </li>
                    <li class='tabOff' style="width: 185px;" onclick="fnTabClickRedirect(SiteInfoSiteManualBill');">
                         <a onclick="fnTabClickRedirect('SiteInfoSiteManualBill');">Bill 정산</a>
                    </li>
                    <li class='tabOn' style="width: 185px;" onclick="fnTabClickRedirect('SiteInfoSiteManualCalculation');">
                         <a onclick="fnTabClickRedirect('SiteInfoSiteManualCalculation');">계산식</a>
                    </li>
                </ul>
            </div>
            <!--메뉴얼 설명 시작-->
            <div class="site_images">
                 <img src="../images/Setting/3.png" />
            </div>
         </div>
</asp:Content>

