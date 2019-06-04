<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Master/AdminMasterPage.master" AutoEventWireup="true" CodeFile="UserInfoManagement.aspx.cs" Inherits="Admin_User_UserInfoManagement" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <style>
        table {
        border: 1px solid #444444;
        border-collapse: collapse;
        }
        th, td {
        border: 1px solid #444444;
        }

        .tabHeaderWrap { border-bottom:2px solid #272D66; height: 30px; margin-bottom: 10px; min-width: 300px;  }
        .tabHeaderWrap a { float: left; display: block; margin-right: 1px; background: #ccc; color: #666; margin-top: 2px; height: 28px; line-height: 30px; padding:0 10px; border-radius: 5px 5px 0 0; text-decoration:none}
        .tabHeaderWrap a:hover { background: #eee; text-decoration:none}
        .tabHeaderWrap a.on { border:2px solid #272D66; border-bottom: none; background: #fff;  color: #000; font-weight: bold; height: 30px; margin-top: 0;  text-decoration:none}

    </style>
    <script type="text/javascript">
        //document ready 시작
        $(document).ready(function () {

            //회사구분 정보 검색 창 
            $("#socialCompDialog").dialog({
                autoOpen: false,
                height: 700,
                width: 800,
                modal: true,
                buttons: {
                    '수정': function () {
                        var socialCompName = $.trim($('#<%= txtModalSocialCompName.ClientID%>').val());
                        var socialCompCode = $('#<%= hfSelectSocialCompCode.ClientID%>').val();
                        var remark = $('#<%= txtModalSocialCompRemark.ClientID%>').val();
                        var gubun = $('#<%= hfGubun.ClientID%>').val();

                        if (socialCompName == '') {
                            alert('회사구분명을 입력해 주세요.');
                            $('#<%= txtModalSocialCompName.ClientID%>').focus();
                            return false;
                        }

                        var modalSocialCompCode = $('#<%= txtModalSocialCompCode.ClientID%>').val();

                        if (socialCompCode != modalSocialCompCode) {
                            alert("수정을 요청하신 코드는 현재 사용자에게 설정된 코드값이 아닙니다.\n해당 코드를 최종 선택하신 후 다시 시도해 주시기 바랍니다.");
                            return false;
                        }

                        // ajax callback 함수
                        var callback = function (response) {
                            var index = 0;

                            $('#tbSocialCompList').find('tr:gt(0)').remove(); //테이블 클리어
                            
                            if (!isEmpty(response)) {

                                $.each(response, function (key, value) { //테이블 추가
                                    var newRowContent = "<tr><td><input id='cbSocialCompCheck" + index + " ' type='checkbox'><input id='hfSocialCompCode" + index + "' type='hidden' value='" + value.SocialCompany_Code + "'><input id='hfSocialCompName" + index + "' type='hidden' value='" + value.SocialCompany_Name + "'></td>";
                                    newRowContent += "<td> " + value.SocialCompany_Code + " </td><td>" + value.SocialCompany_Name + "</td><td>" + value.Remark + "</td></tr>";
                                    $('#tbSocialCompList tr:last').after(newRowContent);
                                    index++;
                                });

                                if (index > 0) {
                                    alert("수정되었습니다.");

                                    var socialCompName = $('#<%= txtModalSocialCompName.ClientID%>').val();
                                    var socialCompCode = $('#<%= txtModalSocialCompCode.ClientID%>').val();

                                    
                                    $('#<%= lblSocialCompName.ClientID%>').text(socialCompName);
                                    $('#<%= hfSelectSocialCompName.ClientID%>').text(socialCompName);
                                }
                            }
                            else {
                                $('#tbSocialCompList tr:last').after("<tr><td colspan='4'>데이터가 없습니다</td></tr>");
                            }
                        };

                        var param = { SocialCompCode: socialCompCode, SocialCompName: socialCompName, Remark: remark, Gubun: gubun, Method: 'SocialCompNameUpdate' }; // ajax 파라미터

                        Jajax("Post", "../../Handler/Admin/SocialCompanyHandler.ashx", param, "json", callback); // 회사구분 수정 ajax 호출
                    },
                    '코드생성': function () {
                        var selectSocialCompCode = $('#<%= hfSelectSocialCompCode.ClientID%>').val();
                        var socialCompName = $.trim($('#<%= txtModalSocialCompName.ClientID%>').val());
                        var remark = $('#<%= txtModalSocialCompRemark.ClientID%>').val();

                        if (socialCompName == '') {
                            alert('회사구분명을 입력해 주세요.');
                            $('#<%= txtModalSocialCompName.ClientID%>').focus();
                            return false;
                        }

                        // ajax callback 함수
                        var callback = function (response) {
                            var index = 0;

                            $('#tbSocialCompList').find('tr:gt(0)').remove(); //테이블 클리어

                            if (!isEmpty(response)) {
                                var socialCompCode = ""; // 새 회사구분코드

                                $.each(response, function (key, value) { //테이블 추가

                                    // 새로 생성된 코드값 변수에 저장
                                    if (index == 0) {
                                        socialCompCode = value.NewCode;
                                        $('#<%= txtModalSocialCompCode.ClientID%>').val(socialCompCode); // 생성된 코드를 텍스트박스에 넣어준다
                                    }

                                    var newRowContent = "<tr><td><input id='cbSocialCompCheck" + index + " ' type='checkbox'><input id='hfSocialCompCode" + index + "' type='hidden' value='" + value.SocialCompany_Code + "'><input id='hfSocialCompName" + index + "' type='hidden' value='" + value.SocialCompany_Name + "'></td>";
                                    newRowContent += "<td> " + value.SocialCompany_Code + " </td><td>" + value.SocialCompany_Name + "</td><td>" + value.Remark + "</td></tr>";
                                    $('#tbSocialCompList tr:last').after(newRowContent);
                                    index++;
                                });

                                if (index > 0) {
                                    alert("저장되었습니다.");
                                }
                            }
                            else {
                                $('#tbSocialCompList tr:last').after("<tr><td colspan='4'>데이터가 없습니다</td></tr>");
                            }
                        };

                        var param = { Gubun: $('#<%= hfGubun.ClientID%>').val(), SocialCompName: socialCompName, Remark: remark, Method: 'SocialCompCodeGenerate' }; // ajax 파라미터

                        Jajax("Post", "../../Handler/Admin/SocialCompanyHandler.ashx", param, "json", callback); // 회사구분코드 생성 ajax 호출

                    },
                    '확인': function () {

                        //선택한 코드와 회사구분코드명을 부모창에 뿌려줌
                        $('#divSocialCompList input[type="checkbox"]').each(function () {
                            if ($(this).prop('checked') == true) {

                                var code = $(this).next('input').val();
                                var name = $(this).next('input').next('input').val();

                                var oldSocialCompCode = $('#<%= hfSelectSocialCompCode.ClientID%>').val(); // 기존 코드

                                // 선택한 코드값으로 보여주기
                                $('#<%= txtSocialCompCode.ClientID%>').val(code);
                                $('#<%= hfSelectSocialCompCode.ClientID%>').val(code);
                                $('#<%= lblSocialCompName.ClientID%>').text(name);
                                $('#<%= hfSelectSocialCompName.ClientID%>').val(name);
                            }
                        });

                        $("#socialCompDialog").dialog("close");

                    },
                },

                open: function (type, data) {

                },

                close: function () {
                }
            });
            
            //회사 정보 검색 창 
            $("#companyDialog").dialog({
                autoOpen: false,
                height: 700,
                width: 800,
                modal: true,
                buttons: {
                    '수정': function () {
                        var companyName = $.trim($('#<%= txtModalComapnyName.ClientID%>').val());
                        var companyCode = $('#<%= hfSelectCompanyCode.ClientID%>').val();
                        var companyNo = $('#<%= hfCompanyNo.ClientID%>').val();
                        var remark = $('#<%= txtModalComanyRemark.ClientID%>').val();

                        if (companyName == '') {
                            alert('회사명을 입력해 주세요.');
                            $('#<%= txtModalComapnyName.ClientID%>').focus();
                            return false;
                        }

                        var modalCompCode = $('#<%= txtModalCompanyCode.ClientID%>').val();

                        if (companyCode != modalCompCode) {
                            alert("수정을 요청하신 코드는 현재 사용자에게 설정된 코드값이 아닙니다.\n해당 코드를 최종 선택하신 후 다시 시도해 주시기 바랍니다.");
                            return false;
                        }

                        // ajax callback 함수
                        var callback = function (response) {
                            var index = 0;
                            
                            $('#tbComapanyList').find('tr:gt(0)').remove(); //테이블 클리어
                            
                            if (!isEmpty(response)) {

                                $.each(response, function (key, value) { //테이블 추가
                                    var newRowContent = "<tr><td><input id='cbCompCheck" + index + " ' type='checkbox'><input id='hfCompCode" + index + "' type='hidden' value='" + value.Company_Code + "'><input id='hfCompName" + index + "' type='hidden' value='" + value.Company_Name + "'><input id='hfDelFlag" + index + "' type='hidden' value='" + value.DelFlag + "'></td>";
                                    newRowContent += "<td> " + value.Company_Code + " </td><td>" + value.Company_Name + "</td><td>" + value.Remark + "</td></tr>";
                                    $('#tbComapanyList tr:last').after(newRowContent);
                                    index++;
                                });

                                if (index > 0) {
                                    alert("수정되었습니다.");

                                    var companyCode = $('#<%= txtModalCompanyCode.ClientID%>').val();
                                    var companyName = $.trim($('#<%= txtModalComapnyName.ClientID%>').val());

                                    $('#<%= lblCompanyName.ClientID%>').text(companyName);
                                    $('#<%= hfSelectCompanyName.ClientID%>').text(companyName);
                                }
                            }
                            else {
                                $('#tbComapanyList tr:last').after("<tr><td colspan='4'>데이터가 없습니다</td></tr>");
                            }
                        };

                        var param = { CompanyCode: companyCode, CompanyName: companyName, CompanyNo: companyNo, Remark: remark, Flag: 'Update' }; // ajax 파라미터

                        Jajax("Post", "../../Handler/Admin/CompanyHandler.ashx", param, "json", callback); // 회사명 수정 ajax 호출
                    },
                    '코드생성': function () {
                        var companyName = $.trim($('#<%= txtModalComapnyName.ClientID%>').val());
                        var remark = $('#<%= txtModalComanyRemark.ClientID%>').val();
                        var companyNo = $('#<%= hfCompanyNo.ClientID%>').val();

                        if (companyName == '') {
                            alert('회사명을 입력해 주세요.');
                            $('#<%= txtModalComapnyName.ClientID%>').focus();
                            return false;
                        }
                        
                        // ajax callback 함수
                        var callback = function (response) {
                            var index = 0;

                            $('#tbComapanyList').find('tr:gt(0)').remove(); //테이블 클리어

                            if (!isEmpty(response)) {
                                var compCode = ""; // 새 회사코드

                                $.each(response, function (key, value) { //테이블 추가
                                    
                                    // 새로 생성된 코드값 변수에 저장
                                    if (index == 0) {
                                        compCode = value.NewCode;
                                        $('#<%= txtModalCompanyCode.ClientID%>').val(compCode); // 생성된 코드를 텍스트박스에 넣어준다
                                    }
                                    
                                    var newRowContent = "<tr><td><input id='cbCompCheck" + index + " ' type='checkbox'><input id='hfCompCode" + index + "' type='hidden' value='" + value.Company_Code + "'><input id='hfCompName" + index + "' type='hidden' value='" + value.Company_Name + "'><input id='hfDelFlag" + index + "' type='hidden' value='" + value.DelFlag + "'></td>";
                                    newRowContent += "<td> " + value.Company_Code + " </td><td>" + value.Company_Name + "</td><td>" + value.Remark + "</td></tr>";
                                    $('#tbComapanyList tr:last').after(newRowContent);
                                    index++;
                                });

                                if (index > 0) {
                                    alert("저장되었습니다.");
                                }
                            }
                            else {
                                $('#tbComapanyList tr:last').after("<tr><td colspan='4'>데이터가 없습니다</td></tr>");
                            }
                        };

                        var param = { CompanyName: companyName, CompanyNo: companyNo, Gubun: 'B', Remark: remark, Flag: 'Create' }; // ajax 파라미터

                        Jajax("Post", "../../Handler/Admin/CompanyHandler.ashx", param, "json", callback); // 회사코드 생성 ajax 호출
                        
                    },
                    '확인': function () {
                        
                        //선택한 코드와 회사명을 부모창에 뿌려줌
                        $('#divCompanyList input[type="checkbox"]').each(function () {
                            if ($(this).prop('checked') == true) {

                                var code = $(this).next('input').val();
                                var name = $(this).next('input').next('input').val();
                                var delFlag = $(this).next('input').next('input').next('input').val();

                                var oldCompCode = $('#<%= hfSelectCompanyCode.ClientID%>').val(); // 기존 코드

                                // 하위 코드의 입력창 초기화
                                if (oldCompCode != code) {
                                    $('#<%= txtAreaCode.ClientID%>').val("");
                                    $('#<%= txtBusinessCode.ClientID%>').val("");
                                    $('#<%= txtDeptCode.ClientID%>').val("");

                                    $('#<%= hfSelectAreaCode.ClientID%>').val("");
                                    $('#<%= hfSelectBusinessCode.ClientID%>').val("");
                                    $('#<%= hfSelectDeptCode.ClientID%>').val("");

                                    $('#<%= hfSelectAreaName.ClientID%>').val("");
                                    $('#<%= hfSelectBusinessName.ClientID%>').val("");
                                    $('#<%= hfSelectDeptName.ClientID%>').val("");

                                    $('#<%= lblAreaName.ClientID%>').text("");
                                    $('#<%= lblBusinessName.ClientID%>').text("");
                                    $('#<%= lblDeptName.ClientID%>').text("");
                                }

                                // 선택한 코드값으로 보여주기
                                $('#<%= txtCompnayCode.ClientID%>').val(code);
                                $('#<%= hfSelectCompanyCode.ClientID%>').val(code);
                                $('#<%= lblCompanyName.ClientID%>').text(name);
                                $('#<%= hfSelectCompanyName.ClientID%>').val(name);
                                $('#<%= hfSelectCompDelFlag.ClientID%>').val(delFlag);

                                // 회사거래중지여부 라디오버튼
                                if (delFlag == 'Y') {
                                    $('#<%= rbnDelflagY.ClientID%>').attr("checked", true);
                                    $('#<%= rbnDelflagN.ClientID%>').attr("checked", false);
                                } else {
                                    $('#<%= rbnDelflagY.ClientID%>').attr("checked", false);
                                    $('#<%= rbnDelflagN.ClientID%>').attr("checked", true);
                                }
                            }
                        });
                        
                        $("#companyDialog").dialog("close");

                    },
                },

                open: function (type, data) {

                },

                close: function () {
                }
            });

            //사업장 정보 검색 창 
            $("#areaDialog").dialog({
                autoOpen: false,
                height: 700,
                width: 800,
                modal: true,
                buttons: {
                    '수정': function () {
                        var areaName = $.trim($('#<%= txtModalAreaName.ClientID%>').val());
                        var selectCompCode = $('#<%= hfSelectCompanyCode.ClientID%>').val();
                        var selectAreaCode = $('#<%= hfSelectAreaCode.ClientID%>').val();
                        var remark = $('#<%= txtModalAreaRemark.ClientID%>').val();

                        if (areaName == '') {
                            alert('사업장명을 입력해 주세요.');
                            $('#<%= txtModalAreaName.ClientID%>').focus();
                            return false;
                        }

                        var modalAreaCode = $('#<%= txtModalAreaCode.ClientID%>').val();
                        if (modalAreaCode != selectAreaCode) {
                            alert("수정을 요청하신 코드는 현재 사용자에게 설정된 코드값이 아닙니다.\n해당 코드를 최종 선택하신 후 다시 시도해 주시기 바랍니다.");
                            return false;
                        }
                        
                        // ajax callback 함수
                        var callback = function (response) {
                            var index = 0;

                            $('#tbAreaList').find('tr:gt(0)').remove(); //테이블 클리어

                            if (!isEmpty(response)) {
                                $.each(response, function (key, value) { //테이블 추가
                                    
                                    var newRowContent = "<tr><td><input id='cbCompCheck" + index + " ' type='checkbox'><input id='hfAreaCode" + index + "' type='hidden' value='" + value.CompanyArea_Code + "'><input id='hfAreaName" + index + "' type='hidden' value='" + value.CompanyArea_Name + "'></td>";
                                    newRowContent += "<td> " + value.CompanyArea_Code + " </td><td>" + value.CompanyArea_Name + "</td><td>" + value.Remark + "</td></tr>";
                                    $('#tbAreaList tr:last').after(newRowContent);
                                    index++;
                                });

                                if (index > 0) {
                                    alert("수정되었습니다.");
                                    
                                    var areaName = $.trim($('#<%= txtModalAreaName.ClientID%>').val());
                                    $('#<%= lblAreaName.ClientID%>').text(areaName);
                                    $('#<%= hfSelectAreaName.ClientID%>').val(areaName);
                                }
                            }
                            else {
                                $('#tbAreaList tr:last').after("<tr><td colspan='4'>데이터가 없습니다</td></tr>");
                            }

                        };

                        var param = { CompanyCode: selectCompCode, AreaCode: selectAreaCode, AreaName: areaName, Remark: remark, Flag: 'Update' }; // ajax 파라미터

                        Jajax("Post", "../../Handler/Admin/CompanyAreaHandler.ashx", param, "json", callback); // ajax 호출
                        
                    },
                    '코드생성': function () {
                        var areaName = $.trim($('#<%= txtModalAreaName.ClientID%>').val());
                        var areaRemark = $('#<%= txtModalAreaRemark.ClientID%>').val();
                        var selectCompCode = $('#<%= hfSelectCompanyCode.ClientID%>').val();

                        if (areaName == '') {
                            alert('사업장명을 입력해 주세요.');
                            $('#<%= txtModalAreaName.ClientID%>').focus();
                            return false;
                        }

                        // ajax callback 함수
                        var callback = function (response) {
                            var index = 0;

                            $('#tbAreaList').find('tr:gt(0)').remove(); //테이블 클리어

                            if (response != "") {
                                var areaCode = ""; // 새 사업장코드

                                $.each(response, function (key, value) { //테이블 추가

                                    // 새로 생성된 코드값 변수에 저장
                                    if (index == 0) {
                                        areaCode = value.NewCode;
                                        $('#<%= txtModalAreaCode.ClientID%>').val(areaCode); // 생성된 코드를 텍스트박스에 넣어준다
                                    }
                                    
                                    var newRowContent = "<tr><td><input id='cbCompCheck" + index + " ' type='checkbox'><input id='hfAreaCode" + index + "' type='hidden' value='" + value.CompanyArea_Code + "'><input id='hfAreaName" + index + "' type='hidden' value='" + value.CompanyArea_Name + "'></td>";
                                    newRowContent += "<td> " + value.CompanyArea_Code + " </td><td>" + value.CompanyArea_Name + "</td><td>" + value.Remark + "</td></tr>";
                                    $('#tbAreaList tr:last').after(newRowContent);
                                    index++;
                                });
                            }
                            else {
                                $('#tbAreaList tr:last').after("<tr><td colspan='4'>데이터가 없습니다</td></tr>");
                            }

                            if (index > 0) {
                                alert("저장되었습니다.");
                            }
                        };

                        var param = { CompanyCode: selectCompCode, AreaName: areaName, Remark: areaRemark, Flag: 'Create' }; // ajax 파라미터

                        Jajax("Post", "../../Handler/Admin/CompanyAreaHandler.ashx", param, "json", callback); // ajax 호출
                        
                    },

                    '확인': function () {
                        //선택한 코드와 사업장명을 부모창에 뿌려줌
                        $('#divAreaList input[type="checkbox"]').each(function () {
                            if ($(this).prop('checked') == true) {

                                var code = $(this).next('input').val();
                                var name = $(this).next('input').next('input').val();

                                var oldAreaCode = $('#<%= hfSelectAreaCode.ClientID%>').val(); // 기존 코드

                                // 하위 코드의 입력창 초기화
                                if (oldAreaCode != code) {
                                    $('#<%= txtBusinessCode.ClientID%>').val("");
                                    $('#<%= txtDeptCode.ClientID%>').val("");
                                    
                                    $('#<%= hfSelectBusinessCode.ClientID%>').val("");
                                    $('#<%= hfSelectDeptCode.ClientID%>').val("");

                                    $('#<%= hfSelectBusinessName.ClientID%>').val("");
                                    $('#<%= hfSelectDeptName.ClientID%>').val("");
                                    
                                    $('#<%= lblBusinessName.ClientID%>').text("");
                                    $('#<%= lblDeptName.ClientID%>').text("");
                                }

                                $('#<%= txtAreaCode.ClientID%>').val(code);
                                $('#<%= hfSelectAreaCode.ClientID%>').val(code);
                                $('#<%= hfSelectAreaName.ClientID%>').val(name);
                                $('#<%= lblAreaName.ClientID%>').text(name);
                            }
                        });

                        $("#areaDialog").dialog("close");
                    },
                },

                open: function (type, data) {
                },

                close: function () {
                    //location.reload();
                }
            });

            //사업부 코드 검색창
            $("#businessDeptDialog").dialog({
                autoOpen: false,
                height: 700,
                width: 800,
                modal: true,
                buttons: {
                    '수정': function () {
                        var BusinessDeptName = $.trim($('#<%= txtModalBusinessDeptName.ClientID%>').val()); //사업부이름
                        var selectCompCode = $('#<%= hfSelectCompanyCode.ClientID%>').val();  //회사코드
                        var txtAreaCode = $('#<%= hfSelectAreaCode.ClientID%>').val();   //사업장 코드
                        var CompBusinessCode = $('#<%= hfSelectBusinessCode.ClientID%>').val();  //사업부 코드
                        var remark = $('#<%= txtModalBusinessDeptRemark.ClientID%>').val();
                        
                        if (BusinessDeptName == '') {
                            alert('사업부명을 입력해 주세요.');
                            $('#<%= txtModalBusinessDeptName.ClientID%>').focus();
                            return false;
                        }

                        var modalBusinessCode = $('#<%= txtModalBusinessDeptCode.ClientID%>').val();
                        if (modalBusinessCode != CompBusinessCode) {
                            alert("수정을 요청하신 코드는 현재 사용자에게 설정된 코드값이 아닙니다.\n해당 코드를 최종 선택하신 후 다시 시도해 주시기 바랍니다.");
                            return false;
                        }

                        // ajax callback 함수
                        var callback = function (response) {
                            $('#tbBusinessList').find('tr:gt(0)').remove(); //테이블 클리어

                            var index = 0;

                            if (!isEmpty(response)) {
                                
                                $.each(response, function (key, value) { //테이블 추가
                                    var newRowContent = "<tr><td><input id='cbCompCheck" + index + " ' type='checkbox'><input id='hfBusinessDeptCode" + index + "' type='hidden' value='" + value.CompBusinessDept_Code + "'><input id='hfBusinessDeptName" + index + "' type='hidden' value='" + value.CompBusinessDept_Name + "'></td>";
                                    newRowContent += "<td> " + value.CompBusinessDept_Code + " </td><td>" + value.CompBusinessDept_Name + "</td><td>" + value.Remark + "</td></tr>";
                                    $('#tbBusinessList tr:last').after(newRowContent);
                                    index++;
                                });

                                if (index > 0) {
                                    alert("수정되었습니다.");

                                    var businessName = $.trim($('#<%= txtModalBusinessDeptName.ClientID%>').val());
                                    $('#<%= lblBusinessName.ClientID%>').text(businessName);
                                    $('#<%= hfSelectBusinessName.ClientID%>').text(businessName);
                                }
                            }
                            else {
                                $('#tbBusinessList tr:last').after("<tr><td colspan='4'>데이터가 없습니다</td></tr>");
                            }
                        };

                        var param = { CompanyCode: selectCompCode, AreaCode: txtAreaCode, BusinessCode: CompBusinessCode, BusinessName: BusinessDeptName, Remark: remark, Flag: 'Update' };

                        Jajax("Post", "../../Handler/Admin/CompBusinessHandler.ashx", param, "json", callback); // ajax 호출
                        
                    },
                    '코드생성': function () {
                        var BusinessDeptName = $.trim($('#<%= txtModalBusinessDeptName.ClientID%>').val());
                        var BusinessDeptRemark = $('#<%= txtModalBusinessDeptRemark.ClientID%>').val();
                        var selectCompCode = $('#<%= hfSelectCompanyCode.ClientID%>').val();
                        var selectAreaCode = $('#<%= hfSelectAreaCode.ClientID%>').val();

                        if (BusinessDeptName == '') {
                            alert('사업부명을 입력해 주세요.');
                            $('#<%= txtModalBusinessDeptName.ClientID%>').focus();
                            return false;
                        }
                        
                        // ajax callback 함수
                        var callback = function (response) {
                            $('#tbBusinessList').find('tr:gt(0)').remove(); //테이블 클리어

                            var index = 0;

                            if (!isEmpty(response)) {
                                var businessCode = ""; // 새 사업부코드

                                $.each(response, function (key, value) { //테이블 추가

                                    // 새로 생성된 코드값 변수에 저장
                                    if (index == 0) {
                                        businessCode = value.NewCode;
                                        $('#<%= txtModalBusinessDeptCode.ClientID%>').val(businessCode); // 생성된 코드를 텍스트박스에 넣어준다
                                    }
                                    
                                    var newRowContent = "<tr><td><input id='cbCompCheck" + index + " ' type='checkbox'><input id='hfBusinessDeptCode" + index + "' type='hidden' value='" + value.CompBusinessDept_Code + "'><input id='hfBusinessDeptName" + index + "' type='hidden' value='" + value.CompBusinessDept_Name + "'></td>";
                                    newRowContent += "<td> " + value.CompBusinessDept_Code + " </td><td>" + value.CompBusinessDept_Name + "</td><td>" + value.Remark + "</td></tr>";
                                    $('#tbBusinessList tr:last').after(newRowContent);
                                    index++;
                                });

                                if (index > 0) {
                                    alert("저장되었습니다.");
                                }
                            }
                            else {
                                $('#tbBusinessList tr:last').after("<tr><td colspan='4'>데이터가 없습니다</td></tr>");
                            }
                        };

                        var param = { CompanyCode: selectCompCode, AreaCode: selectAreaCode, BusinessName: BusinessDeptName, Remark: BusinessDeptRemark, Flag: 'Create' };

                        Jajax("Post", "../../Handler/Admin/CompBusinessHandler.ashx", param, "json", callback); // ajax 호출
                        
                    },

                    '확인': function () {
                        //선택한 코드와 사업부명을 부모창에 뿌려줌
                        $('#divBusinessList input[type="checkbox"]').each(function () {
                            if ($(this).prop('checked') == true) {
                                var code = $(this).next('input').val();
                                var name = $(this).next('input').next('input').val();

                                var oldBusinessCode = $('#<%= hfSelectBusinessCode.ClientID%>').val(); // 기존 코드

                                // 하위 코드의 입력창 초기화
                                if (oldBusinessCode != code) {
                                    $('#<%= txtDeptCode.ClientID%>').val("");
                                    $('#<%= lblDeptName.ClientID%>').text("");

                                    $('#<%= hfSelectDeptCode.ClientID%>').val("");
                                    $('#<%= hfSelectDeptName.ClientID%>').val("");
                                }
                                
                                $('#<%= txtBusinessCode.ClientID%>').val(code);
                                $('#<%= hfSelectBusinessCode.ClientID%>').val(code);
                                $('#<%= hfSelectBusinessName.ClientID%>').val(name);
                                $('#<%= lblBusinessName.ClientID%>').text(name);
                            }
                        });

                        $("#businessDeptDialog").dialog("close");

                    },
                },
                open: function (type, data) {
                },

                close: function () {
                    //location.reload();
                }
            });

            //부서코드 검색 창 
            $("#deptDialog").dialog({
                autoOpen: false,
                height: 700,
                width: 800,
                modal: true,
                buttons: {
                    '수정': function () {
                        var deptName = $.trim($('#<%= txtModalDeptName.ClientID%>').val()); //부서명
                        var remark = $('#<%= txtModalDeptRemark.ClientID%>').val(); //비고               
                        var selectCompCode = $('#<%= hfSelectCompanyCode.ClientID%>').val(); //회사코드
                        var areaCode = $('#<%= hfSelectAreaCode.ClientID%>').val(); //사업장코드
                        var businessCode = $('#<%= hfSelectBusinessCode.ClientID%>').val(); //사업부코드 
                        var deptCode = $('#<%= hfSelectDeptCode.ClientID%>').val(); //부서코드

                        if (deptName == "") {
                            alert('부서명을 입력해 주세요.');
                            $('#<%= txtModalDeptName.ClientID%>').focus();
                            return false;
                        }

                        var modalDeptCode = $('#<%= txtModalDeptCode.ClientID%>').val();

                        if (modalDeptCode != deptCode) {
                            alert("수정을 요청하신 코드는 현재 사용자에게 설정된 코드값이 아닙니다.\n해당 코드를 최종 선택하신 후 다시 시도해 주시기 바랍니다.");
                            return false;
                        }
                        
                        // ajax callback 함수
                        var callback = function (response) {
                            $('#tbDeptList').find('tr:gt(0)').remove(); //테이블 클리어

                            var index = 0;

                            if (!isEmpty(response)) {
                                $.each(response, function (key, value) { //테이블 추가
                                        
                                    var newRowContent = "<tr><td><input id='cbCompCheck" + index + " ' type='checkbox'><input id='hfDeptCode" + index + "' type='hidden' value='" + value.CompanyDept_Code + "'><input id='hfDeptName" + index + "' type='hidden' value='" + value.CompanyDept_Name + "'></td>";
                                    newRowContent += "<td> " + value.CompanyDept_Code + " </td><td>" + value.CompanyDept_Name + "</td><td>" + value.Remark + "</td></tr>";
                                    $('#tbDeptList tr:last').after(newRowContent);

                                    index++;
                                });

                                if (index > 0) {
                                    alert("수정되었습니다.");

                                    var deptName = $.trim($('#<%= txtModalDeptName.ClientID%>').val());
                                    $('#<%= lblDeptName.ClientID%>').text(deptName);
                                    $('#<%= hfSelectDeptName.ClientID%>').text(deptName);
                                }
                            }
                            else {
                                $('#tbDeptList tr:last').after("<tr><td colspan='4'>데이터가 없습니다</td></tr>");
                            }
                        };

                        var param = { CompanyCode: selectCompCode, AreaCode: areaCode, BusinessCode: businessCode, DeptCode: deptCode, DeptName: deptName, Remark: remark, Flag: "Update" };

                        Jajax("Post", "../../Handler/Admin/CompanyDeptHandler.ashx", param, "json", callback); // ajax 호출
                    },
                    '코드생성': function () {
                        var deptName = $.trim($('#<%= txtModalDeptName.ClientID%>').val()); //부서명
                        var remark = $('#<%= txtModalDeptRemark.ClientID%>').val(); //비고               
                        var selectCompCode = $('#<%= hfSelectCompanyCode.ClientID%>').val() //회사코드                    
                        var areaCode = $('#<%= hfSelectAreaCode.ClientID%>').val(); //사업장코드
                        var businessCode = $('#<%= hfSelectBusinessCode.ClientID%>').val(); //사업부코드

                        if (deptName == "") {
                            alert('부서명을 입력해 주세요.');
                            $('#<%= txtModalDeptName.ClientID%>').focus();
                            return false;
                        }
                        
                        // ajax callback 함수
                        var callback = function (response) {
                            $('#tbDeptList').find('tr:gt(0)').remove(); //테이블 클리어

                            var index = 0;

                            if (!isEmpty(response)) {
                                var deptCode = ""; // 새 부서코드

                                $.each(response, function (key, value) { //테이블 추가

                                    // 새로 생성된 코드값 변수에 저장
                                    if (index == 0) {
                                        deptCode = value.NewCode;
                                        $('#<%= txtModalDeptCode.ClientID%>').val(deptCode); // 생성된 코드를 텍스트박스에 넣어준다
                                    }

                                    var newRowContent = "<tr><td><input id='cbCompCheck" + index + " ' type='checkbox'><input id='hfDeptCode" + index + "' type='hidden' value='" + value.CompanyDept_Code + "'><input id='hfDeptName" + index + "' type='hidden' value='" + value.CompanyDept_Name + "'></td>";
                                    newRowContent += "<td> " + value.CompanyDept_Code + " </td><td>" + value.CompanyDept_Name + "</td><td>" + value.Remark + "</td></tr>";
                                    $('#tbDeptList tr:last').after(newRowContent);

                                    index++;
                                });

                                if (index > 0) {
                                    alert('저장되었습니다.');
                                }
                            }
                            else {
                                $('#tbDeptList tr:last').after("<tr><td colspan='4'>데이터가 없습니다</td></tr>");
                            }
                        };

                        var param = { CompanyCode: selectCompCode, AreaCode: areaCode, BusinessCode: businessCode, DeptName: deptName, Remark: remark, Flag: "Create" };

                        Jajax("Post", "../../Handler/Admin/CompanyDeptHandler.ashx", param, "json", callback); // ajax 호출

                    },
                    '확인': function () {
                        //선택한 코드와 부서명을 부모창에 뿌려줌
                        $('#divDeptList input[type="checkbox"]').each(function () {
                            if ($(this).prop('checked') == true) {
                                var code = $(this).next('input').val();
                                var name = $(this).next('input').next('input').val();
                                
                                $('#<%= txtDeptCode.ClientID%>').val(code);
                                $('#<%= hfSelectDeptCode.ClientID%>').val(code);
                                $('#<%= hfSelectDeptName.ClientID%>').val(name);
                                $('#<%= lblDeptName.ClientID%>').text(name);
                            }
                        });

                        $("#deptDialog").dialog("close");
                    },
                },

                open: function (type, data) {
                    
                },

                close: function () {

                }
            });
            
            //리스트 체크박스 just one select
            $("#tbSocialCompList").on("click", "input[type=checkbox]", function (eventData) {
                var checked = $(eventData.currentTarget).prop("checked");

                if (checked) {
                    $("#tbSocialCompList input[type=checkbox]").prop("checked", false);//uncheck everything.
                    $(eventData.currentTarget).prop("checked", "checked");//recheck this one.
                }
            });

            $("#tbComapanyList").on("click", "input[type=checkbox]", function (eventData) {
                var checked = $(eventData.currentTarget).prop("checked");

                if (checked) {
                    $("#tbComapanyList input[type=checkbox]").prop("checked", false);//uncheck everything.
                    $(eventData.currentTarget).prop("checked", "checked");//recheck this one.
                }
            });

            $("#tbAreaList").on("click", "input[type=checkbox]", function (eventData) {
                var checked = $(eventData.currentTarget).prop("checked");

                if (checked) {
                    $("#tbAreaList input[type=checkbox]").prop("checked", false);//uncheck everything.
                    $(eventData.currentTarget).prop("checked", "checked");//recheck this one. 
                }
            });

            $("#tbBusinessList").on("click", "input[type=checkbox]", function (eventData) {
                var checked = $(eventData.currentTarget).prop("checked");

                if (checked) {
                    $("#tbBusinessList input[type=checkbox]").prop("checked", false);//uncheck everything.
                    $(eventData.currentTarget).prop("checked", "checked");//recheck this one. 
                }
            });

            $("#tbDeptList").on("click", "input[type=checkbox]", function (eventData) {
                var checked = $(eventData.currentTarget).prop("checked");

                if (checked) {
                    $("#tbDeptList input[type=checkbox]").prop("checked", false);//uncheck everything.
                    $(eventData.currentTarget).prop("checked", "checked");//recheck this one. 
                }
            });
        });
        //document ready 끝


        //회사 코드 생성 모달창 오픈
        function fnOpenCompanyDialog() {
            var index = 0;
            $('#<%= txtModalComapnyName.ClientID%>').val('');
            $('#<%= txtModalCompanyCode.ClientID%>').val('');
            $('#<%= txtModalComanyRemark.ClientID%>').val('');
            $('#tbComapanyList').find('tr:gt(0)').remove(); //테이블 클리어

            var companyNo = $('#<%= hfCompanyNo.ClientID%>').val();
            
            var callback = function (response) {
                if (!isEmpty(response)) {
                    var compNm = $('#<%= lblCompanyName.ClientID%>').text(); // 회사명
                    var compCode = $('#<%= txtCompnayCode.ClientID%>').val(); // 회사코드

                    $('#<%= txtModalComapnyName.ClientID%>').val(compNm);
                    $('#<%= txtModalCompanyCode.ClientID%>').val(compCode);

                    $.each(response, function (key, value) { //테이블 추가

                        // 모달창의 비고 입력창에 해당하는 코드의 비고값을 넣어줌.
                        if (compCode == value.Company_Code)
                            $('#<%= txtModalComanyRemark.ClientID%>').val(value.Remark);

                        var newRowContent = "<tr><td><input id='cbCompCheck" + index + " ' type='checkbox'><input id='hfCompCode" + index + "' type='hidden' value='" + value.Company_Code + "'><input id='hfCompName" + index + "' type='hidden' value='" + value.Company_Name + "'><input id='hfDelFlag" + index + "' type='hidden' value='" + value.DelFlag + "'></td>";
                        newRowContent += "<td> " + value.Company_Code + " </td><td>" + value.Company_Name + "</td><td>" + value.Remark + "</td></tr>";
                        $('#tbComapanyList tr:last').after(newRowContent);
                        index++;
                    });
                }
                else {
                    $('#tbComapanyList tr:last').after("<tr><td colspan='4'>데이터가 없습니다</td></tr>");
                }

                $("#companyDialog").dialog("open");
                //return false;
            };

            var param = { CompanyNo: companyNo, Flag: 'List' };

            Jajax("Post", "../../Handler/Admin/CompanyHandler.ashx", param, "json", callback);
        }

        //사업장 dialog open
        function fnOpenAreaDialog() {
            if ($('#<%= hfSelectCompanyCode.ClientID%>').val() == '') {
                alert('회사를 선택해 주세요');
                return false;
            }
            
            $('#<%= txtModalAreaCode.ClientID%>').val('');
            $('#<%= txtModalAreaName.ClientID%>').val('');
            $('#<%= txtModalAreaRemark.ClientID%>').val('');
            $('#tbAreaList').find('tr:gt(0)').remove(); //테이블 클리어

            // ajax callback 함수
            var callback = function (response) {
                var index = 0;

                if (!isEmpty(response)) {
                    var compAreaNm = $('#<%= lblAreaName.ClientID%>').text(); // 사업장명
                    var compAreaCode = $('#<%= txtAreaCode.ClientID%>').val(); // 사업장코드

                    $('#<%= txtModalAreaName.ClientID%>').val(compAreaNm);
                    $('#<%= txtModalAreaCode.ClientID%>').val(compAreaCode);

                    $.each(response, function (key, value) { //테이블 추가

                        // 모달창의 비고 입력창에 해당하는 코드의 비고값을 넣어줌.
                        if (compAreaCode == value.CompanyArea_Code)
                            $('#<%= txtModalAreaRemark.ClientID%>').val(value.Remark);

                        var newRowContent = "<tr><td><input id='cbCompCheck" + index + " ' type='checkbox'><input id='hfAreaCode" + index + "' type='hidden' value='" + value.CompanyArea_Code + "'><input id='hfAreaName" + index + "' type='hidden' value='" + value.CompanyArea_Name + "'></td>";
                        newRowContent += "<td> " + value.CompanyArea_Code + " </td><td>" + value.CompanyArea_Name + "</td><td>" + value.Remark + "</td></tr>";
                        $('#tbAreaList tr:last').after(newRowContent);
                        index++;
                    });
                }
                else {
                    $('#tbAreaList tr:last').after("<tr><td colspan='4'>데이터가 없습니다</td></tr>");
                }

                $("#areaDialog").dialog("open");
            };

            var param = { CompanyCode: $('#<%= hfSelectCompanyCode.ClientID%>').val(), Flag: "List" }; // ajax 파라미터

            Jajax("Post", "../../Handler/Admin/CompanyAreaHandler.ashx", param, "json", callback); // ajax 호출
        }

        //사업부 코드 모달창
        function fnOpenCompBusinessDept() {

            if ($('#<%= hfSelectCompanyCode.ClientID%>').val() == '') {
                alert('회사를 선택해 주세요');
                return false;
            }

            if ($('#<%= hfSelectAreaCode.ClientID%>').val() == '') {
                alert('사업장을 선택해 주세요');
                return false;
            }
            
            $('#<%= txtModalBusinessDeptCode.ClientID%>').val(''); //모달창에서 사업부코드
            $('#<%= txtModalBusinessDeptName.ClientID%>').val(''); //모달창에서 사업부이름
            $('#<%= txtModalBusinessDeptRemark.ClientID%>').val(''); //모달창에서 사업부비고

            // ajax callback 함수
            var callback = function (response) {
                $('#tbBusinessList').find('tr:gt(0)').remove(); //테이블 클리어

                var index = 0;

                if (!isEmpty(response)) {
                    var compBusinessCode = $('#<%= hfSelectBusinessCode.ClientID%>').val(); // 사업부코드
                    var compBusinessNm = $('#<%= lblBusinessName.ClientID%>').text(); // 사업부명

                    $('#<%= txtModalBusinessDeptName.ClientID%>').val(compBusinessNm);
                    $('#<%= txtModalBusinessDeptCode.ClientID%>').val(compBusinessCode);

                    $.each(response, function (key, value) { //테이블 추가

                        // 모달창의 비고 입력창에 해당하는 코드의 비고값을 넣어줌.
                        if (compBusinessCode == value.CompBusinessDept_Code)
                            $('#<%= txtModalBusinessDeptRemark.ClientID%>').val(value.Remark);

                        var newRowContent = "<tr><td><input id='cbCompCheck" + index + " ' type='checkbox'><input id='hfBusinessDeptCode" + index + "' type='hidden' value='" + value.CompBusinessDept_Code + "'><input id='hfBusinessDeptName" + index + "' type='hidden' value='" + value.CompBusinessDept_Name + "'></td>";
                        newRowContent += "<td> " + value.CompBusinessDept_Code + " </td><td>" + value.CompBusinessDept_Name + "</td><td>" + value.Remark + "</td></tr>";
                        $('#tbBusinessList tr:last').after(newRowContent);
                        index++;
                    });
                }
                else {
                    $('#tbBusinessList tr:last').after("<tr><td colspan='4'>데이터가 없습니다</td></tr>");
                }

                $("#businessDeptDialog").dialog("open");
            };

            var param = { CompanyCode: $('#<%= hfSelectCompanyCode.ClientID%>').val(), AreaCode: $('#<%= hfSelectAreaCode.ClientID%>').val(), Flag: "List" };

            Jajax("Post", "../../Handler/Admin/CompBusinessHandler.ashx", param, "json", callback); // ajax 호출
            
        }

        //부서코드 dialog open
        function fnOpenDeptDialog() {

            if ($('#<%= hfSelectCompanyCode.ClientID%>').val() == '') {
                alert('회사를 선택해 주세요');
                return false;
            }

            if ($('#<%= hfSelectAreaCode.ClientID%>').val() == '') {
                alert('사업장을 선택해 주세요');
                return false;
            }

            if ($('#<%= hfSelectBusinessCode.ClientID%>').val() == '') {
                alert('사업부를 선택해 주세요');
                return false;
            }
            
            $('#<%= txtModalDeptCode.ClientID%>').val(''); //부서코드
            $('#<%= txtModalDeptName.ClientID%>').val(''); //부서명
            $('#<%= txtModalDeptRemark.ClientID%>').val(''); //부서 비고
            
            // ajax callback 함수
            var callback = function (response) {
                $('#tbDeptList').find('tr:gt(0)').remove(); //테이블 클리어

                var index = 0;

                if (!isEmpty(response)) {
                    var compDeptCode = $('#<%= hfSelectDeptCode.ClientID%>').val(); // 부서코드
                    var compDeptCodeNm = $('#<%= lblDeptName.ClientID%>').text(); // 부서명

                        $('#<%= txtModalDeptName.ClientID%>').val(compDeptCodeNm);
                        $('#<%= txtModalDeptCode.ClientID%>').val(compDeptCode);

                        $.each(response, function (key, value) { //테이블 추가

                            // 모달창의 비고 입력창에 해당하는 코드의 비고값을 넣어줌.
                            if (compDeptCode == value.CompanyDept_Code)
                                $('#<%= txtModalDeptRemark.ClientID%>').val(value.Remark);

                            var newRowContent = "<tr><td><input id='cbCompCheck" + index + " ' type='checkbox'><input id='hfDeptCode" + index + "' type='hidden' value='" + value.CompanyDept_Code + "'><input id='hfDeptName" + index + "' type='hidden' value='" + value.CompanyDept_Name + "'></td>";
                            newRowContent += "<td> " + value.CompanyDept_Code + " </td><td>" + value.CompanyDept_Name + "</td><td>" + value.Remark + "</td></tr>";
                            $('#tbDeptList tr:last').after(newRowContent);

                            index++;
                        });
                }
                else {
                    $('#tbDeptList tr:last').after("<tr><td colspan='4'>데이터가 없습니다</td></tr>");
                }

                $("#deptDialog").dialog("open");
            };
            
            var param = { CompanyCode: $('#<%= hfSelectCompanyCode.ClientID%>').val(), AreaCode: $('#<%= hfSelectAreaCode.ClientID%>').val(), BusinessCode: $('#<%= hfSelectBusinessCode.ClientID%>').val(), Flag: "List" };

            Jajax("Post", "../../Handler/Admin/CompanyDeptHandler.ashx", param, "json", callback); // ajax 호출
            
        }
        
        // 회사구분 dialog open
        function fnOpenSocialCompDialog() {
            $('#<%= txtModalSocialCompCode.ClientID%>').val(''); //회사구분코드
            $('#<%= txtModalSocialCompName.ClientID%>').val(''); //회사구분명
            $('#<%= txtModalSocialCompRemark.ClientID%>').val(''); //회사구분 비고

            // ajax callback 함수
            var callback = function (response) {
                $('#tbSocialCompList').find('tr:gt(0)').remove(); //테이블 클리어

                var index = 0;

                if (!isEmpty(response)) {
                    var socialCompCode = $('#<%= hfSelectSocialCompCode.ClientID%>').val(); // 회사구분코드
                    var socialCompNm = $('#<%= lblSocialCompName.ClientID%>').text(); // 회사구분명

                    $('#<%= txtModalSocialCompName.ClientID%>').val(socialCompNm);
                    $('#<%= txtModalSocialCompCode.ClientID%>').val(socialCompCode);

                    $.each(response, function (key, value) { //테이블 추가

                        // 모달창의 비고 입력창에 해당하는 코드의 비고값을 넣어줌.
                        if (socialCompCode == value.SocialCompany_Code)
                            $('#<%= txtModalSocialCompRemark.ClientID%>').val(value.Remark);

                        var newRowContent = "<tr><td><input id='cbSocialCompCheck" + index + " ' type='checkbox'><input id='hfSocialCompCode" + index + "' type='hidden' value='" + value.SocialCompany_Code + "'><input id='hfSocialCompName" + index + "' type='hidden' value='" + value.SocialCompany_Name + "'></td>";
                        newRowContent += "<td> " + value.SocialCompany_Code + " </td><td>" + value.SocialCompany_Name + "</td><td>" + value.Remark + "</td></tr>";
                        $('#tbSocialCompList tr:last').after(newRowContent);

                        index++;
                    });
                }
                else {
                    $('#tbSocialCompList tr:last').after("<tr><td colspan='4'>데이터가 없습니다</td></tr>");
                }

                $("#socialCompDialog").dialog("open");
            };
            
            var param = { Gubun: $('#<%= hfGubun.ClientID%>').val(), Method: "SocialCompanyList" };

            Jajax("Post", "../../Handler/Admin/SocialCompanyHandler.ashx", param, "json", callback); // ajax 호출
        }

        // 저장 버튼 클릭 시 값 체크
        function checkCodeValue() {
            var socialCompCode = $.trim($('#<%= txtSocialCompCode.ClientID%>').val());
            var compCode = $.trim($('#<%= txtCompnayCode.ClientID%>').val());
            var areaCode = $.trim($('#<%= txtAreaCode.ClientID%>').val());
            var businessCode = $.trim($('#<%= txtBusinessCode.ClientID%>').val());
            var deptCode = $.trim($('#<%= txtDeptCode.ClientID%>').val());

            if (socialCompCode == "") {
                alert("회사구분코드를 선택해 주세요");
                return false;
            }
            if (compCode == "") {
                alert("회사코드를 선택해 주세요");
                return false;
            }
            if (areaCode == "") {
                alert("사업장코드를 선택해 주세요");
                return false;
            }
            if (businessCode == "") {
                alert("사업부코드를 선택해 주세요");
                return false;
            }
            if (deptCode == "") {
                alert("부서코드를 선택해 주세요");
                return false;
            }
            return true;
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <div style="padding-top:100px">
         <div class="sub-title-div">
		    회원정보(고객사B)
	    </div>
        <div class="tabHeaderWrap">
            <asp:DynamicHyperLink ID="dhl1" runat="server" Text="회사기본정보" NavigateUrl="~/Admin/User/UserInfoManagement.aspx" CssClass="on"></asp:DynamicHyperLink>
            <asp:DynamicHyperLink ID="dhl2" runat="server" Text="개인정보" NavigateUrl="~/Admin/User/UserInfoManagement.aspx"></asp:DynamicHyperLink>
            <asp:DynamicHyperLink ID="dhl3" runat="server" Text="권한관리" NavigateUrl="~/Admin/User/UserInfoManagement.aspx"></asp:DynamicHyperLink>
            <asp:DynamicHyperLink ID="dhl4" runat="server" Text="활동정보" NavigateUrl="~/Admin/User/UserInfoManagement.aspx"></asp:DynamicHyperLink>
	    <div class="clear"></div>
        </div>
         <span>회사 코드부여</span>
         <asp:Button ID="btnUserInfoUpdate" runat="server" Text="저장" OnClientClick="return checkCodeValue();" OnClick="btnUserInfoUpdate_Click"></asp:Button>
        <%--<asp:Button ID="btnUserInfoUpdate" runat="server" Text="저장" OnClick="btnUserInfoUpdate_Click"></asp:Button>--%>
    <div>
        <table>
            <tr>
                <td>
                    사업자번호
                </td>
                <td colspan="3">
                    <asp:Label ID="lblCompanyNo" runat="server"></asp:Label>
                </td>
                <%--<td>
                    회사구분
                </td>
                <td style="width:300px">
                    <asp:Label ID="lblGubun" runat="server" Text="B"></asp:Label>
                </td>--%>
            </tr>
            <tr>
                <td>
                    회사구분
                </td>
                <td>
                    <asp:TextBox ID="txtSocialCompCode" runat="server" ReadOnly="true"></asp:TextBox>
                    <asp:HiddenField runat="server" ID="hfSelectSocialCompCode" />
                    <asp:HiddenField runat="server" ID="hfOldSocialCompCode" />
                    <asp:HiddenField runat="server" ID="hfGubun" />
                    <input type="button" id="btnSocialCompSearch" value="검색" onclick="fnOpenSocialCompDialog(); return false;"/>
                </td>
                <td>
                    회사구분명
                </td>
                <td>
                    <asp:Label ID="lblSocialCompName" runat="server"></asp:Label>
                    <asp:HiddenField runat="server" ID="hfSelectSocialCompName" />
                </td>
            </tr>
            <tr>
                <td>
                    회사코드
                </td>
                <td>
                    <asp:Label ID="lblCompanyCode" runat="server" Visible="false"></asp:Label>
                    <asp:TextBox ID="txtCompnayCode" runat="server" ReadOnly="true"></asp:TextBox>
                    <input type="button" id="btnComapyCodeSearch" value="검색" onclick="fnOpenCompanyDialog(); return false;"/>
                    <asp:HiddenField runat="server" ID="hfSelectCompanyCode" />
                    <asp:HiddenField runat="server" ID="hfSvidUSer" />
                    <asp:HiddenField runat="server" ID="hfCompanyNo" />
                    <asp:HiddenField runat="server" ID="hfOldCompCode" />
                </td>
                <td>
                    회사명
                </td>
                <td>
                    <asp:Label ID="lblCompanyName" runat="server"></asp:Label>
                    <asp:HiddenField runat="server" ID="hfSelectCompanyName" />
                </td>
            </tr>
            <tr>
                <td>회사 거래중지여부</td>
                <td colspan="3">
                    <asp:RadioButton ID="rbnDelflagY" runat="server" GroupName="radioFlag" Text="예" />
                    <asp:RadioButton ID="rbnDelflagN" runat="server" GroupName="radioFlag" Text="아니오" Checked="true" />
                    <asp:HiddenField runat="server" ID="hfSelectCompDelFlag" />
                </td>
            </tr>
            <tr>
                <td>
                    사업장코드
                </td>
                <td>
                    <asp:TextBox ID="txtAreaCode" runat="server" ReadOnly="true"></asp:TextBox>
                    <asp:HiddenField runat="server" ID="hfSelectAreaCode" />
                    <input type="button" id="btnAreaCodeSearch" value="검색" onclick="fnOpenAreaDialog(); return false;"/>
                </td>
                <td>
                    사업장명
                </td>
                <td>
                    <asp:Label ID="lblAreaName" runat="server"></asp:Label>
                    <asp:HiddenField runat="server" ID="hfSelectAreaName" />
                </td>
            </tr>
            <tr>
                <td>
                    사업부코드
                </td>
                <td>
                    <asp:TextBox ID="txtBusinessCode" runat="server" ReadOnly="true"></asp:TextBox>
                    <asp:HiddenField runat="server" ID="hfSelectBusinessCode" />
                    <input type="button" id="btnBusinessDeptSearch" value="검색" onclick="fnOpenCompBusinessDept(); return false;" />
                </td>
                <td>
                    사업부명
                </td>
                <td>
                    <asp:Label ID="lblBusinessName" runat="server"></asp:Label>
                    <asp:HiddenField runat="server" ID="hfSelectBusinessName" />
                </td>
            </tr>
            <tr>
                <td>
                    부서코드
                </td>
                <td>
                    <asp:TextBox ID="txtDeptCode" runat="server" ReadOnly="true"></asp:TextBox>
                    <asp:HiddenField runat="server" ID="hfSelectDeptCode" />
                    <input type="button" id="btnDeptCodeSearch" value="검색" onclick="fnOpenDeptDialog(); return false;" />
                </td>
                <td>
                    부서명
                </td>
                <td>
                    <asp:Label ID="lblDeptName" runat="server"></asp:Label>
                    <asp:HiddenField runat="server" ID="hfSelectDeptName" />
                </td>
            </tr>
        </table>
        <br />
         <span>회사 권한관리</span>
         <table>
            <tr>
                <td>
                    후불결제
                </td>
                <td colspan="3" style="width:590px">

                </td>
            </tr>
        </table>
        <br />
         <span>여신관리</span>
         <table>
            <tr>
                <td>
                    회사코드
                </td>
                <td style="width:250px">

                </td>
                <td>
                    회사명
                </td>
                <td style="width:250px">

                </td>
            </tr>
            <tr>
                <td>
                    사업자번호
                </td>
                <td>

                </td>
                <td>
                    대표자
                </td>
                <td>

                </td>
            </tr>
            <tr>
                <td>
                    거래일자
                </td>
                <td>

                </td>
                <td>
                    미수금액
                </td>
                <td>

                </td>
            </tr>
            <tr>
                <td>
                    신용한도
                </td>
                <td colspan="3">

                </td>
            </tr>
        </table>
        <br />
        <span>세금계산 발행정보</span>
         <table>
            <tr>
                <td>
                    회사코드
                </td>
                <td style="width:250px">

                </td>
                 <td>
                    회사명
                </td>
                <td style="width:250px">

                </td>
            </tr>
            <tr>
                <td>
                    사업자번호
                </td>
                <td>

                </td>
                 <td>
                    대표자
                </td>
                <td>

                </td>
            </tr>
            <tr>
                <td colspan="2">
                    전자세금계산서 발행 이메일
                </td>
                <td  colspan="2">

                </td>
            </tr>
            <tr>
                <td>
                    전화번호
                </td>
                <td>

                </td>
                <td>
                    휴대전화
                </td>
                <td>

                </td>
            </tr>
        </table>
    </div>


    <!-- 회사구분 검색 modal -->
    <div id="socialCompDialog" title="회사구분검색" class="ui-widget">
      <table style="text-align:'left';""  border-collapse:  collapse; text-align: center; border: 1px solid solid;" border="1">
       <tr>
       
           <td>
               <asp:Label ID="lblModalSocialCompSelect" runat="server" Text="선택"></asp:Label>
           </td>
           <td>
                <asp:Label ID="lblModalSocialCompName" runat="server" Text="회사구분명"></asp:Label>
           </td>
           <td>
               <asp:TextBox ID="txtModalSocialCompName" runat="server"></asp:TextBox>
           </td>
            <td>
               <asp:Label ID="lblModalSocialCompCode" runat="server" Text="회사구분코드"></asp:Label>
           </td>
           <td>
               <asp:TextBox ID="txtModalSocialCompCode" runat="server"></asp:TextBox>
           </td>

           <td>
               <asp:Label ID="Label8" runat="server" Text="데이터있음"></asp:Label>
           </td>
            <td>
                <%--검색 기능은 추후 개발 예정--%>
                <asp:Button ID="Button1" runat="server" Text="Button" Visible="false"/>
           </td>
       </tr>
        <tr>
            <td>
                비고
            </td>
            <td colspan="6">
                <asp:TextBox ID="txtModalSocialCompRemark" runat="server" Width="100%"></asp:TextBox>
            </td>
        </tr>
        </table>
         <br />
        <div id="divSocialCompList">
            <table id="tbSocialCompList">
                <thead>
                <tr>
                    <td>
                        선택
                    </td>
                    <td>
                        코드
                    </td>
                    <td>
                        회사구분명
                    </td>
                    <td>
                        비고
                    </td>
                </tr>
                </thead>
                <tbody></tbody>
            </table>
        </div>
    </div>

    <!-- 회사코드 검색 modal -->
    <div id="companyDialog" title="회사코드검색" class="ui-widget">
        <table>
            <tr>
                <td>
                    <asp:Label ID="lblSelect" runat="server" Text="선택"></asp:Label>
                </td>
                <td>
                    <asp:Label ID="lblModalCompanyName" runat="server" Text="회사명"></asp:Label>
                </td>
                <td>
                    <asp:TextBox ID="txtModalComapnyName" runat="server"></asp:TextBox>
                </td>
                <td>
                    <asp:Label ID="lblModalCompanyCode" runat="server" Text="회사코드"></asp:Label>
                </td>
                <td>
                    <asp:TextBox ID="txtModalCompanyCode" runat="server" ReadOnly="true"></asp:TextBox>
                </td>
                <td>
                    <asp:Label ID="lblDataCheck" runat="server" Text="데이터있음"></asp:Label>
                </td>
            </tr>
            <tr>
                <td>비고</td>
                <td colspan="5">
                    <asp:TextBox ID="txtModalComanyRemark" runat="server" Width="99%"></asp:TextBox>
                </td>
            </tr>
        </table>
        <br />
        <div id="divCompanyList">
            <table id="tbComapanyList">
                <thead>
                <tr>
                    <td>
                        선택
                    </td>
                    <td>
                        코드
                    </td>
                    <td>
                        회사명
                    </td>
                    <td>
                        비고
                    </td>
                </tr>
                </thead>
                <tbody></tbody>
            </table>
        </div>
    </div>


        <!-- 사업장코드 검색 modal -->
    <div id="areaDialog" title="사업장코드검색" class="ui-widget">
      <table>
       <tr>
       
           <td>
               <asp:Label ID="lblModalAreaSelect" runat="server" Text="선택"></asp:Label>
           </td>
           <td>
                <asp:Label ID="lblModalAreaName" runat="server" Text="사업장명"></asp:Label>
           </td>
           <td>
               <asp:TextBox ID="txtModalAreaName" runat="server"></asp:TextBox>
           </td>
            <td>
               <asp:Label ID="lblModalAreaCode" runat="server" Text="사업장코드"></asp:Label>
           </td>
           <td>
               <asp:TextBox ID="txtModalAreaCode" runat="server" ReadOnly="true"></asp:TextBox>
           </td>

           <td>
               <asp:Label ID="lblModalDataFlag" runat="server" Text="데이터있음"></asp:Label>
               <%--검색 기능은 추후 개발 예정--%>
               <%--<asp:Button ID="btnModalAreaSearch" runat="server" Text="검색" Visible="false" />--%>
           </td>
       </tr>
        <tr>
            <td>
                비고
            </td>
            <td colspan="5">
                <asp:TextBox ID="txtModalAreaRemark" runat="server" Width="100%"></asp:TextBox>
            </td>
        </tr>
        </table>
         <br />
        <div id="divAreaList">
            <table id="tbAreaList">
                <thead>
                <tr>
                    <td>
                        선택
                    </td>
                    <td>
                        코드
                    </td>
                    <td>
                        사업장명
                    </td>
                    <td>
                        비고
                    </td>
                </tr>
                </thead>
                <tbody></tbody>
            </table>
        </div>
    </div>

    <!-- 사업부코드 검색 modal -->
    <div id="businessDeptDialog" title="사업부코드검색" class="ui-widget">
        <table style="text-align:'left';""  border-collapse:  collapse; text-align: center; border: 1px solid solid;" border="1">
       <tr>
       
           <td>
               <asp:Label ID="Label1" runat="server" Text="선택"></asp:Label>
           </td>
           <td>
                <asp:Label ID="Label2" runat="server" Text="사업부명"></asp:Label>
           </td>
           <td>
               <asp:TextBox ID="txtModalBusinessDeptName" runat="server"></asp:TextBox>
           </td>
            <td>
               <asp:Label ID="Label3" runat="server" Text="사업부코드"></asp:Label>
           </td>
           <td>
               <asp:TextBox ID="txtModalBusinessDeptCode" runat="server" ReadOnly="true"></asp:TextBox>
           </td>

           <td>
               <asp:Label ID="Label4" runat="server" Text="데이터있음"></asp:Label>
           </td>
           <td>
              <asp:Button ID="btnBusinessSch" runat="server" Text="검색" Visible="False" /> <%--추후 개발 예정--%>
          </td>
        </tr>
        <tr>
            <td>
                비고
            </td>
            <td colspan="5">
                <asp:TextBox ID="txtModalBusinessDeptRemark" runat="server" Width="100%"></asp:TextBox>
            </td>
        </tr>
        </table>
        <br />
        <div id="divBusinessList">
            <table id="tbBusinessList">
                <thead>
                <tr>
                    <td>
                        선택
                    </td>
                    <td>
                        코드
                    </td>
                    <td>
                        사업장명
                    </td>
                    <td>
                        비고
                    </td>
                </tr>
                </thead>
                <tbody></tbody>
            </table>
        </div>
    </div>

    <!-- 부서코드 검색 -->
    <div id="deptDialog" title="부서코드검색" class="ui-widget">
      <table style="text-align:'left';""  border-collapse:  collapse; text-align: center; border: 1px solid solid;" border="1">
       <tr>
       
           <td>
               <asp:Label ID="lblModalDeptSelect" runat="server" Text="선택"></asp:Label>
           </td>
           <td>
                <asp:Label ID="lblModalDeptName" runat="server" Text="부서명"></asp:Label>
           </td>
           <td>
               <asp:TextBox ID="txtModalDeptName" runat="server"></asp:TextBox>
           </td>
            <td>
               <asp:Label ID="lblModalDeptCode" runat="server" Text="부서코드"></asp:Label>
           </td>
           <td>
               <asp:TextBox ID="txtModalDeptCode" runat="server"></asp:TextBox>
           </td>

           <td>
               <asp:Label ID="lblDataCheck2" runat="server" Text="데이터있음"></asp:Label>
           </td>
            <td>
                <%--검색 기능은 추후 개발 예정--%>
                <asp:Button ID="btnModalDeptSearch" runat="server" Text="Button" Visible="false"/>
           </td>
       </tr>
        <tr>
            <td>
                비고
            </td>
            <td colspan="6">
                <asp:TextBox ID="txtModalDeptRemark" runat="server" Width="100%"></asp:TextBox>
            </td>
        </tr>
        </table>
         <br />
        <div id="divDeptList">
            <table id="tbDeptList">
                <thead>
                <tr>
                    <td>
                        선택
                    </td>
                    <td>
                        코드
                    </td>
                    <td>
                        부서명
                    </td>
                    <td>
                        비고
                    </td>
                </tr>
                </thead>
                <tbody></tbody>
            </table>
        </div>
    </div>

</div>
</asp:Content>

