<%@ Page Title="" Language="C#" MasterPageFile="~/Master/Default.master" AutoEventWireup="true" CodeFile="OrderBillList.aspx.cs" Inherits="Order_OrderBillList" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <link href="../Content/Order/order.css" rel="stylesheet" />
    <link href="../Content/popup.css" rel="stylesheet" />

    <script type="text/javascript">
        var is_sending = false;

        $(function () {

            //realTimeInfo(); //첫번째 테이블
            setInitData();
            fnSearch(1); //List
            AllCheckbox(); //체크박스 전체선택

        });

        // enter key 방지
        $(document).on("keypress", "#OrderBilltbl input", function (e) {
            if (e.keyCode == 13) {
                e.preventDefault();
                return false;
            }
            else
                return true;
        });

        function setInitData() {
            var nowDate = new Date();
            var month = nowDate.getMonth() + 1; //현재달
            $("#spanMonth").text(month);

            var strMonth = '';
            if (month < 10) strMonth = "0" + month;

            $("#hdNowMonth").val(strMonth);
        }

        function fnQnaReqInfo() {
            alert("담당자에게 문의전화 바랍니다.\n" + $("#hdUAdminTelNo").val());//수정 필요한 부분
            return false;
        }

        function showCarryForwardPopup(el) {
            $("#txtReason").val($(el).parent().parent().find("#hdReason").val());
            $("#hdReason_pop").val($(el).parent().parent().find("#hdUnum_orderNo").val());

            var e = document.getElementById('CarryForwardDiv');

            if (e.style.display == 'block') {
                e.style.display = 'none';

            } else {
                e.style.display = 'block';
            }
        }

        //팝업창 저장버튼 눌렀을 때
        function fnSave_pop() {

            var svidUser = '<%= Svid_User%>';
            var Unum_OrderNo_Arr = $("#hdReason_pop").val();

            var cfResult = confirm("이월사유를 저장하시겠습니까?");
            var reasonVal = $("#txtReason").val().trim();

            if (!cfResult) return false;
            if (isEmpty(reasonVal)) {
                alert("이월사유를 입력해 주세요.");
                return false;
            }
            
            var callback = function (response) {
                if (response === "Success") {
                    alert("성공적으로 이월사유가 저장되었습니다.");
                } else {
                    alert("이월사유 저장에 실패하였습니다. 관리자에게 문의바랍니다.");
                }
            }

            var param = {
                SvidUser: svidUser,
                Unum_OrderNo_Arr: Unum_OrderNo_Arr,
                OrderNextEndReason: $("#txtReason").val(),
                OrderNextEndConfirm: '',
                P_Flag: 'NEXTREQ_2',
                Method: 'UpdateOrderNextEnd'
            };
            
            var beforeSend = function () {
                is_sending = true;
            }
            var complete = function () {
                is_sending = false;
                window.location.reload(true);
            }
            if (is_sending) return false;

            JqueryAjax('Post', '../Handler/OrderHandler.ashx', true, false, param, 'text', callback, beforeSend, complete, true, svidUser);
        }

         function fnCancel() {
             $('.popupdiv').fadeOut();
             return false;
         }

         //조회하기
         function fnSearch(pageNum) {
            <%--var startDate = $('#<%= txtSearchSdate.ClientID%>').val();
            var endDate = $('#<%= txtSearchEdate.ClientID%>').val();--%>
             //var startDate = $("#hdSartDate").val();
             //var endDate = $("#hdEndDate").val();
             //var pageSize = 20;
             var asynTable = "";
             var completeTypeCnt = 0;
             var callback = function (response) {
                 $("#OrderBilltbl tbody").empty();

                 if (!isEmpty(response)) {
                     $.each(response, function (key, value) {
                         var goodsInfo = "[" + value.BrandName + "] " + value.GoodsFinalName + "<br>" + value.GoodsOptionSummaryValues;
                         //마감현황(이월요청(4)이면 버튼으로)
                         var orderEndType_Name = value.OrderEndType_Name;
                         var checkbox = "";
                         
                         if (value.OrderEndType == "0") {
                             orderEndType_Name = "입고확인";

                         } else if (value.OrderEndType == 3) { //마감완료존재 체크
                             completeTypeCnt++;
                         
                         } else if (value.OrderEndType == 4) {
                             //var orderEndType_Name = "<input type='hidden' id='hdReason' value='" + value.OrderNextEndReason + "'/><img src='' alt='이월요청' onclick='showCarryForwardPopup(this); return false;'/>"; //버튼추가

                             orderEndType_Name = "<input type='hidden' id='hdReason' value='" + value.OrderNextEndReason + "'/><input type='button' class='listBtn' value='이월요청' style='width:71px; height:22px; font-size:12px' onclick='showCarryForwardPopup(this); return false;' />"; //버튼추가
                             
                             checkbox = "<input type='checkbox' disabled='true' />";
                         } else {
                             checkbox = "<input type='checkbox' checked='checked' />";
                         }

                         var orderEntDate = value.OrderEntryDate.substr(0, 10);

                         var orderEndType = value.OrderEndType;
                         var viewMonthNm = '';

                         if (orderEndType == '6') {

                             if (orderEntDate.split('-')[1] == $("#hdNowMonth").val()) {

                                 var nextMonth = Number($("#hdNowMonth").val()) + 1;
                                 if (nextMonth > 12) nextMonth = 1;

                                 var strNextMonth = '';
                                 if (nextMonth < 10) {
                                     strNextMonth = "0" + nextMonth;
                                 }

                                 viewMonthNm = "(" + strNextMonth + "월) ";

                             } else {
                                 //checkbox = "<input type='checkbox' checked='checked' disabled='true' />";
                                 checkbox = '';
                             }
                         }

                         //$("#hdTotalCount").val(value.TotalCount);
                         $("#spanCnt").text(value.OrderNextEnd_CNT);
                         asynTable += "<tr name='trColor'>"
                         asynTable += "<td class='txt-center'>" + checkbox + "</td>";
                         asynTable += "<td class='txt-center'>" + value.RowNumber + "</td>";

                         var dlvrDate = value.DeliveryDate;
                         if (!isEmpty(dlvrDate)) {
                             dlvrDate = "<br>(" + fnOracleDateFormatConverter(dlvrDate) + ")";
                         }

                         asynTable += "<td class='txt-center'>" + orderEntDate + dlvrDate + "</td>";
                         asynTable += "<td class='txt-center'><input type='hidden' id='hdUnum_orderNo' value='" + value.Unum_OrderNo + "'>" + value.OrderCodeNo + "</td>";
                         asynTable += "<td>" + goodsInfo + "</td>";
                         asynTable += "<td style='text-align:right'>" + numberWithCommas(value.GoodsSalePriceVAT) + "원</td>";
                         asynTable += "<td class='txt-center'>" + value.Qty + "</td>";
                         asynTable += "<td style='text-align:right'>" + numberWithCommas(value.GoodsTotalSalePriceVAT) + "원</td>";
                         asynTable += "<td class='txt-center'><input type='hidden' name='hdOrderEndType' value='" + value.OrderEndType + "'>" + viewMonthNm + orderEndType_Name + "</td></tr>";


                         $("#hdUAdminTelNo").val(value.UrianAdminTelNo);
                     });
                 } else {
                     asynTable += "<tr><td colspan='9' class='txt-center'>" + "조회된 내역이 없습니다." + "</td></tr>"
                     //$("#hdTotalCount").val(0);
                 }
                 $("#OrderBilltbl tbody").append(asynTable);
                 if (completeTypeCnt == 0) { //마감완료가 존재하지 않아야 요청버튼들 보이게 처리
                     $('#btnOrderNextEnd').css('display', '');
                     $('#btnEndRequest').css('display', '');
                 }
                 setColor();
                 //fnCreatePagination('pagination', $("#hdTotalCount").val(), pageNum, 8, getPageData);
             }

             var param = {
                 SvidUser: '<%=Svid_User %>',
                    //OrderEndType: 0,
                    TodateB: $('#<%= hdSartDate.ClientID%>').val(),
                    TodateE: $('#<%= hdEndDate.ClientID%>').val(),
                    //PageNo: pageNum,
                    //PageSize: pageSize,
                    Method: 'GetMonthDeadLineList'
                };

                JajaxSessionCheck('Post', '../../Handler/OrderHandler.ashx', param, 'json', callback, '<%= Svid_User%>');

         }

         //function getPageData() {
         //    var container = $('#pagination');
         //    var getPageNum = container.pagination('getSelectedPageNum');
         //    fnSearch(getPageNum);
         //    return false;
         //}


         function fnEnter() {

             if (event.keyCode == 13) {
                 fnSearch();
                 return false;
             }
             else
                 return true;
         }


         //체크박스 전체 선택
         function AllCheckbox() {
             $("#checkAll").change(function () {
                 if ($("#checkAll").is(":checked")) { //체크박스 선택
                     $('#OrderBilltbl input[type="checkbox"]').each(function () {
                         $(this).prop('checked', 'checked');
                     });
                 } else {
                     $('#OrderBilltbl input[type="checkbox"]').each(function () {
                         $(this).prop('checked', '');
                     });
                 }
             });
         }

         //이월요청
         function fnOrderNextEnd() {
             if (fnValidation_NextEnd()) {
                 var svidUser = '<%= Svid_User%>';
                    var Unum_OrderNo_Arr = "";
                    $("#OrderBilltbl tbody tr").each(function () {
                        var chk = $(this).find("input[type=checkbox]").prop('checked');
                        if (chk == true) {
                            var Unum_OrderNo = $(this).find("#hdUnum_orderNo").val();

                            Unum_OrderNo_Arr += Unum_OrderNo + '/';
                        }

                    });

                    var callback = function (response) {

                        if (response == "Success") {
                            alert('성공적으로 이월요청이 되었습니다.');
                        } else {
                            alert("이월요청에 실패하였습니다. 관리자에게 문의바랍니다.");
                        }
                    }

                    //var complFunc = function () {
                    //     window.location.reload(true);
                    //}
                    var param = {
                        SvidUser: svidUser,
                        Unum_OrderNo_Arr: Unum_OrderNo_Arr,
                        OrderNextEndReason: '',
                        OrderNextEndConfirm: '',
                        P_Flag: 'NEXTREQ_1',
                        Method: 'UpdateOrderNextEnd'
                    };

                    //JajaxSessionCheckCompl('post', '../../Handler/OrderHandler.ashx', param, 'json', callback, complFunc, svidUser);

                    var beforeSend = function () {
                        is_sending = true;
                    }
                    var complete = function () {
                        is_sending = false;
                        window.location.reload(true);
                    }

                    if (is_sending) return false;

                    JqueryAjax('Post', '../Handler/OrderHandler.ashx', true, false, param, 'text', callback, beforeSend, complete, true, svidUser);
                }
            }

            //이월요청 유효성 체크
            function fnValidation_NextEnd() {
                var cnt = 0;
                var cnt2 = 0;
                //마감전인지 체크
                $("#OrderBilltbl tbody tr").each(function () {

                    var chk = $(this).find("input[type=checkbox]").prop('checked');

                    if (chk) {
                        if ($(this).find("input:hidden[name='hdOrderEndType']").val() != 1) {
                            ++cnt;
                        }
                        ++cnt2;
                    }

                });

                if (cnt2 < 1) {
                    alert('이월요청 할 상품을 선택해 주세요.');
                    return false;
                }

                if (cnt > 0) {
                    alert('이월요청은 마감전 상태만 가능합니다.');
                    return false;
                }

                if (!confirm('정말로 이월요청을 하시겠습니까?')) {
                    return false;
                }

                return true;
            }

            //마감요청
            function fnEndRequest() {
                if (fnValidation_EndReq()) {

                    var svidUser = '<%= Svid_User%>';
                    var Unum_OrderNo_Arr = "";
                    $("#OrderBilltbl tbody tr").each(function () {
                        var chk = $(this).find("input[type=checkbox]").prop('checked');
                        var Unum_OrderNo = $(this).find("#hdUnum_orderNo").val();
                        if (chk == true) {
                            Unum_OrderNo_Arr += Unum_OrderNo + '/';
                        } else {

                            var ordEndType = $(this).find("input:hidden[name='hdOrderEndType']").val();

                            if (ordEndType == '6') {
                                Unum_OrderNo_Arr += Unum_OrderNo + '/';
                            }
                        }
                    });
                    
                    if (isEmpty(Unum_OrderNo_Arr)) {
                        alert('마감요청 할 상품을 선택해 주세요.');
                        return false;
                    }

                    if (!confirm('정말로 마감요청을 하시겠습니까?')) {
                        return false;
                    }

                    var callback = function (response) {
                        if (response === "Success") {
                            alert("성공적으로 마감이 요청 되었습니다.");
                        } else {
                            alert("마감요청에 실패하였습니다. 관리자에게 문의바랍니다.");
                        }
                    }
                    
                    var param = {
                        SvidUser: svidUser,
                        Unum_OrderNo_Arr: Unum_OrderNo_Arr,
                        P_Flag: 'ENDREQ_1',
                        Method: 'UpdateOrderEndReq'
                    };
                    
                    var beforeSend = function () {
                        is_sending = true;
                    }
                    var complete = function () {
                        is_sending = false;
                        window.location.reload(true);
                    }
                    if (is_sending) return false;

                    JqueryAjax('Post', '../Handler/OrderHandler.ashx', true, false, param, 'text', callback, beforeSend, complete, true, svidUser);
                }
            }

            //마감요청 유효성 체크
            function fnValidation_EndReq() {
                var cnt = 0;
                var cnt2 = 0;
                //유효성검사           
                //1) 체크안된 항목중에서 마감전 있으면 알림
                $("#OrderBilltbl tbody tr").each(function () {
                    var chk = $(this).find("input[type=checkbox]").prop('checked');
                    if ((chk == false) && ($(this).find("input:hidden[name='hdOrderEndType']").val() == 1)) {
                        ++cnt;
                    }
                });
                if (cnt > 0) {
                    alert('체크 안된 상품중 마감전인 상품이 있으니 확인해 주시기 바랍니다.\n(이월건은 이월요청을 먼저 해 주시기 바랍니다.)');
                    return false;
                }

                //2)이월요청 사유 안쓴 건 있는지 체크
                $("#OrderBilltbl tbody tr").each(function () {
                    var reason = $(this).find("#hdReason").val();
                    var orderEndType = $(this).find("input:hidden[name='hdOrderEndType']").val();
                    if (isEmpty(reason) && orderEndType == '4') {
                        ++cnt2;
                    }
                });
                if (cnt2 > 0) {
                    alert("이월요청 " + cnt2 + "건에 대한 사유를 각각 입력해 주시기 바랍니다.");
                    return false;
                }


                return true;

            }

            //마감현황(=이월요청이면) 색칠
            function setColor() {
                $("#OrderBilltbl tbody tr").each(function () {
                    var val = $(this).find("input:hidden[name='hdOrderEndType']").val();
                    if (val == '4') {
                        $(this).css('background-color', '#FFB4B4');
                    }
                });
            }
        
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div class="sub-contents-div">
        <!--제목 타이틀-->
        <div class="sub-title-div">
            <p class="p-title-mainsentence"><img src="../Images/SiteImage/title-img.jpg" class="img-title"/>정산내역조회 
        </div>

        <!--탭메뉴-->
        
        <div class="div-main-tab" style="width: 100%; ">
            <ul>
                <li  class='tabOn' style="width: 185px;" onclick="location.href='OrderBillList.aspx'">
                    <a href="OrderBillList.aspx" >마감신청</a>
                </li>
                <li  class='tabOff' style="width: 185px;" onclick="location.href='OrderBillListSch.aspx'">
                    <a href="OrderBillListSch.aspx" >내역조회</a>
                 </li>
                <li  class='tabOff' style="width: 185px;" onclick="location.href='OrderBillPayment.aspx'">
                    <a href="OrderBillPayment.aspx" >대금결제</a>
                 </li>
            </ul>
        </div>



        <!--상단 조회영역 시작-->
        <div class="search-div">

            <!-- 상단 서브 테이블 -->
            <div>
                <div style="font-weight: bold; font-size: 25px; margin-bottom: 15px">
                    <input type="hidden" id="hdNowMonth" /><span id="spanMonth" style="font-weight: bold; font-size: 25px; margin-bottom: 15px"></span>월분</div>

                <table class="CommonList-tbl">
                    <colgroup>
                        <col style="width: 10%" />
                        <col style="width: 12%" />
                        <col style="width: 13%" />
                        <col style="width: 15%" />
                        <col style="width: 10%" />
                        <col style="width: 15%" />
                        <col style="width: 10%" />
                        <col style="width: 15%" />
                    </colgroup>
                    <thead>
                        <%-- <tr class="txt-center">
                        <th>여신한도</th>
                        <td id="tdLoadPrice" style="text-align:right; padding-right: 5px;" ></td>
                        <th>미수금</th>
                        <td id="tdLoadUsePrice" style="text-align:right; padding-right: 5px;"></td>
                        <th>당월마감예상액</th>
                        <td id="tdLoadMonsPayPrice" style="text-align:right; padding-right: 5px;"></td>
                        <th>예상잔여한도</th>
                        <td id="tdRemainPrice" style="text-align:right; padding-right: 5px;"></td>
                    </tr>--%>

                        <tr class="txt-center">
                            <th>
                                <input type="hidden" id="hdUAdminTelNo">월 마감일</th>
                            <td id="tdLoadEndDate">
                                <asp:Label ID="lbLoadEndDate" runat="server"></asp:Label></td>
                            <th>세금계산서 발행일자 출력일</th>
                            <td id="tdLoadBillDate">
                                <asp:Label ID="lbLoadBillDate" runat="server"></asp:Label></td>
                            <th>결제일</th>
                            <td id="tdLoadPayDate">
                                <asp:Label ID="lbLoadPayDate" runat="server"></asp:Label></td>
                        </tr>
                    </thead>
                </table>
            </div>
            <br />


            <%--            <table class="CommonList-tbl">

                <thead>
                    <tr>
                        <th colspan="8">정산내역조회</th>
                    </tr>
                </thead>

                <tr>
                    <th colspan="2" class="txt-center">입고 일자별 조회</th>
                    <td colspan="6">
                         <asp:TextBox ID="txtSearchSdate" type="date" runat="server" CssClass="calendar" ReadOnly="true" Onkeypress="return fnEnter();" Style="background-color:#ececec;"></asp:TextBox>&nbsp;&nbsp;
                            -
                            &nbsp;&nbsp;<asp:TextBox ID="txtSearchEdate" type="date" runat="server" CssClass="calendar" ReadOnly="true" Onkeypress="return fnEnter();" Style="background-color:#ececec;"></asp:TextBox>&nbsp;&nbsp;
                        <input type="checkbox" id="ckbSearch1" value="" checked="checked" name="chMonth"/><label for="ckbSearch1">당월</label>&nbsp;
                        <input type="checkbox" id="ckbSearch2" value="" name="chMonth"/><label for="ckbSearch2">전월</label> &nbsp;&nbsp;
                        <input type="checkbox" id="ckbSearch3" value="" name="chMonth"/><label for="ckbSearch3">전전월</label> &nbsp;&nbsp;
                        (&nbsp;<input type="checkbox" id="ckbSearch4" value="" /><label for="ckbSearch4">분할설정1</label>&nbsp;
                        <input type="checkbox" id="ckbSearch5" value="" /><label for="ckbSearch5">분할설정2</label>&nbsp;)
                     
                    </td>
                </tr>

                <tr>
                    <th colspan="2">마감 현황 조회</th>
                    <td colspan="6">
                        <input type="checkbox" id="ckbSearch6" value="" checked="checked" /><label for="ckbSearch6">마감전</label>&nbsp;
                        <input type="checkbox" id="ckbSearch7" value="" /><label for="ckbSearch7">마감이월</label>&nbsp;
                        <input type="checkbox" id="ckbSearch8" value="" /><label for="ckbSearch8">마감</label>&nbsp;
                    </td>
                </tr>     
            </table>

                 <!--버튼-->
                <div class="bt-align-div">
                    <a><img alt="조회하기" src="../Images/Goods/aslist.jpg" id="btnSearch" onclick="fnSearch(1); return false;" onmouseover="this.src='../Images/Wish/aslist-over.jpg'" onmouseout="this.src='../Images/Goods/aslist.jpg'" /></a>
                </div>--%>
        </div>

        <!--상단 조회영역 끝-->
        <br />
        <div>
            <span style="font-weight: bold; margin-bottom: 5px">* 마감 미신청시 마감일 +3일 기준으로 자동 마감완료 됩니다.</span><br />
            <span style="font-weight: bold; margin-bottom: 5px">* 이월요청 상품이 필요한 경우 상품 선택 후 이월요청 버튼을 이용해 주세요.</span>
        </div>
        <br />
        <div style="width: 100%; padding-bottom: 20px">
            <div style="display: inline-block;">
                <span style="font-weight: bold; margin-bottom: 5px;">* 이월사유 미작성 : <span style="color: red" id="spanCnt"></span>건</span>
            </div>

            <!--조회하기 버튼-->
            <div style="display: inline-block; float: right">
                <%--<input type="button" class="commonBtn" style="width: 95px; height: 30px; font-size: 12px" value="엑셀다운" onclick="return fnExcelDownload();" />--%>

                 <asp:Button runat="server" ID="btnExcel" CssClass="commonBtn" Text="엑셀다운" Font-Size="12px" Width="95px" Height="30px" OnClick="btnExcel_Click"/>

                <input type="button" id="btnOrderNextEnd" class="commonBtn" style="width: 95px; height: 30px; font-size: 12px; display: none" value="이월요청" onclick="fnOrderNextEnd(); return false;" />
                <input type="button" id="btnEndRequest" class="commonBtn" style="width: 95px; height: 30px; font-size: 12px; display: none" value="마감요청" onclick="fnEndRequest(); return false;" />
                <input type="button" class="commonBtn" style="width: 95px; height: 30px; font-size: 12px" value="문의요청" onclick="return fnQnaReqInfo();" />
            </div>
        </div>

        <!--하단 리스트영역 시작-->
        <div class="list-div" style="width: 1218px;">


            <div style="height: 600px; width: 100%; overflow: auto;">
                <table class="CommonList-tbl" id="OrderBilltbl" style="overflow: scroll;">
                    <thead>
                        <tr>
                            <th style="width: 35px;">선택<br />
                                <input type="checkbox" checked='checked' id="checkAll" /></th>
                            <th style="width: 35px;">번호</th>
                            <th style="width: 105px;">입고일자<br />(배송일자)</th>
                            <th style="width: 95px;">주문번호</th>
                            <th style="width: 300px;">주문상품정보</th>
                            <th style="width: 105px;">상품단가</th>
                            <th style="width: 50px;">주문수량</th>
                            <th style="width: 105px;">주문금액</th>
                            <%--                        <th style="width: 105px;">주문현황</th>--%>
                            <th style="width: 105px;">마감현황</th>
                        </tr>

                    </thead>
                    <tbody>
                        <tr>
                            <td colspan="9" class="txt-center">리스트을 조회해 주시기 바랍니다.</td>
                        </tr>
                    </tbody>
                </table>
            </div>
            <%--<input type="hidden" id="hdSartDate"/>
            <input type="hidden" id="hdEndDate"/>--%>
            <asp:HiddenField runat="server" ID="hdSartDate"></asp:HiddenField>
            <asp:HiddenField runat="server" ID="hdEndDate"></asp:HiddenField>
            <br />
            <input type="hidden" id="hdTotalCount" />
            <!-- 페이징 처리 -->
            <%--<div style="margin: 0 auto; text-align: center">
                <div id="pagination" class="page_curl" style="display: inline-block"></div>
            </div>--%>
        </div>
        <!--하단 리스트 영역 끝 -->
    </div>


    <%--마감이월사유 팝업 시작--%>

    <div id="CarryForwardDiv" class="popupdiv">
        <div class="popupdivWrapper" style="width: 620px; margin: 100px auto; background-color: #ffffff;">
            <div class="popupdivContents" style="background-color: #ffffff; padding: 15px;">

                <div class="close-div">
                    <a onclick="fnCancel()" style="cursor: pointer">
                        <img src="../../Images/Wish/icon-delete.jpg" alt="닫기" style="float: right;" /></a>
                </div>

                <div class="popup-title" style="margin-top: 20px;">
                    <%--<img src="" alt="마감 이월 사유" />--%>
                    <h3 class="pop-title">마감 이월 사유</h3>
                    <br />

                    <div style="height: 150px">
                        <table class="board-table">
                            <thead>
                                <tr>
                                    <th>마감 이월 사유</th>
                                    <td style="padding-left: 1px">
                                        <textarea id="txtReason" style="width: 100%; height: 100px; resize: none;" placeholder="사유를 작성해주세요."></textarea></td>
                                </tr>
                            </thead>
                        </table>
                    </div>
                    <input type="hidden" id="hdReason_pop" />
                </div>

                <!-- 팝업버튼 -->
                <div style="margin-top: 10px; text-align: right">
                    <input type="button" class="commonBtn" style="width:95px; height:30px; font-size:12px" value="저장" onclick="return fnSave_pop();"/>
                    <input type="button" class="commonBtn" style="width:95px; height:30px; font-size:12px" value="닫기" onclick="return fnCancel();"/>
                </div>
            </div>
        </div>
    </div>

</asp:Content>

