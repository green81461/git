<%@ Page Title="" Language="C#" MasterPageFile="~/Master/Login.master" AutoEventWireup="true" CodeFile="MemberCreate_A.aspx.cs" Inherits="Member_MemberCreate_A" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
 <link rel="stylesheet" href="../Content/member.css" />   
    
    
    <script type="text/javascript">
        $(document).ready(function () {
            $("#<%=hfDomain.ClientID%>").val(window.location.hostname);

            var txtId = $("#<%=txtId.ClientID%>");
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
                    return false;
                }
                //else if (txtPwdCheck.val().indexOf(txtId.val()) > -1) {
                //    checkText.text('');
                //    checkText.html("ID가 포함된 비밀번호는 사용할 수 없습니다.");
                //    return false;
                //}
                else {
                    checkText.text('');
                    checkText.html("비밀번호가 일치합니다.");
                    return false;
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
            
            //테이블 동적 생성
            $.ajax({
                url: "GetCommData.aspx",
                type: "GET",
                async: false,
                cache: false,
               // data: param, //전송될 파라미터
                dataType: "json",          
                success: function (response) {
                    
                    var asynTable = "<table  style='width:100%; height:200px; border:1px solid #a2a2a2'  >"
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

        }) 
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
                        if (value.Map_Type != 0){
                            asynTable += "<option value='" + value.Map_Channel + "_" + value.Map_Type + "'>" + value.Map_Name + "</option>"       
                        }
                    });
                    asynTable += "</select></td><td style='border:1px solid #a2a2a2' ><input type='file' id='fuFileAdd" + index + "_1_0' name='fuFileAdd" + index + "_1_0' style='width:100%; height:100%'/></td>";      
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
                txtPwd.focus()
                return false;
            }
            if (txtDeptName.val() == '') {
                alert(' 부서명을 입력해주세요.');
                txtDeptName.focus()
                return false;
            }
            if (txtPostion.val() == '') {
                alert('직책을 입력해주세요.');
                txtPostion.focus()
                return false;
            }
            if (txtEmail1.val() == '' || txtEmail2.val() == '') {
                alert('E-Mail을 입력해주세요.');
                txtEmail1.focus()
                return false;
            }
            var regeMail = /^([\w-]+(?:\.[\w-]+)*)@((?:[\w-]+\.)*\w[\w-]{0,66})\.([a-z]{2,6}(?:\.[a-z]{2})?)$/;
            if (!regeMail.test((txtEmail1.val() + '@' + txtEmail2.val()))) {
                alert("잘못된 이메일 형식입니다.");
                txtEmail1.focus();
                return false;
            }
            if (isEmpty($.trim(txtSelPhone.val()))) {
                alert('휴대전화번호를 올바르게 입력해주세요.');
                txtSelPhone.focus();
                return false;
            }
            if (isEmpty($.trim(txtTelPhone.val()))) {
                alert('유선전화번호를 올바르게 입력해주세요.');
                txtTelPhone.focus();
                return false;
            }
            if (isEmpty($.trim(txtFax.val()))) {
                alert('팩스번호를 올바르게 입력해주세요.');
                txtFax.focus();
                return false;
            }
            if (txtPwd.val() != txtPwdCheck.val()) {
                alert('비밀번호 확인이 일치하지 않습니다.');
                txtPwdCheck.focus()
                return false;
            }

            if ($('#hdIdCheckFlag').val() == '0') {
                alert('아이디 중복 확인을 해주세요.');
                return false;
            }

            var compNo = txtBusinessNum1.val() + '-' + txtBusinessNum2.val() + '-' + txtBusinessNum3.val();
            // if (fnCheckCompNo(compNo) == false) {
            //     alert('회원가입을 하실수 없습니다.\n관리자에게 문의 주시기 바랍니다. \n관리담장자 : 김민(02 - 6363 - 2174)');
            //     return false;
            //}

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
                    if ($(this)[0].files[0] != null) {
                        if ($(this)[0].files[0].size > maxFileSize) {

                            sizeExcessFlag = false
                            return false;
                        }
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
            if (!isValidFile){
                alert('제한된 첨부파일 확장자가 존재합니다.');
                return false;
            }

            if (!confirm("등록하시겠습니까?")) {
                return false;
            }
            

            return true;
        }

        //사업자번호 중복체크
        function fnCheckCompNo(compno) {

            var returnVal = true;
            var param = { CompNo: compno,  Flag: 'GetTypeACompCountByCompNo' };


            var callback = function (response) {
                if (!isEmpty(response) && parseInt(response) > 0) {
                    returnVal = false;
                }
            }
         
            JqueryAjax('Post', '../Handler/Admin/CompanyHandler.ashx', false, false, param, 'json', callback, null, null, false, '');
            return returnVal;
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

        
        function fnInsertCancel() {
             if (confirm('취소하시겠습니까?')) {
                 location.href = 'MemberJoinSelect.aspx';
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
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <div class="sub-contents-div">
       
          <div class="sub-title-div">
             <p style="font-size:30px; margin:0; font-weight:bold; text-align:center;">회원가입 </p>
        <p style="font-size:15px;  margin:10px 0 20px 0; text-align:center;">회원님을 위한 다양한 혜택이 기다리고 있습니다. </p>
                      <p style="border:1px solid #b1b1b1; padding-top:20px; padding-bottom:10px;text-align:center;"><img src="/images/MemberCreate_nam.jpg" /></p>
       <div class="sub-title-div">
            <asp:HiddenField runat="server" ID="hfDomain" />
        
           <h3 style="font-size:14px"><span><img style="margin-right:5px;" src="/images/base_impor.jpg"/></span>기본정보입력 <span style="font-size:11px; font-weight:400; padding-left:15px; color:#ee2248">*표시는 필수입력 항목이오니 반드시 입력해주세요.</span></h3> 
           
           <div class="table-div1" >
              
            <table class="member-table"  >
                <tr>
                    <td style="font-weight:bold" >
                        ＊&nbsp;&nbsp;아이디
                    </td>
                    <td>
                        <asp:TextBox ID="txtId" runat="server" CssClass="id" Width="245px" onkeypress="return preventEnter(event);"></asp:TextBox>
                         <input type="button" class="mainbtn type1" style="width:105px; vertical-align:middle; height:29px; font-size:12px" value="아이디 중복확인" onclick="fnCheckId(); return false;"/>
                         <span>＊아이디는 공백 없이 6자 이상~ 20자이하여야 합니다.</span>
                        <input type="hidden" id="hdIdCheckFlag" value="0" />
                    </td>
                </tr>
                <tr>
                    <td style="font-weight:bold">
                        ＊&nbsp;&nbsp;비밀번호
                    </td>
                    <td>
                        <asp:TextBox ID="txtPwd" runat="server" TextMode="Password" CssClass="password"  Width="245px" onkeypress="return preventEnter(event);"></asp:TextBox>
                        <span>＊영문/숫자 혼합으로 최소 6자 이상 입력하셔야 합니다.</span>
                    </td>
                </tr>
                 <tr>
                    <td style="font-weight:bold">
                        ＊&nbsp;&nbsp;비밀번호 확인
                    </td>
                    <td>
                        <asp:TextBox ID="txtPwdCheck" runat="server" TextMode="Password" CssClass="re-password" Width="245px" onkeypress="return preventEnter(event);"></asp:TextBox>
                        <label id="lbCheckText" style="color:red"></label>
                    </td>
                </tr>
                
                
                <tr><td colspan="2"><div>&nbsp;</div></td></tr>
                <tr>
                    <td style="font-weight:bold">
                        ＊&nbsp;&nbsp;담당자명
                    </td>
                    <td>
                        <asp:TextBox ID="txtChargeName" runat="server" CssClass="director" Width="245px" onkeypress="return preventEnter(event);"></asp:TextBox>
                    </td>
                </tr>
                <tr>
                    <td style="font-weight:bold">
                        ＊&nbsp;&nbsp;부서명
                    </td>
                    <td>
                        <asp:TextBox ID="txtDeptName" runat="server" CssClass="department" Width="245px" onkeypress="return preventEnter(event);"></asp:TextBox>
                    </td>
                </tr>
                <tr>
                    <td style="font-weight:bold">
                        ＊&nbsp;&nbsp;직책
                    </td>
                    <td>
                        <asp:TextBox ID="txtPostion" runat="server" CssClass="position" Width="245px" onkeypress="return preventEnter(event);"></asp:TextBox>
                    </td>
                </tr>
                <tr>
                    <td style="font-weight:bold">
                        ＊&nbsp;&nbsp;E-Mail주소
                    </td>
                    <td>
                   
                        <asp:TextBox ID="txtEmail1" runat="server" Width="100px" CssClass="email1" onkeypress="return preventEnter(event);"></asp:TextBox>&nbsp;&nbsp;@&nbsp;
                        <asp:TextBox ID="txtEmail2" runat="server" CssClass="email2" Width="120px" onkeypress="return preventEnter(event);"></asp:TextBox>
                         <asp:DropDownList ID="ddlEmail3" runat="server" CssClass="email3" Width="160px">
                            <asp:ListItem Value="direct" Text="---------직접입력---------"></asp:ListItem>
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
                    <td style="font-weight:bold">
                        ＊&nbsp;&nbsp;휴대전화번호
                    </td>
                    <td>
                        <asp:TextBox ID="txtSelPhone" runat="server" Width="127px" MaxLength="12" onkeypress="return onlyNumbers(event);" CssClass="text-input"></asp:TextBox>
                        <label style="margin-left:5px; font-weight:normal;">'-' 없이 입력해 주세요.</label>

                    </td>
                </tr>
                <tr>
                    <td style="font-weight:bold">
                        ＊&nbsp;&nbsp;유선전화번호
                    </td>
                    <td>
                        <asp:TextBox ID="txtTelPhone" runat="server" Width="127px" MaxLength="12" onkeypress="return onlyNumbers(event);" CssClass="text-input"></asp:TextBox>
                        <label style="margin-left:5px; font-weight:normal;">'-' 없이 입력해 주세요.</label>

                    </td>
                </tr>
                <tr>
                    <td style="font-weight:bold">
                        ＊&nbsp;&nbsp;Fax번호
                    </td>
                    <td>
                        <asp:TextBox ID="txtFax" runat="server" Width="127px" MaxLength="12" onkeypress="return onlyNumbers(event);" CssClass="text-input"></asp:TextBox>
                        <label style="margin-left:5px; font-weight:normal;">'-' 없이 입력해 주세요.</label>

                    </td>
                </tr>
                
            </table>
          </div>
        <h3 style="font-size:14px"><img style="margin-right:5px;" src="/images/company_nam.jpg"/>회사정보입력 <span style="font-size:11px;font-weight:400; padding-left:15px; color:#ee2248;">*표시는 필수입력 항목이오니 반드시 입력해주세요.</span></h3> 
            <div class="table-div1">
                <table class="member-table">
                <tr>
                    <td style="font-weight:bold">
                        ＊&nbsp;&nbsp;기관명
                    </td>
                    <td>
                        <asp:TextBox ID="txtOrganName" runat="server" CssClass="organization"  Width="245px" onkeypress="return preventEnter(event);"></asp:TextBox>
                    </td>
                </tr>
                <tr>
                    <td style="font-weight:bold">
                        ＊&nbsp;&nbsp;사업자번호
                    </td>
                    <td >
                        <asp:TextBox ID="txtBusinessNum1" runat="server" TextMode="Number" max="9999" oninput="return maxLengthCheck(this)" MaxLength="3" Width="70px" onkeypress="return onlyNumbers(event);" CssClass="taxId1"></asp:TextBox>&nbsp;&nbsp;-&nbsp;
                        <asp:TextBox ID="txtBusinessNum2" runat="server" TextMode="Number" max="9999" oninput="return maxLengthCheck(this)" MaxLength="2" Width="70px" onkeypress="return onlyNumbers(event);" CssClass="taxId2"></asp:TextBox>&nbsp;&nbsp;-&nbsp;
                        <asp:TextBox ID="txtBusinessNum3" runat="server" TextMode="Number" max="99999" oninput="return maxLengthCheck(this)" MaxLength="5" Width="70px" onkeypress="return onlyNumbers(event);" CssClass="taxId3"></asp:TextBox>
                         <span>＊사업자번호나 고유번호를 입력해주세요.</span>
                    </td>
                </tr>
                <tr>
                    <td style="font-weight:bold">
                        ＊&nbsp;&nbsp;대표자명
                    </td>
                    <td>
                        <asp:TextBox ID="txtRepresentativeName" runat="server" CssClass="representative"  Width="245px" onkeypress="return preventEnter(event);"></asp:TextBox>
                    </td>
                </tr>
                <tr>
                    <td rowspan="2" style="font-weight:bold">
                        ＊&nbsp;&nbsp;주소
                    </td>
                    <td>
                        <asp:TextBox ID="txtPostalCode" runat="server" ReadOnly="true"  CssClass="zipSearch" Width="145px" onkeypress="return preventEnter(event);"></asp:TextBox>
                        <asp:HiddenField ID="hfPostalCode" runat="server" />
                        <input type="button"  class="mainbtn type1" style="width:95px; vertical-align:middle; height:29px;  font-size:12px" value="우편번호 검색" onclick="openPostcode();"/>
                    </td>
                </tr>

                

                <tr>
                    <td>
                        <asp:TextBox ID="txtAddress1" runat="server" Width="245px" ReadOnly="true" CssClass="addr1" onkeypress="return preventEnter(event);"></asp:TextBox>
                        <asp:HiddenField ID="hfAddress1" runat="server" />
                        <asp:TextBox ID="txtAddress2" runat="server" Width="245px" CssClass="addr2" onkeypress="return preventEnter(event);"></asp:TextBox>
                    </td>
                </tr>


            </table>
        </div>
        <h3 style="font-size:14px"><span><img style="vertical-align:bottom;" src="/images/market_nam.jpg" /></span>마켓팅 활용 입력 <span style="font-size:11px; padding-left:15px; font-weight:400; color:#ee2248;">(선택사항)</span></h3> 
            <div class="table-div1">
                <table>
                <tr>
                    <td colspan="2">이벤트/쇼핑혜택 SMS 수신동의&nbsp;&nbsp;&nbsp; 
                        <asp:RadioButton ID="rbSMSAlllowY" runat="server" GroupName="rbSMS" Text="Y" Checked="true" />&nbsp; 
                        <asp:RadioButton ID="rbSMSAlllowN" runat="server" GroupName="rbSMS" Text="N"  />
                    </td>
                </tr>
                <tr>
                    <td colspan="2">이벤트/쇼핑혜택 이메일 수신동의&nbsp;&nbsp;
                        <asp:RadioButton ID="rbEmailAlllowY" runat="server" GroupName="rbEmail" Text="Y" Checked="true" />&nbsp; 
                        <asp:RadioButton ID="rbEmailAlllowN" runat="server" GroupName="rbEmail" Text="N"  />
                    </td>
                </tr>
                </table>
        </div>
            <p><span style="margin-right:5px;"><img src="/images/text_star_red.png" /></span><span style="margin-right:10px;color:#ee2248;font-size:18px;margin-top:50px;">문서등록</span> <span>초기 문서를 등록하시는 고객님께서는 보다 신속한 거래가 가능합니다.(청부파일 확장자는DOC, HWP, PDF, JPG로 제한되어있습니다.)</span></p>
            
             <div class="id-table-div" style="border:none;  height:auto">
                 
                 <%--동적으로 추가해야 되는 테이블이니까 지우지 말고 스크립트 //테이블 동적 생성 부분에서 CSS수정해주세요--%>
                <table id="asynTable">
                    
                </table>
               <%-- <table class="insert-docu" >
                <tr>
                    <td style="background:rgba(196, 194, 194, 0.97)">＊&nbsp;&nbsp;첨부파일</td>
                    <td><asp:DropDownList ID="DropDownList1" runat="server" Height="25px" Width="150px" style="border:none;">
                            <asp:ListItem Text="서류1" Value="02"></asp:ListItem>
                            <asp:ListItem Text="서류2" Value="033"></asp:ListItem>
                            <asp:ListItem Text="서류3" Value="032"></asp:ListItem>
                            
                           
                        </asp:DropDownList></td>
                    <td><asp:FileUpload runat="server" ID="fuRegist" CssClass="fileUpLoad" Width="680px" Height="25px"/></td>
                    <td style="background-color:#69686d"><asp:ImageButton runat="server" ID="add" src="../images/add_btn.jpg" Height="25px" alt="추가"/>
                        
                      </td>
                </tr>
                <tr>
                    <td style="background-color:#69686d; padding:0; margin:0 auto;"><asp:ImageButton runat="server" ID="ImageButton1" src="../images/delete_btn.jpg" alt="삭제"/></td>
                    <td>사업자등록증</td>
                    <td colspan="2"></td>
                    
                </tr>
                </table>--%>
            </div>
            
       
        <div class="bottomBtn">
          <asp:Button ID="btnSave" runat="server" OnClick="btnSave_Click" OnClientClick="return fnValidation();" Text="회원가입" CssClass="mainbtn type1" Width="95" Height="30"/>
                <asp:Button ID="btnCancel" runat="server"  OnClientClick="return fnInsertCancel();" Text="취소" CssClass="mainbtn type1" Width="95" Height="30"/>
    </div>  
    </div>
</asp:Content>

