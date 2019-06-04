<%@ Page Title="" Language="C#" MasterPageFile="~/Master/Default.master" AutoEventWireup="true" CodeFile="MemberEdit.aspx.cs" Inherits="Member_MemberEdit" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">

    <link rel="stylesheet" href="../Content/member.css">
    <script type="text/javascript">
        $(document).ready(function () {

            var docCnt = '<%=docCnt %>';
            if (Number(docCnt) > 0) $("#trDocTit").show();
            else $("#trDocTit").hide();

            var txtPwd = $("#<%=txtPwd.ClientID%>");
            var txtPwd_ch = $("#<%=txtPwd_ch.ClientID%>");
            var checkText = $('#spanChPwd');
            var txtLastEmail = $("#<%=txtLastEmail.ClientID %>");
            var dropDownListEmail = $("#<%=dropDownListEmail.ClientID %>");

            //패스워드 창 클리어
            txtPwd.keyup(function () {
                checkText.text('');
            });

            //패스워드와 패스워드 확인 일치 문구 
            txtPwd_ch.keyup(function () {
                if (txtPwd.val() != txtPwd_ch.val()) {
                    checkText.text('');
                    checkText.html("&nbsp;&nbsp;&nbsp;* 비밀번호가 일치하지 않습니다.");
                    checkText.css("color", "#ec2029");
                    checkText.css("font-weight", "bold");
                } else {
                    checkText.text('');
                    checkText.html("&nbsp;&nbsp;&nbsp;* 비밀번호가 일치합니다.");
                    checkText.css("color", "#ec2029");
                    checkText.css("font-weight", "bold");
                }
            });

            //이메일 선택
            dropDownListEmail.change(function () {
                var selectedVal = $('#<%=dropDownListEmail.ClientID %> option:selected').val();
                if (selectedVal == 'direct') {
                    txtLastEmail.val('');
                }
                else {
                    txtLastEmail.val(selectedVal);
                }
            });

            //테이블 동적 생성
            $.ajax({
                url: "GetCommData.aspx",
                type: "GET",
                async: false,
                cache: false,
                // data: param, //전송될 파라미터
                dataType: "json",
                success: function (response) {

                    var asynTable = "<table  style='width:1150px; height:200px; border:1px solid #a2a2a2; text-align:center'  >"
                    $.each(response, function (key, value) {
                        asynTable += "<colgroup><col style='width:130px; height:50px;'><col style='width:20px; border:1px solid #a2a2a2; border-bottom:1px solid #a2a2a2'><col style='width:570px; height:50px; border:1px solid #a2a2a2;'><col style='width:50px; height:50px; '></colgroup>";


                        //맨처음줄 추가버튼 생성
                        if (value.Map_Type == '0') {
                            asynTable += "<tr><th colspan='3' style='text-align:center; width:130px; height:10px; background-color:#ececec; border:1px solid #a2a2a2;'>첨부파일<span style='color: red; font - size:smaller'>(파일용량은 10MB까지 허용됩니다)</span></th>";
                            asynTable += "<td style='text-align:center; border:1px solid #a2a2a2;'><button type='button' onclick = 'fnAddTableRow(this)'><img src= '../Images/delivery/add-off.jpg'alt= '추가하기'/></button ></td>";
                        } else {
                            asynTable += "<tr><th style='text-align:center; width:130px; height:30px; background-color:#ececec; border:1px solid #a2a2a2;'>첨부파일</th>";
                            asynTable += "<td style='width:100px; border:1px solid #a2a2a2; text-align:center; '>" + value.Map_Name + "</td>";
                            asynTable += "<td colspan='2' style='border:1px solid #a2a2a2; '><input type='file' id='fuFile" + value.Map_Channel + "_" + value.Map_Type + "' name='fuFile" + value.Map_Channel + "_" + value.Map_Type + "' style='width:100%; height:25px; ' /></td>";
                        }
                        asynTable += "</tr>"
                    });
                    asynTable += "</table>";

                    $('#asynTable').append(asynTable);
                },
                error: function (xhr, status, error) {
                    alert('xhr: ' + xhr + 'status: ' + status + 'Error: ' + error + "\n오류가 발생했습니다. 잠시 후 다시 시도해 주세요.");


                }
            });
        });

        var index = 0;
        //동적으로 Row추가
        function fnAddTableRow(value) {
            $.ajax({
                url: "GetCommData.aspx",
                type: "GET",
                async: false,
                cache: false,
                // data: param, //전송될 파라미터
                dataType: "json",
                success: function (response) {
                    var asynTable = "";
                    var commValue = '';
                    asynTable += "<tr><th  style='text-align:center;height:30px; background-color:#ececec; border:1px solid #a2a2a2'>첨부파일</th>";
                    asynTable += "<td style='border:1px solid #a2a2a2'><select onchange='fnSetCommType(this.value, this, " + index + ")' style='width:100%; height:28px;'>";
                    $.each(response, function (key, value) {
                        if (value.Map_Type != 0) {
                            asynTable += "<option value='" + value.Map_Channel + "_" + value.Map_Type + "'>" + value.Map_Name + "</option>"
                        }
                    });
                    asynTable += "</select></td><td style='border:1px solid #a2a2a2' ><input type='file' id='fuFileAdd" + index + "_1_1' name='fuFileAdd" + index + "_1_1' style='width:100%; height:100%'/></td>";
                    asynTable += "<td style='text-align:center; border:1px solid #a2a2a2;'><button type='button'  " + index + "' name=btn'" + index + "' value='삭제' onclick ='fnDeleteTableRow(this)'><img src= '../Images/delivery/delete-on.jpg'alt= '삭제하기'/></button ></td></tr>";
                    $("table").children().last().append(asynTable);
                    index++;

                },
                error: function (xhr, status, error) {
                    alert('xhr: ' + xhr + 'status: ' + status + 'Error: ' + error + "\n오류가 발생했습니다. 잠시 후 다시 시도해 주세요.");


                }
            });
        };

        //row삭제
        function fnDeleteTableRow(obj) {
            var tr = $(obj).parent().parent();
            tr.remove();
            index--;
            return false;
        }


        //동적으로 추가된 파일업로드 ID세팅(서버 업로드 작업을 위해....)
        function fnSetCommType(value, select, paramIndex) {

            var id = $(select).parent().next('td').find('input').attr('id');
            $('#' + id).attr('name', 'fuFileAdd' + paramIndex + '_' + value);
            $('#' + id).attr('id', 'fuFileAdd' + paramIndex + '_' + value);
            return false;
        }
        function fnValidation() {
            var txtPwd = $("#<%=txtPwd.ClientID%>");
            var txtPwd_ch = $("#<%=txtPwd_ch.ClientID%>");
            var txtChargeName = $("#<%=txtPerson.ClientID%>");
            var txtPostion = $("#<%=txtPos.ClientID%>");
            var txtFirstEmail = $("#<%=txtFirstEmail.ClientID %>");
            var txtLastEmail = $("#<%=txtLastEmail.ClientID %>");
            var txtSelPhone = $("#<%=txtSelPhone.ClientID%>");
            var txtUptae = $("#<%=txtUptae.ClientID%>"); //업태
            var txtUpjong = $("#<%=txtUpjong.ClientID%>"); //업종
            var txtTelNo = $("#<%=txtTelNo.ClientID%>");
            var txtFaxNo = $("#<%=txtFaxNo.ClientID%>");

            if (txtPwd.val() == '') {
                alert('비밀번호를 입력해주세요.');
                txtPwd.focus();
                return false;
            }

            if (!chkPwd(txtPwd.val())) {
                return false;
            }
            if (txtPwd_ch.val() == '') {
                alert('비밀번호확인을 입력해주세요.');
                txtPwd_ch.focus();
                return false;
            }

            if (txtChargeName.val() == '') {
                alert('담당자명을 입력해주세요.');
                txtPwd.focus()
                return false;
            }

            if (txtPostion.val() == '') {
                alert('직책을 입력해주세요.');
                txtPostion.focus()
                return false;
            }

            if (txtFirstEmail.val() == '' || txtLastEmail.val() == '') {
                alert('E-Mail을 입력해주세요.');
                txtFirstEmail.focus()
                return false;
            }

            var regeMail = /^([\w-]+(?:\.[\w-]+)*)@((?:[\w-]+\.)*\w[\w-]{0,66})\.([a-z]{2,6}(?:\.[a-z]{2})?)$/;
            if (!regeMail.test((txtFirstEmail.val() + '@' + txtLastEmail.val()))) {
                alert("잘못된 이메일 형식입니다.");
                txtFirstEmail.focus();
                return false;
            }
            if (isEmpty($.trim(txtSelPhone.val())) || ($.trim(txtSelPhone.val()).length < 9)) {
                alert('휴대전화 번호를 입력해 주세요.');
                txtSelPhone.focus()
                return false;
            }

            if (isEmpty($.trim(txtTelNo.val())) || ($.trim(txtTelNo.val()).length < 9)) {
                alert("유선전화 번호를 입력해 주세요.");
                txtTelNo.focus()
                return false;
            }
            if (isEmpty($.trim(txtFaxNo.val())) || ($.trim(txtFaxNo.val()).length < 9)) {
                alert('Fax 번호를 입력해 주세요.');
                txtFaxNo.focus()
                return false;
            }

            if (isEmpty(txtUptae.val())) {
                alert('업태를 입력해주세요.');
                txtUptae.focus();
                return false;
            }
            if (isEmpty(txtUpjong.val())) {
                alert('업종을 입력해주세요.');
                txtUpjong.focus();
                return false;
            }

            var uploads = $('input[id^="fuFile"]');
            var exts = new Array();
            var isValidFile = true;
            var validFilesTypes = '<%= ConfigurationManager.AppSettings["AllowExtention"]%>';
            var maxFileSize = '<%= ConfigurationManager.AppSettings["UploadFileMaxSize"]%>';
            var sizeExcessFlag = true;
            $.each(uploads, function (key, value) {
                if ($(this).val() != '') {
                    var path = $(this).val();
                    var ext = path.substring(path.lastIndexOf(".") + 1, path.length).toLowerCase();
                    exts.push(ext);

                    if ($(this)[0].files[0].size > maxFileSize) {

                        sizeExcessFlag = false
                        return false;
                    }
                }
            });

            Array.prototype.contains = function (element) {
                for (var i = 0; i < this.length; i++) {
                    if (this[i] == element) {
                        return true;
                    }
                }
                return false;
            }

            for (var i = 0; i < exts.length; i++) {
                if (validFilesTypes.split(',').contains(exts[i]) == false) {
                    isValidFile = false;
                }
            }

            if (!sizeExcessFlag) {
                alert('파일 용량은 10MB보다 작아야 합니다.');
                return false;
            }
            if (!isValidFile) {
                alert('제한된 첨부파일 확장자가 존재합니다.');
                return false;
            }

            if (!confirm("저장하겠습니까?")) {
                return false;
            }
            return true;
        }

        

        function fnCancelEdit() {
            if (confirm('취소하시겠습니까?')) {
                location.href = '../Default.aspx';
                return false;
            }
        }

        function chkPwd(str) {

            var pw = str;
            var num = pw.search(/[0-9]/g);
            var eng = pw.search(/[a-z]/ig);
            var spe = pw.search(/[`~!@@#$%^&*|₩₩₩'₩";:₩/?]/gi);

            if (pw.length < 6 || pw.length > 15) {

                alert("6자리 ~ 15자리 이내로 입력해주세요.");
                return false;
            }

            if (pw.search(/₩s/) != -1) {

                alert("비밀번호는 공백업이 입력해주세요.");
                return false;
            }

            if ((num < 0 && eng < 0) || (eng < 0 && spe < 0) || (spe < 0 && num < 0)) {

                alert("영문,숫자, 특수문자 중 2가지 이상을 혼합하여 입력해주세요.");
                return false;
            }

            return true;
        }

        function fnConfirm() {
            if (!confirm('삭제하시겠습니까?')) {
                return false;
            }

            return true;
        }
    </script>
    <style>
        .deletefilelink {
            color: black
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">

    <div class="sub-contents-div">

        <div class="sub-title-div">
	        <img src="/images/MemberEditCheck_nam.png" />
         </div>
        <div class="table-div1">

            <table class="member-table">
                <colgroup>
                    <col style="width: 200px;" />
                    <col style="width: 800px" />

                </colgroup>
                <thead>
                </thead>
                <tbody>
                    <tr>
                        <td style="text-align: left; font-weight: bold">
                            <asp:Label runat="server" Text="*&nbsp;&nbsp;&nbsp;아이디"></asp:Label></td>
                        <td>
                            <asp:Label ID="lblId" runat="server" Text="" Style="padding-left: 5px; font-weight: bold"></asp:Label></td>
                    </tr>
                    <tr>
                        <td style="text-align: left; font-weight: bold">
                            <asp:Label runat="server" Text="*&nbsp;&nbsp;&nbsp;비밀번호" TextMode="Password"></asp:Label></td>
                        <td>
                            <asp:TextBox ID="txtPwd" runat="server" TextMode="Password" CssClass="text-input" Width="235px" onkeypress="return preventEnter(event);"></asp:TextBox><span id="spanPwd">&nbsp;&nbsp;＊영문/숫자 혼합으로 최소 6자 이상 입력하셔야 합니다.</span></td>
                    </tr>
                    <tr>
                        <td style="text-align: left; font-weight: bold">
                            <asp:Label runat="server" Text="*&nbsp;&nbsp;&nbsp;비밀번호확인" TextMode="Password"></asp:Label></td>
                        <td>
                            <asp:TextBox ID="txtPwd_ch" runat="server" TextMode="Password" CssClass="text-input" Width="235px" onkeypress="return preventEnter(event);"></asp:TextBox><span id="spanChPwd"></span></td>
                    </tr>
                    <tr>
                        <td>&nbsp;</td>
                    </tr>
                    <tr>
                        <td style="text-align: left; font-weight: bold">
                            <asp:Label runat="server" Text="*&nbsp;&nbsp;&nbsp;기관명"></asp:Label></td>
                        <td>
                            <asp:Label ID="lblOrgName" runat="server" Text="" CssClass="text-readonly" Width="235px"></asp:Label></td>
                    </tr>
                    <tr>
                        <td style="text-align: left; font-weight: bold">
                            <asp:Label runat="server" Text="*&nbsp;&nbsp;&nbsp;사업자번호"></asp:Label></td>
                        <td>
                            <asp:Label ID="lblFirstNum" runat="server" Width="70" CssClass="text-readonly"></asp:Label>&nbsp;-&nbsp;&nbsp;<asp:Label ID="lblMiddleNum" runat="server" Width="70" CssClass="text-readonly"></asp:Label>&nbsp;-&nbsp;<asp:Label ID="lblLastNum" runat="server" Width="63" CssClass="text-readonly"></asp:Label></td>
                    </tr>
                    <tr>
                        <td style="text-align: left; font-weight: bold">
                            <asp:Label runat="server" Text="*&nbsp;&nbsp;&nbsp;대표자명"></asp:Label></td>
                        <td>
                            <asp:Label ID="lblName" runat="server" Text="" CssClass="text-readonly" Width="235px"></asp:Label></td>
                    </tr>
                    <tr>
                        <td style="text-align: left; font-weight: bold">
                            <asp:Label runat="server" Text="*&nbsp;&nbsp;&nbsp;주소"></asp:Label></td>
                        <td>
                            <asp:Label ID="lblFirstAddr" runat="server" Text="" Width="100px" CssClass="text-readonly"></asp:Label></td>
                    </tr>
                    <tr>
                        <td></td>
                        <td>
                            <asp:Label ID="lblAddr2" runat="server" Text="" Width="400px" CssClass="text-readonly"></asp:Label>




                            <asp:Label ID="lblAddr3" runat="server" Text="" Width="300px" CssClass="text-readonly"></asp:Label></td>
                    </tr>
                    <tr>
                        <td>&nbsp;</td>
                    </tr>
                    <tr>
                        <td style="text-align: left; font-weight: bold">
                            <asp:Label runat="server" Text="*&nbsp;&nbsp;&nbsp;담당자명"></asp:Label></td>
                        <td>
                            <asp:TextBox ID="txtPerson" runat="server" CssClass="text-input" Width="235px" onkeypress="return preventEnter(event);"></asp:TextBox></td>
                    </tr>
                    <tr>
                        <td style="text-align: left; font-weight: bold">
                            <asp:Label runat="server" Text="*&nbsp;&nbsp;&nbsp;부서명"></asp:Label></td>
                        <td>
                            <asp:Label ID="lblDept" runat="server" Text="" CssClass="text-readonly" Width="235px"></asp:Label></td>
                    </tr>
                    <tr>
                        <td style="text-align: left; font-weight: bold">
                            <asp:Label runat="server" Text="*&nbsp;&nbsp;&nbsp;직책"></asp:Label></td>
                        <td>
                            <asp:TextBox ID="txtPos" runat="server" CssClass="text-input" Width="235px" onkeypress="return preventEnter(event);"></asp:TextBox></td>
                    </tr>
                    <tr>
                        <td style="text-align: left; font-weight: bold">
                            <asp:Label runat="server" Text="*&nbsp;&nbsp;&nbsp;이메일"></asp:Label></td>
                        <td>
                            <asp:TextBox ID="txtFirstEmail" runat="server" CssClass="text-input" Width="100" onkeypress="return preventEnter(event);"></asp:TextBox>&nbsp;@&nbsp;<asp:TextBox ID="txtLastEmail" runat="server" CssClass="text-input" Width="117"></asp:TextBox>
                            <asp:DropDownList ID="dropDownListEmail" runat="server" CssClass="drop-email">
                                <asp:ListItem Value="direct" Text="-------직접입력------"></asp:ListItem>
                                <asp:ListItem Value="hanmail.net" Text="hanmail.net"></asp:ListItem>
                                <asp:ListItem Value="naver.com" Text="naver.com"></asp:ListItem>
                                <asp:ListItem Value="hotmail.com" Text="hotmail.com"></asp:ListItem>
                                <asp:ListItem Value="nate.com" Text="nate.com"></asp:ListItem>
                                <asp:ListItem Value="yahoo.co.kr" Text="yahoo.co.kr"></asp:ListItem>
                                <asp:ListItem Value="empas.com" Text="empas.com"></asp:ListItem>
                                <asp:ListItem Value="dreamwiz.com" Text="dreamwiz.com"></asp:ListItem>
                                <asp:ListItem Value="freechal.com" Text="freechal.com"></asp:ListItem>
                                <asp:ListItem Value="lycos.co.kr" Text="lycos.co.kr"></asp:ListItem>
                                <asp:ListItem Value="korea.com" Text="korea.com"></asp:ListItem>
                                <asp:ListItem Value="gmail.com" Text="gmail.com"></asp:ListItem>
                                <asp:ListItem Value="hanmir.com" Text="hanmir.com"></asp:ListItem>
                                <asp:ListItem Value="paran.com" Text="paran.com"></asp:ListItem>
                                <asp:ListItem Value="netsgo.com" Text="netsgo.com"></asp:ListItem>
                            </asp:DropDownList>
                        </td>
                    </tr>
                    <tr>
                        <td style="text-align: left; font-weight: bold">
                            <asp:Label runat="server" Text="*&nbsp;&nbsp;&nbsp;휴대전화번호"></asp:Label></td>
                        <td>
                            <asp:TextBox ID="txtSelPhone" runat="server" Width="100px" MaxLength="12" onkeypress="return onlyNumbers(event);" CssClass="text-input"></asp:TextBox>
                            <label style="margin-left:5px; font-weight:normal;">'-' 없이 입력해 주세요.</label>
                        </td>
                    </tr>
                    <tr>
                        <td style="text-align: left; font-weight: bold">
                            <asp:Label runat="server" Text="*&nbsp;&nbsp;&nbsp;유선전화번호"></asp:Label></td>
                        <td>
                            <%--<asp:Label ID="lblTelNo" runat="server" Width="100px" CssClass="text-readonly"></asp:Label>--%>
                            <asp:TextBox ID="txtTelNo" runat="server" CssClass="department" Width="100px" MaxLength="12" onkeypress="return onlyNumbers(event);"></asp:TextBox>
                            <label style="margin-left:5px; font-weight:normal;">'-' 없이 입력해 주세요.</label>
                        </td>
                    </tr>
                    <tr>
                        <td style="text-align: left; font-weight: bold">
                            <asp:Label runat="server" Text="*&nbsp;&nbsp;&nbsp;Fax번호"></asp:Label></td>
                        <td>
                            <%--<asp:Label ID="lblFaxNo" runat="server" Width="100px" CssClass="text-readonly"></asp:Label>--%>
                            <asp:TextBox ID="txtFaxNo" runat="server" CssClass="department" Width="100px" MaxLength="12" onkeypress="return onlyNumbers(event);"></asp:TextBox>
                            <label style="margin-left:5px; font-weight:normal;">'-' 없이 입력해 주세요.</label>
                        </td>
                    </tr>
                    <tr>
                        <td style="font-weight: bold">＊&nbsp;&nbsp;대표업태
                        </td>
                        <td>
                            <asp:TextBox ID="txtUptae" runat="server" CssClass="department" Width="245px" onkeypress="return preventEnter(event);"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <td style="font-weight: bold">＊&nbsp;&nbsp;업종
                        </td>
                        <td>
                            <asp:TextBox ID="txtUpjong" runat="server" CssClass="department" Width="245px" onkeypress="return preventEnter(event);"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <td></td>
                        <td>입력하신 정보가 세금계산서 상에 기입되어 발행됩니다.<br />
                            세금계산서는 회원가입 시 입력하신 이메일로 발송되며,<br />
                            회원가입 후 마이페이지에서 변경 및 수정이 가능합니다.
                        </td>
                    </tr>
                    <tr>
                        <td><span class="check">(선택사항)</span></td>
                    </tr>
                    <tr>
                        <td colspan="2">이벤트/쇼핑혜택 SMS 수신동의&nbsp;&nbsp;&nbsp; 
                            <asp:RadioButton ID="rbSMSAlllowY" runat="server" GroupName="rbSMS" Text="&nbsp;Y" />&nbsp; 
                            <asp:RadioButton ID="rbSMSAlllowN" runat="server" GroupName="rbSMS" Text="&nbsp;N" />
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2">이벤트/쇼핑혜택 이메일 수신동의&nbsp;&nbsp;
                            <asp:RadioButton ID="rbEmailAlllowY" runat="server" GroupName="rbEmail" Text="&nbsp;Y" />&nbsp; 
                            <asp:RadioButton ID="rbEmailAlllowN" runat="server" GroupName="rbEmail" Text="&nbsp;N" />
                        </td>
                    </tr>
                    <tr id="trDocTit" style="height: 60px; vertical-align: bottom; display: none;">
                        <th colspan="2">
                            <h5>▶&nbsp;&nbsp;문서정보</h5>
                        </th>
                    </tr>
                    <asp:ListView runat="server" ID="lvDocList" OnItemCommand="lvDocList_ItemCommand" OnItemDeleting="lvDocList_ItemDeleting">
                        <ItemTemplate>
                            <tr>
                                <th>
                                    <%# Eval("Map_Name").ToString()%>
                                </th>
                                <td>
                                    <asp:LinkButton runat="server" ID="lbAttachFileName" Text='<%# Eval("AttachFile.Attach_P_Name").ToString()%>' CommandName="download" CommandArgument='<%# Eval("AttachFile.Attach_Path").ToString()%>'></asp:LinkButton>&nbsp;&nbsp;
                                    <asp:LinkButton runat="server" CssClass="deletefilelink" ID="lbDeleteFile" Text='삭제' CommandName="delete" CommandArgument='<%# Eval("Svid_Doc").ToString()%>' OnClientClick="return fnConfirm();"></asp:LinkButton>
                                    <asp:HiddenField runat="server" ID="hfPath" Value='<%# Eval("AttachFile.Attach_Path").ToString()%>' />
                                </td>
                            </tr>
                        </ItemTemplate>
                    </asp:ListView>
                    <tr>
                        <td colspan="2">
                            <span class="mini-title">
                                <img src="../Images/member/docu-title.jpg" /></span>

                            <div class="id-table-div" style="border: none; height: auto">

                                <%--동적으로 추가해야 되는 테이블이니까 지우지 말고 스크립트 //테이블 동적 생성 부분에서 CSS수정해주세요--%>
                                <table id="asynTable">
                                </table>

                            </div>
                        </td>
                    </tr>
                </tbody>
            </table>

        </div>
        <div class="bottomBtn">
            <asp:Button ID="btnCancel" runat="server"  OnClientClick="return fnCancelEdit();" Text="취소" CssClass="mainbtn type1" Width="117" Height="30"/>
            <asp:Button ID="btnOk" runat="server" OnClick="btnOk_Click" OnClientClick="return fnValidation();" Text="확인" CssClass="mainbtn type1" Width="117" Height="30"/>


            <%--<asp:ImageButton ID="btnCancel" runat="server" Text="취소" CssClass="right-bt" OnClientClick="return fnCancelEdit();" src="../images/cancle_btn.jpg" onmouseover="this.src='../Images/member/cancle-btn.jpg'" onmouseout="this.src='../images/cancle_btn.jpg'" />
            <asp:ImageButton ID="btnOk" runat="server" Text="변경완료" CssClass="right-bt" OnClick="btnOk_Click" OnClientClick="return fnValidation();" src="../Images/member/completed-btn.jpg" onmouseover="this.src='../images/change-btn.jpg'" onmouseout="this.src='../Images/member/completed-btn.jpg'" />--%>
        </div>
        <div class="left-menu-wrap" id="divLeftMenu">
            <dl>
                 <dt style="border-bottom:1px solid #eaeaea;">
                    <strong>마이페이지</strong>
                </dt>
                <dd>
                    <a href="/Order/OrderHistoryList.aspx">주문조회</a>
                </dd>
                <dd>
                    <a href="/Delivery/DeliveryOrderList.aspx">배송조회</a>
                </dd>
                <dd>
                    <a href="/Order/OrderBillIssue.aspx">세금계산서 조회</a>
                </dd>
                
                <dd class="active">
                    <a href="/Member/MemberEditCheck.aspx">마이정보변경</a>
                </dd>
                <dd>
                    <a href="/Delivery/DeliveryList.aspx">배송지관리</a>
                </dd>
            </dl>
        </div>
    </div>
</asp:Content>

