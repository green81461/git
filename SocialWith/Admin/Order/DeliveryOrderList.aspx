<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Master/AdminMasterPage.master" AutoEventWireup="true" CodeFile="DeliveryOrderList.aspx.cs" Inherits="Admin_Order_DeliveryOrderList" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <link href="../Content/Order/order.css" rel="stylesheet" />
    <script src="../../Scripts/jquery.inputmask.bundle.js"></script>
    <script src="../../Scripts/jquery.fileDownload.js"></script>
    <script>
        $(document).ready(function () {
            var is_sending = false;

            $("#<%=this.txtSearchSdate.ClientID%>").inputmask("9999-99-99");
            $("#<%=this.txtSearchEdate.ClientID%>").inputmask("9999-99-99");

            //체크박스 하나만 선택
            var tableid = 'tblSearchList';
            ListCheckboxOnlyOne(tableid);

            //달력
            $("#<%=this.txtSearchSdate.ClientID%>").datepicker({
                showAnimation: 'slideDown',
                changeMonth: true,
                changeYear: true,
                showOn: 'button',
                buttonImage:/* "/Images/icon_calandar.png"*/"../../Images/Goods/calendar.jpg",
                buttonImageOnly: true,
                dateFormat: "yy-mm-dd",
                monthNamesShort: ["1월", "2월", "3월", "4월", "5월", "6월", "7월", "8월", "9월", "10월", "11월", "12월"],
                dayNamesMin: ["일", "월", "화", "수", "목", "금", "토"],
                showMonthAfterYear: true,
                onSelect: function (dateText, inst) {         //달력에 변경이 생길 시 수행하는 함수. 
                    SetDate();
                }

            });

            $("#<%=this.txtSearchEdate.ClientID%>").datepicker({
                showAnimation: 'slideDown',
                changeMonth: true,
                changeYear: true,
                showOn: 'button',
                buttonImage:/* "/Images/icon_calandar.png"*/"../../Images/Goods/calendar.jpg",
                buttonImageOnly: true,
                dateFormat: "yy-mm-dd",
                monthNamesShort: ["1월", "2월", "3월", "4월", "5월", "6월", "7월", "8월", "9월", "10월", "11월", "12월"],
                dayNamesMin: ["일", "월", "화", "수", "목", "금", "토"],
                showMonthAfterYear: true
            });

            $('#tblSearchList input[type="checkbox"]').change(function () {
                if ($(this).prop('checked') == true) {
                    var num = $(this).val();
                    if (num == '0') {
                        $("#<%=this.txtSearchSdate.ClientID%>").val('')
                        $("#<%=this.txtSearchEdate.ClientID%>").val('')
                        $("#<%=this.txtSearchSdate.ClientID%>").attr("readonly", false)      //ReadOnly 풀기
                        $("#<%=this.txtSearchEdate.ClientID%>").attr("readonly", false)      //ReadOnly 풀기 
                        // $("input[name=id]").attr("readonly", true);
                        return;
                    }
                    else {
                        $("#<%=this.txtSearchSdate.ClientID%>").attr("readonly", true)      //ReadOnly 적용
                        $("#<%=this.txtSearchEdate.ClientID%>").attr("readonly", true)      //ReadOnly 적용 
                    }

                    var resultSDate = new Date();
                    var resultEDate = new Date();
                    $("#<%=this.txtSearchEdate.ClientID%>").val($.datepicker.formatDate("yy-mm-dd", resultEDate));
                    var newDate = new Date($("#<%=this.txtSearchEdate.ClientID%>").val());

                    resultSDate.setDate(newDate.getDate() - num);
                    $("#<%=this.txtSearchSdate.ClientID%>").val($.datepicker.formatDate("yy-mm-dd", resultSDate));
                }
            });
            fnSearch(1);
        });

        //달력 자동 세팅 함수
        function SetDate() {

            $("input[name=chkBox]:checked").each(function () {
                var num = $(this).val();                 //선택한 체크박스
                var newEDate = new Date($("#<%=this.txtSearchSdate.ClientID%>").val());         //시작일자를 NewEDate에 넣음

                var resultDate = new Date();
                num = parseInt(num);
                resultDate.setDate(newEDate.getDate() + num);             //ResultDate에 일자를 NewEdate의 일자로 넣고 선택한 체크박스만큼 더한다.

                if (newEDate.getFullYear() != resultDate.getFullYear()) {         //연도가 다를 때
                    resultDate.setFullYear(newEDate.getFullYear());               //연도를 세팅해준다.
                }

                //if (newEDate.getMonth() == '11' && newEDate.getDate() + num >= 31) {     //12월이며 날짜 값이 31이 넘을 때
                //    alert('1')
                //    resultDate.setFullYear(newEDate.getFullYear() + 1);             //연도 세팅
                //}

                //if (newEDate.getMonth() == '9' && newEDate.getDate()>= 3 && num == 90) {     //12월이며 날짜 값이 31이 넘을 때
                //    alert('10월..')
                //    resultDate.setFullYear(newEDate.getFullYear() + 1);             //연도 세팅

                //}



                var lastDay = (new Date(newEDate.getFullYear(), newEDate.getMonth() + 1, 0)).getDate();        //그 달의 마지막 날 구하는 방법


                if (newEDate.getMonth() == resultDate.getMonth()) {       //newEDate의 달과 ResultDate의 달이 같을 때 처리

                    if (newEDate.getMonth() == '9' && newEDate.getDate() >= 3) { //10월 3일~10월31일 처리과정.
                        resultDate.setMonth(resultDate.getMonth() + 3);
                    }
                }
                else {   //같지 않을때, 달을 바꿔 맞춰준다.
                    resultDate.setMonth(newEDate.getMonth());            //ResultDate에 달 값을 NewEdate의 달로 세팅함.

                    if (num == '1' && newEDate.getDate() >= lastDay) {           //마지막날 비교 후 달 변경
                        resultDate.setMonth(newEDate.getMonth() + 1);  //1일 선택 시
                    }
                    else if (num == '7' && newEDate.getDate() >= '24') { //7일 선택 시
                        resultDate.setMonth(newEDate.getMonth() + 1);
                    }
                    else if (num == '15' && newEDate.getDate() >= '17') { //15일 선택 시
                        resultDate.setMonth(newEDate.getMonth() + 1);
                    }
                    else if (num == '30' && newEDate.getDate() >= '2') { //30일 선택 시
                        resultDate.setMonth(newEDate.getMonth() + 1);
                    }
                    else if (num == '90') {  //90일 선택 시 
                        resultDate.setDate(newEDate.getDate() + num);
                    }

                }
                $("#<%=this.txtSearchEdate.ClientID%>").val($.datepicker.formatDate("yy-mm-dd", resultDate));

            });

        }

        //조회하기
        function fnSearch(pageNum) {
            var svidUser = '<%= Svid_User %>';
            var startDate = $('#<%= txtSearchSdate.ClientID%>').val();
            var endDate = $('#<%= txtSearchEdate.ClientID%>').val();
            var orderCodeNo = $('#<%= txtOrderNo.ClientID %>').val().trim();
            var orderStatus = $('#<%= ddlOrderStatus.ClientID %>').val();
            var payway = $('#<%= ddlPayWay.ClientID %>').val();
            var buyCompName = $('#<%= BuyCompName.ClientID %>').val();
            var saleCompName = $('#<%= SaleCompName.ClientID %>').val();

            var pageSize = 20;
            var i = 1;
            var asynTable = "";

            var callback = function (response) {
                $("#tblDeliveryOrderList tbody").empty();

                if (!isEmpty(response)) {
                    $.each(response, function (key, value) {
                        $("#hdTotalCount").val(value.TotalCount);
                        var orderEnterYN = value.OrderEnterYN;
                        if (orderEnterYN == 'Y') {
                            orderEnterYN = "입고확인완료";
                        } else {
                            orderEnterYN = "입고확인예정";
                        }

                        var deliveryComFlag = "HJ"; // 한진택배
                        //if (value.DeliveryName.toUpperCase().indexOf("CJ") < 0) {
                        //    deliveryComFlag = "DS"; //대신택배
                        //}

                        var src = '/GoodsImage' + '/' + value.GoodsFinalCategoryCode + '/' + value.GoodsGroupCode + '/' + value.GoodsCode + '/' + value.GoodsFinalCategoryCode + '-' + value.GoodsGroupCode + '-' + value.GoodsCode + '-sss.jpg';
                        
                        var OrdStatusIcon = '<img src="../Images/Order/ico_OrdStatus_' + value.OrderStatus + '.png"/>'; //주문상태아이콘
                        var PaywayIcon = '<img src="../Images/Order/ico_PayWay_' + value.PayWay + '.png"/>'; //결제방법아이콘
                        var OrderDueIcon = '<img src="../Images/Order/ico_Delivery_' + value.GoodsDeliveryOrderDue_Type + '.png"/>'; //발송일 아이콘


                        asynTable += "<tr><td rowspan='2' style='text-align:center'>" + (pageSize * (pageNum - 1) + i) + "</td>"; //번호
                        asynTable += "<td style='text-align:center'>" + value.EntryDate.split("T")[0] + "</td>"; //주문일자
                        asynTable += "<td style='text-align:center'>" + value.BuyCompany_Name + "</td>";//구매사
                        asynTable += "<td rowspan='2' style='text-align:center'>" + value.OrderSaleCompanyName + "</td>";//판매사
                        asynTable += "<td rowspan='2' style= 'text-align:left; padding-left:5px;' rowspan='2'><table style='width:100%;' id='tblGoodsInfo'><tr><td rowspan='2' style='width:20%'><img src=" + src + " style='width:50px; height=50px' onerror='no_image(this, \"s\")'/></td><td style='text-align:left; width:280px'>" + value.GoodsCode + "&nbsp;&nbsp;&nbsp;&nbsp;" + value.SupInfo + "</td></tr><tr><td style='text-align:left'>" + "[" + value.BrandName + "] " + value.GoodsFinalName + "<br/><span style='color:#368AFF; width:280px; word-wrap:break-word; display:block;'>" + value.GoodsOptionSummaryValues + "</span></td></tr></table></td>";
                        asynTable += "<td style='text-align:center' rowspan='2'>" + value.GoodsModel + "</td>"; //모델명
                        asynTable += "<td style='text-align:center'>" + value.GoodsUnitMoq + " / " + value.GoodsUnit + "</td>";
                        asynTable += "<td style='padding-right:5px; text-align:right;'>" + numberWithCommas(value.GoodsSalePriceVat) + "원</td>";//주문금액(수량)
                        asynTable += "<td style='text-align:center'>" + /*value.OrderStatus_NAME*/OrdStatusIcon + "</td>";//주문처리현황
                        asynTable += "<td style='text-align:center'>" + value.DeliveryName + "</td>";//배송방법
                        asynTable += "<td rowspan='2' style='text-align:center'>" + orderEnterYN + "</td>";//입고확인
                        asynTable += "</tr>";

                        //--------------------------------------------------다음행-------------------------------------------------------------//
                        asynTable += "<tr>";
                        asynTable += "<td style='text-align:center'>" + value.OrderCodeNo + "</td>";
                        asynTable += "<td style='text-align:center'>" + value.Name + "</td>";
                        asynTable += "<td style='text-align:center'>" + value.Qty + "</td>";
                        asynTable += "<td style='padding-right:5px; text-align:right;'>" + numberWithCommas(value.GoodsTotalSalePriceVAT) + "원</td>";
                        asynTable += "<td style='text-align:center'>" + /*value.PayWay*/PaywayIcon + "</td>";

                        //----운송장 번호 조회되게 처리영역----
                        var strDlvrNo = value.DeliveryNo;
                        var arrDlvrNo = '';
                        var tagDlvrNo = '';
                        if (!isEmpty(strDlvrNo)) {
                            arrDlvrNo = strDlvrNo.split('/');
                        }

                        var etcReg = /외\s?[0-9]+건$/;

                        for (var j = 0; j < arrDlvrNo.length; j++) {
                            if ((j > 0) && (j < arrDlvrNo.length)) {
                                tagDlvrNo += " / ";
                            }

                            if (etcReg.test(arrDlvrNo[j])) {
                                tagDlvrNo += arrDlvrNo[j];
                            } else {
                                tagDlvrNo += "<a style='cursor:pointer;' onclick='fnPopupDeliverySearch(\"" + arrDlvrNo[j] + "\", \"" + deliveryComFlag + "\")'>" + arrDlvrNo[j] + "</a>";
                            }
                        }
                        //----운송장 번호 조회되게 처리영역----

                        //asynTable += "<td style='text-align:center'><a style='cursor:pointer' onclick='fnPopupDeliverySearch(\"" + value.DeliveryNo + "\", \"" + deliveryComFlag + "\")'>" + value.DeliveryNo + "</a></td>";//운송장번호
                        asynTable += "<td style='text-align:center'>" + tagDlvrNo + "</td>";//운송장번호

                        asynTable += "</tr>";
                        i++;

                    });
                } else {
                    asynTable += "<tr><td colspan='20' class='txt-center'>" + "조회된 주문내역이 없습니다." + "</td></tr>"
                    $("#hdTotalCount").val(0);
                }

                $("#tblDeliveryOrderList tbody").append(asynTable);
                fnCreatePagination('pagination', $("#hdTotalCount").val(), pageNum, 20, getPageData);
            };

            var param = {
                SvidUser: svidUser
                , ToDateB: startDate
                , ToDateE: endDate
                , Method: "DeliveryOrderList_Admin"
                , OrderCodeNo: orderCodeNo
                , OrderStatus: orderStatus
                , Payway: payway
                , BuyCompName: buyCompName
                , SaleCompName: saleCompName
                , PageNo: pageNum
                , PageSize: pageSize
            };

            var beforeSend = function () {
                is_sending = true;
                $('#divLoading').css('display', 'block');
            }
            var complete = function () {
                is_sending = false;
                $('#divLoading').css('display', 'none');
            }
            
            JqueryAjax("Post", "../../Handler/Common/DeliveryHandler.ashx", true, false, param, "json", callback, beforeSend, complete, true, '<%=Svid_User %>');
        }

        function getPageData() {
            var container = $('#pagination');
            var getPageNum = container.pagination('getSelectedPageNum');
            fnSearch(getPageNum);
            return false;
        }

        function fnPopupDeliverySearch(deliveryNo, flag) {

            var url = '';

            if (flag == "HJ") {
                url = "http://www.hanjin.co.kr/Delivery_html/inquiry/result_waybill.jsp?wbl_num=" + deliveryNo;

            } else if (flag == "CJ") {
                url = "http://nplus.doortodoor.co.kr/web/detail.jsp?slipno=" + deliveryNo;

            } else {
                var strDlvrArr = deliveryNo.split("-");
                url = "http://home.daesinlogistics.co.kr/daesin/jsp/d_freight_chase/d_general_process2.jsp?billno1=" + strDlvrArr[0] + "&billno2=" + strDlvrArr[1] + "&billno3=" + strDlvrArr[2];
            }

            var width = 1024;
            var height = 800;
            var popupX = (window.screen.width / 2) - (width / 2);
            var popupY = (window.screen.height / 2) - (height / 2);

            window.open(url, '', "height=" + height + ", width=" + width + ",status=yes,toolbar=no,menubar=no,location=no,resizable=no, scrollbars=yes,left=" + popupX + ", top=" + popupY + ", screenX=" + popupX + ", screenY= " + popupY + "");

            return false;
        }
        function fnEnterDate() {

            if (event.keyCode == 13) {

                argStr1 = $("#<%=this.txtSearchSdate.ClientID%>").val();
                argStr2 = $("#<%=this.txtSearchEdate.ClientID%>").val();
                AutoDateSet(argStr1, argStr2)
                return false;
            }
            else
                return true;
        }

        //날짜 데이터 하이픈 넣기
        function AutoDateSet(argStr1, argStr2) {
            var retVal1;
            var retVal2;

            if (argStr1 !== undefined && String(argStr1) !== '') {

                var regExp = /[\{\}\[\]\/?.,;:|\)*~`!^\-_+<>@\#$%&\\\=\(\'\"]/gi;

                var tmp = String(argStr1).replace(/(^\s*)|(\s*$)/gi, '').replace(regExp, ''); // 공백 및 특수문자 제거

                if (tmp.length <= 4) {

                    retVal1 = tmp;

                } else if (tmp.length > 4 && tmp.length <= 6) {

                    retVal1 = tmp.substr(0, 4) + '-' + tmp.substr(4, 2);

                } else if (tmp.length > 6 && tmp.length <= 8) {

                    retVal1 = tmp.substr(0, 4) + '-' + tmp.substr(4, 2) + '-' + tmp.substr(6, 2);

                } else {

                    alert('날짜 형식이 잘못되었습니다.\n입력된 데이터:' + tmp);

                    retVal1 = '';

                }

            }

            if (argStr2 !== undefined && String(argStr2) !== '') {
                var regExp = /[\{\}\[\]\/?.,;:|\)*~`!^\-_+<>@\#$%&\\\=\(\'\"]/gi;

                var tmp2 = String(argStr2).replace(/(^\s*)|(\s*$)/gi, '').replace(regExp, ''); // 공백 및 특수문자 제거

                if (tmp2.length <= 4) {

                    retVal2 = tmp2;

                } else if (tmp2.length > 4 && tmp2.length <= 6) {

                    retVal2 = tmp2.substr(0, 4) + '-' + tmp2.substr(4, 2);

                } else if (tmp2.length > 6 && tmp2.length <= 8) {

                    retVal2 = tmp2.substr(0, 4) + '-' + tmp2.substr(4, 2) + '-' + tmp2.substr(6, 2);

                } else {

                    alert('날짜 형식이 잘못되었습니다.\n입력된 데이터:' + tmp2);

                    retVal2 = '';

                }

            }

            $("#<%=this.txtSearchSdate.ClientID%>").val(retVal1);
            $("#<%=this.txtSearchEdate.ClientID%>").val(retVal2);
            return retVal1, retVal2;
        }

        //페이지 이동
        function fnGoPage(pageVal) {
            switch (pageVal) {
                case "OHL":
                    window.location.href = "../Order/OrderHistoryList?ucode="+ucode;
                    break;
                case "DL":
                    window.location.href = "../Order/DeliveryOrderList?ucode="+ucode;
                    break;
                case "MSM":
                    window.location.href = "../Member/MemberMain_A?ucode=03";
                    break;
                case "MBM":
                    window.location.href = "../Member/MemberMain_B?ucode=03";
                    break;
                default:
                    break;
            }
        }

        function fnEnter() {
            if (event.keyCode == 13) {
                fnSearch(1);
                return false;
            }
            else
                return true;
        }

        //Excel
        function fnExcelExport() {
            var svidUser = '<%= Svid_User %>';
            var userId = '<%= AdminId %>';
            var startDate = $('#<%= txtSearchSdate.ClientID%>').val();
            var endDate = $('#<%= txtSearchEdate.ClientID%>').val();
            var orderCodeNo = $('#<%= txtOrderNo.ClientID %>').val().trim();
            var orderStatus = $('#<%= ddlOrderStatus.ClientID %>').val();
            var payway = $('#<%= ddlPayWay.ClientID %>').val();
            var buyCompName = $('#<%= BuyCompName.ClientID %>').val();
            var saleCompName = $('#<%= SaleCompName.ClientID %>').val();

            $.fileDownload('../../Handler/ExcelHandler.ashx', {
                httpMethod: 'POST',
                dataType: "json",
                contentType: "application/json",
                data: {
                    SvidUser: svidUser
                    , UserId: userId
                    , ToDateB: startDate
                    , ToDateE: endDate
                    , OrderCodeNo: orderCodeNo
                    , OrderStatus: orderStatus
                    , Payway: payway
                    , BuyCompName: buyCompName
                    , SaleCompName: saleCompName
                    , Method: 'DeliveryListExcelDownLoad'
                },
                prepareCallback: function (url) {
                    $('#divLoading').css('display', '');
                },
                successCallback: function (url) {
                    $('#divLoading').css('display', 'none');
                },
                failCallback: function (html, url) {
                    alert("저장에 실패 했습니다. 관리자에게 문의해주십시오.");
                }
            });
        }

    </script>
    <style type="text/css">
        .auto-style1 {
            width: 100px;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div class="all">
        <div class="sub-contents-div">
            <div class="sub-title-div">
                <p class="p-title-mainsentence">
                    배송조회
                    <span class="span-title-subsentence">상품의 배송상태를 확인 할 수 있습니다.</span>
                </p>
            </div>

            <div class="search-div">
                <table id="tblSearchList" class="tbl_main">
                    <colgroup>
                        <col style="width:200px"/>
                        <col />
                        <col style="width:200px"/>
                        <col />
                    </colgroup>
                    <thead>
                        <tr>
                            <th colspan="4">배송현황</th>
                        </tr>
                    </thead>
                    <tr>
                        <th>주문일</th>
                        <td>
                            <asp:TextBox ID="txtSearchSdate" runat="server" MaxLength="10" CssClass="calendar" onkeypress="return fnEnterDate();" placeholder="2018-01-01" ReadOnly="true"></asp:TextBox>
                            -
                            <asp:TextBox ID="txtSearchEdate" runat="server" MaxLength="10" CssClass="calendar" onkeypress="return fnEnterDate();" placeholder="2018-12-30" ReadOnly="true"></asp:TextBox>
                            &nbsp;&nbsp;&nbsp;
                            <input type="checkbox" name="chkBox" id="ckbSearch1" value="1" checked="checked" /><label for="ckbSearch1">1일</label>
                            <input type="checkbox" name="chkBox" id="ckbSearch2" value="7" /><label for="ckbSearch2">7일</label>
                            <input type="checkbox" name="chkBox" id="ckbSearch3" value="15" /><label for="ckbSearch3">15일</label>
                            <input type="checkbox" name="chkBox" id="ckbSearch4" value="30" /><label for="ckbSearch4">30일</label>
                            <input type="checkbox" name="chkBox" id="ckbSearch5" value="90" /><label for="ckbSearch5">90일</label>
                            <input type="checkbox" name="chkBox" id="ckbSearch6" value="0" /><label for="ckbSearch6">직접입력</label>

                        </td>
                        <th>결제수단</th>
                        <td>
                            <asp:DropDownList runat="server" ID="ddlPayWay" CssClass="medium-size">
                            </asp:DropDownList>
                        </td>
                    </tr>
                    <tr>
                        <th>주문번호</th>
                        <td>
                            <asp:TextBox runat="server" CssClass="medium-size" ID="txtOrderNo" onkeypress="return fnEnter();"></asp:TextBox>
                        </td>
                        <th>구분(처리상태)</th>
                        <td>
                            <asp:DropDownList runat="server" ID="ddlOrderStatus" CssClass="medium-size"></asp:DropDownList></td>

                    </tr>
                    <tr>
                        <th>판매사</th>
                        <td>
                            <asp:TextBox runat="server" CssClass="medium-size" ID="SaleCompName" onkeypress="return fnEnter();"></asp:TextBox></td>
                        <th>구매사</th>
                        <td>
                            <asp:TextBox runat="server" CssClass="medium-size" ID="BuyCompName" onkeypress="return fnEnter();"></asp:TextBox></td>

                    </tr>
                </table>
            </div>


            <!--조회하기 버튼-->
            <%--<div class="bt-align-div">
                <a><img alt="조회하기" src="../../Images/Goods/aslist.jpg" id="btnSearch" onclick="fnSearch(1);return false;" onmouseover="this.src='../../Images/Wish/aslist-over.jpg'" onmouseout="this.src='../../Images/Goods/aslist.jpg'" /></a>
            </div>--%>


            <%--검색영역 버튼--%>
            <div style="float: left; margin-bottom: 50px; margin-top: 20px;">
                <input type="button" class="mainbtn type1" style="width: 105px; height: 30px;" value="주문내역조회" onclick="fnGoPage('OHL')" />
                <input type="button" class="mainbtn type1" style="width: 125px; height: 30px;" value="회원관리(판매사)" onclick="fnGoPage('MSM')" />
                <input type="button" class="mainbtn type1" style="width: 125px; height: 30px;" value="회원관리(구매사)" onclick="fnGoPage('MBM')" />
            </div>
            <div style="float: right; margin-bottom: 50px; margin-top: 20px;">
                <input type="button" class="mainbtn type1" style="width: 95px; height: 30px;" value="조회하기" onclick="fnSearch(1); return false;" />
                <input type="button" class="mainbtn type1" style="width:95px; height:30px" value="엑셀저장" onclick="fnExcelExport(); return false;" />
            </div>
            <div style="text-align: right; font-weight: bold; color: #ec2029; clear: both;">배송완료 시점으로 5일 이후에는 자동적으로 "입고 확인 완료"가 진행됩니다.</div>
            <p style="color: #ec2029; font-weight: bold; text-align: right; margin-top:6px;">주문금액(상품금액*주문수량)</p>
            <p style="color: #69686d; margin-top: 6px; text-align: right; margin-bottom:6px;">*<b style="color: #ec2029; font-weight: bold;"> VAT(부가세)포함 가격</b>입니다.</p>

            <div class="list-div" style="margin-top: 10px !important">
                <table id="tblDeliveryOrderList" class="tbl_main">
                    <colgroup>
                        <col width="5%" /> <!-- 번호 -->
                        <col width="9%" /> <!-- 주문일자/주문번호 -->
                        <col width="11%" /> <!-- 구매사/주문자 -->
                        <col width="9%" /> <!-- 판매사 -->
                        <col width="11%" /> <!-- 주문상품정보 -->
                        <col width="10%" /> <!-- 모델명 -->
                        <col width="10%" /> <!-- 최수수량/내용량/주문수량 -->
                        <col width="7%" /> <!-- 상품금액/주문금액 -->
                        <col width="10%" /> <!-- 주문처리현황/결제수단 -->
                        <col width="9%" /> <!-- 배송방법/운송장번호 -->
                        <col width="8%" /> <!-- 입고확인 -->
                    </colgroup>
                    <thead>
                        <tr>
                            <th rowspan="2">번호</th>
                            <th>주문일자</th>
                            <th>구매사</th>
                            <th rowspan="2">판매사</th>
                            <th rowspan="2">주문상품정보</th>
                            <th rowspan="2">모델명</th>
                            <th>최소수량/내용량</th>
                            <th class="td-bgColorGreen">상품금액</th>
                            <th>주문처리현황</th>
                            <th>배송방법</th>
                            <th rowspan="2">입고확인</th>
                        </tr>
                        <tr>
                            <th>주문번호</th>
                            <th>주문자</th>
                            <th class="td-bgColorRed">주문수량</th>
                            <th class="td-bgColorYellow">주문금액</th>
                            <th>결제수단</th>
                            <th>운송장번호</th>
                        </tr>
                    </thead>
                    <tbody>
                    </tbody>
                </table>
            </div>

        </div>
    </div>
    <!--엑셀 저장-->
    <div class="bt-align-div">
        <%--<asp:ImageButton AlternateText="엑셀저장" runat="server" ImageUrl="../../Images/Cart/excel-off.jpg" onmouseover="this.src='../../Images/Cart/excel-on.jpg'" onmouseout="this.src='../../Images/Cart/excel-off.jpg'" />--%>
    </div>
    <div style="margin: 0 auto; text-align: center">
        <input type="hidden" id="hdTotalCount">
        <div id="pagination" class="page_curl" style="display: inline-block"></div>
    </div>
</asp:Content>

