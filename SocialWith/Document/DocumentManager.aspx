<%@ Page Title="" Language="C#" MasterPageFile="~/Master/Default.master" AutoEventWireup="true" CodeFile="DocumentManager.aspx.cs" Inherits="Document_DocumentManager" %>
<%@ Register Src="~/UserControl/ucListControl.ascx" TagName="ListPager" TagPrefix="ucPager"%>
<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <link href="../Content/Document/document.css" rel="stylesheet" />
    <script type="text/javascript">
        function fnEnter() {

            if (event.keyCode == 13) {
                <%=Page.GetPostBackEventReference(btnSearch)%>
                return false;
            }
            else
                return true;
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <div class="sub-contents-div">
      <div class="sub-title-div">
	        <p class="p-title-mainsentence">
                       증빙서류관리
                       <span class="span-title-subsentence">증빙서류를 다운로드 할 수 있습니다.</span>
            </p>
         </div>
     
        <!--데이터 리스트 시작 -->
        <asp:ListView ID="lvDocumentList" runat="server" ItemPlaceholderID="phItemList" OnItemCommand="lvDocumentList_ItemCommand">
             <LayoutTemplate>
                    <table id="tblHeader" class="board-table" >
                        <colgroup class="col-width-colgrp">                        
                            <col style="width:70px;"/>
                            <col style="width:100px;"/>
                            <col style="width:100px;"/>
                            <col style="width:300px;"/>
                            <col style="width:141px;"/>
                            <col style="width:141px;"/>
                        </colgroup>
                        <thead>
                            <tr class="board-tr-height">
                                <th class="txt-center">번호</th>
                                <th class="txt-center">등록일</th>
                                <th class="txt-center">판매사</th>
                                <th class="txt-center">증빙서류명</th>
                                <th class="txt-center">다운로드</th>
                             
                            </tr>
                        </thead>
                        <tbody>
                            <asp:PlaceHolder ID="phItemList" runat="server" />
                        </tbody>
                    </table>
                </LayoutTemplate>
                <ItemTemplate>
                        <tr class="board-tr-height" style="height:30px;">
                            <td class="txt-center"><%#  Eval("RowNum")%></td>
                            <td class="txt-center"><%# ((DateTime)(Eval("EntryDate"))).ToString("yyyy-MM-dd")%> </td>
                            <td class="txt-center"><%# Eval("Company_Name").ToString()%></td>
                            <td style="padding-left:10px; font-weight:bold"><%# Eval("ATTACH_P_NAME").ToString()%></td>
                            <td class="txt-center" style="padding-top:7px; vertical-align:middle;">
                                <asp:ImageButton ID="btnDownload" runat="server" imageUrl="../Images/Document/doc_down_btn_off.jpg" onmouseover="this.src='../Images/Document/doc_down_btn_on.jpg'" onmouseout="this.src='../Images/Document/doc_down_btn_off.jpg'" CommandName="Download" CommandArgument='<%# Eval("Attach_Path").ToString() %>'/>
                                <asp:HiddenField ID="hfFileName" runat="server" Value='<%# Eval("ATTACH_P_NAME").ToString()%>' />
                            </td>
                           
                        </tr>
                </ItemTemplate>
                <EmptyDataTemplate>
                    <table class="board-table">
                            <colgroup>
                            <col />
                            <col />
                            <col />
                            <col />
                            <col />
                        </colgroup>
                        <thead>
                            <tr class="board-tr-height">
                                <th class="txt-center">번호</th>
                                <th class="txt-center">등록일</th>
                                <th class="txt-center">판매사</th>
                                <th class="txt-center">증빙서류명</th>
                                <th class="txt-center">다운로드</th>
                               
                            </tr>
                        </thead>
                        <tr class="board-tr-height">
                            <td colspan="6" class="txt-center">조회된 데이터가 없습니다.</td>
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

        <div class="bottom-search-div">
            <table class="board-search-table">
                <tr>
                    <td>
                        <asp:DropDownList ID="ddlSearchTarget" runat="server">
                            <asp:ListItem Text="판매사" Value="SALE"></asp:ListItem>
                            <asp:ListItem Text="증빙서류" Value="DOCUMENT"></asp:ListItem>
                        </asp:DropDownList>
                    </td>
                    <td>
                        <asp:TextBox ID="txtSearch" runat="server" Onkeypress="return fnEnter();" width="690px"></asp:TextBox>
                    </td>
                    <td style="width:95px; height:30px; float:left; margin-top:15px; margin-left:10px;">
                        <%--검색 버튼--%>
                        <%--<asp:Button ID="btnSearch" runat="server" CssClass="board-search-btn" OnClick="btnSearch_Click"/>--%>
                        <asp:Button ID="btnSearch" runat="server" OnClick="btnSearch_Click" Text="검색" CssClass="mainbtn type1" Width="95" Height="30"/>
                    </td>                  
                </tr>
            </table>
        </div>


    </div>
</asp:Content>

