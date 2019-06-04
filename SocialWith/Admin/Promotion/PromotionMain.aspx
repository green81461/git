<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Master/AdminMasterPage.master" AutoEventWireup="true" CodeFile="PromotionMain.aspx.cs" Inherits="Admin_Promotion_PromotionMain" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <link href="../Content/promotion/promotion.css" rel="stylesheet" />
     <script>
         jQuery.fn.center = function () {
             this.css("position", "absolute");
             this.css("top", Math.max(0, (($(window).height() - $(this).outerHeight()) / 2) + $(window).scrollTop()) + "px");
             this.css("left", Math.max(0, (($(window).width() - $(this).outerWidth()) / 2) + $(window).scrollLeft()) + "px");
             return this;
         }
        //팝업창
        function fnAddPopupOpen() { 
            var e = document.getElementById('productDiv');

            if (e.style.display == 'block') {
                e.style.display = 'none';

            } else {
                e.style.display = 'block';
            }
         }

         //팝업창 닫기
         function fnCancel() {
             $('.divpopup-layer-package').fadeOut();
         }


         $(document).ready(function () {
             //체크박스 하나만 선택
             var tableid = 'tblPrompt';
             ListCheckboxOnlyOne(tableid);

             //달력
             $("#<%=this.txtSearchSdate.ClientID%>").datepicker({
                showAnimation: 'slideDown',
                changeMonth: true,
                changeYear: true,
                showOn: 'button',
                buttonImage:/* "/Images/icon_calandar.png"*/"../../Images/Goods/calendar.jpg",
                buttonImageOnly: true,
                dateFormat: "yy-mm-dd",
                monthNamesShort: ["1월", "2월", "3월", "4월", "5월", "6월", "7월", "8월", "9월", "10월", "11월", "12월"],
                dayNamesMin: ["일", "월", "화", "수", "목", "금", "토"],
                showMonthAfterYear: true
            });

            $("#<%=this.txtSearchEdate.ClientID%>").datepicker({
                showAnimation: 'slideDown',
                changeMonth: true,
                changeYear: true,
                showOn: 'button',
                buttonImage:/* "/Images/icon_calandar.png"*/"../../Images/Goods/calendar.jpg",
                buttonImageOnly: true,
                dateFormat: "yy-mm-dd",
                monthNamesShort: ["1월", "2월", "3월", "4월", "5월", "6월", "7월", "8월", "9월", "10월", "11월", "12월"],
                dayNamesMin: ["일", "월", "화", "수", "목", "금", "토"],
                showMonthAfterYear: true
            });

            $('#tblSearchList input[type="checkbox"]').change(function () {
                if ($(this).prop('checked') == true) {
                    var num = $(this).val();
                    var newDate = new Date($("#<%=this.txtSearchEdate.ClientID%>").val());
                   var resultDate = new Date();
                   resultDate.setDate(newDate.getDate() - num);
                   $("#<%=this.txtSearchSdate.ClientID%>").val($.datepicker.formatDate("yy-mm-dd", resultDate));
                }
            });
              });
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">


  <div class="all">
      <div class="sub-contents-div">
          <div class="sub-title-div"><img src="../Images/promotion/promotion-title1.jpg" alt="프로모션 셋팅"/></div>


