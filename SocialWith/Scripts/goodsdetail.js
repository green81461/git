$(function () {

    if (userId == 'socialwith') {  //게스트계정 기능막기
        $('#DivCount').css("display", "none");
    }

    $('.sub-contents-main-div').css('display', 'none');

    qsGroupCode = qs["GroupCode"];
    qsGoodsCode = qs["GoodsCode"];
    qsBrandCode = qs["BrandCode"];
    qsFinalCategoryCode = qs["CategoryCode"];
    qsType = qs["Type"];



    if (!isEmpty(priceCompcode)) {
        compcode = priceCompcode
    }
    else {
        compcode = 'EMPTY'
    }

    if (!isEmpty(saleCompcdoe)) {
        saleCompcode = saleCompcdoe
    }
    else {
        saleCompcode = 'EMPTY'
    }
    fnCategoryBind();
    fnCtgrCurrentDepth(qsFinalCategoryCode);
    fnGoodsInfoBind();
    fnGoodsListBind(qsGroupCode, qsGoodsCode);
    fnGroupOptionSelector(qsGroupCode, qsGoodsCode);
    fnCategoryHint();
    fnBrandHint();



    //빠른 상품 옵션 검색 초기화
    $("#btnOptionSelect").on("click", function () {
        $("#summaryList tbody tr").css('display', '');
        $(".goodsdetail-optionselector dl.optionlist dd a").removeClass('selected');
        optionValue.length = 0;
        return false;
    });
    

});

//현재 카테고리 메뉴명 설정
function fnCtgrCurrentNameBind(finalCode) {
    var param = { FinalCode: finalCode, Method: 'GetCtgrCurrNameList' };
    var callback = function (response) {
        var addTag = "";
        var index = 0;
        if (!isEmpty(response)) {
            $.each(response, function (key, value) {
                var ctgrName = value.CategoryFinalName;
                var ctgrCode = value.CategoryFinalCode;
                var addCss = '';

                if (key == 0)
                    addCss = "class='Category'";
                else
                    addTag += "&nbsp;&nbsp;&gt;&nbsp;&nbsp;";

                addTag += "<span " + addCss + " style='cursor:pointer;  font-size:14px; color: #787a7f' onclick='fnLoadListPage(\"" + ctgrCode + "\", \"\", \"category\"); '>" + ctgrName + "</span>";
                index++;
            });

            $("#ctgrMenuDiv").append(addTag);
        }
        return false;
    };

    Jajax('Post', '../Handler/Common/CategoryHandler.ashx', param, 'json', callback);
}

//체크박스 전체 선택
function AllCheckbox() {
    $("#checkAll").change(function () {
        if ($("#checkAll").is(":checked")) { //체크박스 선택
            $('#summaryList input[type="checkbox"]').each(function () {
                $(this).prop('checked', 'checked');

                //여기에서 전체 선택 시 로직을 넣어야할 듯;
            });
        } else {
            $('#summaryList input[type="checkbox"]').each(function () {
                $(this).prop('checked', '');
            });
        }
        if ($("#cbSummarySelect").is(":checked")) {
            var sumTotalPrice = 0;
            var check = false;
            var checkCnt = 0;
            var TotalQty = 0;
            $('#summaryList tbody tr').each(function (index, element) {
                if ($(element).find("input[type = checkbox]").prop('checked') == true) {
                    // var qty = $(element).find("input[type = text]").val();//수량
                    var qty = $(element).find("#txtQty").val();//수량
                    var hfGoodsSalePriceVAT = $(element).find("input[type = hidden]").eq(2).val();
                    var sumPrice = hfGoodsSalePriceVAT * qty;
                    sumTotalPrice += sumPrice;
                    TotalQty += Number(qty);
                    ++checkCnt;
                } else {
                    check = true;
                }
            });



            $("#lbTotalCheckPrice").text(numberWithCommas(sumTotalPrice));
            // $("#lblCheckCnt1").text(TotalQty + "개");
            $("#lblCheckCnt").text(TotalQty);
        } else {
            var sumTotalPrice = 0;
            var check = false;
            var checkCnt = 0;
            var TotalQty = 0;
            $('#summaryList tbody tr').each(function (index, element) {
                if ($(element).find("input[type = checkbox]").prop('checked') == true) {
                    // var qty = $(element).find("input[type = text]").val();//수량
                    var qty = $(element).find("#txtQty").val();//수량
                    var hfGoodsSalePriceVAT = $(element).find("input[type = hidden]").eq(2).val();
                    var sumPrice = hfGoodsSalePriceVAT * qty;
                    sumTotalPrice += sumPrice;
                    TotalQty += Number(qty);
                    ++checkCnt;
                } else {
                    check = true;
                }
            });



            $("#lbTotalCheckPrice").text(numberWithCommas(sumTotalPrice));
            $("#lblCheckCnt").text(TotalQty);
        }
    });
}

