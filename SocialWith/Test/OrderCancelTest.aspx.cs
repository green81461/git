using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Urian.Core;
using System.Collections;
using System.Configuration;
using System.Data;
using System.Web.Security;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls.WebParts;
using System.Security.Cryptography;
using System.Text;
using NiceLiteLibNet;
using SocialWith.Biz.Order;
using SocialWith.Biz.Comm;

public partial class Test_OrderCancelTest : NonAuthenticationPageBase
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

    protected void Page_Load(object sender, EventArgs e)
    {
        init();
    }

    #region << 주문취소 신청할 상품 정보 조회 - 데이터 바인드 >>
    public void init()
    {
        string svid_user = Request.QueryString["sUser"].ToString(); //Get
        string uOdrNo = Request.QueryString["uOdrNo"].ToString(); //Get3

        string ordCodeNo = Request.QueryString["ordCodeNo"].ToString(); //Get
        Flag = Request.QueryString["flag"].ToString(); //Get     CancelResult



        var paramList = new Dictionary<string, object> {
            { "nvar_P_SVID_USER", svid_user },
            { "nume_P_UNUM_ORDERNO", uOdrNo.AsInt() }

        };

        string vBankCancelCode = ""; // 가상계좌(후불 포함)일 경우 전체취소구분자

        var info = OrderService.GetOrderHistoryInfo(paramList);

        if (info != null)
        {
            uOrderNo = info.Unum_OrderNo.AsInt();
            Unum_OrderUpNo = info.Unum_OrderUpNo.AsInt();
            OrderCodeNo = info.OrderCodeNo.AsText();
            GoodsFinalCategoryCode = info.GoodsFinalCategoryCode.AsText();
            GoodsGroupCode = info.GoodsGroupCode.AsText();
            GoodsCode = info.GoodsCode.AsText();
            Svid_User = info.Svid_User.AsText();
            Qty = info.Qty.AsInt();
            OrderStatus = info.OrderStatus.AsInt();
            OrderStatus_NAME = info.OrderStatus_NAME.AsText();
            GoodsSalePriceVat = info.GoodsSalePriceVat.AsDecimal();
            EntryDate = info.EntryDate.AsText();
            GoodsFinalName = info.GoodsFinalName.AsText();
            GoodsOptionSummaryCode = info.GoodsOptionSummaryCode.AsText();
            GoodsOptionSummaryValues = info.GoodsOptionSummaryValues.AsText();
            BrandCode = info.BrandCode.AsText();
            BrandName = info.BrandName.AsText();
            GoodsModel = info.GoodsModel.AsText();
            GoodsUnit = info.GoodsUnit.AsText();
            GoodsUnit_Name = info.GoodsUnit_Name.AsText();
            OrderCancel = info.OrderCancel.AsText();
            OrderFinish = info.OrderFinish.AsText();
            OrderChangeStatus = info.OrderChangeStatus.AsText();
            OrderReturnStatus = info.OrderReturnStatus.AsText();
            Pg_TID = info.Pg_TID.AsText();
            Pg_MID = info.Pg_MID.AsText();
            Payway = info.PayWay;



            GoodsQty = info.GoodsQty.AsInt();

            if (GoodsQty == 1)
            {
                PartialCancelCode = "0";   //전체취소
            }
            else
            {
                PartialCancelCode = "1";    //부분취소
            }

            if (Flag == "VBANK")
            {
                PartialCancelCode = "0";
                vBankCancelCode = "ALL";
            }
        }

        goodsinfo = BrandName + GoodsFinalName + GoodsOptionSummaryValues;
        qty = Qty + GoodsUnit_Name;
        CancelPwd = "123456";

        CancelMsg = "";
        OrderCancelStatus = "1";



        // 결제방식에 따라 상태타입 다르게 적용(가상계좌:2, 나머지:1 => Handler 에서 숫자에 따라 상태코드 다르게 적용할 것 임.)
        if (Payway.Equals("3") || Payway.Equals("4"))
        {
            if ((OrderStatus == 100) || (OrderStatus == 412))
            {
                ordStat_type = "2-1";
                OrderCancelStatus = "2-1";

            }
            else
            {
                ordStat_type = "2";
                OrderCancelStatus = "2";
            }

            vbankPanel.Visible = true;
        }
        else
        {
            ordStat_type = "1";
            OrderCancelStatus = "1";
        }

        decimal[] dlvrInfoArr = GetOrderDeliveryInfo(Svid_User, OrderCodeNo, uOrderNo, PartialCancelCode, vBankCancelCode); // 기본배송비, 특수배송비 관련
        DftDlvrCost = dlvrInfoArr[0]; // 기본 배송비
        PowerDlvrCost = dlvrInfoArr[1]; // 특수 배송비
        GoodsSalePriceVat = dlvrInfoArr[2]; // 취소 총금액
        //GoodsSalePriceVat = 523270;
    }
    #endregion



    //protected void PayWayDataBind()
    //{
    //    var paramList = new Dictionary<string, object>
    //    {
    //        { "nvar_P_MAPCODE", "PAY"},
    //        { "nume_P_MAPCHANEL", 2},
    //    };

    //    var list = commService.GetCommList(paramList);


    //    if (list.Count > 0)
    //    {
    //        foreach (var item in list)
    //        {
    //            if (item.Map_Type != 0)
    //            {
    //                paybankName.Items.Add(new ListItem(item.Map_Name, item.Map_Type.AsText()));
    //            }
    //        }
    //    }
    //}

    #region << 기본배송비, 특수배송지 정보 처리 >>
    protected decimal[] GetOrderDeliveryInfo(string sUser, string ordCodeNo, int uOrderNo, string partCancelCodeVal, string vBankCancelCode)
    {
        var paramList = new Dictionary<string, object> {
            { "nvar_P_SVID_USER", sUser },
            { "nvar_P_ORDERCODENO", ordCodeNo }
        };

        var list = OrderService.GetOrderDeliveryInfoList(paramList);

        decimal selectGoodsPrice = 0; // 주문취소 선택한 상품 총 구매가격
        decimal totSalePrice = 0; // 총 상품 구매금액
        decimal totDftCost = 0; // 총 기본 배송비
        decimal totPowerCost = 0; // 총 특수 배송비
        decimal myDftCost = 0; // 취소 기본 배송비
        decimal myPowerCost = 0; // 취소 특수 배송비
        decimal remainSalePrice = 0; // 남은 총 구매금액
        decimal cancelAmt = 0; // 취소 총금액
        int dftDlvrFlag = 0; // 기본배송비인 상품 개수

        if (list != null)
        {
            for (int i = 0; i < list.Count; i++)
            {
                totSalePrice += list[i].GoodsSalePriceVat;

                if ((vBankCancelCode.Equals("")) || (partCancelCodeVal.Equals("1")))
                {
                    // 취소 선택한 상품 구매금액, 기본 배송비 or 특수 배송비
                    if (uOrderNo == list[i].Unum_OrderNo)
                    {
                        selectGoodsPrice = list[i].GoodsSalePriceVat;

                        // 기본 배송비
                        if (list[i].DeliveryCostGubun == 2)
                        {
                            myDftCost = list[i].Default_DeliveryCost;

                            // 특수 배송비
                        }
                        else if (list[i].DeliveryCostGubun == 3)
                        {
                            myPowerCost = list[i].Power_DeliveryCost;
                        }
                    }
                }

                // 기본 배송비(금액은 누적X)
                if (list[i].DeliveryCostGubun == 2)
                {
                    totDftCost = list[i].Default_DeliveryCost;
                    ++dftDlvrFlag;

                    // 특수 배송비 누적
                }
                else if (list[i].DeliveryCostGubun == 3)
                {
                    totPowerCost += list[i].Power_DeliveryCost;
                }
            }

            remainSalePrice = totSalePrice - selectGoodsPrice; // 남은 총 구매금액

            // 부분취소이고 남은 구매금액이 5만원 미만이면 기본 배송비는 환불 안 함.
            // 전체 취소인 경우
            if ((!vBankCancelCode.Equals("ALL")) && (list.Count == 1))
            {
                totDftCost = 0;
                totPowerCost = 0;
            }
            // 부분취소인 경우
            else
            {
                if (dftDlvrFlag == 1)
                {
                    totDftCost = totDftCost - myDftCost;
                }
                else
                {
                    if (dftDlvrFlag > 1)
                    {
                        myDftCost = 0;
                    }
                }

                totPowerCost = totPowerCost - myPowerCost;

                if (remainSalePrice >= 50000)
                {
                    totDftCost = 0;
                }
            }

            // 원래 총 구매금액이 5만원 이상이었던 경우
            if (totSalePrice >= 50000)
            {
                myDftCost = 0;
            }

            cancelAmt = selectGoodsPrice + myDftCost + myPowerCost;

            if ((vBankCancelCode.Equals("ALL")) && (partCancelCodeVal.Equals("0")))
            {
                cancelAmt = totSalePrice + totDftCost + totPowerCost;
            }
        }

        decimal[] returnValArr = new decimal[] { totDftCost, totPowerCost, cancelAmt }; // 반환값 (기본배송비, 특수배송비, 취소 총금액)

        return returnValArr;
    }
    #endregion
}