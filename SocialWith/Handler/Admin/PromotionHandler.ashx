<%@ WebHandler Language="C#" Class="PromotionHandler" %>

using NLog;
using System;
using System.Web;
using System.Collections.Generic;
using SocialWith.Biz.Promotion;
using Newtonsoft.Json;
using Urian.Core;

public class PromotionHandler : IHttpHandler {
    #region << logger >>
    private static Logger logger = NLog.LogManager.GetCurrentClassLogger();
    private static readonly bool IsDebugEnabled = logger.IsDebugEnabled;
    private static readonly bool IsInfoEnabled = logger.IsInfoEnabled;
    private static readonly bool IsWarnEnabled = logger.IsWarnEnabled;
    private static readonly bool IsErrorEnabled = logger.IsErrorEnabled;
    private static readonly bool IsFatalEnabled = logger.IsFatalEnabled;
    #endregion

    protected PromotionService PromotionService = new PromotionService();

    public void ProcessRequest (HttpContext context) {
        string method = context.Request.Form["Method"];

        switch (method)
        {
            case "GetPromotionList":    // 프로모션 목록 조회
                GetPromotionList(context);
                break;
            case "GetPromotionGoodsList":    // 프로모션 상품 목록 조회
                GetPromotionGoodsList(context);
                break;
            case "GetPromotionAddGoodsList":    // 프로모션 상품 추가
                GetPromotionAddGoodsList(context);
                break;
            case "GetPromotionNextCode":    // 프로모션 NextCode생성
                GetPromotionNextCode(context);
                break;
            case "SavePromotion":    // 프로모션생성
                SavePromotion(context);
                break;
            case "MultiSavePromotion":    // 프로모션일괄생성
                MultiSavePromotion(context);
                break;
            case "DeletePromotion":    // 프로모션중지
                DeletePromotion(context);
                break;
            case "DuplCheck":     //프로모션 등록시 종료일기준 이미 같은구매사, 같은 상품 프로모션이 등록되어있는지 체크하는 프로시져
                PromotionDuplCheck(context);
                break;
            default:
                break;
        }
    }

    // 프로모션 목록 조회
    public void GetPromotionList(HttpContext context)
    {
        string keyword = context.Request.Form["Keyword"]; // 일단 구매사 코드만..
        string pageNo = context.Request.Form["PageNo"]; // 
        string pageSize = context.Request.Form["PageSize"]; // 
        var paramList = new Dictionary<string, object> {
           { "nvar_P_SEARCHKEYWORD", keyword},
           { "inte_P_PAGENO", pageNo},
           { "inte_P_PAGESIZE", pageSize},
        };
        var list = PromotionService.GetPromotionList(paramList);

        var returnjsonData = JsonConvert.SerializeObject(list);

        context.Response.ContentType = "text/json";
        context.Response.Write(returnjsonData);
    }

    // 프로모션 상품 목록 조회
    public void GetPromotionGoodsList(HttpContext context)
    {
        string target = context.Request.Form["Target"]; //상품명/상품코드
        string keyword = context.Request.Form["Keyword"]; // 
        string pageNo = context.Request.Form["PageNo"]; // 
        string pageSize = context.Request.Form["PageSize"]; // 
        var paramList = new Dictionary<string, object> {
           { "nvar_P_SEARCHTARGET", target},
           { "nvar_P_SEARCHKEYWORD", keyword},
           { "inte_P_PAGENO", pageNo},
           { "inte_P_PAGESIZE", pageSize},
        };
        var list = PromotionService.GetPromotionGoodsList(paramList);

        var returnjsonData = JsonConvert.SerializeObject(list);

        context.Response.ContentType = "text/json";
        context.Response.Write(returnjsonData);
    }

    // 프로모션 상품 목록 조회
    public void GetPromotionAddGoodsList(HttpContext context)
    {
        string codes = context.Request.Form["GoodsCodes"]; //추가될 상품코드
        var paramList = new Dictionary<string, object> {
           { "nvar_P_GOODSCODES", codes},
        };
        var list = PromotionService.GetPromotionAddGoodsList(paramList);

        var returnjsonData = JsonConvert.SerializeObject(list);

        context.Response.ContentType = "text/json";
        context.Response.Write(returnjsonData);
    }

