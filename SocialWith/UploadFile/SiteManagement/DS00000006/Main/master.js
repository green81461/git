$(function () {
    $('#txtPowerSearch').val(GoodsName);
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
    
    fnSetSiteDist();
    fnAutoComplete();
    DefaultDataBind();
    fnGetCategorySearchLog(); // 최근 선택한 카테고리
    $('#spanCustTelNo').text($('#hdMasterCustTelNo').val());
    $('#navi-liAll .categoryAllBtn').click(function () {

        var displayStatus = $('#navi-allCategorySub').css('display');
        if (displayStatus == 'none') {
            $('#navi-allCategorySub').css('display', 'block');
            $('#navi-allCategorySub').css('position', 'absolute');
        }
        else if (displayStatus == 'block') {
            $('#navi-allCategorySub').css('display', 'none');
        }
    }
    );

    $('#navi-liAll').hover(function () {


    }, function () {

        $('#navi-allCategorySub').css('display', 'none');

    });



    $('#hiddenNavi-liAll .categoryAllBtn').click(function () {

        var displayStatus = $('#hiddenNavi-allCategorySub').css('display');
        if (displayStatus == 'none') {
            $('#hiddenNavi-allCategorySub').css('display', 'block');
            $('#hiddenNavi-allCategorySub').css('position', 'absolute');
        }
        else if (displayStatus == 'block') {
            $('#hiddenNavi-allCategorySub').css('display', 'none');
        }
        return false;
    }

    );

    $('#hiddenNavi-liAll').hover(function () {


    }, function () {

        $('#hiddenNavi-allCategorySub').css('display', 'none');
        return false;

    });

    /* 메인카테고리 즐겨찾기 이벤트2 */
    $('.btn-my2').click(function () {
        $(this).parent().siblings('.my-category2').show();
    });
    $('.my-category2').click(function () {
        $(this).hide();
    });


    $('#navi-allCategorySub > ul > li').hover(function () {
        $('#navi-allCategorySub > ul > li').removeClass('active');
        $('#navi-allCategorySub > ul > li > ul > li .divCategoryLevel02 > ul > li').removeClass('active');

        $(this).addClass('active');
        $(this).find('ul > li .divCategoryLevel02 > ul > li:first').addClass('active');

    }, function () {

        $('#navi-allCategorySub > ul > li').removeClass('active');

    });

    $('#navi-allCategorySub > ul > li > ul > li .divCategoryLevel02 > ul > li').hover(function () {
        $(this).parent().find('li').removeClass('active');
        $(this).addClass('active')
    })


    ///

    $('#hiddenNavi-allCategorySub > ul > li').hover(function () {
        $('#hiddenNavi-allCategorySub > ul > li').removeClass('active');
        $('#hiddenNavi-allCategorySub > ul > li > ul > li .divCategoryLevel02 > ul > li').removeClass('active');

        $(this).addClass('active');
        $(this).find('ul > li .divCategoryLevel02 > ul > li:first').addClass('active');

    }, function () {

        $('#hiddenNavi-allCategorySub > ul > li').removeClass('active');

    });

    $('#hiddenNavi-allCategorySub > ul > li > ul > li .divCategoryLevel02 > ul > li').hover(function () {
        $(this).parent().find('li').removeClass('active');
        $(this).addClass('active')
    })

    //최근본 카테고리 삭제
    $('#pDeleteCategorySearchLog').click(function () {

        fnCategorySearchLogDelete();
        return false;
    });

    //최근본 카테고리 삭제(히든 헤더)
    $('#pFixDeleteCategorySearchLog').click(function () {

        fnCategorySearchLogDelete();
        return false;
    });

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
        $('#divContent').animate({ marginTop: '201px' }, 400);
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

    /* 카테고리 화살표 */
    $('.categoryAllBtn').click(function () {
        $('.categoryAllBtn').toggleClass("up_btn");
    });

    //좌측 사이트맵 스크롤 
    var quick_top = 208;
    var srcollTop = 190;
    var fixTop = 54;
    var left_menu = $('#divLeftMenu');

    if ($('#divTopmenu').height() > 0) {
        quick_top = 256;
        srcollTop = 200;
        fixTop = 89;

    }
    else {
        quick_top = 190;
        srcollTop = 140;
        fixTop = 29
    }

    //left_menu.animate({ "top": $(document).scrollTop() + quick_top + "px" }, 500);

    $(window).scroll(function () {

        if ($(this).scrollTop() > srcollTop) {
            left_menu.css('position', 'fixed');
            left_menu.css('top', '' + fixTop + 'px');
        } else {
            left_menu.css('position', 'absolute');
            left_menu.css('top', '' + quick_top + 'px');
        }
    });

    //스틱키메뉴 마이페이지
    $('.mypage').hover(function () { $('.mypage_sub_menu').css('display', 'block'); }, function () { });
    $('.mypage_sub_menu').hover(function () { }, function () { $(this).css('display', 'none'); });
});

