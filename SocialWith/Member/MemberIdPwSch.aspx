<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/Master/Login.master" CodeFile="MemberIdPwSch.aspx.cs" Inherits="Member_MemberIdPwSch" %>


<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">


    <link rel="stylesheet" href="../Content/member.css"/>
      
      
      
 

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
     <body onselectstart="return false">
    <script type="text/javascript">   
        

        $(document).ready(function () {

            $('#spanCustTelNo').text($('#hdMasterCustTelNo').val());
            var txtEmail2 = $("#<%=txtEmail2.ClientID %>");
            var ddlEmail = $("#<%=ddlEmail3.ClientID %>");
            var txtPWEmail2 = $("#<%=txtPWEmail2.ClientID %>");
            var ddlEmail4 = $("#<%=ddlEmail4.ClientID %>");


            //이메일 선택
            ddlEmail.change(function () {
                var selectedVal = $('#<%=ddlEmail3.ClientID %> option:selected').val();
                if (selectedVal == 'direct') {
                    txtEmail2.val('');
                }
                else {
                    txtEmail2.val(selectedVal);
                }
            });

            ddlEmail4.change(function () {
                var selectedVal = $('#<%=ddlEmail4.ClientID %> option:selected').val();
                 if (selectedVal == 'direct') {
                     txtPWEmail2.val('');
                 }
                 else {
                     txtPWEmail2.val(selectedVal);
                 }
             });
        })

        function maxLengthCheck(object) {
            if (object.value.length > object.maxLength) {
                object.value = object.value.slice(0, object.maxLength);
            }
        }

        function fnValidateSearchId() {

            var txtUserName = $("#<%=txtUserName.ClientID%>");
            var txtEmail1 = $("#<%=txtEmail1.ClientID%>");
            var txtEmail2 = $("#<%=txtEmail2.ClientID%>");

            var txtComnum1 = $("#<%=txtComnum1.ClientID%>");
            var txtComnum2 = $("#<%=txtComnum2.ClientID%>");
            var txtComnum3 = $("#<%=txtComnum3.ClientID%>");

            if (txtUserName.val() == '') {
                alert('담당자명을 입력해 주세요.');
                return false;
            }

            var regeMail = /^([\w-]+(?:\.[\w-]+)*)@((?:[\w-]+\.)*\w[\w-]{0,66})\.([a-z]{2,6}(?:\.[a-z]{2})?)$/;
            if (!regeMail.test((txtEmail1.val() + '@' + txtEmail2.val()))) {
                alert("잘못된 이메일 형식입니다.");
                txtEmail1.focus();
                return false;
            }

            if (txtComnum1.val() == '' || txtComnum2.val() == '' || txtComnum3.val() == '') {
                alert('사업자번호를 제대로 입력해주세요.');
                txtComnum1.focus();
                return false;
            }

            return true;
        }

        function fnValidateSearchPwd() {

            var txtUserId = $("#<%=txtUserId.ClientID%>");
            var txtPWEmail1 = $("#<%=txtPWEmail1.ClientID%>");
            var txtPWEmail2 = $("#<%=txtPWEmail2.ClientID%>");

            var txtPWComnum1 = $("#<%=txtPWComnum1.ClientID%>");
            var txtPWComnum2 = $("#<%=txtPWComnum2.ClientID%>");
            var txtPWComnum3 = $("#<%=txtPWComnum3.ClientID%>");

            if (txtUserId.val() == '') {
                alert('아이디를 입력해 주세요.');
                return false;
            }

            var regeMail = /^([\w-]+(?:\.[\w-]+)*)@((?:[\w-]+\.)*\w[\w-]{0,66})\.([a-z]{2,6}(?:\.[a-z]{2})?)$/;
            if (!regeMail.test((txtPWEmail1.val() + '@' + txtPWEmail2.val()))) {
                alert("잘못된 이메일 형식입니다.");
                txtPWEmail1.focus();
                return false;
            }

            if (txtPWComnum1.val() == '' || txtPWComnum2.val() == '' || txtPWComnum3.val() == '') {
                alert('사업자번호를 제대로 입력해주세요.');
                txtPWComnum1.focus();
                return false;
            }

            return true;
         }
    </script>





         <div style="width: 1218px;  margin-left: auto; margin-right: auto;">
 <%-- <div>
	        <p class="p-title-mainsentence">
                       아이디/비밀번호 찿기
                       <span class="span-title-subsentence">회원정보가 변경되어 조회가 불가능할 경우 고객센터 <span id="spanCustTelNo"></span>로 연락바랍니다. 업무시간 평일 09시~18시, 토요일 09시~12시, 일요일, 공휴일 휴무.</span>
            </p>
         </div>--%>


       <p style="font-weight:bold; font-size:30px; text-align:center; margin:0; ">아이디 비밀번호 찾기</p>
       <p  style="font-size:15px; text-align:center; margin:10px 0 20px 0;">정보 입력 후 아이디와 비밀번호를 찾을 수 있습니다.</p>
        
        <div class="mini-tile"><img style="vertical-align:bottom;" src="../images/searchid.jpg" /> <span style="font-size:14px; color:#ee2248; vertical-align:middle; font-weight:bold;"> 아이디 찾기</span></div>


    <div class="id-table-div1">
        <!--아이디 찾기 영역 시작-->

        <table class="id-table"  >

          

            <tr>
                <td >
                    <asp:Label ID="lblUserName" runat="server" Text="*&nbsp;&nbsp;&nbsp;담당자명"  ></asp:Label>
                </td>
                <td>
                    <asp:TextBox ID="txtUserName" runat="server"  CssClass="text-input" Width="280px"></asp:TextBox>
                </td>
            </tr>
            <tr><td style="height:10px">&nbsp;&nbsp;</td></tr>
             <tr >
                <td>
                    <asp:Label ID="lblComNum" runat="server" Text="* &nbsp;&nbsp;사업자번호" ></asp:Label>
                </td>
                <td>

                    <asp:TextBox ID="txtComnum1" runat="server" TextMode="Number" max="9999"  oninput="maxLengthCheck(this)" MaxLength="3" CssClass="text-input" Width="85px"></asp:TextBox>

                    <asp:Label ID="lblComnum1" runat="server" Text="-"></asp:Label>

                    <asp:TextBox ID="txtComnum2" runat="server" TextMode="Number" max="9999"  oninput="maxLengthCheck(this)" MaxLength="2"  CssClass="text-input" Width="86px"></asp:TextBox>

                    <asp:Label ID="lblComnum2" runat="server" Text="-"></asp:Label>

                    <asp:TextBox ID="txtComnum3" runat="server" TextMode="Number" max="99999" oninput="maxLengthCheck(this)" MaxLength="5"  CssClass="text-input" Width="86px"></asp:TextBox>
              
                <span style="padding-left:5px;">
                    <asp:Label ID="lblComnum3" runat="server" Text=" &nbsp;*사업자 번호나 고유번호를 입력해 주세요." ></asp:Label>
                    </span>
                </td>
            </tr>


            <tr  >
                <td>
                    <asp:Label ID="lblEmail" runat="server" Text="*&nbsp;&nbsp;&nbsp;E-mail 주소"></asp:Label>
                </td>

                <td>

                    <asp:TextBox ID="txtEmail1" runat="server" Width="135px" class="txtEmail1"  CssClass="text-input"></asp:TextBox>&nbsp;@&nbsp;
                    <asp:TextBox ID="txtEmail2" runat="server"  CssClass="text-input"></asp:TextBox>
                    <asp:DropDownList ID="ddlEmail3" style="vertical-align:middle;" runat="server" Width="160px" Height="25px">
                        <asp:ListItem Value="direct"  Text="직접입력" ></asp:ListItem>
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
                

                <span style="padding-left:20px;">
                    <asp:Button ID="btnSearchId" runat="server" OnClick="btnSearchId_Click" OnClientClick="return fnValidateSearchId();" Text="이메일로 아이디 받기" CssClass="mainbtn type1" Width="175" Height="29" style="vertical-align:middle;"/>
                    <%--<asp:ImageButton ID="btnSearchId" runat="server"  OnClick="btnSearchId_Click" OnClientClick="return fnValidateSearchId();" src="../images/recieveEmail_btn.jpg" onmouseover="this.src='../images/recieveEmail_on_btn.jpg'" onmouseout="this.src='../images/recieveEmail_btn.jpg'" style="padding-left:50px; position:relative; top:5px;"/>--%>
                </span>
          
                </td>
            </tr>

           
        </table>

    </div>
    <br />
        <br /><br />
    <!--ID찾기 영역 끝-->
     <div class="mini-tile"><img style="vertical-align:bottom;" src="../images/searchpw.jpg" /> <span style="vertical-align:middle; font-size:14px; color:#ee2248; font-weight:bold;">비밀번호 찾기</span></div> <!-- 패스워드찾기 영역
    
        
        
        
        
        <!--PW찾기 영역 시작-->
    <div class="id-table-div1"  >
          
     
        <table class="id-table">
            <tr>
                <td >
                    <asp:Label ID="Label1" runat="server" Text="*&nbsp;&nbsp;&nbsp;아이디"></asp:Label>
                </td>
                <td>
                    <asp:TextBox ID="txtUserId" runat="server" CssClass="text-input" Width="280px" ></asp:TextBox>
                </td>
            </tr>
           
             <tr><td>&nbsp;&nbsp;</td></tr>
            <tr>
                <td>
                    <asp:Label ID="Label3" runat="server" Text="*&nbsp;&nbsp;사업자번호"></asp:Label>
                </td>
                <td>

                    <asp:TextBox ID="txtPWComnum1" runat="server" TextMode="Number" max="9999" oninput="maxLengthCheck(this)" MaxLength="3" style="border:1px solid #a2a2a2" Width="85px" Height="25px"></asp:TextBox>

                    <asp:Label ID="Label4" runat="server" Text="-"></asp:Label>

                    <asp:TextBox ID="txtPWComnum2" runat="server" TextMode="Number" max="9999" oninput="maxLengthCheck(this)" MaxLength="2" style="border:1px solid #a2a2a2" Width="87px" Height="25px"></asp:TextBox>

                    <asp:Label ID="Label5" runat="server" Text="-"></asp:Label>

                    <asp:TextBox ID="txtPWComnum3" runat="server" TextMode="Number" max="99999" oninput="maxLengthCheck(this)" MaxLength="5" style="border:1px solid #a2a2a2" Width="87px" Height="25px"></asp:TextBox>
              
               <span style="padding-left:5px;">
                    <asp:Label ID="Label6" runat="server" Text="&nbsp;&nbsp;*사업자 번호나 고유번호를 입력해 주세요."></asp:Label></span>
                    </td>
       
            </tr>

               <tr>
                <td>
                    <asp:Label ID="Label2" runat="server" Text="*&nbsp;&nbsp;&nbsp;E-mail 주소"></asp:Label>
                </td>

                <td style="height:25px;padding-top:0;">
                    <asp:TextBox ID="txtPWEmail1" runat="server" Width="135px" Height="24px" style="border:1px solid #a2a2a2"></asp:TextBox>&nbsp;@&nbsp;
                    <asp:TextBox ID="txtPWEmail2" runat="server" Width="135px" Height="24px" style="border:1px solid #a2a2a2" ></asp:TextBox>
                    <asp:DropDownList ID="ddlEmail4" runat="server" style="vertical-align:middle;" Width="150px" Height="25px" >
                        <asp:ListItem Value="direct" Text="직접입력"></asp:ListItem>
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
                
                    <span style="padding-left:20px;">
              <asp:Button ID="btnSearchPwd" runat="server" OnClick="btnSearchPwd_Click" OnClientClick="return fnValidateSearchPwd();" Text="이메일로 임시비밀번호 받기" CssClass="mainbtn type1" Width="175" Height="29" style="vertical-align:middle;"/>
                    <%--<asp:ImageButton ID="btnSearchPwd" runat="server" Text="이메일로 임시비밀번호 받기" OnClick="btnSearchPwd_Click" OnClientClick="return fnValidateSearchPwd();" src="../images/recievePw_btn.jpg" onmouseover="this.src='../images/recievePw_on_btn.jpg'" onmouseout="this.src='../images/recievePw_btn.jpg'" style="padding-left:60px; position:relative; top:5px;"/>--%>
                </span>
                        </td>
            </tr> 
        </table>
    </div>
    <br />
    <div class="bottomBtn">

         <input type="button"  class="mainbtn type1" style="width:125px; height:30px; font-size:12px" value="로그인화면으로 이동" onclick="location.href = 'Login.aspx';"/>
    </div>
    </div>

    <%-- PW찾기 영역 끝--%>
    </body>
</asp:Content>

