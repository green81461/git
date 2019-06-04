using System;
using System.Collections;
using System.Configuration;
using System.Data;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using NiceLiteLibNet;
using System.Security.Cryptography;
using System.Text;
using SocialWith.Biz.Pay;
using System.Collections.Generic;
using Urian.Core;
using System.Globalization;
using System.IO;
using NLog;
using SocialWith.Biz.User;

public partial class Order_ArsResult : NonAuthenticationPageBase
{
    PayService PayService = new PayService();
    UserService UserService = new UserService();

    protected void Page_Load(object sender, EventArgs e)
    {
        logger.Debug("========================= ARSResult START ============================");

        if (!Page.IsPostBack)
        {
            resultData();
        }
    }
    protected void resultData()
    {
        string sResultCode = Request.Form["resultCode"].AsText();
        string sResultMsg = Request.Form["resultMsg"].AsText();

        //ARS 결제 취소인 경우 예외처리
        if (sResultMsg.Equals("취소"))
        {
            Response.Write("OK");
            Response.End();
        }

        string sTID = Request.Form["tid"].AsText();
        string sMoid = Request.Form["moid"].AsText();
        string sAmt = Request.Form["Amt"].AsText();
        string spayMethod = Request.Form["payMethod"].AsText();
        string sAuthDate = Request.Form["authDate"].AsText();
        string sAuthCode = Request.Form["authCode"].AsText();
        string sCardCode = Request.Form["CardCode"].AsText();
        string sCardName = Request.Form["CardName"].AsText();
        string sCardNo = Request.Form["CardNo"].AsText();

        string sCardQuota = Request.Form["CardQuota"].AsText();

        string sAcquCardCode = Request.Form["AcquCardCode"].AsText();
        string sAcquCardName = Request.Form["AcquCardName"].AsText();

        string sBankCode = Request.Form["bankCode"].AsText();
        string sBankName = Request.Form["bankName"].AsText();
        string sRcptType = Request.Form["rcptType"].AsText();
        string sRcptAuthCode = Request.Form["rcptAuthCode"].AsText();
        string srcptTID = Request.Form["rcptTID"].AsText();
        string scarrier = Request.Form["carrier"].AsText();
        string sdstAddr = Request.Form["dstAddr"].AsText();
        string svBankCode = Request.Form["vBankCode"].AsText();
        string sVbankName = Request.Form["vBankName"].AsText();
        string sVbankNum = Request.Form["vbankNum"].AsText();
        string sVbankExpDate = Request.Form["vbankExpDate"].AsText();
        string sgoodsName = Request.Form["goodsName"].AsText();
        string spayWayResult = Request.Form["payWayResult"].AsText();

        string sGoodsCnt = Request.Form["GoodsCnt"].AsText();
        string sSvid_User = Request.Form["Svid_User"].AsText();
        string sBuyerEmail = Request.Form["BuyerEmail"].AsText();
        string sBuyerName = Request.Form["BuyerName"].AsText();
        string sGoodsCl = Request.Form["GoodsCl"].AsText();
        string sTransType = Request.Form["TransType"].AsText();
        string sEncodeParameters = Request.Form["EncodeParameters"].AsText();
        string sPayWay = Request.Form["PayWay"].AsText();
        string sEdiDate = Request.Form["EdiDate"].AsText();

        string sEncryptData = Request.Form["EncryptData"].AsText();
        string sTrKey = Request.Form["TrKey"].AsText();
        string sSocketYN = Request.Form["SocketYN"].AsText();
        string sROLE_FLAG = Request.Form["ROLE_FLAG"].AsText();
        string CompanyName = Request.Form["CompanyName"].AsText();
        string sMID = Request.Form["MID"].AsText();

        string strNowDate = "";
        string nowYear = DateTime.Now.Year.ToString();
        nowYear = nowYear.Substring(0, 2);

        if (!string.IsNullOrWhiteSpace(sAuthDate) && sAuthDate.Length == 12)
        {
            logger.Error("================  " + sMoid + " 건에 대한 ARS 최종 승인 날짜(정상)  =======================");
            logger.Error("ResultCode : " + sResultCode);
            logger.Error("ResultMsg : " + sResultMsg);
            logger.Error("MOID : " + sMoid);
            logger.Error("SVID_USER : " + sSvid_User);
            logger.Error("MID : " + sMID);
            logger.Error("TID : " + sTID);
            logger.Error("Amt : " + sAmt);
            logger.Error("===========================================================================================");

            strNowDate = DateTime.ParseExact(nowYear + sAuthDate, "yyyyMMddHHmmss", null).ToString("yyyy-MM-dd HH:mm:ss");

        }
        else
        {
            logger.Error("================  " + sMoid + " 건에 대한 ARS 최종 승인 날짜 정보(오류)  =======================");
            logger.Error("ResultCode : " + sResultCode);
            logger.Error("ResultMsg : " + sResultMsg);
            logger.Error("MOID : " + sMoid);
            logger.Error("SVID_USER : " + sSvid_User);
            logger.Error("MID : " + sMID);
            logger.Error("TID : " + sTID);
            logger.Error("Amt : " + sAmt);
            logger.Error("============================================================================================");

            strNowDate = DateTime.Now.ToString("yyyy-MM-dd-HH-mm-ss");
        }

        bool insertSuccess = false;

        var service = new PayService();
        var paramList = new Dictionary<string, object>
        {
            {"nvar_P_ORDERCODENO",sMoid.AsText() },         //주문번호
            {"nvar_P_PG_TID",sTID.AsText()},                //TID
            {"nvar_P_BUYERNAME",sBuyerName},                //구매자명
            {"nvar_P_PAYCARDNO",sCardNo},                   //카드번호
            {"nvar_P_PAYCARDCODE",sCardCode},               //카드코드
            {"nvar_P_PAYCARDNAME",sCardName},               //카드명
            {"nvar_P_PAYCARDSPLITDUE",sCardQuota},          //카드할부기간
            {"nvar_P_BUYPAYCODE",sAcquCardCode},            //매입사코드
            {"nvar_P_BUYPAYNAME",sAcquCardName},            //매입사명
            {"nvar_P_SUBJECTDATE",strNowDate.AsText()},
            {"nvar_P_PAYCONFIRMNO",sRcptAuthCode},          //승인일시
            {"nvar_P_PAYRESULTCODE",sResultCode.AsText()},  //결제결과코드
            {"nvar_P_PAYRESULT",sResultMsg.AsText()},       //결제결과메시지
            {"nvar_P_PAYCONFIRMDATE",strNowDate.AsText() }, //결제일시
            {"nvar_P_PAYWAY","5"},                          //지불수단
            {"reVa_P_RETURN_PAYNO", -1}                    // 프로시저 실행 결과값(-1: fail)
        };

        //logger.Debug("sMoid : " + sMoid);
        //logger.Debug("sTID : " + sTID);
        //logger.Debug("sBuyerName : " + sBuyerName);
        //logger.Debug("sCardNo : " + sCardNo);
        //logger.Debug("sCardCode : " + sCardCode);
        //logger.Debug("sCardName : " + sCardName);
        //logger.Debug("sCardQuota : " + sCardQuota);
        //logger.Debug("sAcquCardCode : " + sAcquCardCode);
        //logger.Debug("sAcquCardName : " + sAcquCardName);
        ////logger.Debug("sAuthDate : " + sAuthDate);
        //logger.Debug("sRcptAuthCode : " + sRcptAuthCode);
        //logger.Debug("sResultCode : " + sResultCode);
        //logger.Debug("sResultMsg : " + sResultMsg);
        //logger.Debug("strNowDate : " + strNowDate);
        //logger.Debug("spayMethod : " + spayMethod);
        //logger.Debug("sMoidFlag : " + sMoidFlag);


        int returnVal = service.ArsPayResult(paramList);

        //0보다 크면 true 처리
        if (returnVal >= 1)
        {
            insertSuccess = true;
        }
        else
        {
            insertSuccess = false;
        }

        logger.Debug("========================= ArsResult END ============================");

        //나이스 쪽으로 OK 보냄. 정상처리 완료됨
        if (insertSuccess == true)
        {
            var useSMS = ConfigurationManager.AppSettings["SendSMSUse"].AsText("false");
            if (useSMS == "true")
            {
                SendMMS();
            }
            Response.Write("OK");
            Response.End();
        }

        //나이스쪽으로 FAIL 보내서 결제전문 재전송 요청
        else
        {
            Response.Write("FAIL");
            Response.End();
        }

    }

