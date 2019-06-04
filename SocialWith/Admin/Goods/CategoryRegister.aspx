<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Master/AdminMasterPage.master" AutoEventWireup="true" CodeFile="CategoryRegister.aspx.cs" Inherits="Admin_Goods_CategoryRegister" %>
<%@ Register Src="~/UserControl/ucListControl.ascx" TagName="ListPager" TagPrefix="ucPager" %>
<%@ Import Namespace="Urian.Core" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
   <link href="../Content/Goods/goods.css" rel="stylesheet" />
    <style>
        /*호버로 TD만 색상변화*/
        #tblHeader td:hover {
            background-color: gainsboro
        }
    </style>
    <script type="text/javascript">
        $(document).ready(function () {
            fnCategoryBind();
        });


        function fnChangeSubCategoryBind(el, level) {
            var levelStr = "";

            $("#hdChkSelf").val("0");
            $("input[id^=CategoryName]").attr("readonly", true);
            $("input[id^=CategoryName]").css('background-color', '#ececec');

            var selectedVal = $(el).val();

            //전체 선택 시
            if (selectedVal == "All") {
                level = parseInt(level) - 1;

                var tmpUpLevel = level - 1;
                selectedVal = $("#CategoryCode0" + tmpUpLevel).val();
            }

            //el = 코드
            //level은 depth

          <%--  $("#<%=hfFinalCode.ClientID%>").val(level);--%>
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

            switch (parseInt(level)) {
                case 2:
                    levelStr = "B";
                    break;
                case 3:
                    levelStr = "C";
                    break;
                case 4:
                    levelStr = "D";
                    break;
                case 5:
                    levelStr = "E";
                    break;
                case 6:
                    levelStr = "E";
                    break;
                default :
                    levelStr = "ERR";
                    break;
            }
            
            if (levelStr == "ERR") {
                alert("올바르지 않은 코드값이 존재합니다. 개발 담당자에게 문의바랍니다.");
                return false;
            }

            for (var i = level; i < 10; i++) {
                fnSelectBoxClear(i);
            }

            var callback = function (response) {

                if (!isEmpty(response)) {

                    var ddlHtml = "";
                    var LastCode = 1;
                    var CategoryFinalCode = "";
                    var CategoryFinalName = "";

                    $.each(response, function (key, value) {
                        ddlHtml += '<option value="' + value.CategoryFinalCode + '">' + value.CategoryFinalName + '</option>';
                        if (CategoryFinalCode > value.CategoryFinalCode) {

                        }
                        else {

                            CategoryFinalCode = value.CategoryFinalCode;
                        }
                        CategoryFinalName = value.CategoryFinalName;
                    });

                    //CategoryFinalCode = String(parseInt(CategoryFinalCode) + parseInt(LastCode));
                    //CategoryFinalCode = CategoryFinalCode.substr(value.CategoryFinalCode.length - 3);

                    var LastCodeP = parseInt(CategoryFinalCode.substr(CategoryFinalCode.length - 3));
                    ++LastCodeP;
                    var nextCode = LastCodeP < 10 ? "0" + LastCodeP + levelStr : LastCodeP + levelStr;

                    //var LastCodeP = CategoryFinalCode.substring(CategoryFinalCode.length, CategoryFinalCode.length - 2);

                    $("#hdLastCode").val(nextCode);
                    //  var LastCateCode = CategoryFinalCode.substring(CategoryFinalCode.length, CategoryFinalCode.length - 2);
                    //alert(LastCateCode)

                    var id = '';

                    if (level == '10') {
                        id = level;
                    }
                    else {
                        id = '0' + level;
                    }

                    $("#ddlCategory" + id).append(ddlHtml);
                }
                else {
                    $("#hdLastCode").val("01"+levelStr)
                }

                var Sval1 = $("#ddlCategory01 option:selected").val();
                var Stext1 = $("#ddlCategory01 option:selected").text();
                $("#CategoryCode01").val(Sval1)
                $("#CategoryName01").val(Stext1)

                var Sval2 = $("#ddlCategory02 option:selected").val();
                var Stext2 = $("#ddlCategory02 option:selected").text();
                $("#CategoryCode02").val(Sval2)
                $("#CategoryName02").val(Stext2)

                var Sval3 = $("#ddlCategory03 option:selected").val();
                var Stext3 = $("#ddlCategory03 option:selected").text();
                $("#CategoryCode03").val(Sval3)
                $("#CategoryName03").val(Stext3)

                var Sval4 = $("#ddlCategory04 option:selected").val();
                var Stext4 = $("#ddlCategory04 option:selected").text();
                $("#CategoryCode04").val(Sval4)
                $("#CategoryName04").val(Stext4)

                var Sval5 = $("#ddlCategory05 option:selected").val();
                var Stext5 = $("#ddlCategory05 option:selected").text();
                $("#CategoryCode05").val(Sval5)
                $("#CategoryName05").val(Stext5)

                for (i = 1; i < 6; i++) {
                    var j = i - 1;

                    if ($("#ddlCategory0" + i).val() == 'All') {
                        $("#CategoryCode0" + i).val('')
                        $("#CategoryName0" + i).val('')


                        //< input type = "text" id = "hdFinalCode" />
                        //    <input type="text" id="hdGroupCode" />
                        //    <input type="text" id="hdLevelCode" />
                    }
                    else {
                        $("#hdFinalCode").val($("#CategoryCode0" + i).val())
                        $("#hdFinalName").val($("#CategoryName0" + i).val())
                        $("#hdGroupCode").val($("#CategoryCode0" + j).val())
                        $("#hdLevelCode").val(i);


                    }
                }

                return false;
            };

            var sUser = '<%=Svid_User %>';
            var param = {
                LevelCode: level,
                UpCode: selectedVal,
                Method: 'GetCategoryLevelRegister'
            };



         <%--   $("#<%=categoryCode.ClientID%>").val(selectedVal);--%>

            $("#txtCaLevel" + level).val(selectedVal);
            var applyLevel1 = $("#txtCaLevel1").val();
            var applyLevel2 = $("#txtCaLevel2").val();          //레벨1
            var applyLevel3 = $("#txtCaLevel3").val();          //레벨2
            var applyLevel4 = $("#txtCaLevel4").val();          //레벨3
            var applyLevel5 = $("#txtCaLevel5").val();          //레벨4


            JajaxSessionCheck('Post', '../../Handler/Common/CategoryHandler.ashx', param, 'json', callback, '<%=Svid_User %>');

        }


        function fnCategoryBind() {
            fnSelectBoxClear(1);
            var callback = function (response) {

                if (!isEmpty(response)) {
                    var ddlHtml = "";
                    var CategoryFinalCode = "";
                    var CategoryFinalName = "";

                    $.each(response, function (key, value) {

                        ddlHtml += '<option value="' + value.CategoryFinalCode + '">' + value.CategoryFinalName + '</option>';
                        CategoryFinalCode = value.CategoryFinalCode;
                        CategoryFinalName = value.CategoryFinalName;
                    });

                    $("#ddlCategory01").append(ddlHtml);
                    //$("#CategoryCode01").val(CategoryFinalCode);
                    //$("#CategoryName01").val(CategoryFinalName);
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

        function fnNewInsert(chk) {
            if (chk == '01') {
                alert('1단 카테고리는 등록이 불가합니다.')
                return false;
            }

            if ($("#hdChkSelf").val() != '0') {
                alert('하나의 카테고리만 직접 입력할 수 있습니다.')
                return false;
            }
            if ($("#CategoryName" + chk).val() != '')
            {
                alert('이전 단 수정이 불가합니다. 새로 카테고리 등록을 진행해주세요.')
                return false;
            }
            //if ($("#CategoryName" + chk.val()) != '') {
            //}



            $("#CategoryCode" + chk).val('');
            //  $("#CategoryCode" + chk).attr("readonly", false);
            $("#CategoryName" + chk).attr("readonly", false);
            //  $("#CategoryCode" + chk).attr("readonly", false);

            // $("#CategoryCode" + chk).css('background-color', 'white');
            $("#CategoryName" + chk).css('background-color', 'white');

            $("#CategoryCode" + chk).val($("#hdFinalCode").val() + $("#hdLastCode").val());
            $("#hdChkSelf").val(chk)


        }


        function fnSave() {

            var saveChk = $("#hdChkSelf").val();
            if (saveChk != '0') {
                $("#hdFinalName").val($("#CategoryName" + saveChk).val());

            }

            else {

            }

            var levelCode = $("#hdChkSelf").val();
            levelCode = levelCode.replace('0', '');

            $("#<%=hdfFinalCode.ClientID%>").val($("#hdFinalCode").val() + $("#hdLastCode").val());
            $("#<%=hdfGroupCode.ClientID%>").val($("#hdFinalCode").val());
            $("#<%=hdfLevelCode.ClientID%>").val(levelCode);
            $("#<%=hdfFinalName.ClientID%>").val($("#hdFinalName").val());
            return true;
        }


        function fnEnter() {

            if (event.keyCode == 13) {
                alert('엔터 키 사용 불가');
                return false;
            }
            else
                return true;
        }
        //페이지 이동
        function fnGoPage(pageVal) {
            switch (pageVal) {
                case "GOODS":
                    window.location.href = "../Goods/GoodsRegister";
                    break;
                case "BRAND":
                    window.location.href = "../Goods/BrandMain";
                    break;
                default:
                    break;
            }
        }

    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div class="all">

        <div class="sub-contents-div" style="min-height: 1200px;">
            <div class="sub-title-div">
                <p class="p-title-mainsentence">
                    카테고리 관리
                    <span class="span-title-subsentence">카테고리 메뉴를 추가 및 삭제 관리 할 수 있습니다.</span>
                </p>
            </div>


            <!--탭영역-->
            <div class="div-main-tab" style="width: 100%; ">
                <ul>
                    <li class='tabOff' style="width: 185px;" onclick="fnTabClickRedirect('CategoryManage');">
                        <a onclick="fnTabClickRedirect('CategoryManage');">카테고리 관리</a>
                     </li>
                    <li class='tabOn' style="width: 185px;" onclick="fnTabClickRedirect('CategoryRegister');">
                         <a onclick="fnTabClickRedirect('CategoryRegister');">카테고리 등록</a>
                    </li>
                     <li class='tabOff' style="width: 185px;" onclick="fnTabClickRedirect('CategoryRankManagement');">
                         <a onclick="fnTabClickRedirect('CategoryRankManagement');">카테고리 Rank</a>
                    </li>
                </ul>
            </div>

            <div style="padding-bottom:15px">
                    <div style="float:left">
                         <input type="button" class="mainbtn type1" style="width: 105px; height: 30px;" value="상품 관리" onclick="fnGoPage('GOODS')" />
                         <input type="button" class="mainbtn type1" style="width: 105px; height: 30px;" value="브랜드 관리" onclick="fnGoPage('BRAND')" />
                    </div>
            </div>
            <br />
            <br />
            <!--검색 영역-->
            <table class="tbl_main">
                <tr>
                    <th style="width: 20%">1단 카테고리</th>
                    <th style="width: 20%">2단 카테고리</th>
                    <th style="width: 20%">3단 카테고리</th>
                    <th style="width: 20%">4단 카테고리</th>
                    <th style="width: 20%">5단 카테고리</th>
                </tr>
                <tr>
                    <td>
                        <select class="medium-size" id="ddlCategory01" onchange="fnChangeSubCategoryBind(this,2); return false;">
                            <option value="All">---전체---</option>
                        </select>
                    </td>

                    <td>
                        <select class="medium-size" id="ddlCategory02" onchange="fnChangeSubCategoryBind(this,3); return false;">
                            <option value="All">---전체---</option>
                        </select>
                    </td>
                    <td>
                        <select class="medium-size" id="ddlCategory03" onchange="fnChangeSubCategoryBind(this,4); return false;">
                            <option value="All">---전체---</option>
                        </select>

                    </td>
                    <td>
                        <select class="medium-size" id="ddlCategory04" onchange="fnChangeSubCategoryBind(this,5); return false;">
                            <option value="All">---전체---</option>

                        </select>
                    </td>
                    <td>
                        <select class="medium-size" id="ddlCategory05" onchange="fnChangeSubCategoryBind(this,6); return false;">
                            <option value="All">---전체---</option>

                        </select>
                    </td>
                </tr>
            </table>
            <br />
            <br />

            <table class="tbl_main">
                <tr>
                    <th>1단 카테고리 코드</th>
                    <td>
                        <input type="text" id="CategoryCode01" class="medium-size" readonly /></td>
                    <th>1단 카테고리 명</th>
                    <td>
                        <input type="text" class="medium-size" readonly id="CategoryName01" onkeypress="return fnEnter();" /></td>
                    <td>
                        <input type="button" class="btnDelete" value="직접입력" onclick="fnNewInsert('01')" />
                    </td>
                </tr>

                <tr>
                    <th>2단 카테고리 코드</th>
                    <td>
                        <input type="text" class="medium-size" readonly id="CategoryCode02" /></td>
                    <th>2단 카테고리 명</th>
                    <td>
                        <input type="text" class="medium-size" readonly id="CategoryName02" onkeypress="return fnEnter();" /></td>
                    <td>
                        <input type="button" class="btnDelete" value="직접입력" onclick="fnNewInsert('02')" />
                    </td>
                </tr>

                <tr>
                    <th>3단 카테고리 코드</th>
                    <td>
                        <input type="text" class="medium-size" readonly id="CategoryCode03" /></td>
                    <th>3단 카테고리 명</th>
                    <td>
                        <input type="text" class="medium-size" readonly id="CategoryName03" onkeypress="return fnEnter();" /></td>
                    <td>
                        <input type="button" class="btnDelete" value="직접입력" onclick="fnNewInsert('03')" />
                    </td>
                </tr>

                <tr>
                    <th>4단 카테고리 코드</th>
                    <td>
                        <input type="text" class="medium-size" readonly id="CategoryCode04" /></td>
                    <th>4단 카테고리 명</th>
                    <td>
                        <input type="text" class="medium-size" readonly id="CategoryName04" onkeypress="return fnEnter();" /></td>
                    <td>
                        <input type="button" class="btnDelete" value="직접입력" onclick="fnNewInsert('04')" />
                    </td>
                </tr>

                <tr>
                    <th>5단 카테고리 코드</th>
                    <td>
                        <input type="text" class="medium-size" readonly id="CategoryCode05" /></td>
                    <th>5단 카테고리 명</th>
                    <td>
                        <input type="text" class="medium-size" readonly id="CategoryName05" onkeypress="return fnEnter();" /></td>
                    <td>
                        <input type="button" class="btnDelete" value="직접입력" onclick="fnNewInsert('05')" />
                    </td>
                </tr>

            </table>
            
            <br />
            <div style="float: right">
                <input type="hidden" id="hdFinalCode" />
                <%--선택한 카테고리 코드 --%>
                <input type="hidden" id="hdGroupCode" />
                <%--  상위 그룹 코드--%>
                <input type="hidden" id="hdLevelCode" />
                <%-- 카테고리 레벨--%>
                <input type="hidden" id="hdFinalName" />
                <%--카테고리 이름--%>
                <input type="hidden" id="hdLastCode" />
                <%--카테고리 마지막 코드--%>
                <input type="hidden" id="hdChkSelf" value="0" />
                <asp:HiddenField ID="hdfFinalCode" runat="server" Value="" />
                <asp:HiddenField ID="hdfGroupCode" runat="server" Value="" />
                <asp:HiddenField ID="hdfLevelCode" runat="server" Value="" />
                <asp:HiddenField ID="hdfFinalName" runat="server" Value="" />

                <%--직접입력 여부 --%>
                <asp:Button ID="btnSave" runat="server" Width="95" Height="30" Text="저장" OnClientClick="fnSave();" OnClick="btnSave_Click" CssClass="mainbtn type1"/>
                <%--<asp:ImageButton runat="server" ImageUrl="../Images/Member/save.jpg" AlternateText="저장" onmouseover="this.src='../Images/Member/save-on.jpg'" onmouseout="this.src='../Images/Member/save.jpg'" OnClientClick="fnSave();" OnClick="save_click" />--%>
            </div>
        </div>
    </div>
</asp:Content>
