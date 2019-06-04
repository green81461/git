<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Master/AdminMasterPage.master" AutoEventWireup="true" CodeFile="PromotionManagement.aspx.cs" Inherits="Admin_Promotion_PromotionManagement" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
   <link href="../Content/Goods/goods.css" rel="stylesheet" />
     <link href="../Content/popup.css" rel="stylesheet" />
  
    <script type="text/javascript">
        $(document).ready(function () {
            //달력
            $("#txtPromotionStart").datepicker({
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

            $("#txtPromotionEnd").datepicker({
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

            $("#tblPopupComp_Tbody").on("click", "tr", function () {

                //초기화
                $("#hdSelectCode").val('');
                $("#hdSelectName").val('');
                $("#tblPopupComp_Tbody tr").css("background-color", "");

                $(this).css("background-color", "#ffe6cc");
               
                var selectCode = $(this).find("#SaleComp_Code").text();
                var selectName = $(this).find("#SaleComp_Name").text();
                $("#hdSelectCode").val(selectCode);
                $("#hdSelectName").val(selectName);

            });
        });
        
        //주문 업체 팝업
        function fnSearchPopup() {
            $("#txtPopSearchComp").val($("#<%=txtCompSearch.ClientID%>").val());
            fnGetCompanyList(1);
            fnOpenDivLayerPopup('buyCompListPopupdiv');
            
            return false;
        }

        //주문 업체 목록 조회
        function fnGetCompanyList(pageNum) {

          
            var keyword = $("#txtPopSearchComp").val();
            var pageSize = 10;

            var callback = function (response) {
                $('#tblPopupComp tbody').empty(); //테이블 클리어
                var newRowContent = "";

                if (!isEmpty(response)) {

                    $.each(response, function (key, value) { //테이블 추가
                        if (key == 0) $("#hdCompTotalCount").val(value.TotalCount);

                        newRowContent += "<tr style='height: 30px; cursor: pointer;' >";
                        newRowContent += "<td id='SaleComp_Code' style='width: 100px' class='txt-center'>" + value.Company_Code + "</td>"; //회사코드
                        newRowContent += "<td id='SaleComp_Name' style='width: 100px' class='txt-center'>" + value.Company_Name + "</td> </tr>"; //회사명
                    });
                } else {
                    newRowContent += "<tr style='height: 30px'><td colspan='2' class='txt-center'>" + "조회된 데이터가 없습니다." + "</td></tr>"
                    $("#hdCompTotalCount").val(0);
                }
                $('#tblPopupComp tbody').append(newRowContent);

                fnCreatePagination('compPagination', $("#hdCompTotalCount").val(), pageNum, pageSize, getCompPageData);
                return false;
            }
            var param = {
                Flag: 'GetCompListByGubun',
                Keyword: $('#txtPopSearchComp').val(),
                Target: $('#selectCompTarget').val(),
                Gubun : 'BU',
                PageNo: pageNum,
                PageSize: pageSize,
            };

            JajaxSessionCheck('Post', '../../Handler/Admin/CompanyHandler.ashx', param, 'json', callback, '<%=Svid_User%>');
        }

        function getCompPageData() {
            var container = $('#compPagination');
            var getPageNum = container.pagination('getSelectedPageNum');
            fnGetCompanyList(getPageNum);
            return false;
        }

        function fnPopupOkComp() {
            fnGetPromotionList(1);
            //$('#tblList2 tbody').empty(); //단가리스트 테이블 클리어
            //$('#tblList2 tbody').append("<tr><td colspan='15' class='txt-center'>리스트가 없습니다.</td></tr>");
            //$('#compPricepagination').css('display', 'none');
            fnDisplayPromotionSetView();
            $('#spanSelectCompInfo').text('선택된 구매사 : ' + $("#hdSelectName").val() + '(' + $("#hdSelectCode").val()+')');
            fnClosePopup('buyCompListPopupdiv');

            return false;
        }

        //팝업에서 선택된 구매사의 프로모션 정보 조회
        function fnGetPromotionList(pageNo) {
          //$('#compPricepagination').css('display', 'none');
            $('#imgCreatePromotion').css('display', '');
            
           $('#tblPromotion tbody').empty(); //테이블 클리어
          var callback = function (response) {
           
              var newRowContent = "";
              
                if (!isEmpty(response)) {

                    $.each(response, function (key, value) { //테이블 추가
                        
                        newRowContent += "<tr style='height:40px'>";
                        newRowContent += "<td class='txt-center'>구매사</td>"; //구분
                        newRowContent += "<td class='txt-center'><a style='color:blue; cursor:pointer' onclick='fnGetGoodsPromotionList(1,\"" + value.GoodsPromotionCode + "\" );'> " + value.GoodsPromotionCode + "</a></td>";  //프로모션코드
                        newRowContent += "<td class='txt-center'>" + value.BuyCompCode + "</td>";  //구매사코드
                        newRowContent += "<td class='txt-center'>" + value.BuyCompName + "</td>";  //구매사명
                        newRowContent += "<td class='txt-center'>" + value.BuyCompDelegateName + "</td>";  //대표자명
                        newRowContent += "<td class='txt-center'>" + fnOracleDateFormatConverter(value.StartDate) + "</td>";  //프로모션 시작일
                        newRowContent += "<td class='txt-center'>" + fnOracleDateFormatConverter(value.EndDate) + "</td>";  //프로모션 종료일
                        newRowContent += "<td class='txt-center'>" + fnOracleDateFormatConverter(value.UpdateDate) + "</td>";  //프로모션 수정일
                        newRowContent += "<td class='txt-center'>" + value.UpdateUserName + "</td>";  //프로모션 수정자
                        newRowContent += "<td class='txt-center'>" + value.AdminUserName + "</td>";  //소셜위드 담당자
                        newRowContent += "<td class='txt-center'><img id='imgPromotionStop' alt='중지' src='../Images/Goods/useStop-off.jpg' onmouseover=\"this.src='../Images/Goods/useStop.jpg'\" onmouseout=\"this.src='../Images/Goods/useStop-off.jpg'\" style='cursor:pointer' onclick='fnPromotionDelete(\"" + value.GoodsPromotionCode + "\");'></td>";  //중지
                        newRowContent += "</tr>"; 
                    });
                } 
              else {
                    newRowContent += "<tr style='height:40px'><td colspan='11' class='txt-center'>" + "조회된 데이터가 없습니다." + "</td></tr>"
                  
                }
                $('#tblPromotion tbody').append(newRowContent);
                return false;
            }
            var param = {
                Method: 'GetPromotionList',
                Keyword: $("#hdSelectCode").val(),
                PageNo: pageNo,
                PageSize: 5,
            };

            JajaxSessionCheck('Post', '../../Handler/Admin/PromotionHandler.ashx', param, 'json', callback, '<%=Svid_User%>');
        }

        function fnDisplayPromotionSetView() {

            //$('#promotionGoodsPagination').css('display', 'none');
         
            var date = new Date();
            var dateAfterMonth = new Date(date.getFullYear(), date.getMonth()+1, date.getDate());

            $('#txtPromotionStart').val(date.yyyymmdd());
            $('#txtPromotionEnd').val(dateAfterMonth.yyyymmdd());
            $('#txtPromotioncode').val('');
            $('#trSearchRow').css('display', '');
            $('#divSetPromotion').css('display', ''); 
            $('#imgCreatePromotionCode').css('display', '');
            $('#<%= txtGoodsSearch.ClientID%>').val('');
            $('#txtPromotioncode').prop('disabled', false);
            $('#tblPromotionGoods tbody').empty(); //테이블 클리어
            $('#tblPromotionGoods tbody').append("<tr style='height:30px' id='trEmptyRow'><td colspan='10' class='txt-center'>" + "조회된 데이터가 없습니다." + "</td></tr>");
        }

        //개별 프로모션코드 자동생성
        function fnCreatePromotionCode() {

            var callback = function (response) {
                if (!isEmpty(response)) {

                    $('#txtPromotioncode').val(response);
                }
                else {
                    alert('시스템 오류입니다. 관리자에게 문의하세요.');
                }
                return false;
            }

            var param = {
                Method: 'GetPromotionNextCode',
            };

            var beforeSend = function () {
            };

            var complete = function () {
            };

            JqueryAjax('Post', '../../Handler/Admin/PromotionHandler.ashx', true, false, param, 'text', callback, beforeSend, complete,  true, '<%=Svid_User%>');
        }

     
        //상품 프로모션 리스트
        function fnGetGoodsPromotionList(pageNum, promotionCode) {
            $('#divSetPromotion').css('display', ''); 
            $('#trSearchRow').css('display', 'none');
            $('#imgCreatePromotionCode').css('display', 'none');
            $('#txtPromotioncode').prop('disabled', true);
            $('#selectAll').prop('checked', false)
            var target = 'PROMOTIONCODE';
            var keyword = promotionCode;
          
            $('#divLoading').css('display', '');
            var callback = function (response) {
                $('#tblPromotionGoods tbody').empty(); //테이블 클리어
                var newRowContent = "";

                if (!isEmpty(response)) {
                   
                    var index = 0;
                    $.each(response, function (key, value) { //테이블 추가
                        //$("#hdPromotionGoodsTotalCount").val(value.TotalCount);

                        if (index == 0) {
                            $('#txtPromotioncode').val(value.PromotionCode);
                            $('#txtPromotionStart').val(fnOracleDateFormatConverter(value.StartDate));
                            $('#txtPromotionEnd').val(fnOracleDateFormatConverter(value.EndDate));
                        }
                        var disableStyle = '';
                        if (value.GoodsDcYN == '2') {
                            disableStyle = 'disabled';
                        }
                        newRowContent += "<tr style='height:40px'>";
                        newRowContent += "<td class='txt-center'><input type='checkbox' id='cbSelect' " + disableStyle+"/>";
                        newRowContent += "<input type='hidden' id='hdCategoryCode' value='" + value.GoodsFinalCategoryCode + "'/>";
                        newRowContent += "<input type='hidden' id='hdGroupCode' value='" + value.GoodsGroupCode + "'/>";
                        newRowContent += "<input type='hidden' id='hdGoodsCode' value='" + value.GoodsCode + "'/>";
                        newRowContent += "<input type='hidden' id='hdBrandCode' value='" + value.BrandCode + "'/>";
                        newRowContent += "<input type='hidden' id='hdBuyPriceVat' value='" + value.GoodsBuyPriceVat + "'/>";
                        newRowContent += "</td>"; //선택
                        newRowContent += "<td style='text-align:left'>" + value.GoodsCode + "<br/>" + value.GoodsFinalName + "(" + value.GoodsModel + ")<br/>*" + value.BrandName + "<br/>" + value.GoodsOptionSummaryValue +"</td>";  //상품정보
                        newRowContent += "<td class='txt-center'>" + value.GoodsUnitName + "</td>";  //내용량
                        newRowContent += "<td class='txt-center'>" + value.GoodsGroupCode + "</td>";  //그룹코드
                        newRowContent += "<td class='txt-center' style='background-color:#E8FFFF'>" + numberWithCommas(value.GoodsSalePrice) + "원<br/>";  //구매사 판매가격
                        newRowContent += "<div id='divVatPrice' style='float:left; height:20px; padding-left:15px'><img src='/Images/tax_icon.png' width='20' height='20'/><label style='color:red' id='lblPriceVAT'>" + numberWithCommas(value.GoodsSalePriceVat) + "</label><label style='color:red'>원</label></div></td>";  //매입가격
                        newRowContent += "<td class='txt-center'>" + fnSetDCYN(value.GoodsDcYN) + "</td>";  //가격변동
                        newRowContent += "<td class='txt-center' style='background-color:#FFEBFF'>" + value.UrianYield + "%</td>";  //소셜위드수익률
                        newRowContent += "<td class='txt-center' style='background-color:#FFEBFF'>" + value.SaleCompYield + "%</td>";  //판매사수익률
                        newRowContent += "<td class='txt-center' style='background-color:#FFEBFF'>" + value.BuyCompYield + "%</td>";  //구매사수익률

                        var price = '';
                        if (!isEmpty(value.RolePrice)) {
                            price = numberWithCommas(value.RolePrice);
                        }
                        newRowContent += "<td class='txt-center' style='background-color:#E8FFFF'><input type='text' id='txtPrice' style='width:80%; ' value='" + price + "' " + disableStyle + " onkeyup='return fnAutoComma(this);' onkeypress='return onlyNumbers(event);'>원<div id='divVatPrice' style='float:left; height:20px'>";  //구매사 판매가격입력

                        if (!isEmpty(value.RolePriceVat)) {
                            newRowContent += "<img src='/Images/tax_icon.png' width='20' height='20'/><label style='color:red' id='lblPriceVAT'>" + numberWithCommas(value.RolePriceVat) + "</label><label style='color:red'>원</label>";
                        }

                        newRowContent += "</div></td></tr>";
                        newRowContent += "</tr>";
                        index++;
                    });
                } else {
                    $("#hdPromotionGoodsTotalCount").val(0);
                    newRowContent += "<tr style='height:40px'><td colspan='10' class='txt-center'>" + "조회된 데이터가 없습니다." + "</td></tr>"

                }
                $('#tblPromotionGoods tbody').append(newRowContent);
                $('#divLoading').css('display', 'none');
               

                //fnCreatePagination('promotionGoodsPagination', $("#hdPromotionGoodsTotalCount").val(), pageNum, 50, getPromotionGoodsPageData);
                return false;
            }

            var param = {
                Method: 'GetPromotionGoodsList',
                Target: target,
                Keyword: keyword,
                PageNo: pageNum,
                PageSize: 50,
            };

            var beforeSend = function () {
            };

            var complete = function () {
            };

            JqueryAjax('Post', '../../Handler/Admin/PromotionHandler.ashx', true, false, param, 'json', callback, beforeSend, complete, true, '<%=Svid_User%>');
        }

        

        function getPromotionGoodsPageData() {
            var container = $('#promotionGoodsPagination');
            var getPageNum = container.pagination('getSelectedPageNum');
            fnGetGoodsPromotionList(getPageNum,'');
            return false;
        }

        function fnSetDCYN(val) {
            var returnVal = '';
            if (val == '1') {
                returnVal = '가능';
            }
            else {
                returnVal = '불가능';
            }
            return returnVal;
        }

        
        //전체선택
        function fnSelectAll(el, type) {
            var id = '';
            if (type != 'PopupGoods') {
                id = 'cbSelect';
            }
            else {
                id = 'cbGoodsSelect';
            }

            if ($(el).prop("checked")) {
                $("input[id^=" + id+"]").not(":disabled").prop("checked", true);
            }
            else {
                $("input[id^=" + id +"]").not(":disabled").prop("checked", false);
            }
        }
        var is_sending = false;
        

        function fnMultiPriceSet() {

            if (isEmpty($("#txtPromotioncode").val())) {
                alert('프로모션 코드를 생성해 주세요.');
                return false;
            }

            if (isEmpty($("#hdSelectCode").val())) {
                alert('구매사를 선택해 주세요.');
                return false;
            }

            var selectLength = $('#tblPromotionGoods tbody input[type="checkbox"]:checked').length;
            if (selectLength < 1) {
                alert('상품을 선택해 주세요');
                return false;

            }
            if (isEmpty($('#txtMultiSavePrice').val())) {
                alert('적용값을 입력해 주세요.');
                $('#txtMultiSavePrice').focus();
                return false;
            }

            var categoryCodeArray = '';
            var goodsGroupCodeArray = '';
            var codeArray = '';
            var brandCodeArray = '';
            $('#tblPromotionGoods tbody input[type="checkbox"]').each(function () {
                if ($(this).prop('checked') == true) {
                    var goodsCode = $(this).parent().parent().children().find('#hdGoodsCode').val();
                    var goodsGroupCode = $(this).parent().parent().children().find('#hdGroupCode').val();
                    var categoryCode = $(this).parent().parent().children().find('#hdCategoryCode').val();
                    var brandCode = $(this).parent().parent().children().find('#hdBrandCode').val();
                    var price = $(this).parent().parent().children().find('#txtPrice').val().replace(/[^0-9 | ^.]/g, '');
                    categoryCodeArray += categoryCode + '/';
                    goodsGroupCodeArray += goodsGroupCode + '/';
                    codeArray += goodsCode + '/';
                    brandCodeArray += brandCode + '/';
                }
            });

            var promotionCount = fnPromotionDuplCheck(codeArray.slice(0, -1), $("#hdSelectCode").val(), $('#txtPromotionEnd').val());
            if (parseInt(promotionCount) > 0) {
                alert('이미 프로모션 적용된 상품입니다. \n상단 코드를 선택해서 상품 프로모션 정보를 수정해 주세요.');
                return false;
            }

            if (!confirm('적용하시겠습니까?')) {
                return false;
            }
            var callback = function (response) {
                if (response == 'Success') {
                    alert('적용되었습니다.');
                    fnGetPromotionList(1);
                    fnGetGoodsPromotionList(1, $('#txtPromotioncode').val());
                }
                else {
                    alert('시스템 오류입니다. 관리자에게 문의하세요.');
                }
                return false;
            };

            
            var param = {
                Method: 'MultiSavePromotion',
                SvidUser: '<%= Svid_User%>',
                PromotionCode: $('#txtPromotioncode').val(),
                StartDate: $('#txtPromotionStart').val(),
                EndDate: $('#txtPromotionEnd').val(),
                CompCode: $("#hdSelectCode").val(),
                DcType: 'B',
                DayGubun: '1111111',
                Etc1: '',
                Etc2: '',
                SocialCompCode: '',
                DelFlag: 'N',
                GoodsRole: $('#txtPromotioncode').val().replace('PMC', 'GR'),
                GoodsRoleName: '기본',
                GoodsRoleType: '3',
                CtgrCodes: categoryCodeArray.slice(0, -1),
                GroupCodes: goodsGroupCodeArray.slice(0, -1),
                GoodsCodes: codeArray.slice(0, -1),
                BrandCodes: brandCodeArray.slice(0, -1),
                Type: '',
                Format: '',
                Unit: $('#selectUnit').val(),
                Sign: $('#selectGubun').val(),
                Price: $('#txtMultiSavePrice').val(),
            };

            var beforeSend = function () {
                is_sending = true;
            }
            var complete = function () {
                is_sending = false;
            }

            if (is_sending) return false;
            JajaxDuplicationCheck('Post', '../../Handler/Admin/PromotionHandler.ashx', param, 'text', callback, beforeSend, complete, true, '<%=Svid_User%>');

            return false;
        }


        function fnPriceSet() {

            if (isEmpty($("#txtPromotioncode").val())) {
                alert('프로모션 코드를 생성해 주세요.');
                return false;
            }

            if (isEmpty($("#hdSelectCode").val())) {
                alert('구매사를 선택해 주세요.');
                return false;
            }

            var selectLength = $('#tblPromotionGoods tbody input[type="checkbox"]:checked').length;
            if (selectLength < 1) {
                alert('상품을 선택해 주세요');
                return false;

            }

            var nullFlag = true;

            $('#tblPromotionGoods tbody input[type="checkbox"]').each(function () {
                if ($(this).prop('checked') == true) {

                    var price = $(this).parent().parent().children().find('input[id*="txtPrice"]').val();
                    if (isEmpty(price)) {
                        nullFlag = false;
                    }
                }
            });

            if (nullFlag == false) {
                alert('체크된 판매가격은 필수 입력입니다.');
                return false;
            }

            var categoryCodeArray = '';
            var goodsGroupCodeArray = '';
            var codeArray = '';
            var brandCodeArray = '';
            var priceArray = '';
            $('#tblPromotionGoods tbody input[type="checkbox"]').each(function () {
                if ($(this).prop('checked') == true) {
                    var goodsCode = $(this).parent().parent().children().find('#hdGoodsCode').val();
                    var goodsGroupCode = $(this).parent().parent().children().find('#hdGroupCode').val();
                    var categoryCode = $(this).parent().parent().children().find('#hdCategoryCode').val();
                    var brandCode = $(this).parent().parent().children().find('#hdBrandCode').val();
                    var price = $(this).parent().parent().children().find('#txtPrice').val().replace(/[^0-9 | ^.]/g, '');
                    categoryCodeArray += categoryCode + '/';
                    goodsGroupCodeArray += goodsGroupCode + '/';
                    codeArray += goodsCode + '/';
                    brandCodeArray += brandCode + '/';
                    priceArray += price + '/';
                }
            });

            var promotionCount = fnPromotionDuplCheck(codeArray.slice(0, -1), $("#hdSelectCode").val(), $('#txtPromotionEnd').val(), $('#txtPromotioncode').val());
            if (parseInt(promotionCount) > 0) {
                alert('이미 프로모션 적용된 상품입니다. \n상단 코드를 선택해서 상품 프로모션 정보를 수정해 주세요.');
                return false;
            }

            if (!confirm('적용하시겠습니까?')) {
                return false;
            }
            var callback = function (response) {
                if (response == 'Success') {
                    alert('적용되었습니다.');
                    fnGetPromotionList(1);
                    fnGetGoodsPromotionList(1, $('#txtPromotioncode').val());
                }
                else {
                    alert('시스템 오류입니다. 관리자에게 문의하세요.');
                }
                return false;
            };

            
            var param = {
                Method: 'SavePromotion',
                SvidUser: '<%= Svid_User%>',
                PromotionCode: $('#txtPromotioncode').val(),
                StartDate: $('#txtPromotionStart').val(),
                EndDate: $('#txtPromotionEnd').val(),
                CompCode: $("#hdSelectCode").val(),
                DcType: 'B',
                DayGubun: '1111111',
                Etc1: '',
                Etc2: '',
                SocialCompCode: '',
                DelFlag: 'N',
                GoodsRole: $('#txtPromotioncode').val().replace('PMC','GR'),
                GoodsRoleName: '기본',
                GoodsRoleType: '3',
                CtgrCodes: categoryCodeArray.slice(0, -1),
                GroupCodes: goodsGroupCodeArray.slice(0, -1),
                GoodsCodes: codeArray.slice(0, -1),
                BrandCodes: brandCodeArray.slice(0, -1),
                Prices: priceArray.slice(0, -1),
                Type: '',
                Format: '',
            };
           
            var beforeSend = function () {
                is_sending = true;
            }
            var complete = function () {
                is_sending = false;
            }

            if (is_sending) return false;
            JajaxDuplicationCheck('Post', '../../Handler/Admin/PromotionHandler.ashx', param, 'text', callback, beforeSend, complete, true, '<%=Svid_User%>');

            return false;
        }

        function fnPromotionDuplCheck(codeArray, comcode, enddate, promotionCode) {

            var returnVal = 0;
            var callback = function (response) {
                if (!isEmpty(response)) {
                   
                    returnVal = response;
                }
               
            };

           
            var param = {
                Method: 'DuplCheck',
                GoodsCodes: codeArray,
                CompCode: comcode,
                EndDate: enddate,
                PromotionCode: promotionCode
            };

            var beforeSend = function () {
            };

            var complete = function () {
            };

            JqueryAjax('Post', '../../Handler/Admin/PromotionHandler.ashx', false, false, param, 'text', callback, beforeSend, complete, true, '<%=Svid_User%>');
            return returnVal;
        }

        function fnPromotionDelete(promotionCode) {

            if (!confirm('중지하시겠습니까?')) {
                return false;
            }
            var callback = function (response) {
                if (response == 'Success') {
                    alert('중지되었습니다.');
                    fnGetPromotionList(1);
                    fnDisplayPromotionSetView();
                }
                else {
                    alert('시스템 오류입니다. 관리자에게 문의하세요.');
                }
                return false;
            };

            var param = {
                Method: 'DeletePromotion',
                SvidUser: '<%= Svid_User%>',
                PromotionCode: promotionCode,
            };

            var beforeSend = function () {
                is_sending = true;
            }
            var complete = function () {
                is_sending = false;
            }

            if (is_sending) return false;
            JajaxDuplicationCheck('Post', '../../Handler/Admin/PromotionHandler.ashx', param, 'text', callback, beforeSend, complete, true, '<%=Svid_User%>');

            return false;
        }
        //RealTime Comma찍기
        function fnAutoComma(el) {
            //var price = $(el).val();
            
            //price = price.replace(/[^\d]+/g, ''); // (,)지우기          
            //$(el).val(numberWithCommas(price));   //콤마설정

            //$(el).parent().parent().children().find("input[id^=cbSelect]").not(":disabled").prop("checked", true); //자동 체크박스 선택
            if ($(el).parent().find('#divVatPrice').is(':empty') == true) {
                $(el).parent().find('#divVatPrice').append("<img src='/Images/tax_icon.png' width='20' height='20'/><label style='color:red' id='lblPriceVAT'/><label style='color:red'>원</label>");
            }
            var price = $(el).val();

            price = price.replace(/[^\d]+/g, ''); // (,)지우기          

            var txtpriceVat = price * 1.1; //매입가격(VAT포함)         
            txtpriceVat = roundXL(txtpriceVat, -1);
            $(el).val(numberWithCommas(price));   //콤마설정
            $(el).parent().children().find('#lblPriceVAT').text(numberWithCommas(txtpriceVat));   //콤마설정
            $(el).parent().parent().children().find("input[id^=cbSelect]").not(":disabled").prop("checked", true); //자동 체크박스 선택
        }

        function roundXL(num, digits) {
            digits = Math.pow(10, digits);
            return Math.round(num * digits) / digits;
        };

        //-------------------------------상품조회 팝업 시작 ---------------------------------------------//
        //상품조회  팝업
        function fnOpenGoodsPopup() {

            var keyword = $('#<%= txtGoodsSearch.ClientID%>').val();
            if (keyword == '') {
                alert('상품 관련 검색어를 입력하세요.');
                return false;
            }
            $('#selectPopupGoodsTarget').val($('#selectGoodsSearchKeyword').val()); 
            $('#txtPopSearchGoods').val($('#<%= txtGoodsSearch.ClientID%>').val());
            $("#tblPopupGoods_Tbody").empty(); //데이터 클리어
            $('#popupGoodsPagination').css('display', 'none');
            $('#selectAllGoods').prop('checked', false)
            fnGoodsDataBind(1);
            fnOpenDivLayerPopup('goodsListPopupdiv');
            

            return false;
        }

        function fnGoodsSearchEnter() {
            if (event.keyCode == 13) {
                fnOpenGoodsPopup();
                return false;
            }
        }

        function fnPopupGoodsSearchEnter() {
            if (event.keyCode == 13) {
                fnGoodsDataBind(1);
                return false;
            }
            else
                return true;

        }

        function fnCompSearchEnter() {

            if (event.keyCode == 13) {
                fnSearchPopup();
                return false;
            }
            else
                return true;

        }

        //상품 데이터 바인딩
        function fnGoodsDataBind(pageNo) {

           
            var callback = function (response) {
                var returnVal = false;
                if (!isEmpty(response)) {
                    $("#tblPopupGoods_Tbody").empty(); //데이터 클리어
                    var listTag = "";

                    $.each(response, function (key, value) {
                        $('#popupGoodsPagination').css('display', 'inline-block');
                        $('#hdPopupGoodsTotalCount').val(value.TotalCount);
                        listTag += "<tr>"
                            + "<td class='txt-center'><input type='checkbox' id='cbGoodsSelect'></td>"
                            + "<td class='txt-center'><input type='hidden' id='hdPopupGoodsCode' value='" + value.GoodsCode + "' /><input type='hidden' id='hdPopupGoodsName' value='" + value.GoodsFinalName + "' />" + value.GoodsCode + "</td>"
                            + "<td class='txt-center'>" + value.GoodsFinalName + "</td>"
                            + "</tr>";
                    });

                    $("#tblPopupGoods_Tbody").append(listTag);
                    fnCreatePagination('popupGoodsPagination', $("#hdPopupGoodsTotalCount").val(), pageNo, 20, getGoodsPopupPageData);

                } else {
                    var emptyTag = "<tr><td colspan='3' class='txt-center'>조회된 데이터가 없습니다.</td></tr>";

                    $("#tblPopupGoods_Tbody").append(emptyTag);
                }

                return false;
            };
            var sUser = '<%=Svid_User %>';
            var param = {
                Target: $('#selectPopupGoodsTarget').val(),
                Keyword: $('#txtPopSearchGoods').val(),
                PageNo: pageNo,
                PageSize: 20,
                Method: 'GetGoodsSearchList'
            };

            JajaxSessionCheck('Post', '../../Handler/GoodsHandler.ashx', param, 'json', callback, '<%=Svid_User %>');
        }

        //페이징 인덱스 클릭시 상품데이터 바인딩
        function getGoodsPopupPageData() {
            var container = $('#popupGoodsPagination');
            var getPageNum = container.pagination('getSelectedPageNum');
            fnGoodsDataBind(getPageNum);
            return false;
        }

        //상품 확인클릭
        function fnPopupOkGoods() {

            Array.prototype.contains = function (element) {
                    for (var i = 0; i < this.length; i++) {
                        if (this[i] == element) {
                            return true;
                        }
                    }
                    return false;
            }

            var callback = function (response) {
                $('#tblPromotionGoods tbody').find('#trEmptyRow').remove(); //테이블 클리어
                var rowCnt = $("#tblPromotionGoods tbody tr").length;
             
                if (rowCnt > 100) {
                    alert('상품은 100개까지 등록 가능합니다.');
                    return false;
                }

                

                var newRowContent = "";
                
                if (!isEmpty(response)) {
                    var curCodesArray = new Array();
                    $('#tblPromotionGoods tbody > tr').each(function () {
                        curCodesArray.push($(this).children().find('#hdGoodsCode').val());
                    });

                    $.each(response, function (key, value) { //테이블 추가

                        if (curCodesArray.contains(value.GoodsCode) == false) {
                            var disableStyle = '';
                            if (value.GoodsDcYN == '2') {
                                disableStyle = 'disabled';
                            }
                            newRowContent += "<tr style='height:40px'>";
                            newRowContent += "<td class='txt-center'><input type='checkbox' id='cbSelect' " + disableStyle + "/><br/><input type='button' class='listBtn' id='imgRowDelete' style='width:50px; height:22px; font-size:12px' value='삭제' onclick='fnRowDelete(this)' style='cursor:pointer'>";
                            newRowContent += "<input type='hidden' id='hdCategoryCode' value='" + value.GoodsFinalCategoryCode + "'/>";
                            newRowContent += "<input type='hidden' id='hdGroupCode' value='" + value.GoodsGroupCode + "'/>";
                            newRowContent += "<input type='hidden' id='hdGoodsCode' value='" + value.GoodsCode + "'/>";
                            newRowContent += "<input type='hidden' id='hdBrandCode' value='" + value.BrandCode + "'/>";
                            newRowContent += "<input type='hidden' id='hdBuyPriceVat' value='" + value.GoodsBuyPriceVat + "'/>";
                            newRowContent += "</td>"; //선택
                            newRowContent += "<td style='text-align:left'>" + value.GoodsCode + "<br/>" + value.GoodsFinalName + "(" + value.GoodsModel + ")<br/>*" + value.BrandName + "<br/>" + value.GoodsOptionSummaryValue + "</td>";  //상품정보
                            newRowContent += "<td class='txt-center'>" + value.GoodsUnitName + "</td>";  //내용량
                            newRowContent += "<td class='txt-center'>" + value.GoodsGroupCode + "</td>";  //그룹코드
                           
                            newRowContent += "<td class='txt-center' style='background-color:#E8FFFF'>" + numberWithCommas(value.GoodsSalePrice) + "원<br/>";  //구매사 판매가격
                            newRowContent += "<div id='divVatPrice' style='float:left; height:20px; padding-left:15px'><img src='/Images/tax_icon.png' width='20' height='20'/><label style='color:red' id='lblPriceVAT'>" + numberWithCommas(value.GoodsSalePriceVat) + "</label><label style='color:red'>원</label></div></td>"; 
                            newRowContent += "<td class='txt-center'>" + fnSetDCYN(value.GoodsDcYN) + "</td>";  //가격변동
                            newRowContent += "<td class='txt-center' style='background-color:#FFEBFF'>" + value.UrianYield + "%</td>";  //소셜위드수익률
                            newRowContent += "<td class='txt-center' style='background-color:#FFEBFF'>" + value.SaleCompYield + "%</td>";  //판매사수익률
                            newRowContent += "<td class='txt-center' style='background-color:#FFEBFF'>" + value.BuyCompYield + "%</td>";  //구매사수익률
                            newRowContent += "<td class='txt-center' style='background-color:#E8FFFF'><input type='text' id='txtPrice' style='width:80%;'  " + disableStyle + " onkeyup='return fnAutoComma(this);' onkeypress='return onlyNumbers(event);'>원<div id='divVatPrice' style='float:left; height:20px'></div></td>";  //구매사 판매가격입력
                            newRowContent += "</tr>";
                        } //중복제거
                        
                    });
                } else {
                    newRowContent += "<tr style='height:40px'><td colspan='10' class='txt-center'>" + "조회된 데이터가 없습니다." + "</td></tr>"

                }
                $('#tblPromotionGoods tbody').append(newRowContent);
                fnClosePopup('goodsListPopupdiv');
                return false;
            }

           

            var codeArray = '';
            $('#tblPopupGoods tbody input[type="checkbox"]').each(function () {
                if ($(this).prop('checked') == true) {
                    var goodsCode = $(this).parent().parent().children().find('#hdPopupGoodsCode').val();
                    codeArray += goodsCode + ',';
                  
                }
            });

            var param = {
                Method: 'GetPromotionAddGoodsList',
                GoodsCodes: codeArray.slice(0, -1)
            };

            var beforeSend = function () {
            };

            var complete = function () {
            };

            JqueryAjax('Post', '../../Handler/Admin/PromotionHandler.ashx', true, false, param, 'json', callback, beforeSend, complete, true, '<%=Svid_User%>');
            return false;
        }

        

        function fnRowDelete(el) {

            $(el).parent().parent().remove();
            var rowCnt = $("#tblPromotionGoods tbody tr").length;
            if (rowCnt == 0) {
                $('#tblPromotionGoods tbody').append("<tr style='height:30px' id='trEmptyRow'><td colspan='10' class='txt-center'>" + "조회된 데이터가 없습니다." + "</td></tr>");
            }
            return false;
        }
</script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <div class="sub-contents-div" >
         <div class="sub-title-div">
                <p class="p-title-mainsentence">
                    프로모션 관리(기본)
                    <span class="span-title-subsentence"></span>
                </p>
            </div>
         <div class="bottom-search-div" style="margin-bottom: 20px">
               <table class="tbl_search" style="margin-top: 30px; margin-bottom: 30px;">
                   <colgroup>
                       <col style="width:90px;"/>
                       <col />
                       <col />
                   </colgroup>
                        <tr>
                            <td></td>
                            <td>
                                <select id="selectPromotionSearchKeyword" style="width:200px;">
                                    <option value="BuyComp">구매사</option>
                                    <%--<option value="PromotionCode">프로모션코드</option>--%>
                                </select>
                                <asp:TextBox runat="server" placeholder="검색어를 입력하세요." Style="width: 600px" ID="txtCompSearch" OnKeyPress="return fnCompSearchEnter();"></asp:TextBox>
                                <asp:Button runat="server" Text="검색" CssClass="mainbtn type1" ID="btnGoodsSearch"  Width="75" Height="25" OnClientClick="return fnSearchPopup();"/>
                            </td>
                        </tr>
                    </table>
                </div>
                 <div class="saleComp-search">
                 <table id="tblPromotion" class="tbl_main" style="margin-top: 0;">
                     <thead>
                       
                           <tr class="board-tr-height">
                                <th class="txt-center" style="width:80px">구분</th>
                                <th class="txt-center" style="width:120px">프로모션코드</th>
                                <th class="txt-center" style="width:90px">구매사코드</th>
                                <th class="txt-center" style="width:auto">구매사명</th>
                                <th class="txt-center" style="width:90px">대표자명</th>
                                <th class="txt-center" style="width:120px">프로모션 시작일</th>
                                <th class="txt-center" style="width:120px">프로모션 종료일</th>
                                <th class="txt-center" style="width:120px">프로모션 수정일</th>
                                <th class="txt-center" style="width:120px">프로모션 수정자</th>
                                <th class="txt-center" style="width:120px">소셜위드 담당자</th>
                                <th class="txt-center" style="width:120px">중지</th>
                            </tr>
                           </thead>
                     <tbody>
                            <tr class="board-tr-height">
                                <td class="txt-center" colspan="11">
                                    조회된 데이터가 없습니다.
                                </td>
                            </tr>
                         </tbody>
                </table>
                    <!-- 페이징 처리 -->
                <div style="margin: 0 auto; text-align: center; padding-top: 10px; padding-bottom: 10px">
                    <input type="hidden" id="hdPromtionTotalCount" />
                    <div id="promotionPagination" class="page_curl" style="display: inline-block"></div>
                </div>
            </div>
            <div style="width:100%">
                <input type="button" id="imgCreatePromotion" class="mainbtn type1" style="width:200px; height:30px; font-size:12px; display:none" value="선택된 구매사 프로모션 생성" onclick="fnDisplayPromotionSetView(); return false;"/>
               &nbsp;&nbsp; <span id="spanSelectCompInfo" style="color:red; font-weight:bold">선택된 구매사가 없습니다.</span>
            </div>
            <br />
            <div style="width:100%; display:none" id="divSetPromotion" >
                <div style="display:inline-block; width:50%">
                    <table class="tbl_main">
                        <tr>
                            <th>
                                프로모션 기간
                            </th>
                            <td>
                                <input type="text" id="txtPromotionStart"/> ~ <input type="text" id="txtPromotionEnd"/>
                            </td>
                        </tr>
                        <tr>
                            <th>
                                개별 프로모션코드
                            </th>
                            <td>
                                <input type="text" id="txtPromotioncode"/>&nbsp;
                                <input type="button" class="mainbtn type1" style="width:95px; height:26px; font-size:12px" value="코드생성" onclick="fnCreatePromotionCode();"/>
                                <%--<img id="imgCreatePromotionCode" src="../Images/Member/createcode-off.jpg" onmouseover="this.src='../Images/Member/createcode-on.jpg'" onmouseout="this.src='../Images/Member/createcode-off.jpg'" alt="자동생성" style="display:none; cursor:pointer" onclick="fnCreatePromotionCode();"/>--%>
                            </td>
                        </tr>
                        <tr id="trSearchRow" style="display:none">
                            <td style="text-align:center">
                                <select id="selectGoodsSearchKeyword" style="width:150px">
                                    <option value="GoodsName">상품명</option>
                                    <option value="GoodsCode">상품코드</option>
                                    
                                </select>
                             
                            </td>
                            <td style="text-align:left">
                                    <asp:TextBox runat="server" placeholder="검색어를 입력하세요." Style="width: 250px" ID="txtGoodsSearch" onkeypress="return fnGoodsSearchEnter();"></asp:TextBox>
                                    <input type="button" class="mainbtn type1" style="width:95px; height:26px; font-size:12px" value="상품검색" onclick="fnOpenGoodsPopup(); return false;"/>
                                    <%--<asp:Button runat="server" CssClass="notice-search-btn" ID="imgBtnGoodsSearch"  style="vertical-align:middle; " OnClientClick="fnOpenGoodsPopup(); return false;"/>--%>
                             </td>
                        </tr>
                    </table>
                </div>
                
               <%-- <div style="display:inline-block; width:50%">
                     <table class="fileTbl" >
                        <tr>
                            <th style="width:100px">엑셀파일 등록</th>
                            <td><asp:FileUpload runat="server" ID="fuExcel" Width="200px"/></td>
                            <td style="border-right:none; padding-left:13px"><asp:ImageButton ID="ibtnExcelUpload" AlternateText="엑셀업로드" runat="server" ImageUrl="../Images/Goods/upload-off.jpg" onmouseover="this.src='../Images/Goods/upload-on.jpg'" onmouseout="this.src='../Images/Goods/upload-off.jpg'"  CssClass="upLoad" /></td>
                            <td style="border-left:none;"><asp:ImageButton ID="ibtnExcelFormDownload" AlternateText="엑셀업로드폼 다운로드" runat="server" ImageUrl="../Images/Goods/formSave-off.jpg" onmouseover="this.src='../Images/Goods/formSave-on.jpg'" onmouseout="this.src='../Images/Goods/formSave-off.jpg'"  CssClass="upLoad"/></td>
                        </tr>
                        </table>
                </div>--%>
               
                <div style="display:inline-block; width:605px; padding-left:20px">
                     <table class="tbl_main">
                         <tr>
                             <th rowspan="2">일괄적용</th>
                             <th>
                                  단위
                             </th>
                             <th>
                                  구분
                             </th>
                             <th>
                                  적용값
                             </th>
                             <td rowspan="2" style="width:100px; text-align:center; ">
                                 <input type="button" class="mainbtn type1" style="width: 95px; height: 30px;" value="적용" onclick="fnMultiPriceSet();" />
                             </td>
                         </tr>
                         <tr>
                             <td style="text-align:center">
                                 <select id="selectUnit" style="width:90%">
                                     <option value="WON">원</option>
                                     <option value="PERCENT">%</option>
                                 </select>
                             </td>
                             <td style="text-align:center">
                                 <select id="selectGubun" style="width:90%">
                                     <option value="P">+</option>
                                     <option value="M">-</option>
                                 </select>
                             </td>
                             <td style="text-align:center">
                                 <input type="text" style="width:90%; border:1px solid #a2a2a2" id="txtMultiSavePrice" onkeypress="return onlyNumbers(event);"/>  
                             </td>
                           <td style="border:1px solid #ffffff; padding-left:30px; ">  
                               <input type="button" class="mainbtn type1" style="width: 95px; height: 30px;" value="저장" onclick="fnPriceSet();" />
                            </td>
                         </tr>
                     </table>
                </div>
               
            </div>
            <!-- 리스트 -->
           <%-- <div class="list-div">--%>
          <div id="divTableList2" style="position: relative;">
                <table id="tblPromotionGoods" class="tbl_main">
                    <thead>
                        <tr>
                            <th style="width:60px">
                                <input type="checkbox" id="selectAll" onclick="fnSelectAll(this,'Promotion');">
                            </th>
                            <th style="width:300px">
                                상품정보
                            </th>
                            <th style="width:120px">
                                내용량
                            </th>
                            <th style="width:80px">
                                그룹코드
                            </th>
                            <th style="width:120px; background-color:#E8FFFF">
                                구매사<br/>판매가격
                            </th>
                            <th style="width:80px">
                               가격<br/>변동
                            </th>
                             <th style="width:100px; background-color:#FFEBFF">
                               소셜위드<br/>수익률
                            </th>
                             <th style="width:100px; background-color:#FFEBFF">
                               판매사<br/>수익률
                            </th>
                             <th style="width:100px; background-color:#FFEBFF">
                               구매사<br/>수익률
                            </th>
                             <th style="width:160px; background-color:#E8FFFF">
                               구매사<br/>판매가격입력
                            </th>
                        </tr>
                        
                    </thead>
                    <tbody>
                        <tr id="trEmptyRow">
                            <td colspan="10" style="text-align:center">조회된 데이터가 없습니다.</td>
                        </tr>
                    </tbody>
                </table>
                <div id="divLoading" style="display: none; position: absolute; top:0; left:0; width:100%; height:100%; background-color:rgba(0,0,0,.65);  margin: 0 auto; ">
                    <img src="../Images/loading.gif" style="width: 130px; height: 130px; position:absolute;  top:20%; left:45%">
                </div>
           </div>
           <%-- </div>--%>
                <%--<br />
              <div style="margin:0 auto; text-align:center; padding-top:10px">
                  <input type="hidden" id="hdPromotionGoodsTotalCount"/>
                  <div id="promotionGoodsPagination" class="page_curl" style="display:inline-block"></div> 
              </div>--%>
            
     </div>

      <%--구매사 업체 코드 팝업--%>
    <div id="buyCompListPopupdiv" class="popupdiv divpopup-layer-package">
        <div class="popupdivWrapper" style="width:650px;">
            <div class="popupdivContents">

                <div class="close-div">
                    <a onclick="fnClosePopup('buyCompListPopupdiv'); return false;" style="cursor: pointer">
                        <img src="../Images/icon-delete.jpg" alt="닫기" style="float: right;" /></a>
                </div>
                <div class="popup-title">
                    <h3 class="pop-title">업체명 조회</h3>              
                    <div class="search-div">
                        <select id="selectCompTarget" style="width:150px;">
                            <option value="COMPNAME" >
                                회사명
                            </option>
                            <option value="COMPCODE" >
                                회사코드
                            </option>
                        </select>
                        <input type="text" class="text-code" id="txtPopSearchComp" placeholder="검색어를 입력하세요" onkeypress="return fnPopCompEnter();" style="width:300px"/>
                        <input type="button" value="검색" style="width:75px" class="mainbtn type1" onclick="fnGetCompanyList(1); return false;">
                      </div>


                    <div class="divpopup-layer-conts">
                        <input type="hidden" id="hdSelectCode"/>
                        <input type="hidden" id="hdSelectName"/>
                        <table id="tblPopupComp" class="tbl_main tbl_pop">
                            <thead>
                                <tr>
                                    <th>구매사코드</th>
                                    <th>구매사명</th>
                                </tr>
                            </thead>
                            <tbody id="tblPopupComp_Tbody">
                                <tr class="board-tr-height">
                                    <td colspan="2" class="text-center">리스트가 없습니다.</td>
                                </tr>
                            </tbody>
                        </table>
                        <!-- 페이징 처리 -->   
                        <div style="margin:0 auto; text-align:center; padding-top:10px">
                            <input type="hidden" id="hdCompTotalCount"/>
                            <div id="compPagination" class="page_curl" style="display:inline-block"></div> 
                        </div>
                    </div>
                    
                    <div class="btn_center">
                        <input type="button" class="mainbtn type1" style="width: 95px; height: 30px;" value="확인" onclick="fnPopupOkComp(); return false;" />
                    </div>

                </div>
            </div>
        </div>
    </div>

     <%--상품 팝업--%>
    <div id="goodsListPopupdiv" class="popupdiv divpopup-layer-package">
        <div class="popupdivWrapper" style="width:650px; height:730px; margin: 30px auto;">
            <div class="popupdivContents">

                <div class="close-div">
                    <a onclick="fnClosePopup('goodsListPopupdiv'); return false;" style="cursor: pointer">
                        <img src="../Images/icon-delete.jpg" alt="닫기" style="float: right;" /></a>
                </div>
                <%--<div class="popup-title" style="margin-top: 20px;">
                    <img src="../Images/Goods/goodsSearch-popuptitle.jpg" alt="상품 조회" /></div>--%>
                  <div class="popup-title">
                            <h3 class="pop-title">상품검색</h3>
                        </div>

                    <div class="search-div" style="margin-bottom: 20px;">
                        <select id="selectPopupGoodsTarget" style="height:30px; width:150px; vertical-align:middle">
                            <option value="GoodsName" >
                                상품명
                            </option>
                            <option value="GoodsCode" >
                                상품코드
                            </option>
                        </select>
                        <input type="text" class="text-code" id="txtPopSearchGoods" placeholder="검색어를 입력하세요" onkeypress="return fnPopupGoodsSearchEnter();" style="width:300px"/>
                        <input type="button" class="mainbtn type1" style="width: 95px; height: 30px;" value="검색" onclick="fnGetCompanyList(1); return false;" />
                    </div>


                    <div class="divpopup-layer-conts">
                        <table id="tblPopupGoods" class="tbl_main tbl_pop" style="margin-top: 0; width: 100%">
                            <thead>
                                <tr>
                                    <th style="width:30px; text-align:center"><input type="checkbox" id="selectAllGoods" onclick="fnSelectAll(this, 'PopupGoods');"></th>
                                    <th class="text-center" style="width:150px">상품코드</th>
                                    <th class="text-center" style="width:auto">상품명</th>
                                </tr>
                            </thead>
                            <tbody id="tblPopupGoods_Tbody">
                                <tr class="board-tr-height">
                                    <td colspan="3" class="text-center">리스트가 없습니다.</td>
                                </tr>
                            </tbody>
                        </table>
                        <!-- 페이징 처리 -->   
                        <div style="margin:0 auto; text-align:center; padding-top:10px">
                            <input type="hidden" id="hdPopupGoodsTotalCount"/>
                            <div id="popupGoodsPagination" class="page_curl" style="display:inline-block"></div> 
                        </div>
                    </div>
                    
                    <div style="text-align: right;">

                        <input type="button" class="mainbtn type1" style="width: 95px; height: 30px;" value="확인" onclick="fnPopupOkGoods(); return false;" />
                        
                    </div>

                </div>
            </div>
        </div>
</asp:Content>

