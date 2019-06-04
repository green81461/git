using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Configuration;
using NiceLiteLibNet;
using SocialWith.Biz.Order;
using Urian.Core;

public partial class Admin_Order_OrderCardAllCancelResult : NonAuthenticationPageBase
{
    protected OrderService orderService = new OrderService();
    
    protected string LogPath;
    protected string ResultCode;
    protected string ResultMsg;
    protected string CancelDate;
    protected string CancelTime;
    protected string Tid;
    protected string PayMethod;
    protected string CancelAmt;
    protected string Flag;
    protected string statusFLAG;
    protected string Moid;
    protected string GoodsFinalCategoryCode;
    protected string SVID_USER;
    protected string GoodsGroupCode;
    protected string GoodsCode;
    protected string MID;
    //protected string GoodsQty;
    protected string OrderStatus;
    protected string GoodsFinalName;
    protected string codeNo;
    protected string uOrderNo;
    protected decimal DftDlvrCost; // 기본 배송비
    protected decimal PowerDlvrCost; // 특수 배송비
    protected string cancelFlag;
    protected string uNumOrdNoArr;
    protected int goodsCnt; //취소상품개수
    protected string resultContent; //취소결과 내용
    
    protected void Page_Load(object sender, EventArgs e)
    {

        if (!IsPostBack)
        {
            requestCancel();
        }
    }

