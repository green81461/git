<%@ Page Title="" Language="C#" MasterPageFile="~/Master/Default.master" AutoEventWireup="true" CodeFile="DeliveryOrderList.aspx.cs" Inherits="Delivery_DeliveryOrderList" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <link href="../Content/Delivery/deliverylist.css" rel="stylesheet" />
    <script src="../Scripts/jquery.inputmask.bundle.js"></script>

   
    <script type="text/javascript">
        $(document).ready(function () {
            $("#<%=this.txtSearchSdate.ClientID%>").inputmask("9999-99-99");
            $("#<%=this.txtSearchEdate.ClientID%>").inputmask("9999-99-99");

            var budget_role = '<%=UserInfoObject.Svid_Role %>';

            if (budget_role != "A1") {
                $('#thHeaderName').html('주문자<br/>(요청자)');
            }

            //체크박스 하나만 선택
            var tableid = 'tblSearchList';
            ListCheckboxOnlyOne(tableid);

            //달력
            $("#<%=this.txtSearchSdate.ClientID%>").datepicker({
                showAnimation: 'slideDown',
                changeMonth: true,
                changeYear: true,
                showOn: 'button',
                buttonImage:/* "/Images/icon_calandar.png"*/"../Images/Goods/calendar.jpg",
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
                buttonImage:/* "/Images/icon_calandar.png"*/"../Images/Goods/calendar.jpg",
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

        //조회하기
        function fnSearch(pageNum) {
            var svidUser = '<%= Svid_User %>';
            var svidRole = '<%= UserInfoObject.Svid_Role %>';
            var startDate = $('#<%= txtSearchSdate.ClientID%>').val();
            var endDate = $('#<%= txtSearchEdate.ClientID%>').val();
            var orderCodeNo = $('#<%= txtOrderNo.ClientID %>').val();
            var orderStatus = $('#<%= ddlOrderStatus.ClientID %>').val();
            var payway = $('#<%= ddlPayWay.ClientID %>').val();

            var pageSize = 20;
            var i = 1;
            var asynTable = "";

            var callback = function (response) {
                $("#tblDeliveryOrderList tbody").empty();
                if (!isEmpty(response)) {
                    $.each(response, function (key, value) {
                        $("#hdTotalCount").val(value.TotalCount);

                        var name = '';
                        if (svidRole != 'A1') {
                            name = value.Name + "<br/>(" + value.RequestName + ")";
                        }
                        else {
                            name = value.Name;
                        }

                        var src = '/GoodsImage' + '/' + value.GoodsFinalCategoryCode + '/' + value.GoodsGroupCode + '/' + value.GoodsCode + '/' + value.GoodsFinalCategoryCode + '-' + value.GoodsGroupCode + '-' + value.GoodsCode + '-sss.jpg';

                        asynTable += "<tr><td rowspan='2' class='border-right'>"
                            + "<input type='hidden' name='hdOrdCodeNo' value='" + value.OrderCodeNo + "' />"
                            + "<input type='hidden' name='hdGoodsCode' value='" + value.GoodsCode + "' />"
                            + (pageSize * (pageNum - 1) + i)
                            + "</td>"; //번호
                        asynTable += "<td class='border-right'>" + value.EntryDate.split("T")[0] + "</td>"; //주문일자
                        asynTable += "<td class='border-right' rowspan='2'>" + name + "</td>";//주문자
                        asynTable += "<td class='border-right' rowspan='2'>" + value.OrderSaleCompanyName + "</td>"; //판매사
                        asynTable += "<td rowspan='2' class='border-right' style= 'text-align:left; padding-left:5px;' rowspan='2'><table style='width:100%;' id='tblGoodsInfo'><tr><td rowspan='2' style='width:20%; border:0'><img src=" + src + " style='width:50px; height=50px'/></td><td style='text-align:left; border:0;'>" + value.GoodsCode + "</td></tr><tr><td style='text-align:left; border:0;'>" + "[" + value.BrandName + "] " + value.GoodsFinalName + "<br/><span style='color:#368AFF'>" + value.GoodsOptionSummaryValues + "</span></td></tr></table></td>";
                        asynTable += "<td rowspan='2' class='border-right'>" + value.GoodsModel + "</td>"; //모델명
                        asynTable += "<td style='text-align:center' class='border-right'>" + value.GoodsUnitMoq + " / " + value.GoodsUnit + "</td>"; //최소수량 / 내용량
                        asynTable += "<td rowspan='2' style='padding-right: 5px; text-align: right;' class='border-right'>" + numberWithCommas(value.GoodsSalePriceVat) + "원</td>";//상품가격
                        asynTable += "<td rowspan='2' class='border-right' style='padding-right: 5px; text-align: right;'>" + numberWithCommas(value.GoodsTotalSalePriceVAT) + "원</td>";
                        asynTable += "<td class='border-right'>" + value.OrderStatus_NAME + "</td>";//주문처리현황
                        asynTable += "<td style='text-align:center' class='border-right'>" + value.DeliveryName + "</td>";//배송방법

                        var ordEnterYN_val = ''; //입고확인 출력값
                        var ordEnterYN = value.OrderEnterYN; //입고확인여부
                        if (ordEnterYN == 'Y') {
                            ordEnterYN_val = "입고확인완료";
                        } else {
                            ordEnterYN_val = "<a onclick='fnUpdateOrderEnterYN(this, \"\"); return false;'><img src='../Images/delivery/check-off.jpg' alt='입고확인' onmouseover='this.src=\"../Images/delivery/check-on.jpg\"' onmouseout='this.src=\"../Images/delivery/check-off.jpg\"'></a>";
                        }

                        asynTable += "<td style='text-align:center' rowspan='2' class='border-right'>" + ordEnterYN_val + "</td>";//입고확인
                        asynTable += "</tr>";

                        //--------------------------------------------------다음행-------------------------------------------------------------//
                        asynTable += "<tr>";
                        asynTable += "<td class='border-right'>" + value.OrderCodeNo + "</td>";
                        asynTable += "<td class='border-right'>" + value.Qty + "</td>";
                        asynTable += "<td class='border-right'>" + value.PayWay + "</td>";

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
                                tagDlvrNo += "<a style='cursor:pointer; color:#091994;' onclick='fnPopupDeliverySearch(\"" + arrDlvrNo[j] + "\")'>" + arrDlvrNo[j] + "</a>";
                            }
                        }
                        //----운송장 번호 조회되게 처리영역----

                        //asynTable += "<td class='border-right'><a style='cursor:pointer' onclick='fnPopupDeliverySearch(\"" + value.DeliveryNo + "\")'>" + value.DeliveryNo + "</a></td>";//운송장번호
                        asynTable += "<td class='border-right'>" + tagDlvrNo + "</td>";//운송장번호

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
                , Method: "DeliveryOrderList"
                , OrderCodeNo: orderCodeNo
                , OrderStatus: orderStatus
                , Payway: payway
                , PageNo: pageNum
                , PageSize: pageSize
            };

            JajaxSessionCheck('Post', '../Handler/Common/DeliveryHandler.ashx', param, 'json', callback, svidUser);
        }

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

        function getPageData() {
            var container = $('#pagination');
            var getPageNum = container.pagination('getSelectedPageNum');
            fnSearch(getPageNum);
            return false;
        }

        var is_sending = false;
        //입고확인
        function fnUpdateOrderEnterYN(el, flag) {
            var p_ordStat = $('#<%= ddlOrderStatus.ClientID %>').val();
            if (p_ordStat != "302") {
                alert("배송중인 상품은 입고확인을 하실 수 없습니다.");
                return false;
            }

            var lengthData = $("input:hidden[name='hdOrdCodeNo']").length;
            if (lengthData <= 0) {
                alert("조회된 상품이 없습니다.");
                return false;
            }

            //일괄적용
            if (flag == "ALL") {
                var confirmVal = confirm("선택하신 주문일자의 상품이 전체적으로 \"입고확인완료\"가 됩니다. 계속 진행하시겠습니까?");

                if (!confirmVal) {
                    return false;
                }
            }

            var callback = function (response) {
                if (!isEmpty(response)) {
                    if (response == "ALLOK") {
                        alert("성공적으로 입고확인이 완료되었습니다.");
                        fnSearch(1);

                    } else if (response == "OK") {
                        $(el).parent().text("입고확인완료");
                    }

                } else {
                    alert("입고확인에 실패하였습니다. 잠시 후 다시 시도해 주세요.");
                }
                return false;
            };

            var sUser = '<%= Svid_User %>';
            var p_method = "UpdateOrdEnterYN";
            var p_ordCodeNo = '';
            var p_goodsCode = '';
            var p_payway = '';
            var p_startDate = '';
            var p_endDate = '';

            //일괄적용
            if (flag == "ALL") {
                p_ordCodeNo = $('#<%= txtOrderNo.ClientID %>').val();

                p_payway = $('#<%= ddlPayWay.ClientID %>').val();
                p_startDate = $('#<%= txtSearchSdate.ClientID%>').val();
                p_endDate = $('#<%= txtSearchEdate.ClientID%>').val();

                //개별적용
            } else {
                p_ordCodeNo = $(el).parent().parent().find("input:hidden[name='hdOrdCodeNo']").val();
                p_goodsCode = $(el).parent().parent().find("input:hidden[name='hdGoodsCode']").val();
            }

            var param = {
                SvidUser: sUser,
                OrdCodeNo: p_ordCodeNo,
                GoodsCode: p_goodsCode,
                OrdStat: p_ordStat,
                Payway: p_payway,
                StartDate: p_startDate,
                EndDate: p_endDate,
                Flag: flag,
                Method: p_method
            };

            var beforeSend = function () {
                is_sending = true;
            }
            var complete = function () {
                is_sending = false;
            }
            if (is_sending) return false;

            JajaxDuplicationCheck("Post", "../Handler/Common/DeliveryHandler.ashx", param, "text", callback, beforeSend, complete, true, sUser);
        }

        function fnPopupDeliverySearch(deliveryNo) {
            var width = 1024;
            var height = 800;
            var popupX = (window.screen.width / 2) - (width / 2);
            var popupY = (window.screen.height / 2) - (height / 2);

            //var url = 'http://nplus.doortodoor.co.kr/web/detail.jsp?slipno=' + deliveryNo;

            var url = "http://www.hanjin.co.kr/Delivery_html/inquiry/result_waybill.jsp?wbl_num=" + deliveryNo;

            window.open(url, '', "height=" + height + ", width=" + width + ",status=yes,toolbar=no,menubar=no,location=no,resizable=no, scrollbars=yes,left=" + popupX + ", top=" + popupY + ", screenX=" + popupX + ", screenY= " + popupY + "");

            return false;
        }

        function fnEnter() {

            if (event.keyCode == 13) {
                fnSearch(1);
                return false;
            }
            else
                return true;
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



    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div class="sub-contents-div">
        <div class="sub-title-div">
             <img src="/images/DeliveryOrderList_nam.png" />
            <%--<p class="p-title-mainsentence">
                배송조회
                       <span class="span-title-subsentence">상품의 배송상태 확인할 수 있습니다.</span>
            </p>--%>
        </div>

        <div style="margin-top: 20px;">
            <table class="tbl_main" id="tblSearchList">

                <tr>
                    <th style="height: 30px; width:180px;" class="border-right">주문일</th>
                    <td style="width: 630px;" class="border-right align-left">

                        <asp:TextBox ID="txtSearchSdate" type="date" runat="server" MaxLength="10" CssClass="calendar" onkeypress="return fnEnterDate();" placeholder="2018-01-01" ReadOnly="true" style="margin-right:5px;"></asp:TextBox>
                        -
                            <asp:TextBox ID="txtSearchEdate" type="date" runat="server" MaxLength="10" CssClass="calendar" onkeypress="return fnEnterDate();" placeholder="2018-12-30" ReadOnly="true" style="margin-right:5px;"></asp:TextBox>
                        &nbsp;&nbsp;&nbsp;
                            <input style="vertical-align:middle;" type="checkbox" name="chkBox" id="ckbSearch1" value="1" checked="checked" /><label for="ckbSearch1">1일</label>
                        <input style="margin-left:5px; vertical-align:middle;" type="checkbox" name="chkBox" id="ckbSearch2" value="7" /><label for="ckbSearch2">7일</label>
                        <input style="margin-left:5px; vertical-align:middle;" type="checkbox" name="chkBox" id="ckbSearch3" value="15" /><label for="ckbSearch3">15일</label>
                        <input style="margin-left:5px; vertical-align:middle;" type="checkbox" name="chkBox" id="ckbSearch4" value="30" /><label for="ckbSearch4">30일</label>
                        <input style="margin-left:5px; vertical-align:middle;" type="checkbox" name="chkBox" id="ckbSearch5" value="90" /><label for="ckbSearch5">90일</label>
                        <input style="margin-left:5px; vertical-align:middle;" type="checkbox" name="chkBox" id="ckbSearch6" value="0" /><label for="ckbSearch6">직접입력</label>
                    </td>
                    <th class="txt-center border-right">결제수단</th>
                    <td class="align-left">
                        <asp:DropDownList runat="server" ID="ddlPayWay" CssClass="input-drop" Width="100%" Height="24px">
                        </asp:DropDownList>
                    </td>
                </tr>

                <tr>
                    <th style="height: 30px;" class="border-right">주문번호</th>
                    <td class="border-right align-left">
                        <asp:TextBox ID="txtOrderNo" runat="server" CssClass="input-text" Style="border: 1px solid #a2a2a2;" Onkeypress="return fnEnter();"></asp:TextBox></td>
                    <th class="border-right" style="height: 30px; width: 180px;">구분(처리상태)</th>
                    <td class="align-left">
                        <asp:DropDownList runat="server" ID="ddlOrderStatus" CssClass="input-drop" Width="100%" Height="24px"></asp:DropDownList></td>

                    <%--<th  style="height:30px; width:200px;">송장조회</th>
				   <td style="width:180px;" class="text-center"><a><img src="../Images/delivery/cjDelivery-off.jpg" alt="cj택배송장조회" onmouseover="this.src='../Images/delivery/cjDelivery-on.jpg'"  onmouseout="this.src='../Images/delivery/cjDelivery-off.jpg'"/></a>
				   </td>--%>
                </tr>
            </table>
        </div>

        <div class="align-div">
            <input type="button" class="mainbtn type1" style="width:117px; margin-right:-2px; height:30px; font-size:12px" value="일괄적용" onclick="fnUpdateOrderEnterYN('', 'ALL'); return false;"/>
            <input type="button" class="mainbtn type1" style="width:117px; height:30px; font-size:12px" value="조회하기" onclick="fnSearch(1); return false;"/>

            <%--<a onclick="fnUpdateOrderEnterYN('', 'ALL'); return false;">
                <img src="../Images/delivery/adjust1-on.jpg" alt="일괄적용" onmouseover="this.src='../Images/delivery/adjust1-off.jpg'" onmouseout="this.src='../Images/delivery/adjust1-on.jpg'"></a>
            <a>
                <img src="../Images/Document/search-bt-off.jpg" alt="조회하기" onclick="fnSearch(1);return false;" onmouseover="this.src='../Images/Document/search-bt-on.jpg'" onmouseout="this.src='../Images/Document/search-bt-off.jpg'"></a>--%>
        </div>

        <!--입고확인 관련 알림 및 VAT포함 라벨표시-->
        <div style="width: 100%; color: #ee2248; text-align: right; margin-top: 10px; margin-bottom: 10px;">*<b style="color: #ee2248; font-weight: bold;"> 배송완료 시점으로 5일이후에는 자동적으로 "입고확인완료" 가 진행됩니다.</b></div>
        <div style="width: 100%; color: #ee2248; text-align: right; margin-top: 10px; margin-bottom: 10px;">*<b style="color: #ee2248; font-weight: bold;"> VAT(부가세)포함 가격</b>입니다.</div>
        <!--VAT포함 라벨표시 끝-->
        <div class="list-div">
            <table id="tblDeliveryOrderList" class="tbl_main tbl_main2">

                <thead>
                    <tr>
                        <th style="width: 80px" rowspan="2" class="border-right">번호</th>
                        <th style="width: 140px" class="border-right">주문일자</th>
                        <th style="width: 100px" rowspan="2" id="thHeaderName" class="border-right">주문자</th>
                        <th style="width: 140px" rowspan="2" class="border-right">판매사</th>
                        <th style="width: 300px" rowspan="2" class="border-right">주문상품정보</th>
                        <th style="width: 130px" rowspan="2" class="border-right">모델명</th>
                        <th style="width: 130px" class="border-right">최소수량 / 내용량</th>
                        <th style="width: 100px" rowspan="2" class="border-right">상품가격</th>
                        <th style="width: 130px" rowspan="2" class="border-right">주문금액</th>
                        <%--<th style="width: 100px" class="border-right">예산부서</th>--%>
                        <th style="width: 130px" class="border-right">주문처리현황</th>
                        <th style="width: 130px" class="border-right">배송방법</th>
                        <th style="width: 100px" rowspan="2">입고확인</th>
                    </tr>
                    <tr>
                        <th class="border-right">주문번호</th>
                        <th class="border-right">주문수량</th>
                        <%--<th class="budget-view border-right">예산계정</th>--%>
                        <th class="border-right">결제수단</th>
                        <th style="width: 130px" class="border-right">운송장번호</th>
                    </tr>
                </thead>
                <tbody>
                </tbody>
            </table>
            <br />

            <!-- 페이징 처리 -->
            <div style="margin: 0 auto; text-align: center">
                <input type="hidden" id="hdTotalCount" />
                <div id="pagination" class="page_curl" style="display: inline-block"></div>
            </div>
        </div>
        <div class="align-div">
            <%--임시로 엑셀저장 버튼 숨김--%>
            <asp:ImageButton ID="btnExcel" Visible="false" runat="server" AlternateText="상세내용 엑셀출력" ImageUrl="../Images/Cart/excel-off.jpg" onmouseover="this.src='../Images/Cart/excel-on.jpg'" onmouseout="this.src='../Images/Cart/excel-off.jpg'" />
        </div>
    <div class="left-menu-wrap" id="divLeftMenu">
	    <dl>
		    <dt style="border-bottom:1px solid #eaeaea;">
			    <strong>마이페이지</strong>
		    </dt>
		    <dd>
                <a href="/Order/OrderHistoryList.aspx">주문조회</a> 
            </dd>
            <dd   class="active">
                <a href="/Delivery/DeliveryOrderList.aspx">배송조회</a> 
            </dd>
            <dd>
                <a href="/Order/OrderBillIssue.aspx">세금계산서 조회</a> 
            </dd>
            <dd>
                <a href="/Member/MemberEditCheck.aspx">마이정보변경</a> 
            </dd>
            <dd>
                <a href="/Delivery/DeliveryList.aspx">배송지관리</a> 
            </dd>
	    </dl>
    </div>
    </div>
</asp:Content>
