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

public partial class Order_OrderRequest_Bill : PageBase
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
    protected decimal Amt;
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
    protected String OrderSaleCompany_Code;
    protected String BulkBankNo;
    protected String TypeUnumNo;
    protected String Type;
    protected String RoleFlag;

    protected String Unum_PayNo;


    protected String SaleComName;  //판매업체이름
    protected String Company_Code;  //구매사코드
    
    protected void Page_Load(object sender, EventArgs e)
    {
        init();
        stringToSHA256();
    }

    public void init()
    {
        //string goodsCount = Request.QueryString["goodsCnt"].AsText();
        //string orderNo = Request.QueryString["orderNo"].AsText();

        Unum_PayNo = Request.Form["hdUnumPayNo"].AsText();
        Company_Code = Request.Form["hdCompanyCode"].AsText();
       


        SaleComName = Request.Form["SaleComName"].AsText();

        Type = Request.Form["Type"].AsText();
        TypeUnumNo = Request.Form["TypeUnumNo"].AsText();
        RoleFlag = Request.Form["RoleFlag"].AsText();

        var paramList = new Dictionary<string, object> {
            {"nvar_P_SVID_USER", Svid_User }
            ,{"nvar_P_COMPANY_CODE",Company_Code}
            ,{"nume_P_UNUM_PAYNO",Unum_PayNo}

        };
        var list = PayService.Payinfo_MonthOrder(paramList);

        if (list != null)
        {
            Amt = list[0].SaleAmt;
            merchantKey = list[0].Pg_MidKey;            //키
            merchantID = list[0].Pg_Mid;                //ID 값
            buyerName = list[0].Name;                   //구매자명
            buyerTel = list[0].TelNo;                   //구매자 연락처
            buyerEmail = Crypt.AESDecrypt256(list[0].Email); //구매자 이메일
            ediDate = String.Format("{0:yyyyMMddHHmmss}", DateTime.Now);    //생성일시
            subjectDate = String.Format("{0:yyyy-MM-dd HH:mm:ss}", DateTime.Now);  //저장용
            encodeParameters = "Amt,CardNo,CardExpire,CardPwd";                 //암호화 할 값
            moid = list[0].OrderCodeNo;         //주문번호
            goodsName = list[0].GoodsName; //상품명 외 몇개 처리
            goodsCnt = list.Count.AsInt();
            transType = "0";                    //에스크로,일반여부
            CompanyName = list[0].Company_Name;
            CompanyDeptName = list[0].CompanyDept_Name;
            Address_1 = list[0].Address_1;
            PayWay = list[0].PayWay;
            DeliveryCost = list[0].DeliveryCost; // 기본 배송비
            PowerDeliveryCost = list[0].PowerDeliveryCost; // 특수 배송비
            BulkBankNo = list[0].BulkBankNo;




    

            price = Amt;

            goodsName = ConvertEllipsisString(goodsName, 27);

            if (goodsCnt > 1)
            {
                goodsName = goodsName + " 외 " + (goodsCnt - 1) + "건";
            }

            logger.Debug("최종 상품명 길이 : " + Encoding.Default.GetByteCount(goodsName));
            logger.Debug("최종 상품명 : " + goodsName);

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
                case "5":
                    PayMethod = "CARD_ARS";
                    payWayResult = "ARS 결제";
                    buyerTel = "";
                    break;

                case "6":
                    PayMethod = "VBANK";
                    //payWayResult = "여신 결제(일반)";
                    payWayResult = "여신 결제";
                    break;

                case "8":
                    PayMethod = "VBANK";
                    //payWayResult = "여신 결제(일반)";
                    payWayResult = "여신 결제";
                    break;
            }

            VbankExpDate = TomorrowDateString(list[0].PayWay);

        }

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

    //가상계좌 입금 만료일 체크
    public String TomorrowDateString(string checkPayway)
    {
        if (checkPayway == "3")
        {

            DateTime dt = DateTime.Now;
            DateTime tomorrow = dt.AddDays(7);
            String tomorrowString = String.Format("{0:yyyyMMdd}", tomorrow);
            return tomorrowString;
        }
        //후불결제 & 여신결제의 경우 결제 마감기한 30일로, NICE 측과 협의 후 AddDays 수정

        else if (checkPayway == "4" || checkPayway == "6" || checkPayway == "9")
        {
            DateTime dt = DateTime.Now;
            DateTime tomorrow = dt.AddDays(60);
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
                {"nvar_P_PAYCONFIRMDATE",""},
                {"nvar_P_YYYY",""},
                {"nvar_P_MM",""},
                {"nvar_P_DD",""},
                {"nvar_P_GoodsFinalCateGoryCode",""},
                {"nvar_P_GoodsGroupCode",""},
                {"nvar_P_GoodsCode",""},
                {"nvar_P_GoodsBuyPriceVat",""},
                {"nvar_P_GoodsSalePriceVat",""},
                {"nvar_P_GoodsCustPriceVat",""},
                {"nvarP_Etc1","1"},
                {"nvar_P_Etc2","2"},
                {"nvar_P_Etc3","3"},
                {"nvar_P_Etc4","4"},
                {"nvar_P_Etc5","5"},
                {"nvar_P_Etc6","6"},
                {"nvar_P_Etc7","7"},
                {"nvar_P_Etc8","8"},
                {"nvar_P_Etc9","9"},
                {"nvar_P_Etc10","10"},
                {"nvar_P_DELFLAG",""}
            };

            PayService.PayInsert(paramList);       //파일 DB

        }
        catch (Exception ex)
        {
            logger.Error(ex, "ErrorMessage");
        }
    }
}