function fnGoodsInfoBind() {

    var callback = function (value) {
        if (!isEmpty(value)) {
            $('.sub-contents-main-div').css('display', 'block');
            $('.sub-contents-empty-div').css('display', 'none');
            $('.goods_side_wrap').css('display', '');
            var src = '/GoodsImage' + '/' + value.GoodsFinalCategoryCode + '/' + value.GoodsGroupCode + '/' + value.GoodsCode + '/' + value.GoodsFinalCategoryCode + '-' + value.GoodsGroupCode + '-' + value.GoodsCode + '-fff.jpg';
            //var src = '/UploadFile/Goods/0101090305/G33466/A116121/0101090305-G33466-A116121-goodsimgmaind.jpg';
            //var srcOrigin = '/UploadFile/Origin/' + value.GoodsOriginCode + '.jpg';

            //$('#ImgOrigin').attr('src', srcOrigin);

            $('#zoom_01').attr('src', src);
            $("#zoom_01").data('zoom-image', src);
            $('#zoom_01').elevateZoom({
                zoomWindowPosition: "demo-container",
                zoomWindowHeight: 500,
                zoomWindowWidth: 500,

                easing: true,
                zoomType: "lens",
                lensShape: "square",
                lensSize: 150



            });



            if (value.GoodsFinalName) {
                $('#lblGoodsName').text('[' + value.GoodsBrandName + '] ' + value.GoodsFinalName);
                $('#hdGoodName').val(value.GoodsFinalName);


            }
            if (!isEmpty(value.GoodsConfirmMark) && value.GoodsConfirmMark != '00000000') {
                $('#trCert').css('display', '');
                var html = '';
                if (value.GoodsConfirmMark.substring(0, 1) == '1') {
                    html += "<img class='map' alt= '' src='/UploadFile/CertificationImage/01.jpg' style='padding:5px'/>";

                }
                if (value.GoodsConfirmMark.substring(1, 2) == '1') {
                    html += "<img class='map' alt= '' src='/UploadFile/CertificationImage/02.jpg' style='padding:5px'/>";

                }
                if (value.GoodsConfirmMark.substring(2, 3) == '1') {
                    html += "<img class='map' alt= '' src='/UploadFile/CertificationImage/03.jpg' style='padding:5px'/>";

                }
                if (value.GoodsConfirmMark.substring(3, 4) == '1') {
                    html += "<img class='map' alt= '' src='/UploadFile/CertificationImage/04.jpg' style='padding:5px'/>";

                }
                if (value.GoodsConfirmMark.substring(4, 5) == '1') {
                    html += "<img class='map' alt= '' src='/UploadFile/CertificationImage/05.jpg' style='padding:5px'/>";

                }
                if (value.GoodsConfirmMark.substring(5, 6) == '1') {
                    html += "<img class='map' alt= '' src='/UploadFile/CertificationImage/06.jpg' style='padding:5px'/>";

                }
                if (value.GoodsConfirmMark.substring(6, 7) == '1') {
                    html += "<img class='map' alt= '' src='/UploadFile/CertificationImage/07.jpg' style='padding:5px'/>";

                }
                if (value.GoodsConfirmMark.substring(7, 8) == '1') {
                    html += "<img class='map' alt= '" + text + "' src='/UploadFile/CertificationImage/08.jpg' style='padding:5px'/>";

                }

                $('#divCertImage').append(html);
            }

            if (value.GoodsDeliveryOrderDue == '1') {
                $('#lblTitleDeliveryOrder').css('display', 'block');
                var dtext1 = '<span class="goodsdetail-deliverymapname">당일발송</span>'
                var dtext2 = '<span class="goodsdetail-deliverymaptext">지금 결제 완료시 오늘 바로 발송!</span>'
                $('#tdDeliveryOrder').html(dtext1 + dtext2);
            }

            if (value.GoodsBrandName) {
                $('#lblTitleBrand').css('display', 'block');
                var linkurl = '/Goods/GoodsList?BrandCode=' + qsBrandCode + '&BrandName=' + value.GoodsBrandName + '&ListType=a&SearchFlag=R';
                var linkHtml = '<a href="' + linkurl + '"><span>브랜드 상품 전체보기</span></a>'
                $('#lblBrand').html(linkHtml);
            }


            if (value.GoodsOriginCode) {
                $('#lblTitleOrigin').css('display', 'block');
                $('#lblOrigin').text(value.GoodsOriginName);
            }

            if (value.GoodsSpecial) {
                $('#lblTitleSpecial').css('display', 'block');
                $('#lblSpecial').html(value.GoodsSpecial.replace(/■/gi, '<br/>' + '■').replace(/※/gi, '<br/>' + '※').replace(/▶/gi, '<br/>' + '▶').replace(/≫/gi, '<br/>' + '≫'));
                if ($('#lblSpecial').html().substring(0, 4) == '<br>') {
                    $('#lblSpecial br:lt(1)').remove();
                }
            }

            if (value.GoodsFormat) {
                $('#lblTitleFormat').css('display', 'block');
                $('#lblFormat').html(value.GoodsFormat.replace(/■/gi, '<br/>' + '■').replace(/※/gi, '<br/>' + '※').replace(/▶/gi, '<br/>' + '▶').replace(/≫/gi, '<br/>' + '≫'));
                if ($('#lblFormat').html().substring(0, 4) == '<br>') {
                    $('#lblFormat br:lt(1)').remove();
                }
            }

            if (value.GoodsCause) {
                $('#lblTitleCause').css('display', 'block');
                $('#lblCause').html(value.GoodsCause.replace(/■/gi, '<br/>' + '■').replace(/※/gi, '<br/>' + '※').replace(/▶/gi, '<br/>' + '▶').replace(/≫/gi, '<br/>' + '≫'));
                if ($('#lblCause').html().substring(0, 4) == '<br>') {
                    $('#lblCause br:lt(1)').remove();
                }
            }
            if (value.GoodsSupplies) {
                $('#lblTitleSupplies').css('display', 'block');
                $('#lblSupplies').html(value.GoodsSupplies.replace(/■/gi, '<br/>' + '■').replace(/※/gi, '<br/>' + '※').replace(/▶/gi, '<br/>' + '▶').replace(/≫/gi, '<br/>' + '≫'));
                if ($('#lblSupplies').html().substring(0, 4) == '<br>') {
                    $('#lblSupplies br:lt(1)').remove();
                }
            }

            var detailsrc1 = '/GoodsImage' + '/' + value.GoodsFinalCategoryCode + '/' + value.GoodsGroupCode + '/' + value.GoodsCode + '/' + value.GoodsFinalCategoryCode + '-' + value.GoodsGroupCode + '-' + value.GoodsCode + '-ddd1.jpg';
            var detailsrc2 = '/GoodsImage' + '/' + value.GoodsFinalCategoryCode + '/' + value.GoodsGroupCode + '/' + value.GoodsCode + '/' + value.GoodsFinalCategoryCode + '-' + value.GoodsGroupCode + '-' + value.GoodsCode + '-ddd2.jpg';
            var detailsrc3 = '/GoodsImage' + '/' + value.GoodsFinalCategoryCode + '/' + value.GoodsGroupCode + '/' + value.GoodsCode + '/' + value.GoodsFinalCategoryCode + '-' + value.GoodsGroupCode + '-' + value.GoodsCode + '-ddd3.jpg';
            var detailsrc4 = '/GoodsImage' + '/' + value.GoodsFinalCategoryCode + '/' + value.GoodsGroupCode + '/' + value.GoodsCode + '/' + value.GoodsFinalCategoryCode + '-' + value.GoodsGroupCode + '-' + value.GoodsCode + '-ddd4.jpg';

            //디테일 이미지파일 존재 체크 여부후 div에 append
            ImgFileCheckLoad('#divDetailImage1', detailsrc1, 'detailImage1')
            ImgFileCheckLoad('#divDetailImage2', detailsrc2, 'detailImage2')
            ImgFileCheckLoad('#divDetailImage3', detailsrc3, 'detailImage3')
            ImgFileCheckLoad('#divDetailImage4', detailsrc4, 'detailImage4')
            if (value.GroupCnt > 1) {
                $('#btnOptioinSummary').css('display', ''); //그룹카운트가 1보다 크면 활성화
            }
            
        }
        else {
            $('.sub-contents-main-div').css('display', 'none');
            $('#spansearchkeyword').text(qsGoodsCode);
            $('.sub-contents-empty-div').css('display', 'block');
            $('.goods_side_wrap').css('display', 'none');
        }
        return false;
    }


    var param = { Method: 'GetGoodsInfoByGroupCode', CategoryCode: qsFinalCategoryCode, GroupCode: qsGroupCode, GoodsCode: qsGoodsCode };

    JqueryAjax("Post", "../../Handler/GoodsHandler.ashx", false, false, param, "json", callback, null, null, true, sviduser);

    //Jajax('Post', '../../Handler/GoodsHandler.ashx', param, 'json', callback);

}

//이미지파일 존재 체크 여부후 div에 append
function ImgFileCheckLoad(divid, src, imgId) {

    var img = new Image();
    img.src = src;
    img.onload = function () {
        $(divid).prepend($('<img>', { id: imgId, src: src }))
    }
}

