$(function () {

    fnCategoryBind();
    var qs = fnGetQueryStrings();
    if (!isEmpty(sviduser)) {
        $('#divOrder').css('display', 'inline-block');
    }

    qsFinalCategoryCode = qs["CategoryCode"];
    qsBrandCode = qs["BrandCode"];
    bCodes = !isEmpty(qs["BrandCode"]) ? qs["BrandCode"] + '/' : '';
    qsBrandName = qs["BrandName"];
    qsGoodsName = qs["GoodsName"];
    qsGoodsModel = qs["GoodsModel"];
    qsGoodsCode = qs["GoodsCode"];
    qsType = qs["Type"];
    qsListType = qs["ListType"];
    qsSearchFlag = qs["SearchFlag"];
    qsOrderType = qs["OrderType"];
    qsReGoodsName = qs["ReGoodsName"];

    if (isEmpty(qsPageNo)) {
        qsPageNo = 1;
    }
    if (isEmpty(qsListType)) {
        qsListType = 'a';
    }

    if (qsListType == 'a') {
        $('#img_Grid').attr("src", '../Images/Goods/gridview-on.png');
        $('#img_List').attr("src", '../Images/Goods/listview-off.png');
    }
    else {
        $('#img_Grid').attr("src", '../Images/Goods/gridview-off.png');
        $('#img_List').attr("src", '../Images/Goods/listview-on.png');
    }

    $("#btnMoreBrand").on("click", function () {

        fnOpenDivLayerPopup('moreBranddiv');
    });

    $("#btnMoreBrandSearch").on("click", function () {

        var brandUl = $('.goodslist-brand-check-ul');
        var brandLl = $('.goodslist-brand-check-ul li');
        var code = $(".goodslist-brand-check-ul li").attr("data-code");
        //brandUl.empty();

        $('#ulMoreBrandList li').each(function () {
            var modalCheckbox = $(this).find('input[type="checkbox"]');
            if (modalCheckbox.is(':checked')) {

                //없으면 생성 data code가 같은게 있으면 li안에있는 것들중에 검사 
                if (code == modalCheckbox.val()) {
                    brandUl.empty();
                }
                brandUl.append('<li class="brand-check-li txt-center cd-' + modalCheckbox.val() + '" data-code="' + modalCheckbox.val() + '" onclick="fnBrandLiClick(this);"><span class="check-li-txt">' + modalCheckbox.next().text() + '</span><span class="brand-delete"><i class="fas fa-times"></i></span></li>');
            }
            else if (modalCheckbox.is(':checked')==false){
                if (code == modalCheckbox.val()) {

                    if ($('.goodslist-brand-check-ul li').length != 1) {
                        fnBrandLiClick(el);
                    } else {
                        brandUl.empty();
                      
                        return false;
                    }

                    return false;
                }
              
            }
            
        });


     
        fnGoodsListBind(1, listType, $('#hdOrderValue').val(), bCodes); //버튼클릭시 검색이 된다 되면서 뿌려줘야함 .. 선택한 조건 
        fnClosePopup('moreBranddiv');
    });

    $("#btnReset").on("click", function () {
        $('#ulBrandList li').find('input[type="checkbox"]').prop('checked', '');
        $('#ulMoreBrandList li').find('input[type="checkbox"]').prop('checked', '');
        $('#txtResGoodsName').val('');
        $('#txtResGoodsCode').val('');
        $('#txtResGoodsModel').val('');
        bCodes = '';
        qsBrandCode = '';
        qsBrandName = '';

    });

    $("#link_grid").on("mouseclick focus click", function () {
        $('#img_Grid').attr("src", '../Images/Goods/gridview-on.png');
        $('#img_List').attr("src", '../Images/Goods/listview-off.png');
    });

    $("#link_list").on("mouseclick focus click", function () {
        $('#img_Grid').attr("src", '../Images/Goods/gridview-off.png');
        $('#img_List').attr("src", '../Images/Goods/listview-on.png');
    });

    fnCtgrCurrentDepth(qsFinalCategoryCode);
    fnGoodsListBind(1, qsListType, '1', bCodes);
    fnBrandListBind(qsFinalCategoryCode, qsBrandCode, qsBrandName, qsGoodsModel, qsGoodsName);



})
   

//현재 카테고리 메뉴명 설정
function fnCtgrCurrentDepth(finalCode) {
    var param = { FinalCode: finalCode, Method: 'GetCtgrDepth' };
    var callback = function (response) {
        if (!isEmpty(response)) {
            $("#ddlCategory01").val(response.split(',')[0]);

            //하위 카테고리 정보 바인딩
            for (var i = 1; i <= response.split(',').length; i++) {
                fnSubCategoryBind(response.split(',')[i - 1], response.split(',')[i], i + 1);
            }
        }

        return false;
    };

    Jajax('Post', '../Handler/Common/CategoryHandler.ashx', param, 'json', callback);
}

function fnCertifyCheck() {

    var bCodes = '';
    var cbCertifiedVal = '';
    for (var i = 1; i < 6; i++) {
        var inputTag = $("input:checkbox[id='certify" + i + "']");
        var oneVal = '';

        if ($(inputTag).prop("checked")) {
            oneVal = '1';
        } else {
            oneVal = '0';
        }

        cbCertifiedVal += oneVal;
    }
    cbCertifiedVal += '000';
    $("#hdCertifyCode").val(cbCertifiedVal);
    fnGoodsListBind(1, listType, '1', bCodes);
}




