<%@ WebHandler Language="C#" Class="SocialCompanyHandler" %>

using System;
using System.Web;
using System.Collections.Generic;
using SocialWith.Biz.Comapny;
using Newtonsoft.Json;
using Urian.Core;
using SocialWith.Biz.Company;
using Oracle.ManagedDataAccess.Client;
using System.Configuration;
using System.Linq;



public class SocialCompanyHandler : IHttpHandler
{

    protected CompanyService CompanyService = new CompanyService();
    protected SocialComanyLinkService linkCompanyService = new SocialComanyLinkService();


    public void ProcessRequest(HttpContext context)
    {
        string method = context.Request.Form["Method"];
        switch (method)
        {

            case "SocialCompanyList": // 회사구분 목록 조회
                GetSocialCompanyList(context, "");
                break;
            case "SocialCompNameUpdate": // 회사구분명, 비고 수정
                SocialCompNameUpdate(context);
                break;
            case "SocialCompCodeGenerate": // 회사구분코드 생성
                SocialCompanyCodeGenerate(context);
                break;
            case "SearchSocialComp": // 회사구분 목록 검색
                GetSearchSocialCompList(context);
                break;
            case "SocialCompanyChkSeq": // 회사구분 목록 검색
                SocialCompanyChkSeq(context);
                break;
            case "SocialCompanyChkCom": // 회사구분 목록 검색
                SocialCompanyChkCom(context);
                break;

            case "SocialCompanySelect": // 회사구분 목록 검색
                SocialCompanySelect(context);
                break;

            case "GetSocialCompanyLinkList":
                GetSocialCompanyLinkList(context);
                break;

            case "SaveSocialCompanyLink":
                SaveSocialCompanyLink(context);
                break;

            case "DeleteSocialCompanyLink":
                DeleteSocialCompanyLink(context);
                break;

            case "GetSocialCompanyLinkGubunList": // 관계사 구분 코드 검색(관리자 고정 판매사 변경 화면)
                GetSocialCompanyLinkGubunList(context);
                break;

            case "GetSocialCompanyLinkNoPagingList": //관계사연동관리 페이징없는 리스트(관리자 고정 판매사 변경 화면)
                GetSocialCompanyLinkNoPagingList(context);
                break;

            case "UpdateSocialCompanySeq": //판매사고정 시퀀스 변경 
                UpdateSocialCompanySeq(context);
                break;
            case "SocialCompanyUserLink_Insert":
                SocialCompanyUserLink_Insert(context);
                break;

            default:
                break;
        }
    }

    protected void DeleteSocialCompanyLink(HttpContext context)
    {
        String code = context.Request.Form["Code"];

        var paramList = new Dictionary<string, object> {
            { "nvar_P_SOCIALCOMPANYLINK_CODE",code}
        };

        linkCompanyService.DeleteSocialCompanyLink(paramList);

        context.Response.ContentType = "text/plain";
        context.Response.Write("ok");

    }

    protected void SaveSocialCompanyLink(HttpContext context)
    {
        int txtSeq = context.Request.Form["txtSeq"].AsInt();
        String tstSdate = context.Request.Form["txtSdate"].AsText();
        String txtEdate = context.Request.Form["txtEdate"].AsText();
        String hfLinkCode = context.Request.Form["hfLinkCode"].AsText();
        String txtLinkName = context.Request.Form["txtLinkName"].AsText();
        String hfSaleCompCode = context.Request.Form["hfSaleCompCode"].AsText();
        String hfBuyCompCode = context.Request.Form["hfBuyCompCode"].AsText();
        String txtRemark = context.Request.Form["txtRemark"].AsText();

        var procParam = new Dictionary<string, object>{
            {"nvar_P_SOCIALCOMPANYLINK_CODE", hfLinkCode},        //회사연동코드
            {"nvar_P_SOCIALCOMPANYLINK_NAME", txtLinkName},       //회사연동명
            {"nvar_P_SALESOCIALCOMPANY_CODE", hfSaleCompCode},    //판매사 구분코드
            {"nvar_P_BUYSOCIALCOMPANY_CODE", hfBuyCompCode},      //구매사 구분코드
            {"inte_P_SOCIALCOMPANYLINKSEQ", txtSeq},           //관계사 연동 순번
            {"nvar_P_SOCIALCOMPANYLINKBEGINDATE", tstSdate},      //관계사 연동 시작일
            {"nvar_P_SOCIALCOMPANYLINKENDDATE", txtEdate},      //관계사 연동 종료일
            {"nvar_P_REMARK", txtRemark},                          //비고
        };

        linkCompanyService.SaveSocialCompanyLink(procParam); //부서별 배송지 리스트를 갖고옴

        context.Response.ContentType = "text/plain";
        context.Response.Write("ok");

    }

