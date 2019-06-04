<!--#include file="./class/NICELite.asp"-->

<% 
session.CodePage = 949
Response.CharSet = "euc-kr"
%>

<%
''''''''''''''''''''''''''''''''''''''''''''''''''''''''
' <결제 결과 설정>
' 사용전 결과 옵션을 사용자 환경에 맞도록 변경하세요.
' 로그 디렉토리는 꼭 변경하세요.
''''''''''''''''''''''''''''''''''''''''''''''''''''''''
Set NICEpay = new clssNICEpay
merchantKey = Request.Form("MerchantKey")  '상점키
merchantID = Request.Form("MID")
encodeParameters = "CardNo,CardExpire,CardPwd"              '암호화대상항목 (변경불가)
encryptData = Request.Form("EncryptData")

LogPath = Server.MapPath("/Logs/pay/")

NICEpay.setfield "logdir",LogPath                         'Log Path 설정
NICEpay.setfield "type","CARD_ARS"                               '서비스모드 설정(결제 서비스 : PY0 , 취소 서비스 : CL0)
NICEpay.setfield "EncodeKey",merchantKey                    '상점키 설정
NICEpay.setfield "NetCancelAmt",Request.Form("Amt")         '취소 금액 
NICEpay.setfield "NetCancelPwd","rhdrka219"					'결제수단
NICEpay.setfield "mid",merchantID					'상점ID


'복합과세 설정
NICEpay.setfield "SupplyAmt",Request.Form("SupplyAmt")
NICEpay.setfield "GoodsVat",Request.Form("GoodsVat")
NICEpay.setfield "ServiceAmt",Request.Form("ServiceAmt")
NICEpay.setfield "TaxFreeAmt",Request.Form("TaxFreeAmt")

NICEpay.startAction()

''''''''''''''''''''''''''''''''''''''''''''''''''''''''
' <결제 결과 필드>
' 아래 응답 데이터 외에도 전문 Header와 개별부 데이터 Get 가능
''''''''''''''''''''''''''''''''''''''''''''''''''''''''
resultCode    = NICEpay.getResult("ResultCode")             '결과 코드
resultMsg     = NICEpay.getResult("ResultMsg")	            '결과 메시지
resultErrCode = NICEpay.getResult("resulterrcode")          '결과 에러 코드
tid           = NICEpay.getResult("TID")                    '거래 ID
moid          = NICEpay.getResult("Moid")                   '주문번호
amt           = NICEpay.getResult("Amt")                    '가격
payMethod     = NICEpay.getResult("PayMethod")              '결제수단
authDate      = NICEpay.getResult("AuthDate")               '승인 날짜
authCode      = NICEpay.getResult("AuthCode")               '승인 번호
cardCode      = NICEpay.getResult("CardCode")               '카드사 코드
cardName      = NICEpay.getResult("CardName")               '카드사명
cardQuota     = NICEpay.getResult("CardQuota")              '00:일시불,02:2개월
bankCode      = NICEpay.getResult("BankCode")               '계좌이체 은행 코드
bankName      = NICEpay.getResult("BankName")               '계좌이체 은행명
rcptType      = NICEpay.getResult("RcptType")               '현금 영수증(0:발행되지않음,1:소득공제,2:지출증빙)
rcptAuthCode  = NICEpay.getResult("RcptAuthCode")           '현금영수증 승인 번호
rcptTID       = NICEpay.getResult("RcptTID")                '현금 영수증 TID   
carrier       = NICEpay.getResult("Carrier")                '이통사구분
dstAddr       = NICEpay.getResult("DstAddr")                '휴대폰번호
vBankCode     = NICEpay.getResult("VbankBankCode")          '가상계좌은행코드
vBankName     = NICEpay.getResult("VbankBankName")          '가상계좌은행명
vbankNum      = NICEpay.getResult("VbankNum")               '가상계좌번호
vbankExpDate  = NICEpay.getResult("VbankExpDate")           '가상계좌입금예정일
goodsName     = NICEpay.getResult("GoodsName")

sUser = Request.Form("hdSvidUser")
payMethodFlag = Request.Form("PayMethodFlag")
payMethodName = Request.Form("PayMethodName")
goodsCnt = Request.Form("GoodsCnt")
saleComName = Request.Form("SaleComName")
buyerName = Request.Form("BuyerName")
buyerTel = Request.Form("BuyerTel")
buyerEmail = Request.Form("BuyerEmail")
price = Request.Form("Amt")
goodsName = Request.Form("GoodsName")
moid = Request.Form("Moid")