<!--프로모션 상품선택 영역-->
          <div class="promotion-div">
          <table class="tblPromotion">
              <thead><tr><th colspan="11">프로모션 상품선택</th></tr></thead>
              <tr><th>키테고리</th>
                  <td colspan="2"><asp:DropDownList runat="server" CssClass="input-drop">
                        <asp:ListItem Text="1차분류"></asp:ListItem></asp:DropDownList>                   
                  </td>
                  
                  <td colspan="2"><asp:DropDownList runat="server" CssClass="input-drop">
                        <asp:ListItem Text="2차분류"></asp:ListItem></asp:DropDownList>                   
                  </td>

                  <td colspan="2"><asp:DropDownList runat="server" CssClass="input-drop">
                        <asp:ListItem Text="3차분류"></asp:ListItem></asp:DropDownList>                   
                  </td>

                  <td colspan="2"><asp:DropDownList runat="server" CssClass="input-drop">
                        <asp:ListItem Text="4차분류"></asp:ListItem></asp:DropDownList>                   
                  </td>

                  <td colspan="2"><asp:DropDownList runat="server" CssClass="input-drop">
                        <asp:ListItem Text="5차분류"></asp:ListItem></asp:DropDownList>                   
                  </td>
              </tr>

              <tr><th>브랜드</th>
                  <td colspan="4"><input type="text" placeholder="브랜드를 입력하세요" class="text-search"/>
                    <a class="imgA"><img src="../../AdminSub/Images/Goods/search-bt-off.jpg"  onmouseover="this.src='../../AdminSub/Images/Goods/search-bt-on.jpg'" onmouseout="this.src='../../AdminSub/Images/Goods/search-bt-off.jpg'" alt="검색" class="search-img"/></a>
          </td>
              

              <th>검색</th>
                  <td><asp:DropDownList runat="server" CssClass="input-drop1"><asp:ListItem Text="상품코드" ></asp:ListItem>
                      </asp:DropDownList></td>
                  <td colspan="4">    <input type="text" placeholder="검색어를 입력하세요" class="text-search1"/>
                    <a class="imgA"><img src="../../AdminSub/Images/Goods/search-bt-off.jpg"  onmouseover="this.src='../../AdminSub/Images/Goods/search-bt-on.jpg'" onmouseout="this.src='../../AdminSub/Images/Goods/search-bt-off.jpg'" alt="검색" class="search-img"/></a>
 

                  </td>
              </tr>
          </table>
          </div>

<!--검색조건현황 영역-->
          <div class="promotion-div">
          <table class="tblPromotion">
              <thead><tr ><th colspan="11">검색조건현황</th></tr></thead>
              <tr><th >키테고리</th>
                  <td colspan="2"><asp:DropDownList runat="server" CssClass="input-drop">
                        <asp:ListItem Text="1차분류"></asp:ListItem></asp:DropDownList>                   
                  </td>
                  
                  <td colspan="2"><asp:DropDownList runat="server" CssClass="input-drop">
                        <asp:ListItem Text="2차분류"></asp:ListItem></asp:DropDownList>                   
                  </td>

                  <td colspan="2"><asp:DropDownList runat="server" CssClass="input-drop">
                        <asp:ListItem Text="3차분류"></asp:ListItem></asp:DropDownList>                   
                  </td>

                  <td colspan="2"><asp:DropDownList runat="server" CssClass="input-drop">
                        <asp:ListItem Text="4차분류"></asp:ListItem></asp:DropDownList>                   
                  </td>

                  <td colspan="2"><asp:DropDownList runat="server" CssClass="input-drop">
                        <asp:ListItem Text="5차분류"></asp:ListItem></asp:DropDownList>                   
                  </td>
              </tr>

              <tr><th  >브랜드</th>
                  <td colspan="4"></td>
              
              <th >코드</th>
                  <td colspan="4"></td>
              </tr>
          </table>
          </div>


<!--검색버튼영역-->
        <div class="bt-align-div">
         <a onclick="fnAddPopupOpen()"><img src="../Images/Order/search-off.jpg" alt="검색" onmouseover="this.src='../Images/Order/search-on.jpg'" onmouseout="this.src='../Images/Order/search-off.jpg'"/></a>
        </div>

