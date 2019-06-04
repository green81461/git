
<%@ Page Language="C#" AutoEventWireup="true" CodeFile="imageUpload.aspx.cs" Inherits="Admin_imageUpload" %>


<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
        <div>
        
            <br />
            <br />
            <br />
            <asp:RadioButton ID="rdBtn1" runat="server" GroupName="rdCheck" Text="FTP" />
            <br />
            <asp:RadioButton ID="rdBtn2" runat="server" GroupName="rdCheck" Text="Forder" />
            <br />
         
            
            <br />
            <br />
        </div>
   
        <br />
        <br />
        <br />
        <br />
  
        &nbsp;&nbsp;&nbsp;
        <asp:Button ID="btnUploaded" runat="server" OnClick="btnUploaded_Click" Text="업로드" />
        &nbsp;&nbsp;
        <br />
        <br />
        <br />
        <br />
&nbsp;<br />
        <br />
        <asp:Label ID="lblUpload" runat="server" Visible="False"></asp:Label>
      
    </form>
</body>
</html>
