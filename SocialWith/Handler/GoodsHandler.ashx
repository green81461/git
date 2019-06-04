<%@ WebHandler Language="C#" Class="GoodsHandler" %>

using System;
using System.Web;
using System.Collections.Generic;
using Newtonsoft.Json;
using SocialWith.Biz.Goods;
using SocialWith.Biz.User;
using Urian.Core;
using System.Configuration;
using NLog;
using Oracle.ManagedDataAccess.Client;
public class GoodsHandler : IHttpHandler
{

    #region << logger >>
    private static Logger logger = NLog.LogManager.GetCurrentClassLogger();
    private static readonly bool IsDebugEnabled = logger.IsDebugEnabled;
    private static readonly bool IsInfoEnabled = logger.IsInfoEnabled;
    private static readonly bool IsWarnEnabled = logger.IsWarnEnabled;
    private static readonly bool IsErrorEnabled = logger.IsErrorEnabled;
    private static readonly bool IsFatalEnabled = logger.IsFatalEnabled;
    #endregion

    public void ProcessRequest(HttpContext context)
    {
        string method = context.Request.Form["Method"];
        switch (method)
        {
            case "GetGoodsInfoByGroupCode":
                GetGoodsInfoByGroupCode(context);
                break;
            case "GetGoodsGroupListByCategoryCode":
                GetGoodsGroupListByCategoryCode(context);
                break;
            case "GetGoodsSearchList":
                GetGoodsSearchList(context);
                break;
            case "GetGoodsSummaryList":
                GetGoodsSummaryList(context);
                break;
            case "GetGoodsGroupOption":
                GetGoodsGroupOption(context);
                break;
            case "GetCategoryHint":
                GetCategoryHint(context);
                break;
            case "GetBestRecommendGoods":
                GetBestRecommendGoods(context);
                break;
            case "GetBrandHint":
                GetBrandHint(context);
                break;
            case "GetCategoryCodeByGoodsCode":
                GetCategoryCodeByGoodsCode(context);
                break;
            case "GetGoodsDetailView":
                GetGoodsDetailView(context);
                break;
            case "GetGoodsCompareList":
                GetGoodsCompareList(context);
                break;
            case "GetGoodsCompareSummaryList":
                GetGoodsCompareSummaryList(context);
                break;
            case "GetCompareCodes":
                GetCompareCodeList(context);
                break;
            case "GetCompareSvidSeq":
                GetCompareSvidSeq(context);
                break;
            case "GetGoodsSearchLogSvidSeq":
                GetGoodsSearchLogSvidSeq(context);
                break;
            case "SaveCompare":
                SaveCompareGoods(context);
                break;
            case "SaveGoodsSearchLog":
                SaveGoodsSearchLog(context);
                break;
            case "GetAdminGoodsUpdateInfo":
                GetAdminGoodsUpdateInfo(context);
                break;
            case "GetAdminGoodsGroupCodeList":     //그룹코드리스트 갖고오기
                GetAdminGoodsGroupCodeList(context);
                break;
            case "GetGoodsUnitList":     //단위코드리스트 갖고오기
                GetGoodsUnitList(context);
                break;
            case "GetGoodsOptionCodeList":     //상품 옵션 선택팝업 리스트
                GetGoodsOptionCodeList(context);
                break;
            case "GetGoodsOptionInfo":     //상품 옵션 정보(상품수정용)
                GetGoodsOptionInfo(context);
                break;
            case "DeleteGoodsOption":     //상품 옵션 삭제(상품수정용)
                DeleteGoodsOption(context);
                break;
            case "GetGoodsOriginList":     //원산지 선택팝업 리스트
                GetGoodsOriginList(context);
                break;
            case "GetDeliveryCostCodeList":     //배송비 비용 선택팝업 리스트
                GetDeliveryCostCodeList(context);
                break;
            case "UpdateGoods":              //상품수정
                UpdateGoods(context);
                break;
            case "InsertGoods":              //상품등록
                InsertGoods(context);
                break;
            case "CreateGoodsCode":              //코드생성(상품코드)
                CreateGoodsCode(context);
                break;
            case "CreateServiceGoodsCode":              //코드생성(서비스용역상품코드)
                CreateServiceGoodsCode(context);
                break;
            
            case "CreateGoodsGroupCode":              //코드생성(그룹코드)
                CreateGoodsGroupCode(context);
                break;
            case "CreateGoodsServiceGroupCode":              //코드생성(서비스용역그룹코드)
                CreateGoodsServiceGroupCode(context);
                break;
            case "InsertNewGood":              //신규견적요청
                InsertNewGoodReq(context);
                break;
            case "NewGoodsRequestList":  // 신규상품요청현황
                GetNewGoodsRequestList(context);
                break;
            case "AdminNewGoodsRequestList":  // 신규상품요청현황(관리자)
                GetAdminNewGoodsRequestList(context);
                break;
            case "UpdateNewGoodReq":  // 신규상품요청현황 업데이트(관리자)
                UpdateNewGoodReq(context);
                break;
            case "GetGoodsMDInfo":  // 상품MD정보 갖고오기
                GetGoodsMDInfo(context);
                break;
            case "GetAdminCompPriceList":  //관리자 상품단가 리스트 갖고오기
                GetAdminCompPriceList(context);
                break;
            case "GetAdminCompDisplayList":  //관리자 상품Display 리스트 갖고오기
                GetAdminCompDisplayList(context);
                break;
            case "GetAdminCompPriceList_TypeA":  //관리자 상품단가 리스트 갖고오기
                GetAdminCompPriceList_TypeA(context);
                break;

            case "CompanyGoods_List_TypeA":  //관리자 상품단가 리스트 갖고오기
                CompanyGoods_List_TypeA(context);
                break;
            case "SaveCompPrice":  //단가세팅
                SaveCompPrice(context);
                break;
            case "DeleteCompPrice":  //단가삭제
                DeleteCompPrice(context);
                break;
            case "MultiSaveCompPrice":  //일괄단가세팅
                MultiSaveCompPrice(context);
                break;
            case "SaveBuyCompPrice":  //구매사단가세팅
                SaveBuyCompPrice(context);
                break;
            case "DeleteBuyCompPrice":  //구매사단가삭제
                DeleteBuyCompPrice(context);
                break;
            case "SaveBuyCompDisplay":  //구매사Display세팅
                SaveBuyCompDisplay(context);
                break;
            case "MultiSaveBuyCompPrice":  //구매사일괄단가세팅
                MultiSaveBuyCompPrice(context);
                break;
            case "MultiSaveBuyCompDisplay":  //구매사일괄Display세팅
                MultiSaveBuyCompDisplay(context);
                break;
            case "GetLinkSearchUrl":  //링크검색 url
                GetLinkSearchUrl(context);
                break;
            case "MultiSaveCompDisplay":  //관리자 판매사 디스플레이 관리
                MultiSaveCompDisplay(context);
                break;

            case "SelectSaveCompDisplay":  //관리자 판매사 디스플레이 관리
                SelectSaveCompDisplay(context);
                break;
            case "GoodsAutoCompleteList":  //연관검색어
                GoodsAutoCompleteList(context);
                break;
            case "GoodsRemindSearchList":  //연관검색어
                GoodsRemindSearchList(context);
                break;
            case "GetGoodsSearchLog":  //최근본상품
                GetGoodsSearchLog(context);
                break;
            case "DeleteGoodsSearchLog":  //최근본상품 삭제
                DeleteGoodsSearchLog(context);
                break;
            case "GetGoodsPriceCompareNextSeq":  //상품가격비교 next seq 
                GetGoodsPriceCompareNextSeq(context);
                break;
            case "InsertGoodsPriceCompare":  //상품가격비교 저장
                InsertGoodsPriceCompare(context);
                break;
            case "UpdateGoodsPriceCompare":  //상품가격비교 저장
                UpdateGoodsPriceCompare(context);
                break;
            case "GetPriceCompareNo":  //상품가격비교 존재여부 체크하고 있으면 GroupNo 갖고오기
                GetPriceCompareNo(context);
                break;
            case "GetGoodsPriceCompareList":  //상품가격비교 리스트 갖고오기
                GetGoodsPriceCompareList(context);
                break;
            case "GetGroupCodeListByCategory":  //그룹코드 Rank 리스트 갖고오기 
                GetGroupCodeListByCategory(context);
                break;
            case "UpdateGoodsGroupCodeRank":  //그룹코드 Rank 리스트 업데이트
                UpdateGoodsGroupCodeRank(context);
                break;
            case "GetGoodsCodeListByCategory":  //상품코드 Rank 리스트 갖고오기 
                GetGoodsCodeListByCategory(context);
                break;
            case "UpdateGoodsCodeRank":  //상품코드 Rank 리스트 업데이트 
                UpdateGoodsCodeRank(context);
                break;
            case "GetPopularGoodsList":  //메인화면 인기상품
                GetPopularGoodsList(context);
                break;
            case "GetGoodsSearchList_Admin":  //관리자 상품조회
                GetGoodsSearchList_Admin(context);
                break;
            case "GetGoodsShoppingList":  //메인화면 월 매출리스트 클릭시
                GetGoodsShoppingList(context);
                break;

            

            default:
                break;


        }
    }

    protected void GetGoodsInfoByGroupCode(HttpContext context)
    {
        GoodsService GoodsService = new GoodsService();
        HttpContext.Current.Response.ContentType = "text/json";
        string categoryCode = context.Request.Form["CategoryCode"];
        string groupCode = context.Request.Form["GroupCode"];
        string goodsCode = context.Request.Form["GoodsCode"];
        var paramList = new Dictionary<string, object> {
            {"nvar_P_GOODSFINALCATEGORYCODE", categoryCode},
            {"nvar_P_GOODSGROUPCODE", groupCode},
            {"nvar_P_GOODSCODE", goodsCode},

        };

        var goodsInfo = GoodsService.GetGoodsByGroupCode(paramList);
        var returnjsonData = JsonConvert.SerializeObject(goodsInfo);
        HttpContext.Current.Response.Write(returnjsonData);
    }

    protected void GetGoodsGroupListByCategoryCode(HttpContext context)
    {
        GoodsService GoodsService = new GoodsService();
        string categoryCode = context.Request.Form["CategoryCode"].AsText();
        string brandCode = context.Request.Form["BrandCode"].AsText();
        string brandName = context.Request.Form["BrandName"].AsText();
        string goodsName = context.Request.Form["GoodsName"].AsText();
        string resgoodsName = context.Request.Form["ResGoodsName"].AsText();
        string goodsModel = context.Request.Form["GoodsModel"].AsText();
        string goodsCode = context.Request.Form["GoodsCode"].AsText();
        string orderValue = context.Request.Form["OrderValue"].AsText(); //정렬순서
        string certValue = context.Request.Form["CertValue"].AsText(); //사회적기업제품 검색
        string compCode = context.Request.Form["CompCode"].AsText();
        string saleCompCode = context.Request.Form["SaleCompCode"].AsText();
        string searchFlag = context.Request.Form["SearchFlag"].AsText();
        string dongshinCheck = context.Request.Form["DongshinCheck"].AsText("N");
        string freeYN = context.Request.Form["FreeCompanyYN"].AsText();
        string freeVatYN = context.Request.Form["FreeCompanyVatYN"].AsText("N");
        string svidUser = context.Request.Form["SvidUser"].AsText();
        int pageNo = context.Request.Form["PageNo"].AsInt();
        int pageSize = context.Request.Form["PageSize"].AsInt();

        var paramList = new Dictionary<string, object> {
            {"nvar_P_GOODSFINALCATEGORYCODE", categoryCode},
            {"nvar_P_BRANDCODE", brandCode},
            {"nvar_P_BRANDNAME", brandName},
            {"nvar_P_GOODSFINALNAME", goodsName},
            {"nvar_P_RESGOODSFINALNAME", resgoodsName},
            {"nvar_P_GOODSMODEL", goodsModel},
            {"char_P_GOODSCODE", goodsCode},
            {"nvar_P_ORDERVALUE", orderValue},
            {"nvar_P_CERTVALUE", certValue},
            {"nvar_P_COMPCODE", compCode},
            {"nvar_P_SALECOMPCODE", saleCompCode},
            {"nvar_P_SERACHFLAG", searchFlag},
            {"nvar_P_BDONGSHINCHECK", dongshinCheck},
            {"nvar_P_FREECOMPANYYN", freeYN},
            {"nvar_P_FREECOMPANYVATYN", freeVatYN},
            {"nvar_P_SVID_USER", svidUser},
            {"inte_P_PAGENO", pageNo},
            {"inte_P_PAGESIZE", pageSize},

        };

        var goodsList = GoodsService.GetGoodsGroupListByCategoryCode(paramList);
        var returnjsonData = JsonConvert.SerializeObject(goodsList);
        HttpContext.Current.Response.ContentType = "text/json";
        HttpContext.Current.Response.Write(returnjsonData);
    }

    protected void GetGoodsSearchList(HttpContext context)
    {
        GoodsService GoodsService = new GoodsService();

        string target = context.Request.Form["Target"].AsText();
        string keyword = context.Request.Form["Keyword"].AsText();
        int pageNo = context.Request.Form["PageNo"].AsInt();
        int pageSize = context.Request.Form["PageSize"].AsInt();

        string modelKeyword = context.Request.Form["ModelKeyword"].AsText();

        var paramList = new Dictionary<string, object>() {
              {"nvar_P_GOODSFINALCATEGORYCODE", "" }
            , {"nvar_P_SEARCHTARGET", target }
            , {"nvar_P_MODELKEYWORD", modelKeyword } //모델명 키워드[2019.03.22 추가]
            , {"nvar_P_BRANDKEYWORD", keyword }
            , {"nvar_P_RANGESEARCHFLAG", "N" }
            , {"nvar_P_GOODSCODEB", "" }
            , {"nvar_P_GOODSCODEE", "" }
            , {"nvar_P_DATESEARCHFLAG", "ENTRY" }
            , {"nvar_P_TODATEB", "2001-01-01"}
            , {"nvar_P_TODATEE",  "2099-01-01"}
            , {"inte_P_PAGENO", pageNo }
            , {"inte_P_PAGESIZE", pageSize }
        };

        var list = GoodsService.GetCategoryGoodsList_Admin(paramList);
        var returnjsonData = JsonConvert.SerializeObject(list);
        HttpContext.Current.Response.ContentType = "text/json";
        HttpContext.Current.Response.Write(returnjsonData);
    }

    protected void GetGoodsSummaryList(HttpContext context)
    {
        GoodsService GoodsService = new GoodsService();
        string categoryCode = context.Request.Form["CategoryCode"].AsText();
        string goodsGroupCode = context.Request.Form["GoodsGroupCode"].AsText();
        string goodsCode = context.Request.Form["GoodsCode"].AsText();
        string compCode = context.Request.Form["CompCode"].AsText();
        string dongshinCheck = context.Request.Form["DongshinCheck"].AsText("N");
        string freeYN = context.Request.Form["FreeCompanyYN"].AsText();
        string freeVatYN = context.Request.Form["FreeCompanyVatYN"].AsText("N");
        string svidUser = context.Request.Form["SvidUser"].AsText();
        var paramList = new Dictionary<string, object> {
            {"nvar_P_GOODSFINALCATEGORYCODE", categoryCode},
            {"nvar_P_GOODSGROUPCODE", goodsGroupCode},
            {"nvar_P_GOODSCODE", goodsCode},
            {"nvar_P_COMPCODE", compCode},
            {"nvar_P_BDONGSHINCHECK",  dongshinCheck},
            {"nvar_P_FREECOMPANYYN", freeYN},
            {"nvar_P_FREECOMPANYVATYN", freeVatYN},
            {"nvar_P_SVID_USER", svidUser},

        };

        var sumList = GoodsService.GetGoodsSummaryList(paramList);
        var returnjsonData = JsonConvert.SerializeObject(sumList);
        HttpContext.Current.Response.ContentType = "text/json";
        HttpContext.Current.Response.Write(returnjsonData);
    }

