<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Master/AdminMasterPage.master" AutoEventWireup="true" CodeFile="MemberInterlockList.aspx.cs" Inherits="Admin_Member_MemberInterlockList" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
     <link href="../Content/Member/member.css" rel="stylesheet" />
  <script>
    //판매사 회사구분코드 팝업창
     function fnAddPopupOpen() {
         var e = document.getElementById('corpCodeAdiv');

         if (e.style.display == 'block') {
             e.style.display = 'none';

         } else {
             e.style.display = 'block';
         }
     }

     //구매사 회사구분코드 팝업창
     function fnAddPopupOpen1() {
         var e = document.getElementById('corpCodeBdiv');

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
        <div class="sub-contents-div" style="max-height:1200px; ">
            <div class="sub-title-div"><img src="../Images/Member/interlocking-title2.jpg" alt="관계사연동관리"/></div>



         <!--관계사 연동관리 등록-->
      <div class="mini-title"><img src="../Images/Member/subInterlock1.jpg" alt="연동등록"/></div>
               <table id="tblInsert" >
        <thead>
            <tr><th>회사연동코드</th>
                <td><asp:TextBox  runat="server" CssClass="text-input1" Width="99.7%"></asp:TextBox></td>
                  
                <th>회사연동명</th>
                 <td><asp:TextBox  runat="server" CssClass="text-input1" Width="99.7%"></asp:TextBox></td>
            </tr>
            <tr><th>판매사 회사구분코드</th>
                 <td><input type="text" class="text-code" placeholder="판매사의 회사구분코드를 입력하세요"/>
                    <a class="imgA" onClick="fnAddPopupOpen()"><img src="../../AdminSub/Images/Goods/search-bt-off.jpg"  onmouseover="this.src='../../AdminSub/Images/Goods/search-bt-on.jpg'" onmouseout="this.src='../../AdminSub/Images/Goods/search-bt-off.jpg'" alt="검색" class="search-img"/></a>
                   </td>
                <th>구매사 회사구분코드</th>
                <td><input type="text" class="text-code" placeholder="구매사의 회사구분코드를 입력하세요"/>
                    <a class="imgA" onClick="fnAddPopupOpen1()"><img src="../../AdminSub/Images/Goods/search-bt-off.jpg"  onmouseover="this.src='../../AdminSub/Images/Goods/search-bt-on.jpg'" onmouseout="this.src='../../AdminSub/Images/Goods/search-bt-off.jpg'" alt="검색" class="search-img"/></a>
                   </td>
            </tr>

            <tr><th>비고</th>
                <td colspan="3"><asp:TextBox  runat="server" CssClass="text-input1" Width="99.7%"></asp:TextBox></td></tr>
        </thead>

    </table>
            <div class="bt-align-div">
          <asp:ImageButton runat="server" AlternateText="연동코드생성" ImageUrl="../Images/Member/code-off.jpg" onmouseover="this.src='../Images/Member/code-on.jpg'" onmouseout="this.src='../Images/Member/code-off.jpg'"/>
          <asp:ImageButton runat="server" AlternateText="등록" ImageUrl="../Images/Member/insert-off.jpg" onmouseover="this.src='../Images/Member/insert-on.jpg'" onmouseout="this.src='../Images/Member/insert-off.jpg'"/>
                </div>
        
            <div class="mini-title" ><img src="../Images/Member/subInterlock.jpg" alt="연동등록"/></div>

           <div class="bottom-search-div">
             <table class="notice-search-table" style="margin-top:30px;margin-bottom:30px; border:1px solid #a2a2a2; border-bottom:none;">
                <tr>
                    <td style="text-align:left; width:150px; ">
                        <asp:DropDownList  runat="server">
                            <asp:ListItem Text="전체" Value="Title"></asp:ListItem>
                            <asp:ListItem Text="회사연동코드" Value="Writer"></asp:ListItem>
                            <asp:ListItem Text="회사연동명" Value="Title"></asp:ListItem>
                            <asp:ListItem Text="판매사회사구분코드" Value="Writer"></asp:ListItem>
                            <asp:ListItem Text="구매사회사구분코드" Value="Title"></asp:ListItem>
                        </asp:DropDownList>
                    </td>
                    <td>
                        <asp:TextBox  runat="server" placeholder="검색어를 입력하세요." style="padding-left:10px;"></asp:TextBox>
                    </td>
                    <td >
                        <asp:Button  runat="server" CssClass="notice-search-btn" />
                    </td>
                   
                </tr>
            </table>
         </div>

 <!--관계사 연동관리 리스트 영역-->
               <table class="interlockList">
                <thead>
                <tr>
                    <th style="width:100px;">번호</th>
                    <th style="width:200px;">회사연동코드</th>
                    <th style="width:200px;">회사연동명</th>
                    <th style="width:200px;">판매사회사구분코드</th>
                    <th style="width:200px;">구매사회사구분코드</th>
                    <th style="width:100px;">비고</th>
                    <th style="width:120px;">등록날짜</th>
                    <th style="width:100px;">삭제</th>
                </tr>
                    </thead>
                <tbody> <!--티바디 안에꺼 추후 다 지울예정-->
                    <tr><td>1000</td><td>구세군</td><td>A00001</td><td>B00001</td>
                        <td>CBA00001</td><td></td><td>2018-12-29</td><td>삭제</td>
                    </tr>
                    
                    <tr><td>f</td><td></td><td></td><td></td>
                        <td></td><td></td><td></td><td></td>
                    </tr>
                    
                    <tr><td></td><td></td><td></td><td></td>
                        <td></td><td></td><td></td><td></td>
                    </tr>
                    
                    <tr><td></td><td></td><td></td><td></td>
                        <td></td><td></td><td></td><td></td>
                    </tr>
                    
                    <tr><td></td><td></td><td></td><td></td>
                        <td></td><td></td><td></td><td></td>
                    </tr>
                    
                    <tr><td></td><td></td><td></td><td></td>
                        <td></td><td></td><td></td><td></td>
                    </tr>
                    
                    <tr><td></td><td></td><td></td><td></td>
                        <td></td><td></td><td></td><td></td>
                    </tr>
                    
                    <tr><td></td><td></td><td></td><td></td>
                        <td></td><td></td><td></td><td></td>
                    </tr>
                    
                    <tr><td></td><td></td><td></td><td></td>
                        <td></td><td></td><td></td><td></td>
                    </tr>
                    
                    <tr><td></td><td></td><td></td><td></td>
                        <td></td><td></td><td></td><td></td>
                    </tr>
                    
                    <tr><td></td><td></td><td></td><td></td>
                        <td></td><td></td><td></td><td></td>
                    </tr>
                    
                    <tr><td></td><td></td><td></td><td></td>
                        <td></td><td></td><td></td><td></td>
                    </tr>
                    
                    <tr><td></td><td></td><td></td><td></td>
                        <td></td><td></td><td></td><td></td>
                    </tr>
                    
                    <tr><td></td><td></td><td></td><td></td>
                        <td></td><td></td><td></td><td></td>
                    </tr>
                    
                    <tr><td></td><td></td><td></td><td></td>
                        <td></td><td></td><td></td><td></td>
                    </tr>
                    
                    <tr><td></td><td></td><td></td><td></td>
                        <td></td><td></td><td></td><td></td>
                    </tr>
                    
                    <tr><td></td><td></td><td></td><td></td>
                        <td></td><td></td><td></td><td></td>
                    </tr>
                    
                    <tr><td></td><td></td><td></td><td></td>
                        <td></td><td></td><td></td><td></td>
                    </tr>
                    
                    <tr><td></td><td></td><td></td><td></td>
                        <td></td><td></td><td></td><td></td>
                    </tr>
                    
                    <tr><td></td><td></td><td></td><td></td>
                        <td></td><td></td><td></td><td></td>
                    </tr>
                </tbody>
            </table>
           
 
       
       
    
<!--판매사 회사구분코드 팝업-->
            <div id="corpCodeAdiv" class="divpopup-layer-package">
                <div class="corpCodeAwrapper">
                    <div class="corpCodeAcontents">
      
                        <div class="close-div" ><a onclick="fnClosePopup('corpCodeAdiv');" style="cursor:pointer"><img src="../../Images/Wish/icon-delete.jpg" alt="닫기" style="float:right;"/></a></div>
                        <div class="popup-title" style="margin-top:20px;"><img src="../Images/Member/a-title.jpg" alt="회사구분코드검색"/>  
                      
                            <div class="search-div">
                  <input type="text" class="text-code" placeholder="검색어를 입력하세요"/>
                    <a class="imgA"><img src="../../AdminSub/Images/Goods/search-bt-off.jpg"  onmouseover="this.src='../../AdminSub/Images/Goods/search-bt-on.jpg'" onmouseout="this.src='../../AdminSub/Images/Goods/search-bt-off.jpg'" alt="검색" class="search-img"/></a>
                   </div>
                   
                 <div class="code-div">
                <table class="tblCode">
                    <thead>
                    <tr>
                        <th>번호</th>
                        <th>판매사회사구분코드</th>
                        <th>판매사회사구분명</th>
                    </tr>
                        </thead>
                    <tbody>
                        <tr><td>1</td><td>A0001</td><td>구세군</td></tr>
                        <tr><td></td><td></td><td></td></tr>
                        <tr><td></td><td></td><td></td></tr>
                        <tr><td></td><td></td><td></td></tr>
                        <tr><td></td><td></td><td></td></tr>
                        <tr><td></td><td></td><td></td></tr>
                        <tr><td></td><td></td><td></td></tr>
                        <tr><td></td><td></td><td></td></tr>
                        <tr><td></td><td></td><td></td></tr>
                        <tr><td></td><td></td><td></td></tr>
                    </tbody>
                </table>
                     </div>


                  </div>
               </div>
		    </div>
	    </div>



   <!--구매사 회사구분코드 팝업-->
            <div id="corpCodeBdiv" class="divpopup-layer-package">
                <div class="corpCodeBwrapper">
                    <div class="corpCodeBcontents">
                        <div class="close-div" ><a onclick="fnClosePopup('corpCodeBdiv');" style="cursor:pointer"><img src="../../Images/Wish/icon-delete.jpg" alt="닫기" style="float:right;"/></a></div>
                        <div class="popup-title" style="margin-top:20px;"><img src="../Images/Member/b-title.jpg" alt="회사구분코드검색"/>  
                         
                           
                            <div class="search-div">
                  <input type="text" class="text-code" placeholder="검색어를 입력하세요"/>
                    <a class="imgA"><img src="../../AdminSub/Images/Goods/search-bt-off.jpg"  onmouseover="this.src='../../AdminSub/Images/Goods/search-bt-on.jpg'" onmouseout="this.src='../../AdminSub/Images/Goods/search-bt-off.jpg'" alt="검색" class="search-img"/></a>
                   </div>

                               <div class="code-div">
                <table class="tblCode">
                    <thead>
                    <tr>
                        <th>번호</th>
                        <th>판매사회사구분코드</th>
                        <th>판매사회사구분명</th>
                    </tr>
                        </thead>
                    <tbody>
                        <tr><td>1</td><td>A0001</td><td>구세군</td></tr>
                        <tr><td></td><td></td><td></td></tr>
                        <tr><td></td><td></td><td></td></tr>
                        <tr><td></td><td></td><td></td></tr>
                        <tr><td></td><td></td><td></td></tr>
                        <tr><td></td><td></td><td></td></tr>
                        <tr><td></td><td></td><td></td></tr>
                        <tr><td></td><td></td><td></td></tr>
                        <tr><td></td><td></td><td></td></tr>
                        <tr><td></td><td></td><td></td></tr>
                    </tbody>
                </table>
                     </div>

                        </div>
                    </div>
                </div>
            </div>



        </div>
    </div>
</asp:Content>
