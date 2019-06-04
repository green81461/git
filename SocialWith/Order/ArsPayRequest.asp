<%@Language="VBScript" CODEPAGE="949"%>
<!--#include file="./class/SHA256.asp"-->
<%
''''''''''''''''''''''''''''''''''''''''''''''''''''''''
' <결제요청 파라미터>
' 결제시 Form 에 보내는 결제요청 파라미터입니다.
' 샘플페이지에서는 기본(필수) 파라미터만 예시되어 있으며, 
' 추가 가능한 옵션 파라미터는 연동메뉴얼을 참고하세요.
''''''''''''''''''''''''''''''''''''''''''''''''''''''''
merchantKey      = "s85N0j9+7EQc/Ew1MRfKaLpAW2e6ydFMA2MmB5L2MqVvKUrsChzwbBcGPEwkHetGTwGEHXtT7pjlPceOWoWP4g=="  '상점키
merchantID       = "nisocial2m"                             '상점아이디
goodsCnt         = "1"                                      '결제상품개수
goodsName        = "소셜공감테스트 상품"                             '결제상품명
price            = "1004"                                   '결제상품금액
buyerName        = "나이스"                                 '구매자명
buyerTel         = "01087046370"                            '구매자연락처
buyerEmail       = "rjh@socialwith.co.kr"                        '구매자메일주소
moid             = getMoid()                        		'상품주문번호 (유니크한 상점 주문번호)
encodeParameters = "CardNo,CardExpire,CardPwd"              '암호화대상항목 (변경불가)


'SupplyAmt = request.Form("SupplyAmt") '공급가액
'GoodsVat = request.Form("GoodsVat")   '부가세
'ServiceAmt = request.Form("ServiceAmt")'봉사료
'TaxFreeAmt = request.Form("TaxFreeAmt")'면세금액


''''''''''''''''''''''''''''''''''''''''''''''''''''''''
' <가상계좌 입금 만료일>
''''''''''''''''''''''''''''''''''''''''''''''''''''''''
tomorrow = (date()+1)
tomorrow = Replace(tomorrow, "-", "")

''''''''''''''''''''''''''''''''''''''''''''''''''''''''
' <해쉬암호화> (수정하지 마세요)
' SHA256 해쉬암호화는 거래 위변조를 막기위한 방법입니다. 
''''''''''''''''''''''''''''''''''''''''''''''''''''''''
call initCodecs

ediDate = getNow()
hashString = SHA256_Encrypt(ediDate & merchantID & price & merchantKey)

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

' 유니크한 주문번호(Moid)를 생성하기 위한 함수
' 상점에서는 따로 규칙을 만들어 쓰도 무관 합니다.
Function getMoid()
	getMoid = merchantID & "_" & getNow() & right("000" & (timer * 1000) Mod 1000, 3)
End Function
%>
<!DOCTYPE html>
<html>
<head>
<title>NICEPAY PAY REQUEST(EUC-KR)</title>
<meta charset="euc-kr">
<meta name="viewport" content="width=device-width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=yes, target-densitydpi=medium-dpi" />
<link rel="stylesheet" type="text/css" href="./css/import.css"/>
<script src="https://web.nicepay.co.kr/flex/js/nicepay_tr_utf.js" type="text/javascript"></script>
<script type="text/javascript">
/**
nicepay	를 통해 결제를 시작합니다.
@param	form :	결제 Form 
*/
function nicepay() {
	var payForm		= document.payForm;
	payForm.submit();
}
</script>
</head>
<body>
<form name="payForm" method="post" action="arsPayResult.asp">
    <div class="payfin_area">
      <div class="top">NICEPAY PAY REQUEST(EUC-KR)::ARS 결제 신청</div>
      <div class="conwrap">
        <div class="con">
          <div class="tabletypea">
            <table>
              <colgroup><col style="width:30%" /><col style="width:auto" /></colgroup>
			  <tr>
                <th><span>* 상점 아이디</span></th>
                <td><input type="text" name="MID" value="<%=merchantID%>"></td>
              </tr>
              <tr>
                <th><span>* 상품명</span></th>
                <td><input type="text" name="GoodsName" value="<%=goodsName%>"></td>
              </tr>
			  <tr>
                <th><span>* 상품주문번호</span></th>
                <td>
					<input type="text" name="Moid" value="<%=moid%>" style="width:210px">
					유니크한 상점 주문번호 (영문자+숫자 조합 가능)
				</td>
              </tr>
			  <tr>
                <th><span>* 결제 상품금액</span></th>
                <td>
					<input type="text" name="Amt" value="<%=price%>">
					상품 금액은 소스 상에서 변경 (위변조 체크)
				</td>
              </tr>	  			  
			  <tr>
                <th><span>* 구매자명</span></th>
                <td><input type="text" name="BuyerName" value="<%=buyerName%>"></td>
              </tr>
              <tr>
                <th><span>* 구매자 전화번호</span></th>
                <td>
					<input type="text" name="BuyerTel" value="">
					SMS 수신할 전화 번호 입니다. 숫자만 입력 예: 01012345678
				</td>
              </tr>
			  <tr>
                <th><span>구매자 이메일</span></th>
                <td><input type="text" name="BuyerEmail" value="<%=buyerEmail%>"></td>
              </tr>
			  <tr>
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
              </tr>
			  <tr>
                <th><span>* ARS 구분</span></th>
                <td>
                    <!-- 옵션 -->
                    <input type="hidden" name="VbankExpDate" value="<%=tomorrow%>"/>             <!-- 가상계좌입금만료일 -->
                    <input type="hidden" name="BuyerEmail" value="<%=buyerEmail%>"/>             <!-- 구매자 이메일 -->				  
                    <input type="hidden" name="GoodsCl" value="1"/>                              <!-- 상품구분(실물(1),컨텐츠(0)) -->  
                    <input type="hidden" name="TransType" value="0"/>                            <!-- 일반(0)/에스크로(1) --> 
              
                    <!-- 변경 불가능 -->
                    <input type="hidden" name="EncodeParameters" value="<%=encodeParameters%>"/> <!-- 암호화대상항목 -->
                    <input type="hidden" name="EdiDate" value="<%=ediDate%>"/>                   <!-- 전문 생성일시 -->
                    <input type="hidden" name="EncryptData" value="<%=hashString%>"/>            <!-- 해쉬값 -->
                    <input type="hidden" name="TrKey" value=""/>                                 <!-- 필드만 필요 -->
                    <input type="hidden" name="MerchantKey" value="<%=merchantKey%>"/>           <!-- 상점 키 -->


					<input type="text" name="ArsReqType" value="SMS">
					호전환 : ARS, SMS 전송 : SMS
				</td>
              </tr>
			  
            </table>
          </div>
        </div>
        <div class="btngroup">
          <a href="#" class="btn_blue" onClick="nicepay();">요 청</a>
        </div>
      </div>
    </div>
</form>
</body>
</html>