<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Master/AdminMasterPage.master" AutoEventWireup="true" CodeFile="MemberCorpInfo_B.aspx.cs" Inherits="Admin_Member_MemberCorpInfo_B" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <link href="../Content/Member/member.css" rel="stylesheet" />
    <script>
        var is_sending = false;

        $(document).ready(function () {
            var tableid = "tbodyPopGubunList";
            ListCheckboxOnlyOne(tableid);
            var tableid = "tbodyPopCompList";
            ListCheckboxOnlyOne(tableid);
            var tableid = "tbodyPopAreaList";
            ListCheckboxOnlyOne(tableid);
            var tableid = "tbodyPopBusinList";
            ListCheckboxOnlyOne(tableid);
            var tableid = "tbodyPopDeptList";
            ListCheckboxOnlyOne(tableid);
            
            fnSetBillView();
            //fnSetPayTypeView();

            // enter key 방지
            $(document).on("keypress", "input", function (e) {
                if (e.keyCode == 13) {
                    return false;
                }
                else
                    return true;
            });

            $("#ckbAdminUse").on('click', function () {
                if ($(this).prop("checked")) {
                    $("#slbPayRole option:eq(0)").prop("selected", true);
                    $("#slbPayRole").prop("disabled",true);

                } else {
                    $("#slbPayRole").prop("disabled", false);
                }
            });

            $("#tabDefault").on("click",  function () {

                location.href = 'MemberCorpInfo_B.aspx?uId=' +'<%=uId %>'+'&ucode=' + ucode;
            });
            $("#tabPerson").on("click", function () {
                 location.href = 'MemberPersonalInfo_B.aspx?uId=' +'<%=uId %>' +'&ucode=' + ucode;
            });
            $("#tabHistory").on("click", function () {
                 location.href = 'MemberLogInfo_B.aspx?uId=' +'<%=uId %>'+'&ucode=' + ucode;
            });

            
            // 관리자 권한 목록 조회
            fnLoadUserAdminRoleType();

        });

        
        // 관리자 권한 목록 조회
        function fnLoadUserAdminRoleType() {

            // ajax callback 함수
            var callback = function (response) {
                
                $('#slbUserAdminRoleType').empty();
                if (!isEmpty(response)) {
                    var option = '';
                    for (var i = 0; i < response.length; i++){


                        switch (response[i].Map_Type)
                        {
                            case 1:
                                option += "<option value='N'>" + response[i].Map_Name + "</option>";
                                break;
                            case 2:
                                option += "<option value='C'>" + response[i].Map_Name + "</option>";
                                break;
                            case 3:
                                option += "<option value='G'>" + response[i].Map_Name + "</option>";
                                break;
                            case 4:
                                option += "<option value='A'>" + response[i].Map_Name + "</option>";
                                break;
                        }

                    }
                    $('#slbUserAdminRoleType').append(option);
                    $("#slbUserAdminRoleType").val('<%= useAdminRoleType %>');
                }
                return false;
            };
            
            var param = {Code:'MEMBER', Channel: 2 , Method: 'GetCommList' }; // ajax 파라미터

            JajaxSessionCheck("Post", "../../Handler/Common/CommHandler.ashx", param, "json", callback, '<%=Svid_User %>'); // 회사구분코드 생성 ajax 호출
        }

        //세금계산서 및 결제유형 정보 조회
        function fnSetBillView() {
            var gubun = $("#txtGubunCode").val();
            gubun = gubun.substring(0, 2);
            var compCode = $("#txtCompCode").val();
            var compNo = $("#hdCompNo").val();

            var callback = function (response) {

                var BTypeRole = "";

                if (!isEmpty(response)) {
                    
                    BTypeRole = response.BTypeRole;
                    $("#hdBmroCheck").val(response.BmroCheck); //자사 체크
                    $("#hdBDongsinCode").val(response.BDongshinCode); //자사체크코드
                    $("#hdSameComNoYN").val(response.SameComNO_AB_YN); //판매사=구매사 여부
                }
                
                $("#hdBTypeRole").val(BTypeRole);
                
                fnSetPayTypeView();

                return false;
            };


            var param = { Flag: 'CompanyMngtInfo_Admin', CompCode: compCode, CompNo: compNo, Gubun: gubun };
            JajaxSessionCheck('Post', '../../Handler/Admin/CompanyHandler.ashx', param, 'json', callback, '<%=Svid_User %>');
        }
        
        function fnSetPayTypeView() {

            var txtCompCode = $("#txtCompCode").val() == null ? '' : $("#txtCompCode").val();

            //결제유형 영역 활성화 여부
            //if (isEmpty(txtCompCode) || (txtCompCode.length < 5)) {
            if (isEmpty(txtCompCode)) {
                $("#trPayType").hide();
                $("#trPayTypeNone").show();

            } else {
                $("#trPayTypeNone").hide();
                $("#trPayType").show();
            }

            var payType = $("#hdBTypeRole").val();

            $("#slbPayType").val(payType);

            fnSetPayRoleView(payType);
        }
        
        //결제유형 선택 시 하위 selectbox 설정
        function fnSetPayRoleView(type) {
            $("#slbPayRole").empty();

            if (!isEmpty(type)) {
                $("#slbPayRole").prop("disabled", false);
            } else {
                $("#slbPayRole").prop("disabled", true);
            }

            var optionTag = '';

            switch (type) {
                case "A":
                    optionTag = "<option value='A1' selected='selected'>A1</option>"
                        + "<option value='T'>T</option>";
                    break;
                case "B":
                    optionTag = "<option value='B2' selected='selected'>B2</option>"
                        + "<option value='B1'>B1</option>";
                    break;
                case "C":
                    optionTag = "<option value='C2' selected='selected'>C2</option>"
                        + "<option value='C1'>C1</option>";
                    break;
                case "BC":
                    optionTag = "<option value='BC3' selected='selected'>BC3</option>"
                        + "<option value='BC2'>BC2</option>"
                        + "<option value='BC1'>BC1</option>";
                    break;
                default:
                    optionTag = "<option value='' selected='selected'>없음</option>";
                    break;
            }

            $("#slbPayRole").append(optionTag);
            $("#slbPayRole").show();

            var svidRole = $("#hdSvidRole").val();
            if (!isEmpty(svidRole)) $("#slbPayRole").val(svidRole);
        }

        /////////////////////////////////////////// [팝업:회사구분코드] 영역 //////////////////////////////////////////////////////

        //[팝업:회사구분코드] 코드생성 버튼 클릭 시
        function fnPopGubunNewCode() {
            var newGubunCode = $("#txtPopGubunCode").val();
            var newGubunName = $.trim($("#txtPopGubunNm").val());
            var newRemark = $("#txtPopGubunRemark").val();

            if (isEmpty(newGubunName)) {
                alert('회사구분명을 입력해 주세요.');
                $("#txtPopGubunNm").focus();
                return false;
            }

            // ajax callback 함수
            var callback = function (response) {
                var index = 0;
                var gubunDataVal = "데이터없음";

                $("#tbodyPopGubunList").empty();

                if (!isEmpty(response)) {
                    var socialCompCode = ""; // 새 회사구분코드

                    $.each(response, function (key, value) { //테이블 추가

                        // 새로 생성된 코드값 변수에 저장
                        if (index == 0) {
                            socialCompCode = value.NewCode;
                            $("#txtPopGubunCode").val(socialCompCode); // 생성된 코드를 텍스트박스에 넣어준다
                        }
                        
                        var newRowContent = "<tr><td style='width:20px; text-align:center'><input id='ckbGubunCheck" + index + "' type='checkbox' value='" + value.SocialCompany_Code + "'><input id='hdGubunCode" + index + "' type='hidden' value='" + value.SocialCompany_Code + "'><input id='hdGubunName" + index + "' type='hidden' value='" + value.SocialCompany_Name + "'></td>";
                        newRowContent += "<td class='txt-center'> " + value.SocialCompany_Code + " </td><td class='txt-center'>" + value.SocialCompany_Name + "</td><td class='txt-center'>" + value.Remark + "</td><td class='txt-center'>" + value.EntryDate.split("T")[0] + "</td></tr>";

                        $("#tbodyPopGubunList").append(newRowContent);
                        
                        index++;
                    });

                    if (!isEmpty(socialCompCode)) {
                        $("#txtPopGubunCode").val('');
                        $("#txtPopGubunNm").val('');
                        $("#txtPopGubunRemark").val('');

                        alert("코드가 생성되었습니다.");
                    }
                }
                else {
                    $("#tbodyPopGubunList").html("<tr><td colspan='5' class='txt-center'>데이터가 없습니다</td></tr>");
                }

                $("#tdGubunFlag").text(gubunDataVal);

                $(".popup-div-bottom").scrollTop($("#tblPopGubunList").height());
                
                return false;
            };
            
            var gubun = $("#txtGubunCode").val();
            var param = { Gubun: gubun.substring(0, 2), SocialCompName: newGubunName, Remark: newRemark, Method: 'SocialCompCodeGenerate' }; // ajax 파라미터

            JajaxSessionCheck("Post", "../../Handler/Admin/SocialCompanyHandler.ashx", param, "json", callback, '<%=Svid_User %>'); // 회사구분코드 생성 ajax 호출
        }

        //[팝업:회사구분코드] 수정 버튼 클릭 시
        function fnPopGubunModifyCode() {
            var gubunCode = $("#txtGubunCode").val();
            var popupGubunCode = $("#txtPopGubunCode").val();
            var popupGubunName = $("#txtPopGubunNm").val();
            var popupGubunRemark = $("#txtPopGubunRemark").val();

            if (isEmpty(popupGubunName)) {
                alert('회사구분명을 입력해 주세요.');
                $("#txtPopGubunNm").focus();
                return false;
            }
            
            if (gubunCode != popupGubunCode) {
                alert("수정을 요청하신 코드는 현재 사용자에게 설정된 코드값이 아닙니다.\n해당 코드를 최종 선택하신 후 다시 시도해 주시기 바랍니다.");
                return false;
            }

            // ajax callback 함수
            var callback = function (response) {
                var index = 0;

                $("#tbodyPopGubunList").empty();

                if (!isEmpty(response)) {

                    $.each(response, function (key, value) { //테이블 추가
                        var newRowContent = "<tr><td style='width:20px; text-align:center'><input id='ckbGubunCheck" + index + "' type='checkbox' value='" + value.SocialCompany_Code + "'><input id='hdGubunCode" + index + "' type='hidden' value='" + value.SocialCompany_Code + "'><input id='hdGubunName" + index + "' type='hidden' value='" + value.SocialCompany_Name + "'></td>";
                        newRowContent += "<td class='txt-center'> " + value.SocialCompany_Code + " </td><td class='txt-center'>" + value.SocialCompany_Name + "</td><td class='txt-center'>" + value.Remark + "</td><td class='txt-center'>" + value.EntryDate.split("T")[0] + "</td></tr>";

                        $("#tbodyPopGubunList").append(newRowContent);

                        index++;
                    });

                    if (index > 0) {
                        alert("수정되었습니다.");
                        
                        $("#lblGubunNm").text($("#txtPopGubunNm").val());
                    }
                }
                else {
                    $("#tbodyPopGubunList").html("<tr><td colspan='5' class='txt-center'>데이터가 없습니다</td></tr>");
                }
            };

            var param = { SocialCompCode: popupGubunCode, SocialCompName: popupGubunName, Remark: popupGubunRemark, Gubun: popupGubunCode.substring(0, 2), Method: 'SocialCompNameUpdate' }; // ajax 파라미터

            JajaxSessionCheck("Post", "../../Handler/Admin/SocialCompanyHandler.ashx", param, "json", callback, '<%=Svid_User %>'); // 회사구분 수정 ajax 호출
        }
        
        //[팝업:회사구분코드] 확인 버튼 클릭 시
        function fnPopGubunOK() {
            var gubunCode = '';
            var gubunNm = '';

            //선택한 코드와 회사구분코드명을 부모창에 뿌려줌
            $('#tbodyPopGubunList input[type="checkbox"]').each(function () {
                if ($(this).prop('checked') == true) {

                    var tdTag = $(this).parent();
                    gubunCode = $(tdTag).find("input:hidden[id^='hdGubunCode']").val();
                    gubunNm = $(tdTag).find("input:hidden[id^='hdGubunName']").val();

                    $("#txtGubunCode").val(gubunCode);
                    $("#lblGubunNm").text(gubunNm);
                }
            });

            if (isEmpty(gubunCode) || isEmpty(gubunNm)) {
                alert("목록에서 회사구분코드를 선택해 주세요.");
                return false;
            }

            fnClosePopup('companyClassifyDiv');
        }

        //[팝업:회사구분코드] 팝업창 열기
        function fnAddGubunPopOpen() {

            $("#tbodyPopGubunList").empty();
            $("#txtPopGubunCode").val('');
            $("#txtPopGubunNm").val('');
            $('#tbodyPopGubunList').empty();

            var gubun = $("#txtGubunCode").val();
            if (isEmpty(gubun)) {
                alert("오류가 발생했습니다. 브라우저창을 닫고 다시 접속해 주세요.");
                return false;
            }
            
            var callback = function (response) {

                var gubunDataVal = "데이터없음";
                var gubunCode = $("#txtGubunCode").val(); // 회사구분코드
                var gubunCodeNm = $("#lblGubunNm").text(); // 회사구분명
                $("#txtPopGubunCode").val(gubunCode);
                $("#txtPopGubunNm").val(gubunCodeNm);

                var index = 0;

                if (!isEmpty(response)) {
                    
                    $.each(response, function (key, value) { //테이블 추가

                        // 팝업창의 비고 입력창에 해당하는 코드의 비고값을 넣어줌.
                        if (gubunCode == value.SocialCompany_Code) {
                            $("#txtPopGubunRemark").val(value.Remark);
                            gubunDataVal = "데이터있음";
                        }

                        var newRowContent = "<tr><td style='width:20px; text-align:center'><input id='ckbGubunCheck" + index + " ' type='checkbox' value='" + value.SocialCompany_Code + "'><input id='hdGubunCode" + index + "' type='hidden' value='" + value.SocialCompany_Code + "'><input id='hdGubunName" + index + "' type='hidden' value='" + value.SocialCompany_Name + "'></td>";
                        newRowContent += "<td class='txt-center'> " + value.SocialCompany_Code + " </td><td class='txt-center'>" + value.SocialCompany_Name + "</td><td class='txt-center'>" + value.Remark + "</td><td class='txt-center'>" + value.EntryDate.split("T")[0] + "</td></tr>";
                        
                        $("#tbodyPopGubunList").append(newRowContent);

                        index++;
                    });
                }
                else {
                    $("#tbodyPopGubunList").html("<tr><td colspan='5' class='txt-center'>데이터가 없습니다</td></tr>");
                }

                $("#tdGubunFlag").text(gubunDataVal);

                //var e = document.getElementById('companyClassifyDiv');
                //if (e.style.display == 'block') e.style.display = 'none';
                //else e.style.display = 'block';

                fnOpenDivLayerPopup('companyClassifyDiv');
            };
            
            var param = { Gubun: gubun.substring(0,2), Method: "SocialCompanyList" };

            JajaxSessionCheck("Post", "../../Handler/Admin/SocialCompanyHandler.ashx", param, "json", callback, '<%=Svid_User %>'); // ajax 호출
        }

        /////////////////////////////////////////// [팝업:회사코드] 영역 //////////////////////////////////////////////////////

        //[팝업:회사코드] 수정 버튼 클릭 시
        function fnPopCompModifyCode() {
            var compCode = $("#txtCompCode").val();
            var popupCompCode = $("#txtPopCompCode").val();
            var popupCompName = $("#txtPopCompNm").val();
            var popupCompRemark = $("#txtPopCompRemark").val();

            if (isEmpty(popupCompName)) {
                alert('회사명을 입력해 주세요.');
                $("#txtPopCompNm").focus();
                return false;
            }
            
            if (compCode != popupCompCode) {
                alert("수정을 요청하신 코드는 현재 사용자에게 설정된 코드값이 아닙니다.\n해당 코드를 최종 선택하신 후 다시 시도해 주시기 바랍니다.");
                return false;
            }

            // ajax callback 함수
            var callback = function (response) {
                var index = 0;

                $("#tbodyPopCompList").empty();

                if (!isEmpty(response)) {

                    $.each(response, function (key, value) { //테이블 추가
                        var newRowContent = "<tr><td style='width:20px; text-align:center'><input id='ckbCompCheck" + index + "' type='checkbox' value='" + value.Company_Code + "'><input id='hdCompCode" + index + "' type='hidden' value='" + value.Company_Code + "'><input id='hdCompName" + index + "' type='hidden' value='" + value.Company_Name + "'></td>";
                        newRowContent += "<td class='txt-center'> " + value.Company_Code + " </td><td class='txt-center'>" + value.Company_Name + "</td><td class='txt-center'>" + value.Remark + "</td><td class='txt-center'>" + value.EntryDate.split("T")[0] + "</td></tr>";

                        $("#tbodyPopCompList").append(newRowContent);

                        index++;
                    });

                    if (index > 0) {
                        alert("수정되었습니다.");

                        $("#lblCompNm").text($("#txtPopCompNm").val());
                    }
                }
                else {
                    $("#tbodyPopCompList").html("<tr><td colspan='5' class='txt-center'>데이터가 없습니다</td></tr>");
                }
            };

            var companyNo = $("#hdCompNo").val();
            var param = { CompanyCode: popupCompCode, CompanyName: popupCompName, CompanyNo: companyNo, Gubun: 'BU', Remark: popupCompRemark, Flag: 'Update' };

            var beforeSend = function () { is_sending = true; }
            var complete = function () { is_sending = false; }
            if (is_sending) return false;

            JqueryAjax("Post", "../../Handler/Admin/CompanyHandler.ashx", true, false, param, "json", callback, beforeSend, complete, true, '<%=Svid_User%>');
        }

        //[팝업:회사코드] 코드생성 버튼 클릭 시
        function fnPopCompNewCode() {
            var newCompCode = $("#txtPopCompCode").val();
            var newCompName = $.trim($("#txtPopCompNm").val());
            var newRemark = $("#txtPopCompRemark").val();

            if (isEmpty(newCompName)) {
                alert("회사명을 입력해 주세요.");
                $("#txtPopCompNm").focus();
                return false;
            }

            // ajax callback 함수
            var callback = function (response) {
                var index = 0;
                var compDataVal = "데이터없음";

                $("#tbodyPopCompList").empty();

                if (!isEmpty(response)) {
                    var compCode = ""; // 새 회사코드

                    $.each(response, function (key, value) { //테이블 추가

                        // 새로 생성된 코드값 변수에 저장
                        if (index == 0) {
                            compCode = value.NewCode;
                            $("#txtPopCompCode").val(compCode); // 생성된 코드를 텍스트박스에 넣어준다
                        }

                        var newRowContent = "<tr><td style='width:20px; text-align:center'><input id='ckbCompCheck" + index + "' type='checkbox' value='" + value.Company_Code + "'><input id='hdCompCode" + index + "' type='hidden' value='" + value.Company_Code + "'><input id='hdCompName" + index + "' type='hidden' value='" + value.Company_Name + "'></td>";
                        newRowContent += "<td class='txt-center'> " + value.Company_Code + " </td><td class='txt-center'>" + value.Company_Name + "</td><td class='txt-center'>" + value.Remark + "</td><td class='txt-center'>" + value.EntryDate.split("T")[0] + "</td></tr>";

                        $("#tbodyPopCompList").append(newRowContent);

                        index++;
                    });

                    if (!isEmpty(compCode)) {
                        $("#txtPopCompCode").val('');
                        $("#txtPopCompNm").val('');
                        $("#txtPopCompRemark").val('');

                        alert("코드가 생성되었습니다.");
                    }
                }
                else {
                    $("#tbodyPopCompList").html("<tr><td colspan='5' class='txt-center'>데이터가 없습니다</td></tr>");
                }

                $("#tdCompFlag").text(compDataVal);
                $(".popup-div-bottom").scrollTop($("#tblPopCompList").height());

                return false;
            };

            var companyNo = $("#hdCompNo").val();
            var param = { CompanyName: newCompName, CompanyNo: companyNo, Gubun: 'BU', Remark: newRemark, Flag: 'Create' }; // ajax 파라미터

            JajaxSessionCheck("Post", "../../Handler/Admin/CompanyHandler.ashx", param, "json", callback, '<%=Svid_User %>');
        }

        //[팝업:회사코드] 확인 버튼 클릭 시
        function fnPopCompOK() {
            var compCode = '';
            var compNm = '';

            //선택한 코드와 회사코드명을 부모창에 뿌려줌
            $('#tbodyPopCompList input[type="checkbox"]').each(function () {
                if ($(this).prop('checked') == true) {

                    var tdTag = $(this).parent();
                    compCode = $(tdTag).find("input:hidden[id^='hdCompCode']").val();
                    compNm = $(tdTag).find("input:hidden[id^='hdCompName']").val();

                    $("#txtCompCode").val(compCode);
                    $("#lblCompNm").text(compNm);
                }
            });

            if (isEmpty(compCode) || isEmpty(compNm)) {
                alert("목록에서 회사코드를 선택해 주세요.");
                return false;
            }

            $("#txtAreaCode").val('');
            $("#lblAreaNm").text('');
            $("#txtBusinCode").val('');
            $("#lblBusinNm").text('');
            $("#txtDeptCode").val('');
            $("#lblDeptNm").text('');

            fnSetBillView();
            //fnSetPayTypeView();

            fnClosePopup('companyCodeDiv');
        }

        //[팝업:회사코드] 팝업창 열기
        function fnAddCompPopOpen() {
            //var gubun = $("#txtGubunCode").val() == null ? '' : $("#txtGubunCode").val();
            
            if (isEmpty($("#txtGubunCode").val()) || ($("#txtGubunCode").val().length < 5)) {
            //if (isEmpty(gubun)) {
                alert("회사구분코드를 선택해 주세요.");
                return false;
            }
            
            fnGetCompanyList();
            fnOpenDivLayerPopup('companyCodeDiv');
            //var e = document.getElementById('companyCodeDiv');
            //if (e.style.display == 'block') e.style.display = 'none';
            //else e.style.display = 'block';
            
        }

        function fnGetCompanyList() {
            var index = 0;
            $("#txtPopCompNm").val('');
            $("#txtPopCompCode").val('');
            $("#txtPopCompRemark").val('');
            $('#tbodyPopCompList').empty(); //테이블 클리어

            var companyNo = $("#hdCompNo").val();

            var callback = function (response) {

                var compDataVal = "데이터없음";
                var compNm = $("#lblCompNm").text(); // 회사명
                var compCode = $("#txtCompCode").val(); // 회사코드

                $("#txtPopCompNm").val(compNm);
                $("#txtPopCompCode").val(compCode);

                if (!isEmpty(response)) {

                    $.each(response, function (key, value) { //테이블 추가

                        // 모달창의 비고 입력창에 해당하는 코드의 비고값을 넣어줌.
                        if (compCode == value.Company_Code) {
                            var remark = value.Remark;
                            $("#txtPopCompRemark").val(remark);

                            if (!isEmpty(remark)) {
                                if ((remark.length === 10) && (remark.match("CX") == "CX")) {
                                    $("#txtPopCompRemark").prop("readonly", true);
                                    //$("#btnNoneComNoCode").css("display", "none");
                                }
                            }

                            compDataVal = "데이터있음";
                        }

                        var newRowContent = "<tr><td style='width:20px; text-align:center'><input id='ckbCompCheck" + index + "' type='checkbox' value='" + value.Company_Code + "'><input id='hdCompCode" + index + "' type='hidden' value='" + value.Company_Code + "'><input id='hdCompName" + index + "' type='hidden' value='" + value.Company_Name + "'></td>";
                        newRowContent += "<td class='txt-center'> " + value.Company_Code + " </td><td class='txt-center'>" + value.Company_Name + "</td><td class='txt-center'>" + value.Remark + "</td><td class='txt-center'>" + value.EntryDate.split("T")[0] + "</td></tr>";

                        $("#tbodyPopCompList").append(newRowContent);
                        index++;
                    });
                }
                else {
                    $('#tbodyPopCompList').html("<tr><td colspan='5' class='txt-center'>데이터가 없습니다</td></tr>");
                }

                $("#tdCompFlag").text(compDataVal);
                
                //회사코드 비고에 사업자번호없음코드값 있는 경우 backspace key 방지
                $("#txtPopCompRemark").keydown(function (e) {
                    if ($('#txtPopCompRemark').prop("readonly")) {
                        if (event.keyCode === 8) {
                            return false;
                        }
                    }
                });

                //var remark = $("#txtPopCompRemark").val();
                //if (!isEmpty(remark)) {
                //    console.log("111111111111111");
                //    console.log("remark.length : " + remark.length);
                //    console.log("remark.match('CX') : " + remark.match("CX"));
                //    if ((remark.length === 10) && (remark.match("CX") == "CX")) {
                //        console.log("22222222222222");
                //        $("#txtPopCompRemark").prop("readonly", true);
                //        $("#btnNoneComNoCode").css("display", "none");
                //    }
                //}
            };

            var param = { CompanyNo: companyNo, Gubun: 'BU', Flag: 'ListByGubunCompNo' };

            JajaxSessionCheck("Post", "../../Handler/Admin/CompanyHandler.ashx", param, "json", callback, '<%=Svid_User %>');
        }

        
        //사업자번호없음코드생성
        function fnGetNoneComNoCode() {
            var txtPopCompRemark = $("#txtPopCompRemark").val();
            var confirmVal = confirm("[경고]\n\n코드 생성 시 해당하는 회사코드의 정보에서 기존 사업자번호와 비고가 생성되는 코드로 대체되어 '자동 적용' 됩니다.\n계속 진행하시겠습니까?");

            if (confirmVal) {
                var callback = function (response) {

                    var resultVal = '';
                    var newCode = '';

                    if (!isEmpty(response)) {
                        resultVal = response.result;
                        newCode = response.newCode
                    }

                    if (resultVal == "SUCCESS") {
                        $("#txtPopCompRemark").val(newCode);
                        $("#txtPopCompRemark").prop("readonly", true);
                        //$("#btnNoneComNoCode").css("display", "none");

                        alert("성공적으로 코드가 생성되어 사업자번호가 변경되었습니다.");

                        //fnGetCompanyList();
                        document.location.reload();

                    } else if (resultVal == "OVER") {
                        $("#txtPopCompRemark").prop("readonly", false);
                        $("#btnNoneComNoCode").css("display", "");

                        alert("더이상 코드를 생성할 수 없습니다. 개발자에게 문의하시기 바랍니다.");

                    } else {
                        $("#txtPopCompRemark").prop("readonly", false);
                        $("#btnNoneComNoCode").css("display", "");

                        alert("코드가 생성에 실패하였습니다. 개발자에게 문의하시기 바랍니다.");
                    }

                    return false;
                };

                var comCode = $("#txtPopCompCode").val();
                var param = { Flag: "GetLastNoneComNoCode", ComCode: comCode };

                var beforeSend = function () {
                    is_sending = true;
                }
                var complete = function () {
                    is_sending = false;
                }
                if (is_sending) return false;

                var sUser = '<%=Svid_User%>';
                JqueryAjax("Post", "../../Handler/Admin/CompanyHandler.ashx", true, false, param, "json", callback, beforeSend, complete, true, sUser);
            }

            return false;
        }

        /////////////////////////////////////////// [팝업:사업장코드] 영역 //////////////////////////////////////////////////////

        //[팝업:사업장코드] 수정 버튼 클릭 시
        function fnPopAreaModifyCode() {

            var compCode = $("#txtCompCode").val();
            var areaCode = $("#txtAreaCode").val();
            var popupAreaCode = $("#txtPopAreaCode").val();
            var popupAreaName = $("#txtPopAreaNm").val();
            var popupAreaRemark = $("#txtPopAreaRemark").val();

            if (isEmpty(popupAreaName)) {
                alert('사업장명을 입력해 주세요.');
                $("#txtPopAreaNm").focus();
                return false;
            }

            if (areaCode != popupAreaCode) {
                alert("수정을 요청하신 코드는 현재 사용자에게 설정된 코드값이 아닙니다.\n해당 코드를 최종 선택하신 후 다시 시도해 주시기 바랍니다.");
                return false;
            }

            // ajax callback 함수
            var callback = function (response) {
                var index = 0;

                $("#tbodyPopAreaList").empty();

                if (!isEmpty(response)) {

                    $.each(response, function (key, value) { //테이블 추가
                        var newRowContent = "<tr><td style='width:20px; text-align:center'><input id='ckbAreaCheck" + index + "' type='checkbox' value='" + value.CompanyArea_Code + "'><input id='hdAreaCode" + index + "' type='hidden' value='" + value.CompanyArea_Code + "'><input id='hdAreaName" + index + "' type='hidden' value='" + value.CompanyArea_Name + "'></td>";
                        newRowContent += "<td class='txt-center'> " + value.CompanyArea_Code + " </td><td class='txt-center'>" + value.CompanyArea_Name + "</td><td class='txt-center'>" + value.Remark + "</td><td class='txt-center'>" + value.EntryDate.split("T")[0] + "</td></tr>";

                        $("#tbodyPopAreaList").append(newRowContent);

                        index++;
                    });

                    if (index > 0) {
                        alert("수정되었습니다.");

                        $("#lblAreaNm").text($("#txtPopAreaNm").val());
                    }
                }
                else {
                    $('#tbodyPopAreaList').html("<tr><td colspan='5' class='txt-center'>데이터가 없습니다</td></tr>");
                }
            };
            
            var param = { CompanyCode: compCode, AreaCode: popupAreaCode, AreaName: popupAreaName, Remark: popupAreaRemark, Flag: 'Update' };
            JajaxSessionCheck("Post", "../../Handler/Admin/CompanyAreaHandler.ashx", param, "json", callback, '<%=Svid_User %>');
        }

        //[팝업:사업장코드] 코드생성 버튼 클릭 시
        function fnPopAreaNewCode() {
            var newAreaName = $.trim($("#txtPopAreaNm").val());
            var newRemark = $("#txtPopAreaRemark").val();

            if (isEmpty(newAreaName)) {
                alert("사업장명을 입력해 주세요.");
                $("#txtPopAreaNm").focus();
                return false;
            }

            // ajax callback 함수
            var callback = function (response) {
                var index = 0;
                var areaDataVal = "데이터없음";

                $("#tbodyPopAreaList").empty();

                if (!isEmpty(response)) {
                    var areaCode = ""; // 새 코드

                    $.each(response, function (key, value) { //테이블 추가

                        // 새로 생성된 코드값 변수에 저장
                        if (index == 0) {
                            areaCode = value.NewCode;
                            $("#txtPopAreaCode").val(areaCode); // 생성된 코드를 텍스트박스에 넣어준다
                        }

                        var newRowContent = "<tr><td style='width:20px; text-align:center'><input id='ckbAreaCheck" + index + "' type='checkbox' value='" + value.CompanyArea_Code + "'><input id='hdAreaCode" + index + "' type='hidden' value='" + value.CompanyArea_Code + "'><input id='hdAreaName" + index + "' type='hidden' value='" + value.CompanyArea_Name + "'></td>";
                        newRowContent += "<td class='txt-center'> " + value.CompanyArea_Code + " </td><td class='txt-center'>" + value.CompanyArea_Name + "</td><td class='txt-center'>" + value.Remark + "</td><td class='txt-center'>" + value.EntryDate.split("T")[0] + "</td></tr>";

                        $("#tbodyPopAreaList").append(newRowContent);

                        index++;
                    });

                    if (!isEmpty(areaCode)) {
                        $("#txtPopAreaCode").val('');
                        $("#txtPopAreaNm").val('');
                        $("#txtPopAreaRemark").val('');

                        alert("코드가 생성되었습니다.");
                    }
                }
                else {
                    $('#tbodyPopAreaList').html("<tr><td colspan='5' class='txt-center'>데이터가 없습니다</td></tr>");
                }

                $("#tdAreaFlag").text(areaDataVal);
                $(".popup-div-bottom").scrollTop($("#tblPopAreaList").height());

                return false;
            };

            var selectCompCode = $("#txtCompCode").val();
            
            var param = { CompanyCode: selectCompCode, AreaName: newAreaName, Remark: newRemark, Flag: 'Create' }; // ajax 파라미터

            JajaxSessionCheck("Post", "../../Handler/Admin/CompanyAreaHandler.ashx", param, "json", callback, '<%=Svid_User %>');
        }

        //[팝업:사업장코드] 확인 버튼 클릭 시
        function fnPopAreaOK() {
            var areaCode = '';
            var areaNm = '';

            //선택한 코드와 사업장명을 부모창에 뿌려줌
            $('#tbodyPopAreaList input[type="checkbox"]').each(function () {
                if ($(this).prop('checked') == true) {

                    var tdTag = $(this).parent();
                    areaCode = $(tdTag).find("input:hidden[id^='hdAreaCode']").val();
                    areaNm = $(tdTag).find("input:hidden[id^='hdAreaName']").val();

                    $("#txtAreaCode").val(areaCode);
                    $("#lblAreaNm").text(areaNm);
                }
            });

            if (isEmpty(areaCode) || isEmpty(areaNm)) {
                alert("목록에서 사업장코드를 선택해 주세요.");
                return false;
            }

            $("#txtBusinCode").val('');
            $("#lblBusinNm").text('');
            $("#txtDeptCode").val('');
            $("#lblDeptNm").text('');
            
            fnClosePopup('workplaceCodeDiv');
        }

        //[팝업:사업장코드] 팝업창 열기
        function fnAddAreaPopOpen() {

            if (isEmpty($("#txtCompCode").val())) {
                alert('회사코드를 선택해 주세요');
                return false;
            }

            $("#txtPopAreaCode").val('');
            $("#txtPopAreaNm").val('');
            $("#txtPopAreaRemark").val('');
            $('#tbodyPopAreaList').empty();

            // ajax callback 함수
            var callback = function (response) {
                var index = 0;
                var areaDataVal = "데이터없음";
                var areaNm = $("#lblAreaNm").text(); // 사업장명
                var areaCode = $("#txtAreaCode").val(); // 사업장코드

                $("#txtPopAreaNm").val(areaNm);
                $("#txtPopAreaCode").val(areaCode);

                if (!isEmpty(response)) {
                    
                    $.each(response, function (key, value) { //테이블 추가

                        // 모달창의 비고 입력창에 해당하는 코드의 비고값을 넣어줌.
                        if (areaCode == value.CompanyArea_Code) {
                            $("#txtPopAreaRemark").val(value.Remark);
                            areaDataVal = "데이터있음";
                        }

                        var newRowContent = "<tr><td style='width:20px; text-align:center'><input id='ckbAreaCheck" + index + "' type='checkbox' value='" + value.CompanyArea_Code + "'><input id='hdAreaCode" + index + "' type='hidden' value='" + value.CompanyArea_Code + "'><input id='hdAreaName" + index + "' type='hidden' value='" + value.CompanyArea_Name + "'></td>";
                        newRowContent += "<td class='txt-center'> " + value.CompanyArea_Code + " </td><td class='txt-center'>" + value.CompanyArea_Name + "</td><td class='txt-center'>" + value.Remark + "</td><td class='txt-center'>" + value.EntryDate.split("T")[0] + "</td></tr>";

                        $("#tbodyPopAreaList").append(newRowContent);

                        index++;
                    });
                }
                else {
                    $('#tbodyPopAreaList').html("<tr><td colspan='5' class='txt-center'>데이터가 없습니다</td></tr>");
                }

                $("#tdAreaFlag").text(areaDataVal);

                //var e = document.getElementById('workplaceCodeDiv');
                //if (e.style.display == 'block') e.style.display = 'none';
                //else e.style.display = 'block';

                fnOpenDivLayerPopup('workplaceCodeDiv');
            };

            var param = { CompanyCode: $("#txtCompCode").val(), Flag: "List" }; // ajax 파라미터

            JajaxSessionCheck("Post", "../../Handler/Admin/CompanyAreaHandler.ashx", param, "json", callback, '<%=Svid_User %>');
        }

        /////////////////////////////////////////// [팝업:사업부코드] 영역 //////////////////////////////////////////////////////

        //[팝업:사업부코드] 수정 버튼 클릭 시
        function fnPopBusinessModifyCode() {

            var compCode = $("#txtCompCode").val();
            var areaCode = $("#txtAreaCode").val();
            var businCode = $("#txtBusinCode").val();
            var popupBusinCode = $("#txtPopBusinCode").val();
            var popupBusinName = $("#txtPopBusinNm").val();
            var popupBusinRemark = $("#txtPopBusinRemark").val();

            if (isEmpty(popupBusinName)) {
                alert('사업부명을 입력해 주세요.');
                $("#txtPopBusinNm").focus();
                return false;
            }

            if (businCode != popupBusinCode) {
                alert("수정을 요청하신 코드는 현재 사용자에게 설정된 코드값이 아닙니다.\n해당 코드를 최종 선택하신 후 다시 시도해 주시기 바랍니다.");
                return false;
            }

            // ajax callback 함수
            var callback = function (response) {
                var index = 0;

                $("#tbodyPopBusinList").empty();

                if (!isEmpty(response)) {

                    $.each(response, function (key, value) { //테이블 추가
                        var newRowContent = "<tr><td style='width:20px; text-align:center'><input id='ckbBusinCheck" + index + "' type='checkbox' value='" + value.CompBusinessDept_Code + "'><input id='hdBusinCode" + index + "' type='hidden' value='" + value.CompBusinessDept_Code + "'><input id='hdBusinName" + index + "' type='hidden' value='" + value.CompBusinessDept_Name + "'></td>";
                        newRowContent += "<td class='txt-center'> " + value.CompBusinessDept_Code + " </td><td class='txt-center'>" + value.CompBusinessDept_Name + "</td><td class='txt-center'>" + value.Remark + "</td><td class='txt-center'>" + value.EntryDate.split("T")[0] + "</td></tr>";

                        $("#tbodyPopBusinList").append(newRowContent);

                        index++;
                    });

                    if (index > 0) {
                        alert("수정되었습니다.");

                        $("#lblBusinNm").text($("#txtPopBusinNm").val());
                    }
                }
                else {
                    $('#tbodyPopBusinList').html("<tr><td colspan='5' class='txt-center'>데이터가 없습니다</td></tr>");
                }
            };
            
            var param = { CompanyCode: compCode, AreaCode: areaCode, BusinessCode: popupBusinCode, BusinessName: popupBusinName, Remark: popupBusinRemark, Flag: 'Update' };
            JajaxSessionCheck("Post", "../../Handler/Admin/CompBusinessHandler.ashx", param, "json", callback, '<%=Svid_User %>');
        }

        //[팝업:사업부코드] 코드생성 버튼 클릭 시
        function fnPopBusinessNewCode() {
            var newBusinName = $.trim($("#txtPopBusinNm").val());
            var newRemark = $("#txtPopBusinRemark").val();

            if (isEmpty(newBusinName)) {
                alert("사업장명을 입력해 주세요.");
                $("#txtPopBusinNm").focus();
                return false;
            }

            // ajax callback 함수
            var callback = function (response) {
                var index = 0;
                var businDataVal = "데이터없음";

                $("#tbodyPopBusinList").empty();

                if (!isEmpty(response)) {
                    var businCode = ""; // 새 코드

                    $.each(response, function (key, value) { //테이블 추가

                        // 새로 생성된 코드값 변수에 저장
                        if (index == 0) {
                            businCode = value.NewCode;
                            $("#txtPopBusinCode").val(businCode); // 생성된 코드를 텍스트박스에 넣어준다
                        }

                        var newRowContent = "<tr><td style='width:20px; text-align:center'><input id='ckbBusinCheck" + index + "' type='checkbox' value='" + value.CompBusinessDept_Code + "'><input id='hdBusinCode" + index + "' type='hidden' value='" + value.CompBusinessDept_Code + "'><input id='hdBusinName" + index + "' type='hidden' value='" + value.CompBusinessDept_Name + "'></td>";
                        newRowContent += "<td class='txt-center'> " + value.CompBusinessDept_Code + " </td><td class='txt-center'>" + value.CompBusinessDept_Name + "</td><td class='txt-center'>" + value.Remark + "</td><td class='txt-center'>" + value.EntryDate.split("T")[0] + "</td></tr>";

                        $("#tbodyPopBusinList").append(newRowContent);

                        index++;
                    });

                    if (!isEmpty(businCode)) {
                        $("#txtPopBusinCode").val('');
                        $("#txtPopBusinNm").val('');
                        $("#txtPopBusinRemark").val('');

                        alert("코드가 생성되었습니다.");
                    }
                }
                else {
                    $('#tbodyPopBusinList').html("<tr><td colspan='5' class='txt-center'>데이터가 없습니다</td></tr>");
                }

                $("#tdBusinFlag").text(businDataVal);
                $(".popup-div-bottom").scrollTop($("#tblPopBusinList").height());

                return false;
            };

            var selectCompCode = $("#txtCompCode").val();
            var selectAreaCode = $("#txtAreaCode").val();
            var param = { CompanyCode: selectCompCode, AreaCode: selectAreaCode, BusinessName: newBusinName, Remark: newRemark, Flag: 'Create' };
            JajaxSessionCheck("Post", "../../Handler/Admin/CompBusinessHandler.ashx", param, "json", callback, '<%=Svid_User %>');
        }

        //[팝업:사업부코드] 확인 버튼 클릭 시
        function fnPopBusinessOK() {
            var businCode = '';
            var businNm = '';

            //선택한 코드와 사업부명을 부모창에 뿌려줌
            $('#tbodyPopBusinList input[type="checkbox"]').each(function () {
                if ($(this).prop('checked') == true) {

                    var tdTag = $(this).parent();
                    businCode = $(tdTag).find("input:hidden[id^='hdBusinCode']").val();
                    businNm = $(tdTag).find("input:hidden[id^='hdBusinName']").val();

                    $("#txtBusinCode").val(businCode);
                    $("#lblBusinNm").text(businNm);
                }
            });

            if (isEmpty(businCode) || isEmpty(businNm)) {
                alert("목록에서 사업부코드를 선택해 주세요.");
                return false;
            }

            $("#txtDeptCode").val('');
            $("#lblDeptNm").text('');

            fnClosePopup('divisionCodeDiv');
        }

        //사업부코드 팝업창
        function fnAddBusinessPopOpen() {

            if (isEmpty($("#txtAreaCode").val())) {
                alert('사업장코드를 선택해 주세요');
                return false;
            }

            $("#txtPopBusinCode").val('');
            $("#txtPopBusinNm").val('');
            $("#txtPopBusinRemark").val('');
            $('#tbodyPopBusinList').empty();

            // ajax callback 함수
            var callback = function (response) {
                var index = 0;
                var businDataVal = "데이터없음";
                var businNm = $("#lblBusinNm").text();
                var businCode = $("#txtBusinCode").val();

                $("#txtPopBusinNm").val(businNm);
                $("#txtPopBusinCode").val(businCode);

                if (!isEmpty(response)) {
                    
                    $.each(response, function (key, value) { //테이블 추가

                        // 모달창의 비고 입력창에 해당하는 코드의 비고값을 넣어줌.
                        if (businCode == value.CompBusinessDept_Code) {
                            $("#txtPopBusinRemark").val(value.Remark);
                            businDataVal = "데이터있음";
                        }

                        var newRowContent = "<tr><td style='width:20px; text-align:center'><input id='ckbBusinCheck" + index + "' type='checkbox' value='" + value.CompBusinessDept_Code + "'><input id='hdBusinCode" + index + "' type='hidden' value='" + value.CompBusinessDept_Code + "'><input id='hdBusinName" + index + "' type='hidden' value='" + value.CompBusinessDept_Name + "'></td>";
                        newRowContent += "<td class='txt-center'> " + value.CompBusinessDept_Code + " </td><td class='txt-center'>" + value.CompBusinessDept_Name + "</td><td class='txt-center'>" + value.Remark + "</td><td class='txt-center'>" + value.EntryDate.split("T")[0] + "</td></tr>";

                        $("#tbodyPopBusinList").append(newRowContent);

                        index++;
                    });
                }
                else {
                    $('#tbodyPopBusinList').html("<tr><td colspan='5' class='txt-center'>데이터가 없습니다</td></tr>");
                }

                $("#tdBusinFlag").text(businDataVal);

                //var e = document.getElementById('divisionCodeDiv');
                //if (e.style.display == 'block') e.style.display = 'none';
                //else e.style.display = 'block';

                fnOpenDivLayerPopup('divisionCodeDiv');
            };
            
            var param = { CompanyCode: $("#txtCompCode").val(), AreaCode: $("#txtAreaCode").val(), Flag: "List" };
            JajaxSessionCheck("Post", "../../Handler/Admin/CompBusinessHandler.ashx", param, "json", callback, '<%=Svid_User %>');
        }

        /////////////////////////////////////////// [팝업:부서코드] 영역 //////////////////////////////////////////////////////

        //[팝업:부서코드] 수정 버튼 클릭 시
        function fnPopDeptModifyCode() {

            var compCode = $("#txtCompCode").val();
            var areaCode = $("#txtAreaCode").val();
            var businCode = $("#txtBusinCode").val();
            var deptCode = $("#txtDeptCode").val();
            var popupDeptCode = $("#txtPopDeptCode").val();
            var popupDeptName = $("#txtPopDeptNm").val();
            var popupDeptRemark = $("#txtPopDeptRemark").val();

            if (isEmpty(popupDeptName)) {
                alert('부서명을 입력해 주세요.');
                $("#txtPopDeptNm").focus();
                return false;
            }

            if (deptCode != popupDeptCode) {
                alert("수정을 요청하신 코드는 현재 사용자에게 설정된 코드값이 아닙니다.\n해당 코드를 최종 선택하신 후 다시 시도해 주시기 바랍니다.");
                return false;
            }

            // ajax callback 함수
            var callback = function (response) {
                var index = 0;

                $("#tbodyPopDeptList").empty();

                if (!isEmpty(response)) {

                    $.each(response, function (key, value) { //테이블 추가
                        var newRowContent = "<tr><td style='width:20px; text-align:center'><input id='ckbDeptCheck" + index + "' type='checkbox' value='" + value.CompanyDept_Code + "'><input id='hdDeptCode" + index + "' type='hidden' value='" + value.CompanyDept_Code + "'><input id='hdDeptName" + index + "' type='hidden' value='" + value.CompanyDept_Name + "'></td>";
                        newRowContent += "<td class='txt-center'> " + value.CompanyDept_Code + " </td><td class='txt-center'>" + value.CompanyDept_Name + "</td><td class='txt-center'>" + value.Remark + "</td><td class='txt-center'>" + value.EntryDate.split("T")[0] + "</td></tr>";

                        $("#tbodyPopDeptList").append(newRowContent);

                        index++;
                    });

                    if (index > 0) {
                        alert("수정되었습니다.");

                        $("#lblDeptNm").text($("#txtPopDeptNm").val());
                    }
                }
                else {
                    $('#tbodyPopDeptList').html("<tr><td colspan='5' class='txt-center'>데이터가 없습니다</td></tr>");
                }
            };
            
            var param = { CompanyCode: compCode, AreaCode: areaCode, BusinessCode: businCode, DeptCode: popupDeptCode, DeptName: popupDeptName, Remark: popupDeptRemark, Flag: "Update" };
            JajaxSessionCheck("Post", "../../Handler/Admin/CompanyDeptHandler.ashx", param, "json", callback, '<%=Svid_User %>');
        }

        //[팝업:부서코드] 코드생성 버튼 클릭 시
        function fnPopDeptNewCode() {
            var newDeptName = $.trim($("#txtPopDeptNm").val());
            var newRemark = $("#txtPopDeptRemark").val();

            if (isEmpty(newDeptName)) {
                alert("부서명을 입력해 주세요.");
                $("#txtPopDeptNm").focus();
                return false;
            }

            // ajax callback 함수
            var callback = function (response) {
                var index = 0;
                var deptDataVal = "데이터없음";

                $("#tbodyPopDeptList").empty();

                if (!isEmpty(response)) {
                    var deptCode = ""; // 새 코드

                    $.each(response, function (key, value) { //테이블 추가

                        // 새로 생성된 코드값 변수에 저장
                        if (index == 0) {
                            deptCode = value.NewCode;
                            $("#txtPopDeptCode").val(deptCode); // 생성된 코드를 텍스트박스에 넣어준다
                        }

                        var newRowContent = "<tr><td style='width:20px; text-align:center'><input id='ckbDeptCheck" + index + "' type='checkbox' value='" + value.CompanyDept_Code + "'><input id='hdDeptCode" + index + "' type='hidden' value='" + value.CompanyDept_Code + "'><input id='hdDeptName" + index + "' type='hidden' value='" + value.CompanyDept_Name + "'></td>";
                        newRowContent += "<td class='txt-center'> " + value.CompanyDept_Code + " </td><td class='txt-center'>" + value.CompanyDept_Name + "</td><td class='txt-center'>" + value.Remark + "</td><td class='txt-center'>" + value.EntryDate.split("T")[0] + "</td></tr>";

                        $("#tbodyPopDeptList").append(newRowContent);

                        index++;
                    });

                    if (!isEmpty(deptCode)) {
                        $("#txtPopDeptCode").val('');
                        $("#txtPopDeptNm").val('');
                        $("#txtPopDeptRemark").val('');

                        alert("코드가 생성되었습니다.");
                    }
                }
                else {
                    $('#tbodyPopDeptList').html("<tr><td colspan='5' class='txt-center'>데이터가 없습니다</td></tr>");
                }

                $("#tdDeptFlag").text(deptDataVal);
                $(".popup-div-bottom").scrollTop($("#tblPopDeptList").height());

                return false;
            };

            var selectCompCode = $("#txtCompCode").val();
            var selectAreaCode = $("#txtAreaCode").val();
            var selectBusinCode = $("#txtBusinCode").val();

            var param = { CompanyCode: selectCompCode, AreaCode: selectAreaCode, BusinessCode: selectBusinCode, DeptName: newDeptName, Remark: newRemark, Flag: "Create" };
            JajaxSessionCheck("Post", "../../Handler/Admin/CompanyDeptHandler.ashx", param, "json", callback, '<%=Svid_User %>');
        }

        //[팝업:부서코드] 확인 버튼 클릭 시
        function fnPopDeptOK() {
            var deptCode = '';
            var deptNm = '';

            //선택한 코드와 부서명을 부모창에 뿌려줌
            $('#tbodyPopDeptList input[type="checkbox"]').each(function () {
                if ($(this).prop('checked') == true) {

                    var tdTag = $(this).parent();
                    deptCode = $(tdTag).find("input:hidden[id^='hdDeptCode']").val();
                    deptNm = $(tdTag).find("input:hidden[id^='hdDeptName']").val();

                    $("#txtDeptCode").val(deptCode);
                    $("#lblDeptNm").text(deptNm);
                }
            });

            if (isEmpty(deptCode) || isEmpty(deptNm)) {
                alert("목록에서 부서코드를 선택해 주세요.");
                return false;
            }

            fnClosePopup('deptCodeDiv');
        }

        //부서코드 팝업창
        function fnAddDeptPopOpen() {

            if (isEmpty($("#txtBusinCode").val())) {
                alert('사업부코드를 선택해 주세요');
                return false;
            }

            $("#txtPopDeptCode").val('');
            $("#txtPopDeptNm").val('');
            $("#txtPopDeptRemark").val('');
            $('#tbodyPopDeptList').empty();

            // ajax callback 함수
            var callback = function (response) {
                var index = 0;
                var deptDataVal = "데이터없음";
                var deptNm = $("#lblDeptNm").text();
                var deptCode = $("#txtDeptCode").val();

                $("#txtPopDeptNm").val(deptNm);
                $("#txtPopDeptCode").val(deptCode);

                if (!isEmpty(response)) {
                    
                    $.each(response, function (key, value) { //테이블 추가

                        // 모달창의 비고 입력창에 해당하는 코드의 비고값을 넣어줌.
                        if (deptCode == value.CompanyDept_Code) {
                            $("#txtPopDeptRemark").val(value.Remark);
                            deptDataVal = "데이터있음";
                        }

                        var newRowContent = "<tr><td style='width:20px; text-align:center'><input id='ckbDeptCheck" + index + "' type='checkbox' value='" + value.CompanyDept_Code + "'><input id='hdDeptCode" + index + "' type='hidden' value='" + value.CompanyDept_Code + "'><input id='hdDeptName" + index + "' type='hidden' value='" + value.CompanyDept_Name + "'></td>";
                        newRowContent += "<td class='txt-center'> " + value.CompanyDept_Code + " </td><td class='txt-center'>" + value.CompanyDept_Name + "</td><td class='txt-center'>" + value.Remark + "</td><td class='txt-center'>" + value.EntryDate.split("T")[0] + "</td></tr>";

                        $("#tbodyPopDeptList").append(newRowContent);

                        index++;
                    });
                }
                else {
                    $('#tbodyPopDeptList').html("<tr><td colspan='5' class='txt-center'>데이터가 없습니다</td></tr>");
                }

                $("#tdDeptFlag").text(deptDataVal);

                //var e = document.getElementById('deptCodeDiv');
                //if (e.style.display == 'block') e.style.display = 'none';
                //else e.style.display = 'block';

                fnOpenDivLayerPopup('deptCodeDiv'); 
            };
            
            var param = { CompanyCode: $("#txtCompCode").val(), AreaCode: $("#txtAreaCode").val(), BusinessCode: $("#txtBusinCode").val(), Flag: "List" };
            JajaxSessionCheck("Post", "../../Handler/Admin/CompanyDeptHandler.ashx", param, "json", callback, '<%=Svid_User %>');
        }

        //팝업창 닫기
        //function fnCancel() {
        //    $('.divpopup-layer-package').fadeOut();
        //}

        //승인 버튼 클릭 시 값 유효성 검사
        function fnFormValueCheck() {

            var saleUrianChk = $("#hdBmroCheck").val(); //자사 체크
            var sameComNOYN = $("#hdSameComNoYN").val(); //판매사=구매사 여부
            var BDongshinCode = $("#hdBDongsinCode").val(); //자사체크코드

            if ((sameComNOYN == 'Y') && (saleUrianChk != 'N') && (isEmpty(BDongshinCode))) {
                var result = confirm("회사관리 메뉴로 이동하셔서 자사체크코드를 먼저 입력해 주세요.\n회사관리 화면으로 이동하시겠습니까?");

                if (result) {
                    var comNo = $("#hdCompNo").val();
                    var comCode = $("#txtCompCode").val();
                    document.location.href = "../Company/CompManagementInfo_B?compCode=" + comCode + "&compNo=" + comNo + "&gubun=BU";
                }

                return false;
            }

            if (isEmpty($("#txtGubunCode").val()) || ($("#txtGubunCode").val().length < 5)) {
                alert("회사구분코드를 선택해 주세요.");
                return false;
            }
            if (isEmpty($("#txtCompCode").val())) {
                alert("회사코드를 선택해 주세요.");
                return false;
            }
            if (isEmpty($("#txtAreaCode").val())) {
                alert("사업장코드를 선택해 주세요.");
                return false;
            }
            if (isEmpty($("#txtBusinCode").val())) {
                alert("사업부코드를 선택해 주세요.");
                return false;
            }
            if (isEmpty($("#txtDeptCode").val())) {
                alert("부서코드를 선택해 주세요.");
                return false;
            }
            
            if (isEmpty($("#slbPayType").val()) || isEmpty($("#slbPayRole").val())) {
                alert("결제유형을 선택해 주세요.");
                return false;
            }
            if (isEmpty($("#tdUptae").text())) {
                alert("업태 정보가 없으면 회원승인을 하실 수 없습니다.");
                return false;
            }
            if (isEmpty($("#tdUpjong").text())) {
                alert("업종 정보가 없으면 회원승인을 하실 수 없습니다.");
                return false;
            }
            
            var confirmVal = confirm("정말로 승인하시겠습니까?");
            if (!confirmVal) {
                return false;
            }
            
            return true;
        }

        //승인 버튼 클릭 시
        function fnUserConfirm() {
            if (fnFormValueCheck()) {
                var payRole = $("#slbPayRole").val();

                var callback = function (response) {
                    if (!isEmpty(response) && (response == "OK")) {
                        alert("성공적으로 승인되었습니다.");
                        location.href = 'MemberMain_B.aspx?ucode='+ucode;
                    } else {
                        alert("승인에 실패하였습니다. 개발자에게 문의하시기 바랍니다.");
                    }
                    return false;
                };

                var sUser = $("#hdSvidUser").val();
                var gubun = $("#txtGubunCode").val();
                var compCode = $("#txtCompCode").val();
                var compNm = $("#lblCompNm").text();
                var areaCode = $("#txtAreaCode").val();
                var businCode = $("#txtBusinCode").val();
                var deptCode = $("#txtDeptCode").val();
                var deptName = $("#hdDeptName").val();
                var compNo = $("#hdCompNo").val();
                var userEmail = $("#hdBillEmail").val();
                var useAdminRoleType = $("#slbUserAdminRoleType").val();

                if ($("#ckbAdminUse").prop("checked")) {
                    gubun = $("#ckbAdminUse").val();
                }
                
                var param = { SvidUser: sUser, Gubun: gubun, SvidRole: payRole, ConfirmFlag: 'Y', CompCode: compCode, CompNm: compNm, AreaCode: areaCode, BusinCode: businCode, DeptCode: deptCode, DeptName: deptName, CompNo: compNo, UserEmail: userEmail, UseAdminRoleType: useAdminRoleType, Method: "UserConfirm_Admin" };
                
                var beforeSend = function () {
                    is_sending = true;
                }
                var complete = function () {
                    is_sending = false;
                }
                if (is_sending) return false;

                JqueryAjax("Post", "../../Handler/Common/UserHandler.ashx", true, false, param, "text", callback, beforeSend, complete, true, '<%=Svid_User%>');
            }
        }

        //
        function fnGoCompMngt() {
            var compNo = $("#hdCompNo").val();
            var compCode = $("#txtCompCode").val();
            
            var paramVal = "compCode=" + compCode + "&compNo="+ compNo+"&gubun=BU&ucode="+ucode;

            location.href = "../Company/CompManagementInfo_B?" + paramVal;
        }
        
    </script>

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
<div class="all" >
    <div class="sub-contents-div" >
      <div class="sub-title-div">
                <p class="p-title-mainsentence">
                    회원정보(구매사)
                    <span class="span-title-subsentence"></span>
                </p>
            </div>
    
