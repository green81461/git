<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Master/AdminMasterPage.master" AutoEventWireup="true" CodeFile="BoardReply.aspx.cs" Inherits="Admin_Board_BoardReply" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
  <div class="all">
        <div class="sub-contents-div">
    <!--제목-->
            <div class="sub-title-div"><img src="../../AdminSub/Images/Board/board-title.jpg" alt="1:1문의"/></div>
 
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
    </div>
      </div>

</asp:Content>

