<%@ WebHandler Language="C#" Class="FileDownload" %>

using System;
using System.Web;
using OfficeOpenXml;
using OfficeOpenXml.Style;
using Oracle.ManagedDataAccess.Client;
using SocialWith.Biz.Excel;
using System.Collections.Generic;
using System.Drawing;
using Urian.Core;
using NLog;
using System.Linq;
using System.Data;

public class FileDownload : IHttpHandler
{
    #region << logger >>
    protected static Logger logger = NLog.LogManager.GetCurrentClassLogger();
    protected static readonly bool IsDebugEnabled = logger.IsDebugEnabled;
    protected static readonly bool IsInfoEnabled = logger.IsInfoEnabled;
    protected static readonly bool IsWarnEnabled = logger.IsWarnEnabled;
    protected static readonly bool IsErrorEnabled = logger.IsErrorEnabled;
    protected static readonly bool IsFatalEnabled = logger.IsFatalEnabled;
    #endregion

    public void ProcessRequest(HttpContext context)
    {

        string method = context.Request.Form["Method"].AsText();
        switch (method)
        {
            case "GoodsListExcelDownLoad":
                GoodsListExcelDownLoad(context);
                break;
            case "MemberAListExcelDownLoad":
                MemberAListExcelDownLoad(context);
                break;
            case "MemberBListExcelDownLoad":
                MemberBListExcelDownLoad(context);
                break;
            case "DeliveryListExcelDownLoad":
                DeliveryListExcelDownLoad(context);
                break;
            case "ProfitListExcelDownLoad":
                ProfitListExcelDownLoad(context);
                break;
            default:
                break;
        }
    }

    //회원관리 구매사
    protected void MemberBListExcelDownLoad(HttpContext context)
    {
        string SEARCHKEYWORD_1 = context.Request.Form["SEARCHKEYWORD_1"];
        string SERACHTARGET_1 = context.Request.Form["SERACHTARGET_1"];
        string SEARCHKEYWORD_2 = context.Request.Form["SEARCHKEYWORD_2"];
        string SERACHTARGET_2 = context.Request.Form["SERACHTARGET_2"];
        string SEARCHKEYWORD_3 = context.Request.Form["SEARCHKEYWORD_3"];
        string SERACHTARGET_3 = context.Request.Form["SERACHTARGET_3"];
        string SEARCHKEYWORD_4 = context.Request.Form["SEARCHKEYWORD_4"];
        string SERACHTARGET_4 = context.Request.Form["SERACHTARGET_4"];
        string SEARCHKEYWORD_5 = context.Request.Form["SEARCHKEYWORD_5"];
        string SERACHTARGET_5 = context.Request.Form["SERACHTARGET_5"];
        string CONFIRMFLAG = context.Request.Form["CONFIRMFLAG"];
        string USEFLAG = context.Request.Form["USEFLAG"];
        string TYPE = context.Request.Form["TYPE"];


        var paramList = new Dictionary<string, object>() {

                  {"nvar_P_SEARCHKEYWORD_1", SEARCHKEYWORD_1 }
                , {"nvar_P_SERACHTARGET_1",  SERACHTARGET_1 }
                , {"nvar_P_SEARCHKEYWORD_2",  SEARCHKEYWORD_2 }
                , {"nvar_P_SERACHTARGET_2",  SERACHTARGET_2 }
                , {"nvar_P_SEARCHKEYWORD_3",  SEARCHKEYWORD_3 }
                , {"nvar_P_SERACHTARGET_3",  SERACHTARGET_3 }
                , {"nvar_P_SEARCHKEYWORD_4",  SEARCHKEYWORD_4 }
                , {"nvar_P_SERACHTARGET_4",  SERACHTARGET_4 }
                , {"nvar_P_SEARCHKEYWORD_5",  SEARCHKEYWORD_5 }
                , {"nvar_P_SERACHTARGET_5",  SERACHTARGET_5 }
                , {"nvar_P_CONFIRMFLAG",  CONFIRMFLAG }
                , {"nvar_P_USEFLAG",  USEFLAG }
                , {"nvar_P_TYPE",  TYPE }

            };

        string strDownloadFileName = DateTime.Now.ToString("yyyyMMddHHmmss");
        ExcelService excelService = new ExcelService();
        string[] headerName = { "번호", "회사연동 코드", "회사코드", "아이디", "담당자명", "회사명", "사업자번호", "사업장코드", "사업장명", "사업부코드", "사업부명", "부서코드", "부서명", "승인여부", "대표자명", "구매사주문유형", "가입경로", "전화번호", "휴대폰번호", "팩스번호", "이메일", "SMS동의", "EMAIL동의", "배너유무", "사용유무", "변경자", "수정날짜", "등록날짜" };
        var list = excelService.GetMemberListExcel(paramList);
        MemberBListExportExcel(context.Server.UrlEncode("swp219006" + "_회원목록"), headerName, list);
    }

