<%@ Page Title="" Language="C#" MasterPageFile="~/AdminSub/Master/AdminSubMaster.master" AutoEventWireup="true" CodeFile="MemberEditCheck.aspx.cs" Inherits="AdminSub_Member_MemberEditCheck" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
        <link rel="stylesheet" href="../../Content/member.css"/>
        <style type="text/css">
            .auto-style1 {
                width: 140px;
                height: 30px;
            }
            .auto-style2 {
                height: 30px;
            }
        </style>
    <script type="text/javascript">
        function fnValidate() {
            var txtPwd = $('#<%= txtPwd.ClientID%>');
            if (txtPwd.val() == '') {
                alert('비밀번호를 입력해 주세요.');
                txtPwd.focus();
                return false;
            }
        }

        function fnEnter() {

            if (event.keyCode == 13) {
                <%=Page.GetPostBackEventReference(btnConfirm)%>
                 return false;
             }
             else
                 return true;
         }
    </script>
</asp:Content>




<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <div class="all">
   <div class="sub-contents-div" >                                                              <!-- 전체 감싸는 wrap-->
        
       <!--제목 타이틀-->
            <div class="sub-title-div">
                <p class="p-title-mainsentence">
                    회원정보변경
                    <span class="span-title-subsentence">고객님의 소중한 정보를 보호합니다.</span>
                </p>
            </div>
        <div style="height:30px;"></div>


       <div class="sub-wrap" style=" height:350px;">                                                                      

            <table  style="padding:0; text-align:center; height:350px; width:700px;border:1px solid #a2a2a2;" >
                <tr><td colspan="2"> <img id="imgLock" src="../../images/changeInfo.jpg"/><br /> </td></tr>
                    
                <tr><td colspan="2">
                         * 고객님의 <span style="font-weight:bold; color:#69686">개인정보 보호를 위해</span>
                        <span style="font-weight:bold; color:#ec2028;"> 비밀번호를 다시 한번</span> 입력해 주시기 바랍니다.</td>

                </tr>
                
                <tr>
                    
                    
                    <td style="text-align:right;" class="auto-style1">&nbsp; *&nbsp; 아이디&nbsp;&nbsp;&nbsp;</td>
                    <td style="width:140px; text-align:left;height:30px; font-weight:bold "><asp:Label runat="server" ID="lblId" ></asp:Label></td>
               </tr>
                 
                
                <tr><td style="text-align:right;" class="auto-style1">*&nbsp;&nbsp;비밀번호&nbsp;</td>  
                    <td style="text-align:left;" class="auto-style2"><asp:TextBox runat ="server" ID="txtPwd" TextMode="Password" style="border:1px solid #a2a2a2; width:185px; " Onkeypress="return fnEnter();"></asp:TextBox></td>
                </tr>
              
                <tr>
                    <td colspan="2">
                        <asp:Button id="btnConfirm" runat="server" Text="확인" CssClass="mainbtn type1" Width="95" Height="30" OnClick="btnConfirm_Click" OnClientClick="return fnValidate();"/>
               </td></tr>
                
            </table>

            </div>
        
  </div>
        </div>
</asp:Content>