<!--프로모션 세부선택영역-->
          <div class="promotion-div">
          <table class="tblPromotion" id="tblPrompt">
              <thead><tr><th colspan="10">프로모션 세부선택</th></tr></thead>

              <tr><th>프로모션명/구분</th><td colspan="2" style="width:300px;"></td>
             <th>프로모션일</th>
                 <td colspan="6">   <asp:TextBox ID="txtSearchSdate" runat="server" CssClass="calendar"></asp:TextBox>&nbsp;&nbsp;-&nbsp;
                        <asp:TextBox ID="txtSearchEdate" runat="server" cssclass="calendar"></asp:TextBox>&nbsp;&nbsp; 
                        <input type="checkbox" id="ckbSearch1" value="7" checked="checked" /><label for="ckbSearch1" >7일&nbsp;</label>
                        <input type="checkbox" id="ckbSearch2" value="15" /><label for="ckbSearch2">15일&nbsp;</label>
                        <input type="checkbox" id="ckbSearch3" value="30" /><label for="ckbSearch3">30일</label> 
                 </td> </tr>
              <tr><th>가격조건설정</th><td colspan="4"><asp:DropDownList runat="server" CssClass="input-drop1">
                  <asp:ListItem Text="판매가"></asp:ListItem>
                                     </asp:DropDownList>
                            <asp:Label runat="server" Text="를"></asp:Label>
                            <input type="text" class="input-txt"  />
                            <asp:DropDownList runat="server"  class="input-drop2">
                                <asp:ListItem Text="%"></asp:ListItem>
                            </asp:DropDownList> 
                            <asp:Label runat="server" Text="로 할인적용합니다." ></asp:Label>
                                 </td>
              <th>기&nbsp;&nbsp;타</th><td colspan="2"><input type="checkbox" />&nbsp;단종제외</td>
              <th>범&nbsp;&nbsp;위</th><td><input type="checkbox" />&nbsp;전체상품 일괄적용
                  <input type="checkbox" />&nbsp;선택상품만 적용</td></tr>
              <tr><th>파일첨부</th><td colspan="10"><input type="file" class="fileUpload"/></td></tr>

          </table>

             
              </div>

<!--확인버튼 영역-->
          <div class="bt-align-div">
              <asp:ImageButton runat="server" AlternateText="확인" ImageUrl="../Images/promotion/submit1-off.jpg" onmouseover="this.src='../Images/promotion/submit1-on.jpg'" onmouseout="this.src='../Images/promotion/submit1-off.jpg'"/>              
          </div>
         

 <!--상품등록 팝업창영역 시작-->
             <div id="productDiv" class="divpopup-layer-package"  >
          <div class="productWrapper">
             <div class="productContent" style="border:none;">
               <div class="divpopup-layer-container">
			    
                   <div class="divpopup-layer-conts" ">
                        <div class="close-div" ><a onclick="fnCancel()" style="cursor:pointer"><img src="../../Images/Wish/icon-delete.jpg" alt="닫기" style="float:right;"/></a></div>
                        <div class="popup-title"><img src="../Images/promotion/register-title.jpg" alt="상품등록"/>  
                           
       <!--전체선택 체크박스-->      
                 <div class="bt-align-div"><input type="checkbox" value="all"/>&nbsp;&nbsp;<span style="font-size:14px;">전체선택</span></div> 

                    <div class="popup-div">
                        <table class="tblPopup">
                            <tr><th>번호</th>
                                <th><input type="checkbox" />&nbsp; 선택</th>
                                <th>그룹코드</th>
                                <th>상품코드</th>
                                <th>상품명</th>
                                <th>브랜드명</th>
                                <th>모델명</th>
                                <th>판매가격</th>
                                <th>매입가격</th>
                                <th>재고</th>
                                <th>단종여부</th>
                                <th>단위</th>
                                <th>속성명1~13</th>
                                <th>속성값1~12</th>

                            </tr>
                            <tr><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td></tr>
                            <tr><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td></tr>
                            <tr><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td></tr>
                            <tr><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td></tr>
                            <tr><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td></tr>
                            <tr><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td></tr>
                            <tr><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td></tr>
                            <tr><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td></tr>
                            <tr><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td></tr>
                            <tr><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td></tr>
                            <tr><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td></tr>
                            <tr><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td></tr>
                            <tr><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td></tr>
                            <tr><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td></tr>
                        
                                <tr><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td></tr>
                            <tr><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td></tr>
                            <tr><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td></tr>
                            <tr><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td></tr>
                            <tr><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td></tr>
                            <tr><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td></tr>
                            <tr><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td></tr>
                        
                        </table>
                    </div>

<!--추가 버튼 영역-->
                        <div class="bt-align-div">
                                 <asp:ImageButton runat="server" AlternateText="확인" ImageUrl="../Images/Member/submit-off.jpg" onmouseover="this.src='../Images/Member/submit-on.jpg'" onmouseout="this.src='../Images/Member/submit-off.jpg'"/>
                      
                             </div>


                  </div>
               </div>
		    </div>
	    </div>
    </div>
<!--팝업창 끝-->

    </div>
  </div>
</asp:Content>

