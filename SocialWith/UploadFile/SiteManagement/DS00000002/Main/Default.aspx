<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Default.aspx.cs" Inherits="_Default" %>

<%@ Import Namespace="Urian.Core" %>
<%@ Register Src="~/UserControl/ucNoticeListMain.ascx" TagName="Notice" TagPrefix="ucNotice" %>
<!DOCTYPE html>
<html>
<head runat="server">
    <asp:Literal runat="server" ID="metaDescription" EnableViewState="false"></asp:Literal>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1" />
    <meta http-equiv="Expires" content="-1" />
    <meta http-equiv="Pragma" content="no-cache" />
    <meta http-equiv="Cache-Control" content="No-Cache" />
    <meta property="og:type" content="website" />
    <asp:Literal runat="server" ID="metaOgTitle" EnableViewState="false"></asp:Literal>
    <asp:Literal runat="server" ID="metaOgDescription" EnableViewState="false"></asp:Literal>
    <asp:Literal runat="server" ID="shortcut" EnableViewState="false"></asp:Literal>
    <title><%= Title %></title>
    <!-- Viewport -->
    <meta name="viewport" content="width=device-width" />

    <!-- CSS -->
    <link rel="stylesheet" type="text/css" href="/Content/sub.css" />
    <link rel="stylesheet" type="text/css" href="/Content/jquery-ui.css" />
    <link rel="stylesheet" type="text/css" href="/Content/bootstrap.css" />
    <link rel="stylesheet" type="text/css" href="/Content/pagination.css">
    <link rel="stylesheet" type="text/css" href="/Content/slick-theme.css" />
    <link rel="stylesheet" type="text/css" href="/Content/popup.css" />
    <link rel="stylesheet" type="text/css" href="/Content/slick.css" />
    <link rel="stylesheet" type="text/css" href="/Content/flexslider.css" />
    <asp:Literal runat="server" ID="siteCss" EnableViewState="false"></asp:Literal>
    <asp:Literal runat="server" ID="defaultCss" EnableViewState="false"></asp:Literal>
    
    
    <!-- Script파일-->

    <script type="text/javascript" src="/Scripts/jquery-1.10.2.min.js"></script>

    <script type="text/javascript" src="/Scripts/bootstrap.js"></script>
    <script type="text/javascript" src="/Scripts/common.js"></script>
    <script type="text/javascript" src="/Scripts/pagination.js"></script>
    <script type="text/javascript" src="/Scripts/slick.js"></script>
    <script src="http://dmaps.daum.net/map_js_init/postcode.v2.js"></script>
    <script src="https://ssl.daumcdn.net/dmaps/map_js_init/postcode.v2.js"></script>
    <script type="text/javascript" src="/Scripts/jquery.inputmask.bundle.js"></script>
    <script type="text/javascript" src="/Scripts/jquery-ui.js"></script>
    <script type="text/javascript" src="/Scripts/jquery.flexslider.js"></script>
    <script src="http://malsup.github.com/jquery.cycle2.js"></script>

    <script src="http://malsup.github.io/jquery.cycle2.carousel.js"></script>

    <style>
        .display-none { /*감추기*/
            display: none;
        }

        .mainFavorites {
            border: 1px solid #BDBDBD;
            padding-left: 19px;
            text-align: center;
            padding-right: 19px;
            padding-top: 3px;
            padding-bottom: 3px;
            cursor: pointer;
            color: #4C4C4C;
            font-weight: bold
        }

        .bookmarkimg {
            margin-bottom: 2px
        }

        .bottomlogo {
            vertical-align: middle;
        }
    </style>
    <style>
        .ui-tooltip {
            padding: 0;
            max-width: 600px;
        }



        .product_Promotion_text {
            color: white;
            background-color: red;
            font-size: 11px;
            padding: 2px 2px 2px 2px;
            width: 48px;
        }


        p.topbtn {
            display: none;
        }
    </style>
    <script type="text/javascript">

        var qs = fnGetQueryStrings();
        var GoodsName = qs["GoodsName"];
        var qsBanner;
        
        var sviduser = '<%= SvidUser%>';
        var priceCompcode = '<%= PriceCompCode%>';
        var saleCompcode = '<%= saleCompCode%>';
        var dsCheck = '<%= BmroCheck%>';
        var freeCompYN = '<%= FreeCompanyYN%>';
        var freeCompanyVatYN = '<%= FreeCompanyVatYN%>';
        var svidRole = '<%= SvidRole%>';
		var pgFlag = '<%= PGEvaluation%>';
        var upload = '<%= ConfigurationManager.AppSettings["UpLoadFolder"].AsText()%>';
        var compCode = '<%= buyCompCode%>';
        var userId = '<%= UserId%>';
        var distCode = '<%= DistCode%>';
        var daumMapCode = '<%= daumCode%>';
        var custTelNo = '<%= custTelNo%>';
        var miniLogo = '<%= miniLogo%>';
        var saleCompAdress = '<%= saleCompAddress%>';
        var compName = '<%= companyName%>';
        var distCompName = '<%= distCompanyName%>';
        var domainURL = '<%= enterDomainUrl%>';
        var siteName = '<%= SiteName%>';
        var searchTag = '<%= SearchTag%>';
        var googleCode = '<%= googleCode%>';
        var buyCompName = '<%= UserInfoObject.UserInfo.Company_Name%>';
        var userGubun = '<%= UserInfoObject.Gubun%>';
        var useAdminRoleType ='<%= UserInfoObject.UserInfo.UseAdminRoleType%>';