/* S. 최상단 배너 영역 노출 여부 */
function fnTopmenuCookieChk() {
    if (fnGetCookie("divTopMenu") != "N") {
        $('#divTopmenu').show();
       
    } else {
        $('#divTopmenu').hide();
        $('#divContent').css('margin-top', '201px');
    }
}

function fnAutoComplete() {
    $.getJSON("/UploadFile/AutoComplete/autoCompleteData.json", function (data) {
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
                        var pageName = '/Goods/GoodsList.aspx';
                        location.href = pageName + "?&GoodsName=" + searchKeyword + "&SearchFlag=" + searchFlag;
                    }
                    return false;
                }

                var param = { Method: 'GetLinkSearchUrl', SearchKeyword: ui.item.label };
                Jajax('Post', '/Handler/GoodsHandler.ashx', param, 'json', callback);
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
    location.href = '/Goods/GoodsDetail.aspx?CategoryCode=' + goodsFinalCategoryCode + '&GroupCode=' + goodsGroupCode + '&GoodsCode=' + goodsCode + '&BrandCode=' + brandCode;
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

    SetMenuAuthority();
    HeaderCategoryListBind();
    //fnGetDistMenu();
    fnGetGoodsSearchLog();

}
//권한별 메뉴세팅
function SetMenuAuthority() {

    var role = svidRole;
    if (role == 'B2' || role == 'BC3') {
        $('#liMEBT005002000000').css('display', 'inline-block');//구매요청 
    }
    if (role == 'B1' || role == 'BC2') {
        $('#liMEBT005003000000').css('display', 'inline-block');//구매승인 
    }
    if (role == 'C2' || role == 'C1' || role == 'BC2' || role == 'BC1') {
        $('#liMEBT005004000000').css('display', 'inline-block');//미결 
        $('#liMEBT005005000000').css('display', 'inline-block');//기결
    }
}

