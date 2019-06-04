using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using NiceLiteLibNet;
using Urian.Core;
using SocialWith.Biz.Order;
using SocialWith.Biz.Comm;


public partial class Admin_Order_OrderCardAllCancelRequest : AdminPageBase
{
    OrderService OrderService = new OrderService();
    CommService commService = new CommService();

    protected int uOrderNo;
    protected int Unum_OrderUpNo;
    protected string OrderCodeNo;
    protected string GoodsFinalCategoryCode;
    protected string GoodsGroupCode;
    protected string GoodsCode;
    protected string Svid_User;
    protected int Qty;
    protected int OrderStatus;
    protected string OrderStatus_NAME;
    protected decimal GoodsSalePriceVat;
    protected string EntryDate;
    protected string GoodsFinalName;
    protected string GoodsOptionSummaryCode;
    protected string GoodsOptionSummaryValues;
    protected string BrandCode;
    protected string BrandName;
    protected string GoodsModel;
    protected string GoodsUnit;
    protected string GoodsUnit_Name;
    protected string OrderCancel;
    protected string OrderFinish;
    protected string OrderChangeStatus;
    protected string OrderReturnStatus;
    protected string Pg_TID;
    protected string Pg_MID;
    protected string goodsinfo;
    protected string qty;
    protected string CancelPwd;
    protected string OrderCancelStatus;
    protected string PAYCONFIRMNO;
    protected string Flag;


    protected decimal DftDlvrCost; // 기본 배송비
    protected decimal PowerDlvrCost; // 특수 배송비
    protected string Payway; // 결제방식
    protected string ordStat_type; // 상태코드 구분값(가상계좌:2, 나머지:1)

    protected string PartialCancelCode;
    protected int GoodsQty;

    protected string CancelMsg;
    protected string uNumOrdNoArr; //주문취소할 주문번호 시퀀스 묶음
    protected string cancelFlag; //(구분자)신용카드/실시간계좌이체 - 5만원미만으로 인한 전체 취소
    protected string PayMethod;
    protected string payWayResult;

    protected void Page_Load(object sender, EventArgs e)
    {
        if(!IsPostBack)
        {
            DefaultDataBind();
        }
    }

    #region << 주문취소 신청할 상품 정보 조회 - 데이터 바인드 >>
    public void DefaultDataBind()
    {
        string svid_user = Request.Form["sUser"].AsText();
        string uOdrNo = Request.Form["uOdrNo"].AsText();

        uOrderNo = uOdrNo.AsInt(); //취소 선택한 상품의 주문시퀀스

        string ordCodeNo = Request.Form["ordCodeNo"].AsText();
        Flag = Request.Form["flag"].AsText();

        logger.Debug("카드전체취소 주문번호     : "+ ordCodeNo);
        logger.Debug("카드전체취소 선택한 주문시퀀스 : " + uOdrNo);
        logger.Debug("카드전체취소 사용자시퀀스 : " + svid_user);

        var paramList = new Dictionary<string, object> {
            { "nvar_P_ORDERCODENO", ordCodeNo }
        };

        var list = OrderService.GetOrderCancelAllList(paramList);

        if (list != null)
        {

            GoodsFinalName = ConvertEllipsisString(list[0].GoodsFinalName, 27);
            goodsinfo = GoodsFinalName + " 외 " + (list.Count - 1) + "건";
            GoodsFinalName = goodsinfo;


            OrderCodeNo = list[0].OrderCodeNo;
            Svid_User = list[0].Svid_User;
            GoodsSalePriceVat = list[0].Remain_Amt;
            EntryDate = list[0].EntryDate.AsText();
            Pg_TID = list[0].Pg_TID;
            Pg_MID = list[0].Pg_MID;
            Payway = list[0].PayWay;
            Qty = list.Count;
            qty = Qty + " 개 상품";

            GoodsModel = string.Empty;

            int cancelOrderCnt = list[0].CancelOrderCnt;

            //기존 주문취소상품 있는지 여부에 따라 처리
            if (cancelOrderCnt > 0)
            {
                PartialCancelCode = "1"; //부분취소
            }
            else
            {
                PartialCancelCode = "0"; //전체취소
            }


            for (int i = 0; i < list.Count; i++)
            {
                string uNumNo = list[i].Unum_OrderNo.AsText();
                uNumOrdNoArr += uNumNo + ",";
            }

            uNumOrdNoArr = uNumOrdNoArr.Substring(0, (uNumOrdNoArr.Length - 1));
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
    #endregion


}