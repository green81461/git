<%@ Page Title="" Language="C#" MasterPageFile="~/Master/Default.master" AutoEventWireup="true" CodeFile="DeliveryList.aspx.cs" Inherits="Delivery_DeliveryList" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <style>
        #tblDeliveryList tr.selected td:not(:last-child) {
            background-color: gainsboro
        }

        .member-div {
            width: 100%;
            height: 70px;
            margin-bottom: 50px;
        }

        .board-table td, .board-table th {
            border: 1px solid #a2a2a2;
        }

        .board-table th {
            height: 30px;
        }
    </style>
    <script type="text/javascript">
        function fnSetRowColor(el, type) {
            if (type == 'over') {
                $(el).parent().addClass('selected');
            }
            else {
                $(el).parent().removeClass('selected');
            }
        }

        function fnGoDetailPage(svidUser, gubun) {
            location.href = 'DeliveryManagement.aspx?SvidUser=' + svidUser + '&Gubun=' + gubun;
            return false;
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">


    <div class="sub-contents-div">
        <!-- 전체 감싸는 wrap-->
            <div class="sub-title-div">
                <img src="/images/DeliveryList_nam.png" />
               <%-- <p class="p-title-mainsentence">
                    배송지관리
                       <span class="span-title-subsentence">고객님의 배송지를 확인할 수 있습니다.</span>
                </p>--%>
            </div>


            <div class="mini-title">
                <p style="margin-top:40px;"><span style="vertical-align:top; margin-right:5px;"><img src="../images/text_star.png" /></span><span  style="color:#3e3e46; vertical-align:middle;font-size:18px;margin-top:50px;">회원정보</span> </p></div>

            <div class="member-div">
                <table class="tbl_search">
                    <colgroup>
                        <col style="width: 150px;" />
                        <col>
                        <col style="width: 150px;" />
                        <col>

                    </colgroup>
                    <tr>
                        <th>*&nbsp;&nbsp;기관명</th>
                        <td>
                            <asp:Label ID="lblComanyName" runat="server"></asp:Label></td>
                        <th>*&nbsp;&nbsp;아이디</th>
                        <td>
                            <asp:Label ID="lblUserId" runat="server"></asp:Label></td>
                    </tr>
                </table>
            </div>


            <div class="mini-title">
                <p><span style="vertical-align:top; margin-right:5px;"><img src="../images/text_star.png" /></span><span  style="color:#3e3e46; vertical-align:middle;font-size:18px;margin-top:50px;">회원정보</span> </p></div>

            <!--데이터 리스트 시작 -->
            <asp:ListView ID="lvDeliveryList" runat="server" ItemPlaceholderID="phItemList" OnItemDataBound="lvDeliveryList_ItemDataBound">
                <LayoutTemplate>
                    <table id="tblDeliveryList" class="tbl_main">
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
                        </colgroup>
                        <thead>
                            <tr style="background-color:#eef7fb;" class="">
                                <th class="txt-center" style="height: 40px">구분</th>
                                <th class="txt-center" runat="server" id="tdHeaderArea">사업장</th>
                                <th class="txt-center" runat="server" id="tdHeaderBusiness">사업부</th>
                                <th class="txt-center">부서명</th>
                                <th class="txt-center">담당자</th>
                                <th class="txt-center">우편번호</th>
                                <th class="txt-center" style="width: 350px;">주소</th>
                                <th class="txt-center" style="width: 350px;">상세주소</th>
                                <th class="txt-center" style="width: 100px;">등록배송지수</th>
                                <th class="txt-center" style="width: 80px;">확인</th>
                            </tr>
                        </thead>
                        <tbody>
                            <asp:PlaceHolder ID="phItemList" runat="server" />
                        </tbody>
                    </table>
                </LayoutTemplate>
                <ItemTemplate>
                    <tr class="board-tr-height" style="height: 30px;" onclick="fnGoDetailPage('<%# Eval("Svid_User")%>', '<%# Gubun%>');">
                        <td class="txt-center" onmouseover="fnSetRowColor(this, 'over');" onmouseout="fnSetRowColor(this, 'out');">
                            <%# Container.DataItemIndex + 1%>
                        </td>
                        <td class="txt-center" runat="server" id="tdArea" visible='<%# AreaViewFlag  %>' onmouseover="fnSetRowColor(this, 'over');" onmouseout="fnSetRowColor(this, 'out');">
                            <%# Eval("CompanyArea_Name").ToString()%>
                        </td>
                        <td class="txt-center" runat="server" id="tdBusiness" visible='<%# BusinessViewFlag  %>' onmouseover="fnSetRowColor(this, 'over');" onmouseout="fnSetRowColor(this, 'out');">
                            <%# Eval("CompBusinessDept_Name").ToString()%>
                        </td>
                        <td class="txt-center" onmouseover="fnSetRowColor(this, 'over');" onmouseout="fnSetRowColor(this, 'out');">
                            <%# Eval("CompanyDept_Name").ToString()%>
                        </td>
                        <td class="txt-center" onmouseover="fnSetRowColor(this, 'over');" onmouseout="fnSetRowColor(this, 'out');">
                            <%# Eval("Delivery_Person").ToString()%>
                        </td>
                        <td class="txt-center" onmouseover="fnSetRowColor(this, 'over');" onmouseout="fnSetRowColor(this, 'out');">
                            <%# Eval("Zipcode").ToString()%>
                        </td>
                        <td class="txt-center" style="text-align: left; padding-left: 5px;" onmouseover="fnSetRowColor(this, 'over');" onmouseout="fnSetRowColor(this, 'out');">
                            <%# Eval("Address_1").ToString()%>
                        </td>
                        <td class="txt-center" style="text-align: left; padding-left: 5px;" onmouseover="fnSetRowColor(this, 'over');" onmouseout="fnSetRowColor(this, 'out');">
                            <%# Eval("Address_2").ToString()%>
                        </td>
                        <td class="txt-center" onmouseover="fnSetRowColor(this, 'over');" onmouseout="fnSetRowColor(this, 'out');">
                            <%# Eval("DeliveryCount").ToString()%>
                        </td>
                        <td class="txt-center">
                            <asp:HyperLink runat="server" Text='추가' NavigateUrl='<%# string.Format("DeliveryManagement.aspx?SvidUser={0}&Gubun={1}",  Eval("Svid_User"), Gubun) %>'><img src="../Images/delivery/add1-off.jpg" onmouseover="this.src='../Images/delivery/add1-on.jpg'" onmouseout="this.src='../Images/delivery/add1-off.jpg'"/></asp:HyperLink>
                        </td>
                    </tr>
                </ItemTemplate>
                <EmptyDataTemplate>
                    <table class="board-table">
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
                        </colgroup>
                        <thead>
                            <tr class="board-tr-height">
                                <th class="txt-center">구분</th>
                                <th class="txt-center" runat="server" id="tdEmptyArea">사업장</th>
                                <th class="txt-center" runat="server" id="tdEmptyBusiness">사업부</th>
                                <th class="txt-center">부서명</th>
                                <th class="txt-center">담당자</th>
                                <th class="txt-center">우편번호</th>
                                <th class="txt-center">주소</th>
                                <th class="txt-center">상세주소</th>
                                <th class="txt-center">등록배송지 수</th>
                                <th class="txt-center">확인</th>
                            </tr>
                        </thead>
                        <tr class="board-tr-height">
                            <td colspan="10" style="text-align: center;">조회된 데이터가 없습니다.</td>
                        </tr>
                    </table>
                </EmptyDataTemplate>
            </asp:ListView>
        <div class="left-menu-wrap" id="divLeftMenu">
	        <dl>
		         <dt style="border-bottom:1px solid #eaeaea;">
			        <strong>마이페이지</strong>
		        </dt>
		        <dd>
                        <a href="/Order/OrderHistoryList.aspx">주문조회</a> 
                    </dd>
                    <dd>
                        <a href="/Delivery/DeliveryOrderList.aspx">배송조회</a> 
                    </dd>
                    <dd>
                        <a href="/Order/OrderBillIssue.aspx">세금계산서 조회</a> 
                    </dd>
                    <dd>
                        <a href="/Member/MemberEditCheck.aspx">마이정보변경</a> 
                    </dd>
                    <dd class="active">
                        <a href="/Delivery/DeliveryList.aspx">배송지관리</a> 
                    </dd>
	        </dl>
        </div>
        </div>


</asp:Content>