function fnGoodsListBind(pageNum, type, orderVal, bCodes) {

    $('#hdLinkType').val(type);
    var compcode = '';
    var saleCompCode = '';
    var cartValue = $("#hdCertifyCode").val();
    if (!isEmpty(priceCompcode)) {
        compcode = priceCompcode;
    }
    else {
        compcode = 'EMPTY';
    }

    if (!isEmpty(saleCompcdoe)) {
        saleCompCode = saleCompcdoe;
    }
    else {
        saleCompCode = 'EMPTY';
    }


    if (qsSearchFlag != 'A') //검색플래그가 A(파워서치)를 제외하고
    {
        if (isEmpty(qsFinalCategoryCode) && isEmpty(qsBrandCode)) { //브랜드 체크박스를 다 해지했을경우 혹은 상품디테일에서 브랜드 전체보기 버튼을 클릭해서 넘어왔고 다시 브랜드 체크를 다 해지했을시.. 검색이 될수 있도록 파라미터 변경...
            if (qsSearchFlag.substring(0,1) == 'Y') { //카테고리랜딩
                qsSearchFlag = qsSearchFlag;
            }
            else if (qsSearchFlag.substring(0, 1) == 'G') { //배너
                qsSearchFlag = qsSearchFlag;
            }
            else {
                qsSearchFlag = 'B';  //카테고리 전체보기를 검색할때는 플래그가 B   카테고리 코드는 All로 넘어간다
                $('#divBrandArea').css('display', 'block');
            }
            qsFinalCategoryCode = '';
            qsBrandName = '';
            bCodes = '';
        }
        else if (!isEmpty(qsBrandCode) && !isEmpty(bCodes)) { //브랜드 검색시 검색 플래그 B
            $('#divBrandArea').css('display', 'block');
            if (qsFinalCategoryCode == 'All') {

                qsSearchFlag = 'B'; // 카테고리 전체보기를 검색할때는 플래그가 B   카테고리 코드는 All로 넘어간다
            }
            else {

                qsSearchFlag = 'R'; // 브랜드검색는 R로 넘어감

            }
        }
        else if (!isEmpty(qsFinalCategoryCode)) {
            $('#divBrandArea').css('display', 'block');
            if (qsFinalCategoryCode == 'All') {

                qsSearchFlag = 'B'; // 카테고리 전체보기를 검색할때는 플래그가 B   카테고리 코드는 All로 넘어간다
            }
            else {

                qsSearchFlag = 'C'; // 카테고리검색는 C로 넘어감

            }
        }

    }
    else {
        $('#divBrandArea').css('display', 'block');
        if (!isEmpty(qsBrandCode) && !isEmpty(bCodes)) { //브랜드 검색시 검색 플래그 B

            if (qsFinalCategoryCode == 'All') {

                qsSearchFlag = 'B'; // 카테고리 전체보기를 검색할때는 플래그가 B   카테고리 코드는 All로 넘어간다
            }
            else {

                qsSearchFlag = 'R'; // 브랜드검색는 R로 넘어감

            }
        }
        else if (!isEmpty(qsFinalCategoryCode)) {

            if (qsFinalCategoryCode == 'All') {

                qsSearchFlag = 'B'; // 카테고리 전체보기를 검색할때는 플래그가 B   카테고리 코드는 All로 넘어간다
            }
            else {

                qsSearchFlag = 'C'; // 카테고리검색는 C로 넘어감

            }
        }
    }

    //넘겨줄 매개변수
    var param = {
        Method: 'GetGoodsGroupListByCategoryCode'
        , CategoryCode: qsFinalCategoryCode
        , BrandCode: isEmpty(bCodes) ? qsBrandCode : bCodes.slice(0, -1)
        , BrandName: qsBrandName
        , GoodsName: qsGoodsName
        , ResGoodsName: isEmpty($('#txtResGoodsName').val()) ? qsReGoodsName : $('#txtResGoodsName').val()
        , GoodsModel: isEmpty($('#txtResGoodsModel').val()) ? qsGoodsModel : $('#txtResGoodsModel').val()
        , GoodsCode: isEmpty($('#txtResGoodsCode').val()) ? qsGoodsCode : $('#txtResGoodsCode').val()
        , OrderValue: orderVal
        , CertValue: cartValue
        , CompCode: compcode     //구매자 회사사업자번호와 똑같은 판매사 사업자 번호가 있으면 판매사 코드
        , SaleCompCode: saleCompCode
        , DongshinCheck: dsCheck
        , FreeCompanyYN: freeCompYN
        , FreeCompanyVatYN: freeCompanyVatYN
        , SvidUser: sviduser
        , SearchFlag: qsSearchFlag
        , PageNo: pageNum
        , PageSize: 20
    };

    $.ajax({
        type: 'Post',
        url: '../../Handler/GoodsHandler.ashx',
        cache: false,
        data: param,
        dataType: 'json',
        success: function (response) {
            var index = 0;
            var certifiCations = new Array(); //인증마그
            var newDivContent = '';
            var newListContent = '';
            if (!isEmpty(response)) {

                $('.search-emptywrap').css('display', 'none');
                $('#divEmptyMsg').css('display', 'none');
                $('#divDiscontinueMsg').css('display', 'none');
                $('#divGoodsReadyMsg').css('display', 'none');
                $("#spanFavorites").css('display', '');
                $("#img_Grid").css('display', '');
                $("#img_List").css('display', '');
                $("#middleBanner").css('display', '');
                $('#divOrder').css('display', 'inline-block');
                $('.goods_side_wrap').css('display', '');
                for (var i = 0; i < response.length; i++) {


                    var groupCount = response[i].GoodsGroupCount;
                    var finalCode = response[i].GoodsFinalCategoryCode;
                    totalCount = response[i].GroupListTotalCount;
                    $('#hdTotalCount').val(totalCount);
                    var goodsCode = response[i].GoodsCode;
                    var groupCode = response[i].GoodsGroupCode;
                    var goodsName = response[i].GoodsFinalName;
                    var orderDue = response[i].GoodsDeliveryOrderDue;
                    var goodsUnitMoq = response[i].GoodsUnitMoq;
                    var mapName = '';
                    var brandName = response[i].BrandName;
                    var price = '';
                    var tilde = '';
                    var priceHtml = '';
                    certifiCations.push(response[i].GoodsConfirmMark);
                    if (groupCount > 1) {
                        tilde = '~';
                    }
                    if (sviduser == '' || svidRole == 'T' || userId == 'socialwith') {
                        price = '(회원전용)';
                        priceHtml = '<span class="keep_words">' + price + '</span>';
                    }
                    else {

                        price = numberWithCommas(response[i].GoodsBuyPriceVat) + '원 ' + tilde;


                        if (isEmpty(response[i].GoodsDCPriceVat) || groupCount > 1) {
                            priceHtml = '<span class="keep_words">' + price + '</span>';
                        }
                        else {

                            priceHtml = '<span class="keep_words" style="text-decoration: line-through; font-size:13px">' + price + '</span>&nbsp; <span class="keep_words" style="color:red; ">' + numberWithCommas(response[i].GoodsDCPriceVat) + '원' + tilde + '</span>';
                        }
                    }





                    var goodsSpecial = response[i].GoodsSpecial;
                    var goodsFormat = response[i].GoodsFormat;
                    var goodsCause = response[i].GoodsCause;
                    var goodsSupplies = response[i].GoodsSupplies;


                    if (groupCount > 1) {
                        tilde = '~';
                    }


                    var mapNameDisplayStyle = 'style="visibility:hidden"';
                    //배송일 당일발송과 1일만 보이게
                    if (response[i].GoodsDeliveryOrderDue == '1' || response[i].GoodsDeliveryOrderDue == '2') {
                        mapNameDisplayStyle = '';
                        mapName = response[i].MapName;
                    }


                    var src = '/GoodsImage' + '/' + finalCode + '/' + groupCode + '/' + goodsCode + '/' + finalCode + '-' + groupCode + '-' + goodsCode + '-mmm.jpg';
                    
                    var returnSrc = '';
                    var detailPage = '';
                    //디테일 페이지 Querystring setting
                    if (groupCount > 1) {
                        detailPage = 'GoodsDetail.aspx?CategoryCode=' + finalCode + '&GroupCode=' + groupCode + '&BrandCode=' + response[i].BrandCode + '&GoodsCode=';
                    }
                    else {
                        detailPage = 'GoodsDetail.aspx?CategoryCode=' + finalCode + '&GroupCode=' + groupCode + '&GoodsCode=' + goodsCode + '&BrandCode=' + response[i].BrandCode;
                    }

                    var taxYn = response[i].GoodsSaleTaxYN;
                    var taxTag = '';
                    if (taxYn == "2") taxTag = "&nbsp;<label class='goods_textag'>면세</label>";
                    var spanPromotionDisplayFlag = '';
                    if (isEmpty(response[i].GoodsDCPriceVat)) {
                        spanPromotionDisplayFlag = 'display:none';
                    }

                    var spanCertMarkDisplay = '';
                    if (isEmpty(response[i].GoodsConfirmMark) || response[i].GoodsConfirmMark == '00000000') {
                        spanCertMarkDisplay = 'display:none';
                    }
                    if (pgFlag == 'Y') {

                        if (response[i].GoodsBuyPriceVat < 4000000 && index < 10) {
                            newDivContent += fnCreateGoodsGridTag(index, sviduser, src, groupCount, spanPromotionDisplayFlag, spanCertMarkDisplay, finalCode, groupCode, goodsCode, goodsUnitMoq, detailPage, mapNameDisplayStyle, brandName, mapName, goodsName, priceHtml, taxTag, goodsSpecial, goodsFormat, goodsCause, goodsSupplies);
                            newListContent += fnCreateGoodsListTag(index, sviduser, src, groupCount, spanPromotionDisplayFlag, spanCertMarkDisplay, finalCode, groupCode, goodsCode, goodsUnitMoq, detailPage, mapNameDisplayStyle, brandName, mapName, goodsName, priceHtml, taxTag, goodsSpecial, goodsFormat, goodsCause, goodsSupplies);
                            index++;
                        }
                    }
                    else {
                        /////그리드 바인딩
                        newDivContent += fnCreateGoodsGridTag(index, sviduser, src, groupCount, spanPromotionDisplayFlag, spanCertMarkDisplay, finalCode, groupCode, goodsCode, goodsUnitMoq, detailPage, mapNameDisplayStyle, brandName, mapName, goodsName, priceHtml, taxTag, goodsSpecial, goodsFormat, goodsCause, goodsSupplies);
                        newListContent += fnCreateGoodsListTag(index, sviduser, src, groupCount, spanPromotionDisplayFlag, spanCertMarkDisplay, finalCode, groupCode, goodsCode, goodsUnitMoq, detailPage, mapNameDisplayStyle, brandName, mapName, goodsName, priceHtml, taxTag, goodsSpecial, goodsFormat, goodsCause, goodsSupplies);
                        index++;
                    }

                }


                $('#divGrid').empty().append(newDivContent);
                $('#divList').empty().append(newListContent);
                for (var i = 0; i <= index; i++) {
                    SetCertifyImageSet(i, certifiCations);
                   
                }

            }
            else {
                $("#hdTotalCount").val(0);

                $("#spanFavorites").css('display', 'none');
                $("#img_Grid").css('display', 'none');
                $("#img_List").css('display', 'none');
                $("#middleBanner").css('display', 'none');
                $('#divGrid').empty();
                $('#divList').empty();
                if (qsType == 'ds') {
                    $('#spanGoodsCodekeyword').text(qsGoodsCode);
                    $('#spanGoodsNamekeyword').text(qsGoodsName);
                    $('#spanGoodsModelkeyword').text(qsGoodsModel);
                    $('#spanGoodsBrandkeyword').text(qsBrandName);
                    $('.search-emptywrap').css('display', 'block');
                    $('#divOrder').css('display', 'none');
                    $('.goods_side_wrap').css('display', 'none');
                }
                else if (qsType == 'link') {
                    $('#divDiscontinueMsg').css('display', 'block');
                }
                else {
                    if (qsSearchFlag == 'C') {
                        $('#divGoodsReadyMsg').css('display', 'block');
                    }
                    else {
                        $('#divEmptyMsg').css('display', 'block');
                        $('#noResultMsg').text(qsGoodsName);
                        $('#divOrder').css('display', 'none');
                        $('.goods_side_wrap').css('display', 'none');

                    }
                }
            }
            if (pgFlag != 'Y') {

                fnCreatePagination('pagination', $("#hdTotalCount").val(), pageNum, 20, getPageData);
                fnCreatePagination('paginationBottom', $("#hdTotalCount").val(), pageNum, 20, getPageDataBottom);
            }

            $(".goods_grid_box").hover(function () {
                $(this).find('.goods_icon_link').css('display', 'block');
                /*$(this).find('.goods_icon_link').css('background-color', 'hsl(213, 3%, 84%, 0.3)');*/
                
            }).on("mouseleave", function () {
                $(this).find('.goods_icon_link').css('display', 'none');
                /*$(this).find('.goods_icon_link').css('background-color', '#ffffff');*/

                });

            


            
            
            $("#divGoodsCount").empty().append('<span style="font-size:18px">' + numberWithCommas($('#hdTotalCount').val())+' </span><span>개의 상품이 있습니다.</span>');


            return false;
        }
        , beforeSend: function () {
            $('#divLoading').css('display', '');

        }
        , complete: function () {
            if (type == 'a') {

                $('#divGrid').css('display', '');
                $('#divList').css('display', 'none');
            }
            else if (type == 'b') {
                $('#divGrid').css('display', 'none');
                $('#divList').css('display', '');
            }
            $('#divLoading').css('display', 'none');
        },
        error: function (xhr, status, error) {
            if (xhr.readyState == 0 || xhr.status == 0) {
                return; //Skip this error
            }
            alert('xhr: ' + xhr + 'status: ' + status + 'Error: ' + error + "\n오류가 발생했습니다. 잠시 후 다시 시도해 주세요.");
        }
    });

}