    protected void requestCancel()
    {
        string cancelMsg = Request.Form["CancelMsg"].AsText();

        /*******************************************************
        * <취소 결과 설정>
        * 사용전 결과 옵션을 사용자 환경에 맞도록 변경하세요.
        * 로그 디렉토리는 꼭 변경하세요.
        *******************************************************/
        NiceLite lite = new NiceLite(@"CANCEL");

        LogPath = Server.MapPath(ConfigurationManager.AppSettings["NicePayLogFoler"]);
        // LogPath = @"e$\web\urian\Logs\pay";

        // string dir = @"\\210.121.204.28\e$\web\urian\UploadFile\Goods";
        //LogPath = @"D:log";                      //로그디렉토리

        string CancelPwd = "rhdrka219";

        lite.SetField(@"type", @"CANCEL");                                          //타입설정(고정)
        lite.SetField(@"LogPath", LogPath);                                         //로그폴더 설정    
        lite.SetField(@"MID", Request.Params[@"MID"]);                              //상점 아이디
        lite.SetField(@"CancelPwd", CancelPwd);                  //취소 패스워드
        lite.SetField(@"TID", Request.Params[@"TID"]);                              //TID        
        lite.SetField(@"CancelAmt", Request.Params[@"CancelAmt"]);                  //취소금액
        lite.SetField(@"CancelMsg", Request.Params[@"CancelMsg"]);                  //취소사유
        lite.SetField(@"PartialCancelCode", Request.Params[@"PartialCancelCode"]);  //부분취소여부(0:전체, 1:부분)   
        lite.SetField(@"debug", @"true");                                           //로그모드(실 서비스 "false" 로 설정) 
        lite.SetField(@"GoodsFinalCategoryCode", Request.Params[@"GoodsFinalCategoryCode"]);
        lite.SetField(@"Moid", Request.Params[@"Moid"]);
        lite.SetField(@"Svid_User", Request.Params[@"Svid_User"]);
        lite.SetField(@"GoodsGroupCode", Request.Params[@"GoodsGroupCode"]);
        lite.SetField(@"GoodsCode", Request.Params[@"GoodsCode"]);
        lite.SetField(@"OrderStatus", Request.Params[@"OrderStatus"]);
        lite.SetField(@"GoodsFinalName", Request.Params[@"GoodsFinalName"]);
        lite.SetField(@"codeNo", Request.Params[@"codeNo"]);
        lite.SetField(@"uOrderNo", Request.Params[@"uOrderNo"]);
        lite.SetField(@"DftDlvrCost", Request.Params[@"DftDlvrCost"]); // 기본 배송비
        lite.SetField(@"PowerDlvrCost", Request.Params[@"PowerDlvrCost"]); // 특수 배송비
        lite.SetField(@"Flag", Request.Params[@"Flag"]); // 특수 배송비
        lite.SetField(@"VbankInputName", Request.Params[@"VbankInputName"]);
        lite.SetField(@"vBankNum", Request.Params[@"vBankNum"]);
        lite.SetField(@"paybankName", Request.Params[@"paybankName"]);

        lite.DoPay();

        cancelFlag = Request.Params[@"cancelFlag"].AsText(); //주문취소 구분자(ALL_12:신용카드/실시간 주문전체취소)
        uNumOrdNoArr = Request.Params[@"uNumOrdNoArr"].AsText(); //신용카드/실시간 주문전체취소될 주문번호 시퀀스 묶음(,로 구분)
        goodsCnt = Request.Params[@"qty"].AsInt(); //주문전체취소 상품개수


        //lite.SetField(@"OrderCodeNo", @"OrderCodeNo");
        //lite.SetField(@"Svid_User", @"Svid_User");
        //lite.SetField(@"GoodsFinalCategoryCode", @"GoodsFinalCategoryCode");
        //lite.SetField(@"GoodsGroupCode", @"GoodsGroupCode");
        //lite.SetField(@"GoodsCode", @"GoodsCode");
        //lite.SetField(@"Pg_MID", @"Pg_MID");
        //lite.SetField(@"Qty", @"Qty");
        //lite.SetField(@"OrderStatus", @"OrderStatus");
        /*******************************************************
        * <취소 결과 필드>
        *******************************************************/
        ResultCode = lite.GetValue(@"ResultCode");                                  //결과코드 (취소성공: 2001, 취소성공(LGU 계좌이체):2211)
        ResultMsg = lite.GetValue(@"ResultMsg");                                   //결과메시지       
        CancelDate = lite.GetValue(@"CancelDate");                                  //취소일시(yyyymmdd)
        CancelTime = lite.GetValue(@"CancelTime");                                  //취소시간(hhmmss)
        Tid = lite.GetValue(@"TID");                                                //상점아이디
        PayMethod = lite.GetValue(@"PayMethod");                                   //결제방법
        CancelAmt = lite.GetValue(@"CancelAmt");                                   //취소금액
        Flag = lite.GetValue(@"Flag");
        GoodsFinalCategoryCode = lite.GetValue(@"GoodsFinalCategoryCode");  //제품넘버  
        Moid = lite.GetValue(@"Moid");  //결제취소넘버 ex) OV-171122-39    
        SVID_USER = lite.GetValue(@"SVID_USER");
        GoodsGroupCode = lite.GetValue(@"GOODSGROUPCODE");
        GoodsCode = lite.GetValue(@"GoodsCode");
        MID = lite.GetValue(@"MID");
        //GoodsQty = lite.GetValue(@"GoodsQty");
        OrderStatus = lite.GetValue(@"OrderStatus");
        GoodsFinalName = lite.GetValue(@"GoodsFinalName");
        codeNo = lite.GetValue(@"codeNo");
        uOrderNo = lite.GetValue(@"uOrderNo");


        DftDlvrCost = lite.GetValue(@"DftDlvrCost").AsDecimal(); // 기본 배송비
        PowerDlvrCost = lite.GetValue(@"PowerDlvrCost").AsDecimal(); // 특수 배송비

        string PAYSUCESSYN = "N";
        int ordStat = 422;
        string PayCancelDate = string.Empty;

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

        PayCancelDate = strNowDate + ' ' + strNowTime;

        if (ResultCode.Equals("2001") || ResultCode.Equals("2211"))
        {
            PAYSUCESSYN = "Y";
            statusFLAG = "SUCCESS";
            resultContent = "전체 주문취소 성공";

            ordStat = 422;

            
            
            var paramList = new Dictionary<string, object>
            {
                {"nvar_P_ORDERCODENO",Moid},                 //주문번호
                {"nvar_P_SVID_USER",SVID_USER},              //사용자넘버
                {"nvar_P_CANCELCONTENT",cancelMsg},          //취소사유
                {"nvar_P_UNUM_ORDERNO_ARR",uNumOrdNoArr},
                {"nume_P_CANCEL_UNUMORDNO",uOrderNo},
                {"nvar_P_PG_TID",Tid},                       //결제아이디
                {"nvar_P_PG_MID",MID},                       //상점아이디
                {"nvar_P_GOODSNAME",GoodsFinalName},         //상품이름
                {"nume_P_AMT",CancelAmt},                    //최종결제금액
                {"nume_P_GOODSQTY",goodsCnt},               //개수
                {"char_P_PAYSUCESSYN",PAYSUCESSYN},          //결제유무
                {"nvar_P_PAYCONFIRMNO",""},                  //U_Pay에 있는 데이터
                {"nvar_P_PAYRESULTCODE",ResultCode},         //결제결과코드
                {"nvar_P_PAYRESULT",ResultMsg},              //결제결과 메시지
                {"nvar_P_PAYCONFIRMDATE",PayCancelDate},     //전문생성일시
                {"reVa_P_RESULTVAL",0},               //플래그 값 성공 실패 유무
            };

            var resultVal = orderService.SaveOrderCardAllCancel(paramList);

            logger.Debug("카드 주문전체취소 프로시저 결과값 : " + resultVal);
        }
        else
        {
            PAYSUCESSYN = "N";
            statusFLAG = "FAIL";
            resultContent = "전체 주문취소 실패";
        }

        logger.Debug("카드 주문전체취소 전송값 01 : " + Moid);
        logger.Debug("카드 주문전체취소 전송값 02 : " + SVID_USER);
        logger.Debug("카드 주문전체취소 전송값 03 : " + cancelMsg);
        logger.Debug("카드 주문전체취소 전송값 04 : " + uNumOrdNoArr);
        logger.Debug("카드 주문전체취소 전송값 05 : " + uOrderNo);
        logger.Debug("카드 주문전체취소 전송값 06 : " + Tid);
        logger.Debug("카드 주문전체취소 전송값 07 : " + MID);
        logger.Debug("카드 주문전체취소 전송값 08 : " + GoodsFinalName);
        logger.Debug("카드 주문전체취소 전송값 09 : " + CancelAmt);
        logger.Debug("카드 주문전체취소 전송값 10 : " + goodsCnt);
        logger.Debug("카드 주문전체취소 전송값 11 : " + PAYSUCESSYN);
        logger.Debug("카드 주문전체취소 전송값 12 : " + "");
        logger.Debug("카드 주문전체취소 전송값 13 : " + ResultCode);
        logger.Debug("카드 주문전체취소 전송값 14 : " + ResultMsg);
        logger.Debug("카드 주문전체취소 전송값 15 : " + PayCancelDate);

        logger.Debug("카드 주문전체취소 주문번호 : " + Moid);
        logger.Debug("카드 주문전체취소 프로시저 결과 : " + statusFLAG);
        logger.Debug("카드 주문전체취소 NICE 모듈 결과코드 : " + ResultCode);
        logger.Debug("카드 주문전체취소 NICE 모듈 결과내용 : " + ResultMsg);
    }
}