<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Master/AdminMasterPage.master" AutoEventWireup="true" CodeFile="NoticeEdit.aspx.cs" Inherits="Admin_Notice_NoticeEdit" ValidateRequest="false" %>


<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <style>
        Table {
            border-collapse: collapse;
        }
    </style>
    <script type="text/javascript" src="../../SmartEditor/js/service/HuskyEZCreator.js"></script>
    <script type="text/javascript">

        var editor_object = [];


        $(function () {
            //전역변수선언
            var hfContent = $("#<%=hfContent.ClientID%>");

            nhn.husky.EZCreator.createInIFrame({
                oAppRef: editor_object,
                elPlaceHolder: "txtContent",
                sSkinURI: "../../Smarteditor/SmartEditor2Skin.html",
                htParams: { fOnBeforeUnload: function () { } },
                fOnAppLoad: function () {
                    editor_object.getById["txtContent"].setIR(hfContent.val());
                },
            });

        });


        function fnFileDeleteConfirm() {
            if (confirm('식제하시겠습니까?')) {
                return true;
            }
            return false;
        }


        function fnValidation() {

            var txtTitle = $("#<%=txtTitle.ClientID%>");
        var hfContent = $("#<%=hfContent.ClientID%>");

        hfContent.val(encodeURIComponent(editor_object.getById["txtContent"].getIR())); //히든필드에 에디터 값 저장

        <%--  var txtContent = $("#<%=txtContent.ClientID%>").val();--%>

        if (txtTitle.val() == '') {
            alert('제목을 입력해주세요');
            txtTitle.focus();
            return false;
        }

        if (hfContent.val() == '') {
            alert('내용을 입력해주세요');
            return false;
        }

        var maxFileSize = '<%= ConfigurationManager.AppSettings["UploadFileMaxSize"]%>';
        var fileuploader = $("#<%=fuUploadFile.ClientID%>");

            if (fileuploader[0] != null && fileuploader[0].files[0] != null) {
                if (fileuploader[0].files[0].size > maxFileSize) {

                    alert('파일 용량은 10MB보다 작아야 합니다.');
                    return false;
                }
            }

            if (!confirm("저장하시겠습니까?")) {
                return false;
            }
            return true;
        }

        function fnUpdateCancel() {
            if (confirm('취소하시겠습니까?')) {
                var svid = '<%= Svid%>';
                location.href = 'NoticeView.aspx?Svid=' + svid + '&ucode=' + ucode;
                return false;
            }
        }

    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">

    <div class="sub-contents-div">
        <div class="sub-title-div">
            <p class="p-title-mainsentence">
                공지사항
                    <span class="span-title-subsentence">편리한 쇼핑을 위한 최근 소식이나 유익한 정보를 고객님께 안내해 드리고 있습니다.</span>
            </p>
        </div>

        <div class="board-view-div">
            <table class="tbl_main">


                <tr class="board-tr-height">
                    <th>
                        <asp:Label runat="server" ID="lblTitleHeader" Text="제목"></asp:Label>&nbsp;&nbsp;&nbsp;</th>
                    <td colspan="3">
                        <asp:TextBox runat="server" ID="txtTitle" Width="500px" Height="35px" Style="border: none"></asp:TextBox>
                    </td>
                </tr>
                <tr class="board-tr-height">
                    <th>
                        <asp:Label runat="server" ID="lblWriteHeader" Text="작성자  "></asp:Label>&nbsp;</th>
                    <td style="padding-left: 10px;">
                        <asp:Label runat="server" ID="lblWriter"></asp:Label></td>
                    &nbsp;&nbsp;&nbsp;<th>
                        <asp:Label runat="server" ID="lblRegDateHeader" Text="작성일 : "></asp:Label>&nbsp;</th>
                    <td style="padding-left: 10px;">
                        <asp:Label runat="server" ID="lblRegDate"></asp:Label>

                    </td>
                </tr>

                <tr>
                    <td colspan="4" style="text-align: center; padding-left: 2px;">
                        <textarea id="txtContent" name="txtContent" style="width: 100%; height: 500px"></textarea>
                        <asp:HiddenField ID="hfContent" runat="server" />
                        <%--<asp:TextBox ID="txtContent" runat="server" TextMode="MultiLine" Rows="10" Height="150px" Width="95%"></asp:TextBox>--%>
                    </td>
                </tr>
                <tr class="board-tr-height">
                    <th>
                        <asp:Label runat="server" ID="lblFileHeader" Text="첨부파일"></asp:Label></th>
                    <td colspan="3">
                        <asp:FileUpload ID="fuUploadFile" runat="server" CssClass="file-up-div" />
                        <asp:HiddenField ID="hfFileName" runat="server" />
                        <asp:HiddenField ID="hfBoardNo" runat="server" />
                        <asp:LinkButton ID="lbFileDown" runat="server" Visible="false" OnClick="lbFileDown_Click"></asp:LinkButton>
                        <asp:ImageButton ID="btnFileDelete" runat="server" src="../../Images/delivery/delete-on.jpg" onmouseover="this.src='../../Images/delivery/delete-off.jpg'" onmouseout="this.src='../../Images/delivery/delete-on.jpg'" Visible="false" AlternateText="삭제" OnClick="btnFileDelete_Click" OnClientClick="return fnFileDeleteConfirm();" />

                    </td>
                </tr>

            </table>
            <div class="board-btn-div" style="padding-top: 15px; text-align: right">

                <asp:Button ID="btnSave" runat="server" Width="95" Height="30" Text="저장" OnClientClick="return fnValidation();" OnClick="btnSave_Click" CssClass="mainbtn type1" />
                <input type="button" class="mainbtn type1" style="width: 95px; height: 30px;" value="취소" onclick="return fnUpdateCancel();" />


            </div>
        </div>



    </div>

</asp:Content>

