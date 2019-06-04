<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Master/AdminMasterPage.master" AutoEventWireup="true" CodeFile="NoticeInsert.aspx.cs" Inherits="Admin_Notice_NoticeInsert" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
     <script type="text/javascript" src="../../SmartEditor/js/service/HuskyEZCreator.js"></script>
     <script type="text/javascript">
         var editor_object = [];
         $(function () {
             //전역변수선언

             nhn.husky.EZCreator.createInIFrame({
                 oAppRef: editor_object,
                 elPlaceHolder: "txtContent",
                 sSkinURI: "../../Smarteditor/SmartEditor2Skin.html",
                 htParams: { fOnBeforeUnload: function () { } }

             });
         })

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

             if (fileuploader[0].files[0] != null) {
                 if (fileuploader[0].files[0].size > maxFileSize) {

                     alert('파일 용량은 10MB보다 작아야 합니다.');
                     return false;
                 }
             }

             if (!confirm("저장하시겠습니까?")) {
                 return false;
             }

             
             //if (txtContent == '') {
             //    alert('내용을 입력해주세요');
             //    return false;
             //}
             return true;

         }
         function fnInsertCancel() {
             if (confirm('취소하시겠습니까?')) {
                 location.href = 'NoticeList.aspx?ucode='+ucode;
                 return false;
             }
         }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">

    <!--공지사항 등록 전체 영역 시작-->
    <div class="sub-contents-div">
        <div class="sub-title-div">
                <p class="p-title-mainsentence">
                    공지사항
                    <span class="span-title-subsentence">편리한 쇼핑을 위한 최근 소식이나 유익한 정보를 고객님께 안내해 드리고 있습니다.</span>
                </p>
            </div>

        <div>
            <table class="tbl_main">
                <colgroup>
                    <col style="width:15%"/>
                    <col style="width:85%"/>
                </colgroup>
                <tr>
                    <th>
                         <asp:Label runat="server" ID="lblTitle" Text="제목" ></asp:Label>
                    </th>
                    <td  <%--class="padding-left-ten"--%>>
                        <asp:TextBox runat="server" ID="txtTitle" CssClass="txt-title-input" Width="100%"></asp:TextBox>
                    </td>
                </tr>
                <tr>
                  
                        <%-- <asp:Label runat="server" ID="lblContent" Text="내용" ></asp:Label>--%>
                    
                    <td class="contents-td"colspan="2">
                        <textarea  id="txtContent"  name="txtContent" class="txt-contents-input" style="width:100%"></textarea>
                            <asp:HiddenField ID="hfContent" runat="server" />
                            <%--<asp:TextBox ID="txtContent" runat="server" TextMode="MultiLine" Rows="10" Height="150px" Width="95%"></asp:TextBox>--%>
                    </td>
                </tr>
                <tr>
                    <th>
                        <asp:Label ID="lblFileUp" runat="server" Text="첨부파일"></asp:Label>
                    </th>
                    <td>
                          <asp:FileUpload ID="fuUploadFile" runat="server" CssClass="file-up-div" />
                    </td>
                </tr>
            </table>
        </div>
        <div style ="padding-top:15px; text-align:right">
            <input type="button" class="mainbtn type1" style="width: 95px; height: 30px;" value="목록" onclick="return fnInsertCancel();" />
            <asp:Button ID="btnSave" runat="server" Width="95" Height="30" Text="저장" OnClientClick="return fnValidation();" OnClick="btnSave_Click" CssClass="mainbtn type1"/>
          
        </div>
          
    
    </div>
       
    <!--공지사항 등록 전체 영역 끝-->
</asp:Content>

    