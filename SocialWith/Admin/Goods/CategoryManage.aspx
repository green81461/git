<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Master/AdminMasterPage.master" AutoEventWireup="true" CodeFile="CategoryManage.aspx.cs" Inherits="Admin_Goods_CategoryManage" %>

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
        //  테이블 클릭
        //$(document).on('click', '#tblHeader td:not(:nth-child(6))', function () {       

        //    fnShowDetail(this);
        //    return false;
        //});

        //$("#tbodyCtgrList tr").on('click', 'td', function () {
        //    alert(11111);
        //    fnShowDetail(this);
        //    return false;
        //});




        //..테이블 클릭
        $(function () {

            $("#tbodyCtgrList").on('click', 'tr td:not(:nth-child(6),:nth-child(7),:nth-child(8))', function () {
                //alert($.trim($(this).text()));

                //alert($.trim($(this).text())+",    "+$(this).find("input:hidden[name^='ctgrLevel']").val());
                //alert($(this).find("input:hidden[name^='ctgrName']").val());

                var aa = $(this).find("input:hidden[name^='ctgrLevel']").val();
                var aaa = $(this).find("input:hidden[name^='ctgrName']").val();
                var aaaa = $(this).find("input:hidden[name^='ctgrCode']").val();


                if (aaa == '') {
                    alert('해당 카테고리가 없습니다.')
                    return false;
                }
                else {
                    fnShowDetail(aa, aaa, aaaa);
                    return false;
                }
            });

        })
        var is_sending = false;
        function fnCategoryManagement(el, flag) {
            var categorycode1 = $(el).parent().find('#hdCategoryCode1').val();
            var categorycode2 = $(el).parent().find('#hdCategoryCode2').val();
            var categorycode3 = $(el).parent().find('#hdCategoryCode3').val();
            var categorycode4 = $(el).parent().find('#hdCategoryCode4').val();
            var categorycode5 = $(el).parent().find('#hdCategoryCode5').val();
            var setCode = '';

            if (categorycode2 == 0) {
                setCode = categorycode1;
            }
            else if (categorycode2 != 0 && categorycode3 == 0) {
                setCode = categorycode2;
            }
            else if (categorycode3 != 0 && categorycode4 == 0) {
                setCode = categorycode3;
            }
            else if (categorycode4 != 0 && categorycode5 == 0) {
                setCode = categorycode4;
            }
            else if (categorycode5 != 0) {
                setCode = categorycode5;
            }


            var callback = function (response) {
                if (response == 'OK') {
                    alert('변경되었습니다.');
                }
                else {
                    alert('시스템 오류입니다. 개발팀에 문의하세요.');
                }
                return false;
            };
            var param = {
                Method: 'UpdateCategoryManagement',
                SvidUser: '<%= Svid_User%>',
                CategoryCode: setCode,
                UpdateFlag: flag
            };

            var beforeSend = function () {
                is_sending = true;
            }
            var complete = function () {
                is_sending = false;
                window.location.reload(true);
            }

            if (is_sending) return false;
            JajaxDuplicationCheck('Post', '../../Handler/Common/CategoryHandler.ashx', param, 'text', callback, beforeSend, complete, true, '<%=Svid_User%>');

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


        // 수정 페이지 보여주기
        function fnShowDetail(aa, aaa, aaaa) {


            $('#<%= CategoryLevel.ClientID%>').val('');
            $('#<%= CateGoryFinalName.ClientID%>').val('');
            $('#<%= CateGoryFinalCode.ClientID%>').val('');




            $('#<%= CategoryLevel.ClientID%>').val(aa);
            $('#<%= CateGoryFinalName.ClientID%>').val(aaa);
            $('#<%= CateGoryFinalCode.ClientID%>').val(aaaa);


            //var e = document.getElementById('categoryPdiv');

            //if (e.style.display == 'block') {
            //    e.style.display = 'none';

            //} else {
            //    e.style.display = 'block';
            //}

            fnOpenDivLayerPopup('categoryPdiv');

            return false;
        }

        //카테고리수정 팝업창 열기
        //function fnAddPopupOpen() {
        //    var e = document.getElementById('categoryPdiv');

        //    if (e.style.display == 'block') {
        //        e.style.display = 'none';

        //    } else {
        //        e.style.display = 'block';
        //    }

        //}


        //팝업창 닫기

        function fnCancel() {
            $('.divpopup-layer-package').fadeOut();
        }


        //마우스 오버
        function fnSetRowColor(el, type) {

            if (type == 'over') {
                $(el).css('cursor', 'pointer')
                $(el).addClass("selected");
            }
            else {
                $(el).removeClass("selected");

            }

        }

        //페이지 이동
        function fnGoPage(pageVal) {
            switch (pageVal) {
                case "GOODS":
                    window.location.href = "../Goods/GoodsRegister?ucode=" + ucode;
                    break;
                case "BRAND":
                    window.location.href = "../Goods/BrandMain?ucode=" + ucode;
                    break;
                default:
                    break;
            }
        }


    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div class="all">

        <div class="sub-contents-div" style="min-height: 1450px;">
            <div class="sub-title-div">
                <p class="p-title-mainsentence">
                    카테고리 관리
                    <span class="span-title-subsentence">카테고리 메뉴를 추가 및 삭제 관리 할 수 있습니다.</span>
                </p>
            </div>

            <!--탭영역-->
            <div class="div-main-tab" style="width: 100%;">
                <ul>
                    <li class='tabOn' style="width: 185px;" onclick="fnTabClickRedirect('CategoryManage');">
                        <a onclick="fnTabClickRedirect('CategoryManage');">카테고리 관리</a>
                    </li>
                    <li class='tabOff' style="width: 185px;" onclick="fnTabClickRedirect('CategoryRegister');">
                        <a onclick="fnTabClickRedirect('CategoryRegister');">카테고리 등록</a>
                    </li>
                    <li class='tabOff' style="width: 185px;" onclick="fnTabClickRedirect('CategoryRankManagement');">
                        <a onclick="fnTabClickRedirect('CategoryRankManagement');">카테고리 Rank</a>
                    </li>
                </ul>
            </div>


            <!--검색 영역-->


            <div class="header-search-div" style="margin-bottom: 1px">

                <table id="Search-table" class="tbl_main">
                    <colgroup>
                        <col style="width: 20%" />
                        <col style="width: 20%" />
                        <col style="width: 20%" />
                        <col style="width: 20%" />
                        <col style="width: 20%" />
                    </colgroup>
                    <tr>
                        <th>카테고리명
                        </th>
                        <td colspan="4" style="background-color: white">
                            <asp:TextBox runat="server" ID="txtCategoryName" CssClass="large-size" Onkeypress="return fnEnter();"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <th>1단 카테고리</th>
                        <th>2단 카테고리</th>
                        <th>3단 카테고리</th>
                        <th>4단 카테고리</th>
                        <th>5단 카테고리</th>
                    </tr>
                    <tr id="ctgrSearchTr">
                        <td>
                            <asp:DropDownList runat="server" ID="ddlCtgrLevel_1" CssClass="medium-size" AutoPostBack="true" OnSelectedIndexChanged="ddlCtgrLevel_1_Changed">
                            </asp:DropDownList>
                        </td>
                        <td>
                            <asp:DropDownList runat="server" ID="ddlCtgrLevel_2" CssClass="medium-size" AutoPostBack="true" OnSelectedIndexChanged="ddlCtgrLevel_2_Changed">
                            </asp:DropDownList>
                        </td>
                        <td>
                            <asp:DropDownList runat="server" ID="ddlCtgrLevel_3" CssClass="medium-size" AutoPostBack="true" OnSelectedIndexChanged="ddlCtgrLevel_3_Changed">
                            </asp:DropDownList>
                        </td>
                        <td>
                            <asp:DropDownList runat="server" ID="ddlCtgrLevel_4" CssClass="medium-size" AutoPostBack="true" OnSelectedIndexChanged="ddlCtgrLevel_4_Changed">
                            </asp:DropDownList>
                        </td>
                        <td>
                            <asp:DropDownList runat="server" ID="ddlCtgrLevel_5" CssClass="medium-size" AutoPostBack="true">
                            </asp:DropDownList>
                        </td>
                    </tr>
                </table>

                <div>
                    <div style="float: left">
                        <input type="button" class="mainbtn type1" style="width: 105px; height: 30px;" value="상품 관리" onclick="fnGoPage('GOODS')" />
                        <input type="button" class="mainbtn type1" style="width: 105px; height: 30px;" value="브랜드 관리" onclick="fnGoPage('BRAND')" />
                    </div>
                    <div class="bt-align-div">
                        <asp:Button ID="btnSearch" runat="server" Width="95" Height="30" Text="검색" OnClick="btnSearch_Click" CssClass="mainbtn type1" />

                    </div>
                </div>



                <div class="fileDiv" style="margin-bottom: 30px; height: 30px;">
                    <table class="tbl_file">
                        <colgroup>
                            <col>
                            <col>
                            <col>
                        </colgroup>
                        <tr>
                            <th>엑셀파일 등록</th>
                            <td>
                                <asp:FileUpload runat="server" ID="fuExcel" CssClass="excelfileupload" /></td>
                            <td style="text-align: center">
                                <asp:Button ID="btnExcelUpload" runat="server" Width="95" Height="30" Text="엑셀업로드" OnClick="btnExcelUpload_Click" CssClass="mainbtn type1" />
                                <asp:Button ID="btnExcelFormDownload" runat="server" Width="175" Height="30" Text="엑셀업로드폼 다운로드" OnClick="btnExcelFormDownload_Click" CssClass="mainbtn type1" />
                            </td>
                        </tr>
                    </table>

                </div>

                <div class="all">
                    <asp:ListView ID="lvMemberListB" runat="server" ItemPlaceholderID="phItemList" OnItemDataBound="lvMemberListB_ItemDataBound">
                        <LayoutTemplate>
                            <table id="tblHeader" class="tbl_main">
                                <colgroup>
                                    <col />
                                    <col />
                                    <col />
                                    <col />
                                    <col />
                                    <col />
                                    <col />
                                    <col />
                                </colgroup>
                                <thead>
                                    <tr>
                                        <th>1단 카테고리</th>
                                        <th>2단 카테고리</th>
                                        <th>3단 카테고리</th>
                                        <th>4단 카테고리</th>
                                        <th>5단 카테고리</th>
                                        <th>사용유무</th>
                                        <th>변경자</th>
                                        <th>설정</th>
                                    </tr>
                                </thead>
                                <tbody id="tbodyCtgrList">
                                    <asp:PlaceHolder ID="phItemList" runat="server" />
                                </tbody>

                            </table>
                        </LayoutTemplate>
                        <ItemTemplate>
                            <tr class="board-tr-height" onmouseover="fnSetRowColor(this,'over');" onmouseout="fnSetRowColor(this,'out');">
                                <td class="txt-center" id="tdCateGoryFinalName1">
                                    <%# Eval("CateGoryFinalName1").ToString()%>
                                    <input type="hidden" name="ctgrLevel" value="1단 카테고리" />
                                    <input type="hidden" name="ctgrName" value="<%#Eval("CateGoryFinalName1").ToString() %>" />
                                    <input type="hidden" name="ctgrCode" value="<%#Eval("CategoryFinalCode1").ToString() %>" />
                                </td>

                                <td class="txt-center" id="tdCateGoryFinalName2">
                                    <%# Eval("CateGoryFinalName2").ToString()%>
                                    <input type="hidden" name="ctgrLevel" value="2단 카테고리" />
                                    <input type="hidden" name="ctgrName" value="<%#Eval("CateGoryFinalName2").ToString() %>" />
                                    <input type="hidden" name="ctgrCode" value="<%#Eval("CategoryFinalCode2").ToString() %>" />
                                </td>

                                <td class="txt-center" id="tdCateGoryFinalName3">
                                    <%# Eval("CateGoryFinalName3").ToString()%>
                                    <input type="hidden" name="ctgrLevel" value="3단 카테고리" />
                                    <input type="hidden" name="ctgrName" value="<%#Eval("CateGoryFinalName3").ToString() %>" />
                                    <input type="hidden" name="ctgrCode" value="<%#Eval("CategoryFinalCode3").ToString() %>" />
                                </td>

                                <td class="txt-center" id="tdCateGoryFinalName4">
                                    <%# Eval("CateGoryFinalName4").ToString()%>
                                    <input type="hidden" name="ctgrLevel" value="4단 카테고리" />
                                    <input type="hidden" name="ctgrName" value="<%#Eval("CateGoryFinalName4").ToString() %>" />
                                    <input type="hidden" name="ctgrCode" value="<%#Eval("CategoryFinalCode4").ToString() %>" />
                                </td>

                                <td class="txt-center" id="tdCateGoryFinalName5">
                                    <%# Eval("CateGoryFinalName5").ToString()%>
                                    <input type="hidden" name="ctgrLevel" value="5단 카테고리" />
                                    <input type="hidden" name="ctgrName" value="<%#Eval("CateGoryFinalName5").ToString() %>" />
                                    <input type="hidden" name="ctgrCode" value="<%#Eval("CategoryFinalCode5").ToString() %>" />
                                </td>
                                <td class="txt-center" id="tdDelFlagName">
                                    <%--<%# SetFlagName( Eval("DelFlag").ToString())%>--%>
                                    <img src="../../Images/<%# SetFlagImg( Eval("DelFlag").ToString())%>" />
                                </td>
                                <td class="txt-center">
                                    <%# Eval("DelUserName").ToString()%>
                                </td>
                                <td class="txt-center">
                                    <input type="hidden" id="hdCategoryCode1" value="<%# Eval("CategoryFinalCode1").ToString()%>" />
                                    <input type="hidden" id="hdCategoryCode2" value="<%# Eval("CategoryFinalCode2").ToString()%>" />
                                    <input type="hidden" id="hdCategoryCode3" value="<%# Eval("CategoryFinalCode3").ToString()%>" />
                                    <input type="hidden" id="hdCategoryCode4" value="<%# Eval("CategoryFinalCode4").ToString()%>" />
                                    <input type="hidden" id="hdCategoryCode5" value="<%# Eval("CategoryFinalCode5").ToString()%>" />
                                    <asp:HiddenField runat="server" ID="hfDelFlag" Value='<%# Eval("DelFlag").ToString()%>' />
                                    <asp:ImageButton AlternateText="사용중지" ID="ibtnCategoryDelete" runat="server" ImageUrl="../Images/Goods/useStop-off.jpg" onmouseover="this.src='../Images/Goods/useStop-off.jpg'" onmouseout="this.src='../Images/Goods/useStop-off.jpg'" OnClientClick="return fnCategoryManagement(this,'Y');" CssClass="useBt" />
                                    <asp:ImageButton AlternateText="사용" ID="ibtnCategoryUse" runat="server" ImageUrl="../Images/Goods/use-on.jpg" onmouseover="this.src='../Images/Goods/use-on.jpg'" onmouseout="this.src='../Images/Goods/use-on.jpg'" OnClientClick="return fnCategoryManagement(this,'N');" CssClass="useBt" />
                                </td>

                            </tr>
                        </ItemTemplate>
                        <EmptyDataTemplate>
                            <table class="tblMainB">
                                <colgroup>
                                    <col />
                                    <col />
                                    <col />
                                    <col />
                                    <col />
                                    <col />
                                    <col />
                                </colgroup>
                                <thead>
                                    <tr>
                                        <th>1단 카테고리</th>
                                        <th>2단 카테고리</th>
                                        <th>3단 카테고리</th>
                                        <th>4단 카테고리</th>
                                        <th>5단 카테고리</th>
                                        <th>사용유무</th>
                                        <th>변경자</th>
                                        <th>설정</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr>
                                        <td colspan="8" class="txt-center">조회된 정보가 없습니다.</td>
                                    </tr>
                                </tbody>
                            </table>
                        </EmptyDataTemplate>
                    </asp:ListView>
                </div>

                <div style="margin: 0 auto; text-align: center">
                    <ucPager:ListPager ID="ucListPager" runat="server" PageSize="20" OnPageIndexChange="ucListPager_PageIndexChange" />
                </div>



                <!--엑셀다운로드,저장 버튼-->
                <div class="bt-align-div">
                    <!--액셀다운로드인지, 액셀업로드인지 -_-;; -->

                    <asp:Button ID="btnExcelExport" runat="server" Width="95" Height="30" Text="엑셀 저장" OnClick="btnExcelExport_Click" CssClass="mainbtn type1" />

                </div>


            </div>
        </div>
    </div>

    <!--카테고리 수정 AJAX -->
    <div id="categoryPdiv" class="popupdiv divpopup-layer-package">
        <div class="popupdivWrapper" style="width:400px; height:300px;">
            <div class="popupdivContents">

                <div class="close-div">
                    <a onclick="fnClosePopup('categoryPdiv'); return false;" style="cursor: pointer">
                        <img src="../../Images/Wish/icon-delete.jpg" alt="닫기" style="float: right;" /></a>
                </div>
                <div class="popup-title">
                    <h3 class="pop-title">검색조건 선택</h3>
                    <table id="categoryTbl" class="tbl_main">
                        <tr>
                            <th>단</th>
                            <td>
                                <asp:TextBox runat="server" ID="CategoryLevel" Width="99%" ReadOnly="true" Style="background-color: #ececec;"></asp:TextBox></td>
                        </tr>

                        <tr>
                            <th>카테고리코드</th>
                            <td>
                                <asp:TextBox runat="server" ID="CateGoryFinalCode" Width="99%" ReadOnly="true" Style="background-color: #ececec;"></asp:TextBox></td>
                        </tr>

                        <tr>
                            <th>카테고리명</th>
                            <td>
                                <asp:TextBox runat="server" ID="CateGoryFinalName" Width="99%"></asp:TextBox></td>
                        </tr>

                    </table>


                </div>
                <div class="btn_center">
                    <asp:Button runat="server" Style="width: 75px;" ID="btnSave" OnClick="saveCaterory" CssClass="mainbtn type1" Text="저장" />
                    <%--<div style="text-align: right; margin-top: 30px;">
                    <a >
                <img src="../Images/Goods/submit1-off.jpg" alt="확인" onmouseover="this.src='../Images/Goods/submit1-on.jpg'" onmouseout="this.src='../Images/Goods/submit1-off.jpg'" /></a>
                </div>
                    --%>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