    public void MemberBListExportExcel(string fileName, string[] headerNames, OracleDataReader reader)
    {
        ExcelPackage pck = new ExcelPackage();
        //Create the worksheet
        ExcelWorksheet ws = pck.Workbook.Worksheets.Add("회원목록조회");

        int headerIndex = 0;
        int colCount = 28;
        foreach (string name in headerNames)
        {

            ws.Cells[1, headerIndex + 1].Value = name;
            headerIndex++;

        }

        int count = reader.FieldCount;
        int col = 1, row = 2;

        while (reader.Read())
        {
            for (int i = 0; i < count; i++)
            {
                var val = reader.GetValue(i);
                ws.SetValue(row, col++, val);
            }
            row++;
            col = 1;
        }
        if (row > 2)
        {
            //Format the header
            using (ExcelRange rng = ws.Cells[1, 1, 1, colCount])
            {
                rng.Style.HorizontalAlignment = ExcelHorizontalAlignment.Center;
                rng.Style.Font.Bold = true;
                rng.Style.Fill.PatternType = ExcelFillStyle.Solid;                      //Set Pattern for the background to Solid
                rng.Style.Fill.BackgroundColor.SetColor(Color.FromArgb(79, 129, 189));  //Set color to dark blue
                rng.Style.Font.Color.SetColor(Color.White);
                rng.Style.Border.Top.Style = ExcelBorderStyle.Thin;
                rng.Style.Border.Left.Style = ExcelBorderStyle.Thin;
                rng.Style.Border.Right.Style = ExcelBorderStyle.Thin;
                rng.Style.Border.Bottom.Style = ExcelBorderStyle.Thin;

            }

            //Format the data
            using (ExcelRange rng = ws.Cells[2, 1, row - 1, colCount])
            {
                rng.Style.HorizontalAlignment = ExcelHorizontalAlignment.Center;
                rng.Style.VerticalAlignment = ExcelVerticalAlignment.Center;
                rng.Style.Border.Top.Style = ExcelBorderStyle.Thin;
                rng.Style.Border.Left.Style = ExcelBorderStyle.Thin;
                rng.Style.Border.Right.Style = ExcelBorderStyle.Thin;
                rng.Style.Border.Bottom.Style = ExcelBorderStyle.Thin;

            }

            ws.Cells[2, 27, row - 1, 28].Style.Numberformat.Format = "yyyy-MM-dd";
            //셀 사이즈 오토 세팅
            using (ExcelRange rng = ws.Cells[1, 1, row - 1, colCount])
            {
                rng.AutoFitColumns();
            }

            //Write it back to the client

        }


        HttpContext.Current.Response.ContentType = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet";
        HttpContext.Current.Response.AddHeader("content-disposition", "attachment;  filename=" + fileName + ".xlsx");
        HttpContext.Current.Response.AddHeader("set-cookie", "fileDownload=true; path=/");
        HttpContext.Current.Response.BinaryWrite(pck.GetAsByteArray());
        HttpContext.Current.Response.Flush();
        HttpContext.Current.Response.SuppressContent = true;
        HttpContext.Current.ApplicationInstance.CompleteRequest();
    }




