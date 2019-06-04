using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using NiceLiteLibNet;
using SocialWith.Biz.Order;
using Urian.Core;

public partial class Order_OrderCancelResult : PageBase
{
    protected string LogPath;
    protected string ResultCode;
    protected string ResultMsg;
    protected string CancelDate;
    protected string CancelTime;
    protected string Tid;
    protected string Mid;
    protected string PayMethod;
    protected string CancelAmt;
    protected string SupplyAmt;
    protected string GoodsVat;
    protected string ServiceAmt;
    protected string TaxFreeAmt;
    protected string CancelPwd;
    protected string CancelMsg;
    protected string GoodsFinalCategoryCode;
    protected string GoodsGroupCode;
    protected string GoodsCode;
    protected string GoodsFinalName;

    protected string OrderStatus;
    protected string cancelFlag;
    protected string CancelCodeNo; //취소주문번호
    protected string Moid;
    protected string uNumOrdNoArr; //전체주문취소 시 주문시퀀스 모음(,구분)
    protected int uOrderNo; //주문시퀀스
    protected string GoodsCnt; //취소상품코드 개수
    protected decimal DftDlvrCost;
    protected decimal PowerDlvrCost;
    protected string PaywayFlag; //결제수단 구분값
    protected string statusFLAG;
    protected string VbankNum;
    protected string PayBankCode; //환불은행코드
    protected string VbankInputName; //환불은행 예금주명

    protected void Page_Load(object sender, EventArgs e)
    {
        if(!IsPostBack)
        {
            RequestCancel();
        }
    }

