<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Master/AdminMasterPage.master" AutoEventWireup="true" CodeFile="OrderAreaList.aspx.cs" Inherits="Admin_Order_OrderAreaList" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
   <%--<link href="../Content/order/order.css" rel="stylesheet" />--%>
    <link href="../Content/goods/goods.css" rel="stylesheet" />
   
    <script type="text/javascript">
        $(document).ready(function () {
            fnOrderAreaCodeBind();

        });

        var is_sending = false;

        function fnOrderAreaCodeBind() {
            var callback = function (response) {
                $('#SearchTarget').empty();
                // $('#SearchTarget').prepend('<option value="">--선택--</option>');

                for (var i = 0; i < response.length; i++) {
                    var createHtml = '';

                    createHtml = '<option value="' + response[i].OrderBelongCode + '">' + response[i].OrderBelongName + '</option>';
                    $('#SearchTarget').append(createHtml);

                }
                fnSearch(1);
                return false;
            }

            var sUser = '<%=Svid_User %>';

            var param = {
                Method: 'OrderBelongPopupList'
            };

            JajaxSessionCheck('Post', '../../Handler/OrderHandler.ashx', param, 'json', callback, '<%=Svid_User%>');
        }

        function fnEnter() {

            if (event.keyCode == 13) {
                fnSearch(1);
                return false;
            }
            else
                return true;
        }

        function fnSearch(pageNum) {
            var target = $("#SearchTarget").val();
            var searchKeyword = $("#txtSearchKeyword").val();
            var pageSize = 20;
            var i = 1;
            var asynTable = "";
            var DelFlag = "";
            var btnDelFlag = "";
            var DfVisibleS = "";
            var DfVisibleU = "";


            var callback = function (response) {

                $("#tblOrderAreaList tbody").empty();

                if (!isEmpty(response)) {
                    $.each(response, function (key, value) {

                        $("#hdTotalCount").val(value.TotalCount);

                        if (value.DelFlag == 'N') {
                            DelFlag = "ico_use.png"
                            btnDelFlag = "사용중지"
                            DfVisibleS = "hdDeflagStop"
                            DfVisibleU = ""
                        }
                        else {
                            DelFlag = "ico_stopUsing.png"
                            btnDelFlag = "사용"
                            DfVisibleS = "hdDeflagUse"
                            DfVisibleU = ""
                        }

                        asynTable += "<tr style='text-align:cetner'>"
                        asynTable += "<td class='txt-center'>" + (pageSize * (pageNum - 1) + i) + "</td>";
                        asynTable += "<td class='txt-center'>" + value.OrderAreaCode + "<input type='hidden' name='hdAreaCode' value='" + value.OrderAreaCode + "' /></td>";
                        asynTable += "<td class='txt-center'>" + value.OrderAreaName + "</td>";
                        asynTable += "<td class='txt-center'><img src='../Images/Order/"+DelFlag+"' /> <input type='hidden' name='hdDelFlag' value='" + value.DelFlag + "' /></td>";
                        asynTable += "<td class='txt-center'><input type='button' id='"+DfVisibleS+"' class='btnDelete' name='hdDelFlag' value='"+btnDelFlag+"' onClick='fnCategoryManagement(this); return false;'/></td>";
                        asynTable += "<td class='txt-center'>" + value.Remark + "</td>";
                        asynTable += "<td class='txt-center'>" + value.EntryDate.split('T')[0] + "</td></tr>";
                        i++;

                    });
                } else {
                    asynTable += "<tr><td colspan='7' class='txt-center'>" + "조회된 정보가 없습니다." + "</td></tr>"
                    $("#hdTotalCount").val(0);
                }
                $("#tblOrderAreaList tbody").append(asynTable);
                fnCreatePagination('pagination', $("#hdTotalCount").val(), pageNum, 20, getPageData);
            }


            var sUser = '<%=Svid_User %>';

            var param = {
                Method: 'OrderAreaList',
                Target: target,
                SearchKeyword: searchKeyword,
                PageNo: pageNum,
                PageSize: pageSize
            };

            JajaxSessionCheck('Post', '../../Handler/OrderHandler.ashx', param, 'json', callback, '<%=Svid_User%>');
        }

        function getPageData() {
            var container = $('#pagination');
            var getPageNum = container.pagination('getSelectedPageNum');
            fnSearch(getPageNum);
            return false;
        }


        // 해당 주문 소속 코드 사용중 & 사용중지 이벤트 
        function fnCategoryManagement(el) {

            var setCode = '';
            var setAreaCode = $(el).parent().parent().find("input[name='hdAreaCode']").val();
            var delFlag = $(el).parent().parent().find("input[name='hdDelFlag']").val();

            if (delFlag == 'Y') {
               // alert('N')
                setCode = 'N'
            }

            else {
               // alert('Y')
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
                Method: 'UpdateAreaUse',
                SvidUser: '<%= Svid_User%>',
                AreaCode: setAreaCode,
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
            JajaxDuplicationCheck('Post', '../../Handler/OrderHandler.ashx', param, 'text', callback, beforeSend, complete, true, '<%=Svid_User%>');

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
                    <li class='tabOff' style="width: 185px;" onclick="fnTabClickRedirect('OrderBelongMain');">
                        <a onclick="fnTabClickRedirect('OrderBelongMain');">주문 소속</a>
                    </li>
                    <li class='tabOn' style="width: 185px;" onclick="fnTabClickRedirect('OrderAreaList');">
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
                    <span class="subTabOn" style="width: 186px; height: 35px; cursor: pointer;" id="btnTab1" onclick="fnTabClickRedirect('OrderAreaList.aspx');">주문 지역 조회</span>
                    <span class="subTabOff" style="width: 186px; height: 35px; cursor: pointer;" id="btnTab2" onclick="fnTabClickRedirect('OrderAreaRegister.aspx');">주문 지역 등록</span>

                </div>
            </div>



            <!--상단영역 시작-->
            <div class="OrderSearch-div" style="margin-top: 30px">
                <table id="tblSearch_A" class="tbl_main" style="height: 50px;">
                    <tr>
                        <th colspan="7" style="height: 50px">주문 지역 조회</th>
                    </tr>
                    <tr>
                        <th style="width: 10%;">주문 소속
                        </th>
                        <td>
                            <select id="SearchTarget" class="dropA1">
                            </select>
                        </td>
                        <th>
                            <input type="text" id="txtSearchKeyword" placeholder="지역을 입력하세요"onkeypress="return fnEnter();"  style="width:80%;"/>
                            <input type="button" onclick="fnSearch(1); return false;" value="검색" style="width:75px" class="mainbtn type1" />
                        </th>
                    </tr>
                </table>
            </div>

            <br />
            <!--상단영역 끝-->

            <!-- 테이블영역 -->
            <div>
                <table class="tbl_main" id="tblOrderAreaList">
                    <colgroup>
                        <col style="width: 5%" />
                        <col style="width: 20%" />
                        <col style="width: 20%" />
                        <col style="width: 20%" />
                        <col style="width: 10%" />
                        <col style="width: 10%" />
                        <col style="width: 20%" />
                    </colgroup>
                    <thead>
                        <tr>
                            <th>번호</th>
                            <th>주문 지역 코드</th>
                            <th>주문 지역명</th>
                            <th>사용 유무</th>
                            <th>설정</th>
                            <th>비고</th>
                            <th>등록날짜</th>
                        </tr>

                    </thead>
                    <tbody>
                        <tr>
                            <td colspan="7" class="auto-style1">조회된 정보가 없습니다.</td>
                        </tr>
                    </tbody>

                </table>
            </div>

            <br />

            <input type="hidden" id="hdTotalCount" />

            <!-- 페이징 처리 -->
            <div style="margin: 0 auto; text-align: center">
                <div id="pagination" class="page_curl" style="display: inline-block"></div>
            </div>
        </div>

    </div>

</asp:Content>

