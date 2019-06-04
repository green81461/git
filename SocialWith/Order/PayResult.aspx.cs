using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using NiceLiteLibNet;
using NLog;
using NLog.Config;
using NLog.Targets;
using Urian.Core;
using SocialWith.Biz.Pay;
using SocialWith.Biz.User;

public partial class Order_PayResult : NonAuthenticationPageBase
{
    protected static readonly Logger logger = LogManager.GetCurrentClassLogger();

    protected string svidUser;
    protected string payMethodFlag = string.Empty;
    protected string LogPath;
    protected string EncodeKey;
    protected string CancelPwd;
    protected string vBankDate;         //가상계좌입금만료일
    protected string printSaveAuthDate; //출력용 결제승인일자
    protected string pPayMethodName;    //결제수단명
    protected string paySuccessFlag;    //결제결과구분값

    protected string pMID;
    protected string pAmt;
    protected string pEncodeKey;
    protected string pPayMethod;
    protected string pGoodsName;
    protected string pGoodsCnt;
    protected string pBuyerName;
    protected string pBuyerTel;
    protected string pBuyerEmail;
    protected string pBuyerAddr;
    protected string pBuyerPostNo;
    protected string pTrKey;
    protected string pTransType;
    protected string pMallUserID;
    protected string pMoid;
    protected string pVbankBankCode;
    protected string pVbankBankName;
    protected string pVbankNum;
    protected string pVBankAccountName;
    protected string pVbankExpDate;
    protected string pVbankExpTime;
    protected string pSupplyAmt;
    protected string pGoodsVat;
    protected string pServiceAmt;
    protected string pTaxFreeAmt;

    protected string TID;
    protected string MID;
    

    protected void Page_Load(object sender, EventArgs e)
    {
        if(!IsPostBack)
        {
            ResultDataBind();
        }
    }

