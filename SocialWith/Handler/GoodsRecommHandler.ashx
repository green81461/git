<%@ WebHandler Language="C#" Class="GoodsRecommHandler" %>

using System;
using System.Web;
using Urian.Core;
using System.Collections.Generic;
using Newtonsoft.Json;
using SocialWith.Biz.Goods;
using NLog;
using System.Configuration;
using Oracle.ManagedDataAccess.Client;
using System.IO;
using System.Linq;
using SocialWith.Biz.Board;
public class GoodsRecommHandler : IHttpHandler
{
    #region << logger >>
    private static Logger logger = NLog.LogManager.GetCurrentClassLogger();
    private static readonly bool IsDebugEnabled = logger.IsDebugEnabled;
    private static readonly bool IsInfoEnabled = logger.IsInfoEnabled;
    private static readonly bool IsWarnEnabled = logger.IsWarnEnabled;
    private static readonly bool IsErrorEnabled = logger.IsErrorEnabled;
    private static readonly bool IsFatalEnabled = logger.IsFatalEnabled;
    #endregion

    GoodsRecommService RecommService = new GoodsRecommService();
    public void ProcessRequest(HttpContext context)
    {

        string method = context.Request.Form["Method"].AsText();
        switch (method)
        {
            case "GetGoodsRecommList":
                GetGoodsRecommList(context);
                break;
            case "GetGoodsRecommDetailList":
                GetGoodsRecommDetailList(context);
                break;
            case "GetGoodsRecommUserList":
                GetGoodsRecommUserList(context);
                break;
            case "GetRecommAddGoodsList":
                GetRecommAddGoodsList(context);
                break;
            case "GetGoodsRecommCount":
                GetGoodsRecommCount(context);
                break;
            case "SaveGoodsRecomm":
                SaveGoodsRecomm(context);
                break;
            case "SaveGoodsRecommService":
                SaveGoodsRecommService(context);
                break;
            case "UpdateGoodsRecommConfirm":
                UpdateGoodsRecommConfirm(context);
                break;
            case "OrderByGoodsRecomm":
                OrderByGoodsRecomm(context);
                break;
            case "GoodsRecommList_Admin":
                GoodsRecommList_Admin(context);
                break;

        }
    }

    protected void GetGoodsRecommList(HttpContext context)
    {

        string svidUser = context.Request.Form["SvidUser"].AsText();
        string sDate = context.Request.Form["Sdate"].AsText();
        string eDate = context.Request.Form["Edate"].AsText();
        string subject = context.Request.Form["Subject"].AsText();
        string userName = context.Request.Form["UserName"].AsText();
        string code = context.Request.Form["Code"].AsText();
        int pageNo = context.Request.Form["PageNo"].AsInt();
        int pageSize = context.Request.Form["PageSize"].AsInt();


        var paramList = new Dictionary<string, object>
        {
            { "nvar_P_SVIDUSER", svidUser},
            { "nvar_P_SDATE", String.Format("{0:yyyy-MM-dd HH:mm:ss}", sDate) },
            { "nvar_P_EDATE", String.Format("{0:yyyy-MM-dd HH:mm:ss}", eDate) },
            { "nvar_P_SUBJECT", subject},
            { "nvar_P_ADMINNAME", userName},
            { "nvar_P_CODE", code},
            { "inte_P_PAGENO", pageNo},
            { "inte_P_PAGESIZE", pageSize},
        };

        var list = RecommService.GetGoodsRecommList(paramList);

        var returnjsonData = JsonConvert.SerializeObject(list);
        HttpContext.Current.Response.ContentType = "text/json";
        HttpContext.Current.Response.Write(returnjsonData);

    }


    protected void GetGoodsRecommDetailList(HttpContext context)
    {
        string code = context.Request.Form["Code"].AsText();

        var paramList = new Dictionary<string, object>
        {
            { "nvar_P_CODE", code},
        };

        var list = RecommService.GetGoodsRecommDetailList(paramList);

        var returnjsonData = JsonConvert.SerializeObject(list);
        HttpContext.Current.Response.ContentType = "text/json";
        HttpContext.Current.Response.Write(returnjsonData);

    }
    protected void GetGoodsRecommUserList(HttpContext context)
    {

        string type = context.Request.Form["SearchType"].AsText();
        string keyword = context.Request.Form["SearchKeyword"].AsText();
        int pageNo = context.Request.Form["PageNo"].AsInt();
        int pageSize = context.Request.Form["PageSize"].AsInt();


        var paramList = new Dictionary<string, object>
        {
            { "nvar_P_SEARCHTYPE", type},
            { "nvar_P_SEARCHKEYWORD", keyword},
            { "inte_P_PAGENO", pageNo},
            { "inte_P_PAGESIZE", pageSize},
        };

        var list = RecommService.GetGoodsRecommUserList(paramList);

        var returnjsonData = JsonConvert.SerializeObject(list);
        HttpContext.Current.Response.ContentType = "text/json";
        HttpContext.Current.Response.Write(returnjsonData);

    }

