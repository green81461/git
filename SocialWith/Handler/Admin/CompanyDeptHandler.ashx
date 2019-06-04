<%@ WebHandler Language="C#" Class="CompanyDeptHandler" %>

using NLog;
using System;
using System.Web;
using System.Collections.Generic;
using SocialWith.Biz.Comapny;
using Newtonsoft.Json;
using Urian.Core;

public class CompanyDeptHandler : IHttpHandler {

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
                GetCompanyDeptList(context, "");
                break;
            case "Create":  // 코드 생성
                DeptCodeGenerate(context);
                break;
            case "Update":  // 명칭, 비고 수정
                DeptNameUpdate(context);
                break;
            default:
                break;
        }
    }

    #region << 데이터바인드 - GetCompanyDeptList >>
    protected void GetCompanyDeptList(HttpContext context, string nextCode)
    {
        string companyCode = context.Request.Form["CompanyCode"];
        string areaCode = context.Request.Form["AreaCode"];
        string businessCode = context.Request.Form["BusinessCode"];

        var paramList = new Dictionary<string, object> {
            { "nvar_P_COMPCODE", companyCode},
            { "nume_P_COMPAREA_CODE", areaCode},
            { "nvar_P_BUSINESSCODE", businessCode}

        };
        var list = CompanyService.GetCompanyDeptListByCode(paramList);

        if ((list != null) && (list.Count > 0))
            list[0].NewCode = nextCode;

        var returnjsonData = JsonConvert.SerializeObject(list);

        context.Response.ContentType = "text/plain";
        context.Response.Write(returnjsonData);
    }
    #endregion

    #region << 부서코드 자동 생성 >>
    protected void DeptCodeGenerate(HttpContext context)
    {
        string companyCode = context.Request.Form["CompanyCode"];
        string areaCode = context.Request.Form["AreaCode"];
        string businessCode = context.Request.Form["BusinessCode"];

        var paramList = new Dictionary<string, object>()
        {
            { "nvar_P_COMPCODE", companyCode},
            { "nume_P_COMPANYAREA_CODE", areaCode},
            { "nvar_P_COMPBUSINESSDEPT_CODE", businessCode}
        };
        var lastDeptCode = CompanyService.GetLastCompanyDeptCode(paramList); //부서의 마지막 코드를 가지고 옴

        string nextCode = string.Empty;

        if (!string.IsNullOrWhiteSpace(lastDeptCode))
        {
            nextCode = StringValue.GetNextCompDeptCode(lastDeptCode); //코드 자동생성

            logger.Debug("생성될 부서코드 : "+nextCode);
        }
        else
        {
            nextCode = "CA001"; //최초 부서코드
        }

        DeptInfoSave(context, nextCode); //부서정보 디비 저장

    }
    #endregion

    #region << 데이터바인드 - 부서정보 저장 >>
    protected void DeptInfoSave(HttpContext context, string nextCode)
    {
        string companyCode = context.Request.Form["CompanyCode"];
        string areaCode = context.Request.Form["AreaCode"];
        string businessCode = context.Request.Form["BusinessCode"];
        string deptName = context.Request.Form["DeptName"];
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
                ,{"nvar_P_COMPANYAREA_CODE", areaCode}
                ,{"nvar_P_COMPANYAREA_NAME", ""}
                ,{"nvar_P_COMPBUSINESSDEPT_CODE", businessCode}
                ,{"nvar_P_COMPBUSINESSDEPT_NAME", ""}
                ,{"nvar_P_COMPANYDEPT_CODE", nextCode}
                ,{"nvar_P_COMPANYDEPT_NAME", deptName}
                ,{"nvar_P_FLAG", "DEPT"}
            };

            CompanyService.SaveCompanyInfo(paramList);

            GetCompanyDeptList(context, nextCode);
        }
        catch (Exception ex)
        {
            if (IsErrorEnabled)
            {
                logger.Error(ex, "DeptInfoSave Error");
            }
        }
    }
    #endregion

    #region << 데이터바인드 - 부서명 수정 >>
    protected void DeptNameUpdate(HttpContext context)
    {
        string companyCode = context.Request.Form["CompanyCode"];
        string areaCode = context.Request.Form["AreaCode"];
        string businessCode = context.Request.Form["BusinessCode"];
        string deptCode = context.Request.Form["DeptCode"];
        string deptName = context.Request.Form["DeptName"];
        string remark = context.Request.Form["Remark"];

        try
        {
            var paramList = new Dictionary<string, object>() {
                 {"nvar_P_COMPANY_CODE", companyCode}
                ,{"nvar_P_COMPANY_NAME", ""}
                ,{"nvar_P_COMPANY_NO", ""}
                ,{"nvar_P_COMPANYAREA_CODE", areaCode}
                ,{"nvar_P_COMPANYAREA_NAME", ""}
                ,{"nvar_P_COMPBUSINESSDEPT_CODE", businessCode}
                ,{"nvar_P_COMPBUSINESSDEPT_NAME", ""}
                ,{"nvar_P_COMPANYDEPT_CODE", deptCode}
                ,{"nvar_P_COMPANYDEPT_NAME", deptName}
                ,{"nvar_P_REMARK", remark}
                ,{"nvar_P_FLAG", "DEPT"}
            };

            CompanyService.UpdateCompanyInfo(paramList); // DB수정

            GetCompanyDeptList(context, ""); // 목록 조회
        }
        catch (Exception ex)
        {
            if (IsErrorEnabled)
            {
                logger.Error(ex, "CompanyNameUpdate Error");
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