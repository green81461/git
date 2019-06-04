<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Master/AdminMasterPage.master" AutoEventWireup="true" CodeFile="SiteInfoPartner.aspx.cs" Inherits="Admin_Setting_SiteInfoPartner" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
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

                location.href = 'SiteInfoDefault.aspx?CssCode=' + $('#hdDistCssCode').val() + '&CompCode=' + $('#txtCompSearch').val() + '&CompName=' + $('#lblCompName').text()+ '&ucode=' + ucode;;
            });
            $("#tabPopup").on("click", function () {

                location.href = 'SiteInfoPopup.aspx?CssCode=' + $('#hdDistCssCode').val() + '&CompCode=' + $('#txtCompSearch').val() + '&CompName=' + $('#lblCompName').text()+ '&ucode=' + ucode;;
            });
            //$("#tabMenu").on("click", function () {

            //    location.href = 'SiteInfoMenu.aspx?CssCode=' + $('#hdDistCssCode').val() + '&CompCode=' + $('#txtCompSearch').val() + '&CompName=' + $('#lblCompName').text()+ '&ucode=' + ucode;;
            //});
            $("#tabBanner").on("click", function () {

                location.href = 'SiteInfoBanner.aspx?CssCode=' + $('#hdDistCssCode').val() + '&CompCode=' + $('#txtCompSearch').val() + '&CompName=' + $('#lblCompName').text()+ '&ucode=' + ucode;;
            });
            $("#tabPartner").on("click", function () {

                location.href = 'SiteInfoPartner.aspx?CssCode=' + $('#hdDistCssCode').val() + '&CompCode=' + $('#txtCompSearch').val() + '&CompName=' + $('#lblCompName').text()+ '&ucode=' + ucode;;
            });


            if (!isEmpty(qsCssCode)) {

                $('#txtCompSearch').val(qsCompCode);
                $('#lblCompName').text(qsCompName);
                $('#txtCode').val(qsCssCode);
                fnDistInfo();
                fnGetDistPartner();
                fnGetDistDiperson();
                $('#divMain').css('display', '');
                $('#divBtn').css('display', '');
                $('#divTab').css('display', '');
            }

        })

        
			
        <%--function fnGetPartnerNextSeq() {

            var callback = function (response) {
                if (!isEmpty(response)) {
                    $('#hdPartnerNextSeq').val(response);
                }
                else {
                    $('#hdPartnerNextSeq').val(1);
                }
                return false;
            }

            var param = {

                Method: 'GetNextDistCssPartnerSeq'

            };


            //type, url, async, cache, data, datatype, _callback, _beforeSend, _complete, issessionCheck, sessionValue
            JqueryAjax('Post', '../../Handler/Common/DistCssHandler.ashx', true, false, param, 'text', callback, null, null, true, '<%=Svid_User%>');


        }

        function fnGetDipersonNextSeq() {

            var callback = function (response) {
                if (!isEmpty(response)) {
                    $('#hdDipersonNextSeq').val(response);
                }
                else {
                    $('#hdDipersonNextSeq').val(1);
                }
                return false;
            }

            var param = {

                Method: 'GetNextDistCssDipersonSeq'

            };


            //type, url, async, cache, data, datatype, _callback, _beforeSend, _complete, issessionCheck, sessionValue
            JqueryAjax('Post', '../../Handler/Common/DistCssHandler.ashx', true, false, param, 'text', callback, null, null, true, '<%=Svid_User%>');


        }--%>

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
            fnEmptyTable('tblPartner');
            fnEmptyTable('tblDiperson');
            $("input[type='text'][id^='txt']").val('');
            $("input[type='file'][id^='fu']").val('');
            $("p[id^='lbl']").text('');
            $("span[id^='span']").text('');
            $("input[type='radio'][id^='rb']").prop('checked', false);
        }

        function fnEmptyTable(tableid) {
             $("#"+tableid+"").empty();
            var emptyTag = '';

            if (tableid == 'tblPartner') {
                    emptyTag += '<td class="txt-center"><input type="hidden" id="hdRowPartnerSeq" value="0"><input type="text" style="width: 100%" value="1" id="txtPartnerSeq"/></td>'
                    emptyTag += '<td class="txt-center"></td>'
                    emptyTag += '<td class="txt-center"><input type="text" style="width: 100%"  id="txtPartnerUrl"/></td>'
                    emptyTag += '<td class="txt-center"><input type="text" style="width: 100%"  id="txtPartnerCaption"/></td>'
                    emptyTag += '<td class="txt-center"></td>'
                    emptyTag += '<td class="txt-center"><input type="file" id="fuPartner" /></td>'
                    emptyTag += "<td style='text-align:center'><input type='button' class='btnDelete' value='삭제' style='width:55px' onclick='fnDeletePartnerTableRow(this); return false;'/></td>"
                    emptyTag += '</tr>';
            }

            else if (tableid == 'tblDiperson') {
                    emptyTag += '<td class="txt-center"><input type="hidden" id="hdRowDipersonSeq" value="0"><input type="text" style="width: 100%" value="1" id="txtDipersonSeq"/></td>'
                    emptyTag += '<td class="txt-center"></td>'
                    emptyTag += '<td class="txt-center"><input type="text" style="width: 100%"  id="txtDipersonUrl"/></td>'
                    emptyTag += '<td class="txt-center"><input type="text" style="width: 100%"  id="txtDipersonCaption"/></td>'
                    emptyTag += '<td class="txt-center"></td>'
                    emptyTag += '<td class="txt-center"><input type="file" id="fuDiperson" /></td>'
                    emptyTag += "<td style='text-align:center'><input type='button' class='btnDelete' value='삭제' style='width:55px;' onclick='fnDeleteDipersonTableRow(this); return false;'/></td>"
                    emptyTag += '</tr>';
            }

            $("#"+tableid+"").append(emptyTag);
        }

        function fnDistConfirm() {
            var hdCode = $("#hdSelectDistCssCode").val();
            var hdName = $("#hdSelectDistCssName").val();

            $('#txtCode').val(hdCode);


            fnDistInfo();
            fnGetDistPartner();
            fnGetDistDiperson();
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

        function fnGetDistPartner() {

            var callback = function (response) {
                $("#tblPartner").empty();
                var newRowContent = '';
                if (!isEmpty(response)) {
                    $.each(response, function (key, value) { //테이블 추가

                        newRowContent += "<tr>";
                        newRowContent += "<td  style='text-align:center'><input type='hidden' id='hdRowPartnerSeq' value='" + value.SeqNo + "'><input type='text' style='width:100%' value='" + value.Seq + "' id='txtPartnerSeq'></input></td>";
                        newRowContent += "<td style='text-align:center'></td>";
                        newRowContent += "<td style='text-align:center'><input type='text' style='width:100%' value='" + value.PartnerUrl + "' id='txtPartnerUrl'></input></td>";
                        newRowContent += "<td style='text-align:center'><input type='text' style='width:100%' value='" + value.PartnerCaption + "' id='txtPartnerCaption'></input></td>";

                        var deleteButton = '';
                        var partnerFilePath = ''
                        if (!isEmpty(value.PartnerName)) {
                            deleteButton = '&nbsp;&nbsp;<img src="/Admin/Images/icon-delete.jpg"  alt="x" onclick="fnDeletePartnerImage(this, \'Partner\'); return false" id="" style="cursor:pointer;"/>';
                            partnerFilePath = "/SiteManagement/" + $('#txtCode').val() + "/Partner/" + value.PartnerName;
                        }

                        newRowContent += "<td style='text-align:center'><input type='hidden' id='hdRowPartnerPath' value='" + partnerFilePath + "'/><span id='spanPartnername'>" + value.PartnerName + "</span>" + deleteButton + "</td>";

                        var file = "<input type='file' id='fuPartner" + key + "'/>";
                        var btn = "<input type='button' class='btnDelete' value='저장' style='width:55px;' onclick=''/>";
                        var addBtn = "<input type='button' class='btnDelete' value='추가' style='width:55px;' onclick='fnAddTableRow(this); return false;'/>"

                        newRowContent += "<td style='text-align:center'>" + file + "</td>";
                        newRowContent += "<td style='text-align:center'><input type='button' class='btnDelete' value='삭제' style='width:55px;' onclick='fnDeletePartner(this, \"Partner\"); return false;'/></td>";
                        newRowContent += "</tr>";

                    });
                    $("#tblPartner").append(newRowContent);
                }
                else {
                    var emptyTag = '<tr>'
                    emptyTag += '<td class="txt-center"><input type="hidden" id="hdRowPartnerSeq" value="0"><input type="text" style="width: 100%" value="1" id="txtPartnerSeq"/></td>'
                    //emptyTag += '<td class="txt-center"><input type="checkbox" id="cbPartnerCheck" /></td>'
                    emptyTag += '<td class="txt-center"></td>'
                    emptyTag += '<td class="txt-center"><input type="text" style="width: 100%"  id="txtPartnerUrl"/></td>'
                    emptyTag += '<td class="txt-center"><input type="text" style="width: 100%"  id="txtPartnerCaption"/></td>'
                    emptyTag += '<td class="txt-center"></td>'
                    emptyTag += '<td class="txt-center"><input type="file" id="fuPartner" /></td>'
                    emptyTag += "<td style='text-align:center'><input type='button' class='btnDelete' value='삭제' style='width:55px' onclick='fnDeletePartnerTableRow(this); return false;'/></td>"
                    emptyTag += '</tr>';

                    $("#tblPartner").append(emptyTag);
                }



                return false;
            }
            var param = {

                Code: $('#txtCode').val(),
                Method: 'GetDistCssPartner'

            };


            //type, url, async, cache, data, datatype, _callback, _beforeSend, _complete, issessionCheck, sessionValue
            JqueryAjax('Post', '../../Handler/Common/DistCssHandler.ashx', false, false, param, 'json', callback, null, null, true, '<%=Svid_User%>');
        }

        function fnGetDistDiperson() {

            var callback = function (response) {
                $("#tblDiperson").empty();
                var newRowContent = '';
                if (!isEmpty(response)) {
                    $.each(response, function (key, value) { //테이블 추가

                        newRowContent += "<tr>";
                        newRowContent += "<td  style='text-align:center'><input type='hidden' id='hdRowDipersonSeq' value='" + value.SeqNo + "'><input type='text' style='width:100%' value='" + value.Seq + "' id='txtDipersonSeq'></input></td>";
                        newRowContent += "<td style='text-align:center'></td>";
                        newRowContent += "<td style='text-align:center'><input type='text' style='width:100%' value='" + value.DipersonUrl + "' id='txtDipersonUrl'></input></td>";
                        newRowContent += "<td style='text-align:center'><input type='text' style='width:100%' value='" + value.DipersonCaption + "' id='txtDipersonCaption'></input></td>";

                        var deleteButton = '';
                        var dipersonFilePath = ''
                        if (!isEmpty(value.DipersonName)) {
                            deleteButton = '&nbsp;&nbsp;<img src="/Admin/Images/icon-delete.jpg"  alt="x" onclick="fnDeletePartnerImage(this, \'Diperson\'); return false" id="" style="cursor:pointer;"/>';
                            dipersonFilePath = "/SiteManagement/" + $('#txtCode').val() + "/Partner/" + value.DipersonName;
                        }
                        newRowContent += "<td style='text-align:center'><input type='hidden' id='hdRowDipersonPath' value='" + dipersonFilePath + "'/><span id='spanDipersonname'>" + value.DipersonName + "</span>" + deleteButton + "</td>";

                        var file = "<input type='file' id='fuDiperson" + key + "'/>";
                        var btn = "<input type='button' class='listBtn' value='저장' style='width:55px; height:22px; font-size:12px' onclick=''/>";
                        var addBtn = "<input type='button' class='btnDelete' value='추가' style='width:55px;' onclick='fnAddTableRow(this); return false;'/>"

                        newRowContent += "<td style='text-align:center'>" + file + "</td>";
                        newRowContent += "<td style='text-align:center'><input type='button' class='btnDelete' value='삭제' style='width:55px;' onclick='fnDeletePartner(this, \"Diperson\"); return false;'/></td>";
                        newRowContent += "</tr>";

                    });
                    $("#tblDiperson").append(newRowContent);
                }
                else {
                    var emptyTag = '<tr>'
                    emptyTag += '<td class="txt-center"><input type="hidden" id="hdRowDipersonSeq" value="0"><input type="text" style="width: 100%" value="1" id="txtDipersonSeq"/></td>'
                    //emptyTag += '<td class="txt-center"><input type="checkbox" id="cbDipersonCheck" /></td>'
                    emptyTag += '<td class="txt-center"></td>'
                    emptyTag += '<td class="txt-center"><input type="text" style="width: 100%"  id="txtDipersonUrl"/></td>'
                    emptyTag += '<td class="txt-center"><input type="text" style="width: 100%"  id="txtDipersonCaption"/></td>'
                    emptyTag += '<td class="txt-center"></td>'
                    emptyTag += '<td class="txt-center"><input type="file" id="fuDiperson" /></td>'
                    emptyTag += "<td style='text-align:center'><input type='button' class='btnDelete' value='삭제' style='width:55px;' onclick='fnDeleteDipersonTableRow(this); return false;'/></td>"
                    emptyTag += '</tr>';

                    $("#tblDiperson").append(emptyTag);
                }


                return false;
            }
            var param = {

                Code: $('#txtCode').val(),
                Method: 'GetDistCssDiperson'

            };


            //type, url, async, cache, data, datatype, _callback, _beforeSend, _complete, issessionCheck, sessionValue
            JqueryAjax('Post', '../../Handler/Common/DistCssHandler.ashx', false, false, param, 'json', callback, null, null, true, '<%=Svid_User%>');
        }

        function fnAddTableRow(value, type) {


            var currentRowCount = $('#tbl' + type + ' >tr').length + 1;
            
            var asynTable = "";
            asynTable += "<tr>";
            asynTable += "<td class='txt-center'><input type='hidden' id='hdRow"+type+"Seq' value='0'><input type='text' style='width:100%' id='txt" + type+"Seq' value='" + currentRowCount + "'/>";
            asynTable += "</td>";
            asynTable += "<td>";
            asynTable += "</td>";
            asynTable += "<td><input type='text' style='width:100%' id='txt" + type +"Url'/ >";
            asynTable += "</td>";
            asynTable += "<td><input type='text' style='width:100%' id='txt" + type +"Caption'/ >";
            asynTable += "</td>";
            asynTable += "<td>";
            asynTable += "</td>";
            asynTable += "<td><input type='file' id='fu" + type + currentRowCount + "' >";
            asynTable += "</td>";
            asynTable += "<td class='txt-center'><input type='button' class='listBtn' value='삭제' style='width:55px; height:22px; font-size:12px' onclick='fnDeleteTableRow(this,\""+ type+"\"); return false;'/>";
            asynTable += "</td>";
            asynTable += "</tr>";
            $("#tbl" + type+"").append(asynTable);
        }

        function fnDeleteTableRow(obj, type) {
            var currentRowCount = $('#tbl' + type+' >tr').length;

            if (currentRowCount == 1) {

                alert('행이 1개 남았을 경우에는 삭제할 수 없습니다.');
                return false;
            }
            var tr = $(obj).parent().parent();
            tr.remove();
            return false;
        }
        
        function fnSaveDiscPartner() {

            if (isEmpty($('#txtCode').val())) {
                alert('배포코드를 검색해 주세요.');
                $('#txtCode').focus();
                return false;
            }

            var jsonPartner = [];
            var jsonDiperson = [];
            var nowDate = new Date();  
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
            $("#tblPartner  tr").each(function () {
                var pOldPath = $(this).children().find('#hdRowPartnerPath').val();
                var pName = $(this).children().find('#spanPartnername').text();
                var mainFile = $(this).children().find('input[id*="fuPartner"]').get(0).files[0];
                var keySeq = $(this).children().find('#hdRowPartnerSeq').val();
                var pSeq = $(this).children().find('#txtPartnerSeq').val();

                var dCode = $('#txtCode').val();
                var pUrl = $(this).children().find('#txtPartnerUrl').val();
                var pCaption = $(this).children().find('#txtPartnerCaption').val();
                
                var mainFileName = '';
                var mainFilePath = '';
                if (mainFile != null) {
                    var mainFileNameExt = $(this).children().find('input[id*="fuPartner"]').val().split('.').pop().toLowerCase();
                    mainFileName = 'p-'+ nowDate.format('yyMMdd') + '-' + pSeq+ '.' + mainFileNameExt;
                    mainFilePath = '/SiteManagement/' + $('#txtCode').val() + '/Partner/' + mainFileName;
                }

                jsonPartner.push({
                        KeySeq : keySeq,
                        PSeq: pSeq,
                        PCaption: pCaption,
                        PName: mainFileName,
                        PPath: mainFilePath,
                        POldPath: pOldPath,
                        PUrl: pUrl,
                });
                


            });

            $("#tblDiperson  tr").each(function () {
                var dOldPath = $(this).children().find('#hdRowDipersonPath').val();
                var dName = $(this).children().find('#spanDipersonname').text();
                var dMainFile = $(this).children().find('input[id*="fuDiperson"]').get(0).files[0];
                var keySeq = $(this).children().find('#hdRowDipersonSeq').val();
                var dSeq = $(this).children().find('#txtDipersonSeq').val();
                var dCode = $('#txtCode').val();
                var dUrl = $(this).children().find('#txtDipersonUrl').val();
                var dCaption = $(this).children().find('#txtDipersonCaption').val();
                var dMainFileName = '';
                var dMainFilePath = '';
                if (dMainFile != null) {
                    var dMainFileNameExt = $(this).children().find('input[id*="fuDiperson"]').val().split('.').pop().toLowerCase();
                    dMainFileName = 'd-' + nowDate.format('yyMMdd') + '-' + dSeq+ '.' + dMainFileNameExt;
                    dMainFilePath = '/SiteManagement/' + $('#txtCode').val() + '/Partner/' + dMainFileName;
                }

                
                jsonDiperson.push({
                        KeySeq : keySeq,
                        DSeq: dSeq,
                        DCaption: dCaption,
                        DName: dMainFileName,
                        DPath: dMainFilePath,
                        DOldPath: dOldPath,
                        DUrl: dUrl,
                    });
                


            });

            var callback = function (response) {

                if (response == 'OK') {
                    alert('저장되었습니다.');
                    fnDistInfo();
                    
                    fnGetDistPartner();
                    fnGetDistDiperson();
                    //fnGetPartnerNextSeq();
                    //fnGetDipersonNextSeq();
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
                    data.append("PartnerData", JSON.stringify(jsonPartner));
                    data.append("DipersonData", JSON.stringify(jsonDiperson));
                    data.append("Method", 'SaveDistPartner_Type2');
                    $("#tblPartner tr").each(function () {
                        data.append($(this).children().find('#txtPartnerSeq').val() + 'PFile', $(this).children().find('input[id*="fuPartner"]').get(0).files[0]);
                    });
                    $("#tblDiperson tr").each(function () {
                        data.append($(this).children().find('#txtDipersonSeq').val() + 'DFile', $(this).children().find('input[id*="fuDiperson"]').get(0).files[0]);
                    });
                    return data;
                }(),
            });
        }

       

        function fnDeletePartner(el, type) {
            
            if (!confirm('데이터가 정말 삭제됩니다. 계속 진행하시겠습니까?')) {
                return false;
            }

            var callback = function (response) {

                if (response == 'OK') {

                    fnGetDistPartner();
                    fnGetDistDiperson();
                    //fnGetPartnerNextSeq();
                    //fnGetDipersonNextSeq();
                    return false;
                }
                else {
                    alert('협력사 삭제중 오류가 생겼습니다. 시스템 관리자에게 문의하세요.');
                    return false;
                }
            }
            var seq = $(el).parent().parent().children().find('#hdRow' + type+ 'Seq').val();
            var filePath = $(el).parent().parent().children().find('#hdRow' + type+ 'Path').val();
            var param = {

                DCode: $('#txtCode').val(),
                Method: 'DeleteDist' + type+ '',
                Seq: seq,
                FilePath: filePath,

            };

            JqueryAjax('Post', '../../Handler/Common/DistCssHandler.ashx', false, false, param, 'text', callback, null, null, true, '<%=Svid_User%>');
            return false;
        }

        function fnDeletePartnerImage(el, type) {


            if (!confirm('정말 삭제하시겠습니까?')) {
                return false;
            }

            var callback = function (response) {

                if (response == 'OK') {

                    fnGetDistPartner();
                    fnGetDistDiperson();
                    //fnGetPartnerNextSeq();
                    //fnGetDipersonNextSeq();
                }
                else {
                    alert('시스템 오류입니다 시스템 관리자에게 문의하세요');

                }
                return false;
            }
            var seq = $(el).parent().parent().children().find('#hdRow' + type + 'Seq').val();
            var filePath = $(el).parent().parent().children().find('#hdRow' + type + 'Path').val();

            var param = {


                DCode: $('#txtCode').val(),
                Seq: seq,
                DeleteFilePath: filePath,
                Method: 'Delete' + type + 'Img'

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
                <input type="button" class="mainbtn type1" style="width: 95px; height: 30px; font-size: 12px" value="저장" onclick="return fnSaveDiscPartner();" />
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
                    <li class='tabOff' style="width: 185px;" >
                         <a id="tabBanner">배포배너</a>
                    </li>
                    <li class='tabOn' style="width: 185px;" >
                        <a id="tabPartner">배포기관</a>
                    </li>
                </ul>
            </div>
			
            <!--기본사항 영역 시작-->
            <div style="margin-top: 50px;" class="search-div">
                <input type="hidden" id="hdDipersonNextSeq" />
                <div id="divMain" class="admin-maincontents" style="display:none">
                    <div class="admin-maincontents-subtitle">
                        <span>*중증 장애인, 생산품 이미지링크 관리(사이즈고정 :370*120)</span>
                    </div>

                    <table class="tbl_main">
                        <thead>
                            <tr>
                                <th style="width: 80px">순서
                                </th>
                                <th style="width: 80px">사용유무
                                </th>
                                <th style="width: 300px">링크 Url
                                </th>
                                <th style="width: 150px">요약명
                                </th>
                                <th style="width: 200px">이미지 파일명
                                </th>
                                <th>이미지 업로드
                                </th>
                                <th style="width: 150px">
                                    <input type='button' class='btnDelete' value='추가' style='width: 55px;' onclick='fnAddTableRow(this, "Diperson"); return false;' />
                                </th>
                            </tr>
                        </thead>
                        <tbody id="tblDiperson">
                            <tr>
                                <td class="txt-center">
                                    <input type="text" style="width: 100%" value="1" id="txtDipersonSeq" />
                                </td>
                                <td class="txt-center">
                                 <%--   <input type="checkbox" id="cbPartnerCheck" />--%>
                                </td>
                                <td class="txt-center">
                                    <input type="text" style="width: 100%" id="txtDipersonUrl" />
                                </td>
                                <td class="txt-center">
                                    <input type="text" style="width: 100%" id="txtDipersonCaption"/>
                                </td>
                                <td class="txt-center"></td>
                                <td class="txt-center">
                                    <input type="file" id="fuDiperson" />
                                </td>
                                <td class="txt-center">
                                    <input type='button' class='listBtn' value='삭제' style='width: 55px; height: 22px; font-size: 12px' onclick='fnDeleteTableRow(this,"Diperson"); return false;' />
                                </td>
                            </tr>

                        </tbody>
                    </table>
                    <div class="admin-maincontents-subtitle">
                        <input type="hidden" id="hdPartnerNextSeq" />
                        <span>*협력사 이미지링크 관리 (사이즈고정 :160*53)</span>
                    </div>
                    <table class="tbl_main">
                        <thead>
                            <tr>
                                <th style="width: 80px">순서
                                </th>
                                <th style="width: 80px">사용유무
                                </th>
                                <th style="width: 300px">링크 Url
                                </th>
                                <th style="width: 150px">요약명
                                </th>
                                <th style="width: 200px">이미지 파일명
                                </th>
                                <th>이미지 업로드
                                </th>
                                <th style="width: 150px">
                                    <input type='button' class='btnDelete' value='추가' style='width: 55px;' onclick='fnAddTableRow(this,"Partner"); return false;' />
                                </th>
                            </tr>
                        </thead>
                        <tbody id="tblPartner">
                            <tr>
                                <td class="txt-center">
                                    <input type="text" style="width: 100%" value="1" id="txtPartnerSeq" />
                                </td>
                                <td class="txt-center">
                                 <%--   <input type="checkbox" id="cbPartnerCheck" />--%>
                                </td>
                                <td class="txt-center">
                                    <input type="text" style="width: 100%" id="txtPartnerUrl" />
                                </td>
                                <td class="txt-center">
                                    <input type="text" style="width: 100%" />
                                </td>
                                <td class="txt-center"></td>
                                <td class="txt-center">
                                    <input type="file" id="fuPartner" />
                                </td>
                                <td class="txt-center">
                                    <input type='button' class='listBtn' value='삭제' style='width: 55px; height: 22px; font-size: 12px' onclick='fnDeleteTableRow(this, "Partner"); return false;' />
                                </td>
                            </tr>

                        </tbody>
                    </table>
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
                    <input type="button" class="mainbtn type1" style="width: 95px;" value="확인" onclick="fnConfirm(); return false;" />
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
                    <input type="button" class="mainbtn type1" style="width: 95px;" value="확인" onclick="fnDistConfirm(); return false;" />
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