//
function fnCreateGoodsGridTag(index, sviduser, src, groupCount, spanPromotionDisplayFlag, spanCertMarkDisplay, finalCode, groupCode, goodsCode, goodsUnitMoq, detailPage, mapNameDisplayStyle,  brandName, mapName, goodsName, priceHtml, taxTag, goodsSpecial, goodsFormat, goodsCause, goodsSupplies) {
    var newDivContent = '';
    var newListContent = '';
    /////그리드 바인딩
    newDivContent += '<div class="goods_grid_box item" >';
    newDivContent += '<div class="goods_grid_number"><span class="item_cnt">상품 ' + groupCount + '종</span>&nbsp;<span id="spanPromotion" class="product_Promotion_text" style="' + spanPromotionDisplayFlag + '">특가!!</span><span class="goods_certify" title="" other-title="" id="spanCertifyTooltip' + index + '" style=" ' + spanCertMarkDisplay + '">*인증상품</span></div>';
    newDivContent += '<div style="position: relative;">';
    newDivContent += '<div class="goods_icon_link"><div>';

    if (groupCount == 1 && !isEmpty(sviduser)) {
        newDivContent += '<a class="goods_icon_cart" style="text-decoration:none; " title="장바구니 추가" onclick="fnAddCart(\'' + finalCode + '\',\'' + groupCode + '\',\'' + goodsCode + '\',\'' + goodsUnitMoq + '\');"><img src="../Images/Goods/cart.png" alt="장바구니"> </a>';
        newDivContent += '<a class="goods_icon_wish" style="text-decoration:none" title="찜하기" onclick="fnAddWish(\'' + finalCode + '\',\'' + groupCode + '\',\'' + goodsCode + '\');"><img src="../Images/Goods/wishlist.png" alt="찜하기"> </a>';

    }
    
    newDivContent += '<a class="goods_icon_detail" style="text-decoration:none" target="_blank" title="새창으로 상세보기" href="' + detailPage + '"><img src="../Images/Goods/detail.png" alt="상세" ></a>';
    newDivContent += '</div></div>';
    newDivContent += '<a href="' + detailPage + '"><div class="goods_grid_image"><img onerror="no_image(this, \'m\')" src="' + src + '" alt="' + goodsName + '" title="' + goodsName + '"/></div>';
    newDivContent += '<div class="goods_manufacturers"><span class="goods_brand">' + brandName + '</span>';
    newDivContent += '<span class="goods_today" ' + mapNameDisplayStyle + ' >' + mapName + '<span></div>';
    newDivContent += '<h3>' + goodsName + '</h3>';
    
    newDivContent += '<div style="color:#2d5c84;padding-bottom:5px;"></div>';

    
    newDivContent += '<div class="goods_price price" >' + priceHtml + '' + taxTag + '</div></a></div>';
    newDivContent += '</div>';
    

    return newDivContent;

}

