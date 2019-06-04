using System;
using System.Data;
using System.Configuration;
using System.Collections;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using NiceLiteLibNet;
using System.Collections.Specialized;
using SocialWith.Biz.Order;
using System.Security.Cryptography;
using System.Text;
using System.Collections.Generic;
using Urian.Core;
using System.Globalization;

public partial class Test_OrderCancelResultTest : NonAuthenticationPageBase
{
    OrderService OrderService = new OrderService();


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

    protected string VbankInputName;  //예금주명
    protected string vBankNum;  //환불계좌명
    protected string paybankName;  //환불은행명


    protected decimal DftDlvrCost; // 기본 배송비
    protected decimal PowerDlvrCost; // 특수 배송비

    protected void Page_Load(object sender, EventArgs e)
    {

        if (!Page.IsPostBack)
        {
            requestCancel();
        }
    }

    protected void requestCancel()
    {
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

        lite.SetField(@"type", @"CANCEL");                                          //타입설정(고정)
        lite.SetField(@"LogPath", LogPath);                                         //로그폴더 설정    
        lite.SetField(@"MID", Request.Params[@"MID"]);                              //상점 아이디
        lite.SetField(@"CancelPwd", Request.Params[@"CancelPwd"]);                  //취소 패스워드
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
        //lite.SetField(@"MID", Request.Params[@"MID"]);
        //lite.SetField(@"GoodsQty", Request.Params[@"GoodsQty"]);
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
        Moid = lite.GetValue(@"Moid");  //결제취소넘버 ex) JC-171122-39    
        SVID_USER = lite.GetValue(@"SVID_USER");
        GoodsGroupCode = lite.GetValue(@"GOODSGROUPCODE");
        GoodsCode = lite.GetValue(@"GoodsCode");
        MID = lite.GetValue(@"MID");
        //GoodsQty = lite.GetValue(@"GoodsQty");
        OrderStatus = lite.GetValue(@"OrderStatus");
        GoodsFinalName = lite.GetValue(@"GoodsFinalName");
        codeNo = lite.GetValue(@"codeNo");

        uOrderNo = lite.GetValue(@"uOrderNo");


        VbankInputName = lite.GetValue(@"VbankInputName");
        vBankNum = lite.GetValue(@"vBankNum");
        paybankName = lite.GetValue(@"paybankName");

        int payBankCode = -1; // 결제취소 시 환불 받을 계좌 은행코드

        if (!string.IsNullOrWhiteSpace(paybankName))
            payBankCode = paybankName.AsInt();

        //dd

        DftDlvrCost = lite.GetValue(@"DftDlvrCost").AsDecimal(); // 기본 배송비
        PowerDlvrCost = lite.GetValue(@"PowerDlvrCost").AsDecimal(); // 특수 배송비

        string PAYSUCESSYN = "N";
        int ordStat = 0;

        if (ResultCode == "2001" || ResultCode == "2211")
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

        //string aa = DateTime.ParseExact(CancelDate, "yyyyMMdd", null).ToString("yyyy-MM-dd");
        //string bb = DateTime.ParseExact(CancelTime, "HHmmss", null).ToString("HH:mm:ss");


        //string PayCancelDate = aa + ' ' + bb;
        string PayCancelDate = strNowDate + ' ' + strNowTime;


        var service = new OrderService();

        var paramList = new Dictionary<string, object>
          {  {"nvar_P_ORDERCANCELCODENO",codeNo},           //결제취소넘버 ex) JC-171122-39         
             {"nvar_P_ORDERCODENO",Moid},                   //주문번호 ex) JA-171122-452
             {"nvar_P_SVID_USER",SVID_USER},                //사용자넘버
             {"nvar_P_GOODSFINALCATEGORYCODE",GoodsFinalCategoryCode},  //제품넘버 
             {"nvar_P_GOODSGROUPCODE",GoodsGroupCode},      //제품그룹코드
             {"nvar_P_GOODSCODE",GoodsCode},                //상품정보
             {"nvar_P_PG_TID",Tid},                       //결제아이디
             {"nvar_P_PG_MID",MID},                         //상점아이디
             {"nvar_P_GOODSNAME",GoodsFinalName},           //상품이름
             {"nume_P_GOODSQTY",1},                         //개수
             {"nume_P_AMT",CancelAmt},                      //최종결제금액
             {"char_P_PAYSUCESSYN",PAYSUCESSYN},            //결제유무
             {"nvar_P_PAYCONFIRMNO",""},                    //U_Pay에 있는 데이터               
             {"nvar_P_PAYRESULTCODE",ResultCode},           //결제결과코드
             {"nvar_P_PAYRESULT",ResultMsg},                //결제결과 메시지
             {"nvar_P_PAYCONFIRMDATE",PayCancelDate},       //전문생성일시
             {"nume_P_UNUM_ORDERNO",uOrderNo},              //주문번호 시퀀스
             {"nume_P_DELIVERYCOST",DftDlvrCost},           //배송비
             {"nume_P_POWERDELIVERYCOST",PowerDlvrCost},    //특수배송비
             {"nume_P_ORDERSTATUS",ordStat},            //주문상태
             {"nvar_P_VBANKCANCELNO",vBankNum.AsText()},        //환불계좌
             {"nume_P_VBANKNMCANCELCODE",payBankCode},               //환불은행명코드
             {"nvar_P_VBANKTYPECANCELNAME",VbankInputName.AsText()},    //예금주
             {"nvar_P_FLAG",statusFLAG},               //플래그 값 성공 실패 유무
             {"nvar_P_PAYWAY_FLAG",Flag}      //여기까지 끌고와야하는 값은 OrderCancel의 flag값
        };

        logger.Debug("===================================== paybankName : " + paybankName);

        service.UpdateOrderCancelResult(paramList);
    }
}