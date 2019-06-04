<%@ WebHandler Language="C#" Class="OrderHandler" %>

using System;
using System.Web;
using System.Collections.Generic;
using System.Linq;
using Newtonsoft.Json;
using Urian.Core;
using SocialWith.Biz.Goods;
using SocialWith.Biz.Order;
using SocialWith.Biz.User;
using NLog;
public class OrderHandler : IHttpHandler
{

    OrderService orderService = new OrderService();
    #region << logger >>
    protected static Logger logger = NLog.LogManager.GetCurrentClassLogger();
    protected static readonly bool IsDebugEnabled = logger.IsDebugEnabled;
    protected static readonly bool IsInfoEnabled = logger.IsInfoEnabled;
    protected static readonly bool IsWarnEnabled = logger.IsWarnEnabled;
    protected static readonly bool IsErrorEnabled = logger.IsErrorEnabled;
    protected static readonly bool IsFatalEnabled = logger.IsFatalEnabled;
    #endregion
    public void ProcessRequest(HttpContext context)
    {
        //context.Response.ContentType = "text/plain";
        //context.Response.Write("Hello World");

        string method = context.Request.Form["Method"].AsText();

        switch (method)
        {
            case "QuickView":
                GetQuickGoodsView(context);
                break;
            case "UserInfo":
                GetUserInfo(context);
                break;
            case "OrderTry":
                OrderTry(context);
                break;

            case "BelongList":
                GetOrderBelongList(context);
                break;
            case "AreaList":
                GetOrderAreaList(context);
                break;
            case "OrderAreaList":
                GetAreaList(context);
                break;
            case "SaleCompList":
                GetOrderSaleCompList(context);
                break;
            case "SaveOrder":
                SaveOrder(context);
                break;
            case "DelOrderTry":
                DelOrderTry(context);
                break;
            case "OrderHistory":
                OrderHistory(context);
                break;
            case "OrderHistory_A":
                OrderHistory_A(context);
                break;
            case "OrderHistory_Admin":
                OrderHistory_Admin(context);
                break;
            case "HistoryOrderInfo":
                GetHistoryOrderInfo(context);
                break;
            case "SaveOrderCancel":
                SaveOrderCancel(context);
                break;
            case "OrderDtlInfo":
                GetOrderDtlInfo(context);
                break;
            case "OrderBillIssue":
                OrderBillList(context);
                break;
            case "OrderTrySaveByRequest":
                OrderTrySaveByRequest(context);
                break;
            case "OrderStatCnt":
                GetOrdCancelOrderStatCount(context);
                break;
            case "GetPrintOrderHistoryList":
                GetPrintOrderHistoryList(context);
                break;

            //case "GetTransAction":
            //    GetTransAction(context);
            //    break;

            case "OrdCancelDirect":
                SaveOrdCancelDirect(context);
                break;
            case "OrderByQuick":
                OrderByQuick(context);
                break;
            case "OrderDtlInfoAllUser":
                GetOrderDtlInfo_AllUser(context);
                break;
            case "OrdCancelList_A":
                GetOrdCancelList_A(context);
                break;
            case "OrdCancelList_Admin":
                GetOrdCancelList_Admin(context);
                break;
            case "UpdateOrderTryQty":
                UpdateOrderTryQty(context);
                break;
            case "OrdPgLoanInfo":
                GetOrdPgLoanInfo(context); //구매사와 연결된 판매사 PG 정보 조회
                break;
            case "OrdDeliveryCheck":
                GetOrdDeliveryCheck(context); //주문취소 신청 시 배송단계로 넘어간 상품이 있는 지 체크
                break;

            case "PayBillCheck":
                UpdatePayBillCheck(context);
                break;

            case "GetPayBillCheck":
                GetPayBillCheck(context);
                break;

            case "UpdateBelongUse":                   //주문소속 조회 시 사용중지 버튼 
                UpdateBelongUse(context);
                break;

            case "OrderBelongPopupList":
                GetOrderBelongPopupList(context);
                break;

            case "SaveOrderArea":
                SaveOrderArea(context);
                break;
            case "OrderBillIssue_Admin": //[관리자]계산서발행 조회(구매사)
                OrderBillList_Admin(context);
                break;
            case "OrderBillIssue_A": //[판매사]계산서발행 조회
                OrderBillList_A(context);
                break;
            case "GetGoodsLoanInfo":
                GetGoodsLoanInfo(context);
                break;
            case "GetMonthDeadLineList": //(구매사)구매사 대금결제 내역조회 [마감신청]
                GetMonthDeadLineList(context);
                break;
            case "GetMonthDeadLineList_Admin": //(관리자)구매사 대금결제 내역조회 [마감내역조회]
                GetMonthDeadLineList_Admin(context);
                break;
            case "UpdateOrderEndReq": //(구매사) 구매사 대금결제 내역조회 [마감요청]
                UpdateOrderEndReq(context);
                break;
            case "UpdateOrderNextEnd": //(구매사) 구매사 대금결제 내역조회 [이월요청]
                UpdateOrderNextEnd(context);
                break;
            case "SendSMS": //SMS
                SendSMS(context);
                break;
            case "SendMMS": //MMS
                SendMMS(context);
                break;
            case "OrderPriceData": //주문취소(신용카드/실시간계좌이체) 요청시 주문번호 상품들 관련 금액(배송비 처리 위해) 정보 조회
                GetOrderCancelPriceData(context);
                break;
            case "SaveOrderAllCancel": //주문취소(신용카드/실시간계좌이체) 신청
                SaveOrderAllCancel(context);
                break;
            case "UpdateAreaUse": //주문취소(신용카드/실시간계좌이체) 신청
                UpdateAreaUse(context);
                break;

            case "UpdateDlvrGubunChg": //(관리자)주문상세팝업에서 직송변경
                UpdateDlvrGubunChg(context);
                break;
            case "UpdateOrderStatReset": //(관리자)주문상세팝업에서 주문처리초기화
                UpdateOrderStatReset(context);
                break;
            case "UpdateDlvrGubunChgCD": //(관리자)주문상세팝업에서 CD변경
                UpdateDlvrGubunChgCD(context);
                break;
            case "UpdateDeliPutDate":
                UpdateDeliPutDate(context);
                break;
            case "UpdateOrderStatus": //(관리자)주문상태변경
                UpdateOrderStatus(context);
                break;
            case "UpdateOrderDlvrNo": //(관리자)운송장번호 입력
                UpdateOrderDeliveryNo(context);
                break;
            case "InsertOrderBill_B_Admin": //(관리자)구매사 세금계산서 발행 등록
                InsertAdminOrderBill_B(context);
                break;
            case "UpdateOrderBill_B_Admin": //(관리자)구매사 세금계산서 등록 업데이트
                UpdateAdminOrderBill_B(context);
                break;
            case "GetBillInfo_B_Admin": //(관리자)BILL현황(구매사) - 세금계산서 발행정보 조회 - 목록 팝업
                GetAdminBillInfo_B(context);
                break;
            case "UpdatePopOrderBelong": //관리자 주문연동관리 팝업 업데이트
                UpdatePopOrderBelong(context);
                break;
            case "GetOrderBelongMainPopup_Admin": //관리자 주문연동관리 주문소속조회 팝업조회
                GetOrderBelongMainPopup_Admin(context);
                break;
            case "GetBuyCompMonthProfitList": //메인 - 구매사별 매출금액 조회
                GetBuyCompMonthProfitList(context);
                break;



        }
    }

    //(관리자)구매사 세금계산서 발행 등록
    protected void InsertAdminOrderBill_B(HttpContext context)
    {
        string orderCodeNo = context.Request.Form["OrdCodeNo"].AsText(); //주문번호

        var paramList = new Dictionary<string, object> {
            { "nvar_P_ORDERCODENO", orderCodeNo }
        };

        orderService.InsertAdminOrderBill_B(paramList); //(관리자)구매사 세금계산서 발행 등록

        GetAdminBillInfo_B(context);
    }

    //(관리자)구매사 세금계산서 등록 업데이트
    protected void UpdateAdminOrderBill_B(HttpContext context)
    {
        string orderCodeNo = context.Request.Form["OrdCodeNo"].AsText(); //주문번호
        string sCompany = context.Request.Form["Scompany"].AsText();
        string rCompany = context.Request.Form["Rcompany"].AsText();
        string dt = context.Request.Form["Dt"].AsText();
        string obj = context.Request.Form["Obj"].AsText();
        string sUser = context.Request.Form["sUser"].AsText();
        string rUser = context.Request.Form["rUSer"].AsText();
        string sDivision = context.Request.Form["sDivision"].AsText();
        string rDivision = context.Request.Form["rDivision"].AsText();
        string sTelNo = context.Request.Form["STelNo"].AsText();
        string rTelNo = context.Request.Form["RTelNo"].AsText();
        string sEmail = context.Request.Form["SEmail"].AsText();
        string rEmail = context.Request.Form["REmail"].AsText();

        var paramList = new Dictionary<string, object> {
            { "nvar_P_ORDERCODENO", orderCodeNo },  //주문번호
            { "nvar_P_SCOMPANY", sCompany },     //공급자 법인명
            { "nvar_P_RCOMPANY", rCompany },     //공급받느자 법인명
            { "nvar_P_DT", dt },           //작성일자(YYYY-MM-DD)
            { "nvar_P_OBJ", obj },          //품목
            { "nvar_P_SUSER", sUser },        //공급자
            { "nvar_P_RUSER", rUser },        //공급받는자
            { "nvar_P_SDIVISION", sDivision },    //공급자부서
            { "nvar_P_RDIVISION", rDivision },    //공급받는자부서
            { "nvar_P_STELNO", sTelNo },       //공급자연락처
            { "nvar_P_RTELNO", rTelNo },       //공급받는자연락처
            { "nvar_P_SEMAIL", sEmail },       //공급자이메일
            { "nvar_P_REMAIL", rEmail },       //공급받는자이메일
        };

        orderService.UpdateAdminOrderBill_B(paramList); //(관리자)구매사 세금계산서 등록 업데이트

        GetAdminBillInfo_B(context);
    }

