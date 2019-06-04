using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Urian.Core;
using SocialWith.Biz.Order;
using SocialWith.Biz.Comm;

public partial class Order_OrderCancelRequest : PageBase
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

    //protected decimal GoodsSalePrice; //면세상품금액
    protected decimal SupplyAmt; //공급가액
    protected decimal GoodsVat; //부가가치세
    protected decimal ServiceAmt = 0; //봉사료
    protected decimal TaxFreeAmt; //면세금액
    //protected decimal DeliveryVat; //기본배송비 부가세
    //protected decimal DeliverySupplyCost; //기본배송비 공급가액
    //protected decimal PowerDeliveryVat; //추가배송비 부가세
    //protected decimal PowerDeliverySupplyCost; //추가배송비 공급가액
    
    protected void Page_Load(object sender, EventArgs e)
    {
        if(!IsPostBack)
        {
            DefaultDataBind();
        }
    }

    #region << 주문취소 신청할 상품 정보 조회 - 데이터 바인드 >>
    protected void DefaultDataBind()
    {
        string svid_user = Request.Form["sUser"].AsText();
        string uOdrNo = Request.Form["uOdrNo"].AsText();

        uOrderNo = uOdrNo.AsInt(); //주문취소신청한 주문번호 시퀀스

        string ordCodeNo = Request.Form["ordCodeNo"].AsText();
        Flag = Request.Form["flag"].ToString();
        cancelFlag = Request.Form["cancelFlag"].AsText(); //신용카드/실시간계좌이체 - 5만원미만으로 인한 전체 취소

        uNumOrdNoArr = string.Empty;
        //CancelPwd = "rhdrka219"; //NICE 취소 비밀번호

        //신용카드/실시간이체인 경우 주문취소 시 주문상품합계가 5만원미만이 된 경우
        if (cancelFlag.Equals("ALL_12"))
        {
            var paramList = new Dictionary<string, object> {
                { "nvar_P_ORDERCODENO", ordCodeNo }
            };

            var list = OrderService.GetOrderCancelAllList(paramList);

            if (list != null)
            {
                GoodsFinalName = ConvertEllipsisString(list[0].GoodsFinalName, 27, true);
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
        else
        {
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

            decimal[,] dlvrInfoArr = GetOrderDeliveryInfo(Svid_User, OrderCodeNo, uOrderNo, PartialCancelCode, vBankCancelCode); // 기본배송비, 특수배송비 관련
            DftDlvrCost = dlvrInfoArr[0, 0]; // 기본 배송비
            PowerDlvrCost = dlvrInfoArr[0, 1]; // 특수 배송비
            GoodsSalePriceVat = dlvrInfoArr[0, 2]; // 취소 총금액

            decimal spDefaultDlvrCost = dlvrInfoArr[1, 0];
            decimal spPowerDlvrCost = dlvrInfoArr[1, 1];
            SupplyAmt = dlvrInfoArr[1, 2]; //취소 총 공급가액

            decimal spDefaultDlvrVat = dlvrInfoArr[2, 0];
            decimal spPowerDlvrVat = dlvrInfoArr[2, 1];
            GoodsVat = dlvrInfoArr[2, 2]; //취소 총 부가세

            //화면 출력 설정
            ltrMoid.Text = OrderCodeNo;
            ltrEntryDate.Text = EntryDate;
            ltrGoodsInfo.Text = goodsinfo;
            ltrGoodsModel.Text = GoodsModel;
            ltrGoodsCnt.Text = qty;
            ltrCancelAmt.Text = GoodsSalePriceVat.ToString("#,###") + "원";

            logger.Info("************ 취소 주문건 **********");
            logger.Info("취소 주문번호 : " + OrderCodeNo);
            logger.Info("취소 공급가액 합계       : " + SupplyAmt);
            logger.Info("취소 부가세 합계         : " + GoodsVat);
            logger.Info("취소 기본배송비 공급가액 : " + spDefaultDlvrCost);
            logger.Info("취소 추가배송비 공급가액 : " + spPowerDlvrCost);
            logger.Info("취소 기본배송비 부가세   : " + spDefaultDlvrVat);
            logger.Info("취소 추가배송비 부가세   : " + spPowerDlvrVat);
            logger.Info("취소 봉사료              : " + ServiceAmt);
            logger.Info("취소 면세금액 합계       : " + TaxFreeAmt);
            logger.Info("총 취소 결제금액(기존)     : " + GoodsSalePriceVat);
            logger.Info("총 취소 결제금액(복합과세) : " + (SupplyAmt + GoodsVat + ServiceAmt + TaxFreeAmt));
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
    #endregion

    #region << 기본배송비, 특수배송지 정보 처리 >>
    protected decimal[,] GetOrderDeliveryInfo(string sUser, string ordCodeNo, int uOrderNo, string partCancelCodeVal, string vBankCancelCode)
    {
        var paramList = new Dictionary<string, object> {
            { "nvar_P_SVID_USER", sUser },
            { "nvar_P_ORDERCODENO", ordCodeNo }
        };

        var list = OrderService.GetOrderDeliveryInfoList(paramList);

        decimal selectGoodsPriceVat = 0; // 주문취소 선택한 상품 총 구매가격
        decimal totSalePriceVat = 0; // 총 상품 구매금액
        decimal totDftCostVat = 0; // 총 기본 배송비
        decimal totPowerCostVat = 0; // 총 특수 배송비
        decimal myDftCostVat = 0; // 취소 기본 배송비
        decimal myPowerCostVat = 0; // 취소 특수 배송비
        decimal remainSalePriceVat = 0; // 남은 총 구매금액(VAT포함)
        decimal cancelAmt = 0; // 취소 총금액
        int dftDlvrFlag = 0; // 기본배송비인 상품 개수

        //복합과세 관련
        decimal totSalePrice = 0; // 총 상품 공급가액
        decimal selectGoodsPrice = 0; // 주문취소 선택한 상품 총 공급가액
        decimal totDftCost = 0; // 총 기본 배송비(VAT별도)
        decimal totDftVat = 0; // 총 기본 배송비 VAT
        decimal totPowerCost = 0; // 총 특수 배송비(VAT별도)
        decimal totPowerVat = 0; // 총 특수 배송비 VAT
        decimal myDftCost = 0; // 취소 기본 배송비(VAT별도)
        decimal myDftVat = 0; // 취소 기본 배송비 VAT
        decimal myPowerCost = 0; // 취소 특수 배송비(VAT별도)
        decimal myPowerVat = 0; // 취소 특수 배송비 VAT
        decimal remainSalePrice = 0; // 남은 총 구매금액(VAT별도)
        decimal cancelSupplyAmt = 0; // 취소 총 공급가액(VAT별도)
        decimal cancelVat = 0; // 취소 총 VAT


        if ((list != null) && (list.Count() > 0))
        {
            for (int i = 0; i < list.Count; i++)
            {
                totSalePriceVat += list[i].GoodsSalePriceVat;

                totSalePrice += list[i].GoodsSalePrice; //총 상품 공급가액
                int GoodsTaxYN = list[i].GoodsTaxYN; //과세여부(1:과세, 2:비과세)

                if ((vBankCancelCode.Equals("")) || (partCancelCodeVal.Equals("1")))
                {
                    // 취소 선택한 상품 구매금액, 기본 배송비 or 특수 배송비
                    if (uOrderNo == list[i].Unum_OrderNo)
                    {
                        selectGoodsPriceVat = list[i].GoodsSalePriceVat;

                        //과세/비과세 관련 값 설정
                        if (GoodsTaxYN == 1)
                        {
                            selectGoodsPrice += list[i].GoodsSalePrice;

                            decimal tmpGoodsVat = list[i].GoodsSalePriceVat - list[i].GoodsSalePrice;
                            GoodsVat += tmpGoodsVat; //부가세함계
                        }
                        else if (GoodsTaxYN == 2)
                        {
                            TaxFreeAmt += list[i].GoodsSalePrice; //면세금액
                        }

                        // 기본 배송비
                        if (list[i].DeliveryCostGubun == 2)
                        {
                            myDftCostVat = list[i].Default_DeliveryCost;

                            myDftCost = list[i].DeliverySupplyCost; //기본배송비 공급가액
                            myDftVat = list[i].DeliveryVat; //기본배송비 부가세

                            // 특수 배송비
                        }
                        else if (list[i].DeliveryCostGubun == 3)
                        {
                            myPowerCostVat = list[i].Power_DeliveryCost;

                            myPowerCost = list[i].PowerDeliverySupplyCost; //추가배송비 공급가액
                            myPowerVat = list[i].PowerDeliveryVat; //추가배송비 부가세

                        }
                    }
                }

                // 기본 배송비(금액은 누적X)
                if (list[i].DeliveryCostGubun == 2)
                {
                    totDftCostVat = list[i].Default_DeliveryCost;

                    totDftCost = list[i].DeliverySupplyCost; //기본배송비 공급가액
                    totDftVat = list[i].DeliveryVat; //기본배송비 부가세

                    ++dftDlvrFlag;

                    // 특수 배송비 누적
                }
                else if (list[i].DeliveryCostGubun == 3)
                {
                    totPowerCostVat += list[i].Power_DeliveryCost;

                    totPowerCost += list[i].PowerDeliverySupplyCost; //추가배송비 공급가액
                    totPowerVat += list[i].PowerDeliveryVat; //추가배송비 부가세
                }
            }

            remainSalePriceVat = totSalePriceVat - selectGoodsPriceVat; // 남은 총 구매금액

            //남은 총 상품 공급가액
            remainSalePrice = totSalePrice - selectGoodsPrice;

            // 부분취소이고 남은 구매금액이 5만원 미만이면 기본 배송비는 환불 안 함.
            // 전체 취소인 경우
            if ((!vBankCancelCode.Equals("ALL")) && (list.Count == 1))
            {
                totDftCostVat = 0;
                totPowerCostVat = 0;

                totDftCost = 0;
                totDftVat = 0;
            }
            // 부분취소인 경우
            else
            {
                if (dftDlvrFlag == 1)
                {
                    totDftCostVat = totDftCostVat - myDftCostVat;

                    totDftCost = totDftCost - myDftCost;
                    totDftVat = totDftVat - myDftVat;
                }
                else
                {
                    if (dftDlvrFlag > 1)
                    {
                        myDftCostVat = 0;

                        myDftCost = 0;
                        myDftVat = 0;
                    }
                }

                totPowerCostVat = totPowerCostVat - myPowerCostVat;

                totPowerCost = totPowerCost - myPowerCost;
                totPowerVat = totPowerVat - myPowerVat;

                if (remainSalePriceVat >= 50000)
                {
                    totDftCostVat = 0;

                    totPowerCost = 0;
                    totPowerVat = 0;
                }
            }

            // 원래 총 구매금액이 5만원 이상이었던 경우
            if (totSalePriceVat >= 50000)
            {
                myDftCostVat = 0;

                myDftCost = 0;
                myDftVat = 0;
            }

            cancelAmt = selectGoodsPriceVat + myDftCostVat + myPowerCostVat;

            cancelSupplyAmt = selectGoodsPrice + myDftCost + myPowerCost; //취소 금액(VAT 별도)
            cancelVat = (selectGoodsPriceVat - selectGoodsPrice - TaxFreeAmt) + myDftVat + myPowerVat; //취소 VAT

            if ((vBankCancelCode.Equals("ALL")) && (partCancelCodeVal.Equals("0")))
            {
                cancelAmt = totSalePriceVat + totDftCostVat + totPowerCostVat;

                cancelSupplyAmt = totSalePrice + totDftCost + totPowerCost;
                cancelVat = (totSalePriceVat - totSalePrice - TaxFreeAmt) + totDftVat + totPowerVat; //취소 VAT
            }
        }

        decimal[,] returnValArr = new decimal[3, 3] {
            { totDftCostVat, totPowerCostVat, cancelAmt },  //부가세포함한 금액
            { totDftCost, totPowerCost, cancelSupplyAmt },  //공급가액
            { totDftVat, totPowerVat, cancelVat }           //부가세
        }; // 반환값 (기본배송비, 특수배송비, 취소 총금액)

        return returnValArr;
    }
    #endregion
}