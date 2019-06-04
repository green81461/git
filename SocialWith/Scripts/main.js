$(function () {
    //if (userId != 'socialwith') { //게스트계정 메뉴 접근 막기

    //    $('#liStickyCart').css('display', '');
    //    $('#liCategoryNewGood').css('display', '');
    //    $('#liCategoryWish').css('display', '');
    //    $('#ulRightInfo li.mypage').css('display', '');
    //    $('#libottomCart').css('display', '');
    //}

    if (buyCompName.indexOf('가스공사') > -1) { //일단 구매사가 가스공사일때 행동강령 보여주기
        $('#bottomMenuLiConduct').css('display', '');
    }

    if ($('#divTopmenu').height() > 0) {
        quick_top = 250;
        srcollTop = 200;
        fixTop = 89;

    }
    else {
        quick_top = 190;
        srcollTop = 140;
        fixTop = 29
    }


    if (fnGetCookie('floatDisplay') == 'Y' || isEmpty(fnGetCookie('floatDisplay'))) {
        $('.btn_BtmDown').css('display', 'block');
        $('.btn_BtmUp').css('display', 'none');
        $('.floatbar').css('display', 'block');
    }
    else {
        $('.btn_BtmDown').css('display', 'none');
        $('.btn_BtmUp').css('display', 'block');
        $('.floatbar').css('display', 'none');
    }

    $('#txtPowerSearch').val(GoodsName);



    fnSetSiteDist();  //기본 사이트 배포관리 정보 갖고오기
    fnAutoComplete();
    DefaultDataBind();
    fnGetCategorySearchLog(); // 최근 선택한 카테고리
    fnGetPopularGoodsList(); //인기상품 베스트5
    if (!isEmpty(sviduser)) {
        fnGetGoodsRecommInfo();
    }

    if (!isEmpty(priceCompcode)) {
        compCode = priceCompcode
    }
    else {
        compCode = 'EMPTY';
    }

    if (!isEmpty(saleCompcode)) {
        saleCompCode = saleCompcode;
    }
    else {
        saleCompCode = 'EMPTY';
    }


    fnMdRecommand();



    $('#spanCustTelNo').text($('#hdMasterCustTelNo').val());
    $('#spanCustTelNo2').text($('#hdMasterCustTelNo').val());

    $('.navi-AllCategoryList > ul > li').hover(function () {
        $('.navi-AllCategoryList > ul > li').removeClass('active');
        $('.navi-AllCategoryList > ul > li > ul > li .divCategoryLevel02 > ul > li').removeClass('active');

        $(this).addClass('active');
        $(this).find('ul > li .divCategoryLevel02 > ul > li:first').addClass('active');

    }, function () {

        $('.navi-AllCategoryList > ul > li').removeClass('active');

    });

    $('.navi-AllCategoryList > ul > li > ul > li .divCategoryLevel02 > ul > li').hover(function () {
        $(this).parent().find('li').removeClass('active');
        $(this).addClass('active')
    });

    //최근본 카테고리 삭제
    $('#pDeleteCategorySearchLog').click(function () {

        fnCategorySearchLogDelete();
        return false;
    });

    $('#btnClosePop').click(function () {

        if ($('#cbGoodsRecomm').is(':checked')) {
            fnGoodRecommConfimUpdate();
        }
        else {
            $('#pop').hide();
        }
    });

    $('#btnGoRecomm').click(function () {

        if ($('#cbGoodsRecomm').is(':checked')) {
            fnGoodRecommConfimUpdate();

        }
        location.href = '/Goods/GoodsRecommListSearch.aspx';
        return false
    });

    $('#btnRollStart').click(function () {

        $(this).css('display', 'none');
        $('#btnRollStop').css('display', 'block')
    });

    $('#btnRollStop').click(function () {

        $(this).css('display', 'none');
        $('#btnRollStart').css('display', 'block')
    });

    $('#btnBannerPrev').click(function () {
        fnPrevImageSlide();
        return false;

    });

    $('#btnBannerNext').click(function () {
        fnNextImageSlide();
        return false;
    });

    setInterval(function () {
        if ($('ul#ulrollTab').is(':hover') == false) {
             fnNextImageSlide();
        }
    }, 5000);

    /* 메인카테고리 즐겨찾기 이벤트 */
    $('.btn-my').click(function () {
        $(this).parent().siblings('.my-category').show();
    });
    $('.my-category').click(function () {
        $(this).hide();
    });

    /* S. 최상단 배너 영역 노출 여부 */
    if ($('#divTopmenu').height() <= 1) {
        $('#btnTopMenuCls').hide();
        //fnTopmenuCookieChk();
    } else {
        $('#btnTopMenuCls').show();
        //fnTopmenuCookieChk();
    }

    $('#btnTopMenuCls').on("click", function (e) {
        e.preventDefault();
        fnSetCookie('divTopMenu', 'N', 1, '/', '');
        $('#divTopmenu').slideUp();
    });

    /* 하단 영역 버튼 */
    $('.btn_BtmDown').click(function () {
        $('.floatbar').slideUp();
        $(this).css('display', 'none');
        $('.btn_BtmUp').css('display', 'block');

        fnSetCookie('floatDisplay', "N", 1, '/', '');
    });
    $('.btn_BtmUp').click(function () {
        $('.floatbar').slideDown();
        $(this).css('display', 'none');
        $('.btn_BtmDown').css('display', 'block');
        fnSetCookie('floatDisplay', "Y", 1, '/', '');
    });

    //푸터용 최근본 상품
    $(".moreGoods").length && curViewGoods.init();

    //푸터용 검색창
    $(".searchBar").length && footSearch.init();



    //best상품 

    $('.main-best-tab li').click(function () {
        $(this).parent().find('li').removeClass('active');
        $(this).addClass('active');

        var flag = $(this).attr('id').substring(2);
        if (flag == 'All') {
            $('.goods_md_recommand').css('display', 'block');
        }
        else {
            $('.goods_md_recommand').css('display', 'none');
            $('div.goods_md_recommand[ctgrflag="' + flag + '"]').css('display', 'block');
        }
    });


    //스틱키메뉴 마이페이지
    $('.mypage').hover(function () { $('.mypage_sub_menu').css('display', 'block'); }, function () { });
    $('.mypage_sub_menu').hover(function () { }, function () { $(this).css('display', 'none'); });


});