    protected void GetSocialCompanyLinkList(HttpContext context)
    {

        //SocialComanyLinkService linkCompanyService = new SocialComanyLinkService();
        String target = context.Request.Form["SearchTarget"].AsText();
        String KeyWord = context.Request.Form["SearchKeyword"].AsText();
        int PageNo = context.Request.Form["PageNo"].AsInt();
        int PageSize = context.Request.Form["PageSize"].AsInt();

        var procParam = new Dictionary<string, object>{
            {"nvar_P_SEARCHTARGET",  target},
            {"nvar_P_SEARCHKEYWORD", KeyWord},
            {"inte_P_PAGENO", PageNo },
            {"inte_P_PAGESIZE", PageSize },
        };

        var list = linkCompanyService.GetSocialCompanyLinkList(procParam);

        var returnjsonData = JsonConvert.SerializeObject(list);

        context.Response.ContentType = "text/plain";
        context.Response.Write(returnjsonData);

    }

    // 회사구분 목록 조회
    protected void GetSocialCompanyList(HttpContext context, string nextCode)
    {
        string gubun = context.Request.Form["Gubun"]; // 회사구분(A:판매사, B:구매사)

        var paramList = new Dictionary<string, object> {
              { "nvar_P_SOCIALCOMPANY_CODE", ""}
            , { "nvar_P_GUBUN", gubun}
        };
        var list = CompanyService.GetSocialCompanyList(paramList);

        if ((list != null) && (list.Count > 0))
            list[0].NewCode = nextCode;

        var returnjsonData = JsonConvert.SerializeObject(list);

        context.Response.ContentType = "text/plain";
        context.Response.Write(returnjsonData);
    }

    // 회사구분 코드 자동 생성
    protected void SocialCompanyCodeGenerate(HttpContext context)
    {
        string gubun = context.Request.Form["Gubun"]; // 회사구분(A:판매사, B:구매사)

        var paramList = new Dictionary<string, object> {
              { "nvar_P_SOCIALCOMPANY_CODE", ""}
            , { "nvar_P_GUBUN", gubun}
        };
        var lastSocialCode = CompanyService.GetLastSocialCompanyCode(paramList); //회사구분의 마지막 코드를 가지고 옴

        string nextCode = string.Empty;

        if (!string.IsNullOrWhiteSpace(lastSocialCode))
        {
            nextCode = StringValue.GetNextSocialGubunCode(gubun, lastSocialCode); //코드 자동생성
        }
        else
        {
            nextCode = gubun + "0001"; //최초 코드
        }

        SocialCompanyInfoSave(context, nextCode); //사업장 정보 저장

    }

    // 회사구분 정보 저장
    protected void SocialCompanyInfoSave(HttpContext context, string nextCode)
    {
        string socialCompName = context.Request.Form["SocialCompName"]; // 회사구분명
        string remark = context.Request.Form["Remark"]; // 비고

        var paramList = new Dictionary<string, object>() {
             { "nvar_P_SOCIALCOMPANY_CODE", nextCode}
            ,{ "nvar_P_SOCIALCOMPANY_NAME", socialCompName}
            ,{ "nvar_P_REMARK", remark}
        };

        CompanyService.SaveSocialCompanyInfo(paramList);

        GetSocialCompanyList(context, nextCode);
    }

