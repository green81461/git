<%@ WebHandler Language="C#" Class="MenuHandler" %>

using System;
using System.Web;
using SocialWith.Biz.Brand;
using System.Collections.Generic;
using Newtonsoft.Json;
using Urian.Core;
using SocialWith.Biz.Menu;

public class MenuHandler : IHttpHandler {
    protected MenuService MenuService = new MenuService();
    public void ProcessRequest (HttpContext context) {

        string method = context.Request.Form["Method"];
        switch (method)
        {
            case "GetAllMenuList":
                GetAllMenuList(context);
                break;
            default:
                break;
        }
       
    }

    protected void GetAllMenuList(HttpContext context)
    {

        var paramList = new Dictionary<string, object>
        {
           
        };

        var list = MenuService.GetAllMenu(paramList);

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