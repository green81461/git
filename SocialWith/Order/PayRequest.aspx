<%@ Page Language="C#" AutoEventWireup="true" CodeFile="PayRequest.aspx.cs" Inherits="Order_PayRequest" %>

<!DOCTYPE html>

<html>
<head runat="server">
<title>NICEPAY 결제 요청</title>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=yes, target-densitydpi=medium-dpi" />
<link href="../Content/NicePay/import.css" rel="stylesheet" />
<link href="../Content/jquery-ui.css" rel="stylesheet" />
<script src="https://web.nicepay.co.kr/flex/js/nicepay_tr_utf.js"></script>
<script src="../Scripts/jquery-1.10.2.min.js"></script>
<script src="../Scripts/jquery-ui.min.js"></script>
<script src="../Scripts/common.js"></script>

<script type="text/javascript">
    function resizeWindow() {
        var payway = '<%=payMethodFlag %>';
        var popupY = 750;
        if ((payway == "3") || (payway == "6") || (payway == "9")) {
            popupY = 630;
            if (payway != "3") {
                popupY = 800;
            }
        } else {
            popupY = 650;
        }

        window.resizeTo(830, popupY);
    }

    var is_sending = false;
    $(document).ready(function () {
        resizeWindow();

        var errCode = '<%=ErrorCode %>';
        if (!isEmpty(errCode)) {
            alert("잘못된 접근입니다. 창을 종료합니다.");
            self.close();
        }

        $("#vBankDueDate").datepicker({
            minDate: 0,     //최소 선택 가능 일자 오늘부터
            maxDate: "30D", //최대 선택 가능 일자 오늘부터 +30일
            showAnimation: 'slideDown',
            changeMonth: true,
            changeYear: true,
            dateFormat: "yy-mm-dd",
            monthNamesShort: ["1월", "2월", "3월", "4월", "5월", "6월", "7월", "8월", "9월", "10월", "11월", "12월"],
            dayNamesMin: ["일", "월", "화", "수", "목", "금", "토"],
            showMonthAfterYear: true
        });

        var payway = '<%=payMethodFlag %>';

        if ((payway == "3") || (payway == "6") || (payway == "9")) {
            $(".vBankNone").removeClass("vBankNone");

            if (payway != "3") {
                $(".trBulkNone").removeClass("trBulkNone");
            }

        } else {
            $("#trDueDate").css("display", "none");
            $(".trBulkNone").attr("class", "trBulkNone");
        }
    });

    //결제창 최초 요청시 실행됩니다.
    function nicepayStart() {
        goPay(document.payForm);
    }

    //결제 최종 요청시 실행됩니다. <<'nicepaySubmit()' 이름 수정 불가능>>
    function nicepaySubmit() {
        document.payForm.submit();
    }

    //결제창 종료 함수 <<'nicepayClose()' 이름 수정 불가능>>
    function nicepayClose() {
        alert("결제가 취소 되었습니다.");
        self.close();
    }

    //요청버튼 클릭 시
    function fnPayInsert() {
        var payway = '<%=payMethodFlag %>';
        var buyerTel = $("input[name='BuyerTel']").val();
        var vBankDueDate = ''; //입금예정일

        if (isEmpty(buyerTel)) {
            alert("문자 받으실 휴대폰번호를 입력해 주세요.\n('-'없이 입력해 주세요.)");
            return false;
        }

        //가상계좌인 경우
        if ((payway == "3") || (payway == "6") || (payway == "9")) {
            vBankDueDate = $("input[name='vBankDueDate']").val(); //입금예정일

            if (isEmpty(vBankDueDate)) {
                alert("입금예정일을 선택해 주세요.");
                return false;
            }
        }

        var callback = function (response) {
            if (!isEmpty(response) && (response.Result == "OK")) {
                if ((payway == "1") || (payway == "2") || (payway == "3")) {

                    document.payForm.action = "PayResult";
                    goPay(document.payForm); //NICEPAY 모듈 실행

                } else if (payway == "5") {
                    document.payForm.action = "ArsPayResult.asp";
                    document.charset = 'euc-kr';
                    document.payForm.submit();

                } else {
                    document.payForm.action = "PayResult";
                    document.payForm.submit();
                }
            }
        };

        var ordCodeNo = $("input[name='Moid']").val();
        var pgMid = $("input[name='MID']").val();
        var pgMidKey = $("input[name='MerchantKey']").val();
        var pgHash = $("input[name='EncryptData']").val();
        var buyerName = $("input[name='BuyerName']").val();
        var buyerEmail = $("input[name='BuyerEmail']").val();
        var goodsName = $("input[name='GoodsName']").val();
        var goodsCnt = $("input[name='GoodsCnt']").val();
        var Amt = $("input[name='Amt']").val();
        var subjectDate = $("input[name='EdiDate']").val();
        var vBankExpDate = $("input[name='VbankExpDate']").val(); //입금기간만료일
        
        var param = {
            OrderCodeNo: ordCodeNo,
            Pg_Mid: pgMid,
            Pg_Midkey: pgMidKey,
            Pg_Hash: pgHash,
            BuyerName: buyerName,
            BuyerTel: buyerTel,
            BuyerMail: buyerEmail,
            GoodsName: goodsName,
            Goodsqty: goodsCnt,
            Amt: Amt,
            PayWay: payway,
            SubjectDate: subjectDate,
            VbankExpDate: vBankExpDate,
            VbankDueDate: vBankDueDate,
            Method: "PayInsert"
        };

        var beforeSend = function () {
            is_sending = true;
        }
        var complete = function () {
            is_sending = false;
        }
        if (is_sending) return false;

        JqueryAjax('Post', '../Handler/PayHandler.ashx', true, false, param, 'json', callback, beforeSend, complete, true, '<%=Svid_User%>');
    }