    private void SendSMS()
    {


        var paramList = new Dictionary<string, object>
        {
            {"nvar_P_TYPE", "ARSORDER"},
        };

        var list = UserService.GetSMSUserList(paramList);

        if (list != null)
        {
            string incomingUser = string.Empty;

            foreach (var item in list)
            {
                incomingUser += item.Name + "^" + Crypt.AESDecrypt256(item.PhoneNo).Replace("-", "") + "|";
            }

            if (!string.IsNullOrWhiteSpace(incomingUser))
            {
                var paramList2 = new Dictionary<string, object>
                {
                    {"nvar_P_SUBJECT", "제목"},
                    {"nvar_P_DEST_INFO", incomingUser.Substring(0, incomingUser.Length-1)},
                    //{"nvar_P_SMS_MSG",  "[주문의 건]\r\n"+ Request.Params["MOID"].AsText()+"(" + Request.Params["Amt"].AsDecimal().ToString("N0") + "원)"},
                    {"nvar_P_SMS_MSG",  "[발주 재진행 건]\r\n"+ Request.Params["MOID"].AsText()+" ARS 결제(완)"},
                };

                UserService.OrderSMSInsert(paramList2);
            }

        }
    }

    private void SendMMS()
    {
        var paramList = new Dictionary<string, object>
        {
            {"nvar_P_TYPE", "ARSORDER"},
        };

        var list = UserService.GetSMSUserList(paramList);

        if (list != null)
        {
            string incomingUser = string.Empty;

            foreach (var item in list)
            {
                incomingUser += item.Name + "^" + Crypt.AESDecrypt256(item.PhoneNo).Replace("-", "") + "|";
            }

            if (!string.IsNullOrWhiteSpace(incomingUser))
            {
                var paramList2 = new Dictionary<string, object>
                {
                    {"nvar_P_SUBJECT", "[ARS 발주 재진행]"},
                    {"nvar_P_DEST_INFO", incomingUser.Substring(0, incomingUser.Length-1)},
                    {"nvar_P_MSG",  "[ARS 발주 재진행]\r\n주문번호 : "+ Request.Params["MOID"].AsText()+"\r\n회사명 : "+ Request.Params["CompanyName"].AsText() +"\r\n금액 : " + Request.Params["Amt"].AsDecimal().ToString("N0") + "원" + "\r\nARS 결제(완) 입니다." + "\r\n발주를 재진행 해주시기 바랍니다."},
                };

                UserService.OrderMMSInsert(paramList2);
            }

        }
    }
}