    // 회사구분 정보 수정
    protected void SocialCompNameUpdate(HttpContext context)
    {
        string socialCompCode = context.Request.Form["SocialCompCode"];
        string socialCompName = context.Request.Form["SocialCompName"]; // 회사구분명
        string remark = context.Request.Form["Remark"]; // 비고

        var paramList = new Dictionary<string, object>() {
             { "nvar_P_SOCIALCOMPANY_CODE", socialCompCode}
            ,{ "nvar_P_SOCIALCOMPANY_NAME", socialCompName}
            ,{ "nvar_P_REMARK", remark}
        };

        CompanyService.UpdateSocialCompanyInfo(paramList);

        GetSocialCompanyList(context, "");
    }

    //사업자 구분 검색
    public void GetSearchSocialCompList(HttpContext context)
    {
        string gubun = context.Request.Form["Gubun"]; // 회사구분(A:판매사, B:구매사)
        string socialCompNm = context.Request.Form["SocialCompNm"]; //사업자구분명 키워드
        int pageNo = context.Request.Form["PageNo"].AsInt();
        int pageSize = context.Request.Form["PageSize"].AsInt();

        var paramList = new Dictionary<string, object> {
            {"nvar_P_SOCIALCOMPANY_NAME", socialCompNm},
            {"nvar_P_GUBUN", gubun},
            {"inte_P_PAGENO", pageNo},
            {"inte_P_PAGESIZE", pageSize}
        };
        var list = CompanyService.GetSearchSocialCompList(paramList);

        var returnjsonData = JsonConvert.SerializeObject(list);

        context.Response.ContentType = "text/plain";
        context.Response.Write(returnjsonData);
    }

    //구매사 순번 seq체크
    public void SocialCompanyChkSeq(HttpContext context)
    {
        string chkCompanyCode = context.Request.Form["ChkCompanyCode"];
        string chkSaleCompanyCode = context.Request.Form["ChkSaleCompanyCode"];


        int seq = context.Request.Form["Seq"].AsInt();


        var paramList = new Dictionary<string, object> {
            {"nvar_P_BUYSOCIALCOMPANY_CODE", chkCompanyCode},
            {"nvar_P_SALECOMPANY_CODE", chkSaleCompanyCode}
        };
        var list = CompanyService.SocialCompanyChkSeq(paramList);

        var returnjsonData = JsonConvert.SerializeObject(list);

        HttpContext.Current.Response.ContentType = "text/json";
        HttpContext.Current.Response.Write(returnjsonData);
    }

    //회사 중복 체크
    public void SocialCompanyChkCom(HttpContext context)
    {
        string chkCompanyCode = context.Request.Form["ChkCompanyCode"];
        string chkSaleCompanyCode = context.Request.Form["ChkSaleCompanyCode"];

        var paramList = new Dictionary<string, object> {
            {"nvar_P_BUYSOCIALCOMPANY_CODE", chkCompanyCode},
            {"nvar_P_SALECOMPANY_CODE", chkSaleCompanyCode}
        };
        var list = CompanyService.SocialCompanyChkCom(paramList);

        var returnjsonData = JsonConvert.SerializeObject(list);

        HttpContext.Current.Response.ContentType = "text/json";
        HttpContext.Current.Response.Write(returnjsonData);
    }


    //구매사 순번 seq체크
    public void SocialCompanySelect(HttpContext context)
    {
        string chkCompanyCode = context.Request.Form["ChkCompanyCode"];
        int seq = context.Request.Form["Seq"].AsInt();



        var paramList = new Dictionary<string, object> {
            {"nvar_P_BUYSOCIALCOMPANY_CODE", chkCompanyCode},
              {"inte_P_SOCIALCOMPANYLINKSEQ", seq}

        };
        var list = CompanyService.SocialCompanySelect(paramList);

        var returnjsonData = JsonConvert.SerializeObject(list);

        HttpContext.Current.Response.ContentType = "text/json";
        HttpContext.Current.Response.Write(returnjsonData);
    }


    public bool IsReusable
    {
        get
        {
            return false;
        }
    }