function fnCreateGoodsListTag(index, sviduser, src, groupCount, spanPromotionDisplayFlag, spanCertMarkDisplay, finalCode, groupCode, goodsCode, goodsUnitMoq, detailPage, mapNameDisplayStyle, brandName, mapName, goodsName, priceHtml, taxTag, goodsSpecial, goodsFormat, goodsCause, goodsSupplies) {
    var newListContent = '';
    
    /////리스트 바인딩
    newListContent += '<div class="goods_list_box item">';
    newListContent += '<div style="float:left; padding-left:20px;">';
    newListContent += '<div class="goods_list_number" style="clear:both"><span class="item_cnt">상품 ' + groupCount + '종' + taxTag + '</span>&nbsp;<span id="spanPromotion"  class="product_Promotion_text" style="' + spanPromotionDisplayFlag + '">특가!!</span><span title="" other-title="" id="spanListCertifyTooltip' + index + '" style="float:right; cursor:default; font-weight: bold; color: #050099; ' + spanCertMarkDisplay + '">*인증상품</span></div>';
    newListContent += '<div class="goods_list_image" style="clear:both"><a href="' + detailPage + '"><img style="width: 140px; height:140px;"  onerror="no_image(this, \'m\')" src="' + src + '" alt="' + goodsName + '" title="' + goodsName + '"/></a></div>';
    newListContent += '</div>';
    newListContent += '<div class="goods_list_info"><h3 class="txt" style=" display:inline; height:36px; width:100%; line-height:15px; font-size:12px; font-weight:bold;"><a style="color:#444; font-size:14px" href="' + detailPage + '" title="' + goodsName + '">' + goodsName + '</a></h3><br>';
    newListContent += '<div class="goods_manufacturers" style="padding-top:9px; font-size:12px; color:#69696c;"><span class="goods_brand" >' + brandName + '</span>';
    newListContent += '<span class="goods_today" ' + mapNameDisplayStyle + '>' + mapName + '<span></div><br>';
    newListContent += '<div class="goods_price price" style=" display:inline;">' + priceHtml + '</div><span style="width:20px; display:inline-block"></span><br>';

    if (goodsSpecial != '') {
        newListContent += '<div style="margin-top:9px">' + "<span style='font-weight:bold'>특징</span> : " + goodsSpecial + '</div><br>';
    }
    if (goodsFormat != '') {
        newListContent += '<div style="margin-top:9px">' + "<span style='font-weight:bold'>형식</span> : " + goodsFormat + '</div><br>';
    }
    if (goodsCause != '') {
        newListContent += '<div style="margin-top:9px">' + "<span style='font-weight:bold'>주의사항</span> : " + goodsCause + '</div><br>';
    }
    if (goodsSupplies != '') {
        newListContent += '<div style="margin-top:9px">' + "<span style='font-weight:bold'>용도</span> : " + goodsSupplies + '</div><br>';
    }
    newListContent += '<div style="color:#2d5c84;padding-bottom:5px;"></div></div>';
    newListContent += '<div class="goods_gridicon_wrap">';
    if (groupCount == 1 && !isEmpty(sviduser)) {
        newListContent += '<a class="goods_gridicon_cart" title="장바구니 추가" onclick="fnAddCart(\'' + finalCode + '\',\'' + groupCode + '\',\'' + goodsCode + '\',\'' + goodsUnitMoq + '\')" ></a>';
        newListContent += '<a class="goods_gridicon_wish"  title="찜하기" onclick="fnAddWish(\'' + finalCode + '\',\'' + groupCode + '\',\'' + goodsCode + '\');"></a>';

    }
    newListContent += '<a class="goods_gridicon_detail"  target="_blank" title="새창으로 상세보기" href="' + detailPage + '" ></a>';
    newListContent += '</div>';
    newListContent += '</div>';

    return newListContent;

}

