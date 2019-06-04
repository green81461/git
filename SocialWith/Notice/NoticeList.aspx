<%@ Page Title="" Language="C#" MasterPageFile="~/Master/Default.master" AutoEventWireup="true" CodeFile="NoticeList.aspx.cs" Inherits="Notice_NoticeList" %>
<%@ Register Src="~/UserControl/ucListControl.ascx" TagName="ListPager" TagPrefix="ucPager"%>
<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">

    <script type="text/javascript">
       
        function fnGoWrite() {
            location.href = 'NoticeInsert.aspx'
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
    <div class="sub-contents-div">
        <div class="sub-title-div">
             <img src="/images/NoticeList_go_nam.png" />
	        <%--<p class="p-title-mainsentence">
                       공지사항
                       <span class="span-title-subsentence">편리한 쇼핑을 위한 최근 소식이나 유익한 정보를 고객님께 안내해 드리고 있습니다.</span>
            </p>--%>
         </div>
        <div>
            <!--데이터 리스트 시작 -->
            <asp:ListView ID="lvBoardList" runat="server" ItemPlaceholderID="phItemList">
                <LayoutTemplate>
                    <table id="tblHeader" class="tbl_main">
                    
                        <thead>
                            <tr >
                                <th style="width:30px">번호</th>
                                <th style="width:120px">작성자</th>
                                <th style="width:auto">제목</th>
                                <th style="width:120px">조회수</th>
                                <th style="width:120px">등록일</th>
                            </tr>
                        </thead>
                        <tbody>
                            <asp:PlaceHolder ID="phItemList" runat="server" />
                        </tbody>
                    </table>
                </LayoutTemplate>
                <ItemTemplate>
                        <tr>
                            <td class="txt-center">
                                <%# Eval("RowNum").ToString()%>
                            </td>
                            <td class="txt-center">
                                <%# Eval("Board_Write").ToString()%>
                            </td>
                            <td class="align-left">
                                <asp:HyperLink runat="server"  Text='<%#Eval("Board_Title").ToString()%>' NavigateUrl='<%# string.Format("NoticeView.aspx?Svid={0}", Eval("SVID_BOARD").ToString()) %>' ></asp:HyperLink> 
                            </td>
                            <td class="txt-center">
                                <%# Eval("ReadCount").ToString()%>
                            </td>
                            <td class="txt-center">
                                    <%# ((DateTime)(Eval("Board_RegDate"))).ToString("yyyy-MM-dd")%>
                            </td>
                        </tr>
                </ItemTemplate>
                <EmptyDataTemplate>
                    <table class="tbl_search">
                        <colgroup>
                            <%--<col style="width:50px;" />
                            <col style="width:70px" />
                            <col style="width:200px" />
                            <col style="width:100px" />--%>
                            
                            <col />
                            <col />
                            <col />
                            <col />
                            <col />
                        </colgroup>
                        <thead>
                            <tr>
                                <th class="txt-center" style="width:30px">번호</th>
                                <th class="txt-center" style="width:120px">작성자</th>
                                <th class="txt-center" style="width:auto">제목</th>
                                <th class="txt-center" style="width:120px">조회수</th>
                                <th class="txt-center" style="width:120px">등록일</th>
                            </tr>
                        </thead>
                        <tr>
                            <td colspan="5" style="text-align:center;">조회된 데이터가 없습니다.</td>
                        </tr>
                    </table>
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
            <table class="notice-search-table">
                <tr>
                    <td>
                        <asp:DropDownList ID="ddlSearchTarger" runat="server">
                            <asp:ListItem Text="제목" Value="Title"></asp:ListItem>
                            <asp:ListItem Text="작성자" Value="Writer"></asp:ListItem>
                        </asp:DropDownList>
                    </td>
                    <td>
                        <asp:TextBox ID="txtSearch" runat="server" Onkeypress="return fnEnter();"></asp:TextBox>
                    </td>
                    <td>
                        <asp:Button ID="btnSearch" runat="server" OnClick="btnSearch_Click" style="vertical-align:middle; margin-top:-5px;" Text="검색" CssClass="mainbtn type1" Width="117" Height="30"/>
                       <%-- <asp:Button ID="btnSearch" runat="server" CssClass="notice-search-btn" OnClick="btnSearch_Click"/>--%>
                    </td>
                    <%--<td>
                        <asp:Button ID="btnGoInsert" runat="server" CssClass="notice-write-btn" OnClientClick="return fnGoWrite()"/>
                    </td>--%>
                </tr>
            </table>
        </div>

        <div class="notice-write-btn-div">
            <asp:Button ID="btnGoInsert" runat="server" CssClass="notice-write-btn" OnClientClick="return fnGoWrite()" Visible="false"/>
        </div>
        <div class="left-menu-wrap" id="divLeftMenu">
	        <dl>
		        <dt style="border-bottom:1px solid #eaeaea;">
			        <strong>고객센터</strong>
		        </dt>
		        <dd class="active">
		           <a href="/Notice/NoticeList.aspx">공지사항</a> 
		        </dd>
		        <dd>
		           <a href="/Board/BoardList.aspx">질문게시판</a> 
		        </dd>
		        <dd>
		           <a href="/Other/Faq.aspx">FAQ</a> 
		        </dd>
		        <%--<dd>
		           <a>담당자 전화번호</a> 
		        </dd>--%>
		    </dl>
        </div>
    </div>
</asp:Content>