function fnGoodsListBind(groupCode, goodsCode) {

    $('#summaryList').find('tr').remove(); //테이블 클리어
    var callback = function (response) {
        var newHeaderContent = "<tr class='goodsSummary-tr-height'>";

        //동적으로 Header 뿌리기
        if (response.length >= 1) {

            newHeaderContent += "<th  class='txt-center'><input type='checkbox' id='checkAll' /></th>";
            newHeaderContent += "<th class='txt-center'>이미지</th>";
            newHeaderContent += "<th  class='txt-center'>상품코드</th>";
            newHeaderContent += "<th class='txt-center'>브랜드</th>";
            newHeaderContent += "<th  class='txt-center'>모델명</th>";


            var getCols = response[0];

            for (var col in getCols) {
                if (col.indexOf('OptionCol_') != -1) {
                    if (getCols[col] != '' && getCols[col] != null && getCols[col] != '-') {
                        newHeaderContent += "<th class='txt-center'>" + getCols[col]; +"</th>";
                    }
                }
            }

            newHeaderContent += "<th  class='txt-center'>출하예정일</th>";
            newHeaderContent += "<th  class='txt-center' style='width:80px'>최소수량</th>";
            newHeaderContent += "<th  class='txt-center'>내용량</th>";

            var taxYn = response[0].GoodsSaleTaxYN;

            var freeCompVatYN = freeCompanyVatYN;
            var taxTag = "(VAT포함)";
            if (freeCompVatYN == 'N') {
                taxTag = "(VAT별도)";
            }
            if (taxYn == "2") {
                taxTag = "(면세)";
            }

            newHeaderContent += "<th  class='txt-center'>판매가" + taxTag + "</th>";
            newHeaderContent += "<th  class='txt-center'>수량</th>";
        }

        newHeaderContent += "</tr>";
        $('#summaryList thead').append(newHeaderContent);



        // //데이터 바인딩
        if (response.length >= 1) {

            var tableWidth = 435;
            var index = 0;
            var moq = 0;
            
            for (var obj in response) {
                var newDataContent = '';
                var colWidth = 0;
                var svidUser = sviduser;
                var svidRole = svidRole;
                var price = '';

                var priceHtml = '';
                if (svidUser == '' || svidRole == 'T' || userId == 'socialwith') {
                    price = '(회원전용)';
                    priceHtml = '<span class="keep_words">' + price + '</span>';
                }
                else {
                    price = numberWithCommas(response[obj].GoodsSalePriceVat) + '원';

                    if (isEmpty(response[obj].GoodsDCPriceVat)) {
                        priceHtml = '<span">' + price + '</span>';
                    }
                    else {
                        priceHtml = '<span style="text-decoration: line-through; font-size:13px;">' + price + '</span>&nbsp; <span style="color:red;">' + numberWithCommas(response[obj].GoodsDCPriceVat) + '원</span>';
                    }
                }


                moq = response[obj].GoodsUnitMoq;
                if (response.hasOwnProperty(obj)) {
                    var rowValue = ''
                    for (var i = 1; i < 21; i++) {
                        if (response[obj]['OptionCol_' + i] != null && response[obj]['OptionCol_' + i] != '' && response[obj]['OptionCol_' + i] != '-') {
                            rowValue += response[obj]['OptionCode' + i] + "::" + response[obj]['OptionVal_' + i] + '$#$'
                        }

                    }

                    if (pgFlag == 'Y') {
                        if (response[obj].GoodsSalePriceVat < 4000000) {
                            $('#hdGroupCode').val(response[obj]['GoodsGroupCode']);

                            newDataContent = "<tr id='" + rowValue.slice(0, -3) + "'>";
                            newDataContent += "<td style='width:35px' class='txt-center'><input type='checkbox' id='cbSummarySelect' name='cbSummarySelect'/><input type='hidden' id='hdGroupCode' value=" + response[obj]['GoodsGroupCode'] + " ></input><input type='hidden' id='hdGoodsCode' value=" + response[obj]['GoodsCode'] + " ></input><input type='hidden' id='hdGoodsPrice' value=" + response[obj]['GoodsSalePriceVat'] + " ></input></td>";
                            var src = '/GoodsImage' + '/' + response[obj]['GoodsFinalCategoryCode'] + '/' + response[obj]['GoodsGroupCode'] + '/' + response[obj]['GoodsCode'] + '/' + response[obj]['GoodsFinalCategoryCode'] + '-' + response[obj]['GoodsGroupCode'] + '-' + response[obj]['GoodsCode'] + '-sss.jpg';
                            newDataContent += "<td class='txt-center'><img src=" + src + " width='50' height='50' onerror='no_image(this, \"s\")'/></td>";
                            if (index == 0) {
                                $('#hdFirstGoodsCode').val(response[obj]['GoodsCode']);
                                $('#hdFirstGroupCode').val(response[obj]['GoodsGroupCode']);
                            }
                            newDataContent += "<td class='txt-center'><a style='cursor: pointer' onclick='fnGoodsDetailView(\"" + response[obj]['GoodsCode'] + "\"); return false;'> " + response[obj]['GoodsCode'] + "</a></td>";
                            newDataContent += "<td class='txt-center'>" + response[obj]['BrandName'] + "</td>";
                            newDataContent += "<td class='txt-center'>" + response[obj]['GoodsModel'] + "</td>";

                            for (var i = 1; i < 21; i++) {

                                if (response[obj]['OptionCol_' + i] != null && response[obj]['OptionCol_' + i] != '' && response[obj]['OptionCol_' + i] != '-') {
                                    if (response[obj]['OptionCol_' + i].length > response[obj]['OptionVal_' + i].length) {
                                        colWidth = (response[obj]['OptionCol_' + i].length) * 11;
                                    }
                                    else {
                                        colWidth = (response[obj]['OptionVal_' + i].length) * 11;
                                    }

                                    if (index == 0) {

                                        tableWidth += colWidth;
                                    }

                                    newDataContent += "<td class='txt-center'>" + response[obj]['OptionVal_' + i]; +"</td>";
                                }
                            }

                            newDataContent += "<td class='txt-center'>" + response[obj]['Map_Name'] + "</td>";
                            newDataContent += "<td class='txt-center'>" + response[obj]['GoodsUnitMoq'] + "</td>";
                            newDataContent += "<td class='txt-center'>" + response[obj]['GoodsUnit_Name'] + "</td>";
                            newDataContent += "<td class='txt-center' style='font-weight:bold; text-align:right; padding-right:10px; color:#69686d'>" + priceHtml + "</td>";
                            //newDataContent += "<td class='txt-center'><input type='number' id='txtQty' style='width:50px; height:24px; border:1px solid #a2a2a2; text-align:right; padding-right:5px;' value='1' oninput='return maxLengthCheck(this)' onkeypress='return onlyNumbers(event);' maxLength='4'/></td>";
                            newDataContent += "<td class='txt-center' style='width:90px; padding-left:17px'>";
                            newDataContent += "<span class='input-qty'>";
                            newDataContent += "<input type='number' id='txtQty' value='" + response[obj]['GoodsUnitMoq'] + "' oninput='return maxLengthCheck(this)' onkeypress='return onlyNumbers(event);' maxLength='4'/>";
                            newDataContent += "<a class='input-arrow-up'><img src='../Images/inputarrow_up.png' width='9' height='9' class='imgarrowup'/></a>";
                            newDataContent += "<a class='input-arrow-down'><img src='../Images/inputarrow_down.png' width='9' height='9' class='imgarrowdown'/></a>";
                            newDataContent += "</span></td>";
                            newDataContent += "</tr>";
                        }

                    }
                    else {
                        $('#hdGroupCode').val(response[obj]['GoodsGroupCode']);
                       
                        newDataContent = "<tr id='" + rowValue.slice(0, -3) + "'>";
                        newDataContent += "<td style='width:35px' class='txt-center'><input type='checkbox' id='cbSummarySelect'name='cbSummarySelect'/><input type='hidden' id='hdGroupCode' value=" + response[obj]['GoodsGroupCode'] + " ></input><input type='hidden' id='hdGoodsCode' value=" + response[obj]['GoodsCode'] + " ></input><input type='hidden' id='hdGoodsPrice' value=" + response[obj]['GoodsSalePriceVat'] + " ></input></td>";
                        var src = '/GoodsImage' + '/' + response[obj]['GoodsFinalCategoryCode'] + '/' + response[obj]['GoodsGroupCode'] + '/' + response[obj]['GoodsCode'] + '/' + response[obj]['GoodsFinalCategoryCode'] + '-' + response[obj]['GoodsGroupCode'] + '-' + response[obj]['GoodsCode'] + '-sss.jpg';
                        newDataContent += "<td class='txt-center'><img src=" + src + " width='50' height='50' onerror='no_image(this, \"s\")'/></td>";
                        newDataContent += "<td class='txt-center'><a style='cursor: pointer' onclick='fnGoodsDetailView(\"" + response[obj]['GoodsCode'] + "\"); return false;'> " + response[obj]['GoodsCode'] + "</a></td>";
                        if (index == 0) {
                            $('#hdFirstGoodsCode').val(response[obj]['GoodsCode']);
                            $('#hdFirstGroupCode').val(response[obj]['GoodsGroupCode']);
                        }

                        newDataContent += "<td class='txt-center'>" + response[obj]['BrandName'] + "</td>";
                        newDataContent += "<td class='txt-center'>" + response[obj]['GoodsModel'] + "</td>";

                        for (var i = 1; i < 21; i++) {

                            if (response[obj]['OptionCol_' + i] != null && response[obj]['OptionCol_' + i] != '' && response[obj]['OptionCol_' + i] != '-') {
                                if (response[obj]['OptionCol_' + i].length > response[obj]['OptionVal_' + i].length) {
                                    colWidth = (response[obj]['OptionCol_' + i].length) * 11;
                                }
                                else {
                                    colWidth = (response[obj]['OptionVal_' + i].length) * 11;
                                }

                                if (index == 0) {

                                    tableWidth += colWidth;
                                }

                                newDataContent += "<td class='txt-center'>" + response[obj]['OptionVal_' + i]; +"</td>";
                            }
                        }


                        newDataContent += "<td class='txt-center'>" + response[obj]['Map_Name'] + "</td>";
                        newDataContent += "<td class='txt-center'>" + response[obj]['GoodsUnitMoq'] + "<input type='hidden' id='hdRowMoq' value='" + response[obj]['GoodsUnitMoq'] + "'></td>";
                        newDataContent += "<td class='txt-center'>" + response[obj]['GoodsUnit_Name'] + "</td>";
                        newDataContent += "<td class='txt-center' style='font-weight:bold; text-align:right; padding-right:10px; color:#69686d'>" + priceHtml + "</td>";
                        //newDataContent += "<td class='txt-center'><input type='number' id='txtQty' style='width:50px; height:24px; border:1px solid #a2a2a2; text-align:right; padding-right:5px;' value='1' oninput='return maxLengthCheck(this)' onkeypress='return onlyNumbers(event);' maxLength='4'/></td>";
                        newDataContent += "<td class='txt-center' style='width:90px; padding-left:17px'>";
                        newDataContent += "<span class='input-qty'>";
                        newDataContent += "<input type='number' id='txtQty' value='" + response[obj]['GoodsUnitMoq'] + "' oninput='return maxLengthCheck(this)' onkeypress='return onlyNumbers(event);' maxLength='4'/>";
                        newDataContent += "<a class='input-arrow-up'><img src='../Images/inputarrow_up.png' width='9' height='9' class='imgarrowup'/></a>";
                        newDataContent += "<a class='input-arrow-down'><img src='../Images/inputarrow_down.png' width='9' height='9' class='imgarrowdown'/></a>";
                        newDataContent += "</span></td>";
                        newDataContent += "</tr>";
                    }
                }
                $('#summaryList tbody').append(newDataContent);

                //  $("#cbSummarySelect").change(function () {
                $('#summaryList input[type="checkbox"]').change(function () {
                    if ($("#cbSummarySelect").is(":checked")) {
                        var sumTotalPrice = 0;
                        var check = false;
                        var checkCnt = 0;
                        var TotalQty = 0;
                        $('#summaryList tbody tr').each(function (index, element) {
                            if ($(element).find("input[type = checkbox]").prop('checked') == true) {
                                // var qty = $(element).find("input[type = text]").val();//수량
                                var qty = $(element).find("#txtQty").val();//수량
                                var hfGoodsSalePriceVAT = $(element).find("input[type = hidden]").eq(2).val();
                                var sumPrice = hfGoodsSalePriceVAT * qty;
                                sumTotalPrice += sumPrice;
                                TotalQty += Number(qty);
                                ++checkCnt;
                            } else {
                                check = true;
                            }
                        });



                        $("#lbTotalCheckPrice").text(numberWithCommas(sumTotalPrice));
                        // $("#lblCheckCnt1").text(TotalQty + "개");
                        $("#lblCheckCnt").text(TotalQty);
                    } else {
                        var sumTotalPrice = 0;
                        var check = false;
                        var checkCnt = 0;
                        var TotalQty = 0;
                        $('#summaryList tbody tr').each(function (index, element) {
                            if ($(element).find("input[type = checkbox]").prop('checked') == true) {
                                // var qty = $(element).find("input[type = text]").val();//수량
                                var qty = $(element).find("#txtQty").val();//수량
                                var hfGoodsSalePriceVAT = $(element).find("input[type = hidden]").eq(2).val();
                                var sumPrice = hfGoodsSalePriceVAT * qty;
                                sumTotalPrice += sumPrice;
                                TotalQty += Number(qty);
                                ++checkCnt;
                            } else {
                                check = true;
                            }
                        });



                        $("#lbTotalCheckPrice").text(numberWithCommas(sumTotalPrice));
                        $("#lblCheckCnt").text(TotalQty);
                    }
                });


                index++;
                AllCheckbox();

            }
            tableWidth = tableWidth + 280;
            $('#summaryList').css('width', tableWidth + 'px');

            $(".input-arrow-up").on("click", function () {
                var rowMoq = parseInt($(this).parent().parent().parent().children().find('#hdRowMoq').val());
                $(this).parent().find('#txtQty').val(parseInt($(this).parent().find('#txtQty').val()) + rowMoq);
                if ($("#cbSummarySelect").is(":checked")) {
                    var sumTotalPrice = 0;
                    var check = false;
                    var checkCnt = 0;
                    var TotalQty = 0;
                    $('#summaryList tbody tr').each(function (index, element) {
                        if ($(element).find("input[type = checkbox]").prop('checked') == true) {
                            // var qty = $(element).find("input[type = text]").val();//수량
                            var qty = $(element).find("#txtQty").val();//수량
                            var hfGoodsSalePriceVAT = $(element).find("input[type = hidden]").eq(2).val();
                            var sumPrice = hfGoodsSalePriceVAT * qty;
                            sumTotalPrice += sumPrice;
                            TotalQty += Number(qty);
                            ++checkCnt;
                        } else {
                            check = true;
                        }
                    });



                    $("#lbTotalCheckPrice").text(numberWithCommas(sumTotalPrice));
                    // $("#lblCheckCnt1").text(TotalQty + "개");
                    $("#lblCheckCnt").text(TotalQty);
                } else {
                    var sumTotalPrice = 0;
                    var check = false;
                    var checkCnt = 0;
                    var TotalQty = 0;
                    $('#summaryList tbody tr').each(function (index, element) {
                        if ($(element).find("input[type = checkbox]").prop('checked') == true) {
                            // var qty = $(element).find("input[type = text]").val();//수량
                            var qty = $(element).find("#txtQty").val();//수량
                            var hfGoodsSalePriceVAT = $(element).find("input[type = hidden]").eq(2).val();
                            var sumPrice = hfGoodsSalePriceVAT * qty;
                            sumTotalPrice += sumPrice;
                            TotalQty += Number(qty);
                            ++checkCnt;
                        } else {
                            check = true;
                        }
                    });



                    $("#lbTotalCheckPrice").text(numberWithCommas(sumTotalPrice));
                    $("#lblCheckCnt").text(TotalQty);
                }
            });
            $(".input-arrow-down").on("click", function () {
                var rowMoq = parseInt($(this).parent().parent().parent().children().find('#hdRowMoq').val());
                if (parseInt($(this).parent().find('#txtQty').val()) - rowMoq <= 0) {
                    alert('수량이 0보다 작거나 같을 수 없습니다.');
                }
                else {
                    $(this).parent().find('#txtQty').val(parseInt($(this).parent().find('#txtQty').val()) - rowMoq);
                    if ($("#cbSummarySelect").is(":checked")) {
                        var sumTotalPrice = 0;
                        var check = false;
                        var checkCnt = 0;
                        var TotalQty = 0;
                        $('#summaryList tbody tr').each(function (index, element) {
                            if ($(element).find("input[type = checkbox]").prop('checked') == true) {
                                // var qty = $(element).find("input[type = text]").val();//수량
                                var qty = $(element).find("#txtQty").val();//수량
                                var hfGoodsSalePriceVAT = $(element).find("input[type = hidden]").eq(2).val();
                                var sumPrice = hfGoodsSalePriceVAT * qty;
                                sumTotalPrice += sumPrice;
                                TotalQty += Number(qty);
                                ++checkCnt;
                            } else {
                                check = true;
                            }
                        });



                        $("#lbTotalCheckPrice").text(numberWithCommas(sumTotalPrice));
                        // $("#lblCheckCnt1").text(TotalQty + "개");
                        $("#lblCheckCnt").text(TotalQty);
                    } else {
                        var sumTotalPrice = 0;
                        var check = false;
                        var checkCnt = 0;
                        var TotalQty = 0;
                        $('#summaryList tbody tr').each(function (index, element) {
                            if ($(element).find("input[type = checkbox]").prop('checked') == true) {
                                // var qty = $(element).find("input[type = text]").val();//수량
                                var qty = $(element).find("#txtQty").val();//수량
                                var hfGoodsSalePriceVAT = $(element).find("input[type = hidden]").eq(2).val();
                                var sumPrice = hfGoodsSalePriceVAT * qty;
                                sumTotalPrice += sumPrice;
                                TotalQty += Number(qty);
                                ++checkCnt;
                            } else {
                                check = true;
                            }
                        });



                        $("#lbTotalCheckPrice").text(numberWithCommas(sumTotalPrice));
                        $("#lblCheckCnt").text(TotalQty);
                    }
                }

            });

            $('input[id*="txtQty"]').blur(function () {
                var rowMoq = parseInt($(this).parent().parent().parent().children().find('#hdRowMoq').val());
                var val = parseInt($(this).val()) % rowMoq;

                if (parseInt($(this).val()) <= 0) {
                    alert('수량이 0보다 작거나 같을 수 없습니다.');
                    $(this).val(rowMoq);
                }
                else {
                    if ($("#cbSummarySelect").is(":checked")) {
                        var sumTotalPrice = 0;
                        var check = false;
                        var checkCnt = 0;
                        var TotalQty = 0;
                        $('#summaryList tbody tr').each(function (index, element) {
                            if ($(element).find("input[type = checkbox]").prop('checked') == true) {
                                // var qty = $(element).find("input[type = text]").val();//수량
                                var qty = $(element).find("#txtQty").val();//수량
                                var hfGoodsSalePriceVAT = $(element).find("input[type = hidden]").eq(2).val();
                                var sumPrice = hfGoodsSalePriceVAT * qty;
                                sumTotalPrice += sumPrice;
                                TotalQty += Number(qty);
                                ++checkCnt;
                            } else {
                                check = true;
                            }
                        });



                        $("#lbTotalCheckPrice").text(numberWithCommas(sumTotalPrice));
                        $("#lblCheckCnt").text(TotalQty);
                    } else {
                        var sumTotalPrice = 0;
                        var check = false;
                        var checkCnt = 0;
                        var TotalQty = 0;
                        $('#summaryList tbody tr').each(function (index, element) {
                            if ($(element).find("input[type = checkbox]").prop('checked') == true) {
                                // var qty = $(element).find("input[type = text]").val();//수량
                                var qty = $(element).find("#txtQty").val();//수량
                                var hfGoodsSalePriceVAT = $(element).find("input[type = hidden]").eq(2).val();
                                var sumPrice = hfGoodsSalePriceVAT * qty;
                                sumTotalPrice += sumPrice;
                                TotalQty += Number(qty);
                                ++checkCnt;
                            } else {
                                check = true;
                            }
                        });



                        $("#lbTotalCheckPrice").text(numberWithCommas(sumTotalPrice));
                        $("#lblCheckCnt").text(TotalQty);
                    }
                }

                if (val != 0) {
                    alert('본 상품은 최소구매수량 단위로 구매가 가능합니다. ');
                    $(this).val(rowMoq);
                }
            });
        }
        return false;
    }

    var param = {
        Method: 'GetGoodsSummaryList',
        CategoryCode: qsFinalCategoryCode,
        GoodsGroupCode: groupCode,
        GoodsCode: goodsCode,
        CompCode: compcode,
        DongshinCheck: dsCheck,
        FreeCompanyYN: freeCompYN,
        FreeCompanyVatYN: freeCompanyVatYN,
        SvidUser: sviduser

    };
    var beforeSend = function () {
        is_sending = true;
    }
    var complete = function () {
        is_sending = false;
    }

    if (is_sending) return false;

    JqueryAjax("Post", "../../Handler/GoodsHandler.ashx", false, false, param, "json", callback, beforeSend, complete, true, sviduser);
}


