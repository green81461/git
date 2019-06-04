<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Master/AdminMasterPage.master" AutoEventWireup="true" CodeFile="Board_B_View.aspx.cs" Inherits="Admin_Board_Board_B_View" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <script>
        $(function () {

            // 업로드된 파일이 이미지파일일 때 이미지 표시해주기
            var name = $('#ContentPlaceHolder1_lbFileDown').html();
            var path = '../../UploadFile' + $('#ContentPlaceHolder1_hfFilePath').val().replace(/\\/g, '/');
            var src = path + name;

            name = name.slice(name.indexOf(".") + 1).toLowerCase();

            if (name == "jpg" || name == "png" || name == "gif" || name == "bmp" || name == "psd" || name == "ai") {
                $('#boardContents').prepend('<img src="' + src + '">');
            }

        });
    </script>
    <!--1:1문의 게시판 시작-->
    <div class="sub-contents-div">
        <div class="sub-title-div">
            <p class="p-title-mainsentence">
                1대1문의
                    <span class="span-title-subsentence"></span>
            </p>
        </div>
        <!--사용자가 작성한 문의 영역 시작-->
        <div class="board-view-div" style="padding-top: 30px">
            <table class="tbl_main">
                <tr>
                    <th>
                        <asp:Label runat="server" ID="lblCompanyNmHeader" Text="회사/기관명"></asp:Label></th>
                    <td class="padding-left-ten">
                        <asp:Label runat="server" ID="lblCompanyNm"></asp:Label></td>
                    <th>
                        <asp:Label runat="server" ID="lblWriteHeader" Text="작성자"></asp:Label></th>
                    <td class="padding-left-ten">
                        <asp:Label runat="server" ID="lblWrite"></asp:Label></td>
                </tr>
                <tr>
                    <th>
                        <asp:Label runat="server" ID="lblTelHeader" Text="전화번호"></asp:Label></th>
                    <td class="padding-left-ten">
                        <asp:Label runat="server" ID="lblTel"></asp:Label></td>
                    <th>
                        <asp:Label runat="server" ID="lblPhoneNoHeader" Text="휴대전화번호"></asp:Label></th>
                    <td class="padding-left-ten">
                        <asp:Label runat="server" ID="lblPhoneNo"></asp:Label></td>
                </tr>
                <tr>
                    <th>
                        <asp:Label runat="server" ID="lblEmailHeader" Text="이메일"></asp:Label></th>
                    <td class="padding-left-ten">
                        <asp:Label runat="server" ID="lblEmail"></asp:Label></td>
                    <!--<td><asp:Label runat="server" ID="lblPwdHeader" Text="게시글 비밀번호"></asp:Label></td>
                    <td><asp:Label runat="server" ID="lblPwd"></asp:Label></td>-->
                    <th>
                        <asp:Label runat="server" ID="lblQueryGubunHeader" Text="문의구분"></asp:Label></th>
                    <td class="padding-left-ten">
                        <asp:Label runat="server" ID="lblQueryGubun"></asp:Label></td>
                </tr>
                <tr style="border: 1px solid #a2a2a2">
                    <th>
                        <asp:Label runat="server" ID="lblTitleHeader" Text="제목"></asp:Label></th>
                    <td class="padding-left-ten" colspan="3">
                        <asp:Label runat="server" ID="lblTitle"></asp:Label></td>
                </tr>
                <tr>
                    <td class="padding-left-ten txt-contents-td" colspan="4">
                        <div id="boardContents" style="width: 1256px; overflow-x: auto; overflow-y: hidden">
                            <asp:Label runat="server" ID="lblContext"></asp:Label>
                        </div>
                    </td>
                </tr>
                <tr>
                    <th>
                        <asp:Label runat="server" ID="lblFileHeader" Text="첨부파일"></asp:Label>

                    </th>
                    <td class="padding-left-ten" colspan="3">
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
            <asp:HiddenField runat="server" ID="hdSvidBoardResult" />
            <table class="tbl_main">
                <tr style="border: 1px solid #a2a2a2">
                    <th>처리담당자</th>
                    <td class="txt-center" style="width: 150px">
                        <asp:Label runat="server" ID="lblAdmin"></asp:Label></td>
                    <th>처리결과</th>
                    <td class="txt-center">
                        <asp:DropDownList runat="server" ID="ddlResultStatus" Width="95%" Height="24px">
                            <asp:ListItem Text="진행중" Value="N"></asp:ListItem>
                            <asp:ListItem Text="답변완료" Value="Y"></asp:ListItem>
                        </asp:DropDownList>
                    </td>
                    <th>처리일자</th>
                    <td class="txt-center" style="width: 150px">
                        <asp:Label runat="server" ID="lblResultEntryDate"></asp:Label></td>
                    <td class="support-width-td">고객센터 : 02-6363-2174</td>
                </tr>
                <tr>
                    <th>답변</th>
                    <td class="board-answer-td" colspan="6">
                        <asp:TextBox runat="server" ID="txtReply" Rows="5" TextMode="MultiLine" Width="100%" Height="100%" CssClass="txtBox"></asp:TextBox>
                    </td>
                </tr>
            </table>
        </div>
        <!--관리자 답변 영역 끝-->

        <!--버튼 영역 시작-->
        <div class="bottomBtn" style="text-align: right;">
            <asp:Button ID="btnSave" runat="server" Width="95" Height="30" Text="저장" OnClick="btnSave_Click" CssClass="mainbtn type1" />
            <input type="button" class="mainbtn type1" style="width: 95px; height: 30px;" value="목록" onclick="location.href = 'Board_B.aspx?ucode=' + ucode; return false;" />
        </div>
        <!--버튼 영역 끝-->

    </div>
    <!--1:1문의 게시판 끝-->
</asp:Content>