<!--탭메뉴-->          
            <div id="divTab" class="div-main-tab" style="width: 100%;">
                <ul>
                    <li class='tabOn' style="width: 185px;">
                        <a id="tabDefault">회사기본정보</a>
                     </li>
                    <li class='tabOff' style="width: 185px;">
                         <a id="tabPerson">개인정보</a>
                    </li>
                    <li class='tabOff' style="width: 185px;" >
                        <a id="tabHistory">활동정보</a>
                    </li>
                </ul>
            </div>
<!--회사코드부여 영역-->
        <div class="memberB-div" style="margin-top:30px">
        <div class="mini-title"><h4>회사코드 부여</h4></div>
            <table class="tbl_main">
                <tr>
                    <th>사업자번호</th>
                    <td colspan="3">
                        <asp:Label runat="server" ID="lblCompNo"></asp:Label>
                        <input type="hidden" id="hdCompNo" value="<%=compNo %>" />
                        <input type="hidden" id="hdSvidUser" value="<%=svidUser %>" /> 
                        <input type="hidden" id="hdDeptName" value="<%=deptCodeNm %>" />
                        
                    </td>
                </tr>
                <%--<tr>
                    <th>회사연동코드</th>
                    <td></td>
                    <th>회사연동코드명</th>
                    <td></td>
                </tr>--%>
                <tr>
                    <th>회사구분코드</th>
                    <td>
                        <input type="text" id="txtGubunCode" class="text-code" value="<%=gubunCode %>" readonly="readonly" placeholder="회사구분코드를 선택해 주세요" />
                        <input type="button" class="mainbtn type1" style="width:75px;" value="검색" onclick="fnAddGubunPopOpen()">
                    </td>
                    <th>회사구분명</th>
                    <td><label id="lblGubunNm"><%=gubunCodeNm %></label></td>
                </tr>
                <tr>
                    <th>회사코드</th>
                    <td>
                        <input type="text" id="txtCompCode" class="text-code" value="<%=compCode %>" readonly="readonly" placeholder="회사코드를 선택해 주세요" />
                        <input type="button" class="mainbtn type1" style="width:75px;" value="검색" onclick="fnAddCompPopOpen()">
                    </td>
                    <th>회사명</th>
                    <td><label id="lblCompNm"><%=compCodeNm %></label></td>
                </tr>
                <tr>
                    <th>사업장코드</th>
                    <td>
                        <input type="text" id="txtAreaCode" class="text-code" value="<%=areaCode %>" readonly="readonly" placeholder="사업장코드를 선택해 주세요" />
                        <input type="button" class="mainbtn type1" style="width:75px;" value="검색" onclick="fnAddAreaPopOpen()">
                    </td>
                    <th>사업장명</th>
                    <td><label id="lblAreaNm"><%=areaCodeNm %></label></td>
                </tr>
                <tr>
                    <th>사업부코드</th>
                    <td>
                        <input type="text" id="txtBusinCode" class="text-code" value="<%=businessCode %>" readonly="readonly" placeholder="사업부코드를 선택해 주세요" />
                        <input type="button" class="mainbtn type1" style="width:75px;" value="검색" onclick="fnAddBusinessPopOpen()">
                    </td>
                    <th>사업부명</th>
                    <td><label id="lblBusinNm"><%=businessCodeNm %></label></td>
                </tr>
                <tr>
                    <th>부서코드</th>
                    <td>
                        <input type="text" id="txtDeptCode" class="text-code" value="<%=deptCode %>" readonly="readonly" placeholder="부서코드를 선택해 주세요" />
                        <input type="button" class="mainbtn type1" style="width:75px;" value="검색" onclick="fnAddDeptPopOpen()">
                    </td>
                    <th>부서명</th>
                    <td><label id="lblDeptNm"><%=deptCodeNm %></label></td>
                </tr>
            </table>
        </div>

        <%--관리자권한관리 영역--%>
        <div class="memberB-div" style="margin-top:30px">
            <div class="mini-title"><h4>관리자 권한관리</h4></div>
            <table class="tbl_main">
                <tr>
                    <th style="width:18%">관리자 권한 선택</th>
                    <td>
                        <select id="slbUserAdminRoleType" style="width:200px">
                            <%--<option value="1">회사</option>
                            <option value="2">사업장</option>
                            <option value="3">사업부</option>
                            <option value="4" selected="selected">부서</option>--%>
                        </select>
                    </td>
                </tr>
            </table>
        </div>

        <%--배송지레벨관리 영역--%>
        <div class="memberB-div" style="margin-top:30px">
            <div class="mini-title"><h4>배송지 레벨관리</h4></div>
            <table class="tbl_main">
                <tr>
                    <th style="width:18%">배송지레벨 선택</th>
                    <td>
                        <select id="slbDelivLevel" disabled="disabled" style="width:200px">
                            <option value="1">회사</option>
                            <option value="2">사업장</option>
                            <option value="3">사업부</option>
                            <option value="4" selected="selected">부서</option>
                        </select>
                    </td>
                </tr>
            </table>
        </div>

        <%--세금계산서 발행정보 영역--%>
        <div class="memberB-div" style="margin-top:30px">
            <div class="mini-title"><h4>세금계산서 발행정보</h4></div>
            <table class="tbl_main">
                <tr>
                    <th>담당자명
                        <input type="hidden" id="hdBillUserNm" value="<%=billUserNm %>" />
                        <input type="hidden" id="hdBillTel" value="<%=billTel %>" />
                        <input type="hidden" id="hdBillFax" value="<%=billFax %>" />
                        <input type="hidden" id="hdBillEmail" value="<%=billEmail %>" />
                        <input type="hidden" id="hdBillUptae" value="<%=uptae %>" />
                        <input type="hidden" id="hdBillUpjong" value="<%=upjong %>" />
                        <input type="hidden" id="hdBTypeRole" />
                        <input type="hidden" id="hdSvidRole" value="<%=svidRole %>" />
                        <input type="hidden" id="hdBmroCheck" />
                        <input type="hidden" id="hdBDongsinCode" />
                        <input type="hidden" id="hdSameComNoYN" />
                    </th>
                    <td id="tdBillUserNm"><%=billUserNm %></td>
                    <th>업태</th>
                    <td id="tdUptae"><%=uptae %></td>
                </tr>
                <tr>
                    <th>전화번호</th>
                    <td id="tdBillTel"><%=billTel %></td>
                    <th>업종</th>
                    <td id="tdUpjong"><%=upjong %></td>
                </tr>
                <tr>
                    <th>FAX 번호</th>
                    <td colspan="3" id="tdBillFax"><%=billFax %></td>
                </tr>
                <tr>
                    <th>Email<br />(전자세금계산서 발행)</th>
                    <td colspan="3" id="tdBillEmail"><%=billEmail %></td>
                </tr>
            </table>
        </div>

        <%--결제유형 영역--%>
        <div class="memberB-div" style="margin-top:30px">
            <div class="mini-title"><h4>결제유형</h4></div>
            <table class="tbl_main">
                <tr id="trPayType" style="display:none;">
                    <th style="width:18%;">유형 선택</th>
                    <td style="width:300px">
                        <select id="slbPayType" disabled="disabled" style="width:200px; height:22px">
                            <option value="">없음</option>
                            <option value="A">기본</option>
                            <option value="B">구매요청</option>
                            <option value="C">결재상신</option>
                            <option value="BC">결재상신(요청)</option>
                        </select>
                        <input type="button" class="mainbtn type1" style="width:75px;" value="수정" onclick="return fnGoCompMngt();">                        
                    </td>
                    <td style="width:200px; text-align:right; padding-right:10px;">
                        <select id="slbPayRole" disabled="disabled" style="width:100px; height:22px">
                            <option value="" selected="selected">없음</option>
                        </select>
                    </td>
                    <td style="width:auto; padding-left:10px;">
                        <input type="checkbox" id="ckbAdminUse" value="ADM" />&nbsp;관리자
                    </td>
                </tr>
                <tr id="trPayTypeNone" style="display:none;">
                    <th style="width:10%;">유형 선택</th>
                    <td colspan="3" style="color:red;">회사코드를 선택하시면 활성화 됩니다.</td>
                </tr>
            </table>
        </div>

