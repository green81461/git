<%@ Page Language="C#" MasterPageFile="~/Admin/Master/AdminMasterPage.master" AutoEventWireup="true" CodeFile="OrderBelongRegister.aspx.cs" Inherits="Admin_Order_OrderBelongRegister" %>

<%@ Register Src="~/UserControl/ucListControl.ascx" TagName="ListPager" TagPrefix="ucPager" %>
<%@ Import Namespace="Urian.Core" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <link href="../Content/Goods/goods.css" rel="stylesheet" />
    <link href="../Content/Member/member.css" rel="stylesheet" />

    <script type="text/javascript">
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
    </script>

    <style>
        /*업체명조회 팝업창*/
        #corpCodeAdiv {
            margin: 10px 0 0 0;
            top: 0;
            left: 0;
            position: fixed;
            width: 100%;
            height: 100%;
            background-color: black;
            background-color: rgba(0,0,0,.65);
            display: none;
            z-index: 100;
            widows: 50;
        }

        .corpCodeAwrapper {
            width: 650px;
            height: auto;
            margin: 100px auto;
            text-align: left;
            background-color: #ffffff;
        }

        .corpCodeAcontents {
            background-color: #ffffff;
            height: 520px;
            padding: 15px;
            clear: both;
            z-index: 300;
            transition: ease-in;
            transition-delay: 1s;
            -webkit-transition: ease-in;
        }


        .auto-style1 {
            height: 23px;
        }

        .txtPg {
            border: 1px solid #a2a2a2;
            height: 26px;
        }

        .tax {
            border: 1px solid #a2a2a2;
            height: 26px;
        }

        .search-img {
            vertical-align: middle;
            margin-left: 0;
        }
    </style>


</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div class="all">
        <div class="sub-contents-div">
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
                    <span class="subTabOff" style="width: 186px; height: 35px; cursor: pointer;" id="btnTab1" onclick="fnTabClickRedirect('OrderBelongMain.aspx');">주문 소속 조회</span>
                    <span class="subTabOn" style="width: 186px; height: 35px; cursor: pointer;" id="btnTab2" onclick="fnTabClickRedirect('OrderBelongRegister.aspx');">주문 소속 등록</span>

                </div>
            </div>

            <table class="tbl_main" style="margin-top:30px;">
                <tr>
                    <th>＊&nbsp;&nbsp;주문소속코드</th>
                    <td>
                        <asp:TextBox ID="txtOdrCode" runat="server" CssClass="txtPg" Width="300" onkeypress="return preventEnter(event);"></asp:TextBox>
                        <asp:HiddenField runat="server" ID="hfComCodeNo" />
                        <span>＊자동 생성되는 코드입니다.</span>
                    </td>

                </tr>
                <tr>
                    <th>＊&nbsp;&nbsp;주문소속명</th>
                    <td>
                        <asp:TextBox ID="txtOdrName" runat="server" Width="300px" onkeypress="return preventEnter(event);" CssClass="txtPg"></asp:TextBox>
                    </td>
                </tr>
                <tr>
                    <th>＊&nbsp;&nbsp;비고</th>
                    <td>
                        <asp:TextBox ID="txtRemark" runat="server" oninput="return maxLengthCheck(this)" Width="300px" onkeypress="return onlyNumbers(event);" CssClass="tax"></asp:TextBox>
                        <%--                        <asp:TextBox ID="txtBusinessNum2" runat="server" TextMode="Number" max="9999" oninput="return maxLengthCheck(this)" MaxLength="2" Width="88px" onkeypress="return onlyNumbers(event);" CssClass="tax"></asp:TextBox>&nbsp;&nbsp;-&nbsp;
                        <asp:TextBox ID="txtBusinessNum3" runat="server" TextMode="Number" max="99999" oninput="return maxLengthCheck(this)" MaxLength="5" Width="88px" onkeypress="return onlyNumbers(event);" CssClass="tax"></asp:TextBox>--%>
                        <%--      <span>＊사업자번호나 고유번호를 입력해주세요.</span>--%>
                    </td>
                </tr>

            </table>

            <%-- 업체조회 AJAX 시작--%>
            <div id="corpCodeAdiv" class="divpopup-layer-package">
                <div class="corpCodeAwrapper">
                    <div class="corpCodeAcontents">

                        <div class="close-div">
                            <a onclick="fnCancel()" style="cursor: pointer">
                                <img src="../../Images/Wish/icon-delete.jpg" alt="닫기" style="float: right;" /></a>
                        </div>
                        <div class="popup-title" style="margin-top: 20px;">
                            <img src="../Images/Member/corpPop-tilte.jpg" alt="회사구분코드검색" />


                            <div class="search-div" style="margin-bottom: 20px;">
                                <input type="text" class="text-code" id="SearchKeyWord" name="SearchKeyWord" placeholder="검색어를 입력하세요" />
                                <a class="imgA">
                                    <img src="../../AdminSub/Images/Goods/search-bt-off.jpg" onmouseover="this.src='../../AdminSub/Images/Goods/search-bt-on.jpg'" onmouseout="this.src='../../AdminSub/Images/Goods/search-bt-off.jpg'" onclick="fn_click()" alt="검색" class="search-img" /></a>
                            </div>


                            <div class="divpopup-layer-conts">
                                <table id="tblHeader" class="board-table" style="margin-top: 0; width: 100%">

                                    <thead>
                                        <tr>
                                            <th class="text-center">선택</th>
                                            <th class="text-center">업체명</th>
                                            <th class="text-center">업체코드</th>
                                            <th class="text-center">사업자번호</th>
                                            <th class="text-center">비고</th>
                                        </tr>
                                    </thead>
                                    <tbody></tbody>
                                </table>
                                <input type="hidden" id="hdDeliveryNo" />


                            </div>
                            <div style="text-align: right; margin-top: 30px;">
                                <a onclick="fnSelectCompany()">
                                    <img src="../Images/Goods/submit1-off.jpg" alt="확인" onmouseover="this.src='../Images/Goods/submit1-on.jpg'" onmouseout="this.src='../Images/Goods/submit1-off.jpg'" /></a>
                            </div>

                        </div>
                    </div>
                </div>
            </div>



            <!--저장버튼-->
            <div class="btn_center">
                <asp:Button runat="server" ID="ibSave" Text='저장' OnClick="ibSave_Click" CssClass="mainbtn type1" Style="width: 75px; height: 25px;" />
            </div>
            <!--저장버튼끝-->
        </div>
    </div>
</asp:Content>