function fnGetDistMenu() {

    var callback = function (response) {

        if (!isEmpty(response)) {

            $.each(response, function (key, value) {

                if (value.MenuLevelCode == 1 && value.MenuPlaceCode == '1' && value.MenuGubun == '1' && value.UseYN == 'Y') {
                    var topMenuHtml = '<li id="li' + value.MenuId + '">'
                    topMenuHtml += '<a href="' + value.MenuUrl + '" style="display: block; font-size: 13px; color: white; height: 36px; line-height: 36px;">' + value.MenuName + '</a>';
                    topMenuHtml += '<ul  id="ultopSubMenu' + value.MenuId + '">'
                    topMenuHtml += '</ul>'
                    topMenuHtml += '</li>';
                    $('#categories').append(topMenuHtml);
                }

                else if (value.MenuLevelCode == 2 && value.MenuPlaceCode == '1' && value.MenuGubun == '1' && value.UseYN == 'Y') {

                    var displayStyle = '';
                    if (value.MenuId == 'MEBT005002000000' || value.MenuId == 'MEBT005003000000' || value.MenuId == 'MEBT005004000000' || value.MenuId == 'MEBT005005000000') {
                        displayStyle = 'display:none';
                    }
                    var topMenuChildHtml = ' <li class="topMenu_li" style=" box-sizing: border-box; color:#b2d8fe; border-right:1px solid #C9C9C9; border-left:1px solid #C9C9C9; border-bottom:1px solid #C9C9C9; width: 94px; height:32px; padding-top:6px; vertical-align:middle;' + displayStyle + '" onclick="location.href=\'' + value.MenuUrl + '\'" id="li' + value.MenuId + '"><a href="' + value.MenuUrl + '">' + value.MenuName + '</a></li>';
                    //var topMenuChildHtml = ' <li class="topMenu_li" style=" box-sizing: border-box; color:#b2d8fe; border-bottom:1px solid #eaeaea; width: 94px; height:32px; padding-top:10px; vertical-align:middle;' + displayStyle + '" onclick="location.href=\'' + value.DistCssMgtMenuUrl + '\'" id="li' + value.MenuId + '"><a href="' + value.DistCssMgtMenuUrl + '">' + value.MenuName + '</a></li>';
                    $('#ultopSubMenu' + value.MenuUpCode + '').append(topMenuChildHtml);
                }

                if (value.MenuLevelCode == 1 && value.MenuPlaceCode == '2' && value.MenuGubun == '1' && value.UseYN == 'Y') {
                    var bottomMenuChildHtml = '';
                    if (value.MenuId == 'MEBB005000000000') {
                        bottomMenuChildHtml = '<li><a href="#" onclick="fnRemoteServicePopup(\'' + value.MenuUrl + '\'); " >' + value.MenuName + '</a></li>'
                    }
                    else {
                        bottomMenuChildHtml = '<li><a href="' + value.MenuUrl + '" >' + value.MenuName + '</a></li>'
                    }

                    $('#ulBottomMenu').append(bottomMenuChildHtml);

                }

            });

        }
    }
    var param = {

        Code: $('#hdMasterDistCssCode').val(),
        Method: 'GetDistCssMenu'

    };


    //type, url, async, cache, data, datatype, _callback, _beforeSend, _complete, issessionCheck, sessionValue
    JqueryAjax('Post', '/Handler/Common/DistCssHandler.ashx', false, false, param, 'json', callback, null, null, false, '');



}

function HeaderCategoryListBind() {
    var categoryStorage = sessionStorage.getItem('Category');

    var callback = function (response) {

        fnAllCategoryListBind(response);  //전체카테고리바인드
        fnHiddenCategoryListBind(response);  //전체카테고리바인드
    }
    var param = { Method: 'GetCategoryNaviList' };

    JqueryAjax('Post', '/Handler/Common/CategoryHandler.ashx', false, false, param, 'json', callback, null, null, false, '');

}


