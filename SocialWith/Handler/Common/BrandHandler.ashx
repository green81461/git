<%@ WebHandler Language="C#" Class="BrandHandler" %>

using System;
using System.Web;
using SocialWith.Biz.Brand;
using System.Collections.Generic;
using Newtonsoft.Json;
using Urian.Core;

public class BrandHandler : IHttpHandler
{

    BrandService brandService = new BrandService();

    public void ProcessRequest(HttpContext context)
    {
        string method = context.Request.Form["Method"];
        switch (method)
        {
            case "GetBrandList":
                GetBrandList(context);
                break;

            case "GetBrandListTop10":
                GetBrandListTop10(context);
                break;
            case "BrandSearch_Admin":
                GetSearchBrandList_Admin(context);
                break;
            case "BrandList_Admin":
                GetSearchBrandPagingList_Admin(context);
                break;
            case "DelBrand":
                DeleteBrand(context);
                break;
            case "GetBrandListAdmin":
                BrandDataBind(context);
                break;
            case "UpdateBrand":
                UpdateBrand(context);
                break;
            default:
                break;
        }
    }

    protected void GetBrandList(HttpContext context)
    {

        string finalCode = context.Request.Form["FinalCode"];
        string keyWord = context.Request.Form["Keyword"];
        string compCode = context.Request.Form["CompCode"];
        string saleCompCode = context.Request.Form["SaleCompCode"];
        string bCheck = context.Request.Form["BCheck"];
        //  string brandCode = context.Request.Form["BrandCode"];

        var paramList = new Dictionary<string, object>
            {
                { "nvar_P_CATEGORYFINALCODE", finalCode},
                { "nvar_P_SEARCHKEYWORD", keyWord},
                { "nvar_P_COMPCODE", compCode},
                { "nvar_P_SALECOMPCODE", saleCompCode},
                { "nvar_P_BDONGSHINCHECK", bCheck},
                //{ "nvar_P_BRANDCODE", finalCode},
            };

        var list = brandService.GetBrandList(paramList);

        var returnjsonData = JsonConvert.SerializeObject(list);
        HttpContext.Current.Response.ContentType = "text/json";
        HttpContext.Current.Response.Write(returnjsonData);

    }

    protected void GetBrandListTop10(HttpContext context)
    {

        string finalCode = context.Request.Form["FinalCode"];
        string brandCode = context.Request.Form["BrandCode"];
        string brandName = context.Request.Form["BrandName"];
        string keyWord = context.Request.Form["Keyword"];
        string goodsModel = context.Request.Form["GoodsModel"];
        string compCode = context.Request.Form["CompCode"];
        string saleCompCode = context.Request.Form["SaleCompCode"];
        string bCheck = context.Request.Form["BCheck"];
        var paramList = new Dictionary<string, object>
            {
                { "nvar_P_CATEGORYFINALCODE", finalCode},
                { "nvar_P_BRANDCODE", brandCode},
                { "nvar_P_GOODSMODEL ", goodsModel},
                { "nvar_P_SEARCHKEYWORD", keyWord},
                { "nvar_P_BRANDNAME", brandName},
                { "nvar_P_COMPCODE", compCode},
                { "nvar_P_SALECOMPCODE", saleCompCode},
                { "nvar_P_BDONGSHINCHECK", bCheck},
            };

        var list = brandService.GetBrandListTop10(paramList);

        var returnjsonData = JsonConvert.SerializeObject(list);
        HttpContext.Current.Response.ContentType = "text/json";
        HttpContext.Current.Response.Write(returnjsonData);
    }

    //[관리자]브랜드검색(코드 or 명)
    protected void GetSearchBrandList_Admin(HttpContext context)
    {
        string keyword = context.Request.Form["BrandKeyword"].AsText();

        var paramList = new Dictionary<string, object> {
            { "nvar_P_KEYWORD", keyword}
        };

        var list = brandService.GetBrandSearchList_Admin(paramList);

        var returnJsonData = JsonConvert.SerializeObject(list);
        HttpContext.Current.Response.ContentType = "text/json";
        HttpContext.Current.Response.Write(returnJsonData);
    }