<!--회사권한관리 영역-->
        <%--<div class="memberB-div">
        <div class="mini-title"><img src="../Images/Member/mini-title2.jpg" /></div>
            <table class="tblMember">
                <tr><th>후불결제</th><td><asp:DropDownList runat="server" CssClass="input-drop">
                    <asp:ListItem Text="-----------&nbsp;후불결제 여부를 선택하세요&nbsp;----------"></asp:ListItem>
                    <asp:ListItem Text="사용"></asp:ListItem>
                     <asp:ListItem Text="사용안함"></asp:ListItem>
                                     </asp:DropDownList>
                    

                                 </td>
                    <th>거래현황</th><td><asp:DropDownList runat="server" CssClass="input-drop">
                        <asp:ListItem Text="-----------&nbsp;거래현황을 선택하세요&nbsp;-------------"></asp:ListItem>
                        <asp:ListItem Text="거래중"></asp:ListItem>
                         <asp:ListItem Text="거래중지"></asp:ListItem>
                                     </asp:DropDownList></td></tr>
            </table>
        </div>--%>
<!--여신관리 영역-->
        <%--<div class="memberB-div">
            <div class="mini-title"><img src="../Images/Member/mini-title3.jpg" /></div>
            <table class="tblLoan">
                <tr>
                    <th d>거래일자</th>
                    <td></td>
                    <th>미수금액</th>
                    <td></td>
                    <th>신용한도(여신)</th>
                    <td><input type="text" placeholder="관리자 여신금액 입력" class="text-price" /></td>
                </tr>
            </table>
        </div>--%>