    //(관리자)BILL현황(구매사) - 세금계산서 발행정보 조회 - 목록 팝업
    protected void GetAdminBillInfo_B(HttpContext context)
    {
        string orderCodeNo = context.Request.Form["OrdCodeNo"].AsText(); //주문번호

        var paramList = new Dictionary<string, object> {
            { "nvar_P_ORDERCODENO", orderCodeNo }
        };

        var info = orderService.GetAdminBillInfo_B(paramList);
        var returnjsonData = JsonConvert.SerializeObject(info);

        context.Response.ContentType = "text/plain";
        context.Response.Write(returnjsonData);
    }



    // [관리자] (선택/PO)운송장번호 입력
    protected void UpdateOrderDeliveryNo(HttpContext context)
    {
        string orderCodeNo = context.Request.Form["OdrCodeNo"].AsText(); //주문번호
        string deliveryNo = context.Request.Form["DlvrNo"].AsText();     //주문상태값
        string goodsCode = context.Request.Form["GoodsCode"].AsText();   //상품코드(ALL:전체, 그외:상품코드)
        //string uNumOrdNo = context.Request.Form["UNumOrdNo"].AsText();

        var paramList = new Dictionary<string, object> {
            { "nvar_P_ORDERCODENO", orderCodeNo },
            { "nvar_P_DELIVERYCOMPANY", "한진택배" },
            { "nvar_P_DELIVERYNO", deliveryNo },
            { "nvar_P_GOODSCODE", goodsCode }
        };

        orderService.UpdateOrderDeliveryNo_Admin(paramList); //운송장번호 입력

        GetOrderDtlInfo_AllUser(context);
    }


    // [관리자] (선택/PO)주문상태 변경
    protected void UpdateOrderStatus(HttpContext context)
    {
        string orderCodeNo = context.Request.Form["OdrCodeNo"].AsText(); //주문번호
        string svidUser = context.Request.Form["SvidUser"].AsText();     //사용자시퀀스
        string orderStat = context.Request.Form["OdrStat"].AsText();     //주문상태값
        string goodsCode = context.Request.Form["GoodsCode"].AsText();   //상품코드(ALL:전체, 그외:상품코드)
        //string uNumOrdNo = context.Request.Form["UNumOrdNo"].AsText();

        var paramList = new Dictionary<string, object> {
            { "nvar_P_SVID_USER", svidUser },
            { "nvar_P_ORDERCODENO", orderCodeNo },
            { "nvar_P_GOODSCODE", goodsCode },
            { "nume_P_ORDERSTATUS", orderStat.AsInt() }
        };

        orderService.UpdateOrderStatus_Admin(paramList); //주문상태값 변경

        GetOrderDtlInfo_AllUser(context);
    }

    // 가상/후불계좌 주문취소
    protected void SaveOrdCancelDirect(HttpContext context)
    {
        string odrCodeNo = context.Request.Form["OrdCodeNo"].AsText();
        string svidUser = context.Request.Form["SvidUser"].AsText();
        //string cnclContent = context.Request.Form["CnclContent"].AsText();
        string ordStat = context.Request.Form["OrdStat"].AsText();

        string cancelVBankNo = context.Request.Form["CancVbankNo"].AsText();
        string cancelVBankCode = context.Request.Form["CancVbankCode"].AsText();
        string VbankInputName = context.Request.Form["CancVbankName"].AsText();
        string cancelMsg = context.Request.Form["CancelMsg"].AsText();


        string cancelOrdStat = "422"; // 주문취소 상태코드(기본:주문취소완료)

        // 주문취소중
        if (ordStat.Equals("100"))
        {
            //cancelOrdStat = "421";
            cancelOrdStat = "422";

        }
        //주문취소완료
        else if (ordStat.Equals("101") || ordStat.Equals("102") || ordStat.Equals("411"))
        {
            cancelOrdStat = "422";
        }

        var paramList = new Dictionary<string, object> {
            { "nvar_P_ORDERCODENO", odrCodeNo },
            { "nvar_P_SVID_USER", svidUser },
            { "nvar_P_CANCELCONTENT", cancelMsg },
            { "nume_P_ORDERSTATUS", cancelOrdStat.AsInt() },
            { "nvar_P_VBANKCANCELNO",cancelVBankNo },          //환불계좌
            { "nvar_P_VBANKNMCANCELCODE",cancelVBankCode },     //환불은행명코드
            { "nvar_P_VBANKTYPECANCELNAME",VbankInputName },    //예금주
        };

        orderService.SaveOrdCancelVbankDirect(paramList); // 주문 취소(가상/후불)

        context.Response.ContentType = "text/plain";
        context.Response.Write("{\"Result\": \"OK\"}");
    }

    // 주문취소 신청
    protected void SaveOrderCancel(HttpContext context)
    {
        string uOrderNo = context.Request.Form["UorderNo"].AsText();
        string odrCodeNo = context.Request.Form["OrderCodeNo"].AsText();
        string gdsFinCtgrCodes = context.Request.Form["GoodsFinalCategoryCode"].AsText(); // 상품 최종 카테고리 코드
        string gdsGrpCodes = context.Request.Form["GoodsGroupCode"].AsText(); // 상품그룹코드
        string gdsCodes = context.Request.Form["GoodsCode"].AsText(); // 상품코드
        string svid_user = context.Request.Form["SvidUser"].AsText();
        string subject = context.Request.Form["goodsinfo"].AsText();
        string cnclContent = context.Request.Form["CancelMsg"].AsText();
        string odrCancelStat_type = context.Request.Form["OrderCancelStatus"].AsText();
        string odrStat_type = context.Request.Form["OrderStatus"].AsText();
        string Flag = context.Request.Form["Flag"].AsText();

        // 나중에 수정될 수 있음....
        int odrCancelStat = 0;
        int odrStat = 0;

        switch (odrCancelStat_type)
        {
            case "1":
                odrCancelStat = 400;
                break;
            case "2":
                odrCancelStat = 411;
                break;
            case "2-1":
                odrCancelStat = 412;
                break;
            case "3":
                odrCancelStat = 421;
                break;
        }

        switch (odrStat_type)
        {
            case "1":
                odrStat = 400;
                break;
            case "2":
                odrStat = 411;
                break;
            case "2-1":
                odrStat = 412;
                break;
            case "3":
                odrStat = 421;
                break;
        }

        string odrCnclCodeNo = NextOrderCancelCodeNo();

        var paramList = new Dictionary<string, object> {
            { "nvar_P_ORDERCANCELCODENO", odrCnclCodeNo },
            { "nvar_P_ORDERCODENO", odrCodeNo },
            { "nvar_P_GOODSFINALCATEGORYCODE", gdsFinCtgrCodes },
            { "nvar_P_GOODSGROUPCODE", gdsGrpCodes },
            { "nvar_P_GOODSCODE", gdsCodes },
            { "nvar_P_SVID_USER", svid_user },
            { "nvar_P_SUBJECT", subject },
            { "nvar_P_CANCELCONTENT", cnclContent },
            { "nume_P_ORDERCANCELSTATUS", odrCancelStat.AsInt() },
            { "nume_P_UNUM_ORDERNO", uOrderNo.AsInt() },
            { "nume_P_ORDERSTATUS", odrStat.AsInt() },
            { "nvar_P_FLAG", Flag }
        };

        orderService.SaveOrderCancel(paramList);

        context.Response.ContentType = "text/plain";
        context.Response.Write("{\"Result\": \"" + odrCnclCodeNo + "\"}");
    }


    // ORDERCANCELCODENO 값 생성
    protected string NextOrderCancelCodeNo()
    {
        string nextSeq = orderService.GetNextOrderCancelCodeNo();
        string nowDate = DateTime.Now.ToString("yyMMdd");

        string nextCode = "OV-" + nowDate + "-" + nextSeq;

        return nextCode;
    }

    // ORDERCANCELCODENO 값 생성 여러개
    protected string NextOrderCancelCodeNoArr()
    {
        string nextSeq = orderService.GetNextOrderCancelCodeNo();
        string nowDate = DateTime.Now.ToString("yyMMdd");

        string nextCode = "OV-" + nowDate + "-" + nextSeq;

        return nextCode;
    }

    //
    // 주문취소 신청(신용카드/실시간-전부)
    protected void SaveOrderAllCancel(HttpContext context)
    {
        string odrCodeNo = context.Request.Form["OrderCodeNo"].AsText();
        string svid_user = context.Request.Form["SvidUser"].AsText();
        string cnclContent = context.Request.Form["CancelMsg"].AsText();

        var paramList = new Dictionary<string, object> {
            { "nvar_P_ORDERCODENO", odrCodeNo },
            { "nvar_P_SVID_USER", svid_user },
            { "nvar_P_CANCELCONTENT", cnclContent }
        };

        orderService.SaveAllOrderCancel(paramList);

        context.Response.ContentType = "text/plain";
        context.Response.Write("SUCCESS");
    }

    // 주문하기 화면의 주문내역 목록에서 행 삭제
    protected void DelOrderTry(HttpContext context)
    {
        string svid_user = context.Request.Form["SvidUser"].AsText();
        string uOrderTryNo = context.Request.Form["UorderTryNo"].AsText();
        string uCartNo = context.Request.Form["UcartNo"].AsText();

        var paramList = new Dictionary<string, object> {
            {"nvar_P_SVID_USER", svid_user},
            {"nume_P_UNUM_ORDERTRYNO", uOrderTryNo},
            {"nume_P_UNUM_CARTNO", uCartNo},
            {"nvar_P_FLAG", "ONE"}
        };

        orderService.UpdateOrderTryDelflag(paramList);

        context.Response.ContentType = "text/plain";
        context.Response.Write("{\"Result\": \"OK\"}");
    }

