<%@ Page Title="" Language="C#" MasterPageFile="~/Master/Login.master" AutoEventWireup="true" CodeFile="LoginCompanyAbout_menu03.aspx.cs" Inherits="Other_LoginCompanyAbout_menu03" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
 
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
  <button class="tablinksactive" onclick="location.href = 'LoginCompanyAbout_menu03.aspx'; return false;">사업비전</button>
  <button class="tablinks" onclick="location.href = 'LoginCompanyAbout_menu04.aspx'; return false;">오시는길</button>
  <button class="jump_main" onclick="location.href = '../Member/Login.aspx'; return false;">소셜위드 플랫폼 이동</button>
</div>

<div class="tabcontent on">
    <h2>사업비전</h2>
    <img src="../Images/Introduce/vision_03.jpg" alt="사업비전"/>
</div>

</asp:Content>

