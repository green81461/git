<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Default.aspx.cs" Inherits="AdminSub_Default" %>

<!DOCTYPE html>

<html>
<head runat="server">

    <title>판매사</title>
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
    <link rel="stylesheet" type="text/css" href="/AdminSub/Contents/main.css" />
    <link rel="stylesheet" type="text/css" href="/AdminSub/Contents/common.css" />
    <link rel="stylesheet" type="text/css" href="/AdminSub/Contents/popup.css" />
    <link rel="stylesheet" type="text/css" href="/AdminSub/Contents/jquery-ui.css" />
    <link rel="stylesheet" type="text/css" href="/AdminSub/Contents/tui-chart.css" />
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
    <script type='text/javascript' src='https://cdnjs.cloudflare.com/ajax/libs/core-js/2.5.7/core.js'></script>
    <script type='text/javascript' src='https://rawgit.com/nhnent/tui.code-snippet/v1.4.0/dist/tui-code-snippet.js'></script>
    <script type='text/javascript' src='https://rawgit.com/nhnent/raphael/v2.2.0b/raphael.js'></script>
    <script type="text/javascript" src="../../Scripts/tui-chart.js"></script>
    <style>
        
    </style>
    <script type="text/javascript">
        var qs = fnGetQueryStrings();
        var ucode = qs["ucode"];
        $(function () {
           // fnGetSiteDistPackage();

            //메뉴 닫기 클릭
            $('#aMenuClose').click(function () {
                $('.adminsub-submenu-wrap').css('width', '0px');
                $('.adminsub-content').css('margin-left', '0px');
                $(this).css('display', 'none');
                $('#aMenuOpen').css('display', 'block');
            })

            $('#aMenuOpen').click(function () {
                $('.adminsub-submenu-wrap').css('width', '185px');
                $('.adminsub-content').css('margin-left', '185px');
                $(this).css('display', 'none');
                $('#aMenuClose').css('display', 'block');
            })

            var httpProtocol = '';

            if ('<%= ssluse%>' == 'Y') {
                httpProtocol = 'https://'
            }
            else {
                httpProtocol = 'http://'
            }
            $('#aHomepage').attr('href', httpProtocol + '<%= enterDomainUrl%>');

        })

        function fnGetSiteDistPackage() {
            var callback = function (response) {

                fnGetDistMenu(response["table_1"]);   //메뉴
            }
            var param = {
                Method: 'GetDistCssAdminSubPkg',
                Code: '<%= DistCode%>'

            };

            JqueryAjax('Post', '../../Handler/Common/DistCssHandler.ashx', false, false, param, 'json', callback, null, null, false, '');

        }

        function fnGetDistMenu(response) {

            if (!isEmpty(response)) {

                $.each(response, function (key, value) {

                    if (value.MENULEVELCODE == 1 && value.USEYN == 'Y') {
                        if (value.MENUID == ucode) {
                            $('#hMenuTitle').text(value.MENUNAME)
                        }
                        var topMenuHtml = '<li id="li' + value.MENUID + '">'

                        topMenuHtml += '<a href="' + value.DISTCSSMGTMENUURL + "?ucode=" + value.MENUID + '" >' + value.MENUNAME + '</a>';
                        topMenuHtml += '</li>';
                        $('#ulMainMenu').append(topMenuHtml);
                    }

                    else if (value.MENULEVELCODE == 2 && value.USEYN == 'Y') {
                        var displayStyle = 'display:none';
                        if (value.MENUUPCODE == ucode) {
                            displayStyle = '';
                        }
                        var subMenuHtml = '<li ucode="' + value.MENUUPCODE + '" id="li' + value.MENUID + '" style="' + displayStyle + '">'
                        subMenuHtml += '<a href="' + value.DISTCSSMGTMENUURL + "?ucode=" + value.MENUUPCODE + '" >' + value.MENUNAME + '</a>';
                        subMenuHtml += '</li>';
                        $('#ulSubmenuList').append(subMenuHtml);
                    }
                });
            }
        }


    </script>

