<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Master/AdminMasterPage.master" AutoEventWireup="true" CodeFile="NoticeView.aspx.cs" Inherits="Admin_Notice_NoticeView" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">

<script  type="text/javascript">
    function fnDeleteConfirm()
    {
        if (confirm('삭제하시겠습니까?')) {
            return true;
        }
        return false;
    }

    function fnGoEdit() {
        var svid = '<%= Svid%>';
        location.href = 'NoticeEdit.aspx?Svid=' + svid+'&ucode='+ucode;
        return false;
    }

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

        <div class="board-view-div" style="padding-top:30px">
            <table class="tbl_main">
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
                    <td class="" colspan="4">
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


                  <input type="button" class="mainbtn type1" style="width: 95px; height: 30px;" value="수정" onclick="return fnGoEdit();" />
                  <asp:Button ID="btnDelete" runat="server" Width="95" Height="30" Text="삭제" OnClick="btnDelete_Click" OnClientClick="return fnDeleteConfirm()" CssClass="mainbtn type1"/>
                  <input type="button" class="mainbtn type1" style="width: 95px; height: 30px;" value="목록" onclick="return fnGoList();" />
              </div>
                
        </div>
       
            <%--<table>
                <tr>
                    <td>
                        <asp:Button ID="btnEdit" runat="server" Text="수정"  OnClientClick="return fnGoEdit();"/>
                    </td>
                    <td>
                            <asp:Button ID="btnDelete" runat="server" Text="삭제" OnClientClick="return fnDeleteConfirm()" OnClick="btnDelete_Click"/>
                    </td>
                    
                    <td>
                        <asp:Button ID="BtnList" runat="server" Text="목록" OnClientClick="return fnGoList();"/>
                    </td>
                </tr>
            </table>--%>
         
                
              
           
              

        
    </div>
    <!--공지사항 게시판 끝-->
</asp:Content>

