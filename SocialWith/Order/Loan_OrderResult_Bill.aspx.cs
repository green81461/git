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
using System.Security.Cryptography;
using System.Text;
using NiceLiteLibNet;
using SocialWith.Biz.Pay;
using System.Collections.Generic;
using Urian.Core;
using System.Globalization;
using SocialWith.Biz.User;

public partial class Order_Loan_OrderResult_Bill : System.Web.UI.Page
{
    PayService PayService = new PayService();

    protected string AmtView;
    protected string FLAG;

    protected string loan_ResultCode;
    protected string loan_payMethod;
    protected string loan_goodsName;
    protected string loan_Amt;
    protected string loan_Moid;
    protected string loan_buyerName;
    protected string loan_AuthDate;

    protected string loan_ResultMsg;
    protected string BulkBankNo;
    protected string chkPayway;

    protected string loan_VbankDate;

    protected string loan_PayWayResult;
    protected string Payway;
    protected string loan_SaleComName;
    protected string loan_SaveAuthDate;
    protected string Svid_User;


    protected void Page_Load(object sender, EventArgs e)
    {
        if (!Page.IsPostBack)
        {
            resultData();
        }
    }

    protected void resultData()
    {
        loan_ResultCode = Request.Form["resultCode"].AsText(); //결과내용
        loan_ResultMsg = Request.Form["resultMsg"].AsText(); //결과내용
        loan_payMethod = Request.Form["payMethod"].AsText();   //결제수단
        loan_goodsName = Request.Form["goodsName"].AsText();   //상품명
        loan_Amt = Request.Form["Amt"].AsText();               //가격
        loan_Moid = Request.Form["Moid"].AsText();              //주문번호
        loan_buyerName = Request.Form["BuyerName"].AsText();       //구매자명
        loan_AuthDate = Request.Form["authDate"].AsText();           //승인일시
        BulkBankNo = Request.Form["BulkBankNo"].AsText();       //벌크계좌명
        chkPayway = Request.Form["PayWay"].AsText();            //결제수단 체크
        loan_VbankDate = Request.Form["vbankExpDate"].AsText(); //입금 만료일
        loan_PayWayResult = Request.Form["payWayResult"].AsText();  //결제수단
        loan_SaleComName = Request.Form["SaleComName"].AsText();  //판매사명



        string ResultCode = Request.Form["resultCode"].AsText();
        string ResultMsg = Request.Form["resultMsg"].AsText();
        string TID = Request.Form["tid"].AsText();
        string Moid = Request.Form["Moid"].AsText();
        string Amt = Request.Form["Amt"].AsText();
        string payMethod = Request.Form["payMethod"].AsText();
        string AuthDate = Request.Form["authDate"].AsText();
        string CardCode = Request.Form["cardCode"].AsText();
        string CardName = Request.Form["cardName"].AsText();
        string CardQuota = Request.Form["cardQuota"].AsText();
        string BankCode = Request.Form["bankCode"].AsText();
        string BankName = Request.Form["bankName"].AsText();
        string RcptType = Request.Form["rcptType"].AsText();
        string RcptAuthCode = Request.Form["rcptAuthCode"].AsText();
        string rcptTID = Request.Form["rcptTID"].AsText();
        string carrier = Request.Form["carrier"].AsText();
        string dstAddr = Request.Form["dstAddr"].AsText();
        string vBankCode = Request.Form["vBankCode"].AsText();
        string VbankName = Request.Form["vBankName"].AsText();
        string VbankNum = Request.Form["vbankNum"].AsText();
        string VbankExpDate = Request.Form["vbankExpDate"].AsText();
        string goodsName = Request.Form["goodsName"].AsText();
        string payWayResult = Request.Form["payWayResult"].AsText();

        string GoodsCnt = Request.Form["GoodsCnt"].AsText();
        string Unum_PayNo = Request.Form["Unum_PayNo"].AsText();
        string CompanyCode = Request.Form["Company_Code"].AsText();
        string Svid_User = Request.Form["Svid_User"].AsText();
        string BuyerEmail = Request.Form["BuyerEmail"].AsText();
        string BuyerName = Request.Form["BuyerName"].AsText();
        string GoodsCl = Request.Form["GoodsCl"].AsText();
        string TransType = Request.Form["TransType"].AsText();
        string EncodeParameters = Request.Form["EncodeParameters"].AsText();
        string PayWay = Request.Form["PayWay"].AsText();
        string EdiDate = Request.Form["EdiDate"].AsText();

        string EncryptData = Request.Form["EncryptData"].AsText();
        //     string TrKey = Request.Form["TrKey"].AsText();
        string SocketYN = Request.Form["SocketYN"].AsText();
        string ROLE_FLAG = Request.Form["ROLE_FLAG"].AsText();
        string CompanyName = Request.Form["CompanyName"].AsText();
        string MID = Request.Form["MID"].AsText();

        string UrianType = Request.Form["UrianType"].AsText();
        string urianTypeUnumNo = Request.Form["urianTypeUnumNo"].AsText();



        string VBANKDATE = VbankExpDate;
        string SaveAuthDate = AuthDate;
        AmtView = Amt;
        if (!string.IsNullOrWhiteSpace(VBANKDATE))
        {
            VBANKDATE = VBANKDATE.Insert(6, "-");
            VBANKDATE = VBANKDATE.Insert(4, "-");
        }

        if (!string.IsNullOrWhiteSpace(SaveAuthDate))
        {
            string tmpDate = DateTime.Now.Year.ToString();
            tmpDate = tmpDate.Substring(0, 2);

            SaveAuthDate = SaveAuthDate.Insert(10, ":");
            SaveAuthDate = SaveAuthDate.Insert(8, ":");
            SaveAuthDate = SaveAuthDate.Insert(6, " ");
            SaveAuthDate = SaveAuthDate.Insert(4, "/");
            SaveAuthDate = SaveAuthDate.Insert(2, "/");


            string[] sp = SaveAuthDate.Split('/');
            string[] ap = sp[2].Split(' ');
            string AuthDateYY = tmpDate + sp[0];
            string AuthDateMM = sp[1];
            string AuthDateDD = ap[0];
            string AuthDateSS = ap[1];

            SaveAuthDate = AuthDateYY + '-' + AuthDateMM + '-' + AuthDateDD + ' ' + AuthDateSS;

            loan_SaveAuthDate = AuthDateYY + '년' + AuthDateMM + '월' + AuthDateDD + '일';

        }
        Payway = "";
        if (chkPayway.Equals("6"))
        {
            Payway = "여신결제";
        }

        if (chkPayway.Equals("8"))
        {
            Payway = "여신결제 무";
        }


        string paySuccessYn = "N";

        if (ResultCode.Equals("4120"))
        {
            paySuccessYn = "Y";

            if (chkPayway.Equals("6"))
            {
                FLAG = "SUCCESS_6";
            }
            if (chkPayway.Equals("9"))
            {
                FLAG = "SUCCESS_9";
            }

        }
        else
        {
            FLAG = "FAIL";
        }



        var service = new PayService();
        var paramList = new Dictionary<string, object> {

            { "nvar_P_COMPANY_CODE",CompanyCode }, //구매사코드
            { "nvar_P_PAYLOANSEQNOB",Unum_PayNo },  //여신결제번호 시퀀스
            { "nvar_P_PAYRESULTCOD",loan_ResultCode.AsText() },  //결제결과코드
            { "nvar_P_PAYRESULT",loan_ResultMsg.AsText() },  //결과내용
            { "nvar_P_PAYCONFIRMDATE",SaveAuthDate },  //결제승인일시
            { "nvar_P_PAYCONFIRMNO","" },  //결제승인번호
            { "nvar_P_PG_TID",TID.AsText()},  //거래 아이디
            {"char_P_CASHBILLTYPE",RcptType.AsText()},
            {"nvar_P_CASHBILLTYPECONFIRMNO",RcptAuthCode.AsText()},
            { "nvar_P_VBANKCODE","" },  //가상계좌 코드
            {"nvar_P_VBANKNAME",VbankName.AsText()},
            {"nvar_P_VBANKNO",BulkBankNo.AsText()},
            {"nvar_P_VBANKDATE",VBANKDATE}, //가상계좌 입금 만료일 
            {"char_P_PAYSUCESSYN",paySuccessYn},  //결제성공 유무 
            { "nvar_P_BANKTYPENAME",loan_SaleComName.AsText()},  //예금주(구매명) 
            { "nvar_P_FLAGE",FLAG }  //구분자(SUCCESS_6:여신(일반), SUCCESS_8:여신(무), FAIL:여신(일반) 결과 실패)

    };
        service.OrderBillType6(paramList);

        var useSMS = ConfigurationManager.AppSettings["SendSMSUse"].AsText("false");
        if (useSMS == "true" && FLAG != "FAIL")
        {
            SendMMS();
        }
    }

    private void SendMMS()
    {


        var paramList = new Dictionary<string, object>
        {
            {"nvar_P_TYPE", "ORDER"},
        };
        UserService userService = new UserService();
        var list = userService.GetSMSUserList(paramList);

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
                    {"nvar_P_SUBJECT", "[Web발신]"},
                    {"nvar_P_DEST_INFO", incomingUser.Substring(0, incomingUser.Length-1)},
                    {"nvar_P_MSG",  "[여신마감 결제 접수]\r\n여신번호 : "+ Request.Params["MOID"].AsText()+"\r\n회사명 : "+ Request.Params["CompanyName"].AsText() +"\r\n금액 : " + Request.Params["Amt"].AsDecimal().ToString("N0") + "원" + "\r\n주문 금액 및 결제 진행여부 검토 후 발송 진행해주시기 바랍니다."},
                };

                userService.OrderMMSInsert(paramList2);
            }

        }
    }

}