//인증마크
function SetCertifyImageSet(index, certMark) {
    $('#spanCertifyTooltip' + index).tooltip({ //그리드 툴팁
        items: '[other-title]',
        content: function () {
            var html = '';
            html = "<div>";
            if (certMark[index].substring(0, 1) == '1') {
                html += "<img class='map' alt= '사회적기업' src='" + upload + "CertificationImage/01.jpg' style='padding:5px'/>";

            }
            if (certMark[index].substring(1, 2) == '1') {
                html += "<img class='map' alt= '한국여성경제인협회' src='" + upload + "/CertificationImage/02.jpg' style='padding:5px'/>";

            }
            if (certMark[index].substring(2, 3) == '1') {
                html += "<img class='map' alt= '장애인표준사업장' src='" + upload + "/CertificationImage/03.jpg' style='padding:5px'/>";

            }
            if (certMark[index].substring(3, 4) == '1') {
                html += "<img class='map' alt= 'COOP협동조합' src='" + upload + "/CertificationImage/04.jpg' style='padding:5px'/>";

            }
            if (certMark[index].substring(4, 5) == '1') {
                html += "<img class='map' alt= '중증장애인생산품' src='" + upload + "/CertificationImage/05.jpg' style='padding:5px'/>";

            }
            if (certMark[index].substring(5, 6) == '1') {
                html += "<img class='map' alt= '' src='" + upload + "/CertificationImage/06.jpg' style='padding:5px'/>";

            }
            if (certMark[index].substring(6, 7) == '1') {
                html += "<img class='map' alt= '' src='" + upload + "/CertificationImage/07.jpg' style='padding:5px'/>";

            }
            if (certMark[index].substring(7, 8) == '1') {
                html += "<img class='map' alt= '' src='" + upload + "UploadFile/CertificationImage/08.jpg' style='padding:5px'/>";

            }
            html += "</div>";
            return html;
        },
        position: {
            my: "center bottom",
            at: "center top-6",
        }
    });
    //리스트 툴팁 
    $('#spanListCertifyTooltip' + index).tooltip({
        items: '[other-title]',
        content: function () {
            var html = '';
            html = "<div>";
            if (certMark[index].substring(0, 1) == '1') {
                html += "<img class='map' alt= '사회적기업' src='" + upload + "CertificationImage/01.jpg' style='padding:5px'/>";

            }
            if (certMark[index].substring(1, 2) == '1') {
                html += "<img class='map' alt= '한국여성경제인협회' src='" + upload + "/CertificationImage/02.jpg' style='padding:5px'/>";

            }
            if (certMark[index].substring(2, 3) == '1') {
                html += "<img class='map' alt= '장애인표준사업장' src='" + upload + "/CertificationImage/03.jpg' style='padding:5px'/>";

            }
            if (certMark[index].substring(3, 4) == '1') {
                html += "<img class='map' alt= 'COOP협동조합' src='" + upload + "/CertificationImage/04.jpg' style='padding:5px'/>";

            }
            if (certMark[index].substring(4, 5) == '1') {
                html += "<img class='map' alt= '중증장애인생산품' src='" + upload + "/CertificationImage/05.jpg' style='padding:5px'/>";

            }
            if (certMark[index].substring(5, 6) == '1') {
                html += "<img class='map' alt= '' src='" + upload + "/CertificationImage/06.jpg' style='padding:5px'/>";

            }
            if (certMark[index].substring(6, 7) == '1') {
                html += "<img class='map' alt= '' src='" + upload + "/CertificationImage/07.jpg' style='padding:5px'/>";

            }
            if (certMark[index].substring(7, 8) == '1') {
                html += "<img class='map' alt= '' src='" + upload + "UploadFile/CertificationImage/08.jpg' style='padding:5px'/>";

            }
            html += "</div>";
            return html;
        },
        position: {
            my: "center bottom",
            at: "center top-6",
        }
    });
}

