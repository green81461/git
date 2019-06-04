<%@ Page Title="" Language="C#" MasterPageFile="~/Master/Default.master" AutoEventWireup="true" CodeFile="GoodsRecommListSearch.aspx.cs" Inherits="Goods_GoodsRecommListSearch" %>
<%@ Import Namespace="Urian.Core" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <style>
        table#tblGoodsInfo,
        table#tblGoodsInfo td,
        table#tblGoodsInfo_pop td {
            border: none !important;
        }
    </style>
    <script>
        $(function () {


            if ('<%= UserInfoObject.UserInfo.BPestimateCompareYN.AsText("N")%>' == "N") {
                $('#btnOrder').css('display', '');
            }
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

        }

        function getPageData() {
            var container = $('#pagination');
            var getPageNum = container.pagination('getSelectedPageNum');
            fnSearch(getPageNum);
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
        function fnEnter() {
            if (event.keyCode == 13) {
                fnSearch(1);
                return false;
            }
            else
                return true;
        }

        function fnSearch(pageNo) {
            var callback = function (response) {
                $("#tblItem_tbody").empty(); //데이터 클리어
                if (!isEmpty(response)) {

                    var listTag = "";

                    $.each(response, function (key, value) {

                        $('#itemPagination').css('display', 'inline-block');
                        $('#hdItemTotalCount').val(value.TotalCount);
                        listTag += "<tr>"
                        listTag += "<td class='txt-center' style='display:none'><input type='checkbox' id='cbItemSelect'></td>";
                        listTag += "<td class='txt-center'><input type='hidden' id='hdRecommCode' value='" + value.GoodsRecommCode + "' />" + value.RowNum + "</td>";
                        listTag += "<td class='txt-center'>" + value.YYYYMMDD + "</td>";
                        listTag += "<td class='txt-center'>" + value.GoodsRecommCode + "</td>";
                        listTag += "<td class='txt-center'>" + value.Subject + "</td>";
                        var goodsNames = '';
                        if (parseInt(value.RecommCount) > 0) {
                            goodsNames = value.GoodsFinalName + " 외 " + value.RecommCount + "건";
                        }
                        else {
                            goodsNames = value.GoodsFinalName;
                        }

                        listTag += "<td class='txt-center'>" + goodsNames + "</td>";
                        listTag += "<td class='txt-center'>" + value.AdminUserName + "</td>";

                        var confirmText = '확인';
                        if (value.ConfirmYn == 'N') {
                            confirmText = '미확인';
                        }
                        listTag += "<td class='txt-center'>" + confirmText + "</td>";
                        listTag += "<td class='txt-center'><input type='button' class='listBtn' value='상세보기' style='width:71px; height:22px; font-size:12px' onclick='return fnDetailView(\"" + value.GoodsRecommCode + "\",\"" + value.FreeCompanyVatYN + "\" )'/></td>";
                        listTag += "</tr>";
                    });
                    $("#tblItem_tbody").append(listTag);
                    fnCreatePagination('itemPagination', $("#hdItemTotalCount").val(), pageNo, 20, getItemPageData);

                } else {
                    var emptyTag = "<tr><td colspan='9' class='txt-center'>조회된 데이터가 없습니다.</td></tr>";
                    $('#itemPagination').css('display', 'none');
                    $("#tblItem_tbody").append(emptyTag);
                }

                return false;
            };
            var sUser = '<%=Svid_User %>';

            var param = {
                SvidUser: sUser,
                Sdate: $("#<%=this.txtSearchSdate.ClientID%>").val(),
                Edate: $("#<%=this.txtSearchEdate.ClientID%>").val(),
                Subject: $("#<%=this.txtSubject.ClientID%>").val(),
                UserName: $("#<%=this.txtAdminName.ClientID%>").val(),
                Code: $("#<%=this.txtRecommNum.ClientID%>").val(),
                PageNo: pageNo,
                PageSize: 20,
                Method: 'GetGoodsRecommList'
            };
            JqueryAjax('Post', '../../Handler/GoodsRecommHandler.ashx', true, false, param, 'json', callback, null, null, true, '<%=Svid_User%>');
        }

        function getItemPageData() {
            var container = $('#itemPagination');
            var getPageNum = container.pagination('getSelectedPageNum');
            fnSearch(getPageNum);
            return false;
        }

        function fnDetailView(code, FreeCompanyVatYN) {

            var serviceChk = code.indexOf("RS");

            $('#hdPopupGoodsRecommCode').val(code);
            if (FreeCompanyVatYN == 'Y') {
                $('#vatChk').text("(VAT 포함)");
                $('#totalVatChk').text("(VAT 포함)");
            }
            else if (FreeCompanyVatYN == 'N') {
                $('#vatChk').text("(VAT 별도)");
                $('#totalVatChk').text("(VAT 별도)");
            }
            else {
                $('#vatChk').text("(VAT 포함)");
                $('#totalVatChk').text("(VAT 포함)");
            }

            var callback = function (response) {
                $("#tblPopupGoodsRecomm_tbody").empty(); //데이터 클리어

                if (!isEmpty(response)) {

                    var listTag = '';
                    var fileAdd = '';
                    var title = '';
                    var addWish = ' <input type="button" id="addWish" class="mainbtn type1" style="width:95px; height:30px; font-size:12px;" value="관심상품 저장" onclick="fnAddWish(); return false;"/>';
                    $('#addWish').remove();

                    if (serviceChk != -1) {
                        fileAdd += "<tr><tr><th>제목</th><td><input type='text' id='txtPopupSubject' style='width:100%;background-color:transparent;border:0 solid black;' readonly /></td></tr>";
                        fileAdd += "<tr><th>상세사항</th><td><textarea style='width:100%;background - color: transparent; border: 0 solid black; resize: none;' id='txtPopupContent' rows='5' readonly></textarea></td></tr>";
                        fileAdd += "<tr><th>첨부파일</th><td>";
                        fileAdd += "<input type='hidden' id='hdFileName'/><input type='hidden' id='hdFilePath'/><a id='fileDownload' onclick= 'fnFileDownload(this); return false;' style= 'cursor: pointer; text-decoration:none; color:blue;' ></a ></td></tr>"

                        title += "<h3>서비스용역상품</h3>";

                    } else {
                        fileAdd += "<tr><tr><th>제목</th><td><input type='text' id='txtPopupSubject' style='width:100%;background-color:transparent;border:0 solid black;' readonly /></td></tr>";
                        fileAdd += "<tr><th>상세사항</th><td><textarea style='width:100%; background-color: transparent; border: 0 solid black; resize: none;' id='txtPopupContent' rows='5' readonly></textarea></td></tr>";

                        title += "<h3>견적상품</h3>";

                        $('#addCart').after(addWish);
                    }

                    $('#fileAdd').empty().append(fileAdd);
                    $('#popupTitle').empty().append(title);

                    $.each(response, function (key, value) {

                        if (key == 0) {
                            $('#txtPopupSubject').val(value.Subject);
                            $('#txtPopupContent').val(value.Remark);
                            $('#fileDownload').text(value.AttachPName);
                            $('#hdFileName').val(value.AttachPName);
                            $('#hdFilePath').val(value.AttachPath);
                        }

                        listTag += "<tr>"
                        listTag += "<td class='txt-center'><input type='checkbox' id='cbPopupItemSelect' checked='checked'/>";
                        listTag += "<input type='hidden' id='hdPopupCategoryCode' value='" + value.GoodsFinalCategoryCode + "' />";
                        listTag += "<input type='hidden' id='hdPopupGroupCode' value='" + value.GoodsGroupCode + "' />";
                        listTag += "<input type='hidden' id='hdPopupGoodsCode' value='" + value.GoodsCode + "' />";
                        listTag += "<input type='hidden' id='hdPopupQty' value='" + value.Qty + "' />";
                        listTag += "<input type='hidden' id='hdPopupPriceVat' value='" + value.GoodsRecommPriceVAT + "' />";
                        listTag += "<input type='hidden' id='hdPopupPrice' value='" + value.GoodsRecommPrice + "' /></td>";
                        listTag += "<td class='txt-center'>" + value.Seq + "</td>";
                        var src = '/GoodsImage' + '/' + value.GoodsFinalCategoryCode + '/' + value.GoodsGroupCode + '/' + value.GoodsCode + '/' + value.GoodsFinalCategoryCode + '-' + value.GoodsGroupCode + '-' + value.GoodsCode + '-sss.jpg';
                        listTag += "<td style= 'text-align:left; padding-left:5px; border:1px solid #a2a2a2;' ><table style='width:100%;' id='tblGoodsInfo'><tr><td rowspan='2' style='width:14%'><img src=" + src + " onerror='no_image(this, \"s\")' style='width:50px; height=50px'/></td><td style='text-align:left; width:86%'>" + value.GoodsCode + "</td></tr><tr><td style='text-align:left; width:86%'>" + "[" + value.BrandName + "] " + value.GoodsFinalName + "<br/><span style='color:#368AFF; width:86%; word-wrap:break-word; display:block;'>" + value.GoodsOptionSummaryValues + "</span></td></tr></table></td>";
                        listTag += "<td class='txt-center'>" + value.GoodsModel + "</td>";
                        listTag += "<td class='txt-center'>" + value.GoodsUnitName + "</td>";

                        var price = '';
                        if (FreeCompanyVatYN == 'Y') {
                            price = numberWithCommas(value.GoodsRecommPriceVAT);
                        }
                        else {
                            price = numberWithCommas(value.GoodsRecommPrice);
                        }

                        listTag += "<td class='txt-center'>" + price + "원</td>";
                        listTag += "<td class='txt-center'>" + value.Qty + "</td>";

                        var totalPrice = '';
                        if (FreeCompanyVatYN == 'Y') {
                            totalPrice = numberWithCommas(value.GoodsRecommPriceVAT * value.Qty);
                        }
                        else {
                            totalPrice = numberWithCommas(value.GoodsRecommPrice * value.Qty);
                        }
                        listTag += "<td class='txt-center'>" + totalPrice + "원</td>";

                        listTag += "</tr>";
                    });

                    $("#tblPopupGoodsRecomm_tbody").empty().append(listTag);

                } else {
                    var emptyTag = "<tr><td colspan='9' class='txt-center'>조회된 데이터가 없습니다.</td></tr>";
                    $("#tblPopupGoodsRecomm_tbody").empty().append(emptyTag);
                }
                return false;
            };

            var param = {
                Code: code,
                Method: 'GetGoodsRecommDetailList'
            };

            var complete = function () {

                fnOpenDivLayerPopup('detailViewDiv');
            };

            JqueryAjax('Post', '../../Handler/GoodsRecommHandler.ashx', true, false, param, 'json', callback, null, complete, true, '<%=Svid_User%>');


        }

        var is_sending = false;
        function fnAddCart() {

            var selectLength = $('#tblPopupGoodsRecomm_tbody input[type="checkbox"]:checked').length;
            if (selectLength < 1) {
                alert('상품을 선택해 주세요');
                return false;

            }

            var callback = function (response) {
                if (response.Result == "OK") {

                    if (confirm('장바구니에 담겼습니다. 장바구니 메뉴로 이동하시겠습니까?')) {

                        location.href = '/Cart/CartList.aspx';
                    }

                }
                else {
                    alert('시스템 오류입니다. 관리자에게 문의하세요.');
                }
                return false;

            };


            var categoryCodeArray = '';
            var goodsGroupCodeArray = '';
            var codeArray = '';
            var qtyArray = '';
            $('#tblPopupGoodsRecomm_tbody input[type="checkbox"]').each(function () {
                if ($(this).prop('checked') == true) {
                    var goodsCode = $(this).parent().parent().children().find('#hdPopupGoodsCode').val();
                    var goodsGroupCode = $(this).parent().parent().children().find('#hdPopupGroupCode').val();
                    var categoryCode = $(this).parent().parent().children().find('#hdPopupCategoryCode').val();
                    var qty = $(this).parent().parent().children().find('#hdPopupQty').val();
                    categoryCodeArray += categoryCode + '/';
                    goodsGroupCodeArray += goodsGroupCode + '/';
                    codeArray += goodsCode + '/';
                    qtyArray += qty + '/';
                }
            });

            var param = {
                SvidUser: '<%= Svid_User%>',
                GoodsFinCtgrCodes: categoryCodeArray.slice(0, -1),
                GoodsGrpCodes: goodsGroupCodeArray.slice(0, -1),
                GoodsCodes: codeArray.slice(0, -1),
                RecommCode: $('#hdPopupGoodsRecommCode').val(),
                Qtys: qtyArray.slice(0, -1),
                Flag: 'MultiSaveCartByWishList'
            };

            var beforeSend = function () {
                is_sending = true;
            }
            var complete = function () {
                is_sending = false;
            }

            if (is_sending) return false;
            JqueryAjax('Post', '../../Handler/CartHandler.ashx', true, false, param, 'json', callback, beforeSend, complete, true, '<%=Svid_User%>');
            return false;
        }

        // 관심상품 담기
        function fnAddWish() {
            var selectLength = $('#tblPopupGoodsRecomm_tbody input[type="checkbox"]:checked').length;
            if (selectLength < 1) {
                alert('상품을 선택해 주세요');
                return false;

            }
            var callback = function (response) {

                if (response.Result == "OK") {

                    if (confirm('관심상품에 담겼습니다. 관심상품 메뉴로 이동하시겠습니까?')) {

                        location.href = '/Wish/WishList.aspx';
                    }

                }
                else {
                    alert('시스템 오류입니다. 관리자에게 문의하세요.');
                }
                return false;
            };

            var categoryCodeArray = '';
            var goodsGroupCodeArray = '';
            var codeArray = '';
            $('#tblPopupGoodsRecomm_tbody input[type="checkbox"]').each(function () {
                if ($(this).prop('checked') == true) {
                    var goodsCode = $(this).parent().parent().children().find('#hdPopupGoodsCode').val();
                    var goodsGroupCode = $(this).parent().parent().children().find('#hdPopupGroupCode').val();
                    var categoryCode = $(this).parent().parent().children().find('#hdPopupCategoryCode').val();
                    categoryCodeArray += categoryCode + '/';
                    goodsGroupCodeArray += goodsGroupCode + '/';
                    codeArray += goodsCode + '/';
                }
            });
            var param = {
                Type: 'MultiSaveWishListByCart',
                SvidUser: '<%= Svid_User%>',
                GoodsFinCtgrCodes: categoryCodeArray.slice(0, -1),
                GoodsGrpCodes: goodsGroupCodeArray.slice(0, -1),
                GoodsCodes: codeArray.slice(0, -1),
            };

            var beforeSend = function () {
                is_sending = true;
            }
            var complete = function () {
                is_sending = false;
            }

            if (is_sending) return false;
            JqueryAjax('Post', '../../Handler/WishHandler.ashx', true, false, param, 'json', callback, beforeSend, complete, true, '<%=Svid_User%>');

            return false;
        }

        // 주문하기
        function fnOrder() {
            var selectLength = $('#tblPopupGoodsRecomm_tbody input[type="checkbox"]:checked').length;
            if (selectLength < 1) {
                alert('상품을 선택해 주세요');
                return false;

            }
            var callback = function (response) {
                if (response == "Success") {
                    var url = '';
                    var svidRole = '<%= UserInfoObject.Svid_Role%>';
                    switch (svidRole) {

                        case 'A1':
                            url = '../Order/OrderList.aspx';
                            break;
                        case 'B2':
                        case 'BC3':
                            url = '../Order/OrderList_Type2.aspx';
                            break;
                        case 'C2':
                        case 'BC2':
                            url = '../Order/OrderList_Type3.aspx';
                            break;
                        default:
                            url = '../Order/OrderList.aspx';
                            break;
                    }


                    location.href = url;

                }
                else {
                    alert('시스템 오류입니다. 관리자에게 문의하세요.');
                }
                return false;
            };

            var categoryCodeArray = '';
            var goodsGroupCodeArray = '';
            var codeArray = '';
            var qtyArray = '';
            var priceVatArray = '';
            var priceArray = '';
            $('#tblPopupGoodsRecomm_tbody input[type="checkbox"]').each(function () {
                if ($(this).prop('checked') == true) {
                    var goodsCode = $(this).parent().parent().children().find('#hdPopupGoodsCode').val();
                    var goodsGroupCode = $(this).parent().parent().children().find('#hdPopupGroupCode').val();
                    var categoryCode = $(this).parent().parent().children().find('#hdPopupCategoryCode').val();
                    var qty = $(this).parent().parent().children().find('#hdPopupQty').val();
                    var priceVat = $(this).parent().parent().children().find('#hdPopupPriceVat').val();
                    var price = $(this).parent().parent().children().find('#hdPopupPrice').val();
                    categoryCodeArray += categoryCode + ',';
                    goodsGroupCodeArray += goodsGroupCode + ',';
                    codeArray += goodsCode + ',';
                    qtyArray += qty + ',';
                    priceVatArray += priceVat + ',';
                    priceArray += price + ',';
                }
            });

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
                Method: 'OrderByGoodsRecomm',
                SvidUser: '<%= Svid_User%>',
                GoodsFinCtgrCodes: categoryCodeArray.slice(0, -1),
                GoodsGrpCodes: goodsGroupCodeArray.slice(0, -1),
                GoodsCodes: codeArray.slice(0, -1),
                QTYs: qtyArray.slice(0, -1),
                PriceVats: priceVatArray.slice(0, -1),
                Prices: priceArray.slice(0, -1),
                CompCode: compcode,
                SaleCompCode: saleCompCode,
                DongshinCheck: '<%= UserInfoObject.UserInfo.BmroCheck%>',
                FreeCompanyYN: '<%= UserInfoObject.UserInfo.FreeCompanyYN.AsText("N")%>',
            };

            var beforeSend = function () {
                is_sending = true;
            }
            var complete = function () {
                is_sending = false;
            }

            if (is_sending) return false;
            JqueryAjax('Post', '../../Handler/GoodsRecommHandler.ashx', true, false, param, 'text', callback, beforeSend, complete, true, '<%=Svid_User%>');

            return false;
        }

        //전체선택
        function fnSelectAll(el) {
            if ($(el).prop("checked")) {
                $("input[id^='cbPopupItemSelect']").not(":disabled").prop("checked", true);
            }
            else {
                $("input[id^='cbPopupItemSelect']").not(":disabled").prop("checked", false);
            }
        }

        //파일다운로드
        function fnFileDownload(el) {

            var hdFilePath = $(el).parent().parent().find("input:hidden[id=hdFilePath]").val();
            var hdFileName = $(el).parent().parent().find("input:hidden[id=hdFileName]").val();
            window.location = '/Order/FileDownload.aspx?FilePath=' + hdFilePath + '&FileName=' + hdFileName;
            return false;

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
            <%--제목타이틀--%>
            <div class="sub-title-div">
                <img src="/images/GoodsRecommListSearch_nam.png" />
               <%-- <p class="p-title-mainsentence">
                    견적상품게시판
                </p>--%>
            </div>
           
            <%--<div class="div-main-tab" style="width: 100%; ">
            <ul>
                <li  class='tabOff' style="width: 185px;" onclick="location.href='/Order/QuickOrderMain.aspx'">
                    <a href="/Order/QuickOrderMain.aspx" >간편주문</a>
                </li>
                <li  class='tabOn' style="width: 185px;" onclick="location.href='GoodsRecommListSearch.aspx'">
                    <a href="GoodsRecommListSearch.aspx" >MD 추천상품</a>
                 </li>
            </ul>--%>

            <div class="search-div">
                <table class="tbl_search" id="tblSearchList">
                    <thead>
                    </thead>
                    <tr>
                        <th class="border-right">주문일</th>
                        <td style="width: 650px;" colspan="3" class="align-left">
                            <asp:TextBox ID="txtSearchSdate" type="date" runat="server" MaxLength="10" CssClass="calendar" style="margin-right:3px;" onkeypress="return fnEnterDate();" placeholder="2018-01-01" ReadOnly="true"></asp:TextBox>
                            -
                            <asp:TextBox ID="txtSearchEdate" type="date" runat="server" MaxLength="10" CssClass="calendar" style="margin-right:3px;" onkeypress="return fnEnterDate();" placeholder="2018-12-30" ReadOnly="true"></asp:TextBox>
                            &nbsp;&nbsp;&nbsp;
                            <input type="checkbox" style="vertical-align:middle; margin-left:5px;" name="chkBox" id="ckbSearch1" value="1"  /><label for="ckbSearch1">1일</label>
                            <input type="checkbox" style="vertical-align:middle; margin-left:5px;" name="chkBox" id="ckbSearch2" value="7" checked="checked"><label for="ckbSearch2">7일</label>
                            <input type="checkbox" style="vertical-align:middle; margin-left:5px;" name="chkBox" id="ckbSearch3" value="15" /><label for="ckbSearch3">15일</label>
                            <input type="checkbox" style="vertical-align:middle; margin-left:5px;" name="chkBox" id="ckbSearch4" value="30" /><label for="ckbSearch4">30일</label>
                            <input type="checkbox" style="vertical-align:middle; margin-left:5px;" name="chkBox" id="ckbSearch5" value="90" /><label for="ckbSearch5">90일</label>
                            <input type="checkbox" style="vertical-align:middle; margin-left:5px;" name="chkBox" id="ckbSearch6" value="0" /><label for="ckbSearch6">직접입력</label>

                        </td>

                    </tr>
                    <tr>
                        <th class="border-right">제목 검색</th>
                        <td colspan="3">
                            <asp:TextBox runat="server" CssClass="input-drop" ID="txtSubject" onkeypress="return fnEnter();" Width="100%"></asp:TextBox></td>

                    </tr>
                    <tr>
                        <th class="border-right">담당자 검색</th>
                        <td class="border-right">
                            <asp:TextBox runat="server" CssClass="input-drop" ID="txtAdminName" onkeypress="return fnEnter();" Width="100%"></asp:TextBox></td>
                        <th class="border-right">추천번호 검색
                        </th>
                        <td>
                            <asp:TextBox runat="server" CssClass="input-drop" ID="txtRecommNum" onkeypress="return fnEnter();" Width="100%"></asp:TextBox>
                        </td>

                    </tr>
                </table>
            </div>

            <div style="float: right; margin-bottom: 50px; margin-top: 20px;">
                <input type="button"  class="mainbtn type1" style="width:95px; height:30px; font-size:12px;" value="조회하기" onclick="fnSearch(1); return false;"/>
                <%--<input type="button" class="commonBtn" style="width: 95px; height: 30px; font-size: 12px" value="조회하기" onclick="fnSearch(1); return false;" />--%>
            </div>


            <div class="list-div" style="margin-top: 10px !important">
                <table  class="tbl_main">
                    <thead>

                        <tr>
                            <th style="width:80px; display:none">선택</th>
                            <th style="width:80px">번호</th>
                            <th style="width:80px">일자</th>
                            <th style="width:150px">추천번호</th>
                            <th style="width:200px">제목</th>
                            <th style="width:250px">상품</th>
                            <th style="width:80px">담당자</th>
                            <th style="width:80px">확인여부</th>
                            <th style="width:100px">팝업보기</th>
                        </tr>
                    </thead>
                    <tbody id="tblItem_tbody">
                        <tr id="emptyRow">
                            <td colspan="8" style="text-align: center">조회된 내역이 없습니다.
                            </td>
                        </tr>
                    </tbody>
                </table>
                <div style="margin: 0 auto; text-align: center; padding-top: 10px">
                <input type="hidden" id="hdItemTotalCount" />
                <div id="itemPagination" class="page_curl" style="display: inline-block"></div>
            </div>
            </div>
            <div class="left-menu-wrap" id="divLeftMenu">
                    <dl>
                        <dt>
                            <strong>주문정보</strong>
                        </dt>
                        <dd>
                            <a href="/Cart/CartList.aspx">장바구니</a>
                        </dd>
                        <dd >
                            <a href="/Wish/WishList.aspx">위시상품 리스트</a>
                        </dd>
                        <dd class="active">
                            <a href="/Goods/GoodsRecommListSearch.aspx">견적상품게시판</a>
                        </dd>
                        <dd>
                            <a href="/Goods/NewGoodsRequestMain.aspx">신규견적요청</a>
                        </dd>
                    </dl>
            </div>
        </div>
    </div>
    <!--엑셀 저장-->
    <div class="bt-align-div">
        <%--<asp:ImageButton AlternateText="엑셀저장" runat="server" ImageUrl="../../Images/Cart/excel-off.jpg" onmouseover="this.src='../../Images/Cart/excel-on.jpg'" onmouseout="this.src='../../Images/Cart/excel-off.jpg'" />--%>
    </div>

    <%--견적상품 상세 팝업--%>
    <div id="detailViewDiv" class="popupdiv divpopup-layer-package">
        <div class="popupdivWrapper" style="width: 85%; height: 800px; margin:30px auto">
            <div class="popupdivContents">

                <div class="close-div">
                    <a onclick="fnClosePopup('detailViewDiv'); return false;" style="cursor: pointer">
                        <img src="../../Images/Wish/icon-delete.jpg" alt="닫기" style="float: right;" /></a>
                </div>
                <div id="popupTitle">
                    <%--<h3>견적상품</h3>--%>
                </div>
                <div class="divpopup-layer-conts">
                    <input type="hidden" id="hdPopupGoodsRecommCode" />
                    <table class="tbl_popup" style="margin-top: 0; width: 100%">
                        <tbody id="fileAdd">

                        </tbody>
                        <%--<tr>
                            <th>
                                제목
                            </th>
                            <td>
                                <input type="text" id="txtPopupSubject" style="width: 100%;background-color:transparent;border:0 solid black;" readonly /> 
                            </td>
                        </tr>
                        <tr>
                            <th>
                                상세사항
                            </th>
                            <td>
                                 <textarea style="width: 100%;background-color:transparent;border:0 solid black;resize: none;" id="txtPopupContent" rows="5" readonly></textarea>
                            </td>
                        </tr>--%>
                    </table>
                    <div  style="height: 485px; width: 100%; overflow-y: auto; overflow-x: hidden; margin-top: 10px; ">
                        <table class="tbl_popup" style="width: 100%">
                            <thead>
                                <tr>
                                    <th class="text-center" style="width:30px"><input type="checkbox" id="selectAllItem" checked="checked" onclick="fnSelectAll(this);"/ ></th>
                                   <th class="text-center" style="width:40px">번호</th>
                                    <th class="text-center" style="width:330px">상품정보</th>
                                    <th class="text-center" style="width:100px">모델명</th>
                                    <th class="text-center" style="width:80px">단위</th>
                                    <th class="text-center" style="width:90px">상품가격<br />
                                        <span id="vatChk"></span></th>
                                    <th class="text-center" style="width:60px">수량</th>
                                    <th class="text-center" style="width:90px">합계금액<br />
                                        <span id="totalVatChk"></span></th>
                                </tr>
                            </thead>
                            <tbody id="tblPopupGoodsRecomm_tbody">
                                <tr>
                                    <td colspan="7" class="text-center">리스트가 없습니다.</td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>

                <div id="popupButton" style="text-align: right; margin-top: 18px;">
                    <input type="button" id="addCart" class="mainbtn type1" style="width:95px; height:30px; font-size:12px;" value="장바구니 담기" onclick="fnAddCart(); return false;"/>
                    <%--<input type="button" id="addWish" class="mainbtn type1" style="width:95px; height:30px; font-size:12px;" value="관심상품 저장" onclick="fnAddWish(); return false;"/>--%>
                    <input type="button" id="btnOrder" class="mainbtn type1" style="display:none; width:95px; height:30px; font-size:12px;" value="바로 구매" onclick="fnOrder(); return false;"/>
                    <input type="button" class="mainbtn type1" style="width:95px; height:30px; font-size:12px;" value="닫기" onclick="fnClosePopup('detailViewDiv'); return false;"/>
                </div>

            </div>
        </div>
    </div>
</asp:Content>

