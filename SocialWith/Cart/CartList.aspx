<%@ Page Title="" Language="C#" MasterPageFile="~/Master/Default.master" AutoEventWireup="true" CodeFile="CartList.aspx.cs" Inherits="Cart_CartList" %>

<%@ Import Namespace="Urian.Core" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <asp:Literal runat="server" ID="cartCss" EnableViewState="false"></asp:Literal>
    <asp:Literal runat="server" ID="popupCss" EnableViewState="false"></asp:Literal>

    <script type="text/javascript">
        $(document).ready(function () {
            
            var siteName = '<%= SiteName.AsText("socialwith").ToLower()%>';
            var compName = '<%= UserInfoObject.UserInfo.Company_Name%>';
            var compareYN = '<%= UserInfoObject.UserInfo.BPestimateCompareYN.AsText("N")%>';
            if (siteName != 'socialwith' && compName.indexOf('가스') == -1) { //DURI사이트일때만 견적서 출력 보임
                $('#btnTab2').css('display', '');
            }

            if (compareYN == 'N' || compareYN == 'U') {    //로그인 계정의 구매사가 상품비교를 미사용으로 설정(가격비교 사용유무가 N이나 U일때)
                $('#btnOrder').css('display', '');   //주문하기 보임
                 $('#btnGoodsPriceCompare').css('display', 'none'); //가격비교 안보임
            }
            else {
                 $('#btnOrder').css('display', 'none');//주문하기 안보임
                 $('#btnGoodsPriceCompare').css('display', '');//가격비교 보임
            }

            var comloan = '<%= UserInfoObject.UserInfo !=null ? UserInfoObject.UserInfo.CompLoanYN.AsText() : ""%>';
            if (siteName != 'socialwith' && comloan == 'A') { //DURI사이트 && 관공서일때만 추가견적서 출력 보임
                $('#btnTab3').css('display', '');
            }
            var checkCnt = 0;
            var freeCnt = 0;
            //처음부터 체크박스 전체 선택되게..
            $('#tblCart input[type="checkbox"]').each(function () {

                var memo = $(this).parent().find("input[name='hdMemo']").val();
                if (memo == "FD") { //무료배송일 경우
                    $(this).prop('checked', 'checked');

                    $(this).parent().parent().find("span[id*='spFreeDlvr']").text("\n*무료배송*");
                    
                    ++checkCnt;
                    ++freeCnt; //무료배송있는 경우
                    
                } else if (freeCnt === 0) {

                    if ($(this).parent().find('input[id*="hfCompanyGoodsYN"]').val() != 'N' && isEmpty($(this).parent().find('input[id*="hfGoodsDisplayReason"]').val())) {
                        $(this).prop('checked', 'checked');
                        ++checkCnt;
                    }
                }
            });
            $("#lblCheckCnt").text(checkCnt - 1 + "개");
            initialValue();
            AllCheckbox();
            checkRepetition();

            //총주문금액 계산(체크박스 눌렸을때 작동)
            $('#tblCart input[type="checkbox"]').change(function () {
                fnChangeCheck(this);
                
                var sumTotalPrice = 0;
                var check = false;
                var checkCnt = 0;
                $('#tblCart tbody tr').each(function (index, element) {
                    if ($(element).find("input[type = checkbox]").prop('checked') == true) {
                        var qty = $(element).find("input[type = text]").val();//수량
                        var hfGoodsSalePriceVAT = $(element).find("input[type = hidden]").eq(1).val();
                        var sumPrice = hfGoodsSalePriceVAT * qty;
                        sumTotalPrice += sumPrice;
                        ++checkCnt;
                    } else {
                        check = true;
                    }
                });

                if (check == false) {
                    $("#checkAll").prop('checked', 'checked');
                }

                $("#lbTotalCheckPrice").text(numberWithCommas(sumTotalPrice));
                $("#lblCheckCnt").text(checkCnt + "개");
            });


            $(".input-arrow-up").on("click", function () {
                var moq = parseInt($(this).parent().parent().parent().children().find('input[id*="hfMoq"]').val());
                $(this).parent().find('input[id*="txtGoodsNum"]').val(parseInt($(this).parent().find('input[id*="txtGoodsNum"]').val()) + moq);

            });
            $(".input-arrow-down").on("click", function () {
                var moq = parseInt($(this).parent().parent().parent().children().find('input[id*="hfMoq"]').val());
                if (parseInt($(this).parent().find('input[id*="txtGoodsNum"]').val()) - moq <= 0) {
                    alert('수량이 0보다 작거나 같을 수 없습니다.');
                }
                else {
                    $(this).parent().find('input[id*="txtGoodsNum"]').val(parseInt($(this).parent().find('input[id*="txtGoodsNum"]').val()) - moq);
                }

            });

            $('input[id*="txtGoodsNum"]').blur(function () {
                //var qty = parseInt($(this).parent().parent().parent().children().find('#hdQty').val());
                var qty = parseInt($(this).parent().parent().parent().children().find('input[id*="hfQty"]').val());
                //var moq = parseInt($(this).parent().parent().parent().children().find('#hdMoq').val());
                var moq = parseInt($(this).parent().parent().parent().children().find('input[id*="hfMoq"]').val());
                var val = parseInt($(this).val()) % moq;


                if (parseInt($(this).val()) <= 0) {
                    alert('수량이 0보다 작거나 같을 수 없습니다.');
                    $(this).val(qty);

                }
                if (val != 0) {
                    alert('본 상품은 최소구매수량 단위로 구매가 가능합니다. ');
                    $(this).val(qty);
                }
            });


        });

        function fnChangeNum(event) {
            $(event).parent().parent().find("input[type='checkbox']").prop("checked", true);
        }

        //중복제거
        function fnRemoveRepetition(event) {
            var svidUser = '<%= Svid_User%>';
            var callback = function (response) {
            }
            var complFunc = function () {
                window.location.reload(true);
            }
            param = { SvidUser: svidUser, Flag: 'RemoveRepetition' };
            JajaxSessionCheckCompl('post', '../../Handler/CartHandler.ashx', param, 'json', callback, complFunc, svidUser);
        }

        var cnt = 0;

        //중복체크 ROW Color
        function checkRepetition() {
            var goodsCodeArray = [];
            var array = [];
            var arrayGoodsCode = [];
            $('#tblCart tbody tr').each(function (index, element) {
                var goodsCode = $(element).find("#hdGoodsCode").val();
                goodsCodeArray.push(goodsCode);
            });

            $.each(goodsCodeArray, function (i, el) {
                if ($.inArray(el, array) == -1) {
                    array.push(el);
                } else {
                    var GoodsCode = $('#tblCart tbody tr').eq(i).find("#hdGoodsCode").val();
                    //$('#tblCart tbody tr').eq(i).css("background-color", "#fbccce");
                    arrayGoodsCode.push(GoodsCode);
                }
            });

            $.each(goodsCodeArray, function (i, el) {
                var goodsCode2 = arrayGoodsCode.pop(i);
                $('#tblCart tbody tr').each(function (index, element) {
                    var goodsCode = $(element).find("#hdGoodsCode").val();
                    if (goodsCode == goodsCode2 && $('#tblCart tbody input[type="checkbox"]').length != 0) {
                        cnt++;

                        $(element).find("td").css("background-color", "#fee0e1");
                    }
                });

            });
        }

        window.onload = function () {
            if (cnt != 0) {
                alert('상품코드가 중복되어 주문불가합니다. 중복제거 버튼을 눌러주세요.');
                return false;
            }
        };

        //체크박스 전체 선택
        function AllCheckbox() {
            $("#checkAll").change(function () {
                var freeCnt = 0;
                if ($("#checkAll").is(":checked")) { //체크박스 선택
                    $('#tblCart input[type="checkbox"]').each(function () {
                        
                        var memo = $(this).parent().find("input[name='hdMemo']").val();
                        if (memo == "FD") { //무료배송일 경우
                            $(this).prop('checked', 'checked');

                            $(this).parent().parent().find("span[id*='spFreeDlvr']").text("\n*무료배송*");
                            
                            ++freeCnt; //무료배송있는 경우

                        } else if (freeCnt === 0) {

                            if ($(this).parent().find('input[id*="hfCompanyGoodsYN"]').val() != 'N' && isEmpty($(this).parent().find('input[id*="hfGoodsDisplayReason"]').val())) {
                                $(this).prop('checked', 'checked');
                            }
                        } else {
                            $(this).prop('checked', '');
                        }
                    });
                } else {
                    $('#tblCart input[type="checkbox"]').each(function () {
                        if ($(this).parent().find('input[id*="hfCompanyGoodsYN"]').val() != 'N' && isEmpty($(this).parent().find('input[id*="hfGoodsDisplayReason"]').val())) {
                            $(this).prop('checked', '');
                        }
                    });
                }
            });
        }
        
        
        //총 구매금액 초기값
        function initialValue() {
            var sumTotalPrice = 0;
            $('#tblCart tbody tr').each(function (index, element) {

                //if ($(this).children().find('input[id*="hfCompanyGoodsYN"]').val() != 'N' && isEmpty($(this).children().find('input[id*="hfGoodsDisplayReason"]').val())) {
                //    var qty = $(element).find("input[type = text]").val();//수량  
                //    var hfGoodsSalePriceVAT = $(element).find("input[type = hidden]").eq(1).val();
                //    var sumPrice = hfGoodsSalePriceVAT * qty;
                //    sumTotalPrice += sumPrice;
                //}

                if ($(element).find("input[type = checkbox]").prop('checked') == true) {
                    var qty = $(element).find("input[type = text]").val();//수량
                    var hfGoodsSalePriceVAT = $(element).find("input[type = hidden]").eq(1).val();
                    var sumPrice = hfGoodsSalePriceVAT * qty;
                    sumTotalPrice += sumPrice;
                    
                }
            });

            //총주문금액 초기값
            if (isNaN(sumTotalPrice)) {
                $("#lbTotalCheckPrice").text(0);
                $("#lbTotalSum").text(0);
            } else {
                $("#lbTotalSum").text(numberWithCommas(sumTotalPrice));
                $("#lbTotalCheckPrice").text(numberWithCommas(sumTotalPrice));
            }

        }

        //ROW삭제 
        function fnSingleDelete(index) {

            if (!confirm("삭제하시겠습니까?")) {
                return false;
            }
            //var cartCode = $(index).parent().parent().find('#cartCode').text();
            var cartCode = $(index).parent().parent().find('#hdCartCode').val();
            var goodsFinalCategoryCode = $(index).parent().parent().find('#goodsFinalCategoryCode').val();
            var goodsGroupCode = $(index).parent().parent().find('#goodsGroupCode').val();
            var goodsCode = $(index).parent().parent().find('#hdGoodsCode').val();
            var svidUser = '<%= Svid_User%>';
            var Unum_CartNo = $(index).parent().parent().find("input[type = hidden]").val();

            var callback = function (response) {
                //window.location.reload(true);
            }

            var complFunc = function () {
                window.location.reload(true);
            }

            param = { CartCode: cartCode, GoodsFinalCategoryCode: goodsFinalCategoryCode, GoodsGroupCode: goodsGroupCode, GoodsCode: goodsCode, SvidUser: svidUser, Flag: 'DEL', Unum_CartNo: Unum_CartNo };

            JajaxSessionCheckCompl('post', '../../Handler/CartHandler.ashx', param, 'json', callback, complFunc, svidUser);
        }
        var is_sending = false;
        //Form체크
        function fnFormCheck() {
            var svidUser = '<%= Svid_User%>';
            var goodsFinalCategoryCode = "";
            var goodsGroupCode = "";
            var goodsCode = "";
            var qty = "";
            var budgetAccount = "";
            var Unum_CartNo = "";
            var cartCode = ""

            var total_goodsFinalCategoryCode = "";
            var total_goodsGroupCode = "";
            var total_goodsCode = "";
            var total_qty = "";
            var total_CartNo = "";
            var total_budgetAccount = "";
            var total_cartCode = "";
            var cnt = 0;
            var flag = $("#hdBudgetFlag").val();
            
            $("#tblCart tbody").find("input[flag='qty']").each(function () {
                var num = $(this).prop('value');
                //input창 비어있을 때
                if ($(this).prop('value') == '') {
                    alert('수량을 입력해주세요');
                    $(this).focus();
                    cnt++;
                    return false;
                }
                if ($(this).prop('value') == 0) {
                    alert('최소 수량을 입력해주세요');
                    $(this).prop('value', '');
                    $(this).focus();
                    cnt++;
                    return false;
                }
            });
            if (cnt != 0) {
                return false;
            }
            //주문하기
            var cnt = 0;
            var goodsCodeArray = [];
            $('#tblCart tbody input[type="checkbox"]').each(function () {
                if ($(this).prop('checked') == true) {
                    //cartCode = $(this).parent().parent().find('#cartCode').text();
                    cartCode = $(this).parent().parent().find('#hdCartCode').val();
                    goodsFinalCategoryCode = $(this).parent().parent().find('#goodsFinalCategoryCode').prop('value');
                    goodsGroupCode = $(this).parent().parent().find('#goodsGroupCode').prop('value');
                    goodsCode = $(this).parent().parent().find('#hdGoodsCode').val();       //상품코드      
                    qty = $(this).parent().parent().find("input[type = text]").val();
                    Unum_CartNo = $(this).parent().parent().find("input[type = hidden]").val();
                    //budgetAccount = $(this).parent().parent().find("select option:selected").val(); //예산계정          
                    var num = $(this).val();
                    goodsCodeArray.push(goodsCode);
                    cnt++;
                    total_goodsFinalCategoryCode = total_goodsFinalCategoryCode + goodsFinalCategoryCode + "/";
                    total_goodsGroupCode = total_goodsGroupCode + goodsGroupCode + "/";
                    total_goodsCode = total_goodsCode + goodsCode + "/";
                    total_qty = total_qty + qty + "/";
                    total_CartNo = total_CartNo + Unum_CartNo + "/";
                    //if (!isEmpty(budgetAccount)) {
                    //    total_budgetAccount = total_budgetAccount + budgetAccount + "/";
                    //} else {
                    //    total_budgetAccount = total_budgetAccount + "/";
                    //}

                    total_cartCode = total_cartCode + cartCode + "/";
                }
            });

            //잔여예산보다 총 주문금액이 많으면 주문 안됨
            var budget = $("#lbBudget").text(); //잔여예산 
            var check = budget;

            var totalPrice = $("#lbTotalCheckPrice").text(); //총 주문 금액
            budget = budget + "" //스트링으로 변환   
            budget = budget.replace(/[^\d]+/g, ''); // (,)지우기      
            budget *= 1; //숫자로 변환

            totalPrice = totalPrice + ""
            totalPrice = totalPrice.replace(/[^\d]+/g, '');
            totalPrice *= 1;

            if ($('#tblCart tbody input[type="checkbox"]').length == 0) {
                alert('장바구니에 상품이 없습니다.');
                return false;
            }

            if (cnt == 0 && totalPrice == 0) {
                alert('체크박스를 선택해주세요.');
                return false;
            }
            var svidRole = '<%= svidRole%>';

           if (svidRole == 'C1' || svidRole == 'BC1') {
               alert('권한이 없습니다.');
               return false;
           }

           if (svidRole == 'T') {
               alert("'Test용 ID' 이므로 주문을 하실 수 없습니다.");
               return false;
           }

           var array = [];
           var count = 0;

           $.each(goodsCodeArray, function (i, el) {
               if ($.inArray(el, array) == -1) {
                   array.push(el);
               } else {
                   ++count;
               }
           });
           if (totalPrice > budget && !isEmpty(check) && svidRole != 'A1') {
               alert("총 주문 금액이 잔여예산 금액보다 큽니다.");
               return false;
           } else {
               if (count > 0) {

                   alert("상품코드가 중복된 값이 있습니다. 상품코드를 확인해 주세요.");
                   return false;
               }
               var callback = function (response) {

                   var url = '../Order/OrderList.aspx';

                   

                   if (!isEmpty($('#hdCompareGroupNo').val()) && !isEmpty($('#hdScompInfoNo').val())) {  //가격비교 사용시 판매사 선택을 위해 파라미터를 넘김 
                       url += '?groupNo=' + $('#hdCompareGroupNo').val() + '&scompNo=' + $('#hdScompInfoNo').val();
                   }
                   location.href = url;
               }
               var compcode = '';
               if (!isEmpty('<%= UserInfoObject.UserInfo.PriceCompCode%>')) {
                    compcode = '<%= UserInfoObject.UserInfo.PriceCompCode%>'
                }
                else {
                    compcode = 'EMPTY'
                }

                var saleCompCode = '';
                var siteName = '<%= SiteName.ToLower().AsText("socialwith")%>';
                if (siteName != 'socialwith') {
                    saleCompCode = '<%= UserInfoObject.UserInfo.SaleCompCode%>';
                }
                var param = { GoodsFinalCategoryCode: total_goodsFinalCategoryCode, GoodsGroupCode: total_goodsGroupCode, GoodsCode: total_goodsCode, SvidUser: svidUser, Qty: total_qty, Method: 'OrderTry', Unum_CartNo: total_CartNo, BudgetAccount: total_budgetAccount, CartCode: total_cartCode, Flag: flag, CompCode: compcode, SaleCompCode: saleCompCode, DongshinCheck: '<%= UserInfoObject.UserInfo.BmroCheck%>', FreeCompanyYN: '<%= UserInfoObject.UserInfo.FreeCompanyYN%>' };
               //Jajax('Post', '../../Handler/OrderHandler.ashx', param, 'json', callback);
               var beforeSend = function () {
                   is_sending = true;
               }
               var complete = function () {
                   is_sending = false;
               }

               if (is_sending) return false;

               JajaxDuplicationCheck('Post', '../../Handler/OrderHandler.ashx', param, 'json', callback, beforeSend, complete, true, '<%= Svid_User%>');
            }
        }

        //가격비교 주문하기
        function fnCompPriceFormCheck() {
            fnGetSaleCompCode(); // 판매사 코드 갖고 오기
            var svidUser = '<%= Svid_User%>';
            var goodsFinalCategoryCode = "";
            var goodsGroupCode = "";
            var goodsCode = "";
            var qty = "";
            var Unum_CartNo = "";
            var cartCode = ""

            var total_goodsFinalCategoryCode = "";
            var total_goodsGroupCode = "";
            var total_goodsCode = "";
            var total_qty = "";
            var total_CartNo = "";
            var total_budgetAccount = "";
            var total_cartCode = "";
            var cnt = 0;
            var flag = $("#hdBudgetFlag").val();

            $("#tblCart tbody").find("input[flag='qty']").each(function () {
                var num = $(this).prop('value');
                //input창 비어있을 때
                if ($(this).prop('value') == '') {
                    alert('수량을 입력해주세요');
                    $(this).focus();
                    cnt++;
                    return false;
                }
                if ($(this).prop('value') == 0) {
                    alert('최소 수량을 입력해주세요');
                    $(this).prop('value', '');
                    $(this).focus();
                    cnt++;
                    return false;
                }
            });
            if (cnt != 0) {
                return false;
            }
            //주문하기
            var cnt = 0;
            var goodsCodeArray = [];
            $('#tblCart tbody input[type="checkbox"]').each(function () {
                if ($(this).prop('checked') == true) {
                    //cartCode = $(this).parent().parent().find('#cartCode').text();
                    cartCode = $(this).parent().parent().find('#hdCartCode').val();
                    goodsFinalCategoryCode = $(this).parent().parent().find('#goodsFinalCategoryCode').prop('value');
                    goodsGroupCode = $(this).parent().parent().find('#goodsGroupCode').prop('value');
                    goodsCode = $(this).parent().parent().find('#hdGoodsCode').val();       //상품코드      
                    qty = $(this).parent().parent().find("input[type = text]").val();
                    Unum_CartNo = $(this).parent().parent().find("input[type = hidden]").val();
                    //budgetAccount = $(this).parent().parent().find("select option:selected").val(); //예산계정          
                    var num = $(this).val();
                    goodsCodeArray.push(goodsCode);
                    cnt++;
                    total_goodsFinalCategoryCode = total_goodsFinalCategoryCode + goodsFinalCategoryCode + "/";
                    total_goodsGroupCode = total_goodsGroupCode + goodsGroupCode + "/";
                    total_goodsCode = total_goodsCode + goodsCode + "/";
                    total_qty = total_qty + qty + "/";
                    total_CartNo = total_CartNo + Unum_CartNo + "/";
                    //if (!isEmpty(budgetAccount)) {
                    //    total_budgetAccount = total_budgetAccount + budgetAccount + "/";
                    //} else {
                    //    total_budgetAccount = total_budgetAccount + "/";
                    //}

                    total_cartCode = total_cartCode + cartCode + "/";
                }
            });

            //잔여예산보다 총 주문금액이 많으면 주문 안됨
            var budget = $("#lbBudget").text(); //잔여예산 
            var check = budget;

            var totalPrice = $("#lbTotalCheckPrice").text(); //총 주문 금액
            budget = budget + "" //스트링으로 변환   
            budget = budget.replace(/[^\d]+/g, ''); // (,)지우기      
            budget *= 1; //숫자로 변환

            totalPrice = totalPrice + ""
            totalPrice = totalPrice.replace(/[^\d]+/g, '');
            totalPrice *= 1;

            if ($('#tblCart tbody input[type="checkbox"]').length == 0) {
                alert('장바구니에 상품이 없습니다.');
                return false;
            }

            if (cnt == 0 && totalPrice == 0) {
                alert('체크박스를 선택해주세요.');
                return false;
            }
            var svidRole = '<%= svidRole%>';

            if (svidRole == 'C1' || svidRole == 'BC1') {
                alert('권한이 없습니다.');
                return false;
            }

            if (svidRole == 'T') {
                alert("'Test용 ID' 이므로 주문을 하실 수 없습니다.");
                return false;
            }

            var array = [];
            var count = 0;

            $.each(goodsCodeArray, function (i, el) {
                if ($.inArray(el, array) == -1) {
                    array.push(el);
                } else {
                    ++count;
                }
            });
            if (totalPrice > budget && !isEmpty(check) && svidRole != 'A1') {
                alert("총 주문 금액이 잔여예산 금액보다 큽니다.");
                return false;
            } else {
                if (count > 0) {

                    alert("상품코드가 중복된 값이 있습니다. 상품코드를 확인해 주세요.");
                    return false;
                }
                var callback = function (response) {

                    var url = '../Order/OrderList.aspx';

                    if (!isEmpty($('#hdCompareGroupNo').val()) && !isEmpty($('#hdScompInfoNo').val())) {  //가격비교 사용시 판매사 선택을 위해 파라미터를 넘김 
                        url += '?groupNo=' + $('#hdCompareGroupNo').val() + '&scompNo=' + $('#hdScompInfoNo').val();
                    }
                    location.href = url;
                }
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
                   saleCompCode = $('#hdSaleCompCode').val();
               }
               var param = { GoodsFinalCategoryCode: total_goodsFinalCategoryCode, GoodsGroupCode: total_goodsGroupCode, GoodsCode: total_goodsCode, SvidUser: svidUser, Qty: total_qty, Method: 'OrderTry', Unum_CartNo: total_CartNo, BudgetAccount: total_budgetAccount, CartCode: total_cartCode, Flag: flag, CompCode: compcode, SaleCompCode: saleCompCode, DongshinCheck: '<%= UserInfoObject.UserInfo.BmroCheck%>', FreeCompanyYN: '<%= UserInfoObject.UserInfo.FreeCompanyYN%>' };
               //Jajax('Post', '../../Handler/OrderHandler.ashx', param, 'json', callback);
               var beforeSend = function () {
                   is_sending = true;
               }
               var complete = function () {
                   is_sending = false;
               }

               if (is_sending) return false;

               JajaxDuplicationCheck('Post', '../../Handler/OrderHandler.ashx', param, 'json', callback, beforeSend, complete, true, '<%= Svid_User%>');
            }
        }
        // 관심상품 담기
        function fnAddWish() {
            var role = '<%= UserInfoObject.Svid_Role%>';
            if (role == 'C1' || role == 'BC1') {
                alert('권한이 없습니다.')
                return false;
            }
            var selectLength = $('#tblCart :not(:first-child) input[type="checkbox"]:checked').length;
            if (selectLength < 1) {
                alert('상품을 선택해 주세요');
                return false;

            }
            var callback = function (response) {
                if (response.Result == 'OK') {

                    alert('관심상품 보관함에 담았습니다.');
                    location.href = '../../Wish/WishList.aspx';
                }
                else {
                    alert('시스템 오류입니다. 관리자에게 문의하세요.');
                }
                return false;
            };

            var categoryCodeArray = '';
            var goodsGroupCodeArray = '';
            var codeArray = '';
            $('#tblCart input[type="checkbox"]').not(':first').each(function () {
                if ($(this).prop('checked') == true) {
                    var goodsCode = $(this).parent().parent().children().find('#hdGoodsCode').val();
                    var goodsGroupCode = $(this).parent().parent().children().find('#goodsGroupCode').val();
                    var categoryCode = $(this).parent().parent().children().find('#goodsFinalCategoryCode').val();
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
            JajaxDuplicationCheck('Post', '../Handler/WishHandler.ashx', param, 'json', callback, beforeSend, complete, true, '<%=Svid_User%>');

            return false;
        }

        //체크박스로 삭제
        function fnCheckDelete() {
            var cnt = 0;
            var check = false;

            var selectLength = $('#tblCart input[type="checkbox"]:checked').length;
            if (selectLength < 1) {
                alert('체크박스를 선택해 주세요');
                return false;

            }

            if (!confirm("삭제하시겠습니까?")) {
                return false;
            }

            $('#tblCart input[type="checkbox"]').each(function () {
                if ($(this).prop('checked') == true) {
                    //var cartCode = $(this).parent().parent().find('#cartCode').text();
                    var cartCode = $(this).parent().parent().find('#hdCartCode').val();

                    var goodsFinalCategoryCode = $(this).parent().parent().find('#goodsFinalCategoryCode').prop('value');
                    var goodsGroupCode = $(this).parent().parent().find('#goodsGroupCode').prop('value');
                    var Unum_CartNo = $(this).parent().parent().find("#hdUnum_CartNo").val();
                    var goodsCode = $(this).parent().parent().find('input[id*="hfGoodsCode"]').val();

                    var svidUser = '<%= Svid_User%>';
                    var callback = function (response) {
                        if (check == false) {
                            // alert('삭제되었습니다.');
                            //window.location.reload(true);
                            check = true;
                        }
                    }

                    var complFunc = function () {
                        window.location.reload(true);
                    }

                    param = { CartCode: cartCode, GoodsFinalCategoryCode: goodsFinalCategoryCode, GoodsGroupCode: goodsGroupCode, GoodsCode: goodsCode, SvidUser: svidUser, Flag: 'DEL', Unum_CartNo: Unum_CartNo };

                    JajaxSessionCheckCompl('post', '../../Handler/CartHandler.ashx', param, 'json', callback, complFunc, svidUser);
                }
            });

        }

        //체크박스 하나라도 체크지울경우 처리
        function fnChangeCheck(el) {
            if ($(el).attr("id") == "checkAll") {
                return false;
            }

            var selectMemo = $(el).parent().parent().find("input[name='hdMemo']").val();
            var freeCnt = 0;
            var defaultCnt = 0;

            if ($(el).is(":checked") == false) {
                $("#checkAll").prop('checked', ''); //전체선택 박스 체크해제

            } else {

                $('#tblCart input[type="checkbox"]').each(function () {

                    var memo = $(this).parent().find("input[name='hdMemo']").val();
                    if ((memo == "FD") && ($(this).is(":checked") == true)) { //무료배송일 경우

                        ++freeCnt; //무료배송있는 경우

                    } else {
                        if ($(this).is(":checked")) {
                            ++defaultCnt;
                        }
                    }
                });
            }

            if (freeCnt > 0) {
                if (selectMemo != "FD") {
                    $(el).prop("checked", '');
                    alert("[알림]\n\n관리자가 무료배송상품을 설정했습니다.\n무료배송상품을 먼저 주문하시고 사용해 주시기 바랍니다.");

                } else if (defaultCnt > 0) {
                    $(el).prop("checked", '');
                    alert("[알림]\n\n관리자가 설정한 무료배송상품과 일반상품을 동시에 선택하실 수 없습니다.\n전체 해제 후 선택해 주시기 바랍니다.");
                }
            } else if (defaultCnt > 0) {
                if (selectMemo == "FD") {
                    $(el).prop("checked", '');
                    alert("[알림]\n\n관리자가 설정한 무료배송상품과 일반상품을 동시에 선택하실 수 없습니다.\n전체 해제 후 선택해 주시기 바랍니다.");
                }
            }

        }

        //수량 업데이트
        function fnChangeGoodsNum(index) {
            var Unum_CartNo = $(index).parent().parent().parent().find("input[type = hidden]").eq(0).val();
            //var cartCode = $(index).parent().parent().parent().find('#cartCode').text();
            var cartCode = $(index).parent().parent().parent().find('#hdCartCode').val();
            var goodsFinalCategoryCode = $(index).parent().parent().parent().find('#goodsFinalCategoryCode').val();
            var goodsGroupCode = $(index).parent().parent().parent().find('#goodsGroupCode').val();
            var goodsCode = $(index).parent().parent().parent().find('#hdGoodsCode').val();
            var svidUser = '<%= Svid_User%>';
            var qty = $(index).parent().parent().parent().find("input[type = text]").val();
            var goodsUnitMoq = $(index).parent().parent().parent().find('#goodsUnitMoq').text();

            //수량 입력전으로 돌리기
            var _hfGoodsSalePriceVAT = $(index).parent().parent().parent().find("input[type = hidden]").eq(1).val();
            var _sumPrice = $(index).parent().parent().parent().find("input[type = hidden]").eq(4).val();
            var calculate = _sumPrice / _hfGoodsSalePriceVAT;

            //최소수량보다 작은값 입력 못하게 체크
            if (parseInt(qty) < parseInt(goodsUnitMoq)) {
                alert("입력한 수량이 최소수량보다 작습니다.");
                $(index).parent().parent().find("input[type = text]").val(calculate);
                return false;
            }

            var callback = function (response) {

                alert('수량이 수정되었습니다.');
                //합계금액 변경
                var sumPrice = $(index).parent().parent().parent().find("td label").text(); //합계금액
                var hfGoodsSalePriceVAT = $(index).parent().parent().parent().find("input[type = hidden]").eq(2).val();
                //var newSumPrice = hfGoodsSalePriceVAT * qty;
                //$(index).parent().parent().parent().find("td label").text('');
                //$(index).parent().parent().parent().find("td label").text(newSumPrice);

                return false;
            }

            var complFunc = function () {
                window.location.reload(true);
            }

            param = { CartCode: cartCode, GoodsFinalCategoryCode: goodsFinalCategoryCode, GoodsGroupCode: goodsGroupCode, GoodsCode: goodsCode, SvidUser: svidUser, Qty: qty, Flag: 'QTY', Unum_CartNo: Unum_CartNo };
            JajaxSessionCheckCompl('post', '../Handler/CartHandler.ashx', param, 'json', callback, complFunc, svidUser);

        }

        //다시계산하기
        function fnReCarculate() {
            //다시계산하기 누르면 전체선택
            //$('#tblCart input[type="checkbox"]').each(function () {
            //    $(this).prop('checked', 'checked');
            //});

            var totalSum = 0; //총 구매금액
            var total_Unum_CartNo = "";
            var total_cartCode = "";
            var total_goodsFinalCategoryCode = "";
            var total_goodsGroupCode = "";
            var total_goodsCode = "";
            var svidUser = '<%= Svid_User%>';
            var total_qty = "";
            $('#tblCart tbody input[type="checkbox"]').each(function () {
                if ($(this).prop('checked') == true) {
                    var Unum_CartNo = $(this).parent().parent().find("input[type = hidden]").val();
                    //var cartCode = $(this).parent().parent().find('#cartCode').text();
                    var cartCode = $(this).parent().parent().find('#hdCartCode').val();
                    var goodsFinalCategoryCode = $(this).parent().parent().find('#goodsFinalCategoryCode').prop('value');
                    var goodsGroupCode = $(this).parent().parent().find('#goodsGroupCode').prop('value');
                    var goodsCode = $(this).parent().parent().find('#hdGoodsCode').val(); //상품코드      
                    var qty = $(this).parent().parent().find("input[type = text]").val();
                    //여기까지가 파라미터                
                    var hfGoodsSalePriceVAT = $(this).parent().parent().find("input[type = hidden]").eq(1).val(); //판매가격           
                    var sum = hfGoodsSalePriceVAT * qty;
                    var goodsUnitMoq = $(this).parent().parent().find('#goodsUnitMoq').text(); //최소수량
                    var _hfGoodsSalePriceVAT = $(this).parent().parent().find("input[type = hidden]").eq(1).val();
                    var _sumPrice = $(this).parent().parent().find("input[type = hidden]").eq(4).val();;
                    var calculate = _sumPrice / _hfGoodsSalePriceVAT;
                    if (qty < goodsUnitMoq) {
                        alert("입력한 수량이 최소수량보다 작습니다.");
                        //수량 입력전으로 돌리기
                        $(this).parent().parent().find("input[type = text]").val(calculate);
                        window.location.reload(true)
                        return false;
                    }

                    total_Unum_CartNo = total_Unum_CartNo + Unum_CartNo + "/";
                    total_cartCode = total_cartCode + cartCode + "/";
                    total_goodsFinalCategoryCode = total_goodsFinalCategoryCode + goodsFinalCategoryCode + "/";
                    total_goodsGroupCode = total_goodsGroupCode + goodsGroupCode + "/";
                    total_goodsCode = total_goodsCode + goodsCode + "/";
                    total_qty = total_qty + qty + "/";

                    totalSum += sum;

                    $(this).parent().parent().find("td label").text(numberWithCommas(sum));
                }
            });
            $('#tblCart tbody tr').each(function (index, element) {
                //var Unum_CartNo = $(element).find("input[type = hidden]").eq(0).val();
                //var cartCode = $(element).find('#cartCode').text();          
                //var goodsFinalCategoryCode = $(element).find('#goodsFinalCategoryCode').prop('value');
                //var goodsGroupCode = $(element).find('#goodsGroupCode').prop('value');
                //var goodsCode = $(element).find('#hdGoodsCode').val();
                var qty = $(element).find("input[type = text]").val();//수량
                //여기까지가 파라미터                
                //var hfGoodsSalePriceVAT = $(element).find("input[type = hidden]").eq(1).val(); //판매가격           
                //var sum = hfGoodsSalePriceVAT * qty;
                var goodsUnitMoq = $(element).find('#goodsUnitMoq').text(); //최소수량
                var _hfGoodsSalePriceVAT = $(element).find("input[type = hidden]").eq(1).val();
                var _sumPrice = $(element).find("input[type = hidden]").eq(4).val();
                var calculate = _sumPrice / _hfGoodsSalePriceVAT;
                if (qty < goodsUnitMoq) {
                    alert("입력한 수량이 최소수량보다 작습니다.");
                    //수량 입력전으로 돌리기
                    $(element).find("input[type = text]").val(calculate);
                    window.location.reload(true)
                    return false;
                }

                //total_Unum_CartNo = total_Unum_CartNo + Unum_CartNo + "/";
                //total_cartCode = total_cartCode + cartCode + "/";
                //total_goodsFinalCategoryCode = total_goodsFinalCategoryCode + goodsFinalCategoryCode + "/";
                //total_goodsGroupCode = total_goodsGroupCode + goodsGroupCode + "/";
                //total_goodsCode = total_goodsCode + goodsCode + "/";
                //total_qty = total_qty + qty + "/";

                //totalSum += sum;

                //$(element).find("td label").text(numberWithCommas(sum));
            });

            var callback = function (response) {
                //alert('총 구매금액 계산됨^_^');
                $("#lbTotalSum").text(numberWithCommas(totalSum));
                $("#lbTotalCheckPrice").text(numberWithCommas(totalSum));
                return false;
            }

            //var complFunc = function () {
            //    window.location.reload(true);
            //}

            param = { CartCode: total_cartCode, GoodsFinalCategoryCode: total_goodsFinalCategoryCode, GoodsGroupCode: total_goodsGroupCode, GoodsCode: total_goodsCode, SvidUser: svidUser, Qty: total_qty, Flag: 'MultiUpdateCart', Unum_CartNo: total_Unum_CartNo };
            Jajax('post', '../../handler/carthandler.ashx', param, 'json', callback);
            //JajaxSessionCheckCompl('post', '../../Handler/CartHandler.ashx', param, 'json', callback, complFunc, svidUser);
        }

        function fnEstimatePrint() {
            alert("정식 OPEN (1월초)에 보실수있습니다");
            return false;
        }

        function fnExcelExportValidation() {

            var goodsCodeArray = [];
            $('#tblCart tbody input[type="checkbox"]').each(function () {
                goodsCode = $(this).parent().parent().find('#hdGoodsCode').val();       //상품코드      
                goodsCodeArray.push(goodsCode);
            });

            var array = [];
            var count = 0;

            $.each(goodsCodeArray, function (i, el) {
                if ($.inArray(el, array) == -1) {
                    array.push(el);
                } else {
                    ++count;
                }
            });

            if (count > 0) {

                alert("상품코드가 중복된 값이 있습니다. 중복제거 후 엑셀저장 버튼을 클릭해 주세요.");
                return false;
            }
            var numberArrary = '';

            $('#tblCart tbody input[type="checkbox"]').each(function () {
                if ($(this).prop('checked') == true) {
                    numberArrary += $(this).parent().find("input:hidden[id ='hdUnum_CartNo']").val() + ',';
                }
            });

            if (isEmpty(numberArrary)) {
                alert('엑셀 저장할 행의 체크박스를 선택해주세요.');
                return false;
            }

            $('#<%=hfCartNos.ClientID %>').val(numberArrary.slice(0, -1));

            return true;
        }

        function fnCartReportPopup() {
            var numberArrary = '';

            $('#tblCart tbody input[type="checkbox"]').each(function () {
                if ($(this).prop('checked') == true) {
                    numberArrary += $(this).parent().find("input:hidden[id ='hdUnum_CartNo']").val() + ',';
                }
            });

            if (isEmpty(numberArrary)) {
                alert('출력할 행의 체크박스를 선택해주세요.');
                return false;
            }
            var svidUser = '<%= Svid_User%>';
            var compcode = '';
            if (!isEmpty('<%= UserInfoObject.UserInfo.PriceCompCode%>')) {
                compcode = '<%= UserInfoObject.UserInfo.PriceCompCode%>'
            }
            else {
                compcode = 'EMPTY'
            }
            var url = '../../Print/CartReport.aspx?SvidUser=' + svidUser + '&CartNos=' + numberArrary.slice(0, -1) + '&CompCode=' + compcode + '&Dcheck=' + '<%= UserInfoObject.UserInfo.BmroCheck%>' + '&FreeCompFlag=' + '<%= UserInfoObject.UserInfo.FreeCompanyYN%>';

            //url, target, width, height, status, toolbar,  menubar, location, resizable, scrollbar
            fnWindowOpen(url, '', 1000, 600, 'yes', 'no', 'no', 'no', 'yes', 'yes');
            return false;
            //window.open(url, '', "height=600, width=1000,status=yes,toolbar=no,menubar=no,location=no,resizable=no");
        }


        function fnCompareCartReportPopup() {
            var numberArrary = '';
            fnGetSaleCompCode();
            $('#tblCart tbody input[type="checkbox"]').each(function () {
                if ($(this).prop('checked') == true) {
                    numberArrary += $(this).parent().find("input:hidden[id ='hdUnum_CartNo']").val() + ',';
                }
            });

            if (isEmpty(numberArrary)) {
                alert('출력할 행의 체크박스를 선택해주세요.');
                return false;
            }
            var svidUser = '<%= Svid_User%>';
            var compcode = '';
            if (!isEmpty('<%= UserInfoObject.UserInfo.PriceCompCode%>')) {
                compcode = '<%= UserInfoObject.UserInfo.PriceCompCode%>'
            }
            else {
                compcode = 'EMPTY'
            }
            var url = '../../Print/CompareCartReport.aspx?SvidUser=' + svidUser + '&CartNos=' + numberArrary.slice(0, -1) + '&CompCode=' + compcode + '&Dcheck=' + '<%= UserInfoObject.UserInfo.BmroCheck%>' + '&FreeCompFlag=' + '<%= UserInfoObject.UserInfo.FreeCompanyYN%>' + '&GroupNo=' + $('#hdCompareGroupNo').val() + '&SaleCompCode=' + $('#hdSaleCompCode').val();

            //url, target, width, height, status, toolbar,  menubar, location, resizable, scrollbar
            fnWindowOpen(url, '', 1000, 600, 'yes', 'no', 'no', 'no', 'yes', 'yes');
            return false;
            //window.open(url, '', "height=600, width=1000,status=yes,toolbar=no,menubar=no,location=no,resizable=no");
        }

        function fnCartAdditionReportPopup() {

            var e = document.getElementById('additionPrint');
            if (e.style.display == 'block') {
                e.style.display = 'none';

            } else {
                e.style.display = 'block';
            }

            return false;
        }
        function fnAdditionCartReport() {

            var numberArrary = '';

            $('#tblCart tbody input[type="checkbox"]').each(function () {
                if ($(this).prop('checked') == true) {
                    numberArrary += $(this).parent().find("input:hidden[id ='hdUnum_CartNo']").val() + ',';
                }
            });

            if (isEmpty(numberArrary)) {
                alert('출력할 행의 체크박스를 선택해주세요.');
                return false;
            }
            var svidUser = '<%= Svid_User%>';
            var compcode = '';
            if (!isEmpty('<%= UserInfoObject.UserInfo.PriceCompCode%>')) {
                compcode = '<%= UserInfoObject.UserInfo.PriceCompCode%>'
            }
            else {
                compcode = 'EMPTY'
            }
            var url = '../../Print/CartAdditionReport.aspx?SvidUser=' + svidUser + '&CartNos=' + numberArrary.slice(0, -1) + '&CompCode=' + compcode + '&Dcheck=' + '<%= UserInfoObject.UserInfo.BmroCheck%>' + '&Percent=' + $('#selectPercent').val() + '&FreeCompFlag=' + '<%= UserInfoObject.UserInfo.FreeCompanyYN%>';

            //url, target, width, height, status, toolbar,  menubar, location, resizable, scrollbar
            fnWindowOpen(url, '', 1000, 600, 'yes', 'no', 'no', 'no', 'yes', 'yes');
            return false;
        }

        function fnPopupGoodsPrice() {

            var goodsCodeArray = [];
            $('#tblCart tbody input[type="checkbox"]').each(function () {
                goodsCode = $(this).parent().parent().find('#hdGoodsCode').val();       //상품코드      
                goodsCodeArray.push(goodsCode);
            });

            var array = [];
            var count = 0;

            $.each(goodsCodeArray, function (i, el) {
                if ($.inArray(el, array) == -1) {
                    array.push(el);
                } else {
                    ++count;
                }
            });

            if (count > 0) {

                alert("상품코드가 중복된 값이 있습니다. 중복제거 후 버튼을 클릭해 주세요.");
                return false;
            }
            var numberArrary = '';

            $('#tblCart tbody input[type="checkbox"]').each(function () {
                if ($(this).prop('checked') == true) {
                    numberArrary += $(this).parent().find("input:hidden[id ='hdUnum_CartNo']").val() + ',';
                }
            });

            if (isEmpty(numberArrary)) {
                alert('주문할 행의 체크박스를 선택해주세요.');
                return false;
            }

            var groupNo = fnGetGoodsPriceCompareCheck();
            if (isEmpty(groupNo)) {
                var seq = fnGetGoodsPriceCompareNextSeq();
                fnSaveGoodsPriceCompare(seq);
                groupNo = seq;
            }
            else {
                fnUpdateGoodsPriceCompare(groupNo);
            }
            fnGetGoodsCompareList(groupNo);
            fnGetSaleCompCode();
        }



        function fnSaveGoodsPriceCompare(seq) {

            var jsonArray = [];

            $('#tblCart tbody input[type="checkbox"]').each(function () {
                if ($(this).prop('checked') == true) {
                    var goodsCode = $(this).parent().parent().find('#hdGoodsCode').val();
                    var unum_CartNo = $(this).parent().parent().find("input[type = hidden]").val();
                    var qty = $(this).parent().parent().find("input[type = text]").val();
                    var hfGoodsSalePriceVAT = $(this).parent().parent().find("input[type = hidden]").eq(1).val(); //판매가격           
                    var sum = hfGoodsSalePriceVAT * qty;

                    jsonArray.push({
                        GoodsCode: goodsCode,
                        CartNo: unum_CartNo,
                        Price: sum,
                    });
                }
            });


            var callback = function (response) {

                if (response == 'OK') {

                }
                else {
                    alert('가격비교중 오류가 생겼습니다. 시스템 관리자에게 문의하세요.');

                }
                return false;
            };

            $.ajax({
                type: "POST",
                url: '../../Handler/GoodsHandler.ashx',
                async: false,
                contentType: false,
                processData: false,
                success: callback,
                data: function () {
                    var data = new FormData();
                    data.append("SvidUser", '<%= Svid_User%>');
                    data.append("CompanyCode", '<%= UserInfoObject.UserInfo.Company_Code%>');
                    data.append("GroupNo", seq);
                    data.append("RandomSeq", shuffleRandom(5));
                    data.append("Datas", JSON.stringify(jsonArray));
                    data.append("Method", 'InsertGoodsPriceCompare');

                    return data;
                }(),
            });

        }


        function fnUpdateGoodsPriceCompare(groupNo) {

            var jsonArray = [];

            $('#tblCart tbody input[type="checkbox"]').each(function () {
                if ($(this).prop('checked') == true) {
                    var unum_CartNo = $(this).parent().parent().find("input[type = hidden]").val();
                    var hfSumPriceVAT = $(this).parent().find("input[id *='hfSumPrice']").val(); //판매가격       
                    var sum = hfSumPriceVAT;

                    jsonArray.push({
                        CartNo: unum_CartNo,
                        Price: sum,
                    });
                }
            });


            var callback = function (response) {

                if (response == 'OK') {

                }
                else {
                    alert('가격비교중 오류가 생겼습니다. 시스템 관리자에게 문의하세요.');

                }
                return false;
            };

            $.ajax({
                type: "POST",
                url: '../../Handler/GoodsHandler.ashx',
                async: false,
                contentType: false,
                processData: false,
                success: callback,
                data: function () {
                    var data = new FormData();
                    data.append("GroupNo", groupNo);
                    data.append("Datas", JSON.stringify(jsonArray));
                    data.append("Method", 'UpdateGoodsPriceCompare');

                    return data;
                }(),
            });

        }


        //가격비교 판매사 시퀀스 랜덤생성
        function shuffleRandom(n) {
            var ar = new Array();
            var temp;
            var rnum;

            //전달받은 매개변수 n만큼 배열 생성 ( 1~n )
            for (var i = 1; i <= n; i++) {
                ar.push(i);
            }

            //값을 서로 섞기
            for (var i = 0; i < ar.length; i++) {
                rnum = Math.floor(Math.random() * n); //난수발생
                temp = ar[i];
                ar[i] = ar[rnum];
                ar[rnum] = temp;
            }

            return ar;
        }


        function fnGetGoodsCompareList(groupNo) {
            $('#hdCompareGroupNo').val(groupNo);
            var callback = function (response) {
                $("#pop_goodsCompareTbody").empty();
                var newRowContent = '';
                if (!isEmpty(response)) {
                    $.each(response, function (key, value) { //테이블 추가
                        if (key == 0) {
                            $('#hdScompInfoNo').val(value.Unum_GoodsPrice_ScompInfoNo);
                        }
                        var anonymousComp = '';
                        var confirmText = '';
                        var selectText = '';
                        var selectRowStyle = '';
                        if (value.Seq == '1') {
                            anonymousComp = '가';
                        }
                        else if (value.Seq == '2') {
                            anonymousComp = '나';
                        }
                        else if (value.Seq == '3') {
                            anonymousComp = '다';
                        }
                        else if (value.Seq == '4') {
                            anonymousComp = '라';
                        }
                        else if (value.Seq == '5') {
                            anonymousComp = '마';
                        }
                        else {
                            anonymousComp = '가';
                        }

                        if (value.CompareConfirmYN == 'Y') {
                            confirmText = '최저가';
                            selectText = '✔';
                            selectRowStyle = 'style="background-color:#cce6ff"';
                        }


                        newRowContent += "<tr " + selectRowStyle + ">";
                        newRowContent += "<td style='text-align:center'>" + anonymousComp + "</td>";
                        newRowContent += "<td style='text-align:center'>" + numberWithCommas(value.ComparePriceVat) + "원</td>";
                        newRowContent += "<td style='text-align:center'>" + confirmText + "</td>";
                        newRowContent += "<td style='text-align:center'>" + selectText + "</td>";
                        newRowContent += "</tr>";

                    });
                    $("#pop_goodsCompareTbody").append(newRowContent);
                }

                var e = document.getElementById('goodsCompareDiv');
                if (e.style.display == 'block') {
                    e.style.display = 'none';

                }
                else {
                    e.style.display = 'block';
                }
                $(".popupdivWrapper").draggable();
                return false;
            }
            var param = {

                GroupNo: groupNo,
                Method: 'GetGoodsPriceCompareList'

            };


            //type, url, async, cache, data, datatype, _callback, _beforeSend, _complete, issessionCheck, sessionValue
            JqueryAjax('Post', '../../Handler/GoodsHandler.ashx', false, false, param, 'json', callback, null, null, true, '<%=Svid_User%>');
        }

        function fnGetGoodsPriceCompareNextSeq() {
            var returnVal = '';
            var callback = function (response) {
                returnVal = response;
            }

            var param = {
                Method: 'GetGoodsPriceCompareNextSeq'
            };


            JqueryAjax('Post', '../../Handler/GoodsHandler.ashx', false, false, param, 'text', callback, null, null, true, '<%=Svid_User%>');
            return returnVal;
        }

        function fnGetGoodsPriceCompareCheck() {
            var cartNos = '';
            $('#tblCart tbody input[type="checkbox"]').each(function () {
                if ($(this).prop('checked') == true) {

                    cartNos += $(this).parent().parent().find("input[type = hidden]").val() + ',';
                }
            });
            var returnVal = '';
            var callback = function (response) {
                returnVal = response;
            }
            var param = {
                CartNos: cartNos.slice(0, -1),
                Method: 'GetPriceCompareNo'

            };


            JqueryAjax('Post', '../../Handler/GoodsHandler.ashx', false, false, param, 'text', callback, null, null, true, '<%=Svid_User%>');
            return returnVal;
        }

        function fnGetSaleCompCode() {
            var callback = function (response) {
                if (!isEmpty(response)) {
                    for (var i = 0; i < response.length; i++) {
                        if (i == 0) {
                            $('#hdSaleCompCode').val(response[i].OrderSaleCompanyCode);
                        }
                    }
                }
                else {

                    $('#hdSaleCompCode').val('<%= UserInfoObject.UserInfo.SaleCompCode%>')
                }
                return false;
            }
            var param = {
                SvidUser: '<%= Svid_User%>',
                CompCode: '<%= UserInfoObject.UserInfo.Company_Code%>',
                GroupNo: $('#hdCompareGroupNo').val(),
                ScompInfoNo: $('#hdScompInfoNo').val(),
                Flag: 'GetGoodsPriceCompareSaleCompInfo'
            };

            JqueryAjax("Post", "../Handler/Admin/CompanyHandler.ashx", false, false, param, "json", callback, null, null, true, '<%=Svid_User%>');
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div class="sub-contents-div">
        
            <div style="margin-top:20px; text-align:left;" class="sub-title-div">
                <p class="p-title-mainsentence">
                   <span><img src="/images/C_JANG.png" /></span> 
                </p>
            </div>
            <div class="menuTab-div">
                <div class="btnTab-div">
                    <ul>
                        <li style="padding-right: 1px">
                            <input type="button" id="btnTab1" class="mainbtn type1" style="width: 117px;  margin-right:2px; height: 30px; font-size: 12px" value="삭제" onclick="fnCheckDelete();" /></li>
                        <li style="padding-right: 1px">
                            <input type="button" id="btnTab2" class="mainbtn type1" style=" width: 117px; margin-right:2px; height: 30px; font-size: 12px; display: none" value="견적서출력" onclick="return fnCartReportPopup();" /></li>
                        <li style="padding-right: 1px">
                            <input type="button" id="btnTab3" class="mainbtn type1" style="width: 117px; margin-right:2px; height: 30px; font-size: 12px; display: none" value="추가 견적서출력" onclick="return fnCartAdditionReportPopup();" /></li>
                        <li style="padding-right: 1px">
                            <asp:Button ID="btnExcelExport" runat="server" style="margin-right:2px;" OnClick="btnExcelExport_Click" OnClientClick="return fnExcelExportValidation();" Text="엑셀저장" CssClass="mainbtn type1" Width="112" Height="30"  /></li>
                        <li style="padding-right: 1px">
                            <input type="button" id="btnTab4" class="mainbtn type1" style="width: 117px; margin-right:2px; height: 30px; font-size: 12px" value="찜하기" onclick="return fnAddWish();" />
                        <li style="padding-right: 1px">
                            <input type="button" id="btnOrder" class="mainbtn type2" style="width: 117px; margin-right:2px; height: 30px; font-size: 12px; display: none" value="주문하기" onclick="return fnFormCheck();" />

                        <li style="padding-right: 1px">
                            <input type="button" id="btnGoodsPriceCompare" class="mainbtn type2" style="width: 145px; height: 30px; font-size: 12px; display: none" value="합계금액 최저가 비교" onclick="return fnPopupGoodsPrice();" />
                        </li>
                    </ul>
                </div>

                <div>
                    <div class="totalCost-div">
                        총 주문 금액 (VAT포함) :
						<label id="lbTotalCheckPrice" style="font-size: 16px;">000,000</label>원
                    </div>
                </div>
            </div>

            <br />
            <div style="width: 100%; height: 37px">
                <div style="display: inline-block;">
                    선택상품개수 :
                <label id="lblCheckCnt"></label>
                    <a style="margin-left: 10px;">
                        <img src="../Images/Cart/duple-off.jpg" alt="중복제거" onclick="fnRemoveRepetition(this); return false;" onmouseover="this.src='../Images/Cart/duple-on.jpg'" onmouseout="this.src='../Images/Cart/duple-off.jpg'" />
                    </a>
                </div>
                <div style="display: inline-block; float: right">
                    <asp:Label runat="server" ID="lblPayStatus" CssClass="currentPay"></asp:Label>
                </div>
            </div>

            <table class="tbl_main" id="tblCart">
                <thead>
                    <tr class="">
                        <th class="txt-center" style="width: 50px;">선택<br />
                            <input type="checkbox" id="checkAll" style="" /></th>
                        <th class="txt-center">장바구니번호<br />
                            (추천번호)</th>
                        <th class="txt-center">이미지</th>
                        <th class="txt-center" style="width: 70px;">상품코드</th>
                        <th class="txt-center">상품정보</th>
                        <th class="txt-center">모델명</th>
                        <th class="txt-center" style="width: 70px;">출하예정</th>
                        <th class="txt-center" style="width: 70px;">최소수량<br>내용량</th>
                        <th class="txt-center">상품가격</th>
                        <th class="txt-center">수량</th>
                        <th class="txt-center">합계금액</th>
                        <th class="txt-center">삭제</th>
                    </tr>
                </thead>
                <tbody>
                    <asp:Repeater ID="rptCart" runat="server" OnItemDataBound="rptCart_ItemDataBound">
                        <ItemTemplate>
                            <tr id="trCart" runat="server">
                                <td style="height: 51px;">
                                    <input type="checkbox" id="cbCart" runat="server" />
                                    <input type="hidden" id="hdUnum_CartNo" value='<%# Eval("Unum_CartNo").AsText() %>' />
                                    <asp:HiddenField ID="hfGoodsSalePriceVAT" runat="server" Value='<%# Eval("GoodsDCPriceVAT").AsDecimalNullable() != null ? Eval("GoodsDCPriceVAT").AsText() :  Eval("GoodsSalePriceVAT").AsText() %>' />
                                    <input type="hidden" id="goodsGroupCode" value='<%# Eval("GoodsGroupCode").AsText() %>'>
                                    <input type="hidden" id="goodsFinalCategoryCode" value='<%# Eval("GoodsFinalCategoryCode").AsText() %>'>
                                    <asp:HiddenField ID="hfSumPrice" runat="server" Value='<%# Calculate(Eval("GoodsSalePriceVAT").AsInt(), Eval("Qty").AsInt(), Eval("GoodsDCPriceVAT").AsDecimalNullable()) %>' />
                                    <asp:HiddenField ID="hfGoodsCode" runat="server" Value='<%# Eval("GoodsCode").AsText() %>' />
                                    <asp:HiddenField ID="hfGdsTax" runat="server" Value='<%# Eval("GoodsSaleTaxYN").AsText() %>' />
                                    <asp:HiddenField ID="hfCompanyGoodsYN" runat="server" Value='<%# Eval("CompanyGoodsYN").AsText() %>' />
                                    <asp:HiddenField ID="hfGoodsDisplayReason" runat="server" Value='<%# Eval("GoodsDisplayReason").AsText() %>' />
                                    <asp:HiddenField ID="hfMoq" runat="server" Value='<%# Eval("GoodsUnitMoq").AsText() %>' />
                                    <asp:HiddenField ID="hfQty" runat="server" Value='<%# Eval("Qty").AsText() %>' />
                                    <input type="hidden" id="hdCartCode" value='<%# Eval("CartcodeNo").AsText() %>' />
                                    <input type="hidden" name="hdMemo" value='<%# Eval("Memo").AsText() %>' />
                                    <%-- <input type="hidden" id="hdMoq" value='<%# Eval("GoodsUnitMoq").ToString() %>'>
                                <input type="hidden" id="hdQty" value='<%# Eval("Qty").ToString() %>'>--%>
                                </td>
                                <td id="cartCode" style="width: 120px;"><%# Eval("CartcodeNo").AsText() %><br />
                                    <%# !string.IsNullOrWhiteSpace(Eval("GoodsRecommCode").AsText()) ? "("+ Eval("GoodsRecommCode").AsText() +")" : ""  %><span id="spFreeDlvr" style="color: red"></span></td>

                                <td>
                                    <asp:HyperLink ID="hlImg" runat="server" NavigateUrl='<%# String.Format("../Goods/GoodsDetail?GoodsModel=&GoodsCode={0}&GroupCode={1}&CategoryCode={2}&BrandName=&GoodsName=&Type=ds", Eval("GoodsCode").AsText(),Eval("GoodsGroupCode").AsText(),Eval("GoodsFinalCategoryCode").AsText()) %>'>
                                        <asp:Image runat="server" ID="imgGoods" Width="50" Height="50" ImageUrl='<%# String.Format("/GoodsImage/{0}/{1}/{2}/{3}", Eval("GoodsFinalCategoryCode") , Eval("GoodsGroupCode"), Eval("GoodsCode"), Eval("GoodsFinalCategoryCode").AsText() + "-" + Eval("GoodsGroupCode") + "-" + Eval("GoodsCode") + "-" + "sss.jpg")%>' onerror="this.onload = null; this.src='/Images/noImage_s.jpg';" />
                                    </asp:HyperLink></td>
                                <td id="goodsCode" style="width: 80px">
                                    <input type="hidden" id="hdGoodsCode" value="<%# Eval("GoodsCode").AsText() %>" />
                                    <asp:HyperLink ID="hlGoodsCodeUrl" runat="server" NavigateUrl='<%# String.Format("../Goods/GoodsDetail?GoodsModel=&GoodsCode={0}&GroupCode={1}&CategoryCode={2}&BrandName=&GoodsName=&Type=ds", Eval("GoodsCode").AsText(),Eval("GoodsGroupCode").AsText(),Eval("GoodsFinalCategoryCode").AsText()) %>'><%# Eval("GoodsCode").AsText() %></asp:HyperLink><br />
                                    <asp:Label runat="server" ID="lblGoodsDiplayText" Text='<%# SetGoodsDisplayText(Eval("CompanyGoodsYN").AsText(),Eval("GoodsDisplayReason").AsText()) %>' Font-Bold="true" ForeColor="Red"></asp:Label>
                                </td>
                                <td class="align-left">
                                    <asp:HyperLink ID="HyperLink1" runat="server" NavigateUrl='<%# String.Format("../Goods/GoodsDetail?GoodsModel=&GoodsCode={0}&GroupCode={1}&CategoryCode={2}&BrandName=&GoodsName=&Type=ds", Eval("GoodsCode").AsText(),Eval("GoodsGroupCode").AsText(),Eval("GoodsFinalCategoryCode").AsText()) %>'>
                            <span>[ <%# Eval("BrandName").AsText() %> ] </span>
                            <span><%# Eval("GoodsFinalName").AsText() %></span><br />
                            <span> <%# Eval("GoodsOptionSummaryValues").AsText() %></span></asp:HyperLink>
                                    <asp:Label runat="server" ID="lblTax" Visible="false"><br />(면세)</asp:Label>
                                </td>
                                <td style="padding-left: 5px"><%# Eval("GoodsModel").AsText() %></td>
                                <td><%# Eval("GoodsDeliveryOrderDue_Name").AsText() %></td>
                                
                                <td style="width: 90px"><%# Eval("GoodsUnitMoq").AsText() %> / <%# Eval("GoodsUnit_Name").AsText() %></td>

                                <td style="width: 150px; text-align: right; padding-right: 5px;" id="tdDcPrice" runat="server">
                                    <span style="text-decoration: line-through;"><%# String.Format("{0:##,##0;}", Eval("GoodsSalePriceVAT")) %>원</span>&nbsp;
                           <span style="color: red"><%# String.Format("{0:##,##0;}", Eval("GoodsDCPriceVAT")) %>원</span>
                                </td>
                                <td style="width: 90px; text-align: right; padding-right: 5px;" id="tdOriginPrice" runat="server">
                                    <span><%# String.Format("{0:##,##0;}", Eval("GoodsSalePriceVAT")) %>원</span>
                                </td>
                                <td style="width: 60px; padding-left: 6px">
                                    <span class='input-qty' style="width: 49px;">
                                        <asp:TextBox ID="txtGoodsNum" runat="server" Width="35px" flag="qty" MaxLength='4' Onkeypress="return onlyNumbers(event);" value='<%# Eval("Qty").AsText() %>' OnChange="return fnChangeNum(this);"></asp:TextBox>
                                        <a class='input-arrow-up'>
                                            <img src='../Images/inputarrow_up.png' width='9' height='9' class='imgarrowup' /></a>
                                        <a class='input-arrow-down'>
                                            <img src='../Images/inputarrow_down.png' width='9' height='9' class='imgarrowdown' /></a>
                                    </span>

                                    <a>
                                        <img style="padding-top: 4px" src="../Images/Order/change_btn_off.jpg" onmouseover="this.src='../Images/Order/change_btn_on.jpg'" onmouseout="this.src='../Images/Order/change_btn_off.jpg'" alt="변경" id="imgChangeGoodsNum" onclick="fnChangeGoodsNum(this); return false;" /></a>

                                </td>
                                <td style="width: 90px; text-align: right; padding-right: 5px;">
                                    <label id="lbSumPrice"><%# String.Format("{0:##,##0;}",Calculate(Eval("GoodsSalePriceVAT").AsInt(), Eval("Qty").AsInt(), Eval("GoodsDCPriceVAT").AsDecimalNullable())) %></label>원
                            <asp:HiddenField runat="server" ID="hfDcPrice" Value='<%#Eval("GoodsDCPriceVAT").AsDecimalNullable() %>' />
                                </td>
                                <td style="width: 30px;">
                                    <img src="../Images/Wish/icon-delete.jpg" alt="삭제" onclick="fnSingleDelete(this); return false;" />
                                    <input type="hidden" id="hdBudgetFlag" value="" />
                                </td>
                            </tr>
                        </ItemTemplate>
                        <FooterTemplate>
                            <tr id="trEmpty" runat="server" visible="false">
                                <td colspan="15">리스트가 없습니다.</td>
                            </tr>
                        </FooterTemplate>
                    </asp:Repeater>
                </tbody>
            </table>
            <asp:HiddenField runat="server" ID="hfCartNos" />
            <div style="margin-top: 10px;font-size: 12px; font-family: Dotum">
                <span>총 주문 금액 (VAT포함)&nbsp;&nbsp;</span>
                <label id="lbTotalSum" style="color: #ee2248; font-weight: bold"></label>
                원
            &nbsp;&nbsp;
            <a>
                <img src="../Images/Order/reckoning_btn_off.jpg" alt="다시 계산하기" onmouseover="this.src='../Images/Order/reckoning_btn_on.jpg'" onmouseout="this.src='../Images/Order/reckoning_btn_off.jpg'" onclick="fnReCarculate(); return false;" /></a>

                <span style="float: right;">
                    <span style="color: #ee2248; font-weight: bold;">* 50,000원(VAT포함) 이상</span>  구매 시 무료배송
                </span>
            </div>
            <div class="bottom-btn-div">
            </div>
            <div class="left-menu-wrap" id="divLeftMenu">
                <dl>
                    <dt>
                        <strong>주문정보</strong>
                    </dt>
                    <dd class="active">
                        <a href="/Cart/CartList.aspx">장바구니</a>
                    </dd>
                    <dd>
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

    <%--추가견적서 팝업--%>
    <div id="additionPrint" class="popupdiv divpopup-layer-package">
        <div class="popupdivWrapper" style="width: 350px; height: 160px">
            <div class="popupdivContents">

                <div class="close-div">
                    <a onclick="fnClosePopup('additionPrint'); return false;" style="cursor: pointer">
                        <img src="../../Images/Wish/icon-delete.jpg" alt="닫기" style="float: right;" /></a>
                </div>
                
                    <h3>가격비교 견적</h3>
                
                <div class="divpopup-layer-conts">
                    <table id="tblPopupSaleComp" class="board-table" style="margin-top: 0; width: 100%">
                        <tr class="board-tr-height">
                            <td class="text-center">
                                <select id="selectPercent" style="width: 120px">
                                    <option value="1">1%</option>
                                    <option value="2">2%</option>
                                    <option value="3">3%</option>
                                    <option value="4">4%</option>
                                    <option value="5" selected="selected">5%</option>
                                    <option value="6">6%</option>
                                    <option value="7">7%</option>
                                    <option value="8">8%</option>
                                    <option value="9">9%</option>
                                    <option value="10">10%</option>
                                </select>
                            </td>
                            <td class="text-center">
                                <img src="../Images/print-off.jpg" onmouseover="this.src='../Images/print-on.jpg'" onmouseout="this.src='../Images/print-off.jpg'" id="imgAdditionCartReport" onclick="fnAdditionCartReport();" alt=" 출력" style="cursor: pointer" />
                            </td>
                        </tr>
                    </table>

                </div>
            </div>
        </div>
    </div>


    <%-- 가격비교 팝업--%>
    <div id="goodsCompareDiv" class="popupdiv divpopup-layer-package">
        <div class="popupdivWrapper" style="width: 595px; height: 390px">
            <div class="popupdivContents">
                <div class="close-div">
                    <a onclick="fnClosePopup('goodsCompareDiv'); return false;" style="cursor: pointer">
                        <img src="../../Images/Wish/icon-delete.jpg" alt="닫기" style="float: right;" /></a>
                </div>
                
                    <h3>가격비교 견적</h3>
      
                <div class="divpopup-layer-conts">
                    <input type="hidden" id="hdCompareGroupNo" />
                    <input type="hidden" id="hdScompInfoNo" />
                    <input type="hidden" id="hdSaleCompCode" />
                    <table class="tbl_popup" style="margin-top: 0; width: 100%">
                        <thead>
                            <tr>
                                <th style="width: 120px">판매사</th>
                                <th style="width: auto">상품가격합계<br />
                                    (VAT포함)</th>
                                <th style="width: auto">비교결과</th>
                                <th style="width: auto">자동선택</th>
                            </tr>
                        </thead>
                        <tbody id="pop_goodsCompareTbody">
                        </tbody>
                    </table>
                    <!--팝업 컨텐츠 영역끝-->

                </div>
            </div>
            <br />
            <!--팝업 확인 버튼 영역 시작-->
            <div>
                <div style="text-align: left">
                    <span class="cart-goodscompareprice-popuptext">※ 가격비교에 따른 판매사는 TRN정규분포 통계알고리즘기법으로 매일마다 초기화되어 사용됩니다.</span>
                </div>
                <div style="text-align: right; margin-top: 10px; padding-right: 10px;">
                    <input type="button" class="mainbtn type1" style="width: 125px; height: 30px; font-size: 12px;" value="견적서 출력" onclick="return fnCompareCartReportPopup();" />
                    <input type="button" class="mainbtn type2" style="width: 125px; height: 30px; font-size: 12px" value="주문하기" onclick="return fnCompPriceFormCheck();" />
                </div>
            </div>

            <!--팝업 확인 버튼 영역 끝-->
        </div>
        
    </div>
   
</asp:Content>

