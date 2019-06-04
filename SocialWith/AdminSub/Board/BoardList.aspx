<%@ Page Title="" Language="C#" MasterPageFile="~/AdminSub/Master/AdminSubMaster.master" AutoEventWireup="true" CodeFile="BoardList.aspx.cs" Inherits="AdminSub_Board_BoardList" %>
<%@ Register Src="~/UserControl/ucListControl.ascx" TagName="ListPager" TagPrefix="ucPager"%>
<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <link rel="stylesheet" type="text/css" href="/AdminSub/Contents/board.css" />
    <script type="text/javascript">
        var qs = fnGetQueryStrings();
        var ucode = qs["ucode"];
        function fnGoWrite() {

            location.href = 'BoardInsert.aspx?ucode=' + ucode;
            return false;
        }

        // 게시글 제목 클릭 시 비밀번호 입력 modal 관련 처리
        function fnPwdModal(svId) {
            location.href = "BoardView.aspx?Svid=" + svId + '&ucode=' + ucode;
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
    
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <body onselectstart="return false">
    <!-- 게시글 비밀번호 입력 Modal 시작 -->
    <div class="modal fade" id="myPwdModal" role="dialog">
        <div id="pwdModalDiv" class="modal-dialog">
            
            <!-- Modal content-->
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal">&times;</button>
                    <img src="../../Images/sub_pass_write_bg.jpg" alt="비밀번호" />
                </div>
                <div class="modal-body">
                    <p>* 비회원은 <strong>1:1 문의시 입력한 비밀번호</strong>를 입력해 주세요.</p>
                </div>
                <div class="modal-footer">
                    <%--<asp:TextBox ID="txtPwd" runat="server"></asp:TextBox>
                    <asp:Button ID="btnPwd" runat="server" class="btn btn-default" data-dismiss="modal" Text="OK" OnClick="btnPwd_Click"/>--%>
                   <input type="password" id="txtPwd" name="txtPwd" class="pwd-input" />
                    <button id="btnPwd" class="btn" data-dismiss="modal"></button>
                </div>
            </div>

        </div>
    </div>
    <!-- 게시글 비밀번호 입력 Modal 끝 -->

    <!--1:1문의 게시판 시작-->
    <div class="sub-contents-div">

        <!--제목 타이틀-->
            <div class="sub-title-div">
                <p class="p-title-mainsentence">
                    1:1 회원문의
                    <span class="span-title-subsentence">편리한 쇼핑을 위한 최근 소식이나 유익한 정보를 고객님께 안내해 드리고 있습니다.</span>
                </p>
            </div>

        
        <div>
            <!--데이터 리스트 시작 -->
            <asp:ListView ID="lvBoardList" runat="server" ItemPlaceholderID="phItemList">
                <LayoutTemplate>
                    <table id="tblHeader" class="board-table">
                        <colgroup class="col-width-colgrp">
                            <%--<col style="width:50px;" />
                            <col style="width:70px" />
                            <col style="width:200px" />
                            <col style="width:100px" />
                            <col style="width:100px" />
                            <col style="width:100px" />--%>

                            <col />
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
                                <th class="txt-center">문의구분</th>
                                <th class="txt-center">등록일</th>
                                <th class="txt-center">진행단계</th>
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
                                <%# Eval("BOARD_WRITE").ToString()%>
                            </td>
                            <td>
                                <asp:LinkButton runat="server" Text='<%#Eval("BOARD_TITLE").ToString()%>' ID="lbPwdModal" OnClientClick='<%# string.Format("javascript:fnPwdModal(\"{0}\"); return false;", Eval("SVID_BOARD").ToString()) %>'></asp:LinkButton>
                                <%--   <asp:LinkButton runat="server" Text='<%#Eval("BOARD_TITLE").ToString()%>' ID="lbPwdModal" ></asp:LinkButton>
                                <asp:HiddenField runat="server" ID="hfPwd" Value='<%#Eval("PWD").ToString()%>'/>
                                <asp:HiddenField runat="server" ID="hfSvid" Value='<%#Eval("SVID_BOARD").ToString()%>'/>--%>
                            </td>
                            <td class="txt-center">
                                <%# Eval("QueryGubunNm").ToString() %>
                            </td>
                            <td class="txt-center">
                                <%# ((DateTime)(Eval("Board_RegDate"))).ToString("yyyy-MM-dd")%>
                            </td>
                            <td class="txt-center">
                                  <%# SetResultStatusText( Eval("Board_Detail.Result_Status").ToString()) %>
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
                            <col />
                        </colgroup>
                        <thead>
                            <tr class="board-tr-height">
                                <th class="txt-center">번호</th>
                                <th class="txt-center">작성자</th>
                                <th class="txt-center">제목</th>
                                <th class="txt-center">문의구분</th>
                                <th class="txt-center">등록일</th>
                                <th class="txt-center">진행단계</th>
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
        </div>
        <div class="bottom-search-div">
            <table class="board-search-table">
                <tr>
                   <td style=" text-align:center; ">
                        <asp:DropDownList ID="ddlComm" runat="server">
                             <asp:ListItem Text="전체" Value=""></asp:ListItem>
                        </asp:DropDownList>

                        <asp:DropDownList ID="ddlSearchTarget" runat="server">
                            <asp:ListItem Text="제목" Value="Title"></asp:ListItem>
                            <asp:ListItem Text="작성자" Value="Writer"></asp:ListItem>
                        </asp:DropDownList>
                    
                        <asp:TextBox ID="txtSearch" runat="server"  Onkeypress="return fnEnter();"></asp:TextBox>
                    
                        <%--검색 버튼--%>
                        <asp:Button ID="btnSearch" runat="server"  CssClass="mainbtn type1" Width="95" Height="30" OnClick="btnSearch_Click" Text="검색"/>
                    
                        <%--1:1 문의하기 버튼--%>
                        <asp:Button ID="btnGoInsert" runat="server"  CssClass="mainbtn type1" Width="135" Height="30" OnClientClick="return fnGoWrite()" Text="1:1 문의하기"/>
                    </td>  
                </tr>
            </table>
        </div>
    </div>
       </body>
    <!--1:1문의 게시판 끝-->

  <script type="text/javascript">
        $(function () {

            $(".priority-company>a").on("mouseover focus", function () {
                $("img", this).attr("src", $("img", this).attr("src").replace("out.jpg", "over.jpg"));
            });


            $(".public>a").on("mouseover focus", function () {
                $("img", this).attr("src", $("img", this).attr("src").replace("out.jpg", "over.jpg"));
            });

            $(".public").on("mouseleave", function () {
                $("img", this).attr("src", $("img", this).attr("src").replace("over.jpg", "out.jpg"));
            });

            $(".priority-company").on("mouseleave", function () {
                $("img", this).attr("src", $("img", this).attr("src").replace("over.jpg", "out.jpg"));
            });
        });

    </script>
</asp:Content>