/* S. 최상단 배너 영역 노출 여부 */
//function fnTopmenuCookieChk() {
//    if (fnGetCookie("divTopMenu") != "N") {
//        $('#divTopmenu').show();
//    } else {
//        $('#divTopmenu').hide();
//    }
//}

function isHovered(selector) {

    return $(selector + ":hover").length > 0

}

function fnGetSiteDistPackage() {

    var callback = function (response) {

        //fnGetDistMenu(response["table_1"]);   //메뉴
        fnGetDistRoll(response["table_2"]);    //롤링배너
        fnGetDistCategoryLanding(response["table_3"]); //카테고리 랜딩
        fnGetDistDiperson(response["table_4"]); //중간배너
        fnGetDistPartner(response["table_5"]); //협력사 
        fnDistPopup(response["table_6"]); //팝업
    }
    var param = {
        Method: 'GetDistCssPkg',
        Code: $('#hdMasterDistCssCode').val()

    };

    JqueryAjax('Post', '../../Handler/Common/DistCssHandler.ashx', true, false, param, 'json', callback, null, null, false, '');

}
function fnAutoComplete() {
    $.getJSON("../UploadFile/AutoComplete/autoCompleteData.json", function (data) {
        var autocompleteData = $.map(data, function (item) {
            return {
                label: item,
            };
        });

        $("#txtPowerSearch").autocomplete({
            open: function () {
                $("ul.ui-menu").width(239);
                //$("ul.ui-menu").height(440);
                var acData = $(this).data('ui-autocomplete');
                acData
                    .menu
                    .element
                    .find('li')
                    .each(function () {
                        var me = $(this);
                        var keywords = acData.term.split(' ').join('|');

                        me.html('<div class="ui-menu-item-wrapper">' + me.text().replace(new RegExp("(" + keywords + ")", "gi"), '<span style="color:red">$1</span>') + '</div>');
                    });


            },
            source: autocompleteData,
            appendTo: "#fixedDiv",
            select: function (event, ui) {

                $("#divSuggestGoods").css('display', 'none');
                var searchKeyword = encodeURIComponent(ui.item.label.trim());
                var searchFlag = '';
                if (!isEmpty(ui.item.label)) {
                    searchFlag = 'A';
                }
                else {
                    searchFlag = 'B';
                }


                //링크검색어 서치(결과값있으면 해당 url로 이동 없으면 그냥 상품리스트로 이동)
                var callback = function (response) {
                    if (!isEmpty(response)) {
                        location.href = window.location.protocol + '//' + location.host + '/' + response;
                    }
                    else {
                        var pageName = '../Goods/GoodsList.aspx';
                        location.href = pageName + "?&GoodsName=" + searchKeyword + "&SearchFlag=" + searchFlag;
                    }
                    return false;
                }

                var param = { Method: 'GetLinkSearchUrl', SearchKeyword: ui.item.label };
                Jajax('Post', '../../Handler/GoodsHandler.ashx', param, 'json', callback);
                return false;

            },
            focus: function (event, ui) {

                return false;
            },
            minLength: 2,
            close: function () {
                if ($("#divSuggestGoods:hover").length == 0) {
                    $("#divSuggestGoods").css('display', 'none');
                    $("#divSuggestGoods").empty();
                }
            }
        })
    });
}

function fnGoGoodsDetailPage(goodsFinalCategoryCode, goodsGroupCode, goodsCode, brandCode) {
    location.href = '../Goods/GoodsDetail.aspx?CategoryCode=' + goodsFinalCategoryCode + '&GroupCode=' + goodsGroupCode + '&GoodsCode=' + goodsCode + '&BrandCode=' + brandCode;
    return false;
}


function fnSetSiteDist() {
    $('#hdMasterDistCssCode').val(distCode);
    $('#hdDaumCode').val(daumMapCode);
    $('#hdMasterCustTelNo').val(custTelNo);
    $('#hdMasterMiniLogo').val(miniLogo);
    $('#hdSaleCompAddress').val(saleCompAdress);
    $('#hdMasterCompanyName').val(compName);
    $('#hdMasterDistCompanyName').val(distCompName);
    $('#hdMasterDns').val(domainURL);
    $('#hdMasterSiteName').val(siteName);
    $('#txtPowerSearch').attr("placeholder", searchTag);
    if (!isEmpty(googleCode)) {
        loadtracking(googleCode);
    }

}
function fnRemoteServicePopup(url) {

    window.open(url, '원격지원서비스', 'resizable=no scrollbars=no width=1000 height=650'); return false;
}


function pad(number, length) {
    var str = number.toString();
    while (str.length < length) {
        str = '0' + str;
    }
    return str;
}

function GetYYYYMMDDHHMMSS() {

    var tmpYear = new Date().getFullYear().toString();
    var tmpMonth = pad(new Date().getMonth() + 1, 2);
    var tmpDay = pad(new Date().getDate(), 2);
    var tmpHourr = pad(new Date().getHours(), 2);
    var tmpMin = pad(new Date().getMinutes(), 2);
    var tmpSec = pad(new Date().getSeconds(), 2);
    var nowDay = tmpYear + tmpMonth + tmpDay + tmpHourr + tmpMin + tmpSec;
    return nowDay;
}