    // 주문 저장
    protected void SaveOrder(HttpContext context)
    {
        string gdsFinCtgrCodes = context.Request.Form["GdsFinCtgrCode"].AsText(); // 상품 최종 카테고리 코드
        string gdsGrpCodes = context.Request.Form["GdsGrpCode"].AsText(); // 상품그룹코드
        string gdsCodes = context.Request.Form["GdsCode"].AsText(); // 상품코드
        string qtys = context.Request.Form["Qty"].AsText(); // 수량
        string svid_user = context.Request.Form["Svid_User"].AsText();
        string orderBelong_Code = context.Request.Form["OrderBelong_Code"].AsText(); // 판매사 소속 코드
        string orderArea_Code = context.Request.Form["OrderArea_Code"].AsText(); // 판매사 지역 코드
        string orderSaleComp_Code = context.Request.Form["OrderSaleComp_Code"].AsText(); // 판매사 코드
        string payway = context.Request.Form["Payway"].AsText(); // 결제방법 코드
        string gdsSalePriceVats = context.Request.Form["GdsSalePriceVat"].AsText(); // 상품별 구매금액
        string orderStatus = context.Request.Form["OrderStat"].AsText(); // 주문상태코드
        string ordTryUnums = context.Request.Form["OrdTryUnum"].AsText(); // U_ORDERTRY 테이블의 UNUM_ORDERTRYNO 컬럼값
        string gdsDeliTypes = context.Request.Form["GdsDeliType"].AsText(); // 11:합배송, 21/22:분할배송

        string dlvrCost = context.Request.Form["DlvrCost"].AsText();
        string powerDlvrCost = context.Request.Form["PowerdlvrCost"].AsText();
        string postNo = context.Request.Form["Zipcode"].AsText();
        string addr1 = context.Request.Form["Address_1"].AsText();
        string addr2 = context.Request.Form["Address_2"].AsText();
        string dlvrReqInfo = context.Request.Form["DlvrReqInfo"].AsText();
        string dlvrDueType = context.Request.Form["DlvrDueType"].AsText(); // 배송방법(1:합배송, 2:분할배송)
        string BLoanYN = context.Request.Form["BLoanYN"].AsText(); //PO별 묶음 결제 사용 여부
        string BLoanYNFlag = context.Request.Form["BLoanYNFlag"].AsText(); //PO별 묶음 결제 사용 여부 구분자(주문:ORDER, 결제:PAY)

        string dlvrUserNm = context.Request.Form["DlvrUserNm"].AsText(); //배송지 받는사람명
        string dlvrUserTelNo = context.Request.Form["DlvrUserTelNo"].AsText(); //배송지 받는사람 연락처

        var gdsFinCtgrCodeArray = gdsFinCtgrCodes.Split('/');
        var gdsGrpCodeArray = gdsGrpCodes.Split('/');
        var gdsCodeArray = gdsCodes.Split('/');
        var qtyArray = qtys.Split('/');
        var gdsSalePriceVatArray = gdsSalePriceVats.Split('/');
        var ordTryUnumArray = ordTryUnums.Split('/');
        var gdsDeliTypeArray = gdsDeliTypes.Split('/');

        string resultVal = string.Empty; //반환값

        // 여신결제(일반), 가상계좌(고정)일 경우 고정 계좌번호 값 체크
        var returnPgLoanVal = string.Empty;
        if ((!BLoanYNFlag.Equals("ORDER")) && (payway.Equals("6") || payway.Equals("9")))
        {
            returnPgLoanVal = GetOrdPgLoanInfo(context); //고정 가상계좌 관련 정보 조회

            logger.Debug("returnPgLoanVal : "+returnPgLoanVal);

            //조회된 고정계좌번호 값이 없는 경우
            if (string.IsNullOrWhiteSpace(returnPgLoanVal))
            {
                resultVal = "NotBankNo";

                context.Response.ContentType = "text/plain";
                context.Response.Write("{\"Result\": \"NotBankNo\"}");
            }
        }

        if (string.IsNullOrEmpty(resultVal))
        {
            //  해당하는 사용자의 U_ORDER_DELIVERY 와 U_ORDER 에 행 전부 delflag='Y' 처리
            var delFlagParamList = new Dictionary<string, object>() {
                {"nvar_P_SVID_USER", svid_user}
                ,{"nvar_P_ORDERSTATUS", ""}
                ,{"nvar_P_ORDERCODENO", ""}
                ,{"nvar_P_DELFLAG", "Y"}
                ,{"nvar_P_FLAG", "ORDER_1"}
            };

            orderService.UpdateOrderInfo(delFlagParamList);

            // u_order 에 저장
            var orderCodeNo = NextOrderCodeNo();

            for (int i = 0; i < (gdsCodeArray.Length - 1); i++)
            {
                //주문시도 건에 대한 로그 기록 남김.
                if(i == 0)
                {
                    var hityParamList = new Dictionary<string, object>() {
                        {"nvar_P_SVID_USER", svid_user}
                        ,{"nvar_P_GUBUN", "1"}
                        ,{"nvar_P_INFO", "3"}
                    };


                    SocialWith.Biz.User.UserService userService = new UserService();
                    userService.InsertLoginHity(hityParamList);
                }

                var goodsFinCtgrCode = gdsFinCtgrCodeArray[i];
                var goodsGrpCode = gdsGrpCodeArray[i];
                var goodsCode = gdsCodeArray[i];
                var qty = qtyArray[i];
                var gdsSalePriceVat = gdsSalePriceVatArray[i];
                var ordTryUnum = ordTryUnumArray[i];
                var gdsDeliType = gdsDeliTypeArray[i];

                var paramList = new Dictionary<string, object>() {
                     {"nvar_P_ORDERCODENO", orderCodeNo}
                    ,{"nvar_P_GOODSFINALCATEGORYCODE", goodsFinCtgrCode}
                    ,{"nvar_P_GOODSGROUPCODE", goodsGrpCode}
                    ,{"nvar_P_GOODSCODE", goodsCode}
                    ,{"nvar_P_SVID_USER", svid_user}
                    ,{"nvar_P_ORDERBELONG_CODE", orderBelong_Code}
                    ,{"nvar_P_ORDERAREA_CODE", orderArea_Code}
                    ,{"nvar_P_ORDERSALECOMPANY_CODE", orderSaleComp_Code}
                    ,{"nume_P_QTY", qty.AsInt()}
                    ,{"nvar_P_PAYWAY", payway}
                    ,{"nume_P_GOODSSALEPRICEVAT", gdsSalePriceVat.AsDecimal()}
                    ,{"nume_P_ORDERSTATUS", orderStatus.AsInt()}
                    ,{"nume_P_UNUM_ORDERTRYNO", ordTryUnum}
                    ,{"nvar_P_GOODSDELIVERYTYPE", gdsDeliType}
                };

                orderService.SaveOrder(paramList);
            }

            var paramList2 = new Dictionary<string, object>() {
                 {"nvar_P_ORDERCODENO", orderCodeNo}
                ,{"nume_P_DELIVERYCOST", dlvrCost.AsDecimal()}
                ,{"nume_P_POWERDELIVERYCOST", powerDlvrCost.AsDecimal()}
                ,{"nvar_P_ZIPCODE", postNo}
                ,{"nvar_P_ADDRESS_1", addr1}
                ,{"nvar_P_ADDRESS_2", addr2}
                ,{"nvar_P_DELIVERYREQUESTINFO", dlvrReqInfo}
                ,{"nvar_P_DELIVERYYN", "N"}
                ,{"nvar_P_GOODSDELIVERYTYPE", dlvrDueType}
                ,{"nvar_P_DELIVERYNAME", dlvrUserNm}
                ,{"nvar_P_DELIVERYHPHONE", dlvrUserTelNo}
            };

            orderService.SaveOrderDelivery(paramList2);


            string loanResult = string.Empty;

            if (BLoanYNFlag.Equals("ORDER")) loanResult = ", \"LoanFlag\": \"LOAN\"";

            context.Response.ContentType = "text/plain";
            context.Response.Write("{\"Result\": \"" + orderCodeNo + "\"" + loanResult + "}");
        }
    }

    // orderCodeNo 값 생성
    protected string NextOrderCodeNo()
    {
        string nextSeq = orderService.GetNextOrderCodeNo();
        string nowDate = DateTime.Now.ToString("yyMMdd");

        string nextCode = "ON-" + nowDate + "-" + nextSeq;

        return nextCode;
    }

    // 간편주문 화면 - 상품코드로 상품 조회
    protected void GetQuickGoodsView(HttpContext context)
    {
        string goodsCode = context.Request.Form["GoodsCode"].AsText();
        string compCode = context.Request.Form["CompCode"].AsText();
        string saleCompCode = context.Request.Form["SaleCompCode"].AsText();
        string dongshinCheck = context.Request.Form["DongshinCheck"].AsText("N");
        string freeYN = context.Request.Form["FreeCompanyYN"].AsText();
        string freeVatYN = context.Request.Form["FreeCompanyVatYN"].AsText("N");
        string svidUser = context.Request.Form["SvidUser"].AsText();
        var paramList = new Dictionary<string, object>() {
             {"nvar_P_GOODSCODE", goodsCode},
             {"nvar_P_COMPCODE", compCode},
             {"nvar_P_SALECOMPCODE", saleCompCode},
             {"nvar_P_BDONGSHINCHECK",  dongshinCheck},
             {"nvar_P_FREECOMPANYYN", freeYN},
             {"nvar_P_FREECOMPANYVATYN", freeVatYN},
             {"nvar_P_SVID_USER", svidUser},
        };

        GoodsService goodsService = new GoodsService();
        var goods = goodsService.GetGoodsQuickOrderView(paramList);
        var returnjsonData = string.Empty;

        //if (goods != null)
        //{
        returnjsonData = JsonConvert.SerializeObject(goods);
        //}
        //else
        //{
        //    returnjsonData = "{\"Result\": \"NULL\"}";
        //}

        context.Response.ContentType = "text/plain";
        context.Response.Write(returnjsonData);
    }

    protected void GetUserInfo(HttpContext context)
    {
        string userId = context.Request.Form["Id"].AsText();

        GoodsService GoodsService = new GoodsService();

        var paramList = new Dictionary<string, object> {
            {"nvar_P_ID", userId}, //임시데이터 넣어둠 
        };

        var info = GoodsService.GetUserInfo(paramList);
        var returnjsonData = string.Empty;

        if (info != null)
        {
            info.Email = Crypt.AESDecrypt256(info.Email);
            returnjsonData = JsonConvert.SerializeObject(info);
        }
        else
        {
            returnjsonData = "{\"Result\": \"NULL\"}";
        }

        context.Response.ContentType = "text/plain";
        context.Response.Write(returnjsonData);
    }