<!--세금계산 발행정보 영역-->
        <%--<div class="memberB-div">
            <div class="mini-title"><img src="../Images/Member/mini-title4.jpg" /></div>
            <table class="tblMember">
                <tr><th>회사코드</th><td></td><th>회사명</th><td></td></tr>
                <tr><th>사업자번호</th><td></td><th>대표자</th><td></td></tr>
                <tr><th>전자세금계산서 발행 이메일</th><td colspan="3"></td>
                <tr><th>전화번호</th><td></td><th>휴대전화</th><td></td></tr>
            </table>
        </div>--%>
<!--구매요청/결재상신관리 영역-->
        <%--<div class="memberB-div">
            <div class="mini-title"><img src="../Images/Member/mini-title5.jpg" /></div>
             <table class="tblMember">
                <tr><th style="width:100px;">유형선택</th>
                    <td colspan="5">
                        <asp:DropDownList runat="server" CssClass="input-drop">
                            <asp:ListItem Text="일반(A)"></asp:ListItem>
                            <asp:ListItem Text="구매요청(B)"></asp:ListItem>
                            <asp:ListItem Text="결재상신(C)"></asp:ListItem>
                            <asp:ListItem Text="구매요청+결재상신(BC)"></asp:ListItem>
                        </asp:DropDownList>
                    </td>
                </tr>
            </table>
             
             <table class="tblMember">
                <tr><th>회사코드</th>
                    <th>회사명</th>
                    <th>부서코드</th>
                    <th>부서명</th>
                    <th></th>
                    <th>분류코드</th>
                    <th>사용자등급</th>
                    <th>권한1</th>
                    <th>권한2</th>
                    <th></th>
                </tr>
                 <!--추후 삭제 -->
               <tr><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td><input type="checkbox"  value="authority" /><label for="ckbSearch2">&nbsp;&nbsp;권한1</label>&nbsp;&nbsp;</td></tr>
                 <tr><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td></tr>
                 <tr><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td></tr>
                 <tr><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td></tr>
                 <tr><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td></tr>
                 <tr><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td></tr>
                 <tr><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td></tr>
                 <tr><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td></tr>
                 <tr><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td></tr>
             <!--추후삭제끝 -->    
             </table>
         </div>--%>

