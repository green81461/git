<%@ Page Title="" Language="C#" MasterPageFile="~/AdminSub/Master/AdminSubMaster.master" AutoEventWireup="true" CodeFile="NoticeList.aspx.cs" Inherits="AdminSub_Board_NoticeList" %>
<%@ Register Src="~/UserControl/ucListControl.ascx" TagName="ListPager" TagPrefix="ucPager"%>
<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
 <link rel="stylesheet" type="text/css" href="/AdminSub/Contents/board.css" />
    <script type="text/javascript">
        var qs = fnGetQueryStrings();
        var ucode = qs["ucode"];
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
        <!--탭메뉴-->          
            <%--<div class="sub-tab-div">
	    		<ul>
		    		<li>
			    		<a href="../Notice/NoticeList.aspx"><img src="../../AdminSub/Images/Board/boardA-on.jpg"  alt="고객사A"/></a>
				    	<a href="../Notice/NoticeList.aspx"><img src="../../AdminSub/Images/Board/boardB-off.jpg" alt="고객사B"/></a>
                     </li>
			    </ul>
	         </div>--%>
        <div>
            <!--데이터 리스트 시작 -->
            <asp:ListView ID="lvBoardList" runat="server" ItemPlaceholderID="phItemList">
                <LayoutTemplate>


                    <table id="tblHeader" class="board-table">
                        <colgroup class="notice-col-width-colgrp">
                            <col style="width:50px;" />
                            <col style="width:70px" />
                            <col style="width:200px" />
                            <col style="width:100px" />
                            <col style="width:100px" />

                            <col />
                            <col />
                            <col />
                            <col />
                            <col />
                        </colgroup>
                        <thead>
                            <tr class="board-tr-height">
                                <th class="txt-center">번호</th>
                                <th class="txt-center">작성자</th>
                                <th class="txt-center">제목</th>
                                <th class="txt-center">조회수</th>
                                <th class="txt-center">등록일</th>
                            </tr>
                        </thead>
                        <tbody>
                            <asp:PlaceHolder ID="phItemList" runat="server" />
                        </tbody>
                    </table>
                </LayoutTemplate>
                <ItemTemplate>
                        <tr class="board-tr-height">
                            <td class="txt-center">
                                <%# Eval("RowNum").ToString()%>
                            </td>
                            <td class="txt-center">
                                <%# Eval("Board_Write").ToString()%>
                            </td>
                            <td>
                                <asp:HyperLink runat="server"  Text='<%#Eval("Board_Title").ToString()%>' NavigateUrl='<%# string.Format("NoticeView.aspx?Svid={0}&ucode={1}", Eval("SVID_BOARD").ToString(),Request.QueryString["ucode"]) %>' ></asp:HyperLink> 
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
                    <div class="bpar">
                    <table class="board-table">
                        <colgroup class="notice-col-width-colgrp">
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
                            <tr class="board-tr-height">
                                <th class="txt-center">번호</th>
                                <th class="txt-center">작성자</th>
                                <th class="txt-center">제목</th>
                                <th class="txt-center">조회수</th>
                                <th class="txt-center">등록일</th>
                            </tr>
                        </thead>
                        <tr class="board-tr-height">
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
            <table class="notice-search-table" >
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
                    <td >
                        <asp:Button ID="btnSearch" runat="server"  OnClick="btnSearch_Click" Text="검색" CssClass="mainbtn type1" Width="75" Height="30"/>
                    </td>
                </tr>
            </table>
        </div>

    </div>
    </div>
</asp:Content>