    //회원관리 판매사
    protected void MemberAListExcelDownLoad(HttpContext context)
    {
        string SEARCHKEYWORD_1 = context.Request.Form["SEARCHKEYWORD_1"];
        string SERACHTARGET_1 = context.Request.Form["SERACHTARGET_1"];
        string SEARCHKEYWORD_2 = context.Request.Form["SEARCHKEYWORD_2"];
        string SERACHTARGET_2 = context.Request.Form["SERACHTARGET_2"];
        string SEARCHKEYWORD_3 = context.Request.Form["SEARCHKEYWORD_3"];
        string SERACHTARGET_3 = context.Request.Form["SERACHTARGET_3"];
        string SEARCHKEYWORD_4 = context.Request.Form["SEARCHKEYWORD_4"];
        string SERACHTARGET_4 = context.Request.Form["SERACHTARGET_4"];
        string SEARCHKEYWORD_5 = context.Request.Form["SEARCHKEYWORD_5"];
        string SERACHTARGET_5 = context.Request.Form["SERACHTARGET_5"];
        string CONFIRMFLAG = context.Request.Form["CONFIRMFLAG"];
        string USEFLAG = context.Request.Form["USEFLAG"];
        string TYPE = context.Request.Form["TYPE"];


        var paramList = new Dictionary<string, object>() {

                  {"nvar_P_SEARCHKEYWORD_1", SEARCHKEYWORD_1 }
                , {"nvar_P_SERACHTARGET_1",  SERACHTARGET_1 }
                , {"nvar_P_SEARCHKEYWORD_2",  SEARCHKEYWORD_2 }
                , {"nvar_P_SERACHTARGET_2",  SERACHTARGET_2 }
                , {"nvar_P_SEARCHKEYWORD_3",  SEARCHKEYWORD_3 }
                , {"nvar_P_SERACHTARGET_3",  SERACHTARGET_3 }
                , {"nvar_P_SEARCHKEYWORD_4",  SEARCHKEYWORD_4 }
                , {"nvar_P_SERACHTARGET_4",  SERACHTARGET_4 }
                , {"nvar_P_SEARCHKEYWORD_5",  SEARCHKEYWORD_5 }
                , {"nvar_P_SERACHTARGET_5",  SERACHTARGET_5 }
                , {"nvar_P_CONFIRMFLAG",  CONFIRMFLAG }
                , {"nvar_P_USEFLAG",  USEFLAG }
                , {"nvar_P_TYPE",  TYPE }

            };

        string strDownloadFileName = DateTime.Now.ToString("yyyyMMddHHmmss");
        ExcelService excelService = new ExcelService();
        string[] headerName = { "번호", "회사연동 코드", "회사코드", "아이디", "담당자명", "회사명", "사업자번호", "사업장코드", "사업장명", "사업부코드", "사업부명", "부서코드", "부서명", "승인여부", "대표자명", "플랫폼유형", "전화번호", "휴대폰번호", "팩스번호", "이메일", "SMS동의", "EMAIL동의", "배너유무", "사용유무", "변경자", "수정날짜", "등록날짜" };
        var list = excelService.GetMemberListExcel(paramList);
        MemberAListExportExcel(context.Server.UrlEncode("swp219006" + "_회원목록"), headerName, list);
    }

    public void MemberAListExportExcel(string fileName, string[] headerNames, OracleDataReader reader)
    {
        ExcelPackage pck = new ExcelPackage();
        //Create the worksheet
        ExcelWorksheet ws = pck.Workbook.Worksheets.Add("회원목록조회");

        int headerIndex = 0;
        int colCount = 27;
        foreach (string name in headerNames)
        {

            ws.Cells[1, headerIndex + 1].Value = name;
            headerIndex++;

        }

        int count = reader.FieldCount;
        int col = 1, row = 2;

        while (reader.Read())
        {
            for (int i = 0; i < count; i++)
            {
                var val = reader.GetValue(i);
                ws.SetValue(row, col++, val);
            }
            row++;
            col = 1;
        }
        if (row > 2)
        {
            //Format the header
            using (ExcelRange rng = ws.Cells[1, 1, 1, colCount])
            {
                rng.Style.HorizontalAlignment = ExcelHorizontalAlignment.Center;
                rng.Style.Font.Bold = true;
                rng.Style.Fill.PatternType = ExcelFillStyle.Solid;                      //Set Pattern for the background to Solid
                rng.Style.Fill.BackgroundColor.SetColor(Color.FromArgb(79, 129, 189));  //Set color to dark blue
                rng.Style.Font.Color.SetColor(Color.White);
                rng.Style.Border.Top.Style = ExcelBorderStyle.Thin;
                rng.Style.Border.Left.Style = ExcelBorderStyle.Thin;
                rng.Style.Border.Right.Style = ExcelBorderStyle.Thin;
                rng.Style.Border.Bottom.Style = ExcelBorderStyle.Thin;

            }

            //Format the data
            using (ExcelRange rng = ws.Cells[2, 1, row - 1, colCount])
            {
                rng.Style.HorizontalAlignment = ExcelHorizontalAlignment.Center;
                rng.Style.VerticalAlignment = ExcelVerticalAlignment.Center;
                rng.Style.Border.Top.Style = ExcelBorderStyle.Thin;
                rng.Style.Border.Left.Style = ExcelBorderStyle.Thin;
                rng.Style.Border.Right.Style = ExcelBorderStyle.Thin;
                rng.Style.Border.Bottom.Style = ExcelBorderStyle.Thin;

            }

            ws.Cells[2, 26, row - 1, 27].Style.Numberformat.Format = "yyyy-MM-dd";
            //셀 사이즈 오토 세팅
            using (ExcelRange rng = ws.Cells[1, 1, row - 1, colCount])
            {
                rng.AutoFitColumns();
            }

            //Write it back to the client

        }


        HttpContext.Current.Response.ContentType = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet";
        HttpContext.Current.Response.AddHeader("content-disposition", "attachment;  filename=" + fileName + ".xlsx");
        HttpContext.Current.Response.AddHeader("set-cookie", "fileDownload=true; path=/");
        HttpContext.Current.Response.BinaryWrite(pck.GetAsByteArray());
        HttpContext.Current.Response.Flush();
        HttpContext.Current.Response.SuppressContent = true;
        HttpContext.Current.ApplicationInstance.CompleteRequest();
    }




