<%@ WebHandler Language="C#" Class="PayHandler" %>

using System;
using System.Web;
using System.Collections.Generic;
using Newtonsoft.Json;
using Urian.Core;
using SocialWith.Biz.Comapny;

public class PayHandler : IHttpHandler
{
    SocialWith.Biz.Pay.PayService payService = new SocialWith.Biz.Pay.PayService();
    protected CompanyService companyService = new CompanyService();
        

    public void ProcessRequest(HttpContext context)
    {
        string method = context.Request.Form["Method"].AsText();

        switch (method)
        {
            case "PayInsert":
                PayInsert(context);
                break;
            case "GetProfitList":
                GetProfitList(context);
                break;
            case "ProfitCash_Admin":
                ProfitCash_Admin(context);
                break;
            case "GetAdminProfitList":
                GetAdminProfitList(context);
                break;
            case "GetProfitList_Admin":
                GetProfitList_Admin(context);
                break;
            case "GetAdminCashList":
                GetAdminCashList(context);
                break;
            case "GetAdminSubBAProfitList":  //정산내역 조회(매출내역)
                GetAdminSubBAProfitList(context);
                break;
            case "GetAdminBillList":  //[관리자]전자세금계산서발행현황(판매사)
                GetAdminBillList(context);
                break;
            case "GetAdminSubBillList":  //전자세금계산서발행현황(판매사)
                GetAdminSubBillList(context);
                break;
            case "AdminPayTaxUpdate":  //전자세금계산서발행 적용
                AdminPayTaxUpdate(context);
                break;
            case "AdminSubPayTaxUpdate":  //전자세금계산서발행 적용
                AdminSubPayTaxUpdate(context);
                break;
            case "GetProfitSummaryList_A":  //[판매사]정산요약 - 정산목록 조회
                GetProfitSummaryList_A(context);
                break;

            case "GetProfitSummary_D_A":  //[판매사] 정산요약 - 정산상세
                GetProfitSummary_D_A(context);
                break;
            case "GetProfitSummaryList_Admin":  //[관리자]정산요약 - 정산목록 조회
                GetProfitSummaryList_Admin(context);
                break;
            case "GetProfitSummary_D_Admin":  //[관리자] 정산요약 - 정산상세
                GetProfitSummary_D_Admin(context);
                break;
            case "AdminPayBill": //[관리자]세금계산서 발행
                AdminPayBillInsert(context);
                break;
            case "BillHistoryList_A":  //[판매사]전자세금계산서
                GetBillHistoryAdminSubList(context);
                break;
            case "BillHistoryInfo_A":  //[판매사]전자세금계산서(팝업)
                GetBillHistoryInfo_A(context);
                break;

            case "BillHistoryList_Admin":  //[관리자]전자세금계산서
                GetBillHistoryAdminList(context);
                break;
            case "BillHistoryInfo_Admin":  //[관리자]전자세금계산서(팝업)
                GetBillHistoryInfo_Admin(context);
                break;
            case "AdminDepositConfirmUpdate":  //[관리자]입금내역조회 입금확인
                AdminDepositConfirmUpdate(context);
                break;

            case "OrderBillCheck":  //[관리자]입금내역조회 입금확인
                OrderBillCheck(context);
                break;

            case "OrderBillListSch":  //입금내역조회 입금확인
                OrderBillListSch(context);
                break;

            case "OrderBillListSchPop":  //입금내역조회 입금확인
                OrderBillListSchPop(context);
                break;
            case "OrderBillDeadLine":  //[관리자]마감 내역 조회
                OrderBillDeadLine(context);
                break;
            case "OrderBillPaymentList":  //[구매사]대금결제 조회
                OrderBillPaymentList(context);
                break;
            case "LoanDepositList":  //여신 무 관리
                LoanDepositList(context);
                break;
            case "LoanDepositSalesConfirm":  //여신 무 관리
                LoanDepositSalesConfirm(context);
                break;
            case "OrderEndDepositInsert": //여신 무 관리 재무팀 입금
                OrderEndDepositInsert(context);
                break;

            case "OrderBillType8":              //구매사 대금결제내역
                OrderBillType8(context);
                break;

            case "MonthOrderEnd_Admin":         //관리자 쪽 구매사 대금결제내역
                MonthOrderEnd_Admin(context);
                break;
            case "OutStanding":         //구매사 대금결제내역
                OutStanding(context);
                break;

            case "Payok_OrderEnd":         //관리자 여신 무 관리 확인내역 조회
                Payok_OrderEnd(context);
                break;

            case "OrderEnd_DTL":         //관리자 여신 무 관리 상세
                OrderEnd_DTL(context);
                break;
            case "SaveBLoanOrder": //(구매사) PO별 묶음 결제 사용하는 구매사의 주문 저장
                SaveBLoanOrder(context);
                break;
            case "SavePayNoPassbook": //무통장입금 결제
                SavePayNoPassbook(context);
                break;
            case "UpdateBillDate_Admin": //세금계산서 발행 중지/요청
                UpdateBillDateAdmin(context);
                break;
            case "GetOrderBillCompList_Admin":  //[관리자] 세금계산서 매출내역 RMP/판매사 조회
                GetOrderBillCompList(context);
                break;
            case "GetOrderBillIssueList_Admin": // [관리자] 세금계산서 발행할 리스트 조회
                GetOrderBillIssueList(context);
                break;
            case "GetAdminBillStatus_A":  //[관리자] 정산내역조회 전자세금 계산서 발행내역 최종현황 조회
                GetAdminBillStatus_A(context);
                break;


        }
    }

    protected void PayInsert(HttpContext context)
    {
        string moid = context.Request.Form["OrderCodeNo"].AsText();
        string merchantID = context.Request.Form["Pg_Mid"].AsText();
        string merchantKey = context.Request.Form["Pg_Midkey"].AsText();
        string hash_String = context.Request.Form["Pg_Hash"].AsText();
        string buyerName = context.Request.Form["BuyerName"].AsText();
        string buyerTel = context.Request.Form["BuyerTel"].AsText();
        string buyerEmail = context.Request.Form["BuyeMail"].AsText();
        string goodsName = context.Request.Form["GoodsName"].AsText();
        string goodsCnt = context.Request.Form["Goodsqty"].AsText();
        string price = context.Request.Form["Amt"].AsText();
        string PayMethod = context.Request.Form["PayWay"].AsText();
        string SubjectDate = context.Request.Form["SubjectDate"].AsText();
        string vbankExpDate = context.Request.Form["VbankExpDate"].AsText(); //입금기간만료일
        string vbankDueDate = context.Request.Form["VbankDueDate"].AsText(); //입금예정일

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
             {"nvar_P_GOODSQTY",goodsCnt},
             {"nvar_P_AMT",price},
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
             {"nvar_P_VBANKDATE",vbankExpDate},
             {"nvar_P_CASHBILLTYPE",""},
             {"nvar_P_CASHBILLTYPECONFIRMNO",""},
             {"nvar_P_BANKTYPENAME",""},
             {"nvar_P_PAYSUCESSYN",""},
             {"nvar_P_SUBJECTDATE",SubjectDate},
             {"nvar_P_PAYCONFIRMNO",""},
             {"nvar_P_PAYRESULTCODE",""},
             {"nvar_P_PAYRESULT",""},
             {"nvar_P_PAYCONFIRMDATE",""},
             {"nvar_P_VBANKDUEDATE",vbankDueDate}
        };