    // 프로모션 NextCode생성
    public void GetPromotionNextCode(HttpContext context)
    {
        var paramList = new Dictionary<string, object> {
        };
        var curCode = PromotionService.GetLastPromotionCode(paramList);
        var nextCode = StringValue.NextPromotionRoleCode(curCode, "Promotion");

        context.Response.ContentType = "text/plain";
        context.Response.Write(nextCode);
    }

    protected void SavePromotion(HttpContext context)
    {
        string svidUser = context.Request.Form["SvidUser"].AsText();
        string promotionCode = context.Request.Form["PromotionCode"].AsText();
        string startDate = context.Request.Form["StartDate"].AsText();
        string endDate = context.Request.Form["EndDate"].AsText();
        string compCode = context.Request.Form["CompCode"].AsText();
        string dcType = context.Request.Form["DcType"].AsText();
        string dayGubun = context.Request.Form["DayGubun"].AsText();
        string etc1 = context.Request.Form["Etc1"].AsText();
        string etc2 = context.Request.Form["Etc2"].AsText();
        string socialCompCode = context.Request.Form["SocialCompCode"].AsText();
        string delFlag = context.Request.Form["DelFlag"].AsText();
        string goodsRole = context.Request.Form["GoodsRole"].AsText();
        string goodsRoleName = context.Request.Form["GoodsRoleName"].AsText();
        string goodsRoleType = context.Request.Form["GoodsRoleType"].AsText();
        string categoryCodes = context.Request.Form["CtgrCodes"].AsText();
        string groupCodes = context.Request.Form["GroupCodes"].AsText();
        string goodsCodes = context.Request.Form["GoodsCodes"].AsText();
        string brandCodes = context.Request.Form["BrandCodes"].AsText();
        string rolePrices = context.Request.Form["Prices"].AsText();
        string type = context.Request.Form["Type"].AsText();
        string format = context.Request.Form["Format"].AsText();

        var paramList = new Dictionary<string, object>() {
             {"nvar_P_SVIDUSER", svidUser}
            ,{"nvar_P_GOODSPROMOTIONDCCODE", promotionCode}
            ,{"nvar_P_STARTDATE", String.Format("{0:yyyy-MM-dd HH:mm:ss}", startDate)}
            ,{"nvar_P_ENDDATE", String.Format("{0:yyyy-MM-dd HH:mm:ss}",  endDate)}
            ,{"nvar_P_PROMOTIONCOMPANYCODE", compCode}
            ,{"nvar_P_PROMOTIONDCTYPE", dcType}
            ,{"nvar_P_DAYGUBUN", dayGubun}
            ,{"nvar_P_ETC1", etc1}
            ,{"nvar_P_ETC2", etc2}
            ,{"nvar_P_SOCIALCOMPANY_CODE", socialCompCode}
            ,{"nvar_P_DELFLAG", delFlag}
            ,{"nvar_P_GOODSROLECODE", goodsRole}
            ,{"nvar_P_GOODSROLECODENAME", goodsRoleName}
            ,{"nvar_P_GOODSROLETYPE", goodsRoleType}
            ,{"nvar_P_GOODSFINALCATEGORYCODES", categoryCodes}
            ,{"nvar_P_GOODSGROUPCODES", groupCodes}
            ,{"nvar_P_GOODSCODES", goodsCodes}
            ,{"nvar_P_BRANDCODES", brandCodes}
            ,{"nvar_P_ROLEPRICES", rolePrices}
            ,{"nvar_P_ROLEPRICETYPE", type}
            ,{"nvar_P_ROLEPRICEFORMAT", format}
         };
        PromotionService.SavePromotion(paramList);

        context.Response.ContentType = "text/plain";
        context.Response.Write("Success");
    }

