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

public partial class Order_VbankCancelRequest : PageBase
{
    PayService PayService = new PayService();

    protected String buyerName;
    protected String buyerTel;
    protected String buyerEmail;
    protected String ediDate;
    protected String editDate;
    protected String encodeParameters;
    protected String goodsName;
    protected int goodsCnt;
    protected String hash_String;
    protected decimal price;
    protected decimal DeliveryCost;
    protected decimal PowerDeliveryCost;
    protected String merchantKey;
    protected String merchantID;
    protected String moid;
    protected String transType;
    protected String PayMethod;
    protected String CompanyName;
    protected String CompanyDeptName;
    protected String Address_1;
    protected String PayWay;
    protected String FLAG;
    protected String subjectDate;
    protected String goodsFullName;
    protected String payWayResult;
    protected String VbankExpDate;

    protected String ordCodeNo;
    protected String ordStat;

    protected void Page_Load(object sender, EventArgs e)
    {
        if (IsPostBack == false) { 
            init();
            //stringToSHA256();
        }
    }

    public void init()
    {
        //string goodsCount = Request.QueryString["goodsCnt"].ToString();
        ordCodeNo = Request.QueryString["ordCodeNo"].AsText();
        ordStat = Request.QueryString["ordStat"].AsText();
        
        var paramList = new Dictionary<string, object> {
            {"nvar_P_SVID_USER", Svid_User }
            ,{"nvar_P_ORDERCODENO",ordCodeNo}

        };
        var list = PayService.GetPayList(paramList);

        if (list != null)
        {

            merchantKey = list[0].Pg_MidKey;            //키
            merchantID = list[0].Pg_Mid;                //ID 값
            buyerName = list[0].Name;                   //구매자명
            buyerTel = list[0].TelNo;                   //구매자 연락처
            buyerEmail = Crypt.AESDecrypt256(list[0].Email); //구매자 이메일
            ediDate = String.Format("{0:yyyyMMddHHmmss}", DateTime.Now);    //생성일시
            subjectDate = String.Format("{0:yyyy-MM-dd HH:mm:ss}", DateTime.Now);  //저장용
            encodeParameters = "Amt,CardNo,CardExpire,CardPwd";                 //암호화 할 값
            moid = list[0].OrderCodeNo;         //주문번호
            goodsName = list[0].GoodsFinalName; //상품명 외 몇개 처리
            goodsCnt = list.Count.AsInt();
            transType = "0";                    //에스크로,일반여부
            CompanyName = list[0].Company_Name;
            CompanyDeptName = list[0].CompanyDept_Name;
            Address_1 = list[0].Address_1;
            PayWay = list[0].PayWay;
            DeliveryCost = list[0].DeliveryCost; // 기본 배송비
            PowerDeliveryCost = list[0].PowerDeliveryCost; // 특수 배송비

            // 총 결제금액 계산
            for (int i = 0; i < list.Count; i++)
            {
                price += list[i].GoodsSalePricevat;
            }

            price += DeliveryCost + PowerDeliveryCost; // 총 결제금액

            goodsName = ConvertEllipsisString(goodsName, 27);

            // price = 1003;
            if (goodsCnt > 1)
            {
                goodsName = goodsName + " 외 " + (goodsCnt - 1) + "개";
            }

            // 결제방식
            switch (list[0].PayWay)
            {
                case "1":
                    PayMethod = "CARD";
                    payWayResult = "카드 결제";
                    break;
                case "2":
                    PayMethod = "BANK";
                    payWayResult = "실시간 계좌이체";
                    break;
                case "3":
                    PayMethod = "VBANK";
                    payWayResult = "가상 계좌";
                    //  TomorrowDateString(list[0].PayWay);                    
                    break;
                case "4":
                    PayMethod = "VBANK";
                    payWayResult = "후불 결제";
                    //  TomorrowDateString(list[0].PayWay);
                    break;
                case "6":
                    PayMethod = "VBANK";
                    payWayResult = "여신 결제";
                    //  TomorrowDateString(list[0].PayWay);
                    break;
                case "9":
                    PayMethod = "VBANK";
                    payWayResult = "가상 계좌";
                    //  TomorrowDateString(list[0].PayWay);
                    break;
            }

            VbankExpDate = TomorrowDateString(list[0].PayWay);

        }

        //merchantKey = "EYzu8jGGMfqaDEp76gSckuvnaHHu+bC4opsSN6lHv3b2lurNYkVXrZ7Z1AoqQnXI3eLuaUFyoRNC6FkrzVjceg==";   // 상점키
        //merchantID = "nicepay00m";                                         // 상점아이디
        //buyerName = "나이스";                                             // 구매자명
        //buyerTel = "01000000000";                                        // 구매자연락처
        //buyerEmail = "happy@day.co.kr";                                    // 구매자메일주소
        //ediDate = String.Format("{0:yyyyMMddHHmmss}", DateTime.Now);    // 해쉬암호화
        //encodeParameters = "Amt,CardNo,CardExpire,CardPwd";                      // 암호화대상항목 (변경불가)
        //moid = "mnoid1234567890";                                    // 상품주문번호   
        //price = "1004";                                               // 결제상품금액
        //goodsName = "나이스페이";                                         // 결제상품명
        //goodsCnt = "1";                                                  // 결제상품개수
        //transType = "0";                                                  // 일반(0)/에스크로(1)
    }

