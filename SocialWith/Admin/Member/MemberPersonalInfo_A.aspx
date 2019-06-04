<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Master/AdminMasterPage.master" AutoEventWireup="true" CodeFile="MemberPersonalInfo_A.aspx.cs" Inherits="Admin_Member_MemberPersonalInfo_A" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <link href="../Content/Member/member.css" rel="stylesheet" />

    <script type="text/javascript">
        $(document).ready(function () {

            var uId = '<%=uId %>';
            var docCnt = '<%=docCnt %>';
            if (Number(docCnt) > 0) $("#trDocTit").show();
            else $("#trDocTit").hide();

            if (isEmpty(uId)) {
                alert("잘못된 접근입니다.\n관리자 메인 화면으로 이동합니다.");
                this.location.href = "../Default.aspx";
            }

            var lastEmailSelectboxTag = $("#" + '<%=ddlLastEmail.ClientID %>');
            $(lastEmailSelectboxTag).on("change", function () {
                //alert("선택 : " + $(this).val());

                var txtLastEmailTag = $("#" + '<%=txtLastEmail.ClientID %>');
                var selectLastEmail = $(this).val();

                $(txtLastEmailTag).val('');

                if (selectLastEmail == '') {
                    $(txtLastEmailTag).attr("readonly", false);

                } else {
                    $(txtLastEmailTag).attr("readonly", true);
                }


                $(txtLastEmailTag).val('');

                return false;
            });

             $("#tabDefault").on("click",  function () {

                location.href = 'MemberCorpInfo_A.aspx?uId=' +'<%=uId %>'+'&ucode=' + ucode;
            });
            $("#tabPerson").on("click", function () {
                 location.href = 'MemberPersonalInfo_A.aspx?uId=' +'<%=uId %>' +'&ucode=' + ucode;
            });
            $("#tabHistory").on("click", function () {
                 location.href = 'MemberLogInfo_A.aspx?uId=' +'<%=uId %>'+'&ucode=' + ucode;
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

        // 저장 버튼 클릭 시 폼 체크
        function fnFormCheck() {

            var txtName = $("#" + '<%=txtName.ClientID %>').val();
            var txtPos = $("#" + '<%=txtPos.ClientID %>').val();
            var txtEmail_1 = $("#" + '<%=txtFirstEmail.ClientID %>').val();
            var selectEmail_2 = $("#" + '<%=ddlLastEmail.ClientID %>').val();
            var txtEmail_2 = $("#" + '<%=txtLastEmail.ClientID %>').val();
            var txtSelPhone = $("#<%=txtSelPhone.ClientID%>");
            var txtTelPhone = $("#<%=txtTelPhone.ClientID%>");
            var txtFax = $("#<%=txtFax.ClientID%>");

            if (isEmpty(txtName) || ($.trim(txtName).length <= 0)) {
                alert("담당자명을 입력해 주세요.");
                return false;
            }
            if (isEmpty(txtPos) || ($.trim(txtPos).length <= 0)) {
                alert("직책을 입력해 주세요.");
                return false;
            }
            if ((isEmpty(txtEmail_1) || ($.trim(txtEmail_1).length <= 0)) || ((isEmpty(txtEmail_2) || ($.trim(txtEmail_2).length <= 0)) && isEmpty(selectEmail_2))) {
                alert("이메일을 입력해 주세요.");
                return false;
            }
            if (isEmpty($.trim(txtSelPhone.val()))) {
                alert("휴대전화번호를 입력해 주세요.");
                return false;
            }
        }

    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">

    <div class="all">
        <div class="sub-contents-div">
           <div class="sub-title-div">
                <p class="p-title-mainsentence">
                    회원정보(판매사)
                    <span class="span-title-subsentence"></span>
                </p>
            </div>

            <!--탭메뉴-->
            <div id="divTab" class="div-main-tab" style="width: 100%; ">
                <ul>
                    <li class='tabOff' style="width: 185px;">
                        <a id="tabDefault">회사기본정보</a>
                     </li>
                    <li class='tabOn' style="width: 185px;">
                         <a id="tabPerson">개인정보</a>
                    </li>
                    <li class='tabOff' style="width: 185px;" >
                        <a id="tabHistory">활동정보</a>
                    </li>
                </ul>
            </div>
            <div class="memberB-div" style="margin-top:30px">
                <table class="tbl_main">
                    <colgroup>
                        <col style="width: 200px;" />
                        <col style="width: 800px" />
                    </colgroup>
                    <tr>
                        <th>가입일</th>
                        <td>
                            <asp:Label runat="server" ID="lblEntryDate" Width="245px" CssClass="text-readonly"></asp:Label></td>
                    </tr>
                    <tr>
                        <th>아이디</th>
                        <td>
                            <asp:Label runat="server" ID="lblUserId" Width="245px" CssClass="text-readonly"></asp:Label>

                            <asp:HiddenField runat="server" ID="hfSvidUser" />
                            <asp:HiddenField runat="server" ID="hfGubun" />
                        </td>
                    </tr>
                    <tr>
                        <th>기관명</th>
                        <td>
                            <asp:Label ID="lblCompName" runat="server" Text="" CssClass="text-readonly" Width="245px"></asp:Label></td>
                    </tr>
                    <tr>
                        <th>사업자번호</th>
                        <td>
                            <asp:Label ID="lblFirstNum" runat="server" Width="70" CssClass="text-readonly"></asp:Label>
                            <asp:Label runat="server" Text="&nbsp;-&nbsp;" CssClass="hyphen"></asp:Label>
                            <asp:Label ID="lblMiddleNum" runat="server" Width="70" CssClass="text-readonly"></asp:Label>
                            <asp:Label runat="server" Text="&nbsp;-&nbsp;" CssClass="hyphen"></asp:Label>
                            <asp:Label ID="lblLastNum" runat="server" Width="70" CssClass="text-readonly"></asp:Label></td>
                    </tr>
                    <tr>
                        <th>대표자명</th>
                        <td>
                            <asp:Label ID="lblDelegateName" runat="server" Text="" CssClass="text-readonly" Width="245px"></asp:Label></td>
                    </tr>
                    <tr>
                        <th rowspan="3">주소</th>
                        <td>
                            <asp:Label ID="lblZipCode" runat="server" Text="" Width="100px" CssClass="text-readonly"></asp:Label></td>
                    </tr>
                    <tr>
                        <td><asp:Label ID="lblAddr1" runat="server" Text="" Width="600px" CssClass="text-readonly"></asp:Label></td>
                    </tr>
                    <tr>
                        <td><asp:Label ID="lblAddr2" runat="server" Text="" Width="500px" CssClass="text-readonly"></asp:Label></td>
                    </tr>
                    <tr>
                        <th>담당자명</th>
                        <td>
                            <asp:TextBox ID="txtName" runat="server" CssClass="text-input" Width="245px"></asp:TextBox></td>
                    </tr>
                    <tr>
                        <th>부서명</th>
                        <td>
                            <asp:Label ID="lblDept" runat="server" Text="" CssClass="text-readonly" Width="245px"></asp:Label></td>
                    </tr>
                    <tr>
                        <th>직책</th>
                        <td>
                            <asp:TextBox ID="txtPos" runat="server" CssClass="text-input" Width="245px"></asp:TextBox></td>
                    </tr>
                    <tr>
                        <th>이메일</th>
                        <td>
                            <asp:TextBox ID="txtFirstEmail" runat="server" CssClass="text-input" Width="100"></asp:TextBox>&nbsp;@&nbsp;<asp:TextBox ID="txtLastEmail" runat="server" CssClass="text-input" Width="117"></asp:TextBox>
                            <asp:DropDownList ID="ddlLastEmail" runat="server" CssClass="drop-email">
                                <asp:ListItem Value="" Text="-------직접입력------"></asp:ListItem>
                                <asp:ListItem Value="hanmail.net" Text="hanmail.net"></asp:ListItem>
                                <asp:ListItem Value="naver.com" Text="naver.com"></asp:ListItem>
                                <asp:ListItem Value="hotmail.com" Text="hotmail.com"></asp:ListItem>
                                <asp:ListItem Value="nate.com" Text="nate.com"></asp:ListItem>
                                <asp:ListItem Value="yahoo.co.kr" Text="yahoo.co.kr"></asp:ListItem>
                                <asp:ListItem Value="empas.com" Text="empas.com"></asp:ListItem>
                                <asp:ListItem Value="dreamwiz.com" Text="dreamwiz.com"></asp:ListItem>
                                <asp:ListItem Value="freechal.com" Text="freechal.com"></asp:ListItem>
                                <asp:ListItem Value="lycos.co.kr" Text="lycos.co.kr"></asp:ListItem>
                                <asp:ListItem Value="korea.com" Text="korea.com"></asp:ListItem>
                                <asp:ListItem Value="gmail.com" Text="gmail.com"></asp:ListItem>
                                <asp:ListItem Value="hanmir.com" Text="hanmir.com"></asp:ListItem>
                                <asp:ListItem Value="paran.com" Text="paran.com"></asp:ListItem>
                                <asp:ListItem Value="netsgo.com" Text="netsgo.com"></asp:ListItem>
                            </asp:DropDownList>
                        </td>
                    </tr>
                    <tr>
                        <th>휴대전화번호</th>
                        <td>
                            <asp:TextBox ID="txtSelPhone" runat="server" Width="127px" MaxLength="12" onkeypress="return onlyNumbers(event);" CssClass="text-input"></asp:TextBox>
                            <label style="margin-left:5px; font-weight:normal;">'-' 없이 입력해 주세요.</label>
                        </td>
                    </tr>
                    <tr>
                        <th>유선전화번호</th>
                        <td>
                            <asp:TextBox ID="txtTelPhone" runat="server" Width="127px" MaxLength="12" onkeypress="return onlyNumbers(event);" CssClass="text-readonly"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <th>FAX번호</th>
                        <td>
                            <asp:TextBox ID="txtFax" runat="server" Width="127px" MaxLength="12" onkeypress="return onlyNumbers(event);" CssClass="text-readonly"></asp:TextBox>
                        </td>
                    </tr>

                    <tr id="trDocTit">
                        <th colspan="2"><h5>▶&nbsp;&nbsp;문서정보</h5></th>
                    </tr>

                    <asp:ListView runat="server" ID="lvDocList" OnItemCommand="lvDocList_ItemCommand">
                        <ItemTemplate>

                            <tr>
                                <th>
                                    <%# Eval("Map_Name").ToString()%>
                                </th>
                                <td>
                                    <asp:LinkButton runat="server" ID="lbAttachFileName" Text='<%# Eval("AttachFile.Attach_P_Name").ToString()%>' CommandName="download" CommandArgument='<%# Eval("AttachFile.Attach_Path").ToString()%>'></asp:LinkButton>
                                </td>
                            </tr>
                        </ItemTemplate>
                    </asp:ListView>

                    <%--<tr>
                        <th>증빙서류1</th>
                        <td>
                            <asp:Label runat="server" Width="600px" CssClass="text-readonly"></asp:Label></td>
                    </tr>
                    <tr>
                        <th>증빙서류2</th>
                        <td>
                            <asp:Label runat="server" Width="600px" CssClass="text-readonly"></asp:Label></td>
                    </tr>
                    <tr>
                        <th>증빙서류3</th>
                        <td>
                            <asp:Label runat="server" Width="600px" CssClass="text-readonly"></asp:Label></td>
                    </tr>--%>
                    <tr>
                        <td></td>
                        <td></td>
                    </tr>

                </table>

            </div>
            <!--저장버튼-->
            <div class="bt-align-div">
                <input type="button" class="mainbtn type1" style="width:75px;" value="목록" onclick="location.href = 'MemberMain_A.aspx?ucode=' + ucode; return false;">
                <input type="button" id="btnSave" class="mainbtn type1" style="width:75px;" value="저장" onclick="fnFormCheck()">
                <%--<asp:ImageButton runat="server" OnClientClick="location.href='MemberMain_A.aspx'; return false;" ImageUrl="../Images/Member/list-off.jpg" AlternateText="목록" onmouseover="this.src='../Images/Member/list-on.jpg'" onmouseout="this.src='../Images/Member/list-off.jpg'" alt="목록" CssClass="search-img"/>--%>
                <%--<asp:ImageButton runat="server" ID="btnSave" ImageUrl="../Images/Member/save.jpg" OnClientClick="return fnFormCheck();" OnClick="btnSave_Click" AlternateText="저장" onmouseover="this.src='../Images/Member/save-on.jpg'" onmouseout="this.src='../Images/Member/save.jpg'" />--%>
            </div>
            <!--저장버튼끝-->

        </div>
    </div>

</asp:Content>

