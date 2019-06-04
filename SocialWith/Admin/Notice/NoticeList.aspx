<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Master/AdminMasterPage.master" AutoEventWireup="true" CodeFile="NoticeList.aspx.cs" Inherits="Admin_Notice_NoticeList" %>
<%@ Register Src="~/UserControl/ucListControl.ascx" TagName="ListPager" TagPrefix="ucPager"%>
<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">

    <script type="text/javascript">
       
        function fnGoWrite() {
            location.href = 'NoticeInsert.aspx?ucode=' + ucode;
            return false;
        }

        function fnEnter() {

            if (event.keyCode == 13) {
                <%=Page.GetPostBackEventReference(btnSearch)%>
                 return false;
             }
             else
                 return true;
         }
    </script>
     <link href="Paging.css" rel="stylesheet" type="text/css" />
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
  <div class="all">
    <div class="sub-contents-div">
        <div class="sub-title-div">
                <p class="p-title-mainsentence">
                    공지사항
                    <span class="span-title-subsentence">편리한 쇼핑을 위한 최근 소식이나 유익한 정보를 고객님께 안내해 드리고 있습니다.</span>
                </p>
            </div>
        
        <div style="padding-top:30px">
            <!--데이터 리스트 시작 -->
            <asp:ListView ID="lvBoardList" runat="server" ItemPlaceholderID="phItemList">
                <LayoutTemplate>


                    <table id="tblHeader" class="tbl_main">
                        
                        <thead>
                            <tr class="board-tr-height">
                                <th class="txt-center" style="width:100px">번호</th>
                                <th class="txt-center" style="width:180px">작성자</th>
                                <th class="txt-center" style="width:auto">제목</th>
                                <th class="txt-center" style="width:180px">조회수</th>
                                <th class="txt-center" style="width:200px">등록일</th>
                            </tr>
                        </thead>
                        <tbody>
                            <asp:PlaceHolder ID="phItemList" runat="server" />
                        </tbody>
                    </table>
                </LayoutTemplate>
                <ItemTemplate>
                        <tr class="board-tr-height">
                            <td style="text-align:center">
                                <%# Eval("RowNum").ToString()%>
                            </td>
                            <td style="text-align:center">
                                <%# Eval("Board_Write").ToString()%>
                            </td>
                            <td>
                                <asp:HyperLink runat="server"  Text='<%#Eval("Board_Title").ToString()%>' NavigateUrl='<%# string.Format("NoticeView.aspx?Svid={0}&ucode=04", Eval("SVID_BOARD").ToString()) %>' ></asp:HyperLink> 
                            </td>
                            <td style="text-align:center">
                                <%# Eval("ReadCount").ToString()%>
                            </td>
                            <td style="text-align:center">
                                    <%# ((DateTime)(Eval("Board_RegDate"))).ToString("yyyy-MM-dd")%>
                            </td>
                        </tr>
                </ItemTemplate>
                <EmptyDataTemplate>
                    <div class="bpar">
                    <table class="tbl_main">
                        
                        <thead>
                            <tr>
                                <th class="txt-center" style="width:100px">번호</th>
                                <th class="txt-center" style="width:180px">작성자</th>
                                <th class="txt-center" style="width:auto">제목</th>
                                <th class="txt-center" style="width:180px">조회수</th>
                                <th class="txt-center" style="width:200px">등록일</th>
                            </tr>
                        </thead>
                        <tr>
                            <td colspan="5" style="text-align:center;">조회된 데이터가 없습니다.</td>
                        </tr>
                    </table>
                        </div>
                </EmptyDataTemplate>
            </asp:ListView>
            <!--데이터 리스트 종료 -->
            
            <!--페이징-->
            <div style="margin:0 auto; text-align:center">
                 <ucPager:ListPager id="ucListPager" runat ="server" OnPageIndexChange="ucListPager_PageIndexChange" PageSize="20"/>
            </div>
            <!--페이징 끝-->
        </div>
        <div class="bottom-search-div">
            <table class="tbl_search" >
                <colgroup>
                    <col style="width:90px;"/>
                    <col />
                    <col />
                </colgroup>
                <tr>
                    <td></td>
                    <td>
                        <asp:DropDownList ID="ddlSearchTarger" runat="server" style="width:200px;">
                            <asp:ListItem Text="제목" Value="Title"></asp:ListItem>
                            <asp:ListItem Text="작성자" Value="Writer"></asp:ListItem>
                        </asp:DropDownList>
                        <asp:TextBox ID="txtSearch" runat="server" Onkeypress="return fnEnter();" Width="500"></asp:TextBox>
                        <asp:Button ID="btnSearch" runat="server" Width="95" Height="30" CssClass="mainbtn type1" OnClick="btnSearch_Click" Text="검색"/>
                    </td>
                </tr>
            </table>
        </div>

        <div style="text-align:right; padding-top:15px">
            <asp:Button ID="btnGoInsert" runat="server" Width="125" Height="30" CssClass="mainbtn type1" OnClientClick="return fnGoWrite()" Text="게시글 작성"/>
        </div>
    </div>
    </div>
</asp:Content>

