<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Master/AdminMasterPage.master" AutoEventWireup="true" CodeFile="Board_B_View_Test.aspx.cs" Inherits="Test_Board_Board_B_View_Test" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <script src="//developers.kakao.com/sdk/js/kakao.min.js"></script>
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
                        <asp:Label runat="server" ID="lblContext"></asp:Label>
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
            <asp:Button ID="btnSave" runat="server" Width="95" Height="30" Text="저장" OnClick="btnSave_Click" OnClientClick="sendLink();" CssClass="mainbtn type1" />
            <input type="button" class="mainbtn type1" style="width: 95px; height: 30px;" value="목록" onclick="location.href = 'Board_B_Test.aspx?ucode=' + ucode; return false;" />
        </div>
        <!--버튼 영역 끝-->

    </div>
    <!--1:1문의 게시판 끝-->

    <script type='text/javascript'>
        // // 사용할 앱의 JavaScript 키를 설정해 주세요.
        Kakao.init('5b831352cc26bbadaee65f375a3b5def');
        // // 카카오링크 버튼을 생성합니다. 처음 한번만 호출하면 됩니다.
        function sendLink() {
            var admin = $('#ContentPlaceHolder1_lblAdmin').text();
            var resultStatus = $('#ContentPlaceHolder1_ddlResultStatus').val();
            var answer = $('#ContentPlaceHolder1_txtReply').val();
            var adSt = admin + " / " + resultStatus;

            Kakao.Link.sendDefault({
                objectType: 'location',
                address: '서울 구로구 디지털로30길 28 3층',
                addressTitle: '주식회사 소셜공감',
                content: {
                    title: adSt,
                    description: answer,
                    imageUrl: 'http://mud-kage.kakao.co.kr/dn/bSbH9w/btqgegaEDfW/vD9KKV0hEintg6bZT4v4WK/kakaolink40_original.png',
                    link: {
                        mobileWebUrl: 'https://developers.kakao.com',
                        webUrl: 'https://developers.kakao.com'
                    }
                },
                social: {
                    likeCount: 286,
                    commentCount: 45,
                    sharedCount: 845
                },
                buttons: [
                    {
                        title: '웹으로 보기',
                        link: {
                            mobileWebUrl: 'https://developers.kakao.com',
                            webUrl: 'https://developers.kakao.com'
                        }
                    }
                ]
            });
        }
    </script>
</asp:Content>

