<%@ WebHandler Language="C#" Class="DeliveryHandler" %>

using System;
using System.Web;
using SocialWith.Biz.Delivery;
using SocialWith.Biz.Order;
using System.Collections.Generic;
using Newtonsoft.Json;
using Urian.Core;


public class DeliveryHandler : IHttpHandler {

    public void ProcessRequest (HttpContext context) {
        string method = context.Request.Form["Method"];
        switch (method)
        {
            case "GetDeliveryList":
                GetDeliveryList(context);
                break;
            case "GetDeliveryNo":
                GetDeliveryNo(context);
                break;
            case "DeliveryOrderList":
                DeliveryOrderList(context);
                break;
            case "DeliveryOrderList_A":
                DeliveryOrderList_A(context);
                break;
            case "DeliveryOrderList_Admin":
                DeliveryOrderList_Admin(context);
                break;
            case "UpdateOrdEnterYN":
                UpdateOrdEnterYN(context); //입고확인 수정(일괄적용/개별적용)
                break;
            case "SaveDelivery":
                SaveDelivery(context);
                break;
            default:
                break;
        }
    }

    protected void GetDeliveryList(HttpContext context)
    {

        string gubun = context.Request.Form["Gubun"];
        string svidUser = context.Request.Form["SvidUser"];
        DeliveryService deliveryService = new DeliveryService();

        var paramList = new Dictionary<string, object>
            {
                { "nvar_P_SVID_USER", svidUser},
            };

        var list = deliveryService.GetDeliveryList(paramList);

        var returnjsonData = JsonConvert.SerializeObject(list);
        HttpContext.Current.Response.ContentType = "text/json";
        HttpContext.Current.Response.Write(returnjsonData);

    }

    protected void GetDeliveryNo(HttpContext context)
    {

        string svidUser = context.Request.Form["SvidUser"];
        DeliveryService deliveryService = new DeliveryService();

        var paramList = new Dictionary<string, object>
            {
                { "nvar_P_SVID_USER", svidUser},
            };

        var gubun = deliveryService.GetDeliveryNo(paramList);

        // var returnjsonData = JsonConvert.SerializeObject(gubun);
        HttpContext.Current.Response.ContentType = "text/plain";
        HttpContext.Current.Response.Write(gubun);

    }

    protected void DeliveryOrderList(HttpContext context)
    {
        OrderService orderService = new OrderService();

        string sviduser = context.Request.Form["SvidUser"].AsText();
        string toDateB = context.Request.Form["ToDateB"].AsText();
        string toDateE = context.Request.Form["ToDateE"].AsText();
        string orderCodeNo = context.Request.Form["OrderCodeNo"].AsText();
        int orderStatus = context.Request.Form["OrderStatus"].AsInt();
        string payWay = context.Request.Form["Payway"].AsText();
        int pageNo = context.Request.Form["PageNo"].AsInt();
        int pageSize = context.Request.Form["PageSize"].AsInt();

        var paramList = new Dictionary<string, object> {
            {"nvar_P_SVID_USER", sviduser},
            {"nvar_P_TODATEB", toDateB},
            {"nvar_P_TODATEE", toDateE},
            {"nvar_P_ORDERCODENO", orderCodeNo},
            {"nume_P_ORDERSTATUS", orderStatus},
            {"nvar_P_PAYWAY", payWay},
            {"nume_P_PAGENO", pageNo},
            {"nume_P_PAGESIZE", pageSize},
        };

        var list = orderService.DeliveryOrderList(paramList);

        var returnjsonData = JsonConvert.SerializeObject(list);
        context.Response.ContentType = "text/plain";
        context.Response.Write(returnjsonData);
    }

    protected void DeliveryOrderList_A(HttpContext context)
    {
        OrderService orderService = new OrderService();

        string sviduser = context.Request.Form["SvidUser"].AsText();
        string toDateB = context.Request.Form["ToDateB"].AsText();
        string toDateE = context.Request.Form["ToDateE"].AsText();
        string orderCodeNo = context.Request.Form["OrderCodeNo"].AsText();
        int orderStatus = context.Request.Form["OrderStatus"].AsInt();
        string payWay = context.Request.Form["Payway"].AsText();
        string buyCompName = context.Request.Form["BuyCompName"].AsText();
        int pageNo = context.Request.Form["PageNo"].AsInt();
        int pageSize = context.Request.Form["PageSize"].AsInt();

        var paramList = new Dictionary<string, object> {
            {"nvar_P_SVID_USER", sviduser},
            {"nvar_P_TODATEB", toDateB},
            {"nvar_P_TODATEE", toDateE},
            {"nvar_P_ORDERCODENO", orderCodeNo},
            {"nume_P_ORDERSTATUS", orderStatus},
            {"nvar_P_PAYWAY", payWay},
             {"nvar_P_BUYCOMPNAME", buyCompName},
            {"nume_P_PAGENO", pageNo},
            {"nume_P_PAGESIZE", pageSize},
        };

        var list = orderService.DeliveryOrderList_A(paramList);

        var returnjsonData = JsonConvert.SerializeObject(list);
        context.Response.ContentType = "text/plain";
        context.Response.Write(returnjsonData);
    }

