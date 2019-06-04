<%@ Page Title="" Language="C#" MasterPageFile="~/AdminSub/Master/AdminSubMaster.master" AutoEventWireup="true" CodeFile="DocumentManager.aspx.cs" Inherits="AdminSub_Member_DocumentManager" %>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <link href="../../Content/Document/document.css" rel="stylesheet" />
    <script type="text/javascript">
        $(function () {
            fnCommTypeBind();

        });

        function fnCommTypeBind() {
            var callback = function (response) {
                var html = '';
                for (var i = 0; i < response.length; i++) {
                    if (response[i].Map_Type != '0') {
                        html = "<option value='" + response[i].Map_Channel + "_" + response[i].Map_Type + "'>" + response[i].Map_Name + "</option>";

                    }

                    $('#selectMap').append(html);
                }
                return false;
            }
            var param = { Method: 'GetMemberCommList' };

            //jquery Ajax function 호출 (type, url, data, responseDataType, callback)
            Jajax('Post', '../../Handler/Common/CommHandler.ashx', param, 'json', callback);
        }
        var index = 1;
        function fnCreateRow() {
            var callback = function (response) {
                var asynTable = "";
                asynTable += "<tr><th style='padding-left:00px; font-weight:bold;text-align:center; height:24px;'>첨부파일</th>";
                asynTable += "<td><select onchange='fnSetCommType(this.value, this, " + index + ")' style='width:98%; height:24px; padding-left:10px;'>";
                for (var i = 0; i < response.length; i++) {

                    if (response[i].Map_Type != 0) {
                        asynTable += "<option value='" + response[i].Map_Channel + "_" + response[i].Map_Type + "'>" + response[i].Map_Name + "</option>"
                    }

                }
                asynTable += "</select></td><td ><input type='file' id='fuFileAdd" + index + "_1_1' name='fuFileAdd" + index + "_1_1' style='width:100%;'/></td>";
                asynTable += "<td style='text-align:center'><button type='button'  " + index + "' name=btn'" + index + "' value='삭제' onclick ='fnDeleteTableRow(this)'><img src='../../Images/delivery/delete-off.jpg' onmouseover=\"this.src='../../Images/delivery/delete-on.jpg'\" onmouseout=\"this.src='../../Images/delivery/delete-off.jpg'\" alt='삭제하기'/></button ></td></tr>";
                $("#attachTable").children().last().append(asynTable);
                index++;
                return false;
            }
            var param = { Method: 'GetMemberCommList' };

            //jquery Ajax function 호출 (type, url, data, responseDataType, callback)
            Jajax('Post', '../../Handler/Common/CommHandler.ashx', param, 'json', callback);
        }

        //동적으로 추가된 파일업로드 ID세팅(서버 업로드 작업을 위해....)
        function fnSetCommType(value, select, paramIndex) {

            var id = $(select).parent().next('td').find('input').attr('id');
            $('#' + id).attr('name', 'fuFileAdd' + paramIndex + '_' + value);
            $('#' + id).attr('id', 'fuFileAdd' + paramIndex + '_' + value);
            return false;
        }

        function fnDeleteTableRow(obj) {
            var tr = $(obj).parent().parent();
            tr.remove();
            index--;
            return false;
        }

        function fnAttachConfirm() {
            var uploads = $('input[id^="fuFile"]');
            var path = uploads.val();
            var ext = path.substring(path.lastIndexOf(".") + 1, path.length).toLowerCase();
            var validFilesTypes = '<%= ConfigurationManager.AppSettings["AllowExtention"]%>';
            var maxFileSize = '<%= ConfigurationManager.AppSettings["UploadFileMaxSize"]%>';
            var isValidFile = false;
            for (var i = 0; i < validFilesTypes.split(',').length; i++) {
                if (ext == validFilesTypes.split(',')[i]) {
                    isValidFile = true;
                    break;
                }
            }
            if (uploads[0].files[0] != null) {
                if (uploads[0].files[0].size > maxFileSize) {

                    alert('파일 용량은 10MB보다 작아야 합니다.');
                    return false;
                }
            }
           

            if (!isValidFile && path != '') {
                alert('제한된 첨부파일 확장자입니다.');
                return false;
            }
            return true;
        }
    </script>

    <style type="text/css">
        .deletebtn {
            margin-top: 5px;
        }
    </style>

    <div class="all">
        <div class="sub-contents-div">
            <!--제목 타이틀-->
            <div class="sub-title-div">
                <p class="p-title-mainsentence">
                    등록서류관리
                    <span class="span-title-subsentence">등록서류를 확인 할 수 있습니다.</span>
                </p>
            </div>
            <div style="height:30px;"></div>
            <div>
                <table class="board-table" id="attachTable" style="">
                    <colgroup>
                        <col style="width: 15%" />
                        <col style="width: 20%" />
                        <col style="width: 50%" />
                        <col style="width: 5%;" />
                    </colgroup>




                    <tr>
                        <th style="width: 104px; padding-left: 00px; line-height: 30px; text-align: center; height: 24px; font-weight: bold;">첨부파일<br/><span style="color:red; font-size:smaller">(파일용량은 10MB까지 허용됩니다)</span>
                        </th>
                        <td style="width: 200px">

                            <select id="selectMap" style='width: 98%; height: 24px; padding-left: 10px;' onchange='fnSetCommType(this.value, this, 0)'></select>
                        </td>
                        <td style="width: 700px;" colspan="2">
                            <input type='file' id='fuFileAdd0_1_1' name='fuFileAdd0_1_1' style='width: 100%; height: 24px;' />
                        </td>
                        <%-- <td class="text-center" style="width:73px; height:24px;">
                                  <asp:ImageButton runat="server" ID="ImageButton5" src="../Images/Member/add.jpg" onmouseover="this.src='../../Images/delivery/add-off.jpg'" onmouseout="this.src='../../Images/delivery/add-on.jpg'" Height="22px" width="71px" alt="추가" OnClientClick="fnCreateRow(); return false;"/>
                            </td>--%>
                    </tr>
                    <asp:ListView runat="server" ID="lvDocList" OnItemCommand="lvDocList_ItemCommand" OnItemDeleting="lvDocList_ItemDeleting">
                        <ItemTemplate>

                            <tr class="board-tr-height" style="height: 30px;">
                                <td style="text-align: center; height: 24px;">
                                    <asp:ImageButton runat="server" ID="ImageButton1" src="../../images/delete_btn.jpg" alt="삭제" CommandName="delete" CssClass="deletebtn" CommandArgument='<%# Eval("Svid_Doc").ToString()%>' />
                                    <asp:HiddenField runat="server" ID="hfPath" Value='<%# Eval("AttachFile.Attach_Path").ToString()%>' />
                                </td>
                                <td style="padding-left: 5px; color: #69686d; font-weight: bold">
                                    <%# Eval("Map_Name").ToString()%>
                                </td>
                                <td colspan="2">
                                    <asp:LinkButton runat="server" ID="lbAttachFileName" Text='<%# Eval("AttachFile.Attach_P_Name").ToString()%>' CommandName="download" CommandArgument='<%# Eval("AttachFile.Attach_Path").ToString()%>'></asp:LinkButton>
                                </td>
                            </tr>
                        </ItemTemplate>
                    </asp:ListView>

                </table>
            </div>
            <div class="btn1">
                <asp:Button id="btnConfirm" runat="server" Text="확인" CssClass="mainbtn type1" Width="95" Height="30" OnClick="btnConfirm_Click" OnClientClick="return fnAttachConfirm();"/>
            </div>
        </div>
    </div>
</asp:Content>

