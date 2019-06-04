<%@ Page Title="" Language="C#" MasterPageFile="~/Master/Default.master" AutoEventWireup="true" CodeFile="GoodsDetailSearch.aspx.cs" Inherits="Goods_GoodsDetailSearch" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    
    <link rel="stylesheet" href="../Content/Goods/goods.css"/>

    <script type="text/javascript">

        function fnSearchValidate() {
            var code = $('#<%= txtgoodsCode.ClientID%>').val();
            if (code.trim().length != 7 && code.trim() != '') {
                alert('상품코드는 7자리로 검색해야 됩니다.');
                $('#<%= txtgoodsCode.ClientID%>').focus();
                return false;
            }
        }
        function fnEnter() {

            if (event.keyCode == 13) {
                <%=Page.GetPostBackEventReference(btnSearch)%>
               return false;
           }
           else
               return true;
       }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <div class="sub-contents-div"> 
        <!-- 상세검색 div-->
       
        
        
        
        <div class="sub-contents-right-div">

        <div class="sub-title-div" style="margin-top:0">
	        <p class="p-title-mainsentence">
                       상세검색
                       <span class="span-title-subsentence">보다 상세하게 검색을 합니다.</span>
            </p>
         </div>

         
            
            <table class="search-table">
                <tr>
					<th>
						<label>카테고리</label>
					</th>
                    <td colspan="8">
						<asp:DropDownList ID="ddlCategoryCode" runat="server" style="height:90%;width:100%;">
                        <asp:ListItem Text="---전체카테고리---" Value="All" Selected="True"></asp:ListItem></asp:DropDownList>
					</td>
                    
                </tr>

                <tr>
					<th style="height:30px;">
						<label for="brandName" >브랜드</label>
					</th>
                    <td colspan="2">
                        <asp:TextBox runat="server" id="txtbrandName" onkeypress="return fnEnter();" height="24px" style="border:none; padding-left:5px;"></asp:TextBox>
						<%--<input type="text" name="brandName" id="brandName" "/>--%>
					</td>

					<th>
						<label for="goodsCode">상품코드</label>
					</th>
                    <td>
                         <asp:TextBox runat="server" id="txtgoodsCode" onkeypress="return fnEnter();" height="24px" style="border:none; padding-left:5px;"></asp:TextBox>
						<%--<input type="text" name="goodsCode" id="goodsCode"/>--%>
					</td>
                    <th>
						<label for="goodsName">상품명</label>
					</th>
                    <td>
                         <asp:TextBox runat="server" id="txtgoodsName" onkeypress="return fnEnter();" height="24px" style="border:none; padding-left:5px;"></asp:TextBox>
						<%--<input type="text" name="goodsName" id="goodsName"/>--%>
					</td>
                    <th>
						<label for="modelName">모델명</label>
					</th>
                    <td>
                         <asp:TextBox runat="server" id="txtmodelName" onkeypress="return fnEnter();" height="24px" style="border:none; padding-left:5px;"></asp:TextBox>
						<%--<input type="text" name="modelName" id="modelName" />--%>
					</td>
                
                </tr>
       
            </table>

			<div class="search-btn" style="width:980px">
                <asp:Button ID="btnSearch" runat="server" OnClick="btnSearch_Click" OnClientClick="return fnSearchValidate();" Text="상세검색" CssClass="mainbtn type1" Width="95" Height="30"/>
                <%--<asp:Button runat="server" CssClass="commonBtn" Text="상세검색" ID="btnSearch" Font-Size="12px" Width="95px" Height="30px" OnClientClick="return fnSearchValidate();" OnClick="btnSearch_Click"/>--%>
            </div>
        </div>




         <!--  브랜드 사이드메뉴 div-->
         <%--<div style="float: left; width: 13%; padding:10px; position:absolute; top:223px">
              <span>카테고리</span>
              <ul id="categorySideMenu" class="treeSideMenu-list" style="padding:0">
                  <li  onclick="fnLoadListPage(this, ''); return false;"><span>전체카테고리</span></li>
              </ul>
              <br />
              <span>브랜드</span>
              <ul id="brandSideMenu" class="treeSideMenu-list" style="padding:0">
                  <li><span>전체브랜드</span></li>
              </ul>
             <br />
             <div id="divCategoryAllList">
                <a id="aCategoryAllList" >더보기+</a> <!-- 이거 나중에 지워야 함 -->
             </div>
        </div>--%>
          
    </div>

</asp:Content>

