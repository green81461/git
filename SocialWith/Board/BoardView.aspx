<%@ Page Title="" Language="C#" MasterPageFile="~/Master/Default.master" AutoEventWireup="true" CodeFile="BoardView.aspx.cs" Inherits="Board_BoardView" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <link rel="stylesheet" type="text/css" href="../Content/board.css" />
    <script type="text/javascript">

        $(function () {

            // 업로드된 파일이 이미지파일일 때 이미지 표시해주기
            var name = $('#ContentPlaceHolder1_lbFileDown').html();
            var path = '../UploadFile' + $('#ContentPlaceHolder1_hfFilePath').val().replace(/\\/g, '/');
            var src = path + name;

            name = name.slice(name.indexOf(".") + 1).toLowerCase();

            if (name == "jpg" || name == "png" || name == "gif" || name == "bmp" || name == "psd" || name == "ai") {
                $('#boardContents').prepend('<img src="' + src + '">');
            }

        });


        function fnDeleteConfirm() {
            if (confirm('삭제하시겠습니까?')) {
                return true;
            }
            return false;
        }
        function fnGoList() {
            location.href = 'BoardList.aspx';
            return false;
        }

        function fnGoEdit() {
            var svid = '<%= Svid%>';
            location.href = 'BoardEdit.aspx?Svid=' + svid;
            return false;
        }

    </script>

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">

    <!--1:1문의 게시판 시작-->
    <div class="sub-contents-div">

        <div class="sub-title-div">
            <img src="/images/BoardList_nam.png" />
        </div>
        <!--사용자가 작성한 문의 영역 시작-->
        <div class="board-view-div">
            <table class="tbl_main" style="width:100%">
                <tr>
                    <th class="border-right">
                        <asp:Label runat="server" ID="lblCompanyNmHeader" Text="회사/기관명"></asp:Label></th>
                    <td class="border-right">
                        <asp:Label runat="server" ID="lblCompanyNm"></asp:Label></td>
                    <th class="border-right">
                        <asp:Label runat="server" ID="lblWriteHeader" Text="작성자"></asp:Label></th>
                    <td>
                        <asp:Label runat="server" ID="lblWrite"></asp:Label></td>
                </tr>
                <tr>
                    <th class="border-right">
                        <asp:Label runat="server" ID="lblTelHeader" Text="전화번호"></asp:Label></th>
                    <td class="border-right">
                        <asp:Label runat="server" ID="lblTel"></asp:Label></td>
                    <th class="border-right">
                        <asp:Label runat="server" ID="lblPhoneNoHeader" Text="휴대전화번호"></asp:Label></th>
                    <td>
                        <asp:Label runat="server" ID="lblPhoneNo"></asp:Label></td>
                </tr>
                <tr>
                    <th class="border-right">
                        <asp:Label runat="server" ID="lblEmailHeader" Text="이메일"></asp:Label></th>
                    <td class="border-right">
                        <asp:Label runat="server" ID="lblEmail"></asp:Label></td>
                    <!--<td><asp:Label runat="server" ID="lblPwdHeader" Text="게시글 비밀번호"></asp:Label></td>
                    <td><asp:Label runat="server" ID="lblPwd"></asp:Label></td>-->
                    <th class="border-right">
                        <asp:Label runat="server" ID="lblQueryGubunHeader" Text="문의구분"></asp:Label></th>
                    <td>
                        <asp:Label runat="server" ID="lblQueryGubun"></asp:Label></td>
                </tr>
                <tr>
                    <th class="border-right">
                        <asp:Label runat="server" ID="lblTitleHeader" Text="제목"></asp:Label></th>
                    <td class="align-left" style="border-bottom: 1px solid #a2a2a2;" colspan="3">
                        <asp:Label runat="server" ID="lblTitle"></asp:Label></td>
                </tr>
                <tr>
                    <td  class="padding-left-ten txt-contents-td align-left" colspan="4">
                        <div id="boardContents" style="width:1256px; overflow-x:auto; overflow-y:hidden">
                            <asp:Label runat="server" ID="lblContext"></asp:Label>
                        </div>
                    </td>
                </tr>
                <tr>
                    <th class="border-right">
                        <asp:Label runat="server" ID="lblFileHeader" Text="첨부파일"></asp:Label>
                    </th>
                    <td class="padding-left-ten" colspan="3" style="text-align:left;">
                        <asp:LinkButton runat="server" ID="lbFileDown" OnClick="lbFileDown_Click"></asp:LinkButton>
                        <asp:HiddenField runat="server" ID="hfFilePath" />
                        <asp:HiddenField runat="server" ID="hfFileName" />
                    </td>
                </tr>
            </table>
        </div>
        <!--사용자가 작성한 문의 영역 끝-->

        <%--<br />--%>

        <!--관리자 답변 영역 시작-->
        <div class="board-view-ans-div">
            <table class="tbl_main">
                <tr>
                    <th class="border-right">처리담당자</th>
                    <td class="border-right" style="width: 150px">
                        <asp:Label runat="server" ID="lblAdmin"></asp:Label></td>
                    <th class="border-right">처리결과</th>
                    <td class="border-right">
                        <asp:Label runat="server" ID="lblStatus"></asp:Label></td>
                    <th class="border-right">처리일자</th>
                    <td style="width: 150px">
                        <asp:Label runat="server" ID="lblReplyDate"></asp:Label></td>
                    <td class="support-width-td">고객센터 : 02-6363-2174</td>
                </tr>
                <tr>
                    <th class="border-right">답변</th>
                    <td class="board-answer-td" colspan="6">
                        <asp:Label runat="server" ID="lblReply"></asp:Label></td>
                </tr>
            </table>
            <div class="left-menu-wrap" id="divLeftMenu">
                <dl>
                    <dt>
                        <strong>고객센터</strong>
                    </dt>
                    <dd>
                        <a href="/Notice/NoticeList.aspx">공지사항</a>
                    </dd>
                    <dd class="active">
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
        <!--관리자 답변 영역 끝-->

        <!--버튼 영역 시작-->
        <div class="bottomBtn" style="text-align: right;">
            <asp:Button ID="btnDelete" runat="server" OnClientClick="return fnDeleteConfirm();" OnClick="btnDelete_Click" Text="삭제" CssClass="mainbtn type1" Width="95" Height="30" />
            <asp:Button ID="btnEdit" runat="server" OnClientClick="return fnGoEdit();" Text="수정" CssClass="mainbtn type1" Width="95" Height="30" />
            <asp:Button ID="btnList" runat="server" OnClientClick="return fnGoList();" Text="목록" CssClass="mainbtn type1" Width="95" Height="30" />

            <%--<asp:Button ID="btnList" runat="server" Text="목록" OnClientClick="return fnGoList();"/>--%>
            <%--             <asp:ImageButton ID="ibtnDelete" runat="server" AlternateText="삭제" ImageUrl="../Images/sub_delete_btn.jpg" OnClientClick="return fnDeleteConfirm()" OnClick="ibtnDelete_Click" />
            <asp:ImageButton ID="ImageButton1" runat="server" AlternateText="수정" ImageUrl="../Images/sub_modify_btn.jpg" OnClientClick="return fnGoEdit();"/>
             <asp:ImageButton ID="BtnList" runat="server" AlternateText="목록" ImageUrl="../Images/sub_list_btn.jpg" OnClientClick="return fnGoList();"/>--%>
        </div>
        <!--버튼 영역 끝-->

    </div>
    <!--1:1문의 게시판 끝-->

</asp:Content>

