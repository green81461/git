<%@ Page Title="" Language="C#" MasterPageFile="~/Master/Default.master" AutoEventWireup="true" CodeFile="MemberEditCheck.aspx.cs" Inherits="Member_MemberEditCheck" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <link rel="stylesheet" href="../Content/member.css" />
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
                <%=Page.GetPostBackEventReference(btnOk)%>
                return false;
            }
            else
                return true;
        }
    </script>
</asp:Content>




<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div class="sub-contents-div">
        <!-- 전체 감싸는 wrap-->
        <div style="margin-bottom:40px;"class="sub-title-div">
             <img src="/images/MemberEditCheck_nam.png" />
        </div>



        <div class="sub-wrap">

            <table id="memberEdit">
                <tr>
                    <td colspan="2">
                        <img id="imgLock" src="../images/changeInfo.jpg" />
                    </td>
                </tr>

                <tr>
                    <td colspan="2">고객님의 <span style="font-weight: bold;">개인정보 보호를 위해</span>
                        <span style="font-weight: bold; color: #ec2028">비밀번호를 다시 한번</span> 입력해 주시기 바랍니다.</td>

                </tr>

                <tr>


                    <td style="text-align: right;" class="auto-style1">&nbsp; &nbsp; 아이디&nbsp;&nbsp;&nbsp;</td>
                    <td style="width: 140px; text-align: left; height: 30px; font-weight: bold;">
                        <asp:Label runat="server" ID="lblId"></asp:Label></td>
                </tr>


                <tr>
                    <td style="text-align: right;" class="auto-style1">&nbsp; &nbsp; 비밀번호&nbsp;</td>
                    <td style="text-align: left;" class="auto-style2">
                        <asp:TextBox runat="server" ID="txtPwd" TextMode="Password" Style="border: 1px solid #a2a2a2; padding-left: 5px; height: 26px; width: 185px;" Onkeypress="return fnEnter();"></asp:TextBox></td>
                </tr>



                <tr>
                    <td colspan="2">
                        <div>
                            <%-- <asp:ImageButton runat="server" ID="btnOk" Text="확인" OnClick="btnOk_Click" OnClientClick="return fnValidate();" src="../images/changeInfo_btn.jpg" onmouseover="this.src='../images/changeInfo_on_btn.jpg'" onmouseout="this.src='../images/changeInfo_btn.jpg'" CssClass="btn" style="width:275px; height:32px;"/> --%>
                            <asp:Button ID="btnOk" runat="server" OnClick="btnOk_Click" OnClientClick="return fnValidate();" Text="확인" CssClass="mainbtn type1" Width="117" Height="30" />
                        </div>
                    </td>
                </tr>

            </table>

        </div>
        <div class="left-menu-wrap" id="divLeftMenu">
            <dl>
                 <dt style="border-bottom:1px solid #eaeaea;">
                    <strong>마이페이지</strong>
                </dt>
                <dd>
                    <a href="/Order/OrderHistoryList.aspx">주문조회</a>
                </dd>
                <dd>
                    <a href="/Delivery/DeliveryOrderList.aspx">배송조회</a>
                </dd>
                <dd>
                    <a href="/Order/OrderBillIssue.aspx">세금계산서 조회</a>
                </dd>
                
                <dd class="active">
                    <a href="/Member/MemberEditCheck.aspx">마이정보변경</a>
                </dd>
                <dd>
                    <a href="/Delivery/DeliveryList.aspx">배송지관리</a>
                </dd>
            </dl>
        </div>
    </div>





</asp:Content>