</script>
<asp:Literal runat="server" ID="defaultjs" EnableViewState="false"></asp:Literal>
<script type="text/javascript">

</script>
    <style type="text/css">
        #pop {
            width: 600px;
            height: 330px;
            background: #3d3d3d;
            color: #fff;
            position: absolute;
            top: 35%;
            left: 55%;
            text-align: center;
            border: 2px solid #000;
            z-index: 100;
            position: fixed;
            overflow: auto;
            margin-left: -20%;
        }
    </style>
</head>
<body>
    <div class="container-div">
        <form id="form1" runat="server">
            <!-- 헤더 영역 시작 -->
            <input type="hidden" id="hdMasterDistCssCode" />
            <input type="hidden" id="hdDaumCode" />
            <input type="hidden" id="hdSaleCompAddress" />
            <input type="hidden" id="hdMasterMiniLogo" />
            <input type="hidden" id="hdMasterCustTelNo" />
            <input type="hidden" id="hdMasterCompanyName">
            <input type="hidden" id="hdMasterDistCompanyName">
            <input type="hidden" id="hdMasterDns">
            <input type="hidden" id="hdMasterSiteName">
            <header>
                <div class="topbanner-wrap" id="divTopmenu" runat="server" style="display:none">
                    <asp:Image runat="server" ID="imgTB" />
                    <a href="#none" id="btnTopMenuCls"><img src="/Images/icon_close_24x24.png" alt="닫기"/></a>
                </div>