    public void GetRecommAddGoodsList(HttpContext context)
    {
        string codes = context.Request.Form["GoodsCodes"]; //추가될 상품코드
        string compCode = context.Request.Form["CompCode"]; //회사코드
        string saleCompCode = context.Request.Form["SaleCompCode"]; //판매사 코드
        string bCheck = context.Request.Form["Bcheck"]; //자사체크
        string freeCompYn = context.Request.Form["FreeCompYn"]; //민간유무
        string freeCompVatYn = context.Request.Form["FreeCompVatYn"]; //민간구매사(vat 사용유무)
        var paramList = new Dictionary<string, object> {
           { "nvar_P_GOODSCODES", codes},
           { "nvar_P_COMPCODE", compCode},
           { "nvar_P_SALECOMPCODE", saleCompCode},
           { "nvar_P_BDONGSHINCHECK", bCheck},
           { "nvar_P_FREECOMPANYYN", freeCompYn},
           { "nvar_P_FREECOMPANYVATYN", freeCompVatYn},

        };
        var list = RecommService.GetRecommAddGoodsList(paramList);

        var returnjsonData = JsonConvert.SerializeObject(list);

        context.Response.ContentType = "text/json";
        context.Response.Write(returnjsonData);
    }

    protected void SaveGoodsRecomm(HttpContext context)
    {

        string svidUser = context.Request.Form["SvidUser"].AsText();
        string buyCompCode = context.Request.Form["BuyCompCode"].AsText();
        string saleCompCode = context.Request.Form["SaleCompCode"].AsText();
        string subject = context.Request.Form["Subject"].AsText();
        string remark = context.Request.Form["Remark"].AsText();
        string adminid = context.Request.Form["AdminId"].AsText();
        string categoryCodes = context.Request.Form["CategoryCodes"].AsText();
        string groupCodes = context.Request.Form["GroupCodes"].AsText();
        string goodsCodes = context.Request.Form["GoodsCodes"].AsText();
        string goodsPrices = context.Request.Form["Prices"].AsText();
        string goodsPriceVats = context.Request.Form["PriceVats"].AsText();
        string goodsCustPrices = context.Request.Form["CustPrices"].AsText();
        string goodsCustPriceVats = context.Request.Form["CustPriceVats"].AsText();
        string qtys = context.Request.Form["Qtys"].AsText();
        string seqs = context.Request.Form["Seqs"].AsText();
        string gubun = context.Request.Form["Gubun"].AsText();
        var paramList = new Dictionary<string, object>() {
               { "nvar_P_CODE", GetGoodsRecommNextCodes(gubun)},
               { "nvar_P_SVID_USER", svidUser},
               { "nvar_P_SALECOMPCODE", saleCompCode},
               { "nvar_P_BUYCOMPCODE", buyCompCode},
               { "nvar_P_SUBJECT", subject},
               { "nvar_P_REMARK", remark},
               { "nvar_P_ADMINID", adminid},
               { "nvar_P_GOODSFINALCATEGORYCODES", categoryCodes},
               { "nvar_P_GOODSGROUPCODES", groupCodes},
               { "nvar_P_GOODSCODES", goodsCodes},
               { "nvar_P_GOODSPRICES", goodsPrices},
               { "nvar_P_GOODSPRICEVATS", goodsPriceVats},
               { "nvar_P_GOODSCUSTPRICES", goodsCustPrices},
               { "nvar_P_GOODSCUSTPRICEVATS", goodsCustPriceVats},
               { "nvar_P_QTYS", qtys},
               { "nvar_P_SEQS", seqs},
        };

        RecommService.SaveGoodsRecomm(paramList);

        context.Response.ContentType = "text/plain";
        context.Response.Write("Success");
    }

