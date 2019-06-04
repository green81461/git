<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Master/AdminMasterPage.master" AutoEventWireup="true" CodeFile="CategoryRankManagement.aspx.cs" Inherits="Admin_Goods_CategoryRankManagement" %>

<%@ Import Namespace="Urian.Core" %>



<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
   <link href="../Content/Order/common.css" rel="stylesheet" />
   <link href="../Content/Goods/goods.css" rel="stylesheet" />
    <link  href="../../Content/jstree-style.css" rel="stylesheet" />
    <script src="../../Scripts/jstree.js"></script>
   
    <script type="text/javascript">
        $(document).ready(function () {
            fnAllCategoryListBind();
            //$("#divCategoryTree").jstree(
            //    {
            //        core: {
            //            loaded_state: false,
            //        }
            //    }
            //);
             $("#divCategoryTree").jstree({plugins: ["state"]});
        });

        function fnAllCategoryListBind() {


            var callback = function (response) {

                fnGetCategoryList(response);  //전체카테고리바인드
               
            }
            var param = { Method: 'GetCategoryTreeList' };

            JqueryAjax('Post', '../../Handler/Common/CategoryHandler.ashx', false, false, param, 'json', callback, null, null, false, '');

        }

        //전체카테고리 리스트 바인드
        function fnGetCategoryList(response) {
            $('#divCategoryTree').empty().append('<ul id="categoryTree"></ul>');
            
            var categoryMax = fnGetCategoryMax(response, 'CategoryLevelCode').CategoryLevelCode; //카테고리 레벨코드 맥스값 갖고와서
            for (var i = 0; i < response.length; i++) {

                for (var j = 1; j <= categoryMax; j++) {

                    if (response[i].CategoryLevelCode == j) {

                        var createHtml = '';
                        var nextDepth = j + 1;
                        var leafNodeIcon = response[i].IsLeafNode == "0" ? "" : "../../images/jstree/file.png";
                        createHtml += '<li id="' + response[i].CategoryFinalCode + '" data-jstree=\'{"opened":false , "icon" : "'+leafNodeIcon+'"}\'  ctgrno = "'+response[i].CategoryNo+'">';
                        createHtml += '<a onclick="fnGetCategoryInfo(\''+response[i].CategoryFinalCode+'\',\''+response[i].CategoryChainName+'\',\''+response[i].CategoryNo+'\');"><span>' + response[i].CategoryFinalName + '';
                        createHtml += '</span></a>';
                       if (response[i].IsLeafNode == '0') {

                                createHtml += '<ul  id="subMenu' + nextDepth + 'Depth' + response[i].CategoryFinalCode + '">';
                                createHtml += '</ul>';
                        }

                        createHtml += '</li>';

                        if (j == 1) {
                            $('#categoryTree').append(createHtml);


                        }
                        else {
                            $('#subMenu' + j + 'Depth' + response[i].CategoryUpCode + '').append(createHtml);
                        }
                    }
                }
            }
            return false;
        }

        //노드클릭시 카테고리 정보 Show
        function fnGetCategoryInfo(code, chain, rank) {
            
            $('#level1Category').empty();
            $('#level2Category').empty();
            $('#level3Category').empty();
            $('#level4Category').empty();
            $('#level5Category').empty();
            $('#txtCategoryRank').val('');
            $('#hdCategoryCode').val('');
            
            var chainArray = chain.split('^');
            if (chainArray[0] != null) {
                $('#level1Category').text(chainArray[0]);
            }
            if (chainArray[1] != null) {
                $('#level2Category').text(chainArray[1]);
            }
            if (chainArray[2] != null) {
                $('#level3Category').text(chainArray[2]);
            }
            if (chainArray[3] != null) {
                $('#level4Category').text(chainArray[3]);
            }
            if (chainArray[4] != null) {
                $('#level5Category').text(chainArray[4]);
            }

            $('#hdCategoryCode').val(code);
            $('#hdUpRank').val(rank.substr(0, rank.length -2));
            $('#hdBaseRank').val(rank.substr(rank.length - 2, 2));
            $('#txtCategoryRank').val(rank.substr(rank.length - 2, 2));
            return false;
        }


        //카테고리 순서 저장
        function fnUpdateCategoryNo() {
            //$("#divCategoryTree").jstree({plugins: ["state"]});
            if (isEmpty($('#txtCategoryRank').val())) {
                alert('순서를 기입해 주세요.');
                $('#txtCategoryRank').focus()
                return false;
            }

            if (isEmpty($('#hdCategoryCode').val())) {
                alert('카테고리를 선택해 주세요.');
                return false;
            }
            var callback = function (response) {

                if (response == 'OK') {
                    $("#divCategoryTree").jstree("destroy");
                    fnAllCategoryListBind();
                    $("#divCategoryTree").jstree({plugins: ["state"]});
                    $('#level1Category').empty();
                    $('#level2Category').empty();
                    $('#level3Category').empty();
                    $('#level4Category').empty();
                    $('#level5Category').empty();
                    $('#txtCategoryRank').val('');
                    $('#hdCategoryCode').val('');
                   
                }
                else {
                    alert('시스템 오류입니다. 관리자에게 문의하세요');
                }
                return false;
            }
            var param = {
                CategoryNo: $('#txtCategoryRank').val(),
                CategoryBaseNo: $('#hdBaseRank').val(),
                CategoryUpNo: $('#hdUpRank').val(),
                CategoryCode: $('#hdCategoryCode').val(),
                Method: 'UpdateCategoryNo'
            };

            JqueryAjax('Post', '../../Handler/Common/CategoryHandler.ashx', false, false, param, 'text', callback, null, null, false, '');
        }
        //카테고리 Max 값 갖고오기
        function fnGetCategoryMax(arr, prop) {
            var max;
            for (var i = 0; i < arr.length; i++) {
                if (!max || parseInt(arr[i][prop]) > parseInt(max[prop]))
                    max = arr[i];
            }
            return max;
        }


        function fnEnter() {

            if (event.keyCode == 13) {
                fnUpdateCategoryNo();
                return false;
            }
            else
                return true;
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
            <div class="div-main-tab" style="width: 100%;">
                <ul>
                    <li class='tabOff' style="width: 185px;" onclick="fnTabClickRedirect('CategoryManage');">
                        <a onclick="fnTabClickRedirect('CategoryManage');">카테고리 관리</a>
                    </li>
                    <li class='tabOff' style="width: 185px;" onclick="fnTabClickRedirect('CategoryRegister');">
                        <a onclick="fnTabClickRedirect('CategoryRegister');">카테고리 등록</a>
                    </li>
                    <li class='tabOn' style="width: 185px;" onclick="fnTabClickRedirect('CategoryRankManagement');">
                        <a onclick="fnTabClickRedirect('CategoryRankManagement');">카테고리 Rank</a>
                    </li>
                </ul>
            </div>
            <!--카테고리 Rank 구조-->
            <div class="category-rank">
                <div class="category-rank-columns">
                    <p class="category-rank-title">카테고리 Rank 구조</p>
                    <div id="divCategoryTree">

                    </div>
                    <%--<ul id="categoryTree" class="filetree">
                        
                    </ul>--%>

                </div>
                <div class="category-rank-columns">
                    <p class="category-rank-title">카테고리 Rank 변경</p>
                    <div class="rank-div">
                        <table id="Search-table" class="tbl_main">
                            <colgroup>
                                <col style="width:50%"/>
                                <col />
                            </colgroup>
                            <tbody>
                                <tr>
                                    <th>1단 카테고리</th>
                                    <td id="level1Category"></td>
                                </tr>
                                <tr>
                                    <th>2단 카테고리</th>
                                    <td id="level2Category"></td>
                                </tr>
                                <tr>
                                    <th>3단 카테고리</th>
                                    <td id="level3Category"></td>
                                </tr>
                                <tr>
                                    <th>4단 카테고리</th>
                                    <td id="level4Category"></td>
                                </tr>
                                <tr>
                                    <th>5단 카테고리</th>
                                    <td id="level5Category"></td>
                                </tr>
                            </tbody>
                        </table>
                        <div class="rank-ch">
                            <div>Rank 순위</div>
                            <div>
                                <input type="hidden" id="hdBaseRank">
                                <input type="hidden" id="hdUpRank">
                                <input type="text" id="txtCategoryRank" onkeypress="return fnEnter();"/></div>
                        </div>
                        <div class="rank-btn">
                            <div>
                                <input type="hidden" id="hdCategoryCode"/>
                                <input type="button" class="mainbtn type1" style="height: 30px;" value="카테고리 Rank 초기화" />
                                <input type="button" class="mainbtn type1" style="width: 105px; height: 30px;" value="저장" onclick="fnUpdateCategoryNo(); return false;"/></div>
                        </div>
                    </div>

                </div>
            </div>


        </div>
    </div>
</asp:Content>