function fnGetDistRoll(response) {
    if (!isEmpty(response)) {
        var index = 1;
        $('#sBannerTotalCnt').text(response.length); //배너 이전/다음버튼에서 토탈카운트 설정
        var nowDay = GetYYYYMMDDHHMMSS();


        $.each(response, function (key, value) { //테이블 추가
            var createhtml = '';
            var rollimgPath = upload + value.ROLLBANNERPATH + '?dt=' + nowDay;

            var redirectUrl = 'javascript:;';
            var hdRollUrlVal = '';
            if (!isEmpty(value.ROLLBANNERURL)) {

                redirectUrl = value.ROLLBANNERURL;
                hdRollUrlVal = value.ROLLBANNERURL;

            }

            if (index == 1) {
                $('#divrollimg').css("background", "url(" + rollimgPath + ")");
                $('#divrollimg').css("background-position", "center center");
                $('#divrollimg').append('<a href="' + redirectUrl + '"></a>')
            }
            var liClass = '';
            if (index == 1) {
                liClass = "class='on'";
            }
            createhtml += ' <li ' + liClass + ' id="LiMasterRoll' + value.SEQ + '" idx="' + index + '"><a href="' + redirectUrl + '">' + value.ROLLNAME + '</a><input type="hidden" id="hdRollImgPath" value="' + rollimgPath + '"/><input type="hidden" id="hdRollImgUrl" value="' + value.ROLLBANNERURL + '"/><input type="hidden" id="hdRollUrl" value="' + hdRollUrlVal + '"></li>'
            $('#ulrollTab').append(createhtml);

            index++;

        });

    }

    $('#ulrollTab > li').hover(function () {
        if ($(this).hasClass("on") == false) {
            $('#ulrollTab > li').removeClass('on');
            $(this).addClass('on');

            if ($(this).find('span > a:last').hasClass("on") == false) {
                $(this).find('span > a:last').addClass('on');
            }
            $('#sIndex').text($(this).attr('idx')); //배너버튼 시퀀스 설정

            var rollimgPath = $(this).find('#hdRollImgPath').val();
            var rollurl = $(this).find('#hdRollImgUrl').val();
            $('#divrollimg').css("background", "url(" + rollimgPath + ")");
            $('#divrollimg').css("background-position", "center center");
            if (!isEmpty(rollurl)) {
                $('#divrollimg > a').attr("href", rollurl);
            }
            else {
                $('#divrollimg > a').attr("href", "javascript:;");
            }

        }
    })

}

//이전슬라이드
function fnPrevImageSlide() {
    var maxIdx = 0;

    $('#ulrollTab > li').each(function () {

        maxIdx = Math.max($(this).attr('idx'), maxIdx);
    });
    var curIndex = $('#ulrollTab > li.on').attr('idx');
    var preIndex = parseInt(curIndex) - 1;
    if (curIndex == 1) {
        preIndex = maxIdx;

    }
    if ($('#ulrollTab > li.on').is(':first-child') && maxIdx > 5) { //다음 페이지 슬라이드(배너가 5개 이상일때만)
        
        $('#ulrollTab').css('margin-left', '-166px');
        $("#ulrollTab").animate({
            marginLeft: '0'
        }, 290);

        $('#ulrollTab > li').css('display', '');
        $('#ulrollTab > li:last').insertBefore($("#ulrollTab > li:first"));
    }
    $('#sIndex').text(preIndex); //배너 현재인덱스 보여주기
    $('#ulrollTab > li').removeClass('on');
    $('#ulrollTab > li[idx="' + preIndex + '"]').addClass('on');


    var rollimgPath = $('#ulrollTab > li[idx="' + preIndex + '"]').find('#hdRollImgPath').val();
    var rollurl = $('#ulrollTab > li[idx="' + preIndex + '"]').find('#hdRollUrl').val();

    $('#divrollimg').css("background-image", "url(" + rollimgPath + ")");
    $('#divrollimg').css("background-position", "center center");
    if (!isEmpty(rollurl)) {
        $('#divrollimg > a').attr("href", rollurl);
    }
    else {
        $('#divrollimg > a').attr("href", "javascript:;");
    }

}

//다음슬라이드
function fnNextImageSlide() {
    var maxIdx = 0;
    $('#ulrollTab > li').each(function () {
        maxIdx = Math.max($(this).attr('idx'), maxIdx);
    });
    var curIndex = $('#ulrollTab > li.on').attr('idx');
    var nextIndex = parseInt(curIndex) + 1;
    if (curIndex == maxIdx) {
        nextIndex = 1;
    }
    if ($('#ulrollTab > li.on').index() == 4 && maxIdx > 5) { //다음 페이지 슬라이드(배너가 5개 이상일때만)

        $('#ulrollTab').css('margin-left', '166px');
        $("#ulrollTab").animate({
            marginLeft: '0'
        }, 290);

        $('#ulrollTab > li:first').insertAfter('#ulrollTab >li:last');
        $('#ulrollTab > li').css('display', '');
     }
    $('#sIndex').text(nextIndex); //배너 현재인덱스 보여주기
    $('#ulrollTab > li').removeClass('on');
    $('#ulrollTab > li[idx="' + nextIndex + '"]').addClass('on');


    var rollimgPath = $('#ulrollTab > li[idx="' + nextIndex + '"]').find('#hdRollImgPath').val();

    var rollurl = $('#ulrollTab > li[idx="' + nextIndex + '"]').find('#hdRollUrl').val();
    $('#divrollimg').css("background", "url(" + rollimgPath + ")");
    $('#divrollimg').css("background-position", "center center");
    if (!isEmpty(rollurl)) {
        $('#divrollimg > a').attr("href", rollurl);
    }
    else {
        $('#divrollimg > a').attr("href", "javascript:;");
    }
    return false;
}



