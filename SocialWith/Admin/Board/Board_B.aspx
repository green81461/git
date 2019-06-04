<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Master/AdminMasterPage.master" AutoEventWireup="true" CodeFile="Board_B.aspx.cs" Inherits="Admin_Board_Board_B" %>
<%@ Register Src="~/UserControl/ucListControl.ascx" TagName="ListPager" TagPrefix="ucPager"%>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    
        <meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
    <link href="../Content/font-awesome.min.css" rel="stylesheet" />
    <script type="text/javascript">
        function fnTabClickRedirect(pageName) {
            location.href = pageName + '.aspx?ucode=' + ucode;
            return false;
        }
</script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
     <div class="all">
        <div class="sub-contents-div">
<!--제목-->
        <div class="sub-title-div">
                <p class="p-title-mainsentence">
                    1대1문의
                    <span class="span-title-subsentence"></span>
                </p>
            </div>
 
            
<!--탭메뉴-->          
            <!--탭메뉴-->     
        <div class="div-main-tab" style="width: 100%; ">
                <ul>
                    <li class='tabOff' style="width: 185px;" onclick="fnTabClickRedirect('Board_A');">
                        <a onclick="fnTabClickRedirect('Board_A');">판매사</a>
                     </li>
                    <li class='tabOn' style="width: 185px;" onclick="fnTabClickRedirect('Board_B');">
                         <a onclick="fnTabClickRedirect('Board_B');">구매사</a>
                    </li>
                </ul>
            </div>
       
             <div>
            <!--데이터 리스트 시작 -->
            <asp:ListView ID="lvBoardList" runat="server" ItemPlaceholderID="phItemList">
                <LayoutTemplate>


                    <table id="tblHeader" class="tbl_main">
                        
                        <thead>
                            <tr>
                               <th class="txt-center" style="width:80px">번호</th>
                                <th class="txt-center" style="width:120px">작성자</th>
                                <th class="txt-center" style="width:auto">제목</th>
                                <th class="txt-center" style="width:120px">조회수</th>
                                <th class="txt-center" style="width:200px">등록일</th>
                                <th class="txt-center" style="width:200px">진행상태</th>
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
                                <asp:HyperLink runat="server"  Text='<%#Eval("Board_Title").ToString()%>' NavigateUrl='<%# string.Format("Board_B_View.aspx?Svid={0}&ucode=04", Eval("SVID_BOARD").ToString()) %>' ></asp:HyperLink> 
                            </td>
                            <td style="text-align:center">
                                <%# Eval("ReadCount").ToString()%>
                            </td>
                            <td style="text-align:center">
                                    <%# ((DateTime)(Eval("Board_RegDate"))).ToString("yyyy-MM-dd")%>
                            </td>
                             <td style="text-align:center">
                                 <%# SetResultStatusText( Eval("Board_Detail.Result_Status").ToString()) %>
                            </td>
                        </tr>
                </ItemTemplate>
                <EmptyDataTemplate>
                    <div class="bpar">
                    <table class="tbl_main">
                       
                        <thead>
                            <tr class="board-tr-height">
                                <th class="txt-center" style="width:80px">번호</th>
                                <th class="txt-center" style="width:120px">작성자</th>
                                <th class="txt-center" style="width:auto">제목</th>
                                <th class="txt-center" style="width:120px">조회수</th>
                                <th class="txt-center" style="width:200px">등록일</th>
                                <th class="txt-center" style="width:200px">진행상태</th>
                            </tr>
                        </thead>
                        <tr class="board-tr-height">
                            <td colspan="6" style="text-align:center;">조회된 데이터가 없습니다.</td>
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
                        <asp:DropDownList ID="ddlSearchTarger" runat="server" style="width:200px">
                            <asp:ListItem Text="제목" Value="Title"></asp:ListItem>
                            <asp:ListItem Text="작성자" Value="Writer"></asp:ListItem>
                        </asp:DropDownList>
                        <asp:TextBox ID="txtSearch" runat="server" Onkeypress="return fnEnter();" Width="500"></asp:TextBox>
                        <asp:Button ID="btnSearch" runat="server" CssClass="mainbtn type1" Text="검색" Width="75" Height="25"  OnClick="btnSearch_Click"/>
                    </td>
                </tr>
            </table>
        </div>
</div>
    </div>
</asp:Content>