</head>
<body>
    <form id="form1" runat="server">
        <div class="adminsub-container">
            <div class="adminsub-header">
                <div class="adminsub-header-info">
                    <ul>
                        <li class="adminsub-header-home"><a id="aHomepage">홈페이지 바로가기</a></li>
                        <li class="adminsub-header-user"><a href="/AdminSub/Member/MemberEditCheck.aspx?ucode=MEAT004000000000">
                            <asp:Label runat="server" ID="lblUser"></asp:Label></a>님</li>
                        <li class="adminsub-header-logout">
                            <asp:LinkButton ID="lbLogout" runat="server" Text="→  로그아웃 " CssClass="adminsub-logout" OnClick="lbLogout_Click"></asp:LinkButton>
                        </li>
                    </ul>
                </div>

                <div class="adminsub-mainmenu-wrap">
                    <span class="adminsub-title">
                        <asp:Literal runat="server" ID="lblSiteName"></asp:Literal></span>
                   <ul class="adminsub-mainmenu-list" id="ulMainMenu">
	                    <li id="liMESUT001000000000"><a href="/AdminSub/Order/OrderHistoryList.aspx?ucode=MESUT001000000000">주문관리</a></li>
	                    <li id="liMESUT002000000000"><a href="/AdminSub/Order/OrderCancelList.aspx?ucode=MESUT002000000000">클레임관리</a></li>
	                    <li id="liMESUT003000000000"><a href="/AdminSub/BalanceAccounts/BalanceSummary.aspx?ucode=MESUT003000000000">정산관리</a></li>
	                    <li id="liMESUT004000000000"><a href="/AdminSub/Member/MemberEditCheck.aspx?ucode=MESUT004000000000">마이페이지</a></li>
	                    <li id="liMESUT005000000000"><a href="/AdminSub/BList/InfoList-B?ucode=MESUT005000000000">구매자리스트</a></li>
	                    <%--<li id="liMESUT006000000000"><a href="/AdminSub/Other/companyAbout.aspx?ucode=MESUT006000000000">판매자가이드북</a></li>--%>
	                    <li id="liMESUT007000000000"><a href="/AdminSub/Board/BoardList.aspx?ucode=MESUT007000000000">고객센터</a></li>
                    </ul>
                </div>
            </div>
            <div class="adminsub-mainwrap">
                <div class="adminsub-default">
                    <div class="adminsub-dt01-wrap">
                        <div class="adminsub-dt01">
                            <div class="adminsub-dt-title-wrap">
                                <span>주문관리</span><span class="titleinfo">(7일 기준)</span>
                                <a href="/AdminSub/Order/OrderHistoryList?ucode=MEAT001000000000" style="cursor:pointer"><span class="adminsub-moreinfo">+더보기</span></a>
                            </div>
                            <div class="adminsub-dt-table-wrap">
                                <ul id="ordermanage">
                                    <li><a href="/AdminSub/Order/OrderHistoryList?ucode=MEAT001000000000&ordstatus=100"><span>주문완료</span><div id="ordermng_type1"></div>
                                    </a></li>
                                    <li><a href="/AdminSub/Order/OrderHistoryList?ucode=MEAT001000000000&ordstatus=200"><span>배송준비</span><div id="ordermng_type2"></div>
                                    </a></li>
                                    <li><a href="/AdminSub/Order/OrderHistoryList?ucode=MEAT001000000000&ordstatus=301"><span>배송중</span><div id="ordermng_type3"></div>
                                    </a></li>
                                    <li><a href="/AdminSub/Order/OrderHistoryList?ucode=MEAT001000000000&ordstatus=302"><span>배송완료</span><div id="ordermng_type4"></div>
                                    </a></li>
                                </ul>
                            </div>
                        </div>
                    </div>
                    <div class="adminsub-dt02-wrap">
                        <div class="adminsub-dt02">
                            <div class="adminsub-dt-title-wrap">
                                <span>공지사항</span>
                                <a href="/AdminSub/Board/NoticeList?ucode=MEAT007000000000" style="cursor:pointer"><span class="adminsub-moreinfo">+더보기</span></a>
                            </div>
                            <div class="adminsub-dt-table-wrap">
                                <ul id="ulNotice">
                                </ul>
                            </div>
                        </div>
                    </div>

                    <div class="adminsub-dt03-wrap">
                        <div class="adminsub-dt03">
                            <div class="adminsub-dt-title-wrap">
                                <span>나의 1:1 문의</span>
                                <a href="/AdminSub/Board/BoardList?ucode=MEAT007000000000" style="cursor:pointer"><span class="adminsub-moreinfo">+더보기</span></a>
                            </div>
                            <div class="adminsub-dt-table-wrap">
                                <ul>
                                    <li><a href="/AdminSub/Board/BoardList.aspx?ucode=MEAT007000000000&boardChannel=1_1">상품문의<div><b id="bBoardType1"></b>/<span id="spanBoardType1"></span>건</div>
                                    </a></li>
                                    <li><a href="/AdminSub/Board/BoardList.aspx?ucode=MEAT007000000000&boardChannel=1_2">반품/교환<div><b id="bBoardType2"></b>/<span id="spanBoardType2"></span>건</div>
                                    </a></li>
                                    <li><a href="/AdminSub/Board/BoardList.aspx?ucode=MEAT007000000000&boardChannel=1_3">배송/납기<div><b id="bBoardType3"></b>/<span id="spanBoardType3"></span>건</div>
                                    </a></li>
                                    <li><a href="/AdminSub/Board/BoardList.aspx?ucode=MEAT007000000000&boardChannel=1_4">가입문의<div><b id="bBoardType4"></b>/<span id="spanBoardType4"></span>건</div>
                                    </a></li>
                                    <li><a href="/AdminSub/Board/BoardList.aspx?ucode=MEAT007000000000&boardChannel=1_5">기타<div><b id="bBoardType5"></b>/<span id="spanBoardType5"></span>건</div>
                                    </a></li>
                                </ul>
                            </div>
                        </div>
                    </div>

                    <div class="adminsub-dt04-wrap">
                        <div class="adminsub-dt04">
                            <div class="adminsub-dt-title-wrap">
                                <span>주문현황</span><span class="titleinfo">(7일 기준)</span>
                                <a href="/AdminSub/Order/OrderHistoryList?ucode=MEAT001000000000" style="cursor:pointer"><span class="adminsub-moreinfo">+더보기</span></a>
                            </div>
                            <div class="adminsub-dt-table-wrap">
                                <table class="admin-sub-dt-ordertable">
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
                            <div class="admin-sub-chartwrap">
                                <div class='admin-sub-chart'>
                                    <div class='code-html' id='code-html'>
                                        <div id='chart-area'></div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>



                </div>




            </div>
            <div class="adminsub-bottomwrap">
                <div class="adminsub-copyright">
                    <p>COPYRIGHT (C) URI-AN ALL RIGHTS RESERVED.</p>
                </div>
            </div>
        </div>



    </form>
