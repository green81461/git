<%@ Page Title="" Language="C#" MasterPageFile="~/Master/Default.master" AutoEventWireup="true" CodeFile="BannerInfo.aspx.cs" Inherits="Other_BannerInfo" %>
<%@ Import Namespace="Urian.Core" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
     <script type="text/javascript">
         var qs = fnGetQueryStrings();
         var bannerIndex;
         var bannerDetailFile;
         $(function () {
            
             bannerIndex = qs["BannerIndex"];
             bannerDetailFile = qs["FileName"];
             var distCode = $('#hdMasterDistCssCode').val();
             var upload = '<%= ConfigurationManager.AppSettings["UpLoadFolder"].AsText()%>';

             if (!isEmpty(bannerDetailFile)) {
                 $('#imgDetail').attr('src', upload + '/SiteManagement/' + distCode + '/Banner/' + bannerDetailFile);

             }
             else {
                 $('#imgDetail').attr('src', upload + '/SiteManagement/' + distCode + '/BannerDetail-' + bannerIndex + '.jpg');

             }
         })
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
      <div class="sub-contents-div">
          <div style="text-align:center">
              <img src="" id="imgDetail"/>
          </div>
      </div>
</asp:Content>

