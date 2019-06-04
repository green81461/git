<%@ Page Title="" Language="C#" MasterPageFile="~/Master/Login.master" AutoEventWireup="true" CodeFile="LoginCompanyAbout_menu04.aspx.cs" Inherits="Other_LoginCompanyAbout_menu04" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    
    <script charset="UTF-8" class="daum_roughmap_loader_script" src="http://dmaps.daum.net/map_js_init/roughmapLoader.js"></script>
    <script charset="UTF-8" class="daum_roughmap_loader_script" src="https://ssl.daumcdn.net/dmaps/map_js_init/roughmapLoader.js"></script>
   
    <script type="text/javascript">
        $(function () {
            searchLoad();
        });

        function searchLoad() {          
            //제이쿼리로 초기화
            new daum.roughmap.Lander({
                "timestamp": "1558489573314",
                "key": "tkju",
                "mapWidth": "1254",
                "mapHeight": "600"
            }).render();          
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
<div class="header">
    <div>
        <img src="../Images/Introduce/TEXT.png" class="text"/><img src="../Images/Introduce/logo.png" class="head_logo"/>
    </div>
</div>
<div class="tab">
  <h2>회사소개</h2>
  <button class="tablinks" onclick="location.href = 'LoginCompanyAbout_menu01.aspx'; return false;">인사말</button>
  <button class="tablinks" onclick="location.href = 'LoginCompanyAbout_menu02.aspx'; return false;">사업소개</button>
  <button class="tablinks" onclick="location.href = 'LoginCompanyAbout_menu03.aspx'; return false;">사업비전</button>
  <button class="tablinks active" onclick="location.href = 'LoginCompanyAbout_menu04.aspx'; return false;">오시는길</button>
  <button class="jump_main" onclick="location.href = '../Member/Login.aspx'; return false;">소셜위드 플랫폼 이동</button>
</div>

<div class="tabcontent on">
     <h2>오시는길</h2>
     <div id="daumRoughmapContainer1558489573314" class="root_daum_roughmap root_daum_roughmap_landing"></div>
    <div style="margin-top: 20px; margin-bottom: 20px; margin-left: 20px; height: auto; text-align: left; overflow: hidden">
        <b>찾아오시는 길 : 서울 구로구 디지털로30길 28 404호 소셜공감</b>
    </div>
</div>
</asp:Content>