</body>
<script>
    var totalArray = new Array();
    var dateArray = new Array();
    fnGetDefaultPackage();
    function fnGetDefaultPackage() {

        var callback = function (response) {

            fnGetOrderManage(response["table_1"]);   //주문관리
            fnGetNoticeMain(response["table_2"]); //공지사항
            fnGetBoard(response["table_3"]); //1:1문의
            fnGetOrderStatus(response["table_4"]); //주문현황
        }
        var param = {
            Method: 'GetDefaultAdminSubPkg',
            SvidUser: '<%= SvidUser%>',
                CompCode: '<%= saleCompCode%>'

        };

        JqueryAjax('Post', '../../Handler/DefaultHandler.ashx', false, false, param, 'json', callback, null, null, false, '');

    }



    function fnGetOrderManage(response) {

        $.each(response, function (key, value) {
            $('#ordermng_type1').text(!isEmpty(value.CNT_TYPE1) ? value.CNT_TYPE1 : 0);
            $('#ordermng_type2').text(!isEmpty(value.CNT_TYPE2) ? value.CNT_TYPE2 : 0);
            $('#ordermng_type3').text(!isEmpty(value.CNT_TYPE3) ? value.CNT_TYPE3 : 0);
            $('#ordermng_type4').text(!isEmpty(value.CNT_TYPE4) ? value.CNT_TYPE4 : 0);

        });
    }

    function fnGetNoticeMain(response) {
        $.each(response, function (key, value) {

            var noticeHtml = '<li>'
            noticeHtml += '<a href="/AdminSub/Board/NoticeView.aspx?Svid=' + value.SVID_BOARD + '&ucode=MEAT007000000000" >' + value.BOARD_TITLE + '<span>' + fnOracleDateFormatConverter(value.BOARD_REGDATE) + '</span></a>';
            noticeHtml += '</li>';
            $('#ulNotice').append(noticeHtml);

        });
    }

    function fnGetBoard(response) {

        $.each(response, function (key, value) {
            $('#bBoardType1').text(value.TYPE1);
            $('#spanBoardType1').text(value.TYPE1_Y);

            $('#bBoardType2').text(value.TYPE2);
            $('#spanBoardType2').text(value.TYPE2_Y);

            $('#bBoardType3').text(value.TYPE3);
            $('#spanBoardType3').text(value.TYPE3_Y);

            $('#bBoardType4').text(value.TYPE4);
            $('#spanBoardType4').text(value.TYPE4_Y);

            $('#bBoardType5').text(value.TYPE5);
            $('#spanBoardType5').text(value.TYPE5_Y);

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
        var totalHtml = '<tr class="admin-sub-dt-ordertable-sumrow">'
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
            height: 398,
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