    protected void GetGoodsGroupOption(HttpContext context)
    {
        GoodsService GoodsService = new GoodsService();
        string goodsGroupCode = context.Request.Form["GoodsGroupCode"].AsText();
        string goodsCode = context.Request.Form["GoodsCode"].AsText();

        var paramList = new Dictionary<string, object> {
            {"nvar_P_GOODSGROUPCODE", goodsGroupCode},
            {"nvar_P_GOODSCODE", goodsCode},
        };

        var sumList = GoodsService.GetGoodsGroupOption(paramList);
        var returnjsonData = JsonConvert.SerializeObject(sumList);
        HttpContext.Current.Response.ContentType = "text/json";
        HttpContext.Current.Response.Write(returnjsonData);
    }

    protected void GetCategoryHint(HttpContext context)
    {
        GoodsService GoodsService = new GoodsService();
        string compCode = context.Request.Form["CompCode"].AsText();
        string ctgrCode = context.Request.Form["CtgrCode"].AsText();
        string saleCompCode = context.Request.Form["SaleCompCode"].AsText();
        string dongshinCheck = context.Request.Form["DongshinCheck"].AsText("N");
        string freeYN = context.Request.Form["FreeCompanyYN"].AsText();
        string freeVatYN = context.Request.Form["FreeCompanyVatYN"].AsText("N");
        string svidUser = context.Request.Form["SvidUser"].AsText();
        var paramList = new Dictionary<string, object>
        {
             {"nvar_P_COMPCODE", compCode},
             {"nvar_P_GOODSFINALCATEGORYCODE", ctgrCode},
             {"nvar_P_SALECOMPCODE", saleCompCode},
             {"nvar_P_BDONGSHINCHECK",  dongshinCheck},
             {"nvar_P_FREECOMPANYYN", freeYN},
             {"nvar_P_FREECOMPANYVATYN", freeVatYN},
             {"nvar_P_SVID_USER", svidUser},
        };

        var sumList = GoodsService.GetGoodsCategoryHintList(paramList);
        var returnjsonData = JsonConvert.SerializeObject(sumList);
        HttpContext.Current.Response.ContentType = "text/json";
        HttpContext.Current.Response.Write(returnjsonData);
    }


    protected void GetBestRecommendGoods(HttpContext context)
    {
        GoodsService GoodsService = new GoodsService();
        string compCode = context.Request.Form["CompCode"].AsText();
        string saleCompCode = context.Request.Form["SaleCompCode"].AsText();
        string dongshinCheck = context.Request.Form["DongshinCheck"].AsText("N");
        string freeYN = context.Request.Form["FreeCompanyYN"].AsText();
        string freeVatYN = context.Request.Form["FreeCompanyVatYN"].AsText("N");
        string svidUser = context.Request.Form["SvidUser"].AsText();
        var paramList = new Dictionary<string, object>
        {
             {"nvar_P_COMPCODE", compCode},
             {"nvar_P_SALECOMPCODE", saleCompCode},
             {"nvar_P_BDONGSHINCHECK",  dongshinCheck},
             {"nvar_P_FREECOMPANYYN", freeYN},
             {"nvar_P_FREECOMPANYVATYN", freeVatYN},
             {"nvar_P_SVID_USER", svidUser},
        };

        var sumList = GoodsService.GetBestRecommendGoods(paramList);
        var returnjsonData = JsonConvert.SerializeObject(sumList);
        HttpContext.Current.Response.ContentType = "text/json";
        HttpContext.Current.Response.Write(returnjsonData);
    }


    //해당 브랜드 내 인기상품
    protected void GetBrandHint(HttpContext context)
    {
        GoodsService GoodsService = new GoodsService();
        string brandCode = context.Request.Form["BrandCode"];
        string compCode = context.Request.Form["CompCode"].AsText();
        string saleCompCode = context.Request.Form["SaleCompCode"].AsText();
        string dongshinCheck = context.Request.Form["DongshinCheck"].AsText("N");
        string freeYN = context.Request.Form["FreeCompanyYN"].AsText();
        string freeVatYN = context.Request.Form["FreeCompanyVatYN"].AsText("N");
        string svidUser = context.Request.Form["SvidUser"].AsText();
        var paramList = new Dictionary<string, object> {
            {"nvar_P_BRANDCODE", brandCode},
            {"nvar_P_COMPCODE", compCode},
            {"nvar_P_SALECOMPCODE", saleCompCode},
            {"nvar_P_BDONGSHINCHECK",  dongshinCheck},
            {"nvar_P_FREECOMPANYYN", freeYN},
            {"nvar_P_FREECOMPANYVATYN", freeVatYN},
            {"nvar_P_SVID_USER", svidUser},
        };

        var sumList = GoodsService.GetGoodsBrandHintList(paramList);
        var returnjsonData = JsonConvert.SerializeObject(sumList);
        HttpContext.Current.Response.ContentType = "text/json";
        HttpContext.Current.Response.Write(returnjsonData);
    }



    //상세검색 상품코드로 검색시 카테고리코드 갖고오기
    protected void GetCategoryCodeByGoodsCode(HttpContext context)
    {
        GoodsService GoodsService = new GoodsService();
        string goodsCode = context.Request.Form["GoodsCode"];
        var paramList = new Dictionary<string, object> {
            {"nvar_P_GOODSCODE", goodsCode}
        };


        var sumList = GoodsService.GetCategoryCodeByGoodsCode(paramList);
        var returnjsonData = JsonConvert.SerializeObject(sumList);
        HttpContext.Current.Response.ContentType = "text/json";
        HttpContext.Current.Response.Write(returnjsonData);
    }

    //상품코드 상품 디테일 뷰
    protected void GetGoodsDetailView(HttpContext context)
    {
        GoodsService GoodsService = new GoodsService();
        string goodsCode = context.Request.Form["GoodsCode"];
        string compCode = context.Request.Form["CompCode"].AsText();
        string saleCompCode = context.Request.Form["SaleCompCode"].AsText();
        string dongshinCheck = context.Request.Form["DongshinCheck"].AsText("N");
        string freeYN = context.Request.Form["FreeCompanyYN"].AsText();
        string freeVatYN = context.Request.Form["FreeCompanyVatYN"].AsText("N");
        string svidUser = context.Request.Form["SvidUser"].AsText();
        var paramList = new Dictionary<string, object> {
            {"nvar_P_GOODSCODE", goodsCode},
            {"nvar_P_COMPCODE", compCode},
            {"nvar_P_SALECOMPCODE", saleCompCode},
            {"nvar_P_BDONGSHINCHECK",  dongshinCheck},
            {"nvar_P_FREECOMPANYYN", freeYN},
            {"nvar_P_FREECOMPANYVATYN", freeVatYN},
            {"nvar_P_SVID_USER", svidUser},
        };


        var goods = GoodsService.GetGoodsDetailView(paramList);
        var returnjsonData = JsonConvert.SerializeObject(goods);
        HttpContext.Current.Response.ContentType = "text/json";
        HttpContext.Current.Response.Write(returnjsonData);
    }

    protected void GetGoodsCompareList(HttpContext context)
    {
        GoodsService GoodsService = new GoodsService();
        string svidUser = context.Request.Form["SvidUser"].AsText();
        string goodsCodes = context.Request.Form["GoodsCodes"].AsText();
        string compCode = context.Request.Form["CompCode"].AsText();
        string saleCompCode = context.Request.Form["SaleCompCode"].AsText();
        string dongshinCheck = context.Request.Form["DongshinCheck"].AsText("N");
        string freeYN = context.Request.Form["FreeCompanyYN"].AsText();
        string freeVatYN = context.Request.Form["FreeCompanyVatYN"].AsText("N");
        var paramList = new Dictionary<string, object> {

            {"nvar_P_SVIDUSER", svidUser},
            {"nvar_P_GOODSCODES", goodsCodes},
            {"nvar_P_COMPCODE", compCode},
            {"nvar_P_SALECOMPCODE", saleCompCode},
            {"nvar_P_BDONGSHINCHECK",  dongshinCheck},
            {"nvar_P_FREECOMPANYYN", freeYN},
            {"nvar_P_FREECOMPANYVATYN", freeVatYN},
        };

        var goodsList = GoodsService.GetGoodsCompareList(paramList);
        var returnjsonData = JsonConvert.SerializeObject(goodsList);
        HttpContext.Current.Response.ContentType = "text/json";
        HttpContext.Current.Response.Write(returnjsonData);
    }

    protected void GetGoodsCompareSummaryList(HttpContext context)
    {
        GoodsService GoodsService = new GoodsService();
        string goodsCodes = context.Request.Form["GoodsCodes"].AsText();


        var paramList = new Dictionary<string, object> {
            {"nvar_P_GOODSCODES", goodsCodes},

        };

        var sumList = GoodsService.GetGoodsCompareSummaryList(paramList);
        var returnjsonData = JsonConvert.SerializeObject(sumList);
        HttpContext.Current.Response.ContentType = "text/json";
        HttpContext.Current.Response.Write(returnjsonData);
    }

    //[상품비교]비교에 담은 상품 코드들 조회
    protected void GetCompareCodeList(HttpContext context)
    {
        string goodsCodes = context.Request.Form["GoodsCodes"].AsText();
        string compCode = context.Request.Form["CompCode"].AsText();
        string saleCompCode = context.Request.Form["SaleCompCode"].AsText();
        string dongshinCheck = context.Request.Form["DongshinCheck"].AsText("N");
        string freeYN = context.Request.Form["FreeCompanyYN"].AsText();
        string freeVatYN = context.Request.Form["FreeCompanyVatYN"].AsText("N");
        string svidUser = context.Request.Form["SvidUser"].AsText();
        var paramList = new Dictionary<string, object> {
            {"nvar_P_GOODSCODES", goodsCodes},
            {"nvar_P_COMPCODE", compCode},
            {"nvar_P_SALECOMPCODE", saleCompCode},
            {"nvar_P_BDONGSHINCHECK",  dongshinCheck},
            {"nvar_P_FREECOMPANYYN", freeYN},
            {"nvar_P_FREECOMPANYVATYN", freeVatYN},
            {"nvar_P_SVID_USER", svidUser},
        };

        GoodsService GoodsService = new GoodsService();
        var list = GoodsService.GetGoodsCompareCodesList(paramList);

        var returnjsonData = JsonConvert.SerializeObject(list);
        HttpContext.Current.Response.ContentType = "text/json";
        HttpContext.Current.Response.Write(returnjsonData);
    }

    //[상품비교]비회원 임시 SvidUser 용 시퀀스 조회
    protected void GetCompareSvidSeq(HttpContext context)
    {
        GoodsService GoodsService = new GoodsService();
        string query = "select GOODSCOMPARESVID_SEQ.NEXTVAL from dual";
        var svidSeq = GoodsService.GetCompareSvidUserSeq(query);

        string returnData = string.Empty;

        string nowDate = DateTime.Now.ToString("yyMMdd");
        returnData = nowDate + "T" + svidSeq.ToString("0000000");

        HttpContext.Current.Response.ContentType = "text/plain";
        HttpContext.Current.Response.Write(returnData);
    }

    //[최근본상품]비회원 임시 SvidUser 용 시퀀스 조회
    protected void GetGoodsSearchLogSvidSeq(HttpContext context)
    {
        GoodsService GoodsService = new GoodsService();
        string query = "select GOODSSEARCHLOG_SEQ.NEXTVAL from dual";
        var svidSeq = GoodsService.GetGoodsSearchLogSvidUserSeq(query);

        string returnData = string.Empty;

        string nowDate = DateTime.Now.ToString("yyMMdd");
        returnData = nowDate + "S" + svidSeq.ToString("0000000");

        HttpContext.Current.Response.ContentType = "text/plain";
        HttpContext.Current.Response.Write(returnData);
    }

    //[상품비교]비교상품 저장
    protected void SaveCompareGoods(HttpContext context)
    {
        string svidUser = context.Request.Form["SvidUser"].AsText();
        string gdsFinCodeArr = context.Request.Form["GoodsFinCodes"].AsText();
        string gdsGrpCodeArr = context.Request.Form["GoodsGrpCodes"].AsText();
        string gdsCodeArr = context.Request.Form["GoodsCodes"].AsText();

        var paramList = new Dictionary<string, object> {
            {"nvar_P_CATEGORYCODES", gdsFinCodeArr},
            {"nvar_P_GROUPCODES", gdsGrpCodeArr},
            {"nvar_P_GOODSCODES", gdsCodeArr},
            {"nvar_P_SVID_USER", svidUser}
        };

        GoodsService GoodsService = new GoodsService();
        GoodsService.SaveCompareGoods(paramList);

        HttpContext.Current.Response.ContentType = "text/plain";
        HttpContext.Current.Response.Write("OK");
    }

    //[최근본상품]최근본상품 저장
    protected void SaveGoodsSearchLog(HttpContext context)
    {
        string svidUser = context.Request.Form["SvidUser"].AsText();
        string gubun = context.Request.Form["Gubun"].AsText();
        string gdsFinCodeArr = context.Request.Form["GoodsFinCodes"].AsText();
        string gdsGrpCodeArr = context.Request.Form["GoodsGrpCodes"].AsText();
        string gdsCodeArr = context.Request.Form["GoodsCodes"].AsText();

        var paramList = new Dictionary<string, object> {
            {"nvar_P_CATEGORYCODE", gdsFinCodeArr},
            {"nvar_P_GROUPCODE", gdsGrpCodeArr},
            {"nvar_P_GOODSCODE", gdsCodeArr},
            {"nvar_P_GUBUN", gubun},
            {"nvar_P_SVID_USER", svidUser}
        };

        GoodsService GoodsService = new GoodsService();
        GoodsService.SaveGoodsSearchLog(paramList);

        HttpContext.Current.Response.ContentType = "text/plain";
        HttpContext.Current.Response.Write("OK");
    }

    //관리자 상품수정 정보 바인딩용
    protected void GetAdminGoodsUpdateInfo(HttpContext context)
    {
        GoodsService GoodsService = new GoodsService();
        HttpContext.Current.Response.ContentType = "text/json";

        string goodsCode = context.Request.Form["GoodsCode"];
        var paramList = new Dictionary<string, object> {
            {"nvar_P_GOODSCODE", goodsCode},

        };

        var goodsInfo = GoodsService.GetAdminGoodsUpdateInfo(paramList);
        var returnjsonData = JsonConvert.SerializeObject(goodsInfo);
        HttpContext.Current.Response.Write(returnjsonData);
    }