<%--                <div>
                    <img src="./images/flower.jpg"/>
                </div>--%>
                <div style="background-color:#f9f9f9;" class="top_stickymenu_wrap">
                    <div class="top_stickymenu">
                        <div class="leftinfo">
                            <ul class="leftinfo-list">
                                <li><a class="top_stickymenu_a" onclick="javascript:return fnAddFavorite();">즐겨찾기</a><span class="tx_bar"></span></li>
                                <li><a class="top_stickymenu_a" href="/Board/BoardList">질문게시판</a><span class="tx_bar"></span></li>
                                <li><a class="top_stickymenu_a" href="/Other/Faq.aspx">FAQ</a><span class="tx_bar"></span></li>
                                <li><a class="top_stickymenu_a" href="/Order/OrderBillIssue.aspx">세금계산서 조회</a><span class="tx_bar"></span></li>
                                <li id="liStickyCart" style="display: none" runat="server"><a class="top_stickymenu_a" href="/Cart/CartList.aspx">장바구니 <span class="top_info_num">
                                    <asp:Label runat="server" ID="lblCartCnt"></asp:Label></span></a></li>
                            </ul>
                        </div>
                        <div class="rightinfo" >
                            <ul class="rightinfo-list" id="ulRightInfo" runat="server">
                                <li id="liStatisticsMenu" style="display:none" runat="server">
                                    <a href="/Statistics/Statistics.aspx">관리자</a><span class="tx_bar"></span>
                                </li>
                                <li>
                                    <a style="cursor: unset !important">
                                        <asp:Label runat="server" ID="lblUser" Style="cursor: unset !important"></asp:Label></a><span class="tx_bar"></span></li>
                                <li>
                                    <a style="cursor: unset !important">
                                        <asp:Label runat="server" ID="lblDeptName" Style="cursor: unset !important"></asp:Label></a><span class="tx_bar"></span></li>
                                <li class="mypage" style="width: 106px; display: none">
                                    <a class="top_stickymenu_mypage" href="/Order/OrderHistoryList.aspx" style="width: 86px">
                                        <span>
                                            <img src="./images/mypage_small.png" /></span>마이페이지
                                        <span class="downarrow"></span>
                                    </a>
                                    <span class="tx_bar"></span>
                                    <ul  class="mypage_sub_menu">
                                        <li><a href="Order/OrderHistoryList.aspx">주문조회</a></li>
                                        <li><a href="Delivery/DeliveryOrderList.aspx">배송조회</a></li>
                                        <li><a href="Order/OrderBillIssue.aspx">세금계산서 조회</a></li>
                                        <li><a href="Member/MemberEditCheck.aspx">마이정보변경</a></li>
                                        <li><a href="Delivery/DeliveryList.aspx">배송지관리</a></li>
                                    </ul>
                                </li>
                                <li style="float: left">
                                    <a onclick="fnLogout(); return false;">로그아웃</a><span><img src="./images/logout_small.png" /></span>
                                    <%--<asp:LinkButton CssClass="top_stickymenu_a" ID="lbtnLogout" runat="server" OnClick="lbtnLogout_Click"><span>로그아웃</span><span style="margin-left:4px;"><img src="./images/logout_small.png" /></span></asp:LinkButton>--%>
                                </li>
                            </ul>
                         </div>
                        </div>
                    </div>

                <div class="top_header">
                    <div class="top_header_left">
                        <div class="toplogodiv">
                            <a href="../Default.aspx">
                                <asp:Image runat="server" ID="imgTopLogo" CssClass="toplogo" />
                            </a>
                        </div>
                        <div class="searchdiv">
                            <fieldset class="powersearch-sitecss">
                                <input class="powersearch powersearch-sitecss" type="text" id="txtPowerSearch" onkeypress="return fnPowerSearchEnter('Main');" />
                                <input type="button" class="searchIcon" onclick="fnPowerSearch('Main'); return false;">
                            </fieldset>
                        </div>

                    </div>

                </div>
                <div class="navi-div navi-sitecss">
                    <div class="navi-div-wrap">
                        <!--마이카테고리-->
                        <div class="my-category">
                            <a alt="카테고리" class="btn-my on">
                                <img src="/Images/Button/my-category_select.png" alt="카테고리" />
                            </a>
                            <div class="btn-my-box">
                                <p class="recent-category">최근 선택한 카테고리</p>
                                <ul id="ulCategorySearchLog">
                                   
                                </ul>
                                <p class="delete-category" id="pDeleteCategorySearchLog">카테고리 기록 삭제</p>
                            </div>
                        </div>
                         <!--마이카테고리 끝-->
                        <div id="navi-liAll">
                            <a class='categoryAllBtn ctgrall-sitecss' id="btnNaviAll">
                                <img src="/Images/Button/categorybtn_all.png" alt="전체버튼" />카테고리</a>
                            <a alt="카테고리" class="btn-my">
                                <img src="/Images/Button/my-category.png" alt="카테고리" />
                            </a>
                            <div id="navi-allCategorySub" class="navi-AllCategoryList">
                                <ul class="site-category" id="ulSubMenu1Depth" style="padding-left: 0px">
                            

                                </ul>
                            </div>
                        </div>
                        <ul id="categories" class="stickymenu">
                                <li><a href="/Order/OrderHistoryList.aspx">주문조회</a></li>
                                <li><a href="/Delivery/DeliveryOrderList.aspx">배송조회</a></li>
                                <li id="liCategoryWish" style="display:none" runat="server"><a href="/Wish/WishList.aspx">위시상품 리스트</a></li>
                                <li><a href="/Goods/GoodsRecommListSearch.aspx">견적상품게시판</a></li>
                                <li id="liCategoryNewGood" style="display:none" runat="server"><a href="/Goods/NewGoodsRequestMain.aspx">신규견적요청</a></li>
                                <%--<li><a href="/Statistics/Statistics.aspx">구매사 관리자</a></li>--%>
                        </ul>

                    </div>
                </div>
            </header>

            <!-- 헤더 영역 끝 -->
            <div class="contents-wrap">
                <!--매출내역 퀵메뉴 팝업 시작-->
                <div id="quick">
                    <div class="title">
                        <div class="month"></div>
                        <div class="sub_title"><span class="name">한국가스공사</span><span>구매내역</span></div>
                        <div class="icon"><img src="/Images/main/icon.png" /></div>
                        <a href="#none" id="quickClose" class="close"><img src="/Images/main/close.png" /></a>
                    </div>
                    <ul id="quickMenuList" class="ul">
                    </ul>
                </div>
                <!--매출내역 퀵메뉴 팝업 끝-->
                <!--인기카테고리 시작-->
                <div class="category-bnr" style="display:none">
                    <div>
                        <div>
                            <span class="bnr-title">인기상품 BEST5</span><%--<span class="more-view">더보기</span>--%>
                        </div>
                        <ul id="ulPopularGoods">
                        </ul>
                    </div>
                </div>
                <!--인기카테고리 끝-->
                <!--롤링배너 시작 -->
                    <div class="billboard-wrap" id="divrollbanner">
                        <div class="billboard-main" id="divrollimg">
                        </div>
                        <div class="tab-wrap">
                            <div class="ctrl">
                                <span class="cnt"><strong id="sIndex">1</strong>/<span class="bannerTotalCnt" id="sBannerTotalCnt"></span></span>
                                <button class="prev" id="btnBannerPrev"><i>이전</i></button>
                                <button class="next" id="btnBannerNext"><i>다음</i></button>
                            </div>
                            <div class="billboard-tab">
                                <ul id="ulrollTab">
                                </ul> 
                            </div>
                        </div>
                    </div>

                </div>
                <!--롤링배너 끝 -->

            <!-- Contents 시작 -->
            <div class="contents-main">

                <div class="main-csbanner-wrap">
                    <div class="main-banner">
                        <img src="./images/Banner/main_banner.png" /></div>
                    <div class="main-csbanner">
                        <ul>
                            <li class="info_box notice">
                                <p class="notice_tit">공지사항</p>
                                <div>

                                    <ucNotice:Notice ID="ucNoticeMain" runat="server" />
                                </div>
                            </li>
                            <li class="info_box exchange">
                                <div>
                                    <p class="exchange_tit">반품/교환 전에 꼭 확인하세요.</p>
                                    <p style="margin-top: 6px;">배송완료일부터 7일 이내 반품/교환 신청이 가능합니다.</p>
                                    <p style="font-size: 12px;">(상품박스 및 상품 훼손, 반품 불가 표기 항목 제외)</p>
                                    <p style="margin-top: 20px;"><a class="plus_text" style="display: none;" href="../Goods/ReturnExchangeRequest.aspx">교환 및 반품 바로가기 ></a></p>
                                </div>
                            </li>

                            <li class="info_box info">
                                <div>
                                    <p class="call_number" id="spanCustTelNo"></p>
                                    <p>토/일요일 및 공휴일은 1:1 문의하기를 이용해주세요.</p>
                                    <p>업무가 시작 되면 바로 처리해드리겠습니다.</p>
                                    <p style="margin-top: 20px;"><a class="plus_text" href="/Other/Faq.aspx">FAQ 바로가기></a><a class="plus_text" href="../Board/BoardList" style="margin-left: 10px;">1:1 바로가기></a></p>
                                </div>
                            </li>
                        </ul>

                    </div>
                </div>
                <div class="category-landing-wrap" id="divCategoryLanding" style="display: none">
                    <%--<div class="main-title-wrap">
                            <span> <img src="./images/starw.png" /></span>
                            <span style="margin-left:1px;" class="stlage_text"> 인기전용관</span>
                        </div>--%>

                    <div class="category-landing-main">
                        <ul id="ulCategoryLanding">
                        </ul>
                    </div>
                </div>


                <%--<div class="line_gy"><span><img src="./images/gray_line.jpg" /></span></div>--%>
                <div class="main-best-wrap" style="">
                    <div class="main-best">

                        <div class="main-title-wrap">
                            <span>
                                <img src="./images/recommend.png " />
                            </span>
                            <span style="margin-left: 1px;" class="lage_text">추천상품
                                 <span class="small_text">지금 가장 인기있는 상품</span>
                            </span>
                        </div>

                        <ul class="main-best-tab">
                            <li id="liAll" class="active" style="border-left: 1px solid #e2e2e2; width: 10%">
                                <a><span style="font-size: 14px;">전체</span></a>
                            </li>

                            <li id="li01">
                                <a><span style="font-size: 14px;">식음료</span></a>
                            </li>
                            <li id="li02">
                                <a><span style="font-size: 14px;">사무용품</span></a>
                            </li>
                            <li id="li03">
                                <a><span style="font-size: 14px;">생활용품</span></a>
                            </li>
                            <li id="li04">
                                <a><span style="font-size: 14px;">일반공구</span></a>
                            </li>
                            <li id="li05">
                                <a><span style="font-size: 14px;">시설자재</span></a>
                            </li>
                        </ul>

                        <div class="main-best-list" id="recommandList"></div>
                    </div>
                </div>

                <%-- <div style="text-align:center; margin:0 auto;"><img src="./images/color_d.jpg" /></div>--%>


                <%--<div class="line_gy"><span><img src="./images/gray_line.jpg" /></span></div>--%>

                <div id="defaultMiddleBanner" style="display: none">
                    <div class="main-title-wrap">
                        <span>
                            <img src="./images/jang.png" /></span>
                        <span class="aglarge_test">중증장애인생산품 바로가기</span>
                    </div>
                    <ul class="main-middle-banner" id="ulDiperson">
                    </ul>
                </div>

                <div id="divPartnersContent" style="display: none;">
                    <div class="main-title-wrap">
                        <span>
                            <img src="./images/agreement.jpg" /></span>
                        <span class="aglarge_test">협약기관</span>
                    </div>
                    <ul id="ulPartners" class="ulPartnersList"></ul>
                </div>


            </div>
        </form>
    </div>



    <!-- Contents 끝 -->
    <!-- 컨텐츠 영역 끝 -->
    <%-- <div id="bottomBanner" class="delivery" ><img src="../Images/exchangeBannner.jpg" style="width:100%"/></div>--%>
    <!-- Footer 영역 시작 -->
    <div class="footer_deliveryfree">
        <div class="del_img">
            <img src="./images/deliveryfree.jpg" />
        </div>
    </div>
    <div class="footer-div">

        <div class="footer-menu-div">
            <ul id="ulBottomMenu">
                <li><a href="/Other/CompanyAbout.aspx?MenuUpCode=MEBT001000000000&amp;Tab=1">회사소개</a></li>
                <li><a href="/Other/Agreement.aspx">이용약관</a></li>
                <li><a href="/Other/Privacy.aspx">개인정보취급방침</a></li>
                <li id="bottomMenuLiConduct"><a href="/Other/Conduct.aspx">공급자행동강령</a></li>
            </ul>
        </div>


        <div class="copyright" style="padding-top: 10px">
            <div style="display: inline; padding-right: 20px;">
                <asp:Image runat="server" ID="imgBottomLogo" />
            </div>


            <div style="display: inline;">
                <asp:Image runat="server" ID="imgCopy" />
                <a id="aFTC" href="<%= ftcUrl%>" target="_blank">
                    <img src="Images/SiteImage/ftcImage.png" />

                </a>

            </div>
        </div>
    </div>
    <!-- Footer 영역 끝 -->

    <div id="pop" style="display: none">
        <h3 style="text-align: left; font-weight: bold; padding-left: 20px;">견적 추천 상품</h3>
        <br />

        <div style="height: 200px; font-size: 20px">
            새로운 추천 상품 리스트  <span style="font-size: 40px; font-weight: bold" id="spanGoodsRecommCount"></span>이 있습니다.<br>
            리스트 확인을 위해 이동하시겠습니까?<br />
            <br />
            <input type="button" style="width: 100px;" class="btn btn-info" value="이동" id="btnGoRecomm" />
            <br />
        </div>
        <div style="display: inline-block; float: left">
            &nbsp&nbsp&nbsp&nbsp&nbsp<input type="CHECKBOX" class="checkbox-inline" name="Notice" value="" id="cbGoodsRecomm">
            <span style="line-height: 10px;">위 내용을 다시 보지 않겠습니다.</span>

        </div>

        <div style="display: inline-block; float: right">
            <input type="button" id="btnClosePop" style="width: 100px;" class="btn btn-default" value="닫기" />&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp
        </div>
    </div>

    <div class="floatbar">
        <div class="btmbar">
            <ul class="btmBtns">
                <li><a href="/Default.aspx" class="btmico01">
                    <p>
                        <img src="./images/b_home.png" /></p>
                    <p>홈</p>
                </a></li>
                <li>
                    <a href="javascript: ;" class="btmico02">
                        <p>
                            <img src="./images/b_serch.png" /></p>
                        <p>검색</p>
                    </a>

                    <a href="javascript: ;" class="btmico02 close" style="display: none;">
                        <p style="font-size: 18px; padding-bottom: 2px;">
                            <img src="./images/close-bottom.png" /></p>
                        <p>닫기</p>
                    </a>
                    <div class="searchBar" style="display: none;">
                        <div>
                            <input type="text" placeholder="검색어를 입력해주세요." id="txtFooterSearch" onkeypress="return fnFooterPowerSearchEnter();">
                            <input type="button" class="footersearchicon" onclick="fnFooterPowerSearch(); return false;" id="mainSearchBtn" />

                        </div>
                    </div>

                </li>
                <li id="libottomCart" style="display: none" runat="server"><a href="/Cart/CartList.aspx" class="btmico03">
                    <p>
                        <img src="./images/b_baguni.png" /></p>
                    <p>장바구니</p>
                </a></li>
                <li><a href="/Order/OrderHistoryList.aspx" class="btmico04">
                    <p>
                        <img src="./images/b_myshopping.png" /></p>
                    <p>나의쇼핑</p>
                </a></li>
                <li><a href="Other/Faq.aspx" class="btmico05">
                    <p>
                        <img src="./images/b_call.png" /></p>
                    <p>고객센터</p>
                </a></li>
            </ul>
            <div class="recentGoods">
                <div>
                    <strong>오늘 본 상품</strong>
                    <p class="nolist" style="display: none;">오늘 본 상품이 없습니다.</p>
                    <div class="recentArea">
                        <ul class="recentList">
                        </ul>
                        <a href="javascript: ;" class="btn_moreGoods">
                            <p style="font-size: 20px; padding-top: 5px; font-weight: bold;">+</p>
                            <p>더보기</p>
                        </a>
                        <a href="javascript: ;" class="btn_moreClose" style="display: none;">
                            <p>닫기</p>
                            <p style="font-size: 18px; font-weight: bold;">X</p>
                        </a>
                        <div class="moreGoods" style="display: none;">
                            <p style="float: left; padding-right: 23px;">
                                <img src="./images/b_st.png" /></p>
                            <p style="float: left;">오늘 본 상품</p>
                            <p style="padding-left: 284px;">
                                <img src="./images/b_st.png" /></p>
                            <div class="moreListWrap">
                                <ul class="moreList">
                                </ul>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="btnBtmWrap2">
                <a href="javascript:footSlide('top');" class="btn_BtmTop">
                    <p>∧</p>
                    <p>TOP</p>
                </a>
                <a href="javascript:footSlide('bottom');" class="btn_BtmBtm">
                    <p>DOWN</p>
                    <p>∨</p>
                </a>
            </div>
        </div>
    </div>

    <div class="btnBtmWrap">
        <a href="javascript: ;" class="btn_BtmDown">
            <p style="font-size: 18px; padding-bottom: 5px; font-weight: bold;">▼</p>
            <p>접기</p>
        </a>
        <a href="javascript: ;" class="btn_BtmUp">
            <p style="font-size: 18px; padding-bottom: 5px; font-weight: bold;">△</p>
            <p>펴기</p>
        </a>
    </div>

    <div id="divSuggestGoods" class="ui-autocomplete-suggest" style="background-color: white; height: 443px; width: 442px; display: none; float: left; z-index: 1000"></div>

</body>
</html>
