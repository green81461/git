<%@ Page Language="C#" AutoEventWireup="true" CodeFile="OrderRequest_Bill.aspx.cs" Inherits="Order_OrderRequest_Bill" %>

<!DOCTYPE html>
<html style="overflow-y: hidden">
<head>

    <title>NICEPAY PAY REQUEST</title>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=yes, target-densitydpi=medium-dpi" />

    <%--<link rel="stylesheet" type="text/css" href="./css/import.css" />--%>
    <link href="../Content/Order/order.css" rel="stylesheet" />
    <link rel="stylesheet" type="text/css" href="../Content/jquery-ui-1.10.4.custom.min.css" />

    <script src="https://web.nicepay.co.kr/flex/js/nicepay_tr_utf.js" language="javascript"></script>
    <script type="text/javascript" src="../Scripts/jquery-1.10.2.min.js"></script>
    <script type="text/javascript" src="../Scripts/jquery-ui.min.js"></script>
    <script src="../Scripts/common.js"></script>

    <script type="text/javascript">


        function resize_window() {
            window.resizeTo(850, 580);
        }


        //결제유형에 따라 핸드폰 번호 초기화 및 입금예정일 선택.  
        $(document).ready(function () {

            var buyPrice = $("input[name='Amt1']").val();
            var resetTel = $("input[name='PayWay']").val();

            $("input[name='BuyerTel']").val();
            //가상계좌일 경우    
            if (resetTel == '3') {
                $("input[name='BuyerTel']").val('');             //연락처 정보 고객이 직접 입력  
                $("#noDue").css("display", "");                  //입금예정일 자동  
                $("#onDue").css("display", "none");              //입급예정일 수동체크  


            }

            //후불결제 & 여신결제일 경우  
            else if (resetTel == '4' || resetTel == '6' || resetTel == '7' || resetTel == '8') {
                $("#noDue").css("display", "none");                  //입금예정일 자동  
                $("#onDue").css("display", "");                     //입급예정일 수동체크  
                $("input[name='BuyerTel']").val('');                //연락처 정보 고객이 직접 입력  
                //  $("#trDueDate").css("display", "");                 //입금예정일 선택 tr 보이기.    


                //달력 세팅  
                $("#billDate").datepicker({
                    minDate: 0,                  //최소 선택 가능 일자 오늘 부터.  
                    maxDate: "30D",              //최대 선택 가능 일자 오늘부터 +30일  
                    showAnimation: 'slideDown',
                    changeMonth: true,
                    changeYear: true,
                    dateFormat: "yy-mm-dd",
                    monthNamesShort: ["1월", "2월", "3월", "4월", "5월", "6월", "7월", "8월", "9월", "10월", "11월", "12월"],
                    dayNamesMin: ["일", "월", "화", "수", "목", "금", "토"],
                    showMonthAfterYear: true
                });
            }
            else if (resetTel == '1' || resetTel == '2' || resetTel == '5') {
                $("#noDue").css("display", "");                  //입금예정일 자동  
                $("#onDue").css("display", "none");              //입급예정일 수동체크  
            }


            $("#Amt1").val(numberWithCommas(buyPrice));
        });



        //결제창 최초 요청시 실행됩니다.
        function nicepayStart() {
            //alert(document.payForm.action);
            //goPay(document.payForm);
            document.payForm.submit();
        }

        //function Ars_nicepayStart() {
        //    goPay(document.Ars_payForm);
        //}

        function fnPayClose() {
            alert('결제가 취소 되었습니다.')
            self.close();
        }


        //입금예정일 선택 유무 확인
        function fnCheckDueDate() {

            fnPayInsert();


        }

        var is_sending = false;

        function fnPayInsert() {

            var BuyerTel = $("input[name='BuyerTel']").val();
            var PayWay = $("input[name='PayWay']").val();

            if (BuyerTel == '') {
                alert('휴대폰 번호를 입력해주세요.')
                return false;
            }

            else {
                BuyerTel = BuyerTel.replace(/\-/g, '');
                $('#BuyerTel').val(BuyerTel);

                if (PayWay == '5') {
                    //Ars_nicepayStart();

                    document.payForm.action = "Ars_OrderRequest.asp";
                    document.payForm.submit();
                }
                else if (PayWay == '6') {

                    document.payForm.action = "loan_OrderRequest.asp";
                    document.payForm.submit();
                }
                else {

                    document.payForm.action = "OrderResult";
                    goPay(document.payForm);

                }
                $('div#nice_layer').css('left', '50%');
                $('div#nice_layer').css('transform', 'translateX(-50%)');
                $('div#bg_layer').css('height', '100%');
                //nicepayStart();

            }
        }


        //결제 최종 요청시 실행됩니다. <<'nicepaySubmit()' 이름 수정 불가능>>
        function nicepaySubmit() {
            document.payForm.submit();
        }

        //결제창 종료 함수 <<'nicepayClose()' 이름 수정 불가능>>
        function nicepayClose() {
            alert("결제가 취소 되었습니다");
            self.close();
        }
    </script>

    <style type="text/css">
        * {
            margin: 0;
            padding: 0
        }

        .auto-style1 {
            height: 30px;
        }

        .auto-style2 {
            background-color: #ececec;
            text-align: center;
            height: 30px;
        }

        .auto-style3 {
            background-color: #ececec;
            text-align: center;
            height: 26px;
        }

        .auto-style4 {
            height: 24px;
        }

        .auto-style5 {
            background-color: #ececec;
            text-align: center;
            height: 24px;
        }

        .auto-style6 {
            height: 24px;
            width: 95%;
            margin-top: 0;
        }
    </style>


