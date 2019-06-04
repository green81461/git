<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Master/AdminMasterPage.master" AutoEventWireup="true" CodeFile="BudgetAccountRegister.aspx.cs" Inherits="Admin_Company_BudgetAccountRegister" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <link href="../Content/Goods/goods.css" rel="stylesheet" />
    <link href="../Content/Company/company.css" rel="stylesheet" />



    <style>
        input {
            border: 1px solid #a2a2a2;
        }

        #tblBudget th {
            border: 1px solid #a2a2a2;
            background-color: #ececec;
            text-align: center;
        }

        #tblBudget td {
            border: 1px solid #a2a2a2;
            padding-left: 10px;
        }
    </style>

    <script type="text/javascript">
        $(document).ready(function () {
            var tableid = 'tblBudget';
            ListCheckboxOnlyOne(tableid);
            var tableid_popup = 'tblSearch';
            ListCheckboxOnlyOne(tableid_popup);
        })

        function commonPopUp(event) {
            fnSearch(1);

            var e = document.getElementById('CompSearchDiv');

            if (e.style.display == 'block') {
                e.style.display = 'none';

            } else {
                e.style.display = 'block';
            }
            return false;
        }

        //팝업창 검색
        function fnSearch(pageNo) {
            var txtSearch = $("#txtSearch").val();
            var searchTarget = $("#selectBudget option:selected").val();
            var compCode = "";
            var compArea = "";
            var compBusinessDept = "";
            var txtDeptCode = "";
            var type = "Company";
            var pageSize = 15;
            var asynTable = "";
            var i = 1;

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
                fnCreatePagination('pagination', $("#hdTotalCount").val(), pageNo, 15, getPageData);
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

        //예산계정코드 자동생성
        function fnCreateCode() {

            if ($("#txtCompanyCode").val() == '') {
                alert('회사를 선택해 주세요.');
                return false;
            }
            var sUser = '<%= Svid_User%>';
            var callback = function (response) {
                if (response != null) {
                    $('#txtBudgetAccountCode').val(response);

                } else {
                    alert('시스템 오류입니다. 관리자에게 문의하세요.');
                }

            }
            param = { CompanyCode: $("#txtCompanyCode").val(), Method: 'CreateBudgetAccountCode' };
            JajaxSessionCheck('Post', '../../Handler/Admin/BudgetHandler.ashx', param, 'text', callback, sUser);
        }

        function fnConfirm(event) {
            var txtValue = $('#txtNumber').val();
            var type = "";
            if (txtValue == '') {
                alert('값을 입력해 주세요.');
                $('#txtNumber').focus();
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

                        $("#txtCompanyCode").val(compCode);

                    }
                });
                fnCancel();
            }

        }

        function fnEnter() {
            if (event.keyCode == 13) {
                fnSearch(1);
                return false;
            }
            else
                return true;
        }

        function fnCancel() {
            $('#CompSearchDiv').fadeOut();
            return false;
        }


        function fnValidate() {
            var txtCompanyCode = $("#txtCompanyCode");
            var txtBudgetAccountCode = $("#txtBudgetAccountCode");
            var txtNumber = $("#txtNumber");
            var txtBudgetAccountName = $("#txtBudgetAccountName");

            if (txtCompanyCode.val() == '') {
                alert('구매사 회사코드를 입력해 주세요.');
                txtCompanyCode.focus();
                return false;
            }

            if (txtBudgetAccountCode.val() == '') {
                alert('예산계정코드를 입력해 주세요.');
                txtBudgetAccountCode.focus();
                return false;
            }

            if (txtBudgetAccountName.val() == '') {
                alert('예산계정명을 입력해 주세요.');
                txtBudgetAccountName.focus();
                return false;
            }

            saveForm();

            return true;
        }

        function saveForm() {
            var callback = function (response) {
                if (response == 'OK') {
                    alert('저장되었습니다.');
                }
                else {
                    alert('시스템 오류입니다. 관리자에게 문의하세요.');
                }
                return false;
            }

            var sUser = '<%= Svid_User%>';
            param = {
                SvidUser: sUser
                , Method: 'SaveBudgetAccount'
                , CompCode: $("#txtCompanyCode").val()
                , BudgetAccountCode: $("#txtBudgetAccountCode").val()
                , BudgetAccountName: $("#txtBudgetAccountName").val()
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
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div class="all">


        <div class="sub-contents-div">
            <div class="sub-title-div">
                <p class="p-title-mainsentence">
                    구매사 예산계정관리
                    <span class="span-title-subsentence"></span>
                </p>
            </div>
            <br />
            <div>
                <input type="button" class="mainbtn type1" style="width: 105px; height: 30px; font-size: 12px" value="예산관리" onclick="fnGoPage('BM')" />

            </div>
            <br />


            <!--탭메뉴-->
            <div class="div-main-tab" style="width: 100%;">
                <ul>
                    <li class='tabOff' style="width: 185px;" onclick="fnTabClickRedirect('BudgetAccountMain');">
                        <a onclick="fnTabClickRedirect('BudgetAccountMain');">구매사 예산계정조회</a>
                    </li>
                    <li class='tabOn' style="width: 185px;" onclick="fnTabClickRedirect('BudgetAccountRegister');">
                        <a onclick="fnTabClickRedirect('BudgetAccountRegister');">구매사 예산계정등록</a>
                    </li>
                </ul>
            </div>



            <!-- 테이블 div-->
            <div>
                <table id="tblBudget" style="width: 100%; margin-top: 30px; margin-bottom: 30px; border: 1px solid #a2a2a2;">

                    <tbody>
                        <tr>
                            <th>
                                <label>구매사 회사코드</label>
                            </th>
                            <td colspan="2">
                                <input type="text" id="txtCompanyCode" readonly="readonly" onkeypress="return fnEnter()" style="width: 320px; height: 24px">
                                <a onclick="return commonPopUp(this)">
                                    <img src="../../AdminSub/Images/Goods/search-bt-off.jpg" alt="검색" class="mainbtn type1" /></a>
                            </td>
                            <th>
                                <label>예산계정코드</label>
                            </th>
                            <td colspan="2">
                                <input type="text" id="txtBudgetAccountCode" readonly="readonly" onkeypress="return fnEnter()" style="width: 320px; height: 24px" />
                                <a onclick="return fnCreateCode(this)">
                                    <img src="../Images/Company/gn.jpg" alt="생성" class="mainbtn type1" /></a>
                            </td>
                        </tr>
                        <tr>
                            <th>
                                <input type="checkbox" id="chNum1" /><label>&nbsp;사업자번호</label><br />
                                <input type="checkbox" id="chNum2" /><label>&nbsp;고유번호&nbsp;&nbsp;&nbsp;&nbsp;</label>
                            </th>
                            <td colspan="2">
                                <input type="text" id="txtNumber" onkeypress="return fnEnter()" style="width: 320px; height: 24px" />
                                <a onclick="return fnConfirm(this)">
                                    <img src="../Images/Company/cf.jpg" alt="확인" class="mainbtn type1" /></a>
                            </td>
                            <th>
                                <label>예산계정명</label>
                            </th>
                            <td colspan="2">
                                <input type="text" id="txtBudgetAccountName" onkeypress="return fnEnter()" style="width: 400px; height: 24px" />
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
    </div>



    <!-- 수정 팝업-->

    <div id="CompSearchDiv" class="divpopup-layer-package">
        <div class="bordertypeWrapper" style="margin-top: 100px">
            <div class="bordertypeContent" style="border: none; height: 760px">
                <div class="divpopup-layer-container">
                    <h3 class="pop-title">구매사 회사코드</h3>
                    <div class="divpopup-layer-conts">
                        <div>
                            <select id="selectBudget" style='height: 21px'>
                                <option value="Code">코드</option>
                                <option value="Name">코드명</option>
                            </select>
                            <input type="text" id="txtSearch" onkeypress="return fnEnter()" />
                            <input type="button" class="commonBtn_msize" style="width: 60px; height: 25px; font-size: 12px" value="검색" onclick="return fnSearch(1)" />
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
    </div>

</asp:Content>

