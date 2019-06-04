<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Master/AdminMasterPage.master" AutoEventWireup="true" CodeFile="MemberMain_B.aspx.cs" Inherits="Admin_Member_MemberMain_B" %>

<%@ Register Src="~/UserControl/ucListControl.ascx" TagName="ListPager" TagPrefix="ucPager" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <link href="../Content/Member/member.css" rel="stylesheet" />
    <link href="../Content/Company/company.css" rel="stylesheet" />
    <link href="../Content/Goods/goods.css" rel="stylesheet" />
   <script src="../../Scripts/jquery.fileDownload.js"></script>
    <script>
        $(document).ready(function () {

            fnMemberListBind(1); //회원목록 조회
            fnViewSetting(); //상세 팝업 화면 구성

            // enter key 방지
            $(document).on("keypress", "#tblSearch input", function (e) {
                if (e.keyCode == 13) {
                    fnMemberListBind(1);
                    return false;
                }
                else
                    return true;
            });

            //체크박스 전체 선택 관련 기능
            $("#ckbListAll").change(function () {
                if ($("#ckbListAll").is(":checked")) { //체크박스 선택
                    $('#tbodyMemberList input[type="checkbox"]').each(function () {
                        $(this).prop("checked", true);
                    });
                } else {
                    $('#tbodyMemberList input[type="checkbox"]').each(function () {
                        $(this).prop("checked", false);
                    });
                }
            });

            $("#tbodyMemberList").on("mouseenter", "tr", function () {

                $(this).find("td").css("background-color", "gainsboro");
                $(this).find("td").css("cursor", "pointer");
                var rowIdx = this.rowIndex;
                if ((rowIdx % 2) == 0) {
                    $(this).next().css("background-color", "gainsboro");

                } else {
                    $(this).prev().css("background-color", "gainsboro");
                }
                $(this).next().css("cursor", "pointer");
                $(this).prev().css("cursor", "pointer");
            });
            $("#tbodyMemberList").on("mouseleave", "tr", function () {

                $(this).find("td").css("background-color", "");

                var rowIdx = this.rowIndex;
                if ((rowIdx % 2) == 0) {
                    $(this).next().css("background-color", "");
                } else {
                    $(this).prev().css("background-color", "");
                }
            });

        });

        //상세 팝업 화면 구성
        function fnViewSetting() {

            $("#ckbSearch1").prop("checked", true);
            $("#ckbSearch2").prop("checked", false);
            $("#ckbSearch3").prop("checked", false);
            $("#txtPopDropNameSearch").val('');

            var date = new Date();
            var dayOfMonth = date.getDate();
            date.setDate(dayOfMonth - 7)

            var tableid = "tblPopModiListSearch";
            ListCheckboxOnlyOne(tableid);

            var tableid_2 = "divCodeApply";
            ListCheckboxOnlyOne(tableid_2);

            //상품검색창에서 달력 관련 기능
            $("#searchStartDate").val(date.yyyymmdd())
            $("#searchStartDate").datepicker({
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
            })

            $("#searchEndDate").val((new Date()).yyyymmdd())
            $("#searchEndDate").datepicker({
                showAnimation: 'slideDown',
                changeMonth: true,
                changeYear: true,
                showOn: 'button',
                buttonImage: /*"/Images/icon_calandar.png"*/"../../Images/Goods/calendar.jpg",
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
            })

            //검색창 날짜범위 선택 부분..
            $('#tblPopModiListSearch input[type="checkbox"]').change(function () {
                if ($(this).prop('checked') == true) {
                    var num = $(this).val();
                    var newDate = new Date($("#searchEndDate").val());
                    var resultDate = new Date();
                    resultDate.setDate(newDate.getDate() - num);
                    $("#searchStartDate").val($.datepicker.formatDate("yy-mm-dd", resultDate));
                }
            });
        }

        //목록에서 행 클릭 시
        function fnSelectUserList(uId) {
            location.href = "MemberCorpInfo_B.aspx?uId=" + uId+ '&ucode=' + ucode;
        }

        //회원목록 조회
        function fnMemberListBind(pageNo) {

            var pageSize = 20;

            var callback = function (response) {
                //$("#tbodyMemberList")

                var asyncTable = "";
                var entryDate = '';
                var modiDate = '';

                if (!isEmpty(response)) {
                    $.each(response, function (key, value) {

                        if (!isEmpty(value.EntryDate)) entryDate = value.EntryDate.split("T")[0];
                        if (!isEmpty(value.DropDate)) modiDate = value.DropDate.split("T")[0];

                        //변경사유
                        var dropUserReaTagVal = '';
                        if (!isEmpty(value.DropUserReason)) {
                            var tmpVal = value.DropUserReason;
                            if (tmpVal.length > 6)
                                dropUserReaTagVal = value.DropUserReason + "<br />";
                        }

                        if (key == 0) $("#hdTotalCount").val(value.TotalCount);

                        asyncTable += "<tr >";
                        //  asyncTable += "<td rowspan='2' style='border:1px solid #a2a2a2;'><input type='checkbox' name='ckbTr' onclick='fnChangeCheck(this)' value='" + value.Svid_User + "' /></td>";
                        asyncTable += "<td rowspan='2' onclick='fnSelectUserList(\"" + value.Id + "\")'>" + value.RowNum + "</td>";
                        asyncTable += "<td onclick='fnSelectUserList(\"" + value.Id + "\")'>" + value.SocialCompanyCode + "</td>";
                        asyncTable += "<td onclick='fnSelectUserList(\"" + value.Id + "\")'>" + value.Id + "</td>";
                        asyncTable += "<td class='td-bgColor' onclick='fnSelectUserList(\"" + value.Id + "\")'>" + value.UserInfo.Company_Name + "</td>";

                        var areaCodeTag = '';
                        var areaCodeNmTag = '';
                        var areaCode = value.UserInfo.CompanyArea_Code + '';
                        if (areaCode != '0') {
                            areaCodeTag = areaCode;
                            areaCodeNmTag = '(' + value.UserInfo.CompanyArea_Name + ')';
                        }

                        asyncTable += "<td onclick='fnSelectUserList(\"" + value.Id + "\")'>" + areaCodeTag + "<br />" + areaCodeNmTag + "</td>"; //사업장코드

                        var deptCodeTag = '';
                        var deptCodeNmTag = '';
                        var deptCode = value.UserInfo.CompanyDept_Code + '';
                        if (!isEmpty(deptCode) && (deptCode != '0')) {
                            deptCodeTag = deptCode;
                            deptCodeNmTag = '(' + value.UserInfo.CompanyDept_Name + ')';
                        }

                        var domainTag = '';
                        var domainNmTag = '';
                        var roleTag = value.Svid_Role + '';
                        if (!isEmpty(roleTag) && (roleTag != '0')) {
                            domainTag = roleTag;
                            domainNmTag = '(' + value.UserInfo.EnterUrlDomain + ')';
                        }

                        asyncTable += "<td rowspan='2' onclick='fnSelectUserList(\"" + value.Id + "\")'>" + deptCodeTag + "<br />" + deptCodeNmTag + "</td>"; //부서코드
                        asyncTable += "<td rowspan='2' onclick='fnSelectUserList(\"" + value.Id + "\")'>" + value.ConfirmFlag_Name + "</td>";
                        asyncTable += "<td rowspan='2' onclick='fnSelectUserList(\"" + value.Id + "\")'>" + value.UserInfo.Delegate_Name + "</td>";
                        asyncTable += "<td class='td-bgColor' rowspan='2' onclick='fnSelectUserList(\"" + value.Id + "\")'>" + domainTag + "<br/>" + domainNmTag + "</td>"; //가입자주문유형
                        asyncTable += "<td onclick='fnSelectUserList(\"" + value.Id + "\")'>" + value.TelNo + "</td>";
                        asyncTable += "<td onclick='fnSelectUserList(\"" + value.Id + "\")'>" + value.FaxNo + "</td>";
                        asyncTable += "<td class='txt-center' onclick='fnSelectUserList(\"" + value.Id + "\")'>" + value.SmsYn_Name + "</td>";
                        asyncTable += "<td class='txt-center' onclick='fnSelectUserList(\"" + value.Id + "\")'>" + value.BannerYn_Name + "</td>";
                        asyncTable += "<td class='txt-center'>" + value.DelFlag_Name + "</td>";
                        asyncTable += "<td class='txt-center'>" + value.DropUserName + "</td>";
                        asyncTable += "<td onclick='fnSelectUserList(\"" + value.Id + "\")'>" + modiDate + "</td></tr>";
                        //-----------------------------------------------------------------다음행-----------------------------------------------------------------------------------------------------------//
                        asyncTable += "<tr>";
                        asyncTable += "<td onclick='fnSelectUserList(\"" + value.Id + "\")'>" + value.UserInfo.Company_Code + "</td>";
                        asyncTable += "<td onclick='fnSelectUserList(\"" + value.Id + "\")'>" + value.Name + "</td>";
                        
                        asyncTable += "<td class='td-bgColor' onclick='fnSelectUserList(\"" + value.Id + "\")'>" + value.UserInfo.Company_No + "</td>";

                        var businessCodeTag = '';
                        var businessCodeNmTag = '';
                        var businessCode = value.UserInfo.CompBusinessDept_Code + '';
                        if (!isEmpty(businessCode) && (businessCode != '0')) {
                            businessCodeTag = businessCode;
                            businessCodeNmTag = '(' + value.UserInfo.CompBusinessDept_Name + ')';
                        }

                        asyncTable += "<td onclick='fnSelectUserList(\"" + value.Id + "\")'>" + businessCodeTag + "<br />" + businessCodeNmTag + "</td>";
                        asyncTable += "<td onclick='fnSelectUserList(\"" + value.Id + "\")'>" + value.PhoneNo + "</td>";
                        asyncTable += "<td onclick='fnSelectUserList(\"" + value.Id + "\")'>" + value.Email + "</td>";
                        asyncTable += "<td class='txt-center' onclick='fnSelectUserList(\"" + value.Id + "\")'>" + value.EmailYn_Name + "</td>";
                         asyncTable += "<td class='txt-center'><a onclick='return fnLoginBuyComp(\"" + value.Svid_User + "\", \"" + value.Id + "\", \"" + value.UserInfo.EnterUrlDomain + "\")'><img src='../../Images/login_buyer.png' alt='로그인'  /></a></td>";
                        asyncTable += "<td class='txt-center'><a class='btnDelete' onclick='fnDropRegistSet(\"" + value.Svid_User + "\")'>설정</a></td>";
                        //asyncTable += "<td><span style='width:115px; display: block; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;'>" + dropUserReaTagVal + "</span><a class='imgA'><img src='../../Images/delivery/add1-on.jpg' onclick='fnUseDetailSet(\"" + value.Svid_User + "\")' onmouseover='this.src = \"../../Images/delivery/add1-off.jpg\"' onmouseout='this.src = \"../../Images/delivery/add1-on.jpg\"' alt='상세' class='' /></a></td>";//
                        asyncTable += "<td class='txt-center'><a class='btnDelete' onclick='fnUseDetailSet(\"" + value.Svid_User + "\")'>상세보기</a></td>";
                        asyncTable += "<td onclick='fnSelectUserList(\"" + value.Id + "\")'>" + entryDate + "</td></tr>";

                    });
                } else {
                    asyncTable += "<tr><td colspan='17' class='txt-center'>" + "조회된 회원정보가 없습니다." + "</td></tr>"
                    $("#hdTotalCount").val(0);
                }

                fnSetCountView(); // 카운트 설정

                $("#tbodyMemberList").empty().append(asyncTable);
                fnCreatePagination('pagination', $("#hdTotalCount").val(), pageNo, pageSize, getPageData);
            }

            var target1 = $("#sbSearchTarget_1").val();
            var target2 = $("#sbSearchTarget_2").val();
            var target3 = $("#sbSearchTarget_3").val();
            var target4 = $("#sbSearchTarget_4").val();
            var target5 = $("#sbSearchTarget_5").val();
            var keyword1 = $("#txtSearchKeyword_1").val();
            var keyword2 = $("#txtSearchKeyword_2").val();
            var keyword3 = $("#txtSearchKeyword_3").val();
            var keyword4 = $("#txtSearchKeyword_4").val();
            var keyword5 = $("#txtSearchKeyword_5").val();
            var confirmFlag = $("#sbSearchConfirmStat").val();
            var useFlag = $("#sbSearchUseFlag").val();

            var param = {
                Keyword1: keyword1,
                Keyword2: keyword2,
                Keyword3: keyword3,
                Keyword4: keyword4,
                Keyword5: keyword5,
                Target1: target1,
                Target2: target2,
                Target3: target3,
                Target4: target4,
                Target5: target5,
                ConfirmFlag: confirmFlag,
                UseFlag: useFlag,
                Type: 'BU',
                PageNo: pageNo,
                PageSize: pageSize,
                Method: 'GetAdminUserList'
            };

            var beforeSend = function () {
                $('#divLoading').css('display', '');
            }
            var complete = function () {
                $('#divLoading').css('display', 'none');
            }
            JqueryAjax("Post", "../../Handler/Common/UserHandler.ashx", true, false, param, "json", callback, beforeSend, complete, true, '<%=Svid_User %>');
        }

        function getPageData() {
            var container = $('#pagination');
            var getPageNum = container.pagination('getSelectedPageNum');
            fnMemberListBind(getPageNum);
            return false;
        }

        //체크박스 하나라도 체크지울경우 처리
        function fnChangeCheck(index) {
            if ($(index).is(":checked") == false) {
                $("#ckbListAll").prop("checked", false); //전체선택 박스 체크해제
            }
        }

        function fnLoginBuyComp(sviduser, id, domain) {

            if (isEmpty(sviduser) || isEmpty(id) || isEmpty(domain)) {
                alert('정보가 부족합니다.');
                return false;

            }
            
            var frmPop = document.getElementById('form1');
            var url = 'http://' + domain + '/Member/Login';
            var siteName = '<%= SiteName%>';
            if (siteName.indexOf('localhost') > -1) {
                url = '../../Member/Login';
            }
             window.open('','view');  
     
             frmPop.action = url;
             frmPop.target = 'view'; //window,open()의 두번째 인수와 같아야 하며 필수다.  
             frmPop.openNewWindowSvidUser.value = sviduser;
             frmPop.openNewWindowId.value = id;  
             frmPop.openNewWindowGubun.value = 'BU';  
             frmPop.method = "post";
             frmPop.submit();   

            
        }
        //목록에 대한 count
        function fnSetCountView() {

            $("#lblTotListCnt").text('');
            $("#lblApproYCnt").text('');
            $("#lblApproNCnt").text('');
            $("#lblDropACnt").text('');
            $("#lblDropYCnt").text('');

            var callback = function (response) {
                if (!isEmpty(response)) {
                    $("#lblTotListCnt").text(response.UserCount);
                    $("#lblApproYCnt").text(response.ConfirmYCount);
                    $("#lblApproNCnt").text(response.ConfirmNCount);
                    $("#lblDropACnt").text(response.DelYCount);
                    $("#lblDropYCnt").text(response.DelNCount);
                }

                return false;
            };

            var param = {
                Type: 'BU',
                Method: 'GetAdminUserStatus'
            };

            Jajax('Post', '../../Handler/Common/UserHandler.ashx', param, 'json', callback);
        }

        //목록에서 설정 버튼 클릭 시
        function fnDropRegistSet(userSeq) {
            $("#txtPopDropReason").val('');
            $("#sbPopUseFlag option:eq(0)").prop("selected", true);

            $("#hdSvidUser2").val(userSeq); //선택된 회원
            $("#tdPopupUser").text('<%=UserInfoObject.Name %>');

            //var e = document.getElementById("modifyDiv");

            //if (e.style.display == 'block') {
            //    e.style.display = 'none';

            //} else {
            //    e.style.display = 'block';
            //}

            fnOpenDivLayerPopup('modifyDiv');

        }

        //설정 팝업에서 저장 버튼 클릭 시
        function fnUserDropSave() {

            if (isEmpty($("#txtPopDropReason").val())) {
                alert("변경사유를 입력해 주세요.");
                return false;
            }

            var callback = function (response) {
                if (!isEmpty(response) && (response == "OK")) {
                    alert("사용유무 설정이 성공적으로 변경되었습니다.");

                } else {
                    alert("사용유무 설정 변경에 실패하였습니다. 잠시 후 다시 시도해 주세요.");
                }

                fnMemberListBind(1);
                fnClosePopup('');

                return false;
            };

            var param = {
                SvidUser: $("#hdSvidUser2").val(),
                DropSvidUser: '<%=Svid_User %>',
                Reason: $("#txtPopDropReason").val(),
                UseFlag: $("#sbPopUseFlag").val(),
                Method: 'UpdateUserUseStatus'
            };

            JajaxSessionCheck('Post', '../../Handler/Common/UserHandler.ashx', param, 'text', callback, '<%= Svid_User%>');
        }

        // 목록에서 상세 버튼 클릭 시
        function fnUseDetailSet(userSeq) {

            fnViewSetting(); //초기화

            $("#hdPopupSvidUser").val(userSeq);
            fnPopupDropListBind(1);

            //var e = document.getElementById('modifyReasonDiv');

            //if (e.style.display == 'block') {
            //    e.style.display = 'none';

            //} else {
            //    e.style.display = 'block';
            //}

            fnOpenDivLayerPopup('modifyReasonDiv');

        }

        //상세 팝업에서 변경사유 목록 바인딩
        function fnPopupDropListBind(pageNo) {
            $('#tblModifyList tbody').empty(); //테이블 클리어

            var pageSize = 10;

            var callback = function (response) {
                if (!isEmpty(response)) {
                    var newRowContent = '';

                    for (var i = 0; i < response.length; i++) {


                        $('#hdModifyTotalCount').val(response[i].TotalCount);
                        newRowContent += "<tr>";
                        newRowContent += "<td class='txt-center'>" + response[i].DropUserSeq + "";
                        newRowContent += "</td>";
                        newRowContent += "<td class='txt-center'>" + response[i].DropSvid_Name + "";
                        newRowContent += "</td>";
                        newRowContent += "<td class='txt-center'>" + response[i].EntryDate.split('T')[0] + "";
                        newRowContent += "</td>";
                        newRowContent += "<td class='txt-center'>" + response[i].DelFlag_Name + "</td>";
                        newRowContent += "<td>" + response[i].DropUserReason + "";
                        newRowContent += "</td>";
                        newRowContent += "</tr>";


                    }
                    $('#tblModifyList tbody').append(newRowContent);

                }
                else {
                    $("#hdModifyTotalCount").val(0);
                    $('#tblModifyList tbody').append('<tr><td colspan="5" class="txt-center">조회된 데이터가 없습니다.</td></tr>');
                }
                fnCreatePagination('popuppagination', $("#hdModifyTotalCount").val(), pageNo, pageSize, getPopupPageData);

                return false;
            }

            var param = {
                Keyword: $("#txtPopDropNameSearch").val(),
                Sdate: $("#searchStartDate").val(),
                Edate: $("#searchEndDate").val(),
                SvidUser: $("#hdPopupSvidUser").val(),
                PageNo: pageNo,
                PageSize: pageSize,
                Method: 'GetUserModifyHistoryList'
            };

            JajaxSessionCheck('Post', '../../Handler/Common/UserHandler.ashx', param, 'json', callback, '<%= Svid_User%>');
        }

        function getPopupPageData() {
            var container = $('#popuppagination');
            var getPageNum = container.pagination('getSelectedPageNum');
            fnPopupDropListBind(getPageNum);
            return false;
        }

        //상세 팝업 검색창 엔터 이벤트
        function fnPopupEnter() {
            if (event.keyCode == 13) {
                fnPopupDropListBind(1);
                return false;
            }
            else
                return true;
        }

        //팝업 닫기
        function fnClosePopup(type) {
            if (type == 'View') {
                $('#modifyReasonDiv').fadeOut();
            }
            else {
                $('#modifyDiv').fadeOut();
            }
        }

        function fnReset() {
            alert('검색조건을 초기화 합니다.')

            $('#txtSearchKeyword_1').val('');
            $('#txtSearchKeyword_2').val('');
            $('#txtSearchKeyword_3').val('');
            $('#txtSearchKeyword_4').val('');
            $('#txtSearchKeyword_5').val('');
            $('#sbSearchTarget_1').val('Id');
            $('#sbSearchTarget_2').val('Name');
            $('#sbSearchTarget_3').val('Name');
            $('#sbSearchTarget_4').val('Name');
            $('#sbSearchTarget_5').val('Name');

            $('#sbSearchConfirmStat').val('ALL');

            $('#sbSearchUseFlag').val('ALL');
        }

        function fnGoPage(pageVal) {
            switch (pageVal) {
                case "OHL":
                    window.location.href = "../Order/OrderHistoryList?ucode="+ucode;
                    break;
                case "DL":
                    window.location.href = "../Order/DeliveryOrderList?ucode="+ucode;
                    break;
                case "PG":
                    window.location.href = "../Member/Pg_Main?ucode="+ucode;
                    break;
                case "LOAN":
                    window.location.href = "../Member/Loan_Main?ucode="+ucode;
                    break;
                case "OBM":
                    window.location.href = "../Order/OrderBelongMain?ucode="+ucode;
                    break;
                case "CLM":
                    window.location.href = "../Company/CompanyLinkManagement?ucode="+ucode;
                    break;
                case "CM":
                    window.location.href = "../Company/CompanyManagement?ucode="+ucode;
                    break;
                default:
                    break;
            }
        }

        //엑셀업로드 클릭 시
        function fnExcelCheck() {
            var selectComNoVal = '';
            var rbComNoY = $("#<%=rbComNoY.ClientID %>");
            var rbComNoN = $("#<%=rbComNoN.ClientID %>");
            var lblRbComNoY = $("label[for='" + $(rbComNoY).attr("id")+"']").text();
            var lblRbComNoN = $("label[for='" + $(rbComNoN).attr("id") +"']").text();
            
            if ($(rbComNoN).prop("checked")) {
                selectComNoVal = lblRbComNoN;
            } else {
                selectComNoVal = lblRbComNoY;
            }
            
            var confirmVal = confirm("'" + selectComNoVal+"' 에 대한 회원 일괄 업로드를 진행하시겠습니까?");
            if (!confirmVal) {
                return false;
            }
        }


         //Excel
        function fnExcelExport() {

            var target1 = $("#sbSearchTarget_1").val();
            var target2 = $("#sbSearchTarget_2").val();
            var target3 = $("#sbSearchTarget_3").val();
            var target4 = $("#sbSearchTarget_4").val();
            var target5 = $("#sbSearchTarget_5").val();
            var keyword1 = $("#txtSearchKeyword_1").val();
            var keyword2 = $("#txtSearchKeyword_2").val();
            var keyword3 = $("#txtSearchKeyword_3").val();
            var keyword4 = $("#txtSearchKeyword_4").val();
            var keyword5 = $("#txtSearchKeyword_5").val();
            var confirmFlag = $("#sbSearchConfirmStat").val();
            var useFlag = $("#sbSearchUseFlag").val();


            $.fileDownload('../../Handler/ExcelHandler.ashx', {
                httpMethod: 'POST',
                dataType: "json",
                contentType: "application/json",
                data: {
                    SEARCHKEYWORD_1: keyword1,
                    SERACHTARGET_1: target1,
                    SEARCHKEYWORD_2: keyword2,
                    SERACHTARGET_2: target2,
                    SEARCHKEYWORD_3: keyword3,
                    SERACHTARGET_3: target3,
                    SEARCHKEYWORD_4: keyword4,
                    SERACHTARGET_4: target4,
                    SEARCHKEYWORD_5: keyword5,
                    SERACHTARGET_5: target5,
                    CONFIRMFLAG: confirmFlag,
                    USEFLAG: useFlag,
                    TYPE: 'BU',
                    Method: 'MemberBListExcelDownLoad'
                },
                prepareCallback: function (url) {
                    $('#divLoading').css('display', '');
                },
                successCallback: function (url) {
                    $('#divLoading').css('display', 'none');
                },
                failCallback: function (html, url) {

                    alert("저장에 실패 했습니다. 관리자에게 문의해주십시오.");

                }
            });
        }

    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <input type="hidden" name="openNewWindowSvidUser">
    <input type="hidden" name="openNewWindowId">
    <input type="hidden" name="openNewWindowGubun">

    <div class="all">
        <div class="sub-contents-div">
            <!--제목타이틀-->
      
               <div class="sub-title-div">
                <p class="p-title-mainsentence">
                회원관리(구매사)
                    <span class="span-title-subsentence"></span>
                </p>
            </div>
            <br />

            <!--상단영역시작-->
            <div class="memberB-div">
                <table id="tblSearch" class="tbl_main">
                    <tr>
                        <th>일반검색</th>
                        <td style="width: 250px;">
                            <select id="sbSearchTarget_1" class="dropB1">
                                <option value="Id">아이디</option>
                                <option value="Name">담당자명</option>
                            </select>


                            <input type="text" id="txtSearchKeyword_1" placeholder="검색어를 입력하세요" class="txtB1" />
                        </td>
                        <th style="width: 250px;">승인여부</th>
                        <td>
                            <select id="sbSearchConfirmStat" class="dropB2">
                                <option value="ALL">전체</option>
                                <option value="Y">승인</option>
                                <option value="N">미승인</option>
                            </select>
                        </td>
                        <th>사용유무</th>
                        <td>
                            <select id="sbSearchUseFlag" class="dropB1">
                                <option value="ALL">전체</option>
                                <option value="N">사용</option>
                                <option value="A">중지</option>
                                <option value="Y">탈퇴</option>
                            </select>
                        </td>
                        <%-- <td colspan="2">
                     
                    </td>--%>
                    </tr>
                    <tr>
                        <th>적용 대상</th>
                        <td>
                            <select id="sbSearchTarget_2" class="dropB1">
                                <option value="Name">회사명</option>
                                <option value="Code">회사코드</option>
                                <option value="CompNo">사업자번호</option>
                            </select>

                            <input type="text" id="txtSearchKeyword_2" placeholder="검색어를 입력하세요" class="txtB1" />
                        </td>
                        <td>
                            <select id="sbSearchTarget_3" class="dropB1">
                                <option value="Name">사업장명</option>
                                <option value="Code">사업장코드</option>
                            </select>

                            <input type="text" id="txtSearchKeyword_3" placeholder="검색어를 입력하세요" class="txtB1" />
                        </td>
                        <td>
                            <select id="sbSearchTarget_4" class="dropB1">
                                <option value="Name">사업부명</option>
                                <option value="Code">사업부코드</option>
                            </select>

                            <input type="text" id="txtSearchKeyword_4" placeholder="검색어를 입력하세요" class="txtB1" style="width: 130px"/>
                        </td>
                        <td colspan="2">
                            <select id="sbSearchTarget_5" class="dropB1">
                                <option value="Name">부서명</option>
                                <option value="Code">부서코드</option>
                            </select>

                            <input type="text" id="txtSearchKeyword_5" placeholder="검색어를 입력하세요" class="txtB1" style="width: 176px;" />
                        </td>
                    </tr>
                </table>
            </div>



            <!--검색버튼 -->
            <%--<div class="bt-align-div" style="margin-bottom: 50px;">
                <img src="../Images/Member/reset-off.jpg" onmouseover="this.src='../Images/Member/reset-on.jpg'" onmouseout="this.src='../Images/Member/reset-off.jpg'" onclick="fnReset()" />
                <a class="imgA">
                    <img src="../Images/Order/search-off.jpg" alt="검색" onmouseover="this.src='../Images/Order/search-on.jpg'" onmouseout="this.src='../Images/Order/search-off.jpg'" onclick="fnMemberListBind(1)" /></a>
            </div>--%>

            <%--검색영역 버튼--%>
            <div style="float: left; margin:20px 0 50px 0;">
                <input type="button" class="mainbtn type1" style="width: 105px; height: 30px; font-size: 12px" value="회사관리" onclick="fnGoPage('CM')" />
                <input type="button" class="mainbtn type1" style="width: 105px; height: 30px; font-size: 12px" value="주문내역조회" onclick="fnGoPage('OHL')" />
                <input type="button" class="mainbtn type1" style="width: 95px; height: 30px; font-size: 12px" value="배송조회" onclick="fnGoPage('DL')" />
            </div>
            <div style="float: right; margin-top:20px;">
                <input type="button" class="mainbtn type1" style="width: 95px; height: 30px; font-size: 12px" value="초기화" onclick="fnReset()" />
                <input type="button" class="mainbtn type1" style="width: 95px; height: 30px; font-size: 12px" value="검색" onclick="fnMemberListBind(1)" />
            </div>


            <div class="fileDiv" style="margin-bottom: 30px; height: 30px; clear: both;">
                <table class="tbl_file">
                    <tr>
                        <th style="width:120px;">엑셀파일 등록</th>
                        <td>
                            <asp:FileUpload runat="server" ID="fuExcel" CssClass="excelfileupload" Width="610px" /></td>
                        <td style="width:250px; padding-left:5px;">
                            <asp:RadioButton runat="server" ID="rbComNoY" GroupName="ComNoYn" Text="사업자번호(유)" Checked="true" />&nbsp&nbsp&nbsp
                            <asp:RadioButton runat="server" ID="rbComNoN" GroupName="ComNoYn" Text="사업자번호(무)" />
                        </td>
                        <td style="border-right: none;">
                            <asp:Button ID="btnExcelUpload" Text="엑셀업로드" runat="server" ImageUrl="../Images/Goods/upload-off.jpg" onmouseover="this.src='../Images/Goods/upload-on.jpg'" onmouseout="this.src='../Images/Goods/upload-off.jpg'" OnClientClick="return fnExcelCheck();"  CssClass="mainbtn type1" OnClick="btnExcelUpload_Click" />
                            <asp:Button ID="btnExcelFormDownload" Text="엑셀업로드폼 다운로드" runat="server" ImageUrl="../Images/Goods/formSave-off.jpg" onmouseover="this.src='../Images/Goods/formSave-on.jpg'" onmouseout="this.src='../Images/Goods/formSave-off.jpg'"  CssClass="mainbtn type1" OnClick="btnExcelFormDownload_Click" />
                        </td>
                    </tr>
                </table>

            </div>


            <%--  <tr>
                    <td>
                        <select id="sbSearchTarget_6" class="">
                            <option value="1">회사코드</option>
                            <option value="2">사업장코드</option>
                            <option value="3">사업부코드</option>
                            <option value="4">부서코드</option>
                        </select>
                    </td>
                    <td>
                        <a class="imgA">
                            <img src="" onclick="" onmouseover="this.src=''" onmouseout="this.src=''" alt="자동적용" class="search-img"/>
                        </a>
                    </td>
                    <td colspan="7">
                        <a class="imgA">
                            <img src="" onclick="" onmouseover="this.src=''" onmouseout="this.src=''" alt="수동적용" class="search-img"/>
                        </a>
                    </td>
                </tr>--%>


            <%--    <div style="width:100%; display:inline;">--%>
            <div class="left-dv">
                <span>총&nbsp;<label id="lblTotListCnt"></label>&nbsp;회원&nbsp;</span>
                [<span><label id="lblApproYCnt">값1</label>&nbsp;승인</span>&nbsp;/&nbsp;<span style="color: red;"><label id="lblApproNCnt">값2</label>&nbsp;미승인</span><span>(<label id="lblDropACnt">값3</label>&nbsp;중지,&nbsp;<label id="lblDropYCnt">값4</label>&nbsp;탈퇴)</span>]
            </div>


            <div id="divCodeApply" class="right-div">
                <%--<input type="checkbox" class="ckB" />&nbsp;회사코드
                   <input type="checkbox" class="ckB" />&nbsp;사업장코드
                   <input type="checkbox" class="ckB" />&nbsp;사업부코드
                   <input type="checkbox" class="ckB" />&nbsp;부서코드 
                   <a class="btnStyle" onclick="">자동적용</a>
                   <a class="btnStyle" onclick="">수동적용</a>--%>
                
                <input type="button" id="btnExcelExport" class="mainbtn type1" value="엑셀저장" style="width: 95px; height: 30px;" onclick="fnExcelExport(); return false">
            </div>
            <%--   </div>--%>