//상품코드 클릭시 디테일뷰
function fnGoodsDetailView(goodsCode) {

    var callback = function (value) {
        var moq = 0;
        if (value != null) {
            $('#p_GoodsPriceVat').empty();
            $('#p_GoodsTotalPriceVat').empty();
            var src = '/GoodsImage' + '/' + value.GoodsFinalCategoryCode + '/' + value.GoodsGroupCode + '/' + value.GoodsCode + '/' + value.GoodsFinalCategoryCode + '-' + value.GoodsGroupCode + '-' + value.GoodsCode + '-fff.jpg';
            $('#imgGoodsDetail').attr('src', src);
            $('#p_GoodsName').text(value.GoodsFinalName);
            $('#p_GoodsCode').text(value.GoodsCode);
            $('#p_GoodsInfo').html('[' + value.BrandName + ']<br/>' + value.GoodsFinalName + '<br/><span style="color:#368AFF">' + value.GoodsOptionSummaryValues + '</span>');
            $('#p_GoodsModel').text(value.GoodsModel);
            $('#p_GoodsOrigin').text(value.GoodsOriginName);
            $('#p_GoodsUnit').text(value.GoodsUnitName);
            $('#p_GoodsDueName').text(value.GoodsDeliveryOrderDue_Name);
            $('#p_moq').text(value.GoodsUnitMoq);
            $('#txtPopupQty').val(value.GoodsUnitMoq);
            $('#hdGoodUnitMoq').val(value.GoodsUnitMoq);
            moq = value.GoodsUnitMoq;

            // var goodsQty = $('#txtPopupQty').val();
            var totalPrice = numberWithCommas(value.GoodsSalePriceVat) + '원';
            var svidUser = sviduser;
            var svidRole = svidRole;
            var price = '';
            var priceHtml = '';
            if (svidUser == '' || svidRole == 'T' || userId == 'socialwith') {
                price = '(회원전용)';
                priceHtml = '<span>' + price + '</span>';
                totalPrice = '(회원전용)'; //추가한 부분
            }
            else {
                price = numberWithCommas(value.GoodsSalePriceVat) + '원';

                if (isEmpty(value.GoodsDCPriceVat)) {
                    priceHtml = '<span>' + price + '</span>';
                }
                else {
                    priceHtml = '<span style="text-decoration: line-through; font-size:13px;">' + price + '</span>&nbsp;&nbsp;<span style="color:red;">' + numberWithCommas(value.GoodsDCPriceVat) + '원</span>';
                }
            }

            var taxYn = value.GoodsSaleTaxYN;
            var taxTag = "판매가(VAT포함) : ";

            var freeCompVatYN = freeCompanyVatYN;
            var taxTag = "상품금액(VAT포함)";
            if (freeCompVatYN == 'N') {
                taxTag = "상품금액(VAT별도)";
            }
            if (taxYn == "2") {
                taxTag = "(면세)";
            }


            $('#spPopGdsSale').text(taxTag);
            $('#p_GoodsPriceVat').append(priceHtml);
            $('#p_GoodsTotalPriceVat').append(totalPrice);


            $('#hdPopupCategoryCode').val(value.GoodsFinalCategoryCode);
            $('#hdPopupGoodsGroupCode').val(value.GoodsGroupCode);
            $('#hdPopupGoodsCode').val(value.GoodsCode);

            var sessionValue = sviduser
            if (sessionValue != "" && sessionValue != null) {
                $('#trPopupCart').css('display', '');
            }

            fnOpenDivLayerPopup('popupDiv');
            
            return false;
        }


    }
    var param = { Method: 'GetGoodsDetailView', CompCode: compcode, SaleCompCode: saleCompcode, GoodsCode: goodsCode, DongshinCheck: dsCheck, FreeCompanyYN: freeCompYN, FreeCompanyVatYN: freeCompanyVatYN, SvidUser: sviduser };

    Jajax('Post', '../../Handler/GoodsHandler.ashx', param, 'json', callback);
}

