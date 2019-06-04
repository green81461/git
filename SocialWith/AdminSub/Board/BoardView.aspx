<%@ Page Title="" Language="C#" MasterPageFile="~/AdminSub/Master/AdminSubMaster.master" AutoEventWireup="true" CodeFile="BoardView.aspx.cs" Inherits="AdminSub_Board_BoardView" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <link rel="stylesheet" type="text/css" href="/AdminSub/Contents/board.css" />
    <script type="text/javascript">
        // 목록 버튼 클릭 시
        //function fnGoList() {
        //    location.href = 'BoardList.aspx';
        //    return false;
        //}
         var qs = fnGetQueryStrings();
        var ucode = qs["ucode"];
        function fnDeleteConfirm() {
            if (confirm('삭제하시겠습니까?')) {
                return true;
            }
            return false;
        }
        function fnGoList() {
            location.href = 'BoardList.aspx?ucode=' + ucode;
            return false;
        }

        function fnGoEdit() {
            var svid = '<%= Svid%>';
            location.href = 'BoardEdit.aspx?Svid=' + svid+ '&ucode=' + ucode;
             return false;
         }
    </script>
    
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    
    <!--1:1문의 게시판 시작-->
    <div class="sub-contents-div">

       <!--제목 타이틀-->
            <div class="sub-title-div">
                <p class="p-title-mainsentence">
                    1:1 회원문의
                    <span class="span-title-subsentence">편리한 쇼핑을 위한 최근 소식이나 유익한 정보를 고객님께 안내해 드리고 있습니다.</span>
                </p>
            </div>
        <!--사용자가 작성한 문의 영역 시작-->
        <div class="board-view-div">
            <table class="board-table board-dtl-table">
                <tr>
                    <th><asp:Label runat="server" ID="lblCompanyNmHeader" Text="회사/기관명"></asp:Label></th>
                    <td class="padding-left-ten"><asp:Label runat="server" ID="lblCompanyNm" ></asp:Label></td>
                    <th><asp:Label runat="server" ID="lblWriteHeader" Text="작성자"></asp:Label></th>
                    <td class="padding-left-ten"><asp:Label runat="server" ID="lblWrite"></asp:Label></td>
                </tr>
                <tr>
                    <th><asp:Label runat="server" ID="lblTelHeader" Text="전화번호"></asp:Label></th>
                    <td class="padding-left-ten"><asp:Label runat="server" ID="lblTel"></asp:Label></td>
                    <th><asp:Label runat="server" ID="lblPhoneNoHeader" Text="휴대전화번호"></asp:Label></th>
                    <td class="padding-left-ten"><asp:Label runat="server" ID="lblPhoneNo"></asp:Label></td>
                </tr>
                <tr>
                    <th><asp:Label runat="server" ID="lblEmailHeader" Text="이메일"></asp:Label></th>
                    <td class="padding-left-ten"><asp:Label runat="server" ID="lblEmail"></asp:Label></td>
                    <!--<td><asp:Label runat="server" ID="lblPwdHeader" Text="게시글 비밀번호"></asp:Label></td>
                    <td><asp:Label runat="server" ID="lblPwd"></asp:Label></td>-->
                    <th><asp:Label runat="server" ID="lblQueryGubunHeader" Text="문의구분"></asp:Label></th>
                    <td class="padding-left-ten"><asp:Label runat="server" ID="lblQueryGubun"></asp:Label></td>
                </tr>
                <tr style="border:1px solid #a2a2a2">
                    <th><asp:Label runat="server" ID="lblTitleHeader" Text="제목"></asp:Label></th>
                    <td class="padding-left-ten" style="border-bottom:1px solid #a2a2a2;" colspan="3"><asp:Label runat="server" ID="lblTitle"></asp:Label></td>
                </tr>
                <tr>
                    <td class="padding-left-ten txt-contents-td" colspan="4">
                        <asp:Label runat="server" ID="lblContext"></asp:Label>
                    </td>
                </tr>
                <tr style="border:1px solid #a2a2a2">
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
        </div>
        <!--사용자가 작성한 문의 영역 끝-->

        <%--<br />--%>

        <!--관리자 답변 영역 시작-->
        <div class="board-view-ans-div">
            <table class="board-table board-dtl-table">
                <tr style="border:1px solid #a2a2a2">
                    <th>처리담당자</th>
                    <td class="txt-center" style="width:150px"><asp:Label runat="server" ID="lblAdmin"></asp:Label></td>
                    <th>처리결과</th>
                    <td class="txt-center"><asp:Label runat="server" ID="lblStatus"></asp:Label></td>
                    <th>처리일자</th>
                    <td class="txt-center" style="width:150px"><asp:Label runat="server" ID="lblReplyDate"></asp:Label></td>
                    <td class="support-width-td">고객센터 : 02-6363-2174</td>
                </tr>
                <tr>
                    <th>답변</th>
                    <td class="board-answer-td" colspan="6"><asp:Label runat="server" ID="lblReply"></asp:Label></td>
                </tr>
            </table>
        </div>
        <!--관리자 답변 영역 끝-->

        <!--버튼 영역 시작-->
        <div class="bottomBtn" style="text-align:right;">
            <asp:Button ID="btnDelete" runat="server"  CssClass="mainbtn type1" Width="95" Height="30"  Text="삭제" OnClick="btnDelete_Click"/>
            <asp:Button ID="Button1" runat="server"  CssClass="mainbtn type1" Width="95" Height="30"  Text="수정" OnClientClick="return fnGoEdit();"/>
            <asp:Button ID="Button2" runat="server"  CssClass="mainbtn type1" Width="95" Height="30" Text="목록" OnClientClick="return fnGoList();"/>
        </div>
        <!--버튼 영역 끝-->

    </div>
    <!--1:1문의 게시판 끝-->

</asp:Content>

