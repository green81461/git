<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Master/AdminMasterPage.master" AutoEventWireup="true" CodeFile="SiteInfoBanner.aspx.cs" Inherits="Admin_Setting_SiteInfoBanner" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <script type="text/javascript">
        var qs = fnGetQueryStrings();
        var qsCssCode;
        var qsCompCode;
        var qsCompName;

        $(function () {
            qsCssCode = qs['CssCode'];
            qsCompCode = qs['CompCode'];
            qsCompName = qs['CompName'];
            $("#tblPopupComp").on("click", "tr", function () {

                //초기화
                $("#hdSelectCode").val('');
                $("#hdSelectName").val('');
                $("#hdSiteUrl").val('');
                $("#tblPopupComp tr").css("background-color", "");

                $(this).css("background-color", "#ffe6cc");

                var selectCode = $(this).find("input:hidden[id^='hdCode']").val();
                var selectName = $(this).find("input:hidden[id^='hdName']").val();
                var selectUrl = $(this).find("input:hidden[id^='hdUrl']").val();
                $("#hdSelectCode").val(selectCode);
                $("#hdSelectName").val(selectName);
                $('#hdSelectGubun').val($('#selectGubun').val());
                $("#hdSiteUrl").val(selectUrl);

            });

            $("#tblPopupDist").on("click", "tr", function () {

                //초기화
                $("#hdSelectDistCssCode").val('');
                $("#hdSelectDistCssName").val('');
                $("#tblPopupDist tr").css("background-color", "");

                $(this).css("background-color", "#ffe6cc");

                var selectCode = $(this).find("input:hidden[id^='hdCode']").val();
                var selectName = $(this).find("input:hidden[id^='hdName']").val();

                $("#hdSelectDistCssCode").val(selectCode);
                $("#hdSelectDistCssName").val(selectName);

            });
            $("#tabDefault").on("click", function () {

                location.href = 'SiteInfoDefault.aspx?CssCode=' + $('#hdDistCssCode').val() + '&CompCode=' + $('#txtCompSearch').val() + '&CompName=' + $('#lblCompName').text() + '&ucode=' + ucode;;
            });
            $("#tabPopup").on("click", function () {

                location.href = 'SiteInfoPopup.aspx?CssCode=' + $('#hdDistCssCode').val() + '&CompCode=' + $('#txtCompSearch').val() + '&CompName=' + $('#lblCompName').text() + '&ucode=' + ucode;;
            });
            $("#tabMenu").on("click", function () {

                location.href = 'SiteInfoMenu.aspx?CssCode=' + $('#hdDistCssCode').val() + '&CompCode=' + $('#txtCompSearch').val() + '&CompName=' + $('#lblCompName').text() + '&ucode=' + ucode;;
            });
            $("#tabBanner").on("click", function () {

                location.href = 'SiteInfoBanner.aspx?CssCode=' + $('#hdDistCssCode').val() + '&CompCode=' + $('#txtCompSearch').val() + '&CompName=' + $('#lblCompName').text() + '&ucode=' + ucode;;
            });
            $("#tabPartner").on("click", function () {

                location.href = 'SiteInfoPartner.aspx?CssCode=' + $('#hdDistCssCode').val() + '&CompCode=' + $('#txtCompSearch').val() + '&CompName=' + $('#lblCompName').text() + '&ucode=' + ucode;;
            });

            $("#tbodyBannMaster tr").on("click", function () {
                alert($(this).find("input:hidden[name^=hdTest]").val());
            });


            $("#pop_brandTbody").on("click", "tr", function () {

                //초기화
                $("#hdPopupSelectBrandCode").val('');
                $("#hdPopupSelectBrandName").val('');
                $("#pop_brandTbody tr").css("background-color", "");

                $(this).css("background-color", "#ffe6cc");

                var selectCode = $(this).find("input:hidden[name^='hdRowBrandCode']").val();
                var selectName = $(this).find("input:hidden[name^='hdRowBrandName']").val();
                $("#hdPopupSelectBrandCode").val(selectCode);
                $("#hdPopupSelectBrandName").val(selectName);

            });

            if (!isEmpty(qsCssCode)) {

                $('#txtCompSearch').val(qsCompCode);
                $('#lblCompName').text(qsCompName);
                $('#txtCode').val(qsCssCode);

                fnDistInfo();
                fnGetDistMasterBanner();
                fnGetDistCategoryLanding();

                $('#divMain').css('display', '');
                $('#divBtn').css('display', '');
                $('#divTab').css('display', '');
            }

        })

        
        function fnSearchCompanyPopup() {
            $('#selectGubun').val('SU');
            $('#txtPopSearchComp').val('');
            fnSearchCompanyList(1);
            fnOpenDivLayerPopup('searchCompdiv');
        }

        function fnDistPopup() {

            if ($('#txtCompSearch').val() == '') {

                alert('먼저 회사를 선택해 주세요');
                return false;

            }
            fnDistList(1);
            fnOpenDivLayerPopup('distCssdiv');
        }

        function fnSearchCompanyList(pageNo) {

            $("#tblPopupComp").empty();
            var pageSize = 15;
            var callback = function (response) {
                var newRowContent = '';
                if (!isEmpty(response)) {
                    $.each(response, function (key, value) { //테이블 추가


                        if (key == 0) $("#hdTotalCount").val(value.TotalCount);
                        newRowContent += "<tr style='cursor: pointer'>";
                        newRowContent += "<td style='text-align:center'><input type='hidden' id='hdCode' value='" + value.Company_Code + "'/><input type='hidden' id='hdName' value='" + value.Company_Name + "'/><input type='hidden' id='hdUrl' value='" + value.AtypeUrl + "'/>" + value.Company_Code + "</td>";
                        newRowContent += "<td style='text-align:center'>" + value.Company_Name + "</td>";
                        newRowContent += "<tr>";


                    });
                    $("#tblPopupComp").append(newRowContent);
                }
                else {
                    $("#hdTotalCount").val(0);
                    var emptyTag = "<tr><td colspan='2' class='txt-center'>조회된 데이터가 없습니다.</td></tr>";
                    $("#tblPopupComp").append(emptyTag);
                }
                fnCreatePagination('pagination', $("#hdTotalCount").val(), pageNo, pageSize, getPageData);
                return false;
            }

            var param = {

                Gubun: $('#selectGubun').val(),
                Keyword: $('#txtPopSearchComp').val(),
                PageNo: pageNo,
                PageSize: pageSize,
                Flag: 'GetCompanySearchList'

            };


            //type, url, async, cache, data, datatype, _callback, _beforeSend, _complete, issessionCheck, sessionValue
            JqueryAjax('Post', '../../Handler/Admin/CompanyHandler.ashx', true, false, param, 'json', callback, null, null, true, '<%=Svid_User%>');

        }

        function fnDistList(pageNo) {

            $("#tblPopupDist").empty();
            var pageSize = 15;
            var callback = function (response) {
                var newRowContent = '';
                if (!isEmpty(response)) {
                    $.each(response, function (key, value) { //테이블 추가


                        if (key == 0) $("#hdDistTotalCount").val(value.TotalCount);
                        newRowContent += "<tr style='cursor: pointer'>";
                        newRowContent += "<td style='text-align:center'><input type='hidden' id='hdCode' value='" + value.DistCssCode + "'/><input type='hidden' id='hdName' value='" + value.DistCssName + "'>" + value.DistCssCode + "</td>";
                        newRowContent += "<td style='text-align:center'>" + value.DistCssName + "</td>";
                        newRowContent += "<td style='text-align:center'>" + fnOracleDateFormatConverter(value.UpdateTime) + "</td>";

                        var deleteText = '사용중';
                        if (value.DelFlag == 'Y') {
                            deleteText = '삭제';
                        }
                        newRowContent += "<td style='text-align:center'>" + deleteText + "</td>";
                        newRowContent += "<tr>";


                    });
                    $("#tblPopupDist").append(newRowContent);
                }
                else {
                    $("#hdDistTotalCount").val(0);
                    var emptyTag = "<tr><td colspan='4' class='txt-center'>조회된 데이터가 없습니다.</td></tr>";
                    $("#tblPopupDist").append(emptyTag);
                }
                fnCreatePagination('distPagination', $("#hdDistTotalCount").val(), pageNo, pageSize, getPageData);
                return false;
            }

            var param = {
                Gubun: $('#ddlGubun2').val(),
                GubunInfo: $('#ddlGubun1').val(),
                CompCode: $('#txtCompSearch').val(),
                PageNo: pageNo,
                PageSize: pageSize,
                Method: 'GetDistList'

            };


            //type, url, async, cache, data, datatype, _callback, _beforeSend, _complete, issessionCheck, sessionValue
            JqueryAjax('Post', '../../Handler/Common/DistCssHandler.ashx', true, false, param, 'json', callback, null, null, true, '<%=Svid_User%>');

        }

        function getPageData() {
            var container = $('#pagination');
            var getPageNum = container.pagination('getSelectedPageNum');
            fnSearchCompanyList(getPageNum);
            return false;
        }

        function getDistPageData() {
            var container = $('#distPagination');
            var getPageNum = container.pagination('getSelectedPageNum');
            fnDistList(getPageNum);
            return false;
        }

        function fnPopupEnter() {

            if (event.keyCode == 13) {
                fnSearchCompanyList(1);
                return false;
            }
            else
                return true;
        }

        function fnConfirm() {
            fnDataClear();
            var hdCode = $("#hdSelectCode").val();
            var hdName = $("#hdSelectName").val();

            if (isEmpty(hdCode)) {
                alert('회사를 선택해 주세요.');
                return false;
            }
            var gubunVal = '';
            if ($('#hdSelectGubun').val() == 'BU') {
                gubunVal = '1'
            }
            else if ($('#hdSelectGubun').val() == 'SU') {
                gubunVal = '2'
            }
            else {
                gubunVal = '2'
            }
            $('#ddlGubun2').val(gubunVal);
            $('#lblCompName').text(hdName);
            //$('#btnCopy').css('display', 'none');
            $('#txtCompSearch').val(hdCode);

            fnClosePopup('searchCompdiv');
        }

        function fnDataClear() {
            fnEmptyTable('tbodyRollMaster');
            fnEmptyTable('tbodyPopupRollDetail');
            fnEmptyTable('tbodyLanding');
            $("input[type='text'][id^='txt']").val('');
            $("input[type='file'][id^='fu']").val('');
            $("p[id^='lbl']").text('');
            $("span[id^='span']").text('');
            $("input[type='radio'][id^='rb']").prop('checked', false);
        }

        function fnDistConfirm() {
            var hdCode = $("#hdSelectDistCssCode").val();
            var hdName = $("#hdSelectDistCssName").val();

            $('#txtCode').val(hdCode);


            fnDistInfo();
            fnGetDistMasterBanner();
            fnGetDistCategoryLanding();

            $('#btnSaveDefault').css('display', 'none');
            $('#divMain').css('display', '');
            $('#divBtn').css('display', '');
            $('#divTab').css('display', '');
            fnClosePopup('distCssdiv');
        }

        function fnDistInfo() {

            var callback = function (response) {
                var newRowContent = '';
                if (!isEmpty(response)) {
                    $('input[type="file"]').val('');
                    $('#hdDistCssCode').val(response.DistCssCode);

                    $('#ddlGubun1').val(response.GubunInfo);
                    $('#ddlGubun2').val(response.Gubun);
                    $('#txtTitle').val(response.DistCssName);

                    if (response.DistSSLConfirmYN == 'Y') {
                        $('#rbSSLY').prop('checked', true);
                        $('#rbSSLN').prop('checked', false);
                    }
                    else {
                        $('#rbSSLY').prop('checked', false);
                        $('#rbSSLN').prop('checked', true);
                    }

                    if (response.PgConfirmYN == 'Y') {
                        $('#rbPGY').prop('checked', true);
                        $('#rbPGN').prop('checked', false);
                    }
                    else {
                        $('#rbPGY').prop('checked', false);
                        $('#rbPGN').prop('checked', true);
                    }
                    $('#txtDomain').val(response.EnterUrl);
                    $('#txtCompName').val(response.CompanyName);



                }

                return false;
            }

            var complete = function () {

                //$(btnCopy').css('display', '');
                //$(btnNormalSave').css('display', '');
            };

            var param = {

                DCode: $('#txtCode').val(),
                Method: 'GetDistInfo'

            };


            //type, url, async, cache, data, datatype, _callback, _beforeSend, _complete, issessionCheck, sessionValue
            JqueryAjax('Post', '../../Handler/Common/DistCssHandler.ashx', false, false, param, 'json', callback, null, complete, true, '<%=Svid_User%>');
        }

        function fnSetNextCode() {
            var callback = function (response) {
                var newRowContent = '';
                if (!isEmpty(response)) {

                    $('#txtCode').val(response);
                    $('#btnSaveDefault').css('display','');
                    return false;
                }
            }
            var param = {

                Method: 'GetNextCode'

            };


            //type, url, async, cache, data, datatype, _callback, _beforeSend, _complete, issessionCheck, sessionValue
            JqueryAjax('Post', '../../Handler/Common/DistCssHandler.ashx', true, false, param, 'text', callback, null, null, true, '<%=Svid_User%>');
        }

        function fnOpenCopy() {
            $('#selectPopupDistCopyTarget').val('2');
            $('#txtPopSearchDistCopy').val('');
            $('#hdCopyCodes').val('');
            $('#cbCheckAllCopy').prop('checked', false);



            fnDistCopyList(1);
            fnOpenDivLayerPopup('distCssCopydiv');
        }


        function fnDistCopyList(pageNo) {

            $("#tblPopupDistCopy").empty();
            var pageSize = 10;
            var callback = function (response) {
                var newRowContent = '';
                if (!isEmpty(response)) {
                    $.each(response, function (key, value) { //테이블 추가


                        if (key == 0) $("#hdDistCopyTotalCount").val(value.TotalCount);
                        newRowContent += "<tr style='cursor: pointer'>";
                        newRowContent += "<td style='text-align:center'><input type='hidden' id='hdCopyCode' value='" + value.DistCssCode + "'/><input type='checkbox' id='cbSelectCopy' onclick='return fnCbArrayPush(this);'/></td>";
                        newRowContent += "<td style='text-align:center'>" + value.DistCssCode + "</td>";
                        newRowContent += "<td style='text-align:center'>" + value.DistCssName + "</td>";
                        newRowContent += "<td style='text-align:center'>" + value.CompanyCode + "</td>";
                        newRowContent += "<td style='text-align:center'>" + value.CompanyName + "</td>";

                        var deleteText = '사용중';
                        if (value.DelFlag == 'Y') {
                            deleteText = '삭제';
                        }
                        newRowContent += "<td style='text-align:center'>" + deleteText + "</td>";
                        newRowContent += "</tr>";


                    });
                    $("#tblPopupDistCopy").append(newRowContent);


                    $('#tblPopupDistCopy tr').each(function () {
                        var el = this;
                        var currentCopyCode = $(el).children().find('#hdCopyCode').val();
                        var codeArray = $('#hdCopyCodes').val().slice(1).split('/');
                        $.each(codeArray, function (index, value) {
                            if (value == currentCopyCode) {
                                $(el).children().find('#cbSelectCopy').prop("checked", true);
                            }
                        });

                    });
                }
                else {
                    $("#hdDistCopyTotalCount").val(0);
                    var emptyTag = "<tr><td colspan='6' class='txt-center'>조회된 데이터가 없습니다.</td></tr>";
                    $("#tblPopupDistCopy").append(emptyTag);
                }
                fnCreatePagination('distCopyPagination', $("#hdDistCopyTotalCount").val(), pageNo, pageSize, getDistCopyPageData);
                return false;
            }

            var param = {
                BaseCode: $('#txtCode').val(),
                Gubun: $('#selectPopupDistCopyTarget').val(),
                GubunInfo: '',
                Keyword: $('#txtPopSearchDistCopy').val(),
                PageNo: pageNo,
                PageSize: pageSize,
                Method: 'GetDistCopyList'

            };


            //type, url, async, cache, data, datatype, _callback, _beforeSend, _complete, issessionCheck, sessionValue
            JqueryAjax('Post', '../../Handler/Common/DistCssHandler.ashx', true, false, param, 'json', callback, null, null, true, '<%=Svid_User%>');

        }

        function getDistCopyPageData() {
            var container = $('#distCopyPagination');
            var getPageNum = container.pagination('getSelectedPageNum');
            fnDistCopyList(getPageNum);
            return false;
        }

        function fnPopupCopyEnter() {

            if (event.keyCode == 13) {
                fnDistCopyList(1);
                return false;
            }
            else
                return true;
        }

        //전체선택
        function fnSelectAll(el) {
            var id = 'cbSelectCopy';

            if ($(el).prop("checked")) {
                $("input[id^=" + id + "]").not(":disabled").prop("checked", true);
            }
            else {
                $("input[id^=" + id + "]").not(":disabled").prop("checked", false);
            }

            $('#tblPopupDistCopy tr').each(function () {

                var checkbox = $(this).children().find('#cbSelectCopy');
                var copyCode = $(this).children().find('#hdCopyCode').val();
                if (checkbox.is(':checked')) {
                    $('#hdCopyCodes').val(function (i, v) {
                        var arr = v.split('/');
                        arr.push(copyCode);
                        return arr.join('/');
                    });
                }
                else {
                    $('#hdCopyCodes').val(function (i, v) {
                        return $.grep(v.split('/'), function (v) {
                            return v != copyCode;
                        }).join('/');
                    });
                }
            });
        }

        function fnCbArrayPush(el) {
            var copyCode = $(el).parent().find('#hdCopyCode').val();
            if ($(el).is(':checked')) {
                $('#hdCopyCodes').val(function (i, v) {
                    var arr = v.split('/');
                    arr.push(copyCode);
                    return arr.join('/');
                });
            }
            else {
                $('#hdCopyCodes').val(function (i, v) {
                    return $.grep(v.split('/'), function (v) {
                        return v != copyCode;
                    }).join('/');
                });
            }
        }

        function fnDistCopySave() {

            if ($('#hdCopyCodes').val() == '') {

                alert('복사 대상을 선택해 주세요.');
                return false;
            }

            if ($('#cbCopyDefault').is(":checked") == false && $('#cbCopyPopup').is(":checked") == false && $('#cbCopyMenu').is(":checked") == false && $('#cbCopyBanner').is(":checked") == false && $('#cbCopyPartner').is(":checked") == false&& $('#cbCopyLogin').is(":checked") == false&& $('#cbCopyCategory').is(":checked") == false) {

                alert('복사할 타입을 선택해 주세요.');
                return false;
            }

            if (!confirm('정말 복사하시겠습니까?')) {
                return false;
            }



            var callback = function (response) {

                if (response == 'OK') {

                    alert('복사되었습니다.');
                }
                else {
                    alert('시스템 오류입니다 시스템 관리자에게 문의하세요');

                }
                return false;
            }

            var types = '';
            if ($('#cbCopyDefault').is(":checked")) {
                types += 'Main/';
            }
            if ($('#cbCopyLogin').is(":checked")) {
                types += 'Login/';
            }
            if ($('#cbCopyPopup').is(":checked")) {
                types += 'Popup/';
            }
            if ($('#cbCopyMenu').is(":checked")) {
                types += 'Menu/';
            }
            if ($('#cbCopyBanner').is(":checked")) {
                types += 'Banner/';
            }
            if ($('#cbCopyCategory').is(":checked")) {
                types += 'CategoryLanding/';
            }
            if ($('#cbCopyPartner').is(":checked")) {
                types += 'Partner/';
            }

            var param = {


                BaseDCode: $('#txtCode').val(),
                DestDCodes: $('#hdCopyCodes').val().slice(1),
                DestTypes: types.slice(0, -1),
                Method: 'CopyDist'

            };

            //type, url, async, cache, data, datatype, _callback, _beforeSend, _complete, issessionCheck, sessionValue
            JqueryAjax('Post', '../../Handler/Common/DistCssHandler.ashx', false, false, param, 'text', callback, null, null, true, '<%=Svid_User%>');

            return false;
        }

        function fnSaveDefault() {

            if ($('#txtCompSearch').val() == '') {
                alert('회사를 선택해 주세요.');
                return false;

            }

            if ($('#txtCode').val() == '') {
                alert('신규코드를 생성해 주세요.');
                $('#txtCode').focus();
                return false;

            }

            var callback = function (response) {
                if (response == 'OK') {
                    fnDistInfo();
                }
                else {
                    alert('구성중 오류가 생겼습니다. 시스템 관리자에게 문의하세요.');
                    return false;
                }
            }

            var gubun = '';
            if ($('#hdSelectGubun').val() == 'SU') {
                gubun = '2'
            }
            else if ($('#hdSelectGubun').val() == 'BU') {
                gubun = '1'
            }
            else {
                 gubun = '2'
            }

            var param = {

                DCode: $('#txtCode').val(),
                Gubun: gubun,
                CompCode: $('#txtCompSearch').val(),

                Method: 'SaveDistDefault'

            };


            var beforeSend = function () {
            };

            var complete = function () {
            };

            //type, url, async, cache, data, datatype, _callback, _beforeSend, _complete, issessionCheck, sessionValue
            JqueryAjax('Post', '../../Handler/Common/DistCssHandler.ashx', false, false, param, 'text', callback, beforeSend, complete, true, '<%=Svid_User%>');
        }

         function fnAddTableRow(value, tbodyId) {

             var currentRowCount = $('#' + tbodyId + ' > tr').length + 1;

             var asynTable = "";
             if (tbodyId == 'tbodyRollMaster') {
                    asynTable += "<tr>";
                    asynTable += "<td class='txt-center'><input type='hidden' id='hdRowSeq' value='0'><input type='text' style='width:100%' id='txtRollMasterSeq' value='" + currentRowCount + "' onkeydown='return onlyNumbers(event);'/>";
                    asynTable += "</td>";
                    asynTable += "<td class='txt-center'> <select style='height: 26px; ' id='selectRollMasterUse'><option value='N'>예</option> <option value='Y'>아니오</option> </select>";
                    asynTable += "</td>";
                    asynTable += "<td class='txt-center'><input type='text' style='width:100%' id='txtRollMasterName'/ >";
                    asynTable += "</td>";
                    asynTable += "<td class='txt-center'>";
                    asynTable += "</td>";
                    asynTable += "<td class='txt-center'><input type='file' style='width:100%' id='fuRollMasterFile'/ >";
                    asynTable += "</td>";
                    asynTable += "<td class='txt-center'><input type='text' style='width:100%' id='txtRollMasterUrl'/ >";
                    asynTable += "</td>";
                    asynTable += "<td class='txt-center'><input type='button' class='btnDelete' value='삭제' onclick='fnDeleteTableRow(this, \"tbodyRollMaster\"); return false;'/>";
                    asynTable += "</td>";
                    asynTable += "</tr>";
                   
             }

             else if (tbodyId == 'tbodyPopupRollDetail') {

                 asynTable += "<tr style='height:60px'>";
                 asynTable += '<td class="txt-center"><input type="text" style="width: 100%; height: 22px; font-size: 12px"  id="txtSeq" value="' + currentRowCount + '"/></td>';
                 asynTable += '<td class="txt-center"><select style="height: 26px; width: 60px;" id="selectDetailDelflag"><option value="N">예</option><option value="Y">아니오</option></select></td>';
                 asynTable += '<td class="txt-center"><input type="checkbox" id="chDefaultYN"></td>';
                 
                 asynTable += '<td class="txt-center"><input type="text" style="width: 100%; height: 22px; font-size: 12px" id="txtDetailBannerName"></td>';
                 asynTable += '<td class="txt-center"></td>';
                 asynTable += '<td class="txt-center"><input type="file" style="width: 150px; height: 22px; font-size: 12px" id="fuDetailFile"></td>';
                 asynTable += '<td class="txt-center"></td>';
                 asynTable += '<td class="txt-center"><input type="file" style="width: 150px; height: 22px; font-size: 12px" id="fuDetailDetailFile"></td>';
                 asynTable += '<td class="txt-center"><input type="text" style="width:100%; height:22px; font-size:12px;" id="txtDetailDetailUrl"></td>';
                 asynTable += '<td class="txt-center"><input type="button" class="btnDelete" value="삭제" onclick="fnDeleteTableRow(this, \'tbodyPopupRollDetail\'); return false;"></td>';
                 asynTable += '</tr>';
             }

             else if (tbodyId == 'tbodyLanding') {

                     asynTable += "<tr id='trLandingRow"+currentRowCount+"'>";
                     asynTable += '<td class="txt-center"><input type="hidden" id="hdCtgyRowSeq" value="0"/><input type="text" style="width: 100%; height: 22px; font-size: 12px"  id="txtLandingSeq" value="' + currentRowCount + '"/></td>';
                     asynTable += '<td class="txt-center"><select style="height: 26px; width: 60px;" id="selectLandingUse"><option value="N">예</option><option value="Y">아니오</option></select></td>';
                 
                     asynTable += '<td class="txt-center"><input type="hidden" id="hdRowCategoryCode"/><input type="text" id="textRowCategoryInfo" readonly="readonly" style="width:130px"/><input type="button" class="btnDelete" value="검색" onclick="fnCategoryPopupOpen(this); return false;"></td>';
                     asynTable += '<td class="txt-center"><input type="hidden" id="hdRowBrandCode"/><input type="text" id="textRowBrandInfo" readonly="readonly" style="width:130px"/><input type="button" class="btnDelete" value="검색" onclick="fnBrandPopupOpen(this); return false;"></td>';
                     asynTable += '<td class="txt-center"></td>';
                     asynTable += '<td class="txt-center"><input type="file" style="width: 150px; height: 22px; font-size: 12px" id="fuLandingMainFile"></td>';
                     asynTable += '<td class="txt-center"></td>';
                     asynTable += '<td class="txt-center"><input type="file" style="width: 150px; height: 22px; font-size: 12px" id="fuLandingDetailFile"></td>';
                     asynTable += '<td class="txt-center"><input type="text" style="width:100%; height:22px; font-size:12px;" id="txtLandingUrl"></td>';
                     asynTable += '<td class="txt-center"><input type="button" class="btnDelete" value="삭제" onclick="fnDeleteTableRow(this, \'tbodyLanding\'); return false;"></td>';
                     asynTable += '</tr>';
             }
            $("#"+tbodyId+"").append(asynTable);
        }

        function fnDeleteTableRow(obj, tbodyId) {
            var currentRowCount = $('#'+tbodyId+' >tr').length;

            if (currentRowCount == 1) {

                alert('행이 1개 남았을 경우에는 삭제할 수 없습니다.');
                return false;
            }
            var tr = $(obj).parent().parent();
            tr.remove();
            return false;
        }



        function fnGetDistMasterBanner() {
            
            var callback = function (response) {
                $("#tbodyRollMaster").empty();
                var newRowContent = '';
                if (!isEmpty(response)) {
                    $.each(response, function (key, value) { //테이블 추가

                        newRowContent += "<tr>";
                        newRowContent += "<td  style='text-align:center'><input type='hidden' id='hdRowSeq' value='" + value.Seq + "'><input type='text' style='width:100%' value='" + value.MasterSeq + "' id='txtRollMasterSeq'></input></td>";

                        var selectY = '';
                        var selectN = '';
                       if (value.DelFlag == 'Y') {

                            selectY = 'selected';
                        }
                        else {
                            selectN = 'selected';
                        }
                        newRowContent += "<td style='text-align:center'><select style='height: 26px; ' id='selectRollMasterUse'><option value='N' " + selectN+">예</option> <option value='Y' "+ selectY+">아니오</option> </select></td>";
                        newRowContent += "<td style='text-align:center'><input type='text' style='width:100%' value='" + value.MasterName + "' id='txtRollMasterName'></input></td>";

                        var deleteButton = '';
                        var masterPath = ''
                        if (!isEmpty(value.FileName)) {
                            deleteButton = '&nbsp;&nbsp;<img src="/Admin/Images/icon-delete.jpg"  alt="x" onclick="fnDeleteImage(this,\'ROLLDETAILMAIN\'); return false" id="" style="cursor:pointer;"/>';
                            masterPath = "/SiteManagement/" + $('#txtCode').val() + "/Banner/" + value.FileName;
                        }
                        newRowContent += "<td style='text-align:center'><input type='hidden' id='hdRollMasterPath' value='" + masterPath + "'/><span id='spanMasterFilename'>" + value.FileName + "</span>" + deleteButton + "</td>";
                        newRowContent += "<td style='text-align:center'><input type='file' id='fuRollMasterFile'></input></td>";
                        newRowContent += "<td style='text-align:center'><input type='text' style='width:100%' value='" + value.Url + "' id='txtRollMasterUrl'></input></td>";
                        newRowContent += "<td style='text-align:center'><input type='button' class='btnDelete' value='삭제' onclick='fnDeleteBanner(this,\"ROLLMASTER\"); return false;'/>";
                        newRowContent += "&nbsp;&nbsp;<input type='button' class='listBtn' value='상세등록' style='display:none; width:71px; height:22px; font-size:12px' onclick='fnRollDetailPopup(\""+value.MasterSeq+"\"); return false;'/></td>";
                        newRowContent += "</tr>";

                    });
                    $("#tbodyRollMaster").append(newRowContent);
                }
                else {
                    var emptyTag = '';
                    emptyTag += "<tr>";
                    emptyTag += "<td class='txt-center'><input type='text' style='width:100%' id='txtRollMasterSeq' value='1' onkeydown='return onlyNumbers(event);'/>";
                    emptyTag += "</td>";
                    emptyTag += "<td class='txt-center'> <select style='height: 26px; ' id='selectRollMasterUse'><option value='N'>예</option> <option value='Y'>아니오</option> </select>";
                    emptyTag += "</td>";
                    emptyTag += "<td class='txt-center'><input type='text' style='width:100%' id='txtRollMasterName'/ >";
                    emptyTag += "</td>";
                    emptyTag += "<td class='txt-center'>";
                    emptyTag += "</td>";
                    emptyTag += "<td class='txt-center'><input type='file' style='width:100%' id='fuRollMasterFile'/ >";
                    emptyTag += "</td>";
                    emptyTag += "<td class='txt-center'><input type='text' style='width:100%' id='txtRollMasterUrl'/ >";
                    emptyTag += "</td>";
                    emptyTag += "<td class='txt-center'><input type='button' class='btnDelete' value='삭제' onclick='fnDeleteTableRow(this, \"'tbodyRollMaster'\"); return false;'/>";
                    emptyTag += "</td>";
                    emptyTag += "</tr>";

                    $("#tbodyRollMaster").append(emptyTag);
                }


                return false;
            }
            var param = {

                Code: $('#txtCode').val(),
                Method: 'GetDistCssMasterRollMaster'

            };


            //type, url, async, cache, data, datatype, _callback, _beforeSend, _complete, issessionCheck, sessionValue
            JqueryAjax('Post', '../../Handler/Common/DistCssHandler.ashx', false, false, param, 'json', callback, null, null, true, '<%=Svid_User%>');
        }

        function fnSaveDiscBanner() {

            if (isEmpty($('#txtCode').val())) {
                alert('배포코드를 검색해 주세요.');
                $('#txtCode').focus();
                return false;
            }
            var json = [];
            var landingJson = [];
            var pg = '';
            var nowDate = new Date();  

            if ($('#rbPGY').is(":checked")) {
                pg = 'Y';
            }
            else if ($('#rbPGN').is(":checked")) {
                pg = 'N';
            }

            var ssl = '';
            if ($('#rbSSLY').is(":checked")) {
                ssl = 'Y';
            }
            else if ($('#rbSSLN').is(":checked")) {
                ssl = 'N';
            }
            $("#tbodyRollMaster tr").each(function () {
                var keySeq = $(this).children().find('#hdRowSeq').val();
                var bannerSeq = $(this).children().find('#txtRollMasterSeq').val();
                var name = $(this).children().find('#txtRollMasterName').val();
                var url = $(this).children().find('#txtRollMasterUrl').val();
                var mainFile = $(this).children().find('input[id*="fuRollMasterFile"]').get(0).files[0];
                var mainFileName = '';
                var mainFilePath = '';
                if (mainFile != null) {
                    var mainFileNameExt = $(this).children().find('input[id*="fuRollMasterFile"]').val().split('.').pop().toLowerCase();
                    mainFileName = 'b' + '-' + nowDate.format('yyMMdd') + '-' + bannerSeq+ '.' + mainFileNameExt;
                    mainFilePath = '/SiteManagement/' + $('#txtCode').val() + '/banner/' + mainFileName;
                }
                var hdBannerMainPath =  $(this).children().find('#hdRollMasterPath').val();
                var delFlag = $(this).children().find('#selectRollMasterUse').val();

                json.push({

                    KeySeq:keySeq,
                    MasterBannerSeq: bannerSeq,
                    MasterName: name,
                    MasterFileName: mainFileName,
                    MasterPath: mainFilePath,
                    MasterUrl : url,
                    Delflag: delFlag,
                    BOldPath: hdBannerMainPath
                });


            });

            
            $("#tbodyLanding tr").each(function () {
                var keySeq = $(this).children().find('#hdCtgyRowSeq').val();
                var seq = $(this).children().find('#txtLandingSeq').val();
                var delFlag = $(this).children().find('#selectLandingUse').val();
                var categoryCode = $(this).children().find('#hdRowCategoryCode').val();
                var brandCode = $(this).children().find('#hdRowBrandCode').val();
                var hdLandingMainPath = $(this).children().find('#hdLandingMainPath').val();
                var hdLandingDetailPath = $(this).children().find('#hdLandingDetailPath').val();
                var mainFile = $(this).children().find('input[id*="fuLandingMainFile"]').get(0).files[0];
                var mainFileName = '';
                var mainFilePath = '';

                if (mainFile != null) {
                    var mainFileNameExt = $(this).children().find('input[id*="fuLandingMainFile"]').val().split('.').pop().toLowerCase();
                    mainFileName = 'cl'+'-'+nowDate.format('yyMMdd')+ '-' + seq +'.' + mainFileNameExt;
                    mainFilePath = '/SiteManagement/' + $('#txtCode').val() + '/CategoryLanding/' + mainFileName;
                }
                var seq = $(this).children().find('#txtLandingSeq').val();
                var detailFile = $(this).children().find('input[id*="fuLandingDetailFile"]').get(0).files[0];
                var detailFileName = '';
                var detailFilePath = '';
                if (detailFile != null) {
                    var detailFileNameExt = $(this).children().find('input[id*="fuLandingDetailFile"]').val().split('.').pop().toLowerCase();
                    detailFileName = 'cld'+'-'+nowDate.format('yyMMdd')+ '-' + seq + '.' + detailFileNameExt;
                    detailFilePath = '/SiteManagement/' + $('#txtCode').val() + '/CategoryLanding/' + detailFileName;
                }
                var url = $(this).children().find('#txtLandingUrl').val();
                landingJson.push({
                    KeySeq:keySeq,
                    LSeq: seq,
                    Delflag: delFlag,
                    CategoryCode: categoryCode,
                    BrandCode: brandCode,
                    LFileName: mainFileName,
                    LFilePath: mainFilePath,
                    LUrl: url,
                    LDFileName: detailFileName,
                    LDFilePath: detailFilePath,
                    LOldPath: hdLandingMainPath,
                    LDOldPath:hdLandingDetailPath,

                });
            });

            var callback = function (response) {

                if (response == 'OK') {
                    alert('저장되었습니다.');
                    fnGetDistMasterBanner();
                    fnGetDistCategoryLanding();
                    
                }
                else {
                    alert('구성중 오류가 생겼습니다. 시스템 관리자에게 문의하세요.');

                }
                return false;
            };

            $.ajax({
                type: "POST",
                url: '../../Handler/Common/DistCssHandler.ashx',
                async: false,
                contentType: false,
                processData: false,
                success: callback,
                data: function () {
                    var data = new FormData();
                    data.append("DCode", $('#txtCode').val());
                    data.append("DName", $('#txtTitle').val());
                    data.append("Url", $('#txtDomain').val());
                    data.append("Gubun", $('#ddlGubun2').val());
                    data.append("GubunInfo", $('#ddlGubun1').val());
                    data.append("PgconfirmYN", pg);
                    data.append("SslYN", ssl);
                    data.append("MasterListData", JSON.stringify(json));
                    data.append("CategoryLandingData", JSON.stringify(landingJson));
                    data.append("Method", 'SaveDistBanner');
                    $("#tbodyRollMaster tr").each(function () {
                        data.append($(this).children().find('#txtRollMasterSeq').val() + 'BFile', $(this).children().find('input[id*="fuRollMasterFile"]').get(0).files[0]);
                    });

                    $("#tbodyLanding tr").each(function () {
                        data.append($(this).children().find('#txtLandingSeq').val() + 'LFile', $(this).children().find('input[id*="fuLandingMainFile"]').get(0).files[0]);
                        data.append($(this).children().find('#txtLandingSeq').val() + 'LDFile', $(this).children().find('input[id*="fuLandingDetailFile"]').get(0).files[0]);
                    });
                    return data;
                }(),
            });
        }

        function fnSaveDiscBannerDetail() {
            var json = [];
            
            $("#tbodyPopupRollDetail tr").each(function () {
               
                var materseq = $('#hdPopupMasterSeq').val();
                var seq = $(this).children().find('#txtSeq').val();
                var oldPath = $(this).children().find('#hdRowPopupPath').val();
                var detailOldPath = $(this).children().find('#hdRowPopupDetailPath').val();
                var defaultYn = $(this).children().find('#chDefaultYN').is(':checked')==true ? 'Y' : 'N';
                var detailName = $(this).children().find('#txtDetailBannerName').val();
                var detailFile = $(this).children().find('input[id*="fuDetailFile"]').get(0).files[0];
                var detailFileName = '';
                var detailFilePath = '';
                
                if (detailFile != null) {
                    var detailFileNameExt = $(this).children().find('input[id*="fuDetailFile"]').val().split('.').pop().toLowerCase();
                    detailFileName = 'banner'+'-'+materseq+'_'+seq+ '.' + detailFileNameExt;
                    detailFilePath = '/SiteManagement/' + $('#txtCode').val() + '/Banner/' + detailFileName;
                }
                 
                var detailUrl = $(this).children().find('#txtDetailDetailUrl').val();


                var detailDetailFile = $(this).children().find('input[id*="fuDetailDetailFile"]').get(0).files[0];
                var detailDetailFileName = '';
                var detailDetailFilePath = '';
                if (detailDetailFile != null) {
                    var detailDetailFileNameExt = $(this).children().find('input[id*="fuDetailDetailFile"]').val().split('.').pop().toLowerCase();
                    detailDetailFileName = 'bannerDetail'+'-'+materseq+'_'+seq+ '.' + detailDetailFileNameExt;
                    detailDetailFilePath = '/SiteManagement/' + $('#txtCode').val() + '/Banner/' + detailDetailFileName;
                }


                var delFlag = $(this).children().find('#selectDetailDelflag').val();

                json.push({
                    MasterSeq: materseq,
                    Seq: seq,
                    DefaultYN: defaultYn,
                    DeTailName: detailName,
                    BannerFileName: detailFileName,
                    BannerFilePath: detailFilePath,
                    BannerUrl: detailUrl,
                    BannerDetailFileName: detailDetailFileName,
                    BannerDetailFilePath: detailDetailFilePath,
                    DOldPath: oldPath,
                    BDOldPath: detailOldPath,
                    Delflag: delFlag,
                });


            });
           
            var callback = function (response) {

                if (response == 'OK') {
                    alert('저장되었습니다.');
                    fnGetDistDetailBanner();
                    
                }
                else {
                    alert('구성중 오류가 생겼습니다. 시스템 관리자에게 문의하세요.');

                }
                return false;
            };
            $.ajax({
                type: "POST",
                url: '../../Handler/Common/DistCssHandler.ashx',
                async: false,
                contentType: false,
                processData: false,
                success: callback,
                data: function () {
                    var data = new FormData();
                    data.append("DCode", $('#txtCode').val());
                    data.append("ListData", JSON.stringify(json));
                    data.append("Method", 'SaveDistBannerDetail');
                    $("#tbodyPopupRollDetail tr").each(function () {
                        data.append($(this).children().find('#txtSeq').val() + 'DFile', $(this).children().find('input[id*="fuDetailFile"]').get(0).files[0]);
                        data.append($(this).children().find('#txtSeq').val() + 'BDFile', $(this).children().find('input[id*="fuDetailDetailFile"]').get(0).files[0]);
                    });
                    return data;
                }(),
            });
        }


        function fnGetDistDetailBanner() {

            var callback = function (response) {
                $("#tbodyPopupRollDetail").empty();
                var newRowContent = '';
                if (!isEmpty(response)) {
                    $.each(response, function (key, value) { //테이블 추가

                        newRowContent += "<tr style='height:60px'>";
                        newRowContent += "<td  style='text-align:center'><input type='hidden' id='hdRowDetailSeq' value='" + value.Seq + "'><input type='text' style='width:100%' value='" + value.Seq + "' id='txtSeq'></input></td>";

                        var selectY = '';
                        var selectN = '';
                       if (value.DelFlag == 'Y') {

                            selectY = 'selected';
                        }
                        else {
                            selectN = 'selected';
                        }
                        newRowContent += "<td style='text-align:center'><select style='height: 26px; ' id='selectDetailDelflag'><option value='N' " + selectN + ">예</option> <option value='Y' " + selectY + ">아니오</option> </select></td>";

                        var defaultYn = '';
                        if (value.DefaultYN == 'Y') {
                            defaultYn = 'checked="checked"';
                        }
                        newRowContent += "<td style='text-align:center'><input type='checkbox' id='chDefaultYN' "+defaultYn+"></td>";
                        newRowContent += "<td style='text-align:center'><input type='text' style='width:100%' value='" + value.DetailName + "' id='txtDetailBannerName'></input></td>";

                        var deleteDetailButton = '';
                        var detailPath = ''
                        if (!isEmpty(value.BannerFileName)) {
                            deleteDetailButton = '&nbsp;&nbsp;<img src="/Admin/Images/icon-delete.jpg"  alt="x" onclick="fnDeleteImage(this,\'ROLLDETAILMAIN\'); return false" id="" style="cursor:pointer;"/>';
                            detailPath = "/SiteManagement/" + $('#txtCode').val() + "/Banner/" + value.BannerFileName;
                        }
                        newRowContent += "<td style='text-align:center'><input type='hidden' id='hdRowPopupPath' value='" + detailPath + "'/><span id='spanPopupname'>" + value.BannerFileName + "</span>" + deleteDetailButton + "</td>";
                        newRowContent += "<td style='text-align:center'><input type='file' id='fuDetailFile'/></td>";

                        var deleteDetailDetailButton = '';
                        var detailDetailPath = ''
                        if (!isEmpty(value.DetailBannerFileName)) {
                            deleteDetailDetailButton = '&nbsp;&nbsp;<img src="/Admin/Images/icon-delete.jpg"  alt="x" onclick="fnDeleteImage(this,\'ROLLDETAILDETAIL\'); return false" id="" style="cursor:pointer;"/>';
                            detailDetailPath = "/SiteManagement/" + $('#txtCode').val() + "/Banner/" + value.DetailBannerFileName;
                        }
                        newRowContent += "<td style='text-align:center'><input type='hidden' id='hdRowPopupDetailPath' value='" + detailDetailPath + "'/><span id='spanPopupname'>" + value.DetailBannerFileName + "</span>" + deleteDetailDetailButton + "</td>";
                        newRowContent += "<td style='text-align:center'><input type='file' id='fuDetailDetailFile'/></td>";


                        newRowContent += "<td style='text-align:center'><input type='text' style='width:100%' value='" + value.BannerUrl + "' id='txtDetailDetailUrl'></input></td>";
                        newRowContent += "<td style='text-align:center'><input type='button' class='btnDelete' value='삭제' onclick='fnDeleteBanner(this,\"ROLLDETAIL\"); return false;'/></td>";
                        newRowContent += "</tr>";

                    });
                    $("#tbodyPopupRollDetail").append(newRowContent);
                }
                else {
                    var emptyTag = '';
                     emptyTag += "<tr style='height:60px'>";
                     emptyTag += '<td class="txt-center"><input type="text" style="width: 100%; height: 22px; font-size: 12px"  id="txtSeq" value="1"/></td>';
                     emptyTag += '<td class="txt-center"><select style="height: 26px; width: 60px;" id="selectDetailDelflag"><option value="N">예</option><option value="Y">아니오</option></select></td>';
                     emptyTag += '<td class="txt-center"><input type="checkbox" id="chDefaultYN"></td>';
                 
                     emptyTag += '<td class="txt-center"><input type="text" style="width: 100%; height: 22px; font-size: 12px" id="txtDetailBannerName"></td>';
                     emptyTag += '<td class="txt-center"></td>';
                     emptyTag += '<td class="txt-center"><input type="file" style="width: 150px; height: 22px; font-size: 12px" id="fuDetailFile"></td>';
                     emptyTag += '<td class="txt-center"></td>';
                     emptyTag += '<td class="txt-center"><input type="file" style="width: 150px; height: 22px; font-size: 12px" id="fuDetailDetailFile"></td>';
                     emptyTag += '<td class="txt-center"><input type="text" style="width:100%; height:22px; font-size:12px;" id="txtDetailDetailUrl"></td>';
                     emptyTag += '<td class="txt-center"><input type="button" class="btnDelete" value="삭제" onclick="fnDeleteTableRow(this, \'tbodyPopupRollDetail\'); return false;"></td>';
                     emptyTag += '</tr>';

                    $("#tbodyPopupRollDetail").append(emptyTag);
                }


                return false;
            }
            var param = {

                Code: $('#txtCode').val(),
                Mseq: $('#hdPopupMasterSeq').val(),
                Method: 'GetDistCssMasterRollDetail'

            };


            //type, url, async, cache, data, datatype, _callback, _beforeSend, _complete, issessionCheck, sessionValue
            JqueryAjax('Post', '../../Handler/Common/DistCssHandler.ashx', false, false, param, 'json', callback, null, null, true, '<%=Svid_User%>');
        }

        function fnGetDistCategoryLanding() {

            var callback = function (response) {
                $("#tbodyLanding").empty();
                var newRowContent = '';
                if (!isEmpty(response)) {
                    var index = 1;
                    $.each(response, function (key, value) { //테이블 추가
                       
                        newRowContent += "<tr id='trLandingRow"+index+"' >";
                        newRowContent += "<td  style='text-align:center'><input type='hidden' id='hdCtgyRowSeq' value='" + value.SeqNo + "'><input type='text' style='width:100%' value='" + value.Seq + "' id='txtLandingSeq'></input></td>";

                        var selectY = '';
                        var selectN = '';
                       if (value.DelFlag == 'Y') {

                            selectY = 'selected';
                        }
                        else {
                            selectN = 'selected';
                        }
                        var categorySet = '';
                        if (!isEmpty(value.CateogoryCode)) {
                            categorySet = value.CateogoryCode + "(" + value.CateogoryName + ")";
                        }

                        var brandSet = '';
                        if (!isEmpty(value.BrandCode)) {
                            brandSet = value.BrandCode + "(" + value.BrandName + ")";
                        }
                        newRowContent += "<td style='text-align:center'><select style='height: 26px; ' id='selectLandingUse'><option value='N' " + selectN + ">예</option> <option value='Y' " + selectY + ">아니오</option> </select></td>";
                        newRowContent += "<td style='text-align:center'><input type='hidden' id='hdRowCategoryCode' value='" + value.CateogoryCode + "'/><input type='text' style='width:130px' value='"+categorySet+"' id='textRowCategoryInfo' readonly='readonly'></input><img src='/Admin/Images/icon-delete.jpg'  alt='x' onclick='fnDeleteText(this, \"Category\"); return false'  style='cursor:pointer;'/> <input type='button' class='btnDelete' value='검색' onclick='fnCategoryPopupOpen(this); return false;'></td>";
                        newRowContent += "<td style='text-align:center'><input type='hidden' id='hdRowBrandCode' value='"+value.BrandCode+"'/><input type='text' style='width:130px' value='" + brandSet+"' id='textRowBrandInfo' readonly='readonly'></input> <img src='/Admin/Images/icon-delete.jpg'  alt='x' onclick='fnDeleteText(this, \"Brand\"); return false'  style='cursor:pointer;'/> <input type='button' class='btnDelete' value='검색' onclick='fnBrandPopupOpen(this); return false;'></td>";

                        var deleteMainButton = '';
                        var mainPath = ''
                        if (!isEmpty(value.PageFileName)) {
                            deleteMainButton = '&nbsp;&nbsp;<img src="/Admin/Images/icon-delete.jpg"  alt="x" onclick="fnDeleteImage(this,\'CATEGORYLANDINGMAIN\'); return false" id="" style="cursor:pointer;"/>';
                            mainPath = "/SiteManagement/" + $('#txtCode').val() + "/CategoryLanding/" + value.PageFileName;
                        }
                        newRowContent += "<td style='text-align:center'><input type='hidden' id='hdLandingMainPath' value='" + mainPath + "'/><span id='spanMainname'>" + value.PageFileName + "</span>" + deleteMainButton + "</td>";
                        newRowContent += "<td style='text-align:center'><input type='file' id='fuLandingMainFile'/></td>";

                        var deleteDetailButton = '';
                        var detailPath = ''
                        if (!isEmpty(value.DetailPageFileName)) {
                            deleteDetailButton = '&nbsp;&nbsp;<img src="/Admin/Images/icon-delete.jpg"  alt="x" onclick="fnDeleteImage(this,\'CATEGORYLANDINGDETAIL\'); return false" id="" style="cursor:pointer;"/>';
                            detailPath = "/SiteManagement/" + $('#txtCode').val() + "/CategoryLanding/" + value.DetailPageFileName;
                        }
                        newRowContent += "<td style='text-align:center'><input type='hidden' id='hdLandingDetailPath' value='" + detailPath + "'/><span id='spanDetailname'>" + value.DetailPageFileName + "</span>" + deleteDetailButton + "</td>";
                        newRowContent += "<td style='text-align:center'><input type='file' id='fuLandingDetailFile'/></td>";


                        newRowContent += "<td style='text-align:center'><input type='text' style='width:100%' value='" + value.PageUrl + "' id='txtLandingUrl'></input></td>";
                        newRowContent += "<td style='text-align:center'><input type='button' class='btnDelete' value='삭제' onclick='fnDeleteBanner(this,\"CATEGORYLANDING\"); return false;'/></td>";
                        newRowContent += "</tr>";
                        index++;
                    });
                    $("#tbodyLanding").append(newRowContent);
                }
                else {
                    var emptyTag = '';
                     emptyTag += "<tr id='trLandingRow1' style='height:60px'>";
                     emptyTag += '<td class="txt-center"><input type="hidden" id="hdCtgyRowSeq" value="0"/><input type="text" style="width: 100%; height: 22px; font-size: 12px"  id="txtLandingSeq" value="1"/></td>';
                     emptyTag += '<td class="txt-center"><select style="height: 26px; width: 60px;" id="selectLandingUse"><option value="N">예</option><option value="Y">아니오</option></select></td>';
                 
                     emptyTag += '<td class="txt-center"><input type="hidden" id="hdRowCategoryCode"/><input type="text" id="textRowCategoryInfo" readonly="readonly" style="width:130px"/><img src="/Admin/Images/icon-delete.jpg"  alt="x" onclick="fnDeleteText(this, \'Category\'); return false"  style="cursor:pointer;"/><input type="button" class="listBtn" value="검색" style="float:right;width: 45px; height: 22px; font-size: 12px" onclick="fnCategoryPopupOpen(this); return false;"></td>';
                     emptyTag += '<td class="txt-center"><input type="hidden" id="hdRowBrandCode"/><input type="text" id="textRowBrandInfo" readonly="readonly" style="width:130px"/><img src="/Admin/Images/icon-delete.jpg"  alt="x" onclick="fnDeleteText(this, \'Brand\'); return false"  style="cursor:pointer;"/><input type="button" class="listBtn" value="검색" style="float:right;width: 45px; height: 22px; font-size: 12px" onclick="fnBrandPopupOpen(this); return false;"></td>';
                     emptyTag += '<td class="txt-center"></td>';
                     emptyTag += '<td class="txt-center"><input type="file" style="width: 150px; height: 22px; font-size: 12px" id="fuLandingMainFile"></td>';
                     emptyTag += '<td class="txt-center"></td>';
                     emptyTag += '<td class="txt-center"><input type="file" style="width: 150px; height: 22px; font-size: 12px" id="fuLandingDetailFile"></td>';
                     emptyTag += '<td class="txt-center"><input type="text" style="width:100%; height:22px; font-size:12px;" id="txtLandingUrl"></td>';
                     emptyTag += '<td class="txt-center"><input type="button" class="btnDelete" onclick="fnDeleteTableRow(this, \'tbodyLanding\'); return false;"></td>';
                     emptyTag += '</tr>';

                    $("#tbodyLanding").append(emptyTag);
                }


                return false;
            }
            var param = {

                Code: $('#txtCode').val(),
                Method: 'GetDistCssCategoryLandingList'

            };


            //type, url, async, cache, data, datatype, _callback, _beforeSend, _complete, issessionCheck, sessionValue
            JqueryAjax('Post', '../../Handler/Common/DistCssHandler.ashx', false, false, param, 'json', callback, null, null, true, '<%=Svid_User%>');
        }

        function fnDeleteBanner(el, type) {

            if (!confirm('데이터가 정말 삭제됩니다. 계속 진행하시겠습니까?')) {
                return false;
            }

            var callback = function (response) {

                if (response == 'OK') {

                    fnGetDistMasterBanner();
                    fnGetDistDetailBanner();
                    fnGetDistCategoryLanding();
                    return false;
                }
                else {
                    alert('삭제중 오류가 생겼습니다. 시스템 관리자에게 문의하세요.');
                    return false;
                }
            }
            var masterSeq = 0;
            var seq = 0;
            var filePath = '';
            var detailFilePath = '';
            if (type == 'ROLLMASTER') {
                masterSeq = $(el).parent().parent().children().find('#hdRowSeq').val();
                filePath = $(el).parent().parent().children().find('#hdRollMasterPath').val();
                
            }
            else if(type=='ROLLDETAIL'){
                masterSeq = $('#hdPopupMasterSeq').val();
                seq = $(el).parent().parent().children().find('#hdRowDetailSeq').val();
                filePath = $(el).parent().parent().children().find('#hdRowPopupPath').val();
                detailFilePath =  $(el).parent().parent().children().find('#hdRowPopupDetailPath').val();
            }

            else if(type=='CATEGORYLANDING'){
                seq = $(el).parent().parent().children().find('#hdCtgyRowSeq').val();
                filePath = $(el).parent().parent().children().find('#hdLandingMainPath').val();
                detailFilePath =  $(el).parent().parent().children().find('#hdLandingDetailPath').val();
            }
            var param = {

                DCode: $('#txtCode').val(),
                MasterSeq: masterSeq,
                Seq : seq,
                Type: type,
                FilePath: filePath,
                DetailFilePath : detailFilePath,
                Method: 'DeleteDistBanner',

            };

            JqueryAjax('Post', '../../Handler/Common/DistCssHandler.ashx', false, false, param, 'text', callback, null, null, true, '<%=Svid_User%>');
            return false;
        }

        function fnRollDetailPopup(masterSeq) {
            $('#hdPopupMasterSeq').val(masterSeq);
            fnGetDistDetailBanner();
            var e = document.getElementById('distCssDetaildiv');


            if (e.style.display == 'block') e.style.display = 'none';
            else e.style.display = 'block';
        }

        function fnEmptyTable(tableid) {
             $("#"+tableid+"").empty();
            var emptyTag = '';

            if (tableid == 'tbodyRollMaster') {
                    emptyTag += "<tr>";
                    emptyTag += "<td class='txt-center'><input type='text' style='width:100%' id='txtRollMasterSeq' value='1' onkeydown='return onlyNumbers(event);'/>";
                    emptyTag += "</td>";
                    emptyTag += "<td class='txt-center'> <select style='height: 26px; ' id='selectRollMasterUse'><option value='N'>예</option> <option value='Y'>아니오</option> </select>";
                    emptyTag += "</td>";
                    emptyTag += "<td class='txt-center'><input type='text' style='width:100%' id='txtRollMasterName'/ >";
                    emptyTag += "</td>";
                    emptyTag += "<td class='txt-center'>";
                    emptyTag += "</td>";
                    emptyTag += "<td class='txt-center'><input type='file' style='width:100%' id='fuRollMasterFile'/ >";
                    emptyTag += "</td>";
                    emptyTag += "<td class='txt-center'><input type='text' style='width:100%' id='txtRollMasterUrl'/ >";
                    emptyTag += "</td>";
                    emptyTag += "<td class='txt-center'><input type='button' class='btnDelete' value='삭제' onclick='fnDeleteTableRow(this, \"'tbodyRollMaster'\"); return false;'/>";
                    emptyTag += "</td>";
                    emptyTag += "</tr>";
            }

            else if (tableid == 'tbodyPopupRollDetail') {
                 emptyTag += "<tr style='height:60px'>";
                 emptyTag += '<td class="txt-center"><input type="text" style="width: 100%; height: 22px; font-size: 12px"  id="txtSeq" value="1"/></td>';
                 emptyTag += '<td class="txt-center"><select style="height: 26px; width: 60px;" id="selectDetailDelflag"><option value="N">예</option><option value="Y">아니오</option></select></td>';
                 emptyTag += '<td class="txt-center"><input type="checkbox" id="chDefaultYN"></td>';
                 
                 emptyTag += '<td class="txt-center"><input type="text" style="width: 100%; height: 22px; font-size: 12px" id="txtDetailBannerName"></td>';
                 emptyTag += '<td class="txt-center"></td>';
                 emptyTag += '<td class="txt-center"><input type="file" style="width: 150px; height: 22px; font-size: 12px" id="fuDetailFile"></td>';
                 emptyTag += '<td class="txt-center"></td>';
                 emptyTag += '<td class="txt-center"><input type="file" style="width: 150px; height: 22px; font-size: 12px" id="fuDetailDetailFile"></td>';
                 emptyTag += '<td class="txt-center"><input type="text" style="width:100%; height:22px; font-size:12px;" id="txtDetailDetailUrl"></td>';
                 emptyTag += '<td class="txt-center"><input type="button" class="btnDelete" value="삭제" onclick="fnDeleteTableRow(this, \'tbodyPopupRollDetail\'); return false;"></td>';
                 emptyTag += '</tr>';
            }

            else if (tableid == 'tbodyLanding') {
                  emptyTag += "<tr id='trLandingRow1' style='height:60px'>";
                  emptyTag += '<td class="txt-center"><input type="hidden" id="hdCtgyRowSeq" value="0"/><input type="text" style="width: 100%; height: 22px; font-size: 12px"  id="txtLandingSeq" value="1"/></td>';
                  emptyTag += '<td class="txt-center"><select style="height: 26px; width: 60px;" id="selectLandingUse"><option value="N">예</option><option value="Y">아니오</option></select></td>';
                  emptyTag += '<td class="txt-center"><input type="hidden" id="hdRowCategoryCode"/><input type="text" id="textRowCategoryInfo" readonly="readonly" style="width:130px"/><img src="/Admin/Images/icon-delete.jpg"  alt="x" onclick="fnDeleteText(this, \'Category\'); return false"  style="cursor:pointer;"/><input type="button" class="listBtn" value="검색" style="float:right;width: 45px; height: 22px; font-size: 12px" onclick="fnCategoryPopupOpen(this); return false;"></td>';
                  emptyTag += '<td class="txt-center"><input type="hidden" id="hdRowBrandCode"/><input type="text" id="textRowBrandInfo" readonly="readonly" style="width:130px"/><img src="/Admin/Images/icon-delete.jpg"  alt="x" onclick="fnDeleteText(this, \'Brand\'); return false"  style="cursor:pointer;"/><input type="button" class="listBtn" value="검색" style="float:right;width: 45px; height: 22px; font-size: 12px" onclick="fnBrandPopupOpen(this); return false;"></td>';
                  emptyTag += '<td class="txt-center"></td>';
                  emptyTag += '<td class="txt-center"><input type="file" style="width: 150px; height: 22px; font-size: 12px" id="fuLandingMainFile"></td>';
                  emptyTag += '<td class="txt-center"></td>';
                  emptyTag += '<td class="txt-center"><input type="file" style="width: 150px; height: 22px; font-size: 12px" id="fuLandingDetailFile"></td>';
                  emptyTag += '<td class="txt-center"><input type="text" style="width:100%; height:22px; font-size:12px;" id="txtLandingUrl"></td>';
                  emptyTag += '<td class="txt-center"><input type="button" class="listBtn" value="삭제" style="width: 55px; height: 22px; font-size: 12px" onclick="fnDeleteTableRow(this, \'tbodyLanding\'); return false;"></td>';
                  emptyTag += '</tr>';
            }
            $("#"+tableid+"").append(emptyTag);
        }

       function fnDeleteImage(el, type) {


            if (!confirm('정말 삭제하시겠습니까?')) {
                return false;
            }

            var callback = function (response) {

                if (response == 'OK') {

                    fnGetDistMasterBanner();
                    fnGetDistCategoryLanding();
                }
                else {
                    alert('시스템 오류입니다 시스템 관리자에게 문의하세요');

                }
                return false;
            }
           var seq = 0;
           var mseq = 0;
           var filePath = '';
           if (type == 'ROLLDETAILMAIN') {

               filePath = $(el).parent().parent().children().find('#hdRollMasterPath').val();
               mseq = $(el).parent().parent().children().find('#hdRowSeq').val();
           }
           else if (type == 'ROLLDETAILDETAIL') {
               filePath = $(el).parent().parent().children().find('#hdRowPopupDetailPath').val();
               seq = $(el).parent().parent().children().find('#txtSeq').val();
               mseq = $('#hdPopupMasterSeq').val();
           }   
           else if (type == 'CATEGORYLANDINGMAIN') {
               seq = $(el).parent().parent().children().find('#hdCtgyRowSeq').val()
               filePath = $(el).parent().parent().children().find('#hdLandingMainPath').val();
               mseq = $('#hdPopupMasterSeq').val();
           }   
           else if (type == 'CATEGORYLANDINGDETAIL') {
               seq = $(el).parent().parent().children().find('#hdCtgyRowSeq').val()
               filePath = $(el).parent().parent().children().find('#hdLandingDetailPath').val();
               mseq = $('#hdPopupMasterSeq').val();
           }   
            var param = {


                DCode: $('#txtCode').val(),
                MSeq : mseq,
                Seq: seq,
                DeleteFilePath: filePath,
                Type: type,
                Method: 'DeleteDistBannerImg'

            };

            //type, url, async, cache, data, datatype, _callback, _beforeSend, _complete, issessionCheck, sessionValue
            JqueryAjax('Post', '../../Handler/Common/DistCssHandler.ashx', false, false, param, 'text', callback, null, null, true, '<%=Svid_User%>');
        }


        //브랜드검색 팝업창 열기
        function fnBrandPopupOpen(el) {
            var e = document.getElementById('brandDiv');

                if (e.style.display == 'block') {
                    e.style.display = 'none';

                } else {
                    e.style.display = 'block';
                    $('#hdLandingRowId').val($(el).parent().parent().attr('id'));
                    fnBrandSearch(1);

                }
                return false;
        }
        // 브랜드검색 팝업창에서 검색 버튼 클릭 시
        function fnBrandSearch(pageNo) {
            // 초기화
            $("#pop_brandTbody").empty();
            //$("#hdSelectBrand").val('');
            var sUser = '<%=Svid_User %>';
            var searchTarget = $('#selectBrandSearchTarget').val();
            var txtSearch = $('#txtPopupBrandSearch').val();

            var callback = function (response) {
                var returnVal = false;
               
                
                if (!isEmpty(response)) {

                    var listTag = "";

                    $.each(response, function (key, value) {
                        $('#hdBrandTotalCount').val(value.TotalCount);
                        listTag += "<tr>"
                            + "<td class='txt-center'><input type='hidden' name='hdRowBrandName' value='" + value.BrandName + "' /><input type='hidden' name='hdRowBrandCode' value='" + value.BrandCode + "' />" + value.BrandCode + "</td>"
                            + "<td style='padding-left:5px;'>" + value.BrandName + "</td>"
                            + "</tr>";
                    });

                    $("#pop_brandTbody").append(listTag);

                } else {
                    var emptyTag = "<tr><td colspan='3' class='txt-center'>조회된 브랜드가 없습니다.</td></tr>";

                    $("#pop_brandTbody").append(emptyTag);
                }
                fnCreatePagination('brandpagination', $("#hdBrandTotalCount").val(), pageNo, 15, getBrandPageData);
                return false;
            };


            param = { SvidUser: sUser, Method: 'BrandList_Admin', SearchKeyword: txtSearch, SearchTarget: searchTarget, PageNo: pageNo, PageSize: 15 };
            JqueryAjax('Post', '../../Handler/Common/BrandHandler.ashx', true, false, param, 'json', callback, null, null, true, '<%=Svid_User%>');
        }

        function getBrandPageData() {
            var container = $('#brandpagination');
            var getPageNum = container.pagination('getSelectedPageNum');
            fnBrandSearch(getPageNum);
            return false;
        }

        function fnBrandConfirm() {
            var rowid = $('#hdLandingRowId').val();
            var brandCode = $("#hdPopupSelectBrandCode").val();
            var brandName = $("#hdPopupSelectBrandName").val();
            $('#' + rowid).children().find('#textRowBrandInfo').val(brandCode + ' (' + brandName + ')');
            $('#' + rowid).children().find('#hdRowBrandCode').val(brandCode)
            fnClosePopup('brandDiv');
            return false;
        }

        //브랜드검색 팝업창 열기
        function fnCategoryPopupOpen(el) {
            var e = document.getElementById('categoryDiv');

                if (e.style.display == 'block') {
                    e.style.display = 'none';

                } else {
                    e.style.display = 'block';
                    $('#hdLandingRowId').val($(el).parent().parent().attr('id'));
                    fnCategoryBind();

                }
                return false;
        }

        //카테고리 리스트 바인드(레벨1)
        function fnCategoryBind() {
            fnSelectBoxClear(1);
            fnSelectBoxClear(2);
            fnSelectBoxClear(3);
            fnSelectBoxClear(4);
            fnSelectBoxClear(5);
            var callback = function (response) {

                if (!isEmpty(response)) {

                    var ddlHtml = "";

                    $.each(response, function (key, value) {

                        ddlHtml += '<option value="' + value.CategoryFinalCode + '">' + value.CategoryFinalName + '</option>';
                    });


                    $("#Category01").append(ddlHtml);

                }
                return false;
            };

            var sUser = '<%=Svid_User %>';
            var param = {
                LevelCode: '1',
                UpCode: '',
                Method: 'GetCategoryLevelList'
            };
            JqueryAjax('Post', '../../Handler/Common/CategoryHandler.ashx', true, false, param, 'json', callback, null, null, true, '<%=Svid_User%>');

        }

        //카테고리
        function fnChangeSubCategoryBind(el, level) {

            var selectedVal = $(el).val();
            var selectedText = $(el).find('option:selected').text();
            for (var i = level; i < 10; i++) {
                fnSelectBoxClear(i);
            }

            var callback = function (response) {

                if (!isEmpty(response)) {

                    var ddlHtml = "";
                    var caLevel = "";

                    $.each(response, function (key, value) {
                        ddlHtml += '<option value="' + value.CategoryFinalCode + '">' + value.CategoryFinalName + '</option>';
                        caLevel += value.CategoryFinalCode;

                    });

                    var id = '';

                    if (level == '10') {
                        id = level;
                    }
                    else {
                        id = '0' + level;
                    }
                    $("#Category" + id).append(ddlHtml);

                }
                return false;
            };

            var sUser = '<%=Svid_User %>';
            var param = {
                LevelCode: level,
                UpCode: selectedVal,
                Method: 'GetCategoryLevelList'
            };

            $("#txtCaLevel" + level).val(selectedVal);
            $("#hdPopupSelectCategoryCode").val(selectedVal);
            $("#hdPopupSelectCategoryName").val(selectedText);
            var applyLevel1 = $("#txtCaLevel1").val();
            var applyLevel2 = $("#txtCaLevel2").val();          //레벨1
            var applyLevel3 = $("#txtCaLevel3").val();          //레벨2
            var applyLevel4 = $("#txtCaLevel4").val();          //레벨3
            var applyLevel5 = $("#txtCaLevel5").val();          //레벨4




           JqueryAjax('Post', '../../Handler/Common/CategoryHandler.ashx', true, false, param, 'json', callback, null, null, true, '<%=Svid_User%>');

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
            $("#Category" + id).empty();
            //if (id != 1) {
            //    $("#Category" + id).append('<option value="All">---전체---</option>');
            //}
            $("#Category" + id).append('<option value="All">---전체---</option>');
            return false;

        }

        function fnCategoryConfirm() {
             var rowid = $('#hdLandingRowId').val();
            var code = $("#hdPopupSelectCategoryCode").val();
            var name = $("#hdPopupSelectCategoryName").val();
            $('#' + rowid).children().find('#textRowCategoryInfo').val(code + ' (' + name + ')');
            $('#' + rowid).children().find('#hdRowCategoryCode').val(code)
            fnClosePopup('categoryDiv');
            return false;
        }

        function fnDeleteText(el, type) {

            if (type == 'Category') {
                $(el).parent().find('#textRowCategoryInfo').val('');
                $(el).parent().find('#hdRowCategoryCode').val('');
            }
            else if (type == 'Brand') {
                $(el).parent().find('#textRowBrandInfo').val(''); 
                $(el).parent().find('#hdRowBrandCode').val('');
            }
            return false;
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div class="all">
        <div class="sub-contents-div">
            <!--제목타이틀 영역-->
            <div class="sub-title-div">
                <p class="p-title-mainsentence">
                    사이트 관리
                    <span class="span-title-subsentence"></span>
                </p>
            </div>
            <!--기본사항 영역 시작-->
            <div class="search-div">
                <div class="admin-maincontents-subtitle">
                    <span>*기본 설정</span>
                </div>
                <table class="tbl_main">
                    <tr>
                        <th>회사검색
                        </th>
                        <td>
                            <input type="text" id="txtCompSearch" style="width: 150px;">
                            <input type="button" class="mainbtn type1" value="검색" style="width: 75px; height: 25px; font-size: 12px" onclick="fnSearchCompanyPopup(); return false;">
                        </td>
                        <th>배포코드
                        </th>
                        <td>
                            <input type="text" style="width: 150px;" id="txtCode">
                            <input type="button" class="mainbtn type1" value="검색" style="width: 75px; height: 25px; font-size: 12px" onclick="fnDistPopup(); return false;">
                            <input type="button" class="mainbtn type1" value="신규생성" style="width: 75px; height: 25px; font-size: 12px" onclick="fnSetNextCode(); return false;">
                            <input type="button" id="btnSaveDefault" class="mainbtn type1" value="기본설정 저장" style="display:none;  width:105px; height:25px; font-size:12px" onclick="fnSaveDefault(); return false;">
                        </td>
                    </tr>

                    <tr>
                        <th>회사명
                        </th>
                        <td>
                            <p id="lblCompName"></p>
                        </td>
                        <th>배포관리명
                        </th>
                        <td>
                            <input type="text" style="width: 150px;" id="txtTitle">
                        </td>
                    </tr>
                    <tr>
                        <th>회사구분
                        </th>
                        <td>
                            <select style="height: 26px; width: 150px;" id="ddlGubun1">
                                <option value="1">소셜위드</option>
                                <option value="2">SCM</option>
                                <option value="3">복지몰</option>
                            </select>

                            <select style="height: 26px; width: 150px;" id="ddlGubun2">
                                <option value="2">판매사</option>
                                <option value="1">구매사</option>
                                <option value="3">그룹G</option>
                                <option value="4">관리자</option>
                            </select>
                        </td>
                        <th>도메인 주소
                        </th>
                        <td>
                            <input type="text" style="width: 350px;" id="txtDomain">
                        </td>
                    </tr>
                    <tr>
                        <th>PG심사여부
                        </th>
                        <td>
                            <input type="radio" id="rbPGN" name="radiopg">완료
                            <input type="radio" id="rbPGY" name="radiopg">심사중
                        </td>
                        <th>SSL적용여부
                        </th>
                        <td>
                            <input type="radio" id="rbSSLY" name="radiossl">적용
                              <input type="radio" id="rbSSLN" name="radiossl">미적용
                        </td>
                    </tr>
                </table>
            </div>

            <!--버튼영역-->
            <div id="divBtn" class="btn-div" style="display:none; text-align:right; width:100%;padding-top:25px">
                <input type="button" class="mainbtn type1" style="width: 95px; height: 30px; font-size: 12px" value="저장" onclick="return fnSaveDiscBanner();" />
                <input type="button" class="mainbtn type1" style="width: 155px; height: 30px; font-size: 12px" value="타사이트에 복사하기" onclick="return fnOpenCopy();" />
            </div>
            <!--탭영역-->
            <div id="divTab" class="div-main-tab" style="width: 100%; display:none">
                <ul>
                    <li class='tabOff' style="width: 185px;">
                        <a id="tabDefault">배포기본</a>
                     </li>
                    <li class='tabOff' style="width: 185px;">
                         <a id="tabPopup">배포팝업</a>
                    </li>
                    <%--<li class='tabOff' style="width: 185px;" >
                        <a id="tabMenu">배포메뉴</a>
                    </li>--%>
                    <li class='tabOn' style="width: 185px;" >
                         <a id="tabBanner">배포배너</a>
                    </li>
                    <li class='tabOff' style="width: 185px;" >
                        <a id="tabPartner">배포기관</a>
                    </li>
                </ul>
            </div>
            <!--기본사항 영역 시작-->
          
                  
                    <div style="margin-top: 50px;" class="search-div">
                        <input type="hidden" id="hdMasterRollNextSeq" />
                         <div id="divMain" class="admin-maincontents" style="display:none">
                            <div class="admin-maincontents-subtitle">
                                <span>*메인 롤링배너 그룹 설정</span>
                            </div>

                            <table class="tbl_main">
                                <thead>
                                    <tr>
                                        <th style="width:60px">구분</th>
                                        <th style="width:100px">사용유무</th>
                                        <th style="width:auto">메인 롤링배너 그룹명</th>
                                        <th style="width:200px">파일명</th>
                                        <th style="width:200px">이미지업로드</th>
                                        <th style="width:400px">URL</th>
                                        <th><input type='button' class='btnDelete' value='추가' onclick='fnAddTableRow(this,"tbodyRollMaster"); return false;' /></th>
                                    </tr>
                                </thead>
                                <tbody id="tbodyRollMaster">
                                    <tr>
                                        <td style="text-align: center;">
                                            <input type='text' style='width:100%' id='txtRollMasterSeq' value='1' onkeydown='return onlyNumbers(event);'/>
                                        </td>
                                        <td style="text-align: center;">
                                            <select style="height: 26px; " id='selectRollMasterUse'>
                                                <option value="1">예</option>
                                                <option value="2">아니오</option>
                                            </select>
                                        </td>
                                        <td style="text-align: center;">
                                           <input type='text' style='width:100%' id='txtRollMasterName'/ >
                                        </td>
                                         <td></td>
                                        <td class="txt-center">
                                            <input type="file" id="fuRollMasterFile"/>
                                        </td>
                                        <td style="text-align: center;">
                                            <input type='text' style='width:100%' id='txtRollMasterUrl'/>
                                        </td>
                                        <td style="text-align: center;">
                                            <input type="button" class="btnDelete" value="삭제" onclick='fnDeleteTableRow(this, "tbodyRollMaster"); return false;'>
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                            

                            <div class="admin-maincontents-subtitle">
                                <span>*랜딩페이지 설정 (ss사이즈(한줄 4개) :307*340&nbsp;&nbsp;&nbsp;//&nbsp;&nbsp;&nbsp; s사이즈(한줄 3개) : 412*340 &nbsp;&nbsp;&nbsp;//&nbsp;&nbsp;&nbsp; m사이즈(한줄 2개) : 623*340 &nbsp;&nbsp;&nbsp;//&nbsp;&nbsp;&nbsp; l사이즈(한줄 1개) : 1256 *340)</span>
                            </div>
                            <input type="hidden" id="hdLandingRowId" />
                            <input type="hidden" id="hdCtgrLandingNextSeq" />
                            <div style="width:100%;">
                                <table class="tbl_main">
                                <thead>
                                    <tr>
                                        <th style="width:80px">구분</th>
                                        <th style="width:120px">사용유무</th>
                                        <th style="width:250px">카테고리</th>
                                        <th style="width:250px">브랜드</th>
                                        <th style="width:150px">메인 파일명</th>
                                        <th style="width:120px">메인 이미지 업로드</th>
                                        <th style="width:150px">링크 파일명</th>
                                        <th style="width:120px">링크 이미지 업로드</th>
                                        <th style="width:120px">Url</th>
                                        <th><input type='button' class='btnDelete' value='추가' onclick='fnAddTableRow(this,"tbodyLanding"); return false;' /></th>
                                    </tr>
                                </thead>
                                <tbody id="tbodyLanding">
                                    <tr id="trLandingRow1">
                                        <td style="text-align: center;">
                                            <input type='text' style='width:100%' id='txtLandingSeq' value='1' onkeydown='return onlyNumbers(event);'/>
                                        </td>
                                        <td style="text-align: center;">
                                            <select style="height: 26px; " id='selectLandingUse'>
                                                <option value="N">예</option>
                                                <option value="Y">아니오</option>
                                            </select>
                                        </td>
                                        <td style="text-align: center;">
                                           <input type="hidden" id="hdRowCategoryCode"/>
                                           <input type="text" id="textRowCategoryInfo" readonly="readonly" style="width:130px"/>
                                           <img src='/Admin/Images/icon-delete.jpg'  alt='x' onclick='fnDeleteText(this, "Category"); return false'  style='cursor:pointer;'/>
                                           <input type="button" class="btnDelete" value="검색" onclick='fnCategoryPopupOpen(this); return false;'>
                                        </td>
                                        <td style="text-align: center;">
                                           <input type="hidden" id="hdRowBrandCode"/>
                                           <input type="text" id="textRowBrandInfo" readonly="readonly" style="width:130px"/>
                                             <img src='/Admin/Images/icon-delete.jpg'  alt='x' onclick='fnDeleteText(this, "Brand"); return false'  style='cursor:pointer;'/>
                                           <input type="button" class="btnDelete" value="검색" onclick="fnBrandPopupOpen(this); return false"'>
                                        </td>
                                        <td></td>
                                        <td class="txt-center">
                                            <input type="file" id="fuLandingMainFile"/>
                                        </td>
                                        <td>

                                        </td>
                                        <td class="txt-center">
                                            <input type="file" id="fuLandingDetailFile"/>
                                        </td>
                                        <td style="text-align: center;">
                                            <input type='text' style='width:100%' id='txtLandingUrl'/>
                                        </td>
                                        <td style="text-align: center;">
                                            <input type="button" class="btnDelete" value="삭제" onclick='fnDeleteTableRow(this, "tbodyRollMaster"); return false;'>
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                            </div>
                            

                        </div>
                    </div>
                </div>
            </div>
            
            <%--메인 롤링배너 개별 설정 팝업--%>
            <div id="distBannDetaildiv" class="popupdiv divpopup-layer-package">
                <div class="popupdivWrapper" style="width: 650px; height: 730px">
                    <div class="popupdivContents">

                        <div class="close-div">
                            <a onclick="fnClosePopup('distCssdiv'); return false;" style="cursor: pointer">
                                <img src="../../Images/Wish/icon-delete.jpg" alt="닫기" style="float: right;" /></a>
                        </div>
                        <div class="popup-title">
                            <h3 class="pop-title">메인 롤링배너 개별 설정</h3>
                        </div>



                        <div class="divpopup-layer-conts">
                            <table class="tbl_main tbl_pop">
                                <thead>
                                    <tr>
                                        <th style="width:32px">구분</th>
                                        <th style="width:70px">사용유무</th>
                                       <%-- <th style="width:70px">그룹 지정명</th>--%>
                                        <th style="width:40px;">개별<br />순번</th>
                                        <th style="width:40px;">대표<br />롤링</th>
                                        <th style="width:134px">타이틀명</th>
                                        <th>메인 파일명</th>
                                        <th>메인 이미지 업로드</th>
                                        <th>링크 파일명</th>
                                        <th>링크 이미지 업로드</th>
                                        <th>링크 URL</th>
                                        <%--<th style="width:60px">설정</th>--%>
                                    </tr>
                                </thead>
                                <tbody id="tblPopupBannDtl">
                                    <tr style="height: 60px;">
                                        <td style="text-align: center;">1</td>
                                        <td style="text-align: center;">
                                            <select style="height: 26px; width: 60px;">
                                                <option value="N">예</option>
                                                <option value="Y">아니오</option>
                                            </select>
                                        </td>
                                        <%--<td style="text-align: center;">
                                            <select style="height: 26px; width: 90px;">
                                                <option value="1">이거사시오</option>
                                                <option value="2">아니오</option>
                                            </select>
                                        </td>--%>
                                        <td style="text-align: center;">
                                            <input type="text" style="width: 25px; height: 22px; font-size: 12px">
                                        </td>
                                        <td style="text-align: center;">
                                            <input type="checkbox">
                                        </td>
                                        <td>
                                            <input type="text" style="width: 130px; height: 22px; font-size: 12px">
                                        </td>
                                        <td style="text-align: center;">A.png
                                        </td>
                                        <td>
                                            <input type="file" style="width: 150px; height: 22px; font-size: 12px">
                                        </td>
                                        <td style="text-align: center;">B.png
                                        </td>
                                        <td>
                                            <input type="file" style="width: 150px; height: 22px; font-size: 12px">
                                        </td>
                                        <td>
                                            <input type="text" style="width:160px; height:22px; font-size:12px;">
                                        </td>
                                        <%--<td>
                                            <input type="button" class="listBtn" value="추가" style="width: 61px; height: 22px; font-size: 12px; margin-bottom:5px">
                                            <input type="button" class="listBtn" value="삭제" style="width: 61px; height: 22px; font-size: 12px">
                                        </td>--%>
                                    </tr>
                                </tbody>
                            </table>
                            <br />
                            <!-- 페이징 처리 -->
                            <div style="margin: 0 auto; text-align: center; padding-top: 10px">
                                <input type="hidden" id="hdPopBannTotalCount" />
                                <div id="popBannPagination" class="page_curl" style="display: inline-block"></div>
                            </div>
                        </div>

                        <div style="text-align: right; margin-top: 10px;">
                            <input type="button" class="mainbtn type1" style="width: 95px; height: 30px; font-size: 12px" value="확인" onclick="fnDistConfirm(); return false;" />
                        </div>

                    </div>
                </div>
            </div>


            <%--회사 검색 팝업--%>
            <div id="searchCompdiv" class="popupdiv divpopup-layer-package">
                <div class="popupdivWrapper" style="width: 650px; height: 730px">
                    <div class="popupdivContents">

                        <div class="close-div">
                            <a onclick="fnClosePopup('searchCompdiv'); return false;" style="cursor: pointer">
                                <img src="../../Images/Wish/icon-delete.jpg" alt="닫기" style="float: right;" /></a>
                        </div>
                        <div class="popup-title">
                            <h3 class="pop-title">회사검색</h3>
                        </div>


                        <div class="search-div" style="margin-bottom: 20px;">
                            <select style="width: 150px; height: 26px" id="selectGubun">
                                <option value="SU">판매사</option>
                                <option value="BU">구매사</option>
                            </select>
                            <input type="text" class="" id="txtPopSearchComp" onkeypress="return fnPopupEnter();" style="width: 300px; height: 26px" />
                            <input type="button" class="mainbtn type1" style="width: 75px; height: 25px; font-size: 12px" value="검색" onclick="fnSearchCompanyList(1); return false;" />
                        </div>


                        <div class="divpopup-layer-conts">
                            <input type="hidden" id="hdSelectCode" />
                            <input type="hidden" id="hdSelectName" />
                            <input type="hidden" id="hdSelectGubun" />
                            <table class="tbl_main tbl_pop">
                                <thead>
                                    <tr>
                                        <th class="text-center" style="width: 40%">회사코드</th>
                                        <th class="text-center">회사명</th>
                                    </tr>
                                </thead>
                                <tbody id="tblPopupComp">
                                    <tr>
                                        <td colspan="2" class="text-center">리스트가 없습니다.</td>
                                    </tr>
                                </tbody>
                            </table>
                            <br />
                            <!-- 페이징 처리 -->
                            <div style="margin: 0 auto; text-align: center; padding-top: 10px">
                                <input type="hidden" id="hdTotalCount" />
                                <div id="pagination" class="page_curl" style="display: inline-block"></div>
                            </div>
                        </div>

                        <div class="btn_center">
                            <input type="button" class="mainbtn type1" style="width:75px;" value="확인" onclick="fnConfirm(); return false;" />
                        </div>

                    </div>
                </div>
            </div>

            <%--배포코드 검색 팝업--%>
            <div id="distCssdiv" class="popupdiv divpopup-layer-package">
                <div class="popupdivWrapper" style="width: 650px; height: 730px">
                    <div class="popupdivContents">

                        <div class="close-div">
                            <a onclick="fnClosePopup('distCssdiv'); return false;" style="cursor: pointer">
                                <img src="../../Images/Wish/icon-delete.jpg" alt="닫기" style="float: right;" /></a>
                        </div>
                        <div class="popup-title" style="margin-top: 20px;">
                            <h3 class="pop-title">배포코드 검색</h3>
                        </div>



                        <div class="divpopup-layer-conts">
                            <input type="hidden" id="hdSelectDistCssCode" />
                            <input type="hidden" id="hdSelectDistCssName" />
                            <input type="hidden" id="hdDistCssCode" />
                            <table class="tbl_main tbl_pop">
                                <thead>
                                    <tr>
                                        <th class="text-center" style="width: 25%">배포코드</th>
                                        <th class="text-center" style="width: 25%">배포명</th>
                                        <th class="text-center" style="width: 25%">수정날짜</th>
                                        <th class="text-center" style="width: 25%">삭제여부</th>
                                    </tr>
                                </thead>
                                <tbody id="tblPopupDist">
                                    <tr>
                                        <td colspan="4" class="text-center">리스트가 없습니다.</td>
                                    </tr>
                                </tbody>
                            </table>
                            <br />
                            <!-- 페이징 처리 -->
                            <div style="margin: 0 auto; text-align: center; padding-top: 10px">
                                <input type="hidden" id="hdDistTotalCount" />
                                <div id="distPagination" class="page_curl" style="display: inline-block"></div>
                            </div>
                        </div>

                        <div class="btn_center">
                            <input type="button" value="확인" style="width:75px" class="mainbtn type1" onclick="fnDistConfirm(); return false;">
                        </div>

                    </div>
                </div>
            </div>


            <%--배포코드 검색 팝업(복사용)--%>
            <div id="distCssCopydiv" class="popupdiv divpopup-layer-package">
                <div class="popupdivWrapper" style="width: 650px; height: 730px">
                    <div class="popupdivContents">
                        <input type="hidden" id="hdCopyCodes" />
                        <div class="close-div">
                            <a onclick="fnClosePopup('distCssCopydiv'); return false;" style="cursor: pointer">
                                <img src="../../Images/Wish/icon-delete.jpg" alt="닫기" style="float: right;" /></a>
                        </div>
                        <div class="popup-title">
                            <h3 class="pop-title">배포코드 검색</h3>
                        </div>

                        <div class="search-div" style="margin-bottom: 20px;">
                            <select id="selectPopupDistCopyTarget" style="height: 26px; width: 150px; vertical-align: middle">
                                <option value="2" selected="selected">판매사
                                </option>
                                <option value="1">구매사
                                </option>
                            </select>
                            <input type="text" class="text-code" id="txtPopSearchDistCopy" placeholder="검색어를 입력하세요" onkeypress="return fnPopupCopyEnter();" style="width: 300px" />
                            <input type="button" class="mainbtn type1" style="width: 95px; height: 30px; font-size: 12px" value="검색" onclick="fnDistCopyList(1); return false;" />
                        </div>
                        <div>
                            <input type="checkbox" id="cbCopyDefault" />기본
                    <input type="checkbox" id="cbCopyLogin" />로그인 페이지
                    <input type="checkbox" id="cbCopyPopup" />팝업
                    <input type="checkbox" id="cbCopyMenu" />메뉴
                    <input type="checkbox" id="cbCopyBanner" />배너
                    <input type="checkbox" id="cbCopyCategory" />카테고리 랜딩
                    <input type="checkbox" id="cbCopyPartner" />기관
                        </div>
                        <div class="divpopup-layer-conts">
                            <table class="tbl_main tbl_popup" style="margin-top: 0; width: 100%">
                                <thead>
                                    <tr>
                                        <th class="text-center" style="width: 5%">
                                            <input type="checkbox" id="cbCheckAllCopy" onclick="fnSelectAll(this);" /></th>
                                        <th class="text-center" style="width: 15%">배포코드</th>
                                        <th class="text-center" style="width: 20%">배포명</th>
                                        <th class="text-center" style="width: 20%">구매사코드</th>
                                        <th class="text-center" style="width: 20%">구매사명</th>
                                        <th class="text-center" style="width: 20%">삭제여부</th>
                                    </tr>
                                </thead>
                                <tbody id="tblPopupDistCopy">
                                    <tr>
                                        <td colspan="6" class="text-center">리스트가 없습니다.</td>
                                    </tr>
                                </tbody>
                            </table>
                            <br />
                            <!-- 페이징 처리 -->
                            <div style="margin: 0 auto; text-align: center; padding-top: 10px">
                                <input type="hidden" id="hdDistCopyTotalCount" />
                                <div id="distCopyPagination" class="page_curl" style="display: inline-block"></div>
                            </div>
                        </div>

                        <div style="text-align: right; margin-top: 10px;">
                            <input type="button" class="mainbtn type1" style="width: 95px; height: 30px; font-size: 12px" value="저장" onclick="fnDistCopySave(); return false;" />
                        </div>

                    </div>
                </div>
            </div>

    <%--배너 상세 등록--%>
            <div id="distCssDetaildiv" class="popupdiv divpopup-layer-package">
                <div class="popupdivWrapper" style="width: 1350px; height: 630px">
                    <div class="popupdivContents">
                       <input type="hidden" id="hdPopupMasterSeq" />
                        <div class="close-div">
                            <a onclick="fnClosePopup('distCssDetaildiv'); return false;" style="cursor: pointer">
                                <img src="../../Images/Wish/icon-delete.jpg" alt="닫기" style="float: right;" /></a>
                        </div>
                        <div class="popup-title">
                            <h3 class="pop-title">상세 등록</h3>
                        </div>

                        <div class="divpopup-layer-conts">
                            <table class="tbl_popup" style="margin-top: 0; width: 100%">
                                <thead>
                                     <tr>
                                        <th style="width:50px">순서
                                        </th>
                                        <th style="width:70px">사용<br />유무
                                        </th>
                                        <th style="width:40px;">대표<br />롤링
                                        </th>
                                        <th style="width:200px">타이틀명
                                        </th>
                                        <th style="width:200px">메인 파일명
                                        </th>
                                        <th style="width:164px">메인 이미지 업로드
                                        </th>
                                        <th style="width:200px">링크 파일명
                                        </th>
                                        <th style="width:164px">링크 이미지 업로드
                                        </th>
                                        <th style="width:200px">링크 URL
                                        </th>
                                         <th style="width:70px" class="txt-center">
                                             <input type='button' class='btnDelete' value='추가' onclick='fnAddTableRow(this,"tbodyPopupRollDetail"); return false;' />
                                        </th>
                                    </tr>
                                </thead>
                                <tbody id="tbodyPopupRollDetail">
                                    <tr style="height: 60px;">
                                        <td class="txt-center">
                                            <input type="text" style="width: 100%; height: 22px; font-size: 12px" value="1" id="txtSeq"/>
                                        </td>
                                        <td style="text-align: center;">
                                            <select style="height: 26px; width: 60px;" id="selectDetailDelflag">
                                                <option value="N">예</option>
                                                <option value="Y">아니오</option>
                                            </select>
                                        </td>
                                        
                                        <td style="text-align: center;">
                                            <input type="checkbox" id="chDefaultYN">
                                        </td>
                                        <td style="text-align: center;">
                                            <input type="text" style="width: 100%; height: 22px; font-size: 12px" id="txtDetailBannerName">
                                        </td>
                                        <td class="txt-center">
                                        </td>
                                        <td>
                                            <input type="file" style="width: 150px; height: 22px; font-size: 12px" id="fuDetailFile">
                                        </td>
                                        <td class="txt-center">
                                        </td>
                                        <td>
                                            <input type="file" style="width: 150px; height: 22px; font-size: 12px" id="fuDetailDetailFile">
                                        </td>
                                        <td class="txt-center">
                                            <input type="text" style="width:100%; height:22px; font-size:12px;" id="txtDetailDetailUrl">
                                        </td>
                                        <td class="txt-center">
                                             <input type="button" class="btnDelete" value="삭제" onclick='fnDeleteTableRow(this, "tbodyPopupRollDetail"); return false;'>
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>

                        <div style="text-align: right; margin-top: 10px;">
                            <input type="button" class="mainbtn type1" style="width: 95px; height: 30px; font-size: 12px" value="저장" onclick="fnSaveDiscBannerDetail(); return false;" />
                        </div>

                    </div>
                </div>
            </div>

    <!--팝업창영역 시작-->
    <div id="brandDiv" class="popupdiv divpopup-layer-package">
        <div class="popupdivWrapper" style="width: 595px; height:650px">
            <div class="popupdivContents">
                <div class="close-div">
                    <a onclick="fnClosePopup('brandDiv'); return false;" style="cursor: pointer">
                        <img src="../../Images/Wish/icon-delete.jpg" alt="닫기" style="float: right;" /></a>
                </div>
                <div class="popup-title">
                    <h3 class="pop-title">브랜드 검색</h3>
                </div>
                <div class="divpopup-layer-conts">
                    <input type="hidden" id="hdPopupSelectBrandCode" />
                    <input type="hidden" id="hdPopupSelectBrandName" />
                    
                    <div class="search-sub-div1">
                        <select style="width: 150px; height: 26px" id="selectBrandSearchTarget">
                            <option value="CODE">브랜드 코드</option>
                            <option value="NAME">브랜드 명</option>
                        </select>
                        <input type="text" id="txtPopupBrandSearch" placeholder="검색어를 입력하세요" class="search1" style="padding-left: 5px;" />
                        <input type="button" class="mainbtn type1" style="width:75px;" value="확인" onclick="fnBrandSearch(1)"/>
                    </div>

                    <div class="divpopup-layer-conts">
                        <table class="tbl_main tbl_pop">
                            <thead>
                                <tr>
                                    <th style="width: 150px">코드</th>
                                    <th>브랜드</th>
                                </tr>
                            </thead>
                            <tbody id="pop_brandTbody">
                            </tbody>
                        </table>
                    </div>
                    <br />

                    <!--페이징-->
                    <input type="hidden" id="hdBrandTotalCount" />
                    <div style="margin: 0 auto; text-align: center">
                        <div id="brandpagination" class="page_curl" style="display: inline-block"></div>
                    </div>
                    <!--팝업 컨텐츠 영역끝-->

                </div>
            </div>
            <br />
            <!--팝업 확인 버튼 영역 시작-->
            <div class="btn_center">
                <input type="button" class="mainbtn type1" style="width:75px;" value="확인" onclick="fnBrandConfirm(); return false;" />
            </div>
            <!--팝업 확인 버튼 영역 끝-->
        </div>
    </div>

    <div id="categoryDiv" class="popupdiv divpopup-layer-package">
        <div class="popupdivWrapper" style="width: 1200px; height:300px">
            <div class="popupdivContents">
                <div class="close-div">
                    <a onclick="fnClosePopup('categoryDiv'); return false;" style="cursor: pointer">
                        <img src="../../Images/Wish/icon-delete.jpg" alt="닫기" style="float: right;" /></a>
                </div>
                <div class="popup-title">
                    <h3 class="pop-title">카테고리 검색</h3>
                </div>
                <div class="divpopup-layer-conts">
                    <input type="hidden" id="hdPopupSelectCategoryCode" />
                    <input type="hidden" id="hdPopupSelectCategoryName" />
                    <div class="popup-div">
                        <table class="tbl_main">
                            <thead>
                                <tr>
                                    <th style="width: 20%">1단</th>
                                    <th style="width: 20%">2단</th>
                                    <th style="width: 20%">3단</th>
                                    <th style="width: 20%">4단</th>
                                    <th style="width: 20%">5단</th>
                                </tr>
                            </thead>
                            <tbody id="pop_categoryTbody">
                                <tr>
                                    <td>
                                        <select class="category_select" id="Category01" onchange="fnChangeSubCategoryBind(this,2); return false;" style="width:90%; height:26px">
                                            <option value="All">---전체---</option>
                                        </select>
                                    </td>
                                    <td>
                                        <select class="category_select" id="Category02" onchange="fnChangeSubCategoryBind(this,3); return false;" style="width:90%; height:26px">
                                            <option value="All">---전체---</option>
                                        </select>
                                    </td>
                                    <td>
                                        <select class="category_select" id="Category03" onchange="fnChangeSubCategoryBind(this,4); return false;" style="width:90%; height:26px">
                                            <option value="All">---전체---</option>
                                        </select>
                                    </td>
                                    <td>
                                        <select class="category_select" id="Category04" onchange="fnChangeSubCategoryBind(this,5); return false;" style="width:90%; height:26px">
                                            <option value="All">---전체---</option>
                                        </select>
                                    </td>
                                    <td>
                                        <select class="category_select" id="Category05" onchange="fnChangeSubCategoryBind(this,6); return false;" style="width:90%; height:26px">
                                            <option value="All">---전체---</option>
                                        </select>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                    <!--팝업 컨텐츠 영역끝-->

                </div>
            </div>
            <br />
            <!--팝업 확인 버튼 영역 시작-->
            <div class="btn_center">
                <input type="button" class="mainbtn type1" style="width: 95px;" value="확인" onclick="fnCategoryConfirm(); return false;" />
            </div>
            <!--팝업 확인 버튼 영역 끝-->
        </div>
    </div>
</asp:Content>

