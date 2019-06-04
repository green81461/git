<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Master/AdminMasterPage.master" AutoEventWireup="true" CodeFile="SystemRegister.aspx.cs" Inherits="Admin_Board_SystemRegister" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <link href="../Content/SysList/system.css" rel="stylesheet" />
    <link href="../Content/goods/goods.css" rel="stylesheet" />
    <script type="text/javascript">       
       function fnValidation() {
           var txtTitle = $("#<%=txtTitle.ClientID%>");
           var txtProblemContent = $("#<%=txtProblemContent.ClientID%>");
           var txtReqContent = $("#<%=txtReqContent.ClientID%>");

           if (txtTitle.val() == '') {
               alert('제목을 입력해주세요');
               txtTitle.focus();
               return false;
           }
           if (txtProblemContent.val() == '') {
               alert('애로사항을 입력해주세요');
               txtProblemContent.focus();
               return false;
           }
           if (txtReqContent.val() == '') {
               alert('요청사항을 입력해주세요');
               txtReqContent.focus();
               return false;
           }
           if (!confirm("저장하시겠습니까?")) {
               return false;
           }
           return true;
        }

        function fnTabClickRedirect(pageName) {
            location.href = pageName + '.aspx?ucode=' + ucode;
            return false;
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div class="all">
        <div class="sub-contents-div">
            <!--제목영역-->
            <div class="sub-title-div">
                <p class="p-title-mainsentence">
                    시스템 개선사항
                    <span class="span-title-subsentence"></span>
                </p>
            </div>

            <!--탭영역-->
            <div class="div-main-tab" style="width: 100%; ">
                <ul>
                    <li class='tabOff' style="width: 185px;" onclick="fnTabClickRedirect('SystemListMain');">
                        <a onclick="fnTabClickRedirect('SystemListMain');">요청리스트</a>
                     </li>
                    <li class='tabOn' style="width: 185px;" onclick="fnTabClickRedirect('SystemRegister');">
                         <a onclick="fnTabClickRedirect('SystemRegister');">개선사항등록</a>
                    </li>
                </ul>
            </div>

            <!--테이블영역-->
            <table id="tblSys" class="tbl_main">
                <thead>
                    <tr>
                        <th colspan="4">요청내용</th>
                    </tr>
                </thead>
                <tr>
                    <th>등록일</th>
                    <td>
                        <asp:TextBox runat="server" CssClass="popLabel" ReadOnly="true" ID="txtDate" style="padding-left:5px"></asp:TextBox></td>
                    <th>요청자</th>
                    <td>
                        <asp:TextBox runat="server" CssClass="popLabel" ReadOnly="true" ID="txtUser" style="padding-left:5px"></asp:TextBox></td>
                </tr>
                <tr>
                    <th>대상</th>
                    <td>
                        <asp:DropDownList runat="server" Width="99.5%" CssClass="popDrop" ID="ddlComm" OnSelectedIndexChanged="ddlComm_Changed" AutoPostBack="true">             
                        </asp:DropDownList></td>

                    <th>화면</th>
                    <td>
                        <asp:DropDownList runat="server" Width="99.5%" CssClass="popDrop" ID="ddlView" AutoPostBack="true">                  
                        </asp:DropDownList></td>
                </tr>
                <tr>
                    <th>제목</th>
                    <td colspan="3">
                        <asp:TextBox runat="server"  Width="100%" ID="txtTitle"></asp:TextBox></td>
                </tr>
                <tr>
                    <th>애로사항</th>
                    <td colspan="3" style="height: 100px">
                        <asp:TextBox runat="server" TextMode="MultiLine" CssClass="popTxt-wide" Rows="10" placeholder="내용입력" ID="txtProblemContent"></asp:TextBox></td>
                </tr>

                <tr>
                    <th>요청사항</th>
                    <td colspan="3" style="height: 100px">
                        <asp:TextBox runat="server" TextMode="MultiLine" CssClass="popTxt-wide" Rows="10" placeholder="내용입력" ID="txtReqContent"></asp:TextBox></td>
                </tr>
                <tr>
                    <th>파일첨부</th>
                    <td colspan="3">
                        <asp:FileUpload ID="FileUpload1" runat="server" /></td>
                </tr>
                <tr>
                    <th>파일첨부</th>
                    <td colspan="3">
                        <asp:FileUpload ID="FileUpload2" runat="server" /></td>
                </tr>
                <tr>
                    <th>파일첨부</th>
                    <td colspan="3">
                        <asp:FileUpload ID="FileUpload3" runat="server" /></td>
                </tr>
            </table>


            <div class="btn_center">
                <asp:Button ID="btnSave" runat="server" Width="95" Height="30" Text="등록" OnClick="btnSave_Click" CssClass="mainbtn type1"/>
            </div>

        </div>
    </div>
</asp:Content>

