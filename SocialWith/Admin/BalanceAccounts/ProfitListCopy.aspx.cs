using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Urian.Core;
using SocialWith.Biz.Excel;
using System.Data;
using OfficeOpenXml;
using OfficeOpenXml.Style;
using System.Drawing;

public partial class Admin_BalanceAccounts_ProfitList : AdminPageBase
{
    protected SocialWith.Biz.Comm.CommService CommService = new SocialWith.Biz.Comm.CommService();
    protected SocialWith.Biz.Pay.PayService PayService = new SocialWith.Biz.Pay.PayService();
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
                if (item.Map_Type != 0)
                {
                    ddlSelectPayway.Items.Add(new ListItem(item.Map_Name, item.Map_Type.AsText()));
                }
            }
        }
    }
    
    public void ExportExcel(string fileName, string[] headerNames, DataTable table)
    {
        using (ExcelPackage pck = new ExcelPackage())
        {
            ExcelWorksheet ws = pck.Workbook.Worksheets.Add("판매사 매출내역");
            int headerIndex = 0;
            int colCount = 17;

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

            foreach(string name in headerNames)
            {
                ws.Cells[5, headerIndex + 1].Value = name;
                headerIndex++;
            }

            //Format the Title
            using (ExcelRange rng = ws.Cells[2, 1, 3, colCount])
            {
                this.txtSearchSdate.Text = Request[this.txtSearchSdate.UniqueID];
                this.txtSearchEdate.Text = Request[this.txtSearchEdate.UniqueID];
                rng.Value = "  판매사 매출내역 (" + txtSearchSdate.Text.Trim() + " ~ " + txtSearchEdate.Text.Trim() + ")";
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

            if(table.Rows.Count > 0)
            {
                ws.Cells[5, 6, 5, 6].Style.WrapText = true;
                ws.Cells[5, 8, 5, 8].Style.WrapText = true;
                ws.Cells[5, 9, 5, 9].Style.WrapText = true;
                ws.Cells[5, 11, 5, 16].Style.WrapText = true;

                ws.Cells["A6"].LoadFromDataTable(table, false);
                
                ws.Cells[6, 2, table.Rows.Count + 5, 3].Style.Numberformat.Format = "yyyy-MM-dd";
                ws.Cells[6, 6, table.Rows.Count + 5, 6].Style.WrapText = true;
                ws.Cells[6, 8, table.Rows.Count + 5, 8].Style.WrapText = true;
                ws.Cells[6, 15, table.Rows.Count + 5, 16].Style.WrapText = true;
                ws.Cells[6, 10, table.Rows.Count + 5, 17].Style.Numberformat.Format = "#,###0원";

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
                
                for (int i = 5; i < table.Rows.Count + 5; i++)
                {
                    ws.Row(i+1).Height = 36;
                    
                    //취소주문건인 경우 글자색 바꿈
                    decimal saleAmt = table.Rows[i-5]["SALEAMT"].AsDecimal();
                    if(saleAmt == 0)
                    {
                        using (ExcelRange rng = ws.Cells[(i + 1), 16, (i + 1), 17])
                        {
                            rng.Style.Font.Color.SetColor(Color.Red); ;
                        }
                    }

                    //배송완료상품수와 총 주문상품수가 맞지 않는 경우 행 색칠
                    string deliveryStat = table.Rows[i - 5]["DELIVERYSTATUS"].AsText();
                    var splitStat = deliveryStat.Split(' ','-',' ');
                    int deliveryQty = splitStat[0].AsInt();
                    int cntQty = splitStat[2].AsInt();
                    
                    if (deliveryQty != cntQty)
                    {
                        using (ExcelRange rng = ws.Cells[(i + 1), 1, (i + 1), colCount])
                        {
                            rng.Style.Fill.PatternType = ExcelFillStyle.Solid;
                            rng.Style.Fill.BackgroundColor.SetColor(Color.FromArgb(255, 153, 153));
                        }
                    }
                }

                //상품정보 Cell Width세팅(Wraptext가 true로 설정되있으면 AutoFitColumns이 안 먹음)
                ExcelRange columnCells = ws.Cells[6, 8, table.Rows.Count + 5, 8];
                columnCells.Style.HorizontalAlignment = ExcelHorizontalAlignment.Left;

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

    protected void btnExcelExport_Click(object sender, EventArgs e)
    {
        this.txtSearchSdate.Text = Request[this.txtSearchSdate.UniqueID];
        this.txtSearchEdate.Text = Request[this.txtSearchEdate.UniqueID];
        string todateB = this.txtSearchSdate.Text;
        string todateE = this.txtSearchEdate.Text;

        ExcelService excelService = new ExcelService();

        var paramList = new Dictionary<string, object>
        {
            {"nvar_P_SVID_USER", Svid_User},
            {"nvar_P_STARTDATE", todateB},
            {"nvar_P_ENDDATE", todateE},
            {"nvar_P_SVID_COMPANYNO", UserInfoObject.UserInfo.Company_No},
            {"nvar_P_SALECOMPANY_NAME", txtSaleCompName.Text.Trim()},
            {"nvar_P_BUYERCOMPANY_NAME", txtBuyerCompName.Text.Trim()},
            {"nvar_P_PAYWAY", ddlSelectPayway.SelectedValue}
        };
        var table = excelService.GetAdminProfitListExcel(paramList);

        table.Columns.Add(new DataColumn("TOTALJUNG", typeof(decimal)));

        for (int i = 0; i < table.Rows.Count; i++)
        {
            //구매자(요청자)
            table.Rows[i]["BUYERNAME"] = table.Rows[i]["BUYERNAME"];
            //string reqBuyerNm = table.Rows[i]["REQUESTBUYERCOMPANY_NAME"].AsText();
            //if (!string.IsNullOrWhiteSpace(reqBuyerNm))
            //{
            //    table.Rows[i]["BUYERNAME"] = table.Rows[i]["BUYERNAME"] + "\n(" + table.Rows[i]["REQUESTBUYERCOMPANY_NAME"] + ")";
            //}

            //상품명(수량)
            table.Rows[i]["GOODSNAME"] = table.Rows[i]["GOODSNAME"] + "\n(" + table.Rows[i]["GOODSQTY"] + "개)";

            //배송완료현황(완료상품수/총 상품수)
            table.Rows[i]["DELIVERYSTATUS"] = table.Rows[i]["DELIVERYQTY"] + " / " + table.Rows[i]["CNTQTY"];


            //대금정산
            decimal totalJung = table.Rows[i]["SALEAMT"].AsDecimal() - table.Rows[i]["CUSTAMT"].AsDecimal() - table.Rows[i]["PGJUNG"].AsDecimal() - table.Rows[i]["DELIVERYJUNG"].AsDecimal() - table.Rows[i]["SUPPLYJUNG"].AsDecimal() - table.Rows[i]["BILLJUNG"].AsDecimal();
            table.Rows[i]["TOTALJUNG"] = totalJung;
        }

        //table.Columns.Remove("REQUESTBUYERCOMPANY_NAME");
        table.Columns.Remove("GOODSQTY");
        table.Columns.Remove("PAYWAY");
        table.Columns.Remove("CNTQTY");
        table.Columns.Remove("DELIVERYQTY");
        table.Columns.Remove("ERRPRICEVAT");
        table.Columns.Remove("ERRCODE");

        //string[] headerName = { "번호", "입금날짜", "주문일자", "주문번호", "구매사", "구매자\n(요청자)", "판매사", "상품명\n(수량)", "배송완료현황\n(완료 상품수/총 상품수)", "결제수단", "구매사\n매출정산", "판매사\n매출정산", "플랫폼\n이용수수료", "배송비\n수수료", "세금계산서\n수수료정산", "PG수수료정산\n(취소 수수료)", "대금정산" };
        string[] headerName = { "번호", "입금날짜", "주문일자", "주문번호", "구매사", "구매자", "판매사", "상품명\n(수량)", "배송완료현황\n(완료 상품수/총 상품수)", "결제수단", "구매사\n매출정산", "판매사\n매출정산", "플랫폼\n이용수수료", "배송비\n수수료", "세금계산서\n수수료정산", "PG수수료정산\n(취소 수수료)", "대금정산" };
        var fileName = Server.UrlEncode(AdminId + "_판매사_매출내역");
        //ExeclExport.ExportExcel(fileName, "xlsx", table);
        ExportExcel(fileName, headerName, table);
    }
}