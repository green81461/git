<%@ Page Language="C#" AutoEventWireup="true" CodeFile="GoodsCompareView.aspx.cs" Inherits="Goods_GoodsCompareView" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title></title>
    <link rel="stylesheet" href="../Content/Goods/goods.css" />
    <link rel="stylesheet" href="../Content/common.css" />
    <script type="text/javascript" src="../Scripts/jquery-1.10.2.min.js"></script>
    <script type="text/javascript" src="../Scripts/common.js"></script>
    <style>
        .imgbtndisplaynone {
            display: none;
        }

        * {
            box-sizing: border-box;
        }

        .slider {
            width: 1216px;
            margin: 0px auto;
        }

        .slick-slide {
            margin: 0px 5px;
            width: 183px;
        }

            .slick-slide img {
                width: 100%;
            }

        .slick-prev:before, .slick-next:before {
            color: black;
        }

        .slick-slide {
            transition: all ease-in-out .3s;
            opacity: .2;
        }

        .slick-active {
            opacity: 1;
        }

        .keep_words {
            color: #ec2029;
            line-height: 40px;
            font-size: 12px;
            font-weight: bold;
        }

        .check_boxs {
            line-height: 10px;
            margin-top: 5px;
        }

        .compare_goods_grid_box {
            height: 325px;
            width: 210px;
            margin: 3.5px;
            padding: 10px 10px 5px 10px;
            float: left;
            overflow: hidden;
            line-height: 15px;
            font-size: 12px;
            border: 1px solid #a2a2a2;
        }

        .compare_goods_grid_summarybox {
            height: auto;
            width: 210px;
            margin: 3.5px;
            padding: 3px 3px 3px 3px;
            float: left;
            overflow: hidden;
            line-height: 15px;
            font-size: 12px;
            border: 1px solid #a2a2a2;
        }

        .compare_goods_grid_summarybox2 {
            height: auto;
            width: 210px;
            margin: 3.5px;
            padding: 3px 3px 3px 3px;
            float: left;
            overflow: hidden;
            line-height: 15px;
            font-size: 12px;
            border: 1px solid #a2a2a2;
        }

        .compare_goods_grid_number {
            height: 20px;
        }

        .item_cnt {
            font-size: 13px;
            color: #a55403;
            float: left;
            vertical-align: middle;
        }

        .compare_goods_grid_box h3 {
            margin: 0;
            padding-top: 5px;
            font-weight: normal;
            overflow: hidden;
            font-size: 1.0em;
            height: 2.7em;
            line-height: 1.2em;
            text-align: left;
        }

        .compare_goods_grid_image img {
            height: 170px;
            width: 170px;
            overflow: hidden;
            text-align: center;
            margin-left: -3px;
        }

        .compare_goods_manufacturers {
            font-size: .85em;
            color: #004b91;
            overflow: hidden;
            margin: 4px 0;
            height: 2.0em;
            line-height: 1.2em;
            text-align: left;
        }

        .compare_keep_words {
            white-space: nowrap;
            word-break: keep-all;
            word-wrap: normal;
        }

        .compare_goods_price {
            color: #d53636;
            font-size: 2em;
            font-weight: bold;
            font-family: Verdana,"돋움",sans-serif,helvetica;
            text-align: left;
        }

        .comparegoodssummarytable1 {
            /*border: 1px solid #a2a2a2;*/
            width: 100%;
            font-family: 돋움체, sans-serif;
            border-collapse: collapse;
        }

            .comparegoodssummarytable1 th {
                /*border-top: 2px solid #BFBFBF;
            border-bottom: 1px solid #CECECE;*/
                border: 1px solid #a2a2a2;
                background-color: #F0F0F0;
                color: #69686d;
            }

            .comparegoodssummarytable1 td {
                border: 1px solid #a2a2a2;
            }

        .comparegoodssummarytable2 {
            /*border: 1px solid #a2a2a2;*/
            width: 100%;
            font-family: 돋움체, sans-serif;
            border-collapse: collapse;
        }

            .comparegoodssummarytable2 th {
                /*border-top: 2px solid #BFBFBF;
            border-bottom: 1px solid #CECECE;*/
                border: 1px solid #a2a2a2;
                background-color: #F0F0F0;
                color: #69686d;
            }

            .comparegoodssummarytable2 td {
                border: 1px solid #a2a2a2;
            }

        .product_Promotion_text {
            color: white;
            background-color: red;
            font-size: 11px;
            letter-spacing: -.1em;
            padding: 3px 3px 3px 3px;
            margin-right: 3px;
            width: 48px;
        }
    </style>
    <script type="text/javascript">
        var is_sending = false;
        var qs = fnGetQueryStrings();
        var qsGoodsCodes;
        var qsSvidUser;
        var compcode = '';
        var saleCompCode = '';
        $(function () {

            qsGoodsCodes = qs["GoodsCodes"];
            qsSvidUser = qs["SvidUser"];


            var svidUser = '<%= SvidUser%>';
            if (svidUser != '') {

                $('#<%= ibAddWish.ClientID%>').removeClass('imgbtndisplaynone');
                $('#<%= ibAddCart.ClientID%>').removeClass('imgbtndisplaynone');
            }

            if (!isEmpty('<%= CompCode%>')) {
                compcode = '<%= CompCode%>'
            }
            else {
                compcode = 'EMPTY'
            }

            if (!isEmpty('<%= SaleCompCode%>')) {
                saleCompCode = '<%= SaleCompCode%>'
            }
            else {
                saleCompCode = 'EMPTY'
            }

            fnGoodsListBind();
        })

        function fnGoodsListBind() {

            $('.list-parent-frame').empty();
            $('.summarylist-parent-frame').empty();
            //넘겨줄 매개변수
            var param = {
                Method: 'GetGoodsCompareList'
                , SvidUser: qsSvidUser
                , GoodsCodes: qsGoodsCodes
                , CompCode: compcode
                , SaleCompCode: saleCompCode
                , DongshinCheck: '<%= BmroCheck%>'
                , FreeCompanyYN: '<%= FreeCompanyYN%>'
                , FreeCompanyVatYN: '<%= FreeCompanyVatYN%>'

            };

            $.ajax({
                type: 'Post',
                url: '../../Handler/GoodsHandler.ashx',
                cache: false,
                data: param,
                dataType: 'json',
                success: function (response) {
                    var newDivContent = '';
                    var newDivContent2 = '';
                    var index = 1;
                    if (!isEmpty(response)) {


                        for (var i = 0; i < response.length; i++) {
                            var finalCode = response[i].GoodsFinalCategoryCode;
                            var goodsCode = response[i].GoodsCode;
                            var groupCode = response[i].GoodsGroupCode;
                            var goodsName = response[i].GoodsFinalName;
                            var goodsModel = response[i].GoodsModel;
                            var mapName = '';
                            var brandName = response[i].BrandName;


                            var goodsSpecial = response[i].GoodsSpecial;
                            var goodsFormat = response[i].GoodsFormat;
                            var goodsCause = response[i].GoodsCause;
                            var goodsSupplies = response[i].GoodsSupplies;

                            //배송일 당일발송과 1일만 보이게
                            if (response[i].GoodsDeliveryOrderDue == '1' || response[i].GoodsDeliveryOrderDue == '2') {
                                mapName = response[i].GoodsDeliveryOrderDue_Name;
                            }

                            var svidUser = '<%= SvidUser%>';
                            var svidRole = '<%= SvidRole%>';
                            var price = '';
                            var priceHtml = '';
                            var spanPromotionDisplayFlag = '';
                            if (isEmpty(response[i].GoodsDCPriceVat)) {
                                spanPromotionDisplayFlag = 'display:none';
                            }
                            if (svidUser == '' || svidRole == 'T') {
                                price = '(회원전용)';
                                priceHtml = '<span class="keep_words">' + price + '</span>';
                            }
                            else {
                                price = numberWithCommas(response[i].GoodsBuyPriceVat) + '원';

                                if (isEmpty(response[i].GoodsDCPriceVat)) {
                                    priceHtml = '<span>' + price + '</span>';
                                }
                                else {
                                    priceHtml = '<span style="text-decoration: line-through;">' + price + '</span>&nbsp;<span  style="color:black;">' + numberWithCommas(response[i].GoodsDCPriceVat) + '원</span>';
                                }
                            }


                            var taxYn = response[i].GoodsSaleTaxYN;
                            var taxTag = '';
                            if (taxYn == "2") taxTag = "<span style='color:black; font-weight:normal; font-size:0.5em;'>&nbsp;(면세)</span>";

                            var src = '/GoodsImage' + '/' + finalCode + '/' + groupCode + '/' + goodsCode + '/' + finalCode + '-' + groupCode + '-' + goodsCode + '-mmm.jpg';
                            var srcOrigin = window.location.protocol + '//' + 'www.socialwith.co.kr' + '<%= ConfigurationManager.AppSettings["UpLoadFolder"]%>' + 'Origin' + '/' + response[i].GoodsOriginCode + '.jpg';
                            newDivContent += '<div class="compare_goods_grid_box item">';
                            newDivContent += '<div class="compare_goods_grid_image"><img onerror="no_image(this, \'m\')" src="' + src + '" alt="' + goodsName + '" title="' + goodsName + '"/>&nbsp;</div>';
                            newDivContent += '<h3 class="txt" style=" height:40px; width:100%; line-height:15px; font-size:12px; font-weight:bold;">' + goodsName + '</h3>';
                            newDivContent += "<div style='float:left; '><span id='spanPromotion' class='product_Promotion_text' style='" + spanPromotionDisplayFlag + "; '>특가</span></div>"
                            newDivContent += '<br/><div style="color:red; padding: 2px 0 0px 0; height:10px">' + mapName + '</div>';
                            newDivContent += '<div style="color:#2d5c84;padding-bottom:10px;"></div>';
                            newDivContent += '<div class="compare_goods_manufacturers brand" style="font-size:12px; color:#69696c">' + brandName + '</div>';
                            newDivContent += '<div class="compare_goods_price price" ><span class="keep_words">' + priceHtml + '</span>' + taxTag;
                            newDivContent += '<span class="check_boxs"><input type="checkbox" id="checkAll" style="float:right; border:2px solid blue "/>';
                            newDivContent += '<input type="hidden" id="hdCategoryCode" value="' + finalCode + '"/>';
                            newDivContent += '<input type="hidden" id="hdGroupCode" value="' + groupCode + '"/>';
                            newDivContent += '<input type="hidden" id="hdGoodsCode" value="' + goodsCode + '"/>';
                            newDivContent += '<input type="hidden" id="hdGoodsUnitMoq" value="' + response[i].GoodsUnitMoq + '"/>';
                            newDivContent += '</span>';
                            newDivContent += '</div>';
                            newDivContent += '</div>';


                            newDivContent2 += '<div class="compare_goods_grid_summarybox" id="divsummary' + index + '">';
                            newDivContent2 += '<table class="comparegoodssummarytable1">';
                            newDivContent2 += '<tr>';
                            newDivContent2 += '<th style="width:50px">브랜드';
                            newDivContent2 += '</th>';
                            newDivContent2 += '<td> ' + brandName + '';
                            newDivContent2 += '</td>';
                            newDivContent2 += '</tr>';
                            newDivContent2 += '<tr>';
                            newDivContent2 += '<th>모델명';
                            newDivContent2 += '</th>';
                            newDivContent2 += '<td>' + goodsModel + '';
                            newDivContent2 += '</td>';
                            newDivContent2 += '</tr>';
                            newDivContent2 += '<tr>';
                            newDivContent2 += '<th>원산지';
                            newDivContent2 += '</th>';
                            newDivContent2 += '<td><img src="' + srcOrigin + '" onerror="no_image(this, \'o\')" style="border: 1px solid #a2a2a2; margin: 0 auto"/> ' + response[i].GoodsOriginName + '';
                            newDivContent2 += '</td>';
                            newDivContent2 += '</tr>';

                            if (goodsSpecial != '') {
                                newDivContent2 += '<tr>';
                                newDivContent2 += '<th>특징';
                                newDivContent2 += '</th>';
                                newDivContent2 += '<td id="tdSpecial">' + goodsSpecial.replace(/■/gi, '<br/>' + '■').replace(/※/gi, '<br/>' + '※').replace(/▶/gi, '<br/>' + '▶').replace(/≫/gi, '<br/>' + '≫') + '';
                                newDivContent2 += '</td>';
                                newDivContent2 += '</tr>';


                            }
                            if (goodsFormat != '') {
                                newDivContent2 += '<tr>';
                                newDivContent2 += '<th>형식';
                                newDivContent2 += '</th>';
                                newDivContent2 += '<td id="tdFormat">' + goodsFormat.replace(/■/gi, '<br/>' + '■').replace(/※/gi, '<br/>' + '※').replace(/▶/gi, '<br/>' + '▶').replace(/≫/gi, '<br/>' + '≫') + '';
                                newDivContent2 += '</td>';
                                newDivContent2 += '</tr>';
                            }
                            if (goodsCause != '') {
                                newDivContent2 += '<tr>';
                                newDivContent2 += '<th>주의사항';
                                newDivContent2 += '</th>';
                                newDivContent2 += '<td id="tdCause">' + goodsCause.replace(/■/gi, '<br/>' + '■').replace(/※/gi, '<br/>' + '※').replace(/▶/gi, '<br/>' + '▶').replace(/≫/gi, '<br/>' + '≫') + '';
                                newDivContent2 += '</td>';
                                newDivContent2 += '</tr>';
                            }
                            if (goodsSupplies != '') {
                                newDivContent2 += '<tr>';
                                newDivContent2 += '<th>용도';
                                newDivContent2 += '</th>';
                                newDivContent2 += '<td id="tdSupplies">' + goodsSupplies.replace(/■/gi, '<br/>' + '■').replace(/※/gi, '<br/>' + '※').replace(/▶/gi, '<br/>' + '▶').replace(/≫/gi, '<br/>' + '≫') + '';
                                newDivContent2 += '</td>';
                                newDivContent2 += '</tr>';
                            }


                            newDivContent2 += '</table>';
                            newDivContent2 += '</div>';
                            index++;


                        }

                        $('.list-parent-frame').append(newDivContent);
                        $('.summarylist-parent-frame').append(newDivContent2);


                        var maxHeight = 0;
                        $(".compare_goods_grid_summarybox").each(function () {
                            var thisH = $(this).height();
                            if (thisH > maxHeight) { maxHeight = thisH; }

                            if ($(this).find('#tdSpecial').length > 0 && $(this).find('#tdSpecial').html().substring(0, 4) == '<br>') {
                                $(this).find('#tdSpecial br:lt(1)').remove();
                            }
                            if ($(this).find('#tdFormat').length > 0 && $(this).find('#tdFormat').html().substring(0, 4) == '<br>') {
                                $(this).find('#tdFormat br:lt(1)').remove();
                            }
                            if ($(this).find('#tdCause').length > 0 && $(this).find('#tdCause').html().substring(0, 4) == '<br>') {
                                $(this).find('#tdCause br:lt(1)').remove();
                            }
                            if ($(this).find('#tdSupplies').length > 0 && $(this).find('#tdSupplies').html().substring(0, 4) == '<br>') {
                                $(this).find('#tdSupplies br:lt(1)').remove();
                            }
                        });
                        $('.compare_goods_grid_summarybox').css('height', maxHeight + 30);

                        GoodsOptionListBind();
                    }

                    return false;
                }
                ,
                error: function (xhr, status, error) {
                    if (xhr.readyState == 0 || xhr.status == 0) {
                        return; //Skip this error
                    }
                    alert('xhr: ' + xhr + 'status: ' + status + 'Error: ' + error + "\n오류가 발생했습니다. 잠시 후 다시 시도해 주세요.");
                }
            });

        }

        function GoodsOptionListBind() {

            $('.summarylist-parent-frame2').empty();

            //넘겨줄 매개변수
            var param = {
                Method: 'GetGoodsCompareSummaryList',
                GoodsCodes: qsGoodsCodes
            };

            $.ajax({
                type: 'Post',
                url: '../../Handler/GoodsHandler.ashx',
                cache: false,
                data: param,
                dataType: 'json',
                success: function (response) {
                    var newDivContent = '';
                    var index = 1;
                    if (!isEmpty(response)) {


                        for (var i = 0; i < response.length; i++) {
                            newDivContent += '<div class="compare_goods_grid_summarybox2" id="divsummaryOption' + index + '">';
                            newDivContent += '<table class="comparegoodssummarytable2">';

                            for (var j = 0; j < 21; j++) {

                                if (response[i]['OptionCol_' + j] != '' && response[i]['OptionCol_' + j] != '-' && response[i]['OptionCol_' + j] != null) {
                                    newDivContent += '<tr>';
                                    newDivContent += '<th style="width:50px">' + response[i]['OptionCol_' + j] + '';
                                    newDivContent += '</th>';
                                    newDivContent += '<td>' + response[i]['OptionVal_' + j] + '';
                                    newDivContent += '</td>';
                                    newDivContent += '</tr>';
                                }
                            }

                            newDivContent += '</table>';
                            newDivContent += '</div>';
                            index++;


                        }
                        $('.summarylist-parent-frame2').append(newDivContent);


                        var maxHeight = 0;
                        $(".compare_goods_grid_summarybox2").each(function () {
                            var thisH = $(this).height();
                            if (thisH > maxHeight) { maxHeight = thisH; }
                        });
                        $('.compare_goods_grid_summarybox2').css('height', maxHeight + 30);
                    }

                    return false;
                }
                ,
                error: function (xhr, status, error) {
                    if (xhr.readyState == 0 || xhr.status == 0) {
                        return; //Skip this error
                    }
                    alert('xhr: ' + xhr + 'status: ' + status + 'Error: ' + error + "\n오류가 발생했습니다. 잠시 후 다시 시도해 주세요.");
                }
            });
        }

        // 관심상품 담기
        function fnAddWish() {
            var svidUser = '<%= SvidUser%>';
            var role = '<%= SvidRole%>';
            if (role == 'C1' || role == 'BC1') {
                alert('권한이 없습니다.')
                return false;
            }

            if (svidUser == 'b3679112-1b92-4438-8bbc-862d363c91f3') {
                alert('게스트 계정은 관심상품 담기 기능을 이용할 수 없습니다.')
                return false;
            }
            var selectLength = $('.compare_goods_grid_box input[type="checkbox"]:checked').length;
            if (selectLength < 1) {
                alert('상품을 선택해 주세요');
                return false;

            }
            var callback = function (response) {
                if (!isEmpty(response)) {
                    $.each(response, function (key, value) {
                        if (value == "OK") {
                            alert('관심상품에 담겼습니다.');
                        }
                        else {
                            alert('시스템 오류입니다. 관리자에게 문의하세요');
                        }
                    });
                }
                return false;
            };

            var categoryArray = '';
            var groupCodeArray = '';
            var codeArray = '';
            $('.compare_goods_grid_box input[type="checkbox"]').each(function () {
                if ($(this).prop('checked') == true) {
                    var categoryCode = $(this).parent().find('#hdCategoryCode').val();
                    var goodsGroupCode = $(this).parent().find('#hdGroupCode').val();
                    var goodsCode = $(this).parent().find('#hdGoodsCode').val();
                    categoryArray += categoryCode + '/';
                    groupCodeArray += goodsGroupCode + '/';
                    codeArray += goodsCode + '/';
                }
            });
            var param = {
                Type: 'MultiSaveWishListByCart',
                SvidUser: '<%= SvidUser%>',
                GoodsFinCtgrCodes: categoryArray.slice(0, -1),
                GoodsGrpCodes: groupCodeArray.slice(0, -1),
                GoodsCodes: codeArray.slice(0, -1),
            };

            var beforeSend = function () {
                is_sending = true;
            }
            var complete = function () {
                is_sending = false;
            }

            if (is_sending) return false;
            JajaxDuplicationCheck('Post', '../Handler/WishHandler.ashx', param, 'json', callback, beforeSend, complete, true, '<%=SvidUser%>');

            return false;
        }

        // 장바구니 담기
        function fnAddCart() {
            var svidUser = '<%= SvidUser%>';
            var role = '<%= SvidRole%>';
            if (role == 'C1' || role == 'BC1') {
                alert('권한이 없습니다.')
                return false;
            }
            var selectLength = $('.compare_goods_grid_box input[type="checkbox"]:checked').length;
            if (selectLength < 1) {
                alert('상품을 선택해 주세요');
                return false;
            }
            if (svidUser == 'b3679112-1b92-4438-8bbc-862d363c91f3') {
                alert('게스트 계정은 장바구니 담기 기능을 이용할 수 없습니다.')
                return false;
            }
            var callback = function (response) {
                if (!isEmpty(response)) {
                    $.each(response, function (key, value) {
                        if (value == "OK") {
                            alert('장바구니에 담겼습니다.');
                        }
                        else {
                            alert('시스템 오류입니다. 관리자에게 문의하세요');
                        }
                    });
                }
                return false;
            };

            var categoryArray = '';
            var groupCodeArray = '';
            var codeArray = '';
            var qtyArray = '';
            $('.compare_goods_grid_box input[type="checkbox"]').each(function () {
                if ($(this).prop('checked') == true) {
                    var categoryCode = $(this).parent().find('#hdCategoryCode').val();
                    var goodsGroupCode = $(this).parent().find('#hdGroupCode').val();
                    var goodsCode = $(this).parent().find('#hdGoodsCode').val();
                    var goodsUnitMoq = $(this).parent().find('#hdGoodsUnitMoq').val();
                    categoryArray += categoryCode + '/';
                    groupCodeArray += goodsGroupCode + '/';
                    codeArray += goodsCode + '/';
                    qtyArray += goodsUnitMoq + '/';
                }
            });
            var param = {
                Flag: 'MultiSaveCartByWishList',
                SvidUser: '<%= SvidUser%>',
                GoodsFinCtgrCodes: categoryArray.slice(0, -1),
                GoodsGrpCodes: groupCodeArray.slice(0, -1),
                GoodsCodes: codeArray.slice(0, -1),
                RecommCode: '',
                Qtys: qtyArray.slice(0, -1),
            };

            var beforeSend = function () {
                is_sending = true;
            }
            var complete = function () {
                is_sending = false;
            }

            if (is_sending) return false;
            JajaxDuplicationCheck('Post', '../Handler/CartHandler.ashx', param, 'json', callback, beforeSend, complete, true, '<%=SvidUser%>');

            return false;
        }
    </script>
