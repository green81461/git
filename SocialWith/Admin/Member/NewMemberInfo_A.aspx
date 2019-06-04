<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Master/AdminMasterPage.master" AutoEventWireup="true" CodeFile="NewMemberInfo_A.aspx.cs" Inherits="Admin_Member_NewMemberInfo_A" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <link href="../Content/Member/member.css" rel="stylesheet" />
     <script>
         


         //회사코드 팝업창
         function fnAddPopupOpen() {
             var e = document.getElementById('companyCodeDiv');

             if (e.style.display == 'block') {
                 e.style.display = 'none';

             } else {
                 e.style.display = 'block';
             }
         }
         //팝업창 닫기
         //function fnCancel() {
         //    $('.divpopup-layer-package').fadeOut();
         //}
</script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <div class="all">
        <div class="sub-contents-div">
            <div class="sub-title-div"><img src="../Images/Member/newMem-title.jpg" alt="신규회원관리(상세)" /></div>
        
             <!--탭메뉴-->          
            <div class="sub-tab-div">
	    		<ul>
		    		<li>
			    		<a href="NewMemberInfo_A.aspx"><img src="../Images/Member/signInfo-on.jpg" alt="가입정보"/></a>
				    	<a href="NewMemberManage_A.aspx"><img src="../Images/Member/manage-off.jpg" alt="관리"/></a>
                    
                    </li>
			    </ul>   
	         </div>
        
               <div class="memberB-div">
             <table class="member-table" >
                        <colgroup>
                            <col style="width:200px;" />
                            <col style="width:800px" />
                           
                        </colgroup>
                        
             
                            <tr><td></td><td></td></tr>
                            <tr><th>가입일</th><td><asp:Label runat="server" Width="245px" CssClass="text-readonly" ></asp:Label></td></tr>
                            <tr>
                                <th>아이디</th>
                                <td><asp:Label runat="server" Width="245px" CssClass="text-readonly" ></asp:Label></td>
                            </tr>
                             
                            <tr><td>&nbsp;</td><td>&nbsp;</td></tr>
                             <tr>
                                <th>기관명</th>
                                <td><asp:Label ID="lblOrgName" runat="server" Text="" CssClass="text-readonly"  Width="245px"></asp:Label></td>
                            </tr>

                             <tr><th>회사코드</th>
                        <td><input type="text" id="companyCode" class="text-code" style="width:245px;" placeholder="회사코드를 입력하세요"/>
                    <a class="imgA"  onClick="fnAddPopupOpen()"><img src="../../AdminSub/Images/Goods/search-bt-off.jpg"  onmouseover="this.src='../../AdminSub/Images/Goods/search-bt-on.jpg'" onmouseout="this.src='../../AdminSub/Images/Goods/search-bt-off.jpg'" alt="검색" class="search-img"/></a>
                   </td>
                             <tr>
                                <th>사업자번호</th>
                                <td><asp:Label ID="lblFirstNum" runat="server" Width="70"  CssClass="text-readonly" ></asp:Label>
                                    <asp:Label runat="server" Text="&nbsp;-&nbsp;" CssClass="hyphen"></asp:Label>
                                    <asp:Label ID="lblMiddleNum" runat="server" Width="70"  CssClass="text-readonly"></asp:Label>
                                    <asp:Label runat="server" Text="&nbsp;-&nbsp;" CssClass="hyphen"></asp:Label>
                                    <asp:Label ID="lblLastNum" runat="server"  Width="70"  CssClass="text-readonly"></asp:Label></td>
                            </tr>
                              <tr>
                                <th>대표자명</th>
                                <td><asp:Label ID="lblName" runat="server" Text="" CssClass="text-readonly" Width="245px" ></asp:Label></td>
                            </tr>
                              <tr>
                                <th>주&nbsp;&nbsp;소</th>
                                <td><asp:Label ID="lblFirstAddr" runat="server" Text="" Width="100px" CssClass="text-readonly"></asp:Label></td>
                           </tr>
                          <tr>
                                <td></td>
                                <td><asp:Label ID="lblAddr2" runat="server" Text="" Width="300px" CssClass="text-readonly" ></asp:Label>
                            
                          
                            
                                
                               <asp:Label ID="lblAddr3" runat="server" Text="" Width="300px" CssClass="text-readonly" ></asp:Label></td>
                            </tr>
                            <tr><td>&nbsp;</td><td>&nbsp;</td></tr>
                             <tr>
                                <th>담당자명</th>
                                <td><asp:TextBox ID="txtPerson" runat="server" CssClass="text-input" Width="245px"></asp:TextBox></td>
                            </tr>
                             <tr>
                                <th>부서명</th>
                                <td><asp:Label ID="lblDept" runat="server" Text="" CssClass="text-readonly" Width="245px" ></asp:Label></td>
                            </tr>
                             <tr>
                                <th>직&nbsp;&nbsp;책</th>
                                <td><asp:TextBox ID="txtPos" runat="server" CssClass="text-input" Width="245px"></asp:TextBox></td>
                            </tr>
                            <tr>
                                <th>이메일</th>
                                <td><asp:TextBox ID="txtFirstEmail" runat="server" CssClass="text-input" Width="100"></asp:TextBox>&nbsp;@&nbsp;<asp:TextBox ID="txtLastEmail" runat="server" CssClass="text-input"  Width="117"></asp:TextBox>
                                    <asp:DropDownList ID="dropDownListEmail" runat="server"  CssClass="drop-email">
                                        <asp:ListItem Value="direct" Text="-------직접입력------"></asp:ListItem>
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
                                    <asp:DropDownList ID="ddlSelPhone" runat="server" Width="70px" CssClass="drop-mob">
                                        <asp:ListItem Text="010" Value="010"></asp:ListItem>
                                        <asp:ListItem Text="011" Value="011"></asp:ListItem>
                                        <asp:ListItem Text="016" Value="016"></asp:ListItem>
                                        <asp:ListItem Text="017" Value="017"></asp:ListItem>
                                        <asp:ListItem Text="018" Value="018"></asp:ListItem>
                                        <asp:ListItem Text="019" Value="019"></asp:ListItem>
                                        <asp:ListItem Text="0130" Value="0130"></asp:ListItem>
                                    </asp:DropDownList>
                                    &nbsp;&nbsp;-&nbsp;&nbsp;
                                    <asp:TextBox ID="txtSelPhone2" runat="server" Width="70px" MaxLength="4" TextMode="Number" onkeypress="return onlyNumbers(event);"  CssClass="text-input" ></asp:TextBox><asp:Label runat="server" Text="&nbsp;&nbsp;-&nbsp;"></asp:Label>
                                    <asp:TextBox ID="txtSelPhone3" runat="server" Width="70px" MaxLength="4" TextMode="Number" onkeypress="return onlyNumbers(event);" CssClass="text-input"></asp:TextBox>
                                </td>
                            </tr>
                             <tr>
                                <th >유선전화번호</th>
                                <td>                                
                                    <asp:Label ID="lblFirstNumber" runat="server" Width="70px"  CssClass="text-readonly"></asp:Label>
                                    <asp:Label runat="server" Text="&nbsp;&nbsp;-&nbsp;&nbsp;" CssClass="hyphen"></asp:Label>
                                    <asp:Label ID="lblMiddleNumber" runat="server" Width="70px"  CssClass="text-readonly"></asp:Label><asp:Label runat="server" Text="&nbsp;&nbsp;-&nbsp;&nbsp;" CssClass="hyphen"></asp:Label><asp:Label ID="lblLastNumber" runat="server" Width="70px"  CssClass="text-readonly"></asp:Label></td>
                            </tr>
                             <tr>
                                <th>FAX번호</th>
                                <td><asp:Label ID="lblFirstFax" runat="server" Width="70px"  CssClass="text-readonly" ></asp:Label>
                                    <asp:Label runat="server" Text="&nbsp;&nbsp;-&nbsp;&nbsp;" CssClass="hyphen"></asp:Label>
                                    <asp:Label ID="lblMiddleFax" runat="server"  Width="70px"  CssClass="text-readonly"></asp:Label>
                                    <asp:Label runat="server" Text="&nbsp;-&nbsp;" CssClass="hyphen"></asp:Label>
                                    <asp:Label ID="lblLastFax" runat="server" Width="70px"  CssClass="text-readonly" ></asp:Label></td>
                            </tr>

                            <tr><th>증빙서류1</th>
                                <td><asp:Label runat="server" Width="600px" CssClass="text-readonly" ></asp:Label></td>
                            </tr>
                            <tr><th>증빙서류2</th>
                                <td><asp:Label runat="server" Width="600px" CssClass="text-readonly" ></asp:Label></td></tr>
                            <tr><th>증빙서류3</th>
                               <td><asp:Label runat="server" Width="600px" CssClass="text-readonly" ></asp:Label></td></tr>
                        <tr><td></td><td></td></tr>
          
                    </table> 
           
        </div>
