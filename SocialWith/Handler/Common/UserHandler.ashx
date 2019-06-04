<%@ WebHandler Language="C#" Class="UserHandler" %>

using System;
using System.Web;
using SocialWith.Biz.User;
using Urian.Core;
using System.Collections.Generic;
using Newtonsoft.Json;
using SocialWith.Biz.Platform;
using NLog;
public class UserHandler : IHttpHandler
{
    #region << logger >>
    protected static Logger logger = NLog.LogManager.GetCurrentClassLogger();
    protected static readonly bool IsDebugEnabled = logger.IsDebugEnabled;
    protected static readonly bool IsInfoEnabled = logger.IsInfoEnabled;
    protected static readonly bool IsWarnEnabled = logger.IsWarnEnabled;
    protected static readonly bool IsErrorEnabled = logger.IsErrorEnabled;
    protected static readonly bool IsFatalEnabled = logger.IsFatalEnabled;
    #endregion
    UserService userService = new UserService();
    PlatformService PlatformService = new PlatformService();

    public void ProcessRequest(HttpContext context)
    {
        string method = context.Request.Form["Method"].AsText();
        switch (method)
        {
            case "GetAdminUserList": //관리자 회원관리 리스트(구매자/판매자)
                GetAdminUserList(context);
                break;
            case "GetUserModifyHistoryList":  //관리자 회원관리 변경이력 리스트
                GetUserModifyHistoryList(context);
                break;
            case "GetAdminUserStatus":        // 관리자 회원관리 회원수 카운트(승인/미승인 중지 탈퇴)
                GetAdminUserStatus(context);
                break;
            case "UpdateUserUseStatus":     //관리자 회원관리 사용유무 설정
                UpdateUserUseStatus(context);
                break;
            case "PlatformTypeMgt":
                PlatformTypeMgt(context);
                break;
            case "GetCompanyList":
                GetCompanyList(context);
                break;
            case "GetCompanyBuyer_List":
                GetCompanyBuyer_List(context);
                break;
            case "GetCompanySearch":
                GetCompanySearch(context);
                break;
            case "UserConfirm_Admin":
                UpdateUserConfirm(context);
                break;
            case "GetUserList_A":
                GetUserList_A(context);
                break;
            case "GetUserSearchList":
                GetUserSearchList(context); //[관리자]판매사(A)/구매사(B)/관리자(D) 소속 아이디 조회
                break;
            case "GetUserListByGubun":
                GetUserListByGubun(context); //관계사 연동관리 고정판매사 변경 유저관리 설정
                break;

            case "GetSocialCompanyUserLinkList":
                GetSocialCompanyUserLinkList(context);
                break;

            case "DeleteSocialCompanyUserLink":
                DeleteSocialCompanyUserLink(context);
                break;
            case "SetBuyerLogOut": //구매사 로그아웃
                SetBuyerLogOut(context);
                break;
            case "SetAdminLogOut": //관리자 로그아웃
                SetAdminLogOut(context);
                break;

        }
    }

    public void GetAdminUserList(HttpContext context)
    {
        string keyword1 = context.Request.Form["Keyword1"].AsText();   //아이디 담당자명 키워드
        string keyword2 = context.Request.Form["Keyword2"].AsText();   //회사명 회사코드 사업자 번호 키워드
        string keyword3 = context.Request.Form["Keyword3"].AsText(); //사업장코드 사업자명 키워드
        string keyword4 = context.Request.Form["Keyword4"].AsText(); //사업부코드 사업부명 키워드
        string keyword5 = context.Request.Form["Keyword5"].AsText(); //부서코드 부서명 키워드
        string target1 = context.Request.Form["Target1"].AsText();//아이디 담당자명 타겟
        string target2 = context.Request.Form["Target2"].AsText(); //회사명 회사코드 사업자 번호  타겟
        string target3 = context.Request.Form["Target3"].AsText();//사업장코드 사업자명  타겟
        string target4 = context.Request.Form["Target4"].AsText();//사업부코드 사업부명  타겟
        string target5 = context.Request.Form["Target5"].AsText();//부서코드 부서명  타겟
        string confirmFlag = context.Request.Form["ConfirmFlag"].AsText(); // 승인여부
        string userFlag = context.Request.Form["UseFlag"].AsText(); // 승인여부
        string type = context.Request.Form["Type"].AsText(); // 판매사(A) 구매사(B) 구분

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
           { "nvar_P_SEARCHKEYWORD_5", keyword5},
           { "nvar_P_SERACHTARGET_5", target5},
           { "nvar_P_CONFIRMFLAG", confirmFlag},
           { "nvar_P_USEFLAG", userFlag},
           { "char_P_TYPE", type},
           { "inte_P_PAGENO", pageNo},
           { "inte_P_PAGESIZE", pageSize}
        };
        var list = userService.GetUserList_Admin(paramList);

