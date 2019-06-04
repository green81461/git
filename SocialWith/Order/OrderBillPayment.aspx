<%@ Page Title="" Language="C#" MasterPageFile="~/Master/Default.master" AutoEventWireup="true" CodeFile="OrderBillPayment.aspx.cs" Inherits="Order_OrderBillPayment" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <link href="../Content/Order/order.css" rel="stylesheet" />
    <link href="../Content/popup.css" rel="stylesheet" />

    <script type="text/javascript">
        $(document).ready(function () {
            ListCheckboxOnlyOne("tblSearch");

            fnOrderList();
            $("#totalAmt").val('0');
        });



        //체크박스 개별 선택 값 넘기기.
        function chkClick(el) {

            var rowEl = $(el).parent();

            if (el.checked) {

                $("#spGdsSalePriceVat").text(numberWithCommas($(rowEl).find("input:hidden[name='hdGoodsSalePriceVat']").val()));

                var dfCost = Number($(rowEl).find("input:hidden[name='hdDeliveryCost']").val());
                var pwCost = Number($(rowEl).find("input:hidden[name='hdPowerDeliveryCost']").val());

                $("#spDeliveryCost").text(numberWithCommas(dfCost + pwCost));

                $("#spFinalPrice").text(numberWithCommas($(rowEl).find("input:hidden[name='hdAmt']").val()));

            } else {
                $("#spGdsSalePriceVat").text('');
                $("#spDeliveryCost").text('');
                $("#spFinalPrice").text('');
            }

            //var maxChecked = 1;   //선택가능한 체크박스 갯수
            //var totalChecked = $("#hdCheckChk").val();

            //if (el.checked) {
            //    totalChecked = Number(totalChecked) + 1;
            //    $("#hdCheckChk").val(totalChecked);
            //}
            //else {
            //    totalChecked = Number(totalChecked) - 1;
            //    $("#hdCheckChk").val(totalChecked);
            //}


            //if (totalChecked > maxChecked) {
            //    alert("최대 1개까지만 선택 가능합니다.");
            //    el.checked = false;
            //    $("#hdCheckChk").val('1');
            //}
            //else {

            //    var Price = $(el).parent().parent().find("input:hidden[name='hdTotalAmt']").val();
            //    var tmp = $(el).parent().parent().find("input:checkbox[name='chkOrder']").prop('checked');


            //    sumAmt(Price, tmp)
            //}

        }

        function sumAmt(Price, tmp) {
            var sumTotalPrice = $("#totalAmt").val();

            if (tmp == true) {
                sumTotalPrice = parseInt(sumTotalPrice) + parseInt(Price);
            }
            else if (tmp == '전체선택') {
                sumTotalPrice = '0'
                sumTotalPrice = parseInt(sumTotalPrice) + parseInt(Price);
            }

            else {
                if (Price == '전체취소') {
                    sumTotalPrice = '0'
                }
                else {
                    sumTotalPrice = parseInt(sumTotalPrice) - parseInt(Price);
                }
            }

            var FinalPrice = numberWithCommas(sumTotalPrice);
            $("#FinalPrice").val(FinalPrice);

            $("#totalAmt").val(sumTotalPrice);
        }



        function showEndPopup(el) {
            var e = document.getElementById('EndPop');

            if (e.style.display == 'block') {
                e.style.display = 'none';

            } else {
                e.style.display = 'block';
            }
            return false;
        }


        function fnPopupclose() {
            history.back();
        }


        function showDetailPopup(el) {
            var e = document.getElementById('DetailDiv');

            if (e.style.display == 'block') {
                e.style.display = 'none';

            } else {
                e.style.display = 'block';
            }
            return false;
        }

        function fnCancel() {
            $('.popupdiv').fadeOut();
            return false;
        }

        //바인딩
        function fnOrderList() {
            var asynTable = "";
            var sUser = '<%=Svid_User %>';
            var ComCode = '<%=UserInfoObject.UserInfo.Company_Code%>';

            var callback = function (response) {
                $("#tblSearch tbody").empty();
                if (!isEmpty(response)) {

                    $.each(response, function (key, value) {
                        var payway = value.PayWay;
                        if (key === 0) {
                            $('#hdCompany_Code').val(value.Company_Code); //히든 회사코드
                            $('#hdLoanCalDue').val(value.LoanCalDue);
                            $('#hdLoanPayDate').val(value.LoanPayDate);
                            $('#hdAdminUserName').val(value.AdminUserName); //히든 담당자이름
                            $('#hdAdminTelNo').val(value.AdminTelNo); //히든 담당자 번호
                            $('#hdAdminPhoneNo').val(value.AdminPhoneNo); //히든 담당자 폰번호
                            $('#hdAdminFaxNo').val(value.AdminFaxNo); //히든 fax번호
                            $('#hdAdminEmail').val(value.AdminEmail); //히든 이메일
                            $('#hdAdminUserId').val(value.AdminUserId); //히든 아이디
                            $('#hdBpayType').val(value.BpayType); //히든 주문번호
                            $('#hdPayWay').val(value.PayWay); //히든 결제수단
                            //$('#hdAccountNumber').val(value.AccountNumber); //히든 계좌번호
                            //$('#hdBankNm').val(value.BankNm); //히든 은행이름
                            $('#hdAccountHolder').val(value.AccountHolder); //히든 예금주명
                            //$('#hdBulkBankNo').val(value.BulkBankNo); //히든 벌크계좌명
                            $('#LoanPayDate').text(value.LoanPayDate); //결제일 보여주기

                            if (!isEmpty(payway)) {

                                if (payway == '6') {
                                    $('#hdAccountNumber').val(value.BulkBankNo);
                                    $('#hdBankNm').val(value.BulkBankNm);

                                } else {
                                    $('#hdAccountNumber').val(value.AccountNumber);
                                    $('#hdBankNm').val(value.BankNm);
                                }

                                $('#AccountNumber').text($('#hdBankNm').val() + " " + $('#hdAccountNumber').val());

                            } else {
                                alert("오류가 발생했습니다. 관리자에게 문의바랍니다.");

                                $('#AccountNumber').text('');

                                return false;
                            }
                        }
                        //$('#hdUnumPayNo').val(value.Unum_PayNo); //히든 시퀀스번호
                        //$('#hdOrderCodeNo').val(value.OrderCodeNo); //히든 주문번호
                        //$('#hdGoodsQty').val(value.GoodsQty); //히든 상품개수
                        //$('#hdAmt').val(value.Amt); //히든 결제금액
                        //$('#hdYY').val(value.YY); //히든 년도
                        //$('#hdMM').val(value.MM); //히든 월
                        //$('#hdOrderCnt').val(value.OrderCnt); //히든 주문개수
                        //$('#hdSumQty').val(value.SumQty); //히든 개수
                        //$('#hdGoodsSalePriceVat').val(value.GoodsSalePriceVat); //히든 상품결제금액
                        //$('#hdDeliveryCost').val(value.DeliveryCost); //히든 배송비
                        //$('#hdPowerDeliveryCost').val(value.PowerDeliveryCost); //히든 특수배송비


                        asynTable += "<tr name='trColor'>";
                        asynTable += "<td style='border:1px solid #a2a2a2; text-align:center' class='txt-center'>";
                        asynTable += "<input type='hidden' name='hdUnumPayNo' value='" + value.Unum_PayNo + "'>";
                        asynTable += "<input type='hidden' name='hdOrderCodeNo' value='" + value.OrderCodeNo + "'>";
                        asynTable += "<input type='hidden' name='hdGoodsQty' value='" + value.GoodsQty + "'>";
                        asynTable += "<input type='hidden' name='hdAmt' value='" + value.Amt + "'>";
                        asynTable += "<input type='hidden' name='hdYY' value='" + value.YY + "'>";
                        asynTable += "<input type='hidden' name='hdMM' value='" + value.YY + "'>";
                        asynTable += "<input type='hidden' name='hdOrderCnt' value='" + value.OrderCnt + "'>";
                        asynTable += "<input type='hidden' name='hdSumQty' value='" + value.SumQty + "'>";
                        asynTable += "<input type='hidden' name='hdGoodsSalePriceVat' value='" + value.GoodsSalePriceVat + "'>";
                        asynTable += "<input type='hidden' name='hdDeliveryCost' value='" + value.DeliveryCost + "'>";
                        asynTable += "<input type='hidden' name='hdPowerDeliveryCost' value='" + value.PowerDeliveryCost + "'>";
                        asynTable += "<input type='checkbox' name='chkOrder' onchange='chkClick(this)' /></td>";
                        asynTable += "<td style='border:1px solid #a2a2a2; text-align:center' class='txt-center' id='tdDeadline'>" + value.YY + '-' + value.MM + "</td>";
                        asynTable += "<td style='border:1px solid #a2a2a2; text-align:center' class='txt-center' id='tdOrderCodeNo'>" + value.OrderCodeNo + "</td>";
                        asynTable += "<td style='border:1px solid #a2a2a2; text-align:center' class='txt-center' id='tdOrderCnt'>" + value.OrderCnt + "  건 </td>";
                        asynTable += "<td style='border:1px solid #a2a2a2; text-align:center' class='txt-center' id='tdSumQty'>" + value.SumQty + "  건</td>";
                        asynTable += "<td style='border:1px solid #a2a2a2; text-align:center' class='txt-center' id='tdAmt'>" + numberWithCommas(value.Amt) + "  원 <input type= 'hidden' id= 'hdTotalAmt' name= 'hdTotalAmt' value= '" + value.Amt + "'</td>";
                        //  asynTable += "<td class='txt-center' style='display:none' id='tdPrice'>" + value.DeliveryCost + value.Amt + "   <input type= 'hidden' id= 'hdTotalAmt' name= 'hdTotalAmt' value= '" + (value.DeliveryCost + value.Amt) + "' ></td > ";

                        asynTable += "<td style='border:1px solid #a2a2a2; text-align:center;'><input type='button' class='listBtn' value='상세보기' style='width:71px; height:22px; font-size:12px' onclick='return showDetailPopup(this);' /></td></tr>";

                        $('#AdminName').val(value.AdminUserName);
                        $('#AdminTel').val(value.AdminTelNo);
                        $('#AdminPhoneNo').val(value.AdminPhoneNo);
                        $('#AdminFaxNo').val(value.AdminFaxNo);
                        $('#AdminEmail').val(value.AdminEmail);
                        //   $('#GoodsSalePriceVat').val(numberWithCommas(value.GoodsSalePriceVat));
                        //$('#DeliveryCost').val(numberWithCommas(value.DeliveryCost));


                        //$("#totalAmt").val(numberWithCommas(value.DeliveryCost + value.Amt));


                        //결제 수단에 따라 결제 할 계좌번호 보여주기
                        //if (PayWaychk == '6') {
                        //    $('#AccountNumber').text(value.BulkBankNo);
                        //}
                        //else {
                        //    $('#AccountNumber').text(value.AccountNumber);
                        //}

                    });
                } else {
                    asynTable += "<tr><td colspan='7' class='txt-center'>" + "리스트가 없습니다." + "</td></tr>"
                    // 여기서 다른 화면 띄워주면됨
                    //    alert('대금결제 내역이 없습니다.')
                    showEndPopup();

                }
                $("#tblSearch tbody").append(asynTable);
            }

            var param = {
                sUser: sUser,
                comCode: ComCode,
                Method: 'OrderBillPaymentList'
            };

            var beforeSend = function () { };
            var complete = function () { };
            JqueryAjax('Post', '../Handler/PayHandler.ashx', true, false, param, 'json', callback, beforeSend, complete, true, '<%=Svid_User%>');

  //          JajaxSessionCheck('Post', '../Handler/PayHandler.ashx', param, 'json', callback, '<%=Svid_User%>');
        }


        var is_sending = false;
        //Bill 결제
        function fnOrderPayment() {
            var sUser = '<%=Svid_User %>';
            <%--var ComCode = '<%=UserInfoObject.UserInfo.Company_Code%>';--%> //회사코드

            var unumPayNo = '';

            $('#tbodyOrdEnd tr').each(function (idx, el) {
                var chkFlag = $(el).find(":checkbox[name='chkOrder']").prop("checked");

                if (chkFlag) {
                    unumPayNo = $(el).find(":hidden[name='hdUnumPayNo']").val();
                }
            });

            var CmpanyCode = $("#hdCompany_Code").val(); //회사코드
            //var Unum_PayNo = $('#hdUnumPayNo').val(); //여신결제 시퀀스
            var VbankName = $('#hdBankNm').val(); //은행이름
            var VbankNo = $('#hdAccountNumber').val(); //계좌번호
            var BankTypeName = $('#hdAccountHolder').val(); //예금주

            //   var vBankDate = $('#hdAccountNumber').val(); //은행이름
            //  var paySucessYN
            // var flag = $('#hdAccountHolde').val(); //은행이름

            var PayWaychk = $("#hdPayWay").val();

            //결제수단이 여신결제(무)인 경우 동신계좌 보여주며 결제 요청 저장 끝.
            if (PayWaychk == '8') {
                var msg = "정말로 결제를 하시겠습니까?";
                if (confirm(msg)) {

                    var callback = function (response) {

                        if (!isEmpty(response) && (response == "OK")) {
                            alert('결제 신청이 완료 되었습니다.');
                        }
                        else {
                            alert('결제가 실패하였습니다. 관리자에게 문의바랍니다.');
                        }
                        return false;
                    };

                    var param = {
                        sUser: sUser,
                        //comCode: ComCode,
                        cmpanyCode: CmpanyCode,
                        unum_PayNo: unumPayNo,
                        vbankName: VbankName,
                        vbankNo: VbankNo,
                        bankTypeName: BankTypeName,
                        Method: 'OrderBillType8'
                    };

                    var beforeSend = function () {
                        is_sending = true;
                    }
                    var complete = function () {
                        is_sending = false;
                    }
                    if (is_sending) return false;

                    JqueryAjax('Post', '../Handler/PayHandler.ashx', true, false, param, 'text', callback, beforeSend, complete, true, '<%=Svid_User%>');

                } else {
                    return false;
                }

            }
            //결제수단이 여신결제 일반(6)일때, Request 팝업 오픈
            else {

                //var hdUnumPayNo = $("#hdUnumPayNo").val();
                //var hdCompany_Code = $("#hdCompany_Code").val();
                var totalAmt = $("#totalAmt").val();

                var url = "OrderRequest_Bill";
                var targetName = "OrdReqPopup";

                var roleFlag = "TYPE_1";

                var addForm = "<form name='ordPayForm' method='POST' action='" + url + "' target='" + targetName + "'>"
                    + "<input type='hidden' name='hdUnumPayNo' value='" + unumPayNo + "' />"
                    + "<input type='hidden' name='hdCompanyCode' value='" + CmpanyCode + "' />"
                    + "</form>";

                $("body").append(addForm);


                var popupForm = $("form[name='ordPayForm']");

                //var width = 820;
                //var height = 630;
                //var popupX = (window.screen.width / 2) - (width / 2);
                //var popupY = (window.screen.height / 2) - (height / 2);

                //url, target, width, height, status, toolbar,  menubar, location, resizable, scrollbar
                fnWindowOpen('', targetName, 820, 630, 'yes', 'no', 'no', 'no', 'no', 'no');

                // window.open("", targetName, "height=" + height + ", width=" + width + ",status=yes,toolbar=no,menubar=no,location=no,scrollbars=no,resizable=no, left=" + popupX + ", top=" + popupY + ", screenX=" + popupX + ", screenY= " + popupY + ";");

                popupForm.submit();
            }
        }

        //페이징 처리하는 것.(팝업창)
        function getPageData2() {
            var container = $('#pagination_2');
            var getPageNum = container.pagination('getSelectedPageNum');
            SearachPop(getPageNum, $("#hd_pop_uNumPay").val());
            return false;
        }


        //상세보기 팝업 visible
        function showDetailPopup(el) {

            var e = document.getElementById('DetailDiv');

            if (e.style.display == 'block') {
                e.style.display = 'none';

            } else {
                e.style.display = 'block';
            }

            // var uNumPay = $("#hdUnumPayNo").val();

            var uNumPay = $(el).parent().parent().find("input:hidden[name='hdUnumPayNo']").val();

            SearachPop(1, uNumPay);
            return false;
        }


        //팝업에서 상세보기 조회
        function SearachPop(pageNum, UnumPayNo) {


            //var searchKeyword = $("#txtLoanNo").val();   //여신결제번호


            var pageSize = 7;                                  //페이징 처리 사이즈
            var i = 1;                                          //페이징
            var asynTable = "";


            var callback = function (response) {

                $("#tblOrderBillListSchPop tbody").empty();

                if (!isEmpty(response)) {

                    $.each(response, function (key, value) {
                        $("#hdTotalCount_2").val(value.TotalCount);
                        if (key == 0) $("#hd_pop_uNumPay").val(value.PayLoanSeqNoB);

                        var src = '/GoodsImage' + '/' + value.GoodsFinalCategoryCode + '/' + value.GoodsGroupCode + '/' + value.GoodsCode + '/' + value.GoodsFinalCategoryCode + '-' + value.GoodsGroupCode + '-' + value.GoodsCode + '-sss.jpg';
                        asynTable += "<tr name='trColor'>"
                        asynTable += "<td rowspan='2' class='txt-center'>" + value.RowNumber + "</td>";  //번호
                        asynTable += "<td rowspan='2' class='txt-center'>" + value.OrderEnterDate.split("T")[0] + "</td>"; //입고일
                        asynTable += "<td rowspan='2' class='txt-center'>" + value.OrderCodeNo + "</td>"; //주문코드
                        asynTable += "<td rowspan='2' class='txt-center'><img src=" + src + " onerror='no_image(this, \"s\")' style='width:50px; height=50px'/></td>"; //이미지
                        asynTable += "<td rowspan='2' class='txt-center'>" + value.GoodsCode + "</td>"; //상품코드 
                        asynTable += "<td rowspan='2' style='text-align:left;  class='txt-center'>" + "[" + value.BrandName + "] " + value.GoodsFinalName + "<br /><span style='color:#368AFF; width:280px; word-wrap:break-word; display:block;'>" + value.GoodsOptionSummaryValues + "</span></td>"; //주문상품정보
                        asynTable += "<td rowspan='2' class='txt-center'>" + value.GoodsModel + "</td>"; //모델명 
                        asynTable += "<td class='txt-center'>" + numberWithCommas(value.GoodsSalePriceVat) + "원</td>"; //상품단가(vat 포함)
                        asynTable += "<td rowspan='2' class='txt-center'>" + value.Qty + "</td>"; //수량
                        asynTable += "<td rowspan='2' class='txt-center'>" + numberWithCommas(value.GoodsTotalSalePriceVat) + "원</td>"; //주문금액(vat 포함)
                        asynTable += "<td rowspan='2' class='txt-center'>" + value.OrderEndType_Name + "</td>"; //마감현황
                        asynTable += "<tr name='trColor'>"
                        asynTable += "<td class='txt-center'>" + value.GoodsUnit_Name + "</td></tr>";


                        //<td style='text-align:left; width:280px'>" + "[" + value.BrandName + "] " + value.GoodsFinalName + "<br /><span style='color:#368AFF; width:280px; word-wrap:break-word; display:block;'>" + value.GoodsOptionSummaryValues + "</span></td></tr></table ></td >


                        i++;

                    });
                } else {
                    asynTable += "<tr><td colspan='11' class='txt-center'>" + "조회된 정보가 없습니다." + "</td></tr>"
                    $("#hdTotalCount_2").val(0);
                }
                $("#tblOrderBillListSchPop tbody").append(asynTable);
                fnCreatePagination('pagination_2', $("#hdTotalCount_2").val(), pageNum, pageSize, getPageData2);


            }

            var sUser = '<%=Svid_User %>';
            var param = {
                sUser: sUser,
                unumPayNo: UnumPayNo,
                PageNo: pageNum,
                PageSize: pageSize,
                Flag: 'BUY',
                Method: 'OrderBillListSchPop'
            };

            // JajaxSessionCheck('Post', '../Handler/PayHandler.ashx', param, 'json', callback, sUser);

            var beforeSend = function () { };
            var complete = function () { };
            JqueryAjax('Post', '../Handler/PayHandler.ashx', true, false, param, 'json', callback, beforeSend, complete, true, '<%=Svid_User%>');

            //반환 값 없이 OK와 같은 신호를 보낼거면 json을 text로 바꿈, 마지막에 svid전에 true는 세션체크 유무

        }

    </script>

    <style type="text/css">
        .auto-style1 {
            height: 30px;
        }

        .table1 {
            float: left;
            width: 550px;
            height: 300px;
        }

        .table2 {
            display: inline-block;
            width: 550px;
            height: 300px;
        }

        .auto-style6 {
            height: 29px;
        }

        .auto-style7 {
            width: 1218px;
        }

        .auto-style8 {
            width: 70px;
            height: 30px;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div class="sub-contents-div">
        <!--제목 타이틀-->
        <div class="sub-title-div">
            <p class="p-title-mainsentence">
                정산내역조회
                <%--<span class="span-title-subsentence">고객님의 배송지를 확인할 수 있습니다.</span>--%>
            </p>
        </div>

        <!--탭메뉴-->
        
        <div class="div-main-tab" style="width: 100%; ">
            <ul>
                <li  class='tabOff' style="width: 185px;" onclick="location.href='OrderBillList.aspx'">
                    <a href="OrderBillList.aspx" >마감신청</a>
                </li>
                <li  class='tabOff' style="width: 185px;" onclick="location.href='OrderBillListSch.aspx'">
                    <a href="OrderBillListSch.aspx" >내역조회</a>
                 </li>
                <li  class='tabOn' style="width: 185px;" onclick="location.href='OrderBillPayment.aspx'">
                    <a href="OrderBillPayment.aspx" >대금결제</a>
                 </li>
            </ul>
        </div>

        <%--  <div class="mini-title">
            <img src="../" alt="주문상품" />
        </div>--%>


        <div class="list-div">
            <div>

                <h3 class="pop-title"><span style="text-align: left; font-size: 20px; color: red;">▣</span>대금결제</h3>
            </div>

            <table id="tblSearch" style="border: 1px solid #a2a2a2; float: left; width: 60%;">
                <thead>
                    <tr>
                        <th style="width: 35px;">선택</th>
                        <th style="height: 30px;">마감월</th>
                        <th style="height: 30px;">여신결제번호</th>
                        <th style="height: 30px;">주문건수</th>
                        <th style="height: 30px;">상품건수</th>
                        <th style="height: 30px;">총 결제금액</th>
                        <th style="height: 30px;">상세</th>

                    </tr>
                </thead>
                <tbody id="tbodyOrdEnd">
                    <tr>
                        <td colspan="7" class="txt-center">조회 결과 값이 없습니다.</td>
                    </tr>
                </tbody>

                <%-- <tr>

                    <td style="height: 60px;">
                        <input type="text" id="Deadline" name="Deadline" value="">
                    </td>
                    <td style="height: 60px;">
                        <input type="text" id="OrderCodeNo" name="OrderCodeNo" value="">
                    </td>
                    <td style="height: 60px;">
                        <input type="text" id="OrderCnt" name="OrderCnt" value="">
                    </td>
                    <td style="height: 60px;">
                        <input type="text" id="SumQty" name="SumQty" value="">
                    </td>
                    <td style="height: 60px;">
                        <input type="text" id="Amt" name="Amt" value="">
                    </td>
                    <td style="height: 60px;">

                        <img src="../Images/add-on.jpg" onmouseover="this.src='../Images/add-off.jpg'" onmouseout="this.src='../Images/add-on.jpg'" onclick="showDetailPopup(this);" />
                    </td>

                </tr>--%>
            </table>

            <table class="order5-table" style="border: 1px solid #a2a2a2; float: right; width: 460px;">
                <tr>
                    <th colspan="2" style="height: 30px; width: 140px">소셜위드 담당자</th>
                    <td colspan="2" style="height: 30px; width: 140px">
                        <input type="text" id="AdminName" name="AdminName" value="">
                    </td>

                </tr>
                <tr>
                    <th class="auto-style8">전화번호</th>
                    <td class="auto-style8">
                        <input type="text" id="AdminTel" name="AdminTel" value="">
                    </td>
                    <th class="auto-style8">휴대폰번호</th>
                    <td class="auto-style8">
                        <input type="text" id="AdminPhoneNo" name="AdminPhoneNo" value="">
                    </td>

                </tr>
                <tr>
                    <th style="height: 30px; width: 70px">팩스번호</th>
                    <td style="height: 30px; width: 70px">
                        <input type="text" id="AdminFaxNo" name="AdminFaxNo" value=""></td>
                    <th style="height: 30px; width: 70px">이메일</th>
                    <td style="height: 30px; width: 70px">
                        <input type="text" id="AdminEmail" name="AdminEmail" value=""></td>
                </tr>



            </table>
            <br />

            <br />


        </div>

        <!--상단 조회영역 끝-->
        <br />
        <br />
        <br />

        <br />
        <br />
        <br />
        <br />
        <br />


        <!--하단 리시트영역 시작-->
        <div class="auto-style7">


            <div class="mini-title">
                <h3 class="pop-title"><span style="text-align: left; font-size: 20px; color: red;">▣</span>결제진행</h3>
            </div>

            <div class="order5-div">

                <%--<input type="hidden" name="hdUnumCartNoArr" id="hdUnumCartNoArr" value="" />
                <input type="hidden" name="hdBasicDlvrCost" id="hdBasicDlvrCost" value="" />
                <input type="hidden" name="hdAddDlvrCost" id="hdAddDlvrCost" value="" />
                <input type="hidden" name="hdGdsSalePriceVat" id="hdGdsSalePriceVat" value="" />

                <input type="hidden" name="hd_pay_GoodsCnt" id="hd_pay_GoodsCnt" value="" />
                <input type="hidden" name="hd_pay_GoodsName" id="hd_pay_GoodsName" value="" />
                <input type="hidden" name="hd_pay_Amt" id="hd_pay_Amt" value="" />
                <input type="hidden" name="hd_pay_BuyerName" id="hd_pay_BuyerName" value="" />
                <input type="hidden" name="hd_pay_BuyerTel" id="hd_pay_BuyerTel" value="" />
                <input type="hidden" name="hd_pay_Company" id="hd_pay_Company" value="" />
                <input type="hidden" name="hd_pay_CompDept" id="hd_pay_CompDept" value="" />
                <input type="hidden" name="hd_pay_Email" id="hd_pay_Email" value="" />
                <input type="hidden" name="hd_pay_DlvrPostNo" id="hd_pay_DlvrPostNo" value="" />
                <input type="hidden" name="hd_pay_DlvrAddr" id="hd_pay_DlvrAddr" value="" />
                <input type="hidden" id="hdBPayType" />--%>

                <table class="order5-table">
                    <colgroup>
                        <col style="width: 183px" />
                        <col style="width: 426px" />
                        <col style="width: 203px" />
                        <col style="width: 306px" />
                    </colgroup>


                    <tr>
                        <th class="auto-style1">결제방식</th>


                        <td id="tdPayway" style="border: none; vertical-align: middle" class="auto-style1">&nbsp;&nbsp;
                        <%--<span id="spanBasic" style="margin-top: -13px;">
                            <input type="radio" value="1" name="pay" checked="checked" />신용카드 &nbsp;&nbsp;
                            <input type="radio" value="2" name="pay" />실시간계좌&nbsp;&nbsp;                       
                            <input type="radio" value="3" name="pay" />가상계좌&nbsp;&nbsp;
                            <input type="radio" value="5" name="pay" />ARS(신용카드결제)&nbsp;&nbsp;
                        </span>
                        <span id="spanLoan" style="display: none; width: 100px; margin-top: -13px;">
                            <input type="radio" value="4" name="pay" />&nbsp;후불계좌
                        </span>--%>
                       여신결제
                            <%--<input type="hidden" id="paywayCheck" name="paywayCheck" value="">--%>
                            <%-- <input type="hidden" name="hdUnumPayNo" value="">
                            <input type="hidden" name="hdOrderCodeNo" value="">
                            <input type="hidden" name="hdGoodsQty" value="">
                            <input type="hidden" name="hdAmt" value="">--%>
                            <input type="hidden" id="hdCompany_Code" name="hdCompany_Code" value="">
                            <%--<input type="hidden" name="hdYY" value="">
                            <input type="hidden" name="hdMM" value="">--%>
                            <input type="hidden" id="hdLoanCalDue" name="hdLoanCalDue" value="">
                            <input type="hidden" id="hdLoanPayDate" name="hdLoanPayDate" value="">
                            <%--<input type="hidden" name="hdOrderCnt" value="">
                            <input type="hidden" name="hdSumQty" value="">
                            <input type="hidden" name="hdGoodsSalePriceVat" value="">
                            <input type="hidden" name="hdDeliveryCost" value="">
                            <input type="hidden" name="hdPowerDeliveryCost" value="">--%>
                            <input type="hidden" id="hdAdminUserName" name="hdAdminUserName" value="">
                            <input type="hidden" id="hdAdminTelNo" name="hdAdminTelNo" value="">
                            <input type="hidden" id="hdAdminPhoneNo" name="hdAdminPhoneNo" value="">
                            <input type="hidden" id="hdAdminFaxNo" name="hdAdminFaxNo" value="">
                            <input type="hidden" id="hdAdminEmail" name="hdAdminEmail" value="">
                            <input type="hidden" id="hdAdminUserId" name="hdAdminUserId" value="">
                            <input type="hidden" id="hdBpayType" name="hdBpayType" value="">
                            <input type="hidden" id="hdPayWay" name="hdPayWay" value="">
                            <input type="hidden" id="hdAccountNumber" name="hdAccountNumber" value="">
                            <input type="hidden" id="hdBankNm" name="hdBankNm" value="">
                            <input type="hidden" id="hdAccountHolder" name="hdAccountHolder" value="">
                            <%--<input type="hidden" id="hdBulkBankNo" name="hdBulkBankNo" value="">--%>
                            <input type="hidden" id="hdCheckChk" name="hdCheckChk" value="0">
                        </td>
                        <th colspan="2" class="auto-style1">결제금액</th>
                    </tr>
                    <tr>
                        <td style="color: red; font-size: 20px;" colspan="2" rowspan="5"><span style="font-size: 12px; display: block; text-align: center"></span>
                            입금계좌 : <span id="AccountNumber" style="color: red; font-size: 20px; text-align: left;"></span>
                            <br />
                            <br />
                            <span style="text-align: left; font-size: 13px; color: black;">* 결제일 (매월</span> <span id="LoanPayDate" style="text-align: left;"></span>
                            <span style="text-align: left; font-size: 13px; color: black;">일)을 꼭 준수해주시기를 바랍니다.<br />
                                * 결제금액과 입금액이 동일한 액수인지 꼭 확인해주시기 바랍니다.</span>
                        </td>
                        <th style="height: 30px;">상품금액</th>
                        <td>
                            <%--<input type="text" id="GoodsSalePriceVat" name="GoodsSalePriceVat" value="">--%>
                            <span id="spGdsSalePriceVat"></span>원
                        </td>
                    </tr>

                    <tr>
                        <th class="auto-style6">할인금액</th>
                        <td class="auto-style6"></td>
                    </tr>

                    <tr>
                        <th style="height: 30px;">배송금액</th>
                        <td>
                            <%--<input type="text" id="DeliveryCost" name="DeliveryCost" value="">--%>
                            <span id="spDeliveryCost"></span>원
                            <%--<input type="hidden" id="hdDlvrPrice" value="" />
                            <input type="hidden" id="hdAddDlvrPrice" value="" />--%>
                        </td>
                    </tr>
                    <tr>
                        <th style="height: 30px;">총 결제 금액</th>
                        <td style="color: red">
                            <input type="hidden" id="totalAmt" name="totalAmt" value="">
                            <%--<input type="text" id="FinalPrice" name="FinalPrice" value="">원--%>
                            <span id="spFinalPrice"></span>원
                        </td>
                    </tr>

                    <tr>
                        <th class="auto-style1">사회적기업</th>
                        <td class="auto-style1"><span id="selectCompanyName"></span></td>
                    </tr>
                </table>
            </div>

            <br />
            <br />
            <div style="text-align: right">
                <%--<img src="../Images/Order/orderP-off.jpg" alt="결제하기" onclick="fnOrderPayment()" onmouseover="this.src='../Images/Order/orderP-on.jpg'" onmouseout="this.src='../Images/Order/orderP-off.jpg'" />--%>
                <input type="button" class="commonBtn" style="width: 95px; height: 30px; font-size: 12px" value="결제하기" onclick="return fnOrderPayment();" />
            </div>


        </div>
        <!--하단 리스트 영역 끝 -->

    </div>

    <%--상세보기 팝업 시작--%>
    <div id="DetailDiv" class="popupdiv">
        <div class="popupdivWrapper" style="width: 1200px; height: 200px; margin: 150px auto; background-color: #ffffff;">
            <div class="popupdivContents" style="background-color: #ffffff; height: 720px; padding: 15px;">

                <div class="close-div">
                    <a onclick="fnCancel()" style="cursor: pointer">
                        <img src="../../Images/Wish/icon-delete.jpg" alt="닫기" style="float: right;" /></a>
                </div>

                <div class="popup-title" style="margin-top: 20px;">
                    <h3 class="pop-title">주문상품</h3>
                    <br />

                    <!-- 주문 상품 테이블 -->
                    <div>
                        <table class="board-table" id="tblOrderBillListSchPop">
                            <thead>
                                <tr>
                                    <th rowspan="2">번호<input type="hidden" id="hd_pop_uNumPay" /></th>
                                    <th rowspan="2">입고일</th>
                                    <th rowspan="2">주문코드</th>
                                    <th rowspan="2">이미지</th>
                                    <th rowspan="2">상품코드</th>
                                    <th rowspan="2">주문상품정보</th>
                                    <th>모델명</th>
                                    <th rowspan="2">상품단가
                                        <br />
                                        (VAT포함)</th>
                                    <th rowspan="2">수량</th>
                                    <th rowspan="2">주문금액M<br />
                                        (VAT포함)</th>
                                    <th rowspan="2">마감현황</th>

                                </tr>
                                <tr>
                                    <th>내용량</th>

                                </tr>
                            </thead>
                            <tbody>
                                <tr>
                                    <td colspan="12" class="txt-center">주문내역이 없습니다.</td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                    <br />
                    <br />
                </div>

                <div style="margin: 0 auto; text-align: center">
                    <input type="hidden" id="hdTotalCount_2" />
                    <div id="pagination_2" class="page_curl" style="display: inline-block"></div>
                </div>

                <!-- 팝업버튼 -->
                <div style="margin-top: 20px; text-align: right">
                    <input type="button" class="commonBtn" style="width: 95px; height: 30px; font-size: 12px" value="닫기" onclick="return fnCancel();" />

                </div>
            </div>
        </div>
    </div>
    <input type="hidden" id="hdTotalCount" />


    <%--대금결제안내 팝업 시작--%>
    <div id="EndPop" class="popupdiv">
        <div class="popupdivWrapper" style="width: 600px; height: 150px; margin: 150px auto; background-color: #ffffff;">
            <div class="popupdivContents" style="background-color: #ffffff; height: 300px; padding: 15px;">

                <div class="close-div">
                    <a onclick="fnCancel()" style="cursor: pointer">
                        <img src="../../Images/Wish/icon-delete.jpg" alt="닫기" style="float: right;" /></a>
                </div>

                <h3 class="pop-title">대글결제안내</h3>
                <div class="popup-title" style="margin-top: 20px; text-align: center;">

                    <span style="text-align: center; font-size: 20px; color: black;">해당월 마감 승인 후 결제가 가능합니다.
                        <br />
                    </span>
                    <span style="text-align: center; font-size: 16px; color: black;">(자세한 사항은 담당자에게 문의전화 바랍니다)
                    </span>

                    <br />

                    <br />
                    <br />
                    <br />


                </div>
                <div style="text-align: right">
                    <a onclick="fnPopupclose(); return false;">
                        <img style="text-align: right" alt="닫기" src="../Images/Order/close-off.jpg" onclick="fnCancel(); return false;" onmouseover="this.src='../Images/Order/close-on.jpg'" onmouseout="this.src='../Images/Order/close-off.jpg'" /></a>
                </div>
            </div>
        </div>
    </div>


</asp:Content>

