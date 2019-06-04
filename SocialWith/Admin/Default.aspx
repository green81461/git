<%@ Page Title="" Language="C#" AutoEventWireup="true" CodeFile="Default.aspx.cs" Inherits="Admin_Default" %>

<!DOCTYPE html>

<html>
<head runat="server">

    <title>관리자</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0" />
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1" />
    <meta http-equiv="Expires" content="-1" />
    <meta http-equiv="Pragma" content="no-cache" />
    <meta http-equiv="Cache-Control" content="No-Cache" />
    <!-- CSS -->

    <link rel="stylesheet" type="text/css" href="../../Content/listPager.css" />
    <link rel="stylesheet" type="text/css" href="../../Content/bootstrap.css" />
    <link rel="stylesheet" type="text/css" href="../../Content/pagination.css">
    <link rel="stylesheet" type="text/css" href="/Admin/Content/main.css" />
    <link rel="stylesheet" type="text/css" href="/Admin/Content/common.css" />
    <link rel="stylesheet" type="text/css" href="/Admin/Content/popup.css" />
    <link rel="stylesheet" type="text/css" href="/Admin/Content/jquery-ui.css" />
    <link rel="stylesheet" type="text/css" href="/Admin/Content/tui-chart.css" />
    <!-- Script파일-->

    <script type="text/javascript" src="../../Scripts/jquery-1.10.2.min.js"></script>
    <script type="text/javascript" src="../../Scripts/bootstrap.js"></script>
    <script type="text/javascript" src="../../Scripts/common.js"></script>
    <script type="text/javascript" src="../../Scripts/pagination.js"></script>
    <script src="http://dmaps.daum.net/map_js_init/postcode.v2.js"></script>
    <script src="https://ssl.daumcdn.net/dmaps/map_js_init/postcode.v2.js"></script>
    <script type="text/javascript" src="../../Scripts/googleAnalytics.js"></script>
    <script type="text/javascript" src="../../Scripts/jquery.inputmask.bundle.js"></script>
    <script type="text/javascript" src="../../Scripts/jquery-ui.js"></script>
    <script type="text/javascript" src="../../Scripts/core.js"></script>
    <script type='text/javascript' src='../../Scripts/tui-code-snippet.min.js'></script>
    <script type='text/javascript' src='../../Scripts/raphael.min.js'></script>
    <script type="text/javascript" src="../../Scripts/tui-chart.js"></script>

    <script type="text/javascript">
        var qs = fnGetQueryStrings();
        var ucode = qs["ucode"];
        $(function () {
        });

       //$(document).keydown(function (e) {
       //     if (e.which === 116) {
       //         if (typeof event == "object") {
       //             event.keyCode = 0;
       //         }
       //         return false;
       //     }
       //     else if (e.which === 82 && e.ctrlKey) {
       //         return false;
       //     }
       // });

       // window.addEventListener("beforeunload", function (e) {
       //     if ($('a').click) {
       //         (e || window.event).returnValue = null;
       //         return null;
       //     }
       //         fnLogout();
       //         return false;

       //     (e || window.event).returnValue = null;
       //     return null;
       // });

        //로그아웃
        function fnLogout() {
            var callback = function (response) {
                if (!isEmpty(response)) {
                    if (response == 'OK') {
                        location.href = '/Admin/Login.aspx';
                    }
                    else {
                        alert('로그아웃을 해주세요.');
                    }
                }
                else {
                    alert('시스템 오류입니다. 관리자에게 문의하세요.');
                }
                return false;
            }

            var param = {
                Method: 'SetAdminLogOut'
            };

            JqueryAjax('Post', '/Handler/Common/UserHandler.ashx', true, false, param, 'text', callback, null, null, true, '<%=Svid_User%>');
        }
    </script>