function fnGetDistCategoryLanding(response) {
    if (!isEmpty(response)) {
        $('#divCategoryLanding').css('display', '');
        $.each(response, function (key, value) { //테이블 추가

            var size = value.LANDINGPAGENAME.split('-')[1];
            var imgClass = '';
            if (size == 'SS') {
                imgClass = 'class="ss-size"'
            }
            else if (size == 'S') {
                imgClass = 'class="s-size"'
            }
            else if (size == 'M') {
                imgClass = 'class="m-size"'
            }
            else if (size == 'L') {
                imgClass = 'class="l-size"'
            }
            else {
                imgClass = 'class="s-size"'
            }

            var searchFlag = '';
            if (value.GUBUN == '1') {
                searchFlag = 'C'
            }
            else if (value.GUBUN == '2') {
                searchFlag = 'R'
            }
            else if (value.GUBUN == '3') {
                searchFlag = 'R'
            }

            var linkUrl = '';
            if (isEmpty(value.LANDINGPAGEURL)) {
                linkUrl = '/Goods/GoodsList?CategoryCode=' + value.GOODSFINALCATEGORYCODE + '&BRANDCODE=' + value.BRANDCODE + '&BRANDNAME=' + value.BRANDNAME + '&SearchFlag=' + searchFlag + '';
            }
            else {
                linkUrl = value.LANDINGPAGEURL;
            }

            var html = '<li class="hovereffect s-size">'
            html += '<img ' + imgClass + ' src="' + upload + value.LANDINGPAGEPATH + '" />'
            html += '<div class="overlay" onclick="location.href=\'' + linkUrl + '\'">'
            html += '<a class="info" href="' + linkUrl + '">보러가기</a>'
            html += '</div>'
            html += '</li>'
            $('#ulCategoryLanding').append(html);


        });
    }
    else {
        $('#divCategoryLanding').css('display', 'none');
    }
    return false;
}

function fnGetDistDiperson(response) {
    if (!isEmpty(response)) {
        $('#defaultMiddleBanner').css('display', '');
        $.each(response, function (key, value) { //테이블 추가

            var html = '<li class="main-middle-banner">'
            html += '<a href="' + value.DIPERSONURL + '" target="_blank">'
            html += '<img src="' + upload + value.DIPERSONPATH + '" title="' + value.DIPERSONCAPTION + '"/>'
            html += '<div class="overlay">'
            html += '<p class="info">보러가기</p>'
            html += '</div>'
            html += '</a>'
            html += '</li>'
            $('#ulDiperson').append(html);


        });
    }
    else {
        $('#defaultMiddleBanner').css('display', 'none');
    }
    return false;
}

function fnGetDistPartner(response) {
    if (!isEmpty(response)) {
        $('#divPartnersContent').css('display', '');
        $.each(response, function (key, value) { //테이블 추가
            var html = '<li>'
            html += '<a  href="' + value.PARTNERURL + '" target="_blank">'
            html += '<img src="' + upload + value.PARTNERPATH + '"  title="' + value.PARTNERCAPTION + '" />'
            html += '</a>'
            html += '</li>'
            $('#ulPartners').append(html);

        });
    }
    else {
        $('#divPartnersContent').css('display', 'none');
        $('.divEmpty').css('display', 'none');
    }
    return false;
}

function fnDistPopup(response) {
    if (!isEmpty(response)) {

        $.each(response, function (key, value) { //테이블 추가

            if (fnGetCookie(value.POPUPCAPTION) != 'done' && value.DELFLAG == 'N') {
                fnOpenPopup(value.POPUPWIDTH, value.POPUPHEIGHT, value.POPUPLEFT, value.POPUPTOP, value.POPUPCAPTION, value.POPUPPATH);
            }

        });
    }
}

var _gaq = _gaq || [];

function loadtracking(googleCode) {
    window._gaq.push(['_setAccount', googleCode]);
    window._gaq.push(['_trackPageview']);

    (function () {
        var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
        ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
        var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
    })();
}
function DefaultDataBind() {

    HeaderCategoryListBind();
    fnGetSiteDistPackage();
    fnGetGoodsSearchLog();

}


function HeaderCategoryListBind() {


    var callback = function (response) {

        fhAllCategoryListBind(response);  //전체카테고리바인드
    }
    var param = { Method: 'GetCategoryNaviList' };

    JqueryAjax('Post', '../../Handler/Common/CategoryHandler.ashx', false, false, param, 'json', callback, null, null, false, '');

}


function SortByCategoryLevel(x, y) {
    return ((x.CategoryFinalCode == y.CategoryFinalCode) ? 0 : ((x.CategoryFinalCode > y.CategoryFinalCode) ? 1 : -1));
}

//전체카테고리 리스트 바인드
function fhAllCategoryListBind(response) {
    var categoryMax = fnGetCategoryMax(response, 'CategoryLevelCode').CategoryLevelCode; //카테고리 레벨코드 맥스값 갖고와서

    for (var i = 0; i < response.length; i++) {

        for (var j = 1; j <= 3; j++) {

            if (response[i].CategoryLevelCode == j) {

                var createHtml = '';
                var nextDepth = j + 1;

                //createHtml += '<li id="liCategoryMenu' + j + 'Depth' + response[i].CategoryFinalCode + '" onmouseover="fnSetSubDivMenuView(this, \'' + response[i].CategoryLevelCode + '\',\'' + response[i].CategoryFinalCode + '\', \'over\')" onmouseout="fnSetSubDivMenuView(this, \'' + response[i].CategoryLevelCode + '\',\'' + response[i].CategoryFinalCode + '\' , \'out\')">';
                createHtml += '<li id="liCategoryMenu' + j + 'Depth' + response[i].CategoryFinalCode + '" >';
                createHtml += '<a class="site-category" href="../../Goods/GoodsList.aspx?CategoryCode=' + response[i].CategoryFinalCode + '&SearchFlag=C">';
                createHtml += '<span>' + response[i].CategoryFinalName + '';
                createHtml += '</span>';
                createHtml += '</a>';
                if (j == 1) {

                    createHtml += '<ul>';
                    createHtml += '<li>';
                    createHtml += '<div class="divCategoryLevel02 site-category" depth="' + nextDepth + '" id="subDivMenu' + nextDepth + 'Depth' + response[i].CategoryFinalCode + '" >';
                    createHtml += '<h4 class="site-category">' + response[i].CategoryFinalName + '<img class="categoryicon" src="/Images/Category/C_' + response[i].CategoryFinalCode + '.png"/></h4>';
                    createHtml += '<ul class="site-category" id="subMenu' + nextDepth + 'Depth' + response[i].CategoryFinalCode + '">';
                    createHtml += '</ul>';
                    createHtml += '</div>';
                    createHtml += '</li>';
                    createHtml += '</ul>';

                }
                else if (j == 2) {

                    createHtml += '<ul  id="subMenu' + nextDepth + 'Depth' + response[i].CategoryFinalCode + '">';
                    createHtml += '</ul>';

                }

                createHtml += '</li>';

                if (j == 1) {
                    $('#ulSubMenu1Depth').append(createHtml);


                }
                else {
                    $('#subMenu' + j + 'Depth' + response[i].CategoryUpCode + '').append(createHtml);
                }
            }
        }
    }


    return false;
}