    protected void RequestCancel()
    {
        Mid = Request.Params[@"MID"].AsText();
        Tid = Request.Params[@"TID"].AsText();
        CancelAmt = Request.Params[@"CancelAmt"].AsText();
        CancelMsg = Request.Params[@"CancelMsg"].AsText();

        Moid = Request.Params[@"Moid"].AsText();
        CancelCodeNo = Request.Params[@"CancelCodeNo"].AsText();

        uOrderNo = Request.Params[@"uOrderNo"].AsInt();
        GoodsFinalCategoryCode = Request.Params[@"GoodsFinalCategoryCode"].AsText();
        GoodsGroupCode = Request.Params[@"GoodsGroupCode"].AsText();
        GoodsCode = Request.Params[@"GoodsCode"].AsText();
        GoodsFinalName = Request.Params[@"GoodsFinalName"].AsText();
        GoodsCnt = Request.Params[@"qty"].AsText();
        DftDlvrCost = Request.Params[@"DftDlvrCost"].AsDecimal();
        PowerDlvrCost = Request.Params[@"PowerDlvrCost"].AsDecimal();
        PaywayFlag = Request.Params["PaywayFlag"].AsText();
        OrderStatus = Request.Params[@"OrderStatus"].AsText();
        VbankNum = Request.Params[@"vBankNum"].AsText();
        PayBankCode = Request.Params[@"paybankName"].AsText();
        VbankInputName = Request.Params[@"VbankInputName"].AsText();
        cancelFlag = Request.Params[@"cancelFlag"].AsText(); //주문취소 구분자(ALL_12:신용카드/실시간 주문전체취소)

        /*******************************************************
        * <취소 결과 설정>
        * 사용전 결과 옵션을 사용자 환경에 맞도록 변경하세요.
        * 로그 디렉토리는 꼭 변경하세요.
        *******************************************************/
        NiceLite lite = new NiceLite(@"CANCEL");

        CancelPwd = "rhdrka219"; //NICE 취소 비밀번호
        LogPath = Server.MapPath(ConfigurationManager.AppSettings["NicePayLogFoler"]); //로그디렉토리

        lite.SetField(@"type", @"CANCEL");                                          //타입설정(고정)
        lite.SetField(@"LogPath", LogPath);                                         //로그폴더 설정    
        lite.SetField(@"MID", Mid);                              //상점 아이디
        lite.SetField(@"CancelPwd", CancelPwd);                  //취소 패스워드
        lite.SetField(@"TID", Tid);                              //TID        
        lite.SetField(@"CancelAmt", CancelAmt);                  //취소금액
        lite.SetField(@"CancelMsg", CancelMsg);                  //취소사유
        lite.SetField(@"PartialCancelCode", Request.Params[@"PartialCancelCode"]);  //부분취소여부(0:전체, 1:부분)
        
        //복합과세 정보
        lite.SetField(@"SupplyAmt", Request.Params["SupplyAmt"].AsText());       //공급가액
        lite.SetField(@"GoodsVat", Request.Params["GoodsVat"].AsText());         //부가세
        lite.SetField(@"ServiceAmt", Request.Params["ServiceAmt"].AsText());     //봉사료
        lite.SetField(@"TaxFreeAmt", Request.Params["TaxFreeAmt"].AsText());     //면세금액

        lite.SetField(@"debug", @"true");                                           //로그모드(실 서비스 "false" 로 설정)        
        lite.DoPay();

        /*******************************************************
        * <취소 결과 필드>
        *******************************************************/
        ResultCode = lite.GetValue(@"ResultCode");                                  //결과코드 (취소성공: 2001, 취소성공(LGU 계좌이체):2211)
        ResultMsg = lite.GetValue(@"ResultMsg");                                   //결과메시지       
        CancelDate = lite.GetValue(@"CancelDate");                                  //취소일시(yyymmdd)
        CancelTime = lite.GetValue(@"CancelTime");                                  //취소시간(hhmmss)
        Tid = lite.GetValue(@"TID");                                         //상점아이디
        PayMethod = lite.GetValue(@"PayMethod");                                   //결제방법
        CancelAmt = lite.GetValue(@"CancelAmt");                                   //취소금액
        SupplyAmt = lite.GetValue(@"SupplyAmt");                                   //취소 공급가액
        GoodsVat = lite.GetValue(@"GoodsVat");                                    //취소 부가세
        ServiceAmt = lite.GetValue(@"ServiceAmt");                                  //취소 봉사료
        TaxFreeAmt = lite.GetValue(@"TaxFreeAmt");                                  //취소 면세금액

        //DftDlvrCost = lite.GetValue(@"DftDlvrCost").AsDecimal();     // 기본 배송비
        //PowerDlvrCost = lite.GetValue(@"PowerDlvrCost").AsDecimal(); // 특수 배송비

        string PAYSUCESSYN = "N";
        int ordStat = 0;

        if (ResultCode.Equals("2001") || ResultCode.Equals("2211"))
        {
            PAYSUCESSYN = "Y";
            statusFLAG = "SUCCESS";

            ordStat = 422;
        }
        else
        {
            PAYSUCESSYN = "N";
            statusFLAG = "FAIL";

            switch (OrderStatus)
            {
                case "1":
                    ordStat = 400;
                    break;
                case "2":
                    ordStat = 411;
                    break;
                case "2-1":
                    ordStat = 412;
                    break;
                case "3":
                    ordStat = 421;
                    break;
            }
        }

        string strNowDate = "";
        string strNowTime = "";

        if (CancelDate.Equals("00000000") || string.IsNullOrWhiteSpace(CancelDate))
        {
            strNowDate = DateTime.Now.ToString("yyyy-MM-dd");
            strNowTime = DateTime.Now.ToString("HH:mm:ss");

        }
        else
        {
            strNowDate = DateTime.ParseExact(CancelDate, "yyyyMMdd", null).ToString("yyyy-MM-dd");
            strNowTime = DateTime.ParseExact(CancelTime, "HHmmss", null).ToString("HH:mm:ss");
        }

        string PayCancelDate = strNowDate + ' ' + strNowTime;


        logger.Debug("------------------------ 취소결과 정보 --------------------------");
        logger.Debug("CancelCodeNo : " + CancelCodeNo);
        logger.Debug("Moid : " + Moid);
        logger.Debug("SVID_USER : " + Svid_User);
        logger.Debug("GoodsFinalCategoryCode : " + GoodsFinalCategoryCode);
        logger.Debug("GoodsGroupCode : " + GoodsGroupCode);
        logger.Debug("GoodsCode : " + GoodsCode);
        logger.Debug("Tid : " + Tid);
        logger.Debug("Mid : " + Mid);
        logger.Debug("GoodsFinalName : " + GoodsFinalName);
        logger.Debug("CancelAmt : " + CancelAmt);
        logger.Debug("PAYSUCESSYN : " + PAYSUCESSYN);
        logger.Debug("ResultCode : " + ResultCode);
        logger.Debug("ResultMsg : " + ResultMsg);
        logger.Debug("PayCancelDate : " + PayCancelDate);
        logger.Debug("uOrderNo : " + uOrderNo);
        logger.Debug("DftDlvrCost : " + DftDlvrCost);
        logger.Debug("PowerDlvrCost : " + PowerDlvrCost);
        logger.Debug("ordStat : " + ordStat);
        logger.Debug("VbankNum : " + VbankNum);
        logger.Debug("PayBankCode : " + PayBankCode.AsDecimal());
        logger.Debug("VbankInputName : " + VbankInputName);
        logger.Debug("statusFLAG : " + statusFLAG);
        logger.Debug("PaywayFlag : " + PaywayFlag);
        logger.Debug("--------------------------------------------------");


        OrderService orderService = new OrderService();

        //(신용카드/실시간계좌이체)주문취소 시 5만원 미만인 경우
        if (cancelFlag.Equals("ALL_12"))
        {
            var paramList = new Dictionary<string, object>
            {
                {"nvar_P_ORDERCODENO",Moid},                //주문번호 ex) ON-171122-452
                {"nvar_P_SVID_USER",Svid_User},             //사용자넘버
                {"nvar_P_UNUM_ORDERNO_ARR",uNumOrdNoArr},
                {"nume_P_CANCEL_UNUMORDNO",uOrderNo},
                {"nvar_P_PG_TID",Tid},                      //결제아이디
                {"nvar_P_PG_MID",Mid},                      //상점아이디
                {"nvar_P_GOODSNAME",GoodsFinalName},        //상품이름
                {"nume_P_AMT",CancelAmt.AsDecimal()},       //최종결제금액
                {"nume_P_GOODSQTY",GoodsCnt},               //개수
                {"char_P_PAYSUCESSYN",PAYSUCESSYN},         //결제유무
                {"nvar_P_PAYCONFIRMNO",""},                 //U_Pay에 있는 데이터
                {"nvar_P_PAYRESULTCODE",ResultCode},        //결제결과코드
                {"nvar_P_PAYRESULT",ResultMsg},             //결제결과 메시지
                {"nvar_P_PAYCONFIRMDATE",PayCancelDate},    //전문생성일시
                {"nvar_P_FLAG",statusFLAG},                 //플래그 값 성공 실패 유무
            };

            orderService.UpdateAllOrderCancelResult(paramList);

            //일반적인 주문취소
        }
        else
        {
            var paramList = new Dictionary<string, object>
            {
                {"nvar_P_ORDERCANCELCODENO",CancelCodeNo},    //결제취소넘버 ex) JC-171122-39
                {"nvar_P_ORDERCODENO",Moid},                   //주문번호 ex) ON-171122-452
                {"nvar_P_SVID_USER",Svid_User},                //사용자넘버
                {"nvar_P_GOODSFINALCATEGORYCODE",GoodsFinalCategoryCode},  //제품넘버 
                {"nvar_P_GOODSGROUPCODE",GoodsGroupCode},      //제품그룹코드
                {"nvar_P_GOODSCODE",GoodsCode},                //상품정보
                {"nvar_P_PG_TID",Tid},                         //결제아이디
                {"nvar_P_PG_MID",Mid},                         //상점아이디
                {"nvar_P_GOODSNAME",GoodsFinalName},           //상품이름
                {"nume_P_GOODSQTY",1},                         //개수
                {"nume_P_AMT",CancelAmt.AsDecimal()},          //최종결제금액
                {"char_P_PAYSUCESSYN",PAYSUCESSYN},            //결제유무
                {"nvar_P_PAYCONFIRMNO",""},                    //U_Pay에 있는 데이터               
                {"nvar_P_PAYRESULTCODE",ResultCode},           //결제결과코드
                {"nvar_P_PAYRESULT",ResultMsg},                //결제결과 메시지
                {"nvar_P_PAYCONFIRMDATE",PayCancelDate},       //전문생성일시
                {"nume_P_UNUM_ORDERNO",uOrderNo},              //주문번호 시퀀스
                {"nume_P_DELIVERYCOST",DftDlvrCost},           //배송비
                {"nume_P_POWERDELIVERYCOST",PowerDlvrCost},    //특수배송비
                {"nume_P_ORDERSTATUS",ordStat},                //주문상태
                {"nvar_P_VBANKCANCELNO",VbankNum.AsText()},    //환불계좌
                {"nume_P_VBANKNMCANCELCODE",PayBankCode.AsDecimal()},   //환불은행명코드
                {"nvar_P_VBANKTYPECANCELNAME",VbankInputName.AsText()}, //예금주
                {"nvar_P_FLAG",statusFLAG},         //플래그 값 성공 실패 유무
                {"nvar_P_PAYWAY_FLAG",PaywayFlag}   //여기까지 끌고와야하는 값은 OrderCancel의 flag값
            };

            logger.Debug("주문취소 1건 ===================================== OrderCodeNo : " + Moid);

            orderService.UpdateOrderCancelResult(paramList);
        }
    }
}