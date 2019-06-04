using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using SocialWith.Biz.Pay;
using Urian.Core;
using OfficeOpenXml;
using OfficeOpenXml.Style;
using System.ComponentModel.DataAnnotations;
using System.Drawing;
using System.Reflection;
using System.Data;

public partial class Order_QuickOrderMain : PageBase
{
    PayService payService = new PayService();
    protected string  vatTag = "포함";

    protected void Page_PreInit(Object sender, EventArgs e)
    {
        string masterPageUrl = CommonHelper.GetMasterPageUrl(DistCssObject); //마스터페이지 세팅
        MasterPageFile = masterPageUrl;
    }


    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            DefaultDataBind();
            GetPayStatus();
        }
    }


    protected void DefaultDataBind()
    {

        if (UserInfoObject.UserInfo.FreeCompanyVATYN.AsText("N") == "N")
        {
            vatTag = "별도";
        }

        if ((UserInfoObject.Svid_Role == "A1") || (UserInfoObject.Svid_Role == "B1") || (UserInfoObject.Svid_Role == "C2") || (UserInfoObject.Svid_Role == "BC2"))
        {
            btnCart.Visible = true;
            if (UserInfoObject.UserInfo.BPestimateCompareYN.AsText("N") == "N")
            {
                btnOrder.Visible = true;
            }
            
        }
        else
        {
            btnCart.Visible = true;
        }
    }

    protected void GetPayStatus()
    {

        var paramList = new Dictionary<string, object> {
            {"nvar_P_SVID_USER", Svid_User },
        };

        var info = payService.GetCurrentPayStatus(paramList);
        var value = string.Empty;
        if (!string.IsNullOrWhiteSpace(info))
        {
            value = info.AsDecimal().ToString("#,###");
        }
        else
        {
            value = "0";
        }

        
        lblPayStatus.Text = DateTime.Now.Month + "월 총 주문금액(VAT"+ vatTag + ") : " + value + "원";
    }

    ///// 엑셀 기능 작업중...............
    #region << 엑셀 파일 저장 >>
    //protected void btnQuickOrdExcel_Click(object sender, ImageClickEventArgs e)
    //{
    //    var tmpVal = hfList.Value.AsText();
    //    var dataArr = tmpVal.Split('|');
    //    var gdsCodeArr = dataArr[0].AsText();
    //    var gdsQtyArr = dataArr[1].AsText();
       

    //    var gdsCodeList = gdsCodeArr.Substring(0, gdsCodeArr.Length-1);

    //    var codeList = gdsCodeList.Split(',');
    //    var qtyList = gdsQtyArr.Split(',');
    //    string compCode = string.Empty;
    //    string freeCompYN = string.Empty;
    //    string freeCompVatYN = string.Empty;
    //    if (UserInfoObject != null && UserInfoObject.UserInfo != null)
    //    {
    //        compCode = UserInfoObject.UserInfo.Company_Code;
    //        freeCompYN = UserInfoObject.UserInfo.FreeCompanyYN;
    //        freeCompVatYN = UserInfoObject.UserInfo.FreeCompanyVATYN.AsText("N");
    //    }
    //    else
    //    {
    //        compCode = "EMPTY";
    //    }
    //    // SocialWith.Biz.Order.OrderService orderService = new SocialWith.Biz.Order.OrderService();
    //    SocialWith.Biz.Excel.ExcelService excelService = new SocialWith.Biz.Excel.ExcelService();
    //    var paramList = new Dictionary<string, object>() {
    //             {"nvar_P_GOODSCODE_ARR", gdsCodeList},
    //             {"nvar_P_COMPCODE", compCode},
    //             {"nvar_P_BDONGSHINCHECK",  UserInfoObject.UserInfo.BdongshinCheck.AsText("N")},
    //             {"nvar_P_FREECOMPANYYN", freeCompYN },
    //             {"nvar_P_FREECOMPANYVATYN", freeCompVatYN},
    //             {"nvar_P_SVID_USER", Svid_User},
    //    };
    //    //var goodsList = orderService.GetExcelQuickOrderList(paramList);
    //    var table = excelService.GetExcelQuickOrderList(paramList);
    //    table.Columns.Add("QTY", typeof(int));
    //    table.Columns.Add("GOODSTOTALSALEPRICEVAT", typeof(decimal));
    //    for (int rowIndex = 0; rowIndex < table.Rows.Count; rowIndex++)
    //    {
    //        table.Rows[rowIndex]["GOODSFINALNAME"] = "[" + table.Rows[rowIndex]["BRANDNAME"] + "]" + table.Rows[rowIndex]["GOODSFINALNAME"] + "\n" + table.Rows[rowIndex]["GOODSOPTIONSUMMARYVALUES"];
    //    }
    //    table.Columns.Remove("BRANDNAME");
    //    table.Columns.Remove("GOODSOPTIONSUMMARYVALUES");
    //    string[] headerName = { "번호",  "상품코드", "상품정보", "모델명",  "출하예정일", "최소수량","내용량", "상품가격(VAT" + vatTag + ")", "수량", "총금액(VAT" + vatTag + ")" };
    //    if (table.Rows.Count >0)
    //    {
    //        for (int i = 0; i < table.Rows.Count; i++)
    //        {
    //            for (int j = 0; j < codeList.Length; j++)
    //            {
    //                if (table.Rows[i]["GOODSCODE"].Equals(codeList[j].AsText()))
    //                {
    //                    table.Rows[i]["QTY"] = Int32.Parse(qtyList[j].AsText());

    //                    var gdsSalePriceVat = Int32.Parse(table.Rows[i]["GOODSSALEPRICEVAT"].AsText("0"));
    //                    var totPriceVat = gdsSalePriceVat * table.Rows[i]["QTY"].AsDecimal(0);

    //                    // goodsList[i].GoodsSalePriceVat = string.Format("{0:#,###}", gdsSalePriceVat).AsText();
    //                    table.Rows[i]["GOODSTOTALSALEPRICEVAT"] = totPriceVat;
    //                }
    //            }
    //        }
    //    }
    //    var fileName = Server.UrlEncode(UserId + "_간편주문내역");
    //    ExportExcel(fileName, headerName, table);
    //   // ExeclExport.ExportExcel(fileName, "xlsx", goodsList);
    //}

    public void ExportExcel(string fileName, string[] headerNames, DataTable table)
    {

        int colCount = 10;
        using (ExcelPackage pck = new ExcelPackage())
        {
            //Create the worksheet
            ExcelWorksheet ws = pck.Workbook.Worksheets.Add("간편주문내역");

            //Format the Title
            using (ExcelRange rng = ws.Cells[2, 1, 3, colCount])
            {
                rng.Value = "간편주문내역조회";
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

            int headerIndex = 0;

            foreach (string name in headerNames)
            {

                ws.Cells[5, headerIndex + 1].Value = name;
                headerIndex++;

            }

            //populate our Data
            if (table.Rows.Count > 0)
            {
                ws.Cells["A6"].LoadFromDataTable(table,false);

                ws.Cells[6, 3, table.Rows.Count + 5, 3].Style.WrapText = true;
                ws.Cells[6, 8, table.Rows.Count + 5, 8].Style.Numberformat.Format = "#,###0원";
                ws.Cells[6, 10, table.Rows.Count + 5, 10].Style.Numberformat.Format = "#,###0원";


                //Format the header
                using (ExcelRange rng = ws.Cells[5, 1, 5, colCount])
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
                    ws.Row(i + 1).Height = 36;
                }

                //상품정보 Cell Width세팅 (Wraptext가 true로 설정되있으면 AutoFitColumns이 안먹는다...)
                ExcelRange columnCells = ws.Cells[6, 3, table.Rows.Count + 5, 3];
                columnCells.Style.HorizontalAlignment = ExcelHorizontalAlignment.Left;
                int maxLength = columnCells.Max(cell => cell.Value.ToString().Count(c => char.IsLetterOrDigit(c)));
                ws.Column(3).Width = maxLength + 20; // 2 is just an extra buffer for all that is not letter/digits.
            }
            



            //Write it back to the client
            Response.ContentType = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet";
            Response.AddHeader("content-disposition", "attachment;  filename=" + fileName + ".xlsx");
            Response.BinaryWrite(pck.GetAsByteArray());
            Response.End();
        }
    }
    #endregion

    protected void btnQuickOrdExcel_Click(object sender, EventArgs e)
    {
        var tmpVal = hfList.Value.AsText();
        var dataArr = tmpVal.Split('|');
        var gdsCodeArr = dataArr[0].AsText();
        var gdsQtyArr = dataArr[1].AsText();


        var gdsCodeList = gdsCodeArr.Substring(0, gdsCodeArr.Length - 1);

        var codeList = gdsCodeList.Split(',');
        var qtyList = gdsQtyArr.Split(',');
        string compCode = string.Empty;
        string freeCompYN = string.Empty;
        string freeCompVatYN = string.Empty;
        if (UserInfoObject != null && UserInfoObject.UserInfo != null)
        {
            compCode = UserInfoObject.UserInfo.Company_Code;
            freeCompYN = UserInfoObject.UserInfo.FreeCompanyYN;
            freeCompVatYN = UserInfoObject.UserInfo.FreeCompanyVATYN.AsText("N");
        }
        else
        {
            compCode = "EMPTY";
        }
        // SocialWith.Biz.Order.OrderService orderService = new SocialWith.Biz.Order.OrderService();
        SocialWith.Biz.Excel.ExcelService excelService = new SocialWith.Biz.Excel.ExcelService();
        var paramList = new Dictionary<string, object>() {
                 {"nvar_P_GOODSCODE_ARR", gdsCodeList},
                 {"nvar_P_COMPCODE", compCode},
                 {"nvar_P_BDONGSHINCHECK",  UserInfoObject.UserInfo.BmroCheck.AsText("N")},
                 {"nvar_P_FREECOMPANYYN", freeCompYN },
                 {"nvar_P_FREECOMPANYVATYN", freeCompVatYN},
                 {"nvar_P_SVID_USER", Svid_User},
        };
        //var goodsList = orderService.GetExcelQuickOrderList(paramList);
        var table = excelService.GetExcelQuickOrderList(paramList);
        table.Columns.Add("QTY", typeof(int));
        table.Columns.Add("GOODSTOTALSALEPRICEVAT", typeof(decimal));
        for (int rowIndex = 0; rowIndex < table.Rows.Count; rowIndex++)
        {
            table.Rows[rowIndex]["GOODSFINALNAME"] = "[" + table.Rows[rowIndex]["BRANDNAME"] + "]" + table.Rows[rowIndex]["GOODSFINALNAME"] + "\n" + table.Rows[rowIndex]["GOODSOPTIONSUMMARYVALUES"];
        }
        table.Columns.Remove("BRANDNAME");
        table.Columns.Remove("GOODSOPTIONSUMMARYVALUES");
        string[] headerName = { "번호", "상품코드", "상품정보", "모델명", "출하예정일", "최소수량", "내용량", "상품가격(VAT" + vatTag + ")", "수량", "총금액(VAT" + vatTag + ")" };
        if (table.Rows.Count > 0)
        {
            for (int i = 0; i < table.Rows.Count; i++)
            {
                for (int j = 0; j < codeList.Length; j++)
                {
                    if (table.Rows[i]["GOODSCODE"].Equals(codeList[j].AsText()))
                    {
                        table.Rows[i]["QTY"] = Int32.Parse(qtyList[j].AsText());

                        var gdsSalePriceVat = Int32.Parse(table.Rows[i]["GOODSSALEPRICEVAT"].AsText("0"));
                        var totPriceVat = gdsSalePriceVat * table.Rows[i]["QTY"].AsDecimal(0);

                        // goodsList[i].GoodsSalePriceVat = string.Format("{0:#,###}", gdsSalePriceVat).AsText();
                        table.Rows[i]["GOODSTOTALSALEPRICEVAT"] = totPriceVat;
                    }
                }
            }
        }
        var fileName = Server.UrlEncode(UserId + "_간편주문내역");
        ExportExcel(fileName, headerName, table);
    }
}