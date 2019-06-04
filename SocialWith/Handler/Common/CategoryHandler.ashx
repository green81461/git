<%@ WebHandler Language="C#" Class="CategoryHandler" %>

using System;
using System.Web;
using SocialWith.Biz.Category;
using System.Collections.Generic;
using Newtonsoft.Json;
using Urian.Core;

public class CategoryHandler : IHttpHandler
{

    public void ProcessRequest(HttpContext context)
    {

        string method = context.Request.Form["Method"];
        switch (method)
        {
            case "GetCategoryList":
                GetCategoryList(context);
                break;
            case "GetCategoryLevelList":
                GetCategoryLevelList(context);
                break;
            case "GetCategoryParentList":
                GetCategoryParentList(context);
                break;
            case "GetCategoryNaviList":
                GetCategoryNaviList(context);
                break;
            case "UpdateCategoryManagement":
                UpdateCategoryManagement(context);
                break;
            case "GetCtgrCurrNameList":
                GetCtgrCurrNameList(context);
                break;
            case "GetCtgrDepth":
                GetCtgrDepth(context);
                break;
            case "GetCategoryLevelRegister":
                GetCategoryLevelRegister(context);
                break;
            case "GetCategoryTreeList":
                GetCategoryTreeList(context);
                break;
            case "UpdateCategoryNo":
                UpdateCategoryNo(context);
                break;
            case "GetCategorySearchLog": //최근 본 카테고리 갖고오기
                GetCategorySearchLog(context);
                break;
            case "DeleteCategorySearchLog": //최근 본 카테고리 삭제
                DeleteCategorySearchLog(context);
                break;
            default:
                break;
        }
    }


    protected void GetCategoryList(HttpContext context)
    {

        string code = context.Request.Form["FinalCode"];
        string keyWord = context.Request.Form["Keyword"];
        string brandName = context.Request.Form["BrandName"];
        string goodsModel = context.Request.Form["GoodsModel"];
        string compCode = context.Request.Form["CompCode"];
        string saleCompCode = context.Request.Form["SaleCompCode"];
        string bCheck = context.Request.Form["BCheck"];
        CategoryService categoryService = new CategoryService();

        var paramList = new Dictionary<string, object>
            {
                { "nvar_P_CATEGORYFINALCODE", code},
                { "nvar_P_BRANDNAME ", brandName},
                { "nvar_P_SEARCHKEYWORD", keyWord},
                { "nvar_P_GOODSMODEL ", goodsModel},
                { "nvar_P_COMPCODE", compCode},
                { "nvar_P_SALECOMPCODE", saleCompCode},
                { "nvar_P_BDONGSHINCHECK", bCheck},
            };

        var list = categoryService.GetCategoryList(paramList);

        var returnjsonData = JsonConvert.SerializeObject(list);
        HttpContext.Current.Response.ContentType = "text/json";
        HttpContext.Current.Response.Write(returnjsonData);

    }

    protected void GetCategoryLevelList(HttpContext context)
    {
        string levelCode = context.Request.Form["LevelCode"];
        string upCode = context.Request.Form["UpCode"];
        CategoryService categoryService = new CategoryService();

        var paramList = new Dictionary<string, object>
            {
                {"nvar_P_CATEGORYLEVELCODE", levelCode }
              , {"nvar_P_CATEGORYUPCODE", upCode }
            };

        var list = categoryService.GetCategoryLevelList_Admin(paramList);

        var returnjsonData = JsonConvert.SerializeObject(list);
        HttpContext.Current.Response.ContentType = "text/json";
        HttpContext.Current.Response.Write(returnjsonData);

    }

        //관리자 카테고리 생성
    protected void GetCategoryLevelRegister(HttpContext context)
    {
        string levelCode = context.Request.Form["LevelCode"];
        string upCode = context.Request.Form["UpCode"];
        CategoryService categoryService = new CategoryService();

        var paramList = new Dictionary<string, object>
            {
                {"nvar_P_CATEGORYLEVELCODE", levelCode }
              , {"nvar_P_CATEGORYUPCODE", upCode }
            };

        var list = categoryService.GetCategoryLevelRegister(paramList);

        var returnjsonData = JsonConvert.SerializeObject(list);
        HttpContext.Current.Response.ContentType = "text/json";
        HttpContext.Current.Response.Write(returnjsonData);

    }

    protected void GetCategoryParentList(HttpContext context)
    {
        CategoryService categoryService = new CategoryService();

        var paramList = new Dictionary<string, object>
        {
        };

        var list = categoryService.GetCategoryParentList(paramList);

        var returnjsonData = JsonConvert.SerializeObject(list);
        HttpContext.Current.Response.ContentType = "text/json";
        HttpContext.Current.Response.Write(returnjsonData);

    }