ediDate = getNow()

Function getNow()
Dim aDate(2), aTime(2)
    aDate(0) = Year(Now)
    aDate(1) = Right("0" & Month(Now), 2)
    aDate(2) = Right("0" & Day(Now), 2)
    aTime(0) = Right("0" & Hour(Now), 2)
    aTime(1) = Right("0" & Minute(Now), 2)
    aTime(2) = Right("0" & Second(Now), 2)	
    getNow   = aDate(0)&aDate(1)&aDate(2)&aTime(0)&aTime(1)&aTime(2)	   
End Function

''''''''''''''''''''''''''''''''''''''''''''''''''''''''
' <결제 성공 여부 확인>
''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'paySuccess = False
'If payMethod = "CARD" Then
'	If resultCode = "3001" Then paySuccess  = True          '신용카드(정상 결과코드:3001)
'ElseIf  payMethod = "BANK" Then
'	If resultCode = "4000" Then paySuccess  = True 	        '계좌이체(정상 결과코드:4000)	
'ElseIf payMethod  = "CELLPHONE" Then
'	If resultCode = "A000" Then paySuccess  = True	        '휴대폰(정상 결과코드:A000)
'ElseIf  payMethod = "VBANK" Then
'	If resultCode = "4100" Then paySuccess  = True	        '가상계좌(정상 결과코드:4100)
'End If

''''''''''''''''''''''''''''''''''''''''''''''''''''''''
' <클래스 해제>
''''''''''''''''''''''''''''''''''''''''''''''''''''''''
Set NICEpay = Nothing
%>
<!DOCTYPE html>
<html>
<head>
<title>NICEPAY PAY RESULT(EUC-KR)</title>
<meta charset="euc-kr">
<meta name="viewport" content="width=device-width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=yes, target-densitydpi=medium-dpi" />
<link href="../Content/NicePay/import.css" rel="stylesheet" />
<script src="../Scripts/jquery-1.10.2.min.js"></script>
<script>
    $(document).ready(function () {
        document.arsPayForm.acceptCharset = 'utf-8';
        document.arsPayForm.action = "PayResult";
        document.arsPayForm.submit();
    });

