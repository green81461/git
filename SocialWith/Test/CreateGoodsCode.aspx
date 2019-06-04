<%@ Page Language="C#" AutoEventWireup="true" CodeFile="CreateGoodsCode.aspx.cs" Inherits="Test_CreateGoodsCode" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
        <div>
            <asp:TextBox runat="server" ID="txtGoodsCode"></asp:TextBox>
            <asp:Button runat="server" ID="btnGenerateCode" Text="생성" OnClick="btnGenerateCode_Click" />

            <br />

            <asp:TextBox runat="server" ID="txtGroupCode"></asp:TextBox>
            <asp:Button runat="server" ID="btnGenerateGroupCode" Text="생성" OnClick="btnGenerateGroupCode_Click" />
        </div>
    </form>
</body>
</html>
