using OfficeOpenXml;
using OfficeOpenXml.Style;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Reflection;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using SocialWith.Biz.Comm;
using SocialWith.Biz.Excel;
using SocialWith.Biz.Order;
using Urian.Core;
using SocialWith.Data;

public partial class AdminSub_Order_OrderHistoryList : AdminSubPageBase
{
    CommService commService = new CommService();
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            DefaultDataBind();
        }
       
    }

    #region <<데이터바인드>>
    protected void DefaultDataBind()
    {
        txtSearchSdate.Text = DateTime.Now.AddDays(-1).ToString("yyyy-MM-dd");
        txtSearchEdate.Text = DateTime.Now.ToString("yyyy-MM-dd");
        OrderStatusDataBind();
        PayWayDataBind();
    }

    protected void OrderStatusDataBind()
    {
        var paramList = new Dictionary<string, object>
        {
            { "nvar_P_MAPCODE", "ORDER"},
            { "nume_P_MAPCHANEL", 2},
        };

        var list = commService.GetCommList(paramList);
        ddlOrderStatus.Items.Add(new ListItem("---전체---", "ALL"));

        if ((list != null) && (list.Count > 0))
        {
            foreach (var item in list)
            {
                if ((item.Map_Type != 0) && (item.Map_Type < 500) && (item.Map_Type != 431)) //주문취소실패는 안 보이게 수정함.
                {
                    if ((item.Map_Type == 100) || (item.Map_Type == 200) || (item.Map_Type == 301) || (item.Map_Type == 302) || (item.Map_Type == 400) || (item.Map_Type == 421) || (item.Map_Type == 422))
                    {
                        ddlOrderStatus.Items.Add(new ListItem(item.Map_Name, item.Map_Type.AsText()));
                    }
                }
            }
        }
    }

    protected void PayWayDataBind()
    {
        var paramList = new Dictionary<string, object>
        {
            { "nvar_P_MAPCODE", "PAY"},
            { "nume_P_MAPCHANEL", 3},
        };

        var list = commService.GetCommList(paramList);

        ddlPayWay.Items.Add(new ListItem("---전체---", "ALL"));
        if ((list != null) && (list.Count > 0))
        {
            foreach (var item in list)
            {
                if (item.Map_Type != 0)
                {
                    ddlPayWay.Items.Add(new ListItem(item.Map_Name, item.Map_Type.AsText()));
                }
            }
        }
    }

    #endregion



    protected void btnOrdHistoryExcel_Click(object sender, ImageClickEventArgs e)
    {

        this.txtSearchSdate.Text = Request[this.txtSearchSdate.UniqueID];
        this.txtSearchEdate.Text = Request[this.txtSearchEdate.UniqueID];

        ExcelService excelService = new ExcelService();
        var param = new Dictionary<string, object> {
            { "nvar_P_SVID_USER", Svid_User},
            { "nvar_P_ORDERSTATUS", ddlOrderStatus.SelectedValue},
            { "nvar_P_PAYWAY", ddlPayWay.SelectedValue},
            { "nvar_P_TODATEB", txtSearchSdate.Text.Trim()},
            { "nvar_P_TODATEE", txtSearchEdate.Text.Trim()},
        };

        var table = excelService.GetExcelAdminSubOrderHistoryList(param);
        for (int rowIndex = 0; rowIndex < table.Rows.Count; rowIndex++)
        {
            table.Rows[rowIndex]["GOODSFINALNAME"] = "[" + table.Rows[rowIndex]["BRANDNAME"] + "]" + table.Rows[rowIndex]["GOODSFINALNAME"] + "\n" + table.Rows[rowIndex]["GOODSOPTIONSUMMARYVALUES"];
        }
        table.Columns.Remove("BRANDNAME");
        table.Columns.Remove("GOODSOPTIONSUMMARYVALUES");
        string[] headerName = { "번호", "주문일자", "주문번호", "구매사","상품코드", "주문상품정보", "모델명", "내용량", "상품단가(VAT포함)", "수량", "주문금액(VAT포함)", "출하예정일", "배송완료일", "주문처리현황", "결제수단" };
        var fileName = Server.UrlEncode(UserId + "_주문내역");
        ExportExcel(fileName, headerName, table);
    }




    public void ExportExcel(string fileName, string[] headerNames, DataTable table)
    {


        using (ExcelPackage pck = new ExcelPackage())
        {
            //Create the worksheet
            ExcelWorksheet ws = pck.Workbook.Worksheets.Add("주문내역조회");
            

            int headerIndex = 0;
            foreach (string name in headerNames)
            {

                ws.Cells[5, headerIndex + 1].Value = name;
                headerIndex++;

            }

            //Format the Title
            using (ExcelRange rng = ws.Cells[2, 5, 3, 11])
            {
                rng.Value = "주문내역조회";
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

                ws.Cells[6, 6, table.Rows.Count + 5, 6].Style.WrapText = true;
                ws.Cells[6, 2, table.Rows.Count + 5, 2].Style.Numberformat.Format = "yyyy-MM-dd";
                ws.Cells[6, 9, table.Rows.Count + 5, 9].Style.Numberformat.Format = "#,###원";
                ws.Cells[6, 10, table.Rows.Count + 5, 10].Style.Numberformat.Format = "#,###";
                ws.Cells[6, 11, table.Rows.Count + 5, 11].Style.Numberformat.Format = "#,###원";


                //Format the header
                using (ExcelRange rng = ws.Cells[5, 1, 5, 15])
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
                using (ExcelRange rng = ws.Cells[6, 1, table.Rows.Count + 5, 15])
                {
                    rng.Style.HorizontalAlignment = ExcelHorizontalAlignment.Center;
                    rng.Style.VerticalAlignment = ExcelVerticalAlignment.Center;
                    rng.Style.Border.Top.Style = ExcelBorderStyle.Thin;
                    rng.Style.Border.Left.Style = ExcelBorderStyle.Thin;
                    rng.Style.Border.Right.Style = ExcelBorderStyle.Thin;
                    rng.Style.Border.Bottom.Style = ExcelBorderStyle.Thin;
                        
                }

                //셀 사이즈 오토 세팅
                using (ExcelRange rng = ws.Cells[5, 1, table.Rows.Count + 5, 15])
                {
                    rng.AutoFitColumns();
                }

                for (int i = 5; i <= table.Rows.Count+4; i++)
                {
                    ws.Row(i + 1).Height = 36;
                }

                //상품정보 Cell Width세팅 (Wraptext가 true로 설정되있으면 AutoFitColumns이 안먹는다...)
                ExcelRange columnCells = ws.Cells[6, 6, table.Rows.Count + 5, 6];
                int maxLength = columnCells.Max(cell => cell.Value.ToString().Count(c => char.IsLetterOrDigit(c)));
                ws.Column(6).Width = maxLength + 20; // 2 is just an extra buffer for all that is not letter/digits.
            }
            



            //Write it back to the client
            Response.ContentType = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet";
            Response.AddHeader("content-disposition", "attachment;  filename=" + fileName + ".xlsx");
            Response.BinaryWrite(pck.GetAsByteArray());
            Response.End();
        }
    }

}