<!--데이터 리스트 시작 -->
            <table id="tblMemberList" class="tbl_main">
                <colgroup class="">
                    <col />
                    <col />
                    <col />
                    <col />
                    <col />
                    <col />
                    <col />
                    <col />
                    <col />
                    <col />
                    <col />
                    <col />
                    <col style="width:90px;"/>
                    <col />
                    <col />
                    <col />
                    <col />
                </colgroup>
                <thead>
                    <tr>
                        <%--             <th rowspan="2" style="text-align: center; width: 30px;">
                            <input type="checkbox" id="ckbListAll" /></th>--%>
                        <th rowspan="2" class="txt-center" style="width: 30px">번호</th>
                        <th class="auto-style2" style="width: 56px">회사연동<br />
                            코드</th>
                        <th class="auto-style2" style="width: 92px">아이디</th>
                        <th class="auto-style2 td-bgColor" style="width: 89px">회사명</th>
                        <th class="auto-style2" style="width: 80px">사업장코드<br />
                            (사업장명)</th>
                        <th rowspan="2" class="txt-center" style="width: 62px">부서코드<br />
                            (부서명)</th>
                        <th rowspan="2" class="txt-center" style="width: 49px">승인<br />
                            여부</th>
                        <th rowspan="2" class="txt-center" style="width: 61px">대표자명</th>
                        <th rowspan="2" class="txt-center td-bgColor" style="width: 127px">구매사주문유형<br />
                            (가입경로)</th>
                        <th class="auto-style2" style="width: 92px">전화번호</th>
                        <th class="auto-style2" style="width: 132px">팩스번호</th>
                        <th class="auto-style2" style="width: 70px">SMS동의</th>
                        <th class="txt-center" style="width: 55px">배너유무</th>
                        <th class="auto-style2" style="width: 55px">사용유무</th>
                        <th class="auto-style2" style="width: 95px">변경자</th>
                        <th class="auto-style2" style="width: 72px">수정날짜</th>
                    </tr>
                    <tr class="board-tr-height">
                        <th class="txt-center">회사코드</th>
                        <th class="txt-center">담당자명</th>
                        <th class="txt-center td-bgColor">사업자번호</th>
                        <th class="txt-center">사업부코드<br />
                            (사업부명)</th>
                        <th class="txt-center">휴대폰번호</th>
                        <th class="txt-center">이메일</th>
                        <th class="txt-center">EMAIL동의</th>
                        <th class="txt-center">구매사 로그인</th>
                        <th class="txt-center">설정</th>
                        <th class="txt-center">변경사유</th>
                        <th class="txt-center">등록날짜</th>
                    </tr>
                </thead>
                <tbody id="tbodyMemberList" class="txt-center">
                </tbody>
            </table>
        </div>
        <!--데이터 리스트 종료 -->
        <br />
        <!-- 페이징 처리 -->
        <input type="hidden" id="hdTotalCount" />
        <div style="margin: 0 auto; text-align: center">
            <div id="pagination" class="page_curl" style="display: inline-block"></div>
        </div>
        <!--페이징 끝-->

        <!--하단영역시작-->
    </div>

    <%-- 상세 팝업시작 --%>
    <div id="modifyReasonDiv" class="divpopup-layer-package">
        <div class="popupdivWrapper" style="width:700px; height:650px;">
            <div class="popupdivContents" style="border: none;">
                    <div class="sub-title-div">
                        <h3 class="pop-title">변경 이력 조회</h3>
                        <a onclick="fnClosePopup('View'); return false;" class="close-bt" style="float: right">
                            <img src="../../Images/Wish/icon-delete.jpg" /></a>
                    </div>

                    <div class="divpopup-layer-conts">
                        <div>
                            <table id="tblPopModiListSearch" class="tbl_main">
                                <colgroup>
                                    <col style="width: 100px" />
                                    <col/>
                                </colgroup>
                                <tr>
                                    <th>조회기간</th>
                                    <td style="padding-left: 5px;">
                                        <input type="text" id="searchStartDate" class="searchDate" />&nbsp; - &nbsp;<input type="text" id="searchEndDate" class="searchDate" />&nbsp;&nbsp;&nbsp;
                                        <input type="checkbox" id="ckbSearch1" value="7" checked="checked" /><label for="ckbSearch1">7일</label>
                                        <input type="checkbox" id="ckbSearch2" value="15" /><label for="ckbSearch2">15일</label>
                                        <input type="checkbox" id="ckbSearch3" value="30" /><label for="ckbSearch3">30일</label>
                                    </td>
                                </tr>
                                <tr>
                                    <th>변경자명</th>
                                    <td>
                                        <input type="text" id="txtPopDropNameSearch" class="medium-size" onkeypress="return fnPopupEnter();" placeholder="변경자명을 입력하세요" />
                                    </td>
                                </tr>
                            </table>
                            <div class="btn_center">
                                <input type="button" value="검색" style="width:75px;" class="mainbtn type1" id="ibtnSave"  onclick="fnPopupDropListBind(1); return false;";>
                                <input type="hidden" id="hdPopupSvidUser" />
                            </div>

                        </div>
                        <br />
                        <div style="clear: both;">
                            <table id="tblModifyList" class="tbl_main">
                                <thead>
                                    <tr>
                                        <th class="txt-center" style="width: 30px">순번</th>
                                        <th class="txt-center" style="width: 50px">변경자</th>
                                        <th class="txt-center" style="width: 50px">변경날짜</th>
                                        <th class="txt-center" style="width: 50px">사용유무</th>
                                        <th class="txt-center" style="width: 250px;">변경이유</th>
                                    </tr>
                                </thead>
                                <tbody>
                                </tbody>
                            </table>
                        </div>
                        <br />
                        <input type="hidden" id="hdModifyTotalCount" />
                        <div style="margin: 0 auto; text-align: center">
                            <div id="popuppagination" class="page_curl" style="display: inline-block"></div>
                        </div>
                    </div>
                </div>
        </div>
    </div>
    <%-- 상세 팝업끝 --%>

    <%-- 설정 팝업시작 --%>
    <div id="modifyDiv" class="divpopup-layer-package">
        <div class="popupdivWrapper" style="width:700px; height:450px;">
            <div class="popupdivContents" style="border: none;">
                    <div class="sub-title-div">
                        <h3 class="pop-title">사용유무 설정</h3>
                        <a onclick="fnClosePopup('Modify'); return false;" class="close-bt" style="float: right">
                            <img src="../../Images/Wish/icon-delete.jpg" /></a>
                    </div>

                    <div class="divpopup-layer-conts">
                        <table id="tblModify" class="tbl_main">
                             <colgroup>
                                <col style="width:30%"/>
                                <col />
                            </colgroup>
                            <tr>
                                <th>변경자</th>
                                <td id="tdPopupUser"></td>
                            </tr>
                            <tr>
                                <th>사용유무</th>
                                <td>
                                    <select id="sbPopUseFlag" class="small-size">
                                        <option value="N">사용</option>
                                        <option value="A">중지</option>
                                        <option value="Y">탈퇴</option>
                                    </select>
                                </td>
                            </tr>
                            <tr>
                                <th>변경사유</th>
                                <td>
                                    <%--<asp:TextBox runat="server" id="txtPopDropReason" Rows="5" onkeypress="preventEnter(event)" TextMode="MultiLine" Width="100%"></asp:TextBox>--%>
                                    <textarea id="txtPopDropReason" rows="5" style="width: 100%; border: 1px solid #a2a2a2;" maxlength="200" placeholder="변경사유를 입력해 주세요"></textarea>
                                </td>

                            </tr>
                        </table>
                        <br />
                        <div class="btn_center">
                            <input type="hidden" id="hdSvidUser2" />
                            <input type="button" value="저장" style="width:75px;" class="mainbtn type1" id="ibtnSave" onclick="fnUserDropSave()"/>
                        </div>
                    </div>
                </div>
        </div>
    </div>
    <%-- 설정 팝업끝 --%>
</asp:Content>

