<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Master/AdminMasterPage.master" AutoEventWireup="true" CodeFile="CompManagementInfo_B.aspx.cs" Inherits="Admin_Company_CompManagementInfo_B" %>

<%@ Import Namespace="System.Web.Script.Serialization" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <link href="../Content/Member/member.css" rel="stylesheet" />
    <link href="../Content/Company/company.css" rel="stylesheet" />
    <link href="../Content/popup.css" rel="stylesheet" />

    <style>

        .lbl-tip-th {
            font-size: 11px;
            color: red;
            font-weight: normal;
        }
    </style>
    <script type="text/javascript">
        var is_sending = false;
        $(document).ready(function () {

            ListCheckboxOnlyOne("tblPopupAdmUserId");

            //달력
            $("#txtConStartDate").datepicker({
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

            $("#txtConEndDate").datepicker({
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

            $("#txtLoanStartDate").datepicker({
                showAnimation: 'slideDown',
                changeMonth: true,
                changeYear: true,
                showOn: 'button',
                buttonImage:/* "/Images/icon_calandar.png"*/"../../Images/Goods/calendar.jpg",
                buttonImageOnly: true,
                dateFormat: "yy-mm-dd",
                monthNamesShort: ["1월", "2월", "3월", "4월", "5월", "6월", "7월", "8월", "9월", "10월", "11월", "12월"],
                dayNamesMin: ["일", "월", "화", "수", "목", "금", "토"],
                showMonthAfterYear: true,
                beforeShow: function () {
                    $(this).css({
                        "position": "relative",
                        "z-index": '999999'
                    });
                },
            });

            //여신계산일자
            $("#txtLoanCalDate").datepicker({
                showAnimation: 'slideDown',
                changeMonth: true,
                changeYear: true,
                showOn: 'button',
                buttonImage:/* "/Images/icon_calandar.png"*/"../../Images/Goods/calendar.jpg",
                buttonImageOnly: true,
                dateFormat: "yy-mm-dd",
                monthNamesShort: ["1월", "2월", "3월", "4월", "5월", "6월", "7월", "8월", "9월", "10월", "11월", "12월"],
                dayNamesMin: ["일", "월", "화", "수", "목", "금", "토"],
                showMonthAfterYear: true,
                beforeShow: function () {
                    $(this).css({
                        "position": "relative",
                        "z-index": '999999'
                    });
                },
            });

            //구매사 주문 유형 이벤트
            $("#<%=ddlBOrdType.ClientID%>").on('change', function () {
                fnSetBOrderType("CHG", $(this).val());
            });

            $("#ddlFreeCompYN").on('change', function () {
                if ($(this).val() == "Y") {
                    $("#rdFreeCompVATN").prop("checked", true);
                    $("#rdFreeCompVATN").prop("disabled", false);
                    $("#rdFreeCompVATY").prop("disabled", false);

                    $("#spFreeCompVAT").css("display", "");

                    $("#ddlBtender").val("N");
                    $("#ddlBtender").prop("disabled", false);

                } else {
                    $("#rdFreeCompVATN").prop("checked", false);
                    $("#rdFreeCompVATY").prop("checked", false);
                    $("#rdFreeCompVATN").prop("disabled", true);
                    $("#rdFreeCompVATY").prop("disabled", true);

                    $("#spFreeCompVAT").css("display", "none");

                    $("#ddlBtender").val("N");
                    $("#ddlBtender").prop("disabled", true);
                }
            });

            //여신기간
            $("#ddlLoanCalDue").on("change", function () {
                fnSetLoanPayMonth($(this).val());
            });

            $("#txtLoanStartDate").on("change", function () {
                if (isEmpty($("#txtLoanCalDate").val())) {
                    $("#txtLoanCalDate").val($(this).val());
                }
            });

            //여신 여부 이벤트
            var prevVal = '';
            $("#ddlLoanYN").focus(function () {
                prevVal = $(this).val();
            }).change(function () {
                $(this).blur();

                var flag = $(this).val();
                var loanUsePrice = isEmpty($("#txtLoanUsePrice").val()) == true ? 0 : Number($("#txtLoanUsePrice").val().replace(/[^0-9 | ^.]/g, ''));
                var loanPayUsePrice = isEmpty($("#txtLoanPayUsePrice").val()) == true ? 0 : Number($("#txtLoanPayUsePrice").val().replace(/[^0-9 | ^.]/g, ''));
                var BOrdTypeVal = $("#<%=ddlBOrdType.ClientID%>").val();

                if (flag == 'N') {
                    if ((loanUsePrice > 0) || (loanPayUsePrice > 0)) {
                        alert("미수금액이나 대금 미수금액이 있는 경우 여신 여부를 '아니오'로 설정하실 수 없습니다.");
                        $(this).val('Y');
                        return false;

                    } else {
                        //var BOrdTypeConfirmVal = confirm("여신을 사용하지 않을 경우 구매사 주문 유형이 자동으로 'B-comT' 유형으로 변경됩니다.\n정말로 여신여부를 '아니오'로 설정하시겠습니까? ");
                        //if (BOrdTypeConfirmVal) {
                            <%--$("#<%=ddlBOrdType.ClientID%>").val("4");--%>

                            <%--BOrdTypeVal = $("#<%=ddlBOrdType.ClientID%>").val();--%>

                            fnSetCompLoanYn("CHG", BOrdTypeVal); //여신여부에 따른 설정

                            //} else {
                            //    $("#ddlLoanYN").val(prevVal);
                            //    return false;
                            //}
                        }

                    } else {

                        fnSetLoanPayMonth($("#ddlLoanCalDue").val());

                        fnSetCompLoanYn("CHG", BOrdTypeVal); //여신여부에 따른 설정
                    }

                    return false;
                });

            fnSetPageLoad(); //화면 설정
        });

        // enter key 방지
        $(document).on("keypress", "#tblCompManagement input, #tblCompTypeManagement input, #tblCompLoanManagement input, #tblCompPayManagement checkbox", function (e) {
            if (e.keyCode == 13) {
                return false;
            }
            else
                return true;
        });



        //화면 설정
        function fnSetPageLoad() {
            var callback = function (response) {
                if (!isEmpty(response)) {
                    var gubun = response.Gubun;
                    var gubunName = response.Gubun_Name;
                    var compLoanYN = response.CompLoanYN; //여신 사용 여부

                    var BOrdType = response.BOrderType; //구매사 주문 유형
                    var saleUrianChk = response.BmroCheck; //자사 체크
                    var tenderYN = response.BTenderYN; //입찰 유무
                    var textImgYN = ''; //첨부파일유무(사업자등록증) 출력값
                    var admUserId = response.AdminUserId; //소셜위드 관리 담당자ID
                    var admUserNm = response.AdminUserName; //소셜위드 관리 담당자명
                    var delegateNm = response.Delegate_Name; //대표자명
                    var freeCompYN = response.FreeCompanyYN; //민간 업체 유무
                    var freeCompVATYN = response.FreeCompanyVATYN; //민간 업체 부가세포함 유무
                    var sameComNOYN = response.SameComNO_AB_YN; //판매사=구매사 여부
                    var BLoanYN = response.BLoanYN; //구매사 대금 결제 묶음 유무
                    var BOrderSelectWeek = response.BOrderSelectWeek; //구매사 주문선택 주기
                    var BPestimateCompareYN = response.BPestimateCompareYN; //가격비교사용유무

                    if (isEmpty(BOrderSelectWeek) || (BOrderSelectWeek == '0')) BOrderSelectWeek = '4';
                    if (isEmpty(BPestimateCompareYN)) BPestimateCompareYN = 'N';

                    $("#tdCompName").empty();

                    $("#hdCompCode").val(response.Company_Code);
                    $("#hdCompNo").val(response.Company_No);
                    $("#hdGubun").val(gubun);
                    $("#hdCompName").val(response.Company_Name);

                    $("#hdBTypeRole").val(response.BTypeRole);
                    $("#hdDelFlag").val(response.DelFlag);
                    $("#hdCompLoanYN").val(compLoanYN);
                    $("#hdLoanPayway").val(response.LoanPayway);
                    //$("#hdGroupChk").val(response.GroupCheck); //판매사 그룹 사용 여부
                    $("#hdImgYN").val(response.ImgYN); //첨부파일유무(사업자등록증)
                    $('#hdPayway').val(response.BPayType); //구매사 결제수단

                    $("#tdGubun").text(gubunName); //구분
                    $("#txtDelegateName").val(delegateNm); //대표자명
                    $("#ddlFreeCompYN").val(freeCompYN);
                    $("#sameComNoYN").val(sameComNOYN);

                    $("#tdCompCode").text($("#hdCompCode").val());

                    $("#tdCompName").text(response.Company_Name); //회사명
                    $("#trATypeRole").css("display", "none"); //판매사플랫폼 유형
                    $("#trUseYN").css("display", "none"); //판매사 그룹 사용 여부
                    $("#trATypeUrl").css("display", "none"); //판매사 플랫폼 URL
                    //$("#trGroupComp").css("display", "none"); //판매사 그룹 ID
                    //$("#trAdmUserId").css("display", "none"); //소셜위드 관리 담당자
                    $("#trJungsan_A").css("display", "none"); //판매사 정산 마감일, 정산 결제일 

                    $("#selectUseYN").val('');
                    $("#tdCompNo").text(response.Company_No); //사업자번호
                    $("#txtComRemark").val(response.Remark); //비고

                    $("#ddlBOrderSelectWeek").val(BOrderSelectWeek); //구매사 주문선택 주기
                    $("#ddlBPCompareYN").val(BPestimateCompareYN); //가격비교사용유무

                    //구매사 사업자등록증 첨부 유무 처리
                    if ($("#hdImgYN").val() == 'Y') {
                        textImgYN = "있음";
                    } else {
                        textImgYN = "없음";
                    }
                    $("#spImgYN").text(textImgYN);

                    //계약 시작일&종료일 세팅
                    var cpConStartDateVal = '';
                    if (!isEmpty(response.CpConStartDate)) cpConStartDateVal = response.CpConStartDate.split("T")[0];
                    var cpConEndDateVal = '';
                    if (!isEmpty(response.CpConEndDate)) cpConEndDateVal = response.CpConEndDate.split("T")[0];

                    $("#txtConStartDate").val(cpConStartDateVal);
                    $("#txtConEndDate").val(cpConEndDateVal);

                    //값 설정
                    $("#ddlDelFlag").val(response.DelFlag);

                    //소셜위드 관리 담당자 처리
                    if (isEmpty(admUserId)) {
                        $("#txtAdmUserId").val('');
                        $("#spAdmUserNm").text('');
                    } else {
                        $("#txtAdmUserId").val(admUserId); //소셜위드 관리 담당자 ID
                        $("#spAdmUserNm").text(admUserNm);
                    }

                    /////////////////////////////////////////////////////

                    //자사 체크 설정
                    if (isEmpty(saleUrianChk)) saleUrianChk = "N";

                    $("#ddlSaleUrian").val(saleUrianChk); //자사 체크

                    //판매사,구매사 둘 다 존재하는 경우
                    if (sameComNOYN == "Y") $("#ddlSaleUrian").find("option[value='A']").prop("disabled", false);
                    else $("#ddlSaleUrian").find("option[value='A']").prop("disabled", true);

                    //민간 업체 유무 부분
                    if (freeCompYN == 'Y') {
                        $("#spFreeCompVAT").css("display", '');

                        $("input:radio[name='rdFreeCompVATYN']").each(function () {
                            if (this.value == freeCompVATYN) {
                                this.checked = true;
                            }
                        });

                        $("#ddlBtender").prop("disabled", false);

                        $("#ddlSaleUrian").find("option[value='A']").prop("disabled", true); //민간업체인 경우 자사체크에서 판매사 가격 선택 불가

                    } else {
                        $("#rdFreeCompVATN").prop("checked", false);
                        $("#rdFreeCompVATY").prop("checked", false);
                        $("#rdFreeCompVATN").prop("disabled", true);
                        $("#rdFreeCompVATY").prop("disabled", true);

                        $("#spFreeCompVAT").css("display", "none");

                        $("#ddlBtender").prop("disabled", true);
                    }

                    //입찰유무
                    if (isEmpty(tenderYN)) tenderYN = "N";
                    $("#ddlBtender").val(tenderYN);

                    if (isEmpty(BLoanYN)) BLoanYN = "N";
                    $("#ddlBloanyn").val(BLoanYN);

                    ////////////////////////////////////////////////////

                    //여신관리 부분
                    if (isEmpty(compLoanYN)) compLoanYN = "N";
                    $("#ddlLoanYN").val(compLoanYN);

                    var assuranceYN = response.AssuranceYN; //보증여부
                    var collateralYN = response.CollateralYN; //담보여부

                    var loanUserPrice = response.LoanUsePrice;
                    var loanPayUserPrice = response.LoanPayUsePrice;
                    var loanPrice = response.LoanPrice;
                    var loanMonsPayPrice = response.LoanMonsPayPrice; //월마감 미수금액
                    var loanPassYN = response.LoanPassYN; //여신 패스기능
                    var loanStartDate = "";//여신거래일자
                    var loanCalDate = response.LoanCalDate; //여신계산일자
                    var loanCalDue = $.trim(response.LoanCalDue); //여신기간
                    var loanBillDate = response.LoanBillDate; //세금계산서 발행일자 출력일(2자리)

                    if (compLoanYN != "N") {

                        $("#txtLoanUsePrice").val(numberWithCommas(loanUserPrice)); //여신 사용금액
                        $("#txtLoanPayUsePrice").val(numberWithCommas(loanPayUserPrice)); //월마감 대금 납입금액
                        $("#txtLoanPrice").val(numberWithCommas(loanPrice)); //여신한도
                        $("#txtLoanMonsPayPrice").val(numberWithCommas(loanMonsPayPrice)); //월마감 미수금액

                        if (isEmpty(loanPassYN)) loanPassYN = 'N';
                        $("#ddlLoanPassYN").val(loanPassYN);

                        if (!isEmpty(response.LoanStartDate)) loanStartDate = response.LoanStartDate.split('T')[0]; //여신거래일자

                        $("#txtLoanStartDate").val(loanStartDate); //거래일자
                        $("#txtLoanEndDate").val(response.LoanEndDate); //여신 마감일(2자리)
                        $("#txtLoanPayDate").val(response.LoanPayDate); //여신 결제일(2자리)
                        $("#txtLoanBillDate").val(loanBillDate); //세금계산서 발행일자 출력일

                        $("#txtLoanCalDate").val(loanCalDate.replace(/(\d{4})(\d{2})(\d{2})/g, '$1-$2-$3')); //여신계산일자
                        $("#ddlLoanCalDue").val(loanCalDue); //여신기간

                        fnSetLoanPayMonth(loanCalDue); //대금결제일 월표시
                    }

                    if (!isEmpty(assuranceYN)) $("#ddlAssuranceYN").val(assuranceYN);
                    if (!isEmpty(collateralYN)) $("#ddlCollateralYN").val(collateralYN);

                    ////////////////////////////////////////////////////////////////

                    if (isEmpty($("#hdBTypeRole").val())) $("#hdBTypeRole").val("A");
                    $("#<%=ddlBTypeRole.ClientID %>").val($("#hdBTypeRole").val()); //구매사 결제 유형

                    $("#<%=ddlBOrdType.ClientID %>").val(BOrdType);

                    ////////////////////////////////////////////////////////////////

                    //여신 제출서류 관련
                    var commChList = "1,2"; //channel번호
                    var commCode = "COMPANY";

                    fnGetComm(commCode, commChList); //여신 제출서류 항목 조회

                    fnSetBOrderType("LOAD", BOrdType); //구매사 주문 유형에 따른 값 설정

                } else {
                    alert("오류가 발생했습니다. 잠시 후 다시 시도해 주세요.");
                }
            }

            var sUser = '<%= Svid_User%>';
            var qsCompCode = '<%=qsCompCode %>';
            var qsCompNo = '<%=qsCompNo %>';
            var qsGubun = "BU";

            if (isEmpty(qsCompCode) || isEmpty(qsCompNo) || isEmpty(qsGubun)) {
                alert("잘못된 호출 방법입니다. 다시 로그인 후 이용해 주시기 바랍니다.");
                document.location.href = "CompanyManagement.aspx?ucode=" + ucode;
                return false;
            }

            var param = { Flag: 'CompanyMngtInfo_Admin', CompCode: qsCompCode, CompNo: qsCompNo, Gubun: qsGubun };

            var beforeSend = function () { is_sending = true; }
            var complete = function () { is_sending = false; }
            if (is_sending) return false;

            JqueryAjax("Post", "../../Handler/Admin/CompanyHandler.ashx", true, false, param, "json", callback, beforeSend, complete, true, sUser);
        }

        ////////////////////////////////////////////////////////////////////////////////////////////////

        //여신기간에 따라 대금 결제일 월표시
        function fnSetLoanPayMonth(selectDue) {
            var printVal = '';

            switch (selectDue) {
                case "0":
                    printVal = "당월";
                    break;
                case "30":
                    printVal = "익월";
                    break;
                case "60":
                    printVal = "익익월";
                    break;
                case "90":
                    printVal = "익익익월";
                    break;
                case "120":
                    printVal = "익익익익월";
                    break;
                default:
                    printVal = '';
            }

            if ($("#ddlLoanYN").val() != 'Y') {
                printVal = '';
            }

            if (isEmpty(printVal)) $("#spLoanPayMonth").css("margin-right", "0");
            else $("#spLoanPayMonth").css("margin-right", "3px");

            $("#spLoanPayMonth").text(printVal);
        }

        //구매사 주문 유형 값에 따라 설정
        function fnSetBOrderType(param, flag) {

            var BOrdType = $("#<%=ddlBOrdType.ClientID %>").val();
            var arrBOrdTypeNm = '<%=BOrdTypeNames %>';
            $("#lblBOrdTypeName").text(arrBOrdTypeNm.split("^")[parseInt(BOrdType)]);

            var BloanynVal = "";
            var LoanYN = "";

            $("#ddlBloanyn").prop("disabled", true);

            fnSetComTypeDisplay(param, BOrdType); //기능관리 display 설정
            fnSetPaywayDisplay(param, BOrdType); //구매사 결제관리 display 설정

            if (BOrdType == "1") {
                BloanynVal = "N";
                LoanYN = "N";
            } else if (BOrdType == "2") {
                BloanynVal = "N";
                LoanYN = "A";
            } else if (BOrdType == "3") {
                BloanynVal = "N";
                LoanYN = "A";
            } else if (BOrdType == "4") { //첨부파일(사업자등록증) 없는 경우
                BloanynVal = "N";
                LoanYN = "N";
            } else if (BOrdType == "5") {
                BloanynVal = "N";
                LoanYN = "N";
            } else if (BOrdType == "6") {
                BloanynVal = "Y";
                LoanYN = "Y";
                //$("#ddlBloanyn").prop("disabled", false);

            } else if (BOrdType == "7") {
                BloanynVal = "Y";
                LoanYN = "Y";
                //$("#ddlBloanyn").prop("disabled", false);

            } else {
                BloanynVal = "N";
                LoanYN = "N";
            }
            //$("#ddlBloanyn").val(BloanynVal); //대금결제 묶음 여부

            if (param != "LOAD") {
                $("#ddlLoanYN").val(LoanYN); //여신여부
            }

            fnSetCompLoanYn(param, BOrdType); //여신 여부에 따른 설정
        }

        //여신관리 값 초기화
        function fnResetCompLoanYN(param, flag) {

            var ddlLoanYN = $("#ddlLoanYN").val();

            $("#txtLoanPrice").val('');
            $("#txtLoanUsePrice").val('0');
            $("#txtLoanPayUsePrice").val('0');
            $("#ddlAssuranceYN").val("N");
            $("#ddlCollateralYN").val("N");
            $("#ddlLoanPayway").val("1");

            $("#txtLoanMonsPayPrice").val('0');
            $("#txtLoanBillDate").val('');
            $("#txtLoanCalDate").val('');
            $("#ddlLoanCalDue").val('');
            $("#ddlLoanPassYN").val('N');

            $("#txtLoanEndDate").val('');
            $("#txtLoanPayDate").val('');
            $("#spLoanPayMonth").text('');
            $("#spLoanPayMonth").css("margin-right", "0");

            var disabledVal = false;
            if ((flag == "1") || (ddlLoanYN == "N")) {
                disabledVal = true;

                $("#txtLoanPrice").val('');
                $("#txtLoanUsePrice").val('');
                $("#txtLoanPayUsePrice").val('');
                $("#txtLoanMonsPayPrice").val('');
            }

            $("#ddlLoanYN").prop("disabled", disabledVal);
            $("#txtLoanEndDate").prop("disabled", disabledVal);
            $("#txtLoanPayDate").prop("disabled", disabledVal);

            $("#txtLoanPrice").prop("disabled", disabledVal);
            $("#txtLoanUsePrice").prop("disabled", disabledVal);
            $("#txtLoanPayUsePrice").prop("disabled", disabledVal);
            $("#ddlAssuranceYN").prop("disabled", disabledVal);
            $("#ddlCollateralYN").prop("disabled", disabledVal);
            $("#ddlLoanPayway").prop("disabled", disabledVal);

            $("#txtLoanStartDate").prop("disabled", disabledVal);
            $("#txtLoanBillDate").prop("disabled", disabledVal);
            $("#txtLoanCalDate").prop("disabled", disabledVal);
            $("#txtLoanMonsPayPrice").prop("disabled", disabledVal);
            $("#ddlLoanCalDue").prop("disabled", disabledVal);
            $("#ddlLoanPassYN").prop("disabled", disabledVal);


            if (ddlLoanYN == "A") {
                $("#txtLoanEndDate").prop("disabled", true);
                $("#txtLoanPayDate").prop("disabled", true);
            }

            return false;
        }

        //여신 여부에 따른 설정
        function fnSetCompLoanYn(param, flag) {

            var ddlLoanYN = $("#ddlLoanYN").val();

            var disabledVal = false;
            if ((flag == "1") || (ddlLoanYN == "N")) {
                disabledVal = true;

                $("#txtLoanPrice").val('');
                $("#txtLoanUsePrice").val('');
                $("#txtLoanPayUsePrice").val('');
                $("#ddlAssuranceYN").val("N");
                $("#ddlCollateralYN").val("N");
                $("#ddlLoanPayway").val("1");

                $("#txtLoanMonsPayPrice").val('');
                $("#txtLoanBillDate").val('');
                $("#txtLoanCalDate").val('');
                $("#ddlLoanCalDue").val('');
                $("#ddlLoanPassYN").val('N');

                $("#txtLoanEndDate").val('');
                $("#txtLoanPayDate").val('');
                $("#spLoanPayMonth").text('');
                $("#spLoanPayMonth").css("margin-right", "0");

                $("#ddlLoanCalDue").prop("disabled", true);
            }

            $("#ddlLoanYN").prop("disabled", disabledVal);
            $("#txtLoanEndDate").prop("disabled", disabledVal);
            $("#txtLoanPayDate").prop("disabled", disabledVal);

            $("#txtLoanPrice").prop("disabled", disabledVal);
            $("#txtLoanUsePrice").prop("disabled", disabledVal);
            $("#txtLoanPayUsePrice").prop("disabled", disabledVal);
            $("#ddlAssuranceYN").prop("disabled", disabledVal);
            $("#ddlCollateralYN").prop("disabled", disabledVal);
            $("#ddlLoanPayway").prop("disabled", disabledVal);
            $("#ddlLoanCalDue").prop("disabled", disabledVal);
            $("#txtLoanStartDate").prop("disabled", disabledVal);
            $("#txtLoanBillDate").prop("disabled", disabledVal);
            $("#txtLoanCalDate").prop("disabled", disabledVal);
            $("#txtLoanMonsPayPrice").prop("disabled", disabledVal);
            $("#ddlLoanPassYN").prop("disabled", disabledVal);

            if (flag != "1") {
                $("#txtLoanUsePrice").val('0');
                $("#txtLoanPayUsePrice").val('0');
                $("#txtLoanMonsPayPrice").val('0');

                //disabledVal = false;

                $("#ddlLoanYN").prop("disabled", false);

                if (ddlLoanYN == "A") {
                    $("#txtLoanEndDate").prop("disabled", true);
                    $("#txtLoanPayDate").prop("disabled", true);
                    $("#ddlLoanCalDue").prop("disabled", true);
                }
            }

            return false;
        }

        //기능관리 display 설정
        function fnSetComTypeDisplay(param, flag) {

            if (param == "LOAD") {
                return false;
            }

            $("#ddlSaleUrian").attr("disabled", "disabled");
            $("#ddlSaleUrian").val("N");

            $("#ddlBloanyn").val("N");
            $("#ddlBloanyn").prop("disabled", true);

            $("#ddlFreeCompYN").val("N");
            $("#ddlFreeCompYN").prop("disabled", false);

            $("#rdFreeCompVATN").prop("checked", false);
            $("#rdFreeCompVATY").prop("checked", false);
            $("#rdFreeCompVATN").prop("disabled", true);
            $("#rdFreeCompVATY").prop("disabled", true);

            $("#spFreeCompVAT").css("display", "none");

            $("#ddlBtender").val("N");
            $("#ddlBtender").prop("disabled", true);

            if (flag == "1") {

            } else if (flag == "2") {
                $("#ddlFreeCompYN").val("N");
                $("#ddlFreeCompYN").attr("disabled", "disabled");

                $("#rdFreeCompVATN").prop("checked", false);
                $("#rdFreeCompVATY").prop("checked", false);
                $("#rdFreeCompVATN").attr("disabled", "disabled");
                $("#rdFreeCompVATY").attr("disabled", "disabled");

                //$("#ddlBtender").prop("disabled", true);

            } else if (flag == "3") {
                $("#ddlFreeCompYN").val("Y");
                $("#ddlFreeCompYN").prop("disabled", false);

                $("#rdFreeCompVATN").prop("checked", true);
                $("#rdFreeCompVATN").prop("disabled", false);
                $("#rdFreeCompVATY").prop("disabled", false);

                $("#spFreeCompVAT").css("display", "");

                $("#ddlBtender").val("N");
                //$("#ddlBtender").prop("disabled", false);

            } else if (flag == "4") {
                $("#ddlSaleUrian").val("N");
                $("#ddlSaleUrian").prop("disabled", false);
                
            } else if (flag == "5") {
                $("#ddlSaleUrian").val("N");
                $("#ddlSaleUrian").prop("disabled", false);

            } else if (flag == "6") {
                $("#ddlSaleUrian").val("N");
                $("#ddlSaleUrian").prop("disabled", false);

                $("#ddlBloanyn").val("Y");
                $("#ddlBloanyn").prop("disabled", true);

            } else if (flag == "7") {
                $("#ddlSaleUrian").val("N");
                $("#ddlSaleUrian").prop("disabled", false);

                $("#ddlBloanyn").val("Y");
                $("#ddlBloanyn").prop("disabled", true);
            }

            return false;
        }

        //구매사 결제관리 display 설정
        function fnSetPaywayDisplay(param, flag) {

            $("#ckbBPayway_1").prop("checked", false);
            $("#ckbBPayway_2").prop("checked", false);
            $("#ckbBPayway_3").prop("checked", false);
            $("#ckbBPayway_4").prop("checked", false);
            $("#ckbBPayway_5").prop("checked", false);
            $("#ckbBPayway_6").prop("checked", false);
            $("#ckbBPayway_7").prop("checked", false);
            $("#ckbBPayway_8").prop("checked", false);
            $("#ckbBPayway_9").prop("checked", false);
            $("#ckbBPayway_10").prop("checked", false);

            $("#ckbBPayway_1").prop("disabled", true);
            $("#ckbBPayway_2").prop("disabled", true);
            $("#ckbBPayway_3").prop("disabled", true);
            $("#ckbBPayway_4").prop("disabled", true);
            $("#ckbBPayway_5").prop("disabled", true);
            $("#ckbBPayway_6").prop("disabled", true);
            $("#ckbBPayway_7").prop("disabled", true);
            $("#ckbBPayway_8").prop("disabled", true);
            $("#ckbBPayway_9").prop("disabled", true);
            $("#ckbBPayway_10").prop("disabled", true);

            if (flag == "1") {
                if (param == "LOAD") {
                    fnSetBPayType($("#hdPayway").val());

                } else {
                    $("#ckbBPayway_1").prop("checked", true);
                    $("#ckbBPayway_2").prop("checked", true);
                    $("#ckbBPayway_3").prop("checked", true);
                    $("#ckbBPayway_5").prop("checked", true);
                }

                $("#ckbBPayway_1").prop("disabled", false);
                $("#ckbBPayway_2").prop("disabled", false);
                $("#ckbBPayway_3").prop("disabled", false);
                $("#ckbBPayway_5").prop("disabled", false);

            } else if ((flag == "2") || flag == "3") {
                if (param == "LOAD") {
                    fnSetBPayType($("#hdPayway").val());

                } else {
                    $("#ckbBPayway_1").prop("checked", true);
                    $("#ckbBPayway_2").prop("checked", true);
                    $("#ckbBPayway_5").prop("checked", true);
                    $("#ckbBPayway_9").prop("checked", true);
                }

                $("#ckbBPayway_1").prop("disabled", false);
                $("#ckbBPayway_2").prop("disabled", false);
                $("#ckbBPayway_5").prop("disabled", false);
                $("#ckbBPayway_9").prop("disabled", false);

            } else if (flag == "4") {
                if (param == "LOAD") {
                    fnSetBPayType($("#hdPayway").val());

                } else {
                    $("#ckbBPayway_1").prop("checked", true);
                    $("#ckbBPayway_2").prop("checked", true);
                    $("#ckbBPayway_3").prop("checked", true);
                    $("#ckbBPayway_5").prop("checked", true);
                    $("#ckbBPayway_9").prop("checked", false);
                }

                $("#ckbBPayway_1").prop("disabled", false);
                $("#ckbBPayway_2").prop("disabled", false);
                $("#ckbBPayway_3").prop("disabled", false);
                $("#ckbBPayway_5").prop("disabled", false);
                $("#ckbBPayway_9").prop("disabled", false);

            } else if (flag == "5") {
                if (param == "LOAD") {
                    fnSetBPayType($("#hdPayway").val());

                } else {
                    $("#ckbBPayway_1").prop("checked", true);
                    $("#ckbBPayway_2").prop("checked", true);
                    $("#ckbBPayway_3").prop("checked", false);
                    $("#ckbBPayway_5").prop("checked", true);
                    $("#ckbBPayway_9").prop("checked", true);
                    $("#ckbBPayway_10").prop("checked", true);
                }

                $("#ckbBPayway_1").prop("disabled", false);
                $("#ckbBPayway_2").prop("disabled", false);
                $("#ckbBPayway_3").prop("disabled", false);
                $("#ckbBPayway_5").prop("disabled", false);
                $("#ckbBPayway_9").prop("disabled", false);
                $("#ckbBPayway_10").prop("disabled", false);

            } else if ((flag == "6") || (flag == "7")) {
                if (param == "LOAD") {
                    fnSetBPayType($("#hdPayway").val());

                } else {
                    $("#ckbBPayway_6").prop("checked", true);
                }

                $("#ckbBPayway_6").prop("disabled", false);
                $("#ckbBPayway_8").prop("disabled", false);
            }

            return false;
        }

        //구매사 결제 방식 설정(저장된 값)
        function fnSetBPayType(payType) {
            if (!isEmpty(payType)) {
                var posArr = new Array();
                var pos = payType.indexOf("1");

                while (pos > -1) {
                    posArr.push(pos);
                    pos = payType.indexOf("1", pos + 1);
                }

                for (var i = 0; i < posArr.length; i++) {
                    $("#ckbBPayway_" + posArr[i]).prop("checked", true);
                }
            }

            return false;
        }

        ////////////////////////////////////////////////////////////////////////////////////////////////

        //여신 제출서류 항목 조회
        function fnGetComm(code, channel) {
            var callback = function (response) {

                var createHtml = null;
                var channelNum = null;

                if (!isEmpty(response)) {

                    fnLoanDocList("COMPANY", "2", response.comm_1); //제출서류 영역 출력

                    var loanPayway = $("#hdLoanPayway").val();

                    $.each(response, function (key, value) {

                        if (key == "comm_0") {
                            channelNum = channel.split(',')[0];

                            for (var i = 1; i < value.length; i++) {

                                var selectFlag = "";

                                if (!isEmpty(loanPayway) && (loanPayway == value[i].Map_Type)) {
                                    selectFlag = " selected='selected'";
                                }

                                createHtml = '<option value="' + value[i].Map_Type + '"' + selectFlag + '>' + value[i].Map_Name + '</option>';
                                $('#ddlLoanPayway').append(createHtml);
                            }
                        }

                    });

                } else {
                    alert("오류가 발생했습니다. 잠시 후 다시 시도해 주세요.");
                }

                return false;
            }

            var sUser = '<%=Svid_User%>';
            var param = { Method: 'GetCommMultiList', Code: code, Channel: channel };

            var beforeSend = function () { };
            var complete = function () { };
            JqueryAjax("Post", "../../Handler/Common/CommHandler.ashx", true, false, param, "json", callback, beforeSend, complete, true, sUser);
        }

        //제출서류 영역 출력
        function fnSetLoanDocView(commObj, docObj) {

            $("#tbodyLoanDoc").empty();

            for (var i = 1; i < commObj.length; i++) {

                var mapCode = commObj[i].Map_Code;
                var mapCh = commObj[i].Map_Channel;
                var mapType = commObj[i].Map_Type;
                var mapName = commObj[i].Map_Name;

                var addTag = "<tr>";
                addTag += "<th>" + mapName;
                addTag += "<input type='hidden' id='hdLoanDocMapCode_" + mapType + "' value= '" + mapCode + "' />";
                addTag += "<input type='hidden' id='hdLoanDocMapCh_" + mapType + "' value= '" + mapCh + "' />";
                addTag += "<input type='hidden' id='hdLoanDocMapType_" + mapType + "' value= '" + mapType + "' />";
                addTag += "</th>";

                var addFileTag = "";

                if (!isEmpty(docObj)) {
                    for (var x = 0; x < docObj.length; x++) {
                        var docMapCode = docObj[x].Map_Code;
                        var docCommCh = docObj[x].Comm_Chanel;
                        var docCommType = docObj[x].Comm_Type;
                        var docFilePath = docObj[x].Attach_Path;
                        var docFileName = docObj[x].Attach_P_Name;
                        var docSvidLoanDoc = docObj[x].Svid_GoodsLoanDoc;

                        if ((mapCode == docMapCode) && (mapCh == docCommCh) && (mapType == docCommType)) {
                            addFileTag += "<td colspan='2'>";
                            addFileTag += "<input type='hidden' id='hdLoanDocPath_" + mapType + "' value= '" + docFilePath + "' />";
                            addFileTag += "<input type='hidden' id='hdLoanDocName_" + mapType + "' value= '" + docFileName + "' />";
                            addFileTag += "<input type='hidden' id='hdLoanDocSvid_" + mapType + "' value= '" + docSvidLoanDoc + "' />";
                            addFileTag += "<a onclick= 'fnFileDownload(this); return false;' style='cursor: pointer; text-decoration:none; color:blue;' > " + docFileName + "</a ></td > ";
                        }
                    }
                }

                if (isEmpty(addFileTag)) {
                    addFileTag += "<td colspan='3'><input type='file' id='fileUpload_" + mapType + "' style='width: 700px' onkeypress='preventEnter(event);' /></td>";
                } else {
                    addFileTag += "<td style='width:50px;'><a onclick='return fnDeleteLoanDoc(this);'><img src='' alt='삭제'/></a></td>";
                }

                addTag += addFileTag;

                addTag += "</tr>";

                $("#tbodyLoanDoc").append(addTag);
            }
        }

        //등록한 여신문서 삭제
        function fnDeleteLoanDoc(el) {

            var confirmVal = confirm("정말로 파일을 삭제하시겠습니까?");

            if (confirmVal) {
                var hdDocSvidLoan = $(el).parent().parent().find("input:hidden[id^='hdLoanDocSvid_']").val();
                var hdFilePath = $(el).parent().parent().find("input:hidden[id^='hdLoanDocPath_']").val();
                var hdFileName = $(el).parent().parent().find("input:hidden[id^='hdLoanDocName_']").val();

                if (isEmpty(hdDocSvidLoan) || isEmpty(hdFilePath) || isEmpty(hdFileName)) {
                    alert("삭제할 파일 정보가 부족합니다. 브라우저창을 닫고 다시 시도해 주세요.");
                    return false;
                }

                var callback = function (response) {

                    if (!isEmpty(response)) {
                        fnLoanDocList("COMPANY", "2", response); //제출서류 영역 출력

                        alert("선택하신 파일이 삭제되었습니다.");

                    } else {
                        alert("오류가 발생했습니다. 잠시 후 다시 시도해 주세요.");
                    }

                    return false;
                }

                var sUser = '<%=Svid_User%>';
                var param = { Flag: 'DelLoanDoc', SvidLoanDoc: hdDocSvidLoan, FilePath: hdFilePath, FileName: hdFileName, Code: 'COMPANY', Channel: '2' };

                var beforeSend = function () { is_sending = true; }
                var complete = function () { is_sending = false; }
                if (is_sending) return false;

                JqueryAjax("Post", "../../Handler/Admin/CompanyHandler.ashx", true, false, param, "json", callback, beforeSend, complete, true, sUser);
            }

            return false;
        }

        //등록한 여신문서 조회
        function fnLoanDocList(mapCode, compChanel, commObj) {

            var callback = function (response) {

                fnSetLoanDocView(commObj, response);

                return false;
            }

            var compCode = $("#hdCompCode").val();
            var param = { Flag: 'GetLoanDocList', CompCode: compCode, MapCode: mapCode, CompChanel: compChanel };

            JajaxSessionCheck('Post', '../../Handler/Admin/CompanyHandler.ashx', param, 'json', callback, '<%=Svid_User%>');
        }

        //등록된 여신문서 클릭 시
        function fnFileDownload(el) {

            var hdFilePath = $(el).parent().find("input:hidden[id^='hdLoanDocPath_']").val();
            var hdFileName = $(el).parent().find("input:hidden[id^='hdLoanDocName_']").val();

            window.location = "/Order/FileDownload.aspx?FilePath=" + hdFilePath + "&FileName=" + hdFileName;

            return false;
        }

        //[팝업]소셜위드 관리 담당자 조회
        function fnAdmUserIdSearch(pageNo) {
            var searchKeyword = $("#txtPopSearch2").val();
            var searchTarget = $("#ddlPopSearch2").val();
            var pageSize = 10;
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

            var sUser = '<%= Svid_User%>';
            var param = { Method: 'GetUserSearchList', Type: 'AU', SearchTarget: searchTarget, SearchKeyword: searchKeyword, PageNo: pageNo, PageSize: pageSize };

            var beforeSend = function () { }
            var complete = function () { }

            JqueryAjax("Post", "../../Handler/Common/UserHandler.ashx", true, false, param, "json", callback, beforeSend, complete, true, sUser);

        }
        function getPageData2() {
            var container = $('#pagination2');
            var getPageNum = container.pagination('getSelectedPageNum');
            fnAdmUserIdSearch(getPageNum);
            return false;
        }

        //팝업에서 Enter event
        function fnPopupSearchTxtEnter(flag) {
            if (event.keyCode == 13) {
                if (flag == "ADM") {
                    fnAdmUserIdSearch(1); //소셜위드 관리 담당자 ID 조회
                } else if (flag == "GRP") {
                    fnGroupIdSearch(1); //그룹G아이디 조회
                }

                return false;
            }
            else
                return true;
        }

        //팝업 : 소셜위드 관리 담당자 아이디
        function fnSearchAdmUserIdPopup() {

            fnAdmUserIdSearch(1);

            fnOpenDivLayerPopup('admUserIdSearchDiv');

            return false;
        }

        //팝업 : 소셜위드 관리 담당자 아이디 - 확인 버튼
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

        //[팝업]그룹 판매사 아이디 조회
        function fnGroupIdSearch(pageNo) {
            var searchKeyword = $("#txtSearch").val();
            var searchTarget = $("#ddlPopSearch").val();
            var pageSize = 10;
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

            var sUser = '<%= Svid_User%>';
            var param = { Method: 'GetUserSearchList', Type: 'A', SearchTarget: searchTarget, SearchKeyword: searchKeyword, PageNo: pageNo, PageSize: pageSize };

            var beforeSend = function () { }
            var complete = function () { }

            JqueryAjax("Post", "../../Handler/Common/UserHandler.ashx", true, false, param, "json", callback, beforeSend, complete, true, sUser);

        }
        //페이징 인덱스 클릭시 데이터 바인딩
        function getPageData() {
            var container = $('#pagination');
            var getPageNum = container.pagination('getSelectedPageNum');
            fnGroupIdSearchPopup(getPageNum);
            return false;
        }

        //그룹 판매사 아이디 팝업
        function fnGroupIdSearchPopup() {

            fnGroupIdSearch(1);
            var e = document.getElementById('CodeSearchDiv');

            if (e.style.display == 'block') {
                e.style.display = 'none';

            } else {
                e.style.display = 'block';
            }
            return false;
        }



        //구매사 결제방식 값 조합
        function fnGetBPayType() {
            var result = "P";

            $("#tbodyBPayType input:checkbox[id^='ckbBPayway_']").each(function () {

                if ($(this).is(":checked")) {
                    result += "1";
                } else {
                    result += "0";
                }
            });

            return result;
        }

        //유효성 검사
        function fnValidation() {

            var txtConStartDate = $("#txtConStartDate").val();
            var txtConEndDate = $("#txtConEndDate").val();
            var txtAdmUserId = $("#txtAdmUserId").val();
            var txtDelegateName = $.trim($("#txtDelegateName").val());
            var ddlBOrdType = $("#<%=ddlBOrdType.ClientID %>").val();

            if (isEmpty(txtConStartDate)) {
                alert("계약 시작일을 선택해 주세요.");
                $("#txtConStartDate").focus();
                return false;
            }
            if (isEmpty(txtConEndDate)) {
                alert('계약만료일을 입력해 주세요');
                $("#txtConEndDate").focus();
                return false;
            }
            if (isEmpty(txtDelegateName)) {
                alert("대표자명을 입력해 주세요.");
                return false;
            }
            if (isEmpty(ddlBOrdType)) {
                alert("구매사 주문 유형을 선택해 주세요.");
                return false;
            }


            if (isEmpty($("#<%=ddlBTypeRole.ClientID %>").val())) {
                alert('구매사 결제 선택 유형을 선택해 주세요');
                return false;
            }

            var BPayType = fnGetBPayType(); //구매사 결제방식

            if (BPayType.indexOf('1') < 0) {
                alert("구매사 결제관리에서 결제수단을 선택해 주세요.");
                return false;
            }

            //자사체크 시
            if (!isEmpty($("#ddlSaleUrian").val()) && ($("#ddlSaleUrian").val() != "N")) {
                if (isEmpty($("#txtAdmUserId").val())) {
                    alert("소셜위드 관리 담당자 ID 를 선택해 주세요.");
                    return false;
                }
            }

            //여신관리 부분
            if (!isEmpty($("#ddlLoanYN").val()) && $("#ddlLoanYN").val() != "N") {

                if ($("#ddlLoanYN").val() == "Y") {

                    //여신마감일
                    var numEndDate = 0;
                    var endDateMsg = "여신 마감일을 \"01~31\" 사이의 값으로 입력해 주세요.";
                    if (isEmpty($("#txtLoanEndDate").val()) || ($("#txtLoanEndDate").val().length < 2)) {
                        alert(endDateMsg);
                        return false;

                    } else {
                        numEndDate = Number($("#txtLoanEndDate").val());
                        if ((numEndDate <= 0) || (numEndDate > 31)) {
                            alert(endDateMsg);
                            return false;
                        }
                    }

                    //대금결제일
                    var numPayDate = 0;
                    var payDateMsg = "대금 결제일을 \"01~31\" 사이의 값으로 입력해 주세요.";
                    if (isEmpty($("#txtLoanPayDate").val()) || ($("#txtLoanPayDate").val().length < 2)) {
                        alert(payDateMsg);
                        return false;

                    } else {
                        numPayDate = Number($("#txtLoanPayDate").val());
                        if ((numPayDate <= 0) || (numPayDate > 31)) {
                            alert(payDateMsg);
                            return false;
                        }

                        if (($("#ddlLoanCalDue").val() == "0") && (numPayDate < numEndDate)) {
                            alert("여신기간이 당월인 경우 대금 결제일은 여신 마감일보다 이후 일자여야 합니다. 다시 입력해 주세요.");
                            return false;
                        }
                    }

                    //여신기간
                    if (isEmpty($("#ddlLoanCalDue").val())) {
                        alert("여신기간을 선택해 주세요.");
                        return false;
                    }
                }

                //여신한도금액
                if (isEmpty($("#txtLoanPrice").val())) {
                    alert("여신 한도 금액을 입력해 주세요.");
                    return false;
                }

                //여신사용금액
                if (isEmpty($("#txtLoanUsePrice").val())) {
                    alert("여신 사용 금액을 입력해 주세요.");
                    return false;
                }

                //월마감 미수금액
                if (isEmpty($("#txtLoanMonsPayPrice").val())) {
                    alert("월마감 미수 금액을 입력해 주세요.");
                    return false;
                }

                //대금납입금액
                if (isEmpty($("#txtLoanPayUsePrice").val())) {
                    alert("대금 납입 금액을 입력해 주세요.");
                    return false;
                }

                //거래일자
                if (isEmpty($("#txtLoanStartDate").val())) {
                    alert("거래일자를 입력해 주세요.");
                    return false;
                }

                //대금결제방법
                if (isEmpty($("#ddlLoanPayway").val())) {
                    alert("대금 결제방법을 선택해 주세요.");
                    return false;
                }

                //세금계산서 발행일자 출력일
                var billDateMsg = "세금계산서 발행일자 출력일을 \"01~31\" 사이의 값으로 입력해 주세요.";
                if (!isEmpty($("#txtLoanBillDate").val())) {
                    if ($("#txtLoanBillDate").val().length < 2) {
                        alert(billDateMsg);
                        return false;
                    }

                    var numDate = Number($("#txtLoanBillDate").val());
                    if ((numDate <= 0) || (numDate > 31)) {
                        alert(billDateMsg);
                        return false;
                    }
                }

                //여신계산일자
                if (isEmpty($("#txtLoanCalDate").val())) {
                    alert("여신 계산일자를 입력해 주세요.");
                    return false;
                }

                //보증여부
                if (isEmpty($("#ddlAssuranceYN").val())) {
                    alert("보증여부를 선택해 주세요.");
                    return false;
                }

                //담보여부
                if (isEmpty($("#ddlCollateralYN").val())) {
                    alert("담보여부를 선택해 주세요.");
                    return false;
                }
            }

            if (isEmpty($("#txtAdmUserId").val())) {
                alert("소셜위드 관리 담당자 ID를 입력해 주세요.");
                return false;
            }

            var confirmVal = confirm("정말로 저장하시겠습니까?");
            if (!confirmVal) {
                return false;
            }

            return true;
        }


        // 적용 버튼 클릭 시
        function fnSaveComInfo() {
            if (!fnValidation()) {
                return false;
            }

            var compCode = $("#hdCompCode").val();
            var compNo = $("#hdCompNo").val();
            var gubun = $("#hdGubun").val();
            var compName = $("#hdCompName").val();
            var delFlag = $("#ddlDelFlag").val();
            var BTypeRole = $("#<%=ddlBTypeRole.ClientID %>").val();
            var BPCompareYN = $("#ddlBPCompareYN").val(); //가격비교사용유무

            var BOrdType = $("#<%=ddlBOrdType.ClientID %>").val(); //구매사 주문 유형
            var Bloanyn = $("#ddlBloanyn").val(); //구매사 대금 결제 묶음 유무
            var saleUrian = $("#ddlSaleUrian").val(); //구매사 자사 체크
            var btender = $("#ddlBtender").val(); //구매사 입찰유무
            var BPayType = fnGetBPayType(); //구매사 결제방식

            //여신관련
            var compLoanYN = $("#ddlLoanYN").val();
            var loanPrice = $("#txtLoanPrice").val().replace(/[^0-9 | ^.]/g, '');
            var loanUsePrice = $("#txtLoanUsePrice").val().replace(/[^0-9 | ^.]/g, '');
            var loanMonsPayPrice = $("#txtLoanMonsPayPrice").val().replace(/[^0-9 | ^.]/g, '');
            var loanPayUsePrice = $("#txtLoanPayUsePrice").val().replace(/[^0-9 | ^.]/g, '');
            var loanEndDate = $("#txtLoanEndDate").val();
            var loanPayDate = $("#txtLoanPayDate").val();
            var loanBillDate = $("#txtLoanBillDate").val();
            var loanCalDate = $("#txtLoanCalDate").val().replace(/\-/g, '');
            var loanCalDue = $.trim($("#ddlLoanCalDue").val());
            var loanStartDate = $("#txtLoanStartDate").val();
            var loanPassYN = $("#ddlLoanPassYN").val();
            var assuranceYN = $("#ddlAssuranceYN").val();
            var collateralYN = $("#ddlCollateralYN").val();
            var loanPayway = $("#ddlLoanPayway").val();
            var gdsLoanDelFlag = "";

            var adminUserId = $("#txtAdmUserId").val(); //소셜위드 관리 담당자 ID
            var delegateName = $("#txtDelegateName").val(); //대표자명
            var freeCompYN = $("#ddlFreeCompYN").val(); //민간 업체 유무
            var freeCompVATYN = 'Y'; //민간 업체 부가세 포함 유무
            var BOrderSelectWeek = $("#ddlBOrderSelectWeek").val(); //구매사 주문선택 주기

            //민간업체사용일 경우만
            if (freeCompYN == "Y") {
                $("input:radio[name='rdFreeCompVATYN']").each(function () {
                    if (this.checked) {
                        freeCompVATYN = this.value;
                    }
                });
            }

            var txtConStartDate = $("#txtConStartDate").val();
            var txtConEndDate = $("#txtConEndDate").val();
            var comRemark = $("#txtComRemark").val(); //비고

            //여신사용 아닌 경우 정보 초기화
            if (isEmpty(compLoanYN) || (compLoanYN == "N")) {
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
            }

            var callback = function (response) {
                if (response == 'OK') {
                    fnGetFiles();
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
                , ATypeRole: ''
                , BPayType: BPayType
                , BillCheck: 'N'
                , BillUserNm: ''
                , BillTel: ''
                , BillFax: ''
                , BillEmail: ''
                , Uptae: ''
                , Upjong: ''
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
                , GroupSaleCompId: ''
                , StartDate: txtConStartDate
                , EndDate: txtConEndDate
                , BOrdType: BOrdType
                , SaleUrian: saleUrian
                , GroupChk: ''
                , ATypeUrl: ''
                , AdminUserId: adminUserId
                , DelegateName: delegateName
                , ABillType: ''
                , BDsCode: ''
                , BTender: btender
                , FreeCompYN: freeCompYN
                , FreeCompVATYN: freeCompVATYN
                , Remark: comRemark
                , AutoConfirmYn: 'Y'
                , BOrderSelectWeek: BOrderSelectWeek
                , BPCompareYN: BPCompareYN
            };

            var sUser = '<%=Svid_User %>';
            var beforeSend = function () { is_sending = true; }
            var complete = function () { is_sending = false; }
            if (is_sending) return false;

            JqueryAjax("Post", "../../Handler/Admin/CompanyHandler.ashx", true, false, param, "text", callback, beforeSend, complete, true, sUser);
        }

        //파일 정보를 얻음
        function fnGetFiles() {
            var getFiles = $("#tbodyLoanDoc").find("input[id^='fileUpload_']");
            var docNo = 0;

            for (var i = 0; i < getFiles.length; i++) {
                var fileObj = getFiles[i].files;
                var trTag = $(getFiles[i]).parent().parent();

                for (var x = 0; x < fileObj.length; x++) {
                    var file = fileObj[x];

                    if ('name' in file) {
                        ++docNo;
                        fnFileUpload(file, trTag, docNo);
                    }
                }
            }

            fnSetPageLoad(); //화면 설정
        }

        //파일 업로드
        function fnFileUpload(files, objTag, docNo) {
            var data = new FormData();
            var compCode = $("#hdCompCode").val();
            var gubun = $("#hdGubun").val();

            var commCode = $(objTag).find("input[id^='hdLoanDocMapCode_']").val();
            var commCh = $(objTag).find("input[id^='hdLoanDocMapCh_']").val();
            var commType = $(objTag).find("input[id^='hdLoanDocMapType_']").val();

            data.append("UploadFile", files);
            data.append("CompCode", compCode);
            data.append("Type", 'Company');
            data.append("Gubun", gubun);
            data.append("CommType", commType);
            data.append("CommChanel", commCh);
            data.append("MapCode", commCode);
            data.append("DocNo", docNo);
            data.append("Method", 'LoanDocFileUpload');

            // Make Ajax request with the contentType = false, and procesDate = false
            var ajaxRequest = $.ajax({
                type: "POST",
                url: '../../Handler/FileUploadHandler.ashx',
                async: false,
                contentType: false,
                processData: false,
                data: data
            });

            ajaxRequest.done(function (xhr, textStatus) {


            });

            return false;
        }

        //1년후 날짜 세팅
        function fnSetDate() {
            var date = $("#txtConStartDate").val();
            var y = parseInt(date.split('-')[0]) + 1;
            var m = date.split('-')[1];
            var d = date.split('-')[2];
            $("#txtConEndDate").val(y + "-" + m + "-" + d);
        }

        //여신결제(3개) 중 1개만 선택
        function fnCheckLoanPayway(el) {
            var checked = $(el).prop("checked");
            if (checked) {
                $("input:checkbox[name='ckbLoanPayway']").prop("checked", false);
                $(el).prop("checked", true);
            }
        }

        //가상계좌(유동/고정) 중 1개만 선택
        function fnCheckVirtualPayway(el) {
            if (el.id == "ckbBPayway_3") {
                $("#ckbBPayway_3").prop("checked", $(el).prop(":checked"));
                $("#ckbBPayway_9").prop("checked", false);

            } else if (el.id == "ckbBPayway_9") {
                $("#ckbBPayway_3").prop("checked", false);
                $("#ckbBPayway_9").prop("checked", $(el).prop(":checked"));
            }
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

            <div class="sub-mini-title">
                <p>회사관리</p>
            </div>

            <table class="tbl_main" id="tblCompManagement">
                <colgroup>
                    <col />
                    <col style="width: 32%" />
                    <col />
                    <col style="width: 28%" />
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
                            <input type="hidden" id="hdBTypeRole" />
                            <input type="hidden" id="hdDelFlag" />
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
                        <th>구매사 주문선택 주기</th>
                        <td>
                            <select id="ddlBOrderSelectWeek" class="small-size">
                                <option value="1">1주</option>
                                <option value="2">2주</option>
                                <option value="3">3주</option>
                                <option value="4">4주</option>
                            </select>
                        </td>
                    </tr>
                    <tr>
                        <th>거래 현황</th>
                        <td>
                            <select id="ddlDelFlag" class="small-size">
                                <option value="N">거래중</option>
                                <option value="Y">거래중지</option>
                            </select>
                        </td>
                        <th>구매사 결제 선택 유형</th>
                        <td>
                            <asp:DropDownList runat="server" ID="ddlBTypeRole" CssClass="small-size"></asp:DropDownList>
                        </td>
                    </tr>
                    <tr>
                        <th>계약 시작일</th>
                        <td>
                            <%--<asp:TextBox ID="txtConStartDate" runat="server" CssClass="calendar" ReadOnly="true" Height="24px" onkeypress="return fnEnter()" onchange="return fnSetDate()"></asp:TextBox>--%>
                            <input type="date" id="txtConStartDate" class="calendar" readonly="readonly" onchange="return fnSetDate();" />
                        </td>
                        <th>계약 만료일</th>
                        <td>
                            <%--<asp:TextBox ID="txtConEndDate" runat="server" CssClass="calendar" ReadOnly="true" Height="24px" onkeypress="return fnEnter()"></asp:TextBox>--%>
                            <input type="date" id="txtConEndDate" class="calendar" readonly="readonly" />
                        </td>
                    </tr>
                    <tr id="trAdmUserId">
                        <th>소셜위드 관리 담당자 ID</th>
                        <td style="width: 26%">
                            <input class="txtCompManagement" id="txtAdmUserId" onkeypress="return fnEnter()" type="text" readonly="readonly" style="width:75%">
                            <input type="button" class="mainbtn type1" value="검 색" style="width: 75px;" onclick="return fnSearchAdmUserIdPopup();" />
                        </td>
                        <th>소셜위드 관리 담당자명</th>
                        <td><span id="spAdmUserNm"></span></td>
                    </tr>
                    <tr id="trDelegateName">
                        <th>대표자명</th>
                        <td>
                            <input type="text" id="txtDelegateName" class="txtCompManagement" style="width: 300px;" />
                        </td>
                        <th>가격비교사용유무</th>
                        <td>
                            <select id="ddlBPCompareYN" class="small-size">
                                <option value="N">아니오</option>
                                <option value="Y">예</option>
                                <option value="U">유저관리</option>
                            </select>
                        </td>
                    </tr>
                    <tr>
                        <th>구매사 사업자등록증 첨부 유무</th>
                        <td>
                            <input type="hidden" id="hdImgYN" />
                            <span id="spImgYN"></span>
                        </td>
                        <th>비고</th>
                        <td>
                            <input type="text" id="txtComRemark" class="txtCompManagement" style="width: 300px;" />
                        </td>
                    </tr>
                </tbody>
            </table>
            <div class="sub-mini-title">
                <p>기능관리</p>
            </div>
            <table class="tbl_main" id="tblCompTypeManagement">
                <colgroup>
                    <col />
                    <col style="width: 32%" />
                    <col />
                    <col style="width: 28%" />
                </colgroup>
                <thead>
                </thead>
                <tbody>
                    <tr id="trBOrdType">
                        <th>구매사 주문 유형</th>
                        <td>
                            <asp:DropDownList runat="server" ID="ddlBOrdType" CssClass="small-size"></asp:DropDownList>
                            <label id="lblBOrdTypeName" style="padding-left: 5px; font-weight: normal;"></label>
                        </td>
                        <th>구매사 대금 결제 묶음 유무<br />
                            (=PO별 묶음 결제 유무)</th>
                        <td>
                            <select id="ddlBloanyn" class="small-size">
                                <option value="N" selected="selected">아니오</option>
                                <option value="Y">예</option>
                            </select>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="4" style="color: red; font-size: 20px; font-weight: bold; background-color: #ececec; text-align: center">※ 필수항목 체크(아래)</td>
                    </tr>
                    <tr>
                        <th>민간 업체 유무</th>
                        <td id="tdFreeCompYN">
                            <select id="ddlFreeCompYN" class="small-size">
                                <option value="N">아니오</option>
                                <option value="Y">예</option>
                            </select>
                            <span id="spFreeCompVAT" style="margin-left: 10px;">
                                <input type="radio" name="rdFreeCompVATYN" id="rdFreeCompVATN" value="N" />
                                <label for="rdFreeCompVATN">부가세 별도</label>
                                &nbsp;&nbsp;
                            <input type="radio" name="rdFreeCompVATYN" id="rdFreeCompVATY" value="Y" />
                                <label for="rdFreeCompVATY">부가세 포함</label>
                            </span>
                        </td>
                        <th>입찰 유무<br />
                            <label class="lbl-tip-th">※민간 업체 유무 선택 시 입력가능합니다.</label>
                        </th>
                        <td>
                            <select id="ddlBtender" class="small-size">
                                <option value="N" selected="selected">아니오</option>
                                <option value="Y">예</option>
                            </select>
                        </td>
                    </tr>
                    <tr>
                        <th>자사 체크<br />
                            (판매사 = 소셜위드)</th>
                        <td>
                            <input type="hidden" id="sameComNoYN" />
                            <select id="ddlSaleUrian" class="large-size">
                                <option value="N" selected="selected">아니오 = 기본 유형</option>
                                <option value="Y">소셜위드 = 구매사 가격</option>
                                <option value="A">판매사 직접 구매 = 판매사 + 셋팅 가격</option>
                            </select>
                        </td>
                        <th></th>
                        <td></td>
                    </tr>
                </tbody>
            </table>
            <div id="divLoanManagement">
                <div class="sub-mini-title">
                    <p>여신관리</p>
                </div>

                <table class="tbl_main" id="tblCompLoanManagement">
                    <thead>
                    </thead>
                    <tbody id="tbodyLoan">
                        <tr>
                            <th>여신 여부
                            <input type="hidden" id="hdCompLoanYN" />
                                <%--
                            <input type="hidden" id="hdAssuranceYN" />
                            <input type="hidden" id="hdCollateralYN" />--%>
                                <input type="hidden" id="hdLoanPayway" />
                            </th>
                            <td>
                                <select class="small-size" id="ddlLoanYN">
                                    <option value="N">아니오</option>
                                    <option value="A">예(관공서)</option>
                                    <option value="Y">예</option>
                                </select>
                            </td>
                            <th>여신 마감일</th>
                            <td>
                                <input type="text" id="txtLoanEndDate" class="txtCompManagement" style="width: 50px;" onkeypress="return onlyNumbers(event);" maxlength="2" />
                                &nbsp;(일자 2자리:01~31)
                            </td>
                        </tr>

                        <tr>
                            <th>여신 한도 금액</th>
                            <td>
                                <input type="text" class="txtCompManagement" id="txtLoanPrice" onchange="return RealTimeComma('txtLoanPrice');" onkeyup="return RealTimeComma('txtLoanPrice');" onkeypress="return onlyNumbers(event);" />
                            </td>
                            <th>대금 결제일</th>
                            <td>
                                <span id="spLoanPayMonth">당월</span>
                                <input type="text" id="txtLoanPayDate" class="txtCompManagement" style="width: 50px;" onkeypress="return onlyNumbers(event);" maxlength="2" />
                                &nbsp;(일자 2자리:01~31)
                            </td>
                        </tr>

                        <tr>
                            <th>여신 사용 금액</th>
                            <td>
                                <input type="text" class="txtCompManagement" id="txtLoanUsePrice" onchange="return RealTimeComma('txtLoanUsePrice');" onkeyup="return  RealTimeComma('txtLoanUsePrice');" onkeypress="return onlyNumbers(event);" />
                            </td>
                            <th>세금계산서 발행일자 출력일</th>
                            <td>
                                <input type="text" class="txtCompManagement" style="width: 50px;" onkeypress="return onlyNumbers(event);" maxlength="2" id="txtLoanBillDate" />
                                &nbsp;(일자 2자리:01~31)
                            </td>
                        </tr>
                        <tr>
                            <th>월마감 미수 금액</th>
                            <td>
                                <input type="text" class="txtCompManagement" id="txtLoanMonsPayPrice" onchange="return RealTimeComma('txtLoanMonsPayPrice');" onkeyup="return RealTimeComma('txtLoanMonsPayPrice');" onkeypress="return onlyNumbers(event);" />
                            </td>
                            <th>여신 계산일자</th>
                            <td>
                                <%--<input type="text" class="txtCompManagement" id="txtLoanCalDate" readonly="readonly" style="margin-right: 5px;" />--%>
                                <input type="date" id="txtLoanCalDate" class="calendar" readonly="readonly" onchange="return fnSetDate();" />
                            </td>
                        </tr>
                        <tr>
                            <th>대금 납입 금액</th>
                            <td>
                                <input type="text" class="txtCompManagement" id="txtLoanPayUsePrice" onchange="return RealTimeComma('txtLoanPayUsePrice');" onkeyup="return RealTimeComma('txtLoanPayUsePrice');" onkeypress="return onlyNumbers(event);" />
                            </td>
                            <th>여신기간</th>
                            <td>
                                <select id="ddlLoanCalDue" class="small-size">
                                    <option value="0">0</option>
                                    <option value="30">30</option>
                                    <option value="60">60</option>
                                    <option value="90">90</option>
                                    <option value="120">120</option>
                                </select>
                                일
                            </td>
                        </tr>
                        <tr>
                            <th>여신패스여부</th>
                            <td>
                                <select id="ddlLoanPassYN" class="small-size">
                                    <option value="N">아니오</option>
                                    <option value="Y">예</option>
                                </select>
                                <span style="margin-left: 5px;">(추후 개발 예정)</span>
                            </td>
                            <th>보증여부</th>
                            <td>
                                <select id="ddlAssuranceYN" class="small-size">
                                    <option value="N">아니오</option>
                                    <option value="Y">예</option>
                                </select>
                            </td>
                        </tr>
                        <tr>
                            <th>여신 거래일자</th>
                            <td>
                                <%--<input type="date" class="txtCompManagement" id="txtLoanStartDate" readonly="readonly" style="margin-right: 5px;" onkeypress="return fnEnter()"/>--%>
                                <input type="date" id="txtLoanStartDate" class="calendar" readonly="readonly" />
                            </td>
                            <th>담보여부</th>
                            <td>
                                <select id="ddlCollateralYN" class="small-size">
                                    <option value="N">아니오</option>
                                    <option value="Y">예</option>
                                </select>
                            </td>
                        </tr>
                        <tr>
                            <th>대금 결제방법</th>
                            <td colspan="3">
                                <select class="small-size" id="ddlLoanPayway">
                                </select>
                            </td>
                        </tr>
                    </tbody>
                </table>
                <table class="tbl_main">
                    <thead>
                        <tr>
                            <th colspan="4">여신 제출서류</th>
                        </tr>
                    </thead>
                    <tbody id="tbodyLoanDoc"></tbody>
                </table>
            </div>
            <div id="divPayManagement">    
                <div class="sub-mini-title">
                    <p>구매사 결제관리</p>
                </div>
                <input type="hidden" id="hdPayway" />
                <table class="tbl_main" id="tblCompPayManagement">
                    <colgroup>
                        <col style="width: 20%" />
                        <col style="width: 20%" />
                        <col style="width: 20%" />
                        <col style="width: 20%" />
                    </colgroup>
                    <thead>
                    </thead>
                    <tbody id="tbodyBPayType">
                        <tr>
                            <td style="margin-left: 30px">
                                <input type="checkbox" id="ckbBPayway_1" value="1" style="margin-left: 100px" /> <img src="../../Images/Order/paywayicon_1.png">
                            </td>
                            <td>
                                <input type="checkbox" id="ckbBPayway_2" value="2" style="margin-left: 100px" /> <img src="../../Images/Order/paywayicon_2.png">
                            </td>
                            <td>
                                <input type="checkbox" id="ckbBPayway_3" value="3" onclick="fnCheckVirtualPayway(this)" style="margin-left: 100px" /> <img src="../../Images/Order/paywayicon_3.png">
                            </td>
                            <td>
                                <input type="checkbox" id="ckbBPayway_4" value="4" style="margin-left: 100px" /> <img src="../../Images/Order/paywayicon_4.png">
                            </td>

                        </tr>

                        <tr>
                            <td>
                                <input type="checkbox" id="ckbBPayway_5" value="5" style="margin-left: 100px" /> <img src="../../Images/Order/paywayicon_5.png">
                            </td>
                            <td>
                                <input type="checkbox" id="ckbBPayway_6" name="ckbLoanPayway" onclick="fnCheckLoanPayway(this)" value="6" style="margin-left: 100px" /> <img src="../../Images/Order/paywayicon_6.png">
                            </td>
                            <td>
                                <input type="checkbox" id="ckbBPayway_7" name="ckbLoanPayway" onclick="fnCheckLoanPayway(this)" value="7" style="margin-left: 100px" /> <img src="../../Images/Order/paywayicon_7.png">
                            </td>
                            <td>
                                <input type="checkbox" id="ckbBPayway_8" name="ckbLoanPayway" onclick="fnCheckLoanPayway(this)" value="8" style="margin-left: 100px" /> <img src="../../Images/Order/paywayicon_8.png">
                            </td>
                        </tr>

                        <tr>
                            <td>
                                <input type="checkbox" id="ckbBPayway_9" value="9" onclick="fnCheckVirtualPayway(this)" style="margin-left: 100px" /> <img src="../../Images/Order/paywayicon_9.png">
                            </td>
                            <td>
                                <input type="checkbox" id="ckbBPayway_10" value="10" style="margin-left: 100px" /> <img src="../../Images/Order/paywayicon_10.png">
                            </td>
                            <td>
                                <input type="checkbox" id="ckbBPayway_11" value="11" disabled="disabled" style="margin-left: 100px" /> 추가예정
                            </td>
                            <td>
                                <input type="checkbox" id="ckbBPayway_12" value="12" disabled="disabled" style="margin-left: 100px" /> 추가예정
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>

            <div class="bt-align-div">
                <input type="button" class="mainbtn type1" style="width: 105px; height: 30px; font-size: 12px" value="목록" onclick="fnGoPage('LIST')" />
                <input type="button" class="mainbtn type1" style="width: 105px; height: 30px; font-size: 12px" value="적용" onclick="return fnSaveComInfo()" />

                <%--            <input type="button" class="commonBtn" style="width:95px; height:30px; font-size:12px" value="목 록" onclick="javascript: document.location.href ='CompanyManagement.aspx'"/>
            <input type="button" class="commonBtn" style="width:95px; height:30px; font-size:12px" value="적 용" onclick="return fnSaveComInfo();"/>--%>
            </div>
        </div>
    </div>


    <%--팝업 소셜위드 관리 담당자 ID--%>
    <div id="admUserIdSearchDiv" class="popupdiv divpopup-layer-package">
        <div class="popupdivWrapper" style="width: 650px; height: 630px">
            <div class="popupdivContents">

                <div class="close-div">
                    <a onclick="return fnClosePopup('admUserIdSearchDiv');" style="cursor: pointer">
                        <img src="../../Images/Wish/icon-delete.jpg" alt="닫기" style="float:right;" /></a>
                </div>
                <div class="popup-title">
                    <h3 class="pop-title">소셜위드 관리 담당자 조회</h3>
                    <div class="search-div">
                        <select id="ddlPopSearch2" class="selectCompManagement" style="width: 100px; height: 25px;">
                            <option value="Name">이름</option>
                            <option value="Id">아이디</option>
                        </select>
                        <input type="text" class="text-code" id="txtPopSearch2" placeholder="검색어를 입력해 주세요." onkeypress="return fnPopupSearchTxtEnter('ADM');" style="width: 300px" />
                        <input type="button" class="mainbtn type1" style="width:75px;" value="검색" onclick="return fnAdmUserIdSearch(1);"/>
                        <%--<a class="imgA" onclick="return fnAdmUserIdSearch(1);">
                            <img src="../Images/Popup/search-bt-off.jpg" onmouseover="this.src='../Images/Popup/search-bt-on.jpg'" onmouseout="this.src='../Images/Popup/search-bt-off.jpg'" alt="검색" class="search-img" /></a>--%>
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
                        <div style="margin: 0 auto; text-align: center; padding-top: 10px">
                            <input type="hidden" id="hdTotalCount2" />
                            <div id="pagination2" class="page_curl" style="display: inline-block"></div>
                        </div>
                    </div>

                    <div class="btn_center">
                        <input type="button" value="취소" style="width:75px" class="mainbtn type2" onclick="return fnClosePopup('admUserIdSearchDiv');">
                        <input type="button" value="확인" style="width:75px" class="mainbtn type1" onclick="return fnPopupOkAdmUserId();">
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!--팝업 그룹 G 아이디 검색-->
    <div id="CodeSearchDiv" class="popupdiv divpopup-layer-package">
        <div class="popupdivWrapper" style="width: 650px; height: 630px">
            <div class="popupdivContents">
                <div class="close-div">
                    <a onclick="return fnClosePopup('CodeSearchDiv');" style="cursor: pointer">
                        <img src="../../Images/Wish/icon-delete.jpg" alt="닫기" style="float: right;" /></a>
                </div>
               <div class="popup-title">
                    <h3 class="pop-title">그룹 판매사 아이디 조회</h3>
                    <div class="search-div" style="margin-bottom: 20px;">
                        <select id="ddlPopSearch" class="selectCompManagement" style="width: 100px; height: 25px;">
                            <option value="Name">이름</option>
                            <option value="Id">아이디</option>
                        </select>
                        <input type="text" class="text-code" id="txtSearch" placeholder="검색어를 입력해 주세요." onkeypress="return fnPopupSearchTxtEnter('GRP');" style="width: 300px" />
                        <input type="button" class="commonBtn" style="width: 95px; height: 30px; font-size: 12px" value="검색" onclick="return fnGroupIdSearchPopup(1);" />
                        <%--<a class="imgA" onclick="return fnGroupIdSearchPopup(1);">
                            <img src="../Images/Popup/search-bt-off.jpg" onmouseover="this.src='../Images/Popup/search-bt-on.jpg'" onmouseout="this.src='../Images/Popup/search-bt-off.jpg'" alt="검색" class="search-img" /></a>--%>
                    </div>
                </div>

                <div class="divpopup-layer-conts">
                    <table id="tblSearch" style="width: 100%; margin-top: 0px" class="tbl_popup">
                        <colgroup>
                            <col style="width: 10px" />
                            <col style="width: 20px" />
                            <col style="width: 80px" />
                            <col style="width: 100px" />
                            <col style="width: 50px" />
                        </colgroup>
                        <thead>
                            <tr>
                                <th class="txt-center"></th>
                                <th class="txt-center">번호</th>
                                <th class="txt-center" id="thComp">그룹 판매사명</th>
                                <th class="txt-center" id="thId">아이디</th>
                                <th class="txt-center" id="thName">이름</th>
                            </tr>
                        </thead>
                        <tbody id="pop_commonTbody">
                            <tr>
                                <td colspan="5" class="txt-center">리스트가 없습니다.</td>
                            </tr>
                        </tbody>
                    </table>
                    <!-- 페이징 처리 -->
                    <div style="margin: 0 auto; text-align: center; padding-top: 10px">
                        <input type="hidden" id="hdTotalCount" />
                        <div id="pagination" class="page_curl" style="display: inline-block"></div>
                    </div>
                    <div style="text-align: right; margin-top: 30px;">
                        <input type="hidden" id="hdSelectCode" />
                        <input type="hidden" id="hdSelectName" />
                        <input type="button" class="commonBtn" style="width: 95px; height: 30px; font-size: 12px" value="취 소" onclick="return fnClosePopup('CodeSearchDiv');" />
                        <input type="button" class="commonBtn" style="width: 95px; height: 30px; font-size: 12px" value="확 인" onclick="return fnPopupOkGroupId();" />
                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>

