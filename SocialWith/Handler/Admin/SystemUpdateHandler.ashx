<%@ WebHandler Language="C#" Class="SystemUpdateHandler" %>

using System;
using System.Web;
using System.Collections.Generic;
using SocialWith.Biz.SystemUpdate;
using Newtonsoft.Json;
using Urian.Core;

public class SystemUpdateHandler : IHttpHandler {

    protected SystemUpdateService SystemUpdateService = new SystemUpdateService();

    public void ProcessRequest (HttpContext context) {
        string method = context.Request.Form["Method"];
        switch (method)
        {
          
            case "GetSystemUpdateInfo": 
                GetSystemUpdateInfo(context);
                break;

            case "GetSystemUpdateAttachFiles":
                GetSystemUpdateAttachFiles(context);
                break;
           
            default:
                break;
        }
    }

    
    public void GetSystemUpdateInfo(HttpContext context)
    {
        string sysUpNo = context.Request.Form["SysUpNo"]; 

        var paramList = new Dictionary<string, object> {
              { "nume_P_UNUM_SYSTEMUPDATENO", sysUpNo}
        };
        var systemUpdate = SystemUpdateService.SystemUpdateInfo(paramList);

        
        var returnjsonData = JsonConvert.SerializeObject(systemUpdate);

        context.Response.ContentType = "text/json";
        context.Response.Write(returnjsonData);
    }
        
    public void GetSystemUpdateAttachFiles(HttpContext context)
    {
        string sysUpNo = context.Request.Form["SysUpNo"]; 

        var paramList = new Dictionary<string, object> {
              { "nume_P_UNUM_SYSTEMUPDATENO", sysUpNo}
        };
        var systemUpdate = SystemUpdateService.GetSystemUpdateAttachFileList(paramList);

        
        var returnjsonData = JsonConvert.SerializeObject(systemUpdate);

        context.Response.ContentType = "text/json";
        context.Response.Write(returnjsonData);
    }
    public bool IsReusable {
        get {
            return false;
        }
    }

}