    protected void MultiSavePromotion(HttpContext context)
    {
        string svidUser = context.Request.Form["SvidUser"].AsText();
        string promotionCode = context.Request.Form["PromotionCode"].AsText();
        string startDate = context.Request.Form["StartDate"].AsText();
        string endDate = context.Request.Form["EndDate"].AsText();
        string compCode = context.Request.Form["CompCode"].AsText();
        string dcType = context.Request.Form["DcType"].AsText();
        string dayGubun = context.Request.Form["DayGubun"].AsText();
        string etc1 = context.Request.Form["Etc1"].AsText();
        string etc2 = context.Request.Form["Etc2"].AsText();
        string socialCompCode = context.Request.Form["SocialCompCode"].AsText();
        string delFlag = context.Request.Form["DelFlag"].AsText();
        string goodsRole = context.Request.Form["GoodsRole"].AsText();
        string goodsRoleName = context.Request.Form["GoodsRoleName"].AsText();
        string goodsRoleType = context.Request.Form["GoodsRoleType"].AsText();
        string categoryCodes = context.Request.Form["CtgrCodes"].AsText();
        string groupCodes = context.Request.Form["GroupCodes"].AsText();
        string goodsCodes = context.Request.Form["GoodsCodes"].AsText();
        string brandCodes = context.Request.Form["BrandCodes"].AsText();
        string type = context.Request.Form["Type"].AsText();
        string format = context.Request.Form["Format"].AsText();

        string unit = context.Request.Form["Unit"].AsText();
        string sign = context.Request.Form["Sign"].AsText();
        decimal rolePrice = context.Request.Form["Price"].AsDecimal();
        var paramList = new Dictionary<string, object>() {
             {"nvar_P_SVIDUSER", svidUser}
            ,{"nvar_P_GOODSPROMOTIONDCCODE", promotionCode}
            ,{"nvar_P_STARTDATE", String.Format("{0:yyyy-MM-dd HH:mm:ss}", startDate)}
            ,{"nvar_P_ENDDATE", String.Format("{0:yyyy-MM-dd HH:mm:ss}",  endDate)}
            ,{"nvar_P_PROMOTIONCOMPANYCODE", compCode}
            ,{"nvar_P_PROMOTIONDCTYPE", dcType}
            ,{"nvar_P_DAYGUBUN", dayGubun}
            ,{"nvar_P_ETC1", etc1}
            ,{"nvar_P_ETC2", etc2}
            ,{"nvar_P_SOCIALCOMPANY_CODE", socialCompCode}
            ,{"nvar_P_DELFLAG", delFlag}
            ,{"nvar_P_GOODSROLECODE", goodsRole}
            ,{"nvar_P_GOODSROLECODENAME", goodsRoleName}
            ,{"nvar_P_GOODSROLETYPE", goodsRoleType}
            ,{"nvar_P_GOODSFINALCATEGORYCODES", categoryCodes}
            ,{"nvar_P_GOODSGROUPCODES", groupCodes}
            ,{"nvar_P_GOODSCODES", goodsCodes}
            ,{"nvar_P_BRANDCODES", brandCodes}
            ,{"nvar_P_ROLEPRICETYPE", type}
            ,{"nvar_P_ROLEPRICEFORMAT", format}
            ,{"nvar_P_UNIT", unit}
            ,{"nvar_P_SIGN", sign}
            ,{"nume_P_ROLEPRICE", rolePrice}
         };
        PromotionService.MultiSavePromotion(paramList);

        context.Response.ContentType = "text/plain";
        context.Response.Write("Success");
    }

    protected void DeletePromotion(HttpContext context)
    {
        string svidUser = context.Request.Form["SvidUser"].AsText();
        string promotionCode = context.Request.Form["PromotionCode"].AsText();


        var paramList = new Dictionary<string, object>() {
             {"nvar_P_SVIDUSER", svidUser}
            ,{"nvar_P_GOODSPROMOTIONDCCODE", promotionCode}
         };
        PromotionService.DeletePromotion(paramList);

        context.Response.ContentType = "text/plain";
        context.Response.Write("Success");
    }

    // 프로모션 등록시 종료일기준 이미 같은구매사, 같은 상품 프로모션이 등록되어있는지 체크하는 프로시져
    public void PromotionDuplCheck(HttpContext context)
    {
        string goodsCodes = context.Request.Form["GoodsCodes"].AsText();
        string endDate = context.Request.Form["EndDate"].AsText();
        string compCode = context.Request.Form["CompCode"].AsText();
        string promotioniCode = context.Request.Form["PromotionCode"].AsText();

        var paramList = new Dictionary<string, object> {
             {"nvar_P_PROMOTIONCODE", promotioniCode}
            ,{"nvar_P_GOODSCODES", goodsCodes}
            ,{"nvar_P_ENDDATE", endDate.Replace("-","")}
            ,{"nvar_P_COMPCODE", compCode}
        };
        var code = PromotionService.PromotionDuplCheck(paramList);

        context.Response.ContentType = "text/plain";
        context.Response.Write(code);
    }
    public bool IsReusable {
        get {
            return false;
        }
    }

}