    //주문테이블에 담기
    protected void OrderTry(HttpContext context)
    {
        OrderService OrderService = new OrderService();

        string goodsFinalCategoryCode = context.Request.Form["GoodsFinalCategoryCode"].AsText();
        string cartNo = context.Request.Form["Unum_CartNo"].AsText();
        string goodsGroupCode = context.Request.Form["GoodsGroupCode"].AsText();
        string goodsCode = context.Request.Form["GoodsCode"].AsText();
        string svidUser = context.Request.Form["SvidUser"].AsText();
        string qty = context.Request.Form["Qty"].AsText();
        string budgetAccount = context.Request.Form["BudgetAccount"].AsText();
        string cartCode = context.Request.Form["CartCode"].AsText();
        string flag = context.Request.Form["Flag"].AsText();
        string dongshinCheck = context.Request.Form["DongshinCheck"].AsText("N");
        string freeYN = context.Request.Form["FreeCompanyYN"].AsText();
        var goodsFinalCategoryCodeArray = goodsFinalCategoryCode.Split('/');
        var goodsGroupCodeArray = goodsGroupCode.Split('/');
        var goodsCodeArray = goodsCode.Split('/');
        var qtyArray = qty.Split('/');
        var cartNoArray = cartNo.Split('/');
        //var budgetAccountArray = budgetAccount.Split('/');
        var cartCodeArray = cartCode.Split('/');
        string compCode = context.Request.Form["CompCode"].AsText();
        string saleCompCode = context.Request.Form["SaleCompCode"].AsText();
        var paramList = new Dictionary<string, object> {
                {"nvar_P_SVID_USER", svidUser},
                {"nume_P_UNUM_ORDERTRYNO", 0},
                {"nume_P_UNUM_CARTNO", 0},
                {"nvar_P_FLAG", "ALL"}
        };

        OrderService.UpdateOrderTryDelflag(paramList);

        for (int i = 0; i < goodsFinalCategoryCodeArray.Length - 1; i++)
        {
            var _goodsFinalCategoryCode = goodsFinalCategoryCodeArray[i].AsText();
            var _goodsGroupCode = goodsGroupCodeArray[i].AsText();
            var _goodsCode = goodsCodeArray[i].AsText();
            var _qty = qtyArray[i].AsInt();
            var _cartNo = cartNoArray[i].AsText();
            //var _budgetAccount = budgetAccountArray[i].AsText();
            var _cartCode = cartCodeArray[i].AsText();

            paramList = new Dictionary<string, object> {
                {"nvar_P_SVID_USER", svidUser},
                {"nvar_P_UNUM_CARTNO ", _cartNo},
                {"nvar_P_GOODSFINALCATEGORYCODE", _goodsFinalCategoryCode},
                {"nvar_P_GOODSGROUPCODE", _goodsGroupCode},
                {"nvar_P_GOODSCODE", _goodsCode},
                {"nume_P_QTY", _qty},
                {"nvar_P_CARTCODE", _cartCode},
                {"nvar_P_BUDGETACCOUNT", ""},
                {"nvar_P_FLAG", flag},
                {"nvar_P_COMPCODE", compCode},
                {"nvar_P_SALECOMPCODE", saleCompCode},
                {"nvar_P_BDONGSHINCHECK",  dongshinCheck},
                {"nvar_P_FREECOMPANYYN", freeYN},


            };

            OrderService.OrderTry(paramList);
        }

        context.Response.ContentType = "text/plain";
        context.Response.Write("{\"Result\": \"OK\"}");
    }

    protected void GetOrderBelongList(HttpContext context)
    {
        OrderService OrderService = new OrderService();


        var paramList = new Dictionary<string, object>
        {

        };

        var list = OrderService.GetOrderBelongList(paramList);


        var returnjsonData = JsonConvert.SerializeObject(list);
        HttpContext.Current.Response.ContentType = "text/json";
        HttpContext.Current.Response.Write(returnjsonData);
    }

    protected void GetOrderAreaList(HttpContext context)
    {
        OrderService OrderService = new OrderService();

        string belongCode = context.Request.Form["OrderBelongCode"].AsText();
        var paramList = new Dictionary<string, object> {
            {"nvar_P_ORDERBELONG_CODE", belongCode},

        };

        var list = OrderService.GetOrderAreaList(paramList);


        var returnjsonData = JsonConvert.SerializeObject(list);
        HttpContext.Current.Response.ContentType = "text/json";
        HttpContext.Current.Response.Write(returnjsonData);
    }

    protected void GetAreaList(HttpContext context)
    {
        OrderService OrderService = new OrderService();

        string target = context.Request.Form["Target"].AsText();
        string searchKeyword = context.Request.Form["SearchKeyword"].AsText();
        int pageNo = context.Request.Form["PageNo"].AsInt();
        int pageSize = context.Request.Form["PageSize"].AsInt();

        var paramList = new Dictionary<string, object> {
            {"nvar_P_ORDERBELONG_CODE", target},
            {"nvar_P_SEARCHKEYWORD", searchKeyword},
            {"inte_P_PAGENO", pageNo},
            {"inte_P_PAGESIZE", pageSize},
        };

        var list = OrderService.GetAreaList(paramList);


        var returnjsonData = JsonConvert.SerializeObject(list);
        HttpContext.Current.Response.ContentType = "text/json";
        HttpContext.Current.Response.Write(returnjsonData);
    }

    protected void GetOrderSaleCompList(HttpContext context)
    {
        OrderService OrderService = new OrderService();

        string belongCode = context.Request.Form["OrderBelongCode"].AsText();
        string areaCode = context.Request.Form["OrderAreaCode"].AsText();
        var paramList = new Dictionary<string, object> {
            {"nvar_P_ORDERBELONG_CODE", belongCode},
            {"nvar_P_ORDERAREA_CODE", areaCode},

        };

        var list = OrderService.GetOrderSaleCompanyList(paramList);


        var returnjsonData = JsonConvert.SerializeObject(list);
        HttpContext.Current.Response.ContentType = "text/json";
        HttpContext.Current.Response.Write(returnjsonData);
    }

    //주문내역 조회
    protected void OrderHistory(HttpContext context)
    {
        OrderService OrderService = new OrderService();

        string svidUser = context.Request.Form["SvidUser"].AsText();
        string orderStatus = context.Request.Form["OrderStatus"].AsText();
        string payway = context.Request.Form["PayWay"].AsText();
        string todateB = context.Request.Form["TodateB"].AsText();
        string todateE = context.Request.Form["TodateE"].AsText();
        string orderCodeNo = context.Request.Form["OrderCodeNo"].AsText();
        string Brand = context.Request.Form["Brand"].AsText();
        string goodsFinalName = context.Request.Form["GoodsFinalName"].AsText();
        string goodsCode = context.Request.Form["GoodsCode"].AsText();
        int pageNo = context.Request.Form["PageNo"].AsInt();
        int pageSize = context.Request.Form["PageSize"].AsInt();

        var paramList = new Dictionary<string, object> {
            {"nvar_P_SVID_USER", svidUser},
            {"nvar_P_ORDERSTATUS", orderStatus},
            {"nvar_P_PAYWAY", payway},
            {"nvar_P_TODATEB", todateB},
            {"nvar_P_TODATEE", todateE},
            {"nvar_P_ORDERCODENO", orderCodeNo},
            {"nvar_P_BRAND", Brand},
            {"nvar_P_GOODSFINALNAME", goodsFinalName},
            {"nvar_P_GOODSCODE", goodsCode},
            {"inte_P_PAGENO", pageNo},
            {"inte_P_PAGESIZE", pageSize},
        };

        var list = OrderService.GetOrderHistoryList(paramList);

        if (list != null)
        {
            for (int i = 0; i < list.Count; i++)
            {
                int ordStat = list[i].OrderStatus;

                // 주문취소 가능 여부 설정
                if ((ordStat >= 100) && (ordStat < 200))
                {
                    list[i].OrdCancelYn = "Y";

                }
                else
                {
                    //if ((ordStat >= 400) && (ordStat <= 421))
                    if ((ordStat >= 400) && (ordStat < 421))
                    {
                        list[i].OrdCancelYn = "Y";
                    }
                    else
                    {
                        list[i].OrdCancelYn = "N";
                    }
                }
            }
        }

        var returnjsonData = JsonConvert.SerializeObject(list);
        HttpContext.Current.Response.ContentType = "text/json";
        HttpContext.Current.Response.Write(returnjsonData);
    }


    //주문내역 조회(고객사A)
    protected void OrderHistory_A(HttpContext context)
    {
        OrderService OrderService = new OrderService();

        string svidUser = context.Request.Form["SvidUser"].AsText();
        string orderStatus = context.Request.Form["OrderStatus"].AsText();
        string payway = context.Request.Form["PayWay"].AsText();
        string todateB = context.Request.Form["TodateB"].AsText();
        string todateE = context.Request.Form["TodateE"].AsText();
        int pageNo = context.Request.Form["PageNo"].AsInt();
        int pageSize = context.Request.Form["PageSize"].AsInt();

        var paramList = new Dictionary<string, object> {
            {"nvar_P_SVID_USER", svidUser},
            {"nvar_P_ORDERSTATUS", orderStatus},
            {"nvar_P_PAYWAY", payway},
            {"nvar_P_TODATEB", todateB},
            {"nvar_P_TODATEE", todateE},
            {"inte_P_PAGENO", pageNo},
            {"inte_P_PAGESIZE", pageSize},
        };

        var list = OrderService.GetOrderHistoryList_A(paramList);

        if (list != null)
        {
            for (int i = 0; i < list.Count; i++)
            {
                int ordStat = list[i].OrderStatus;

                // 주문취소 가능 여부 설정
                if ((ordStat >= 100) && (ordStat < 200))
                {
                    list[i].OrdCancelYn = "Y";

                }
                else
                {
                    if ((ordStat >= 400) && (ordStat <= 421))
                    {
                        list[i].OrdCancelYn = "Y";
                    }
                    else
                    {
                        list[i].OrdCancelYn = "N";
                    }
                }
            }
        }

        var returnjsonData = JsonConvert.SerializeObject(list);
        HttpContext.Current.Response.ContentType = "text/json";
        HttpContext.Current.Response.Write(returnjsonData);
    }