</head>
<body onload="javascript_:resize_window();">
    <form name="payForm" method="post" action="OrderResult" style="height: 100%">
        <div class="payffin_area">

            <div class="conwrap">
                <div class="orderR-title-div">
                    <img src="../Images/Order/orderR-title.jpg" alt="최종결제내역 확인" />
                </div>
                <div class="con">
                    <div class="tabletypea">
                        <table class="orderRqs-table">
                            <tr>
                                <td class="auto-style2">결제수단</td>
                                <td style="padding-left: 5px;" class="auto-style1">
                                    <input name="PayMethod" type="hidden" id="PayMethod" value="<%=PayMethod%>" />

                                    <input name="payWayResult" type="text" readonly id="payWayResult" value="<%=payWayResult%>" />
                                    <input type="hidden" name="Moid" value="<%=moid%>">
                                    <input type="hidden" name="Unum_PayNo" value="<%=Unum_PayNo%>">
                                    <input type="hidden" name="GoodsCnt" value="<%=goodsCnt%>">

                                    <input type="hidden" name="Svid_User" value="<%=Svid_User%>">

                                    <input type="hidden" name="BulkBankNo" value="<%=BulkBankNo%>">


                                    <%-- <input type="hidden" name="FLAG" value="<%=FLAG%>" />--%>



                                    <!-- 옵션 -->


                                    <input type="hidden" name="BuyerEmail" value="<%=buyerEmail%>" />
                                    <!-- 구매자 이메일 -->
                                    <input type="hidden" name="GoodsCl" value="1" />
                                    <!-- 상품구분(실물(1),컨텐츠(0)) -->
                                    <input type="hidden" name="TransType" value="<%=transType%>" />

                                    <input type="hidden" name="ArsReqType" value="SMS" />
                                    <!-- 일반(0)/에스크로(1) -->

                                    <!-- 변경 불가능 -->
                                    <input type="hidden" name="EncodeParameters" value="<%=encodeParameters%>" />

                                    <input type="hidden" name="PayWay" id="PayWay" value="<%=PayWay%>" />
                                    <!-- 암호화대상항목 -->
                                    <input type="hidden" name="EdiDate" value="<%=ediDate%>" />
                                    <!-- 전문 생성일시 -->
                                    <input type="hidden" name="EncryptData" value="<%=hash_String%>" />

                                    <input type="hidden" name="subjectDate" value="<%=subjectDate%>" />

                                    <input type="hidden" name="SaleComName" value="<%=SaleComName%>" />


                                    <input type="hidden" name="Company_Code" value="<%=Company_Code%>" />

                                    <!-- 해쉬값 -->
                                    <input type="hidden" name="TrKey" value="" />

                                    <!-- 필드만 필요 -->
                                    <input type="hidden" name="MerchantKey" value="<%=merchantKey%>" />

                                    <input type="hidden" name="MID" value="<%=merchantID%>">
                                    <!-- 상점 키 -->
                                    <input type="hidden" name="SocketYN" value="Y">
                                    <!-- 소켓통신 -->
                                    <input type="hidden" name="ROLE_FLAG" value="<%=RoleFlag%>">

                                    <input type="hidden" name="Amt" value="<%=price%>">

                                    <input type="hidden" name="UrianType" value="<%=Type%>">

                                    <input type="hidden" name="urianTypeUnumNo" value="<%=TypeUnumNo%>">
                                </td>
                            </tr>

                            <tr>
                                <td class="tbl-td">구매기관명</td>
                                <td style="padding-left: 5px;">
                                    <input name="tdCompanyName" type="text" id="tdCompanyName" readonly value="<%=CompanyName%>" style="height: 24px; width: 95%; line-height: 25px;" /></td>
                            </tr>

                            <tr>
                                <td class="tbl-td">부서명</td>
                                <td style="padding-left: 5px;">
                                    <input name="부서명" type="text" value="<%=CompanyDeptName%>" readonly style="height: 24px; width: 95%; line-height: 25px;" /></td>

                            </tr>


                            <tr>
                                <td class="auto-style3" style="background-color: #ececec; text-align: center">주문자</td>
                                <td style="padding-left: 5px;">
                                    <input name="BuyerName" type="text" value="<%=buyerName%>" readonly id="BuyerName" style="height: 24px; width: 95%; line-height: 25px;" /></td>
                            </tr>

                            <tr>
                                <td class="auto-style3" style="background-color: #ececec; text-align: center;">
                                    <br />
                                    연락처
                                    <br>
                                    (문자받으실 핸드폰번호)<br />
                                </td>
                                <td style="padding-left: 5px;">
                                    <input name="BuyerTel" id="BuyerTel" value="<%=buyerTel%>" placeholder="-없이 입력해주세요" style="line-height: 25px;" class="auto-style6" /></td>
                            </tr>

                            <tr>
                                <td class="auto-style1" style="background-color: #ececec; text-align: center;">이메일</td>
                                <td class="auto-style1" style="padding-left: 5px;">
                                    <input name="이메일" type="text" value="<%=buyerEmail%>" readonly style="height: 24px; width: 95%; line-height: 25px;" /></td>

                            </tr>

                            <%--       <tr>
                                <td class="tbl-td">배송지 정보</td>
                                <td colspan="5" style="padding-left: 5px;">
                                    <input name="DeliveryInfo" type="text" class="addr" value="<%=Address_1%>" readonly style="height: 24px; width: 95%; line-height: 25px;" /></td>
                            </tr>--%>
                            <tr>
                                <td class="auto-style2">결제상품명</td>
                                <td style="padding-left: 5px;" class="auto-style1">
                                    <input name="GoodsName" class="goodN" type="text" readonly id="GoodsName" value="<%=goodsName%>" style="height: 24px; width: 95%; line-height: 25px;" /></td>
                            </tr>
                            <tr>
                                <td class="auto-style5">총결제금액</td>
                                <td style="padding-left: 5px;" class="auto-style4">
                                    <input name="Amt1" type="text" id="Amt1" readonly value="<%=price%> 원" style="height: 24px; width: 95%; line-height: 25px;" />

                                    <input type="hidden" id="VbankExpDate" name="VbankExpDate" value="<%=VbankExpDate%>" />

                                    <input type="hidden" id="VbankDate" name="VbankDate" value="<%=VbankExpDate%>" />
                                </td>
                            </tr>


                            <%-- <tr id="trDueDate" style="display: none">
                                <th class="auto-style1"><span>입금예정일</span></th>
                                <td>
                                    <input type="text" id="billDate" name="billDate" placeholder="클릭하세요" size="30" />

                                </td>
                            </tr>--%>
                        </table>


                        <%--  <asp:Button ID="btnPayment" runat="server" Text="결제!" OnClick="btnPayment_Click" UseSubmitBehavior="false" Style="height: 21px" />--%>
                    </div>
                </div>
                <div class="orderRqs-bt-align">
                    <a>
                        <img src="../Images/Order/cancleR-off.jpg" alt="취소하기" onclick="fnPayClose();" onmouseover="this.src='../Images/Order/cancleR-on.jpg'" onmouseout="this.src='../Images/Order/cancleR-off.jpg'" />
                    </a>
                    <%--입금예정일 자동--%>
                    <a class="btn_blue" id="noDue" onclick="fnPayInsert();">
                        <img src="../Images/Order/orderP-off.jpg" alt="결제하기" onmouseover="this.src='../Images/Order/orderP-on.jpg'" onmouseout="this.src='../Images/Order/orderP-off.jpg'" />
                    </a>
                    <%--입금예정일 선택--%>
                    <a class="btn_blue" id="onDue" onclick="fnCheckDueDate();">
                        <img src="../Images/Order/orderP-off.jpg" alt="결제하기" onmouseover="this.src='../Images/Order/orderP-on.jpg'" onmouseout="this.src='../Images/Order/orderP-off.jpg'" />

                    </a>
                    <%--   <a href="#" class="btn_blue" onclick="nicepayStart();">요 청</a>--%>
                </div>
            </div>
        </div>
    </form>
</body>
</html>