//카테고리 Max 값 갖고오기
function fnGetCategoryMax(arr, prop) {
    var max;
    for (var i = 0; i < arr.length; i++) {
        if (!max || parseInt(arr[i][prop]) > parseInt(max[prop]))
            max = arr[i];
    }
    return max;
}


function fnGoGoodsPage(ddd) {
    location.href = '../../Goods/GoodsList.aspx?CategoryCode=' + ddd + '&SearchFlag=C';
    return false;
}

//상세검색

function fnPowerSearch(type) {
    var txtSearchId = '';
    if (type == 'Main') {
        txtSearchId = 'txtPowerSearch';
    }
    else {
        txtSearchId = 'txtPowerSearch-Sub';
    }
    var searchKeyword = encodeURIComponent($("#" + txtSearchId).val().trim());
    var searchFlag = '';
    if (!isEmpty($("#" + txtSearchId).val())) {
        searchFlag = 'A';
    }
    else {
        searchFlag = 'B';
    }


    //링크검색어 서치(결과값있으면 해당 url로 이동 없으면 그냥 상품리스트로 이동)
    var callback = function (response) {
        if (!isEmpty(response)) {
            location.href = window.location.protocol + '//' + location.host + '/' + response;
        }
        else {
            var pageName = '../Goods/GoodsList.aspx';
            location.href = pageName + "?&GoodsName=" + searchKeyword + "&SearchFlag=" + searchFlag;
        }
    }

    var param = { Method: 'GetLinkSearchUrl', SearchKeyword: $("#txtPowerSearch").val() };
    Jajax('Post', '../../Handler/GoodsHandler.ashx', param, 'json', callback);
}



function fnPowerSearchEnter(type) {

    if (event.keyCode == 13) {
        fnPowerSearch(type);
        return false;
    }
    else
        return true;
}

function fnFooterPowerSearch() {

    var searchKeyword = encodeURIComponent($("#txtFooterSearch").val().trim());
    var searchFlag = '';
    if (!isEmpty($("#txtFooterSearch").val())) {
        searchFlag = 'A';
    }
    else {
        searchFlag = 'B';
    }


    //링크검색어 서치(결과값있으면 해당 url로 이동 없으면 그냥 상품리스트로 이동)
    var callback = function (response) {
        if (!isEmpty(response)) {
            location.href = window.location.protocol + '//' + location.host + '/' + response;
        }
        else {
            var pageName = '../Goods/GoodsList.aspx';
            location.href = pageName + "?&GoodsName=" + searchKeyword + "&SearchFlag=" + searchFlag;
        }
    }

    var param = { Method: 'GetLinkSearchUrl', SearchKeyword: $("#txtFooterSearch").val() };
    Jajax('Post', '../../Handler/GoodsHandler.ashx', param, 'json', callback);
}


function fnFooterPowerSearchEnter() {
    if (event.keyCode == 13) {
        fnFooterPowerSearch();
        return false;
    }
    else
        return true;
}

function fnGoMemberJoinPage() {

    var geturl = location.host;

    if ($('#hdMasterSiteName').val() == 'socialwith') {
        location.href = '../Member/MemberJoinSelect.aspx';
    }
    else {
        location.href = '../Member/Agreement.aspx?JoinType=B';
    }
}

// 즐겨찾기 

$(document).ready(function () {
    $("#bookmarkme").on("click", function () {
        if (navigator.userAgent.indexOf("Chrome") > -1) {  //크롬 
            alert("이용하시는 웹 브라우저는 기능이 지원되지 않습니다. Ctrl+D 키를 누르시면 즐겨찾기에 추가하실 수 있습니다.");
            return true;

        }
    });
});

function fnGoLoginPage() {
    location.href = '/Member/Login.aspx?returnUrl=' + escape(document.location);
    return false;
}

function fnAddFavorite() {

    var host = 'https://www.' + $('#hdMasterSiteName').val() + '.co.kr';
    var title = ':::: ' + $('#hdMasterDistCompanyName').val() + ' ::::';
    if (window.sidebar && window.sidebar.addPanel) {  //Firefox
        window.sidebar.addPanel(title, host, "");
    } else if (window.opera && window.print) {  //opera
        var elem = decument.createElement('a');
        elem.setAttribute('href', host);
        elem.setAttribute('title', title);
        elem.setAttribute('rel', 'sidebar');
        elem.click();
    }
    else if (navigator.userAgent.indexOf("MSIE") > -1 || (window.external && ('AddFavorite' in window.external))) { //IE
        window.external.AddFavorite(host, title);
    } else if (navigator.userAgent.indexOf("Chrome") > -1) {  //크롬 
        alert("이용하시는 웹 브라우저는 기능이 지원되지 않습니다. Ctrl+D 키를 누르시면 즐겨찾기에 추가하실 수 있습니다.");
        return true;
    }

    return false;
}





function fnGetGoodsRecommInfo() {

    var callback = function (response) {
        if (!isEmpty(response)) {
            if (parseInt(response) > 0) {
                $('#spanGoodsRecommCount').text(response + '건');
                $('#pop').css('display', '');
                $("#pop").draggable();
            }
        }
        return false;
    }
    var param = {

        SvidUser: sviduser,
        Method: 'GetGoodsRecommCount'

    };


    //type, url, async, cache, data, datatype, _callback, _beforeSend, _complete, issessionCheck, sessionValue
    JqueryAjax('Post', '../../Handler/GoodsRecommHandler.ashx', false, false, param, 'text', callback, null, null, false, '');
}