    //상품조회 
    protected void GoodsListExcelDownLoad(HttpContext context)
    {
        string categoryCode = context.Request.Form["CategoryCode"];
        string modelKeyword = context.Request.Form["ModelKeyword"];
        string brandKeyword = context.Request.Form["BrandKeyword"];
        string target = context.Request.Form["Target"];
        string rangeSearchFlag = context.Request.Form["RangeSearchFlag"];
        string goodsCodeB = context.Request.Form["GoodsCodeB"];
        string goodsCodeE = context.Request.Form["GoodsCodeE"];
        string dateSearchFlag = context.Request.Form["DateSearchFlag"];
        string toDateB = context.Request.Form["ToDateB"];
        string toDateE = context.Request.Form["ToDateE"];

        var paramList = new Dictionary<string, object>() {

                  {"nvar_P_GOODSFINALCATEGORYCODE", categoryCode }
                , {"nvar_P_SEARCHTARGET",  target }
                , {"nvar_P_MODELKEYWORD", modelKeyword }
                , {"nvar_P_BRANDKEYWORD", brandKeyword }
                , {"nvar_P_RANGESEARCHFLAG", rangeSearchFlag }
                , {"nvar_P_GOODSCODEB", goodsCodeB }
                , {"nvar_P_GOODSCODEE", goodsCodeE }
                , {"nvar_P_DATESEARCHFLAG", dateSearchFlag }
                , {"nvar_P_TODATEB", toDateB}
                , {"nvar_P_TODATEE",  toDateE}

            };

        string strDownloadFileName = DateTime.Now.ToString("yyyyMMddHHmmss");
        ExcelService excelService = new ExcelService();
        string[] headerName = { "최종카테고리", "상위카테고리 코드", "최종카테고리명", "	카테고리1단코드", "카테고리1단명", "카테고리2단코드", "카테고리2단명", "카테고리3단코드", "카테고리3단명", "카테고리4단코드", "카테고리4단명", "카테고리5단코드", "카테고리5단명", "6코드", "6코드명", "7코드", "7코드명", "8코드", "8코드명", "9코드", "9코드명", "10코드", "10코드명", "담당MD아이디", "MD메모", "브랜드코드", "그룹코드", "상품코드", "상품명", "모델명", "MOQ(최소판매수량)", "출고예정일", "내용량", "단위코드", "서브내용량", "서브단위코드", "특징", "형식", "주의사항", "용도", "옵션코드", "속성명1", "속성값1", "속성명2", "속성값2", "속성명3", "속성값3", "속성명4", "속성값4", "속성명5", "속성값5", "속성명6", "속성값6", "속성명7", "속성값7", "속성명8", "속성값8", "속성명9", "속성값9", "속성명10", "속성값10", "속성명11", "속성값11", "속성명12", "속성값12", "속성명13", "속성값13", "속성명14", "속성값14", "속성명15", "속성값15", "속성명16", "속성값16", "속성명17", "속성값17", "속성명18", "속성값18", "속성명19", "속성값19", "속성명20", "속성값20", "연관검색어", "상품노출여부", "비노출사유", "판매중단사유", "품절품목입고예정일", "반품(교환)불가여부", "재고관리여부", "판매과세여부", "추가DC적용여부", "고객사상품구분", "특정판매고객사코드", "매입가격(VAT별도)", "매입가격(VAT포함)", "판매사가격(VAT별도)", "판매사가격(VAT포함)", "구매사판매가격(VAT별도)", "구매사판매가격(VAT포함)", "민간구매사판매가격(VAT별도)", "민간구매사판매가격(VAT포함)", "매입상품유형", "공급사단위코드", "상품유통기간관리여부", "원산지코드", "상품바코드(낱개)", "상품바코드(inbox)", "상품바코드(outbox)", "공급사코드1", "공급사상품코드1", "상품바코드1", "매입MOQ1", "입고LEADTIME1", "매입정산구분1", "발주형태1", "상품제조유통기간1", "공급사코드2", "공급사상품코드2", "상품바코드2", "매입MOQ2", "입고LEADTIME2", "매입정산구분2", "발주형태2", "상품제조유통기간2", "공급사코드3", "공급사상품코드3", "상품바코드3", "매입MOQ3", "입고LEADTIME3", "매입정산구분3", "발주형태3", "상품제조유통기간3", "배송구분", "배송비구분", "배송비 비용코드" };
        var list = excelService.GetAdminGoodsListExcelReader(paramList);
        GoodsListExportExcel(context.Server.UrlEncode("swp219006" + "_상품목록"), headerName, list);
    }


