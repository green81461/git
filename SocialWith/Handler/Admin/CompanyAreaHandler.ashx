<%@ WebHandler Language="C#" Class="CompanyAreaHandler" %>

using NLog;
using System;
using System.Web;
using System.Collections.Generic;
using SocialWith.Biz.Comapny;
using Newtonsoft.Json;
using Urian.Core;

// 사업장 코드 관련 기능
public class CompanyAreaHandler : IHttpHandler {

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
            case "List":    // 사업장코드 목록 조회
                GetCompanyAreaList(context, "");
                break;
            case "Create":  // 사업장코드 생성
                AreaCodeGenerate(context);
                break;
            case "Update":  // 사업장명, 비고 수정
                CompanyAreaNameUpdate(context);
                break;
            default:
                break;
        }
    }

    #region << 데이터바인드 - GetCompanyAreaList >>
    protected void GetCompanyAreaList(HttpContext context, string nextCode)
    {
        string companyCode = context.Request.Form["CompanyCode"];

        var paramList = new Dictionary<string, object> {
            { "nvar_P_COMPCODE", companyCode}
        };
        var list = CompanyService.GetCompanyAreaListByCode(paramList);
        
        if ((list != null) && (list.Count > 0))
            list[0].NewCode = nextCode;
        
        var returnjsonData = JsonConvert.SerializeObject(list);

        context.Response.ContentType = "text/plain";
        context.Response.Write(returnjsonData);
    }
    #endregion

    #region << 사업장 코드 자동 생성 >>
    protected void AreaCodeGenerate(HttpContext context)
    {
        string companyCode = context.Request.Form["CompanyCode"];

        var paramList = new Dictionary<string, object>()
        {
            { "nvar_P_COMPCODE", companyCode}
        };
        var lastAreaCode = CompanyService.GetLastCompanyAreaCode(paramList); //회사의 마지막 코드를 가지고 옴

        string nextCode = string.Empty;

        if (!string.IsNullOrWhiteSpace(lastAreaCode))
        {
            nextCode = StringValue.NextAreaCode(lastAreaCode); //코드 자동생성
        }
        else
        {
            nextCode = "11"; //최초 사업장 코드
        }

        CompanyAreaInfoSave(context, nextCode); //사업장 정보 저장

    }
    #endregion

    #region << 데이터바인드 - 사업장정보 저장 >>
    protected void CompanyAreaInfoSave(HttpContext context, string nextCode)
    {
        string companyCode = context.Request.Form["CompanyCode"]; // 회사 코드
        string areaName = context.Request.Form["AreaName"]; // 사업장명
        string remark = context.Request.Form["Remark"]; // 비고

        try
        {
            var paramList = new Dictionary<string, object>() {
                 {"nvar_P_COMPANY_CODE", companyCode}
                ,{"nvar_P_COMPANY_NAME", ""}
                ,{"nvar_P_COMPANY_NO", ""}
                ,{"nvar_P_UNIQUE_NO", ""}
                ,{"nvar_P_GUBUN", ""}
                ,{"nvar_P_REMARK", remark}
                ,{"nume_P_COMPANYAREA_CODE", nextCode}
                ,{"nvar_P_COMPANYAREA_NAME", areaName}
                ,{"nvar_P_COMPBUSINESSDEPT_CODE", ""}
                ,{"nvar_P_COMPBUSINESSDEPT_NAME", ""}
                ,{"nvar_P_COMPANYDEPT_CODE", ""}
                ,{"nvar_P_COMPANYDEPT_NAME", ""}
                ,{"nvar_P_FLAG", "AREA"}
            };

            CompanyService.SaveCompanyInfo(paramList); // 디비 저장

            GetCompanyAreaList(context, nextCode); // 목록 조회
        }
        catch (Exception ex)
        {
            if (IsErrorEnabled)
            {
                logger.Error(ex, "CompanyAreaInfoSave Error");
            }
        }
    }
    #endregion

    #region << 데이터바인드 - 사업장명 수정 >>
    protected void CompanyAreaNameUpdate(HttpContext context)
    {
        string companyCode = context.Request.Form["CompanyCode"];
        string areaCode = context.Request.Form["AreaCode"];
        string areaName = context.Request.Form["AreaName"];
        string remark = context.Request.Form["Remark"];

        try
        {
            var paramList = new Dictionary<string, object>() {
                 {"nvar_P_COMPANY_CODE", companyCode}
                ,{"nvar_P_COMPANY_NAME", ""}
                ,{"nvar_P_COMPANY_NO", ""}
                ,{"nume_P_COMPANYAREA_CODE", areaCode}
                ,{"nvar_P_COMPANYAREA_NAME", areaName}
                ,{"nvar_P_COMPBUSINESSDEPT_CODE", ""}
                ,{"nvar_P_COMPBUSINESSDEPT_NAME", ""}
                ,{"nvar_P_COMPANYDEPT_CODE", ""}
                ,{"nvar_P_COMPANYDEPT_NAME", ""}
                ,{"nvar_P_REMARK", remark}
                ,{"nvar_P_FLAG", "AREA"}
            };

            CompanyService.UpdateCompanyInfo(paramList); // DB 수정

            GetCompanyAreaList(context, ""); // 목록 조회
        }
        catch (Exception ex)
        {
            if (IsErrorEnabled)
            {
                logger.Error(ex, "CompanyAreaNameUpdate Error");
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