function fnGoodRecommConfimUpdate() {

    var callback = function (response) {
        if (response == 'Success') {
            $('#pop').hide();
        }
        else {
            alert('시스템오류입니다. 관리자에게 문의하세요.');
        }
        return false;
    }
    var param = {

        SvidUser: sviduser,
        Method: 'UpdateGoodsRecommConfirm'

    };


    //type, url, async, cache, data, datatype, _callback, _beforeSend, _complete, issessionCheck, sessionValue
    JqueryAjax('Post', '../../Handler/GoodsRecommHandler.ashx', false, false, param, 'text', callback, null, null, false, '');
}


//엠디 추천 상품
function fnMdRecommand() {

    var index = 0;
    var certifiCations = new Array(); //인증마크
    var callback = function (response) {
        if (!isEmpty(response)) {
            for (var i = 0; i < response.length; i++) {

                var mapName = '';
                //배송일 당일발송과 1일만 보이게
                if (response[i].GoodsDeliveryOrderDue == '1' || response[i].GoodsDeliveryOrderDue == '2') {
                    mapName = response[i].MapName;
                }

                var spanCertMarkDisplay = '';
                if (isEmpty(response[i].GoodsConfirmMark) || response[i].GoodsConfirmMark == '00000000') {
                    spanCertMarkDisplay = 'visibility :hidden';
                }
                certifiCations.push(response[i].GoodsConfirmMark);
                var src = '/GoodsImage' + '/' + response[i].GoodsFinalCategoryCode + '/' + response[i].GoodsGroupCode + '/' + response[i].GoodsCode + '/' + response[i].GoodsFinalCategoryCode + '-' + response[i].GoodsGroupCode + '-' + response[i].GoodsCode + '-mmm.jpg';
                var detailPage = '../Goods/GoodsDetail.aspx?CategoryCode=' + response[i].GoodsFinalCategoryCode + '&GroupCode=' + response[i].GoodsGroupCode + '&BrandCode=' + response[i].BrandCode + '&GoodsCode=' + response[i].GoodsCode;
                var svidUser = sviduser;
                var svidRole = svidRole;
                var price = '';
                var priceHtml = '';
                var spanPromotionDisplayFlag = '';
                if (isEmpty(response[i].GoodsDCPriceVat)) {
                    spanPromotionDisplayFlag = 'visibility :hidden';
                }
                if (svidUser == '' || svidRole == 'T' || userId == 'socialwith') {
                    price = '(회원전용)';
                    priceHtml = '<span class="keep_words">' + price + '</span>';
                }
                else {
                    price = numberWithCommas(response[i].GoodsSalePriceVat) + '원';

                    if (isEmpty(response[i].GoodsDCPriceVat)) {
                        priceHtml = '<span>' + price + '</span>';
                    }
                    else {
                        priceHtml = '<span style="text-decoration: line-through;">' + price + '</span>&nbsp;<span  style="color:black;">' + numberWithCommas(response[i].GoodsDCPriceVat) + '원</span>';
                    }
                }
                var createHtml = '';
                if (pgFlag == 'Y') {
                    if (response[i].GoodsSalePriceVat < 4000000) {
                        createHtml = fnCreateGoodsHintHtml(response[i].CategoryFlag, response[i].GoodsConfirmMark, spanCertMarkDisplay, detailPage, src, response[i].GoodsFinalName, mapName, response[i].BrandName, priceHtml);
                    }
                }
                else {
                    createHtml = fnCreateGoodsHintHtml(response[i].CategoryFlag, response[i].GoodsConfirmMark, spanCertMarkDisplay, detailPage, src, response[i].GoodsFinalName, mapName, response[i].BrandName, priceHtml);

                }
                $('#recommandList').append(createHtml);
            }
            SetCertifyImageSet();
        }

        return false;
    }
    var param = {
        Method: 'GetBestRecommendGoods',
        CompCode: compCode,
        SaleCompCode: saleCompCode,
        DongshinCheck: dsCheck,
        FreeCompanyYN: freeCompYN,
        FreeCompanyVatYN: freeCompanyVatYN,
        SvidUser: sviduser
    };
    Jajax('Post', '../../Handler/GoodsHandler.ashx', param, 'json', callback);
}



function fnCreateGoodsHintHtml(ctgrFlag, confirmMark, confirmMarkDisplay, detailPageUrl, imgSrc, goodsName, mapName, brandName, price) {
    var createHtml = '';
    var mapnameStyle = '';
    if (isEmpty(mapName)) {
        mapnameStyle = 'style="visibility:hidden"';
    }
    createHtml += '<div class="goods_md_recommand" ctgrFlag="' + ctgrFlag + '"><a href="' + detailPageUrl + '" ><div class="goods_hint">';
    createHtml += '<div class="goods_confirmMark"><span class="spanCert" other-title="" id="spanCert' + confirmMark + '" style="' + confirmMarkDisplay + '">*인증상품</span></div>';
    createHtml += '<span class="goods_img" ><img src="' + imgSrc + '"  onerror="no_image(this, \'m\')"></span>';
    createHtml += '<h4>' + goodsName + '</h4>';
    createHtml += '<div class="goodshint_mapname" ' + mapnameStyle + '>' + mapName + '</div>';
    createHtml += '<div class="" style="color:#2d5c84;padding-bottom:5px;"></div>';
    createHtml += '<div class="goodshint_brand"><span>' + brandName + '</span></div>';
    createHtml += '<div class="goods_price" ><span class="keep_words">' + price + '</span></div>';
    createHtml += '</div></a></div>';
    return createHtml;
}

