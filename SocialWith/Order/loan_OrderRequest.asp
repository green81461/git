<%
PayMethod = request.form("PayMethod")                      '결제수단    PG사에서 원하는 값
payWayResult = request.form("payWayResult")                '결제수단    우리가 보여줄것.
Moid = request.form("Moid")                                '주문번호 
GoodsCnt = request.form("GoodsCnt")                        '수량  
Unum_PayNo = request.form("Unum_PayNo")                    '오더넘버  
Company_Code = request.form("Company_Code")                '회사넘버  
Svid_User = request.form("Svid_User")                      '로그인정보
VbankExpDate = request.form("VbankExpDate")                '입금 만료일
BuyerEmail = request.form("BuyerEmail")                    '이메일주소
GoodsCl = request.form("GoodsCl")                          '상품구분
TransType = request.form("TransType")                      '일반,에스크로 여부 
EncodeParameters = request.form("EncodeParameters")        '필수 값 중하나
PayWay = request.form("PayWay")                            '결제수단                   
EdiDate = request.form("EdiDate")                          '전문생성일시
EncryptData = request.form("EncryptData")                  '해쉬값
TrKey = request.form("TrKey")                              '필드만 있으면 됨.  
MerchantKey = request.form("MerchantKey")                  '상점 KEY 값
niceMID = request.form("MID")                              '상점 MID                     
SocketYN = request.form("SocketYN")                        '소켓 통신 여부 Y 고정
ROLE_FLAG = request.form("ROLE_FLAG")                      'FLAG 값
CompanyName = request.form("CompanyName")                  '회사명  
Amt = request.form("Amt")                                  '결제금액
GoodsName = request.form("GoodsName")                      '상품명   
BuyerName = request.form("BuyerName")                      '구매자명
BuyerTel = request.form("BuyerTel")                        '구매자 연락처  
ArsReqType = request.form("ArsReqType")                    'ARS타입
LogPath = Server.MapPath("/Logs/pay/")                     '로그정보
BulkBankNo = request.form("BulkBankNo")                    '벌크 계좌번호
   
UrianType = request.form("UrianType")                      '우리안 타입 정보
urianTypeUnumNo = request.form("urianTypeUnumNo")          '우리안 타입 정보
SaleComName = request.form("SaleComName")                  '판매사명

VbankBankCode = "088" '은행 코드
 
%>

<%
'###############################################################################
'# 1. 객체 생성 #
'################
Set NICEpay = Server.CreateObject("NICE.NICETX2.1")

'###############################################################################
'# 2. 인스턴스 초기화 #
'######################
PInst = NICEpay.Initialize("")

'###############################################################################
'# 3. 거래 유형 설정 #
'#####################
NICEpay.SetActionType CLng(PInst), "FORMPAY"

'###############################################################################
'# 4. 지불 정보 설정 #
'###############################################################################
'NICEpay.SetField CLng(PInst), "mid", "hangster0m"					'상점 ID  
NICEpay.SetField CLng(PInst), "mid", niceMID					'상점 ID  

'NICEpay.SetField CLng(PInst), "LicenseKey", "1XTbbnhq4AtLB1KP6iRoaKn/tievvie2YRrEWP0VY6UHW5e10Z9hNhaVPGK/1gVrYiYOWN+iJxfCRprZLjhFjg==" '상점키
NICEpay.SetField CLng(PInst), "LicenseKey", MerchantKey '상점키
NICEpay.SetField CLng(PInst), "paymethod","VBANK"					'결제 수단(고정)
NICEpay.SetField CLng(PInst), "debug", "true"							'로그모드("true"로 설정하면 상세한 로그를 남김)
NICEpay.SetField CLng(PInst), "TransType", "0"						'전송구분(고정)
NICEpay.SetField CLng(PInst), "logpath", LogPath