    //주문내역 조회(Admin)
    protected void OrderHistory_Admin(HttpContext context)
    {
        OrderService OrderService = new OrderService();

        string svidUser = context.Request.Form["SvidUser"].AsText();
        string orderStatus = context.Request.Form["OrderStatus"].AsText();
        string payway = context.Request.Form["PayWay"].AsText();
        string todateB = context.Request.Form["TodateB"].AsText();
        string todateE = context.Request.Form["TodateE"].AsText();
        string orderCodeNo = context.Request.Form["OrderCodeNo"].AsText();
        string Brand = context.Request.Form["Brand"].AsText();
        string goodsFinalName = context.Request.Form["GoodsFinalName"].AsText();
        string goodsCode = context.Request.Form["GoodsCode"].AsText();

        string saleCompname = context.Request.Form["SaleCompName"].AsText();
        string buyCompname = context.Request.Form["BuyCompName"].AsText();
        int pageNo = context.Request.Form["PageNo"].AsInt();
        int pageSize = context.Request.Form["PageSize"].AsInt();

        var paramList = new Dictionary<string, object> {
            {"nvar_P_SVID_USER", svidUser},
            {"nvar_P_ORDERSTATUS", orderStatus},
            {"nvar_P_PAYWAY", payway},
            {"nvar_P_TODATEB", todateB},
            {"nvar_P_TODATEE", todateE},
            {"nvar_P_ORDERCODENO", orderCodeNo},
            {"nvar_P_BRAND", Brand},
            {"nvar_P_GOODSFINALNAME", goodsFinalName},
            {"nvar_P_GOODSCODE", goodsCode},
            {"nvar_P_SALECOMPNAME", saleCompname},
            {"nvar_P_BUYCOMPNAME", buyCompname},
            {"inte_P_PAGENO", pageNo},
            {"inte_P_PAGESIZE", pageSize},
        };

        var list = OrderService.GetOrderHistoryList_Admin(paramList);

        //if (list != null)
        //{
        //    for (int i=0; i<list.Count; i++)
        //    {
        //        int ordStat = list[i].OrderStatus;

        //        // 주문취소 가능 여부 설정
        //        if ((ordStat >= 100) && (ordStat < 200))
        //        {
        //            list[i].OrdCancelYn = "Y";

        //        } else
        //        {
        //            if ((ordStat >= 400) && (ordStat <= 421))
        //            {
        //                list[i].OrdCancelYn = "Y";
        //            } else
        //            {
        //                list[i].OrdCancelYn = "N";
        //            }
        //        }
        //    }
        //}

        var returnjsonData = JsonConvert.SerializeObject(list);
        HttpContext.Current.Response.ContentType = "text/json";
        HttpContext.Current.Response.Write(returnjsonData);
    }
    // 주문내역에서 목록 행의 취소 버튼 클릭 시 해당 주문 내용 조회
    protected void GetHistoryOrderInfo(HttpContext context)
    {
        string svid_user = context.Request.Form["SvidUser"].AsText();
        string uOrderNo = context.Request.Form["UorderNo"].AsText();

        var paramList = new Dictionary<string, object> {
            { "nvar_P_SVID_USER", svid_user },
            { "nume_P_UNUM_ORDERNO", uOrderNo.AsInt() }
        };

        var info = orderService.GetOrderHistoryInfo(paramList);

        var returnjsonData = JsonConvert.SerializeObject(info);
        HttpContext.Current.Response.ContentType = "text/json";
        HttpContext.Current.Response.Write(returnjsonData);
    }

    // 주문내역 목록 - 확인 버튼 클릭 시 주문번호에 해당하는 주문목록 조회
    protected void GetOrderDtlInfo(HttpContext context)
    {
        string svid_user = context.Request.Form["SvidUser"].AsText();
        string odrCodeNo = context.Request.Form["OdrCodeNo"].AsText();
        string odrStat = context.Request.Form["OdrStat"].AsText();
        string unumOrdNo = context.Request.Form["UnumOrdNo"].AsText();

        // 주문 정보 가져오는 부분
        var paramList = new Dictionary<string, object> {
            { "nvar_P_SVID_USER", svid_user },
            { "nvar_P_ORDERCODENO", odrCodeNo },
            { "nume_P_ORDERSTATUS", odrStat }
        };

        var list = orderService.GetOrderInfoList(paramList);

        // 결제 정보 가져오는 부분
        SocialWith.Biz.Pay.PayService payService = new SocialWith.Biz.Pay.PayService();

        string delFlag = "N"; // 결제 테이블에서 취소유무(결제 취소 시 : DELFLAG='Y')

        if ((!odrStat.Equals("431")) && ((odrStat.AsInt() > 400) && (odrStat.AsInt() < 500)))
        {
            delFlag = "Y";
        }
        else
        {
            delFlag = "N";
        }

        var paramList2 = new Dictionary<string, object> {
            { "nvar_P_SVID_USER", svid_user },
            { "nvar_P_ORDERCODENO", odrCodeNo },
            { "nume_P_ORDERSTATUS", odrStat },
            { "nvar_P_DELFLAG", delFlag },
            { "nvar_P_UNUM_ORDERNO", unumOrdNo } //주문내역조회에서 선택한 상품의 주문 시퀀스
        };

        var payInfo = payService.GetOrderPayInfo(paramList2);

        var resultList = new Dictionary<string, object>();
        resultList.Add("orderGoodsList", list);
        resultList.Add("payInfo", payInfo);

        var returnJsonData = JsonConvert.SerializeObject(resultList);
        context.Response.ContentType = "text/plain";
        context.Response.Write(returnJsonData);
    }

    //계산서발행
    protected void OrderBillList(HttpContext context)
    {
        string sviduser = context.Request.Form["SvidUser"].AsText();
        string toDateB = context.Request.Form["ToDateB"].AsText();
        string toDateE = context.Request.Form["ToDateE"].AsText();
        int pageNo = context.Request.Form["PageNo"].AsInt();
        int pageSize = context.Request.Form["PageSize"].AsInt();

        var paramList = new Dictionary<string, object> {
            {"nvar_P_SVID_USER", sviduser},
            {"nvar_P_TODATEB", toDateB},
            {"nvar_P_TODATEE", toDateE},
            {"inte_P_PAGENO", pageNo},
            {"inte_P_PAGESIZE", pageSize},
        };

        var list = orderService.OrderBillList(paramList);

        var returnjsonData = JsonConvert.SerializeObject(list);
        context.Response.ContentType = "text/plain";
        context.Response.Write(returnjsonData);
    }

    //유형2 승인내역에서 결제하기 버튼 클릭시 ordertry데이터생성
    protected void OrderTrySaveByRequest(HttpContext context)
    {
        int requestNo = context.Request.Form["RequestNo"].AsInt();

        var paramList = new Dictionary<string, object> {
            { "nume_P_UNUM_ORDERREQUESTNO", requestNo },
        };

        orderService.SaveOrderTryByOrderRequest(paramList);
        HttpContext.Current.Response.ContentType = "text/plain";
        HttpContext.Current.Response.Write("{\"Result\": \"OK\"}");
    }

    // 후불계좌 주문취소 팝업 뜨기 전에 배송 관련 상태코드 값이 있는지 조회
    protected void GetOrdCancelOrderStatCount(HttpContext context)
    {
        string sUser = context.Request.Form["SvidUser"].AsText();
        string ordCodeNo = context.Request.Form["OrdCodeNo"].AsText();

        var paramList = new Dictionary<string, object> {
            { "nvar_P_ORDERCODENO", ordCodeNo },
            { "nvar_P_SVID_USER", sUser }
        };

        int returnCnt = orderService.GetOrderStatCount(paramList);
        var returnjsonData = JsonConvert.SerializeObject(returnCnt);
        HttpContext.Current.Response.ContentType = "text/json";
        HttpContext.Current.Response.Write("{\"Result\": " + returnjsonData + "}");
    }

    // 납품확인서 출력
    protected void GetPrintOrderHistoryList(HttpContext context)
    {
        string sUser = context.Request.Form["SvidUser"].AsText();
        string ordCodeNo = context.Request.Form["OrdCodeNo"].AsText();

        var paramList = new Dictionary<string, object> {
            { "nvar_P_ORDERCODENO", ordCodeNo },
            { "nvar_P_SVID_USER", sUser }
        };

        var list = orderService.GetPrintOrderHistoryList(paramList);
        var returnjsonData = JsonConvert.SerializeObject(list);
        HttpContext.Current.Response.ContentType = "text/json";
        HttpContext.Current.Response.Write(returnjsonData);
    }
    //반품&교환 거래명세서
    //protected void GetTransAction(HttpContext context)
    //{
    //    string sUser = context.Request.Form["SvidUser"].AsText();
    //    string ordCodeNo = context.Request.Form["OrdCodeNo"].AsText();

    //    var paramList = new Dictionary<string, object> {
    //        { "nvar_P_ORDERCODENO", ordCodeNo },
    //        { "nvar_P_SVID_USER", sUser }
    //    };

    //    var list = orderService.GetTransAction(paramList);
    //    var returnjsonData = JsonConvert.SerializeObject(list);
    //    HttpContext.Current.Response.ContentType = "text/json";
    //    HttpContext.Current.Response.Write(returnjsonData);
    //}

