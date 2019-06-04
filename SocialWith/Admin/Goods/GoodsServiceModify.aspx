<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Master/AdminMasterPage.master" AutoEventWireup="true" CodeFile="GoodsServiceModify.aspx.cs" Inherits="Admin_Goods_GoodsModify" EnableEventValidation="false" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <link href="../Content/Goods/goods.css" rel="stylesheet" />
    <link href="../Content/Company/company.css" rel="stylesheet" />
    <script type="text/javascript">
        var qs = fnGetQueryStrings();
        var qsGoodsCode;
        $(function () {

            qsGoodsCode = qs["GoodsCode"];
            //카테고리 리스트 바인드(레벨1)
            fnCategoryBind();
            fnGoodsInfoBind();
            fnGoodsOptionBind();//상품옵션 바인딩
            $("#pop_commonTbody").on("mouseover", "tr", function () {

                $("#pop_commonTbody tr").css("cursor", "pointer");
            });

            $("#pop_commonTbody").on("click", "tr", function () {

                //초기화
                $("#hdSelectCode").val('');
                $("#hdSelectName").val('');
                $("#pop_commonTbody tr").css("background-color", "");

                $(this).css("background-color", "#ffe6cc");

                var selectCode = $(this).find("input:hidden[name^='hdCode']").val();
                var selectName = $(this).find("input:hidden[name^='hdName']").val();

                $("#hdSelectCode").val(selectCode);
                $("#hdSelectName").val(selectName);

            });


            //속성수정팝업 로우 클릭
            $("#tblSearchCode_tbody").on("mouseover", "tr", function () {

                $("#pop_commonTbody tr").css("cursor", "pointer");
            });

            $("#tblSearchCode_tbody").on("click", "tr", function () {

                //초기화
                $("#hdSelectOptionCode").val('');
                $("#hdSelectOptionName").val('');
                $("#tblSearchCode_tbody tr").css("background-color", "");

                $(this).css("background-color", "#ffe6cc");

                var selectCode = $(this).find("input:hidden[id ='hdPopupOptionCode']").val();
                var selectName = $(this).find("input:hidden[id ='hdPopupOptionName']").val();

                $("#hdSelectOptionCode").val(selectCode);
                $("#hdSelectOptionName").val(selectName);

            });

            //원산지수정팝업 로우 클릭
            $("#tblSearchOriginCode_tbody").on("mouseover", "tr", function () {

                $("#tblSearchOriginCode_tbody tr").css("cursor", "pointer");
            });

            $("#tblSearchOriginCode_tbody").on("click", "tr", function () {

                //초기화
                $("#hdSelectOriginCode").val('');
                $("#hdSelectOriginName").val('');
                $("#tblSearchOriginCode_tbody tr").css("background-color", "");

                $(this).css("background-color", "#ffe6cc");

                var selectCode = $(this).find("input:hidden[id ='hdPopupOriginCode']").val();
                var selectName = $(this).find("input:hidden[id ='hdPopupOriginName']").val();

                $("#hdSelectOriginCode").val(selectCode);
                $("#hdSelectOriginName").val(selectName);

            });

            //배송비수정팝업 로우 클릭
            $("#tblDeliveryCode_tbody").on("mouseover", "tr", function () {

                $("#tblDeliveryCode_tbody tr").css("cursor", "pointer");
            });

            $("#tblDeliveryCode_tbody").on("click", "tr", function () {

                //초기화
                $("#hdSelectDeliveryCode").val('');
                $("#hdSelectDeliveryName").val('');
                $("#tblDeliveryCode_tbody tr").css("background-color", "");

                $(this).css("background-color", "#ffe6cc");

                var selectCode = $(this).find("input:hidden[id ='hdPopupDeliveryCode']").val();
                var selectName = $(this).find("input:hidden[id ='hdPopupDeliveryName']").val();

                $("#hdSelectDeliveryCode").val(selectCode);
                $("#hdSelectDeliveryName").val(selectName);

            });

            //상품조회 팝업 로우 클릭
            $("#tblGoods_tbody").on("mouseover", "tr", function () {

                $("#tblGoods_tbody tr").css("cursor", "pointer");
            });

            $("#tblGoods_tbody").on("click", "tr", function () {

                //초기화
                $("#hdSelectGoodsCode").val('');
                $("#hdSelectGoodsName").val('');
                $("#tblGoods_tbody tr").css("background-color", "");

                $(this).css("background-color", "#ffe6cc");

                var selectCode = $(this).find("input:hidden[id ='hdPopupGoodsCode']").val();
                var selectName = $(this).find("input:hidden[id ='hdPopupGoodsName']").val();

                $("#hdSelectGoodsCode").val(selectCode);


            });
            setDDLDisplay();

            //콤마처리
            RealTimeComma("ContentPlaceHolder1_txtPurchaseTransportCost1");


            // enter key 방지
            $(document).on("keypress", "#tblGoodsModify input", function (e) {
                if (e.keyCode == 13) {

                    return false;
                }
                else
                    return true;
            });


        });



        // 상품노출여부/비노출사유/판매중단사유 disable처리
        function setDDLDisplay() {

            $("#<%=ddlDisplay.ClientID%>").change(function () {
                var display = $("#<%=ddlDisplay.ClientID%> option:selected").prop("value");
                var noDisplay = $("#<%=ddlNoDisplay.ClientID%> option:selected").prop("value");

                //상품노출여부 노출인경우
                if (display == 1) {
                    $("#<%=ddlNoDisplay.ClientID%>").prop("disabled", "true");
                    $("#<%=ddlNoSale.ClientID%>").prop("disabled", "true");
                    $("#<%=ddlNoDisplay.ClientID%> option:eq(0)").prop("selected", "selected");
                    $("#<%=ddlNoSale.ClientID%> option:eq(0)").prop("selected", "selected");
                } else {
                    $("#<%=ddlNoDisplay.ClientID%>").prop("disabled", "");
                    if (noDisplay != 1) {
                        $("#<%=ddlNoSale.ClientID%>").prop("disabled", "true");
                    } else {//상품노출여부 비노출인경우
                        $("#<%=ddlNoSale.ClientID%>").prop("disabled", "");
                    }
                }


            });

            $("#<%=ddlNoDisplay.ClientID%>").change(function () {
                var noDisplay = $("#<%=ddlNoDisplay.ClientID%> option:selected").prop("value");

                if (noDisplay != 1) {
                    $("#<%=ddlNoSale.ClientID%> option:eq(0)").prop("selected", "selected");
                    $("#<%=ddlNoSale.ClientID%>").prop("disabled", "true");

                } else {
                    $("#<%=ddlNoSale.ClientID%>").prop("disabled", "");
                }
            });

            $("#<%=ddlPurchaseTransportCost1.ClientID%>").change(function () {
                if ($(this).val() == '1') {

                    $("#<%=txtPurchaseTransportCost1.ClientID%>").prop("disabled", "");
                }
                else {

                    $("#<%=txtPurchaseTransportCost1.ClientID%>").prop("disabled", "true");
                }
            });



        }

        //카테고리 리스트 바인드(레벨1)
        function fnCategoryBind() {
            fnSelectBoxClear(1);
            var callback = function (response) {

                if (!isEmpty(response)) {

                    var ddlHtml = "";

                    $.each(response, function (key, value) {

                        ddlHtml += '<option value="' + value.CategoryFinalCode + '">' + value.CategoryFinalName + '</option>';
                    });

                    $("#ContentPlaceHolder1_ddlCategory01").append(ddlHtml);


                }
                return false;
            };

            var sUser = '<%=Svid_User %>';
            var param = {
                LevelCode: '1',
                UpCode: '',
                Method: 'GetCategoryLevelList'
            };

            JajaxSessionCheck('Post', '../../Handler/Common/CategoryHandler.ashx', param, 'json', callback, '<%=Svid_User %>');
        }

        //상위레벨 카테고리 선택시 하위 카테고리 리스트 바인드
        function fnChangeSubCategoryBind(el, level) {

            var selectedVal = $(el).val();

            if (level == '2') {
                var callback = function (response) {
                    if (!isEmpty(response)) {
                        if (response.MdName != '' && response.MdToId != '') {
                            $('#hdMdToId').val(response.MdToId);
                            $('#lbMD').text(response.MdName);
                        }
                    }
                    else {
                        $('#hdMdToId').val('<%= UserInfoObject.Id%>');
                        $('#lbMD').text('<%= UserInfoObject.Name%>');
                    }
                    return false;
                };

                var sUser = '<%=Svid_User %>';
                var param = {
                    CategoryCode: selectedVal,
                    Method: 'GetGoodsMDInfo'
                };

                JajaxSessionCheck('Post', '../../Handler/GoodsHandler.ashx', param, 'json', callback, '<%=Svid_User %>');
            }

            for (var i = level; i < 10; i++) {
                fnSelectBoxClear(i);
            }

            var callback = function (response) {

                if (!isEmpty(response)) {

                    var ddlHtml = "";

                    $.each(response, function (key, value) {
                        ddlHtml += '<option value="' + value.CategoryFinalCode + '">' + value.CategoryFinalName + '</option>';
                    });

                    var id = '';

                    if (level == '10') {
                        id = level;
                    }
                    else {
                        id = '0' + level;
                    }
                    $("#ContentPlaceHolder1_ddlCategory" + id).append(ddlHtml);

                }
                return false;
            };

            var sUser = '<%=Svid_User %>';
            var param = {
                LevelCode: level,
                UpCode: selectedVal,
                Method: 'GetCategoryLevelList'
            };

            JajaxSessionCheck('Post', '../../Handler/Common/CategoryHandler.ashx', param, 'json', callback, '<%=Svid_User %>');

        }

        //디폴트 서브카테고리 바인드
        function fnSubCategoryBind(upcode, code, level) {

            var callback = function (response) {

                if (!isEmpty(response)) {

                    var ddlHtml = "";

                    $.each(response, function (key, value) {
                        ddlHtml += '<option value="' + value.CategoryFinalCode + '">' + value.CategoryFinalName + '</option>';
                    });

                    var id = '';

                    if (level == '10') {
                        id = level;
                    }
                    else {
                        id = '0' + level;
                    }
                    $("#ContentPlaceHolder1_ddlCategory" + id).append(ddlHtml);
                    $("#ContentPlaceHolder1_ddlCategory" + id).val(code);

                }

                return false;
            };

            var sUser = '<%=Svid_User %>';
            var param = {
                LevelCode: level,
                UpCode: upcode,
                Method: 'GetCategoryLevelList'
            };

            JajaxSessionCheck('Post', '../../Handler/Common/CategoryHandler.ashx', param, 'json', callback, '<%=Svid_User %>');

        }


        //카테고리 리스트 클리어
        function fnSelectBoxClear(index) {

            var id = '';

            if (index == '10') {
                id = index;
            }
            else {
                id = '0' + index;
            }


            $("#ContentPlaceHolder1_ddlCategory" + id).empty();
            $("#ContentPlaceHolder1_ddlCategory" + id).append('<option value="All">---전체---</option>');
            return false;

        }


        //상품정보 바인딩
        function fnGoodsInfoBind() {

            var callback = function (value) {
                if (value != null) {
                    $('#divMainContent').css('display', '');
                    //1단계 카테고리 정보 바인딩
                    $("#ContentPlaceHolder1_ddlCategory01").val(value.CategoryParentCodes.split(',')[0]);


                    //하위 카테고리 정보 바인딩
                    for (var i = 1; i <= value.CategoryParentCodes.split(',').length - 1; i++) {
                        fnSubCategoryBind(value.CategoryParentCodes.split(',')[i - 1], value.CategoryParentCodes.split(',')[i], i + 1);
                    }

                    var goodsNoSaleEnterTargetDue = ''

                    if (value.GoodsNoSaleEnterTargetDue != null) {
                        goodsNoSaleEnterTargetDue = value.GoodsNoSaleEnterTargetDue.split("T")[0];
                    }
                    //text바인딩
                    $('#spanEntryDate').text(fnOracleDateFormatConverter(value.EntryDate));
                    $('#spanModifyDate').text(fnOracleDateFormatConverter(value.ModifyDate));
                    $("#lbMD").text(value.MdName); //담당MD
                    $('#hdMdToId').val(value.MdToId);//담당MD아이디
                    $("#<%=txtGoodsUnitMoq.ClientID%>").val(value.GoodsUnitMoq); //MOQ
                    $("#<%=txtGoodsUnitQty.ClientID%>").val(value.GoodsUnitQty); //내용량
                    $("#<%=txtGoodsUnitSubQty.ClientID%>").val(value.GoodsUnitSubQty); //서브내용량
                    $("#<%=txtGoodsSpecial.ClientID%>").val(value.GoodsSpecial); //특징
                    $("#<%=txtGoodsFormat.ClientID%>").val(value.GoodsFormat); //형식

                    $("#<%=txtGoodsCause.ClientID%>").val(value.GoodsCause); //주의사항
                    $("#<%=txtGoodsSupplies.ClientID%>").val(value.GoodsSupplies); //용도
                    $("#<%=txtMdMemo.ClientID%>").val(value.MdMemo); //MD메모
                    <%--$("#<%=txtBrandName.ClientID%>").val(value.BrandName);--%> //브랜드명
                    $("#<%=txtGoodsModel.ClientID%>").val(value.GoodsModel); //모델명
                    $("#<%=txtGoodsFinalName.ClientID%>").val(value.GoodsFinalName); //상품명
                    $("#<%=txtGoodsNoSaleEnterTargetDue.ClientID%>").val(goodsNoSaleEnterTargetDue);  //품절품목입고예정일 

                    $("#<%=txtGoodsBuyPrice.ClientID%>").val(numberWithCommas(value.GoodsBuyPrice)); //매입가격(VAT별도)
                    $("#<%=txtGoodsBuyPriceVat.ClientID%>").val(numberWithCommas(value.GoodsBuyPriceVat)); //매입가격(VAT포함)
                    $("#<%=txtGoodsSalePrice.ClientID%>").val(numberWithCommas(value.GoodsSalePrice)); //구매사판매가격(VAT별도)
                    $("#<%=txtGoodsSalePriceVat.ClientID%>").val(numberWithCommas(value.GoodsSalePriceVat)); //구매사판매가격(VAT포함)
                    $("#<%=txtGoodsCustPrice.ClientID%>").val(numberWithCommas(value.GoodsCustPrice)); //판매사판매가격(VAT별도)
                    $("#<%=txtGoodsCustPriceVat.ClientID%>").val(numberWithCommas(value.GoodsCustPriceVat)); //판매사판매가격(VAT포함)
                    $("#<%=txtGoodsMSalePrice.ClientID%>").val(numberWithCommas(value.GoodsMSalePrice)); //민간구매사판매가격(VAT별도)
                    $("#<%=txtGoodsMSalePriceVat.ClientID%>").val(numberWithCommas(value.GoodsMSalePriceVat)); //민간구매사판매가격(VAT포함)
                    $("#<%=txtGoodsOriginCode.ClientID%>").val(value.GoodsOriginCode + '(' + value.GoodsOriginName + ')'); //원산지코드
                    $("#<%=txtOptionSummaryCode.ClientID%>").val(value.GoodsOptionSummaryCode); //옵션코드

                    $("#<%=txtSupplyCompanyCode1.ClientID%>").val(value.SupplyCompanyCode1); //공급사코드1
                    $("#<%=txtSupplyCompanyName1.ClientID%>").val(value.SupplyCompanyName1); //공급사명1

                    $("#<%=txtSupplyCompanyBarcode1.ClientID%>").val(value.SupplyBarcode1); //공급사바코드1

                    $("#<%=txtSupplyGoodsCode1.ClientID%>").val(value.SupplyGoodsCode1); //공급사상품코드1

                    $("#<%=txtRemindSearch.ClientID%>").val(value.GoodsRemindSearch);  //상품검색어



                    //드롭다운리스트 바인딩

                    var displayFlag = value.GoodsDisplayFlag; //상품노출여부
                    var noDisplayReason = value.GoodsNoDisplayReason; //비노츨사유
                    var noSaleReason = value.GoodsNoSaleReason; //판매중단사유

                    var returnChangeFlag = value.GoodsReturnChangeFlag; //반품(교환)불가여부
                    var saleTaxYN = value.GoodsSaleTaxYN; //판매과세여부
                    var keepYN = value.GoodsKeepYN; //재고관리여부
                    var dCYN = value.GoodsDCYN; //추가DC적용여부
                    var custGubun = value.GoodsCustGubun; //고객사상품구분
                    var deliveryOrderDue = value.GoodsDeliveryOrderDue;//출고예정일
                    var supplyOrderForm = value.SupplyOrderForm;//발주형태
                    var supplyBuyGoodsType = value.SupplyBuyGoodsType;//매입상품유형
                    var supplyGoodsEnterDue = value.SupplyGoodsEnterDue;//입고LeadTime
                    var supplyGoodsDistrAdmin = value.SupplyGoodsDistrAdmin;//상품유통기간 관리여부
                    var supplyBuyCalc = value.SupplyBuyCalc;//매입정산구분
                    var deliveryGubun = value.DeliveryGubun; //배송구분
                    var deliveryCostGubun = value.DeliveryCostGubun; //배송비구분
                    var deliveryCost_Code = value.DeliveryCost_Code; //배송비코드
                    var deliveryCost_Val = value.DeliveryCost_Value; //배송비

                    <%--$("#<%=txtBrandCode.ClientID%>").val(value.BrandCode);--%> //브랜드코드

                    $("#spGoodsCnt").text("(" + value.GoodsCnt + "종)"); //그룹코드N종

                    $("#<%=txtGroupCode.ClientID%>").val(value.GoodsGroupCode); //그룹코드
                    $("#<%=txtGoodsCode.ClientID%>").val(value.GoodsCode); //상품코드
                    $("#<%=txtSupplyBuyGoodsMoq.ClientID%>").val(value.SupplyGoodsUnitMoq);//매입moq
                    $("#<%=txtSupplyGoodsDistrDue.ClientID%>").val(value.SupplyGoodsDistrDue);//상품제조 유통기간
                    $("#<%=ddlSupplyGoodsDistrAdmin.ClientID%>").val(supplyGoodsDistrAdmin);//상품유통기간 관리여부

                    $("#<%=txtBarcode1.ClientID%>").val(value.GoodsSupplyCBarcode1); //공통바코드(Qty바코드)
                    $("#<%=txtBarcode2.ClientID%>").val(value.GoodsSupplyCBarcode2); //공통바코드(In바코드)
                    $("#<%=txtBarcode3.ClientID%>").val(value.GoodsSupplyCBarcode3); //공통바코드(Out바코드)

                    var unitName = "";
                    var unitSubName = "";

                    if (value.GoodsUnit != "") {
                        unitName = "(" + value.GoodsUnitName + ")";
                    }

                    if (value.GoodsSubUnit != "") {
                        unitSubName = "(" + value.GoodsSubUnitName + ")";
                    }

                    $("#<%=txtQtyCode.ClientID%>").val(value.GoodsUnit + unitName);//단위코드
                    $("#<%=txtSupplyCompUnitCode.ClientID%>").val(value.GoodsUnit + unitName); //단위코드(공급사관련)
                    $("#<%=txtSubQtyCode.ClientID%>").val(value.GoodsSubUnit + unitSubName);//서브단위코드

                    $("#<%=txtDeliveryGubunCode.ClientID%>").val(deliveryCost_Code + ' (' + numberWithCommas(deliveryCost_Val) + '원)');
                    $("#<%=ddlDCYN.ClientID%>").val(dCYN); //dc여부
                    $("#<%=ddlsaleTaxYN.ClientID%>").val(saleTaxYN); //과세여부


                    //상품인증구분
                    var gdsConfirmMark = value.GoodsConfirmMark;

                    for (var i = 0; i < gdsConfirmMark.length; i++) {
                        var ckbEl = $("input:checkbox[id='cbCertified" + (i + 1) + "']");
                        var markVal = gdsConfirmMark.charAt(i);

                        if (markVal == "1") {
                            $(ckbEl).prop("checked", true);
                        } else {
                            $(ckbEl).prop("checked", false);
                        }
                    }

                    //각 공급사별 매입운송비유무 및 매입운송비용
                    var suppTransCostYN1 = value.SupplyTransCostYN;
                    var suppTransCostVat1 = value.SupplyTransCostVat;


                    $("#<%=ddlPurchaseTransportCost1.ClientID %>").val(suppTransCostYN1);


                    //공급사
                    if (suppTransCostYN1 == "1") {
                        $("#<%=txtPurchaseTransportCost1.ClientID%>").val(numberWithCommas(suppTransCostVat1));
                        $("#<%=txtPurchaseTransportCost1.ClientID%>").prop("disabled", "");

                    } else {
                        $("#<%=txtPurchaseTransportCost1.ClientID %>").val('');
                        $("#<%=txtPurchaseTransportCost1.ClientID%>").prop("disabled", true);
                    }



                    //이미지바인딩
                    var finalCode = value.GoodsFinalCategoryCode;
                    var goodsCode = value.GoodsCode;
                    var groupCode = value.GoodsGroupCode;
                    var goodsName = value.GoodsFinalName;

                    $('#<%= hdfinalCode.ClientID%>').val(finalCode);
                    $('#<%= hdgroupCode.ClientID%>').val(groupCode);
                    $('#<%= hdgoodsCode.ClientID%>').val(goodsCode);

                    //8 입고리드타임 supplyGoodsEnterDue
                    //9 매입정산구분 supplyBuyCalc
                    //10 매입정산구분 supplyOrderForm
                    var list = "1,2,3,4,5,6,7,10,11,8,9,12,13"; //channel번호
                    var flag = deliveryOrderDue + "," + displayFlag + "," + noDisplayReason + "," + noSaleReason + "," + returnChangeFlag + "," + keepYN + ","
                        + custGubun + "," + supplyOrderForm + "," + supplyBuyGoodsType + "," + supplyGoodsEnterDue + ","
                        + supplyBuyCalc + "," + deliveryGubun + "," + deliveryCostGubun;


                    fnGetComm("GOODS", list, flag);

                }

                return false;
            }
            var goodsCode = '';
            if (isEmpty($("#hdSelectGoodsCode").val())) {
                goodsCode = qsGoodsCode;

            }
            else {
                goodsCode = $("#hdSelectGoodsCode").val();
            }

            var param = { Method: 'GetAdminGoodsUpdateInfo', GoodsCode: goodsCode };

            Jajax('Post', '../../Handler/GoodsHandler.ashx', param, 'json', callback);

        }


        //드롭다운리스트 바인딩
        function fnGetComm(code, channel, flag) {
            var callback = function (response) {

                var createHtml = null;
                var channelNum = null;
                var flagName = null;

                if (!isEmpty(response)) {
                    $.each(response, function (key, value) {

                        switch (key) {

                            case "comm_0":

                                $('#ContentPlaceHolder1_ddlDueDate').empty();

                                channelNum = channel.split(',')[0];
                                flagName = flag.split(',')[0];

                                for (var i = 1; i < value.length; i++) {
                                    createHtml = '<option value="' + value[i].Map_Type + '">' + value[i].Map_Name + '</option>';
                                    $('#ContentPlaceHolder1_ddlDueDate').append(createHtml);

                                    if (value.length - 1 == i) {
                                        initDDLValue("ContentPlaceHolder1_ddlDueDate", value.length - 1, flagName);
                                    }
                                }
                                break;

                            case "comm_1":

                                $('#ContentPlaceHolder1_ddlDisplay').empty();

                                channelNum = channel.split(',')[1];
                                flagName = flag.split(',')[1];

                                for (var i = 1; i < value.length; i++) {
                                    createHtml = '<option value="' + value[i].Map_Type + '">' + value[i].Map_Name + '</option>';
                                    $('#ContentPlaceHolder1_ddlDisplay').append(createHtml);

                                    if (value.length - 1 == i) {
                                        initDDLValue("ContentPlaceHolder1_ddlDisplay", value.length - 1, flagName);
                                    }
                                }
                                break;

                            case "comm_2":

                                $('#ContentPlaceHolder1_ddlNoDisplay').empty();

                                channelNum = channel.split(',')[2];
                                flagName = flag.split(',')[2];

                                for (var i = 1; i < value.length; i++) {
                                    createHtml = '<option value="' + value[i].Map_Type + '">' + value[i].Map_Name + '</option>';
                                    $('#ContentPlaceHolder1_ddlNoDisplay').append(createHtml);

                                    if (value.length - 1 == i) {
                                        initDDLValue("ContentPlaceHolder1_ddlNoDisplay", value.length - 1, flagName);

                                        //초기 disable설정
                                        var display = $("#<%=ddlDisplay.ClientID%> option:selected").prop("value");

                                        if (display == 1) {
                                            $("#<%=ddlNoDisplay.ClientID%> option:eq(0)").prop("selected", "selected");
                                            $("#<%=ddlNoDisplay.ClientID%>").prop("disabled", "true");
                                        }
                                    }
                                }
                                break;

                            case "comm_3": //판매중단사유

                                $('#ContentPlaceHolder1_ddlNoSale').empty();

                                channelNum = channel.split(',')[3];
                                flagName = flag.split(',')[3];

                                for (var i = 1; i < value.length; i++) {
                                    createHtml = '<option value="' + value[i].Map_Type + '">' + value[i].Map_Name + '</option>';
                                    $('#ContentPlaceHolder1_ddlNoSale').append(createHtml);

                                    if (value.length - 1 == i) {
                                        initDDLValue("ContentPlaceHolder1_ddlNoSale", value.length - 1, flagName);

                                        //초기 disable설정
                                        var display = $("#<%=ddlDisplay.ClientID%> option:selected").prop("value");
                                        if (display == 1) {
                                            $("#<%=ddlNoSale.ClientID%> option:eq(0)").prop("selected", "selected");
                                            $("#<%=ddlNoSale.ClientID%>").prop("disabled", "true");
                                        }
                                        var noDisplay = $("#<%=ddlNoDisplay.ClientID%> option:selected").prop("value");

                                        if (noDisplay != 1) {
                                            $("#<%=ddlNoSale.ClientID%>").prop("disabled", "true");
                                        }
                                    }
                                }
                                break;

                            case "comm_4":

                                $('#ContentPlaceHolder1_ddlReturnChange').empty();

                                channelNum = channel.split(',')[4];
                                flagName = flag.split(',')[4];

                                for (var i = 1; i < value.length; i++) {
                                    createHtml = '<option value="' + value[i].Map_Type + '">' + value[i].Map_Name + '</option>';
                                    $('#ContentPlaceHolder1_ddlReturnChange').append(createHtml);

                                    if (value.length - 1 == i) {
                                        initDDLValue("ContentPlaceHolder1_ddlReturnChange", value.length - 1, flagName);
                                    }
                                }
                                break;

                            case "comm_5":

                                $('#ContentPlaceHolder1_ddlGoodsKeepYN').empty();

                                channelNum = channel.split(',')[5];
                                flagName = flag.split(',')[5];

                                for (var i = 1; i < value.length; i++) {
                                    createHtml = '<option value="' + value[i].Map_Type + '">' + value[i].Map_Name + '</option>';
                                    $('#ContentPlaceHolder1_ddlGoodsKeepYN').append(createHtml);

                                    if (value.length - 1 == i) {
                                        initDDLValue("ContentPlaceHolder1_ddlGoodsKeepYN", value.length - 1, flagName);
                                    }
                                }
                                break;

                            case "comm_6":

                                $('#ContentPlaceHolder1_ddlGoodsGubun').empty();

                                channelNum = channel.split(',')[6];
                                flagName = flag.split(',')[6];

                                for (var i = 1; i < value.length; i++) {
                                    createHtml = '<option value="' + value[i].Map_Type + '">' + value[i].Map_Name + '</option>';
                                    $('#ContentPlaceHolder1_ddlGoodsGubun').append(createHtml);

                                    if (value.length - 1 == i) {
                                        initDDLValue("ContentPlaceHolder1_ddlGoodsGubun", value.length - 1, flagName);
                                    }
                                }
                                break;
                            case "comm_7":  //발주형태

                                $('#ContentPlaceHolder1_ddlOrderForm').empty();


                                channelNum = channel.split(',')[7];
                                flagName = flag.split(',')[7];


                                for (var i = 1; i < value.length; i++) {
                                    createHtml = '<option value="' + value[i].Map_Type + '">' + value[i].Map_Name + '</option>';
                                    $('#ContentPlaceHolder1_ddlOrderForm').append(createHtml);

                                    if (value.length - 1 == i) {
                                        initDDLValue("ContentPlaceHolder1_ddlOrderForm", value.length - 1, flagName);

                                    }
                                }
                                break;
                            case "comm_8":  //매입상품유형

                                $('#ContentPlaceHolder1_ddlSupplyBuyGoodsType').empty();

                                channelNum = channel.split(',')[8];
                                flagName = flag.split(',')[8];

                                for (var i = 1; i < value.length; i++) {
                                    createHtml = '<option value="' + value[i].Map_Type + '">' + value[i].Map_Name + '</option>';
                                    $('#ContentPlaceHolder1_ddlSupplyBuyGoodsType').append(createHtml);

                                    if (value.length - 1 == i) {
                                        initDDLValue("ContentPlaceHolder1_ddlSupplyBuyGoodsType", value.length - 1, flagName);
                                    }
                                }
                                break;
                            case "comm_9":  //입고LeadTime

                                $('#ContentPlaceHolder1_ddlSupplyGoodsEnterDue').empty();


                                channelNum = channel.split(',')[9];
                                flagName = flag.split(',')[9];


                                for (var i = 1; i < value.length; i++) {
                                    createHtml = '<option value="' + value[i].Map_Type + '">' + value[i].Map_Name + '</option>';
                                    $('#ContentPlaceHolder1_ddlSupplyGoodsEnterDue').append(createHtml);


                                    if (value.length - 1 == i) {
                                        initDDLValue("ContentPlaceHolder1_ddlSupplyGoodsEnterDue", value.length - 1, flagName);

                                    }
                                }
                                break;
                            case "comm_10":  //매입정산구분

                                $('#ContentPlaceHolder1_ddlSupplyBuyCalc').empty();


                                channelNum = channel.split(',')[10];
                                flagName = flag.split(',')[10];
                                flagName2 = flag.split(',')[14];
                                flagName3 = flag.split(',')[17];

                                for (var i = 1; i < value.length; i++) {
                                    createHtml = '<option value="' + value[i].Map_Type + '">' + value[i].Map_Name + '</option>';
                                    $('#ContentPlaceHolder1_ddlSupplyBuyCalc').append(createHtml);


                                    if (value.length - 1 == i) {

                                        initDDLValue("ContentPlaceHolder1_ddlSupplyBuyCalc", value.length - 1, flagName);

                                    }
                                }
                                break;
                            case "comm_11":  //배송구분

                                $('#ContentPlaceHolder1_ddlDeliveryGubun').empty();

                                channelNum = channel.split(',')[11];
                                flagName = flag.split(',')[11];

                              //  for (var i = 1; i < value.length; i++) {
                                    createHtml = '<option value="' + value[6].Map_Type + '">' + value[6].Map_Name + '</option>';
                                    $('#ContentPlaceHolder1_ddlDeliveryGubun').append(createHtml);

                                    if (value.length - 1 == i) {
                                        initDDLValue("ContentPlaceHolder1_ddlDeliveryGubun", value.length - 1, flagName);
                                    }
                               // }
                                break;
                            case "comm_12":  //배송비구분

                                $('#ContentPlaceHolder1_ddlDeliveryCostGubun').empty();

                                channelNum = channel.split(',')[12];
                                flagName = flag.split(',')[12];

                                for (var i = 1; i < value.length; i++) {
                                    createHtml = '<option value="' + value[i].Map_Type + '">' + value[i].Map_Name + '</option>';
                                    $('#ContentPlaceHolder1_ddlDeliveryCostGubun').append(createHtml);

                                    if (value.length - 1 == i) {
                                        initDDLValue("ContentPlaceHolder1_ddlDeliveryCostGubun", value.length - 1, flagName);
                                    }
                                }
                                break;
                        }
                    });
                } else {
                    alert("오류가 발생했습니다. 잠시 후 다시 시도해 주세요.");
                }

                return false;

            }

            var param = { Method: 'GetCommMultiList', Code: code, Channel: channel };

            JajaxSessionCheck('Post', '../../Handler/Common/CommHandler.ashx', param, 'json', callback, '<%=Svid_User%>');
        }

        // 드롭다운리스트 초기selected 세팅
        function initDDLValue(ddlName, arrNum, selectNum) {
            if (selectNum == 0 || selectNum == 'null') {


                $("#" + ddlName).prepend("<option value='0'>--해당없음--</option>");
                $("#" + ddlName + " option:eq(0)").prop("selected", "true");
            }

            else {
                $("#" + ddlName).prepend("<option value='0'>--해당없음--</option>");
                $("#" + ddlName + "").val(selectNum);

            }

        }

        function fnSaleTaxYN(event) {
            var ddlsaleTaxYN = $(event).val();
            var goodsBuyPrice = $("#ContentPlaceHolder1_txtGoodsBuyPrice").val();
            var goodsCustPrice = $("#ContentPlaceHolder1_txtGoodsCustPrice").val();
            var goodsSalePrice = $("#ContentPlaceHolder1_txtGoodsSalePrice").val();
            var goodsMSalePrice = $("#ContentPlaceHolder1_txtGoodsMSalePrice").val();
            goodsBuyPrice = goodsBuyPrice.replace(/[^\d]+/g, ''); // (,)지우기    
            goodsCustPrice = goodsCustPrice.replace(/[^\d]+/g, ''); // (,)지우기    
            goodsSalePrice = goodsSalePrice.replace(/[^\d]+/g, ''); // (,)지우기    
            goodsMSalePrice = goodsMSalePrice.replace(/[^\d]+/g, ''); // (,)지우기    

            if (ddlsaleTaxYN == 1) {
                var txtGoodsBuyPriceVat = goodsBuyPrice * 1.1; //매입가격(VAT포함)     
                var txtGoodsCustPriceVat = goodsCustPrice * 1.1; //매입가격(VAT포함) 
                var txtGoodsSalePriceVat = goodsSalePrice * 1.1; //매입가격(VAT포함) 
                var txtGoodsMSalePriceVat = goodsMSalePrice * 1.1; //매입가격(VAT포함) 


                txtGoodsBuyPriceVat = roundXL(txtGoodsBuyPriceVat, 0);
                txtGoodsCustPriceVat = roundXL(txtGoodsCustPriceVat, -1);
                txtGoodsSalePriceVat = roundXL(txtGoodsSalePriceVat, -1);
                txtGoodsMSalePriceVat = roundXL(txtGoodsMSalePriceVat, -1);
            } else {
                txtGoodsBuyPriceVat = goodsBuyPrice;
                txtGoodsCustPriceVat = goodsCustPrice;
                txtGoodsSalePriceVat = goodsSalePrice;
                txtGoodsMSalePriceVat = goodsMSalePrice;
            }
            $("#hdGoodsBuyPriceVat").val(txtGoodsBuyPriceVat);
            $("#hdGoodsCustPriceVat").val(txtGoodsCustPriceVat);
            $("#hdGoodsSalePriceVat").val(txtGoodsSalePriceVat);
            $("#hdGoodsMSalePriceVat").val(txtGoodsMSalePriceVat);

            $("#ContentPlaceHolder1_txtGoodsBuyPriceVat").val(numberWithCommas(txtGoodsBuyPriceVat));
            $("#ContentPlaceHolder1_txtGoodsCustPriceVat").val(numberWithCommas(txtGoodsCustPriceVat));
            $("#ContentPlaceHolder1_txtGoodsSalePriceVat").val(numberWithCommas(txtGoodsSalePriceVat));
            $("#ContentPlaceHolder1_txtGoodsMSalePriceVat").val(numberWithCommas(txtGoodsMSalePriceVat));

        }

        //RealTime Comma
        function fnAutoComma(event) {
            var ddlsaleTaxYN = $("#ContentPlaceHolder1_ddlsaleTaxYN").val();
            var id = $(event).prop('id');


            if (id == 'ContentPlaceHolder1_txtGoodsSalePrice') {
                var goodsSalePrice = $(event).val(); //구매가 값

                goodsSalePrice = goodsSalePrice.replace(/[^\d]+/g, ''); // (,)지우기          
                if (ddlsaleTaxYN == 1) {
                    var txtGoodsSalePriceVat = goodsSalePrice * 1.1; //구매사(VAT별도)         
                    txtGoodsSalePriceVat = roundXL(txtGoodsSalePriceVat, -1);
                } else {
                    txtGoodsSalePriceVat = goodsSalePrice;
                }
                var goodsCustPrice2 = goodsSalePrice * 0.99 // -1%

                $("#hdGoodsSalePriceVat").val(txtGoodsSalePriceVat);
                $("#ContentPlaceHolder1_txtGoodsSalePriceVat").val(numberWithCommas(txtGoodsSalePriceVat)); //구매사 판매가격(VAT포함)
                $(event).val(numberWithCommas(goodsSalePrice));


                $("#ContentPlaceHolder1_txtGoodsMSalePrice").val(numberWithCommas(goodsSalePrice)); //민간 (구매사랑 같게)
                var goodsMSalePrice = goodsSalePrice //구매가
                goodsMSalePrice = goodsMSalePrice.replace(/[^\d]+/g, ''); // (,)지우기          
                if (ddlsaleTaxYN == 1) {
                    var txtGoodsMSalePriceVat = goodsMSalePrice * 1.1; //판매사가격(VAT계산)         
                    txtGoodsMSalePriceVat = roundXL(txtGoodsMSalePriceVat, -1);
                } else {
                    txtGoodsMSalePriceVat = goodsMSalePrice;
                }
                $("#hdGoodsMSalePriceVat").val(txtGoodsMSalePriceVat);
                $("#ContentPlaceHolder1_txtGoodsMSalePriceVat").val(numberWithCommas(txtGoodsMSalePriceVat)); //민간구매 VAT 포함


                $("#ContentPlaceHolder1_txtGoodsCustPrice").val(numberWithCommas(goodsCustPrice2)); //판매가 (구매사가격에서 -1%)

                var goodsCustPrice = goodsCustPrice2

                if (ddlsaleTaxYN == 1) {
                    var txtGoodsCustPriceVat = goodsCustPrice * 1.1; //판매가가격(VAT계산)         
                    txtGoodsCustPriceVat = roundXL(txtGoodsCustPriceVat, -1);
                } else {
                    txtGoodsCustPriceVat = goodsCustPrice;
                }
                $("#hdGoodsCustPriceVat").val(txtGoodsCustPriceVat);
                $("#ContentPlaceHolder1_txtGoodsCustPriceVat").val(numberWithCommas(txtGoodsCustPriceVat)); //판매가 부가세포함


                var goodsBuyPrice2 = goodsCustPrice2 * 0.99; //판매가-1% 매입가 넣어주기 
                goodsBuyPrice2 = roundXL(goodsBuyPrice2, 0);
                $("#ContentPlaceHolder1_txtGoodsBuyPrice").val(numberWithCommas(goodsBuyPrice2)); //매입가 (판매가에서 -1%)

                var goodsBuyPrice = goodsBuyPrice2 //매입가 넣어주기
                if (ddlsaleTaxYN == 1) {
                    var txtGoodsBuyPriceVat = goodsBuyPrice * 1.1; //매입가격(VAT포함)         
                    txtGoodsBuyPriceVat = roundXL(txtGoodsBuyPriceVat, 0);
                } else {
                    txtGoodsBuyPriceVat = goodsBuyPrice;
                }
                $("#hdGoodsBuyPriceVat").val(txtGoodsBuyPriceVat);
                $("#ContentPlaceHolder1_txtGoodsBuyPriceVat").val(numberWithCommas(txtGoodsBuyPriceVat)); //매입가 부가세포함

            }

        }

        function roundXL(num, digits) {
            digits = Math.pow(10, digits);
            return Math.round(num * digits) / digits;
        };

        function commonPopUp(event) {

            $("#txtSearch").val(""); //초기화       
            $("#divSubTitle").empty();
            $("#divSelectBox").empty();
            $("#txtSearch").prop('placeholder', '');

            $('.divScr').css({
                'width': '100 %',
                'height': '450px',
                'overflow-y': 'hidden'
            });

            $('#txtSearch, #btnSearch').css({
                'display': 'inline',
            });

            var id = $(event).attr('id');
            var title = '';
            var createHtml = '';
            var code = '';
            if (id == 'groupCode') {
                code = $("#ContentPlaceHolder1_txtGoodsCode").val();
                if (code == '') {
                    alert('먼저 상품을 검색해 주세요.');
                    return false;
                }
                title = "<h3 class='pop-title' id='srcGroupCode'>그룹코드 검색</h3>";

                $("#thCode").text("그룹코드");
                $("#thName").text("상품명");

                createHtml += '<select id="selectTarget">';
                createHtml += '<option value="' + "Code" + '">' + "상품코드" + '</option>';
                createHtml += '<option value="' + "Name" + '">' + "상품명" + '</option>';
                createHtml += '</select>';

            //} else if (id == 'brandCode') {

            //    code = $("#ContentPlaceHolder1_txtBrandCode").val();

            //    title = "<h3 class='pop-title' id='srcBrandCode'>브랜드코드 검색</h3>";

            //    $("#thCode").text("브랜드코드");
            //    $("#thName").text("브랜드명");

            //    createHtml += '<select id="selectTarget">';
            //    createHtml += '<option value="' + "Code" + '">' + "브랜드코드" + '</option>';
            //    createHtml += '<option value="' + "Name" + '">' + "브랜드명" + '</option>';
            //    createHtml += '</select>';
            } else if (id == 'UnitCode') {
                $('#txtSearch, #btnSearch').css({
                    'display': 'none',
                });

                code = $("#ContentPlaceHolder1_txtQtyCode").val();

                title = "<h3 class='pop-title' id='srcQtyCode'>단위코드 검색</h3>";

                $("#thCode").text("단위코드");
                $("#thName").text("단위코드명");


            } else if (id == 'SubUnitCode') {
                $('#txtSearch, #btnSearch').css({
                    'display': 'none',
                });

                code = $("#ContentPlaceHolder1_txtSubQtyCode").val();

                title = "<h3 class='pop-title' id='srcSubQtyCode'>서브단위코드 검색</h3>";

                $("#thCode").text("서브단위코드");
                $("#thName").text("서브단위코드명");

            }
            else if (id == 'SupplyUnitCode') {
                $('#txtSearch, #btnSearch').css({
                    'display': 'none',
                });

                code = $("#ContentPlaceHolder1_txtSupplyCompUnitCode").val();

                title = "<h3 class='pop-title' id='srcQtyCode'>단위코드 검색</h3>";

                $("#thCode").text("단위코드");
                $("#thName").text("단위코드명");


            }
            else if (id == 'CompCode') {

                code = $("#ContentPlaceHolder1_txtCompCode").val();
                var hdName = $("#hdSelectName").val();

                title = "<h3 class='pop-title' id='srcCompCode'>특정판매 고객사코드 검색</h3>";

                if (code != '') {
                    $("#txtSearch").val(hdName);
                } else {
                    $("#txtSearch").prop('placeholder', '판매사명');
                }

                $("#thCode").text("회사코드");
                $("#thName").text("회사명");
            } else if (id == 'supplyCompanyCode1') {

                code = $("#ContentPlaceHolder1_txtSupplyCompanyCode1").val();
                var hdName = $("#hdSelectName").val();

                title = "<h3 class='pop-title' id='srcSupplyCompanyCode1'>공급사코드(1)</h3>";

                $("#thCode").text("공급사코드");
                $("#thName").text("공급사명");

                createHtml += '<select id="selectTarget">';
                createHtml += '<option value="' + "Code" + '">' + "공급사코드" + '</option>';
                createHtml += '<option value="' + "Name" + '">' + "공급사명" + '</option>';
                createHtml += '</select>';
            }


            if (id != 'CompCode') {
                $("#txtSearch").val(code);
            }

            $("#txtCode").val(id);
            $("#divSubTitle").append(title);
            $("#divSelectBox").append(createHtml);

            fnSearch(1);



            fnOpenDivLayerPopup('CodeSearchDiv');

            return false;
        }



        function fnConfirm() {
            var hdCode = $("#hdSelectCode").val();
            var hdName = $("#hdSelectName").val();
            var id = $("#txtCode").val();

            var check = fnPopupSelect_Check();
            if (check) {
                <%--if (id == 'brandCode') {
                    $("#ContentPlaceHolder1_txtBrandCode").val(hdCode);
                    $("#<%=txtBrandName.ClientID%>").val(hdName);
                } else--%>
                if (id == 'groupCode') {
                    $("#ContentPlaceHolder1_txtGroupCode").val(hdCode);
                } else if (id == 'UnitCode') {
                    $("#ContentPlaceHolder1_txtQtyCode").val(hdCode + "(" + hdName + ")");
                } else if (id == 'SubUnitCode') {
                    $("#ContentPlaceHolder1_txtSubQtyCode").val(hdCode + "(" + hdName + ")");
                }
                else if (id == 'SupplyUnitCode') {
                    $("#ContentPlaceHolder1_txtSupplyCompUnitCode").val(hdCode + "(" + hdName + ")");
                }
                else if (id == 'CompCode') {
                    $("#ContentPlaceHolder1_txtCompCode").val(hdCode);
                } else if (id == 'supplyCompanyCode1') {
                    $("#ContentPlaceHolder1_txtSupplyCompanyCode1").val(hdCode);
                    $("#<%=txtSupplyCompanyName1.ClientID%>").val(hdName);
                }
                fnOpenDivLayerPopup('CodeSearchDiv');
            }
        }

        //팝업선택 안했을 때 체크
        function fnPopupSelect_Check() {

            var cnt = 0;

            $('#tblSearch tbody tr').each(function (index, element) {
                var bgColor = $(this).css("background-color");
                //alert(bgColor)
                if (bgColor == 'rgb(255, 230, 204)') {
                    ++cnt;
                }
            });

            if (cnt == 0) {
                alert('코드를 선택해 주세요.');
                return false;
            }

            return true;
        }

        //팝업창 검색
        function fnSearch(pageNo) {

            var txtSearch = $("#txtSearch").val();

            //var title = $("#divSubTitle").children().prop('alt');
            var popup_Id = $("#divSubTitle").children().prop('id');

            fnPopupCodeValidation(txtSearch, popup_Id);

            var searchTarget = $("#selectTarget option:selected").val();
            var pageSize = 15;
            var asynTable = "";
            var i = 1;

            var callback = function (response) {


                if (!isEmpty(response)) {
                    $("#tblSearch tbody").empty();
                    $.each(response, function (key, value) {
                        $('#hdTotalCount').val(value.TotalCount);


                        if (popup_Id == 'srcGroupCode') {

                            asynTable += "<tr>";
                            asynTable += "<td class='txt-center'>" + (pageSize * (pageNo - 1) + i) + "</td>";
                            asynTable += "<td class='txt-center' id='tdGoodsGroupCode'><input type='hidden' name='hdCode' value='" + value.GoodsGroupCode + "' />" + value.GoodsGroupCode + "</td>";
                            asynTable += "<td class='txt-center' id='tdGoodsFinalName'><input type='hidden' name='hdName' value='" + value.GoodsFinalName + "' />" + value.GoodsFinalName + "</td>";
                            asynTable += "</tr>";
                            i++;

                        //} else if (popup_Id == 'srcBrandCode') {

                        //    asynTable += "<tr>";
                        //    asynTable += "<td class='txt-center'>" + (pageSize * (pageNo - 1) + i) + "</td>";
                        //    asynTable += "<td class='txt-center' id='tdGoodsGroupCode'><input type='hidden' name='hdCode' value='" + value.BrandCode + "' />" + value.BrandCode + "</td>";
                        //    asynTable += "<td class='txt-center' id='tdGoodsFinalName'><input type='hidden' name='hdName' value='" + value.BrandName + "' />" + value.BrandName + "</td>";
                        //    asynTable += "</tr>";
                        //    i++;

                        } else if (popup_Id == 'srcCompCode') {
                            asynTable += "<tr>";
                            asynTable += "<td class='txt-center'>" + (pageSize * (pageNo - 1) + i) + "</td>";
                            asynTable += "<td class='txt-center' id='tdGoodsGroupCode'><input type='hidden' name='hdCode' value='" + value.Company_Code + "' />" + value.Company_Code + "</td>";
                            asynTable += "<td class='txt-center' id='tdGoodsFinalName'><input type='hidden' name='hdName' value='" + value.Company_Name + "' />" + value.Company_Name + "</td>";
                            asynTable += "</tr>";
                            i++;

                        } else if (popup_Id == 'srcQtyCode' || popup_Id == 'srcSubQtyCode') {

                            $('.divScr').css({
                                'width': '100 %',
                                'height': '443px',
                                'overflow-y': 'scroll',
                            });
                            asynTable += "<tr>";
                            asynTable += "<td class='txt-center'>" + (pageSize * (pageNo - 1) + i) + "</td>";
                            asynTable += "<td class='txt-center' id='tdGoodsGroupCode'><input type='hidden' name='hdCode' value='" + value.GoodsUnitCode + "' />" + value.GoodsUnitCode + "</td>";
                            asynTable += "<td class='txt-center' id='tdGoodsFinalName'><input type='hidden' name='hdName' value='" + value.GoodsUnitName + "' />" + value.GoodsUnitName + "</td>";
                            asynTable += "</tr>";
                            i++;

                        } else if (popup_Id == 'srcSupplyCompanyCode1') {
                            asynTable += "<tr>";
                            asynTable += "<td class='txt-center'>" + (pageSize * (pageNo - 1) + i) + "</td>";
                            asynTable += "<td class='txt-center' id='tdGoodsGroupCode'><input type='hidden' name='hdCode' value='" + value.SupplyCompanyCode + "' />" + value.SupplyCompanyCode + "</td>";
                            asynTable += "<td class='txt-center' id='tdGoodsFinalName'><input type='hidden' name='hdName' value='" + value.SupplyCompanyName + "' />" + value.SupplyCompanyName + "</td>";
                            asynTable += "</tr>";
                            i++;
                        }


                    });
                } else {
                    asynTable += "<tr><td colspan='3' class='txt-center'>" + "조회된 데이터가 없습니다." + "</td></tr>"
                    $("#hdTotalCount").val(0);
                }
                $("#tblSearch tbody").append(asynTable);

                //페이징
                fnCreatePagination('pagination', $("#hdTotalCount").val(), pageNo, 15, getPageData);
                return false;
            }

            var sUser = '<%= Svid_User%>';

            if (popup_Id == 'srcGroupCode') {

                param = { SvidUser: sUser, Method: 'GetAdminGoodsGroupCodeList', Keyword: txtSearch, Target: searchTarget, PageNo: pageNo, PageSize: pageSize };
                JajaxSessionCheck('Post', '../../Handler/GoodsHandler.ashx', param, 'json', callback, sUser);

            //} else if (popup_Id == 'srcBrandCode') {

            //    searchTarget = searchTarget.toUpperCase(); //대문자로 바꾸기           
            //    param = { SvidUser: sUser, Method: 'BrandList_Admin', SearchKeyword: txtSearch, SearchTarget: searchTarget, PageNo: pageNo, PageSize: pageSize };
            //    JajaxSessionCheck('Post', '../../Handler/Common/BrandHandler.ashx', param, 'json', callback, sUser);

            } else if (popup_Id == 'srcQtyCode' || popup_Id == 'srcSubQtyCode') {

                param = { SvidUser: sUser, Method: 'GetGoodsUnitList' };
                JajaxSessionCheck('Post', '../../Handler/GoodsHandler.ashx', param, 'json', callback, sUser);

            } else if (popup_Id == 'srcCompCode') {

                param = { SvidUser: sUser, Flag: 'GetSaleCompanyList', Keyword: txtSearch, PageNo: pageNo, PageSize: pageSize };
                JajaxSessionCheck('Post', '../../Handler/Admin/CompanyHandler.ashx', param, 'json', callback, sUser);

            } else if (popup_Id == 'srcSupplyCompanyCode1') {

                param = { SvidUser: sUser, Flag: 'GetSupplyCompanyList', Keyword: txtSearch, Target: searchTarget, PageNo: pageNo, PageSize: pageSize };
                JajaxSessionCheck('Post', '../../Handler/Admin/CompanyHandler.ashx', param, 'json', callback, sUser);

            }


        }

        //페이징 인덱스 클릭시 데이터 바인딩
        function getPageData() {
            var container = $('#pagination');
            var getPageNum = container.pagination('getSelectedPageNum');
            fnSearch(getPageNum);
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

        function fnPopupCodeValidation(txt1, txt2) {

            var target = $("#selectTarget").val();

            if ((txt1.length == 0 || txt1 == '') && txt2 == 'srcGroupCode') {
                alert('검색창에 입력해 주세요.');
                //txt1.focus();
                return false;
            }

            if (txt1.length != 7 && (target == 'Code') && (txt2 == 'srcGroupCode')) {
                alert('7자리의 코드를 입력해 주세요.');
                //txt1.focus();
                return false;
            }
        }

        //상품옵션 바인딩
        function fnGoodsOptionBind() {

            //초기화
            for (var j = 1; j <= 20; j++) {
                $('#ContentPlaceHolder1_txtOptionName_' + j).val('');
                $('#ContentPlaceHolder1_txtOptionVal_' + j).val('');
                $('#hdOptionCode_' + j).val('');
            }

            var callback = function (response) {
                if (response != '' && response != null) {

                    for (var i = 1; i <= response.length; i++) {

                        if (!isEmpty(response[i - 1].GoodsOptionCationCode)) {
                            $('#ContentPlaceHolder1_txtOptionName_' + response[i - 1].GoodsOptionLevelCode).val(response[i - 1].GoodsOptionCationName);
                            $('#ContentPlaceHolder1_txtOptionVal_' + response[i - 1].GoodsOptionLevelCode).val(response[i - 1].GoodsOptionValues);
                            $('#hdOptionCode_' + response[i - 1].GoodsOptionLevelCode).val(response[i - 1].GoodsOptionCationCode);
                            $('#imgSearchOption_' + response[i - 1].GoodsOptionLevelCode).css('display', 'none');
                            $('#spanOptionTextDel_' + response[i - 1].GoodsOptionLevelCode).css('display', 'none');

                            var sumCode = response[i - 1].GoodsOptionSummaryCode;

                            for (var k = 1; k < sumCode.split('_').length; k++) {
                                if (response[i - 1].GoodsOptionCationCode == sumCode.split('_')[k]) {
                                    $('#cbSummaryOptionCode_' + response[i - 1].GoodsOptionLevelCode).prop('checked', true);
                                }
                            }
                        }

                    }

                }

                return false;
            };

            var goodsCode = '';
            if (isEmpty(qsGoodsCode)) {
                goodsCode = $("#hdSelectGoodsCode").val();

            }
            else {
                goodsCode = qsGoodsCode;
            }

            var param = {
                Method: 'GetGoodsOptionInfo',
                GoodsCode: goodsCode,
            };

            JajaxSessionCheck('Post', '../../Handler/GoodsHandler.ashx', param, 'json', callback, '<%=Svid_User %>');
        }



        var is_sending = false;

        //속성 삭제
        function fnGoodsOptionDel(el, level) {



            var cationCode = $(el).parent().find('#hdOptionCode_' + level).val();

            if (cationCode == '') {
                alert('속성이 없습니다.');
                return false;

            }

            if (!confirm('삭제하시겠습니까?')) {
                return false;
            }


            var callback = function (response) {

                if (response == 'OK') {

                    fnGoodsOptionBind();
                    $('#imgSearchOption_' + level).css('display', '');
                    $('#spanOptionTextDel_' + level).css('display', '');
                    $('#hdOptionCode_' + level).val('');
                    $('input[id*=txtOptionName_' + level + ']').val('');
                    $('input[id*=txtOptionVal_' + level + ']').val('');
                    $('#cbSummaryOptionCode_' + level).prop('checked', false);

                }
                else {
                    alert('시스템 오류입니다. 개발팀에 문의하세요.');
                }
                return false;
            };

            var goodsCode = '';
            if (isEmpty(qsGoodsCode)) {
                goodsCode = $("#hdSelectGoodsCode").val();

            }
            else {
                goodsCode = qsGoodsCode;
            }

            var param = {

                GoodsCode: goodsCode,
                CationCode: cationCode,
                LevelCode: level,
                Method: 'DeleteGoodsOption'
            };

            var beforeSend = function () {
                is_sending = true;
            }

            var complete = function () {
                is_sending = false;
            }

            if (is_sending) return false;

            JajaxDuplicationCheck('Post', '../../Handler/GoodsHandler.ashx', param, 'text', callback, beforeSend, complete, true, '<%= Svid_User%>');

            return false;

        }


        //속성창 변경 팝업
        function fnOpenOptionPopup(level) {

            $('#selectOptionTarget').val('Code');
            $('#txtOptionPopupSearch').val('');
            $('#hdSelectOptionLevel').val(level);
            fnOptionDataBind(1);

            fnOpenDivLayerPopup('OptionCodeSearchDiv');


            return false;
        }

        //속성 데이터 바인딩
        function fnOptionDataBind(pageNo) {
            $("#tblSearchCode_tbody").empty(); //데이터 클리어
            var callback = function (response) {
                var returnVal = false;
                if (!isEmpty(response)) {

                    var listTag = "";

                    $.each(response, function (key, value) {

                        $('#hdOptionPopupTotalCount').val(value.TotalCount);
                        listTag += "<tr>"
                            + "<td class='txt-center'>" + value.RowNum + "</td>"
                            + "<td class='txt-center'><input type='hidden' id='hdPopupOptionCode' value='" + value.GoodsOptionCationCode + "' /><input type='hidden' id='hdPopupOptionName' value='" + value.GoodsOptionCationName + "' />" + value.GoodsOptionCationCode + "</td>"
                            + "<td class='txt-center'>" + value.GoodsOptionCationName + "</td>"
                            + "</tr>";
                    });

                    $("#tblSearchCode_tbody").append(listTag);

                } else {
                    var emptyTag = "<tr><td colspan='3' class='txt-center'>조회된 데이터가 없습니다.</td></tr>";

                    $("#tblSearchCode_tbody").append(emptyTag);
                }
                fnCreatePagination('searchCodePagination', $("#hdOptionPopupTotalCount").val(), pageNo, 15, geOptionPopupPageData);



                return false;
            };

            var sUser = '<%=Svid_User %>';
            var param = {
                Target: $('#selectOptionTarget').val(),
                Keyword: $('#txtOptionPopupSearch').val(),
                PageNo: pageNo,
                PageSize: 15,
                Method: 'GetGoodsOptionCodeList'
            };

            JajaxSessionCheck('Post', '../../Handler/GoodsHandler.ashx', param, 'json', callback, '<%=Svid_User %>');
        }

        //페이징 인덱스 클릭시 속성데이터 바인딩
        function geOptionPopupPageData() {
            var container = $('#searchCodePagination');
            var getPageNum = container.pagination('getSelectedPageNum');
            fnOptionDataBind(getPageNum);
            return false;
        }

        function fnOptionPopupEnter() {
            if (event.keyCode == 13) {
                fnOptionDataBind(1);
                return false;
            }
            else
                return true;
        }

        //옵션팝업 확인클릭
        function fnOptionPopupConfirm() {
            var getLevel = $('#hdSelectOptionLevel').val();


            var hdCode = $("#hdSelectOptionCode").val();
            var hdName = $("#hdSelectOptionName").val();

            var duflCheck = true;
            $("input:hidden[id ^='hdOptionCode_']").each(function () {
                if ($(this).val() == hdCode) {
                    duflCheck = false;
                }
            });
            if (duflCheck == false) {

                alert('이미 추가된 속성입니다.');
                return false;
            }


            $('#ContentPlaceHolder1_txtOptionName_' + getLevel).val(hdName);
            $('#hdOptionCode_' + getLevel).val(hdCode);

            fnClosePopup('OptionCodeSearchDiv');
            return false;
        }
        //옵션 텍스트박스 클리어
        function fnDelPopuptext() {
            var getLevel = $('#hdSelectOptionLevel').val();

            $('#ContentPlaceHolder1_txtOptionName_' + getLevel).val('');
            $('#hdOptionCode_' + getLevel).val('');
            fnClosePopup('OptionCodeSearchDiv');
            return false;
        }

        //공급사 텍스트박스 클리어
        function fnDelPopuptext_2(event) {
            var id_1 = $(event).prev().prop('id');
            var i = id_1.substr(id_1.length - 1, 1);
            var id_2 = "ContentPlaceHolder1_txtSupplyCompanyName" + i; //공급사명

            $('#' + id_1).val("");
            $('#' + id_2).val("");

            return false;
        }

        // 텍스트박스 클리어
        function fnDelCodetext(type) {
            if (type == 'subUnit') {
                $('#<%= txtSubQtyCode.ClientID%>').val("");
            }
            else if (type == 'comp') {
                $('#<%= txtCompCode.ClientID%>').val("");

            }
            return false;
        }

        //옵션코드생성
        function fnCreateOptionSumCode() {

            $('#<%= txtOptionSummaryCode.ClientID%>').val('');

            var optionCode = 'O_'

            $('input:checkbox[id ^="cbSummaryOptionCode_"]').each(function () {
                var getName = $(this).parent().next().find('input:text[id ^="ContentPlaceHolder1_txtOptionName_"]').val();
                if (this.checked && getName != '') {//checked 처리된 항목의 값

                    var getCode = $(this).parent().find('input:hidden[id ^="hdOptionCode_"]').val();
                    optionCode += getCode + '_';
                }

            });
            if (optionCode.length != 2) {

                optionCode = optionCode.slice(0, -1);
            }
            $('#<%= txtOptionSummaryCode.ClientID%>').val(optionCode);

            return false;
        }

        //-------------------------------원산지 팝업 시작 ---------------------------------------------//
        //원산지 변경 팝업
        function fnOpenOriginPopup() {


            $('#txtOriginPopupSearch').val('');
            fnOriginDataBind(1);

            $('.divScr').css({
                'width': '100 %',
                'height': '543px',
                'overflow-y': 'hidden'
            });



            fnOpenDivLayerPopup('OriginCodeSearchDiv');

            return false;
        }

        //원산지 데이터 바인딩
        function fnOriginDataBind(pageNo) {
            $("#tblSearchOriginCode_tbody").empty(); //데이터 클리어
            var callback = function (response) {
                var returnVal = false;
                if (!isEmpty(response)) {

                    var listTag = "";

                    $.each(response, function (key, value) {

                        $('#hdOriginPopupTotalCount').val(value.TotalCount);
                        listTag += "<tr>"
                            + "<td class='txt-center'>" + value.RowNum + "</td>"
                            + "<td class='txt-center'><input type='hidden' id='hdPopupOriginCode' value='" + value.OriginCode + "' /><input type='hidden' id='hdPopupOriginName' value='" + value.OriginName + "' />" + value.OriginCode + "</td>"
                            + "<td class='txt-center'>" + value.OriginName + "</td>"
                            + "</tr>";
                    });
                    $("#tblSearchOriginCode_tbody").append(listTag);

                } else {
                    var emptyTag = "<tr><td colspan='3' class='txt-center'>조회된 데이터가 없습니다.</td></tr>";

                    $("#tblSearchOriginCode_tbody").append(emptyTag);
                }
                fnCreatePagination('originPopuppagination', $("#hdOriginPopupTotalCount").val(), pageNo, 15, getOriginPopupPageData);



                return false;
            };

            var sUser = '<%=Svid_User %>';
            var param = {
                Keyword: $('#txtOriginPopupSearch').val(),
                PageNo: pageNo,
                PageSize: 15,
                Method: 'GetGoodsOriginList'
            };

            JajaxSessionCheck('Post', '../../Handler/GoodsHandler.ashx', param, 'json', callback, '<%=Svid_User %>');
        }

        //페이징 인덱스 클릭시 원산지데이터 바인딩
        function getOriginPopupPageData() {
            var container = $('#originPopuppagination');
            var getPageNum = container.pagination('getSelectedPageNum');
            fnOriginDataBind(getPageNum);
            return false;
        }

        function fnOriginPopupEnter() {
            if (event.keyCode == 13) {
                fnOriginDataBind(1);
                return false;
            }
            else
                return true;
        }

        //원산지팝업 확인클릭
        function fnOriginPopupConfirm() {

            var hdCode = $("#hdSelectOriginCode").val();
            var hdName = $("#hdSelectOriginName").val();

            $('#<%= txtGoodsOriginCode.ClientID%>').val(hdCode + '(' + hdName + ')');

            fnClosePopup('OriginCodeSearchDiv');
            return false;
        }
        //-----------------------------원산지 팝업 끝-----------------------------------------//


        //-------------------------------배송비 팝업 시작 ---------------------------------------------//
        //배송비 변경 팝업
        function fnOpenDeliveryPopup() {

            var costGubun = $('#<%= ddlDeliveryCostGubun.ClientID%>').val();
            if (costGubun == '1') {
                alert('배송비 구분이 무료입니다.');
                return false;
            }

            fnDeliveryDataBind(1);



            fnOpenDivLayerPopup('deliveryCodeSearchDiv');

            return false;
        }

        //배송비 데이터 바인딩
        function fnDeliveryDataBind(pageNo) {
            $("#tblDeliveryCode_tbody").empty(); //데이터 클리어
            var callback = function (response) {
                var returnVal = false;
                if (!isEmpty(response)) {

                    var listTag = "";

                    $.each(response, function (key, value) {

                        listTag += "<tr>"
                            + "<td class='txt-center'>" + parseInt(key + 1) + "</td>"
                            + "<td class='txt-center'><input type='hidden' id='hdPopupDeliveryCode' value='" + value.CostCode + "' /><input type='hidden' id='hdPopupDeliveryName' value='" + value.CostValue + "' />" + value.CostCode + "</td>"
                            + "<td class='txt-center'>" + numberWithCommas(value.CostValue) + "원</td>"
                            + "</tr>";
                    });

                    $("#tblDeliveryCode_tbody").append(listTag);

                } else {
                    var emptyTag = "<tr><td colspan='3' class='txt-center'>조회된 데이터가 없습니다.</td></tr>";

                    $("#tblDeliveryCode_tbody").append(emptyTag);
                }

                return false;
            };
            var sUser = '<%=Svid_User %>';
            var param = {
                Gubun: $('#<%=ddlDeliveryCostGubun.ClientID %>').val(),
                Method: 'GetDeliveryCostCodeList'
            };

            JajaxSessionCheck('Post', '../../Handler/GoodsHandler.ashx', param, 'json', callback, '<%=Svid_User %>');
        }

        //배송비팝업 확인클릭
        function fnDeliveryPopupConfirm() {

            var hdCode = $("#hdSelectDeliveryCode").val();
            var hdName = $("#hdSelectDeliveryName").val();

            $('#<%= txtDeliveryGubunCode.ClientID%>').val(hdCode + ' (' + numberWithCommas(hdName) + '원)');

            fnClosePopup('deliveryCodeSearchDiv');
            return false;
        }
        //-----------------------------배송비 팝업 끝-----------------------------------------//



        //-------------------------------상품조회 팝업 시작 ---------------------------------------------//
        //상품조회  팝업
        function fnOpenGoodsPopup() {

            var keyword = $('#<%= txtGoodsSearch.ClientID%>').val();
            if (keyword == '') {
                alert('상품 관련 검색어를 입력하세요.');
                return false;
            }

            fnGoodsDataBind(1);




            fnOpenDivLayerPopup('goodsSearchDiv');

            return false;
        }

        //상품 데이터 바인딩
        function fnGoodsDataBind(pageNo) {

            $("#tblGoods_tbody").empty(); //데이터 클리어
            var callback = function (response) {
                var returnVal = false;
                if (!isEmpty(response)) {

                    var listTag = "";

                    $.each(response, function (key, value) {
                        $('#hdGoodsPopupTotalCount').val(value.TotalCount);
                        listTag += "<tr>"
                            + "<td class='txt-center'>" + value.RowNum + "</td>"
                            + "<td class='txt-center'><input type='hidden' id='hdPopupGoodsCode' value='" + value.GoodsCode + "' /><input type='hidden' id='hdPopupGoodsName' value='" + value.GoodsFinalName + "' />" + value.GoodsCode + "</td>"
                            + "<td class='txt-center'>" + value.BrandName + "</td>"
                            + "<td class='txt-center'>" + value.GoodsFinalName + "</td>"
                            + "</tr>";
                    });

                    $("#tblGoods_tbody").append(listTag);


                } else {
                    $("#hdGoodsPopupTotalCount").val(0);
                    var emptyTag = "<tr><td colspan='4' class='txt-center'>조회된 데이터가 없습니다.</td></tr>";

                    $("#tblGoods_tbody").append(emptyTag);
                }
                fnCreatePagination('goodsPopuppagination', $("#hdGoodsPopupTotalCount").val(), pageNo, 15, getGoodsPopupPageData);
                return false;
            };
            var sUser = '<%=Svid_User %>';
            var param = {
                Target: $('#<%= ddlSearchTarget.ClientID%>').val(),
                Keyword: $('#<%= txtGoodsSearch.ClientID%>').val().trim(),
                ModelKeyWord: "",
                PageNo: pageNo,
                PageSize: 15,
                Method: 'GetGoodsSearchList'
            };



            var beforeSend = function () {
                $('#divLoading').css('display', '');
            }
            var complete = function () {
                $('#divLoading').css('display', 'none');
            }

            JqueryAjax('Post', '../../Handler/GoodsHandler.ashx', true, false, param, 'json', callback, beforeSend, complete, true, '<%=Svid_User%>');
        }

        //페이징 인덱스 클릭시 상품데이터 바인딩
        function getGoodsPopupPageData() {
            var container = $('#goodsPopuppagination');
            var getPageNum = container.pagination('getSelectedPageNum');
            fnGoodsDataBind(getPageNum);
            return false;
        }

        //상품 확인클릭
        function fnGoodsPopupConfirm() {

            $('select[id*=ddlCategory]').empty();
            $('select[id*=ddlCategory]').append('<option value="All">---전체---</option>');

            var hdCode = $("#hdSelectGoodsCode").val();
            fnCategoryBind();
            fnGoodsInfoBind();
            fnGoodsOptionBind();//상품옵션 바인딩
            setDDLDisplay();
            fnClosePopup('goodsSearchDiv');

            return false;
        }

        function fnGoodsSearchEnter() {
            if (event.keyCode == 13) {
                fnOpenGoodsPopup(1);
                return false;
            }
            else
                return true;
        }

        function fnSetDeliveryCostCode(el) {

            var selectedVal = $(el).val();

            if (selectedVal == 1) {
                $('#<%= txtDeliveryGubunCode.ClientID%>').val('DL000000');
            }
            else {
                $('#<%= txtDeliveryGubunCode.ClientID%>').val('');
            }
        }
        //-----------------------------상품조회 팝업 끝-----------------------------------------//



        //저장버튼 클릭
        function fnGoodsUpdate() {

            var goodsCode = '';
            if (isEmpty($("#hdSelectGoodsCode").val())) {
                goodsCode = qsGoodsCode;

            }
            else {
                goodsCode = $("#hdSelectGoodsCode").val();
            }

            if (goodsCode == '') {

                alert('수정할 상품을 선택해 주세요.');
                return false;
            }

            var ctgrCode = '';
            var ctgrName = '';

            $("select[id ^='ContentPlaceHolder1_ddlCategory'] option:selected ").each(function () {  //마지막카테고리 갖고오기

                if ($(this).val() != 'All') {
                    ctgrCode = $(this).val();
                    ctgrName = $(this).text();
                }
            });

            var optionCode = 'O_';
            var optionSumValue = '';
            $('input:checkbox[id ^="cbSummaryOptionCode_"]').sort(function (a, b) {
                return parseInt(a.id) > parseInt(b.id);
            }).each(function () {
                var getName = $(this).parent().next().find('input:text[id ^="ContentPlaceHolder1_txtOptionName_"]').val();
                if (this.checked && getName != '') {//checked 처리된 항목의 값

                    var getCode = $(this).parent().find('input:hidden[id ^="hdOptionCode_"]').val();

                    var getVal = $(this).parent().next().next().next().find('input:text[id ^="ContentPlaceHolder1_txtOptionVal_"]').val();
                    optionCode += getCode + '_';
                    optionSumValue += getName + ':' + getVal + ',';
                }

            });

            if (optionCode.length != 2) {

                optionCode = optionCode.slice(0, -1);
            }


            var txtGroupCode = $("#<%=txtGroupCode.ClientID%>");
            var txtGoodsFinalName = $("#<%=txtGoodsFinalName.ClientID%>");
            var txtGoodsCode = $("#<%=txtGoodsCode.ClientID%>");
            var txtGoodsUnitQty = $("#<%=txtGoodsUnitQty.ClientID%>");
            var txtGoodsUnitSubQty = $("#<%=txtGoodsUnitSubQty.ClientID%>");
            var txtQtyCode = $("#<%=txtQtyCode.ClientID%>");
            var txtSupplyCompUnitCode = $("#<%=txtSupplyCompUnitCode.ClientID%>");
            var txtSubQtyCode = $("#<%=txtSubQtyCode.ClientID%>");
            var txtRemindSearch = $("#<%=txtRemindSearch.ClientID%>");

            var txtGoodsBuyPrice = $("#<%=txtGoodsBuyPrice.ClientID%>");
            var txtGoodsBuyPriceVat = $("#<%=txtGoodsBuyPriceVat.ClientID%>");
            var txtGoodsSalePrice = $("#<%=txtGoodsSalePrice.ClientID%>");
            var txtGoodsCustPrice = $("#<%=txtGoodsCustPrice.ClientID%>");
            var txtGoodsSalePriceVat = $("#<%=txtGoodsSalePriceVat.ClientID%>");
            var txtGoodsCustPriceVat = $("#<%=txtGoodsCustPriceVat.ClientID%>");

            var txtGoodsMSalePrice = $("#<%=txtGoodsMSalePrice.ClientID%>");
            var txtGoodsMSalePriceVat = $("#<%=txtGoodsMSalePriceVat.ClientID%>");

            var txtOptionSummaryCode = $("#<%=txtOptionSummaryCode.ClientID%>");

            var txtSupplyCompanyCode1 = $("#<%=txtSupplyCompanyCode1.ClientID%>");
            var txtSupplyCompanyName1 = $("#<%=txtSupplyCompanyName1.ClientID%>");
            var txtSupplyBuyGoodsMoq = $("#<%=txtSupplyBuyGoodsMoq.ClientID%>");

            var txtGoodsOriginCode = $("#<%=txtGoodsOriginCode.ClientID%>");
            var txtDeliveryGubunCode = $("#<%=txtDeliveryGubunCode.ClientID%>");
            var unitMoq = $('#<%= txtGoodsUnitMoq.ClientID%>').val(); //MOQ(최소판매수량)

            //바코드
            var txtBarcode1 = $("#<%=txtBarcode1.ClientID%>");
            var txtBarcode2 = $("#<%=txtBarcode2.ClientID%>");
            var txtBarcode3 = $("#<%=txtBarcode3.ClientID%>");

            //상품인증구분
            var cbCertifiedVal = '';
            for (var i = 1; i < 9; i++) {
                var inputTag = $("input:checkbox[id='cbCertified" + i + "']");
                var oneVal = '';

                if ($(inputTag).prop("checked")) {
                    oneVal = '1';
                } else {
                    oneVal = '0';
                }

                cbCertifiedVal += oneVal;
            }

            //매입운송비유무(공급사)
            var purchaseTransportCostYN1 = $("#<%=ddlPurchaseTransportCost1.ClientID %>").val();


            //매입운송비용(공급사)
            var purchaseTransportCost1 = $('#<%= txtPurchaseTransportCost1.ClientID%>').val().replace(/[^0-9 | ^.]/g, '');


            if (txtGroupCode.val() == '') {
                alert('그룹코드는 필수 입력 항목입니다.');
                txtGroupCode.focus();
                return false;
            }
            if (txtGoodsFinalName.val() == '') {
                alert('상품명은 필수 입력 항목입니다.');
                txtGoodsFinalName.focus();
                return false;
            }
            if (txtGoodsCode.val() == '') {
                alert('상품코드는 필수 입력 항목입니다.');
                txtGoodsCode.focus();
                return false;
            }
            if (unitMoq == '') {
                alert('MOQ(최소판매수량)은 필수 입력 항목입니다.');
                $('#<%= txtGoodsUnitMoq.ClientID%>').focus();
                return false;
            }

            if (txtGoodsUnitQty.val() == '') {
                alert('내용량은 필수 입력 항목입니다.');
                txtGoodsUnitQty.focus();
                return false;
            }

            if (txtQtyCode.val() == '') {
                alert('단위코드는 필수 입력 항목입니다.');
                txtQtyCode.focus();
                return false;
            }

            if (txtRemindSearch.val() == '') {
                alert('연관검색어는 필수 입력 항목입니다.');
                txtRemindSearch.focus();
                return false;
            }

            var pattern = /[0-9]{4}-[0-9]{2}-[0-9]{2}/;
            var txtGoodsNoSaleEnterTargetDue = $('#<%= txtGoodsNoSaleEnterTargetDue.ClientID%>');
            if (!pattern.test(txtGoodsNoSaleEnterTargetDue.val()) && txtGoodsNoSaleEnterTargetDue.val() != '') {

                alert('품절품목입고예정일을 형식에 맞게 작성해 주세요.');
                txtGoodsNoSaleEnterTargetDue.focus();
                return false;

            }

            if (txtGoodsBuyPrice.val() == '') {
                alert("매입가격(VAT별도)은 필수 입력 항목입니다.");
                txtGoodsBuyPrice.focus();
                return false;
            }
            if (parseInt(txtGoodsBuyPrice.val()) < 1) {
                alert("매입가격(VAT별도)은 0보다 커야 합니다.");
                txtGoodsBuyPrice.focus();
                return false;
            }

            if (txtGoodsSalePrice.val() == '') {
                alert('구매사 판매가격(VAT별도)은 필수 입력 항목입니다.');
                txtGoodsSalePrice.focus();
                return false;
            }
            if (parseInt(txtGoodsSalePrice.val()) < 1) {
                alert('구매사 판매가격(VAT별도)은 0보다 커야 합니다.');
                txtGoodsSalePrice.focus();
                return false;
            }

            if (txtGoodsMSalePrice.val() == '') {
                alert('민간 구매사 판매가격(VAT별도)은 필수 입력 항목입니다.');
                txtGoodsMSalePrice.focus();
                return false;
            }
            if (parseInt(txtGoodsMSalePrice.val()) < 1) {
                alert("민간 구매사 판매가격(VAT별도)은 0보다 커야 합니다.");
                txtGoodsMSalePrice.focus();
                return false;
            }

            if (txtGoodsMSalePriceVat.val() == '') {
                alert('민간 구매사 판매가격(VAT포함)은 필수 입력 항목입니다.');
                txtGoodsMSalePriceVat.focus();
                return false;
            }
            if (parseInt(txtGoodsMSalePriceVat.val()) < 1) {
                alert("민간 구매사 판매가격(VAT포함)은 0보다 커야 합니다.");
                txtGoodsMSalePriceVat.focus();
                return false;
            }

            if (txtGoodsSalePriceVat.val() == '') {
                alert('구매사 판매가격은 필수 입력 항목입니다.');
                txtGoodsSalePriceVat.focus();
                return false;
            }

            if (txtGoodsCustPrice.val() == '') {
                alert('판매사 판매가격(VAT별도)은 필수 입력 항목입니다.');
                txtGoodsCustPrice.focus();
                return false;
            }
            if (parseInt(txtGoodsCustPrice.val()) < 1) {
                alert("판매사 판매가격(VAT별도)은 0보다 커야 합니다.");
                txtGoodsCustPrice.focus();
                return false;
            }

            if (txtGoodsCustPriceVat.val() == '') {
                alert('판매사 판매가격은 필수 입력 항목입니다.');
                txtGoodsCustPriceVat.focus();
                return false;
            }


            if (txtOptionSummaryCode.val() == '') {
                alert('옵션코드는 필수 입력 항목입니다.');
                txtOptionSummaryCode.focus();
                return false;
            }
            if (txtSupplyCompUnitCode.val() == '') {
                alert('공급사 단위코드는 필수 입력 항목입니다.');
                txtSupplyCompUnitCode.focus();
                return false;
            }

            if (txtSupplyCompanyCode1.val() == '') {
                alert('공급사코드은 필수 입력 항목입니다.');
                txtSupplyCompanyCode1.focus();
                return false;
            }
            if (txtSupplyCompanyName1.val() == '') {
                alert('공급사명은 필수 입력 항목입니다.');
                txtSupplyCompanyName1.focus();
                return false;
            }

            if (txtSupplyBuyGoodsMoq.val() == '') {
                alert('매입MOQ는 필수 입력 항목입니다.');
                txtSupplyBuyGoodsMoq.focus();
                return false;
            }
            if (txtGoodsOriginCode.val() == '') {
                alert('원산지코드는 필수 입력 항목입니다.');
                txtGoodsOriginCode.focus();
                return false;
            }
            if (txtDeliveryGubunCode.val() == '') {
                alert('배송비 비용코드는 필수 입력 항목입니다.');
                txtDeliveryGubunCode.focus();
                return false;
            }

            if (isEmpty(cbCertifiedVal)) {
                alert("상품 인증 구분값이 올바르지 않습니다. 개발자에게 문의바랍니다.");
                return false;
            }

            if ((purchaseTransportCostYN1 == '1') && (isEmpty(purchaseTransportCost1))) {
                alert("공급사의 매입운송비용을 입력해 주세요.");
                return false;
            }



            var callback = function (response) {
                if (response != 'OK') {
                    alert('시스템 오류입니다. 관리자에게 문의하세요');
                }
                else {
                    alert('저장되었습니다.');
                }
                return false;
            };

            var param = {

                GoodsCode: goodsCode,
                CategoryCode: ctgrCode,
                CategoryName: ctgrName,
                GroupCode: $('#<%= txtGroupCode.ClientID%>').val(),
                GoodsName: $('#<%= txtGoodsFinalName.ClientID%>').val(),
                SummaryCode: optionCode,
                BrandCode: "BC00000",
                Model: $('#<%= txtGoodsModel.ClientID%>').val(),
                Unit: $('#<%= txtQtyCode.ClientID%>').val().substring(0, 7),
                SubUnit: $('#<%= txtSubQtyCode.ClientID%>').val().substring(0, 7),
                UnitMoq: $('#<%= txtGoodsUnitMoq.ClientID%>').val(),
                UnitQty: $('#<%= txtGoodsUnitQty.ClientID%>').val(),
                UnitSubQty: $('#<%= txtGoodsUnitSubQty.ClientID%>').val(),
                DeliveryOrderDue: $('#<%= ddlDueDate.ClientID%>').val(),
                BuyPrice: parseInt($('#<%= txtGoodsBuyPrice.ClientID%>').val().replace(/[^0-9 | ^.]/g, '')),
                BuyPriceVat: parseInt($('#<%= txtGoodsBuyPriceVat.ClientID%>').val().replace(/[^0-9 | ^.]/g, '')),
                SalePrice: parseInt($('#<%= txtGoodsSalePrice.ClientID%>').val().replace(/[^0-9 | ^.]/g, '')),
                SalePriceVat: parseInt($('#<%= txtGoodsSalePriceVat.ClientID%>').val().replace(/[^0-9 | ^.]/g, '')),
                MSalePrice: parseInt($('#<%= txtGoodsMSalePrice.ClientID%>').val().replace(/[^0-9 | ^.]/g, '')),
                MSalePriceVat: parseInt($('#<%= txtGoodsMSalePriceVat.ClientID%>').val().replace(/[^0-9 | ^.]/g, '')),
                CustPrice: parseInt($('#<%= txtGoodsCustPrice.ClientID%>').val().replace(/[^0-9 | ^.]/g, '')),
                CustPriceVat: parseInt($('#<%= txtGoodsCustPriceVat.ClientID%>').val().replace(/[^0-9 | ^.]/g, '')),
                GoodsSpecial: $('#<%= txtGoodsSpecial.ClientID%>').val(),
                GoodsFormat: $('#<%= txtGoodsFormat.ClientID%>').val(),
                GoodsCause: $('#<%= txtGoodsCause.ClientID%>').val(),
                GoodsSupplies: $('#<%= txtGoodsSupplies.ClientID%>').val(),
                RemindSearch: $('#<%= txtRemindSearch.ClientID%>').val(),
                //MdId: $('#hdMdToId').val(),
                MdId: $('#hdMdToId').val(),
                cBarcode1: txtBarcode1.val(),
                cBarcode2: txtBarcode2.val(),
                cBarcode3: txtBarcode3.val(),
                Mdmemo: $('#<%= txtMdMemo.ClientID%>').val(),
                DisplayFlag: $('#<%= ddlDisplay.ClientID%>').val(),
                NodisplayReason: $('#<%= ddlNoDisplay.ClientID%>').val(),
                NosaleReason: $('#<%= ddlNoSale.ClientID%>').val(),
                NosaleEnterdue: $('#<%= txtGoodsNoSaleEnterTargetDue.ClientID%>').val(),
                ReturnChangeFlag: $('#<%= ddlReturnChange.ClientID%>').val(),
                KeepYn: $('#<%= ddlGoodsKeepYN.ClientID%>').val(),
                SaleTaxYn: $('#<%= ddlsaleTaxYN.ClientID%>').val(),
                DcYn: $('#<%= ddlDCYN.ClientID%>').val(),
                CustGubun: $('#<%= ddlGoodsGubun.ClientID%>').val(),
                CustGubunCode: $('#<%= txtCompCode.ClientID%>').val(),
                Barcode: $('#<%= txtSupplyCompanyBarcode1.ClientID%>').val(),
                Barcode2: "",
                Barcode3: "",
                SCompCode1: $('#<%= txtSupplyCompanyCode1.ClientID%>').val(),
                SCompCode2: "",
                SCompCode3: "",
                SGoodsCode1: $('#<%= txtSupplyGoodsCode1.ClientID%>').val(),
                SGoodsCode2: "",
                SGoodsCode3: "",
                SGoodsUnit: $('#<%= txtSupplyCompUnitCode.ClientID%>').val().substring(0, 7),
                SGoodsUnitMoq: $('#<%= txtSupplyBuyGoodsMoq.ClientID%>').val(),
                SGoodsUnitMoq2: "",
                SGoodsUnitMoq3: "",
                SGoodsEnterDue: $('#<%= ddlSupplyGoodsEnterDue.ClientID%>').val(),
                SGoodsEnterDue2: "",
                SGoodsEnterDue3: "",
                SBuyCalc: $('#<%= ddlSupplyBuyCalc.ClientID%>').val(),
                SBuyCalc2: "",
                SBuyCalc3: "",
                SOrderForm: $('#<%= ddlOrderForm.ClientID%>').val(),
                SOrderForm2: "",
                SOrderForm3: "",
                SGoodsType: $('#<%= ddlSupplyBuyGoodsType.ClientID%>').val(),
                SDistrA: $('#<%= ddlSupplyGoodsDistrAdmin.ClientID%>').val(),
                SDistrDue: $('#<%= txtSupplyGoodsDistrDue.ClientID%>').val(),
                SDistrDue2: "",
                SDistrDue3: "",
                OriginCode: $('#<%= txtGoodsOriginCode.ClientID%>').val().substring(0, 2),
                DeliveryGubun: $('#<%= ddlDeliveryGubun.ClientID%>').val(),
                DeliveryCGubun: $('#<%= ddlDeliveryCostGubun.ClientID%>').val(),
                DeliveryCCode: $('#<%= txtDeliveryGubunCode.ClientID%>').val().substring(0, 8),
                SummaryValues: optionSumValue.slice(0, -1),
                OptionCode1: $('#hdOptionCode_1').val(),
                OptionValue1: $('#<%= txtOptionVal_1.ClientID%>').val(),
                OptionCode2: $('#hdOptionCode_2').val(),
                OptionValue2: $('#<%= txtOptionVal_2.ClientID%>').val(),
                OptionCode3: $('#hdOptionCode_3').val(),
                OptionValue3: $('#<%= txtOptionVal_3.ClientID%>').val(),
                OptionCode4: $('#hdOptionCode_4').val(),
                OptionValue4: $('#<%= txtOptionVal_4.ClientID%>').val(),
                OptionCode5: $('#hdOptionCode_5').val(),
                OptionValue5: $('#<%= txtOptionVal_5.ClientID%>').val(),
                OptionCode6: $('#hdOptionCode_6').val(),
                OptionValue6: $('#<%= txtOptionVal_6.ClientID%>').val(),
                OptionCode7: $('#hdOptionCode_7').val(),
                OptionValue7: $('#<%= txtOptionVal_7.ClientID%>').val(),
                OptionCode8: $('#hdOptionCode_8').val(),
                OptionValue8: $('#<%= txtOptionVal_8.ClientID%>').val(),
                OptionCode9: $('#hdOptionCode_9').val(),
                OptionValue9: $('#<%= txtOptionVal_9.ClientID%>').val(),
                OptionCode10: $('#hdOptionCode_10').val(),
                OptionValue10: $('#<%= txtOptionVal_10.ClientID%>').val(),
                OptionCode11: $('#hdOptionCode_11').val(),
                OptionValue11: $('#<%= txtOptionVal_11.ClientID%>').val(),
                OptionCode12: $('#hdOptionCode_12').val(),
                OptionValue12: $('#<%= txtOptionVal_12.ClientID%>').val(),
                OptionCode13: $('#hdOptionCode_13').val(),
                OptionValue13: $('#<%= txtOptionVal_13.ClientID%>').val(),
                OptionCode14: $('#hdOptionCode_14').val(),
                OptionValue14: $('#<%= txtOptionVal_14.ClientID%>').val(),
                OptionCode15: $('#hdOptionCode_15').val(),
                OptionValue15: $('#<%= txtOptionVal_15.ClientID%>').val(),
                OptionCode16: $('#hdOptionCode_16').val(),
                OptionValue16: $('#<%= txtOptionVal_16.ClientID%>').val(),
                OptionCode17: $('#hdOptionCode_17').val(),
                OptionValue17: $('#<%= txtOptionVal_17.ClientID%>').val(),
                OptionCode18: $('#hdOptionCode_18').val(),
                OptionValue18: $('#<%= txtOptionVal_18.ClientID%>').val(),
                OptionCode19: $('#hdOptionCode_19').val(),
                OptionValue19: $('#<%= txtOptionVal_19.ClientID%>').val(),
                OptionCode20: $('#hdOptionCode_20').val(),
                OptionValue20: $('#<%= txtOptionVal_20.ClientID%>').val(),
                GdsConfirmMark: cbCertifiedVal,
                SupplyTransCostYN: purchaseTransportCostYN1,
                SupplyTransCostVat: purchaseTransportCost1,
                SupplyTransCostYN2: "",
                SupplyTransCostVat2: "",
                SupplyTransCostYN3: "",
                SupplyTransCostVat3: "",
                Method: 'UpdateGoods'
            };

            var beforeSend = function () {
                is_sending = true;
            }

            var complete = function () {
                is_sending = false;

                fnCategoryBind();
                fnGoodsInfoBind();
                fnGoodsOptionBind();
                setDDLDisplay();
            }

            if (is_sending) return false;


            JajaxDuplicationCheck('Post', '../../Handler/GoodsHandler.ashx', param, 'text', callback, beforeSend, complete, true, '<%=Svid_User%>');
            return false;


        }

        //페이지 이동
        function fnGoPage(pageVal) {
            switch (pageVal) {
                case "GOODS":
                    window.location.href = "../Goods/GoodsRegister";
                    break;
                case "BRAND":
                    window.location.href = "../Goods/BrandMain";
                    break;
                case "CATEGORY":
                    window.location.href = "../Goods/CategoryManage";
                    break;
                default:
                    break;
            }
        }
    </script>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div class="all">

        <div class="sub-contents-div" style="min-height: 1500px">
            <div class="sub-title-div">
                <p class="p-title-mainsentence">
                    서비스용역수정
                    <span class="span-title-subsentence"></span>
                </p>
            </div>


            <!--탭영역-->
            <div class="div-main-tab" style="width: 100%;">
                <ul>
                    <li class='tabOff' style="width: 185px;" onclick="fnTabClickRedirect('GoodsRegister');">
                        <a onclick="fnTabClickRedirect('GoodsRegister');">상품등록</a>
                    </li>
                    <li class='tabOff' style="width: 185px;" onclick="fnTabClickRedirect('GoodsModify');">
                        <a onclick="fnTabClickRedirect('GoodsModify');">상품수정</a>
                    </li>
                    <li class='tabOff' style="width: 185px;" onclick="fnTabClickRedirect('GoodsServiceRegister');">
                        <a onclick="fnTabClickRedirect('GoodsCodeRank');">서비스용역등록</a>
                    </li>
                    <li class='tabOn' style="width: 185px;" onclick="fnTabClickRedirect('GoodsServiceModify');">
                        <a onclick="fnTabClickRedirect('GoodsCodeRank');">서비스용역수정</a>
                    </li>
                    <li class='tabOff' style="width: 185px;" onclick="fnTabClickRedirect('GoodsGroupCodeRank');">
                        <a onclick="fnTabClickRedirect('GoodsGroupCodeRank');">그룹코드 Rank</a>
                    </li>
                    <li class='tabOff' style="width: 185px;" onclick="fnTabClickRedirect('GoodsCodeRank');">
                        <a onclick="fnTabClickRedirect('GoodsCodeRank');">상품코드 Rank</a>
                    </li>
                </ul>
            </div>
            <div>
                <input type="button" class="mainbtn type1" style="width: 105px; height: 30px;" value="카테고리 관리" onclick="fnGoPage('CATEGORY')" />
                <input type="button" class="mainbtn type1" style="width: 105px; height: 30px;" value="브랜드 관리" onclick="fnGoPage('BRAND')" />


            </div>




            <span style="color: #69686d; float: left; margin-top: 10px; margin-bottom: 5px;"><b style="color: #ec2029; font-weight: bold;">" * " 표시는 필수 입력항목입니다.</b></span>
            <br />
            <asp:Label ID="lblErrorMsg" runat="server"></asp:Label>
            <div class="bottom-search-div" style="margin-bottom: 20px">

                <table class="tbl_main">
                    <tr>
                        <th style="width: 200px;">
                            <asp:DropDownList ID="ddlSearchTarget" runat="server" Width="150px" Height="26" Style="margin-left: 5px;">
                                <asp:ListItem Text="서비스용역코드" Value="GoodsCode"></asp:ListItem>
                                <asp:ListItem Text="서비스용역명" Value="GoodsName"></asp:ListItem>
                            </asp:DropDownList>
                           <%-- <p>(확장검색) 모델명</p>--%>
                        </th>
                        <td colspan="2" style="text-align: left;">
                            <asp:TextBox runat="server" placeholder="검색어를 입력하세요." Style="width: 80%" ID="txtGoodsSearch" OnKeyPress="return fnGoodsSearchEnter();"></asp:TextBox>
                            <%--<asp:TextBox runat="server" placeholder="검색어를 입력하세요." Style="width: 80%" ID="txtModelSearch" OnKeyPress="return fnGoodsSearchEnter();"></asp:TextBox>--%>
                            <asp:Button runat="server" CssClass="mainbtn type1" Style="width: 75px;" Text="검색" OnClientClick="return fnOpenGoodsPopup();" />
                        </td>
                    </tr>
                </table>
            </div>
            <div id="divMainContent" style="display: none">
                <div style="text-align: right; margin-top: 30px; margin-bottom: 20px; clear: both">
                    <input type="button" class="mainbtn type1" style="width: 95px; height: 30px;" value="저장" onclick="return fnGoodsUpdate();" />

                </div>

               

                <div style="float: right; padding-bottom: 10px">
                    <table class="tbl_main" style="width: 400px">
                        <tr>
                            <td style="width: 50%">신규등록일 : <span id="spanEntryDate"></span>

                            </td>
                            <td>최신수정일 : <span id="spanModifyDate"></span>

                            </td>
                        </tr>
                    </table>
                </div>


                <table class="tbl_main" id="tblGoodsModify">
                    <tr>
                        <th style="width: 10%">카테고리1단</th>
                        <th style="width: 10%">카테고리2단</th>
                        <th style="width: 10%">카테고리3단</th>
                        <th style="width: 10%">카테고리4단</th>
                        <th style="width: 10%">카테고리5단</th>
                        <th style="width: 10%">카테고리6단</th>
                        <th style="width: 10%">카테고리7단</th>
                        <th style="width: 10%">카테고리8단</th>
                        <th style="width: 10%">카테고리9단</th>
                        <th style="width: 10%">카테고리10단</th>
                    </tr>

                    <tr>
                        <td>
                            <asp:DropDownList ID="ddlCategory01" runat="server" Width="99%" Height="26px" onchange="fnChangeSubCategoryBind(this,2); return false;">
                                <asp:ListItem Value="All" Text="---전체---"></asp:ListItem>
                            </asp:DropDownList>
                        </td>
                        <td>
                            <asp:DropDownList ID="ddlCategory02" runat="server" Width="99%" Height="26px" onchange="fnChangeSubCategoryBind(this,3); return false;">
                                <asp:ListItem Value="All" Text="---전체---"></asp:ListItem>
                            </asp:DropDownList>
                        </td>
                        <td>
                            <asp:DropDownList ID="ddlCategory03" runat="server" Width="99%" Height="26px" onchange="fnChangeSubCategoryBind(this,4); return false;">
                                <asp:ListItem Value="All" Text="---전체---"></asp:ListItem>
                            </asp:DropDownList>
                        </td>
                        <td>
                            <asp:DropDownList ID="ddlCategory04" runat="server" Width="99%" Height="26px" onchange="fnChangeSubCategoryBind(this,5); return false;">
                                <asp:ListItem Value="All" Text="---전체---"></asp:ListItem>
                            </asp:DropDownList>
                        </td>
                        <td>
                            <asp:DropDownList ID="ddlCategory05" runat="server" Width="99%" Height="26px" onchange="fnChangeSubCategoryBind(this,6); return false;">
                                <asp:ListItem Value="All" Text="---전체---"></asp:ListItem>
                            </asp:DropDownList>
                        </td>
                        <td>
                            <asp:DropDownList ID="ddlCategory06" runat="server" Width="99%" Height="26px" onchange="fnChangeSubCategoryBind(this,7); return false;">
                                <asp:ListItem Value="All" Text="---전체---"></asp:ListItem>
                            </asp:DropDownList>
                        </td>
                        <td>
                            <asp:DropDownList ID="ddlCategory07" runat="server" Width="99%" Height="26px" onchange="fnChangeSubCategoryBind(this,8); return false;">
                                <asp:ListItem Value="All" Text="---전체---"></asp:ListItem>
                            </asp:DropDownList>
                        </td>
                        <td>
                            <asp:DropDownList ID="ddlCategory08" runat="server" Width="99%" Height="26px" onchange="fnChangeSubCategoryBind(this,9); return false;">
                                <asp:ListItem Value="All" Text="---전체---"></asp:ListItem>
                            </asp:DropDownList>
                        </td>
                        <td>
                            <asp:DropDownList ID="ddlCategory09" runat="server" Width="99%" Height="26px" onchange="fnChangeSubCategoryBind(this,10); return false;">
                                <asp:ListItem Value="All" Text="---전체---"></asp:ListItem>
                            </asp:DropDownList>
                        </td>
                        <td>
                            <asp:DropDownList ID="ddlCategory10" runat="server" Width="99%" Height="26px">
                                <asp:ListItem Value="All" Text="---전체---"></asp:ListItem>
                            </asp:DropDownList>
                        </td>
                    </tr>


                    <tr>
                        <th colspan="2">구분</th>
                        <th colspan="2">항목1</th>
                        <th colspan="2">내용1</th>
                        <th colspan="2">항목2</th>
                        <th colspan="2">내용2</th>
                    </tr>

                    <tr>
                        <th colspan="2">담당자정보</th>
                        <th colspan="2">담당MD</th>
                        <td colspan="2">
                            <label id="lbMD"></label>
                            <input type="hidden" id="hdMdToId" />
                        </td>
                        <th colspan="2">MD메모</th>
                        <td colspan="2">
                            <asp:TextBox runat="server" placeholder="내용입력" CssClass="txtB" ID="txtMdMemo"></asp:TextBox></td>
                    </tr>



                    <%--<tr>
                        <th colspan="2" style="padding-left: 50px;">브랜드코드 &nbsp;&nbsp;<a onclick="return commonPopUp(this)" id="brandCode"><img src="../Images/Goods/test2.png" alt="검색" /></a></th>
                        <td colspan="2">
                            <asp:TextBox runat="server" Width="90%" CssClass="txtB" ReadOnly="true" Style="background-color: #ececec;" ID="txtBrandCode"></asp:TextBox><span onclick="return fnDelCodetext('brand');" style="padding-left: 5px; cursor: pointer" id=""><img src="../Images/Goods/c4.jpg" alt="x" /></span></td>
                        <th colspan="2">브랜드명</th>
                        <td colspan="2">
                            <asp:TextBox runat="server" placeholder="내용입력" CssClass="txtB" ID="txtBrandName"></asp:TextBox></td>

                    </tr>--%>

                    <tr>
                        <th rowspan="15" colspan="2">상품기본정보</th>
                        <th colspan="2" style="padding-left: 40px; color: #ec2029">&nbsp;&nbsp;*그룹코드 
                        <span id="spGoodsCnt"></span>
                            <a onclick="return commonPopUp(this)" id="groupCode">
                                <img src="../Images/Goods/test2.png" alt="검색" /></a>
                        </th>
                        <td colspan="2">
                            <asp:TextBox runat="server" CssClass="txtB" ReadOnly="true" Style="background-color: #ececec;" ID="txtGroupCode"></asp:TextBox></td>
                        <th colspan="2">모델명</th>
                        <td colspan="2">
                            <asp:TextBox runat="server" placeholder="내용입력" CssClass="txtB" ID="txtGoodsModel"></asp:TextBox></td>
                    </tr>

                    <tr>
                        <th colspan="2" style="color: #ec2029">&nbsp;&nbsp;*서비스용역코드</th>
                        <td colspan="2">
                            <asp:TextBox runat="server" CssClass="txtL" ReadOnly="true" Style="background-color: #ececec;" ID="txtGoodsCode"></asp:TextBox></td>
                        <th colspan="2" style="color: #ec2029">*서비스용역명</th>
                        <td colspan="2">
                            <asp:TextBox runat="server" placeholder="내용입력" CssClass="txtB" ID="txtGoodsFinalName"></asp:TextBox></td>
                    </tr>

                    <tr>
                        <th colspan="2" style="padding-left: 10px; color: #ec2029">*MOQ(최소판매수량)</th>
                        <td colspan="2">
                            <asp:TextBox runat="server" placeholder="내용입력" CssClass="txtB" ID="txtGoodsUnitMoq" onkeypress="return onlyNumbers(event);"></asp:TextBox></td>
                        <th colspan="2" style="color: #ec2029">&nbsp;&nbsp;*상품출고예정일</th>
                        <td colspan="2">
                            <asp:DropDownList runat="server" placeholder="내용입력" CssClass="txtB" ID="ddlDueDate">
                            </asp:DropDownList></td>
                    </tr>

                    <tr>
                        <th colspan="2" style="color: #ec2029">*내용량</th>
                        <td colspan="2">
                            <asp:TextBox runat="server" placeholder="내용입력" CssClass="txtB" ID="txtGoodsUnitQty" onkeypress="return onlyNumbers(event);"></asp:TextBox></td>
                        <th colspan="2" style="padding-left: 50px; color: #ec2029">*단위코드&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a onclick="return commonPopUp(this)" id="UnitCode"><img src="../Images/Goods/test2.png" alt="검색" /></a></th>
                        <td colspan="2">
                            <asp:TextBox runat="server" ReadOnly="true" Style="background-color: #ececec;" CssClass="txtB" ID="txtQtyCode"></asp:TextBox></td>
                    </tr>


                    <tr>
                        <th colspan="2">서브내용량</th>
                        <td colspan="2">
                            <asp:TextBox runat="server" placeholder="내용입력" CssClass="txtB" ID="txtGoodsUnitSubQty" onkeypress="return onlyNumbers(event);"></asp:TextBox></td>
                        <th colspan="2" style="padding-left: 40px;">서브단위코드&nbsp;&nbsp;&nbsp;<a onclick="return commonPopUp(this)" id="SubUnitCode"><img src="../Images/Goods/test2.png" alt="검색" /></a></th>
                        <td colspan="2">
                            <asp:TextBox runat="server" Width="90%" ReadOnly="true" Style="background-color: #ececec;" CssClass="txtB" ID="txtSubQtyCode"></asp:TextBox><span onclick="return fnDelCodetext('subUnit');" style="padding-left: 5px; cursor: pointer" id=""><img src="../Images/Goods/c4.jpg" alt="x" /></span></td>
                    </tr>


                    <tr>
                        <th colspan="2">특징</th>
                        <td colspan="6">
                            <asp:TextBox runat="server" placeholder="내용입력" Width="99.5%" CssClass="txtB" ID="txtGoodsSpecial"></asp:TextBox></td>
                    </tr>


                    <tr>
                        <th colspan="2">형식</th>
                        <td colspan="6">
                            <asp:TextBox runat="server" placeholder="내용입력" Width="99.5%" CssClass="txtB" ID="txtGoodsFormat"></asp:TextBox></td>
                    </tr>

                    <tr>
                        <th colspan="2">주의사항</th>
                        <td colspan="6">
                            <asp:TextBox runat="server" placeholder="내용입력" Width="99.5%" CssClass="txtB" ID="txtGoodsCause"></asp:TextBox></td>
                    </tr>

                    <tr>
                        <th colspan="2">용도</th>
                        <td colspan="6">
                            <asp:TextBox runat="server" placeholder="내용입력" Width="99.5%" CssClass="txtB" ID="txtGoodsSupplies"></asp:TextBox></td>
                    </tr>

                    <tr>
                        <th colspan="2" style="color: #ec2029">*연관검색어</th>
                        <td colspan="6">
                            <asp:TextBox runat="server" placeholder="내용입력" Width="99.5%" CssClass="txtB" ID="txtRemindSearch"></asp:TextBox></td>
                    </tr>

                    <tr>
                        <th colspan="2" style="color: #ec2029">*상품노출여부</th>
                        <td colspan="2">
                            <asp:DropDownList runat="server" CssClass="txtB" ID="ddlDisplay">
                            </asp:DropDownList></td>
                        <th colspan="2">비노출사유</th>
                        <td colspan="2">
                            <asp:DropDownList runat="server" CssClass="txtB" ID="ddlNoDisplay">
                            </asp:DropDownList></td>
                    </tr>

                    <tr>
                        <th colspan="2">판매중단사유</th>
                        <td colspan="2">
                            <asp:DropDownList runat="server" CssClass="txtB" ID="ddlNoSale">
                            </asp:DropDownList></td>
                        <th colspan="2">품절품목입고예정일</th>
                        <td colspan="2">
                            <asp:TextBox runat="server" CssClass="txtB" ID="txtGoodsNoSaleEnterTargetDue" placeholder="ex)2018-01-01"></asp:TextBox></td>
                    </tr>


                    <tr>
                        <th colspan="2" style="color: #ec2029">*반품(교환)불가여부</th>
                        <td colspan="2">
                            <asp:DropDownList runat="server" CssClass="txtB" ID="ddlReturnChange">
                            </asp:DropDownList></td>
                        <th colspan="2" style="color: #ec2029">*판매과세여부</th>
                        <td colspan="2">
                            <asp:DropDownList runat="server" CssClass="txtB" ID="ddlsaleTaxYN" onchange="return fnSaleTaxYN(this);">
                                <asp:ListItem Text="과세" Value="1"></asp:ListItem>
                                <asp:ListItem Text="비과세" Value="2"></asp:ListItem>
                            </asp:DropDownList></td>
                    </tr>

                    <tr>
                        <th colspan="2" style="color: #ec2029">*재고관리여부</th>
                        <td colspan="2">
                            <asp:DropDownList runat="server" CssClass="txtB" ID="ddlGoodsKeepYN">
                            </asp:DropDownList></td>
                        <th colspan="2" style="color: #ec2029">*추가DC적용여부</th>
                        <td colspan="2">
                            <asp:DropDownList runat="server" CssClass="txtB" ID="ddlDCYN">
                                <asp:ListItem Text="적용" Value="1"></asp:ListItem>
                                <asp:ListItem Text="미적용" Value="2"></asp:ListItem>
                            </asp:DropDownList></td>
                    </tr>

                    <tr>
                        <th colspan="2" style="color: #ec2029">*고객사상품구분</th>
                        <td colspan="2">
                            <asp:DropDownList runat="server" CssClass="txtB" ID="ddlGoodsGubun">
                            </asp:DropDownList></td>
                        <th colspan="2" style="padding-left: 30px">특정판매고객사코드&nbsp;&nbsp;&nbsp;<a onclick="return commonPopUp(this)" id="CompCode"><img src="../Images/Goods/test2.png" alt="검색" /></a></th>
                        <td colspan="2">
                            <asp:TextBox runat="server" Width="90%" ReadOnly="true" Style="background-color: #ececec;" CssClass="txtB" ID="txtCompCode"></asp:TextBox><span onclick="return fnDelCodetext('comp');" style="padding-left: 5px; cursor: pointer" id=""><img src="../Images/Goods/c4.jpg" alt="x" /></span></td>
                    </tr>

                    <tr>
                        <th rowspan="4" colspan="2">상품단가정보</th>
                        <th colspan="2" style="color: #ec2029">*매입가격(VAT별도)</th>
                        <td colspan="2">
                            <asp:TextBox runat="server" CssClass="txtB" ID="txtGoodsBuyPrice" onchange="return fnAutoComma(this);" onkeyup="return fnAutoComma(this);" onkeypress="return onlyNumbers(event);" ReadOnly="true" Style="background-color: #ececec;"></asp:TextBox></td>
                        <th colspan="2" style="color: #ec2029">*매입가격(VAT포함)</th>
                        <td colspan="2">
                            <input type="hidden" id="hdGoodsBuyPriceVat" /><asp:TextBox runat="server" CssClass="txtB" ID="txtGoodsBuyPriceVat" onchange="return fnAutoComma(this);" onkeyup="return fnAutoComma(this);" onkeypress="return onlyNumbers(event);" ReadOnly="true" Style="background-color: #ececec;"></asp:TextBox></td>
                    </tr>

                    <tr>
                        <th colspan="2" style="color: #ec2029">*판매사판매가격(VAT별도)</th>
                        <td colspan="2">
                            <asp:TextBox runat="server" CssClass="txtB" ID="txtGoodsCustPrice" onchange="return fnAutoComma(this);" onkeyup="return fnAutoComma(this);" onkeypress="return onlyNumbers(event);" ReadOnly="true" Style="background-color: #ececec;"></asp:TextBox></td>
                        <th colspan="2" style="color: #ec2029">*판매사판매가격(VAT포함)</th>
                        <td colspan="2">
                            <input type="hidden" id="hdGoodsCustPriceVat" /><asp:TextBox runat="server" CssClass="txtB" ID="txtGoodsCustPriceVat" onchange="return fnAutoComma(this);" onkeyup="return fnAutoComma(this);" onkeypress="return onlyNumbers(event);" ReadOnly="true" Style="background-color: #ececec;"></asp:TextBox></td>
                    </tr>
                    <tr>
                        <th colspan="2" style="color: #ec2029">*구매사판매가격(VAT별도)</th>
                        <td colspan="2">
                            <asp:TextBox runat="server" CssClass="txtB" ID="txtGoodsSalePrice" onchange="return fnAutoComma(this);" onkeyup="return fnAutoComma(this);" onkeypress="return onlyNumbers(event);"></asp:TextBox></td>
                        <th colspan="2" style="color: #ec2029">*구매사판매가격(VAT포함)</th>
                        <td colspan="2">
                            <input type="hidden" id="hdGoodsSalePriceVat" /><asp:TextBox runat="server" CssClass="txtB" ID="txtGoodsSalePriceVat" onchange="return fnAutoComma(this);" onkeyup="return fnAutoComma(this);" onkeypress="return onlyNumbers(event);" ReadOnly="true" Style="background-color: #ececec;"></asp:TextBox></td>
                    </tr>
                    <tr>
                        <th colspan="2" style="color: #ec2029">*민간 구매사판매가격(VAT별도)</th>
                        <td colspan="2">
                            <asp:TextBox runat="server" CssClass="txtB" ID="txtGoodsMSalePrice" onchange="return fnAutoComma(this);" onkeyup="return fnAutoComma(this);" onkeypress="return onlyNumbers(event);" ReadOnly="true" Style="background-color: #ececec;"></asp:TextBox></td>
                        <th colspan="2" style="color: #ec2029">*민간 구매사판매가격(VAT포함)</th>
                        <td colspan="2">
                            <input type="hidden" id="hdGoodsMSalePriceVat" /><asp:TextBox runat="server" CssClass="txtB" ID="txtGoodsMSalePriceVat" onchange="return fnAutoComma(this);" onkeyup="return fnAutoComma(this);" onkeypress="return onlyNumbers(event);" ReadOnly="true" Style="background-color: #ececec;"></asp:TextBox></td>
                    </tr>


                    <tr>
                        <th colspan="4" style="color: #ec2029">*옵션코드</th>
                        <td colspan="8">
                            <asp:TextBox runat="server" CssClass="txtB" Width="300px" ID="txtOptionSummaryCode"></asp:TextBox>
                            <input type="button" value="옵션코드생성" class="btnDelete" onclick="fnCreateOptionSumCode(); return false;" />
                        </td>

                    </tr>

                    <tr>
                        <th>속성명1&nbsp;&nbsp;<img src="../Images/Goods/test2.png" alt="검색" id="imgSearchOption_1" onclick="fnOpenOptionPopup(1); return false;" style="cursor: pointer" />
                            <input type="checkbox" id="cbSummaryOptionCode_1" />
                            <img src="../Images/Goods/c444.jpg" id="imgDelete_1" alt="X" onclick="return fnGoodsOptionDel(this, 1);" style="cursor: pointer" />
                            <input type="hidden" id="hdOptionCode_1" />
                        </th>
                        <td>
                            <asp:TextBox ID="txtOptionName_1" runat="server" CssClass="txtB" ReadOnly="true" Style="background-color: #ececec;" Width="85%"></asp:TextBox><span onclick="return fnDelPopuptext();" style="padding-left: 2px; cursor: pointer" id="spanOptionTextDel_1"><img src="../Images/Goods/c4.jpg" alt="x" /></span></td>
                        <th>속성값1</th>
                        <td colspan="2">
                            <asp:TextBox ID="txtOptionVal_1" runat="server" CssClass="txtB"></asp:TextBox></td>
                        <th>속성명11&nbsp;&nbsp;<img src="../Images/Goods/test2.png" alt="검색" id="imgSearchOption_11" onclick="fnOpenOptionPopup(11); return false;" style="cursor: pointer" />
                            <input type="checkbox" id="cbSummaryOptionCode_11" />
                            <input type="hidden" id="hdOptionCode_11" />
                            <img src="../Images/Goods/c444.jpg" id="imgDelete_11" alt="x" onclick="return fnGoodsOptionDel(this, 11);" style="cursor: pointer" />
                        </th>
                        <td>
                            <asp:TextBox ID="txtOptionName_11" runat="server" CssClass="txtB" ReadOnly="true" Style="background-color: #ececec;" Width="85%"></asp:TextBox>
                            <span onclick="return fnDelPopuptext();" style="cursor: pointer" id="spanOptionTextDel_11">
                                <img src="../Images/Goods/c4.jpg" alt="x" /></span></td>
                        <th>속성값11</th>
                        <td colspan="2">
                            <asp:TextBox ID="txtOptionVal_11" runat="server" CssClass="txtB"></asp:TextBox></td>
                    </tr>

                    <tr>
                        <th>속성명2&nbsp;&nbsp;<img src="../Images/Goods/test2.png" alt="검색" id="imgSearchOption_2" onclick="fnOpenOptionPopup(2); return false;" style="cursor: pointer" />
                            <input type="checkbox" id="cbSummaryOptionCode_2" />
                            <input type="hidden" id="hdOptionCode_2" />
                            <img src="../Images/Goods/c444.jpg" id="imgDelete_2" alt="x" onclick="return fnGoodsOptionDel(this, 2);" style="cursor: pointer" />
                        </th>
                        <td>
                            <asp:TextBox ID="txtOptionName_2" runat="server" CssClass="txtB" ReadOnly="true" Style="background-color: #ececec;" Width="85%"></asp:TextBox><span onclick="return fnDelPopuptext();" style="padding-left: 2px; cursor: pointer" id="spanOptionTextDel_2"><img src="../Images/Goods/c4.jpg" alt="x" /></span></td>
                        <th>속성값2</th>
                        <td colspan="2">
                            <asp:TextBox ID="txtOptionVal_2" runat="server" CssClass="txtB"></asp:TextBox></td>
                        <th>속성명12&nbsp;&nbsp;<img src="../Images/Goods/test2.png" alt="검색" id="imgSearchOption_12" onclick="fnOpenOptionPopup(12); return false;" style="cursor: pointer" />
                            <input type="checkbox" id="cbSummaryOptionCode_12" />
                            <input type="hidden" id="hdOptionCode_12" />
                            <img src="../Images/Goods/c444.jpg" id="imgDelete_12" alt="x" onclick="return fnGoodsOptionDel(this, 12);" style="cursor: pointer" />
                        </th>
                        <td>
                            <asp:TextBox ID="txtOptionName_12" runat="server" CssClass="txtB" ReadOnly="true" Style="background-color: #ececec;" Width="85%"></asp:TextBox>
                            <a onclick="return fnDelPopuptext();" style="cursor: pointer" id="spanOptionTextDel_12">
                                <img src="../Images/Goods/c4.jpg" /></a>


                        </td>
                        <th>속성값12</th>
                        <td colspan="2">
                            <asp:TextBox ID="txtOptionVal_12" runat="server" CssClass="txtB"></asp:TextBox></td>
                    </tr>

                    <tr>
                        <th>속성명3&nbsp;&nbsp;<img src="../Images/Goods/test2.png" alt="검색" id="imgSearchOption_3" onclick="fnOpenOptionPopup(3); return false;" style="cursor: pointer" />
                            <input type="checkbox" id="cbSummaryOptionCode_3" />
                            <input type="hidden" id="hdOptionCode_3" />
                            <img src="../Images/Goods/c444.jpg" id="imgDelete_3" alt="x" onclick="return fnGoodsOptionDel(this, 3);" style="cursor: pointer" />
                        </th>
                        <td>
                            <asp:TextBox ID="txtOptionName_3" runat="server" CssClass="txtB" ReadOnly="true" Style="background-color: #ececec;" Width="85%"></asp:TextBox><span onclick="return fnDelPopuptext();" style="padding-left: 2px; cursor: pointer" id="spanOptionTextDel_3"><img src="../Images/Goods/c4.jpg" alt="x" /></span></td>
                        <th>속성값3</th>
                        <td colspan="2">
                            <asp:TextBox ID="txtOptionVal_3" runat="server" CssClass="txtB"></asp:TextBox></td>
                        <th>속성명13&nbsp;&nbsp;<img src="../Images/Goods/test2.png" alt="검색" id="imgSearchOption_13" onclick="fnOpenOptionPopup(13); return false;" style="cursor: pointer;" />
                            <input type="checkbox" id="cbSummaryOptionCode_13" />
                            <input type="hidden" id="hdOptionCode_13" />
                            <img src="../Images/Goods/c444.jpg" id="imgDelete_13" alt="x" onclick="return fnGoodsOptionDel(this, 13);" style="cursor: pointer" />
                        </th>
                        <td>
                            <asp:TextBox ID="txtOptionName_13" runat="server" CssClass="txtB" ReadOnly="true" Style="background-color: #ececec;" Width="85%"></asp:TextBox><span onclick="return fnDelPopuptext();" style="padding-left: 2px; cursor: pointer" id="spanOptionTextDel_13"><img src="../Images/Goods/c4.jpg" alt="x" /></span></td>
                        <th>속성값13</th>
                        <td colspan="2">
                            <asp:TextBox ID="txtOptionVal_13" runat="server" CssClass="txtB"></asp:TextBox></td>
                    </tr>

                    <tr>
                        <th>속성명4&nbsp;&nbsp;<img src="../Images/Goods/test2.png" alt="검색" id="imgSearchOption_4" onclick="fnOpenOptionPopup(4); return false;" style="cursor: pointer" />
                            <input type="checkbox" id="cbSummaryOptionCode_4" />
                            <input type="hidden" id="hdOptionCode_4" />
                            <img src="../Images/Goods/c444.jpg" id="imgDelete_4" alt="x" onclick="return fnGoodsOptionDel(this, 4);" style="cursor: pointer" />
                        </th>
                        <td>
                            <asp:TextBox ID="txtOptionName_4" runat="server" CssClass="txtB" ReadOnly="true" Style="background-color: #ececec;" Width="85%"></asp:TextBox><span onclick="return fnDelPopuptext();" style="padding-left: 2px; cursor: pointer" id="spanOptionTextDel_4"><img src="../Images/Goods/c4.jpg" alt="x" /></span></td>
                        <th>속성값4</th>
                        <td colspan="2">
                            <asp:TextBox ID="txtOptionVal_4" runat="server" CssClass="txtB"></asp:TextBox></td>
                        <th>속성명14&nbsp;&nbsp;<img src="../Images/Goods/test2.png" alt="검색" id="imgSearchOption_14" onclick="fnOpenOptionPopup(14); return false;" style="cursor: pointer" />
                            <input type="checkbox" id="cbSummaryOptionCode_14" />
                            <input type="hidden" id="hdOptionCode_14" />
                            <img src="../Images/Goods/c444.jpg" id="imgDelete_14" alt="x" onclick="return fnGoodsOptionDel(this, 14);" style="cursor: pointer" />
                        </th>
                        <td>
                            <asp:TextBox ID="txtOptionName_14" runat="server" CssClass="txtB" ReadOnly="true" Style="background-color: #ececec;" Width="85%"></asp:TextBox><span onclick="return fnDelPopuptext();" style="padding-left: 2px; cursor: pointer" id="spanOptionTextDel_14"><img src="../Images/Goods/c4.jpg" alt="x" /></span></td>
                        <th>속성값14</th>
                        <td colspan="2">
                            <asp:TextBox ID="txtOptionVal_14" runat="server" CssClass="txtB"></asp:TextBox></td>
                    </tr>

                    <tr>
                        <th>속성명5&nbsp;&nbsp;<img src="../Images/Goods/test2.png" alt="검색" id="imgSearchOption_5" onclick="fnOpenOptionPopup(5); return false;" style="cursor: pointer" />
                            <input type="checkbox" id="cbSummaryOptionCode_5" />
                            <input type="hidden" id="hdOptionCode_5" />
                            <img src="../Images/Goods/c444.jpg" id="imgDelete_5" alt="x" onclick="return fnGoodsOptionDel(this, 5);" style="cursor: pointer" />
                        </th>
                        <td>
                            <asp:TextBox ID="txtOptionName_5" runat="server" CssClass="txtB" ReadOnly="true" Style="background-color: #ececec;" Width="85%"></asp:TextBox><span onclick="return fnDelPopuptext();" style="padding-left: 2px; cursor: pointer" id="spanOptionTextDel_5"><img src="../Images/Goods/c4.jpg" alt="x" /></span></td>
                        <th>속성값5</th>
                        <td colspan="2">
                            <asp:TextBox ID="txtOptionVal_5" runat="server" CssClass="txtB"></asp:TextBox></td>
                        <th>속성명15&nbsp;&nbsp;<img src="../Images/Goods/test2.png" alt="검색" id="imgSearchOption_15" onclick="fnOpenOptionPopup(15); return false;" style="cursor: pointer" />
                            <input type="checkbox" id="cbSummaryOptionCode_15" />
                            <input type="hidden" id="hdOptionCode_15" />
                            <img src="../Images/Goods/c444.jpg" id="imgDelete_15" alt="x" onclick="return fnGoodsOptionDel(this, 15);" style="cursor: pointer" />
                        </th>
                        <td>
                            <asp:TextBox ID="txtOptionName_15" runat="server" CssClass="txtB" ReadOnly="true" Style="background-color: #ececec;" Width="85%"></asp:TextBox><span onclick="return fnDelPopuptext();" style="padding-left: 2px; cursor: pointer" id="spanOptionTextDel_15"><img src="../Images/Goods/c4.jpg" alt="x" /></span></td>
                        <th>속성값15</th>
                        <td colspan="2">
                            <asp:TextBox ID="txtOptionVal_15" runat="server" CssClass="txtB"></asp:TextBox></td>
                    </tr>

                    <tr>
                        <th>속성명6&nbsp;&nbsp;<img src="../Images/Goods/test2.png" alt="검색" id="imgSearchOption_6" onclick="fnOpenOptionPopup(6); return false;" style="cursor: pointer" />
                            <input type="checkbox" id="cbSummaryOptionCode_6" />
                            <input type="hidden" id="hdOptionCode_6" />
                            <img src="../Images/Goods/c444.jpg" id="imgDelete_6" alt="x" onclick="return fnGoodsOptionDel(this, 6);" style="cursor: pointer" />
                        </th>
                        <td>
                            <asp:TextBox ID="txtOptionName_6" runat="server" CssClass="txtB" ReadOnly="true" Style="background-color: #ececec;" Width="85%"></asp:TextBox><span onclick="return fnDelPopuptext();" style="padding-left: 2px; cursor: pointer" id="spanOptionTextDel_6"><img src="../Images/Goods/c4.jpg" alt="x" /></span></td>
                        <th>속성값6</th>
                        <td colspan="2">
                            <asp:TextBox ID="txtOptionVal_6" runat="server" CssClass="txtB"></asp:TextBox></td>
                        <th>속성명16&nbsp;&nbsp;<img src="../Images/Goods/test2.png" alt="검색" id="imgSearchOption_16" onclick="fnOpenOptionPopup(16); return false;" style="cursor: pointer" />
                            <input type="checkbox" id="cbSummaryOptionCode_16" />
                            <input type="hidden" id="hdOptionCode_16" />
                            <img src="../Images/Goods/c444.jpg" id="imgDelete_16" alt="x" onclick="return fnGoodsOptionDel(this, 16);" style="cursor: pointer" />
                        </th>
                        <td>
                            <asp:TextBox ID="txtOptionName_16" runat="server" CssClass="txtB" ReadOnly="true" Style="background-color: #ececec;" Width="85%"></asp:TextBox><span onclick="return fnDelPopuptext();" style="padding-left: 2px; cursor: pointer" id="spanOptionTextDel_16"><img src="../Images/Goods/c4.jpg" alt="x" /></span></td>
                        <th>속성값16</th>
                        <td colspan="2">
                            <asp:TextBox ID="txtOptionVal_16" runat="server" CssClass="txtB"></asp:TextBox></td>
                    </tr>

                    <tr>
                        <th>속성명7&nbsp;&nbsp;<img src="../Images/Goods/test2.png" alt="검색" id="imgSearchOption_7" onclick="fnOpenOptionPopup(7); return false;" style="cursor: pointer" />
                            <input type="checkbox" id="cbSummaryOptionCode_7" />
                            <input type="hidden" id="hdOptionCode_7" />
                            <img src="../Images/Goods/c444.jpg" id="imgDelete_7" alt="x" onclick="return fnGoodsOptionDel(this, 7);" style="cursor: pointer" />
                        </th>
                        <td>
                            <asp:TextBox ID="txtOptionName_7" runat="server" CssClass="txtB" ReadOnly="true" Style="background-color: #ececec;" Width="85%"></asp:TextBox><span onclick="return fnDelPopuptext();" style="padding-left: 2px; cursor: pointer" id="spanOptionTextDel_7"><img src="../Images/Goods/c4.jpg" alt="x" /></span></td>
                        <th>속성값7</th>
                        <td colspan="2">
                            <asp:TextBox ID="txtOptionVal_7" runat="server" CssClass="txtB"></asp:TextBox></td>
                        <th>속성명17&nbsp;&nbsp;<img src="../Images/Goods/test2.png" alt="검색" id="imgSearchOption_17" onclick="fnOpenOptionPopup(17); return false;" style="cursor: pointer" />
                            <input type="checkbox" id="cbSummaryOptionCode_17" />
                            <input type="hidden" id="hdOptionCode_17" />
                            <img src="../Images/Goods/c444.jpg" id="imgDelete_17" alt="x" onclick="return fnGoodsOptionDel(this, 17);" style="cursor: pointer" />
                        <td>
                            <asp:TextBox ID="txtOptionName_17" runat="server" CssClass="txtB" ReadOnly="true" Style="background-color: #ececec;" Width="85%"></asp:TextBox><span onclick="return fnDelPopuptext();" style="padding-left: 2px; cursor: pointer" id="spanOptionTextDel_17"><img src="../Images/Goods/c4.jpg" alt="x" /></span></td>
                        <th>속성값17</th>
                        <td colspan="2">
                            <asp:TextBox ID="txtOptionVal_17" runat="server" CssClass="txtB"></asp:TextBox></td>
                    </tr>

                    <tr>
                        <th>속성명8&nbsp;&nbsp;<img src="../Images/Goods/test2.png" alt="검색" id="imgSearchOption_8" onclick="fnOpenOptionPopup(8); return false;" style="cursor: pointer" />
                            <input type="checkbox" id="cbSummaryOptionCode_8" />
                            <input type="hidden" id="hdOptionCode_8" />
                            <img src="../Images/Goods/c444.jpg" id="imgDelete_8" alt="x" onclick="return fnGoodsOptionDel(this, 8);" style="cursor: pointer" />
                        </th>
                        <td>
                            <asp:TextBox ID="txtOptionName_8" runat="server" CssClass="txtB" ReadOnly="true" Style="background-color: #ececec;" Width="85%"></asp:TextBox><span onclick="return fnDelPopuptext();" style="padding-left: 2px; cursor: pointer" id="spanOptionTextDel_8"><img src="../Images/Goods/c4.jpg" alt="x" /></span></td>
                        <th>속성값8</th>
                        <td colspan="2">
                            <asp:TextBox ID="txtOptionVal_8" runat="server" CssClass="txtB"></asp:TextBox></td>
                        <th>속성명18&nbsp;&nbsp;<img src="../Images/Goods/test2.png" alt="검색" id="imgSearchOption_18" onclick="fnOpenOptionPopup(18); return false;" style="cursor: pointer" />
                            <input type="checkbox" id="cbSummaryOptionCode_18" />
                            <input type="hidden" id="hdOptionCode_18" />
                            <img src="../Images/Goods/c444.jpg" id="imgDelete_18" alt="x" onclick="return fnGoodsOptionDel(this, 18);" style="cursor: pointer" />
                        <td>
                            <asp:TextBox ID="txtOptionName_18" runat="server" CssClass="txtB" ReadOnly="true" Style="background-color: #ececec;" Width="85%"></asp:TextBox><span onclick="return fnDelPopuptext();" style="padding-left: 2px; cursor: pointer" id="spanOptionTextDel_18"><img src="../Images/Goods/c4.jpg" alt="x" /></span></td>
                        <th>속성값18</th>
                        <td colspan="2">
                            <asp:TextBox ID="txtOptionVal_18" runat="server" CssClass="txtB"></asp:TextBox></td>
                    </tr>

                    <tr>
                        <th>속성명9&nbsp;&nbsp;<img src="../Images/Goods/test2.png" alt="검색" id="imgSearchOption_9" onclick="fnOpenOptionPopup(9); return false;" style="cursor: pointer" />
                            <input type="checkbox" id="cbSummaryOptionCode_9" />
                            <input type="hidden" id="hdOptionCode_9" />
                            <img src="../Images/Goods/c444.jpg" id="imgDelete_9" alt="x" onclick="return fnGoodsOptionDel(this, 9);" style="cursor: pointer" />
                        </th>
                        <td>
                            <asp:TextBox ID="txtOptionName_9" runat="server" CssClass="txtB" ReadOnly="true" Style="background-color: #ececec;" Width="85%"></asp:TextBox><span onclick="return fnDelPopuptext();" style="padding-left: 2px; cursor: pointer" id="spanOptionTextDel_9"><img src="../Images/Goods/c4.jpg" alt="x" /></span></td>
                        <th>속성값9</th>
                        <td colspan="2">
                            <asp:TextBox ID="txtOptionVal_9" runat="server" CssClass="txtB"></asp:TextBox></td>
                        <th>속성명19&nbsp;&nbsp;<img src="../Images/Goods/test2.png" alt="검색" id="imgSearchOption_19" onclick="fnOpenOptionPopup(19); return false;" style="cursor: pointer" />
                            <input type="checkbox" id="cbSummaryOptionCode_19" />
                            <input type="hidden" id="hdOptionCode_19" />
                            <img src="../Images/Goods/c444.jpg" id="imgDelete_19" alt="x" onclick="return fnGoodsOptionDel(this, 19);" style="cursor: pointer" />
                        </th>
                        <td>
                            <asp:TextBox ID="txtOptionName_19" runat="server" CssClass="txtB" ReadOnly="true" Style="background-color: #ececec;" Width="85%"></asp:TextBox><span onclick="return fnDelPopuptext();" style="padding-left: 2px; cursor: pointer" id="spanOptionTextDel_19"><img src="../Images/Goods/c4.jpg" alt="x" /></span></td>
                        <th>속성값19</th>
                        <td colspan="2">
                            <asp:TextBox ID="txtOptionVal_19" runat="server" CssClass="txtB"></asp:TextBox></td>
                    </tr>

                    <tr>
                        <th>속성명10&nbsp;&nbsp;<img src="../Images/Goods/test2.png" alt="검색" id="imgSearchOption_10" onclick="fnOpenOptionPopup(10); return false;" style="cursor: pointer" />
                            <input type="checkbox" id="cbSummaryOptionCode_10" />
                            <input type="hidden" id="hdOptionCode_10" />
                            <img src="../Images/Goods/c444.jpg" id="imgDelete_10" alt="x" onclick="return fnGoodsOptionDel(this, 10);" style="cursor: pointer" />
                        </th>
                        <td>
                            <asp:TextBox ID="txtOptionName_10" runat="server" CssClass="txtB" ReadOnly="true" Style="background-color: #ececec;" Width="85%"></asp:TextBox><span onclick="return fnDelPopuptext();" style="padding-left: 2px; cursor: pointer" id="spanOptionTextDel_10"><img src="../Images/Goods/c4.jpg" alt="x" /></span></td>
                        <th>속성값10</th>
                        <td colspan="2">
                            <asp:TextBox ID="txtOptionVal_10" runat="server" CssClass="txtB"></asp:TextBox></td>
                        <th>속성명20&nbsp;<img src="../Images/Goods/test2.png" alt="검색" id="imgSearchOption_20" onclick="fnOpenOptionPopup(20); return false;" style="cursor: pointer" />
                            <input type="checkbox" id="cbSummaryOptionCode_20" />
                            <input type="hidden" id="hdOptionCode_20" />
                            <img src="../Images/Goods/c444.jpg" id="imgDelete_20" alt="x" onclick="return fnGoodsOptionDel(this, 20);" style="cursor: pointer" />
                        </th>
                        <td>
                            <asp:TextBox ID="txtOptionName_20" runat="server" CssClass="txtB" ReadOnly="true" Style="background-color: #ececec;" Width="85%"></asp:TextBox><span onclick="return fnDelPopuptext();" style="padding-left: 2px; cursor: pointer" id="spanOptionTextDel_20"><img src="../Images/Goods/c4.jpg" alt="x" /></span></td>
                        <th>속성값20</th>
                        <td colspan="2">
                            <asp:TextBox ID="txtOptionVal_20" runat="server" CssClass="txtB"></asp:TextBox></td>
                    </tr>

                    <tr>
                        <th rowspan="4" colspan="2">공급사공통</th>
                        <th colspan="2" style="color: #ec2029">*매입상품유형</th>
                        <td colspan="2">
                            <asp:DropDownList runat="server" CssClass="txtB" ID="ddlSupplyBuyGoodsType"></asp:DropDownList></td>

                        <th colspan="2" style="padding-left: 40px; color: #ec2029">*단위코드&nbsp;&nbsp;<a onclick="return commonPopUp(this)" id="SupplyUnitCode"><img src="../Images/Goods/test2.png" alt="검색" /></a></th>
                        <td colspan="2">
                            <asp:TextBox runat="server" CssClass="txtB" Style="background-color: #ececec;" ReadOnly="true" ID="txtSupplyCompUnitCode"></asp:TextBox></td>

                    </tr>

                    <tr>
                        <th colspan="2" style="color: #ec2029">*상품유통기간관리여부</th>
                        <td colspan="2">
                            <asp:DropDownList runat="server" CssClass="txtB" ID="ddlSupplyGoodsDistrAdmin">
                                <asp:ListItem Text="예" Value="1"></asp:ListItem>
                                <asp:ListItem Text="아니오" Value="2"></asp:ListItem>
                            </asp:DropDownList></td>
                        <th colspan="2" style="padding-left: 40px; color: #ec2029">*원산지코드&nbsp;&nbsp;&nbsp;<a onclick="fnOpenOriginPopup(); return false;"><img src="../Images/Goods/test2.png" alt="검색" /></a></th>
                        <td colspan="2">
                            <asp:TextBox runat="server" CssClass="txtB" Style="background-color: #ececec;" ReadOnly="true" ID="txtGoodsOriginCode"></asp:TextBox></td>
                    </tr>
                    <tr>
                        <th colspan="2">공통바코드</th>
                        <th>Qty바코드</th>
                        <td>
                            <asp:TextBox runat="server" CssClass="txtB" placeholder="내용입력" ID="txtBarcode1"></asp:TextBox></td>
                        <th>In바코드</th>
                        <td>
                            <asp:TextBox runat="server" CssClass="txtB" placeholder="내용입력" ID="txtBarcode2"></asp:TextBox></td>
                        <th>Out바코드</th>
                        <td>
                            <asp:TextBox runat="server" CssClass="txtB" placeholder="내용입력" ID="txtBarcode3"></asp:TextBox></td>
                    </tr>
                    <tr>
                        <th colspan="2" style="color: #ec2029">*상품 인증 구분
                        </th>
                        <td colspan="6" class="txt-center">
                            <input type="checkbox" id="cbCertified1" />사회적 기업&nbsp;&nbsp;
               <input type="checkbox" id="cbCertified2" />여성 기업&nbsp;&nbsp;
               <input type="checkbox" id="cbCertified3" />장애인 표준사업장&nbsp;&nbsp;
               <input type="checkbox" id="cbCertified4" />협동조합&nbsp;&nbsp;
               <input type="checkbox" id="cbCertified5" />중증 장애인 생산품&nbsp;&nbsp;
               <input type="checkbox" id="cbCertified6" />기타&nbsp;&nbsp;
               <input type="checkbox" id="cbCertified7" />임시1&nbsp;&nbsp;
               <input type="checkbox" id="cbCertified8" />임시2
                        </td>
                    </tr>

                    <tr>
                        <th rowspan="5" colspan="2">공급사</th>
                        <th style="color: #ec2029">*공급사코드&nbsp;<a onclick="return commonPopUp(this)" id="supplyCompanyCode1"><img src="../Images/Goods/test2.png" alt="검색" /></a></th>
                        <td>
                            <asp:TextBox runat="server" CssClass="txtB" Style="width: 86%; background-color: #ececec;" ReadOnly="true" ID="txtSupplyCompanyCode1"></asp:TextBox><span onclick="return fnDelPopuptext_2(this);" style="padding-left: 2px; cursor: pointer" id="spanTextDel_1"><img src="../Images/Goods/c4.jpg" alt="x" /></span></td>
                        <th style="color: #ec2029">*공급사명</th>
                        <td>
                            <asp:TextBox runat="server" CssClass="txtL" Style="background-color: #ececec;" ReadOnly="true" ID="txtSupplyCompanyName1"></asp:TextBox></td>
                        <th>공급사상품코드</th>
                        <td>
                            <asp:TextBox runat="server" CssClass="txtB" placeholder="내용입력" ID="txtSupplyGoodsCode1"></asp:TextBox></td>
                        <th>공급사바코드</th>
                        <td>
                            <asp:TextBox runat="server" CssClass="txtB" placeholder="내용입력" ID="txtSupplyCompanyBarcode1"></asp:TextBox></td>
                    </tr>
                    <tr>
                        <th colspan="2" style="color: #ec2029">*매입MOQ</th>
                        <td colspan="2">
                            <asp:TextBox runat="server" CssClass="txtB" placeholder="내용입력" ID="txtSupplyBuyGoodsMoq"></asp:TextBox></td>
                        <th colspan="2" style="color: #ec2029">*입고LeadTime</th>
                        <td colspan="2">
                            <asp:DropDownList runat="server" CssClass="txtB" ID="ddlSupplyGoodsEnterDue"></asp:DropDownList></td>

                    </tr>
                    <tr>
                        <th colspan="2" style="color: #ec2029">*매입정산구분</th>
                        <td colspan="2">
                            <asp:DropDownList runat="server" CssClass="txtB" ID="ddlSupplyBuyCalc"></asp:DropDownList></td>
                        <th colspan="2" style="color: #ec2029">*발주형태</th>
                        <td colspan="2">
                            <asp:DropDownList runat="server" CssClass="txtB" ID="ddlOrderForm"></asp:DropDownList></td>

                    </tr>
                    <tr>
                        <th colspan="2">매입운송비유무</th>
                        <td colspan="2">
                            <asp:DropDownList runat="server" CssClass="txtB" ID="ddlPurchaseTransportCost1">
                                <asp:ListItem Text="예" Value="1"></asp:ListItem>
                                <asp:ListItem Text="아니오" Value="2"></asp:ListItem>
                            </asp:DropDownList>
                        </td>
                        <th colspan="2">매입운송비용</th>
                        <td colspan="2">
                            <asp:TextBox runat="server" CssClass="txtB" ID="txtPurchaseTransportCost1" onkeydown="return onlyNumbers(event); "></asp:TextBox></td>
                    </tr>
                    <tr>
                        <th colspan="2">상품제조유통기간</th>
                        <td colspan="6">
                            <asp:TextBox runat="server" CssClass="txtB" placeholder="개월수입력" ID="txtSupplyGoodsDistrDue" onkeypress="return onlyNumbers(event);"></asp:TextBox></td>
                    </tr>

                    <tr>
                        <th rowspan="2" colspan="2">배송관련</th>
                        <th colspan="2" style="color: #ec2029">*배송구분</th>
                        <td colspan="2">
                            <asp:DropDownList runat="server" CssClass="txtB" ID="ddlDeliveryGubun"></asp:DropDownList>
                        </td>
                        <th colspan="2" style="color: #ec2029">*배송비구분</th>
                        <td colspan="2">
                            <asp:DropDownList runat="server" CssClass="txtB" ID="ddlDeliveryCostGubun" onchange="fnSetDeliveryCostCode(this); return false;"></asp:DropDownList></td>
                    </tr>

                    <tr>
                        <th colspan="2" style="padding-left: 20px; color: #ec2029">*배송비 비용코드&nbsp;&nbsp;<a onclick="fnOpenDeliveryPopup(); return false;"><img src="../Images/Goods/test2.png" alt="검색" /></a></th>
                        <td colspan="6">
                            <asp:TextBox runat="server" CssClass="txtB" Style="background-color: #ececec;" ReadOnly="true" ID="txtDeliveryGubunCode"></asp:TextBox></td>

                    </tr>

                </table>

                <div style="text-align: right; margin-top: 30px; margin-bottom: 30px; clear: both">
                    <input type="button" class="mainbtn type1" style="width: 95px; height: 30px;" value=" 상품 저장" onclick="return fnGoodsUpdate();">
                </div>



                <asp:HiddenField ID="hdfinalCode" Value="" runat="server" />
                <asp:HiddenField ID="hdgroupCode" Value="" runat="server" />
                <asp:HiddenField ID="hdgoodsCode" Value="" runat="server" />


            </div>
        </div>


    </div>

    <!--그룹코드 (1종)  팝업-->

    <div id="CodeSearchDiv" class="popupdiv divpopup-layer-package">
        <div class="popupdivWrapper" style="margin-top: 50px; width: 700px; height: 750px;">
            <div class="popupdivContents" style="border: none;">
                <div class="sub-title-div" id="divSubTitle"></div>

                <div class="divpopup-layer-conts">
                    <div>
                        <div id="divSelectBox" style="display: inline">
                        </div>
                        <input type="text" id="txtSearch" style="width: 300px; height: 25px; border: 1px solid #a2a2a2" onkeypress="return fnEnter()" />

                        <input type="button" class="mainbtn type1" style="width: 75px" id="btnSearch" value="검색" onclick="return fnSearch(1)" />
                    </div>

                    <div class="divScr" style="margin-top: 20px">
                        <table id="tblSearch" class="tbl_main tbl_pop">
                            <colgroup>
                                <col style="width: 100px" />
                                <col style="width: 100px" />
                            </colgroup>
                            <thead>
                                <tr class="">
                                    <th class="txt-center">번호</th>
                                    <th class="txt-center" id="thCode">속성코드</th>
                                    <th class="txt-center" id="thName">속성명</th>
                                </tr>
                            </thead>
                            <tbody id="pop_commonTbody" style="height: 25px"></tbody>
                        </table>
                    </div>
                    <br />
                    <input type="hidden" id="txtCode" />

                    <!--페이징-->
                    <input type="hidden" id="hdTotalCount" />
                    <div style="margin: 0 auto; text-align: center">
                        <div id="pagination" class="page_curl" style="display: inline-block"></div>
                    </div>

                    <div class="btn_center">

                        <input type="hidden" id="hdSelectCode" />
                        <input type="hidden" id="hdSelectName" />
                        <input type="button" style="width: 75px;" id="btnCancel" onclick="fnClosePopup('CodeSearchDiv'); return false;" value="취소" class="mainbtn type2" />
                        <input type="button" style="width: 75px;" id="btnSave" onclick="fnConfirm()" value="확인" class="mainbtn type1" />

                    </div>

                </div>
            </div>
        </div>
    </div>


    <!--속성팝업-->

    <div id="OptionCodeSearchDiv" class="popupdiv divpopup-layer-package">
        <div class="popupdivWrapper" style="margin-top: 50px; width: 700px; height: 800px;">
            <div class="popupdivContents" style="border: none;">
                <div class="sub-title-div">
                    <h3 class='pop-title'>속성수정</h3>
                </div>
                <div class="divpopup-layer-conts">
                    <div>
                        <select id="selectOptionTarget" style="width: 100px; height: 25px">
                            <option value="Code">옵션코드</option>
                            <option value="Name">옵션명</option>
                        </select>
                        <input type="text" id="txtOptionPopupSearch" style="width: 300px; height: 25px; border: 1px solid #a2a2a2" onkeypress="return fnOptionPopupEnter()" />

                        <input type="button" class="mainbtn type1" style="width: 75px" value="검색" onclick="return fnOptionDataBind(1)" />
                    </div>

                    <div class="divScr" style="margin-top: 20px">
                        <table id="tblSearchCode" class="tbl_main tbl_pop">
                            <colgroup>
                                <col style="width: 100px" />
                                <col style="width: 100px" />
                            </colgroup>
                            <thead>
                                <tr class="">
                                    <th class="txt-center">번호</th>
                                    <th class="txt-center">옵션코드</th>
                                    <th class="txt-center">옵션명</th>
                                </tr>
                            </thead>
                            <tbody id="tblSearchCode_tbody" style="height: 25px"></tbody>
                        </table>


                        <!--페이징-->
                        <input type="hidden" id="hdOptionPopupTotalCount" />
                        <div style="margin: 0 auto; text-align: center">
                            <div id="optionPopuppagination" class="page_curl" style="display: inline-block"></div>
                        </div>
                    </div>


                    <!--페이징-->
                    <input type="hidden" id="hdSearchCodeTotalCount" />
                    <div style="margin: 0 auto; text-align: center">
                        <div id="searchCodePagination" class="page_curl" style="display: inline-block"></div>
                    </div>

                    <div class="btn_center">

                        <input type="hidden" id="hdSelectOptionLevel" />
                        <input type="hidden" id="hdSelectOptionCode" />
                        <input type="hidden" id="hdSelectOptionName" />
                        <input type="button" style="width: 75px;" id="btnOptionCancel" onclick="fnClosePopup('OptionCodeSearchDiv')" value="취소" class="mainbtn type2" />
                        <input type="button" style="width: 75px;" id="btnOptionSave" onclick="fnOptionPopupConfirm()" value="확인" class="mainbtn type1" />
                    </div>

                </div>
            </div>
        </div>
    </div>

    <div id="OriginCodeSearchDiv" class="popupdiv divpopup-layer-package">
        <div class="popupdivWrapper" style="margin-top: 50px; width: 700px; height: 800px;">
            <div class="popupdivContents" style="border: none;">
                <div class="divpopup-layer-container">
                    <div class="popup-title" style="margin-top: 20px;">
                        <h3 class="pop-title">원산지코드</h3>
                    </div>
                    <div class="divpopup-layer-conts">
                        <div>
                            <input type="text" id="txtOriginPopupSearch" style="width: 300px; height: 25px; border: 1px solid #a2a2a2" onkeypress="return fnOriginPopupEnter()" placeholder="원산지명을 입력하세요" />

                            <input type="button" class="mainbtn type1" style="width: 75px" value="검색" onclick="return fnOptionDataBind(1)" />
                        </div>

                        <div class="" style="margin-top: 20px;">
                            <table id="tblOriginCode" class="tbl_main tbl_pop">
                                <colgroup>
                                    <col style="width: 100px" />
                                    <col style="width: 100px" />
                                </colgroup>
                                <thead>
                                    <tr class="">
                                        <th class="txt-center">번호</th>
                                        <th class="txt-center">원산지코드</th>
                                        <th class="txt-center">원산지명</th>
                                    </tr>
                                </thead>
                                <tbody id="tblSearchOriginCode_tbody" style="height: 25px"></tbody>
                            </table>
                            <br />

                            <!--페이징-->
                            <input type="hidden" id="hdOriginPopupTotalCount" />
                            <div style="margin: 0 auto; text-align: center">
                                <div id="originPopuppagination" class="page_curl" style="display: inline-block"></div>
                            </div>
                        </div>
                        <br />

                        <div class="btn_center">
                            <input type="hidden" id="hdSelectOriginCode" />
                            <input type="hidden" id="hdSelectOriginName" />
                            <input type="button" style="width: 75px;" id="btnOriginCancel" onclick="fnClosePopup('OriginCodeSearchDiv')" value="취소" class="mainbtn type2" />
                            <input type="button" style="width: 75px;" id="btnOriginSave" onclick="fnOriginPopupConfirm()" value="확인" class="mainbtn type1" />


                        </div>

                    </div>
                </div>
            </div>
        </div>
    </div>

    <!--배송비 비용구분 팝업-->

    <div id="deliveryCodeSearchDiv" class="popupdiv divpopup-layer-package">
        <div class="popupdivWrapper" style="margin-top: 50px; width: 700px; height: 730px;">
            <div class="popupdivContents" style="border: none;">
                <div class="popup-title" style="margin-top: 20px;">
                    <h3 class='pop-title'>배송비 비용코드 검색</h3>
                </div>
                <div class="divpopup-layer-conts">

                    <div class="" style="margin-top: 20px; height: 543px; overflow-y: auto">
                        <table id="tblDeliveryCode" class="tbl_main tbl_pop">
                            <colgroup>
                                <col style="width: 100px" />
                                <col style="width: 100px" />
                            </colgroup>
                            <thead>
                                <tr class="">
                                    <th class="txt-center">번호</th>
                                    <th class="txt-center">비용코드</th>
                                    <th class="txt-center">비용</th>
                                </tr>
                            </thead>
                            <tbody id="tblDeliveryCode_tbody" style="height: 25px"></tbody>
                        </table>
                    </div>
                    <br />

                    <div class="btn_center">
                        <input type="hidden" id="hdSelectDeliveryCode" />
                        <input type="hidden" id="hdSelectDeliveryName" />
                        <input type="button" style="width: 75px;" id="btnDeliveryCancel" onclick="fnClosePopup('deliveryCodeSearchDiv')" value="취소" class="mainbtn type2" />
                        <input type="button" style="width: 75px;" id="btnDeliverySave" onclick="fnDeliveryPopupConfirm()" value="확인" class="mainbtn type1" />


                    </div>

                </div>
            </div>
        </div>
    </div>

    <!--서비스용역조회 팝업-->

    <div id="goodsSearchDiv" class="popupdiv divpopup-layer-package">
        <div class="popupdivWrapper" style="margin-top: 100px; width: 700px; height: 700px;">
            <div class="popupdivContents" style="border: none;">
                <div class="popup-title" style="margin-top: 20px;">
                    <h3 class='pop-title'>서비스용역조회</h3>
                </div>
                <div class="divpopup-layer-conts">

                    <table id="tblGoods" class="tbl_main tbl_pop">
                        <colgroup>
                            <col style="width: 100px" />
                            <col style="width: 100px" />
                        </colgroup>
                        <thead>
                            <tr>
                                <th class="txt-center">번호</th>
                                <th class="txt-center">서비스용역코드</th>
                                <th class="txt-center">브랜드명</th>
                                <th class="txt-center">서비스용역명</th>
                            </tr>
                        </thead>
                        <tbody id="tblGoods_tbody" style="height: 25px"></tbody>
                    </table>
                    <br />

                    <!--페이징-->
                    <input type="hidden" id="hdGoodsPopupTotalCount" />
                    <div style="margin: 0 auto; text-align: center">
                        <div id="goodsPopuppagination" class="page_curl" style="display: inline-block"></div>
                    </div>

                    <div class="btn_center">
                        <input type="hidden" id="hdSelectGoodsCode" />
                        <input type="button" style="width: 75px;" id="btnGoodsCancel" onclick="fnClosePopup('goodsSearchDiv')" value="취소" class="mainbtn type2" />
                        <input type="button" style="width: 75px;" id="btnGoodsSave" onclick="fnGoodsPopupConfirm()" value="확인" class="mainbtn type1" />

                    </div>

                </div>
            </div>
        </div>
    </div>
</asp:Content>

