using Oracle.ManagedDataAccess.Client;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.OleDb;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using SocialWith.Biz.Goods;
using OfficeOpenXml;
using OfficeOpenXml.Style;
using SocialWith.Biz.Excel;
using System.Drawing;
public partial class Admin_Goods_RMPPriceManagement : AdminPageBase
{
    protected void Page_Load(object sender, EventArgs e)
    {

    }

    public void ExportExcel(string fileName, string[] headerNames, DataTable table)
    {


        using (ExcelPackage pck = new ExcelPackage())
        {
            //Create the worksheet
            ExcelWorksheet ws = pck.Workbook.Worksheets.Add("RMP가격관리");
            int headerIndex = 0;
            int colCount = 11; //11열
            //Format the header
            using (ExcelRange rng = ws.Cells[5, 1, 6, colCount]) //제목 5번째부터 6번째까지
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
            //5,6번 셀 병합
            ws.Cells[5, 1, 6, 1].Merge = true;
            ws.Cells[5, 2, 6, 2].Merge = true;
            ws.Cells[5, 3, 6, 3].Merge = true;
            ws.Cells[5, 4, 6, 4].Merge = true;
            ws.Cells[5, 5, 6, 5].Merge = true;
           
            ws.Cells[5, 6, 5, 7].Merge = true; //옆으로 병합
            ws.Cells[5, 6, 5, 7].Value = "소셜위드 기준";
            ws.Cells[5, 8, 5, 9].Merge = true;
            ws.Cells[5, 8, 5, 9].Value = "RMP 기준";

            ws.Cells[5, 10, 6, 10].Merge = true;
            ws.Cells[5, 11, 6, 11].Merge = true;
            
            foreach (string name in headerNames) //병합으로 인한 출력 위치
            {
                if (headerIndex > 4 && headerIndex < 9)
                {
                   ws.Cells[6, headerIndex+1].Value = name;
                }
                else
                {
                   ws.Cells[5, headerIndex+1].Value = name;
                 }
                headerIndex++;
            }


            //Format the Title
            using (ExcelRange rng = ws.Cells[2, 1, 3, colCount])
            {

                this.excelKeyword.Value = Request[this.excelKeyword.UniqueID];
                this.excelTarget.Value = Request[this.excelTarget.UniqueID];
            
                rng.Value = "RMP 가격관리";
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
                ws.Cells["A7"].LoadFromDataTable(table, false); //a7셀부터 뿌려주기 

                //7번째 부터 시작
                ws.Cells[7, 4, table.Rows.Count + 6, 5].Style.Numberformat.Format = "yyyy-MM-dd";
                ws.Cells[7, 10, table.Rows.Count + 6, 10].Style.Numberformat.Format = "yyyy-MM-dd";

                    //Format the data
                using (ExcelRange rng = ws.Cells[7, 1, table.Rows.Count + 6, colCount])
                {
                    rng.Style.HorizontalAlignment = ExcelHorizontalAlignment.Center;
                    rng.Style.VerticalAlignment = ExcelVerticalAlignment.Center;
                    rng.Style.Border.Top.Style = ExcelBorderStyle.Thin;
                    rng.Style.Border.Left.Style = ExcelBorderStyle.Thin;
                    rng.Style.Border.Right.Style = ExcelBorderStyle.Thin;
                    rng.Style.Border.Bottom.Style = ExcelBorderStyle.Thin;

                }

                //셀 사이즈 오토 세팅
                using (ExcelRange rng = ws.Cells[6, 1, table.Rows.Count + 6, colCount])
                {
                    rng.AutoFitColumns();
                }
                //Height
                for (int i = 5; i <= table.Rows.Count + 5; i++) 
                {
                    ws.Row(i + 1).Height = 36;
                }

                ws.Column(2).Width = 15;
                ws.Column(6).Width = 20;
                ws.Column(7).Width = 20;
                ws.Column(8).Width = 20;
                ws.Column(9).Width = 20;
                ws.Column(10).Width = 15;
                ws.Column(11).Width = 15;
                ws.Row(5).Height = 20;
                ws.Row(6).Height = 20;
            }
            //Write it back to the client
            Response.ContentType = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet";
            Response.AddHeader("content-disposition", "attachment;  filename=" + fileName + ".xlsx");
            Response.BinaryWrite(pck.GetAsByteArray());
            Response.End();
        }
    }


    protected void btnExcelDownLoad_Click(object sender, EventArgs e)
    {

        this.excelTarget.Value = Request[this.excelTarget.UniqueID];
        this.excelKeyword.Value = Request[this.excelKeyword.UniqueID];
        
        ExcelService excelService = new ExcelService();
        var param = new Dictionary<string, object> {

            { "nvar_P_SERACHTARGET", excelTarget.Value.Trim()},
            { "nvar_P_SEARCHKEYWORD", excelKeyword.Value.Trim()},
        };

        var table = excelService.GetRmpPriceListExcel(param);

        string[] headerName = { "순번", "RMP 회사코드", "RMP 회사명", "시작일", "종료일", "소셜위드 가격(%)", "RMP 가격(%)", "RMP 가격(%)", "판매사 가격(%)","RMP 등록날짜","사용유무" };
        var fileName = Server.UrlEncode(AdminId + "_RMP가격관리");
        ExportExcel(fileName, headerName, table);

    }

}