    protected void SaveGoodsRecommService(HttpContext context)
    {

        string svidUser = context.Request.Form["SvidUser"].AsText();
        string buyCompCode = context.Request.Form["BuyCompCode"].AsText();
        string saleCompCode = context.Request.Form["SaleCompCode"].AsText();
        string subject = context.Request.Form["Subject"].AsText();
        string remark = context.Request.Form["Remark"].AsText();
        string adminid = context.Request.Form["AdminId"].AsText();
        string categoryCodes = context.Request.Form["CategoryCodes"].AsText();
        string groupCodes = context.Request.Form["GroupCodes"].AsText();
        string goodsCodes = context.Request.Form["GoodsCodes"].AsText();
        string goodsPrices = context.Request.Form["Prices"].AsText();
        string goodsPriceVats = context.Request.Form["PriceVats"].AsText();
        string goodsCustPrices = context.Request.Form["CustPrices"].AsText();
        string goodsCustPriceVats = context.Request.Form["CustPriceVats"].AsText();
        string qtys = context.Request.Form["Qtys"].AsText();
        string seqs = context.Request.Form["Seqs"].AsText();
        string gubun = context.Request.Form["Gubun"].AsText();
        string nextCode = GetGoodsRecommNextCodes(gubun);
        using (OracleConnection connection = new OracleConnection(ConfigurationManager.AppSettings["ConnectionString"]))
        {
            connection.Open();

            using (OracleTransaction trans = connection.BeginTransaction())
            {
                try
                {
                    var paramList = new Dictionary<string, object>() {
                           { "nvar_P_CODE", nextCode},
                           { "nvar_P_SVID_USER", svidUser},
                           { "nvar_P_SALECOMPCODE", saleCompCode},
                           { "nvar_P_BUYCOMPCODE", buyCompCode},
                           { "nvar_P_SUBJECT", subject},
                           { "nvar_P_REMARK", remark},
                           { "nvar_P_ADMINID", adminid},
                           { "nvar_P_GOODSFINALCATEGORYCODES", categoryCodes},
                           { "nvar_P_GOODSGROUPCODES", groupCodes},
                           { "nvar_P_GOODSCODES", goodsCodes},
                           { "nvar_P_GOODSPRICES", goodsPrices},
                           { "nvar_P_GOODSPRICEVATS", goodsPriceVats},
                           { "nvar_P_GOODSCUSTPRICES", goodsCustPrices},
                           { "nvar_P_GOODSCUSTPRICEVATS", goodsCustPriceVats},
                           { "nvar_P_QTYS", qtys},
                           { "nvar_P_SEQS", seqs},
                    };

                    RecommService.SaveGoodsRecomm(paramList);
                    if (HttpContext.Current.Request.Files.AllKeys.Any())
                    {
                        BoardService BoardService = new BoardService();
                        var files = HttpContext.Current.Request.Files;
                        var file = files["GFile"];
                        var fileName =  Path.GetFileName(file.FileName);
                        var ifileName =  nextCode +"_"+file.FileName;
                        var path = "\\GoodsRecomm\\" + nextCode + "\\";
                        var attachParamList = new Dictionary<string, object>() {
                           {"nvar_P_SVID_ATTACH", Guid.NewGuid().ToString()},
                            {"nvar_P_SVID_BOARD", nextCode},
                            {"nume_P_ATTACH_NO", 1 },
                            {"nvar_P_ATTACH_P_NAME",fileName },
                            {"nvar_P_ATTACH_I_NAME",ifileName },
                            {"nvar_P_ATTACH_EXT", Path.GetExtension(fileName)},
                            {"nume_P_ATTACH_DOWNCNT",0 },
                            {"nvar_P_ATTACH_SIZE", file.ContentLength },
                            {"nvar_P_ATTACH_PATH", path }
                        };
                        BoardService.SaveBoardAttach(attachParamList);
                        string uploadFolder = ConfigurationManager.AppSettings["UpLoadFolder"].AsText();
                        GoodsRecommServiceFileUpload(nextCode, uploadFolder, fileName ,context, file );

                    }
                }
                catch (Exception)
                {
                    trans.Rollback();
                    throw;
                }
            }
        }


        context.Response.ContentType = "text/plain";
        context.Response.Write("Success");
    }

    public void GoodsRecommServiceFileUpload(string code, string uploadFolder, string fileName, HttpContext context, HttpPostedFile file)
    {

        string virtualPath = String.Format("{0}/{1}/{2}/"
                                                    , uploadFolder
                                                    , "GoodsRecomm"
                                                    , code
                                                    );

        string realPath = context.Server.MapPath(virtualPath);

        int fileSize = file.ContentLength; //업로드될 파일 크기
        int maxSize = int.Parse(ConfigurationManager.AppSettings["UploadFileMaxSize"]);
        string strNowFileName = FileHelper.UploadFileCheck(realPath, fileName, maxSize, fileSize);
        FileHelper.CreateDirectory(realPath);
        if (strNowFileName.Equals("false"))
        {
            HttpContext.Current.Response.Write("<script>alert(\"Error - 파일 업로드중 오류 발생! 파일타입과 용량확인!\"); location.href='" + HttpContext.Current.Request.Url.ToString() + "';</script>");
            HttpContext.Current.Response.End();
        }
        logger.Debug("realPath="+realPath );
        logger.Debug("strNowFileName="+strNowFileName );
        file.SaveAs(realPath + strNowFileName);
    }


