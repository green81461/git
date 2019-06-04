<%@ Page Title="" Language="C#" MasterPageFile="~/Master/Login.master" AutoEventWireup="true" CodeFile="MemberCreate_B.aspx.cs" Inherits="Member_MemberCreate_B" %>
<%@ Import Namespace="Urian.Core" %>


<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <!doctype html>
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">


    <link rel="stylesheet" href="../Content/member.css" />

    <script type="text/javascript">
        $(document).ready(function () {
            $("#<%=hfDomain.ClientID%>").val(window.location.hostname);

            var txtPwd = $("#<%=txtPwd.ClientID%>");
            var txtPwdCheck = $("#<%=txtPwdCheck.ClientID%>");
            var txtEmail2 = $("#<%=txtEmail2.ClientID %>");
            var ddlEmail = $("#<%=ddlEmail3.ClientID %>");
            var checkText = $('#lbCheckText');


            //패스워드 창 클리어
            txtPwd.keyup(function () {
                checkText.text('');
            });

            //패스워드와 패스워드 확인 일치 문구 
            txtPwdCheck.keyup(function () {
                if (txtPwd.val() != txtPwdCheck.val()) {
                    checkText.text('');
                    checkText.html("비밀번호가 일치하지 않습니다.");
                } else {
                    checkText.text('');
                    checkText.html("비밀번호가 일치합니다.");
                }
            });

            //이메일 선택
            ddlEmail.change(function () {
                var selectedVal = $('#<%=ddlEmail3.ClientID %> option:selected').val();
                if (selectedVal == 'direct') {
                    txtEmail2.val('');
                }
                else {
                    txtEmail2.val(selectedVal);
                }
            });

        })

        function fnValidation() {
            var txtId = $("#<%=txtId.ClientID%>");
            var txtPwd = $("#<%=txtPwd.ClientID%>");
            var txtPwdCheck = $("#<%=txtPwdCheck.ClientID%>");
            var txtOrganName = $("#<%=txtOrganName.ClientID%>");

            var txtBusinessNum1 = $("#<%=txtBusinessNum1.ClientID%>");
            var txtBusinessNum2 = $("#<%=txtBusinessNum2.ClientID%>");
            var txtBusinessNum3 = $("#<%=txtBusinessNum3.ClientID%>");

            var txtRepresentativeName = $("#<%=txtRepresentativeName.ClientID%>");
            var txtPostalCode = $("#<%=txtPostalCode.ClientID%>");
            var txtChargeName = $("#<%=txtChargeName.ClientID%>");
            var txtDeptName = $("#<%=txtDeptName.ClientID%>");
            var txtPostion = $("#<%=txtPostion.ClientID%>");

            var txtEmail1 = $("#<%=txtEmail1.ClientID%>");
            var txtEmail2 = $("#<%=txtEmail2.ClientID%>");
            
            var txtSelPhone = $("#<%=txtSelPhone.ClientID%>");
            var txtTelPhone = $("#<%=txtTelPhone.ClientID%>");
            var txtFax = $("#<%=txtFax.ClientID%>");
            
            var txtUptae = $("#<%=txtUptae.ClientID%>"); //업태
            var txtUpjong = $("#<%=txtUpjong.ClientID%>"); //업종


            if (txtId.val() == '') {
                alert('아이디를 입력해주세요.');
                txtId.focus();
                return false;
            }
            if (!chkID(txtId.val())) {
                alert('아이디는 숫자와 영문 조합으로 6자리 이상 사용해야 합니다.');
                txtId.focus();
                return false;
            }
            if (txtPwd.val() == '') {
                alert('비밀번호를 입력해주세요.');
                txtPwd.focus();
                return false;
            }
            if (!chkPwd(txtPwd.val())) {
                txtPwd.focus();
                return false;
            }

            if (txtPwd.val().indexOf(txtId.val()) > -1) {
                alert('ID가 포함된 비밀번호는 사용하실 수 없습니다.');
                txtPwd.focus();
                return false;
            }

            if (txtPwdCheck.val() == '') {
                alert('비밀번호확인을 입력해주세요.');
                txtPwdCheck.focus();
                return false;
            }
            if (txtOrganName.val() == '') {
                alert('기관명을 입력해주세요.');
                txtOrganName.focus();
                return false;
            }
            if (txtBusinessNum1.val().length != 3 || txtBusinessNum2.val().length != 2 || txtBusinessNum3.val().length != 5) {
                alert('사업자번호를 제대로 입력해주세요.');
                txtBusinessNum1.focus();
                return false;
            }
            if (txtRepresentativeName.val() == '') {
                alert('대표자명을 입력해주세요.');
                txtRepresentativeName.focus();
                return false;
            }
            if (txtPostalCode.val() == '') {
                alert('주소를 입력해주세요.');
                txtPostalCode.focus();
                return false;
            }
            if (txtChargeName.val() == '') {
                alert('담당자명을 입력해주세요.');
                txtPwd.focus();
                return false;
            }
            if (txtDeptName.val() == '') {
                alert(' 부서명을 입력해주세요.');
                txtDeptName.focus();
                return false;
            }
            if (txtPostion.val() == '') {
                alert('직책을 입력해주세요.');
                txtPostion.focus();
                return false;
            }
            if (txtEmail1.val() == '' || txtEmail2.val() == '') {
                alert('E-Mail을 입력해주세요.');
                txtEmail1.focus();
                return false;
            }
            var regeMail = /^([\w-]+(?:\.[\w-]+)*)@((?:[\w-]+\.)*\w[\w-]{0,66})\.([a-z]{2,6}(?:\.[a-z]{2})?)$/;
            if (!regeMail.test((txtEmail1.val() + '@' + txtEmail2.val()))) {
                alert("잘못된 이메일 형식입니다.");
                txtEmail1.focus();
                return false;
            }
            if (isEmpty(txtSelPhone.val())) {
                alert('휴대전화번호를 올바르게 입력해 주세요.');
                txtSelPhone.focus();
                return false;
            }
            if (isEmpty(txtTelPhone.val())) {
                alert('유선전화번호를 올바르게 입력해주세요.');
                txtTelPhone.focus();
                return false;
            }
            if (isEmpty(txtFax.val())) {
                alert('팩스번호를 올바르게 입력해주세요.');
                txtFax.focus();
                return false;
            }
            if (txtPwd.val() != txtPwdCheck.val()) {
                alert('비밀번호 확인이 일치하지 않습니다.');
                txtPwdCheck.focus();
                return false;
            }

            if ($('#hdIdCheckFlag').val() == '0') {
                alert('아이디 중복 확인을 해주세요.');
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


            var compNo = txtBusinessNum1.val() + '-' + txtBusinessNum2.val() + '-' + txtBusinessNum3.val();
            var siteName = '<%= SiteName%>';
            if (fnCheckCompNo(compNo, siteName) == false && siteName != 'socialwith') {
                alert('회원가입을 하실수 없습니다.\n관리자에게 문의 주시기 바랍니다. \n관리담장자 : 김민(02 - 6363 - 2174)');
                return false;
            }

            var fileuploader = $("#<%=fuRegist.ClientID%>");
            //if (fileuploader[0].files[0] == undefined || fileuploader[0].files[0] == null) {
            //    alert('사업자 등록증은 필수 첨부입니다.')
            //    return false;
            //}

            var path = fileuploader.val();
            var ext = path.substring(path.lastIndexOf(".") + 1, path.length).toLowerCase();
            var validFilesTypes = '<%= ConfigurationManager.AppSettings["AllowExtention"]%>';

            var isValidFile = false;
            for (var i = 0; i < validFilesTypes.split(',').length; i++) {
                if (ext == validFilesTypes.split(',')[i]) {
                    isValidFile = true;
                    break;
                }
            }

            var maxFileSize = '<%= ConfigurationManager.AppSettings["UploadFileMaxSize"]%>';

            if (fileuploader[0].files[0] != null) {
                if (fileuploader[0].files[0].size > maxFileSize) {

                    alert('파일 용량은 10MB보다 작아야 합니다.');
                    return false;
                }
            }

            if (!isValidFile && path != '') {
                alert('제한된 첨부파일 확장자입니다.');
                return false;
            }

            if (!confirm("등록하시겠습니까?")) {
                return false;
            }

            return true;
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
        
        //아이디 중복 체크
        function fnCheckId() {

            var txtId = $("#<%=txtId.ClientID%>");
            var result = false;

            if (txtId.val() == '') {
                alert('아이디를 입력해주세요.');
                txtId.focus()
                return false;
            }

            if (!chkID(txtId.val())) {
                alert('아이디는 숫자와 영문 조합으로 6자리 이상 사용해야 합니다.');
                txtId.focus();
                return false;
            }

            var param = 'TextId=' + txtId.val();
            $.ajax({
                url: 'DuplicationCheck.aspx',
                type: "GET",
                async: false,
                cache: false,
                data: param,
                dataType: "json",
                success: function (response) {
                    result = response;
                },
                error: function (xhr, status, error) {
                    alert('xhr: ' + xhr + 'status: ' + status + 'Error: ' + error + "\n오류가 발생했습니다. 잠시 후 다시 시도해 주세요.");
                    $("#myPwdModal").modal("hide");
                }
            });

            if (result == false) {
                alert('아이디' + txtId.val() + '는 이미 사용중입니다.');
                txtId.val('');
                txtId.focus();
                return false;
            }
            else {
                if (confirm('아이디' + txtId.val() + '는 사용가능합니다. 사용하시겠습니까?') == false) {
                    txtId.val('');
                    txtId.focus();
                    $('#hdIdCheckFlag').val('0'); //플래그 초기화
                    return false;
                }
            }
            $('#hdIdCheckFlag').val('1'); //중복 확인 후 플래그 업데이트

            return;
        }


        //사업자번호 중복체크
        function fnCheckCompNo(compno, sitename) {

            var returnVal = true;
            var param = { CompNo: compno, SiteName: sitename, Flag: 'GetCompCountByCompNoUrl' };

            
            var callback = function (response) {
                if (!isEmpty(response) && parseInt(response) > 0) {
                    returnVal = false;
                }
            }
            var beforeSend = function () {
            };

            var complete = function () {
            };

            JqueryAjax('Post', '../Handler/Admin/CompanyHandler.ashx', false, false, param, 'json', callback, beforeSend, complete, false, '');
            return returnVal;
        }

        // 사업자번호 최대 입력수 제한
        function maxLengthCheck(object) {
            if (object.value.length > object.maxLength) {
                object.value = object.value.slice(0, object.maxLength);
            }
        }

        function fnInsertCancel() {
            if (confirm('취소하시겠습니까?')) {

                var geturl = location.host;
                if ($('#hdMasterSiteName').val() == 'socialwith') {
                    location.href = '../Member/MemberJoinSelect.aspx';
                }
                else {
                    location.href = '/Default.aspx';
                }


                return false;
            }
        }
    </script>
    <script>
        //우편번호 팝업
        function openPostcode() {
            var width = 500; //팝업의 너비
            var height = 500; //팝업의 높이
            new daum.Postcode({
                width: width,
                height: height,
                oncomplete: function (data) {
                    // 팝업에서 검색결과 항목을 클릭했을때 실행할 코드를 작성하는 부분.

                    // 각 주소의 노출 규칙에 따라 주소를 조합한다.
                    // 내려오는 변수가 값이 없는 경우엔 공백('')값을 가지므로, 이를 참고하여 분기 한다.
                    var fullAddr = ''; // 최종 주소 변수
                    var extraAddr = ''; // 조합형 주소 변수

                    // 사용자가 선택한 주소 타입에 따라 해당 주소 값을 가져온다.
                    if (data.userSelectedType === 'R') { // 사용자가 도로명 주소를 선택했을 경우
                        fullAddr = data.roadAddress;

                    } else { // 사용자가 지번 주소를 선택했을 경우(J)
                        fullAddr = data.jibunAddress;
                    }

                    // 사용자가 선택한 주소가 도로명 타입일때 조합한다.
                    if (data.userSelectedType === 'R') {
                        //법정동명이 있을 경우 추가한다.
                        if (data.bname !== '') {
                            extraAddr += data.bname;
                        }
                        // 건물명이 있을 경우 추가한다.
                        if (data.buildingName !== '') {
                            extraAddr += (extraAddr !== '' ? ', ' + data.buildingName : data.buildingName);
                        }
                        // 조합형주소의 유무에 따라 양쪽에 괄호를 추가하여 최종 주소를 만든다.
                        fullAddr += (extraAddr !== '' ? ' (' + extraAddr + ')' : '');
                    }

                    // 우편번호와 주소 정보를 해당 필드에 넣는다.
                    $("#<%=txtPostalCode.ClientID%>").val(data.zonecode);
                    $("#<%=hfPostalCode.ClientID%>").val(data.zonecode);
                    $("#<%=txtAddress1.ClientID%>").val(fullAddr);
                    $("#<%=hfAddress1.ClientID%>").val(fullAddr);

                    //document.getElementById('sample6_postcode').value = data.zonecode; //5자리 새우편번호 사용
                    //document.getElementById('sample6_address').value = fullAddr;

                    //// 커서를 상세주소 필드로 이동한다.
                    $("#<%=txtAddress2.ClientID%>").focus();
                }
            }).open({
                left: (window.screen.width / 2) - (width / 2),
                top: (window.screen.height / 2) - (height / 2)
            }
                );
        }
    </script>


</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <%--<body>--%>
        <div class="sub-contents-div">

        <div class="sub-title-div">
             <p style="font-size:30px; margin:0; font-weight:bold; text-align:center;">회원가입 </p>
        <p style="font-size:15px;  margin:10px 0 20px 0; text-align:center;">회원님을 위한 다양한 혜택이 기다리고 있습니다. </p>
                      <p style="border:1px solid #b1b1b1; padding-top:20px; padding-bottom:10px;text-align:center;"><img src="/images/MemberCreate_nam.jpg" /></p>
       <div class="sub-title-div">

	       <%-- <p class="p-title-mainsentence">
                       회원가입
                       <span class="span-title-subsentence">회원님을 위한 다양한 혜택이 기다리고 있습니다.</span>
            </p>--%>
         </div>
            <asp:HiddenField runat="server" ID="hfDomain" />

                <h3 style="font-size:14px"><span style="margin-right:5px;"><img src="/images/base_impor.jpg"/></span>기본정보입력 <span style="font-size:11px; padding-left:15px; font-weight:400;color:#ee2248">*표시는 필수입력 항목이오니 반드시 입력해주세요.</span></h3> 

            <div class="table-div1">

                <table class="member-table">
                    <tr>
                        <td style="font-weight: bold">＊&nbsp;&nbsp;아이디
                        </td>
                        <td>
                            <asp:TextBox ID="txtId" runat="server" CssClass="id" Width="245px" onkeypress="return preventEnter(event);"></asp:TextBox>
                            <input type="button" class="mainbtn type1" style="width:105px; vertical-align:middle; height:29px; font-size:12px" value="아이디 중복확인" onclick="fnCheckId(); return false;"/>

                            <%--<asp:ImageButton ID="btnDuplicationCheck" runat="server" Text="아이디 중복확인" OnClientClick="fnCheckId(); return false;" src="../images/idDuplCheck_btn.jpg" CssClass="idCheck-btn" />--%>
                            <span>＊아이디는 공백 없이 6자 이상~ 20자이하여야 합니다.</span>
                            <input type="hidden" id="hdIdCheckFlag" value="0" />
                        </td>
                    </tr>
                    <tr>
                        <td style="font-weight: bold">＊&nbsp;&nbsp;비밀번호
                        </td>
                        <td>
                            <asp:TextBox ID="txtPwd" runat="server" TextMode="Password" CssClass="password" Width="245px" onkeypress="return preventEnter(event);"></asp:TextBox>
                            <span>＊영문/숫자 혼합으로 최소 6자 이상 입력하셔야 합니다.</span>
                        </td>
                    </tr>
                    <tr>
                        <td style="font-weight: bold">＊&nbsp;&nbsp;비밀번호 확인
                        </td>
                        <td>
                            <asp:TextBox ID="txtPwdCheck" runat="server" TextMode="Password" CssClass="re-password" Width="245px" onkeypress="return preventEnter(event);"></asp:TextBox>
                            <label id="lbCheckText" style="color: red"></label>
                        </td>
                    </tr>

                    
                    
                    <tr>
                        <td style="font-weight: bold">＊&nbsp;&nbsp;담당자명
                        </td>
                        <td>
                            <asp:TextBox ID="txtChargeName" runat="server" CssClass="director" Width="245px" onkeypress="return preventEnter(event);"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <td style="font-weight: bold">＊&nbsp;&nbsp;부서명
                        </td>
                        <td>
                            <asp:TextBox ID="txtDeptName" runat="server" CssClass="department" Width="245px" onkeypress="return preventEnter(event);"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <td style="font-weight: bold">＊&nbsp;&nbsp;직책
                        </td>
                        <td>
                            <asp:TextBox ID="txtPostion" runat="server" CssClass="position" Width="245px" onkeypress="return preventEnter(event);"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <td style="font-weight: bold">＊&nbsp;&nbsp;E-Mail주소
                        </td>
                        <td>

                            <asp:TextBox ID="txtEmail1" runat="server" Width="100px" CssClass="email1" onkeypress="return preventEnter(event);"></asp:TextBox>&nbsp;&nbsp;@&nbsp;
                        <asp:TextBox ID="txtEmail2" runat="server" CssClass="email2" Width="120" onkeypress="return preventEnter(event);"></asp:TextBox>
                            <asp:DropDownList ID="ddlEmail3" runat="server" CssClass="email3" Width="160">
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
                        <td style="font-weight: bold">＊&nbsp;&nbsp;휴대전화번호
                        </td>
                        <td>
                            <asp:TextBox ID="txtSelPhone" runat="server" Width="127px" MaxLength="12" onkeypress="return onlyNumbers(event);" CssClass="text-input"></asp:TextBox>
                            <label style="margin-left:5px; font-weight:normal;">'-' 없이 입력해 주세요.</label>
                        </td>
                    </tr>
                    <tr>
                        <td style="font-weight: bold">＊&nbsp;&nbsp;유선전화번호
                        </td>
                        <td>
                            <asp:TextBox ID="txtTelPhone" runat="server" Width="127px" MaxLength="12" onkeypress="return onlyNumbers(event);" CssClass="text-input"></asp:TextBox>
                            <label style="margin-left:5px; font-weight:normal;">'-' 없이 입력해 주세요.</label>
                        </td>
                    </tr>
                    <tr>
                        <td style="font-weight: bold">＊&nbsp;&nbsp;Fax번호
                        </td>
                        <td>
                            <asp:TextBox ID="txtFax" runat="server" Width="127px" MaxLength="12" onkeypress="return onlyNumbers(event);" CssClass="text-input"></asp:TextBox>
                            <label style="margin-left:5px; font-weight:normal;">'-' 없이 입력해 주세요.</label>
                        </td>
                    </tr>
                    

                   
                </table>
                
                
            </div>

            <h3 style="font-size:14px"><img style="margin-right:5px;" src="/images/company_nam.jpg"/>회사정보입력 <span style="font-size:11px; font-weight:400;padding-left:15px; color:#ee2248;">*표시는 필수입력 항목이오니 반드시 입력해주세요.</span></h3> 
            <div class="table-div1">
                <table class="member-table">
                    <tr>
                        <td style="font-weight: bold">＊&nbsp;&nbsp;기관명
                        </td>
                        <td>
                            <asp:TextBox ID="txtOrganName" runat="server" CssClass="organization" Width="245px" onkeypress="return preventEnter(event);"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <td style="font-weight: bold">＊&nbsp;&nbsp;사업자번호
                        </td>
                        <td>
                            <asp:TextBox ID="txtBusinessNum1" runat="server" TextMode="Number" max="9999" oninput="return maxLengthCheck(this)" MaxLength="3" Width="70px" onkeypress="return onlyNumbers(event);" CssClass="taxId1"></asp:TextBox>&nbsp;&nbsp;-&nbsp;
                        <asp:TextBox ID="txtBusinessNum2" runat="server" TextMode="Number" max="9999" oninput="return maxLengthCheck(this)" MaxLength="2" Width="70px" onkeypress="return onlyNumbers(event);" CssClass="taxId2"></asp:TextBox>&nbsp;&nbsp;-&nbsp;
                        <asp:TextBox ID="txtBusinessNum3" runat="server" TextMode="Number" max="99999" oninput="return maxLengthCheck(this)" MaxLength="5" Width="70px" onkeypress="return onlyNumbers(event);" CssClass="taxId3"></asp:TextBox>
                            <span>＊사업자번호나 고유번호를 입력해주세요.</span>
                        </td>
                    </tr>
                    <tr>
                        <td style="font-weight: bold">＊&nbsp;&nbsp;대표자명
                        </td>
                        <td>
                            <asp:TextBox ID="txtRepresentativeName" runat="server" CssClass="representative" Width="245px" onkeypress="return preventEnter(event);"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <td rowspan="2" style="font-weight: bold">＊&nbsp;&nbsp;주소
                        </td>
                        <td>
                            <asp:TextBox ID="txtPostalCode" runat="server" ReadOnly="true" CssClass="zipSearch" Width="145px" onkeypress="return preventEnter(event);"></asp:TextBox>
                            <asp:HiddenField ID="hfPostalCode" runat="server" />
                            <input type="button"  class="mainbtn type1" style="width:95px; vertical-align:middle; height:29px; font-size:12px" value="우편번호 검색" onclick="openPostcode();"/>
                            <%--<input type="button" class="zipCheck-btn" onclick="openPostcode()" />--%>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <asp:TextBox ID="txtAddress1" runat="server" Width="300px" ReadOnly="true" CssClass="addr1" onkeypress="return preventEnter(event);"></asp:TextBox>
                            <asp:HiddenField ID="hfAddress1" runat="server" />
                            <asp:TextBox ID="txtAddress2" runat="server" Width="300px" CssClass="addr2" onkeypress="return preventEnter(event);"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2">
                            <div>&nbsp;</div>
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
                </table>
            </div>
            <h3 style="font-size:14px"><span><img style="vertical-align:bottom;" src="/images/market_nam.jpg" /></span>마켓팅 활용 입력 <span style="font-size:11px; padding-left:15px;font-weight:400; color:#ee2248;">(선택사항)</span></h3> 
            <div class="table-div1">
                <table>
                     
                    <tr>
                        <td colspan="2">이벤트/쇼핑혜택 SMS 수신동의&nbsp;&nbsp;&nbsp; 
                        <asp:RadioButton ID="rbSMSAlllowY" runat="server" GroupName="rbSMS" Text="&nbsp;Y" Checked="true" />&nbsp; 
                        <asp:RadioButton ID="rbSMSAlllowN" runat="server" GroupName="rbSMS" Text="&nbsp;N" />
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2">이벤트/쇼핑혜택 이메일 수신동의&nbsp;&nbsp;
                        <asp:RadioButton ID="rbEmailAlllowY" runat="server" GroupName="rbEmail" Text="&nbsp;Y" Checked="true" />&nbsp; 
                        <asp:RadioButton ID="rbEmailAlllowN" runat="server" GroupName="rbEmail" Text="&nbsp;N" />
                        </td>
                    </tr>
                </table>
            </div>

             <p><span style="margin-right:5px;"><img src="/images/text_star_red.png" /></span><span style="margin-right:10px;color:#ee2248;font-size:18px;margin-top:50px;">문서등록</span><span> 초기 문서를 등록하시는 고객님께서는 보다 신속한 거래가 가능합니다.(첨부파일 확장자는 DOC, HWP, PDF, JPF로 제한되어 있습니다. 제한 용량은 10MB 입니다.)   </span></p>
            <table class="insert-docu" style="margin-top: 20px; margin-bottom: 20px;">
                <tr>
                    <th style="border: 1px solid #a2a2a2; width: 350px; text-align: center;">첨부파일<br />
                    
                    <td style="border: 1px solid #a2a2a2; width: 300px;">사업자등록증</td>
                    <td style="border: 1px solid #a2a2a2;">
                        <asp:FileUpload runat="server" ID="fuRegist" CssClass="fileUpLoad" Width="990px" Height="25px" /></td>
                    
                </tr>

                <tr>
                   
                </tr>

            </table>

          

            <div class="bottomBtn" style="margin-bottom:23px">
                <asp:Button ID="btnSave" runat="server" OnClick="btnSave_Click" OnClientClick="return fnValidation();" Text="회원가입" CssClass="mainbtn type1" Width="95" Height="30"/>
                <asp:Button ID="btnCancel" runat="server"  OnClientClick="return fnInsertCancel();" Text="취소" CssClass="mainbtn type1" Width="95" Height="30"/>

                
            </div>
        </div>

    <%--</body>--%>
</asp:Content>

