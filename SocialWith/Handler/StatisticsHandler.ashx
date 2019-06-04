<%@ WebHandler Language="C#" Class="StatisticsHandler" %>

using System;
using System.Web;
using System.Collections.Generic;
using Newtonsoft.Json;
using Urian.Core;
using SocialWith.Biz.Statistics;
using NLog;

public class StatisticsHandler : IHttpHandler
{

    #region << logger >>
    protected static Logger logger = NLog.LogManager.GetCurrentClassLogger();
    protected static readonly bool IsDebugEnabled = logger.IsDebugEnabled;
    protected static readonly bool IsInfoEnabled = logger.IsInfoEnabled;
    protected static readonly bool IsWarnEnabled = logger.IsWarnEnabled;
    protected static readonly bool IsErrorEnabled = logger.IsErrorEnabled;
    protected static readonly bool IsFatalEnabled = logger.IsFatalEnabled;
    #endregion


    StatisticsService statisticsService = new StatisticsService();

    public void ProcessRequest(HttpContext context)
    {
        string method = context.Request.Form["Method"];
        switch (method)
        {
            case "GetStatisticsPackage":
                GetStatisticsPackage(context);
                break;
            default:
                break;
        }
    }

    protected void GetStatisticsPackage(HttpContext context)
    {
        string gubun = context.Request.Form["Gubun"];
        string compName = context.Request.Form["CompName"];

        var paramList = new Dictionary<string, object>
    {
            {"nvar_P_GUBUN", gubun },
            {"nvar_P_COMPNAME", compName }
    };

        var list = statisticsService.GetStatisticsPackage(paramList);

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
