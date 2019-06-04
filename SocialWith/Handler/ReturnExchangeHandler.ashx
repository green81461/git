<%@ WebHandler Language="C#" Class="ReturnExchangeRequestHandler" %>

using System;
using System.Web;
using System.Collections.Generic;
using Newtonsoft.Json;
using SocialWith.Biz.Comm;
using SocialWith.Biz.ReturnChange;
using Urian.Core;

public class ReturnExchangeRequestHandler : IHttpHandler
{

    protected ReturnChangeService rtnChgService = new ReturnChangeService();

    public void ProcessRequest(HttpContext context)
    {
        string flag = context.Request.Form["Flag"];

        switch (flag)
        {
            case "OrderInfo":
                GetOrderEndInfo(context);
                break;
            case "RtnChgReq":
                SaveReturnExchange(context);
                break;
            case "RtnChgCancel":
                UpdateReturnExchangeCancel(context);
                break;
            case "ReturnList_A":
                GetReturnList_A(context);
                break;
            case "ReturnList_Admin":
                GetReturnList_Admin(context);
                break;
            case "ChangeList_A":
                GetChangeList_A(context);
                break;
            case "RtnChgList_Admin":
                GetReturnChangeList_Admin(context);
                break;
            case "RtnChgInfo":
                GetRtchInfo(context);
                break;

            case "GetTransAction":
                GetTransAction(context);
                break;
        }

        //GetCommMultipleList(context);
    }

    // 반품/교환 취소 시
    protected void UpdateReturnExchangeCancel(HttpContext context)
    {
        string svidUser = context.Request.Form["S_User"].AsText();
        int unumRtnChgNo = context.Request.Form["UNumRtnChgNo"].AsText().AsInt();
        int unumOrdNo = context.Request.Form["UNumOrdNo"].AsText().AsInt();
        int rtnChgGubun = context.Request.Form["RtnChgGubun"].AsText().AsInt();
        int? ordStatCode = null;

        // 반품
        if (rtnChgGubun == 14)
        {
            ordStatCode = 508;
        }
        // 교환
        else if (rtnChgGubun == 15)
        {
            ordStatCode = 504;
        }

        var paramList = new Dictionary<string, object> {
              { "nvar_P_SVID_USER", svidUser}
            , { "nume_P_UNUM_RETURNCHANGENO", unumRtnChgNo}
            , { "nume_P_UNUM_ORDERNO", unumOrdNo}
            , { "nume_P_ORDERSTATUS", ordStatCode}
        };

        rtnChgService.UpdateReturnChangeCancel(paramList);

        context.Response.ContentType = "text/plain";
        context.Response.Write("{\"Result\": \"OK\"}");
    }

