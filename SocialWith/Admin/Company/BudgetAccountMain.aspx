<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Master/AdminMasterPage.master" AutoEventWireup="true" CodeFile="BudgetAccountMain.aspx.cs" Inherits="Admin_Company_BudgetAccountMain" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <link href="../Content/Goods/goods.css" rel="stylesheet" />
    <link href="../Content/Company/company.css" rel="stylesheet" />
    <style>
        #tblSearch th {
            height: 30px;
        }

        #tblSearch td {
            height: 30px;
        }
    </style>
    <script type="text/javascript">
        $(document).ready(function () {

            fnSearch(1);
            fnSearch2(1);

            //체크박스 하나만 선택
            var tableid = 'divCalendar';
            ListCheckboxOnlyOne(tableid);

            //달력
            $("#txtSearchSdate").datepicker({
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

            $("#txtSearchEdate").datepicker({
                showAnimation: 'slideDown',
                changeMonth: true,
                changeYear: true,
                showOn: 'button',
                buttonImage:/* "/Images/icon_calandar.png
                ."*/"../../Images/Goods/calendar.jpg",
                buttonImageOnly: true,
                dateFormat: "yy-mm-dd",
                monthNamesShort: ["1월", "2월", "3월", "4월", "5월", "6월", "7월", "8월", "9월", "10월", "11월", "12월"],
                dayNamesMin: ["일", "월", "화", "수", "목", "금", "토"],
                showMonthAfterYear: true
            });

            $('#divCalendar input[type="checkbox"]').change(function () {
                if ($(this).prop('checked') == true) {
                    var num = $(this).val();
                    var newDate = new Date($("#txtSearchEdate").val());
                    var resultDate = new Date();
                    resultDate.setDate(newDate.getDate() - num);
                    $("#txtSearchSdate").val($.datepicker.formatDate("yy-mm-dd", resultDate));
                }
            });

        })

        function fnSearch(pageNo) {
            var searchText = $("#txtSearch").val();
            var searchDelFlag = $("#selectSearchDelFlag option:selected").val();
            var searchTarget = $("#selectSearchTarget option:selected").val();
            var pageSize = 20;
            var asynTable = "";
            var i = 1;

            var callback = function (response) {
                $("#tblBudgetAccount tbody").empty();

                if (!isEmpty(response)) {
                    $.each(response, function (key, value) {
                        $('#hdTotalCount').val(value.TotalCount);

                        asynTable += "<tr>";
                        asynTable += "<td class='txt-center' rowspan='2'><input type='checkbox'/>";
                        asynTable += "<input type='hidden' id='hdUserName' value='" + value.UserName + "'/>";
                        asynTable += "<input type='hidden' id='hdMsvidUser' value='" + value.ModiSvid_User + "'/>";
                        asynTable += "<input type='hidden' id='hdUseFlag' value='" + value.DelFlag + "'/></td>";
                        asynTable += "<td class='txt-center' rowspan='2'>" + (pageSize * (pageNo - 1) + i) + "</td>";
                        asynTable += "<td class='txt-center' id='tdCompCode' >" + value.Company_Code + "</td>";
                        asynTable += "<td class='txt-center' rowspan='2' id='tdAccountCode'>" + value.BudgetAccount_Code + "</td>";
                        asynTable += "<td class='txt-center' id='tdCompNo'>" + value.Company_No + "</td>";
                        asynTable += "<td class='txt-center' rowspan='2'>" + value.BudgetAccount_Name + "</td>";
                        asynTable += "<td class='txt-center' rowspan='2'>" + value.DelFlag_Name + "</td>";
                        asynTable += "<td class='txt-center' rowspan='2'><a onclick='return fnSetting(this)'><img src='../Images/Member/setting1-on.jpg'  onmouseover='this.src = \"../Images/Member/setting1-off.jpg\"' onmouseout='this.src = \"../Images/Member/setting1-on.jpg\"' alt='설정'/></a></td>";
                        asynTable += "<td class='txt-center' rowspan='2' id='tdRemark'><a style='cursor:pointer; color:blue' onclick='return fnChangeReason(this)'>" + value.Remark + "</a></td>";
                        asynTable += "<td class='txt-center' >" + value.ModiUserName + "</td>";
                        asynTable += "<td class='txt-center' >" + value.UserName + "</td>";
                        asynTable += "</tr>";
                        //--------------------------------------------------다음행-----------------------------------------//
                        asynTable += "<tr>";
                        asynTable += "<td class='txt-center' >" + value.Company_Name + "</td>";
                        var uniqueNo = value.UpdateDate;
                        if (uniqueNo == null) {
                            uniqueNo = "";
                        } else {
                            uniqueNo = uniqueNo.split('T')[0];
                        }
                        asynTable += "<td class='txt-center' >" + value.Unique_No + "</td>";
                        asynTable += "<td class='txt-center' >" + uniqueNo + "</td>";
                        asynTable += "<td class='txt-center' >" + value.EntryDate.split('T')[0] + "</td>";


                        asynTable += "</tr>";
                        i++;
                    });
                } else {
                    asynTable += "<tr class='board-tr-height'><td colspan='11' class='txt-center'>" + "조회된 데이터가 없습니다." + "</td></tr>"
                    $("#hdTotalCount").val(0);
                }
                $("#tblBudgetAccount tbody").append(asynTable);

                //페이징
                fnCreatePagination('pagination', $("#hdTotalCount").val(), pageNo, 20, getPageData);
                return false;
            }

            var sUser = '<%= Svid_User%>';
            param = {
                SvidUser: sUser
                , Method: 'BudgetAccountList'
                , Keyword: searchText
                , UseFlag: searchDelFlag
                , Target: searchTarget
                , PageNo: pageNo
                , PageSize: pageSize
            };
            JajaxSessionCheck('Post', '../../Handler/Admin/BudgetHandler.ashx', param, 'json', callback, sUser);
        }

        //페이징 인덱스 클릭시 데이터 바인딩
        function getPageData() {
            var container = $('#pagination');
            var getPageNum = container.pagination('getSelectedPageNum');
            fnSearch(getPageNum);
            return false;
        }

        function getPageData_Popup() {
            var container = $('#pagination_Popup');
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

        function fnEnter_Popup() {
            if (event.keyCode == 13) {
                fnSearch2(1);
                return false;
            }
            else
                return true;
        }

        function fnSetting(event) {
            $("#txtContent").val("");//초기화 
            $('#lbUser').text($(event).parent().parent().find("#hdUserName").val());
            $("#hdCompNo").val($(event).parent().parent().find("#tdCompNo").text());
            $("#hdCompCode").val($(event).parent().parent().find("#tdCompCode").text());
            $("#hdAccountCode").val($(event).parent().parent().find("#tdAccountCode").text());

            var e = document.getElementById('SettingDiv');

            if (e.style.display == 'block') {
                e.style.display = 'none';

            } else {
                e.style.display = 'block';
            }
            return false;
        }

        function fnChangeReason(event) {
            $("#txtName").val("");//초기화 
            $("#txtSearchEdate").val((new Date()).yyyymmdd());
            var newDate = new Date($("#txtSearchEdate").val());
            var resultDate = new Date();
            resultDate.setDate(newDate.getDate() - 7);
            $("#txtSearchSdate").val($.datepicker.formatDate("yy-mm-dd", resultDate));

            $("#hdCompNo").val($(event).parent().parent().find("#tdCompNo").text());
            $("#hdAccountCode").val($(event).parent().parent().find("#tdAccountCode").text());


            fnSearch2(1);

            var e = document.getElementById('ChangeReasonDiv');

            if (e.style.display == 'block') {
                e.style.display = 'none';

            } else {
                e.style.display = 'block';
            }
            return false;
        }

        function fnCancel() {
            $('#SettingDiv').fadeOut();
            return false;
        }

        function fnCancel2() {
            $('#ChangeReasonDiv').fadeOut();
            return false;
        }

        function fnPopupValidate() {

            var selectUse = $("#selectUse option:selected").val();
            var txtContent = $("#txtContent").val();

            if (txtContent == '') {
                alert('변경이유를 입력해 주세요.');
                txtContent.focus();
                return false;
            }
            fnSave(selectUse, txtContent);
            fnCancel();
            return true;
        }

        function fnSearch2(pageNo) {
            var txtSearchSdate = $("#txtSearchSdate").val();
            var txtSearchEdate = $("#txtSearchEdate").val();
            var keyword = $("#txtName").val();
            var compNo = $("#hdCompNo").val();
            var accountCode = $("#hdAccountCode").val();
            var pageSize = 20;
            var asynTable = "";
            var i = 1;
            var sUser = '<%= Svid_User%>';

            var callback = function (response) {
                $("#tblSearch tbody").empty();

                if (!isEmpty(response)) {
                    $.each(response, function (key, value) {
                        $('#hdTotalCount_Popup').val(value.TotalCount);

                        asynTable += "<tr>";
                        asynTable += "<td class='txt-center'>" + (pageSize * (pageNo - 1) + i) + "</td>";
                        asynTable += "<td class='txt-center'>" + value.ModiUserName + "</td>";
                        asynTable += "<td class='txt-center'>" + value.EntryDate.split('T')[0] + "</td>";
                        asynTable += "<td class='txt-center'>" + value.Remark + "</td>";
                        asynTable += "</tr>";
                        i++;
                    });
                } else {
                    asynTable += "<tr><td colspan='4' class='txt-center'>" + "조회된 데이터가 없습니다." + "</td></tr>"
                    $("#hdTotalCount_Popup").val(0);
                }
                $("#tblSearch tbody").append(asynTable);

                //페이징
                fnCreatePagination('pagination_Popup', $("#hdTotalCount_Popup").val(), pageNo, 20, getPageData_Popup);
                return false;
            }

            param = {
                SvidUser: sUser
                , Method: 'BAModifyHistoryList'
                , Keyword: keyword
                , Sdate: txtSearchSdate
                , Edate: txtSearchEdate
                , CompNo: compNo
                , AccountCode: accountCode
                , PageNo: pageNo
                , PageSize: pageSize
            };

            JajaxSessionCheck('Post', '../../Handler/Admin/BudgetHandler.ashx', param, 'json', callback, sUser);

        }

        function fnSave(useFlag, content) {
            var compNo = $("#hdCompNo").val();
            var compCode = $("#hdCompCode").val();
            var accountCode = $("#hdAccountCode").val();
            var callback = function (response) {
                if (response == 'OK') {
                    alert('설정되었습니다.');
                    window.location.reload(true);

                }
                else {
                    alert('시스템 오류입니다. 관리자에게 문의하세요.');
                }
                return false;
            }

            var sUser = '<%= Svid_User%>';
            param = {
                SvidUser: sUser
                , Method: 'UpdateBAUseStatus'
                , Remark: content
                , UseFlag: useFlag
                , MsvidUser: sUser
                , AccountCode: accountCode
                , CompCode: compCode
                , CompNo: compNo
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


                <!--탭메뉴-->
                <div class="div-main-tab" style="width: 100%;">
                    <ul>
                        <li class='tabOn' style="width: 185px;" onclick="fnTabClickRedirect('BudgetAccountMain');">
                            <a onclick="fnTabClickRedirect('BudgetAccountMain');">구매사 예산계정조회</a>
                        </li>
                        <li class='tabOff' style="width: 185px;" onclick="fnTabClickRedirect('BudgetAccountRegister');">
                            <a onclick="fnTabClickRedirect('BudgetAccountRegister');">구매사 예산계정등록</a>
                        </li>
                    </ul>
                </div>




                <!--상단 조회 영역 시작-->
                <div class="search-div">
                    <div class="bottom-search-div" style="margin-bottom: 1px">
                        <table class="notice-search-table" style="width: 100%; margin-top: 30px; margin-bottom: 30px; border: 1px solid #a2a2a2;">
                            <tr>
                                <th style="width: 90px"></th>
                                <td style="width: 90px">
                                    <select id="selectSearchDelFlag" style="width: 150px">
                                        <option selected="selected" value="ALL">사용/미사용 선택</option>
                                        <option value="N">사용</option>
                                        <option value="Y">미사용</option>
                                    </select>
                                </td>
                                <td style="width: 150px;">
                                    <select id="selectSearchTarget" style="width: 150px; margin-left: 5px; position: relative; top: -3px">
                                        <option selected="selected" value="Code">구매사 회사코드</option>
                                        <option value="Name">구매사 회사명</option>
                                        <option value="CompNo">사업자 번호</option>
                                    </select>
                                </td>
                                <td>
                                    <input type="text" placeholder="검색어를 입력하세요." style="padding-left: 10px; width: 100%" id="txtSearch" onkeypress="return fnEnter();" />
                                </td>
                                <td style="text-align: left">
                                    <a>
                                        <img src="../Images/Order/search-off.jpg" alt="검색" id="btnSearch" onclick="return fnSearch(1)" class="mainbtn type1" /></a>

                                    <a>
                                        <img src="../Images/Company/adj1.jpg" alt="적용" id="btnApplication" onclick="" class="mainbtn type1" /></a>
                                </td>
                            </tr>
                        </table>
                    </div>
                </div>

                <br />

                <div class="fileDiv" style="margin-bottom: 30px; height: 30px;">

                    <table class="fileTbl">
                        <tr>
                            <th>엑셀파일 등록</th>
                            <td>
                                <asp:FileUpload runat="server" ID="fuExcel" CssClass="excelfileupload" /></td>
                            <td style="border-right: none;">
                                <asp:Button ID="ibtnExcelUpload" Text="엑셀업로드" runat="server" OnClick="ibtnExcelUpload_Click" CssClass="mainbtn type1" /></td>
                            <td style="border-left: none;">
                                <asp:Button ID="ibtnExcelFormDownload" Text="엑셀업로드폼 다운로드" runat="server" OnClick="ibtnExcelFormDownload_Click" CssClass="mainbtn type1" /></td>
                        </tr>
                    </table>

                </div>

                <!-- 테이블 div-->
                <div>
                    <table id="tblBudgetAccount" border="1" class="tbl_main" style="width: 100%; margin-top: 30px; margin-bottom: 30px; border: 1px solid #a2a2a2;">
                        <colgroup>
                            <col style="width: 50px;" />
                            <col style="width: 70px;" />
                            <col style="width: 150px;" />
                            <col style="width: 150px;" />
                            <col style="width: 150px;" />
                            <col style="width: 120px;" />
                            <col style="width: 80px;" />
                            <col style="width: 100px;" />
                            <col style="width: 150px;" />
                            <col style="width: 150px;" />
                            <col style="width: 150px;" />
                        </colgroup>
                        <thead style="background-color: #f0f0f0">
                            <tr>
                                <th class="txt-center" rowspan="2">선택</th>
                                <th class="txt-center" rowspan="2">번호</th>
                                <th class="txt-center">구매사 회사코드</th>
                                <th class="txt-center" rowspan="2">예산계정코드</th>
                                <th class="txt-center">사업자번호</th>
                                <th class="txt-center" rowspan="2">예산계정명</th>
                                <th class="txt-center" rowspan="2">사용유무</th>
                                <th class="txt-center" rowspan="2">설정</th>
                                <th class="txt-center" rowspan="2">변경이유</th>
                                <th class="txt-center">변경자</th>
                                <th class="txt-center">등록자</th>
                            </tr>
                            <tr>
                                <th class="txt-center">구매사 회사명</th>
                                <th class="txt-center">고유번호</th>
                                <th class="txt-center">변경날짜</th>
                                <th class="txt-center">등록날짜</th>
                            </tr>
                        </thead>
                        <tbody>
                        </tbody>

                    </table>
                </div>
                <!-- 테이블 div끝-->

                <br />


                <!--페이징-->
                <input type="hidden" id="hdTotalCount" />
                <div style="margin: 0 auto; text-align: center">
                    <div id="pagination" class="page_curl" style="display: inline-block"></div>
                </div>
            </div>
        </div>


        <!-- 설정 팝업-->

        <div id="SettingDiv" class="divpopup-layer-package">
            <div class="bordertypeWrapper" style="margin-top: 300px">
                <div class="bordertypeContent" style="border: none;">
                    <div class="divpopup-layer-container">
                        <div class="sub-title-div" id="divSubTitle">
                            <img src="../Images/Company/settingPop-title.jpg" alt="설정" />
                        </div>
                        <div class="divpopup-layer-conts">
                            <table id="divSetting">
                                <tr>
                                    <th>
                                        <label>변경자</label></th>
                                    <td>
                                        <label id="lbUser"></label>
                                    </td>
                                </tr>

                                <tr>
                                    <th>
                                        <label>사용유무</label></th>
                                    <td>
                                        <select id="selectUse">
                                            <option value="N">사용</option>
                                            <option value="Y">중지</option>
                                        </select></td>
                                </tr>

                                <tr>
                                    <th>
                                        <label>변경이유</label></th>
                                    <td>
                                        <textarea id="txtContent"></textarea></td>
                                </tr>
                            </table>



                            <div style="text-align: right; margin-top: 15px;">
                                <a onclick="fnCancel()" id="btnCancel">
                                    <img src="../Images/Company/cancleB-off.jpg" alt="취소" onmouseover="this.src='../Images/Company/cancleB-off.jpg'" onmouseout="this.src='../Images/Company/cancleB-off.jpg'" /></a>
                                <a onclick="fnPopupValidate(this)" id="btnSave">
                                    <img src="../Images/Company/adjust-off.jpg" alt="적용" onmouseover="this.src='../Images/Company/adjust-on.jpg'" onmouseout="this.src='../Images/Company/adjust-off.jpg'" /></a>
                                <input type="hidden" id="hdCompNo" />
                                <input type="hidden" id="hdCompCode" />
                                <input type="hidden" id="hdAccountCode" />
                            </div>

                        </div>
                    </div>
                </div>
            </div>
        </div>




        <!-- 변경이유 팝업-->



        <div id="ChangeReasonDiv" class="divpopup-layer-package">
            <div class="BudgetAccWrapper" style="margin-top: 100px">
                <div class="BudgetAccContent" style="border: none;">
                    <div class="divpopup-layer-container">
                        <div class="sub-title-div">
                            <img src="../Images/Member/mPop-title2.jpg" alt="변경이유" />
                        </div>
                        <div class="divpopup-layer-conts">
                            <div>
                                <table id="divCalendar">

                                    <tr>
                                        <th>
                                            <label>조회기간</label>
                                        </th>
                                        <td>
                                            <input type="text" id="txtSearchSdate" class="calendar1" readonly="readonly" onkeypress="return fnEnter();" />
                                            -
                                <input type="text" id="txtSearchEdate" class="calendar1" readonly="readonly" onkeypress="return fnEnter();" />
                                            <input type="checkbox" id="ckbSearch1" value="7" checked="checked" /><label for="ckbSearch2">7일</label>
                                            <input type="checkbox" id="ckbSearch2" value="15" /><label for="ckbSearch3">15일</label>
                                            <input type="checkbox" id="ckbSearch3" value="30" /><label for="ckbSearch4">30일</label>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th>
                                            <label>변경자명</label></th>
                                        <td>
                                            <input type="text" onkeypress="return fnEnter_Popup();" id="txtName" style="width: 250px; height: 25px; border: 1px solid #a2a2a2" />
                                            <a onclick="return fnSearch2(1)">
                                                <img src="../../AdminSub/Images/Goods/search-bt-off.jpg" alt="검색" /></a>
                                        </td>
                                    </tr>

                                </table>






                            </div>


                        </div>

                        <table id="tblSearch" style="width: 100%; margin-top: 20px" class="board-table">
                            <colgroup>
                                <col style="width: 30px" />
                                <col style="width: 100px" />
                                <col style="width: 100px" />
                                <col style="width: 200px" />
                            </colgroup>
                            <thead>
                                <tr>
                                    <th class="txt-center">순번</th>
                                    <th class="txt-center">변경자</th>
                                    <th class="txt-center">변경날짜</th>
                                    <th class="txt-center">변경사유</th>
                                </tr>
                            </thead>
                            <tbody></tbody>
                        </table>
                        <br />

                        <!--페이징-->
                        <input type="hidden" id="hdTotalCount_Popup" />
                        <div style="margin: 0 auto; text-align: center">
                            <div id="pagination_Popup" class="page_curl" style="display: inline-block"></div>
                        </div>


                        <div style="text-align: right">
                            <a onclick="return fnCancel2()" id="btnOk">
                                <img src="../../Images/Goods/sub-off.jpg" alt="확인" onmouseover="this.src='../../Images/Goods/sub-on.jpg'" onmouseout="this.src='../../Images/Goods/sub-off.jpg'" /></a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

</asp:Content>