    //관리자 상품수정 그룹코드 리스트 바인딩 용
    protected void GetAdminGoodsGroupCodeList(HttpContext context)
    {
        GoodsService GoodsService = new GoodsService();
        HttpContext.Current.Response.ContentType = "text/json";

        string target = context.Request.Form["Target"];
        string keyword = context.Request.Form["Keyword"];
        int pageNo = context.Request.Form["PageNo"].AsInt();
        int pageSize = context.Request.Form["PageSize"].AsInt();
        var paramList = new Dictionary<string, object> {
            {"nvar_P_SEARCHTARGET", target},
            {"nvar_P_SEARCHKEYWORD", keyword},
            {"inte_P_PAGENO", pageNo},
            {"inte_P_PAGESIZE", pageSize},

        };

        var goodsInfo = GoodsService.GetGoodsGroupCodeList(paramList);
        var returnjsonData = JsonConvert.SerializeObject(goodsInfo);
        HttpContext.Current.Response.Write(returnjsonData);
    }

    //관리자 상품수정 단위코드 리스트 바인딩 용
    protected void GetGoodsUnitList(HttpContext context)
    {
        GoodsService GoodsService = new GoodsService();
        HttpContext.Current.Response.ContentType = "text/json";

        var paramList = new Dictionary<string, object>
        {
        };

        var goodsInfo = GoodsService.GetGoodsUnitList(paramList);
        var returnjsonData = JsonConvert.SerializeObject(goodsInfo);
        HttpContext.Current.Response.Write(returnjsonData);
    }

    //상품 옵션 선택팝업 리스트(상품수정용)
    protected void GetGoodsOptionCodeList(HttpContext context)
    {
        GoodsService GoodsService = new GoodsService();
        HttpContext.Current.Response.ContentType = "text/json";

        string target = context.Request.Form["Target"];
        string keyword = context.Request.Form["Keyword"];
        int pageNo = context.Request.Form["PageNo"].AsInt();
        int pageSize = context.Request.Form["PageSize"].AsInt();

        var paramList = new Dictionary<string, object> {

            {"nvar_P_SEARCHTARGET", target},
            {"nvar_P_SEARCHKEYWORD", keyword},
            {"inte_P_PAGENO", pageNo},
            {"inte_P_PAGESIZE", pageSize},
        };

        var goodsInfo = GoodsService.GetGoodsOptionCodeList(paramList);
        var returnjsonData = JsonConvert.SerializeObject(goodsInfo);
        HttpContext.Current.Response.Write(returnjsonData);
    }

    //상품 옵션 정보(상품수정용)
    protected void GetGoodsOptionInfo(HttpContext context)
    {
        GoodsService GoodsService = new GoodsService();
        HttpContext.Current.Response.ContentType = "text/json";

        string code = context.Request.Form["GoodsCode"];
        var paramList = new Dictionary<string, object> {

            {"nvar_P_GOODSCODE", code},
        };

        var goodsInfo = GoodsService.GetGoodsOptionInfo(paramList);
        var returnjsonData = JsonConvert.SerializeObject(goodsInfo);
        HttpContext.Current.Response.Write(returnjsonData);
    }

    //원산지 선택팝업 리스트(상품수정용)
    protected void GetGoodsOriginList(HttpContext context)
    {
        GoodsService GoodsService = new GoodsService();
        HttpContext.Current.Response.ContentType = "text/json";

        string keyword = context.Request.Form["Keyword"];
        int pageNo = context.Request.Form["PageNo"].AsInt();
        int pageSize = context.Request.Form["PageSize"].AsInt();

        var paramList = new Dictionary<string, object> {

            {"nvar_P_SEARCHKEYWORD", keyword},
            {"inte_P_PAGENO", pageNo},
            {"inte_P_PAGESIZE", pageSize},
        };

        var goodsInfo = GoodsService.GetGoodsOriginList(paramList);
        var returnjsonData = JsonConvert.SerializeObject(goodsInfo);
        HttpContext.Current.Response.Write(returnjsonData);
    }

    //배송비 비용 선택팝업 리스트(상품수정용)
    protected void GetDeliveryCostCodeList(HttpContext context)
    {
        GoodsService GoodsService = new GoodsService();
        HttpContext.Current.Response.ContentType = "text/json";
        string gubun = context.Request.Form["Gubun"];

        var paramList = new Dictionary<string, object> {

            {"char_P_GUBUN", gubun},

        };

        var goodsInfo = GoodsService.GetDeliveryCostCodeList(paramList);
        var returnjsonData = JsonConvert.SerializeObject(goodsInfo);
        HttpContext.Current.Response.Write(returnjsonData);
    }

    //상품 옵션 삭제(상품수정용)
    protected void DeleteGoodsOption(HttpContext context)
    {
        string goodsCode = context.Request.Form["GoodsCode"];
        string cationCode = context.Request.Form["CationCode"];
        string levelCode = context.Request.Form["LevelCode"];

        var paramList = new Dictionary<string, object> {
            {"nvar_P_GOODSCODE", goodsCode},
            {"nvar_P_GOODSOPTIONCATIONCODE", cationCode},
            {"nvar_P_GOODSOPTIONLEVELCODE", levelCode},
        };

        GoodsService GoodsService = new GoodsService();
        GoodsService.DeleteGoodsOption(paramList);

        HttpContext.Current.Response.ContentType = "text/plain";
        HttpContext.Current.Response.Write("OK");
    }

    //상품수정
    protected void UpdateGoods(HttpContext context)
    {
        string goodsCode = context.Request.Form["GoodsCode"].AsText();
        string categoryCode = context.Request.Form["CategoryCode"].AsText();
        string categoryName = context.Request.Form["CategoryName"].AsText();
        string groupCode = context.Request.Form["GroupCode"].AsText();
        string goodsName = context.Request.Form["GoodsName"].AsText();
        string sumCode = context.Request.Form["SummaryCode"].AsText();
        string brandCode = context.Request.Form["BrandCode"].AsText();
        string model = context.Request.Form["Model"].AsText();
        string unit = context.Request.Form["Unit"].AsText();
        string subUnit = context.Request.Form["SubUnit"].AsText();
        int unitMoq = context.Request.Form["UnitMoq"].AsInt(1);
        int unitQty = context.Request.Form["UnitQty"].AsInt();
        int? subQty = context.Request.Form["UnitSubQty"].AsIntNullable();
        string deliveryOrderDue = context.Request.Form["DeliveryOrderDue"].AsText();
        decimal buyPrice = context.Request.Form["BuyPrice"].AsDecimal();
        decimal buyPriceVat = context.Request.Form["BuyPriceVat"].AsDecimal();
        decimal salePrice = context.Request.Form["SalePrice"].AsDecimal();
        decimal salePriceVat = context.Request.Form["SalePriceVat"].AsDecimal();
        decimal msalePrice = context.Request.Form["MSalePrice"].AsDecimal();
        decimal msalePriceVat = context.Request.Form["MSalePriceVat"].AsDecimal();
        decimal custPrice = context.Request.Form["CustPrice"].AsDecimal();
        decimal custPriceVat = context.Request.Form["CustPriceVat"].AsDecimal();
        string goodsSpecial = context.Request.Form["GoodsSpecial"].AsText();
        string goodsFormat = context.Request.Form["GoodsFormat"].AsText();
        string cause = context.Request.Form["GoodsCause"].AsText();
        string supplies = context.Request.Form["GoodsSupplies"].AsText();
        string remindSearh = context.Request.Form["RemindSearch"].AsText();
        string mdId = context.Request.Form["MdId"].AsText();
        string mdMemo = context.Request.Form["Mdmemo"].AsText();
        int dispFlag = context.Request.Form["DisplayFlag"].AsInt();
        int noDispReason = context.Request.Form["NodisplayReason"].AsInt();
        int noSaleReason = context.Request.Form["NosaleReason"].AsInt();
        string noSaleEntDue = context.Request.Form["NosaleEnterdue"].AsText();
        int returnChangeFlag = context.Request.Form["ReturnChangeFlag"].AsInt();
        int keepYn = context.Request.Form["KeepYn"].AsInt();
        string saleTaxYn = context.Request.Form["SaleTaxYn"].AsText();
        string dcYn = context.Request.Form["DcYn"].AsText();
        int custGubun = context.Request.Form["CustGubun"].AsInt();
        string custGubunCode = context.Request.Form["CustGubunCode"].AsText();
        string barcode = context.Request.Form["Barcode"].AsText();
        string barcode2 = context.Request.Form["Barcode2"].AsText();
        string barcode3 = context.Request.Form["Barcode3"].AsText();
        string sCompCode1 = context.Request.Form["SCompCode1"].AsText();
        string sCompCode2 = context.Request.Form["SCompCode2"].AsText();
        string sCompCode3 = context.Request.Form["SCompCode3"].AsText();
        string sGoodsCode1 = context.Request.Form["SGoodsCode1"].AsText();
        string sGoodsCode2 = context.Request.Form["SGoodsCode2"].AsText();
        string sGoodsCode3 = context.Request.Form["SGoodsCode3"].AsText();
        string sGoodsUnit = context.Request.Form["SGoodsUnit"].AsText();
        int? sGoodsUnitMoq = context.Request.Form["SGoodsUnitMoq"].AsIntNullable();
        int? sGoodsUnitMoq2 = context.Request.Form["SGoodsUnitMoq2"].AsIntNullable();
        int? sGoodsUnitMoq3 = context.Request.Form["SGoodsUnitMoq3"].AsIntNullable();
        int sGoodsEntDue = context.Request.Form["SGoodsEnterDue"].AsInt();
        int sGoodsEntDue2 = context.Request.Form["SGoodsEnterDue2"].AsInt();
        int sGoodsEntDue3 = context.Request.Form["SGoodsEnterDue3"].AsInt();
        int sBuyCalc = context.Request.Form["SBuyCalc"].AsInt();
        int sBuyCalc2 = context.Request.Form["SBuyCalc2"].AsInt();
        int sBuyCalc3 = context.Request.Form["SBuyCalc3"].AsInt();
        int sOrderForm = context.Request.Form["SOrderForm"].AsInt();
        int sOrderForm2 = context.Request.Form["SOrderForm2"].AsInt();
        int sOrderForm3 = context.Request.Form["SOrderForm3"].AsInt();
        int sGoodsType = context.Request.Form["SGoodsType"].AsInt();
        string sDistrA = context.Request.Form["SDistrA"].AsText();
        int? sDistrDue = context.Request.Form["SDistrDue"].AsIntNullable();
        int? sDistrDue2 = context.Request.Form["SDistrDue2"].AsIntNullable();
        int? sDistrDue3 = context.Request.Form["SDistrDue3"].AsIntNullable();
        string originCode = context.Request.Form["OriginCode"].AsText();
        int deliGubun = context.Request.Form["DeliveryGubun"].AsInt();
        int deliCGubun = context.Request.Form["DeliveryCGubun"].AsInt();
        string deliCCode = context.Request.Form["DeliveryCCode"].AsText();
        string summaryValues = context.Request.Form["SummaryValues"].AsText();
        string optionCode1 = context.Request.Form["OptionCode1"].AsText();
        string optionVal1 = context.Request.Form["OptionValue1"].AsText();
        string optionCode2 = context.Request.Form["OptionCode2"].AsText();
        string optionVal2 = context.Request.Form["OptionValue2"].AsText();
        string optionCode3 = context.Request.Form["OptionCode3"].AsText();
        string optionVal3 = context.Request.Form["OptionValue3"].AsText();
        string optionCode4 = context.Request.Form["OptionCode4"].AsText();
        string optionVal4 = context.Request.Form["OptionValue4"].AsText();
        string optionCode5 = context.Request.Form["OptionCode5"].AsText();
        string optionVal5 = context.Request.Form["OptionValue5"].AsText();
        string optionCode6 = context.Request.Form["OptionCode6"].AsText();
        string optionVal6 = context.Request.Form["OptionValue6"].AsText();
        string optionCode7 = context.Request.Form["OptionCode7"].AsText();
        string optionVal7 = context.Request.Form["OptionValue7"].AsText();
        string optionCode8 = context.Request.Form["OptionCode8"].AsText();
        string optionVal8 = context.Request.Form["OptionValue8"].AsText();
        string optionCode9 = context.Request.Form["OptionCode9"].AsText();
        string optionVal9 = context.Request.Form["OptionValue9"].AsText();
        string optionCode10 = context.Request.Form["OptionCode10"].AsText();
        string optionVal10 = context.Request.Form["OptionValue10"].AsText();
        string optionCode11 = context.Request.Form["OptionCode11"].AsText();
        string optionVal11 = context.Request.Form["OptionValue11"].AsText();
        string optionCode12 = context.Request.Form["OptionCode12"].AsText();
        string optionVal12 = context.Request.Form["OptionValue12"].AsText();
        string optionCode13 = context.Request.Form["OptionCode13"].AsText();
        string optionVal13 = context.Request.Form["OptionValue13"].AsText();
        string optionCode14 = context.Request.Form["OptionCode14"].AsText();
        string optionVal14 = context.Request.Form["OptionValue14"].AsText();
        string optionCode15 = context.Request.Form["OptionCode15"].AsText();
        string optionVal15 = context.Request.Form["OptionValue15"].AsText();
        string optionCode16 = context.Request.Form["OptionCode16"].AsText();
        string optionVal16 = context.Request.Form["OptionValue16"].AsText();
        string optionCode17 = context.Request.Form["OptionCode17"].AsText();
        string optionVal17 = context.Request.Form["OptionValue17"].AsText();
        string optionCode18 = context.Request.Form["OptionCode18"].AsText();
        string optionVal18 = context.Request.Form["OptionValue18"].AsText();
        string optionCode19 = context.Request.Form["OptionCode19"].AsText();
        string optionVal19 = context.Request.Form["OptionValue19"].AsText();
        string optionCode20 = context.Request.Form["OptionCode20"].AsText();
        string optionVal20 = context.Request.Form["OptionValue20"].AsText();
        string cBarcode1 = context.Request.Form["cBarcode1"].AsText();
        string cBarcode2 = context.Request.Form["cBarcode2"].AsText();
        string cBarcode3 = context.Request.Form["cBarcode3"].AsText();

        string gdsConfirmMark = context.Request.Form["GdsConfirmMark"].AsText(); //상품인증구분
        int supplyTransCostYN = context.Request.Form["SupplyTransCostYN"].AsInt(); //공급사1 매입운송유무
        decimal? supplyTransCostVat = context.Request.Form["SupplyTransCostVat"].AsDecimalNullable(); //공급사1 매입운송비용
        int supplyTransCostYN2 = context.Request.Form["SupplyTransCostYN2"].AsInt(); //공급사2 매입운송유무
        decimal? supplyTransCostVat2 = context.Request.Form["SupplyTransCostVat2"].AsDecimalNullable(); //공급사2 매입운송비용
        int supplyTransCostYN3 = context.Request.Form["SupplyTransCostYN3"].AsInt(); //공급사3 매입운송유무
        decimal? supplyTransCostVat3 = context.Request.Form["SupplyTransCostVat3"].AsDecimalNullable(); //공급사3 매입운송비용

        var paramList = new Dictionary<string, object> {
            {"nvar_P_GOODSCODE", goodsCode},
            {"nvar_P_GOODSFINALCATEGORYCODE", categoryCode},
            {"nvar_P_GOODSFINALCATEGORYNAME", categoryName},
            {"nvar_P_GOODSGROUPCODE", groupCode},
            {"nvar_P_GOODSFINALNAME", goodsName},
            {"nvar_P_GOODSOPTIONSUMMARYCODE", sumCode},
            {"nvar_P_BRANDCODE", brandCode},
            {"nvar_P_GOODSMODEL", model},
            {"nvar_P_GOODSUNIT", unit},
            {"nvar_P_GOODSSUBUNIT", subUnit},
            {"nume_P_GOODSUNITMOQ", unitMoq},
            {"nume_P_GOODSUNITQTY", unitQty},
            {"nvar_P_GOODSUNITSUBQTY", subQty},
            {"nvar_P_GOODSDELIVERYORDERDUE", deliveryOrderDue},
            {"nume_P_GOODSBUYPRICE", buyPrice},
            {"nume_P_GOODSBUYPRICEVAT", buyPriceVat},
            {"nume_P_GOODSSALEPRICE", salePrice},
            {"nume_P_GOODSSALEPRICEVAT", salePriceVat},
            {"nume_P_GOODSMSALEPRICE", msalePrice},
            {"nume_P_GOODSMSALEPRICEVAT", msalePriceVat},
            {"nume_P_GOODSCUSTPRICE", custPrice},
            {"nume_P_GOODSCUSTPRICEVAT", custPriceVat},
            {"nvar_P_GOODSSPECIAL", goodsSpecial},
            {"nvar_P_GOODSFORMAT", goodsFormat},
            {"nvar_P_GOODSCAUSE", cause},
            {"nvar_P_GOODSSUPPLIES", supplies},
            {"nvar_P_GOODSREMINDSEARCH", remindSearh},
            {"nvar_P_MDTOID", mdId},
            {"nvar_P_MDMEMO", mdMemo},
            {"nume_P_GOODSDISPLAYFLAG", dispFlag},
            {"nume_P_GOODSNODISPLYREASON", noDispReason},
            {"nume_P_GOODSNOSALEREASON", noSaleReason},
            {"nvar_P_GOODSNOSALEENTERTARGETDUE",String.Format("{0:yyyy-MM-dd HH:mm:ss}",  noSaleEntDue) },
            {"nume_P_GOODSRETURNCHANGEFLAG", returnChangeFlag},
            {"nume_P_GOODSKEEPYN", keepYn},
            {"nvar_P_GOODSSALETAXYN", saleTaxYn},
            {"nvar_P_GOODSDCYN", dcYn},
            {"nume_P_GOODSCUSTGUBUN", custGubun},
            {"nvar_P_GOODSSALECUSTGUBUNCODE", custGubunCode},
            {"nvar_P_GOODSSUPPLYBARCODE", barcode},
            {"nvar_P_GOODSSUPPLYBARCODE2", barcode2},
            {"nvar_P_GOODSSUPPLYBARCODE3", barcode3},
            {"nvar_P_SUPPLYCOMPANYCODE1", sCompCode1},
            {"nvar_P_SUPPLYCOMPANYCODE2", sCompCode2},
            {"nvar_P_SUPPLYCOMPANYCODE3", sCompCode3},
            {"nvar_P_SUPPLYGOODSCODE1", sGoodsCode1},
            {"nvar_P_SUPPLYGOODSCODE2", sGoodsCode2},
            {"nvar_P_SUPPLYGOODSCODE3", sGoodsCode3},
            {"nvar_P_SUPPLYGOODSUNIT", sGoodsUnit},
            {"nvar_P_SUPPLYGOODSUNITMOQ", sGoodsUnitMoq},
            {"nvar_P_SUPPLYGOODSUNITMOQ2", sGoodsUnitMoq2},
            {"nvar_P_SUPPLYGOODSUNITMOQ3", sGoodsUnitMoq3},
            {"nume_P_SUPPLYGOODSENTERDUE", sGoodsEntDue},
            {"nume_P_SUPPLYGOODSENTERDUE2", sGoodsEntDue2},
            {"nume_P_SUPPLYGOODSENTERDUE3", sGoodsEntDue3},
            {"nume_P_SUPPLYBUYCALC", sBuyCalc},
            {"nume_P_SUPPLYBUYCALC2", sBuyCalc2},
            {"nume_P_SUPPLYBUYCALC3", sBuyCalc3},
            {"nume_P_SUPPLYORDERFORM", sOrderForm},
            {"nume_P_SUPPLYORDERFORM2", sOrderForm2},
            {"nume_P_SUPPLYORDERFORM3", sOrderForm3},
            {"nume_P_SUPPLYBUYGOODSTYPE", sGoodsType},
            {"nvar_P_SUPPLYGOODSDISTRADMIN", sDistrA},
            {"nvar_P_SUPPLYGOODSDISTRDUE", sDistrDue},
            {"nvar_P_SUPPLYGOODSDISTRDUE2", sDistrDue2},
            {"nvar_P_SUPPLYGOODSDISTRDUE3", sDistrDue3},
            {"nvar_P_GOODSORIGINCODE", originCode},
            {"nume_P_DELIVERYGUBUN", deliGubun},
            {"nume_P_DELIVERYCOSTGUBUN", deliCGubun},
            {"nvar_P_DELIVERYCOST_CODE", deliCCode},
            {"nvar_P_GOODSOPTIONSUMMARYVALUES", summaryValues},
            {"nvar_P_GOODSOPTIONCATIONCODE1", optionCode1},
            {"nvar_P_GOODSOPTIONVALUES1", optionVal1},
            {"nvar_P_GOODSOPTIONCATIONCODE2", optionCode2},
            {"nvar_P_GOODSOPTIONVALUES2", optionVal2},
            {"nvar_P_GOODSOPTIONCATIONCODE3", optionCode3},
            {"nvar_P_GOODSOPTIONVALUES3", optionVal3},
            {"nvar_P_GOODSOPTIONCATIONCODE4", optionCode4},
            {"nvar_P_GOODSOPTIONVALUES4", optionVal4},
            {"nvar_P_GOODSOPTIONCATIONCODE5", optionCode5},
            {"nvar_P_GOODSOPTIONVALUES5", optionVal5},
            {"nvar_P_GOODSOPTIONCATIONCODE6", optionCode6},
            {"nvar_P_GOODSOPTIONVALUES6", optionVal6},
            {"nvar_P_GOODSOPTIONCATIONCODE7", optionCode7},
            {"nvar_P_GOODSOPTIONVALUES7", optionVal7},
            {"nvar_P_GOODSOPTIONCATIONCODE8", optionCode8},
            {"nvar_P_GOODSOPTIONVALUES8", optionVal8},
            {"nvar_P_GOODSOPTIONCATIONCODE9", optionCode9},
            {"nvar_P_GOODSOPTIONVALUES9", optionVal9},
            {"nvar_P_GOODSOPTIONCATIONCODE10", optionCode10},
            {"nvar_P_GOODSOPTIONVALUES10", optionVal10},
            {"nvar_P_GOODSOPTIONCATIONCODE11", optionCode11},
            {"nvar_P_GOODSOPTIONVALUES11", optionVal11},
            {"nvar_P_GOODSOPTIONCATIONCODE12", optionCode12},
            {"nvar_P_GOODSOPTIONVALUES12", optionVal12},
            {"nvar_P_GOODSOPTIONCATIONCODE13", optionCode13},
            {"nvar_P_GOODSOPTIONVALUES13", optionVal13},
            {"nvar_P_GOODSOPTIONCATIONCODE14", optionCode14},
            {"nvar_P_GOODSOPTIONVALUES14", optionVal14},
            {"nvar_P_GOODSOPTIONCATIONCODE15", optionCode15},
            {"nvar_P_GOODSOPTIONVALUES15", optionVal15},
            {"nvar_P_GOODSOPTIONCATIONCODE16", optionCode16},
            {"nvar_P_GOODSOPTIONVALUES16", optionVal16},
            {"nvar_P_GOODSOPTIONCATIONCODE17", optionCode17},
            {"nvar_P_GOODSOPTIONVALUES17", optionVal17},
            {"nvar_P_GOODSOPTIONCATIONCODE18", optionCode18},
            {"nvar_P_GOODSOPTIONVALUES18", optionVal18},
            {"nvar_P_GOODSOPTIONCATIONCODE19", optionCode19},
            {"nvar_P_GOODSOPTIONVALUES19", optionVal19},
            {"nvar_P_GOODSOPTIONCATIONCODE20", optionCode20},
            {"nvar_P_GOODSOPTIONVALUES20", optionVal20},
            {"nvar_P_GOODSSUPPLYCBARCODE1", cBarcode1},
            {"nvar_P_GOODSSUPPLYCBARCODE2", cBarcode2},
            {"nvar_P_GOODSSUPPLYCBARCODE3", cBarcode3},
            {"nvar_P_GOODSCONFIRMMARK", gdsConfirmMark},
            {"nume_P_SUPPLYTRANSCOSTYN", supplyTransCostYN},
            {"nvar_P_SUPPLYTRANSCOSTVAT", supplyTransCostVat},
            {"nume_P_SUPPLYTRANSCOSTYN2", supplyTransCostYN2},
            {"nvar_P_SUPPLYTRANSCOSTVAT2", supplyTransCostVat2},
            {"nume_P_SUPPLYTRANSCOSTYN3", supplyTransCostYN3},
            {"nvar_P_SUPPLYTRANSCOSTVAT3", supplyTransCostVat3}

        };

        GoodsService GoodsService = new GoodsService();
        GoodsService.UpdateGoods(paramList);

        HttpContext.Current.Response.ContentType = "text/plain";
        HttpContext.Current.Response.Write("OK");
    }