    // 반품/교환 신청 저장
    protected void SaveReturnExchange(HttpContext context)
    {
        int unum_orderNo = context.Request.Form["Unum_OrderNo"].AsInt();
        string svid_user = context.Request.Form["Svid_User"].AsText();
        string gubun = context.Request.Form["Gubun"].AsText();
        int rtnChgGubun = context.Request.Form["RtnChgGubun"].AsInt();
        string deliGubun = context.Request.Form["RtnChgDeliGubun"].AsText();
        int rtnChgType = context.Request.Form["RtnChgType"].AsInt();
        int Qty = context.Request.Form["Qty"].AsInt();
        int rtnChgQty = context.Request.Form["RtnChgQty"].AsInt();
        decimal rtnChgPrice = context.Request.Form["RtnChgPrice"].AsDecimal();
        int noRtnQty = context.Request.Form["NoReturnQty"].AsInt();

        string orderCodeNo = context.Request.Form["OrderCodeNo"].AsText();
        string gdsFinCtgrCode = context.Request.Form["GdsFinCtgrCode"].AsText();
        string gdsGrpCode = context.Request.Form["GdsGrpCode"].AsText();
        string gdsCode = context.Request.Form["GdsCode"].AsText();

        int? ordStatCode = null; // 상태코드
        string ordRtnStat = "N"; // 반품상태유무
        string ordChgStat = "N"; // 교환상태유무

        // 반품
        if (rtnChgGubun == 14)
        {
            ordStatCode = 505;
            ordRtnStat = "Y";
            ordChgStat = "";
        }
        // 교환
        else if (rtnChgGubun == 15)
        {
            ordStatCode = 501;
            ordRtnStat = "";
            ordChgStat = "Y";
        }

        string rtnChgCodeNo = NextSeqCode(rtnChgGubun);

        var paramList = new Dictionary<string, object> {
              { "nvar_P_RETURNCHANGECODENO", rtnChgCodeNo }
            , { "nume_P_UNUM_ORDERNO", unum_orderNo }
            , { "nvar_P_SVID_USER", svid_user }
            , { "nvar_P_GUBUN", gubun }
            , { "nume_P_RETURNCHANGEGUBUN", rtnChgGubun }
            , { "char_P_RETURNCHANGEDELIVERYGUBUN", deliGubun }
            , { "nume_P_RETURNCHANGETYPE", rtnChgType }
            , { "nume_P_RETURNCHANGEQTY", rtnChgQty }
            , { "nume_P_RETURNCHANGEPRICE", rtnChgPrice }
            , { "nume_P_NORETURNQTY", noRtnQty }
            , { "nvar_P_ORDERCODENO", orderCodeNo }
            , { "nvar_P_GOODSFINALCATEGORYCODE", gdsFinCtgrCode }
            , { "nvar_P_GOODSGROUPCODE", gdsGrpCode }
            , { "nvar_P_GOODSCODE", gdsCode }
            , { "nume_P_ORDERSTATUS", ordStatCode }
            , { "nume_P_QTY", Qty }
            , { "char_P_ORDERCHANGESTATUS", ordChgStat }
            , { "char_P_ORDERRETURNSTATUS", ordRtnStat }
        };

        rtnChgService.SaveReturnChange(paramList);
        context.Response.ContentType = "text/plain";
        context.Response.Write("{\"Result\": \"OK\"}");
    }

    // RETURNCHANGECODENO 값 생성
    protected string NextSeqCode(int rtnChgGubun)
    {
        string nextSeq = rtnChgService.GetNextCodeNo();
        string nowDate = DateTime.Now.ToString("yyMMdd");

        string nextCode = "";

        // 반품
        if (rtnChgGubun == 14)
        {
            nextCode = "R-" + nowDate + "-" + nextSeq;

            // 교환
        }
        else if (rtnChgGubun == 15)
        {
            nextCode = "C-" + nowDate + "-" + nextSeq;
        }

        return nextCode;
    }

    // 반품/교환 신청할 주문 정보 조회
    protected void GetOrderEndInfo(HttpContext context)
    {
        int unum_orderNo = context.Request.Form["Unum_OrderNo"].AsInt();
        string orderCodeNo = context.Request.Form["OrderCodeNo"].AsText();
        string goodsFinCtgrCode = context.Request.Form["GdsFinCtgrCode"].AsText();
        string goodsGroupCode = context.Request.Form["GdsGrpCode"].AsText();
        string goodsCode = context.Request.Form["GdsCode"].AsText();
        string svid_user = context.Request.Form["Svid_User"].AsText();

        SocialWith.Biz.Order.OrderService orderService = new SocialWith.Biz.Order.OrderService();

        var paramList = new Dictionary<string, object> {
              { "nvar_P_SVID_USER", svid_user}
            , { "nume_P_UNUM_ORDERNO", unum_orderNo}
            , { "nvar_P_ORDERCODENO", orderCodeNo}
            , { "nvar_P_GOODSFINALCATEGORYCODE", goodsFinCtgrCode}
            , { "nvar_P_GOODSGROUPCODE", goodsGroupCode}
            , { "nvar_P_GOODSCODE", goodsCode}
        };

        var info = orderService.GetOrderEndInfo(paramList);
        var commList = GetCommMultipleList(context);

        var resultList = new Dictionary<string, object>();
        resultList.Add("orderInfo", info);
        resultList.Add("commList", commList);


        var returnJsonData = JsonConvert.SerializeObject(resultList);

        context.Response.ContentType = "text/plain";
        context.Response.Write(returnJsonData);
    }