function fnPopupArrowClick(type) {
    var svidUser = sviduser;
    var svidRole = svidRole;
    var Qty = "";               //상품 수량 변수
    var Amt = "";               //상품 단가 변수
    var TotalAmt = "";          //수량 x 단가 변수
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


    Qty = $('#txtPopupQty').val();                      // 수량 체크
    Amt = $('label[id*="p_GoodsPriceVat"]').text();     // 상품 단가 체크
    Amt = Amt.replace('원', '');                        // '원' 한글 텍스트 제거
    Amt = (parseInt(Amt.replace(/[^\d]+/g, '')));       // 콤마 제거 정규식 
    TotalAmt = numberWithCommas(Qty * Amt) + '원';      // 수량 x 단가 계산
    $('#p_GoodsTotalPriceVat').empty();                 // 데이터가 들어갈 label 태그 비워주기
    $('#p_GoodsTotalPriceVat').append(TotalAmt);        // label 태그 에 데이터 뿌림
    if (svidUser == '' || svidRole == 'T' || userId == 'socialwith') {
        TotalAmt = '(회원전용)'; //추가한 부분
        $('#p_GoodsTotalPriceVat').empty();                 // 데이터가 들어갈 label 태그 비워주기
        $('#p_GoodsTotalPriceVat').append(TotalAmt);        // label 태그 에 데이터 뿌림
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


//팝업 장바구니 담기
function fnPopupCartAdd() {

    if (userId == 'socialwith') {
        alert('게스트 계정은 이용할 수 없습니다.');
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
        SvidUser: sviduser,
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

    JqueryAjax("Post", "../../Handler/CartHandler.ashx", false, false, param, "json", callback, beforeSend, complete, true, sviduser);
    return false;
}
// 장바구니 담기
function fnAddCart() {
    var svidUser = sviduser;
    var role = svidRole;


    if (svidUser == '') {
        alert('회원전용입니다. 로그인 후 이용해 주세요.');
        return false;
    }

    if (userId == 'socialwith') {
        alert('게스트 계정은 이용할 수 없습니다.');
        return false;
    }

    var selectLength = $('#summaryList tbody input[type="checkbox"]:checked').length;
    if (selectLength < 1) {
        alert('상품을 선택해 주세요');
        return false;

    }
    var callback = function (response) {
        if (!isEmpty(response)) {
            $.each(response, function (key, value) {
                if (value == "OK") {

                    fnOpenDivLayerPopup('cartDiv');
                    
                    return false;
                }
            });
        }
        return false;
    };
    var categoryCode = qsFinalCategoryCode;
    var goodsGroupCode = '';
    var codeArray = '';
    var qtyArray = '';
    var zeroFlag = true;
    $('#summaryList tbody input[type="checkbox"]').each(function () {
        if ($(this).prop('checked') == true) {
            var goodsCode = $(this).parent().parent().children().find('#hdGoodsCode').val();
            goodsGroupCode = $(this).parent().parent().children().find('#hdGroupCode').val();
            var qty = $(this).parent().parent().children().find('#txtQty').val();
            if (qty < 1) {
                zeroFlag = false;
            }
            codeArray += goodsCode + '/';
            qtyArray += qty + '/';
        }
    });

    if (zeroFlag == false) {
        alert('수량이 0인 상품이 있습니다.');
        return false;
    }
    var param = {
        SvidUser: sviduser,
        GoodsFinCtgrCode: categoryCode,
        GoodsGrpCode: goodsGroupCode,
        GoodsCodes: codeArray.slice(0, -1),
        QTYs: qtyArray.slice(0, -1),
        Memo: '',
        Flag: 'MultiAdd'
    };

    var beforeSend = function () {
        is_sending = true;
    }
    var complete = function () {
        is_sending = false;
    }

    if (is_sending) return false;

    JqueryAjax("Post", "../../Handler/CartHandler.ashx", false, false, param, "json", callback, beforeSend, complete, true, sviduser);
    return false;
}

// 주문하기
function fnOrder() {
    var svidUser = sviduser;
    var role = svidRole;

    if (svidUser == '') {
        alert('회원전용입니다. 로그인 후 이용해 주세요.');
        return false;
    }

    if (userId == 'socialwith') {
        alert('게스트 계정은 이용할 수 없습니다.');
        return false;
    }

    if (svidUser == 'b3679112-1b92-4438-8bbc-862d363c91f3') {
        alert('게스트 계정은 주문하기 기능을 이용할 수 없습니다.')
        return false;
    }

    if (role == 'C1' || role == 'BC1') {
        alert('권한이 없습니다.')
        return false;
    }
    var selectLength = $('#summaryList tbody input[type="checkbox"]:checked').length;
    if (selectLength < 1) {
        alert('상품을 선택해 주세요');
        return false;

    }
    var callback = function (response) {
        if (!isEmpty(response)) {
            fnGoCart();
        }
        return false;
    };
    var categoryCode = qsFinalCategoryCode;
    var goodsGroupCode = '';
    var codeArray = '';
    var qtyArray = '';
    var zeroFlag = true;
    $('#summaryList tbody input[type="checkbox"]').each(function () {
        if ($(this).prop('checked') == true) {
            var goodsCode = $(this).parent().parent().children().find('#hdGoodsCode').val();
            goodsGroupCode = $(this).parent().parent().children().find('#hdGroupCode').val();
            var qty = $(this).parent().parent().children().find('#txtQty').val();
            if (qty < 1) {
                zeroFlag = false;
            }
            codeArray += goodsCode + '/';
            qtyArray += qty + '/';
        }
    });

    if (zeroFlag == false) {
        alert('수량이 0인 상품이 있습니다.');
        return false;
    }
    var param = {
        SvidUser: sviduser,
        GoodsFinCtgrCode: categoryCode,
        GoodsGrpCode: goodsGroupCode,
        GoodsCodes: codeArray.slice(0, -1),
        QTYs: qtyArray.slice(0, -1),
        Memo: '',
        Flag: 'MultiAdd'
    };

    var beforeSend = function () {
        is_sending = true;
    }
    var complete = function () {
        is_sending = false;
    }

    if (is_sending) return false;

    JqueryAjax("Post", "../../Handler/CartHandler.ashx", false, false, param, "json", callback, beforeSend, complete, true, sviduser);
    return false;
}

// 관심상품 담기
function fnAddWish() {
    var svidUser = sviduser;
    var role = svidRole;

    if (svidUser == '') {
        alert('회원전용입니다. 로그인 후 이용해 주세요.');
        return false;
    }

    if (userId == 'socialwith') {
        alert('게스트 계정은 이용할 수 없습니다.');
        return false;
    }
    
    var callback = function (response) {
        if (!isEmpty(response)) {
            $.each(response, function (key, value) {
                if (value == "OK") {

                    fnOpenDivLayerPopup('wishListDiv');
                }
            });
        }
        return false;
    };

    var categoryCode = qsFinalCategoryCode;
    var goodsGroupCode = '';
    var codeArray = '';

    var selectLength = $('#summaryList tbody input[type="checkbox"]:checked').length;
    if (selectLength < 1) { //체크박스 선택안하면 젤 위에있는 상품을 찜함
        goodsGroupCode = $('#hdFirstGroupCode').val();
        codeArray = $('#hdFirstGoodsCode').val() + '/';
    }
    else {
        $('#summaryList tbody input[type="checkbox"]').each(function () {
            if ($(this).prop('checked') == true) {
                var goodsCode = $(this).parent().parent().children().find('#hdGoodsCode').val();
                goodsGroupCode = $(this).parent().parent().children().find('#hdGroupCode').val();
                codeArray += goodsCode + '/';
            }
        });
    }

    var param = {
        Type: 'MultiSaveWishList',
        SvidUser: sviduser,
        GoodsFinCtgrCode: categoryCode,
        GoodsGrpCode: goodsGroupCode,
        GoodsCodes: codeArray.slice(0, -1),
    };

    var beforeSend = function () {
        is_sending = true;
    }
    var complete = function () {
        is_sending = false;
    }

    if (is_sending) return false;

    JqueryAjax("Post", "../../Handler/WishHandler.ashx", false, false, param, "json", callback, beforeSend, complete, true, sviduser);

    return false;
}


//카테고리 인기 상품
function fnCategoryHint() {
    var callback = function (response) {
        var index = 0;
        var certifiCations = new Array(); //인증마크
        if (!isEmpty(response)) {

            for (var i = 0; i < response.length; i++) {
                var mapName = '';
                //배송일 당일발송과 1일만 보이게
                if (response[i].GoodsDeliveryOrderDue == '1' || response[i].GoodsDeliveryOrderDue == '2') {
                    mapName = response[i].MapName;
                }

                var spanCertMarkDisplay = '';
                if (isEmpty(response[i].GoodsConfirmMark) || response[i].GoodsConfirmMark == '00000000') {
                    spanCertMarkDisplay = 'visibility :hidden';
                }
                certifiCations.push(response[i].GoodsConfirmMark);

                var src = '/GoodsImage' + '/' + response[i].GoodsFinalCategoryCode + '/' + response[i].GoodsGroupCode + '/' + response[i].GoodsCode + '/' + response[i].GoodsFinalCategoryCode + '-' + response[i].GoodsGroupCode + '-' + response[i].GoodsCode + '-mmm.jpg';
                var detailPage = 'GoodsDetail.aspx?CategoryCode=' + response[i].GoodsFinalCategoryCode + '&GroupCode=' + response[i].GoodsGroupCode + '&BrandCode=' + response[i].BrandCode + '&GoodsCode=' + response[i].GoodsCode;

                var svidUser = sviduser;
                var svidRole = svidRole;
                var price = '';
                var priceHtml = '';
                var spanPromotionDisplayFlag = '';
                if (isEmpty(response[i].GoodsDCPriceVat)) {
                    spanPromotionDisplayFlag = 'visibility :hidden';
                }
                if (svidUser == '' || svidRole == 'T' || userId == 'socialwith') {
                    price = '(회원전용)';
                    priceHtml = '<span class="keep_words">' + price + '</span>';
                }
                else {
                    price = numberWithCommas(response[i].GoodsSalePriceVat) + '원';

                    if (isEmpty(response[i].GoodsDCPriceVat)) {
                        priceHtml = '<span>' + price + '</span>';
                    }
                    else {
                        priceHtml = '<span style="text-decoration: line-through; font-size:13px;">' + price + '</span>&nbsp;<span  style="color:red;">' + numberWithCommas(response[i].GoodsDCPriceVat) + '원</span>';
                    }
                }

                var createHtml = '';
                if (pgFlag == 'Y') {

                    if (response[i].GoodsSalePriceVat < 4000000) {
                        createHtml = fnCreateGoodsHintHtml(response[i].GoodsConfirmMark, spanCertMarkDisplay, detailPage, src, response[i].GoodsFinalName, mapName, response[i].BrandName, priceHtml);
                    }
                }
                else {
                    createHtml = fnCreateGoodsHintHtml(response[i].GoodsConfirmMark, spanCertMarkDisplay, detailPage, src, response[i].GoodsFinalName, mapName, response[i].BrandName, priceHtml);
                }

                $('.category-hint-image').append(createHtml);
            }
            SetCertifyImageSet();

        } else {
            $('.category-hint').css('display', 'none')
        }



        $(".category-hint-image").slick({
            infinite: false,
            variableWidth: true,
            slidesToShow: 6,
            slidesToScroll: 1
        });
        return false;
    }
    var param = {
        Method: 'GetCategoryHint',
        CompCode: compcode,
        CtgrCode: qsFinalCategoryCode,
        SaleCompCode: saleCompcode,
        DongshinCheck: dsCheck,
        FreeCompanyYN: freeCompYN,
        FreeCompanyVatYN: freeCompanyVatYN,
        SvidUser: sviduser
    };

    JqueryAjax("Post", "../../Handler/GoodsHandler.ashx", false, false, param, "json", callback, null, null, true, sviduser);
    //Jajax('Post', '../../Handler/GoodsHandler.ashx', param, 'json', callback);
}

//브랜드내 인기상품
function fnBrandHint() {
    var index = 0;
    var certifiCations = new Array(); //인증마크
    var callback = function (response) {
        if (!isEmpty(response)) {

            for (var i = 0; i < response.length; i++) {
                var mapName = '';
                //배송일 당일발송과 1일만 보이게
                if (response[i].GoodsDeliveryOrderDue == '1' || response[i].GoodsDeliveryOrderDue == '2') {
                    mapName = response[i].MapName;
                }

                var spanCertMarkDisplay = '';
                if (isEmpty(response[i].GoodsConfirmMark) || response[i].GoodsConfirmMark == '00000000') {
                    spanCertMarkDisplay = 'visibility :hidden';
                }
                certifiCations.push(response[i].GoodsConfirmMark);
                var detailPage = 'GoodsDetail.aspx?CategoryCode=' + response[i].GoodsFinalCategoryCode + '&GroupCode=' + response[i].GoodsGroupCode + '&BrandCode=' + response[i].BrandCode + '&GoodsCode=' + response[i].GoodsCode;
                var src = '/GoodsImage' + '/' + response[i].GoodsFinalCategoryCode + '/' + response[i].GoodsGroupCode + '/' + response[i].GoodsCode + '/' + response[i].GoodsFinalCategoryCode + '-' + response[i].GoodsGroupCode + '-' + response[i].GoodsCode + '-mmm.jpg';


                var svidUser = sviduser;
                var svidRole = svidRole;
                var price = '';
                var priceHtml = '';
                var spanPromotionDisplayFlag = '';
                if (isEmpty(response[i].GoodsDCPriceVat)) {
                    spanPromotionDisplayFlag = 'visibility :hidden';
                }
                if (svidUser == '' || svidRole == 'T' || userId == 'socialwith') {
                    price = '(회원전용)';
                    priceHtml = '<span class="keep_words">' + price + '</span>';
                }
                else {
                    price = numberWithCommas(response[i].GoodsSalePriceVat) + '원';

                    if (isEmpty(response[i].GoodsDCPriceVat)) {
                        priceHtml = '<span>' + price + '</span>';
                    }
                    else {
                        priceHtml = '<span style="text-decoration: line-through; font-size:13px;">' + price + '</span>&nbsp;<span  style="color:red;">' + numberWithCommas(response[i].GoodsDCPriceVat) + '원</span>';
                    }
                }
                var createHtml = '';
                if (pgFlag == 'Y') {

                    if (response[i].GoodsSalePriceVat < 4000000) {
                        createHtml = fnCreateGoodsHintHtml(response[i].GoodsConfirmMark, spanCertMarkDisplay, detailPage, src, response[i].GoodsFinalName, mapName, response[i].BrandName, priceHtml);
                    }
                }
                else {
                    createHtml = fnCreateGoodsHintHtml(response[i].GoodsConfirmMark, spanCertMarkDisplay, detailPage, src, response[i].GoodsFinalName, mapName, response[i].BrandName, priceHtml);
                }

                $('.brand-hint-image').append(createHtml);
            }
            SetCertifyImageSet();

        }
        else {
            $('.brand-hint').css('display', 'none')
        }



        $(".brand-hint-image").slick({
            infinite: false,
            variableWidth: true,
            slidesToShow: 6,
            slidesToScroll: 1
        });
        return false;
    }
    var param = {
        Method: 'GetBrandHint',
        BrandCode: qsBrandCode,
        CompCode: compcode,
        DongshinCheck: dsCheck,
        FreeCompanyYN: freeCompYN,
        FreeCompanyVatYN: freeCompanyVatYN,
        SvidUser: sviduser
    };
    Jajax('Post', '../../Handler/GoodsHandler.ashx', param, 'json', callback);
}


function fnCreateGoodsHintHtml(confirmMark, confirmMarkDisplay, detailPageUrl, imgSrc, goodsName, mapName, brandName, price) {
    var createHtml = '';
    var mapnameStyle = '';
    if (isEmpty(mapName)) {
        mapnameStyle = 'style="visibility:hidden"';
    }
    createHtml += '<div class="goodsdetail_hint"><a href="' + detailPageUrl + '">';
    createHtml += '<div class="goods_confirmMark"><span class="spanCert" other-title="" id="spanCert' + confirmMark + '" style="' + confirmMarkDisplay + '">*인증상품</span></div>';
    createHtml += '<img src="' + imgSrc + '"  onerror="no_image(this, \'m\')">';
    createHtml += '<div class="subinfo"><span class="goodshint_brand">' + brandName + '</span><span class="goodshint_mapname" ' + mapnameStyle + '>' + mapName + '</span></div>';
    createHtml += '<h4>' + goodsName + '</h4>';
    createHtml += '<div class="" style="color:#2d5c84;padding-bottom:10px;"></div>';

    createHtml += '<div class="goods_price" ><span class="keep_words">' + price + '</span></div>';
    createHtml += '</a></div>';

    return createHtml;
}

//인증마크
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

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function fnShowAllSummary() {

    $(".goodsdetail-optionselector dl.optionlist dd a").removeClass('selected');
    var groupCode = $('#hdGroupCode').val();
    fnGroupOptionSelector(groupCode, '');
    fnGoodsListBind(groupCode, '');
    return false;
}
function fnCartPopupClose() {
    $('#summaryList input[type="checkbox"]').each(function () {
        $(this).prop('checked', '');
    });
    $('.divpopup-layer-package').fadeOut();
}

function fnGoCart() {

    location.href = '../../Cart/CartList.aspx';
    return false;
}
function fnWishPopupClose() {
    $('#summaryList input[type="checkbox"]').each(function () {
        $(this).prop('checked', '');
    });

    $('.divpopup-layer-package').fadeOut();
}

function fnGoWish() {

    location.href = '../../Wish/WishList.aspx';
    return false;
}



// 즐겨찾기 추가 
function addBookmark() {

    var title = $("#hdGoodName").val();
    var url = location.href;

    if (window.sidebar && window.sidebar.addPanel) {  //Firefox
        window.sidebar.addPanel(title, url, "");
    } else if (window.opera && window.print) {  //opera
        var elem = decument.createElement('a');
        elem.setAttribute('href', url);
        elem.setAttribute('title', title);
        elem.setAttribute('rel', 'sidebar');
        elem.click();
    }
    else if (navigator.userAgent.indexOf("MSIE") > -1 || (window.external && ('AddFavorite' in window.external))) { //IE
        window.external.AddFavorite(url, "[소셜위드]- " + title + " 즐겨찾기");
    } else if (navigator.userAgent.indexOf("Chrome") > -1) {  //크롬 
        alert("이용하시는 웹 브라우저는 기능이 지원되지 않습니다. Ctrl+D 키를 누르시면 즐겨찾기에 추가하실 수 있습니다.");
        return true;
    }
}

//최저가 가격 비교 팝업
function fnPriceDetail() {
    var goodsChk = $('#summaryList input[type="checkbox"]:checked').length      //체크박스 값 체크(0이면 리턴)

    if (goodsChk == '0') {
        alert('비교할 상품이 없습니다. 상품을 선택해주세요.')
        return false;
    }
    else if (goodsChk > '1') {
        alert('상품 비교는 한 품목씩 가능합니다.')
        return false;
    }


    var e = document.getElementById('categoryPdiv');

    if (e.style.display == 'block') {
        e.style.display = 'none';

    } else {
        e.style.display = 'block';
    }


    fnSetting();

    return false;


}

function fnPriceSet(obj) {
    var svidUser = sviduser;
    var svidRole = svidRole;
    var Qty = "";               //상품 수량 변수
    var Amt = "";               //상품 단가 변수
    var TotalAmt = "";          //수량 x 단가 변수
    var moq = parseInt($('#hdGoodUnitMoq').val());

    Qty = $('#txtPopupQty').val();                      // 수량 체크
    Amt = $('label[id*="p_GoodsPriceVat"]').text();     // 상품 단가 체크
    Amt = Amt.replace('원', '');                        // '원' 한글 텍스트 제거
    Amt = (parseInt(Amt.replace(/[^\d]+/g, '')));       // 콤마 제거 정규식 
    TotalAmt = numberWithCommas(Qty * Amt) + '원';      // 수량 x 단가 계산
    $('#p_GoodsTotalPriceVat').empty();                 // 데이터가 들어갈 label 태그 비워주기
    $('#p_GoodsTotalPriceVat').append(TotalAmt);        // label 태그 에 데이터 뿌림
    if (svidUser == '' || svidRole == 'T' || userId == 'socialwith') {
        TotalAmt = '(회원전용)'; //추가한 부분
        $('#p_GoodsTotalPriceVat').empty();                 // 데이터가 들어갈 label 태그 비워주기
        $('#p_GoodsTotalPriceVat').append(TotalAmt);        // label 태그 에 데이터 뿌림
    }

}

//가격비교 창 닫기
function fnCancel() {
    $('.divpopup-layer-package').fadeOut();
}

function fnGroupOptionSelector(groupCode, goodsCode) {


    var callback = function (response) {

        if (!isEmpty(response)) {
            $('#divOptionSelector').empty();
            var codes = new Array();
            var createHtml = '';

            for (var i = 0; i < response.length; i++) {

                if (fnCheckArrayCotains(codes, response[i].GoodsOptionCationCode) == false) { //중복제거
                    createHtml += '<dl class="optionlist"  style="margin-bottom:0px">'
                    createHtml += '<dt id="dt' + response[i].GoodsOptionCationCode + '">' + response[i].GoodsOptionCationName
                    createHtml += '</dt>'
                    createHtml += '</dl>'
                    codes.push(response[i].GoodsOptionCationCode);

                }



            }

            $('#divOptionSelector').append(createHtml);

            $.each(codes, function (index, value) {
                var subCreateHtml = '';
                subCreateHtml += '<dd>';
                for (var i = 0; i < response.length; i++) {

                    if (value == response[i].GoodsOptionCationCode) {

                        subCreateHtml += '<a onclick="fnOptionFilter(this)" style="float:left;">' + response[i].GoodsOptionValues + '';
                        var hdOptionSelectorVale = response[i].GoodsOptionCationCode + '::' + response[i].GoodsOptionValues;
                        subCreateHtml += '<input type="hidden" id="hdOptionSelector" value="' + hdOptionSelectorVale + '"></a>';

                    }

                }
                subCreateHtml += '</dd>';
                $('#dt' + value + '').after(subCreateHtml);
            });
            return false;
        }


    }
    var param = { Method: 'GetGoodsGroupOption', GoodsGroupCode: groupCode, GoodsCode: goodsCode };


    JqueryAjax("Post", "../../Handler/GoodsHandler.ashx", false, false, param, "json", callback, null, null, true, sviduser);
}

var optionValue = new Array();
function fnOptionFilter(el) {
    if ($(el).attr('class') == 'selected') {
        fnArrayValRemove(optionValue, $(el).find("#hdOptionSelector").val());
        $(el).removeClass('selected');
    }
    else {
        if (fnCheckArrayCotains(optionValue, $(el).find("#hdOptionSelector").val()) == false) { //중복제거

            optionValue.push($(el).find("#hdOptionSelector").val());
        }

        $(el).addClass('selected');
    }

    if (optionValue.length == 0) {
        $("#summaryList tbody tr").css('display', '');
        return false;
    }


    $("#summaryList tbody tr").css('display', 'none');
    $("#summaryList tbody tr").each(function () {

        var curRow = $(this);
        var getOptionArray = curRow.attr('id').split('$#$');

        $.each(getOptionArray, function (index, value) {

            if (fnCheckArrayCotains(optionValue, value)) {
                curRow.css('display', '');
            }
        })
    });
    return false;
}

//현재 카테고리 메뉴명 설정
function fnCtgrCurrentDepth(finalCode) {
    var param = { FinalCode: finalCode, Method: 'GetCtgrDepth' };
    var callback = function (response) {
        if (!isEmpty(response)) {
            $("#ddlCategory01").val(response.split(',')[0]);

            //하위 카테고리 정보 바인딩
            for (var i = 1; i <= response.split(',').length; i++) {
                fnSubCategoryBind(response.split(',')[i - 1], response.split(',')[i], i + 1);
            }
        }

        return false;
    };

    JqueryAjax("Post", "../Handler/Common/CategoryHandler.ashx", false, false, param, "json", callback, null, null, true, sviduser);

}

function fnCategoryChanged(el, level) {

    var ctgrCode = $(el).val();
    var searchType = 'C';
    if ($(el).val() == 'All') {
        if (level == 1) {
            ctgrCode = 'All';
            searchType = 'B';
        }
        else if (level == 2) {
            ctgrCode = $('#ddlCategory01').val();
        }
        else if (level == 3) {
            ctgrCode = $('#ddlCategory02').val();
        }
        else if (level == 4) {
            ctgrCode = $('#ddlCategory03').val();
        }
        else if (level == 5) {
            ctgrCode = $('#ddlCategory04').val();
        }
    }

    var params = 'CategoryCode=' + ctgrCode + '&SearchFlag=' + searchType;
    location.href = 'GoodsList.aspx?' + params;
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

            $("#ddlCategory01").append(ddlHtml);

         }
        return false;
    };

    var param = {
        LevelCode: '1',
        UpCode: '',
        Method: 'GetCategoryLevelList'
    };

    JqueryAjax("Post", "../../Handler/Common/CategoryHandler.ashx", false, false, param, "json", callback, null, null, true, sviduser);
}

//상위레벨 카테고리 선택시 하위 카테고리 리스트 바인드
function fnChangeSubCategoryBind(el, level) {



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
            $("#ddlCategory" + id).append(ddlHtml); ddlCategory

        }
        return false;
    };

    var param = {
        LevelCode: level,
        UpCode: selectedVal,
        Method: 'GetCategoryLevelList'
    };

    JajaxSessionCheck('Post', '../../Handler/Common/CategoryHandler.ashx', param, 'json', callback, sviduser);

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
            $("#ddlCategory" + id).append(ddlHtml);
            code = !isEmpty(code) ? code : 'All';
            $("#ddlCategory" + id).val(code);

        }
        //fnGoodsListBind(1, $("#hdLinkType").val(), $('#hdOrderValue').val(),bCodes);
        return false;
    };

    var param = {
        LevelCode: level,
        UpCode: upcode,
        Method: 'GetCategoryLevelList'
    };

    JajaxSessionCheck('Post', '../../Handler/Common/CategoryHandler.ashx', param, 'json', callback, sviduser);

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


    $("#ddlCategory" + id).empty();
    $("#ddlCategory" + id).append('<option value="All">---전체---</option>');
    return false;

}