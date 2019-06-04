<%@ WebHandler Language="C#" Class="CodeGenerateHandler" %>

using System;
using System.Web;
using SocialWith.Biz.Company;

public class CodeGenerateHandler : IHttpHandler {

    public void ProcessRequest (HttpContext context) {
        string type = context.Request.Form["Type"];
        switch (type)
        {
            case "SocialCompanyLink":
                SocialComapnyLinkGenerate(context);
                break;

            default:
                break;
        }
    }


    public void SocialComapnyLinkGenerate(HttpContext context) {

        SocialComanyLinkService LinkCompanyService = new SocialComanyLinkService();
        var curCode = LinkCompanyService.GetLastLinkCode();
        string nextCode = string.Empty;
        if (!string.IsNullOrWhiteSpace(curCode))
        {
            nextCode = StringValue.NextLinkCode(curCode);
        }
        else
        {
            nextCode = "SCLK00000001";
        }
        context.Response.ContentType = "text/plain";
        context.Response.Write(nextCode);
    }


    public bool IsReusable {
        get {
            return false;
        }
    }

}