<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Master/AdminMasterPage.master" AutoEventWireup="true" CodeFile="GoodsCodeRank.aspx.cs" Inherits="Admin_Goods_GoodsCodeRank" EnableEventValidation="false" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <link href="../Content/Order/common.css" rel="stylesheet" />
    <link href="../Content/Goods/goods.css" rel="stylesheet" />
    <link href="../Content/Company/company.css" rel="stylesheet" />
    <style>
        #selectTarget {
            width: 100px;
            height: 25px;
        }

        td.txt-center {
            height: 25px;
        }
        /*on 클래스 클릭시 색변경*/
        .on {
            background-color: #F5F5F5;
        }
    </style>
    <script>

        //상품코드 Rank 변경 
        $(function () {

            $("#tblGroupList").on("click", "tr", function (e) {
                $('tr').removeClass('on');

                var tr = $(this); //클릭한 그거
                var td = tr.children(); //클릭한 tr의 자식


                var code1 = td.parent().find('.tdCode').text(); //첫번째
                var name1 = td.parent().find('.tdName').text(); //두번째
                var num1 = td.parent().find('.tdRank').text(); //세번째 
                $('#hdBaseRank').val(num1);  //기존 Rank를 히든필드에 넣어둠(스위칭을 위함)

                if (tr.hasClass('groupTr')) {
                    tr.addClass('on');
                    $('#codeModify').text(code1); //넣어주기
                    $('#nameModify').text(name1); //넣어주기
                    $('#rankModify').val(num1);
                }
            });// on() end

        });//$function end

        function fnSearchClick() { //검색 버튼 클릭시 

            var callback = function (response) {
               // $("#tblGroupList").empty();

                var selectedValue = $('#ddlSearchTarget').val();

                if (selectedValue == 'name') {
                    $('#categoryTitle').empty().append('말단 카테고리 명 : <span class="category-name" id="categoryFinalName"></span>');
                } else {
                    $('#categoryTitle').empty().append('말단 카테고리 코드 : <span class="category-name" id="categoryFinalName"></span>');
                }

                if (!isEmpty(response)) {

                    var groupList = "";
                    $.each(response, function (key, value) {

                        $('#categoryFinalName').text("");
                        $('#categoryFinalName').text(value.GoodsFinalCategoryName);

                        groupList += "<tr class='groupTr'>"
                        groupList += "<td class='tdCode'>" + value.GoodsCode + "</td>"
                        groupList += "<td class='tdName'>" + value.GoodsFinalName + "</td>"
                        groupList += "<td class='tdRank'>" + value.GoodsCodeRank + "</td>"
                        groupList += "</tr>"
                    });//each() end

                    $("#tblGroupList").empty().append(groupList);
                    $('#tblGroupList').children().css('cursor', 'pointer');

                } else {

                    groupList += "<tr >"
                    groupList += "<td colspan='3' >조회된 데이터가 없습니다.</td>"
                    groupList += "</tr>"
                    $("#tblGroupList").empty().append(groupList);
                    $('#categoryFinalName').text(" 없는 카테고리 입니다.");

                } //if~else end

                return false;

            }; // var callback

            var param = {
                SearchTarget: $('#ddlSearchTarget').val(),
                SearchKeyword: $('#txtGoodsSearch').val(),
                Method: 'GetGoodsCodeListByCategory'
            };

            JqueryAjax('Post', '../../Handler/GoodsHandler.ashx', true, false, param, 'json', callback, null, null, true, '<%=Svid_User%>');
        } // fnSearchClick() end

        //엔터눌렀을시 검색 작동
        function fnGoodsSearchEnter() {
            if (event.keyCode == 13) {
                fnSearchClick();
                return false;
            }// if end

        }// fnGoodsSearchEnter() end

        // 검색창 공백제거
        function removeSpace(obj) {
            var removeS = $('#txtGoodsSearch').val().replace(/\s/gi, "");
            $('#txtGoodsSearch').val(removeS);
        }// removeSpace end 

        //저장 버튼 눌렀을때 
        function fnUpdateRank() {

            if ($('#rankModify').val() != 0) {
                var callback = function (response) {

                    if (response == 'OK') {
                        alert("Rank 순위가 변경되었습니다.");
                        fnSearchClick();

                    } else {
                        alert('시스템 오류입니다. 관리자에게 문의하세요.');
                    }
                    return false;


                }; // var callback

                var param = {
                    GoodsCodeRank: $('#rankModify').val(),
                    BaseRank: $('#hdBaseRank').val(),
                    GoodsCode: $('#codeModify').text(),
                    Method: 'UpdateGoodsCodeRank'

                };

                JqueryAjax('Post', '../../Handler/GoodsHandler.ashx', true, false, param, 'text', callback, null, null, true, '<%=Svid_User%>')
            } else {
                alert("Rank 순위가 잘못되었습니다. 다시 입력해주세요.");
                $('#rankModify').focus();
            }
        }
        //숫자만 입력되게 막아놓기
        function numberKey(event) {
            event = event || window.event;
            var keyID = (event.which) ? event.which : event.keyCode;
            if ((keyID >= 48 && keyID <= 57) || (keyID >= 96 && keyID <= 105) || keyID == 8 || keyID == 46 || keyID == 37 || keyID == 39 || keyID == 13)
                return;
            else
                return false;
        }
        function removeChar(event) {
            event = event || window.event;
            var keyID = (event.which) ? event.which : event.keyCode;
            if (keyID == 8 || keyID == 46 || keyID == 37 || keyID == 39 || keyID == 13)
                return;
            else
                event.target.value = event.target.value.replace(/[^0-9]/g, "");
        }

        //엔터눌렀을시 검색 작동
        function fnGoodsUpdateEnter() {
            if (event.keyCode == 13) {
                fnUpdateRank();
                return false;
            }// if end
        }// fnGoodsUpdateEnter() end

    </script>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div class="all">

        <div class="sub-contents-div" style="min-height: 1500px">
            <div class="sub-title-div">
                <p class="p-title-mainsentence">
                    상품등록
                    <span class="span-title-subsentence"></span>
                </p>
            </div>


            <!--탭영역-->
            <div class="div-main-tab" style="width: 100%;">
                <ul>
                    <li class='tabOff' style="width: 185px;" onclick="fnTabClickRedirect('GoodsRegister');">
                        <a onclick="fnTabClickRedirect('GoodsRegister');">상품등록</a>
                    </li>
                    <li class='tabOff' style="width: 185px;" onclick="fnTabClickRedirect('GoodsModify');">
                        <a onclick="fnTabClickRedirect('GoodsModify');">상품수정</a>
                    </li>
                    <li class='tabOff' style="width: 185px;" onclick="fnTabClickRedirect('GoodsServiceRegister');">
                         <a onclick="fnTabClickRedirect('GoodsCodeRank');">서비스용역등록</a>
                    </li>
                    <li class='tabOff' style="width: 185px;" onclick="fnTabClickRedirect('GoodsServiceModify');">
                         <a onclick="fnTabClickRedirect('GoodsCodeRank');">서비스용역수정</a>
                    </li>
                    <li class='tabOff' style="width: 185px;" onclick="fnTabClickRedirect('GoodsGroupCodeRank');">
                        <a onclick="fnTabClickRedirect('GoodsGroupCodeRank');">그룹코드 Rank</a>
                    </li>
                    <li class='tabOn' style="width: 185px;" onclick="fnTabClickRedirect('GoodsCodeRank');">
                        <a onclick="fnTabClickRedirect('GoodsCodeRank');">상품코드 Rank</a>
                    </li>
                </ul>
            </div>
            <asp:Label ID="lblErrorMsg" runat="server"></asp:Label>
            <div class="bottom-search-div" style="margin-bottom: 20px">
                <table class="tbl_search">
                    <tr>
                        <td style="width: 200px; text-align: right;">
                            <select id="ddlSearchTarget">
                                <option value="name">말단 카테고리 명</option>
                                <option value="code">말단 카테고리 코드</option>
                            </select>
                        </td>
                        <td>
                            <input type="text" placeholder="검색어를 입력하세요." style="width: 65%" id="txtGoodsSearch" onkeyup="removeSpace(this);" onkeypress="return fnGoodsSearchEnter();" />
                            <button class="mainbtn type1" style="width: 95px; height: 30px;" onclick="fnSearchClick(); return false;">검색</button>
                        </td>
                    </tr>
                </table>

                <h4 class="sub-title" id="categoryTitle">말단 카테고리 명 : <span class="category-name" id="categoryFinalName">카테고리를 검색해주세요.</span></h4>
                <!--카테고리 Rank 구조-->
                <div class="category-rank">
                    <div class="category-rank-columns">
                        <p class="category-rank-title">상품코드 Rank 구조</p>
                        <div class="rank-div">
                            <table class="tbl_main">
                                <colgroup>
                                    <col style="width: 30%" />
                                    <col style="width: 50%" />
                                    <col />
                                </colgroup>
                                <thead>
                                    <tr>
                                        <th>상품코드</th>
                                        <th>상품명</th>
                                        <th>Rank No</th>
                                    </tr>
                                </thead>
                                <tbody id="tblGroupList">
                                    <tr>
                                        <td colspan="3">조회된 데이터가 없습니다.</td>
                                    </tr>
                                </tbody>
                            </table>
                            <span style="color: #69686d; float: left; margin-top: 10px; margin-bottom: 5px;"><b style="color: #ec2029; font-weight: bold;">상품을 클릭해주세요</b></span>
                        </div>
                    </div>
                    <div class="category-rank-columns">
                        <p class="category-rank-title">상품코드 Rank 변경</p>
                        <div class="rank-div">
                            <table class="tbl_main">
                                <colgroup>
                                    <col style="width: 50%" />
                                    <col style="width: 50%" />
                                </colgroup>
                                <tbody id="tblGroupRankModify">
                                    <tr class="height">
                                        <th>상품코드</th>
                                        <td id="codeModify"></td>
                                    </tr>
                                    <tr class="height">
                                        <th>상품명</th>
                                        <td id="nameModify"></td>
                                    </tr>
                                    <tr class="height">
                                        <th>Rank 순위</th>
                                        <td>
                                            <input type="hidden" id="hdBaseRank"><input type="number" id="rankModify" style="ime-mode: disabled;" onkeypress="return fnGoodsUpdateEnter();" onkeyup='removeChar(event)' onkeydown="return numberKey(event)"></td>
                                    </tr>
                                </tbody>
                            </table>
                            <div class="rank-btn">
                                <div>
                                    <input type="button" class="mainbtn type1" style="height: 30px;" value="그룸코드&상품코드 초기화" />
                                    <input type="button" class="mainbtn type1" style="width: 105px; height: 30px;" value="저장" onclick="fnUpdateRank(); return false;" />
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>

