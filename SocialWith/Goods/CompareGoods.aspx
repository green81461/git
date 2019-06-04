<%@ Page Title="" Language="C#" MasterPageFile="~/Master/Default.master" AutoEventWireup="true" CodeFile="CompareGoods.aspx.cs" Inherits="Goods_CompareGoods" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <link href="../Content/Goods/goods.css" rel="stylesheet" />

    <style>

     * { box-sizing: border-box;}

    .slider {width: 1216px;  margin: 0px auto;}

    .slick-slide {margin: 0px 5px; width:183px;}

    .slick-slide img {width: 100%;}

    .slick-prev:before, .slick-next:before { color: black;}

    .slick-slide {transition: all ease-in-out .3s;  opacity: .2;}
    
    .slick-active {opacity: 1;}
	  
    .keep_words{color:#ec2029; line-height:40px; font-size:12px; font-weight:bold;}

    .check_boxs{line-height:40px; margin-top:20px;}

</style>

    <script type="text/javascript">
       
    $(function () {
        fnWeekSale();
       
    })

    //금주 특가상품
    function fnWeekSale() {
        var callback = function (response) {

            for (var i = 0; i < response.length; i++) {

                var mapName = '';
                //배송일 당일발송과 1일만 보이게
                if (response[i].GoodsDeliveryOrderDue == '1' || response[i].GoodsDeliveryOrderDue == '2') {
                    mapName = response[i].MapName;
                }

                var src = '/GoodsImage' + '/' + response[i].GoodsFinalCategoryCode + '/' + response[i].GoodsGroupCode + '/' + response[i].GoodsCode + '/' + response[i].GoodsFinalCategoryCode + '-' + response[i].GoodsGroupCode + '-' + response[i].GoodsCode + '-mmm.jpg';
                var detailPage = '../Goods/GoodsDetail.aspx?CategoryCode=' + response[i].GoodsFinalCategoryCode + '&GroupCode=' + response[i].GoodsGroupCode + '&BrandCode=&GoodsCode=' + response[i].GoodsCode;
                var createHtml = '<div class="goods_hint" style="border:1px solid #a2a2a2; width:194px; height:320px; padding:3px 5px">';
                createHtml += '<a href="' + detailPage + '"><img src="' + src + '"  onerror="no_image(this, \'m\')"  style="width:170px; height:170px; margin:0 auto; margin-top:6px;"></a>';
                createHtml += '<h4 class="txt" style=" height:36px; width:100%; line-height:15px; font-size:12px; font-weight:bold;"><a href="' + detailPage + '" title="' + response[i].GoodsFinalName + '">' + response[i].GoodsFinalName + '</a></h4>';
                createHtml += '<div style="color:red; padding: 5px 0 0px 0; height:20px">' + mapName + '</div>';
                createHtml += '<div style="color:#2d5c84;padding-bottom:10px;"></div>';
                createHtml += '<div style="height:15px; width:100%"><span>' + response[i].BrandName + '</span></div>';
                createHtml += '<span class="keep_words">' + numberWithCommas(response[i].GoodsSalePriceVat) + '원</span><span class="check_boxs"><input type="checkbox" id="checkAll" style="float:right; border:2px solid blue "/></span></div>';

                createHtml += '</div>';
                $('#compareGoods').append(createHtml);
            }

            $.when(callback).then(function (data, textStatus, jqXHR) {
                $("#compareGoods").slick({
                infinite: false,
                slidesToShow: 5,
                slidesToScroll: 5,
                variableWidth: true
                 });
            });
           
            return false;
        }
        var param = {
            Method: 'GetCategoryHint'
        };
        Jajax('Post', '../../Handler/GoodsHandler.ashx', param, 'json', callback);
    }
</script>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <div class="sub-contents-div" style="widtH:1262px; height:auto;">
<!--제목타이틀영역-->
        <div class="sub-title-div"><img src="../Images/Goods/compare-title.jpg" alt="상품비교"/> </div>

<!--관심상품담기, 장바구니담기 버튼영역-->    
        <div class="Cbt-align">
            <asp:ImageButton runat="server" AlternatedText="관심상품담기" ImageUrl="../Images/Goods/wish-off.jpg" onmouseover="this.src='../Images/Goods/wish-on.jpg'" onmouseout="this.src='../Images/Goods/wish-off.jpg'"/>
            <asp:ImageButton runat="server" AlternatedText="장바구니담기" ImageUrl="../Images/Goods/cart-on.jpg" onmouseover="this.src='../Images/Goods/cart-on.jpg'" onmouseout="this.src='../Images/Goods/cart-on.jpg'"/>
        </div>
	   <table class="title-event-table"  style="margin-top:30px;">
										
					<tr class="data-tr" style="width:1262px; height:310px; float:left; border:1px solid blue "> <!-- 비교상품은 5개 출력! 맨 앞자리 한칸은 비워주세요-->
						<td  >
							<div style="width:218px; height:320px; margin-right:00px; float:left">
									<img src="../Images/Goods/compare_comment.jpg">
							</div>
					  
							<div style="float:right;  width:1012px; overflow:hidden">
								   <section class="thisweek-sale-image slider" id="compareGoods"></section>
								
							</div>
						</td>
					</tr>

					

		  </table>

		 <div class="title-event-table" style="float:left">
				<div style="width:218px; height:auto; border:1px solid blue;  min-height:600px; float:left; padding:10px 10px;">
								비교데이터 영역<br />
								상품명<br />
								모델명<br />
								기타등등<br />
								기타등등<br />
								기타등등<br />
								기타등등<br />
								기타등등<br />
								기타등등<br />
								기타등등<br />
								기타등등<br />
								기타등등<br />
				 </div>

				 <div style="width:1012px; height:auto; border:1px solid #a2a2a2; margin-left:245px;  min-height:600px; ">

							<div style="width:198px; height:598px; margin-right:5px; padding:5px 5px;  border-right:1px dotted #a2a2a2;  float:left">
								<div style="width:186px; height:580px; "> 비교데이터 영역</div>
							</div>

							<div style="width:198px; height:598px; margin-right:5px; padding:5px 5px; border-right:1px dotted #a2a2a2;  float:left">
								<div style="width:186px; height:580px; "> 비교데이터 영역</div>
							</div>

							<div style="width:198px; height:598px; margin-right:5px; padding:5px 5px; border-right:1px dotted #a2a2a2;  float:left">
								<div style="width:186px; height:580px; "> 비교데이터 영역</div>
							</div>

							<div style="width:198px; height:598px;  margin-right:5px; padding:5px 5px; border-right:1px dotted #a2a2a2;  float:left">
								<div style="width:186px; height:580px; "> 비교데이터 영역</div>
							</div>

							<div style="width:198px; height:598px;  float:left;  padding:5px 5px;">
								<div style="width:186px; height:580px; "> 비교데이터 영역</div>
							</div>

				 </div>
		 </div>

    </div>
 </asp:Content>