    public void GoodsListExportExcel(string fileName, string[] headerNames, OracleDataReader reader)
    {
        ExcelPackage pck = new ExcelPackage();
        //Create the worksheet
        ExcelWorksheet ws = pck.Workbook.Worksheets.Add("상품목록조회");

        int headerIndex = 0;
        int colCount = 134;
        foreach (string name in headerNames)
        {

            ws.Cells[1, headerIndex + 1].Value = name;
            headerIndex++;

        }

        int count = reader.FieldCount;
        int col = 1, row = 2;

        while (reader.Read())
        {
            for (int i = 0; i < count; i++)
            {
                var val = reader.GetValue(i);
                ws.SetValue(row, col++, val);
            }
            row++;
            col = 1;
        }
        if (row > 2)
        {
            //Format the header
            using (ExcelRange rng = ws.Cells[1, 1, 1, colCount])
            {
                rng.Style.HorizontalAlignment = ExcelHorizontalAlignment.Center;
                rng.Style.Font.Bold = true;
                rng.Style.Fill.PatternType = ExcelFillStyle.Solid;                      //Set Pattern for the background to Solid
                rng.Style.Fill.BackgroundColor.SetColor(Color.FromArgb(79, 129, 189));  //Set color to dark blue
                rng.Style.Font.Color.SetColor(Color.White);
                rng.Style.Border.Top.Style = ExcelBorderStyle.Thin;
                rng.Style.Border.Left.Style = ExcelBorderStyle.Thin;
                rng.Style.Border.Right.Style = ExcelBorderStyle.Thin;
                rng.Style.Border.Bottom.Style = ExcelBorderStyle.Thin;

            }

            //Format the data
            using (ExcelRange rng = ws.Cells[2, 1, row - 1, colCount])
            {
                rng.Style.HorizontalAlignment = ExcelHorizontalAlignment.Center;
                rng.Style.VerticalAlignment = ExcelVerticalAlignment.Center;
                rng.Style.Border.Top.Style = ExcelBorderStyle.Thin;
                rng.Style.Border.Left.Style = ExcelBorderStyle.Thin;
                rng.Style.Border.Right.Style = ExcelBorderStyle.Thin;
                rng.Style.Border.Bottom.Style = ExcelBorderStyle.Thin;

            }
            //셀 사이즈 오토 세팅
            using (ExcelRange rng = ws.Cells[1, 1, row - 1, colCount])
            {
                rng.AutoFitColumns();
            }

            //Write it back to the client

        }


        HttpContext.Current.Response.ContentType = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet";
        HttpContext.Current.Response.AddHeader("content-disposition", "attachment;  filename=" + fileName + ".xlsx");
        HttpContext.Current.Response.AddHeader("set-cookie", "fileDownload=true; path=/");
        HttpContext.Current.Response.BinaryWrite(pck.GetAsByteArray());
        HttpContext.Current.Response.Flush();
        HttpContext.Current.Response.SuppressContent = true;
        HttpContext.Current.ApplicationInstance.CompleteRequest();
    }

    //배송조회 
    protected void DeliveryListExcelDownLoad(HttpContext context)
    {
        string svidUser = context.Request.Form["Svid_User"].AsText();
        string userId = context.Request.Form["UserId"].AsText();
        string toDateB = context.Request.Form["ToDateB"].AsText();
        string toDateE = context.Request.Form["ToDateE"].AsText();
        string orderCodeNo = context.Request.Form["OrderCodeNo"].AsText();
        string orderStatus = context.Request.Form["OrderStatus"].AsText();
        string payWay = context.Request.Form["Payway"].AsText();
        string buyCompName = context.Request.Form["BuyCompName"].AsText();
        string saleCompName = context.Request.Form["SaleCompName"].AsText();

        var paramList = new Dictionary<string, object>() {
                  {"nvar_P_SVID_USER", svidUser}
                , {"nvar_P_TODATEB", toDateB}
                , {"nvar_P_TODATEE", toDateE}
                , {"nvar_P_ORDERCODENO", orderCodeNo}
                , {"nvar_P_ORDERSTATUS", orderStatus}
                , {"nvar_P_PAYWAY", payWay}
                , {"nvar_P_BUYCOMPNAME", buyCompName}
                , {"nvar_P_SALECOMPNAME", saleCompName}
            };

        string strDownloadFileName = DateTime.Now.ToString("yyyyMMddHHmmss");
        ExcelService excelService = new ExcelService();
        string[] headerName = {
                "번호"
                ,"주문일자"
                ,"주문번호"
                ,"구매사"
                ,"주문자"
                ,"판매사"
                ,"주문상품정보"
                ,"모델명"
                ,"최소수량/내용량"
                , "주문수량"
                , "상품금액"
                , "주문금액"
                , "주문처리현황"
                , "결제수단"
                , "배송방법"
                , "운송장번호"
                , "입고확인"
        };
        var list = excelService.GetDeliveryListExcel(paramList);
        DeliveryListExportExcel(context.Server.UrlEncode(userId + "_배송조회"), headerName, list);
    }