function getPageData() {

    var container = $('#pagination');
    var getPageNum = container.pagination('getSelectedPageNum');
    $('#paginationBottom').pagination('go', getPageNum);
    var linkType = $("#hdLinkType").val();

    //  var url = 'GoodsList.aspx?CategoryCode=' + qsFinalCategoryCode + '&BrandCode=' + qsBrandCode + '&BrandName=' + qsBrandName + '&GoodsName=' + qsGoodsName + '&GoodsModel=' + qsGoodsModel + '&BrandCode=' + qsBrandCode + '&GoodsCode=' + qsGoodsCode + '&Type=' + qsType + '&ListType=' + qsListType + '&PageNo=' + getPageNum + '&OrderType=' + $('#hdOrderValue').val();
    fnGoodsListBind(getPageNum, listType, $('#hdOrderValue').val(), bCodes);

    //  location.href = url;
    return false;
}

function getPageDataBottom() {
    var container = $('#paginationBottom');
    var getPageNum = container.pagination('getSelectedPageNum');
    $('#pagination').pagination('go', getPageNum);
    var linkType = $("#hdLinkType").val();

    fnGoodsListBind(getPageNum, listType, $('#hdOrderValue').val(), bCodes);
    return false;
}

function fnLinkType(type) {

    if (type == 'grid') {
        $('#divGrid').css('display', '');
        $('#divList').css('display', 'none');
        listType = 'a';
        $('#hdListType').val('a');
    }
    else {
        $('#divGrid').css('display', 'none');
        $('#divList').css('display', '');
        $('#hdListType').val('b');
        listType = 'b';
    }
}

function fnOrderListBind(el, type) {

    $(el).parent().parent().find('a').removeClass('active');
    $(el).addClass('active');
    $('#hdOrderValue').val(type); //정렬값 저장

    var listType = qsListType;
    if (!isEmpty(qsListType)) {
        if (!isEmpty($('#hdListType').val())) {
            listType = $('#hdListType').val();
        }
        else {
            listType = 'a';
        }
    }

    fnGoodsListBind(1, listType, type, bCodes);

}


// 즐겨찾기 추가 
function addBookmark() {

    var title = $("#titleT").text();
    var url = location.href.replace('&ListType=b', '').replace('&ListType=a', '');

    if (window.sidebar && window.sidebar.addPanel) {  //Firefox
        window.sidebar.addPanel(title, url, "");
    } else if (window.opera && window.print) {  //opera
        var elem = decument.createElement('a');
        elem.setAttribute('href', url);
        elem.setAttribute('title', title);
        elem.setAttribute('rel', 'sidebar');
        elem.click();
    }
    else if (navigator.userAgent.indexOf("MSIE") > -1 || (window.external && ('AddFavorite' in window.external))) { //IE
        window.external.AddFavorite(url, "[소셜위드] " + title + " 즐겨찾기");
    } else if (navigator.userAgent.indexOf("Chrome") > -1) {  //크롬 
        alert("이용하시는 웹 브라우저는 기능이 지원되지 않습니다. Ctrl+D 키를 누르시면 즐겨찾기에 추가하실 수 있습니다.");
        return true;
    }
}

var is_sending = false;