    //상품등록
    protected void InsertGoods(HttpContext context)
    {
        string goodsCode = context.Request.Form["GoodsCode"].AsText();
        string categoryCode = context.Request.Form["CategoryCode"].AsText();
        string categoryName = context.Request.Form["CategoryName"].AsText();
        string groupCode = context.Request.Form["GroupCode"].AsText();
        string goodsName = context.Request.Form["GoodsName"].AsText();
        string sumCode = context.Request.Form["SummaryCode"].AsText();
        string brandCode = context.Request.Form["BrandCode"].AsText();
        string model = context.Request.Form["Model"].AsText();
        string unit = context.Request.Form["Unit"].AsText();
        string subUnit = context.Request.Form["SubUnit"].AsText();
        int unitMoq = context.Request.Form["UnitMoq"].AsInt(1);
        int unitQty = context.Request.Form["UnitQty"].AsInt();
        int? subQty = context.Request.Form["UnitSubQty"].AsIntNullable();
        string deliveryOrderDue = context.Request.Form["DeliveryOrderDue"].AsText();
        decimal buyPrice = context.Request.Form["BuyPrice"].AsDecimal();
        decimal buyPriceVat = context.Request.Form["BuyPriceVat"].AsDecimal();
        decimal salePrice = context.Request.Form["SalePrice"].AsDecimal();
        decimal salePriceVat = context.Request.Form["SalePriceVat"].AsDecimal();
        decimal msalePrice = context.Request.Form["MSalePrice"].AsDecimal();
        decimal msalePriceVat = context.Request.Form["MSalePriceVat"].AsDecimal();
        decimal custPrice = context.Request.Form["CustPrice"].AsDecimal();
        decimal custPriceVat = context.Request.Form["CustPriceVat"].AsDecimal();
        string goodsSpecial = context.Request.Form["GoodsSpecial"].AsText();
        string goodsFormat = context.Request.Form["GoodsFormat"].AsText();
        string cause = context.Request.Form["GoodsCause"].AsText();
        string supplies = context.Request.Form["GoodsSupplies"].AsText();
        string remindSearh = context.Request.Form["RemindSearch"].AsText();
        string mdId = context.Request.Form["MdId"].AsText();
        string mdMemo = context.Request.Form["Mdmemo"].AsText();
        int dispFlag = context.Request.Form["DisplayFlag"].AsInt();
        int noDispReason = context.Request.Form["NodisplayReason"].AsInt();
        int noSaleReason = context.Request.Form["NosaleReason"].AsInt();
        string noSaleEntDue = context.Request.Form["NosaleEnterdue"].AsText();
        int returnChangeFlag = context.Request.Form["ReturnChangeFlag"].AsInt();
        int keepYn = context.Request.Form["KeepYn"].AsInt();
        string saleTaxYn = context.Request.Form["SaleTaxYn"].AsText();
        string dcYn = context.Request.Form["DcYn"].AsText();
        int custGubun = context.Request.Form["CustGubun"].AsInt();
        string custGubunCode = context.Request.Form["CustGubunCode"].AsText();
        string barcode = context.Request.Form["Barcode"].AsText();
        string sCompCode1 = context.Request.Form["SCompCode1"].AsText();
        string sCompCode2 = context.Request.Form["SCompCode2"].AsText();
        string sCompCode3 = context.Request.Form["SCompCode3"].AsText();
        string sGoodsCode1 = context.Request.Form["SGoodsCode1"].AsText();
        string sGoodsCode2 = context.Request.Form["SGoodsCode2"].AsText();
        string sGoodsCode3 = context.Request.Form["SGoodsCode3"].AsText();
        string sGoodsUnit = context.Request.Form["SGoodsUnit"].AsText();
        int? sGoodsUnitMoq = context.Request.Form["SGoodsUnitMoq"].AsIntNullable();
        int? sGoodsUnitMoq2 = context.Request.Form["SGoodsUnitMoq2"].AsIntNullable();
        int? sGoodsUnitMoq3 = context.Request.Form["SGoodsUnitMoq3"].AsIntNullable();
        int sGoodsEntDue = context.Request.Form["SGoodsEnterDue"].AsInt();
        int sGoodsEntDue2 = context.Request.Form["SGoodsEnterDue2"].AsInt();
        int sGoodsEntDue3 = context.Request.Form["SGoodsEnterDue3"].AsInt();
        int sBuyCalc = context.Request.Form["SBuyCalc"].AsInt();
        int sBuyCalc2 = context.Request.Form["SBuyCalc2"].AsInt();
        int sBuyCalc3 = context.Request.Form["SBuyCalc3"].AsInt();
        int sOrderForm = context.Request.Form["SOrderForm"].AsInt();
        int sOrderForm2 = context.Request.Form["SOrderForm2"].AsInt();
        int sOrderForm3 = context.Request.Form["SOrderForm3"].AsInt();
        int sGoodsType = context.Request.Form["SGoodsType"].AsInt();
        string sDistrA = context.Request.Form["SDistrA"].AsText();
        int? sDistrDue = context.Request.Form["SDistrDue"].AsIntNullable();
        int? sDistrDue2 = context.Request.Form["SDistrDue2"].AsIntNullable();
        int? sDistrDue3 = context.Request.Form["SDistrDue3"].AsIntNullable();
        string originCode = context.Request.Form["OriginCode"].AsText();
        int deliGubun = context.Request.Form["DeliveryGubun"].AsInt();
        int deliCGubun = context.Request.Form["DeliveryCGubun"].AsInt();
        string deliCCode = context.Request.Form["DeliveryCCode"].AsText();
        string summaryValues = context.Request.Form["SummaryValues"].AsText();
        string optionCode1 = context.Request.Form["OptionCode1"].AsText();
        string optionVal1 = context.Request.Form["OptionValue1"].AsText();
        string optionCode2 = context.Request.Form["OptionCode2"].AsText();
        string optionVal2 = context.Request.Form["OptionValue2"].AsText();
        string optionCode3 = context.Request.Form["OptionCode3"].AsText();
        string optionVal3 = context.Request.Form["OptionValue3"].AsText();
        string optionCode4 = context.Request.Form["OptionCode4"].AsText();
        string optionVal4 = context.Request.Form["OptionValue4"].AsText();
        string optionCode5 = context.Request.Form["OptionCode5"].AsText();
        string optionVal5 = context.Request.Form["OptionValue5"].AsText();
        string optionCode6 = context.Request.Form["OptionCode6"].AsText();
        string optionVal6 = context.Request.Form["OptionValue6"].AsText();
        string optionCode7 = context.Request.Form["OptionCode7"].AsText();
        string optionVal7 = context.Request.Form["OptionValue7"].AsText();
        string optionCode8 = context.Request.Form["OptionCode8"].AsText();
        string optionVal8 = context.Request.Form["OptionValue8"].AsText();
        string optionCode9 = context.Request.Form["OptionCode9"].AsText();
        string optionVal9 = context.Request.Form["OptionValue9"].AsText();
        string optionCode10 = context.Request.Form["OptionCode10"].AsText();
        string optionVal10 = context.Request.Form["OptionValue10"].AsText();
        string optionCode11 = context.Request.Form["OptionCode11"].AsText();
        string optionVal11 = context.Request.Form["OptionValue11"].AsText();
        string optionCode12 = context.Request.Form["OptionCode12"].AsText();
        string optionVal12 = context.Request.Form["OptionValue12"].AsText();
        string optionCode13 = context.Request.Form["OptionCode13"].AsText();
        string optionVal13 = context.Request.Form["OptionValue13"].AsText();
        string optionCode14 = context.Request.Form["OptionCode14"].AsText();
        string optionVal14 = context.Request.Form["OptionValue14"].AsText();
        string optionCode15 = context.Request.Form["OptionCode15"].AsText();
        string optionVal15 = context.Request.Form["OptionValue15"].AsText();
        string optionCode16 = context.Request.Form["OptionCode16"].AsText();
        string optionVal16 = context.Request.Form["OptionValue16"].AsText();
        string optionCode17 = context.Request.Form["OptionCode17"].AsText();
        string optionVal17 = context.Request.Form["OptionValue17"].AsText();
        string optionCode18 = context.Request.Form["OptionCode18"].AsText();
        string optionVal18 = context.Request.Form["OptionValue18"].AsText();
        string optionCode19 = context.Request.Form["OptionCode19"].AsText();
        string optionVal19 = context.Request.Form["OptionValue19"].AsText();
        string optionCode20 = context.Request.Form["OptionCode20"].AsText();
        string optionVal20 = context.Request.Form["OptionValue20"].AsText();
        string barcode1 = context.Request.Form["Barcode1"].AsText();
        string barcode2 = context.Request.Form["Barcode2"].AsText();
        string barcode3 = context.Request.Form["Barcode3"].AsText();

        string gdsConfirmMark = context.Request.Form["GdsConfirmMark"].AsText(); //상품인증구분
        int supplyTransCostYN = context.Request.Form["SupplyTransCostYN"].AsInt(); //공급사1 매입운송유무
        decimal? supplyTransCostVat = context.Request.Form["SupplyTransCostVat"].AsDecimalNullable(); //공급사1 매입운송비용
        int supplyTransCostYN2 = context.Request.Form["SupplyTransCostYN2"].AsInt(); //공급사2 매입운송유무
        decimal? supplyTransCostVat2 = context.Request.Form["SupplyTransCostVat2"].AsDecimalNullable(); //공급사2 매입운송비용
        int supplyTransCostYN3 = context.Request.Form["SupplyTransCostYN3"].AsInt(); //공급사3 매입운송유무
        decimal? supplyTransCostVat3 = context.Request.Form["SupplyTransCostVat3"].AsDecimalNullable(); //공급사3 매입운송비용

        var paramList = new Dictionary<string, object> {
            {"nvar_P_GOODSCODE", goodsCode}, //상품코드
            {"nvar_P_GOODSFINALCATEGORYCODE", categoryCode},
            {"nvar_P_GOODSFINALCATEGORYNAME", categoryName},
            {"nvar_P_GOODSGROUPCODE", groupCode}, //그룹코드
            {"nvar_P_GOODSFINALNAME", goodsName},
            {"nvar_P_GOODSOPTIONSUMMARYCODE", sumCode},
            {"nvar_P_BRANDCODE", brandCode},
            {"nvar_P_GOODSMODEL", model},
            {"nvar_P_GOODSUNIT", unit},
            {"nvar_P_GOODSSUBUNIT", subUnit},
            {"nume_P_GOODSUNITMOQ", unitMoq},
            {"nume_P_GOODSUNITQTY", unitQty},
            {"nvar_P_GOODSUNITSUBQTY", subQty},
            {"nume_P_GOODSDELIVERYORDERDUE", deliveryOrderDue},
            {"nume_P_GOODSBUYPRICE", buyPrice},
            {"nume_P_GOODSBUYPRICEVAT", buyPriceVat},
            {"nume_P_GOODSSALEPRICE", salePrice},
            {"nume_P_GOODSSALEPRICEVAT", salePriceVat},
            {"nume_P_GOODSMSALEPRICE", msalePrice},
            {"nume_P_GOODSMSALEPRICEVAT", msalePriceVat},
            {"nume_P_GOODSCUSTPRICE", custPrice},
            {"nume_P_GOODSCUSTPRICEVAT", custPriceVat},
            {"nvar_P_GOODSSPECIAL", goodsSpecial},
            {"nvar_P_GOODSFORMAT", goodsFormat},
            {"nvar_P_GOODSCAUSE", cause},
            {"nvar_P_GOODSSUPPLIES", supplies},
            {"nvar_P_GOODSREMINDSEARCH", remindSearh},
            {"nvar_P_MDTOID", mdId},
            {"nvar_P_MDMEMO", mdMemo},
            {"nume_P_GOODSDISPLAYFLAG", dispFlag},
            {"nume_P_GOODSNODISPLYREASON", noDispReason},
            {"nume_P_GOODSNOSALEREASON", noSaleReason},
            {"nvar_P_GOODSNOSALEENTERTARGETDUE",String.Format("{0:yyyy-MM-dd HH:mm:ss}",  noSaleEntDue) },
            {"nume_P_GOODSRETURNCHANGEFLAG", returnChangeFlag},
            {"nume_P_GOODSKEEPYN", keepYn},
            {"nvar_P_GOODSSALETAXYN", saleTaxYn},
            {"nvar_P_GOODSDCYN", dcYn},
            {"nume_P_GOODSCUSTGUBUN", custGubun},
            {"nvar_P_GOODSSALECUSTGUBUNCODE", custGubunCode},
            {"nvar_P_GOODSSUPPLYBARCODE", barcode},
            {"nvar_P_SUPPLYCOMPANYCODE1", sCompCode1},
            {"nvar_P_SUPPLYCOMPANYCODE2", sCompCode2},
            {"nvar_P_SUPPLYCOMPANYCODE3", sCompCode3},
            {"nvar_P_SUPPLYGOODSCODE1", sGoodsCode1},
            {"nvar_P_SUPPLYGOODSCODE2", sGoodsCode2},
            {"nvar_P_SUPPLYGOODSCODE3", sGoodsCode3},
            {"nvar_P_SUPPLYGOODSUNIT", sGoodsUnit},
            {"nume_P_SUPPLYGOODSUNITMOQ", sGoodsUnitMoq},
            {"nvar_P_SUPPLYGOODSUNITMOQ2", sGoodsUnitMoq2},
            {"nvar_P_SUPPLYGOODSUNITMOQ3", sGoodsUnitMoq3},
            {"nvar_P_SUPPLYGOODSENTERDUE", sGoodsEntDue},
            {"nume_P_SUPPLYGOODSENTERDUE2", sGoodsEntDue2},
            {"nume_P_SUPPLYGOODSENTERDUE3", sGoodsEntDue3},
            {"nume_P_SUPPLYBUYCALC", sBuyCalc},
            {"nume_P_SUPPLYBUYCALC2", sBuyCalc2},
            {"nume_P_SUPPLYBUYCALC3", sBuyCalc3},
            {"nume_P_SUPPLYORDERFORM", sOrderForm},
            {"nume_P_SUPPLYORDERFORM2", sOrderForm2},
            {"nume_P_SUPPLYORDERFORM3", sOrderForm3},
            {"nume_P_SUPPLYBUYGOODSTYPE", sGoodsType},
            {"nvar_P_SUPPLYGOODSDISTRADMIN", sDistrA},
            {"nvar_P_SUPPLYGOODSDISTRDUE", sDistrDue},
            {"nvar_P_SUPPLYGOODSDISTRDUE2", sDistrDue2},
            {"nvar_P_SUPPLYGOODSDISTRDUE3", sDistrDue3},
            {"nvar_P_GOODSORIGINCODE", originCode},
            {"nume_P_DELIVERYGUBUN", deliGubun},
            {"nume_P_DELIVERYCOSTGUBUN", deliCGubun},
            {"nvar_P_DELIVERYCOST_CODE", deliCCode},
            {"nvar_P_GOODSOPTIONSUMMARYVALUES", summaryValues},
            {"nvar_P_GOODSOPTIONCATIONCODE1", optionCode1},
            {"nvar_P_GOODSOPTIONVALUES1", optionVal1},
            {"nvar_P_GOODSOPTIONCATIONCODE2", optionCode2},
            {"nvar_P_GOODSOPTIONVALUES2", optionVal2},
            {"nvar_P_GOODSOPTIONCATIONCODE3", optionCode3},
            {"nvar_P_GOODSOPTIONVALUES3", optionVal3},
            {"nvar_P_GOODSOPTIONCATIONCODE4", optionCode4},
            {"nvar_P_GOODSOPTIONVALUES4", optionVal4},
            {"nvar_P_GOODSOPTIONCATIONCODE5", optionCode5},
            {"nvar_P_GOODSOPTIONVALUES5", optionVal5},
            {"nvar_P_GOODSOPTIONCATIONCODE6", optionCode6},
            {"nvar_P_GOODSOPTIONVALUES6", optionVal6},
            {"nvar_P_GOODSOPTIONCATIONCODE7", optionCode7},
            {"nvar_P_GOODSOPTIONVALUES7", optionVal7},
            {"nvar_P_GOODSOPTIONCATIONCODE8", optionCode8},
            {"nvar_P_GOODSOPTIONVALUES8", optionVal8},
            {"nvar_P_GOODSOPTIONCATIONCODE9", optionCode9},
            {"nvar_P_GOODSOPTIONVALUES9", optionVal9},
            {"nvar_P_GOODSOPTIONCATIONCODE10", optionCode10},
            {"nvar_P_GOODSOPTIONVALUES10", optionVal10},
            {"nvar_P_GOODSOPTIONCATIONCODE11", optionCode11},
            {"nvar_P_GOODSOPTIONVALUES11", optionVal11},
            {"nvar_P_GOODSOPTIONCATIONCODE12", optionCode12},
            {"nvar_P_GOODSOPTIONVALUES12", optionVal12},
            {"nvar_P_GOODSOPTIONCATIONCODE13", optionCode13},
            {"nvar_P_GOODSOPTIONVALUES13", optionVal13},
            {"nvar_P_GOODSOPTIONCATIONCODE14", optionCode14},
            {"nvar_P_GOODSOPTIONVALUES14", optionVal14},
            {"nvar_P_GOODSOPTIONCATIONCODE15", optionCode15},
            {"nvar_P_GOODSOPTIONVALUES15", optionVal15},
            {"nvar_P_GOODSOPTIONCATIONCODE16", optionCode16},
            {"nvar_P_GOODSOPTIONVALUES16", optionVal16},
            {"nvar_P_GOODSOPTIONCATIONCODE17", optionCode17},
            {"nvar_P_GOODSOPTIONVALUES17", optionVal17},
            {"nvar_P_GOODSOPTIONCATIONCODE18", optionCode18},
            {"nvar_P_GOODSOPTIONVALUES18", optionVal18},
            {"nvar_P_GOODSOPTIONCATIONCODE19", optionCode19},
            {"nvar_P_GOODSOPTIONVALUES19", optionVal19},
            {"nvar_P_GOODSOPTIONCATIONCODE20", optionCode20},
            {"nvar_P_GOODSOPTIONVALUES20", optionVal20},
            {"nvar_P_GOODSSUPPLYCBARCODE1", barcode1},
            {"nvar_P_GOODSSUPPLYCBARCODE2", barcode2},
            {"nvar_P_GOODSSUPPLYCBARCODE3", barcode3},
            {"nvar_P_GOODSCONFIRMMARK", gdsConfirmMark},
            {"nume_P_SUPPLYTRANSCOSTYN", supplyTransCostYN},
            {"nvar_P_SUPPLYTRANSCOSTVAT", supplyTransCostVat},
            {"nume_P_SUPPLYTRANSCOSTYN2", supplyTransCostYN2},
            {"nvar_P_SUPPLYTRANSCOSTVAT2", supplyTransCostVat2},
            {"nume_P_SUPPLYTRANSCOSTYN3", supplyTransCostYN3},
            {"nvar_P_SUPPLYTRANSCOSTVAT3", supplyTransCostVat3}
        };

        GoodsService GoodsService = new GoodsService();
        GoodsService.InsertGoods(paramList);

        context.Response.ContentType = "text/plain";
        context.Response.Write("OK");
    }

