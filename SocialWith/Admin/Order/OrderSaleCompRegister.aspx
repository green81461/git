<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Master/AdminMasterPage.master" AutoEventWireup="true" CodeFile="OrderSaleCompRegister.aspx.cs" Inherits="Admin_Order_OrderSaleCompRegister" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <link href="../Content/order/order.css" rel="stylesheet" />
    <link href="../Content/Goods/goods.css" rel="stylesheet" />

    <script type="text/javascript">

        $(document).ready(function () {
            var tableid = "tblHeader";
            ListCheckboxOnlyOne(tableid);

            var tableid = "tblSaleComp";
            ListCheckboxOnlyOne(tableid);

            fnOrderAreaCodeList($("#txtBelongCode").val()); //주문지역 selectbox 바인딩

            $("#ddlAreaCode").on("change", function () {
                $("#spAreaNm").text($(this).val());
            });
        });

        //주문지역 selectbox 바인딩
        function fnOrderAreaCodeList() {

            var callback = function (response) {
                var createHtml = '';
                for (var i = 0; i < response.length; i++) {

                    if (response[i].Map_Type != 0) {
                        createHtml += '<option value="' + response[i].Map_Name + '">' + "0" + response[i].Map_Type + '</option>';
                    }
                }
                $("#ddlAreaCode").append(createHtml);

                $("#spAreaNm").text($("#ddlAreaCode option:first").val());

                return false;
            }

            var param = {
                Method: 'GetCommList',
                Code: 'ORDER',
                Channel: 3
            };

            JajaxSessionCheck('Post', '../../Handler/Common/CommHandler.ashx', param, 'json', callback, '<%=Svid_User%>');
        }

        ///////////////// 주문 소속 팝업 영역 //////////////////

        //주문 소속 목록 조회
        function fnGetOrderBelongList(keyword) {
            var callback = function (response) {
                $('#tblHeader tbody').empty(); //테이블 클리어
                var newRowContent = "";

                if (!isEmpty(response)) {

                    $.each(response, function (key, value) { //테이블 추가
                        newRowContent += "<tr>";
                        newRowContent += "<td style='width: 50px' class='txt-center'><input type='checkbox' id='cbSelect'/></td>";  //선택          
                        newRowContent += "<td id='Belong_Name" + key + "' style='width: 100px' class='txt-center'>" + value.OrderBelongName + "</td>"; //소속명         
                        newRowContent += "<td id='Belong_Code" + key + "' style='width: 100px' class='txt-center'>" + value.OrderBelongCode + "</td> </tr>"; //소속코드
                    });
                } else {
                    newRowContent += "<tr><td colspan='3' class='txt-center'>" + "조회된 데이터가 없습니다." + "</td></tr>"
                }
                $('#tblHeader tbody').append(newRowContent);

                return false;
            }

            var param = {
                Method: 'OrderBelongPopupList',
                SearchKeyword: keyword
            };

            JajaxSessionCheck('Post', '../../Handler/OrderHandler.ashx', param, 'json', callback, '<%=Svid_User%>');
        }

        //주문 소속 팝업
        function fnSearchBelongPopup() {
            $("#txtPopSearchBelong").val('');
            fnGetOrderBelongList('');
            fnOpenDivLayerPopup('orderBelongCodediv');
            

            return false;
        }

        function fnPopBelongEnter() {
            if (event.keyCode == 13) {
                fnGetOrderBelongList($("#txtPopSearchBelong").val());
                return false;
            }
            else
                return true;
        }

        function fnPopupOkBelong() {
            var isCheck = false;
            $('#tblHeader tbody tr').each(function (index, element) {
                if ($(this).find("input[type = checkbox]").prop('checked') == true) {
                    var name = $(this).find("td[id^='Belong_Name']").text();
                    var code = $(this).find("td[id^='Belong_Code']").text();
                    $("#txtBelongCode").val(code);
                    $("#spBelongNm").text(name);
                    isCheck = true;
                }
            });

            if (!isCheck) {
                alert("주문 소속을 선택해 주세요.");
                return false;
            }

            fnClosePopup('orderBelongCodediv');
        }

        ///////////////// 주문 업체 팝업 영역 //////////////////

        //주문 업체 목록 조회
        function fnGetCompanyList_A(pageNum) {

            var keyword = $("#txtPopSearchSaleComp").val();
            var pageSize = 15;

            var callback = function (response) {
                $('#tblSaleComp tbody').empty(); //테이블 클리어
                var newRowContent = "";

                if (!isEmpty(response)) {

                    $.each(response, function (key, value) { //테이블 추가
                        if (key == 0) $("#hdTotalCount").val(value.TotalCount);

                        newRowContent += "<tr>";
                        newRowContent += "<td style='width: 50px' class='txt-center'><input type='checkbox' id='cbSelect'/>";
                        newRowContent += "<input type='hidden' name='hdCompNo' value='" + value.Company_No + "'";
                        newRowContent += "</td > ";  //선택
                        newRowContent += "<td id='SaleComp_Name" + key + "' style='width: 100px' class='txt-center'>" + value.Company_Name + "</td>"; //회사명
                        newRowContent += "<td id='SaleComp_Code" + key + "' style='width: 100px' class='txt-center'>" + value.Company_Code + "</td> </tr>"; //회사코드
                    });
                } else {
                    newRowContent += "<tr><td colspan='3' class='txt-center'>" + "조회된 데이터가 없습니다." + "</td></tr>"
                    $("#hdTotalCount").val(0);
                }
                $('#tblSaleComp tbody').append(newRowContent);

                fnCreatePagination('pagination', $("#hdTotalCount").val(), pageNum, pageSize, getPageData);

                return false;
            }

            var param = {
                Flag: 'CompList_A',
                CompNm: keyword,
                PageNo: pageNum,
                PageSize: pageSize,
            };

            JajaxSessionCheck('Post', '../../Handler/Admin/CompanyHandler.ashx', param, 'json', callback, '<%=Svid_User%>');
        }
        function getPageData() {
            var container = $('#pagination');
            var getPageNum = container.pagination('getSelectedPageNum');
            fnGetCompanyList_A(getPageNum);
            return false;
        }

        //주문 업체 팝업
        function fnSearchSaleCompPopup() {
            $("#txtPopSearchSaleComp").val('');
            fnGetCompanyList_A(1);
            fnOpenDivLayerPopup('orderSaleCodediv');
         

            return false;
        }

        function fnPopupOkSaleComp() {
            var isCheck = false;
            $('#tblSaleComp tbody tr').each(function (index, element) {
                if ($(this).find("input[type = checkbox]").prop('checked') == true) {
                    var name = $(this).find("td[id^='SaleComp_Name']").text();
                    var code = $(this).find("td[id^='SaleComp_Code']").text();
                    var compNo = $(this).find("input:hidden[name^='hdCompNo']").val();

                    $("#txtCompCode").val(code);
                    $("#spCompNm").text(name);
                    $("#spCompNo").text("(" + compNo + ")");
                    $("#hdSaleCompNo").val(compNo);
                    $("#hdSaleCompNm").val(name);

                    isCheck = true;
                }
            });

            if (!isCheck) {
                alert("주문 업체를 선택해 주세요.");
                return false;
            }

            fnClosePopup('orderSaleCodediv');
        }

        function fnPopSaleCompEnter() {
            if (event.keyCode == 13) {
                fnGetCompanyList_A(1);
                return false;
            }
            else
                return true;
        }

        ///////////////// 사업자 구분 팝업 영역 //////////////////

        //사업자 구분 목록 조회
        function fnGetSocialCompList(pageNum) {

            var keyword = $("#txtPopSearchSocialComp").val();
            var pageSize = 15;

            var callback = function (response) {
                $('#tblSocialComp tbody').empty(); //테이블 클리어
                var newRowContent = "";

                if (!isEmpty(response)) {

                    $.each(response, function (key, value) { //테이블 추가
                        if (key == 0) $("#hdTotalCount_3").val(value.TotalCount);

                        newRowContent += "<tr>";
                        newRowContent += "<td style='width: 50px' class='txt-center'><input type='checkbox' id='cbSelect'/></td>";  //선택
                        newRowContent += "<td id='SocialComp_Name" + key + "' style='width: 100px' class='txt-center'>" + value.SocialCompany_Name + "</td>"; //회사명
                        newRowContent += "<td id='SocialComp_Code" + key + "' style='width: 100px' class='txt-center'>" + value.SocialCompany_Code + "</td> </tr>"; //회사코드
                    });
                } else {
                    newRowContent += "<tr><td colspan='3' class='txt-center'>" + "조회된 데이터가 없습니다." + "</td></tr>"
                    $("#hdTotalCount_3").val(0);
                }
                $('#tblSocialComp tbody').append(newRowContent);

                fnCreatePagination('pagination_3', $("#hdTotalCount_3").val(), pageNum, pageSize, getPageData2);

                return false;
            }

            var param = {
                Method: 'SearchSocialComp',
                SocialCompNm: keyword,
                Gubun: 'SU',
                PageNo: pageNum,
                PageSize: pageSize,
            };

            JajaxSessionCheck('Post', '../../Handler/Admin/SocialCompanyHandler.ashx', param, 'json', callback, '<%=Svid_User%>');
        }
        function getPageData2() {
            var container = $('#pagination_3');
            var getPageNum = container.pagination('getSelectedPageNum');
            fnGetSocialCompList(getPageNum);
            return false;
        }

        //사업자 구분 팝업
        function fnSearchSocialCompPopup() {
            $("#txtPopSearchSocialComp").val('');
            fnGetSocialCompList(1);
            fnOpenDivLayerPopup('socialCompCodediv');
           

            return false;
        }

        function fnPopupOkSocialComp() {
            var isCheck = false;
            $('#tblSocialComp tbody tr').each(function (index, element) {
                if ($(this).find("input[type = checkbox]").prop('checked') == true) {
                    var name = $(this).find("td[id^='SocialComp_Name']").text();
                    var code = $(this).find("td[id^='SocialComp_Code']").text();
                    $("#txtSocialCompCode").val(code);
                    $("#spSocialCompNm").text(name);
                    isCheck = true;
                }
            });

            if (!isCheck) {
                alert("사업자 구분을 선택해 주세요.");
                return false;
            }

          
            fnClosePopup('socialCompCodediv');
        }

        function fnPopSocialCompEnter() {
            if (event.keyCode == 13) {
                fnGetSocialCompList(1);
                return false;
            }
            else
                return true;
        }

     

        //유효성 검사
        function fnValidate() {

            if (isEmpty($("#txtBelongCode").val())) {
                alert("주문 소속 코드를 선택해 주세요.");
                return false;
            }
            if (isEmpty($("#ddlAreaCode").val())) {
                alert("주문 지역 코드를 선택해 주세요.");
                return false;
            }
            if (isEmpty($("#txtCompCode").val())) {
                alert("주문 업체 코드를 선택해 주세요.");
                return false;
            }
            if (isEmpty($("#txtSocialCompCode").val())) {
                alert("사업자 구분을 선택해 주세요.");
                return false;
            }
            var confirmVal = confirm("정말로 등록하시겠습니까?");
            if (!confirmVal) {
                return false;
            }

            return true;
        }

        //등록 버튼 클릭 시
        function fnSaveOrdSaleComp() {
            if (fnValidate()) {

                var callback = function (response) {

                    if (!isEmpty(response)) {
                        if (response === "OK") {
                            alert("성공적으로 등록되었습니다.");
                            location.href = "OrderSaleCompList.aspx";

                        } else if (response === "SAME") {
                            alert("중복된 코드이므로 등록할 수 없습니다.");

                        } else {
                            alert("오류가 발생했습니다. 개발자에게 문의해 주시기 바랍니다.");
                        }

                    } else {
                        alert("오류가 발생했습니다. 개발자에게 문의해 주시기 바랍니다.");
                    }

                    return false;
                }

                var param = {
                    Flag: 'SaveOrdSaleComp',
                    BelongCode: $("#txtBelongCode").val(),
                    AreaCode: $("#ddlAreaCode option:selected").text(),
                    SaleCompCode: $("#txtCompCode").val(),
                    SaleCompNm: $("#hdSaleCompNm").val(),
                    SaleCompNo: $("#hdSaleCompNo").val(),
                    UniqueNo: '',
                    Gubun: $("#txtSocialCompCode").val(),
                    Remark: $("#txtaRemark").val()
                };

                JajaxSessionCheck('Post', '../../Handler/Admin/CompanyHandler.ashx', param, 'text', callback, '<%=Svid_User%>');
            }
        }
        //페이지 이동
        function fnGoPage(pageVal) {
            switch (pageVal) {
                case "OHL":
                    window.location.href = "../Order/OrderHistoryList";
                    break;
                case "DL":
                    window.location.href = "../Order/DeliveryOrderList";
                    break;
                case "PG":
                    window.location.href = "../Member/Pg_Main";
                    break;
                case "LOAN":
                    window.location.href = "../Member/Loan_Main";
                    break;
                case "OBM":
                    window.location.href = "../Order/OrderBelongMain";
                    break;
                case "CLM":
                    window.location.href = "../Company/CompanyLinkManagement";
                    break;
                default:
                    break;
            }
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">

    <div class="all">

        <div class="sub-contents-div">
            <!--제목 타이틀-->
            <div class="sub-title-div">
                <p class="p-title-mainsentence">
                    주문 연동 관리
                    <span class="span-title-subsentence"></span>
                </p>
            </div>
            <br />
            <!--상위 탭메뉴-->
            <div>
                <input type="button" class="mainbtn type1" style="width: 105px; height: 30px; font-size: 12px" value="관계사 연동 관리" onclick="fnGoPage('CLM')" />
                <input type="button" class="mainbtn type1" style="width: 105px; height: 30px; font-size: 12px" value="PG 관리" onclick="fnGoPage('PG')" />
                <input type="button" class="mainbtn type1" style="width: 105px; height: 30px; font-size: 12px" value="여신 관리" onclick="fnGoPage('LOAN')" />
            </div>


            <!--탭메뉴-->
            <div class="div-main-tab" style="width: 100%;">
                <ul>
                    <li class='tabOff' style="width: 185px;" onclick="fnTabClickRedirect('OrderBelongMain');">
                        <a onclick="fnTabClickRedirect('OrderBelongMain');">주문 소속</a>
                    </li>
                    <li class='tabOff' style="width: 185px;" onclick="fnTabClickRedirect('OrderAreaList');">
                        <a onclick="fnTabClickRedirect('OrderAreaList');">주문 지역</a>
                    </li>
                    <li class='tabOn' style="width: 185px;" onclick="fnTabClickRedirect('OrderSaleCompList');">
                        <a onclick="fnTabClickRedirect('OrderSaleCompList');">판매사플랫폼등록</a>
                    </li>
                </ul>
            </div>


            <!--하위 탭메뉴-->
            <div class="tab-display1">
                <div class="tab" style="margin-top: 10px">
                    <span class="subTabOff" style="width: 186px; height: 35px; cursor: pointer;" id="btnTab1" onclick="fnTabClickRedirect('OrderSaleCompList');">주문 업체 조회</span>
                    <span class="subTabOn" style="width: 186px; height: 35px; cursor: pointer;" id="btnTab2" onclick="fnTabClickRedirect('OrderSaleCompRegister');">주문 업체 등록</span>
                    <%--<a class="tabButton1"  id="btnTab1" onclick="javascript:location.href='OrderSaleCompList.aspx';">
                   <img src="../../Images/Order/belongTsub-off.jpg" alt="주문 지역 조회"  /></a>
                <a class="tabButton2"  id="btnTab2" onclick="javascript:location.href='OrderSaleCompRegister.aspx';"><img src="../../Images/Order/belongT2sub-on.jpg" alt="주문 지역 등록"  /></a>--%>
                </div>
            </div>

            <%--본문 영역 시작--%>
            <div class="search-div">
                <table id="tblCompReg" class="tbl_main">
                    <thead>
                        <tr>
                            <th colspan="5" style="height: 50px;">주문 업체 등록</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <th>* 주문 소속 코드</th>
                            <td class="td-width-1 border-right-none">
                                <input type="text" id="txtBelongCode" readonly="readonly" onkeypress="return preventEnter(event);" /></td>
                            <td>
                                <input type="button" value="검색" style="width:75px;" class="mainbtn type1" onclick="return fnSearchBelongPopup();"/>
                            </td>
                            <th>주문 소속명</th>
                            <td class="td-width-1"><span id="spBelongNm" style="margin-left: 6px;"></span></td>
                        </tr>
                        <tr>
                            <th>* 주문 지역 코드</th>
                            <td colspan="2">
                                <select id="ddlAreaCode" style="height: 24px; margin-left: 2px;"></select>
                            </td>
                            <th>주문 지역명</th>
                            <td><span id="spAreaNm" style="margin-left: 6px;"></span></td>
                        </tr>
                        <tr>
                            <th>* 주문 업체 코드<br />
                                (판매사 회사코드)</th>
                            <td class="border-right-none">
                                <input type="text" id="txtCompCode" readonly="readonly" onkeypress="return preventEnter(event);" /></td>
                            <td>
                                <input type="button" value="검색" style="width:75px;" class="mainbtn type1" onclick="return fnSearchSaleCompPopup();"/>
                            </td>
                            <th>주문 업체명<br />
                                (판매사 회사명)</th>
                            <td>
                                <input type="hidden" id="hdSaleCompNm" />
                                <input type="hidden" id="hdSaleCompNo" />
                                <span id="spCompNm" style="margin-left: 6px;"></span>
                                <br />
                                <span id="spCompNo" style="margin-left: 6px;"></span>
                            </td>
                        </tr>
                        <tr>
                            <th>* 사업자 구분</th>
                            <td class="border-right-none">
                                <input type="text" id="txtSocialCompCode" readonly="readonly" onkeypress="return preventEnter(event);" /></td>
                            <td class="border-left-none">
                                 <input type="button" value="검색" style="width:75px;" class="mainbtn type1" onclick="fnSearchSocialCompPopup(); return false;"/>
                            </td>
                            <th>사업자 구분<br />
                                (판매사)</th>
                            <td><span id="spSocialCompNm" style="margin-left: 6px;"></span></td>
                        </tr>
                        <tr>
                            <th>* 비고</th>
                            <td colspan="4">
                                <textarea id="txtaRemark" style="width:99%" maxlength="180"></textarea>
                            </td>
                        </tr>
                    </tbody>
                </table>
                <br />
                <div class="bt-align-div">
                    <input type="button" value="등록" style="width:75px;" class="mainbtn type1"onclick="fnSaveOrdSaleComp(); return false;">
                    <%--<asp:ImageButton runat="server" id="ibtnSave" OnClientClick="return fnValidate();"  AlternateText="등록" ImageUrl="../Images/Member/insert-off.jpg" onmouseover="this.src='../Images/Member/insert-on.jpg'" onmouseout="this.src='../Images/Member/insert-off.jpg'"/>--%>
                </div>
            </div>
            <%--본문 영역 끝--%>
        </div>

        <!-- 팝업창 영역 시작 -->
        <%--주문 소속 코드 팝업--%>
        <div id="orderBelongCodediv" class="popupdiv divpopup-layer-package">
            <div class="popupdivWrapper" style="width:700px; height: 600px">
                <div class="popupdivContents">

                    <div class="close-div">
                        <a onclick="fnClosePopup('orderBelongCodediv'); return false;" style="cursor: pointer">
                            <img src="../../Images/Wish/icon-delete.jpg" alt="닫기" style="float: right;" /></a>
                    </div>
                    <div class="popup-title" style="margin-top: 20px;">
                        <h3 class="pop-title">주문 소속 코드 조회</h3>

                        <div class="search-div" style="margin-bottom: 20px;">
                            <input type="text" class="text-code" id="txtPopSearchBelong" placeholder="주문 소속명을 입력하세요" onkeypress="return fnPopBelongEnter();" style="width:400px" />
                            <input type="button" class="mainbtn type1" style="width:75px" value="검색" onclick="fnGetOrderBelongList(); return false;" />
                        </div>


                        <div class="divpopup-layer-conts">
                            <table id="tblHeader" class="tbl_main tbl_popup" style="margin-top: 0; width: 100%">
                                <thead>
                                    <tr>
                                        <th class="text-center" style="width: 10%">선택</th>
                                        <th class="text-center">소속명</th>
                                        <th class="text-center">소속코드</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr>
                                        <td colspan="3" class="text-center">리스트가 없습니다.</td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                        <div style="text-align: right; margin-top: 30px;">
                            <input type="button" class="mainbtn type1" style="width:75px" value="확인" onclick="fnPopupOkBelong(); return false;" />
                        </div>

                    </div>
                </div>
            </div>
        </div>

        <%--주문 업체 코드 팝업--%>
        <div id="orderSaleCodediv" class="popupdiv divpopup-layer-package">
            <div class="popupdivWrapper" style="width:700px; height: 750px">
                <div class="popupdivContents">

                    <div class="close-div">
                        <a onclick="fnClosePopup('orderSaleCodediv'); return false;" style="cursor: pointer">
                            <img src="../../Images/Wish/icon-delete.jpg" alt="닫기" style="float: right;" /></a>
                    </div>


                    <div class="popup-title" style="margin-top: 20px;">
                         <h3 class="pop-title">주문 업체 코드 조회</h3>

                        <div class="search-div" style="margin-bottom: 20px;">
                            <input type="text" class="text-code" id="txtPopSearchSaleComp" placeholder="주문 업체명을 입력하세요" onkeypress="return fnPopSaleCompEnter();" style="width:400px" />
                            <input type="button" class="mainbtn type1" style="width:75px" value="검색" onclick="fnGetCompanyList_A(1); return false;"  />
                        </div>


                        <div class="divpopup-layer-conts">
                            <table id="tblSaleComp" class="tbl_main tbl_popup" style="margin-top: 0; width: 100%">
                                <thead>
                                    <tr>
                                        <th class="text-center" style="width: 10%">선택</th>
                                        <th class="text-center">판매사명</th>
                                        <th class="text-center">판매사 코드</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr>
                                        <td colspan="3" class="text-center">리스트가 없습니다.</td> 
                                    </tr>
                                </tbody>
                            </table>
                            <br />
                            <!-- 페이징 처리 -->
                            <div style="margin: 0 auto; text-align: center">
                                <input type="hidden" id="hdTotalCount" />
                                <div id="pagination" class="page_curl" style="display: inline-block"></div>
                            </div>
                        </div>

                        <div style="text-align: right; margin-top: 30px;">
                            
                            <input type="button" class="mainbtn type1" style="width:75px" value="확인" onclick="fnPopupOkSaleComp(); return false;" />
                        </div>

                    </div>
                </div>
            </div>
        </div>
        <%--사업자 구분 팝업--%>
        <div id="socialCompCodediv" class="popupdiv divpopup-layer-package">
            <div class="popupdivWrapper" style="width: 700px; height: 750px">
                <div class="popupdivContents">

                    <div class="close-div">
                        <a onclick="fnClosePopup('socialCompCodediv'); return false;" style="cursor: pointer">
                            <img src="../../Images/Wish/icon-delete.jpg" alt="닫기" style="float: right;" /></a>
                    </div>
                    <div class="popup-title" style="margin-top: 20px;">
                       <h3 class="pop-title">사업자 구분 코드 조회</h3>

                        <div class="search-div" style="margin-bottom: 20px;">
                            <input type="text" class="text-code" id="txtPopSearchSocialComp" placeholder="사업자 구분명을 입력하세요" onkeypress="return fnPopSocialCompEnter();" style="width:400px" />
                            <%--<a class="imgA" onclick="fnGetSocialCompList(1); return false;">
                                <img src="../../AdminSub/Images/Goods/search-bt-off.jpg" alt="검색" class="mainbtn type1" /></a>--%>
                            <input type="button" class="mainbtn type1" style="width:75px" value="검색" onclick="fnGetSocialCompList(1); return false;" />
                        </div>


                        <div class="divpopup-layer-conts">
                            <table id="tblSocialComp" class="tbl_main tbl_popup" style="margin-top: 0; width: 100%">
                                <thead>
                                    <tr>
                                        <th class="text-center" style="width: 10%">선택</th>
                                        <th class="text-center">사업자 구분명</th>
                                        <th class="text-center">사업자 구분 코드</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr>
                                        <td colspan="3" class="text-center">리스트가 없습니다.</td>
                                    </tr>
                                </tbody>
                            </table>
                            <br />
                            <!-- 페이징 처리 -->
                            <div style="margin: 0 auto; text-align: center">
                                <input type="hidden" id="hdTotalCount_3" />
                                <div id="pagination_3" class="page_curl" style="display: inline-block"></div>
                            </div>
                        </div>

                        <div style="text-align: right; margin-top: 30px;">
                           <%-- <a onclick="fnPopupOkSocialComp(); return false;">
                                <img src="../Images/Goods/submit1-off.jpg" alt="확인" class="mainbtn type1" /></a>--%>
                            <input type="button" class="mainbtn type1" style="width:75px" value="확인" onclick="fnPopupOkSocialComp(); return false;" />
                        </div>

                    </div>
                </div>
            </div>
        </div>
        <!-- 팝업창 영역 끝 -->
    </div>

</asp:Content>
