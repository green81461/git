<%@ Page Title="" Language="C#" MasterPageFile="~/Master/Default.master" AutoEventWireup="true" CodeFile="WishGroupList.aspx.cs" Inherits="Wish_WishGroupList" %>
<%@ Register Src="~/UserControl/ucListControl.ascx" TagName="ListPager" TagPrefix="ucPager"%>
<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
   <link href="../Content/Wish/wish.css" rel="stylesheet" />
    
    <script type="text/javascript">
        function fnAddPopupOpen() {
            $('#<%= txtGroupName.ClientID%>').val('');  //텍스트박스 클리어
            $('#<%= txtGroupContent.ClientID%>').val('');//텍스트박스 클리어
            //layer_open('divpopup-layer-package', 'divLayerPopup', '400px', '300px');

            fnOpenDivLayerPopup('divWishGroupPopup');
        }

        function fnValidate() {
            var txtGroupName = $('#<%= txtGroupName.ClientID%>');
            var txtGroupContent = $('#<%= txtGroupContent.ClientID%>');

            if (txtGroupName.val() == '') {
                alert('분류명을 입력해주세요.');
                txtGroupName.focus();
                return false;
            }

            if (txtGroupContent.val() == '') {
                alert('내용을 입력해주세요.');
                txtGroupContent.focus();
                return false;
            }

            return true;
        }

        function fnEnter() {

            if (event.keyCode == 13) {
                <%=Page.GetPostBackEventReference(btnSearch)%>
                return false;
            }
            else
                return true;
        }

        function fnDeleteConfirm() {
            if (confirm('삭제 하시겠습니까?')) {
                return true;
            }
            return false;
        }

        function fnCancel() {
            $('.divpopup-layer-package').fadeOut();
        }

        function fnGoWishList(groupCode) {
            location.href = 'WishList.aspx?GroupCode=' + groupCode;
            return false;
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
      <div class="sub-contents-div">
            <div class="sub-title-div">
                <img src="/images/WishGroupList_nam.png" />
                <%--<p class="p-title-mainsentence">
                    위시상품 분류함 
                    <span class="span-title-subsentence">내가 찜한 상품을 한눈에 조회할 수 있습니다.</span>
                </p>--%>
            </div>
          <div class="div-main-tab">
                <ul>
                    <li class='tabOff' onclick="location.href='NewGoodsRequestMain.aspx'">
                        <a href="../Wish/WishList.aspx" style="display: block">위시상품 리스트</a>
                    </li>
                    <li class='tabOn' onclick="location.href='NewGoodsRequestList.aspx'">
                        <a href="../Wish/WishGroupList.aspx" style="display: block">위시상품 분류함</a>
                    </li>
                </ul>
            </div>
            <div class="clear"></div>
            <div class="top-bts">
                <input type="button"  class="mainbtn type1" style="width:95px; height:30px; font-size:12px" value="분류함 추가"" onclick="fnAddPopupOpen();"/>
            </div>
          ` <div>
                <!--데이터 리스트 시작 -->
                <asp:ListView ID="lvWishGroupList" runat="server" ItemPlaceholderID="phItemList"  OnItemCommand="lvWishGroupList_ItemCommand" OnItemDeleting="lvWishGroupList_ItemDeleting">
                    <LayoutTemplate>
                        <table id="tblHeader" class="tbl_main">
                            <colgroup class="">
                                <col />
                                <col />
                                <col />
                                <col />
                                <col />
                                <col />
                                <col />
                                <col />
                                <col />
                                <col />
                            </colgroup>
                            <thead>
                                <tr class="">
                                    <th class="txt-center" style="height:40px;">번호</th>
                                    <th class="txt-center">분류명</th>
                                    <th class="txt-center">내용</th>
                                    <th class="txt-center">상풍수량</th>
                                    <th class="txt-center">삭제</th>
                                </tr>
                            </thead>
                            <tbody>
                                <asp:PlaceHolder ID="phItemList" runat="server" />
                            </tbody>
                        </table>
                    </LayoutTemplate>
                    <ItemTemplate>
                            <tr">
                                <td class="txt-center" >
                                    <%# Container.DataItemIndex + 1%>
                                </td>
                                <td class="txt-center" runat="server" id="tdArea" visible='true'>
                                    <%# Eval("UWishListGroupName").ToString()%>
                                </td>
                                <td class="txt-center" runat="server" id="tdBusiness">
                                  <a href="WishList.aspx?GroupCode=<%# Eval("UNum_WishListGroup").ToString()%>"><%# Eval("UWishListGroupContext").ToString()%></a>
                                </td>
                                <td class="txt-center">
                                 <a href="WishList.aspx?GroupCode=<%# Eval("UNum_WishListGroup").ToString()%>"><%# Eval("ProductCount").ToString()%></a>
                                   
                                </td>
                                <td class="txt-center">
                                 <asp:ImageButton id="deleteLink" runat="server"   OnClientClick="return fnDeleteConfirm();" CommandArgument='<%# Eval("UNum_WishListGroup").ToString() %>' CommandName="Delete" ImageUrl="../Images/delivery/delete-off.jpg" onmouseover="this.src='../Images/delivery/delete-on.jpg'" onmouseout="this.src='../Images/delivery/delete-off.jpg'"/>
                  


                                </td>
                            </tr>
                    </ItemTemplate>
                    <EmptyDataTemplate>
                        <table class="tbl_main" >
                            <colgroup>
                                <col />
                                <col />
                                <col />
                                <col />
                                <col />
                            </colgroup>
                            <thead>
                                <tr>
                                    <th class="txt-center" ">번호</th>
                                    <th class="txt-center">분류명</th>
                                    <th class="txt-center">내용</th>
                                    <th class="txt-center">상풍수량</th>
                                    <th class="txt-center">삭제</th>
                                </tr>
                            </thead>
                            <tr>
                                <td colspan="10" style="text-align:center;">조회된 데이터가 없습니다.</td>
                            </tr>
                        </table>
                    </EmptyDataTemplate>
                </asp:ListView>
               <div style="margin:0 auto; text-align:center">
                 <ucPager:ListPager id="ucListPager" runat ="server" OnPageIndexChange="ucListPager_PageIndexChange" PageSize="20"/>
               </div>
            </div>
          <div  class="wish-search-div" style="text-align:center">
          <table>
              <tr>
                  <td>
                    <asp:TextBox runat="server" ID="txtSearchGroupName" placeholder="분류명으로 검색" Width="500px" Onkeypress="return fnEnter();" CssClass="text-box1" style="border:1px solid #a2a2a2;"></asp:TextBox>
                </td>
               <td>
                   <asp:Button ID="btnSearch" runat="server" OnClick="btnSearch_Click" Text="검색" CssClass="mainbtn type1" Width="95" Height="30"/>

               </td>
        </table> 

          </div>  
      </div>
            

             
                                

    <div class="left-menu-wrap" id="divLeftMenu">
        <dl>
            <dt>
                <strong>주문정보</strong>
            </dt>
            <dd>
                <a href="/Cart/CartList.aspx">장바구니</a>
            </dd>
            <dd  class="active">
                <a href="/Wish/WishList.aspx">위시상품 리스트</a>
            </dd>
            <dd>
                <a href="/Goods/GoodsRecommListSearch.aspx">견적상품게시판</a>
            </dd>
            <dd>
                <a href="/Goods/NewGoodsRequestMain.aspx">신규견적요청</a>
            </dd>
        </dl>
    </div>
          
          
     <div id="divWishGroupPopup" class="popupdiv divpopup-layer-package">
             <div  class="popupdivWrapper" style="width:400px; height:300px">
               <div class="popupdivContents">
			    <div class="divpopup-layer-conts">
                    <h3>보관함추가</h3>
                    <table  class="wishbox-pop">
                        <thead>
                            <tr>
                                <th >
                                    분류명
                                </th>
                                <th >
                                    내용
                                </th>
                            </tr>
                            </thead>
                            <tbody>
                                <tr>
                                    <td>
                                        <asp:TextBox runat="server" ID="txtGroupName" CssClass="text-box" onkeypress="return preventEnter(event);"></asp:TextBox>
                                    </td>
                                    <td>
                                        <asp:TextBox runat="server" ID="txtGroupContent" CssClass="text-box" onkeypress="return preventEnter(event);"></asp:TextBox>
                                    </td>
                                </tr>
                            </tbody>
                    </table>
                    <br />
                    <div class="bt-pop">
                    <asp:ImageButton id="btnCancle" runat="server"  OnClick="btnAdd_Click"   OnClientClick="return fnValidate();" ImageUrl="../Images/Wish/add-bt-off.jpg" onmouseover="this.src='../Images/Wish/add-bt-on.jpg'" onmouseout="this.src='../Images/Wish/add-bt-off.jpg'"/>
                    
                     <asp:ImageButton id="btnAdd" runat="server" onclientclick="fnCancel(); return false;" ImageUrl="../Images/Wish/cancle-off.jpg" onmouseover="this.src='../Images/Wish/cancle-on.jpg'" onmouseout="this.src='../Images/Wish/cancle-off.jpg'"/>
                     
                     <%--   <asp:Button runat="server" ID="btnAdd" Text="추가" OnClick="btnAdd_Click" OnClientClick="return fnValidate();" />--%>
                       <%-- <input type="button" id="btnCancel" value="취소" onclick="fnCancel(); return false;" class="cancle-btn"/>--%>
                
                        </div>
                </div>
		    </div>
	    </div>
    </div>
</asp:Content>