//장바구니 담기
function fnAddCart(ctgrCode, groupCode, goodsCode, goodsUnitMoq) {

    if (userId == 'socialwith') {
        alert('게스트 계정은 이용할 수 없습니다.');
        return false;
    }

    if (isEmpty(sviduser)) {
        alert('로그인후 이용해 주세요.')
        return false;
    }



    var callback = function (response) {
        if (!isEmpty(response)) {
            $.each(response, function (key, value) {
                if (value == "OK") {
                    if (!confirm('장바구니에 담겼습니다. 바로 확인하시겠습니까?')) {
                        return false;
                    }
                    else {
                        location.href = '../Cart/CartList.aspx';
                    }

                    return false;
                }
                else {
                    alert('시스템 오류입니다. 관리자에게 문의하세요.');
                }
            });
        }
        return false;
    };

    if (isEmpty(goodsUnitMoq)) {
        goodsUnitMoq = 1;
    }
    var param = {
        SvidUser: sviduser,
        GoodsFinCtgrCodes: ctgrCode,
        GoodsGrpCodes: groupCode,
        GoodsCodes: goodsCode,
        Qtys: goodsUnitMoq,
        RecommCode: '',
        Flag: 'MultiSaveCartByWishList'
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

// 관심상품 담기
function fnAddWish(ctgrCode, groupCode, goodsCode) {
    if (userId == 'socialwith') {
        alert('게스트 계정은 이용할 수 없습니다.');
        return false;
    }

    if (isEmpty(sviduser)) {
        alert('로그인후 이용해 주세요.')
        return false;
    }

    var callback = function (response) {

        if (response.Result == 'OK') {
            if (!confirm('상품을 찜하기에 추가했습니다. 바로 확인하시겠습니까?')) {
                return false;
            }
            else {
                location.href = '../../Wish/WishList.aspx';
            }

        }
        else {
            alert('시스템 오류입니다. 관리자에게 문의하세요.');
        }
        return false;
    };
    var param = {
        Type: 'MultiSaveWishListByCart',
        SvidUser: sviduser,
        GoodsFinCtgrCodes: ctgrCode,
        GoodsGrpCodes: groupCode,
        GoodsCodes: goodsCode,
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

//카테고리 리스트 바인드(레벨1)
function fnCategoryBind() {
    fnSelectBoxClear(1);
    var callback = function (response) {

        if (!isEmpty(response)) {

            var ddlHtml = "";

            $.each(response, function (key, value) {

                ddlHtml += '<option value="' + value.CategoryFinalCode + '">' + value.CategoryFinalName + '</option>';
            });

            $("#ddlCategory01").append(ddlHtml);


        }
        return false;
    };


    var param = {
        LevelCode: '1',
        UpCode: '',
        Method: 'GetCategoryLevelList'
    };

    JajaxSessionCheck('Post', '../../Handler/Common/CategoryHandler.ashx', param, 'json', callback, sviduser);
}

//상위레벨 카테고리 선택시 하위 카테고리 리스트 바인드
function fnChangeSubCategoryBind(el, level) {



    for (var i = level; i < 10; i++) {
        fnSelectBoxClear(i);
    }

    var callback = function (response) {

        if (!isEmpty(response)) {

            var ddlHtml = "";

            $.each(response, function (key, value) {
                ddlHtml += '<option value="' + value.CategoryFinalCode + '">' + value.CategoryFinalName + '</option>';
            });

            var id = '';

            if (level == '10') {
                id = level;
            }
            else {
                id = '0' + level;
            }
            $("#ddlCategory" + id).append(ddlHtml); ddlCategory

        }
        return false;
    };

    var param = {
        LevelCode: level,
        UpCode: selectedVal,
        Method: 'GetCategoryLevelList'
    };

    JajaxSessionCheck('Post', '../../Handler/Common/CategoryHandler.ashx', param, 'json', callback, sviduser);

}

//디폴트 서브카테고리 바인드
function fnSubCategoryBind(upcode, code, level) {
    var callback = function (response) {

        if (!isEmpty(response)) {

            var ddlHtml = "";

            $.each(response, function (key, value) {
                ddlHtml += '<option value="' + value.CategoryFinalCode + '">' + value.CategoryFinalName + '</option>';
            });

            var id = '';

            if (level == '10') {
                id = level;
            }
            else {
                id = '0' + level;
            }
            $("#ddlCategory" + id).append(ddlHtml);
            code = !isEmpty(code) ? code : 'All';
            $("#ddlCategory" + id).val(code);

        }
        //fnGoodsListBind(1, $("#hdLinkType").val(), $('#hdOrderValue').val(),bCodes);
        return false;
    };

    var param = {
        LevelCode: level,
        UpCode: upcode,
        Method: 'GetCategoryLevelList'
    };

    JajaxSessionCheck('Post', '../../Handler/Common/CategoryHandler.ashx', param, 'json', callback, sviduser);

}

//카테고리 리스트 클리어
function fnSelectBoxClear(index) {

    var id = '';

    if (index == '10') {
        id = index;
    }
    else {
        id = '0' + index;
    }


    $("#ddlCategory" + id).empty();
    $("#ddlCategory" + id).append('<option value="All">---전체---</option>');
    return false;

}


//브랜드 사이드메뉴
function fnBrandListBind(FinalCategoryCode, BrandCode, BrandName, GoodsModel, GoodsName) {
    $('#ulBrandList').empty();
    var cnt = 0; //브랜드 리스트 카운트
    var brandCallback = function (response) {

        if (!isEmpty(response)) {

            $.each(response, function (key, value) { //테이블 추가
                var name = value.BrandName;

                var checkedFlag = '';
                if (!isEmpty(qsBrandCode) && qsBrandCode.includes(value.BrandCode)) {
                    checkedFlag = 'checked="checked"';
                }

                if (cnt < 10) {

                    $('#ulBrandList').append('<li><input type="checkbox" ' + checkedFlag + ' text="' + name + '" id="' + value.BrandCode + '" value="' + value.BrandCode + '" style="" onclick="fnBrandChClick(this);"><label for="' + value.BrandCode + '"><span></span>' + name + '</label></li>');
                }

                $('#ulMoreBrandList').append('<li><input type="checkbox" ' + checkedFlag + ' text="' + name + '" id="more' + value.BrandCode + '" value="' + value.BrandCode + '"  onclick="fnMoreBrandChClick(this);"><label for="more' + value.BrandCode + '"><span></span>' + name + '</label></li>');

                cnt++;
            });
        }
    }

    var brandParam = {
        Method: 'GetBrandListTop10',
        FinalCode: !isEmpty(FinalCategoryCode) ? FinalCategoryCode : 'All',
        BrandCode: BrandCode,
        BrandName: BrandName,
        GoodsModel: GoodsModel,
        Keyword: GoodsName,
        CompCode: compCode,
        SaleCompCode: saleCompcdoe,
        BCheck: dsCheck
    };
    Jajax('Post', '../../Handler/Common/BrandHandler.ashx', brandParam, 'json', brandCallback);

    return false;
}


//체크 한 부분 표시 
function fnBrandLiClick(el) {


    var li = $("#ulBrandList").children('li');
    var moreLi = $("#ulMoreBrandList").children('li');
    
  
    var code = $(el).attr("data-code");
    var check = li.children('#'+code);
    var checkPop = moreLi.children('#more'+code);

    check.prop('checked', '');
    checkPop.prop('checked', '');
    $(el).remove();
    bCodes = '';

    li.each(function () {

        var checkbox = $(this).find('input[type="checkbox"]');
        if (checkbox.is(':checked')) { //체크인것만
            bCodes += checkbox.val() + '/';
        } 
    });
    moreLi.each(function () { //팝업창

        var checkbox = $(this).find('input[type="checkbox"]');
        if (checkbox.is(':checked')) {
            bCodes += checkbox.val() + '/';
        }
    });
    qsBrandCode = bCodes.slice(0, -1);
    fnGoodsListBind(1, listType, $('#hdOrderValue').val(), bCodes);

   
}

function fnBrandChClick(el) {
    bCodes = '';
    var parentCheckbox = $(el);
    var brandUl = $('.goodslist-brand-check-ul'); //체크한거 보여주는

 

    $('#ulMoreBrandList li').each(function () {
        var modalCheckbox = $(this).find('input[type="checkbox"]');
        if (modalCheckbox.val() == parentCheckbox.val()) {
            if (parentCheckbox.is(':checked')) {
                modalCheckbox.prop('checked', 'checked');
                //붙여주기
                brandUl.append('<li class="brand-check-li txt-center cd-' + parentCheckbox.val() + '" data-code="' + parentCheckbox.val() +'" onclick="fnBrandLiClick(this);"><span class="check-li-txt">' + parentCheckbox.next().text() + '</span><span class="brand-delete"><i class="fas fa-times"></i></span></li>');
            }
            else {
                modalCheckbox.prop('checked', '');
               //체크가 해제 되면 삭제되기 
                brandUl.children('.cd-' + parentCheckbox.val() + '').remove();
            }
        }
    });

    $('#ulBrandList li').each(function () {

        var checkbox = $(this).find('input[type="checkbox"]');
        if (checkbox.is(':checked')) {
            bCodes += checkbox.val() + '/';
        }
    });

    qsBrandCode = bCodes.slice(0, -1);
    fnGoodsListBind(1, listType, $('#hdOrderValue').val(), bCodes);
}

function fnMoreBrandChClick(el) {
    bCodes = '';
    var modalCheckbox = $(el);

    $('#ulBrandList li').each(function () {

        var parentCheckbox = $(this).find('input[type="checkbox"]');
        if (modalCheckbox.val() == parentCheckbox.val()) {
            if (modalCheckbox.is(':checked')) {
                parentCheckbox.prop('checked', 'checked');
            }
            else {
                parentCheckbox.prop('checked', '');
            }
        }
    });

    $('#ulMoreBrandList li').each(function () {

        var checkbox = $(this).find('input[type="checkbox"]');
        if (checkbox.is(':checked')) {
            bCodes += checkbox.val() + '/';
        }
    });

    qsBrandCode = bCodes.slice(0, -1);
}

function fnSearchGoodsList() {

    var linkType = listType;

    fnGoodsListBind(1, linkType, $('#hdOrderValue').val(), bCodes);
}

function fnCategoryChanged(el, level) {

    var ctgrCode = $(el).val();
    var searchType = 'C';
    if ($(el).val() == 'All') {
        if (level == 1) {
            ctgrCode = 'All';
            searchType = 'B';
        }
        else if (level == 2) {
            ctgrCode = $('#ddlCategory01').val();
        }
        else if (level == 3) {
            ctgrCode = $('#ddlCategory02').val();
        }
        else if (level == 4) {
            ctgrCode = $('#ddlCategory03').val();
        }
        else if (level == 5) {
            ctgrCode = $('#ddlCategory04').val();
        }
    }

    var goodsName = '';
    if (!isEmpty(qsGoodsName)) {
        goodsName = qsGoodsName
    }

    var brandCode = '';
    if (!isEmpty(qsBrandCode)) {
        brandCode = qsBrandCode
    }
    var params = 'CategoryCode=' + ctgrCode + '&BrandCode=&BrandName=' + '' + '&GoodsName=' + goodsName + '&GoodsModel=' + $('#txtResGoodsModel').val() + '&GoodsCode=' + $('#txtResGoodsCode').val() + '&ListType=' + listType + '&SearchFlag=' + searchType + '&OrderType=' + $('#hdOrderValue').val();
    location.href = 'GoodsList.aspx?' + params;
}

function fnGoodsReSearchEnter() {

    if (event.keyCode == 13) {
        fnGoodsListBind(1, listType, $('#hdOrderValue').val(), bCodes);
        return false;
    }
    else
        return true;
}

function fnToggle(){
    var grb = $(".goodslist-research-brand");
    var gbcv = $(".goodslist-brand-check-view")

    if (grb.css("display") == "none") {
        grb.show();
        gbcv.show();
        $(".fas").removeClass("fa-angle-down");
        $(".fas").addClass("fa-angle-up");
    } else {
        grb.hide();
        gbcv.hide();
        $(".fas").removeClass("fa-angle-up");
        $(".fas").addClass("fa-angle-down");
    }

}



