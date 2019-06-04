using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using SocialWith.Biz.Pay;
using Urian.Core;
using System.Security.Cryptography;

public partial class OrderNoPassbookRequest : PageBase
{
    protected string GoodsName;
    protected string OrderCodeNo;
    protected string BuyerName;
    protected decimal Amt;
    protected string SaleComName;
    protected string BuyerTel;
    protected string BuyerEmail;
    protected decimal DeliveryCost;
    protected decimal PowerDeliveryCost;
    protected string Payway;
    protected int GoodsCnt = 0;
    protected string SubjectDate;
    protected string RoleFlag; //구매사 주문 유형(A/B/C/BC) 구분값(TYPE_1/TYPE_2/TYPE_3/TYPE_4)
    protected string UrianType; //구매사 주문 유형(B/C/BC) 관련 설정값
    protected string UrianTypeUnumNo; //구매사 주문 유형(B/C/BC) 관련 설정값
    protected string BuyerComName; //구매사명
    

    protected void Page_Load(object sender, EventArgs e)
    {
        if(!IsPostBack)
        {
            DefaultDataBind();
        }
    }

    #region << 데이터 바인딩 >>
    protected void DefaultDataBind()
    {
        OrderCodeNo = Request.Form["orderNo"].AsText(); //주문번호
        SaleComName = Request.Form["SaleComName"].AsText(); //판매사명
        RoleFlag = Request.Form["RoleFlag"].AsText(); //구매사 주문 유형
        UrianType = Request.Form["Type"].AsText();
        UrianTypeUnumNo = Request.Form["TypeUnumNo"].AsText();


        PayService payService = new PayService();

        var paramList = new Dictionary<string, object> {
            {"nvar_P_SVID_USER", Svid_User }
            ,{"nvar_P_ORDERCODENO",OrderCodeNo}

        };
        var list = payService.GetPayList(paramList);

        if ((list != null) && (list.Count > 0))
        {
            GoodsCnt = list.Count;

            OrderCodeNo = list[0].OrderCodeNo;
            GoodsName = list[0].GoodsFinalName;
            BuyerName = list[0].Name;
            BuyerTel = list[0].TelNo;
            BuyerEmail = Crypt.AESDecrypt256(list[0].Email);
            DeliveryCost = list[0].DeliveryCost; // 기본 배송비
            PowerDeliveryCost = list[0].PowerDeliveryCost; // 특수 배송비
            Payway = list[0].PayWay;
            SubjectDate = String.Format("{0:yyyy-MM-dd HH:mm:ss}", DateTime.Now);
            BuyerComName = list[0].Company_Name;

            GoodsName = ConvertEllipsisString(GoodsName, 27);

            if (GoodsCnt > 1)
            {
                GoodsName = GoodsName + " 외 " + (GoodsCnt - 1) + "건";
            }

            // 총 결제금액 계산
            for (int i = 0; i < list.Count; i++)
            {
                Amt += list[i].GoodsSalePricevat;
            }

            Amt += DeliveryCost + PowerDeliveryCost; //총 결제금액
        }

        logger.Debug("*********** 무통장입금 주문내역 ***********");
        logger.Debug("OrderCodeNo : "+ OrderCodeNo);
        logger.Debug("GoodsName : " + GoodsName);
        logger.Debug("Amt : " + Amt);
        logger.Debug("BuyerName : " + BuyerName);
        logger.Debug("BuyerComName : " + BuyerComName);
        logger.Debug("SaleComName : " + SaleComName);
        logger.Debug("RoleFlag : " + RoleFlag);
        logger.Debug("*******************************************");
    }
    #endregion

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
    
}