//인증마크
function SetCertifyImageSet() {
    $('.spanCert').tooltip({
        items: '[other-title]',
        content: function () {
            var code = $(this).prop('id').substring(8);
            var html = '';
            html = "<div>";
            if (code.substring(0, 1) == '1') {
                html += "<img class='map' alt= '사회적기업' src='" + upload + "CertificationImage/01.jpg' style='padding:5px'/>";

            }
            if (code.substring(1, 2) == '1') {
                html += "<img class='map' alt= '한국여성경제인협회' src='" + upload + "/CertificationImage/02.jpg' style='padding:5px'/>";

            }
            if (code.substring(2, 3) == '1') {
                html += "<img class='map' alt= '장애인표준사업장' src='" + upload + "/CertificationImage/03.jpg' style='padding:5px'/>";

            }
            if (code.substring(3, 4) == '1') {
                html += "<img class='map' alt= 'COOP협동조합' src='" + upload + "/CertificationImage/04.jpg' style='padding:5px'/>";

            }
            if (code.substring(4, 5) == '1') {
                html += "<img class='map' alt= '중증장애인생산품' src='" + upload + "/CertificationImage/05.jpg' style='padding:5px'/>";

            }
            if (code.substring(5, 6) == '1') {
                html += "<img class='map' alt= '' src='" + upload + "/CertificationImage/06.jpg' style='padding:5px'/>";

            }
            if (code.substring(6, 7) == '1') {
                html += "<img class='map' alt= '' src='" + upload + "/CertificationImage/07.jpg' style='padding:5px'/>";

            }
            if (code.substring(7, 8) == '1') {
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


function fnOpenPopup(width, height, left, top, name, filePath) {

    var curX = window.screenLeft;
    var curY = window.screenTop;

    var nLeft = curX + left;
    var nTop = curY + top;


    var windowPop = window.open('/Popup/MainPopup.html?FilePath=' + filePath + '&PopName=' + name, '', "width=" + width + ",height=" + height + ",status=no ,toolbar=no,menubar=no,location=no,resizable=yes,scrollbars=yes,left=" + nLeft + ", top=" + nTop + "");


    //if (windowPop == null) {
    //    alert("팝업 차단을 해제해주세요.");
    //    return false;
    //}

    windowPop.opener = self;

}

function fnGetGoodsSearchLog() {
    $('.recentList').empty();
    $('.moreList').empty();
    $('.nolist').css('display', 'none');
    var callback = function (response) {

        if (!isEmpty(response)) {

            $.each(response, function (key, value) { //테이블 추가
                var src = '/GoodsImage' + '/' + value.GoodsFinalCategoryCode + '/' + value.GoodsGroupCode + '/' + value.GoodsCode + '/' + value.GoodsFinalCategoryCode + '-' + value.GoodsGroupCode + '-' + value.GoodsCode + '-mmm.jpg';
                var redirectUrl = '/Goods/GoodsDetail.aspx?CategoryCode=' + value.GoodsFinalCategoryCode + '&GroupCode=' + value.GoodsGroupCode + '&BrandCode=' + value.BrandCode + '&GoodsCode=' + value.GoodsCode;
                var html = '<li>'
                html += '<a id="aTodayGoods' + key + '"  href="' + redirectUrl + '" style="" >'
                html += '<img id="imgTodayGoods" src="' + src + '"   onerror="no_image(this, \'m\')" />'
                html += '</a>'

                html += '<a id="aDeleteTodayGoods" class="btn_btmdel" style="display:none" onclick="return fnGoodsSearchLogDelete(\'' + value.GoodsCode + '\');">'

                html += '</a>'
                html += '</li>'
                $('.recentList').append(html);


                var moreHtml = '<li>'
                moreHtml += '<a id="aTodayGoods' + key + '"  href="' + redirectUrl + '" style="" >'
                moreHtml += '<img id="imgTodayGoods" src="' + src + '"   onerror="no_image(this, \'m\')" />'
                moreHtml += '</a>'

                moreHtml += '<a id="aDeleteTodayGoods" class="btn_btmdel" style="display:none" onclick="return fnGoodsSearchLogDelete(\'' + value.GoodsCode + '\');">'

                moreHtml += '</a>'
                moreHtml += '</li>'
                $('.moreList').append(moreHtml);
                $(".moreGoods").length && curViewGoods.init();
            });
        }
        else {
            $('.nolist').css('display', 'block'); //오늘본 상품이 없습니다. 문구 보여주기
        }


    }
    var param = {

        SvidUser: sviduser,
        Method: 'GetGoodsSearchLog'

    };


    //type, url, async, cache, data, datatype, _callback, _beforeSend, _complete, issessionCheck, sessionValue
    JqueryAjax('Post', '../../Handler/GoodsHandler.ashx', false, false, param, 'json', callback, null, null, false, '');
}


//최근 선택한 카테고리 갖고오기
function fnGetCategorySearchLog() {
    $('#ulCategorySearchLog').empty();
    var callback = function (response) {
        if (!isEmpty(response)) {
            $.each(response, function (key, value) {
                var url = '/Goods/GoodsList?CategoryCode=' + value.CategoryFinalCode + '&SearchFlag=C'
                var html = '<a href="' + url + '"><li>' + value.CategoryFinalName + '';
                html += '</li></a>';
                $('#ulCategorySearchLog').append(html);
            }); //테이블 추가
        }
        else {
            $('#ulCategorySearchLog').append('<li>최근 선택한 카테고리가 없습니다.</li>');
        }
        return false;
    }

    var param = {

        SvidUser: sviduser,
        Method: 'GetCategorySearchLog'

    };


    //type, url, async, cache, data, datatype, _callback, _beforeSend, _complete, issessionCheck, sessionValue
    JqueryAjax('Post', '../../Handler/Common/CategoryHandler.ashx', true, false, param, 'json', callback, null, null, true, sviduser);
}


//최근 본 상품 제거
function fnGoodsSearchLogDelete(goodscode) {
    var callback = function (response) {
        if (response == 'OK') {
            fnGetGoodsSearchLog();
        }
        else {
            alert('시스템 오류입니다. 관리자에게 문의하세요');

        }
        return false;
    }

    var param = {

        GoodsCode: goodscode,
        Method: 'DeleteGoodsSearchLog'

    };


    //type, url, async, cache, data, datatype, _callback, _beforeSend, _complete, issessionCheck, sessionValue
    JqueryAjax('Post', '../../Handler/GoodsHandler.ashx', false, false, param, 'text', callback, null, null, true, sviduser);
}

//최근 본 카테고리 제거
function fnCategorySearchLogDelete() {
    var callback = function (response) {
        if (response == 'OK') {
            fnGetCategorySearchLog();
        }
        else {
            alert('시스템 오류입니다. 관리자에게 문의하세요');

        }
        return false;
    }

    var param = {

        SvidUser: sviduser,
        Method: 'DeleteCategorySearchLog'

    };


    //type, url, async, cache, data, datatype, _callback, _beforeSend, _complete, issessionCheck, sessionValue
    JqueryAjax('Post', '../../Handler/Common/CategoryHandler.ashx', true, false, param, 'text', callback, null, null, true, sviduser);
}

//하단 플로팅박스 내 최근본상품
var goodsDel;
var delIdx = 0;
var curViewGoods = {
    init: function () {
        this.moreGoods = $(".btn_moreGoods");
        this.moreClose = $(".btn_moreClose");
        this.moreListBox = $(".moreGoods");
        this.goodsList = $(".recentGoods ul li");
        this.goodsDel = $(".btn_btmdel");
        this.btnOptionCls = $(".btnOption2, .optioncls")
        this.goodsDel.hide();
        curViewGoods.addEvent();
    },
    addEvent: function () {
        this.moreGoods.on("click", function () { curViewGoods.open(); });
        this.moreClose.on("click", function () { curViewGoods.close(); });
        this.goodsList.on("mouseenter", function () {
            if ($(this).find(".btn_btmdel").css("display") == "none") {
                $(this).find(".btn_btmdel").show();
            }
        });
        this.goodsList.on("mouseleave", function () {
            if ($(this).find(".btn_btmdel").css("display") != "none") {
                $(this).find(".btn_btmdel").hide();
            }
        });
        //this.goodsDel.on("click",function(){curViewGoods.del($(this).parent().parent().attr("class"),$(this).parent().index());});
    },
    open: function () {
        this.moreGoods.hide();
        this.moreClose.show();
        this.moreListBox.css({ "bottom": $(".floatbar").height() + "px" }).show();
    },
    close: function () {
        this.moreGoods.show();
        this.moreClose.hide();
        this.moreListBox.hide();
    },
    del: function (delClass, delIdx) {
        $("." + delClass).find("li").eq(delIdx).remove();
    }
};

//하단 플로팅박스 내 검색
var footSearch = {
    init: function () {
        this.moreGoods = $(".btmico02");
        this.moreClose = $(".btmico02.close");
        this.moreListBox = $(".searchBar");
        footSearch.addEvent();
    },
    addEvent: function () {
        this.moreGoods.on("click", function () { footSearch.open(); });
        this.moreClose.on("click", function () { footSearch.close(); });
    },
    open: function () {
        this.moreGoods.hide();
        this.moreClose.show();
        this.moreListBox.show();
    },
    close: function () {
        this.moreGoods.show();
        this.moreClose.hide();
        this.moreListBox.hide();
    }
};

//하단 플로팅박스 내 up/down 버튼
var goSide = 0;
var footSlide = function (side) {
    if (side == "top") {
        goSide = 0;
        goSpeed = 500;
    } else {
        goSide = $(document).height();
        goSpeed = 3000;
    }

    $("html, body").animate({ scrollTop: goSide }, goSpeed);
}

//메인화면 인기상품 
function fnGetPopularGoodsList() {
    $('#ulPopularGoods').empty();
    var callback = function (response) {
        if (!isEmpty(response)) {
            $('.category-bnr').css('display', '');
            var list = "";
            var num = 1;
            $.each(response, function (key, value) {


                var src = '/GoodsImage' + '/' + value.GoodsFinalCategoryCode + '/' + value.GoodsGroupCode + '/' + value.GoodsCode + '/' + value.GoodsFinalCategoryCode + '-' + value.GoodsGroupCode + '-' + value.GoodsCode + '-mmm.jpg';

                list += '<li>'
                list += '<a href="/Goods/GoodsDetail?CategoryCode=' + value.GoodsFinalCategoryCode + '&GroupCode=' + value.GoodsGroupCode + '&BrandCode=' + value.BrandCode + '&GoodsCode=' + value.GoodsCode + '">'
                list += '<span class="mun">' + num + '</span><div><span>' + value.GoodsFinalName + '</span></div>'
                list += '<img class="img" src="' + src + '" onerror="no_image(this, \'m\')">'
                list += '</a>'
                list += '</li>'

                num++;

                //console.log(value.GoodsFinalCategoryCode);
            }); //each end
            $('#ulPopularGoods').append(list);
        }
        else {
            //없으면 아예 창 안보이게 
            $('.category-bnr').css('display', 'none');

        }
        return false;
    }

    var param = {

        SvidUser: sviduser,
        Method: 'GetPopularGoodsList'
    };

    JqueryAjax('Post', '../../Handler/GoodsHandler.ashx', true, false, param, 'json', callback, null, null, true, sviduser);
}


//로그아웃
function fnLogout() {
    var callback = function (response) {
        if (!isEmpty(response)) {
            if (response == 'OK') {
                location.href = '/Member/Login.aspx';
            }
            else {
                alert('시스템 오류입니다. 관리자에게 문의하세요.');
            }
        }
        else {
            alert('시스템 오류입니다. 관리자에게 문의하세요.');
        }
        return false;
    }

    var param = {

        Method: 'SetBuyerLogOut'
    };

    JqueryAjax('Post', '/Handler/Common/UserHandler.ashx', true, false, param, 'text', callback, null, null, true, sviduser);
}