'과오납 체크 설정
'NICEpay.SetField CLng(PInst), "VbankBankCode", Request("VbankBankCode")					'은행 코드
'NICEpay.SetField CLng(PInst), "VbankNum", Request("VbankNum")							'가상계좌 번호
'NICEpay.SetField CLng(PInst), "VBankAccountName", Request("VBankAccountName")	        '입금 예금주명
'NICEpay.SetField CLng(PInst), "Amt", Request("Amt")									    '입금 금액
'NICEpay.SetField CLng(PInst), "VbankExpDate", Request("VbankExpDate")					'입금 마감일자 (YYYYMMDD)
'NICEpay.SetField CLng(PInst), "VbankExpTime", Request("VbankExpTime")					'입금 마감시간 (미 입력시 235959 hhmmss) 로 자동등록
NICEpay.SetField CLng(PInst), "GoodsName", GoodsName	                    '상품명
NICEpay.SetField CLng(PInst), "BuyerName", BuyerName			          	'구매자명
NICEpay.SetField CLng(PInst), "Moid", Moid			                    	'주문번호
NICEpay.SetField CLng(PInst), "VbankBankCode", VbankBankCode				'은행 코드
NICEpay.SetField CLng(PInst), "VbankNum", BulkBankNo						'가상계좌 번호
NICEpay.SetField CLng(PInst), "VBankAccountName", SaleComName	            '입금 예금주명
NICEpay.SetField CLng(PInst), "Amt", Amt								    '입금 금액
NICEpay.SetField CLng(PInst), "VbankExpDate", VbankExpDate					'입금 마감일자 (YYYYMMDD)
NICEpay.SetField CLng(PInst), "VbankExpTime",""



'###############################################################################
'# 5. 과오납 체크  요청 #
'################
NICEpay.StartAction(CLng(PInst))

'###############################################################################
'6. 요청 결과 #
'###############################################################################
resultCode = NICEpay.GetResult(CLng(PInst), "resultcode")	'결과코드 (정상 :4120 , 그 외 에러)
resultMsg = NICEpay.GetResult(CLng(PInst), "resultmsg")		'결과메시지
authDate = NICEpay.GetResult((PInst), "AuthDate")			'승인일시YYMMDDHH24mmss
tid = NICEpay.GetResult(CLng(PInst), "tid")                   '거래 ID
    
'###############################################################################
'# 8. 인스턴스 해제 #
'###############################################################################
NICEpay.Destroy CLng(PInst)

%>



<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <!--    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />-->
    <meta charset="utf-8" />
    <title></title>
    <script src="https://web.nicepay.co.kr/flex/js/nicepay_tr_utf.js" type="text/javascript"></script>
    <script type="text/javascript" src="../Scripts/jquery-1.10.2.min.js"></script>
    <script src="../Scripts/common.js"></script>
    <script type="text/javascript">

        $(document).ready(function () {

            var flagChk = $("input[name='ROLE_FLAG']").val();
            if ((flagChk != null) && (flagChk != '')) {
                document.payForm.action = "Loan_OrderResult";
                document.payForm.submit();
            }
            else {
                document.payForm.action = "Loan_OrderResult_Bill";
                document.payForm.submit();

            }

        });




    </script>
    <style>
        ul {
            list-style: none;
        }

        .auto-style1 {
            width: 317px;
            height: 168px;
            margin-left: 146px;
        }
    </style>

