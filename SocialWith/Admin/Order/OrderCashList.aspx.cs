﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using SocialWith.Biz.Comm;
using Urian.Core;
using OfficeOpenXml;
using OfficeOpenXml.Style;
using System.ComponentModel.DataAnnotations;
using System.Drawing;
using System.Reflection;
using SocialWith.Biz.Pay;
using System.Data;
using SocialWith.Biz.Excel;

public partial class Admin_Order_OrderCashList : AdminPageBase
{
    CommService CommService = new CommService();
    PayService payService = new PayService();

    protected void Page_Load(object sender, EventArgs e)
    {
        DefaultValueSet();
    }
    protected void DefaultValueSet()
    {
        txtSearchEdate.Text = DateTime.Now.ToString("yyyy-MM-dd");
        txtSearchSdate.Text = DateTime.Now.AddDays(-1).ToString("yyyy-MM-dd");

        var paramList = new Dictionary<string, object>
        {
            { "nvar_P_MAPCODE", "PAY"},
            { "nume_P_MAPCHANEL", 3},
        };


        //결제방법 리스트 바인딩
        var list = CommService.GetCommList(paramList);

        if ((list != null) && (list.Count > 0))
        {
            foreach (var item in list)
            {
                if (item.Map_Type != 0 && (item.Map_Type == 3 || item.Map_Type == 4))
                {
                    ddlSelectPayway.Items.Add(new ListItem(item.Map_Name, item.Map_Type.AsText()));
                }
            }
        }
    }
    

    protected void ExportExcel(string fileName, string[] headerNames, DataTable table)
    {


        using (ExcelPackage pck = new ExcelPackage())
        {
            //Create the worksheet
            ExcelWorksheet ws = pck.Workbook.Worksheets.Add("입금내역현황");

            //Format the Title
            using (ExcelRange rng = ws.Cells[2, 4, 3, 11])
            {
                rng.Value = "입금내역현황";
                rng.Merge = true;
                rng.Style.HorizontalAlignment = ExcelHorizontalAlignment.Center;
                rng.Style.VerticalAlignment = ExcelVerticalAlignment.Center;
                rng.Style.Font.Bold = true;
                rng.Style.Border.Top.Style = ExcelBorderStyle.Medium;
                rng.Style.Border.Left.Style = ExcelBorderStyle.Medium;
                rng.Style.Border.Right.Style = ExcelBorderStyle.Medium;
                rng.Style.Border.Bottom.Style = ExcelBorderStyle.Medium;

            }

            int headerIndex = 0;
            int colCount = 16;
            foreach (string name in headerNames)
            {

                ws.Cells[5, headerIndex + 1].Value = name;
                headerIndex++;

            }

            //populate our Data
            if (table.Rows.Count > 0)
            {
                ws.Cells["A6"].LoadFromDataTable(table, false);


                ws.Cells[6, 2, table.Rows.Count + 5, 2].Style.Numberformat.Format = "yyyy-MM-dd";
                ws.Cells[6, 13, table.Rows.Count + 5, 13].Style.Numberformat.Format = "yyyy-MM-dd";
                ws.Cells[6, 16, table.Rows.Count + 5, 16].Style.Numberformat.Format = "yyyy-MM-dd";
                ws.Cells[6, 9, table.Rows.Count + 5, 9].Style.Numberformat.Format = "#,###";
                ws.Cells[6, 8, table.Rows.Count + 5, 8].Style.Numberformat.Format = "#,###원";


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
                //ExcelRange columnCells = ws.Cells[2, 8, list.Count() + 1, 8];
                //int maxLength = columnCells.Max(cell => cell.Value.ToString().Count(c => char.IsLetterOrDigit(c)));
                //ws.Column(8).Width = maxLength + 20; // 2 is just an extra buffer for all that is not letter/digits.
            }




            //Write it back to the client
            Response.ContentType = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet";
            Response.AddHeader("content-disposition", "attachment;  filename=" + fileName + ".xlsx");
            Response.BinaryWrite(pck.GetAsByteArray());
            Response.End();
        }
    }

    protected void btnExcelExport_Click(object sender, EventArgs e)
    {
        this.txtSearchSdate.Text = Request[this.txtSearchSdate.UniqueID];
        this.txtSearchEdate.Text = Request[this.txtSearchEdate.UniqueID];
        ExcelService excelService = new ExcelService();
        var paramList = new Dictionary<string, object>
        {
            { "nvar_P_SVID_USER", ""},
            { "nvar_P_STARTDATE", txtSearchSdate.Text.Trim()},
            { "nvar_P_ENDDATE", txtSearchEdate.Text.Trim()},
            { "nvar_P_SVID_COMPANYNO", ""},
            { "nvar_P_SALECOMPANY_NAME", txtSaleCompName.Text.Trim()},
            { "nvar_P_BUYERCOMPANY_NAME", txtBuyerCompName.Text.Trim()},
            { "nvar_P_PAYWAY", ddlSelectPayway.SelectedValue.Trim()},
             { "nvar_P_PAYCASH", ddlPayCash.SelectedValue.Trim()},
        };

        var table = excelService.GetAdminCashListExcel(paramList);
        for (int rowIndex = 0; rowIndex < table.Rows.Count; rowIndex++)
        {
            table.Rows[rowIndex]["ISCONFIRM"] = table.Rows[rowIndex]["ISCONFIRM"].AsText() == "Y" ? "확인" : "미확인";
            table.Rows[rowIndex]["PAYCASHCONFIRM"] = table.Rows[rowIndex]["PAYCASHCONFIRM"].AsText() == "Y" ? "입금완료" : "입금전";
        }
        var fileName = Server.UrlEncode(AdminId + "_입금내역현황");
        string[] headerName = { "번호", "주문날짜", "주문번호", "구매사", "구매자", "판매사", "상품명", "결제금액", "수량", "결제수단", "결과내용", "입금진행현황", "입금날짜", "입금확인여부", "입금확인자", "입금확인일자" };
        ExportExcel(fileName, headerName, table);
    }
}