    public String TomorrowDateString(string checkPayway)
    {
        if (checkPayway == "3")
        {

            DateTime dt = DateTime.Now;
            DateTime tomorrow = dt.AddDays(1);
            String tomorrowString = String.Format("{0:yyyyMMdd}", tomorrow);
            return tomorrowString;
        }

        else if (checkPayway == "4")
        {
            DateTime dt = DateTime.Now;
            DateTime tomorrow = dt.AddDays(1);
            String tomorrowString = String.Format("{0:yyyyMMdd}", tomorrow);
            return tomorrowString;
        }

        else
        {
            return null;
        }

    }

    public void stringToSHA256()
    {
        SHA256Managed SHA256 = new SHA256Managed();
        String getHashString = BitConverter.ToString(SHA256.ComputeHash(Encoding.UTF8.GetBytes(ediDate + merchantID + price + merchantKey))).ToLower();

        hash_String = getHashString.Replace("-", "");
    }

    //문자열 길이 초과 시 ...표현
    public string ConvertEllipsisString(string strDest, int nMaxLength)
    {
        string strConvert;
        int nLength, n2ByteCharCount;
        byte[] arrayByte = System.Text.Encoding.Default.GetBytes(strDest);
        nLength = System.Text.Encoding.Default.GetByteCount(strDest);
        if (nLength > nMaxLength) // 글 제목이 너무 길 경우... 
        {
            n2ByteCharCount = 0;

            for (int i = 0; i < nMaxLength; i++)
            {
                if (arrayByte[i] >= 128) // 2바이트 문자 판별 
                    n2ByteCharCount++;
            }
            strConvert = strDest.Substring(0, nMaxLength - (n2ByteCharCount / 2)) + "...";
        }
        else
        {
            strConvert = strDest;
        }

        return strConvert;
    }


    protected void btnSearchId_Click(object sender, ImageClickEventArgs e)
    {
        try
        {
            var paramList = new Dictionary<string, object>
            {
                {"nvar_P_ORDERCODENO",moid},
                {"nvar_P_PG_TID",""},
                {"nvar_P_PG_MID",merchantID},
                {"nvar_P_PG_MIDKEY",merchantKey},
                {"nvar_P_PG_HASH",hash_String},
                {"nvar_P_BUYERNAME",buyerName},
                {"nvar_P_BUYERTEL",buyerTel},
                {"nvar_P_BUYEMAIL",buyerEmail},
                {"nvar_P_GOODSNAME",goodsName},
                {"nume_P_GOODSQTY",goodsCnt},
                {"nume_P_AMT",price},
                {"nvar_P_PAYWAY",PayMethod},
                {"nvar_P_PAYBANKNO",""},
                {"nvar_P_PAYCARDNO",""},
                {"nvar_P_PAYCARDCODE",""},
                {"nvar_P_PAYCARDNAME",""},
                {"nvar_P_PAYCARDSPLITDUE",""},
                {"nvar_P_ISSSUECODE",""},
                {"nvar_P_ISSSUENAME",""},
                {"nvar_P_BUYPAYCODE",""},
                {"nvar_P_BUYPAYNAME",""},
                {"nvar_P_BANKCODE",""},
                {"nvar_P_BANKNAME",""},
                {"nvar_P_VBANKCODE",""},
                {"nvar_P_VBANKNAME",""},
                {"nvar_P_VBANKNO",""},
                {"nvar_P_VBANKDATEDUETYPE",""},
                {"nvar_P_VBANKDATE",""},
                {"nvar_P_CASHBILLTYPE",""},
                {"nvar_P_CASHBILLTYPECONFIRMNO",""},
                {"nvar_P_BANKTYPENAME",""},
                {"nvar_P_PAYSUCESSYN",""},
                {"nvar_P_SUBJECTDATE", subjectDate},
                {"nvar_P_PAYCONFIRMNO",""},
                {"nvar_P_PAYRESULTCODE",""},
                {"nvar_P_PAYRESULT",""},
                {"nvar_P_PAYCONFIRMDATE",""}
            };

            PayService.PayInsert(paramList);       //파일 DB

        }
        catch (Exception ex)
        {
            logger.Error(ex, "ErrorMessage");
        }
    }
}