//전체카테고리 리스트 바인드
function fnAllCategoryListBind(response) {

    for (var i = 0; i < response.length; i++) {

        for (var j = 1; j <= 3; j++) {

            if (response[i].CategoryLevelCode == j) {

                var createHtml = '';
                var nextDepth = j + 1;

                createHtml += '<li id="liCategoryMenu' + j + 'Depth' + response[i].CategoryFinalCode + '" >';
                createHtml += '<a class="site-category" href="/Goods/GoodsList.aspx?CategoryCode=' + response[i].CategoryFinalCode + '&SearchFlag=C">';
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


//히든카테고리 리스트 바인드
function fnHiddenCategoryListBind(response) {

    for (var i = 0; i < response.length; i++) {

        for (var j = 1; j <= 3; j++) {

            if (response[i].CategoryLevelCode == j) {

                var createHtml = '';
                var nextDepth = j + 1;

                createHtml += '<li>';
                createHtml += '<a class="site-category" onclick="fnGoGoodsPage(\'' + response[i].CategoryFinalCode + '\')" >';
                createHtml += '<span>' + response[i].CategoryFinalName + '';
                createHtml += '</span>';
                createHtml += '</a>';
                if (j == 1) {

                    createHtml += '<ul>';
                    createHtml += '<li>';
                    createHtml += '<div class="divCategoryLevel02 site-category" depth="' + nextDepth + '" >';
                    createHtml += '<h4 class="site-category">' + response[i].CategoryFinalName + '<img class="categoryicon" src="/Images/Category/C_' + response[i].CategoryFinalCode + '.png"/></h4>';
                    createHtml += '<ul class="site-category" id="hiddenSubMenu' + nextDepth + 'Depth' + response[i].CategoryFinalCode + '">';
                    createHtml += '</ul>';
                    createHtml += '</div>';
                    createHtml += '</li>';
                    createHtml += '</ul>';

                }
                else if (j == 2) {

                    createHtml += '<ul  id="hiddenSubMenu' + nextDepth + 'Depth' + response[i].CategoryFinalCode + '">';
                    createHtml += '</ul>';

                }

                createHtml += '</li>';

                if (j == 1) {
                    $('#ulHiddenSubMenu1Depth').append(createHtml);
                }
                else {
                    $('#hiddenSubMenu' + j + 'Depth' + response[i].CategoryUpCode + '').append(createHtml);
                }
            }
        }
    }


    return false;
}


function fnGoGoodsPage(ccode) {
    location.href = '/Goods/GoodsList.aspx?CategoryCode=' + ccode + '&SearchFlag=C';
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
            var pageName = '/Goods/GoodsList.aspx';
            location.href = pageName + "?&GoodsName=" + searchKeyword + "&SearchFlag=" + searchFlag;
        }
    }

    var param = { Method: 'GetLinkSearchUrl', SearchKeyword: $("#txtPowerSearch").val() };
    Jajax('Post', '/Handler/GoodsHandler.ashx', param, 'json', callback);
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
            var pageName = '/Goods/GoodsList.aspx';
            location.href = pageName + "?&GoodsName=" + searchKeyword + "&SearchFlag=" + searchFlag;
        }
    }

    var param = { Method: 'GetLinkSearchUrl', SearchKeyword: $("#txtFooterSearch").val() };
    Jajax('Post', '/Handler/GoodsHandler.ashx', param, 'json', callback);
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
        location.href = '/Member/MemberJoinSelect.aspx';
    }
    else {
        location.href = '/Member/Agreement.aspx?JoinType=B';
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
    JqueryAjax('Post', '/Handler/GoodsHandler.ashx', false, false, param, 'json', callback, null, null, false, '');
}


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
    JqueryAjax('Post', '/Handler/GoodsHandler.ashx', false, false, param, 'text', callback, null, null, true, sviduser);
}

//최근 선택한 카테고리 갖고오기
function fnGetCategorySearchLog() {
    $('#ulCategorySearchLog').empty();
    $('#ulFixCategorySearchLog').empty();

    var callback = function (response) {
        if (!isEmpty(response)) {
            $.each(response, function (key, value) {
                var url = '/Goods/GoodsList?CategoryCode=' + value.CategoryFinalCode + '&SearchFlag=C'
                var html = '<a href="' + url + '"><li>' + value.CategoryFinalName + '';
                html += '</li></a>';
                $('#ulCategorySearchLog').append(html);
                $('#ulFixCategorySearchLog').append(html);
            }); //테이블 추가
        }
        else {
            $('#ulCategorySearchLog').append('<li>최근 선택한 카테고리가 없습니다.</li>');
            $('#ulFixCategorySearchLog').append('<li>최근 선택한 카테고리가 없습니다.</li>');
        }
        return false;
    }

    var param = {

        SvidUser: sviduser,
        Method: 'GetCategorySearchLog'

    };


    //type, url, async, cache, data, datatype, _callback, _beforeSend, _complete, issessionCheck, sessionValue
    JqueryAjax('Post', '/Handler/Common/CategoryHandler.ashx', true, false, param, 'json', callback, null, null, true, sviduser);
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
    JqueryAjax('Post', '/Handler/Common/CategoryHandler.ashx', true, false, param, 'text', callback, null, null, true, sviduser);
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


function bluring() {

    if (event.srcElement.tagName == "A" || event.srcElement.tagName == "IMG") document.body.focus();

}

document.onfocusin = bluring;

$(function () {

    $(window).scroll(function (event) {
        var st = $(document).scrollTop();
        if (st > 95) {
            document.getElementById("fixedDiv").style.top = "-240px";
            document.getElementById("fixedDiv-sub").style.top = "0";
            $("#divSuggestGoods").css('display', 'none');
            $(".my-category").hide();
        } else {

            document.getElementById("fixedDiv").style.top = "0";
            document.getElementById("fixedDiv-sub").style.top = "-240px";
            $(".my-category2").hide();
        }
    });
})

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