    public void DeliveryListExportExcel(string fileName, string[] headerNames, OracleDataReader reader)
    {
        ExcelPackage pck = new ExcelPackage();

        //Create the worksheet
        ExcelWorksheet ws = pck.Workbook.Worksheets.Add("배송조회");

        int headerIndex = 0;
        int colCount = 17;

        // Format the header
        using (ExcelRange rng = ws.Cells[5, 1, 5, colCount])
        {
            rng.Style.HorizontalAlignment = ExcelHorizontalAlignment.Center;
            rng.Style.VerticalAlignment = ExcelVerticalAlignment.Center;
            rng.Style.Font.Bold = true;
            rng.Style.Fill.PatternType = ExcelFillStyle.Solid;                      //Set Pattern for the background to Solid
            rng.Style.Fill.BackgroundColor.SetColor(Color.FromArgb(79, 129, 189));  //Set color to dark blue
            rng.Style.Font.Color.SetColor(Color.White);
            rng.Style.Border.Top.Style = ExcelBorderStyle.Thin;
            rng.Style.Border.Left.Style = ExcelBorderStyle.Thin;
            rng.Style.Border.Right.Style = ExcelBorderStyle.Thin;
            rng.Style.Border.Bottom.Style = ExcelBorderStyle.Thin;
        }

        foreach (string name in headerNames)
        {
            ws.Cells[5, headerIndex + 1].Value = name;
            headerIndex++;
        }

        using (ExcelRange rng = ws.Cells[2, 1, 3, colCount])
        {
            rng.Value = "배송조회";
            rng.Merge = true;
            rng.Style.HorizontalAlignment = ExcelHorizontalAlignment.Left;
            rng.Style.VerticalAlignment = ExcelVerticalAlignment.Center;
            rng.Style.Font.Bold = true;
            rng.Style.Font.Size = 15;
            rng.Style.Font.Color.SetColor(Color.White);

            rng.Style.Border.Top.Style = ExcelBorderStyle.Thin;
            rng.Style.Border.Left.Style = ExcelBorderStyle.Thin;
            rng.Style.Border.Right.Style = ExcelBorderStyle.Thin;
            rng.Style.Border.Bottom.Style = ExcelBorderStyle.Thin;
            rng.Style.Fill.PatternType = ExcelFillStyle.Solid;                      //Set Pattern for the background to Solid
            rng.Style.Fill.BackgroundColor.SetColor(Color.FromArgb(79, 129, 189));  //Set color to dark blue
        }

        int count = reader.FieldCount;
        int col = 1, row = 6;

        while (reader.Read())
        {
            for (int i = 0; i < count; i++)
            {
                var val = reader.GetValue(i);
                ws.SetValue(row, col++, val);
            }
            row++;
            col = 1;
        }
        if (row > 2)
        {
            ws.Cells[2, 2, row - 1, 2].Style.Numberformat.Format = "yyyy-MM-dd";
            ws.Cells[2, 7, row - 1, 7].Style.WrapText = true;
            ws.Cells[2, 11, row - 1, 12].Style.Numberformat.Format = "#,###원";

            //Format the data
            using (ExcelRange rng = ws.Cells[5, 1, row - 1, colCount])
            {
                rng.Style.HorizontalAlignment = ExcelHorizontalAlignment.Center;
                rng.Style.VerticalAlignment = ExcelVerticalAlignment.Center;
                rng.Style.Border.Top.Style = ExcelBorderStyle.Thin;
                rng.Style.Border.Left.Style = ExcelBorderStyle.Thin;
                rng.Style.Border.Right.Style = ExcelBorderStyle.Thin;
                rng.Style.Border.Bottom.Style = ExcelBorderStyle.Thin;
            }
            //셀 사이즈 오토 세팅
            using (ExcelRange rng = ws.Cells[2, 1, row - 1, colCount])
            {
                rng.AutoFitColumns();
            }

            for (int i = 5; i <= row + 4; i++)
            {
                ws.Row(i + 1).Height = 45;
            }

            //상품정보 Cell Width세팅(Wraptext가 true로 설정되있으면 AutoFitColumns이 안먹는다...)
            ExcelRange columnCells = ws.Cells[6, 7, row - 1, 7];
            columnCells.Style.HorizontalAlignment = ExcelHorizontalAlignment.Left;
            int maxLength = columnCells.Max(cell => cell.Value.ToString().Count(c => char.IsLetterOrDigit(c)));
            ws.Column(7).Width = maxLength + 20; // 2 is just an extra buffer for all that is not letter/digits.
        }

        HttpContext.Current.Response.ContentType = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet";
        HttpContext.Current.Response.AddHeader("content-disposition", "attachment;  filename=" + fileName + ".xlsx");
        HttpContext.Current.Response.AddHeader("set-cookie", "fileDownload=true; path=/");
        HttpContext.Current.Response.BinaryWrite(pck.GetAsByteArray());
        HttpContext.Current.Response.Flush();
        HttpContext.Current.Response.SuppressContent = true;
        HttpContext.Current.ApplicationInstance.CompleteRequest();
    }


