<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Master/AdminMasterPage.master" AutoEventWireup="true" CodeFile="SupplierRegister.aspx.cs" Inherits="Admin_Goods_SupplierRegister" %>

<%@ Import Namespace="Urian.Core" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <script src="pagination.js"></script>
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <link href="../Content/Goods/goods.css" rel="stylesheet" />
    <link href="../Content/Member/member.css" rel="stylesheet" />
    <script type="text/javascript">

        $(document).ready(function () {
            var tableid = 'tblPopupAdmUserId';
            ListCheckboxOnlyOne(tableid);



            var ddlEmail = $("#<%=ddlEmail3.ClientID %>");
            var txtLastEmail = $("#<%=txtLastEmail.ClientID %>");
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




            ddlEmail.change(function () {
                var selectedVal = $('#<%=ddlEmail3.ClientID %> option:selected').val();
                if (selectedVal == 'direct') {
                    txtLastEmail.val('');
                }
                else {
                    txtLastEmail.val(selectedVal);
                }
            });

            //카테고리 리스트 바인드(레벨1)
            fnCategoryBind();

        });

        //사업자번호 중복 체크!
        function CheckComNo() {
            var sUser = '<%=Svid_User %>';
            var ComCode1 = $("#<%=lblFirstNum.ClientID%>").val();
            var ComCode2 = $("#<%=lblMiddleNum.ClientID%>").val();
            var ComCode3 = $("#<%=lblLastNum.ClientID%>").val();

            if (isEmpty(ComCode1) || isEmpty(ComCode2) || isEmpty(ComCode3)) {
                alert("사업자번호를 입력해 주세요.");
                return false;
            }

            var callback = function (response) {

                if (!isEmpty(response)) {
                    if (response.CompanyCount == '1') {
                        alert(response.CompanyCount)
                        alert('중복된 사업자 등록번호 입니다.')
                        $('#<%=lblFirstNum.ClientID%>').val('');
                        $('#<%=lblMiddleNum.ClientID%>').val('');
                        $('#<%=lblLastNum.ClientID%>').val('');

                    }
                    else {
                        alert('사용 가능한 사업자 등록번호 입니다.')
                    }

                }
                else {

                }
                return false;
            };

            var CompanyCode = ComCode1 + '-' + ComCode2 + '-' + ComCode3;

            var param = {
                CompanyCode: CompanyCode,
                Flag: 'CheckComNo'
            };

            JajaxSessionCheck('Post', '../../Handler/Admin/CompanyHandler.ashx', param, 'json', callback, '<%=Svid_User %>');
        }


        //카테고리 리스트 바인드(레벨1)
        function fnCategoryBind() {
            fnSelectBoxClear(1);
            var callback = function (response) {

                if (!isEmpty(response)) {

                    var ddlHtml = "";

                    $.each(response, function (key, value) {

                        ddlHtml += '<option value="' + value.CategoryFinalCode + '">' + value.CategoryFinalName + '</option>';
                    });


                    $("#Category01").append(ddlHtml);

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

        //카테고리
        function fnChangeSubCategoryBind(el, level) {

            $("#<%=hfFinalCode.ClientID%>").val(level);
            var selectedVal = $(el).val();
            for (var i = level; i < 10; i++) {
                fnSelectBoxClear(i);
            }

            var callback = function (response) {

                if (!isEmpty(response)) {

                    var ddlHtml = "";
                    var caLevel = "";

                    $.each(response, function (key, value) {
                        ddlHtml += '<option value="' + value.CategoryFinalCode + '">' + value.CategoryFinalName + '</option>';
                        caLevel += value.CategoryFinalCode;

                    });

                    var id = '';

                    if (level == '10') {
                        id = level;
                    }
                    else {
                        id = '0' + level;
                    }
                    $("#Category" + id).append(ddlHtml);

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

        //카테고리 리스트 클리어
        function fnSelectBoxClear(index) {

            var id = '';

            if (index == '10') {
                id = index;
            }
            else {
                id = '0' + index;
            }
            $("#Category" + id).empty();
            //if (id != 1) {
            //    $("#Category" + id).append('<option value="All">---전체---</option>');
            //}
            $("#Category" + id).append('<option value="All">---전체---</option>');
            return false;

        }

        //소셜위드 담당자 호출
        function fnAdmUserIdSearch(pageNo) {
            var searchKeyword = $("#txtPopSearch2").val();
            var searchTarget = $("#ddlPopSearch2").val();
            var pageSize =15;
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

        //페이징
        function getPageData2() {
            var container = $('#pagination2');
            var getPageNum = container.pagination('getSelectedPageNum');
            fnAdmUserIdSearch(getPageNum);
            return false;
        }


        function fnEnter() {

            if (event.keyCode == 13) {

                return false;
            }
            else
                return true;
        }


        //담당자 검색
        function fnSearchAdmUserIdPopup() {

            fnAdmUserIdSearch(1);

            //var e = document.getElementById('admUserIdSearchDiv');

            //if (e.style.display == 'block') {
            //    e.style.display = 'none';

            //} else {
            //    $(".popupdivWrapper").css("height", "600px");

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


        //우편번호 팝업
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

        //사업자번호 유효성검사
        function fnValidationComNo() {
            var comNo1 = $('#<%=lblFirstNum.ClientID %>').val();
            var comNo2 = $('#<%=lblMiddleNum.ClientID %>').val();
            var comNo3 = $('#<%=lblLastNum.ClientID %>').val();

            if (isEmpty(comNo1) || isEmpty(comNo2) || isEmpty(comNo3)) {
                alert("사업자번호를 입력해 주세요.");
                return false;
            }

            return true;
        }



    </script>
    <style type="text/css">
        .auto-style2 {
            height: 25px;
            position: relative;
            top: -2px;
            padding-left: 5px;
            left: 0px;
        }

        span {
            width: 150px;
            height: 40px;
        }
    </style>
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
            <div class="div-main-tab" style="width: 100%; ">
                <ul>
                    <li class='tabOff' style="width: 185px;" onclick="fnTabClickRedirect('SupplierMain');">
                        <a onclick="fnTabClickRedirect('SupplierMain');">공급업체 조회</a>
                     </li>
                    <li class='tabOn' style="width: 185px;" onclick="fnTabClickRedirect('SupplierRegister');">
                         <a onclick="fnTabClickRedirect('SupplierRegister');">공급업체 등록</a>
                    </li>
                </ul>
            </div>


            <div>
                <table>
                </table>
            </div>

            <div class="memberB-div" style="margin-top: 30px">
                <table class="tbl_main">
                    <colgroup>
                        <col style="width: 200px;" />
                        <col style="width: 800px" />
                    </colgroup>
                    <tr>
                        <th>업체코드</th>
                        <td>
                            <asp:TextBox runat="server" ID="ComCodeNo" Width="250px" CssClass="text-input"></asp:TextBox>
                            <asp:HiddenField runat="server" ID="hfComCodeNo" />
                            <span>＊자동 생성되는 코드입니다.</span>
                            <%--<input type="text" id="companyCode" class="text-code" style="width:250px;" placeholder="업체코드를 입력하세요"/>--%>
                        </td>
                    </tr>

                    <tr>
                        <th>업체명</th>
                        <td>
                            <asp:TextBox runat="server" ID="txtComName" Width="250px" CssClass="text-input"></asp:TextBox></td>
                    </tr>
                    <tr>
                        <th>사업자번호</th>
                        <td>
                            <%--                        <asp:TextBox ID="lblFirstNum" runat="server" Width="75" CssClass="text-input"></asp:TextBox>
                            &nbsp;-&nbsp;
                                    <asp:TextBox ID="lblMiddleNum" runat="server" Width="70" CssClass="text-input"></asp:TextBox>
                            &nbsp;-&nbsp;
                                    <asp:TextBox ID="lblLastNum" runat="server" Width="70" CssClass="text-input"></asp:TextBox></td>--%>

                            <asp:TextBox ID="lblFirstNum" runat="server" TextMode="Number" max="9999" oninput="return maxLengthCheck(this)" MaxLength="3" Width="75px" onkeypress="return onlyNumbers(event);" CssClass="text-input"></asp:TextBox>&nbsp;&nbsp;-&nbsp;
                        <asp:TextBox ID="lblMiddleNum" runat="server" TextMode="Number" max="9999" oninput="return maxLengthCheck(this)" MaxLength="2" Width="70px" onkeypress="return onlyNumbers(event);" CssClass="text-input"></asp:TextBox>&nbsp;&nbsp;-&nbsp;
                        <asp:TextBox ID="lblLastNum" runat="server" TextMode="Number" max="99999" oninput="return maxLengthCheck(this)" MaxLength="5" Width="70px" onkeypress="return onlyNumbers(event);" CssClass="text-input"></asp:TextBox>
                            <input type="hidden" name="hdComNo" id="hdComNo" value="1" />
                            <input type="button" class="mainbtn type1" style="width: 75px; height: 25px;" value="확인" onclick="CheckComNo();" />
                           <%-- <a onclick="CheckComNo()" class="zip">
                                <img src="../../images/sub_confirm_btn.jpg" /></a>--%>
                            <span>
                                <br />
                                ＊사업자번호나 고유번호를 입력해주세요.</span>
                        </td>
                    </tr>
                    <tr>
                        <th>대표자명</th>
                        <td>
                            <asp:TextBox ID="lblName" runat="server" Text="" CssClass="text-input" Width="250px"></asp:TextBox></td>
                    </tr>
                    <tr>
                        <th>업체담당자명</th>
                        <td>
                            <asp:TextBox ID="txtPerson" runat="server" CssClass="text-input" Width="250px"></asp:TextBox>
                            <asp:TextBox ID="lblDept" Visible="false" runat="server" Text="" CssClass="text-input" Width="250px"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <th>전화번호</th>
                        <td>

                            <asp:DropDownList ID="ddlTelPhone" runat="server" Width="70px" CssClass="auto-style2">
                                <asp:ListItem Text="02" Value="02"></asp:ListItem>
                                <asp:ListItem Text="070" Value="070"></asp:ListItem>
                                <asp:ListItem Text="031" Value="031"></asp:ListItem>
                                <asp:ListItem Text="032" Value="032"></asp:ListItem>
                                <asp:ListItem Text="033" Value="033"></asp:ListItem>
                                <asp:ListItem Text="041" Value="041"></asp:ListItem>
                                <asp:ListItem Text="042" Value="042"></asp:ListItem>
                                <asp:ListItem Text="043" Value="043"></asp:ListItem>
                                <asp:ListItem Text="051" Value="051"></asp:ListItem>
                                <asp:ListItem Text="052" Value="052"></asp:ListItem>
                                <asp:ListItem Text="053" Value="053"></asp:ListItem>
                                <asp:ListItem Text="054" Value="054"></asp:ListItem>
                                <asp:ListItem Text="055" Value="055"></asp:ListItem>
                                <asp:ListItem Text="061" Value="061"></asp:ListItem>
                                <asp:ListItem Text="062" Value="062"></asp:ListItem>
                                <asp:ListItem Text="063" Value="063"></asp:ListItem>
                                <asp:ListItem Text="064" Value="064"></asp:ListItem>
                                <asp:ListItem Text="지역번호 없음" Value="0"></asp:ListItem>
                            </asp:DropDownList>

                            <asp:Label runat="server" Text="&nbsp;&nbsp;-&nbsp;&nbsp;" CssClass="hyphen"></asp:Label>
                            <%--   <asp:TextBox ID="lblMiddleNumber" runat="server" Width="70px" CssClass="text-input"></asp:TextBox><asp:Label runat="server" Text="&nbsp;&nbsp;-&nbsp;&nbsp;" CssClass="hyphen"></asp:Label>
                            <asp:TextBox ID="lblLastNumber" runat="server" Width="70px" CssClass="text-input"></asp:TextBox></td>
                            --%>
                            <asp:TextBox ID="lblMiddleNumber" runat="server" Width="110px" max="99999" oninput="return maxLengthCheck(this)" MaxLength="5" TextMode="Number" onkeypress="return onlyNumbers(event);" CssClass="text-input"></asp:TextBox>&nbsp;&nbsp;-&nbsp;
                        <asp:TextBox ID="lblLastNumber" runat="server" Width="140px" max="99999" oninput="return maxLengthCheck(this)" MaxLength="5" TextMode="Number" onkeypress="return onlyNumbers(event);" CssClass="text-input"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <th>휴대전화번호</th>
                        <td>
                            <asp:DropDownList ID="ddlSelPhone" runat="server" Width="70px" CssClass="drop-mob">
                                <asp:ListItem Text="010" Value="010"></asp:ListItem>
                                <asp:ListItem Text="011" Value="011"></asp:ListItem>
                                <asp:ListItem Text="016" Value="016"></asp:ListItem>
                                <asp:ListItem Text="017" Value="017"></asp:ListItem>
                                <asp:ListItem Text="018" Value="018"></asp:ListItem>
                                <asp:ListItem Text="019" Value="019"></asp:ListItem>
                                <asp:ListItem Text="0130" Value="0130"></asp:ListItem>
                            </asp:DropDownList>
                            &nbsp;&nbsp;-&nbsp;&nbsp;
                    <%--                <asp:TextBox ID="txtSelPhone2" runat="server" Width="70px" MaxLength="4" TextMode="Number" onkeypress="return onlyNumbers(event);" CssClass="text-input"></asp:TextBox><asp:Label runat="server" Text="&nbsp;&nbsp;-&nbsp;"></asp:Label>
                            <asp:TextBox ID="txtSelPhone3" runat="server" Width="70px" MaxLength="4" TextMode="Number" onkeypress="return onlyNumbers(event);" CssClass="text-input"></asp:TextBox>--%>

                            <asp:TextBox ID="txtSelPhone2" runat="server" Width="110px" max="9999" oninput="return maxLengthCheck(this)" MaxLength="4" TextMode="Number" onkeypress="return onlyNumbers(event);" CssClass="text-input"></asp:TextBox>&nbsp;&nbsp;-&nbsp;
                            <asp:TextBox ID="txtSelPhone3" runat="server" Width="140px" max="9999" oninput="return maxLengthCheck(this)" MaxLength="4" TextMode="Number" onkeypress="return onlyNumbers(event);" CssClass="text-input"></asp:TextBox>

                        </td>
                    </tr>

                    <tr>
                        <th>FAX번호</th>
                        <td>
                            <asp:DropDownList ID="ddlFax" runat="server" Width="70px" CssClass="drop-mob">
                                <asp:ListItem Text="02" Value="02"></asp:ListItem>
                                <asp:ListItem Text="070" Value="070"></asp:ListItem>
                                <asp:ListItem Text="031" Value="031"></asp:ListItem>
                                <asp:ListItem Text="032" Value="032"></asp:ListItem>
                                <asp:ListItem Text="033" Value="033"></asp:ListItem>
                                <asp:ListItem Text="041" Value="041"></asp:ListItem>
                                <asp:ListItem Text="042" Value="042"></asp:ListItem>
                                <asp:ListItem Text="043" Value="043"></asp:ListItem>
                                <asp:ListItem Text="051" Value="051"></asp:ListItem>
                                <asp:ListItem Text="052" Value="052"></asp:ListItem>
                                <asp:ListItem Text="053" Value="053"></asp:ListItem>
                                <asp:ListItem Text="054" Value="054"></asp:ListItem>
                                <asp:ListItem Text="055" Value="055"></asp:ListItem>
                                <asp:ListItem Text="061" Value="061"></asp:ListItem>
                                <asp:ListItem Text="062" Value="062"></asp:ListItem>
                                <asp:ListItem Text="063" Value="063"></asp:ListItem>
                                <asp:ListItem Text="064" Value="064"></asp:ListItem>
                            </asp:DropDownList>
                            <asp:Label runat="server" Text="&nbsp;&nbsp;-&nbsp;&nbsp;" CssClass="hyphen"></asp:Label>
                            <%-- <asp:TextBox ID="lblMiddleFax" runat="server" Width="70px" CssClass="text-input"></asp:TextBox>--%>
                            <%--   <asp:TextBox ID="lblLastFax" runat="server" Width="70px" CssClass="text-input"></asp:TextBox>--%>

                            <asp:TextBox ID="lblMiddleFax" runat="server" Width="110px" TextMode="Number" max="99999" oninput="return maxLengthCheck(this)" MaxLength="5" onkeypress="return onlyNumbers(event);" CssClass="text-input"></asp:TextBox>
                            <asp:Label runat="server" Text="&nbsp;-&nbsp;" CssClass="hyphen"></asp:Label>
                            <asp:TextBox ID="lblLastFax" runat="server" Width="140px" TextMode="Number" max="99999" oninput="return maxLengthCheck(this)" MaxLength="5" onkeypress="return onlyNumbers(event);" CssClass="text-input"></asp:TextBox>


                        </td>
                    </tr>
                    <tr>
                        <th>이메일</th>
                        <td>
                            <%--                   <asp:TextBox ID="txtFirstEmail" runat="server" CssClass="text-input" Width="100"></asp:TextBox>&nbsp;@&nbsp;
                            <asp:TextBox ID="txtLastEmail" runat="server" CssClass="text-input" Width="117"></asp:TextBox>
                            <asp:DropDownList ID="dropDownListEmail" runat="server" CssClass="drop-email">
                                <asp:ListItem Value="direct" Text="-------직접입력------"></asp:ListItem>
                                <asp:ListItem Value="hanmail.net" Text="hanmail.net"></asp:ListItem>
                                <asp:ListItem Value="naver.com" Text="naver.com"></asp:ListItem>
                                <asp:ListItem Value="hotmail.com" Text="hotmail.com"></asp:ListItem>
                                <asp:ListItem Value="nate.com" Text="nate.com"></asp:ListItem>
                                <asp:ListItem Value="yahoo.co.kr" Text="yahoo.co.kr"></asp:ListItem>
                                <asp:ListItem Value="empas.com" Text="empas.com"></asp:ListItem>
                                <asp:ListItem Value="dreamwiz.com" Text="dreamwiz.com"></asp:ListItem>
                                <asp:ListItem Value="freechal.com" Text="freechal.com"></asp:ListItem>
                                <asp:ListItem Value="lycos.co.kr" Text="lycos.co.kr"></asp:ListItem>
                                <asp:ListItem Value="korea.com" Text="korea.com"></asp:ListItem>
                                <asp:ListItem Value="gmail.com" Text="gmail.com"></asp:ListItem>
                                <asp:ListItem Value="hanmir.com" Text="hanmir.com"></asp:ListItem>
                                <asp:ListItem Value="paran.com" Text="paran.com"></asp:ListItem>
                                <asp:ListItem Value="netsgo.com" Text="netsgo.com"></asp:ListItem>
                            </asp:DropDownList>--%>



                            <asp:TextBox ID="txtFirstEmail" runat="server" Width="100px" CssClass="text-input" onkeypress="return preventEnter(event);"></asp:TextBox>&nbsp;&nbsp;@&nbsp;
                        <asp:TextBox ID="txtLastEmail" runat="server" CssClass="text-input" Width="120" onkeypress="return preventEnter(event);"></asp:TextBox>
                            <asp:DropDownList ID="ddlEmail3" runat="server" CssClass="text-input" Width="160">
                                <asp:ListItem Value="direct" Text="-------직접입력------"></asp:ListItem>
                                <asp:ListItem Value="hanmail.net" Text="hanmail.net"></asp:ListItem>
                                <asp:ListItem Value="naver.com" Text="naver.com"></asp:ListItem>
                                <asp:ListItem Value="hotmail.com" Text="hotmail.com"></asp:ListItem>
                                <asp:ListItem Value="nate.com" Text="nate.com"></asp:ListItem>
                                <asp:ListItem Value="yahoo.co.kr" Text="yahoo.co.kr"></asp:ListItem>
                                <asp:ListItem Value="empas.com" Text="empas.com"></asp:ListItem>
                                <asp:ListItem Value="dreamwiz.com" Text="dreamwiz.com"></asp:ListItem>
                                <asp:ListItem Value="freechal.com" Text="freechal.com"></asp:ListItem>
                                <asp:ListItem Value="lycos.co.kr" Text="lycos.co.kr"></asp:ListItem>
                                <asp:ListItem Value="korea.com" Text="korea.com"></asp:ListItem>
                                <asp:ListItem Value="gmail.com" Text="gmail.com"></asp:ListItem>
                                <asp:ListItem Value="hanmir.com" Text="hanmir.com"></asp:ListItem>
                                <asp:ListItem Value="paran.com" Text="paran.com"></asp:ListItem>
                                <asp:ListItem Value="netsgo.com" Text="netsgo.com"></asp:ListItem>
                            </asp:DropDownList>
                        </td>
                    </tr>
                    <tr>
                        <th>주&nbsp;&nbsp;소</th>
                        <td>
                            <asp:TextBox ID="txtPostalCode" runat="server" ReadOnly="true" CssClass="text-readonly" Width="105px"></asp:TextBox>
                            <asp:HiddenField ID="hfPostalCode" runat="server" />
                            <input type="button" class="mainbtn type1" style="width: 105px; height: 25px;" value="우편번호 검색" onclick="openPostcode();" />

                            <%--<a onclick="openPostcode()" class="zip">
                                <img src="../../images/zipSear_btn.jpg" /></a>--%>
                        </td>
                    </tr>

                    <tr>
                        <th></th>
                        <td>
                            <asp:TextBox ID="txtAddress1" runat="server" Width="400px" ReadOnly="true" CssClass="text-readonly"></asp:TextBox>
                            <asp:HiddenField ID="hfAddress1" runat="server" />
                            <asp:TextBox ID="txtAddress2" runat="server" Width="300px" CssClass="text-readonly"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <th>은행명</th>
                        <td>
                            <asp:TextBox runat="server" ID="txtBankName" CssClass="text-input" Width="250px" Style="margin-right: 5px"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <th>예금주</th>
                        <td>
                            <asp:TextBox runat="server" ID="txtSupplyBankName" CssClass="text-input" Width="250px" Style="margin-right: 5px"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <th>계좌번호</th>
                        <td>
                            <asp:TextBox runat="server" ID="txtBankNo" CssClass="text-input" Width="250px" Style="margin-right: 5px"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <th>거래등록일</th>
                        <td>
                            <asp:TextBox runat="server" ID="SupplyDate" ReadOnly="true" CssClass="text-input" Width="250px" Style="margin-right: 5px"></asp:TextBox>

                            <%--<asp:TextBox  ID="SupplyDate" runat="server" CssClass="text-input" Width="250px"></asp:TextBox>--%></td>
                    </tr>


                    <tr>
                        <th>결제일자</th>
                        <td>
                            <asp:TextBox runat="server" ID="PayDate" CssClass="text-input" Width="250px" Style="margin-right: 5px"></asp:TextBox>

                            <%--<asp:TextBox  ID="SupplyDate" runat="server" CssClass="text-input" Width="250px"></asp:TextBox>--%></td>
                    </tr>


                    <tr>
                        <th>카테고리 </th>
                        <td>
                            <asp:Label runat="server" ID="lblLevel1" Text=" 1단 " Width="180px" Height="30px"></asp:Label>
                            <asp:Label runat="server" ID="lblLevel2" Text=" 2단 " Width="180px" Height="30px"></asp:Label>
                            <asp:Label runat="server" ID="lblLevel3" Text=" 3단 " Width="180px" Height="30px"></asp:Label>
                            <asp:Label runat="server" ID="lblLevel4" Text=" 4단 " Width="180px" Height="30px"></asp:Label>
                            <asp:Label runat="server" ID="lblLevel5" Text=" 5단 " Width="180px" Height="30px"></asp:Label>
                            <input type="hidden" id="txtCaLevel1" name="txtCaLevel1">
                            <input type="hidden" id="txtCaLevel2" name="txtCaLevel2">
                            <input type="hidden" id="txtCaLevel3" name="txtCaLevel3">
                            <input type="hidden" id="txtCaLevel4" name="txtCaLevel4">
                            <input type="hidden" id="txtCaLevel5" name="txtCaLevel5">

                            <asp:HiddenField ID="categoryCode" runat="server"></asp:HiddenField>

                            <%--                            <asp:TextBox ID="txtCaLeve1" runat="server"></asp:TextBox>
                            <asp:TextBox ID="txtCaLeve2" runat="server"></asp:TextBox>
                            <asp:TextBox ID="txtCaLeve3" runat="server"></asp:TextBox>
                            <asp:TextBox ID="txtCaLeve4" runat="server"></asp:TextBox>
                            <asp:TextBox ID="txtCaLeve5" runat="server"></asp:TextBox>--%>

                            <br />
                            <select style="width:180px" id="Category01" onchange="fnChangeSubCategoryBind(this,2); return false;">
                                <option value="All">---전체---</option>
                            </select>
                            <select style="width:180px" id="Category02" onchange="fnChangeSubCategoryBind(this,3); return false;">
                                <option value="All">---전체---</option>

                            </select>
                            <select style="width:180px" id="Category03" onchange="fnChangeSubCategoryBind(this,4); return false;">
                                <option value="All">---전체---</option>

                            </select>
                            <select style="width:180px" id="Category04" onchange="fnChangeSubCategoryBind(this,5); return false;">
                                <option value="All">---전체---</option>

                            </select>
                            <select style="width:180px" id="Category05" onchange="fnChangeSubCategoryBind(this,6); return false;">
                                <option value="All">---전체---</option>

                            </select>
                        </td>
                    </tr>


                    <%--  <tr>
                        <th>1단 카테고리</th>
                        <th>2단 카테고리</th>
                        <th>3단 카테고리</th>
                        <th>4단 카테고리</th>
                        <th>5단 카테고리</th>
                    </tr>--%>
                    <%-- <tr id="ctgrSearchTr">
                        <td>
                            <asp:DropDownList runat="server" ID="ddlCtgrLevel_1" CssClass="input-drop" AutoPostBack="true" OnSelectedIndexChanged="ddlCtgrLevel_1_Changed">
                            </asp:DropDownList>
                        </td>
                        <td>
                            <asp:DropDownList runat="server" ID="ddlCtgrLevel_2" CssClass="input-drop" AutoPostBack="true" OnSelectedIndexChanged="ddlCtgrLevel_2_Changed">
                            </asp:DropDownList>
                        </td>
                        <td>
                            <asp:DropDownList runat="server" ID="ddlCtgrLevel_3" CssClass="input-drop" AutoPostBack="true" OnSelectedIndexChanged="ddlCtgrLevel_3_Changed">
                            </asp:DropDownList>
                        </td>
                        <td>
                            <asp:DropDownList runat="server" ID="ddlCtgrLevel_4" CssClass="input-drop" AutoPostBack="true" OnSelectedIndexChanged="ddlCtgrLevel_4_Changed">
                            </asp:DropDownList>
                        </td>
                        <td>
                            <asp:DropDownList runat="server" ID="ddlCtgrLevel_5" CssClass="input-drop" AutoPostBack="true">
                            </asp:DropDownList>
                        </td>
                    </tr>
                    --%>

                    <tr id="trAdmUserId">
                        <th>소셜위드 관리 담당자 ID</th>
                        <td>
                            <%--<input type="hidden" id="hdAdmUserId" />
                            <span id="spAdmUserId"></span>--%>

                            <input class="txtCompManagement" id="txtAdmUserId" onkeypress="return fnEnter()" type="text" readonly="readonly" style="width:300px">
                            <input type="button" class="mainbtn type1" value="검색" style="width:75px;" onclick="return fnSearchAdmUserIdPopup()" />

                            <asp:HiddenField ID="hfAdmUserId" runat="server" />
                            <asp:HiddenField ID="hfAdmUserNm" runat="server" />
                            <asp:HiddenField ID="hfFinalCode" runat="server" />
                        </td>
                    </tr>

                    <tr>
                        <th>소셜위드 관리 담당자명</th>
                        <td>
                            <input class="txtCompManagement" id="spAdmUserNm" onkeypress="return fnEnter()" type="text" readonly="readonly" style="width:300px">
                        </td>
                    </tr>
                </table>

            </div>

            <!--저장버튼-->
            <div class="btn_center">
                <asp:Button ID="btnSave" runat="server" Width="95" Height="30" Text="저장" OnClientClick="return fnValidationComNo();" OnClick="btnSave_Click" CssClass="mainbtn type1"/>
                <%--<asp:ImageButton runat="server" ImageUrl="../Images/Member/save.jpg" AlternateText="저장" onmouseover="this.src='../Images/Member/save-on.jpg'" onmouseout="this.src='../Images/Member/save.jpg'" OnClick="save_click" />--%>
            </div>
            <!--저장버튼끝-->


        </div>
    </div>


    <div id="admUserIdSearchDiv" class="popupdiv divpopup-layer-package">
        <div class="popupdivWrapper" style="width: 650px;">
            <div class="popupdivContents">

                <div class="close-div">
                    <a onclick="fnClosePopup('admUserIdSearchDiv'); return false;" style="cursor: pointer">
                        <img src="../../Images/Wish/icon-delete.jpg" alt="닫기" style="float: right;" /></a>
                </div>
                <div class="sub-title-div">
                    <h3 class="pop-title">소셜위드 관리 담당자 조회</h3>
                </div>
                <div class="popup-title">
                    <%--<img src="../Images/Goods/supplierRegister-title.jpg" alt="소셜위드 관리 담당자 조회" />--%>

                    <div class="search-div" style="margin-bottom: 20px;">
                        <select id="ddlPopSearch2" name="ddlPopSearch2" class="selectCompManagement" onclick="checkOnly(this);">
                            <option value="Name">이름</option>
                            <option value="Id">아이디</option>
                        </select>
                        <input type="text" class="text-code" id="txtPopSearch2" placeholder="검색어를 입력해 주세요." onkeypress="return fnEnter();" style="width: 300px" />
                        <input type="button" class="mainbtn type1" style="width: 75px; height: 25px;" value="검색" onclick="fnAdmUserIdSearch(1); return false;" />
                        <%--<a class="imgA" onclick="fnAdmUserIdSearch(1); return false;">
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

                        <input type="button" class="mainbtn type2" style="width: 95px; height: 30px;" value="취소" onclick="fnClosePopup('admUserIdSearchDiv'); return false;" />
                        <input type="button" class="mainbtn type1" style="width: 95px; height: 30px;" value="확인" onclick="fnPopupOkAdmUserId(); return false;" />


                       <%-- <a onclick="fnClosePopup('admUserIdSearchDiv'); return false;">
                            <img src="../../Images/cancle_btn.jpg" alt="취소" onmouseover="this.src='../../Images/cancle_on_btn.jpg'" onmouseout="this.src='../../Images/cancle_btn.jpg'" /></a>
                        <a onclick="fnPopupOkAdmUserId(); return false;">
                            <img src="../Images/Goods/submit1-off.jpg" alt="확인" onmouseover="this.src='../Images/Goods/submit1-on.jpg'" onmouseout="this.src='../Images/Goods/submit1-off.jpg'" /></a>--%>
                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