    // 간편주문 주문하기
    protected void OrderByQuick(HttpContext context)
    {
        string cartCode = StringValue.NextCartCode();
        string svid_user = context.Request.Form["SvidUser"].AsText();
        string categoryCodes = context.Request.Form["GoodsFinCtgrCodes"].AsText();
        string groupCodes = context.Request.Form["GoodsGrpCodes"].AsText();
        string goodsCodes = context.Request.Form["GoodsCodes"].AsText();
        string qtys = context.Request.Form["QTYs"].AsText();
        string compCode = context.Request.Form["CompCode"].AsText();
        string saleCompCode = context.Request.Form["SaleCompCode"].AsText();
        string dongshinCheck = context.Request.Form["DongshinCheck"].AsText("N");
        string freeCompYN = context.Request.Form["FreeCompanyYN"].AsText("N");
        var paramList = new Dictionary<string, object> {
            {"nvar_P_SVID_USER", svid_user},
            {"nvar_P_CARTCODE", cartCode},
            {"nvar_P_GOODSFINALCATEGORYCODES", categoryCodes},
            {"nvar_P_GOODSGROUPCODES",  groupCodes},
            {"nvar_P_GOODSCODES", goodsCodes},
            {"nvar_P_QTYS", qtys},
            {"nvar_P_COMPCODE", compCode},
            {"nvar_P_SALECOMPCODE", saleCompCode},
            {"nvar_P_BDONGSHINCHECK",  dongshinCheck},
            {"nvar_P_FREECOMPANYYN", freeCompYN},
        };

        orderService.OrderTryInsertByWish(paramList);

        context.Response.ContentType = "text/plain";
        context.Response.Write("{\"Result\": \"OK\"}");
    }

    // [판매사/관리자]주문내역 목록 - 확인 버튼 클릭 시 주문번호에 해당하는 주문목록 조회
    protected void GetOrderDtlInfo_AllUser(HttpContext context)
    {
        //string svid_user = context.Request.Form["SvidUser"].AsText();
        string odrCodeNo = context.Request.Form["OdrCodeNo"].AsText();
        string odrStat = context.Request.Form["OdrStat"].AsText();
        int uNumOrdNo = context.Request.Form["UNumOrdNo"].AsInt();


        // 주문 정보 가져오는 부분
        var paramList = new Dictionary<string, object> {
            { "nvar_P_ORDERCODENO", odrCodeNo },
            { "nume_P_ORDERSTATUS", odrStat }
        };

        logger.Debug("odrCodeNo : "+odrCodeNo);
        logger.Debug("odrStat : "+odrStat);

        var list = orderService.GetOrderInfoList_AllUser(paramList);

        // 결제 정보 가져오는 부분
        SocialWith.Biz.Pay.PayService payService = new SocialWith.Biz.Pay.PayService();

        string delFlag = "N"; // 결제 테이블에서 취소유무(결제 취소 시 : DELFLAG='Y')

        if ((!odrStat.Equals("431")) && ((odrStat.AsInt() > 400) && (odrStat.AsInt() < 500)))
        {
            delFlag = "Y";
        }
        else
        {
            delFlag = "N";
        }

        var paramList2 = new Dictionary<string, object> {
            { "nvar_P_ORDERCODENO", odrCodeNo },
            { "nume_P_ORDERSTATUS", odrStat.AsInt() },
            { "nvar_P_DELFLAG", delFlag },
            { "nume_P_CANCEL_UNUM", uNumOrdNo },
        };

        var payInfo = payService.GetOrderPayInfo_AllUser(paramList2);

        var resultList = new Dictionary<string, object>();
        resultList.Add("orderGoodsList", list);
        resultList.Add("payInfo", payInfo);

        var returnJsonData = JsonConvert.SerializeObject(resultList);
        context.Response.ContentType = "text/plain";
        context.Response.Write(returnJsonData);
    }

    //[판매사]주문취소내역 조회
    protected void GetOrdCancelList_A(HttpContext context)
    {
        string svidUser = context.Request.Form["SvidUser"].AsText();
        string orderStatus = context.Request.Form["OrderStatus"].AsText();
        string payway = context.Request.Form["PayWay"].AsText();
        string todateB = context.Request.Form["TodateB"].AsText();
        string todateE = context.Request.Form["TodateE"].AsText();
        string buyComp = context.Request.Form["BuyComp"].AsText();
        int pageNo = context.Request.Form["PageNo"].AsInt();
        int pageSize = context.Request.Form["PageSize"].AsInt();


        var paramList = new Dictionary<string, object>{
            {"nvar_P_SVID_USER", svidUser},
            {"nvar_P_TODATEB",  todateB },
            {"nvar_P_TODATEE", todateE },
            {"nvar_P_PAYWAY", payway },
            {"nvar_P_STATUS", orderStatus },
            {"nvar_P_BUYCOMPANY", buyComp },
            {"nume_P_PAGENO", pageNo },
            {"nume_P_PAGESIZE", pageSize }
        };

        var list = orderService.GetOrderCancelHistoryList(paramList);

        if (list != null)
        {
            if (list.Count > 0)
            {
                list.ToList().ForEach(s => s.GoodsInfo = "[" + s.BrandName + "]" + s.GoodsFinalName + "<br/>" + s.GoodsOptionSummaryValues);
            }
        }

        var returnJsonData = JsonConvert.SerializeObject(list);
        context.Response.ContentType = "text/plain";
        context.Response.Write(returnJsonData);
    }

    //[관리자]주문취소내역 조회
    protected void GetOrdCancelList_Admin(HttpContext context)
    {
        string svidUser = context.Request.Form["SvidUser"].AsText();
        string orderStatus = context.Request.Form["OrderStatus"].AsText();
        string payway = context.Request.Form["PayWay"].AsText();
        string todateB = context.Request.Form["TodateB"].AsText();
        string todateE = context.Request.Form["TodateE"].AsText();
        string buyComp = context.Request.Form["BuyComp"].AsText();
        string saleComp = context.Request.Form["SaleComp"].AsText();
        string status = context.Request.Form["Status"].AsText();
        int pageNo = context.Request.Form["PageNo"].AsInt();
        int pageSize = context.Request.Form["PageSize"].AsInt();


        var paramList = new Dictionary<string, object>{
            {"nvar_P_SVID_USER", svidUser},
            {"nvar_P_TODATEB",  todateB },
            {"nvar_P_TODATEE", todateE },
            {"nvar_P_PAYWAY", payway },
            {"nvar_P_STATUS", orderStatus },
            {"nvar_P_BUYCOMPANY", buyComp },
            {"nvar_P_SALECOMPANY", saleComp },
            {"nume_P_PAGENO", pageNo },
            {"nume_P_PAGESIZE", pageSize }
        };

        var list = orderService.GetOrderCancelHistoryList_Admin(paramList);

        if (list != null)
        {
            if (list.Count > 0)
            {
                list.ToList().ForEach(s => s.GoodsInfo = "[" + s.BrandName + "]" + s.GoodsFinalName + "<br/>" + s.GoodsOptionSummaryValues);
            }
        }

        var returnJsonData = JsonConvert.SerializeObject(list);
        context.Response.ContentType = "text/plain";
        context.Response.Write(returnJsonData);
    }

    // 주문하기 수량값 변경
    public void UpdateOrderTryQty(HttpContext context)
    {

        int ordertryNo = context.Request.Form["OrderTryNo"].AsInt();
        int qty = context.Request.Form["Qty"].AsInt();
        string compCode = context.Request.Form["CompCode"].AsText();
        string saleCompCode = context.Request.Form["SaleCompCode"].AsText();
        string dongshinCheck = context.Request.Form["DongshinCheck"].AsText("N");
        string freeCompYN = context.Request.Form["FreeCompanyYN"].AsText();
        string svidUser = context.Request.Form["SvidUser"].AsText();
        var paramList = new Dictionary<string, object> {
            {"nume_P_UNUM_ORDERTRYNO", ordertryNo},
            {"nume_P_QTY", qty},
            {"nvar_P_COMPCODE", compCode},
            {"nvar_P_SALECOMPCODE", saleCompCode},
            {"nvar_P_BDONGSHINCHECK",  dongshinCheck},
            {"nvar_P_FREECOMPANYYN", freeCompYN},
            {"nvar_P_SVID_USER", svidUser},
      };

        orderService.UpdateOrdTryQtyUpdate(paramList);
        context.Response.ContentType = "text/json";
        context.Response.Write("Success");
    }

    //구매사와 연결된 판매사 PG 정보 조회
    protected string GetOrdPgLoanInfo(HttpContext context)
    {
        string saleCompNo = context.Request.Form["SaleCompNo"].AsText();
        string saleCompCode = context.Request.Form["SaleCompCode"].AsText();
        string myCompCode = context.Request.Form["MyCompCode"].AsText();

        UserService userService = new UserService();

        var paramList = new Dictionary<string, object> {
            {"nvar_P_COMPANY_CODE", saleCompCode},
            {"nvar_P_COMPANY_NO", saleCompNo},
            {"nvar_P_MAPPCOMPANY_CODE", myCompCode}
        };

        var info = orderService.GetOrderPGLoanInfo(paramList);
        string bulkBankNo = string.Empty;

        if (info != null)
        {
            bulkBankNo = info.BulkBankNo; //고정 가상계좌 번호
        }

        return bulkBankNo;
    }

    //주문취소 신청 시 배송단계로 넘어간 상품이 있는 지 체크
    protected void GetOrdDeliveryCheck(HttpContext context)
    {
        string svidUser = context.Request.Form["SvidUser"].AsText();
        string ordCodeNo = context.Request.Form["OrdCodeNo"].AsText();

        var paramList = new Dictionary<string, object> {
            {"nvar_P_SVID_USER", svidUser},
            {"nvar_P_ORDERCODENO", ordCodeNo}
        };

        var info = orderService.GetOrdDeliveryCheck(paramList);

        context.Response.ContentType = "text/plain";
        context.Response.Write(info);
    }

    protected void UpdatePayBillCheck(HttpContext context)
    {
        var orderCodeNo = context.Request.Form["OrderCodeNo"].AsText();
        var billSelectDate = context.Request.Form["BillSelectDate"].AsText();
        var billEmail = context.Request.Form["BillEmail"].AsText();

        var paramList = new Dictionary<string, object> {
            {"nvar_P_ORDERCODENO", orderCodeNo},
            {"nvar_P_BILLSELECTDATE", billSelectDate},
            {"nvar_P_BILLEMAIL", billEmail}
        };

        orderService.UpdatePayBillCheck(paramList);
        HttpContext.Current.Response.ContentType = "text/plain";
        //HttpContext.Current.Response.Write("{\"Result\": \"OK\"}");
        HttpContext.Current.Response.Write("OK");
    }

