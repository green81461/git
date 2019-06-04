<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Master/AdminMasterPage.master" AutoEventWireup="true" CodeFile="CompanyLinkSeqUpdate.aspx.cs" Inherits="Admin_Company_CompanyLinkSeqUpdate" %>

<%@ Register Src="~/UserControl/ucListControl.ascx" TagName="ListPager" TagPrefix="ucPager" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <link href="../Content/Member/member.css" rel="stylesheet" />
    <script type="text/javascript">

        $(function () {

            // 팝업창에서 클릭시 변경 이벤트
            $("#companyLinkPopup_Tbody").on("mouseover", "tr", function () {
                $("#companyLinkPopup_Tbody tr").css("cursor", "pointer");
            });

            $("#companyLinkPopup_Tbody").on("click", "tr", function () {

                //초기화
                $("#hdSelectCode").val('');
                $("#hdSelectName").val('');
                $("#companyLinkPopup_Tbody tr").css("background-color", "");

                $(this).css("background-color", "#ffe6cc");

                var selectCode = $(this).find("#Comp_Code").text();
                var selectName = $(this).find("#Comp_Name").text();
                $("#hdSelectCode").val(selectCode);
                $("#hdSelectName").val(selectName);

            });

            // 검색창에서 검색 후 엔터키 클릭시 이벤트
            $('#txtSearchLinkName').on({
                keydown: function (e) {
                    if (e.keyCode == 13) {
                        fnCompanyLinkGubunListPopUp(1);
                        return false;
                    }
                    else
                        return true;
                }
            });


            $("#btnCorpCode").on("click", function () {
                fnCompanyLinkGubunListPopUp(1);
                fnOpenDivLayerPopup('corpCodeAdiv');
            });

            $("#btnPopUserSearch").on("click", function () {

                var SCLKCode = $("#hdPopSCLKCode").val();
                fnUserList(1, SCLKCode);

            });

            $("#aPopClose").on("click", function () {
                $('#hdCopyCodes').val('');
            });
        });

        $(document).on("click", ".btnUserPopOpen", function () {
            $("#hdPopSCLKCode").val('');
            $("#hdPopSUCode").val('');
            $("#hdPopBUCode").val('');
            $('#hdCopyCodes').val('');
            fnOpenDivLayerPopup('searchUserDiv');
            var el = $(this);
            var SCLKCode = el.parent().next().find('#selectCode').val(); //회사연동코드 가져오기 부모의 다음형제요소에 자식
            var SUCode = el.parent().find('#hdSUCode').val();
            var BUCode = el.parent().find('#hdBUCode').val();
            $("#hdPopSCLKCode").val(SCLKCode);
            $("#hdPopSUCode").val(SUCode);
            $("#hdPopBUCode").val(BUCode);

        });


        //관계사 연동관리 고정판매사 변경 유저관리 
        function fnUserList(pageNo, SCLKcode) {
            $("#tblPopupComp").empty();
            var gubun = $("#hdBUCode").val();
            var pageSize = 10;
            var callback = function (response) {
                var asynTable = '';
                if (!isEmpty(response)) {

                    $.each(response, function (index, value) {
                        $("#txtSCLKCount").text("현재 설정된 유저는 " + value.SocialCompanyUserCount + "명 입니다.");
                        $("#txtSCLKCount1").text("지정 가능한 유저 수 " + (5 - value.SocialCompanyUserCount) + "명");

                        if (index == 0) $('#hdUserTotalCount').val(value.TotalCount);
                        asynTable += "<tr>";
                        asynTable += "<td class='txt-center'><input type='hidden' id='hdCopyCode' value='" + value.Svid_User + "'/>"

                        if (value.SettingCompName != "") {
                            asynTable += "<input type = 'checkbox' id = 'cbSelectCopy' disabled /></td > ";

                        } else {

                            asynTable += "<input type='checkbox' id='cbSelectCopy' onclick='return fnCbArrayPush(this);' /></td> ";
                        }
                        asynTable += "<input type='hidden' id='hdUserCountY' value='" + value.SocialCompanyUserCount + "' /><input type='hidden' id='hdUserCountN' value='" + (5 - value.SocialCompanyUserCount) + "' />";
                        asynTable += "<td class='txt-center'>" + value.Company_Name + "</td>";
                        asynTable += "<td class='txt-center'>" + value.Id + "</td>";
                        asynTable += "<td class='txt-center'>" + value.Name + "</td>";
                        asynTable += "<td class='txt-center'>" + value.SettingCompName + "</td>";
                        asynTable += "</tr>";

                    });

                } else {
                    $('#hdUserTotalCount').val(0);
                    asynTable += "<tr><td colspan='5' class='text-center'>" + "검색결과가 없습니다." + "</td></tr>";
                }
                $("#tblPopupComp").empty().append(asynTable);
                $('#tblPopupComp tr').each(function () {
                    var el = this;
                    var currentCopyCode = $(el).children().find('#hdCopyCode').val();
                    var codeArray = $('#hdCopyCodes').val().slice(1).split('/');
                    $.each(codeArray, function (index, value) {
                        if (value == currentCopyCode) {
                            $(el).children().find('#cbSelectCopy').prop("checked", true);
                        } else {
                            $(el).children().find('#cbSelectCopy').prop("checked", false);
                        }
                    });
                });


                fnCreatePagination('userPagination', $("#hdUserTotalCount").val(), pageNo, pageSize, getUserPageData);
                return false;

            };

            var param = {
                Gubun: gubun,
                SocialCompanyLinkCode: SCLKcode,
                SearchKeyword: $("#txtPopUserSearch").val(),
                PageNo: pageNo,
                PageSize: pageSize,
                Method: "GetUserListByGubun",
            }

            var beforeSend = function () {
                $('#divLoading').css('display', '');

            }
            var complete = function () {
                $('#divLoading').css('display', 'none');

            }

            JqueryAjax("Post", "../../Handler/Common/UserHandler.ashx", false, false, param, "json", callback, beforeSend, complete, true, '<%=Svid_User %>');

        }

        //유저관리
        function getUserPageData() {
            var container = $('#userPagination');
            var getPageNum = container.pagination('getSelectedPageNum');
            var hdSCLKCode = $("#hdPopSCLKCode").val();
            fnUserList(getPageNum, hdSCLKCode);
            return false;
        }


        function fnCbArrayPush(el) { //체크박스 클릭시 

            var copyCode = $(el).parent().find('#hdCopyCode').val();
            if ($(el).is(':checked')) { //체크가 되어있으면 
                $('#hdCopyCodes').val(function (i, v) { //안에 값을 / 넣고 
                    var arr = v.split('/');
                    arr.push(copyCode);
                    return arr.join('/');
                });
            }
            else { //체크가 안되어 있으면 
                $('#hdCopyCodes').val(function (i, v) {
                    return $.grep(v.split('/'), function (v) {
                        return v != copyCode;
                    }).join('/');
                });
            }
            var userNum = $(el).parent().parent().find('#hdUserCountY').val();
            var checkNum = $("#hdCopyCodes").val().slice(1).split('/').length; //slice 1번째 글자 제외
            var count = 0;

            count = checkNum + parseInt(userNum);

            if (count > 5) { //카운트가 5보다 크면
                if ($(el).is(':checked') == true) { // 체크가 되어있는지 검사 해서 되어있을때

                    $('#hdCopyCodes').val(function (i, v) {
                        return $.grep(v.split('/'), function (v) {
                            return v != copyCode;
                        }).join('/');
                    });
                    alert('5명 이상 선택할 수 없습니다.');
                    return false;
                }
            }
        }

        //검색 엔터
        function fnPopupEnter() {
            if (event.keyCode == 13) {
                var hdSCLKCode = $("#hdPopSCLKCode").val();
                fnUserList(1, hdSCLKCode);
                return false;
            }
            else
                return true;
        }

        //팝업에서 고정유저 설정
        function fnConfirm() {

            if ($('#hdCopyCodes').val() == '') {

                alert('연동할 사용자를 선택해 주세요.');
                return false;
            }

            var jsonMenu = [];
            var socialCompanyLinkCode = $("#hdPopSCLKCode").val();
            var saleGubunCode = $("#hdPopSUCode").val();
            var buyGubunCode = $("#hdPopBUCode").val();

            $.each($("#hdCopyCodes").val().slice(1).split('/'), function (index, value) {

                jsonMenu.push({
                    SocialCompanyLinkCode: socialCompanyLinkCode,
                    SvidUser: value,
                    SaleGubunCode: saleGubunCode,
                    BuyGubunCode: buyGubunCode,

                });

            });

            var callback = function (response) {

                if (response == 'OK') {
                    alert('저장되었습니다.');
                    $("#hdCopyCodes").val('');
                    fnClosePopup('searchUserDiv');
                    fnCompanyLinkListSet();

                }
                else {
                    alert('구성중 오류가 생겼습니다. 시스템 관리자에게 문의하세요.');

                }
                return false;
            };

            $.ajax({
                type: "POST",
                url: '../../Handler/Admin/SocialCompanyHandler.ashx',
                async: false,
                contentType: false,
                processData: false,
                success: callback,
                data: function () {
                    var data = new FormData();
                    data.append("MenuData", JSON.stringify(jsonMenu));
                    data.append("Method", 'SocialCompanyUserLink_Insert');

                    return data;
                }(),
            });
        }







        // 팝업 열기
        function fnCompanyLinkGubunListPopUp(pageNum) {
            var asynTable = '';
            var pageSize = 10;
            var selSearchTarget = $('#selectSearchTarget').val();
            var keyword = $('#txtSearchLinkName').val();
            var gubun = 'BU';

            var callback = function (response) {

                if (!isEmpty(response)) {

                    $.each(response, function (index, value) {

                        asynTable += "<tr>";
                        asynTable += "<td id='Comp_Code' class='txt-center'>" + value.SocialCompany_Code + "</td>";
                        asynTable += "<td id='Comp_Name' class='txt-center'>" + value.SocialCompany_Name + "</td></tr>";
                        $('#hdTotalCount').val(value.TotalCount);
                    });
                } else {
                    asynTable += "<tr><td colspan='2' class='text-center'>" + "검색결과가 없습니다." + "</td></tr>";
                    $('#hdTotalCount').val(0);
                }
                $('#tbSocialCompanyList tbody').empty().append(asynTable);

                // 페이징 만들어주는 함수
                fnCreatePagination('pagination', $("#hdTotalCount").val(), pageNum, pageSize, getPageData);


            };

            var param = {
                SearchTarget: selSearchTarget,
                SearchKeyword: keyword.trim(),
                Gubun: gubun,
                PageNo: pageNum,
                PageSize: pageSize,
                Method: "GetSocialCompanyLinkGubunList"
            };

            var beforeSend = function () {
                $('#divLoading').css('display', '');
            }
            var complete = function () {
                $('#divLoading').css('display', 'none');
            }

            JqueryAjax("Post", "../../Handler/Admin/SocialCompanyHandler.ashx", false, false, param, "json", callback, beforeSend, complete, true, '<%=Svid_User %>');
        }




        // 코드로 검색하는지 이름으로 검색하는지 구분
        function fnSelectedTarget() {
            var searchTarget = $('#selectSearchTarget').val();

            if (searchTarget == 'CODE') {
                return $('#hdSelectCode').val();
            } else {
                return $('#hdSelectName').val();
            }
        }



        // 리스트 조회
        function fnCompanyLinkListSet() {
            var asynTable = "";
            var selSearchTarget = $('#selectSearchTarget').val();
            var rowCnt = 0;
            var callback = function (response) {

                if (!isEmpty(response)) {

                    $.each(response, function (index, value) {

                        asynTable += "<tr>";
                        asynTable += "<td class='txt-center' rowspan='2' id='tableIndex'>" + (index + 1) + "</td>";
                        asynTable += "<td class='txt-center' rowspan='2'>" + value.SocialCompanyLink_Code + "</td>";
                        asynTable += "<td class='txt-center' rowspan='2'>" + value.SocialCompanyLink_Name + "</td>";
                        asynTable += "<td class='txt-center'>" + value.SaleSocialCompanyName + "</td>";
                        asynTable += "<td class='txt-center'>" + value.BuySocialCompanyName + "</td>";
                        asynTable += "<td class='txt-center' rowspan='2'>" + value.SocialCompanyLinkSeq + "</td>";
                        asynTable += "<td class='txt-center' rowspan='2'>" + fnGetCurrentSeqFlag(value.CurrentSeqFlag, value.SocialCompanyLink_Code, value.SocialCompanyLinkSeq) + "</td>"; // 설정여부 추가
                        asynTable += "<td class='txt-center' rowspan='2'>" + value.Remark + "</td>";
                        asynTable += "<td class='txt-center' rowspan='2'>" + fnOracleDateFormatConverter(value.EntryDate) + "</td>"
                        asynTable += "<td class='txt-center' rowspan='2'>"
                        if (value.SocialCompanyUserCount != 0) {
                            asynTable += "<input type='button' value='보기' class='btnDelete' onclick='fnuserLinkViewPopUp(\"" + value.SocialCompanyLink_Code + "\")'// />" // 유저관리 보기
                        }
                        if (value.UseUserManagementCount != 0) {
                            asynTable += "<input type='button' value='설정' class='btnDelete btnUserPopOpen' onclick='fnUserList(1,\"" + value.SocialCompanyLink_Code + "\"); return false;' style='margin-left: 5px;' />" // 유저관리 설정
                        }
                        asynTable += "<input type='hidden' id='hdSUCode' value='" + value.SaleSocialCompany_Code + "' /><input type='hidden' id='hdBUCode' value='" + value.BuySocialCompany_Code + "' /></td>"
                        asynTable += "<td rowspan='2' id='selectLink' class='txt-center'><input type='hidden' id='selectCode' value='" + value.SocialCompanyLink_Code + "' />";
                        asynTable += "<input type='hidden' id='selectSeq' value='" + value.SocialCompanyLinkSeq + "' />" + fnGetSelectedComp(value.CurrentSeqFlag); // 설정버튼
                        asynTable += "<input type='hidden' value='" + value.SocialCompanyLink_Code + "' /></td >";
                        asynTable += "</tr><tr>"

                        //------------------------------------------------------------------------------

                        asynTable += "<td class='txt-center'>" + value.SaleSocialCompany_Code + "</td>";
                        asynTable += "<td class='txt-center'>";
                        asynTable += "<p class='btnBuyCompCode'>" + value.BuySocialCompany_Code + "</p>";
                        // asynTable += "<input type='hidden' id='hfBuySocialCompCode' value='" + value.BuySocialCompany_Code + "' />";
                        asynTable += "</td > ";
                        asynTable += "</tr>";
                        rowCnt = index + 1;

                    });

                } else {
                    asynTable += "<tr><td colspan='11' class='text-center'>" + "리스트가 없습니다." + "</td></tr>";
                }

                $(".tblCompanyLinkList tbody").empty().append(asynTable);
                if (rowCnt == 1) {
                    $('.btnDelete').css('display', 'none');
                }
            }

            var param = {
                SearchTarget: selSearchTarget,
                SearchKeyword: fnSelectedTarget(),
                Method: "GetSocialCompanyLinkNoPagingList"
            };

            var beforeSend = function () {
                is_sending = true;
            }
            var complete = function () {
                is_sending = false;
            }

            JqueryAjax("Post", "../../Handler/Admin/SocialCompanyHandler.ashx", true, false, param, "json", callback, beforeSend, complete, true, '<%=Svid_User %>');
        }

        // 설정되어있을시에 이미지 표시
        function fnGetCurrentSeqFlag(currentSeqFlag, code, seq) {
            if (currentSeqFlag == 'Y') {
                return '<input type="hidden" id="currentCode" value="' + code + '" /><input type="hidden" id="currentSeq" value="' + seq + '" /><img src="../../Images/Company_Selected.png" />';
            } else {
                return '';
            }
        }

        // 설정되어있지 않을시에 설정버튼 표시
        function fnGetSelectedComp(currentSeqFlag) {
            if (currentSeqFlag == 'Y') {
                return '';
            } else {
                return "<input type='button' id='deleteLink' class='btnDelete' value='설정' onclick='fnSelectedChange(this);' />";
            }
        }

        // 페이징처리함수
        function getPageData() {
            var container = $('#pagination');
            var getPageNum = container.pagination('getSelectedPageNum');
            fnCompanyLinkGubunListPopUp(getPageNum);
            return false;
        }

        //팝업창 확인버튼
        function fnPopupOk() {
            var selectCode = $("#hdSelectCode").val();
            var selectName = $("#hdSelectName").val();
            var selSearchTarget = $('#selectSearchTarget').val();

            if (selSearchTarget == 'CODE' && selectCode == '' || selSearchTarget == 'NAME' && selectName == '') {
                alert('회사를 선택해주세요.');
                return false;
            } else {
                fnCompanyLinkListSet(1);
                fnClosePopup('corpCodeAdiv');
                return false;
            }
        }

        // 설정버튼 온클릭 이벤트
        function fnSelectedChange(el) {
            var selectCode = $(el).siblings().eq(0).val();
            var selectSeq = $(el).siblings().eq(1).val();
            var currentSaleCode = $('#currentCode').val();
            var currentSaleSeq = $('#currentSeq').val();

            var callback = function (response) {

                if (!isEmpty(response)) {
                    fnCompanyLinkListSet();
                }
            }

            var param = {
                SelectCode: selectCode,
                SelectSeq: selectSeq,
                CurrentSaleCode: currentSaleCode,
                CurrentSaleSeq: currentSaleSeq,
                Method: "UpdateSocialCompanySeq"
            };

            var beforeSend = function () {
                is_sending = true;
            }
            var complete = function () {
                is_sending = false;
            }

            JqueryAjax("Post", "../../Handler/Admin/SocialCompanyHandler.ashx", false, false, param, "json", callback, beforeSend, complete, true, '<%=Svid_User %>');
        }

        // 유저관리 - 보기 팝업 열기
        function fnuserLinkViewPopUp(linkCode) {
            var asynTable = '';

            var callback = function (response) {
                if (!isEmpty(response)) {

                    $.each(response, function (index, value) {
                        asynTable += "<tr>";
                        asynTable += "<td id='Company_Name' class='txt-center'>" + value.Company_Name + "</td>";
                        asynTable += "<td id='Id' class='txt-center'>" + value.Id + "</td>";
                        asynTable += "<td id='Name' class='txt-center'>" + value.Name + "</td>";
                        asynTable += "<td id='DelBtn' class='txt-center'><input type='button' value='삭제' class='btnDelete'onclick='fnDeleteUserLink(\"" + value.UnumSocialCompanyUserLink + "\",\"" + linkCode + "\")'//></td></tr>";
                    });
                } else {
                    asynTable += "<tr><td colspan='4' class='text-center'>" + "검색결과가 없습니다." + "</td></tr>";
                }
                $('#tblUserLinkView tbody').empty().append(asynTable);
                fnOpenDivLayerPopup('userLinkViewDiv');
            };

            var param = {
                SocialCompanyLink_Code: linkCode,
                Method: "GetSocialCompanyUserLinkList"
            };

            JqueryAjax("Post", "../../Handler/Common/UserHandler.ashx", false, false, param, "json", callback, null, null, true, '<%=Svid_User %>');
        }

        // 유저관리 목록에서 삭제
        function fnDeleteUserLink(unumSocialCompanyUserLink, linkCode) {
            if (confirm("정말 삭제하시겠습니까?")) {
                var callback = function (response) {
                    if (response == 'OK') {
                        document.getElementById('userLinkViewDiv').style.removeProperty("display")

                        fnuserLinkViewPopUp(linkCode);
                    }
                    else {
                        alert('시스템 오류입니다. 개발팀에 문의하세요.');
                    }
                }
                var param = {
                    P_UnumSocialCompanyUserLink: unumSocialCompanyUserLink,
                    Method: "DeleteSocialCompanyUserLink"
                };
                JqueryAjax("Post", "../../Handler/Common/UserHandler.ashx", false, false, param, "text", callback, null, null, true, '<%=Svid_User %>');
            }
        }

    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <p class="p-title-mainsentence">관계사 연동관리</p>
    <ul class="listStyle0">
        <li><a href="#none" class="mainbtn type1" onclick="fnGoPage('PG'); return false;">PG 관리</a></li>
        <li><a href="#none" class="mainbtn type1" onclick="fnGoPage('OBM'); return false;">주문 연동 관리</a></li>
        <li><a href="#none" class="mainbtn type1" onclick="fnGoPage('LOAN'); return false;">여신 관리</a></li>
    </ul>

    <!-- S. 탭메뉴-->
    <div class="div-main-tab">
        <ul>
            <li class='tabOff' onclick="fnTabClickRedirect('CompanyLinkList');">
                <a onclick="fnTabClickRedirect('CompanyLinkList');">관계사 연동 조회</a>
            </li>
            <li class='tabOff' onclick="fnTabClickRedirect('CompanyLinkRegist');">
                <a onclick="fnTabClickRedirect('CompanyLinkRegist');">관계사 연동 등록</a>
            </li>
            <li class='tabOn' onclick="fnTabClickRedirect('CompanyLinkSeqUpdate');">
                <a onclick="fnTabClickRedirect('CompanyLinkSeqUpdate');">관계사 고정 판매사 변경</a>
            </li>
        </ul>
    </div>
    <!-- E. 탭메뉴 -->

    <!-- S. 관계사 연동 조회 -->
    <div class="bottom-search-div">
        <table class="tbl_search">
            <tr>
                <td style="90px"></td>
                <td style="width: 200px; text-align: right;">
                    <select id="selectSearchTarget">
                        <option value="NAME">구매사 회사구분명</option>
                        <option value="CODE">구매사 회사구분코드</option>
                    </select>
                </td>
                <td>
                    <input type="text" style="width: 65%" id="txtSearchLinkName" placeholder="구매사 회사구분으로 검색" />
                    <input type="button" class="mainbtn type1" style="width: 65px; text-align: center;" id="btnCorpCode" value="검색" />
                </td>
            </tr>
        </table>

        <table class="tbl_main tblCompanyLinkList interlockList" style="margin-top: 40px;">
            <colgroup>
                <col width="3%" />
                <!-- 번호 -->
                <col width="7%" />
                <!-- 회사연동코드 -->
                <col width="15%" />
                <!-- 회사연동명 -->
                <col width="17%" />
                <!-- 판매사회사구분 -->
                <col width="13%" />
                <!-- 구매사회사구분 -->
                <col width="5%" />
                <!-- 관계사연동순번 -->
                <col width="5%" />
                <!--현재 판매사 여부 -->
                <col width="17%" />
                <!-- 비고 -->
                <col width="6%" />
                <!-- 등록날짜 -->
                <col width="7%" />
                <!-- 보기/설정버튼 -->
                <col width="5%" />
                <!-- 삭제버튼 -->
            </colgroup>
            <thead>
                <tr>
                    <th rowspan="2">번호</th>
                    <th rowspan="2">회사연동코드</th>
                    <th rowspan="2">회사연동명</th>
                    <th>판매사 회사구분명</th>
                    <th>구매사 회사구분명</th>
                    <th rowspan="2">관계사<br />
                        연동 순번</th>
                    <th rowspan="2">현재 판매사<br />
                        여부</th>
                    <th rowspan="2">비고</th>
                    <th rowspan="2">등록날짜</th>
                    <th rowspan="2">유저관리</th>
                    <th rowspan="2">설정</th>
                </tr>
                <tr>
                    <th>판매사 회사구분코드</th>
                    <th>구매사 회사구분코드</th>
                </tr>
            </thead>
            <tbody>
                <tr>
                    <td colspan="11" class="text-center">리스트가 없습니다.</td>
                </tr>
            </tbody>
        </table>
    </div>
    <!-- E. 관계사 연동 조회 -->

    <%-- 유저관리 팝업  --%>
    <div id="searchUserDiv" class="popupdiv divpopup-layer-package">
        <div class="popupdivWrapper" style="width: 650px; height: 730px">
            <div class="popupdivContents">
                <input type="hidden" id="hdCopyCodes">
                <div class="close-div">
                    <a id="aPopClose" onclick="fnClosePopup('searchUserDiv'); return false;" style="cursor: pointer">
                        <img src="../../Images/Wish/icon-delete.jpg" alt="닫기" style="float: right;" /></a>
                </div>
                <div class="popup-title" style="margin-top: 20px;">
                    <h3 class="pop-title">유저검색</h3>
                </div>


                <div class="search-div" style="margin-bottom: 20px;">

                    <input type="text" class="" id="txtPopUserSearch" placeholder="회사명, ID, 이름중에 하나를 입력하세요" onkeypress="return fnPopupEnter();" style="width: 300px; height: 26px" />
                    <input type="button" id="btnPopUserSearch" class="mainbtn type1" style="width: 75px; height: 25px; font-size: 12px" value="검색" />
                    <div id="txtSCLKCount" style="font-weight: bold; color: #ec2029;"></div>
                    <div id="txtSCLKCount1" style="font-weight: bold; color: #ec2029;"></div>
                </div>


                <div class="divpopup-layer-conts">

                    <input type='hidden' id='hdPopSCLKCode' /><input type='hidden' id='hdPopBUCode' /><input type='hidden' id='hdPopSUCode' />
                    <table class="tbl_main tbl_popup" style="margin-top: 0; width: 100%">

                        <thead>
                            <tr>
                                <th class="text-center" style="width: 34px">선택</th>
                                <th class="text-center">회사명</th>
                                <th class="text-center">ID</th>
                                <th class="text-center">이름</th>
                                <th class="text-center" style="width: 212px">현재상태</th>
                            </tr>
                        </thead>
                        <tbody id="tblPopupComp">
                        </tbody>
                    </table>
                    <br />
                    <!-- 페이징 처리 -->
                    <div style="margin: 0 auto; text-align: center; padding-top: 10px">
                        <input type="hidden" id="hdUserTotalCount" />
                        <div id="userPagination" class="page_curl" style="display: inline-block"></div>
                    </div>
                </div>

                <div style="text-align: right; margin-top: 10px;">
                    <input type="button" class="mainbtn type1" style="width: 95px; height: 30px; font-size: 12px" value="확인" onclick="fnConfirm(); return false;" />
                </div>

            </div>
        </div>
    </div>
    <%-- 팝업끝 --%>


    <%--구매사 회사구분코드 팝업--%>
    <div id="corpCodeAdiv" class="popupdiv divpopup-layer-package">
        <div class="popupdivWrapper" style="width: 700px;">
            <div class="popupdivContents">
                <div class="close-div">
                    <a onclick="fnClosePopup('corpCodeAdiv');" style="cursor: pointer">
                        <img src="../../Images/Wish/icon-delete.jpg" alt="닫기" style="float: right;" /></a>
                </div>
                <div class="popup-title">
                    <h3 class="pop-title">회사구분코드</h3>
                </div>
                <div class="divpopup-layer-conts" style="overflow-y: hidden">
                    <input type="hidden" id="hdSelectCode" />
                    <input type="hidden" id="hdSelectName" />
                    <table id="tbSocialCompanyList" class="tbl_main tbl_popup">
                        <thead>
                            <tr>
                                <th>구분코드</th>
                                <th>구분명</th>
                            </tr>
                        </thead>
                        <tbody id="companyLinkPopup_Tbody">
                            <tr>
                                <td colspan="2" class="text-center">리스트가 없습니다.</td>
                            </tr>
                        </tbody>
                    </table>
                    <%--페이징처리--%>
                    <div style="margin: 20px auto; text-align: center">
                        <input type="hidden" id="hdTotalCount" />
                        <div id="pagination" class="page_curl" style="display: inline-block"></div>
                    </div>
                </div>
                <div class="btn_center">
                    <input type="button" id="btnOk" class="mainbtn type1" style="width: 95px; height: 30px;" value="확인" onclick="return fnPopupOk();" />
                </div>
            </div>
        </div>
    </div>

    <!-- 유저관리 - 보기 -->
    <div id="userLinkViewDiv" class="popupdiv divpopup-layer-package">
        <div class="popupdivWrapper" style="width: 35%">
            <div class="popupdivContents" style="">
                <div class="close-div">
                    <a onclick="fnClosePopup('userLinkViewDiv');fnCompanyLinkListSet();" style="cursor: pointer">
                        <img src="../../Images/Wish/icon-delete.jpg" alt="닫기" style="float: right;" />
                    </a>
                </div>
                <div class="sub-title-div">
                    <h3 class="pop-title">유저관리 보기</h3>
                </div>

                <div class="tblOrder-div">
                    <div style="height: 300px; overflow-y: auto;">
                        <table id="tblUserLinkView" class="tbl_main tbl_pop">
                            <thead>
                                <tr>
                                    <th style="width: 40%;">회사명</th>
                                    <th style="width: 20%;">ID</th>
                                    <th style="width: 20%;">사용자명</th>
                                    <th style="width: 20%;">삭제</th>
                                </tr>
                            </thead>
                            <tbody id="tbody_pop_odrDtl"></tbody>
                        </table>
                    </div>
                </div>
                <div id="divDtlPop_1">
                    <table id="tbl_dtlPop_pay" class="tbl_main tbl_pop"></table>
                </div>

                <input type="button" class="mainbtn type1" style="width: 75px; float: right;" value="확인" onclick="fnClosePopup('userLinkViewDiv'); fnCompanyLinkListSet()" />
            </div>
        </div>
    </div>
</asp:Content>