    protected void GetCategoryNaviList(HttpContext context)
    {
        CategoryService categoryService = new CategoryService();

        var paramList = new Dictionary<string, object>
        {
        };

        var list = categoryService.GetCategoryNaviList(paramList);

        var returnjsonData = JsonConvert.SerializeObject(list);
        HttpContext.Current.Response.ContentType = "text/json";
        HttpContext.Current.Response.Write(returnjsonData);

    }

    // 카테고리 사용유무 업데이트
    protected void UpdateCategoryManagement(HttpContext context)
    {
        CategoryService categoryService = new CategoryService();

        string svidUser = context.Request.Form["SvidUser"].AsText();
        string categoryCode = context.Request.Form["CategoryCode"].AsText();
        string updateFlag = context.Request.Form["UpdateFlag"].AsText();

        var paramList = new Dictionary<string, object>() {
            {"nvar_P_SVIDUSER", svidUser}
            ,{"nvar_P_CATEGORYCODE", categoryCode}
            ,{"char_P_UPDATEFLAG", updateFlag}
        };

        categoryService.UpdateCategoryManagement(paramList);

        context.Response.ContentType = "text/plain";
        context.Response.Write("OK");
    }

    //현재 카테고리 메뉴명 상위 포함해서 조회
    protected void GetCtgrCurrNameList(HttpContext context)
    {
        string code = context.Request.Form["FinalCode"];
        CategoryService categoryService = new CategoryService();

        var paramList = new Dictionary<string, object> {
            { "nvar_P_CATEGORYFINALCODE", code},
        };

        var list = categoryService.GetCategoryCurrentName_List(paramList);

        var returnjsonData = JsonConvert.SerializeObject(list);
        HttpContext.Current.Response.ContentType = "text/json";
        HttpContext.Current.Response.Write(returnjsonData);
    }

    protected void GetCtgrDepth(HttpContext context)
    {
        string code = context.Request.Form["FinalCode"];
        CategoryService categoryService = new CategoryService();

        var paramList = new Dictionary<string, object> {
            { "nvar_P_CATEGORYFINALCODE", code},
        };

        var list = categoryService.GetCategoryDepth(paramList);

        var returnjsonData = JsonConvert.SerializeObject(list);
        HttpContext.Current.Response.ContentType = "text/plain";
        HttpContext.Current.Response.Write(returnjsonData);
    }

    protected void GetCategoryTreeList(HttpContext context)
    {
        CategoryService categoryService = new CategoryService();

        var paramList = new Dictionary<string, object>
            {
            };

        var list = categoryService.GetCategoryTreeList(paramList);

        var returnjsonData = JsonConvert.SerializeObject(list);
        HttpContext.Current.Response.ContentType = "text/json";
        HttpContext.Current.Response.Write(returnjsonData);

    }

    protected void UpdateCategoryNo(HttpContext context)
    {
        CategoryService categoryService = new CategoryService();

        string categoryNo = context.Request.Form["CategoryNo"].AsText();
        string categoryBaseNo = context.Request.Form["CategoryBaseNo"].AsText();
        string categoryUpNo = context.Request.Form["CategoryUpNo"].AsText();
        string categoryCode = context.Request.Form["CategoryCode"].AsText();

        var paramList = new Dictionary<string, object>() {
            {"nvar_P_CATEGORYNO", categoryNo},
            {"nva_P_CATEGORYBASENO", categoryBaseNo},
            {"nva_P_CATEGORYUPNO", categoryUpNo},
            {"nvar_P_CATEGORYFINALCODE", categoryCode}
        };

        categoryService.CategoryNoUpdate(paramList);

        context.Response.ContentType = "text/plain";
        context.Response.Write("OK");
    }

    protected void GetCategorySearchLog(HttpContext context)
    {

        string svidUser = context.Request.Form["SvidUser"];
        CategoryService categoryService = new CategoryService();

        var paramList = new Dictionary<string, object>
            {
                { "nvar_P_SVIDUSER", svidUser},
            };

        var list = categoryService.GetCategorySearchLogList(paramList);

        var returnjsonData = JsonConvert.SerializeObject(list);
        HttpContext.Current.Response.ContentType = "text/json";
        HttpContext.Current.Response.Write(returnjsonData);

    }


    protected void DeleteCategorySearchLog(HttpContext context)
    {
        string svidUser = context.Request.Form["SvidUser"];
        CategoryService categoryService = new CategoryService();

        var paramList = new Dictionary<string, object>
            {
                { "nvar_P_SVIDUSER", svidUser},
            };

        categoryService.CategorySearchLogDelete(paramList);

        context.Response.ContentType = "text/plain";
        context.Response.Write("OK");
    }
    public bool IsReusable
    {
        get
        {
            return false;
        }
    }

}