    //주문 소속 조회 사용중지 사용중 업데이트 
    protected void UpdateBelongUse(HttpContext context)
    {
        OrderService orderService = new OrderService();

        string belongCode = context.Request.Form["BelongCode"].AsText();
        string updateFlag = context.Request.Form["UpdateFlag"].AsText();

        var paramList = new Dictionary<string, object>() {
            {"nvar_P_ORDERBELONG_CODE", belongCode }
            ,{"char_P_DELFLAG", updateFlag}
        };

        orderService.UpdateBelongUse(paramList);

        context.Response.ContentType = "text/plain";
        context.Response.Write("OK");
    }

    //주문 지역 연동 사용중지 사용중 업데이트 
    protected void UpdateAreaUse(HttpContext context)
    {
        OrderService orderService = new OrderService();

        string areaCode = context.Request.Form["AreaCode"].AsText();
        string updateFlag = context.Request.Form["UpdateFlag"].AsText();

        var paramList = new Dictionary<string, object>() {
           {"char_P_DELFLAG", updateFlag}
           , {"nvar_P_ORDERAREA_CODE", areaCode }
        };

        orderService.UpdateAreaUse(paramList);

        context.Response.ContentType = "text/plain";
        context.Response.Write("OK");
    }


    protected void GetPayBillCheck(HttpContext context)
    {
        var orderCodeNo = context.Request.Form["OrderCodeNo"].AsText();

        var paramList = new Dictionary<string, object>() {
            {"nvar_P_ORDERCODENO", orderCodeNo},
        };

        var list = orderService.GetPayBillCheck(paramList);
        var returnjsonData = JsonConvert.SerializeObject(list);
        HttpContext.Current.Response.ContentType = "text/json";
        HttpContext.Current.Response.Write(returnjsonData);
    }

    protected void GetOrderBelongPopupList(HttpContext context)
    {
        OrderService OrderService = new OrderService();
        var searchKeyword = context.Request.Form["SearchKeyword"].AsText();

        var paramList = new Dictionary<string, object>
        {
            {"nvar_P_ORDERBELONG_NAME", searchKeyword},
        };

        var list = OrderService.GetOrderBelongPopupList(paramList);


        var returnjsonData = JsonConvert.SerializeObject(list);
        HttpContext.Current.Response.ContentType = "text/json";
        HttpContext.Current.Response.Write(returnjsonData);
    }

    protected void SaveOrderArea(HttpContext context)
    {
        OrderService OrderService = new OrderService();
        var orderBelongCode = context.Request.Form["OrderBelongCode"].AsText();
        var orderAreaCode = context.Request.Form["OrderAreaCode"].AsText();
        var orderAreaName = context.Request.Form["OrderAreaName"].AsText();
        var remark = context.Request.Form["Remark"].AsText();

        var paramList = new Dictionary<string, object>
        {
            {"nvar_P_ORDERBELONG_CODE ", orderBelongCode},
            {"nvar_P_ORDERAREA_CODE", orderAreaCode},
            {"nvar_P_ORDERAREA_NAME", orderAreaName},
            {"nvar_P_REMARK", remark},
            {"reVa_P_RETURN",0 },
        };

        var returnData = OrderService.SaveOrderArea(paramList);

        HttpContext.Current.Response.ContentType = "text/plain";
        HttpContext.Current.Response.Write(returnData);
    }

    //[관리자]계산서발행(구매사)
    protected void OrderBillList_Admin(HttpContext context)
    {
        string sviduser = context.Request.Form["SvidUser"].AsText();
        string toDateB = context.Request.Form["ToDateB"].AsText();
        string toDateE = context.Request.Form["ToDateE"].AsText();
        string buyCompNm = context.Request.Form["BuyCompNm"].AsText(); //구매사명
        string saleCompNm = context.Request.Form["SaleCompNm"].AsText(); //판매사명
        int pageNo = context.Request.Form["PageNo"].AsInt();
        int pageSize = context.Request.Form["PageSize"].AsInt();

        var paramList = new Dictionary<string, object> {
            {"nvar_P_SVID_USER", sviduser},
            {"nvar_P_TODATEB", toDateB},
            {"nvar_P_TODATEE", toDateE},
            {"nvar_P_BUYCOMPANY", buyCompNm},
            {"nvar_P_SALECOMPANY", saleCompNm},
            {"inte_P_PAGENO", pageNo},
            {"inte_P_PAGESIZE", pageSize},
        };

        var list = orderService.OrderBillList_Admin(paramList);

        var returnjsonData = JsonConvert.SerializeObject(list);
        context.Response.ContentType = "text/plain";
        context.Response.Write(returnjsonData);
    }

    //[판매사]계산서발행
    protected void OrderBillList_A(HttpContext context)
    {
        string sviduser = context.Request.Form["SvidUser"].AsText();
        string toDateB = context.Request.Form["ToDateB"].AsText();
        string toDateE = context.Request.Form["ToDateE"].AsText();
        string buyCompNm = context.Request.Form["BuyCompNm"].AsText(); //구매사명
        int pageNo = context.Request.Form["PageNo"].AsInt();
        int pageSize = context.Request.Form["PageSize"].AsInt();

        var paramList = new Dictionary<string, object> {
            {"nvar_P_SVID_USER", sviduser},
            {"nvar_P_TODATEB", toDateB},
            {"nvar_P_TODATEE", toDateE},
            {"nvar_P_BUYCOMPANY", buyCompNm},
            {"inte_P_PAGENO", pageNo},
            {"inte_P_PAGESIZE", pageSize},
        };

        var list = orderService.OrderBillList_A(paramList);

        var returnjsonData = JsonConvert.SerializeObject(list);
        context.Response.ContentType = "text/plain";
        context.Response.Write(returnjsonData);
    }

    // 여신 정보 조회
    protected void GetGoodsLoanInfo(HttpContext context)
    {
        string svid_user = context.Request.Form["SvidUser"].AsText();

        var paramList = new Dictionary<string, object> {
            { "nvar_P_SVID_USER", svid_user },
        };

        var info = orderService.GetGoodsLoanInfo(paramList);

        var returnjsonData = JsonConvert.SerializeObject(info);
        HttpContext.Current.Response.ContentType = "text/json";
        HttpContext.Current.Response.Write(returnjsonData);
    }

    protected void GetMonthDeadLineList(HttpContext context)
    {
        OrderService OrderService = new OrderService();

        string svidUser = context.Request.Form["SvidUser"].AsText();
        //int orderEndType = context.Request.Form["OrderEndType"].AsInt();
        string startDate = context.Request.Form["TodateB"].AsText();
        string endDate = context.Request.Form["TodateE"].AsText();
        //int pageNo = context.Request.Form["PageNo"].AsInt();
        //int PageSize = context.Request.Form["PageSize"].AsInt();


        var paramList = new Dictionary<string, object> {
            {"nvar_P_SVID_USER", svidUser},
            //{"inte_P_ORDERENDTYPE", orderEndType},
            {"nvar_P_SEARCHSTARTDATE", startDate},
            {"nvar_P_SEARCHENDDATE", endDate},
            //{"inte_P_PAGENO", pageNo},
            //{"inte_P_PAGESIZE", PageSize},
        };

        var list = OrderService.GetMonthDeadLineList(paramList);


        var returnjsonData = JsonConvert.SerializeObject(list);
        HttpContext.Current.Response.ContentType = "text/json";
        HttpContext.Current.Response.Write(returnjsonData);
    }

    //(관리자)구매사정산내역조회 - 마감승인 목록 조회
    protected void GetMonthDeadLineList_Admin(HttpContext context)
    {
        OrderService OrderService = new OrderService();

        string compCode = context.Request.Form["CompCode"].AsText(); //구매사코드
        int orderEndType = context.Request.Form["OrderEndType"].AsInt(); //마감유형
        string startDate = context.Request.Form["TodateB"].AsText(); //
        string endDate = context.Request.Form["TodateE"].AsText();
        var paramList = new Dictionary<string, object> {
            {"nvar_P_BUYCOMPANY_CODE", compCode},
            {"nume_P_ORDERENDTYPE", orderEndType},
            {"nvar_P_SEARCHSTARTDATE", startDate},
            {"nvar_P_SEARCHENDDATE", endDate},
        };

        var list = OrderService.GetMonthDeadLineList_Admin(paramList);

        var returnjsonData = JsonConvert.SerializeObject(list);
        HttpContext.Current.Response.ContentType = "text/json";
        HttpContext.Current.Response.Write(returnjsonData);
    }

    //(구매사) 구매사 대금결제 내역조회 [이월요청]
    protected void UpdateOrderNextEnd(HttpContext context)
    {
        string svid_user = context.Request.Form["SvidUser"].AsText();
        string Unum_OrderNo_Arr = context.Request.Form["Unum_OrderNo_Arr"].AsText();
        string orderNextEndReason = context.Request.Form["OrderNextEndReason"].AsText();
        string orderNextEndConfirm = context.Request.Form["OrderNextEndConfirm"].AsText();
        string flag = context.Request.Form["P_Flag"].AsText();

        var paramList = new Dictionary<string, object> {
            {"nvar_P_SVID_USER", svid_user},
            {"nvar_P_UNUM_ORDERNO_ARR", Unum_OrderNo_Arr},
            {"nvar_P_ORDERNEXTENDREASON", orderNextEndReason},
            {"nvar_P_ORDERNEXTENDCONFIRM", orderNextEndConfirm},
            {"nvar_P_FLAG", flag},

        };

        orderService.UpdateOrderNextEnd(paramList);

        context.Response.ContentType = "text/plain";
        context.Response.Write("Success");
    }

    //(구매사) 구매사 대금결제 내역조회 [마감요청]
    protected void UpdateOrderEndReq(HttpContext context)
    {
        string svid_user = context.Request.Form["SvidUser"].AsText();
        string Unum_OrderNo_Arr = context.Request.Form["Unum_OrderNo_Arr"].AsText();
        string compCode = context.Request.Form["CompCode"].AsText();
        string flag = context.Request.Form["P_Flag"].AsText();

        var paramList = new Dictionary<string, object> {
            {"nvar_P_SVID_USER", svid_user},
            {"nvar_P_UNUM_ORDERNO_ARR", Unum_OrderNo_Arr},
            {"nvar_P_COMPANY_CODE", compCode},
            {"nvar_P_FLAG", flag},

        };
        //logger.DebugFormat("svid_user={0}, Unum_OrderNo_Arr={1}, flag={2}", svid_user, Unum_OrderNo_Arr, flag);
        orderService.UpdateOrderEndReq(paramList);

        context.Response.ContentType = "text/plain";
        context.Response.Write("Success");
    }