//    function nicepay() {
//        document.arsPayForm.acceptCharset = 'utf-8';
//        document.arsPayForm.action = "PayResult";
//        document.arsPayForm.submit();
//    }
</script>
</head>
<body>
<form name="arsPayForm" method="post" action="PayResult">
<!--  <div class="payfin_area">
      <div class="top">NICEPAY PAY REQUEST(EUC-KR)::ARS 결제 신청</div>
      <div class="conwrap">
        <div class="con">
          <div class="tabletypea">
            <table>-->
              <!--<colgroup><col style="width:30%" /><col style="width:auto" /></colgroup>-->
                <!--<tr>
                    <td>
                        <input type="hidden" name="txtResultCode" value="<%=resultCode %>">
                    </td>
                    <td>
                    <input type="hidden" name="txtResultMsg" value="<%=resultMsg %>">
                    </td>
                </tr>-->
			  <!--<tr>
                <th><span>* 상점 아이디</span></th>
                <td><input type="hidden" name="MID" value="<%=merchantID%>"></td>
              </tr>
              <tr>
                <th><span>* 상품명</span></th>
                <td><input type="hidden" name="GoodsName" value="<%=goodsName%>"></td>
              </tr>
			  <tr>
                <th><span>* 상품주문번호</span></th>
                <td>
					<input type="hidden" name="Moid" value="<%=moid%>" style="width:210px">
					유니크한 상점 주문번호 (영문자+숫자 조합 가능)
				</td>
              </tr>
			  <tr>
                <th><span>* 결제 상품금액</span></th>
                <td>
					<input type="hidden" name="Amt" value="<%=price%>">
					상품 금액은 소스 상에서 변경 (위변조 체크)
				</td>
              </tr>	  			  
			  <tr>
                <th><span>* 구매자명</span></th>
                <td><input type="hidden" name="BuyerName" value="<%=buyerName%>"></td>
              </tr>
              <tr>
                <th><span>* 구매자 전화번호</span></th>
                <td>
					<input type="hidden" name="BuyerTel" value="<%=buyerTel%>">
					SMS 수신할 전화 번호 입니다. 숫자만 입력 예: 01012345678
				</td>
              </tr>
			  <tr>
                <th><span>구매자 이메일</span></th>
                <td><input type="hidden" name="BuyerEmail" value="<%=buyerEmail%>"></td>
              </tr>-->
			  <!--<tr>
                <th><span>무이자여부</span></th>
                <td>
					<select name="CardInterest">
						<option value="0" selected>일반</option>
						<option value="1">무이자</option>
					</select>
				</td>
              </tr>
			  <tr>
                <th><span>할부개월수</span></th>
                <td>
					<select name="CardQuota">
					<%
						FOR i=0 TO 36 STEP 1
							optionText = ""
							optionValue = ""
							IF i <> 1 THEN
								IF i = 0 THEN 
									optionText = "일시불"
								ELSE 
									optionText = i & "개월"
								END IF
							
								IF i < 10 THEN 
									optionValue = "0" & i
								ELSE 
									optionValue = i
								END IF
								
					%>
						<option value="<%=optionValue%>"><%=optionText%></option>
					<%
							END IF
							
						NEXT
					%>
					</select>
				</td>
              </tr>-->
			  <!--<tr>
                <th><span>* ARS 구분</span></th>
                <td>-->
                    <input type="hidden" name="MID" value="<%=merchantID%>">
                    <input type="hidden" name="GoodsName" value="<%=goodsName%>">
                    <input type="hidden" name="Moid" value="<%=moid%>" style="width:210px">
                    <input type="hidden" name="Amt" value="<%=price%>">
                    <input type="hidden" name="BuyerName" value="<%=buyerName%>">
                    <input type="hidden" name="BuyerTel" value="<%=buyerTel%>">
                    <input type="hidden" name="BuyerEmail" value="<%=buyerEmail%>">


                    <input type="hidden" name="CardInterest" value="0"/>
                    <input type="hidden" name="CardQuota" value="00"/>

                    <!-- 옵션 -->
                    <input type="hidden" name="VbankExpDate" value="<%=tomorrow%>"/>             <!-- 가상계좌입금만료일 -->
                    <input type="hidden" name="BuyerEmail" value="<%=buyerEmail%>"/>             <!-- 구매자 이메일 -->				  
                    <input type="hidden" name="GoodsCl" value="1"/>                              <!-- 상품구분(실물(1),컨텐츠(0)) -->  
                    <input type="hidden" name="TransType" value="0"/>                            <!-- 일반(0)/에스크로(1) --> 
              
                    <!-- 변경 불가능 -->
                    <input type="hidden" name="EncodeParameters" value="<%=encodeParameters%>"/> <!-- 암호화대상항목 -->
                    <input type="hidden" name="EdiDate" value="<%=ediDate%>"/>                   <!-- 전문 생성일시 -->
                    <input type="hidden" name="EncryptData" value="<%=encryptData%>"/>            <!-- 해쉬값 -->
                    <input type="hidden" name="TrKey" value=""/>                                 <!-- 필드만 필요 -->
                    <input type="hidden" name="MerchantKey" value="<%=merchantKey%>"/>           <!-- 상점 키 -->

                    <input type="hidden" name="AuthDate" value="<%=authDate %>">
                    <input type="hidden" name="AuthCode" value="<%=authCode %>">
                    
                    <input type="hidden" name="SaleComName" value="<%=saleComName %>">

                    <input type="hidden" name="hdSvidUser" value="<%=sUser%>"/>
                    <input type="hidden" name="PayMethod" value="CARD_ARS">
                    <input type="hidden" name="PayMethodFlag" value="<%=payMethodFlag %>">
                    <input type="hidden" name="PayMethodName" value="<%=payMethodName %>">
                    <input type="hidden" name="GoodsCnt" value="<%=goodsCnt %>">
                    
                    <input type="hidden" name="hdResultCode" value="<%=resultCode %>">
                    <input type="hidden" name="hdResultMsg" value="<%=resultMsg %>">

					<input type="hidden" name="ArsReqType" value="SMS">
				<!--</td>
              </tr>
			  
            </table>
          </div>
        </div>-->
        <!--<div class="btngroup">
          <a href="#" class="btn_blue" onClick="nicepay();">요 청</a>
        </div>-->
      <!--</div>
    </div>-->
</form>
</body>
</html>