<!--저장버튼-->
        <div class="bt-align-div">
            <input type="button" class="mainbtn type1" style="width:75px;" value="목록" onclick="location.href='MemberMain_B.aspx'">
            <input type="button" class="mainbtn type1" style="width:75px;" value="승인" onclick="fnUserConfirm(); return false;">
            <%--<asp:ImageButton runat="server" ImageUrl="../Images/Member/save.jpg" AlternateText="저장" onmouseover="this.src='../Images/Member/save-on.jpg'" onmouseout="this.src='../Images/Member/save.jpg'"/>--%>        
        </div>
<!--저장버튼끝-->
  
        


<%--///////////////////////////////팝업창 시작///////////////////////////////////////////////////////////--%>

   <!--회사구분코드 팝업창영역 시작-->
    <div id="companyClassifyDiv" class="divpopup-layer-package">
        <div class="popupdivWrapper" style="width:700px; height:520px;">
            <div class="popupdivContents" style="border:none;">
                    <div>
                        <div class="close-div" ><a onclick="fnClosePopup('companyClassifyDiv');" style="cursor:pointer"><img src="../../Images/Wish/icon-delete.jpg" alt="닫기" style="float:right;"/></a></div>
                        <div class="popup-title">
                            <h3 class="pop-title">회사구분코드 검색</h3>  
                            <!--팝업 컨텐츠 영역 시작-->                     
                            <div class="popup-div-top">
                                <table id="tblPopGubunCode" class="tbl_main">
                                    <tr>
                                        <th style="width:40px; text-align:center">선택</th>
                                        <th>회사구분명</th>
                                        <td style="width:30%;"><input type="text" id="txtPopGubunNm" style="width:99%" /></td>
                                        <th>회사구분코드</th>
                                        <td style="width:20%;"><input type="text" id="txtPopGubunCode" readonly="readonly" tabindex="-1" style="width:99%" /></td>
                                        <td id="tdGubunFlag" style="width:80px" class="text-center">데이터있음</td>
                                    </tr>
                                    <tr>
                                        <th colspan="2">비고</th>
                                        <td colspan="4"><input type="text" id="txtPopGubunRemark" style="width:99%" /></td>
                                    </tr>
                                </table>
                            </div>               
                            <div class="popup-div-bottom">
                                <table id="tblPopGubunList" class="tbl_main tbl_pop">
                                    <colgroup>
                                        <col width="6%" />
                                        <col width="20%" />
                                        <col width="27%" />
                                        <col width="30%" />
                                        <col width="17%" />
                                    </colgroup>
                                    <thead>
                                        <tr><th>선택</th>
                                            <th>회사구분코드</th>
                                            <th>회사구분명</th>
                                            <th>비고</th>
                                            <th>등록날짜</th>
                                        </tr>
                                    </thead>
                                    <tbody id="tbodyPopGubunList"></tbody>
                                </table>
                            </div>

