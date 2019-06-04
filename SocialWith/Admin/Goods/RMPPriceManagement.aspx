<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Master/AdminMasterPage.master" AutoEventWireup="true" CodeFile="RMPPriceManagement.aspx.cs" Inherits="Admin_Goods_RMPPriceManagement" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <%--<link href="../Content/Order/common.css" rel="stylesheet" />--%>
    <link href="../Content/Goods/goods.css" rel="stylesheet" />
    <link href="../Content/popup.css" rel="stylesheet" />
    <script>
        $(function () {

            //검색을 클릭 했을때 
            $("#btnGoodsSearch").click(function () {
                if ($("#txtSaleCompSearch").val() == "") {
                    fnSearchRMPPopup(1);
                    return false;
                }
                if ($("#txtSaleCompSearch").val() != "") {
                    fnRMPList(1);
                    return false;
                }
            });

            //검색 input창 엔터 
            $("#txtSaleCompSearch").keydown(function (event) {
                if (event.keyCode == 13) {
                    if ($("#txtSaleCompSearch").val() == "") { 
                        fnSearchRMPPopup(1);
                        return false;
                    }

                    $("#tblPopList").empty();
                    if ($(this).val() != "") { 
                        fnRMPList(1);
                        return false;
                    }
                }
            }); //keydown end


            //RMP 선택시
            $("#tblPopList").on("click", "tr", function (e) {
                $('tr').removeClass('on');
                var tr = $(this);

                if (tr.hasClass('RMPList')) {
                    tr.addClass('on');
                }
            });// on() end
        }); //$function end

        //팝업함수 
        function fnSearchRMPPopup(pageNo) {

            fnOpenDivLayerPopup('txtPopSearchRMP');//팝업열림 
            $("#txtSaleCompSearch:focus").blur(); //포커스 없애기 엔터 재방지

            var pageSize = 15;
            var callback = function (response) {

                $("#tblPopList").empty();

                if (!isEmpty(response)) {
                    // console.log(response);
                    var RMPList = "";
                    var num = 1;
                    $.each(response, function (key, value) {

                        $('#hdRMPpopupTotalCount').val(value.TotalCount);
                        RMPList += '<tr class="RMPList" ondblclick="dbClick()">'
                        RMPList += '<td class="txt-center">' + num + '</td>'
                        RMPList += '<td class="txt-center compCode">' + value.Company_Code + '</td>'
                        RMPList += '<td class="txt-center compName">' + value.Company_Name + '</td>'
                        RMPList += '</tr>'
                        num++;

                    });//each() end

                    $("#tblPopList").append(RMPList);
                    fnCreatePagination('RMPpagination', $("#hdRMPpopupTotalCount").val(), pageNo, pageSize, getRMPPageData);
                    $('#tblPopList').children().css('cursor', 'pointer');

                } else {
                    RMPList += "<tr >"
                    RMPList += "<td class='txt-center' colspan='3' >조회된 데이터가 없습니다.</td>"
                    RMPList += "</tr>"
                    $("#tblPopList").append(RMPList);

                } //if~else end

                return false;

            }; // var callback
            var param = {
                Keyword: $("#txtSaleCompSearch").val(),
                Target: $("#searchTarget").val(),
                Gubun: "IU",
                PageNo: pageNo,
                PageSize: pageSize,
                Flag: 'GetCompListByGubun'
            };

            JqueryAjax('Post', '../../Handler/Admin/CompanyHandler.ashx', true, false, param, 'json', callback, null, null, true, '<%=Svid_User%>');
        }

        //팝업페이지
        function getRMPPageData() {
            var container = $('#RMPpagination');
            var getPageNum = container.pagination('getSelectedPageNum');
            fnSearchRMPPopup(getPageNum);
            return false;
        }

        //더블클릭시
        function dbClick() {
            fnPopupOkSaleComp();
        }

        //팝업 확인
        function fnPopupOkSaleComp() {

            var tr = $('.on');
            var compCode = tr.children('.compCode').text();
            var compName = tr.children('.compName').text();

            if (compCode && compName != null) {
                $("#txtSaleCompSearch").val(compName)
           
                $("#<%=excelTarget.ClientID%>").val(compCode);
                $("#<%=excelKeyword.ClientID%>").val(compName);

                $('#txtPopSearchRMP').fadeOut();

                fnRMPList(1);

            } else {
                alert("RMP 회사를 선택해주세요.");
            }
        }

        //사용유무 업데이트
        function fnUpdateDelflag(el) {

            var unum = $(el).parent().find('.RMPUnum').val();
            var use = $(el).parent().find('#useWhether').val();

            var updateAlert = confirm("저장 하시겠습니까?");
            if (updateAlert == true) {

                var callback = function (response) {
                    if (response == 'OK') {
                        alert("사용유무가 변경되었습니다.");

                        fnRMPList(1);

                    } else {
                        alert('시스템 오류입니다. 관리자에게 문의하세요.');
                    }
                    return false;
                }; // var callback

                var param = {
                    Unum_RmpCompanyPrice: unum,
                    Delflag: use,
                    Flag: 'UpdateRmpCompPrice'

                };
                JqueryAjax('Post', '../../Handler/Admin/CompanyHandler.ashx', true, false, param, 'text', callback, null, null, true, '<%=Svid_User%>')

            } else {
                alert("취소되었습니다.");
            }
        }
        //가격관리 목록 
        function fnRMPList(pageNo) {
            var pageSize = 20;

            var callback = function (response) {

                $("#tblRMPManageList").empty();
                if (!isEmpty(response)) {

                    var RMPList = "";

                    $.each(response, function (key, value) {

                        $('#RMPListTotalCount').val(value.TotalCount);
                        var RMPprice2 = Math.round((value.RmpPriceP * 100) / (100 - value.SwpPriceP));
                        var saleCompPrice = Math.round((value.SalePriceP * 100) / (100 - value.SwpPriceP));
                         // console.log(value.RmpPriceP);
                        var colorRed = '';
                        if (value.Delflag == 'N') {

                            colorRed = 'colorRed';
                        } else {
                            colorRed = '';
                        }
                        if (key == 0) {
                            $("#<%=excelTarget.ClientID%>").val($("#searchTarget").val());
                            $("#<%=excelKeyword.ClientID%>").val($("#txtSaleCompSearch").val());
                        }

                        RMPList += '<tr class="RMPBodyList ' + colorRed + '">'
                        RMPList += '<td class="txt-center">' + value.RowNum + ' </td>'
                        RMPList += '<td class="txt-center">' + value.Company_Code + '</td>'
                        RMPList += '<td class="txt-center">' + value.Company_Name + '</td>'
                        RMPList += '<td class="txt-center">' + fnOracleDateFormatConverter(value.StartDate) + '</td>'
                        RMPList += '<td class="txt-center">' + fnOracleDateFormatConverter(value.EndDate) + '</td>'
                        RMPList += '<td class="txt-center">' + value.SwpPriceP + '%</td>'
                        RMPList += '<td class="txt-center">' + (100 - value.SwpPriceP) + '%</td>'
                        RMPList += '<td class="txt-center">' + RMPprice2 + '%</td>'
                        RMPList += '<td class="txt-center">' + saleCompPrice + '%</td>'
                        RMPList += '<td class="v-align">';
                        var selectY = '';
                        var selectN = '';
                        if (value.Delflag == 'N') {

                            selectY = 'selected';
                        }
                        else {
                            selectN = 'selected';
                        }
                        RMPList += '<select id="useWhether" style="width:50%;">'
                        RMPList += '<option value="N" ' + selectY + '>유</option>'
                        RMPList += '<option value="Y" ' + selectN + '>무</option>'
                        RMPList += '</select>'
                        RMPList += '  <input type="button" class="btnDelete" value="저장" onclick="fnUpdateDelflag(this); return false;"/>'
                        RMPList += '  <input type="hidden" class="RMPUnum" value="' + value.Unum_RmpCompanyPrice + '" />'
                        RMPList += '  </td>'
                        RMPList += '</tr>'

                    });//each() end

                    $("#tblRMPManageList").append(RMPList);
                    fnCreatePagination('RMPListpagination', $("#RMPListTotalCount").val(), pageNo, pageSize, getRMPListPageData);

                } else {
                    RMPList += "<tr class='RMPBodyList' >"
                    RMPList += "<td class='txt-center' colspan='10' >조회된 데이터가 없습니다.</td>"
                    RMPList += "</tr>"
                    $("#tblRMPManageList").append(RMPList);

                } //if~else end
                return false;
            }; // var callback

            if ($("#txtSaleCompSearch").val() == "") { //빈칸일때
                var param = {
                    Target: 'COMPNAME',
                    Keyword: $("#txtSaleCompSearch").val(),
                    PageNo: pageNo,
                    PageSize: pageSize,
                    Flag: 'GetRmpCompPriceList'
                };

            } else {

                var param = {
                    Target: $("#searchTarget").val(),
                    Keyword: $("#txtSaleCompSearch").val(),
                    PageNo: pageNo,
                    PageSize: pageSize,
                    Flag: 'GetRmpCompPriceList'
                };

            }
            JqueryAjax('Post', '../../Handler/Admin/CompanyHandler.ashx', true, false, param, 'json', callback, null, null, true, '<%=Svid_User%>');
        }

        function getRMPListPageData() {
            var container = $('#RMPListpagination');
            var getPageNum = container.pagination('getSelectedPageNum');
            fnRMPList(getPageNum);
            return false;
        }

    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div class="sub-contents-div" style="min-height: 1500px">
        <div class="sub-title-div">
            <p class="p-title-mainsentence">
                RMP 가격관리
                    <span class="span-title-subsentence"></span>
            </p>
        </div>
        <!--탭영역-->
        <div class="div-main-tab" style="width: 100%;">
            <ul>
                <li class='tabOn' style="width: 185px;" onclick="fnTabClickRedirect('RMPPriceManagement');">
                    <a onclick="fnTabClickRedirect('RMPPriceManagement');">RMP 가격관리</a>
                </li>
                <li class='tabOff' style="width: 185px;" onclick="fnTabClickRedirect('RMPPriceRegister');">
                    <a onclick="fnTabClickRedirect('RMPPriceRegister');">RMP 가격등록</a>
                </li>
            </ul>
        </div>
        <div class="bottom-search-div" style="margin-bottom: 20px">
            <table class="tbl_search" style="margin-top: 30px; margin-bottom: 30px;">
                <tr>
                    <td style="width: 200px; text-align: right;">
                        <select id="searchTarget">
                            <option value="COMPNAME">회사명</option>
                            <option value="COMPCODE">회사코드</option>
                        </select>
                    </td>
                    <td>
                        <input type="text" placeholder="RMP 검색하시오." style="width: 600px;" id="txtSaleCompSearch" />
                        <input type="button" class="mainbtn type1" id="btnGoodsSearch" value="검색" style="vertical-align: middle; width: 75px; height: 25px;" />
                        <asp:HiddenField runat="server" ID="excelTarget" />
                        <asp:HiddenField runat="server" ID="excelKeyword" />
                    </td>
                </tr>
            </table>
        </div>

        <!-- RMP가격관리 -->
        <div>

            <input type="hidden" id="hdCompCode" />
            <table id="tblBuyComp" class="tbl_main">
                <colgroup>
                    <col>
                    <col>
                    <col>
                    <col>
                    <col>
                    <col>
                    <col>
                    <col>
                    <col>
                    <col style="width: 150px;">
                </colgroup>
                <thead>
                    <tr>
                        <th rowspan="2">순번</th>
                        <th rowspan="2">RMP 회사코드</th>
                        <th rowspan="2">RMP 회사명</th>
                        <th rowspan="2">시작일</th>
                        <th rowspan="2">종료일</th>
                        <th colspan="2">소셜위드 기준</th>
                        <th colspan="2">RMP 기준</th>
                        <th rowspan="2">사용유무</th>
                    </tr>
                    <tr>
                        <th>소셜위드 가격(%)</th>
                        <th>RMP 가격(%)</th>
                        <th>RMP 가격(%)</th>
                        <th>판매사 가격(%)</th>
                    </tr>
                </thead>
                <tbody id="tblRMPManageList">

                    <tr>
                        <td class='txt-center' colspan='10'>조회된 데이터가 없습니다.</td>

                    </tr>


                </tbody>

            </table>

        </div>
        <!--페이징-->
        <div style="margin: 0 auto; text-align: center; padding-top: 10px">
            <input type="hidden" id="RMPListTotalCount" />
            <div id="RMPListpagination" class="page_curl" style="display: inline-block"></div>
        </div>
        <!--페이징 끝-->
        <div class="bt-align-div">

            <asp:Button runat="server" ID="btnExcelDownLoad" OnClick="btnExcelDownLoad_Click" Width="155" Height="30" Text="Excel 다운로드" CssClass="mainbtn type1" />
        </div>
    </div>


    <%--RMP 가격관리 팝업--%>
    <div id="txtPopSearchRMP" class="popupdiv divpopup-layer-package">
        <div class="popupdivWrapper" style="width: 650px; height:300px">
            <div class="popupdivContents">

                <div class="close-div">
                    <a onclick="fnClosePopup('txtPopSearchRMP'); return false;" style="cursor: pointer">
                        <img src="../../Images/Wish/icon-delete.jpg" alt="닫기" style="float: right;" /></a>
                </div>
                <div class="popup-title" style="margin-top: 20px;">
                <h3 class="pop-title">RMP 회사검색</h3>
                    </div>
                <table class="tbl_main tbl_popup">
                    <thead>
                        <tr>
                            <th>순번</th>
                            <th>RMP 회사코드</th>
                            <th>RMP 회사명</th>
                        </tr>
                    </thead>
                    <tbody id="tblPopList">
                    </tbody>
                </table>
                <!--페이징-->
                <div style="margin: 0 auto; text-align: center; padding-top: 10px">
                    <input type="hidden" id="hdRMPpopupTotalCount" />
                    <div id="RMPpagination" class="page_curl" style="display: inline-block"></div>
                </div>
                <!--페이징 끝-->
                <div class="btn_center">

                    <input type="button" id="popupOk" class="mainbtn type1" style="width: 95px; height: 30px;" value="확인" onclick="fnPopupOkSaleComp(); return false; " />
                </div>
            </div>
        </div>
    </div>



</asp:Content>
