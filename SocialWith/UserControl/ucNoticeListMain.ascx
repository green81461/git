<%@ Control Language="C#" AutoEventWireup="true" CodeFile="ucNoticeListMain.ascx.cs" Inherits="UserControl_ucNoticeListMain" %>
<%@ Import Namespace="Urian.Core" %>
<script type="text/javascript">
    function fnGoNoticeView(svidBoard) {
        location.href = '../../Notice/NoticeView.aspx?Svid=' + svidBoard;
        return false;
    }
</script>
<asp:Label ID="lblnoticeList" runat="server"></asp:Label>