<!--코드명생성,코드생성, 확인 버튼 영역-->
                            <div class="btn_center">
                                <input type="submit" value="코드명 수정" class="mainbtn type1" onclick="fnPopGubunModifyCode(); return false;">
                                <input type="submit" value="코드 생성" class="mainbtn type1" onclick="fnPopGubunNewCode(); return false;">
                                <input type="submit" value="확인" class="mainbtn type1" style="width:75px" onclick="fnPopGubunOK(); return false;">
                            </div>
                        </div>
                    </div>
		        </div>
	        </div>
        </div>
    </div>
<!--팝업창영역 끝-->




<!--회사코드 팝업창영역 시작-->
    <div id="companyCodeDiv" class="popupdiv divpopup-layer-package">
        <div class="popupdivWrapper" style="width:700px; height:520px;">
            <div class="popupdivContents">
                    <div>
                        <div class="close-div" ><a onclick="fnClosePopup('companyCodeDiv');" style="cursor:pointer"><img src="../../Images/Wish/icon-delete.jpg" alt="닫기" style="float:right;"/></a></div>
                        <div class="popup-title">
                            <h3 class="pop-title">회사코드 검색</h3>  
                           
<!--팝업 컨텐츠 영역 시작-->                     
                        <div class="popup-div-top">
                            <table class="tbl_main">
                                <tr>
                                    <th style="width:40px; text-align:center">선택</th>
                                    <th>회사명</th>
                                    <td style="width:30%;"><input type="text" id="txtPopCompNm" style="width:99%" /></td>
                                    <th>회사코드</th>
                                    <td style="width:20%;"><input type="text" id="txtPopCompCode" readonly="readonly" tabindex="-1" style="width:99%" /></td>
                                    <td id="tdCompFlag" style="width:80px" class="text-center">데이터있음</td>
                                </tr>
                                <tr>
                                    <th colspan="2">비고</th>
                                    <td colspan="4">
                                        <input type="text" id="txtPopCompRemark" style="width:60%; margin-right:5px" />
                                        <a class="btnDelete" id="btnNoneComNoCode" onclick="return fnGetNoneComNoCode();">사업자번호없음코드생성</a>
                                    </td>
                                </tr>
                            </table>
                        </div>
                        <div class="popup-div-bottom">
                            <table id="tblPopCompList" class="tbl_main">
                                <colgroup>
                                    <col width="6%">
                                    <col width="20%">
                                    <col width="27%">
                                    <col width="30%">
                                    <col width="17%">
                                </colgroup>
                                <thead>
                                    <tr><th>선택</th>
                                        <th>회사코드</th>
                                        <th>회사명</th>
                                        <th>비고</th>
                                        <th>등록날짜</th>
                                    </tr>
                                </thead>
                                <tbody id="tbodyPopCompList"></tbody>
                            </table>
                        </div>

