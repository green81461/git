<%@ Page Title="" Language="C#" MasterPageFile="~/Master/Default.master" AutoEventWireup="true" CodeFile="Statistics.aspx.cs" Inherits="Statistics_Statistics" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <link href="../Content/Statistics/statistics.css" rel="stylesheet" />

    <link rel="stylesheet" type="text/css" href="/Admin/Content/tui-chart.css" />
    <script type="text/javascript" src="../../Scripts/core.js"></script>
    <script type='text/javascript' src='/Scripts/tui-code-snippet.min.js'></script>
    <script type='text/javascript' src='/Scripts/raphael.min.js'></script>
    <script type="text/javascript" src="/Scripts/tui-chart.js"></script>

    <script>
        <%--$(function () {
            fnBuyListSet();
        });

        function fnBuyListSet() {
            var asynList = "";
            var userGubun = '<%= UserInfoObject.Gubun%>';

            var callback = function (response) {

                if (!isEmpty(response)) {

                    $.each(response, function (index, value) {
                        //asynList += "<ul>";
                        asynList += "<li><span class='list_name'>" + value.Company_Name + "</span>";
                        asynList += "<span class='price'>" + numberWithCommas(value.GoodsSalePriceVat) + "원</span></li>";
                        //asynList += "</ul>";
                    });

                }
                $("#buyList").empty().append(asynList);

            }
            var param = {
                Gubun: userGubun, //"BU0002"
                Method: "GetBuyCompMonthProfitList"
            }


            var beforeSend = function () {
                is_sending = true;
            }
            var complete = function () {
                is_sending = false;
            }

            JqueryAjax("Post", "/Handler/OrderHandler.ashx", false, false, param, "json", callback, beforeSend, complete, true, '<%=Svid_User %>');
        }--%>
    </script>

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div class="sub-contents-div">
        <div class="admin_wrap">
            <div class="title">당월구매내역</div>
            <div class="admin-wrap-wide">
                <ul id="buyList">
                </ul>
            </div>
            <div class="admin-wrap-right">
                <div>
                    <!--그래프 영역-->
                </div>
            </div>
        </div>
        <div class="admin_wrap">
            <div class="title">주문현황 <span class="titleinfo">( 7일 기준 )</span></div>
            <div class="admin-wrap-left">
                <table class="tbl_admin">
                    <colgroup>
                        <col style="width: 25%" />
                        <col style="width: 25%" />
                        <col style="width: 25%" />
                        <col style="width: 25%" />
                    </colgroup>
                    <thead>
                        <tr>
                            <th>날짜</th>
                            <th>주문 금액</th>
                            <th>취소 금액</th>
                            <th>매출 금액</th>
                        </tr>
                    </thead>
                    <tbody id="tbodyOrderStatus">
                    </tbody>
                    <tfoot id="tfootOrderStatus">
                    </tfoot>
                </table>
            </div>
            <div class="admin-wrap-right">
                <div class="admin-chartwrap">
                    <div class="admin-chart">
                        <div class="code-html">
                            <div id="chart-area"></div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="admin_wrap">
            <div class="title">월별기준</div>
            <div class="admin-wrap-left">
                <table class="tbl_admin">
                    <colgroup>
                        <col style="width: 25%" />
                        <col style="width: 25%" />
                        <col style="width: 25%" />
                        <col style="width: 25%" />
                    </colgroup>
                    <thead>
                        <tr>
                            <th>월</th>
                            <th>주문 금액</th>
                            <th>취소 금액</th>
                            <th>매출 금액</th>
                        </tr>
                    </thead>
                    <tbody id="tbodyOrderMonthStatus">
                    </tbody>
                    <tfoot id="tfootOrderMonthStatus">
                    </tfoot>
                </table>
            </div>
            <div class="admin-wrap-right">
                <div class="admin-chartwrap">
                    <div class="admin-chart">
                        <div class="code-html">
                            <div id="chart-area2"></div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="admin_wrap">
            <div class="title">년별기준</div>
            <div class="admin-wrap-left">
                <table class="tbl_admin">
                    <colgroup>
                        <col style="width: 25%" />
                        <col style="width: 25%" />
                        <col style="width: 25%" />
                        <col style="width: 25%" />
                    </colgroup>
                    <thead>
                        <tr>
                            <th>년</th>
                            <th>주문 금액</th>
                            <th>취소 금액</th>
                            <th>매출 금액</th>
                        </tr>
                    </thead>
                    <tbody id="tbodyOrderYearStatus">
                    </tbody>
                    <tfoot id="tfootOrderYearStatus">
                    </tfoot>
                </table>
            </div>
            <div class="admin-wrap-right">
                <div class="admin-chartwrap">
                    <div class="admin-chart">
                        <div class="code-html">
                            <div id="chart-area3"></div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script type="text/javascript">

        //주문현황
        var totalArray = new Array();
        var dateArray = new Array();
        //월별
        var totalArray2 = new Array();
        var dateArray2 = new Array();
        //년별
        var totalArray3 = new Array();
        var dateArray3 = new Array();

        fnGetStatisticsPackage();

        function fnGetStatisticsPackage() {

            var gubun = '<%= UserInfoObject.Gubun%>';
            var CompName = "가스공사";
            var callback = function (response) {
                fnGetOrderStatus(response["table_1"]); //주문현황
                fnGetOrderMonthStatus(response["table_2"]); //월별기준
                fnGetOrderYearStatus(response["table_3"]); //년별기준
                fnBuyListSet(response["table_4"]); //당월구매내역
            }
            var param = {
                Gubun: gubun,
                CompName : CompName,
                Method: "GetStatisticsPackage"
            };

            JqueryAjax('Post', '../Handler/StatisticsHandler.ashx', false, false, param, 'json', callback, null, null, false, '');
        }

        function fnBuyListSet(response) {

            var asynList = '';

            if (!isEmpty(response)) {

                $.each(response, function (index, value) {
                    asynList += "<li><span class='list_name'>" + value.COMPANY_NAME + "</span>";
                    asynList += "<span class='price'>" + numberWithCommas(value.GOODSSALEPRICEVAT) + "원</span></li>";
                });

                //if (response % 2 != 0) {
                //    asynList += "<li></li>";
                //}

            }
                $("#buyList").empty().append(asynList);
             
        }

        //주문현황
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

            $('#tbodyOrderStatus').empty();
            $('#tfootOrderStatus').empty();

            $.each(response, function (key, value) {
                var date = '';
                if (!isEmpty(value.ORDERDATE)) {
                    date = value.ORDERDATE.substring(2, 4) + '/' + value.ORDERDATE.substring(4, 6);
                }
                if (key <= response.length - 3) {

                    var tableHtml = '';
                    tableHtml += '<tr><td>' + date + ''
                    tableHtml += '</td>'
                    tableHtml += '<td>' + numberWithCommas(value.AAMT) + ''
                    tableHtml += '</td>'
                    tableHtml += '<td>' + numberWithCommas(value.CAMT) + ''
                    tableHtml += '</td>'
                    tableHtml += '<td>' + numberWithCommas(value.PAMT) + ''
                    tableHtml += '</td></tr>';

                    aamtArray.push(value.AAMT);
                    camtArray.push(value.CAMT);
                    samtArray.push(value.PAMT);
                    dateArray.push(date);

                    $('#tbodyOrderStatus').append(tableHtml);

                } else {
                    var tableHtml = '<tr class="tfoot">'
                    tableHtml += '<td>' + value.ORDERDATE + '</td>'
                    tableHtml += '<td>' + numberWithCommas(value.AAMT) + ''
                    tableHtml += '</td>'
                    tableHtml += '<td>' + numberWithCommas(value.CAMT) + ''
                    tableHtml += '</td>'
                    tableHtml += '<td>' + numberWithCommas(value.PAMT) + ''
                    tableHtml += '</td></tr>';

                    $('#tfootOrderStatus').append(tableHtml);
                }
            });
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
                width: 620,
                height: 438,
                format: '1,000'
            },
            yAxis: {
                title: '금액',
                min: 0,
            },
            xAxis: {
                title: '날짜'
            },
            legend: {
                align: 'top'
            }
        };

        tui.chart.lineChart(container, data, options);


        //월별기준
        function fnGetOrderMonthStatus(response) {
            var aamtObj = new Object();
            var camtObj = new Object();
            var samtObj = new Object();

            aamtObj.name = '주문금액';
            camtObj.name = '취소금액';
            samtObj.name = '매출금액';

            var aamtArray = new Array();
            var camtArray = new Array();
            var samtArray = new Array();

            $('#tbodyOrderMonthStatus').empty();
            $('#tfootOrderMonthStatus').empty();

            $.each(response, function (key, value) {
                var date = '';
                if (!isEmpty(value.GETMONTH)) {
                    date = value.GETMONTH.substring(0, 2) + "/" + value.GETMONTH.substring(2, 4);
                }
                if (key <= response.length - 2) {

                    var tableHtml = '';
                    tableHtml += '<tr><td>' + date + ''
                    tableHtml += '</td>'
                    tableHtml += '<td>' + numberWithCommas(value.AAMT) + ''
                    tableHtml += '</td>'
                    tableHtml += '<td>' + numberWithCommas(value.CAMT) + ''
                    tableHtml += '</td>'
                    tableHtml += '<td>' + numberWithCommas(value.PAMT) + ''
                    tableHtml += '</td></tr>';

                    aamtArray.push(value.AAMT);
                    camtArray.push(value.CAMT);
                    samtArray.push(value.PAMT);
                    dateArray2.push(date);

                    $('#tbodyOrderMonthStatus').append(tableHtml);

                } else {
                    var tableHtml = '<tr class="tfoot">'
                    tableHtml += '<td>' + value.GETMONTH + '</td>'
                    tableHtml += '<td>' + numberWithCommas(value.AAMT) + ''
                    tableHtml += '</td>'
                    tableHtml += '<td>' + numberWithCommas(value.CAMT) + ''
                    tableHtml += '</td>'
                    tableHtml += '<td>' + numberWithCommas(value.PAMT) + ''
                    tableHtml += '</td></tr>';

                    $('#tfootOrderMonthStatus').append(tableHtml);
                }
            });
            aamtObj.data = aamtArray;
            camtObj.data = camtArray;
            samtObj.data = samtArray;

            totalArray2.push(aamtObj);
            totalArray2.push(camtObj);
            totalArray2.push(samtObj);
        }
        var container = document.getElementById('chart-area2');

        var data = {
            categories: dateArray2,
            series: totalArray2
        };

        var options = {
            chart: {
                width: 620,
                height: 553,
                format: '1,000'
            },
            yAxis: {
                title: '금액',
                min: 0,
            },
            xAxis: {
                title: '날짜'
            },
            legend: {
                align: 'top'
            }
        };

        tui.chart.lineChart(container, data, options);


        //년별기준
        function fnGetOrderYearStatus(response) {
            var aamtObj = new Object();
            var camtObj = new Object();
            var samtObj = new Object();

            aamtObj.name = '주문금액';
            camtObj.name = '취소금액';
            samtObj.name = '매출금액';

            var aamtArray = new Array();
            var camtArray = new Array();
            var samtArray = new Array();

            $('#tbodyOrderYearStatus').empty();
            $('#tfootOrderYearStatus').empty();

            $.each(response, function (key, value) {
                if (key < response.length - 1) {

                    var tableHtml = '';
                    tableHtml += '<tr><td>20' + value.ORDERDATE + ''
                    tableHtml += '</td>'
                    tableHtml += '<td>' + numberWithCommas(value.AAMT) + ''
                    tableHtml += '</td>'
                    tableHtml += '<td>' + numberWithCommas(value.CAMT) + ''
                    tableHtml += '</td>'
                    tableHtml += '<td>' + numberWithCommas(value.PAMT) + ''
                    tableHtml += '</td></tr>';

                    aamtArray.push(value.AAMT);
                    camtArray.push(value.CAMT);
                    samtArray.push(value.PAMT);
                    dateArray3.push('20' + value.ORDERDATE);

                    $('#tbodyOrderYearStatus').append(tableHtml);

                } else {
                    var tableHtml = '<tr class="tfoot">'
                    tableHtml += '<td>' + value.ORDERDATE + '</td>'
                    tableHtml += '<td>' + numberWithCommas(value.AAMT) + ''
                    tableHtml += '</td>'
                    tableHtml += '<td>' + numberWithCommas(value.CAMT) + ''
                    tableHtml += '</td>'
                    tableHtml += '<td>' + numberWithCommas(value.PAMT) + ''
                    tableHtml += '</td></tr>';

                    $('#tfootOrderYearStatus').append(tableHtml);
                }
            });
            aamtObj.data = aamtArray;
            camtObj.data = camtArray;
            samtObj.data = samtArray;

            totalArray3.push(aamtObj);
            totalArray3.push(camtObj);
            totalArray3.push(samtObj);
        }
        var container = document.getElementById('chart-area3');

        var data = {
            categories: dateArray3,
            series: totalArray3
        };

        var options = {
            chart: {
                width: 620,
                height: 353,
                format: '1,000'
            },
            yAxis: {
                title: '금액',
                min: 0,
            },
            xAxis: {
                title: '날짜'
            },
            legend: {
                align: 'top'
            }
        };

        tui.chart.columnChart(container, data, options);
        //tui.chart.barChart(container, data, options);
        //tui.chart.lineChart(container, data, options);

    </script>

</asp:Content>

