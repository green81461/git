<%@ Control Language="C#" AutoEventWireup="true" CodeFile="ucListControl.ascx.cs" Inherits="UserControl_ucListControl" %>
<style>
    .paginarrowbutton{
        border:1px solid #E4E4E4;
        width:44px;
        height:44px;
        margin: 0 2px 0 2px;
        font-weight:bold;
        color:#8A8A8A;
        text-align:center;
    }
     
        .paginarrowbutton:hover {
            border:1px solid #403f44;
        }

</style>
<div id="divPanel" class="" style="margin-top:10px;" runat="server">
   <div class="paginationjs">
        <div class="paginationjs-pages">
            <ul class="ucPager_table">
                <li>
                    <asp:ImageButton d="btnGoFirstPage" CssClass="paginarrowbutton" runat="server"  ImageUrl="~/Images/left-arrow.jpg"  OnClick="btnGoFirstPage_Click"/>
                   <%--  <asp:Button id="btnGoFirstPage" CssClass="paginarrowbutton" runat="server" Text="<<" OnClick="btnGoFirstPage_Click" />--%>
                </li>
                <li>
                     <asp:ImageButton d="btnGoPreviousPage" CssClass="paginarrowbutton" runat="server"  ImageUrl="~/Images/left-arrow-pre.jpg"  OnClick="btnGoPreviousPage_Click"/>
                     <%--<asp:Button id="btnGoPreviousPage" CssClass="paginarrowbutton" runat="server" Text="<" OnClick="btnGoPreviousPage_Click" />--%>
                </li>
                <asp:Label id="lblPageList" CssClass="lblPageList" runat="server" />
                <li>
                    <asp:ImageButton d="btnGoNextPage" CssClass="paginarrowbutton" runat="server"  ImageUrl="~/Images/right-arrow-next.jpg"  OnClick="btnGoNextPage_Click"/>
                     <%--<asp:Button id="btnGoNextPage" CssClass="paginarrowbutton" runat="server" Text=">" OnClick="btnGoNextPage_Click" />--%>
                </li>
                <li>
                     <asp:ImageButton d="btnGoLastPage" CssClass="paginarrowbutton" runat="server"  ImageUrl="~/Images/right-arrow.jpg"  OnClick="btnGoLastPage_Click"/>
                     <%--<asp:Button id="btnGoLastPage" CssClass="paginarrowbutton" runat="server" Text=">>" OnClick="btnGoLastPage_Click" />--%>
                </li>
            </ul>
        </div>
        </div>
   
        <%--<table class="ucPager_table">
        <tr>
            <td>
                <asp:Button id="btnGoFirstPage" CssClass="btnGoFirstPage" runat="server" Text="<<" OnClick="btnGoFirstPage_Click" />
            </td>
            <td>
                <asp:Button id="btnGoPreviousPage" CssClass="btnGoPreviousPage" runat="server" Text="<" OnClick="btnGoPreviousPage_Click" />
            </td>
            <td>
               <asp:Label id="lblPageList" CssClass="lblPageList" runat="server" Text=""  />
            </td>
            <td>
                <asp:Button id="btnGoNextPage" CssClass="btnGoNextPage" runat="server" Text=">" OnClick="btnGoNextPage_Click" />
            </td>
            <td>
                <asp:Button id="btnGoLastPage" CssClass="btnGoLastPage" runat="server" Text=">>" OnClick="btnGoLastPage_Click" />
            </td>
        </tr>
        </table>--%>
    

    <asp:Button ID="btnGoSelectedPage" runat="server"  style="display: none;" OnClick="btnGoSelectedPage_Click" />
    <asp:HiddenField id="hfCurrentPageIndex" runat="server"/>
</div>


<script type="text/javascript">
    function goSelectedPage(pageIndex) {
       
       
        var btnGoSelectedPage = $("#<%=btnGoSelectedPage.ClientID %>");
        var hdnCurrentPageIndex = $("#<%=hfCurrentPageIndex.ClientID %>");
       
        hdnCurrentPageIndex.val(pageIndex);
        btnGoSelectedPage.click();
    }
</script>

