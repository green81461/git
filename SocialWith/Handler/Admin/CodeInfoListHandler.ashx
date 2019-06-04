<%@ WebHandler Language="C#" Class="CodeInfoListHandler" %>

using NLog;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Web;
using SocialWith.Biz.Comapny;
using Urian.Core;

public class CodeInfoListHandler : IHttpHandler {

    #region << logger >>
    protected static Logger logger = NLog.LogManager.GetCurrentClassLogger();
    protected static readonly bool IsDebugEnabled = logger.IsDebugEnabled;
    protected static readonly bool IsInfoEnabled = logger.IsInfoEnabled;
    protected static readonly bool IsWarnEnabled = logger.IsWarnEnabled;
    protected static readonly bool IsErrorEnabled = logger.IsErrorEnabled;
    protected static readonly bool IsFatalEnabled = logger.IsFatalEnabled;
    #endregion

    protected CompanyService CompanyService = new CompanyService();

    public void ProcessRequest (HttpContext context) {

        string companyCode = context.Request.Form["CompanyCode"];
        string areaCode = context.Request.Form["AreaCode"];
        string compBusinessDeptCode = context.Request.Form["CompBusinessDeptCode"];
        string companyDeptCode = context.Request.Form["CompanyDeptCode"];
        string type = context.Request.Form["Type"];

        if (!string.IsNullOrWhiteSpace(type))
        {
            switch (type)
            {
                case "Company":     //회사리스트 갖고오기
                    //GetCompanyList(companyName);
                    GetCompanyList(context);
                    break;
                //case "Area":        //사업장 갖고오기
                //    GetCompanyAreaList(companyCode.AsText());
                //    break;
                //case "Business":    //사업부 갖고오기
                //    GetCompanyBusinessDeptList(companyCode.AsText(), areaCode.AsText());
                //    break;
                //case "Dept":        //부서리스트 갖고오기
                //    GetCompanyDeptList(companyCode.AsText(), areaCode.AsText(), compBusinessDeptCode.AsText());
                //    break;
                default:
                    break;
            }
        }
    }

    #region << 데이터바인드 - GetCompanyList >>
    public void GetCompanyList(HttpContext context)
    {
        string companyNo = context.Request.Form["CompanyNo"]; // 사업자 번호
        
        var paramList = new Dictionary<string, object> {
           { "nvar_P_COMPNO", companyNo}
        };
        var list = CompanyService.GetCompanyListByCompNo(paramList);

        var returnjsonData = JsonConvert.SerializeObject(list);
        context.Response.ContentType = "text/plain";
        context.Response.Write(returnjsonData);
    }
    #endregion

    public bool IsReusable {
        get {
            return false;
        }
    }

}