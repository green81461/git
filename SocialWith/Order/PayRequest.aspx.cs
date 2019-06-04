using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Security.Cryptography;
using System.Text;
using Urian.Core;
using NLog;
using NLog.Config;
using NLog.Targets;
using SocialWith.Biz.Pay;

public partial class Order_PayRequest : PageBase
{
    protected static readonly Logger logger = LogManager.GetCurrentClassLogger();

    protected string buyerName;
    protected string buyerTel;
    protected string buyerEmail;
    protected string ediDate;
    protected string editDate;
    protected string encodeParameters;
    protected string goodsName;
    protected int goodsCnt;
    protected string hash_String;
    protected decimal price;
    protected string merchantKey;
    protected string merchantID;
    protected string moid;
    protected string transType;
    protected string payMethod;             //결제수단
    protected string payMethodName;         //결제수단명
    protected string payMethodFlag;         //결제수단구분값
    protected decimal deliveryCost;         //기본배송비
    protected decimal powerDeliveryCost;    //추가배송비
    protected String vBankExpDate;          //가상계좌입금만료일

    //복합과세
    protected decimal supplyAmt;                    //공급가액
    protected decimal goodsVat;                     //부가가치세
    protected decimal serviceAmt = 0;               //봉사료
    protected decimal taxFreeAmt;                   //면세금액
    protected decimal deliveryVat;                  //기본배송비 부가세
    protected decimal deliverySupplyCost;           //기본배송비 공급가액
    protected decimal powerDeliveryVat;             //추가배송비 부가세
    protected decimal powerDeliverySupplyCost;      //추가배송비 공급가액

    //가상계좌(벌크)
    protected string vBankBankName = "신한은행";    //입금은행명
    protected string vBankBankCode = "088";         //입금은행코드
    protected string vBankNum;                      //벌크계좌번호
    protected string vBankExpTime = "235959";       //입금마감시간(HHMMSS)
    protected string vBankAccountName;              //입금예금주명

    protected string orderCodeNo = string.Empty;    //주문번호
    protected string saleComName = string.Empty;    //판매사명
    protected string companyName;                   //구매사명
    protected string companyDeptName;               //부서명
    protected string address;                       //배송지주소
    protected int totGoodsQty = 0;                      //상품 총 수량

    protected string ErrorCode = string.Empty;      //오류코드
    

    protected void Page_Load(object sender, EventArgs e)
    {
        DefaultDataBind();
        StringToSHA256();
    }

