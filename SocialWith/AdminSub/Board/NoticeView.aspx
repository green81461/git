<%@ Page Title="" Language="C#" MasterPageFile="~/AdminSub/Master/AdminSubMaster.master" AutoEventWireup="true" CodeFile="NoticeView.aspx.cs" Inherits="AdminSub_Board_NoticeView" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
       <link rel="stylesheet" type="text/css" href="/AdminSub/Contents/board.css" />
<script  type="text/javascript">
    var qs = fnGetQueryStrings();
    var ucode = qs["ucode"];
    function fnGoList() {
        location.href = 'NoticeList.aspx?ucode='+ucode;
        return false;
    }
    
</script>

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">

    <!--공지사항 게시판 시작-->
    <div class="sub-contents-div">

        <div class="sub-title-div">
                <p class="p-title-mainsentence">
                    공지사항
                    <span class="span-title-subsentence">편리한 쇼핑을 위한 최근 소식이나 유익한 정보를 고객님께 안내해 드리고 있습니다.</span>
                </p>
            </div>

        <div class="board-view-div">
            <table class="board-table board-dtl-table">
                <tr >
                   <th>
                      <asp:Label runat="server" ID="lblTitleHeader" Text="제목"></asp:Label>
                    </th>
                    <td class="padding-left-ten" colspan="3">
                        <asp:Label runat="server" ID="lblTitle"></asp:Label>
                    </td>
                </tr>
                <tr>
                    <th>
                        <asp:Label runat="server" ID="lblWriteHeader" Text="작성자  "></asp:Label>
                    </th>
                    <td class="padding-left-ten">
                        <asp:Label runat="server" ID="lblWriter"></asp:Label>
                    </td>
                    <th>
                        <asp:Label runat="server" ID="lblRegDateHeader" Text="작성일  "></asp:Label>
                    </th>
                    <td class="padding-left-ten">
                        <asp:Label runat="server" ID="lblRegDate"></asp:Label>
                    </td>
                </tr>
                 <tr>
                    <td class="padding-left-ten txt-contents-td" colspan="4">
                        <asp:Label runat="server" ID="lblContent"></asp:Label>
                    </td>
                </tr>
                <tr>
                    <th>
                        <asp:Label runat="server" ID="lblFileHeader" Text="첨부파일"></asp:Label>
                    </th>
                    <td class="padding-left-ten" colspan="3">
                         <asp:LinkButton runat="server" ID="lbFileDown" OnClick="lbFileDown_Click"></asp:LinkButton>
                         <asp:HiddenField runat ="server" ID="hfFilePath" />
                         <asp:HiddenField runat ="server" ID="hfFileName" />
                    </td>
                    </tr>
            </table>
                 
        <%-- <div class="bt-left1">
              
            </div> 
            <div class="bt-right1">
                
            </div>--%>
              <div class="list-bottomBt" style="float:right; padding-top:10px">
                    <asp:Button ID="btnList" runat="server"  OnClientClick="return fnGoList();" Text="목록" CssClass="mainbtn type1" Width="95" Height="30"/>
               </div>
                
        </div>
       
    </div>
    <!--공지사항 게시판 끝-->
</asp:Content>

