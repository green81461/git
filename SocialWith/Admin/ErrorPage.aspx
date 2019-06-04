<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Master/AdminMasterPage.master" AutoEventWireup="true" CodeFile="ErrorPage.aspx.cs" Inherits="Admin_ErrorPage" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
     <div class="sub-contents-div" >    
		<h1>관리자페이지 에러</h1>
         <div style="width:100%">
             <asp:Label runat="server" id="lblErr"></asp:Label>
         </div>
  	</div>
</asp:Content>

