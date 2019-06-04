<%@ WebHandler Language="C#" Class="BudgetHandler" %>

using NLog;
using System;
using System.Web;
using System.Collections.Generic;
using SocialWith.Biz.Comapny;
using Newtonsoft.Json;
using Urian.Core;


public class BudgetHandler : IHttpHandler {

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

        string method = context.Request.Form["Method"];

        switch (method)
        {
            case "AdminBudgetList":
                GetAdminBudgetList(context);
                break;
            case "GetAdminBudgetModifyList":
                GetAdminBudgetModifyList(context);
                break;
            case "UpdateBudget":
                UpdateBudget(context);
                break;
            case "CompanyInfo":
                GetCompanyInfo(context);
                break;
            case "CompanyInfoList":
                GetCompanyInfoList(context);
                break;
            case "SaveBudget":
                SaveBudget(context);
                break;
            case "SaveBudgetAccount":
                SaveBudgetAccount(context);
                break;
            //case "CreateBudgetAccountCode":
            //    CreateBudgetAccountCode(context);
            //    break;
            case "BudgetAccountList":
                GetBudgetAccountList(context);
                break;
            case "BAModifyHistoryList":
                GetBAModifyHistoryList(context);
                break;
            case "UpdateBAUseStatus":
                UpdateBAUseStatus(context);
                break;
            default:
                break;
        }
    }

    public void GetAdminBudgetList(HttpContext context)
    {
        string keyword1 = context.Request.Form["Keyword1"].AsText();
        string keyword2 = context.Request.Form["Keyword2"].AsText();
        string keyword3 = context.Request.Form["Keyword3"].AsText();
        string keyword4 = context.Request.Form["Keyword4"].AsText();
        string target1 = context.Request.Form["Target1"].AsText();
        string target2 = context.Request.Form["Target2"].AsText();
        string target3 = context.Request.Form["Target3"].AsText();
        string target4 = context.Request.Form["Target4"].AsText();

        int pageNo = context.Request.Form["PageNo"].AsInt();
        int pageSize = context.Request.Form["PageSize"].AsInt();
        var paramList = new Dictionary<string, object> {
           { "nvar_P_SEARCHKEYWORD_1", keyword1},
           { "nvar_P_SERACHTARGET_1", target1},
           { "nvar_P_SEARCHKEYWORD_2", keyword2},
           { "nvar_P_SERACHTARGET_2", target2},
           { "nvar_P_SEARCHKEYWORD_3", keyword3},
           { "nvar_P_SERACHTARGET_3", target3},
           { "nvar_P_SEARCHKEYWORD_4", keyword4},
            { "nvar_P_SERACHTARGET_4", target4},
             { "inte_P_PAGENO", pageNo},
           { "inte_P_PAGESIZE", pageSize}
        };
        var list = CompanyService.GetAdminBudgetList(paramList);
        var returnjsonData = JsonConvert.SerializeObject(list);

        context.Response.ContentType = "text/json";
        context.Response.Write(returnjsonData);
    }

    public void GetAdminBudgetModifyList(HttpContext context)
    {
        string keyword = context.Request.Form["Keyword"].AsText();
        string sDate = context.Request.Form["Sdate"].AsText();
        string eDate = context.Request.Form["Edate"].AsText();
        string year = context.Request.Form["Year"].AsText();
        string month = context.Request.Form["Month"].AsText();
        string compNo = context.Request.Form["CompNo"].AsText();
        string uniqueNo = context.Request.Form["UniqueNo"].AsText();
        string compCode = context.Request.Form["CompCode"].AsText();
        string areaCdoe = context.Request.Form["CompAreaCode"].AsText();
        string bdeptCode = context.Request.Form["CompBDeptCode"].AsText();
        string deptCode = context.Request.Form["CompDeptCode"].AsText();
        string svidUser = context.Request.Form["SvidUser"].AsText();
        int pageNo = context.Request.Form["PageNo"].AsInt();
        int pageSize = context.Request.Form["PageSize"].AsInt();

        var paramList = new Dictionary<string, object> {
           { "nvar_P_SEARCHKEYWORD", keyword},
           { "nvar_P_TOSDATE", sDate},
           { "nvar_P_TOEDATE", eDate},
           { "nvar_P_YEAR", year},
           { "nvar_P_MONTH", month},
           { "nvar_P_COMPNO", compNo},
           { "nvar_P_UNIQUENO", uniqueNo},
           { "nvar_P_COMPCODE", compCode},
           { "nvar_P_COMPAREACODE", areaCdoe},
           { "nvar_P_COMPBUSINESSDEPTCODE", bdeptCode},
           { "nvar_P_COMPDEPTCODE", deptCode},
           { "nvar_P_SVIDUSER", svidUser},
           { "inte_P_PAGENO", pageNo},
           { "inte_P_PAGESIZE", pageSize}
        };
        var list = CompanyService.GetAdminBudgetModifyList(paramList);
        var returnjsonData = JsonConvert.SerializeObject(list);

        context.Response.ContentType = "text/json";
        context.Response.Write(returnjsonData);
    }

    // 예산 수정
    protected void UpdateBudget(HttpContext context)
    {
        string year = context.Request.Form["Year"].AsText();
        string month = context.Request.Form["Month"].AsText();
        string compNo = context.Request.Form["CompNo"].AsText();
        string uniqueNo = context.Request.Form["UniqueNo"].AsText();
        string compCode = context.Request.Form["CompCode"].AsText();
        string areaCdoe = context.Request.Form["CompAreaCode"].AsText();
        string bdeptCode = context.Request.Form["CompBDeptCode"].AsText();
        string deptCode = context.Request.Form["CompDeptCode"].AsText();
        Int64 cost= context.Request.Form["Cost"].AsInt64();
        string svidUser = context.Request.Form["SvidUser"].AsText();
        string mSvidUser = context.Request.Form["MSvidUser"].AsText();
        string remark = context.Request.Form["Remark"].AsText();

        var paramList = new Dictionary<string, object>() {
               { "nvar_P_YEAR", year},
               { "nvar_P_MONTH", month},
               { "nvar_P_COMPNO", compNo},
               { "nvar_P_UNIQUENO", uniqueNo},
               { "nvar_P_COMPCODE", compCode},
               { "nvar_P_COMPAREACODE", areaCdoe},
               { "nvar_P_COMPBUSINESSDEPTCODE", bdeptCode},
               { "nvar_P_COMPDEPTCODE", deptCode},
               { "nume_P_BUDGETCOST", cost},
               { "nvar_P_SVID_USER", svidUser},
               { "nvar_P_MOBISVID_USER", mSvidUser},
               { "nvar_P_REMARK", remark},
        };

        CompanyService.UpdateBudget(paramList);

        context.Response.ContentType = "text/plain";
        context.Response.Write("Success");
    }

    public void SaveBudget(HttpContext context)
    {
        string yyyy = context.Request.Form["YYYY"].AsText();
        string mm = context.Request.Form["MM"].AsText();
        string sviduser = context.Request.Form["SvidUser"].AsText();
        string compCode = context.Request.Form["CompCode"].AsText();
        int compArea = context.Request.Form["CompArea"].AsInt();
        string compBusinessDept = context.Request.Form["CompBusinessDept"].AsText();
        string deptCode = context.Request.Form["DeptCode"].AsText();
        Int64 budget = context.Request.Form["Budget"].AsInt64();

        var paramList = new Dictionary<string, object> {
           { "nvar_P_YYYY ", yyyy},
           { "nvar_P_MM", mm},
           { "nvar_P_COMPANY_CODE", compCode},
           { "inte_P_COMPANYAREA_CODE", compArea},
           { "nvar_P_COMPBUSINESSDEPT_CODE", compBusinessDept},
           { "nvar_P_COMPANYDEPT_CODE", deptCode},
           { "nvar_P_SVID_USER", sviduser},
           { "inte_P_BUDGETCOST", budget},
           { "reVa_P_RETURN",0 },
        };
        var returnData = CompanyService.SaveBudget(paramList);
        context.Response.ContentType = "text/plain";
        context.Response.Write(returnData);
    }

    public void SaveBudgetAccount(HttpContext context)
    {
        string sviduser = context.Request.Form["SvidUser"].AsText();
        string compCode = context.Request.Form["CompCode"].AsText();
        string budgetAccountCode = context.Request.Form["BudgetAccountCode"].AsText();
        string budgetAccountName = context.Request.Form["BudgetAccountName"].AsText();

        var paramList = new Dictionary<string, object> {
           { "nvar_P_COMPANY_CODE", compCode},
           { "nvar_P_BUDGETACCOUNTCODE", budgetAccountCode},
           { "nvar_P_BUDGETACCOUNTNAME", budgetAccountName},
           { "nvar_P_SVID_USER", sviduser},
        };
        CompanyService.SaveBudgetAccount(paramList);
        context.Response.ContentType = "text/plain";
        context.Response.Write("OK");
    }

    public void GetCompanyInfo(HttpContext context)
    {
        string type = context.Request.Form["Type"].AsText();
        string textValue = context.Request.Form["TextValue"].AsText();

        var paramList = new Dictionary<string, object> {
           { "nvar_P_TYPE", type},
           { "nvar_P_SEARCHKEYWORD", textValue},
        };
        var list = CompanyService.GetCompanyInfo(paramList);
        var returnjsonData = JsonConvert.SerializeObject(list);

        context.Response.ContentType = "text/json";
        context.Response.Write(returnjsonData);
    }

    public void GetCompanyInfoList(HttpContext context)
    {
        string type = context.Request.Form["Type"].AsText();
        string searchKeyword = context.Request.Form["SearchKeyword"].AsText();
        string searchTarget = context.Request.Form["SearchTarget"].AsText();
        int pageNo = context.Request.Form["PageNo"].AsInt();
        int pageSize = context.Request.Form["PageSize"].AsInt();
        string compCode = context.Request.Form["CompCode"].AsText();
        string compArea = context.Request.Form["CompArea"].AsText();
        string compBusinessDept = context.Request.Form["CompBusinessDept"].AsText();

        var paramList = new Dictionary<string, object> {
           { "nvar_P_TYPE", type},
           { "nvar_P_SEARCHKEYWORD", searchKeyword},
           { "nvar_P_SERACHTARGET", searchTarget},
           { "inte_P_PAGENO", pageNo},
           { "inte_P_PAGESIZE", pageSize},
           { "nvar_P_COMPCODE", compCode},
           { "nvar_P_COMPAREACODE", compArea},
           { "nvar_P_COMPBUSINESSDEPT_CODE", compBusinessDept},

        };
        var list = CompanyService.GetCompanyInfoList(paramList);
        var returnjsonData = JsonConvert.SerializeObject(list);

        context.Response.ContentType = "text/json";
        context.Response.Write(returnjsonData);
    }

    //<<계산예정코드 자동 생성>>
    //public void CreateBudgetAccountCode(HttpContext context)
    //{
    //    string companyCode = context.Request.Form["CompanyCode"];

    //    var paramList = new Dictionary<string, object>()
    //    {
    //        {"nvar_P_COMPCODE", companyCode }
    //    };
    //    var lastDeptCode = CompanyService.GetLastBudgetAccountCode(paramList); //예산계정코드의 마지막 코드를 가지고 옴

    //    string nextCode = string.Empty;

    //    if (!string.IsNullOrWhiteSpace(lastDeptCode))
    //    {
    //        nextCode = StringValue.GetNextCodeOneAndFourNum(lastDeptCode); //코드 자동생성
    //    }
    //    else
    //    {
    //        nextCode = "A0001"; //최초 부서코드
    //    }

    //    context.Response.ContentType = "text/plain";
    //    context.Response.Write(nextCode);

    //}

    //예산 계정 리스트
    public void GetBudgetAccountList(HttpContext context)
    {
        string keyword = context.Request.Form["Keyword"].AsText();   //키워드
        string target = context.Request.Form["Target"].AsText();//드롭다운리스트 타겟
        string confirmFlag = context.Request.Form["ConfirmFlag"].AsText(); // 승인여부
        string userFlag = context.Request.Form["UseFlag"].AsText(); // 승인여부
        int pageNo = context.Request.Form["PageNo"].AsInt();
        int pageSize = context.Request.Form["PageSize"].AsInt();

        var paramList = new Dictionary<string, object> {
           { "nvar_P_SEARCHKEYWORD", keyword},
           { "nvar_P_SERACHTARGET", target},
           { "nvar_P_USEFLAG", userFlag},
           { "inte_P_PAGENO", pageNo},
           { "inte_P_PAGESIZE", pageSize}
        };
        var list = CompanyService.GetAdminBudgetAccountList(paramList);
        var returnjsonData = JsonConvert.SerializeObject(list);

        context.Response.ContentType = "text/json";
        context.Response.Write(returnjsonData);
    }

    //예산계정 변경이력 리스트
    public void GetBAModifyHistoryList(HttpContext context)
    {
        string keyword = context.Request.Form["Keyword"].AsText();   //변경자명 검색 키워드
        string svidUser = context.Request.Form["SvidUser"].AsText();   //해당 유저 시퀀스
        string compNo = context.Request.Form["CompNo"].AsText();   //사업자 번호
        string accountCode = context.Request.Form["AccountCode"].AsText();   //예산계정 코드
        int pageNo = context.Request.Form["PageNo"].AsInt();
        int pageSize = context.Request.Form["PageSize"].AsInt();
        string sDate = context.Request.Form["Sdate"].AsText();
        string eDate = context.Request.Form["Edate"].AsText();
        var paramList = new Dictionary<string, object> {

           { "nvar_P_SEARCHKEYWORD", keyword},
           { "nvar_P_TOSDATE", sDate},
           { "nvar_P_TOEDATE", eDate},
           { "nvar_P_COMPNO", compNo},
           { "nvar_P_BUDGETACCOUNTCODE", accountCode},
           { "nvar_P_SVIDUSER", svidUser},
           { "inte_P_PAGENO", pageNo},
           { "inte_P_PAGESIZE", pageSize},

        };
        var list = CompanyService.GetAdminBudgetAccountModifyList(paramList);
        var returnjsonData = JsonConvert.SerializeObject(list);

        context.Response.ContentType = "text/json";
        context.Response.Write(returnjsonData);
    }


    //예산계정 사용유무 업데이트
    public void UpdateBAUseStatus(HttpContext context)
    {
        string compNo = context.Request.Form["CompNo"].AsText();   //사업자 번호
        string compCode = context.Request.Form["CompCode"].AsText();   //회사 코드
        string accountCode = context.Request.Form["AccountCode"].AsText();   //예산계정 코드
        string sviduser = context.Request.Form["SvidUser"].AsText();  //등록자 시퀀스
        string mSviduser = context.Request.Form["MsvidUser"].AsText(); //사용자 시퀀스
        string remark = context.Request.Form["Remark"].AsText(); //변경사유
        string useFlag = context.Request.Form["UseFlag"].AsText(); //사용유무


        var paramList = new Dictionary<string, object> {
           { "nvar_P_COMPNO ", compNo},
           { "nvar_P_COMPCODE", compCode},
           { "nvar_P_BUGETACCOUNTCODE", accountCode},
           { "nvar_P_SVIDUSER", sviduser},
           { "nvar_P_MODISVID_USER", mSviduser},
           { "nvar_P_REMARK", remark},
           { "char_P_USEFLAG", useFlag},
        };
        CompanyService.UpdateBudgetAccountUseStatus(paramList);
        context.Response.ContentType = "text/plain";
        context.Response.Write("OK");
    }
    public bool IsReusable {
        get {
            return false;
        }
    }

}