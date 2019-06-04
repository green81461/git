using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using SocialWith.Biz.Order;
using SocialWith.Biz.Comm;
using Urian.Core;
using OfficeOpenXml;
using OfficeOpenXml.Style;
using System.Data;
using System.Drawing;
using SocialWith.Biz.Excel;

public partial class Admin_Order_OrderCancelList : AdminPageBase
{
    OrderService OrderService = new OrderService();
    CommService commService = new CommService();
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
        txtSearchSdate.Text = DateTime.Now.AddDays(-1).ToString("yyyy-MM-dd");
        txtSearchEdate.Text = DateTime.Now.ToString("yyyy-MM-dd");
        OrderStatusDataBind();
        PayWayBind();
    }


    protected void OrderStatusDataBind()
    {

        var paramList = new Dictionary<string, object>
        {
            { "nvar_P_MAPCODE", "ORDER"},
            { "nume_P_MAPCHANEL", 2},
        };

        var list = commService.GetCommList(paramList);


        if ((list != null) && (list.Count > 0))
        {
            foreach (var item in list)
            {
                if (item.Map_Type != 0 && item.Map_Type >= 400 && item.Map_Type <= 431)
                {
                    ddlAsStatus.Items.Add(new ListItem(item.Map_Name, item.Map_Type.AsText()));
                }
            }
        }
    }

    protected void PayWayBind()
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
                if (item.Map_Type != 0)
                {
                    ddlPay.Items.Add(new ListItem(item.Map_Name, item.Map_Type.AsText()));

                }
            }
        }
    }


    #endregion


    protected void btnExcelExport_Click(object sender, EventArgs e)
    {
        var procParam = new Dictionary<string, object>{


            {"nvar_P_TODATEB",  txtSearchSdate.Text },
            {"nvar_P_TODATEE", txtSearchEdate.Text },
            {"nvar_P_PAYWAY", ddlPay.SelectedValue },
            {"nvar_P_STATUS", ddlAsStatus.SelectedValue },
            {"nvar_P_BUYCOMPANY", txtBuySaleName.Text.Trim() },
            {"nvar_P_SALECOMPANY", txtSaleCompanyName.Text.Trim() },
        };

        ExcelService excelService = new ExcelService();
        var table = excelService.GetAdminOrderCancelHistoryExcel(procParam);
        for (int rowIndex = 0; rowIndex < table.Rows.Count; rowIndex++)
        {
            table.Rows[rowIndex]["GOODSFINALNAME"] = "[" + table.Rows[rowIndex]["BRANDNAME"] + "]" + table.Rows[rowIndex]["GOODSFINALNAME"] + "\n" + table.Rows[rowIndex]["GOODSOPTIONSUMMARYVALUES"];
        }
        table.Columns.Remove("BRANDNAME");
        table.Columns.Remove("GOODSOPTIONSUMMARYVALUES");
        var fileName = Server.UrlEncode(AdminId + "_주문취소내역");
        //string[] headerName = { "구분", "주문취소일자", "주문취소번호", "구매사", "주문자", "요청자", "판매사", "예산부서", "예산금액", "주문일자", "주문번호", "상품코드", "주문상품정보", "모델명", "내용량", "상품금액", "취소수량", "취소금액", "취소사유", "결제수단" };
        string[] headerName = { "구분", "주문취소일자", "주문취소번호", "구매사", "주문자", "판매사", "주문일자", "주문번호", "상품코드", "주문상품정보", "모델명", "내용량", "상품금액", "취소수량", "취소금액", "취소사유", "결제수단" };
        // ExeclExport.ExportExcel(fileName, "xlsx", list);
        ExportExcel(fileName, headerName, table);
    }

    public void ExportExcel(string fileName, string[] headerNames, DataTable table)
    {


        using (ExcelPackage pck = new ExcelPackage())
        {
            //Create the worksheet
            ExcelWorksheet ws = pck.Workbook.Worksheets.Add("주문취소조회");


            int headerIndex = 0;
            int colCount = 17;
            foreach (string name in headerNames)
            {

                ws.Cells[5, headerIndex + 1].Value = name;
                headerIndex++;

            }

            //Format the Title
            using (ExcelRange rng = ws.Cells[2, 5, 3, 13])
            {
                rng.Value = "주문취소조회";
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

                ws.Cells[6, 10, table.Rows.Count + 5, 10].Style.WrapText = true;
                ws.Cells[6, 2, table.Rows.Count + 5, 2].Style.Numberformat.Format = "yyyy-MM-dd";
                ws.Cells[6, 7, table.Rows.Count + 5, 7].Style.Numberformat.Format = "yyyy-MM-dd";
                ws.Cells[6, 13, table.Rows.Count + 5, 13].Style.Numberformat.Format = "#,###원";
                ws.Cells[6, 15, table.Rows.Count + 5, 15].Style.Numberformat.Format = "#,###원";
                ws.Cells[6, 14, table.Rows.Count + 5, 14].Style.Numberformat.Format = "#,###";


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
                ExcelRange columnCells = ws.Cells[6, 10, table.Rows.Count + 5, 10];
                int maxLength = columnCells.Max(cell => cell.Value.ToString().Count(c => char.IsLetterOrDigit(c)));
                ws.Column(10).Width = maxLength + 20; // 2 is just an extra buffer for all that is not letter/digits.
            }




            //Write it back to the client
            Response.ContentType = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet";
            Response.AddHeader("content-disposition", "attachment;  filename=" + fileName + ".xlsx");
            Response.BinaryWrite(pck.GetAsByteArray());
            Response.End();
        }
    }

    
}