<!--코드명생성,코드생성, 확인 버튼 영역-->
                        <div class="btn_center">
                            <input type="submit" value="코드명 수정" class="mainbtn type1" onclick="fnPopCompModifyCode(); return false;">
                            <input type="submit" value="코드 생성" class="mainbtn type1" onclick="fnPopCompNewCode(); return false;">
                            <input type="submit" value="확인" class="mainbtn type1" style="width:75px" onclick="fnPopCompOK(); return false;">
                        </div>
<!--버튼영역끝 -->
<!--팝업 컨텐츠 영역끝-->
                      </div>
                   </div>
	        </div>
        </div>
    </div>
<!--팝업창영역 끝-->

<!--사업장 팝업창영역 시작-->
    <div id="workplaceCodeDiv" class="divpopup-layer-package">
        <div class="popupdivWrapper" style="width:700px; height:520px;">
             <div class="popupdivContents" style="border:none;">
			    <div>
                    <div class="close-div"><a onclick="fnClosePopup('workplaceCodeDiv');" style="cursor:pointer"><img src="../../Images/Wish/icon-delete.jpg" alt="닫기" style="float:right;"/></a></div>
                    <div class="popup-title">
                        <h3 class="pop-title">사업장 코드 검색</h3>
                           
<!--팝업 컨텐츠 영역 시작-->                     
                    <div class="popup-div-top">
                       <table class="tbl_main">
                            <tr>
                                <th style="width:40px; text-align:center">선택</th>
                                <th>사업장명</th>
                                <td style="width:30%;"><input type="text" id="txtPopAreaNm" style="width:99%" /></td>
                                <th>사업장코드</th>
                                <td style="width:20%;"><input type="text" id="txtPopAreaCode" readonly="readonly" tabindex="-1" style="width:99%" /></td>
                                <td id="tdAreaFlag" style="width:80px" class="text-center">데이터있음</td>
                            </tr>
                            <tr>
                                <th colspan="2">비고</th>
                                <td colspan="4"><input type="text" id="txtPopAreaRemark" style="width:99%" /></td>
                            </tr>
                       </table>
                    </div>
                    <div class="popup-div-bottom">
                        <table id="tblPopAreaList" class="tbl_main tbl_pop">
                            <colgroup>
                                <col width="6%">
                                <col width="20%">
                                <col width="27%">
                                <col width="30%">
                                <col width="17%">
                            </colgroup>
                            <thead>
                                <tr><th>선택</th>
                                    <th>사업장코드</th>
                                    <th>사업장명</th>
                                    <th>비고</th>
                                    <th>등록날짜</th>
                                </tr>
                            </thead>
                            <tbody id="tbodyPopAreaList"></tbody>
                        </table>
                    </div>

