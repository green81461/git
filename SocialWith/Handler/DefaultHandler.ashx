<%@ WebHandler Language="C#" Class="DefaultHandler" %>

using System;
using System.Web;
using SocialWith.Biz.Default;
using SocialWith.Biz.Order;
using System.Collections.Generic;
using Newtonsoft.Json;
using Urian.Core;
using SocialWith.Biz.Delivery;
using NLog;

public class DefaultHandler : IHttpHandler {

    #region << logger >>
    protected static Logger logger = NLog.LogManager.GetCurrentClassLogger();
    protected static readonly bool IsDebugEnabled = logger.IsDebugEnabled;
    protected static readonly bool IsInfoEnabled = logger.IsInfoEnabled;
    protected static readonly bool IsWarnEnabled = logger.IsWarnEnabled;
    protected static readonly bool IsErrorEnabled = logger.IsErrorEnabled;
    protected static readonly bool IsFatalEnabled = logger.IsFatalEnabled;
    #endregion

    public void ProcessRequest (HttpContext context) {
        string method = context.Request.Form["Method"];
        switch (method)
        {
            case "GetDefaultAdminSubPkg":
                GetDefaultAdminSubPkg(context);
                break;
            case "GetAdminDefaultPackage":
                GetAdminDefaultPackage(context);
                break;
            default:
                break;
        }
    }

    protected void GetDefaultAdminSubPkg(HttpContext context)
    {
        string svidUser = context.Request.Form["SvidUser"];
        string compCode = context.Request.Form["CompCode"];
        DefaultService deliveryService = new DefaultService();

        var paramList = new Dictionary<string, object>
            {
                { "nvar_P_SVIDUSER", svidUser},
                { "nvar_P_COMPCODE", compCode},
            };

        var list = deliveryService.GetAdminSubDefaultPackage(paramList);

        var returnjsonData = JsonConvert.SerializeObject(list);
        HttpContext.Current.Response.ContentType = "text/json";
        HttpContext.Current.Response.Write(returnjsonData);

    }

    protected void GetAdminDefaultPackage(HttpContext context)
    {
        DefaultService defaultService = new DefaultService();
        DeliveryService deliveryService = new DeliveryService();

        var paramList = new Dictionary<string, object>
        {
            { "nvar_P_SVIDUSER", ""},
            { "nvar_P_COMPCODE", ""},
        };

        var list = defaultService.GetAdminDefaultPackage(paramList);

        var paramList2 = new Dictionary<string, object> {};

        var chart = deliveryService.GetDeliveryDueChart(paramList2); //배송납기현황 차트 정보 조회

        list.Tables.Add(chart);
        list.Tables["Table1"].TableName = "table_9";

        var returnjsonData = JsonConvert.SerializeObject(list);
        HttpContext.Current.Response.ContentType = "text/json";
        HttpContext.Current.Response.Write(returnjsonData);
    }


    public bool IsReusable {
        get {
            return false;
        }
    }

}