    public void DefaultDataBind()
    {
        orderCodeNo = Request.Form["ordCdNo"].AsText();     //주문번호
        //saleComName = Request.Form["saleComName"].AsText(); //판매사명

        logger.Info("전송 받은 주문번호 : " + orderCodeNo);
        //logger.Info("전송 받은 판매사명 : " + saleComName);

        PayService payService = new PayService();

        var paramList = new Dictionary<string, object> {
            {"nvar_P_SVID_USER", Svid_User },
            {"nvar_P_ORDERCODENO",orderCodeNo}
        };

        var list = payService.GetPayList(paramList);

        if((list != null) && (list.Count > 0))
        {
            payMethodFlag = list[0].PayWay; //결제수단

            merchantKey = list[0].Pg_MidKey;                    //상점키
            merchantID = list[0].Pg_Mid;                        //상점아이디
            buyerName = list[0].Name;                           //구매자명
            buyerTel = list[0].TelNo;                           //구매자 연락처
            buyerEmail = Crypt.AESDecrypt256(list[0].Email);    //구매자 이메일
            encodeParameters = "Amt,CardNo,CardExpire,CardPwd"; //암호화 할 값
            moid = list[0].OrderCodeNo;                         //주문번호
            goodsName = list[0].GoodsFinalName;                 //결제상품명
            goodsCnt = list.Count;                              //결제상품개수
            companyName = list[0].Company_Name;
            companyDeptName = list[0].CompanyDept_Name;
            address = list[0].Address_1 + " "+ list[0].Address_2;       //배송지주소
            deliveryCost = list[0].DeliveryCost;                        //기본 배송비
            powerDeliveryCost = list[0].PowerDeliveryCost;              //특수 배송비
            vBankNum = list[0].BulkBankNo;                              //벌크계좌번호
            deliveryVat = list[0].DeliveryVat;                          //기본배송비 부가세
            deliverySupplyCost = list[0].DeliverySupplyCost;            //기본배송비 공급가액
            powerDeliveryVat = list[0].PowerDeliveryVat;                //추가배송비 부가세
            powerDeliverySupplyCost = list[0].PowerDeliverySupplyCost;  //추가배송비 공급가액
            vBankAccountName = list[0].OrderSaleCompany_Name; //벌크 입금예금주명(=판매사명)

            saleComName = list[0].OrderSaleCompany_Name; //판매사명

            // 총 결제금액 계산
            for (int i = 0; i < list.Count; i++)
            {
                price += list[i].GoodsSalePricevat;
                int GoodsTaxYN = list[i].GoodsTaxYN; //과세여부(1:과세, 2:비과세)

                //과세/비과세 관련 값 설정
                if (GoodsTaxYN == 1)
                {
                    supplyAmt += list[i].GoodsSalePrice;

                    decimal tmpGoodsVat = list[i].GoodsSalePricevat - list[i].GoodsSalePrice;
                    goodsVat += tmpGoodsVat; //부가세함계
                }
                else if (GoodsTaxYN == 2)
                {
                    taxFreeAmt += list[i].GoodsSalePrice; //면세금액
                }

                totGoodsQty += list[i].Qty; //주문수량을 더해서 총수량을 얻음.
            }

            price += deliveryCost + powerDeliveryCost;                  //총 결제금액
            supplyAmt += deliverySupplyCost + powerDeliverySupplyCost;  //배송비 공급가액 추가
            goodsVat += deliveryVat + powerDeliveryVat;                 //부가세 합계에 배송비 부가세 추가
            
            //상품명 최대길이에 맞게 설정
            goodsName = ConvertEllipsisString(goodsName, 27, true);
            if (goodsCnt > 1)
            {
                goodsName = goodsName + " 외 " + (goodsCnt - 1) + "건";
            }

            logger.Info("************ 결제 요청 **********");
            logger.Info("주문번호 : " + moid);
            logger.Info("상품명   : " + goodsName);
            logger.Info("공급가액 합계       : " + supplyAmt);
            logger.Info("부가세 합계         : " + goodsVat);
            logger.Info("기본배송비 공급가액 : " + deliverySupplyCost);
            logger.Info("추가배송비 공급가액 : " + powerDeliverySupplyCost);
            logger.Info("기본배송비 부가세   : " + deliveryVat);
            logger.Info("추가배송비 부가세   : " + powerDeliveryVat);
            logger.Info("봉사료              : " + serviceAmt);
            logger.Info("면세금액 합계       : " + taxFreeAmt);

            logger.Info("총 결제금액(기존)     : " + price);
            logger.Info("총 결제금액(복합과세) : " + (supplyAmt + goodsVat + serviceAmt + taxFreeAmt));
        }

        if (String.IsNullOrWhiteSpace(orderCodeNo))
        {
            ErrorCode = "PARAM_ERROR";
            logger.Error(ErrorCode, "파라미터 부족으로 인한 오류={0}:{1}", Svid_User, orderCodeNo);

        } else
        {
            switch (payMethodFlag)
            {
                case "1":
                    payMethod = "CARD";
                    payMethodName = "카드 결제";
                    break;
                case "2":
                    payMethod = "BANK";
                    payMethodName = "실시간 계좌이체";
                    break;
                case "3":
                    payMethod = "VBANK";
                    payMethodName = "가상 계좌";
                    break;
                //case "4":
                //    payMethod = "VBANK";
                //    payMethodName = "후불 결제";
                //    break;
                case "5":
                    payMethod = "CARD_ARS";
                    payMethodName = "ARS(카드) 결제";
                    break;
                case "6":
                    payMethod = "VBANK";
                    payMethodName = "여신 결제";
                    vBankAccountName = ConvertEllipsisString(vBankAccountName, 20, false); //벌크 입금예금주명(=판매사명) -> 최대길이가 20 byte
                    break;
                case "9":
                    payMethod = "VBANK";
                    payMethodName = "후불 결제";
                    vBankAccountName = ConvertEllipsisString(vBankAccountName, 20, false); //벌크 입금예금주명(=판매사명) -> 최대길이가 20 byte
                    break;
            }

            logger.Info("입금예금주명 : "+ vBankAccountName);
            logger.Info("*************************************");

            ediDate = String.Format("{0:yyyyMMddHHmmss}", DateTime.Now);    //전문생성일시
            transType = "0";                                                // 일반(0)/에스크로(1)
            vBankExpDate = TomorrowDateString(payMethodFlag);               //가상계좌입금만료일


            //화면 출력 설정
            ltrSaleComName.Text = saleComName;  //판매사명
            ltrPayMethod.Text = payMethodName;          //결제수단명 출력
            ltrTotGoodsQty.Text = totGoodsQty.AsText() + " 개"; //주문 총 수량
            ltrGoodsName.Text = goodsName;                              //상품명
            ltrAmt.Text = price.AsDecimal().ToString("#,###") + " 원";   //결제금액
            ltrBuyerName.Text = buyerName;                              //구매자명
            //ltrMoid.Text = moid;                            //주문번호
            ltrVbankNum.Text = vBankNum;                    //벌크계좌번호
            ltrVbankBankName.Text = vBankBankName;          //입금은행명
            ltrVBankAccountName.Text = vBankAccountName;    //입금예금주명(벌크=판매사명)
            //ltrMID.Text = merchantID;                       //상점아이디
            ltrComName.Text = companyName;          //구매기관명
            ltrComDeptName.Text = companyDeptName;  //구매부서명
            ltrAddr.Text = address;                 //배송지주소
            ltrBuyerEmail.Text = buyerEmail;        //구매자이메일
        }
    }