        payService.PayInsert(paramList);
        context.Response.ContentType = "text/plain";
        context.Response.Write("{\"Result\": \"OK\"}");

    }

    protected void GetProfitList(HttpContext context)
    {

        string svidUser = context.Request.Form["SvidUser"].AsText();
        string startDate = context.Request.Form["StartDate"].AsText();
        string endDate = context.Request.Form["EndDate"].AsText();
        string svidCompNo = context.Request.Form["SvidCompNo"].AsText();
        string buyerCompName = context.Request.Form["BuyerCompName"].AsText();
        string payway = context.Request.Form["Payway"].AsText();
        string paycash = context.Request.Form["PayCash"].AsText();
        int pageNo = context.Request.Form["PageNo"].AsInt();
        int pageSize = context.Request.Form["PageSize"].AsInt();
        var paramList = new Dictionary<string, object>
        {
            { "nvar_P_SVID_USER", svidUser},
            { "nvar_P_STARTDATE", startDate},
            { "nvar_P_ENDDATE", endDate},
            { "nvar_P_SVID_COMPANYNO", svidCompNo},
            { "nvar_P_BUYERCOMPANY_NAME", buyerCompName},
            { "nvar_P_PAYWAY", payway},
            { "nvar_P_PAYCASH", paycash},
            { "inte_P_PAGENO", pageNo},
            { "inte_P_PAGESIZE", pageSize},
        };

        var list = payService.GetProfitList(paramList);

        var returnjsonData = JsonConvert.SerializeObject(list);
        HttpContext.Current.Response.ContentType = "text/json";
        HttpContext.Current.Response.Write(returnjsonData);

    }

    //admin 입금내역 조회(현금)
    protected void ProfitCash_Admin(HttpContext context)
    {

        string svidUser = context.Request.Form["SvidUser"].AsText();
        string startDate = context.Request.Form["StartDate"].AsText();
        string endDate = context.Request.Form["EndDate"].AsText();
        string svidCompNo = context.Request.Form["SvidCompNo"].AsText();
        string buyerCompName = context.Request.Form["BuyerCompName"].AsText();
        string saleCompName = context.Request.Form["saleCompName"].AsText();
        string payway = context.Request.Form["Payway"].AsText();
        string paycash = context.Request.Form["PayCash"].AsText();
        int pageNo = context.Request.Form["PageNo"].AsInt();
        int pageSize = context.Request.Form["PageSize"].AsInt();
        var paramList = new Dictionary<string, object>
        {
            { "nvar_P_SVID_USER", svidUser},
            { "nvar_P_STARTDATE", startDate},
            { "nvar_P_ENDDATE", endDate},
            { "nvar_P_SVID_COMPANYNO", svidCompNo},
            { "nvar_P_SALECOMPANY_NAME", saleCompName},
            { "nvar_P_BUYERCOMPANY_NAME", buyerCompName},
            { "nvar_P_PAYWAY", payway},
            { "nvar_P_PAYCASH", paycash},
            { "inte_P_PAGENO", pageNo},
            { "inte_P_PAGESIZE", pageSize},
        };

        var list = payService.ProfitCash_Admin(paramList);

        var returnjsonData = JsonConvert.SerializeObject(list);
        HttpContext.Current.Response.ContentType = "text/json";
        HttpContext.Current.Response.Write(returnjsonData);

    }

    protected void GetAdminProfitList(HttpContext context)
    {
        string startDate = context.Request.Form["StartDate"].AsText();
        string endDate = context.Request.Form["EndDate"].AsText();
        string buyerCompName = context.Request.Form["BuyerCompName"].AsText();
        string payway = context.Request.Form["Payway"].AsText();
        int pageNo = context.Request.Form["PageNo"].AsInt();
        int pageSize = context.Request.Form["PageSize"].AsInt();
        var paramList = new Dictionary<string, object>
        {
            { "nvar_P_STARTDATE", startDate},
            { "nvar_P_ENDDATE", endDate},
            { "nvar_P_BUYERCOMPANY_NAME", buyerCompName},
            { "nvar_P_PAYWAY", payway},
            { "inte_P_PAGENO", pageNo},
            { "inte_P_PAGESIZE", pageSize},
        };

        var list = payService.GetProfitList(paramList);

        var returnjsonData = JsonConvert.SerializeObject(list);
        HttpContext.Current.Response.ContentType = "text/json";
        HttpContext.Current.Response.Write(returnjsonData);

    }

    protected void GetAdminCashList(HttpContext context)
    {
        string startDate = context.Request.Form["StartDate"].AsText();
        string endDate = context.Request.Form["EndDate"].AsText();
        string saleCompName = context.Request.Form["SaleCompName"].AsText();
        string buyerCompName = context.Request.Form["BuyerCompName"].AsText();
        string payway = context.Request.Form["Payway"].AsText();
        int pageNo = context.Request.Form["PageNo"].AsInt();
        int pageSize = context.Request.Form["PageSize"].AsInt();
        var paramList = new Dictionary<string, object>
        {
            { "nvar_P_SVID_USER", ""},
            { "nvar_P_STARTDATE", startDate},
            { "nvar_P_ENDDATE", endDate},
            { "nvar_P_SVID_COMPANYNO", ""},
            { "nvar_P_SALECOMPANY_NAME", saleCompName},
            { "nvar_P_BUYERCOMPANY_NAME", buyerCompName},
            { "nvar_P_PAYWAY", payway},
            { "inte_P_PAGENO", pageNo},
            { "inte_P_PAGESIZE", pageSize},
        };

        var list = payService.GetAdminCashList(paramList);

        var returnjsonData = JsonConvert.SerializeObject(list);
        HttpContext.Current.Response.ContentType = "text/json";
        HttpContext.Current.Response.Write(returnjsonData);

    }

    protected void GetAdminSubBAProfitList(HttpContext context)
    {
        string svidUser = context.Request.Form["SvidUser"].AsText();
        string startDate = context.Request.Form["StartDate"].AsText();
        string endDate = context.Request.Form["EndDate"].AsText();
        string svidCompNo = context.Request.Form["SvidCompNo"].AsText();
        string saleCompName = context.Request.Form["SaleCompName"].AsText();
        string buyerCompName = context.Request.Form["BuyerCompName"].AsText();
        string payway = context.Request.Form["Payway"].AsText();
        int pageNo = context.Request.Form["PageNo"].AsInt();
        int pageSize = context.Request.Form["PageSize"].AsInt();
        var paramList = new Dictionary<string, object>
        {
            { "nvar_P_SVID_USER", svidUser},
            { "nvar_P_STARTDATE", startDate},
            { "nvar_P_ENDDATE", endDate},
            { "nvar_P_SVID_COMPANYNO", svidCompNo},
            { "nvar_P_BUYERCOMPANY_NAME", buyerCompName},
            { "nvar_P_PAYWAY", payway},
            { "inte_P_PAGENO", pageNo},
            { "inte_P_PAGESIZE", pageSize},
        };

        var list = payService.GetAdminSubBAProfitList(paramList);

        var returnjsonData = JsonConvert.SerializeObject(list);
        HttpContext.Current.Response.ContentType = "text/json";
        HttpContext.Current.Response.Write(returnjsonData);

    }


    //[판매사]정산요약 - 목록
    protected void GetProfitSummaryList_A(HttpContext context)
    {
        string svidUser = context.Request.Form["SvidUser"].AsText();
        string startDate = context.Request.Form["StartDate"].AsText();
        string endDate = context.Request.Form["EndDate"].AsText();
        int pageNo = context.Request.Form["PageNo"].AsInt();
        int pageSize = context.Request.Form["PageSize"].AsInt();
        var paramList = new Dictionary<string, object>
        {
            { "nvar_P_SVID_USER", svidUser},
            { "nvar_P_STARTDATE", startDate},
            { "nvar_P_ENDDATE", endDate},
            { "inte_P_PAGENO", pageNo},
            { "inte_P_PAGESIZE", pageSize},
        };

        var list = payService.GetProfitSummaryList_A(paramList);

        var returnjsonData = JsonConvert.SerializeObject(list);
        HttpContext.Current.Response.ContentType = "text/json";
        HttpContext.Current.Response.Write(returnjsonData);

    }

    //[판매사] 정산내역 조회(정산상세)

    protected void GetProfitSummary_D_A(HttpContext context)
    {
        string svidUser = context.Request.Form["SvidUser"].AsText();
        string startDate = context.Request.Form["StartDate"].AsText();
        string endDate = context.Request.Form["EndDate"].AsText();

        var paramList = new Dictionary<string, object>
        {
            { "nvar_P_SVID_USER", svidUser},
            { "nvar_P_STARTDATE", startDate},
            { "nvar_P_ENDDATE", endDate}
        };

        var list = payService.GetProfitSummaryInfo_A(paramList);

        var returnjsonData = JsonConvert.SerializeObject(list);
        HttpContext.Current.Response.ContentType = "text/json";
        HttpContext.Current.Response.Write(returnjsonData);
    }

    protected void GetProfitList_Admin(HttpContext context)
    {
        string svidUser = context.Request.Form["SvidUser"].AsText();
        string startDate = context.Request.Form["StartDate"].AsText();
        string endDate = context.Request.Form["EndDate"].AsText();
        string svidCompNo = context.Request.Form["SvidCompNo"].AsText();
        string saleCompName = context.Request.Form["SaleCompName"].AsText();
        string buyerCompName = context.Request.Form["BuyerCompName"].AsText();
        string payway = context.Request.Form["Payway"].AsText();
        int pageNo = context.Request.Form["PageNo"].AsInt();
        int pageSize = context.Request.Form["PageSize"].AsInt();
        var paramList = new Dictionary<string, object>
        {
            { "nvar_P_SVID_USER", svidUser},
            { "nvar_P_STARTDATE", startDate},
            { "nvar_P_ENDDATE", endDate},
            { "nvar_P_SVID_COMPANYNO", svidCompNo},
            { "nvar_P_SALECOMPANY_NAME", saleCompName},
            { "nvar_P_BUYERCOMPANY_NAME", buyerCompName},
            { "nvar_P_PAYWAY", payway},
            { "inte_P_PAGENO", pageNo},
            { "inte_P_PAGESIZE", pageSize},
        };

        var list = payService.GetProfitList_Admin(paramList);

        var returnjsonData = JsonConvert.SerializeObject(list);
        HttpContext.Current.Response.ContentType = "text/json";
        HttpContext.Current.Response.Write(returnjsonData);
    }

    //[관리자]전자세금계산서 발행(판매사) 목록 조회 - 수정판(2018-07-11 유준희)
    protected void GetAdminBillList(HttpContext context)
    {
        string startDate = context.Request.Form["StartDate"].AsText();
        string endDate = context.Request.Form["EndDate"].AsText();
        string saleCompName = context.Request.Form["SaleCompName"].AsText();
        string delFlag = context.Request.Form["DelFlag"].AsText();
        string paySelecetType = context.Request.Form["PaySelectType"].AsText();
        var paramList = new Dictionary<string, object>
        {
            { "nvar_P_STARTDATE", startDate},
            { "nvar_P_ENDDATE", endDate},
            { "nvar_P_ORDERSALECOMPANY_NAME", saleCompName},
            { "nvar_P_DELFLAG", delFlag},
            { "nvar_P_PAYSELECTTYPE", paySelecetType},
        };

        var list = payService.GetAdminBillList(paramList);

        var paramList2 = new Dictionary<string, object>
        {
            { "nvar_P_STARTDATE", startDate},
            { "nvar_P_ENDDATE", endDate},
            { "nvar_P_ORDERSALECOMPANY_NAME", saleCompName},
        };

        var statList = payService.GetAdminBillStatList(paramList2);

        var resultList = new Dictionary<string, object>();
        resultList.Add("billList",list);
        resultList.Add("billStatList",statList);

        var returnjsonData = JsonConvert.SerializeObject(resultList);
        HttpContext.Current.Response.ContentType = "text/json";
        HttpContext.Current.Response.Write(returnjsonData);
    }

    protected void GetAdminSubBillList(HttpContext context)
    {
        string startDate = context.Request.Form["StartDate"].AsText();
        string endDate = context.Request.Form["EndDate"].AsText();
        string saleCompCode = context.Request.Form["SaleCompCode"].AsText();
        var paramList = new Dictionary<string, object>
        {
            { "nvar_P_STARTDATE", startDate},
            { "nvar_P_ENDDATE", endDate},
            { "nvar_P_ORDERSALECOMPANY_CODE", saleCompCode},

        };

        var list = payService.GetAdminSubBillList(paramList);

        var returnjsonData = JsonConvert.SerializeObject(list);
        HttpContext.Current.Response.ContentType = "text/json";
        HttpContext.Current.Response.Write(returnjsonData);

    }

    protected void AdminPayTaxUpdate(HttpContext context)
    {
        string numbers = context.Request.Form["Nums"].AsText();
        string type = context.Request.Form["Type"].AsText();

        SocialWith.Biz.Pay.PayService payService = new SocialWith.Biz.Pay.PayService();

        var paramList = new Dictionary<string, object>
        {
             {"nvar_P_UNUM_PAYNOS",numbers},
             {"nvar_P_TYPE",type},

        };

        payService.AdminPayTaxUpdate(paramList);
        context.Response.ContentType = "text/plain";
        context.Response.Write("OK");

    }

    protected void AdminSubPayTaxUpdate(HttpContext context)
    {
        string numbers = context.Request.Form["Nums"].AsText();

        SocialWith.Biz.Pay.PayService payService = new SocialWith.Biz.Pay.PayService();

        var paramList = new Dictionary<string, object>
        {
             {"nvar_P_UNUM_PAYNOS",numbers},
        };

        payService.AdminSubPayTaxUpdate(paramList);
        context.Response.ContentType = "text/plain";
        context.Response.Write("OK");

    }

    //[관리자]정산요약 목록 조회
    protected void GetProfitSummaryList_Admin(HttpContext context)
    {
        string svidUser = context.Request.Form["SvidUser"].AsText();
        string startDate = context.Request.Form["StartDate"].AsText();
        string endDate = context.Request.Form["EndDate"].AsText();
        string saleCompNm = context.Request.Form["SaleCompNm"].AsText();
        int pageNo = context.Request.Form["PageNo"].AsInt();
        int pageSize = context.Request.Form["PageSize"].AsInt();

        var paramList = new Dictionary<string, object>
        {
            {"nvar_P_SVID_USER", svidUser },
            { "nvar_P_STARTDATE", startDate},
            { "nvar_P_ENDDATE", endDate},
            { "nvar_P_SALECOMPANY_NAME", saleCompNm},
            { "inte_P_PAGENO", pageNo},
            { "inte_P_PAGESIZE", pageSize}
        };

        var list = payService.GetProfitSummaryList_Admin(paramList);

        var returnjsonData = JsonConvert.SerializeObject(list);
        HttpContext.Current.Response.ContentType = "text/json";
        HttpContext.Current.Response.Write(returnjsonData);

    }

    //[관리자]세금계산서 발행
    protected void AdminPayBillInsert(HttpContext context)
    {
        string ordSaleCompCode = context.Request.Form["OrdSaleCompCode"].AsText(); //판매사코드
        string numbers = context.Request.Form["Nums"].AsText(); //변경할 pay 시퀀스들(,로 구분)
        string goodsName = context.Request.Form["GoodsName"].AsText(); //세금계산서명
        int goodsQty = context.Request.Form["GoodsQty"].AsInt(); //총 수량
        decimal totalAmt = context.Request.Form["TotAmt"].AsDecimal(); //세금계산서 총 발행금액

        SocialWith.Biz.Pay.PayService payService = new SocialWith.Biz.Pay.PayService();

        // P_ORDERSALECOMPANY_CODE IN VARCHAR2 --판매사코드
        //,P_UNUM_PAYNOS IN VARCHAR2 --'1,2,3' 이런 형식임.
        //,P_GOODSNAME IN VARCHAR2
        //,P_GOODSQTY IN NUMBER --세금계산서 합계 수량
        //,P_AMT IN NUMBER --세금계산서 합계 발행금액

        var paramList = new Dictionary<string, object>
        {
             {"nvar_P_ORDERSALECOMPANY_CODE",ordSaleCompCode},
             {"nvar_P_UNUM_PAYNOS",numbers},
             {"nvar_P_GOODSNAME",goodsName},
             {"nume_P_GOODSQTY",goodsQty},
             {"nume_P_AMT",totalAmt},
             {"reVa_P_RETURN",0}
        };

        payService.AdminPayBillInsert(paramList);

        var paramList2 = new Dictionary<string, object> { };

        payService.UpdateBillTransN(paramList2); //BILL_TRANS 테이블에서 TRANSYN = 'N' 으로 업데이트

        context.Response.ContentType = "text/plain";
        context.Response.Write("OK");
    }


    protected void GetBillHistoryAdminSubList(HttpContext context)
    {
        string svidUser = context.Request.Form["SvidUser"].AsText();
        string startDate = context.Request.Form["ToDateB"].AsText();
        string endDate = context.Request.Form["ToDateE"].AsText();
        int pageNo = context.Request.Form["PageNo"].AsInt();
        int pageSize = context.Request.Form["PageSize"].AsInt();

        var paramList = new Dictionary<string, object>
        {
            {"nvar_P_SVID_USER", svidUser },
            { "nvar_P_STARTDATE", startDate},
            { "nvar_P_ENDDATE", endDate},
            { "inte_P_PAGENO", pageNo},
            { "inte_P_PAGESIZE", pageSize},
        };

        var list = payService.GetBillHistoryAdminSubList(paramList);

        var returnjsonData = JsonConvert.SerializeObject(list);
        HttpContext.Current.Response.ContentType = "text/json";
        HttpContext.Current.Response.Write(returnjsonData);

    }

    protected void GetBillHistoryInfo_A(HttpContext context)
    {
        string svidCompCode = context.Request.Form["SvidCompCode"].AsText();
        string payNo = context.Request.Form["PayNo"].AsText();
        int pageNo = context.Request.Form["PageNo"].AsInt();
        int pageSize = context.Request.Form["PageSize"].AsInt();

        var paramList = new Dictionary<string, object>
        {
            { "nvar_P_UNUM_PAYNO", payNo},
            { "nvar_P_ORDERSALECOMPANY_CODE", svidCompCode },
            { "inte_P_PAGENO", pageNo},
            { "inte_P_PAGESIZE", pageSize},
        };

        var list = payService.GetBillHistoryInfo_A(paramList);

        var returnjsonData = JsonConvert.SerializeObject(list);
        HttpContext.Current.Response.ContentType = "text/json";
        HttpContext.Current.Response.Write(returnjsonData);

    }

    protected void GetBillHistoryAdminList(HttpContext context)
    {
        string startDate = context.Request.Form["ToDateB"].AsText();
        string endDate = context.Request.Form["ToDateE"].AsText();
        string saleComp = context.Request.Form["SaleCompName"].AsText();
        int pageNo = context.Request.Form["PageNo"].AsInt();
        int pageSize = context.Request.Form["PageSize"].AsInt();

        var paramList = new Dictionary<string, object>
        {
            { "nvar_P_STARTDATE", startDate},
            { "nvar_P_ENDDATE", endDate},
            { "nvar_P_BUYCOMPNAME", saleComp},
            { "inte_P_PAGENO", pageNo},
            { "inte_P_PAGESIZE", pageSize},
        };

        var list = payService.GetBillHistoryAdminList(paramList);

        var returnjsonData = JsonConvert.SerializeObject(list);
        HttpContext.Current.Response.ContentType = "text/json";
        HttpContext.Current.Response.Write(returnjsonData);

    }

    protected void GetBillHistoryInfo_Admin(HttpContext context)
    {
        string svidCompCode = context.Request.Form["SvidCompCode"].AsText();
        string payNo = context.Request.Form["PayNo"].AsText();
        int pageNo = context.Request.Form["PageNo"].AsInt();
        int pageSize = context.Request.Form["PageSize"].AsInt();

        var paramList = new Dictionary<string, object>
        {
            { "nvar_P_UNUM_PAYNO", payNo},
            { "nvar_P_ORDERSALECOMPANY_CODE", svidCompCode },
            { "inte_P_PAGENO", pageNo},
            { "inte_P_PAGESIZE", pageSize},
        };

        var list = payService.GetBillHistoryInfo_Admin(paramList);

        var returnjsonData = JsonConvert.SerializeObject(list);
        HttpContext.Current.Response.ContentType = "text/json";
        HttpContext.Current.Response.Write(returnjsonData);

    }

    //관리자 입금내역조회 입금확인
    protected void AdminDepositConfirmUpdate(HttpContext context)
    {
        string codes = context.Request.Form["Codes"].AsText();
        string userId = context.Request.Form["UserId"].AsText();
        SocialWith.Biz.Pay.PayService payService = new SocialWith.Biz.Pay.PayService();

        var paramList = new Dictionary<string, object>
        {
             {"nvar_P_ORDERCODENOS",codes},
             {"nvar_P_USERID",userId},
        };

        payService.AdminDepositConfirmUpdate(paramList);
        context.Response.ContentType = "text/plain";
        context.Response.Write("OK");

    }

    //[관리자] 정산내역 조회(정산상세)

    protected void GetProfitSummary_D_Admin(HttpContext context)
    {
        string svidUser = context.Request.Form["SvidUser"].AsText(); //관리자 Svid_User
        string startDate = context.Request.Form["StartDate"].AsText();
        string endDate = context.Request.Form["EndDate"].AsText();
        string saleCompCode = context.Request.Form["SaleCompCode"].AsText(); //판매사코드

        var paramList = new Dictionary<string, object>
        {
            { "nvar_P_SVID_USER", svidUser},
            { "nvar_P_STARTDATE", startDate},
            { "nvar_P_ENDDATE", endDate},
            { "nvar_P_SALECOMPANY_CODE", saleCompCode}
        };

        var list = payService.GetProfitSummaryInfo_Admin(paramList);

        var returnjsonData = JsonConvert.SerializeObject(list);
        HttpContext.Current.Response.ContentType = "text/json";
        HttpContext.Current.Response.Write(returnjsonData);
    }

    protected void OrderBillCheck(HttpContext context)
    {
        string svidUser = context.Request.Form["sUser"].AsText(); //관리자 Svid_User
        string odrCodeNo = context.Request.Form["OdrCodeNo"].AsText();
        string billSelectDate = context.Request.Form["BillSelectDate"].AsText();
        string billEmail = context.Request.Form["BillEmail"].AsText(); //판매사코드

        var paramList = new Dictionary<string, object>
        {
            { "nvar_P_ORDERCODENO", odrCodeNo},
            { "nvar_P_BILLSELECTDATE", billSelectDate},
            { "nvar_P_BILLEMAIL", billEmail}
        };

        payService.OrderBillCheck(paramList);
        HttpContext.Current.Response.ContentType = "text/plain";
        HttpContext.Current.Response.Write("OK");


    }


    //대금결제 내역 조회 - 내역조회 
    protected void OrderBillListSch(HttpContext context)
    {
        string svidUser = context.Request.Form["sUser"].AsText(); //관리자 Svid_User
        string ComCode = context.Request.Form["comCode"].AsText(); //관리자 Svid_User           
        string OdrCodeNo = context.Request.Form["odrCodeNo"].AsText(); //주문번호
        string SYear = context.Request.Form["sYear"].AsText();
        string EYear = context.Request.Form["eYear"].AsText();
        string SMon = context.Request.Form["sMon"].AsText();
        string EMon = context.Request.Form["eMon"].AsText();
        int pageNo = context.Request.Form["PageNo"].AsInt(); //페이지no
        int pageSize = context.Request.Form["PageSize"].AsInt(); //페이지 size

        var paramList = new Dictionary<string, object>
        {
            { "nvar_P_SVID_USER",svidUser},
            { "nvar_P_COMPANY_CODE", ComCode},
            { "nvar_P_STARTYEAR", SYear},
            { "char_P_ENDYEAR", EYear},
            { "char_P_STARTMONTH",SMon},
            { "char_P_ENDMONTH", EMon},
            { "nvar_P_ORDERCODENO", OdrCodeNo},
            { "inte_P_PAGENO", pageNo},
            { "inte_P_PAGESIZE", pageSize}
        };

        var list = payService.OrderBillListSch(paramList);


        var returnjsonData = JsonConvert.SerializeObject(list);
        HttpContext.Current.Response.ContentType = "text/json";
        HttpContext.Current.Response.Write(returnjsonData);
    }

    //대금결제 내역 조회 - 내역조회 - 팝업
    protected void OrderBillListSchPop(HttpContext context)
    {
        string svidUser = context.Request.Form["sUser"].AsText(); //관리자 Svid_User           
        string UnumPayNo = context.Request.Form["unumPayNo"].AsText(); //주문번호
        string Flag = context.Request.Form["flag"].AsText(); //주문번호
        int pageNo = context.Request.Form["PageNo"].AsInt(); //페이지no
        int pageSize = context.Request.Form["PageSize"].AsInt(); //페이지 size

        var paramList = new Dictionary<string, object>
        {
            { "nvar_P_SVID_USER",svidUser},
            { "nvar_P_PAYLOANSEQNOB", UnumPayNo},
            { "inte_P_PAGENO", pageNo},
            { "inte_P_PAGESIZE", pageSize},
            { "nvar_P_FLAG",Flag }
        };

        var list = payService.OrderBillListSchPop(paramList);


        var returnjsonData = JsonConvert.SerializeObject(list);
        HttpContext.Current.Response.ContentType = "text/json";
        HttpContext.Current.Response.Write(returnjsonData);
    }




    //[관리자]대금결제 내역 조회 - 마감내역조회 
    protected void OrderBillDeadLine(HttpContext context)
    {
        string SYear = context.Request.Form["sYear"].AsText();
        string EYear = context.Request.Form["eYear"].AsText();
        string SMon = context.Request.Form["sMon"].AsText();
        string EMon = context.Request.Form["eMon"].AsText();
        string AdminID = context.Request.Form["adminID"].AsText(); //우리안 담당자명
        string ComCode = context.Request.Form["compCode"].AsText(); //회사코드  
        string OdrCodeNo = context.Request.Form["odrCodeNo"].AsText(); //여신번호
        int pageNo = context.Request.Form["PageNo"].AsInt(); //페이지no
        int pageSize = context.Request.Form["PageSize"].AsInt(); //페이지 size

        var paramList = new Dictionary<string, object>
        {
            { "char_P_STARTYEAR", SYear}, //검색 시작년도
            { "char_P_ENDYEAR", EYear},   //검색 종료년도
            { "char_P_STARTMONTH",SMon},  //검색 시작 월
            { "char_P_ENDMONTH", EMon},  //검색 종료 월
            { "nvar_P_ADMINUSERID", AdminID}, //우리안 담당자 아이디
            { "nvar_P_COMPANY_CODE", ComCode}, //회사코드
            { "nvar_P_ORDERCODENO", OdrCodeNo}, //여신결제번호
            { "inte_P_PAGENO", pageNo},
            { "inte_P_PAGESIZE", pageSize}
        };

        var list = payService.OrderBillDeadLine(paramList);


        var returnjsonData = JsonConvert.SerializeObject(list);
        HttpContext.Current.Response.ContentType = "text/json";
        HttpContext.Current.Response.Write(returnjsonData);
    }


    //[구매사]정산내역조회 - 대금결제 조회
    protected void OrderBillPaymentList(HttpContext context)
    {
        string svidUser = context.Request.Form["sUser"].AsText(); //관리자 Svid_User           
        string companyCode = context.Request.Form["comCode"].AsText(); //주문번호


        var paramList = new Dictionary<string, object>
        {
            { "nvar_P_SVID_USER", svidUser},
            { "nvar_P_COMPANY_CODE", companyCode},
        };

        var list = payService.OrderBillPaymentList(paramList);


        var returnjsonData = JsonConvert.SerializeObject(list);
        HttpContext.Current.Response.ContentType = "text/json";
        HttpContext.Current.Response.Write(returnjsonData);
    }



    //[구매사] 대금내역결제 - 여신결제 무 프로시저 연결  
    protected void OrderBillType8(HttpContext context)
    {
        string svidUser = context.Request.Form["sUser"].AsText(); //관리자 Svid_User           
        //string ComCode = context.Request.Form["comCode"].AsText(); //회사코드
        string CompanyCode = context.Request.Form["cmpanyCode"].AsText(); //회사코드
        string Unum_PayNo = context.Request.Form["unum_PayNo"].AsText(); //시퀀스
        string VbankName = context.Request.Form["vbankName"].AsText(); //은행명
        string VbankNo = context.Request.Form["vbankNo"].AsText(); //계좌번호
        string BankTypeName = context.Request.Form["bankTypeName"].AsText(); //예금주

        var paramList = new Dictionary<string, object>
        {
            { "nvar_P_COMPANY_CODE",CompanyCode }, //구매사코드
            { "nvar_P_PAYLOANSEQNOB",Unum_PayNo },  //여신결제번호 시퀀스
            { "nvar_P_PAYRESULTCOD","" },  //결제결과코드
            { "nvar_P_PAYRESULT","" },  //결과내용
            { "nvar_P_PAYCONFIRMDATE","" },  //결제승인일시
            { "nvar_P_PAYCONFIRMNO","" },  //결제승인번호
            { "nvar_P_PG_TID","" },  //거래 아이디
            { "char_P_CASHBILLTYPE","" },  //현금영수증타입
            { "nvar_P_CASHBILLTYPECONFIRMNO","" },  //현금영수증 승인번호
            { "nvar_P_VBANKCODE","" },  //가상계좌 코드
            { "nvar_P_VBANKNAME",VbankName},  //가상계좌 은행명
            { "nvar_P_VBANKNO",VbankNo },  //가상계좌 번호
            { "nvar_P_VBANKDATE","" },  //가상계좌 입금 만료일 
            { "char_P_PAYSUCESSYN","" },  //결제성공 유무 
            { "nvar_P_BANKTYPENAME",BankTypeName},  //예금주(구매명) 
            { "nvar_P_FLAGE","SUCCESS_8" },  //구분자(SUCCESS_6:여신(일반), SUCCESS_8:여신(무), FAIL:여신(일반) 결과 실패)
        };


        payService.OrderBillType8(paramList);
        HttpContext.Current.Response.ContentType = "text/plain";
        HttpContext.Current.Response.Write("OK");


    }

    //관리자 여신(무)관리
    protected void LoanDepositList(HttpContext context)
    {
        string compCode = context.Request.Form["CompCode"].AsText(); //회사코드
        string sdate = context.Request.Form["Sdate"].AsText(); //시작일
        string edate = context.Request.Form["Edate"].AsText(); //종료일
        string pageNo = context.Request.Form["PageNo"].AsText(); //
        string pageSize = context.Request.Form["PageSize"].AsText(); //
        var paramList = new Dictionary<string, object>
        {
            { "nvar_P_COMPANY_CODE", compCode},
            { "nvar_P_SEARCHSTARTDATE", sdate},
            { "nvar_P_SEARCHENDDATE", edate},
            { "inte_P_PAGENO", pageNo},
            { "inte_P_PAGESIZE", pageSize},
        };

        var list = payService.LoanDepositList(paramList);


        var returnjsonData = JsonConvert.SerializeObject(list);
        HttpContext.Current.Response.ContentType = "text/json";
        HttpContext.Current.Response.Write(returnjsonData);
    }

    //관리자 여신(무)관리
    protected void LoanDepositSalesConfirm(HttpContext context)
    {
        string compCode = context.Request.Form["CompCode"].AsText(); //회사코드
        string confIrmIdB = context.Request.Form["ConfIdB"].AsText(); //확인한 영업담당자ID
        string depositDate = context.Request.Form["DepositDate"].AsText(); //확인한 행의 입금일
        int seq = context.Request.Form["Seq"].AsInt(); //확인한 행의 순번
        var paramList = new Dictionary<string, object>
        {
            { "nvar_P_COMPANY_CODE", compCode},
            { "nvar_P_CONFIRMIDA", ""},
            { "nvar_P_CONFIRMIDB", confIrmIdB},
            { "nume_P_LOANPAYUSEPRICE", 0},
            { "nume_P_SEQ", seq},
            { "nvar_P_ENTRYDATE", depositDate},
            { "nvar_P_FLAG", "DEPOSIT_2"}
        };

        payService.OrderEndDepositInsert(paramList);

        context.Response.ContentType = "text/palin";
        context.Response.Write("OK");
    }

    protected void OrderEndDepositInsert(HttpContext context)
    {
        string compCode = context.Request.Form["CompCode"].AsText();
        string ida = context.Request.Form["Ida"].AsText();
        string idb = context.Request.Form["Idb"].AsText();
        var price = context.Request.Form["Price"].AsDecimal();
        int seq = context.Request.Form["Seq"].AsInt();
        string entryDate = context.Request.Form["EntryDate"].AsText();
        string flag = context.Request.Form["Flag"].AsText();
        SocialWith.Biz.Pay.PayService payService = new SocialWith.Biz.Pay.PayService();

        var paramList = new Dictionary<string, object>
        {
             {"nvar_P_COMPANY_CODE",compCode},
             {"nvar_P_CONFIRMIDA",ida},
             {"nvar_P_CONFIRMIDB",idb},
             {"nvar_P_LOANPAYUSEPRICE",price},
             {"nvar_P_SEQ",seq},
             {"nvar_P_ENTRYDATE",entryDate},
             {"nvar_P_FLAG",flag},


        };

        payService.OrderEndDepositInsert(paramList);
        context.Response.ContentType = "text/plain";
        context.Response.Write("Success");

    }



    //[관리자] 대금결제 내역조회  
    protected void MonthOrderEnd_Admin(HttpContext context)
    {
        string compCode = context.Request.Form["CompCode"].AsText();               //검색조건: 구매사 회사코드
        string adminUserID = context.Request.Form["AdminUserID"].AsText();         //검색조건: 영업 담당자
        string dateFlag = context.Request.Form["DateFlag"].AsText();               //검색조건: 검색일자 구분자
        string orderCodeNo = context.Request.Form["OrderCodeNo"].AsText();         //검색조건: 여신결제번호
        string payWay = context.Request.Form["PayWay"].AsText();                   //검색조건: 결제수단
        string loanPayList_Arr = context.Request.Form["LoanPayList_Arr"].AsText(); //쉼표로 구분된 여신결제 현황 상태
        string sdate = context.Request.Form["Sdate"].AsText();                     //검색 시작일
        string edate = context.Request.Form["Edate"].AsText();                     //검색 종료일
        string pageNo = context.Request.Form["PageNo"].AsText();                   //페이징
        string pageSize = context.Request.Form["PageSize"].AsText();               //페이징
        var paramList = new Dictionary<string, object>
        {
            { "nvar_P_COMPANY_CODE", compCode},            //검색조건: 구매사 회사코드
            { "nvar_P_ADMINUSERID", adminUserID},             //검색조건: 영업 담당자
            { "nvar_P_DATEFLAG", dateFlag},                //검색조건: 검색일자 구분자
            { "nvar_P_ORDERCODENO", orderCodeNo},             //검색조건: 여신결제번호
            { "nvar_P_PAYWAY", payWay},                  //검색조건: 결제수단
            { "nvar_P_LOANPAYLIST_ARR", loanPayList_Arr},         //쉼표로 구분된 여신결제 현황 상태
            { "nvar_P_SEARCHSTARTDATE", sdate},            //검색 시작일
            { "nvar_P_SEARCHENDDATE", edate},              //검색 종료일
            { "inte_P_PAGENO", pageNo},                    //페이징
            { "inte_P_PAGESIZE", pageSize},                //페이징
        };

        var list = payService.MonthOrderEnd_Admin(paramList);


        var returnjsonData = JsonConvert.SerializeObject(list);
        HttpContext.Current.Response.ContentType = "text/json";
        HttpContext.Current.Response.Write(returnjsonData);
    }

    //[관리자] 대금결제 내역조회 미결제 건수 체크 프로시저 
    protected void OutStanding(HttpContext context)
    {
        string compCode = context.Request.Form["CompCode"].AsText();               //검색조건: 구매사 회사코드
        string adminUserID = context.Request.Form["AdminUserID"].AsText();         //검색조건: 영업 담당자

        var paramList = new Dictionary<string, object>
        {
            { "nvar_P_COMPANY_CODE", compCode},            //검색조건: 구매사 회사코드
            { "nvar_P_ADMINUSERID", adminUserID}            //검색조건: 영업 담당자
        };

        var list = payService.OutStanding(paramList);


        var returnjsonData = JsonConvert.SerializeObject(list);
        HttpContext.Current.Response.ContentType = "text/json";
        HttpContext.Current.Response.Write(returnjsonData);
    }
    //[관리자] 여신(무) 관리 확인내역 조회 
    protected void Payok_OrderEnd(HttpContext context)
    {
        string compCode = context.Request.Form["CompCode"].AsText();               //검색조건: 구매사 회사코드
        string adminUserID = context.Request.Form["AdminUserID"].AsText();         //검색조건: 영업 담당자    
        string orderCodeNo = context.Request.Form["OrderCodeNo"].AsText();         //검색조건: 여신결제번호
        string loanPayList_Arr = context.Request.Form["LoanPayList_Arr"].AsText(); //쉼표로 구분된 여신결제 현황 상태
        string sdate = context.Request.Form["Sdate"].AsText();                     //검색 시작일
        string edate = context.Request.Form["Edate"].AsText();                     //검색 종료일
        string pageNo = context.Request.Form["PageNo"].AsText();                   //페이징
        string pageSize = context.Request.Form["PageSize"].AsText();               //페이징


        var paramList = new Dictionary<string, object>
        {
            { "nvar_P_COMPANY_CODE", compCode},               //회사코드
            { "nvar_P_ADMINUSERID", adminUserID},             //검색조건: 영업담당자ID
            { "nvar_P_SEARCHSTARTDATE", sdate},               //검색조건: 입금일자 시작일
            { "nvar_P_SEARCHENDDATE", edate},                 //검색조건: 입금일자 종료일
            { "nvar_P_ORDERCODENO", orderCodeNo},             //검색조건: 여신결제번호
            { "nvar_P_LOANPAYLIST_ARR", loanPayList_Arr},     //검색조건: 여신결제현황 상태코드
            { "inte_P_PAGENO", pageNo},                       //페이징
            { "inte_P_PAGESIZE", pageSize}                    //페이징
        };

        var list = payService.Payok_OrderEnd(paramList);


        var returnjsonData = JsonConvert.SerializeObject(list);
        HttpContext.Current.Response.ContentType = "text/json";
        HttpContext.Current.Response.Write(returnjsonData);
    }

    //[관리자] 여신(무) 관리 확인내역 조회 
    protected void OrderEnd_DTL(HttpContext context)
    {
        string compCode = context.Request.Form["comCode"].AsText();               //검색조건: 구매사 회사코드
        string payLoanSeqnob = context.Request.Form["unumPayNo"].AsText();         //검색조건: 여신 시퀀스 번호    
        string pageNo = context.Request.Form["PageNo"].AsText();                   //페이징
        string pageSize = context.Request.Form["PageSize"].AsText();               //페이징


        var paramList = new Dictionary<string, object>
        {
            { "nvar_P_COMPANY_CODE", compCode},               //회사코드
          //  { "inte_P_PAYLOANSEQNOB", payLoanSeqnob},            //검색조건: 여신결제번호 시퀀스     
            { "inte_P_PAYLOANSEQNOB",payLoanSeqnob},            //검색조건: 여신결제번호 시퀀스         
            { "inte_P_PAGENO", pageNo},                       //페이징
            { "inte_P_PAGESIZE", pageSize}                    //페이징
        };

        var list = payService.OrderEnd_DTL(paramList);


        var returnjsonData = JsonConvert.SerializeObject(list);
        HttpContext.Current.Response.ContentType = "text/json";
        HttpContext.Current.Response.Write(returnjsonData);
    }

    //(구매사) PO별 묶음 결제 사용하는 구매사의 주문 저장
    protected void SaveBLoanOrder(HttpContext context)
    {
        string svidUser = context.Request.Form["SvidUser"].AsText();
        string ordCodeNo = context.Request.Form["OrdCodeNo"].AsText();
        string roleFlag = context.Request.Form["RoleFlag"].AsText();
        string type = context.Request.Form["Type"].AsText();
        string typeUnumNo = context.Request.Form["TypeUnumNo"].AsText();

        string pgMid = string.Empty;
        string bName = string.Empty;
        string bTelNo = string.Empty;
        string bEmail = string.Empty;
        string ediDate = string.Empty;
        string goodsName = string.Empty;
        int goodsCnt = 0;
        string transType = string.Empty;
        string CompanyName = string.Empty;
        string CompanyDeptName = string.Empty;
        string Address_1 = string.Empty;
        decimal DeliveryCost = 0;
        decimal PowerDeliveryCost = 0;
        decimal price = 0;
        string payway = string.Empty;
        string payWayResult = "여신결제 주문";

        var paramList = new Dictionary<string, object> {
            {"nvar_P_SVID_USER", svidUser }
            ,{"nvar_P_ORDERCODENO",ordCodeNo}

        };
        var list = payService.GetPayList(paramList); //주문 정보값 조회
        var returnVal = "ZERO"; //조회된 목록 여부에 따라 리턴값이 달라짐

        if ((list != null) && (list.Count > 0))
        {
            returnVal = "LIST";

            pgMid = list[0].Pg_Mid;                //ID 값
            bName = list[0].Name;                   //구매자명
            bTelNo = list[0].TelNo;                   //구매자 연락처
            bEmail = Crypt.AESDecrypt256(list[0].Email); //구매자 이메일
            ediDate = String.Format("{0:yyyyMMddHHmmss}", DateTime.Now);    //생성일시
            ordCodeNo = list[0].OrderCodeNo;         //주문번호
            goodsName = list[0].GoodsFinalName; //상품명 외 몇개 처리
            goodsCnt = list.Count.AsInt();
            transType = "0";                    //에스크로,일반여부
            CompanyName = list[0].Company_Name;
            CompanyDeptName = list[0].CompanyDept_Name;
            Address_1 = list[0].Address_1;
            DeliveryCost = list[0].DeliveryCost; // 기본 배송비
            PowerDeliveryCost = list[0].PowerDeliveryCost; // 특수 배송비
            payway = list[0].PayWay;


            // 총 결제금액 계산
            for (int i = 0; i < list.Count; i++)
            {
                price += list[i].GoodsSalePricevat;
            }

            price += DeliveryCost + PowerDeliveryCost; // 총 결제금액

            goodsName = ConvertEllipsisString(goodsName, 27);

            if (goodsCnt > 1)
            {
                goodsName = goodsName + " 외 " + (goodsCnt - 1) + "건";
            }

            //주문 정보 관련 테이블에 값들 저장
            var paramList2 = new Dictionary<string, object>
            {
                 {"nvar_P_ORDERCODENO",ordCodeNo},
                 {"nvar_P_SVID_USER",svidUser},
                 {"nvar_P_PG_MID",pgMid},
                 {"nvar_P_BUYERNAME",bName},
                 {"nvar_P_BUYERTEL",bTelNo},
                 {"nvar_P_BUYEMAIL",bEmail},
                 {"nvar_P_GOODSNAME",goodsName},
                 {"inte_P_GOODSQTY",goodsCnt},
                 {"nume_P_AMT",price},
                 {"nvar_P_PAYWAY",payway},
                 {"nvar_P_PAYRESULTCODE",""},
                 {"nvar_P_PAYRESULT",payWayResult},
                 {"nvar_P_ROLE_FLAG",roleFlag},
                 {"nvar_P_TYPE",type},
                 {"nvar_P_TYPE_UNUMNO",typeUnumNo}
            };

            payService.SaveBLoanCompOrder(paramList2);
        }

        context.Response.ContentType = "text/plain";
        context.Response.Write(returnVal);
    }

    //무통장입금 결제
    protected void SavePayNoPassbook(HttpContext context)
    {
        string ordCodeNo = context.Request.Form["OrderCodeNo"].AsText();
        string svidUser = context.Request.Form["SvidUser"].AsText();
        string pgMid = context.Request.Form["PgMid"].AsText();
        string buyerName = context.Request.Form["BuyerName"].AsText();
        string buyerTel = context.Request.Form["BuyerTel"].AsText();
        string buyerEmail = context.Request.Form["BuyerMail"].AsText();
        string goodsName = context.Request.Form["GoodsName"].AsText();
        int goodsQty = context.Request.Form["GoodsQty"].AsInt();
        decimal Amt = context.Request.Form["Amt"].AsDecimal();
        string payway = context.Request.Form["PayWay"].AsText();
        string roleFlag = context.Request.Form["RoleFlag"].AsText();
        string urianType = context.Request.Form["UrianType"].AsText();
        string urianTypeUnumNo = context.Request.Form["UrianTypeUnumNo"].AsText();

        var paramList = new Dictionary<string, object>
        {
            { "nvar_P_ORDERCODENO", ordCodeNo},
            { "nvar_P_SVID_USER", svidUser},
            { "nvar_P_PG_MID", pgMid},
            { "nvar_P_BUYERNAME", buyerName},
            { "nvar_P_BUYERTEL", buyerTel},
            { "nvar_P_BUYEMAIL", buyerEmail},
            { "nvar_P_GOODSNAME", goodsName},
            { "nume_P_GOODSQTY", goodsQty},
            { "nume_P_AMT", Amt},
            { "nvar_P_PAYWAY", payway},
            { "nvar_P_ROLE_FLAG", roleFlag},
            { "nvar_P_TYPE", urianType},
            { "nvar_P_TYPE_UNUMNO", urianTypeUnumNo}
        };

        payService.SavePayNoPassbook(paramList);

        context.Response.ContentType = "text/plain";
        context.Response.Write("OK");
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

    //(관리자)세금계산서 발행 중지/요청
    protected void UpdateBillDateAdmin(HttpContext context)
    {
        string odrCodeNo = context.Request.Form["OdrCodeNo"].AsText();
        string billSelectDate = context.Request.Form["BillSelectDate"].AsText();
        string billEmail = context.Request.Form["BillEmail"].AsText();
        billEmail = Crypt.AESDecrypt256(billEmail);
        string billFlag = context.Request.Form["BillFlag"].AsText(); //STOP:중지/REQ:요청

        //세금계산서 발행 중지인 경우 발행일 날짜를 바꿈.
        if(billFlag.Equals("STOP"))
        {
            billSelectDate = "9999-01-01";

        }

        var paramList = new Dictionary<string, object>
        {
            { "nvar_P_ORDERCODENO", odrCodeNo},
            { "nvar_P_BILLSELECTDATE", billSelectDate},
            { "nvar_P_BILLEMAIL", billEmail}
        };

        payService.OrderBillCheck(paramList);
        HttpContext.Current.Response.ContentType = "text/plain";
        HttpContext.Current.Response.Write(billFlag);


    }

    protected void GetOrderBillCompList(HttpContext context)
    {
        string keyword = context.Request.Form["Keyword"].AsText();
        string gubun = context.Request.Form["Gubun"].AsText();
        int PageNo = context.Request.Form["PageNo"].AsInt();
        int PageSize = context.Request.Form["PageSize"].AsInt();

        var paramList = new Dictionary<string, object>
        {
            { "nvar_P_SEARCHKEYWORD", keyword},
            { "nvar_P_GUBUN", gubun},
            {"inte_P_PAGENO", PageNo },
            {"inte_P_PAGESIZE", PageSize },
        };

        var list = companyService.GetSearchCompanyList(paramList);
        var returnjsonData = JsonConvert.SerializeObject(list);

        context.Response.ContentType = "text/plain";
        context.Response.Write(returnjsonData);
    }
    
    // 정산내역조회 전자세금계산서 발행할 내역 조회
    protected void GetOrderBillIssueList(HttpContext context)
    {
        string month = context.Request.Form["Month"].AsText();
        string gubun = context.Request.Form["Gubun"].AsText();
        string compCode = context.Request.Form["CompCode"].AsText();
        string payway = context.Request.Form["PayWay"].AsText();

        var paramList = new Dictionary<string, object>
        {
            {"nvar_P_MONTH", month},
            {"nvar_P_GUBUN", gubun},
            {"nvar_P_COMPCODE", compCode },
            {"nvar_P_PAYWAY", payway },
        };

        var list = payService.GetOrdBillHistoryList(paramList);
        var returnjsonData = JsonConvert.SerializeObject(list);

        context.Response.ContentType = "text/plain";
        context.Response.Write(returnjsonData);
    }

    //정산내역조회 전자세금계산서 발행내역 최종현황 조회
    protected void GetAdminBillStatus_A(HttpContext context)
    {
        string startDate = context.Request.Form["StartDate"].AsText();              
        string endDate = context.Request.Form["EndDate"].AsText();             
        string gubun = context.Request.Form["Gubun"].AsText();            
        string compName = context.Request.Form["CompName"].AsText();            
        int pageNo = context.Request.Form["PageNo"].AsInt();           
        int pageSize = context.Request.Form["PageSize"].AsInt();            



        var paramList = new Dictionary<string, object>
        {
            { "nvar_P_STARTDATE", startDate},               
            { "nvar_P_ENDDATE", endDate},            
            { "nvar_P_GUBUN", gubun},            
            { "nvar_P_COMPNAME", compName},            
            { "nvar_P_PAGENO", pageNo},            
            { "nvar_P_PAGESIZE", pageSize},            
        
        };

        var list = payService.GetAdminBillStatus_A(paramList);


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