    protected void ResultDataBind()
    {
        svidUser = Request.Params["hdSvidUser"].AsText();           //사용자시퀀스
        payMethodFlag = Request.Params["PayMethodFlag"].AsText();   //결제수단
        pPayMethodName = Request.Params["PayMethodName"].AsText();  //결제수단명

        pMID = Request.Params[@"MID"].AsText();
        pAmt = Request.Params[@"Amt"].AsText();
        pEncodeKey = Request.Params[@"MerchantKey"].AsText();
        pPayMethod = Request.Params[@"PayMethod"].AsText();
        pGoodsName = Request.Params[@"GoodsName"].AsText();
        pGoodsCnt = Request.Params[@"GoodsCnt"].AsText();
        pBuyerName = Request.Params[@"BuyerName"].AsText();
        pBuyerTel = Request.Params[@"BuyerTel"].AsText();
        pBuyerEmail = Request.Params[@"BuyerEmail"].AsText();
        pBuyerAddr = Request.Params[@"BuyerAddr"].AsText();
        pBuyerPostNo = Request.Params[@"BuyerPostNo"].AsText();
        pTrKey = Request.Params[@"TrKey"].AsText();
        pTransType = Request.Params[@"TransType"].AsText();
        pMallUserID = Request.Params[@"MallUserID"].AsText();
        pMoid = Request.Params[@"Moid"].AsText();
        pVbankBankCode = Request.Params[@"VbankBankCode"].AsText();
        pVbankBankName = Request.Params[@"VbankBankName"].AsText();
        pVbankNum = Request.Params[@"VbankNum"].AsText();
        pVBankAccountName = Request.Params[@"VBankAccountName"].AsText();
        pVbankExpDate = Request.Params[@"VbankExpDate"].AsText();
        pVbankExpTime = Request.Params[@"VbankExpTime"].AsText();
        pSupplyAmt = Request.Params[@"SupplyAmt"].AsText();
        pGoodsVat = Request.Params[@"GoodsVat"].AsText();
        pServiceAmt = Request.Params[@"ServiceAmt"].AsText();
        pTaxFreeAmt = Request.Params[@"TaxFreeAmt"].AsText();

        string bankTypeName = pBuyerName; //예금주명(가상계좌(채번):구매자, 가상계좌(벌크):판매사)
        string apiFlag = @"SECUREPAY";

        //ARS(카드) 결제인 경우
        if (payMethodFlag.Equals("5"))
        {
            ResultCode.Text = Request.Params[@"hdResultCode"].AsText();  //ARS 결제결과코드
            ResultMsg.Text = Request.Params[@"hdResultMsg"].AsText();    //ARS 결제결과메시지
            AuthDate.Text = Request.Params[@"AuthDate"].AsText();        //결제승인일시
            AuthCode.Text = Request.Params[@"AuthCode"].AsText();        //결제승인번호

            MID = pMID; //상점ID
            TID = Request.Params[@"TID"].AsText();  //거래ID
            Moid.Text = pMoid;                      //주문번호
            Amt.Text = pAmt;                        //결제금액
            
            CardCode.Text = string.Empty;           //카드코드
            CardName.Text = string.Empty;           //카드사명
            CardNumber.Text = string.Empty;         //카드번호
            AcquCardCode.Text = string.Empty;       //카드매입사코드
            AcquCardName.Text = string.Empty;       //카드매입사명
            CardQuota.Text = string.Empty;          //카드할부개월
            BankCode.Text = string.Empty;           //계좌이체은행코드
            BankName.Text = string.Empty;           //계좌이체은행명
            RcptType.Text = string.Empty;           //현금영수증 타입 (0:발행되지않음,1:소득공제,2:지출증빙)
            RcptAuthCode.Text = string.Empty;       //현금영수증 승인 번호
        }
        //그 외 결제수단인 경우
        else
        {
            if (payMethodFlag.Equals("6") || payMethodFlag.Equals("9"))
            {
                apiFlag = @"FORMPAY";
                bankTypeName = pVBankAccountName;
            }

            //FORMPAY

            /****************************************************
            * <결제 결과 설정>
            * 사용전 결과 옵션을 사용자 환경에 맞도록 변경하세요.
            * 로그 디렉토리는 꼭 변경하세요.
            ****************************************************/
            NiceLite lite = new NiceLite(apiFlag);

            LogPath = Server.MapPath(ConfigurationManager.AppSettings["NicePayLogFoler"]);         //로그 디렉토리   
            CancelPwd = @"rhdrka219";

            lite.SetField(@"LogPath", LogPath);                             //로그폴더 설정  
            lite.SetField(@"type", apiFlag);                           //타입설정(고정)  
            lite.SetField(@"MID", pMID);                   //상점 아이디
            lite.SetField(@"Amt", pAmt);                   //지불금액
            lite.SetField(@"EncodeKey", Request.Params[@"MerchantKey"].AsText());     //상점 라이센스 키(상점 아이디별 상이)
            lite.SetField(@"CancelPwd", CancelPwd);                         //취소 패스워드(상점 관리자페이지에서 설정)
            lite.SetField(@"PayMethod", pPayMethod);       //지불수단
            lite.SetField(@"GoodsName", pGoodsName);       //상품명
            lite.SetField(@"GoodsCnt", pGoodsCnt);         //상품갯수   
            lite.SetField(@"BuyerName", pBuyerName);       //구매자 명
            lite.SetField(@"BuyerTel", pBuyerTel);         //구매자 연락처
            lite.SetField(@"BuyerEmail", pBuyerEmail);     //구매자 이메일         
            lite.SetField(@"ParentEmail", Request.Params["ParentEmail"].AsText());   //보호자 이메일      
            lite.SetField(@"BuyerAddr", pBuyerAddr);       //구매자 주소
            lite.SetField(@"BuyerPostNo", pBuyerPostNo);   //구매자 우편번호
            lite.SetField(@"GoodsCl", Request.Params[@"GoodsCl"].AsText());           //휴대폰 컨텐츠 구분            
            lite.SetField(@"TrKey", pTrKey);               //인증key    
            lite.SetField(@"TransType", pTransType);       //요청 타입(일반(0) 에스크로(1))
            lite.SetField(@"MallUserID", pMallUserID);     //회원사 고객ID
            lite.SetField(@"Moid", pMoid);  //가맹점 주문번호

            lite.SetField(@"VbankBankCode", pVbankBankCode);           //은행 코드
            lite.SetField(@"VbankNum", pVbankNum);                     //가상계좌 번호
            lite.SetField(@"VBankAccountName", pVBankAccountName);     //입금예금주명
            lite.SetField(@"VbankExpDate", pVbankExpDate);             //입금마감일자
            lite.SetField(@"VbankExpTime", pVbankExpTime);             //입금마감시간

            //복합과세 정보
            lite.SetField(@"SupplyAmt", pSupplyAmt);       //공급가액
            lite.SetField(@"GoodsVat", pGoodsVat);         //부가세
            lite.SetField(@"ServiceAmt", pServiceAmt);     //봉사료
            lite.SetField(@"TaxFreeAmt", pTaxFreeAmt);     //면세금액
            lite.SetField(@"debug", @"true");                               //로그모드(실 서비스 "false" 로 설정)

            lite.DoPay();

            /****************************************************
            * <결제 결과 필드>
            * 아래 응답 데이터 외에도 전문 Header와 개별부 데이터 Get 가능
            ****************************************************/
            ResultCode.Text = lite.GetValue("ResultCode");          //결제결과코드
            ResultMsg.Text = lite.GetValue("ResultMsg");            //결제결과메시지
            AuthDate.Text = lite.GetValue("AuthDate");              //결제승인일시
            AuthCode.Text = lite.GetValue("AuthCode");              //결제승인번호
            //BuyerName.Text = lite.GetValue("BuyerName");            //구매자명
            //GoodsName.Text = lite.GetValue("GoodsName");            //결제상품명
            MID = lite.GetValue("MID");                        //상점ID
            TID = lite.GetValue("TID");                        //거래ID
            Moid.Text = lite.GetValue("Moid");                      //주문번호
            Amt.Text = lite.GetValue("Amt");                        //결제금액
            pPayMethod = lite.GetValue("PayMethod");            //결제지불수단
            CardCode.Text = lite.GetValue("CardCode");              //카드코드
            CardName.Text = lite.GetValue("CardName");              //카드사명
            CardNumber.Text = lite.GetValue("CardNo");              //카드번호
            AcquCardCode.Text = lite.GetValue("AcquCardCode");      //카드매입사코드
            AcquCardName.Text = lite.GetValue("AcquCardName");      //카드매입사명
            CardQuota.Text = lite.GetValue("CardQuota");            //카드할부개월
            BankCode.Text = lite.GetValue("BankCode");              //계좌이체은행코드
            BankName.Text = lite.GetValue("BankName");              //계좌이체은행명
            RcptType.Text = lite.GetValue("RcptType");              //현금영수증 타입 (0:발행되지않음,1:소득공제,2:지출증빙)
            RcptAuthCode.Text = lite.GetValue("RcptAuthCode");      //현금영수증 승인 번호
            //VbankBankCode.Text = lite.GetValue("VbankBankCode");    //가상계좌 은행코드
            //VbankName.Text = lite.GetValue("VbankBankName");        //가상계좌 은행명
            //VbankNum.Text = lite.GetValue("VbankNum");              //가상계좌 번호
            //VbankExpDate.Text = lite.GetValue("VbankExpDate");      //가상계좌 입금만료일

            //vBankDate = lite.GetValue("VbankExpDate");

            //복합과세 정보
            //SupplyAmt.Text = lite.GetValue("SupplyAmt");            //공급가액
            //GoodsVat.Text = lite.GetValue("GoodsVat");              //부가세
            //ServiceAmt.Text = lite.GetValue("ServiceAmt");          //봉사료
            //TaxFreeAmt.Text = lite.GetValue("TaxFreeAmt");          //면세금액

            
            VbankBankCode.Text = pVbankBankCode;    //가상계좌 은행코드
            VbankName.Text = pVbankBankName;        //가상계좌 은행명
            VbankNum.Text = pVbankNum;              //가상계좌 번호
            VbankExpDate.Text = pVbankExpDate;      //가상계좌 입금만료일
        }

        TotGoodsQty.Text = pGoodsCnt;
        BuyerName.Text = pBuyerName;
        GoodsName.Text = pGoodsName;

        /****************************************************
        * <결제 성공 여부 확인>
        ****************************************************/
        bool paySuccess = false;
        if (pPayMethod.Equals("CARD"))
        {
            if (ResultCode.Text.Equals("3001"))
            {
                paySuccess = true;      //신용카드(정상 결과코드:3001)
            }
            cardPanel.Visible = true;
        }
        else if(pPayMethod.Equals("CARD_ARS"))
        {
            if (ResultCode.Text.Equals("0000"))
            {
                paySuccess = true;      //신용카드(정상 결과코드:0000)
            }
            cardPanel.Visible = true;
        }
        else if (pPayMethod.Equals("BANK"))
        {
            if (ResultCode.Text.Equals("4000")) paySuccess = true;	    //계좌이체(정상 결과코드:4000)  
            bankPanel.Visible = true;
        }
        else if (pPayMethod.Equals("VBANK"))
        {
            if (ResultCode.Text.Equals("4100") || ResultCode.Text.Equals("4120")) paySuccess = true;	    //가상계좌(정상 결과코드:4100)  
            vbankPanel.Visible = true;
        }

        ltrResultTxt.Text = "결제 실패";
        paySuccessFlag = "FAIL";
        string paySuccessYn = "N"; //결제여부

        string saveAuthDate = string.Empty;

        if (paySuccess)
        {
            ltrResultTxt.Text = "결제 성공";
            paySuccessFlag = "SUCCESS_"+payMethodFlag;

            //여신(일반), 여신(무) 결제수단이 아닌 경우
            if(!payMethodFlag.Equals("6") && !payMethodFlag.Equals("8"))
            {
                paySuccessYn = "Y";
            }

            //결제승인일시 설정
            saveAuthDate = AuthDate.Text.AsText();

            logger.Info("saveAuthDate : " + saveAuthDate);

            if (!String.IsNullOrWhiteSpace(saveAuthDate))
            {
                string tmpDate = DateTime.Now.Year.ToString();
                tmpDate = tmpDate.Substring(0, 2);

                saveAuthDate = saveAuthDate.Insert(10, ":");
                saveAuthDate = saveAuthDate.Insert(8, ":");
                saveAuthDate = saveAuthDate.Insert(6, " ");
                saveAuthDate = saveAuthDate.Insert(4, "/");
                saveAuthDate = saveAuthDate.Insert(2, "/");


                string[] sp = saveAuthDate.Split('/');
                string[] ap = sp[2].Split(' ');
                string AuthDateYY = tmpDate + sp[0];
                string AuthDateMM = sp[1];
                string AuthDateDD = ap[0];
                string AuthDateSS = ap[1];

                saveAuthDate = AuthDateYY + '-' + AuthDateMM + '-' + AuthDateDD + ' ' + AuthDateSS;

                printSaveAuthDate = AuthDateYY + '년' + AuthDateMM + '월' + AuthDateDD + '일';
            }

            //가상계좌 입금만료일 설정
            if (!String.IsNullOrWhiteSpace(pVbankExpDate))
            {
                pVbankExpDate = pVbankExpDate.Insert(6, "-");
                pVbankExpDate = pVbankExpDate.Insert(4, "-");
            }

        } else
        {
            Moid.Text = pMoid;
            BuyerName.Text = pBuyerName;
            GoodsName.Text = pGoodsName;
        }

        PayMethodName.Text = pPayMethodName;
        Amt.Text = pAmt.AsDecimal().ToString("#,###");


        logger.Info("----------------------------------------------------");
        logger.Info("결제 성공 여부 : " + paySuccess);
        logger.Info("결제 수단 코드 : " + payMethodFlag);
        logger.Info("결제 주문번호(Moid) : " + Request.Params["Moid"].AsText());
        logger.Info("결제 MID : " + Request.Params["MID"].AsText());
        logger.Info("결제 금액 : " + Request.Params["Amt"].AsText());
        logger.Info("결제 결과코드(ResultCode) : " + ResultCode.Text);
        logger.Info("결제 결과내용(ResultMsg) : " + ResultMsg.Text);
        logger.Info("결제메소드구분 : " + paySuccessFlag);
        logger.Info("----------------------------------------------------");

        PayService payService = new PayService();

        var paramList = new Dictionary<string, object> {
            {"nvar_P_ORDERCODENO",Moid.Text.AsText()},
            {"nvar_P_SVID_USER", svidUser}, // ===========>  svidUser 값 넘기게 처리해야 함........
            {"nvar_P_PAYRESULTCODE",ResultCode.Text.AsText()},
            {"nvar_P_PAYRESULT",ResultMsg.Text.AsText()},
            {"nvar_P_PAYCONFIRMDATE",saveAuthDate},
            {"nvar_P_PAYCONFIRMNO",AuthCode.Text.AsText()},
            {"nvar_P_PG_TID",TID.AsText()},
            {"nvar_P_PAYCARDCODE",CardCode.Text.AsText()},
            {"nvar_P_PAYCARDNAME",CardName.Text.AsText()},
            {"nvar_P_PAYCARDNO ",CardNumber.Text.AsText()},
            {"nvar_P_BUYPAYCODE",AcquCardCode.Text.AsText()},
            {"nvar_P_BUYPAYNAME",AcquCardName.Text.AsText()},
            {"nvar_P_PAYCARDSPLITDUE",CardQuota.Text.AsText()},
            {"nvar_P_BANKCODE",BankCode.Text.AsText()},
            {"nvar_P_BANKNAME",BankName.Text.AsText()},
            {"char_P_CASHBILLTYPE",RcptType.Text.AsText()},
            {"nvar_P_CASHBILLTYPECONFIRMNO",RcptAuthCode.Text.AsText()},
            {"nvar_P_VBANKCODE",pVbankBankCode},
            {"nvar_P_VBANKNAME",pVbankBankName},
            {"nvar_P_VBANKNO",pVbankNum},
            {"nvar_P_VBANKDATE",pVbankExpDate},
            {"char_P_PAYSUCESSYN",paySuccessYn},
            {"nvar_P_BANKTYPENAME",bankTypeName},
            {"nume_P_AMT",pAmt},
            {"nvar_P_FLAG",paySuccessFlag}
        };

        //새로고침 시 "[1610]TrKey 재사용 거래" 라는 오류가 발생
        //위의 오류 발생 시 DB에 Update 방지
        if(!ResultCode.Text.Equals("1610"))
        {
            payService.GetPayUpdate(paramList); //결제 결과 저장
        }

        if (paySuccess)
        {
            var useSMS = ConfigurationManager.AppSettings["SendSMSUse"].AsText("false");
            if (useSMS.Equals("true"))
            {
                if (!payMethodFlag.Equals("3") && !payMethodFlag.Equals("5"))
                {
                    SendMMS(); //관리자에게 문자전송
                }
            }
        }
    }

    private void SendMMS()
    {

        UserService UserService = new UserService();
        var paramList = new Dictionary<string, object>
        {
            {"nvar_P_TYPE", "ORDER"},
        };

        var list = UserService.GetSMSUserList(paramList);

        if (list != null)
        {
            string incomingUser = string.Empty;

            foreach (var item in list)
            {
                incomingUser += item.Name + "^" + Crypt.AESDecrypt256(item.PhoneNo).Replace("-", "") + "|";
            }

            if (!String.IsNullOrWhiteSpace(incomingUser))
            {
                var paramList2 = new Dictionary<string, object>
                {
                    {"nvar_P_SUBJECT", "[상품 주문 접수]"},
                    {"nvar_P_DEST_INFO", incomingUser.Substring(0, incomingUser.Length-1)},
                    {"nvar_P_MSG",  "[상품 주문 접수]\r\n주문번호 : "+ Request.Params["MOID"].AsText()+"\r\n회사명 : "+ Request.Params["CompanyName"].AsText() +"\r\n금액 : " + Request.Params["Amt"].AsDecimal().ToString("N0") + "원" + "\r\n주문 검토 후 발송 진행해주시기 바랍니다."},
                };

                UserService.OrderMMSInsert(paramList2);
            }

        }
    }
}