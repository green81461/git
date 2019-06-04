<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Master/AdminMasterPage.master" AutoEventWireup="true" CodeFile="NewMemberManage_A.aspx.cs" Inherits="Admin_Member_NewMemberManage_A" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
     <link href="../Content/Member/member.css" rel="stylesheet" />

    <script>
     


        //회사구분코드 팝업창
        function fnAddPopupOpen() {
            var e = document.getElementById('companyClassifyDiv');

            if (e.style.display == 'block') {
                e.style.display = 'none';

            } else {
                e.style.display = 'block';
            }
        }


        //회사코드 팝업창
        function fnAddPopupOpen1() {
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
            <div class="sub-title-div"><img src="../Images/Member/newMem-title.jpg" alt="신규회원관리(상세)"/></div>
        
 <!--탭메뉴-->          
            <div class="sub-tab-div">
	    		<ul>
		    		<li>
			    		<a href="NewMemberInfo_A.aspx"><img src="../Images/Member/signInfo-off.jpg" alt="가입정보"/></a>
				    	<a href="NewMemberManage_A.aspx"><img src="../Images/Member/manage-on.jpg" alt="관리"/></a>
                    </li>
			    </ul>   
	         </div>
<!--탭메뉴 끝-->

  <!--테이블 시작-->      
            <div class="memberB-div">
                <table class="tblMember">
                    <tr><th>사업자번호</th><td colspan="3"></td></tr>
                    
                    <tr><th>회사연동코드</th>
                        <td></td>
                        <th>회사연동명</th>
                        <td></td></tr>
                    
                    <tr><th>회사구분코드</th>
                        <td><input type="text" class="text-code" placeholder="회사구분코드를 입력하세요"/>
                    <a class="imgA" onClick="fnAddPopupOpen()"><img src="../../AdminSub/Images/Goods/search-bt-off.jpg"  onmouseover="this.src='../../AdminSub/Images/Goods/search-bt-on.jpg'" onmouseout="this.src='../../AdminSub/Images/Goods/search-bt-off.jpg'" alt="검색" class="search-img"/></a>
                   </td>
                        
                        <th>회사구분명</th><td></td></tr>
                    <tr><th>회사코드</th>
                        <td><input type="text" class="text-code" placeholder="회사코드를 입력하세요"/>
                    <a class="imgA"  onClick="fnAddPopupOpen1()"><img src="../../AdminSub/Images/Goods/search-bt-off.jpg"  onmouseover="this.src='../../AdminSub/Images/Goods/search-bt-on.jpg'" onmouseout="this.src='../../AdminSub/Images/Goods/search-bt-off.jpg'" alt="검색" class="search-img"/></a>
                   </td>
                        
                        <th>회사명</th><td></td></tr>
                </table>
            </div>
<!--테이블영역끝-->

<!--승인 버튼 영역시작-->
            <div class="bt-align-div">
                <asp:ImageButton AlternateText="승인" runat="server" ImageUrl="../Images/Member/commit-off.jpg" onmouseover="this.src='../Images/Member/commit-on.jpg'" onmouseout="this.src='../Images/Member/commit-off.jpg'"/>
               
            </div>


<!--회사구분코드 팝업창영역 시작-->
           <div id="companyClassifyDiv" class="divpopup-layer-package"  >
	
          <div class="companyClassifyWrapper">
             <div class="companyClassifyContent" style="border:none;">    
                 <div class="divpopup-layer-container">
			    
                   <div class="divpopup-layer-conts" ">
                        <div class="close-div" ><a onclick="fnClosePopup('companyClassifyDiv');" style="cursor:pointer"><img src="../../Images/Wish/icon-delete.jpg" alt="닫기" style="float:right;"/></a></div>
                        <div class="popup-title"><img src="../Images/Member/codeClassify-title.jpg" alt="회사구분코드검색"/>  
                           
<!--팝업 컨텐츠 영역 시작-->                     
                   <div class="popup-div-top">
                       <table class="tblPopup">
                           <tr><th><input type="checkbox" />&nbsp;선택</th><th>회사구분명</th><td class="text-center"></td><th>회사구분코드</th><td class="text-center"></td><td class="text-center">데이터있음</td></tr>
                           <tr><th colspan="2">비고</th><td colspan="4"></td></tr>
                       </table>
                   </div>
                            
                    <div class="popup-div-bottom">
                        <table class="tblPopup">
                            <tr><th>선택</th>
                                <th>회사명</th>
                                <th>회사구분코드</th>
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
               </div>
<!--팝업창영역 끝-->


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
                 </div>
<!--팝업창영역 끝-->



<!--승인버튼 영역끝-->
        </div>
   </div>





</asp:Content>