</head>
<body>
    <form id="form1" runat="server">
        <div class="sub-contents-div" style="width: 1450px; height: auto;">
            <!--제목타이틀영역-->
            <div class="sub-title-div" style="padding-left: 25px">
                <p class="p-title-mainsentence">
                    상품비교
                           <span class="span-title-subsentence">내가 고른 상품을 한눈에 비교할 수 있습니다.</span>
                </p>
            </div>


            <table class="title-event-table" style="margin-top: 5px;">

                <tr class="data-tr" style="width: 1450px; height: 330px; float: left;">
                    <!-- 비교상품은 5개 출력! 맨 앞자리 한칸은 비워주세요-->
                    <td>
                        <div style="width: 218px; height: 320px; margin-right: 00px; float: left">
                            <img src="../Images/Goods/compare_comment.jpg" />
                        </div>

                        <div style="float: right; width: auto; overflow: hidden">
                            <!--관심상품담기, 장바구니담기 버튼영역-->
                            <div style="margin-bottom: 20px; margin-right: 0px; text-align: right; width: auto">
                                <asp:ImageButton runat="server" ID="ibAddWish" AlternatedText="관심상품담기" ImageUrl="../Images/Goods/wish-off.jpg" onmouseover="this.src='../Images/Goods/wish-on.jpg'" onmouseout="this.src='../Images/Goods/wish-off.jpg'" CssClass="imgbtndisplaynone" OnClientClick="return fnAddWish();" />
                                <asp:ImageButton runat="server" ID="ibAddCart" AlternatedText="장바구니담기" ImageUrl="../Images/Goods/cart-on.jpg" onmouseover="this.src='../Images/Goods/cart-on.jpg'" onmouseout="this.src='../Images/Goods/cart-on.jpg'" CssClass="imgbtndisplaynone" OnClientClick="return fnAddCart();" />
                            </div>
                            <div class="list-parent-frame"></div>
                            <br style="clear: both" />
                            <div class="summarylist-parent-frame"></div>
                            <br style="clear: both" />
                            <div class="summarylist-parent-frame2"></div>
                        </div>
                    </td>
                </tr>



            </table>

            <%--<div class="title-event-table" style="float: left">
                <div style="width: 1012px; height: auto; border: 1px solid #a2a2a2; margin-left: 245px; min-height: 600px;">
                   
                   <div style="width: 198px; height: 598px; margin-right: 5px; padding: 5px 5px; border-right: 1px dotted #a2a2a2; float: left">
                        <div style="width: 186px; height: 580px;">비교데이터 영역</div>
                    </div>

                    <div style="width: 198px; height: 598px; margin-right: 5px; padding: 5px 5px; border-right: 1px dotted #a2a2a2; float: left">
                        <div style="width: 186px; height: 580px;">비교데이터 영역</div>
                    </div>

                    <div style="width: 198px; height: 598px; margin-right: 5px; padding: 5px 5px; border-right: 1px dotted #a2a2a2; float: left">
                        <div style="width: 186px; height: 580px;">비교데이터 영역</div>
                    </div>

                    <div style="width: 198px; height: 598px; margin-right: 5px; padding: 5px 5px; border-right: 1px dotted #a2a2a2; float: left">
                        <div style="width: 186px; height: 580px;">비교데이터 영역</div>
                    </div>

                    <div style="width: 198px; height: 598px; float: left; padding: 5px 5px;">
                        <div style="width: 186px; height: 580px;">비교데이터 영역</div>
                    </div>

                </div>
            </div>--%>
        </div>
    </form>
</body>
</html>