</head>
<body>
    <form id="form1" runat="server">
        <div class="admin-container">
            <div class="admin-header">
                <div class="admin-mainmenu-wrap">
                    <span class="admin-title">소셜위드 관리자</span>
                    <ul class="admin-mainmenu-list" id="ulMainMenu">
                        <li><a href="/Admin/Order/OrderHistoryList.aspx?ucode=01">주문관리</a></li>
                        <li><a href="/Admin/Goods/CategoryManage.aspx?ucode=02">상품관리</a></li>
                        <li><a href="/Admin/Company/CompanyManagement.aspx?ucode=03">회원관리</a></li>
                        <li><a href="/Admin/Board/Board_A.aspx?ucode=04">게시판 관리</a></li>
                        <li><a href="/Admin/Promotion/PromotionManagement.aspx?ucode=05">프로모션/쿠폰</a></li>
                        <li><a href="/Admin/SCMquote/newGoodsRequest.aspx?ucode=06">[SCM]견적관리</a></li>

                        <%-- <li><a href="#">디자인</a></li>--%>
                        <li><a href="/Admin/Setting/SiteInfoDefault.aspx?ucode=08">환경설정</a></li>
                    </ul>
                    <div class="admin-header-info">
                        <ul>
                            <li class="admin-header-user"><a href="#">
                                <!--<img style="margin-right:2px;" src="/Admin/Images/top_login.png">-->
                                <asp:Label runat="server" ID="lblUser"></asp:Label></a>님</li>
                            <li class="admin-header-logout">
                                <%--<asp:LinkButton ID="lbLogout" runat="server" Text="로그아웃  →" CssClass="admin-logout" OnClick="lbLogout_Click"></asp:LinkButton>--%>
                                <a class="admin-logout" onclick="return fnLogout();">로그아웃  →</a>
                            </li>
                        </ul>
                    </div>
                </div>
            </div>
            <div class="admin-mainwrap">
                <div class="admin-default">
                    <div class="admin-dt01-wrap">
                        <div class="admin-dt01">
                            <div class="admin-dt-title-wrap">
                                <img style="width: 38px;" src="/Admin/Images/icon_01.jpg">
                                <span>주문관리</span><span class="titleinfo">(30일 기준)</span>
                                <a href="/Admin/Order/OrderHistoryList.aspx?ucode=01" style="cursor: pointer"><span class="admin-moreinfo1" style="float: right; font-size: 11px; font-weight: normal; font-family: 'Noto Sans KR Regular'; letter-spacing: 0px; padding-top: 17px">+더보기</span></a>
                            </div>
                            <div class="admin-dt-table-wrap">
                                <ul id="ordermanage">
                                    <li><a href="/admin/Order/OrderHistoryList?ucode=01&ordstatus=100"><span>주문완료</span><div id="ordermng_type1"></div>
                                    </a></li>
                                    <li><a href="/admin/Order/OrderHistoryList?ucode=01&ordstatus=101"><span>주문완료<br />
                                        (입금전)</span><div id="ordermng_type2"></div>
                                    </a></li>
                                    <li><a href="/admin/Order/OrderHistoryList?ucode=01&ordstatus=102"><span>주문완료<br />
                                        (ARS결제전)</span><div id="ordermng_type3"></div>
                                    </a></li>
                                    <li><a href="/admin/Order/OrderHistoryList?ucode=01&ordstatus=200"><span>배송준비</span><div id="ordermng_type4"></div>
                                    </a></li>
                                    <li><a href="/admin/Order/OrderHistoryList?ucode=01&ordstatus=207"><span>출고완료</span><div id="ordermng_type5"></div>
                                    </a></li>
                                    <li><a href="/admin/Order/OrderHistoryList?ucode=01&ordstatus=301"><span>배송중</span><div id="ordermng_type6"></div>
                                    </a></li>
                                    <li><a href="/admin/Order/OrderHistoryList?ucode=01&ordstatus=302"><span>배송완료</span><div id="ordermng_type7"></div>
                                    </a></li>
                                    <li><a href="/admin/Order/OrderHistoryList?ucode=01&ordstatus=422"><span>주문취소완료</span><div id="ordermng_type8"></div>
                                    </a></li>
                                </ul>
                            </div>
                        </div>
                    </div>

                    <div class="admin-dt02-wrap">
                        <div class="admin-dt02">
                            <div class="admin-dt-title-wrap">
                                <img style="width: 38px;" src="/Admin/Images/icon_02.jpg">
                                <span>1:1 문의</span>
                            </div>
                            <div class="admin-dt-table-wrap">
                                <div class="admin-dt-subtitle-wrap">
                                    <span class="admin-dt02-subtitle">판매사</span>
                                    <a href="/Admin/Board/Board_A.aspx?ucode=04" style="cursor: pointer; width: 7%"><span class="admin-moreinfo2" style="float: right; font-size: 11px; font-weight: normal; font-family: 'Noto Sans KR Regular'; font-weight: bold; padding-top: 3px;">+더보기</span></a>
                                </div>

                                <ul id="ulBoarda" class="admin-dashboard-boarda">
                                </ul>
                                <div style="background-color: #efefff; padding: 3px 5px;">
                                    <span class="admin-dt02-subtitle">구매사</span>
                                    <a href="/Admin/Board/Board_B.aspx?ucode=04" style="cursor: pointer; width: 7%"><span class="admin-moreinfo2" style="float: right; letter-spacing: 0px; font-size: 11px; font-weight: normal; font-family: 'Noto Sans KR Regular'; padding-top: 3px;">+더보기</span></a>
                                </div>

                                <ul id="ulBoardb" class="admin-dashboard-boardb">
                                </ul>
                            </div>
                        </div>
                    </div>

                    <div id="refreshIcon">
                        <input type="button" style="background-image: url('../Images/refresh.png'); height: 30px; background-repeat: no-repeat; width: 30px; margin-left: -35px; background-color: none; background-color: transparent !important; outline: none;" onclick="fnGetDefaultPackage();" />
                    </div>

                    <div class="admin-dt03-wrap">
                        <div class="admin-dt03">
                            <div class="admin-dt-title-wrap">
                                <img style="width: 38px;" src="/Admin/Images/icon_03.jpg">
                                <span>공지사항</span>
                                <a href="/Admin/Notice/NoticeList.aspx?ucode=04" style="cursor: pointer"><span class="admin-moreinfo1" style="float: right; letter-spacing: 0px; font-size: 11px; font-weight: normal; font-family: 'Noto Sans KR Regular'; padding-top: 17px">+더보기</span></a>
                            </div>
                            <div class="admin-dt-table-wrap">
                                <ul id="ulNotice">
                                </ul>
                            </div>
                        </div>
                    </div>
                    <div class="admin-dt04-wrap">
                        <div class="admin-dt04">
                            <div class="admin-dt-title-wrap">
                                <img style="width: 38px;" src="/Admin/Images/icon_04.jpg">
                                <span>신규요청상품</span>
                                <a href="/Admin/SCMquote/newGoodsRequest.aspx?ucode=06" style="cursor: pointer"><span class="admin-moreinfo1" style="float: right; font-size: 11px; letter-spacing: 0px; font-weight: normal; font-family: 'Noto Sans KR Regular'; padding-top: 17px">+더보기</span></a>
                            </div>
                            <div class="admin-dt-table-wrap">
                                <ul id="ulNewRequest">
                                </ul>
                            </div>
                        </div>
                    </div>
                    <div class="admin-dt05-wrap">
                        <div class="admin-dt05">
                            <div class="admin-dt-title-wrap">
                                <img style="width: 38px;" src="/Admin/Images/icon_05.jpg">
                                <span>가입현황</span>
                            </div>
                            <div class="admin-dt-table-wrap">
                                <div class="admin-dt-subtitle-wrap">
                                    <div style="background-color: #efefff; padding: 0 5px; margin-bottom: 5px;">
                                        <span class="admin-dt05-subtitle">판매사
                                        </span>
                                        <a href="/Admin/Member/MemberMain_A.aspx?ucode=03" style="cursor: pointer; width: 17%;"><span class="admin-moreinfo1" style="float: right; font-size: 11px; font-weight: normal; font-family: 'Noto Sans KR Regular'; padding-top: 3px;">+더보기</span></a>
                                    </div>


                                    <div>
                                        <span style="padding: 0 3px; display: inline-block; width: 100%">총 <b id="membertypeA_total" style="color: red"></b>회원  [<b id="membertypeA_confirmY"></b> 승인 / <b id="membertypeA_confirmN"></b>미승인(<b id="membertypeA_stop"></b> 중지, <b id="membertypeA_leave"></b>탈퇴)]</span>
                                        <span style="padding: 0 3px; display: inline-block; width: 100%">금일 신규가입 : <b id="membertypeA_today" style="color: red"></b></span>
                                    </div>
                                </div>
                                <div style="height: 50%;">
                                    <div style="background-color: #efefff; padding: 0 5px; margin-bottom: 5px;">
                                        <span class="admin-dt05-subtitle">구매사
                                        </span>
                                        <a href="/Admin/Member/MemberMain_B.aspx?ucode=03" style="cursor: pointer; width: 17%"><span class="admin-moreinfo1" style="float: right; font-size: 11px; font-family: 'Noto Sans KR Regular'; letter-spacing: 0px; font-weight: normal; padding-top: 3px;">+더보기</span></a>
                                    </div>

                                    <div>
                                        <span style="padding: 0 3px; display: inline-block; width: 100%">총 <b id="membertypeB_total" style="color: red"></b>회원  [<b id="membertypeB_confirmY"></b> 승인 / <b id="membertypeB_confirmN"></b>미승인(<b id="membertypeB_stop"></b> 중지, <b id="membertypeB_leave"></b>탈퇴)]</span>
                                        <span style="padding: 0 3px; display: inline-block; width: 100%">금일 신규가입 : <b id="membertypeB_today" style="color: red"></b></span>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="admin-dt06-wrap">
                        <div class="admin-dt06">
                            <div class="admin-dt-title-wrap">
                                <img style="width: 38px;" src="/Admin/Images/icon_08.png">
                                <span>방문현황</span>
                            </div>
                            <ul class="visit_list">
                                <li>
                                    <img src="/Admin/Images/day.png" />
                                    <p class="count" id="pDayVisitCount"></p>
                                    <p class="title">일일방문자수</p>
                                </li>
                                <li>
                                    <img src="/Admin/Images/month.png" />
                                    <p class="count" id="pMonthVisitCount"></p>
                                    <p class="title" id="pMonthVisitTxt"></p>
                                </li>
                                <li>
                                    <img src="/Admin/Images/rank.png" />
                                    <p class="count" id="pMonthPrice"></p>
                                    <span class="id" id="spRankIdAndName"></span>
                                    <p class="title" id="pRankTxt"></p>
                                </li>
                            </ul>
                        </div>
                    </div>

                    <div class="admin-dt06-wrap">
                        <div class="admin-dt06">
                            <div class="admin-dt-title-wrap">
                                <img style="width: 38px;" src="/Admin/Images/icon_06.jpg">
                                <span>주문현황</span><span class="titleinfo">(7일 기준)</span>
                                <a href="/Admin/Order/OrderHistoryList.aspx?ucode=01" style="cursor: pointer"><span class="admin-moreinfo1" style="float: right; font-size: 11px; font-weight: normal; letter-spacing: 0px; padding-top: 17px">+더보기</span></a>
                            </div>
                            <div class="admin-dt-table-wrap">
                                <table class="admin-dt-ordertable">
                                    <thead>
                                        <tr>
                                            <th>날짜
                                            </th>
                                            <th>주문 금액
                                            </th>
                                            <th>취소 금액
                                            </th>
                                            <th>매출 금액
                                            </th>
                                        </tr>
                                    </thead>
                                    <tbody id="tbodyOrderStatus">
                                    </tbody>
                                </table>
                            </div>
                            <div class="admin-chartwrap">
                                <div class='admin-chart'>
                                    <div class='code-html' id='code-html'>
                                        <div id='chart-area'></div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="admin-dt07-wrap">
                        <div class="admin-dt07">
                            <div class="admin-dt-title-wrap">
                                <img style="width: 38px;" src="/Admin/Images/icon_07.png">
                                <span>배송납기현황</span>
                                <a href="/Admin/Order/OrderHistoryList.aspx?ucode=01" style="cursor: pointer"><span class="admin-moreinfo1" style="float: right; font-size: 11px; font-weight: normal; letter-spacing: 0px; padding-top: 17px">+더보기</span></a>
                            </div>
                            <div class="admin-dt-table-wrap">
                                <p>[<span id="spPrevMonth"></span> 평균]</p>
                                <table class="admin-dt-ordertable colunms-3">
                                    <thead>
                                        <tr>
                                            <th>구분</th>
                                            <th>소요일</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <tr>
                                            <td>배송준비</td>
                                            <td><span id="spPrevDlvrReady"></span></td>
                                        </tr>
                                        <tr>
                                            <td>발주준비</td>
                                            <td><span id="spPrevSupplyOrd"></span></td>
                                        </tr>
                                        <tr>
                                            <td>입고준비</td>
                                            <td><span id="spPrevEnterGoods"></span></td>
                                        </tr>
                                        <tr>
                                            <td>출고준비</td>
                                            <td><span id="spPrevOutGoods"></span></td>
                                        </tr>
                                        <tr>
                                            <td>배송중</td>
                                            <td><span id="spPrevDlvring"></span></td>
                                        </tr>
                                        <tr>
                                            <td>배송완료</td>
                                            <td><span id="spPrevDlvry"></span></td>
                                        </tr>
                                    </tbody>
                                </table>
                            </div>
                            <div class="admin-dt-table-wrap">
                                <p>[<span id="spNowMonth"></span> 평균]</p>
                                <table class="admin-dt-ordertable colunms-3">
                                    <thead>
                                        <tr>
                                            <th>구분</th>
                                            <th>소요일</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <tr>
                                            <td>배송준비</td>
                                            <td><span id="spNowDlvrReady"></span></td>
                                        </tr>
                                        <tr>
                                            <td>발주준비</td>
                                            <td><span id="spNowSupplyOrd"></span></td>
                                        </tr>
                                        <tr>
                                            <td>입고준비</td>
                                            <td><span id="spNowEnterGoods"></span></td>
                                        </tr>
                                        <tr>
                                            <td>출고준비</td>
                                            <td><span id="spNowOutGoods"></span></td>
                                        </tr>
                                        <tr>
                                            <td>배송중</td>
                                            <td><span id="spNowDlvring"></span></td>
                                        </tr>
                                        <tr>
                                            <td>배송완료</td>
                                            <td><span id="spNowDlvry"></span></td>
                                        </tr>
                                    </tbody>
                                </table>
                            </div>
                            <div class="admin-dt-table-wrap">
                                <p>[<span id="spNowYear"></span> 평균]</p>
                                <table class="admin-dt-ordertable colunms-3">
                                    <thead>
                                        <tr>
                                            <th>구분</th>
                                            <th>소요일</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <tr>
                                            <td>배송준비</td>
                                            <td><span id="spYearDlvrReady"></span></td>
                                        </tr>
                                        <tr>
                                            <td>발주준비</td>
                                            <td><span id="spYearSupplyOrd"></span></td>
                                        </tr>
                                        <tr>
                                            <td>입고준비</td>
                                            <td><span id="spYearEnterGoods"></span></td>
                                        </tr>
                                        <tr>
                                            <td>출고준비</td>
                                            <td><span id="spYearOutGoods"></span></td>
                                        </tr>
                                        <tr>
                                            <td>배송중</td>
                                            <td><span id="spYearDlvring"></span></td>
                                        </tr>
                                        <tr>
                                            <td>배송완료</td>
                                            <td><span id="spYearDlvry"></span></td>
                                        </tr>
                                    </tbody>
                                </table>
                            </div>
                            <div class="admin-chartwrap">
                                <div class="admin-chart">
                                    <div class="code-html" id="divDlvrCode-html">
                                        <div id="chart-area2"></div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>


                </div>




            </div>
            <div class="admin-bottomwrap">
                <div class="admin-copyright">
                    <p>COPYRIGHT (C) SocialWith ALL RIGHTS RESERVED.</p>
                </div>
            </div>
        </div>



    </form>
