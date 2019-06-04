<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Login.aspx.cs" Inherits="Admin_Login" %>

<!DOCTYPE html>
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <link rel="stylesheet" type="text/css" href="Contents/login.css" />
    <script type="text/javascript" src="../../Scripts/jquery-1.10.2.min.js"></script>
    <title></title>
    <script type="text/javascript">
        $(function () {
            var bannerCookie = fnGetCookie("bannerYN");

            if (bannerCookie != null && bannerCookie != '') {
                $('#<%= hfBannerYN.ClientID%>').val('Y');
            }
            else {
                $('#<%= hfBannerYN.ClientID%>').val('N');
            }
        })


        function fnEnter() {

            if (event.keyCode == 13) {
                <%=Page.GetPostBackEventReference(btnLogin)%>
                return false;
            }
            else
                return true;
        }
        function fnPageRedirect(type) {
            if (type == 'search') {

                location.href = 'MemberIdPwSch.aspx'
            }
            else if (type == 'join') {
               fnGoMemberJoinPage();
            }

            return false;
        }
        

        function fnLoginValidation() {
            var txtLoginId = $('#<%= txtLoginId.ClientID%>');
            var txtPwd = $('#<%= txtPwd.ClientID%>');

            if (txtLoginId.val() == '') {
                alert('아이디를 입력해 주세요.');
                txtLoginId.focus();
                return false;
            }

            if (txtPwd.val() == '') {
                alert('비밀번호를 입력해 주세요.');
                txtPwd.focus();
                return false;
            }
        }
    </script>
</head>
<body>  
    <form id="form1" runat="server">
        <asp:HiddenField runat="server" ID="hfBannerYN" />
        <div class="container">
             <h2>관리자 페이지</h2>
            <div class="main">
                <div class="border">
                   <div class="login_text" style="position: relative">
                       <span><asp:Image runat="server" Style="vertical-align: middle;" ID="imgLoginLogo" /></span>
                        <span class="admin_title">아이디</span>
                        <span><asp:TextBox runat="server" ID="txtLoginId" Class="login_txt" placeholder="아이디"></asp:TextBox></span>
                        <span class="admin_title">패스워드</span>
                        <span>
                           <asp:TextBox runat="server" ID="txtPwd" CssClass="login_txt" TextMode="Password" placeholder="패스워드"  Onkeypress="return fnEnter();" /></span>
                        <span class="loginw">
                           <asp:CheckBox runat="server" ID="ckbSaveId" Text="&nbsp;아이디 저장" CssClass="w" />
                        </span>
                        <asp:Button runat="server" ID="btnLogin" OnClick="btnLogin_Click" Text="로그인" CssClass="login_btn login-sitecss" OnClientClick="return fnLoginValidation(); return false;" />
                    </div>
                    <div class="center-td">
                        <asp:Label runat="server" ID="lblLoginMsg"></asp:Label>
                    </div>
                </div>
            </div>
            <div class="logo_list">
                <img src="Images/login/logo_list.png" />
            </div>
        </div>
    </form>
</body>
</html>