    private void SendSMS(HttpContext context)
    {

        UserService UserService = new UserService();
        var paramList = new Dictionary<string, object>
        {
            {"nvar_P_TYPE", "ORDER"},
        };

        var list = UserService.GetSMSUserList(paramList);
        if (list != null)
        {
            string incomingUser = string.Empty;

            foreach (var item in list)
            {
                incomingUser += item.Name + "^" + Crypt.AESDecrypt256(item.PhoneNo).Replace("-", "") + "|";
            }
            string orderCodeNo = context.Request.Form["OrderCodeNo"].AsText();
            decimal amt = context.Request.Form["Amt"].AsDecimal();
            if (!string.IsNullOrWhiteSpace(incomingUser))
            {
                var paramList2 = new Dictionary<string, object>
                {
                    {"nvar_P_SUBJECT", "제목"},
                    {"nvar_P_DEST_INFO", incomingUser.Substring(0, incomingUser.Length-1)},
                    {"nvar_P_SMS_MSG",  "[주문의 건]\r\n"+ orderCodeNo+"(" + amt.ToString("N0") + "원)"},
                };

                UserService.OrderSMSInsert(paramList2);
            }

        }


        context.Response.ContentType = "text/plain";
        context.Response.Write("Success");

    }

    private void SendMMS(HttpContext context)
    {

        UserService UserService = new UserService();
        var paramList = new Dictionary<string, object>
        {
            {"nvar_P_TYPE", "ORDER"},
        };

        var list = UserService.GetSMSUserList(paramList);
        if (list != null)
        {
            string incomingUser = string.Empty;

            foreach (var item in list)
            {
                incomingUser += item.Name + "^" + Crypt.AESDecrypt256(item.PhoneNo).Replace("-", "") + "|";
            }
            string orderCodeNo = context.Request.Form["OrderCodeNo"].AsText();
            string buyCompName = context.Request.Form["BuyCompName"].AsText();
            decimal amt = context.Request.Form["Amt"].AsDecimal();
            if (!string.IsNullOrWhiteSpace(incomingUser))
            {
                var paramList2 = new Dictionary<string, object>
                {
                    {"nvar_P_SUBJECT", "[상품 주문 접수]"},
                    {"nvar_P_DEST_INFO", incomingUser.Substring(0, incomingUser.Length-1)},
                    {"nvar_P_MSG",   "[상품 주문 접수]\r\n주문번호 : "+ orderCodeNo+"\r\n회사명 : "+ buyCompName +"\r\n금액 : " + amt.ToString("N0") + "원" + "\r\n주문 검토 후 발송 진행해주시기 바랍니다."},
                };

                UserService.OrderMMSInsert(paramList2);
            }

        }


        context.Response.ContentType = "text/plain";
        context.Response.Write("Success");

    }

    //주문취소(신용카드/실시간계좌이체) 요청시 주문번호 상품들 관련 금액(배송비 처리 위해) 정보 조회
    protected void GetOrderCancelPriceData(HttpContext context)
    {
        OrderService orderService = new OrderService();

        string orderCodeNo = context.Request.Form["OrdCodeNo"].AsText();
        int uNumOrdNo = context.Request.Form["UNumOrdNo"].AsInt();

        var paramList = new Dictionary<string, object> {
            {"nvar_P_ORDERCODENO", orderCodeNo},
            {"nume_P_UNUM_ORDERNO", uNumOrdNo}
        };

        var list = orderService.GetOrderCancelPriceData(paramList);

        var returnjsonData = JsonConvert.SerializeObject(list);
        HttpContext.Current.Response.ContentType = "text/json";
        HttpContext.Current.Response.Write(returnjsonData);
    }

    //(관리자)주문상세팝업에서 직송변경 기능
    protected void UpdateDlvrGubunChg(HttpContext context)
    {
        OrderService orderService = new OrderService();

        int uNumOrdNo = context.Request.Form["UnumOrdNo"].AsInt();
        string OrdCodeNo = context.Request.Form["OrdCodeNo"].AsText();
        string GdsFinCtgrCode = context.Request.Form["GdsFinCtgrCode"].AsText();
        string GdsGrpCode = context.Request.Form["GdsGrpCode"].AsText();
        string GdsCode = context.Request.Form["GdsCode"].AsText();
        string OrdSaleComCode = context.Request.Form["OrdSaleComCode"].AsText();

        var paramList = new Dictionary<string, object> {
            {"nume_P_UNUM_ORDERNO", uNumOrdNo},
            {"nvar_P_ORDERCODENO", OrdCodeNo},
            {"nvar_P_GOODSFINALCATEGORYCODE", GdsFinCtgrCode},
            {"nvar_P_GOODSGROUPCODE", GdsGrpCode},
            {"nvar_P_GOODSCODE", GdsCode},
            {"nvar_P_ORDERSALECOMPANY_CODE", OrdSaleComCode},
        };

        orderService.UpdateDlvrGubunChg(paramList); //직송변경

        context.Response.ContentType = "text/plain";
        context.Response.Write("Success");
    }

    //(관리자)주문상세팝업에서 주문처리초기화 기능
    protected void UpdateOrderStatReset(HttpContext context)
    {
        OrderService orderService = new OrderService();

        int uNumOrdNo = context.Request.Form["UnumOrdNo"].AsInt();
        string OrdCodeNo = context.Request.Form["OrdCodeNo"].AsText();
        string GdsCode = context.Request.Form["GdsCode"].AsText();

        var paramList = new Dictionary<string, object> {
            {"nume_P_UNUM_ORDERNO", uNumOrdNo},
            {"nvar_P_ORDERCODENO", OrdCodeNo},
            {"nvar_P_GOODSCODE", GdsCode}
        };

        orderService.UpdateOrderStatReset(paramList); //주문처리초기화

        context.Response.ContentType = "text/plain";
        context.Response.Write("Success");
    }

    //(관리자)주문상세팝업에서 CD변경 기능
    protected void UpdateDlvrGubunChgCD(HttpContext context)
    {
        OrderService orderService = new OrderService();

        int uNumOrdNo = context.Request.Form["UnumOrdNo"].AsInt();
        string OrdCodeNo = context.Request.Form["OrdCodeNo"].AsText();
        string GdsCode = context.Request.Form["GdsCode"].AsText();

        var paramList = new Dictionary<string, object> {
            {"nume_P_UNUM_ORDERNO", uNumOrdNo},
            {"nvar_P_ORDERCODENO", OrdCodeNo},
            {"nvar_P_GOODSCODE", GdsCode}
        };

        orderService.UpdateDlvrGubunChgCD(paramList); //CD변경

        context.Response.ContentType = "text/plain";
        context.Response.Write("Success");
    }

    //(관리자)주문내역조회 배송,입고확인기능
    protected void UpdateDeliPutDate(HttpContext context)
    {
        OrderService orderService = new OrderService();

        string ProcessType = context.Request.Form["Type"].AsText();
        string OrderCodeNo = context.Request.Form["OrdCodeNo"].AsText();
        string GoodsCode = context.Request.Form["GdsCode"].AsText();
        string ParamDate = context.Request.Form["ChkDate"].AsText();

        var paramList = new Dictionary<string, object> {
            {"nvar_P_PROCESSTYPE", ProcessType}, //프로세스타입
            {"nvar_P_ORDERCODENO", OrderCodeNo},
            {"nvar_P_GOODSCODE", GoodsCode},
            {"nvar_P_CHKDATE", ParamDate},
        };

        orderService.UPDATE_DELIPUTDATE(paramList); //CD변경

        context.Response.ContentType = "text/plain";
        context.Response.Write("Success");
    }

    //관리자 주문연동관리 주문소속 조회 저장 
    protected void UpdatePopOrderBelong(HttpContext context)
    {
        OrderService orderService = new OrderService();

        string ORDERBELONG_CODE = context.Request.Form["OrderBelong_Code"].AsText();
        string ORDERBELONG_NAME = context.Request.Form["OrderBelong_Name"].AsText();
        string REMARK = context.Request.Form["Remark"].AsText();
        string DELFLAG = context.Request.Form["Delflag"].AsText();

        var paramList = new Dictionary<string, object> {
          {"nvar_P_ORDERBELONG_CODE", ORDERBELONG_CODE },
          {"nvar_P_ORDERBELONG_NAME", ORDERBELONG_NAME },
          {"nvar_P_REMARK", REMARK },
          {"nvar_P_DELFLAG",DELFLAG },
        };

        orderService.OrderBelong_Update(paramList);

        context.Response.ContentType = "text/plain";
        context.Response.Write("OK");
    }

    //관리자 주문소속조회 팝업 
    protected void GetOrderBelongMainPopup_Admin(HttpContext context)
    {
        OrderService orderService = new OrderService();

        string orderBelong_Code = context.Request.Form["OrderBelong_Code"].AsText();


        var paramList = new Dictionary<string, object> {
            {"nvar_P_ORDERBELONG_CODE", orderBelong_Code},

        };

        var list = orderService.GetOrderBelongInfo_Admin(paramList);

        var returnjsonData = JsonConvert.SerializeObject(list);
        HttpContext.Current.Response.ContentType = "text/json";
        HttpContext.Current.Response.Write(returnjsonData);
    }
    
    //메인 
    protected void GetBuyCompMonthProfitList(HttpContext context)
    {
        string gubun = context.Request.Form["Gubun"].AsText();
        string companyName = context.Request.Form["CompanyName"].AsText();

        var paramList = new Dictionary<string, object>
        {
            {"nvar_P_GUBUN",  gubun},
            {"nvar_P_COMPANY_NAME",  companyName},
        };

        var list = orderService.GetBuyCompMonthProfitList(paramList);

        var returnjsonData = JsonConvert.SerializeObject(list);
        HttpContext.Current.Response.ContentType = "text/json";
        HttpContext.Current.Response.Write(returnjsonData);
    }

    public bool IsReusable
    {
        get
        {
            return false;
        }
    }
}