<!--회사코드 팝업창영역 시작-->
           <div id="companyCodeDiv" class="divpopup-layer-package"  >
	
          <div class="companyCodeWrapper">
             <div class="companyCodeContent" style="border:none;">
                 <div class="divpopup-layer-container">
			    
                   <div class="divpopup-layer-conts" ">
                        <div class="close-div" ><a onclick="fnClosePopup('companyCodeDiv');" style="cursor:pointer"><img src="../../Images/Wish/icon-delete.jpg" alt="닫기" style="float:right;"/></a></div>
                        <div class="popup-title"><img src="../Images/Member/code-title.jpg" alt="회사코드검색"/>           
                           
<!--팝업 컨텐츠 영역 시작-->                     
                   <div class="popup-div-top">
                       <table class="tblPopup">
                           <tr><th><input type="checkbox" />&nbsp;선택</th><th>회사명</th><td class="text-center"></td><th>회사코드</th><td class="text-center"></td><td class="text-center">데이터있음</td></tr>
                           <tr><th colspan="2">비고</th><td colspan="4"></td></tr>
                       </table>
                   </div>
                            
                    <div class="popup-div-bottom">
                        <table class="tblPopup">
                            <tr><th>선택</th>
                                <th>회사명</th>
                                <th>회사코드</th>
                                <th>비고</th>
                                <th>등록날짜</th>
                            </tr>
                            <tr><td></td><td></td><td></td><td></td><td></td></tr>
                            <tr><td></td><td></td><td></td><td></td><td></td></tr>
                            <tr><td></td><td></td><td></td><td></td><td></td></tr>
                            <tr><td></td><td></td><td></td><td></td><td></td></tr>
                            <tr><td></td><td></td><td></td><td></td><td></td></tr>
                            <tr><td></td><td></td><td></td><td></td><td></td></tr>
                            <tr><td></td><td></td><td></td><td></td><td></td></tr>
                            <tr><td></td><td></td><td></td><td></td><td></td></tr>
                            <tr><td></td><td></td><td></td><td></td><td></td></tr>
                            <tr><td></td><td></td><td></td><td></td><td></td></tr>
                        </table>


                    </div>

<!--코드명생성,코드생성, 확인 버튼 영역-->
                        <div class="bt-align-div">
                            <asp:ImageButton runat="server" AlternateText="코드명수정" ImageUrl="../Images/Member/codemodify-off.jpg" onmouseover="this.src='../Images/Member/codemodify-on.jpg'" onmouseout="this.src='../Images/Member/codemodify-off.jpg'"/>
                            <asp:ImageButton runat="server" AlternateText="코드생성" ImageUrl="../Images/Member/createcode-off.jpg" onmouseover="this.src='../Images/Member/createcode-on.jpg'" onmouseout="this.src='../Images/Member/createcode-off.jpg'"/>
                            <asp:ImageButton runat="server" AlternateText="확인" ImageUrl="../Images/Member/submit-off.jpg" onmouseover="this.src='../Images/Member/submit-on.jpg'" onmouseout="this.src='../Images/Member/submit-off.jpg'"/>
                        </div>
<!--버튼영역끝 -->
<!--팝업 컨텐츠 영역끝-->


                  </div>
               </div>
		    </div>
	    </div>
    </div>
<!--팝업창영역 끝-->


        </div>
    </div>
</asp:Content>

