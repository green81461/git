<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Master/AdminMasterPage.master" AutoEventWireup="true" CodeFile="GoodsList.aspx.cs" Inherits="Admin_Goods_GoodsList" %>

<%@ Register Src="~/UserControl/ucListControl.ascx" TagName="ListPager" TagPrefix="ucPager" %>
<%@ Import Namespace="Urian.Core" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <script src="../../Scripts/jquery.fileDownload.js"></script>
    <script>

        $(function () {

            fnCategoryBind(1);

            //브랜드팝업 확인
            $("#popupOk").on("click", function () {

                var brandCode = $("#hdSelectBrand").val();

                $("#txtBrandSearch").val(brandCode);

                fnBrandPopupOpen();
                fnBrandPopupCancel();
                fnCategoryListBind(1);

            });

            //$("#btnSearch").on("click", function () {

            //    fnCategoryListBind(1);
            //});



            $("#txtStartDate").inputmask("9999-99-99");
            $("#txtStartDate").datepicker({
                showAnimation: 'slideDown',
                changeMonth: true,
                changeYear: true,
                showOn: 'button',
                buttonImage: "/Images/Goods/calendar.jpg",
                buttonImageOnly: true,
                dateFormat: "yy-mm-dd",
                monthNamesShort: ["1월", "2월", "3월", "4월", "5월", "6월", "7월", "8월", "9월", "10월", "11월", "12월"],
                dayNamesMin: ["일", "월", "화", "수", "목", "금", "토"],
                showMonthAfterYear: true,
                onSelect: function (dateText) {
                    $("#hfStartDate").val(dateText)
                }

            });

            $("#txtEndDate").val($.datepicker.formatDate('yymmdd', new Date()));
            $("#hfEndDate").attr('value', $.datepicker.formatDate('yy-mm-dd', new Date()));
            $("#txtEndDate").inputmask("9999-99-99");
            $("#txtEndDate").datepicker({
                showAnimation: 'slideDown',
                changeMonth: true,
                changeYear: true,
                showOn: 'button',
                buttonImage: "/Images/Goods/calendar.jpg",
                buttonImageOnly: true,
                dateFormat: "yy-mm-dd",
                monthNamesShort: ["1월", "2월", "3월", "4월", "5월", "6월", "7월", "8월", "9월", "10월", "11월", "12월"],
                dayNamesMin: ["일", "월", "화", "수", "목", "금", "토"],
                showMonthAfterYear: true,
                onSelect: function (dateText) {
                    $("#hfEndDate").val(dateText)
                }

            });

            //오늘날짜로 부터 1년전
            var date = new Date();
            date.setFullYear(date.getFullYear() - 1);
            $("#txtStartDate").val($.datepicker.formatDate('yy-mm-dd', date));
            $("#hfStartDate").attr('value', $.datepicker.formatDate('yy-mm-dd', date));

            // fnCategoryListBind(1); //날짜때문에 마지막에

            //팝업창
            var ddlSearchTarget = $('#ddlSearchTarget');
            $("#pop_brandTbody").on("mouseover", "tr", function () {

                $("#pop_brandTbody tr").css("cursor", "pointer");
            });

            $("#pop_brandTbody").on("click", "tr", function () {

                $("#hdSelectBrand").val('');
                $("#pop_brandTbody tr").css("background-color", "");

                $(this).css("background-color", "#ffe6cc");

                var selectBrand = $(this).find("input:hidden[name^='hd_trBrandCode']").val();
                $("#hdSelectBrand").val(selectBrand);
            });

            $("#txtBrandSearch").on("keypress", function (e) {

                var txtBrandSearch = $('#txtBrandSearch');
                if (e.keyCode == 13) {

                    if (ddlSearchTarget.val() == 'Brand' && txtBrandSearch.val() != '') {
                        fnBrandPopupOpen();
                        $("#txtPopupBrandSearch").focus();
                        return false;
                    }
                    else {

                        fnCategoryListBind(1);

                        return false;
                    }
                }
            });

            $("#txtModelSearch").on("keypress", function (e) {

                //var txtBrandSearch = $('#txtModelSearch');
                if (e.keyCode == 13) {
                    fnCategoryListBind(1);
                    return false;
                }

            });

            $("#txtGoodsCodeB").on("keypress", function (e) {


                if (e.keyCode == 13) {

                    if ($('#txtGoodsCodeB').val() == '' || $('#txtGoodsCodeE').val() == '') {

                        alert('상품코드를 입력해 주세요');
                        return false;
                    }

                    fnCategoryListBind(1);
                    return false;
                }

            });

            $("#txtGoodsCodeE").on("keypress", function (e) {

                if ($('#txtGoodsCodeB').val() == '' || $('#txtGoodsCodeE').val() == '') {

                    alert('상품코드를 입력해 주세요');
                    return false;
                }

                if (e.keyCode == 13) {
                    fnCategoryListBind(1);
                    return false;
                }

            });



            //브랜드검색
            $('#txtBrandSearch').bind('paste', function (e) {

                if (ddlSearchTarget.val() == 'GoodsCode' || ddlSearchTarget.val() == 'SGoodsCode') {

                    var $this = $(this);
                    setTimeout(function () {
                        var agent = navigator.userAgent.toLowerCase();

                        if ((navigator.appName == 'Netscape' && agent.indexOf('trident') != -1) || (agent.indexOf("msie") != -1)) {
                            var source = window.clipboardData;

                            if (source.getData("Text").length > 0) {

                                $this.val(source.getData("Text").replace(/(\n|\r\n)/g, ','))
                            }

                        }
                        else {
                            $this.val($this.val().replace(/ /g, ','))
                        }

                    }, 0);
                }
            });


            //브랜드검색 Enter
             $("#txtPopupBrandSearch").keypress(function () {
            if (event.keyCode == 13) {
                
                fnBrandSearch($('#txtBrandSearch'));
            }
		 }); 


        });//$function end



        function fnCategoryListBind(pageNo) {
            $('#hdTarget').val("");
            var codeCheck = $('#cbSearchRange').prop("checked") ? "GoodsCode" : $('#ddlSearchTarget').val();
            $('#hdTarget').val(codeCheck);
            var pageSize = 20;
            var callback = function (response) {
                // $("#tblCategoryList").empty()


                if (!isEmpty(response)) {

                    var categoryList = '';
                    $.each(response, function (key, value) {

                        $('#TotalCount').val(value.TotalCount);


                        var src = '/GoodsImage/' + value.GoodsFinalCategoryCode + '/' + value.GoodsGroupCode + '/' + value.GoodsCode + '/' + value.GoodsFinalCategoryCode + '-' + value.GoodsGroupCode + '-' + value.GoodsCode + '-sss.jpg';
                        var orderdueIcon = '<img src="../../Images/Order/orderdueicon_' + value.GoodsDeliveryOrderDue_Type + '.png"/>'; //발송일 아이콘
                        categoryList += '<tr>';
                        categoryList += '<td style="width:30px"><input type="checkbox" id="cbSelect" /><input type="hidden" id="hfGoodsCode" value="' + value.GoodsCode + '" /></td>';
                        categoryList += '<td style="width:50px">' + value.RowNum + '</td>';
                        categoryList += '<td style="width:70px"><img width="50" height="50" src=' + src + ' onerror="this.onload = null; this.src=\'/Images/noImage_s.jpg\';" /></td>';
                        categoryList += '<td style="width:100px" class="txt-center">' + value.GoodsGroupCode + '</td>';

                        var displayFlagVal = value.GoodsDisplayFlag + "";
                        var displayFlagNm = '';
                        if (isEmpty(displayFlagVal)) {
                            displayFlagNm = '-';
                        } else {
                            if (displayFlagVal == "1") {
                                displayFlagNm = "<br />(노출)";
                            } else if (displayFlagVal == "2") {
                                displayFlagNm = "<br />(비노출)";
                            }
                        }

                        categoryList += '<td style="width:100px" class="txt-center"><a style="cursor:pointer" onclick="javascript:fnGoGoodsModify(\'' + value.GoodsCode + '\');">' + value.GoodsCode + '</a>' + displayFlagNm + '</td>';
                        categoryList += '<td id="tdGoodsInfo" style="width:280px; text-align:left; padding-left:10px;">[' + value.BrandName + ']&nbsp;' + value.GoodsFinalName + '<br />' + value.GoodsOptionSummaryValues + '</td>';
                        categoryList += '<td style="width:100px" class="txt-center">' + value.GoodsModel + '</td>';
                        categoryList += '<td style="width:100px" class="txt-center">' + orderdueIcon + '</td>';
                        categoryList += '<td style="width:70px" class="txt-center">' + value.GoodsUnitMoq + ' / ' + value.GoodsUnit + '</td>';
                        //categoryList += '<td style="width:50px">' + value.GoodsUnit + '</td>';
                        categoryList += '<td style="width:100px ;text-align:right; padding-right:15px;">' + numberWithCommas(value.GoodsBuyPriceVat) + '원</td>';
                        categoryList += '<td style="width:100px ;text-align:right; padding-right:15px;">' + numberWithCommas(value.GoodsCustPriceVat) + '원</td>';
                        categoryList += '<td style="width:100px ;text-align:right; padding-right:15px;">' + numberWithCommas(value.GoodsSalePriceVat) + '원</td>';
                        categoryList += '<td style="width:100px ;text-align:right; padding-right:15px;">' + numberWithCommas(value.GoodsMSalePriceVat) + '원</td>';
                        categoryList += '</tr>';

                    });
                } else {

                    categoryList += '<tr>';
                    categoryList += '<td colspan="13" class="txt-center">조회된 정보가 없습니다.</td>';
                    categoryList += '</tr>';
                    $("#TotalCount").val(0);
                }
                fnCreatePagination('pagination', $("#TotalCount").val(), pageNo, pageSize, getPageData);
                $("#tblCategoryList").empty().append(categoryList);
                return false;
            };

            var ctgrIndex_1 = $("#ddlCtgrLevel_1 option").index($("#ddlCtgrLevel_1 option:selected"));
            var ctgrIndex_2 = $("#ddlCtgrLevel_2 option").index($("#ddlCtgrLevel_2 option:selected"));
            var ctgrIndex_3 = $("#ddlCtgrLevel_3 option").index($("#ddlCtgrLevel_3 option:selected"));
            var ctgrIndex_4 = $("#ddlCtgrLevel_4 option").index($("#ddlCtgrLevel_4 option:selected"));
            var ctgrIndex_5 = $("#ddlCtgrLevel_5 option").index($("#ddlCtgrLevel_5 option:selected"));


            var categoryCode = "";
            if (ctgrIndex_5 > 0) {
                categoryCode = $("#ddlCtgrLevel_5").val();

            } else if (ctgrIndex_4 > 0) {
                categoryCode = $("#ddlCtgrLevel_4").val();
            }
            else if (ctgrIndex_3 > 0) {
                categoryCode = $("#ddlCtgrLevel_3").val();
            }
            else if (ctgrIndex_2 > 0) {
                categoryCode = $("#ddlCtgrLevel_2").val();
            }
            else if (ctgrIndex_1 > 0) {
                categoryCode = $("#ddlCtgrLevel_1").val();
            }

            $('#hdcategoryCode').val(categoryCode);


            var param = {
                CategoryCode: categoryCode,
                Target: $('#cbSearchRange').prop("checked") ? "GoodsCode" : $('#ddlSearchTarget').val(),
                BrandKeyword: $('#ddlSearchTarget').val() ? $.trim($('#txtBrandSearch').val()) : $('#txtBrandSearch').val(),
                ModelKeyword: $('#txtModelSearch').val(),
                RangeSearchFlag: $('#cbSearchRange').prop("checked") ? "Y" : "N",
                GoodsCodeB: $('#txtGoodsCodeB').val(),
                GoodsCodeE: $('#txtGoodsCodeE').val(),
                DateSearchFlag: $('#rbSearchE').prop("checked") ? "ENTRY" : "MODIFY",
                ToDateB: $('#hfStartDate').val(),
                ToDateE: $('#hfEndDate').val(),
                PageNo: pageNo,
                PageSize: pageSize,
                Method: 'GetGoodsSearchList_Admin'
            };

            var beforeSend = function () {
                $('#divLoading').css('display', '');
            }
            var complete = function () {
                $('#divLoading').css('display', 'none');
            }

            JqueryAjax("Post", "../../Handler/GoodsHandler.ashx", true, false, param, "json", callback, beforeSend, complete, true, '<%=Svid_User %>');
        }

        //페이지
        function getPageData() {
            var container = $('#pagination');
            var getPageNum = container.pagination('getSelectedPageNum');
            fnCategoryListBind(getPageNum);
            return false;
        }

        //상품코드 눌렀을때 이동
        function fnGoGoodsModify(code) {
            location.href = 'GoodsModify.aspx?GoodsCode=' + code + '&ucode=' + ucode;
            return false;
        }

        //카테고리 리스트 1
        function fnCategoryBind() {
            fnSelectBoxClear(1);
            var callback = function (response) {

                if (!isEmpty(response)) {

                    var ddlHtml = "";

                    $.each(response, function (key, value) {

                        ddlHtml += '<option value="' + value.CategoryFinalCode + '">' + value.CategoryFinalName + '</option>';
                    });
                    $("#ddlCtgrLevel_1").append(ddlHtml);
                }
                return false;
            };
            var param = {
                LevelCode: '1',
                UpCode: '',
                Method: 'GetCategoryLevelList'
            };

            JqueryAjax("Post", "../../Handler/Common/CategoryHandler.ashx", true, false, param, "json", callback, null, null, true, '<%=Svid_User %>');
        }


        //상위레벨 카테고리 선택시 하위 카테고리 리스트 바인드
        function fnChangeSubCategoryBind(el, level) {

            var selectedVal = $(el).val();
            for (var i = level; i <= 5; i++) {
                fnSelectBoxClear(i);
            }
            var callback = function (response) {
                if (!isEmpty(response)) {

                    var ddlHtml = "";

                    $.each(response, function (key, value) {
                        ddlHtml += '<option value="' + value.CategoryFinalCode + '">' + value.CategoryFinalName + '</option>';
                    });

                    $("#ddlCtgrLevel_" + level).append(ddlHtml);
                }
                return false;
            };

            var param = {
                LevelCode: level,
                UpCode: selectedVal,
                Method: 'GetCategoryLevelList'
            };

            JqueryAjax("Post", "../../Handler/Common/CategoryHandler.ashx", true, false, param, "json", callback, null, null, true, '<%=Svid_User %>');


        }

        //카테고리 리스트 클리어
        function fnSelectBoxClear(index) {
            $("#ddlCtgrLevel_" + index).empty();
            $("#ddlCtgrLevel_" + index).append('<option value="All">전체</option>');
        }

        //전체선택
        function fnSelectAll(el) {
            if ($(el).prop("checked")) {
                $("input[id*=cbSelect]").not(":disabled").prop("checked", true);
            }
            else {
                $("input[id*=cbSelect]").not(":disabled").prop("checked", false);
            }
        }

        //브랜드검색 팝업창 열기
        function fnBrandPopupOpen() {
            // $('#hdTarget').val($('#cbSearchRange').prop("checked") ? "GoodsCode" : $('#ddlSearchTarget').val());
            var ddlSearchTarget = $('#ddlSearchTarget');
            var txtBrandSearch = $('#txtBrandSearch');
            var searchRange = $('#cbSearchRange').prop("checked");
            if (ddlSearchTarget.val() == 'GoodsCode' && searchRange == true) {

                if ($('#txtGoodsCodeB').val() == '' || $('#txtGoodsCodeE').val() == '') {

                    alert('상품코드를 입력해 주세요.');
                    return false;
                }
                else {
                    fnCategoryListBind(1);
                }

            }
            else if (ddlSearchTarget.val() == 'Brand' && txtBrandSearch.val() != '') {

                fnOpenDivLayerPopup('brandDiv');
                fnBrandSearch($('#txtBrandSearch'));
                return false;
            }
            else {
                fnCategoryListBind(1);
            }
        }

        

        // 브랜드검색 팝업창에서 검색 버튼 클릭 시
        function fnBrandSearch(obj) {
            // 초기화
            $("#pop_brandTbody").html('');
            $("#hdSelectBrand").val('');

            var brandKeyword = $(obj).val();
            $("#txtPopupBrandSearch").val(brandKeyword);

            var callback = function (response) {
                var returnVal = false;
                if (!isEmpty(response)) {

                    var listTag = "";

                    $.each(response, function (key, value) {

                        listTag += "<tr>"
                            + "<td class='txt-center'>" + (key + 1) + "</td>"
                            + "<td class='txt-center'><input type='hidden' name='hd_trBrandCode' value='" + value.BrandCode + "' />" + value.BrandCode + "</td>"
                            + "<td style='padding-left:5px;'>" + value.BrandName + "</td>"
                            + "</tr>";
                    });

                    $("#pop_brandTbody").append(listTag);

                } else {
                    var emptyTag = "<tr><td colspan='3' class='txt-center'>조회된 브랜드가 없습니다.</td></tr>";

                    $("#pop_brandTbody").append(emptyTag);
                }

                return false;
            };

            var sUser = '<%=Svid_User %>';
            var param = { BrandKeyword: brandKeyword, Method: 'BrandSearch_Admin' };

            JqueryAjax("Post", "../../Handler/Common/BrandHandler.ashx", true, false, param, "json", callback, null, null, true, '<%=Svid_User %>');
        }





        //팝업창 닫기
        function fnBrandPopupCancel() {
            $('.divpopup-layer-package').fadeOut();
            $("#txtPopupBrandSearch").val('');
            $("#hdSelectBrand").val('');
            $("#pop_brandTbody").html('');
        }

        //상품코드 범위
        function fnSearchRangeChecked(el) {

            if ($(el).prop("checked")) {
                $('#spanSearchRange').css('display', '');
                $('#txtBrandSearch').css('display', 'none');
                $('#ddlSearchTarget').val('GoodsCode');
                $('#ddlSearchTarget').prop("disabled", true);
            }
            else {
                $('#spanSearchRange').css('display', 'none');
                $('#txtBrandSearch').css('display', '');
                $('#ddlSearchTarget').prop("disabled", false);
            }
        }

        //Excel
        function fnExcelExport() {

            $.fileDownload('../../Handler/ExcelHandler.ashx', {
                httpMethod: 'POST',
                dataType: "json",
                contentType: "application/json",
                data: {
                    CategoryCode: $('#hdcategoryCode').val(),
                    ModelKeyword: $('#txtModelSearch').val(),
                    BrandKeyword: $('#ddlSearchTarget').val("GoodsCode") ? $.trim($('#txtBrandSearch').val()) : $('#txtBrandSearch').val(),
                    Target: $('#hdTarget').val(),
                    RangeSearchFlag: $('#cbSearchRange').prop("checked") ? "Y" : "N",
                    GoodsCodeB: $('#txtGoodsCodeB').val(),
                    GoodsCodeE: $('#txtGoodsCodeE').val(),
                    DateSearchFlag: $('#rbSearchE').prop("checked") ? "ENTRY" : "MODIFY",
                    ToDateB: $('#hfStartDate').val(),
                    ToDateE: $('#hfEndDate').val(),
                    Method: 'GoodsListExcelDownLoad'
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
    <style>
        .imgbtn {
            vertical-align: bottom;
        }

        .goodSearchTopBox {
            overflow: hidden;
            float: left;
            width: 70%;
            padding: 5px 5px 0
        }

            .goodSearchTopBox select,
            .goodSearchTopBox input[type="text"],
            .goodSearchTopBox > span.searchValTitle {
                float: left;
                width: 126px;
                border: 1px solid #a9a9a9;
                line-height: 26px;
                height: 26px;
                color: #000;
                background-color: white; /* line-height, height, color 값이 없어서 추가함.*/
            }

            .goodSearchTopBox input[type="text"] {
                width: calc(100% - 131px);
                margin-left: 5px;
                padding: 0 5px;
                border-radius: 0 !important
            }

            .goodSearchTopBox + .goodSearchTopBox {
                clear: both;
                padding-bottom: 5px
            }

            .goodSearchTopBox + input[type="submit"].mainbtn.type1 {
                width: 68px;
                height: 43px;
                margin-top: 13px
            }

        span.searchRangeSign {
            float: left;
            margin: 3px 0 0 5px
        }

        table#Search-table td {
            padding: 5px
        }

            table#Search-table td .input-drop {
                height: 26px !important
            }

            table#Search-table td input[type="text"].hasDatepicker {
                padding: 0 3px
            }

                table#Search-table td input[type="text"].hasDatepicker + img {
                    margin: -4px 0 0 3px
                }

        input[type="radio"] {
            margin-right: 3px;
            vertical-align: middle
        }
    </style>
    <link href="../Content/Goods/goods.css" rel="stylesheet" />
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div class="all">
        <div class="sub-contents-div">
            <!--제목타이틀 영역-->
            <div class="sub-title-div">
                <p class="p-title-mainsentence">
                    상품 조회
                    <span class="span-title-subsentence">상품을 조회 할 수 있습니다.</span>
                </p>
            </div>

            <!--상단 조회 영역 시작-->
            <div class="search-div">

                <!--검색 영역-->
                <div class="bottom-search-div">
                    <table class="tbl_search">
                        <tr>
                            <td>
                                <div class="goodSearchTopBox">

                                    <select id="ddlSearchTarget" style="background-color: white; height: 26px;">
                                        <option value="GoodsCode">상품코드</option>
                                        <option value="GoodsName">상품명</option>
                                        <option value="Brand">브랜드</option>
                                        <option value="SGoodsCode">공급사 상품코드</option>
                                        <option value="SupplyCompCode1">공급사 코드1</option>
                                    </select>
                                    <input type="text" id="txtBrandSearch" placeholder="검색어를 입력하세요" />
                                    <span id="spanSearchRange" style="display: none">
                                        <input type="text" id="txtGoodsCodeB" style="width: 150px" onkeypress="return fnsearchRangeTextKeypress()" />
                                        <span class="searchRangeSign">~ </span>
                                        <input type="text" id="txtGoodsCodeE" style="width: 150px" onkeypress="return fnsearchRangeTextKeypress()" /></span>
                                </div>
                                <div class="goodSearchTopBox">
                                    <span class="searchValTitle">모델명</span>
                                    <input type="text" id="txtModelSearch" value="" placeholder="검색어를 입력하세요" />
                                </div>

                                <input type="button" id="btnSearch" value="검색" style="width:75px" onclick="return fnBrandPopupOpen()" class="mainbtn type1" />
                                <input type="checkbox" id="cbSearchRange" onclick="fnSearchRangeChecked(this);" />상품코드 범위검색
                            </td>
                        </tr>
                    </table>
                </div>

                <table id="Search-table" class="tbl_main">
                    <tr>
                        <th>1차분류</th>
                        <th>2차분류</th>
                        <th>3차분류</th>
                        <th>4차분류</th>
                        <th>5차분류</th>
                    </tr>
                    <tr id="ctgrSearchTr">
                        <td>
                            <%--<asp:DropDownList runat="server" ID="ddlCtgrLevel_1" CssClass="medium-size" onchange="fnChangeSubCategoryBind(this,2); return false;">
                        </asp:DropDownList>--%>
                            <select id="ddlCtgrLevel_1" class="medium-size" onchange="fnChangeSubCategoryBind(this,2); return false;"></select>
                        </td>
                        <td>

                            <select id="ddlCtgrLevel_2" class="medium-size" onchange="fnChangeSubCategoryBind(this,3); return false;">
                                <option>전체</option>
                            </select>
                        </td>
                        <td>

                            <select id="ddlCtgrLevel_3" class="medium-size" onchange="fnChangeSubCategoryBind(this,4); return false;">
                                <option>전체</option>
                            </select>
                        </td>
                        <td>

                            <select id="ddlCtgrLevel_4" class="medium-size" onchange="fnChangeSubCategoryBind(this,5); return false;">
                                <option>전체</option>
                            </select>
                        </td>
                        <td>

                            <select id="ddlCtgrLevel_5" class="medium-size">
                                <option>전체</option>
                            </select>
                        </td>
                    </tr>
                    <tr>
                        <th>기준일자 별
                        </th>
                        <td colspan="4">
                            <input type="text" id="txtStartDate" readonly />
                            <input type="hidden" id="hfStartDate" />
                            ~
                        <input type="text" id="txtEndDate" readonly />
                            <input type="hidden" id="hfEndDate" />&nbsp;&nbsp;&nbsp;
                        <input type="radio" id="rbSearchE" name="radioFlag" value="rbSearchE" checked="checked" />
                            <label for="rbSearchE">등록일자</label>
                            <input type="radio" id="rbSearchM" name="radioFlag" value="rbSearchM" />
                            <label for="rbSearchM">수정일자</label>
                        </td>

                    </tr>
                </table>
            </div>

            <!--상단영역 끝 -->
            <input type="hidden" id="hdTarget" />
            <!--엑셀저장 버튼-->
            <div style="float: right; padding: 10px 0 10px 0">
                <%--<asp:Button runat="server" ID="btnExcelExport" CssClass="mainbtn type1" Text="엑셀저장"  Width="95" Height="30" OnClick="btnExcelExport_Click"/>--%>
                <input type="button" id="btnExcelExport" class="mainbtn type1" value="엑셀저장" style="width: 95px; height: 30px;" onclick="fnExcelExport(); return false" />
            </div>
            <input type="hidden" id="hdcategoryCode" />

            <!--하단 리스트 영역 시작-->
            <div class="">
                <!--데이터 리스트 시작 -->


                <table id="tblList" class="tbl_main">

                    <thead>
                        <tr>
                            <th>
                                <input type="checkbox" id="cbSelectAll" onclick="fnSelectAll(this);" />
                            </th>
                            <th>번호</th>
                            <th>이미지</th>
                            <th>상품그룹코드</th>
                            <th>상품코드</th>
                            <th>상품정보</th>
                            <th>모델명</th>
                            <th>출고예정일</th>
                            <th>최소수량 /
                                <br />
                                내용량</th>
                            <%--<th>내용량</th>--%>
                            <th>매입가격<br />
                                (VAT 포함)</th>
                            <th>판매사<br />
                                판매가격<br />
                                (VAT 포함)</th>
                            <th>구매사<br />
                                판매가격<br />
                                (VAT 포함)</th>
                            <th>민간 구매사<br />
                                판매가격<br />
                                (VAT 포함)</th>
                        </tr>
                    </thead>
                    <tbody id="tblCategoryList">
                        <tr>
                            <td colspan="13" class="txt-center">조회된 정보가 없습니다.</td>
                        </tr>
                    </tbody>
                </table>





                <!--데이터 리스트 종료 -->

            </div>

            <!--페이징-->
            <div style="margin: 20px auto; text-align: center">
                <input type="hidden" id="TotalCount" />
                <div id="pagination" class="page_curl" style="display: inline-block"></div>
            </div>
            <!--페이징 끝-->

            <!--하단 영역 끝-->




            <!--팝업창영역 시작-->
            <div id="brandDiv" class="popupdiv divpopup-layer-package">

                <div class="popupdivWrapper" style="width: 650px; height: 331px;">
                    <div class="popupdivContents" style="border: none;">
                        <div class="divpopup-layer-conts">
                            <div class="close-div">
                                <a onclick="fnBrandPopupCancel()" style="cursor: pointer">
                                    <img src="../../Images/Wish/icon-delete.jpg" alt="닫기" style="float: right;" /></a>
                            </div>
                                <%--<img src="../Images/Order/brand-search-title.jpg" alt="브랜드검색" />--%>
                                <h3 class="pop-title">브랜드검색</h3>

                                <!--팝업 컨텐츠 영역 시작-->
                                <div class="search-sub-div1">
                                    <input type="text" id="txtPopupBrandSearch" placeholder="검색어를 입력하세요" class="search1" style="padding-left: 5px;" />
                                    <input type="button" class="searchBt mainbtn type1" style="width:75px" value="검색" onclick="fnBrandSearch($('#txtPopupBrandSearch'))" />
                                <%--    <a onclick="fnBrandSearch($('#txtPopupBrandSearch'))" class="searchBt">
                                        <img src="../Images/Order/search-off.jpg" onmouseover="this.src='../Images/Order/search-on.jpg'" onmouseout="this.src='../Images/Order/search-off.jpg'" /></a>--%>
                                </div>

                                <div class="popup-div">
                                    <table class="tbl_main tbl_popup">
                                        <thead>
                                            <tr>
                                                <th style="width: 70px">번호</th>
                                                <th style="width: 150px">코드</th>
                                                <th style="width: auto">브랜드</th>
                                            </tr>
                                        </thead>
                                        <tbody id="pop_brandTbody">
                                        </tbody>
                                    </table>
                                </div>
                                <!--팝업 컨텐츠 영역끝-->

                            </div>
                        <br />
                        <!--팝업 확인 버튼 영역 시작-->
                        <div class="bt-align-div">
                            <input type="hidden" id="hdSelectBrand" />
                            <input type="button" id="popupOk" class="mainbtn type1" style="width: 95px; height: 30px;" value="확인" />

                        </div>
                        <!--팝업 확인 버튼 영역 끝-->
                    </div>
                </div>

            </div>
            <!--팝업창영역 끝-->
        </div>
    </div>

</asp:Content>