    //상품 코드 생성
    protected void CreateGoodsCode(HttpContext context)
    {
        GoodsService GoodsService = new GoodsService();
        HttpContext.Current.Response.ContentType = "text/json";

        var param = new Dictionary<string, object> { };

        var curCode = GoodsService.GetLastGoodsCode(param); ;
        string code = StringValue.GetNextGoodsCode(curCode);
        var returnjsonData = JsonConvert.SerializeObject(code);
        HttpContext.Current.Response.Write(returnjsonData);
    }

        //서비스용역 상품코드 생성
        protected void CreateServiceGoodsCode(HttpContext context)
    {
        GoodsService GoodsService = new GoodsService();
        HttpContext.Current.Response.ContentType = "text/json";

        var param = new Dictionary<string, object> { };

        var curCode = GoodsService.GetLastServiceGoodsCode(param); ;
        string code = StringValue.GetNextServiceGoodsCode(curCode);
        var returnjsonData = JsonConvert.SerializeObject(code);
        HttpContext.Current.Response.Write(returnjsonData);
    }

    //상품 그룹코드 생성
    protected void CreateGoodsGroupCode(HttpContext context)
    {
        GoodsService GoodsService = new GoodsService();
        HttpContext.Current.Response.ContentType = "text/json";

        var param = new Dictionary<string, object> { };

        var curCode = GoodsService.GetLastGroupCode(param);
        string code = StringValue.GetNextGoodsGroupCode(curCode);
        var returnjsonData = JsonConvert.SerializeObject(code);
        HttpContext.Current.Response.Write(returnjsonData);
    }

    //서비스용역 그룹코드 생성    
    protected void CreateGoodsServiceGroupCode(HttpContext context)
    {
        GoodsService GoodsService = new GoodsService();
        HttpContext.Current.Response.ContentType = "text/json";

        var param = new Dictionary<string, object> { };

        var curCode = GoodsService.GetLastServiceGroupCode(param);
        string code = StringValue.GetNextGoodsServiceGroupCode(curCode);
        var returnjsonData = JsonConvert.SerializeObject(code);
        HttpContext.Current.Response.Write(returnjsonData);
    }

