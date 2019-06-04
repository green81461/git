<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Master/AdminMasterPage.master" AutoEventWireup="true" CodeFile="SiteInfoPopupAll.aspx.cs" Inherits="Admin_Setting_SiteInfoPopupAll" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <script type="text/javascript">
        
        $(function () {
           
            fnGetDistPopup();
        })

        

        function fnAddTableRow(value) {


            var currentRowCount = $('#tblPopup >tr').length + 1;
            var asynTable = "";
            asynTable += "<tr>";
            asynTable += "<td class='txt-center'><input type='text' style='width:100%' id='txtPopupSeq' value='" + currentRowCount + "' onkeydown='return onlyNumbers(event);'/>";
            asynTable += "</td>";
            asynTable += "<td class='txt-center'> <select style='height: 26px; ' id='selectPopupUse'><option value='N'>예</option> <option value='Y'>아니오</option> </select>";
            asynTable += "</td>";
            asynTable += "<td class='txt-center'><input type='text' style='width:100%' id='txtPopupCaption'/ >";
            asynTable += "</td>";
            asynTable += "<td class='txt-center'><input type='text' style='width:100%' id='txtPopupTop' onkeydown='return onlyNumbers(event);'/ >";
            asynTable += "</td>";
            asynTable += "<td class='txt-center'><input type='text' style='width:100%' id='txtPopupLeft' onkeydown='return onlyNumbers(event);'/ >";
            asynTable += "</td>";
            asynTable += "<td class='txt-center'><input type='text' style='width:100%' id='txtPopupWidth' onkeydown='return onlyNumbers(event);'/ >";
            asynTable += "</td>";
            asynTable += "<td class='txt-center'><input type='text' style='width:100%' id='txtPopupheight' onkeydown='return onlyNumbers(event);'/ >";
            asynTable += "</td>";
            asynTable += "<td id='tdPopupFileName'>";
            asynTable += "</td>";
            asynTable += "<td class='txt-center'> <input type='file' id='fuPopup' class='fileC'>";
            asynTable += "</td>";
            asynTable += "<td class='txt-center'><input type='button' class='btnDelete' value='삭제' onclick='fnDeleteTableRow(this); return false;'/>";
            asynTable += "</td>";
            asynTable += "</tr>";
            $("#tblPopup").append(asynTable);
        }

        function fnDeleteTableRow(obj) {
            var currentRowCount = $('#tblPopup >tr').length;

            if (currentRowCount == 1) {

                alert('행이 1개 남았을 경우에는 삭제할 수 없습니다.');
                return false;
            }
            var tr = $(obj).parent().parent();
            tr.remove();
            return false;
        }


        function fnGetDistPopup() {
             
            var callback = function (response) {
                
                $("#tblPopup").empty();
                var newRowContent = '';
                if (!isEmpty(response)) {
                    $.each(response, function (key, value) { //테이블 추가

                        newRowContent += "<tr>";
                        newRowContent += "<td  style='text-align:center'><input type='hidden' id='hdRowPopupSeq' value='" + value.Seq + "'><input type='text' style='width:100%' value='" + value.Seq + "' id='txtPopupSeq'></input></td>";

                        var selectY = '';
                        var selectN = '';
                        if (value.Delflag == 'Y') {

                            selectY = 'selected';
                        }
                        else {
                            selectN = 'selected';
                        }
                        newRowContent += "<td style='text-align:center'><select style='height: 26px; ' id='selectPopupUse'><option value='N' " + selectN+">예</option> <option value='Y' "+ selectY+">아니오</option> </select></td>";
                        newRowContent += "<td style='text-align:center'><input type='text' style='width:100%' value='" + value.PopupCaption + "' id='txtPopupCaption'></input></td>";
                        newRowContent += "<td style='text-align:center'><input type='text' style='width:100%' value='" + value.PopupTop + "' id='txtPopupTop' onkeydown='return onlyNumbers(event);'></input></td>";
                        newRowContent += "<td style='text-align:center'><input type='text' style='width:100%' value='" + value.PopupLeft + "' id='txtPopupLeft' onkeydown='return onlyNumbers(event);'></input></td>";
                        newRowContent += "<td style='text-align:center'><input type='text' style='width:100%' value='" + value.PopupWidth + "' id='txtPopupWidth' onkeydown='return onlyNumbers(event);'></input></td>";
                        newRowContent += "<td style='text-align:center'><input type='text' style='width:100%' value='" + value.PopupHeight + "' id='txtPopupheight' onkeydown='return onlyNumbers(event);'></input></td>";

                        var deleteButton = '';
                        var popupFilePath = ''
                        if (!isEmpty(value.PopupName)) {
                            deleteButton = '&nbsp;&nbsp;<img src="/Admin/Images/icon-delete.jpg"  alt="x" onclick="fnDeleteImage(this); return false" id="" style="cursor:pointer;"/>';
                            popupFilePath = "/SiteManagement/DSAAAAAAAA/Popup/" + value.PopupName;
                        }
                        newRowContent += "<td style='text-align:center'><input type='hidden' id='hdRowPopupPath' value='" + popupFilePath + "'/><span id='spanPopupname'>" + value.PopupName + "</span>" + deleteButton + "</td>";

                        var file = "<input type='file' id='fuPopup" + key + "'/>";
                        var btn = "<input type='button' class='btnDelete' value='저장' onclick=''/>";
                        var addBtn = "<input type='button' class='btnDelete' value='추가' onclick='fnAddTableRow(this); return false;'/>"

                        newRowContent += "<td style='text-align:center'>" + file + "</td>";
                        newRowContent += "<td style='text-align:center'><input type='button' class='btnDelete' value='삭제' onclick='fnDeletePopup(this); return false;'/></td>";
                        newRowContent += "</tr>";

                    });
                    $("#tblPopup").append(newRowContent);
                }
                else {
                    
                    var emptyTag = "<tr>";
                    emptyTag += "<td class='txt-center'><input type='text' style='width:100%' id='txtPopupSeq' value='1' onkeydown='return onlyNumbers(event);'/>";
                    emptyTag += "</td>";
                    emptyTag += "<td class='txt-center'> <select style='height: 26px; ' id='selectPopupUse'><option value='N'>예</option> <option value='Y'>아니오</option> </select>";
                    emptyTag += "</td>";
                    emptyTag += "<td class='txt-center'><input type='text' style='width:100%' id='txtPopupCaption'/ >";
                    emptyTag += "</td>";
                    emptyTag += "<td class='txt-center'><input type='text' style='width:100%' id='txtPopupTop' onkeydown='return onlyNumbers(event);'/ >";
                    emptyTag += "</td>";
                    emptyTag += "<td class='txt-center'><input type='text' style='width:100%' id='txtPopupLeft' onkeydown='return onlyNumbers(event);'/ >";
                    emptyTag += "</td>";
                    emptyTag += "<td class='txt-center'><input type='text' style='width:100%' id='txtPopupWidth' onkeydown='return onlyNumbers(event);'/ >";
                    emptyTag += "</td>";
                    emptyTag += "<td class='txt-center'><input type='text' style='width:100%' id='txtPopupheight' onkeydown='return onlyNumbers(event);'/ >";
                    emptyTag += "</td>";
                    emptyTag += "<td id='tdPopupFileName'>";
                    emptyTag += "</td>";
                    emptyTag += "<td class='txt-center'> <input type='file' id='fuPopup' class='fileC'>";
                    emptyTag += "</td>";
                    emptyTag += "<td class='txt-center'><input type='button' class='btnDelete' value='삭제' onclick='fnDeleteTableRow(this); return false;'/>";
                    emptyTag += "</td>";
                    emptyTag += "</tr>";
                    $("#tblPopup").append(emptyTag);
                }


                return false;
            }
            var param = {

                Code: 'DSAAAAAAAA',
                Method: 'GetDistCssPopup'

            };


            //type, url, async, cache, data, datatype, _callback, _beforeSend, _complete, issessionCheck, sessionValue
            JqueryAjax('Post', '../../Handler/Common/DistCssHandler.ashx', false, false, param, 'json', callback, null, null, true, '<%=Svid_User%>');
        }

        function fnSaveDiscPopup() {
            var jsonPopup = [];
           
            $("#tblPopup tr").each(function () {
                var oldPath = $(this).children().find('#hdRowPopupPath').val();
                var name = $(this).children().find('#spanPopupname').text();
                var mainFile = $(this).children().find('input[id*="fuPopup"]').get(0).files[0];
                var seq = $(this).children().find('#txtPopupSeq').val();
                
                var caption = $(this).children().find('#txtPopupCaption').val();
                var top = $(this).children().find('#txtPopupTop').val();
                var left = $(this).children().find('#txtPopupLeft').val();
                var width = $(this).children().find('#txtPopupWidth').val();
                var height = $(this).children().find('#txtPopupheight').val();
                var delFlag = $(this).children().find('#selectPopupUse').val();

                var mainFileName = '';
                var mainFilePath = '';
                if (mainFile != null) {
                    var mainFileNameExt = $(this).children().find('input[id*="fuPopup"]').val().split('.').pop().toLowerCase();
                    mainFileName = 'popup'+'-'+seq+ '.' + mainFileNameExt;
                    mainFilePath = '/SiteManagement/DSAAAAAAAA/Popup/' + mainFileName;
                }

                if (!isEmpty(caption) || mainFile != null) {

                    jsonPopup.push({
                    Seq: seq,
                    Top: top,
                    Left: left,
                    Width: width,
                    Height: height,
                    Caption: caption,
                    Name: mainFileName,
                    Path: mainFilePath,
                    DelFlag: delFlag,
                    OldPath: oldPath,
                    });

                }
                


            });


            var callback = function (response) {

                if (response == 'OK') {
                    alert('저장되었습니다.');
                    fnGetDistPopup();
                    
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
                    data.append("DCode", 'DSAAAAAAAA');
                    data.append("PopupData", JSON.stringify(jsonPopup));
                    data.append("Method", 'SaveDistPopupAll');
                    $("#tblPopup tr").each(function () {
                        data.append($(this).children().find('#txtPopupSeq').val() + 'File', $(this).children().find('input[id*="fuPopup"]').get(0).files[0]);
                    });
                    return data;
                }(),
            });
        }

        function fnDeletePopup(el) {

            if (!confirm('데이터가 정말 삭제됩니다. 계속 진행하시겠습니까?')) {
                return false;
            }

            var callback = function (response) {

                if (response == 'OK') {

                    fnGetDistPopup();
                    return false;
                }
                else {
                    alert('협력사 삭제중 오류가 생겼습니다. 시스템 관리자에게 문의하세요.');
                    return false;
                }
            }
            var seq = $(el).parent().parent().children().find('#hdRowPopupSeq').val();
            var filePath = $(el).parent().parent().children().find('#hdRowPopupPath').val();
            var param = {

                DCode: 'DSAAAAAAAA',
                Method: 'DeleteDistPopup',
                Seq: seq,
                FilePath: filePath,

            };

            JqueryAjax('Post', '../../Handler/Common/DistCssHandler.ashx', false, false, param, 'text', callback, null, null, true, '<%=Svid_User%>');
            return false;
        }

        function fnDeleteImage(el) {


            if (!confirm('정말 삭제하시겠습니까?')) {
                return false;
            }

            var callback = function (response) {

                if (response == 'OK') {

                    fnGetDistPopup();
                }
                else {
                    alert('시스템 오류입니다 시스템 관리자에게 문의하세요');

                }
                return false;
            }
            var seq = $(el).parent().parent().children().find('#hdRowPopupSeq').val();
            var filePath = $(el).parent().parent().children().find('#hdRowPopupPath').val();

            var param = {


                DCode: 'DSAAAAAAAA',
                Seq: seq,
                DeleteFilePath: filePath,
                Method: 'DeletePopupImg'

            };

            //type, url, async, cache, data, datatype, _callback, _beforeSend, _complete, issessionCheck, sessionValue
            JqueryAjax('Post', '../../Handler/Common/DistCssHandler.ashx', false, false, param, 'text', callback, null, null, true, '<%=Svid_User%>');
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <div class="all">
        <div class="sub-contents-div">
            <!--제목타이틀 영역-->
            <div class="sub-title-div">
                <p class="p-title-mainsentence">
                    공통 팝업 관리
                    <span class="span-title-subsentence"></span>
                </p>
            </div>
            
            

           <!--메인 영역 시작-->
            
            <div id="divMain" class="admin-maincontents">
                <div class="admin-maincontents-subtitle">
                    <span>*팝업 설정 (실제 이미지 사이즈(pixel 기준)보다 넓이는 +30 높이는 +50 으로 설정하면 됩니다.</span>
                </div>
                <table class="tbl_main">
                    <thead>
                        <tr>
                            <th style="width:80px;">순번</th>
                            <th style="width:100px;">사용유무</th>
                            <th style="width:250px;">팝업명</th>
                            <th style="width:80px;">상단</th>
                            <th style="width:80px;">왼쪽</th>
                            <th style="width:80px;">넓이</th>
                            <th style="width:80px;">높이</th>
                            <th style="width:250px;">파일명</th>
                            <th style="width:15px;">파일업로드</th>
                            <th style="width:100px;">
                                <input type='button' class='btnDelete' value='추가' onclick='fnAddTableRow(this); return false;' />
                            </th>
                        </tr>
                    </thead>
                    
                    <tbody id="tblPopup">
                        <tr>
                            <td style="text-align:center;">
                                 <input type="text"  style="width:100%" id="txtPopupSeq" onkeydown="return onlyNumbers(event); " value="1">
                            </td>
                            <td style="text-align:center;">
                                <select style="height:26px;" id="selectPopupUse">
                                    <option value="N">예</option>
                                    <option value="Y">아니오</option>
                                </select>
                            </td>
                        
                            <td style="text-align:center;">
                               <input type="text" style="width:100%" id="txtPopupCaption">
                            </td>
                            <td style="text-align:center;">
                              <input type="text" style="width:100%" id="txtPopupTop" onkeydown="return onlyNumbers(event); ">
                            </td>
                            <td style="text-align:center;">
                              <input type="text" style="width:100%" id="txtPopupLeft" onkeydown="return onlyNumbers(event); ">
                            </td>
                            <td style="text-align:center;">
                              <input type="text" style="width:100%" id="txtPopupWidth" onkeydown="return onlyNumbers(event); ">
                            </td>
                            <td style="text-align:center;">
                              <input type="text" style="width:100%" id="txtPopupheight" onkeydown="return onlyNumbers(event); ">
                            </td>
                            <td style="text-align:center;">
                         
                            </td>
                            <td style="text-align:center;">
                              <input type="file" id="fuPopup" class="fileC">
                            </td>
                            <td style="text-align:center;">
                               <input type='button' class='listBtn' value='삭제' style='width: 55px; height: 22px; font-size: 12px' onclick='fnDeleteTableRow(this); return false;' />
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>
            <!--버튼영역-->
            <div id="divBtn" class="btn-div" style="text-align:right; width:100%;padding-top:25px">
                 <input type="button" class="mainbtn type1" style="width:95px; height:30px; font-size:12px" value="저장" onclick="return fnSaveDiscPopup();"/>
            </div>
        </div>
     </div>

</asp:Content>

