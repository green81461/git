<%@ Page Title="" Language="C#" MasterPageFile="~/Master/Default.master" AutoEventWireup="true" CodeFile="ShowAllBrand.aspx.cs" Inherits="Goods_ShowAllBrand" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
      <style>

        .searchkeyword{

            color:red;
            font-weight:bold
        }
        #brandList ul {
            
            float: left;
            margin-left:-32px;
            list-style:none;
			padding-top:10px;

        }


         #brandList ul.node_list span:hover,#brandList ul.node_list span:focus {  
            font-weight : bold;  
            cursor: pointer;
			background-color:#ec2028;
			width:209px;
			height:31px;
			display:block;
			color:#fff;
			
			
        } 
		
		.categorys{font-size:13px; font-weight:bold}

        /*ul{
            list-style:none;
          
        }
        ul li:hover, ul li:focus {  
            font-weight : bold;  
            cursor: pointer;
			
        } */  
    </style>
    <script type="text/javascript">
        var FinalCategoryCode;
        var GoodsName;
        var qs = fnGetQueryStrings();
        $(function () {
           

            FinalCategoryCode = qs["FinalCategoryCode"];
           
            GoodsName = qs["GoodsName"];
          
            fnBrandListBind();
        })

        function fnBrandListBind() {
           
            var callback = function (response) {
                var index1 = 1;
                $.each(response, function (key, value) { //테이블 추가

                    $('#list1').append('<li onclick="fnLoadListPage(\'' + FinalCategoryCode + '\', \'' + value.BrandCode + '\'); return false;" style="border:1px solid #a2a2a2; background-color:#ececec; width:209px; height:31px; text-align:center; font-size:12px; line-height:30px; font-color:#69696c; margin-bottom:10px; margin-left:22px; float:left"><span style="display:block;">' + value.BrandName + '</span></li>');

                    index1++;
                });
            }

            var categoryCode = '';
           
            var goodsName = '';
            var compCode = '';
            var saleCompCode = '';
            var bCheck = '';
            if (!isEmpty(qs["FinalCategoryCode"])) {
                categoryCode = qs["FinalCategoryCode"];
            }

            if (!isEmpty(qs["GoodsName"])) {
                goodsName = qs["GoodsName"];
            }
            if (!isEmpty(qs["CompCode"])) {
                compCode = qs["CompCode"];
            }
            if (!isEmpty(qs["SaleCompCode"])) {
                saleCompCode = qs["CompCode"];
            }
            if (!isEmpty(qs["BCheck"])) {
                bCheck = qs["BCheck"];
            }
           
            var param = { Method: 'GetBrandList', FinalCode: categoryCode, Keyword: goodsName, CompCode: compCode, SaleCompCode: saleCompCode, BCheck: bCheck};
            Jajax('Post', '../../Handler/Common/BrandHandler.ashx', param, 'json', callback);
        }

        function fnLoadListPage(categoryCode, brandCode) {

            var goodsName = '';
            
            if (!isEmpty(qs["GoodsName"])) {
                goodsName = qs["GoodsName"];
            }

            location.href = '../../Goods/GoodsList.aspx?CategoryCode=' + categoryCode + '&GoodsName=' + goodsName + '&BrandCode=' + brandCode + '&SearchFlag=R';
            return false;
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <div class="sub-contents-div">
        <div>
			<img src="../images/Goods/sub_title_showallbrand.jpg">
		</div>
        <div>
		    <div style="margin-top:30px; margin-left:10px; display:inline-block">
			    <img src="../images/Goods/sub_title_category.jpg"> &nbsp;&nbsp; <asp:Label ID="lbCategory" runat="server" cssclass="categorys"></asp:Label>
                &nbsp;&nbsp;&nbsp;
            </div>
            <div style="margin-top:30px; margin-right:60px; float:right; display:inline-block">
                <span style="font-weight:bold">검색어 : </span><asp:Label runat="server" ID="lblSearchKeyword" CssClass="searchkeyword"></asp:Label>
            </div>
        </div>
        <div  style="margin-top:18px; ">
            
            <div style=" width:100%; padding: 10px; 10px;">
				<div id="brandList">
					<ul id="list1" class="node_list"  style="height:auto;"></ul>
					<%--<ul id="list2" class="node_list"  style="height:auto;"></ul>
					<ul id="list3" class="node_list"  style="height:auto;"></ul>--%>
					
				</div>
			</div>

        </div>       
    </div>
</asp:Content>

