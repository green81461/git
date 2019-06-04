<%@ WebHandler Language="C#" Class="WishHandler" %>

using System;
using System.Web;
using System.Collections.Generic;
using Urian.Core;
using SocialWith.Biz.Wish;
using NLog;

public class WishHandler : IHttpHandler {

    #region << logger >>
    protected static Logger logger = NLog.LogManager.GetCurrentClassLogger();
    protected static readonly bool IsDebugEnabled = logger.IsDebugEnabled;
    protected static readonly bool IsInfoEnabled = logger.IsInfoEnabled;
    protected static readonly bool IsWarnEnabled = logger.IsWarnEnabled;
    protected static readonly bool IsErrorEnabled = logger.IsErrorEnabled;
    protected static readonly bool IsFatalEnabled = logger.IsFatalEnabled;
    #endregion


    WishService wishService = new WishService();
    string[] str = null;
    public void ProcessRequest (HttpContext context) {
        string type = context.Request.Form["Type"];
        switch (type)
        {
            case "AddWishGroupList":
                AddWishGroupList(context);
                break;
            case "SaveWishList":
                SaveWishList(context);
                break;
            case "MultiSaveWishList":
                MultiSaveWishList(context);
                break;
            case "MultiSaveWishListByCart":
                MultiSaveWishListByCart(context);
                break;
            default:
                break;
        }
    }

    // 장바구니에 저장
    protected void SaveWishList(HttpContext context)
    {
        string goodsFinalCategoryCode = context.Request.Form["GoodsFinCtgrCode"].AsText();
        string goodsGroupCode = context.Request.Form["GoodsGrpCode"].AsText();
        string goodsCode = context.Request.Form["GoodsCode"].AsText();
        string svid_user = context.Request.Form["SvidUser"].AsText();

        var paramList = new Dictionary<string, object>() {
             {"nvar_P_SVID_USER", svid_user}
            ,{"nvar_P_GOODSCODE", goodsCode}
            ,{"nvar_P_GOODSGROUPCODE", goodsGroupCode}
            ,{"nvar_P_GOODSFINALCATEGORYCODE", goodsFinalCategoryCode}
        };

        wishService.SaveWishList(paramList);

        context.Response.ContentType = "text/plain";
        context.Response.Write("{\"Result\": \"OK\"}");
    }

    // 관심상품 보관함에 저장
    protected void MultiSaveWishList(HttpContext context)
    {
        int count = context.Request.Form["Count"].AsInt();

        string goodsFinalCategoryCode = context.Request.Form["GoodsFinCtgrCode"].AsText();
        string goodsGroupCode = context.Request.Form["GoodsGrpCode"].AsText();
        string goodsCodes = context.Request.Form["GoodsCodes"].AsText();
        var goodsCodeArray = goodsCodes.Split('/');
        string svid_user = context.Request.Form["SvidUser"].AsText();

        for (int i = 1; i <= goodsCodeArray.Length; i++)
        {
            var goodsCode = goodsCodeArray[i - 1];
            var paramList = new Dictionary<string, object>() {
                {"nvar_P_SVID_USER", svid_user}
               ,{"nvar_P_GOODSCODE", goodsCode}
               ,{"nvar_P_GOODSGROUPCODE", goodsGroupCode}
               ,{"nvar_P_GOODSFINALCATEGORYCODE", goodsFinalCategoryCode}
            };

            wishService.SaveWishList(paramList);
        }
        context.Response.ContentType = "text/plain";
        context.Response.Write("{\"Result\": \"OK\"}");
    }

    // 장바구니에서 관심상품 보관함에 저장
    protected void MultiSaveWishListByCart(HttpContext context)
    {
        int count = context.Request.Form["Count"].AsInt();

        string goodsFinalCategoryCodes = context.Request.Form["GoodsFinCtgrCodes"].AsText();
        string goodsGroupCodes = context.Request.Form["GoodsGrpCodes"].AsText();
        string goodsCodes = context.Request.Form["GoodsCodes"].AsText();
        string moq = context.Request.Form["Qtys"].AsText();
        var goodsFinalCategoryCodeArray = goodsFinalCategoryCodes.Split('/');
        var goodsGroupCodeArray = goodsGroupCodes.Split('/');
        var goodsCodeArray = goodsCodes.Split('/');

        string svid_user = context.Request.Form["SvidUser"].AsText();

        for (int i = 1; i <= goodsCodeArray.Length; i++)
        {
            var categoryCode = goodsFinalCategoryCodeArray[i - 1];
            var groupCode = goodsGroupCodeArray[i - 1];
            var goodsCode = goodsCodeArray[i - 1];
            var paramList = new Dictionary<string, object>() {
                {"nvar_P_SVID_USER", svid_user}
               ,{"nvar_P_GOODSCODE", goodsCode}
               ,{"nvar_P_GOODSGROUPCODE", groupCode}
               ,{"nvar_P_GOODSFINALCATEGORYCODE", categoryCode}
            };

            wishService.SaveWishList(paramList);
        }
        context.Response.ContentType = "text/plain";
        context.Response.Write("{\"Result\": \"OK\"}");
    }


    public void AddWishGroupList(HttpContext context)
    {
        context.Response.ContentType = "text/plain";
        context.Response.Write(str[1]);

    }

    public bool IsReusable {
        get {
            return false;
        }
    }

}