</body>
<script>

    $(function () {
        fnRefresh();
    });

    // 새로고침
    function fnRefresh() {
        var refresh = setInterval(function () {
            fnGetDefaultPackage();
        }, 3000);
    }

    var totalArray = new Array();
    var dateArray = new Array();

    fnGetDefaultPackage();

    function fnGetDefaultPackage() {
        var callback = function (response) {
            fnGetOrderManage(response["table_1"]);   //주문관리
            fnGetNoticeMain(response["table_2"]); //공지사항
            fnGetBoard(response["table_3"]); //1:1문의
            fnGetOrderStatus(response["table_4"]); //주문현황
            fnGetNewGoodsRequest(response["table_5"]); //신규견적요청
            fnGetMemberInfo(response["table_6"]); //회원가입현황
            fnGetDeliveryDueInfo(response["table_7"]); //배송납기현황 정보
            fnGetVisitStatus(response["table_8"]); //방문현황
            fnGetDeliveryDueChart(response["table_9"]); //배송납기현황 차트

        }
        var param = {
            Method: 'GetAdminDefaultPackage',
        };

        JqueryAjax('Post', '../../Handler/DefaultHandler.ashx', false, false, param, 'json', callback, null, null, false, '');

    }

    //방문현황
    function fnGetVisitStatus(response) {

        var date = new Date();
        var month = (date.getMonth() + 1);

        $.each(response, function (key, value) {


            $("#pDayVisitCount").text(!isEmpty(value.TODAYLOGINCOUNT) ? value.TODAYLOGINCOUNT : 0);
            $("#pMonthVisitCount").text(!isEmpty(value.MONTHLOGINCOUNT) ? value.MONTHLOGINCOUNT : 0);
            $("#pMonthPrice").text(!isEmpty(value.RANKAMT) ? numberWithCommas(value.RANKAMT) + "원" : 0 + "원");
            $("#spRankIdAndName").text(!isEmpty(value.RANKUSER) ? value.RANKUSER : "-");
            $("#pMonthVisitTxt").text(month + "월누적 방문자수");
            $("#pRankTxt").text(month + "월구매 Rank Top1");


        });


    }



    //배송납기현황 차트
    function fnGetDeliveryDueChart(response) {
        var arrCategory = new Array();
        var arrData = new Array();

        $.each(response, function (key, value) {
            var strDate = value.YYYYMM + '';
            var tmpYear = strDate.substring(0, 4);
            var tmpMonth = strDate.substring(4, 6);

            var tmpPrevMonth = 0;
            var strCategory = '';

            if (key > 0) {
                tmpPrevMonth = parseInt(response[key - 1].YYYYMM.substring(4, 6));
            }

            if (parseInt(tmpMonth) < tmpPrevMonth) {
                strCategory = tmpYear + "년" + tmpMonth + "월";

            } else {
                if (key == 0) {
                    strCategory = tmpYear + "년" + tmpMonth + "월";
                } else {
                    strCategory = tmpMonth + "월";
                }
            }

            arrCategory[key] = strCategory;
            arrData[key] = value.DELIVERYDATE;
        });

        var container = document.getElementById('chart-area2');
        var data = {
            categories: arrCategory,

            series: [{
                name: '소요일',
                data: arrData
            }
            ]
        };
        var options = {
            chart: {
                width: 540,
                height: 438,
                format: '1,000'
            },
            yAxis: {
                title: '소요일',
                min: 0,
                //max: 9000
            },
            xAxis: {
                title: '날짜'
            },
            legend: {
                align: 'top'
            }
        };

        tui.chart.lineChart(container, data, options);
    }

    //배송납기현황 정보
    function fnGetDeliveryDueInfo(response) {
        $.each(response, function (key, value) {
            var l_yyyymm = value.LYYYYMM + ''; //이전 월
            var n_yyyymm = value.NYYYYMM + ''; //현재 월

            //이전월
            var prevYYYY = '';
            var prevMM = '';
            var prevDlvrReadyDate = value.LDELIVERYREADYDATE;   //배송준비
            var prevSupplyOrdDate = value.LSUPPLYORDERDATE;     //발주완료
            var prevEnterGoodsDate = value.LENTERGOODSDATE;     //입고완료
            var prevOutGoodsDate = value.LOUTGOODSDATE;         //출고완료
            var prevDlvringDate = value.LDELIVERYINGDATE;       //배송중
            var prevDlvryDate = value.LDELIVERYDATE;            //배송완료

            //현재월
            var nowYYYY = '';
            var nowMM = '';
            var nowDlvrReadyDate = value.NDELIVERYREADYDATE;   //배송준비
            var nowSupplyOrdDate = value.NSUPPLYORDERDATE;     //발주완료
            var nowEnterGoodsDate = value.NENTERGOODSDATE;     //입고완료
            var nowOutGoodsDate = value.NOUTGOODSDATE;         //출고완료
            var nowDlvringDate = value.NDELIVERYINGDATE;       //배송중
            var nowDlvryDate = value.NDELIVERYDATE;            //배송완료

            //평균
            var avrDlvrReadyDate = value.DELIVERYREADYDATE;   //배송준비
            var avrSupplyOrdDate = value.SUPPLYORDERDATE;     //발주완료
            var avrEnterGoodsDate = value.ENTERGOODSDATE;     //입고완료
            var avrOutGoodsDate = value.OUTGOODSDATE;         //출고완료
            var avrDlvringDate = value.DELIVERYINGDATE;       //배송중
            var avrDlvryDate = value.DELIVERYDATE;            //배송완료

            if (!isEmpty(l_yyyymm)) {
                prevYYYY = l_yyyymm.substring(0, 4);
                prevMM = l_yyyymm.substring(4, 6);
            }
            if (!isEmpty(n_yyyymm)) {
                nowYYYY = n_yyyymm.substring(0, 4);
                nowMM = n_yyyymm.substring(4, 6);
            }

            $("#spPrevMonth").text(prevYYYY + "년" + prevMM + "월");
            $("#spNowMonth").text(nowYYYY + "년" + nowMM + "월");
            $("#spNowYear").text(value.YYYY + "년");


            $("#spPrevDlvrReady").text(fnGetDeliveryDueName(parseInt(prevDlvrReadyDate)));
            $("#spPrevSupplyOrd").text(fnGetDeliveryDueName(parseInt(prevSupplyOrdDate)));
            $("#spPrevEnterGoods").text(fnGetDeliveryDueName(parseInt(prevEnterGoodsDate)));
            $("#spPrevOutGoods").text(fnGetDeliveryDueName(parseInt(prevOutGoodsDate)));
            $("#spPrevDlvring").text(fnGetDeliveryDueName(parseInt(prevDlvringDate)));
            $("#spPrevDlvry").text(fnGetDeliveryDueName(parseInt(prevDlvryDate)));

            $("#spNowDlvrReady").text(fnGetDeliveryDueName(parseInt(nowDlvrReadyDate)));
            $("#spNowSupplyOrd").text(fnGetDeliveryDueName(parseInt(nowSupplyOrdDate)));
            $("#spNowEnterGoods").text(fnGetDeliveryDueName(parseInt(nowEnterGoodsDate)));
            $("#spNowOutGoods").text(fnGetDeliveryDueName(parseInt(nowOutGoodsDate)));
            $("#spNowDlvring").text(fnGetDeliveryDueName(parseInt(nowDlvringDate)));
            $("#spNowDlvry").text(fnGetDeliveryDueName(parseInt(nowDlvryDate)));

            $("#spYearDlvrReady").text(fnGetDeliveryDueName(parseInt(avrDlvrReadyDate)));
            $("#spYearSupplyOrd").text(fnGetDeliveryDueName(parseInt(avrSupplyOrdDate)));
            $("#spYearEnterGoods").text(fnGetDeliveryDueName(parseInt(avrEnterGoodsDate)));
            $("#spYearOutGoods").text(fnGetDeliveryDueName(parseInt(avrOutGoodsDate)));
            $("#spYearDlvring").text(fnGetDeliveryDueName(parseInt(avrDlvringDate)));
            $("#spYearDlvry").text(fnGetDeliveryDueName(parseInt(avrDlvryDate)));
        });
    }

    //배송 관련 소요일 명칭
    function fnGetDeliveryDueName(dueNum) {
        var returnVal = '';

        if (dueNum == 0) {
            returnVal = "당일";

        } else if (dueNum > 0) {
            returnVal = dueNum + "일";

        } else {
            returnVal = '-';
        }

        return returnVal;
    }


    function fnGetOrderManage(response) {

        $.each(response, function (key, value) {
            $('#ordermng_type1').text(!isEmpty(value.CNT_TYPE1) ? value.CNT_TYPE1 : 0);
            $('#ordermng_type2').text(!isEmpty(value.CNT_TYPE2) ? value.CNT_TYPE2 : 0);
            $('#ordermng_type3').text(!isEmpty(value.CNT_TYPE3) ? value.CNT_TYPE3 : 0);
            $('#ordermng_type4').text(!isEmpty(value.CNT_TYPE4) ? value.CNT_TYPE4 : 0);
            $('#ordermng_type5').text(!isEmpty(value.CNT_TYPE5) ? value.CNT_TYPE5 : 0);
            $('#ordermng_type6').text(!isEmpty(value.CNT_TYPE6) ? value.CNT_TYPE6 : 0);
            $('#ordermng_type7').text(!isEmpty(value.CNT_TYPE7) ? value.CNT_TYPE7 : 0);
            $('#ordermng_type8').text(!isEmpty(value.CNT_TYPE8) ? value.CNT_TYPE8 : 0);

        });
    }

    function fnGetNoticeMain(response) {

        $('#ulNotice').empty();

        $.each(response, function (key, value) {

            var noticeHtml = '<li>'
            noticeHtml += '<a href="/Admin/Notice/NoticeView.aspx?Svid=' + value.SVID_BOARD + '&ucode=04" ><span class="admin-dash-boardtitle">' + value.BOARD_TITLE + '</span><span class="admin-dash-boarddate">' + fnOracleDateFormatConverter(value.BOARD_REGDATE) + '</span></a>';
            noticeHtml += '</li>';
            $('#ulNotice').append(noticeHtml);

        });
    }

    function fnGetBoard(response) {


        var thisDay = new Date().format("yyyy-MM-dd");
        var htmlA = '';
        var htmlB = '';
        $.each(response, function (key, value) {
            if (value.BOARD_GUBUN == '1') {
                var newText = '';
                var resultText = '';
                if (thisDay == fnOracleDateFormatConverter(value.BOARD_REGDATE)) {
                    newText = '<img src="/Admin/Images/board-new.png">';
                }

                if (value.RESULT_STATUS == 'Y') {
                    resultText = '답변완료';
                }

                htmlA += ' <li><a href="/Admin/Board/Board_A_View.aspx?ucode=04&Svid=' + value.SVID_BOARD + '"><span class="admin-dash-board-compname">[' + value.COMPANY_NAME + ']</span><span class="admin-dash-board-title">' + value.BOARD_TITLE + '</span><span class="admin-dash-board-new">' + newText + '</span><span class="admin-dash-board-result">' + resultText + '</span><span class="admin-dash-board-date">' + fnOracleDateFormatConverter(value.BOARD_REGDATE) + '</span></a></li>'
                
            }
            if (value.BOARD_GUBUN == '2') {
                var newText = '';
                var compText = '';
                var resultText = '';
                if (thisDay == fnOracleDateFormatConverter(value.BOARD_REGDATE)) {
                    newText = '<img src="/Admin/Images/board-new.png">';
                }
                if (value.RESULT_STATUS == 'Y') {
                    resultText = '답변완료';
                }
                if (!isEmpty(value.COMPANY_NAME)) {
                    compText = '<span class="admin-dash-board-compname">[' + value.COMPANY_NAME + ']</span>'
                }
                htmlB += ' <li><a href="/Admin/Board/Board_B_View.aspx?ucode=04&Svid=' + value.SVID_BOARD + '">' + compText + '<span class="admin-dash-board-title">' + value.BOARD_TITLE + '</span><span class="admin-dash-board-new">' + newText + '</span><span class="admin-dash-board-result">' + resultText + '</span><span class="admin-dash-board-date">' + fnOracleDateFormatConverter(value.BOARD_REGDATE) + '</span></a></li>'
                
            }
        });
        $('#ulBoarda').empty().append(htmlA);
        $('#ulBoardb').empty().append(htmlB);
    }

    function fnGetNewGoodsRequest(response) {

        $('#ulNewRequest').empty();

        var thisDay = new Date().format("yyyy-MM-dd");
        $.each(response, function (key, value) {
            var resultText = '';
            var newText = '';
            if (thisDay == fnOracleDateFormatConverter(value.ENTRYDATE)) {
                newText = '<imgsrc="/Admin/Images/board-new.png">';
            }

            if (value.PROCESSSTATUS == 'A') {
                resultText = '접수완료';
            }
            else if (value.PROCESSSTATUS == 'Y') {
                resultText = '처리완료';
            }
            var html = '<li>'
            html += '<a href="/Admin/SCMquote/newGoodsRequest.aspx?ucode=06"><span class="admin-dash-newgoods-title">' + value.GOODSFINALNAME + '</span><span class="admin-dash-newgoods-new">' + newText + '</span><span class="admin-dash-newgoods-result">' + resultText + '</span><span class="admin-dash-newgoods-date">' + fnOracleDateFormatConverter(value.ENTRYDATE) + '</span></a>';
            html += '</li>';
            $('#ulNewRequest').append(html);

        });
    }

    function fnGetMemberInfo(response) {

        $.each(response, function (key, value) {
            $('#membertypeA_total').text(!isEmpty(value.USERCOUNT_A) ? value.USERCOUNT_A : 0);
            $('#membertypeA_confirmY').text(!isEmpty(value.CONFIRMY_A) ? value.CONFIRMY_A : 0);
            $('#membertypeA_confirmN').text(!isEmpty(value.CONFIRMN_A) ? value.CONFIRMN_A : 0);
            $('#membertypeA_stop').text(!isEmpty(value.DELA_A) ? value.DELA_A : 0);
            $('#membertypeA_leave').text(!isEmpty(value.DELN_A) ? value.DELN_A : 0);
            $('#membertypeA_today').text(!isEmpty(value.TODAYREG_A) ? value.TODAYREG_A : 0);

            $('#membertypeB_total').text(!isEmpty(value.USERCOUNT_B) ? value.USERCOUNT_B : 0);
            $('#membertypeB_confirmY').text(!isEmpty(value.CONFIRMY_B) ? value.CONFIRMY_B : 0);
            $('#membertypeB_confirmN').text(!isEmpty(value.CONFIRMN_B) ? value.CONFIRMN_B : 0);
            $('#membertypeB_stop').text(!isEmpty(value.DELA_B) ? value.DELA_B : 0);
            $('#membertypeB_leave').text(!isEmpty(value.DELN_B) ? value.DELN_B : 0);
            $('#membertypeB_today').text(!isEmpty(value.TODAYREG_B) ? value.TODAYREG_B : 0);

        });
    }

    function fnGetOrderStatus(response) {

        var aamtObj = new Object();
        var camtObj = new Object();
        var samtObj = new Object();

        aamtObj.name = '주문금액';
        camtObj.name = '취소금액';
        samtObj.name = '매출금액';
        var aamtArray = new Array();
        var camtArray = new Array();
        var samtArray = new Array();


        var orderTotal = 0;
        var cancelTotal = 0;
        var saleTotal = 0;

        $('#tbodyOrderStatus').empty();

        $.each(response, function (key, value) {
            var date = '';
            if (!isEmpty(value.ORDERDATE)) {
                date = value.ORDERDATE.substring(2, 4) + '/' + value.ORDERDATE.substring(4, 6);
            }
            var tableHtml = '<tr>'
            tableHtml += '<td>' + date + ''
            tableHtml += '</td>'
            tableHtml += '<td>' + numberWithCommas(value.AAMT) + ''
            tableHtml += '</td>'
            tableHtml += '<td>' + numberWithCommas(value.CAMT) + ''
            tableHtml += '</td>'
            tableHtml += '<td>' + numberWithCommas(value.PAMT) + ''
            tableHtml += '</td>'
            tableHtml += '</tr>';

            orderTotal += value.AAMT;
            cancelTotal += value.CAMT;
            saleTotal += value.PAMT;

            aamtArray.push(value.AAMT);
            camtArray.push(value.CAMT);
            samtArray.push(value.PAMT);
            dateArray.push(date);
            $('#tbodyOrderStatus').append(tableHtml);

        });
        var totalHtml = '<tr class="admin-dt-ordertable-sumrow">'
        totalHtml += '<td>합계'
        totalHtml += '</td>'
        totalHtml += '<td>' + numberWithCommas(orderTotal) + ''
        totalHtml += '</td>'
        totalHtml += '<td>' + numberWithCommas(cancelTotal) + ''
        totalHtml += '</td>'
        totalHtml += '<td>' + numberWithCommas(saleTotal) + ''
        totalHtml += '</td>'
        totalHtml += '</tr>';
        $('#tbodyOrderStatus').append(totalHtml);
        aamtObj.data = aamtArray;
        camtObj.data = camtArray;
        samtObj.data = samtArray;

        totalArray.push(aamtObj);
        totalArray.push(camtObj);
        totalArray.push(samtObj);

    }
    var container = document.getElementById('chart-area');
    var data = {
        categories: dateArray,
        series: totalArray
    };
    var options = {
        chart: {
            width: 770,
            height: 438,
            format: '1,000'
        },
        yAxis: {
            title: '금액',
            min: 0,
            //max: 9000
        },
        xAxis: {
            title: '날짜'
        },
        legend: {
            align: 'top'
        }
    };

    tui.chart.lineChart(container, data, options);
</script>
</html>
