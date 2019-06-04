<%@ Page Title="" Language="C#" MasterPageFile="~/Master/Default.master" AutoEventWireup="true" CodeFile="WishList.aspx.cs" Inherits="Wish_WishList" %>

<%@ Register Src="~/UserControl/ucListControl.ascx" TagName="ListPager" TagPrefix="ucPager" %>
<%@ Import Namespace="Urian.Core" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <link href="../Content/Wish/wish.css" rel="stylesheet" />
    <style>
        .ui-tooltip {
            padding: 0;
            max-width: 600px;
        }

        .currentPay {
            font-weight: bold;
            color: red
        }
    </style>

    <script type="text/javascript">
        var compcode = '';
        var saleCompcode = '';
        $(function () {
            //인증마크
            SetCertifyImageSet();
            var checkCnt = 0;
            //처음부터 체크박스 전체 선택되게..
            $('#tblWishList input[type="checkbox"]').each(function () {
                $(this).prop('checked', 'checked');

                if (!isEmpty($(this).parent().find("input:hidden[name='hdGdsDisplayRs']").val())) {
                    $(this).prop("checked", false);
                    $(this).prop("disabled", true);
                }

                ++checkCnt;
            });

            AllCheckbox();

            var tableid = 'tblWishGroupList';
            ListCheckboxOnlyOne(tableid); //체크박스 하나만 체크되게..

            $('#tblWishList input[type="checkbox"]').change(function () {
                var check = false;
                var checkCnt = 0;
                $('#tblWishList tbody tr').each(function (index, element) {
                    if ($(element).find("input[type = checkbox]").prop('checked') == true) {
                        ++checkCnt;
                    } else {
                        check = true;
                    }
                });

                if (check == false) {
                    $("#checkAll").prop('checked', 'checked');
                }

            });

            if (!isEmpty('<%= UserInfoObject.UserInfo.PriceCompCode%>')) {
                compcode = '<%= UserInfoObject.UserInfo.PriceCompCode%>'
            }
            else {
                compcode = 'EMPTY'
            }

            if (!isEmpty('<%= UserInfoObject.UserInfo.SaleCompCode%>')) {
                saleCompcode = '<%= UserInfoObject.UserInfo.SaleCompCode%>'
            }
            else {
                saleCompcode = 'EMPTY'
            }


            $(".input-arrow-up").on("click", function () {
                var moq = parseInt($(this).parent().parent().parent().children().find('#hdMoq').val());
                $(this).parent().find('input[id*="txtQty"]').val(parseInt($(this).parent().find('input[id*="txtQty"]').val()) + moq);

                var pricevat = $(this).parent().parent().parent().children().find('#hdPriceVat').val();
                var qty = $(this).parent().find('input[id*="txtQty"]').val();
                $(this).parent().parent().parent().children().find('#spanPriceVat').text(numberWithCommas(pricevat * qty));

            });
            $(".input-arrow-down").on("click", function () {
                var moq = parseInt($(this).parent().parent().parent().children().find('#hdMoq').val());
                if (parseInt($(this).parent().find('input[id*="txtQty"]').val()) - moq <= 0) {
                    alert('수량이 0보다 작거나 같을 수 없습니다.');
                }
                else {
                    $(this).parent().find('input[id*="txtQty"]').val(parseInt($(this).parent().find('input[id*="txtQty"]').val()) - moq);
                    var pricevat = $(this).parent().parent().parent().children().find('#hdPriceVat').val();
                    var qty = $(this).parent().find('input[id*="txtQty"]').val();
                    $(this).parent().parent().parent().children().find('#spanPriceVat').text(numberWithCommas(pricevat * qty));
                }

            });

            $('input[id*="txtQty"]').blur(function () {
                var moq = parseInt($(this).parent().parent().parent().children().find('#hdMoq').val());
                var val = parseInt($(this).val()) % moq;


                if (parseInt($(this).val()) <= 0) {
                    alert('수량이 0보다 작거나 같을 수 없습니다.');
                    $(this).val(moq);

                }
                if (val != 0) {
                    alert('본 상품은 최소구매수량 단위로 구매가 가능합니다. ');
                    $(this).val(moq);
                }

                var pricevat = $(this).parent().parent().parent().children().find('#hdPriceVat').val();
                var qty = $(this).val();
                $(this).parent().parent().parent().children().find('#spanPriceVat').text(numberWithCommas(pricevat * qty));
            });
        });

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

        //체크박스 전체 선택
        function AllCheckbox() {
            $("#checkAll").change(function () {
                if ($("#checkAll").is(":checked")) { //체크박스 선택
                    $('#tblWishList input[type="checkbox"]').each(function () {
                        $(this).prop('checked', 'checked');

                        if (!isEmpty($(this).parent().find("input:hidden[name='hdGdsDisplayRs']").val())) {
                            $(this).prop("checked", false);
                            $(this).prop("disabled", true);
                        }
                    });
                } else {
                    $('#tblWishList input[type="checkbox"]').each(function () {
                        $(this).prop('checked', '');
                    });
                }
            });
        }

        //체크박스 하나라도 체크지울경우 처리
        function fnChangeCheck(index) {
            if ($(index).is(":checked") == false) {
                $("#checkAll").prop('checked', ''); //전체선택 박스 체크해제
            }
        }

        function fnAddPopupOpen() {
            $('#tblWishGroupList input[type="checkbox"]').removeAttr('checked');//체크박스 클리어
            var selectLength = $('#tblWishList input[type="checkbox"]:checked').length;
            if (selectLength < 1) {
                alert('상품을 선택해 주세요.');
                return false;
            }
            else {
                fnOpenDivLayerPopup('divpopupGroupPackage');

            }

        }

        function fnDeleteConfirm() {
            var selectLength = $('#tblWishList input[type="checkbox"]:checked').length;
            if (selectLength < 1) {
                alert('상품을 선택해 주세요.');
                return false;
            }

            if (!confirm('삭제하시겠습니까?')) {
                return false;
            }
            return true;
        }

        function fnCancel() {
            $('.divpopup-layer-package').fadeOut();
            return false;
        }

        //popup창 등록버튼
        function fnAddWishList() {

            var selectLength = $('#tblWishGroupList input[type="checkbox"]:checked').length;
            if (selectLength < 1) {
                alert('보관함을 선택해 주세요.');
                return false;
            }
            var wishgroupSeq = $('#tblWishGroupList tr').filter(':has(:checkbox:checked)').find('input:hidden[id$=hdWishGroupSeq]').val();
            $('#<%= hfWishGroupSeq.ClientID%>').val(wishgroupSeq);
            return true;
        }

        //상품코드 클릭시 디테일뷰
        function fnGoodsDetailView(goodsCode) {

            var callback = function (value) {
                var moq = 0;
                if (value != null) {
                    $('#p_GoodsPriceVat').empty();
                    var src = '/GoodsImage' + '/' + value.GoodsFinalCategoryCode + '/' + value.GoodsGroupCode + '/' + value.GoodsCode + '/' + value.GoodsFinalCategoryCode + '-' + value.GoodsGroupCode + '-' + value.GoodsCode + '-fff.jpg';
                    $('#imgGoodsDetail').attr('src', src);
                    $('#p_GoodsName').text(value.GoodsFinalName);
                    $('#p_GoodsCode').text(value.GoodsCode);
                    $('#p_GoodsInfo').html('[' + value.BrandName + ']' + value.GoodsFinalName + '<br/>' + value.GoodsOptionSummaryValues);
                    $('#p_GoodsModel').text(value.GoodsModel);
                    $('#p_GoodsOrigin').text(value.GoodsOriginName);
                    $('#p_GoodsUnit').text(value.GoodsUnitName);
                    $('#p_GoodsDueName').text(value.GoodsDeliveryOrderDue_Name);
                    $('#p_moq').text(value.GoodsUnitMoq);
                    $('#txtPopupQty').val(value.GoodsUnitMoq);
                    $('#hdGoodUnitMoq').val(value.GoodsUnitMoq);
                    moq = value.GoodsUnitMoq;

                    var svidUser = '<%= Svid_User%>';
                    var svidRole = '<%= UserInfoObject.Svid_Role%>';
                    var price = '';
                    var priceHtml = '';
                    if (svidUser == '' || svidRole == 'T' || userId == 'socialwith') {
                        price = '(회원전용)';
                        priceHtml = '<span>' + price + '</span>';
                    }
                    else {
                        price = numberWithCommas(value.GoodsSalePriceVat) + '원';

                        if (isEmpty(value.GoodsDCPriceVat)) {
                            priceHtml = '<span>' + price + '</span>';
                        }
                        else {
                            priceHtml = '<span style="text-decoration: line-through;">' + price + '</span>&nbsp;&nbsp;<span style="color:black;">' + numberWithCommas(value.GoodsDCPriceVat) + '원</span>';
                        }
                    }

                    $('#p_GoodsPriceVat').append(priceHtml);
                    $('#hdPopupCategoryCode').val(value.GoodsFinalCategoryCode);
                    $('#hdPopupGoodsGroupCode').val(value.GoodsGroupCode);
                    $('#hdPopupGoodsCode').val(value.GoodsCode);

                    var taxYn = value.GoodsSaleTaxYN;
                    var freeCompVatYN = '<%= UserInfoObject.UserInfo.FreeCompanyVATYN.AsText("N")%>';
                    var taxTag = "(VAT포함)";
                    if (freeCompVatYN == 'N') {
                        taxTag = "(VAT별도)";
                    }
                    if (taxYn == "2") {
                        taxTag = "(면세)";
                    }
                    $('#spPopGdsSale').text(taxTag);

                    var sessionValue = '<%=Svid_User%>'
                    if (sessionValue != "" && sessionValue != null) {
                        $('#trPopupCart').css('display', '');
                    }

                    fnOpenDivLayerPopup('productCodeDiv');
                    
                    return false;
                }
            }
            var param = { Method: 'GetGoodsDetailView', CompCode: compcode, SaleCompCode: saleCompcode, GoodsCode: goodsCode, DongshinCheck: '<%= UserInfoObject.UserInfo.BmroCheck%>', FreeCompanyYN: '<%= UserInfoObject.UserInfo.FreeCompanyYN%>' };

            Jajax('Post', '../../Handler/GoodsHandler.ashx', param, 'json', callback);
        }

        function fnPopupArrowClick(type) {


            var moq = parseInt($('#hdGoodUnitMoq').val());

            if (type == 'Up') {
                $('#txtPopupQty').val(parseInt($('#txtPopupQty').val()) + moq);
            }
            else if (type == 'Down') {
                if (parseInt($('#txtPopupQty').val()) - moq <= 0) {
                    alert('수량이 0보다 작거나 같을 수 없습니다.');
                }
                else {
                    $('#txtPopupQty').val(parseInt($('#txtPopupQty').val()) - moq);
                }
            }
        }

        function fnPopupTextboxBlur(el) {
            var moq = parseInt($('#hdGoodUnitMoq').val());
            var val = parseInt($(el).val()) % moq;


            if (parseInt($(el).val()) <= 0) {
                alert('수량이 0보다 작거나 같을 수 없습니다.');
                $('#txtPopupQty').val(moq);
            }
            if (val != 0) {
                alert('본 상품은 최소구매수량 단위로 구매가 가능합니다. ');
                $('#txtPopupQty').val(moq);
            }
        }

        function fnClosePopup() {
            $('.divpopup-layer-package').fadeOut();
        }

        var is_sending = false;
        //팝업 장바구니 담기
        function fnPopupCartAdd() {


            var role = '<%= UserInfoObject.Svid_Role%>';
            if (role == 'C1' || role == 'BC1') {
                alert('권한이 없습니다.')
                return false;
            }

            if ($('#txtPopupQty').val() < 1) {
                alert('수량을 확인해 주세요.');
                $('#txtPopupQty').focus();
                return false;
            }

            var callback = function (response) {
                if (!isEmpty(response)) {
                    $.each(response, function (key, value) {
                        if (value == "OK") {
                            alert('장바구니에 담겼습니다.');
                            location.href = '../../Cart/CartList.aspx';
                            return false;

                        }
                    });
                }
                return false;
            };
            var param = {
                SvidUser: '<%= Svid_User%>',
                GoodsFinCtgrCode: $('#hdPopupCategoryCode').val(),
                GoodsGrpCode: $('#hdPopupGoodsGroupCode').val(),
                GoodsCode: $('#hdPopupGoodsCode').val(),
                QTY: $('#txtPopupQty').val(),
                Memo: '',
                Flag: 'Add'
            };

            var beforeSend = function () {
                is_sending = true;
            }
            var complete = function () {
                is_sending = false;
            }

            if (is_sending) return false;

            JajaxDuplicationCheck('Post', '../Handler/CartHandler.ashx', param, 'json', callback, beforeSend, complete, true, '<%=Svid_User%>');
            return false;
        }

        function fnGoCart() {

            location.href = '../../Cart/CartList.aspx';
            return false;
        }

        function fnCartPopupClose() {
            $('.divpopup-layer-package').fadeOut();
        }

        var is_sending1 = false;
        function fnAddCart() {

            if (userId == 'socialwith') {
                alert('게스트 계정은 이용할 수 없습니다.');
                return false;
            }

            var selectLength = $('#tblWishList input[type="checkbox"]:checked').length;
            if (selectLength < 1) {
                alert('상품을 선택해 주세요');
                return false;

            }

            var zeroFlag = true;

            $('#tblWishList input[type="checkbox"]').each(function () {
                if ($(this).prop('checked') == true) {

                    var qty = $(this).parent().parent().children().find('input[id*="txtQty"]').val();
                    if (qty < 1) {
                        zeroFlag = false;
                    }
                }
            });

            if (zeroFlag == false) {
                alert('수량이 0인 상품이 있습니다.');
                return false;
            }

            var callback = function (response) {
                if (!isEmpty(response)) {
                    $.each(response, function (key, value) {
                        if (value == "OK") {

                            var e = document.getElementById('cartDiv');

                            if (e.style.display == 'block') {
                                e.style.display = 'none';

                            } else {
                                e.style.display = 'block';
                            }
                            return false;
                        }
                    });
                }
                return false;
            };


            var categoryCodeArray = '';
            var goodsGroupCodeArray = '';
            var codeArray = '';
            var qtyArray = '';
            $('#tblWishList input[type="checkbox"]').not(':first').each(function () {
                if ($(this).prop('checked') == true) {
                    var goodsCode = $(this).parent().parent().children().find('#hdGoodsCode').val();
                    var goodsGroupCode = $(this).parent().parent().children().find('#hdGroupCode').val();
                    var categoryCode = $(this).parent().parent().children().find('#hdCategoryCode').val();
                    var qty = $(this).parent().parent().children().find('input[id*="txtQty"]').val();
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
                Qtys: qtyArray.slice(0, -1),
                RecommCode: '',
                Flag: 'MultiSaveCartByWishList'
            };

            var beforeSend = function () {
                is_sending1 = true;
            }
            var complete = function () {
                is_sending1 = false;
            }

            if (is_sending1) return false;

            JajaxDuplicationCheck('Post', '../Handler/CartHandler.ashx', param, 'json', callback, beforeSend, complete, true, '<%=Svid_User%>');
            return false;
        }

        function fnOrderConfirm() {

            var selectLength = $('#tblWishList input[type="checkbox"]:checked').length;
            if (selectLength < 1) {
                alert('상품을 선택해 주세요.');
                return false;
            }

            var zeroFlag = true;

            $('#tblWishList input[type="checkbox"]').each(function () {
                if ($(this).prop('checked') == true) {

                    var qty = $(this).parent().parent().children().find('input[id*="txtQty"]').val();
                    if (qty < 1) {
                        zeroFlag = false;
                    }
                }
            });

            if (zeroFlag == false) {
                alert('수량이 0인 상품이 있습니다.');
                return false;
            }
        }
        //합계금액 계산
        function fnCalTotalVat(el) {

            var pricevat = $(el).parent().parent().children().find('#hdPriceVat').val();
            var qty = $(el).val();
            $(el).parent().parent().children().find('#spanPriceVat').text(numberWithCommas(pricevat * qty));
            return false;
        }

    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div class="sub-contents-div">
            <div style="text-align:left;" class="sub-title-div">
                <img src="/images/wish_.png"/>
                <p class="p-title-mainsentence">
                   <%-- 위시상품 리스트 
                    <span class="span-title-subsentence">내가 찜한 상품을 한눈에 조회할 수 있습니다.</span>--%>
                </p>
            </div>
            <div class="div-main-tab">
                <ul>
                    <li class='tabOn' onclick="location.href='NewGoodsRequestMain.aspx'">
                        <a href="../Wish/WishList.aspx" style="display: block">위시상품 리스트</a>
                    </li>
                    <li class='tabOff' onclick="location.href='NewGoodsRequestList.aspx'">
                        <a href="../Wish/WishGroupList.aspx" style="display: block">위시상품 분류함</a>
                    </li>
                </ul>
            </div>
            
            <div class="clear"></div>
            <!-- 전체리스트, 삭제, 엑셀, 장바구니담기, 보관함담기-->
            <div class="top-bts" style="margin-bottom: 20px;">
                <asp:DropDownList CssClass="top-bts-drop" ID="ddlWishInfo" runat="server" OnSelectedIndexChanged="ddlWishInfo_SelectedIndexChanged" AutoPostBack="True">
                </asp:DropDownList>
                <asp:Button ID="btnWishDel" runat="server" Text="삭제" style="margin-right:3px;" CssClass="mainbtn type1" Width="117" Height="30" OnClick="btnWishDel_Click" OnClientClick="return fnDeleteConfirm();" />
                <asp:Button ID="btnWishExcel" runat="server" Text="엑셀" style="margin-right:3px;" CssClass="mainbtn type1" Width="117" Height="30" OnClick="btnWishExcel_Click" />
                <asp:Button ID="btnStorage" runat="server" Text="분류함에 담기" style="margin-right:3px;" CssClass="mainbtn type1" Width="117" Height="30" OnClientClick=" fnAddPopupOpen(); return false;" />
                <asp:Button ID="btnCartAdd" runat="server" Text="장바구니담기" style="margin-right:3px;" CssClass="mainbtn type1" Width="117" Height="30" OnClientClick=" fnAddCart(); return false;" />
                <asp:Button ID="btnOrder" runat="server" Text="주문하기" CssClass="mainbtn type2" Width="117" Height="30" OnClientClick="return fnOrderConfirm();" OnClick="btnOrder_Click" Visible="false" />
            </div>
            <div style="float: right; padding-top: 10px; margin-bottom: 10px;">
                <asp:Label ID="lblPayStatus" runat="server" CssClass="currentPay" Style="text-align: right; color:#ee2248;"></asp:Label>
                <br />
                *<b style="color: #ee2248; font-weight: bold;"> VAT(부가세)<%= vatTag %> 가격</b>입니다.

            </div>
            <%--                      <div style="color:#69686d;  float:right; margin-bottom:10px;"> *<b style="color:#ec2029; font-weight:bold;"> VAT(부가세)포함 가격</b>입니다.</div>--%>

            <div>
                <!--데이터 리스트 시작 -->
                <asp:ListView ID="lvWishList" runat="server" ItemPlaceholderID="phItemList" OnItemDataBound="lvWishList_ItemDataBound">
                    <LayoutTemplate>
                        <table id="tblWishList" class="tbl_main">
                            <colgroup class="">
                                <col style="width: 30px" />
                                <col style="width: 100px" />
                                <col style="width: 120px" />
                                <col style="width: 280px" />
                                <col style="width: 120px" />
                                <col style="width: 100px" />
                                <col style="width: 80px" />
                                <col style="width: 120px" />
                                <col style="width: 80px" />
                                <col style="width: 80px" />
                                <col style="width: 100px" />
                            </colgroup>
                            <thead style="height:40px; color:#333333; background-color:#eef7fb; border-top:1px solid #000000;border-bottom:2px solid #aaaaaa;" class="wishlist_nam">
                                <tr>
                                    <th  class="txt-center"><input type="checkbox" id="checkAll" style="" /></th>
                                    <th  class="txt-center">이미지</th>
                                    <th class="txt-center">상품코드</th>
                                    <th class="txt-center">상품정보</th>
                                    <th class="txt-center">모델명</th>
                                    <th class="txt-center">출하예정일</th>
                                    <th class="txt-center">최소수량</th>
                                    <th class="txt-center">내용량</th>
                                    <th class="txt-center">상품가격</th>
                                    <th class="txt-center">수량</th>
                                    <th class="txt-center">합계금액</th>
                                </tr>
                            </thead>
                            <tbody>
                                <asp:PlaceHolder ID="phItemList" runat="server" />
                            </tbody>
                        </table>
                    </LayoutTemplate>
                    <ItemTemplate>
                        <tr>

                            <td class="txt-center" runat="server">
                                <asp:CheckBox runat="server" ID="chSelect" OnClick="javascript:fnChangeCheck(this);" />
                                <asp:HiddenField runat="server" ID="hfWishNum" Value='<%# Eval("UNum_WishList").ToString()%>' />
                                <asp:HiddenField runat="server" ID="hfCategoryCode" Value='<%# Eval("GoodsFinalCategoryCode").ToString()%>' />
                                <asp:HiddenField runat="server" ID="hfGoodsGroupCode" Value='<%# Eval("GoodsGroupCode").ToString()%>' />
                                <asp:HiddenField runat="server" ID="hfGoodsCode" Value='<%# Eval("GoodsCode").ToString()%>' />
                                <input type="hidden" id="hdCategoryCode" value='<%# Eval("GoodsFinalCategoryCode").ToString()%>' />
                                <input type="hidden" id="hdGroupCode" value='<%# Eval("GoodsGroupCode").ToString()%>' />
                                <input type="hidden" id="hdGoodsCode" value='<%# Eval("GoodsCode").ToString()%>' />
                                <input type="hidden" id="hdPriceVat" value='<%# Eval("GoodsDCPriceVat").AsDecimalNullable() != null ? Eval("GoodsDCPriceVat").ToString() : Eval("GoodsSalePriceVat").ToString()%>' />
                                <asp:HiddenField ID="hfGdsTax" runat="server" Value='<%# Eval("GoodsSaleTaxYN").ToString() %>' />
                                <input type="hidden" id="hdMoq" value='<%# Eval("GoodsUnitMoq").ToString()%>' />
                                <input type="hidden" name="hdGdsDisplayRs" value='<%# Eval("GoodsDisplayReason").AsText()%>' />
                            </td>
                            <td class="txt-center" runat="server">
                                <span class="spanCert" id="spanCert<%# Eval("GoodsConfirmMark").AsText() %>" other-title=""><%# !string.IsNullOrWhiteSpace(Eval("GoodsConfirmMark").AsText()) && Eval("GoodsConfirmMark").AsText()!="00000000" ? "*인증상품" : "" %> </span>
                                <asp:Image runat="server" ID="imgGoods" Width="50" Height="50" ImageUrl='<%# String.Format("/GoodsImage/{0}/{1}/{2}/{3}", Eval("GoodsFinalCategoryCode") , Eval("GoodsGroupCode"), Eval("GoodsCode"), string.Format("{0}-{1}-{2}-sss.jpg",Eval("GoodsFinalCategoryCode") , Eval("GoodsGroupCode"), Eval("GoodsCode"))) %>' onerror="this.onload = null; this.src='/Images/noImage_s.jpg';" />

                            </td>
                            <td class="txt-center">
                                <a style="cursor: pointer" onclick='<%# String.Format("javascript:fnGoodsDetailView(\"{0}\");", Eval("GoodsCode")) %>'><%# Eval("GoodsCode").ToString()%></a><br />
                                <asp:Label runat="server" ID="lblGoodsDiplayText" Text='<%# SetGoodsDisplayText(Eval("CompanyGoodsYN").AsText(),Eval("GoodsDisplayReason").AsText()) %>' Font-Bold="true" ForeColor="Red"></asp:Label>
                            </td>
                            <td class="txt-center" style="text-align: left; padding-left: 5px;">
                                <%# "[" + Eval("BrandName").ToString() + "]"%> <%# Eval("GoodsName").ToString()%>
                                <asp:Label runat="server" ID="lblTax" Visible="false"><br />(면세)</asp:Label>
                                <br />
                                <span style='color: #808080; width: 280px; word-wrap: break-word; display: block;'><%# Eval("GoodsSummaryValue").ToString()%></span>
                            </td>
                            <td class="txt-center">
                                <%# Eval("GoodsModel").ToString()%>
                            </td>
                            <td class="txt-center">
                                <%# Eval("GoodsDeliveryOrderDue_Name").ToString()%>
                            </td>
                            <td class="txt-center">
                                <%# Eval("GoodsUnitMoq").ToString()%>
                            </td>
                            <td class="txt-center">
                                <%# Eval("GoodsUnitName").ToString()%>
                            </td>
                            <td style="width: 150px; text-align: right; padding-right: 5px;" id="tdDcPrice" runat="server">
                                <span style="text-decoration: line-through;"><%# String.Format("{0:##,##0;}", Eval("GoodsSalePriceVat")) %>원</span>&nbsp;
                                       <span style="color: red"><%# String.Format("{0:##,##0;}", Eval("GoodsDCPriceVAT")) %>원</span>
                            </td>
                            <td style="width: 90px; text-align: right; padding-right: 5px;" id="tdOriginPrice" runat="server">
                                <span><%# String.Format("{0:##,##0;}", Eval("GoodsSalePriceVat")) %>원</span>
                            </td>
                            <td class="txt-center" style="padding-left: 27px">
                                <span class='input-qty'>
                                    <asp:TextBox runat="server" ID="txtQty" onkeypress="return onlyNumbers(event);" Text='<%# Eval("GoodsUnitMoq").ToString()%>'></asp:TextBox>
                                    <a class='input-arrow-up'>
                                        <img src='../Images/inputarrow_up.png' width='9' height='9' class='imgarrowup' /></a>
                                    <a class='input-arrow-down'>
                                        <img src='../Images/inputarrow_down.png' width='9' height='9' class='imgarrowdown' /></a>
                                </span>
                            </td>
                            <td style="text-align: right; padding-right: 5px;">
                                <span id="spanPriceVat"><%# Eval("GoodsDCPriceVat").AsDecimalNullable() != null ? (Eval("GoodsDCPriceVat").AsDecimal()*Eval("GoodsUnitMoq").AsInt()).ToString("#,###") : (Eval("GoodsSalePriceVat").AsDecimal()*Eval("GoodsUnitMoq").AsInt()).ToString("#,###")%></span>원
                                       <asp:HiddenField runat="server" ID="hfDcPrice" Value='<%#Eval("GoodsDCPriceVAT").AsDecimalNullable() %>' />
                            </td>
                        </tr>
                    </ItemTemplate>
                    <EmptyDataTemplate>
                        <table class="tbl_main">
                            <colgroup class="">
                                <col style="width: 30px" />
                                <col style="width: 100px" />
                                <col style="width: 120px" />
                                <col style="width: 280px" />
                                <col style="width: 120px" />
                                <col style="width: 100px" />
                                <col style="width: 80px" />
                                <col style="width: 120px" />
                                <col style="width: 80px" />
                                <col style="width: 80px" />
                                <col style="width: 100px" />
                            </colgroup>
                            <thead>
                                <tr class="board-tr-height">
                                    <th class="txt-center">
                                        <input type="checkbox" id="checkAll" style="" /></th>
                                    <th class="txt-center">이미지</th>
                                    <th class="txt-center">상품코드</th>
                                    <th class="txt-center">상품정보</th>
                                    <th class="txt-center">모델명</th>
                                    <th class="txt-center">출하예정일</th>
                                    <th class="txt-center">최소수량</th>
                                    <th class="txt-center">내용량</th>
                                    <th class="txt-center">상품가격</th>
                                    <th class="txt-center">수량</th>
                                    <th class="txt-center">합계금액</th>
                                </tr>
                            </thead>
                            <tr class="board-tr-height">
                                <td colspan="11" style="text-align: center;">조회된 데이터가 없습니다.</td>
                            </tr>
                        </table>
                    </EmptyDataTemplate>
                </asp:ListView>

                <asp:HiddenField runat="server" ID="hfWishGroupSeq" />
            </div>
            <br />
            <div style="margin: 0 auto; text-align: center">
                <ucPager:ListPager ID="ucListPager" runat="server" OnPageIndexChange="ucListPager_PageIndexChange" PageSize="20" />
            </div>
            <div class="left-menu-wrap" id="divLeftMenu">
                    <dl>
                        <dt>
                            <strong>주문정보</strong>
                        </dt>
                        <dd>
                            <a href="/Cart/CartList.aspx">장바구니</a>
                        </dd>
                        <dd  class="active">
                            <a href="/Wish/WishList.aspx">위시상품 리스트</a>
                        </dd>
                        <dd>
                            <a href="/Goods/GoodsRecommListSearch.aspx">견적상품게시판</a>
                        </dd>
                        <dd>
                            <a href="/Goods/NewGoodsRequestMain.aspx">신규견적요청</a>
                        </dd>
                    </dl>
            </div>
        </div>

    <div id="divpopupGroupPackage" class="popupdiv divpopup-layer-package">
        <div id="divpopupGroup" class="popupdivWrapper" style="width:60%">
            <div class="popupdivContents">
                    <h3>보관함</h3>

                    <asp:ListView ID="lvPopupList" runat="server" ItemPlaceholderID="phItemList2">

                        <LayoutTemplate>
                            <div id="divpopup-layer-contents" style="">
                                <table id="tblWishGroupList" class="scroll" style="width:100%;">
                                    <colgroup>
                                        <col>
                                        <col>
                                        <col>
                                        <col>
                                        <col>
                                    </colgroup>
                                    <thead>
                                        <tr class="lvPopupList_title">
                                            <th style="width: 30px" class="txt-center">선택</th>
                                            <th style="width: 30px" class="txt-center">번호</th>
                                            <th style="width: 300px" class="txt-center">분류명</th>
                                            <th style="width: 350px" class="txt-center">내용</th>
                                            <th style="width: 70px" class="txt-center">상품수량</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <asp:PlaceHolder ID="phItemList2" runat="server" />
                                    </tbody>
                                </table>
                            </div>
                        </LayoutTemplate>

                        <ItemTemplate>
                            <tr class="board-tr-height">

                                <td style="width: 30px" class="txt-center" runat="server" id="tdCheck" visible='true'>
                                    <asp:CheckBox ID="cbWishRow" runat="server" />
                                    <input type="hidden" value='<%#Eval("UNum_WishListGroup").ToString()%>' id="hdWishGroupSeq" />
                                </td>
                                <td style="width: 30px" class="txt-center">
                                    <%# Container.DataItemIndex + 1%>
                                </td>
                                <td style="width: 300px" class="txt-center" runat="server" id="tdWishGroupName">
                                    <%# Eval("UWishListGroupName").ToString()%>
                                </td>
                                <td style="width: 350px" class="txt-center">
                                    <%# Eval("UWishListGroupContext").ToString()%>
                                </td>
                                <td style="width: 70px" class="txt-center">
                                    <%# Eval("ProductCount").ToString()%>
                                </td>
                            </tr>
                        </ItemTemplate>
                        <EmptyDataTemplate>
                            <table class="tbl_popup">
                                <colgroup>
                                    <col />
                                    <col />
                                    <col />
                                    <col />
                                    <col />
                                </colgroup>
                                <thead>
                                    <tr>

                                        <th class="txt-center">선택</th>
                                        <th class="txt-center">번호</th>
                                        <th class="txt-center">분류명</th>
                                        <th class="txt-center">내용</th>
                                        <th class="txt-center">상품수량</th>
                                    </tr>
                                </thead>
                                <tr>
                                    <td colspan="5" style="text-align: center;">조회된 데이터가 없습니다.</td>
                                </tr>
                            </table>
                        </EmptyDataTemplate>
                    </asp:ListView>
                    <br />
                    <div class="bt">
                        <asp:Button ID="btnCancel" runat="server" Text="취소" CssClass="mainbtn type1" Width="95" Height="30" OnClientClick="return fnCancel();" />
                        <asp:Button ID="btnAddGroup" runat="server" OnClick="btnAddGroup_Click" Text="확인" CssClass="mainbtn type1" Width="95" Height="30" OnClientClick="return fnAddWishList();" />
                        <%-- <asp:ImageButton ID="btnCancel" runat="server" AlternateText=" 취소" OnClientClick="return fnCancel();" ImageUrl="../Images/Wish/cancle-off.jpg" onmouseover="this.src='../Images/Wish/cancle-on.jpg'" onmouseout="this.src='../Images/Wish/cancle-off.jpg'"/>
                        <asp:ImageButton ID="btnAddGroup" runat="server" AlternateText="확인" OnClientClick="return fnAddWishList();" OnClick="btnAddGroup_Click" ImageUrl="../Images/Wish/submit-off.jpg" onmouseover="this.src='../Images/Wish/submit-on.jpg'" onmouseout="this.src='../Images/Wish/submit-off.jpg'"/>--%>
                    </div>
            </div>
        </div>
    </div>

    
    <!--  상품디테일뷰 상품코드 팝업-->

    <div id="productCodeDiv" class="popupdiv divpopup-layer-package">
        <div class="popupdivWrapper" style="width:55%; height: 400px">
            <div class="popupdivContents" >
                    <div style="width: 14px; height: 14px; float: right; margin-top: -10px;">
                        <button type="button" onclick="fnClosePopup(); return false;" class="close-bt">
                            <img src="../Images/Wish/icon-delete.jpg" /></button>
                    </div>

                    <div class="divpopup-layer-conts5">
                        <table style="width: 100%;">
                            <tr>
                                <td style="text-align: left; width: 300px; margin-top: 10px;" rowspan="5">
                                    <img id="imgGoodsDetail" width="300px" height="300px" onerror="this.src='/Images/noImage.jpg'" style="border: 1px solid #a2a2a2" />
                                    <div style="margin-top: 7px;">
                                        <span style="font-size: 12px; padding-left: 10px;">출하예정일 : </span>
                                        <label id="p_GoodsDueName" style="width: 60px; height: 20px; color: #ec2029"></label>
                                    </div>
                                    <div>
                                        <span id="spPopGdsSale" style="font-size: 12px; padding-left: 10px;">판매가(VAT포함) : </span>
                                        <label id="p_GoodsPriceVat" style="width: 170px; height: 20px; color: #ec2029"></label>
                                    </div>
                                </td>
                                <td>
                                    <table style="width: 90%; height: 300px; margin-top: -60px; margin-left: 20px;">


                                        <tr>
                                            <td colspan="2" style="width: 200px; margin-top: -30px; border-bottom: 1px solid #a2a2a2;">
                                                <p id="p_GoodsName" style="font-size: 18px; font-weight: bold; height: 35px; margin-top: 5px;"></p>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td style="width: 100px; height: 30px; background-color: #ececec; border-bottom: 1px solid #a2a2a2;">
                                                <p style="width: 100px; height: 20px; font-weight: bold; text-align: center; margin: auto 0;">상품코드</p>
                                            </td>
                                            <td style="width: 220px; height: 20px; border-bottom: 1px solid #a2a2a2;">
                                                <p id="p_GoodsCode" style="width: 100px; height: 20px; padding-left: 5px; margin: auto 0;"></p>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td style="width: 100px; height: 30px; background-color: #ececec; border-bottom: 1px solid #a2a2a2;">
                                                <p style="width: 100px; height: 20px; font-weight: bold; text-align: center; margin: auto 0;">상품정보</p>
                                            </td>
                                            <td style="width: 100%; height: 20px; border-bottom: 1px solid #a2a2a2;">
                                                <p id="p_GoodsInfo" style="width: 100%; height: auto; padding-left: 5px; margin: auto 0;"></p>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td style="width: 100px; height: 30px; background-color: #ececec; border-bottom: 1px solid #a2a2a2;">
                                                <p style="width: 100px; height: 20px; font-weight: bold; text-align: center; margin: auto 0;">모델명</p>
                                            </td>
                                            <td style="width: 520px; height: 20px; border-bottom: 1px solid #a2a2a2;">
                                                <p id="p_GoodsModel" style="width: 100%; height: 20px; padding-left: 5px; margin: auto 0;"></p>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td style="width: 100px; height: 30px; background-color: #ececec; border-bottom: 1px solid #a2a2a2;">
                                                <p style="width: 100px; height: 20px; font-weight: bold; text-align: center; margin: auto 0;">원산지</p>
                                            </td>
                                            <td style="width: 520px; height: 20px; border-bottom: 1px solid #a2a2a2;">
                                                <p id="p_GoodsOrigin" style="width: 100%; height: 20px; padding-left: 5px; margin: auto 0;"></p>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td style="width: 100px; height: 30px; background-color: #ececec; border-bottom: 1px solid #a2a2a2;">
                                                <p style="width: 100px; height: 20px; font-weight: bold; text-align: center; margin: auto 0;">최소수량</p>
                                            </td>
                                            <td style="width: 520px; height: 20px; border-bottom: 1px solid #a2a2a2;">
                                                <p id="p_moq" style="width: 100%; height: 20px; padding-left: 5px; margin: auto 0;"></p>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td style="width: 100px; height: 30px; background-color: #ececec; border-bottom: 1px solid #a2a2a2;">
                                                <p style="width: 100px; height: 20px; font-weight: bold; text-align: center; margin: auto 0;">내용량</p>
                                            </td>
                                            <td style="width: 520px; height: 20px; border-bottom: 1px solid #a2a2a2;">
                                                <p id="p_GoodsUnit" style="width: 100%; height: 20px; padding-left: 5px; margin: auto 0;"></p>
                                            </td>
                                        </tr>
                                        <tr id="trPopupCart" style="display: none">
                                            <td style="width: 100px; height: 30px; background-color: #ececec; border-bottom: 1px solid #a2a2a2;">
                                                <p style="width: 100px; height: 20px; font-weight: bold; text-align: center; margin: auto 0;">수량</p>
                                            </td>
                                            <td style="width: 520px; height: 20px; padding: 5px 5px; border-bottom: 1px solid #a2a2a2; margin: auto 0;">
                                                <span class='input-qty'>
                                                    <input type='number' id='txtPopupQty' onblur="fnPopupTextboxBlur(this)" oninput='return maxLengthCheck(this)' onkeypress='return onlyNumbers(event);' maxlength='4' />
                                                    <a class='input-arrow-up' id="popupArrowUp" onclick="fnPopupArrowClick('Up'); return false;">
                                                        <img src='../Images/inputarrow_up.png' width='9' height='9' class='imgarrowup' /></a>
                                                    <a class='input-arrow-down' id="popupArrowDown" onclick="fnPopupArrowClick('Down'); return false;">
                                                        <img src='../Images/inputarrow_down.png' width='9' height='9' class='imgarrowdown' /></a>
                                                </span>&nbsp;&nbsp;
                                                <input type="button" class="mainbtn type2" value="장바구니 담기" onclick="fnPopupCartAdd();"/>
                                                <input type="hidden" id="hdPopupCategoryCode" />
                                                <input type="hidden" id="hdPopupGoodsGroupCode" />
                                                <input type="hidden" id="hdPopupGoodsCode" />
                                                <input type="hidden" id="hdGoodUnitMoq" />
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>

                        </table>
                    </div>
            </div>
        </div>
    </div>
    <!--  장바구니담기 모달-->

    <div id="cartDiv" class="popupdiv divpopup-layer-package">
        <div class="popupdivWrapper" style="width: 500px; ">
            <div class="popupdivContents" >
                    <table style="text-align: center; margin: auto; text-align: left">
                        <tr>
                            <td rowspan="2" style="padding-right: 20px;">선택하신 상품이 
                                    <br />
                                <span style="color: red; font-weight: bold">장바구니</span>에 담겼습니다.
                            </td>
                        </tr>

                        <tr>
                            <td>
                                <ul style="list-style: none;">
                                    <li style="padding-bottom: 10px;">
                                        <a class="mainbtn type2" onclick="fnGoCart(); return false;" style="width:110px; text-align:center;">
                                            장바구니 보기</a>
                                    </li>
                                    <li><a class="mainbtn type1" onclick="fnCartPopupClose(); return false;" style="width:110px; text-align:center;">
                                        보관함 보기</a>
                                    </li>
                                </ul>
                            </td>

                        </tr>
                    </table>
            </div>
        </div>
    </div>
</asp:Content>

