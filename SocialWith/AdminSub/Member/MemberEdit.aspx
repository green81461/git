<%@ Page Title="" Language="C#" MasterPageFile="~/AdminSub/Master/AdminSubMaster.master" AutoEventWireup="true" CodeFile="MemberEdit.aspx.cs" Inherits="AdminSub_Member_MemberEdit" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">

    <link rel="stylesheet" href="../../Content/member.css">
    <script type="text/javascript">
        $(document).ready(function () {
            var txtPwd = $("#<%=txtPwd.ClientID%>");
            var txtPwd_ch = $("#<%=txtPwd_ch.ClientID%>");
            var checkText = $('#spanChPwd');
            var txtLastEmail = $("#<%=txtLastEmail.ClientID %>");
            var dropDownListEmail = $("#<%=dropDownListEmail.ClientID %>");

            //패스워드 창 클리어
            txtPwd.keyup(function () {
                checkText.text('');
            });

            //패스워드와 패스워드 확인 일치 문구 
            txtPwd_ch.keyup(function () {
                if (txtPwd.val() != txtPwd_ch.val()) {
                    checkText.text('');
                    checkText.html("&nbsp;&nbsp;&nbsp;* 비밀번호가 일치하지 않습니다.");
                    checkText.css("font-weight", "bold");
                    checkText.css("color", "#ec2029");

                } else {
                    checkText.text('');
                    checkText.html("&nbsp;&nbsp;&nbsp;* 비밀번호가 일치합니다.");
                    checkText.css("font-weight", "bold");
                    checkText.css("color", "#ec2029");
                }
            });

            //이메일 선택
            dropDownListEmail.change(function () {
                var selectedVal = $('#<%=dropDownListEmail.ClientID %> option:selected').val();
                if (selectedVal == 'direct') {
                    txtLastEmail.val('');
                }
                else {
                    txtLastEmail.val(selectedVal);
                }
            });
        });

        function fnValidation() {
            var txtPwd = $("#<%=txtPwd.ClientID%>");
            var txtPwd_ch = $("#<%=txtPwd_ch.ClientID%>");
            var txtChargeName = $("#<%=txtPerson.ClientID%>");
            var txtPostion = $("#<%=txtPos.ClientID%>");
            var txtFirstEmail = $("#<%=txtFirstEmail.ClientID %>");
            var txtLastEmail = $("#<%=txtLastEmail.ClientID %>");
            var txtSelPhone = $("#<%=txtSelPhone.ClientID%>");
            var txtTelNo = $("#<%=txtTelNo.ClientID%>");
            var txtFaxNo = $("#<%=txtFaxNo.ClientID%>");

            if (txtPwd.val() == '') {
                alert('비밀번호를 입력해주세요.');
                txtPwd.focus();
                return false;
            }
            if (!/^[a-zA-Z0-9]{6,15}$/.test(txtPwd.val())) {
                alert('비밀번호는 숫자와 영문 조합으로 6자리 이상 사용해야 합니다.');
                txtPwd.focus();
                return false;
            }
            if (txtPwd_ch.val() == '') {
                alert('비밀번호확인을 입력해주세요.');
                txtPwd_ch.focus();
                return false;
            }

            if (txtChargeName.val() == '') {
                alert('담당자명을 입력해주세요.');
                txtPwd.focus()
                return false;
            }

            if (txtPostion.val() == '') {
                alert('직책을 입력해주세요.');
                txtPostion.focus()
                return false;
            }

            if (txtFirstEmail.val() == '' || txtLastEmail.val() == '') {
                alert('E-Mail을 입력해주세요.');
                txtFirstEmail.focus()
                return false;
            }

            var regeMail = /^([\w-]+(?:\.[\w-]+)*)@((?:[\w-]+\.)*\w[\w-]{0,66})\.([a-z]{2,6}(?:\.[a-z]{2})?)$/;
            if (!regeMail.test((txtFirstEmail.val() + '@' + txtLastEmail.val()))) {
                alert("잘못된 이메일 형식입니다.");
                txtFirstEmail.focus();
                return false;
            }
            if (isEmpty($.trim(txtSelPhone.val()))) {
                alert('휴대전화번호를 입력해 주세요.');
                txtSelPhone.focus()
                return false;
            }
            if (isEmpty($.trim(txtTelNo.val())) || ($.trim(txtTelNo.val()).length < 9)) {
                alert("유선전화 번호를 입력해 주세요.");
                txtTelNo.focus()
                return false;
            }
            if (isEmpty($.trim(txtFaxNo.val())) || ($.trim(txtFaxNo.val()).length < 9)) {
                alert('Fax 번호를 입력해 주세요.');
                txtFaxNo.focus()
                return false;
            }

            if (!confirm("저장하겠습니까?")) {
                return false;
            }
            return true;
        }

        function fnCancelEdit() {
            if (confirm('취소하시겠습니까?')) {
                location.href = '../Default.aspx';
                
            }
            return false;
        }


    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div class="all">
        <div class="sub-contents-div">

            <%--<div class="sub-title-div"><img src="../images/Member/changeInfo_Title.jpg"/></div>--%>
            <!--제목 타이틀-->
            <div class="sub-title-div">
                <p class="p-title-mainsentence">
                    회원정보변경
                    <span class="span-title-subsentence">고객님의 소중한 정보를 보호합니다.</span>
                </p>
            </div>
            <div style="height:30px;"></div>

            <span class="mini-title">
                <img src="../../images/insertInfo.jpg" /></span>
            <div class="table-div1">

                <table class="member-table">
                    <colgroup>
                        <col style="width: 200px;" />
                        <col style="width: 800px" />
                    </colgroup>
                    <thead>
                    </thead>
                    <tbody>
                        <tr>
                            <td style="text-align: left; font-weight: bold">
                                <asp:Label runat="server" Text="*&nbsp;&nbsp;&nbsp;아이디"></asp:Label></td>
                            <td>
                                <asp:Label ID="lblId" runat="server" Text="" Style="padding-left: 5px;"></asp:Label></td>
                        </tr>
                        <tr>
                            <td style="text-align: left; font-weight: bold">
                                <asp:Label runat="server" Text="*&nbsp;&nbsp;&nbsp;비밀번호" TextMode="Password"></asp:Label></td>
                            <td>
                                <asp:TextBox ID="txtPwd" runat="server" TextMode="Password" CssClass="text-input" Width="235px" onkeypress="return preventEnter(event);"></asp:TextBox><span id="spanPwd">&nbsp;&nbsp;＊영문/숫자 혼합으로 최소 6자 이상 입력하셔야 합니다.</span></td>
                        </tr>
                        <tr>
                            <td style="text-align: left; font-weight: bold">
                                <asp:Label runat="server" Text="*&nbsp;&nbsp;&nbsp;비밀번호확인" TextMode="Password"></asp:Label></td>
                            <td>
                                <asp:TextBox ID="txtPwd_ch" runat="server" TextMode="Password" CssClass="text-input" Width="235px" onkeypress="return preventEnter(event);"></asp:TextBox><span id="spanChPwd"></span></td>
                        </tr>
                        <tr>
                            <td>&nbsp;</td>
                        </tr>
                        <tr>
                            <td style="text-align: left; font-weight: bold">
                                <asp:Label runat="server" Text="*&nbsp;&nbsp;&nbsp;기관명"></asp:Label></td>
                            <td>
                                <asp:Label ID="lblOrgName" runat="server" Text="" CssClass="text-readonly" Width="242px"></asp:Label></td>
                        </tr>
                        <tr>
                            <td style="text-align: left; font-weight: bold">
                                <asp:Label runat="server" Text="*&nbsp;&nbsp;&nbsp;사업자번호"></asp:Label></td>
                            <td>
                                <asp:Label ID="lblFirstNum" runat="server" Width="70" CssClass="text-readonly"></asp:Label>&nbsp;-&nbsp;&nbsp;<asp:Label ID="lblMiddleNum" runat="server" Width="70" CssClass="text-readonly"></asp:Label>&nbsp;-&nbsp;<asp:Label ID="lblLastNum" runat="server" Width="70" CssClass="text-readonly"></asp:Label></td>
                        </tr>
                        <tr>
                            <td style="text-align: left; font-weight: bold">
                                <asp:Label runat="server" Text="*&nbsp;&nbsp;&nbsp;대표자명"></asp:Label></td>
                            <td>
                                <asp:Label ID="lblName" runat="server" Text="" CssClass="text-readonly" Width="242px"></asp:Label></td>
                        </tr>
                        <tr>
                            <td style="text-align: left; font-weight: bold">
                                <asp:Label runat="server" Text="*&nbsp;&nbsp;&nbsp;주소"></asp:Label></td>
                            <td>
                                <asp:Label ID="lblFirstAddr" runat="server" Text="" Width="100px" CssClass="text-readonly"></asp:Label></td>
                        </tr>
                        <tr>
                            <td></td>
                            <td>
                                <asp:Label ID="lblAddr2" runat="server" Text="" Width="500px" CssClass="text-readonly"></asp:Label>
                                <asp:Label ID="lblAddr3" runat="server" Text="" Width="500px" CssClass="text-readonly"></asp:Label></td>
                        </tr>
                        <tr>
                            <td>&nbsp;</td>
                        </tr>
                        <tr>
                            <td style="text-align: left; font-weight: bold">
                                <asp:Label runat="server" Text="*&nbsp;&nbsp;&nbsp;담당자명"></asp:Label></td>
                            <td>
                                <asp:TextBox ID="txtPerson" runat="server" CssClass="text-input" Width="235px" onkeypress="return preventEnter(event);"></asp:TextBox></td>
                        </tr>
                        <tr>
                            <td style="text-align: left; font-weight: bold">
                                <asp:Label runat="server" Text="*&nbsp;&nbsp;&nbsp;부서명"></asp:Label></td>
                            <td>
                                <asp:Label ID="lblDept" runat="server" Text="" CssClass="text-readonly" Width="235px"></asp:Label></td>
                        </tr>
                        <tr>
                            <td style="text-align: left; font-weight: bold">
                                <asp:Label runat="server" Text="*&nbsp;&nbsp;&nbsp;직책"></asp:Label></td>
                            <td>
                                <asp:TextBox ID="txtPos" runat="server" CssClass="text-input" Width="235px" onkeypress="return preventEnter(event);"></asp:TextBox></td>
                        </tr>
                        <tr>
                            <td style="text-align: left; font-weight: bold">
                                <asp:Label runat="server" Text="*&nbsp;&nbsp;&nbsp;이메일"></asp:Label></td>
                            <td>
                                <asp:TextBox ID="txtFirstEmail" runat="server" CssClass="text-input" Width="100" onkeypress="return preventEnter(event);"></asp:TextBox>&nbsp;@&nbsp;<asp:TextBox ID="txtLastEmail" runat="server" CssClass="text-input" Width="117" onkeypress="return preventEnter(event);"></asp:TextBox>
                                <asp:DropDownList ID="dropDownListEmail" runat="server" CssClass="drop-email">
                                    <asp:ListItem Value="direct" Text="-----직접입력------"></asp:ListItem>
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
                            <td style="text-align: left; font-weight: bold">
                                <asp:Label runat="server" Text="*&nbsp;&nbsp;&nbsp;휴대전화번호"></asp:Label></td>
                            <td>
                                <asp:TextBox ID="txtSelPhone" runat="server" Width="100px" MaxLength="12" onkeypress="return onlyNumbers(event);" CssClass="text-input"></asp:TextBox>
                                <label style="margin-left: 5px; font-weight: normal;">'-' 없이 입력해 주세요.</label>
                            </td>
                        </tr>
                        <tr>
                            <td style="text-align: left; font-weight: bold">
                                <asp:Label runat="server" Text="*&nbsp;&nbsp;&nbsp;유선전화번호"></asp:Label></td>
                            <td>
                                <%--<asp:Label ID="lblTelNo" runat="server" Width="100px" CssClass="text-readonly"></asp:Label>--%>
                                <asp:TextBox ID="txtTelNo" runat="server" CssClass="text-input" Width="100px" MaxLength="12" onkeypress="return onlyNumbers(event);"></asp:TextBox>
                                <label style="margin-left:5px; font-weight:normal;">'-' 없이 입력해 주세요.</label>
                            </td>
                        </tr>
                        <tr>
                            <td style="text-align: left; font-weight: bold">
                                <asp:Label runat="server" Text="*&nbsp;&nbsp;&nbsp;Fax번호"></asp:Label></td>
                            <td>
                                <%--<asp:Label ID="lblFaxNo" runat="server" Width="100px" CssClass="text-readonly"></asp:Label>--%>
                                <asp:TextBox ID="txtFaxNo" runat="server" CssClass="text-input" Width="100px" MaxLength="12" onkeypress="return onlyNumbers(event);"></asp:TextBox>
                                <label style="margin-left:5px; font-weight:normal;">'-' 없이 입력해 주세요.</label>
                            </td>
                        </tr>
                        <tr>
                            <td style="height: 50px; vertical-align: bottom;"><span class="check">(선택사항)</span></td>
                        </tr>
                        <tr>
                            <td colspan="2">이벤트/쇼핑혜택 SMS 수신동의&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                <asp:RadioButton ID="rbSMSAlllowY" runat="server" GroupName="rbSMS" Text="&nbsp;Y" onkeypress="return preventEnter(event);" />&nbsp;&nbsp;
                                <asp:RadioButton ID="rbSMSAlllowN" runat="server" GroupName="rbSMS" Text="&nbsp;N" onkeypress="return preventEnter(event);" />
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2">이벤트/쇼핑혜택 이메일 수신동의&nbsp;&nbsp;&nbsp;
                                <asp:RadioButton ID="rbEmailAlllowY" runat="server" GroupName="rbEmail" Text="&nbsp;Y" onkeypress="return preventEnter(event);" />&nbsp;&nbsp;
                                <asp:RadioButton ID="rbEmailAlllowN" runat="server" GroupName="rbEmail" Text="&nbsp;N" onkeypress="return preventEnter(event);" />
                            </td>
                        </tr>
                        <tr></tr>
                        <tr></tr>
                    </tbody>
                </table>

            </div>
            <div class="adminsub-bottomBtn">
                <asp:Button id="btnCancel" runat="server" Text="취소" CssClass="mainbtn type1" Width="95" Height="30" OnClientClick="return fnCancelEdit();"/>
                <asp:Button id="btnOk" runat="server" Text="변경완료" CssClass="mainbtn type1" Width="95" Height="30" OnClick="btnOk_Click" OnClientClick="return fnValidation();"/>

<%--                <asp:ImageButton ID="btnCancel" runat="server" Text="취소" OnClientClick="return fnCancelEdit();" src="../../images/cancle_btn.jpg" onmouseover="this.src='../../Images/member/cancle-btn.jpg'" onmouseout="this.src='../../images/cancle_btn.jpg'" />
                <asp:ImageButton ID="btnOk" runat="server" Text="변경완료" OnClick="btnOk_Click" OnClientClick="return fnValidation();" src="../../Images/member/completed-btn.jpg" onmouseover="this.src='../../images/change-btn.jpg'" onmouseout="this.src='../../Images/member/completed-btn.jpg'" />--%>
            </div>

        </div>
    </div>
</asp:Content>