</head>
<body>
    <form name="payForm" method="post">
        <h1></h1>
        <ul>
            <li>
                <input id="PayMethod" name="PayMethod" type="hidden" value="<%=PayMethod%>" /></li>

            <li>
                <input id="payWayResult" name="payWayResult" type="hidden" value="<%=payWayResult%>" /></li>
            <li>
                <input id="Moid" name="Moid" type="hidden" value="<%=Moid%>" /></li>
            <li>
                <input id="GoodsCnt" name="GoodsCnt" type="hidden" value="<%=GoodsCnt%>" /></li>
            <li>
                <input id="Unum_PayNo" name="Unum_PayNo" type="hidden" value="<%=Unum_PayNo%>" /></li>
            <li>
                <input id="Company_Code" name="Company_Code" type="hidden" value="<%=Company_Code%>" /></li>
            <li>
                <input id="Svid_User" name="Svid_User" type="hidden" value="<%=Svid_User%>" /></li>
            <li>
                <input id="VbankExpDate" name="VbankExpDate" type="hidden" value="<%=VbankExpDate%>" /></li>
            <li>
                <input id="BuyerEmail" name="BuyerEmail" type="hidden" value="<%=BuyerEmail%>" /></li>
            <li>
                <input id="GoodsCl" name="GoodsCl" type="hidden" value="<%=GoodsCl%>" /></li>

            <li>
                <input id="TransType" name="TransType" type="hidden" value="<%=TransType%>" /></li>
            <li>
                <input id="EncodeParameters" name="EncodeParameters" type="hidden" value="<%=EncodeParameters%>" /></li>

            <li>
                <input id="PayWay" name="PayWay" type="hidden" value="<%=PayWay%>" /></li>

            <li>
                <input id="EdiDate" name="EdiDate" type="hidden" value="<%=EdiDate%>" /></li>

            <li>
                <input id="ArsReqType" name="ArsReqType" type="hidden" value="<%=ArsReqType%>" /></li>

            <li>
                <input id="EncryptData" name="EncryptData" type="hidden" value="<%=EncryptData%>" /></li>

            <li>
                <input id="TrKey" name="TrKey" type="hidden" value="<%=TrKey%>" /></li>

            <li>
                <input id="MerchantKey" name="MerchantKey" type="hidden" value="<%=MerchantKey%>" /></li>

            <li>
                <input id="MID" name="MID" type="hidden" value="<%=niceMID%>" /></li>

            <li>
                <input id="SocketYN" name="SocketYN" type="hidden" value="<%=SocketYN%>" /></li>
            <li>
                <input id="ROLE_FLAG" name="ROLE_FLAG" type="hidden" value="<%=ROLE_FLAG%>" /></li>
            <li>
                <input id="CompanyName" name="CompanyName" type="hidden" value="<%=CompanyName%>" /></li>
            <li>
                <input id="Amt" name="Amt" type="hidden" value="<%=Amt%>" /></li>

            <li>
                <input id="CardQuota" name="CardQuota" type="hidden" value="0" /></li>

            <li>
                <input id="Buyertel" name="Buyertel" type="hidden" value="<%=BuyerTel%>" /></li>

            <li>
                <input id="BuyerName" name="BuyerName" type="hidden" value="<%=BuyerName%>" /></li>

            <li>
                <input id="GoodsName" name="GoodsName" type="hidden" value="<%=GoodsName%>" /></li>

            <li>
                <input id="LogPath" name="LogPath" type="hidden" value="<%=LogPath%>" /></li>
            <li>
                <input id="resultCode" name="resultCode" type="hidden" value="<%=resultCode%>" /></li>

            <li>
                <input id="resultMsg" name="resultMsg" type="hidden" value="<%=resultMsg%>" /></li>

            <li>
                <input id="authDate" name="authDate" type="hidden" value="<%=authDate%>" /></li>

            <li>
                <input id="BulkBankNo" name="BulkBankNo" type="hidden" value="<%=BulkBankNo%>" /></li>

            <li>
                <input id="vBankCode" name="vBankCode" type="hidden" value="<%=VbankBankCode%>" /></li>

            <li>
                <input id="UrianType" name="UrianType" type="hidden" value="<%=UrianType%>" /></li>


            <li>
                <input id="urianTypeUnumNo" name="urianTypeUnumNo" type="hidden" value="<%=urianTypeUnumNo%>" /></li>


            <li>
                <input id="tid" name="tid" type="hidden" value="<%=tid%>" /></li>

            <li>
                <input id="SaleComName" name="SaleComName" type="hidden" value="<%=SaleComName%>" /></li>



        </ul>



        <!--로딩패널-->
        <div class="wrap-loading  display-none" style="width: 50%; height: 500px; margin: auto">

            <div style="margin-right: 200px; margin-top: 200px; margin-bottom: 200px;" class="auto-style1">
                <img src="../Images/loading.gif" style="width: 80px; height: 79px" />
                지금 처리 중입니다.
            </div>

        </div>

        <div style="clear: both; margin: 5px 0 5px 0;">
            <div id="paginationBottom" class="page_curl"></div>
        </div>
        <!--<div class="btngroup">
            <a href="#" class="btn_blue" onclick="nicepay();">요 청</a>
        </div>-->
    </form>



</body>
</html>
