<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Master/AdminMasterPage.master" AutoEventWireup="true" CodeFile="SiteInfoDefault.aspx.cs" Inherits="Admin_Setting_SiteInfoDefault" %>

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

            $("#tabDefault").on("click",  function () {

                location.href = 'SiteInfoDefault.aspx?CssCode=' + $('#hdDistCssCode').val() + '&CompCode=' + $('#txtCompSearch').val() + '&CompName=' + $('#lblCompName').text() + '&ucode=' + ucode;
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
                    $('#txtDistCompanyName').val(response.DistCompanyName);
                    $('#txtMetatag').val(response.MetaTag);
                    $('#txtTabTitle').val(response.BrowserTag);
                    $('#txtSearchPhrases').val(response.SearchTag);
                    $('#txtDaumCode').val(response.distCssMgtDetail.CompanyDirection);
                    $('#txtAddress').val(response.distCssMgtDetail.CompanyDirectionCaption);
                    $('#txtGoogleCode').val(response.DistGoogleCode);
                    $('#txtTel').val(response.DistCustTelNo);
                    $('#cbFavicon').prop("checked", true);
                    $('#lblFavicon').text(response.distCssMgtDetail.BrowseEmtcName);
                    if (!isEmpty(response.distCssMgtDetail.BrowseEmtcName)) {
                        $('#lblFavicon').append('<img src="/Admin/Images/icon-delete.jpg"  alt="x" onclick="fnDeleteMgtImage(\'Favicon\'); return false" id="btnFaviconDelete" style="padding-left:5px; cursor:pointer;"/>');
                    }
                   
                    $('#hfFaviconPath').val(response.distCssMgtDetail.BrowseEmtcPath);

                    $('#lblCss').text(response.distCssMgtDetail.CssName);
                    if (!isEmpty(response.distCssMgtDetail.CssName)) {
                        $('#lblCss').append('<img src="/Admin/Images/icon-delete.jpg"  alt="x" onclick="fnDeleteMgtImage(\'Css\'); return false" id="btnCssDelete" style="padding-left:5px; cursor:pointer;"/>');
                    }
                    
                    $('#hfCssPath').val(response.distCssMgtDetail.CssPath);

                    $('#lblTopLogo').text(response.distCssMgtDetail.TopLogoImageName);
                    if (!isEmpty(response.distCssMgtDetail.TopLogoImageName)) {
                        $('#lblTopLogo').append('<img src="/Admin/Images/icon-delete.jpg"  alt="x" onclick="fnDeleteMgtImage(\'Tlogo\'); return false" id="btnTlogoDelete" style="padding-left:5px; cursor:pointer;"/>');
                    }
                    
                    $('#hfTopLogoPath').val(response.distCssMgtDetail.TopLogoImagePath);

                    $('#lblBottomLogo').text(response.distCssMgtDetail.BottomLogoImageName);
                    if (!isEmpty(response.distCssMgtDetail.BottomLogoImageName)) {
                        $('#lblBottomLogo').append('<img src="/Admin/Images/icon-delete.jpg"  alt="x" onclick="fnDeleteMgtImage(\'Blogo\'); return false" id="btnBlogoDelete" style="padding-left:5px; cursor:pointer;"/>');
                    }
                    
                    $('#hfBottomLogoPath').val(response.distCssMgtDetail.BottomLogoImagePath);

                    $('#lblCopyright').text(response.distCssMgtDetail.CopyRName);
                    if (!isEmpty(response.distCssMgtDetail.CopyRName)) {
                        $('#lblCopyright').append('<img src="/Admin/Images/icon-delete.jpg"  alt="x" onclick="fnDeleteMgtImage(\'Copy\'); return false" id="btnCopyDelete" style="padding-left:5px; cursor:pointer;"/>');
                    }
                    
                    $('#hfCopyrightPath').val(response.distCssMgtDetail.CopyRPath);


                    //로그인
                    $('#lblLoginFavicon').text(response.distCssMgtLogin.LoginBrowseEmtcName);
                    if (!isEmpty(response.distCssMgtLogin.LoginBrowseEmtcName)) {
                        $('#lblLoginFavicon').append('<img src="/Admin/Images/icon-delete.jpg"  alt="x" onclick="fnDeleteMgtImage(\'LoginFavicon\'); return false" id="btnLoginFaviconDelete" style="padding-left:5px; cursor:pointer;"/>');
                    }

                    $('#hfLoginFaviconPath').val(response.distCssMgtLogin.LoginBrowseEmtcPath);
                    $('#selectLoginFaviconUse').val(response.distCssMgtLogin.LoginBrowseEmtcDelflag);

                    $('#lblLoginTopBanner').text(response.distCssMgtLogin.LoginTopBannerCaption);
                    if (!isEmpty(response.distCssMgtLogin.LoginTopBannerCaption)) {
                        $('#lblLoginTopBanner').append('<img src="/Admin/Images/icon-delete.jpg"  alt="x" onclick="fnDeleteMgtImage(\'LoginTBanner\'); return false" id="btnLoginTBannerDelete" style="padding-left:5px; cursor:pointer;"/>');
                    }

                    $('#hfLoginTopBannerPath').val(response.distCssMgtLogin.LoginTopBannerPath);
                    $('#selectfuLoginTopBannerUse').val(response.distCssMgtLogin.LoginTopBannerDelflag);

                    $('#lblLoginBackImg').text(response.distCssMgtLogin.LoginBackgroundImgName);
                    if (!isEmpty(response.distCssMgtLogin.LoginBackgroundImgName)) {
                        $('#lblLoginBackImg').append('<img src="/Admin/Images/icon-delete.jpg"  alt="x" onclick="fnDeleteMgtImage(\'LoginTBg\'); return false" id="btnLoginTBgDelete" style="padding-left:5px; cursor:pointer;"/>');
                    }

                    $('#hfLoginBackPath').val(response.distCssMgtLogin.LoginBackgroundImgPath);
                    $('#selectLginBackImgUse').val(response.distCssMgtLogin.LoginBackgroundImgDelflag);

                    $('#lblLoginCompLogo').text(response.distCssMgtLogin.LoginCompanyLogoName);
                    if (!isEmpty(response.distCssMgtLogin.LoginCompanyLogoName)) {
                        $('#lblLoginCompLogo').append('<img src="/Admin/Images/icon-delete.jpg"  alt="x" onclick="fnDeleteMgtImage(\'LoginCompLogo\'); return false" id="btnLoginCompLogoDelete" style="padding-left:5px; cursor:pointer;"/>');
                    }

                    $('#hfLoginCompLogoPath').val(response.distCssMgtLogin.LoginCompnayLogoPath);
                    $('#selectLoginCompLogoUse').val(response.distCssMgtLogin.LoginCompnayLogoDelflag);

                    $('#lblLoginCopyright').text(response.distCssMgtLogin.LoginCopyrightName);
                    if (!isEmpty(response.distCssMgtLogin.LoginCopyrightName)) {
                        $('#lblLoginCopyright').append('<img src="/Admin/Images/icon-delete.jpg"  alt="x" onclick="fnDeleteMgtImage(\'LoginCopy\'); return false" id="btnLoginCopyDelete" style="padding-left:5px; cursor:pointer;"/>');
                    }

                    $('#hfLoginCopyrightPath').val(response.distCssMgtLogin.LoginCopyrightPath);
                    $('#selectLoginCopyrightUse').val(response.distCssMgtLogin.LoginCopyrightDelflag);


                    ////마스터 탑배너
                    $('#selectTopBannerUse').val(response.distCssMgtDetail.TopBannerDelflag);

                    $('#lblTopBanner').text(response.distCssMgtDetail.TopBannerCaption);
                    if (!isEmpty(response.distCssMgtDetail.TopBannerCaption)) {
                        $('#lblTopBanner').append('<img src="/Admin/Images/icon-delete.jpg"  alt="x" onclick="fnDeleteMgtImage(\'TBanner\'); return false" id="btnTBannerDelete" style="padding-left:5px; cursor:pointer;"/>');
                    }

                    $('#hfTopBannerPath').val(response.distCssMgtDetail.TopBannerPath);

                    $('#lblTopBannerDetail').text(response.distCssMgtDetail.TopBannerDetailCaption);
                    if (!isEmpty(response.distCssMgtDetail.TopBannerDetailCaption)) {
                        $('#lblTopBannerDetail').append('<img src="/Admin/Images/icon-delete.jpg"  alt="x" onclick="fnDeleteMgtImage(\'TBannerDetail\'); return false" id="btnTBannerDetailDelete" style="padding-left:5px; cursor:pointer;"/>');
                    }

                    $('#hfTopBannerDetailPath').val(response.distCssMgtDetail.TopBannerDetailPath);

                    $('#txtTopBannerUrl').val(response.distCssMgtDetail.TopBannerLinkUrl);
                    

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

             if (isEmpty($('#txtCode').val())) {
                alert('배포코드를 검색해 주세요.');
                $('#txtCode').focus();
                return false;
            }

            var callback = function (response) {
                if (response == 'OK') {
                   

                    var dCode = $('#txtCode').val();
                    var oldFaviconPath = $('#hfFaviconPath').val();
                    var oldCssPath = $('#hfCssPath').val();
                    var oldToplogoPath = $('#hfTopLogoPath').val();
                    var oldBottomLogoPath = $('#hfBottomLogoPath').val();
                    var oldCopyPath = $('#hfCopyrightPath').val();
                    var oldTopBannerPath = $('#hfTopBannerPath').val();
                    var oldTopBannerDetailPath = $('#hfTopBannerDetailPath').val();
                    var oldLoginFaviconPath = $('#hfLoginFaviconPath').val();
                    var oldLoginTbannerPath = $('#hfLoginTopBannerPath').val();
                    var oldLoginBgPath = $('#hfLoginBackPath').val();
                    var oldLoginCompLogoPath = $('#hfLoginCompLogoPath').val();
                    var oldLoginCopyrightPath = $('#hfLoginCopyrightPath').val();

                    var fuFavicon = $('#fuFavicon').get(0).files;
                    var fuCss = $('#fuCss').get(0).files;
                    var fuTopLogo = $('#fuTopLogo').get(0).files;
                    var fuBottomLogo = $('#fuBottomLogo').get(0).files;
                    var fuCopyright = $('#fuCopyright').get(0).files;
                    var fuTopBanner = $('#fuTopBanner').get(0).files;
                    var fuTopBannerDetail = $('#fuTopBannerDetail').get(0).files;
                    var fuLoginFavicon = $('#fuLoginFavicon').get(0).files;
                    var fuLoginTopBanner = $('#fuLoginTopBanner').get(0).files;
                    var fuLoginBackimg = $('#fuLoginBackimg').get(0).files;
                    var fuLoginCompLogo = $('#fuLoginCompLogo').get(0).files;
                    var fuLoginCopyright = $('#fuLoginCopyright').get(0).files;
                    

                    fnDistFileupload(dCode, oldFaviconPath, oldCssPath, oldToplogoPath, oldBottomLogoPath, oldCopyPath, oldTopBannerPath, oldTopBannerDetailPath, oldLoginFaviconPath, oldLoginTbannerPath, oldLoginBgPath, oldLoginCompLogoPath, oldLoginCopyrightPath, fuFavicon, fuCss, fuTopLogo, fuBottomLogo, fuCopyright, fuTopBanner, fuTopBannerDetail, fuLoginFavicon, fuLoginTopBanner, fuLoginBackimg, fuLoginCompLogo, fuLoginCopyright);
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
            var emtcName = '';
            var emtcPath = '';
            if ($('#fuFavicon').get(0).files[0] != null) {
                emtcName = 'mini_logo.' + $('#fuFavicon').val().split('.').pop().toLowerCase(); 
                emtcPath = '/SiteManagement/' + $('#txtCode').val() + '/Main/' + emtcName;
            }

            var cssName = '';
            var cssPath = '';
            if ($('#fuCss').get(0).files[0] != null ) {
                cssName = 'SiteInfo.' + $('#fuCss').val().split('.').pop().toLowerCase(); 
                cssPath = '/SiteManagement/' + $('#txtCode').val() + '/Main/' + cssName;
            }

            var tImageName = '';
            var tImagePath = '';
            if ($('#fuTopLogo').get(0).files[0] != null) {
                tImageName = 'main_logo.' + $('#fuTopLogo').val().split('.').pop().toLowerCase(); 
                tImagePath = '/SiteManagement/' + $('#txtCode').val() + '/Main/' + tImageName;
            }

            var bImageName = '';
            var bImagePath = '';
            if ($('#fuBottomLogo').get(0).files[0] != null) {
                bImageName = 'main_bottom_logo.' + $('#fuBottomLogo').val().split('.').pop().toLowerCase(); 
                bImagePath = '/SiteManagement/' + $('#txtCode').val() + '/Main/' + bImageName;
            }

            var copyName = '';
            var copyPath = '';
            if ($('#fuCopyright').get(0).files[0] != null) {
                copyName = 'copyright.' + $('#fuCopyright').val().split('.').pop().toLowerCase(); 
                copyPath = '/SiteManagement/' + $('#txtCode').val() + '/Main/' + copyName;
            }

            var tbanner = '';
            var tbannerPath = '';
            if ($('#fuTopBanner').get(0).files[0] != null ) {
                tbanner = 'top_banner.' + $('#fuTopBanner').val().split('.').pop().toLowerCase(); 
                tbannerPath = '/SiteManagement/' + $('#txtCode').val() + '/Main/' + tbanner;
            }

            var tbannerDetail = '';
            var tbannerDetailPath = '';
            if ($('#fuTopBannerDetail').get(0).files[0] != null) {
                tbannerDetail = 'top_banner_detail.' + $('#fuTopBannerDetail').val().split('.').pop().toLowerCase(); 
                tbannerDetailPath = '/SiteManagement/' + $('#txtCode').val() + '/Main/' + tbannerDetail;
            }

            var loginFavicon = '';
            var loginFaviconPath = '';
            if ($('#fuLoginFavicon').get(0).files[0] != null) {
                loginFavicon = 'loginFavicon.' + $('#fuLoginFavicon').val().split('.').pop().toLowerCase(); 
                loginFaviconPath = '/SiteManagement/' + $('#txtCode').val() + '/Login/' + loginFavicon;
            }

            var loginTbanner = '';
            var loginTbannerPath = '';
            if ($('#fuLoginTopBanner').get(0).files[0] != null) {
                loginTbanner = 'login_topbanner.' + $('#fuLoginTopBanner').val().split('.').pop().toLowerCase(); 
                loginTbannerPath = '/SiteManagement/' + $('#txtCode').val() + '/Login/' + loginTbanner;
            }

            var loginBg = '';
            var loginBgPath = '';
            if ($('#fuLoginBackimg').get(0).files[0] != null) {
                loginBg = 'login_bg.' + $('#fuLoginBackimg').val().split('.').pop().toLowerCase(); 
                loginBgPath = '/SiteManagement/' + $('#txtCode').val() + '/Login/' + loginBg;
            }

            var loginCompLogo = '';
            var loginCompLogoPath = '';
            if ($('#fuLoginCompLogo').get(0).files[0] != null) {
                loginCompLogo = 'login_compLogo.' + $('#fuLoginCompLogo').val().split('.').pop().toLowerCase(); 
                loginCompLogoPath = '/SiteManagement/' + $('#txtCode').val() + '/Login/' + loginCompLogo;
            }

            var loginCopyright = '';
            var loginCopyrightPath = '';
            if ($('#fuLoginCopyright').get(0).files[0] != null) {
                loginCopyright = 'login_copyright.' + $('#fuLoginCopyright').val().split('.').pop().toLowerCase(); 
                loginCopyrightPath = '/SiteManagement/' + $('#txtCode').val() + '/Login/' + loginCopyright;
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
                GoogleCode: $('#txtGoogleCode').val(),
                CustTelNo: $('#txtTel').val(),
                Delflag: 'N',
                EmtcName: emtcName,
                EmtcPath: emtcPath,
                CssName: cssName,
                CssPath: cssPath,
                TImageName: tImageName,
                TImagePath: tImagePath,
                BImageName: bImageName,
                BImagePath: bImagePath,
                CopyRName: copyName,
                CopyRPath: copyPath,
                CompanyDirection: $('#txtDaumCode').val(),
                CompanyDirectionCaption: $('#txtAddress').val(),
                TopBannerCaption: tbanner,
                TopBannerPath: tbannerPath,
                TopBannerDetailCaption: tbannerDetail,
                TopBannerDetailPath: tbannerDetailPath,
                TopBannerUrl: $('#txtTopBannerUrl').val(),
                TopBannerDelflag: $('#selectTopBannerUse').val(),
                LoginBrowseEmtcName: loginFavicon,
                LoginBrowseEmtcPath: loginFaviconPath,
                LoginBrowseEmtcDelflag: $('#selectLoginFaviconUse').val(),
                LoginTopBannerCaption: loginTbanner,
                LoginTopBannerPath: loginTbannerPath,
                LoginTopBannerDelflag: $('#selectfuLoginTopBannerUse').val(),
                LoginBgImgName: loginBg,
                LoginBgImgPath: loginBgPath,
                LoginBgImgDelflag: $('#selectLginBackImgUse').val(),
                LoginCompLogoName: loginCompLogo,
                LoginCompLogoPath: loginCompLogoPath,
                LoginCompLogoDelflag: $('#selectLoginCompLogoUse').val(),
                LoginCopyrightName: loginCopyright,
                LoginCopyrightPath: loginCopyrightPath,
                LoginCopyrightDelflag: $('#selectLoginCopyrightUse').val(),



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
            data.append("OldTopLogoPath", oldToplogoPath);
            data.append("OldBottomLogoPath", oldBottomLogoPath);
            data.append("OldCopyPath", oldCopyPath);
            data.append("OldTopBannerPath", OldTopBannerPath);
            data.append("OldTopBannerDetailPath", OldTopBannerDetailPath);
            data.append("OldLoginFaviconPath", OldLoginFaviconPath);
            data.append("OldLoginTbannerPath", OldLoginTbannerPath);
            data.append("OldLoginBgPath", OldLoginBgPath);
            data.append("OldLoginCompLogoPath", OldLoginCompLogoPath);
            data.append("OldLoginCopyPath", OldLoginCopyPath);

            data.append("Favicon", faviconFile[0]);
            data.append("Css", cssFile[0]);
            data.append("TopLogo", topLogoFile[0]);
            data.append("BottomLogo", bottomLogoFile[0]);
            data.append("CopyRight", copyFile[0]);
            data.append("TopBanner", topBannerFile[0]);
            data.append("TopBannerDetail", topBannerDetailFile[0]);
            data.append("LoginFavicon", loginFaviconFile[0]);
            data.append("LoginTBanner", loginTbannerFile[0]);
            data.append("LoginBg", loginBgFile[0]);
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

                (alert('저장되었습니다.'));
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
                    $('#divMain').css('display', '');
                    $('#divBtn').css('display', '');
                    $('#divTab').css('display', '');
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

        function fnDeleteMgtImage(type) {

            if (!confirm('정말 삭제하시겠습니까?')) {
                return false;
            }

            var callback = function (response) {

                if (response == 'OK') {

                    fnDistInfo();
                }
                else {
                    alert('시스템 오류입니다 시스템 관리자에게 문의하세요');

                }
                return false;
            }

            var filePath = '';

            switch (type) {

                case "Favicon":
                    filePath = $('#hfFaviconPath').val();
                    break;
                case "Css":
                    filePath = $('#hfCssPath').val();
                    break;
                case "Tlogo":
                    filePath = $('#hfTopLogoPath').val();
                    break;
                case "Blogo":
                    filePath = $('#hfBottomLogoPath').val();
                    break;
                case "Copy":
                    filePath = $('#hfCopyrightPath').val();
                    break;
                case "LoginFavicon":
                    filePath = $('#hfLoginFaviconPath').val();
                    break;
                case "LoginTBanner":
                    filePath = $('#hfLoginTopBannerPath').val();
                    break;
                case "LoginTBg":
                    filePath = $('#hfLoginBackPath').val();
                    break;
                case "LoginCompLogo":
                    filePath = $('#hfLoginCompLogoPath').val();
                    break;
                case "LoginCopy":
                    filePath = $('#hfLoginCopyrightPath').val();
                    break;
                case "TBanner":
                    filePath = $('#hfTopBannerPath').val();
                    break;
                case "TBannerDetail":
                    filePath = $('#hfTopBannerDetailPath').val();
                    break;
                default:
            }

            var param = {


                DCode: $('#txtCode').val(),
                Type: type,
                DeleteFilePath: filePath,
                Method: 'DeleteDistMgtImg'

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
            //if ($('#cbCopyMenu').is(":checked")) {
            //    types += 'Menu/';
            //}
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
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
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
                        <th>
                           회사검색
                        </th>
                        <td>
                            <input type="text" ID="txtCompSearch" style="width:150px;">
                            <input type="button" class="mainbtn type1" value="검색" style="width:75px; height:25px;" onclick="fnSearchCompanyPopup(); return false;">
                        </td>
                        <th>
                           배포코드
                        </th>
                        <td>
                            <input type="text"  style="width:150px;" id="txtCode">
                            <input type="button" class="mainbtn type1" value="검색" style="width:75px; height:25px;" onclick="fnDistPopup(); return false;">
                            <input type="button" class="mainbtn type1" value="신규생성" style="width:75px; height:25px;" onclick="fnSetNextCode(); return false;">
                            <input type="button" id="btnSaveDefault" class="mainbtn type1" value="기본설정 저장" style="display:none;  width:105px; height:25px;" onclick="fnSaveDefault(); return false;">
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
                 <input type="button" class="mainbtn type1" style="width:95px; height:30px;" value="저장" onclick="return fnSaveDiscMgt();"/>
                 <input type="button" class="mainbtn type1" style="width:155px; height:30px;" value="타사이트에 복사하기" onclick="return fnOpenCopy();"/>
            </div>

            <!--탭영역-->
            <div id="divTab" class="div-main-tab" style="width: 100%; display:none">
                <ul>
                    <li class='tabOn' style="width: 185px;">
                        <a id="tabDefault">배포기본</a>
                     </li>
                    <li class='tabOff' style="width: 185px;">
                         <a id="tabPopup">배포팝업</a>
                    </li>
                    <%--<li class='tabOff' style="width: 185px;" >
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
                    <span>*텍스트 설정</span>
                </div>
               <table class="tbl_main">
                    <tr>
                        <th>
                           연동 판매사명
                        </th>
                        <td>
                            <input type="text"  style="width:90%" id="txtCompName">
                        </td>
                        <th>
                           연동 판매사 주소
                        </th>
                        <td>
                            <input type="text"  style="width:90%" id="txtAddress">
                        </td>
                    </tr>

                    <tr>
                        <th>
                            Tab Title
                        </th>
                        <td>
                             <input type="text"  style="width:90%" id="txtTabTitle">
                        </td> 
                         <th>
                            검색창 문구
                        </th>
                        <td>
                             <input type="text"  style="width:90%" id="txtSearchPhrases">
                        </td>
                     </tr>
                     <tr>
                        <th>
                            약관 회사명
                        </th>
                        <td>
                             <input type="text"  style="width:90%" id="txtDistCompanyName">
                        </td>
                        <th>
                           고객센터 Tel
                        </th>
                        <td>
                             <input type="text"  style="width:90%" id="txtTel">
                        </td>
                      </tr>
                      <tr>
                           <th>
                               구글 웹분석 코드
                           </th>
                          <td>
                              <input type="text"  style="width:90%" id="txtGoogleCode">
                          </td>
                          <th>
                               Daum 지도코드
                           </th>
                          <td>
                               <input type="text"  style="width:90%" id="txtDaumCode">
                          </td>
                      </tr>
                      <tr>
                           <th>
                               Meta Tag
                           </th>
                          <td colspan="3">
                               <input type="text"  style="width:90%" id="txtMetatag">
                          </td>
                      </tr>
                </table>

                <div class="admin-maincontents-subtitle">
                    <span>*관리 요소 설정</span>
                </div>
               <table class="tbl_main">
                    <tr>
                        <th style="width:30%">
                           구분
                        </th>
                        <th style="width:40%">
                           파일명
                        </th>
                        <th style="width:30%">
                           이미지 저장
                        </th>
                    </tr>

                    <tr>
                        <th>
                            Favicon
                        </th>
                         <td>
                             <p id="lblFavicon"></p>
                        </td>
                        <td>
                             <input type="file"  style="width:90%" id="fuFavicon">
                             <input type="hidden"  id="hfFaviconPath">
                        </td>
                     </tr>
                   <tr>
                        <th>
                            CSS
                        </th>
                         <td>
                             <p id="lblCss"></p>
                        </td>
                        <td>
                             <input type="file"  style="width:90%" id="fuCss">
                             <input type="hidden"  id="hfCssPath">
                        </td>
                     </tr>
                   <tr>
                        <th>
                            상단 로고
                        </th>
                         <td>
                             <p id="lblTopLogo"></p>
                        </td>
                        <td>
                             <input type="file"  style="width:90%" id="fuTopLogo">
                             <input type="hidden"  id="hfTopLogoPath">
                        </td>
                     </tr>
                   <tr>
                        <th>
                            하단 로고
                        </th>
                         <td>
                             <p id="lblBottomLogo"></p>
                        </td>
                        <td>
                             <input type="file"  style="width:90%" id="fuBottomLogo">
                             <input type="hidden"  id="hfBottomLogoPath">
                        </td>
                     </tr>
                   <tr>
                        <th>
                            카피라이트
                        </th>
                         <td>
                             <p id="lblCopyright"></p>
                        </td>
                        <td>
                             <input type="file"  style="width:90%" id="fuCopyright">
                             <input type="hidden"  id="hfCopyrightPath">
                        </td>
                     </tr>
                     
                </table>

                <div class="admin-maincontents-subtitle">
                    <span>*로그인 페이지 설정</span>
                </div>
               <table class="tbl_main">
                    <tr>
                        <th style="width:30%">
                           구분
                        </th>
                        <th style="width:10%">
                           사용유무
                        </th>
                        <th style="width:30%">
                           파일명
                        </th>
                        <th style="width:30%">
                           이미지 저장
                        </th>
                    </tr>
                   <tr>
                        <th>
                           Login Favicon
                        </th>
                        <td class="txt-center">
                            <select id="selectLoginFaviconUse">
                                <option value="N">예</option>
                                <option value="Y">아니오</option>
                            </select>
                        </td> 
                         <td>
                             <p id="lblLoginFavicon"></p>
                        </td>
                        <td>
                             <input type="file"  style="width:90%" id="fuLoginFavicon">
                             <input type="hidden"  id="hfLoginFaviconPath">
                        </td>
                     </tr>
                    <tr>
                        <th>
                           Login Top 배너
                        </th>
                        <td class="txt-center">
                            <select id="selectfuLoginTopBannerUse">
                                <option value="N">예</option>
                                <option value="Y">아니오</option>
                            </select>
                        </td> 
                         <td>
                             <p id="lblLoginTopBanner"></p>
                        </td>
                        <td>
                             <input type="file"  style="width:90%" id="fuLoginTopBanner">
                             <input type="hidden"  id="hfLoginTopBannerPath">
                        </td>
                     </tr>
                  <tr>
                        <th>
                            배경 이미지
                        </th>
                        <td class="txt-center">
                            <select id="selectLginBackImgUse">
                                 <option value="N">예</option>
                                <option value="Y">아니오</option>
                            </select>
                        </td> 
                         <td>
                             <p id="lblLoginBackImg"></p>
                        </td>
                        <td>
                             <input type="file"  style="width:90%" id="fuLoginBackimg">
                             <input type="hidden"  id="hfLoginBackPath">
                        </td>
                     </tr>
                   <tr>
                        <th>
                           기업 로고
                        </th>
                        <td class="txt-center">
                            <select id="selectLoginCompLogoUse">
                               <option value="N">예</option>
                                <option value="Y">아니오</option>
                            </select>
                        </td> 
                         <td>
                             <p id="lblLoginCompLogo"></p>
                        </td>
                        <td>
                             <input type="file"  style="width:90%" id="fuLoginCompLogo">
                             <input type="hidden"  id="hfLoginCompLogoPath">
                        </td>
                     </tr>
                   <tr>
                        <th>
                            카피라이트
                        </th>
                        <td class="txt-center">
                            <select id="selectLoginCopyrightUse">
                              <option value="N">예</option>
                                <option value="Y">아니오</option>
                            </select>
                        </td> 
                         <td>
                             <p id="lblLoginCopyright"></p>
                        </td>
                        <td>
                             <input type="file"  style="width:90%" id="fuLoginCopyright">
                              <input type="hidden"  id="hfLoginCopyrightPath">
                        </td>
                     </tr>
                     
                </table>

                <div class="admin-maincontents-subtitle">
                    <span>*Master Top 배너 설정</span>
                </div>
               <table class="tbl_main">
                    <tr>
                        <th style="width:10%">
                           구분
                        </th>
                        <th style="width:7%">
                           사용유무
                        </th>
                        <th style="width:13%">
                           파일명
                        </th>
                        <th style="width:13%">
                           이미지 저장
                        </th>
                        <th style="width:13%">
                           상세 파일명
                        </th>
                        <th style="width:13%">
                           이미지 저장
                        </th>
                        <th style="width:20%">
                           링크 URL
                        </th>
                    </tr>
                   <tr>
                        <th>
                          Top 배너
                        </th>
                        <td class="txt-center">
                            <select id="selectTopBannerUse">
                                <option value="N">예</option>
                                <option value="Y">아니오</option>
                            </select>
                        </td> 
                         <td>
                             <p id="lblTopBanner"></p>
                        </td>
                        <td>
                             <input type="file"  style="width:90%" id="fuTopBanner">
                             <input type="hidden"  id="hfTopBannerPath">
                        </td>
                        <td>
                             <p id="lblTopBannerDetail"></p>
                        </td>
                        <td>
                             <input type="file"  style="width:90%" id="fuTopBannerDetail">
                              <input type="hidden"  id="hfTopBannerDetailPath">
                        </td>
                        <td>
                            <input type="text"  style="width:90%" id="txtTopBannerUrl">
                        </td>
                     </tr>
                </table>
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
                <div class="search-div">
                    <select style="width: 150px;" id="selectGubun">
                        <option value="SU">판매사</option>
                        <option value="BU">구매사</option>
                    </select>
                    <input type="text" id="txtPopSearchComp" onkeypress="return fnPopupEnter();" style="width: 300px;" />
                    <input type="button" class="mainbtn type1" style="width: 75px; height: 25px;" value="검색" onclick="fnSearchCompanyList(1); return false;" />
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
                <div class="popup-title">
                    <h3 class="pop-title">배포코드 검색</h3>
                </div>
                <div class="divpopup-layer-conts">
                    <input type="hidden" id="hdSelectDistCssCode" />
                    <input type="hidden" id="hdDistCssCode" />
                    <input type="hidden" id="hdSelectDistCssName" />
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
                    <input type="button" class="mainbtn type1" style="width:75px;" value="확인" onclick="fnDistConfirm(); return false;" />
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
                    <h3 class="pop-title">배포코드 검색(복사용)</h3>
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
                        <input type="button" class="mainbtn type1" style="width:95px; height:30px;" value="검색" onclick="fnDistCopyList(1); return false;"/>
                    </div>
                <div>
                    <input type="checkbox" id="cbCopyDefault" />기본
                    <input type="checkbox" id="cbCopyLogin" />로그인 페이지
                    <input type="checkbox" id="cbCopyPopup" />팝업
                   <%-- <input type="checkbox" id="cbCopyMenu" />메뉴--%>
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
                    <input type="button" class="mainbtn type1" style="width: 95px; height: 30px;" value="저장" onclick="fnDistCopySave(); return false;" />
                </div>

            </div>
        </div>
    </div>
</asp:Content>