    //문자열 길이 초과 시 ...표현
    public string ConvertEllipsisString(string strDest, int nMaxLength, bool dotYn)
    {
        string dotStr = "";
        if (dotYn) dotStr = "..."; //... 설정

        string strConvert;
        int nLength, n2ByteCharCount;
        byte[] arrayByte = System.Text.Encoding.Default.GetBytes(strDest);
        nLength = System.Text.Encoding.Default.GetByteCount(strDest);

        if (nLength > nMaxLength)
        {
            n2ByteCharCount = 0;

            for (int i = 0; i < nMaxLength; i++)
            {
                if (arrayByte[i] >= 128) // 2바이트 문자 판별 
                    ++n2ByteCharCount;
            }
            strConvert = strDest.Substring(0, (nMaxLength - Math.Ceiling((double)n2ByteCharCount / (double)2)).AsInt()) + dotStr;
        }
        else
        {
            strConvert = strDest;
        }

        return strConvert;
    }

    //결제수단에 맞게 가상계좌입금만료일 설정
    public String TomorrowDateString(string paywayFlag)
    {
        DateTime dt = DateTime.Now;
        DateTime tomorrow = dt.AddDays(7);
        String tomorrowString = String.Format("{0:yyyyMMdd}", tomorrow);
        

        if (paywayFlag.Equals("3"))
        {
            return tomorrowString;

        }
        //후불결제 & 여신결제의 경우 결제 마감기한 30일로, NICE 측과 협의 후 AddDays 수정
        //else if (paywayFlag.Equals("4") || paywayFlag.Equals("6") || paywayFlag.Equals("9"))
        else if (paywayFlag.Equals("6") || paywayFlag.Equals("9"))
        {
            tomorrow = dt.AddDays(60);
            tomorrowString = String.Format("{0:yyyyMMdd}", tomorrow);

            return tomorrowString;

        } else
        {
            return null;
        }
        
    }

    public void StringToSHA256()
    {
        SHA256Managed SHA256 = new SHA256Managed();
        String getHashString = BitConverter.ToString(SHA256.ComputeHash(Encoding.UTF8.GetBytes(ediDate + merchantID + price + merchantKey))).ToLower();

        hash_String = getHashString.Replace("-", "");
    }
}