<!--코드명생성,코드생성, 확인 버튼 영역-->
                    <div class="btn_center">
                        <input type="submit" value="코드명 수정" class="mainbtn type1" onclick="fnPopAreaModifyCode(); return false;">
                        <input type="submit" value="코드 생성" class="mainbtn type1" onclick="fnPopAreaNewCode(); return false;">
                        <input type="submit" value="확인" class="mainbtn type1" style="width:75px" onclick="fnPopAreaOK(); return false;">
                    </div>
<!--버튼영역끝 -->
<!--팝업 컨텐츠 영역끝-->
                      </div>
                    </div>
		        </div>
        </div>
    </div>
<!--팝업창영역 끝-->


<!--사업부코드 팝업창영역 시작-->
    <div id="divisionCodeDiv" class="divpopup-layer-package">
          <div class="popupdivWrapper" style="width:700px; height:520px;">
             <div class="popupdivContents" style="border:none;">
			    <div>
                     <div class="close-div" ><a onclick="fnClosePopup('divisionCodeDiv');" style="cursor:pointer"><img src="../../Images/Wish/icon-delete.jpg" alt="닫기" style="float:right;"/></a></div>
                        <div class="popup-title">
                            <h3 class="pop-title">사업부 코드 검색</h3>
                           
<!--팝업 컨텐츠 영역 시작-->                     
                   <div class="popup-div-top">
                       <table class="tbl_main">
                            <tr>
                                <th style="width:40px;">선택</th>
                                <th>사업부명</th>
                                <td style="width:30%;"><input type="text" id="txtPopBusinNm" style="width:99%" /></td>
                                <th>사업부코드</th>
                                <td style="width:20%;"><input type="text" id="txtPopBusinCode" readonly="readonly" tabindex="-1" style="width:99%" /></td>
                                <td id="tdBusinFlag" style="width:80px" class="text-center">데이터있음</td>
                            </tr>
                            <tr>
                                <th colspan="2">비고</th>
                                <td colspan="4"><input type="text" id="txtPopBusinRemark" style="width:99%" /></td>
                            </tr>
                       </table>
                   </div>
                            
                    <div class="popup-div-bottom">
                        <table id="tblPopBusinList" class="tbl_main tbl_pop">
                            <colgroup>
                                <col width="6%">
                                <col width="20%">
                                <col width="27%">
                                <col width="30%">
                                <col width="17%">
                            </colgroup>
                            <thead>
                                <tr><th>선택</th>
                                    <th>사업부코드</th>
                                    <th>사업부명</th>
                                    <th>비고</th>
                                    <th>등록날짜</th>
                                </tr>
                            </thead>
                            <tbody id="tbodyPopBusinList"></tbody>
                        </table>
                    </div>

<!--코드명생성,코드생성, 확인 버튼 영역-->
                        <div class="btn_center">
                            <input type="submit" value="코드명 수정" class="mainbtn type1" onclick="fnPopBusinessModifyCode(); return false;">
                            <input type="submit" value="코드 생성" class="mainbtn type1" onclick="fnPopBusinessNewCode(); return false;">
                            <input type="submit" value="확인" class="mainbtn type1" style="width:75px" onclick="fnPopBusinessOK(); return false;">
                        </div>
<!--버튼영역끝 -->
<!--팝업 컨텐츠 영역끝-->
                        </div>
                    </div>
		        </div>
        </div>
    </div>
<!--팝업창영역 끝-->

        <!--부서코드 팝업창영역 시작-->
    <div id="deptCodeDiv" class="divpopup-layer-package">
          <div class="popupdivWrapper" style="width:700px; height:520px;">
             <div class="popupdivContents" style="border:none;">
			    <div>
                  <div class="close-div" ><a onclick="fnClosePopup('deptCodeDiv');" style="cursor:pointer"><img src="../../Images/Wish/icon-delete.jpg" alt="닫기" style="float:right;"/></a></div>
                    <div class="popup-title">
                        <h3 class="pop-title">부서코드 검색</h3>    
                           
<!--팝업 컨텐츠 영역 시작-->                     
                   <div class="popup-div-top">
                       <table class="tbl_main">
                           <tr>
                                <th style="width:40px; text-align:center">선택</th>
                                <th>부서코드</th>
                                <td style="width:30%;"><input type="text" id="txtPopDeptNm" style="width:99%" /></td>
                                <th>부서명</th>
                                <td style="width:20%;"><input type="text" id="txtPopDeptCode" readonly="readonly" tabindex="-1" style="width:99%" /></td>
                                <td id="tdDeptFlag" style="width:80px" class="text-center">데이터있음</td>
                            </tr>
                            <tr>
                                <th colspan="2">비고</th>
                                <td colspan="4"><input type="text" id="txtPopDeptRemark" style="width:99%" /></td>
                            </tr>
                       </table>
                   </div>
                    <div class="popup-div-bottom">
                        <table id="tblPopDeptList" class="tbl_main tbl_pop">
                            <colgroup>
                                <col width="6%">
                                <col width="20%">
                                <col width="27%">
                                <col width="30%">
                                <col width="17%">
                            </colgroup>
                            <thead>
                                <tr><th>선택</th>
                                    <th>부서명</th>
                                    <th>부서코드</th>
                                    <th>비고</th>
                                    <th>등록날짜</th>
                                </tr>
                            </thead>
                            <tbody id="tbodyPopDeptList"></tbody>
                        </table>
                    </div>

<!--코드명생성,코드생성, 확인 버튼 영역-->
                    <div class="btn_center">
                        <input type="submit" value="코드명 수정" class="mainbtn type1" onclick="fnPopDeptModifyCode(); return false;">
                        <input type="submit" value="코드 생성" class="mainbtn type1" onclick="fnPopDeptNewCode(); return false;">
                        <input type="submit" value="확인" class="mainbtn type1" style="width:75px" onclick="fnPopDeptOK(); return false;">
                    </div>
<!--버튼영역끝 -->
<!--팝업 컨텐츠 영역끝-->
                        </div>
                    </div>
		        </div>
        </div>
    </div>
<!--팝업창영역 끝-->

</div>
</div>
</asp:Content>

