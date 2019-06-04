<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/Admin/Master/AdminMasterPage.master" CodeFile="OrderBelongMain.aspx.cs" Inherits="Admin_Order_OrderBelongMain" %>

<%@ Register Src="~/UserControl/ucListControl.ascx" TagName="ListPager" TagPrefix="ucPager" %>
<%@ Import Namespace="Urian.Core" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <%--<link href="../Content/order/order.css" rel="stylesheet" />--%>
    <link href="../Content/Goods/goods.css" rel="stylesheet" />

    <style>
        .sub-tab-div a:nth-child(1) {
            margin-left: 0px;
        }

        #tblHeader tr.selected {
            background-color: gainsboro
        }
        

    </style>
    <script type="text/javascript">

        var is_sending = false;

        $(document).on('click', '#tblHeader td:not(:nth-child(5))', function () {
            
            fnShowDetail(this); return false;
        });

        //클릭 시 팝업창  
        function fnShowDetail(el) {
            var hdBelongCode = $(el).parent().find('#hdBelongCode').val();

            var callback = function (response) {
                
                if (!isEmpty(response)) {

                    $("#obName").val(response.OrderBelongName);
                    $("#obCode").val(response.OrderBelongCode);
                    $("#selUse").val(response.DelFlag);
                    $("#obRemark").val(response.Remark);
                    $("#obEntryDate").val(response.EntryDate);

                }
            }

            var param = {
                Method: 'GetOrderBelongMainPopup_Admin',
                OrderBelong_Code: hdBelongCode,
            };

            var beforeSend = function () {
                $('#divLoading').css('display', '');
            }
            var complete = function () {
                $('#divLoading').css('display', 'none');
                fnOpenDivLayerPopup('Belongdiv');
            }
            JqueryAjax('Post', '../../Handler/OrderHandler.ashx', true, false, param, 'json', callback, beforeSend, complete, true, '<%=Svid_User%>');

        }

        // 해당 주문 소속 코드 사용중 & 사용중지 이벤트  
        function fnCategoryManagement(el, flag) {
            var setCode = '';
            var setBelongCode = $(el).parent().parent().find("input[name='hdBelongCode']").val();
            var delFlag = $(el).parent().parent().find("#hdDelFlag").val();


            if (delFlag == 'Y') {
                setCode = 'N'
            }

            else {
                setCode = 'Y'
            }
            var callback = function (response) {
                if (response == 'OK') {
                    alert('사용 유무가 변경 되었습니다');
                }
                else {
                    alert('시스템 오류입니다. 개발팀에 문의하세요.');
                }
                return false;
            };
            var param = {
                Method: 'UpdateBelongUse',
                SvidUser: '<%= Svid_User%>',
                BelongCode: setBelongCode,
                UpdateFlag: setCode
            };

            var beforeSend = function () {
                is_sending = true;
            }
            var complete = function () {
                is_sending = false;
                window.location.reload(true);
            }

            if (is_sending) return false;
            JqueryAjax('Post', '../../Handler/OrderHandler.ashx', true, false, param, 'text', callback, beforeSend, complete, true, '<%=Svid_User%>');

            return false;
        }
        //페이지 이동
        function fnGoPage(pageVal) {
            switch (pageVal) {
                case "OHL":
                    window.location.href = "../Order/OrderHistoryList?ucode=" + ucode;
                    break;
                case "DL":
                    window.location.href = "../Order/DeliveryOrderList?ucode=" + ucode;
                    break;
                case "PG":
                    window.location.href = "../Member/Pg_Main?ucode=" + ucode;
                    break;
                case "LOAN":
                    window.location.href = "../Member/Loan_Main?ucode=" + ucode;
                    break;
                case "OBM":
                    window.location.href = "../Order/OrderBelongMain?ucode=" + ucode;
                    break;
                case "CLM":
                    window.location.href = "../Company/CompanyLinkManagement?ucode=" + ucode;
                    break;
                default:
                    break;
            }
        }

        function fnTabClickRedirect(pageName) {
            location.href = pageName + '.aspx?ucode=' + ucode;
            return false;
        }

        function fnPopOrderUpdate() {
            $("#selUse").val();
            var callback = function (response) {
               
                if (response == 'OK') {

                    alert('저장되었습니다.');
                    fnClosePopup('Belongdiv');
                    <%=Page.GetPostBackEventReference(btnSearch)%>
                }
                else {
                    alert('시스템 오류입니다. 개발팀에 문의하세요.');
                }
                return false;
            };
            var param = {
                OrderBelong_Code: $("#obCode").val(),
                OrderBelong_Name: $("#obName").val(),
                Remark: $("#obRemark").val(),
                Delflag:  $("#selUse").val(),
                Method: 'UpdatePopOrderBelong',
            };
              JqueryAjax('Post', '../../Handler/OrderHandler.ashx', true, false, param, 'text', callback, null, null, true, '<%=Svid_User%>');
        }

        function trMouseOver(el) {
            $(el).css("background-color", "#ececec");
        }
         function trMouseOut(el) {
            $(el).css("background-color", "white");
        }

    </script>

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div class="all">
        <div class="sub-contents-div">
            <!--제목 타이틀-->
            <div class="sub-title-div">
                <p class="p-title-mainsentence">
                    주문연동관리
                    <span class="span-title-subsentence"></span>
                </p>
            </div>
            <br />
            <!--상위 탭메뉴-->
            <div>
                <input type="button" class="mainbtn type1" style="width: 105px; height: 30px; font-size: 12px" value="관계사 연동 관리" onclick="fnGoPage('CLM')" />
                <input type="button" class="mainbtn type1" style="width: 105px; height: 30px; font-size: 12px" value="PG 관리" onclick="fnGoPage('PG')" />
                <input type="button" class="mainbtn type1" style="width: 105px; height: 30px; font-size: 12px" value="여신 관리" onclick="fnGoPage('LOAN')" />
            </div>

            <!--탭메뉴-->
            <div class="div-main-tab" style="width: 100%;">
                <ul>
                    <li class='tabOn' style="width: 185px;" onclick="fnTabClickRedirect('OrderBelongMain');">
                        <a onclick="fnTabClickRedirect('OrderBelongMain');">주문 소속</a>
                    </li>
                    <li class='tabOff' style="width: 185px;" onclick="fnTabClickRedirect('OrderAreaList');">
                        <a onclick="fnTabClickRedirect('OrderAreaList');">주문 지역</a>
                    </li>
                    <li class='tabOff' style="width: 185px;" onclick="fnTabClickRedirect('OrderSaleCompList');">
                        <a onclick="fnTabClickRedirect('OrderSaleCompList');">주문 업체</a>
                    </li>
                </ul>
            </div>

            <!--하위 탭메뉴-->
            <div class="tab-display1">
                <div class="tab" style="margin-top: 10px">
                    <span class="subTabOn" style="width: 186px; height: 35px; cursor: pointer;" id="btnTab1" onclick="fnTabClickRedirect('OrderBelongMain.aspx');">주문 소속 조회</span>
                    <span class="subTabOff" style="width: 186px; height: 35px; cursor: pointer;" id="btnTab2" onclick="fnTabClickRedirect('OrderBelongRegister.aspx');">주문 소속 등록</span>
                    <%--<a class="tabButton1" id="btnTab1" onclick="javascript:location.href='OrderBelongMain.aspx';">
                        <img src="../../Images/Order/belongTsub-on.jpg" alt="주문 지역 조회" /></a>--%>
                    <%--<a class="tabButton2" id="btnTab2" onclick="javascript:location.href='OrderBelongRegister.aspx';">
                        <img src="../../Images/Order/belongT2sub-off.jpg" alt="주문 지역 등록" /></a>--%>
                </div>
            </div>
            <!--상단 조회 영역 시작-->
            <div class="search-div">
                <div class="bottom-search-div" style="margin-bottom: 1px">
                    <table class="tbl_search" style="width: 100%; margin-top: 30px; margin-bottom: 30px;">
                        <tr>
                            <td style="width: 90px"></td>
                            <td>
                                <asp:TextBox runat="server" placeholder="업체명을 입력하세요." Style="padding-left: 10px; width: 100%" ID="txtSearch" Onkeypress="return fnEnter();"></asp:TextBox>
                            </td>
                            <td style="text-align: left;">
                                <asp:Button runat="server" CssClass="mainbtn type1" ID="btnSearch" OnClick="btnSearch_Click" Text="검색" Style="width: 75px; height: 25px;"/>
                            </td>
                        </tr>
                    </table>
                </div>
            </div>

            <div class="brand-search">


                <asp:ListView ID="lvBrandList" runat="server" ItemPlaceholderID="phItemList" OnItemDataBound="lvBrandList_ItemDataBound">
                    <LayoutTemplate>
                        <table id="tblHeader" class="tbl_main" style="margin-top: 0; text-align:center;">
                            <colgroup>
                                <col />
                                <col />
                                <col />
                                <col style="width:330px" />
                                <col />
                                <col />

                                <col />
                                <col />
                                <col />
                            </colgroup>
                            <thead>
                                <tr class="board-tr-height">
                                    <th class="txt-center">번호</th>
                                    <th class="txt-center">주문소속코드</th>
                                    <th class="txt-center">주문소속명</th>
                                    <th class="txt-center">사용유무</th>
                                    <th class="txt-center">설정</th>
                                    <th class="txt-center">비고</th>
                                    <th class="txt-center">등록날짜</th>
                                </tr>
                            </thead>
                            <tbody id="tbodyBrand">
                                <asp:PlaceHolder ID="phItemList" runat="server" />
                            </tbody>
                        </table>
                    </LayoutTemplate>
                    <ItemTemplate>
                        <tr class="board-tr-height" style="cursor:pointer;" id="trList" onmouseover="trMouseOver(this)" onmouseout="trMouseOut(this)"  >
                            <td class="txt-center">
                                <span><%# Eval("RowNumber").ToString()%></span>
                            </td>
                            <td class="txt-center" id="tdOdr_Code">
                                <span><%# Eval("ORDERBELONG_CODE").ToString()%></span>

                                <input type="hidden" id="hdBelongCode" name="hdBelongCode" value="<%#Eval("ORDERBELONG_CODE").ToString() %>" />
                            </td>
                            <td class="txt-center" id="tdOdr_Name">
                                <%# Eval("ORDERBELONG_NAME").ToString() %>
                            </td>
                            <td class="txt-center" id="tdDelFlag">
                                <img src="../Images/Order/<%# (SetFlagName( Eval("DelFlag").ToString())=="사용") ? "ico_use.png" : "ico_stopUsing.png"%>" />
                                
                                <asp:HiddenField runat="server" ID="hfDelFlag" Value='<%# Eval("DelFlag").ToString()%>' />
                                <input type="hidden" id="hdDelFlag" name="hdDelFlag" value="<%#Eval("DelFlag").ToString() %>" />

                            </td>

                            <td class="txt-center" id="tdSetting">
                                <asp:ImageButton AlternateText="사용중지" ID="ibtnCategoryDelete" runat="server" ImageUrl="../Images/Goods/use-on.jpg" onmouseover="this.src='../Images/Goods/use-on.jpg'" onmouseout="this.src='../Images/Goods/use-on.jpg'" OnClientClick="return fnCategoryManagement(this,'Y');" CssClass="useBt" />
                                <asp:ImageButton AlternateText="사용" ID="ibtnCategoryUse" runat="server" ImageUrl="../Images/Goods/useStop-off.jpg" onmouseover="this.src='../Images/Goods/useStop-off.jpg'" onmouseout="this.src='../Images/Goods/useStop-off.jpg'" OnClientClick="return fnCategoryManagement(this,'N');" CssClass="useBt" />

                            </td>

                            <td class="txt-center" id="tdRemark">
                                <%# Eval("Remark").ToString() %>
                            </td>

                            <td class="txt-center" id="tdEntryDate">
                                <%# ((DateTime)(Eval("EntryDate"))).ToString("yyyy-MM-dd")%>
                            </td>
                        </tr>
                    </ItemTemplate>
                    <EmptyDataTemplate>
                        <table class="board-table" style="margin-top: 0;">
                            <colgroup>
                                <col />
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
                                <tr class="board-tr-height">
                                    <th class="txt-center">번호</th>
                                    <th class="txt-center">주문소속코드</th>
                                    <th class="txt-center">주문소속명</th>
                                    <th class="txt-center">사용유무</th>
                                    <th class="txt-center">설정</th>
                                    <th class="txt-center">비고</th>
                                    <th class="txt-center">등록날짜</th>
                                </tr>
                            </thead>
                            <tr class="board-tr-height">
                                <td colspan="11" class="txt-center">조회된 데이터가 없습니다.</td>
                            </tr>
                        </table>
                    </EmptyDataTemplate>
                </asp:ListView>
                <!--데이터 리스트 종료 -->

                <!--페이징-->
                <div style="margin: 0 auto; text-align: center">
                    <ucPager:ListPager ID="ucListPager" runat="server" OnPageIndexChange="ucListPager_PageIndexChange" PageSize="20" />
                </div>
            </div>

        </div>
    </div>



    <%--PG정보 수정 팝업 시작--%>

    <div id="Belongdiv" class="popupdiv divpopup-layer-package">
        <div class="popupdivWrapper" style="width:620px; height:400px;">
            <div class="popupdivContents">

                <div class="close-div">
                    <a onclick="fnClosePopup('Belongdiv'); return false;" style="cursor: pointer">
                        <img src="../../Images/Wish/icon-delete.jpg" alt="닫기" style="float: right;" /></a>
                </div>
                <div class="popup-title">
                    <h3 class="pop-title">주문소속 조회</h3>
                    <table id="tblBelongPop" class="tbl_main tbl_popup">
                        <tr>
                            <th>＊&nbsp;&nbsp;주문소속명</th>
                            <td>
                                <input type='text' id='obName' style='width: 300px' class='txtPg' disabled='disabled' /></td>
                        </tr>
                        <tr>
                            <th>＊&nbsp;&nbsp;주문소속코드</th>
                            <td>
                                <input type='text' id='obCode' style='width: 300px' class='txtPg'  disabled='disabled' /></td>
                        </tr>
                        <tr>
                            <th>＊&nbsp;&nbsp;사용유무</th>
                            <td>
                                
                                <select style='width: 300px' class='tax' id='selUse'>
                                    <option id="selUseY" value="Y">사용중지</option>
                                    <option id="selUseN" value="N">사용</option>
                                </select></td>
                        </tr>
                        <tr>
                            <th>＊&nbsp;&nbsp;비고</th>
                            <td>
                                <input type='text' id="obRemark" style='width: 300px' class='txtPg' /></td>
                        </tr>
                        <tr>
                            <th>＊&nbsp;&nbsp;등록날짜</th>
                            <td>
                                <input type='text' id="obEntryDate" style='width: 300px' class='txtPg' disabled='disabled' /></td>
                        </tr>
                    </table>

                    <div class="btn_center">
                        <input type="button" value="저장" style="width:75px" class="mainbtn type1" ID="btnSave" onclick="fnPopOrderUpdate()">
                    </div>

                </div>
            </div>
        </div>
    </div>
</asp:Content>