    // 관리자 정산내역조회 매출정산내역 조회 엑셀 다운로드
    protected void ProfitListExcelDownLoad(HttpContext context)
    {
        string month = context.Request.Form["Month"].AsText();
        string gubun = context.Request.Form["Gubun"].AsText();
        string compCode = context.Request.Form["CompCode"].AsText();
        string buyerCompany_Name = context.Request.Form["BuyerCompany_Name"].AsText();
        string payWay = context.Request.Form["PayWay"].AsText();
        string id = context.Request.Form["Id"].AsText();

        var paramList = new Dictionary<string, object>() {
                  {"nvar_P_MONTH", month}
                , {"nvar_P_GUBUN", gubun}
                , {"nvar_P_COMPCODE", compCode}
                , {"nvar_P_BUYERCOMPANY_NAME", buyerCompany_Name}
                , {"nvar_P_PAYWAY", payWay}
            };

        ExcelService excelService = new ExcelService();
        var table = excelService.GetProfitListExcel(paramList);
        for (int rowIndex = 0; rowIndex < table.Rows.Count; rowIndex++)
        {
            var isRMP = table.Rows[rowIndex]["ISRMP"].AsText();
            if (isRMP.Equals("Y"))
            {
                table.Rows[rowIndex]["GOODSRMPPRICEVAT"] = Math.Round(table.Rows[rowIndex]["GOODSBUYPRICEVAT"].AsDecimal() +
                    (table.Rows[rowIndex]["GOODSSALEPRICEVAT"].AsDecimal() - table.Rows[rowIndex]["GOODSBUYPRICEVAT"].AsDecimal()) *
                    (100 - table.Rows[rowIndex]["SWPPRICEP"].AsInt()) / 100); // RMP매출금액
                table.Rows[rowIndex]["GOODSCUSTPRICEVAT"] = Math.Round(table.Rows[rowIndex]["GOODSRMPPRICEVAT"].AsDecimal() +
                        (table.Rows[rowIndex]["GOODSSALEPRICEVAT"].AsDecimal() - table.Rows[rowIndex]["GOODSBUYPRICEVAT"].AsDecimal()) *
                        table.Rows[rowIndex]["RMPPRICEP"].AsInt() / 100); //판매사 매출금액
            }
            else
            {
                table.Rows[rowIndex]["GOODSRMPPRICEVAT"] = DBNull.Value;
                table.Rows[rowIndex]["GOODSCUSTPRICEVAT"] = table.Rows[rowIndex]["GOODSCUSTPRICEVAT"].AsDecimal();
            }

        }
        table.Columns.Remove("ISRMP"); // RMP 여부
        table.Columns.Remove("RMPCOMPANYCODE"); // RMP회사코드
        table.Columns.Remove("SWPPRICEP"); // 소셜위드/rmp 정산 가격 비율
        table.Columns.Remove("RMPPRICEP"); // rmp/판매사에서 rmp 정산 가격 비율
        table.Columns.Remove("SALEPRICEP"); // rmp/판매사에서 판매사 정산 가격 비율


        string[] headerName = {
                         "번호"
                        ,"주문일자"
                        ,"주문번호"
                        ,"구매사"
                        ,"입금날짜"
                        ,"주문자"
                        ,"아이디"
                        ,"판매사"
                        ,"RMP"
                        ,"주문상품정보"
                        ,"모델명"
                        ,"구매사 매출금액"
                        ,"결제수단"
                        ,"(예정)판매사 매출금액"
                        ,"(예정)RMP 매출금액"
                        ,"매입매출금액"
                        ,"플랫폼 이용수수료"
            };
        var fileName = context.Server.UrlEncode(id + "_매출정산내역");
        ProfitListExportExcel(fileName, headerName, table);
    }

