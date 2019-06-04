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

public partial class Order_VbankResult : System.Web.UI.Page
{
    #region << logger >>
    protected static Logger logger = NLog.LogManager.GetCurrentClassLogger();
    protected static readonly bool IsDebugEnabled = logger.IsDebugEnabled;
    protected static readonly bool IsInfoEnabled = logger.IsInfoEnabled;
    protected static readonly bool IsWarnEnabled = logger.IsWarnEnabled;
    protected static readonly bool IsErrorEnabled = logger.IsErrorEnabled;
    protected static readonly bool IsFatalEnabled = logger.IsFatalEnabled;
    #endregion

    PayService PayService = new PayService();
    UserService UserService = new UserService();

    protected string LogPath;
    protected string CancelPwd;



    protected void Page_Load(object sender, EventArgs e)
    {
        logger.Debug("========================= VbankResult START ============================");

        if (!Page.IsPostBack)
        {
            resultData();
        }
    }
    protected void resultData()
    {
        //NiceLite lite = new NiceLite(@"SECUREPAY");

        LogPath = Server.MapPath(ConfigurationManager.AppSettings["NicePayLogFoler"]);
        LogPath += DateTime.Now.ToString("yyyy-MM-dd") + "_NiceVbankResult.log";

        //LogPath = @"E:\web\urian\Logs\pay";        //로그 디렉토리   
        CancelPwd = @"rhdrka219";

        String sPayMethod = Request.Params["PayMethod"];    //지불수단 ex vbank        
        String sMID = Request.Params["MID"];                //상점ID
        String sMallUserID = Request.Params["MallUserID"];  // 회원사ID
        String sAmt = Request.Params["Amt"];                //금액
        String sName = Request.Params["Name"];              //구매자명
        String sGoodsName = Request.Params["GoodsName"];    //상품명
        String sTID = Request.Params["TID"];                //거래아이디
        String sMOID = Request.Params["MOID"];              //주문번호
        String sAuthDate = Request.Params["AuthDate"];      //입금일시
        String sResultCode = Request.Params["ResultCode"];  //결과코드 4110
        String sResultMsg = Request.Params["ResultMsg"];    //결과메시지
        String sVbankNum = Request.Params["VbankNum"];      //가상계좌번호
        String sFnCd = Request.Params["FnCd"];              //가상계좌 은행코드
        String sVbankName = Request.Params["VbankName"];    //가상계좌 은행명
        String sVbankInputName = Request.Params["VbankInputName"];  //입금자명
        String sRcptTID = Request.Params["RcptTID"];        //현금영수증 거래번호
        String sRcptType = Request.Params["RcptType"];      //현금영수증 구분(0:미발행, 1: 소득공제용,2:지출증빙용)
        String sRcptAuthCode = Request.Params["RcptAuthCode"];       //현금영수증 승인번호
        String CompanyName = Request.Params["CompanyName"];        //회사명

        FileInfo file = new FileInfo(LogPath);
        StreamWriter sw = file.AppendText();
        sw.WriteLine("********************************************************************");
        sw.WriteLine("PayMethod:" + sPayMethod);
        sw.WriteLine("MID:" + sMID);
        sw.WriteLine("MallUserID:" + sMallUserID);
        sw.WriteLine("Amt:" + sAmt);
        sw.WriteLine("name:" + sName);
        sw.WriteLine("GoodsName:" + sGoodsName);
        sw.WriteLine("TID:" + sTID);
        sw.WriteLine("MOID:" + sMOID);
        sw.WriteLine("AuthDate:" + sAuthDate);
        sw.WriteLine("ResultCode:" + sResultCode);
        sw.WriteLine("ResultMSG:" + sResultMsg);
        sw.WriteLine("FnCd:" + sFnCd);
        sw.WriteLine("VbankName:" + sVbankName);
        sw.WriteLine("VbankInputName:" + sVbankInputName);
        sw.WriteLine("RcptTID:" + sRcptTID);
        sw.WriteLine("RcptType:" + sRcptType);
        sw.WriteLine("RcptAuthCode:" + sRcptAuthCode);
        sw.WriteLine("sVbankNum:" + sVbankNum);
        sw.WriteLine("CompanyName:" + CompanyName);
        sw.WriteLine("********************************************************************");
        sw.WriteLine("");

        sw.Flush();
        sw.Close();

        if(string.IsNullOrWhiteSpace(sPayMethod))
        {
            logger.Debug("FAIL : NULL" );

            Response.Write("FAIL - NULL");
            Response.End();
        }

        string strNowDate = "";
        string nowYear = DateTime.Now.Year.ToString();
        nowYear = nowYear.Substring(0, 2);
        logger.Debug("sAuthDate : " + sAuthDate);
        logger.Debug("nowYear : " + nowYear);
        strNowDate = DateTime.ParseExact(nowYear + sAuthDate, "yyyyMMddHHmmss", null).ToString("yyyy-MM-dd HH:mm:ss");

        logger.Debug("strNowDate : " + strNowDate);


        string sMoidFlag;
        // sMOID가 as면 플래그값 넘기기 nvar_P_FLAG as면 AS 아니면 JA

   

        if (sMOID.Contains("YN") == true)
        {
            sMoidFlag = "YN";
        }
        else
        {
            sMoidFlag = "ON";
        }

        logger.Debug("sMoidFlag : " + sMoidFlag);

        bool insertSuccess = false;

        var service = new PayService();
        var paramList = new Dictionary<string, object>
        {
            {"nvar_P_ORDERCODENO",sMOID.AsText() },                  //주문번호
            {"nvar_P_PG_TID",sTID.AsText()},                         //TID
            {"nvar_P_PG_MID",sMID.AsText()},                         //상점아이디
            {"nvar_P_BUYERNAME",sName.AsText()},                     //구매자명
            {"nvar_P_GOODSNAME",sGoodsName.AsText()},                //구매상품명
            {"nume_P_AMT",sAmt.AsDecimal()},                         //결제금액
            {"nvar_P_PAYWAY",sPayMethod.AsText()},                   //지불수단
            {"nvar_P_VBANKCODE",sFnCd.AsText()},                     //은행코드
            {"nvar_P_VBANKNAME",sVbankName.AsText()},                //은행명
            {"nvar_P_VBANKNO",sVbankNum.AsText()},                   //가상계좌번호
            {"char_P_CASHBILLTYPE",sRcptType.AsText()},              //현금영수증타입
            {"nvar_P_CASHBILLTYPECONFIRMNO",sRcptAuthCode.AsText()}, //현금영수증 승인번호
            {"nvar_P_CASHBILLTYPETID",sRcptTID.AsText()},            //현금영수증 TID
            {"nvar_P_BANKTYPENAME",sVbankInputName.AsText()},        //예금주
            {"nvar_P_PAYRESULTCODE",sResultCode.AsText()},           //결제결과코드
            {"nvar_P_PAYRESULT",sResultMsg.AsText()},                //결제결과메시지
            {"nvar_P_PAYCONFIRMDATE",strNowDate.AsText() },          //결제일시
            {"reVa_P_RETURN_PAYNO", -1},                             // 프로시저 실행 결과값(-1: fail)
            {"nvar_P_FLAG",sMoidFlag.AsText()}
        };

        int returnVal = service.VbankPayResult(paramList);

        //0보다 크면 true 처리
        if (returnVal >= 1)
        {
            insertSuccess = true;
        }
        else
        {
            insertSuccess = false;
        }

        logger.Debug("========================= VbankResult END ============================");

        //나이스 쪽으로 OK 보냄. 정상처리 완료됨
        if (insertSuccess == true)
        {
            var useSMS = ConfigurationManager.AppSettings["SendSMSUse"].AsText("false");
            if ((useSMS == "true") && sMoidFlag.Equals("ON"))
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

    private void SendMMS()
    {


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

            if (!string.IsNullOrWhiteSpace(incomingUser))
            {
                var paramList2 = new Dictionary<string, object>
                {
                    {"nvar_P_SUBJECT", "[가상계좌 입금]"},
                    {"nvar_P_DEST_INFO", incomingUser.Substring(0, incomingUser.Length-1)},
                    {"nvar_P_MSG",  "[가상계좌 입금완료]\r\n주문번호 : "+ Request.Params["MOID"].AsText()+"\r\n회사명 : "+ Request.Params["CompanyName"].AsText() +"\r\n금액 : " + Request.Params["Amt"].AsDecimal().ToString("N0") + "원"},
                };

                UserService.OrderMMSInsert(paramList2);
            }
        }
    }
}
