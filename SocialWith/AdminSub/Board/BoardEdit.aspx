<%@ Page Title="" Language="C#" MasterPageFile="~/AdminSub/Master/AdminSubMaster.master" AutoEventWireup="true" CodeFile="BoardEdit.aspx.cs" Inherits="AdminSub_Board_BoardEdit"  validateRequest="false"%>



<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <link rel="stylesheet" type="text/css" href="/AdminSub/Contents/board.css" />
     <script type="text/javascript" src="../../SmartEditor/js/service/HuskyEZCreator.js"></script>
    <script type="text/javascript">
        var editor_object = [];

        var qs = fnGetQueryStrings();
        var ucode = qs["ucode"];
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
                var svid = '<%= Svid %>';
                location.href = 'BoardView.aspx?Svid=' + svid + '&ucode='+ucode;
               
            }
             return false;
        }
    </script>
    <style>
        .sub-contents-div {
            margin-left: 0;
            margin-right: 0;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <!--1:1문의 게시판 시작-->
    <div class="sub-contents-div">

        <!--제목 타이틀-->
            <div class="sub-title-div">
                <p class="p-title-mainsentence">
                    1:1 회원문의
                    <span class="span-title-subsentence">편리한 쇼핑을 위한 최근 소식이나 유익한 정보를 고객님께 안내해 드리고 있습니다.</span>
                </p>
            </div>
        <!--사용자가 작성한 문의 영역 시작-->
        <div class="board-view-div">
            <table class="board-table board-dtl-table">

                 <tr>
                    <th><asp:Label runat="server" ID="lblCompanyNmHeader" Text="회사/기관명"></asp:Label></th>
                    <td class="padding-left-ten"><asp:Label runat="server" ID="lblCompanyNm" ></asp:Label></td>
                    <th><asp:Label runat="server" ID="lblWriter" Text="작성자"></asp:Label></th>
                    <td class="padding-left-ten"><asp:Label runat="server" ID="lblWrite"></asp:Label></td>
                </tr>
                <tr>
                    <th><asp:Label runat="server" ID="lblTelHeader" Text="전화번호"></asp:Label></th>
                    <td class="padding-left-ten"><asp:Label runat="server" ID="lblTel"></asp:Label></td>
                    <th><asp:Label runat="server" ID="lblPhoneNoHeader" Text="휴대전화번호"></asp:Label></th>
                    <td class="padding-left-ten"><asp:Label runat="server" ID="lblPhoneNo"></asp:Label></td>
                </tr>
                <tr>
                    <th><asp:Label runat="server" ID="lblEmailHeader" Text="이메일"></asp:Label></th>
                    <td class="padding-left-ten"><asp:Label runat="server" ID="lblEmail"></asp:Label></td>
                    <!--<td><asp:Label runat="server" ID="lblPwdHeader" Text="게시글 비밀번호"></asp:Label></td>
                    <td><asp:Label runat="server" ID="lblPwd"></asp:Label></td>-->
                    <th><asp:Label runat="server" ID="lblQueryGubunHeader" Text="문의구분"></asp:Label></th>
                    <td class="padding-left-ten"> <asp:DropDownList ID="ddlComm" runat="server" CssClass="board-selectbox" Width="300px">

                        </asp:DropDownList></td>
                </tr>
                
                <tr>
                    <th>
                        <asp:Label runat="server" ID="lblRegDateHeader" Text="작성일"></asp:Label>&nbsp;</th>
                    <td style="padding-left: 10px;" colspan="3">
                        <asp:Label runat="server" ID="lblRegDate"></asp:Label>

                    </td>
                </tr>
                <tr>
                    <th>
                        <asp:Label runat="server" ID="lblTitleHeader" Text="제목"></asp:Label>&nbsp;&nbsp;&nbsp;</th>
                    <td colspan="3" style="border: none;">
                        <asp:TextBox runat="server" ID="txtTitle" Width="100%" Height="25px"></asp:TextBox>
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
            <div class="board-btn-div" style="text-align:right; padding-top:10px">
                <asp:Button runat="server"  CssClass="mainbtn type1" Width="95" Height="30" ID="Button1" OnClientClick="return fnUpdateCancel();"  Text="취소"/>
                <asp:Button runat="server" CssClass="mainbtn type1" Width="95" Height="30" ID="btnSave" OnClientClick="return fnValidation();" Text="작성완료" OnClick="btnEdit_Click"/>
            </div>

        </div>
        <!--1:1문의 게시판 끝-->
    </div>
</asp:Content>