    // 관계사 구분 코드 검색(관리자 고정 판매사 변경 화면)
    public void GetSocialCompanyLinkGubunList(HttpContext context)
    {
        String target = context.Request.Form["SearchTarget"].AsText();
        String KeyWord = context.Request.Form["SearchKeyword"].AsText();
        string gubun = context.Request.Form["Gubun"];
        int PageNo = context.Request.Form["PageNo"].AsInt();
        int PageSize = context.Request.Form["PageSize"].AsInt();

        var paramList = new Dictionary<string, object>
        {
            {"navr_P_SEARCHTARGET",  target},
            {"nvar_P_SEARCHKEYWORD", KeyWord},
            {"nvar_P_GUBUN", gubun},
            {"inte_P_PAGENO", PageNo },
            {"inte_P_PAGESIZE", PageSize }
        };

        var list = linkCompanyService.GetSocialCompanyLinkGubunList(paramList);

        var returnjsonData = JsonConvert.SerializeObject(list);

        HttpContext.Current.Response.ContentType = "text/json";
        HttpContext.Current.Response.Write(returnjsonData);

    }
    //관계사연동관리 페이징없는 리스트 (관계사 고정 판매사 변경 화면에서 사용)
    public void GetSocialCompanyLinkNoPagingList(HttpContext context)
    {
        String target = context.Request.Form["SearchTarget"].AsText();
        String KeyWord = context.Request.Form["SearchKeyword"].AsText();

        var paramList = new Dictionary<string, object>
        {
            {"navr_P_SEARCHTARGET",  target},
            {"nvar_P_SEARCHKEYWORD", KeyWord}
        };

        var list = linkCompanyService.GetSocialCompanyLinkNoPagingList(paramList);

        var returnjsonData = JsonConvert.SerializeObject(list);

        HttpContext.Current.Response.ContentType = "text/json";
        HttpContext.Current.Response.Write(returnjsonData);
    }

    //판매사고정 시퀀스 변경 
    public void UpdateSocialCompanySeq(HttpContext context)
    {
        String selectCode = context.Request.Form["SelectCode"].AsText();
        int selectSeq = context.Request.Form["SelectSeq"].AsInt();
        String currentSaleCode = context.Request.Form["CurrentSaleCode"].AsText();
        int currentSaleSeq = context.Request.Form["CurrentSaleSeq"].AsInt();

        var paramList = new Dictionary<string, object>
        {
            {"navr_P_SELECTCODE",  selectCode},
            {"inte_P_SELECTSEQ", selectSeq },
            {"navr_P_CURRENTSALECODE",  currentSaleCode},
            {"inte_P_CURRENTSALESEQ", currentSaleSeq }
        };

        linkCompanyService.UpdateSocialCompanySeq(paramList);

        GetSocialCompanyLinkNoPagingList(context);
    }

    //관계사 연동관리 유저관리 insert 
    protected void SocialCompanyUserLink_Insert(HttpContext context)
    {
      

        string menuData = context.Request.Form["MenuData"].AsText();
        var obj = JsonConvert.DeserializeObject<List<Dictionary<string, string>>>(menuData);

        using (OracleConnection connection = new OracleConnection(ConfigurationManager.AppSettings["ConnectionString"]))
        {
            connection.Open();
            using (OracleTransaction trans = connection.BeginTransaction())
            {

                try
                {

                    foreach (Dictionary<string, string> lst in obj)
                    {

                        var paramList = new Dictionary<string, object>
                        {
                          
                            { "nvar_P_SOCIALCOMPANYLINKCODE", lst["SocialCompanyLinkCode"].AsText() },
                            { "nvar_P_SVIDUSER", lst["SvidUser"].AsText() },
                            { "nvar_P_SALEGUBUNCODE", lst["SaleGubunCode"].AsText() },
                            { "nvar_P_BUYGUBUNCODE", lst["BuyGubunCode"].AsText() },
                           
                        };

                        linkCompanyService.SaveSocialCompanyUserLink(connection,paramList);

                    }

                    trans.Commit();   //커밋
                }
                catch (Exception)
                {
                    trans.Rollback();
                    throw;
                }

            }
        }

        HttpContext.Current.Response.ContentType = "text/plain";
        HttpContext.Current.Response.Write("OK");
    }

}