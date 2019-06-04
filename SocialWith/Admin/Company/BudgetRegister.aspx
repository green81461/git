<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Master/AdminMasterPage.master" AutoEventWireup="true" CodeFile="BudgetRegister.aspx.cs" Inherits="Admin_Company_BudgetRegister" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <link href="../Content/Goods/goods.css" rel="stylesheet" />
    <link href="../Content/Company/company.css" rel="stylesheet" />

    <script type="text/javascript">
        $(document).ready(function () {
            var tableid = 'tblBudget';
            ListCheckboxOnlyOne(tableid);

            var tableid_popup = 'tblSearch';
            ListCheckboxOnlyOne(tableid_popup);

            RealTimeComma("txtBudget");
            initDate();

        })

        function initDate() {
            $("#txtYear").val(new Date().getFullYear());
            var mm = new Date().getMonth() + 1;
            if (mm < 10) {
                mm = '0' + mm;
            }
            $("#txtMonth").val(mm);
        }

        function commonPopUp(event) {
            $("#txtSearch").val(""); //초기화
            $("#divSubTitle").empty();
            var code = $(event).prev().attr("id");
            var title = "";
            $("#hdCode").val(code);
            if (code == 'txtCompanyCode') {

                title = "<img src='../Images/Company/BcorpCode-title.jpg' alt='구매사회사코드' />";
            } else if (code == 'txtCompAreaCode') {
                if ($("#txtCompanyCode").val() == "") {
                    alert('구매사 회사코드를 먼저 입력해 주세요.');
                    return false;
                } else {
                    title = "<img src='../Images/Company/bPop-title2.jpg' alt='구매사사업장코드' />";
                }
            } else if (code == 'txtBusinessDeptCode') {
                if ($("#txtCompAreaCode").val() == "") {
                    alert('구매사 사업장코드를 먼저 입력해 주세요.');
                    return false;
                } else {
                    title = "<img src='../Images/Company/balPop-title3.jpg' alt='구매사사업부코드' />";
                }
            } else if (code == 'txtDeptCode') {
                if ($("#txtBusinessDeptCode").val() == "") {
                    alert('구매사 사업부코드를 먼저 입력해 주세요.');
                    return false;
                } else {
                    title = "<img src='../Images/Company/balPop-title4.jpg' alt='구매사부서명코드' />";
                }
            }

            $("#divSubTitle").append(title);
            fnSearch(1);

            var e = document.getElementById('CompSearchDiv');

            if (e.style.display == 'block') {
                e.style.display = 'none';

            } else {
                e.style.display = 'block';
            }
            return false;
        }

        function fnCancel() {
            $('#CompSearchDiv').fadeOut();
            return false;
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
                        var code = $("#hdCode").val();
                        if (code == 'txtCompanyCode') {
                            $("#txtCompanyCode").val(compCode);
                        } else if (code == 'txtCompAreaCode') {
                            $("#txtCompAreaCode").val(compCode);
                        } else if (code == 'txtBusinessDeptCode') {
                            $("#txtBusinessDeptCode").val(compCode);
                        } else if (code == 'txtDeptCode') {
                            $("#txtDeptCode").val(compCode);
                        }
                    }
                });
                fnCancel();
            }

        }

        function fnConfirm(event) {
            var txtValue = $('#txtNumber').val();
            var type = "";
            if (txtValue == '') {
                alert('값을 입력해 주세요.');
                return false;
            }
            if ($("input:checkbox[id='chNum1']").is(":checked") == true) {
                type = "CompNo";
            } else if ($("input:checkbox[id='chNum2']").is(":checked") == true) {
                type = "UniqueNo";
            } else {
                alert("사업자번호 또는 고유번호 체크박스를 체크해 주세요.");
                return false;
            }
            var callback = function (response) {
                if (!isEmpty(response)) {
                    $('#txtCompanyCode').val(response.Company_Code);
                } else {
                    alert('확인된 구매사 회사코드 값이 없습니다.');
                }

            }

            var sUser = '<%= Svid_User%>';
            param = { SvidUser: sUser, TextValue: txtValue, Method: 'CompanyInfo', Type: type };
            JajaxSessionCheck('Post', '../../Handler/Admin/BudgetHandler.ashx', param, 'json', callback, sUser);



        }

        //팝업창 검색
        function fnSearch(pageNo) {
            var txtSearch = $("#txtSearch").val();
            var searchTarget = $("#selectBudget option:selected").val();
            var code = $("#hdCode").val();
            var compCode = "";
            var compArea = "";
            var compBusinessDept = "";
            var txtDeptCode = "";
            var type = "";
            var pageSize = 15;
            var asynTable = "";
            var i = 1;

            if (code == 'txtCompanyCode') {
                type = "Company";

            } else if (code == 'txtCompAreaCode') {
                type = "Area";
                compCode = $("#txtCompanyCode").val();
            } else if (code == 'txtBusinessDeptCode') {
                type = "Business";
                compCode = $("#txtCompanyCode").val();
                compArea = $("#txtCompAreaCode").val();
            } else if (code == 'txtDeptCode') {
                type = "Dept";
                compCode = $("#txtCompanyCode").val();
                compArea = $("#txtCompAreaCode").val();
                compBusinessDept = $("#txtBusinessDeptCode").val();
            }

            var callback = function (response) {
                $("#tblSearch tbody").empty();

                if (!isEmpty(response)) {
                    $.each(response, function (key, value) {
                        $('#hdTotalCount').val(value.TotalCount);

                        asynTable += "<tr>";
                        asynTable += "<td class='txt-center'><input type='checkbox'/></td>";
                        asynTable += "<td class='txt-center'>" + (pageSize * (pageNo - 1) + i) + "</td>";
                        asynTable += "<td class='txt-center' id='tdCompCode'>" + value.Company_Code + "</td>";
                        asynTable += "<td class='txt-center' id='tdCompName'>" + value.Company_Name + "</td>";
                        asynTable += "</tr>";
                        i++;
                    });
                } else {
                    asynTable += "<tr><td colspan='4' class='txt-center'>" + "조회된 데이터가 없습니다." + "</td></tr>"
                    $("#hdTotalCount").val(0);
                }
                $("#tblSearch tbody").append(asynTable);

                //페이징
                fnCreatePagination('pagination', $("#hdTotalCount").val(), pageNo, pageSize, getPageData);
                return false;
            }

            var sUser = '<%= Svid_User%>';
            param = { SvidUser: sUser, Method: 'CompanyInfoList', SearchKeyword: txtSearch, SearchTarget: searchTarget, Type: type, PageNo: pageNo, PageSize: pageSize, CompCode: compCode, CompArea: compArea, CompBusinessDept: compBusinessDept };
            JajaxSessionCheck('Post', '../../Handler/Admin/BudgetHandler.ashx', param, 'json', callback, sUser);

        }

        //페이징 인덱스 클릭시 데이터 바인딩
        function getPageData() {
            var container = $('#pagination');
            var getPageNum = container.pagination('getSelectedPageNum');
            fnSearch(getPageNum);
            return false;
        }

        function fnEnter() {
            if (event.keyCode == 13) {
                fnSearch(1);
                return false;
            }
            else
                return true;
        }

        function fnValidate() {
            var txtYear = $("#txtYear");
            var txtMonth = $("#txtMonth");
            var txtCompanyCode = $("#txtCompanyCode");
            var txtCompAreaCode = $("#txtCompAreaCode");
            var txtDeptCode = $("#txtDeptCode");
            var txtNumber = $("#txtNumber");
            var txtBusinessDeptCode = $("#txtBusinessDeptCode");
            var txtBudget = $("#txtBudget");

            if (txtYear.val() == '') {
                alert('년도를 입력해 주세요.');
                txtYear.focus();
                return false;
            }

            if (txtYear.val().length != 4) {
                alert('년도를 4자리로 입력해 주세요.');
                txtYear.focus();
                return false;
            }

            if (txtYear.val() < 1900 || txtYear.val() > 3000) {
                alert('유효하지 않은 년도 입니다.');
                txtYear.focus();
                return false;
            }

            if (txtMonth.val() == '') {
                alert('월을 입력해 주세요.');
                txtMonth.focus();
                return false;
            }


            if (txtMonth.val().length != 2) {
                alert('월을 2자리로 입력해 주세요.');
                txtMonth.focus();
                return false;
            }

            if (txtMonth.val() < 1 || txtMonth.val() > 12) {
                alert('유효하지 않은 월 입니다.');
                txtMonth.focus();
                return false;
            }

            //if (txtNumber.val() == '') {
            //    alert('사업자번호 또는 고유번호를 입력해 주세요.');
            //    txtNumber.focus();
            //    return false;
            //}

            if (txtCompanyCode.val() == '') {
                alert('구매사 회사코드를 입력해 주세요.');
                txtCompanyCode.focus();
                return false;
            }

            if (txtCompAreaCode.val() == '') {
                alert('구매사 사업장코드를 입력해 주세요.');
                txtCompAreaCode.focus();
                return false;
            }

            if (txtBusinessDeptCode.val() == '') {
                alert('구매사 사업부코드를 입력해 주세요.');
                txtBusinessDeptCode.focus();
                return false;
            }

            if (txtDeptCode.val() == '') {
                alert('구매사 부서명코드를 입력해 주세요.');
                txtDeptCode.focus();
                return false;
            }

            if (txtBudget.val() == '') {
                alert('예산금액을 입력해 주세요.');
                txtBudget.focus();
                return false;
            }
            saveForm();

            return true;
        }

        function saveForm() {
            var callback = function (response) {
                if (response == '1') {
                    alert('저장되었습니다.');
                }
                else if (response == '2') {
                    alert('값이 중복되어 저장할 수 없습니다.');
                } else {
                    alert('시스템 오류입니다. 관리자에게 문의하세요.');
                }
                return false;
            }

            var txtBudget = $("#txtBudget").val();
            txtBudget = txtBudget.replace(/[^\d]+/g, ''); // (,)지우기 

            var sUser = '<%= Svid_User%>';
            param = {
                SvidUser: sUser
                , Method: 'SaveBudget'
                , YYYY: $("#txtYear").val()
                , MM: $("#txtMonth").val()
                , CompCode: $("#txtCompanyCode").val()
                , CompArea: $("#txtCompAreaCode").val()
                , CompBusinessDept: $("#txtBusinessDeptCode").val()
                , DeptCode: $("#txtDeptCode").val()
                , Budget: txtBudget
            };
            JajaxSessionCheck('Post', '../../Handler/Admin/BudgetHandler.ashx', param, 'text', callback, sUser);
        }
        //페이지 이동
        function fnGoPage(pageVal) {
            switch (pageVal) {
                case "BAM":
                    window.location.href = "../Company/BudgetAccountMain?ucode=" + ucode;
                    break;
                case "BM":
                    window.location.href = "../Company/BudgetMain?ucode=" + ucode;
                    break;
                default:
                    break;
            }
        }

        function fnTabClickRedirect(pageName) {
            location.href = pageName + '.aspx?ucode=' + ucode;
            return false;
        }
    </script>
    <style>
        a {
            cursor: pointer;
        }

        #tblBudget th {
            text-align: center;
            height: 30px;
            background-color: #ececec;
        }

        .txtBoxS {
            width: 60%;
            border: 1px solid #a2a2a2;
            height: 25px
        }

        .txtBox {
            width: 80%;
            height: 25px;
            border: 1px solid #a2a2a2;
        }

        #tblBudget td {
            padding-left: 5px;
            padding-right: 5px;
            height: 30px;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div class="all">
        <div class="sub-title-div">
            <p class="p-title-mainsentence">
                구매사 예산관리
                    <span class="span-title-subsentence"></span>
            </p>
        </div>
        <br />
        <div>
            <input type="button" class="mainbtn type1" style="width: 105px; height: 30px; font-size: 12px" value="예산계정관리" onclick="fnGoPage('BAM')" />

        </div>
        <br />

        <!--탭메뉴-->
        <div class="div-main-tab" style="width: 100%;">
            <ul>
                <li class='tabOff' style="width: 185px;" onclick="fnTabClickRedirect('BudgetMain');">
                    <a onclick="fnTabClickRedirect('BudgetMain');">구매사 예산조회</a>
                </li>
                <li class='tabOn' style="width: 185px;" onclick="fnTabClickRedirect('BudgetRegister');">
                    <a onclick="fnTabClickRedirect('BudgetRegister');">구매사 예산등록</a>
                </li>
            </ul>
        </div>



        <!-- 테이블 div-->
        <div>
            <table id="tblBudget" border="1" style="width: 100%; margin-top: 30px; margin-bottom: 30px; border: 1px solid #a2a2a2;">

                <thead></thead>
                <tbody>
                    <tr>
                        <th>
                            <label>년도</label>
                        </th>
                        <td colspan="2">
                            <input type="text" id="txtYear" onkeypress="return onlyNumbers(event);" maxlength="4" class="txtBoxS" style="width: 100%" />
                        </td>
                        <th>
                            <label>월</label>
                        </th>
                        <td colspan="2">
                            <input type="text" id="txtMonth" onkeypress="return onlyNumbers(event);" maxlength="2" class="txtBoxS" style="width: 100%" />
                        </td>
                    </tr>
                    <tr>
                        <th>
                            <label>구매사 회사코드</label>
                        </th>
                        <td colspan="2">
                            <input type="text" id="txtCompanyCode" readonly="readonly" onkeypress="return fnEnter()" class="txtBox" />
                            <a onclick="return commonPopUp(this)">
                                <img src="../../AdminSub/Images/Goods/search-bt-off.jpg" alt="검색" class="mainbtn type1" /></a>

                        </td>
                        <th>
                            <input type="checkbox" id="chNum1" /><label>&nbsp;&nbsp;사업자번호</label><br />
                            <input type="checkbox" id="chNum2" /><label>&nbsp;&nbsp;고유번호&nbsp;&nbsp;&nbsp;&nbsp;</label>
                        </th>
                        <td colspan="2">
                            <input type="text" id="txtNumber" onkeypress="return fnEnter()" class="txtBoxS" />
                            <a onclick="return fnConfirm(this)">
                                <img src="../Images/Company/confirm.jpg" alt="확인" class="mainbtn type1" /></a>
                        </td>
                    </tr>
                    <tr>
                        <th>
                            <label>구매사 사업장코드</label>
                        </th>
                        <td colspan="2">
                            <input type="text" id="txtCompAreaCode" readonly="readonly" onkeypress="return fnEnter()" class="txtBox" />
                            <a onclick="return commonPopUp(this)">
                                <img src="../../AdminSub/Images/Goods/search-bt-off.jpg" alt="검색" class="mainbtn type1" /></a>
                        </td>
                        <th>
                            <label>구매사 사업부코드</label>
                        </th>
                        <td colspan="2">
                            <input type="text" id="txtBusinessDeptCode" readonly="readonly" onkeypress="return fnEnter()" class="txtBox" />
                            <a onclick="return commonPopUp(this)">
                                <img src="../../AdminSub/Images/Goods/search-bt-off.jpg" alt="검색" class="mainbtn type1" /></a>
                        </td>
                    </tr>
                    <tr>
                        <th>
                            <label>구매사 부서명코드</label>
                        </th>
                        <td colspan="2">
                            <input type="text" id="txtDeptCode" readonly="readonly" onkeypress="return fnEnter()" class="txtBox" />
                            <a onclick="return commonPopUp(this)">
                                <img src="../../AdminSub/Images/Goods/search-bt-off.jpg" alt="검색" class="mainbtn type1" /></a>
                        </td>
                        <th>
                            <label>예산금액</label>
                        </th>
                        <td colspan="2">
                            <input type="text" id="txtBudget" onkeypress="return onlyNumbers(event);" class="txtBoxS" style="width: 100%" />
                        </td>
                    </tr>
                </tbody>

            </table>
        </div>
        <!-- 테이블 div끝-->

        <div style="text-align: right;">
            <a>
                <img src="../Images/Member/save.jpg" alt="저장" onclick="return fnValidate();" class="mainbtn type1" /></a>
        </div>


    </div>


    <!-- 수정 팝업-->

    <div id="CompSearchDiv" class="popupdiv divpopup-layer-package">
        <div class="popupdivWrapper" style="margin-top: 100px; height: 750px; width: 700px">
            <div class="popupdivContents" style="border: none">
                <div class="sub-title-div" id="divSubTitle"></div>
                <div class="divpopup-layer-conts">
                    <div>
                        <select id="selectBudget" style="width: 100px; height: 25px">
                            <option value="Code">코드</option>
                            <option value="Name">코드명</option>
                        </select>
                        <input type="text" id="txtSearch" style="width: 300px; height: 25px; border: 1px solid #a2a2a2" onkeypress="return fnEnter()" />
                        <a onclick="return fnSearch(1)">
                            <img src="../../AdminSub/Images/Goods/search-bt-off.jpg" alt="검색" /></a>
                    </div>
                    <input type="hidden" id="hdCode" />

                    <table id="tblSearch" style="width: 100%; margin-top: 20px" class="tbl_popup">
                        <colgroup>
                            <col style="width: 30px" />
                            <col style="width: 100px" />
                            <col style="width: 100px" />
                            <col style="width: 200px" />
                        </colgroup>
                        <thead>
                            <tr>
                                <th class="txt-center">선택</th>
                                <th class="txt-center">번호</th>
                                <th class="txt-center">코드</th>
                                <th class="txt-center">코드명</th>
                            </tr>
                        </thead>
                        <tbody></tbody>
                    </table>
                    <br />

                    <!--페이징-->
                    <input type="hidden" id="hdTotalCount" />
                    <div style="margin: 0 auto; text-align: center">
                        <div id="pagination" class="page_curl" style="display: inline-block"></div>
                    </div>

                    <div style="text-align: right">
                        <a onclick="fnCancel()" id="btnCancel">
                            <img src="../Images/Order/cancle.jpg" alt="취소" onmouseover="this.src='../Images/Order/cancle-on.jpg'" onmouseout="this.src='../Images/Order/cancle.jpg'" /></a>
                        <a onclick="fnSave()" id="btnSave">
                            <img src="../Images/Order/save.jpg" alt="저장" onmouseover="this.src='../Images/Order/save-on.jpg'" onmouseout="this.src='../Images/Order/save.jpg'" /></a>
                    </div>

                </div>
            </div>
        </div>
    </div>


</asp:Content>

