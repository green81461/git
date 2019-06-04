<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Master/AdminMasterPage.master" AutoEventWireup="true" CodeFile="SupplierMain.aspx.cs" Inherits="Admin_Goods_SupplierMain" %>

<%@ Register Src="~/UserControl/ucListControl.ascx" TagName="ListPager" TagPrefix="ucPager" %>
<%@ Import Namespace="Urian.Core" %>


<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <link href="../Content/Goods/goods.css" rel="stylesheet" />
    <link href="../Content/Member/member.css" rel="stylesheet" />

    <script>
        $(document).ready(function () {
            fnCategoryBind();

            //체크박스 하나만 선택
            var tableid = 'tblPopupAdmUserId';
            ListCheckboxOnlyOne(tableid);


            var PayDateChk = $("#tdSupplyCompanyCode").val();


            $("#<%=this.SupplyDate.ClientID%>").datepicker({
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


            $("#<%=this.PayDate.ClientID%>").datepicker({
                showAnimation: 'slideDown',
                changeMonth: true,
                changeYear: true,
                showOn: 'button',
                buttonImage:/* "/Images/icon_calandar.png"*/"../../Images/Goods/calendar.jpg",
                buttonImageOnly: true,
                dateFormat: "dd",
                monthNamesShort: ["1월", "2월", "3월", "4월", "5월", "6월", "7월", "8월", "9월", "10월", "11월", "12월"],
                dayNamesMin: ["일", "월", "화", "수", "목", "금", "토"],
                showMonthAfterYear: true
            });



            $("#tbodyMemberList").on("mouseenter", "tr", function () {

                $(this).find("td").css("background-color", "gainsboro");
                $(this).find("td").css("cursor", "pointer");
                var rowIdx = this.rowIndex;
                if ((rowIdx % 2) == 0) {
                    $(this).next().css("background-color", "gainsboro");
                } else {
                    $(this).prev().css("background-color", "gainsboro");
                    //alert(rowIdx - 1);
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


        //테이블 클릭했을 때
        $(document).on('click', '#tblHeader td:not(:nth-child(1))', function () {
            fnAddPopupOpen(this);
            //return false;
        });


        function fnAddPopupOpen(el) {
            //여기서 콜백으로 핸들러 태우고 나서 처리하기.

            $('#<%= ComCodeNo.ClientID%>').val('');
            $('#<%= txtComName.ClientID%>').val('');
            $('#<%= lblFirstNum.ClientID%>').val('');
            $('#<%= lblMiddleNum.ClientID%>').val('');
            $('#<%= lblLastNum.ClientID%>').val('');
            $('#<%= lblName.ClientID%>').val('');

            $('#<%= ddlTelPhone.ClientID%>').val('');    //전화기
            $('#<%= lblMiddleNumber.ClientID%>').val('');
            $('#<%= lblLastNumber.ClientID%>').val('');

            $('#<%= ddlSelPhone.ClientID%>').val(''); //핸드폰
            $('#<%= txtSelPhone2.ClientID%>').val('');
            $('#<%= txtSelPhone3.ClientID%>').val('');

            $('#<%= ddlFax.ClientID%>').val('');  //팩스
            $('#<%= lblMiddleFax.ClientID%>').val('');
            $('#<%= lblLastFax.ClientID%>').val('');

            $('#<%= txtFirstEmail.ClientID%>').val(''); //이메일
            $('#<%= txtLastEmail.ClientID%>').val('');


            $('#<%= txtPostalCode.ClientID%>').val(''); //주소
            $('#<%= txtAddress1.ClientID%>').val('');  //상세주소
            $('#<%= txtAddress2.ClientID%>').val('');
            $('#<%= SupplyDate.ClientID%>').val('');
            $('#<%= txtPerson.ClientID%>').val('');
            $('#<%= lblDept.ClientID%>').val('');
            $('#<%= PayDate.ClientID%>').val('');


            $('#txtAdmUserId').val('');
            $('#spAdmUserNm').val('');


            //핸들러 태우는 부분
            var callback = function (response) {

                if (!isEmpty(response)) {
                    console.log(response);
                    $.each(response, function (key, value) {

                        var SupplyCompanyCode = value.SupplyCompanyCode;                           //공급업체코드
                        var SupplyCompanyName = value.SupplyCompanyName;                           //공급업체명
                        var SupplyCompany_No = value.SupplyCompany_No;                             //사업자번호
                        var SupplyCompanyDelegate_Name = value.SupplyCompanyDelegate_Name;         //대표자명
                        var TelNo = value.TelNo;                                                   //전화번호 
                        var PhoneNo = value.PhoneNo;                                               //휴대폰번호
                        var FaxNo = value.FaxNo;                                                   //FAX번호     
                        var Email = value.Email;                                                   //이메일주소 
                        var ZipCode = value.ZipCode;                                               //우편번호
                        var ADDRESS_1 = value.ADDRESS_1;                                           //상세주소1
                        var ADDRESS_2 = value.ADDRESS_2;                                           //상세주소2 
                        var Name = value.Name;                                                     //업체담당자명
                        var DeptName = value.DeptName;                                             //부서명
                        var SupplyDate = value.SupplyDate.split("T")[0];                                         //거래등록일
                        var EntryDate = value.EntryDate;                                           //등록일
                        var TotalCount = value.TotalCount;                                         //토탈카운트
                        var PayDate = value.PAYDATE;
                        var ADMINUSERNAME = value.ADMINUSERNAME;
                        var ADMINUSERID = value.ADMINUSERID;
                        var CaterogyCode = value.SUPPLYCATEGORY;

                        var CategoryParentcode = $(el).parent().find("input:hidden[name^=hdCategoryCodes]").val();



                        //var SupplyCompany_No_1 = SupplyCompany_No.substring(0, 3);
                        //var SupplyCompany_No_2 = SupplyCompany_No.substring(4, 6);
                        //var SupplyCompany_No_3 = SupplyCompany_No.substring(7, 12);

                        var ComCodeGubun = SupplyCompany_No.split('-');
                        var SupplyCompany_No_1 = ComCodeGubun[0];
                        var SupplyCompany_No_2 = ComCodeGubun[1];
                        var SupplyCompany_No_3 = ComCodeGubun[2];

                        //전화번호세팅
                        var Telgubun = TelNo.split('-');


                        var TelNo_1 = Telgubun[0];
                        var TelNo_2 = Telgubun[1];
                        var TelNo_3 = Telgubun[2];


                        if (TelNo_3 == undefined || TelNo_3 == null) {
                            var TelNo_1 = ''
                            var TelNo_2 = Telgubun[0];
                            var TelNo_3 = Telgubun[1];

                        }
                        else {

                        }


                        //핸드폰 번호 세팅
                        var PhoneNoGubun = PhoneNo.split('-');

                        var PhoneNo_1 = PhoneNoGubun[0];
                        var PhoneNo_2 = PhoneNoGubun[1];
                        var PhoneNo_3 = PhoneNoGubun[2];


                        //var PhoneNo_1 = PhoneNo.substring(0, 3);
                        //var PhoneNo_2 = PhoneNo.substring(4, 8);
                        //var PhoneNo_3 = PhoneNo.substring(9, 13);



                        //FAX 번호 세팅
                        var FaxNoGubun = FaxNo.split('-');

                        var FaxNo_1 = FaxNoGubun[0];
                        var FaxNo_2 = FaxNoGubun[1];
                        var FaxNo_3 = FaxNoGubun[2];



                        //이메일 세팅

                        var EmailGubun = Email.split('@');
                        var EmailGubun_1 = EmailGubun[0];
                        var EmailGubun_2 = EmailGubun[1];

                        $('#<%= ComCodeNo.ClientID%>').val(SupplyCompanyCode);
                        $('#<%= txtComName.ClientID%>').val(SupplyCompanyName);
                        $('#<%= lblFirstNum.ClientID%>').val(SupplyCompany_No_1);
                        $('#<%= lblMiddleNum.ClientID%>').val(SupplyCompany_No_2);
                        $('#<%= lblLastNum.ClientID%>').val(SupplyCompany_No_3);
                        $('#<%= lblName.ClientID%>').val(SupplyCompanyDelegate_Name);

                        $('#<%= ddlTelPhone.ClientID%>').val(TelNo_1);    //전화기
                        $('#<%= lblMiddleNumber.ClientID%>').val(TelNo_2);
                        $('#<%= lblLastNumber.ClientID%>').val(TelNo_3);


                        $('#<%= ddlSelPhone.ClientID%>').val(PhoneNo_1); //핸드폰
                        $('#<%= txtSelPhone2.ClientID%>').val(PhoneNo_2);
                        $('#<%= txtSelPhone3.ClientID%>').val(PhoneNo_3);


                        $('#<%= ddlFax.ClientID%>').val(FaxNo_1);    //팩스
                        $('#<%= lblMiddleFax.ClientID%>').val(FaxNo_2);
                        $('#<%= lblLastFax.ClientID%>').val(FaxNo_3);


                        $('#<%= txtFirstEmail.ClientID%>').val(EmailGubun_1); //이메일
                        $('#<%= txtLastEmail.ClientID%>').val(EmailGubun_2);



                        $('#<%= txtPostalCode.ClientID%>').val(ZipCode);
                        $('#<%= txtAddress1.ClientID%>').val(ADDRESS_1);
                        $('#<%= txtAddress2.ClientID%>').val(ADDRESS_2);
                        $('#<%= SupplyDate.ClientID%>').val(SupplyDate);
                        $('#<%= txtPerson.ClientID%>').val(Name);
                        $('#<%= lblDept.ClientID%>').val('');
                        $('#<%= PayDate.ClientID%>').val(PayDate);


                        $('#txtAdmUserId').val(ADMINUSERID);
                        $('#spAdmUserNm').val(ADMINUSERNAME);


                        $("#<%=hfAdmUserId.ClientID%>").val(ADMINUSERID);
                        $("#<%=hfAdmUserNm.ClientID%>").val(ADMINUSERNAME);
                        $("#<%=categoryCode.ClientID%>").val(CaterogyCode);

                        if (!isEmpty(CategoryParentcode)) {
                            $("#ddlCategory01").val(CategoryParentcode.split(',')[0]);

                            for (var i = 1; i <= CategoryParentcode.split(',').length - 1; i++) {
                                fnSubCategoryBind(CategoryParentcode.split(',')[i - 1], CategoryParentcode.split(',')[i], i + 1);
                            }
                        }

                        // 은행명&예금주&계좌번호 셋팅
                        $('#<%=txtBankName.ClientID%>').val(value.BankName);
                        $('#<%=txtBankNo.ClientID%>').val(value.BankNo);
                        $('#<%=txtSupplyBankName.ClientID%>').val(value.SupplyBankName);

                    });
                } else {
                    alert("오류가 발생했습니다. 잠시 후 다시 시도해 주세요.");
                }
                return false;
            };


            var sUser = '<%= Svid_User%>';
            var SupplyDate = $(el).parent().find('#tdSupplyDate').text().trim();            //등록일
            var SupplyCompanyCode = $(el).parent().find('#tdSupplyCompanyCode').text().trim();      //공급업체코드    
            var SupplyCompanyName = $(el).parent().find('#tdSupplyCompanyName').text().trim();                    //업체명           
            var SupplyCompany_No = $(el).parent().find('#tdSupplyCompany_No').text().trim();       //사업자번호
            var SupplyCompanyDelegate_Name = $(el).parent().find('#tdSupplyCompanyDelegate_Name').text().trim(); //대표자명
            var Name = $(el).parent().find('#tdName').text().trim();        //업체담당자명
            var TelNo = $(el).parent().find('#tdTelNo').text().trim(); //전화번호
            var PhoneNo = $(el).parent().find('#tdPhoneNo').text().trim(); //핸드폰
            var FaxNo = $(el).parent().find('#tdFaxNo').text().trim(); //팩스번호
            var Email = $(el).parent().find('#tdEmail').text().trim(); //이메일 
            var ZipCode = $(el).parent().find('#tdZipCode').text().trim(); //주소 
            var ADDRESS_1 = $(el).parent().find('#tdADDRESS_1').text().trim(); //상세주소 
            var EntryDatem = $(el).parent().find('#tdEntryDate').text().trim(); //공급 업체 등록일



            var param = {
                supplyCompanyCode: SupplyCompanyCode,
                supplyCompany_No: SupplyCompany_No,
                Flag: "SupComUdateList"
            };
            JajaxSessionCheck("Post", "../../Handler/Admin/CompanyHandler.ashx", param, "json", callback, sUser);






            //var e = document.getElementById('supplierMdiv');

            //if (e.style.display == 'block') {
            //    e.style.display = 'none';

            //} else {
            //    e.style.display = 'block';
            //}

            // 공급업체 수정 팝업 노출
            fnOpenDivLayerPopup('supplierMdiv');

        }


        function fnCategoryBind() {
            fnSelectBoxClear(1);
            var callback = function (response) {

                if (!isEmpty(response)) {

                    var ddlHtml = "";

                    $.each(response, function (key, value) {

                        ddlHtml += '<option value="' + value.CategoryFinalCode + '">' + value.CategoryFinalName + '</option>';
                    });

                    $("#ddlCategory01").append(ddlHtml);
                   <%-- $("#<%=ddlExcelCategory.ClientID%>").append(ddlHtml);--%>

                }
                return false;
            };

            var sUser = '<%=Svid_User %>';
            var param = {
                LevelCode: '1',
                UpCode: '',
                Method: 'GetCategoryLevelList'
            };

            JajaxSessionCheck('Post', '../../Handler/Common/CategoryHandler.ashx', param, 'json', callback, '<%=Svid_User %>');
        }


        //디폴트 하위 카테고리 넣는 것.
        function fnSubCategoryBind(upcode, code, level) {

            var callback = function (response) {

                if (!isEmpty(response)) {

                    var ddlHtml = "";

                    $.each(response, function (key, value) {
                        ddlHtml += '<option value="' + value.CategoryFinalCode + '">' + value.CategoryFinalName + '</option>';

                    });

                    var id = '';

                    if (level == '10') {
                        id = level;
                    }
                    else {
                        id = '0' + level;
                    }


                    //$("#ContentPlaceHolder1_ddlCategory" + id).append(ddlHtml);
                    //$("#ContentPlaceHolder1_ddlCategory" + id).val(code);
                    $("#ddlCategory" + id).append(ddlHtml);
                    $("#ddlCategory" + id).val(code);

                }

                return false;
            };

            var sUser = '<%=Svid_User %>';
            var param = {
                LevelCode: level,
                UpCode: upcode,
                Method: 'GetCategoryLevelList'
            };

            JajaxSessionCheck('Post', '../../Handler/Common/CategoryHandler.ashx', param, 'json', callback, '<%=Svid_User %>');

        }


        //팝업창 닫기

        function fnCancel() {
            $('.divpopup-layer-package').fadeOut();
        }
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


        function fnSearchAdmUserIdPopup() {

            fnAdmUserIdSearch(1);

            //var e = document.getElementById('admUserIdSearchDiv');

            //if (e.style.display == 'block') {
            //    e.style.display = 'none';

            //} else {
            //    $(".popupdivWrapper").css("height", "650px");

            //    e.style.display = 'block';
            //}

            fnOpenDivLayerPopup('admUserIdSearchDiv'); 

            return false;
        }

        function fnPopupOkAdmUserId() {
            var cnt = 0;

            $('#tblPopupAdmUserId tr').each(function (index, element) {
                var check = $(this).find("#cbPopup").is(":checked");
                if (check) {
                    var userId = $(this).find("input:hidden[name='hdPopUserId']").val();
                    var userNm = $(this).find("input:hidden[name='hdPopUserNm']").val();

                    $("#txtAdmUserId").val(userId);
                    $("#spAdmUserNm").val(userNm);

                    $("#<%=hfAdmUserId.ClientID%>").val(userId);
                    $("#<%=hfAdmUserNm.ClientID%>").val(userNm);


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
        function getPageData2() {
            var container = $('#pagination2');
            var getPageNum = container.pagination('getSelectedPageNum');
            fnAdmUserIdSearch(getPageNum);
            return false;
        }

        function fnEnter() {

            if (event.keyCode == 13) {
                    <%=Page.GetPostBackEventReference(btnSearch)%>
                return false;
            }
            else
                return true;
        }

        function fnPopupEnter() {

            if (event.keyCode == 13) {
                fnAdmUserIdSearch(1);
                return false;
            }
            else
                return true;
        }


        function fnChangeSubCategoryBind(el, level) {
            var selectedVal = $(el).val();

            $("#<%=hfFinalCode.ClientID%>").val(level); fnChangeSubCategoryBind
            if (level == '2') {
                var callback = function (response) {
                    if (!isEmpty(response)) {
                        if (response.MdName != '' && response.MdToId != '') {
                            $('#hdMdToId').val(response.MdToId);
                            $('#lbMD').text(response.MdName);
                        }
                    }
                    else {
                        $('#hdMdToId').val('<%= UserInfoObject.Id%>');
                        $('#lbMD').text('<%= UserInfoObject.Name%>');
                    }
                    return false;
                };

                var sUser = '<%=Svid_User %>';
                var param = {
                    CategoryCode: selectedVal,
                    Method: 'GetGoodsMDInfo'
                };

                JajaxSessionCheck('Post', '../../Handler/GoodsHandler.ashx', param, 'json', callback, '<%=Svid_User %>');
            }

            for (var i = level; i < 10; i++) {
                fnSelectBoxClear(i);
            }

            var callback = function (response) {

                if (!isEmpty(response)) {

                    var ddlHtml = "";

                    $.each(response, function (key, value) {
                        ddlHtml += '<option value="' + value.CategoryFinalCode + '">' + value.CategoryFinalName + '</option>';
                    });

                    var id = '';

                    if (level == '10') {
                        id = level;
                    }
                    else {
                        id = '0' + level;
                    }
                    $("#ddlCategory" + id).append(ddlHtml);

                }
                return false;
            };

            var sUser = '<%=Svid_User %>';
            var param = {
                LevelCode: level,
                UpCode: selectedVal,
                Method: 'GetCategoryLevelList'
            };



            $("#<%=categoryCode.ClientID%>").val(selectedVal);

            $("#txtCaLevel" + level).val(selectedVal);
            var applyLevel1 = $("#txtCaLevel1").val();
            var applyLevel2 = $("#txtCaLevel2").val();          //레벨1
            var applyLevel3 = $("#txtCaLevel3").val();          //레벨2
            var applyLevel4 = $("#txtCaLevel4").val();          //레벨3
            var applyLevel5 = $("#txtCaLevel5").val();          //레벨4


            JajaxSessionCheck('Post', '../../Handler/Common/CategoryHandler.ashx', param, 'json', callback, '<%=Svid_User %>');

        }

        function fnSelectBoxClear(index) {

            var id = '';

            if (index == '10') {
                id = index;
            }
            else {
                id = '0' + index;
            }
            $("#ddlCategory" + id).empty();
            $("#ddlCategory" + id).append('<option value="All">---전체---</option>');
            return false;

        }



        function openPostcode() {
            var width = 500; //팝업의 너비
            var height = 500; //팝업의 높이
            new daum.Postcode({
                width: width,
                height: height,
                oncomplete: function (data) {
                    // 팝업에서 검색결과 항목을 클릭했을때 실행할 코드를 작성하는 부분.

                    // 각 주소의 노출 규칙에 따라 주소를 조합한다.
                    // 내려오는 변수가 값이 없는 경우엔 공백('')값을 가지므로, 이를 참고하여 분기 한다.
                    var fullAddr = ''; // 최종 주소 변수
                    var extraAddr = ''; // 조합형 주소 변수

                    // 사용자가 선택한 주소 타입에 따라 해당 주소 값을 가져온다.
                    if (data.userSelectedType === 'R') { // 사용자가 도로명 주소를 선택했을 경우
                        fullAddr = data.roadAddress;

                    } else { // 사용자가 지번 주소를 선택했을 경우(J)
                        fullAddr = data.jibunAddress;
                    }

                    // 사용자가 선택한 주소가 도로명 타입일때 조합한다.
                    if (data.userSelectedType === 'R') {
                        //법정동명이 있을 경우 추가한다.
                        if (data.bname !== '') {
                            extraAddr += data.bname;
                        }
                        // 건물명이 있을 경우 추가한다.
                        if (data.buildingName !== '') {
                            extraAddr += (extraAddr !== '' ? ', ' + data.buildingName : data.buildingName);
                        }
                        // 조합형주소의 유무에 따라 양쪽에 괄호를 추가하여 최종 주소를 만든다.
                        fullAddr += (extraAddr !== '' ? ' (' + extraAddr + ')' : '');
                    }

                    // 우편번호와 주소 정보를 해당 필드에 넣는다.
                    $("#<%=txtPostalCode.ClientID%>").val(data.zonecode);
                    $("#<%=hfPostalCode.ClientID%>").val(data.zonecode);
                    $("#<%=txtAddress1.ClientID%>").val(fullAddr);
                    $("#<%=hfAddress1.ClientID%>").val(fullAddr);

                    //document.getElementById('sample6_postcode').value = data.zonecode; //5자리 새우편번호 사용
                    //document.getElementById('sample6_address').value = fullAddr;

                    //// 커서를 상세주소 필드로 이동한다.
                    $("#<%=txtAddress2.ClientID%>").focus();
                }
            }).open({
                left: (window.screen.width / 2) - (width / 2),
                top: (window.screen.height / 2) - (height / 2)
            }
            );
        }


        function fnSetRowColor(el, type) {

            if (type == 'over') {
                $(el).css('cursor', 'pointer')
                $(el).addClass("selected");
            }
            else {
                $(el).removeClass("selected");

            }

        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div class="all">

        <div class="sub-contents-div">
            <div class="sub-title-div">
                <p class="p-title-mainsentence">
                    공급업체 관리
                    <span class="span-title-subsentence">공급업체를 등록 및 조회 관리 할 수 있습니다.</span>
                </p>
            </div>

            <!--탭메뉴-->
            <div class="div-main-tab" style="width: 100%;">
                <ul>
                    <li class='tabOn' style="width: 185px;" onclick="fnTabClickRedirect('SupplierMain');">
                        <a onclick="fnTabClickRedirect('SupplierMain');">공급업체 조회</a>
                    </li>
                    <li class='tabOff' style="width: 185px;" onclick="fnTabClickRedirect('SupplierRegister');">
                        <a onclick="fnTabClickRedirect('SupplierRegister');">공급업체 등록</a>
                    </li>
                </ul>
            </div>

            <div class="bottom-search-div">
                <table class="tbl_search">
                    <colgroup>
                        <col style="width: 90px;" />
                        <col style="width: 200px" />
                        <col />
                    </colgroup>
                    <tr>
                        <td></td>
                        <td>
                            <asp:DropDownList ID="ddlSearchTarget" runat="server" CssClass="medium-size">
                                <asp:ListItem Text="업체코드" Value="ComCodeNo"></asp:ListItem>
                                <asp:ListItem Text="업체명" Value="ComName"></asp:ListItem>
                            </asp:DropDownList>
                        </td>
                        <td>
                            <asp:TextBox ID="txtSerch" runat="server" placeholder="검색어를 입력하세요." Style="padding-left: 10px; width: 800px;" onkeypress="return fnEnter()"></asp:TextBox>
                            <asp:Button runat="server" ID="btnSearch" CssClass="mainbtn type1" OnClick="btnSearch_Click" Text="검색" Width="75" Height="25" />
                        </td>
                    </tr>
                </table>
            </div>

            <asp:ListView ID="lvMemberListB" runat="server" ItemPlaceholderID="phItemList">
                <LayoutTemplate>
                    <table id="tblHeader" class="tbl_main" style="margin-top: 40px;">
                        <colgroup>
                            <col style="width: 50px;" />
                            <col style="width: 100px;" />
                            <col style="width: 100px;" />
                            <col style="width: 100px;" />
                            <col style="width: 100px;" />
                            <col style="width: 110px;" />
                            <col style="width: 150px;" />
                            <col style="width: 150px;" />
                            <%--<col style="width:100px;"/>--%>
                            <col style="width: 650px;" />
                            <col style="width: 100px;" />
                        </colgroup>
                        <thead>
                            <tr>
                                <th rowspan="2">번호</th>
                                <th>거래등록일</th>
                                <th rowspan="2">공급업체코드</th>
                                <th>업체명</th>
                                <th rowspan="2">카테고리명</th>
                                <th>대표자명</th>
                                <th>전화번호</th>
                                <th>핸드폰</th>
                                <%--<th rowspan="2">우편번호</th>--%>
                                <th rowspan="2">주소(우편번호)<br />(은행)예금주-계좌번호</th>
                                <th rowspan="2">등록일</th>
                            </tr>
                            <tr>
                                <th>결제일자</th>
                                <th>사업자번호</th>
                                <th>업체담당자명</th>
                                <th>FAX</th>
                                <th>이메일</th>

                            </tr>
                        </thead>
                        <tbody id="tbodyMemberList">
                            <asp:PlaceHolder ID="phItemList" runat="server" />
                        </tbody>

                    </table>
                </LayoutTemplate>

                <ItemTemplate>
                    <tr class="board-tr-height" onmouseover="fnSetRowColor(this,'over');" onmouseout="fnSetRowColor(this,'out');">
                        <%--<td></td>--%>
                        <%--    <td class="txt-center">
                            <%# Eval("TotalCount").ToString()%>
                        </td>--%>

                        <td rowspan="2" class="txt-center">
                            <%--<%# Container.DataItemIndex + 1%>--%>
                            <%# Eval("RowNum").ToString()%>
                            <input type="hidden" name="hdCategoryCodes" value="<%# Eval("CategoryParentCodes").ToString()%>" />
                        </td>
                        <%-- 번호--%>
                        <td class="txt-center" id="tdSupplyDate1"><%-- 거래등록일--%>
                            <%# Eval("SupplyDate").AsDateTime().ToString("yyyy-MM-dd")%>
                        </td>
                        <td rowspan="2" class="txt-center" id="tdSupplyCompanyCode"><%-- 공급업체 코드--%>
                            <%# Eval("SupplyCompanyCode").ToString()%>
                        </td>
                        <td class="txt-center" id="tdSupplyCompanyName"><%-- 업체명--%>
                            <%# Eval("SupplyCompanyName").ToString()%>
                        </td>
                        <td rowspan="2" class="txt-center"><%-- 카테고리--%>
                            <%# Eval("SUPPLYCATEGORY").ToString()%>
                        </td>
                        <td class="txt-center" id="tdSupplyCompanyDelegate_Name"><%-- 대표자명--%>
                            <%# Eval("SupplyCompanyDelegate_Name").ToString()%>
                        </td>
                        <td class="txt-center" id="tdTelNo"><%-- 전화번호--%>
                            <%# string.IsNullOrWhiteSpace(Eval("TelNo").ToString()) ? "-" :  Eval("TelNo").ToString()%>             
                        </td>
                        <td class="txt-center" id="tdPhoneNo"><%-- 휴대폰번호--%>
                            <%# string.IsNullOrWhiteSpace(Eval("PhoneNo").ToString()) ? "-" :  Eval("PhoneNo").ToString()%>

                            <input type="hidden" id="hdCategoryCode4" value="<%# Eval("SupplyCompany_No").ToString()%>" />
                        </td>


                        <%--<td rowspan="2" class="txt-center" id="tdZipCode">
                            우편번호
                            <%# Eval("ZipCode").ToString()%>
                        </td>--%>


                        <td rowspan="2" class="txt-center" id="tdADDRESS_1"><%-- 상세주소(우편번호) & 계좌정보--%>
                            <%# Eval("ADDRESS_1").ToString()%>
                            <%# Eval("ADDRESS_2").ToString()%>
                            <%# string.IsNullOrWhiteSpace(Eval("ZipCode").ToString()) ? " " : "("+Eval("ZipCode").ToString().Trim()+")"%>
                            
                            <br />
                            <%# string.IsNullOrWhiteSpace(Eval("BankName").ToString()) ? " " : "("+Eval("BankName").ToString()+")"  %>
                            <%# Eval("SupplyBankName").ToString()%>-<%# Eval("BankNo").ToString()%>
                        </td>


                        <td rowspan="2" class="txt-center" id="tdEntryDate"><%-- 등록일--%>
                            <%# Eval("EntryDate").AsDateTime().ToString("yyyy-MM-dd")%>
                        </td>
                    </tr>

                    <tr>
                        <td class="txt-center" id="tdPayDate"><%-- 결제일자--%>                 
                            <%# string.IsNullOrWhiteSpace(Eval("PAYDATE").ToString()) ? "-" :  "매월 " +  Eval("PAYDATE").ToString() +"일"%> 
                        </td>
                        <td class="txt-center" id="tdSupplyCompany_No"><%-- 사업자번호--%>
                            <%# Eval("SupplyCompany_No").ToString()%>
                        </td>
                        <td class="txt-center" id="tdName"><%-- 담당자명--%>
                            <%# Eval("Name").ToString()%>
                        </td>
                        <td class="txt-center" id="tdFaxNo"><%-- 팩스번호--%>
                            <%# string.IsNullOrWhiteSpace(Eval("FaxNo").ToString()) ? "-" :  Eval("FaxNo").ToString()%>
                        </td>
                        <td class="txt-center" id="tdEmail"><%-- 이메일--%>
                            <%# string.IsNullOrWhiteSpace(Eval("Email").ToString()) ? "-" :  Eval("Email").ToString()%>
                        </td>
                    </tr>
                </ItemTemplate>

                <EmptyDataTemplate>
                    <table class="tbl_main" style="margin-top: 20px;">
                        <colgroup>
                            <%--<col />--%>
                            <col />
                            <col />
                            <col />
                            <col />
                            <col />
                            <col />
                            <col />
                            <col />
                            <col />
                            <%--<col />--%>
                            <col />
                        </colgroup>
                        <thead>
                            <tr>
                                <th rowspan="2">번호</th>
                                <th rowspan="2">거래등록일<br></br>
                                    (결제일자)
                                </th>
                                <th rowspan="2">공급업체코드</th>
                                <th>업체명</th>
                                <th rowspan="2">카테고리명</th>
                                <th>대표자명</th>
                                <th>전화번호</th>
                                <th>핸드폰</th>
                                <%--<th rowspan="2">우편번호</th>--%>
                                <th rowspan="2" style="width: 270px;">상세주소</th>
                                <th rowspan="2">등록일</th>
                            </tr>
                            <tr>
                                <th>사업자번호</th>
                                <th>업체담당자명</th>
                                <th>FAX</th>
                                <th>이메일</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td colspan="10" class="txt-center">조회된 정보가 없습니다.</td>
                            </tr>
                        </tbody>
                    </table>
                </EmptyDataTemplate>
            </asp:ListView>

            <div style="margin: 0 auto; text-align: center">
                <ucPager:ListPager ID="ucListPager" runat="server" PageSize="20" OnPageIndexChange="ucListPager_PageIndexChange" />
            </div>

            <!--엑셀다운로드,저장 버튼-->
            <div class="bt-align-div">
                <asp:Button ID="btnExcelExport" runat="server" Width="95" Height="30" Text="엑셀 저장" CssClass="mainbtn type1" OnClick="btnExcelExport_Click" />
            </div>

            <!--공급업체 수정 팝업  -->
            <div id="supplierMdiv" class="divpopup-layer-package">
                <div class="supplierMwrapper popupdivWrapper" style="height: 760px;">
                    <div class="supplierMcontents">
                        <!--닫기버튼-->
                        <div class="close-div">
                            <a onclick="fnCancel()" style="cursor: pointer">
                                <img src="../../Images/Wish/icon-delete.jpg" alt="닫기" style="float: right;" /></a>
                        </div>
                        <!--제목-->
                        <h3 class="pop-title">공급업체 수정</h3>

                        <div class="memberB-div">
                            <table class="tbl_main tbl_pop">
                                <colgroup>
                                    <col style="width: 150px;" />
                                    <col />
                                </colgroup>
                                <tr>
                                    <th>업체코드</th>
                                    <td>
                                        <asp:TextBox runat="server" ReadOnly="true" ID="ComCodeNo" CssClass="medium-size"></asp:TextBox>
                                    </td>
                                </tr>
                                <tr>
                                    <th>업체명</th>
                                    <td>
                                        <asp:TextBox runat="server" ID="txtComName" CssClass="medium-size"></asp:TextBox>
                                    </td>
                                </tr>
                                <tr>
                                    <th>사업자번호</th>
                                    <td>
                                        <asp:TextBox ID="lblFirstNum" ReadOnly="true" runat="server" TextMode="Number" max="9999" oninput="return maxLengthCheck(this)" MaxLength="3" Width="60px" onkeypress="return onlyNumbers(event);" CssClass="text-input"></asp:TextBox>&nbsp;&nbsp;-&nbsp;
                                        <asp:TextBox ID="lblMiddleNum" ReadOnly="true" runat="server" TextMode="Number" max="9999" oninput="return maxLengthCheck(this)" MaxLength="2" Width="60px" onkeypress="return onlyNumbers(event);" CssClass="text-input"></asp:TextBox>&nbsp;&nbsp;-&nbsp;
                                        <asp:TextBox ID="lblLastNum" ReadOnly="true" runat="server" TextMode="Number" max="99999" oninput="return maxLengthCheck(this)" MaxLength="5" Width="60px" onkeypress="return onlyNumbers(event);" CssClass="text-input"></asp:TextBox>
                                        <span>＊사업자번호나 고유번호를 입력해주세요.</span>
                                </tr>

                                <tr>
                                    <th>대표자명</th>
                                    <td>
                                        <asp:TextBox ID="lblName" runat="server" Text="" CssClass="medium-size"></asp:TextBox>
                                    </td>
                                </tr>

                                <tr>
                                    <th>업체담당자명</th>
                                    <td>
                                        <asp:TextBox ID="txtPerson" runat="server" CssClass="medium-size"></asp:TextBox>
                                        <asp:TextBox Visible="false" ID="lblDept" runat="server" Text="" CssClass="medium-size"></asp:TextBox>
                                    </td>
                                </tr>

                                <tr>
                                    <th>전화번호</th>
                                    <td>
                                        <asp:TextBox ID="ddlTelPhone" runat="server" Width="60px" max="99999" oninput="return maxLengthCheck(this)" MaxLength="5" TextMode="Number" onkeypress="return onlyNumbers(event);" CssClass="text-input"></asp:TextBox>&nbsp;&nbsp;-&nbsp;
                                        <asp:TextBox ID="lblMiddleNumber" runat="server" Width="60px" max="99999" oninput="return maxLengthCheck(this)" MaxLength="5" TextMode="Number" onkeypress="return onlyNumbers(event);" CssClass="text-input"></asp:TextBox>&nbsp;&nbsp;-&nbsp;
                                        <asp:TextBox ID="lblLastNumber" runat="server" Width="60px" oninput="return maxLengthCheck(this)" TextMode="Number" MaxLength="5" onkeypress="return onlyNumbers(event);" CssClass="text-input"></asp:TextBox>
                                    </td>
                                </tr>
                                <tr>
                                    <th>휴대전화번호</th>
                                    <td>
                                        <asp:TextBox ID="ddlSelPhone" runat="server" Width="60px" oninput="return maxLengthCheck(this)" TextMode="Number" MaxLength="5" onkeypress="return onlyNumbers(event);" CssClass="text-input"></asp:TextBox>&nbsp;&nbsp;-&nbsp;
                                        <asp:TextBox ID="txtSelPhone2" runat="server" Width="60px" oninput="return maxLengthCheck(this)" TextMode="Number" MaxLength="5" onkeypress="return onlyNumbers(event);" CssClass="text-input"></asp:TextBox>&nbsp;&nbsp;-&nbsp;
                                        <asp:TextBox ID="txtSelPhone3" runat="server" Width="60px" oninput="return maxLengthCheck(this)" TextMode="Number" MaxLength="5" onkeypress="return onlyNumbers(event);" CssClass="text-input"></asp:TextBox>
                                    </td>
                                </tr>

                                <tr>
                                    <th>FAX번호</th>
                                    <td>
                                        <asp:TextBox ID="ddlFax" runat="server" Width="60px" TextMode="Number" MaxLength="5" oninput="return maxLengthCheck(this)" onkeypress="return onlyNumbers(event);" CssClass="text-input"></asp:TextBox>&nbsp;&nbsp;-&nbsp;
                                        <asp:TextBox ID="lblMiddleFax" runat="server" Width="60px" TextMode="Number" MaxLength="5" oninput="return maxLengthCheck(this)" onkeypress="return onlyNumbers(event);" CssClass="text-input"></asp:TextBox>&nbsp;&nbsp;-&nbsp;
                                        <asp:TextBox ID="lblLastFax" runat="server" Width="60px" TextMode="Number" MaxLength="5" oninput="return maxLengthCheck(this)" onkeypress="return onlyNumbers(event);" CssClass="text-input"></asp:TextBox>
                                    </td>
                                </tr>
                                <tr>
                                    <th>이메일</th>
                                    <td>
                                        <asp:TextBox ID="txtFirstEmail" runat="server" Width="130px" CssClass="text-input" onkeypress="return preventEnter(event);"></asp:TextBox>
                                        @
                                        <asp:TextBox ID="txtLastEmail" runat="server" Width="130px" CssClass="text-input" onkeypress="return preventEnter(event);"></asp:TextBox>
                                    </td>
                                </tr>
                                <tr>
                                    <th rowspan="2">주&nbsp;&nbsp;소</th>
                                    <td>
                                        <asp:TextBox ID="txtPostalCode" runat="server" ReadOnly="true" CssClass="text-readonly" Width="105px"></asp:TextBox>
                                        <asp:HiddenField ID="hfPostalCode" runat="server" />
                                        <a href="#none" class="mainbtn type1" onclick="openPostcode(); return false;">우편번호검색</a>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:TextBox ID="txtAddress1" runat="server" Width="350px" ReadOnly="true" CssClass="text-readonly"></asp:TextBox>
                                        <asp:HiddenField ID="hfAddress1" runat="server" />
                                        <asp:TextBox ID="txtAddress2" runat="server" CssClass="text-readonly"></asp:TextBox>
                                        <asp:HiddenField ID="hfAddress2" runat="server" />
                                    </td>
                                </tr>
                                <tr>
                                    <th>은행명</th>
                                    <td>
                                        <asp:TextBox runat="server" ID="txtBankName" CssClass="medium-size"></asp:TextBox>
                                    </td>
                                </tr>
                                <tr>
                                    <th>예금주</th>
                                    <td>
                                        <asp:TextBox runat="server" ID="txtSupplyBankName" CssClass="medium-size"></asp:TextBox>
                                    </td>
                                </tr>
                                <tr>
                                    <th>계좌번호</th>
                                    <td>
                                        <asp:TextBox runat="server" ID="txtBankNo" CssClass="medium-size"></asp:TextBox>
                                    </td>
                                </tr>
                                <tr>
                                    <th>거래등록일</th>
                                    <td>
                                        <asp:TextBox runat="server" ID="SupplyDate" ReadOnly="true" CssClass="medium-size" Style="margin-right: 5px"></asp:TextBox>
                                    </td>
                                </tr>
                                <tr>
                                    <th>결제일자</th>
                                    <td>
                                        <asp:TextBox runat="server" ID="PayDate" CssClass="medium-size" Style="margin-right: 5px"></asp:TextBox>
                                        <%--<asp:TextBox  ID="SupplyDate" runat="server" CssClass="text-input" Width="250px"></asp:TextBox>--%></td>
                                </tr>
                                <tr id="trAdmUserId">
                                    <th>소셜위드 관리 담당자</th>
                                    <td>
                                        <input class="txtCompManagement" id="txtAdmUserId" type="text" readonly="readonly" style="width: 130px; border: 1px solid #a2a2a2">
                                        <asp:HiddenField ID="hfAdmUserId" runat="server" />
                                        <asp:HiddenField ID="hfAdmUserNm" runat="server" />
                                        <asp:HiddenField ID="hfFinalCode" runat="server" />
                                        <asp:HiddenField ID="categoryCode" runat="server"></asp:HiddenField>
                                        <input class="txtCompManagement" id="spAdmUserNm" type="text" readonly="readonly" style="width: 130px; border: 1px solid #a2a2a2">
                                        <a href="#none" class="mainbtn type1" onclick="fnSearchAdmUserIdPopup(); return false;">검색</a>
                                    </td>
                                </tr>
                                <%--<tr>
                                    <th>소셜위드 관리 담당자명</th>
                                    <td>
                                        <input class="txtCompManagement" id="spAdmUserNm" onkeypress="return fnEnter()" type="text" readonly="readonly" style="border: 1px solid #a2a2a2">
                                    </td>
                                </tr>--%>
                                <tr>
                                    <th rowspan="2">카테고리</th>
                                    <td>
                                        <input type="hidden" id="txtCaLevel1" name="txtCaLevel1">
                                        <input type="hidden" id="txtCaLevel2" name="txtCaLevel2">
                                        <input type="hidden" id="txtCaLevel3" name="txtCaLevel3">
                                        <input type="hidden" id="txtCaLevel4" name="txtCaLevel4">
                                        <input type="hidden" id="txtCaLevel5" name="txtCaLevel5">
                                        <select class="category_select" id="ddlCategory01" onchange="fnChangeSubCategoryBind(this,2); return false;">
                                            <option value="All">---전체---</option>
                                        </select>
                                        <select class="category_select" id="ddlCategory02" onchange="fnChangeSubCategoryBind(this,3); return false;">
                                            <option value="All">---전체---</option>
                                        </select>
                                        <select class="category_select" id="ddlCategory03" onchange="fnChangeSubCategoryBind(this,4); return false;">
                                            <option value="All">---전체---</option>
                                        </select>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <select class="category_select" id="ddlCategory04" onchange="fnChangeSubCategoryBind(this,5); return false;">
                                            <option value="All">---전체---</option>
                                        </select>
                                        <select class="category_select" id="ddlCategory05" onchange="fnChangeSubCategoryBind(this,6); return false;">
                                            <option value="All">---전체---</option>
                                        </select>
                                    </td>
                                </tr>
                            </table>
                        </div>

                        <!--저장버튼-->
                        <div class="btn_center">
                            <asp:Button ID="btnSave" runat="server" Width="95" Height="30" Text="저장" OnClick="btnSave_Click" CssClass="mainbtn type1" />
                            <%--<asp:ImageButton ID="btnSave" runat="server" ImageUrl="../Images/Member/save.jpg" AlternateText="저장" onmouseover="this.src='../Images/Member/save-on.jpg'" onmouseout="this.src='../Images/Member/save.jpg'" OnClick="click_save" />--%>
                        </div>
                        <!--저장버튼끝-->

                    </div>
                </div>
            </div>

        </div>
    </div>


    <div id="admUserIdSearchDiv" class="popupdiv divpopup-layer-package">
        <div class="popupdivWrapper" style="width: 650px;">
            <div class="popupdivContents">

                <div class="close-div">
                    <a onclick="fnClosePopup('admUserIdSearchDiv'); return false;" style="cursor: pointer">
                        <img src="../../Images/Wish/icon-delete.jpg" alt="닫기" style="float: right;" /></a>
                </div>
                <div class="popup-title">
                    <h3 class="pop-title">소셜위드 관리 담당자 조회</h3>
                    <div class="search-div">
                        <select id="ddlPopSearch2" class="selectCompManagement">
                            <option value="Name">이름</option>
                            <option value="Id">아이디</option>
                        </select>
                        <input type="text" class="text-code" id="txtPopSearch2" placeholder="검색어를 입력해 주세요." onkeypress="return fnPopupEnter();" style="width: 300px" />
                        <input type="button" value="검색" style="width: 75px" class="mainbtn type1" onclick="fnAdmUserIdSearch(1); return false;" id="btnAdminSearch">
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
                        <input type="button" value="취소" style="width: 75px" class="mainbtn type2" onclick="fnClosePopup('admUserIdSearchDiv'); return false;">
                        <input type="button" value="확인" style="width: 75px" class="mainbtn type1" onclick="fnPopupOkAdmUserId(); return false;">
                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>

