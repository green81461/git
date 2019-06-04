<%@ Page Title="" Language="C#" MasterPageFile="~/Master/Default.master" AutoEventWireup="true" CodeFile="BoardInsertByMember.aspx.cs" Inherits="Board_BoardInsertByMember" %>



<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <script type="text/javascript" src="../SmartEditor/js/service/HuskyEZCreator.js"></script>
    <script type="text/javascript">
        var editor_object = [];
        $(function () {
            //전역변수선언

            nhn.husky.EZCreator.createInIFrame({
                oAppRef: editor_object,
                elPlaceHolder: "txtContent",
                sSkinURI: "../Smarteditor/SmartEditor2Skin.html",
                htParams: { fOnBeforeUnload: function () { } }

            });
        })

         function fnValidation() {
             var txtTitle = $("#<%=txtTitle.ClientID%>");
             var hfContent = $("#<%=hfContent.ClientID%>");
           <%--  var txtContent = $("#<%=txtContent.ClientID%>").val();--%>

             hfContent.val(encodeURIComponent(editor_object.getById["txtContent"].getIR())); //히든필드에 에디터 값 저장


             if (txtTitle.val() == '') {
                 alert('제목을 입력해주세요');
                 txtTitle.focus();
                 return false;
             }
             if (editor_object.getById["txtContent"].getIR() == '' || editor_object.getById["txtContent"].getIR() == null || editor_object.getById["txtContent"].getIR() == '&nbsp;' || editor_object.getById["txtContent"].getIR() == '<p><br></p>') {
                 alert('내용을 입력해주세요');
                 editor_object.getById["txtContent"].exec("FOCUS"); //포커싱
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

             return true;

         }
         function fnInsertCancel() {
             if (confirm('취소하시겠습니까?')) {
                 location.href = 'BoardList.aspx';
                 return false;
             }
         }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <!--1:1 회원 문의 작성 전체 영역 시작-->
    <div class="sub-contents-div">
        <div class="sub-title-div">
	        <img src="/images/BoardInsertByMember_nam.png" />
         </div>
        <div>
            <table class="tbl_main">
                <tr>
                    <th class="border-right">
                        <asp:Label runat="server" ID="lblDivWrite" Text="담당자" ></asp:Label>
                    </th>
                    <td class="border-right">
                        <asp:Label runat="server" ID="lblWrite" CssClass="padding-left-ten"></asp:Label>
                    </td>
                    <th class="border-right">
                        <asp:Label runat="server" ID="lblDivPhone" Text="회신 휴대전화번호" ></asp:Label>
                    </th>
                    <td>
                        <asp:Label runat="server" ID="lblPhone" CssClass="padding-left-ten"></asp:Label>
                    </td>
                </tr>
                <tr style="border:1px solid #a2a2a2">
                    <th class="border-right">
                         <asp:Label runat="server" ID="lblDivMail" Text="회신 메일주소" ></asp:Label>
                    
                    </th>
                    <td class="border-right" style="width:400px">
                        <asp:Label runat="server" ID="lblMail" CssClass="padding-left-ten"></asp:Label>
                    </td>
                    <th class="border-right">
                         <asp:Label runat="server" ID="lblDivGubun" Text="문의 구분"></asp:Label>
                    
                    </th>
                    <td class="padding-left-ten">
                        <asp:DropDownList ID="ddlComm" runat="server" CssClass="board-selectbox" Width="300px">

                        </asp:DropDownList>
                    </td>
                </tr>
                 <tr>
                    <th class="border-right">
                         <asp:Label runat="server" ID="lblTitle" Text="제목" ></asp:Label>
                    </th>
                    <td colspan="3">
                        <asp:TextBox runat="server" ID="txtTitle" CssClass="padding-left-ten txt-title-input"  style="height:25px; width:99%"></asp:TextBox>
                    </td>
                </tr>
                <tr>
                     <th class="border-right">
                         <asp:Label runat="server" ID="lblContent" Text="내용" ></asp:Label>
                    </th>
                    <td colspan="3">
                            <textarea  id="txtContent" name="txtContent" class="txt-contents-input"></textarea>
                            <asp:HiddenField ID="hfContent" runat="server" />
                            <%--<asp:TextBox ID="txtContent" runat="server" TextMode="MultiLine" Rows="10" Height="150px" Width="95%"></asp:TextBox>--%>
                    </td>
                </tr>
                <tr>
                    <th class="border-right">
                        <asp:Label ID="lblFileUp" runat="server" Text="첨부파일"></asp:Label>
                    </th>
                    <td colspan="3">
                          <asp:FileUpload ID="fuUploadFile" runat="server" CssClass="file-up-div" Width="1000px" Height="25px"/>
                    </td>
                </tr>
            </table>
            <asp:HiddenField runat="server" ID="hfSvidUser" />
            <asp:HiddenField runat="server" ID="hfCompanyName" />
            <asp:HiddenField runat="server" ID="hfTelNum" />
            <asp:HiddenField runat="server" ID="hfPhoneNum" />
            <asp:HiddenField runat="server" ID="hfEmail" />
            <asp:HiddenField runat="server" ID="hfIp" />
            <asp:HiddenField runat="server" ID="hfpwd" />

        </div>
        <div class="btn-bottom-div">
                <asp:Button ID="btnCancel" runat="server"  OnClientClick="return fnInsertCancel();" Text="목록" CssClass="mainbtn type1" Width="95" Height="30"/>
                <asp:Button ID="btnSave" runat="server" OnClick="btnSave_Click" OnClientClick="return fnValidation();" Text="작성완료" CssClass="mainbtn type1" Width="95" Height="30"/>
        </div>
        <div class="left-menu-wrap" id="divLeftMenu">
	        <dl>
		        <dt>
			        <strong>고객센터</strong>
		        </dt>
		        <dd>
		           <a href="/Notice/NoticeList.aspx">공지사항</a> 
		        </dd>
		        <dd class="active">
		           <a href="/Board/BoardList.aspx">질문게시판</a> 
		        </dd>
		        <dd>
		           <a href="/Other/Faq.aspx">FAQ</a> 
		        </dd>
		        <%--<dd>
		           <a>담당자 전화번호</a> 
		        </dd>--%>
		    </dl>
        </div>
    </div>
    <!--1:1 회원 문의 작성 전체 영역 끝-->
</asp:Content>