    // 구분, 유형 목록 조회(공통 코드)
    protected List<SocialWith.Data.Comm.CommDTO> GetCommMultipleList(HttpContext context)
    {
        string mapCode = context.Request.Form["MapCode"].AsText();
        int mapChanel_1 = context.Request.Form["MapChanel_1"].AsInt();
        int mapChanel_2 = context.Request.Form["MapChanel_2"].AsInt();

        CommService commService = new CommService();

        var paramList = new Dictionary<string, object> {
              { "nvar_P_MAPCODE", mapCode}
            , { "nume_P_MAPCHANEL_1", mapChanel_1}
            , { "nume_P_MAPCHANEL_2", mapChanel_2}
        };

        var list = commService.GetCommReturnExchangeList(paramList);

        //var returnJsonData = JsonConvert.SerializeObject(list);

        return list;

        //context.Response.ContentType = "text/plain";
        //context.Response.Write(returnJsonData);
    }

    protected void GetReturnList_A(HttpContext context)
    {
        string svidUser = context.Request.Form["SvidUser"].AsText();
        string todateB = context.Request.Form["TodateB"].AsText();
        string todateE = context.Request.Form["TodateE"].AsText();
        string status = context.Request.Form["Status"].AsText();
        string buyComp = context.Request.Form["BuyComp"].AsText();
        int pageNo = context.Request.Form["PageNo"].AsInt();
        int pageSize = context.Request.Form["PageSize"].AsInt();


        var paramList = new Dictionary<string, object>{
            {"nvar_P_SVID_USER", svidUser},
            {"nvar_P_TODATEB",  todateB },
            {"nvar_P_TODATEE", todateE },
            {"nvar_P_ORDERSTATUS", status },
            {"nvar_P_BUYCOMPANY", buyComp },
            {"nume_P_PAGENO", pageNo },
            {"nume_P_PAGESIZE", pageSize }
        };

        var list = rtnChgService.GetReturnList_A(paramList);

        var returnJsonData = JsonConvert.SerializeObject(list);
        context.Response.ContentType = "text/plain";
        context.Response.Write(returnJsonData);
    }

    protected void GetReturnList_Admin(HttpContext context)
    {
        string todateB = context.Request.Form["TodateB"].AsText();
        string todateE = context.Request.Form["TodateE"].AsText();
        string payway = context.Request.Form["PayWay"].AsText();
        string buyComp = context.Request.Form["BuyComp"].AsText();
        string saleComp = context.Request.Form["SaleComp"].AsText();
        int pageNo = context.Request.Form["PageNo"].AsInt();
        int pageSize = context.Request.Form["PageSize"].AsInt();


        var paramList = new Dictionary<string, object>{
            {"nvar_P_TODATEB",  todateB },
            {"nvar_P_TODATEE", todateE },
            {"nvar_P_PAYWAY", payway },
            {"nvar_P_BUYCOMPANY", buyComp },
            {"nvar_P_SALECOMPANY", saleComp },
            {"nume_P_PAGENO", pageNo },
            {"nume_P_PAGESIZE", pageSize }
        };

        var list = rtnChgService.GetReturnList_Admin(paramList);

        var returnJsonData = JsonConvert.SerializeObject(list);
        context.Response.ContentType = "text/plain";
        context.Response.Write(returnJsonData);
    }