</script>
</head>
<body>
<form name="payForm" method="post" action="PayResult.aspx">
    <div class="payfin_area">
        <div class="top">최종 결제내역 확인</div>
        <div class="conwrap">
            <div class="con">
                <div class="tabletypea">
                    <table>
                        <colgroup>
                            <col style="width:40%" />
                            <col style="width:auto" />
                            <col style="width:15%" />
                            <col style="width:15%" />
                        </colgroup>
                        <tr>
                            <th>상품명</th>
                            <th>상품금액(VAT포함)</th>
                            <th>총 수량</th>
                            <th>결제수단</th>
                        </tr>
                        <tr>
                            <td style="padding-top:10px;">
                                <asp:Literal runat="server" ID="ltrGoodsName"></asp:Literal>
                                <input type="hidden" name="GoodsName" value="<%=goodsName %>">
                            </td>
                            <td style="padding-top:10px;">
                                <asp:Literal runat="server" ID="ltrAmt"></asp:Literal>
                                <input type="hidden" name="Amt" value="<%=price %>">
                            </td>
                            <td style="padding-top:10px;">
                                <asp:Literal runat="server" ID="ltrTotGoodsQty"></asp:Literal>
                                <input type="hidden" name="TotGoodsQty" value="<%=totGoodsQty %>">
                            </td>
                            <td style="padding-top:10px;">
                                <asp:Literal runat="server" ID="ltrPayMethod"></asp:Literal>
                                <input type="hidden" name="PayMethod" value="<%=payMethod %>">
                                <input type="hidden" name="PayMethodFlag" value="<%=payMethodFlag %>">
                                <input type="hidden" name="PayMethodName" value="<%=payMethodName %>">

                                <input type="hidden" name="Moid" value="<%=moid %>">
                                <input type="hidden" name="MID" value="<%=merchantID %>">

                                <%-- 옵션 --%>
                                <input type="hidden" name="VbankExpDate" value="<%=vBankExpDate %>"/>   <%-- 가상계좌입금만료일 --%>
                                <input type="hidden" name="BuyerEmail" value="<%=buyerEmail %>"/>       <%-- 구매자 이메일 --%>
                                <input type="hidden" name="GoodsCl" value="1"/>                         <%-- 상품구분(실물(1),컨텐츠(0)) --%>
                                <input type="hidden" name="TransType" value="<%=transType %>"/>         <%-- 일반(0)/에스크로(1) --%>

                                <%-- 변경 불가능 --%>
                                <input type="hidden" name="EncodeParameters" value="<%=encodeParameters %>"/>   <%-- 암호화대상항목 --%>
                                <input type="hidden" name="EdiDate" value="<%=ediDate %>"/>                     <%-- 전문 생성일시 --%>
                                <input type="hidden" name="EncryptData" value="<%=hash_String %>"/>             <%-- 해쉬값 --%>
                                <input type="hidden" name="TrKey" value=""/>                                    <%-- 필드만 필요 --%>
                                <input type="hidden" name="MerchantKey" value="<%=merchantKey %>"/>             <%-- 상점 키 --%>
                                <input type="hidden" name="SocketYN" value="Y">                                 <%-- 소켓통신 --%>
                                <input type="hidden" name="ArsReqType" value="SMS">

                                <%--복합과세--%>
                                <input type="hidden" name="SupplyAmt" value="<%=supplyAmt %>">
                                <input type="hidden" name="GoodsVat" value="<%=goodsVat %>">
                                <input type="hidden" name="ServiceAmt" value="<%=serviceAmt %>">
                                <input type="hidden" name="TaxFreeAmt" value="<%=taxFreeAmt %>">

                                <input type="hidden" name="GoodsCnt" value="<%=goodsCnt %>">
                                <input type="hidden" name="SaleComName" value="<%=saleComName %>">
                                <input type="hidden" name="hdSvidUser" value="<%=Svid_User %>">
                                <input type="hidden" name="CompanyName" value="<%=companyName %>">
                                
                            </td>
                        </tr>
                    </table>
                </div>


                <br />
                <div class="top">주문 정보 및 요청</div>

                <div class="tabletypea">
                    <table>
                        <colgroup>
                            <col style="width:15%" />
                            <col style="width:30%" />
                            <col style="width:auto" />
                            <col style="width:30%" />
                        </colgroup>
                        
                        <tr>
                            <th><span>판매업체명</span></th>
                            <td colspan="3"><asp:Literal runat="server" ID="ltrSaleComName"></asp:Literal></td>
                        </tr>
                        <tr>
                            <th><span>구매기관명</span></th>
                            <td><asp:Literal runat="server" ID="ltrComName"></asp:Literal></td>
                            <th><span>부서명</span></th>
                            <td><asp:Literal runat="server" ID="ltrComDeptName"></asp:Literal></td>
                        </tr>
                        <tr>
                            <th><span>주문자</span></th>
                            <td>
                                <asp:Literal runat="server" ID="ltrBuyerName"></asp:Literal>
                                <input type="hidden" name="BuyerName" value="<%=buyerName %>">
                            </td>
                            <th><span>연락처(문자 받을 휴대폰번호)</span></th>
                            <td><input type="text" name="BuyerTel" style="height: 26px; padding-left:2px;" placeholder="- 없이 입력해 주세요." value=""></td>
                        </tr>
                        <tr>
                            <th><span>배송지주소</span></th>
                            <td>
                                <asp:Literal runat="server" ID="ltrAddr"></asp:Literal>
                            </td>
                            <th><span>이메일</span></th>
                            <td>
                                <asp:Literal runat="server" ID="ltrBuyerEmail"></asp:Literal>
                            </td>
                        </tr>
                    </table>
                </div>

                <br />
                <div class="top vBankNone">입금 가상계좌 정보</div>

                <div class="tabletypea">
                    <table>
                        <colgroup>
                            <col style="width:20%" />
                            <col style="width:auto" />
                        </colgroup>

                        <tr class="trBulkNone">
                            <th><span>입금은행명</span></th>
                            <td>
                                <asp:Literal runat="server" ID="ltrVbankBankName"></asp:Literal>
                                <input type="hidden" name="VbankBankCode" value="<%=vBankBankCode %>"/> <%-- 입금은행코드 --%>
                                <input type="hidden" name="VbankBankName" value="<%=vBankBankName %>"/> <%-- 입금은행명 --%>
                            </td>
                        </tr>
                        <tr id="trBulkVbankNum" class="trBulkNone">
                            <th><span>가상계좌 번호</span></th>
                            <td>
                                <asp:Literal runat="server" ID="ltrVbankNum"></asp:Literal>
                                <input type="hidden" name="VbankNum" value="<%=vBankNum %>"/>
                                <input type="hidden" name="VbankExpTime" value="<%=vBankExpTime %>"/>    <%-- 입금마감시간 --%>
                            </td>
                        </tr>
                        <tr class="trBulkNone" id="trVbankAccountName">
                            <th><span>입금예금주명</span></th>
                            <td>
                                <asp:Literal runat="server" ID="ltrVBankAccountName"></asp:Literal>
                                <input type="hidden" name="VBankAccountName" value="<%=vBankAccountName %>"/>
                            </td>
                        </tr>
                        <tr id="trDueDate" class="vBankNone">
                            <th><span>입금예정일</span></th>
                            <td>
                                <input type="text" id="vBankDueDate" name="vBankDueDate" style="height: 26px; width:90px; padding-left:2px;" placeholder="클릭하세요" size="30" />
                            </td>
                        </tr>
                    </table>
                </div>
            </div>
            <div class="btngroup">
                <a href="#" class="btn_blue" onClick="nicepayClose();">취소하기</a>
                <a href="#" class="btn_blue" onClick="fnPayInsert()">결제하기</a>
            </div>
        </div>
    </div>
</form>
</body>
</html>
