<%@ WebHandler Language="C#" Class="CompBusinessHandler" %>

using NLog;
using System;
using System.Web;
using System.Collections.Generic;
using SocialWith.Biz.Comapny;
using Newtonsoft.Json;
using Urian.Core;

public class CompBusinessHandler : IHttpHandler {
    #region << logger >>
    private static Logger logger = NLog.LogManager.GetCurrentClassLogger();
    private static readonly bool IsDebugEnabled = logger.IsDebugEnabled;
    private static readonly bool IsInfoEnabled = logger.IsInfoEnabled;
    private static readonly bool IsWarnEnabled = logger.IsWarnEnabled;
    private static readonly bool IsErrorEnabled = logger.IsErrorEnabled;
    private static readonly bool IsFatalEnabled = logger.IsFatalEnabled;
    #endregion

    protected CompanyService CompanyService = new CompanyService();

    public void ProcessRequest (HttpContext context) {
        string flag = context.Request.Form["Flag"];

        switch (flag)
        {
            case "List":    // 목록 조회
                GetCompanyBusinessDeptList(context, "");
                break;
            case "Create":  // 코드 생성
                BusinessDeptCodeGenerate(context);
                break;
            case "Update":  // 명칭, 비고 수정
                BusinessDeptNameUpdate(context);
                break;
            default:
                break;
        }
    }

    #region << 데이터바인드 - GetCompanyBusinessDeptList >>
    protected void GetCompanyBusinessDeptList(HttpContext context, string nextCode)
    {
        //string companyCode, string areaCode

        string companyCode = context.Request.Form["CompanyCode"];
        string areaCode = context.Request.Form["AreaCode"];

        var paramList = new Dictionary<string, object> {
                { "nvar_P_COMPCODE", companyCode},
                { "nume_P_COMPAREA_CODE",areaCode }
            };

        var list = CompanyService.GetCompanyBusinessDeptListByCode(paramList);

        if ((list != null) && (list.Count > 0))
            list[0].NewCode = nextCode;

        var returnjsonData = JsonConvert.SerializeObject(list);

        context.Response.ContentType = "text/plain";
        context.Response.Write(returnjsonData);
    }
    #endregion

    #region << 사업부 코드 자동 생성 >>
    protected void BusinessDeptCodeGenerate(HttpContext context)
    {
        //string companyCode, string areaCode, string businessName, string remark
        string companyCode = context.Request.Form["CompanyCode"];
        string areaCode = context.Request.Form["AreaCode"];
        string businessName = context.Request.Form["BusinessName"];
        string remark = context.Request.Form["Remark"];

        var paramList = new Dictionary<string, object>()
        {
             { "nvar_P_COMPCODE", companyCode}
            ,{ "nume_P_COMPANYAREACODE", areaCode}
        };
        var lastBusinessCode = CompanyService.GetLastCompBusinessDeptCode(paramList); //회사의 마지막 코드를 가지고 옴

        string nextCode = string.Empty;

        if (!string.IsNullOrWhiteSpace(lastBusinessCode))
        {
            nextCode = StringValue.GetCompBusinessDeptCode(lastBusinessCode); //코드 자동생성 
        }
        else
        {
            nextCode = "CB001"; //최초 사업부 코드
        }

        CompBusinessDeptInfoSave(context, nextCode); //사업부 정보 디비 저장

    }
    #endregion

    #region << 데이터바인드 - 사업부정보 저장 >>
    protected void CompBusinessDeptInfoSave(HttpContext context, string nextCode)
    {
        // string companyCode, string areaCode, string businessCode, string businessName, string remark
        string companyCode = context.Request.Form["CompanyCode"];
        string areaCode = context.Request.Form["AreaCode"];
        string businessName = context.Request.Form["BusinessName"];
        string remark = context.Request.Form["Remark"];

        try
        {
            var paramList = new Dictionary<string, object>() {
                 {"nvar_P_COMPANY_CODE", companyCode}
                ,{"nvar_P_COMPANY_NAME", ""}
                ,{"nvar_P_COMPANY_NO", ""}
                ,{"nvar_P_UNIQUE_NO", ""}
                ,{"nvar_P_GUBUN", ""}
                ,{"nvar_P_REMARK", remark}
                ,{"nume_P_COMPANYAREA_CODE", areaCode}
                ,{"nvar_P_COMPANYAREA_NAME", ""}
                ,{"nvar_P_COMPBUSINESSDEPT_CODE", nextCode}
                ,{"nvar_P_COMPBUSINESSDEPT_NAME", businessName}
                ,{"nvar_P_COMPANYDEPT_CODE", ""}
                ,{"nvar_P_COMPANYDEPT_NAME", ""}
                ,{"nvar_P_FLAG", "BUSINESS"}
            };

            CompanyService.SaveCompanyInfo(paramList);

            GetCompanyBusinessDeptList(context, nextCode);
        }
        catch (Exception ex)
        {
            if (IsErrorEnabled)
            {
                logger.Error(ex, "CompBusinessDeptInfoSave Error");
            }
        }
    }
    #endregion

    #region << 데이터바인드 - 사업부명 수정 >>
    protected void BusinessDeptNameUpdate(HttpContext context)
    {
        string companyCode = context.Request.Form["CompanyCode"];
        string areaCode = context.Request.Form["AreaCode"];
        string businessCode = context.Request.Form["BusinessCode"];
        string businessName = context.Request.Form["BusinessName"];
        string remark = context.Request.Form["Remark"];

        try
        {
            var paramList = new Dictionary<string, object>() {
                 {"nvar_P_COMPANY_CODE", companyCode}
                ,{"nvar_P_COMPANY_NAME", ""}
                ,{"nvar_P_COMPANY_NO", ""}
                ,{"nume_P_COMPANYAREA_CODE", areaCode}
                ,{"nvar_P_COMPANYAREA_NAME", ""}
                ,{"nvar_P_COMPBUSINESSDEPT_CODE", businessCode}
                ,{"nvar_P_COMPBUSINESSDEPT_NAME", businessName}
                ,{"nvar_P_COMPANYDEPT_CODE", ""}
                ,{"nvar_P_COMPANYDEPT_NAME", ""}
                ,{"nvar_P_REMARK", remark}
                ,{"nvar_P_FLAG", "BUSINESS"}
            };

            CompanyService.UpdateCompanyInfo(paramList); // DB 수정

            GetCompanyBusinessDeptList(context, ""); // 목록 조회
        }
        catch (Exception ex)
        {
            if (IsErrorEnabled)
            {
                logger.Error(ex, "BusinessDeptNameUpdate Error");
            }
        }
    }
    #endregion

    public bool IsReusable {
        get {
            return false;
        }
    }

}