    //신규견적요청
    protected void InsertNewGoodReq(HttpContext context)
    {
        string nextCode = StringValue.NextNewGoodCode();
        string svidUser = context.Request.Form["SvidUser"].AsText();
        string userId = context.Request.Form["UserId"].AsText();
        string categoryCode = context.Request.Form["CategoryCode"].AsText();
        string categoryName = context.Request.Form["CategoryName"].AsText();
        string mdName = context.Request.Form["MdName"].AsText();
        string goodsName = context.Request.Form["GoodsName"].AsText();
        string optionValue = context.Request.Form["OptionValue"].AsText();
        string brandName = context.Request.Form["BrandName"].AsText();
        string model = context.Request.Form["Model"].AsText();
        string originName = context.Request.Form["OriginName"].AsText();
        string unitName = context.Request.Form["UnitName"].AsText();
        int prospectQty = context.Request.Form["Qty"].AsInt();
        decimal priceVat = context.Request.Form["Price"].AsDecimal();
        string explainDetail = context.Request.Form["Detail"].AsText();
        string reqSubject = context.Request.Form["ReqSubject"].AsText();
        string isUploadFileExist = context.Request.Form["FileFlag"].AsText();
        string svidAttach = isUploadFileExist == "Y" ? Guid.NewGuid().ToString() : string.Empty;


        var paramList = new Dictionary<string, object> {
            {"nvar_P_NEWGOODSREQNO", nextCode},
            {"nvar_P_SVID_USER", svidUser},
            {"nvar_P_GOODSCATEGORYFINALCODE", categoryCode},
            {"nvar_P_GOODSFINALNAME", goodsName},
            {"nvar_P_OPTIONVALUES", optionValue},
            {"nvar_P_BRANDNAME", brandName},
            {"nvar_P_GOODSMODEL", model},
            {"nvar_P_GOODSORIGINNAME", originName},
            {"nvar_P_GOODSUNITNAME", unitName},
            {"nume_P_PROSPECTGOODSQTY", prospectQty},
            {"nume_P_NEWGOODSPRICEVAT", priceVat},
            {"nvar_P_NEWGOODSEXPLANDETAIL", explainDetail},
            {"nvar_P_NEWGOODSREQSUBJECT", reqSubject},
            {"nvar_P_SVID_ATTACH", svidAttach},


        };

        GoodsService GoodsService = new GoodsService();
        GoodsService.InsertNewGoodReq(paramList);
        SendMMS(nextCode, categoryName, mdName, goodsName);
        HttpContext.Current.Response.ContentType = "text/plain";
        HttpContext.Current.Response.Write(svidAttach + "//" + nextCode);
    }

    private void SendMMS(string requestNo, string category, string md, string goodsName)
    {


        var paramList = new Dictionary<string, object>
        {
            {"nvar_P_TYPE", "GOODS"},
        };
        var userService = new UserService();
        var list = userService.GetSMSUserList(paramList);

        if (list != null)
        {
            string incomingUser = string.Empty;

            foreach (var item in list)
            {
                incomingUser += item.Name + "^" + Crypt.AESDecrypt256(item.PhoneNo).Replace("-", "") + "|";
            }

            if (!string.IsNullOrWhiteSpace(incomingUser))
            {
                var paramList2 = new Dictionary<string, object>
                {
                    {"nvar_P_SUBJECT", "[신규 상품 접수]"},
                    {"nvar_P_DEST_INFO", incomingUser.Substring(0, incomingUser.Length-1)},
                    {"nvar_P_MSG",  "[신규 상품 접수]\r\n요청번호 : " + requestNo +"\r\n카테고리 : " + category + "\r\n담당MD : " + md + "\r\n상품명 : " + goodsName + "\r\n세부사항들 검토 및 대응바랍니다." },
                };

                userService.MMSInsert(paramList2);
            }

        }
    }

    protected void GetNewGoodsRequestList(HttpContext context)
    {
        GoodsService GoodsService = new GoodsService();
        string svidUser = context.Request.Form["SvidUser"].AsText();
        string todateB = context.Request.Form["TodateB"].AsText();
        string todateE = context.Request.Form["TodateE"].AsText();
        int pageNo = context.Request.Form["PageNo"].AsInt();
        int pageSize = context.Request.Form["PageSize"].AsInt();


        var paramList = new Dictionary<string, object> {
             {"nvar_P_SVID_USER", svidUser},
             { "nvar_P_TODATEB", todateB},
             {"nvar_P_TODATEE", todateE},
             {"inte_P_PAGENO", pageNo},
             {"inte_P_PAGESIZE", pageSize},

        };

        var list = GoodsService.GetNewGoodsRequestList(paramList);
        var returnjsonData = JsonConvert.SerializeObject(list);
        HttpContext.Current.Response.ContentType = "text/json";
        HttpContext.Current.Response.Write(returnjsonData);
    }

    protected void GetAdminNewGoodsRequestList(HttpContext context)
    {
        GoodsService GoodsService = new GoodsService();

        string todateB = context.Request.Form["TodateB"].AsText();
        string todateE = context.Request.Form["TodateE"].AsText();
        int pageNo = context.Request.Form["PageNo"].AsInt();
        int pageSize = context.Request.Form["PageSize"].AsInt();


        var paramList = new Dictionary<string, object> {

             { "nvar_P_TODATEB", todateB},
             {"nvar_P_TODATEE", todateE},
             {"inte_P_PAGENO", pageNo},
             {"inte_P_PAGESIZE", pageSize},

        };

        var list = GoodsService.GetAdminNewGoodsRequestList(paramList);
        var returnjsonData = JsonConvert.SerializeObject(list);
        HttpContext.Current.Response.ContentType = "text/json";
        HttpContext.Current.Response.Write(returnjsonData);
    }

    //[상품요청]관리자 상품요청 진행상태 업데이트
    protected void UpdateNewGoodReq(HttpContext context)
    {
        string svidUser = context.Request.Form["SvidUser"].AsText();
        string reqNo = context.Request.Form["ReqNo"].AsText();
        string flag = context.Request.Form["Flag"].AsText();

        var paramList = new Dictionary<string, object> {
            {"nvar_P_NEWGOODSREQNO", reqNo},
            {"nvar_P_SVID_USER", svidUser},
            {"char_P_FLAG", flag},
        };

        GoodsService GoodsService = new GoodsService();
        GoodsService.UpdateNewGoodReqStatus(paramList);

        HttpContext.Current.Response.ContentType = "text/plain";
        HttpContext.Current.Response.Write("OK");
    }

    //상품MD조회(상품 등록 수정)
    protected void GetGoodsMDInfo(HttpContext context)
    {
        GoodsService GoodsService = new GoodsService();
        HttpContext.Current.Response.ContentType = "text/json";
        string categoryCode = context.Request.Form["CategoryCode"];
        var paramList = new Dictionary<string, object> {
            {"nvar_P_CATEGORYCODE", categoryCode},

        };

        var goodsInfo = GoodsService.GetGoodsMdInfo(paramList);
        var returnjsonData = JsonConvert.SerializeObject(goodsInfo);
        HttpContext.Current.Response.Write(returnjsonData);
    }

    //관리자 업체별 단가 리스트
    protected void GetAdminCompPriceList(HttpContext context)
    {
        GoodsService GoodsService = new GoodsService();
        string saleCompCode = context.Request.Form["SaleCompCode"].AsText();
        string compCode1 = context.Request.Form["CompCode1"].AsText();
        string compCode2 = context.Request.Form["CompCode2"].AsText();
        string compCode3 = context.Request.Form["CompCode3"].AsText();
        string compCode4 = context.Request.Form["CompCode4"].AsText();
        string compCode5 = context.Request.Form["CompCode5"].AsText();
        string categoryCode = context.Request.Form["CategoryCode"].AsText();
        string goodsName = context.Request.Form["GoodsName"].AsText();
        string goodsCode = context.Request.Form["GoodsCode"].AsText();
        string brandCode = context.Request.Form["BrandCode"].AsText();
        string brandName = context.Request.Form["BrandName"].AsText();
        string groupCode = context.Request.Form["GroupCode"].AsText();
        int pageNo = context.Request.Form["PageNo"].AsInt();
        int pageSize = context.Request.Form["PageSize"].AsInt();

        var paramList = new Dictionary<string, object> {
            {"nvar_P_SALECOMPCODE", saleCompCode},
            {"nvar_P_COMPCODE1", compCode1},
            {"nvar_P_COMPCODE2", compCode2},
            {"nvar_P_COMPCODE3", compCode3},
            {"nvar_P_COMPCODE4", compCode4},
            {"nvar_P_COMPCODE5", compCode5},
            {"nvar_P_CATEGORYCODE", categoryCode},
            {"nvar_P_GOODSNAME", goodsName},
            {"char_P_GOODSCODE", goodsCode},
            {"nvar_P_BRANDNAME", brandName},
            {"nvar_P_BRANDCODE", brandCode},
            {"nvar_P_GROUPCODE", groupCode},
            {"inte_P_PAGENO", pageNo},
            {"inte_P_PAGESIZE", pageSize},

        };

        var goodsList = GoodsService.GetAdminCompPriceList(paramList);
        var returnjsonData = JsonConvert.SerializeObject(goodsList);
        HttpContext.Current.Response.ContentType = "text/json";
        HttpContext.Current.Response.Write(returnjsonData);
    }

    //관리자 업체별 Display 리스트
    protected void GetAdminCompDisplayList(HttpContext context)
    {
        GoodsService GoodsService = new GoodsService();
        string gubun = context.Request.Form["Gubun"].AsText();
        string saleCompCode = context.Request.Form["SaleCompCode"].AsText();
        string compCode1 = context.Request.Form["CompCode1"].AsText();
        string compCode2 = context.Request.Form["CompCode2"].AsText();
        string compCode3 = context.Request.Form["CompCode3"].AsText();
        string compCode4 = context.Request.Form["CompCode4"].AsText();
        string compCode5 = context.Request.Form["CompCode5"].AsText();
        string categoryCode = context.Request.Form["CategoryCode"].AsText();
        string goodsName = context.Request.Form["GoodsName"].AsText();
        string goodsCode = context.Request.Form["GoodsCode"].AsText();
        string brandCode = context.Request.Form["BrandCode"].AsText();
        string brandName = context.Request.Form["BrandName"].AsText();
        string groupCode = context.Request.Form["GroupCode"].AsText();
        int pageNo = context.Request.Form["PageNo"].AsInt();
        int pageSize = context.Request.Form["PageSize"].AsInt();

        var paramList = new Dictionary<string, object> {
            {"nvar_P_GUBUN", gubun},
            {"nvar_P_SALECOMPCODE", saleCompCode},
            {"nvar_P_COMPCODE1", compCode1},
            {"nvar_P_COMPCODE2", compCode2},
            {"nvar_P_COMPCODE3", compCode3},
            {"nvar_P_COMPCODE4", compCode4},
            {"nvar_P_COMPCODE5", compCode5},
            {"nvar_P_CATEGORYCODE", categoryCode},
            {"nvar_P_GOODSNAME", goodsName},
            {"char_P_GOODSCODE", goodsCode},
            {"nvar_P_BRANDNAME", brandName},
            {"nvar_P_BRANDCODE", brandCode},
            {"nvar_P_GROUPCODE", groupCode},
            {"inte_P_PAGENO", pageNo},
            {"inte_P_PAGESIZE", pageSize},

        };

        var goodsList = GoodsService.GetAdminCompDisplayList(paramList);
        var returnjsonData = JsonConvert.SerializeObject(goodsList);
        HttpContext.Current.Response.ContentType = "text/json";
        HttpContext.Current.Response.Write(returnjsonData);
    }


    //관리자 업체별 단가 리스트(판매사 단가관리 세팅화면)
    protected void GetAdminCompPriceList_TypeA(HttpContext context)
    {
        GoodsService GoodsService = new GoodsService();
        string compCode1 = context.Request.Form["CompCode1"].AsText();
        string categoryCode = context.Request.Form["CategoryCode"].AsText();
        string goodsName = context.Request.Form["GoodsName"].AsText();
        string goodsCode = context.Request.Form["GoodsCode"].AsText();
        string brandCode = context.Request.Form["BrandCode"].AsText();
        string brandName = context.Request.Form["BrandName"].AsText();
        string groupCode = context.Request.Form["GroupCode"].AsText();
        int pageNo = context.Request.Form["PageNo"].AsInt();
        int pageSize = context.Request.Form["PageSize"].AsInt();

        var paramList = new Dictionary<string, object> {
            {"nvar_P_COMPCODE1", compCode1},
            {"nvar_P_CATEGORYCODE", categoryCode},
            {"nvar_P_GOODSNAME", goodsName},
            {"char_P_GOODSCODE", goodsCode},
            {"nvar_P_BRANDNAME", brandName},
            {"nvar_P_BRANDCODE", brandCode},
            {"nvar_P_GROUPCODE", groupCode},
            {"inte_P_PAGENO", pageNo},
            {"inte_P_PAGESIZE", pageSize},

        };

        var goodsList = GoodsService.GetAdminCompPriceList_TypeA(paramList);
        var returnjsonData = JsonConvert.SerializeObject(goodsList);
        HttpContext.Current.Response.ContentType = "text/json";
        HttpContext.Current.Response.Write(returnjsonData);
    }

    //[관리자] 판매자 디스플레이 관리 
    protected void CompanyGoods_List_TypeA(HttpContext context)
    {
        GoodsService GoodsService = new GoodsService();
        string gubun = context.Request.Form["Gubun"].AsText();                 //회사구분(A : 판매사 , B : 구매사)
        string compCode1 = context.Request.Form["CompCode1"].AsText();         //선택한 회사 코드
        string categoryCode = context.Request.Form["CategoryCode"].AsText();   //카테고리코드
        string goodsName = context.Request.Form["GoodsName"].AsText();         //상품명
        string goodsCode = context.Request.Form["GoodsCode"].AsText();         //상품코드
        string brandCode = context.Request.Form["BrandCode"].AsText();         //브랜드코드
        string brandName = context.Request.Form["BrandName"].AsText();         //브랜드명
        string groupCode = context.Request.Form["GroupCode"].AsText();         //그룹코드
        int pageNo = context.Request.Form["PageNo"].AsInt();                   //페이지넘버
        int pageSize = context.Request.Form["PageSize"].AsInt();               //페이지사이즈

        var paramList = new Dictionary<string, object> {
            {"nvar_P_GUBUN", gubun},
            { "nvar_P_COMPCODE1", compCode1},
            {"nvar_P_CATEGORYCODE", categoryCode},
            {"nvar_P_GOODSNAME", goodsName},
            {"char_P_GOODSCODE", goodsCode},
            {"nvar_P_BRANDNAME", brandName},
            {"nvar_P_BRANDCODE", brandCode},
            {"nvar_P_GROUPCODE", groupCode},
            {"inte_P_PAGENO", pageNo},
            {"inte_P_PAGESIZE", pageSize},

        };

        var goodsList = GoodsService.CompanyGoods_List_TypeA(paramList);
        var returnjsonData = JsonConvert.SerializeObject(goodsList);
        HttpContext.Current.Response.ContentType = "text/json";
        HttpContext.Current.Response.Write(returnjsonData);
    }


