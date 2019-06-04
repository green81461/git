<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Master/AdminMasterPage.master" AutoEventWireup="true" CodeFile="MemberLogInfo_B.aspx.cs" Inherits="Admin_Member_MemberLogInfo_B" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <link href="../Content/Member/member.css" rel="stylesheet" />

    <script type="text/javascript">
        $(document).ready(function () {

            var uId = '<%=uId %>';

            if (isEmpty(uId)) {
                alert("잘못된 접근입니다.\n관리자 메인 화면으로 이동합니다.");
                this.location.href = "../Default.aspx";
            }

            $("#tabDefault").on("click",  function () {

                location.href = 'MemberCorpInfo_B.aspx?uId=' +'<%=uId %>'+'&ucode=' + ucode;
            });
            $("#tabPerson").on("click", function () {
                 location.href = 'MemberPersonalInfo_B.aspx?uId=' +'<%=uId %>' +'&ucode=' + ucode;
            });
            $("#tabHistory").on("click", function () {
                 location.href = 'MemberLogInfo_B.aspx?uId=' +'<%=uId %>'+'&ucode=' + ucode;
            });
        });

        // enter key 방지
        $(document).on("keypress", "input, span", function (e) {
            if (e.keyCode == 13) {
                return false;
            }
            else
                return true;
        });
    </script>

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <div class="all">
    <div class="sub-contents-div">
    <!--회원정보-개인정보-->
    <div class="sub-title-div">
        <p class="p-title-mainsentence">
            회원정보(구매사)
            <span class="span-title-subsentence"></span>
        </p>
    </div>
    
<!--탭메뉴-->
            <div id="divTab" class="div-main-tab" style="width: 100%;">
                <ul>
                    <li class='tabOff' style="width: 185px;">
                        <a id="tabDefault">회사기본정보</a>
                     </li>
                    <li class='tabOff' style="width: 185px;">
                         <a id="tabPerson">개인정보</a>
                    </li>
                    <li class='tabOn' style="width: 185px;" >
                        <a id="tabHistory">활동정보</a>
                    </li>
                </ul>
            </div>

        <div class="memberB-div" style="margin-top:30px">
            <table class="tbl_main">
                <tr>
                    <th>최근로그인</th>
                    <td><asp:Label runat="server" ID="lblLoginDate" Width="245px" CssClass="text-readonly"></asp:Label></td>
                    <th>최근수정일</th>
                    <td><asp:Label runat="server" ID="lblUpdateDate" Width="245px" CssClass="text-readonly"></asp:Label></td>
                </tr>
                <tr>
                    <th>포인트(적립금)</th>
                    <td></td>
                    <th>보유쿠폰</th>
                    <td ></td>
                </tr>
                <tr>
                    <th>방문횟수(월)</th>
                    <td><asp:Label runat="server" ID="lblLoginCnt" Width="245px" CssClass="text-readonly"></asp:Label></td>
                    <th>주문횟수(월)</th>
                    <td></td>
                </tr>
                <tr>
                    <th>1:1문의횟수</th>
                    <td></td>
                    <td colspan="2"></td>
                </tr>
            </table>
        </div>
        <!--저장버튼-->
            <div class="btn_center">
                <input type="submit" value="목록" class="mainbtn type1" style="width:75px" onclick="Unnamed_Click">
            </div>
            <!--저장버튼끝-->
    </div>
</div>
</asp:Content>

