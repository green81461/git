<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Master/AdminMasterPage.master" AutoEventWireup="true" CodeFile="MemberCorpInfo_A.aspx.cs" Inherits="Admin_Member_MemberCorpInfo_A" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
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

            // enter key 방지
            $(document).on("keypress", "input", function (e) {
                if (e.keyCode == 13) {
                    return false;
                }
                else
                    return true;
            });

            $("#tabDefault").on("click", function () {

                location.href = 'MemberCorpInfo_A.aspx?uId=' +'<%=uId %>' + '&ucode=' + ucode;
            });
            $("#tabPerson").on("click", function () {
                location.href = 'MemberPersonalInfo_A.aspx?uId=' +'<%=uId %>' + '&ucode=' + ucode;
            });
            $("#tabHistory").on("click", function () {
                location.href = 'MemberLogInfo_A.aspx?uId=' +'<%=uId %>' + '&ucode=' + ucode;
            });

        });

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

                        var newRowContent = "<tr><td style='text-align:center'><input id='ckbGubunCheck" + index + "' type='checkbox' value='" + value.SocialCompany_Code + "'><input id='hdGubunCode" + index + "' type='hidden' value='" + value.SocialCompany_Code + "'><input id='hdGubunName" + index + "' type='hidden' value='" + value.SocialCompany_Name + "'></td>";
                        newRowContent += "<td style='text-align:center'> " + value.SocialCompany_Code + " </td><td style='text-align:center'>" + value.SocialCompany_Name + "</td><td style='text-align:center'>" + value.Remark + "</td><td class='txt-center'>" + value.EntryDate.split("T")[0] + "</td></tr>";

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
                        var newRowContent = "<tr><td style='text-align:center'><input id='ckbGubunCheck" + index + "' type='checkbox' value='" + value.SocialCompany_Code + "'><input id='hdGubunCode" + index + "' type='hidden' value='" + value.SocialCompany_Code + "'><input id='hdGubunName" + index + "' type='hidden' value='" + value.SocialCompany_Name + "'></td>";
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
                var index = 0;
                var gubunCode = $("#txtGubunCode").val(); // 회사구분코드
                var gubunCodeNm = $("#lblGubunNm").text(); // 회사구분명

                $("#txtPopGubunCode").val(gubunCode);
                $("#txtPopGubunNm").val(gubunCodeNm);

                if (!isEmpty(response)) {

                    $.each(response, function (key, value) { //테이블 추가

                        // 팝업창의 비고 입력창에 해당하는 코드의 비고값을 넣어줌.
                        if (gubunCode == value.SocialCompany_Code) {
                            $("#txtPopGubunRemark").val(value.Remark);
                            gubunDataVal = "데이터있음";
                        }

                        var newRowContent = "<tr><td style='text-align:center'><input id='ckbGubunCheck" + index + " ' type='checkbox' value='" + value.SocialCompany_Code + "'><input id='hdGubunCode" + index + "' type='hidden' value='" + value.SocialCompany_Code + "'><input id='hdGubunName" + index + "' type='hidden' value='" + value.SocialCompany_Name + "'></td>";
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

            var param = { Gubun: gubun.substring(0, 2), Method: "SocialCompanyList" };

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
                        var newRowContent = "<tr><td style='text-align:center'><input id='ckbCompCheck" + index + "' type='checkbox' value='" + value.Company_Code + "'><input id='hdCompCode" + index + "' type='hidden' value='" + value.Company_Code + "'><input id='hdCompName" + index + "' type='hidden' value='" + value.Company_Name + "'></td>";
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
            var param = { CompanyCode: popupCompCode, CompanyName: popupCompName, CompanyNo: companyNo, Remark: popupCompRemark, Flag: 'Update' };
            JajaxSessionCheck("Post", "../../Handler/Admin/CompanyHandler.ashx", param, "json", callback, '<%=Svid_User %>');
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

                        var newRowContent = "<tr><td style='text-align:center'><input id='ckbCompCheck" + index + "' type='checkbox' value='" + value.Company_Code + "'><input id='hdCompCode" + index + "' type='hidden' value='" + value.Company_Code + "'><input id='hdCompName" + index + "' type='hidden' value='" + value.Company_Name + "'></td>";
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
            var param = { CompanyName: newCompName, CompanyNo: companyNo, Gubun: 'SU', Remark: newRemark, Flag: 'Create' }; // ajax 파라미터

            JajaxSessionCheck("Post", "../../Handler/Admin/CompanyHandler.ashx", param, "json", callback, '<%=Svid_User %>');
        }





        //선택한 회사의 세금계산서 정보 조회
        function fnCompBillInfo(compCode) {

            var uptae = '';
            var upjong = '';

            var callback = function (response) {
                if (!isEmpty(response)) {
                    $("#hdBillUserNm").val(response.BillUserNm);
                    $("#hdBillTel").val(response.BillTel);
                    $("#hdBillFax").val(response.BillFax);
                    $("#hdBillEmail").val(response.BillEmail);
                    $("#hdBillUptae").val(response.Uptae);
                    $("#hdBillUpjong").val(response.Upjong);

                    $("#tdBillUserNm").text(response.BillUserNm);
                    $("#tdUptae").text(response.Uptae);
                    $("#tdBillTel").text(response.BillTel);
                    $("#tdUpjong").text(response.Upjong);
                    $("#tdBillFax").text(response.BillFax);
                    $("#tdBillEmail").text(response.BillEmail);
                }
                return false;
            };

            var compNo = $("#hdCompNo").val();

            var param = {
                CompCode: compCode,
                CompNo: compNo,
                Gubun: 'SU',
                Flag: "CompanyMngtInfo_Admin"
            };

            var beforeSend = function () {
                is_sending = true;
            }
            var complete = function () {
                is_sending = false;
            }

            if (is_sending) return false;

            JqueryAjax("Post", "../../Handler/Admin/CompanyHandler.ashx", true, false, param, "json", callback, beforeSend, complete, true, '<%=Svid_User%>');
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

            fnCompBillInfo(compCode);

            $("#txtAreaCode").val('');
            $("#lblAreaNm").text('');
            $("#txtBusinCode").val('');
            $("#lblBusinNm").text('');
            $("#txtDeptCode").val('');
            $("#lblDeptNm").text('');

            //fnSetPayTypeView();

            fnClosePopup('companyCodeDiv');
        }

        //[팝업:회사코드] 팝업창 열기
        function fnAddCompPopOpen() {
            var gubun = $("#txtGubunCode").val() == null ? '' : $("#txtGubunCode").val();
            if (isEmpty(gubun) || (gubun.length < 5)) {
                alert("회사구분코드를 선택해 주세요.");
                return false;
            }

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
                            $("#txtPopCompRemark").val(value.Remark);
                            compDataVal = "데이터있음";
                        }

                        var newRowContent = "<tr><td style='text-align:center'><input id='ckbCompCheck" + index + "' type='checkbox' value='" + value.Company_Code + "'><input id='hdCompCode" + index + "' type='hidden' value='" + value.Company_Code + "'><input id='hdCompName" + index + "' type='hidden' value='" + value.Company_Name + "'></td>";
                        newRowContent += "<td class='txt-center'> " + value.Company_Code + " </td><td class='txt-center'>" + value.Company_Name + "</td><td class='txt-center'>" + value.Remark + "</td><td class='txt-center'>" + value.EntryDate.split("T")[0] + "</td></tr>";

                        $("#tbodyPopCompList").append(newRowContent);
                        index++;
                    });
                }
                else {
                    $('#tbodyPopCompList').html("<tr><td colspan='5' class='txt-center'>데이터가 없습니다</td></tr>");
                }

                $("#tdCompFlag").text(compDataVal);

                //var e = document.getElementById('companyCodeDiv');
                //if (e.style.display == 'block') e.style.display = 'none';
                //else e.style.display = 'block';

                fnOpenDivLayerPopup('companyCodeDiv');

            };

            var param = { CompanyNo: companyNo, Gubun: 'SU', Flag: 'ListByGubunCompNo' };

            JajaxSessionCheck("Post", "../../Handler/Admin/CompanyHandler.ashx", param, "json", callback, '<%=Svid_User %>');

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
                        var newRowContent = "<tr><td style='text-align:center'><input id='ckbAreaCheck" + index + "' type='checkbox' value='" + value.CompanyArea_Code + "'><input id='hdAreaCode" + index + "' type='hidden' value='" + value.CompanyArea_Code + "'><input id='hdAreaName" + index + "' type='hidden' value='" + value.CompanyArea_Name + "'></td>";
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

                        var newRowContent = "<tr><td style='text-align:center'><input id='ckbAreaCheck" + index + "' type='checkbox' value='" + value.CompanyArea_Code + "'><input id='hdAreaCode" + index + "' type='hidden' value='" + value.CompanyArea_Code + "'><input id='hdAreaName" + index + "' type='hidden' value='" + value.CompanyArea_Name + "'></td>";
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

                        var newRowContent = "<tr><td style='text-align:center'><input id='ckbAreaCheck" + index + "' type='checkbox' value='" + value.CompanyArea_Code + "'><input id='hdAreaCode" + index + "' type='hidden' value='" + value.CompanyArea_Code + "'><input id='hdAreaName" + index + "' type='hidden' value='" + value.CompanyArea_Name + "'></td>";
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
                        var newRowContent = "<tr><td style='text-align:center'><input id='ckbBusinCheck" + index + "' type='checkbox' value='" + value.CompBusinessDept_Code + "'><input id='hdBusinCode" + index + "' type='hidden' value='" + value.CompBusinessDept_Code + "'><input id='hdBusinName" + index + "' type='hidden' value='" + value.CompBusinessDept_Name + "'></td>";
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

                        var newRowContent = "<tr><td style='text-align:center'><input id='ckbBusinCheck" + index + "' type='checkbox' value='" + value.CompBusinessDept_Code + "'><input id='hdBusinCode" + index + "' type='hidden' value='" + value.CompBusinessDept_Code + "'><input id='hdBusinName" + index + "' type='hidden' value='" + value.CompBusinessDept_Name + "'></td>";
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

                        var newRowContent = "<tr><td style='text-align:center'><input id='ckbBusinCheck" + index + "' type='checkbox' value='" + value.CompBusinessDept_Code + "'><input id='hdBusinCode" + index + "' type='hidden' value='" + value.CompBusinessDept_Code + "'><input id='hdBusinName" + index + "' type='hidden' value='" + value.CompBusinessDept_Name + "'></td>";
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
                        var newRowContent = "<tr><td style='text-align:center'><input id='ckbDeptCheck" + index + "' type='checkbox' value='" + value.CompanyDept_Code + "'><input id='hdDeptCode" + index + "' type='hidden' value='" + value.CompanyDept_Code + "'><input id='hdDeptName" + index + "' type='hidden' value='" + value.CompanyDept_Name + "'></td>";
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

                        var newRowContent = "<tr><td style='text-align:center'><input id='ckbDeptCheck" + index + "' type='checkbox' value='" + value.CompanyDept_Code + "'><input id='hdDeptCode" + index + "' type='hidden' value='" + value.CompanyDept_Code + "'><input id='hdDeptName" + index + "' type='hidden' value='" + value.CompanyDept_Name + "'></td>";
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

                        var newRowContent = "<tr><td style='text-align:center'><input id='ckbDeptCheck" + index + "' type='checkbox' value='" + value.CompanyDept_Code + "'><input id='hdDeptCode" + index + "' type='hidden' value='" + value.CompanyDept_Code + "'><input id='hdDeptName" + index + "' type='hidden' value='" + value.CompanyDept_Name + "'></td>";
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
                var payRole = "A1"; //임시용. 나중에 수정해야 함.

                var callback = function (response) {
                    if (!isEmpty(response) && (response == "OK")) {
                        alert("성공적으로 승인되었습니다.");
                        location.href = 'MemberMain_A.aspx?ucode=' + ucode;
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
                var compNo = $("#hdCompNo").val();

                var param = {
                    SvidUser: sUser, Gubun: gubun, SvidRole: payRole, ConfirmFlag: 'Y', CompCode: compCode
                    , CompNm: compNm, AreaCode: areaCode, BusinCode: businCode, DeptCode: deptCode, CompNo: compNo, Method: "UserConfirm_Admin"
                };

                var beforeSend = function () { is_sending = true; }
                var complete = function () { is_sending = false; }
                if (is_sending) return false;

                JqueryAjax("Post", "../../Handler/Common/UserHandler.ashx", true, false, param, "text", callback, beforeSend, complete, true, '<%=Svid_User%>');

                <%--JajaxSessionCheck("Post", "../../Handler/Common/UserHandler.ashx", param, "text", callback, '<%=Svid_User %>');--%>
            }
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div class="all">
        <div class="sub-contents-div">
            <div class="sub-title-div">
                <p class="p-title-mainsentence">
                    회원정보(판매사)
                    <span class="span-title-subsentence"></span>
                </p>
            </div>

            <!--탭영역-->
            <div id="divTab" class="div-main-tab" style="width: 100%;">
                <ul>
                    <li class='tabOn' style="width: 185px;">
                        <a id="tabDefault">회사기본정보</a>
                    </li>
                    <li class='tabOff' style="width: 185px;">
                        <a id="tabPerson">개인정보</a>
                    </li>
                    <li class='tabOff' style="width: 185px;">
                        <a id="tabHistory">활동정보</a>
                    </li>
                </ul>
            </div>

            <!--회사코드부여 영역-->
            <div class="memberB-div" style="margin-top: 20px">
                <div class="admin-maincontents-subtitle">
                    <span>*회사코드부여</span>
                </div>
                <table class="tbl_main">
                    <colgroup>
                        <col style="width:20%"/>
                        <col style="width:30%"/>
                        <col style="width:20%"/>
                        <col style="width:30%"/>
                    </colgroup>
                    <tr>
                        <th>사업자번호</th>
                        <td colspan="3">
                            <asp:Label runat="server" ID="lblCompNo"></asp:Label>
                            <input type="hidden" id="hdCompNo" value="<%=compNo %>" />
                            <input type="hidden" id="hdSvidUser" value="<%=svidUser %>" />
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
                            <input type="text" id="txtGubunCode" class="medium-size" value="<%=gubunCode %>" readonly="readonly" placeholder="회사구분코드를 선택해 주세요" />
                            <%--<a class="imgA" onclick="fnAddGubunPopOpen()">
                            <img src="../../AdminSub/Images/Goods/search-bt-off.jpg" onmouseover="this.src='../../AdminSub/Images/Goods/search-bt-on.jpg'" onmouseout="this.src='../../AdminSub/Images/Goods/search-bt-off.jpg'" alt="검색" class="search-img" />
                        </a>--%>
                            <input type="button" class="mainbtn type1" style="width:75px;" onclick="fnAddGubunPopOpen();" value="검색" />
                        </td>
                        <th>회사구분명</th>
                        <td>
                            <label id="lblGubunNm"><%=gubunCodeNm %></label></td>
                    </tr>
                    <tr>
                        <th>회사코드</th>
                        <td>
                            <input type="text" id="txtCompCode" class="medium-size" value="<%=compCode %>" readonly="readonly" placeholder="회사코드를 선택해 주세요" />
                            <%--<a class="imgA" onclick="fnAddCompPopOpen()">
                            <img src="../../AdminSub/Images/Goods/search-bt-off.jpg" onmouseover="this.src='../../AdminSub/Images/Goods/search-bt-on.jpg'" onmouseout="this.src='../../AdminSub/Images/Goods/search-bt-off.jpg'" alt="검색" class="search-img" /></a>--%>
                            <input type="button" class="mainbtn type1" style="width:75px;" onclick="fnAddCompPopOpen();" value="검색" />
                        </td>
                        <th>회사명</th>
                        <td>
                            <label id="lblCompNm"><%=compCodeNm %></label></td>
                    </tr>
                    <tr>
                        <th>사업장코드</th>
                        <td>
                            <input type="text" id="txtAreaCode" class="medium-size" value="<%=areaCode %>" readonly="readonly" placeholder="사업장코드를 선택해 주세요" />
                            <%-- <a class="imgA" onclick="fnAddAreaPopOpen()">
                            <img src="../../AdminSub/Images/Goods/search-bt-off.jpg" onmouseover="this.src='../../AdminSub/Images/Goods/search-bt-on.jpg'" onmouseout="this.src='../../AdminSub/Images/Goods/search-bt-off.jpg'" alt="검색" class="search-img" /></a>--%>
                            <input type="button" class="mainbtn type1" style="width:75px;" onclick="fnAddAreaPopOpen();" value="검색" />
                        </td>
                        <th>사업장명</th>
                        <td>
                            <label id="lblAreaNm"><%=areaCodeNm %></label></td>
                    </tr>
                    <tr>
                        <th>사업부코드</th>
                        <td>
                            <input type="text" id="txtBusinCode" class="medium-size" value="<%=businessCode %>" readonly="readonly" placeholder="사업부코드를 선택해 주세요" />
                            <%--<a class="imgA" onclick="fnAddBusinessPopOpen()">
                            <img src="../../AdminSub/Images/Goods/search-bt-off.jpg" onmouseover="this.src='../../AdminSub/Images/Goods/search-bt-on.jpg'" onmouseout="this.src='../../AdminSub/Images/Goods/search-bt-off.jpg'" alt="검색" class="search-img" /></a>--%>
                            <input type="button" class="mainbtn type1" style="width:75px;" onclick="fnAddBusinessPopOpen();" value="검색" />
                        </td>
                        <th>사업부명</th>
                        <td>
                            <label id="lblBusinNm"><%=businessCodeNm %></label></td>
                    </tr>
                    <tr>
                        <th>부서코드</th>
                        <td>
                            <input type="text" id="txtDeptCode" class="medium-size" value="<%=deptCode %>" readonly="readonly" placeholder="부서코드를 선택해 주세요" />
                            <%--<a class="imgA" onclick="fnAddDeptPopOpen()">
                            <img src="../../AdminSub/Images/Goods/search-bt-off.jpg" onmouseover="this.src='../../AdminSub/Images/Goods/search-bt-on.jpg'" onmouseout="this.src='../../AdminSub/Images/Goods/search-bt-off.jpg'" alt="검색" class="search-img" /></a>--%>
                            <input type="button" class="mainbtn type1" style="width:75px;" onclick="fnAddDeptPopOpen();" value="검색" />
                        </td>
                        <th>부서명</th>
                        <td>
                            <label id="lblDeptNm"><%=deptCodeNm %></label></td>
                    </tr>
                </table>
            </div>

            <%--세금계산서 발행정보 영역--%>
            <div class="memberB-div" style="margin-top: 30px">
                <div class="admin-maincontents-subtitle">
                    <span>*세금계산서 발행정보</span>
                </div>
                <table class="tbl_main">
                    <colgroup>
                        <col style="width:20%"/>
                        <col style="width:30%"/>
                        <col style="width:20%"/>
                        <col style="width:30%"/>
                    </colgroup>
                    <tr>
                        <th>담당자명
                        <input type="hidden" id="hdBillUserNm" value="<%=billUserNm %>" />
                            <input type="hidden" id="hdBillTel" value="<%=billTel %>" />
                            <input type="hidden" id="hdBillFax" value="<%=billFax %>" />
                            <input type="hidden" id="hdBillEmail" value="<%=billEmail %>" />
                            <input type="hidden" id="hdBillUptae" value="<%=uptae %>" />
                            <input type="hidden" id="hdBillUpjong" value="<%=upjong %>" />
                            <input type="hidden" id="hdSvidRole" />

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
                        <th>Email<br />
                            (전자세금계산서 발행)</th>
                        <td colspan="3" id="tdBillEmail"><%=billEmail %></td>
                    </tr>
                </table>
            </div>


            <!--저장버튼-->
            <div class="bt-align-div">
                <input type="button" class="mainbtn type1" style="width: 95px; height: 30px;" value="목록" onclick="location.href = 'MemberMain_A.aspx?ucode=' + ucode; return false;" />
                <input type="button" class="mainbtn type1" style="width: 95px; height: 30px;" value="승인" onclick="fnUserConfirm(); return false;" />
            </div>
            <!--저장버튼끝-->




            <%--///////////////////////////////팝업창 시작///////////////////////////////////////////////////////////--%>

            <!--회사구분코드 팝업창영역 시작-->
            <div id="companyClassifyDiv" class="divpopup-layer-package">
                <div class="popupdivWrapper" style="width: 700px; height: 520px;">
                    <div class="popupdivContents" style="border: none;">
                        <div class="divpopup-layer-conts">
                            <div class="close-div"><a onclick="fnClosePopup('companyClassifyDiv');" style="cursor: pointer">
                                <img src="../../Images/Wish/icon-delete.jpg" alt="닫기" style="float: right;" /></a></div>
                            <div class="popup-title">
                                <%--<img src="../Images/Member/codeClassify-title.jpg" alt="회사구분코드검색"/>  --%>
                                <h3 class="pop-title">회사구분코드검색</h3>
                                <!--팝업 컨텐츠 영역 시작-->
                                <div class="popup-div-top">
                                    <table id="tblPopGubunCode" class="tbl_main">
                                        <tr>
                                            <th style="width: 40px;">선택</th>
                                            <th>회사구분명</th>
                                            <td style="width: 30%;">
                                                <input type="text" id="txtPopGubunNm" style="width: 99%" /></td>
                                            <th>회사구분코드</th>
                                            <td style="width: 18%;">
                                                <input type="text" id="txtPopGubunCode" readonly="readonly" tabindex="-1" style="width: 99%" /></td>
                                            <td id="tdGubunFlag" style="width: 70px" class="text-center">데이터있음</td>
                                        </tr>
                                        <tr>
                                            <th colspan="2">비고</th>
                                            <td colspan="4">
                                                <input type="text" id="txtPopGubunRemark" style="width: 99%" /></td>
                                        </tr>
                                    </table>
                                </div>
                                <div class="popup-div-bottom">
                                    <table id="tblPopGubunList" class="tbl_main tbl_pop">
                                        <thead>
                                            <tr>
                                                <th>선택</th>
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
                                <div class="bt-align-div">
                                    <%--<asp:ImageButton runat="server" AlternateText="코드명수정" OnClientClick="fnPopGubunModifyCode(); return false;" ImageUrl="../Images/Member/codemodify-off.jpg" onmouseover="this.src='../Images/Member/codemodify-on.jpg'" onmouseout="this.src='../Images/Member/codemodify-off.jpg'"/>
                                <asp:ImageButton runat="server" AlternateText="코드생성" OnClientClick="fnPopGubunNewCode(); return false;" ImageUrl="../Images/Member/createcode-off.jpg" onmouseover="this.src='../Images/Member/createcode-on.jpg'" onmouseout="this.src='../Images/Member/createcode-off.jpg'"/>
                                <asp:ImageButton runat="server" AlternateText="확인" OnClientClick="fnPopGubunOK(); return false;" ImageUrl="../Images/Member/submit-off.jpg" onmouseover="this.src='../Images/Member/submit-on.jpg'" onmouseout="this.src='../Images/Member/submit-off.jpg'"/>--%>
                                    <input type="button" class="mainbtn type1" onclick="fnPopGubunModifyCode();" value="코드명수정" />
                                    <input type="button" class="mainbtn type1" onclick="fnPopGubunNewCode();" value="코드생성" />
                                    <input type="button" class="mainbtn type1" onclick="fnPopGubunOK();" value="확인" />
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <!--팝업창영역 끝-->




        <!--회사코드 팝업창영역 시작-->
        <div id="companyCodeDiv" class="divpopup-layer-package">
            <div class="popupdivWrapper" style="width: 700px; height: 520px;">
                <div class="popupdivContents" style="border: none;">
                    <div class="divpopup-layer-conts">
                        <div class="close-div"><a onclick="fnClosePopup('companyCodeDiv');" style="cursor: pointer">
                            <img src="../../Images/Wish/icon-delete.jpg" alt="닫기" style="float: right;" /></a></div>
                        <div class="popup-title">
                            <%-- <img src="../Images/Member/code-title.jpg" alt="회사코드검색"/>       --%>
                            <h3 class="pop-title">회사코드검색</h3>

                            <!--팝업 컨텐츠 영역 시작-->
                            <div class="popup-div-top">
                                <table class="tbl_main">
                                    <tr>
                                        <th style="width: 40px;">선택</th>
                                        <th>회사명</th>
                                        <td style="width: 30%;">
                                            <input type="text" id="txtPopCompNm" style="width: 99%" /></td>
                                        <th>회사코드</th>
                                        <td style="width: 20%;">
                                            <input type="text" id="txtPopCompCode" readonly="readonly" tabindex="-1" style="width: 99%" /></td>
                                        <td id="tdCompFlag" style="width: 70px" class="text-center">데이터있음</td>
                                    </tr>
                                    <tr>
                                        <th colspan="2">비고</th>
                                        <td colspan="4">
                                            <input type="text" id="txtPopCompRemark" style="width: 99%" /></td>
                                    </tr>
                                </table>
                            </div>
                            <div class="popup-div-bottom">
                                <table id="tblPopCompList" class="tbl_main tbl_pop">
                                    <thead>
                                        <tr>
                                            <th>선택</th>
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
                            <div class="bt-align-div">
                                <%--<asp:ImageButton runat="server" AlternateText="코드명수정" OnClientClick="fnPopCompModifyCode(); return false;" ImageUrl="../Images/Member/codemodify-off.jpg" onmouseover="this.src='../Images/Member/codemodify-on.jpg'" onmouseout="this.src='../Images/Member/codemodify-off.jpg'"/>
                            <asp:ImageButton runat="server" AlternateText="코드생성" OnClientClick="fnPopCompNewCode(); return false;" ImageUrl="../Images/Member/createcode-off.jpg" onmouseover="this.src='../Images/Member/createcode-on.jpg'" onmouseout="this.src='../Images/Member/createcode-off.jpg'"/>
                            <asp:ImageButton runat="server" AlternateText="확인" OnClientClick="fnPopCompOK(); return false;" ImageUrl="../Images/Member/submit-off.jpg" onmouseover="this.src='../Images/Member/submit-on.jpg'" onmouseout="this.src='../Images/Member/submit-off.jpg'"/>--%>
                                <input type="button" class="mainbtn type1" onclick="fnPopCompModifyCode();" value="코드명수정" />
                                <input type="button" class="mainbtn type1" onclick="fnPopCompNewCode();" value="코드생성" />
                                <input type="button" class="mainbtn type1" onclick="fnPopCompOK();" value="확인" />
                            </div>
                            <!--버튼영역끝 -->
                            <!--팝업 컨텐츠 영역끝-->
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <!--팝업창영역 끝-->

    <!--사업장 팝업창영역 시작-->
    <div id="workplaceCodeDiv" class="divpopup-layer-package">
        <div class="popupdivWrapper" style="width: 700px; height: 520px;">
            <div class="popupdivContents" style="border: none;">
                <div class="close-div"><a onclick="fnClosePopup('workplaceCodeDiv');" style="cursor: pointer">
                    <img src="../../Images/Wish/icon-delete.jpg" alt="닫기" style="float: right;" /></a></div>
                <div class="popup-title">
                    <%--<img src="../Images/Member/business-title2.jpg" alt="사업장검색" />--%>
                    <h3 class="pop-title">사업장검색</h3>

                    <!--팝업 컨텐츠 영역 시작-->
                    <div class="popup-div-top">
                        <table class="tbl_main">
                            <tr>
                                <th style="width: 40px;">선택</th>
                                <th>사업장명</th>
                                <td style="width: 30%;">
                                    <input type="text" id="txtPopAreaNm" style="width: 99%" /></td>
                                <th>사업장코드</th>
                                <td style="width: 20%;">
                                    <input type="text" id="txtPopAreaCode" readonly="readonly" tabindex="-1" style="width: 99%" /></td>
                                <td id="tdAreaFlag" style="width: 70px" class="text-center">데이터있음</td>
                            </tr>
                            <tr>
                                <th colspan="2">비고</th>
                                <td colspan="4">
                                    <input type="text" id="txtPopAreaRemark" style="width: 99%" /></td>
                            </tr>
                        </table>
                    </div>
                    <div class="popup-div-bottom">
                        <table id="tblPopAreaList" class="tbl_main tbl_pop">
                            <thead>
                                <tr>
                                    <th>선택</th>
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
                    <div class="bt-align-div">
                        <%--<asp:ImageButton runat="server" AlternateText="코드명수정" OnClientClick="fnPopAreaModifyCode(); return false;" ImageUrl="../Images/Member/codemodify-off.jpg" onmouseover="this.src='../Images/Member/codemodify-on.jpg'" onmouseout="this.src='../Images/Member/codemodify-off.jpg'"/>
                        <asp:ImageButton runat="server" AlternateText="코드생성" OnClientClick="fnPopAreaNewCode(); return false;" ImageUrl="../Images/Member/createcode-off.jpg" onmouseover="this.src='../Images/Member/createcode-on.jpg'" onmouseout="this.src='../Images/Member/createcode-off.jpg'"/>
                        <asp:ImageButton runat="server" AlternateText="확인" OnClientClick="fnPopAreaOK(); return false;" ImageUrl="../Images/Member/submit-off.jpg" onmouseover="this.src='../Images/Member/submit-on.jpg'" onmouseout="this.src='../Images/Member/submit-off.jpg'"/>--%>
                        <input type="button" class="mainbtn type1" onclick="fnPopAreaModifyCode();" value="코드명수정" />
                        <input type="button" class="mainbtn type1" onclick="fnPopAreaNewCode();" value="코드생성" />
                        <input type="button" class="mainbtn type1" onclick="fnPopAreaOK();" value="확인" />
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
        <div class="popupdivWrapper" style="width: 700px; height: 520px;">
            <div class="popupdivContents" style="border: none;">
                <div class="divpopup-layer-conts">
                    <div class="close-div"><a onclick="fnClosePopup('divisionCodeDiv');" style="cursor: pointer">
                        <img src="../../Images/Wish/icon-delete.jpg" alt="닫기" style="float: right;" /></a></div>
                    <div class="popup-title">
                        <%--<img src="../Images/Member/business-title1.jpg" alt="사업부검색" />--%>
                        <h3 class="pop-title">사업부검색</h3>

                        <!--팝업 컨텐츠 영역 시작-->
                        <div class="popup-div-top">
                            <table class="tbl_main">
                                <tr>
                                    <th style="width: 40px;">선택</th>
                                    <th>사업부코드</th>
                                    <td style="width: 30%;">
                                        <input type="text" id="txtPopBusinNm" style="width: 99%" /></td>
                                    <th>사업부명</th>
                                    <td style="width: 20%;">
                                        <input type="text" id="txtPopBusinCode" readonly="readonly" tabindex="-1" style="width: 99%" /></td>
                                    <td id="tdBusinFlag" style="width: 70px" class="text-center">데이터있음</td>
                                </tr>
                                <tr>
                                    <th colspan="2">비고</th>
                                    <td colspan="4">
                                        <input type="text" id="txtPopBusinRemark" style="width: 99%" /></td>
                                </tr>
                            </table>
                        </div>

                        <div class="popup-div-bottom">
                            <table id="tblPopBusinList" class="tbl_main tbl_pop">
                                <thead>
                                    <tr>
                                        <th>선택</th>
                                        <th>사업부명</th>
                                        <th>사업부코드</th>
                                        <th>비고</th>
                                        <th>등록날짜</th>
                                    </tr>
                                </thead>
                                <tbody id="tbodyPopBusinList"></tbody>
                            </table>
                        </div>

                        <!--코드명생성,코드생성, 확인 버튼 영역-->
                        <div class="bt-align-div">
                            <%-- <asp:ImageButton runat="server" AlternateText="코드명수정" OnClientClick="fnPopBusinessModifyCode(); return false;" ImageUrl="../Images/Member/codemodify-off.jpg" onmouseover="this.src='../Images/Member/codemodify-on.jpg'" onmouseout="this.src='../Images/Member/codemodify-off.jpg'"/>
                            <asp:ImageButton runat="server" AlternateText="코드생성" OnClientClick="fnPopBusinessNewCode(); return false;" ImageUrl="../Images/Member/createcode-off.jpg" onmouseover="this.src='../Images/Member/createcode-on.jpg'" onmouseout="this.src='../Images/Member/createcode-off.jpg'"/>
                            <asp:ImageButton runat="server" AlternateText="확인" OnClientClick="fnPopBusinessOK(); return false;" ImageUrl="../Images/Member/submit-off.jpg" onmouseover="this.src='../Images/Member/submit-on.jpg'" onmouseout="this.src='../Images/Member/submit-off.jpg'"/>--%>
                            <input type="button" class="mainbtn type1" onclick="fnPopBusinessModifyCode();" value="코드명수정" />
                            <input type="button" class="mainbtn type1" onclick="fnPopBusinessNewCode();" value="코드생성" />
                            <input type="button" class="mainbtn type1" onclick="fnPopBusinessOK();" value="확인" />
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
        <div class="popupdivWrapper" style="width: 700px; height: 520px;">
            <div class="popupdivContents" style="border: none;">
                <div class="divpopup-layer-conts">
                    <div class="close-div"><a onclick="fnClosePopup('deptCodeDiv');" style="cursor: pointer">
                        <img src="../../Images/Wish/icon-delete.jpg" alt="닫기" style="float: right;" /></a></div>
                    <div class="popup-title">
                        <%--<img src="../Images/Member/dept-ttile.jpg" alt="부서코드"/>--%>
                        <h3 class="pop-title">부서코드</h3>

                        <!--팝업 컨텐츠 영역 시작-->
                        <div class="popup-div-top">
                            <table class="tbl_main">
                                <tr>
                                    <th style="width: 40px;">선택</th>
                                    <th>부서코드</th>
                                    <td style="width: 30%;">
                                        <input type="text" id="txtPopDeptNm" style="width: 99%" /></td>
                                    <th>부서명</th>
                                    <td style="width: 20%;">
                                        <input type="text" id="txtPopDeptCode" readonly="readonly" tabindex="-1" style="width: 99%" /></td>
                                    <td id="tdDeptFlag" style="width: 70px" class="text-center">데이터있음</td>
                                </tr>
                                <tr>
                                    <th colspan="2">비고</th>
                                    <td colspan="4">
                                        <input type="text" id="txtPopDeptRemark" style="width: 99%" /></td>
                                </tr>
                            </table>
                        </div>
                        <div class="popup-div-bottom">
                            <table id="tblPopDeptList" class="tbl_main tbl_pop">
                                <thead>
                                    <tr>
                                        <th>선택</th>
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
                        <div class="bt-align-div">
                            <%--<asp:ImageButton runat="server" AlternateText="코드명수정" OnClientClick="fnPopDeptModifyCode(); return false;" ImageUrl="../Images/Member/codemodify-off.jpg" onmouseover="this.src='../Images/Member/codemodify-on.jpg'" onmouseout="this.src='../Images/Member/codemodify-off.jpg'"/>
                        <asp:ImageButton runat="server" AlternateText="코드생성" OnClientClick="fnPopDeptNewCode(); return false;" ImageUrl="../Images/Member/createcode-off.jpg" onmouseover="this.src='../Images/Member/createcode-on.jpg'" onmouseout="this.src='../Images/Member/createcode-off.jpg'"/>
                        <asp:ImageButton runat="server" AlternateText="확인" OnClientClick="fnPopDeptOK(); return false;" ImageUrl="../Images/Member/submit-off.jpg" onmouseover="this.src='../Images/Member/submit-on.jpg'" onmouseout="this.src='../Images/Member/submit-off.jpg'"/>--%>
                            <input type="button" class="mainbtn type1" onclick="fnPopDeptModifyCode();" value="코드명수정" />
                            <input type="button" class="mainbtn type1" onclick="fnPopDeptNewCode();" value="코드생성" />
                            <input type="button" class="mainbtn type1" onclick="fnPopDeptOK();" value="확인" />
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