    //[관리자]판매사 상품 단가 업데이트
    protected void SaveCompPrice(HttpContext context)
    {
        string compCode = context.Request.Form["CompCode"].AsText();
        string gubun = context.Request.Form["Gubun"].AsText();
        string priceId = context.Request.Form["PriceId"].AsText();
        string ctgrCodes = context.Request.Form["CtgrCodes"].AsText();
        string groupCodes = context.Request.Form["GroupCodes"].AsText();
        string goodsCodes = context.Request.Form["GoodsCodes"].AsText();
        string prices = context.Request.Form["Prices"].AsText();

        var paramList = new Dictionary<string, object> {
            {"nvar_P_COMPANY_CODE", compCode},
            {"nvar_P_GUBUN", gubun},
            {"nvar_P_COMPANYPRICEID", priceId},
            //{"nvar_P_GOODSFINALCATEGORYCODES", ctgrCodes},
            //{"nvar_P_GOODSGROUPCODES", groupCodes},
            {"nvar_P_GOODSCODES", goodsCodes},
            {"nvar_P_COMPANYPRICES", prices},
        };

        GoodsService GoodsService = new GoodsService();
        GoodsService.SaveCompPrice(paramList);

        HttpContext.Current.Response.ContentType = "text/plain";
        HttpContext.Current.Response.Write("OK");
    }

    //[관리자]판매사 상품 단가 삭제 (null처리)
    protected void DeleteCompPrice(HttpContext context)
    {
        string compCode = context.Request.Form["CompCode"].AsText();
        string gubun = context.Request.Form["Gubun"].AsText();
        string priceId = context.Request.Form["PriceId"].AsText();
        string ctgrCodes = context.Request.Form["CtgrCodes"].AsText();
        string groupCodes = context.Request.Form["GroupCodes"].AsText();
        string goodsCodes = context.Request.Form["GoodsCodes"].AsText();

        var paramList = new Dictionary<string, object> {
            {"nvar_P_COMPANY_CODE", compCode},
            {"nvar_P_GUBUN", gubun},
            {"nvar_P_COMPANYPRICEID", priceId},
            {"nvar_P_GOODSFINALCATEGORYCODES", ctgrCodes},
            {"nvar_P_GOODSGROUPCODES", groupCodes},
            {"nvar_P_GOODSCODES", goodsCodes},
        };

        GoodsService GoodsService = new GoodsService();
        GoodsService.DeleteCompPrice(paramList);

        HttpContext.Current.Response.ContentType = "text/plain";
        HttpContext.Current.Response.Write("OK");
    }

    //[관리자]판매사 상품 단가 업데이트 일괄적용
    protected void MultiSaveCompPrice(HttpContext context)
    {
        string compCode = context.Request.Form["CompCode"].AsText();
        string gubun = context.Request.Form["Gubun"].AsText();
        string priceId = context.Request.Form["PriceId"].AsText();
        string ctgrCodes = context.Request.Form["CtgrCodes"].AsText();
        string groupCodes = context.Request.Form["GroupCodes"].AsText();
        string goodsCodes = context.Request.Form["GoodsCodes"].AsText();
        string unit = context.Request.Form["Unit"].AsText();
        string sign = context.Request.Form["Sign"].AsText();
        decimal price = context.Request.Form["Price"].AsDecimal();

        var paramList = new Dictionary<string, object> {
            {"nvar_P_COMPANY_CODE", compCode},
            {"nvar_P_GUBUN", gubun},
            {"nvar_P_COMPANYPRICEID", priceId},
            {"nvar_P_GOODSFINALCATEGORYCODES", ctgrCodes},
            {"nvar_P_GOODSGROUPCODES", groupCodes},
            {"nvar_P_GOODSCODES", goodsCodes},
            {"nvar_P_UNIT", unit},
            {"nvar_P_SIGN", sign},
            {"nume_P_COMPANYPRICE", price},
        };

        GoodsService GoodsService = new GoodsService();
        GoodsService.SaveMultiCompPrice(paramList);

        HttpContext.Current.Response.ContentType = "text/plain";
        HttpContext.Current.Response.Write("OK");
    }


    //[관리자]판매사 상품 디스플레이 업데이트 일괄적용  
    protected void MultiSaveCompDisplay(HttpContext context)
    {
        string compCode = context.Request.Form["CompCode"].AsText();
        string gubun = context.Request.Form["Gubun"].AsText();
        string companyGoodsId = context.Request.Form["CompanyGoodsId"].AsText();
        string goodsFinalCategoryCodes = context.Request.Form["GoodsFinalCategoryCodes"].AsText();
        string goodsGroupCodes = context.Request.Form["GoodsGroupCodes"].AsText();
        string goodsCodes = context.Request.Form["GoodsCodes"].AsText();
        string companyGoodsYN_Arr = context.Request.Form["CompanyGoodsYN_Arr"].AsText();


        var paramList = new Dictionary<string, object> {
            {"nvar_P_COMPANY_CODE", compCode},
            {"nvar_P_GUBUN", gubun},
            {"nvar_P_COMPANYGOODSID", companyGoodsId},
            {"nvar_P_GOODSFINALCATEGORYCODES", goodsFinalCategoryCodes},
            {"nvar_P_GOODSGROUPCODES", goodsGroupCodes},
            {"nvar_P_GOODSCODES", goodsCodes},
            {"nvar_P_COMPANYGOODSYN_ARR", companyGoodsYN_Arr},

        };

        GoodsService GoodsService = new GoodsService();
        GoodsService.SaveMultiCompDisplay(paramList);

        HttpContext.Current.Response.ContentType = "text/plain";
        HttpContext.Current.Response.Write("OK");
    }

    //[관리자]판매사 상품 디스플레이 업데이트 선택한 항목 적용  
    protected void SelectSaveCompDisplay(HttpContext context)
    {
        string compCode = context.Request.Form["CompCode"].AsText();
        string gubun = context.Request.Form["Gubun"].AsText();
        string companyGoodsId = context.Request.Form["CompanyGoodsId"].AsText();
        string goodsFinalCategoryCodes = context.Request.Form["GoodsFinalCategoryCodes"].AsText();
        string goodsGroupCodes = context.Request.Form["GoodsGroupCodes"].AsText();
        string goodsCodes = context.Request.Form["GoodsCodes"].AsText();
        string companyGoodsYN_Arr = context.Request.Form["CompanyGoodsYN_Arr"].AsText();


        var paramList = new Dictionary<string, object> {
            {"nvar_P_COMPANY_CODE", compCode},
            {"nvar_P_GUBUN", gubun},
            {"nvar_P_COMPANYGOODSID", companyGoodsId},
            {"nvar_P_GOODSFINALCATEGORYCODES", goodsFinalCategoryCodes},
            {"nvar_P_GOODSGROUPCODES", goodsGroupCodes},
            {"nvar_P_GOODSCODES", goodsCodes},
            {"nvar_P_COMPANYGOODSYN_ARR", companyGoodsYN_Arr},

        };

        GoodsService GoodsService = new GoodsService();
        GoodsService.SaveSelectCompDisplay(paramList);

        HttpContext.Current.Response.ContentType = "text/plain";
        HttpContext.Current.Response.Write("OK");
    }



    //[관리자]구매사 상품 단가 업데이트
    protected void SaveBuyCompPrice(HttpContext context)
    {
        string compCode = context.Request.Form["CompCodes"].AsText();
        string gubun = context.Request.Form["Gubun"].AsText();
        string priceId = context.Request.Form["PriceId"].AsText();
        string ctgrCode = context.Request.Form["CtgrCode"].AsText();
        string groupCode = context.Request.Form["GroupCode"].AsText();
        string goodsCode = context.Request.Form["GoodsCode"].AsText();
        string prices = context.Request.Form["Prices"].AsText();

        var paramList = new Dictionary<string, object> {
            {"nvar_P_COMPANY_CODES", compCode},
            {"nvar_P_GUBUN", gubun},
            {"nvar_P_COMPANYPRICEID", priceId},
            {"nvar_P_GOODSFINALCATEGORYCODE", ctgrCode},
            {"nvar_P_GOODSGROUPCODE", groupCode},
            {"nvar_P_GOODSCODE", goodsCode},
            {"nvar_P_COMPANYPRICES", prices},
        };

        GoodsService GoodsService = new GoodsService();
        GoodsService.SaveBuyCompPrice(paramList);

        HttpContext.Current.Response.ContentType = "text/plain";
        HttpContext.Current.Response.Write("OK");
    }

    //[관리자]구매사 상품 단가 삭제
    protected void DeleteBuyCompPrice(HttpContext context)
    {
        string compCode = context.Request.Form["CompCodes"].AsText();
        string gubun = context.Request.Form["Gubun"].AsText();
        string priceId = context.Request.Form["PriceId"].AsText();
        string ctgrCode = context.Request.Form["CtgrCode"].AsText();
        string groupCode = context.Request.Form["GroupCode"].AsText();
        string goodsCode = context.Request.Form["GoodsCode"].AsText();

        var paramList = new Dictionary<string, object> {
            {"nvar_P_COMPANY_CODES", compCode},
            {"nvar_P_GUBUN", gubun},
            {"nvar_P_COMPANYPRICEID", priceId},
            {"nvar_P_GOODSFINALCATEGORYCODE", ctgrCode},
            {"nvar_P_GOODSGROUPCODE", groupCode},
            {"nvar_P_GOODSCODE", goodsCode},
        };

        GoodsService GoodsService = new GoodsService();
        GoodsService.DeleteBuyCompPrice(paramList);

        HttpContext.Current.Response.ContentType = "text/plain";
        HttpContext.Current.Response.Write("OK");
    }

    //[관리자]구매사 상품 Display 업데이트
    protected void SaveBuyCompDisplay(HttpContext context)
    {
        string compCode = context.Request.Form["CompCodes"].AsText();
        string gubun = context.Request.Form["Gubun"].AsText();
        string priceId = context.Request.Form["PriceId"].AsText();
        string ctgrCode = context.Request.Form["CtgrCode"].AsText();
        string groupCode = context.Request.Form["GroupCode"].AsText();
        string goodsCode = context.Request.Form["GoodsCode"].AsText();
        string useYN = context.Request.Form["UseYN"].AsText();

        var paramList = new Dictionary<string, object> {
            {"nvar_P_COMPANY_CODES", compCode},
            {"nvar_P_GUBUN", gubun},
            {"nvar_P_COMPANYGOODSID", priceId},
            {"nvar_P_GOODSFINALCATEGORYCODE", ctgrCode},
            {"nvar_P_GOODSGROUPCODE", groupCode},
            {"nvar_P_GOODSCODE", goodsCode},
            {"nvar_P_COMPANYGOODSYN_ARR", useYN},
        };

        GoodsService GoodsService = new GoodsService();
        GoodsService.SaveBuyCompDisplay(paramList);

        HttpContext.Current.Response.ContentType = "text/plain";
        HttpContext.Current.Response.Write("OK");
    }

    //[관리자]구매사 상품 단가 업데이트 일괄적용
    protected void MultiSaveBuyCompPrice(HttpContext context)
    {
        string compCodes = context.Request.Form["CompCodes"].AsText();
        string gubun = context.Request.Form["Gubun"].AsText();
        string priceId = context.Request.Form["PriceId"].AsText();
        string ctgrCodes = context.Request.Form["CtgrCodes"].AsText();
        string groupCodes = context.Request.Form["GroupCodes"].AsText();
        string goodsCodes = context.Request.Form["GoodsCodes"].AsText();
        string unit = context.Request.Form["Unit"].AsText();
        string sign = context.Request.Form["Sign"].AsText();
        decimal price = context.Request.Form["Price"].AsDecimal();

        var paramList = new Dictionary<string, object> {
            {"nvar_P_COMPANY_CODES", compCodes},
            {"nvar_P_GUBUN", gubun},
            {"nvar_P_COMPANYPRICEID", priceId},
            {"nvar_P_GOODSFINALCATEGORYCODES", ctgrCodes},
            {"nvar_P_GOODSGROUPCODES", groupCodes},
            {"nvar_P_GOODSCODES", goodsCodes},
            {"nvar_P_UNIT", unit},
            {"nvar_P_SIGN", sign},
            {"nume_P_COMPANYPRICE", price},
        };

        GoodsService GoodsService = new GoodsService();
        GoodsService.SaveMultiBuyCompPrice(paramList);

        HttpContext.Current.Response.ContentType = "text/plain";
        HttpContext.Current.Response.Write("OK");
    }

    //[관리자]구매사 상품 Display 업데이트 일괄적용
    protected void MultiSaveBuyCompDisplay(HttpContext context)
    {
        string compCodes = context.Request.Form["CompCodes"].AsText();
        string gubun = context.Request.Form["Gubun"].AsText();
        string priceId = context.Request.Form["PriceId"].AsText();
        string ctgrCodes = context.Request.Form["CtgrCodes"].AsText();
        string groupCodes = context.Request.Form["GroupCodes"].AsText();
        string goodsCodes = context.Request.Form["GoodsCodes"].AsText();
        string goodsYN = context.Request.Form["GoodsYN"].AsText();

        var paramList = new Dictionary<string, object> {
            {"nvar_P_COMPANY_CODES", compCodes},
            {"nvar_P_GUBUN", gubun},
            {"nvar_P_COMPANYGOODSID", priceId},
            {"nvar_P_GOODSFINALCATEGORYCODES", ctgrCodes},
            {"nvar_P_GOODSGROUPCODES", groupCodes},
            {"nvar_P_GOODSCODES", goodsCodes},
            {"nvar_P_COMPANYGOODSYN_ARR", goodsYN},
        };

        GoodsService GoodsService = new GoodsService();
        GoodsService.SaveMultiBuyCompDisplay(paramList);

        HttpContext.Current.Response.ContentType = "text/plain";
        HttpContext.Current.Response.Write("OK");
    }

    protected void GetLinkSearchUrl(HttpContext context)
    {
        GoodsService GoodsService = new GoodsService();
        HttpContext.Current.Response.ContentType = "text/json";
        string keyword = context.Request.Form["SearchKeyword"];
        var paramList = new Dictionary<string, object> {
            {"nvar_P_SEARCHKEYWORD", keyword}

        };

        var getUrl = GoodsService.GetLinkSearchUrl(paramList);
        var returnjsonData = JsonConvert.SerializeObject(getUrl);
        HttpContext.Current.Response.Write(returnjsonData);
    }

    protected void GoodsAutoCompleteList(HttpContext context)
    {
        GoodsService GoodsService = new GoodsService();

        var paramList = new Dictionary<string, object>
        {
        };

        var goodsList = GoodsService.GoodsAutoCompleteList(paramList);
        var returnjsonData = JsonConvert.SerializeObject(goodsList);
        HttpContext.Current.Response.ContentType = "text/json";
        HttpContext.Current.Response.Write(returnjsonData);
    }

    //[관리자] 판매자 디스플레이 관리 
    protected void GoodsRemindSearchList(HttpContext context)
    {
        GoodsService GoodsService = new GoodsService();

        string keyword = context.Request.Form["Keyword"].AsText();
        string compCode = context.Request.Form["CompCode"].AsText();
        string saleCompCode = context.Request.Form["SaleCompCode"].AsText();
        string dongshinCheck = context.Request.Form["DongshinCheck"].AsText("N");
        string freeYN = context.Request.Form["FreeCompanyYN"].AsText();
        string freeVatYN = context.Request.Form["FreeCompanyVatYN"].AsText("N");
        string svidUser = context.Request.Form["SvidUser"].AsText();
        var paramList = new Dictionary<string, object> {

            {"nvar_P_COMPCODE", compCode},
            {"nvar_P_SALECOMPCODE", saleCompCode},
            {"nvar_P_BDONGSHINCHECK",  dongshinCheck},
            {"nvar_P_FREECOMPANYYN", freeYN},
            {"nvar_P_KEYWORD", keyword},
            {"nvar_P_FREECOMPANYVATYN", freeVatYN},
            {"nvar_P_SVID_USER", svidUser},
        };


        var goodsList = GoodsService.GoodsRemindSearchList(paramList);
        var returnjsonData = JsonConvert.SerializeObject(goodsList);
        HttpContext.Current.Response.ContentType = "text/json";
        HttpContext.Current.Response.Write(returnjsonData);
    }

