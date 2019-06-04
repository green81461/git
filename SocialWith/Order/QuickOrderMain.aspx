<%@ Page Title="" Language="C#" MasterPageFile="~/Master/Default.master" AutoEventWireup="true" CodeFile="QuickOrderMain.aspx.cs" Inherits="Order_QuickOrderMain" %>
<%@ Import Namespace="Urian.Core" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <link href="../Content/Order/order.css" rel="stylesheet" />

    <style>
        .str-upper {
            text-transform: uppercase;
        }
         .currentPay {
            font-weight:bold;
            color:red
        }
    </style>

    <script type="text/javascript">

        var is_sending = false;
        var gflag = false;
        // 상품코드 입력창에서 포커스 벗어났을 경우 - 상품조회
        $(document).on("blur", "input[id^=gCode]", function (e) {

            var addFlag = $(this).parent().find('input[id^=hdAddFlag]').val();
            if (!gflag && addFlag == 'false') {

                fnQuickOrder(this);
            }
           
        });
        
        function fnQuickOrder(el) {
            var gCode = $(el).val().toUpperCase();
            gCode = gCode.trim();
            $(el).val(gCode);

            var goodsTr = $(el).parent().parent();

            if (isEmpty(gCode)) {
                fnTdClear(goodsTr); // 행 출력 정보 제거
                return false;
            }

            var sameCheck = fnDuplCheck(this, gCode);
            if (!sameCheck) return false; // 중복된 상품코드 추가 방지

            var tdGoods = $(goodsTr).find("td[id^=tdGoods]");
            var tdGdsModel = $(goodsTr).find("td[id^=tdGdsModel]");
            var tdGdsSaleVat = $(goodsTr).find("td[id^=tdGdsSaleVat]");
            var tdGdsMoq = $(goodsTr).find("td[id^=tdGdsMoq]");
            var tdGdsUnitQty = $(goodsTr).find("td[id^=tdGdsUnitQty]");
            var tdGdsQty = $(goodsTr).find("td[id^=tdGdsQty]");
            var tdGdsDue = $(goodsTr).find("td[id^=tdGdsDue]");
            var tdGdsHapVat = $(goodsTr).find("td[id^=tdGdsHapVat]");
            var tdImg = $(goodsTr).find("td[id^='tdImg']");

            var hdSaleVat = $(tdGdsSaleVat).find("input:hidden[id^=hdSaleVat]");
            var hdGdsHapVat = $(tdGdsHapVat).find("input:hidden[id^=hdGdsHapVat]");
            var hdGdsMoq = $(tdGdsUnitQty).find("input:hidden[id^=hdGdsMoq]");

            var goodsSalePriceVat = 0;
            var minQty = 1;
            var pgFlag = '<%= DistCssObject.PgConfirmYN.AsText("N")%>';
            var callback = function (response) {

                if (!isEmpty(response)) {


                    var unitName = ""; // 단위명

                    $.each(response, function (key, value) {
                        if (!isEmpty(value.GoodsDCPriceVat)) {
                            goodsSalePriceVat = value.GoodsDCPriceVat;
                        }
                        else {
                            goodsSalePriceVat = value.GoodsSalePriceVat;
                        }

                        if (pgFlag == 'True') {

                            if (goodsSalePriceVat >= 4000000) {
                                alert("해당하는 상품을 찾을 수 없습니다.");
                                return false;
                            }
                        }

                        $(goodsTr).find("input:hidden[id^=hdFinCtgrCode]").val(value.GoodsFinalCategoryCode);
                        $(goodsTr).find("input:hidden[id^=hdGrpCode]").val(value.GoodsGroupCode);
                        $(goodsTr).find("input:hidden[id^=hdgCode]").val(value.GoodsCode);
                        $(goodsTr).find("input:hidden[id^=hdAddFlag]").val('true');

                        var taxTag = "";
                        if (value.GoodsSaleTaxYN == "2") taxTag = "<br />(면세)";

                        $(tdGoods).css("text-align", "left");
                        $(tdGoods).html("<span style='font-weight:bold'>[" + value.BrandName + "] " + value.GoodsFinalName + "</span><br><span style='color:#368AFF; width:280px; word-wrap:break-word; display:block;'>" + value.GoodsOptionSummaryValues +"</span>"+ taxTag);
                        $(tdGdsModel).text(value.GoodsModel);
                        $(tdGdsMoq).text(value.GoodsUnitMoq);
                        unitName = value.GoodsUnitName;

                        if (!isEmpty(value.GoodsDCPriceVat)) {
                            $(tdGdsSaleVat).empty();
                            $(tdGdsSaleVat).append('<input type="hidden" id="hdSaleVat" value="' + value.GoodsDCPriceVat + '"><span style="text-decoration: line-through;">' + numberWithCommas(value.GoodsSalePriceVat) + " 원" + '</span>&nbsp;<span style="color:red;">' + numberWithCommas(value.GoodsDCPriceVat) + " 원" + '</span>');
                        }
                        else {
                            $(tdGdsSaleVat).find("span").text(numberWithCommas(value.GoodsSalePriceVat) + " 원");
                        }

                        $(hdSaleVat).val(goodsSalePriceVat);

                        $(tdGdsUnitQty).find("span").text(value.GoodsUnitName);

                        minQty = value.GoodsUnitMoq;
                        $(goodsTr).find("input:hidden[id^=hdGdsMoq]").val(value.GoodsUnitMoq);

                        $(tdGdsDue).text(value.GoodsDeliveryOrderDue_Name);

                        var gdsFinalCtgrCode = value.GoodsFinalCategoryCode;
                        var gdsGrpCode = value.GoodsGroupCode;
                        var gdsCode = value.GoodsCode;
                        var gdsName = value.GoodsFinalName;

                        var src = "/GoodsImage" + "/" + gdsFinalCtgrCode + "/" + gdsGrpCode + "/" + gdsCode + "/" + gdsFinalCtgrCode + "-" + gdsGrpCode + "-" + gdsCode + '-sss.jpg';
                        $(tdImg).html("<img width='50px' height='50px' onerror='no_image(this, \"s\")' src='" + src + "' alt='" + gdsName + "' title='" + gdsName + "' />");
                    });

                    if (pgFlag == 'True') {

                        if (goodsSalePriceVat < 4000000) {
                            $(tdGdsQty).find("input[id^=gQty]").val(minQty);
                            $(tdGdsHapVat).find("label").text(numberWithCommas(goodsSalePriceVat * minQty) + " 원");
                            $(hdGdsHapVat).val(goodsSalePriceVat);

                            fnAutoAddRow(); // 자동 행 추가
                        }
                    }
                    else {
                        $(tdGdsQty).find("input[id^=gQty]").val(minQty);
                        $(tdGdsHapVat).find("label").text(numberWithCommas(goodsSalePriceVat * minQty) + " 원");
                        $(hdGdsHapVat).val(goodsSalePriceVat);

                        fnAutoAddRow(); // 자동 행 추가
                    }




                    //////////// 이 부분 임시로 주석-0-
                    //$(tdGdsQty).find("input[id^=gQty]").focus();

                } else {
                    fnTdClear(goodsTr); // 행 출력 정보 제거

                    alert("해당하는 상품을 찾을 수 없습니다.");
                }
                if (pgFlag == 'True') {

                    if (goodsSalePriceVat < 4000000) {
                        fnSetTotalPrice(); // 총 합계 계산해서 출력
                    }
                }
                else {
                    fnSetTotalPrice(); // 총 합계 계산해서 출력
                }


                return false;
            };
            var compcode = '';
            if (!isEmpty('<%= UserInfoObject.UserInfo.PriceCompCode%>')) {
                compcode = '<%= UserInfoObject.UserInfo.PriceCompCode%>'
            }
            else {
                compcode = 'EMPTY'
            }

            var saleCompcode = '';
            if (!isEmpty('<%= UserInfoObject.UserInfo.SaleCompCode%>')) {
                saleCompcode = '<%= UserInfoObject.UserInfo.SaleCompCode%>'
            }
            else {
                saleCompcode = 'EMPTY'
            }
            var param = { GoodsCode: gCode, CompCode: compcode, SaleCompCode: saleCompcode, DongshinCheck: '<%= UserInfoObject.UserInfo.BmroCheck%>', FreeCompanyYN: '<%= UserInfoObject.UserInfo.FreeCompanyYN%>', FreeCompanyVatYN: '<%= UserInfoObject.UserInfo.FreeCompanyVATYN.AsText("N")%>', SvidUser: '<%= Svid_User%>', Method: 'QuickView' };

            if (gCode != '') {

                var beforeSend = function () {
                    is_sending = true;
                }
                var complete = function () {
                    is_sending = false;
                    gflag = false;
                }
                if (is_sending) return false;

                JajaxDuplicationCheck("Post", "../Handler/OrderHandler.ashx", param, "json", callback, beforeSend, complete, true, '<%= Svid_User %>');

                //Jajax('Post', '../Handler/OrderHandler.ashx', param, 'json', callback);
            } else {
                fnTdClear(goodsTr); // 행 출력 정보 제거
            }
        }
        function fnSearchGoods(el) {
            if (event.keyCode == 13) {
                if ($(el).val().length != 7 ) {
                    alert('상품코드는 7자리로 입력해 주세요.');
                    gflag = true;
                }
                else {
                    fnQuickOrder(el);
                }
            }
        }
        
        $(document).on("blur", "input[id^=gQty]", function () {
           
            var qtyVal = $(this).val();

            var goodsTr = $(this).parent().parent().parent();
            var tdGdsSaleVat = $(goodsTr).find("td[id^=tdGdsSaleVat]");
            var tdGdsHapVat = $(goodsTr).find("td[id^=tdGdsHapVat]");
            var hdSaleVat = $(tdGdsSaleVat).find("input:hidden[id^=hdSaleVat]");
            var hdGdsHapVat = $(tdGdsHapVat).find("input:hidden[id^=hdGdsHapVat]");
            var hdGdsMoq = $(goodsTr).find("input:hidden[id^=hdGdsMoq]");
            var inputGdsQty = $(goodsTr).find("input[id^=gQty]");
            if ($(goodsTr).find("td[id^=tdGoods]").text() != '') {
                if ((qtyVal == "") || ($(hdGdsMoq).val() > $(inputGdsQty).val()) || ($(inputGdsQty).val() < 1)) {
                    alert("최소판매수량보다 작거나 1보다 작은 값을 입력하실 수 없습니다.");
                    $(inputGdsQty).val($(hdGdsMoq).val());

                    qtyVal = $(inputGdsQty).val();
                }
            }

            var moq = parseInt($(hdGdsMoq).val());
            var val = parseInt($(this).val()) % moq;

            if (val != 0) {
                alert('본 상품은 최소구매수량 단위로 구매가 가능합니다. ');
                $(inputGdsQty).val(moq);
                qtyVal = $(inputGdsQty).val();
            }
            if ($(tdGdsSaleVat).text() != "") {
                var tdHapVat = qtyVal * $(hdSaleVat).val();
                
                tdGdsHapVat.find("label").text(numberWithCommas(tdHapVat) + " 원");
                $(hdGdsHapVat).val(tdHapVat);
            }

            fnSetTotalPrice();
        });

        // enter key 방지
        $(document).on("keypress", "#tblTbody input", function (e) {
            if (e.keyCode == 13) {
                return false;
            }
            else
                return true;
        });
        
        $(document).on("keyup", "input[id^='gQty']", function () {
            $(this).val($(this).val().replace(/[^0-9]/g, ""));
        });


        // 상품코드 중복검사
        function fnDuplCheck(el, newCode) {
            var sameCnt = 0;
            $("#tblTbody tr").each(function () {
                var gCode = $(this).find("input[id^= gCode]").val();
                if (newCode == gCode) {
                    if (sameCnt == 1) {
                        $(el).val('');
                    }
                    ++sameCnt;
                }

                if (isEmpty(gCode)) {
                    fnTdClear($(this)); // 행 출력 정보 제거
                }
                
            });

            if (sameCnt > 1) {
                alert("이미 추가한 상품코드입니다. 더이상 추가하실 수 없습니다.");
                gflag = true;
                return false;
            } else {
                return true;
            }
        }

        // 자동 행 추가
        function fnAutoAddRow() {
            var emptyTdCnt = 0;
            $("#tblTbody tr").each(function () {
                var gdsNm = $(this).find("td[id^=tdGoods]").text();
                if (isEmpty(gdsNm)) {
                    ++emptyTdCnt;
                }
            });

            if (emptyTdCnt < 1) {
                fnRowAdd(); // 행 추가
            }
        }

        //행 출력 정보 제거
        function fnTdClear(goodsTr) {
            var tdGoods = $(goodsTr).find("td[id^=tdGoods]");
            var tdGdsModel = $(goodsTr).find("td[id^=tdGdsModel]");
            var tdGdsSaleVat = $(goodsTr).find("td[id^=tdGdsSaleVat]");

            var tdGdsUnitQty = $(goodsTr).find("td[id^=tdGdsUnitQty]");
            var tdGdsMoq = $(goodsTr).find("td[id^=tdGdsMoq]");
            var tdGdsQty = $(goodsTr).find("td[id^=tdGdsQty]");
            var tdGdsDue = $(goodsTr).find("td[id^=tdGdsDue]");
            var tdGdsHapVat = $(goodsTr).find("td[id^=tdGdsHapVat]");
            var tdImg = $(goodsTr).find("td[id^='tdImg']");

            var hdSaleVat = $(tdGdsSaleVat).find("input:hidden[id^=hdSaleVat]");
            var hdGdsHapVat = $(tdGdsHapVat).find("input:hidden[id^=hdGdsHapVat]");
            var hdGdsMoq = $(tdGdsUnitQty).find("input:hidden[id^=hdGdsMoq]");

            $(goodsTr).find("input[id^=gCode]").val('');
            $(goodsTr).find("input:hidden[id^=hdFinCtgrCode]").val('');
            $(goodsTr).find("input:hidden[id^=hdGrpCode]").val('');
            $(goodsTr).find("input:hidden[id^=hdgCode]").val('');
            $(goodsTr).find("input:hidden[id^=hdGdsMoq]").val('');

            $(tdImg).text('');
            $(tdGoods).text('');
            $(tdGdsModel).text('');
            $(tdGdsUnitQty).find("span").text('');
            $(tdGdsMoq).text('');
            $(tdGdsSaleVat).find("span").text('');
            $(hdSaleVat).val('');

            $(tdGdsQty).find("input[id^=gQty]").val('');

            $(tdGdsDue).text('');

            $(tdGdsHapVat).find("label").text('');
            $(hdGdsHapVat).val('');
            $(hdGdsMoq).val('');

            return false;
        }
        
        // 총 합계 금액 표시
        function fnSetTotalPrice() {
            var totPrice = 0.0;
            $("#tblTbody tr").each(function () {
                var tmpSaleVat = $(this).find("td[id^=tdGdsSaleVat]").text();
                if (tmpSaleVat != "") {
                    totPrice += parseFloat($(this).find("input:hidden[id^=hdGdsHapVat]").val());
                }
            });

            var strTotPrice = numberWithCommas(totPrice);

            $("#lblTotPrice").text(strTotPrice + " 원");
        }

        // 행 추가
        function fnRowAdd() {

            var rowCnt = $("#tblTbody tr").length;

            var btnTags = "<div id='btn'>"
                + "<a id='delbtn" + rowCnt + "' onclick='fnRowDel(this)'><img src='../Images/Goods/del-on.jpg' onmouseover=\"this.src='../Images/Goods/del-off.jpg'\" onmouseout=\"this.src='../Images/Goods/del-on.jpg'\"/></a> "
                + "<a id='addRowBtn" + rowCnt + "' onclick='fnRowAdd()'><img src='../Images/Goods/add-on.jpg' onmouseover=\"this.src='../Images/Goods/add-off.jpg'\" onmouseout=\"this.src='../Images/Goods/add-on.jpg'\"/></a>"
                + "</div>";



            var table = document.getElementById("tblTbody");

            //var row = table.insertRow();
            var row = table.insertRow(0);
            var cell1 = row.insertCell(0);
            var cell2 = row.insertCell(1);
            var cell3 = row.insertCell(2);
            var cell4 = row.insertCell(3);
            var cell5 = row.insertCell(4);
            var cell6 = row.insertCell(5);
            var cell7 = row.insertCell(6);
            var cell8 = row.insertCell(7);
            var cell9 = row.insertCell(8);
            var cell10 = row.insertCell(9);
            var cell11 = row.insertCell(10);

            cell1.innerHTML = "<input type='text' id='gCode" + rowCnt + "' class='textbox-css str-upper' onkeypress='return fnSearchGoods(this);'/>"
                + "<input type='hidden' id='hdFinCtgrCode" + rowCnt + "' />"
                + "<input type='hidden' id='hdGrpCode" + rowCnt + "' />"
                + "<input type='hidden' id='hdgCode" + rowCnt + "' />"
                 + "<input type='hidden' id='hdAddFlag" + rowCnt + "' value='false'/>";
            cell2.id = "tdImg" + rowCnt;
            cell2.innerHTML = "";
            cell3.id = "tdGoods" + rowCnt;
            cell3.innerHTML = "";
            cell4.id = "tdGdsModel" + rowCnt;
            cell4.innerHTML = "";
            cell5.id = "tdGdsDue" + rowCnt;
            cell5.innerHTML = "";
           
            cell6.id = "tdGdsMoq" + rowCnt;
            cell6.innerHTML = "";
            cell7.id = "tdGdsUnitQty" + rowCnt;
            cell7.innerHTML = "<span></span><input type='hidden' id='hdGdsMoq" + rowCnt + "' />";
            cell8.id = "tdGdsSaleVat" + rowCnt;
            cell8.style.paddingRight = "5px";
            cell8.style.textAlign = "right";
            cell8.innerHTML = "<span></span><input type='hidden' id='hdSaleVat" + rowCnt + "' />";
            cell9.id = "tdGdsQty" + rowCnt;
            cell9.innerHTML = "<span class='input-qty'><input type='number' id='gQty" + rowCnt + "'  min='0' max='9999999' /><a class='input-arrow-up' style='height: 15px' onclick='fnSetQty(this, \"up\");'><img src='../Images/inputarrow_up.png' width='9' height='9' class='imgarrowup' style='margin-bottom:15px;'/></a><a class='input-arrow-down' style='height: 15px' onclick='fnSetQty(this, \"down\");'><img src='../Images/inputarrow_down.png' width='9' height='9' class='imgarrowdown' style='margin-bottom:15px;'/></a></span>";
            cell10.id = "tdGdsHapVat" + rowCnt;
            cell10.style.paddingRight = "5px";
            cell10.style.textAlign = "right";
            cell10.innerHTML = "<label>---</label><input type='hidden' id='hdGdsHapVat" + rowCnt + "' />";
            cell11.innerHTML = btnTags;

            $('#gCode' + rowCnt + '').focus();
        }

        // 행 삭제
        function fnRowDel(obj) {
            var rowCnt = $("#tblTbody tr").length;
            if (rowCnt <= 1) {
                alert("행이 1개 남은 경우에는 더이상 삭제할 수 없습니다.");
                return false;
            }
            var clickTr = $(obj).parent().parent().parent();
            $(clickTr).remove();

            fnSetTotalPrice();
        }

        // 장바구니 담기
        function fnAddCart() {
            var rowCnt = $("#tblTbody tr").length;
            
            var trIndex = 0;

            var categoryCodeArray = '';
            var goodsGroupCodeArray = '';
            var codeArray = '';
            var qtyArray = '';

            $("#tblTbody tr").each(function () {
                var tmpGdsCode = $(this).find("input:hidden[id^=hdgCode]").val();
                if (tmpGdsCode != "") {
                    var tmpCtgrCode = $(this).find("input:hidden[id^=hdFinCtgrCode]").val();
                    var tmpGrpCode = $(this).find("input:hidden[id^=hdGrpCode]").val();
                    var tmpQty = $(this).find("input[id^=gQty]").val();

                    categoryCodeArray += tmpCtgrCode + '/';
                    goodsGroupCodeArray += tmpGrpCode + '/';
                    codeArray += tmpGdsCode + '/';
                    qtyArray += tmpQty + '/';

                    ++trIndex;
                }
                //else {
                //    console.log("빈 행 : " + $(this).find("input:hidden[id^=hdgCode]").prop("id"));
                //}
            });

            if (trIndex < 1) {
                alert("조회하신 상품이 없습니다. 상품코드를 입력해 주세요.");
                return false;
            }
            
            var callback = function (response) {
                if (!isEmpty(response)) {
                    $.each(response, function (key, value) {
                        if (value == "OK") {
                            alert("장바구니에 담았습니다.");
                            location.href = "../Cart/CartList.aspx";
                        }
                    });
                }
                return false;
            };

            var param = {
                SvidUser: '<%= Svid_User%>',
                GoodsFinCtgrCodes: categoryCodeArray.slice(0, -1),
                GoodsGrpCodes: goodsGroupCodeArray.slice(0, -1),
                GoodsCodes: codeArray.slice(0, -1),
                QTYs: qtyArray.slice(0, -1),
                Memo: '',
                Flag: 'QuickMultiAdd'
            };

            var beforeSend = function () {
                is_sending = true;
            }
            var complete = function () {
                is_sending = false;
            }
            if (is_sending) return false;

            JajaxDuplicationCheck("Post", "../Handler/CartHandler.ashx", param, "json", callback, beforeSend, complete, true, '<%= Svid_User %>');

            //Jajax('Post', '../Handler/CartHandler.ashx', param, 'json', callback);
            return false;
        }

        // 주문하기
        function fnOrder() {
            var rowCnt = $("#tblTbody tr").length;

            var trIndex = 0;

            var categoryCodeArray = '';
            var goodsGroupCodeArray = '';
            var codeArray = '';
            var qtyArray = '';

            $("#tblTbody tr").each(function () {
                var tmpGdsCode = $(this).find("input:hidden[id^=hdgCode]").val();
                if (tmpGdsCode != "") {
                    var tmpCtgrCode = $(this).find("input:hidden[id^=hdFinCtgrCode]").val();
                    var tmpGrpCode = $(this).find("input:hidden[id^=hdGrpCode]").val();
                    var tmpQty = $(this).find("input[id^=gQty]").val();

                    categoryCodeArray += tmpCtgrCode + ',';
                    goodsGroupCodeArray += tmpGrpCode + ',';
                    codeArray += tmpGdsCode + ',';
                    qtyArray += tmpQty + ',';

                    ++trIndex;
                }
            });

            if (trIndex < 1) {
                alert("조회하신 상품이 없습니다. 상품코드를 입력해 주세요.");
                return false;
            }

            var callback = function (response) {
                if (!isEmpty(response)) {
                    $.each(response, function (key, value) {
                        if (value == "OK") {
                            location.href = "../Order/OrderList.aspx";
                        }
                    });
                }
                return false;
            };

            var compcode = '';
            if (!isEmpty('<%= UserInfoObject.UserInfo.PriceCompCode%>')) {
                compcode = '<%= UserInfoObject.UserInfo.PriceCompCode%>'
            }
            else {
                compcode = 'EMPTY'
            }

            var saleCompCode = '';
            var siteName = '<%= SiteName.AsText("socialwith").ToLower()%>';
             if (siteName != 'socialwith') {
                 saleCompCode = '<%= UserInfoObject.UserInfo.SaleCompCode%>';
            }

            var param = {
                SvidUser: '<%= Svid_User%>',
                GoodsFinCtgrCodes: categoryCodeArray.slice(0, -1),
                GoodsGrpCodes: goodsGroupCodeArray.slice(0, -1),
                GoodsCodes: codeArray.slice(0, -1),
                QTYs: qtyArray.slice(0, -1),
                CompCode: compcode,
                SaleCompCode: saleCompCode,
                DongshinCheck: '<%= UserInfoObject.UserInfo.BmroCheck%>',
                FreeCompanyYN: '<%= UserInfoObject.UserInfo.FreeCompanyYN.AsText("N")%>',
                SvidUser: '<%= Svid_User%>',
                Method: 'OrderByQuick'
            };
            
           var beforeSend = function () {
                is_sending = true;
            }
            var complete = function () {
                is_sending = false;
            }
            if (is_sending) return false;

            JajaxDuplicationCheck("Post", "../Handler/OrderHandler.ashx", param, "json", callback, beforeSend, complete, true, '<%= Svid_User %>');

            //Jajax('Post', '../Handler/CartHandler.ashx', param, 'json', callback);
            return false;
        }

        ///// 엑셀 기능 작업중...............
        function fnExcel() {
            
            var gdsCodeArr = "";
            //var gdsInfoArr = [];
            //var gdsModelArr = [];
            //var gdsUnitArr = [];
            //var gdsDueArr = [];
            //var gdsSaleVatArr = [];
            var gdsQtyArr = "";
            //var gdsTotPriceArr = [];

            //var jsonList = '{"list" : [] }';

            $("#tblTbody tr").each(function () {

                var tmpGdsCode = $(this).find("input:hidden[id^=hdgCode]").val();
                //var tmpGdsInfo = $(this).find("td[id^='tdGoods']").text();
                //var tmpGdsModel = $(this).find("td[id^='tdGdsModel']").text();
                //var tmpGdsUnit = $(this).find("td[id^='tdGdsUnitQty']").text();
                //var tmpGdsDue = $(this).find("td[id^='tdGdsDue']").text();
                //var tmpGdsSaleVat = $(this).find("td[id^='tdGdsSaleVat']").text();
                var tmpGdsQty = $(this).find("input[id^='gQty']").val();
                //var tmpGdsTotPrice = $(this).find("td[id^='tdGdsHapVat']").text();

                gdsCodeArr += tmpGdsCode + ',';
                //gdsInfoArr[gdsInfoArr.length] = tmpGdsInfo;
                //gdsModelArr[gdsModelArr.length] = tmpGdsModel;
                //gdsUnitArr[gdsUnitArr.length] = tmpGdsUnit;
                //gdsDueArr[gdsDueArr.length] = tmpGdsDue;
                //gdsSaleVatArr[gdsSaleVatArr.length] = tmpGdsSaleVat;
                gdsQtyArr += tmpGdsQty + ',';
                //gdsTotPriceArr[gdsTotPriceArr.length] = tmpGdsTotPrice;


                //jsonList +=
            });

            //var list = [gdsCodeArr, gdsInfoArr, gdsModelArr, gdsUnitArr, gdsDueArr, gdsSaleVatArr, gdsQtyArr, gdsTotPriceArr];
            var list = gdsCodeArr + "|" + gdsQtyArr;
            
            $("#<%=hfList.ClientID %>").val(list);

            <%=Page.GetPostBackEventReference(btnQuickOrdExcel)%>

            return false;
        }

        function fnQuotePrint() {
            alert("추후에 서비스 할 예정입니다.");
            return false;
        }


        function fnSetQty(el, type) {
            var moq = parseInt($(el).parent().parent().parent().children().find('input[id^=hdGdsMoq]').val());
            if (type == 'up') {
               
                $(el).parent().find('input[id*="gQty"]').val(parseInt($(el).parent().find('input[id*="gQty"]').val()) + moq);
            }
            else if (type == 'down') {
                if (parseInt($(el).parent().find('input[id*="gQty"]').val()) - moq <= 0) {
                    alert('수량이 0보다 작거나 같을 수 없습니다.');
                }
                else {
                    $(el).parent().find('input[id*="gQty"]').val(parseInt($(el).parent().find('input[id*="gQty"]').val()) - moq);
                }
            }

            var qtyVal = parseInt($(el).parent().find('input[id*="gQty"]').val());
           
            var goodsTr = $(el).parent().parent().parent();
            var tdGdsSaleVat = $(goodsTr).find("td[id^=tdGdsSaleVat]");
            var tdGdsHapVat = $(goodsTr).find("td[id^=tdGdsHapVat]");
            var hdSaleVat = $(tdGdsSaleVat).find("input:hidden[id^=hdSaleVat]");
            var hdGdsHapVat = $(tdGdsHapVat).find("input:hidden[id^=hdGdsHapVat]");
            var hdGdsMoq = $(goodsTr).find("input:hidden[id^=hdGdsMoq]");
            var inputGdsQty = $(goodsTr).find("input[id^=gQty]");

            if ($(goodsTr).find("td[id^=tdGoods]").text() != '') {
                if ((qtyVal == "") || (parseInt($(hdGdsMoq).val()) > parseInt($(inputGdsQty).val())) || (parseInt($(inputGdsQty).val()) < 1)) {
                    alert("최소판매수량보다 작거나 1보다 작은 값을 입력하실 수 없습니다.");
                    $(inputGdsQty).val($(hdGdsMoq).val());

                    qtyVal = $(inputGdsQty).val();
                }
            }

            if ($(tdGdsSaleVat).text() != "") {
                var tdHapVat = qtyVal * $(hdSaleVat).val();

                tdGdsHapVat.find("label").text(numberWithCommas(tdHapVat) + " 원");
                $(hdGdsHapVat).val(tdHapVat);
            }

            fnSetTotalPrice();
           
        }
        
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <div class="sub-contents-div">

        <div class="sub-title-div">
                <p class="p-title-mainsentence">
                    <img src="../Images/SiteImage/title-img.jpg" class="img-title"/>간편주문(상품코드주문)
                    <span class="span-title-subsentence">상품코드로 간단하게 주문할 수 있습니다.</span>
                </p>
        </div>
        <!--탭메뉴-->
            <%--<div class="div-main-tab" >
                <ul>
                    <li>
                        <a href="QuickOrderMain.aspx" class='tabOn' style="width:185px; height:35px; font-size:12px">간편주문</a>
                        <a href="/Goods/GoodsRecommListSearch.aspx" class='tabOff' style="width:185px; height:35px; font-size:12px">MD 추천상품</a>
                    </li>
                </ul>
            </div>--%>
         <div class="div-main-tab" style="width: 100%; ">
            <ul>
                <li  class='tabOn' style="width: 185px;" onclick="location.href='QuickOrderMain.aspx'" >
                    <a href="QuickOrderMain.aspx" >간편주문</a>
                </li>
                <li  class='tabOff' style="width: 185px;" onclick="location.href='/Goods/GoodsRecommListSearch.aspx'">
                    <a href="/Goods/GoodsRecommListSearch.aspx" >MD 추천상품</a>
                 </li>
            </ul>
        </div>
        <div class="Quickimgnam" style="margin-left:3px; margin-bottom:30px; margin-top:50px;">

            <img src="/Images/Quickimgnam.jpg"/>

        </div>
        <div class="tab" style="text-align:right; margin-bottom:20px;">
           
            <%--<asp:Button runat="server"  Text="견적서출력" CssClass="mainbtn type1" Width="95" Height="30" Visible="false"/>--%>
           <%--  <a class="tabButton1" id="btnTab1"> <asp:ImageButton  runat="server" OnClientClick="fnQuotePrint(); return false;" Visible="false" AlternateText="견적서출력" ImageUrl="../Images/Cart/print-off.jpg" onmouseover="this.src='../Images/Cart/print-on.jpg'" onmouseout="this.src='../Images/Cart/print-off.jpg'" /></a>--%>
            <asp:Button ID="btnQuickOrdExcel" runat="server"  Text="엑셀저장" CssClass="mainbtn type1" Width="95" Height="30" OnClientClick="fnExcel(); return false;" OnClick="btnQuickOrdExcel_Click"/>
            <%--<asp:ImageButton  ID="btnQuickOrdExcel" OnClientClick="fnExcel(); return false;" OnClick="btnQuickOrdExcel_Click" runat="server" AlternateText="엑셀저장" ImageUrl="../Images/Cart/excel-off.jpg" onmouseover="this.src='../Images/Cart/excel-on.jpg'" onmouseout="this.src='../Images/Cart/excel-off.jpg'" />--%>
            <asp:Button ID="btnCart" runat="server"  Text="장바구니담기" CssClass="mainbtn type1" Width="95" Height="30" OnClientClick="fnAddCart(); return false;"  Visible="false"/>
            <%--<asp:ImageButton  runat="server"  ID="btnCart" OnClientClick="fnAddCart(); return false;" AlternateText="장바구니담기" ImageUrl="../Images/Goods/storage-btn_out.jpg" onmouseover="this.src='../Images/Goods/storage-btn_over.jpg'" onmouseout="this.src='../Images/Goods/storage-btn_out.jpg'" Visible="false"/>--%>
            <asp:Button ID="btnOrder" runat="server"  Text="주문하기" CssClass="mainbtn type1" Width="95" Height="30" OnClientClick="return fnOrder();"  Visible="false"/>
            <%--<asp:ImageButton  CssClass="top-bts-bt"  ID="btnOrder" runat="server" AlternateText="주문하기"  OnClientClick="return fnOrder();" ImageUrl="../Images/Cart/order-on.jpg" Visible="false" />--%>
            <asp:HiddenField runat="server" ID="hfList" />
             
        </div>
       <div style="float:right; margin-bottom:10px;">
                         <asp:Label runat="server" ID="lblPayStatus" CssClass="currentPay"></asp:Label>
                   </div>
        <div style="margin-top:30px;">
            <table id="tblQuick" class="board-table" style="line-height:30px; text-align:center;">
                <thead>
                    <tr class="board-tr-height" >
                        <th class="text-center" style="width:70px">상품코드</th>
                        <th class="text-center" style="width:70px">이미지</th>
                        <th class="text-center" style="width:300px">상품정보</th>
                        <th class="text-center" style="width:100px">모델명</th>
                        
                        <th class="text-center">출하예정일</th>
                        <th class="text-center">최소수량</th>
                        <th class="text-center" style="width:100px">내용량</th>
                        <th class="text-center" style="width:160px; height:40px; line-height:15px;">상품가격<br />(VAT <%= vatTag %>)</th>
                        <th style="text-align:center; width:70px">수 량</th>
                        <th class="text-center" style="width:110px; height:40px; line-height:15px;">합계 금액<br />(VAT <%= vatTag %>)</th>
                        <th style="text-align:center; width:100px">추가/삭제</th>
                    </tr>
                </thead>
                <tbody id="tblTbody">
                    <tr>
                        <td>
                            <input type="text" id="gCode0" class="textbox-css str-upper" onkeypress="return fnSearchGoods(this);"/>
                            <input type="hidden" id="hdFinCtgrCode0" />
                            <input type="hidden" id="hdGrpCode0" />
                            <input type="hidden" id="hdgCode0" />
                            <input type="hidden" id="hdAddFlag0" value="false" />
                        </td>
                        <td id="tdImg0"></td>
                        <td id="tdGoods0" style="text-align:left;"></td>         
                        <td id="tdGdsModel0"></td>
                        <td id="tdGdsDue0"></td>
                        <td id="tdGdsMoq0"></td>
                        <td id="tdGdsUnitQty0"><span></span><input type="hidden" id="hdGdsMoq0" /></td>
                        
                        <td id="tdGdsSaleVat0" style="padding-right:5px; text-align:right;"><span></span><input type="hidden" id="hdSaleVat0" /></td>
                        <td id="tdGdsQty0">
                            <span class='input-qty'>
                                <input type="number" id="gQty0" min="0" max="9999999"  />
                                <a class='input-arrow-up' onclick="fnSetQty(this, 'up');" style="height:15px"><img src='../Images/inputarrow_up.png' width='9' height='9' class='imgarrowup' style="margin-bottom:15px"/></a>
                                <a class='input-arrow-down' onclick="fnSetQty(this,'down');" style="height:15px"><img src='../Images/inputarrow_down.png' width='9' height='9' class='imgarrowdown' style="margin-bottom:15px"/></a>
                            </span>
                        </td>
                        <td id="tdGdsHapVat0" style="padding-right:5px; text-align:right;"><label>---</label><input type="hidden" id="hdGdsHapVat0" /></td>
                        <td>
                            <div id="btn">
                                <a id="delbtn0" onclick="fnRowDel(this)"><img src="../Images/Goods/del-on.jpg"  onmouseover="this.src='../Images/Goods/del-off.jpg'" onmouseout="this.src='../Images/Goods/del-on.jpg'"/></a>
                                <a id="addRowBtn0" onclick="fnRowAdd()"><img src="../Images/Goods/add-on.jpg"  onmouseover="this.src='../Images/Goods/add-off.jpg'" onmouseout="this.src='../Images/Goods/add-on.jpg'"/></a>
                            </div>
                        </td>
                    </tr>
                </tbody>
                <tfoot>
                    <tr>
                        <td colspan="11" style="line-height:25px">합계 : <label id="lblTotPrice">---</label></td>
                    </tr>
                </tfoot>
            </table>
            <span style="color:#69686d;  float:right;  margin-top:10px; margin-bottom:10px;"> *<b style="color:#ec2029; font-weight:bold;"> VAT(부가세)<%= vatTag %> 가격</b>입니다.</span>
        </div>
    </div>

    <script>
        $(function () {

            $("a[id^=delbtn]").on("mouseover focus", function () {
                $("img", this).attr("src", $("img", this).attr("src").replace("out.jpg", "over.jpg"));
            });

            $("a[id^=delbtn]").on("mouseleave", function () {
                $("img", this).attr("src", $("img", this).attr("src").replace("over.jpg", "out.jpg"));
            });

        });

    </script>
</asp:Content>
