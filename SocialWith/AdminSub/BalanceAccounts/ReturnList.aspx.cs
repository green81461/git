using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using SocialWith.Biz.Comm;
using SocialWith.Biz.ReturnChange;
using Urian.Core;
using OfficeOpenXml;
using OfficeOpenXml.Style;
using SocialWith.Biz.Excel;
using System.Data;
using System.Drawing;

public partial class AdminSub_BalanceAccounts_ReturnList : AdminSubPageBase
{
    CommService commService = new CommService();
    ReturnChangeService rgServive = new ReturnChangeService();
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            DefaultDataBind();
        }
    }

    #region <<파라미터 Get>>
    protected void ParseRequestParameters()
    {
    }

    #endregion

    #region <<데이터바인드>>
    protected void DefaultDataBind()
    {
        txtSearchEdate.Text = DateTime.Now.ToString("yyyy-MM-dd");
        txtSearchSdate.Text = DateTime.Now.AddDays(-7).ToString("yyyy-MM-dd");
        OrderStatusDataBind();
    }


    protected void OrderStatusDataBind()
    {

        var paramList = new Dictionary<string, object>
        {
            { "nvar_P_MAPCODE", "PAY"},
            { "nume_P_MAPCHANEL", 3},
        };

        var list = commService.GetCommList(paramList);


        if ((list != null) && (list.Count > 0))
        {
            foreach (var item in list)
            {
                // if (item.Map_Type != 0 && item.Map_Type >= 505 && item.Map_Type <= 508)
                if (item.Map_Type != 0)
                {
                  
                    ddlReturnStatus.Items.Add(new ListItem(item.Map_Name, item.Map_Type.AsText()));
                }
            }
        }
    }


    #endregion

    #region 

    // 엑셀저장
    protected void btnRtnExcel_Click(object sender, ImageClickEventArgs e)
    {
        ExcelService excelService = new ExcelService();
        var paramList = new Dictionary<string, object>
        {
            {"nvar_P_SVID_USER",  Svid_User },
            {"nvar_P_TODATEB",  txtSearchSdate.Text },
            {"nvar_P_TODATEE", txtSearchEdate.Text },
            {"nvar_P_ORDERSTATUS", ddlReturnStatus.SelectedValue },
            {"nvar_P_BUYCOMPNAME", txtBuySaleName.Value.Trim() }
        };

        var table = excelService.GetReturnJungExcelExport(paramList);
        table.Columns.Add("TOTALJUNG", typeof(decimal));

        for (int rowIndex = 0; rowIndex < table.Rows.Count; rowIndex++)
        {
            table.Rows[rowIndex]["TOTALJUNG"] = table.Rows[rowIndex]["SALEAMT"].AsDecimalNullable(0) - table.Rows[rowIndex]["CUSTAMT"].AsDecimalNullable(0) - table.Rows[rowIndex]["PGJUNG"].AsDecimalNullable(0) - table.Rows[rowIndex]["DELIVERYJUNG"].AsDecimalNullable(0) - table.Rows[rowIndex]["SUPPLYJUNG"].AsDecimalNullable(0) - table.Rows[rowIndex]["BILLJUNG"].AsDecimalNullable(0);
            table.Rows[rowIndex]["GOODSFINALNAME"] = "[" + table.Rows[rowIndex]["BRANDNAME"] + "]" + table.Rows[rowIndex]["GOODSFINALNAME"] + "\n" + table.Rows[rowIndex]["GOODSOPTIONSUMMARYVALUES"];
        }
        table.Columns.Remove("BRANDNAME");
        table.Columns.Remove("GOODSOPTIONSUMMARYVALUES");
        var fileName = Server.UrlEncode(UserId + "_반품정산내역");
        string[] headerName = { "번호", "출금날짜", "반품일자", "반품번호", "구매사", "신청자", "상품코드", "주문상품정보", "수량", "모델명", "내용량", "구매사 반품정산", "결제수단", "판매사 반품정산", "플랫폼 이용 수수료", "배송비 수수료", "세금계산서 수수료정산", "PG수수료정산", "반품대금정산" };
        ExportExcel(fileName, headerName, table);
    }

    public void ExportExcel(string fileName, string[] headerNames, DataTable table)
    {


        using (ExcelPackage pck = new ExcelPackage())
        {
            //Create the worksheet
            ExcelWorksheet ws = pck.Workbook.Worksheets.Add("반품정산내역조회");


            int headerIndex = 0;
            int colCount = 19;
            foreach (string name in headerNames)
            {

                ws.Cells[5, headerIndex + 1].Value = name;
                headerIndex++;

            }

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

            //Format the Title
            using (ExcelRange rng = ws.Cells[2, 5, 3, 14])
            {
                rng.Value = "반품정산내역";
                rng.Merge = true;
                rng.Style.HorizontalAlignment = ExcelHorizontalAlignment.Center;
                rng.Style.VerticalAlignment = ExcelVerticalAlignment.Center;
                rng.Style.Font.Bold = true;
                rng.Style.Border.Top.Style = ExcelBorderStyle.Medium;
                rng.Style.Border.Left.Style = ExcelBorderStyle.Medium;
                rng.Style.Border.Right.Style = ExcelBorderStyle.Medium;
                rng.Style.Border.Bottom.Style = ExcelBorderStyle.Medium;

            }

            if (table.Rows.Count > 0)
            {
                ws.Cells["A6"].LoadFromDataTable(table, false);
                ws.Cells[6, 8, table.Rows.Count + 5, 8].Style.WrapText = true;
                ws.Cells[6, 2, table.Rows.Count + 5, 3].Style.Numberformat.Format = "yyyy-MM-dd";
                ws.Cells[6, 14, table.Rows.Count + 5, 19].Style.Numberformat.Format = "#,###원";
                ws.Cells[6, 9, table.Rows.Count + 5, 9].Style.Numberformat.Format = "#,###";
                ws.Cells[6, 12, table.Rows.Count + 5, 12].Style.Numberformat.Format = "#,###원";




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
                ExcelRange columnCells = ws.Cells[6, 8, table.Rows.Count + 5, 8];
                int maxLength = columnCells.Max(cell => cell.Value.ToString().Count(c => char.IsLetterOrDigit(c)));
                ws.Column(8).Width = maxLength + 20; // 2 is just an extra buffer for all that is not letter/digits.

            }
            //Write it back to the client
            Response.ContentType = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet";
            Response.AddHeader("content-disposition", "attachment;  filename=" + fileName + ".xlsx");
            Response.BinaryWrite(pck.GetAsByteArray());
            Response.End();
        }
    }
    #endregion

}