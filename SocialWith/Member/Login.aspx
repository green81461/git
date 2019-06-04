
<%@ Page Title="" Language="C#" MasterPageFile="~/Master/Login.master" AutoEventWireup="true" CodeFile="Login.aspx.cs" Inherits="Member_Login" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <!-- CSS -->
    <script src="../Scripts/jquery.capslockstate.js"></script>
    <script src="aes.js" type="text/javascript"></script>
    <script type="text/javascript">
        var siteName = '<%= SiteName%>';
        $(function () {
            var bannerCookie = fnGetCookie("bannerYN");

            if (bannerCookie != null && bannerCookie != '') {
                $('#<%= hfBannerYN.ClientID%>').val('Y');
            }
            else {
                $('#<%= hfBannerYN.ClientID%>').val('N');
            }

            if (siteName == 'socialwith') {
                $('#btnCompAbout').css('display','');
            }

        })

        function fnGoMemberJoinPage() {
           
            if (siteName == 'socialwith') {
                location.href = '../Member/MemberJoinSelect.aspx';
            }
            else {
                location.href = '../Member/Agreement.aspx?JoinType=B';
            }
        }

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


        function fnGuestChk() {
            var custTel = '<%= CustTel%>';
            alert('게스트 로그인을 진행합니다. \n가격 정보는 표시되지 않습니다.\n문의:' + custTel);
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
    <style>
       
        
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <asp:HiddenField runat="server" ID="hfBannerYN" />

    <div runat="server" id="divBg">
        <div class="login_main">
            <div class="ci">
                <asp:Image runat="server" Style="vertical-align: middle;" ID="imgHeader" />
            </div>
            <div class="bgimg">
                <asp:Image runat="server" Style="vertical-align: middle;" ID="imgBg" />
            </div>
            <div class="border">
                <div class="line_black"></div>
                <div class="login_text" style="position: relative">
                        <asp:Image runat="server" Style="vertical-align: middle; display:inline-block; margin-right: 34px;" ID="imgLoginLogo" OnClick="location.href = '../Other/LoginCompanyAbout_menu01.aspx'; return false;"/>
                        <a id="btnCompAbout" style="display:none" class="btn_style" onclick="location.href = '../Other/LoginCompanyAbout_menu01.aspx'; return false;">회사소개</a>
                        <asp:TextBox runat="server" Style=" display:inline-block" ID="txtLoginId" Class="login_txt" placeholder="아이디"></asp:TextBox>
                        <asp:TextBox runat="server" Style="display:inline-block" ID="txtPwd" CssClass="login_txt" TextMode="Password"  placeholder="패스워드" onkeyup="checkCapsWarning(event)" onfocus="checkCapsWarning(event)" onblur="removeCapsWarning()" Onkeypress="return fnEnter();" />
                        <asp:Button runat="server" Style="display:inline-block" ID="btnLogin" OnClick="btnLogin_Click" Text="로그인" CssClass="login_btn login-sitecss" OnClientClick="return fnLoginValidation(); return false;" />                   
                    <div class="capserror-wrap" id="err_capslock" style="display: none">
                        <div class="capserror-box">
                            <p><strong>Caps Lock</strong>이 켜져 있습니다.</p>
                        </div>
                    </div>
                    <div class="mismsg-wrap" style="position:absolute">
                        <asp:Label runat="server" ID="lblLoginMsg" CssClass="mismsg"></asp:Label>
                    </div>
                </div>

                <div class="pswd">
                    <div style="display: inline-block; float: left">
                        <asp:CheckBox runat="server" ID="ckbSaveId" Text="&nbsp;아이디 저장" CssClass="w"  style="font-size:12px;"/>
                    </div>
                    <div style="display: inline-block; float: right">
                        <a onclick="fnPageRedirect('join')"><span class="memberjoin">· 회원가입&nbsp; ▶</span></a>&nbsp;&nbsp;&nbsp;
                        <a onclick="fnPageRedirect('search')"><span class="id_find">· 아이디/비밀번호찾기&nbsp; ▶</span></a>
                    </div>

                </div>


            </div>
        </div>
        <div class="society">
            <asp:Image runat="server" Style="vertical-align: middle;" ID="imgCopyright" />
        </div>

    </div>






    <script>
        var capsLockEnabled = null;

        function getChar(e) {

            if (e.which == null) {
                return String.fromCharCode(e.keyCode); // IE
            }
            if (e.which != 0 && e.charCode != 0) {
                return String.fromCharCode(e.which); // rest
            }

            return null;
        }

        document.onkeydown = function (e) {
            e = e || event;

            if (e.keyCode == 20 && capsLockEnabled !== null) {
                capsLockEnabled = !capsLockEnabled;
            }
        }

        document.onkeypress = function (e) {
            e = e || event;

            var chr = getChar(e);
            if (!chr) return; // special key

            if (chr.toLowerCase() == chr.toUpperCase()) {
                // caseless symbol, like whitespace 
                // can't use it to detect Caps Lock
                return;
            }

            capsLockEnabled = (chr.toLowerCase() == chr && e.shiftKey) || (chr.toUpperCase() == chr && !e.shiftKey);
        }

        /**
         * Check caps lock 
         */
        function checkCapsWarning() {
            document.getElementById('err_capslock').style.display = capsLockEnabled ? 'inline' : 'none';
        }

        function removeCapsWarning() {
            document.getElementById('err_capslock').style.display = 'none';
        }
    </script>


</asp:Content>