    //[관리자] 반품/교환 조회
    protected void GetReturnChangeList_Admin(HttpContext context)
    {
        string rtnChgGubun = context.Request.Form["RtnChgGubun"].AsText();
        string orderStatus = context.Request.Form["OrdStatus"].AsText();
        string todateB = context.Request.Form["TodateB"].AsText();
        string todateE = context.Request.Form["TodateE"].AsText();
        string buyComp = context.Request.Form["BuyComp"].AsText();
        string saleComp = context.Request.Form["SaleComp"].AsText();
        int pageNo = context.Request.Form["PageNo"].AsInt();
        int pageSize = context.Request.Form["PageSize"].AsInt();

        var paramList = new Dictionary<string, object> {
            {"nvar_P_TODATEB",  todateB },
            {"nvar_P_TODATEE", todateE },
            {"nvar_P_ORDERSTATUS", orderStatus },
            {"nvar_P_BUYCOMPANY", buyComp },
            {"nvar_P_SALECOMPANY", saleComp },
            {"nvar_P_RETURNCHANGEGUBUN", rtnChgGubun },
            {"nume_P_PAGENO", pageNo },
            {"nume_P_PAGESIZE", pageSize }
        };

        var list = rtnChgService.GetAdminReturnChangeList(paramList);

        var returnJsonData = JsonConvert.SerializeObject(list);
        context.Response.ContentType = "text/plain";
        context.Response.Write(returnJsonData);
    }
        //반품 교환 거래명세서
    protected void GetTransAction(HttpContext context)
    {
        string sUser = context.Request.Form["SvidUser"].AsText();
        string ordCodeNo = context.Request.Form["OrdCodeNo"].AsText();

        var paramList = new Dictionary<string, object> {
            { "nvar_P_ORDERCODENO", ordCodeNo },
            { "nvar_P_SVID_USER", sUser }
        };

        var list = rtnChgService.GetTransAction(paramList);
        var returnjsonData = JsonConvert.SerializeObject(list);
        HttpContext.Current.Response.ContentType = "text/json";
        HttpContext.Current.Response.Write(returnjsonData);
    }

    protected void GetChangeList_A(HttpContext context)
    {
        string svidUser = context.Request.Form["SvidUser"].AsText();
        string todateB = context.Request.Form["TodateB"].AsText();
        string todateE = context.Request.Form["TodateE"].AsText();
        string status = context.Request.Form["Status"].AsText();
        string buyComp = context.Request.Form["BuyComp"].AsText();
        int pageNo = context.Request.Form["PageNo"].AsInt();
        int pageSize = context.Request.Form["PageSize"].AsInt();

        var paramList = new Dictionary<string, object>{
            {"nvar_P_SVID_USER", svidUser},
            {"nvar_P_TODATEB",  todateB },
            {"nvar_P_TODATEE", todateE },
            {"nvar_P_ORDERSTATUS", status },
            {"nvar_P_BUYCOMPANY", buyComp },
            {"nume_P_PAGENO", pageNo },
            {"nume_P_PAGESIZE", pageSize }
        };

        var list = rtnChgService.GetChangeList_A(paramList);

        var returnJsonData = JsonConvert.SerializeObject(list);
        context.Response.ContentType = "text/plain";
        context.Response.Write(returnJsonData);
    }

    protected void GetRtchInfo(HttpContext context)
    {
        string svidUser = context.Request.Form["SvidUser"].AsText();
        string codeNo = context.Request.Form["RtchCodeNo"].AsText();

        var paramList = new Dictionary<string, object>{
              {"nvar_P_RETURNCHANGECODENO",  codeNo },
            {"nvar_P_SVID_USER", svidUser},
          
        };

        var info = rtnChgService.GetReturnChangeInfo(paramList);

        var returnJsonData = JsonConvert.SerializeObject(info);
        context.Response.ContentType = "text/json";
        context.Response.Write(returnJsonData);
    }

    public bool IsReusable
    {
        get
        {
            return false;
        }
    }

}