        if (list != null)
        {
            //복호화
            for (int i = 0; i < list.Count; i++)
            {
                string encPhoneNo = list[i].PhoneNo.AsText();
                list[i].PhoneNo = Crypt.AESDecrypt256(encPhoneNo);

                string encEmail = list[i].Email.AsText();
                list[i].Email = Crypt.AESDecrypt256(encEmail);
            }
        }

        var returnjsonData = JsonConvert.SerializeObject(list);

        context.Response.ContentType = "text/json";
        context.Response.Write(returnjsonData);
    }

    public void GetUserModifyHistoryList(HttpContext context)
    {
        string keyword = context.Request.Form["Keyword"].AsText();   //변경자명 검색 키워드
        string svidUser = context.Request.Form["SvidUser"].AsText();   //해당 유저 시퀀스
        int pageNo = context.Request.Form["PageNo"].AsInt();
        int pageSize = context.Request.Form["PageSize"].AsInt();
        string sDate = context.Request.Form["Sdate"].AsText();
        string eDate = context.Request.Form["Edate"].AsText();
        var paramList = new Dictionary<string, object> {
           { "nvar_P_SVID_USER", svidUser},
           { "nvar_P_SEARCHKEYWORD", keyword},
           { "inte_P_PAGENO", pageNo},
           { "inte_P_PAGESIZE", pageSize},
           { "nvar_P_TOSDATE", sDate},
           { "nvar_P_TOEDATE", eDate},
        };
        var list = userService.GetUserModifyHistoryList(paramList);
        var returnjsonData = JsonConvert.SerializeObject(list);

        context.Response.ContentType = "text/json";
        context.Response.Write(returnjsonData);
    }

    //관리자 회원관리 (현황)
    public void GetAdminUserStatus(HttpContext context)
    {
        string type = context.Request.Form["Type"].AsText();   //판매사 구매사 타입

        var paramList = new Dictionary<string, object> {
           { "char_P_TYPE", type},

        };
        var list = userService.GetAdminUserStatus(paramList);
        var returnjsonData = JsonConvert.SerializeObject(list);

        context.Response.ContentType = "text/json";
        context.Response.Write(returnjsonData);
    }


    //판매사 조회
    protected void GetCompanyList(HttpContext context)
    {

        //string gubun = context.Request.Form["Gubun"];
        string SearchKeyWord = context.Request.Form["SearchKeyWord"].AsText();
        int pageNo = context.Request.Form["PageNo"].AsInt();
        int pageSize = context.Request.Form["PageSize"].AsInt();
        UserService UserService = new UserService();

        var paramList = new Dictionary<string, object> {
            {"nvar_P_SEARCHKEYWORD", SearchKeyWord},
            {"inte_P_PAGENO", pageNo},
            {"inte_P_PAGESIZE", pageSize }
        };

        var list = UserService.Update_PG_Company(paramList);

        var returnjsonData = JsonConvert.SerializeObject(list);
        HttpContext.Current.Response.ContentType = "text/json";
        HttpContext.Current.Response.Write(returnjsonData);

    }
    //구매사 조회
    protected void GetCompanyBuyer_List(HttpContext context)
    {

        //string gubun = context.Request.Form["Gubun"];
        string SearchKeyWord = context.Request.Form["bSearchKeyWord"].AsText();
        int pageNo = context.Request.Form["PageNo"].AsInt();
        int pageSize = context.Request.Form["PageSize"].AsInt();
        UserService UserService = new UserService();

        var paramList = new Dictionary<string, object> {
            {"nvar_P_SEARCHKEYWORD", SearchKeyWord},
            {"inte_P_PAGENO", pageNo},
            {"inte_P_PAGESIZE", pageSize }
        };

        var list = UserService.BuyerLoan_List(paramList);

        var returnjsonData = JsonConvert.SerializeObject(list);
        HttpContext.Current.Response.ContentType = "text/json";
        HttpContext.Current.Response.Write(returnjsonData);

    }

    //PG등록을 위한 판매사 검색
    protected void GetCompanySearch(HttpContext context)
    {

        //string gubun = context.Request.Form["Gubun"];
        string SearchKeyWord = context.Request.Form["SearchKeyWord"].AsText();
        int pageNo = context.Request.Form["PageNo"].AsInt();
        int pageSize = context.Request.Form["PageSize"].AsInt();

        UserService UserService = new UserService();

        var paramList = new Dictionary<string, object> {
            {"nvar_P_SEARCHKEYWORD", SearchKeyWord},
            {"inte_P_PAGENO", pageNo},
            {"inte_P_PAGESIZE", pageSize }
        };

        var list = UserService.Update_PG_Company(paramList);

        var returnjsonData = JsonConvert.SerializeObject(list);
        HttpContext.Current.Response.ContentType = "text/json";
        HttpContext.Current.Response.Write(returnjsonData);

    }
    //asda
    protected void GetUserList_A(HttpContext context)
    {

        //string gubun = context.Request.Form["Gubun"];
        string sdate = context.Request.Form["StartDate"].AsText();
        string edate = context.Request.Form["EndDate"].AsText();
        string svidUser = context.Request.Form["SvidUser"].AsText();

        int pageNo = context.Request.Form["PageNo"].AsInt();
        int pageSize = context.Request.Form["PageSize"].AsInt();
        UserService UserService = new UserService();
        var paramList = new Dictionary<string, object> {
             {"inte_P_PAGENO", pageNo },
            {"inte_P_PAGESIZE",pageSize },
            {"nvar_P_TODATEB", sdate },
            {"nvar_P_TODATEE", edate },
            {"nvar_P_SVID_USER", svidUser }
        };

        var list = UserService.GetUserList_A(paramList);

        var returnjsonData = JsonConvert.SerializeObject(list);
        HttpContext.Current.Response.ContentType = "text/json";
        HttpContext.Current.Response.Write(returnjsonData);

    }



    //사용자 사용유무 업데이트
    public void UpdateUserUseStatus(HttpContext context)
    {
        string sviduser = context.Request.Form["SvidUser"].AsText();
        string dropSvidUser = context.Request.Form["DropSvidUser"].AsText();
        string reason = context.Request.Form["Reason"].AsText();
        string useFlag = context.Request.Form["UseFlag"].AsText();


        var paramList = new Dictionary<string, object> {
           { "nvar_P_SVID_USER ", sviduser},
           { "nvar_P_DROP_SVID_USER", dropSvidUser},
           { "nvar_P_DROPUSERREASON", reason},
           { "char_P_USEFLAG", useFlag},
        };
        userService.UpdateUserUseStatus_Admin(paramList);
        context.Response.ContentType = "text/plain";
        context.Response.Write("OK");
    }
    //[관리자]판매사 플랫폼 관리
    protected void PlatformTypeMgt(HttpContext context)
    {
        string code = context.Request.Form["Code"].AsText();
        string delFlag = context.Request.Form["DelFlag"].AsText();
        var paramList = new Dictionary<string, object>
        {
            { "char_P_TYPE", "A" },
            { "nvar_P_URIANPLATFORMCODE", code },
            { "char_P_DELFLAG", delFlag },
            { "nvar_P_URIANPLATFORMNAME", "" },
            { "nvar_P_REMARK", "" },
        };

        PlatformService.PlatformTypeMgt(paramList);

        HttpContext.Current.Response.ContentType = "text/plain";
        HttpContext.Current.Response.Write("OK");
    }

    //[관리자]사용자 승인
    protected void UpdateUserConfirm(HttpContext context)
    {
        //var param = { SvidUser: sUser, Gubun: gubun, SvidRole: payRole, CompCode: compCode, CompNm: compNm, AreaCode: areaCode, BusinCode: businCode, DeptCode: deptCode, Method: "UserConfirm" };
        string svidUser = context.Request.Form["SvidUser"].AsText();
        string gubun = context.Request.Form["Gubun"].AsText();
        string svidRole = context.Request.Form["SvidRole"].AsText();
        string confirmFlag = context.Request.Form["ConfirmFlag"].AsText();
        string compCode = context.Request.Form["CompCode"].AsText();
        string compNm = context.Request.Form["CompNm"].AsText();
        string areaCode = context.Request.Form["AreaCode"].AsText();
        string businCode = context.Request.Form["BusinCode"].AsText();
        string deptCode = context.Request.Form["DeptCode"].AsText();
        string deptName = context.Request.Form["DeptName"].AsText();
        string compNo = context.Request.Form["CompNo"].AsText();
        string userEmail = context.Request.Form["UserEmail"].AsText();
        string useAdminRoleType = context.Request.Form["UseAdminRoleType"].AsText();

        //관리자 설정값인 경우 값 설정

        if (gubun.Equals("ADM"))
        {
            gubun = "AU";
            svidRole = "A1";
        }

        var paramList = new Dictionary<string, object>
        {
            { "nvar_P_SVID_USER", svidUser},
            { "nvar_P_GUBUN", gubun},
            { "nvar_P_SVID_ROLE", svidRole},
            { "nvar_P_CONFIRMFLAG", confirmFlag},
            { "nvar_P_COMPANY_NAME", compNm},
            { "nvar_P_COMPANY_CODE", compCode},
            { "nvar_P_COMPANYAREA_CODE", areaCode},
            { "nvar_P_COMPBUSINESSDEPT_CODE", businCode},
            { "nvar_P_COMPANYDEPT_CODE", deptCode},
            { "nvar_P_COMPANYDEPT_NAME", deptName},
            { "nvar_P_COMPANY_NO", compNo},
            { "nvar_P_ENTCODE", "A634"},
            { "nvar_P_EMAIL", userEmail},
            { "nvar_P_USEADMINROLETYPE", useAdminRoleType}
        };

        userService.UpdateUserConfirm(paramList);

        HttpContext.Current.Response.ContentType = "text/plain";
        HttpContext.Current.Response.Write("OK");
    }

    //[관리자]판매사(A)/구매사(B)/관리자(D) 소속 아이디 조회
    protected void GetUserSearchList(HttpContext context)
    {
        string gubun = context.Request.Form["Type"].AsText(); //판매사(A)/구매사(B)/관리자(D)
        string searchTarget = context.Request.Form["SearchTarget"].AsText();
        string searchKeyword = context.Request.Form["SearchKeyword"].AsText();

        int pageNo = context.Request.Form["PageNo"].AsInt();
        int pageSize = context.Request.Form["PageSize"].AsInt();

        UserService UserService = new UserService();
        var paramList = new Dictionary<string, object> {
            {"nvar_P_TYPE", gubun },
            {"nvar_P_SEARCHTARGET", searchTarget },
            {"nvar_P_SEARCHKEYWORD", searchKeyword },
            {"inte_P_PAGENO", pageNo },
            {"inte_P_PAGESIZE",pageSize },
        };

        var list = UserService.GetSearchUserList(paramList);

        var returnjsonData = JsonConvert.SerializeObject(list);
        HttpContext.Current.Response.ContentType = "text/json";
        HttpContext.Current.Response.Write(returnjsonData);
    }


    //관계사 고정 판매사 변경 유저관리 설정
    protected void GetUserListByGubun(HttpContext context)
    {
        string gubun = context.Request.Form["Gubun"].AsText(); //연동코드
        string socialCompanyLinkCode = context.Request.Form["SocialCompanyLinkCode"].AsText(); //연동코드
        string searchKeyword = context.Request.Form["SearchKeyword"].AsText();
        int pageNo = context.Request.Form["PageNo"].AsInt();
        int pageSize = context.Request.Form["PageSize"].AsInt();

        UserService UserService = new UserService();
        var paramList = new Dictionary<string, object> {
            {"nvar_P_GUBUN", gubun },
            {"nvar_P_SOCIALCOMPANYLINKCODE", socialCompanyLinkCode },
            {"nvar_P_SEARCHKEYWORD", searchKeyword },
            {"inte_P_PAGENO", pageNo },
            {"inte_P_PAGESIZE",pageSize },
        };

        var list = UserService.GetUserListByGubun(paramList);

        var returnjsonData = JsonConvert.SerializeObject(list);
        HttpContext.Current.Response.ContentType = "text/json";
        HttpContext.Current.Response.Write(returnjsonData);
    }

    // 관계사 연동관리 - 유저관리 목록 조회
    protected void GetSocialCompanyUserLinkList(HttpContext context)
    {

        //SocialComanyLinkService linkCompanyService = new SocialComanyLinkService();
        String target = context.Request.Form["SocialCompanyLink_Code"].AsText();

        var procParam = new Dictionary<string, object>{
            {"nvar_P_SOCIALCOMPANYLINKCODE",  target},
        };

        var list = userService.GetSocialCompanyUserLinkList(procParam);

        var returnjsonData = JsonConvert.SerializeObject(list);

        context.Response.ContentType = "text/json";
        context.Response.Write(returnjsonData);

    }

    // 관계사 연동관리 - 유저관리 목록에서 삭제
    protected void DeleteSocialCompanyUserLink(HttpContext context)
    {
        string unumSocialCompanyUserLink = context.Request.Form["P_UnumSocialCompanyUserLink"].AsText();

        var paramList = new Dictionary<string, object>
        {
            {"nvar_P_UNUMSOCIALCOMPANYUSERLINK", unumSocialCompanyUserLink}
        };

        userService.DeleteSocialCompanyUserLink(paramList);

        context.Response.ContentType = "text/plain";
        context.Response.Write("OK");
    }

    // 구매사 로그아웃
    protected void SetBuyerLogOut(HttpContext context)
    {
        string result = string.Empty;
        try
        {
            System.Web.Security.FormsAuthentication.SignOut();

            string svidSessionKey = "Svid_User";
            string loginIdsession = "LoginID";

            HttpCookie sviduser = new HttpCookie(svidSessionKey);
            HttpCookie id = new HttpCookie(loginIdsession);

            sviduser.Expires = DateTime.Now.AddDays(-1d);
            id.Expires = DateTime.Now.AddDays(-1d);

            HttpContext.Current.Response.SetCookie(sviduser);
            HttpContext.Current.Response.SetCookie(id);
            result = "OK";
        }
        catch (Exception)
        {
            result = "Fail";
            throw;
        }

        context.Response.ContentType = "text/plain";
        context.Response.Write(result);
    }

    // 관리자 로그아웃
    protected void SetAdminLogOut(HttpContext context)
    {
        string result = string.Empty;
        try
        {
            logger.Debug("로그아웃 진입");
            System.Web.Security.FormsAuthentication.SignOut();

            string svidSessionKey = "Admin_Svid_User";
            string loginIdSessionKey = "Admin_LoginID";

            HttpCookie sviduser = new HttpCookie(svidSessionKey);
            HttpCookie id = new HttpCookie(loginIdSessionKey);

            sviduser.Expires = DateTime.Now.AddDays(-1d);
            id.Expires = DateTime.Now.AddDays(-1d);

            HttpContext.Current.Response.SetCookie(sviduser);
            HttpContext.Current.Response.SetCookie(id);
            result = "OK";
        }
        catch (Exception)
        {
            result = "Fail";
            throw;
        }

        context.Response.ContentType = "text/plain";
        context.Response.Write(result);
    }

    public bool IsReusable
    {
        get
        {
            return false;
        }
    }

}