    //[관리자]브랜드검색2(코드 or 명)
    protected void GetSearchBrandPagingList_Admin(HttpContext context)
    {
        string keyword = context.Request.Form["SearchKeyword"].AsText();
        string target = context.Request.Form["SearchTarget"].AsText();
        int pageNo = context.Request.Form["PageNo"].AsInt();
        int pageSize = context.Request.Form["PageSize"].AsInt();

        var paramList = new Dictionary<string, object> {
             { "nvar_P_SEARCHKEYWORD", keyword},
             { "nvar_P_SERACHTARGET", target},
             { "char_P_ORDERVALUE", '1'},
             { "char_P_DELFLAG", 'N'},
             { "inte_P_PAGENO", pageNo},
             { "inte_P_PAGESIZE", pageSize},

        };

        var list = brandService.GetBrandList_Admin(paramList);

        var returnJsonData = JsonConvert.SerializeObject(list);
        HttpContext.Current.Response.ContentType = "text/json";
        HttpContext.Current.Response.Write(returnJsonData);
    }

    //[관리자]브랜드 삭제
    protected void DeleteBrand(HttpContext context)
    {
        string svidUser = context.Request.Form["SvidUser"].AsText();
        string brandCodes = context.Request.Form["BrandCodes"].AsText();
        string delFlag = context.Request.Form["DelFlag"].AsText();

        var paramList = new Dictionary<string, object>
        {
            { "char_P_TYPE", "A" },
            { "nvar_P_SVID_USER", svidUser },
            { "nvar_P_BRANDCODES", brandCodes },
            { "nvar_P_DELFLAG", delFlag },
            { "nvar_P_BRANDNAME", "" },
            { "nvar_P_REMARK", "" },
        };

        brandService.DeleteBrand(paramList);

        HttpContext.Current.Response.ContentType = "text/plain";
        HttpContext.Current.Response.Write("OK");
    }

    public bool IsReusable
    {
        get
        {
            return false;
        }
    }

    protected void BrandDataBind(HttpContext context)
    {

        string keyword = context.Request.Form["SearchKeyword"].AsText();
        string target = context.Request.Form["SearchTarget"].AsText();
        string orderValue = context.Request.Form["OrderValue"].AsText();
        string delFlag = context.Request.Form["DelFlag"].AsText();
        int pageNo = context.Request.Form["PageNo"].AsInt();
        int pageSize = context.Request.Form["PageSize"].AsInt();

        var paramList = new Dictionary<string, object> {
            {"nvar_P_SEARCHKEYWORD", keyword },
            {"nvar_P_SERACHTARGET", target },
            {"char_P_ORDERVALUE", orderValue },
            {"char_P_DELFLAG", delFlag },
            {"inte_P_PAGENO", pageNo },
            {"inte_P_PAGESIZE", pageSize },
        };

        var list = brandService.GetBrandList_Admin(paramList);

        var returnjsonData = JsonConvert.SerializeObject(list);
        HttpContext.Current.Response.ContentType = "text/json";
        HttpContext.Current.Response.Write(returnjsonData);

    }

    //[관리자]브랜드 정보 업데이트
    protected void UpdateBrand(HttpContext context)
    {
        string svidUser = context.Request.Form["SvidUser"].AsText();
        string code = context.Request.Form["BrandCode"].AsText();
        string name = context.Request.Form["BrandName"].AsText();
        string remark = context.Request.Form["Remark"].AsText();
        var paramList = new Dictionary<string, object>
        {
            { "char_P_TYPE", "B" },
            { "nvar_P_SVID_USER", svidUser },
            { "nvar_P_BRANDCODES",  code.Trim() },
            { "nvar_P_DELFLAG", "" },
            { "nvar_P_BRANDNAME", name.Trim() },
            { "nvar_P_REMARK", remark.Trim() },
        };

        brandService.DeleteBrand(paramList);

        HttpContext.Current.Response.ContentType = "text/plain";
        HttpContext.Current.Response.Write("OK");
    }

}