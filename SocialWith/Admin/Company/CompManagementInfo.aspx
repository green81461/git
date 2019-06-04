<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Master/AdminMasterPage.master" AutoEventWireup="true" CodeFile="CompManagementInfo.aspx.cs" Inherits="Admin_Company_CompManagementInfo" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <link href="../Content/Member/member.css" rel="stylesheet" />
    <link href="../Content/Company/company.css" rel="stylesheet" />
    <link href="../Content/popup.css" rel="stylesheet" />

    <style>
        input {
            border: 1px solid #a2a2a2;
        }

        /*달력*/
        .calendar {
            border: 1px solid #a2a2a2;
            height: 90%;
            padding-left: 5px;
            margin-right: 5px;
            width: 180px;
        }
    </style>

    <script type="text/javascript">
        var is_sending = false;
        var qs = fnGetQueryStrings();
        var qsCompCode;
        var qsCompNo;
        var qsGubun;

        $(document).ready(function () {

            ListCheckboxOnlyOne("tblSearch");
            ListCheckboxOnlyOne("tblPopupAdmUserId");

            qsCompCode = qs["compCode"];
            qsCompNo = qs["compNo"];
            qsGubun = qs["gubun"];

            //달력
            $("#<%=this.txtConStartDate.ClientID%>").datepicker({
                showAnimation: 'slideDown',
                changeMonth: true,
                changeYear: true,
                showOn: 'button',
                buttonImage:/* "/Images/icon_calandar.png"*/"../../Images/Goods/calendar.jpg",
                buttonImageOnly: true,
                dateFormat: "yy-mm-dd",
                monthNamesShort: ["1월", "2월", "3월", "4월", "5월", "6월", "7월", "8월", "9월", "10월", "11월", "12월"],
                dayNamesMin: ["일", "월", "화", "수", "목", "금", "토"],
                showMonthAfterYear: true
            });

            $("#<%=this.txtConEndDate.ClientID%>").datepicker({
                showAnimation: 'slideDown',
                changeMonth: true,
                changeYear: true,
                showOn: 'button',
                buttonImage:/* "/Images/icon_calandar.png"*/"../../Images/Goods/calendar.jpg",
                buttonImageOnly: true,
                dateFormat: "yy-mm-dd",
                monthNamesShort: ["1월", "2월", "3월", "4월", "5월", "6월", "7월", "8월", "9월", "10월", "11월", "12월"],
                dayNamesMin: ["일", "월", "화", "수", "목", "금", "토"],
                showMonthAfterYear: true
            });

            fnSetPageLoad(); //화면 설정

            $("#sltAPlatform").on('change', function () {

                //$("#lblAPlatform").text($(this).val());
                $("#hdATypeRole").val($("#sltAPlatform option:selected").val());

                var ATypeRole = $("#hdATypeRole").val();
                var findVal = ATypeRole.indexOf("G");
                if (findVal >= 0) {
                    $("#hdGroupChk").val("Y");
                    $("#trGroupComp").css("display", '');
                } else {
                    $("#hdGroupChk").val("N");
                    $("#trGroupComp").css("display", "none");
                }

                $("#txtGroupCompId").val('');

                if (ATypeRole == "MRO") {
                    $("#txtATypeUrl").val("MRO");
                    $("#txtATypeUrl").prop("disabled", true);
                } else if (ATypeRole == "MROG") {
                    $("#txtATypeUrl").val("MROG");
                    $("#txtATypeUrl").prop("disabled", true);
                } else {
                    $("#txtATypeUrl").val("");
                    $("#txtATypeUrl").prop("disabled", false);
                }
            });

            $("#chkNonePlatform").on('click', function () {
                if ($(this).is(":checked")) {
                    $("#sltAPlatform").val('');
                    $("#sltAPlatform").prop("disabled", true);
                    $("#hdGroupChk").val('N');
                    $("#trGroupComp").css("display", "none");
                    $("#txtGroupCompId").val('');
                    $("#hdATypeRole").val('');
                } else {
                    $("#sltAPlatform").prop("disabled", false);
                }
            });

            //민간업체유무
            $("#ddlFreeCompYN").on('change', function () {

                if (this.value == 'Y') {
                    $("#spFreeCompVAT").css("display", '');
                    $("input:radio[id='rdFreeCompVATN']").prop("checked", true);

                    $("#ddlSaleUrian").find("option[value='A']").prop("disabled", true);

                } else {
                    $("#spFreeCompVAT").css("display", "none");
                    $("input:radio[id='rdFreeCompVATY']").prop("checked", true);

                    //판매사사업자번호!=구매사사업자번호
                    if ($("#sameComNoYN").val() == "Y")
                        $("#ddlSaleUrian").find("option[value='A']").prop("disabled", false);
                    else
                        $("#ddlSaleUrian").find("option[value='A']").prop("disabled", true);
                }

                $("#ddlSaleUrian").val('N');
                $("#txtBDsCode").val('');
                $("#txtBDsCode").prop("disabled", true);
            });

            // 전체선택 체크박스 클릭시
            $('#allChk').on("click", function () {
                //만약 전체 선택 체크박스가 체크된 상태일 경우
                if ($('#allChk').prop("checked")) {
                    $('input[type=checkbox').prop('checked', true);
                } else {
                    $('input[type=checkbox]').prop('checked', false);
                }
            })
        });

        //화면 설정
        function fnSetPageLoad() {
            fnPlatformTypeBind();   //판매사플랫폼유형 조회
            fnSetInfo();            //기본적인 정보 설정
        }

        //판매사플랫폼유형 조회
        function fnPlatformTypeBind() {

            var callback = function (response) {

                //$("#sltAPlatform").empty();
                var optionTag = '';

                if (!isEmpty(response)) {
                    $.each(response, function (key, value) {

                        var mapVal = '';
                        var mapName = value.Map_Name;

                        switch (parseInt(value.Map_Type)) {
                            case 1:
                                mapVal = 'D';
                                break;
                            case 2:
                                mapVal = 'S';
                                break;
                        }

                        if (value.Map_Type != '0') {
                            optionTag += "<option value='" + mapVal + "'>" + mapName + "</option>";
                        }
                    });
                    $("#sltAPlatform").append(optionTag);

                } else {
                    alert("판매사 플랫폼 유형");
                    return false;
                }

                return false;
            }
            var param = {
                Method: 'GetCommList',
                Code: 'COMPANY',
                Channel: 3
            };
            
            var beforeSend = function () {
                is_sending = true;
            }
            var complete = function () {
                is_sending = false;
            }

            JqueryAjax("Post", "../../Handler/Common/CommHandler.ashx", true, false, param, "json", callback, beforeSend, complete, true, '<%=Svid_User %>');
        }

        //기본적인 정보 설정
        function fnSetInfo() {
            var callback = function (response) {
                if (!isEmpty(response)) {
                    var gubun = response.Gubun;
                    var gubunName = response.Gubun_Name;
                    
                    var admUserId = response.AdminUserId; //소셜위드 관리 담당자ID
                    var admUserNm = response.AdminUserName; //소셜위드 관리 담당자명
                    var delegateNm = response.Delegate_Name; //대표자명
                    var ABillType = response.ABillType; //(판매사)세금계산서 유형
                    var freeCompYN = response.FreeCompanyYN; //민간 업체 유무
                    var freeCompVATYN = response.FreeCompanyVATYN; //민간 업체 부가세포함 유무
                    var sameComNOYN = response.SameComNO_AB_YN; //판매사=구매사 여부

                    $("#tdCompName").empty();

                    $("#hdCompCode").val(response.Company_Code);
                    $("#hdCompNo").val(response.Company_No);
                    $("#hdGubun").val(gubun);
                    $("#hdCompName").val(response.Company_Name);

                    $("#hdATypeRole").val(response.ATypeRole);
                    $("#hdBTypeRole").val(response.BTypeRole);
                    $("#hdDelFlag").val(response.DelFlag);
                    $("#hdGroupChk").val(response.GroupCheck); //판매사 그룹 사용 여부
                    
                    $("#tdGubun").text(gubunName); //구분
                    $("#txtDelegateName").val(delegateNm); //대표자명
                    $("#ddlFreeCompYN").val(freeCompYN);
                    $("#sameComNoYN").val(sameComNOYN);

                    $("#tdCompCode").text($("#hdCompCode").val());

                    if ((gubun == "SU") || (gubun == "IU")) {
                        $("#tdCompName").append("<input type='text' id='txtCompName' onkeypress='return fnEnter()' style='width:400px; height:24px' value='" + response.Company_Name + "'/>");
                        
                        if ($("#hdGroupChk").val() == 'Y') {
                            $("#trGroupComp").css("display", ""); //그룹 G 아이디
                        } else {
                            $("#trGroupComp").css("display", "none"); //그룹 G 아이디
                        }
                    }
                    
                    $("#tdCompNo").text(response.Company_No); //사업자번호
                    $("#ddlDelFlag").val(response.DelFlag);   //값 설정

                    //소셜위드 관리 담당자 처리
                    if (isEmpty(admUserId)) {
                        $("#txtAdmUserId").val('');
                        $("#spAdmUserNm").text('');
                    } else {
                        $("#txtAdmUserId").val(admUserId); //소셜위드 관리 담당자 ID
                        $("#spAdmUserNm").text(admUserNm);
                    }

                    if ((gubun == "SU") || (gubun == "IU")) {

                        //판매사 플랫폼 유형 설정
                        if (isEmpty($("#hdATypeRole").val())) {
                            $("#sltAPlatform").val('');
                            $("#sltAPlatform").prop("disabled", true);
                            //$("#lblAPlatform").text('');
                            $("#hdGroupChk").val('N');
                            $("#chkNonePlatform").prop("checked", true);
                            $("#trGroupComp").css("display", "none");
                            $("#txtGroupCompId").val('');

                        } else {
                            $("#sltAPlatform option").each(function (index, element) {

                                if ($(this).val() == $("#hdATypeRole").val()) {
                                    $(element).prop("selected", true);
                                    //$("#lblAPlatform").text($(this).val());

                                    if (($(this).text() == "MRO") || ($(this).text() == "MROG")) {
                                        //$("#txtATypeUrl").val("MRO");
                                        $("#txtATypeUrl").prop("disabled", true);
                                    } else {
                                        //$("#txtATypeUrl").val("");
                                        $("#txtATypeUrl").prop("disabled", false);
                                    }
                                }
                            });
                        }

                        if ($("#hdGroupChk").val() == "Y") {
                            $("#txtGroupCompId").val(response.GroupCompanyId);
                            $("#trGroupComp").css("display", '');
                        }

                        $("#txtATypeUrl").val(response.ATypeUrl);
                        if (!isEmpty(response.AJungEndType)) $("#<%=ddlAJungEndType.ClientID %>").val(response.AJungEndType); //정산마감일
                        if (!isEmpty(response.AJungPayType)) $("#<%=ddlAJungPayType.ClientID %>").val(response.AJungPayType); //정산결제일

                        //판매사RMPS유무
                        var rmpsChkVal = isEmpty(response.RmpsCheck) == true?'N':response.RmpsCheck;
                        $("#sltRmpsChkYN").val(rmpsChkVal);

                        //자동승인 유무
                        var autoConfirmYn = response.AutoConfirmYN;
                        if (isEmpty(autoConfirmYn)) autoConfirmYn = 'Y';
                        $("#ddlAutoConfirmYN").val(response.AutoConfirmYN);

                        //세금계산서 발행정보 부분
                        $("#txtBillUserNm").val(response.BillUserNm); //세금계산서 담당자명
                        $("#txtBillTel").val(response.BillTel); //세금계산서 전화번호
                        $("#<%= txtTelPhone1.ClientID%>").val(fnSplitText(response.BillTel, 0, '-')); //세금계산서 전화번호1
                        $("#<%= txtTelPhone2.ClientID%>").val(fnSplitText(response.BillTel, 1, '-')); //세금계산서 전화번호2
                        $("#<%= txtTelPhone3.ClientID%>").val(fnSplitText(response.BillTel, 2, '-')); //세금계산서 전화번호3

                        $("#txtBillFax").val(response.BillFax); //세금계산서 FAX번호

                        $("#<%= txtFax1.ClientID%>").val(fnSplitText(response.BillFax, 0, '-')); //세금계산서 팩스번호1                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
                        $("#<%= txtFax2.ClientID%>").val(fnSplitText(response.BillFax, 1, '-')); //세금계산서 팩스번호2
                        $("#<%= txtFax3.ClientID%>").val(fnSplitText(response.BillFax, 2, '-')); //세금계산서 팩스번호3

                        $("#txtBillEmail").val(response.BillEmail); //세금계산서 EMAIL

                        $("#<%= txtEmail1.ClientID%>").val(fnSplitText(response.BillEmail, 0, '@')); //세금계산서 EMAIL
                        $("#<%= txtEmail2.ClientID%>").val(fnSplitText(response.BillEmail, 1, '@')); //세금계산서 EMAIL

                        $("#txtUptae").val(response.Uptae); //세금계산서 업태
                        $("#txtUpjong").val(response.Upjong); //세금계산서 업종

                        if (isEmpty(ABillType)) ABillType = "1";
                        $("#ddlABillType").val(ABillType); //세금계산서 유형

                        if (freeCompYN == 'Y') {
                            $("#spFreeCompVAT").css("display", '');

                            $("input:radio[name='rdFreeCompVATYN']").each(function () {
                                if (this.value == freeCompVATYN) {
                                    this.checked = true;
                                }
                            });

                            $("#ddlSaleUrian").find("option[value='A']").prop("disabled", true); //민간업체인 경우 자사체크에서 판매사 가격 선택 불가

                        } else {
                            $("#spFreeCompVAT").css("display", "none");
                            $("input:radio[id='rdFreeCompVATY']").prop("checked", true);
                        }

                    }
                    //그룹판매사코드
                    $("#txtGroupSaleCompCode").val(response.GroupCompanyCode);

                    var cpConStartDateVal = '';
                    if (!isEmpty(response.CpConStartDate)) cpConStartDateVal = response.CpConStartDate.split("T")[0];
                    var cpConEndDateVal = '';
                    if (!isEmpty(response.CpConEndDate)) cpConEndDateVal = response.CpConEndDate.split("T")[0];

                    //계약 시작일&종료일 세팅
                    $("#<%=this.txtConStartDate.ClientID%>").val(cpConStartDateVal);
                    $("#<%=this.txtConEndDate.ClientID%>").val(cpConEndDateVal);

                } else {
                    alert("오류가 발생했습니다. 잠시 후 다시 시도해 주세요.");
                }
            }

            var sUser = '<%= Svid_User%>';
            var param = { Flag: 'CompanyMngtInfo_Admin', CompCode: qsCompCode, CompNo: qsCompNo, Gubun: qsGubun };
            JajaxSessionCheck('Post', '../../Handler/Admin/CompanyHandler.ashx', param, 'json', callback, sUser);
        }

        //1년후 날짜 세팅
        function fnSetDate() {
            var date = $("#<%=this.txtConStartDate.ClientID%>").val();
            var y = parseInt(date.split('-')[0]) + 1;
            var m = date.split('-')[1];
            var d = date.split('-')[2];
            $("#<%=this.txtConEndDate.ClientID%>").val(y + "-" + m + "-" + d);
        }

        function fnConfirm() {
            var cnt = 0;

            $('#pop_commonTbody tr').each(function (index, element) {
                var check = $(this).find("#cbPopup").is(":checked");
                if (check) {
                    var userId = $(this).find("input:hidden[name='hdPopUserId']").val();

                    $("#txtGroupCompId").val(userId);
                    ++cnt;
                    fnCancel();
                }
            });

            if (cnt == 0) {
                alert('그룹 판매사 아이디를 선택해 주세요.');
                return false;
            }
            return true;
        }

        //[팝업]그룹 판매사 아이디 조회
        function fnSearch(pageNo) {
            var searchKeyword = $("#txtSearch").val();
            var searchTarget = $("#ddlPopSearch").val();
            var pageSize = 15;
            var asynTable = "";
            var i = 1;

            var callback = function (response) {
                $("#pop_commonTbody").empty();

                if (!isEmpty(response)) {

                    $.each(response, function (key, value) {

                        $('#hdTotalCount').val(value.TotalCount);

                        asynTable += "<tr>";
                        asynTable += "<td class='txt-center'><input type='checkbox' id='cbPopup'/><input type='hidden' name='hdPopUserId' value='" + value.Id + "' /></td>";
                        asynTable += "<td class='txt-center'>" + (pageSize * (pageNo - 1) + i) + "</td>";
                        asynTable += "<td class='txt-center' id='tdPopCompName'>" + value.Company_Name + "</td>";
                        asynTable += "<td class='txt-center' id='tdPopUserId'>" + value.Id + "</td>";
                        asynTable += "<td class='txt-center' id='tdPopName'>" + value.Name + "</td>";
                        asynTable += "</tr>";
                        i++;
                    });

                } else {
                    asynTable += "<tr><td colspan='5' class='txt-center'>" + "리스트가 없습니다." + "</td></tr>"
                    $("#pop_commonTbody").val(0);

                }
                $("#tblSearch tbody").append(asynTable);

                //페이징
                fnCreatePagination('pagination', $("#hdTotalCount").val(), pageNo, pageSize, getPageData);
                return false;
            }

            var param = { Method: 'GetUserSearchList', Type: 'A', SearchTarget: searchTarget, SearchKeyword: searchKeyword, PageNo: pageNo, PageSize: pageSize };

            JajaxSessionCheck('Post', '../../Handler/Common/UserHandler.ashx', param, 'json', callback, '<%=Svid_User%>');

        }
        //페이징 인덱스 클릭시 데이터 바인딩
        function getPageData() {
            var container = $('#pagination');
            var getPageNum = container.pagination('getSelectedPageNum');
            fnSearch(getPageNum);
            return false;
        }

        //그룹 판매사 아이디 팝업
        function fnSearchPopup() {

            fnSearch(1);
            fnOpenDivLayerPopup('CodeSearchDiv');

            return false;
        }
        //그룹 판매사 아이디 팝업 닫기
        function fnCancel() {
            $('#CodeSearchDiv').fadeOut();
            return false;
        }

        //[팝업]소셜위드 관리 담당자 조회
        function fnAdmUserIdSearch(pageNo) {
            var searchKeyword = $("#txtPopSearch2").val();
            var searchTarget = $("#ddlPopSearch2").val();
            var pageSize = 15;
            var asynTable = "";
            var i = 1;

            var callback = function (response) {
                $("#pop_admUserIdTbody").empty();

                if (!isEmpty(response)) {

                    $.each(response, function (key, value) {

                        $('#hdTotalCount2').val(value.TotalCount);

                        asynTable += "<tr>";
                        asynTable += "<td class='txt-center'><input type='checkbox' id='cbPopup'/><input type='hidden' name='hdPopUserId' value='" + value.Id + "' /><input type='hidden' name='hdPopUserNm' value='" + value.Name + "' /></td>";
                        asynTable += "<td class='txt-center'>" + (pageSize * (pageNo - 1) + i) + "</td>";
                        asynTable += "<td class='txt-center' id='tdPopUserId'>" + value.Id + "</td>";
                        asynTable += "<td class='txt-center' id='tdPopName'>" + value.Name + "</td>";
                        asynTable += "</tr>";
                        i++;
                    });

                } else {
                    asynTable += "<tr><td colspan='4' class='txt-center'>" + "리스트가 없습니다." + "</td></tr>"
                    $("#pop_admUserIdTbody").val(0);

                }
                $("#pop_admUserIdTbody").append(asynTable);

                //페이징
                fnCreatePagination('pagination2', $("#hdTotalCount2").val(), pageNo, pageSize, getPageData2);
                return false;
            }

            var param = { Method: 'GetUserSearchList', Type: 'AU', SearchTarget: searchTarget, SearchKeyword: searchKeyword, PageNo: pageNo, PageSize: pageSize };

            JajaxSessionCheck('Post', '../../Handler/Common/UserHandler.ashx', param, 'json', callback, '<%=Svid_User%>');

        }
        //페이징 인덱스 클릭시 데이터 바인딩
        function getPageData2() {
            var container = $('#pagination2');
            var getPageNum = container.pagination('getSelectedPageNum');
            fnAdmUserIdSearch(getPageNum);
            return false;
        }

        //소셜위드 관리 담당자 아이디 팝업
        function fnSearchAdmUserIdPopup() {

            fnAdmUserIdSearch(1);
            fnOpenDivLayerPopup('admUserIdSearchDiv');

            return false;
        }

        //소셜위드 관리 담당자 아이디 팝업 확인 버튼 클릭 시
        function fnPopupOkAdmUserId() {
            var cnt = 0;

            $('#tblPopupAdmUserId tr').each(function (index, element) {
                var check = $(this).find("#cbPopup").is(":checked");
                if (check) {
                    var userId = $(this).find("input:hidden[name='hdPopUserId']").val();
                    var userNm = $(this).find("input:hidden[name='hdPopUserNm']").val();

                    $("#txtAdmUserId").val(userId);
                    $("#spAdmUserNm").text(userNm);

                    ++cnt;
                    fnClosePopup("admUserIdSearchDiv");
                }
            });

            if (cnt == 0) {
                alert('소셜위드 관리 담당자 아이디를 선택해 주세요.');
                return false;
            }
            return true;
        }

        function fnSplitText(val, index, splitText) {

            var returnVal = '';

            if (!isEmpty(val)) {
                returnVal = val.split(splitText)[index];
            }
            return returnVal;
        }

        function fnEnter() {
            if (event.keyCode == 13) {
                fnSearch(1);
                return false;
            }
            else
                return true;
        }

        function fnAdminIdPopupEnter() {
            if (event.keyCode == 13) {
                fnAdmUserIdSearch(1);
                return false;
            }
            else
                return true;
        }

        function fnSave() {
            var selectLength = $('#tblSearch input[type="checkbox"]:checked').length;
            if (selectLength < 1) {
                alert('체크박스를 선택해 주세요.');
                return false;
            } else {
                $('#tblSearch input[type="checkbox"]').each(function () {
                    if ($(this).prop('checked') == true) {
                        var compCode = $(this).parent().parent().find("#tdCompCode").text();
                        var compName = $(this).parent().parent().find("#tdCompName").text();

                        $("#txtGroupSaleCompCode").val(compCode);
                    }
                });

                fnCancel();
            }
        }

        // 판매사 플랫폼 유형에 따른 판매사 그룹 사용여부 세팅
        function fnSetCompManagement() {
            var str = $("#sltAPlatform option:selected").text();
            var findVal = str.indexOf("G");
            var trName = $("#tblCompManagement tbody").find("#trUseYN").css("display");

            if (findVal < 0) { // G가 없음
                $("#tblCompManagement tbody").find("#trUseYN").css("display", "none");
                $("#tblCompManagement tbody").find("#trGroupComp").css("display", "none");
            } else if ((findVal >= 0) && (trName == 'none')) { //G가 있음& tr이 없음
                $("#tblCompManagement tbody").find("#trUseYN").css("display", "");
                $("#selectUseYN").val("N").prop("selected", true);
            } else if ((findVal >= 0) && (trName != 'none')) { //G가 있음&tr이 있음
                fnUseYN();
            }
        }

        function fnValidation() {
            //세금계산서 발행정보 필수값
            var txtBillUserNm = ''; //세금계산서 담당자명
            var txtBillTel = '';
            var txtBillEmail = '';
            var txtUptae = ''; //세금계산서 업태
            var txtUpjong = ''; //세금계산서 업종
            var txtEmail1 = '';
            var txtEmail2 = '';
            var txtTelPhone1 = '';
            var txtTelPhone2 = '';
            var txtTelPhone3 = '';

            var txtConStartDate = $("#<%=txtConStartDate.ClientID%>");
            var txtConEndDate = $("#<%=txtConEndDate.ClientID%>");

            var compCode = $("#hdCompCode").val();
            if (isEmpty(compCode)) {
                alert("회사코드가 없습니다. 개발자에게 문의바랍니다.");
                return false;
            }

            var gubun = $("#hdGubun").val();
            if ((gubun == "SU") || (gubun == "IU")) {
                var compName = $("#txtCompName").val();
                if (isEmpty(compName)) {
                    alert("회사명을 입력해 주세요.");
                    $("#txtCompName").focus();
                    return false;
                }

                //세금계산서 발행정보 필수값
                txtBillUserNm = $("#txtBillUserNm"); //세금계산서 담당자명
                txtBillTel = $("#<%= txtTelPhone1.ClientID%>").val() + '-' + $("#<%= txtTelPhone2.ClientID%>").val() + '-' + $("#<%= txtTelPhone3.ClientID%>").val();
                txtBillEmail = $("#<%= txtEmail1.ClientID%>").val() + '@' + $("#<%= txtEmail2.ClientID%>").val();
                txtUptae = $("#txtUptae"); //세금계산서 업태
                txtUpjong = $("#txtUpjong"); //세금계산서 업종

                txtEmail1 = $("#<%=txtEmail1.ClientID%>");
                txtEmail2 = $("#<%=txtEmail2.ClientID%>");

                txtTelPhone1 = $("#<%=txtTelPhone1.ClientID%>");
                txtTelPhone2 = $("#<%=txtTelPhone2.ClientID%>");
                txtTelPhone3 = $("#<%=txtTelPhone3.ClientID%>");

                if (isEmpty(txtBillUserNm.val())) {
                    alert('세금계산서 담당자명을 입력해 주세요');
                    txtBillUserNm.focus();
                    return false;
                }

                if (isEmpty(txtUptae.val())) {
                    alert('세금계산서 업태를 입력해 주세요');
                    txtUptae.focus();
                    return false;
                }

                if (isEmpty(txtTelPhone1.val()) || isEmpty(txtTelPhone2.val()) || isEmpty(txtTelPhone3.val())) {
                    alert('세금계산서 전화번호를 입력해 주세요');
                    txtTelPhone1.focus();
                    return false;
                }

                if (isEmpty(txtUpjong.val())) {
                    alert('세금계산서 업종을 입력해 주세요');
                    txtUpjong.focus();
                    return false;
                }

                if (isEmpty(txtEmail1.val()) || isEmpty(txtEmail2.val())) {
                    alert('세금계산서 이메일을 입력해 주세요');
                    txtBillEmail.focus();
                    return false;
                }

                var regeMail = /^([\w-]+(?:\.[\w-]+)*)@((?:[\w-]+\.)*\w[\w-]{0,66})\.([a-z]{2,6}(?:\.[a-z]{2})?)$/;
                if (!regeMail.test((txtEmail1.val() + '@' + txtEmail2.val()))) {
                    alert("잘못된 이메일 형식입니다.");
                    txtEmail1.focus();
                    return false;
                }

                if (isEmpty($("#ddlABillType").val())) {
                    alert("세금계산서 유형을 선택해 주세요.");
                    return false;
                }

                if (isEmpty($("#<%=ddlAJungEndType.ClientID %>").val())) {
                    alert("정산 마감일을 선택해 주세요.");
                    return false;
                }

                if (isEmpty($("#<%=ddlAJungPayType.ClientID %>").val())) {
                    alert("정산 결제일을 선택해 주세요.");
                    return false;
                }

                var hdATypeRole = $("#hdATypeRole").val(); //판매사 플랫폼 유형
                if (hdATypeRole.indexOf('AU') == 0) {
                    if (isEmpty($("#txtATypeUrl").val())) {
                        alert("판매사 플랫폼 URL을 입력해 주세요.");
                        return false;
                    }
                }
            }

            if (isEmpty(txtConStartDate.val())) {
                alert('계약시작일을 입력해 주세요');
                txtConStartDate.focus();
                return false;
            }

            if (isEmpty(txtConEndDate.val())) {
                alert('계약만료일을 입력해 주세요');
                txtConEndDate.focus();
                return false;
            }

            var groupChk = $("#hdGroupChk").val(); //그룹 G 사용 여부
            if (groupChk == 'Y') {
                if (isEmpty($("#txtGroupCompId").val())) {
                    alert('그룹 G 아이디를 입력해 주세요');
                    $("#txtGroupCompId").focus();
                    return false;
                }
            }

            var hdGubun = $("#hdGubun").val();
            if (((hdGubun == "SU") || (hdGubun == "IU")) && (isEmpty($("#txtAdmUserId").val()))) {
                alert("소셜위드 관리 담당자를 입력해 주세요.");
                return false;
            }

            if (isEmpty($("#txtDelegateName").val())) {
                alert("대표자명을 입력해 주세요.");
                return false;
            }

            if (!confirm("정말로 저장하시겠습니까?")) {
                return false;
            }

            return true;
        }

        // 적용 버튼 클릭 시
        function fnSubmit() {

            if (fnValidation()) {
                var compCode = $("#hdCompCode").val();
                var compNo = $("#hdCompNo").val();
                var gubun = $("#hdGubun").val();
                var compName = $("#hdCompName").val();
                var delFlag = $("#ddlDelFlag").val();
                var BTypeRole = '';
                var ATypeRole = $("#hdATypeRole").val();

                var BOrdType = ''; //구매사 주문 유형
                var Bloanyn = ''; //구매사 대금 결제 묶음 유무
                var saleUrian = ''; //구매사 자사 체크
                var btender = ''; //구매사 입찰유무
                var BDsCode = ''; //(구매사)자사체크코드

                var txtGroupCompId = $("#txtGroupCompId").val(); //그룹 G 아이디
                if (!isEmpty(txtGroupCompId)) $("#hdGroupChk").val("Y");
                var groupChk = $("#hdGroupChk").val(); //그룹 사용 여부

                var txtATypeUrl = $("#txtATypeUrl").val(); //판매사 URL
                var ddlAJungEndType = $("#<%=ddlAJungEndType.ClientID %>").val(); //판매사 정산 마감일
                var ddlAJungPayType = $("#<%=ddlAJungPayType.ClientID %>").val(); //판매사 정산 결제일

                var BPayType = ''; //구매사 결제방식

                var rmpsChkYN = $("#sltRmpsChkYN").val();

                //세금계산서 관련
                var billCheck = '';
                var billUserNm = '';
                var telNo = '';
                var billTel = telNo;
                var faxNo = '';
                var billFaX = faxNo;
                var email = '';
                var billEmail = email;
                var uptae = '';
                var upjong = '';
                var ABillType = '';

                //여신관련
                var compLoanYN = '';
                var loanPrice = '';
                var loanUsePrice = '';
                var loanMonsPayPrice = '';
                var loanPayUsePrice = '';
                var loanEndDate = '';
                var loanPayDate = '';
                var loanBillDate = '';
                var loanCalDate = '';
                var loanCalDue = '';
                var loanStartDate = '';
                var loanPassYN = '';
                var assuranceYN = '';
                var collateralYN = '';
                var loanPayway = '';
                var gdsLoanDelFlag = "";

                var adminUserId = $("#txtAdmUserId").val(); //소셜위드 관리 담당자 ID
                var delegateName = $("#txtDelegateName").val(); //대표자명
                var freeCompYN = $("#ddlFreeCompYN").val(); //민간 업체 유무
                var freeCompVATYN = 'Y'; //민간 업체 부가세 포함 유무
                var autoConfirmYn = $("#ddlAutoConfirmYN").val(); //자동승인 유무

                //민간업체사용일 경우만
                if (freeCompYN == "Y") {
                    $("input:radio[name='rdFreeCompVATYN']").each(function () {
                        if (this.checked) {
                            freeCompVATYN = this.value;
                        }
                    });
                }

                var txtConStartDate = $("#<%=this.txtConStartDate.ClientID%>").val();
                var txtConEndDate = $("#<%=this.txtConEndDate.ClientID%>").val();

                if ((gubun == "SU") || (gubun == "IU")) {
                    compName = $("#txtCompName").val();
                    BTypeRole = '';
                    BPayType = '';
                    BOrdType = '';
                    Bloanyn = '';
                    saleUrian = '';
                    BDsCode = '';
                    compLoanYN = "N";
                    loanPrice = '';
                    loanUsePrice = '';
                    loanMonsPayPrice = '';
                    loanPayUsePrice = '';
                    loanEndDate = '';
                    loanPayDate = '';
                    loanBillDate = '';
                    loanCalDate = '';
                    loanCalDue = '';
                    loanStartDate = '';
                    loanPassYN = '';
                    assuranceYN = '';
                    collateralYN = '';
                    loanPayway = '';

                    billCheck = "Y";
                    billUserNm = $("#txtBillUserNm").val();

                    telNo = $("#<%= txtTelPhone1.ClientID%>").val() + '-' + $("#<%= txtTelPhone2.ClientID%>").val() + '-' + $("#<%= txtTelPhone3.ClientID%>").val();
                    billTel = telNo;

                    faxNo = $("#<%= txtFax1.ClientID%>").val() + '-' + $("#<%= txtFax2.ClientID%>").val() + '-' + $("#<%= txtFax3.ClientID%>").val();
                    billFaX = faxNo;

                    email = $("#<%= txtEmail1.ClientID%>").val() + '@' + $("#<%= txtEmail2.ClientID%>").val();
                    billEmail = email;

                    uptae = $("#txtUptae").val();
                    upjong = $("#txtUpjong").val();
                    ABillType = $("#ddlABillType").val();

                }

                //세금계산서 발행정보 입력 충족 안 된 경우
                if (isEmpty(billTel) || isEmpty(billEmail) || isEmpty(billUserNm) || isEmpty(uptae) || isEmpty(upjong) || isEmpty(ABillType)) {
                    billCheck = "N";
                }
            
                var callback = function (response) {
                    if (response == 'OK') {
                        alert("성공적으로 저장되었습니다.");
                        location.href = 'CompanyManagement.aspx?ucode=' + ucode;

                    } else {
                        alert("오류가 발생했습니다. 개발자에게 문의해 주세요.");
                    }

                    return false;
                }

                var param = {
                    Flag: 'SaveCompMngt'
                    , CompCode: compCode
                    , CompNo: compNo
                    , Gubun: gubun
                    , CompNm: compName
                    , DelFlag: delFlag
                    , BTypeRole: BTypeRole
                    , ATypeRole: ATypeRole
                    , BPayType: BPayType
                    , BillCheck: billCheck
                    , BillUserNm: billUserNm
                    , BillTel: billTel
                    , BillFax: billFaX
                    , BillEmail: billEmail
                    , Uptae: uptae
                    , Upjong: upjong
                    , CompLoanYN: compLoanYN
                    , LoanPrice: loanPrice
                    , LoanUsePrice: loanUsePrice
                    , LoanPayUsePrice: loanPayUsePrice
                    , LoanPayway: loanPayway
                    , AssuranceYN: assuranceYN
                    , CollateralYN: collateralYN
                    , GdsLoanDelFlag: gdsLoanDelFlag
                    , LoanPayDate: loanPayDate
                    , LoanStartDate: loanStartDate
                    , LoanEndDate: loanEndDate
                    , LoanMonsPayPrice: loanMonsPayPrice
                    , LoanBillDate: loanBillDate
                    , LoanCalDate: loanCalDate
                    , LoanCalDue: loanCalDue
                    , LoanPassYN: loanPassYN
                    , Bloanyn: Bloanyn
                    , GroupSaleCompId: txtGroupCompId
                    , StartDate: txtConStartDate
                    , EndDate: txtConEndDate
                    , BOrdType: BOrdType
                    , SaleUrian: saleUrian
                    , GroupChk: groupChk
                    , ATypeUrl: txtATypeUrl
                    , AdminUserId: adminUserId
                    , DelegateName: delegateName
                    , ABillType: ABillType
                    , BDsCode: BDsCode
                    , BTender: btender
                    , FreeCompYN: freeCompYN
                    , FreeCompVATYN: freeCompVATYN
                    , AutoConfirmYn: autoConfirmYn
                    , RmpsChkYN: rmpsChkYN
                    //, AJungEndType: ddlAJungEndType
                    //, AJungPayType: ddlAJungPayType
                };

                var beforeSend = function () {
                    is_sending = true;
                }
                var complete = function () {
                    is_sending = false;
                }
                if (is_sending) return false;

                JqueryAjax('Post', '../../Handler/Admin/CompanyHandler.ashx', false, false, param, 'text', callback, beforeSend, complete, true, '<%=Svid_User%>');
            }
        }

        //금액에 실시간 콤마 입력
        function fnAutoComma(event) {
            var goodsBuyPrice = $(event).val();
            goodsBuyPrice = goodsBuyPrice.replace(/[^\d]+/g, ''); // (,)지우기  

            $(event).val(numberWithCommas(goodsBuyPrice));
        }

        //페이지 이동
        function fnGoPage(pageVal) {
            switch (pageVal) {
                case "LIST":
                    window.location.href = "../Company/CompanyManagement?ucode=" + ucode;
                    break;
                default:
                    break;
            }
        }


    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div class="all">
        <div class="sub-contents-div">
            <div class="sub-title-div">
                <p class="p-title-mainsentence">
                    회사 추가 정보
                    <span class="span-title-subsentence"></span>
                </p>
            </div>
            <br />

            <div class="divStrapLine">
                <h4>회사관리</h4>
            </div>
            <table class="tbl_main" id="tblCompManagement">
                <colgroup>
                    <col style="width: 20%" />
                    <col />
                    <col />
                    <col />
                </colgroup>
                <thead>
                </thead>
                <tbody>
                    <tr>
                        <th>구분
                            <input type="hidden" id="hdCompCode" />
                            <input type="hidden" id="hdCompNo" />
                            <input type="hidden" id="hdGubun" />
                            <input type="hidden" id="hdCompName" />
                            <input type="hidden" id="hdATypeRole" />
                            <input type="hidden" id="hdBTypeRole" />
                            <input type="hidden" id="hdDelFlag" />
                            <input type="hidden" id="hdGroupChk" />
                        </th>
                        <td id="tdGubun" colspan="3"></td>
                    </tr>
                    <tr>
                        <th>회사명</th>
                        <td id="tdCompName"></td>
                        <th>회사코드</th>
                        <td id="tdCompCode"></td>
                    </tr>
                    <tr>
                        <th>사업자번호</th>
                        <td id="tdCompNo"></td>
                        <th>판매사 자동승인 유무</th>
                        <td>
                            <select id="ddlAutoConfirmYN" class="selectCompManagement" style="width: 80px">
                                <option value="N">아니오</option>
                                <option value="Y">예</option>
                            </select>
                        </td>
                    </tr>
                    <tr>
                        <th>거래 현황</th>
                        <td>
                            <select id="ddlDelFlag" class="selectCompManagement">
                                <option value="N">거래중</option>
                                <option value="Y">거래중지</option>
                            </select>
                        </td>
                        <th>민간 업체 유무</th>
                        <td colspan="3" id="tdFreeCompYN">
                            <select id="ddlFreeCompYN" class="selectCompManagement" style="width: 80px">
                                <option value="N">아니오</option>
                                <option value="Y">예</option>
                            </select>
                            <span id="spFreeCompVAT" style="margin-left: 20px;">
                                <input type="radio" name="rdFreeCompVATYN" id="rdFreeCompVATN" value="N" />
                                <label for="rdFreeCompVATN">부가세 별도</label>
                                &nbsp;&nbsp;
                                <input type="radio" name="rdFreeCompVATYN" id="rdFreeCompVATY" value="Y" />
                                <label for="rdFreeCompVATY">부가세 포함</label>
                            </span>
                        </td>
                    </tr>
                    <tr>
                        <th>계약 시작일</th>
                        <td>
                            <asp:TextBox ID="txtConStartDate" runat="server" CssClass="calendar" ReadOnly="true" Height="24px" onkeypress="return fnEnter()" onchange="return fnSetDate()"></asp:TextBox>
                        </td>
                        <th>계약 만료일</th>
                        <td>
                            <asp:TextBox ID="txtConEndDate" runat="server" CssClass="calendar" ReadOnly="true" Height="24px" onkeypress="return fnEnter()"></asp:TextBox>
                        </td>
                    </tr>
                    
                    <tr id="trATypeRole">
                        <th>판매사 플랫폼 유형</th>
                        <td colspan="3">
                            <%--<asp:DropDownList runat="server" ID="ddlAPlatform" CssClass="selectCompManagement"></asp:DropDownList>--%>
                            <select id="sltAPlatform" class="selectCompManagement">
                                <option value="">-선택-</option>
                            </select>
                            <%--<asp:Label runat="server" ID="lblAPlatform"></asp:Label>--%>
                            <%--<label id="lblAPlatform"></label>--%>
                            <span style="margin-left: 15px;">
                                <input type="checkbox" id="chkNonePlatform" value="" />
                                <label for="chkNonePlatform">유형 없음</label>
                            </span>
                        </td>
                    </tr>
                    <tr>
                        <th>판매사 RMPS 유무</th>
                        <td colspan="3">
                            <select id="sltRmpsChkYN" class="selectCompManagement" style="width:80px">
                                <option value="N" selected="selected">아니오</option>
                                <option value="Y">예</option>
                            </select>
                        </td>
                    </tr>
                    <tr id="trGroupComp" style="display: none;">
                        <th>그룹 G 아이디</th>
                        <td colspan="3">
                            <input class="txtCompManagement" id="txtGroupCompId" onkeypress="return fnEnter()" type="text" readonly="readonly">
                            <a class="imgA" onclick="return fnSearchPopup()">
                                <img class="search-img" onmouseover="this.src='../../AdminSub/Images/Goods/search-bt-on.jpg'" onmouseout="this.src='../../AdminSub/Images/Goods/search-bt-off.jpg'" alt="검색" src="../../AdminSub/Images/Goods/search-bt-off.jpg">
                            </a>
                        </td>
                    </tr>
                    <tr id="trATypeUrl">
                        <th>판매사 플랫폼 URL</th>
                        <td colspan="3">http://
                            <input type="text" id="txtATypeUrl" class="txtCompManagement" style="width: 400px;" />
                        </td>
                    </tr>
                    <tr id="trDelegateName">
                        <th>대표자명</th>
                        <td colspan="3">
                            <input type="text" id="txtDelegateName" class="txtCompManagement" style="width: 300px;" />
                        </td>
                    </tr>
                    <tr id="trAdmUserId">
                        <th>소셜위드 관리 담당자 ID</th>
                        <td style="width: 26%">
                            <input class="txtCompManagement" id="txtAdmUserId" onkeypress="return fnEnter()" type="text" readonly="readonly">
                            <a href="#none" class="mainbtn type1" style="width:75px;" onclick="return fnSearchAdmUserIdPopup(); return false">검색</a>
                        </td>
                        <th>소셜위드 관리 담당자명</th>
                        <td><span id="spAdmUserNm"></span></td>
                    </tr>

                    <tr id="trJungsan_A">
                        <th>정산 마감일(추후 개발예정)</th>
                        <td>
                            <asp:DropDownList runat="server" ID="ddlAJungEndType" CssClass="selectCompManagement">
                                <asp:ListItem Value="30" Selected="True">30일</asp:ListItem>
                            </asp:DropDownList>
                        </td>
                        <th>정산 결제일(추후 개발예정)</th>
                        <td>
                            <asp:DropDownList runat="server" ID="ddlAJungPayType" CssClass="selectCompManagement">
                                <asp:ListItem Value="15" Selected="True">15일</asp:ListItem>
                            </asp:DropDownList>
                        </td>
                    </tr>
                </tbody>
            </table>
            <br />


            <div id="divBill">
                <div class="divStrapLine">
                    <h4>세금계산서 발행정보</h4>
                </div>
                <table class="tbl_main">
                    <colgroup>
                        <col style="width: 20%" />
                        <col />
                        <col style="width: 20%" />
                        <col />
                    </colgroup>
                    <thead>
                    </thead>
                    <tbody>
                        <tr>
                            <th>세금계산서 담당자명</th>
                            <td>
                                <input type="text" class="txtCompManagement" id="txtBillUserNm" onkeypress="return fnEnter()" />
                            </td>
                            <th>세금계산서 업태</th>
                            <td>
                                <input type="text" class="txtCompManagement" id="txtUptae" onkeypress="return fnEnter()" />
                            </td>
                        </tr>

                        <tr>
                            <th>세금계산서 전화번호</th>
                            <td>

                                <asp:TextBox ID="txtTelPhone1" runat="server" Width="90px" max="99999" oninput="return maxLengthCheck(this)" MaxLength="4" TextMode="Number" onkeypress="return onlyNumbers(event);" CssClass="txtCompManagement"></asp:TextBox>&nbsp;&nbsp;-&nbsp;
                        <asp:TextBox ID="txtTelPhone2" runat="server" Width="110px" max="99999" oninput="return maxLengthCheck(this)" MaxLength="4" TextMode="Number" onkeypress="return onlyNumbers(event);" CssClass="txtCompManagement"></asp:TextBox>&nbsp;&nbsp;-&nbsp;
                        <asp:TextBox ID="txtTelPhone3" runat="server" Width="140px" max="99999" oninput="return maxLengthCheck(this)" MaxLength="4" TextMode="Number" onkeypress="return onlyNumbers(event);" CssClass="txtCompManagement"></asp:TextBox>
                            </td>
                            <th>세금계산서 업종</th>
                            <td>
                                <input type="text" class="txtCompManagement" id="txtUpjong" onkeypress="return fnEnter()" />
                            </td>
                        </tr>

                        <tr>
                            <th>세금계산서 FAX번호</th>
                            <td>
                                <asp:TextBox ID="txtFax1" runat="server" Width="90px" max="99999" oninput="return maxLengthCheck(this)" MaxLength="4" TextMode="Number" onkeypress="return onlyNumbers(event);" CssClass="txtCompManagement"></asp:TextBox>&nbsp;&nbsp;-&nbsp;
                            <asp:TextBox ID="txtFax2" runat="server" Width="110px" max="99999" oninput="return maxLengthCheck(this)" MaxLength="4" TextMode="Number" onkeypress="return onlyNumbers(event);" CssClass="txtCompManagement"></asp:TextBox>&nbsp;&nbsp;-&nbsp;
                            <asp:TextBox ID="txtFax3" runat="server" Width="140px" max="99999" oninput="return maxLengthCheck(this)" MaxLength="4" TextMode="Number" onkeypress="return onlyNumbers(event);" CssClass="txtCompManagement"></asp:TextBox>
                            </td>
                            <th>세금계산서 유형</th>
                            <td>
                                <select id="ddlABillType" class="selectCompManagement">
                                    <option value="1">위수탁</option>
                                    <option value="2">판매사 발행</option>
                                </select>
                            </td>
                        </tr>
                        <tr>
                            <th>세금계산서 EMAIL</th>
                            <td colspan="3">
                                <asp:TextBox ID="txtEmail1" runat="server" Width="150px" onkeypress="return fnEnter()" CssClass="txtCompManagement"></asp:TextBox>&nbsp;&nbsp;@&nbsp;
                            <asp:TextBox ID="txtEmail2" runat="server" Width="250px" onkeypress="return fnEnter()" CssClass="txtCompManagement"></asp:TextBox>
                            </td>
                        </tr>

                    </tbody>
                </table>
                <br />
            </div>

            <div style="float: right">
                <input type="button" class="mainbtn type1" style="width: 105px; height: 30px; font-size: 12px" value="목록" onclick="fnGoPage('LIST')" />
                <input type="button" class="mainbtn type1" style="width: 105px; height: 30px; font-size: 12px" value="적용" onclick="return fnSubmit();" />
            </div>
        </div>
    </div>

    <!--팝업-->
    <div id="CodeSearchDiv" class="divpopup-layer-package">
        <div class="bordertypeWrapper" style="margin-top: 50px">
            <div class="bordertypeContent" style="border: none; height: 700px">
                <div class="divpopup-layer-container" style="height: 100%">
                    <div class="sub-title-div" id="divSubTitle">
                        <img src="../Images/Company/grounpSearch-pop.jpg" alt="그룹 판매사 아이디 검색" />
                    </div>

                    <div class="divpopup-layer-conts">
                        <div>
                            <%--<div id="divSelectBox" style="display:inline">--%>
                            <select id="ddlPopSearch" class="selectCompManagement">
                                <option value="Name">이름</option>
                                <option value="Id">아이디</option>
                            </select>
                            <%--</div>--%>
                            <input type="text" id="txtSearch" style="width: 300px; height: 25px; border: 1px solid #a2a2a2" onkeypress="return fnEnter()" placeholder="검색어를 입력해 주세요." />
                            <a href="#none" class="mainbtn type1" onclick="return fnSearch(1); return false">검색</a>
                        </div>

                        <div class="divScr" style="margin-top: 20px">
                            <table id="tblSearch" style="width: 100%; margin-top: 0px" class="board-table">
                                <colgroup>
                                    <col style="width: 10px" />
                                    <col style="width: 20px" />
                                    <col style="width: 80px" />
                                    <col style="width: 100px" />
                                    <col style="width: 50px" />
                                </colgroup>
                                <thead>
                                    <tr class="board-tr-height">
                                        <th class="txt-center"></th>
                                        <th class="txt-center">번호</th>
                                        <th class="txt-center" id="thComp">그룹 판매사명</th>
                                        <th class="txt-center" id="thId">아이디</th>
                                        <th class="txt-center" id="thName">이름</th>
                                    </tr>
                                </thead>
                                <tbody id="pop_commonTbody" style="height: 25px">
                                    <tr>
                                        <td colspan="5" class="txt-center">리스트가 없습니다.</td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                        <br />

                        <!--페이징-->
                        <input type="hidden" id="hdTotalCount" />
                        <div style="margin: 0 auto; text-align: center">
                            <div id="pagination" class="page_curl" style="display: inline-block"></div>
                        </div>

                        <div style="text-align: right">
                            <a onclick="fnCancel()" id="btnCancel">
                                <img src="../../Images/cancle_btn.jpg" alt="취소" onmouseover="this.src='../../Images/cancle_on_btn.jpg'" onmouseout="this.src='../../Images/cancle_btn.jpg'" /></a>
                            <a onclick="fnConfirm()" id="btnSave">
                                <input type="hidden" id="hdSelectCode" />
                                <input type="hidden" id="hdSelectName" />
                                <img src="../Images/Goods/submit1-off.jpg" alt="확인" onmouseover="this.src='../Images/Goods/submit1-on.jpg'" onmouseout="this.src='../Images/Goods/submit1-off.jpg'" />
                            </a>
                        </div>

                    </div>
                </div>
            </div>
        </div>
    </div>

    <%--소셜위드 관리 담당자 ID--%>
    <div id="admUserIdSearchDiv" class="popupdiv divpopup-layer-package">
        <div class="popupdivWrapper" style="width: 650px; height: 730px">
            <div class="popupdivContents">
                <div class="close-div">
                    <a onclick="fnClosePopup('admUserIdSearchDiv'); return false;" style="cursor: pointer">
                        <img src="../../Images/Wish/icon-delete.jpg" alt="닫기" style="float: right;" /></a>
                </div>
                <div class="popup-title">
                    <h3 class="pop-title">소셜위드 관리 담당자 조회</h3>
                    <div class="search-div" style="overflow:hidden;" >
                        <select id="ddlPopSearch2" style="float:left;" class="selectCompManagement">
                            <option value="Name">이름</option>
                            <option value="Id">아이디</option>
                        </select>
                        <input type="text" class="text-code" id="txtPopSearch2" style="float:left; margin-left:5px; width: 300px " placeholder="검색어를 입력해 주세요." onkeypress="return fnAdminIdPopupEnter();"  />
                        <a class="mainbtn type1" style="float:left; margin-left:5px; padding:0 20px" onclick="fnAdmUserIdSearch(1); return false;">검색</a>
                    </div>


                    <div class="divpopup-layer-conts">
                        <table id="tblPopupAdmUserId" class="tbl_main tbl_pop">
                            <thead>
                                <tr>
                                    <th class="text-center" style="width: 10%">선택</th>
                                    <th class="text-center">번호</th>
                                    <th class="text-center">담당자 ID</th>
                                    <th class="text-center">담당자명</th>
                                </tr>
                            </thead>
                            <tbody id="pop_admUserIdTbody">
                                <tr>
                                    <td colspan="4" class="text-center">리스트가 없습니다.</td>
                                </tr>
                            </tbody>
                        </table>
                        <!-- 페이징 처리 -->
                        <div style="margin: 0 auto; text-align: center; padding-top:20px">
                            <input type="hidden" id="hdTotalCount2" />
                            <div id="pagination2" class="page_curl" style="display: inline-block"></div>
                        </div>
                    </div>

                    <div class="btn_center">
                        <a href="#none" class="mainbtn type2" style="width:75px" onclick="fnClosePopup('admUserIdSearchDiv'); return false;">취소</a>
                        <a href="#none" class="mainbtn type1" style="width:75px" onclick="fnPopupOkAdmUserId(); return false;">확인</a>
                    </div>
                </div>
            </div>
        </div>
    </div>

</asp:Content>