    //최근 본 상품
    protected void GetGoodsSearchLog(HttpContext context)
    {
        GoodsService GoodsService = new GoodsService();

        string svidUser = context.Request.Form["SvidUser"].AsText();
        var paramList = new Dictionary<string, object> {

            {"nvar_P_SVID_USER", svidUser},
        };


        var goodsList = GoodsService.GetGoodsSearchLog(paramList);
        var returnjsonData = JsonConvert.SerializeObject(goodsList);
        HttpContext.Current.Response.ContentType = "text/json";
        HttpContext.Current.Response.Write(returnjsonData);
    }

    protected void DeleteGoodsSearchLog(HttpContext context)
    {
        string goodsCode = context.Request.Form["GoodsCode"].AsText();

        var paramList = new Dictionary<string, object> {

            {"nvar_P_GOODSCODE", goodsCode},
        };

        GoodsService GoodsService = new GoodsService();
        GoodsService.DeleteGoodsSearchLog(paramList);

        HttpContext.Current.Response.ContentType = "text/plain";
        HttpContext.Current.Response.Write("OK");
    }

    protected void GetGoodsPriceCompareNextSeq(HttpContext context)
    {
        var paramList = new Dictionary<string, object>
        {
        };

        GoodsService GoodsService = new GoodsService();
        int returnVal = GoodsService.GetGoodsPriceCompareNextSeq(paramList);

        HttpContext.Current.Response.ContentType = "text/plain";
        HttpContext.Current.Response.Write(returnVal);
    }

    protected void InsertGoodsPriceCompare(HttpContext context)
    {
        string svidUser = context.Request.Form["SvidUser"].AsText();
        string companyCode = context.Request.Form["CompanyCode"].AsText();
        string randomSeq = context.Request.Form["RandomSeq"].AsText();
        int groupNo = context.Request.Form["GroupNo"].AsInt();

        string datas = context.Request.Form["Datas"].AsText();
        var obj = JsonConvert.DeserializeObject<List<Dictionary<string, string>>>(datas);

        using (OracleConnection connection = new OracleConnection(ConfigurationManager.AppSettings["ConnectionString"]))
        {
            connection.Open();
            using (OracleTransaction trans = connection.BeginTransaction())
            {

                try
                {

                    foreach (Dictionary<string, string> lst in obj)
                    {
                        var paramList = new Dictionary<string, object> {

                            {"nvar_P_SVID_USER", svidUser},
                            {"nvar_P_GOODSCODE", lst["GoodsCode"].AsText()},
                            {"nvar_P_COMPANYCODE", companyCode},
                            {"nume_P_GROUPCOMPARENO", groupNo},
                            {"nume_P_UNUM_CARTNO", lst["CartNo"].AsText()},
                            {"nvar_P_RANDOMSEQ", randomSeq},
                            {"nume_P_BASEPRICE", lst["Price"].AsText()},
                        };
                        GoodsService GoodsService = new GoodsService();
                        GoodsService.SaveGoodsPriceCompare(paramList);
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


    protected void UpdateGoodsPriceCompare(HttpContext context)
    {
        int groupNo = context.Request.Form["GroupNo"].AsInt();

        string datas = context.Request.Form["Datas"].AsText();
        var obj = JsonConvert.DeserializeObject<List<Dictionary<string, string>>>(datas);

        using (OracleConnection connection = new OracleConnection(ConfigurationManager.AppSettings["ConnectionString"]))
        {
            connection.Open();
            using (OracleTransaction trans = connection.BeginTransaction())
            {

                try
                {

                    foreach (Dictionary<string, string> lst in obj)
                    {
                        var paramList = new Dictionary<string, object> {

                            {"nume_P_GROUPCOMPARENO", groupNo},
                            {"nume_P_UNUM_CARTNO", lst["CartNo"].AsText()},
                            {"nume_P_BASEPRICE", lst["Price"].AsText()},
                        };
                        GoodsService GoodsService = new GoodsService();
                        GoodsService.UpdateGoodsPriceCompare(paramList);
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

    protected void GetPriceCompareNo(HttpContext context)
    {
        string cartNos = context.Request.Form["CartNos"].AsText();
        var paramList = new Dictionary<string, object> {
            { "P_UNUM_CARTNOS", cartNos}
        };

        GoodsService GoodsService = new GoodsService();
        int? returnVal = GoodsService.GetPriceCompareNo(paramList);

        HttpContext.Current.Response.ContentType = "text/plain";
        HttpContext.Current.Response.Write(returnVal);
    }

    protected void GetGoodsPriceCompareList(HttpContext context)
    {
        GoodsService GoodsService = new GoodsService();

        int groupNo = context.Request.Form["GroupNo"].AsInt();
        var paramList = new Dictionary<string, object> {

            {"nume_P_GROUPCOMPARENO", groupNo},
        };


        var goodsList = GoodsService.GetGoodsPriceCompareList(paramList);
        var returnjsonData = JsonConvert.SerializeObject(goodsList);
        HttpContext.Current.Response.ContentType = "text/json";
        HttpContext.Current.Response.Write(returnjsonData);
    }

    //그룹코드 검색해서 출력 
    protected void GetGroupCodeListByCategory(HttpContext context)


    {
        logger.Debug("In");
        GoodsService GoodsService = new GoodsService();


        //말단 카테고리 명
        string categoryFinalCode = context.Request.Form["SearchTarget"].AsText(); //뷰에서 받아오는거
                                                                                  //말단카테고리 검색어
        string categoryFinalName = context.Request.Form["SearchKeyword"].AsText();
        var paramList = new Dictionary<string, object> {
            //파라미터 넘기기 
            { "nvar_P_GOODSFINALCATEGORYCODE", categoryFinalCode}, //디비명이랑 같이 
            { "nvar_P_GOODSFINALCATEGORYNAME", categoryFinalName},


        };

        logger.Debug("Out");
        var goodsList = GoodsService.GetGroupCodeListByCategory(paramList);
        var returnjsonData = JsonConvert.SerializeObject(goodsList);
        HttpContext.Current.Response.ContentType = "text/json";
        HttpContext.Current.Response.Write(returnjsonData);
    }

    //그룹코드업데이트 핸들러
    protected void UpdateGoodsGroupCodeRank(HttpContext context)
    {
        GoodsService GoodsService = new GoodsService();

        string groupCode = context.Request.Form["GroupCode"].AsText();
        int baseRank = context.Request.Form["BaseRank"].AsInt();
        int groupRank = context.Request.Form["GroupRank"].AsInt();

        var paramList = new Dictionary<string, object> {
            //파라미터 넘기기 
            { "inte_P_RANK", groupRank},
            { "inte_P_BASERANK", baseRank},
            { "nvar_P_GOODSGROUPCODE", groupCode}, //디비명이랑 같이 


        };
        GoodsService.UpdateGoodsGroupCodeRank(paramList);
        HttpContext.Current.Response.ContentType = "text/plain";
        HttpContext.Current.Response.Write("OK");
    }



    //상품코드 검색
    protected void GetGoodsCodeListByCategory(HttpContext context) //20190326
    {
        logger.Debug("In");
        GoodsService GoodsService = new GoodsService();


        //말단 카테고리 명
        string categoryFinalCode = context.Request.Form["SearchTarget"].AsText(); //뷰에서 받아오는거
                                                                                  //말단카테고리 검색어
        string categoryFinalName = context.Request.Form["SearchKeyword"].AsText();
        var paramList = new Dictionary<string, object> {
            //파라미터 넘기기 
            { "nvar_P_GOODSFINALCATEGORYCODE", categoryFinalCode}, //디비명이랑 같이 
            { "nvar_P_GOODSFINALCATEGORYNAME", categoryFinalName},
        };

        logger.Debug("Out");
        var goodsList = GoodsService.GetGoodsCodeListByCategory(paramList);
        var returnjsonData = JsonConvert.SerializeObject(goodsList);
        HttpContext.Current.Response.ContentType = "text/json";
        HttpContext.Current.Response.Write(returnjsonData);
    }

    //상품코드업데이트 핸들러
    protected void UpdateGoodsCodeRank(HttpContext context)
    {
        GoodsService GoodsService = new GoodsService();

        string goodsCode = context.Request.Form["GoodsCode"].AsText(); //뷰에서 param 안에 들어갈 이름
        int baseRank = context.Request.Form["BaseRank"].AsInt();
        int goodsRank = context.Request.Form["GoodsCodeRank"].AsInt();

        var paramList = new Dictionary<string, object> {
            //파라미터 넘기기 
            { "nume_P_RANK", goodsRank},
            { "inte_P_BASERANK", baseRank},
            { "nvar_P_GOODSCODE", goodsCode}, //앞에는 DB명 뒤에는 위에 변수
            


        };
        GoodsService.UpdateGoodsCodeRank(paramList);
        HttpContext.Current.Response.ContentType = "text/plain";
        HttpContext.Current.Response.Write("OK");
    }



    //메인화면 인기상품 
    protected void GetPopularGoodsList(HttpContext context)
    {
        GoodsService GoodsService = new GoodsService();


        string svidUser = context.Request.Form["SvidUser"].AsText();

        var paramList = new Dictionary<string, object> {
            //파라미터 넘기기 
            { "nvar_P_SVID_USER", svidUser }, //DB로
           
        };

        var goodsList = GoodsService.GetPopularGoodsList(paramList);
        var returnjsonData = JsonConvert.SerializeObject(goodsList);
        HttpContext.Current.Response.ContentType = "text/json";
        HttpContext.Current.Response.Write(returnjsonData);
    }

    //관리자 상품조회 검색 리스트
    protected void GetGoodsSearchList_Admin(HttpContext context)
    {
        GoodsService GoodsService = new GoodsService();

        string categoryCode = context.Request.Form["CategoryCode"].AsText();
        string target = context.Request.Form["Target"].AsText();
        string brandKeyword = context.Request.Form["BrandKeyword"].AsText();
        string modelKeyword = context.Request.Form["ModelKeyword"].AsText();
        string rangeSearchFlag = context.Request.Form["RangeSearchFlag"].AsText();
        string goodsCodeB = context.Request.Form["GoodsCodeB"].AsText();
        string goodsCodeE = context.Request.Form["GoodsCodeE"].AsText();
        string dateSearchFlag = context.Request.Form["DateSearchFlag"].AsText();
        string toDateB = context.Request.Form["ToDateB"].AsText();
        string toDateE = context.Request.Form["ToDateE"].AsText();
        int pageNo = context.Request.Form["PageNo"].AsInt();
        int pageSize = context.Request.Form["PageSize"].AsInt();


        var paramList = new Dictionary<string, object>() {
              {"nvar_P_GOODSFINALCATEGORYCODE", categoryCode }
            , {"nvar_P_SEARCHTARGET", target }
            , {"nvar_P_MODELKEYWORD", modelKeyword } 
            , {"nvar_P_BRANDKEYWORD", brandKeyword }
            , {"nvar_P_RANGESEARCHFLAG", rangeSearchFlag}
            , {"nvar_P_GOODSCODEB", goodsCodeB }
            , {"nvar_P_GOODSCODEE", goodsCodeE }
            , {"nvar_P_DATESEARCHFLAG", dateSearchFlag }
            , {"nvar_P_TODATEB", toDateB}
            , {"nvar_P_TODATEE",  toDateE}
            , {"inte_P_PAGENO", pageNo }
            , {"inte_P_PAGESIZE", pageSize }
        };

        var list = GoodsService.GetCategoryGoodsList_Admin(paramList);
        var returnjsonData = JsonConvert.SerializeObject(list);
        HttpContext.Current.Response.ContentType = "text/json";
        HttpContext.Current.Response.Write(returnjsonData);
    }

    //메인화면 매출리스트 클릭시 
     protected void GetGoodsShoppingList(HttpContext context)
    {
        GoodsService GoodsService = new GoodsService();

        string Select_Company_Code = context.Request.Form["SELECT_COMPANY_CODE"].AsText(); //넘어온회사코드
        string BrandCode = context.Request.Form["BRANDCODE"].AsText(); //브랜드코드
        string BrandName = context.Request.Form["BRANDNAME"].AsText(); //브랜드이름
        string GoodsFinalName = context.Request.Form["GOODSFINALNAME"].AsText(); //상품명
        string ResgoodsFinalName = context.Request.Form["RESGOODSFINALNAME"].AsText(); //재검색 상품명
        string GoodsModel = context.Request.Form["GOODSMODEL"].AsText(); //모델명
        string GoodsCode = context.Request.Form["GOODSCODE"].AsText(); //상품코드
        string OrderValue = context.Request.Form["ORDERVALUE"].AsText(); //정렬순서
        string CertValue = context.Request.Form["CERTVALUE"].AsText(); //사회적기업제품 검색
        string CompCode = context.Request.Form["COMPCODE"].AsText(); //회사코드(구매사)
        string SaleCompCode = context.Request.Form["SALECOMPCODE"].AsText(); //회사코드(판매사)
        string BdongShinCheck = context.Request.Form["BDONGSHINCHECK"].AsText(); //동신자사체크
        string FreeCompanyYN = context.Request.Form["FREECOMPANYYN"].AsText(); //민간기업사용유무
        string FreeCompanyVatYN = context.Request.Form["FREECOMPANYVATYN"].AsText(); //민간기업VAT포함유무
        string Svid_User = context.Request.Form["SVID_USER"].AsText(); //사용자
        string PageNo = context.Request.Form["PAGENO"].AsText(); //페이지 
        string PageSize = context.Request.Form["PAGESIZE"].AsText();

        var paramList = new Dictionary<string, object>() {
              {"nvar_P_SELECT_COMPANY_CODE", Select_Company_Code }
            , {"nvar_P_BRANDCODE", BrandCode }
            , {"nvar_P_BRANDNAME", BrandName }
            , {"nvar_P_GOODSFINALNAME", GoodsFinalName }
            , {"nvar_P_RESGOODSFINALNAME", ResgoodsFinalName }
            , {"nvar_P_GOODSMODEL", GoodsModel }
            , {"nvar_P_GOODSCODE", GoodsCode }
            , {"nvar_P_ORDERVALUE", OrderValue }
            , {"nvar_P_CERTVALUE", CertValue }
            , {"nvar_P_COMPCODE", CompCode }
            , {"nvar_P_SALECOMPCODE", SaleCompCode }
            , {"nvar_P_BDONGSHINCHECK", BdongShinCheck }
            , {"nvar_P_FREECOMPANYYN", FreeCompanyYN }
            , {"nvar_P_FREECOMPANYVATYN", FreeCompanyVatYN }
            , {"nvar_P_SVID_USER", Svid_User }
            , {"nvar_P_PAGENO", PageNo }
            , {"nvar_P_PAGESIZE", PageSize }
        };

        var list = GoodsService.GetGoodsShoppingList(paramList);
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

}