    protected void DeliveryOrderList_Admin(HttpContext context)
    {
        OrderService orderService = new OrderService();

        string sviduser = context.Request.Form["SvidUser"].AsText();
        string toDateB = context.Request.Form["ToDateB"].AsText();
        string toDateE = context.Request.Form["ToDateE"].AsText();
        string orderCodeNo = context.Request.Form["OrderCodeNo"].AsText();
        string orderStatus = context.Request.Form["OrderStatus"].AsText();
        string payWay = context.Request.Form["Payway"].AsText();
        string buyCompName = context.Request.Form["BuyCompName"].AsText();
        string saleCompName = context.Request.Form["SaleCompName"].AsText();
        int pageNo = context.Request.Form["PageNo"].AsInt();
        int pageSize = context.Request.Form["PageSize"].AsInt();

        var paramList = new Dictionary<string, object> {
            {"nvar_P_SVID_USER", sviduser},
            {"nvar_P_TODATEB", toDateB},
            {"nvar_P_TODATEE", toDateE},
            {"nvar_P_ORDERCODENO", orderCodeNo},
            {"nvar_P_ORDERSTATUS", orderStatus},
            {"nvar_P_PAYWAY", payWay},
            {"nvar_P_BUYCOMPNAME", buyCompName},
            {"nvar_P_SALECOMPNAME", saleCompName},
            {"nume_P_PAGENO", pageNo},
            {"nume_P_PAGESIZE", pageSize},
        };

        var list = orderService.DeliveryOrderList_Admin(paramList);

        var returnjsonData = JsonConvert.SerializeObject(list);
        context.Response.ContentType = "text/plain";
        context.Response.Write(returnjsonData);
    }

    //입고확인 여부 수정(일괄적용/개별적용)
    protected void UpdateOrdEnterYN(HttpContext context)
    {
        string svidUser = context.Request.Form["SvidUser"].AsText();
        string ordCodeNo = context.Request.Form["OrdCodeNo"].AsText();
        string goodsCode = context.Request.Form["GoodsCode"].AsText();
        int ordStat = context.Request.Form["OrdStat"].AsInt();
        string payway = context.Request.Form["Payway"].AsText();
        string startDate = context.Request.Form["StartDate"].AsText();
        string endDate = context.Request.Form["EndDate"].AsText();
        string flag = context.Request.Form["Flag"].AsText(); //일괄적용:ALL, 개별적용:''

        string returnVal = "OK"; //반환값(개별적용)
        if (flag.Equals("ALL")) returnVal = "ALLOK"; //반환값(일괄적용)

        OrderService orderService = new OrderService();

        var paramList = new Dictionary<string, object>
        {
            {"nvar_P_SVID_USER", svidUser},
            {"nvar_P_ORDERCODENO", ordCodeNo},
            {"nvar_P_GOODSCODE", goodsCode},
            {"nume_P_ORDERSTATUS", ordStat},
            {"nvar_P_PAYWAY", payway},
            {"nvar_P_TODATEB", startDate},
            {"nvar_P_TODATEE", endDate},
            {"nvar_P_FLAG", flag}
        };

        orderService.UpdateOrderEnterYN(paramList);

        context.Response.ContentType = "text/plain";
        context.Response.Write(returnVal);
    }

    protected void SaveDelivery(HttpContext context)
    {
        string svidUser = context.Request.Form["SvidUser"].AsText();
        string name = context.Request.Form["UserName"].AsText();
        string compNo = context.Request.Form["CompNo"].AsText();
        string compCode = context.Request.Form["CompCode"].AsText();
        string areaCode = context.Request.Form["AreaCode"].AsText();
        string businessDeptCode = context.Request.Form["BDeptCode"].AsText();
        string deptCode = context.Request.Form["DeptCode"].AsText();
        string portal = context.Request.Form["Portal"].AsText();
        string address1 = context.Request.Form["Addr1"].AsText();
        string address2 = context.Request.Form["Addr2"].AsText();

        DeliveryService deliveryService = new DeliveryService();

        var createSvidDelivery = Guid.NewGuid().ToString();
        var paramList = new Dictionary<string, object> {
                 { "nvar_P_SVID_DELIVERY",createSvidDelivery}
                ,{ "nvar_P_SVID_USER",svidUser}
                ,{ "nvar_P_COMPANY_NO",compNo}
                ,{ "nvar_P_COMPANY_CODE",compCode}
                ,{ "nvar_P_COMPANYAREA_CODE",areaCode}
                ,{ "nvar_P_COMPBUSINESSDEPT_CODE",businessDeptCode}
                ,{ "nvar_P_COMPANYDEPT_CODE",deptCode}
                ,{ "nvar_P_DELIVERY_DEFAULT","N"}
                ,{ "nvar_P_DELIVERY_NOSUB",""}
                ,{ "nvar_P_DELIVERY_PERSON", name}
                ,{ "nvar_P_DELIVERY_DELFLAG","N"}
                ,{ "nvar_P_ZIPCODE",portal}
                ,{ "nvar_P_ADDRESS_1",address1}
                ,{ "nvar_P_ADDRESS_2",address2}
            };

        deliveryService.SaveDelivery(paramList);

        context.Response.ContentType = "text/plain";
        context.Response.Write("Success");
    }

    public bool IsReusable {
        get {
            return false;
        }
    }

}