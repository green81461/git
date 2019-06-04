<%@ WebHandler Language="C#" Class="CommHandler" %>

using System;
using System.Web;
using SocialWith.Biz.Brand;
using System.Collections.Generic;
using Newtonsoft.Json;
using Urian.Core;
public class CommHandler : IHttpHandler {
    protected SocialWith.Biz.Comm.CommService CommService = new SocialWith.Biz.Comm.CommService();
    public void ProcessRequest (HttpContext context) {
        string method = context.Request.Form["Method"];
        switch (method)
        {
            case "GetMemberCommList":
                GetMemberCommList(context);
                break;
            case "GetCommList":
                GetCommList(context);
                break;
            case "GetCommMultiList":
                GetCommMultiList(context);
                break;
            case "GetCommMultiCodeList":
                GetCommMultiCodeList(context);
                break;
            default:
                break;
        }
    }

    protected void GetMemberCommList(HttpContext context)
    {

        var paramList = new Dictionary<string, object>
        {
            { "nvar_P_MAPCODE", "MEMBER"},
            { "nume_P_MAPCHANEL", 1},
        };

        var list = CommService.GetCommList(paramList);

        var returnjsonData = JsonConvert.SerializeObject(list);
        HttpContext.Current.Response.ContentType = "text/json";
        HttpContext.Current.Response.Write(returnjsonData);

    }

    protected void GetCommList(HttpContext context)
    {

        string code = context.Request.Form["Code"].AsText();
        int channel = context.Request.Form["Channel"].AsInt();
        var paramList = new Dictionary<string, object>
        {
            { "nvar_P_MAPCODE", code},
            { "nume_P_MAPCHANEL", channel},
        };

        var list = CommService.GetCommList(paramList);

        var returnjsonData = JsonConvert.SerializeObject(list);
        HttpContext.Current.Response.ContentType = "text/json";
        HttpContext.Current.Response.Write(returnjsonData);

    }

    protected void GetCommMultiList(HttpContext context)
    {

        string code = context.Request.Form["Code"];
        string channelList = context.Request.Form["Channel"];
        int[] channel = new int[channelList.Length];

        var resultList = new Dictionary<string, object>();
        var split = channelList.Split(',');

        for (int i = 0; i < split.Length; i++)
        {
            channel[i] = split[i].AsInt();

            var paramList = new Dictionary<string, object>
            {
                { "nvar_P_MAPCODE", code},
                { "nume_P_MAPCHANEL", channel[i]},
            };

            var list = CommService.GetCommList(paramList);

            resultList.Add("comm_" + i, list);

        }

        var returnJsonData = JsonConvert.SerializeObject(resultList);
        context.Response.ContentType = "text/plain";
        context.Response.Write(returnJsonData);
    }

    //다중 Map_Code 및 다중 Map_Chanel 인 경우
    protected void GetCommMultiCodeList(HttpContext context)
    {

        string codeList = context.Request.Form["Code"].AsText();
        string channelList = context.Request.Form["Channel"].AsText();
        
        var resultList = new Dictionary<string, object>();
        var splitCode = codeList.Split(',');
        var splitChanel = channelList.Split(',');

        string[] code = new string[splitCode.Length];
        int[] channel = new int[splitChanel.Length];

        for (int i = 0; i < splitCode.Length; i++)
        {
            code[i] = splitCode[i].AsText();
            channel[i] = splitChanel[i].AsInt();

            var paramList = new Dictionary<string, object>
            {
                { "nvar_P_MAPCODE", code[i]},
                { "nume_P_MAPCHANEL", channel[i]},
            };

            var list = CommService.GetCommList(paramList);

            resultList.Add("comm_" + i, list);

        }

        var returnJsonData = JsonConvert.SerializeObject(resultList);
        context.Response.ContentType = "text/plain";
        context.Response.Write(returnJsonData);
    }

    public bool IsReusable {
        get {
            return false;
        }
    }

}