    public void ProfitListExportExcel(string fileName, string[] headerNames, DataTable table)
    {

        using (ExcelPackage pck = new ExcelPackage())
        {
            //Create the worksheet
            ExcelWorksheet ws = pck.Workbook.Worksheets.Add("매출정산내역");
            int headerIndex = 0;
            int colCount = 17;
            //Format the header
            using (ExcelRange rng = ws.Cells[5, 1, 5, colCount])
            {
                rng.Style.HorizontalAlignment = ExcelHorizontalAlignment.Center;
                rng.Style.VerticalAlignment = ExcelVerticalAlignment.Center;
                rng.Style.Font.Bold = true;
                rng.Style.Fill.PatternType = ExcelFillStyle.Solid;                      //Set Pattern for the background to Solid
                rng.Style.Fill.BackgroundColor.SetColor(Color.FromArgb(79, 129, 189));  //Set color to dark blue
                rng.Style.Font.Color.SetColor(Color.White);
                rng.Style.Border.Top.Style = ExcelBorderStyle.Thin;
                rng.Style.Border.Left.Style = ExcelBorderStyle.Thin;
                rng.Style.Border.Right.Style = ExcelBorderStyle.Thin;
                rng.Style.Border.Bottom.Style = ExcelBorderStyle.Thin;

            }

            foreach (string name in headerNames)
            {

                ws.Cells[5, headerIndex + 1].Value = name;
                headerIndex++;

            }

            //Format the Title
            using (ExcelRange rng = ws.Cells[2, 1, 3, colCount])
            {
                rng.Value = "  매출정산내역";
                rng.Merge = true;
                rng.Style.HorizontalAlignment = ExcelHorizontalAlignment.Left;
                rng.Style.VerticalAlignment = ExcelVerticalAlignment.Center;
                rng.Style.Font.Bold = true;
                rng.Style.Font.Size = 15;
                rng.Style.Font.Color.SetColor(Color.White);

                rng.Style.Border.Top.Style = ExcelBorderStyle.Thin;
                rng.Style.Border.Left.Style = ExcelBorderStyle.Thin;
                rng.Style.Border.Right.Style = ExcelBorderStyle.Thin;
                rng.Style.Border.Bottom.Style = ExcelBorderStyle.Thin;
                rng.Style.Fill.PatternType = ExcelFillStyle.Solid;                      //Set Pattern for the background to Solid
                rng.Style.Fill.BackgroundColor.SetColor(Color.FromArgb(79, 129, 189));  //Set color to dark blue

            }

            if (table.Rows.Count > 0)
            {
                ws.Cells["A6"].LoadFromDataTable(table, false);


                ws.Cells[6, 2, table.Rows.Count + 5, 2].Style.Numberformat.Format = "yyyy-MM-dd"; // 주문일자
                ws.Cells[6, 5, table.Rows.Count + 5, 5].Style.Numberformat.Format = "yyyy-MM-dd"; // 입금날짜
                ws.Cells[6, 10, table.Rows.Count + 5, 10].Style.WrapText = true; // 주문상품정보


                ws.Cells[6, 12, table.Rows.Count + 5, 12].Style.Numberformat.Format = "#,###0원"; //구매사 매출금액
                ws.Cells[6, 14, table.Rows.Count + 5, 14].Style.Numberformat.Format = "#,###0원"; // 판매사 매출금액
                ws.Cells[6, 15, table.Rows.Count + 5, 15].Style.Numberformat.Format = "#,###0원"; // RMP 매출금액
                ws.Cells[6, 16, table.Rows.Count + 5, 16].Style.Numberformat.Format = "#,###0원"; // 매입 매출금액
                ws.Cells[6, 17, table.Rows.Count + 5, 17].Style.Numberformat.Format = "#,###0원"; // 플랫폼 이용수수료

                //Format the data
                using (ExcelRange rng = ws.Cells[6, 1, table.Rows.Count + 5, colCount])
                {
                    rng.Style.HorizontalAlignment = ExcelHorizontalAlignment.Center;
                    rng.Style.VerticalAlignment = ExcelVerticalAlignment.Center;
                    rng.Style.Border.Top.Style = ExcelBorderStyle.Thin;
                    rng.Style.Border.Left.Style = ExcelBorderStyle.Thin;
                    rng.Style.Border.Right.Style = ExcelBorderStyle.Thin;
                    rng.Style.Border.Bottom.Style = ExcelBorderStyle.Thin;

                }

                //셀 사이즈 오토 세팅
                using (ExcelRange rng = ws.Cells[5, 1, table.Rows.Count + 5, colCount])
                {
                    rng.AutoFitColumns();
                }

                for (int i = 5; i <= table.Rows.Count + 4; i++)
                {
                    ws.Row(i + 1).Height = 45;
                }

                // 주문상품정보 Cell Width세팅
                ExcelRange columnCells = ws.Cells[6, 10, table.Rows.Count + 5, 10]; // 주문상품정보

                columnCells.Style.HorizontalAlignment = ExcelHorizontalAlignment.Left;

                int maxLength = columnCells.Max(cell => cell.Value.ToString().Count(c => char.IsLetterOrDigit(c)));

                ws.Column(10).Width = maxLength + 20; // 2 is just an extra buffer for all that is not letter/digits.
            }


            //Write it back to the client
            HttpContext.Current.Response.ContentType = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet";
            HttpContext.Current.Response.AddHeader("content-disposition", "attachment;  filename=" + fileName + ".xlsx");
            HttpContext.Current.Response.BinaryWrite(pck.GetAsByteArray());
            HttpContext.Current.Response.End();
        }
    }

    public bool IsReusable
    {
        get
        {
            return false;
        }
    }

}