    protected void OrderByGoodsRecomm(HttpContext context)
    {
        string cartCode = StringValue.NextCartCode();
        string svid_user = context.Request.Form["SvidUser"].AsText();
        string categoryCodes = context.Request.Form["GoodsFinCtgrCodes"].AsText();
        string groupCodes = context.Request.Form["GoodsGrpCodes"].AsText();
        string goodsCodes = context.Request.Form["GoodsCodes"].AsText();
        string qtys = context.Request.Form["QTYs"].AsText();
        string priceVats = context.Request.Form["PriceVats"].AsText();
        string prices = context.Request.Form["Prices"].AsText();
        string compCode = context.Request.Form["CompCode"].AsText();
        string saleCompCode = context.Request.Form["SaleCompCode"].AsText();
        string dongshinCheck = context.Request.Form["DongshinCheck"].AsText("N");
        string freeCompYN = context.Request.Form["FreeCompanyYN"].AsText("N");

        var paramList = new Dictionary<string, object> {
            {"nvar_P_SVID_USER", svid_user},
            {"nvar_P_CARTCODE", cartCode},
            {"nvar_P_GOODSFINALCATEGORYCODES", categoryCodes},
            {"nvar_P_GOODSGROUPCODES",  groupCodes},
            {"nvar_P_GOODSCODES", goodsCodes},
            {"nvar_P_QTYS", qtys},
            {"nvar_P_TOTALPRICEVATS", priceVats},
            {"nvar_P_TOTALPRICES", prices},
            {"nvar_P_COMPCODE", compCode},
            {"nvar_P_SALECOMPCODE", saleCompCode},
            {"nvar_P_BDONGSHINCHECK",  dongshinCheck},
            {"nvar_P_FREECOMPANYYN", freeCompYN},
        };

        RecommService.SaveGoodsRecommOrder(paramList);

        context.Response.ContentType = "text/plain";
        context.Response.Write("Success");
    }
    public string GetGoodsRecommNextCodes(string gubun)
    {
        var paramList = new Dictionary<string, object>
        {
            {"nvar_P_GUBUN", gubun}
        };
        var curCode = RecommService.GetLastGoodsRecommCode(paramList);
        var nextCodes = StringValue.NextGoodsRecommCode(curCode, gubun);

        return nextCodes;
    }

    public void GetGoodsRecommCount(HttpContext context)
    {
        string svidUser = context.Request.Form["SvidUser"]; //추가될 상품코드
        var paramList = new Dictionary<string, object> {
           { "nvar_P_SVIDUSER", svidUser},
        };
        int count = RecommService.GetGoodsRecommCount(paramList);

        context.Response.ContentType = "text/plain";
        context.Response.Write(count);
    }

    public void UpdateGoodsRecommConfirm(HttpContext context)
    {
        string svidUser = context.Request.Form["SvidUser"]; //추가될 상품코드
        var paramList = new Dictionary<string, object> {
           { "nvar_P_SVIDUSER", svidUser},
        };
        RecommService.UpdateGoodsRecommConfirm(paramList);

        context.Response.ContentType = "text/plain";
        context.Response.Write("Success");
    }

    //[관리자] 견적관리 생성 리스트 조회 
    protected void GoodsRecommList_Admin(HttpContext context)
    {
        GoodsRecommService GoodsRecommService = new GoodsRecommService();


        string sdate = context.Request.Form["Sdate"].AsText();
        string edate = context.Request.Form["Edate"].AsText();
        string subject = context.Request.Form["Subject"].AsText();
        string adminName = context.Request.Form["AdminName"].AsText();
        string code = context.Request.Form["Code"].AsText();
        string gubun = context.Request.Form["Gubun"].AsText();
        string pageNo = context.Request.Form["PageNo"].AsText();
        string pageSize = context.Request.Form["PageSize"].AsText();


        var paramList = new Dictionary<string, object> {

            {"nvar_P_SDATE", sdate},
            {"nvar_P_EDATE", edate},
            {"nvar_P_SUBJECT",  subject},
            {"nvar_P_ADMINNAME", adminName},
            {"nvar_P_CODE", code},
            {"nvar_P_GUBUN", gubun},
            {"inte_P_PAGENO", pageNo},
            {"inte_P_PAGESIZE", pageSize},
        };


        var goodsList = GoodsRecommService.GetGoodsRecommListAdmin(paramList);
        var returnjsonData = JsonConvert.SerializeObject(goodsList);
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