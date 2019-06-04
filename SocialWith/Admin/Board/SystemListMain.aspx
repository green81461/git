<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Master/AdminMasterPage.master" AutoEventWireup="true" CodeFile="SystemListMain.aspx.cs" Inherits="Admin_Board_SystemListMain" %>

<%@ Register Src="~/UserControl/ucListControl.ascx" TagName="ListPager" TagPrefix="ucPager" %>
<%@ Import Namespace="Urian.Core" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <link href="../Content/SysList/system.css" rel="stylesheet" />

    <script>
        var is_sending = false;
        //시스템개선사항요청 팝업창 열기
        function fnPopupOpen(el) {

            fnSystemInfoBind(el);
            //var e = document.getElementById('systemDiv');

            //if (e.style.display == 'block') {
            //    e.style.display = 'none';

            //} else {
            //    e.style.display = 'block';
            //}

            fnOpenDivLayerPopup('systemDiv');

        }



        function fnValidate() {
            if (!confirm('저장하시겠습니까?')) {
                return false;
            }
            return true;
        }
        function fnEnter() {

            if (event.keyCode == 13) {
                <%=Page.GetPostBackEventReference(btnSearch)%>
                return false;
            }
            else
                return true;
        }

        //개선요청 정보 바인드
        function fnSystemInfoBind(el) {


            $('#<%= txtEntryDate.ClientID%>').val('');
            $('#<%= txtSvidUser.ClientID%>').val('');
            $('#<%= txtType.ClientID%>').val('');
            $('#<%= txtDisplay.ClientID%>').val('');
            $('#<%= txtProblem.ClientID%>').val('');
            $('#<%= txtRequest.ClientID%>').val('');
            $('#<%= txtProcessResult.ClientID%>').val('');
            $('#<%= hfUnumUpdateNo.ClientID%>').val('');
            $('#<%= ddlProcessResult.ClientID%>').val('N');

            var callback = function (response) {

                if (!isEmpty(response)) {
                    var processYN = '';

                    if (response.ProcessYN == 'Z') {
                        processYN = 'N'
                    }
                    else {
                        processYN = response.ProcessYN
                    }
                    $('#<%= txtEntryDate.ClientID%>').val(response.EntryDate);
                    $('#<%= txtSvidUser.ClientID%>').val(response.RequestName);
                    $('#<%= txtType.ClientID%>').val(response.SystemUpdate_Type_Name);
                    $('#<%= txtDisplay.ClientID%>').val(response.DisplayDesc_Name);
                    $('#<%= txtProblem.ClientID%>').val(response.Problem);
                    $('#<%= txtRequest.ClientID%>').val(response.Request);
                    $('#<%= txtProcessResult.ClientID%>').val(response.ProcessResult);
                    $('#<%= ddlProcessResult.ClientID%>').val(processYN);
                }

                return false;
            }

            var sysNo = $(el).parent().parent().find('#hdUnumUpdateNo').val();
            fnAttachFileBind(sysNo);
            $('#<%= hfUnumUpdateNo.ClientID%>').val(sysNo);
            var param = {
                Method: 'GetSystemUpdateInfo',
                SysUpNo: sysNo
            };

            var beforeSend = function () {
                is_sending = true;
            }
            var complete = function () {
                is_sending = false;
            }

            if (is_sending) return false;

            JqueryAjax('Post', '../../Handler/Admin/SystemUpdateHandler.ashx', true, false, param, 'json', callback, beforeSend, complete, true, '<%=Svid_User%>');
        }

        function fnAttachFileBind(sysNo) {

            var callback = function (response) {
                var newRowContent = '';

                $('#tblPopupDocument tbody').empty(); //테이블 클리어
                if (!isEmpty(response)) {
                    for (var i = 0; i < response.length; i++) {

                        newRowContent += "<tr>";
                        newRowContent += "<td style='border: none'>";
                        newRowContent += "<input type= 'hidden' id='hdFileName' value= '" + response[i].Attach_P_Name + "' />";
                        newRowContent += "<input type= 'hidden' id='hdFilePath' value= '" + response[i].Attach_Path + "' />";
                        newRowContent += "<a onclick='fnFileDownload(this); return false;' style='cursor: pointer; text-decoration:none; color:black; font-weight:bold;'>" + response[i].Attach_P_Name + "</a>";
                        newRowContent += "</td>";
                        newRowContent += "</tr>";
                    }
                    $('#tblPopupDocument tbody').append(newRowContent);
                }
                return false;
            }

            var param = {
                Method: 'GetSystemUpdateAttachFiles',
                SysUpNo: sysNo
            };

            JqueryAjax('Post', '../../Handler/Admin/SystemUpdateHandler.ashx', true, false, param, 'json', callback, null, null, true, '<%=Svid_User%>');
        }

        function fnFileDownload(el) {

            var hdFilePath = $(el).parent().parent().find("input:hidden[id=hdFilePath]").val();
            var hdFileName = $(el).parent().parent().find("input:hidden[id=hdFileName]").val();
            window.location = '../../Order/FileDownload.aspx?FilePath=' + hdFilePath + '&FileName=' + hdFileName;
            return false;
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

            <div class="div-main-tab" style="width: 100%;">
                <ul>
                    <li class='tabOn' style="width: 185px;" onclick="fnTabClickRedirect('SystemListMain');">
                        <a onclick="fnTabClickRedirect('SystemListMain');">요청리스트</a>
                    </li>
                    <li class='tabOff' style="width: 185px;" onclick="fnTabClickRedirect('SystemRegister');">
                        <a onclick="fnTabClickRedirect('SystemRegister');">개선사항등록</a>
                    </li>
                </ul>
            </div>

            <!--검색영역-->
            <div class="bottom-search-div" style="margin-bottom: 50px">
                <table class="tbl_search" style="margin-top: 30px; margin-bottom: 30px;">
                    <colgroup>
                        <col style="width: 90px;" />
                        <col />
                        <col />
                    </colgroup>
                    <tr>
                        <td></td>
                        <td>
                            <asp:DropDownList ID="ddlSearchTarget" runat="server" Style="width: 200px;">
                                <asp:ListItem Text="제목" Value="Title"></asp:ListItem>
                                <asp:ListItem Text="애로사항" Value="Problem"></asp:ListItem>
                                <asp:ListItem Text="요청사항" Value="Request"></asp:ListItem>
                            </asp:DropDownList>
                            <asp:TextBox runat="server" placeholder="검색어를 입력하세요." Style="padding-left: 10px; width: 500px" ID="txtSearch" Onkeypress="return fnEnter();"></asp:TextBox>
                            <asp:Button runat="server" CssClass="mainbtn type1" ID="btnSearch" OnClick="btnSearch_Click" Text="검색" Width="75" Height="25" />
                        </td>

                    </tr>
                </table>
            </div>


            <!--테이블 영역-->
            <!--데이터 리스트 시작 -->
            <asp:ListView ID="lvSystemList" runat="server" ItemPlaceholderID="phItemList">
                <LayoutTemplate>
                    <table id="tblSysList" class="tbl_main">
                        <thead>
                            <tr>
                                <th style="width: 50px">번호</th>
                                <th style="width: 80px">등록일</th>
                                <th style="width: 80px">대상</th>
                                <th style="width: 80px">화면</th>
                                <th style="width: 200px">제목</th>
                                <th style="width: 90px">요청자</th>
                                <th style="width: 70px">처리결과</th>
                                <th style="width: 70px">처리대상자</th>
                                <th style="width: 80px;">처리일</th>
                                <th style="width: 90px;">상세확인</th>
                            </tr>
                        </thead>
                        <tbody>
                            <asp:PlaceHolder ID="phItemList" runat="server" />
                        </tbody>
                    </table>
                </LayoutTemplate>
                <ItemTemplate>
                    <tr>
                        <td class="txt-center">
                            <%# Eval("Rownum").AsText()%>
                        </td>
                        <td class="txt-center">
                            <%# Eval("EntryDate").AsDateTime().ToString("yyyy-MM-dd")%>
                        </td>
                        <td class="txt-center">
                            <%# GetComm("BOARD",2,Eval("SystemUpdate_Type").AsInt()) %>
                        </td>
                        <td class="txt-center">
                            <%# GetComm("BOARD",3,Eval("DisplayDesc").AsInt()) %>
                        </td>
                        <td class="txt-center">
                            <%# Eval("Title").AsText()%>
                        </td>
                        <td class="txt-center">
                            <%# GetUser( Eval("Svid_User").AsText())%>
                        </td>
                        <td class="txt-center">
                            <%# SetProcessStatusText(Eval("ProcessYN").AsText()) %>
                        </td>
                        <td class="txt-center">
                            <%# GetUser( Eval("Process_User").AsText())%>
                        </td>
                        <td class="txt-center">
                            <%#   Eval("ProcessDate").AsDateTimeNullable() == null ? "" :Eval("ProcessDate").AsDateTime().ToString("yyyy-MM-dd")%>
                        </td>
                        <td class="txt-center">
                            <input type="hidden" id="hdUnumUpdateNo" value="<%# Eval("Unum_SystemupdateNo").AsText()%>" />
                            <a>
                                <img src="../Images/Board/detailBt-on.jpg" alt="상세확인버튼" onclick="fnPopupOpen(this)" onmouseover="this.src='../Images/Board/detailBt-off.jpg'" onmouseout="this.src='../Images/Board/detailBt-on.jpg'" />
                            </a>
                        </td>
                    </tr>
                </ItemTemplate>
                <EmptyDataTemplate>
                    <table id="tblSysList" class="tbl_main">
                        <thead>
                            <tr>
                                <th style="width: 50px">번호</th>
                                <th style="width: 80px">등록일</th>
                                <th style="width: 80px">대상</th>
                                <th style="width: 80px">화면</th>
                                <th style="width: 200px">제목</th>
                                <th style="width: 90px">요청자</th>
                                <th style="width: 70px">처리결과</th>
                                <th style="width: 70px">처리대상자</th>
                                <th style="width: 80px;">처리일</th>
                                <th style="width: 90px;">상세확인</th>
                            </tr>
                        </thead>
                        <tr>
                            <td colspan="10" class="txt-center">조회된 데이터가 없습니다.</td>
                        </tr>
                    </table>
                </EmptyDataTemplate>
            </asp:ListView>
            <!--데이터 리스트 종료 -->

            <!--페이징-->
            <div style="margin: 0 auto; text-align: center">
                <ucPager:ListPager ID="ucListPager" runat="server" OnPageIndexChange="ucListPager_PageIndexChange" PageSize="20" />
            </div>
            <!--페이징 끝-->

            <!--DIV팝업-시스템개선사항 요청 -->
            <div id="systemDiv" class="popupdiv divpopup-layer-package">

                <div class="popupdivWrapper" style="width: 700px;">
                    <div class="popupdivContents" style="border: none;">
                        <!--제목-->
                        <div class="close-div">
                            <a onclick="fnClosePopup('systemDiv'); return false;" style="cursor: pointer">
                                <img src="../../Images/Wish/icon-delete.jpg" alt="닫기" style="float: right;" /></a>
                        </div>
                        <div class="popup-title" style="margin-top: 20px;">
                            <h3 class="pop-title">시스템개선사항요청</h3>
                        </div>

                        <div class="tblSys-div">
                            <table id="tblSys" class="tbl_main tbl_popup">
                                <thead>
                                    <tr>
                                        <th colspan="4">요청내용</th>
                                    </tr>
                                </thead>
                                <tr>
                                    <th>등록일</th>
                                    <td>
                                        <asp:TextBox ID="txtEntryDate" runat="server" CssClass="popLabel" ReadOnly="true"></asp:TextBox></td>
                                    <th>요청자</th>
                                    <td>
                                        <asp:TextBox ID="txtSvidUser" runat="server" CssClass="popLabel" ReadOnly="true"></asp:TextBox></td>
                                </tr>
                                <tr>
                                    <th>대상</th>
                                    <td>
                                        <asp:TextBox ID="txtType" runat="server" CssClass="popLabel" ReadOnly="true"></asp:TextBox></td>
                                    <th>화면</th>
                                    <td>
                                        <asp:TextBox ID="txtDisplay" runat="server" CssClass="popLabel" ReadOnly="true"></asp:TextBox></td>
                                </tr>

                                <tr>
                                    <th>애로사항</th>
                                    <td colspan="3" style="height: 100px">
                                        <asp:TextBox ID="txtProblem" runat="server" TextMode="MultiLine" CssClass="popLabel-wide" Rows="4" ReadOnly="true"></asp:TextBox></td>
                                </tr>

                                <tr>
                                    <th>요청사항</th>
                                    <td colspan="3" style="height: 100px">
                                        <asp:TextBox ID="txtRequest" runat="server" TextMode="MultiLine" CssClass="popLabel-wide" Rows="4" ReadOnly="true"></asp:TextBox></td>
                                </tr>
                                <tr>
                                    <th>첨부파일</th>
                                    <td colspan="3" style="height: 100px">
                                        <table id="tblPopupDocument" class="tbl_main tbl_popup">
                                            <tbody>
                                            </tbody>
                                        </table>
                                    </td>
                                </tr>
                            </table>
                        </div>



                        <table class="tbl_main tbl_popup">
                            <thead>
                                <tr>
                                    <th colspan="4">처리내용</th>
                                </tr>
                            </thead>

                            <tr>
                                <th>처리대상자</th>
                                <td>
                                    <asp:TextBox runat="server" ID="txtProcessName"></asp:TextBox></td>
                                <th>요청결과</th>
                                <td style="width: 280px;">
                                    <asp:DropDownList runat="server" ID="ddlProcessResult">
                                        <asp:ListItem Value="Y">완료</asp:ListItem>
                                        <asp:ListItem Value="N">진행중</asp:ListItem>
                                        <asp:ListItem Value="A">진행불가</asp:ListItem>
                                    </asp:DropDownList></td>
                            </tr>

                            <tr>
                                <th>결과내용</th>
                                <td colspan="3" style="height: 100px">
                                    <asp:TextBox runat="server" ID="txtProcessResult" Rows="4" CssClass="txtbox" TextMode="MultiLine" placeholder="관리자 내용 입력"></asp:TextBox>
                                </td>
                            </tr>
                        </table>
                        <asp:HiddenField runat="server" ID="hfUnumUpdateNo" />
                        <div class="btn_center">


                            <asp:Button ID="btnSave" runat="server" Width="95" Height="30" Text="저장" OnClick="btnSave_Click" OnClientClick="return fnValidate();" CssClass="mainbtn type1" />
                            <%--<input type="button" class="mainbtn type1" style="width: 95px; height: 30px;" value="저장" onclick="btnSave_Click"/>--%>
                            <input type="button" class="mainbtn type2" style="width: 95px; height: 30px;" value="취소" onclick="fnClosePopup('systemDiv'); return false;" />

                        </div>

                    </div>
                </div>
            </div>
            <!--팝업끝-->

        </div>
    </div>
</asp:Content>


