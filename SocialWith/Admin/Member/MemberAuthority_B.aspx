<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Master/AdminMasterPage.master" AutoEventWireup="true" CodeFile="MemberAuthority_B.aspx.cs" Inherits="Admin_Member_MemberAuthority_B" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <link href="../Content/Member/member.css" rel="stylesheet" />
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <div class="all">
    <div class="sub-contents-div">
<!--회원정보-권한관리-->
        <div class="sub-title-div"><img src="../Images/Member/memberInfo_a.jpg" alt="회원정보(구매사)"/></div>
    
<!--탭메뉴-->          
            <div class="sub-tab-div">
	    		<ul>
		    		<li>
			    		<a href="MemberCorpInfo_B.aspx?uId=<%=uId %>"><img src="../Images/Member/corpInfo-off.jpg" alt="회사기본정보"/></a>
				    	<a href="MemberPersonalInfo_B.aspx?uId=<%=uId %>"><img src="../Images/Member/personalInfo-off.jpg" alt="개인정보"/></a>
                        <a href="MemberAuthority_B.aspx?uId=<%=uId %>"><img src="../Images/Member/authority-on.jpg" alt="권한관리"/></a>
				        <a href="MemberLogInfo_B.aspx?uId=<%=uId %>"><img src="../Images/Member/log-off.jpg" alt="활동정보"/></a>
				
                    </li>
			    </ul>   
	         </div>

        <div class="memberB-div">
            <table class="tblMember">
                <tr><th>예산관리</th><td><asp:DropDownList runat="server" CssClass="input-drop1"><asp:ListItem Text="거래중/거래중지"></asp:ListItem>
                                     </asp:DropDownList></td><th>배송지관리</th>
                    <td><asp:DropDownList runat="server" CssClass="input-drop1">
                        <asp:ListItem Text="거래중/거래중지"></asp:ListItem>
                        </asp:DropDownList></td>

                </tr>
                
                <tr><th>주문취소</th><td><asp:DropDownList runat="server" CssClass="input-drop1"><asp:ListItem Text="거래중/거래중지"></asp:ListItem>
                                     </asp:DropDownList></td><th>유저관리</th>
                    <td><asp:DropDownList runat="server" CssClass="input-drop1"><asp:ListItem Text="거래중/거래중지"></asp:ListItem>
                                     </asp:DropDownList></td></tr>
                <tr><th>구매요청취소</th><td><asp:DropDownList runat="server" CssClass="input-drop1"><asp:ListItem Text="거래중/거래중지"></asp:ListItem>
                                     </asp:DropDownList></td>
                    <th>사회적기업선택</th><td><asp:DropDownList runat="server" CssClass="input-drop1"><asp:ListItem Text="거래중/거래중지"></asp:ListItem>
                                     </asp:DropDownList></td></tr>
                <tr><th>결제상신취소</th><td><asp:DropDownList runat="server" CssClass="input-drop1"><asp:ListItem Text="거래중/거래중지"></asp:ListItem>
                                     </asp:DropDownList></td>
                    <th>구매요청관리(취소/승인)</th><td><asp:DropDownList runat="server" CssClass="input-drop1"><asp:ListItem Text="거래중/거래중지"></asp:ListItem>
                                     </asp:DropDownList></td></tr>
                <tr><th>주문권한(대금결제)</th><td><asp:DropDownList runat="server" CssClass="input-drop1"><asp:ListItem Text="거래중/거래중지"></asp:ListItem>
                                     </asp:DropDownList></td>
                    <th>결제상신관리(취소/승인)</th><td><asp:DropDownList runat="server" CssClass="input-drop1"><asp:ListItem Text="거래중/거래중지"></asp:ListItem>
                                     </asp:DropDownList></td></tr>
                
            </table>
        </div>
<!--저장버튼-->
        <div class="bt-align-div">
            <asp:ImageButton runat="server" ImageUrl="../Images/Member/save.jpg" AlternateText="저장" onmouseover="this.src='../Images/Member/save-on.jpg'" onmouseout="this.src='../Images/Member/save.jpg'"/>
        </div>
<!--저장버튼끝-->

    </div>
</div>
</asp:Content>

