<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Master/AdminMasterPage.master" AutoEventWireup="true" CodeFile="SiteInfoMenu.aspx.cs" Inherits="Admin_Setting_SiteInfoMenu" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <script type="text/javascript">
        var qs = fnGetQueryStrings();
        var qsCssCode;
        var qsCompCode;
        var qsCompName;
        $(function () {
            qsCssCode = qs['CssCode'];
            qsCompCode = qs['CompCode'];
            qsCompName = qs['CompName']

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

                location.href = 'SiteInfoDefault.aspx?CssCode=' + $('#hdDistCssCode').val() + '&CompCode=' + $('#txtCompSearch').val() + '&CompName=' + $('#lblCompName').text()+ '&ucode=' + ucode;
            });
            $("#tabPopup").on("click", function () {

                location.href = 'SiteInfoPopup.aspx?CssCode=' + $('#hdDistCssCode').val() + '&CompCode=' + $('#txtCompSearch').val() + '&CompName=' + $('#lblCompName').text()+ '&ucode=' + ucode;
            });
            //$("#tabMenu").on("click", function () {

            //    location.href = 'SiteInfoMenu.aspx?CssCode=' + $('#hdDistCssCode').val() + '&CompCode=' + $('#txtCompSearch').val() + '&CompName=' + $('#lblCompName').text()+ '&ucode=' + ucode;
            //});
            $("#tabBanner").on("click", function () {

                location.href = 'SiteInfoBanner.aspx?CssCode=' + $('#hdDistCssCode').val() + '&CompCode=' + $('#txtCompSearch').val() + '&CompName=' + $('#lblCompName').text()+ '&ucode=' + ucode;
            });
            $("#tabPartner").on("click", function () {

                location.href = 'SiteInfoPartner.aspx?CssCode=' + $('#hdDistCssCode').val() + '&CompCode=' + $('#txtCompSearch').val() + '&CompName=' + $('#lblCompName').text()+ '&ucode=' + ucode;
            });

            if (!isEmpty(qsCssCode)) {

                $('#txtCompSearch').val(qsCompCode);
                $('#lblCompName').text(qsCompName);
                $('#txtCode').val(qsCssCode);
                fnDistInfo();
                fnGetDistMenu();

                $('#divMain').css('display', '');
                $('#divBtn').css('display', '');
                $('#divTab').css('display', '');
            }

        })
        function fnSearchCompanyPopup() {
            $('#selectGubun').val('SU');
            $('#txtPopSearchComp').val('');
            fnSearchCompanyList(1);
            var e = document.getElementById('searchCompdiv');


            if (e.style.display == 'block') e.style.display = 'none';
            else e.style.display = 'block';
        }

        function fnDistPopup() {

            if ($('#txtCompSearch').val() == '') {

                alert('먼저 회사를 선택해 주세요');
                return false;

            }
            fnDistList(1);
            var e = document.getElementById('distCssdiv');
            if (e.style.display == 'block') e.style.display = 'none';
            else e.style.display = 'block';
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
            fnGetDistMenu();
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
                    }
                    else {
                        $('#rbSSLN').prop('checked', true);
                    }

                    if (response.PgConfirmYN == 'Y') {
                        $('#rbPGY').prop('checked', true);
                    }
                    else {
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


        function fnSaveDiscMgt() {
            var callback = function (response) {
                if (response == 'OK') {
                   
                }
                else {
                    alert('구성중 오류가 생겼습니다. 시스템 관리자에게 문의하세요.');
                    return false;
                }
            }

            var pg = '';
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
            
            var param = {

                DCode: $('#txtCode').val(),
                DName: $('#txtTitle').val(),
                Url: $('#txtDomain').val(),
                CompCode: $('#txtCompSearch').val(),
                CompName: $('#txtCompName').val(),
                DistCompName: $('#txtDistCompanyName').val(),
                DefaultYN: 'N',
                Gubun: $('#ddlGubun2').val(),
                GubunInfo: $('#ddlGubun1').val(),
                PgconfirmYN: pg,
                MetaTag: $('#txtMetatag').val(),
                BrowerTag: $('#txtTabTitle').val(),
                SearchTag: $('#txtSearchPhrases').val(),
                SslYN: ssl,
              
                Method: 'SaveDist'

            };


            var beforeSend = function () {
            };

            var complete = function () {
            };

            //type, url, async, cache, data, datatype, _callback, _beforeSend, _complete, issessionCheck, sessionValue
            JqueryAjax('Post', '../../Handler/Common/DistCssHandler.ashx', false, false, param, 'text', callback, beforeSend, complete, true, '<%=Svid_User%>');

        }

        function fnDistFileupload(dCode, oldFaviconPath, oldCssPath, oldToplogoPath, oldBottomLogoPath, oldCopyPath, OldTopBannerPath, OldTopBannerDetailPath, OldLoginFaviconPath, OldLoginTbannerPath, OldLoginBgPath, OldLoginCompLogoPath, OldLoginCopyPath, faviconFile, cssFile, topLogoFile, bottomLogoFile, copyFile, topBannerFile, topBannerDetailFile, loginFaviconFile, loginTbannerFile, loginBgFile, loginCompLogoFile, loginCopyFile) {
            var data = new FormData();
            data.append("DCode", dCode);

            data.append("OldFaviconPath", oldFaviconPath);
            data.append("OldCssPath", oldCssPath);
            data.append("LoginCompLogo", loginCompLogoFile[0]);
            data.append("LoginCopy", loginCopyFile[0]);

            data.append("Method", 'DistFileUpload_Type2');

            var ajaxRequest = $.ajax({
                type: "POST",
                url: '../../Handler/FileUploadHandler.ashx',
                async: false,
                contentType: false,
                processData: false,
                data: data
            });

            ajaxRequest.done(function (xhr, textStatus) {

                fnDistInfo();
            });
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

        function fnDeleteMenuImage(el, type) {


            if (!confirm('정말 삭제하시겠습니까?')) {
                return false;
            }

            var callback = function (response) {

                if (response == 'OK') {

                    fnGetDistMenu();
                }
                else {
                    alert('시스템 오류입니다 시스템 관리자에게 문의하세요');

                }
                return false;
            }

            var filePath = '';

            switch (type) {

                case "Main":
                    filePath = $(el).parent().parent().children().find('#hdRowMainPath').val();
                    break;
                case "Detail":
                    filePath = $(el).parent().parent().children().find('#hdRowDetailMainPath').val();
                    break;
                default:
            }
            var param = {


                DCode: $('#txtCode').val(),
                MenuId: $(el).parent().parent().children().find('#hdRowMenuId').val(),
                Type: type,
                DeleteFilePath: filePath,
                Method: 'DeleteMenuImg'

            };

            //type, url, async, cache, data, datatype, _callback, _beforeSend, _complete, issessionCheck, sessionValue
            JqueryAjax('Post', '../../Handler/Common/DistCssHandler.ashx', false, false, param, 'text', callback, null, null, true, '<%=Svid_User%>');
        }

        function fnOpenCopy() {
            $('#selectPopupDistCopyTarget').val('2');
            $('#txtPopSearchDistCopy').val('');
            $('#hdCopyCodes').val('');
            $('#cbCheckAllCopy').prop('checked', false);



            fnDistCopyList(1);
            var e = document.getElementById('distCssCopydiv');
            if (e.style.display == 'block') e.style.display = 'none';
            else e.style.display = 'block';
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

        function fnGetDistMenu() {

            var callback = function (response) {
                $("#tblMenu").empty();
                var newRowContent = '';
                if (!isEmpty(response)) {
                    $.each(response, function (key, value) { //테이블 추가


                        newRowContent += "<tr id='" + value.MenuId + "'>";

                        var gubunText = '구매사';

                        if ($.trim(value.MenuGubun) == '2') {
                            gubunText = '판매사';
                        }
                        else if ($.trim(value.MenuGubun) == '3') {
                            gubunText = '그룹G';
                        }
                        else if ($.trim(value.MenuGubun) == '4') {
                            gubunText = '관리자';
                        }

                        newRowContent += "<td  style='text-align:center'>" + gubunText + "</td>";
                        var padding = '';
                        if ($.trim(value.MenuLevelCode) == '2') {

                            padding = 'padding-left:35px';
                        }
                        newRowContent += "<td style='" + padding + "'><input type='hidden' id='hdRowGubun' value='" + value.MenuGubun + "'/><input type='hidden' id='hdRowMenuId' value='" + value.MenuId + "'/><input type='hidden' id='hdRowPlaceCode' value='" + value.MenuPlaceCode + "'/>" + value.MenuName + "</td>";

                        var placeText = '상단';

                        if ($.trim(value.MenuPlaceCode) == '2') {
                            placeText = '하단';
                        }
                        else if ($.trim(value.MenuPlaceCode) == '3') {
                            placeText = '하단2';
                        }

                        var useChecked = '';

                        if (value.UseYN == 'Y') {
                            useChecked = 'checked';
                        }
                        newRowContent += "<td style='text-align:center'>" + placeText + "</td>";
                        newRowContent += "<td style='text-align:center'><input type='checkbox' " + useChecked + " id='cbMenuUse'/></td>";

                        var menuSeqDisabled = '';
                        if (!isEmpty(value.MenuUpCode) || $.trim(value.MenuPlaceCode) != '1' ) {
                            menuSeqDisabled = 'disabled = "disabled"';
                        }
                        newRowContent += "<td ><input type='text' id='txtMenuSeq'  style='width:100%' " + menuSeqDisabled + " value='" + value.MenuSeq+"'/></td>";

                        var detailMenuPath = "/SiteManagement/" + $('#txtCode').val() + "/Menu/" + value.DistCssMgtMenuDetailName;
                        var deleteMainButton = '';
                        var dfile = "<input type='file' id='fuDMenuFile" + key + "'/>";
                        var dbtn = "<input type='button' class='listBtn' value='저장' style='width:55px; height:22px; font-size:12px' onclick=''/>";
                        var deleteDetailButton = '';

                        if (!isEmpty(value.DistCssMgtMenuDetailName)) {
                            deleteDetailButton = '&nbsp;&nbsp;<img src="/Admin/Images/icon-delete.jpg"  alt="x" onclick="fnDeleteMenuImage(this, \'Detail\'); return false" id="btnBLogoDelete" style="cursor:pointer;"/>';
                        }

                        newRowContent += "<td style='text-align:center'><input type='hidden' id='hdRowDetailMainPath' value='" + detailMenuPath + "'/><span id='spanDetailMenuName'>" + value.DistCssMgtMenuDetailName + "</span>" + deleteDetailButton + "</td>";
                        newRowContent += "<td style='text-align:center'>" + dfile + "</td>";
                        newRowContent += "<td ><input type='text' id='txtMenuUrl' style='width:100%' value='" + value.MenuUrl+"'/></td>";
                        newRowContent += "</tr>";


                    });
                    $("#tblMenu").append(newRowContent);

                }
                else {
                    var emptyTag = "<tr><td colspan='8' class='txt-center'>조회된 데이터가 없습니다.</td></tr>";
                    $("#tblMenu").append(emptyTag);
                }

                table_row_spanning('#tblMenu', 2);
                table_row_spanning('#tblMenu', 0);
                return false;
            }

             var param = {

                 Code: $('#txtCode').val(),
                 Method: 'GetDistCssMenu'

             };


             //type, url, async, cache, data, datatype, _callback, _beforeSend, _complete, issessionCheck, sessionValue
             JqueryAjax('Post', '../../Handler/Common/DistCssHandler.ashx', false, false, param, 'json', callback, null, null, true, '<%=Svid_User%>');
        }

        function table_row_spanning(table, spanning_row_index) {
            var rowspan_td = false;
            var rowspan_column_name = false;
            var rowspan_count = 0;
            var rows = $('tr', table);
            $.each(rows, function () {
                var This = $('td', this)[spanning_row_index];
                var text = $(This).text();
                if (rowspan_td == false) {
                    rowspan_td = This; rowspan_column_name = text; rowspan_count = 1;
                }
                else if (rowspan_column_name != text) {
                    $(rowspan_td).attr('rowSpan', rowspan_count);
                    rowspan_td = This;
                    rowspan_column_name = text;
                    rowspan_count = 1;
                }
                else {
                    $(This).remove();
                    rowspan_count++;
                }
            }); // 반복 종료 후 마지막 rowspan 적용 
            $(rowspan_td).attr('rowSpan', rowspan_count);
        }

        function fnSaveDiscMenu() {
            var jsonMenu = [];
            var pg = '';
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
            $("#tblMenu tr").each(function () {
                var oldDetailPath = $(this).children().find('#hdRowDetailMainPath').val();
                var pCode = $(this).children().find('#hdRowPlaceCode').val();
                var mid = $(this).attr('id');
                var gubun = $(this).children().find('#hdRowGubun').val();
                var detailFile = $(this).children().find('input[id*="fuDMenuFile"]').get(0).files[0];
                var placeCode = $(this).children().find('#hdRowPlaceCode').val();
                var useYn = 'N';
                if ($(this).children().find('#cbMenuUse').is(":checked")) {
                    useYn = 'Y'
                }
                var menuGubun = 't';
                if ($.trim(placeCode) == '2') {
                    menuGubun = 'b';
                }

                var detailMenuName = '';
                var detailMenuPath = '';
                if (detailFile != null) {
                    detailMenuName = 'detail_' + menuGubun + '_' + mid + '.' + $(this).children().find('input[id*="fuDMenuFile"]').val().split('.').pop().toLowerCase();
                    detailMenuPath = '/SiteManagement/' + $('#txtCode').val() + '/Menu/' + detailMenuName;
                }
                var seq = $(this).children().find('#txtMenuSeq').val();
                var menuUrl = $(this).children().find('#txtMenuUrl').val();
                jsonMenu.push({
                    Mid: mid,
                    Gubun: gubun,
                    PlaceCode: placeCode,
                    Seq: seq,
                    UseYN: useYn,
                    DetailName: detailMenuName,
                    DetailPath: detailMenuPath,
                    Url: menuUrl,
                    OldMenuDetailPath: oldDetailPath
                });

            });

            var callback = function (response) {
                
                if (response == 'OK') {
                    alert('저장되었습니다.');
                    fnDistInfo();
                    fnGetDistMenu();
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
                    data.append("MenuData", JSON.stringify(jsonMenu));
                    data.append("Method", 'SaveDistMenu');
                    $("#tblMenu tr").each(function () {
                        data.append($(this).attr('id') + 'File', $(this).children().find('input[id*="fuDMenuFile"]').get(0).files[0]);
                    });
                    return data;
                }(),
            });
        }
        
        function fnOpenCopy() {
            $('#selectPopupDistCopyTarget').val('2');
            $('#txtPopSearchDistCopy').val('');
            $('#hdCopyCodes').val('');
            $('#cbCheckAllCopy').prop('checked', false);



            fnDistCopyList(1);
            var e = document.getElementById('distCssCopydiv');
            if (e.style.display == 'block') e.style.display = 'none';
            else e.style.display = 'block';
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

            if ($('#cbCopyDefault').is(":checked") == false && $('#cbCopyPopup').is(":checked") == false && $('#cbCopyMenu').is(":checked") == false && $('#cbCopyBanner').is(":checked") == false && $('#cbCopyPartner').is(":checked") == false) {

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
            if ($('#cbCopyPopup').is(":checked")) {
                types += 'Popup/';
            }
            if ($('#cbCopyMenu').is(":checked")) {
                types += 'Menu/';
            }
            if ($('#cbCopyBanner').is(":checked")) {
                types += 'Banner/';
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
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
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
                <table class="tbl_search">
                    <tr>
                        <th>
                           회사검색
                        </th>
                        <td>
                            <input type="text" ID="txtCompSearch" style="width:150px;">
                            <input type="button" class="mainbtn type1" value="검색" style="width:75px; height:25px; font-size:12px" onclick="fnSearchCompanyPopup(); return false;">
                        </td>
                        <th>
                           배포코드
                        </th>
                        <td>
                            <input type="text"  style="width:150px;" id="txtCode">
                            <input type="button" class="mainbtn type1" value="검색" style="width:75px; height:25px; font-size:12px" onclick="fnDistPopup(); return false;">
                            <input type="button" class="mainbtn type1" value="신규생성" style="width:75px; height:25px; font-size:12px" onclick="fnSetNextCode(); return false;">
                            <input type="button" id="btnSaveDefault" class="mainbtn type1" value="기본설정 저장" style="display:none;  width:105px; height:25px; font-size:12px" onclick="fnSaveDefault(); return false;">
                        </td>
                    </tr>

                    <tr>
                        <th>
                            회사명
                        </th>
                        <td>
                            <p id="lblCompName"></p>
                        </td> 
                         <th>
                            배포관리명
                        </th>
                        <td>
                            <input type="text"  style="width:150px;" id="txtTitle">
                        </td>
                     </tr>
                     <tr>
                        <th>
                            회사구분
                        </th>
                        <td>
                            <select style="height:26px;width:150px;" ID="ddlGubun1">
                                <option value="1">소셜위드</option>
                                <option value="2">SCM</option>
                                <option value="3">복지몰</option>
                            </select>

                            <select style="height:26px;width:150px;" ID="ddlGubun2">
                                <option value="2">판매사</option>
                                <option value="1">구매사</option>
                                <option value="3">그룹G</option>
                                <option value="4">관리자</option>
                            </select>
                        </td>
                        <th>
                           도메인 주소
                        </th>
                        <td>
                            <input type="text"  style="width:350px;" id="txtDomain">
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
                 <input type="button" class="mainbtn type1" style="width:95px; height:30px; font-size:12px" value="저장" onclick="return fnSaveDiscMenu();"/>
                 <input type="button" class="mainbtn type1" style="width:155px; height:30px; font-size:12px" value="타사이트에 복사하기" onclick="return fnOpenCopy();"/>
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
                    <%--<li class='tabOn' style="width: 185px;" >
                        <a id="tabMenu">배포메뉴</a>
                    </li>--%>
                    <li class='tabOff' style="width: 185px;" >
                         <a id="tabBanner">배포배너</a>
                    </li>
                    <li class='tabOff' style="width: 185px;" >
                        <a id="tabPartner">배포기관</a>
                    </li>
                </ul>
            </div>

           <!--메인 영역 시작-->
            
            <div id="divMain" class="admin-maincontents" style="display:none">
                <div class="admin-maincontents-subtitle">
                    <span>*메뉴 설정</span>
                </div>
                <table class="tbl_main">
                    <thead>
                        <tr>
                            <th style="width: 80px">구분
                            </th>
                            <th style="width: 170px">메뉴명
                            </th>
                            <th style="width: 80px">상/하단
                            </th>
                            <th style="width: 80px">사용유무
                            </th>
                            <th style="width: 80px">1단메뉴 <br />순서
                            </th>
                            <th style="width: 400px">상세이미지 파일명
                            </th>
                            <th>상세이미지 업로드
                            </th>
                            <th style="width: 400px">url
                            </th>
                        </tr>
                    </thead>
                    <tbody id="tblMenu">
                        <tr><td colspan='8' class='txt-center'>조회된 데이터가 없습니다.</td></tr>
                    </tbody>
                </table>
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
                <div class="popup-title" style="margin-top: 20px;">
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
                    <table class="tbl_popup" style="margin-top: 0; width: 100%">
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

                <div style="text-align: right; margin-top: 10px;">
                    <input type="button" class="mainbtn type1" style="width: 95px; height: 30px; font-size: 12px" value="확인" onclick="fnConfirm(); return false;" />
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
                    <table class="tbl_popup" style="margin-top: 0; width: 100%">
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

                <div style="text-align: right; margin-top: 10px;">
                    <input type="button" class="mainbtn type1" style="width: 95px; height: 30px; font-size: 12px" value="확인" onclick="fnDistConfirm(); return false;" />
                </div>

            </div>
        </div>
    </div>


     <%--배포코드 검색 팝업(복사용)--%>
    <div id="distCssCopydiv" class="popupdiv divpopup-layer-package">
        <div class="popupdivWrapper" style="width: 650px; height: 730px">
            <div class="popupdivContents">
                <input type="hidden" id="hdCopyCodes"/>
                <div class="close-div">
                    <a onclick="fnClosePopup('distCssCopydiv'); return false;" style="cursor: pointer">
                        <img src="../../Images/Wish/icon-delete.jpg" alt="닫기" style="float: right;" /></a>
                </div>
                <div class="popup-title" style="margin-top: 20px;">
                    <h3 class="pop-title">배포코드 검색</h3>
                </div>

                <div class="search-div" style="margin-bottom: 20px;">
                        <select id="selectPopupDistCopyTarget" style="height:26px; width:150px; vertical-align:middle">
                            <option value="2" selected="selected" >
                                판매사
                            </option>
                            <option value="1" >
                                구매사
                            </option>
                        </select>
                        <input type="text" class="text-code" id="txtPopSearchDistCopy" placeholder="검색어를 입력하세요" onkeypress="return fnPopupCopyEnter();" style="width:300px"/>
                        <input type="button" class="mainbtn type1" style="width:95px; height:30px; font-size:12px" value="검색" onclick="fnDistCopyList(1); return false;"/>
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
                                <th class="text-center" style="width: 5%"><input type="checkbox" id="cbCheckAllCopy" onclick="fnSelectAll(this);"/></th>
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
</asp:Content>

